--[[
	$Id$

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
]]

local LIBRARY_VERSION_MAJOR = "nSideBar-0.1"
local LIBRARY_VERSION_MINOR = tonumber(string.match("$Revision$", "(%d+)") or 1)

if not DongleStub then error(LIBRARY_VERSION_MAJOR .. " requires DongleStub.") end
if not DongleStub:IsNewerVersion(LIBRARY_VERSION_MAJOR, LIBRARY_VERSION_MINOR) then return end

RegisterCVar("nSideBarPos", "visible:10:right:180")

local lib = { private = {} };
local private = lib.private
local frame

function lib:GetVersion()
	return LIBRARY_VERSION_MAJOR, LIBRARY_VERSION_MINOR;
end

local function activate(new, old)
	if (old) then
		new.frame = old.frame
		frame = new.frame
		frame.private = new.private
		private = new.private
	else
		frame = CreateFrame("Frame", "", UIParent)
		new.frame = frame
		new.private = private
		frame.private = private

		frame:SetToplevel(true)
		frame:SetHitRectInsets(-3, -3, -3, -3)
		frame:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 32, edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		})
		frame:SetBackdropColor(0,0,0, 0.5)
		frame:EnableMouse(true)
		frame:SetScript("OnEnter", function(me) me.private.PopOut(me) end)
		frame:SetScript("OnLeave", function(me) me.private.PopBack(me) end)
		frame:SetScript("OnUpdate", function(me, dur) me.private.Popper(me,dur) end)
		frame.Tab = frame:CreateTexture()
		frame.Tab:SetTexture(0.98, 0.78, 0)
		frame.buttons = {}

		SLASH_NSIDEBAR1 = "/nsb"
		SLASH_NSIDEBAR2 = "/nsidebar"
		SlashCmdList["NSIDEBAR"] = function(msg)
			frame.private.CommandHandler(msg)
		end
	end
	new.ApplyLayout()
end


lib.Frame = frame

function private.PopOut(me, button)
	me.PopTimer = 0.15
	me.PopDirection = 1
end

function private.PopBack(me, button)
	me.PopTimer = 0.75
	me.PopDirection = -1
end

function private.MouseDown(me, button)
	if button then
		button.icon:SetTexCoord(0, 1, 0, 1)
	end
end

function private.MouseUp(me, button)
	if button then
		button.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
	end
end

function private.Popper(me, duration)
	if me.PopDirection then
		me.PopTimer = me.PopTimer - duration
		if me.PopTimer < 0 then
			if me.PopDirection > 0 then
				-- Pop Out
				me.PopDirection = nil
				me:ClearAllPoints()
				me.isOpen = true
			else
				-- Pop Back
				me.PopDirection = nil
				me:ClearAllPoints()
				me.isOpen = false
			end
			lib.ApplyLayout(true)
		end
	end
end

function private.CommandHandler(msg)
	local configVar = GetCVar("nSideBarPos")
	local vis, wide, side, position = strsplit(":", configVar)

	local save = false
	if (not msg or msg == "") then msg = "help" end
	local a, b, c = strsplit(" ", msg:lower())
	if (a == "help") then
		DEFAULT_CHAT_FRAME:AddMessage("/nsb [ top | left | bottom | right ] [ <n> ]")
		DEFAULT_CHAT_FRAME:AddMessage("/nsb [ fadeout | nofade ]")
		DEFAULT_CHAT_FRAME:AddMessage("/nsb size [ <n> ]")
		return
	end
	if (a == "top") 
	or (a == "left") 
	or (a == "bottom")
	or (a == "right") then
		side = a
		save = true
		if (tonumber(b)) then
			a, b, c = b, nil, nil
		end
	end
	if (tonumber(a)) then
		position = math.min(math.abs(tonumber(a)), 1200)
		save = true
	end
	if (a == "fadeout" or a == "fade") then
		vis = "fadeout"
		save = true
	elseif (a == "nofade") then
		vis = "visible"
		save = true
	end
	if (a == "size") then
		if (tonumber(b)) then
			wide = math.floor(tonumber(b))
			if (wide < 1) then wide = 1 end
			save = true
		end
	end

	if (save) then
		SetCVar("nSideBarPos", strjoin(":", vis, wide, side, position))
		lib.ApplyLayout()
	end
end

function lib.AddButton(id, texture, priority)
	if not priority then priority = 200 end

	local button
	if not frame.buttons[id] then
		button = CreateFrame("Button", "", frame)
		button.frame = frame
		button:SetPoint("TOPLEFT", frame, "TOPLEFT", 0,0)
		button:SetWidth(30)
		button:SetHeight(30)
		button:SetScript("OnMouseDown", function (me) me.frame.private.MouseDown(me.frame, me) end)
		button:SetScript("OnMouseUp", function (me) me.frame.private.MouseUp(me.frame, me) end)
		button:SetScript("OnEnter", function (me) me.frame.private.PopOut(me.frame, me) end)
		button:SetScript("OnLeave", function (me) me.frame.private.PopBack(me.frame, me) end)
		button.icon = button:CreateTexture("", "BACKGROUND")
		button.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
		button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0,0)
		button.icon:SetWidth(30)
		button.icon:SetHeight(30)
		button.id = id
		frame.buttons[id] = button
	else
		button = frame.buttons[id]
	end
	button.icon:SetTexture(texture)
	button.priority = priority

	lib.ApplyLayout()
	return button
end

function lib.ApplyLayout(useLayout)
	local configVar = GetCVar("nSideBarPos")
	if not (lib.lastConfig and configVar == lib.lastConfig) then
		useLayout = false
	end

	local vis, wide, side, position = strsplit(":", configVar)
	position = math.abs(tonumber(position) or 180)
	wide = tonumber(wide)
	side = side:lower()

	if not lib.private.layout then
		lib.private.layout = {}
		useLayout = false
	end
	local layout = lib.private.layout

	if not useLayout then
		for i = 1, #layout do table.remove(layout) end
		for id, button in pairs(frame.buttons) do
			table.insert(layout, button)
		end
	
		if (#layout == 0) then
			frame:Hide()
			return
		end
		
		table.sort(layout, function (a, b)
			if (a.priority < b.priority) then
				return true
			elseif (a.id < b.id) then
				return true
			end
			return false
		end)
	end

	if (#layout == 0) then
		frame:Hide()
		return
	end
		
	local width = wide
	if (#layout < wide) then width = #layout end
	local height = math.floor((#layout - 1) / wide) + 1

	local distance = 9
	if (frame.isOpen) then
		distance = width * 32 + 10
		if (frame:GetAlpha() < 1) then
			UIFrameFadeIn(frame, 0.25, frame:GetAlpha(), 1)
		end
	elseif (vis ~= "visible") then
		if (frame:GetAlpha() > 0.2) then
			UIFrameFadeOut(frame, 1.5, frame:GetAlpha(), 0.2)
		end
	end

	frame:ClearAllPoints()
	if (side == "top") then
		frame:SetPoint("BOTTOMLEFT", UIParent, "TOPLEFT", position, -1*distance)
	elseif (side == "bottom") then
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", position, distance)
	elseif (side == "left") then
		frame:SetPoint("TOPRIGHT", UIParent, "TOPLEFT", distance, -1*position)
	elseif (side == "right") then
		frame:SetPoint("TOPLEFT", UIParent, "TOPRIGHT", -1*distance, -1*position)
	end

	if (useLayout) then return end

	frame.Tab:ClearAllPoints()
	if (side == "top" or side == "bottom") then
		frame:SetWidth(height * 32 + 10)
		frame:SetHeight(width * 32 + 18)
		if (side == "top") then
			frame.Tab:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 5, 5)
			frame.Tab:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
		else
			frame.Tab:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
			frame.Tab:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
		end
		frame.Tab:SetHeight(3)
	else
		frame:SetWidth(width * 32 + 18)
		frame:SetHeight(height * 32 + 10)
		if (side == "right") then
			frame.Tab:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
			frame.Tab:SetPoint("BOTTOM", frame, "BOTTOM", 0, 5)
		else
			frame.Tab:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
			frame.Tab:SetPoint("BOTTOM", frame, "BOTTOM", 0, 5)
		end
		frame.Tab:SetWidth(3)
	end
	frame:Show()
	
	local button
	for pos = 1, #layout do
		button = layout[pos]
		pos = pos - 1
		local row = math.floor(pos / wide)
		local col = pos % wide

		if (row == 0) then width = col end

		button:ClearAllPoints()
		if (side == "right") then
			button:SetPoint("TOPLEFT", frame, "TOPLEFT", col*32+10, 0-(row*32+5))
		elseif (side == "left") then
			button:SetPoint("TOPLEFT", frame, "TOPLEFT", col*32+5, 0-(row*32+5))
		elseif (side == "bottom") then
			button:SetPoint("TOPLEFT", frame, "TOPLEFT", row*32+5, 0-(col*32+10))
		elseif (side == "top") then
			button:SetPoint("TOPLEFT", frame, "TOPLEFT", row*32+5, 0-(col*32+5))
		end
	end
end

-- Register our library
DongleStub:Register(lib, activate)

