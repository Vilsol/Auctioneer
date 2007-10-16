local libName = "BeanCounter"
local libType = "Util"
local lib = AucAdvanced.Modules[libType][libName]
local private = lib.Private

local print = AucAdvanced.Print
local debugPrint = print

local frame
function private.CreateFrames()
	if frame then return end

	local SelectBox = LibStub:GetLibrary("SelectBox")
	local ScrollSheet = LibStub:GetLibrary("ScrollSheet")

	frame = CreateFrame("Frame", nil, AuctionFrame)
	private.frame = frame
	frame.list = {}
	frame.buffer = {}
	frame.cache = {}
	
	--Create the TAB
	frame.ScanTab = CreateFrame("Button", "AuctionFrameTabUtilBeanCounter", AuctionFrame, "AuctionTabTemplate")
	frame.ScanTab:SetText("BeanCounter ADV")
	frame.ScanTab:Show()
	
	PanelTemplates_DeselectTab(frame.ScanTab)
	AucAdvanced.AddTab(frame.ScanTab, frame)
	
	--Set our Coordinate system relative to top left AH Frame
	frame:SetPoint("TOPLEFT", "AuctionFrame", "TOPLEFT", 0,0)
	frame:SetPoint("BOTTOMRIGHT", "AuctionFrame", "BOTTOMRIGHT", 0,0)
	--Add Title to the Top
	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", frame, "TOPLEFT", 80, -17)
	title:SetText("BeanCounter: Auction History Database")

	
	function frame.ScanTab.OnClick(_, _, index)
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
	
	--[[function private.ChangeControls(obj, ...)
		print("Clicked the button Option 1",obj, ...)
	end
	
	local vals = {
			{"sever", "Search Sever Data"},
			{"player", "Current character's data"},
			--"alliance", "Alliance Faction data",
			--"horde", "Horde Faction data"
			}
		
		--INSERT available toons to search them --TODO
	
	
	--Default Server wide
	--Select box, used to chooose where the stats comefrom we show server/faction/player/all
	frame.selectbox = CreateFrame("Frame", "BeanCounterSelectBox", frame)
	frame.selectbox.box = SelectBox:Create("BeanCounterSelectBox", frame.selectbox, 140, private.ChangeControls, vals, "default")
	frame.selectbox.box:SetPoint("TOPLEFT", frame, "TOPLEFT", 4,-115)
	frame.selectbox.box.element = "selectBox"
	frame.selectbox.box:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.selectbox.box:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0,-90)
	frame.selectbox.box:SetText("Data to show:")
	
	
]]
	--Search box		
	frame.searchBox = CreateFrame("EditBox", "BeancountersearchBox", frame, "InputBoxTemplate")
	frame.searchBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 29, -183)
	frame.searchBox:SetAutoFocus(false)
	frame.searchBox:SetHeight(15)
	frame.searchBox:SetWidth(150)
	frame.searchBox:SetScript("OnEnterPressed", function()
		local settings = {["exact"] = frame.exactCheck:GetChecked(), ["bid"] = frame.bidCheck:GetChecked(),["auction"] = frame.auctionCheck:GetChecked() } --["buy"] = frame.buyCheck:GetChecked(), }--["sell"] = frame.sellCheck:GetChecked()}
		private.startSearch(frame.searchBox:GetText(), settings)
	end)
	
	--Search Button	
	frame.searchButton = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.searchButton:SetPoint("TOPLEFT", frame.searchBox, "BOTTOMLEFT", -6, 0)
	frame.searchButton:SetText("Search")
	frame.searchButton:SetScript("OnClick", function()
		local settings = {["exact"] = frame.exactCheck:GetChecked(), ["bid"] = frame.bidCheck:GetChecked(),["auction"] = frame.auctionCheck:GetChecked() } --["buy"] = frame.buyCheck:GetChecked(), }--["sell"] = frame.sellCheck:GetChecked()}
		private.startSearch(frame.searchBox:GetText(), settings)
	end)
		
	--Check boxes to narrow our search
	frame.exactCheck = CreateFrame("CheckButton", "BeancounterexactCheck", frame, "OptionsCheckButtonTemplate")
	getglobal(BeancounterexactCheck:GetName().."Text"):SetText("Exact name search")
	frame.exactCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -217)

	frame.bidCheck = CreateFrame("CheckButton", "BeancounterbidCheck", frame, "OptionsCheckButtonTemplate")
	frame.bidCheck:SetChecked(true)
	getglobal(BeancounterbidCheck:GetName().."Text"):SetText("Bids")
	frame.bidCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -280)
	
	--frame.buyCheck = CreateFrame("CheckButton", "BeancounterbuyCheck", frame, "OptionsCheckButtonTemplate")
	--frame.buyCheck:SetChecked(true)
	--getglobal(BeancounterbuyCheck:GetName().."Text"):SetText("Buys")
	--frame.buyCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -255)
	
	frame.auctionCheck = CreateFrame("CheckButton", "BeancounterauctionCheck", frame, "OptionsCheckButtonTemplate")
	frame.auctionCheck:SetChecked(true)
	getglobal(BeancounterauctionCheck:GetName().."Text"):SetText("Auctions")
	frame.auctionCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -305)
	
	--frame.sellCheck = CreateFrame("CheckButton", "BeancountersellCheck", frame, "OptionsCheckButtonTemplate")
	--frame.sellCheck:SetChecked(true)
	--getglobal(BeancountersellCheck:GetName().."Text"):SetText("Sold")
	--frame.sellCheck:SetPoint("TOPLEFT", frame, "TOPLEFT", 19, -330)
	
	
	--Create the results window
	frame.resultlist = CreateFrame("Frame", "BeanCounterResultList", frame)
	frame.resultlist:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	
	frame.resultlist:SetBackdropColor(0, 0, 0.0, 0.5)
	frame.resultlist:SetPoint("TOPLEFT", AuctionFrame, "BOTTOMLEFT", 187, 320)
	frame.resultlist:SetPoint("TOPRIGHT", AuctionFrame, "BOTTOMRIGHT", -5, 0)
	frame.resultlist:SetPoint("BOTTOM", AuctionFrame, "BOTTOM", 0, 34)

	frame.resultlist.sheet = ScrollSheet:Create(frame.resultlist, {
		{ "Item", "TEXT", 120 },
		{ "Type", "TEXT", 110 },
		{ "Seller", "TEXT", 85 },
		{ "Buyer", "TEXT", 85 },
		--{ "Stk", "INT", 30 },
		{ "Price", "COIN", 80 },
		{ "Deposit", "COIN", 50 },
		{ "Fee", "COIN", 50 },
		{ "Bid", "COIN", 70 },
		{ "Buyout", "COIN", 70 },
		{ "Wealth", "COIN", 70 },
		--{ "Time", "INT", 80 },
	})
	
	
	function private.startSearch(itemName, settings)
		if not itemName then return end
		
		local data ={}
		
		for a,b in pairs(private.serverData) do
				if settings.auction then	 
					for i,v in pairs(private.serverData[a]["completedAuctions"]) do
						for index, text in pairs(v) do
						
						local tbl = {strsplit(":", text)}
						local match = false
						match = private.fragmentsearch(tbl[1], itemName, settings.exact)
							if match then
						--'["completedAuctions"] == itemName, "Auction successful", money, deposit , fee, buyout , bid, buyer, (time the mail arrived in our mailbox), current wealth',
						   table.insert(data,{
									tbl[1], --itemname
									tbl[2], --status
									    nil,  --seller
									tbl[8], --buyer
									tbl[3], --money,
									tbl[4], --deposit
									tbl[5], --fee
									tbl[7], --bid
									tbl[6], --buyout
									tbl[10], --current wealth
									tbl[9], --time,
									--math.floor(0.5+result[Const.MINBID]/count),
									--math.floor(0.5+result[Const.CURBID]/count),
									--math.floor(0.5+result[Const.BUYOUT]/count),
								    })
							end
						end
					end
					for i,v in pairs(private.serverData[a]["failedAuctions"]) do
						for index, text in pairs(v) do
						
						local tbl = {strsplit(":", text)}
						local match = false
						match = private.fragmentsearch(tbl[1], itemName, settings.exact)
							if match then
						--'["failedAuctions"] == itemName, "Auction expired", (time the mail arrived in our mailbox), curretn wealth',
						   --Lets try some basic reconciling here
						count, minBid, buyoutPrice, runTime, deposit = private.reconcileFailedAuctions(a, i, tbl)
						   
						   table.insert(data,{
									tbl[1], --itemname
									tbl[2], --status
									    nil,  --seller
									nil, --buyer
									nil, --money,
									deposit, --deposit
									nil, --fee
									minBid, --bid
									buyoutPrice, --buyout
									tbl[4], --current wealth
									tbl[3], --time,
								})
							end
						end
					end
			    end
			
				if settings.bid then--or settings.buy then	 
					for i,v in pairs(private.serverData[a]["completedBids/Buyouts"]) do
						for index, text in pairs(v) do
						
						local tbl = {strsplit(":", text)}
						local match = false
						match = private.fragmentsearch(tbl[1], itemName, settings.exact)
							if match then
									--  		1		2	    3	       4	       5       6         7      8                      9				10
						--'["completedBids"] == itemName, "Auction won", money, deposit , fee, buyout , bid, seller, (time the mail arrived in our mailbox), current wealth',
						   table.insert(data,{
									tbl[1], --itemname
									tbl[2], --status
									tbl[8],   --seller
									  nil, --buyer
									tbl[3], --money,
									tbl[4], --deposit
									tbl[5], --fee
									tbl[7], --bid
									tbl[6], --buyout
									tbl[10], --current wealth
									tbl[9], --time,
								    })
							end
						end
					end
					for i,v in pairs(private.serverData[a]["failedBids"]) do
						for index, text in pairs(v) do
						
						local tbl = {strsplit(":", text)}
						local match = false
						match = private.fragmentsearch(tbl[1], itemName, settings.exact)
							if match then
						--'["failedBids"] == itemName, "Outbid", money, (time the mail arrived in our mailbox)',
						   table.insert(data,{
									tbl[1], --itemname
									tbl[2], --status
									nil,  --seller
									nil, --buyer
									tbl[3], --money,
									nil, --deposit
									nil, --fee
									nil, --bid
									nil, --buyout
									tbl[5], --current wealth
									tbl[4], --time,
								    })
							end
						end
					end
				end
		end
		
	
		table.sort(data, function (a,b)  --Sort tables by time
			return (a[11] < b[11]) 
		end)
		
		frame.resultlist.sheet:SetData(data)
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
    			local tbl2 = {strsplit(":", v)}
			local runtime = tbl2[5]*60  --Time the auction was set to last
			local TimeFailedAuctionEnded = tbl[3] - runtime --Time this message should have been posted
			TimeFailedAuctionEnded = tostring(TimeFailedAuctionEnded) 
			local TimePostedAuction = tostring(tbl2[7])
		
		TimeFailedAuctionEnded = TimeFailedAuctionEnded:match("(.*).") --removes the last digit. This gives a 10 sec time window for our matching post
		TimePostedAuction = TimePostedAuction:match("(.*).")
		    
		    if TimePostedAuction == TimeFailedAuctionEnded then
			--post.name, post.count, post.minBid, post.buyoutPrice, post.runTime, post.deposit, time(), private.wealth
			return tbl2[2], tbl2[3], tbl2[4], tbl2[5], tbl2[6]
		    end
    
		end
	
	end
	
	
	
	
	
hooksecurefunc("AuctionFrameTab_OnClick", frame.ScanTab.OnClick)

end


