--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$

	BeanCounterAPI - Functions for other addons to get BeanCounter Data
	URL: http://auctioneeraddon.com/

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
		You have an implicit license to use this AddOn with these facilities
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
LibStub("LibRevision"):Set("$URL$","$Rev$","5.1.DEV.", 'auctioneer', 'libs')

local lib = BeanCounter
lib.API = {}
local private = lib.Private
local private, print, get, set, _BC = lib.getLocals()

local function debugPrint(...)
    if get("util.beancounter.debugAPI") then
        private.debugPrint("BeanCounterAPI",...)
    end
end
--[[External Search Stub, allows other addons searches to search to display in BC or get results of a BC search
Can be item Name or Link or itemID
If itemID or Link search will be faster than a plain text lookup
]]
local _
function lib.API.search(name, settings, queryReturn)
	if get("util.beancounter.externalSearch") then --is option enabled and have we already searched for this name (stop spam)
		--check for blank search request
		if name == "" and not queryReturn then return end
		name = tostring(name)
		
		--serverName is used as part of our cache ID string
		local serverName
		if settings and settings.servers and settings.servers[1] then
			serverName = settings.servers[1]
		else
			serverName = GetRealmName()
		end
		
		--playerName is also used as part of our cache ID string
		local playerName
		if settings and settings.selectbox and settings.selectbox[2] then
			playerName = settings.selectbox[2]
		else
			playerName = "server"
		end

		--the function getItemInfo will return a plain text name on itemID or itemLink searches and nil if a plain text search is passed
		local itemID, itemLink, itemName		
		itemID, itemLink = private.getItemInfo(name, "itemid")
		if not itemLink then 
			itemName = name
		else
			_, itemName =  lib.API.getItemString(itemLink)
		end
		
		local cached = private.checkSearchCache(itemName, serverName, playerName)
		--return cached search
		if queryReturn and cached then
			return cached
		end
		
		if not settings then
			settings = {["selectbox"] = {"1", "server"}, ["exact"] = false, ["bid"] = true, ["auction"] = true}
		end
	
		--search data
		if itemLink then
			--itemKey is used to filter results if exact is used. We need the key to remove of the XXX style items from returns
			_, settings.suffix = lib.API.decodeLink(itemLink)
			if settings.suffix == 0 then settings.suffix = nil end
			--cache search request
			private.searchByItemID(itemID, settings, queryReturn, nil, nil, itemName)
		else
			private.startSearch(itemName, settings, queryReturn)
		end
		--return data or displayItemName in select box
		if queryReturn then
			return private.checkSearchCache(itemName, serverName, playerName)
		else
			private.frame.searchBox:SetText(itemName)
		end
	end
end
--Cache system for searches

function private.checkSearchCache(name, serverName, playerName)
	local SearchCache = private.SearchCache
	--return cached search
	name = name:lower() --lower case names for better matching
	if SearchCache[name..serverName..playerName] then
		debugPrint("cached used", name, serverName, playerName  )
		return SearchCache[name..serverName..playerName]
	end
end
function private.addSearchCache(name, data, serverName, playerName)
	local SearchCache = private.SearchCache
	--remove oldest cache entry, only save 5 searches
	if #SearchCache >= 10 then
		--debugPrint("removing",  SearchCache[1] )
		SearchCache[ SearchCache[1] ] = nil
		table.remove(SearchCache, 1)
	end
	--store cache of the request
	name = name:lower() -- store as lower case for better matching
	SearchCache[name..serverName..playerName] = data
	SearchCache[#SearchCache + 1] = name..serverName..playerName
end

--[[ Returns the Sum of all AH sold vs AH buys along with the date range
If no player name is supplied then the entire server profit will be totaled
if no item name is provided then all items will be returned
if no date range is supplied then a sufficently large range to cover the entire BeanCounter History will be used.
]]
function lib.API.getAHProfit(player, item, lowDate, highDate)
	if not player or player == "" then player = "server" end
	if not item then item = "" end
	
	local sum, low, high, date = 0, 9999999999, 0
	local settings = {["selectbox"] = {"1", player} , ["bid"] = true, ["auction"] = true, ["failedauction"] = true}
	local tbl
	--allow a already API searched data table to be passed instead of just a text string
	if type(item) == "string" then
		tbl = private.startSearch(item, settings, true)
	elseif type(item) == "table" then
		tbl = item
	end
	if not tbl then return end
		
	for i,v in pairs(tbl) do
		date = tonumber(v[12])
		--if user passes a low and high date to use, filter out any not in the range
		local dateRange = true
		if date and lowDate and highDate then--if we have high/low then set range to false 
			dateRange = false
			if lowDate < date and date < highDate then --set back to true if we meet conditions
				dateRange = true
			end
		end
		
		if dateRange then
			--store lower and upper date ranges
			if date and date < low then low = date end
			if date and date > high then high = date end
			--Sum the trxns	
			if v[2] == _BC('UiAucSuccessful') then
				sum = sum + v[5] - v[9] --sum sale - deposit. fee's have already been subtracted
			elseif v[2] == _BC('UiAucExpired') then
				sum = sum - v[9] --subtract failed deposits
			elseif v[2] == _BC('UiWononBid') then
				sum = sum - v[3] --subtract bought items
			elseif v[2] == _BC('UiWononBuyout') then
				sum = sum - v[4]
			end
		end
	end
	return sum, lowDate or low, highDate or high
end

--[[This will return profits in date segments  allow easy to create graphs
Similar to API.getProfit()  This utility return a table containing the profit earned in day based segments. useful for graphing a change over time
example: entering (player, "arcane dust", 7) would return the the profit for arcane dust in 7 day segments starting from most recent to oldest
]]
function lib.API.getAHProfitGraph(player, item ,days)
	if not player or player == "" then player = "server" end
	if not item then item = "" end
	if not days then days = 7 end
	--Get data from BeanCounter
	local settings = {["selectbox"] = {"1", player} , ["bid"] =true, ["auction"] = true}
	local tbl = private.startSearch(item, settings, "none")
	--Merge and edit provided table to needed format
	for i,v in pairs(tbl) do
		for a,b in pairs(v) do
			table.insert(tbl, b)
		end
	end
	--remove now redundant table entries
	tbl.completedAuctions, tbl["completedBids/Buyouts"], tbl.failedAuctions, tbl.failedBids = nil, nil, nil, nil
	--check if we actually have any results from the search
	if #tbl == 0 then return {0}, 0, 0 end
	--sort by date
	table.sort(tbl, function(a,b) return a[5] > b[5] end)
	--get min and max dates.
	local high, low, count, sum, number = tbl[1][5], tbl[#tbl][5], 1, 0, 0
	local range = high - (days* 86400)

	tbl.sums = {}
	tbl.sums[count] = {}
	for i,v in ipairs(tbl) do
		if tonumber(v[5]) >= range then
			if v[4] == "Auction successful" then
				number = tonumber(v[3]:match(".-;.-;.-;.-;.-;(.-);.*")) or 0
				sum = sum + number
			elseif v[4] == "Auction won" then
				number = tonumber(v[3]:match(".-;.-;.-;.-;.-;.-;(.-);.*")) or 0
				sum = sum - number
			end
			tbl.sums[count] = sum
		else
			count = count + 1
			range = range - (days * 86400)
			tbl.sums[count] = {}
			sum = 0
			if v[4] == "Auction successful" then
				number = tonumber(v[3]:match(".-;.-;.-;.-;.-;(.-);.*")) or 0
				sum = sum + number
			elseif v[4] == "Auction won" then
				number = tonumber(v[3]:match(".-;.-;.-;.-;.-;.-;(.-);.*")) or 0
				sum = sum - number
			end
			tbl.sums[count] = sum
		end
	end
	return tbl.sums, low, high
end

--[[
Get  Sold / Failed Ratio
Used by match beancounter, made into an API  to allow other addons easier access to this data
This returns the Sold/Failed number of auctions and Sold/Failed  number of items
]]
function lib.API.getAHSoldFailed(player, link, days)
	if not link or not player then return end
	if not private.serverData[player] then return end
	
	local itemID = lib.API.decodeLink(link)
	if not itemID then return end
		
	local now = time()
	local success, failed, sucessStack, failedStack = 0, 0, 0, 0
	--if we want to filter to a date range then we use this, if we want EVERY trxn uses second lookup
	--the second lookup is mesurably  faster but not noticable in real use due to not having to expand the DB. 100 trxns may have a  0.0001 sec diffrence
	if days then
		days = days * 86400 --days to seconds
		if private.serverData[player]["completedAuctions"][itemID] then
			for key in pairs(private.serverData[player]["completedAuctions"][itemID] ) do
				for i, text in pairs(private.serverData[player]["completedAuctions"][itemID][key]) do
					local stack, _, _, _, _, _, _, auctime = strsplit(";", text)
					auctime, stack = tonumber(auctime), tonumber(stack)
					
					if (now - auctime) < (days) then
						success = success + 1
						sucessStack = sucessStack + stack
					end
				end
			end
		end
		if private.serverData[player]["failedAuctions"][itemID] then
			for key in pairs(private.serverData[player]["failedAuctions"][itemID]) do
				for i, text in pairs(private.serverData[player]["failedAuctions"][itemID][key]) do
					local stack, _, _, _, _, _, _, auctime = strsplit(";", text)
					auctime, stack = tonumber(auctime), tonumber(stack)
					
					if (now - auctime) < (days) then
						failed = failed + 1
						failedStack = failedStack + stack
					end
				end
			end
		end
	else
		if BeanCounter and BeanCounter.Private.playerData then
			if private.serverData[player]["completedAuctions"][itemID]  then
				for key in pairs(private.serverData[player]["completedAuctions"][itemID] ) do
					success = success + #private.serverData[player]["completedAuctions"][itemID][key]
				end
			end
			if private.serverData[player]["failedAuctions"][itemID] then
				for key in pairs(private.serverData[player]["failedAuctions"][itemID]) do
					failed = failed + #private.serverData[player]["failedAuctions"][itemID][key]
				end
			end
		end
	end
	
	return success, failed, sucessStack, failedStack
end

--**********************************************************************************************************************
--ITEMLINK AND STRING API'S USE THESE IN PLACE OF LOCAL :MATCH() CALLS
--[[ Retrives the itemLink from the name array when passed an itemKey
we store itemKeys with a unique ID but our name array does not
]]
function lib.API.getArrayItemLink(itemString)
	local itemID, suffix = lib.API.decodeLink(itemString)
	local itemKey = itemID..":"..suffix
	if BeanCounterDB.ItemIDArray[itemKey] then
		return lib.API.createItemLinkFromArray(itemKey, BeanCounterDB.ItemIDArray[itemKey])
	end
	debugPrint("Searching DB for ItemID..", suffix, itemID, "Failed Item does not exist")
	return
end

--[[Converts the compressed link stored in the itemIDArray back to a standard blizzard format]]
function lib.API.createItemLinkFromArray(itemKey)
	if BeanCounterDB["ItemIDArray"][itemKey] then 
		local itemID, suffix = string.split(":", itemKey)
		local color, name = string.split(";", BeanCounterDB["ItemIDArray"][itemKey])
		return strjoin("", "|", color, "|Hitem:", itemID,":0:0:0:0:0:", suffix, ":0:80|h[", name, "]|h|r")
	end
	return
end
--[[Convert and store an itemLink into teh compressed format used in teh itemIDArray]]
function lib.API.storeItemLinkToArray(itemLink)
	if not itemLink then return end
	local color, itemID, suffix, name = itemLink:match("|(.-)|Hitem:(.-):.-:.-:.-:.-:.-:(.-):.+|h%[(.-)%]|h|r")
	
	if color and itemID and suffix and name then
		BeanCounterDB["ItemIDArray"][itemID..":"..suffix] =  color..";"..name
	end
end

--[[Turns an itemLink into an itemString and extracts the itemName
Returns sanitized itemlinks. Since hyperlinks now vary depending on level of player who looks/creates them
]]
function lib.API.getItemString(itemLink)
	if not itemLink or not type(itemLink) == "string" then return end
	local itemString, itemName = itemLink:match("H(item:.-)|h%[(.-)%]")
	if not itemString then return end
	itemString = itemString:gsub("(item:[^:]+:[^:]+:[^:]+:[^:]+:[^:]+:[^:]+:[^:]+:[^:]+):%d+", "%1:80")
	return itemString, itemName
end

--[[Returns id, suffix, uniqueID when passed an itemLink or itemString, this a mildly tweaked version of the one found in AucAdv.
Handles Hitem:string,  item:string, or full itemlinks
]]
local function breakHyperlink(match, matchlen, ...)
	local v
	local n = select("#", ...)
	for i = 1, n do
		v = select(i, ...)
		if (v:sub(1,matchlen) == match) then
			return strsplit(":", v) --for item:0:...  style links bean stores
		elseif(v:sub(2, matchlen+1) == match) then
			return strsplit(":", v:sub(2))  --for Hitem:0:... normal itemStrings and hyperlinks
		end
	end
end
function lib.API.decodeLink(link)
	local vartype = type(link)
	if (vartype == "string") then
		local lType, id, enchant, gem1, gem2, gem3, gemBonus, suffix, uniqueID, lichKing = breakHyperlink("item:", 5, strsplit("|", link))
		if (lType ~= "item") then return end
			return id, suffix, uniqueID
		end
	return
end

--[[Return REASON codes for tooltip or other use
This allows a way to get it that wont break if I change the internal DB layout
Pass a itemlink and stack count
Returns :  "Reason, time of purchase, what you payed"  or nil
NOTE: Reason could possibly be "", decided to return data anyways, calling module can decide if it want to use data or not
]]
function lib.API.getBidReason(itemLink, quantity)
	if not itemLink or not quantity then return end

	local itemString = lib.API.getItemString(itemLink)
	local itemID, suffix = lib.API.decodeLink(itemLink)

	if private.playerData["completedBids/Buyouts"][itemID] and private.playerData["completedBids/Buyouts"][itemID][itemString] then
		for i,v in pairs(private.playerData["completedBids/Buyouts"][itemID][itemString]) do
			local quan, _, _ , _, _, bid, _, Time, reason = private.unpackString(v)
			if tonumber(quan) == tonumber(quantity) and reason and Time then
				return reason, Time, tonumber(bid)
			end
		end
	end
	--not found on the current player lets see if we bought it on another player
	for player in pairs(private.serverData) do
		if private.serverData[player]["completedBids/Buyouts"][itemID] and private.serverData[player]["completedBids/Buyouts"][itemID][itemString] then
			for i,v in pairs(private.serverData[player]["completedBids/Buyouts"][itemID][itemString]) do
				local quan, _, _ , _, _, bid, _, Time, reason = private.unpackString(v)
				if tonumber(quan) == tonumber(quantity) and reason and Time then
					return reason, Time, tonumber(bid), player
				end
			end
		end
	end
	
	return --if nothing found return nil
end

--[[===========================================================================
--|| Deprecation Alert Functions
--||=========================================================================]]
 --Ths function was created by Shirik all thanks and blame go to him :P
do
	local SOURCE_PATTERN = "([^\\/:]+:%d+): in function ([^\"']+)[\"']";
	local seenCalls = {};
	local uid = 0;
	-------------------------------------------------------------------------------
	-- Shows a deprecation alert. Indicates that a deprecated function has
	-- been called and provides a stack trace that can be used to help
	-- find the culprit.
	-- @param replacementName (Optional) The displayable name of the replacement function
	-- @param comments (Optional) Any extra text to display
	-------------------------------------------------------------------------------
	function lib.ShowDeprecationAlert(replacementName, comments)
		local caller, source, functionName =
		debugstack(3):match(SOURCE_PATTERN),        -- Keep in mind this will be truncated to only the first in the tuple
		debugstack(2):match(SOURCE_PATTERN);        -- This will give us both the source and the function name

		caller, source, functionName = caller or "Unknown.lua:000", source or "Unknown.lua:000", functionName or "Unknown" --Stop nil errors if data is missing
		functionName = functionName .. "()";

		-- Check for this source & caller combination
		seenCalls[source] = seenCalls[source] or {};
		if not seenCalls[source][caller] then
			-- Not warned yet, so warn them!
			seenCalls[source][caller]=true
			-- Display it
			debugPrint(
			"Auctioneer Advanced: "..
			functionName .. " has been deprecated and was called by |cFF9999FF"..caller:match("^(.+)%.[lLxX][uUmM][aAlL]:").."|r. "..
				(replacementName and ("Please use "..replacementName.." instead. ") or "")..
				(comments or "")
				);
				geterrorhandler()(
				"Deprecated function call occurred in BeanCounter API:\n     {{{Deprecated Function:}}} "..functionName..
				"\n     {{{Source Module:}}} "..source:match("^(.+)%.[lLxX][uUmM][aAlL]:")..
				"\n     {{{Calling Module:}}} "..caller:match("^(.+)%.[lLxX][uUmM][aAlL]:")..
				"\n     {{{Available Replacement:}}} "..replacementName..
				(comments and "\n\n"..comments or "")
				)
		end

	end

end
