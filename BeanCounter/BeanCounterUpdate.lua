--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://auctioneeraddon.com/

	BeanCounterUpdate - Upgrades the Beancounter Database to latest version

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

local libName = "BeanCounter"
local libType = "Util"
local lib = BeanCounter
local private, print, get, set, _BC = lib.getLocals()
private.update = {}

local function debugPrint(...)
    if get("util.beancounter.debugUpdate") then
        private.debugPrint("BeanCounterUpdate",...)
    end
end

local performedUpdate = false
function private.UpgradeDatabaseVersion()
	--Recreate the itemID array if for some reason user lacks it.
	if not BeanCounterDB["ItemIDArray"] then BeanCounterDB["ItemIDArray"] = {} private.refreshItemIDArray() end
	
	for server, serverData in pairs(BeanCounterDB) do
		if  server ~= "settings" and server ~= "ItemIDArray" then
			for player, playerData in pairs(serverData) do
				private.startPlayerUpgrade(server, player, playerData)
			end
			--validate the DB for this server after all upgrades have completed
			if performedUpdate then --only id we actually had to update
				private.integrityCheck(true, server)
			end
		end
	end
end

function private.startPlayerUpgrade(server, player, playerData)
	if playerData["version"] < 2.0 then --Delete and start fresh
		BeanCounterDB[server][player] = nil
		private.initializeDB(server, player)
		performedUpdate = true
	end
	if playerData["version"] < 2.01 then --removes old "Wealth entry to make room for reason codes
		private.update._2_01(server, player)
		performedUpdate = true
	end
	if playerData["version"] < 2.02 then --bump version # only, the fix it implemented is merged into later updates
		private.update._2_02(server, player)
		performedUpdate = true
	end
	if  playerData["version"] < 2.03 then--if not upgraded yet then upgrade
		private.update._2_03(server, player)
		performedUpdate = true
	end
	if playerData["version"] < 2.04 then --bump version # only, the fix it implemented is merged into later updates
		private.update._2_04(server, player)
		performedUpdate = true
	end
	if playerData["version"] < 2.05 then --bump version # only, the fix it implemented is merged into later updates
		private.update._2_05(server, player)
		performedUpdate = true
	end
	if playerData["version"] < 2.06 then --bump version # only 2.09 nukes the itemIDArray no need to wast time "updating" it
		private.update._2_06(server, player)
		performedUpdate = true
	end
	if playerData["version"] < 2.07 then -- removes all 0 entries from stored strings. Makes all database entries same length for easier parsing
		private.update._2_07(server, player)
		performedUpdate = true
	end
	if playerData["version"] < 2.08 then -- removes all 0 entries from stored strings. Makes all database entries same length for easier parsing
		private.update._2_08(server, player)
		performedUpdate = true
	end
	if playerData["version"] < 2.09 then -- removes all 0 entries from stored strings. Makes all database entries same length for easier parsing
		private.update._2_09(server, player)
		performedUpdate = true
	end
end

function private.update._2_01(server, player)
	for DB, data in pairs(BeanCounterDB[server][player]) do
		if  DB == "failedBids" or DB == "failedAuctions" or DB == "completedAuctions" or DB == "completedBids/Buyouts" then
			for itemID, value in pairs(data) do
				for itemString, index in pairs(value) do
					for i, item in pairs(index) do
						local reason = item:match(".+;(.-)$")
						if tonumber(reason) or reason == "<nil>" then
							item = item:gsub("(.+);.-$", "%1;", 1)
							BeanCounterDB[server][player][DB][itemID][itemString][i] = item
						end
					end
				end
			end
		end
	end
	BeanCounterDB[server][player]["version"] = 2.01
end

function private.update._2_02(server, player)
	BeanCounterDB[server][player]["version"] = 2.02
end

function private.update._2_03(server, player)
	if BeanCounterDB[server][player]["version"] < 2.03 then
		for DB, data in pairs(BeanCounterDB[server][player]) do
			if  DB == "failedBids" or DB == "failedAuctions" or DB == "completedAuctions" or DB == "completedBids/Buyouts" or DB == "postedAuctions" or DB == "postedBids" then
				for itemID, value in pairs(data) do
					local temp = {}
					for itemString, index in pairs(value) do
						itemString = itemString..":80"
						temp[itemString] = index
					end
					BeanCounterDB[server][player][DB][itemID] = temp
				end
			end
		end
	end
	BeanCounterDB[server][player]["version"] = 2.03
		
	print("WOW version 30000 Update finished")
end

function private.update._2_04(server, player)
	BeanCounterDB[server][player]["version"] = 2.04
end

function private.update._2_05(server, player)
	BeanCounterDB[server][player]["version"] = 2.05
end

function private.update._2_06(server, player) --2.09 nukes the itemIDArray no need to wast time "updating" it
	BeanCounterDB[server][player]["version"] = 2.06
end

local function convert(DB , text)
	if  DB == "failedBids" then
		local money, Time = strsplit(";", text)
		text =  private.packString("", money,"", "", "", "", "", Time, "","")
	elseif DB == "failedAuctions" then
		local stack, buyout, bid, deposit, Time, reason = strsplit(";", text)
		text = private.packString(stack, "", deposit, "", buyout, bid,  "", Time, reason, "")
	elseif DB == "completedAuctions" then
		local stack,  money, deposit, fee, buyout, bid, buyer, Time, reason = strsplit(";", text)
		text = private.packString(stack,  money, deposit , fee, buyout , bid, buyer, Time, reason, "")
	elseif DB == "completedBids/Buyouts" then
		local stack,  money, fee, buyout, bid, buyer, Time, reason = strsplit(";", text)
		text = private.packString(stack,  money, "" , fee, buyout , bid, buyer, Time, reason, "")
	end
	return text
end
function private.update._2_07(server, player)
	for DB, data in pairs(BeanCounterDB[server][player]) do
		if  DB == "failedBids" or DB == "failedAuctions" or DB == "completedAuctions" or DB == "completedBids/Buyouts"  then
			for itemID, value in pairs(data) do
				for itemString, data in pairs(value) do
					for index, text in pairs(data) do
						text = convert(DB , text)
						BeanCounterDB[server][player][DB][itemID][itemString][index] = text
					end
				end
			end
		end
	end
	BeanCounterDB[server][player]["version"] = 2.07
end

--[[moves itemNameArray  to not store full itemlinks but generate when needed
from "10155:1046"] = "|cff1eff00|Hitem:10155:0:0:0:0:0:1046:898585428:15|h[Mercurial Greaves of the Whale]|h|r",
to "10155:1046"] = "cff1eff00:Mercurial Greaves of the Whale",
reduces saved variable size and slighty increases text string matching speed even with the overhead needed to change it back to an itemlink
]]
function private.update._2_08(server, player)
--just let 2.09 do it.  Yes we will nuke teh array in each server that has not been upgraded. But we do not know how far behind each server is.
	BeanCounterDB[server][player]["version"] = 2.08
end
--Storing the data using a colon caused issues with schematics so store using a ;  instead.
--Easiest to just regenerate the ItemID array
function private.update._2_09(server, player)
	local _, item = next(BeanCounterDB["ItemIDArray"])
	--if not in new format then upgrade itemID array otherwise leave it alone
	if not item:match("c........;.-") then
		debugPrint("UPGRADE itemName", item)
		for itemKey, itemLink in pairs(BeanCounterDB["ItemIDArray"]) do
			local color, name = itemLink:match("|(.-)|.item.*%[(.+)%].*")
			local data = string.join(";", color, name)
			BeanCounterDB["ItemIDArray"][itemKey] = data
		end
	end
	BeanCounterDB[server][player]["version"] = 2.09
end
