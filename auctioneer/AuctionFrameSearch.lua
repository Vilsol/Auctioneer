--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: <%version%>
	Revision: $Id$

	Auctioneer Search Auctions tab
	
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

local TIME_LEFT_NAMES = 
{
	"Short",
	"Medium",
	"Long",
	"Very Long"
};

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFrameSearch_OnLoad()
	-- Methods
	this.SearchBids = AuctionFrameSearch_SearchBids;
	this.SearchBuyouts = AuctionFrameSearch_SearchBuyouts;
	this.SelectResultByIndex = AuctionFrameSearch_SelectResultByIndex;

	-- Controls
	this.searchDropDown = getglobal(this:GetName().."SearchDropDown");
	this.profitMoneyFrame = getglobal(this:GetName().."MinProfit");
	this.percentLessEdit = getglobal(this:GetName().."MinPercentLess"); 
	this.timeLeftText = getglobal(this:GetName().."TimeLeftText");
	this.timeLeftDropDown = getglobal(this:GetName().."TimeLeftDropDown");
	this.resultsList = getglobal(this:GetName().."List");
	this.bidButton = getglobal(this:GetName().."BidButton");
	this.buyoutButton = getglobal(this:GetName().."BuyoutButton");

	-- Data members
	this.results = {};
	this.resultsType = nil;
	this.selectedResult = nil;

	-- Initialize the Search drop down
	local frame = this;
	this = this.searchDropDown;
	UIDropDownMenu_Initialize(this, AuctionFrameSearch_SearchDropDown_Initialize);
	AuctionFrameSearch_SearchDropDownItem_SetSelectedID(this, 1);
	this = frame;
	
	-- Configure the logical columns
	this.logicalColumns = 
	{
		Quantity =
		{
			title = "Qty";
			dataType = "Number";
			valueFunc = (function(record) return record.quantity end);
			compareAscendingFunc = (function(record1, record2) return record1.quantity < record2.quantity end);
			compareDescendingFunc = (function(record1, record2) return record1.quantity > record2.quantity end);
		},
		Name =
		{
			title = "Name";
			dataType = "String";
			valueFunc = (function(record) return record.name end);
			colorFunc = AuctionFrameSearch_GetItemColor;
			compareAscendingFunc = (function(record1, record2) return record1.name < record2.name end);
			compareDescendingFunc = (function(record1, record2) return record1.name > record2.name end);
		},
		TimeLeft =
		{
			title = "Time Left";
			dataType = "String";
			valueFunc = (function(record) return Auctioneer_GetTimeLeftString(record.timeLeft) end);
			compareAscendingFunc = (function(record1, record2) return record1.timeLeft < record2.timeLeft end);
			compareDescendingFunc = (function(record1, record2) return record1.timeLeft > record2.timeLeft end);
		},
		Bid =
		{
			title = "Bid";
			dataType = "Money";
			valueFunc = (function(record) return record.bid end);
			compareAscendingFunc = (function(record1, record2) return record1.bid < record2.bid end);
			compareDescendingFunc = (function(record1, record2) return record1.bid > record2.bid end);
		},
		BidPer =
		{
			title = "Bid Per";
			dataType = "Money";
			valueFunc = (function(record) return record.bidPer end);
			compareAscendingFunc = (function(record1, record2) return record1.bidPer < record2.bidPer end);
			compareDescendingFunc = (function(record1, record2) return record1.bidPer > record2.bidPer end);
		},
		Buyout =
		{
			title = "Buyout";
			dataType = "Money";
			valueFunc = (function(record) return record.buyout end);
			compareAscendingFunc = (function(record1, record2) return record1.buyout < record2.buyout end);
			compareDescendingFunc = (function(record1, record2) return record1.buyout > record2.buyout end);
		},
		BuyoutPer =
		{
			title = "Buyout Per";
			dataType = "Money";
			valueFunc = (function(record) return record.buyoutPer end);
			compareAscendingFunc = (function(record1, record2) return record1.buyoutPer < record2.buyoutPer end);
			compareDescendingFunc = (function(record1, record2) return record1.buyoutPer > record2.buyoutPer end);
		},
		Profit =
		{
			title = "Profit";
			dataType = "Money";
			valueFunc = (function(record) return record.profit end);
			compareAscendingFunc = (function(record1, record2) return record1.profit < record2.profit end);
			compareDescendingFunc = (function(record1, record2) return record1.profit > record2.profit end);
		},
		ProfitPer =
		{
			title = "Profit Per";
			dataType = "Money";
			valueFunc = (function(record) return record.profitPer end);
			compareAscendingFunc = (function(record1, record2) return record1.profitPer < record2.profitPer end);
			compareDescendingFunc = (function(record1, record2) return record1.profitPer > record2.profitPer end);
		},
		PercentLess =
		{
			title = "Pct";
			dataType = "Number";
			valueFunc = (function(record) return record.percentLess end);
			compareAscendingFunc = (function(record1, record2) return record1.percentLess < record2.percentLess end);
			compareDescendingFunc = (function(record1, record2) return record1.percentLess > record2.percentLess end);
		},
	};

	-- Configure the bid search physical columns
	this.bidSearchPhysicalColumns = 
	{
		{
			width = 40;
			logicalColumn = this.logicalColumns.Quantity;
			logicalColumns = { this.logicalColumns.Quantity };
			sortAscending = true;
		},
		{
			width = 170;
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
			logicalColumn = this.logicalColumns.Profit;
			logicalColumns =
			{
				this.logicalColumns.Profit,
				this.logicalColumns.ProfitPer
			};
			sortAscending = true;
		},
		{
			width = 50;
			logicalColumn = this.logicalColumns.PercentLess;
			logicalColumns =
			{
				this.logicalColumns.PercentLess
			};
			sortAscending = true;
		},
	};

	-- Configure the buyout search physical columns
	this.buyoutSearchPhysicalColumns = 
	{
		{
			width = 40;
			logicalColumn = this.logicalColumns.Quantity;
			logicalColumns = { this.logicalColumns.Quantity };
			sortAscending = true;
		},
		{
			width = 260;
			logicalColumn = this.logicalColumns.Name;
			logicalColumns = { this.logicalColumns.Name };
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
		{
			width = 130;
			logicalColumn = this.logicalColumns.Profit;
			logicalColumns =
			{
				this.logicalColumns.Profit,
				this.logicalColumns.ProfitPer
			};
			sortAscending = true;
		},
		{
			width = 50;
			logicalColumn = this.logicalColumns.PercentLess;
			logicalColumns =
			{
				this.logicalColumns.PercentLess
			};
			sortAscending = true;
		},
	};

	-- Initialize the list to show nothing at first.
	ListTemplate_Initialize(this.resultsList, this.results, this.results);
	
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFrameSearch_SearchDropDown_Initialize()
	local dropdown = this:GetParent();
	local frame = dropdown:GetParent();
	
	local bidsInfo = {};
	bidsInfo.text = "Bids";
	bidsInfo.func = AuctionFrameSearch_SearchDropDownItem_OnClick;
	bidsInfo.owner = dropdown;
	UIDropDownMenu_AddButton(bidsInfo);
	
	local buyoutsInfo = {};
	buyoutsInfo.text = "Buyouts";
	buyoutsInfo.func = AuctionFrameSearch_SearchDropDownItem_OnClick;
	buyoutsInfo.owner = dropdown;
	UIDropDownMenu_AddButton(buyoutsInfo);
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFrameSearch_SearchDropDownItem_OnClick()
	local index = this:GetID();
	local dropdown = this.owner;
	AuctionFrameSearch_SearchDropDownItem_SetSelectedID(dropdown, index);
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function AuctionFrameSearch_SearchDropDownItem_SetSelectedID(dropdown, index)
	local frame = dropdown:GetParent();
	if (index == 1) then
		frame.timeLeftText:Show();
		frame.timeLeftDropDown:Show();
	else
		frame.timeLeftText:Hide();
		frame.timeLeftDropDown:Hide();
	end
	UIDropDownMenu_SetSelectedID(dropdown, index);
end

-------------------------------------------------------------------------------
-- Initialize the content of the MinProfitDropDown list
-------------------------------------------------------------------------------
function AuctionFrameSearch_MinProfitDropDown_Initialize()
	local dropdown = this:GetParent();
	local frame = dropdown:GetParent();
	for index in TIME_LEFT_NAMES do
		local info = {};
		info.text = TIME_LEFT_NAMES[index];
		info.func = AuctionFrameSearch_MinProfitDropDownItem_OnClick;
		info.owner = dropdown;
		UIDropDownMenu_AddButton(info);
	end
end

-------------------------------------------------------------------------------
-- An item in the MinProfitDrownDown has been clicked
-------------------------------------------------------------------------------
function AuctionFrameSearch_MinProfitDropDownItem_OnClick()
	local index = this:GetID();
	local dropdown = this.owner;
	UIDropDownMenu_SetSelectedID(dropdown, index);
end

-------------------------------------------------------------------------------
-- The Search button has been clicked
-------------------------------------------------------------------------------
function AuctionFrameSearch_SearchButton_OnClick(button)
	local frame = button:GetParent();
	local searchIndex = UIDropDownMenu_GetSelectedID(frame.searchDropDown);
	local minProfit = MoneyInputFrame_GetCopper(frame.profitMoneyFrame);
	local minPercentLess = frame.percentLessEdit:GetNumber();
	if (searchIndex == 1) then
		local timeLeft = TIME_LEFT_SECONDS[UIDropDownMenu_GetSelectedID(frame.timeLeftDropDown)];
		frame:SearchBids(minProfit, minPercentLess, timeLeft);
	else
		frame:SearchBuyouts(minProfit, minPercentLess);
	end
end

-------------------------------------------------------------------------------
-- The Bid button has been clicked
-------------------------------------------------------------------------------
function AuctionFrameSearch_BidButton_OnClick(button)
	local frame = button:GetParent();
	local result = frame.selectedResult;
	if (result and result.name and result.quantity and result.bid) then
		DEFAULT_CHAT_FRAME:AddMessage("Bidding not yet implemented");
		--BidAuction_BidAuction(result.name, result.quantity, nil, result.bid, nil);
	end
end

-------------------------------------------------------------------------------
-- The Buyout button has been clicked.
-------------------------------------------------------------------------------
function AuctionFrameSearch_BuyoutButton_OnClick(button)
	local frame = button:GetParent();
	local result = frame.selectedResult;
	if (result and result.name and result.quantity and result.buyout) then
		DEFAULT_CHAT_FRAME:AddMessage("Buying not yet implemented");
		--BidAuction_BuyoutAuction(result.name, result.quantity, nil, nil, result.buyout);
	end
end

-------------------------------------------------------------------------------
-- Returns the item color for the specified result
-------------------------------------------------------------------------------
function AuctionFrameSearch_GetItemColor(result)
	_, _, rarity = GetItemInfo(result.id);
	return ITEM_QUALITY_COLORS[rarity];
end

-------------------------------------------------------------------------------
-- Perform a bid search (aka bidBroker)
-------------------------------------------------------------------------------
function AuctionFrameSearch_SearchBids(frame, minProfit, minPercentLess, maxTimeLeft)
	-- Create the content from auctioneer.
	frame.results = {};
	local bidWorthyAuctions = Auctioneer_QuerySnapshot(Auctioneer_BidBrokerFilter, minProfit, maxTimeLeft);
	if (bidWorthyAuctions) then
		local player = UnitName("player");
		for pos,a in pairs(bidWorthyAuctions) do
			if (a.owner ~= player) then
				local id,rprop,enchant,name, count,min,buyout,uniq = Auctioneer_GetItemSignature(a.signature);
				local itemKey = id .. ":" .. rprop..":"..enchant;
				local hsp, seenCount = Auctioneer_GetHSP(itemKey, Auctioneer_GetAuctionKey());
				local currentBid = Auctioneer_GetCurrentBid(a.signature);
				local percentLess = 100 - math.floor(100 * currentBid / (hsp * count));
				if (percentLess >= minPercentLess) then
					local auction = {};
					auction.quantity = count;
					auction.id = id;
					auction.link = a.itemLink;
					auction.name = name;
					auction.owner = a.owner;
					auction.timeLeft = a.timeLeft;
					auction.bid = currentBid;
					auction.bidPer = math.floor(auction.bid / count);
					auction.buyout = buyout;
					auction.buyoutPer = math.floor(auction.buyout / count);
					auction.profit = (hsp * count) - currentBid;
					auction.profitPer = math.floor(auction.profit / count);
					auction.percentLess = percentLess;
					table.insert(frame.results, auction);
				end
			end
		end
	end

	-- Hand the updated results to the list.
	frame.resultsType = "BidSearch";
	frame:SelectResultByIndex(nil);
	ListTemplate_Initialize(frame.resultsList, frame.bidSearchPhysicalColumns, frame.auctioneerListLogicalColumns);
	ListTemplate_SetContent(frame.resultsList, frame.results);
	ListTemplate_Sort(frame.resultsList, 2);
	ListTemplate_Sort(frame.resultsList, 3);
end

-------------------------------------------------------------------------------
-- Perform a buyout search (aka percentLess)
-------------------------------------------------------------------------------
function AuctionFrameSearch_SearchBuyouts(frame, minProfit, minPercentLess, maxTimeLeft)
	-- Create the content from auctioneer.
	frame.results = {};
	local buyoutWorthyAuctions = Auctioneer_QuerySnapshot(Auctioneer_PercentLessFilter, minPercentLess);
	if (buyoutWorthyAuctions) then
		local player = UnitName("player");
		for pos,a in pairs(buyoutWorthyAuctions) do
			if (a.owner ~= player) then
				local id,rprop,enchant,name,count,min,buyout,uniq = Auctioneer_GetItemSignature(a.signature);
				local itemKey = id .. ":" .. rprop..":"..enchant;
				local hsp, seenCount = Auctioneer_GetHSP(itemKey, Auctioneer_GetAuctionKey());
				local profit = (hsp * count) - buyout;
				if (profit >= minProfit) then
					local auction = {};
					auction.quantity = count;
					auction.id = id;
					auction.link = a.itemLink;
					auction.name = name;
					auction.owner = a.owner;
					auction.timeLeft = a.timeLeft;
					auction.buyout = buyout;
					auction.buyoutPer = math.floor(auction.buyout / count);
					auction.profit = profit;
					auction.profitPer = math.floor(auction.profit / count);
					auction.percentLess = 100 - math.floor(100 * buyout / (hsp * count));
					table.insert(frame.results, auction);
				end
			end
		end
	end

	-- Hand the updated content to the list.
	frame.resultsType = "BuyoutSearch";
	frame:SelectResultByIndex(nil);
	ListTemplate_Initialize(frame.resultsList, frame.buyoutSearchPhysicalColumns, frame.auctioneerListLogicalColumns);
	ListTemplate_SetContent(frame.resultsList, frame.results);
	ListTemplate_Sort(frame.resultsList, 5);
end

-------------------------------------------------------------------------------
-- Select a search result by index.
-------------------------------------------------------------------------------
function AuctionFrameSearch_SelectResultByIndex(frame, index)
	if (index and index <= table.getn(frame.results) and frame.resultsType) then
		-- Select the item
		local result = frame.results[index];
		frame.selectedResult = result;
		ListTemplate_SelectRow(frame.resultsList, index);

		-- Update the bid button
		if (frame.resultsType == "BidSearch") then
			frame.bidButton:Enable();
			frame.buyoutButton:Disable();
		elseif (frame.resultsType == "BuyoutSearch") then
			frame.bidButton:Disable();
			frame.buyoutButton:Enable();
		end
	else
		-- Clear the selection
		frame.selectedResult = nil;
		ListTemplate_SelectRow(frame.resultsList, nil);
		frame.bidButton:Disable();
		frame.buyoutButton:Disable();
	end
end

-------------------------------------------------------------------------------
-- An item in the list is moused over.
-------------------------------------------------------------------------------
function AuctionFrameSearch_ListItem_OnEnter(row)
	local frame = this:GetParent():GetParent();
	local results = frame.results;
	if (results and row <= table.getn(results)) then
		local result = results[row];
		if (result) then
			local name = result.name;
			local _, link, rarity = GetItemInfo(results[row].id);
			local count = result.quantity;
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
			GameTooltip:SetHyperlink(link);
			GameTooltip:Show();
			EnhTooltip.TooltipCall(GameTooltip, name, result.link, rarity, count);
		end
	end
end

-------------------------------------------------------------------------------
-- An item in the list is clicked.
-------------------------------------------------------------------------------
function AuctionFrameSearch_ListItem_OnClick(row)
	local frame = this:GetParent():GetParent();
	
	-- Select the item clicked.
	frame:SelectResultByIndex(row);

	-- Bid or buyout the item if the alt key is down.
	if (frame.resultsType and IsAltKeyDown()) then
		--BrowseName:SetText(results[row].name)
		--BrowseMinLevel:SetText("")
		--BrowseMaxLevel:SetText("")
		--AuctionFrameBrowse.selectedInvtypeIndex = nil
		--AuctionFrameBrowse.selectedClassIndex = nil
		--AuctionFrameBrowse.selectedSubclassIndex = nil
		--IsUsableCheckButton:SetChecked(0)
		--UIDropDownMenu_SetSelectedValue(BrowseDropDown, -1)
		--AuctionFrameBrowse_Search()
		--AuctionFrameTab_OnClick(1);
		if (frame.resultsType == "BidSearch") then
			AuctionFrameSearch_BidButton_OnClick(frame.bidButton);
		elseif (frame.resultsType == "BuyoutSearch") then
			AuctionFrameSearch_BuyoutButton_OnClick(frame.buyoutButton);
		end
	end
end
