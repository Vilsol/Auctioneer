--[[

BottomScanner  -  An AddOn for WoW to alert you to good purchases as they appear on the AH
$Id$
Copyright (c) 2006, Norganna

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

]]

BtmScanData = {}
local tr = BtmScan.Locales.Translate
local data, dataZone

-- Load function gets run when this addon has loaded.
BtmScan.OnLoad = function ()
	BtmScan.Print(tr("Welcome to BottomScanner. Type /btm for help"))

	-- Register our command handlers
	SLASH_BTMSCAN1 = "/btm"
	SLASH_BTMSCAN2 = "/btmscan"
	SLASH_BTMSCAN3 = "/bottomscan"
	SLASH_BTMSCAN4 = "/bottomscanner"
	SlashCmdList["BTMSCAN"] = BtmScan.Command

	-- Ensure sane defaults
	if (not BtmScanData.config) then BtmScanData.config = {} end
	if (not BtmScanData.factions) then BtmScanData.factions = {} end

	-- Hook into functions (if Stubby exists)
	if (Stubby and Stubby.RegisterFunctionHook) then
		Stubby.RegisterFunctionHook("EnhTooltip.AddTooltip", 600, BtmScan.TooltipHook)
		Stubby.RegisterFunctionHook("QueryAuctionItems", 600, BtmScan.QueryAuctionItems)
	end
	if( not BtmScan.hookedCanSendAuctionQuery ) then
		BtmScan.hookedCanSendAuctionQuery = CanSendAuctionQuery
		CanSendAuctionQuery = BtmScan.CanSendAuctionQuery;
	end

	BtmScan.timer = 0
end

-- Event handler
BtmScan.OnEvent = function(...)
	local event, arg = select(2, ...)
	if (event == "ADDON_LOADED") then
		if (string.lower(arg) == "btmscan") then
			BtmScan.OnLoad()
		end
	end
end

-- Timing routines
BtmScan.interval = 30
BtmScan.offset = 0
BtmScan.OnUpdate = function(...)
	local elapsed = select(2, ...)

	if (not BtmScan.lastTry) then BtmScan.lastTry = 0 end
	if (not BtmScan.LogFrame and AuctionFrame and BtmScan.lastTry < BtmScan.timer - 1 ) then
		BtmScan.CreateLogWindow()
		if (BtmScan.LogFrame) then BtmScan.LogFrame.Update() end
		BtmScan.lastTry = BtmScan.timer
	end

	if (not BtmScan.aucPriceModel and AuctionFramePost_AdditionalPricingModels) then
		BtmScan.aucPriceModel = true
		table.insert(AuctionFramePost_AdditionalPricingModels, BtmScan.AddAuctPriceModel)
	end

	if (not BtmScan.interval) then BtmScan.interval = 6 end
	if (BtmScan.timer) then
		BtmScan.timer = BtmScan.timer + elapsed
		if (BtmScan.pageScan) then
			if (BtmScan.timer > BtmScan.pageScan) then
				BtmScan.PageScan()
			elseif (BtmScan.timer > BtmScan.pageScan-0.25) then
				BtmScan.scanStage = 1
			end
		end
		if (BtmScan.timer < BtmScan.interval) then
			return
		end
		BtmScan.timer = BtmScan.timer - BtmScan.interval
	else
		BtmScan.timer = 0
	end

	-- Set the background at the correct stage color
	if (not BtmScan.LogParent) then return end
	if (not BtmScan.scanStage or BtmScan.scanStage == 0) then
		BtmScan.LogParent:SetBackdropColor(0,0,0,0.9)
	elseif (BtmScan.scanStage == 1) then
		BtmScan.LogParent:SetBackdropColor(0,0,0.5,0.9)
	elseif (BtmScan.scanStage == 2) then
		BtmScan.LogParent:SetBackdropColor(0,0.5,0,0.9)
	elseif (BtmScan.scanStage == 3) then
		BtmScan.LogParent:SetBackdropColor(0.5,0,0,0.9)
		return
	end

	-- If we are supposed to be scanning, then let's do it!
	if (BtmScan.scanning) then

		-- Time to scan the page
		if (not BtmScan.pageCount) then
			BtmScan.pageCount = -1
		end

		-- Get the current number of auctions
		local pageCount, totalCount = GetNumAuctionItems("list")
		local totalPages = math.floor((totalCount-1)/50)
		if (totalPages < 0) then totalPages = 0 end
		if (totalPages ~= BtmScan.pageCount) then
			BtmScan.pageCount = totalPages
			BtmScan.interval = 6 -- Short cut the delay, we need to reload now damnit!
		else
			BtmScan.interval = BtmScanData.refresh
		end

		-- Check to see if the AH is open for business
		if (not BtmScan.hookedCanSendAuctionQuery() or not (AuctionFrame and AuctionFrame:IsVisible())) then
			BtmScan.interval = 1 -- Try again in one second
			return
		end

		-- Every 5 pages, go back a page just to double check that nothing got by us.
		BtmScan.offset = (BtmScan.offset + 1) % 5
		local offset = 0
		if (BtmScan.offset == 0) then offset = 1 end

		-- Show me tha money!
		--BtmScan.processing = true
		BtmScan.scanStage = 2
		local page = BtmScan.pageCount-offset or 0
		QueryAuctionItems("", "", "", nil, nil, nil, page, nil, nil)
	end
end


BtmScan.QueryAuctionItems = function(par,ret, name,lmin,lmax,itype,class,sclass,page,able,qual)
	if (not BtmScan.scanning) then return end

	-- Kewl, lets schedule a scan of this page for 2 seconds into the future.
	BtmScan.timer = 0
	BtmScan.pageScan = 2
end

BtmScan.PageScan = function(resume)
	BtmScan.pageScan = nil
	if (not BtmScan.scanStage or BtmScan.scanStage == 0 or BtmScan.scanStage == 3) then return end

	-- Make sure the current zone is loaded and has defaults
	BtmScan.GetZoneConfig("pagescan")

	-- Ok, we've just queried the auction house, page should be loaded etc.
	-- lets get the items on the list and scan them.
	local pageCount, totalCount = GetNumAuctionItems("list")

	local log = BtmScan.Log
	if (BtmScan.dryRun) then log = BtmScan.Print end

	-- Ok, lets look at all these lovely items
	if (not resume) then resume = 1 end
	BtmScan.scanning = true
	for i=resume, pageCount do
		local itemLink = GetAuctionItemLink("list", i)
		-- If:
		--   * This item has been loaded
		if (itemLink) then

			-- Break apart the link and assemble the keys
			local itemID, itemRand, itemEnch, itemUniq = BtmScan.BreakLink(itemLink)
			local sanityKey = itemID..":"..itemRand
			local auctKey = itemID..":"..itemRand..":"..itemEnch

			-- Check to see that we're not ignoring this item
			if (not data.ignore[sanityKey]) then

				-- Get the auction information for this this item
				local iName, iTex, iCount, iQual, iUse, iLvl, iMin, iInc, iBuy, iCur, iHigh, iOwner = GetAuctionItemInfo("list", i)

				-- Work out what the next bid will be
				local iBid = iMin
				if (iCur and iCur > 0) then iBid = iCur + iInc end

				-- If:
				--   * This item has a buyout price
				--   * It's not owned by us
				--   * It's not gonna break the bank
				if (iOwner ~= UnitName('player')) then

					-- Check to see if we have overspent the safetynet on this item
					-- Note that it is possible to overspend the safety amount, as
					-- the safetynet only kicks in once you have met or exceeded this
					-- amount spent.
					local ignoreItem = false
					if (not BtmScan.sessionSpend) then BtmScan.sessionSpend = {} end
					if (BtmScan.sessionSpend[sanityKey]) then
						local sSpend = BtmScan.sessionSpend[sanityKey]
						if (sSpend.count >= data.safetyCount) then
							ignoreItem = true
						elseif (sSpend.cost >= data.safetyCost) then
							ignoreItem = true
						end

						if (not BtmScan.dryRun and ignoreItem and not sSpend.warned) then
							log(tr("Warning: Safety limit reached on item: %1", itemLink))
							BtmScan.sessionSpend[sanityKey].warned = true
						end
					end

					-- If this item doesn't breach the safetynet
					if (not ignoreItem) then

						-- Get vendor price if available
						local vendorValue = BtmScan.GetVendorPrice(itemID, iCount)

						-- Get disenchant value if available
						local disenchantValue = 0
						if (Enchantrix and Enchantrix.Storage) then
							local disenchantTo = Enchantrix.Storage.GetItemDisenchants(Enchantrix.Util.GetSigFromLink(itemLink), itemName, true)
							if (disenchantTo and disenchantTo.totals and disenchantTo.totals.hspValue and iQual > 1 and iCount <= 1) then
								disenchantValue = disenchantTo.totals.hspValue * disenchantTo.totals.conf
							end
						end

						-- Get snatch value if it has been set
						local snatchAmount = data.snatch[sanityKey]
						local snatchPrice, snatchCount, snatchStack
						if (type(snatchAmount) ~= "table") then
							snatchPrice = tonumber(snatchAmount) or 0
							snatchCount = 0
							snatchStack = 0
						else
							snatchPrice = tonumber(snatchAmount[1]) or 0
							snatchCount = tonumber(snatchAmount[2]) or 0
							snatchStack = tonumber(snatchAmount[3]) or 0
						end
						snatchPrice = snatchPrice * iCount
						local snatched = tonumber(data.snatched[sanityKey]) or 0
						if (snatched + iCount > snatchCount and snatchCount > 0) then
							snatchPrice = 0
						end

						local _,_,_,_,_,_,_,stackSize = GetItemInfo(itemID)
						if (not stackSize) then
							if (snatchStack > 0) then
								stackSize = snatchStack
							else
								stackSize = 1
							end
						end

						-- Initialize buyIt to false
						local buyIt = false
						local bidIt = false
						local ignoreIt = false
						local whyBuy = ""
						local noSafety = false
						local buying = itemLink
						local message

						if (iCount and iCount > 1) then buying = buying.."x"..iCount end

						-- If this item is not trash (grey) quality
						if (iQual > 0) then

							-- Grab the sane price from our list
							--   Note these are compiled averages from all factions and servers
							--   This is meant to "double check" the Auctioneer prices, if both
							--   agree that this item is a "good buy", only then will we buy it
							local sanity = BtmScan.ConfidenceList[sanityKey]
							local iqm, iqwm, iqCount, bBase, bCount
							if (sanity) then
								local iqm, iqwm, iqCount = strsplit(",", sanity)
								iqm = tonumber(iqm)
								iqwm = tonumber(iqwm)
								iqCount = tonumber(iqCount)
								bCount = data.minSeen
								bBase = iqwm

								-- Use the worst case scenario from inbuilt or auctioneer prices
								-- (if available)
								local auctMedian, auctCount
								if (Auctioneer and Auctioneer.Statistic) then
									auctMedian, auctCount = Auctioneer.Statistic.GetUsableMedian(auctKey)
									bCount = 0
									if (auctMedian and auctCount) then
										if (bBase >= auctMedian) then
											bBase = auctMedian
										end
										bCount = auctCount
									end
								end
								if (not auctMedian) then auctMedian = 0 end
								if (not auctCount) then auctCount = 0 end

								if (not iCount or iCount < 1) then iCount = 1 end
								local deposit = BtmScan.GetDepositCost(itemID, iCount)
								if (not deposit) then deposit = 0 end

								if (BtmScan.BaseRule) then
									BtmScan.prices = {
										consKey = sanityKey,
										consMean = iqm * iCount,
										consPrice = iqwm * iCount,
										consSeen = iqCount,
										auctKey = auctKey,
										auctPrice = auctMedian * iCount,
										auctSeen = auctCount,
										itemID = itemID,
										itemRand = itemRand,
										itemEnch = itemEnch,
										itemCount = iCount,
										buyPrice = iBuy,
										bidPrice = iBid,
										basePrice = bBase * iCount,
										depositCost = deposit,
									}
									bBase = BtmScan.BaseRule()
								else
									bBase = bBase * iCount
								end

								-- If user has specified a specific worth for this item, use it
								if (data.worth[sanityKey]) then
									bBase = tonumber(data.worth[sanityKey]) * iCount
									bCount = data.minSeen
									noSafety = true
								end

								-- Work out what the required profit will be
								local requiredProfit = data.minProfit
								-- White or lower items have a multiplier added to them
								if (iQual < 2) then requiredProfit = requiredProfit * data.commonMult end

								-- Find out what the profitable price will be based on pctprofit
								local profitablePrice = iBuy * (1+data.pctProfit/100)
								local profitableBid = iBid * (1+data.pctProfit/100)
								-- Work out which is larger, pctProfit, or requiredProfit
								if (iBuy + requiredProfit > profitablePrice) then
									-- Use requiredProfit instead
									profitablePrice = iBuy + requiredProfit
								end
								if (iBid + requiredProfit > profitableBid) then
									profitableBid = iBid + requiredProfit
								end

								-- If:
								--    * It's base price (what we think it's worth) is better
								--      than what would be profitable for this item.
								--    * It's buyout cost is less than our maximum price
								--    * It meets our minimum seen count requirement
								if (bBase and bBase > 0 and bCount >= data.minSeen) then
									if (iBuy and iBuy>0 and bBase >= profitablePrice and iBuy <= data.maxPrice and GetMoney()-iBuy >= data.reserve) then
										whyBuy = tr("resale")
										message = tr("Buying %1 at %2 [%3 at %4 = %5 profit]", buying, BtmScan.GSC(iBuy), whyBuy, tr("%1 (%2 med x%3 / %4 cons)", BtmScan.GSC(bBase), BtmScan.GSC(auctMedian), auctCount, BtmScan.GSC(iqwm)), BtmScan.GSC(bBase-iBuy))
										buyIt = true
									elseif (bBase >= profitableBid and iBid <= data.maxPrice and GetMoney()-iBid >= data.reserve) then
										whyBuy = tr("resale")
										message = tr("Bidding %1 at %2 [%3 at %4 = %5 profit]", buying, BtmScan.GSC(iBid), whyBuy, tr("%1 (%2 med x%3 / %4 cons)", BtmScan.GSC(bBase), BtmScan.GSC(auctMedian), auctCount, BtmScan.GSC(iqwm)), BtmScan.GSC(bBase-iBid))
										bidIt = true
									end
								end

								if (iBuy > bBase * 100) then ignoreIt = true end
							end


							-- If:
							--   * We're not buying it
							--   * It has a disenchant value
							if (not buyIt and disenchantValue > 0) then

								-- We need to increase the required profit for disenchants
								-- since there is often a chance that it will not D/E into
								-- what we want it to. (/btm defactor)

								local profitablePrice = iBuy * (1+data.pctDeProfit/100)
								local profitableBid = iBid * (1+data.pctDeProfit/100)
								-- Work out which is larger, pctDeProfit, or minDeProfit
								if (iBuy + data.minDeProfit > profitablePrice) then
									-- Use minDeProfit instead
									profitablePrice = iBuy + data.minDeProfit
								end
								if (iBid + data.minDeProfit > profitableBid) then
									profitableBid = iBid + data.minDeProfit
								end

								-- If:
								--   * This item's de value is more than the profitable price
								--   * It's buyout cost is less than our maximum price
								if (iBuy and iBuy>0 and disenchantValue >= profitablePrice and iBuy <= data.maxPrice and GetMoney()-iBuy >= data.reserve) then
									whyBuy = tr("disenchant")
									message = tr("Buying %1 at %2 [%3 at %4 = %5 profit]", buying, BtmScan.GSC(iBuy), whyBuy, BtmScan.GSC(disenchantValue), BtmScan.GSC(disenchantValue-iBuy))
									buyIt = true
									noSafety = true
								elseif (not bidIt and disenchantValue >= profitableBid and iBid <= data.maxPrice and GetMoney()-iBid >= data.reserve) then
									whyBuy = tr("disenchant")
									message = tr("Bidding %1 at %2 [%3 at %4 = %5 profit]", buying, BtmScan.GSC(iBid), whyBuy, BtmScan.GSC(disenchantValue), BtmScan.GSC(disenchantValue-iBid))
									bidIt = true
									noSafety = true
								end
							end
						end --if (not trash)

						-- If:
						--   * We're not buying it
						--   * It has a vendor value
						if (not buyIt and vendorValue and vendorValue > 0) then
							local profitablePrice = iBuy + data.vendProfit
							local profitableBid = iBid + data.vendProfit

							-- If:
							--   * This item's vendor value is more than the profitable price
							--   * It's buyout cost is less than our maximum price
							if (iBuy and iBuy>0 and vendorValue >= profitablePrice and iBuy <= data.maxPrice and GetMoney()-iBuy >= data.reserve) then
								whyBuy = tr("vendor")
								message = tr("Buying %1 at %2 [%3 at %4 = %5 profit]", buying, BtmScan.GSC(iBuy), whyBuy, BtmScan.GSC(vendorValue), BtmScan.GSC(vendorValue-iBuy))
								buyIt = true
								noSafety = true
							elseif (not bidIt and vendorValue >= profitableBid and iBid <= data.maxPrice and GetMoney()-iBid >= data.reserve) then
								whyBuy = tr("vendor")
								message = tr("Bidding %1 at %2 [%3 at %4 = %5 profit]", buying, BtmScan.GSC(iBid), whyBuy, BtmScan.GSC(vendorValue), BtmScan.GSC(vendorValue-iBid))
								bidIt = true
								noSafety = true
							end

							if (iBuy > vendorValue * 100) then ignoreIt = true end
						end

						-- If:
						--   * We're not buying it
						--   * It has a snatch value
						local snatching
						if (not buyIt and snatchPrice > 0) then
							if (iBuy and iBuy>0 and iBuy < snatchPrice and GetMoney()-iBuy >= data.reserve) then
								whyBuy = tr("snatch")
								message = tr("Buying %1 at %2 [%3 at %4 = %5 profit]", buying, BtmScan.GSC(iBuy), whyBuy, BtmScan.GSC(snatchPrice), BtmScan.GSC(snatchPrice-iBuy))
								buyIt = true
								noSafety = true
								snatching = true
							elseif (not bidIt and iBid <= snatchPrice and GetMoney()-iBid >= data.reserve) then
								whyBuy = tr("snatch")
								message = tr("Bidding %1 at %2 [%3 at %4 = %5 profit]", buying, BtmScan.GSC(iBid), whyBuy, BtmScan.GSC(snatchPrice), BtmScan.GSC(snatchPrice-iBid))
								bidIt = true
								noSafety = true
							end

							if (iBuy > snatchPrice * 100) then ignoreIt = true end
						end

						-- If for some reason the buyIt flag was set above, then place a bid on this item
						-- equal to the buyout price (ie: buy it out)
						if (buyIt or bidIt) then
							local bidType, bidPrice
							if (buyIt) then
								bidType = tr("bought")
								bidPrice = iBuy
							elseif (bidIt and data.allowBids > 0 and not iHigh and not ignoreIt) then
								bidType = tr("bid on")
								bidPrice = iBid
							end
							
							if (bidPrice and GetMoney()-bidPrice >= data.reserve and bidPrice <= data.maxPrice) then
								log(message)
								if (BtmScan.dryRun) then
									BtmScan.Print(tr("Would have %1 %2 for %3, but we are doing a dry run.", bidType, buying, bidPrice))
								else
									local bidSig = itemLink.."x"..iCount
									BtmScan.PromptPurchase(i, bidSig, whyBuy, bidPrice, bidType, noSafety, snatching, iCount, stackSize, sanityKey, itemLink, iTex)
									return
								end
							end
						end
					end
				end
			end
		end
	end

	BtmScan.scanStage = 0
	--BtmScan.LogParent:SetBackdropColor(0,0,0, 0.8)
	--BtmScan.processing = false
end

BtmScan.CanSendAuctionQuery = function()
	if (BtmScan.scanStage and BtmScan.scanStage > 0) then return false end
	return BtmScan.hookedCanSendAuctionQuery()
end

-- Get a GSC value and work out what it's worth
BtmScan.ParseGSC = function (price)
	price = string.gsub(price, "|c[0-9a-fA-F]+", " ")
	price = string.gsub(price, "[gG]", "0000 ")
	price = string.gsub(price, "[sS]", "00 ")
	price = string.gsub(price, "[^0-9]+", " ")

	local total = 0
	for q in string.gmatch(price, "(%d+)") do
		local number = tonumber(q) or 0
		total = total + number
	end
	return total
end

-- Break an ItemID into it's component pieces
BtmScan.BreakLink = function (link)
	if (type(link) ~= 'string') then return end
	local whole, item, name, remain = string.match(link, "(|c[0-9a-fA-F]+|Hitem:([^|]+)|h%[(.-)%]|h|r)(.*)")
	if (not item) then return end

	local itemID, enchant, gem1, gem2, gem3, gem4, randomProp, uniqID = strsplit(":", item)

	local i,j, count, nextpart = string.find(remain or "", "^x(%d+)(.*)")
	if (i) then
		count = tonumber(count) or 0
		remain = nextpart
	else count = 0 end
	local i,j, price, nextpart = string.find(remain or "", "^ at ([^ ]+)(.*)")
	if (i) then
		price = BtmScan.ParseGSC(price)
		remain = nextpart
	else price = 0 end 
	return tonumber(itemID) or 0, tonumber(randomProp) or 0, tonumber(enchant) or 0, tonumber(uniqID) or 0, name, whole, count, price, remain
end

-- Item Designation used in several places
BtmScan.ItemDes = function (link)
	local itemID, itemRand, _,_,_, itemLink, count, price, remain = BtmScan.BreakLink(link)
	if (not itemID) then return end
	return string.format("%d:%d", tonumber(itemID) or 0, tonumber(itemRand) or 0), tonumber(count) or 0, tonumber(price) or 0, itemID, itemRand, itemLink, remain
end

-- Item Designation used in several places
BtmScan.BreakItemDes = function (des)
	local i,j, itemID, itemRand = string.find(des, "(%d+):(%d+)")
	return tonumber(itemID) or 0, tonumber(itemRand) or 0
end

-- Makes up a pretend link based off the hyperlink code
BtmScan.FakeLink = function (hyperlink, quality, name)
	if not hyperlink then return end
	local sName, sLink, iQuality = GetItemInfo(hyperlink)
	if (quality == nil) then quality = iQuality or -1 end
	if (name == nil) then name = sName or "unknown ("..hyperlink..")" end
	local _, _, _, color = GetItemQualityColor(quality)
	return color.. "|H"..hyperlink.."|h["..name.."]|h|r"
end

BtmScan.GetGSC = function (money)
	if (money == nil) then money = 0 end
	local g = math.floor(money / 10000)
	local s = math.floor((money - (g*10000)) / 100)
	local c = math.ceil(money - (g*10000) - (s*100))
	return g,s,c
end

-- formats money text by color for gold, silver, copper
BtmScan.GSC = function (money, exact, dontUseColorCodes)
	if (type(money) ~= "number") then return end

	local TEXT_NONE = "0"

	local GSC_GOLD="ffd100"
	local GSC_SILVER="e6e6e6"
	local GSC_COPPER="c8602c"
	local GSC_START="|cff%s%d%s|r"
	local GSC_PART=".|cff%s%02d%s|r"
	local GSC_NONE="|cffa0a0a0"..TEXT_NONE.."|r"

	if (not money) then money = 0 end
	if (not exact) and (money >= 10000) then money = math.floor(money / 100 + 0.5) * 100 end
	local g, s, c = BtmScan.GetGSC(money)

	local gsc = ""
	if (not dontUseColorCodes) then
		local fmt = GSC_START
		if (g > 0) then gsc = gsc..string.format(fmt, GSC_GOLD, g, 'g') fmt = GSC_PART end
		if (s > 0) or (c > 0) then gsc = gsc..string.format(fmt, GSC_SILVER, s, 's') fmt = GSC_PART end
		if (c > 0) then gsc = gsc..string.format(fmt, GSC_COPPER, c, 'c') end
		if (gsc == "") then gsc = GSC_NONE end
	else
		if (g > 0) then gsc = gsc .. g .. "g " end
		if (s > 0) then gsc = gsc .. s .. "s " end
		if (c > 0) then gsc = gsc .. c .. "c " end
		if (gsc == "") then gsc = TEXT_NONE end
	end
	return gsc
end

BtmScan.Print = function (text, cRed, cGreen, cBlue, cAlpha, holdTime)
	local frameIndex = BtmScan.getFrameIndex()

	if (cRed and cGreen and cBlue) then
		if getglobal("ChatFrame"..frameIndex) then
			getglobal("ChatFrame"..frameIndex):AddMessage(text, cRed, cGreen, cBlue, cAlpha, holdTime)

		elseif (DEFAULT_CHAT_FRAME) then
			DEFAULT_CHAT_FRAME:AddMessage(text, cRed, cGreen, cBlue, cAlpha, holdTime)
		end

	else
		if getglobal("ChatFrame"..frameIndex) then
			getglobal("ChatFrame"..frameIndex):AddMessage(text, 0.9, 0.6, 0.2)

		elseif (DEFAULT_CHAT_FRAME) then
			DEFAULT_CHAT_FRAME:AddMessage(text, 0.9, 0.6, 0.2)
		end
	end
end

BtmScan.getFrameNames = function (index)
	local frames = {}
	local frameName = ""

	for i=1, 10 do
		local name, fontSize, r, g, b, a, shown, locked, docked = GetChatWindowInfo(i)

		if ( name == "" ) then
			if (i == 1) then
				frames[string.lower(GENERAL)] = 1

			elseif (i == 2) then
				frames[string.lower(COMBAT_LOG)] = 2
			end

		else
			frames[string.lower(name)] = i
		end
	end

	if (type(index) == "number") then
		local name, fontSize, r, g, b, a, shown, locked, docked = GetChatWindowInfo(index)

		if ( name == "" ) then
			if (index == 1) then
				frameName = GENERAL

			elseif (index == 2) then
				frameName = COMBAT_LOG
			end

		else
			frameName = name
		end
	end

	return frames, frameName
end

BtmScan.getFrameIndex = function ()
	if not BtmScanData.printFrame then return 1 end
	return tonumber(BtmScanData.printFrame) or 1
end

BtmScan.setFrame = function (frame, chatprint)
	local frameNumber
	local frameVal
	frameVal = tonumber(frame)

	--If no arguments are passed, then set it to the default frame.
	if not (frame) then
		frameNumber = 1

	--If the frame argument is a number then set our chatframe to that number.
	elseif ((frameVal) ~= nil) then
		frameNumber = frameVal

	--If the frame argument is a string, find out if there's a chatframe with that name, and set our chatframe to that index. If not set it to the default frame.
	elseif (type(frame) == "string") then
		local allFrames = BtmScan.getFrameNames()
		if (allFrames[string.lower(frame)]) then
			frameNumber = allFrames[frame]
		else
			frameNumber = 1
		end

	--If the argument is something else, set our chatframe to its default value.
	else
		frameNumber = 1
	end

	local _, frameName

	_, frameName = BtmScan.getFrameNames(frameNumber)
	if (BtmScan.getFrameIndex() ~= frameNumber) then
		BtmScan.Print(tr("BottomScanner's messages will now print on the \"%1\" chat frame", frameName))
	end

	BtmScanData.printFrame = frameNumber
	BtmScan.Print(tr("BottomScanner's messages will now print on the \"%1\" chat frame", frameName))
end

BtmScan.Log = function (msg)
	-- Make sure the current zone is loaded and has defaults
	BtmScan.GetZoneConfig("log")

	if (not data.logText) then data.logText = {} end
	table.insert(data.logText, { time(), msg })
	if (not BtmScan.LogFrame) then BtmScan.CreateLogWindow() end
	if (BtmScan.LogFrame) then BtmScan.LogFrame.Update() end
end

-- Command function handles the processing of slash commands.
BtmScan.Command = function (msg)
	local i,j, ocmd, oparam = string.find(msg, "^([^ ]+) (.*)$")
	local i,j, cmd, param = string.find(string.lower(msg), "^([^ ]+) (.*)$")
	if (not i) then cmd = msg param = nil oparam = nil end
	if (oparam == "") then param = nil oparam = nil end

	if (not BtmScanData.unlocked) then
		if (cmd == "agree") then
			BtmScanData.unlocked = true
			BtmScan.Print(tr("BottomScanner is now unlocked."))
		else
			BtmScan.Print(tr("This program is not intended for unattended play."))
			BtmScan.Print(tr("In order to use this addon, you must first agree to not use this addon whilst not at the computer. Please type |cff00ff80/btm agree|r now to continue."))
		end
		return
	end

	-- Make sure the current zone is loaded and has defaults
	BtmScan.GetZoneConfig("command")

	local help = false
	if (cmd == "maxprice") then
		if (param) then
			data.maxPrice = BtmScan.ParseGSC(param)
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Maximum Price"), BtmScan.GSC(data.maxPrice,1)))
	elseif (cmd == "minprofit") then
		if (param) then
			data.minProfit = BtmScan.ParseGSC(param)
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Minimum Profit"), BtmScan.GSC(data.minProfit,1)))
	elseif (cmd == "pctprofit") then
		if (param) then
			data.pctProfit = tonumber(param)
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Percent Profit"), data.pctProfit.."%"))
	elseif (cmd == "mindeprofit") then
		if (param) then
			data.minDeProfit = BtmScan.ParseGSC(param)
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Minimum Disenchant Profit"), BtmScan.GSC(data.minDeProfit,1)))
	elseif (cmd == "pctdeprofit") then
		if (param) then
			data.pctDeProfit = tonumber(param)
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Percent Disenchant Profit"), data.pctDeProfit.."%"))
	elseif (cmd == "vendprofit") then
		if (param) then
			data.vendProfit = BtmScan.ParseGSC(param)
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Vendor Profit"), BtmScan.GSC(data.vendProfit)))
	elseif (cmd == "reserve") then
		if (param) then
			data.reserve = BtmScan.ParseGSC(param)
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Reserve"), BtmScan.GSC(data.reserve,1)))
	elseif (cmd == "defactor") then
		if (param) then
			data.deFactor = tonumber(param)
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Disenchant Factor"), data.deFactor))
	elseif (cmd == "commonmult") then
		if (param) then
			data.commonMult = tonumber(param)
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Common Item Multiplier"), data.commonMult))
	elseif (cmd == "allowbids") then
		if (param) then
			data.allowBids = tonumber(param)
		end
		local allowing = tr("Not Allowed")
		if (data.allowBids > 0) then
			allowing = tr("Allowed")
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Item Bidding"), allowing))
	elseif (cmd == "safetynet") then
		local i,j, scount, scost = string.find(oparam, "^(%d+) (%d+)")
		if (i) then
			scount = tonumber(scount)
			scost = BtmScan.ParseGSC(scost)
			if (scount < 0) then scount = 0 end
			if (scost < 0) then scost = 0 end
			data.safetyCount = scount
			data.safetyCost = scost
		end
		scount = data.safetyCount
		scost = data.safetyCost
		if (scount == 0) then scount = "unlimited" end
		if (scost == 0) then scost = "unlimited" else scost = BtmScan.GSC(scost) end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Safety Net"), tr("%1 items, %2 total spend", scount, scost)))
	elseif (cmd == "minseen") then
		if (param) then
			data.minSeen = tonumber(param)
		end
		BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Minimum Seen Count"), data.minSeen))
	elseif (cmd == "end" or cmd == "stop" or cmd == "cancel") then
		BtmScan.EndScan()
	elseif (cmd == "begin" or cmd == "start" or cmd == "scan") then
		BtmScan.dryRun = false
		BtmScan.BeginScan()
	elseif (cmd == "dryrun") then
		BtmScan.dryRun = true
		BtmScan.BeginScan()
	elseif (cmd == "baserule") then
		if (oparam) then
			data.baseRule = oparam
			BtmScan.CompileBaseRule()
		else
			BtmScan.EditData("baseRule", BtmScan.CompileBaseRule)
		end
	elseif (cmd == "ignore") then
		if (oparam) then
			local des = BtmScan.ItemDes(oparam)
			data.ignore[des] = true
			BtmScan.Print(tr("BottomScanner will now %1 %2", tr("ignore"), oparam))
		else
			BtmScan.Print(tr("Your current %1 list is:", tr("ignore")))
			if (data.ignore and next(data.ignore)) then
				for des, ignored in pairs(data.ignore) do
					local itemID, itemRand = BtmScan.BreakItemDes(des)
					local itemString = "item:"..itemID..":0:"..itemRand..":0"
					local itemLink = BtmScan.FakeLink(itemString)
					BtmScan.Print(tr("  * %1", itemLink))
				end
			else
				BtmScan.Print(tr("  -- Empty --"))
			end
		end
	elseif (cmd == "unignore") then
		if (oparam) then
			local des = BtmScan.ItemDes(oparam)
			data.ignore[des] = nil
			BtmScan.Print(tr("BottomScanner will now %1 %2", tr("not ignore"), oparam))
		end
	elseif (cmd == "worth") then
		if (oparam) then
			local des, count, price, itemid,itemrand,itemlink, remain = BtmScan.ItemDes(oparam)
			if (not des) then
				BtmScan.Print(tr("Unable to understand command. Please see /btm help"))
				return
			end

			if (price <= 0) then
				price = BtmScan.ParseGSC(remain) or 0
			end

			if (price <= 0) then
				BtmScan.Print(tr("BottomScanner will now %1 %2", tr("not value"), itemlink))
				data.worth[des] = nil
				return
			end

			local _,_,_,_,_,_,stack = GetItemInfo(itemid)
			if (not stack) then
				stack = 1
			end

			local stackText = ""
			if (stack > 1) then
				stackText = " ("..tr("%1 per %2 stack", BtmScan.GSC(price*stack, 1), stack)..")"
			end

			data.worth[des] = price
			BtmScan.Print(tr("BottomScanner will now %1 %2", tr("value"), tr("%1 at %2", itemlink, tr("%1 per unit", BtmScan.GSC(price, 1)))..stackText))
		else
			BtmScan.Print(tr("Your current %1 list is:", tr("worth")))
			if (data.worth and data.worth ~= {}) then
				for des, amount in pairs(data.worth) do
					local itemID, itemRand = BtmScan.BreakItemDes(des)
					local itemString = "item:"..itemID..":0:"..itemRand..":0"
					local itemLink = BtmScan.FakeLink(itemString)

					local worthLine = ""
					amount = tonumber(amount) or 0

					worthLine = worthLine..tr("%1 per unit", BtmScan.GSC(amount,1))
					local _,_,_,_,_,_,stack = GetItemInfo(itemID)
					stack = tonumber(stack) or 1;
					if (stack > 1) then
						worthLine = worthLine.." ("..tr("%1 per %2 stack", BtmScan.GSC(amount*stack,1), stack)..")"
					end
					BtmScan.Print(tr("  * %1 = %2", itemLink, worthLine))
				end
			else
				BtmScan.Print(tr("  -- Empty --"))
			end
		end
	elseif (cmd == "snatch") then
		if (oparam) then
			local des, count, price, itemid,itemrand,itemlink, remain = BtmScan.ItemDes(oparam)
			if (not des) then
				BtmScan.Print(tr("Unable to understand command. Please see /btm help"))
				return
			end

			if (price <= 0) then
				price = BtmScan.ParseGSC(remain) or 0
			end

			if (price <= 0) then
				BtmScan.Print(tr("BottomScanner will now %1 %2", tr("not snatch"), itemlink))
				data.snatched[des] = nil
				data.snatch[des] = nil
				return
			end

			local _,_,_,_,_,_,stack = GetItemInfo(itemid)
			if (not stack) then
				stack = 1
			end

			local stackText = ""
			if (stack > 1) then
				stackText = " ("..tr("%1 per %2 stack", BtmScan.GSC(price*stack, 1), stack)..")"
			end
			local countText =""
			if (count > 0) then
				countText = tr("up to %1", count).." "
			else
				countText = tr("unlimited").." "
			end

			data.snatch[des] = { price, count, stack }
			data.snatched[des] = 0
			BtmScan.Print(tr("BottomScanner will now %1 %2", tr("snatch"), countText..tr("%1 at %2", itemlink, tr("%1 per unit", BtmScan.GSC(price, 1)))..stackText))
		else
			BtmScan.Print(tr("Your current %1 list is:", tr("snatch")))
			if (data.snatch and data.snatch ~= {}) then
				for des, amount in pairs(data.snatch) do
					local itemID, itemRand = BtmScan.BreakItemDes(des)
					local itemString = "item:"..itemID..":0:"..itemRand..":0"
					local itemLink = BtmScan.FakeLink(itemString)

					local price, count, stack
					local snatchLine = ""
					if (type(amount) ~= "table") then
						price = tonumber(amount) or 0
						count = 0
						stack = 0
					else
						price = tonumber(amount[1]) or 0
						count = tonumber(amount[2]) or 0
						stack = tonumber(amount[3]) or 0
					end

					if (count > 0) then
						local fulfilled = tonumber(data.snatched[des]) or 0
						snatchLine = snatchLine..tr("%1 / %2 at", fulfilled, count).." "
					end
					snatchLine = snatchLine..tr("%1 per unit", BtmScan.GSC(price,1))
					if (stack > 1) then
						snatchLine = snatchLine.." ("..tr("%1 per %2 stack", BtmScan.GSC(price*stack,1), stack)..")"
					end
					BtmScan.Print(tr("  * %1 = %2", itemLink, snatchLine))
				end
			else
				BtmScan.Print(tr("  -- Empty --"))
			end
		end
	elseif (cmd == "print-in") then
		BtmScan.setFrame(oparam)
	elseif (cmd == "clear") then
		data.logText = { { time(), "--- Welcome to BottomScanner ---" } }
		if (BtmScan.LogFrame) then BtmScan.LogFrame.Update() end
	elseif (cmd == "help" or cmd == "") then
		help = true
	else
		BtmScan.Print(tr("BottomScanner: %1 [%2]", tr("Unknown command"), cmd))
		help = true
	end

	if (help) then
		BtmScan.Print(tr("BottomScanner is using %1 configuration", dataZone))
		BtmScan.Print(tr(" %1 [%2] = %3", "reserve <copper>", tr("Reserves a certain amount of your money from being spent"), BtmScan.GSC(data.reserve,1)))
		BtmScan.Print(tr(" %1 [%2] = %3", "maxprice <copper>", tr("Sets the maximum price that we will buy auctions for"), BtmScan.GSC(data.maxPrice,1)))
		BtmScan.Print(tr(" %1 [%2] = %3", "minprofit <copper>", tr("Sets the minimum profit that we consider an auction"), BtmScan.GSC(data.minProfit,1)))
		BtmScan.Print(tr(" %1 [%2] = %3", "pctprofit <percent>", tr("Sets the minimum percentage of profit to buy an auction"), data.pctProfit.."%"))
		BtmScan.Print(tr(" %1 [%2] = %3", "mindeprofit <copper>", tr("Sets the minimum disenchant profit that we consider an auction"), BtmScan.GSC(data.minDeProfit,1)))
		BtmScan.Print(tr(" %1 [%2] = %3", "pctdeprofit <percent>", tr("Sets the minimum percentage of disenchant profit to buy an auction"), data.pctDeProfit.."%"))
		BtmScan.Print(tr(" %1 [%2] = %3", "vendprofit <copper>", tr("Sets the minimum profit on vendorable items"), data.vendProfit))
		BtmScan.Print(tr(" %1 [%2] = %3", "commonmult <factor>", tr("Sets a penalty factor on white items' profitability"), data.commonMult))
		local allowing = tr("Not Allowed") if (data.allowBids > 0) then allowing = tr("Allowed") end
		BtmScan.Print(tr(" %1 [%2] = %3", "allowbids <0/1>", tr("Sets whether to allow bidding if the rules would have bought at that price"), allowing))
		BtmScan.Print(tr(" %1 [%2] = %3", "minseen <count>", tr("Sets the minimum Auctioneer \"seen count\" before we will buy an item"), data.minSeen))

		local scount, scost
		scount = data.safetyCount
		scost = data.safetyCost
		if (scount == 0) then scount = "unlimited" end
		if (scost == 0) then scost = "unlimited" else scost = BtmScan.GSC(scost) end
		BtmScan.Print(tr(" %1 [%2] = %3", "safetynet <count> <copper>", tr("Sets the maximum number / cost of any single item that will be bought in any one session (0 for unlimited)"), tr("%1 items, %2 total spend", scount, scost)))

		BtmScan.Print(tr(" %1 [%2]", "print-in (<frameIndex>[Number]|<frameName>[String])", tr("Sets the chatFrame that BottomScanner's messages will be printed to")))
		BtmScan.Print(tr(" %1 [%2]", "baserule <lua>", tr("Advanced users only: Specify your own lua code for calculating the base price")))

		BtmScan.Print(tr(" %1 [%2]", "ignore <item>", tr("Ignores the specified item")))
		BtmScan.Print(tr(" %1 [%2]", "unignore <item>", tr("Stops ignoring the specified item")))
		BtmScan.Print(tr(" %1 [%2]", "snatch <item> <copper> <count>", tr("Sets the item's snatch value")))
		BtmScan.Print(tr(" %1 [%2]", "worth <item> <copper>", tr("Sets the specified item's value")))
		BtmScan.Print(tr(" %1 [%2]", "clear", tr("Clears the AH event log window")))
		BtmScan.Print(tr(" %1 [%2]", "dryrun", tr("Begins a test scanning run (must have AH open)")))
		BtmScan.Print(tr(" %1 [%2]", "begin", tr("Begins the scanning process (must have AH open)")))
		BtmScan.Print(tr(" %1 [%2]", "end", tr("Ends the scanning process")))
	end
end

BtmScan.BeginScan = function ()
	BtmScan.Log(tr("BottomScanner is now scanning"))
	BtmScan.scanning = true
	BtmScan.interval = 1
end
BtmScan.EndScan = function ()
	BtmScan.Log(tr("BottomScanner is stopping scanning"))
	BtmScan.scanning = false
end

BtmScan.AddAuctPriceModel = function (itemID, itemRand, itemEnch, itemName, count)
	local sanityKey = itemID..":"..itemRand
	local sanity = BtmScan.ConfidenceList[sanityKey]
	local iqm, iqwm
	if (sanity) then
		local iqm, iqwm, iqCount = strsplit(",", sanity)
		iqm = tonumber(iqm)
		iqwm = tonumber(iqwm)
		if (count and count > 1) then
			iqm = iqm * count
			iqwm = iqwm * count
		end
 		return {
			text = "BottomScanner",
			note = "",
			bid = iqwm,
			buyout = iqm
		}
	end
	return nil
end

BtmScan.CompileBaseRule = function()
	if not data or not data.baseRule or data.baseRule == "default" then
		BtmScan.BaseRule = nil
		return
	end

	local script = -- Block script below:
[[
local consKey     = BtmScan.prices.consKey
local consMean    = BtmScan.prices.consMean
local consPrice   = BtmScan.prices.consPrice
local consSeen    = BtmScan.prices.consSeen
local auctKey     = BtmScan.prices.auctKey
local auctPrice   = BtmScan.prices.auctPrice
local auctSeen    = BtmScan.prices.auctSeen
local itemID      = BtmScan.prices.itemID
local itemRand    = BtmScan.prices.itemRand
local itemEnch    = BtmScan.prices.itemEnch
local itemCount   = BtmScan.prices.itemCount
local bidPrice    = BtmScan.prices.bidPrice
local buyPrice    = BtmScan.prices.buyPrice
local basePrice   = BtmScan.prices.basePrice
local depositCost = BtmScan.prices.depositCost
local depositRate = BtmScan.depositRate
local cutRate     = BtmScan.cutRate
local auctionFee  = 0
]]..data.baseRule..[[

BtmScan.prices.depositCost = depositCost
BtmScan.prices.auctionFee = auctionFee
return basePrice
]]
	-- End of block script --

	local scriptFunc = loadstring(script)
	if (not scriptFunc) then
		BtmScan.Print("Error compiling BottomScanner BaseRule script")
		BtmScan.BaseRule = nil
		return
	end
	BtmScan.Print(tr("BottomScanner has set %1 to %2", tr("Base Rule"), tr("the provided value")))
	BtmScan.BaseRule = scriptFunc
end

BtmScan.GetDepositCost = function (itemID, count)
	local vendorValue = BtmScan.GetVendorPrice(itemID, count)
	if (not vendorValue) then return 0 end
	if (count and count > 1) then vendorValue = vendorValue * count end
	local baseDeposit = math.floor(vendorValue * BtmScan.depositRate) -- 2 hr auction
	return baseDeposit * 12 -- 24 hour auction
end

BtmScan.GetVendorPrice = function(itemID, count)
	local vendorValue = BtmScan.VendorPrices[itemID]
	if (not vendorValue and Informant and Informant.GetItem) then
		local itemInfo = Informant.GetItem(itemID)
		if (itemInfo and itemInfo.sell) then
			vendorValue = tonumber(itemInfo.sell) or 0
		end
	end
	if not vendorValue then return end
	if (count and count > 1) then vendorValue = vendorValue * count end
	return vendorValue
end

BtmScan.ConfigZone = function (whence)
	local realmName = GetRealmName()
	local currentZone = GetMinimapZoneText()
	local factionGroup
	
	if (not BtmScanData.factions) then
		BtmScan.Print(tr("BottomScanner: %1", tr("Zone data uninitialized: %1", whence)))
		return
	end
	if (BtmScanData.factions[currentZone]) then
		factionGroup = BtmScanData.factions[currentZone]
	else
		SetMapToCurrentZone()
		local map = GetMapInfo()
		if ((map == "Taneris") or (map == "Winterspring") or (map == "Stranglethorn")) then
			factionGroup = "Neutral"
		end
		BtmScanData.factions[currentZone] = factionGroup
	end

	if not factionGroup then factionGroup = UnitFactionGroup("player") end
	if not factionGroup then return end
	if (factionGroup == "Neutral") then
		BtmScan.cutRate = 0.15
		BtmScan.depositRate = 0.25
	else
		BtmScan.cutRate = 0.05
		BtmScan.depositRate = 0.05
	end
		
	return realmName.."-"..factionGroup
end

-- Gets the configdata for the current zone
BtmScan.GetZoneConfig = function (whence)
	local newZone = BtmScan.ConfigZone(whence.."getzone")
	if not newZone then
		BtmScan.Print(tr("BottomScanner: %1", tr("Unable to get config zone: %1", whence)))
		dataZone = ""
		data = {}
	elseif (newZone ~= dataZone) then
		BtmScan.Print(tr("BottomScanner: %1", tr("Switching to %1 config zone", newZone)))
		dataZone = newZone
		if (not BtmScanData.config[dataZone]) then BtmScanData.config[dataZone] = {} end
		data = BtmScanData.config[dataZone]

		if (not BtmScanData.version or BtmScanData.version < 115) then
			for i,j in pairs(BtmScanData) do
				-- Copy realm specific data to realm element
				if (i ~= "config" and i ~= "unlocked" and
				    i ~= "refresh" and i ~= "factions" and
				    i ~= "printFrame" and i ~= "version" and
				    not data[i]) then
					data[i] = j
					BtmScanData[i] = nil
				end
			end
			BtmScanData.version = 115
		end
	else
		return
	end

	-- Check config data
	if (not data.maxPrice) then data.maxPrice = 25000 end -- 2g50 max buyout
	if (not data.minProfit) then data.minProfit = 3000 end -- 30s min profit
	if (not data.pctProfit) then data.pctProfit = 30 end -- 30% min profit
	if (not data.minDeProfit) then data.minDeProfit = 4500 end -- 4g50
	if (not data.pctDeProfit) then data.pctDeProfit = 45 end -- 45%
	if (not data.reserve) then data.reserve = 20000 end -- 2gReserve
	if (not data.deFactor) then data.deFactor = 1.5 end -- 150%
	if (not data.minSeen) then data.minSeen = 3 end -- 150%
	if (not data.vendProfit) then data.vendProfit = 20 end -- 20c min vendor profit
	if (not data.commonMult) then data.commonMult = 1.5 end -- common multiplier
	if (not data.allowBids) then data.allowBids = 0 end -- to allow or not allow
	if (not data.ignore) then data.ignore = {} end -- ignore nothing
	if (not data.snatch) then data.snatch = {} end -- snatch list
	if (not data.snatched) then data.snatched = {} end -- snatched list
	if (not data.worth) then data.worth = {} end -- fixed price list
	if (not data.refresh) then data.refresh = 25 end -- fixed price list
	if (not data.bids) then data.bids = {} end -- latest bids and reasons
	if (not data.safetyCount) then data.safetyCount = 6 end -- safetynet count
	if (not data.safetyCost) then
		data.safetyCost = data.safetyCount * data.maxPrice / 2
	end -- safetynet cost
	BtmScan.CompileBaseRule()
end


BtmScan.TooltipHook = function (funcVars, retVal, frame, name, link, quality, count)
	-- Make sure the current zone is loaded and has defaults
	BtmScan.GetZoneConfig("tooltip")

	local ltype = EnhTooltip.LinkType(link)
	if ltype == "item" then
		local itemID, itemRand, itemEnch, itemUniq = BtmScan.BreakLink(link)
		local sanityKey = itemID..":"..itemRand
		local auctKey = itemID..":"..itemRand..":"..itemEnch

		local sanity = BtmScan.ConfidenceList[sanityKey]
		local iqm, iqwm, iqCount
		if (sanity) then
			local iqm, iqwm, iqCount = strsplit(",", sanity)
			iqm = tonumber(iqm)
			iqwm = tonumber(iqwm)
			iqCount = tonumber(iqCount)
			if (count and count > 1) then
				iqm = iqm * count
				iqwm = iqwm * count
			end

			EnhTooltip.AddLine(tr("BottomScanner prices"))
			EnhTooltip.LineColor(0.9,0.6,0.2)
			EnhTooltip.AddLine("  "..tr("IQR Mean"), iqm)
			EnhTooltip.LineColor(0.9,0.6,0.2)
			EnhTooltip.AddLine("  "..tr("Conservative"), iqwm)
			EnhTooltip.LineColor(0.9,0.6,0.2)

			local baseIs = "Conservative"
			local basePrice = iqwm
			local auctMedian, auctCount
			if (Auctioneer and Auctioneer.Statistic) then
				auctMedian, auctCount = Auctioneer.Statistic.GetUsableMedian(auctKey)
				if (auctMedian and auctCount) then
					if (auctMedian > basePrice) then
						basePrice = auctMedian
						baseIs = "Auctioneer"
					end
				end
			end
			if (not auctMedian) then auctMedian = 0 end
			if (not auctCount) then auctCount = 0 end

			if (not count or count < 1) then count = 1 end
			local deposit = BtmScan.GetDepositCost(itemID, count)
			if (not deposit) then deposit = 0 end
			if (BtmScan.BaseRule) then
				BtmScan.prices = {
					consKey = sanityKey,
					consMean = iqm * count,
					consPrice = iqwm * count,
					consSeen = iqCount,
					auctKey = auctKey,
					auctPrice = auctMedian * count,
					auctSeen = auctCount,
					itemID = itemID,
					itemRand = itemRand,
					itemEnch = itemEnch,
					itemCount = count,
					bidPrice = 0,
					buyPrice = 0,
					basePrice = basePrice * count,
					depositCost = deposit
				}
				local newBase = BtmScan.BaseRule()
				if (not newBase or newBase <= 0) then
					basePrice = 0
				elseif (newBase ~= basePrice) then
					basePrice = newBase
					baseIs = "Custom"
				end
			else
				basePrice = basePrice * count
			end

			if (data.worth[sanityKey]) then
				basePrice = tonumber(data.worth[sanityKey]) or 0
				baseIs = "Fixed Worth"
			end

			if (not basePrice or basePrice <= 0) then
				basePrice = 0
				baseIs = "Don't Buy"
			end
	
			local auctionFee
			if (BtmScan.prices) then
				auctionFee = BtmScan.prices.auctionFee
			end
			if (not auctionFee or auctionFee <= 0) then
				auctionFee = basePrice * 0.05
			end

			if (BtmScan.prices and BtmScan.prices.depositCost and BtmScan.prices.depositCost > 0) then
				deposit = BtmScan.prices.depositCost
			end

			EnhTooltip.AddLine("  "..tr("Valuation (%1)", tr(baseIs)), basePrice)
			EnhTooltip.LineColor(0.9,0.9,0.2)
			if (basePrice > 0) then
				EnhTooltip.AddLine("    ("..tr("Auction Fee")..")", auctionFee)
				EnhTooltip.LineColor(0.9,0.8,0.4)
				EnhTooltip.AddLine("    ("..tr("Deposit Cost")..")", deposit)
				EnhTooltip.LineColor(0.9,0.8,0.4)
			end

			if (data.snatch[sanityKey]) then
				local sdata = data.snatch[sanityKey]
				local price, count, stack
				local snatchLine = ""
				if (type(sdata) ~= "table") then
					price = tonumber(amount) or 0
					count = 0
					stack = 0
				else
					price = tonumber(sdata[1]) or 0
					count = tonumber(sdata[2]) or 0
					stack = tonumber(sdata[3]) or 0
				end
				if (count == 0) then
					EnhTooltip.AddLine("  "..tr("Snatch it at"), price)
				else
					local fulfilled = tonumber(data.snatched[sanityKey]) or 0
					EnhTooltip.AddLine("  "..tr("Snatch %1 (%2 done)", count, fulfilled), price)
				end
				EnhTooltip.LineColor(0.9,0.9,0.2)
				if (stack > 1) then
					EnhTooltip.AddLine("    "..tr("(or per %1 stack)", stack), price * stack)
					EnhTooltip.LineColor(0.9,0.9,0.2)
				end
			end

			if (BtmScan.sessionSpend and BtmScan.sessionSpend[sanityKey]) then
				local sspend = BtmScan.sessionSpend[sanityKey]
				EnhTooltip.AddLine("  "..tr("SafetyNet: %1 bought",  sspend.count), tonumber(sspend.cost) or 0)
				EnhTooltip.LineColor(0.9,0.6,0.2)
			end

			local bidSig = link.."x"..count
			if (data.bids and data.bids[bidSig]) then
				local whyBuy = data.bids[bidSig][1]
				local howMuch = data.bids[bidSig][2]
				local bidType = data.bids[bidSig][3] or tr("bought")
				local tStamp = data.bids[bidSig][4]
				local ago = ""
				if (tStamp) then
					local elapsed = time() - tStamp
					ago = tr(" (%1 ago)", SecondsToTime(elapsed))
				end
				EnhTooltip.AddLine("  "..tr("Last %1 for %2%3",  bidType, whyBuy, ago), tonumber(howMuch) or 0)
				EnhTooltip.LineColor(0.2,0.4,0.9)
			end
		end
	end
end

BtmScan.DoTooltip = function ()
	if (not this.lineID) then return end

	local i = this.lineID
	local line = BtmScan.LogFrame.Lines[i]:GetText()

	local itemID, itemRand, itemEnch, itemUniq, itemName, wholeLink, count, cost = BtmScan.BreakLink(line)
	if (itemID and itemID > 0) then
		--GameTooltip:SetOwner(BtmScan.LogFrame, "ANCHOR_NONE")
		GameTooltip:SetOwner(AuctionFrameCloseButton, "ANCHOR_NONE")
		GameTooltip:SetHyperlink("item:"..itemID..":"..itemEnch..":"..itemRand..":"..itemUniq)
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPLEFT", "AuctionFrame", "TOPRIGHT", 10, -20)
		if (EnhTooltip) then
			EnhTooltip.TooltipCall(GameTooltip, itemName, wholeLink, -1, count, cost)
		end
	end
end
BtmScan.PurchaseTooltip = function()
	if (BtmScan.Prompt.iLink) then
		local itemID, itemRand, itemEnch, itemUniq, itemName, wholeLink = BtmScan.BreakLink(iLink)
		if (itemID and itemID > 0) then
			GameTooltip:SetOwner(AuctionFrameCloseButton, "ANCHOR_NONE")
			GameTooltip:SetHyperlink("item:"..itemID..":"..itemEnch..":"..itemRand..":"..itemUniq)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("TOPLEFT", "AuctionFrame", "TOPRIGHT", 10, -20)
			if (EnhTooltip) then
				EnhTooltip.TooltipCall(GameTooltip, itemName, wholeLink, -1, BtmScan.Prompt.iCount, BtmScan.Prompt.bidPrice)
			end
		end
	end
end
BtmScan.UndoTooltip = function ()
	GameTooltip:Hide()
end


BtmScan.PromptPurchase = function(i, bidSig, whyBuy, bidPrice, bidType, noSafety, snatching, iCount, stackSize, sanityKey, iLink, iTex)
	BtmScan.scanStage = 3
	BtmScan.Prompt.index     = i
	BtmScan.Prompt.bidSig    = bidSig
	BtmScan.Prompt.whyBuy    = whyBuy
	BtmScan.Prompt.bidPrice  = bidPrice
	BtmScan.Prompt.bidType   = bidType
	BtmScan.Prompt.noSafety  = noSafety
	BtmScan.Prompt.snatching = snatching
	BtmScan.Prompt.iCount    = iCount
	BtmScan.Prompt.stackSize = stackSize
	BtmScan.Prompt.sanityKey = sanityKey
	BtmScan.Prompt.iLink     = iLink
	BtmScan.Prompt.iTex      = iTex

	local bidText = bidType
	if (bidText == tr("bought")) then bidText = tr("buyout") end
	
	BtmScan.Prompt.Lines[1]:SetText(tr("Do you want to %1:", bidText))
	BtmScan.Prompt.Lines[2]:SetText("  "..iLink.."x"..iCount)
	BtmScan.Prompt.Lines[3]:SetText("  "..tr("%1 price: %2", bidText, BtmScan.GSC(bidPrice)))
	BtmScan.Prompt.Lines[4]:SetText("  "..tr("Purchasing for: %1", whyBuy))
	BtmScan.Prompt.Lines[5]:SetText("");
	BtmScan.Prompt.Item:GetNormalTexture():SetTexture(iTex)
	BtmScan.Prompt:Show()
end
BtmScan.PerformPurchase = function()
	BtmScan.scanStage = 2
	local i         = BtmScan.Prompt.index
	local bidSig    = BtmScan.Prompt.bidSig
	local whyBuy    = BtmScan.Prompt.whyBuy
	local bidPrice  = BtmScan.Prompt.bidPrice
	local bidType   = BtmScan.Prompt.bidType
	local noSafety  = BtmScan.Prompt.noSafety
	local snatching = BtmScan.Prompt.snatching
	local iCount    = BtmScan.Prompt.iCount
	local stackSize = BtmScan.Prompt.stackSize
	local sanityKey = BtmScan.Prompt.sanityKey

	data.bids[bidSig] = { whyBuy, bidPrice, bidType, time() }
	--p("Placing bid on", i, bidPrice) --Normal commented this out. It errors, and thinks that the info is shown elsewhere anyways
	PlaceAuctionBid("list", i, bidPrice)
	-- Mark this item as "bought"
	if (not noSafety) then
		local bought = 1
		if (stackSize and stackSize > 1) then
			bought = iCount / stackSize
		end
		
		if (BtmScan.sessionSpend[sanityKey]) then
			BtmScan.sessionSpend[sanityKey].count = BtmScan.sessionSpend[sanityKey].count + bought 
			BtmScan.sessionSpend[sanityKey].cost = BtmScan.sessionSpend[sanityKey].cost + bidPrice
		else
			BtmScan.sessionSpend[sanityKey] = { count = bought, cost = bidPrice }
		end
	end
	if (snatching) then
		local snatched = tonumber(data.snatched[sanityKey]) or 0
		data.snatched[sanityKey] = snatched + iCount
	end
	BtmScan.Prompt:Hide()
end

BtmScan.CancelPurchase = function()
	BtmScan.scanStage = 2
	BtmScan.Prompt:Hide()
end

BtmScan.InputData = {
	dataField = nil,
	callBack = nil
}
BtmScan.InputShow = function ()
	if (BtmScan.InputData.dataField) then
		BtmScan.Input.Box:SetText(data[BtmScan.InputData.dataField] or "")
	else
		BtmScan.Input.Box:SetText("")
	end
end
BtmScan.InputDone = function ()
	if (BtmScan.InputData.dataField) then
		data[BtmScan.InputData.dataField] = BtmScan.Input.Box:GetText()
	end
	if (BtmScan.InputData.callBack) then
		BtmScan.InputData.callBack(BtmScan.Input.Box:GetText())
	end
	BtmScan.Input:Hide()
end
BtmScan.EditData = function (dataField, callBack)
	BtmScan.InputData.dataField = dataField
	BtmScan.InputData.callBack = callBack
	BtmScan.Input:Show()
end
BtmScan.InputUpdate = function()
	BtmScan.Input.Scroll:UpdateScrollChildRect()
--	local bar = getglobal(this:GetParent():GetName().."ScrollBar")
--	local min, max
--	min, max = bar:GetMinMaxValues()
--	if (max > 0 and this.max ~= max) then
--		this.max = max
--		bar:SetValue(max)
--	end
end

BtmScan.Frame = CreateFrame("Frame")
BtmScan.Frame:RegisterEvent("ADDON_LOADED")
BtmScan.Frame:SetScript("OnEvent", BtmScan.OnEvent)
BtmScan.Frame:SetScript("OnUpdate", BtmScan.OnUpdate)

BtmScan.Prompt = CreateFrame("Frame", "", UIParent)
BtmScan.Prompt:Hide()
BtmScan.Prompt:SetPoint("TOP", "UIParent", "TOP", 0, -100)
BtmScan.Prompt:SetFrameStrata("DIALOG")
BtmScan.Prompt:SetHeight(150)
BtmScan.Prompt:SetWidth(400)
BtmScan.Prompt:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 9, right = 9, top = 9, bottom = 9 }
})
BtmScan.Prompt:SetBackdropColor(0,0,0, 0.8)

BtmScan.Prompt.Item = CreateFrame("Button", "", BtmScan.Prompt)
BtmScan.Prompt.Item:SetNormalTexture("Interface\\Buttons\\UI-Slot-Background")
BtmScan.Prompt.Item:GetNormalTexture():SetTexCoord(0,0.640625, 0,0.640625)
BtmScan.Prompt.Item:SetPoint("TOPLEFT", BtmScan.Prompt, "TOPLEFT", 15, -15)
BtmScan.Prompt.Item:SetHeight(37)
BtmScan.Prompt.Item:SetWidth(37)
BtmScan.Prompt.Item:SetScript("OnEnter", BtmScan.PurchaseTooltip)
BtmScan.Prompt.Item:SetScript("OnLeave", BtmScan.UndoTooltip)

BtmScan.Prompt.Lines = {}
for i = 1, 5 do
	BtmScan.Prompt.Lines[i] = BtmScan.Prompt:CreateFontString("BtmScanPromptLine"..i, "HIGH")
	if (i == 1) then
		BtmScan.Prompt.Lines[i]:SetPoint("TOPLEFT", BtmScan.Prompt.Item, "TOPRIGHT", 5, 5)
		BtmScan.Prompt.Lines[i]:SetFont("Fonts\\FRIZQT__.TTF",16)
	else
		BtmScan.Prompt.Lines[i]:SetPoint("TOPLEFT", BtmScan.Prompt.Lines[i-1], "BOTTOMLEFT")
		BtmScan.Prompt.Lines[i]:SetFont("Fonts\\FRIZQT__.TTF",13)
	end
	BtmScan.Prompt.Lines[i]:SetWidth(350)
	BtmScan.Prompt.Lines[i]:SetJustifyH("LEFT")
	BtmScan.Prompt.Lines[i]:SetText("Prompt Line "..i)
	BtmScan.Prompt.Lines[i]:Show()
end

BtmScan.Prompt.Yes = CreateFrame("Button", "", BtmScan.Prompt, "OptionsButtonTemplate")
BtmScan.Prompt.Yes:SetText(tr("Yes"))
BtmScan.Prompt.Yes:SetPoint("BOTTOMRIGHT", BtmScan.Prompt, "BOTTOMRIGHT", -10, 10)
BtmScan.Prompt.Yes:SetScript("OnClick", BtmScan.PerformPurchase)
BtmScan.Prompt.No = CreateFrame("Button", "", BtmScan.Prompt, "OptionsButtonTemplate")
BtmScan.Prompt.No:SetText(tr("No"))
BtmScan.Prompt.No:SetPoint("BOTTOMRIGHT", BtmScan.Prompt.Yes, "BOTTOMLEFT", -5, 0)
BtmScan.Prompt.No:SetScript("OnClick", BtmScan.CancelPurchase)

BtmScan.Input = CreateFrame("Frame", "", UIParent)
BtmScan.Input:Hide()
BtmScan.Input:SetPoint("CENTER", "UIParent", "CENTER")
BtmScan.Input:SetFrameStrata("DIALOG")
BtmScan.Input:SetHeight(280)
BtmScan.Input:SetWidth(500)
BtmScan.Input:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 9, right = 9, top = 9, bottom = 9 }
})
BtmScan.Input:SetBackdropColor(0,0,0, 0.8)
BtmScan.Input:SetScript("OnShow", BtmScan.InputShow)

BtmScan.Input.Done = CreateFrame("Button", "", BtmScan.Input, "OptionsButtonTemplate")
BtmScan.Input.Done:SetText(tr("Done"))
BtmScan.Input.Done:SetPoint("BOTTOMRIGHT", BtmScan.Input, "BOTTOMRIGHT", -10, 10)
BtmScan.Input.Done:SetScript("OnClick", BtmScan.InputDone)

BtmScan.Input.Scroll = CreateFrame("ScrollFrame", "BtmScanInputScroll", BtmScan.Input, "UIPanelScrollFrameTemplate")
BtmScan.Input.Scroll:SetPoint("TOPLEFT", BtmScan.Input, "TOPLEFT", 20, -20)
BtmScan.Input.Scroll:SetPoint("RIGHT", BtmScan.Input, "RIGHT", -30, 0)
BtmScan.Input.Scroll:SetPoint("BOTTOM", BtmScan.Input.Done, "TOP", 0, 10)

BtmScan.Input.Box = CreateFrame("EditBox", "BtmScanEditBox", BtmScan.Input.Scroll)
BtmScan.Input.Box:SetWidth(460)
BtmScan.Input.Box:SetHeight(85)
BtmScan.Input.Box:SetMultiLine(true)
BtmScan.Input.Box:SetAutoFocus(true)
BtmScan.Input.Box:SetFontObject(GameFontHighlight)
BtmScan.Input.Box:SetScript("OnEscapePressed", BtmScan.InputDone)
BtmScan.Input.Box:SetScript("OnTextChanged", BtmScan.InputUpdate)

BtmScan.Input.Scroll:SetScrollChild(BtmScan.Input.Box)

BtmScan.CreateLogWindow = function()
	if (BtmScan.LogFrame) then return end
	if (not AuctionFrame) then return end

	-- Make sure the current zone is loaded and has defaults
	BtmScan.GetZoneConfig("createlog")

	BtmScan.LogParent = CreateFrame("Frame", "", AuctionFrame)
	BtmScan.LogParent:SetPoint("TOPLEFT", "AuctionFrame", "BOTTOMLEFT", 15, 30)
	BtmScan.LogParent:SetPoint("TOPRIGHT", "AuctionFrame", "BOTTOMRIGHT", -10, 30)
	BtmScan.LogParent:SetFrameStrata("BACKGROUND")
	BtmScan.LogParent:SetHeight(150)
	BtmScan.LogParent:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 9, right = 9, top = 9, bottom = 9
	}})
	BtmScan.LogParent:SetBackdropColor(0,0,0, 0.8)
	BtmScan.LogParent:Show()

	BtmScan.LogFrame = CreateFrame("ScrollFrame", "BtmScanLogFrame", BtmScan.LogParent, "FauxScrollFrameTemplate")
	BtmScan.LogFrame:SetPoint("TOPLEFT", BtmScan.LogParent, "TOPLEFT", 10, -50)
	BtmScan.LogFrame:SetPoint("BOTTOMRIGHT", BtmScan.LogParent, "BOTTOMRIGHT", -35, 10)

	BtmScan.LogFrame.LineFrames = {}
	BtmScan.LogFrame.Dates = {}
	BtmScan.LogFrame.Lines = {}
	for i=1, 8 do
		BtmScan.LogFrame.LineFrames[i] = CreateFrame("Frame", "BtmScanLogFrame"..i, BtmScan.LogFrame)
		if (i == 1) then
			BtmScan.LogFrame.LineFrames[i]:SetPoint("TOPLEFT", BtmScan.LogFrame, "TOPLEFT", 5, -2)
			BtmScan.LogFrame.LineFrames[i]:SetPoint("RIGHT", BtmScan.LogFrame, "RIGHT", -10, 0)

		else
			BtmScan.LogFrame.LineFrames[i]:SetPoint("TOPLEFT", BtmScan.LogFrame.LineFrames[i-1], "BOTTOMLEFT")
			BtmScan.LogFrame.LineFrames[i]:SetPoint("RIGHT", BtmScan.LogFrame.LineFrames[i-1], "RIGHT")
		end
		BtmScan.LogFrame.LineFrames[i]:SetHeight(10)
		BtmScan.LogFrame.LineFrames[i].lineID = i
		BtmScan.LogFrame.LineFrames[i]:EnableMouse(true)
		BtmScan.LogFrame.LineFrames[i]:SetScript("OnEnter", BtmScan.DoTooltip)
		BtmScan.LogFrame.LineFrames[i]:SetScript("OnLeave", BtmScan.UndoTooltip)

		BtmScan.LogFrame.Dates[i] = BtmScan.LogFrame.LineFrames[i]:CreateFontString("BtmScanLogDate"..i, "HIGH")
		BtmScan.LogFrame.Dates[i]:SetPoint("TOPLEFT", BtmScan.LogFrame.LineFrames[i], "TOPLEFT")
		BtmScan.LogFrame.Dates[i]:SetWidth(150)
		BtmScan.LogFrame.Dates[i]:SetFont("Fonts\\FRIZQT__.TTF",11)
		BtmScan.LogFrame.Dates[i]:SetJustifyH("LEFT")
		BtmScan.LogFrame.Dates[i]:SetText("Date"..i)
		BtmScan.LogFrame.Dates[i]:Show()

		BtmScan.LogFrame.Lines[i] = BtmScan.LogFrame.LineFrames[i]:CreateFontString("BtmScanLogLine"..i, "HIGH")
		BtmScan.LogFrame.Lines[i]:SetFont("Fonts\\FRIZQT__.TTF",11)
		BtmScan.LogFrame.Lines[i]:SetPoint("TOPLEFT", BtmScan.LogFrame.Dates[i], "TOPRIGHT", 5, 0)
		BtmScan.LogFrame.Lines[i]:SetPoint("RIGHT", BtmScan.LogFrame.LineFrames[i], "RIGHT")
		BtmScan.LogFrame.Lines[i]:SetJustifyH("LEFT")
		BtmScan.LogFrame.Lines[i]:SetText("Text"..i)
		BtmScan.LogFrame.Lines[i]:Show()
	end

	BtmScan.LogFrame.Update = function()
		if (not data.logText) then
			data.logText = { { time(), "--- Welcome to BottomScanner ---" } }
		end
		local rows = table.getn(data.logText)
		local scrollrows = rows
		if (scrollrows > 0 and scrollrows < 9) then scrollrows = 9 end
		FauxScrollFrame_Update(BtmScan.LogFrame, scrollrows, 8, 16)
		local line
		for i=1, 8 do
			line = rows - (FauxScrollFrame_GetOffset(BtmScanLogFrame) + i) + 1
			if (rows > 0 and line <= rows and line > 0) then
				BtmScan.LogFrame.Dates[i]:SetText("["..date("%Y-%m-%d %H:%M:%S", data.logText[line][1]).."]")
				BtmScan.LogFrame.Lines[i]:SetText(data.logText[line][2])
			else
				BtmScan.LogFrame.Dates[i]:SetText("")
				BtmScan.LogFrame.Lines[i]:SetText("")
			end
		end
	end
	BtmScan.LogFrame:SetScript("OnVerticalScroll", function ()
		FauxScrollFrame_OnVerticalScroll(16, BtmScan.LogFrame.Update)
	end)
	BtmScan.LogFrame:SetScript("OnShow", function()
		BtmScan.LogFrame.Update()
	end)

	BtmScan.LogFrame:Show()
end

