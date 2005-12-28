--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$

	Auctioneer Post Auctions tab
	
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
		along with this program(see GLP.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
--]]

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_OnLoad()
	-- Methods
	this.CalculateAuctionDeposit = AuctionFramePost_CalculateAuctionDeposit;
	this.UpdateDeposit = AuctionFramePost_UpdateDeposit;
	this.GetItemID = AuctionFramePost_GetItemID;
	this.GetItemName = AuctionFramePost_GetItemName;
	this.SetNoteText = AuctionFramePost_SetNoteText;
	this.GetSavePrice = AuctionFramePost_GetSavePrice;
	this.GetStartPrice = AuctionFramePost_GetStartPrice;
	this.SetStartPrice = AuctionFramePost_SetStartPrice;
	this.GetBuyoutPrice = AuctionFramePost_GetBuyoutPrice;
	this.SetBuyoutPrice = AuctionFramePost_SetBuyoutPrice;
	this.GetStackSize = AuctionFramePost_GetStackSize;
	this.SetStackSize = AuctionFramePost_SetStackSize;
	this.GetStackCount = AuctionFramePost_GetStackCount;
	this.SetStackCount = AuctionFramePost_SetStackCount;
	this.GetDuration = AuctionFramePost_GetDuration;
	this.SetDuration = AuctionFramePost_SetDuration;
	this.GetDeposit = AuctionFramePost_GetDeposit;
	this.SetAuctionItem = AuctionFramePost_SetAuctionItem;
	this.ValidateAuction = AuctionFramePost_ValidateAuction;
	this.UpdateAuctionList = AuctionFramePost_UpdateAuctionList;

	-- Data Members
	this.itemID = nil;
	this.itemName = nil;
	this.updating = false;
	this.prices = {};

	-- Controls
	this.auctionList = getglobal(this:GetName().."List");

	-- Configure the logical columns
	this.logicalColumns = 
	{
		Quantity =
		{
			title = _AUCT("UiQuantityHeader");
			dataType = "Number";
			valueFunc = (function(record) return record.quantity end);
			alphaFunc = AuctionFramePost_GetItemAlpha;
			compareAscendingFunc = (function(record1, record2) return record1.quantity < record2.quantity end);
			compareDescendingFunc = (function(record1, record2) return record1.quantity > record2.quantity end);
		},
		Name =
		{
			title = _AUCT("UiNameHeader");
			dataType = "String";
			valueFunc = (function(record) return record.name end);
			colorFunc = AuctionFramePost_GetItemColor;
			alphaFunc = AuctionFramePost_GetItemAlpha;
			compareAscendingFunc = (function(record1, record2) return record1.name < record2.name end);
			compareDescendingFunc = (function(record1, record2) return record1.name > record2.name end);
		},
		TimeLeft =
		{
			title = _AUCT("UiTimeLeftHeader");
			dataType = "String";
			valueFunc = (function(record) return Auctioneer_GetTimeLeftString(record.timeLeft) end);
			alphaFunc = AuctionFramePost_GetItemAlpha;
			compareAscendingFunc = (function(record1, record2) return record1.timeLeft < record2.timeLeft end);
			compareDescendingFunc = (function(record1, record2) return record1.timeLeft > record2.timeLeft end);
		},
		Bid =
		{
			title = _AUCT("UiBidHeader");
			dataType = "Money";
			valueFunc = (function(record) return record.bid end);
			alphaFunc = AuctionFramePost_GetItemAlpha;
			compareAscendingFunc = (function(record1, record2) return record1.bid < record2.bid end);
			compareDescendingFunc = (function(record1, record2) return record1.bid > record2.bid end);
		},
		BidPer =
		{
			title = _AUCT("UiBidPerHeader");
			dataType = "Money";
			valueFunc = (function(record) return record.bidPer end);
			alphaFunc = AuctionFramePost_GetItemAlpha;
			compareAscendingFunc = (function(record1, record2) return record1.bidPer < record2.bidPer end);
			compareDescendingFunc = (function(record1, record2) return record1.bidPer > record2.bidPer end);
		},
		Buyout =
		{
			title = _AUCT("UiBuyoutHeader");
			dataType = "Money";
			valueFunc = (function(record) return record.buyout end);
			alphaFunc = AuctionFramePost_GetItemAlpha;
			compareAscendingFunc = (function(record1, record2) return record1.buyout < record2.buyout end);
			compareDescendingFunc = (function(record1, record2) return record1.buyout > record2.buyout end);
		},
		BuyoutPer =
		{
			title = _AUCT("UiBuyoutPerHeader");
			dataType = "Money";
			valueFunc = (function(record) return record.buyoutPer end);
			alphaFunc = AuctionFramePost_GetItemAlpha;
			compareAscendingFunc = (function(record1, record2) return record1.buyoutPer < record2.buyoutPer end);
			compareDescendingFunc = (function(record1, record2) return record1.buyoutPer > record2.buyoutPer end);
		},
	};

	-- Configure the physical columns
	this.physicalColumns = 
	{
		{
			width = 50;
			logicalColumn = this.logicalColumns.Quantity;
			logicalColumns = { this.logicalColumns.Quantity };
			sortAscending = true;
		},
		{
			width = 210;
			logicalColumn = this.logicalColumns.Name;
			logicalColumns = { this.logicalColumns.Name };
			sortAscending = true;
		},
		{
			width = 90;
			logicalColumn = this.logicalColumns.TimeLeft;
			logicalColumns = { this.logicalColumns.TimeLeft };
			sortAscending = true;
		},
		{
			width = 130;
			logicalColumn = this.logicalColumns.Bid;
			logicalColumns =
			{
				this.logicalColumns.Bid,
				this.logicalColumns.BidPer
			};
			sortAscending = true;
		},
		{
			width = 130;
			logicalColumn = this.logicalColumns.Buyout;
			logicalColumns =
			{
				this.logicalColumns.Buyout,
				this.logicalColumns.BuyoutPer
			};
			sortAscending = true;
		},
	};

	this.auctions = {};
	ListTemplate_Initialize(this.auctionList, this.physicalColumns, this.logicalColumns);
	ListTemplate_SetContent(this.auctionList, this.auctions);

	this:ValidateAuction();
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_UpdatePriceModels(frame, name, count)
	frame.prices = {};

	if (name and count) then
		local bag, slot, id, rprop, enchant, uniq = Auctioneer_FindItemInBags(name);
		local itemKey = id..":"..rprop..":"..enchant;
		local hsp, histCount, market, warn, nexthsp, nextwarn = Auctioneer_GetHSP(itemKey, Auctioneer_GetAuctionKey());

		-- Get the fixed price
		if (Auctioneer_GetFixedPrice(itemKey)) then
			local startPrice, buyPrice = Auctioneer_GetFixedPrice(itemKey, count);
			local fixedPrice = {};
			fixedPrice.text = "Fixed Price";
			fixedPrice.note = "";
			fixedPrice.bid = startPrice;
			fixedPrice.buyout = buyPrice;
			table.insert(frame.prices, fixedPrice);
		end

		-- Calculate auctioneer's suggested resale price.
		if (hsp == 0) then
			local auctionPriceItem = Auctioneer_GetAuctionPriceItem(itemKey, Auctioneer_GetAuctionKey());
			local aCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = Auctioneer_GetAuctionPrices(auctionPriceItem.data);
			hsp = math.floor(buyPrice / buyCount); -- use mean buyout if median not available
		end
		local discountBidPercent = tonumber(Auctioneer_GetFilterVal('pct-bidmarkdown'));
		local auctioneerPrice = {};
		auctioneerPrice.text = "Auctioneer Price";
		auctioneerPrice.note = warn;
		auctioneerPrice.buyout = Auctioneer_RoundDownTo95(nullSafe(hsp) * count);
		auctioneerPrice.bid = Auctioneer_RoundDownTo95(Auctioneer_SubtractPercent(auctioneerPrice.buyout, discountBidPercent));
		table.insert(frame.prices, auctioneerPrice);

		-- Add the fallback custom price
		local customPrice = {}
		customPrice.text = "Custom Price"
		customPrice.note = "";
		customPrice.bid = nil;
		customPrice.buyout = nil;
		table.insert(frame.prices, customPrice);

		-- Update the price model combo.
		local oldThis = this;
		local dropdown = getglobal(frame:GetName().."PriceModelDropDown");
		this = getglobal(frame:GetName().."PriceModelDropDownButton");
		UIDropDownMenu_Initialize(dropdown, AuctionFramePost_PriceModelDropDown_Initialize);
		AuctionFramePost_PriceModelDropDownItem_SetSelectedID(dropdown, 1);
		this = oldThis;
	else
		-- Update the price model combo.
		local oldThis = this;
		local dropdown = getglobal(frame:GetName().."PriceModelDropDown");
		this = getglobal(frame:GetName().."PriceModelDropDownButton");
		UIDropDownMenu_Initialize(dropdown, AuctionFramePost_PriceModelDropDown_Initialize);
		AuctionFramePost_PriceModelDropDownItem_SetSelectedID(dropdown, nil);
		this = oldThis;
	end
end

-------------------------------------------------------------------------------
-- Updates the content of the auction list based on the current auction item.
-------------------------------------------------------------------------------
function AuctionFramePost_UpdateAuctionList(frame)
	frame.auctions = {};
	local itemName = frame:GetItemName();
	if (itemName) then
		local auctions = Auctioneer_QuerySnapshot(AuctionFramePost_ItemNameFilter, itemName);
		if (auctions) then
			for _,a in pairs(auctions) do
				local id,rprop,enchant,name,count,min,buyout,uniq = Auctioneer_GetItemSignature(a.signature);
				local auction = {};
				auction.item = string.format("item:%s:%s:%s:0", id, enchant, rprop);
				auction.quantity = count;
				auction.name = itemName;
				auction.owner = a.owner;
				auction.timeLeft = a.timeLeft;
				auction.bid = Auctioneer_GetCurrentBid(a.signature);
				auction.bidPer = math.floor(auction.bid / auction.quantity);
				auction.buyout = buyout;
				auction.buyoutPer = math.floor(auction.buyout / auction.quantity);
				table.insert(frame.auctions, auction);
			end
		end
	end
	ListTemplate_SetContent(frame.auctionList, frame.auctions);
	ListTemplate_Sort(frame.auctionList, 5);
end

-------------------------------------------------------------------------------
-- Updates the deposit value.
-------------------------------------------------------------------------------
function AuctionFramePost_UpdateDeposit(frame)
	if (not frame.updating) then
		local itemID = frame:GetItemID();
		local duration = frame:GetDuration();
		local stackSize = frame:GetStackSize();
		local stackCount = frame:GetStackCount();
		local depositFrameName = frame:GetName().."DepositMoneyFrame";
		if (itemID) then
			local deposit = AuctionFramePost_CalculateAuctionDeposit(itemID, duration);
			if (deposit) then
				MoneyFrame_Update(depositFrameName, deposit * stackSize * stackCount);
			else
				-- TODO: Figure out what to do when we don't know the deposit.
				MoneyFrame_Update(depositFrameName, 0);
			end
		else
			MoneyFrame_Update(depositFrameName, 0);
		end
	end
end

-------------------------------------------------------------------------------
-- Gets the item ID.
-------------------------------------------------------------------------------
function AuctionFramePost_GetItemID(frame)
	return frame.itemID;
end

-------------------------------------------------------------------------------
-- Gets the item name.
-------------------------------------------------------------------------------
function AuctionFramePost_GetItemName(frame)
	return frame.itemName;
end

-------------------------------------------------------------------------------
-- Sets the price model note (i.e. "Undercutting 5%")
-------------------------------------------------------------------------------
function AuctionFramePost_SetNoteText(frame, text)
	local cHex, cRed, cGreen, cBlue = Auctioneer_GetWarnColor(text);

	getglobal(frame:GetName().."PriceModelNoteText"):SetText(text);
	getglobal(frame:GetName().."PriceModelNoteText"):SetTextColor(cRed, cGreen, cBlue);
end

-------------------------------------------------------------------------------
-- Gets whether or not to save the current price information as the fixed
-- price.
-------------------------------------------------------------------------------
function AuctionFramePost_GetSavePrice(frame)
	local checkbox = getglobal(frame:GetName().."SavePriceCheckBox");
	return (checkbox and checkbox:IsVisible() and checkbox:GetChecked());
end

-------------------------------------------------------------------------------
-- Gets the starting price.
-------------------------------------------------------------------------------
function AuctionFramePost_GetStartPrice(frame)
	return MoneyInputFrame_GetCopper(getglobal(frame:GetName().."StartPrice"));
end

-------------------------------------------------------------------------------
-- Sets the starting price.
-------------------------------------------------------------------------------
function AuctionFramePost_SetStartPrice(frame, price)
	frame.ignoreStartPriceChange = true;
	MoneyInputFrame_SetCopper(getglobal(frame:GetName().."StartPrice"), price);
	frame:ValidateAuction();
end

-------------------------------------------------------------------------------
-- Gets the buyout price.
-------------------------------------------------------------------------------
function AuctionFramePost_GetBuyoutPrice(frame)
	return MoneyInputFrame_GetCopper(getglobal(frame:GetName().."BuyoutPrice"));
end

-------------------------------------------------------------------------------
-- Sets the buyout price.
-------------------------------------------------------------------------------
function AuctionFramePost_SetBuyoutPrice(frame, price)
	frame.ignoreBuyoutPriceChange = true;
	MoneyInputFrame_SetCopper(getglobal(frame:GetName().."BuyoutPrice"), price);
	frame:ValidateAuction();
end

-------------------------------------------------------------------------------
-- Gets the stack size.
-------------------------------------------------------------------------------
function AuctionFramePost_GetStackSize(frame)
	return getglobal(frame:GetName().."StackSize"):GetNumber();
end

-------------------------------------------------------------------------------
-- Sets the stack size.
-------------------------------------------------------------------------------
function AuctionFramePost_SetStackSize(frame, size)
	-- Update the stack size.
	getglobal(frame:GetName().."StackSize"):SetNumber(size);

	-- Update the deposit cost.
	frame:UpdateDeposit();
	frame:ValidateAuction();
end

-------------------------------------------------------------------------------
-- Gets the stack count.
-------------------------------------------------------------------------------
function AuctionFramePost_GetStackCount(frame)
	return getglobal(frame:GetName().."StackCount"):GetNumber();
end

-------------------------------------------------------------------------------
-- Sets the stack count.
-------------------------------------------------------------------------------
function AuctionFramePost_SetStackCount(frame, count)
	-- Update the stack count.
	getglobal(frame:GetName().."StackCount"):SetNumber(count);

	-- Update the deposit cost.
	frame:UpdateDeposit();
	frame:ValidateAuction();
end

-------------------------------------------------------------------------------
-- Gets the duration.
-------------------------------------------------------------------------------
function AuctionFramePost_GetDuration(frame)
	if (getglobal(frame:GetName().."ShortAuctionRadio"):GetChecked()) then
		return 120;
	elseif(getglobal(frame:GetName().."MediumAuctionRadio"):GetChecked()) then
		return 480;
	else
		return 1440;
	end
end

-------------------------------------------------------------------------------
-- Sets the duration.
-------------------------------------------------------------------------------
function AuctionFramePost_SetDuration(frame, duration)
	local shortRadio = getglobal(frame:GetName().."ShortAuctionRadio");
	local mediumRadio = getglobal(frame:GetName().."MediumAuctionRadio");
	local longRadio = getglobal(frame:GetName().."LongAuctionRadio");

	-- Figure out radio to set as checked.
	if (duration == 120) then
		shortRadio:SetChecked(1);
		mediumRadio:SetChecked(nil);
		longRadio:SetChecked(nil);
	elseif (duration == 480) then
		shortRadio:SetChecked(nil);
		mediumRadio:SetChecked(1);
		longRadio:SetChecked(nil);
	else
		shortRadio:SetChecked(nil);
		mediumRadio:SetChecked(nil);
		longRadio:SetChecked(1);
	end
	
	-- Update the deposit cost.
	frame:UpdateDeposit();
	frame:ValidateAuction();
end

-------------------------------------------------------------------------------
-- Gets the deposit amount required to post.
-------------------------------------------------------------------------------
function AuctionFramePost_GetDeposit(frame)
	return getglobal(frame:GetName().."DepositMoneyFrame").staticMoney;
end

-------------------------------------------------------------------------------
-- Sets the item to display in the create auction frame.
-------------------------------------------------------------------------------
function AuctionFramePost_SetAuctionItem(frame, bag, item, count)
	-- Prevent validation while updating.
	frame.updating = true;

	-- Update the controls with the item.	
	local button = getglobal(frame:GetName().."AuctionItem");
	if (bag and item) then
		-- Get the item's information.
		local itemLink = GetContainerItemLink(bag, item)
		local itemID, randomProp, enchant, uniqueId, name = Auctioneer_BreakLink(itemLink);
		local itemTexture, itemCount = GetContainerItemInfo(bag, item);
		if (count == nil) then
			count = itemCount;
		end

		-- Save the item's information.	
		frame.itemName = name;
		frame.itemID = itemID;

		-- Show the item
		getglobal(button:GetName().."Name"):SetText(name);
		getglobal(button:GetName().."Name"):Show();
		getglobal(button:GetName().."IconTexture"):SetTexture(itemTexture);
		getglobal(button:GetName().."IconTexture"):Show();
		--if ( count > 1 ) then
		--	getglobal(button:GetName().."Count"):SetText(count);
		--	getglobal(button:GetName().."Count"):Show();
		--else
		--	getglobal(button:GetName().."Count"):Hide();
		--end

		-- Set the defaults.
		frame:SetDuration(1440);
		frame:SetStackSize(count);
		frame:SetStackCount(1);
		AuctionFramePost_UpdatePriceModels(frame, name, count);
	else
		-- Clear the item's information.
		frame.itemName = nil;
		frame.itemID = nil;

		-- Hide the item
		getglobal(button:GetName().."Name"):Hide();
		getglobal(button:GetName().."IconTexture"):Hide();
		--getglobal(button:GetName().."Count"):Hide();

		-- Clear the defaults.
		frame:SetStackSize(1);
		frame:SetStackCount(1);
		AuctionFramePost_UpdatePriceModels(frame, nil, nil);
	end

	-- Update the deposit cost and validate the auction.
	frame.updating = false;
	frame:UpdateDeposit();
	frame:UpdateAuctionList();
	frame:ValidateAuction();
end

-------------------------------------------------------------------------------
-- Validates the current auction.
-------------------------------------------------------------------------------
function AuctionFramePost_ValidateAuction(frame)
	-- Only validate if its not turned off.
	if (not frame.updating) then
		-- Check that we have an item.
		local valid = false;
		if (frame.itemID) then
			valid = (frame.itemID ~= nil);
		end

		-- Check that there is a starting price.
		local startPrice = frame:GetStartPrice();
		local startErrorText = getglobal(frame:GetName().."StartPriceInvalidText");
		if (startPrice == 0) then
			valid = false;
			startErrorText:Show();
		else
			startErrorText:Hide();
		end

		-- Check that the starting price is less than or equal to the buyout.
		local buyoutPrice = frame:GetBuyoutPrice();
		local buyoutErrorText = getglobal(frame:GetName().."BuyoutPriceInvalidText");
		if (buyoutPrice > 0 and buyoutPrice < startPrice) then
			valid = false;
			buyoutErrorText:Show();
		else
			buyoutErrorText:Hide();
		end

		-- Check that the item stacks to the amount specified and that the player
		-- has enough of the item.
		local stackSize = frame:GetStackSize();
		local stackCount = frame:GetStackCount();
		local stackErrorText = getglobal(frame:GetName().."StackInvalidText");
		local quantityErrorText = getglobal(frame:GetName().."QuantityInvalidText");
		if (frame.itemID and frame.itemName) then
			local quantity = AucPostManager.GetItemQuantity(frame.itemName);
			local maxStackSize = AuctionFramePost_GetMaxStackSize(frame.itemID);
			if (stackSize > 1 and (maxStackSize == nil or stackSize > maxStackSize)) then
				valid = false;
				stackErrorText:Show();
				quantityErrorText:Hide();
			elseif (quantity < (stackSize * stackCount)) then
				valid = false;
				stackErrorText:Hide();
				quantityErrorText:Show();
			else
				stackErrorText:Hide();
				quantityErrorText:Hide();
			end
		else
			stackErrorText:Hide();
			quantityErrorText:Hide();
		end

		-- TODO: Check that the player can afford the deposit cost.
		local deposit = frame:GetDeposit();

		-- Update the state of the Create Auction button.
		local button = getglobal(frame:GetName().."CreateAuctionButton");
		if (valid) then
			button:Enable();
		else
			button:Disable();
		end

		-- Update the price model to reflect bid and buyout prices.
		local dropdown = getglobal(frame:GetName().."PriceModelDropDown");
		local index = UIDropDownMenu_GetSelectedID(dropdown);
		if (index and frame.prices and index <= table.getn(frame.prices)) then
			-- Check if the current selection matches
			local currentPrice = frame.prices[index];
			if ((currentPrice.bid and currentPrice.bid ~= startPrice) or
				(currentPrice.buyout and currentPrice.buyout ~= buyoutPrice)) then
				-- Nope, find one that does.
				for index,price in pairs(frame.prices) do
					if ((price.bid == nil or price.bid == startPrice) and (price.buyout == nil or price.buyout == buyoutPrice)) then
						if (UIDropDownMenu_GetSelectedID(dropdown) ~= index) then
							AuctionFramePost_PriceModelDropDownItem_SetSelectedID(dropdown, index);
						end
						break;
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_AuctionItem_OnClick(button)
	local frame = button:GetParent();

	-- If the cursor has an item, get it and put it back down in its container.
	local item = AuctioneerUI_GetCursorContainerItem();
	if (item) then
		PickupContainerItem(item.bag, item.slot);
	end

	-- Update the current item displayed
	if (item) then	
		local itemLink = GetContainerItemLink(item.bag, item.slot)
		local _, _, _, _, itemName = Auctioneer_BreakLink(itemLink);
		local _, count = GetContainerItemInfo(item.bag, item.slot);
		frame:SetAuctionItem(item.bag, item.slot, count);
	else
		frame:SetAuctionItem(nil, nil, nil);
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_DurationRadioButton_OnClick(button, index)
	local frame = button:GetParent();
	if (index == 1) then
		frame:SetDuration(120);
	elseif (index == 2) then
		frame:SetDuration(480);
	else
		frame:SetDuration(1440);
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_StartPrice_OnChanged()
	local frame = this:GetParent():GetParent();
	if (not frame.ignoreStartPriceChange and not updating) then
		frame:ValidateAuction();
	end
	frame.ignoreStartPriceChange = false;
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_BuyoutPrice_OnChanged()
	local frame = this:GetParent():GetParent();
	if (not frame.ignoreBuyoutPriceChange and not frame.updating) then
		frame.updating = true;
		local discountBidPercent = tonumber(Auctioneer_GetFilterVal('pct-bidmarkdown'));
		local bidPrice = Auctioneer_SubtractPercent(frame:GetBuyoutPrice(), discountBidPercent);
		frame:SetStartPrice(bidPrice);
		frame.updating = false;
		frame:ValidateAuction();
	end
	frame.ignoreBuyoutPriceChange = false;
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_StackSize_OnTextChanged()
	local frame = this:GetParent();

	-- Update the stack size displayed on the graphic.
	local itemID = frame:GetItemID();
	local stackSize = frame:GetStackSize();
	if (itemID and stackSize > 1) then
		getglobal(frame:GetName().."AuctionItemCount"):SetText(stackSize);
		getglobal(frame:GetName().."AuctionItemCount"):Show();
	else
		getglobal(frame:GetName().."AuctionItemCount"):Hide();
	end

	-- Update the deposit and validate the auction.
	frame:UpdateDeposit();
	frame:ValidateAuction();
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_StackCount_OnTextChanged()
	local frame = this:GetParent();
	frame:UpdateDeposit();
	frame:ValidateAuction();
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_CreateAuctionButton_OnClick(button)
	local frame = button:GetParent();
	local name = frame:GetItemName();
	local startPrice = frame:GetStartPrice();
	local buyoutPrice = frame:GetBuyoutPrice();
	local stackSize = frame:GetStackSize();
	local stackCount = frame:GetStackCount();
	local duration = frame:GetDuration();
	local deposit = frame:GetDeposit();

	-- Check if we should save the pricing information.
	if (frame:GetSavePrice()) then
		local bag, slot, id, rprop, enchant, uniq = Auctioneer_FindItemInBags(name);
		local itemKey = id..":"..rprop..":"..enchant;
		Auctioneer_SetFixedPrice(itemKey, startPrice, buyoutPrice, duration, stackSize, Auctioneer_GetAuctionKey());
	end

	-- Post the auction.
	AucPostManager.PostAuction(name, stackSize, stackCount, startPrice, buyoutPrice, duration);

	-- Clear the current auction item.
	frame:SetAuctionItem(nil, nil, nil);
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_PriceModelDropDown_Initialize()
	local dropdown = this:GetParent();
	local frame = dropdown:GetParent();
	if (frame.prices) then
		for index in frame.prices do
			local price = frame.prices[index];
			local info = {};
			info.text = price.text;
			info.func = AuctionFramePost_PriceModelDropDownItem_OnClick;
			info.owner = dropdown;
			UIDropDownMenu_AddButton(info);
		end
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_PriceModelDropDownItem_OnClick()
	local index = this:GetID();
	local dropdown = this.owner;
	local frame = dropdown:GetParent();
	if (frame.prices) then
		AuctionFramePost_PriceModelDropDownItem_SetSelectedID(dropdown, index);
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFramePost_PriceModelDropDownItem_SetSelectedID(dropdown, index)
	local frame = dropdown:GetParent();
	frame.updating = true;
	if (index) then
		local price = frame.prices[index]
		if (price.note) then
			frame:SetNoteText(price.note);
		end
		if (price.buyout) then
			frame:SetBuyoutPrice(price.buyout);
		end
		if (price.bid) then
			frame:SetStartPrice(price.bid);
		end

		if (price.text == "Custom Price") then
			getglobal(frame:GetName().."SavePriceText"):Show();
			getglobal(frame:GetName().."SavePriceCheckBox"):Show();
			getglobal(frame:GetName().."PriceModelNoteText"):Hide();
		elseif (price.text == "Auctioneer Price") then
			getglobal(frame:GetName().."SavePriceText"):Hide();
			getglobal(frame:GetName().."SavePriceCheckBox"):Hide();
			getglobal(frame:GetName().."PriceModelNoteText"):Show();
		else
			getglobal(frame:GetName().."SavePriceText"):Hide();
			getglobal(frame:GetName().."SavePriceCheckBox"):Hide();
			getglobal(frame:GetName().."PriceModelNoteText"):Hide();
		end

		UIDropDownMenu_SetSelectedID(dropdown, index);
	else
		frame:SetNoteText("");
		frame:SetStartPrice(0);
		frame:SetBuyoutPrice(0);
		getglobal(frame:GetName().."SavePriceText"):Hide();
		getglobal(frame:GetName().."SavePriceCheckBox"):Hide();
		getglobal(frame:GetName().."PriceModelNoteText"):Hide();
		UIDropDownMenu_ClearAll(dropdown);
	end
	frame.updating = false;
	frame:ValidateAuction();
end

-------------------------------------------------------------------------------
-- Calculate the deposit required for the specified item.
--
-- TODO: This method of calculating the deposit works for most items, but for
-- some items its wrong.
-------------------------------------------------------------------------------
function AuctionFramePost_CalculateAuctionDeposit(itemID, duration)
	local price = Auctioneer_GetVendorSellPrice(itemID);
	if (price) then
		if (duration == 120) then
			return math.floor(price * 0.05);
		elseif (duration == 480) then
			return math.floor(price * .20);
		else
			return math.floor(price * .60);
		end
	end
end

-------------------------------------------------------------------------------
-- Calculate the maximum stack size for an item based on the information returned by GetItemInfo()
-------------------------------------------------------------------------------
function AuctionFramePost_GetMaxStackSize(itemID)
	local _, _, _, _, _, _, itemStackCount = GetItemInfo(itemID);
	return itemStackCount;
end

-------------------------------------------------------------------------------
-- Filter for Auctioneer_QuerySnapshot that filters on item name.
-------------------------------------------------------------------------------
function AuctionFramePost_ItemNameFilter(item, signature)
	local id,rprop,enchant,name,count,min,buyout,uniq = Auctioneer_GetItemSignature(signature);
	if (item == name) then
		return false;
	end
	return true;
end

-------------------------------------------------------------------------------
-- Returns 1.0 for player auctions and 0.4 for competing auctions
-------------------------------------------------------------------------------
function AuctionFramePost_GetItemAlpha(record)
	if (record.owner ~= UnitName("player")) then
		return 0.4;
	end
	return 1.0;
end

-------------------------------------------------------------------------------
-- Returns the item color for the specified result
-------------------------------------------------------------------------------
function AuctionFramePost_GetItemColor(auction)
	_, _, rarity = GetItemInfo(auction.item);
	return ITEM_QUALITY_COLORS[rarity];
end
