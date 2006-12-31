--[[
	Swatter - An AddOn debugging aid for World of Warcraft.
	$Id$
	Copyright (C) 2006 Norganna

	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.

	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
]]

Swatter = {
	origHandler = geterrorhandler(),
	origItemRef = SetItemRef,
	nilFrame = {
		GetName = function() return "Global" end
	},
	errorOrder = {},
	HISTORY_SIZE = 50,
}
local origItemRef = Swatter.origItemRef

SwatterData = {
	enabled = true,
	autoshow = true,
	errors = {},
}

function Swatter.ChatMsg(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local chat = Swatter.ChatMsg

function Swatter.IsEnabled()
	return SwatterData.enabled
end

-- Test:  /run Swatter.OnError("Test")
function Swatter.OnError(msg, frame, stack, etype, ...)
	if (not SwatterData.enabled) then 
		if (not etype) then
			return Swatter.origHandler(msg, frame)
		else
			return UIParent_OnEvent(etype, ...)
		end
	end

	msg = msg or ""
	frame = frame or Swatter.nilFrame
	stack = stack or debugstack(2, 20, 20)

	local context
	if (not frame.Swatter) then frame.Swatter = {} end
	local id = frame.Swatter[msg]
	if (not id) then
		context = "Anonymous"
		if (frame) then
			context = "Unnamed"
			if (frame:GetName()) then
				context = frame:GetName()
			end
		end
		table.insert(SwatterData.errors, {
			context = context,
			message = msg,
			stack = stack,
			count = 0,
		})
		id = table.getn(SwatterData.errors)
		frame.Swatter[msg] = id
	else
		context = SwatterData.errors[id].context
		for pos, errid in ipairs(Swatter.errorOrder) do
			if (errid == id) then
				table.remove(Swatter.errorOrder, pos)
				break
			end
		end
	end
	table.insert(Swatter.errorOrder, id)

	local err = SwatterData.errors[id]
	local count = err.count or 0
	if (count < 1000) then err.count = count + 1 end
	if (count == 0) then
		if (etype == "ADDON_ACTION_BLOCKED") then
			if (not Swatter.blockWarn) then
				chat("|cffffaa11Warning only: Swatter found blocked actions:|r |Hswatter:"..id.."|h|cffff3311["..context.."]|r|h")
				chat("|cffffaa11Note: Swatter will continue to catch blocked actions but this is the last time this session that we'll tell you about it.|r")
				Swatter.blockWarn = true
			end
		elseif (SwatterData.autoshow) then
			Swatter.ErrorUpdate()
			Swatter.Error:Show()
		else
			chat("|cffffaa11Swatter caught error:|r |Hswatter:"..id.."|h|cffff3311["..context.."]|r|h")
		end
	end
end

function Swatter.NamedFrame(name)
	if (not Swatter.named) then Swatter.named = {} end
	if (not Swatter.named[name]) then
		Swatter.named[name] = {
			name = name,
			GetName = function(obj) return obj.name end,
		}
	end
	return Swatter.named[name]
end


-- Error occured in: Global
-- Count: 1
-- Message: [string "bla()"] line 1:
--   attempt to call global 'bla' (a nil value)
-- Debug:
-- [C]: in function `bla'
-- [string "bla()"]:1: in main chunk
-- [C]: in function `RunScript'
-- Interface\FrameXML\ChatFrame.lua:1788: in function `value'
-- Interface\FrameXML\ChatFrame.lua:3008: in function `ChatEdit_ParseText'
-- Interface\FrameXML\ChatFrame.lua:2734: in function `ChatEdit_SendText'
-- Interface\FrameXML\ChatFrame.lua:2756: in function `ChatEdit_OnEnterPressed'
-- [string "ChatFrameEditBox:OnEnterPressed"]:2: in function <[string "ChatFrameEditBox:OnEnterPressed"]:1>

function Swatter.OnEvent(frame, event, ...)
	if (event == "ADDON_LOADED") then
		local addon = select(1, ...)
		if (addon:lower() == "!swatter") then

			-- Check to see if we still exist
			if (not SwatterData) then
				if (BugGrabber) then
					-- We've been buggrabber-nabbed. Give up.
					DEFAULT_CHAT_FRAME:AddMessage("|cffffaa11Warning: Swatter has been disabled by BugGrabber. If you want to run Swatter instead of BugGrabber/BugSack, disable those two addons in you addon list and re-enable Swatter. Otherwise, enjoy BugGrabber!|r");
				end
				SetItemRef = origItemRef
				return
			end

			-- We need to cleanup our error history
			if (not SwatterData.errors) then SwatterData.errors = {} end
			local ec = table.getn(SwatterData.errors) or 0
			if (ec > Swatter.HISTORY_SIZE) then
				local remove = ec - Swatter.HISTORY_SIZE
				for i=1, remove do
					table.remove(SwatterData.errors, 1)
				end
			end
			for pos, err in ipairs(SwatterData.errors) do
				table.insert(Swatter.errorOrder, pos)
			end
			frame:UnregisterEvent("ADDON_LOADED")
			return
		end
	elseif (event == "ADDON_ACTION_BLOCKED") then
		local addon, func = select(1, ...)
		Swatter.OnError(string.format("Warning: AddOn %s attempted to call a protected function (%s) from a tainted execution path.", addon, func), Swatter.NamedFrame("AddOn: "..addon), debugstack(2, 20, 20), event, ...)
	elseif (event == "ADDON_ACTION_FORBIDDEN") then
		local addon, func = select(1, ...)
		Swatter.OnError(string.format("Warning: AddOn %s attempted to call a forbidden function (%s) from a tainted execution path.", addon, func), Swatter.NamedFrame("AddOn: "..addon), debugstack(2, 20, 20), event, ...)
	end
end

function Swatter.SetItemRef(...)
	local msg = select(1, ...)
	local id = select(3, msg:find("^swatter:(%d+)"))
	id = tonumber(id)
	if (id) then
		if (Swatter) then
			for pos, errid in ipairs(Swatter.errorOrder) do
				if (errid == id) then
					Swatter.Error:Show()
					return Swatter.ErrorDisplay(pos)
				end
			end
		end
	else
		if (not Swatter) then
			SetItemRef = origItemRef
			return origItemRef(...)
		end
		return Swatter.origItemRef(...)
	end
end

function Swatter.ErrorShow()
	Swatter.Error.pos = table.getn(Swatter.errorOrder)
	Swatter.ErrorDisplay()
end

function Swatter.ErrorDisplay(id)
	if id then Swatter.Error.pos = id else id = Swatter.Error.pos end
	Swatter.ErrorUpdate()

	local errid = Swatter.errorOrder[id]
	if (not errid) then 
		Swatter.Error.curError = "Unknown error at position "..id
		Swatter.ErrorUpdate()
		return
	end
	local err = SwatterData.errors[errid]
	if (not err) then
		Swatter.Error.curError = "Unknown error at index "..errid
		Swatter.ErrorUpdate()
		return
	end
	
	local message = err.message:gsub("(.-):(%d+): ", "%1 line %2:\n   "):gsub("Interface(\\%w+\\)", "..%1"):gsub(": in function `(.-)`", ": %1"):gsub("|", "||")
	local trace = "   "..err.stack:gsub("Interface\\AddOns\\", ""):gsub("Interface(\\%w+\\)", "..%1"):gsub(": in function `(.-)'", ": %1()"):gsub(": in function <(.-)>", ":\n   %1"):gsub(": in main chunk ", ": "):gsub("\n", "\n   ")
	local count = err.count
	if (count > 999) then count = "\226\136\158" --[[Infinity]] end

	Swatter.Error.curError = "Error occured in: "..(err.context or "Anonymous").."\nCount: "..count.."\nMessage: "..message.."\n".."Debug:\n"..trace.."\n"
	Swatter.ErrorUpdate()
	Swatter.Error:Show()
end


function Swatter.ErrorDone()
	Swatter.Error:Hide()
end

function Swatter.ErrorPrev()
	local cur = Swatter.Error.pos or 1
	if (cur > 1) then
		Swatter.ErrorDisplay(cur - 1)
	else
		Swatter.ErrorUpdate()
	end
end

function Swatter.ErrorNext()
	local cur = Swatter.Error.pos or 1
	local max = table.getn(Swatter.errorOrder) or 0
	if (cur < max) then
		Swatter.ErrorDisplay(cur + 1)
	else
		Swatter.ErrorUpdate()
	end
end

function Swatter.UpdateNextPrev()
	local cur = Swatter.Error.pos or 1
	local max = table.getn(Swatter.errorOrder) or 0
	if (max > cur) then Swatter.Error.Next:Enable() else Swatter.Error.Next:Disable() end
	if (cur > 1) then Swatter.Error.Prev:Enable() else Swatter.Error.Prev:Disable() end
end

function Swatter.ErrorUpdate()
	if (not Swatter.Error.curError) then Swatter.Error.curError = "" end
	Swatter.Error.Box:SetText(Swatter.Error.curError)
	Swatter.Error.Scroll:UpdateScrollChildRect()
	Swatter.Error.Box:ClearFocus()
	Swatter.UpdateNextPrev()
end

-- Create our error message frame
Swatter.Error = CreateFrame("Frame", "", UIParent)
Swatter.Error:Hide()
Swatter.Error:SetPoint("CENTER", "UIParent", "CENTER")
Swatter.Error:SetFrameStrata("DIALOG")
Swatter.Error:SetHeight(280)
Swatter.Error:SetWidth(500)
Swatter.Error:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 9, right = 9, top = 9, bottom = 9 }
})
Swatter.Error:SetBackdropColor(0,0,0, 0.8)
Swatter.Error:SetScript("OnShow", Swatter.ErrorShow)

Swatter.Error.Done = CreateFrame("Button", "", Swatter.Error, "OptionsButtonTemplate")
Swatter.Error.Done:SetText("Close")
Swatter.Error.Done:SetPoint("BOTTOMRIGHT", Swatter.Error, "BOTTOMRIGHT", -10, 10)
Swatter.Error.Done:SetScript("OnClick", Swatter.ErrorDone)

Swatter.Error.Next = CreateFrame("Button", "", Swatter.Error, "OptionsButtonTemplate")
Swatter.Error.Next:SetText("Next >")
Swatter.Error.Next:SetPoint("BOTTOMRIGHT", Swatter.Error.Done, "BOTTOMLEFT", -5, 0)
Swatter.Error.Next:SetScript("OnClick", Swatter.ErrorNext)

Swatter.Error.Prev = CreateFrame("Button", "", Swatter.Error, "OptionsButtonTemplate")
Swatter.Error.Prev:SetText("< Prev")
Swatter.Error.Prev:SetPoint("BOTTOMRIGHT", Swatter.Error.Next, "BOTTOMLEFT", -5, 0)
Swatter.Error.Prev:SetScript("OnClick", Swatter.ErrorPrev)

Swatter.Error.Scroll = CreateFrame("ScrollFrame", "SwatterErrorInputScroll", Swatter.Error, "UIPanelScrollFrameTemplate")
Swatter.Error.Scroll:SetPoint("TOPLEFT", Swatter.Error, "TOPLEFT", 20, -20)
Swatter.Error.Scroll:SetPoint("RIGHT", Swatter.Error, "RIGHT", -30, 0)
Swatter.Error.Scroll:SetPoint("BOTTOM", Swatter.Error.Done, "TOP", 0, 10)

Swatter.Error.Box = CreateFrame("EditBox", "SwatterErrorEditBox", Swatter.Error.Scroll)
Swatter.Error.Box:SetWidth(450)
Swatter.Error.Box:SetHeight(85)
Swatter.Error.Box:SetMultiLine(true)
Swatter.Error.Box:SetAutoFocus(false)
Swatter.Error.Box:SetFontObject(GameFontHighlight)
Swatter.Error.Box:SetScript("OnEscapePressed", Swatter.ErrorDone)
Swatter.Error.Box:SetScript("OnTextChanged", Swatter.ErrorUpdate)

Swatter.Error.Scroll:SetScrollChild(Swatter.Error.Box)

seterrorhandler(Swatter.OnError)
Swatter.Frame = CreateFrame("Frame")
Swatter.Frame:Show()
Swatter.Frame:SetScript("OnEvent", Swatter.OnEvent)
Swatter.Frame:RegisterEvent("ADDON_LOADED")
Swatter.Frame:RegisterEvent("ADDON_ACTION_FORBIDDEN")
Swatter.Frame:RegisterEvent("ADDON_ACTION_BLOCKED")
SetItemRef = Swatter.SetItemRef

UIParent:UnregisterEvent("ADDON_ACTION_FORBIDDEN")
UIParent:UnregisterEvent("ADDON_ACTION_BLOCKED")

SLASH_SWATTER1 = "/swatter"
SLASH_SWATTER2 = "/swat"
SlashCmdList["SWATTER"] = function(msg)
	if (not msg or msg == "" or msg == "help") then
		chat("Swatter help:")
		chat("  /swat enable    -  Enables swatter")
		chat("  /swat disable   -  Disables swatter")
		chat("  /swat show      -  Shows the last error box again")
		chat("  /swat autoshow  -  Enables swatter autopopup upon error")
		chat("  /swat noauto    -  Swatter will only show an error in chat")
	elseif (msg == "show") then
		Swatter.Error:Show()
	elseif (msg == "enable") then
		SwatterData.enabled = true
		chat("Swatter will now catch errors")
	elseif (msg == "disable") then
		SwatterData.enabled = false
		chat("Swatter will no longer catch errors")
	elseif (msg == "autoshow") then
		SwatterData.autoshow = true
		chat("Swatter will popup the first time it sees an error")
	elseif (msg == "noautoshow") then
		SwatterData.autoshow = false
		chat("Swatter will print into chat instead of popping up")
	end
end

