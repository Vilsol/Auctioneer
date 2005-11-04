--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: <%version%>
	Revision: $Id$

	Auctioneer scanning functions
	Functions to handle the auction scan procedure
]]


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


-- This function sets the dirty flag to true for all the auctions in the snapshot
-- This is done to indicate that the snapshot is out of date.
function Auctioneer_InvalidateAHSnapshot()
	-- Invalidate the snapshot
	local auctKey = Auctioneer_GetAuctionKey();
	if (not AuctionConfig.snap) then
		AuctionConfig.snap = {};
	end
	if (not AuctionConfig.snap[auctKey]) then
		AuctionConfig.snap[auctKey] = {};
	end
	for cat,cData in pairs(AuctionConfig.snap[auctKey]) do
		-- Only invalidate the class group if we will be scanning it.
		if (Auctioneer_GetFilter("scan-class"..cat)) then
			for iKey, iData in pairs(cData) do
				-- The first char is the dirty flag (purposely)
				AuctionConfig.snap[auctKey][cat][iKey] = "1" .. string.sub(iData,2);
			end
		end
	end
end

-- Called when the auction scan starts
function Auctioneer_AuctionStart_Hook()
	Auction_DoneItems = {};
	lSnapshotItemPrices = {};
	Auctioneer_InvalidateAHSnapshot();

	-- Make sure AuctionConfig.data is initialized
	local serverFaction = Auctioneer_GetAuctionKey();
	if (AuctionConfig.data == nil) then AuctionConfig.data = {}; end
	if (AuctionConfig.data[serverFaction] == nil) then
		AuctionConfig.data[serverFaction] = {};
	end

	-- Reset scan audit counters
	lTotalAuctionsScannedCount = 0;
	lNewAuctionsCount = 0;
	lOldAuctionsCount = 0;
	lDefunctAuctionsCount = 0;
	
	-- Protect AuctionFrame if we should
	if (Auctioneer_GetFilterVal('protect-window') == 1) then
		Auctioneer_ProtectAuctionFrame(true);
	end
end

-- This is called when an auction scan finishes and is used for clean up
function Auctioneer_FinishedAuctionScan_Hook()
	-- Only remove defunct auctions from snapshot if there was a good amount of auctions scanned.
	local auctKey = Auctioneer_GetAuctionKey();

	local endTime = time();
	if lTotalAuctionsScannedCount >= 50 then 
		local dropCount, buyCount, bidCount, expCount;
		dropCount = 0;
		buyCount = 0;
		bidCount = 0;
		expCount = 0;
		local snap,lastSeen,expiredSeconds,itemKey,buyList,listStr,listSplit,buyout,hist;
		if (AuctionConfig and AuctionConfig.snap and AuctionConfig.snap[auctKey]) then
			for cat,cData in pairs(AuctionConfig.snap[auctKey]) do
				for iKey, iData in pairs(cData) do
					snap = Auctioneer_GetSnapshotFromData(iData);
					if (snap.dirty == "1") then
						-- This item should have been seen, but wasn't.
						-- We need to work out if it expired before or after it's time
						lastSeen = snap.lastSeenTime;
						expiredSeconds = endTime - lastSeen;
						if (snap.timeLeft == 1) and (snap.bidamount > 0) then
							bidCount = bidCount+1;
							-- This one expired at the final time interval, so it's likely
							-- that this is the best bid value we'll get for it.
							itemKey = Auctioneer_GetKeyFromSig(iKey);
							if (not AuctionConfig.success) then AuctionConfig.success = {} end
							if (not AuctionConfig.success.bid) then AuctionConfig.success.bid = {} end
							if (not AuctionConfig.success.bid[auctKey]) then AuctionConfig.success.bid[auctKey] = {} end
							bidList = newBalancedList(lMaxBuyoutHistorySize);
							bidList.setList(Auctioneer_LoadMedianList(AuctionConfig.success.bid[auctKey][itemKey]));
							bidList.insert(snap.bidamount);
							AuctionConfig.success.bid[auctKey][itemKey] = Auctioneer_StoreMedianList (bidList.getList());
						elseif (expiredSeconds < TIME_LEFT_SECONDS[snap.timeLeft]) then
							-- Whoa! This item was bought out.
							itemKey = Auctioneer_GetKeyFromSig(iKey);
							if (not AuctionConfig.success) then AuctionConfig.success = {} end

							x,x,x,x,x,x,buyout = Auctioneer_GetItemSignature(iKey);
							if (buyout > 0) then
								buyCount = buyCount+1;
								if (not AuctionConfig.success.buy) then AuctionConfig.success.buy = {} end
								if (not AuctionConfig.success.buy[auctKey]) then AuctionConfig.success.buy[auctKey] = {} end
								buyList = newBalancedList(lMaxBuyoutHistorySize);
								buyList.setList(Auctioneer_LoadMedianList(AuctionConfig.success.buy[auctKey][itemKey]));
								buyList.insert(buyout);
								AuctionConfig.success.buy[auctKey][itemKey] = Auctioneer_StoreMedianList (buyList.getList());
							else
								if (not AuctionConfig.success.drop) then AuctionConfig.success.drop = {} end
								if (not AuctionConfig.success.drop[auctKey]) then AuctionConfig.success.drop[auctKey] = {} end
								local cancelCount = tonumber(AuctionConfig.success.drop[auctKey][itemKey]) or 0
								AuctionConfig.success.drop[auctKey][itemKey] = cancelCount + 1;
								dropCount = dropCount + 1;
							end
						else
							expCount = expCount+1;
						end
					end
						
					if (string.sub(iData, 1,1) == "1") then
						AuctionConfig.snap[auctKey][cat][iKey] = nil; --clear defunct auctions
						lDefunctAuctionsCount = lDefunctAuctionsCount + 1;
					end
				end
			end
		end
		EnhTooltip.DebugPrint("Final counts", dropCount, buyCount, bidCount, expCount);
	end

	if (not AuctionConfig.sbuy) then AuctionConfig.sbuy = {}; end
	if (not AuctionConfig.sbuy[auctKey]) then AuctionConfig.sbuy[auctKey] = {}; end

	-- Copy the item prices into the Saved item prices table
	if (lSnapshotItemPrices) then
		for sig, iData in pairs(lSnapshotItemPrices) do
			AuctionConfig.sbuy[auctKey][sig] = Auctioneer_StoreMedianList(iData.buyoutPrices);
			lSnapshotItemPrices[sig] = nil;
		end
	end

	local lDiscrepencyCount = lTotalAuctionsScannedCount - (lNewAuctionsCount + lOldAuctionsCount);

	Auctioneer_ChatPrint(string.format(_AUCT['AuctionTotalAucts'], Auctioneer_ColorTextWhite(lTotalAuctionsScannedCount)));
	Auctioneer_ChatPrint(string.format(_AUCT['AuctionNewAucts'], Auctioneer_ColorTextWhite(lNewAuctionsCount)));
	Auctioneer_ChatPrint(string.format(_AUCT['AuctionOldAucts'], Auctioneer_ColorTextWhite(lOldAuctionsCount)));
	Auctioneer_ChatPrint(string.format(_AUCT['AuctionDefunctAucts'], Auctioneer_ColorTextWhite(lDefunctAuctionsCount)));

	if (nullSafe(lDiscrepencyCount) > 0) then
		Auctioneer_ChatPrint(string.format(_AUCT['AuctionDiscrepancies'], Auctioneer_ColorTextWhite(lDiscrepencyCount)));
	end
end

-- Called by scanning hook when an auction item is scanned from the Auction house
-- we save the aution item to our tables, increment our counts etc
function Auctioneer_AuctionEntry_Hook(funcVars, retVal, page, index, category)
	EnhTooltip.DebugPrint("Processing page", page, "item", index);
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
	if (aiOwner == nil) then aiOwner = "unknown"; end

	-- do some validation of the auction data that was returned
	if (aiName == nil or tonumber(aiBuyoutPrice) > MAX_ALLOWED_FORMAT_INT or tonumber(aiMinBid) > MAX_ALLOWED_FORMAT_INT) then return; end
	if (aiCount < 1) then aiCount = 1; end

	-- get other auctiondata
	local aiTimeLeft = GetAuctionItemTimeLeft("list", index);
	local aiLink = GetAuctionItemLink("list", index);

	-- Call some interested iteminfo addons
	Auctioneer_ProcessLink(aiLink);
	
	local aiItemID, aiRandomProp, aiEnchant, aiUniqID = EnhTooltip.BreakLink(aiLink);
	local aiKey = aiItemID..":"..aiRandomProp..":"..aiEnchant;
	local hyperlink = string.format("item:%d:%d:%d:%d", aiItemID, aiEnchant, aiRandomProp, aiUniqID);

	-- Get all item data
	local iName, iLink, iQuality, iLevel, iClass, iSubClass, iCount, iMaxStack = GetItemInfo(hyperlink);
	local itemCat = Auctioneer_GetCatNumberByName(iClass);
	
	-- construct the unique auction signature for this aution
	local lAuctionSignature = string.format("%d:%d:%d:%s:%d:%d:%d:%d", aiItemID, aiRandomProp, aiEnchant, nilSafeString(aiName), nullSafe(aiCount), nullSafe(aiMinBid), nullSafe(aiBuyoutPrice), aiUniqID);

	-- add this item's buyout price to the buyout price history for this item in the snapshot
	if aiBuyoutPrice > 0 then
		local buyoutPriceForOne = (aiBuyoutPrice / aiCount);
		if (not lSnapshotItemPrices[aiKey]) then
			lSnapshotItemPrices[aiKey] = {buyoutPrices={buyoutPriceForOne}, name=aiName};
		else
			table.insert(lSnapshotItemPrices[aiKey].buyoutPrices, buyoutPriceForOne);
			table.sort(lSnapshotItemPrices[aiKey].buyoutPrices);
		end
	end


	-- if this auction is not in the snapshot add it
	local auctKey = Auctioneer_GetAuctionKey();
	local snap = Auctioneer_GetSnapshot(auctKey, itemCat, lAuctionSignature);
	
	-- If we haven't seen this item (it's not in the old snapshot)
	if (not snap) then 
		EnhTooltip.DebugPrint("No snap");
		lNewAuctionsCount = lNewAuctionsCount + 1;

		-- now build the list of buyout prices seen for this auction to use to get the median
		local newBuyoutPricesList = newBalancedList(lMaxBuyoutHistorySize);

		local auctionPriceItem = Auctioneer_GetAuctionPriceItem(aiKey, auctKey);
		if (not auctionPriceItem) then auctionPriceItem = {} end
		
		local seenCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = Auctioneer_GetAuctionPrices(auctionPriceItem.data);
		seenCount = seenCount + 1;
		minCount = minCount + 1;
		minPrice = minPrice + math.ceil(nullSafe(aiMinBid) / aiCount);
		if (nullSafe(aiBidAmount) > 0) then
			bidCount = bidCount + 1;
			bidPrice = bidPrice + math.ceil(nullSafe(aiBidAmount) / aiCount);
		end
		if (nullSafe(aiBuyoutPrice) > 0) then
			buyCount = buyCount + 1;
			buyPrice = buyPrice + math.ceil(nullSafe(aiBuyoutPrice) / aiCount);
		end
		auctionPriceItem.data = string.format("%d:%d:%d:%d:%d:%d:%d", seenCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice);

		local bph = auctionPriceItem.buyoutPricesHistoryList;
		if (bph and table.getn(bph) > 0) then
			newBuyoutPricesList.setList(bph);
		end
		if (nullSafe(aiBuyoutPrice) > 0) then
			newBuyoutPricesList.insert(math.ceil(aiBuyoutPrice / aiCount));
		end

		auctionPriceItem.buyoutPricesHistoryList = newBuyoutPricesList.getList();
		auctionPriceItem.name = aiName;
		auctionPriceItem.category = itemCat;
		Auctioneer_SaveAuctionPriceItem(auctKey, aiKey, auctionPriceItem);

		-- finaly add the auction to the snapshot
		if (aiOwner == nil) then aiOwner = "unknown"; end
		local initialTimeSeen = time();

		snap = {
			initialSeenTime=initialTimeSeen, 
			lastSeenTime=initialTimeSeen, 
			itemLink=aiLink, 
			quality=nullSafe(aiQuality), 
			level=nullSafe(aiLevel), 
			bidamount=nullSafe(aiBidAmount), 
			highBidder=aiHighBidder, 
			owner=aiOwner, 
			timeLeft=nullSafe(aiTimeLeft), 
			category=itemCat, 
			dirty=0
		};

	else
		EnhTooltip.DebugPrint("Snap!");
		lOldAuctionsCount = lOldAuctionsCount + 1;
		--this is an auction that was already in the snapshot from a previous scan and is still in the auction house
		snap.dirty = 0;                         --set its dirty flag to false so we know to keep it in the snapshot
		snap.lastSeenTime = time();             --set the time we saw it last
		snap.timeLeft = nullSafe(aiTimeLeft);   --update the time left
		snap.bidamount = nullSafe(aiBidAmount); --update the current bid amount
		snap.highBidder = aiHighBidder;         --update the high bidder
	end

	-- Commit the snapshot back to the table.
	Auctioneer_SaveSnapshot(auctKey, itemCat, lAuctionSignature, snap);
end

-- hook into the auction starting process
function Auctioneer_StartAuction(funcArgs, retVal, start, buy, duration)
	if (AuctPriceRememberCheck:GetChecked()) then
		if (not AuctionConfig.fixedprice) then AuctionConfig.fixedprice = {} end
		local count = Auctioneer_CurAuctionCount
		AuctionConfig.fixedprice[Auctioneer_CurAuctionItem] = string.format("%d:%d:%d", math.ceil(start/count), math.ceil(buy/count), duration)
	end
	Auctioneer_CurAuctionItem = nil
	Auctioneer_CurAuctionCount = nil
	AuctPriceRememberCheck:SetChecked(false)
end

-- hook to capture data about an auction that was boughtout
function Auctioneer_PlaceAuctionBid(funcVars, retVal, itemtype, itemindex, bidamount)
	-- get the info for this auction
	local aiLink = GetAuctionItemLink(itemtype, itemindex);
	local aiItemID, aiRandomProp, aiEnchant, aiUniqID = EnhTooltip.BreakLink(aiLink);
	local aiKey = aiItemID..":"..aiRandomProp..":"..aiEnchant;
	local aiName, aiTexture, aiCount, aiQuality, aiCanUse, aiLevel, aiMinBid, aiMinIncrement,
		aiBuyout, aiBidAmount, aiHighBidder, aiOwner =
		GetAuctionItemInfo(itemtype, itemindex);

	local auctionSignature = string.format("%d:%d:%d:%s:%d:%d:%d:%d", aiItemID, aiRandomProp, aiEnchant, nilSafeString(aiName), nullSafe(aiCount), nullSafe(aiMinBid), nullSafe(aiBuyout), aiUniqID);

	local playerName = UnitName("player");
	local eventTime = "e"..time();
	if (not AuctionConfig.bids) then AuctionConfig.bids = {} end
	if (not AuctionConfig.bids[playerName]) then
		AuctionConfig.bids[playerName] = {};
	end

	AuctionConfig.bids[playerName][eventTime] = string.format("%s|%s|%s|%s|%s", auctionSignature, bidamount, 0, aiOwner, aiHighBidder or "unknown");

	if bidamount == aiBuyout then -- only capture buyouts
		-- remove from snapshot
		Auctioneer_ChatPrint(string.format(_AUCT['FrmtActRemove'], auctionSignature));
		local auctKey = Auctioneer_GetAuctionKey();
		local itemCat = Auctioneer_GetCatForKey(aiKey);
		if (itemCat and AuctionConfig and AuctionConfig.snap and AuctionConfig.snap[auctKey] and AuctionConfig.snap[auctKey][itemCat]) then
			AuctionConfig.snap[auctKey][itemCat][auctionSignature] = nil;
		end
		if (not AuctionConfig.bids) then AuctionConfig.bids = {} end
		if (not AuctionConfig.bids[playerName]) then AuctionConfig.bids[playerName] = {} end
		AuctionConfig.bids[playerName][eventTime] = string.format("%s|%s|%s|%s|%s", auctionSignature, bidamount, 1, aiOwner, aiHighBidder or "unknown");
		if (Auctioneer_HSPCache and Auctioneer_HSPCache[auctKey]) then
			Auctioneer_HSPCache[auctKey][aiKey] = nil;
		end
		if (Auctioneer_Lowests) then Auctioneer_Lowests = nil; end
	end
end

local lAHConfigPending = true
function Auctioneer_ConfigureAH()
	if (lAHConfigPending and IsAddOnLoaded("Blizzard_AuctionUI")) then
		EnhTooltip.DebugPrint("Configuring AuctionUI");
		AuctionsPriceText:ClearAllPoints();
		AuctionsPriceText:SetPoint("TOPLEFT", "AuctionsItemText", "TOPLEFT", 0, -53);
		AuctionsBuyoutText:ClearAllPoints();
		AuctionsBuyoutText:SetPoint("TOPLEFT", "AuctionsPriceText", "TOPLEFT", 0, -33);
		AuctionsBuyoutErrorText:ClearAllPoints();
		AuctionsBuyoutErrorText:SetPoint("TOPLEFT", "AuctionsBuyoutText", "TOPLEFT", 0, -29);
		AuctionsDurationText:ClearAllPoints();
		AuctionsDurationText:SetPoint("TOPLEFT", "AuctionsBuyoutErrorText", "TOPLEFT", 0, -7);
		AuctionsDepositText:ClearAllPoints();
		AuctionsDepositText:SetPoint("TOPLEFT", "AuctionsDurationText", "TOPLEFT", 0, -31);
		if (AuctionInfo ~= nil) then
			AuctionInfo:ClearAllPoints();
			AuctionInfo:SetPoint("TOPLEFT", "AuctionsDepositText", "TOPLEFT", -4, -33);
		end

		AuctionsShortAuctionButtonText:SetText("2");
		AuctionsMediumAuctionButton:SetPoint("TOPLEFT", "AuctionsDurationText", "BOTTOMLEFT", 3, 1);
		AuctionsMediumAuctionButtonText:SetText("8");
		AuctionsMediumAuctionButton:ClearAllPoints();
		AuctionsMediumAuctionButton:SetPoint("BOTTOMLEFT", "AuctionsShortAuctionButton", "BOTTOMRIGHT", 20,0);
		AuctionsLongAuctionButtonText:SetText("24 "..HOURS);
		AuctionsLongAuctionButton:ClearAllPoints();
		AuctionsLongAuctionButton:SetPoint("BOTTOMLEFT", "AuctionsMediumAuctionButton", "BOTTOMRIGHT", 20,0);
		
		-- set UI-texts
		BrowseScanButton:SetText(_AUCT['TextScan']);
		BrowseScanButton:SetParent("AuctionFrameBrowse");
		BrowseScanButton:SetPoint("LEFT", "AuctionFrameMoneyFrame", "RIGHT", 5,0);
		BrowseScanButton:Show();

		if (AuctionInfo) then
			AuctionInfo:SetParent("AuctionFrameAuctions")
			AuctionInfo:SetPoint("TOPLEFT", "AuctionsDepositText", "TOPLEFT", -4, -51)
			AuctionInfo:Show()

			AuctPriceRemember:SetParent("AuctionFrameAuctions")
			AuctPriceRemember:SetPoint("TOPLEFT", "AuctionsDepositText", "BOTTOMLEFT", 0, -6)
			AuctPriceRemember:Show()
			AuctPriceRememberText:SetText(_AUCT['GuiRememberText'])
			AuctPriceRememberCheck:SetParent("AuctionFrameAuctions")
			AuctPriceRememberCheck:SetPoint("TOPLEFT", "AuctionsDepositText", "BOTTOMLEFT", 0, -2)
			AuctPriceRememberCheck:Show()
		end

		-- Protect the auction frame from being closed if we should
		if (Auctioneer_GetFilterVal('protect-window') == 2) then
			Auctioneer_ProtectAuctionFrame(true);
		end

		Auctioneer_HookAuctionHouse()
		AuctionFrameFilters_UpdateClasses()
		lAHConfigPending = nil
	end
end

function Auctioneer_AuctionFrameFilters_UpdateClasses()
	local obj
	for i=1, 15 do
		obj = getglobal("AuctionFilterButton"..i.."Checkbox")
		if (obj) then
			obj:SetParent("AuctionFilterButton"..i)
			obj:SetPoint("RIGHT", "AuctionFilterButton"..i, "RIGHT", -5,0)
		end
	end
end

function Auctioneer_RememberPrice()
	if (not Auctioneer_CurAuctionItem) then
		AuctPriceRememberCheck:SetChecked(false)
		return
	end

	if (not AuctPriceRememberCheck:GetChecked()) then
		if (AuctionConfig.fixedprice) then
			AuctionConfig.fixedprice[Auctioneer_CurAuctionItem] = nil
		end
	else
		if (not AuctionConfig.fixedprice) then AuctionConfig.fixedprice = {} end
		local count = Auctioneer_CurAuctionCount
		local start = MoneyInputFrame_GetCopper(StartPrice)
		local buy = MoneyInputFrame_GetCopper(BuyoutPrice)
		local dur = AuctionFrameAuctions.duration
		AuctionConfig.fixedprice[Auctioneer_CurAuctionItem] = string.format("%d:%d:%d", math.ceil(start/count), math.ceil(buy/count), dur)
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
	if (AuctionInfoWarnText == nil) then EnhTooltip.DebugPrint("Error, no text for AuctionInfo line "..line); end
	AuctionInfoWarnText:SetText(textStr);
	AuctionInfoWarnText:SetTextColor(0.9, 0.4, 0.0);
	AuctionInfoWarnText:Show();
end

function Auctioneer_Auctions_SetLine(line, textStr, moneyAmount)
	local text = getglobal("AuctionInfoText"..line);
	local money = getglobal("AuctionInfoMoney"..line);
	if (text == nil) then EnhTooltip.DebugPrint("Error, no text for AuctionInfo line "..line); end
	if (money == nil) then EnhTooltip.DebugPrint("Error, no money for AuctionInfo line "..line); end
	text:SetText(textStr);
	text:Show();
	if (money ~= nil) then
		MoneyFrame_Update("AuctionInfoMoney"..line, math.ceil(nullSafe(moneyAmount)));
		getglobal("AuctionInfoMoney"..line.."SilverButtonText"):SetTextColor(1.0,1.0,1.0);
		getglobal("AuctionInfoMoney"..line.."CopperButtonText"):SetTextColor(0.86,0.42,0.19);
		money:Show();
	else
		money:Hide();
	end
end


function Auctioneer_NewAuction()
	local name, texture, count, quality, canUse, price = GetAuctionSellItemInfo()
	local countFix = count
	if countFix == 0 then
		countFix = 1
	end

	if (not name) then
		Auctioneer_Auctions_Clear()
		return
	end

	local bag, slot, id, rprop, enchant, uniq = EnhTooltip.FindItemInBags(name);
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

	local startPrice, buyoutPrice, x;
	local itemKey = id..":"..rprop..":"..enchant;
	Auctioneer_CurAuctionItem = itemKey;
	Auctioneer_CurAuctionCount = countFix;
	local auctionPriceItem = Auctioneer_GetAuctionPriceItem(itemKey);
	local aCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = Auctioneer_GetAuctionPrices(auctionPriceItem.data);

	if (AuctionConfig.fixedprice and AuctionConfig.fixedprice[itemKey]) then
		AuctPriceRememberCheck:SetChecked(true)
	else
		AuctPriceRememberCheck:SetChecked(false)
	end

	-- Find the current lowest buyout for 1 of these in the current snapshot
	local currentLowestBuyout = Auctioneer_FindLowestAuctions(itemKey);
	if currentLowestBuyout then
		x,x,x,x,lowStackCount,x,currentLowestBuyout = Auctioneer_GetItemSignature(currentLowestBuyout);
		currentLowestBuyout = currentLowestBuyout / lowStackCount;
	end 
	
	local historicalMedian, historicalMedCount = Auctioneer_GetItemHistoricalMedianBuyout(itemKey);
	local snapshotMedian, snapshotMedCount = Auctioneer_GetItemSnapshotMedianBuyout(itemKey);

	Auctioneer_Auctions_Clear();
	Auctioneer_Auctions_SetLine(1, string.format(_AUCT['FrmtAuctinfoHist'], historicalMedCount), historicalMedian * count); 
	Auctioneer_Auctions_SetLine(2, string.format(_AUCT['FrmtAuctinfoSnap'], snapshotMedCount), snapshotMedian * count); 
	if (snapshotMedCount and snapshotMedCount > 0 and currentLowestBuyout) then
		Auctioneer_Auctions_SetLine(3, _AUCT['FrmtAuctinfoLow'], currentLowestBuyout * count);
	else
		Auctioneer_Auctions_SetLine(3, _AUCT['FrmtAuctinfoNolow']);
	end
	local blizPrice = MoneyInputFrame_GetCopper(StartPrice);

	local hsp, hspCount, mktPrice, warn = Auctioneer_GetHSP(itemKey, Auctioneer_GetAuctionKey());
	if hsp == 0 and buyCount > 0 then
		hsp = math.ceil(buyPrice / buyCount); -- use mean buyout if median not available
	end
	local discountBidPercent = tonumber(Auctioneer_GetFilterVal('pct-bidmarkdown'));
	local buyPrice = Auctioneer_RoundDownTo95(nullSafe(hsp) * countFix);
	local bidPrice = Auctioneer_RoundDownTo95(Auctioneer_SubtractPercent(buyPrice, discountBidPercent));

	if (AuctionConfig.fixedprice and AuctionConfig.fixedprice[itemKey]) then
		local i,j, start,buy,dur = string.find(AuctionConfig.fixedprice[itemKey], "(%d+):(%d+):(%d+)");
		Auctioneer_Auctions_SetLine(4, _AUCT['FrmtAuctinfoSugbid'], bidPrice);
		Auctioneer_Auctions_SetLine(5, _AUCT['FrmtAuctinfoSugbuy'], buyPrice);
		Auctioneer_Auctions_SetWarn(_AUCT['FrmtWarnUser']);
		MoneyInputFrame_SetCopper(StartPrice, start*countFix);
		MoneyInputFrame_SetCopper(BuyoutPrice, buy*countFix);
		Auctioneer_SetAuctionDuration(tonumber(dur));
	elseif (Auctioneer_GetFilter('autofill')) then
		Auctioneer_Auctions_SetLine(4, _AUCT['FrmtAuctinfoMktprice'], nullSafe(mktPrice)*countFix);
		Auctioneer_Auctions_SetLine(5, _AUCT['FrmtAuctinfoOrig'], blizPrice);
		Auctioneer_Auctions_SetWarn(warn);
		MoneyInputFrame_SetCopper(StartPrice, bidPrice);
		MoneyInputFrame_SetCopper(BuyoutPrice, buyPrice);
	else
		Auctioneer_Auctions_SetLine(4, _AUCT['FrmtAuctinfoSugbid'], bidPrice);
		Auctioneer_Auctions_SetLine(5, _AUCT['FrmtAuctinfoSugbuy'], buyPrice);
		Auctioneer_Auctions_SetWarn(warn);
	end
end

function Auctioneer_AuctHouseShow()
	-- Set the default auction duration
	if (Auctioneer_GetFilterVal('auction-duration') > 0) then
		Auctioneer_SetAuctionDuration(Auctioneer_GetFilterVal('auction-duration'))
	else
		Auctioneer_SetAuctionDuration(Auctioneer_GetFilterVal('last-auction-duration'))
	end
	
	-- Protect the auction frame from being closed if we should
	if (Auctioneer_GetFilterVal('protect-window') == 2) then
		Auctioneer_ProtectAuctionFrame(true);
	end
	
	-- Start scanning if so requested
	if Auctioneer_isScanningRequested then
		Auctioneer_StartAuctionScan();
	end
end


function Auctioneer_AuctHouseClose()
	if Auctioneer_isScanningRequested then
		Auctioneer_StopAuctionScan();
	end
	
	-- Unprotect the auction frame
	Auctioneer_ProtectAuctionFrame(false);
end

function Auctioneer_AuctHouseUpdate()
	if (Auctioneer_isScanningRequested and Auctioneer_CheckCompleteScan()) then
		Auctioneer_ScanAuction();
	end
end

function Auctioneer_FilterButton_SetType(funcVars, retVal, button, type, text, isLast)
	EnhTooltip.DebugPrint("Setting button", button:GetName(), type, text, isLast);

	local buttonName = button:GetName();
	local i,j, buttonID = string.find(buttonName, "(%d+)$");
	buttonID = tonumber(buttonID);

	local checkbox = getglobal(button:GetName().."Checkbox");
	if checkbox then
		if (type == "class") then
			local classid, maxid = Auctioneer_FindFilterClass(text);
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
end

local ignoreAuctionDurationChange = nil
function Auctioneer_OnChangeAuctionDuration()
	if (ignoreAuctionDurationChange) then
		ignoreAuctionDurationChange = nil;
		return
	end
	Auctioneer_SetFilter('last-auction-duration', AuctionFrameAuctions.duration)
end

function Auctioneer_SetAuctionDuration(duration, persist)
	local durationIndex
	if (duration >= 1 and duration <= 3) then
		durationIndex = duration
	elseif (duration == 120) then
		durationIndex = 1
	elseif (duration == 480) then
		durationIndex = 2
	elseif (duration == 1440) then
		durationIndex = 3
	else
		EnhTooltip.DebugPrint("Auctioneer_SetAuctionDuration(): invalid duration ", duration)
		return
	end
	
	if (not persist) then ignoreAuctionDurationChange = true; end
	AuctionsRadioButton_OnClick(durationIndex);
end

