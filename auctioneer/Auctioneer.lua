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

	Auctioneer_ChatPrint(string.format(AUCTIONEER_AUCTION_TOTAL_AUCTS, colorTextWhite(lTotalAuctionsScannedCount)));
	Auctioneer_ChatPrint(string.format(AUCTIONEER_AUCTION_NEW_AUCTS, colorTextWhite(lNewAuctionsCount)));
	Auctioneer_ChatPrint(string.format(AUCTIONEER_AUCTION_OLD_AUCTS, colorTextWhite(lOldAuctionsCount)));
	Auctioneer_ChatPrint(string.format(AUCTIONEER_AUCTION_DEFUNCT_AUCTS, colorTextWhite(lDefunctAuctionsCount)));

	if (nullSafe(lDiscrepencyCount) > 0) then
		Auctioneer_ChatPrint(string.format(AUCTIONEER_AUCTION_DISCREPANCIES, colorTextWhite(lDiscrepencyCount)));
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
function Auctioneer_isValidAlso(also)
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
		if (Auctioneer_isValidAlso(also)) and (also ~= "off") then
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
		Auctioneer_Command(msg, nil);
	end

	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage(string.format(AUCT_FRMT_WELCOME, AUCTIONEER_VERSION), 0.8, 0.8, 0.2);
	end

	Auctioneer_ConfigureAH();	
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

function Auctioneer_GUI_radioTestCallback(state)

	if (state == "shift") then
		Auctioneer_Command("show-mesh shift", "GUI")

	elseif (state == "ctrl") then
		Auctioneer_Command("show-mesh ctrl", "GUI")

	elseif (state == "alt") then
		Auctioneer_Command("show-mesh ctrl", "GUI")

	elseif (state == "off") then
		Auctioneer_Command("show-mesh on", "GUI")
	end
end


function Auctioneer_GUI_radioTestFeedback(state)

	if ((state == "shift") or (state == "ctrl") or (state == "alt")) then
		return string.format(AUCT_FRMT_ACT_ENABLED_ON, AUCT_SHOW_MESH, state.value);

	else
		return string.format(AUCT_FRMT_ACT_ENABLE, AUCT_SHOW_MESH);
	end
end


function Auctioneer_Register_Khaos()
	
	
	local optionSet = {
		id="Auctioneer";
		text="Auctioneer";
		helptext=AUCTIONEER_GUI_MAIN_HELP;
		difficulty=1;
		default={checked=true};
		options={
			{
				id="Header";
				text="Auctioneer";
				helptext=AUCTIONEER_GUI_MAIN_HELP;
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="AuctioneerEnable";
				type=K_TEXT;
				text=AUCTIONEER_GUI_MAIN_ENABLE;
				helptext=AUCT_HELP_ONOFF;
				callback=function(state) if (state.checked) then Auctioneer_Command("on", "GUI") else Auctioneer_Command("off", "GUI") end end;
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
				text=AUCTIONEER_GUI_LOCALE;
				helptext=AUCT_HELP_LOCALE;
				callback = function(state)
					Auctioneer_Command("locale "..state.value, "GUI");
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, AUCT_CMD_LOCALE, state.value);
				end;
				default = {
					value = Auctioneer_GetLocale();
				};
				disabled = {
					value = Auctioneer_GetLocale();
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=2;				
			};
			{
				id="show-verbose";
				type=K_TEXT;
				text=AUCTIONEER_GUI_VERBOSE;
				helptext=AUCT_HELP_VERBOSE;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-verbose on", "GUI") else Auctioneer_Command("show-verbose off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-verbose")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-verbose")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id="show-stats";
				type=K_TEXT;
				text=AUCTIONEER_GUI_STATS_ENABLE;
				helptext=AUCT_HELP_STATS;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-stats on", "GUI") else Auctioneer_Command("show-stats off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-stats")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-stats")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id="AuctioneerStatsHeader";
				type=K_HEADER;
				text=AUCTIONEER_GUI_STATS_HEADER;
				helptext=AUCTIONEER_GUI_STATS_HELP;
				difficulty=2;
			};
			{
				id="show-average";
				type=K_TEXT;
				text=AUCTIONEER_GUI_AVERAGES;
				helptext=AUCT_HELP_AVERAGE;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-average on", "GUI") else Auctioneer_Command("show-average off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-average")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-average")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			{
				id="show-median";
				type=K_TEXT;
				text=AUCTIONEER_GUI_MEDIAN;
				helptext=AUCT_HELP_MEDIAN;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-median on", "GUI") else Auctioneer_Command("show-median off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-median")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-average")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			{
				id="show-suggest";
				type=K_TEXT;
				text=AUCTIONEER_GUI_SUGGEST;
				helptext=AUCT_HELP_SUGGEST;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-suggest on", "GUI") else Auctioneer_Command("show-suggest off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-suggest")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-suggest")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			{
				id="AuctioneerVendorHeader";
				type=K_HEADER;
				text=AUCTIONEER_GUI_VENDOR_HEADER;
				helptext=AUCTIONEER_GUI_VENDOR_HELP;
				difficulty=1;
			};
			{
				id="show-vendor";
				key="AuctioneerVendor";
				type=K_TEXT;
				text=AUCTIONEER_GUI_VENDOR;
				helptext=AUCT_HELP_VENDOR;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-vendor on", "GUI") else Auctioneer_Command("show-vendor off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-vendor")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-vendor")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id="show-vendor-buy";
				type=K_TEXT;
				text=AUCTIONEER_GUI_VENDOR_BUY;
				helptext=AUCT_HELP_VENDOR_BUY;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-vendor-buy on", "GUI") else Auctioneer_Command("show-vendor-buy off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-vendor-buy")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-vendor-buy")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerVendor={checked=true;}, AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			{
				id="show-vendor-sell";
				type=K_TEXT;
				text=AUCTIONEER_GUI_VENDOR_SELL;
				helptext=AUCT_HELP_VENDOR_SELL;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-vendor-sell on", "GUI") else Auctioneer_Command("show-vendor-sell off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-vendor-sell")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-vendor-sell")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerVendor={checked=true;}, AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			{
				id="AuctioneerEmbedHeader";
				type=K_HEADER;
				text=AUCTIONEER_GUI_EMBED_HEADER;
				helptext=AUCT_HELP_EMBED;
				difficulty=1;
			};
			{
				id="embed";
				key="AuctioneerEmbed";
				type=K_TEXT;
				text=AUCTIONEER_GUI_EMBED;
				helptext=AUCT_HELP_EMBED;
				callback=function(state) if (state.checked) then Auctioneer_Command("embed on", "GUI") else Auctioneer_Command("embed off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "embed")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "embed")) end end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id="show-embed-blankline";
				type=K_TEXT;
				text=AUCTIONEER_GUI_EMBED_BLANKLINE;
				helptext=AUCT_HELP_EMBED_BLANK;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-embed-blankline on", "GUI") else Auctioneer_Command("show-embed-blankline off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-embed-blankline")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-embed-blankline")) end end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				dependencies={AuctioneerEmbed={checked=true;}, AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id="AuctioneerClearHeader";
				type=K_HEADER;
				text=AUCTIONEER_GUI_CLEAR_HEADER;
				helptext=AUCTIONEER_GUI_CLEAR_HELP;
				difficulty=3;
			};
			{
				id="AuctioneerClearAll";
				type=K_BUTTON;
				setup={
					buttonText = AUCTIONEER_GUI_CLEARALL_BUTTON;
				};
				text=AUCTIONEER_GUI_CLEARALL;
				helptext=AUCTIONEER_GUI_CLEARALL_HELP;
				callback=function() Auctioneer_Command("clear all", "GUI") end;
				feedback=string.format(AUCT_FRMT_ACT_CLEARALL,  "for the current server-faction");
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
			{
				id="AuctioneerClearSnapshot";
				type=K_BUTTON;
				setup={
					buttonText=AUCTIONEER_GUI_CLEARSNAP_BUTTON;
				};
				text=AUCTIONEER_GUI_CLEARSNAP;
				helptext=AUCTIONEER_GUI_CLEARSNAP_HELP;
				callback=function() Auctioneer_Command("clear snapshot", "GUI")end;
				feedback=AUCT_FRMT_ACT_CLEARSNAP;
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
			{
				id="AuctioneerPercentsHeader";
				type=K_HEADER;
				text=AUCTIONEER_GUI_PERCENTS_HEADER;
				helptext=AUCTIONEER_GUI_PERCENTS_HELP;
				difficulty=4;
			};
			{
				id="pct-bidmarkdown";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=AUCTIONEER_GUI_BIDMARKDOWN;
				helptext=AUCT_HELP_PCT_BIDMARKDOWN;
				callback = function(state)
					Auctioneer_Command("pct-bidmarkdown "..state.value, "GUI");
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, "pct-bidmarkdown", state.value.."%");
				end;
				default = {
					value = AUCT_OPT_PCT_BIDMARKDOWN_DEFAULT;
				};
				disabled = {
					value = AUCT_OPT_PCT_BIDMARKDOWN_DEFAULT;
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;				
			};
			{
				id="pct-markup";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=AUCTIONEER_GUI_MARKUP;
				helptext=AUCT_HELP_PCT_MARKUP;
				callback = function(state)
					Auctioneer_Command("pct-markup "..state.value, "GUI");
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, "pct-markup", state.value.."%");
				end;
				default = {
					value = AUCT_OPT_PCT_MARKUP_DEFAULT;
				};
				disabled = {
					value = AUCT_OPT_PCT_MARKUP_DEFAULT;
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};
			{
				id="pct-maxless";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=AUCTIONEER_GUI_MAXLESS;
				helptext=AUCT_HELP_PCT_MAXLESS;
				callback = function(state)
					Auctioneer_Command("pct-maxless "..state.value, "GUI");
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, "pct-maxless", state.value.."%");
				end;
				default = {
					value = AUCT_OPT_PCT_MAXLESS_DEFAULT;
				};
				disabled = {
					value = AUCT_OPT_PCT_MAXLESS_DEFAULT;
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};
			{
				id="pct-nocomp";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=AUCTIONEER_GUI_NOCOMP;
				helptext=AUCT_HELP_PCT_NOCOMP;
				callback = function(state)
					Auctioneer_Command("pct-nocomp "..state.value, "GUI");
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, "pct-nocomp", state.value.."%");
				end;
				default = {
					value = AUCT_OPT_PCT_NOCOMP_DEFAULT;
				};
				disabled = {
					value = AUCT_OPT_PCT_NOCOMP_DEFAULT;
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};
			{
				id="pct-underlow";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=AUCTIONEER_GUI_UNDERLOW;
				helptext=AUCT_HELP_PCT_UNDERLOW;
				callback = function(state)
					Auctioneer_Command("pct-underlow "..state.value, "GUI");
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, "pct-underlow", state.value.."%");
				end;
				default = {
					value = AUCT_OPT_PCT_UNDERLOW_DEFAULT;
				};
				disabled = {
					value = AUCT_OPT_PCT_UNDERLOW_DEFAULT;
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};
			{
				id="pct-undermkt";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=AUCTIONEER_GUI_UNDERMKT;
				helptext=AUCT_HELP_PCT_UNDERMKT;
				callback = function(state)
					Auctioneer_Command("pct-undermkt "..state.value, "GUI");
				end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_SET, "pct-undermkt", state.value.."%");
				end;
				default = {
					value = AUCT_OPT_PCT_UNDERMKT_DEFAULT;
				};
				disabled = {
					value = AUCT_OPT_PCT_UNDERMKT_DEFAULT;
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};
			{
				id="AuctioneerOtherHeader";
				type=K_HEADER;
				text=AUCTIONEER_GUI_OTHER_HEADER;
				helptext=AUCTIONEER_GUI_OTHER_HELP;
				difficulty=1;
			};
			{
				id="autofill";
				type=K_TEXT;
				text=AUCTIONEER_GUI_AUTOFILL;
				helptext=AUCT_HELP_AUTOFILL;
				callback=function(state) if (state.checked) then Auctioneer_Command("autofill on", "GUI") else Auctioneer_Command("autofill off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "autofill")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "autofill")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id="AuctioneerInclude";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=AUCTIONEER_GUI_ALSO;
				helptext=AUCT_HELP_ALSO;
				callback = function(state)
					Auctioneer_Command("also "..state.value, "GUI");
				end;
				feedback = function (state)
					if (state.value == opposite) then
						return AUCTIONEER_GUI_ALSO_OPPOSITE;
					elseif (state.value == off) then
						return AUCTIONEER_GUI_ALSO_OFF;
					elseif (not Auctioneer_isValidAlso(param)) then
						string.format(AUCT_FRMT_UNKNOWN_RF, state.value)
					else
						return string.format(AUCTIONEER_GUI_ALSO_DISPLAY, state.value);
					end
				end;
				default = {
					value = AUCT_CMD_OFF;
				};
				disabled = {
					value = AUCT_CMD_OFF;
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			--Oops, not yet implemented :)
			--[[
			{
				id="AuctioneerHSP";
				type=K_TEXT;
				text="Show Highest Sellable Price (HSP)";
				helptext=AUCT_HELP_HSP;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-hsp on", "GUI") else Auctioneer_Command("show-hsp off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-hsp")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-hsp")) end end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				difficulty=3;
			};
			]]--
			{
				id="AuctioneerMesh";
				key="AuctioneerMesh";
				type=K_TEXT;
				text=AUCTIONEER_GUI_MESH;
				helptext=AUCT_HELP_MESH;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-mesh on", "GUI") else Auctioneer_Command("show-mesh off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-mesh")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-mesh")) end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEmbed={checked=false;}, AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
			{
				id="Off";
				key = "MeshModifier";
				text=AUCTIONEER_GUI_MESH_OFF;
				helptext=AUCTIONEER_GUI_MESH_MODIFIER_HELP;
				value = "off";
				radio = true;
				type = K_TEXT;
				default = { value = "off" };
				disabled = { value = "off" };
				callback = function(state) if(state.value == "off") then Auctioneer_Command("show-mesh on", "GUI"); end end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_ENABLE, AUCT_SHOW_MESH);
				end;
				dependencies={AuctioneerMesh={checked=true;}, AuctioneerEmbed={checked=false;}, AuctioneerEnable={checked=true;}};
				setup = { 
					selectedColor={r=0,g=1,b=0};
					disabledColor={r=.5,g=.5,b=.5};
				};
				difficulty=3;
			};
			{
				id="Shift";
				key = "MeshModifier";
				text=AUCTIONEER_GUI_MESH_SHIFT;
				helptext=AUCTIONEER_GUI_MESH_MODIFIER_HELP;
				value = "shift";
				radio = true;
				type = K_TEXT;
				default = { value = "off" };
				disabled = { value = "off" };
				callback = function(state) Auctioneer_Command("show-mesh "..state.value, "GUI"); end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_ENABLED_ON, AUCT_SHOW_MESH, state.value);
				end;
				setup = { 
					selectedColor={r=0,g=1,b=0};
					disabledColor={r=.5,g=.5,b=.5};
				};
				dependencies={AuctioneerMesh={checked=true;}, AuctioneerEmbed={checked=false;}, AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
			{
				id="Ctrl";
				key = "MeshModifier";
				text=AUCTIONEER_GUI_MESH_CTRL;
				helptext=AUCTIONEER_GUI_MESH_MODIFIER_HELP;
				value = "ctrl";
				radio = true;
				type = K_TEXT;
				default = { value = "off" };
				disabled = { value = "off" };
				callback = function(state) Auctioneer_Command("show-mesh "..state.value, "GUI"); end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_ENABLED_ON, AUCT_SHOW_MESH, state.value);
				end;
				setup = { 
					selectedColor={r=0,g=1,b=0};
					disabledColor={r=.5,g=.5,b=.5};
				};
				dependencies={AuctioneerMesh={checked=true;}, AuctioneerEmbed={checked=false;}, AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
			{
				id="Alt";
				key = "MeshModifier";
				text=AUCTIONEER_GUI_MESH_ALT;
				helptext=AUCTIONEER_GUI_MESH_MODIFIER_HELP;
				value = "alt";
				radio = true;
				type = K_TEXT;
				default = { value = "off" };
				disabled = { value = "off" };
				callback = function(state) Auctioneer_Command("show-mesh "..state.value, "GUI"); end;
				feedback = function (state)
					return string.format(AUCT_FRMT_ACT_ENABLED_ON, AUCT_SHOW_MESH, state.value);
				end;
				setup = { 
					selectedColor={r=0,g=1,b=0};
					disabledColor={r=.5,g=.5,b=.5};
				};
				dependencies={AuctioneerMesh={checked=true;}, AuctioneerEmbed={checked=false;}, AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
			{
				id="show-link";
				type=K_TEXT;
				text=AUCTIONEER_GUI_LINK;
				helptext=AUCT_HELP_LINK;
				callback=function(state) if (state.checked) then Auctioneer_Command("show-link on", "GUI") else Auctioneer_Command("show-link off", "GUI") end end;
				feedback=function(state) if (state.checked) then return (string.format(AUCT_FRMT_ACT_ENABLE, "show-link")) else return (string.format(AUCT_FRMT_ACT_DISABLE, "show-link")) end end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
			{
				id="ReloadUI";
				type=K_BUTTON;
				setup={
					buttonText = AUCTIONEER_GUI_RELOADUI_BUTTON;
				};
				text=AUCTIONEER_GUI_RELOADUI;
				helptext=AUCTIONEER_GUI_RELOADUI_HELP;
				callback=function() ReloadUI() end;
				feedback=AUCTIONEER_GUI_RELOADUI_FEEDBACK;
				difficulty=4;
			};
		};
	};

	Khaos.registerOptionSet("tooltip",optionSet);
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

--Cleaner Command Handling Functions (added by MentalPower)
function Auctioneer_Command(command, source)
	
	--To print or not to print, that is the question...
	local chatprint = nil;
	if (source == "GUI") then 
		chatprint = false;
	else 
		chatprint = true;
	end;
	
	--Divide the large command into smaller logical sections (Shameless copy from the original function)
	local i,j, cmd, param = string.find(command, "^([^ ]+) (.+)$");

	if (not cmd) then
		cmd = command;
	end

	if (not cmd) then
		cmd = "";
	end

	if (not param) then
		param = "";
	end

	--Now for the real Command handling
	if ((cmd == "") or (cmd == "help")) then
		Auctioneer_ChatPrint_Help();
		return;

	elseif (((cmd == AUCT_CMD_ON) or (cmd == "on")) or ((cmd == AUCT_CMD_OFF) or (cmd == "off")) or ((cmd == AUCT_CMD_TOGGLE) or (cmd == "toggle"))) then
		Auctioneer_OnOff(cmd, chatprint);

	elseif ((cmd == AUCT_CMD_CLEAR) or (cmd == "clear")) then
		Auctioneer_Clear(param, chatprint);

	elseif ((cmd == AUCT_CMD_ALSO) or (cmd == "also")) then
		Auctioneer_AlsoInclude(param, chatprint);
	
	elseif ((cmd == AUCT_CMD_LOCALE) or (cmd == "locale")) then
		Auctioneer_SetLocale(param, chatprint);

	--The following are copied verbatim from the original function. These functions are not supported in the current Khaos-based GUI implementation and as such have been left intact.
	elseif ((cmd == AUCT_CMD_BROKER) or (cmd == "broker")) then
		doBroker(param);

	elseif (cmd == AUCT_CMD_BIDBROKER) or (cmd == AUCT_CMD_BIDBROKER_SHORT) then
		doBidBroker(param);

	elseif (cmd == AUCT_CMD_PERCENTLESS) or (cmd == AUCT_CMD_PERCENTLESS_SHORT) then
		doPercentLess(param);

	elseif ((cmd == AUCT_CMD_COMPETE) or (cmd == "compete")) then
		doCompeting(param);

	elseif ((cmd == AUCT_CMD_SCAN) or (cmd == "scan")) then
		Auctioneer_RequestAuctionScan();

	elseif (cmd == "test") then
		doTest(param);

	elseif (cmd == "low") then
		doLow(param);

	elseif (cmd == "med") then
		doMedian(param);

	elseif (cmd == "hsp") then
		doHSP(param);

	--We now return to our regular programming.
	elseif ((cmd == AUCT_SHOW_MESH) or ( cmd == "show-mesh")) then
		Auctioneer_MeshOnOff(param, chatprint);

	elseif (
		((cmd == AUCT_CMD_EMBED) or (cmd == "embed")) or
		((cmd == AUCT_CMD_AUTOFILL) or (cmd == "autofill")) or
		((cmd == AUCT_SHOW_VERBOSE) or (cmd == "show-verbose")) or
		((cmd == AUCT_SHOW_AVERAGE) or (cmd == "show-average")) or
		((cmd == AUCT_SHOW_LINK) or (cmd == "show-link")) or
		((cmd == AUCT_SHOW_MEDIAN) or (cmd == "show median")) or
		((cmd == AUCT_SHOW_STACK) or (cmd == "show-stack")) or
		((cmd == AUCT_SHOW_STATS) or (cmd == "show-stats")) or
		((cmd == AUCT_SHOW_SUGGEST) or (cmd == "show-suggest")) or
		((cmd == AUCT_SHOW_USAGE) or (cmd == "show-usage")) or
		((cmd == AUCT_SHOW_VENDOR) or (cmd == "show-vendor")) or
		((cmd == AUCT_SHOW_VENDOR_BUY) or (cmd == "show-vendor-buy")) or
		((cmd == AUCT_SHOW_VENDOR_SELL) or (cmd == "show-vendor-sell")) or		
		((cmd == AUCT_SHOW_EMBED_BLANK) or (cmd == "show-embed-blankline")) or
		((cmd == AUCT_SHOW_HSP) or (cmd == "show-hsp")) --This command has not yet been implemented.
	) then
		Auctioneer_GenVarSet(cmd, param, chatprint);

	elseif (
		((cmd == AUCT_CMD_PCT_BIDMARKDOWN) or(cmd == "pct-bidmarkdown")) or
		((cmd == AUCT_CMD_PCT_MARKUP) or(cmd == "pct-markup")) or
		((cmd == AUCT_CMD_PCT_MAXLESS) or(cmd == "pct-maxless")) or
		((cmd == AUCT_CMD_PCT_NOCOMP) or(cmd == "pct-nocomp")) or
		((cmd == AUCT_CMD_PCT_UNDERLOW) or(cmd == "pct-underlow")) or
		((cmd == AUCT_CMD_PCT_UNDERMKT) or (cmd == "pct-undermkt"))
	) then
		Auctioneer_PercentVarSet(cmd, param, chatprint);

	else
		if (chatprint == true) then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_UNKNOWN, cmd));
		end
	end
end

--Help ME!! (The Handler) (Another shameless copy from the original function)
function Auctioneer_ChatPrint_Help()

	local onOffToggle = " ("..AUCT_CMD_ON.."|"..AUCT_CMD_OFF.."|"..AUCT_CMD_TOGGLE..")";
	local lineFormat = "  |cffffffff/auctioneer %s "..onOffToggle.."|r |cff2040ff[%s]|r - %s";

	Auctioneer_ChatPrint(AUCT_TEXT_USAGE);
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

end

--The Auctioneer_OnOff(state, chatprint) function handles the state of the Auctioneer AddOn (whether it is currently on or off)
--If "on" or "off" is specified in the " state" variable then Auctioneer's state is changed to that value,
--If "toggle" is specified then it will toggle Auctioneer's state (if currently on then it will be turned off and vice-versa)
--If no keyword is specified then the functione will simply return the current state
--
--If chatprint is "true" then the state will also be printed to the user.

function Auctioneer_OnOff(state, chatprint)

	if ((state == nil) or (state == "")) then
		state = Auctioneer_GetFilterVal("all");


	elseif ((state == AUCT_CMD_ON) or (state == "on")) then
		Auctioneer_SetFilter("all", "on");


	elseif ((state == AUCT_CMD_OFF) or (state == "off")) then
		Auctioneer_SetFilter("all", "off");


	elseif ((state == AUCT_CMD_TOGGLE) or (state == "toggle")) then
		state = Auctioneer_GetFilterVal("all");
		
		if (state == "off") then
			Auctioneer_SetFilter("all", "on");
		else
			Auctioneer_SetFilter("all", "off");
		end
	end

	--Print the change and alert the GUI if the command came from slash commands. Do nothing if they came from the GUI.
	if (chatprint == true) then
		if ((state == AUCT_CMD_ON) or (state == "on")) then
			Auctioneer_ChatPrint(AUCT_STAT_ON);

			if (Khaos) then
				Khaos.setSetKeyParameter("Auctioneer", "AuctioneerEnable", "checked", true);
			end
		else
			Auctioneer_ChatPrint(AUCT_STAT_OFF);

			if (Khaos) then
				Khaos.setSetKeyParameter("Auctioneer", "AuctioneerEnable", "checked", false);
			end
		end
	end

	return state;	
end

--The following functions are almost verbatim copies of the original functions but modified in order to make them compatible with direct GUI access.
function Auctioneer_Clear(param, chatprint)

	local aKey = auctionKey();
	local clearok = nil;

	if ((param == AUCT_CMD_CLEAR_ALL) or (param == "all")) then

		AuctionPrices[aKey] = {};
		AHSnapshot = {};
		AHSnapshot[aKey] = {};
		AHSnapshotItemPrices = {};
		AHSnapshotItemPrices[aKey] = {};


	elseif ((param == AUCT_CMD_CLEAR_SNAPSHOT) or (param == "snapshot")) then

		AHSnapshot = {};
		AHSnapshot[aKey] = {};
		AHSnapshotItemPrices = {};
		AHSnapshotItemPrices[aKey] = {};
		lSnapshotItemPrices = {};

	else

		local items = Auctioneer_GetItems(param);
		for _,itemKey in items do
			if (AuctionPrices[aKey][itemKey] ~= nil) then
				AuctionPrices[aKey][itemKey] = nil;
				clearok = true;
			else
				clearok = false;
			end
		end
	end

	if (chatprint == true) then

		if ((param == AUCT_CMD_CLEAR_ALL) or (param == "all")) then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_CLEARALL, aKey));
			
		elseif ((param == AUCT_CMD_CLEAR_SNAPSHOT) or (param == "snapshot")) then
			Auctioneer_ChatPrint(AUCT_FRMT_ACT_CLEARSNAP);

		else
			if (clearok == true) then
				Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_CLEAR_OK, itemKey));
			else
				Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_CLEAR_FAIL, itemKey));
			end
		end
	end
end


function Auctioneer_AlsoInclude(param, chatprint)

	if ((param == AUCT_CMD_ALSO_OPPOSITE) or (param == "opposite")) then
		param = "opposite";
	end

	if (not Auctioneer_isValidAlso(param)) then

		if (chatprint == true) then 
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_UNKNOWN_RF, param));
		end
		return
	end
	
	Auctioneer_SetFilter("also", param);
	
	if (chatprint == true) then 
		
		if (Khaos) then 
			Khaos.setSetKeyParameter("Auctioneer", "AuctioneerInclude", "value", param);
		end

		if ((param == AUCT_CMD_OFF) or (param == "off")) then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_DISABLE, AUCT_CMD_ALSO));	

		else
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_SET, AUCT_CMD_ALSO, param));
		end	
	end
end


function Auctioneer_SetLocale(param, chatprint)

local validLocale=nil;

	if (param == Auctioneer_GetLocale()) then
		--Do Nothing
		validLocale=true;
	elseif (AUCT_VALID_LOCALES[param]) then
		Auctioneer_SetFilter('locale', param);
		Auctioneer_SetLocaleStrings(Auctioneer_GetLocale());
		Auctioneer_BuildBaseData();
		validLocale=true;

	elseif (param == '') or (param == 'default') or (param == 'off') then
		Auctioneer_SetFilter('locale', 'default');
		Auctioneer_SetLocaleStrings(Auctioneer_GetLocale());
		validLocale=true;
	end
	
	
	if (chatprint == true) then

		if ((validLocale == true) and (AUCT_VALID_LOCALES[param])) then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_SET, AUCT_CMD_LOCALE, param));
			
			if (Khaos) then
				Khaos.setSetKeyParameter("Auctioneer", "AuctioneerLocale", "value", param);
			end

		elseif (validLocale == nil) then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_UNKNOWN_LOCALE, param));
			for locale, _ in AUCT_VALID_LOCALES do
				Auctioneer_ChatPrint("  "..locale);
			end

		else
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_SET, AUCT_CMD_LOCALE, 'default'));
			
			if (Khaos) then
				Khaos.setSetKeyParameter("Auctioneer", "AuctioneerLocale", "value", "default");
			end
		end
	end
end


function Auctioneer_MeshOnOff(param, chatprint)

	if ((param == AUCT_CMD_ON) or (param == "on")) then
		Auctioneer_SetFilter("show-mesh", "on");

	elseif ((param == AUCT_CMD_OFF) or (param == "off")) then
		Auctioneer_SetFilter("show-mesh", "off");

	elseif ((param == AUCT_CMD_TOGGLE) or (param == "toggle")) then
		param = Auctioneer_GetFilterVal("show-mesh");

		if (param == "on") then
			param = "off";
		else
			param = "on";
		end
		Auctioneer_SetFilter("show-mesh", param);

	--If it's alt, ctrl or shift then
	else
		Auctioneer_SetFilter("show-mesh", param);
	end

	if (chatprint == true) then

		if ((param == AUCT_CMD_ON) or (param == "on")) then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_ENABLE, AUCT_SHOW_MESH));
			
			if (Khaos) then
				Khaos.setSetKeyParameter("Auctioneer", "AuctioneerMesh", "checked", true);
			end

		elseif ((param == AUCT_CMD_OFF) or (param == "off")) then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_DISABLE, AUCT_SHOW_MESH));
			
			if (Khaos) then
				Khaos.setSetKeyParameter("Auctioneer", "AuctioneerMesh", "checked", false);
			end

		--If it's alt, ctrl or shift then
		else
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_ENABLED_ON, AUCT_SHOW_MESH, param));
		end
	end
end


function Auctioneer_GenVarSet(variable, param, chatprint)

	if ((param == AUCT_CMD_ON) or (param == "on")) then
		Auctioneer_SetFilter(variable, "on");

	elseif ((param == AUCT_CMD_OFF) or (param == "off")) then
		Auctioneer_SetFilter(variable, "off");

	elseif ((param == AUCT_CMD_TOGGLE) or (param == nil) or (param == "")) then
		param = Auctioneer_GetFilterVal(variable);

		if (param == "on") then
			param = "off";
		else
			param = "on";
		end
		Auctioneer_SetFilter(variable, param);
	end

	if (chatprint == true) then	

		if ((param == AUCT_CMD_ON) or (param == "on")) then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_ENABLE, variable));

			--Account for different key name in the embed variable
			if ((variable == AUCT_CMD_EMBED) or (variable == "embed")) then
				
				if (Khaos) then
					Khaos.setSetKeyParameter("Auctioneer", "AuctioneerEmbed", "checked", true);
				end
			else
				
				if (Khaos) then
					Khaos.setSetKeyParameter("Auctioneer", variable, "checked", true);
				end
			end

		elseif ((param == AUCT_CMD_OFF) or (param == "off")) then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_DISABLE, variable));

			--Account for different key name in the embed variable
			if ((variable == AUCT_CMD_EMBED) or (variable == "embed")) then
				
				if (Khaos) then
					Khaos.setSetKeyParameter("Auctioneer", "AuctioneerEmbed", "checked", false);
				end
			else
				
				if (Khaos) then
					Khaos.setSetKeyParameter("Auctioneer", variable, "checked", false);
				end
			end
		end
	end
end


function Auctioneer_PercentVarSet(variable, param, chatprint)

	local paramVal = tonumber(param);
	if paramVal == nil then
		-- failed to convert the param to a number
		if chatprint then
			Auctioneer_ChatPrint(string.format(AUCT_FRMT_UNKNOWN_ARG, param, variable))
		end
		return -- invalid argument, don't do anything
	end
	-- param is a valid number, save it
	Auctioneer_SetFilter(variable, paramVal);

	if (chatprint == true) then
		Auctioneer_ChatPrint(string.format(AUCT_FRMT_ACT_SET, variable, paramVal.."%"));
		
		if (Khaos) then
			Khaos.setSetKeyParameter("Auctioneer", variable, "value", paramVal);
		end
	end
end

--This marks the end of the New Command processing code.
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
		
		--GUI Registration code added by MentalPower	
		Auctioneer_Register();
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