﻿--[[
	Auctioneer Advanced - Appraisals and Auction Posting
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds an appriasals dialog for
	easy posting of your auctionables when you are at the auction-house.

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

local lib = AucAdvanced.Modules.Util.Appraiser
local private = lib.Private
local print = AucAdvanced.Print
local Const = AucAdvanced.Const
local recycle = AucAdvanced.Recycle
local acquire = AucAdvanced.Acquire
local clone = AucAdvanced.Clone

local frame

local NUM_ITEMS = 12

function private.CreateFrames()
	if frame then return end

	local SelectBox = LibStub:GetLibrary("SelectBox")
	local ScrollSheet = LibStub:GetLibrary("ScrollSheet")

	frame = CreateFrame("Frame", "AucAdvAppraiserFrame", AuctionFrame)
	private.frame = frame
	local DiffFromModel = 0
	local MatchString = ""
	frame.list = {}
	frame.cache = {}
	
	function frame.GenerateList(repos)
		local n = #(frame.list)
		for i=1, n do
			frame.list[i] = nil
		end

		for bag=0,4 do
			for slot=1,GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag,slot)
				if link then
					local isDirect = false
					if frame.direct and frame.direct == link then
						isDirect = true
					end

					if AucAdvanced.Post.IsAuctionable(bag, slot) or isDirect then
						local itype, id, suffix, factor, enchant, seed = AucAdvanced.DecodeLink(link)
						if itype == "item" then
							local sig
							if enchant ~= 0 then
								sig = ("%d:%d:%d:%d"):format(id, suffix, factor, enchant)
							elseif factor ~= 0 then
								sig = ("%d:%d:%d"):format(id, suffix, factor)
							elseif suffix ~= 0 then
								sig = ("%d:%d"):format(id, suffix)
							else
								sig = tostring(id)
							end

							local texture, itemCount, locked, special, readable = GetContainerItemInfo(bag,slot)
							if special == -1 then special = true else special = false end
							if not itemCount or itemCount < 0 then itemCount = 1 end
							local found = false
							for i = 1, #(frame.list) do
								if frame.list[i] then
									if frame.list[i][1] == sig then
										frame.list[i][6] = frame.list[i][6] + itemCount
										found = true
										break
									end
								end
							end

							if not found then
								local ignore = not not AucAdvanced.Settings.GetSetting('util.appraiser.item.'..sig..".ignore")

								if frame.showHidden or (not ignore) or isDirect then
									local name, _,rarity,_,_,_,_, stack = GetItemInfo(link)
									
									table.insert(frame.list, {
										sig,name,texture,rarity,stack,itemCount,link,
										ignore=ignore
									} )
									
									if AucAdvanced.Modules.Util
									and AucAdvanced.Modules.Util.ScanData
									and AucAdvanced.Modules.Util.ScanData.GetDistribution
									and not frame.cache[sig] then
										local exact, suffix, base, colorDist = AucAdvanced.Modules.Util.ScanData.GetDistribution(link)
										frame.cache[sig] = { exact, suffix, base, {} }
										for k,v in pairs(colorDist.exact) do
											frame.cache[sig][4][k] = v
										end
									end
								end
							end
						end
					end
				end
			end
		end

		if frame.showAuctions then
			for auc=1, GetNumAuctionItems("owner") do
				local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, owner  = GetAuctionItemInfo("owner", auc)
				local link = GetAuctionItemLink("owner", auc)

				local itype, id, suffix, factor, enchant, seed = AucAdvanced.DecodeLink(link)
				if itype == "item" then
					local sig
					if enchant ~= 0 then
						sig = ("%d:%d:%d:%d"):format(id, suffix, factor, enchant)
					elseif factor ~= 0 then
						sig = ("%d:%d:%d"):format(id, suffix, factor)
					elseif suffix ~= 0 then
						sig = ("%d:%d"):format(id, suffix)
					else
						sig = tostring(id)
					end
				
					local found = false
					for i = 1, #(frame.list) do
						if frame.list[i][1] == sig and frame.list[i].auction then
							frame.list[i][6] = frame.list[i][6] + count
							found = true
							break
						end
					end
					
					if not found then
						local name, _,rarity,_,_,_,_, stack = GetItemInfo(link)
						
						table.insert(frame.list, {
							sig,name,texture,rarity,stack,count,link,
							auction=true
						} )
						
						if AucAdvanced.Modules.Util
						and AucAdvanced.Modules.Util.ScanData
						and AucAdvanced.Modules.Util.ScanData.GetDistribution
						and not frame.cache[sig] then
							local exact, suffix, base, colorDist = AucAdvanced.Modules.Util.ScanData.GetDistribution(link)
							frame.cache[sig] = { exact, suffix, base, {} }
							for k,v in pairs(colorDist.exact) do
								frame.cache[sig][4][k] = v
							end
						end
					end
				end
			end
		end
		
		table.sort(frame.list, private.sortItems)
		
		local pos = 0
		n = #frame.list
		if (n <= NUM_ITEMS) then
			frame.scroller:Hide()
			frame.scroller:SetMinMaxValues(0, 0)
			frame.scroller:SetValue(0)
		else
			frame.scroller:Show()
			frame.scroller:SetMinMaxValues(0, n-NUM_ITEMS)
			-- Find the current item
			for i = 1, n do
				if frame.list[i][1] == frame.selected then
					pos = i
					break
				end
			end
		end
		if (repos) then
			frame.scroller:SetValue(math.max(0, math.min(n-NUM_ITEMS+1, pos-(NUM_ITEMS/2))))
		end
		frame:SetScroll()

		if frame.itembox.sig then
			frame.UpdateControls()
		end
		return pos
	end

	private.empty = {}
	function frame.SelectItem(obj, button)
		if not obj.id then obj = obj:GetParent() end
		local pos = math.floor(frame.scroller:GetValue())
		local id = obj.id
		pos = math.min(pos + id, #frame.list)
		local item = frame.list[pos]
		local sig = nil
		if item then
			sig = item[1] or nil
		end
		if button and sig == frame.selected then
			sig = nil
			pos = nil
		end
		frame.selected = sig
		frame.selectedPos = pos
		frame.selectedObj = obj
		frame.selectedAuction = item and item.auction
		frame.SetScroll()

		frame.salebox.sig = sig
		if sig then
			local _,_,_, hex = GetItemQualityColor(item[4])
			frame.salebox.icon:SetNormalTexture(item[3])
			frame.salebox.name:SetText(hex.."["..item[2].."]|r")
			if item.auction then
				frame.salebox.info:SetText("You have "..item[6].." up for auction")
			else
				frame.salebox.info:SetText("You have "..item[6].." available to auction")
			end
			frame.salebox.info:SetTextColor(1,1,1, 0.8)
			frame.salebox.link = item[7]
			frame.salebox.stacksize = item[5]
			frame.salebox.count = item[6]

			frame.UpdateImage()
			frame.InitControls()
			--Also pass this search to BeanCounter's frame
			if BeanCounter and BeanCounter.externalSearch and BeanCounter.API.isLoaded then
				BeanCounter.externalSearch(item[1], nil, nil, 50)
			end			
		else
			frame.salebox.name:SetText("No item selected")
			frame.salebox.name:SetTextColor(0.5, 0.5, 0.7)
			if not AucAdvanced.Settings.GetSetting("util.appraiser.classic") then
				frame.salebox.info:SetText("Select an item to the left to begin auctioning...")
			else
				frame.salebox.info:SetText("Select an item to begin auctioning...")
			end
			frame.salebox.info:SetTextColor(0.5, 0.5, 0.7)
			frame.imageview.sheet:SetData(private.empty)
			frame.imageviewclassic.sheet:SetData(private.empty)
			frame.UpdateControls()
		end

		--[[if not (frame.direct and item and item[7] and frame.direct == item[7]) then
			frame.direct = nil
			frame.GenerateList()
		end]]
	end

	function frame.Reselect(posted)
		local reselect = (frame.selected == posted[1])
		local reselectenabled = AucAdvanced.Settings.GetSetting("util.appraiser.reselect")
		frame.GenerateList()
		if reselect then
			if reselectenabled then
				frame.SelectItem(frame.selectedObj)
			else
				frame.selected = nil
				frame.selectedPos = nil
				frame.salebox.sig = nil
				frame.salebox.name:SetText("No item selected")
				frame.salebox.name:SetTextColor(0.5, 0.5, 0.7)
				if not AucAdvanced.Settings.GetSetting("util.appraiser.classic") then
					frame.salebox.info:SetText("Select an item to the left to begin auctioning...")
				else
					frame.salebox.info:SetText("Select an item to begin auctioning...")
				end
				frame.salebox.info:SetTextColor(0.5, 0.5, 0.7)
				frame.imageview.sheet:SetData(private.empty)
				frame.imageviewclassic.sheet:SetData(private.empty)
				frame.UpdateControls()
			end
		end
	end

	function frame.DirectSelect(link)
		if frame.direct == link then return end
		frame.direct = link
		local sig
		local itype, id, suffix, factor, enchant, seed = AucAdvanced.DecodeLink(link)
		if enchant ~= 0 then
			sig = ("%d:%d:%d:%d"):format(id, suffix, factor, enchant)
		elseif factor ~= 0 then
			sig = ("%d:%d:%d"):format(id, suffix, factor)
		elseif suffix ~= 0 then
			sig = ("%d:%d"):format(id, suffix)
		else
			sig = tostring(id)
		end
		frame.GenerateList()
		frame.GetItemByLink(link)
		frame.GenerateList(true)
	end

	function frame.UpdateImage()
		if not frame.salebox.sig then return end

		local itemId, suffix, factor = strsplit(":", frame.salebox.sig)
		itemId = tonumber(itemId)
		suffix = tonumber(suffix) or 0
		factor = tonumber(factor) or 0

		local results = AucAdvanced.API.QueryImage({
			itemId = itemId,
			suffix = suffix,
			factor = factor,
		})
		local itemkey = string.join(":", "item", itemId, "0", "0", "0", "0", "0", suffix, factor)
		
		local data = acquire()
		local style = acquire()
		for i = 1, #results do
			local result = results[i]
			local tLeft = result[Const.TLEFT]
			if (tLeft == 1) then tLeft = "30m"
			elseif (tLeft == 2) then tLeft = "2h"
			elseif (tLeft == 3) then tLeft = "12h"
			elseif (tLeft == 4) then tLeft = "48h"
			end
			local count = result[Const.COUNT]
			data[i] = acquire (
				result[Const.NAME],
				result[Const.SELLER],
				tLeft,
				count,
				math.floor(0.5+result[Const.MINBID]/count),
				math.floor(0.5+result[Const.CURBID]/count),
				math.floor(0.5+result[Const.BUYOUT]/count),
				result[Const.MINBID],
				result[Const.CURBID],
				result[Const.BUYOUT],
				result[Const.LINK]
			)
			local r,g,b = frame.SetPriceColor(itemkey, count, result[Const.CURBID], result[Const.BUYOUT])
			if r then
				style[i] = acquire()
				style[i][1] = acquire()
				style[i][1].textColor = acquire(r,g,b)
			end
		end
		frame.refresh:Enable()
		frame.switchUI:Enable()
		frame.imageview.sheet:SetData(data, style)
		frame.imageviewclassic.sheet:SetData(data, style)
		recycle(data)
		recycle(style)
		--reset scroll position if new items list is too short to show
		if  not frame.imageview.sheet.rows[1][1]:IsShown() then
			frame.imageview.sheet.panel:ScrollToCoords(0,0)
		end
		
	end

	function frame.SetPriceColor(itemID, count, requiredBid, buyoutPrice, rDef, gDef, bDef)
		if AucAdvanced.Settings.GetSetting('util.appraiser.color') and AucAdvanced.Modules.Util.PriceLevel then
			local _, link = GetItemInfo(itemID)
			local _, _, r,g,b = AucAdvanced.Modules.Util.PriceLevel.CalcLevel(link, count, requiredBid, buyoutPrice)
			return r,g,b
		end
		return rDef,gDef,bDef
	end
		
	function frame.SetPriceFromModel(curModel)
		if not frame.salebox.sig then return end
		if not curModel then
			curModel = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".model") or "default"
		else
			AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".model", curModel)
		end
		frame.salebox.warn:SetText("")
		if curModel == "default" then
			curModel = AucAdvanced.Settings.GetSetting("util.appraiser.model") or "market"
			if ((curModel == "market") and ((not AucAdvanced.API.GetMarketValue(frame.salebox.link)) or (AucAdvanced.API.GetMarketValue(frame.salebox.link) <= 0))) or
			   ((not (curModel == "fixed")) and (not (curModel == "market")) and ((not AucAdvanced.API.GetAlgorithmValue(curModel, frame.salebox.link)) or (AucAdvanced.API.GetAlgorithmValue(curModel, frame.salebox.link) <= 0))) then
				curModel = AucAdvanced.Settings.GetSetting("util.appraiser.altModel")
			end
			frame.salebox.model:SetText("Default ("..curModel..")")
		end

		local newBuy, newBid
		local match = frame.salebox.matcher:GetChecked()
		if (frame.salebox.matcher:IsEnabled() == 0) then
			match = false
		end
		if curModel == "fixed" then
			newBuy = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".fixed.buy")
			newBid = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".fixed.bid")
			if match and AucAdvanced.API.GetBestMatch(frame.salebox.link, newBuy) then
				local _
				local BidPercent = newBid/newBuy
				newBuy, _, _, DiffFromModel, MatchString = AucAdvanced.API.GetBestMatch(frame.salebox.link, newBuy)
				newBid = newBuy * BidPercent
			end
		elseif curModel == "market" then
			if match and AucAdvanced.API.GetBestMatch(frame.salebox.link, curModel) then
				local _
				newBuy, _, _, DiffFromModel, MatchString = AucAdvanced.API.GetBestMatch(frame.salebox.link, curModel)
			else
				newBuy = AucAdvanced.API.GetMarketValue(frame.salebox.link)
			end
		else
			if match and AucAdvanced.API.GetBestMatch(frame.salebox.link, curModel) then
				local _
				newBuy, _, _, DiffFromModel, MatchString = AucAdvanced.API.GetBestMatch(frame.salebox.link, curModel)
			else
				newBuy = AucAdvanced.API.GetAlgorithmValue(curModel, frame.salebox.link)
			end
		end

		if curModel ~= "fixed" then
			if not newBuy or newBuy <= 0 then
				frame.salebox.warn:SetText(("No %s price available!"):format(curModel))
				MoneyInputFrame_ResetMoney(frame.salebox.bid)
				MoneyInputFrame_ResetMoney(frame.salebox.buy)
				frame.salebox.bid.modelvalue = 0
				frame.salebox.buy.modelvalue = 0
				return
			end

			if newBuy and not newBid then
				local markdown = math.floor(AucAdvanced.Settings.GetSetting("util.appraiser.bid.markdown") or 0)/100
				local subtract = AucAdvanced.Settings.GetSetting("util.appraiser.bid.subtract") or 0
				local deposit = AucAdvanced.Settings.GetSetting("util.appraiser.bid.deposit") or false
				if (deposit) then
					local rate = AucAdvanced.depositRate or 0.05
					local newfaction
					if rate == .25 then newfaction = "neutral" end
					deposit = GetDepositCost(frame.salebox.link, 12, newfaction)
				else deposit = 0 end

				-- Scale up for duration > 12 hours
				if deposit > 0 then
					local curDurationIdx = frame.salebox.duration:GetValue()
					local duration = private.durations[curDurationIdx][1]
					deposit = deposit * duration/720
				end

				markdown = newBuy * markdown

				newBid = math.max(newBuy - markdown - subtract - deposit, 1)
			end

			if newBid and (not newBuy or newBid > newBuy) then
				newBuy = newBid
			end
		end

		newBid = math.floor((newBid or 0) + 0.5)
		newBuy = math.floor((newBuy or 0) + 0.5)

		local oldBid = MoneyInputFrame_GetCopper(frame.salebox.bid)
		local oldBuy = MoneyInputFrame_GetCopper(frame.salebox.buy)
		MoneyInputFrame_ResetMoney(frame.salebox.bid)
		MoneyInputFrame_ResetMoney(frame.salebox.buy)
		MoneyInputFrame_SetCopper(frame.salebox.bid, newBid)
		MoneyInputFrame_SetCopper(frame.salebox.buy, newBuy)
		if oldBid ~= newBid then
			frame.salebox.buyconfig = true
		end
		if oldBuy ~= newBuy then
			frame.salebox.buyconfig = true
		end
		frame.salebox.bid.modelvalue = newBid
		frame.salebox.buy.modelvalue = newBuy
	end

	function frame.InitControls()
		if frame.salebox.config then return end
		frame.salebox.config = true

		local curDuration = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".duration") or
			AucAdvanced.Settings.GetSetting('util.appraiser.duration') or 2880

		for i=1, #private.durations do
			if (curDuration == private.durations[i][1]) then
				frame.salebox.duration:SetValue(i)
				break
			end
		end

		local defStack = AucAdvanced.Settings.GetSetting("util.appraiser.stack")
		if defStack == "max" then
			defStack = frame.salebox.stacksize
		elseif (not (tonumber(defStack))) then
			defStack = frame.salebox.stacksize
			AucAdvanced.Settings.SetSetting("util.appraiser.stack", "max")
		end
		defStack = tonumber(defStack)
		if defStack > frame.salebox.stacksize then
			defStack = frame.salebox.stacksize
		end
		local curStack = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".stack") or defStack
		frame.salebox.stack:SetValue(curStack)
		
		local defStack = AucAdvanced.Settings.GetSetting("util.appraiser.number")
		if defStack == "maxplus" then
			defStack = -1
		elseif defStack == "maxfull" then
			defStack = -2
		elseif (not (tonumber(defStack))) then
			defStack = -1
			AucAdvanced.Settings.SetSetting("util.appraiser.number", "maxplus")
		else
			defStack = tonumber(defStack)
		end
		local curNumber = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".number") or defStack
		frame.salebox.number:SetAdjustedValue(curNumber)
		
		local defMatch = AucAdvanced.Settings.GetSetting("util.appraiser.match")
		local curMatch = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".match")
		if curMatch == nil then
			curMatch = defMatch
		end
		if curMatch == "on" then
			frame.salebox.matcher:SetChecked(true)
		elseif curMatch == "off" then
			frame.salebox.matcher:SetChecked(false)
		else
			frame.salebox.matcher:SetChecked(curMatch)
		end

		local curBulk = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".bulk") or false
		frame.salebox.bulk:SetChecked(curBulk)


		local curModel = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".model") or "default"
		frame.salebox.model.value = curModel
		frame.salebox.model:UpdateValue()
		frame.SetPriceFromModel(curModel)

		frame.UpdateControls()
		frame.salebox.config = nil
	end
	
	function frame.ShowOwnAuctionDetails(itemString)
        local colored = (AucAdvanced.Settings.GetSetting('util.appraiser.manifest.color') and AucAdvanced.Modules.Util.PriceLevel)

		local itemName, itemLink = GetItemInfo(itemString)
		
		local results = AucAdvanced.Modules.Util.Appraiser.ownResults[itemName]
		local counts = AucAdvanced.Modules.Util.Appraiser.ownCounts[itemName]
		
		if counts and #counts>0 then
			table.sort(counts)
		
			frame.manifest.lines:Add("")
			frame.manifest.lines:Add("Own auctions:       |cffffffff(price/each)", nil, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

			for _,count in ipairs(counts) do
				local res = results[count]
				local avgBid = res.countBid>0 and (res.sumBid / res.countBid) or nil
				local avgBO =  res.countBO>0 and (res.sumBO / res.countBO) or nil
				
				local r,g,b,_
				if colored then
					_, _, r,g,b = AucAdvanced.Modules.Util.PriceLevel.CalcLevel(itemLink, 1, avgBid, avgBO)
				end
				r,g,b = r or 1,g or 1, b or 1
				
				frame.manifest.lines:Add(format("  %2d lots of %2dx", res.stackCount, count)..
					(avgBO and "" or " (bid)"), avgBO or avgBid, r,g,b)
			end
		end
	end

	function frame.UpdateControls()
		if ( not frame.salebox.sig ) or	-- nothing selected
		   ( frame.selectedAuction and not frame.itembox:IsShown()) -- old UI: don't show auctions
		   then
			frame.salebox.icon:SetAlpha(0)
			frame.salebox.stack:Hide()
			frame.salebox.number:Hide()
			frame.salebox.stackentry:Hide()
			frame.salebox.numberentry:Hide()
			frame.salebox.model:Hide()
			frame.salebox.matcher:Hide()
			frame.salebox.bid:Hide()
			frame.salebox.buy:Hide()
			frame.salebox.duration:Hide()
			frame.salebox.warn:SetText("")
			frame.salebox.note:SetText("")
			frame.manifest.lines:Clear()
			frame.manifest:Hide()
			frame.toggleManifest:Disable()
			frame.age:SetText("")
			frame.go:Disable()
			frame.salebox.depositcost:SetText("")
			frame.salebox.totalbid:SetText("")
			frame.salebox.totalbuyout:SetText("")
			frame.salebox.ignore:Hide()
			frame.salebox.bulk:Hide()
			return
		end
		frame.salebox.icon:SetAlpha(1)
		frame.salebox.matcher:Show()
		frame.salebox.bid:Show()
		frame.salebox.model:Show()
		frame.salebox.buy:Show()
		frame.salebox.duration:Show()
		frame.manifest.lines:Clear()
		frame.manifest:SetFrameLevel(AuctionFrame:GetFrameLevel())
		if frame.itembox:IsShown() then
			-- new UI
			frame.salebox.ignore:Show()
			frame.salebox.bulk:Show()
			if frame.selectedAuction then
				frame.salebox.number:Hide()
				frame.salebox.stack:Hide()
				frame.salebox.stackentry:Hide()
				frame.salebox.numberentry:Hide()
			else
				frame.salebox.number:Show()
				frame.salebox.stack:Show()
				frame.salebox.stackentry:Show()
				frame.salebox.numberentry:Show()
			end
		else
			-- old UI
			frame.salebox.stackentry:Show()
			frame.salebox.stacksoflabel:Show()
			frame.salebox.numberentry:Show()
			frame.salebox.depositcost:Show()
			frame.salebox.totalbid:Show()
			frame.salebox.totalbuyout:Show()
		end
		frame.toggleManifest:Enable()
		if frame.toggleManifest:GetText() == "Close Sidebar" then
			frame.manifest:Show()
		end
		
		frame.refresh:Enable()
		frame.switchUI:Enable()

		local matchers = AucAdvanced.Settings.GetSetting("matcherlist")
		if not matchers or #matchers == 0 then
			frame.salebox.matcher:Disable()
			frame.salebox.matcher.label:SetTextColor(.5, .5, .5)
		else
			frame.salebox.matcher:Enable()
			frame.salebox.matcher.label:SetTextColor(1, 1, 1)
		end

		local itemId, suffix, factor = strsplit(":", frame.salebox.sig)
		itemId = tonumber(itemId)
		suffix = tonumber(suffix) or 0
		factor = tonumber(factor) or 0

		local itemKey = string.join(":", "item", itemId, "0", "0", "0", "0", "0", suffix, factor)
	
		local results = AucAdvanced.API.QueryImage({
			itemId = itemId,
			suffix = suffix,
			factor = factor,
		})
		
		if results[1] then
			local seen = results[1][Const.TIME]
			if (time() - seen) < 60 then
				frame.age:SetText("Data is < 1 minute old")
			elseif ((time() - seen) / 3600) <= 48 then
				frame.age:SetText("Data is "..SecondsToTime(time() - seen, true).." old")
			else
				frame.age:SetText("Data is > 48 hours old")
			end
		else
			frame.age:SetText("No data for "..string.sub(frame.salebox.name:GetText(), 12, -4))
		end

		local curDurationIdx = frame.salebox.duration:GetValue() or 3
		local curDurationMins = private.durations[curDurationIdx][1]
		local curDurationText = private.durations[curDurationIdx][2]
		frame.salebox.duration.label:SetText(("Duration: %s"):format(curDurationText))

		local curIgnore = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".ignore") or false
		frame.salebox.icon:GetNormalTexture():SetDesaturated(curIgnore)
		frame.salebox.ignore:SetChecked(curIgnore)

		local curBid = frame.salebox.bid.modelvalue or 0
		local curBuy = frame.salebox.buy.modelvalue or 0

		local sig = frame.salebox.sig
		local totalBid, totalBuy, totalDeposit = 0,0,0
		local bidVal, buyVal, depositVal

		local r,g,b,a
		local colored = AucAdvanced.Settings.GetSetting('util.appraiser.manifest.color')
		local tinted = AucAdvanced.Settings.GetSetting('util.appraiser.tint.color')
		
		r,g,b,a=0,0,0,0
		if tinted then
			r,g,b = frame.SetPriceColor(itemKey, 1, curBid, curBid,  r,g,b)
			if r then a=0.4 end
		end
		AppraiserSaleboxBidGold:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBidSilver:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBidCopper:SetBackdropColor(r,g,b, a)
		
		r,g,b,a=0,0,0,0
		if tinted then
			r,g,b = frame.SetPriceColor(itemKey, 1, curBuy, curBuy,  r,g,b)
			if r then a=0.4 end
		end
		AppraiserSaleboxBuyGold:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBuySilver:SetBackdropColor(r,g,b, a)
		AppraiserSaleboxBuyCopper:SetBackdropColor(r,g,b, a)
		
		if not frame.selectedAuction then

			local depositMult = curDurationMins / 720
			local curNumber = frame.salebox.number:GetAdjustedValue()

			if (frame.salebox.stacksize > 1) then
				local count = frame.salebox.count

				frame.salebox.stack:SetMinMaxValues(1, frame.salebox.stacksize)
				local curSize = frame.salebox.stack:GetValue()
				local extra = ""
				if (curSize > count) then
					extra = "  |cffffaa40" .. "(Stack > Available)"
				end
				frame.salebox.stack.label:SetText(("Stack size: %d"):format(curSize)..extra)
				frame.salebox.stack:SetAlpha(1)
				frame.salebox.stackentry:SetNumber(curSize)

				local maxStax = math.floor(count / curSize)
				local fullPop = maxStax*curSize
				local remain = count - fullPop
				frame.salebox.number:SetAdjustedRange(maxStax, -2, -1)
				if (curNumber >= -2 and curNumber < 0) then
					if (curNumber == -2) then
						frame.salebox.number.label:SetText(("Number: %s"):format(("All full stacks (%d) = %d"):format(maxStax, fullPop)))
						frame.salebox.totalsize:SetText("("..(fullPop)..")")
						frame.salebox.numberentry:SetText("Full")
					else
						frame.salebox.number.label:SetText(("Number: %s"):format(("All stacks (%d) plus %d = %d"):format(maxStax, remain, count)))
						frame.salebox.totalsize:SetText("("..(count)..")")
						frame.salebox.numberentry:SetText("All")
					end
					--frame.salebox.numberentry:SetNumber(maxStax)
					if (maxStax > 0) then
						frame.manifest.lines:Clear()
						frame.manifest.lines:Add(("%d lots of %dx stacks:"):format(maxStax, curSize))
						bidVal = lib.RoundBid(curBid * curSize)
						buyVal = lib.RoundBuy(curBuy * curSize)
											
						local rate = AucAdvanced.depositRate or 0.05
						local newfaction
						if rate == .25 then newfaction = "neutral" end
						depositVal = GetDepositCost(frame.salebox.link, 12, newfaction, curSize) * depositMult
						
						r,g,b=nil,nil,nil
						if colored then
							r,g,b = frame.SetPriceColor(itemKey, curSize, bidVal, bidVal)
						end
						frame.manifest.lines:Add(("  Bid for %dx"):format(curSize), bidVal, r,g,b)
						r,g,b=nil,nil,nil
						if colored then
							r,g,b = frame.SetPriceColor(itemKey, curSize, buyVal, buyVal)
						end
						frame.manifest.lines:Add(("  Buyout for %dx"):format(curSize), buyVal, r,g,b)
						frame.manifest.lines:Add(("  Deposit for %dx"):format(curSize), depositVal)

						totalBid = totalBid + (bidVal * maxStax)
						totalBuy = totalBuy + (buyVal * maxStax)
						totalDeposit = totalDeposit + (depositVal * maxStax)
					end
					if (curNumber == -1 and remain > 0) then
						bidVal = lib.RoundBid(curBid * remain)
						buyVal = lib.RoundBuy(curBuy * remain)
						
						local rate = AucAdvanced.depositRate or 0.05
						local newfaction
						if rate == .25 then newfaction = "neutral" end
						depositVal = GetDepositCost(frame.salebox.link, 12, newfaction, remain) * depositMult
						
						frame.manifest.lines:Clear()
						frame.manifest.lines:Add(("%d lots of %dx stacks:"):format(1, remain))
						r,g,b=nil,nil,nil
						if colored then
							r,g,b = frame.SetPriceColor(itemKey, remain, bidVal, bidVal)
						end
						frame.manifest.lines:Add(("  Bid for %dx"):format(remain), bidVal, r,g,b)
						r,g,b=nil,nil,nil
						if colored then
							r,g,b = frame.SetPriceColor(itemKey, remain, buyVal, buyVal)
						end
						frame.manifest.lines:Add(("  Buyout for %dx"):format(remain), buyVal, r,g,b)
						frame.manifest.lines:Add(("  Deposit for %dx"):format(remain), depositVal)

						totalBid = totalBid + bidVal
						totalBuy = totalBuy + buyVal
						totalDeposit = totalDeposit + depositVal
					end
				else
					frame.salebox.number.label:SetText(("Number: %s"):format(("%d stacks = %d"):format(curNumber, curNumber*curSize)))
					frame.salebox.totalsize:SetText("("..(curNumber*curSize)..")")
					frame.salebox.numberentry:SetNumber(curNumber)
					frame.manifest.lines:Clear()
					frame.manifest.lines:Add(("%d lots of %dx stacks:"):format(curNumber, curSize))
					bidVal = lib.RoundBid(curBid * curSize)
					buyVal = lib.RoundBuy(curBuy * curSize)
					
					local rate = AucAdvanced.depositRate or 0.05
					local newfaction
					if rate == .25 then newfaction = "neutral" end
					depositVal = GetDepositCost(frame.salebox.link, 12, newfaction, curSize) * depositMult
					
					r,g,b=nil,nil,nil
					if colored then
						r,g,b = frame.SetPriceColor(itemKey, curSize, bidVal, bidVal)
					end
					frame.manifest.lines:Add(("  Bid for %dx"):format(curSize), bidVal, r,g,b)
					r,g,b=nil,nil,nil
					if colored then
						r,g,b = frame.SetPriceColor(itemKey, curSize, buyVal, buyVal)
					end
					frame.manifest.lines:Add(("  Buyout for %dx"):format(curSize), buyVal, r,g,b)
					frame.manifest.lines:Add(("  Deposit for %dx"):format(curSize), depositVal)

					totalBid = totalBid + (bidVal * curNumber)
					totalBuy = totalBuy + (buyVal * curNumber)
					totalDeposit = totalDeposit + (depositVal * curNumber)
				end

			else
				frame.salebox.stack:SetMinMaxValues(1,1)
				frame.salebox.stack:SetValue(1)
				frame.salebox.stack.label:SetText("Item is not stackable")
				frame.salebox.stackentry:SetNumber(1)
				frame.salebox.stack:SetAlpha(0.6)

				frame.salebox.number:SetAdjustedRange(frame.salebox.count, -1)
				if (curNumber == -1) then
					curNumber = frame.salebox.count
					frame.salebox.number.label:SetText(("Number: %s"):format(("All items = %d"):format(curNumber)))
					frame.salebox.totalsize:SetText("("..(curNumber)..")")
					frame.salebox.numberentry:SetText("All")
				else
					frame.salebox.number.label:SetText(("Number: %s"):format(("%d items"):format(curNumber)))
					frame.salebox.totalsize:SetText("("..(curNumber)..")")
					frame.salebox.numberentry:SetNumber(curNumber)
				end
				
				if curNumber > 0 then
					frame.manifest.lines:Clear()
					frame.manifest.lines:Add(("%d items"):format(curNumber))
					bidVal = lib.RoundBid(curBid)
					buyVal = lib.RoundBuy(curBuy)
					
					local rate = AucAdvanced.depositRate or 0.05
					local newfaction
					if rate == .25 then newfaction = "neutral" end
					local baseDeposit = GetDepositCost(frame.salebox.link, 12, newfaction) or 0
					
					depositVal = baseDeposit * depositMult
					r,g,b=nil,nil,nil
					if colored then
						r,g,b = frame.SetPriceColor(itemKey, 1, bidVal, bidVal)
					end
					frame.manifest.lines:Add(("  Bid /item"), bidVal, r,g,b)
					r,g,b=nil,nil,nil
					if colored then
						r,g,b = frame.SetPriceColor(itemKey, 1, buyVal, buyVal)
					end
					frame.manifest.lines:Add(("  Buyout /item"), buyVal, r,g,b)
					frame.manifest.lines:Add(("  Deposit /item"), depositVal)
					totalBid = totalBid + (bidVal * curNumber)
					totalBuy = totalBuy + (buyVal * curNumber)
					totalDeposit = totalDeposit + (depositVal * curNumber)
				end
			end
			frame.manifest.lines:Add(("Totals:"))
			frame.manifest.lines:Add(("  Total Bid"), totalBid)
			frame.manifest.lines:Add(("  Total Buyout"), totalBuy)
			frame.manifest.lines:Add(("  Total Deposit"), totalDeposit)
			frame.salebox.depositcost:SetText("Deposit:      "..EnhTooltip.GetTextGSC(totalDeposit, true))
			frame.salebox.totalbid:SetText("Total Bid:    "..EnhTooltip.GetTextGSC(totalBid, true))
			frame.salebox.totalbuyout:SetText("Total Buyout: "..EnhTooltip.GetTextGSC(totalBuy, true))
			local curModel = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".model") or "default"
			if (frame.salebox.matcher:GetChecked() and (frame.salebox.matcher:IsEnabled()==1) and (DiffFromModel)) then
				local MatchStringList = {strsplit("\n", MatchString)}
				for i in pairs(MatchStringList) do
					frame.manifest.lines:Add((MatchStringList[i]))
				end
			end
			
			if (totalBid < 1) then
				frame.manifest.lines:Add(("------------------------------"))
				frame.manifest.lines:Add(("Note: No auctionable items"))
			end
		end -- if not frame.selectedAuction then
		
		frame.ShowOwnAuctionDetails(itemKey)	-- Adds lines to frame.manifest

		frame.salebox.note:SetText("")
		if GetSellValue then
			local sellValue = GetSellValue(frame.salebox.link)
			if (sellValue and sellValue > 0) then
				if curBuy > 0 and curBuy < sellValue then
					frame.salebox.note:SetText("|cffff8010".."Note: Buyout < Vendor")
				elseif curBid > 0 and curBid < sellValue then
					frame.salebox.note:SetText("Note: Min Bid < Vendor")
				end
			end
		end
		
		local canAuction = true
		if curModel == "fixed" and curBid <= 0 then
			frame.salebox.warn:SetText("Bid price must be > 0")
			canAuction = false
		elseif (curBuy > 0 and curBid > curBuy) then
			frame.salebox.warn:SetText("Buy price must be > bid")
			canAuction = false
		else
			frame.salebox.warn:SetText("")
		end

		if totalBid < 1 then
			canAuction = false
		end
		
		if frame.selectedAuction then
			canAuction = false
		end

		if canAuction then
			frame.go:Enable()
		else
			frame.go:Disable()
		end

		-- Give this function a chance to save the current settings
		-- (if we're not already running within it)
		if not frame.salebox.config then
			frame.ChangeControls()
		end
	end

	function frame.ChangeControls(obj, ...)
		if frame.salebox.config then return end
		frame.salebox.config = true

		local curStack = frame.salebox.stack:GetValue()
		local curNumber = frame.salebox.number:GetAdjustedValue()
		local curDurationIdx = frame.salebox.duration:GetValue()
		local curDuration = private.durations[curDurationIdx][1]
		local curMatch = frame.salebox.matcher:GetChecked()
		local curBulk = frame.salebox.bulk:GetChecked()
		local curIgnore = frame.salebox.ignore:GetChecked()

		if curIgnore then curIgnore = true else curIgnore = false end
		if curBulk then curBulk = true else curBulk = false end
		AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".stack", curStack)
		AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".number", curNumber)
		AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".duration", curDuration)
		AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".bulk", curBulk)
		AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".ignore", curIgnore)
		if curMatch then
			curMatch = "on"
		else
			curMatch = "off"
		end  --must be something other than true/false, as false == nil, so false would cause default to be used
		AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".match", curMatch)

		local curModel
		if (obj and obj.element == "model") then
			curModel = select(2, ...)
			if curModel ~= "fixed" then
				frame.SetPriceFromModel(curModel)
			end
		else
			curModel = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".model")
		end

		local curBid = MoneyInputFrame_GetCopper(frame.salebox.bid)
		local curBuy = MoneyInputFrame_GetCopper(frame.salebox.buy)
		if frame.salebox.bid.modelvalue ~= curBid
		or frame.salebox.buy.modelvalue ~= curBuy
		then
			curModel = "fixed"
			frame.salebox.matcher:SetChecked(False)
			AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".model", curModel)
			AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".fixed.bid", curBid)
			AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".fixed.buy", curBuy)
			frame.salebox.model.value = curModel
			frame.salebox.model:UpdateValue()
		end

		--[[local good = true
		if curModel == "fixed" and curBid <= 0 then
			frame.salebox.warn:SetText("Bid price must be > 0")
			good = false
		elseif (curBuy > 0 and curBid > curBuy) then
			frame.salebox.warn:SetText("Buy price must be > bid")
			good = false
		end
		if (good and curModel == "fixed") then
			frame.salebox.warn:SetText("")
		end]]

		--[[frame.salebox.note:SetText("")
		if GetSellValue then
			local sellValue = GetSellValue(frame.salebox.link)
			if (sellValue and sellValue > 0) then
				if curBuy > 0 and curBuy < sellValue then
					frame.salebox.note:SetText("|cffff8010".."Note: Buyout < Vendor")
				elseif curBid > 0 and curBid < sellValue then
					frame.salebox.note:SetText("Note: Min Bid < Vendor")
				end
			end
		end]]

		frame.salebox.config = false
	end
	
	function frame.ChangeUI()
		if AucAdvanced.Settings.GetSetting("util.appraiser.classic") then
			frame.itembox:Hide()
			frame.salebox:SetPoint("TOPLEFT", frame, "TOPLEFT", 13, -71)
			frame.salebox:SetPoint("RIGHT", frame, "LEFT", 253, 0)
			frame.salebox:SetHeight(340)
			frame.salebox.stack:Hide()
			frame.salebox.number:Hide()
			frame.salebox.model:SetPoint("TOPLEFT", frame.salebox.icon, "BOTTOMLEFT", 0, -45)
			frame.salebox.bid:ClearAllPoints()
			frame.salebox.bid:SetPoint("TOP", frame.salebox.model, "BOTTOM", 0, -35)
			frame.salebox.bid:SetPoint("LEFT", frame.salebox, "LEFT", 25, 0)
			frame.salebox.bid.label:ClearAllPoints()
			frame.salebox.bid.label:SetPoint("BOTTOMLEFT", frame.salebox.bid, "TOPLEFT", 0, 2)
			frame.salebox.buy:SetPoint("TOPLEFT", frame.salebox.bid, "BOTTOMLEFT", 0, -20)
			frame.salebox.buy.label:ClearAllPoints()
			frame.salebox.buy.label:SetPoint("BOTTOMLEFT", frame.salebox.buy, "TOPLEFT", 0, 2)
			frame.salebox.duration:SetPoint("TOPLEFT", frame.salebox.buy, "BOTTOMLEFT", -10, -10)
			frame.gobatch:Hide()
			frame.go:SetPoint("BOTTOMRIGHT", frame.salebox, "BOTTOMRIGHT", -20, 15)
			frame.salebox.info:ClearAllPoints()
			frame.salebox.info:SetPoint("TOPLEFT", frame.salebox.slot, "BOTTOMLEFT", 0, 8)
			frame.imageview:Hide()
			frame.imageviewclassic:Show()
			frame.salebox.numberentry:SetPoint("TOPLEFT", frame.salebox.duration, "BOTTOMLEFT", 20, -5)
			frame.salebox.stackentry:SetPoint("TOPLEFT", frame.salebox.stacksoflabel, "TOPRIGHT", 5, 0)
			if not frame.salebox.sig then
				frame.salebox.info:SetText("Select an item to begin auctioning...")
			else
				frame.salebox.stackentry:Show()
				frame.salebox.stacksoflabel:Show()
				frame.salebox.numberentry:Show()
				frame.salebox.totalsize:Show()
				frame.salebox.depositcost:Show()
				frame.salebox.totalbid:Show()
				frame.salebox.totalbuyout:Show()
			end
			frame.salebox.name:SetHeight(36)
			frame.salebox.warn:SetJustifyH("LEFT")
			frame.salebox.warn:SetPoint("BOTTOMLEFT", frame.salebox.slot, "BOTTOMLEFT", 0, -25)
			frame.salebox.oldnote = frame.salebox.note
			frame.salebox.note = frame.salebox.warn
			frame.salebox.ignore:Hide()
			frame.salebox.bulk:Hide()
		else
			frame.salebox.stackentry:SetPoint("TOPLEFT", frame.salebox.stack, "TOPRIGHT", 5, 0)
			frame.salebox.numberentry:SetPoint("TOPLEFT", frame.salebox.number, "TOPRIGHT", 5, 0)
			frame.salebox.stacksoflabel:Hide()
			frame.salebox.totalsize:Hide()
			frame.salebox.numberentry:Hide()
			frame.salebox.depositcost:Hide()
			frame.salebox.totalbid:Hide()
			frame.salebox.totalbuyout:Hide()
			frame.salebox.ignore:Show()
			frame.salebox.bulk:Show()
			frame.itembox:Show()
			frame.salebox:SetPoint("TOPLEFT", frame.itembox, "TOPRIGHT", -3,35)
			frame.salebox:SetPoint("RIGHT", frame, "RIGHT", -5,0)
			frame.salebox:SetHeight(170)
			if frame.salebox.sig then
				frame.salebox.stack:Show()
				frame.salebox.stackentry:Show()
				frame.salebox.numberentry:Show()
				frame.salebox.number:Show()
			else
				frame.salebox.info:SetText("Select an item to the left to begin auctioning...")
			end
			frame.salebox.icon:SetScript("OnClick", frame.IconClicked)
			frame.salebox.bid:ClearAllPoints()
			frame.salebox.bid:SetPoint("TOP", frame.salebox.number, "BOTTOM", 0,-5)
			frame.salebox.bid:SetPoint("RIGHT", frame.salebox, "RIGHT", 0,0)
			frame.salebox.buy:SetPoint("TOPLEFT", frame.salebox.bid, "BOTTOMLEFT", 0,-5)
			frame.salebox.duration:SetPoint("TOPLEFT", frame.salebox.number, "BOTTOMLEFT", 0,0)
			frame.salebox.model:SetPoint("TOPLEFT", frame.salebox.duration, "BOTTOMLEFT", 0,-16)
			frame.salebox.bid.label:ClearAllPoints()
			frame.salebox.bid.label:SetPoint("LEFT", frame.salebox.model, "RIGHT", 5,0)
			frame.salebox.bid.label:SetPoint("TOPRIGHT", frame.salebox.bid, "TOPLEFT", -5,0)
			frame.salebox.bid.label:SetPoint("BOTTOMRIGHT", frame.salebox.bid, "BOTTOMLEFT", -5,0)
			frame.salebox.buy.label:ClearAllPoints()
			frame.salebox.buy.label:SetPoint("LEFT", frame.salebox.model, "RIGHT", 5,0)
			frame.salebox.buy.label:SetPoint("TOPRIGHT", frame.salebox.buy, "TOPLEFT", -5,0)
			frame.salebox.buy.label:SetPoint("BOTTOMRIGHT", frame.salebox.buy, "BOTTOMLEFT", -5,0)
			frame.gobatch:Show()
			frame.go:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7,15)
			frame.salebox.info:ClearAllPoints()
			frame.salebox.info:SetPoint("BOTTOMLEFT", frame.salebox.slot, "BOTTOMRIGHT", 5,7)
			frame.imageview:Show()
			frame.imageviewclassic:Hide()
			frame.salebox.name:SetHeight(20)
			frame.salebox.warn:SetJustifyH("RIGHT")
			frame.salebox.warn:SetPoint("BOTTOMLEFT", frame.salebox.slot, "BOTTOMRIGHT", 5, 0)
			frame.salebox.note = frame.salebox.oldnote or frame.salebox.note
			frame.salebox.oldnote = nil
		end
		
		frame.UpdateControls()
	end

	function frame.GetItemByLink(link)
		local sig
		local itype, id, suffix, factor, enchant, seed = AucAdvanced.DecodeLink(link)
		assert(itype and itype == "item", "Item must be a valid link")

		if enchant ~= 0 then
			sig = ("%d:%d:%d:%d"):format(id, suffix, factor, enchant)
		elseif factor ~= 0 then
			sig = ("%d:%d:%d"):format(id, suffix, factor)
		elseif suffix ~= 0 then
			sig = ("%d:%d"):format(id, suffix)
		else
			sig = tostring(id)
		end
		for i = 1, #(frame.list) do
			if frame.list[i] then
				if frame.list[i][1] == sig then
					local obj = {}
					obj.id = i
					local pos = math.floor(frame.scroller:GetValue())
					obj.id = obj.id - pos
					frame.SelectItem(obj)
					frame.scroller:SetValue(i-(NUM_ITEMS*(i/#frame.list)))
					return
				end
			end
		end
		frame.DirectSelect(link)
	end
	
	function frame.IconClicked()
		local objtype, _, itemlink = GetCursorInfo()
		ClearCursor()
		if objtype == "item" then
			frame.GetItemByLink(itemlink)
		else
			if not AucAdvanced.Settings.GetSetting("util.appraiser.classic") then
				frame.ToggleDisabled()
			end
		end
	end
	
	function frame.ToggleDisabled()
		if not frame.salebox.sig then return end
		local curDisable = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".ignore") or false
		AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".ignore", not curDisable)
		frame.GenerateList()
	end

	function frame.RefreshView(background,link)
		if not link then
			link = frame.salebox.link
			if not link then
				-- The user attempted a single-item refresh without selecting anything, just re-enable the button and return.
			    print("No items were selected for refresh.")
				frame.refresh:Enable()
				return
			-- else
				-- print(("Got link from salebox: {{%s}}"):format(link))
			end
		-- else
			-- print(("Got link from parameter: {{%s}}"):format(link))
		end
		local name, _, rarity, _, itemMinLevel, itemType, itemSubType, stack, equipLoc = GetItemInfo(link)
		local itemTypeId, itemSubId
		for catId, catName in pairs(AucAdvanced.Const.CLASSES) do
			if catName == itemType then
				itemTypeId = catId
				for subId, subName in pairs(AucAdvanced.Const.SUBCLASSES[itemTypeId]) do
					if subName == itemSubType then
						itemSubId = subId
						break
					end
				end
				break
			end
		end
		if equipLoc == "" then equipLoc = nil end

		print(("Refreshing view of {{%s}}"):format(name))
		if background and type(background) == 'boolean' then
			AucAdvanced.Scan.StartPushedScan(name, itemMinLevel, itemMinLevel, equipLoc, itemTypeId, itemSubId, nil, rarity)
		else
			AucAdvanced.Scan.PushScan()
			AucAdvanced.Scan.StartScan(name, itemMinLevel, itemMinLevel, equipLoc, itemTypeId, itemSubId, nil, rarity)
		end
	end

	function frame.RefreshAll()
		local bg = false
		for i = 1, #(frame.list) do
			local item = frame.list[i]
			if item then
				local link = item[7]
				frame.RefreshView(bg, link)
				bg = true
			end
		end
	end
	
	-- We use this to make sure the correct number of parameters are passed to RefreshView; otherwise, we can end up with e.g. link="LeftButton".
	function frame.SmartRefresh()
		frame.refresh:Disable()
		if (not IsAltKeyDown()) then
			frame.RefreshView()
		else
			frame.RefreshAll()
		end
	end

	function frame.PostAuctions(obj)
		local postType = obj.postType
		if postType == "single" then
			frame.PostBySig(frame.salebox.sig)
		elseif postType == "batch" then
			if not IsModifierKeyDown() then
				message("This button requires you to press a combination of keys when clicked.\nSee help printed in the chat frame for further details.")
				print("The batch post mechanism will allow you to perform automated actions on all the items in your inventory marked for batch posting.")
				print("You must hold down one of the following keys when you click the button:")
				print("  - Alt = Auto-refresh all batch postable items.")
				print("  - Shift = List all auctions that would be posted without actually posting them.")
				print("  - Control+Alt+Shift = Auto-post all batch postable items.")
				return
			end

			local a = IsAltKeyDown()
			local s = IsShiftKeyDown()
			local c = IsControlKeyDown()

			local mode
			if a and c and s then mode = "autopost" end
			if a and not c and not s then mode = "refresh" end
			if not a and not c and s then mode = "list" end

			if not mode then
				message("Unknown key combination pressed while clicking batch post button.")
				return
			end
			
			if mode == "list" then
				print "The following items would have be auto-posted:"
			end
			
			local bg = false
			local obj = acquire()
			for i = 1, #(frame.list) do
				local item = frame.list[i]
				if item then
					local sig = item[1]
					if AucAdvanced.Settings.GetSetting('util.appraiser.item.'..sig..".bulk") then
						if mode == "autopost" then
							-- Auto post these items
							frame.PostBySig(sig)
						elseif mode == "list" then
							-- List these items
							frame.PostBySig(sig, true)
						elseif mode == "refresh" then
							-- Refresh these items
							local link = item[7]
							frame.RefreshView(bg, link)
							bg = true
						end
					end
				end
			end
			
		end
	end

	function frame.PostBySig(sig, dryRun)
		local generallink = AucAdvanced.Modules.Util.Appraiser.GetLinkFromSig(sig)
		local itemBuy, itemBid, _, _, _, _, stack, number, duration = AucAdvanced.Modules.Util.Appraiser.GetPrice(generallink, _, true)
		local success, errortext, total, _,_, link = pcall(AucAdvanced.Post.FindMatchesInBags, sig)
		if success==false then
			UIErrorsFrame:AddMessage("Unable to post auctions at this time")
			print("Cannot post auctions: ", errortext)
			return
		end

		-- Just a quick bit of sanity checking first
		if not link then
			print("Skipping "..generallink..": no auctionable item in bags.  May need to repair item")
			return
		elseif not (stack and stack >= 1) then
			print("Skipping "..link..": no stack size set")
			return
		elseif (not number) or number < -2 or number == 0 then
			print("Skipping "..link..": invalid number of stacks/items set")
			return
		elseif (not itemBid) or itemBid <= 0 then
			print("Skipping "..link..": no bid value set")
			return
		elseif not (itemBuy and (itemBuy == 0 or itemBuy >= itemBid)) then
			print("Skipping "..link..": invalid buyout value")
			return
		elseif not (duration and (duration == 720 or duration == 1440 or duration == 2880)) then
			print("Skipping "..link..": invalid duration")
			return
		elseif not (total and total > 0) or (number > 0 and number * stack > total) then
			print("Skipping "..link..": You do not have enough items to do that")
			return
		elseif (number == -2) and (stack > total) then
			print("Skipping "..link..": Stack size larger than available")
			return
		end

		print(("Posting batch of: %s"):format(link))

		print((" - Duration: {{%d hours}}"):format(duration/60))

		local bidVal, buyVal
		local totalBid, totalBuy, totalNum = 0,0,0

		if (stack > 1) then
			local fullStacks = math.floor(total / stack)
			local fullPop = fullStacks * stack
			local remain = total - fullPop

			if (number < 0) then
				if (fullStacks > 0) then
					bidVal = lib.RoundBid(itemBid * stack)
					buyVal = lib.RoundBuy(itemBuy * stack)
					if (buyVal ~= 0 and bidVal > buyVal) then buyVal = bidVal end
					if dryRun then
						print((" - Pretending to post {{%d}} stacks of {{%d}} at {{%s}} min and {{%s}} buyout per stack"):format(fullStacks, stack, EnhTooltip.GetTextGSC(bidVal, true), EnhTooltip.GetTextGSC(buyVal, true)))
					else
						print((" - Queueing {{%d}} lots of {{%d}}"):format(fullStacks, stack))
						AucAdvanced.Post.PostAuction(sig, stack, bidVal, buyVal, duration, fullStacks)
					end

					totalBid = totalBid + (bidVal * fullStacks)
					totalBuy = totalBuy + (buyVal * fullStacks)
					totalNum = totalNum + (stack * fullStacks)
				end
				if (number == -1 and remain > 0) then
					bidVal = lib.RoundBid(itemBid * remain)
					buyVal = lib.RoundBuy(itemBuy * remain)
					if (buyVal ~= 0 and bidVal > buyVal) then buyVal = bidVal end
					if dryRun then
						print((" - Pretending to post {{%d}} stacks of {{%d}} at {{%s}} min and {{%s}} buyout per stack"):format(1, remain, EnhTooltip.GetTextGSC(bidVal, true), EnhTooltip.GetTextGSC(buyVal, true)))
					else
						print((" - Queueing {{%d}} lots of {{%d}}"):format(1, remain))
						AucAdvanced.Post.PostAuction(sig, remain, bidVal, buyVal, duration)
					end

					totalBid = totalBid + bidVal
					totalBuy = totalBuy + buyVal
					totalNum = totalNum + remain
				end
			else
				bidVal = lib.RoundBid(itemBid * stack)
				buyVal = lib.RoundBuy(itemBuy * stack)
				if (buyVal ~= 0 and bidVal > buyVal) then buyVal = bidVal end
				if dryRun then
					print((" - Pretending to post {{%d}} stacks of {{%d}} at {{%s}} min and {{%s}} buyout per stack"):format(number, stack, EnhTooltip.GetTextGSC(bidVal, true), EnhTooltip.GetTextGSC(buyVal, true)))
				else
					print((" - Queueing {{%d}} lots of {{%d}}"):format(number, stack))
					AucAdvanced.Post.PostAuction(sig, stack, bidVal, buyVal, duration, number)
				end

				totalBid = totalBid + (bidVal * number)
				totalBuy = totalBuy + (buyVal * number)
				totalNum = totalNum + (stack * number)
			end
		else
			if number < 0 then number = total end
			bidVal = lib.RoundBid(itemBid)
			buyVal = lib.RoundBuy(itemBuy)
			if (buyVal ~= 0 and bidVal > buyVal) then buyVal = bidVal end
			if dryRun then
				print((" - Pretending to post {{%d}} items at {{%s}} min and {{%s}} buyout"):format(number, EnhTooltip.GetTextGSC(bidVal, true), EnhTooltip.GetTextGSC(buyVal, true)))
			else
				print((" - Queueing {{%d}} items"):format(number))
				AucAdvanced.Post.PostAuction(sig, 1, bidVal, buyVal, duration, number)
			end

			totalBid = totalBid + (bidVal * number)
			totalBuy = totalBuy + (buyVal * number)
			totalNum = totalNum + number
		end

		print("-----------------------------------")
		if dryRun then
			print(("Pretended {{%d}} items"):format(totalNum))
		else
			print(("Queued up {{%d}} items"):format(totalNum))
		end
		print(("Total minbid value: %s"):format(EnhTooltip.GetTextGSC(totalBid, true)))
		print(("Total buyout value: %s"):format(EnhTooltip.GetTextGSC(totalBuy, true)))
		print("-----------------------------------")
	end

	function frame.ClickBagHook(_,_,button)
		if (not AucAdvanced.Settings.GetSetting("util.appraiser.clickhook")) then return end
		local bag = this:GetParent():GetID()
		local slot = this:GetID()
		local texture, count, noSplit = GetContainerItemInfo(bag, slot)
		local link = GetContainerItemLink(bag, slot)
		if (frame.salebox and frame.salebox:IsVisible()) then
			if link then
				if (button == "LeftButton") and (IsAltKeyDown()) then
					frame.GetItemByLink(link)
					if (IsShiftKeyDown()) then
						local stack = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".stack")
						local number = AucAdvanced.Settings.GetSetting('util.appraiser.item.'..frame.salebox.sig..".number")
						AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".stack", count)
						AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".number", 1)
						frame.PostBySig(frame.salebox.sig)
						AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".stack", stack)
						AucAdvanced.Settings.SetSetting('util.appraiser.item.'..frame.salebox.sig..".number", number)
					end
				end
			end
		end
	end
	
	function frame.SetScroll(...)
		local pos = math.floor(frame.scroller:GetValue())
		for i = 1, NUM_ITEMS do
			local item = frame.list[pos+i]
			local button = frame.items[i]
			if item then
				local curIgnore = item.ignore

				button.icon:SetTexture(item[3])
				button.icon:SetDesaturated(curIgnore)

				local _,_,_, hex = GetItemQualityColor(item[4])
				local stackX = "x "
				if item.auction then
					stackX = ""
				end
				
				if curIgnore then
					hex = "|cff444444"
					stackX = hex..stackX
				end

				button.name:SetText(hex.."["..item[2].."]|r")
				button.size:SetText(stackX..item[6])
				
				if item.auction then
					button.size:SetAlpha(0.7)
				else
					button.size:SetAlpha(1)
				end
				
				local info = ""
				if frame.cache[item[1]] and not curIgnore then
					local exact, suffix, base, dist = unpack(frame.cache[item[1]])
					info = "Counts: "..exact.." +"..suffix.." +"..base
					if (dist) then
						info = AucAdvanced.Modules.Util.ScanData.Colored(true, dist, nil, true)	-- use shortened format
					end
				end
				button.info:SetText(info)
				button:Show()
				button.bg:SetVertexColor(1,1,1)
				if (item[1] == frame.selected) then
					button.bg:SetAlpha(0.6)
				elseif curIgnore then
					button.bg:SetAlpha(0.1)
				elseif item.auction then
					button.bg:SetVertexColor(0.3,0.1,1)	-- very dark red
					button.bg:SetAlpha(0.3)
				else
					button.bg:SetAlpha(0.2)
				end
				
				button.bg:SetDesaturated(curIgnore)
			else
				button:Hide()
			end
		end
	end

	frame.DoTooltip = function ()
		if not this.id then this = this:GetParent() end
		local id = this.id
		local pos = math.floor(frame.scroller:GetValue())
		local item = frame.list[pos + id]
		if item then
			local name = item[2]
			local link = item[7]
			local count = item[6]
			GameTooltip:SetOwner(frame.itembox, "ANCHOR_NONE")
			GameTooltip:SetHyperlink(link)
			if (EnhTooltip) then
				EnhTooltip.TooltipCall(GameTooltip, name, link, -1, count)
			end
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("TOPLEFT", frame.itembox, "TOPRIGHT", 10, 0)
		end
	end
	frame.UndoTooltip = function ()
		GameTooltip:Hide()
	end

	frame:SetPoint("TOPLEFT", "AuctionFrame", "TOPLEFT", 10,-70)
	frame:SetPoint("BOTTOMRIGHT", "AuctionFrame", "BOTTOMRIGHT", 0,0)

	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", frame, "TOPLEFT", 80, -16)
	title:SetText("Appraiser: Auction posting interface")

	frame.toggleManifest = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.toggleManifest:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -26, -13)
	frame.toggleManifest:SetScript("OnClick", function()
		if frame.manifest:IsShown() then
			frame.toggleManifest:SetText("Open Sidebar")
			frame.manifest:Hide()
		else
			frame.toggleManifest:SetText("Close Sidebar")
			frame.manifest:Show()
		end
	end)
	frame.toggleManifest:SetWidth(120)
	frame.toggleManifest:SetText("Close Sidebar")
	frame.toggleManifest:Disable()
	frame.toggleManifest:Show()

	frame.config = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.config:SetPoint("TOPRIGHT", frame.toggleManifest, "TOPLEFT", 3, 0)
	frame.config:SetText("Configure")
	frame.config:SetScript("OnClick", function()
		AucAdvanced.Settings.Show()
		private.gui:ActivateTab(private.guiId)
	end)
	
	frame.switchUI = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.switchUI:SetPoint("TOPRIGHT", frame.config, "TOPLEFT", 2, 0)
	frame.switchUI:SetText("Switch UI")
	frame.switchUI:SetWidth(80)
	frame.switchUI:SetScript("OnClick", function()
		AucAdvanced.Settings.SetSetting("util.appraiser.classic", (not AucAdvanced.Settings.GetSetting("util.appraiser.classic")))
		frame.ChangeUI()
	end)
	frame.switchUI:Enable()

	frame.itembox = CreateFrame("Frame", nil, frame)
	frame.itembox:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame.itembox:SetBackdropColor(0, 0, 0, 0.8)
	frame.itembox:SetPoint("TOPLEFT", frame, "TOPLEFT", 13, -71)
	frame.itembox:SetWidth(240)
	frame.itembox:SetHeight(340)

	-- "Show Auctions" checkbox
	frame.itembox.showAuctions = CreateFrame("CheckButton", "Auc_Util_Appraiser_ShowAuctions", frame.itembox, "OptionsCheckButtonTemplate")
	frame.itembox.showAuctions.tooltipText = "Include own auctions in the item listing"
	frame.itembox.showAuctions:SetWidth(24)
	frame.itembox.showAuctions:SetHeight(24)
	Auc_Util_Appraiser_ShowAuctionsText:SetText("Auctions ")
	frame.itembox.showAuctions:SetPoint("BOTTOMRIGHT", frame.itembox, "TOPRIGHT", 0-Auc_Util_Appraiser_ShowAuctionsText:GetWidth(), 0)
	frame.itembox.showAuctions:SetHitRectInsets(0, 0-Auc_Util_Appraiser_ShowAuctionsText:GetWidth(), 0, 0)
	frame.itembox.showAuctions:SetScript("OnClick", function()
		frame.showAuctions = this:GetChecked()
		frame.GenerateList(true)
		PlaySound(frame.showAuctions and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff");
	end)
	
	-- "Show Hidden" checkbox
	frame.itembox.showHidden = CreateFrame("CheckButton", "Auc_Util_Appraiser_ShowHidden", frame.itembox, "OptionsCheckButtonTemplate")
	frame.itembox.showHidden.tooltipText = "Include items tagged as 'hidden' in the item listing"
	frame.itembox.showHidden:SetWidth(24)
	frame.itembox.showHidden:SetHeight(24)
	Auc_Util_Appraiser_ShowHiddenText:SetText("Hidden ")
	frame.itembox.showHidden:SetPoint("BOTTOMRIGHT", frame.itembox.showAuctions, "BOTTOMLEFT", 0-Auc_Util_Appraiser_ShowHiddenText:GetWidth(), 0)
	frame.itembox.showHidden:SetHitRectInsets(0, 0-Auc_Util_Appraiser_ShowHiddenText:GetWidth(), 0, 0)
	frame.itembox.showHidden:SetScript("OnClick", function()
		frame.showHidden = this:GetChecked()
		frame.GenerateList(true)
		PlaySound(frame.showHidden and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff");
	end)
	
	-- "Show:" label
	frame.itembox.showText = CreateFrame("Frame", nil, frame.itembox)
	frame.itembox.showText:SetPoint("BOTTOMRIGHT", frame.itembox.showHidden, "BOTTOMLEFT", 0,0)
	frame.itembox.showText.text = frame.itembox.showText:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.itembox.showText.text:SetAllPoints(frame.itembox.showText)
	frame.itembox.showText.text:SetText("Show: ")
	frame.itembox.showText:SetWidth(frame.itembox.showText.text:GetWidth())
	frame.itembox.showText:SetHeight(frame.itembox.showAuctions:GetHeight())
	
	

	frame.items = {}
	for i=1, NUM_ITEMS do
		local item = CreateFrame("Button", nil, frame.itembox)
		frame.items[i] = item
		item:SetScript("OnClick", function(obj, button)
			if IsShiftKeyDown() and IsAltKeyDown() then
				local pos = math.floor(frame.scroller:GetValue())
				local id = obj.id
				pos = math.min(pos + id, #frame.list)
				local sig = nil
				if frame.list[pos] then
					sig = frame.list[pos][1]
				end
				frame.PostBySig(sig)
			else
				frame.SelectItem(obj, button)
			end
		end)
		if (i == 1) then
			item:SetPoint("TOPLEFT", frame.itembox, "TOPLEFT", 5,-8 )
		else
			item:SetPoint("TOPLEFT", frame.items[i-1], "BOTTOMLEFT", 0, -1)
		end
		item:SetPoint("RIGHT", frame.itembox, "RIGHT", -23,0)
		item:SetHeight(26)

		item.id = i

		item.iconbutton = CreateFrame("Button", nil, item)
		item.iconbutton:SetHeight(26)
		item.iconbutton:SetWidth(26)
		item.iconbutton:SetPoint("LEFT", item, "LEFT", 3,0)
		item.iconbutton:SetScript("OnClick", function(obj, button)
			if IsShiftKeyDown() and IsAltKeyDown() then
				obj = obj:GetParent()
				local pos = math.floor(frame.scroller:GetValue())
				local id = obj.id
				pos = math.min(pos + id, #frame.list)
				local sig = nil
				if frame.list[pos] then
					sig = frame.list[pos][1]
				end
				frame.PostBySig(sig)
			else
				frame.SelectItem(obj, button)
			end
		end)
		item.iconbutton:SetScript("OnEnter", frame.DoTooltip)
		item.iconbutton:SetScript("OnLeave", frame.UndoTooltip)

		item.icon = item.iconbutton:CreateTexture(nil, "OVERLAY")
		item.icon:SetPoint("TOPLEFT", item.iconbutton, "TOPLEFT", 0,0)
		item.icon:SetPoint("BOTTOMRIGHT", item.iconbutton, "BOTTOMRIGHT", 0,0)
		item.icon:SetTexture("Interface\\InventoryItems\\WoWUnknownItem01")

		item.name = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		item.name:SetJustifyH("LEFT")
		item.name:SetJustifyV("TOP")
		item.name:SetPoint("TOPLEFT", item.icon, "TOPRIGHT", 3,-1)
		item.name:SetPoint("RIGHT", item, "RIGHT", -5,0)
		item.name:SetText("[None]")

		item.size = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		item.size:SetJustifyH("RIGHT")
		item.size:SetJustifyV("BOTTOM")
		item.size:SetPoint("BOTTOMLEFT", item.icon, "BOTTOMRIGHT", 3,2)
		item.size:SetPoint("RIGHT", item, "RIGHT", -10,0)
		item.size:SetText("25x")

		item.info = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		item.info:SetJustifyH("LEFT")
		item.info:SetJustifyV("BOTTOM")
		item.info:SetPoint("BOTTOMLEFT", item.icon, "BOTTOMRIGHT", 3,2)
		item.info:SetPoint("RIGHT", item, "RIGHT", -10,0)
		item.info:SetText("11/23/55/112")

		item.bg = item:CreateTexture(nil, "ARTWORK")
		item.bg:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
		item.bg:SetPoint("TOPLEFT", item, "TOPLEFT", 0,0)
		item.bg:SetPoint("BOTTOMRIGHT", item, "BOTTOMRIGHT", 0,0)
		item.bg:SetAlpha(0.2)
		item.bg:SetBlendMode("ADD")

		item:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
	end
	local scroller = CreateFrame("Slider", "AucAppraiserItemScroll", frame.itembox)
	scroller:SetPoint("TOPRIGHT", frame.itembox, "TOPRIGHT", -1,-3)
	scroller:SetPoint("BOTTOM", frame.itembox, "BOTTOM", 0,3)
	scroller:SetWidth(20)
	scroller:SetOrientation("VERTICAL")
	scroller:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	scroller:SetMinMaxValues(1, 30)
	scroller:SetValue(1)
	scroller:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	scroller:SetBackdropColor(0, 0, 0, 0.8)
	scroller:SetScript("OnValueChanged", frame.SetScroll)
	frame.scroller = scroller

	frame.itembox:EnableMouseWheel(true)
	frame.itembox:SetScript("OnMouseWheel", function(obj, dir) scroller:SetValue(scroller:GetValue() - dir) frame.SetScroll() end)

	frame.salebox = CreateFrame("Frame", nil, frame)
	frame.salebox:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame.salebox:SetBackdropColor(0, 0, 0, 0.8)
	frame.salebox:SetPoint("TOPLEFT", frame.itembox, "TOPRIGHT", -3,35)
	frame.salebox:SetPoint("RIGHT", frame, "RIGHT", -5,0)
	frame.salebox:SetHeight(170)

	frame.salebox.slot = frame.salebox:CreateTexture(nil, "BORDER")
	frame.salebox.slot:SetPoint("TOPLEFT", frame.salebox, "TOPLEFT", 10, -10)
	frame.salebox.slot:SetWidth(40)
	frame.salebox.slot:SetHeight(40)
	frame.salebox.slot:SetTexCoord(0.15, 0.85, 0.15, 0.85)
	frame.salebox.slot:SetTexture("Interface\\Buttons\\UI-EmptySlot")

	frame.salebox.icon = CreateFrame("Button", nil, frame.salebox)
	frame.salebox.icon:SetPoint("TOPLEFT", frame.salebox.slot, "TOPLEFT", 3, -3)
	frame.salebox.icon:SetWidth(32)
	frame.salebox.icon:SetHeight(32)
	frame.salebox.icon:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square.blp")
	frame.salebox.icon:SetScript("OnClick", frame.IconClicked)
	frame.salebox.icon:SetScript("OnReceiveDrag", frame.IconClicked)
	
	frame.salebox.name = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	frame.salebox.name:SetPoint("TOPLEFT", frame.salebox.slot, "TOPRIGHT", 5,-2)
	frame.salebox.name:SetPoint("RIGHT", frame.salebox, "RIGHT", -15)
	frame.salebox.name:SetHeight(20)
	frame.salebox.name:SetJustifyH("LEFT")
	frame.salebox.name:SetJustifyV("TOP")
	frame.salebox.name:SetText("No item selected")
	frame.salebox.name:SetTextColor(0.5, 0.5, 0.7)

	frame.salebox.info = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.salebox.info:SetPoint("BOTTOMLEFT", frame.salebox.slot, "BOTTOMRIGHT", 5,7)
	frame.salebox.info:SetHeight(20)
	frame.salebox.info:SetJustifyH("LEFT")
	frame.salebox.info:SetJustifyV("BOTTOM")
	frame.salebox.info:SetText("Select an item to the left to begin auctioning...")
	frame.salebox.info:SetTextColor(0.5, 0.5, 0.7)

	frame.salebox.warn = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.warn:SetPoint("BOTTOMLEFT", frame.salebox.slot, "BOTTOMRIGHT", 5,0)
	frame.salebox.warn:SetPoint("RIGHT", frame.salebox, "RIGHT", -10,0)
	frame.salebox.warn:SetHeight(12)
	frame.salebox.warn:SetTextColor(1, 0.3, 0.06)
	frame.salebox.warn:SetText("")
	frame.salebox.warn:SetJustifyH("RIGHT")
	frame.salebox.warn:SetJustifyV("BOTTOM")

	frame.salebox.note = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.note:SetPoint("BOTTOMLEFT", frame.salebox, "BOTTOMLEFT", 0,10)
	frame.salebox.note:SetPoint("RIGHT", frame.salebox, "RIGHT", -10,0)
	frame.salebox.note:SetHeight(12)
	frame.salebox.note:SetTextColor(1, 0.8, 0.1)
	frame.salebox.note:SetText("")
	frame.salebox.note:SetJustifyH("RIGHT")
	frame.salebox.note:SetJustifyV("BOTTOM")

	frame.salebox.stack = CreateFrame("Slider", "AppraiserSaleboxStack", frame.salebox, "OptionsSliderTemplate")
	frame.salebox.stack:SetPoint("TOPLEFT", frame.salebox.slot, "BOTTOMLEFT", 0, -5)
	frame.salebox.stack:SetHitRectInsets(0,0,0,0)
	frame.salebox.stack:SetMinMaxValues(1,20)
	frame.salebox.stack:SetValueStep(1)
	frame.salebox.stack:SetValue(20)
	frame.salebox.stack:SetWidth(255)
	frame.salebox.stack:SetScript("OnValueChanged", frame.UpdateControls)
	frame.salebox.stack.element = "stack"
	frame.salebox.stack:Hide()
	
	frame.salebox.stack:EnableMouseWheel(1)
	frame.salebox.stack:SetScript("OnMouseWheel", function()
		frame.salebox.stack:SetValue(frame.salebox.stack:GetValue() + -arg1)
	end)
	
	AppraiserSaleboxStackLow:SetText("")
	AppraiserSaleboxStackHigh:SetText("")

	frame.salebox.stack.label = frame.salebox.stack:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.stack.label:SetPoint("LEFT", frame.salebox.stack, "RIGHT", 33,2)
	frame.salebox.stack.label:SetJustifyH("LEFT")
	frame.salebox.stack.label:SetJustifyV("CENTER")
	
	frame.salebox.number = CreateFrame("Slider", "AppraiserSaleboxNumber", frame.salebox, "OptionsSliderTemplate")
	frame.salebox.number:SetPoint("TOPLEFT", frame.salebox.stack, "BOTTOMLEFT", 0,0)
	frame.salebox.number:SetHitRectInsets(0,0,0,0)
	frame.salebox.number:SetMinMaxValues(1,1)
	frame.salebox.number:SetValueStep(1)
	frame.salebox.number:SetValue(1)
	frame.salebox.number:SetWidth(255)
	frame.salebox.number:SetScript("OnValueChanged", frame.UpdateControls)
	frame.salebox.number.element = "number"
	frame.salebox.number:Hide()
	AppraiserSaleboxNumberLow:SetText("")
	AppraiserSaleboxNumberHigh:SetText("")

	
	function frame.salebox.number:GetAdjustedValue()
		local maxStax = self.maxStax or 0
		local value = self:GetValue()
		if value > maxStax then
			local extraPos = value - maxStax
			value = self.extra[extraPos]
		end
		return value or 1
	end
	function frame.salebox.number:SetAdjustedValue(value)
		local maxStax = self.maxStax or 0
		if value < 1 or value > maxStax then
			for i = 1, #self.extra do
				if self.extra[i] == value then
					value = maxStax + i
					break
				end
			end
		end
		self:SetValue(value)
	end
	frame.salebox.number.extra = {}
	function frame.salebox.number:SetAdjustedRange(maxStax, ...)
		local curVal = self:GetAdjustedValue()
		self.maxStax = maxStax
		local n = select("#", ...)
		for i = 1, #self.extra do self.extra[i] = nil end
		for i = 1, select("#", ...) do self.extra[i] = select(i, ...) end
		self:SetMinMaxValues(1, maxStax+n)
		self:SetAdjustedValue(math.min(curVal, maxStax))
	end
	
	frame.salebox.number:EnableMouseWheel(1)
	frame.salebox.number:SetScript("OnMouseWheel", function()
		frame.salebox.number:SetValue(frame.salebox.number:GetValue() + -arg1)
	end)
	
	frame.salebox.number.label = frame.salebox.number:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.number.label:SetPoint("LEFT", frame.salebox.number, "RIGHT", 33,2)
	frame.salebox.number.label:SetJustifyH("LEFT")
	frame.salebox.number.label:SetJustifyV("CENTER")

	frame.salebox.duration = CreateFrame("Slider", "AppraiserSaleboxDuration", frame.salebox, "OptionsSliderTemplate")
	frame.salebox.duration:SetPoint("TOPLEFT", frame.salebox.number, "BOTTOMLEFT", 0,0)
	frame.salebox.duration:SetHitRectInsets(0,0,0,0)
	frame.salebox.duration:SetMinMaxValues(1,3)
	frame.salebox.duration:SetValueStep(1)
	frame.salebox.duration:SetValue(3)
	frame.salebox.duration:SetWidth(80)
	frame.salebox.duration:SetScript("OnValueChanged", frame.UpdateControls)
	frame.salebox.duration.element = "duration"
	frame.salebox.duration:Hide()
	AppraiserSaleboxDurationLow:SetText("")
	AppraiserSaleboxDurationHigh:SetText("")

	frame.salebox.duration:EnableMouseWheel(1)
	frame.salebox.duration:SetScript("OnMouseWheel", function()
		frame.salebox.duration:SetValue(frame.salebox.duration:GetValue() + arg1)
	end)
	
	frame.salebox.duration.label = frame.salebox.duration:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.duration.label:SetPoint("LEFT", frame.salebox.duration, "RIGHT", 3,2)
	frame.salebox.duration.label:SetJustifyH("LEFT")
	frame.salebox.duration.label:SetJustifyV("CENTER")

	function frame.GetLinkPriceModels()
		return private.GetExtraPriceModels(frame.salebox.link)
	end
	frame.salebox.model = SelectBox:Create("AppraiserSaleboxModel", frame.salebox, 140, frame.ChangeControls, frame.GetLinkPriceModels, "default")
	frame.salebox.model:SetPoint("TOPLEFT", frame.salebox.duration, "BOTTOMLEFT", 0,-16)
	frame.salebox.model.element = "model"
	frame.salebox.model:Hide()

	frame.salebox.model.label = frame.salebox.model:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.model.label:SetPoint("BOTTOMLEFT", frame.salebox.model, "TOPLEFT", 0,0)
	frame.salebox.model.label:SetText("Pricing model to use:")
	
	frame.salebox.matcher = CreateFrame("CheckButton", "AppraiserSaleboxMatch", frame.salebox, "UICheckButtonTemplate")
	frame.salebox.matcher:SetPoint("TOPLEFT", frame.salebox.model, "BOTTOMLEFT", 22, 7)
	frame.salebox.matcher:SetHeight(20)
	frame.salebox.matcher:SetWidth(20)
	frame.salebox.matcher:SetChecked(false)
	frame.salebox.matcher:SetScript("OnClick", frame.UpdateControls)
	frame.salebox.matcher:Hide()
	
	frame.salebox.matcher.label = frame.salebox.matcher:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.matcher.label:SetPoint("BOTTOMLEFT", frame.salebox.matcher, "BOTTOMRIGHT", 0, 6)
	frame.salebox.matcher.label:SetText("Enable price matching")

	frame.salebox.ignore = CreateFrame("CheckButton", "AppraiserSaleboxIgnore", frame.salebox, "UICheckButtonTemplate")
	frame.salebox.ignore:SetPoint("TOPRIGHT", frame.salebox, "TOPRIGHT", -10, -3)
	frame.salebox.ignore:SetHeight(20)
	frame.salebox.ignore:SetWidth(20)
	frame.salebox.ignore:SetChecked(false)
	frame.salebox.ignore:SetScript("OnClick", frame.IconClicked)
	frame.salebox.ignore:Hide()
	
	frame.salebox.ignore.label = frame.salebox.ignore:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.ignore.label:SetPoint("BOTTOMRIGHT", frame.salebox.ignore, "BOTTOMLEFT", -5, 6)
	frame.salebox.ignore.label:SetText("Hide this item")

	frame.salebox.bulk = CreateFrame("CheckButton", "AppraiserSaleboxBulk", frame.salebox, "UICheckButtonTemplate")
	frame.salebox.bulk:SetPoint("TOPRIGHT", frame.salebox.ignore, "BOTTOMRIGHT", 0, 3)
	frame.salebox.bulk:SetHeight(20)
	frame.salebox.bulk:SetWidth(20)
	frame.salebox.bulk:SetChecked(false)
	frame.salebox.bulk:SetScript("OnClick", frame.UpdateControls)
	frame.salebox.bulk:Hide()
	
	frame.salebox.bulk.label = frame.salebox.bulk:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.bulk.label:SetPoint("BOTTOMRIGHT", frame.salebox.bulk, "BOTTOMLEFT", -5, 6)
	frame.salebox.bulk.label:SetText("Enable batch posting")

	frame.salebox.bid = CreateFrame("Frame", "AppraiserSaleboxBid", frame.salebox, "MoneyInputFrameTemplate")
	frame.salebox.bid:SetPoint("TOP", frame.salebox.number, "BOTTOM", 0,-5)
	frame.salebox.bid:SetPoint("RIGHT", frame.salebox, "RIGHT", 0,0)
	MoneyInputFrame_SetOnvalueChangedFunc(frame.salebox.bid, function()
		if not frame.salebox.buyconfig then
			frame.UpdateControls()
		else
			frame.salebox.buyconfig = nil
		end
	end)
	frame.salebox.bid.element = "bid"
	frame.salebox.bid:Hide()
	AppraiserSaleboxBidGold:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 3, top = 4, bottom = 2}
	})
	AppraiserSaleboxBidGold:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBidSilver:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBidSilver:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBidCopper:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBidCopper:SetBackdropColor(0,0,0, 0)

	frame.salebox.bid.label = frame.salebox.bid:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.bid.label:SetPoint("LEFT", frame.salebox.model, "RIGHT", 5,0)
	frame.salebox.bid.label:SetPoint("TOPRIGHT", frame.salebox.bid, "TOPLEFT", -5,0)
	frame.salebox.bid.label:SetPoint("BOTTOMRIGHT", frame.salebox.bid, "BOTTOMLEFT", -5,0)
	frame.salebox.bid.label:SetText("Bid price/item:")
	frame.salebox.bid.label:SetJustifyH("RIGHT")

	frame.salebox.buy = CreateFrame("Frame", "AppraiserSaleboxBuy", frame.salebox, "MoneyInputFrameTemplate")
	frame.salebox.buy:SetPoint("TOPLEFT", frame.salebox.bid, "BOTTOMLEFT", 0,-5)
	MoneyInputFrame_SetOnvalueChangedFunc(frame.salebox.buy, function()
		if not frame.salebox.buyconfig then
			frame.UpdateControls()
		else
			frame.salebox.buyconfig = nil
		end
	end)
	frame.salebox.buy.element = "buy"
	frame.salebox.buy:Hide()
	AppraiserSaleboxBuyGold:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 3, top = 4, bottom = 2}
	})
	AppraiserSaleboxBuyGold:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBuySilver:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBuySilver:SetBackdropColor(0,0,0, 0)
	AppraiserSaleboxBuyCopper:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile = true, tileSize = 32,
		insets = { left = -2, right = 12, top = 4, bottom = 2}
	})
	AppraiserSaleboxBuyCopper:SetBackdropColor(0,0,0, 0)

	MoneyInputFrame_SetNextFocus(frame.salebox.bid, AppraiserSaleboxBuyGold)
	MoneyInputFrame_SetPreviousFocus(frame.salebox.bid, AppraiserSaleboxBuyCopper)
	MoneyInputFrame_SetNextFocus(frame.salebox.buy, AppraiserSaleboxBidGold)
	MoneyInputFrame_SetPreviousFocus(frame.salebox.buy, AppraiserSaleboxBidCopper)

	frame.salebox.buy.label = frame.salebox.buy:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.buy.label:SetPoint("LEFT", frame.salebox.model, "RIGHT", 5,0)
	frame.salebox.buy.label:SetPoint("TOPRIGHT", frame.salebox.buy, "TOPLEFT", -5,0)
	frame.salebox.buy.label:SetPoint("BOTTOMRIGHT", frame.salebox.buy, "BOTTOMLEFT", -5,0)
	frame.salebox.buy.label:SetText("Buy price/item:")
	frame.salebox.buy.label:SetJustifyH("RIGHT")

	frame.go = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.go:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7,15)
	frame.go:SetText("Post items")
	frame.go:SetWidth(80)
	frame.go:SetScript("OnClick", frame.PostAuctions)
	frame.go.postType = "single"
	frame.go:Disable()

	frame.gobatch = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.gobatch:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -87,15)
	frame.gobatch:SetText("Batch post")
	frame.gobatch:SetWidth(80)
	frame.gobatch:SetScript("OnClick", frame.PostAuctions)
	frame.gobatch.postType = "batch"
	frame.gobatch:Enable()

	frame.refresh = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.refresh:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -167,15)
	frame.refresh:SetText("Refresh")
	frame.refresh:SetWidth(80)
	frame.refresh:SetScript("OnClick", frame.SmartRefresh)

	frame.age = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.age:SetPoint("RIGHT", frame.refresh, "LEFT", -10, 0)
	frame.age:SetTextColor(1, 0.8, 0)
	frame.age:SetText("")
	frame.age:SetJustifyH("RIGHT")
	--frame.age:SetJustifyV("BOTTOM")
	
	frame.cancel = CreateFrame("Button", "AucAdvAppraiserCancelButton", frame, "OptionsButtonTemplate")
	frame.cancel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 180, 15)
	frame.cancel:SetWidth(22)
	frame.cancel:SetHeight(18)
	frame.cancel:Disable()
	frame.cancel:SetScript("OnClick", function()
		AucAdvanced.Post.Private.postRequests = {}
	end)
	frame.cancel:RegisterEvent("AUCTION_OWNED_LIST_UPDATE")
	frame.cancel:SetScript("OnUpdate", function()
		local postnum = #AucAdvanced.Post.Private.postRequests
		frame.cancel.label:SetText(tostring(postnum))
		if postnum > 0 then
			frame.cancel:Enable()
			frame.cancel.tex:SetVertexColor(1.0, 0.9, 0.1)
		else
			frame.cancel:Disable()
			frame.cancel.tex:SetVertexColor(0.3,0.3,0.3)
		end
        -- piggyback update of auction details
        AucAdvanced.Modules.Util.Appraiser.GetOwnAuctionDetails()
	end)
	frame.cancel.tex = frame.cancel:CreateTexture(nil, "OVERLAY")
	frame.cancel.tex:SetPoint("TOPLEFT", frame.cancel, "TOPLEFT", 4, -2)
	frame.cancel.tex:SetPoint("BOTTOMRIGHT", frame.cancel, "BOTTOMRIGHT", -4, 2)
	frame.cancel.tex:SetTexture("Interface\\Addons\\Auc-Advanced\\Textures\\NavButtons")
	frame.cancel.tex:SetTexCoord(0.25, 0.5, 0, 1)
	frame.cancel.tex:SetVertexColor(1.0, 0.9, 0.1)
	
	frame.cancel.label = frame.cancel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.cancel.label:SetPoint("LEFT", frame.cancel, "RIGHT", 5, 0)
	frame.cancel.label:SetTextColor(1, 0.8, 0)
	frame.cancel.label:SetText("")
	frame.cancel.label:SetJustifyH("LEFT")

	frame.manifest = CreateFrame("Frame", nil, frame)
	frame.manifest:SetBackdrop({
		bgFile = "Interface\\Tooltips\\ChatBubble-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame.manifest:SetBackdropColor(0, 0, 0, 1)
	frame.manifest:SetPoint("TOPLEFT", frame, "TOPRIGHT", -20,-30)
	frame.manifest:SetPoint("BOTTOM", frame, "BOTTOM", 0,30)
	frame.manifest:SetWidth(230)
	frame.manifest:SetFrameStrata("MEDIUM")
	frame.manifest:SetFrameLevel(AuctionFrame:GetFrameLevel())
	frame.manifest:Hide()

	frame.manifest.close = CreateFrame("Button", nil, frame.manifest)
	frame.manifest.close:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	frame.manifest.close:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
	frame.manifest.close:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	frame.manifest.close:SetDisabledTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Disabled")
	frame.manifest.close:SetPoint("TOPRIGHT", frame.manifest, "TOPRIGHT", 0,0)
	frame.manifest.close:SetWidth(26)
	frame.manifest.close:SetHeight(26)
	frame.manifest.close:SetScript("OnClick", function()
		frame.manifest:Hide()
		frame.toggleManifest:SetText("Open Sidebar")
	end)

	local function lineHide(obj)
		local id = obj.id
		local line = frame.manifest.lines[id]
		line[1]:Hide()
		line[2]:Hide()
	end

	local function lineSet(obj, text, coins, r,g,b)
		local id = obj.id
		local line = frame.manifest.lines[id]
		line[1]:SetText(text)
		if r and g and b then
			line[1]:SetTextColor(r,g,b)
		else
			line[1]:SetTextColor(1,1,1)
		end
		line[1]:Show()
		line[2]:Show()

		local zero = false
		local money = 0
		if coins then
			money = math.floor(tonumber(coins) or 0)
			if money == 0 then zero = true end
		end
		TinyMoneyFrame_Update(line[2], money)
		if zero then
			getglobal("AppraisalManifestCoins"..id.."CopperButton"):Show()
		end
	end

	local function lineReset(obj, text, coins)
		local id = obj.id
		local line = frame.manifest.lines[id]
		line[1]:SetText("")
		TinyMoneyFrame_Update(line[2], 0)
	end

	local function linesClear(obj)
		obj.pos = 0
		for i = 1, obj.max do
			obj[i]:Hide()
		end
	end

	local function linesAdd(obj, text, coins, r,g,b)
		obj.pos = obj.pos + 1
		if (obj.pos > obj.max) then return end
		obj[obj.pos]:Set(text, coins, r,g,b)
	end


	local myStrata = frame.manifest:GetFrameStrata()

	frame.manifest.header = frame.manifest:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.manifest.header:SetPoint("TOPLEFT", frame.manifest, "TOPLEFT", 24, -5)
	frame.manifest.header:SetPoint("RIGHT", frame.manifest, "RIGHT", 0,0)
	frame.manifest.header:SetJustifyH("LEFT")
	frame.manifest.header:SetText("Auction detail:")

	local lines = { pos = 0, max = 40, Clear = linesClear, Add = linesAdd }
	for i=1, lines.max do
		local text = frame.manifest:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		if i == 1 then
			text:SetPoint("TOPLEFT", frame.manifest, "TOPLEFT", 26,-18)
		else
			text:SetPoint("TOPLEFT", lines[i-1][1], "BOTTOMLEFT", 0,0)
		end
		text:SetPoint("RIGHT", frame.manifest, "RIGHT", 0,0)
		text:SetJustifyH("LEFT")
		text:SetHeight(9)

		local coins = CreateFrame("Frame", "AppraisalManifestCoins"..i, frame.manifest, "EnhancedTooltipMoneyTemplate")
		coins:SetPoint("RIGHT", text, "RIGHT", 0,0)
		coins:SetFrameStrata(myStrata)
		coins.info.showSmallerCoins = "backpack"
		coins:SetScale(0.85)

		local line = { text, coins, id = i, Hide = lineHide, Set = lineSet, Reset = lineReset }
		lines[i] = line
	end
	frame.manifest.lines = lines

	frame.imageview = CreateFrame("Frame", nil, frame)
	frame.imageview:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame.imageview:SetBackdropColor(0, 0, 0, 0.8)
	frame.imageview:SetPoint("TOPLEFT", frame.salebox, "BOTTOMLEFT")
	frame.imageview:SetPoint("TOPRIGHT", frame.salebox, "BOTTOMRIGHT")
	frame.imageview:SetPoint("BOTTOM", frame.itembox, "BOTTOM", 0, 20)
	
	--records the column width changes
	--store width by header name, that way if column reorginizing is added we apply size to proper column
	function private.onResize(self, column, width)
		if not width then 
			AucAdvanced.Settings.SetSetting("util.appraiser.columnwidth."..self.labels[column]:GetText(), "default") --reset column if no width is passed. We use CTRL+rightclick to reset column
			self.labels[column].button:SetWidth(AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth."..self.labels[column]:GetText()))
		else
			AucAdvanced.Settings.SetSetting("util.appraiser.columnwidth."..self.labels[column]:GetText(), width)
		end
	end
	
	function private.BuyAuction()
		print(private.buyselection.link)
		AucAdvanced.Buy.QueueBuy(private.buyselection.link, private.buyselection.seller, private.buyselection.stack, private.buyselection.minbid, private.buyselection.buyout, private.buyselection.buyout)
		frame.imageview.sheet.selected = nil
		frame.imageviewclassic.sheet.selected = nil
		private.onSelect()
		private.onClassicSelect()
	end
	function private.BidAuction()
		local bid = private.buyselection.minbid
		if private.buyselection.curbid and private.buyselection.curbid > 0 then
			bid = math.ceil(private.buyselection.curbid*1.05)
		end
		AucAdvanced.Buy.QueueBuy(private.buyselection.link, private.buyselection.seller, private.buyselection.stack, private.buyselection.minbid, private.buyselection.buyout, bid)
		frame.imageview.sheet.selected = nil
		frame.imageviewclassic.sheet.selected = nil
		private.onSelect()
		private.onClassicSelect()
	end
	
	private.buyselection = {}
	function private.onSelect()
		if frame.imageview.sheet.selected and frame.imageviewclassic.sheet.selected then
			frame.imageviewclassic.sheet.selected = nil
			private.onClassicSelect()
		end
		if frame.imageview.sheet.prevselected ~= frame.imageview.sheet.selected then
			frame.imageview.sheet.prevselected = frame.imageview.sheet.selected
			local selected = frame.imageview.sheet:GetSelection()
			if not selected then
				private.buyselection = {}
			else
				private.buyselection.link = selected[11]
				private.buyselection.seller = selected[2]
				private.buyselection.stack = selected[4]
				private.buyselection.minbid = selected[8]
				private.buyselection.curbid = selected[9]
				private.buyselection.buyout = selected[10]
			end
			if private.buyselection.buyout and (private.buyselection.buyout > 0) then
				frame.imageview.purchase.buy:Enable()
				frame.imageview.purchase.buy.price:SetText(EnhTooltip.GetTextGSC(private.buyselection.buyout, true))
			else
				frame.imageview.purchase.buy:Disable()
				frame.imageview.purchase.buy.price:SetText("")
			end
			
			if private.buyselection.minbid then
				if private.buyselection.curbid and private.buyselection.curbid > 0 then
					frame.imageview.purchase.bid.price:SetText(EnhTooltip.GetTextGSC(math.ceil(private.buyselection.curbid*1.05), true))
				else
					frame.imageview.purchase.bid.price:SetText(EnhTooltip.GetTextGSC(private.buyselection.minbid, true))
				end
				frame.imageview.purchase.bid:Enable()
			else
				frame.imageview.purchase.bid:Disable()
				frame.imageview.purchase.bid.price:SetText("")
			end
		end
	end
	
	frame.imageview.sheet = ScrollSheet:Create(frame.imageview, {
		{ "Item",   "TEXT", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Item")}, -- Default width 105
		{ "Seller", "TEXT", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Seller")}, --75
		{ "Left",   "INT",  AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Left")}, --40
		{ "Stk",    "INT",  AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Stk")}, --30
		{ "Min/ea", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Min/ea"), { DESCENDING=true } }, --85
		{ "Cur/ea", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Cur/ea"), { DESCENDING=true } }, --85
		{ "Buy/ea", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Buy/ea"), { DESCENDING=true, DEFAULT=true } }, --85
		{ "MinBid", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.MinBid"), { DESCENDING=true } }, --85
		{ "CurBid", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.CurBid"), { DESCENDING=true } }, --85
		{ "Buyout", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Buyout"), { DESCENDING=true } }, --85
		{ "", "TEXT", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.BLANK")}, --Hidden column to carry the link --0
	}, nil, nil, nil, private.onResize, private.onSelect)
	frame.imageview.sheet:EnableSelect(true)
	
	frame.imageview.purchase = CreateFrame("Frame", nil, frame.imageview)
	frame.imageview.purchase:SetPoint("TOPLEFT", frame.imageview, "BOTTOMLEFT", 0, 4)
	frame.imageview.purchase:SetPoint("BOTTOMRIGHT", frame.imageview, "BOTTOMRIGHT", 0, -16)
	frame.imageview.purchase:SetBackdrop({
		bgFile = "Interface\\QuestFrame\\UI-QuestTitleHighlight"
	})
	frame.imageview.purchase:SetBackdropColor(0.5, 0.5, 0.5, 1)

	frame.imageview.purchase.buy = CreateFrame("Button", nil, frame.imageview.purchase, "OptionsButtonTemplate")
	frame.imageview.purchase.buy:SetPoint("TOPLEFT", frame.imageview.purchase, "TOPLEFT", 5, 0)
	frame.imageview.purchase.buy:SetWidth(30)
	frame.imageview.purchase.buy:SetText("Buy")
	frame.imageview.purchase.buy:SetScript("OnClick", private.BuyAuction)
	frame.imageview.purchase.buy:Disable()
	
	frame.imageview.purchase.buy.price = frame.imageview.purchase.buy:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.imageview.purchase.buy.price:SetPoint("TOPLEFT", frame.imageview.purchase.buy, "TOPRIGHT")
	frame.imageview.purchase.buy.price:SetPoint("BOTTOMLEFT", frame.imageview.purchase.buy, "BOTTOMRIGHT")
	frame.imageview.purchase.buy.price:SetJustifyV("MIDDLE")
	
	frame.imageview.purchase.bid = CreateFrame("Button", nil, frame.imageview.purchase, "OptionsButtonTemplate")
	frame.imageview.purchase.bid:SetPoint("TOPLEFT", frame.imageview.purchase.buy, "TOPLEFT", 120, 0)
	frame.imageview.purchase.bid:SetWidth(30)
	frame.imageview.purchase.bid:SetText("Bid")
	frame.imageview.purchase.bid:SetScript("OnClick", private.BidAuction)
	frame.imageview.purchase.bid:Disable()
	
	frame.imageview.purchase.bid.price = frame.imageview.purchase.bid:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.imageview.purchase.bid.price:SetPoint("TOPLEFT", frame.imageview.purchase.bid, "TOPRIGHT")
	frame.imageview.purchase.bid.price:SetPoint("BOTTOMLEFT", frame.imageview.purchase.bid, "BOTTOMRIGHT")
	frame.imageview.purchase.bid.price:SetJustifyV("MIDDLE")
	
	frame.imageviewclassic = CreateFrame("Frame", nil, frame)
	frame.imageviewclassic:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	
	function private.onClassicSelect()
		if frame.imageviewclassic.sheet.selected and frame.imageview.sheet.selected then
			frame.imageview.sheet.selected = nil
			private.onSelect()
		end
		if frame.imageviewclassic.sheet.prevselected ~= frame.imageviewclassic.sheet.selected then
			frame.imageviewclassic.sheet.prevselected = frame.imageviewclassic.sheet.selected
			local selected = frame.imageviewclassic.sheet:GetSelection()
			if not selected then
				private.buyselection = {}
			else
				private.buyselection.link = selected[11]
				private.buyselection.seller = selected[2]
				private.buyselection.stack = selected[4]
				private.buyselection.minbid = selected[8]
				private.buyselection.curbid = selected[9]
				private.buyselection.buyout = selected[10]
			end
			if private.buyselection.buyout and (private.buyselection.buyout > 0) then
				frame.imageviewclassic.purchase.buy:Enable()
				frame.imageviewclassic.purchase.buy.price:SetText(EnhTooltip.GetTextGSC(private.buyselection.buyout, true))
			else
				frame.imageviewclassic.purchase.buy:Disable()
				frame.imageviewclassic.purchase.buy.price:SetText("")
			end
			
			if private.buyselection.minbid then
				if private.buyselection.curbid and private.buyselection.curbid > 0 then
					frame.imageviewclassic.purchase.bid.price:SetText(EnhTooltip.GetTextGSC(math.ceil(private.buyselection.curbid*1.05), true))
				else
					frame.imageviewclassic.purchase.bid.price:SetText(EnhTooltip.GetTextGSC(private.buyselection.minbid, true))
				end
				frame.imageviewclassic.purchase.bid:Enable()
			else
				frame.imageviewclassic.purchase.bid:Disable()
				frame.imageviewclassic.purchase.bid.price:SetText("")
			end
		end
	end
	
	frame.imageviewclassic:SetBackdropColor(0, 0, 0, 1)
	frame.imageviewclassic:SetPoint("TOPLEFT", frame.itembox, "TOPRIGHT", -3, 35)
	frame.imageviewclassic:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, 0)
	frame.imageviewclassic:SetPoint("BOTTOM", frame.itembox, "BOTTOM", 0, 20)
	frame.imageviewclassic.sheet = ScrollSheet:Create(frame.imageviewclassic, {
		{ "Item",   "TEXT", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Item")}, -- Default width 105
		{ "Seller", "TEXT", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Seller")}, --75
		{ "Left",   "INT",  AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Left")}, --40
		{ "Stk",    "INT",  AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Stk")}, --30
		{ "Min/ea", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Min/ea"), { DESCENDING=true } }, --85
		{ "Cur/ea", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Cur/ea"), { DESCENDING=true } }, --85
		{ "Buy/ea", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Buy/ea"), { DESCENDING=true, DEFAULT=true } }, --85
		{ "MinBid", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.MinBid"), { DESCENDING=true } }, --85
		{ "CurBid", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.CurBid"), { DESCENDING=true } }, --85
		{ "Buyout", "COIN", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.Buyout"), { DESCENDING=true } }, --85
		{ "", "TEXT", AucAdvanced.Settings.GetSetting("util.appraiser.columnwidth.BLANK")}, --Hidden column to carry the link --0
	}, nil, nil, nil, private.onResize, private.onClassicSelect)
	frame.imageviewclassic.sheet:EnableSelect(true)
	frame.imageviewclassic:Hide()

	frame.imageviewclassic.purchase = CreateFrame("Frame", nil, frame.imageviewclassic)
	frame.imageviewclassic.purchase:SetPoint("TOPLEFT", frame.imageviewclassic, "BOTTOMLEFT", 0, 4)
	frame.imageviewclassic.purchase:SetPoint("BOTTOMRIGHT", frame.imageviewclassic, "BOTTOMRIGHT", 0, -16)
	frame.imageviewclassic.purchase:SetBackdrop({
		bgFile = "Interface\\QuestFrame\\UI-QuestTitleHighlight"		
	})
	frame.imageviewclassic.purchase:SetBackdropColor(0.5, 0.5, 0.5, 1)

	frame.imageviewclassic.purchase.buy = CreateFrame("Button", nil, frame.imageviewclassic.purchase, "OptionsButtonTemplate")
	frame.imageviewclassic.purchase.buy:SetPoint("TOPLEFT", frame.imageviewclassic.purchase, "TOPLEFT", 5, 0)
	frame.imageviewclassic.purchase.buy:SetWidth(30)
	frame.imageviewclassic.purchase.buy:SetText("Buy")
	frame.imageviewclassic.purchase.buy:SetScript("OnClick", private.BuyAuction)
	frame.imageviewclassic.purchase.buy:Disable()
	
	frame.imageviewclassic.purchase.buy.price = frame.imageviewclassic.purchase.buy:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.imageviewclassic.purchase.buy.price:SetPoint("TOPLEFT", frame.imageviewclassic.purchase.buy, "TOPRIGHT")
	frame.imageviewclassic.purchase.buy.price:SetPoint("BOTTOMLEFT", frame.imageviewclassic.purchase.buy, "BOTTOMRIGHT")
	frame.imageviewclassic.purchase.buy.price:SetJustifyV("MIDDLE")
	
	frame.imageviewclassic.purchase.bid = CreateFrame("Button", nil, frame.imageviewclassic.purchase, "OptionsButtonTemplate")
	frame.imageviewclassic.purchase.bid:SetPoint("TOPLEFT", frame.imageviewclassic.purchase.buy, "TOPLEFT", 120, 0)
	frame.imageviewclassic.purchase.bid:SetWidth(30)
	frame.imageviewclassic.purchase.bid:SetText("Bid")
	frame.imageviewclassic.purchase.bid:SetScript("OnClick", private.BidAuction)
	frame.imageviewclassic.purchase.bid:Disable()
	
	frame.imageviewclassic.purchase.bid.price = frame.imageviewclassic.purchase.bid:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.imageviewclassic.purchase.bid.price:SetPoint("TOPLEFT", frame.imageviewclassic.purchase.bid, "TOPRIGHT")
	frame.imageviewclassic.purchase.bid.price:SetPoint("BOTTOMLEFT", frame.imageviewclassic.purchase.bid, "BOTTOMRIGHT")
	frame.imageviewclassic.purchase.bid.price:SetJustifyV("MIDDLE")

	frame.ScanTab = CreateFrame("Button", "AuctionFrameTabUtilAppraiser", AuctionFrame, "AuctionTabTemplate")
	frame.ScanTab:SetText("Appraiser")
	frame.ScanTab:Show()
	PanelTemplates_DeselectTab(frame.ScanTab)
	AucAdvanced.AddTab(frame.ScanTab, frame)

	function frame.ScanTab.OnClick(_, _, index)
		if not index then index = this:GetID() end
		local tab = getglobal("AuctionFrameTab"..index)
		if (tab and tab:GetName() == "AuctionFrameTabUtilAppraiser") then
			AuctionFrameTopLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-TopLeft")
			AuctionFrameTop:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-Top")
			AuctionFrameTopRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-TopRight")
			AuctionFrameBotLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotLeft")
			AuctionFrameBot:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-Bot")
			AuctionFrameBotRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotRight")
			AuctionFrameMoneyFrame:Hide()
			if (AuctionDressUpFrame:IsVisible()) then
				AuctionDressUpFrame:Hide()
				AuctionDressUpFrame.reshow = true
			end
			frame:Show()
			AucAdvanced.Scan.GetImage()
			frame.GenerateList(true)
		else
			if (AuctionDressUpFrame.reshow) then
				AuctionDressUpFrame:Show()
				AuctionDressUpFrame.reshow = nil
			end
			AuctionFrameMoneyFrame:Show()
			frame:Hide()
		end
	end
	
	frame.salebox.numberentry = CreateFrame("EditBox", "AppraiserSaleboxNumberEntry", frame.salebox, "InputBoxTemplate")
	frame.salebox.numberentry:SetPoint("TOPLEFT", frame.salebox.duration, "BOTTOMLEFT", 20, -5)
	frame.salebox.numberentry:SetNumeric(false)
	frame.salebox.numberentry:SetHeight(16)
	frame.salebox.numberentry:SetWidth(30)
	frame.salebox.numberentry:SetNumber(0)
	frame.salebox.numberentry:SetAutoFocus(false)
	frame.salebox.numberentry:SetScript("OnEnterPressed", function()
		local text = frame.salebox.numberentry:GetText()
		if (text:lower() == "full") then
			frame.salebox.numberentry:SetNumber(-2)
		elseif (text:lower() == "all") then
			frame.salebox.numberentry:SetNumber(-1)
		end
		frame.salebox.number:SetAdjustedValue(frame.salebox.numberentry:GetNumber())
		frame.salebox.numberentry:ClearFocus()
		frame.UpdateControls()
	end)
	frame.salebox.numberentry:SetScript("OnTabPressed", function()
		local text = frame.salebox.numberentry:GetText()
		if (text:lower() == "full") then
			frame.salebox.numberentry:SetNumber(-2)
		elseif (text:lower() == "all") then
			frame.salebox.numberentry:SetNumber(-1)
		end
		frame.salebox.number:SetAdjustedValue(frame.salebox.numberentry:GetNumber())
		frame.salebox.stackentry:SetFocus()
		frame.UpdateControls()
	end)
	frame.salebox.numberentry:SetScript("OnTextChanged", function()
		local text = frame.salebox.numberentry:GetText()
		if text ~= "" then
			if (text:lower() == "full") then
				if (frame.salebox.stacksize > 1) then
					frame.salebox.numberentry:SetText("Full")
					frame.salebox.number:SetAdjustedValue(-2)
				else
					frame.salebox.numberentry:SetText("All")
					frame.salebox.number:SetAdjustedValue(-1)
				end
			elseif (text:lower() == "all") then
				frame.salebox.numberentry:SetText("All")
				frame.salebox.number:SetAdjustedValue(-1)
			else
				if frame.salebox.numberentry:GetNumber() ~= 0 or frame.salebox.numberentry:GetText() == "0" then
					frame.salebox.number:SetAdjustedValue(frame.salebox.numberentry:GetNumber())
					frame.UpdateControls()
				end
			end
		end
		--frame.UpdateControls()
	end)
	frame.salebox.numberentry:SetScript("OnEscapePressed", function()
		frame.salebox.numberentry:ClearFocus()
	end)
	frame.salebox.numberentry:Hide()
	
	frame.salebox.stacksoflabel = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.stacksoflabel:SetPoint("TOPLEFT", frame.salebox.numberentry, "TOPRIGHT", 5, 0)
	frame.salebox.stacksoflabel:SetJustifyH("LEFT")
	frame.salebox.stacksoflabel:SetJustifyV("CENTER")
	frame.salebox.stacksoflabel:SetText("stacks of")
	frame.salebox.stacksoflabel:Hide()
	
	frame.salebox.stackentry = CreateFrame("EditBox", "AppraiserSaleboxStackEntry", frame.salebox, "InputBoxTemplate")
	frame.salebox.stackentry:SetPoint("TOPLEFT", frame.salebox.stacksoflabel, "TOPRIGHT", 5, 0)
	frame.salebox.stackentry:SetNumeric(true)
	frame.salebox.stackentry:SetNumber(0)
	frame.salebox.stackentry:SetHeight(16)
	frame.salebox.stackentry:SetWidth(30)
	frame.salebox.stackentry:SetAutoFocus(false)
	frame.salebox.stackentry:SetScript("OnEnterPressed", function()
		frame.salebox.stack:SetValue(frame.salebox.stackentry:GetNumber())
		frame.salebox.stackentry:ClearFocus()
		frame.UpdateControls()
	end)
	frame.salebox.stackentry:SetScript("OnTabPressed", function()
		frame.salebox.stack:SetValue(frame.salebox.stackentry:GetNumber())
		frame.salebox.numberentry:SetFocus()
		frame.UpdateControls()
	end)
	frame.salebox.stackentry:SetScript("OnTextChanged", function()
		local text = frame.salebox.stackentry:GetText()
		if text ~= "" then
			frame.salebox.stack:SetValue(frame.salebox.stackentry:GetNumber())
			frame.UpdateControls()
		end
	end)
	frame.salebox.stackentry:SetScript("OnEscapePressed", function()
		frame.salebox.stackentry:ClearFocus()
	end)
	frame.salebox.stackentry:Hide()
	
	frame.salebox.totalsize = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.totalsize:SetPoint("TOPLEFT", frame.salebox.stackentry, "TOPRIGHT", 3, 0)
	frame.salebox.totalsize:SetJustifyH("LEFT")
	frame.salebox.totalsize:SetJustifyV("CENTER")
	frame.salebox.totalsize:SetText("()")
	frame.salebox.totalsize:Hide()
	
	frame.salebox.depositcost = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.depositcost:SetPoint("TOPLEFT", frame.salebox.numberentry, "BOTTOMLEFT", -15, -5)
	frame.salebox.depositcost:SetJustifyH("LEFT")
	frame.salebox.depositcost:SetJustifyV("CENTER")
	frame.salebox.depositcost:Hide()
	frame.salebox.totalbid = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.totalbid:SetPoint("TOPLEFT", frame.salebox.depositcost, "BOTTOMLEFT", 0, 0)
	frame.salebox.totalbid:SetJustifyH("LEFT")
	frame.salebox.totalbid:SetJustifyV("CENTER")
	frame.salebox.totalbid:Hide()
	frame.salebox.totalbuyout = frame.salebox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.salebox.totalbuyout:SetPoint("TOPLEFT", frame.salebox.totalbid, "BOTTOMLEFT", 0, 0)
	frame.salebox.totalbuyout:SetJustifyH("LEFT")
	frame.salebox.totalbuyout:SetJustifyV("CENTER")
	frame.salebox.totalbuyout:Hide()
	
	Stubby.RegisterFunctionHook("ContainerFrameItemButton_OnModifiedClick", -300, frame.ClickBagHook)
	frame.ChangeUI()
	hooksecurefunc("AuctionFrameTab_OnClick", frame.ScanTab.OnClick)
end

AucAdvanced.RegisterRevision("$URL$", "$Rev$")
