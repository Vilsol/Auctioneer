-- Auctioneer
AUCTIONEER_VERSION="<%version%>";
-- Revision: $Id$
-- Original version written by Norganna.
-- Contributors: Araband
--
-- This is an addon for World of Warcraft that adds statistical history to the auction data that is collected
-- when the auction is scanned, so that you can easily determine what price
-- you will be able to sell an item for at auction or at a vendor whenever you
-- mouse-over an item in the game
--
--
if (AUCTIONEER_VERSION == "<".."%version%>") then
	AUCTIONEER_VERSION = "3.DEV";
end

local MAX_ALLOWED_FORMAT_INT = 2000000000; -- numbers much greater than this overflow when using format("%d")

-- If non-nil, check for appearance of GameTooltip for adding information
local lAuctioneerCheckTooltip;

-- Timer for frequency of tooltip checks
local lAuctioneerCheckTimer = 0;

-- Current Tooltip frame
local lAuctioneerTooltip = nil;

-- Counter to count the total number of auctions scanned
local lTotalAuctionsScannedCount = 0;
local lNewAuctionsCount = 0;
local lOldAuctionsCount = 0;
local lDefunctAuctionsCount = 0;

-- temp table that is copied into AHSnapshotItemPrices only when a scan fully completes
local lSnapshotItemPrices = {};

-- the maximum number of elements we store in our buyout prices history table 
local lMaxBuyoutHistorySize = 35;

-- min median buyout price for an item to show up in the list of items below median
local MIN_PROFIT_MARGIN = 5000;

-- min median buyout price for an item to show up in the list of items below median
local DEFAULT_COMPETE_LESS = 5;

-- min times an item must be seen before it can show up in the list of items below median
local MIN_BUYOUT_SEEN_COUNT = 5;

-- max buyout price for an auction to display as a good deal item
local MAX_BUYOUT_PRICE = 800000;

-- the default percent less, only find auctions that are at a minimum this percent less than the median
local MIN_PERCENT_LESS_THAN_HSP = 60; -- 60% default

-- the minimum profit/price percent that an auction needs to be displayed as a resellable auction
local MIN_PROFIT_PRICE_PERCENT = 30; -- 30% default

-- the minimum percent of bids placed on an item to be considered an "in-demand" enough item to be traded, this is only applied to Weapons and Armor and Recipies
local MIN_BID_PERCENT = 10;

-- categories that the brokers and HSP look at the bid data for
--  1 = weapon
--  2 = armor
--  3 = container
--  4 = dissipatable
--  5 = tradeskillitems
--  6 = projectile
--  7 = quiver
--  8 = recipe
--  9 = reagence
-- 10 = miscellaneous
local BID_BASED_CATEGORIES = {[1]=true, [2]=true, [8]=true, [10]=true}

-- GUI Init Variables (Added by MentalPower)
Auctioneer_GUI_Registered = nil;
Auctioneer_Khaos_Registered = nil;

--[[ SavedVariables --]]
AuctionBids = {};          --Table that stores all your bids
AuctionConfig = {};        --Table that stores config settings
AuctionPrices = {};        --Table that keeps the price history of auctions
Auction_DoneItems = {};    --Table to keep a record of auction items that have been scanned
AHSnapshot = {};           --Table that will hold the Auction scan results
AHSnapshotItemPrices = {}; --Table that holds the lists of prices buy item name, for quick look up

-- Auction time constants
local TIME_LEFT_SHORT = 1;
local TIME_LEFT_MEDIUM = 2;
local TIME_LEFT_LONG = 3;
local TIME_LEFT_VERY_LONG = 4;

-- Item quality constants
local QUALITY_EPIC = 4;
local QUALITY_RARE = 3;
local QUALITY_UNCOMMON = 2;
local QUALITY_COMMON= 1;
local QUALITY_POOR= 0;

-- return the string representation of the given timeLeft constant
local function getTimeLeftString(timeLeft)
	local timeLeftString = "";
	-- TODO: localize these strings
	if timeLeft == TIME_LEFT_SHORT then
		timeLeftString = AUCT_TIME_SHORT;
	elseif timeLeft == TIME_LEFT_MEDIUM then
		timeLeftString = AUCT_TIME_MED;
	elseif timeLeft == TIME_LEFT_LONG then
		timeLeftString = AUCT_TIME_LONG;
	elseif timeLeft == TIME_LEFT_VERY_LONG then
		timeLeftString = AUCT_TIME_VLONG;
	end
	return timeLeftString;
end
Auctioneer_GetTimeLeftString = getTimeLeftString;

function Auctioneer_GetGSC(money)
	local g,s,c = TT_GetGSC(money);
	return g,s,c;
end
function Auctioneer_GetTextGSC(money)
	return TT_GetGSC(money);
end

-- return an empty string if str is nil
function nilSafeString(str)
	if (not str) then str = "" end
	return str;
end

local function colorTextWhite(text)
	if (not text) then text = ""; end
	local COLORING_START = "|cff%s%s|r";
	local WHITE_COLOR = "e6e6e6";
	return format(COLORING_START, WHITE_COLOR, ""..text);
end
Auctioneer_ColorTextWhite = colorTextWhite;

-- used to convert variables that should be numbers but are nil to 0
function nullSafe(val)
	if (val == nil) then return 0; end
	if (0 + val > 0) then return 0 + val; end
	return 0;
end

-- subtracts a percent from a value
local function subtractPercent(value, percentLess)
	return math.floor(value * ((100 - percentLess)/100));
end
local function addPercent(value, percentMore)
	return math.floor(value * ((100 + percentMore)/100));
end

-- returns the integer representation of the percent less value2 is from value1
-- example: value1=10, value2=7,  percentLess=30
local function percentLessThan(value1, value2)
	if nullSafe(value1) > 0 and nullSafe(value2) < nullSafe(value1) then
		return 100 - math.floor((100 * nullSafe(value2))/nullSafe(value1));
	else
		return 0;
	end
end
Auctioneer_PercentLessThan = percentLessThan;

-- returns the median value of a given table one-dimentional table
function getMedian(valuesTable)
	if (not valuesTable or table.getn(valuesTable) == 0) then
		return nil; --make this function nil argument safe
	end

	local tableSize = table.getn(valuesTable);

	if (tableSize == 1) then
		return valuesTable[1];
	end

	local median; -- value to return

	table.sort(valuesTable);

	if (math.mod(tableSize, 2) == 0) then --first handle the case of even table size
		local middleIndex1 = tableSize / 2;
		local middleIndex2 = middleIndex1 + 1;
		local middleValue1 = valuesTable[middleIndex1];
		local middleValue2 = valuesTable[middleIndex2];
		median = (middleValue1 + middleValue2) / 2; --average the two middle values
	else -- the table size is odd
		local trueMiddleIndex = (tableSize + 1) / 2; -- calculate the middle index
		median = valuesTable[trueMiddleIndex];
	end

	return median;
end

local function sanifyAHSnapshot()
	local auctKey = auctionKey();
	if (not AHSnapshot) then
		AHSnapshot = { [auctKey] = {}}; 
	elseif (not AHSnapshot[auctKey]) then
		AHSnapshot[auctKey] = {};
	end
	if (not AHSnapshotItemPrices) then
		AHSnapshotItemPrices = { [auctKey] = {}}; 
	elseif (not AHSnapshotItemPrices[auctKey]) then
		AHSnapshotItemPrices[auctKey] = {};
	end
	return auctKey;
end
Auctioneer_SanifyAHSnapshot = sanifyAHSnapshot;

--this function sets the dirty flag to true for all the auctions in the snapshot
--this is done to indicate that the snapshot is out of date.
local function invalidateAHSnapshot()
	-- invalidate the snapshot
	local auctKey = sanifyAHSnapshot();
	for i,a in AHSnapshot[auctKey] do
		a.dirty = 1;
	end
end

-- called when the auction scan starts
local function Auctioneer_AuctionStart_Hook()
	Auction_DoneItems = {};
	lSnapshotItemPrices = {};
	invalidateAHSnapshot();

	-- make sure AuctionPrices is initialized
	local serverFaction = auctionKey();
	if (AuctionPrices[serverFaction] == nil) then
		AuctionPrices[serverFaction] = {};
	end

	-- reset scan audit counters
	lTotalAuctionsScannedCount = 0;
	lNewAuctionsCount = 0;
	lOldAuctionsCount = 0;
	lDefunctAuctionsCount = 0;
end

-- this is called when an auction scan finishes and is used for clean up
local function Auctioneer_FinishedAuctionScan_Hook()
	-- only remove defunct auctions from snapshot if there was a good amount of auctions scanned.
	local auctKey = sanifyAHSnapshot();

	if lTotalAuctionsScannedCount >= 50 then 
		for i,a in AHSnapshot[auctKey] do
			if (a.dirty == 1) then
				AHSnapshot[auctKey][i] = nil; --clear defunct auctions
				lDefunctAuctionsCount = lDefunctAuctionsCount + 1;
			end
		end
	end

	-- copy the item prices into the Saved item prices table
	AHSnapshotItemPrices[auctKey] = lSnapshotItemPrices;

	local lDiscrepencyCount = lTotalAuctionsScannedCount - (lNewAuctionsCount + lOldAuctionsCount);

	Auctioneer_ChatPrint("Total auctions scanned: "..colorTextWhite(lTotalAuctionsScannedCount));
	Auctioneer_ChatPrint("New auctions scanned: "..colorTextWhite(lNewAuctionsCount));
	Auctioneer_ChatPrint("Previously scanned: "..colorTextWhite(lOldAuctionsCount));
	Auctioneer_ChatPrint("Defunct auctions removed: "..colorTextWhite(lDefunctAuctionsCount));

	if (nullSafe(lDiscrepencyCount) > 0) then
		Auctioneer_ChatPrint("Discrepencies: "..colorTextWhite(lDiscrepencyCount));
	end
end

--returns the auction prices key to get the prices for this server and faction
function auctionKey()
	local serverName = GetCVar("realmName");
	local factionGroup = UnitFactionGroup("player");
	return serverName.."-"..factionGroup;
end

local function oppositeKey()
	local serverName = GetCVar("realmName");
	local factionGroup = UnitFactionGroup("player");
	if (factionGroup == "Alliance") then factionGroup="Horde"; else factionGroup="Alliance"; end
	return serverName.."-"..factionGroup;
end
Auctioneer_OppositeKey = oppositeKey;

function Auctioneer_GetAuctionKey()
	return auctionKey();
end

function Auctioneer_GetOppositeKey()
	return oppositeKey();
end

local function breakLink(link)
	local i,j, itemID, enchant, randomProp, uniqID, name = string.find(link, "|Hitem:(%d+):(%d+):(%d+):(%d+)|h[[]([^]]+)[]]|h");
	return tonumber(itemID or 0), tonumber(randomProp or 0), tonumber(enchant or 0), tonumber(uniqID or 0), name;
end
Auctioneer_BreakLink = breakLink;

local function breakItemKey(itemKey)
	local i,j, itemID, randomProp, enchant = string.find(itemKey, "(%d+):(%d+):(%d+)");
	return tonumber(itemID or 0), tonumber(randomProp or 0), tonumber(enchant or 0);
end
Auctioneer_BreakItemKey = breakItemKey;

-- returns an AuctionPrices item from the table based on an item name
local function getAuctionPriceItem(itemKey, from, name, id)
	local serverFaction;
	local auctionPriceItem;

	if (from ~= nil) then
		serverFaction = from;
	else
		serverFaction = auctionKey();
	end;
	if (AuctionPrices[serverFaction] == nil) then
		AuctionPrices[serverFaction] = {};
	elseif AuctionPrices[serverFaction][itemKey] then
		auctionPriceItem = AuctionPrices[serverFaction][itemKey];
	elseif AuctionPrices[serverFaction][name] then
		auctionPriceItem = AuctionPrices[serverFaction][name];
	elseif AuctionPrices[serverFaction][id] then
		auctionPriceItem = AuctionPrices[serverFaction][id];
	end

	return auctionPriceItem;
end
Auctioneer_GetAuctionPriceItem = getAuctionPriceItem;

-- wrapper for getting AuctionPrices data that is backward compatible with old AuctionPrices keys
local function getAuctionPriceData(itemKey, from, name, id)
	local auctionItem = getAuctionPriceItem(itemKey, from, name, id);
	local data = "0:0:0:0:0:0:0";
	if (auctionItem ~= nil) then
		if (type(auctionItem) == "table") and (auctionItem.data ~= nil) then 
			data = auctionItem.data;
		elseif (type(auctionItem) == "string") then
			data = auctionItem;
		end
	end
	return data;
end
Auctioneer_GetAuctionPriceData = getAuctionPriceData;

-- returns the auction buyout history for this item
function getAuctionBuyoutHistory(itemKey, name, realm)
	local auctionItem = getAuctionPriceItem(itemKey, realm, name);
	if (auctionItem == nil) then 
		buyoutHistory = {};
	else
		buyoutHistory = auctionItem.buyoutPricesHistoryList;
	end
	return buyoutHistory;
end

-- returns the parsed auction price data
local function getAuctionPrices(priceData)
	local i,j, count,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = string.find(priceData, "^(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)");
	return nullSafe(count),nullSafe(minCount),nullSafe(minPrice),nullSafe(bidCount),nullSafe(bidPrice),nullSafe(buyCount),nullSafe(buyPrice);
end
Auctioneer_GetAuctionPrices = getAuctionPrices;

-- parse the data from the auction signature
local function getItemSignature(sigData)
	local i,j, id,rprop,enchant,name,count,min,buyout,uniq = string.find(sigData, "^(%d+):(%d+):(%d+):(.-):(%d+):(.-):(%d+):(.+)");
	if (name == nil) then name = ""; end
	return tonumber(id),tonumber(rprop),tonumber(enchant),name,tonumber(count),tonumber(min),tonumber(buyout),tonumber(uniq);
end
Auctioneer_GetItemSignature = getItemSignature;

-- returns the category i.e. category number 1..10 for an item or 0, if there is no recorded category
local function getItemCategory(itemKey)
	local auctionItem = getAuctionPriceItem(itemKey);

	if not auctionItem then
	   return 0
	end
	
	if not auctionItem.category then
		return 0
	end

	return auctionItem.category;
end
Auctioneer_GetItemCategory = getItemCategory;

local function isItemPlayerMade(itemKey)
	local playerMade;
	local auctionItem = getAuctionPriceItem(itemKey);
	if auctionItem then 
		playerMade = auctionItem.playerMade;
	end
	return playerMade;
end
Auctioneer_IsItemPlayerMade = isItemPlayerMade;

-- return all of the averages for an item
-- Returns: avgMin,avgBuy,avgBid,bidPct,buyPct,avgQty,aCount
local function getMeans(itemKey, from, name, id)
	local itemData = getAuctionPriceData(itemKey, from, name, id);
	local aCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = getAuctionPrices(itemData);
	local avgMin,avgBuy,avgBid,bidPct,buyPct,avgQty;

	if aCount > 0 then
		avgQty = math.floor(minCount / aCount);
		avgMin = math.floor(minPrice / minCount);
		bidPct = math.floor(bidCount / minCount * 100);
		buyPct = math.floor(buyCount / minCount * 100);

		avgBid = 0;
		if (bidCount > 0) then
			avgBid = math.floor(bidPrice / bidCount);
		end

		avgBuy = 0;
		if (buyCount > 0) then
			avgBuy = math.floor(buyPrice / buyCount);
		end
	end
	return avgMin,avgBuy,avgBid,bidPct,buyPct,avgQty,aCount;
end
Aucioneer_GetMeans = getMeans;

-- returns the current snapshot median for an item
local function getItemSnapshotMedianBuyout(itemKey)
	local buyoutPrices = {};
	local auctKey = sanifyAHSnapshot()
	if AHSnapshotItemPrices[auctKey][itemKey] then 
		buyoutPrices = AHSnapshotItemPrices[auctKey][itemKey].buyoutPrices;
	else
		return 0, 0;
	end

	return getMedian(buyoutPrices) or 0, table.getn(buyoutPrices) or 0;
end
Auctioneer_GetItemSnapshotMedianBuyout = getItemSnapshotMedianBuyout;

local function getItemHistoricalMedianBuyout(itemKey, name, realm)
	if not realm then
		realm = auctionKey()
	end
	local buyoutHistoryTable = getAuctionBuyoutHistory(itemKey, name, realm);
	local historyMedian = getMedian(buyoutHistoryTable);
	local historySeenCount = table.getn(buyoutHistoryTable);
	return historyMedian or 0, historySeenCount or 0;
end
Auctioneer_GetItemHistoricalMedianBuyout = getItemHistoricalMedianBuyout;

-- this function returns the most accurate median possible, 
-- if an accurate median cannot be obtained based on min seen counts then nil is returned
local function getUsableMedian(itemKey, name, realm)
	local usableMedian = nil;
	local count = nil;
	if not realm then
		realm = auctionKey();
	end

	--get snapshot median
	local snapshotMedian, snapshotCount
	-- only use Snapshot, when calculating current realm's marketPrice
	-- won't make any sense to use alternate realm's snapshotdata as that data might me out of date
	if realm == auctionKey() then
		snapshotMedian, snapshotCount = getItemSnapshotMedianBuyout(itemKey)
	else
		snapshotMedian = nil
	end

	--get history median
	local historyMedian, historySeenCount = getItemHistoricalMedianBuyout(itemKey, name, realm);

	if historyMedian and (not snapshotMedian or snapshotCount < MIN_BUYOUT_SEEN_COUNT or snapshotMedian > (historyMedian * 1.20)) then
		if historySeenCount >= MIN_BUYOUT_SEEN_COUNT then -- could not obtain a usable median
			usableMedian = historyMedian;
			count = historySeenCount;
		end
	elseif snapshotMedian then
		usableMedian = snapshotMedian;
		count = snapshotCount;
	end

	return usableMedian, count;
end
Auctioneer_GetUsableMedian = getUsableMedian;

-- returns true if they link is likely a player made item
local function isPossiblePlayerMadeItem(link)
	local itemID, randomProp, enchant, uniqID = breakLink(link);
	if randomProp == 0 and uniqID > 0 then
		return true;
	end
	return false;
end
Auctioneer_IsPossiblePlayerMadeItem = isPossiblePlayerMadeItem;

-- returns the current bid on an auction
local function getCurrentBid(auctionSignature)
	local _,_,_, _, _,min,_,_ = getItemSignature(auctionSignature);
	local auctKey = sanifyAHSnapshot();
	local currentBid = AHSnapshot[auctKey][auctionSignature].bidamount;
	if currentBid == 0 then currentBid = min end
		return currentBid;
end
Auctioneer_GetCurrentBid = getCurrentBid;

-- this filter will return true if an auction is a bad choice for reselling
local function isBadResaleChoice(auctionSignature)
	local isBadChoice = false;
	local id,rprop,enchant, name, count,min,buyout,uniq = getItemSignature(auctionSignature);
	local itemKey = id..":"..rprop..":"..enchant;
	local auctKey = sanifyAHSnapshot();
	local auctionItem = AHSnapshot[auctKey][auctionSignature];
	local itemData = getAuctionPriceData(itemKey);
	local aCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = getAuctionPrices(itemData);
	local bidPercent = math.floor(bidCount / minCount * 100);

	-- bad choice conditions
	if BID_BASED_CATEGORIES[auctionItem.category] and bidPercent < MIN_BID_PERCENT then 
		isBadChoice = true; -- bidbased items should have a minimum bid percent
	elseif (auctionItem.level >= 50 and auctionItem.quality == QUALITY_UNCOMMON and bidPercent < MIN_BID_PERCENT) then 
		isBadChoice = true; -- level 50 and greater greens that do not have bids do not sell well  
	elseif auctionItem.owner == UnitName("player") or auctionItem.highBidder then 
		isBadChoice = true; -- don't display auctions that we own, or are high bidder on
	elseif auctionItem.quality == QUALITY_POOR then 
		isBadChoice = true; -- gray items are never a good choice
	end

	return isBadChoice;
end
Auctioneer_IsBadResaleChoice = isBadResaleChoice;

-- filters out all auctions except those that meet profit requirements
local function brokerFilter(minProfit, signature)
	local filterAuction = true;
	local id,rprop,enchant, name, count,min,buyout,uniq = getItemSignature(signature);
	local itemKey = id..":"..rprop..":"..enchant;

	if getUsableMedian(itemKey) then -- we have a useable median
		local hsp = Auctioneer_GetHighestSellablePriceForOne(itemKey, true, auctionKey());
		local profit = (hsp * count) - buyout;
		local profitPricePercent = math.floor((profit / buyout) * 100);

		--see if this auction should not be filtered
		if (buyout and buyout > 0 and buyout <= MAX_BUYOUT_PRICE and profit >= minProfit and not isBadResaleChoice(signature) and profitPricePercent >= MIN_PROFIT_PRICE_PERCENT) then
			filterAuction = false;
		end
	end

	return filterAuction;
end

-- filters out all auctions except those that have short or medium time remaining and meet profit requirements
local function bidBrokerFilter(minProfit, signature)
	local filterAuction = true;
	local id,rprop,enchant, name, count,min,buyout,uniq = getItemSignature(signature);
	local itemKey = id..":"..rprop..":"..enchant;

	if getUsableMedian(itemKey) then  -- only add if we have seen it enough times to have a usable median
		local currentBid = getCurrentBid(signature);
		local hsp = Auctioneer_GetHighestSellablePriceForOne(itemKey, true, auctionKey());
		local profit = (hsp * count) - currentBid;
		local profitPricePercent = math.floor((profit / currentBid) * 100);

		--see if this auction should not be filtered
		local auctKey = sanifyAHSnapshot();
		if (currentBid <= MAX_BUYOUT_PRICE and profit >= minProfit and AHSnapshot[auctKey][signature].timeLeft <= TIME_LEFT_MEDIUM and not isBadResaleChoice(signature) and profitPricePercent >= MIN_PROFIT_PRICE_PERCENT) then
			filterAuction = false;
		end
	end

	return filterAuction;
end

local function auctionOwnerFilter(owner, signature)
	local auctKey = sanifyAHSnapshot();
	if (AHSnapshot[auctKey][signature].owner == owner) then
		return false;
	end
	return true;
end

local function competingFilter(minLess, signature, myAuctions)
	local id,rprop,enchant, name, count,min,buyout,uniq = getItemSignature(signature);
	if (count > 1) then buyout = buyout/count; end
	local itemKey = id..":"..rprop..":"..enchant;

	local auctKey = sanifyAHSnapshot();
	if (AHSnapshot[auctKey][signature].owner ~= UnitName("player")) and
		(myAuctions[itemKey]) and
		(buyout > 0) and
		(buyout+minLess < myAuctions[itemKey]) then
		return false;
	end
	return true;
end


-- filters out all auctions that are not a given percentless than the median for that item.
local function percentLessFilter(percentLess, signature)
	local filterAuction = true;
	local id,rprop,enchant, name, count,min,buyout,uniq = getItemSignature(signature);
	local itemKey = id .. ":" .. rprop..":"..enchant;
	local hsp, seenCount = Auctioneer_GetHighestSellablePriceForOne(itemKey, true, auctionKey());

	if hsp > 0 and nullSafe(seenCount) > 0 then
		local profit = (hsp * count) - buyout;
		--see if this auction should not be filtered
		if (buyout > 0 and percentLessThan(hsp, buyout / count) >= tonumber(percentLess) and profit >= MIN_PROFIT_MARGIN) then
			filterAuction = false;
		end
	end

	return filterAuction;
end


-- generic function for querying the snapshot with a filter function that returns true if an auction should be filtered out of the result set.
local function querySnapshot(filter, param, extra1, extra2)
	local queryResults = {};
	param = param or "";

	local auctKey = sanifyAHSnapshot();
	for auctionSignature,a in AHSnapshot[auctKey] do
		if(not filter(param, auctionSignature, extra1, extra2)) then
			table.insert(queryResults, a); -- for some reason we have to use table.insert in order to use table.sort later
			queryResults[table.getn(queryResults)].signature = auctionSignature;
		end
	end

	return queryResults;
end
Auctioneer_QuerySnapshot = querySnapshot;


-- method to pass to table.sort() that sorts auctions by profit descending
local function profitComparisonSort(a, b)
	local aid,arprop,aenchant, aName, aCount, _, aBuyout, _ = getItemSignature(a.signature);
	local bid,brprop,benchant, bName, bCount, _, bBuyout, _ = getItemSignature(b.signature);
	local aItemKey = aid .. ":" .. arprop..":"..aenchant;
	local bItemKey = bid .. ":" .. brprop..":"..benchant;
	local realm = auctionKey()
	local aProfit = (Auctioneer_GetHighestSellablePriceForOne(aItemKey, true, realm) * aCount) - aBuyout;
	local bProfit = (Auctioneer_GetHighestSellablePriceForOne(bItemKey, true, realm) * bCount) - bBuyout;
	return (aProfit > bProfit) 
end
Auctioneer_ProfitComparisonSort = profitComparisonSort;


-- function returns true, if the given parameter is a valid option for the also command, false otherwise
local function isValidAlso(also)
	-- make also a required parameter
	if (also == nil) then
		return false	-- missing parameter
	end

	if (also == 'opposite') or (also == 'off') then
		return true	-- allow special keywords
	end

	-- check if string matches: "[realm]-[faction]"
	local s, e, r, f = string.find(also, "^(.+)-(.+)$")
	if (s == nil) then
		return false	-- invalid string
	end

	-- check if faction = "Horde" or "Alliance"
	if (f ~= 'Horde') and (f ~= 'Alliance') then
		return false	-- invalid faction
	end

	return true
end


-- builds the list of auctions that can be bought and resold for profit
function doBroker(minProfit)
	if not minProfit or minProfit == "" then minProfit = MIN_PROFIT_MARGIN else minProfit = tonumber(minProfit) * 100  end
	local output = string.format(AUCT_FRMT_BROKER_HEADER, TT_GetTextGSC(minProfit));
	Auctioneer_ChatPrint(output);

	local resellableAuctions = querySnapshot(brokerFilter, minProfit);

	-- sort by profit decending
	table.sort(resellableAuctions, profitComparisonSort);

	-- output the list of auctions
	for _,a in resellableAuctions do
		local id,rprop,enchant, name, count,min,buyout,uniq = getItemSignature(a.signature); 
		local itemKey = id .. ":" .. rprop..":"..enchant;
		local hsp, seenCount = Auctioneer_GetHighestSellablePriceForOne(itemKey, true, auctionKey());
		local profit = (hsp * count) - buyout;
		local output = string.format(AUCT_FRMT_BROKER_LINE, colorTextWhite(count.."x")..a.itemLink, seenCount, TT_GetTextGSC(hsp * count), TT_GetTextGSC(buyout), TT_GetTextGSC(profit));
		Auctioneer_ChatPrint(output);
	end

	Auctioneer_ChatPrint(AUCT_FRMT_BROKER_DONE);
end

-- builds the list of auctions that can be bought and resold for profit
function doBidBroker(minProfit)
	if not minProfit or minProfit == "" then minProfit = MIN_PROFIT_MARGIN else minProfit = tonumber(minProfit) * 100  end
	local output = string.format(AUCT_FRMT_BIDBROKER_HEADER, TT_GetTextGSC(minProfit));
	Auctioneer_ChatPrint(output);

	local bidWorthyAuctions = querySnapshot(bidBrokerFilter, minProfit);

	table.sort(bidWorthyAuctions, function(a, b) return (a.timeLeft < b.timeLeft) end);

	-- output the list of auctions
	for _,a in bidWorthyAuctions do
		local id,rprop,enchant, name, count,min,buyout,uniq = getItemSignature(a.signature);
		local itemKey = id .. ":" .. rprop..":"..enchant;
		local hsp, seenCount = Auctioneer_GetHighestSellablePriceForOne(itemKey, true, auctionKey());
		local currentBid = getCurrentBid(a.signature);
		local profit = (hsp * count) - currentBid;

		local bidText = AUCT_FRMT_BIDBROKER_CURBID;
		if (currentBid == min) then
			bidText = AUCT_FRMT_BIDBROKER_MINBID;
		end
		local output = string.format(AUCT_FRMT_BIDBROKER_LINE, colorTextWhite(count.."x")..a.itemLink, seenCount, TT_GetTextGSC(hsp * count), bidText, TT_GetTextGSC(currentBid), TT_GetTextGSC(profit), colorTextWhite(getTimeLeftString(a.timeLeft)));
		Auctioneer_ChatPrint(output);
	end

	Auctioneer_ChatPrint(AUCT_FRMT_BIDBROKER_DONE);
end

function doCompeting(minLess)
	if not minLess or minLess == "" then minLess = DEFAULT_COMPETE_LESS * 100 else minLess = tonumber(minLess) * 100  end
	local output = string.format(AUCT_FRMT_COMPETE_HEADER, TT_GetTextGSC(minLess));
	Auctioneer_ChatPrint(output);

	local myAuctions = querySnapshot(auctionOwnerFilter, UnitName("player"));
	local myHighestPrices = {}
	for _,a in myAuctions do
		local id,rprop,enchant, name, count,min,buyout,uniq = getItemSignature(a.signature);
		if (count > 1) then buyout = buyout/count; end
		local itemKey = id .. ":" .. rprop..":"..enchant;
		if (not myHighestPrices[itemKey]) or (myHighestPrices[itemKey] < buyout) then
			myHighestPrices[itemKey] = buyout;
		end
	end
	local competingAuctions = querySnapshot(competingFilter, minLess, myHighestPrices);

	table.sort(competingAuctions, profitComparisonSort);

	-- output the list of auctions
	for _,a in competingAuctions do
		local id,rprop,enchant, name, count,min,buyout,uniq = getItemSignature(a.signature);
		local itemKey = id .. ":" .. rprop..":"..enchant;
		local currentBid = getCurrentBid(a.signature);

		local buyoutForOne = buyout;
		local bidForOne = currentBid;
		if (count > 1) then
			buyoutForOne = buyout/count;
			bidForOne = currentBid/count;
		end

		local bidPrice = TT_GetTextGSC(bidForOne).."ea";
		if (currentBid == min) then
			bidPrice = "No bids ("..bidPrice..")";
		end

		local myBuyout = myHighestPrices[itemKey];
		local buyPrice = TT_GetTextGSC(buyoutForOne).."ea";
		local myPrice = TT_GetTextGSC(myBuyout).."ea";
		local priceLess = myBuyout - buyoutForOne;
		local lessPrice = TT_GetTextGSC(priceLess);

		local output = string.format(AUCT_FRMT_COMPETE_LINE, colorTextWhite(count.."x")..a.itemLink, bidPrice, buyPrice, myPrice, lessPrice);
		Auctioneer_ChatPrint(output);
	end

	Auctioneer_ChatPrint(AUCT_FRMT_COMPETE_DONE);
end

-- builds the list of auctions that can be bought and resold for profit
function doPercentLess(percentLess)
	if not percentLess or percentLess == "" then percentLess = MIN_PERCENT_LESS_THAN_HSP end
	local output = string.format(AUCT_FRMT_PCTLESS_HEADER, percentLess);
	Auctioneer_ChatPrint(output);

	local auctionsBelowHSP = querySnapshot(percentLessFilter, percentLess);

	-- sort by profit based on median
	table.sort(auctionsBelowHSP, profitComparisonSort);

	-- output the list of auctions
	for _,a in auctionsBelowHSP do
		local id,rprop,enchant, name, count,_,buyout,_ = getItemSignature(a.signature);
		local itemKey = id ..":"..rprop..":"..enchant;
		local hsp, seenCount = Auctioneer_GetHighestSellablePriceForOne(itemKey, true, auctionKey());
		local profit = (hsp * count) - buyout;
		local output = string.format(AUCT_FRMT_PCTLESS_LINE, colorTextWhite(count.."x")..a.itemLink, seenCount, TT_GetTextGSC(hsp * count), TT_GetTextGSC(buyout), TT_GetTextGSC(profit), colorTextWhite(percentLessThan(hsp, buyout / count).."%"));
		Auctioneer_ChatPrint(output);
	end

	Auctioneer_ChatPrint(AUCT_FRMT_PCTLESS_DONE);
end

-- given an item name, find the lowest price for that item in the current AHSnapshot
-- if the item does not exist in the snapshot or the snapshot does not exist
-- a nil is returned.
function findLowestAuctionForItem(itemKey)
	local itemID, itemRand, enchant = breakItemKey(itemKey);
	if (itemID == nil) then return nil; end

	local lowSig = nil;
	local lowestPrice = 9000000; -- initialize to a very high value, 900 gold
	local auctKey = sanifyAHSnapshot();
	for sig,v in AHSnapshot[auctKey] do
		local id,rprop,enchant, name, count,min,buyout,uniq = getItemSignature(sig);
		local priceForOne = 0;
		if (count and count > 0) then priceForOne = (buyout / count); end
			if (tonumber(itemID) == tonumber(id) and tonumber(itemRand) == tonumber(rprop) and buyout > 0 and priceForOne < lowestPrice) then 
				lowSig = sig;
				lowestPrice = priceForOne;
		end
	end
	return lowSig;
end

-- quick index to lowest snapshot price of an item
function getLowestPriceQuick(itemKey)
	local lowestPriceForOne = nil;

	local auctKey = sanifyAHSnapshot();
	if AHSnapshotItemPrices[auctKey][itemKey] then 
		buyoutPrices = AHSnapshotItemPrices[auctKey][itemKey].buyoutPrices;
		table.sort(buyoutPrices)
		lowestPriceForOne = buyoutPrices[1];
	end

	return lowestPriceForOne or 0;
end

function doMedian(link)
	local itemID, randomProp, enchant, uniqID, itemName = breakLink(link);
	local itemKey = itemID..":"..randomProp..":"..enchant;

	local median, count = getUsableMedian(itemKey);
	if (not median) then
		Auctioneer_ChatPrint(string.format(AUCT_FRMT_MEDIAN_NOAUCT, colorTextWhite(itemName)));
	else
		Auctioneer_ChatPrint(string.format(AUCT_FRMT_MEDIAN_LINE, count, colorTextWhite(itemName), TT_GetTextGSC(median)));
	end
end

local function getBidBasedSellablePrice(itemKey, realm)
	local itemData = getAuctionPriceData(itemKey, realm);
	local avgMin,avgBuy,avgBid,bidPct,buyPct,avgQty,seenCount = getMeans(itemKey, realm);
	local bidBasedSellPrice = 0;
	local typicalBuyout = 0;

	local medianBuyout = getUsableMedian(itemKey, nil, realm);
	if medianBuyout then
		typicalBuyout = math.min(avgBuy, medianBuyout)  ;
	else
		typicalBuyout = avgBuy;
	end

	bidBasedSellPrice = (3*typicalBuyout + avgBid) / 4;
	return bidBasedSellPrice;
end

-- returns the best market price - 0, if no market price could be calculated
local function getMarketPrice(itemKey, realm)
	-- make sure to call this function with valid parameters! No check is being performed!
	local buyoutMedian = nullSafe(getUsableMedian(itemKey, realm))
	local avgMin, avgBuy, avgBid, bidPct, buyPct, avgQty, meanCount = getMeans(itemKey, realm)
	local commonBuyout = 0

	-- assign the best common buyout
	if buyoutMedian > 0 then
		commonBuyout = buyoutMedian
	elseif meanCount and meanCount > 0 then
		commonBuyout = avgBuy; -- if a usable median does not exist, use the average buyout instead
	end

	if BID_BASED_CATEGORIES[getItemCategory(itemKey)] and not (isItemPlayerMade(itemKey) and commonBuyout < 100000) then
		return getBidBasedSellablePrice(itemKey, realm) -- returns bibasedSellablePrice for bidbaseditems, playermade items or if the buyoutprice is not present or less than 10g
	end

	return commonBuyout -- returns buyoutMedian, if present - returns avgBuy otherwise, if meanCount > 0 - returns 0 otherwise
end

function Auctioneer_GetHighestSellablePriceForOne(itemKey, useCachedPrices, realm)
	-- make sure that if useCachedPrices is set to true, realm is the current one - otherwise it won't make any sense and the result could be undefined.
	-- check added, as it's a global function and should not cause any problems even when called with invalid parameters
	local playerRealm = auctionKey()
	
	if (itemKey == nil) or                                 -- make itemKey a required parameter
		 (useCachedPrices == nil) or                        -- make useCachedPrices a required parameter
		 (realm == nil) or                                  -- make realm a required parameter
		 (useCachedPrices and realm ~= playerRealm) then    -- using cachedPrices with alternative realms is not supported atm
		return nil
	end

	local highestSellablePrice = 0;
	local warn = AUCT_FRMT_WARN_NODATA;
	local marketPrice = getMarketPrice(itemKey, realm);

	local lowestAllowedPercentBelowMarket = tonumber(Auctioneer_GetFilterVal(AUCT_CMD_PCT_MAXLESS, AUCT_OPT_PCT_MAXLESS_DEFAULT));
	local discountLowPercent = tonumber(Auctioneer_GetFilterVal(AUCT_CMD_PCT_UNDERLOW, AUCT_OPT_PCT_UNDERLOW_DEFAULT));
	local discountMarketPercent = tonumber(Auctioneer_GetFilterVal(AUCT_CMD_PCT_UNDERMKT, AUCT_OPT_PCT_UNDERMKT_DEFAULT));
	local discountNoCompetitionPercent = tonumber(Auctioneer_GetFilterVal(AUCT_CMD_PCT_NOCOMP, AUCT_OPT_PCT_NOCOMP_DEFAULT));
	local vendorSellMarkupPercent = tonumber(Auctioneer_GetFilterVal(AUCT_CMD_PCT_MARKUP, AUCT_OPT_PCT_MARKUP_DEFAULT));

	local buyoutMedian, count = getUsableMedian(itemKey, realm);
	local id = breakItemKey(itemKey);

	-- get the lowest auction for this item
	local currentLowestBuyout = nil;
	local lowestAuctionSignature = nil;
	local lowestAuctionCount, lowestAuctionBuyout;
	if useCachedPrices then
		currentLowestBuyout = getLowestPriceQuick(itemKey);
	elseif realm == playerRealm then
		lowestAuctionSignature = findLowestAuctionForItem(itemKey);
		if lowestAuctionSignature then
			_,_,_, _, lowestAuctionCount, _, lowestAuctionBuyout, _ = getItemSignature(lowestAuctionSignature);
			currentLowestBuyout = lowestAuctionBuyout / lowestAuctionCount;
--~ p("currentLowestBuyout: "..currentLowestBuyout);
		end
	end

	if marketPrice > 0 then
		-- Note: urentLowestBuyout is nil, incase the realm is not the current player's realm
		if currentLowestBuyout and currentLowestBuyout > 0 then
			lowestBuyoutPriceAllowed = subtractPercent(marketPrice, lowestAllowedPercentBelowMarket);
			if lowestAuctionSignature and AHSnapshot[playerRealm][lowestAuctionSignature].owner == UnitName("player") then
				highestSellablePrice = currentLowestBuyout; -- If I am the lowest seller use same low price
				warn = AUCT_FRMT_WARN_MYPRICE;
			elseif (currentLowestBuyout < lowestBuyoutPriceAllowed) then
				highestSellablePrice = subtractPercent(marketPrice, discountMarketPercent);
				warn = AUCT_FRMT_WARN_TOOLOW;
			elseif (currentLowestBuyout > marketPrice) then
				highestSellablePrice = subtractPercent(marketPrice, discountNoCompetitionPercent);
				warn = AUCT_FRMT_WARN_ABOVEMKT;
			else -- use discount low
				-- set highest price to "Discount low"
				highestSellablePrice = subtractPercent(currentLowestBuyout, discountLowPercent);
				warn = string.format(AUCT_FRMT_WARN_UNDERCUT, discountLowPercent);
			end
		else -- no low buyout, use discount no competition
			-- set highest price to "Discount no competition"
			highestSellablePrice = subtractPercent(marketPrice, discountNoCompetitionPercent);
			warn = AUCT_FRMT_WARN_NOCOMP;
		end
	else -- no market
		-- Note: urentLowestBuyout is nil, incase the realm is not the current player's realm
		if currentLowestBuyout and currentLowestBuyout > 0 then
			-- set highest price to "Discount low"
--~ p("Discount low case 2");
			highestSellablePrice = subtractPercent(currentLowestBuyout, discountLowPercent);
			warn = string.format(AUCT_FRMT_WARN_UNDERCUT, discountLowPercent);
		elseif Auctioneer_BasePrices and Auctioneer_BasePrices[id] and Auctioneer_BasePrices[id].s then -- see if we have vendor sell info for this item
			-- use vendor prices if no auction data available
			local itemInfo = Auctioneer_BasePrices[id];
			local vendorSell = nullSafe(itemInfo.s); -- use vendor prices
			highestSellablePrice = addPercent(vendorSell, vendorSellMarkupPercent);
			warn = string.format(AUCT_FRMT_WARN_MARKUP, vendorSellMarkupPercent);
		end
	end

	return highestSellablePrice, count, marketPrice, warn;
end

-- execute the '/auctioneer low <itemName>' that returns the auction for an item with the lowest buyout
local function doLow(link)
	local itemID, randomProp, enchant, uniqID, itemName = breakLink(link);
	local itemKey = itemID..":"..randomProp..":"..enchant;

	local auctionSignature = findLowestAuctionForItem(itemKey);
	if (not auctionSignature) then
		Auctioneer_ChatPrint(string.format(AUCT_FRMT_NOAUCT, colorTextWhite(itemName)));
	else
		local _,_,_, _, count, _, buyout, _ = getItemSignature(auctionSignature);
		local auctKey = sanifyAHSnapshot();
		local auction = AHSnapshot[auctKey][auctionSignature];
		local itemKey = itemID..":"..randomProp..":"..enchant;
		Auctioneer_ChatPrint(string.format(AUCT_FRMT_LOW_LINE, colorTextWhite(count.."x")..auction.itemLink, TT_GetTextGSC(buyout), colorTextWhite(auction.owner), TT_GetTextGSC(buyout / count), colorTextWhite(percentLessThan(getUsableMedian(itemKey), buyout / count).."%")));
	end
end

local function doHSP(link)
	local itemID, randomProp, enchant, uniqID, itemName = breakLink(link);
	local itemKey = itemID..":"..randomProp..":"..enchant;
	local highestSellablePrice = Auctioneer_GetHighestSellablePriceForOne(itemKey, false, auctionKey());
	Auctioneer_ChatPrint(string.format(AUCT_FRMT_HSP_LINE, colorTextWhite(itemName), TT_GetTextGSC(nilSafeString(highestSellablePrice))));
end

local function doTest(param)
	p(getBidBasedSellablePrice(param));
end


-- Hook into this function if you want notification when we find a link.
function Auctioneer_ProcessLink(link)
	if (ItemsMatrix_ProcessLinks ~= nil) then
		ItemsMatrix_ProcessLinks(	link, -- itemlink
											nil,  -- not used atm
											nil,  -- vendorprice - TODO: not calculatable in AH?
											nil	-- event - TODO: donno, maybe only for chatevents?
										)
	end
	if (LootLink_ProcessLinks ~= nil) then
		LootLink_ProcessLinks(	link, -- itemlink
										true  -- TODO: uncertain? - ah is a trustable source?
									);
	end
end

-- Called by scanning hook when an auction item is scanned from the Auction house
-- we save the aution item to our tables, increment our counts etc
local function Auctioneer_AuctionEntry_Hook(page, index, category)
	local auctionDoneKey;
	if (not page or not index or not category) then
		return;
	else
		auctionDoneKey = category.."-"..page.."-"..index;
	end
	if (not Auction_DoneItems[auctionDoneKey]) then
		Auction_DoneItems[auctionDoneKey] = true;
	else
		return;
	end

	lTotalAuctionsScannedCount = lTotalAuctionsScannedCount + 1;

	local aiName, aiTexture, aiCount, aiQuality, aiCanUse, aiLevel, aiMinBid, aiMinIncrement, aiBuyoutPrice, aiBidAmount, aiHighBidder, aiOwner = GetAuctionItemInfo("list", index);

	-- do some validation of the auction data that was returned
	if (aiName == nil or tonumber(aiBuyoutPrice) > MAX_ALLOWED_FORMAT_INT or tonumber(aiMinBid) > MAX_ALLOWED_FORMAT_INT) then return; end
	if (aiCount < 1) then aiCount = 1; end

	-- get other auctiondata
	local aiTimeLeft = GetAuctionItemTimeLeft("list", index);
	local aiLink = GetAuctionItemLink("list", index);
	-- Call some interested iteminfo addons
	Auctioneer_ProcessLink(aiLink);

	local aiItemID, aiRandomProp, aiEnchant, aiUniqID = breakLink(aiLink);
	local aiKey = aiItemID..":"..aiRandomProp..":"..aiEnchant;

	-- construct the unique auction signature for this aution
	local lAuctionSignature = string.format("%d:%d:%d:%s:%d:%d:%d:%d", aiItemID, aiRandomProp, aiEnchant, nilSafeString(aiName), nullSafe(aiCount), nullSafe(aiMinBid), nullSafe(aiBuyoutPrice), aiUniqID);

	-- add this item's buyout price to the buyout price history for this item in the snapshot
	if aiBuyoutPrice > 0 then
		local buyoutPriceForOne = (aiBuyoutPrice / aiCount);
		if (not lSnapshotItemPrices[aiKey]) then
			lSnapshotItemPrices[aiKey] = {buyoutPrices={buyoutPriceForOne}, name=aiName};
		else
			table.insert(lSnapshotItemPrices[aiKey].buyoutPrices, buyoutPriceForOne);
		end
	end


	-- if this auction is in the snapshot, do not add it to the AuctionPrices and AHSnapshot
	local auctKey = sanifyAHSnapshot();
	if (AHSnapshot[auctKey][lAuctionSignature]) then 
		lOldAuctionsCount = lOldAuctionsCount + 1;
		--this is an auction that was already in the snapshot from a previous scan and is still in the auction house
		AHSnapshot[auctKey][lAuctionSignature].dirty = 0;                         --set its dirty flag to false so we know to keep it in the snapshot
		AHSnapshot[auctKey][lAuctionSignature].lastSeenTime = time();             --set the time we saw it last
		AHSnapshot[auctKey][lAuctionSignature].timeLeft = nullSafe(aiTimeLeft);   --update the time left
		AHSnapshot[auctKey][lAuctionSignature].bidamount = nullSafe(aiBidAmount); --update the current bid amount
		AHSnapshot[auctKey][lAuctionSignature].highBidder = aiHighBidder;         --update the high bidder
		return
	end

	-- this auction is not in the snapshot, so add it to the AuctionPrices and AHSnapshot
	--Auctioneer_ChatPrint("New sig: "..lAuctionSignature);

	lNewAuctionsCount = lNewAuctionsCount + 1;

	-- get the item data from AuctionPrices table
	local itemData;
	local buyoutPricesHistory;

	-- correct old SavedVariables-format
	-- see if they are still using the itemID as the key
	if AuctionPrices[auctionKey()][aiItemID] then
		itemData = AuctionPrices[auctionKey()][aiItemID];
		AuctionPrices[auctionKey()][aiItemID] = nil; --clear entry using old ID key
	-- else, see if they are still using the item name as the key
	elseif AuctionPrices[auctionKey()][aiName] then
		itemData = AuctionPrices[auctionKey()][aiName].data;
		buyoutPricesHistory = AuctionPrices[auctionKey()][aiName].buyoutPricesHistoryList;
		AuctionPrices[auctionKey()][aiKey] = {data=itemData, buyoutPricesHistoryList=buyoutPricesHistory};
		AuctionPrices[auctionKey()][aiName] = nil; --clear entry using old Item Name key
	else
		itemData = getAuctionPriceData(aiKey);
	end

	local seenCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = getAuctionPrices(itemData);

	-- Sanity check values to ensure they aren't whack. if prices are wack we dont want to skew the mean, but still can add to the median
	local hasWackPrice = false;
	if ((nullSafe(minCount) > 10) and (aiMinBid/aiCount > 5*minPrice/minCount)) then
		hasWackPrice = true;
	elseif ((nullSafe(bidCount) > 10) and (aiBidAmount/aiCount > 5*bidPrice/bidCount)) then
		hasWackPrice = true;
	elseif ((nullSafe(buyCount) > 10) and (aiBuyoutPrice/aiCount > 5*buyPrice/buyCount)) then
		hasWackPrice = true;
	end

	if (not hasWackPrice) then 
		-- update counts and price data for this item
		seenCount = nullSafe(seenCount) + 1;
		minCount = nullSafe(minCount) + aiCount;
		minPrice = nullSafe(minPrice) + aiMinBid;
		if (aiBidAmount > 0) then 
			bidCount = nullSafe(bidCount) + aiCount;
			bidPrice = nullSafe(bidPrice) + aiBidAmount;
		end
		if (aiBuyoutPrice > 0) then
			buyCount = nullSafe(buyCount) + aiCount;
			buyPrice = nullSafe(buyPrice) + aiBuyoutPrice;
		end
	end

	itemData = string.format("%d:%d:%d:%d:%d:%d:%d", seenCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice);

	-- now build the list of buyout prices seen for this auction to use to get the median
	local newBuyoutPricesList = newBalancedList(lMaxBuyoutHistorySize);
	if (AuctionPrices[auctionKey()][aiKey] and table.getn(AuctionPrices[auctionKey()][aiKey].buyoutPricesHistoryList) > 0) then
		newBuyoutPricesList.setList(AuctionPrices[auctionKey()][aiKey].buyoutPricesHistoryList);
	end
	if (nullSafe(aiBuyoutPrice) > 0) then
		newBuyoutPricesList.insert(math.floor(aiBuyoutPrice / aiCount));
	end
	AuctionPrices[auctionKey()][aiKey] = {name=aiName, category=category, playerMade=isPossiblePlayerMadeItem(aiLink), data=itemData, buyoutPricesHistoryList=newBuyoutPricesList.getList()};

	-- finaly add the auction to the snapshot
	if (aiOwner == nil) then aiOwner = "unknown"; end
	local initialTimeSeen = time();
	AHSnapshot[auctKey][lAuctionSignature] = {initialSeenTime=initialTimeSeen, lastSeenTime=initialTimeSeen, itemLink=aiLink, quality=nullSafe(aiQuality), level=nullSafe(aiLevel), bidamount=nullSafe(aiBidAmount), highBidder=aiHighBidder, owner=aiOwner, timeLeft=nullSafe(aiTimeLeft), category=category, dirty=0};
end

-- this function takes copper and rounds to 5 silver below the the nearest gold if it is less than 15 silver above of an even gold
-- example: this function changes 1g9s to 95s
-- example: 1.5g will be unchanged and remain 1.5g
local function roundDownTo95(copper)
	local g,s,c = TT_GetGSC(copper);

	if g > 0 and s < 10 then
		return (copper - ((s + 5) * 100)); -- subtract enough copper to round to 95 silver
	end

	return copper;
end

function Auctioneer_SetModelByID(itemID)
	if ( (not Auctioneer_GetFilter(AUCT_SHOW_MESH)) or (Auctioneer_GetFilter(AUCT_CMD_EMBED)) ) then
		return;
	end
	local showMesh = Auctioneer_GetFilterVal(AUCT_SHOW_MESH);
	if (showMesh == AUCT_CMD_ALT) and (not IsAltKeyDown()) then return; end
	if (showMesh == AUCT_CMD_CTRL) and (not IsControlKeyDown()) then return; end
	if (showMesh == AUCT_CMD_SHIFT) and (not IsShiftKeyDown()) then return; end

	if (Auctioneer_BasePrices[itemID]) then
		local dinfo = Auctioneer_BasePrices[itemID].d;
		if (dinfo) then
			local meshID = Auctioneer_DisplayInfo[dinfo];
			if (meshID) then
				local mesh = Auctioneer_MeshData[meshID];
				if (mesh) then
					local i,j, class, model = string.find(mesh, "([^/]+)/(.*)");
					if (class) then
						TT_SetModel(class, model);
					else Auctioneer_ChatPrint("No class for mesh "..mesh);
					end
				else Auctioneer_ChatPrint("No mesh for mesh id "..meshID);
				end
			end
		end
	end
end

function Auctioneer_ItemPopup(name, link, quality, count)
	return true;
end

function Auctioneer_NewTooltip(frame, name, link, quality, count)
	Auctioneer_OldTooltip(frame, name, link, quality, count);
	
	if (not link) then p("No link was passed to the client");  return; end

	-- nothing to do, if auctioneer is disabled
	if (not Auctioneer_GetFilter("all")) then
		TT_Show(frame);
	   return;
	end;
	
	-- initialize local variables
	local itemID, randomProp, enchant, uniqID, lame = breakLink(link);
	local itemKey = itemID..":"..randomProp..":"..enchant;
	local embedded = Auctioneer_GetFilter(AUCT_CMD_EMBED);

	-- OUTPUT: seperator line
	if (embedded) then
		if (Auctioneer_GetFilter(AUCT_SHOW_EMBED_BLANK)) then
			TT_AddLine(" ", nil, embedded);
		end
	else
		TT_AddLine(name, nil, embedded);
		TT_LineQuality(quality);
	end

	if (Auctioneer_GetFilter(AUCT_SHOW_LINK)) then
		-- OUTPUT: show item link
		TT_AddLine("Link: " .. itemKey .. ":" .. uniqID, nil, embedded);
		TT_LineQuality(quality);
	end

	local itemInfo = nil;

	-- show item info
	if (itemID > 0) then
		-- prepare mesh
		if (Auctioneer_GetFilter(AUCT_SHOW_MESH)) then
			Auctioneer_SetModelByID(itemID);
		end

		frame.eDone = 1;
		local itemData = getAuctionPriceData(itemKey, nil, name, itemID);
		local aCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = getAuctionPrices(itemData);
		itemInfo = Auctioneer_BasePrices[itemID];

		-- show auction info
		if (aCount == 0) then
			-- OUTPUT: "Never seen at auction"
			TT_AddLine(string.format(AUCT_FRMT_INFO_NEVER, AUCT_TEXT_AUCTION), nil, embedded);
			TT_LineColor(0.5, 0.8, 0.5);
		else -- (aCount > 0)
			-- calculate auction values
			local avgQty = math.floor(minCount / aCount);
			local avgMin = math.floor(minPrice / minCount);

			local bidPct = math.floor(bidCount / minCount * 100);
			local avgBid = 0;
			if (bidCount > 0) then
				avgBid = math.floor(bidPrice / bidCount);
			end

			local buyPct = math.floor(buyCount / minCount * 100);
			local avgBuy = 0;
			if (buyCount > 0) then
				avgBuy = math.floor(buyPrice / buyCount);
			end

			local median, medCount = getUsableMedian(itemKey, name);

			if (Auctioneer_GetFilter(AUCT_SHOW_AVERAGE)) then -- show item's average auction price
				-- OUTPUT: "Seen [aCount] times at auction total"
				TT_AddLine(string.format(AUCT_FRMT_INFO_SEEN, aCount), nil, embedded);
				TT_LineColor(0.5,0.8,0.1);
				if (not Auctioneer_GetFilter(AUCT_SHOW_VERBOSE)) then -- default mode
					if (avgQty > 1) then
						-- OUTPUT: "For 1: [avgMin] min/[avgBuy] BO ([avgBid] bid) [in [avgQty]'s]"
						TT_AddLine(string.format(AUCT_FRMT_INFO_FORONE, TT_GetTextGSC(avgMin), TT_GetTextGSC(avgBuy), TT_GetTextGSC(avgBid), avgQty), nil, embedded);
						TT_LineColor(0.1,0.8,0.5);
					else -- (avgQty = 1)
						-- OUTPUT: "[avgMin] min/[avgBuy] BO ([avgBid] bid)"
						TT_AddLine(string.format(AUCT_FRMT_INFO_AVERAGE, TT_GetTextGSC(avgMin), TT_GetTextGSC(avgBuy), TT_GetTextGSC(avgBid)), nil, embedded);
						TT_LineColor(0.1,0.8,0.5);
					end
				else -- verbose mode
					if (count > 1) then
						-- OUTPUT: "Averages for [count] items:"
						TT_AddLine(string.format(AUCT_FRMT_INFO_HEAD_MULTI, count), nil, embedded);
						TT_LineColor(0.4,0.5,1.0);
						-- OUTPUT: "  Minimum ([avgMin] ea)"
						TT_AddLine(string.format(AUCT_FRMT_INFO_MIN_MULTI, TT_GetTextGSC(avgMin)), avgMin*count, embedded);
						TT_LineColor(0.4,0.5,0.8);
						if (Auctioneer_GetFilter(AUCT_SHOW_STATS)) then -- show buyout/bidded percentages
							-- OUTPUT: "  Bidded ([bidPct]%, [avgBid] ea)"
							TT_AddLine(string.format(AUCT_FRMT_INFO_BID_MULTI, bidPct.."%, ", TT_GetTextGSC(avgBid)), avgBid*count, embedded);
							TT_LineColor(0.4,0.5,0.85);
							-- OUTPUT: "  Buyout ([buyPct]%, [avgBuy] ea)"
							TT_AddLine(string.format(AUCT_FRMT_INFO_BUY_MULTI, buyPct.."%, ", TT_GetTextGSC(avgBuy)), avgBuy*count, embedded);
							TT_LineColor(0.4,0.5,0.9);
						else -- don't show buyout/bidded percentages
							-- OUTPUT: "  Bidded ([avgBid] ea)"
							TT_AddLine(string.format(AUCT_FRMT_INFO_BID_MULTI, "", TT_GetTextGSC(avgBid)), avgBid*count, embedded);
							TT_LineColor(0.4,0.5,0.85);
							-- OUTPUT: "  Buyout ([avgBuy] ea)"
							TT_AddLine(string.format(AUCT_FRMT_INFO_BUY_MULTI, "", TT_GetTextGSC(avgBuy)), avgBuy*count, embedded);
							TT_LineColor(0.4,0.5,0.9);
						end
						if (median) then
							-- OUTPUT: "  Buyout median"
							TT_AddLine(AUCT_FRMT_INFO_BUYMEDIAN, median * count, embedded);
							TT_LineColor(0.4,0.5,0.95);
						end
					else -- (count = 0 | 1)
					   -- OUTPUT: "Averages for this item:"
						TT_AddLine(AUCT_FRMT_INFO_HEAD_ONE, nil, embedded);
						TT_LineColor(0.4,0.5,1.0);
						-- OUTPUT: "  Minimum bid"
						TT_AddLine(AUCT_FRMT_INFO_MIN_ONE, avgMin, embedded);
						TT_LineColor(0.4,0.5,0.8);
						if (Auctioneer_GetFilter(AUCT_SHOW_STATS)) then -- show buyout/bidded percentages
							-- OUTPUT: "  Bidded [bidPct]%"
							TT_AddLine(string.format(AUCT_FRMT_INFO_BID_ONE, " "..bidPct.."%"), avgBid, embedded);
							TT_LineColor(0.4,0.5,0.85);
							-- OUTPUT: "  Buyout [buyPct]%"
							TT_AddLine(string.format(AUCT_FRMT_INFO_BUY_ONE, " "..buyPct.."%"), avgBuy, embedded);
							TT_LineColor(0.4,0.5,0.9);
						else -- don't show buyout/bidded percentages
						   -- OUTPUT: "  Bidded [bidPct]%"
							TT_AddLine(string.format(AUCT_FRMT_INFO_BID_ONE, ""), avgBid, embedded);
							TT_LineColor(0.4,0.5,0.85);
							-- OUTPUT: "  Buyout [buyPct]%"
							TT_AddLine(string.format(AUCT_FRMT_INFO_BUY_ONE, ""), avgBuy, embedded);
							TT_LineColor(0.4,0.5,0.9);
						end
						if (median) then
							-- OUTPUT: "  Buyout median"
							TT_AddLine(AUCT_FRMT_INFO_BUYMEDIAN, median, embedded);
							TT_LineColor(0.4,0.5,0.95);
						end
					end
					if (avgQty > 1) then
						-- OUTPUT: "  Average stack size: [avgQty] items"
						TT_AddLine(string.format(AUCT_FRMT_INFO_STACKSIZE, avgQty), nil, embedded);
						TT_LineColor(0.4,0.5,1.0);
					end
				end

				if median and Auctioneer_GetFilter(AUCT_SHOW_MEDIAN) then -- show item's median buyout price
					local historicalMedian, historicalMedCount = getItemHistoricalMedianBuyout(itemKey, name);
					local snapshotMedian, snapshotMedCount = getItemSnapshotMedianBuyout(itemKey);
					if historicalMedian and historicalMedCount > nullSafe(snapshotMedCount)  then
						-- OUTPUT: "Last [historicalMedCount], median BO (ea)"
						TT_AddLine(string.format(AUCT_FRMT_INFO_HISTMED, historicalMedCount), historicalMedian, embedded)
						TT_LineColor(0.1,0.8,0.5);
					end
					if snapshotMedian then
						-- OUTPUT: "Scanned [snapshotMedCount], median BO (ea)"
						TT_AddLine(string.format(AUCT_FRMT_INFO_SNAPMED, snapshotMedCount), snapshotMedian, embedded)
						TT_LineColor(0.1,0.8,0.5);
					end
				end
			end -- if(Auctioneer_GetFilter(AUCT_SHOW_AVERAGE)) - show item's average auction price

			-- seperate line for suggested auction price (for clarification, even if the values have already been shown somewhere else
			if (Auctioneer_GetFilter(AUCT_SHOW_SUGGEST)) then -- show item's suggested auction price
				local hsp = Auctioneer_GetHighestSellablePriceForOne(itemKey, false, auctionKey());
				if hsp == 0 and buyCount > 0 then
					hsp = math.floor(buyPrice / buyCount); -- use mean buyout if median not available
				end
				local discountBidPercent = tonumber(Auctioneer_GetFilterVal(AUCT_CMD_PCT_BIDMARKDOWN, AUCT_OPT_PCT_BIDMARKDOWN_DEFAULT));
				local countFix = count
				if countFix == 0 then
					countFix = 1
				end
				local buyPrice = roundDownTo95(nullSafe(hsp) * countFix);
				local bidPrice = roundDownTo95(subtractPercent(buyPrice, discountBidPercent));
				if (count > 1) then
					-- OUTPUT: "Suggested price for your [count] stack: [bidPrice] min/[buyPrice] BO"
					TT_AddLine(string.format(AUCT_FRMT_INFO_SGSTSTX, count, TT_GetTextGSC(bidPrice, true), TT_GetTextGSC(buyPrice, true)), nil, embedded);
					TT_LineColor(0.5,0.5,0.8);
				else -- count = 0 | 1
					-- OUTPUT: "Suggested price: [bidPrice] min/[buyPrice] BO"
					TT_AddLine(string.format(AUCT_FRMT_INFO_SGST, TT_GetTextGSC(bidPrice, true), TT_GetTextGSC(buyPrice, true)), nil, embedded);
					TT_LineColor(0.5,0.5,0.8);
				end
			end
			if (not Auctioneer_GetFilter(AUCT_SHOW_VERBOSE)) then
				if (Auctioneer_GetFilter(AUCT_SHOW_STATS)) then -- show buyout/bidded percentages
					-- OUTPUT: "[bidPct]% have bid, [buyPct]% have BO"
					TT_AddLine(string.format(AUCT_FRMT_INFO_BIDRATE, bidPct, buyPct), nil, embedded);
					TT_LineColor(0.1,0.5,0.8);
				end
			end
		end -- (aCount > 0)

		local also = Auctioneer_GetFilterVal("also");
		if (isValidAlso(also)) and (also ~= "off") then
			if (also == "opposite") then
				also = oppositeKey();
			end
			local itemData = getAuctionPriceData(itemKey, also, name, itemID);
			local aCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = getAuctionPrices(itemData);
			local avgQty = math.floor(minCount / aCount);
			local avgMin = math.floor(minPrice / minCount);

			local bidPct = math.floor(bidCount / minCount * 100);
			local avgBid = 0;
			if (bidCount > 0) then
				avgBid = math.floor(bidPrice / bidCount);
			end

			local buyPct = math.floor(buyCount / minCount * 100);
			local avgBuy = 0;
			if (buyCount > 0) then
				avgBuy = math.floor(buyPrice / buyCount);
			end

			if (aCount == 0) then
				TT_AddLine(string.format(">> "..AUCT_FRMT_INFO_NEVER, also), nil, embedded);
				TT_LineColor(0.5,0.8,0.1);
			else
				if (Auctioneer_GetFilter(AUCT_SHOW_AVERAGE)) then
					TT_AddLine(string.format(">> "..AUCT_FRMT_INFO_ALSOSEEN, aCount, also), nil, embedded);
					TT_LineColor(0.5,0.8,0.1);
					if (avgQty > 1) then
						TT_AddLine(string.format(">> "..AUCT_FRMT_INFO_FORONE, TT_GetTextGSC(avgMin), TT_GetTextGSC(avgBuy), TT_GetTextGSC(avgBid), avgQty), nil, embedded);
						TT_LineColor(0.1,0.8,0.5);
					else
						TT_AddLine(string.format(">> "..AUCT_FRMT_INFO_AVERAGE, TT_GetTextGSC(avgMin), TT_GetTextGSC(avgBuy), TT_GetTextGSC(avgBid)), nil, embedded);
						TT_LineColor(0.1,0.8,0.5);
					end
					if (Auctioneer_GetFilter(AUCT_SHOW_SUGGEST)) then
						local hsp = Auctioneer_GetHighestSellablePriceForOne(itemKey, false, also);
						if hsp == 0 and buyCount > 0 then
							hsp = math.floor(buyPrice / buyCount); -- use mean buyout if median not available
						end
						local discountBidPercent = tonumber(Auctioneer_GetFilterVal(AUCT_CMD_PCT_BIDMARKDOWN, AUCT_OPT_PCT_BIDMARKDOWN_DEFAULT));
						local countFix = count
						if countFix == 0 then
							countFix = 1
						end
						local buyPrice = roundDownTo95(nullSafe(hsp) * countFix);
						local bidPrice = roundDownTo95(subtractPercent(buyPrice, discountBidPercent));
						if (count > 1) then
							-- OUTPUT: "Suggested price for your [count] stack: [bidPrice] min/[buyPrice] BO"
							TT_AddLine(string.format(">> "..AUCT_FRMT_INFO_SGSTSTX, count, TT_GetTextGSC(bidPrice, true), TT_GetTextGSC(buyPrice, true)), nil, embedded);
							TT_LineColor(0.5,0.5,0.8);
						else -- count = 0 | 1
							-- OUTPUT: "Suggested price: [bidPrice] min/[buyPrice] BO"
							TT_AddLine(string.format(">> "..AUCT_FRMT_INFO_SGST, TT_GetTextGSC(bidPrice, true), TT_GetTextGSC(buyPrice, true)), nil, embedded);
							TT_LineColor(0.5,0.5,0.8);
						end
					end
				end
				if (Auctioneer_GetFilter(AUCT_SHOW_STATS)) then
					TT_AddLine(string.format(">> "..AUCT_FRMT_INFO_BIDRATE, bidPct, buyPct), nil, embedded);
					TT_LineColor(0.1,0.5,0.8);
				end
			end
		end
	end -- if (itemID > 0)
	local sellNote = "";
	local buyNote = "";
	local sell = 0;
	local buy = 0;
	local quant = 1;
	local stacks = 1;
	local class = "";
	local uses = "";
	if (itemInfo) then
		buyNote = "*"
		stacks = itemInfo.x;
		if (not stacks) then stacks = 1; end
		quant = nullSafe(itemInfo.q);
		if (quant < 1) then quant = 1; end
		if (quant > 1) then
			buyNote = "*";
		end
		buy = nullSafe(itemInfo.b) / quant;
		sellNote = "*"
		sell = nullSafe(itemInfo.s);
		if (itemInfo.c) then
			class = itemInfo.c;
		end
		if (itemInfo.u) then
			uses = itemInfo.u;
		end
	end

	if (Auctioneer_GetFilter(AUCT_SHOW_VENDOR)) then
		if ((buy > 0) or (sell > 0)) then
			local bgsc = TT_GetTextGSC(buy);
			local sgsc = TT_GetTextGSC(sell);

			if (count and (count > 1)) then
				local bqgsc = TT_GetTextGSC(buy*count);
				local sqgsc = TT_GetTextGSC(sell*count);
				if (Auctioneer_GetFilter(AUCT_SHOW_VENDOR_BUY)) then
					TT_AddLine(string.format(AUCT_FRMT_INFO_BUYMULT, buyNote, count, bgsc), buy*count, embedded);
					TT_LineColor(0.8, 0.5, 0.1);
				end
				if (Auctioneer_GetFilter(AUCT_SHOW_VENDOR_SELL)) then
					TT_AddLine(string.format(AUCT_FRMT_INFO_SELLMULT, sellNote, count, sgsc), sell*count, embedded);
					TT_LineColor(0.8, 0.5, 0.1);
				end
			else
				if (Auctioneer_GetFilter(AUCT_SHOW_VENDOR_BUY)) then
					TT_AddLine(string.format(AUCT_FRMT_INFO_BUY, buyNote), buy, embedded);
					TT_LineColor(0.8, 0.5, 0.1);
				end
				if (Auctioneer_GetFilter(AUCT_SHOW_VENDOR_SELL)) then
					TT_AddLine(string.format(AUCT_FRMT_INFO_SELL, sellNote), sell, embedded);
					TT_LineColor(0.8, 0.5, 0.1);
				end
			end
		end
	end

	if (Auctioneer_GetFilter(AUCT_SHOW_STACK)) then
		if (stacks > 1) then
			TT_AddLine(string.format(AUCT_FRMT_INFO_STX, stacks), nil, embedded);
		end
	end
	if (Auctioneer_GetFilter(AUCT_SHOW_USAGE)) then
		local reagentInfo = "";
		if (class ~= "") then
			if (uses ~= "") then
				reagentInfo = string.format(AUCT_FRMT_INFO_CLASSUSE, class, uses);
			else
				reagentInfo = string.format(AUCT_FRMT_INFO_CLASS, class);
			end
		elseif (uses ~= "") then
			reagentInfo = string.format(AUCT_FRMT_INFO_USE, uses);
		end
		if (reagentInfo ~= "") then
			TT_AddLine(reagentInfo, nil, embedded);
			TT_LineColor(0.6, 0.4, 0.8);
		end
	end
	TT_Show(frame);
end

local function Auctioneer_Tooltip_Hook(frame, name, count, data)
	Auctioneer_Old_Tooltip_Hook(frame, name, count, data);
end
function Auctioneer_AddTooltipInfo(frame, name, count, data)
end

-- hook to capture data about an auction that was boughtout
function Auctioneer_PlaceAuctionBid(itemtype, itemindex, bidamount)
	-- get the info for this auction
	local aiLink = GetAuctionItemLink(AuctionFrame.type, GetSelectedAuctionItem(AuctionFrame.type));
	local aiItemID, aiRandomProp, aiEnchant, aiUniqID = breakLink(aiLink);
	local aiKey = aiItemID..":"..aiRandomProp..":"..aiEnchant;
	local aiName, aiTexture, aiCount, aiQuality, aiCanUse, aiLevel, aiMinBid, aiMinIncrement,
		aiBuyout, aiBidAmount, aiHighBidder, aiOwner =
		GetAuctionItemInfo(AuctionFrame.type, GetSelectedAuctionItem(AuctionFrame.type));

	local auctionSignature = string.format("%d:%d:%d:%s:%d:%d:%d:%d", aiItemID, aiRandomProp, aiEnchant, nilSafeString(aiName), nullSafe(aiCount), nullSafe(aiMinBid), nullSafe(aiBuyout), aiUniqID);

	local playerName = UnitName("player");
	local eventTime = "e"..time();
	if (not AuctionBids[playerName]) then
		AuctionBids[playerName] = {};
	end
	AuctionBids[playerName][eventTime] = {
		signature = auctionSignature,
		bidAmount = bidamount,
		itemOwner = aiOwner,
		prevBidder = aiHighBidder,
		itemWon = false;
	}

	if bidamount == aiBuyout then -- only capture buyouts
		-- remove from snapshot
		Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_REMOVE, auctionSignature));
		local auctKey = sanifyAHSnapshot();
		AHSnapshot[auctKey][auctionSignature] = nil;
		AuctionBids[playerName][eventTime].itemWon=true;
	end

	Auctioneer_Old_BidHandler(itemtype,itemindex,bidamount);
end

function Auctioneer_OnLoad()
	-- register events
	this:RegisterEvent("NEW_AUCTION_UPDATE"); -- event that is fired when item changed in new auction frame
	this:RegisterEvent("AUCTION_HOUSE_SHOW"); -- auction house window opened
	this:RegisterEvent("AUCTION_HOUSE_CLOSED"); -- auction house window closed
	this:RegisterEvent("AUCTION_ITEM_LIST_UPDATE"); -- event for scanning

	this:RegisterEvent("VARIABLES_LOADED"); -- get called when our vars have loaded

	Auctioneer_Event_StartAuctionScan = Auctioneer_AuctionStart_Hook;
	Auctioneer_Event_ScanAuction = Auctioneer_AuctionEntry_Hook;
	Auctioneer_Event_FinishedAuctionScan = Auctioneer_FinishedAuctionScan_Hook;

	-- Hook in new tooltip code
	Auctioneer_OldTooltip = TT_AddTooltip;
	TT_AddTooltip = Auctioneer_NewTooltip;
	Auctioneer_OldPopup = TT_ItemPopup;
	TT_ItemPopup = Auctioneer_ItemPopup;

	-- Hook PlaceAuctionBid
	Auctioneer_Old_BidHandler = PlaceAuctionBid;
	PlaceAuctionBid = Auctioneer_PlaceAuctionBid;

	-- Hook in the FilterButton_SetType
	Auctioneer_Old_FilterButton_SetType = FilterButton_SetType;
	FilterButton_SetType = Auctioneer_FilterButton_SetType;

	SLASH_AUCTIONEER1 = "/auctioneer";
	SLASH_AUCTIONEER2 = "/auction";
	SLASH_AUCTIONEER3 = "/auc";
	SlashCmdList["AUCTIONEER"] = function(msg)
		Auctioneer_Command(msg);
	end

	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage(string.format(AUCT_FRMT_WELCOME, AUCTIONEER_VERSION), 0.8, 0.8, 0.2);
	end

	Auctioneer_ConfigureAH();
	
	--GUI Registration code added by MentalPower
	
	Auctioneer_Register();
	
end

function Auctioneer_Register()
	if (Khaos) then
		if (not Auctioneer_Khaos_Registered) then
			Auctioneer_GUI_Registered = Auctioneer_Register_Khaos();
		end
	end
	-- The following check is to accomodate other GUI libraries other than Khaos relatively easily.
	if (Auctioneer_GUI_Registered == true) then
		return true;
	else 
		return false;
	end
end

function Auctioneer_Register_Khaos()
	local optionSet = {
		id="Auctioneer";
		text="Auctioneer";
		helptext="Contains settings for Auctioneer \nan AddOn that displays item info and analyzes auction data. \nUse \"/auctioneer scan\" at AH to collect auction data.";
		difficulty=1;
		default={checked=true};
		options={
			{
				id="Header";
				text="Auctioneer";
				helptext="Contains settings for Auctioneer \nan AddOn that displays item info and analyzes auction data. \nClick the \"Scan\" button at the AH to collect auction data.";
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="AuctioneerEnable";
				type=K_TEXT;
				text="Enable Auctioneer";
				helptext=AUCT_HELP_ONOFF;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("on") else Auctioneer_GUI_Command("off") end end;
				feedback=function(state) if (state.checked) then return AUCT_STAT_ON else return AUCT_STAT_OFF end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=1;
			};
			{
				id="AuctioneerLocale";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text="Change locale to";
				helptext=AUCT_HELP_LOCALE;
				callback = function(state)
					Auctioneer_GUI_Command("locale "..state.value);
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, AUCT_CMD_LOCALE, state.value);
				end;
				default = {
					value = Auctioneer_GetLocale();
				};
				disabled = {
					value = "enUS";
				};
				difficulty=2;
				
			};
			{
				id="AuctioneerVerbose";
				type=K_TEXT;
				text="Verbose Mode";
				helptext=AUCT_HELP_VERBOSE;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-average on") else Auctioneer_GUI_Command("show-average off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-average")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-average")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=1;
			};
			{
				id="AuctioneerStats";
				type=K_TEXT;
				text="Show Stats";
				helptext=AUCT_HELP_STATS;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-stats on") else Auctioneer_GUI_Command("show-stats off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-stats")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-stats")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=1;
			};
			{
				id="AuctioneerStatsHeader";
				type=K_HEADER;
				text="Item Price Statistics";
				helptext="Show the following statistics in the tooltip.";
				difficulty=2;
			};
			{
				id="AuctioneerAverage";
				type=K_TEXT;
				text="Show Averages";
				helptext=AUCT_HELP_AVERAGE;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-average on") else Auctioneer_GUI_Command("show-average off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-average")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-average")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=2;
			};
			{
				id="AuctioneerMedian";
				type=K_TEXT;
				text="Show Medians";
				helptext=AUCT_HELP_MEDIAN;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-median on") else Auctioneer_GUI_Command("show-median off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-median")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-average")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=2;
			};
			{
				id="AuctioneerSuggest";
				type=K_TEXT;
				text="Show Suggested Prices";
				helptext=AUCT_HELP_SUGGEST;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-suggest on") else Auctioneer_GUI_Command("show-suggest off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-suggest")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-suggest")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=2;
			};
			{
				id="AuctioneerEmbedHeader";
				type=K_HEADER;
				text="Vendor Prices";
				helptext="Options related to NPC buy/sell prices.";
				difficulty=1;
			};
			{
				id="AuctioneerVendor";
				type=K_TEXT;
				text="Show Vendor Prices";
				helptext=AUCT_HELP_VENDOR;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-vendor on") else Auctioneer_GUI_Command("show-vendor off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-vendor")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-vendor")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=1;
			};
			{
				id="AuctioneerVendorBuy";
				type=K_TEXT;
				text="Show Vendor Buy Prices";
				helptext=AUCT_HELP_VENDOR_BUY;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-vendor-buy on") else Auctioneer_GUI_Command("show-vendor-buy off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-vendor-buy")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-vendor-buy")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=2;
			};
			{
				id="AuctioneerVendorSell";
				type=K_TEXT;
				text="Show Vendor Sell Prices";
				helptext=AUCT_HELP_VENDOR_SELL;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-vendor-sell on") else Auctioneer_GUI_Command("show-vendor-sell off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-vendor-sell")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-vendor-sell")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=2;
			};
			{
				id="AuctioneerEmbedHeader";
				type=K_HEADER;
				text="Embed";
				helptext=AUCT_HELP_EMBED;
				difficulty=1;
			};
			{
				id="AuctioneerEmbed";
				type=K_TEXT;
				text="Embed info in in-game tooltip";
				helptext=AUCT_HELP_EMBED;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("embed on") else Auctioneer_GUI_Command("embed off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "embed")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "embed")) end end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				difficulty=1;
			};
			{
				id="AuctioneerEmbedBlankline";
				type=K_TEXT;
				text="Show blankline in in-game tooltip";
				helptext=AUCT_HELP_EMBED_BLANK;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-embed-blankline on") else Auctioneer_GUI_Command("show-embed-blankline off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-embed-blankline")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-embed-blankline")) end end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				difficulty=1;
			};
			{
				id="AuctioneerClearHeader";
				type=K_HEADER;
				text="Clear Data";
				helptext="Clears Auctioneer data. \nSelect either all data or the current snapshot.\nWARNING: These actions are NOT undoable.";
				difficulty=3;
			};
			{
				id="AuctioneerClearAll";
				key="AuctioneerClear";
				type=K_BUTTON;
				setup={
					buttonText = "Clear All";
				};
				text="Clear All Auctioneer Data";
				helptext="Click here to clear all of the auctioneer data.";
				callback=function() Auctioneer_GUI_Command("clear all") end;
				feedback=string.format(AUCT_FRMT_ACT_CLEARALL,  "for the current server-faction");
				difficulty=3;
			};
			{
				id="AuctioneerClearSnapshot";
				type=K_BUTTON;
				setup={
					buttonText="Clear Snapshot";
				};
				text="Clear snapshot data";
				helptext="Click here to clear the last Auctioneer snapshot data.";
				callback=function() Auctioneer_GUI_Command("clear snapshot")end;
				feedback=AUCT_FRMT_ACT_CLEARSNAP;
				difficulty=3;
			};
			{
				id="AuctioneerPercentsHeader";
				type=K_HEADER;
				text="Auctioneer Threshold Percents";
				helptext="WARNING: The following setting are for Power Users ONLY.\nAdjust the following values to change how aggresive Auctioneer will be when deciding profitable levels.";
				difficulty=4;
			};
			{
				id="AuctioneerBidmarkdownPercent";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text="Bid Markdown Percent";
				helptext=AUCT_HELP_PCT_BIDMARKDOWN;
				callback = function(state)
					Auctioneer_GUI_Command("pct-bidmarkdown "..state.value);
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, pct-bidmarkdown, state.value.."%");
				end;
				default = {
					value = 20;
				};
				disabled = {
					value = 20;
				};
				difficulty=4;				
			};
			{
				id="AuctioneerMarkupPercent";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text="Vendor Price Markup Percent";
				helptext=AUCT_HELP_PCT_MARKUP;
				callback = function(state)
					Auctioneer_GUI_Command("pct-markup "..state.value);
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, pct-markup, state.value.."%");
				end;
				default = {
					value = 300;
				};
				disabled = {
					value = 300;
				};
				difficulty=4;
			};
			{
				id="AuctioneerMaxlessPercent";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text="Max Market Undercut Percent";
				helptext=AUCT_HELP_PCT_MAXLESS;
				callback = function(state)
					Auctioneer_GUI_Command("pct-maxless "..state.value);
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, pct-maxless, state.value.."%");
				end;
				default = {
					value = 30;
				};
				disabled = {
					value = 30;
				};
				difficulty=4;
			};
			{
				id="AuctioneerNocompPercent";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text="No Competition Undercut Percent";
				helptext=AUCT_HELP_PCT_NOCOMP;
				callback = function(state)
					Auctioneer_GUI_Command("pct-nocomp "..state.value);
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, pct-nocomp, state.value.."%");
				end;
				default = {
					value = 2;
				};
				disabled = {
					value = 2;
				};
				difficulty=4;
			};
			{
				id="AuctioneerUnderlowPercent";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text="Lowest Auction Undercut";
				helptext=AUCT_HELP_PCT_UNDERLOW;
				callback = function(state)
					Auctioneer_GUI_Command("pct-underlow "..state.value);
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, pct-underlow, state.value.."%");
				end;
				default = {
					value = 5;
				};
				disabled = {
					value = 5;
				};
				difficulty=4;
			};
			{
				id="AuctioneerUndermktPercent";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text="Undercut Market When Maxless";
				helptext=AUCT_HELP_PCT_UNDERMKT;
				callback = function(state)
					Auctioneer_GUI_Command("pct-undermkt "..state.value);
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, pct-undermkt, state.value.."%");
				end;
				default = {
					value = 20;
				};
				disabled = {
					value = 20;
				};
				difficulty=4;
			};
			{
				id="AuctioneerOtherHeader";
				type=K_HEADER;
				text="Other Options";
				helptext="Miscellaneous Auctioneer Options";
				difficulty=1;
			};
			{
				id="AuctioneerAutofill";
				type=K_TEXT;
				text="Autofill prices in the AH";
				helptext=AUCT_HELP_AUTOFILL;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("autofill on") else Auctioneer_GUI_Command("autofill off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "autofill")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "autofill")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=1;
			};
			{
				id="AuctioneerInclude";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text="Also display data for";
				helptext=AUCT_HELP_ALSO;
				callback = function(state)
					Auctioneer_GUI_Command("also "..state.value);
				end;
				feedback = function (state)
					if (state.value == opposite) then
						return "Now also displaying data for opposite faction.";
					elseif (state.value == off) then
						return "No longer displaying other real-faction data.";
					else
						return string.format("Displaying data for %s", state.value);
					end
				end;
				default = {
					value = "off";
				};
				disabled = {
					value = "off";
				};
				difficulty=2;
			};
			--Conflicts with above input box
			--[[
			{
				id="AuctioneerIncludeOpposite";
				type=K_TEXT;
				text="Include data from opposite faction";
				helptext=AUCT_HELP_ALSO;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("also opposite") else Auctioneer_GUI_Command("also ") end end;
				feedback=function(state) if (state.checked) then return "Now including opposite faction data" else return "Not including opposite faction data" end end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				difficulty=2;
			};
			]]--
			--Oops, not yet implemented :)
			--[[
			{
				id="AuctioneerHSP";
				type=K_TEXT;
				text="Show Highest Sellable Price (HSP)";
				helptext=AUCT_HELP_HSP;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-hsp on") else Auctioneer_GUI_Command("show-hsp off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-hsp")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-hsp")) end end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				difficulty=3;
			};
			]]--
			{
				id="AuctioneerMesh";
				type=K_TEXT;
				text="Show Item Mesh";
				helptext=AUCT_HELP_MESH;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-mesh on") else Auctioneer_GUI_Command("show-mesh off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-mesh")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-mesh")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=3;
			};
			{
				id="AuctioneerLink";
				type=K_TEXT;
				text="Show LinkID";
				helptext=AUCT_HELP_LINK;
				callback=function(state) if (state.checked) then Auctioneer_GUI_Command("show-link on") else Auctioneer_GUI_Command("show-link off") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-link")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-link")) end end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				difficulty=3;
			};
		};
	};

	Khaos.registerOptionSet(
		"tooltip",
		optionSet
	);
	
	Auctioneer_Khaos_Registered = true;
	return true;
end


local function findFilterClass(text)
	local totalFilters = getn(CLASS_FILTERS);
	for currentFilter=1, totalFilters do
		if (text == CLASS_FILTERS[currentFilter]) then
			return currentFilter, totalFilters;
		end
	end
	return 0, totalFilters;
end

function AuctFilter_SetFilter(checkbox, filter)
	checkbox.filterVal = filter;
	checkbox:SetChecked(Auctioneer_GetFilter(filter));
	checkbox:SetScale(0.5);
	checkbox:Show();
end

function Auctioneer_GetLocale()
	local locale = Auctioneer_GetFilterVal('locale');
	if (locale ~= 'on') and (locale ~= 'off') and (locale ~= 'default') then
		return locale;
	end
	return GetLocale();
end

function Auctioneer_FilterButton_SetType(button, type, text, isLast)
	Auctioneer_Old_FilterButton_SetType(button, type, text, isLast);

	local buttonName = button:GetName();
	local i,j, buttonID = string.find(buttonName, "(%d+)$");
	buttonID = tonumber(buttonID);

	local checkbox = getglobal(button:GetName().."Checkbox");
	if (type == "class") then
		local classid, maxid = findFilterClass(text);
		if (classid > 0) then
			AuctFilter_SetFilter(checkbox, "scan-class"..classid);
			if (classid == maxid) and (buttonID < 15) then
				for i=buttonID+1, 15 do
					getglobal("AuctionFilterButton"..i):Hide();
				end
			end
		else
			checkbox:Hide();
		end
	else
		checkbox:Hide();
	end
end

function Auctioneer_ConfigureAH()
	AuctionsPriceText:ClearAllPoints();
	AuctionsPriceText:SetPoint("TOPLEFT", "AuctionsItemText", "TOPLEFT", 0, -56);
	AuctionsBuyoutText:ClearAllPoints();
	AuctionsBuyoutText:SetPoint("TOPLEFT", "AuctionsPriceText", "TOPLEFT", 0, -36);
	AuctionsBuyoutErrorText:ClearAllPoints();
	AuctionsBuyoutErrorText:SetPoint("TOPLEFT", "AuctionsBuyoutText", "TOPLEFT", 0, -32);
	AuctionsDurationText:ClearAllPoints();
	AuctionsDurationText:SetPoint("TOPLEFT", "AuctionsBuyoutErrorText", "TOPLEFT", 0, -10);
	AuctionsDepositText:ClearAllPoints();
	AuctionsDepositText:SetPoint("TOPLEFT", "AuctionsDurationText", "TOPLEFT", 0, -34);
	if (AuctionInfo ~= nil) then
		AuctionInfo:ClearAllPoints();
		AuctionInfo:SetPoint("TOPLEFT", "AuctionsDepositText", "TOPLEFT", -4, -36);
	end

	AuctionsShortAuctionButtonText:SetText("2");
	AuctionsMediumAuctionButtonText:SetText("8");
	AuctionsMediumAuctionButton:ClearAllPoints();
	AuctionsMediumAuctionButton:SetPoint("BOTTOMLEFT", "AuctionsShortAuctionButton", "BOTTOMRIGHT", 20,0);
	AuctionsLongAuctionButtonText:SetText("24 "..HOURS);
	AuctionsLongAuctionButton:ClearAllPoints();
	AuctionsLongAuctionButton:SetPoint("BOTTOMLEFT", "AuctionsMediumAuctionButton", "BOTTOMRIGHT", 20,0);
	
	-- set UI-texts
	BrowseScanButton:SetText(AUCT_TEXT_SCAN);
end

function Auctioneer_Command(command)
	local i,j, cmd, param = string.find(command, "^([^ ]+) (.+)$");
	if (not cmd) then cmd = command; end
	if (not cmd) then cmd = ""; end
	if (not param) then param = ""; end

	if ((cmd == "") or (cmd == "help")) then
		Auctioneer_ChatPrint("Usage:");
		local onOffToggle = " ("..AUCT_CMD_ON.."|"..AUCT_CMD_OFF.."|"..AUCT_CMD_TOGGLE..")";
		local lineFormat = "  |cffffffff/auctioneer %s "..onOffToggle.."|r |cff2040ff[%s]|r - %s";

		Auctioneer_ChatPrint("  |cffffffff/auctioneer "..onOffToggle.."|r |cff2040ff["..Auctioneer_GetFilterVal("all").."]|r - " .. AUCT_HELP_ONOFF);

		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_VERBOSE, Auctioneer_GetFilterVal(AUCT_SHOW_VERBOSE), AUCT_HELP_VERBOSE));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_AVERAGE, Auctioneer_GetFilterVal(AUCT_SHOW_AVERAGE), AUCT_HELP_AVERAGE));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_MEDIAN, Auctioneer_GetFilterVal(AUCT_SHOW_MEDIAN), AUCT_HELP_MEDIAN));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_SUGGEST, Auctioneer_GetFilterVal(AUCT_SHOW_SUGGEST), AUCT_HELP_SUGGEST));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_STATS, Auctioneer_GetFilterVal(AUCT_SHOW_STATS), AUCT_HELP_STATS));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_VENDOR, Auctioneer_GetFilterVal(AUCT_SHOW_VENDOR), AUCT_HELP_VENDOR));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_VENDOR_SELL, Auctioneer_GetFilterVal(AUCT_SHOW_VENDOR_SELL), AUCT_HELP_VENDOR_SELL));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_VENDOR_BUY, Auctioneer_GetFilterVal(AUCT_SHOW_VENDOR_BUY), AUCT_HELP_VENDOR_BUY));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_USAGE, Auctioneer_GetFilterVal(AUCT_SHOW_USAGE), AUCT_HELP_USAGE));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_STACK, Auctioneer_GetFilterVal(AUCT_SHOW_STACK), AUCT_HELP_STACK));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_LINK, Auctioneer_GetFilterVal(AUCT_SHOW_LINK), AUCT_HELP_LINK));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_AUTOFILL, Auctioneer_GetFilterVal(AUCT_CMD_AUTOFILL), AUCT_HELP_AUTOFILL));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_EMBED, Auctioneer_GetFilterVal(AUCT_CMD_EMBED), AUCT_HELP_EMBED));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_EMBED_BLANK, Auctioneer_GetFilterVal(AUCT_SHOW_EMBED_BLANK), AUCT_HELP_EMBED_BLANK));

		lineFormat = "  |cffffffff/auctioneer %s %s|r |cff2040ff[%s]|r - %s";
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_MESH, "("..AUCT_CMD_ON.."|"..AUCT_CMD_OFF.."|"..AUCT_CMD_ALT.."|"..AUCT_CMD_CTRL.."|"..AUCT_CMD_SHIFT..")" ,Auctioneer_GetFilterVal(AUCT_SHOW_MESH), AUCT_HELP_MESH));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_LOCALE, AUCT_OPT_LOCALE, Auctioneer_GetFilterVal('locale'), AUCT_HELP_LOCALE));

		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_MARKUP, AUCT_OPT_PCT_MARKUP, Auctioneer_GetFilterVal(AUCT_CMD_PCT_MARKUP, AUCT_OPT_PCT_MARKUP_DEFAULT), AUCT_HELP_PCT_MARKUP));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_BIDMARKDOWN, AUCT_OPT_PCT_BIDMARKDOWN, Auctioneer_GetFilterVal(AUCT_CMD_PCT_BIDMARKDOWN, AUCT_OPT_PCT_BIDMARKDOWN_DEFAULT), AUCT_HELP_PCT_BIDMARKDOWN));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_NOCOMP, AUCT_OPT_PCT_NOCOMP, Auctioneer_GetFilterVal(AUCT_CMD_PCT_NOCOMP, AUCT_OPT_PCT_NOCOMP_DEFAULT), AUCT_HELP_PCT_NOCOMP));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_UNDERLOW, AUCT_OPT_PCT_UNDERLOW, Auctioneer_GetFilterVal(AUCT_CMD_PCT_UNDERLOW, AUCT_OPT_PCT_UNDERLOW_DEFAULT), AUCT_HELP_PCT_UNDERLOW));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_UNDERMKT, AUCT_OPT_PCT_UNDERMKT, Auctioneer_GetFilterVal(AUCT_CMD_PCT_UNDERMKT, AUCT_OPT_PCT_UNDERMKT_DEFAULT), AUCT_HELP_PCT_UNDERMKT));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_MAXLESS, AUCT_OPT_PCT_MAXLESS, Auctioneer_GetFilterVal(AUCT_CMD_PCT_MAXLESS, AUCT_OPT_PCT_MAXLESS_DEFAULT), AUCT_HELP_PCT_MAXLESS));

		lineFormat = "  |cffffffff/auctioneer %s %s|r - %s";
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_CLEAR, AUCT_OPT_CLEAR, AUCT_HELP_CLEAR));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_ALSO, AUCT_OPT_ALSO, AUCT_HELP_ALSO));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_BROKER, AUCT_OPT_BROKER, AUCT_HELP_BROKER));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_BIDBROKER, AUCT_OPT_BIDBROKER, AUCT_HELP_BIDBROKER));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PERCENTLESS, AUCT_OPT_PERCENTLESS, AUCT_HELP_PERCENTLESS));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_COMPETE, AUCT_OPT_COMPETE, AUCT_HELP_COMPETE));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_SCAN, AUCT_OPT_SCAN, AUCT_HELP_SCAN));

	elseif (cmd == AUCT_CMD_ON) then
		Auctioneer_SetFilter("all", "on");
		Auctioneer_ChatPrint(AUCT_STAT_ON);
	elseif (cmd == AUCT_CMD_OFF) then
		Auctioneer_SetFilter("all", "off");
		Auctioneer_ChatPrint(AUCT_STAT_OFF);
	elseif (cmd == AUCT_CMD_TOGGLE) then
		local cur = Auctioneer_GetFilterVal("all");
		if (cur == "off") then
			Auctioneer_SetFilter("all", "on");
			Auctioneer_ChatPrint(AUCT_STAT_ON);
		else
			Auctioneer_SetFilter("all", "off");
			Auctioneer_ChatPrint(AUCT_STAT_OFF);
		end
	elseif (cmd == AUCT_CMD_CLEAR) then
		if (param == AUCT_CMD_CLEAR_ALL) then
			local aKey = auctionKey();
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_CLEARALL, aKey));
			AuctionPrices[aKey] = {};
			AHSnapshot = {};
			AHSnapshot[auctionKey()] = {};
			AHSnapshotItemPrices = {};
			AHSnapshotItemPrices[auctionKey()] = {};
		elseif (param == AUCT_CMD_CLEAR_SNAPSHOT) then
			Auctioneer_ChatPrint(AUCT_FRMT_ACT_CLEARSNAP);
			AHSnapshot = {};
			AHSnapshot[auctionKey()] = {};
			AHSnapshotItemPrices = {};  
			AHSnapshotItemPrices[auctionKey()] = {};
			lSnapshotItemPrices = {}; 
		else
			local items = Auctioneer_GetItems(param);
			for _,itemKey in items do
				local aKey = auctionKey();
				if (AuctionPrices[aKey][itemKey] ~= nil) then
					AuctionPrices[aKey][itemKey] = nil;
					Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_CLEAR_OK, itemKey));
				else
					Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_CLEAR_FAIL, itemKey));
				end
			end
		end
	elseif (cmd == AUCT_CMD_ALSO) then
		if (param == AUCT_CMD_ALSO_OPPOSITE) then
			param = "opposite";
		end
		if (not isValidAlso(param)) then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_UNKNOWN_RF, param))
			return
		end
		Auctioneer_SetFilter("also", param);
	elseif (cmd == AUCT_CMD_LOCALE) then
		if (AUCT_VALID_LOCALES[param]) then
			Auctioneer_SetFilter('locale', param);
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_SET, AUCT_CMD_LOCALE, param));
			Auctioneer_SetLocaleStrings(Auctioneer_GetLocale());
			Auctioneer_BuildBaseData();
		elseif (param == '') or (param == 'default') or (param == 'off') then
			Auctioneer_SetFilter('locale', 'default');
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_SET, AUCT_CMD_LOCALE, 'default'));
			Auctioneer_SetLocaleStrings(Auctioneer_GetLocale());
		else
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_UNKNOWN_LOCALE, param));
			for locale, _ in AUCT_VALID_LOCALES do
				Auctioneer_ChatPrint("  "..locale);
			end
		end
	elseif (cmd == AUCT_CMD_BROKER) then
		doBroker(param);
	elseif (cmd == AUCT_CMD_BIDBROKER) or (cmd == AUCT_CMD_BIDBROKER_SHORT) then
		doBidBroker(param);
	elseif (cmd == AUCT_CMD_PERCENTLESS) or (cmd == AUCT_CMD_PERCENTLESS_SHORT) then
		doPercentLess(param);
	elseif (cmd == AUCT_CMD_COMPETE) then
		doCompeting(param);
	elseif (cmd == AUCT_CMD_SCAN) then
		Auctioneer_RequestAuctionScan();
	elseif (cmd == "test") then
		doTest(param);
	elseif (cmd == "low") then
		doLow(param);
	elseif (cmd == "med") then
		doMedian(param);
	elseif (cmd == "hsp") then
		doHSP(param);
	elseif (
		(cmd == AUCT_CMD_PCT_BIDMARKDOWN) or
		(cmd == AUCT_CMD_PCT_MARKUP) or
		(cmd == AUCT_CMD_PCT_MAXLESS) or
		(cmd == AUCT_CMD_PCT_NOCOMP) or
		(cmd == AUCT_CMD_PCT_UNDERLOW) or
		(cmd == AUCT_CMD_PCT_UNDERMKT)
	) then
		local paramVal = tonumber(param);
		Auctioneer_SetFilter(cmd, paramVal);
		Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_SET, cmd, paramVal.."%"));
	elseif (
		(cmd == AUCT_SHOW_VERBOSE) or 
		(cmd == AUCT_SHOW_AVERAGE) or 
		(cmd == AUCT_SHOW_MEDIAN) or
		(cmd == AUCT_SHOW_SUGGEST) or 
		(cmd == AUCT_SHOW_STATS) or 
		(cmd == AUCT_SHOW_VENDOR) or 
		(cmd == AUCT_SHOW_USAGE) or 
		(cmd == AUCT_SHOW_STACK) or 
		(cmd == AUCT_SHOW_VENDOR_SELL) or 
		(cmd == AUCT_SHOW_VENDOR_BUY) or 
		(cmd == AUCT_SHOW_LINK) or 
		(cmd == AUCT_CMD_EMBED) or 
		(cmd == AUCT_CMD_AUTOFILL) or 
		(cmd == AUCT_SHOW_EMBED_BLANK) or 
		(cmd == AUCT_SHOW_HSP)
	) then
		if (param == AUCT_CMD_OFF) then
			Auctioneer_SetFilter(cmd, "off");
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_DISABLE, cmd));
		elseif (param == AUCT_CMD_TOGGLE) then
			local cur = Auctioneer_GetFilterVal(cmd);
			if (cur == "on") then
				cur = "off";
				Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_DISABLE, cmd));
			else
				cur = "on";
				Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_ENABLE, cmd));
			end
			Auctioneer_SetFilter(cmd, cur);
		else
			Auctioneer_SetFilter(cmd, "on");
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_ENABLE, cmd));
		end
	elseif (cmd == AUCT_SHOW_MESH) then
		if (param == AUCT_CMD_OFF) then
			Auctioneer_SetFilter(cmd, "off");
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_DISABLE, cmd));
		elseif (
			(param == AUCT_CMD_ALT) or
			(param == AUCT_CMD_CTRL) or
			(param == AUCT_CMD_SHIFT)
		) then
			Auctioneer_SetFilter(cmd, param);
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_ENABLED_ON, cmd, param));
		elseif (param == AUCT_CMD_TOGGLE) then
			local cur = Auctioneer_GetFilterVal(cmd);
			if (cur == "on") then
				cur = "off";
				Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_DISABLE, cmd));
			else
				cur = "on";
				Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_ENABLE, cmd));
			end
			Auctioneer_SetFilter(cmd, cur);
		else
			Auctioneer_SetFilter(cmd, "on");
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_ENABLE, cmd));
		end
	else
		Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_UNKNOWN, cmd));
	end
end

function Auctioneer_GUI_Command(command)
	local i,j, cmd, param = string.find(command, "^([^ ]+) (.+)$");
	if (not cmd) then cmd = command; end
	if (not cmd) then cmd = ""; end
	if (not param) then param = ""; end

		if ((cmd == "") or (cmd == "help")) then
		Auctioneer_ChatPrint("Usage:");
		local onOffToggle = " ("..AUCT_CMD_ON.."|"..AUCT_CMD_OFF.."|"..AUCT_CMD_TOGGLE..")";
		local lineFormat = "  |cffffffff/auctioneer %s "..onOffToggle.."|r |cff2040ff[%s]|r - %s";

		Auctioneer_ChatPrint("  |cffffffff/auctioneer "..onOffToggle.."|r |cff2040ff["..Auctioneer_GetFilterVal("all").."]|r - " .. AUCT_HELP_ONOFF);

		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_VERBOSE, Auctioneer_GetFilterVal(AUCT_SHOW_VERBOSE), AUCT_HELP_VERBOSE));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_AVERAGE, Auctioneer_GetFilterVal(AUCT_SHOW_AVERAGE), AUCT_HELP_AVERAGE));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_MEDIAN, Auctioneer_GetFilterVal(AUCT_SHOW_MEDIAN), AUCT_HELP_MEDIAN));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_SUGGEST, Auctioneer_GetFilterVal(AUCT_SHOW_SUGGEST), AUCT_HELP_SUGGEST));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_STATS, Auctioneer_GetFilterVal(AUCT_SHOW_STATS), AUCT_HELP_STATS));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_VENDOR, Auctioneer_GetFilterVal(AUCT_SHOW_VENDOR), AUCT_HELP_VENDOR));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_VENDOR_SELL, Auctioneer_GetFilterVal(AUCT_SHOW_VENDOR_SELL), AUCT_HELP_VENDOR_SELL));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_VENDOR_BUY, Auctioneer_GetFilterVal(AUCT_SHOW_VENDOR_BUY), AUCT_HELP_VENDOR_BUY));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_USAGE, Auctioneer_GetFilterVal(AUCT_SHOW_USAGE), AUCT_HELP_USAGE));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_STACK, Auctioneer_GetFilterVal(AUCT_SHOW_STACK), AUCT_HELP_STACK));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_LINK, Auctioneer_GetFilterVal(AUCT_SHOW_LINK), AUCT_HELP_LINK));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_AUTOFILL, Auctioneer_GetFilterVal(AUCT_CMD_AUTOFILL), AUCT_HELP_AUTOFILL));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_EMBED, Auctioneer_GetFilterVal(AUCT_CMD_EMBED), AUCT_HELP_EMBED));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_EMBED_BLANK, Auctioneer_GetFilterVal(AUCT_SHOW_EMBED_BLANK), AUCT_HELP_EMBED_BLANK));

		lineFormat = "  |cffffffff/auctioneer %s %s|r |cff2040ff[%s]|r - %s";
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_SHOW_MESH, "("..AUCT_CMD_ON.."|"..AUCT_CMD_OFF.."|"..AUCT_CMD_ALT.."|"..AUCT_CMD_CTRL.."|"..AUCT_CMD_SHIFT..")" ,Auctioneer_GetFilterVal(AUCT_SHOW_MESH), AUCT_HELP_MESH));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_LOCALE, AUCT_OPT_LOCALE, Auctioneer_GetFilterVal('locale'), AUCT_HELP_LOCALE));

		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_MARKUP, AUCT_OPT_PCT_MARKUP, Auctioneer_GetFilterVal(AUCT_CMD_PCT_MARKUP, AUCT_OPT_PCT_MARKUP_DEFAULT), AUCT_HELP_PCT_MARKUP));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_BIDMARKDOWN, AUCT_OPT_PCT_BIDMARKDOWN, Auctioneer_GetFilterVal(AUCT_CMD_PCT_BIDMARKDOWN, AUCT_OPT_PCT_BIDMARKDOWN_DEFAULT), AUCT_HELP_PCT_BIDMARKDOWN));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_NOCOMP, AUCT_OPT_PCT_NOCOMP, Auctioneer_GetFilterVal(AUCT_CMD_PCT_NOCOMP, AUCT_OPT_PCT_NOCOMP_DEFAULT), AUCT_HELP_PCT_NOCOMP));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_UNDERLOW, AUCT_OPT_PCT_UNDERLOW, Auctioneer_GetFilterVal(AUCT_CMD_PCT_UNDERLOW, AUCT_OPT_PCT_UNDERLOW_DEFAULT), AUCT_HELP_PCT_UNDERLOW));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_UNDERMKT, AUCT_OPT_PCT_UNDERMKT, Auctioneer_GetFilterVal(AUCT_CMD_PCT_UNDERMKT, AUCT_OPT_PCT_UNDERMKT_DEFAULT), AUCT_HELP_PCT_UNDERMKT));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PCT_MAXLESS, AUCT_OPT_PCT_MAXLESS, Auctioneer_GetFilterVal(AUCT_CMD_PCT_MAXLESS, AUCT_OPT_PCT_MAXLESS_DEFAULT), AUCT_HELP_PCT_MAXLESS));

		lineFormat = "  |cffffffff/auctioneer %s %s|r - %s";
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_CLEAR, AUCT_OPT_CLEAR, AUCT_HELP_CLEAR));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_ALSO, AUCT_OPT_ALSO, AUCT_HELP_ALSO));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_BROKER, AUCT_OPT_BROKER, AUCT_HELP_BROKER));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_BIDBROKER, AUCT_OPT_BIDBROKER, AUCT_HELP_BIDBROKER));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_PERCENTLESS, AUCT_OPT_PERCENTLESS, AUCT_HELP_PERCENTLESS));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_COMPETE, AUCT_OPT_COMPETE, AUCT_HELP_COMPETE));
		Auctioneer_ChatPrint(string.format(lineFormat, AUCT_CMD_SCAN, AUCT_OPT_SCAN, AUCT_HELP_SCAN));
	
	
	elseif (cmd == "on") then
		Auctioneer_SetFilter("all", "on");
	elseif (cmd == "off") then
		Auctioneer_SetFilter("all", "off");
	elseif (cmd == "toggle") then
		local cur = Auctioneer_GetFilterVal("all");
		if (cur == "off") then
			Auctioneer_SetFilter("all", "on");
		else
			Auctioneer_SetFilter("all", "off");
		end
	elseif (cmd == "clear") then
		if (param == "all") then
			local aKey = auctionKey();
			AuctionPrices[aKey] = {};
			AHSnapshot = {};
			AHSnapshot[auctionKey()] = {};
			AHSnapshotItemPrices = {};
			AHSnapshotItemPrices[auctionKey()] = {};
		elseif (param == "snapshot") then
			AHSnapshot = {};
			AHSnapshot[auctionKey()] = {};
			AHSnapshotItemPrices = {};  
			AHSnapshotItemPrices[auctionKey()] = {};
			lSnapshotItemPrices = {}; 
		--Currently not possible in Khaos
		else
			local items = Auctioneer_GetItems(param);
			for _,itemKey in items do
				local aKey = auctionKey();
				if (AuctionPrices[aKey][itemKey] ~= nil) then
					AuctionPrices[aKey][itemKey] = nil;
					Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_CLEAR_OK, itemKey));
				else
					Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_CLEAR_FAIL, itemKey));
				end
			end
		
		end
	elseif (cmd == "also") then
		if (param == "opposite") then
			param = "opposite";
		elseif (param == "opposite") then
			param = "";
		elseif (param == "") then
			param = "";
		end
		if (not isValidAlso(param)) then
			return
		end
		Auctioneer_SetFilter("also", param);
	elseif (cmd == "locale") then
		if (AUCT_VALID_LOCALES[param]) then
			Auctioneer_SetFilter('locale', param);
			Auctioneer_SetLocaleStrings(Auctioneer_GetLocale());
			Auctioneer_BuildBaseData();
		elseif (param == '') or (param == 'default') or (param == 'off') then
			Auctioneer_SetFilter('locale', 'default');
			Auctioneer_SetLocaleStrings(Auctioneer_GetLocale());
		--To implement later.
		
		else
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_UNKNOWN_LOCALE, param));
			for locale, _ in AUCT_VALID_LOCALES do
				Auctioneer_ChatPrint("  "..locale);
			end
		end
	
	--TODO: Implement with the Earth library.
	
	elseif (cmd == AUCT_CMD_BROKER) then
		doBroker(param);
	elseif (cmd == AUCT_CMD_BIDBROKER) or (cmd == AUCT_CMD_BIDBROKER_SHORT) then
		doBidBroker(param);
	elseif (cmd == AUCT_CMD_PERCENTLESS) or (cmd == AUCT_CMD_PERCENTLESS_SHORT) then
		doPercentLess(param);
	elseif (cmd == AUCT_CMD_COMPETE) then
		doCompeting(param);
	elseif (cmd == AUCT_CMD_SCAN) then
		Auctioneer_RequestAuctionScan();
	elseif (cmd == "test") then
		doTest(param);
	elseif (cmd == "low") then
		doLow(param);
	elseif (cmd == "med") then
		doMedian(param);
	elseif (cmd == "hsp") then
		doHSP(param);
	elseif (
		(cmd == "pct-bidmarkdown") or
		(cmd == "pct-markup") or
		(cmd == "pct-maxless") or
		(cmd == "pct-nocomp") or
		(cmd == "pct-underlow") or
		(cmd == "pct-undermkt")
	) then
		local paramVal = tonumber(param);
		Auctioneer_SetFilter(cmd, paramVal);
	
	
	elseif (
		(cmd == "show-verbose") or 
		(cmd == "show-average") or 
		(cmd == "show-median") or
		(cmd == "show-suggest") or 
		(cmd == "show-stats") or 
		(cmd == "show-vendor") or 
		(cmd == "show-usage") or 
		(cmd == "show-stack") or 
		(cmd == "show-vendor-sell") or 
		(cmd == "show-vendor-buy") or 
		(cmd == "show-link") or 
		(cmd == "embed") or 
		(cmd == "autofill") or 
		(cmd == "show-embed-blankline") or 
		(cmd == "show-hsp")
	) then
		if (param == "off") then
			Auctioneer_SetFilter(cmd, "off");
		elseif (param == "toggle") then
			local cur = Auctioneer_GetFilterVal(cmd);
			if (cur == "on") then
				cur = "off";
			else
				cur = "on";
			end
			Auctioneer_SetFilter(cmd, cur);
		else
			Auctioneer_SetFilter(cmd, "on");
		end
	elseif (cmd == "show-mesh") then
		if (param == "off") then
			Auctioneer_SetFilter(cmd, "off");
		elseif (
			(param == "alt") or
			(param == "ctrl") or
			(param == "shift")
		) then
			Auctioneer_SetFilter(cmd, param);
		elseif (param == "toggle") then
			local cur = Auctioneer_GetFilterVal(cmd);
			if (cur == "on") then
				cur = "off";
			else
				cur = "on";
			end
			Auctioneer_SetFilter(cmd, cur);
		else
			Auctioneer_SetFilter(cmd, "on");
		end
	elseif (cmd == "nil") then
		--Do Nothing :)	
	else
		--Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_UNKNOWN, cmd));
	end
	
end

function Auctioneer_SetFilter(type, value)
	if (not AuctionConfig.filters) then AuctionConfig.filters = {}; end
	AuctionConfig.filters[type] = value;
end

function Auctioneer_GetFilterVal(type, default)
	if (default == nil) then default = "on"; end
	if (not AuctionConfig.filters) then AuctionConfig.filters = {}; end
	value = AuctionConfig.filters[type];
	if (not value) then
		if (type == AUCT_SHOW_LINK) then return "off"; end
		if (type == AUCT_CMD_EMBED) then return "off"; end
		return default;
	end
	return value;
end

function Auctioneer_GetFilter(filter)
	value = Auctioneer_GetFilterVal(filter);
	if (value == "on") then return true;
	elseif (value == "off") then return false; end
	return true;
end

function Auctioneer_ChatPrint(str)
	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage(str, 0.0, 1.0, 0.25);
	end
end


function Auctioneer_Auctions_Clear()
	for i = 1, 5 do
		getglobal("AuctionInfoText"..i):Hide();
		getglobal("AuctionInfoMoney"..i):Hide();
	end
	AuctionInfoWarnText:Hide();
end

function Auctioneer_Auctions_SetWarn(textStr)
	if (AuctionInfoWarnText == nil) then p("Error, no text for AuctionInfo line "..line); end
	AuctionInfoWarnText:SetText(textStr);
	AuctionInfoWarnText:SetTextColor(0.9, 0.4, 0.0);
	AuctionInfoWarnText:Show();
end

function Auctioneer_Auctions_SetLine(line, textStr, moneyAmount)
	local text = getglobal("AuctionInfoText"..line);
	local money = getglobal("AuctionInfoMoney"..line);
	if (text == nil) then p("Error, no text for AuctionInfo line "..line); end
	if (money == nil) then p("Error, no money for AuctionInfo line "..line); end
	text:SetText(textStr);
	text:Show();
	if (money ~= nil) then
		MoneyFrame_Update("AuctionInfoMoney"..line, math.floor(nullSafe(moneyAmount)));
		getglobal("AuctionInfoMoney"..line.."SilverButtonText"):SetTextColor(1.0,1.0,1.0);
		getglobal("AuctionInfoMoney"..line.."CopperButtonText"):SetTextColor(0.86,0.42,0.19);
		money:Show();
	else
		money:Hide();
	end
end

function Auctioneer_GetItemLinks(str)
	local itemList = {};
	local listSize = 0;
	for link, item in string.gfind(str, "|Hitem:([^|]+)|h[[]([^]]+)[]]|h") do
		listSize = listSize+1;
		itemList[listSize] = item.." = "..link;
	end
	return itemList;
end


function Auctioneer_GetItems(str)
	local itemList = {};
	local listSize = 0;
	for itemLink in string.gfind(str, "|Hitem:([^|]+)|h[[][^]]+[]]|h") do
		local itemID, randomProp, enchant, uniqID, lame = breakLink(link);
		local itemKey = itemID..":"..randomProp..":"..enchant;
		listSize = listSize+1;
		itemList[listSize] = itemKey;
	end
	return itemList;
end

function Auctioneer_FindItemInBags(findName)
	for bag = 0, 4, 1 do
		size = GetContainerNumSlots(bag);
		if (size) then
			for slot = size, 1, -1 do
				local link = GetContainerItemLink(bag, slot);
				if (link) then
					local itemID, randomProp, enchant, uniqID, itemName = breakLink(link);
					if (itemName == findName) then
						return bag, slot, itemID, randomProp, enchant, uniqID;
					end
				end
			end
		end
	end
end

function Auctioneer_OnEvent(event)
--	p("Event", event);
	if (event=="NEW_AUCTION_UPDATE") then
		local name, texture, count, quality, canUse, price = GetAuctionSellItemInfo()

		if (not name) then
			Auctioneer_Auctions_Clear()
			return
		end

		local bag, slot, id, rprop, enchant, uniq = Auctioneer_FindItemInBags(name);
		if (bag == nil) then
			-- is the item one of your bags?
			local i
			for i = 0, 4, 1 do
				if name == GetBagName(i) then
					id, rprop, enchant, uniq = breakLink(GetInventoryItemLink("player", ContainerIDToInventoryID(i)))
					break
				end
			end
		end

		-- still no corresponding item found?
		if id == nil then
			Auctioneer_Auctions_Clear()
			return
		end

		local startPrice, buyoutPrice;
		local itemKey = id..":"..rprop..":"..enchant;
		local itemData = getAuctionPriceData(itemKey, nil, name, id);
		local aCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = getAuctionPrices(itemData);

		-- find the current lowest buyout for 1 of these in the current snapshot
		local currentLowestBuyout = findLowestAuctionForItem(itemKey)
		if currentLowestBuyout then
			_,_,_,_,lowStackCount,_,currentLowestBuyout = getItemSignature(currentLowestBuyout);
			currentLowestBuyout = currentLowestBuyout / lowStackCount;
		end

		local historicalMedian, historicalMedCount = getItemHistoricalMedianBuyout(itemKey, name);
		local snapshotMedian, snapshotMedCount = getItemSnapshotMedianBuyout(itemKey);

		Auctioneer_Auctions_Clear();
		Auctioneer_Auctions_SetLine(1, string.format(AUCT_FRMT_AUCTINFO_HIST, historicalMedCount), historicalMedian * count); 
		Auctioneer_Auctions_SetLine(2, string.format(AUCT_FRMT_AUCTINFO_SNAP, snapshotMedCount), snapshotMedian * count); 
		if (snapshotMedCount and snapshotMedCount > 0 and currentLowestBuyout) then
			Auctioneer_Auctions_SetLine(3, AUCT_FRMT_AUCTINFO_LOW, currentLowestBuyout * count);
		else
			Auctioneer_Auctions_SetLine(3, AUCT_FRMT_AUCTINFO_NOLOW);
		end
		local blizPrice = MoneyInputFrame_GetCopper(StartPrice);

		-- calculates the suggested prices
		local hsp, hspCount, mktPrice, warn = Auctioneer_GetHighestSellablePriceForOne(itemKey, false, auctionKey());
		if hsp == 0 and buyCount > 0 then
			hsp = math.floor(buyPrice / buyCount); -- use mean buyout if median not available
		end
		local discountBidPercent = tonumber(Auctioneer_GetFilterVal(AUCT_CMD_PCT_BIDMARKDOWN, AUCT_OPT_PCT_BIDMARKDOWN_DEFAULT));
		local countFix = count
		if countFix == 0 then
			countFix = 1
		end
		local buyPrice = roundDownTo95(nullSafe(hsp) * countFix);
		local bidPrice = roundDownTo95(subtractPercent(buyPrice, discountBidPercent));

		if (Auctioneer_GetFilter(AUCT_CMD_AUTOFILL)) then
			Auctioneer_Auctions_SetLine(4, AUCT_FRMT_AUCTINFO_MKTPRICE, nullSafe(mktPrice)*countFix);
			Auctioneer_Auctions_SetLine(5, AUCT_FRMT_AUCTINFO_ORIG, blizPrice);
			Auctioneer_Auctions_SetWarn(warn);
			MoneyInputFrame_SetCopper(StartPrice, bidPrice);
			MoneyInputFrame_SetCopper(BuyoutPrice, buyPrice);
		else
			Auctioneer_Auctions_SetLine(4, AUCT_FRMT_AUCTINFO_SUGBID, bidPrice);
			Auctioneer_Auctions_SetLine(5, AUCT_FRMT_AUCTINFO_SUGBUY, buyPrice);
			Auctioneer_Auctions_SetWarn(warn);
		end
	elseif (event=="AUCTION_HOUSE_SHOW") then
		Auctioneer_ConfigureAH();
		if Auctioneer_isScanningRequested then
			Auctioneer_StartAuctionScan();
		else
			AuctionsShortAuctionButton:SetChecked(nil);
			AuctionsMediumAuctionButton:SetChecked(nil);
			AuctionsLongAuctionButton:SetChecked(nil);

			-- default to 24 hour auctions
			AuctionsLongAuctionButton:SetChecked(1);
			AuctionFrameAuctions.duration = 1440;
		end
	elseif(event == "AUCTION_HOUSE_CLOSED") then
		if Auctioneer_isScanningRequested then
			Auctioneer_StopAuctionScan();
		end
	elseif(event == "AUCTION_ITEM_LIST_UPDATE" and Auctioneer_isScanningRequested) then
		Auctioneer_ScanAuction();

	elseif (event == "VARIABLES_LOADED") then
		Auctioneer_ConvertData()
		Auctioneer_SetLocaleStrings(Auctioneer_GetLocale());
		Auctioneer_BuildBaseData();
	end
end

function dump(...)
	local out = "";
	for i = 1, arg.n, 1 do
		local d = arg[i];
		local t = type(d);
		if (t == "table") then
			out = out .. "{";
			local first = true;
			for k, v in d do
				if (not first) then out = out .. ", "; end
				first = false;
				out = out .. dump(k);
				out = out .. " = ";
				out = out .. dump(v);
			end
			out = out .. "}";
		elseif (t == "nil") then
			out = out .. "NIL";
		elseif (t == "number") then
			out = out .. d;
		elseif (t == "string") then
			out = out .. "\"" .. d .. "\"";
		elseif (t == "boolean") then
			if (d) then
				out = out .. "true";
			else
				out = out .. "false";
			end
		else
			out = out .. string.upper(t) .. "??";
		end

		if (i < arg.n) then out = out .. ", "; end
	end
	return out;
end

function p(...)
	local out = "";
	for i = 1, arg.n, 1 do
		if (i > 1) then out = out .. ", "; end
		if (type(arg[i]) == "string") then
			out = out .. arg[i];
		else
			out = out .. dump(arg[i]);
		end
	end
	ChatFrame1:AddMessage(out, 1.0, 1.0, 0.0);
end