--[[
	Enchantrix Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$

	Minimap Icon

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
Enchantrix_RegisterRevision("$URL$", "$Rev$")

local settings = Enchantrix.Settings
local miniIcon = CreateFrame("Button", "", Minimap);
Enchantrix.MiniIcon = miniIcon

miniIcon:SetToplevel(true)
miniIcon:SetMovable(true)
miniIcon:SetFrameStrata("LOW")
miniIcon:SetWidth(20)
miniIcon:SetHeight(20)
miniIcon:SetPoint("RIGHT", Minimap, "LEFT", 0,0)
miniIcon:Hide()
miniIcon.icon = miniIcon:CreateTexture("", "BACKGROUND")
miniIcon.icon:SetTexture("Interface\\AddOns\\Enchantrix\\Skin\\EnxOrb")
miniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
miniIcon.icon:SetWidth(20)
miniIcon.icon:SetHeight(20)
miniIcon.icon:SetPoint("TOPLEFT", miniIcon, "TOPLEFT", 0,0)
miniIcon.mask = miniIcon:CreateTexture("", "OVERLAY")
miniIcon.mask:SetTexCoord(0.0, 0.6, 0.0, 0.6)
miniIcon.mask:SetTexture("Interface\\Minimap\\Minimap-TrackingBorder")
miniIcon.mask:SetWidth(36)
miniIcon.mask:SetHeight(36)
miniIcon.mask:SetPoint("TOPLEFT", miniIcon, "TOPLEFT", -8,8)


local function mouseDown()
	miniIcon.icon:SetTexCoord(0, 1, 0, 1)
end
local function mouseUp()
	miniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
end

local moving = false
local function dragStart()
	moving = true
end
local function dragStop()
	miniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
	moving = false
end

local function click(obj, button)
	if (button == "LeftButton") then
		CastSpellByName("Enchanting")
	elseif (button == "RightButton") then
		settings.MakeGuiConfig()
		local gui = settings.Gui
		if (gui:IsVisible()) then
			gui:Hide()
		else
			gui:Show()
		end
	end
end

local function reposition(angle)
	if (not settings.GetSetting("miniicon.enable")) then
		miniIcon:Hide()
		return
	end
	miniIcon:Show()
	if (not angle) then angle = settings.GetSetting("miniicon.angle") or 0.5
	else settings.SetSetting("miniicon.angle", angle) end
	angle = angle
	local distance = settings.GetSetting("miniicon.distance")

	local width,height = Minimap:GetWidth()/2, Minimap:GetHeight()/2
	width = width+distance
	height = height+distance

	local iconX, iconY
	iconX = width * cos(angle)
	iconY = height * sin(angle)

	miniIcon:ClearAllPoints()
	miniIcon:SetPoint("CENTER", Minimap, "CENTER", iconX, iconY)
end
miniIcon.Reposition = reposition

local function update()
	if moving then
		local curX, curY = GetCursorPosition()
		local miniX, miniY = Minimap:GetCenter()
		miniX = miniX * Minimap:GetEffectiveScale()
		miniY = miniY * Minimap:GetEffectiveScale()

		local relX = miniX - curX
		local relY = miniY - curY
		local angle = math.deg(math.atan2(relY, relX)) + 180

		reposition(angle)
	end
end

miniIcon:RegisterForClicks("LeftButtonUp","RightButtonUp")
miniIcon:RegisterForDrag("LeftButton")
miniIcon:SetScript("OnMouseDown", mouseDown)
miniIcon:SetScript("OnMouseUp", mouseUp)
miniIcon:SetScript("OnDragStart", dragStart)
miniIcon:SetScript("OnDragStop", dragStop)
miniIcon:SetScript("OnClick", click)
miniIcon:SetScript("OnUpdate", update)

if (DongleStub) then
	local nSideBar = DongleStub("nSideBar-0.1")
	if nSideBar then
		Enchantrix.SideIcon = nSideBar.AddButton("Enchantrix", "Interface\\AddOns\\Enchantrix\\Skin\\EnxOrb")
		Enchantrix.SideIcon:RegisterForClicks("LeftButtonUp","RightButtonUp")
		Enchantrix.SideIcon:SetScript("OnClick", click)
	end
end
