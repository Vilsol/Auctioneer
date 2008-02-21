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
		You have an implicit licence to use this AddOn with these facilities
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]

local libName = "BeanCounter"
local libType = "Util"
local lib = BeanCounter
local private = lib.Private
local print =  BeanCounter.Print


local function debugPrint(...) 
    if private.getOption("util.beancounter.debugUpdate") then
        private.debugPrint("BeanCounterUpdate",...)
    end
end
--manually ran, not used by any other functions atm
function private.fixMissingItemlinks()
local tbl = {}
	for player, v in pairs(private.serverData)do
		for DB,data in pairs(private.serverData[player]) do
			if type(data) == "table" then
				for itemID, value in pairs(data) do
					for index, text in ipairs(value) do
						tbl = {strsplit(";", text)}
						if tbl[1] == "0" or tbl[1] == "<nil>" then
							_, link = private.getItemInfo(itemID, "itemid")
							if link and  tbl[1] == "<nil>" then
								private.serverData[player][DB][itemID][index] = text:gsub("(<nil>)", link, 1)
								print("Corrected",private.serverData[player][DB][itemID][index])
							elseif link and  tbl[1] == "0" then
								private.serverData[player][DB][itemID][index] = text:gsub("(0)", link, 1)
								print("Corrected",private.serverData[player][DB][itemID][index])
							else 
								print("Server could not find itemID, try again later", itemID)    
							end
						end
					end
				end
			end
		end
	end

end

function private.UpgradeDatabaseVersion()
	if BeanCounterDB["version"] then --Remove the old global version and create new per toon version
		BeanCounterDB["version"] = nil
	end
	if not BeanCounterDB[private.realmName][private.playerName]["version"] then  --added in 1.01 update
		BeanCounterDB[private.realmName][private.playerName]["version"] = private.version
		BeanCounterDB[private.realmName][private.playerName]["vendorbuy"] = {}
		BeanCounterDB[private.realmName][private.playerName]["vendorsell"] = {}
	end
	if not BeanCounterDB["settings"] then --Added to allow beancounter to be standalone
	    BeanCounterDB["settings"] = {}
	end
	if not BeanCounterDB[private.realmName][private.playerName]["faction"] then --typo corrected in revision 2747 that prevented faction from recording
		BeanCounterDB[private.realmName][private.playerName]["faction"] = private.faction
	end
	--Recreate the itemID array if for some reason user lacks it.
	if not BeanCounterDB["ItemIDArray"] then BeanCounterDB["ItemIDArray"] = {} private.refreshItemIDArray() end
	
	if private.playerData["version"] < 1.015 then
		private.updateTo1_02A()
	elseif private.playerData["version"] < 1.02 then
		private.updateTo1_02B()
	elseif private.playerData["version"] < 1.03 then
		private.updateTo1_03()
	elseif private.playerData["version"] < 1.04 then
		debugPrint("private.updateTo1_04()")
		private.updateTo1_04()
	elseif private.playerData["version"] < 1.05 then
		debugPrint("private.updateTo1_05()")
		private.updateTo1_05()
	elseif private.playerData["version"] < 1.06 then
		debugPrint("private.updateTo1_06()")
		private.updateTo1_06()
	elseif private.playerData["version"] < 1.07 then
		debugPrint("private.updateTo1_07()")
		private.updateTo1_07()
	elseif private.playerData["version"] < 1.08 then
		private.updateTo1_075()
	elseif private.playerData["version"] < 1.09 then
		private.updateTo1_09()
	elseif private.playerData["version"] < 1.10 then
		private.updateTo1_10()
	elseif private.playerData["version"] < 1.11 then
		private.updateTo1_11A()
	end	
	
	--Integrity checks of the DB after upgrades to make sure no invalid entries remain
	if not private.getOption("util.beancounter.integrityCheckComplete") then 
		private.integrityCheck(true) 
	elseif not private.getOption("util.beancounter.integrityCheck") then
		private.integrityCheck()
	end
	
end

--[[This changes the database to use ; and to replace itemNames with itemlink]]--
function private.updateTo1_02A() 
	--: to ; and itemName to itemlink
	for player, v in pairs(private.serverData) do
		for DB, data in pairs(v) do
			if type(data) == "table" then
				for itemID, value in pairs(data) do
				    for index, text in ipairs(value) do
					private.serverData[player][DB][itemID][index] = private.packString(strsplit(":", text)) --repackage all strings using ;
				    end
				end
			end
		end
	end
	for player, v in pairs(private.serverData) do
	    for DB, data in pairs(v) do
		if DB == "version" then
		    private.serverData[player]["version"] = 1.015 --update each players version #
		end
	    end
	end
	private.updateTo1_02B()
end
function private.updateTo1_02B() 
	for player, v in pairs(private.serverData) do
		for DB, data in pairs(v) do
			if type(data) == "table" then
				for itemID, value in pairs(data) do
				    for index, text in ipairs(value) do
					local _, link = private.getItemInfo(itemID, "itemid")
					    if link then 
						text = text:gsub("(.-);", link..";", 1) --Change item Name to item links
						private.serverData[player][DB][itemID][index] = private.packString(strsplit(";", text)) --repackage string with new itemlink   
					    else
						local name = text:match("(.-);")
						link = private.updateCreatelink(itemID, name)
						text = text:gsub("(.-);", link..";", 1) --Change item Name to item links
						private.serverData[player][DB][itemID][index] = private.packString(strsplit(";", text)) --repackage string with new itemlink   
					    end
				    end
				end
			end
		end
	end
	for player, v in pairs(private.serverData) do
	    for DB, data in pairs(v) do
		if DB == "version" then
		    private.serverData[player]["version"] = 1.02 --update each players version #
		end
	    end
	end
	private.updateTo1_03()
end 
function private.updateCreatelink(itemID, name) --If the server query fails make a fake link so we can still view item
    return "|cffffff33|Hitem:"..itemID..":0:0:0:0:0:0:1529248154|h["..name.."]|h|r" --Our fake links are always yellow
end
--[[This removes the redundent "date" field]]--
function private.updateTo1_03()
	for DB,data in pairs(private.playerData) do
		if type(data) == "table" then
			for itemID, value in pairs(data) do
				for index, text in ipairs(value) do
					text = text:gsub(";(%d-%-%d-%-%d-)$", "", 1) --Remove the date field
					private.playerData[DB][itemID][index] = text
				end
			end
		end
	end
	private.playerData.version = 1.03
	
	private.updateTo1_04()
end

--[[This adds the MailBox table, used to pretend messages are unread from a user point a view]]--
function private.updateTo1_04()
	debugPrint("Start")
	if not BeanCounterDB[private.realmName][private.playerName]["mailbox"] then
		BeanCounterDB[private.realmName][private.playerName]["mailbox"] = {}
	end
	private.playerData.version = 1.04
	
	private.updateTo1_05()
end

--[[This adds the missing stack size count for expired auctions]]--
function private.updateTo1_05()
	for player,data in pairs(private.serverData) do
	    for itemID,value in pairs(private.serverData[player]["failedAuctions"]) do
		for i,v in pairs(value) do
		   local tbl = private.unpackString(v)
			if #tbl == 4 then
				local value = private.packString(tbl[1], tbl[2], 0, tbl[3], tbl[4])
				private.serverData[player]["failedAuctions"][itemID][i] = value
			else
				print("There has been an error updating versions ", player, itemID, tbl[1], tbl[2],tbl[3], tbl[4])
			end
		end
	    end
	private.serverData[player]["version"] = 1.05
	end
	private.updateTo1_06()
end

--[[This adds the ItemID array allowing plain text searches to search via itemID search routine]]--
function private.updateTo1_06()
	if not BeanCounterDB["ItemIDArray"] then BeanCounterDB["ItemIDArray"] = {} end
	for player, v in pairs(private.serverData)do
		for DB,data in pairs(private.serverData[player]) do
			if type(data) == "table" then
				for itemID, value in pairs(data) do
					for index, text in ipairs(value) do
						local item = text:match("^|c%x+|H.+|h%[(.+)%].-;.*")
						if item then
							BeanCounterDB["ItemIDArray"][item:lower()] = itemID
						end
					end
				end
			end
		end
	private.serverData[player]["version"] = 1.07 --Since this is actually the 1.07 change item:lower()
	end
	private.updateTo1_075() --Skip 1_07 it was fixed in 1_06 as well
end

--[[This changes the ItemID array to store names in lower case, needed to easily allow exact match, We also add faction table]]--
function private.updateTo1_07()
	BeanCounterDB["ItemIDArray"] = {}
	private.updateTo1_06() --1.06 has been changed to always record in lower, so reuse that code :)
end

--[[Major update Adds the bid and correct Stack to the Completed Auctions Table. From now on bean will alwasy try and match a posted Auction to get stack.]]

--Insert <nil> segment into completed AUctions to make room for stack
function private.updateTo1_075()
	for player,data in pairs(private.serverData) do
		for itemID ,values in pairs(private.serverData[player]["completedAuctions"]) do
			for i, text in pairs(values) do
				text = text:gsub("Auction successful;", "Auction successful;<nil>;", 1) --Add new Stack size field 
				private.serverData[player]["completedAuctions"][itemID][i] = text
			end
		end
		private.serverData[player]["version"] = 1.075
	end
	private.updateTo1_08()
end
--Compare with postedAuctions add as much stack info as we can. Also add the correct Starting Bid 
function private.updateTo1_08()
	for player,data in pairs(private.serverData) do
		for itemID ,values in pairs(private.serverData[player]["completedAuctions"]) do
			local used = {}
			for i, text in pairs(values) do
				local tbl = private.unpackString(text)
				local soldDeposit, soldBuy, soldTime , oldestPossible = tonumber(tbl[5]), tonumber(tbl[8]),tonumber(tbl[10]), tonumber(tbl[10]-17300)
				if not private.serverData[player]["postedAuctions"][itemID] then print("failed", itemID) break end
				
				for index, v in pairs(private.serverData[player]["postedAuctions"][itemID]) do
					local tbl2 = private.unpackString(v)
					local postDeposit, postBuy, postTime = tonumber(tbl2[6]), tonumber(tbl2[4]),tonumber(tbl2[7])
					--if the deposits and buyouts match, check if time range would make this a possible match
					if postDeposit ==  soldDeposit and postBuy == soldBuy and not used[index] then
						if (soldTime > postTime) and (oldestPossible < postTime) then
							private.serverData[player]["completedAuctions"][itemID][i] = private.packString(tbl[1], tbl[2], tbl2[2], tbl[4], tbl[5], tbl[6], tbl[7], tbl2[3],tbl[9], tbl[10], tbl[11])
							used[index] = "used"
							break
						end
					end
				end
			end
		end
	private.serverData[player]["version"] = 1.08
	end
	private.updateTo1_09()
end

--[[Update the completedBids/Buyouts table to also include stack sizes]]
function private.updateTo1_09()
	for player,data in pairs(private.serverData) do
		for itemID ,values in pairs(private.serverData[player]["completedBids/Buyouts"]) do
			local usedBid = {}
			local usedBuy = {}
			for index, text in pairs(values) do
				local tbl = private.unpackString(text)
				local seller, buy, bid = tbl[8], tonumber(tbl[6]),tonumber(tbl[7])
				local found = false --used to skip checking bids if we found in buys table
				
				if private.serverData[player]["postedBuyouts"][itemID] then
					for i,v in pairs(private.serverData[player]["postedBuyouts"][itemID]) do
						local tbl2 = private.unpackString(v)
						local stack, postBuy, postSeller, Type = tonumber(tbl2[2]), tonumber(tbl2[3]), tbl2[4], tbl2[5]
						if seller ==  postSeller and postBuy == buy and not usedBid[i] then
							usedBuy[i] = "used" --stores each item index so each postedBid entry is only allowed one match
							private.serverData[player]["completedBids/Buyouts"][itemID][index] = private.packString(tbl[1], tbl[2], stack, tbl[4], tbl[5], tbl[6], tbl[7], tbl[8], tbl[9], tbl[10])
							found = true
							break
						end
					end
				end
				if private.serverData[player]["postedBids"][itemID] and not found then
					for i,v in pairs(private.serverData[player]["postedBids"][itemID]) do
						local tbl2 = private.unpackString(v)
						local stack, postBid, postSeller, Type = tonumber(tbl2[2]), tonumber(tbl2[3]), tbl2[4], tbl2[5]
						if seller ==  postSeller and postBid == bid and not usedBid[i] then
							usedBid[i] = "used"
							private.serverData[player]["completedBids/Buyouts"][itemID][index] = private.packString(tbl[1], tbl[2], stack, tbl[4], tbl[5], tbl[6], tbl[7], tbl[8], tbl[9], tbl[10])
							break
						end
					end
				end
			end
		end
		private.serverData[player]["version"] = 1.09
	end
	private.updateTo1_10()
end
--[[Correct Bug in 1.09 =, we accidently added a extra stack field for completedbids/buyouts. This update looks over the table and removes that extra data to stop errors on sorting.]]
function private.updateTo1_10()
	for player,data in pairs(private.serverData) do
		for itemID , values in pairs(private.serverData[player]["completedBids/Buyouts"]) do
			for i, text in pairs(values)do
				local tbl = private.unpackString(text)
				if #tbl == 11 then --if this has the extra entry then repack sans value
					text = private.packString(tbl[1], tbl[2], tbl[3], tbl[4], tbl[6], tbl[7], tbl[8], tbl[9], tbl[10], tbl[11] )
					private.serverData[player]["completedBids/Buyouts"][itemID][i] = text
				end
			end
		end
		private.serverData[player]["version"] = 1.10
	end
	private.updateTo1_11A()
end
--[[Updates expired auctions table to hold new values  buy, bid, deposit cost]]
function private.updateTo1_11A()
	for player, data in pairs(private.serverData) do
		for itemID ,values in pairs(private.serverData[player]["failedAuctions"]) do
			for i, text in pairs(values) do
				local tbl = private.unpackString(text)
				if #tbl == 5 then
					private.serverData[player]["failedAuctions"][itemID][i] = private.packString(tbl[1], tbl[2], tbl[3], 0, 0, 0, tbl[4], tbl[5])
				elseif #tbl == 4 then --some expired auctions seem to have made it past the 1.05 update and are missing stack placeholder
					private.serverData[player]["failedAuctions"][itemID][i] = private.packString(tbl[1], tbl[2], 0, 0, 0, tbl[3], tbl[4])
				else --remove the entry
					if #private.serverData[player]["failedAuctions"][itemID][i] == 1 then
						private.serverData[player]["failedAuctions"][itemID] = nil
					else
						private.serverData[player]["failedAuctions"][itemID][i] = nil
					end
				end
			end
		end
	end
	private.updateTo1_11B()
end
--[[Looks in postedAuctions table to get new data fields for failedAuctions, stack, buy, bid, deposit cost]]
--"|cffffffff|Hitem:32381:0:0:0:0:0:0:0|h[Schematic: Fused Wiring]|h|r;     Auction expired;   0;   new4BUY;  new5BID ; new6DEPOSIT ;  1194214443;     15881251"
function private.updateTo1_11B()
	for player,data in pairs(private.serverData) do
		for itemID ,values in pairs(private.serverData[player]["failedAuctions"]) do
			local used = {}
			for i, text in pairs(values) do
				local tbl = private.unpackString(text)
				local stack, arrivedTime = tonumber(tbl[3]), tonumber(tbl[7])
				
				if not private.serverData[player]["postedAuctions"][itemID] then print("failed", itemID) break end
				
				for index, v in pairs(private.serverData[player]["postedAuctions"][itemID]) do
					local tbl2 = private.unpackString(v)
					local timeAuctionPosted, timeFailedAuctionStarted = tonumber(tbl2[7]), tonumber(tbl[7] - (tbl2[5]*60)) --Time this message should have been posted
					if  not used[index] and (timeAuctionPosted - 500) <= timeFailedAuctionStarted and timeFailedAuctionStarted <= (timeAuctionPosted + 500) then
						private.serverData[player]["failedAuctions"][itemID][i] = private.packString(tbl[1], tbl[2], tbl2[2], tbl2[4], tbl2[3], tbl2[6], tbl[7], tbl[8])
						--add stack size, buy, bid, deposit cost
						used[index] = "used"
						break
					end
				end
			end
		end
		private.serverData[player]["version"] = 1.11
	end
end






--[[INTEGRITY CHECKS]]--
--Make sure the DB format is correct removing any entries that were missed by updating.
--To be run after every DB update
 function private.integrityCheck(complete)
	local tbl,text = {}, nil
	for player,data in pairs(private.serverData) do
		for itemID ,values in pairs(private.serverData[player]["postedAuctions"]) do
			--"|cffffffff|Hitem:24401:0:0:0:0:0:0:1518857512|h[Unidentified Plant Parts]|h|r; 1 ; 3599;3980;1440;222;1200446651;12072651", -- [1]
			for i = #values, 1, -1 do
				text = values[i]
				local tbl = private.unpackString(text)
				if #tbl ~= 8 or (complete and private.IC(tbl, "postedAuctions")) then
					print("BeanCounter is removing corupted entry",tbl[1],"from the postedAuctions database")
					if #values == 1 then
						private.serverData[player]["postedAuctions"][itemID] = nil
					else
						table.remove(private.serverData[player]["postedAuctions"][itemID], i)
					end	
				end
			end
		end
		for itemID ,values in pairs(private.serverData[player]["postedBuyouts"]) do
			--"|cff1eff00|Hitem:7475:0:0:0:0:0:1024:1250482484|h[Regal Cuffs of the Whale]|h|r;1;9484;Imyourpal;boolean true;4;1198790630;5725595", -- [1]
			for i = #values, 1, -1 do
				text = values[i]
				local tbl = private.unpackString(text)
				if #tbl ~= 8 or (complete and private.IC(tbl, "postedBuyouts")) then
					print("BeanCounter is removing corupted entry",tbl[1],"from the postedBuyouts database")
					if #values == 1 then
						private.serverData[player]["postedBuyouts"][itemID] = nil
					else
						table.remove(private.serverData[player]["postedBuyouts"][itemID], i)
						
					end
				end
			end
		end
		for itemID ,values in pairs(private.serverData[player]["postedBids"]) do
			--"|cff1eff00|Hitem:7924:248:0:0:0:0:0:1436734832|h[Mithril Scale Bracers]|h|r;1;6454;Dviyan;boolean false;4;1198790141;7968164", -- [6]
			for i = #values, 1, -1 do
				text = values[i]
				local tbl = private.unpackString(text)
				if #tbl ~= 8 or (complete and private.IC(tbl, "postedBids")) then
					print("BeanCounter is removing corupted entry",tbl[1],"from the postedBids database")
					if #values == 1 then
						private.serverData[player]["postedBids"][itemID] = nil
					else
						table.remove(private.serverData[player]["postedBids"][itemID], i)
					end
				end
			end
		end
		for itemID ,values in pairs(private.serverData[player]["failedAuctions"]) do
			--"|cffffffff|Hitem:10285:0:0:0:0:0:0:0|h[Shadow Silk]|h|r;Auction expired;1;1673;1499;150;1198835637;7800679", -- [1]
			for i = #values, 1, -1 do
				text = values[i]
				local tbl = private.unpackString(text)
				if #tbl ~= 8 or (complete and private.IC(tbl, "failedAuctions")) then
					print("BeanCounter is removing corupted entry",tbl[1],"from the failedAuctions database")
					if #values == 1 then
						private.serverData[player]["failedAuctions"][itemID] = nil
					else
						table.remove(private.serverData[player]["failedAuctions"][itemID], i)
					end
				end
			end
		end
		for itemID ,values in pairs(private.serverData[player]["failedBids"]) do
			--"|cff1eff00|Hitem:14242:0:0:0:0:0:785:1026408052|h[Darkmist Pants of the Owl]|h|r;Outbid;6019;1198804515;7146455", -- [1]
			for i = #values, 1, -1 do
				text = values[i]
				local tbl = private.unpackString(text)
				if #tbl ~= 5 or (complete and private.IC(tbl, "failedBids")) then
					print("BeanCounter is removing corupted entry",tbl[1],"from the failedBids database")
					if #values == 1 then
						private.serverData[player]["failedBids"][itemID] = nil
					else
						table.remove(private.serverData[player]["failedBids"][itemID], i)
					end
				end
			end
		end
		for itemID ,values in pairs(private.serverData[player]["completedAuctions"]) do
			--"|cffffffff|Hitem:11176:0:0:0:0:0:0:-22442025|h[Dream Dust]|h|r;Auction successful;10;38000;0;2000;40000;36599;Nitehawkx;1200703508;9777695", -- [35]
			for i = #values, 1, -1 do
				text = values[i]
				local tbl = private.unpackString(text)
				if #tbl ~= 11 or (complete and private.IC(tbl, "completedAuctions")) then
					print("BeanCounter is removing corupted entry",tbl[1],"from the completedAuctions database")
					if #values == 1 then
						private.serverData[player]["completedAuctions"][itemID] = nil
					else
						table.remove(private.serverData[player]["completedAuctions"][itemID], i)
					end
				end
			end
		end
		for itemID ,values in pairs(private.serverData[player]["completedBids/Buyouts"]) do
			for i = #values, 1, -1 do
				text = values[i]
				local tbl = private.unpackString(text)
				if #tbl ~= 10 or (complete and private.IC(tbl, "completedBids/Buyouts")) then
					print("BeanCounter is removing corupted entry",tbl[1],"from the completedBids/Buyouts database")
					if #values == 1 then
						private.serverData[player]["completedBids/Buyouts"][itemID] = nil
					else
						table.remove(private.serverData[player]["completedBids/Buyouts"][itemID], i)
					end
				end
				
			end
		end
	end
	private.setOption("util.beancounter.integrityCheckComplete", true)
	private.setOption("util.beancounter.integrityCheck", true)
end
local integrity = {}
	integrity["completedBids/Buyouts"] = {"string", "string", "number", "number", "number", "number", "number", "string", "number", "number" } --10
	integrity["completedAuctions"] = {"string", "string", "number", "number", "number", "number", "number", "number", "string", "number", "number"}--11
	integrity["failedBids"] = {"string", "string", "number", "number", "number"} --5
	integrity["failedAuctions"] = {"string", "string", "number", "number", "number", "number", "number", "number"} --8
	integrity["postedBids"] = {"string", "number", "number", "string", "string", "number", "number", "number" } --8
	integrity["postedBuyouts"] = {"string", "number", "number", "string", "string", "number", "number", "number" } --8
	integrity["postedAuctions"] = {"string", "number", "number", "number", "number", "number" ,"number", "number"} --8
function private.IC(tbl, DB)
		for i,v in pairs(tbl) do
			v = tonumber(v) or v
			if type(v) ~= integrity[DB][i] then
				return true
			end
		end
		return false
	end



