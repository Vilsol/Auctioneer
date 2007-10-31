--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$

	BeanCounterCore - BeanCounter: Auction House History
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
		You have an implicit licence to use this AddOn with these facilities
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]

--AucAdvanced.Modules["Util"]["BeanCounter"]

local libName = "BeanCounter"
local libType = "Util"
local lib
BeanCounter={}
lib = BeanCounter

--Handle if Auc Adv is not loaded
local lib2 = lib --this will only be used when Auc is running
if AucAdvanced then
	AucAdvanced.Modules[libType][libName] = {}
	lib2 = AucAdvanced.Modules[libType][libName]
end
	


local private = {
	--BeanCounterCore
	playerName = UnitName("player"),
	realmName = GetRealmName(), 
	faction, _ = UnitFactionGroup(UnitName("player")),
	version = 1.02,
	wealth, --This characters current net worth. This will be appended to each transaction.
	playerData, --Alias for BeanCounterDB[private.realmName][private.playerName]
	serverData, --Alias for BeanCounterDB[private.realmName]
		
	--BeanCounter Bids/posts
	PendingBids = {},
	PendingPosts = {},
	
	--BeanCounterMail 
	reconcilePending = {},
	inboxStart = {},
	inboxCurrent = {},
	Task ={},
	TakeInboxIgnore = false,
	}
	
lib.Private = private --allow beancounter's sub lua's access
--Taken from AucAdvCore
function BeanCounter.Print(...)
	local output, part
	for i=1, select("#", ...) do
		part = select(i, ...)
		part = tostring(part):gsub("{{", "|cffddeeff"):gsub("}}", "|r")
		if (output) then output = output .. " " .. part
		else output = part end
	end
	DEFAULT_CHAT_FRAME:AddMessage(output, 0.3, 0.9, 0.8)
end

local print = BeanCounter.Print

local function debugPrint(...) 
    private.debugPrint("BeanCounterCore",...)
end

function lib2.GetName()
	return libName
end

function lib2.Processor(callbackType, ...)
	if (callbackType == "config") then
		private.SetupConfigGui(...)
	end
end

function lib.OnLoad(addon)
	private.frame:RegisterEvent("PLAYER_MONEY")
	
	private.frame:RegisterEvent("MAIL_INBOX_UPDATE")
	private.frame:RegisterEvent("UI_ERROR_MESSAGE")
	private.frame:RegisterEvent("MAIL_SHOW")
	private.frame:RegisterEvent("MAIL_CLOSED")
	
	private.frame:RegisterEvent("MERCHANT_SHOW")	
	private.frame:RegisterEvent("MERCHANT_UPDATE")
	private.frame:RegisterEvent("MERCHANT_CLOSED")
	
	private.frame:RegisterEvent("AUCTION_HOUSE_SHOW")
	
	private.frame:SetScript("OnUpdate", private.onUpdate)
	
	-- Hook all the methods we need
	Stubby.RegisterAddOnHook("Blizzard_AuctionUi", "BeanCounter", private.CreateFrames) --To be standalone we cannot depend on AucAdv for lib.Processor
	
	Stubby.RegisterFunctionHook("TakeInboxMoney", -100, private.PreTakeInboxMoneyHook);
	Stubby.RegisterFunctionHook("TakeInboxItem", -100, private.PreTakeInboxItemHook);
	--Bids
	Stubby.RegisterFunctionHook("PlaceAuctionBid", 50, private.postPlaceAuctionBidHook)
	--Posting
	Stubby.RegisterFunctionHook("StartAuction", -50, private.preStartAuctionHook)
	--Vendor
	hooksecurefunc("BuyMerchantItem", private.merchantBuy)

	--Setup Configator defaults if AucAdv loaded
	if AucAdvanced then
	    for config, value in pairs(private.defaults) do
		    AucAdvanced.Settings.SetDefault(config, value)
	    end
	end
	private.initializeDB() --create or initialize the saved DB
end

--Create the database
function private.initializeDB()  
	if not BeanCounterDB  then
		BeanCounterDB  = {}
		BeanCounterDB["settings"] = {}
	end
	if not BeanCounterDB[private.realmName] then
		BeanCounterDB[private.realmName] = {}
		
	end
	if not BeanCounterDB[private.realmName][private.playerName] then
		BeanCounterDB[private.realmName][private.playerName] = {}
		BeanCounterDB[private.realmName][private.playerName]["version"] = private.version
		
		BeanCounterDB[private.realmName][private.playerName]["faction]"] = private.faction
		BeanCounterDB[private.realmName][private.playerName]["wealth"] = GetMoney()
		
		BeanCounterDB[private.realmName][private.playerName]["vendorbuy"] = {}
		BeanCounterDB[private.realmName][private.playerName]["vendorsell"] = {}
		
		BeanCounterDB[private.realmName][private.playerName]["postedAuctions"] = {}
		BeanCounterDB[private.realmName][private.playerName]["completedAuctions"] = {}
		BeanCounterDB[private.realmName][private.playerName]["failedAuctions"] = {}
		
		BeanCounterDB[private.realmName][private.playerName]["postedBids"] = {}
		BeanCounterDB[private.realmName][private.playerName]["postedBuyouts"] = {}
		BeanCounterDB[private.realmName][private.playerName]["completedBids/Buyouts"]  = {}
		BeanCounterDB[private.realmName][private.playerName]["failedBids"]  = {}
		
	end
--OK we now have our Database ready, lets create an Alias to make refrencing easier
private.playerData = BeanCounterDB[private.realmName][private.playerName]
private.serverData = BeanCounterDB[private.realmName]


--[[Ok, create a fake table telling folks what our database means
	BeanCounterDBFormat = {"This is a diagram for the layout of the BeanCounterDB.",
	'POSTING DATABASE -- records Auction house activities',
	"['postedAuctions'] == Item, post.count, post.minBid, post.buyoutPrice, post.runTime, post.deposit, time(), current wealth, date",
	"['postedBids'] == itemName, count, bid, owner, isBuyout, timeLeft, time(),current wealth, date",
	"['postedBuyouts'] ==  itemName, count, bid, owner, isBuyout, timeLeft, time(), current wealth, date",
	' ',
	' ',
	'MAIL DATABASE --records mail received from Auction House',	
	'(Some of these values will be nil If we were unable to Retrieve the Invoice), current wealth, date',
	"['completedAuctions'] == itemName, Auction successful, money, deposit , fee, buyout , bid, buyer, (time the mail arrived in our mailbox), current wealth, date",
	"['failedAuctions'] == itemName, Auction expired, (time the mail arrived in our mailbox), current wealth, date",
	"completedBids/Buyouts are a combination of the mail data from postedBuyouts and postedBids, current wealth, date",
	"['completedBids/Buyouts] == itemName, Auction won, money, deposit , fee, buyout , bid, buyer, (time the mail arrived in our mailbox), current wealth, date",
	"[failedBids] == itemName, Outbid, money, (time the mail arrived in our mailbox), current wealth, date",
	'',
	'APIs',
    'TODO',
    }]]
    --[[
	'private.playerData is an alias for BeanCounterDB[private.realmName][private.playerName]',
	'private.packString(...) --will return any length arguments into a : seperated string',
	'private.databaseAdd(key, itemID, value)  --Adds to the DB. Example "postedBids", itemID, ( : seperated string)',
	'private.databaseRemove(key, itemID, ITEM, NAME, BID) --This is only for ["postedBids"]  NAME == Auction Owners Name',
	}]]

	private.wealth = GetMoney()
	private.playerData["wealth"] = private.wealth

	private.UpgradeDatabaseVersion() 
 
end

--[[ Configator Section ]]--

private.defaults = {
	["util.beancounter.activated"] = true,
	["util.beancounter.debug"] = false,
	}

function private.getOption(option)
    if AucAdvanced then
	return AucAdvanced.Settings.GetSetting(option)
    end
end

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName)
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",     0,    libName.." options")
	gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.debug", "Turn on BeanCounter Debugging.")

	--gui:AddControl(id, "Subhead",    0,    "Debug from specific modules:")
	--gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.Maildebug", "Show BeanCounterMail Debugging Messages.")
	--gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.Framedebug", "Show BeanCounterFrames Debugging Messages.")
	--gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.Framedebug", "Show BeanCounterPosting/Bid Debugging Messages.")	
end


--[[ Local functions ]]--
function private.onUpdate()
	private.mailonUpdate()
end

function private.onEvent(frame, event, arg, ...)
	if (event == "PLAYER_MONEY") then
		private.wealth = GetMoney()
		private.playerData["wealth"] = private.wealth
	
	elseif (event == "MAIL_INBOX_UPDATE") or (event == "MAIL_SHOW") or (event == "MAIL_CLOSED") then
		private.mailMonitor(event, arg, ...)
	
	elseif (event == "MERCHANT_CLOSED") or (event == "MERCHANT_SHOW") or (event == "MERCHANT_UPDATE") then
		--private.vendorOnevent(event, arg, ...)

	elseif (event == "ADDON_LOADED") then
		if arg == "BeanCounter" then
		   lib.OnLoad()
		elseif arg == "Auc-Advanced" then
		    AucAdvanced.Modules[libType][libName] = {}
		    lib2 = AucAdvanced.Modules[libType][libName]
		    for config, value in pairs(private.defaults) do
			AucAdvanced.Settings.SetDefault(config, value)
		    end
		end
	end
end


--[[ Utility Functions]]--
--will return any length arguments into a ; seperated string
function private.packString(...)
local String
	for n = 1, select("#", ...) do
		local msg = select(n, ...)
		if msg == nil then 
			msg = "<nil>" 
		elseif msg == true then
			msg = "boolean true"
		elseif msg == false then
			msg = "boolean false"
		end
		if n == 1 then  --This prevents a seperator from being the first character.  :foo:foo:
			String = msg
		else
			String = strjoin(";",String,msg)
		end
	end
	return(String)
end
--Will split any string and return a table value
function private.unpackString(text)
	return {strsplit(";", text)}
end

--Add data to DB
function private.databaseAdd(key, itemID, value)
	if private.playerData[key][itemID] then
		table.insert(private.playerData[key][itemID], value)
	else
		private.playerData[key][itemID]={value}
	end
end
--remove item (for pending bids only atm) Can I make this universal?
function private.databaseRemove(key, itemID, ITEM, NAME)
	if key == "postedBids" then	
		for i,v in pairs(private.playerData[key][itemID]) do
			local tbl = private.unpackString(v)
			if tbl and itemID and ITEM and NAME then
				if tbl[1] == ITEM and tbl[4] == NAME then
				if (#playerData[key][itemID] == 1) then --itemID needs to be removed if we are deleting the only value              
			playerData[key][itemID] = nil
                        break
                    else
                        table.remove(playerData[key][itemID],i)--Just remove the key
                        break
                    end
				end
			end
		end
	end
end
--Get item Info or a specific subset. accepts itemID or "itemString" or "itemName ONLY IF THE ITEM IS IN PLAYERS BAG" or "itemLink"
function private.getItemInfo(link, cmd) 
debugPrint(link, cmd)
local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(link)
	if not cmd and itemLink then --return all
		return itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture
	elseif itemLink and (cmd == "itemid") then
		local itemID = itemLink:match("|c%x+|Hitem:(%d-):.-|h%[.-%]|h|r")
		return itemID, itemLink
	end
end

function private.debugPrint(...)
	if private.getOption("util.beancounter.debug") then
		print(...)
	end
end

--[[Bootstrap Code]]
private.frame = CreateFrame("Frame")
private.frame:RegisterEvent("ADDON_LOADED")
private.frame:SetScript("OnEvent", private.onEvent)