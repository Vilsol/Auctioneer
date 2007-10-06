--[[
	Auctioneer Advanced - Price Level Utility module
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds a price level indicator
	to auctions when browsing the Auction House, so that you may readily see
	which items are bargains or overpriced at a glance.

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
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]

local libName = "CompactUI"
local libType = "Util"

AucAdvanced.Modules[libType][libName] = {}
local lib = AucAdvanced.Modules[libType][libName]
local private = {}
local print = AucAdvanced.Print

local data
private.cache = {}

--[[
The following functions are part of the module's exposed methods:
	GetName()         (required) Should return this module's full name
	CommandHandler()  (optional) Slash command handler for this module
	Processor()       (optional) Processes messages sent by Auctioneer
	ScanProcessor()   (optional) Processes items from the scan manager
*	GetPrice()        (required) Returns estimated price for item link
*	GetPriceColumns() (optional) Returns the column names for GetPrice
	OnLoad()          (optional) Receives load message for all modules

	(*) Only implemented in stats modules; util modules do not provide
]]

function lib.GetName()
	return libName
end

function lib.Processor(callbackType, ...)
	if (callbackType == "config") then
		private.SetupConfigGui(...)
	elseif (callbackType == "auctionui") then
		private.HookAH(...)
	elseif callbackType == "configchanged"
	or callbackType == "blockupdate" then
		if (private.Active) then
			private.MyAuctionFrameUpdate()
		end
	elseif (callbackType == "scanstats") then
		private.cache = {}
	end
end

function lib.OnLoad()
	--print("AucAdvanced: {{"..libType..":"..libName.."}} loaded!")
	AucAdvanced.Settings.SetDefault("util.compactui.activated", true)
	AucAdvanced.Settings.SetDefault("util.compactui.collapse", false)
	AucAdvanced.Settings.SetDefault("util.compactui.bidrequired", true)
	AucAdvanced.Settings.SetDefault("util.browseoverride.activated", false)
end

--[[ Local functions ]]--
private.candy = {}
private.buttons = {}
function private.HookAH()
	lib.inUse = true

	if (not AucAdvanced.Settings.GetSetting("util.compactui.activated")) then
		private.MyAuctionFrameUpdate = function() end
		return
	end

	AuctionFrameBrowse_Update = private.MyAuctionFrameUpdate
	local button, lastButton, origButton
	local line

	BrowseQualitySort:Hide()
	BrowseLevelSort:Hide()
	BrowseDurationSort:Hide()
	BrowseHighBidderSort:Hide()
	BrowseCurrentBidSort:Hide()

	local NEW_NUM_BROWSE = 14
	for i = 1, NEW_NUM_BROWSE do
		if (i <= NUM_BROWSE_TO_DISPLAY) then
			origButton = getglobal("BrowseButton"..i)
			origButton:Hide()
			_G["BrowseButton"..i] = nil
		else
			origButton = nil
		end
		button = CreateFrame("Button", "BrowseButton"..i, AuctionFrameBrowse)
		button.Orig = origButton
		button.pos = i
		private.buttons[i] = button
		if (i == 1) then
			button:SetPoint("TOPLEFT", 188, -103)
		else
			button:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT")
		end
		button:SetWidth(610)
		button:SetHeight(19)
		button:EnableMouse(true)
		button.LineTexture = button:CreateTexture()
		button.LineTexture:SetPoint("TOPLEFT", 0,-1)
		button.LineTexture:SetPoint("BOTTOMRIGHT")
		button.AddTexture = button:CreateTexture()
		button.AddTexture:SetPoint("TOPLEFT", 0,-1)
		button.AddTexture:SetPoint("BOTTOMRIGHT")

		button.Count = button:CreateFontString(nil,nil,"GameFontHighlight")
		button.Count:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
		button.Count:SetWidth(28)
		button.Count:SetHeight(19)
		button.Count:SetJustifyH("RIGHT")
		button.Count:SetFont(STANDARD_TEXT_FONT, 11)
		button.IconButton = CreateFrame("Button", nil, button)
		button.IconButton:SetPoint("TOPLEFT", button, "TOPLEFT", 30, 0)
		button.IconButton:SetWidth(16)
		button.IconButton:SetHeight(19)
		button.IconButton:SetScript("OnEnter", private.IconEnter)
		button.IconButton:SetScript("OnLeave", private.IconLeave)
		button.IconButton:SetFrameLevel(button.IconButton:GetFrameLevel() + 5)
		button.Icon = button.IconButton:CreateTexture()
		button.Icon:SetPoint("TOPLEFT", button.IconButton, "TOPLEFT", 0,-2)
		button.Icon:SetPoint("BOTTOMRIGHT", button.IconButton, "BOTTOMRIGHT" , 0, 1)
		button.Name = button:CreateFontString(nil,nil,"GameFontHighlight")
		button.Name:SetPoint("TOPLEFT", button, "TOPLEFT", 50, 0)
		button.Name:SetWidth(220)
		button.Name:SetHeight(19)
		button.Name:SetJustifyH("LEFT")
		button.Name:SetFont(STANDARD_TEXT_FONT, 10)
		button.rLevel = button:CreateFontString(nil,nil,"GameFontHighlight")
		button.rLevel:SetPoint("TOPLEFT", button.Name, "TOPRIGHT", 2, 0)
		button.rLevel:SetWidth(30)
		button.rLevel:SetHeight(19)
		button.rLevel:SetJustifyH("RIGHT")
		button.rLevel:SetFont(STANDARD_TEXT_FONT, 11)
		button.iLevel = button:CreateFontString(nil,nil,"GameFontHighlight")
		button.iLevel:SetPoint("TOPLEFT", button.rLevel, "TOPRIGHT", 2, 0)
		button.iLevel:SetWidth(30)
		button.iLevel:SetHeight(19)
		button.iLevel:SetJustifyH("RIGHT")
		button.iLevel:SetFont(STANDARD_TEXT_FONT, 11)
		button.tLeft = button:CreateFontString(nil,nil,"GameFontHighlight")
		button.tLeft:SetPoint("TOPLEFT", button.iLevel, "TOPRIGHT", 2, 0)
		button.tLeft:SetWidth(35)
		button.tLeft:SetHeight(19)
		button.tLeft:SetJustifyH("CENTER")
		button.tLeft:SetFont(STANDARD_TEXT_FONT, 11)
		button.Owner = button:CreateFontString(nil,nil,"GameFontHighlight")
		button.Owner:SetPoint("TOPLEFT", button.tLeft, "TOPRIGHT", 2, 0)
		button.Owner:SetWidth(80)
		button.Owner:SetHeight(19)
		button.Owner:SetJustifyH("LEFT")
		button.Owner:SetFont(STANDARD_TEXT_FONT, 10)
		button.Bid = CreateFrame("Frame", "AucAdvancedUtilCompactUIMoneyBid"..i, button, "EnhancedTooltipMoneyTemplate")
		button.Bid.SetMoney = private.SetMoney
		button.Bid:SetPoint("TOPRIGHT", button.Owner, "TOPRIGHT", 122, 0)
		button.Bid:SetWidth(120)
		button.Bid:SetFrameStrata("MEDIUM")
		button.Buy = CreateFrame("Frame", "AucAdvancedUtilCompactUIMoneyBuy"..i, button, "EnhancedTooltipMoneyTemplate")
		button.Buy.SetMoney = private.SetMoney
		button.Buy:SetPoint("TOPRIGHT", button.Bid, "BOTTOMRIGHT", 0, 1)
		button.Buy:SetWidth(120)
		button.Buy:SetFrameStrata("MEDIUM")
		button.Value = button:CreateFontString(nil,nil,"GameFontHighlight")
		button.Value:SetPoint("TOPLEFT", button.Bid, "TOPRIGHT", -10, 0)
		button.Value:SetWidth(45)
		button.Value:SetHeight(19)
		button.Value:SetJustifyH("RIGHT")
		button.Value:SetFont(STANDARD_TEXT_FONT, 11)

		button.SetAuction = private.SetAuction
		button:SetScript("OnClick", private.ButtonClick)

		lastButton = button
	end
	NUM_BROWSE_TO_DISPLAY = NEW_NUM_BROWSE

	local function selectHeader(self, ...)
		local id = self.id
		private.headers.sort = 0
		private.headers.dir = 0
		private.headers.pos = 0
		for i=1, #private.headers do
			local header = private.headers[i]
			if i == id then
				if header.dir ~= 0 then
					header.dir = header.dir * -1
					if header.dir == header.defaultdir then
						header.pos = header.pos + 1
					end
				else
					header.pos = 1
					header.dir = header.defaultdir
				end
				if header.dir > 0 then
					header.Back:SetVertexColor(0.6,1,1, 1)
				else
					header.Back:SetVertexColor(1,0.6,1, 1)
				end
				if header.cycle then
					local headPos = ((header.pos-1) % #header.cycle)+1
					header.Text:SetText(header.cycle[headPos])
					private.headers.pos = headPos
				end
				private.headers.sort = id
				private.headers.dir = header.dir
			else
				header.dir = 0
				header.Back:SetVertexColor(1,1,1, 0.8)
				header.Text:SetText(header.Text.default)
			end
		end
		private.MyAuctionFrameUpdate()
	end


	local function createHeader(id, dir, text, parentLeft, parentRight, lOfs, rOfs, cycle)
		if not parentRight then parentRight = parentLeft end

		local header = CreateFrame("Button", nil, private.headers)
		header:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		header:SetPoint("BOTTOMLEFT", parentLeft, "TOPLEFT", lOfs or 0, 2)
		header:SetPoint("BOTTOMRIGHT", parentRight, "TOPRIGHT", rOfs or 0, 2)
		header:SetHeight(16)
		header.Text = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		header.Text:SetPoint("TOPLEFT", header, "TOPLEFT", 2, 0)
		header.Text:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT")
		header.Text:SetJustifyH("LEFT")
		header.Text:SetJustifyV("CENTER")
		header.Text:SetText(text)
		header.Text.default = text
		header.Back = header:CreateTexture(nil, "ARTWORK")
		header.Back:SetPoint("TOPLEFT", header, "TOPLEFT")
		header.Back:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT")
		header.Back:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		header.Back:SetTexCoord(0.1, 0.8, 0, 1)
		header.Back:SetVertexColor(1,1,1, 0.8)
		header:SetScript("OnClick", selectHeader)
		header.defaultdir = dir
		header.cycle = cycle
		header.pos = 1
		header.dir = 0
		header.id = id
		private.headers[id] = header
	end

	private.headers = CreateFrame("Frame", nil, AuctionFrameBrowse)
	table.insert(private.candy, private.headers)

	local bOne = private.buttons[1]
	createHeader(1, 1, "#", bOne.Count)
	createHeader(2, 1, "Auction Item", bOne.IconButton, bOne.Name, 0, 0, { "Name", "Quality" })
	createHeader(3, -1, "Min", bOne.rLevel)
	createHeader(4, -1, "iLvl", bOne.iLevel)
	createHeader(5, 1, "Left", bOne.tLeft)
	createHeader(6, 1, "Owner", bOne.Owner)
	createHeader(7, -1, "Price", bOne.Value, bOne.Bid, -110, -13, {"Buy total", "Bid total", "Buy each", "Bid each"})
	createHeader(8, 1, "Pct", bOne.Value, nil, 0, -2)

	local tex
	tex = AuctionFrameBrowse:CreateTexture()
	tex:SetTexture(1,1,1, 0.05)
	tex:SetPoint("TOPLEFT", private.buttons[1].rLevel, "TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT", private.buttons[NEW_NUM_BROWSE].rLevel, "BOTTOMRIGHT")
	table.insert(private.candy, tex)

	tex = AuctionFrameBrowse:CreateTexture()
	tex:SetTexture(1,1,1, 0.05)
	tex:SetPoint("TOPLEFT", private.buttons[1].tLeft, "TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT", private.buttons[NEW_NUM_BROWSE].tLeft, "BOTTOMRIGHT")
	table.insert(private.candy, tex)

	tex = AuctionFrameBrowse:CreateTexture()
	tex:SetTexture(1,1,1, 0.05)
	tex:SetPoint("TOPLEFT", private.buttons[1].Owner, "TOPRIGHT", 2, 0)
	tex:SetPoint("BOTTOM", private.buttons[NEW_NUM_BROWSE].Buy, "BOTTOM", 0, 0)
	tex:SetPoint("RIGHT", private.buttons[1].Bid, "RIGHT", -10, 0)
	table.insert(private.candy, tex)

	tex = AuctionFrameBrowse:CreateTexture()
	tex:SetTexture(1,1,0.5, 0.1)
	tex:SetPoint("TOPLEFT", private.buttons[NEW_NUM_BROWSE].Count, "BOTTOMLEFT", 0, -1)
	tex:SetWidth(610)
	tex:SetHeight(38)
	table.insert(private.candy, tex)

	BrowsePrevPageButton:ClearAllPoints()
	BrowsePrevPageButton:SetPoint("BOTTOMRIGHT", tex, "BOTTOMRIGHT", -170, -5)
	BrowseNextPageButton:ClearAllPoints()
	BrowseNextPageButton:SetPoint("BOTTOMRIGHT", tex, "BOTTOMRIGHT", -5, -5)
	BrowseSearchCountText:ClearAllPoints()
	BrowseSearchCountText:SetPoint("BOTTOMRIGHT", tex, "BOTTOMRIGHT", -10, 27)

	local check = CreateFrame("CheckButton", nil, AuctionFrameBrowse, "OptionsCheckButtonTemplate")
	private.PerItem = check
	check:SetChecked(false)
	check:SetPoint("TOPLEFT", tex, "TOPLEFT", 5, -5)
	check:SetScript("OnClick", AuctionFrameBrowse_Update)
	table.insert(private.candy, check)

	local text = AuctionFrameBrowse:CreateFontString(nil,nil,"GameFontNormal")
	text:SetPoint("LEFT", check, "LEFT", 30, 0)
	text:SetText("Show stacks as price per unit")
	table.insert(private.candy, text)

	text = AuctionFrameBrowse:CreateFontString(nil,nil,"GameFontNormal")
	private.PageNum = text
	text:SetPoint("TOPLEFT", BrowsePrevPageButton, "TOPLEFT")
	text:SetPoint("BOTTOMRIGHT", BrowseNextPageButton, "BOTTOMRIGHT")
	text:SetFont(STANDARD_TEXT_FONT, 12)
	text:SetShadowOffset(2,2)
	table.insert(private.candy, text)

	private.Active = true

	-- Select our PCT column
	selectHeader(private.headers[8])
end

function private.SetMoney(me, value, hasBid, highBidder)
	value = math.floor(tonumber(value) or 0)
	if (value == 0) then me:Hide() return end
	me.small = true
	if (AucAdvanced.Settings.GetSetting("util.compactui.collapse")) then
		me.info.showSmallerCoins = false
	else
		me.info.showSmallerCoins = true
	end
	TinyMoneyFrame_Update(me, value)
	local r,g,b
	if (hasBid == true) then r,g,b = 1,1,1
	elseif (hasBid == false) then r,g,b = 0.7,0.7,0.7 end
	if (highBidder) then r,g,b = 0.4,1,0.2 end
	if (r and g and b) then
		local myName = me:GetName()
		getglobal(myName.."GoldButtonText"):SetTextColor(r,g,b)
		getglobal(myName.."SilverButtonText"):SetTextColor(r,g,b)
		getglobal(myName.."CopperButtonText"):SetTextColor(r,g,b)
	end
	me:Show()
end

function private.ButtonClick(me, mouseButton)
	if ( IsControlKeyDown() ) then
		DressUpItemLink(GetAuctionItemLink("list", me.id))
	elseif ( IsShiftKeyDown() ) then
		ChatEdit_InsertLink(GetAuctionItemLink("list", me.id))
	else
		if ( AUCTION_DISPLAY_ON_CHARACTER == "1" ) then
			DressUpItemLink(GetAuctionItemLink("list", me.id))
		end
		SetSelectedAuctionItem("list", me.id)
		-- Close any auction related popups
		CloseAuctionStaticPopups()
		AuctionFrameBrowse_Update()
	end
end

function private.IconEnter(this)
	local button = this:GetParent()
	button.Icon:ClearAllPoints()
	button.Icon:SetPoint("RIGHT", this, "LEFT")
	button.Icon:SetWidth(64)
	button.Icon:SetHeight(64)
	AuctionFrameItem_OnEnter("list", button.id)
end

function private.IconLeave(this)
	local button = this:GetParent()
	button.Icon:ClearAllPoints()
	button.Icon:SetPoint("TOPLEFT", this, "TOPLEFT")
	button.Icon:SetWidth(16)
	button.Icon:SetHeight(16)
	GameTooltip:Hide()
	ResetCursor()
end


function private.BrowseSort(a, b)
	local sort = private.headers.sort
	local dir = private.headers.dir

	if sort then
		if sort == 1 then            col = 3       -- Count
		elseif sort == 2 then                      --
			local pos = private.headers.pos    --
			if pos == 1 then     col = 6       -- Name
			elseif pos == 2 then col = 5       -- Quality
			end                                --
		elseif sort == 3 then        col = 8       -- MinLevel
		elseif sort == 4 then        col = 9       -- ItemLevel
		elseif sort == 5 then        col = 10      -- TimeLeft
		elseif sort == 6 then        col = 11      -- Owner
		elseif sort == 7 then                      --
			local pos = private.headers.pos    --
			if pos == 1 then     col = 16      -- Buy
			elseif pos == 2 then col = 15      -- Bid
			elseif pos == 3 then col = 18      -- BuyEach
			elseif pos == 4 then col = 17      -- BidEach
			end                                --
		elseif sort == 8 then        col = 21      -- PriceLevel
		end
	end

	if a[col] ~= b[col] then
		if dir > 0 then return (a[col] < b[col])
		else return (a[col] > b[col])
		end
	end
	if a[5] ~= b[5] then return a[5] < b[5] end
	if a[6] ~= b[6] then return a[6] < b[6] end
	if a[3] ~= b[3] then return a[3] < b[3] end
end

private.pageContents = {}
private.pageElements = {}
function private.RetrievePage()
	for i = 1, #private.pageContents do
		private.pageContents[i] = nil
	end

	local selected = GetSelectedAuctionItem("list") or 0
	for i = 1, NUM_AUCTION_ITEMS_PER_PAGE do
		if not private.pageElements[i] then private.pageElements[i] = {} end

		local link = GetAuctionItemLink("list", i)
		if link then
			local item = private.pageElements[i]

			item[1] = i
			if (selected == i) then
				item[2] = true
			else
				item[2] = false
			end

			local name, texture, count, quality, canUse, level,
				minBid, minIncrement, buyoutPrice, bidAmount,
				highBidder, owner  = GetAuctionItemInfo("list", i)
			local itemName, itemLink, itemRarity, itemLevel,
				itemMinLevel, itemType, itemSubType, itemStackCount,
				itemEquipLoc, itemTexture = GetItemInfo(link)

			if not itemLevel then itemLevel = level end
			if not itemMinLevel then itemMinLevel = level end
			local timeLeft = GetAuctionItemTimeLeft("list", i)
			if (timeLeft == 4) then timeLeftText = "24h"
			elseif (timeLeft == 3) then timeLeftText = "8h"
			elseif (timeLeft == 2) then timeLeftText = "2h"
			else timeLeftText = "30m" end
			if (not count or count < 1) then count = 1 end

			local requiredBid = minBid
			local showBid = minBid
			if ( bidAmount > 0 ) then
				requiredBid = bidAmount + minIncrement
				if (AucAdvanced.Settings.GetSetting("util.compactui.bidrequired")) then
					showBid = requiredBid
				else
					showBid = bidAmount
				end
			end

			if ( requiredBid >= MAXIMUM_BID_PRICE ) then
				-- Lie about our buyout price
				buyoutPrice = requiredBid
			end

			local priceLevel, perItem, r,g,b
			local cacheSig = strjoin(":", link, count, requiredBid, buyoutPrice)
			if private.cache[cacheSig] then
				priceLevel, perItem, r,g,b = unpack(private.cache[cacheSig])
			elseif AucAdvanced.Modules.Util.PriceLevel then
				priceLevel, perItem, r,g,b = AucAdvanced.Modules.Util.PriceLevel.CalcLevel(link, count, requiredBid, buyoutPrice)
				private.cache[cacheSig] = { priceLevel, perItem, r,g,b }
			end

			item[3] = count
			item[4] = texture
			item[5] = itemRarity
			item[6] = name
			item[7] = link
			item[8] = itemMinLevel
			item[9] = itemLevel
			item[10] = timeLeft
			item[11] = owner or ""
			item[12] = minBid
			item[13] = bidAmount
			item[14] = minIncrement
			item[15] = requiredBid
			item[16] = buyoutPrice
			item[17] = requiredBid / count
			item[18] = buyoutPrice / count
			item[19] = timeLeftText
			item[20] = highBidder
			item[21] = priceLevel or 0
			item[22] = perItem
			item[23] = r
			item[24] = g
			item[25] = b

			table.insert(private.pageContents, item)
		end
	end

	table.sort(private.pageContents, private.BrowseSort)
end

function lib.GetContents(pos)
	if private.pageContents[pos] then
		return unpack(private.pageContents[pos])
	end
	-- id, selected, count, texture, itemRarity, name, link, itemMinLevel, itemLevel, timeLeft, owner, minBid, bidAmount, minIncrement, requiredBid, buyoutPrice, requiredBidEach, buyoutPriceEach, timeLeftText, highBidder, priceLevel, perItem, r, g, b
end

function private.SetAuction(button, pos)
	local id, selected, count, texture, itemRarity, name, link, itemMinLevel, itemLevel, timeLeft, owner, minBid, bidAmount, minIncrement, requiredBid, buyoutPrice, requiredBidEach, buyoutPriceEach, timeLeftText, highBidder, priceLevel, perItem, r, g, b = lib.GetContents(pos)

	if not id then
		button:Hide()
		return
	end

	if (selected) then
		button.LineTexture:SetTexture(1,1,0.3, 0.2)
	elseif (pos % 2 == 0) then
		button.LineTexture:SetTexture(0.3,0.3,0.4, 0.1)
	else
		button.LineTexture:SetTexture(0,0,0.1, 0.1)
	end
	button.id = id

	local showBid
	if (AucAdvanced.Settings.GetSetting("util.compactui.bidrequired")) then
		showBid = requiredBid
	else
		showBid = bidAmount
	end

	if (selected) then
		if (buyoutPrice > 0 and buyoutPrice >= minBid) then
			local canBuyout = 1
			if (GetMoney() < buyoutPrice) then
				if (not highBidder or GetMoney()+bidAmount < buyoutPrice) then
					canBuyout = nil
				end
			end
			if (canBuyout) then
				BrowseBuyoutButton:Enable()
				AuctionFrame.buyoutPrice = buyoutPrice
			end
		else
			AuctionFrame.buyoutPrice = nil
		end
		-- Set bid
		MoneyInputFrame_SetCopper(BrowseBidPrice, requiredBid)

		-- See if the user can bid on this
		if (not highBidder and owner ~= UnitName("player")) then
			if (GetMoney() >= MoneyInputFrame_GetCopper(BrowseBidPrice)) then
				if (MoneyInputFrame_GetCopper(BrowseBidPrice) <= MAXIMUM_BID_PRICE) then
					BrowseBidButton:Enable()
				end
			end
		end
	end

	local perUnit = 1
	if (private.PerItem:GetChecked()) then
		perUnit = count
	end

	if itemLevel == 0 then itemLevel = "" end
	if itemMinLevel == 0 then itemMinLevel = "" end

	button.Count:SetText(count)
	button.Icon:SetTexture(texture)
	button.Name:SetText(link)
	button.rLevel:SetText(itemMinLevel)
	button.iLevel:SetText(itemLevel)
	button.tLeft:SetText(timeLeftText)
	button.Owner:SetText(owner)
	button.Bid:SetMoney(showBid/perUnit, requiredBid ~= minBid, highBidder)
	button.Buy:SetMoney(buyoutPrice/perUnit)
	button:Show()
end

function private.MyAuctionFrameUpdate()
	if not BrowseScrollFrame then return end

	if WOWEcon_AH_PerItem_Enable 
	and WOWEcon_AH_PerItem_Enable:IsVisible() then
		WOWEcon_AH_PerItem_Enable:Hide()
	end

	if AucAdvanced.API.IsBlocked() then
		for pos, candy in ipairs(private.candy) do candy:Hide() end
		BrowsePrevPageButton:Hide()
		BrowseNextPageButton:Hide()
		BrowseSearchCountText:Hide()
		return
	end

	local numBatchAuctions, totalAuctions = GetNumAuctionItems("list")
	local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
	local index, button
	BrowseBidButton:Disable()
	BrowseBuyoutButton:Disable()

	if ( numBatchAuctions == 0 ) then
		BrowseNoResultsText:Show()
	else
		BrowseNoResultsText:Hide()
	end

	private.RetrievePage()

	for i=1, NUM_BROWSE_TO_DISPLAY do
		index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)
		button = private.buttons[i]
		if ( index > (numBatchAuctions + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)) ) then
			button:SetAuction()
			-- If the last button is empty then set isLastSlotEmpty var
			if ( i == NUM_BROWSE_TO_DISPLAY ) then
				isLastSlotEmpty = 1
			end
		else
			button:SetAuction(offset+i)
		end
	end

	if (totalAuctions > 0) then
		for pos, candy in ipairs(private.candy) do candy:Show() end
		BrowsePrevPageButton:Show()
		BrowseNextPageButton:Show()
		BrowseSearchCountText:Show()
		local itemsMin = AuctionFrameBrowse.page * NUM_AUCTION_ITEMS_PER_PAGE + 1
		local itemsMax = itemsMin + numBatchAuctions - 1
		BrowseSearchCountText:SetText(format(NUMBER_OF_RESULTS_TEMPLATE, itemsMin, itemsMax, totalAuctions ))
		if ( isLastSlotEmpty ) then
			if ( AuctionFrameBrowse.page == 0 ) then
				BrowsePrevPageButton.isEnabled = nil
			else
				BrowsePrevPageButton.isEnabled = 1
			end
			if ( AuctionFrameBrowse.page == (ceil(totalAuctions/NUM_AUCTION_ITEMS_PER_PAGE) - 1) ) then
				BrowseNextPageButton.isEnabled = nil
			else
				BrowseNextPageButton.isEnabled = 1
			end
		else
			BrowsePrevPageButton.isEnabled = nil
			BrowseNextPageButton.isEnabled = nil
		end
	else
		for pos, candy in ipairs(private.candy) do candy:Hide() end
		BrowsePrevPageButton:Hide()
		BrowseNextPageButton:Hide()
		BrowseSearchCountText:Hide()
	end

	private.PageNum:SetText(("%d/%d"):format(AuctionFrameBrowse.page+1, ceil(totalAuctions/NUM_AUCTION_ITEMS_PER_PAGE)))
	FauxScrollFrame_Update(BrowseScrollFrame, numBatchAuctions, NUM_BROWSE_TO_DISPLAY, AUCTIONS_BUTTON_HEIGHT)
	BrowseScrollFrame:Show()
	AucAdvanced.API.ListUpdate()
end

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	id = gui:AddTab(libName)

	gui:AddHelp(id, "what compactui",
		"What is CompactUI?",
		"CompactUI is a space optimized browse interface to replace the default Blizzard auction browse interface.\n"..
		"Due to the fact that it heavily modifies your auction frames, it may cause it to be incompatible with other addons that also modify the auction frames. If this is the case you will have to make a choice between CompactUI and the other addons. You may disable CompactUI easily by unticking the \"Enable use of CompactUI (requires logout)\" option in the settings window.")

	gui:AddControl(id, "Header",     0,    libName.." options")
	gui:AddControl(id, "Checkbox",   0, 1, "util.compactui.activated", "Enable use of CompactUI (requires logout)")
	gui:AddTip(id, "Ticking this box will enable CompactUI to take over your auction browse window after your next reload")
	gui:AddControl(id, "Note",       0, 2, 600, 70, "Note: This module heavily modifies your standard auction browser window, and may not play well with other auction house addons. Should you enable this module and notice any incompatabilities, please turn this module off again by unticking the above box and reloading your interface.")

	gui:AddControl(id, "Checkbox",   0, 1, "util.compactui.collapse", "Remove smaller denomination coins when zero")
	gui:AddTip(id, "This option will cause lower value coins to be hidden when the hiding would not change the value of the displayed price")
	gui:AddControl(id, "Checkbox",   0, 1, "util.compactui.bidrequired", "Show required bid instead of current bid value")
	gui:AddTip(id, "The default interface shows you the current bid, ticking this option changes CompactUI's behaviour to instead show the required bid")
	gui:AddControl(id, "Checkbox",   0, 1, "util.browseoverride.activated", "Prevent other modules from changing the display of the browse tab while scanning")
	gui:AddTip(id, "Enabling this option will allow CompactUI to continue displaying the auction data, even when another module is installed to hide the display of auctions while scanning")

	gui:AddHelp(id, "what is collapse",
		"What does removing smaller denomination coins do?",
		"Removing smaller denomination coins removes coins from the lowest order when the coins are zero and their removal would not affect the accuracy of the price display.\n"..
		"This has the effect of shortening the length of the displayed prices, however it can cause additional confusion over similar length prices that are of a different order (ie: 1s 55c looks like 1g 55s) and if you're not careful, you may spend more than you meant to.")

	gui:AddHelp(id, "what is required",
		"What is the required bid?",
		"The stock standard interface shows you the current bid. In the case where the current bid is not the minimum (or starting) bid, your actual spend when you bid on this item will be the current bid, plus the minimum increment. Therefore what you pay will be more than what is displayed in the window when you are not the first bidder. By ticking this option, you change CompactUI's behaviour to instead show the required bid that you will need to bid, so that no matter if there is a bid or not, what you see is what you will pay.")

	gui:AddHelp(id, "what is browseoverride",
		"Why do I want to prevent other modules from changing the browse window?",
		"If you have a module such as ScanProgress installed, and activated, it will change the browse interface so that you cannot see the items as you are scanning. This option will revert the display so that you can see the items while scanning instead.")
end