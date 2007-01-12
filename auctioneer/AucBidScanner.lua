--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$

	BidScanner - manages searching for auctions to bid on

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
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit licence to use this AddOn with these facilities
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]
Auctioneer_RegisterRevision("$URL$", "$Rev$")

-------------------------------------------------------------------------------
-- Function Imports
-------------------------------------------------------------------------------
local chatPrint = Auctioneer.Util.ChatPrint;
local emptyHookFunction = Auctioneer.ScanManager.EmptyHookFunction;

-------------------------------------------------------------------------------
-- Function Prototypes
-------------------------------------------------------------------------------
local load;
local getBidRequestCount
local bidByAuctionId;
local buyoutByAuctionId;
local placeBidByAuction;
local addRequestToQueue;
local removeRequestFromQueue;
local sendQuery;
local queryCompleteCallback;
local placeBid;
local bidCompleteCallback;
local emptyHookFunction;
local scanStarted;
local scanEnded;
local isScanning;
local debugPrint;

-------------------------------------------------------------------------------
-- Data Members
-------------------------------------------------------------------------------
local RequestState = {
	WaitingToQuery = "WaitingToQuery";
	WaitingForQueryResult = "WaitingForQueryResult";
	WaitingToBid = "WaitingToBid";
	WaitingForBidResult = "WaitingForBidResult";
	Abort = "Abort";
	Done = "Done";
};

local FilterResult = {
	Bid = "Bid";
	Skip = "Skip";
	Done = "Done";
};

-- Queue of bid requests.
local BidRequestQueue = {};

-- Flag that indicates if scanning has begun.
local Scanning = false;

-- The original OnEvent and Update methods for AuctionFrameBrowse. These are
-- overridden when a scan is in progress so that the UI doesn't update.
local Original_AuctionFrameBrowse_OnEvent = nil;
local Original_AuctionFrameBrowse_Update = nil;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function load()
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AucBidScanner_OnUpdate()
	local request = BidRequestQueue[1];
	if (request) then
		if (request.state == RequestState.WaitingToQuery and Auctioneer.QueryManager.CanSendAuctionQuery()) then
			if (not Scanning) then
				scanStarted();
			end
			sendQuery(request);
		elseif (request.state == RequestState.WaitingToBid and not Auctioneer.BidManager.IsBidInProgress()) then
			placeBid(request);
		end
	elseif (Scanning) then
		scanEnded();
	end
end

-------------------------------------------------------------------------------
-- Gets the number of pending bid requests.
-------------------------------------------------------------------------------
function getBidRequestCount()
	return #BidRequestQueue;
end

-------------------------------------------------------------------------------
-- Searches for the specified auction and places a minimum bid on it if the
-- current bid has not changed from the snasphot.
-------------------------------------------------------------------------------
function bidByAuctionId(auctionId, callbackFunc)
	local auctionInSnapshot = Auctioneer.SnapshotDB.GetAuctionById(nil, auctionId);
	if (auctionInSnapshot) then
		placeBidByAuction(auctionInSnapshot, nil, callbackFunc);
	else
		debugPrint("bidByAuctionId() - Invalid auctionId");
		Auctioneer.Util.Debug("AucBidScanner", AUC_INFO, "Invalid auctionId", "Found invalid auctionId ", auctionId, " in bidByAuctionId")
	end
end

-------------------------------------------------------------------------------
-- Searches for the specified auction and buys it out.
-------------------------------------------------------------------------------
function buyoutByAuctionId(auctionId, callbackFunc)
	local auctionInSnapshot = Auctioneer.SnapshotDB.GetAuctionById(nil, auctionId);
	if (auctionInSnapshot and auctionInSnapshot.buyoutPrice > 0) then
		placeBidByAuction(auctionInSnapshot, auctionInSnapshot.buyoutPrice, callbackFunc);
	else
		debugPrint("buyoutByAuctionId() - Invalid auctionId");
		Auctioneer.Util.Debug("AucBidScanner", AUC_INFO, "Invalid auctionId", "Found invalid auctionId ", auctionId, " in buyoutByAuctionId")
	end
end

-------------------------------------------------------------------------------
-- Searches for the specified auction and places a bid on it if the current
-- bid has not changed.
-------------------------------------------------------------------------------
function placeBidByAuction(auctionInSnapshot, bidAmount, callbackFunc)
	local itemKey = Auctioneer.ItemDB.CreateItemKeyFromAuction(auctionInSnapshot);
	local itemInfo = Auctioneer.ItemDB.GetItemInfo(itemKey);
	if (itemInfo) then
		-- Construct a query that will find this item.
		local query = {
			name = itemInfo.name;
			page = 0;
		};

		-- Construct a filter function that will only match the auction in
		-- question.
		local filterFunc =
			function (request, auction)
				-- Check if this is the auction we are looking for.
				if (auction.auctionId ~= auctionInSnapshot.auctionId) then
					return FilterResult.Skip;
				end
				debugPrint("Found auction with matching id");
				Auctioneer.Util.Debug("AucBidScanner", AUC_INFO, "Found matching auction", "Found matching auction ", auction.auctionId, " in placeBidByAuction")

				-- If we are bidding, perform checks to see if we should still
				-- bid on it.
				if (bidAmount or bidAmount ~= auction.buyoutPrice) then
					-- Check that the current bid is the same.
					if (request.currentBid ~= Auctioneer.SnapshotDB.GetCurrentBid(auction)) then
						chatPrint(ERR_AUCTION_HIGHER_BID);
						debugPrint(ERR_AUCTION_HIGHER_BID);
						Auctioneer.Util.Debug("AucBidScanner", AUC_NOTICE, "Found higher bid", "Matching auction now has a higher bid ", auction.buyoutPrice, " than your bid of ", bidAmount, " in placeBidByAuction")
						return FilterResult.Abort;
					end

					-- Check that we aren't already the high bidder.
					if (auction.highBidder) then
						-- %todo: localize
						chatPrint("Already the high bidder");
						debugPrint("Already the high bidder");
						Auctioneer.Util.Debug("AucBidScanner", AUC_NOTICE, "Found player's bid", "Matching auction has a player's bid already in placeBidByAuction")
						return FilterResult.Abort;
					end
				end

				-- We've found ourselves an auction to bid on! Calculate
				-- what the bid should be.
				local bid;
				if (bidAmount) then
					bid = bidAmount; -- buyout
				elseif (auction.bidAmount == 0) then
					bid = auction.minBid; -- first bid
				else
					bid = auction.bidAmount + auction.minIncrement;
				end
				debugPrint("Bidding on auction: "..bid);
				Auctioneer.Util.Debug("AucBidScanner", AUC_INFO, "Bidding on Auction", "Bidding ", bid, " on auction in placeBidByAuction")
				return FilterResult.Bid, bid;
			end

		-- Create the request and add it to the queue.
		local request = {
			query = query;
			name = itemInfo.name;
			count = auctionInSnapshot.count;
			currentBid = Auctioneer.SnapshotDB.GetCurrentBid(auctionInSnapshot);
			filterFunc = filterFunc;
			callbackFunc = callbackFunc;
			maxBidAttempts = 1;
		};
		addRequestToQueue(request);
	else
		debugPrint("placeBidByAuction() - No information for item "..itemKey);
		Auctioneer.Util.Debug("AucBidScanner", AUC_NOTICE, "No Information", "Unable to find information on ", itemKey, " in placeBidByAuction")
	end
end

-------------------------------------------------------------------------------
-- Adds the search request to the back of the queue.
-------------------------------------------------------------------------------
function addRequestToQueue(request)
	request.state = RequestState.WaitingToQuery;
	request.bidAttempts = 0;
	request.bidCount = 0;
	request.currentPage = 0;
	request.currentIndex = 1;
	request.isBuyout = false;
	table.insert(BidRequestQueue, request);
	Auctioneer.Util.Debug("AucBidScanner", AUC_DEBUG, "Adding request to queue", "Adding request ", request, " in addRequestToQueue")
	Auctioneer.EventManager.FireEvent("AUCTIONEER_BID_SCAN_QUEUED", request);
	debugPrint("Added request to back of queue");
end

-------------------------------------------------------------------------------
-- Removes the search request at the head of the queue.
-------------------------------------------------------------------------------
function removeRequestFromQueue()
	if (#BidRequestQueue > 0) then
		-- Remove the request from the queue.
		local request = BidRequestQueue[1];
		table.remove(BidRequestQueue, 1);
		Auctioneer.Util.Debug("AucBidScanner", AUC_DEBUG, "Removing request from queue", "Removing request ", request, " in addRequestToQueue")
		Auctioneer.EventManager.FireEvent("AUCTIONEER_BID_SCAN_COMPLETE", request);
		debugPrint("Removed request from queue");

		-- Inform the user if no auctions were found.
		if (request.state == RequestState.Done and request.bidCount == 0) then
			local output = _AUCT('FrmtNoAuctionsFound'):format(request.name, request.count);
			chatPrint(output);
		end

		-- If a callback function was provided, call it!
		if (request.callbackFunc) then
			request.callbackFunc(request.auctionId);
		end
	end
end

-------------------------------------------------------------------------------
-- Sends the next query
-------------------------------------------------------------------------------
function sendQuery(request)
	request.state = RequestState.WaitingForQueryResult;
	local query = request.query;
	Auctioneer.QueryManager.QueryAuctionItems(
		query.name,
		query.minLevel,
		query.maxLevel,
		query.invTypeIndex,
		query.classIndex,
		query.subclassIndex,
		request.currentPage,
		query.isUsable,
		query.qualityIndex,
		10,
		3,
		queryCompleteCallback
	);
end

-------------------------------------------------------------------------------
-- Called when our query request completes.
-------------------------------------------------------------------------------
function queryCompleteCallback(query, result)
	local request = BidRequestQueue[1];
	if (request and request.state == RequestState.WaitingForQueryResult) then
		request.state = RequestState.WaitingToBid;
	else
		debugPrint("WARNING: Received query complete callback in unexpected state");
		Auctioneer.Util.Debug("AucBidScanner", AUC_WARNING, "Query unexpected", "Query complete callback unexpected in current state: ", request, " in queryCompleteCallback")
	end
end

-------------------------------------------------------------------------------
-- Searches the current page for an auction matching the first request in
-- the request queue. If it finds the auction, it carries out the specified
-- action (bid/buyout).
-------------------------------------------------------------------------------
function placeBid(request)
	-- Iterate through each item on the page, searching for a match
	local lastIndexOnPage, totalAuctions = GetNumAuctionItems("list");
	debugPrint("Processing page", request.currentPage, "starting at index", request.currentIndex, "(", lastIndexOnPage, "on page;", totalAuctions, "in total)");
	Auctioneer.Util.Debug("AucBidScanner", AUC_DEBUG, "Processing Page", "Processing page", request.currentPage, "starting at index", request.currentIndex, "(", lastIndexOnPage, "on page;", totalAuctions, "in total) in placeBid")
	for indexOnPage = request.currentIndex, lastIndexOnPage do
		local auction = Auctioneer.QueryManager.GetAuctionByIndex("list", indexOnPage);
		if (Auctioneer.QueryManager.IsAuctionValid(auction)) then
			auction.auctionId = Auctioneer.QueryManager.GetAuctionId("list", indexOnPage);
			if (auction.auctionId) then
				local result, bidAmount = request.filterFunc(request, auction);
				if (result == FilterResult.Bid) then
					-- Update the starting point for this page.
					request.currentIndex = indexOnPage;
					request.bidAttempts = request.bidAttempts + 1;
					if (auction.buyout == bidAmount) then
						request.isBuyout = true;
					end
					request.state = RequestState.WaitingForBidResult;

					-- Place the bid! This MUST be done last since the response
					-- can be received during the call to PlaceAuctionBid.
					local itemKey = Auctioneer.ItemDB.CreateItemKeyFromAuction(auction);
					local name = Auctioneer.ItemDB.GetItemName(itemKey);
					debugPrint("Placing bid on", name, "at", bidAmount, "(index ", indexOnPage, ")");
					Auctioneer.Util.Debug("AucBidScanner", AUC_DEBUG, "Placing bid", "Placing bid on ", name, " at ", bidAmount, " (index ", indexOnPage, ") in placeBid")
					Auctioneer.BidManager.PlaceAuctionBid("list", indexOnPage, bidAmount, bidCompleteCallback);

				elseif (result == FilterResult.Abort) then
					-- Complete the request.
					request.state = RequestState.Abort;
					removeRequestFromQueue();
				end
			else
				debugPrint("Skipping auction due to no auction id (index", indexOnPage, ")");
				Auctioneer.Util.Debug("AucBidScanner", AUC_NOTICE, "Skipping bid", "Skipping bid on item (index ", indexOnPage, ") in placeBid")
			end
		end
	end

	-- If we are still waiting to bid then we reached finished the current page.
	if (request.state == RequestState.WaitingToBid) then
		-- When an item is bought out on the page, the item is not replaced
		-- with an item from a subsequent page. Nor is the item removed from
		-- the total count. Thus if there were 7 items total before the buyout,
		-- GetNumAuctionItems() will report 6 items on the page and but still
		-- 7 total after the buyout.
		if (lastIndexOnPage == 0 or
			request.currentPage * NUM_AUCTION_ITEMS_PER_PAGE + lastIndexOnPage == totalAuctions) then
			-- Reached the end of the line for this item, remove it from the queue
			request.currentIndex = lastIndexOnPage + 1;
			request.state = RequestState.Done;
			removeRequestFromQueue();

		else
			-- Continue looking for items on the next page.
			request.currentPage = request.currentPage + 1;
			request.currentIndex = 1;
			request.state = RequestState.WaitingToQuery;
		end
	end
end

-------------------------------------------------------------------------------
-- Called when our bid request completes.
-------------------------------------------------------------------------------
function bidCompleteCallback(auction, result)
	local request = BidRequestQueue[1];
	if (request and request.state == RequestState.WaitingForBidResult) then
		-- Check if the bid succeeded.
		if (result == BidResultCodes.BidAccepted) then
			-- Update the bid count.
			request.bidCount = request.bidCount + 1;

			-- Report the completed bid.
			if (request.isBuyout) then
				local output = _AUCT('FrmtBoughtAuction'):format(request.name, request.count);
				chatPrint(output);

			else
				local output = _AUCT('FrmtBidAuction'):format(request.name, request.count);
				chatPrint(output);
			end

			-- Increment the request's current index if the auction was not bought.
			if (not request.isBuyout) then
				request.currentIndex = request.currentIndex + 1;
				debugPrint("Incrementing the request's currentIndex to", request.currentIndex);
				Auctioneer.Util.Debug("AucBidScanner", AUC_DEBUG, "Incrementing request index", "Incrementing the request's currentIndex to ", request.currentIndex, " due to no buyout in bidCompleteCallback")
			end
		else
			-- Skip over the auction we failed to bid on.
			request.currentIndex = request.currentIndex + 1;
			debugPrint("Incrementing the request's currentIndex to", request.currentIndex);
			Auctioneer.Util.Debug("AucBidScanner", AUC_DEBUG, "Incrementing request index", "Incrementing the request's currentIndex to ", request.currentIndex, " due to bid not accepted in bidCompleteCallback")
		end

		-- Get ready to send the next bid if we haven't reached the limit.
		if (request.maxBids and request.bidCount == request.maxBids) then
			removeRequestFromQueue();
		elseif (request.maxBidAttempts and request.bidAttempts == request.maxBidAttempts) then
			removeRequestFromQueue();
		else
			request.isBuyout = false;
			request.state = RequestState.WaitingToBid;
		end
	else
		debugPrint("WARNING: Received bid complete callback in unexpected state");
		Auctioneer.Util.Debug("AucBidScanner", AUC_WARNING, "Bid complete unexpected", "Bid completet callback unexpected in current state: ", request, " in bidCompleteCallback")
	end
end

-------------------------------------------------------------------------------
-- Called when a scan starts.
-------------------------------------------------------------------------------

function scanStarted()
	-- Hide the results UI
	BrowseNoResultsText:Show();
	BrowseNoResultsText:SetText(_AUCT('UiProcessingBidRequests'));
	for iButton = 1, NUM_BROWSE_TO_DISPLAY do
		button = getglobal("BrowseButton"..iButton);
		button:Hide();
	end
	BrowsePrevPageButton:Hide();
	BrowseNextPageButton:Hide();
	BrowseSearchCountText:Hide();
	BrowseBidButton:Disable();
	BrowseBuyoutButton:Disable();

	-- Don't allow AuctionFrameBrowse updates during a scan.
	Stubby.RegisterFunctionHook("AuctionFrameBrowse_OnEvent", -200, emptyHookFunction)
	Stubby.RegisterFunctionHook("AuctionFrameBrowse_Update", -200, emptyHookFunction)

	-- Bid scanning has begun!
	Scanning = true;
	Auctioneer.Scanning.IsScanningRequested = true;
end

-------------------------------------------------------------------------------
-- Called when a scan ends.
-------------------------------------------------------------------------------
function scanEnded()
	-- Bid scanning has ended!
	Scanning = false;
	Auctioneer.Scanning.IsScanningRequested = false;

	-- We can allow AuctionFrameBrowse updates once again.
	Stubby.UnregisterFunctionHook("Original_AuctionFrameBrowse_OnEvent", emptyHookFunction)
	Stubby.UnregisterFunctionHook("Original_AuctionFrameBrowse_Update", emptyHookFunction)

	-- Update the Browse UI.
	BrowseNoResultsText:Hide();
	BrowseNoResultsText:SetText("");
	AuctionFrameBrowse_Update();
end

-------------------------------------------------------------------------------
-- Checks if a bid scan is in progress.
-------------------------------------------------------------------------------
function isScanning()
	return Scanning;
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--local debug = true;
function debugPrint(...)
	if debug then EnhTooltip.DebugPrint("[Auc.BidScanner]", ...); end
end

-------------------------------------------------------------------------------
-- Public API
-------------------------------------------------------------------------------
Auctioneer.BidScanner =
{
	Load = load;
	GetBidRequestCount = getBidRequestCount;
	BidByAuctionId = bidByAuctionId;
	BuyoutByAuctionId = buyoutByAuctionId;
	IsScanning = isScanning;
}

