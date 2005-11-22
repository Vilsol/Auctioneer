--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: <%version%>
	Revision: $Id$

	AHScanning
	Functions for scanning the AH
	Thanks to Telo for the LootLink code from which this was based.
	
	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GLP.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
]]

Auctioneer_isScanningRequested = false;
local lCurrentAuctionPage;
local lMajorAuctionCategories;
local lCurrentCategoryIndex;
local lIsPageScanned;
local lScanInProgress;
local lFullScan;
local lScanStartedAt;
local lPageStartedAt;

-- function hooks
local lOriginal_CanSendAuctionQuery;
local lOriginal_AuctionFrameBrowse_OnEvent;
local lOriginal_AuctionFrameBrowse_Update;

-- TODO: If all categories are selected, then we should do a complete scan rather than a one-by-one scan.

-- get the next category index to based on what categories have been configured to be scanned
local function nextIndex()
	if (lCurrentCategoryIndex == nil) then lCurrentCategoryIndex = 0 end
	for i = lCurrentCategoryIndex + 1, table.getn(lMajorAuctionCategories) do
		if tostring(Auctioneer_GetFilterVal("scan-class"..i)) == "on" then
			return i;
		end
	end

	return nil;
end

function Auctioneer_StopAuctionScan()
	Auctioneer_Event_StopAuctionScan();
	
	-- Unhook the scanning functions
	if( lOriginal_CanSendAuctionQuery ) then
		CanSendAuctionQuery = lOriginal_CanSendAuctionQuery;
		lOriginal_CanSendAuctionQuery = nil;
	end
	
	if( lOriginal_AuctionFrameBrowse_OnEvent ) then
		AuctionFrameBrowse_OnEvent = lOriginal_AuctionFrameBrowse_OnEvent;
		lOriginal_AuctionFrameBrowse_OnEvent = nil;
	end
	
	if( lOriginal_AuctionFrameBrowse_Update ) then
		AuctionFrameBrowse_Update = lOriginal_AuctionFrameBrowse_Update;
		lOriginal_AuctionFrameBrowse_Update = nil;
	end
	
	Auctioneer_isScanningRequested = false;
	lScanInProgress = false;
	lCurrentCategoryIndex = 0;
	lPageStartedAt = nil;
	
	-- Unprotect AuctionFrame if we should
	if (Auctioneer_GetFilterVal('protect-window') == 1) then
		Auctioneer_ProtectAuctionFrame(false);
	end
end

local function Auctioneer_AuctionSubmitQuery()
	if not lCurrentAuctionPage or lCurrentAuctionPage == 0 then
		if not lCurrentAuctionPage then lCurrentAuctionPage = 0 end
		if lFullScan then
			BrowseNoResultsText:SetText(string.format(_AUCT('AuctionScanStart'), _AUCT('TextAuction')));
		else
			BrowseNoResultsText:SetText(string.format(_AUCT('AuctionScanStart'), lMajorAuctionCategories[lCurrentCategoryIndex]));
		end
	end
	if (lFullScan) then
		QueryAuctionItems("", "", "", nil, nil, nil, lCurrentAuctionPage, nil, nil);
	else
		QueryAuctionItems("", "", "", nil, lCurrentCategoryIndex, nil, lCurrentAuctionPage, nil, nil);
	end
	lPageStartedAt = time();

	lIsPageScanned = false;
	Auctioneer_Event_AuctionQuery(lCurrentAuctionPage);
end

local function Auctioneer_AuctionNextQuery()
	lCheckPage = nil;
	if lCurrentAuctionPage then
		local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
		local maxPages = floor(totalAuctions / NUM_AUCTION_ITEMS_PER_PAGE);

		local auctionsPerSecond = ( lTotalAuctionsScannedCount / ( GetTime() - lScanStartedAt ) );
		local auctionETA = ( ( totalAuctions - lTotalAuctionsScannedCount ) / auctionsPerSecond );
		auctionsPerSecond = floor( auctionsPerSecond * 100 ) / 100;
		if ( type(auctionsPerSecond) ~= "number" ) then
			auctionsPerSecond = "";
		else
			auctionsPerSecond = tostring(auctionsPerSecond);
		end
		local ETAString = SecondsToTime(auctionETA);

		if( lCurrentAuctionPage < maxPages ) then
			lPageStartedAt = time();
			lCurrentAuctionPage = lCurrentAuctionPage + 1;
			if lFullScan then
				BrowseNoResultsText:SetText(string.format(_AUCT('AuctionPageN'), _AUCT('TextAuction'), lCurrentAuctionPage + 1, maxPages + 1, auctionsPerSecond, ETAString));
			else
				BrowseNoResultsText:SetText(string.format(_AUCT('AuctionPageN'), lMajorAuctionCategories[lCurrentCategoryIndex],lCurrentAuctionPage + 1, maxPages + 1, auctionsPerSecond, ETAString));
			end
		elseif nextIndex() then
			lPageStartedAt = time();
			lCurrentCategoryIndex = nextIndex();
			lCurrentAuctionPage = 0;
		else
			Auctioneer_StopAuctionScan();
			if( totalAuctions > 0 ) then
				BrowseNoResultsText:SetText(_AUCT('AuctionScanDone'));
				Auctioneer_Event_FinishedAuctionScan();
			end
			return;
		end
	end
	Auctioneer_AuctionSubmitQuery();
end

local lCheckStartTime = nil;
local lCheckPage = nil;
local lCheckSize = nil;
local lCheckPos = nil;
function Auctioneer_CheckCompleteScan()
	if (lCheckPage ~= lCurrentAuctionPage) or (not lCheckSize) or (not lCheckPos) then
		lCheckSize = GetNumAuctionItems("list");
		lCheckPage = lCurrentAuctionPage;
		lCheckPos = 1;
		lCheckStartTime = time()
	end

	if lCheckPage and lCheckSize > 0 then
		if (time() - lCheckStartTime > 10) then 
			-- Sometimes they never return an owner.
			return true
		end
		for auctionid = lCheckPos, lCheckSize do
			lCheckPos = auctionid;
			local _,_,_,_,_,_,_,_,_,_,_, owner = GetAuctionItemInfo("list", auctionid);
			if (owner == nil) then return false end
		end
	end
	return true;
end

function Auctioneer_ScanAuction()
	local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
	local auctionid;

	if( numBatchAuctions > 0 ) then
		for auctionid = 1, numBatchAuctions do
			Auctioneer_Event_ScanAuction(lCurrentAuctionPage, auctionid, lCurrentCategoryIndex);
		end
	end

	lIsPageScanned = true;
end

local function Auctioneer_CanSendAuctionQuery()
	local value = lOriginal_CanSendAuctionQuery();
	if (value and lIsPageScanned) then
		Auctioneer_AuctionNextQuery();
		return nil;
	end
	if (lPageStartedAt) then
		local pageElapsed = time() - lPageStartedAt;
		if (pageElapsed > 20) then
			if (Auctioneer_GetFilter('show-warning')) then
				Auctioneer_ChatPrint(string.format(_AUCT('AuctionScanRedo'), 20));
			end
			Auctioneer_AuctionSubmitQuery();
			return nil;
		end
		return false;
	end
end

function Auctioneer_AuctionFrameBrowse_OnEvent()
	-- Intentionally empty; don't allow the auction UI to update while we're scanning
end

function Auctioneer_AuctionFrameBrowse_Update()
	-- Intentionally empty; don't allow the auction UI to update while we're scanning
end



function Auctioneer_StartAuctionScan()
	lMajorAuctionCategories = {GetAuctionItemClasses()};

	lFullScan = true;
	for i = 1, table.getn(lMajorAuctionCategories) do
		if tostring(Auctioneer_GetFilterVal("scan-class"..i)) ~= "on" then
			lFullScan = false;
		end
	end

	if (lFullScan) then
		lCurrentCategoryIndex = table.getn(lMajorAuctionCategories);
	else
		-- first make sure that we have at least one category to scan
		lCurrentCategoryIndex = nextIndex();
		if not lCurrentCategoryIndex then
			lCurrentCategoryIndex = 0;
			Auctioneer_ChatPrint(_AUCT('AuctionScanNocat'));
			return;
		end
	end

	-- Start with the first page
	lCurrentAuctionPage = nil;
	lScanInProgress = true;

	-- Hook the functions that we need for the scan
	if( not lOriginal_CanSendAuctionQuery ) then
		lOriginal_CanSendAuctionQuery = CanSendAuctionQuery;
		CanSendAuctionQuery = Auctioneer_CanSendAuctionQuery;
	end
	
	if( not lOriginal_AuctionFrameBrowse_OnEvent ) then
		lOriginal_AuctionFrameBrowse_OnEvent = AuctionFrameBrowse_OnEvent;
		AuctionFrameBrowse_OnEvent = Auctioneer_AuctionFrameBrowse_OnEvent;
	end
	
	if( not lOriginal_AuctionFrameBrowse_Update ) then
		lOriginal_AuctionFrameBrowse_Update = AuctionFrameBrowse_Update;
		AuctionFrameBrowse_Update = Auctioneer_AuctionFrameBrowse_Update;
	end
	
	Auctioneer_Event_StartAuctionScan();

	lScanStartedAt = GetTime();
	Auctioneer_AuctionNextQuery();
end

function Auctioneer_CanScan()
	if (lScanInProgress) then
		return false;
	end
	if (not CanSendAuctionQuery()) then
		return false;
	end
	return true;
end

function Auctioneer_RequestAuctionScan()
	Auctioneer_isScanningRequested = true;
	if (AuctionFrame and AuctionFrame:IsVisible()) then
		local iButton;
		local button;
	
		-- Hide the UI from any current results, show the no results text so we can use it
		BrowseNoResultsText:Show();
		for iButton = 1, NUM_BROWSE_TO_DISPLAY do
			button = getglobal("BrowseButton"..iButton);
			button:Hide();
		end
		BrowsePrevPageButton:Hide();
		BrowseNextPageButton:Hide();
		BrowseSearchCountText:Hide();
	
		Auctioneer_StartAuctionScan();
	else
		Auctioneer_ChatPrint(_AUCT('AuctionScanNexttime'));
	end
end


-- Hook this function to be called whenever an auction entry is successfully inspected
function Auctioneer_Event_ScanAuction(auctionpage, auctionid)
	-- auctionpage: the page number this item was found on
	-- auctionid: the id of the inspected item
end

-- Hook this function to be called whenever Auctioneer starts an auction scan
function Auctioneer_Event_StartAuctionScan()
end

-- Hook this function to be called whenever Auctioneer stops an auction scan
function Auctioneer_Event_StopAuctionScan()
end

-- Hook this function to be called whenever Auctioneer completes a full auction scan
function Auctioneer_Event_FinishedAuctionScan()
end

-- Hook this function to be called whenever Auctioneer sends a new auction query
function Auctioneer_Event_AuctionQuery(auctionpage)
	-- auctionpage: the page number for the query that was just sent
end
