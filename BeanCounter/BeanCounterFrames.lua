--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://auctioneeraddon.com/
	
	BeanCounterFrames - AuctionHouse UI for Beancounter 

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
    if private.getOption("util.beancounter.debugFrames") then
        private.debugPrint("BeanCounterFrames",...)
    end
end


local frame
function private.AuctionUI()
	if frame then return end
	frame = private.frame
	
	--Create the TAB
	frame.ScanTab = CreateFrame("Button", "AuctionFrameTabUtilBeanCounter", AuctionFrame, "AuctionTabTemplate")
	frame.ScanTab:SetText("BeanCounter")
	frame.ScanTab:Show()
	
	PanelTemplates_DeselectTab(frame.ScanTab)
	
	if AucAdvanced then
		AucAdvanced.AddTab(frame.ScanTab, frame)
	else
		private.AddTab(frame.ScanTab, frame)
	end
	
	function frame.ScanTab.OnClick(_, _, index)
		if private.frame:GetParent() == BeanCounterBaseFrame then
			BeanCounterBaseFrame:Hide()
			private.frame:SetParent(AuctionFrame)
			frame:SetPoint("TOPLEFT", "AuctionFrame", "TOPLEFT")
			--private.frame:SetWidth(828)
			--private.frame:SetHeight(450)
			private.relevelFrame(frame)--make sure our frame stays in proper order		
		end
	
		if not index then index = this:GetID() end
		local tab = getglobal("AuctionFrameTab"..index)
		if (tab and tab:GetName() == "AuctionFrameTabUtilBeanCounter") then
			AuctionFrameTopLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopLeft");
			AuctionFrameTop:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-Top");
			AuctionFrameTopRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopRight");
			AuctionFrameBotLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-BotLeft");
			AuctionFrameBot:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-Bot");
			AuctionFrameBotRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-BotRight");
			
			--print(tab:GetName())
			
			if (AuctionDressUpFrame:IsVisible()) then
				AuctionDressUpFrame:Hide()
				AuctionDressUpFrame.reshow = true
			end
			frame:Show()
		else
			if (AuctionDressUpFrame.reshow) then
				AuctionDressUpFrame:Show()
				AuctionDressUpFrame.reshow = nil
			end
			AuctionFrameMoneyFrame:Show()
			frame:Hide()
		end
	end
	
	hooksecurefunc("AuctionFrameTab_OnClick", frame.ScanTab.OnClick)
end
--Change parent to our GUI frame

function private.GUI(_,button)
	if (button == "LeftButton") then
		if private.frame:GetParent() == AuctionFrame then 
			--BeanCounterBaseFrame:SetWidth(800)
			--BeanCounterBaseFrame:SetHeight(450)
			
			private.frame:SetParent("BeanCounterBaseFrame")
			private.frame:SetPoint("TOPLEFT", BeanCounterBaseFrame, "TOPLEFT")
			--BeanCounterBaseFrame:SetPoint("TOPLEFT", lib.Gui, "TOPLEFT")
			
			--private.frame:SetPoint("BOTTOMRIGHT", lib.Gui, "BOTTOMRIGHT", 0,0)
		end
		if not BeanCounterBaseFrame:IsVisible() then
			if AuctionFrame then AuctionFrame:Hide() end
			BeanCounterBaseFrame:Show()
			private.frame:SetFrameStrata("FULLSCREEN")
			private.frame:Show()
		else
			BeanCounterBaseFrame:Hide()
		end
	else 
		if not lib.Gui:IsVisible() then
			lib.Gui:Show()
		else
			lib.Gui:Hide()
		end
	end
		
end

--Seperated frame items from frame creation, this should allow the same code to be reused for AH UI and Standalone UI
function private.CreateFrames()

	--Create the base frame for external GUI
	local base = CreateFrame("Frame", "BeanCounterBaseFrame", UIParent)
	base:SetBackdrop({
		bgFile = "Interface/Tooltips/ChatBubble-Background",
		edgeFile = "Interface/Tooltips/ChatBubble-BackDrop",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 32, right = 32, top = 32, bottom = 32 }
	})
	base:SetBackdropColor(0,0,0, 1)
	base:Hide()
	
	base:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
	base:SetWidth(828)
	base:SetHeight(450)
	
	--base:SetToplevel(true)
	base:SetMovable(true)
	base:EnableMouse(true)
	base.Drag = CreateFrame("Button", nil, base)
	base.Drag:SetPoint("TOPLEFT", base, "TOPLEFT", 10,-5)
	base.Drag:SetPoint("TOPRIGHT", base, "TOPRIGHT", -10,-5)
	base.Drag:SetHeight(6)
	base.Drag:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")

	base.Drag:SetScript("OnMouseDown", function() base:StartMoving() end)
	base.Drag:SetScript("OnMouseUp", function() base:StopMovingOrSizing() private.setter("configator.left", base:GetLeft()) private.setter("configator.top", base:GetTop()) end)
		
	--Launch BeanCounter GUI Config frame
	base.Config = CreateFrame("Button", nil, base, "OptionsButtonTemplate")
	base.Config:SetPoint("BOTTOMRIGHT", base, "BOTTOMRIGHT", -10, 10)
	base.Config:SetScript("OnClick", function() base:Hide() end)
	base.Config:SetText("Done")
	
	function private.toggleConfig()
		if base:IsVisible() then
			base:Hide()
			lib.Gui:Show()
			frame.Config:SetText("GUI")
		else
			base:Show()
			lib.Gui:Hide()
			frame.Config:SetText("Config")
		end
	end	
	
		
	
	--Create the Actual Usable Frame
	local frame = CreateFrame("Frame", "BeanCounterUiFrame", base)
	private.frame = frame
	frame:Hide()
	
	private.frame:SetPoint("TOPLEFT", base, "TOPLEFT")
	private.frame:SetWidth(828)
	private.frame:SetHeight(450)	
	
	--Add Title to the Top
	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", frame, "TOPLEFT", 80, -17)
	title:SetText("BeanCounter: Auction History Database")

	local SelectBox = LibStub:GetLibrary("SelectBox")
	local ScrollSheet = LibStub:GetLibrary("ScrollSheet")

	local BeanCounterSelectBoxSetting 	= {"1","server"}
	function private.ChangeControls(obj, arg1,arg2,...)
		--debugPrint("Clicked the button Option #", arg1, arg2)
		BeanCounterSelectBoxSetting = {arg1, arg2}
	end
	--Default Server wide
	local vals = {{"server", "Search "..private.realmName.." Data"},}
	for name,data in pairs(private.serverData) do 
		table.insert(vals,{name, "Search "..name.."'s Data"})
	end
			
	--Select box, used to chooose where the stats comefrom we show server/faction/player/all
	frame.selectbox = CreateFrame("Frame", "BeanCounterSelectBox", frame)
	frame.selectbox.box = SelectBox:Create("BeanCounterSelectBox", frame.selectbox, 140, private.ChangeControls, vals, "default")
	frame.selectbox.box:SetPoint("TOPLEFT", frame, "TOPLEFT", 4,-115)
	frame.selectbox.box.element = "selectBox"
	frame.selectbox.box:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.selectbox.box:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0,-90)
	frame.selectbox.box:SetText("Data to show:")
		
	--Search box		
	frame.searchBox = CreateFrame("EditBox", "BeancountersearchBox", frame, "InputBoxTemplate")
	frame.searchBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 29, -183)
	frame.searchBox:SetAutoFocus(false)
	frame.searchBox:SetHeight(15)
	frame.searchBox:SetWidth(150)
	frame.searchBox:SetScript("OnEnterPressed", function()
		local settings = {["selectbox"] = BeanCounterSelectBoxSetting, ["exact"] = frame.exactCheck:GetChecked(), ["classic"] = frame.classicCheck:GetChecked(), ["bid"] = frame.bidCheck:GetChecked(), ["auction"] = frame.auctionCheck:GetChecked() } --["buy"] = frame.buyCheck:GetChecked(), }--["sell"] = frame.sellCheck:GetChecked()}
		private.startSearch(frame.searchBox:GetText(), settings)
	end)
	
	--Search Button	
	frame.searchButton = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.searchButton:SetPoint("TOPLEFT", frame.searchBox, "BOTTOMLEFT", -6, 0)
	frame.searchButton:SetText("Search")
	frame.searchButton:SetScript("OnClick", function()
		local settings = {["selectbox"] = BeanCounterSelectBoxSetting,["exact"] = frame.exactCheck:GetChecked(), ["classic"] = frame.classicCheck:GetChecked(), ["bid"] = frame.bidCheck:GetChecked(),["auction"] = frame.auctionCheck:GetChecked() } --["buy"] = frame.buyCheck:GetChecked(), }--["sell"] = frame.sellCheck:GetChecked()}
		private.startSearch(frame.searchBox:GetText(), settings)
	end)
		
	--Check boxes to narrow our search
	frame.exactCheck = CreateFrame("CheckButton", "BeancounterexactCheck", frame, "OptionsCheckButtonTemplate")
	frame.exactCheck:SetChecked(false)
	getglobal("BeancounterexactCheckText"):SetText("Exact name search")
	frame.exactCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -217)

	--search classic data
	frame.classicCheck = CreateFrame("CheckButton", "BeancounterclassicCheck", frame, "OptionsCheckButtonTemplate")
	frame.classicCheck:SetChecked(false)
	getglobal("BeancounterclassicCheckText"):SetText("Show BC Classic data")
	frame.classicCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -242)	
	frame.classicCheck:Hide()
	--no need to show this button if theres no classic data to search
	if BeanCounterAccountDB then
		if BeanCounterAccountDB[private.realmName] then 
			frame.classicCheck:Show()
		end
	end
	
	--search bids
	frame.bidCheck = CreateFrame("CheckButton", "BeancounterbidCheck", frame, "OptionsCheckButtonTemplate")
	frame.bidCheck:SetChecked(true)
	getglobal("BeancounterbidCheckText"):SetText("Bids")
	frame.bidCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -280)
	
	--search Auctions
	frame.auctionCheck = CreateFrame("CheckButton", "BeancounterauctionCheck", frame, "OptionsCheckButtonTemplate")
	frame.auctionCheck:SetChecked(true)
	getglobal("BeancounterauctionCheckText"):SetText("Auctions")
	frame.auctionCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -305)
	
	--[[search Purchases (vendor/trade)
	frame.buyCheck = CreateFrame("CheckButton", "BeancounterbuyCheck", frame, "OptionsCheckButtonTemplate")
	frame.buyCheck:SetChecked(true)
	getglobal(BeancounterbuyCheck:GetName().."Text"):SetText("Buys")
	frame.buyCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -255)
	--search Sold (vendor/trade)
	frame.sellCheck = CreateFrame("CheckButton", "BeancountersellCheck", frame, "OptionsCheckButtonTemplate")
	frame.sellCheck:SetChecked(true)
	getglobal(BeancountersellCheck:GetName().."Text"):SetText("Sold")
	frame.sellCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -330)]]
	
	
	--Create the results window
	frame.resultlist = CreateFrame("Frame", nil, frame)
	frame.resultlist:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	
	frame.resultlist:SetBackdropColor(0, 0, 0.0, 0.5)
	frame.resultlist:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 187, 320)
	frame.resultlist:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -5, 0)
	frame.resultlist:SetPoint("BOTTOM", frame, "BOTTOM", 0, 34)
	--This changed the scroll sheet parent from AH to GUI or vice versa
	function private.resultlistSetPoint(frame)
		frame.resultlist:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 187, 320)
		frame.resultlist:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -5, 0)
		frame.resultlist:SetPoint("BOTTOM", frame, "BOTTOM", 0, 34)
	end

	frame.resultlist.sheet = ScrollSheet:Create(frame.resultlist, {
		{ "Item", "TEXT", 120 },
		{ "Type", "TEXT", 110 },
		
		{ "Bid", "COIN", 70 },
		{ "Buyout", "COIN", 70 },
		{ "Price", "COIN", 70},
		
		{ "Seller", "TEXT", 70 },
		{ "Buyer", "TEXT", 70 },
		
		{ "Deposit", "COIN", 50 },
		{ "Fee", "COIN", 50 },
		{ "Wealth", "COIN", 70 },
		{ "Date", "text", 110 },
	})
	
	
	function private.startSearch(itemName, settings)
		if not itemName then return end
		
		local data = {}
		local style = {}
		
		for a,b in pairs(private.serverData) do
				if settings.auction then
					if settings.selectbox[1] ~= 1 and a ~= settings.selectbox[2] and settings.selectbox[2] ~= "server" then --this allows the player to search a specific toon, rather than whole server
						--debugPrint("no match found for selectbox", settings.selectbox[2], a)
					else				
					for i,v in pairs(private.serverData[a]["completedAuctions"]) do 
						for index, text in pairs(v) do
						
						local tbl = private.unpackString(text)
						local match = false
						match = private.fragmentsearch(tbl[1], itemName, settings.exact)
							if match then
						--'["completedAuctions"] == itemName, "Auction successful", money, deposit , fee, buyout , bid, buyer, (time the mail arrived in our mailbox), current wealth', date
						   table.insert(data,{
									tbl[1], --itemname
									tbl[2], --status
									 
									"-", --tbl[7], --bid
									"-", --tbl[6], --buyout
									tbl[3], --money,
									
									  "-",  --seller
									tbl[8], --buyer
									
									tbl[4], --deposit
									tbl[5], --fee
									tbl[10], --current wealth
									date("%c", tbl[9]), --time, --Make this a user choosable option.
									--tbl[12], --date
								    })
								style[#data] = {}
								style[#data][2] = {}
								style[#data][2].textColor = {0.3, 0.9, 0.8}	
							end
						end
					end
					for i,v in pairs(private.serverData[a]["failedAuctions"]) do
						for index, text in pairs(v) do
						
						local tbl = private.unpackString(text)
						local match = false
						match = private.fragmentsearch(tbl[1], itemName, settings.exact)
							if match then
						--'["failedAuctions"] == itemName, "Auction expired", (time the mail arrived in our mailbox), curretn wealth',
						   --Lets try some basic reconciling here
						local count, minBid, buyoutPrice, runTime, deposit = private.reconcileFailedAuctions(a, i, tbl)
						   
						   table.insert(data,{
									tbl[1], --itemname
									tbl[2], --status
									
									minBid, --bid
									buyoutPrice, --buyout
									"-", --money,
									
									"-",  --seller
									"-", --buyer
									
									deposit, --deposit
									"-", --fee
									tbl[4], --current wealth
									date("%c", tbl[3]), --time,
									--tbl[5], --date
								})
								style[#data] = {}
								style[#data][2] = {}
								style[#data][2].textColor = {1,0,0}
							end
						end
					end
				end
			   end
			
				if settings.bid then--or settings.buy then
					if settings.selectbox[1] ~= 1 and a ~= settings.selectbox[2] and settings.selectbox[2] ~= "server" then --this allows the player to search a specific toon, rather than whole server
						--debugPrint("no match found for selectbox", settings.selectbox[2], a)
					else				
					
					for i,v in pairs(private.serverData[a]["completedBids/Buyouts"]) do
						for index, text in pairs(v) do
						
						local tbl = private.unpackString(text)
						local match = false
						match = private.fragmentsearch(tbl[1], itemName, settings.exact)
							if match then
									--  		1		2	    3	       4	       5       6         7      8                      9				10
						--'["completedBids"] == itemName, "Auction won", money, deposit , fee, buyout , bid, seller, (time the mail arrived in our mailbox), current wealth',
						   table.insert(data,{
									tbl[1], --itemname
									tbl[2], --status
									
									tbl[7], --bid
									tbl[6], --buyout
									tbl[3], --money,
									
									tbl[8],   --seller
									"-", --buyer
									  
									tbl[4], --deposit
									tbl[5], --fee
									tbl[10], --current wealth
									date("%c", tbl[9]), --time,
									--tbl[11], --date
								    })
								style[#data] = {}
								style[#data][2] = {}
								style[#data][2].textColor = {1,1,0}	
							end
						end
					end
					for i,v in pairs(private.serverData[a]["failedBids"]) do
						for index, text in pairs(v) do
						
						local tbl = private.unpackString(text)
						local match = false
						match = private.fragmentsearch(tbl[1], itemName, settings.exact)
							if match then
						--'["failedBids"] == itemName, "Outbid", money, (time the mail arrived in our mailbox)',
						   table.insert(data,{
									tbl[1], --itemname
									tbl[2], --status
									
									"-", --bid
									"-", --buyout
									tbl[3], --money,
									
									"-",  --seller
									"-", --buyer
									
									"-", --deposit
									"-", --fee
									tbl[5], --current wealth
									date("%c", tbl[4]), --time,
									--tbl[6], --date
								    })
								style[#data] = {}
								style[#data][2] = {}
								style[#data][2].textColor = {1,1,1}	
							end
						end
					end
					end
				end
		end
--BC CLASSIC DATA SEARCH	
	    if settings.classic then
		data, style = private.classicSearch(data, style, itemName, settings)
	    end

		frame.resultlist.sheet:SetData(data, style)
	end
	 
	function private.fragmentsearch(compare, itemName, exact)
		if exact then 
			if compare:lower() == itemName:lower() then return true end
		else
			local match = (compare:lower():find(itemName:lower(), 1, true) ~= nil)
			return match
		end
	end
	
	function private.reconcileFailedAuctions(player, itemID, tbl)
		for i,v in pairs(private.serverData[player]["postedAuctions"][itemID]) do
    			local tbl2 = private.unpackString(v)
			
			 --Time the auction was set to last
			local TimeFailedAuctionStarted= tbl[3] - (tbl2[5]*60) --Time this message should have been posted
			local TimePostedAuction = tbl2[7]
			
			TimeFailedAuctionStarted = math.floor(TimeFailedAuctionStarted/100)
			TimePostedAuction = math.floor(TimePostedAuction/100)
		    if TimePostedAuction == TimeFailedAuctionStarted then
		    --debugPrint(TimePostedAuction,TimeFailedAuctionStarted, tbl[3])
			--post.name, post.count, post.minBid, post.buyoutPrice, post.runTime, post.deposit, time(), private.wealth
			return tbl2[2], tbl2[3], tbl2[4], tbl2[5], tbl2[6]
		    end
    
		end
	
	end
	
private.CreateMailFrames()

end


function private.CreateMailFrames()

	local frame = CreateFrame("Frame", "BeanCounterMail", MailFrame)
	frame:Hide()
	private.MailGUI = frame
	local count, total = 0,0
	
	frame:SetPoint("TOPLEFT", MailFrame, "TOPLEFT", 19,-71)
	frame:SetPoint("BOTTOMRIGHT", MailFrame, "BOTTOMRIGHT", -39,115)
	--Add Title to the Top
	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("CENTER", frame, "CENTER", 0,60)
	title:SetText("BeanCounter is recording your mail")
	
	local body = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	body:SetPoint("CENTER", frame, "CENTER", 0, 30)
	body:SetText("Please do not close the mail frame or")
	local body1 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	body1:SetPoint("CENTER", frame, "CENTER", 0,0)
	body1:SetText("Auction Items will not be recorded")
	
	
	local countdown = frame:CreateFontString("BeanCounterMailCount", "OVERLAY", "GameFontNormalLarge")
	private.CountGUI = countdown
	countdown:SetPoint("CENTER", frame, "CENTER", 0, -60)
	countdown:SetText("Recording: "..count.." of "..total.." items")
	
end



--Taken from AucCore to make beancounter Standalone, Need to remove Redudundant stuff
function private.AddTab(tabButton, tabFrame)
	-- Count the number of auction house tabs (including the tab we are going
	-- to insert).
	local tabCount = 1;
	while (getglobal("AuctionFrameTab"..(tabCount))) do
		tabCount = tabCount + 1;
	end

	-- Find the correct location to insert our Search Auctions and Post Auctions
	-- tabs. We want to insert them at the end or before BeanCounter's
	-- Transactions tab.
	local tabIndex = 1;
	while (getglobal("AuctionFrameTab"..(tabIndex)) and
		   getglobal("AuctionFrameTab"..(tabIndex)):GetName() ~= "AuctionFrameTabTransactions") do
		tabIndex = tabIndex + 1;
	end

	-- Make room for the tab, if needed.
	for index = tabCount, tabIndex + 1, -1  do
		setglobal("AuctionFrameTab"..(index), getglobal("AuctionFrameTab"..(index - 1)));
		getglobal("AuctionFrameTab"..(index)):SetID(index);
	end

	-- Configure the frame.
	tabFrame:SetParent("AuctionFrame");
	tabFrame:SetPoint("TOPLEFT", "AuctionFrame", "TOPLEFT", 0, 0);
	private.relevelFrame(tabFrame);

	-- Configure the tab button.
	setglobal("AuctionFrameTab"..tabIndex, tabButton);
	tabButton:SetParent("AuctionFrame");
	tabButton:SetPoint("TOPLEFT", getglobal("AuctionFrameTab"..(tabIndex - 1)):GetName(), "TOPRIGHT", -8, 0);
	tabButton:SetID(tabIndex);
	tabButton:Show();

	-- Update the tab count.
	PanelTemplates_SetNumTabs(AuctionFrame, tabCount)
end

function private.relevelFrame(frame)
	return private.relevelFrames(frame:GetFrameLevel() + 2, frame:GetChildren())
end

function private.relevelFrames(myLevel, ...)
	for i = 1, select("#", ...) do
		local child = select(i, ...)
		child:SetFrameLevel(myLevel)
		private.relevelFrame(child)
	end
end

--Search BeancounterClassic Data
function private.classicSearch(data, style, itemName, settings)
   	    for name, v in pairs(BeanCounterAccountDB[private.realmName]["sales"]) do
		for index, text in pairs(v) do
		    local tbl = private.unpackString(text)
		    local match = false
		    match = private.fragmentsearch(name, itemName, settings.exact)
			if match then
			    --	1	2	    3	     4	   5	      6	      7	       8		9	   10
			    --"time;saleResult;quantity;bid;buyout;netPrice;price;isBuyout;buyerName;sellerId"
			    --"1173571623;1;1;11293;22000;-1500;<nil>;<nil>;<nil>;2"
			    local status = "Sold"
			 			    
			    if tbl[9] == "<nil>" then
				status = "Un-Sold"
				tbl[9] = "-"
			    end
			    			    
			    table.insert(data,{
					name, --itemname
					status, --status

					tbl[4], --tbl[7], --bid
					tbl[5], --buyout
					tbl[7], --money,
								
					 "-",  --seller
					tbl[9], --buyer
									
					"-",--tbl[7], --deposit
					"-", --tbl[8], --fee
					"-", --current wealth
					date("%c", tbl[1]), --time,
		
					 })	 
			end
		end
	    end
	    for name, v in pairs(BeanCounterAccountDB[private.realmName]["purchases"]) do
		for index, text in pairs(v) do
		    local tbl = private.unpackString(text)
		    local match = false
		    match = private.fragmentsearch(name, itemName, settings.exact)
			if match then
			    --	1	2	    3	     4	   5	      6	      7	       8		9	   10
			    --time;     quantity;value;seller;isBuyout;buyerId
			    --"1178840165;1;980000;Eruder;1;5",
			    local status = "Purchased"
			 			   		    			    
			    table.insert(data,{
					name, --itemname
					status, --status

					"-", --tbl[7], --bid
					tbl[3], --buyout
					"-", --money,
								
					tbl[4],  --seller
					"-", --buyer
									
					"-",--tbl[7], --deposit
					"-", --tbl[8], --fee
					"-", --current wealth
					date("%c", tbl[1]), --time,
					 })
			   style[#data] = {}
			   style[#data][2] = {}
			   style[#data][2].textColor = {1,0,0}					 
			end
		end
	    end
    
    return data, style
end