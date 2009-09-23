
if not AucAdvanced then return end

local libType, libName = "Util", "Glypher"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local print,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()
local tooltip = LibStub("nTipHelper:1")
local timeRemaining
local coFG
local onupdateframe
local INSCRIPTION_SPELLNAME = GetSpellInfo(45357)
local _, _, _, _, _, GLYPH_TYPE = GetItemInfo(42956)
if not GLYPH_TYPE then GLYPH_TYPE = "Glyph" end
print("Localized name of itemType for Glyphs: " .. GLYPH_TYPE)

-- temporary check for Auc-Stat-Glypher
if AucAdvanced.Modules.Stat.Glypher then
    message("For this version of Auc-Util-Glypher, you MUST manually copy (in game) your Auc-Stat-Glypher configuration over to Auc-Util-Glypher, AND disable Auc-Stat-Glypher. The Glypher pricing model is now included in Auc-Util-Glypher.")
    return
end
--
function lib.Processor(callbackType, ...)
    if (callbackType == "config") then
        private.SetupConfigGui(...)
    elseif (callbackType == "configchanged") then
        private.ConfigChanged(...)
    elseif (callbackType == "auctionui") then
        private.auctionHook() ---When AuctionHouse loads hook the auction function we need
    elseif (callbackType == "scanprogress") then
        private.ScanProgressReceiver(...)
    elseif (callbackType == "scanstats") then
        private.ScanComplete(...)
    end
end

--after Auction House Loads Hook the Window Display event
function private.auctionHook()
    hooksecurefunc("AuctionFrameAuctions_Update", private.storeCurrentAuctions)
end

function private.ScanComplete()
    --need to set last scan time so we can disable the refresh button for 2-5 minutes after doing a scan (to be nice to Blizzard and also to be able to notice when the refresh is actually done
    if private.frame then
        private.frame.refreshButton:Enable()
        private.frame.refreshButton:SetText("Scan Glyphs")
    end
end

function private.ScanProgressReceiver(state, totalAuctions, scannedAuctions, elapsedTime)
    totalAuctions = tonumber(totalAuctions) or 0
    scannedAuctions = tonumber(scannedAuctions) or 0
    elapsedTime = tonumber(elapsedTime) or 0

    --borrowed this from Auc-Util-ScanProgress/ScanProgress.lua
    local numAuctionsPerPage = NUM_AUCTION_ITEMS_PER_PAGE

    -- Prefer the elapsed time which is provided by core and excludes paused time.
    local secondsElapsed = elapsedTime or (time() - private.scanStartTime)

    local auctionsToScan = totalAuctions - scannedAuctions

    local currentPage = math.floor(scannedAuctions / numAuctionsPerPage)

    local totalPages = totalAuctions / numAuctionsPerPage
    if (totalPages - math.floor(totalPages) > 0) then
        totalPages = math.ceil(totalPages)
    else
        totalPages = math.floor(totalPages)
    end

    local auctionsScannedPerSecond = scannedAuctions / secondsElapsed
    local secondsToScanCompletion = auctionsToScan / auctionsScannedPerSecond
    timeRemaining = SecondsToTime(secondsToScanCompletion)
    --print(timeRemaining .. " - " .. secondsToScanCompletion) -- debug to figure out how to eliminate the -hugenumber Sec
    -- and when it's blank, then go back to just "Refresh Glyphs" since scanprogress seems to trigger after scancomplete
    if private.frame then
        if timeRemaining and auctionsScannedPerSecond and secondsElapsed and scannedAuctions and (secondsToScanCompletion > 1) and (secondsToScanCompletion < 600)  then
            private.frame.refreshButton:SetText(timeRemaining)
        else
            private.frame.refreshButton:SetText("Scan Glyphs")
        end
    end


end

function lib.OnLoad()
    default("util.glypher.moneyframeprofit", 35000)
    default("util.glypher.history", 14)
    default("util.glypher.stockdays", 2)
    default("util.glypher.maxstock", 5)
    default("util.glypher.failratio", 30)
    default("util.glypher.makefornew", 2)
    default("util.glypher.herbprice", 8000)
    default("util.glypher.profitAppraiser", 100)
    default("util.glypher.profitBeancounter", 100)
    default("util.glypher.profitMarket", 50)
    default("util.glypher.pricemodel.active", true) --weltmeister is this still needed?
    default("util.glypher.pricemodel.min", 32500)
    default("util.glypher.pricemodel.max", 999999)
    default("util.glypher.pricemodel.undercut", 1)
    default("util.glypher.pricemodel.whitelist", "")

--Check to see if we've got a recent enough version of AucAdvanced
    local rev = AucAdvanced.GetCurrentRevision() or 0
    if rev < 4409 then
        local mess = "Auc-Util-Glypher requires Auctioneer Advanced build >= 4409"
        DEFAULT_CHAT_FRAME:AddMessage(mess,1.0,0.0,0.0)
        mess = "Auc-Util-Glypher will still load, but some features are guaranteed to NOT work"
                DEFAULT_CHAT_FRAME:AddMessage(mess,1.0,0.0,0.0)
    end

    local sideIcon
    if LibStub then
        local SlideBar = LibStub:GetLibrary("SlideBar", true)
        if SlideBar then
            sideIcon = SlideBar.AddButton("Glypher", "Interface\\AddOns\\Auc-Util-Glypher\\Images\\Glypher")
            sideIcon:RegisterForClicks("LeftButtonUp","RightButtonUp") --What type of click you want to respond to
            sideIcon:SetScript("OnClick", private.SlideBarClick) --same function that the addons current minimap button calls
            sideIcon.tip = {
            "Auc-Util-Glypher",
            "Open the glypher gui",
            --"{{Click}} Open the glypher gui",
            --"{{Right-Click}} BUTTON MOUSEOVER CLICK DESCRIPTION IF WANTED",--remove lines if not wanted
            }
        end
    end
    private.sideIcon = sideIcon
end

function private.SlideBarClick(_, button)
    if private.gui and private.gui:IsShown() then
        AucAdvanced.Settings.Hide()
    else
        AucAdvanced.Settings.Show()
        private.gui:ActivateTab(private.id)
    end
end


--[[ Local functions ]]--

local frame
function private.SetupConfigGui(gui)
    -- The defaults for the following settings are set in the lib.OnLoad function
    local id = gui:AddTab(libName, libType.." Modules")
    gui:MakeScrollable(id)

    local SelectBox = LibStub:GetLibrary("SelectBox")
    local ScrollSheet = LibStub:GetLibrary("ScrollSheet")
    --Add Drag slot / Item icon
    frame = gui.tabs[id].content
    private.gui = gui
    private.id = id
    private.frame = frame

    frame.SetButtonTooltip = function(text)
        if text and get("util.appraiser.buttontips") then
            GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
            GameTooltip:SetText(text)
        end
    end

    gui:AddHelp(id, "what is Glypher?",
        "What is Glypher?",
        "Glyher is a work-in-progress. Its goal is to assist in managing a profitable glyph-based business."
    )

    gui:AddControl(id, "Subhead", 0, "Glypher: Profitable Glyph Utility")

    gui:AddControl(id, "Subhead", 0, "Glyph creation configuration")

    gui:AddControl(id, "MoneyFrame", 0, 1, "util.glypher.moneyframeprofit", "Minimum profit")
    gui:AddTip(id, "Sets the minimum profit required to queue glyphs to craft.")

    gui:AddControl(id, "Text", 0, 1, "util.glypher.ink", "Restrict ink to")
    gui:AddTip(id, "Restrict glyphs to those requiring this ink. Leave blank to craft all glyphs regardless of ink.")

    gui:AddControl(id, "NumeriSlider", 0, 1, "util.glypher.history",    1, 31, 1, "Consider sales")
    gui:AddTip(id, "Consider sales you've made on all toons from the last number of days selected.")

    gui:AddControl(id, "NumeriSlider", 0, 1, "util.glypher.failratio", 0, 500, 1, "expired filter")
    gui:AddTip(id, "The expired:success (slider:1) ratio at which we will not craft glyphs. For failures we go back to the start of BeanCounter history.\nIf set to 0 this feature will be disabled.")

    gui:AddControl(id, "NumeriSlider", 0, 1, "util.glypher.stockdays", 1, 8, 1, "Days to stock")
    gui:AddTip(id, "Number of days worth of glyphs to stock based upon your considered sales")

    gui:AddControl(id, "NumeriSlider", 0, 1, "util.glypher.maxstock", 1, 40, 1, "Max stock")
    gui:AddTip(id, "Maximum number of each glyph to stock.")

    gui:AddControl(id, "MoneyFrame", 0, 1, "util.glypher.herbprice", "Price of single Northrend herb")
    gui:AddTip(id, "Used to calculate the price of Ink of the Sea which can be traded for most other inks.")

    gui:AddControl(id, "Subhead", 0, "New glyph configuration")

    gui:AddControl(id, "NumeriSlider", 0, 1, "util.glypher.makefornew", 0, 20, 1, "Make new")
    gui:AddTip(id, "Number of glyphs (probably newly learned) to make when there are zero sales and zero failures in history.")

    local weightWords = "for evaluation of new or previously unprofitable glyphs."

    gui:AddControl(id, "NumeriSlider", 0, 1, "util.glypher.profitAppraiser", 1, 100, 1, "Current model")
    gui:AddTip(id, "Relative weight for the current pricing model set " .. weightWords)

    gui:AddControl(id, "NumeriSlider", 0, 1, "util.glypher.profitBeancounter", 1, 100, 1, "Sales history")
    gui:AddTip(id, "Relative weight for the Beancounter sales history, restricted by your consideration period, " .. weightWords)

    gui:AddControl(id, "NumeriSlider", 0, 1, "util.glypher.profitMarket", 1, 100, 1, "Market price")
    gui:AddTip(id, "Relative weight for the Market price " .. weightWords)

    gui:AddControl(id, "Subhead", 0, "Glypher pricing model")

    --gui:AddControl(id, "Subhead", 0, "Minimum Sale Price")
    gui:AddControl(id, "Note", 0, 1, nil, nil, "Minimum Sale Price")
    gui:AddControl(id, "MoneyFrame", 0, 1, "util.glypher.pricemodel.min")
    gui:AddTip(id, "The price that Glypher will never go below in order to undercut others")


    --gui:AddControl(id, "Subhead", 0, "Maximum Sale Price")
    gui:AddControl(id, "Note", 0, 1, nil, nil, "Maximum Sale Price")
    gui:AddControl(id, "MoneyFrame", 0, 1, "util.glypher.pricemodel.max")
    gui:AddTip(id, "The price that Glypher will never go above in order to overcut others")


    --gui:AddControl(id, "Subhead", 0, "Undercut Amount")
    gui:AddControl(id, "Note", 0, 1, nil, nil, "Undercut Amount")
    gui:AddControl(id, "MoneyFrame", 0, 1, "util.glypher.pricemodel.undercut")
    gui:AddTip(id, "The amount that you undercut others")


    --gui:AddControl(id, "Subhead", 0, "Whitelist")
    gui:AddControl(id, "Note", 0, 1, nil, nil, "Whitelist")
    gui:AddControl(id, "Text", 0, 1, "util.glypher.pricemodel.whitelist")
    gui:AddTip(id, "The players to whitelist on undercuts (blank for no whitelist, separarate whitelisted users with a ':')") --eventually have a list to edit


    frame.refreshButton = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
    frame.refreshButton:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 325, 225)
    frame.refreshButton:SetWidth(110)
    frame.refreshButton:SetText("Scan Glyphs")
    frame.refreshButton:SetScript("OnClick", function() private.refreshAll() end)
    frame.refreshButton:SetScript("OnEnter", function() return frame.SetButtonTooltip("Click to do a category scan on glyphs, refreshing Auctioneers image of all glyphs.") end)
    frame.refreshButton:SetScript("OnLeave", function() return GameTooltip:Hide() end)

    frame.searchButton = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
    frame.searchButton:SetPoint("TOP", frame.refreshButton, "BOTTOM", 0, -5)
    frame.searchButton:SetWidth(110)
    frame.searchButton:SetText("Get Profitable")
    frame.searchButton:SetScript("OnClick", function() private.findGlyphs() end)
    frame.searchButton:SetScript("OnEnter", function() return frame.SetButtonTooltip("Click to get profitable glyphs.") end)
    frame.searchButton:SetScript("OnLeave", function() return GameTooltip:Hide() end)

    frame.skilletButton = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
    frame.skilletButton:SetPoint("TOP", frame.searchButton, "BOTTOM", 0, -5)
    frame.skilletButton:SetWidth(110)
    frame.skilletButton:SetText("Add to Skill")
    frame.skilletButton:SetScript("OnClick", function() private.addtoCraft() end)
    frame.skilletButton:SetScript("OnEnter", function() return frame.SetButtonTooltip("Click to add profitable glyphs from the list to Skillet.") end)
    frame.skilletButton:SetScript("OnLeave", function() return GameTooltip:Hide() end)

    --Create the glyph list results frame
    frame.glypher = CreateFrame("Frame", nil, frame)
    frame.glypher:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 32, edgeSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })

    frame.glypher:SetBackdropColor(0, 0, 0.0, 0.5)
    frame.glypher:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -138)
    frame.glypher:SetPoint("BOTTOM", frame, "BOTTOM", 0, -135)
    frame.glypher:SetWidth(275)
    frame.glypher:SetHeight(310)

    frame.glypher.sheet = ScrollSheet:Create(frame.glypher, {
        { "Glyph", "TOOLTIP", 150 },
        { "#", "NUMBER", 25 },
        { "Profit", "COIN", 60},
        --{ "index", "TEXT",0 },
        })

    function frame.glypher.sheet.Processor(callback, self, button, column, row, order, curDir, ...)
        if (callback == "OnMouseDownCell")  then

        elseif (callback == "OnClickCell") then

        elseif (callback == "ColumnOrder") then

        elseif (callback == "ColumnWidthSet") then

        elseif (callback == "ColumnWidthReset") then

        elseif (callback == "ColumnSort") then

        elseif (callback == "OnEnterCell")  then
            private.sheetOnEnter(button, row, column)
        elseif (callback == "OnLeaveCell") then
            GameTooltip:Hide()
        end
    end

end

function private.sheetOnEnter(button, row, column)
    local link, name, _
    link = private.frame.glypher.sheet.rows[row][column]:GetText() or "FAILED LINK"
    if link:match("^(|c%x+|H.+|h%[.+%])") then
        name = GetItemInfo(link)
    end
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    if private.frame.glypher.sheet.rows[row][column]:IsShown()then --Hide tooltip for hidden cells
        if link and name then
            GameTooltip:SetHyperlink(link)
        end
    end
end

function private.ConfigChanged(setting, value, ...)
--     if setting == "util.glypher.craft" and value then
--         private.addtoCraft()
--         set("util.glypher.craft", nil) --for some reason teh button will not toggle a setting http://jira.norganna.org/browse/CNFG-89
--
--     elseif setting == "util.glypher.getglyphs" and value then
--         private.findGlyphs()
--         set("util.glypher.getglyphs", nil)
--     end
end
function private.findGlyphs()
    if not AuctionFrame or not AuctionFrame:IsVisible() then
        print("Please visit your local auctioneer before using this function.")
        return
    end
        if (not coFG) or (coroutine.status(coFG) == "dead") then
                coFG = coroutine.create(private.cofindGlyphs)
                onupdateframe = CreateFrame("frame")
                onupdateframe:SetScript("OnUpdate", function()
                        coroutine.resume(coFG)
                end)

                local status, result = coroutine.resume(coFG)
                if not status and result then
                        error("Error in search coroutine: "..result.."\n\n{{{Coroutine Stack:}}}\n"..debugstack(coFG));
                end
        else
                print("coroutine already running: "..coroutine.status(coFG))
        end
        coroutine.resume(coFG)
end
function private.cofindGlyphs()
    private.frame.searchButton:Disable()
    local MinimumProfit = get("util.glypher.moneyframeprofit")
    local quality = 2 --no rare quality items
    local history = get("util.glypher.history") --how far back in beancounter to look, in days
    local stockdays = get("util.glypher.stockdays")
    local maxstock = get("util.glypher.maxstock")
    local failratio = get("util.glypher.failratio")
    local makefornew = get("util.glypher.makefornew")
    local herbprice = get("util.glypher.herbprice")
    local INK =  get("util.glypher.ink") or ""

    local HOURS_IN_DAY = 24
    local MINUTES_IN_HOUR = 60;
    local SECONDS_IN_MINUTE = 60;
    local SECONDS_IN_DAY = HOURS_IN_DAY * MINUTES_IN_HOUR * SECONDS_IN_MINUTE;
    local historyTime = time() - (history * SECONDS_IN_DAY)

    local milldata = Enchantrix.Storage.GetItemMilling(36904) -- get probability data on Tiger Lily
    if not milldata then
        return
    end

    local inkCost
    for result, resProb in pairs(milldata) do
        if result == 39343 then -- goldclover
            inkCost = ((herbprice * 5) / resProb) * 2 -- 5 herbs divided by the average pigments you get, 2 to make ink of the sea
        end
    end
    if not inkCost then
        print("Error in inkCost - returned nill!!!!!!!")
    else
        print("Ink cost: " .. inkCost)
    end

    if not private.auctionCount or not BeanCounter then return end

    private.data = {}
    private.Display = {}
    local currentSelection = GetTradeSkillLine() -- the "1" in the original code is superfluous -- this function takes no arguments
    if currentSelection ~= INSCRIPTION_SPELLNAME then
        local hasInscription = GetSpellInfo(INSCRIPTION_SPELLNAME)
        if not hasInscription then print("It does not look like this character has INSCRIPTION_SPELLNAME") return end
        CastSpellByName(INSCRIPTION_SPELLNAME) --open trade skill
    end
    --end lilsparky suggested change
    local numTradeSkills = GetNumTradeSkills()
    for ID = GetFirstTradeSkill(), GetNumTradeSkills() do
        coroutine.yield()
        local pctDone = 100 - floor((numTradeSkills-ID)/numTradeSkills*100)
        private.frame.searchButton:SetText("(" .. pctDone .. "%)")

        local link = GetTradeSkillItemLink(ID)
        local itemName = GetTradeSkillInfo(ID)
        if itemName:find("Glyph") then
            if link and link:match("^|c%x+|Hitem.+|h%[.*%]") and itemName and select(3, GetItemInfo(link)) <= quality then --if its a craftable line and not a header and lower than our Quality
                --We want these local to the loop (at least) because we're zeroing them if there is no price
                local profitAppraiser = get("util.glypher.profitAppraiser")
                local profitMarket = get("util.glypher.profitMarket")
                local profitBeancounter = get("util.glypher.profitBeancounter")

                --local price = AucAdvanced.API.GetMarketValue(link)
                local priceAppraiser = AucAdvanced.Modules.Util.Appraiser.GetPrice(link, AucAdvanced.GetFaction()) or 0

                if priceAppraiser == 0 then profitAppraiser = 0 end
                local priceMarket = AucAdvanced.API.GetMarketValue(link) or 0
                if priceMarket == 0 then profitMarket = 0 end
                local bcSold = BeanCounter.API.getAHSoldFailed(UnitName("player"), link, history) or 1 -- avoid divide by zero
                local bcProfit, tmpLow, tmpHigh = BeanCounter.API.getAHProfit(UnitName("player"), itemName, historyTime, time()) or 0, 0, 0
                --local bcSold = BeanCounter.API.getAHSoldFailed("server", link, history) or 1 -- avoid divide by zero
                --local bcProfit, tmpLow, tmpHigh = BeanCounter.API.getAHProfit(nil, itemName, historyTime, time()) or 0, 0, 0
                local priceBeancounter
                if bcProfit > 0 and bcSold > 0 then
                    priceBeancounter = floor(bcProfit/bcSold)
                else
                    priceBeancounter = 0
                end
                if priceBeancounter == 0 then profitBeancounter = 0 end
                --evalutate based upon weights
                local profitTotalWeight = profitAppraiser + profitMarket + profitBeancounter
                if profitTotalWeight == 0 then
                    print("profitTotalWeight is 0 - changing to 1")
                    profitTotalWeight = 1
                end
                local worthPrice = floor((priceAppraiser * (profitAppraiser/profitTotalWeight)) + (priceMarket * (profitMarket/profitTotalWeight)) + (priceBeancounter * (profitBeancounter/profitTotalWeight)))

                local linkType,itemId,property,factor = AucAdvanced.DecodeLink(link)
                itemId = tonumber(itemId)
                property = tonumber(property) or 0
                factor = tonumber(factor) or 0
                local data = AucAdvanced.API.QueryImage({
                        itemId = itemId,
                        suffix = property,
                        factor = factor,
                })
                competing = #data
                local buyoutMin = 99999999
                for j = 1, #data do
                        local compet = AucAdvanced.API.UnpackImageItem(data[j])
                        compet.buyoutPrice = (compet.buyoutPrice/compet.stackSize)
                        local postPrice = AucAdvanced.Modules.Util.Appraiser.GetPrice(itemId, serverKey) or 0
                        if compet.buyoutPrice < buyoutMin then
                                buyoutMin = compet.buyoutPrice
                        end
                end

                if worthPrice > buyoutMin then
                    worthPrice = buyoutMin
                end

                local sold
                if BeanCounter and BeanCounter.API and BeanCounter.API.isLoaded and BeanCounter.API.getAHSoldFailed then
                     sold = BeanCounter.API.getAHSoldFailed(UnitName("player"), link, history) or 0
                     --sold = BeanCounter.API.getAHSoldFailed(nil, link, history) or 0
                end
                local reagentCost = 0
                --Sum the cost of the mats to craft this item, parchment is not considered its really too cheap to matter
                local inkMatch = false --only match inks choosen by user
                for i = 1 ,GetTradeSkillNumReagents(ID) do
                    local inkName, _, count = GetTradeSkillReagentInfo(ID, 1)
                    local link = GetTradeSkillReagentItemLink(ID, i)
                    --local inkPrice = AucAdvanced.API.GetMarketValue(link) or 0
                    local _, _, _, _, Id  = string.find(link, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
                    local isVendored,isLimited,itemCost,toSell,buyStack,maxStack = Informant.getItemVendorInfo(Id)
                    if string.find(":43126:43120:43124:37101:43118:43116:39774:39469:43122:", ":" .. Id .. ":") then
                        reagentCost = (reagentCost + (inkCost * count) )
                    elseif Id == 43127 then
                        reagentCost = (reagentCost + (inkCost * count * 10) )
                    elseif isVendored then
                        reagentCost = (reagentCost + (itemCost * count) )
                    else
                        print("Not parchment or buyable ink -- " .. link .. "-- need market price")
                    end

                    if INK:match("-") then -- ignore a specific ink
                        local INK = INK:gsub("-","")
                        inkMatch = true
                        if inkName:lower():match(INK:lower()) then
                            inkMatch = false
                        end
                    else
                        if inkName:lower():match(INK:lower()) then
                            inkMatch = true
                        end
                    end
                end

            --if we match the ink and our profits high enough, check how many we currently have on AH
                if worthPrice and (worthPrice - reagentCost) >= MinimumProfit and inkMatch then
                    local currentAuctions = private.auctionCount[itemName] or 0
                    currentAuctions = currentAuctions + GetItemCount(itemName,true) -- Auctions + Bags + Bank

                    local make = floor(sold/history * stockdays + .9) - currentAuctions -- using .9 for rounding because it's best not to miss a sale
                    local _, failed = BeanCounter.API.getAHSoldFailed(UnitName("player"), link) or 0, 0
                    --local _, failed = BeanCounter.API.getAHSoldFailed(nil, link) or 0, 0

                    if sold == 0 and failed == 0 and currentAuctions == 0 then
                        make = makefornew
                        local mess = "New glyph: " .. link
                        DEFAULT_CHAT_FRAME:AddMessage(mess,1.0,0.0,0.0)
                    end

                    if (make + currentAuctions) > maxstock then make = (maxstock - currentAuctions) end
                    if make > 0 then
                        local failedratio
                        if (sold > 0) then failedratio = failed/sold else failedratio = -1 end
                        if (sold > 0 and failed/sold < failratio) or failed == 0 or failratio == 0 then
                            table.insert(private.data, { ["link"] = link, ["ID"] = ID, ["count"] = make, ["name"] = itemName} )
                            table.insert(private.Display, {link, make, worthPrice - reagentCost} )
                        end
                    end
                end
            end
        end
    end

    private.frame.glypher.sheet:SetData(private.Display, Style)
    private.frame.searchButton:Enable()
    private.frame.searchButton:SetText("Get Profitable")

end
--store the players current auctions
function private.storeCurrentAuctions()
    local count = {}
    local _, totalAuctions = GetNumAuctionItems("owner");

    if totalAuctions > 0 then
        for i = 1, totalAuctions do
            local name, _, c = GetAuctionItemInfo("owner", i)
            if name then
                if not count[name] then
                    count[name] = 0
                end
                count[name] = (count[name]+c)
            end
        end
    end
    private.auctionCount = count
    private.auctionCountRefresh = time()
end


function private.addtoCraft()
    if Skillet and Skillet.QueueAppendCommand then
        if not Skillet.reagentsChanged then Skillet.reagentsChanged = {} end --this required table is nil when we use teh queue
        for i, glyph in ipairs(private.data) do
            local command = {}
            --index is needed for skillet to properly make use of our  data
            local _, index = Skillet:GetRecipeDataByTradeIndex(45357, glyph.ID)

            command["recipeID"] = index
            command["op"] = "iterate"
            command["count"] = glyph.count
            Skillet:QueueAppendCommand(command, true)
        end
        Skillet:UpdateTradeSkillWindow()
    elseif ATSW_AddJobRecursive then
        for i, glyph in ipairs(private.data) do
            ATSW_AddJobRecursive(glyph.name, glyph.count)
        end
    else
        print("Lilsparky's clone of Skillet or Advanced Trade Skill Window not found")
        print("Get Lilsparky's clone of Skillet at http://www.wowace.com/addons/skillet/repositories/lilsparkys-clone/files/")
    end
end

function private.refreshAll()
    if not AuctionFrame or not AuctionFrame:IsVisible() then
        print("Please visit your local auctioneer before using this function.")
        return
    end
    private.frame.refreshButton:SetText("Scanning")
    private.frame.refreshButton:Disable()
    AucAdvanced.Scan.StartScan(nil, nil, nil, nil, 5, nil, nil, nil, nil)
end

function lib.GetPrice(link, faction, realm)
    local linkType, itemId, property, factor = AucAdvanced.DecodeLink(link)
    local glypherMin = get("util.glypher.pricemodel.min")
    local glypherMax = get("util.glypher.pricemodel.max")
    local glypherUndercut = get("util.glypher.pricemodel.undercut")
    local glypherWhitelist = get("util.glypher.pricemodel.whitelist")
    if (linkType ~= "item") then return end
    itemId = tonumber(itemId)
    property = tonumber(property) or 0
    factor = tonumber(factor) or 0
    local data = AucAdvanced.API.QueryImage({
        itemId = itemId,
        suffix = property,
        factor = factor,
    })
    local auctions = #data
    local playerLow = glypherMax * 2
    local competitorLow = glypherMax * 2
    local whitelistLow = glypherMax * 2
    for j = 1, #data do
        local auction = AucAdvanced.API.UnpackImageItem(data[j])
        auction.buyoutPrice = (auction.buyoutPrice/auction.stackSize)
        if auction.stackSize == 1 then
            if auction.sellerName == playerName then
                if auction.buyoutPrice < playerLow then
                    playerLow = auction.buyoutPrice
                end
            elseif string.find(":" .. glypherWhitelist .. ":", ":" .. auction.sellerName .. ":") then
                if auction.buyoutPrice < whitelistLow then
                    if auction.buyoutPrice >= glypherMin then
                        --this if we're in is so that we don't even both with prices below our min
                        whitelistLow = auction.buyoutPrice
                    end
                end
            else
                if auction.buyoutPrice < competitorLow then
                    if auction.buyoutPrice >= glypherMin then
                        --this if we're in is so that we don't even both with prices below our min
                        competitorLow = auction.buyoutPrice
                    end
                end
            end
        end
    end
    local newPrice = glypherMax
    newPrice = competitorLow - glypherUndercut
    --tshea if whitelistLow < newPrice then
        --tshea newPrice = whitelistLow
    --tshea end
    if newPrice > glypherMax then
        newPrice = glypherMax
    elseif newPrice < glypherMin then
        --what do we do with the new price in this case?
        --ideally we should match the 2nd lowest price minus undercut
        newPrice = glypherMin
    end    
    return newPrice
end

function lib.IsValidAlgorithm(link)
    if link then
        local _, _, _, _, _, itemType, itemSubtype = GetItemInfo(link) 
        if (GLYPH_TYPE == itemType) then
            return true
        end
    else
	return true
    end
end
