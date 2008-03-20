--[[
	Auctioneer Advanced - Scan Button module
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://auctioneeraddon.com/

	This is an Auctioneer Advanced module that adds a textual scan progress
	indicator to the Auction House UI.

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

local libType, libName = "Util", "ScanButton"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local print,decode,recycle,acquire,clone,scrub,get,set,default = AucAdvanced.GetModuleLocals()

function lib.Processor(callbackType, ...)
	if (callbackType == "scanprogress") then
		private.UpdateScanProgress(...)
	elseif (callbackType == "auctionui") then
		private.HookAH(...)
	elseif (callbackType == "config") then
		private.SetupConfigGui(...)
	elseif (callbackType == "configchanged") then
		private.ConfigChanged(...)
	end
end

function lib.OnLoad()
	AucAdvanced.Settings.SetDefault("util.scanbutton.enabled", true)
end

-- /run local t = AucAdvanced.Modules.Util.ScanButton.Private.buttons.stop.tex t:SetPoint("TOPLEFT", t:GetParent() "TOPLEFT", 3,-3) t:SetPoint("BOTTOMRIGHT", t:GetParent(), "BOTTOMRIGHT", -3,3)
-- /run local t = AucAdvanced.Modules.Util.ScanButton.Private.buttons.stop.tex t:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\NavButtons") t:SetTexCoord(0.25, 0.5, 0, 1) t:SetVertexColor(1.0, 0.9, 0.1)

function private.HookAH()
	private.buttons = CreateFrame("Frame", nil, AuctionFrameBrowse)
	private.buttons:SetPoint("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 200,-15)
	private.buttons:SetWidth(22*3 + 4)
	private.buttons:SetHeight(18)
	private.buttons:SetScript("OnUpdate", private.OnUpdate)
	
	private.buttons.stop = CreateFrame("Button", nil, private.buttons, "OptionsButtonTemplate")
	private.buttons.stop:SetPoint("TOPLEFT", private.buttons, "TOPLEFT", 0,0)
	private.buttons.stop:SetWidth(22)
	private.buttons.stop:SetHeight(18)
	private.buttons.stop:SetScript("OnClick", private.stop)
	private.buttons.stop.tex = private.buttons.stop:CreateTexture(nil, "OVERLAY")
	private.buttons.stop.tex:SetPoint("TOPLEFT", private.buttons.stop, "TOPLEFT", 4,-2)
	private.buttons.stop.tex:SetPoint("BOTTOMRIGHT", private.buttons.stop, "BOTTOMRIGHT", -4,2)
	private.buttons.stop.tex:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\NavButtons")
	private.buttons.stop.tex:SetTexCoord(0.25, 0.5, 0, 1)
	private.buttons.stop.tex:SetVertexColor(1.0, 0.9, 0.1)
	
	private.buttons.play = CreateFrame("Button", nil, private.buttons, "OptionsButtonTemplate")
	private.buttons.play:SetPoint("TOPLEFT", private.buttons.stop, "TOPRIGHT", 2,0)
	private.buttons.play:SetWidth(22)
	private.buttons.play:SetHeight(18)
	private.buttons.play:SetScript("OnClick", private.play)
	private.buttons.play.tex = private.buttons.play:CreateTexture(nil, "OVERLAY")
	private.buttons.play.tex:SetPoint("TOPLEFT", private.buttons.play, "TOPLEFT", 4,-2)
	private.buttons.play.tex:SetPoint("BOTTOMRIGHT", private.buttons.play, "BOTTOMRIGHT", -4,2)
	private.buttons.play.tex:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\NavButtons")
	private.buttons.play.tex:SetTexCoord(0, 0.25, 0, 1)
	private.buttons.play.tex:SetVertexColor(1.0, 0.9, 0.1)
	
	private.buttons.pause = CreateFrame("Button", nil, private.buttons, "OptionsButtonTemplate")
	private.buttons.pause:SetPoint("TOPLEFT", private.buttons.play, "TOPRIGHT", 2,0)
	private.buttons.pause:SetWidth(22)
	private.buttons.pause:SetHeight(18)
	private.buttons.pause:SetScript("OnClick", private.pause)
	private.buttons.pause.tex = private.buttons.pause:CreateTexture(nil, "OVERLAY")
	private.buttons.pause.tex:SetPoint("TOPLEFT", private.buttons.pause, "TOPLEFT", 4,-2)
	private.buttons.pause.tex:SetPoint("BOTTOMRIGHT", private.buttons.pause, "BOTTOMRIGHT", -4,2)
	private.buttons.pause.tex:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\NavButtons")
	private.buttons.pause.tex:SetTexCoord(0.5, 0.75, 0, 1)
	private.buttons.pause.tex:SetVertexColor(1.0, 0.9, 0.1)

	private.UpdateScanProgress()
end

function private.UpdateScanProgress()
	local scanning, paused = AucAdvanced.Scan.IsScanning(), AucAdvanced.Scan.IsPaused()
	private.ConfigChanged()

	if scanning or paused then
		private.buttons.stop:Enable()
		private.buttons.stop.tex:SetVertexColor(1.0, 0.9, 0.1)
	else
		private.buttons.stop:Disable()
		private.buttons.stop.tex:SetVertexColor(0.3,0.3,0.3)
	end

	private.blink = nil
	if scanning and not paused then
		private.buttons.pause:Enable()
		private.buttons.pause.tex:SetVertexColor(1.0, 0.9, 0.1)
		private.buttons.play:Disable()
		private.buttons.play.tex:SetVertexColor(0.3,0.3,0.3)
	else
		private.buttons.play:Enable()
		private.buttons.play.tex:SetVertexColor(1.0, 0.9, 0.1)
		private.buttons.pause:Disable()
		private.buttons.pause.tex:SetVertexColor(0.3,0.3,0.3)
		if paused then
			private.blink = 1
		end
	end
end
local queue = {}
function private:OnUpdate(delay)
	if private.blink then
		private.timer = (private.timer or 0) - delay
		if private.timer < 0 then
			if not AucAdvanced.Scan.IsPaused() then
				private.UpdateScanProgress()
				return
			end
			if private.blink == 1 then
				private.buttons.pause.tex:SetVertexColor(0.1, 0.3, 1.0)
				private.blink = 2
			else
				private.buttons.pause.tex:SetVertexColor(0.3, 0.3, 0.3)
				private.blink = 1
			end
			private.timer = 0.75
		end
	end
	--Create the overlay filter buttons the (callbackType == "auctionui") is too early.
	if not AuctioneerFilterButton1 and AuctionFilterButton1 then
		private.CreateSecondaryFilterButtons()
		hooksecurefunc("AuctionFrameFilters_Update", private.AuctionFrameFilters_UpdateClasses)
	end
	--if we still have filters pending process it
	if #queue > 0 and not AucAdvanced.Scan.IsScanning() then
		private.play()
	end
end

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	id = gui:AddTab(libName, libType.." Modules")
	gui:AddControl(id, "Header",     0,    libName.." options")

	gui:AddHelp(id, "what scanbutton",
		"What are the scan buttons?",
		"The scan buttons are the Stop/Play/Pause buttons in the titlebar of the AuctionHouse frame.\n"..
		"These scan buttons are the scan buttons for Auctioneer Advanced. If you are also using Auctioneer Classic, "..
		"you may want to disable these buttons, until you are ready to switch, so as to avoid confusion.")

	gui:AddControl(id, "Checkbox",   0, 1, "util.scanbutton.enabled", "Show scan buttons in the AuctionHouse")
	gui:AddTip(id, "If enabled, shows the Stop/Play/Pause scan buttons in the title bar of the AuctionHouse")
end

function private.ConfigChanged()
	if not private.buttons then return end
	if AucAdvanced.Settings.GetSetting("util.scanbutton.enabled") then
		private.buttons:Show()
	else
		private.buttons:Hide()
	end
end


function private.stop()
	AucAdvanced.Scan.SetPaused(false)
	AucAdvanced.Scan.Cancel()
	private.UpdateScanProgress()
end

function private.play()
	if AucAdvanced.Scan.IsPaused() then
		AucAdvanced.Scan.SetPaused(false)
	elseif not AucAdvanced.Scan.IsScanning() then
		if #queue == 0 then queue = private.checkedFrames() end --check for user selected frames
		if #queue > 0  then
			print("Starting search on filter ", queue[1])
			AucAdvanced.Scan.StartScan("", "", "", nil, queue[1], nil, nil, nil)
			--print(#queue)
			table.remove(queue, 1)
			--print(#queue)
			if #queue == 0 then private.AuctionFrameFilters_ClearSelection() private.AuctionFrameFilters_ClearHighlight() print("Finished Queue") end
		else
			AucAdvanced.Scan.StartScan("", "", "", nil, nil, nil, nil, nil)
		end
	end
	private.UpdateScanProgress()
end

function private.pause()
	if not AucAdvanced.Scan.IsPaused() then
		AucAdvanced.Scan.SetPaused(true)
	end
	private.UpdateScanProgress()
end


--[[frame test code for AH
This adds a transparent replica of teh HA filters on the browse frame, we have scripts on this frame to select catagories a user chooses to scan
This means we do not have to directly modify blizzards filter frame
]]
local base = CreateFrame("Frame", "AuctionTest", UIParent)
base:SetFrameStrata("MEDIUM")
base:Show()
base:SetPoint("CENTER", UIParent, "CENTER")
--base:SetToplevel(true)
base:EnableMouse(true)

--store the primary AH filter catagories, this is a copy of the global table the AH uses
--CLASS_FILTERS generated via GetAuctionItemClasses()
--Resets the selections table to 0 if an alt click is not used, or after a scan has been implemented
private.Filters = {}
function private.AuctionFrameFilters_ClearSelection()
	for i,v in pairs(CLASS_FILTERS) do
		private.Filters[v] = {0,i} --store cleared table of selections
	end
end
--clear any current highlighting from a prev search
function private.AuctionFrameFilters_ClearHighlight()
	for i in pairs(CLASS_FILTERS) do
		getglobal("AuctionFilterButton"..i):UnlockHighlight() 
	end
end

function private.checkedFrames()
	queue = {}
	for i,v in pairs(private.Filters) do
		if v[1] == 1 then
			table.insert(queue, v[2])
		end
	end
	return queue
end

function private.CreateSecondaryFilterButtons()
local frame, prev
private.AuctionFrameFilters_ClearSelection() --create the filter selection table
	for i = 1,15 do
		frame = "AuctioneerFilterButton"..i
		prev = "AuctioneerFilterButton"..(i - 1)
		if i == 1 then
			base[frame] = CreateFrame("Button", frame, AuctionFilterButton1, "AuctionClassButtonTemplate")
			base[frame]:SetText("TICK-"..i)
			base[frame]:SetPoint("LEFT",0,0)
			base[frame]:SetWidth(156)
			base[frame]:SetAlpha(0)
			base[frame]:SetScript("OnClick", function()
									if IsControlKeyDown() then
										if private.Filters[getglobal("AuctionFilterButton"..i):GetText()][1] then
											if  private.Filters[getglobal("AuctionFilterButton"..i):GetText()][1] == 1 then
												private.Filters[getglobal("AuctionFilterButton"..i):GetText()][1] = 0
												getglobal("AuctionFilterButton"..i):UnlockHighlight()
												--print("false", getglobal("AuctionFilterButton"..i):GetText())
											else
												private.Filters[getglobal("AuctionFilterButton"..i):GetText()][1] = 1
												--print("true", getglobal("AuctionFilterButton"..i):GetText())
												getglobal("AuctionFilterButton"..i):LockHighlight()
											end
										end
									else
										AuctionFrameFilter_OnClick() 
										private.AuctionFrameFilters_UpdateClasses()
										private.AuctionFrameFilters_ClearSelection()
									end
								end)
		else
			base[frame] = CreateFrame("Button", frame, AuctionFilterButton1, "AuctionClassButtonTemplate")
			base[frame]:SetText("TICK-"..i)
			base[frame]:ClearAllPoints()
			base[frame]:SetPoint("TOPLEFT", base[prev],"BOTTOMLEFT",0,0)
			base[frame]:SetWidth(156)
			base[frame]:SetAlpha(0)
			base[frame]:SetScript("OnClick", function()
									if IsControlKeyDown() then
										if private.Filters[getglobal("AuctionFilterButton"..i):GetText()] then
											if  private.Filters[getglobal("AuctionFilterButton"..i):GetText()][1] == 1 then
												private.Filters[getglobal("AuctionFilterButton"..i):GetText()][1] = 0
												getglobal("AuctionFilterButton"..i):UnlockHighlight()
												--print("false", getglobal("AuctionFilterButton"..i):GetText())
											else
												private.Filters[getglobal("AuctionFilterButton"..i):GetText()][1] = 1
												--print("true", getglobal("AuctionFilterButton"..i):GetText())
												getglobal("AuctionFilterButton"..i):LockHighlight()
											end
										end
									else
										AuctionFrameFilter_OnClick() 
										private.AuctionFrameFilters_UpdateClasses()
										private.AuctionFrameFilters_ClearSelection()
									end
								end)
		end
	end 
	private.AuctionFrameFilters_UpdateClasses() --Changes the frame to match current filter frame, needed for 1 refresh after frame creation.
end

--Blizzard code base, used to generate a replica of the default filter frame
function private.AuctionFrameFilters_UpdateClasses()
	-- Display the list of open filters
	local button, index, info, isLast
	local offset = FauxScrollFrame_GetOffset(BrowseFilterScrollFrame)
	index = offset
	for i=1, NUM_FILTERS_TO_DISPLAY do
		button = getglobal("AuctioneerFilterButton"..i)
			
		if ( getn(OPEN_FILTER_LIST) > NUM_FILTERS_TO_DISPLAY ) then
			button:SetWidth(136)
		else
			button:SetWidth(156)
		end
		index = index + 1
		if ( index <= getn(OPEN_FILTER_LIST) ) then
			info = OPEN_FILTER_LIST[index]
			while ((info[2] == "invtype") and (not info[6])) do
				index = index + 1
				if ( index <= getn(OPEN_FILTER_LIST) ) then
					info = OPEN_FILTER_LIST[index]
				else
					info = nil
					button:Hide()
					break
				end
			end
			if ( info ) then
				FilterButton_SetType(button, info[2], info[1], info[5])
				button.index = info[3]
				if ( info[4] ) then
					button:LockHighlight()
				else
					button:UnlockHighlight()
				end
				button:Show()
			end
		else
			button:Hide()
		end
		
	end
end

AucAdvanced.RegisterRevision("$URL$", "$Rev$")
