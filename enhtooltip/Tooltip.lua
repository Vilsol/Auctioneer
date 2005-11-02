--[[
  Additional function hooks to allow hooks into more tooltips
  <%version%>
  $Id$

  You should hook into EnhTooltip using Stubby:
  	Stubby.RegisterFunctionHook("EnhTooltip.HOOK", 200, myHookingFunction)
	Where myHooking function is one of your functions (see calling parameters below)
	And HOOK is one of:
      addTooltip
	  checkPopup
	  merchantHook
	  tradeHook
	  bankHook
	  bagHook
	The number 200 is a number that determines calling order
	  A lower number will make your tooltip information display earlier (higher)
	  A higher number will call your tooltip later (lower)
	  Auctioneer (if installed) gets called at position 100.
	  Informant  (if installed) gets called at position 300.
	  Enchantrix (if installed) gets called at position 400.

	The appropriate function calls are, respectively:
	  tooltip - A tooltip is being displayed, hookFunc will be called as:
	    addTooltipHook(frame, name, link, quality, count, price)
	  popup - A tooltip may be displayed, unless you want to popup something:
	    popped = checkPopupHook(name, link, quality, count, price, hyperlink)
	    -- If your function returns true, then we won't present a tooltip
	  merchant - Get called for each of a merchant's items.
	    merchantHook(frame, name, link, quality, count, price)
	  trade - Get called when a tradeskill window is displayed / item selected
	    tradeHook(type, selid)
	    -- valid types: 'trade', 'craft'
	    -- selID will be nil when the window is first displayed
	  bank - You are at the bank and are able to scan it's containers
	    bankHook()
	  bag - One or more of the items in your bags has updated.
	    bagHook()


  You may use the following methods of the EnhTooltip class:
  
    EnhTooltip.HideTooltip()
	  - Causes the enhanced tooltip to vanish.
	  
    EnhTooltip.ClearTooltip()
	  - Clears the current tooltip of contents and hides it.
	  
    EnhTooltip.GetGSC(money)
	  - Returns the given money (in copper) amount in gold, silver and copper.
	  
    EnhTooltip.GetTextGSC(money, exact)
	  - Returns the money (in copper) amount as colored text, suitable for display.
	    If exact evaluates to true, then the text will be exact, otherwise rounded.
		
    EnhTooltip.AddLine(lineText, moneyAmount, embed)
	  - Adds the lineText to the tooltip.
	    If moneyAmount is supplied, the line has a money amount right-aligned after it.
		It embed evaluates to true, then the line is placed at the end of the game tooltip
		  and the money amount is converted to a textual form.

	EnhTooltip.AddSeparator()
	  - Adds an empty line to the tooltip.

    EnhTooltip.LineColor(r, g, b)
	  - Changes the color of the most recently added line to the given R,G,B value.
	    The R,G,B values are floating point values from 0.0 (dark) to 1.0 (bright)

    EnhTooltip.LineSize_Large()
      - Changes the size of the font string to 12
      
    EnhTooltip.LineSize_Small()
      - Changes the size of the font string to 10
		
    EnhTooltip.LineQuality(quality)
	  - Changes the color of the most recently added line to the quality color of the
	      item that is supplied in the quality parameter.
		  
    EnhTooltip.SetIcon(iconPath)
	  - Adds an icon to the current tooltip, where the texture path is set to that of
	      the iconPath parameter.
		  
    EnhTooltip.NameFromLink(link)
	  - Given a link, returns the embedded item name.
	  
    EnhTooltip.HyperlinkFromLink(link)
	  - Given a link, returns the blizzard hyperlink (eg: "item:12345:0:321:0")
	  
    EnhTooltip.BaselinkFromLink(link)
	  - Given a link, returns the first 3 numbers from the item link (eg: "12345:0:321")
	  
    EnhTooltip.QualityFromLink(link)
	  - Given a link, returns the numerical quality value (0=Poor/Gray ... 4=Epic/Purple)
	  
    EnhTooltip.FakeLink(hyperlink, quality, name)
	  - Given a hyperlink, a numerical quality and an item name, does it's best to fabricate
	      as authentic a link as it can. This link may not be suitable for messaging however.
		  
    EnhTooltip.AddHook(hookType, hookFunc, position)
	  - Allows dependant addons to register a function for inclusion at key moments.
	    Where:
		  hookType = The type of event to be notified of. One of:
            tooltip - A tooltip is being displayed, hookFunc will be called as:
			  addTooltipHook(frame, name, link, quality, count, price)
			popup - A tooltip may be displayed, unless you want to popup something:
			  popped = checkPopupHook(name, link, quality, count, price, hyperlink)
			  -- If your function returns true, then we won't present a tooltip
			merchant - Get called for each of a merchant's items.
			  merchantHook(frame, name, link, quality, count, price)
			trade - Get called when a tradeskill window is displayed / item selected
			  tradeHook(type, selid)
			  -- valid types: 'trade', 'craft'
			  -- selID will be nil when the window is first displayed
			bank - You are at the bank and are able to scan it's containers
			  bankHook()
			bag - One or more of the items in your bags has updated.
			  bagHook()
		  hookFunction = Your function (prototyped as above) that we will call.
		  position = A number that determines calling order
		    The default position if not supplied is 100.
			A lower number will make your tooltip information display earlier (higher)
			A higher number will call your tooltip later (lower)
			Auctioneer (if installed) gets called at position 50.
			Enchantrix (if installed) gets called at position 150.
			
    EnhTooltip.BreakLink(link)
	  - Given an item link, splits it into it's component parts as follows:
		  itemID, randomProperty, enchantment, uniqueID, itemName = EnhTooltip.BreakLink(link)
	    Note that the return order is not the same as the order of the items in the link
		  (ie: randomProp and enchant are reversed from their link order)
		  
    EnhTooltip.FindItemInBags(findName)
	  - Searches through your bags to find an item with the given name (exact match)
	    It returns the following information about the item:
		  bag, slot, itemID, randomProp, enchant, uniqID = EnhTooltip.FindItemInBags(itemName)
		  
    EnhTooltip.SetElapsed(elapsed)
	  - If a value is given, adds the elapsed interval to our own internal timer.
	    Checks to see if it is time to hide the tooltip.
	    Returns the total elapsed time that the tooltip has been displayed since startup.
		
	EnhTooltip.SetMoneySpacing(spacing)
	  - Sets the amount of padding (if provided) that money should be given in the tooltips.
	    Returns the current spacing.
		
	EnhTooltip.SetPopupKey(key)
	  - Sets a key (if provided), which if pressed while a tooltip is being displayed, checks
	      for hooked functions that may wish to provide popups.
	    Returns the current key.

]]

-- setting version number
ENHTOOLTIP_VERSION = "<%version%>"
if (ENHTOOLTIP_VERSION == "<".."%version%>") then
	ENHTOOLTIP_VERSION = "3.1.DEV"
end

--[[
---- Initialize a storage space that all our functions can see
--]]
local self = {
	showIgnore = false,
	moneySpacing = 4,
	embedLines = {},
	eventTimer = 0,
	hideTime = 0,
	currentGametip = nil,
	currentItem = nil,
	forcePopupKey = "alt",
	oldChatItem = nil,
	hooks = {},
	notify = { tooltip = {}, popup = {}, merchant = {}, bank = {}, bag = {}, trade = {} },
	notifyFuncs = {},
}

-- =============== LOCAL FUNCTIONS =============== --

-- prototypes for all local functions
local addLine                   -- AddLine(lineText,moneyAmount,embed)
local addSeparator              -- AddSeparator(embed)
local addTooltip                -- AddTooltip(frame,name,link,quality,count,price)
local afHookOnEnter             -- AfHookOnEnter(type,index)
local bagHook                   -- BagHook()
local bankHook                  -- BankHook()
local baselinkFromLink          -- BaselinkFromLink(link)
local breakLink                 -- BreakLink(link)
local callBagHook               -- CallBagHook(event,bagNumber)
local callBankHook              -- CallBankHook()
local callCheckPopup            -- CallCheckPopup(name,link,quality,count,price,hyperlink)
local callTradeHook             -- CallTradeHook(type,event,selID)
local cfHookUpdate              -- CfHookUpdate(frame)
local chatHookOnHyperlinkShow   -- ChatHookOnHyperlinkShow(reference,link,button,...)
local checkHide                 -- CheckHide()
local checkPopup                -- CheckPopup(name,link,quality,count,price,hyperlink)
local clearTooltip              -- ClearTooltip()
local debugPrint                -- DebugPrint(...)
local doHyperlink               -- DoHyperlink(reference,link,button)
local embedRender               -- EmbedRender()
local fakeLink                  -- FakeLink(hyperlink,quality,name)
local findItemInBags            -- FindItemInBags(findName)
local getGSC                    -- GetGSC(money)
local getLootLinkLink           -- GetLootLinkLink(name)
local getLootLinkServer         -- GetLootLinkServer()
local getRect                   -- GetRect(object,curRect)
local getTextGSC                -- GetTextGSC(money,exact)
local gtHookOnHide              -- GtHookOnHide()
local gtHookSetAuctionSellItem  -- GtHookSetAuctionSellItem(frame)
local gtHookSetBagItem          -- GtHookSetBagItem(frame,frameID,buttonID,retVal)
local gtHookSetCraftItem        -- GtHookSetCraftItem(frame,skill,slot)
local gtHookSetInventoryItem    -- GtHookSetInventoryItem(frame,unit,slot,retVal)
local gtHookSetLootItem         -- GtHookSetLootItem(frame,slot)
local gtHookSetMerchantItem     -- GtHookSetMerchantItem(frame,slot)
local gtHookSetOwner            -- GtHookSetOwner(frame,owner,anchor)
local gtHookSetQuestItem        -- GtHookSetQuestItem(frame,qtype,slot)
local gtHookSetQuestLogItem     -- GtHookSetQuestLogItem(frame,qtype,slot)
local gtHookSetTradeSkillItem   -- GtHookSetTradeSkillItem(frame,skill,slot)
local hideTooltip               -- HideTooltip()
local hyperlinkFromLink         -- HyperlinkFromLink(link)
local imHookOnEnter             -- ImHookOnEnter()
local imiHookOnEnter            -- ImiHookOnEnter()
local lineColor                 -- LineColor(r,g,b)
local lineQuality               -- LineQuality(quality)
local lineSize_Large            -- LineSize_Large()
local lineSize_Small            -- LineSize_Small()
local llHookOnEnter             -- LlHookOnEnter()
local merchantHook              -- MerchantHook(merchant,slot,name,link,quality,count,price,limit)
local merchantScanner           -- MerchantScanner()
local nameFromLink              -- NameFromLink(link)
local qualityFromLink           -- QualityFromLink(link)
local setElapsed                -- SetElapsed(elapsed)
local setIcon                   -- SetIcon(iconPath)
local setMoneySpacing           -- SetMoneySpacing(spacing)
local setPopupKey               -- SetPopupKey(key)
local showTooltip               -- ShowTooltip(currentTooltip)
local tooltipCall               -- TooltipCall(frame,name,link,quality,count,price,forcePopup,hyperlink)
local tradeHook                 -- TradeHook(type,selID)
local ttInitialize              -- TtInitialize()


------------------------
--  Hookable functions
------------------------

function addTooltip(frame, name, link, quality, count, price)
	-- This is it.
	-- Hook this function when you have something to put into the
	-- tooltip and use the AddLine etc methods to do so.
end

function checkPopup(name, link, quality, count, price, hyperlink)
	-- Hook this function to stop EnhTooltip putting up a tooltip
	-- Return true to stop EnhTooltip's tooltip.
end

function merchantHook(merchant, slot, name, link, quality, count, price, limit)
	-- Hook this function to be notified of an item at a merchant
end

function bankHook()
	-- Hook this function to be alerted to do a bank scan
end

function bagHook()
	-- Hook this function to be alerted to do a bag scan
end

function tradeHook(type,selID)
	-- Hook this function to be notified when a trade window is
	-- displayed or an item therein is selected.
	--   type is one of: "trade", or "craft"
	--   selID can be nil when first opened, or the id of the selected item.
end



------------------------
-- Function definitions
------------------------

function hideTooltip()
	EnhancedTooltip:Hide()
	self.currentItem = ""
	self.hideTime = 0
end

function clearTooltip()
	hideTooltip()
	EnhancedTooltip.hasEmbed = false
	EnhancedTooltip.curEmbed = false
	EnhancedTooltip.hasData = false
	EnhancedTooltipIcon:Hide()
	EnhancedTooltipIcon:SetTexture("Interface\\Buttons\\UI-Quickslot2")
	for i = 1, 30 do
		local ttText = getglobal("EnhancedTooltipText"..i)
		ttText:Hide()
		ttText:SetTextColor(1.0,1.0,1.0)
		ttText:SetFont("Fonts\\FRIZQT__.TTF", 10);
	end
	for i = 1, 20 do
		local ttMoney = getglobal("EnhancedTooltipMoney"..i)
		ttMoney.myLine = nil
		ttMoney:Hide()
	end
	EnhancedTooltip.lineCount = 0
	EnhancedTooltip.moneyCount = 0
	EnhancedTooltip.minWidth = 0
	for curLine in self.embedLines do
		self.embedLines[curLine] = nil;
	end
	table.setn(self.embedLines, 0);
end

function getRect(object, curRect)
	local rect = curRect
	if (not rect) then
		rect = {}
	end
	rect.t = object:GetTop() or 0
	rect.l = object:GetLeft() or 0
	rect.b = object:GetBottom() or 0
	rect.r = object:GetRight() or 0
	rect.w = object:GetWidth() or 0
	rect.h = object:GetHeight() or 0
	rect.cx = rect.l + (rect.w / 2)
	rect.cy = rect.t - (rect.h / 2)
	return rect
end

function showTooltip(currentTooltip)
	if (self.showIgnore == true) then return end
	if (EnhancedTooltip.hasEmbed) then
		embedRender()
		currentTooltip:Show()
	end
	if (not EnhancedTooltip.hasData) then
		return
	end

	local height = 20
	local width = EnhancedTooltip.minWidth
	local lineCount = EnhancedTooltip.lineCount
	if (lineCount == 0) then
		if (not EnhancedTooltip.hasEmbed) then 
			hideTooltip()
			return 
		end
	end

	local firstLine = EnhancedTooltipText1
	local trackHeight = firstLine:GetHeight()
	for i = 2, lineCount do
		local currentLine = getglobal("EnhancedTooltipText"..i)
		trackHeight = trackHeight + currentLine:GetHeight() + 1
	end
	height = 20 + trackHeight

	local minWidth = width

	local sWidth = GetScreenWidth()
	local sHeight = GetScreenHeight()

	local parentObject = currentTooltip.owner
	if (parentObject) then
		local align = currentTooltip.anchor

		enhTooltipParentRect = getRect(currentTooltip.owner, enhTooltipParentRect)

		local xAnchor, yAnchor
		if (enhTooltipParentRect.l - width < sWidth * 0.2) then
			xAnchor = "RIGHT"
		elseif (enhTooltipParentRect.r + width > sWidth * 0.8) then
			xAnchor = "LEFT"
		elseif (align == "ANCHOR_RIGHT") then
			xAnchor = "RIGHT"
		elseif (align == "ANCHOR_LEFT") then
			xAnchor = "LEFT"
		else
			xAnchor = "RIGHT"
		end
		if (enhTooltipParentRect.cy < sHeight/2) then
			yAnchor = "TOP"
		else
			yAnchor = "BOTTOM"
		end

		currentTooltip:ClearAllPoints()
		EnhancedTooltip:ClearAllPoints()
		local anchor = yAnchor..xAnchor

		if (anchor == "TOPLEFT") then
			EnhancedTooltip:SetPoint("BOTTOMRIGHT", parentObject:GetName(), "TOPLEFT", -5,5)
			currentTooltip:SetPoint("BOTTOMRIGHT", "EnhancedTooltip", "TOPRIGHT", 0,0)
		elseif (anchor == "TOPRIGHT") then
			EnhancedTooltip:SetPoint("BOTTOMLEFT", parentObject:GetName(), "TOPRIGHT", 5,5)
			currentTooltip:SetPoint("BOTTOMLEFT", "EnhancedTooltip", "TOPLEFT", 0,0)
		elseif (anchor == "BOTTOMLEFT") then
			currentTooltip:SetPoint("TOPRIGHT", parentObject:GetName(), "BOTTOMLEFT", -5,-5)
			EnhancedTooltip:SetPoint("TOPRIGHT", currentTooltip:GetName(), "BOTTOMRIGHT", 0,0)
		else -- BOTTOMRIGHT
			currentTooltip:SetPoint("TOPLEFT", parentObject:GetName(), "BOTTOMRIGHT", 5,-5)
			EnhancedTooltip:SetPoint("TOPLEFT", currentTooltip:GetName(), "BOTTOMLEFT", 0,0)
		end

	else
		-- No parent
		-- The only option is to tack the object underneath / shuffle it up if there aint enuff room
		currentTooltip:Show()
		enhTooltipTipRect = getRect(currentTooltip, enhTooltipTipRect)

		if (enhTooltipTipRect.b - height < 60) then
			currentTooltip:ClearAllPoints()
			currentTooltip:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", enhTooltipTipRect.l, height+60)
		end
		EnhancedTooltip:ClearAllPoints()
		if (enhTooltipTipRect.cx < 6*sWidth/10) then
			EnhancedTooltip:SetPoint("TOPLEFT", currentTooltip:GetName(), "BOTTOMLEFT", 0,0)
		else
			EnhancedTooltip:SetPoint("TOPRIGHT", currentTooltip:GetName(), "BOTTOMRIGHT", 0,0)
		end
	end
		
		
	local cWidth = currentTooltip:GetWidth()
	if (cWidth < width) then
		getglobal(currentTooltip:GetName().."TextLeft1"):SetWidth(width - 20)
		currentTooltip:Show()
	elseif (cWidth > width) then
		width = cWidth
	end
		
	EnhancedTooltip:SetHeight(height)
	EnhancedTooltip:SetWidth(width)
	EnhancedTooltip:Show()
	
	for i = 1, 20 do
		local ttMoney = getglobal("EnhancedTooltipMoney"..i)
		if (ttMoney.myLine ~= nil) then
			ttMoneyWidth = ttMoney:GetWidth()
			ttMoneyLineWidth = getglobal(ttMoney.myLine):GetWidth()
			ttMoney:ClearAllPoints()
			ttMoney:SetPoint("LEFT", ttMoney.myLine, "RIGHT", width - ttMoneyLineWidth - ttMoneyWidth - self.moneySpacing*2, 0)
		end
	end
end

-- calculate the gold, silver, and copper values based the amount of copper
function getGSC(money)
	if (money == nil) then money = 0 end
	local g = math.floor(money / 10000)
	local s = math.floor((money - (g*10000)) / 100)
	local c = math.floor(money - (g*10000) - (s*100))
	return g,s,c
end

-- formats money text by color for gold, silver, copper
function getTextGSC(money, exact)
	if not exact then
	   exact = false
	end

	local TEXT_NONE = "0"
	
	local GSC_GOLD="ffd100"
	local GSC_SILVER="e6e6e6"
	local GSC_COPPER="c8602c"
	local GSC_START="|cff%s%d|r"
	local GSC_PART=".|cff%s%02d|r"
	local GSC_NONE="|cffa0a0a0"..TEXT_NONE.."|r"

	local g, s, c = getGSC(money)

	local gsc = ""
	if (g > 0) then
		gsc = string.format(GSC_START, GSC_GOLD, g)
		if (s > 0) then
			gsc = gsc..string.format(GSC_PART, GSC_SILVER, s)
		end
		if exact then
		   gsc = gsc..string.format(GSC_PART,GSC_COPPER, c)
		end
	elseif (s > 0) then
		gsc = string.format(GSC_START, GSC_SILVER, s)
		if (c > 0) then
			gsc = gsc..string.format(GSC_PART, GSC_COPPER, c)
		end
	elseif (c > 0) then
		gsc = gsc..string.format(GSC_START, GSC_COPPER, c)
	else
		gsc = GSC_NONE
	end
		return gsc
end

function embedRender()
	for pos, lData in self.embedLines do
		self.currentGametip:AddLine(lData.line)
		if (lData.r) then
			local lastLine = getglobal(self.currentGametip:GetName().."TextLeft"..self.currentGametip:NumLines())
			lastLine:SetTextColor(lData.r,lData.g,lData.b)
		end
	end
end

function addLine(lineText, moneyAmount, embed)
	if (embed) and (self.currentGametip) then
		EnhancedTooltip.hasEmbed = true
		EnhancedTooltip.curEmbed = true
		local line = ""
		if (moneyAmount) then
			line = lineText .. ": " .. getTextGSC(moneyAmount)
		else
			line = lineText
		end
		table.insert(self.embedLines, {line = line})
		return
	end
	EnhancedTooltip.hasData = true
	EnhancedTooltip.curEmbed = false

	local curLine = EnhancedTooltip.lineCount + 1
	local line = getglobal("EnhancedTooltipText"..curLine)
	line:SetText(lineText)
	line:SetTextColor(1.0, 1.0, 1.0)
	line:Show()
	local lineWidth = line:GetWidth()

	EnhancedTooltip.lineCount = curLine
	if (moneyAmount ~= nil) and (moneyAmount > 0) then
		local curMoney = EnhancedTooltip.moneyCount + 1
		local money = getglobal("EnhancedTooltipMoney"..curMoney)
		money:SetPoint("LEFT", line:GetName(), "RIGHT", self.moneySpacing, 0)
		TinyMoneyFrame_Update(money:GetName(), math.floor(moneyAmount))
		money.myLine = line:GetName()
		money:Show()
		local moneyWidth = money:GetWidth()
		lineWidth = lineWidth + moneyWidth + self.moneySpacing
		getglobal("EnhancedTooltipMoney"..curMoney.."SilverButtonText"):SetTextColor(1.0,1.0,1.0)
		getglobal("EnhancedTooltipMoney"..curMoney.."CopperButtonText"):SetTextColor(0.86,0.42,0.19)
		EnhancedTooltip.moneyCount = curMoney
	end
	lineWidth = lineWidth + 20
	if (lineWidth > EnhancedTooltip.minWidth) then
		EnhancedTooltip.minWidth = lineWidth
	end
end

function addSeparator(embed)
	if (embed) and (self.currentGametip) then
		EnhancedTooltip.hasEmbed = true
		EnhancedTooltip.curEmbed = true
		table.insert(self.embedLines, {line = " "})
		return
	end
	EnhancedTooltip.hasData = true
	EnhancedTooltip.curEmbed = false

    local curLine = EnhancedTooltip.lineCount +1;
	local line = getglobal("EnhancedTooltipText"..curLine)
	line:SetText(" ");
	line:SetTextColor(1.0, 1.0, 1.0);
	line:Show();
	EnhancedTooltip.lineCount = curLine
end

function lineColor(r, g, b)
	if (EnhancedTooltip.curEmbed) and (self.currentGametip) then
		local n = table.getn(self.embedLines)
		self.embedLines[n].r = r
		self.embedLines[n].g = g
		self.embedLines[n].b = b
		return
	end
	local curLine = EnhancedTooltip.lineCount
	if (curLine == 0) then return end
	local line = getglobal("EnhancedTooltipText"..curLine)
	line:SetTextColor(r, g, b)
end

function lineSize_Large()
	if (EnhancedTooltip.curEmbed) and (self.currentGametip) then return end
    local curLine = EnhancedTooltip.lineCount
    if (curLine == 0) then return end
    local line = getglobal("EnhancedTooltipText"..curLine)
    line:SetFont("Fonts\\FRIZQT__.TTF", 12)
end

function lineSize_Small()
	if (EnhancedTooltip.curEmbed) and (self.currentGametip) then return end
    local curLine = EnhancedTooltip.lineCount
    if (curLine == 0) then return end
    local line = getglobal("EnhancedTooltipText"..curLine)
    line:SetFont("Fonts\\FRIZQT__.TTF", 10)
end

function lineQuality(quality)
	if ( quality ) then
		local color = ITEM_QUALITY_COLORS[quality]
		lineColor(color.r, color.g, color.b)
	else
		lineColor(1.0, 1.0, 1.0)
	end
end

function setIcon(iconPath)
	EnhancedTooltipIcon:SetTexture(iconPath)
	EnhancedTooltipIcon:Show()
	local width = EnhancedTooltipIcon:GetWidth()
	local tWid = EnhancedTooltipText1:GetWidth() + width + 20
	if (tWid > EnhancedTooltip.minWidth) then
		EnhancedTooltip.minWidth = tWid
	end
	tWid = EnhancedTooltipText2:GetWidth() + width + 20
	if (tWid > EnhancedTooltip.minWidth) then
		EnhancedTooltip.minWidth = tWid
	end
end

function gtHookOnHide()
	local curName = ""
	local hidingName = this:GetName()
	if (self.currentGametip) then curName = self.currentGametip:GetName() end
	if (curName == hidingName) then
		HideObj = hidingName
		self.hideTime = self.eventTimer + 0.1
	end
end

function doHyperlink(reference, link, button)
	if (ItemRefTooltip:IsVisible()) then
		local itemName = ItemRefTooltipTextLeft1:GetText()
		if (itemName and self.currentItem ~= itemName) then
			self.currentItem = itemName

			local testPopup = false
			if (button == "RightButton") then
				testPopup = true
			end
			local callRes = tooltipCall(ItemRefTooltip, itemName, link, -1, 1, 0, testPopup, reference)
			if (callRes == true) then 
				self.oldChatItem = {['reference']=reference, ['link']=link, ['button']=button, ['embed']=EnhancedTooltip.hasEmbed}
			elseif (callRes == false) then
				return false;
			end
		end
	end
end

function checkHide()
	if (self.hideTime == 0) then return end

	if (self.eventTimer >= self.hideTime) then
		hideTooltip()
		if (HideObj and HideObj == "ItemRefTooltip") then
			-- closing chatreferenceTT?
			self.oldChatItem = nil -- remove old chatlink data
		elseif self.oldChatItem then
			-- closing another tooltip
			-- redisplay old chatlinkdata, if it was not embeded
			if not self.oldChatItem.embed then
				doHyperlink(self.oldChatItem.reference, self.oldChatItem.link, self.oldChatItem.button)
			end
		end
	end
end

function nameFromLink(link)
	local name
	if( not link ) then
		return nil
	end
	_, _, name = string.find(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r");
 	if (name) then
		return name;
 	end
	return nil
end

function hyperlinkFromLink(link)
		if( not link ) then
				return nil
		end
		_, _, hyperlink = string.find(link, "|H([^|]+)|h");
	 	if (hyperlink) then
			return hyperlink;
	 	end
		return nil
end

function baselinkFromLink(link)
		if( not link ) then
				return nil
		end
		_, _, baselink = string.find(link, "|Hitem:(%d+:%d+:%d+):%d+|h");
	 	if (baselink) then
			return baselink;
	 	end
		return nil
end

function qualityFromLink(link)
	local color
	if (not link) then return nil end
	_, _, color = string.find(link, "|c(%x+)|Hitem:%d+:%d+:%d+:%d+|h%[.-%]|h|r");
	if (color) then
		if (color == "ffff8000") then return 5;--[[ Legendary ]] end
		if (color == "ffa335ee") then return 4;--[[ Epic ]] end
		if (color == "ff0070dd") then return 3;--[[ Rare ]] end
		if (color == "ff1eff00") then return 2;--[[ Uncommon ]] end
		if (color == "ffffffff") then return 1;--[[ Common ]] end
		if (color == "ff9d9d9d") then return 0;--[[ Poor ]] end
	end
	return -1
end

function fakeLink(hyperlink, quality, name)
	-- make this function nilSafe, as it's a global one and might be used by external addons
	if not hyperlink then
		return nil
	end
	if (quality == nil) then quality = -1 end
	if (name == nil) then name = "unknown" end
	local color = "ffffff"
	if (quality == 5) then color = "ff8000"
	elseif (quality == 4) then color = "a335ee"
	elseif (quality == 3) then color = "0070dd"
	elseif (quality == 2) then color = "1eff00"
	elseif (quality == 0) then color = "9d9d9d"
	end
	return "|cff"..color.. "|H"..hyperlink.."|h["..name.."]|h|r"
end

function tooltipCall(frame, name, link, quality, count, price, forcePopup, hyperlink)
	self.currentGametip = frame
	self.hideTime = 0

	local itemSig = frame:GetName()
	if (link) then itemSig = itemSig..link end
	if (count) then itemSig = itemSig..count end
	if (price) then itemSig = itemSig..price end
	
	if (self.currentItem and self.currentItem == itemSig) then
		-- We are already showing this... No point doing it again.
		showTooltip(self.currentGametip)
		return
	end

	self.currentItem = itemSig
	
	if (quality==nil or quality==-1) then
		local linkQuality = qualityFromLink(link)
		if (linkQuality and linkQuality > -1) then
			quality = linkQuality
		else
			quality = -1
		end
	end
	if (hyperlink == nil) then hyperlink = link end
	local extract = hyperlinkFromLink(hyperlink)
	if (extract) then hyperlink = extract end

	local showTip = true
	local popupKeyPressed = (
		(self.forcePopupKey == "ctrl" and IsControlKeyDown()) or
		(self.forcePopupKey == "alt" and IsAltKeyDown()) or
		(self.forcePopupKey == "shift" and IsShiftKeyDown())
	)
		
	if ((forcePopup == true) or ((forcePopup == nil) and (popupKeyPressed))) then
		local popupTest = checkPopup(name, link, quality, count, price, hyperlink)
		if (popupTest) then
			showTip = false
		end
	end
		
	if (showTip) then
		clearTooltip()
		self.showIgnore = true
		EnhTooltip.AddTooltip(frame, name, link, quality, count, price)
		self.showIgnore = false
		showTooltip(frame)
		self.currentItem = itemSig
		return true
	else
		frame:Hide()
		hideTooltip()
		return false
	end
end



------------------------
-- Hook calling functions
------------------------

function callCheckPopup(name, link, quality, count, price, hyperlink)
	if (EnhTooltip.CheckPopup(name, link, quality, count, price, hyperlink)) then
		return true;
	end
	return false 
end

function merchantScanner()
	local npcName = UnitName("NPC")
	local numMerchantItems = GetMerchantNumItems()
	local link, quality, name, texture, price, quantity, numAvailable, isUsable
	for i=1, numMerchantItems, 1 do
		link = GetMerchantItemLink(i)
		quality = qualityFromLink(link)
		name, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(i)
		EnhTooltip.MerchantHook(npcName, i, name, link, quality, quantity, price, numAvailable)
	end
end

function callBankHook()
	if not (BankFrame and BankFrame:IsVisible()) then return end
	EnhTooltip.BankHook(0)
end

function callBagHook(funcVars, event, bagNumber)
	if (bagNumber >= 5) and (bagNumber < 10) then
		if not (BankFrame and BankFrame:IsVisible()) then return end
		EnhTooltip.BankHook(bagNumber)
	else
		EnhTooltip.BagHook(bagNumber)
	end
end

function callTradeHook(funcVars, event, selID)
	EnhTooltip.TradeHook(funcVars[1], selID)
end



------------------------
-- Tooltip functions that we have hooked
------------------------

function chatHookOnHyperlinkShow(funcArgs, retVal, reference, link, button, ...)
	if (IsAltKeyDown()) and (AuctionFrame:IsVisible()) then
		AuctionFrameTab_OnClick(1)
		local itemID, randomProp, enchant, uniqID, itemName = breakLink(link)
		if (itemName) then
			QueryAuctionItems(itemName, "", "", nil, nil, nil, 0, nil, nil)
			ItemRefTooltip:Hide()
		end
		return
	end

	doHyperlink(reference, link, button)
end

function afHookOnEnter(funcArgs, retVal, type, index)
	local link = GetAuctionItemLink(type, index)
	if (link) then
		local name = nameFromLink(link)
		if (name) then
			local aiName, aiTexture, aiCount, aiQuality, aiCanUse, aiLevel, aiMinBid, aiMinIncrement, aiBuyoutPrice, aiBidAmount, aiHighBidder, aiOwner = GetAuctionItemInfo(type, index)
			tooltipCall(GameTooltip, name, link, aiQuality, aiCount)
		end
	end
end

function cfHookUpdate(funcArgs, retVal, frame)
	local frameID = frame:GetID()
	local frameName = frame:GetName()
	local iButton
	for iButton = 1, frame.size do
		local button = getglobal(frameName.."Item"..iButton)
		if (GameTooltip:IsOwned(button)) then
			local buttonID = button:GetID()
			local link = GetContainerItemLink(frameID, buttonID)
			local name = nameFromLink(link)
				
			if (name) then
				local texture, itemCount, locked, quality, readable = GetContainerItemInfo(frameID, buttonID)
				if (quality == nil) then quality = qualityFromLink(link) end

				tooltipCall(GameTooltip, name, link, quality, itemCount)
			end
		end
	end
end

function gtHookSetLootItem(funcArgs, retVal, frame, slot)
	local link = GetLootSlotLink(slot)
	local name = nameFromLink(link)
	if (name) then
		local texture, item, quantity, quality = GetLootSlotInfo(slot)
		if (quality == nil) then quality = qualityFromLink(link) end
		tooltipCall(GameTooltip, name, link, quality, quantity)
	end
end

function gtHookSetQuestItem(funcArgs, retVal, frame, qtype, slot)
	local link = GetQuestItemLink(qtype, slot)
	if (link) then
		local name, texture, quantity, quality, usable = GetQuestItemInfo(qtype, slot)
		tooltipCall(GameTooltip, name, link, quality, quantity)
	end
end

function gtHookSetQuestLogItem(funcArgs, retVal, frame, qtype, slot)
	local link = GetQuestLogItemLink(qtype, slot)
	if (link) then
		local name, texture, quantity, quality, usable = GetQuestLogRewardInfo(slot)
		if (name == nil) then name = nameFromLink(link) end
		quality = qualityFromLink(link) -- I don't trust the quality returned from the above function.

		tooltipCall(GameTooltip, name, link, quality, quantity)
	end
end

function gtHookSetBagItem(funcArgs, retVal, frame, frameID, buttonID)
	-- local hasCooldown = retVal[1]
	-- local repairCost = retVal[2]

	local link = GetContainerItemLink(frameID, buttonID)
	local name = nameFromLink(link)

	if (name) then
		local texture, itemCount, locked, quality, readable = GetContainerItemInfo(frameID, buttonID)
		if (quality==nil or quality==-1) then quality = qualityFromLink(link) end

		tooltipCall(GameTooltip, name, link, quality, itemCount)
	end
end

function gtHookSetInventoryItem(funcArgs, retVal, frame, unit, slot, ...)
	-- local hasItem = retVal[1]
	-- local hasCooldown = retVal[2]
	-- local repairCost = retVal[3]

	local link = GetInventoryItemLink(unit, slot)
	if (link) then
		local name = nameFromLink(link)
		local quantity
		if (slot >= 20 and slot <= 23) then
			-- Workaround for bag slots. Quiver slots report the number of
			-- arrows in there instead of 1 for the actual bag.
			-- And well, bags aren't stackable anyway, so here you go:
			quantity = 1
		else
			quantity = GetInventoryItemCount(unit, slot)
		end
		local quality = GetInventoryItemQuality(unit, slot)
		if (quality == nil) then quality = qualityFromLink(link) end

		tooltipCall(GameTooltip, name, link, quality, quantity)
	end
end

function gtHookSetMerchantItem(funcArgs, retVal, frame, slot)
	local link = GetMerchantItemLink(slot)
	if (link) then
		local name, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(slot)
		local quality = qualityFromLink(link)
		tooltipCall(GameTooltip, name, link, quality, quantity, price)
	end
end

function gtHookSetCraftItem(funcArgs, retVal, frame, skill, slot)
	local link
	if (slot) then
		link = GetCraftReagentItemLink(skill, slot)
		if (link) then
			local name, texture, quantity, quantityHave = GetCraftReagentInfo(skill, slot)
			local quality = qualityFromLink(link)
			tooltipCall(GameTooltip, name, link, quality, quantity, 0)
		end
	else
		link = GetCraftItemLink(skill)
		if (link) then
			local name = nameFromLink(link)
			local quality = qualityFromLink(link)
			tooltipCall(GameTooltip, name, link, quality, 1, 0)
		end
	end
end

function gtHookSetTradeSkillItem(funcArgs, retVal, frame, skill, slot)
	local link
	if (slot) then
		link = GetTradeSkillReagentItemLink(skill, slot)
		if (link) then
			local name, texture, quantity, quantityHave = GetTradeSkillReagentInfo(skill, slot)
			local quality = qualityFromLink(link)
			tooltipCall(GameTooltip, name, link, quality, quantity, 0)
		end
	else
		link = GetTradeSkillItemLink(skill)
		if (link) then
			local name = nameFromLink(link)
			local quality = qualityFromLink(link)
			tooltipCall(GameTooltip, name, link, quality, 1, 0)
		end
	end
end

-- Given a Blizzard item link, breaks it into it's itemID, randomProperty, enchantProperty, uniqueness and name
function breakLink(link)
	if (type(link) ~= 'string') then return end
	local i,j, itemID, enchant, randomProp, uniqID, name = string.find(link, "|Hitem:(%d+):(%d+):(%d+):(%d+)|h[[]([^]]+)[]]|h")
	return tonumber(itemID or 0), tonumber(randomProp or 0), tonumber(enchant or 0), tonumber(uniqID or 0), name
end


function findItemInBags(findName)
	for bag = 0, 4, 1 do
		size = GetContainerNumSlots(bag)
		if (size) then
			for slot = size, 1, -1 do
				local link = GetContainerItemLink(bag, slot)
				if (link) then
					local itemID, randomProp, enchant, uniqID, itemName = breakLink(link)
					if (itemName == findName) then
						return bag, slot, itemID, randomProp, enchant, uniqID
					end
				end
			end
		end
	end
end

function gtHookSetAuctionSellItem(funcArgs, retVal, frame)
	local name, texture, quantity, quality, canUse, price = GetAuctionSellItemInfo()
	if (name) then
		local bag, slot = findItemInBags(name)
		if (bag) then
			local link = GetContainerItemLink(bag, slot)
			if (link) then
				tooltipCall(GameTooltip, name, link, quality, quantity, price)
			end
		end
	end
end

function imiHookOnEnter()
	if(not IM_InvList) then return end
	local id = this:GetID()

	if(id == 0) then
		id = this:GetParent():GetID()
	end
	local offset = FauxScrollFrame_GetOffset(ItemsMatrix_IC_ScrollFrame)
	local item = IM_InvList[id + offset]

	if (not item) then return end
	local imlink = ItemsMatrix_GetHyperlink(item.name)
	local link = fakeLink(imlink, item.quality, item.name)
	if (link) then
		tooltipCall(GameTooltip, item.name, link, item.quality, item.count, 0)
	end
end

function imHookOnEnter()
	local imlink = ItemsMatrix_GetHyperlink(this:GetText())
	if (imlink) then
		local name = this:GetText()
		local link = fakeLink(imlink, -1, name)
		tooltipCall(GameTooltip, name, link, -1, 1, 0)
	end
end

function getLootLinkServer()
	return LootLinkState.ServerNamesToIndices[GetCVar("realmName")]
end

function getLootLinkLink(name)
	local itemLink = ItemLinks[name]
	if (itemLink and itemLink.c and itemLink.i and LootLink_CheckItemServer(itemLink, getLootLinkServer())) then
		local item = string.gsub(itemLink.i, "(%d+):(%d+):(%d+):(%d+)", "%1:0:%3:%4")
		local link = "|c"..itemLink.c.."|Hitem:"..item.."|h["..name.."]|h|r"
		return link
	end
	return nil
end

function llHookOnEnter()
	local name = this:GetText()
	local link = getLootLinkLink(name)
	if (link) then
		local quality = qualityFromLink(link)
		tooltipCall(LootLinkTooltip, name, link, quality, 1, 0)
	end
end

function gtHookSetOwner(funcArgs, retVal, frame, owner, anchor)
	frame.owner = owner
	frame.anchor = anchor
end


------------------------
-- Operation functions
------------------------

function setElapsed(elapsed)
	if (elapsed) then
		self.eventTimer = self.eventTimer + elapsed
	end
	checkHide()
	return self.eventTimer
end

function setMoneySpacing(spacing)
	if (spacing ~= nil) then self.moneySpacing = spacing end
	return self.moneySpacing
end

function setPopupKey(key)
	if (key ~= nil) then self.forcePopupKey = key end
	return self.forcePopupKey
end


------------------------
-- Debug functions
------------------------

local function dump(...)
	local out = "";
	for i = 1, arg.n, 1 do
		local d = arg[i];
		local t = type(d);
		if (t == "table") then
			out = out .. "{";
			local first = true;
			if (d) then
				for k, v in pairs(d) do
					if (not first) then out = out .. ", "; end
					first = false;
					out = out .. dump(k);
					out = out .. " = ";
					out = out .. dump(v);
				end
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

function debugPrint(...)
	local debugWin = 0;
	local name, shown;
	for i=1, NUM_CHAT_WINDOWS do
		name,_,_,_,_,_,shown = GetChatWindowInfo(i);
		if (string.lower(name) == "ettdebug") then debugWin = i; break; end
	end
	if (debugWin == 0) then return end

	local out = "";
	for i = 1, arg.n, 1 do
		if (i > 1) then out = out .. ", "; end
		local t = type(arg[i]);
		if (t == "string") then
			out = out .. '"'..arg[i]..'"';
		elseif (t == "number") then
			out = out .. arg[i];
		else
			out = out .. dump(arg[i]);
		end
	end
	getglobal("ChatFrame"..debugWin):AddMessage(out, 1.0, 1.0, 0.3);
end


------------------------
-- Load and initialization functions
------------------------

-- The new blizzard addons are called:
--   Blizzard_TrainerUI,  Blizzard_MacroUI,    Blizzard_RaidUI,  Blizzard_TradeSkillUI,
--   Blizzard_InspectUI,  Blizzard_BattlefieldMinimap,           Blizzard_TalentUI,
--   Blizzard_AuctionUI,  Blizzard_BindingUI,  Blizzard_CraftUI


-- Hook in alternative Auctionhouse tooltip code
local function hookAuctionHouse()
	Stubby.RegisterFunctionHook("AuctionFrameItem_OnEnter", 200, afHookOnEnter)
end

-- Hook the ItemsMatrix tooltip functions
local function hookItemsMatrix()
	Stubby.RegisterFunctionHook("IMInv_ItemButton_OnEnter", 200, imiHookOnEnter)
	Stubby.RegisterFunctionHook("ItemsMatrixItemButton_OnEnter", 200, imHookOnEnter)
end

-- Hook the LootLink tooltip function
local function hookLootLink()
	Stubby.RegisterFunctionHook("LootLinkItemButton_OnEnter", 200, llHookOnEnter)
end

-- Hook tradeskill functions
local function hookTradeskill()
	Stubby.RegisterFunctionHook("TradeSkillFrame_OnUpdate", 200, callTradeHook, "trade", "")
	Stubby.RegisterFunctionHook("TradeSkillFrame_SetSelection", 200, callTradeHook, "trade", "")
end

-- Hook craft functions
local function hookCraft()
	Stubby.RegisterFunctionHook("CraftFrame_Update", 200, callTradeHook, "craft", "");
	Stubby.RegisterFunctionHook("CraftFrame_SetSelection", 200, callTradeHook, "craft", "");
end

function ttInitialize()
	--[[
	----  Establish hooks to all the game tooltips.
	--]]

	-- Hook in alternative Chat/Hyperlinking code
	Stubby.RegisterFunctionHook("ChatFrame_OnHyperlinkShow", 200, chatHookOnHyperlinkShow)

	-- Container frame linking
	Stubby.RegisterFunctionHook("ContainerFrame_Update", 200, cfHookUpdate)

	-- Game tooltips
	Stubby.RegisterFunctionHook("GameTooltip.SetLootItem", 200, gtHookSetLootItem);
	Stubby.RegisterFunctionHook("GameTooltip.SetQuestItem", 200, gtHookSetQuestItem);
	Stubby.RegisterFunctionHook("GameTooltip.SetQuestLogItem", 200, gtHookSetQuestLogItem);
	Stubby.RegisterFunctionHook("GameTooltip.SetInventoryItem", 200, gtHookSetInventoryItem);
	Stubby.RegisterFunctionHook("GameTooltip.SetBagItem", 200, gtHookSetBagItem);
	Stubby.RegisterFunctionHook("GameTooltip.SetMerchantItem", 200, gtHookSetMerchantItem);
	Stubby.RegisterFunctionHook("GameTooltip.SetCraftItem", 200, gtHookSetCraftItem);
	Stubby.RegisterFunctionHook("GameTooltip.SetTradeSkillItem", 200, gtHookSetTradeSkillItem);
	Stubby.RegisterFunctionHook("GameTooltip.SetAuctionSellItem", 200, gtHookSetAuctionSellItem);
	Stubby.RegisterFunctionHook("GameTooltip.SetOwner", 200, gtHookSetOwner);
	Stubby.RegisterFunctionHook("GameTooltip_OnHide", 200, gtHookOnHide);

	-- Establish hooks for us to use.
	Stubby.RegisterAddOnHook("Blizzard_AuctionUI", "EnhTooltip", hookAuctionHouse)
	Stubby.RegisterAddOnHook("ItemsMatrix", "EnhTooltip", hookItemsMatrix)
	Stubby.RegisterAddOnHook("LootLink", "EnhTooltip", hookLootLink)
	Stubby.RegisterAddOnHook("Blizzard_TradeSkillUI", "EnhTooltip", hookTradeskill)
	Stubby.RegisterAddOnHook("Blizzard_CraftUI", "EnhTooltip", hookCraft)

	-- Register event notification
	Stubby.RegisterEventHook("MERCHANT_SHOW", "EnhTooltip", merchantScanner);
	Stubby.RegisterEventHook("TRADE_SKILL_SHOW", "EnhTooltip", callTradeHook, 'trade');
	Stubby.RegisterEventHook("TRADE_SKILL_CLOSE", "EnhTooltip", callTradeHook, 'trade');
	Stubby.RegisterEventHook("CRAFT_SHOW", "EnhTooltip", callTradeHook, 'craft');
	Stubby.RegisterEventHook("CRAFT_CLOSE", "EnhTooltip", callTradeHook, 'craft');
	Stubby.RegisterEventHook("BANKFRAME_OPENED", "EnhTooltip", callBankHook);
	Stubby.RegisterEventHook("PLAYERBANKSLOTS_CHANGED", "EnhTooltip", callBankHook);
	Stubby.RegisterEventHook("BAG_UPDATE", "EnhTooltip", callBagHook);
end


-- =============== EVENT HANDLERS =============== --

function TT_OnLoad()
	EnhancedTooltip:SetBackdropColor(0,0,0)
	clearTooltip()
	ttInitialize()
end

function TT_OnUpdate(elapsed)
	setElapsed(elapsed)
end

-- =============== DEFINE ACCESS OBJECT =============== --

-- Global object
EnhTooltip = {
	['AddTooltip']        = addTooltip,
	['CheckPopup']        = checkPopup,
	['MerchantHook']      = merchantHook,
	['TradeHook']         = tradeHook,
	['BankHook']          = bankHook,
	['BagHook']           = bagHook,

	['AddLine']           = addLine,
	['AddSeparator']      = addSeparator,
	['LineColor']         = lineColor,
	['LineQuality']       = lineQuality,
	['LineSize_Large']    = lineSize_Large,
	['LineSize_Small']    = lineSize_Small,
	['SetIcon']           = setIcon,

	['ClearTooltip']      = clearTooltip,
	['HideTooltip']       = hideTooltip,
	['ShowTooltip']       = showTooltip,

	['GetGSC']            = getGSC,
	['GetTextGSC']        = getTextGSC,
	['BaselinkFromLink']  = baselinkFromLink,
	['BreakLink']         = breakLink,
	['FindItemInBags']    = findItemInBags,

	['FakeLink']          = fakeLink,
	['HyperlinkFromLink'] = hyperlinkFromLink,
	['NameFromLink']      = nameFromLink,
	['QualityFromLink']   = qualityFromLink,

	['SetMoneySpacing']   = setMoneySpacing,
	['SetPopupKey']       = setPopupKey,
	['TooltipCall']       = tooltipCall,

	['SetElapsed']        = setElapsed,
	['DebugPrint']        = debugPrint,
}



--- Temporary backwards compatibility ---
-- This will go away eventually, so upgrade now!
function TT_AddTooltip() end
Stubby.RegisterFunctionHook("EnhTooltip.AddTooltipHook", 100, TT_AddTooltip)
TT_HideTooltip       = hideTooltip
TT_ClearTooltip      = clearTooltip
TT_GetGSC            = getGSC
TT_GetTextGSC        = getTextGSC
TT_AddLine           = addLine
TT_LineColor         = lineColor
TT_LineQuality       = lineQuality
TT_SetIcon           = setIcon
TT_NameFromLink      = nameFromLink
TT_HyperlinkFromLink = hyperlinkFromLink
TT_QualityFromLink   = qualityFromLink
TT_FakeLink          = fakeLink
TT_BreakLink         = breakLink
TT_FindItemInBags    = findItemInBags
TT_SetElapsed        = setElapsed
TT_SetMoneySpacing   = setMoneySpacing
TT_SetPopupKey       = setPopupKey
-- DO NOT USE THESE FUNCTIONS IN NEW ADDONS --
-- Use the EnhTooltip object instead --



