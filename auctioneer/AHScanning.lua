-- AHScanning
-- Functions for scanning the AH
-- Thanks to Telo for the LootLink code from which this was based.

Auctioneer_isScanningRequested = false;
local lCurrentAuctionPage;

AUCTIONEER_AUCTION_SCAN_START = "Auctioneer: scanning page 1...";
AUCTIONEER_AUCTION_PAGE_N = "Auctioneer: scanning page %d of %d...";
AUCTIONEER_AUCTION_SCAN_DONE = "Auctioneer: auction scanning finished";

-- function hooks
local lOriginal_CanSendAuctionQuery;
local lOriginal_AuctionFrameBrowse_OnEvent;


function Auctioneer_ScanAuction()
	local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
	local auctionid;

	if( numBatchAuctions > 0 ) then
		for auctionid = 1, numBatchAuctions do        
            Auctioneer_Event_ScanAuction(lCurrentAuctionPage, auctionid);
		end
	end
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
    
    Auctioneer_isScanningRequested = false;
end


local function Auctioneer_AuctionNextQuery()
	if( lCurrentAuctionPage ) then
		local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
		local maxPages = floor(totalAuctions / NUM_AUCTION_ITEMS_PER_PAGE);
		
		if( lCurrentAuctionPage < maxPages ) then
			lCurrentAuctionPage = lCurrentAuctionPage + 1;
			BrowseNoResultsText:SetText(format(AUCTIONEER_AUCTION_PAGE_N, lCurrentAuctionPage + 1, maxPages + 1));
		else
			Auctioneer_StopAuctionScan();
			if( totalAuctions > 0 ) then
				BrowseNoResultsText:SetText(AUCTIONEER_AUCTION_SCAN_DONE);
                Auctioneer_Event_FinishedAuctionScan();
			end
			return;
		end
	else
		lCurrentAuctionPage = 0;
		BrowseNoResultsText:SetText(AUCTIONEER_AUCTION_SCAN_START);
	end
	QueryAuctionItems("", "", "", nil, nil, nil, lCurrentAuctionPage, nil, nil);
	Auctioneer_Event_AuctionQuery(lCurrentAuctionPage);
end


local function Auctioneer_CanSendAuctionQuery()
	local value = lOriginal_CanSendAuctionQuery();
	if( value ) then
		Auctioneer_AuctionNextQuery();
		return nil;
	end
	return value;
end

function Auctioneer_AuctionFrameBrowse_OnEvent()
	-- Intentionally empty; don't allow the auction UI to update while we're scanning
end

function Auctioneer_StartAuctionScan()
	-- Start with the first page
	lCurrentAuctionPage = nil;

	-- Hook the functions that we need for the scan
	if( not lOriginal_CanSendAuctionQuery ) then
		lOriginal_CanSendAuctionQuery = CanSendAuctionQuery;
		CanSendAuctionQuery = Auctioneer_CanSendAuctionQuery;
	end
	if( not lOriginal_AuctionFrameBrowse_OnEvent ) then
		lOriginal_AuctionFrameBrowse_OnEvent = AuctionFrameBrowse_OnEvent;
		AuctionFrameBrowse_OnEvent = Auctioneer_AuctionFrameBrowse_OnEvent;
	end
	
	Auctioneer_Event_StartAuctionScan();
end


function Auctioneer_RequestAuctionScan()
    Auctioneer_isScanningRequested = true;
    if( AuctionFrame:IsVisible() ) then
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
        Auctioneer_ChatPrint("Auctioneer will perform a full auction scan the next time you talk to an auctioneer.");
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