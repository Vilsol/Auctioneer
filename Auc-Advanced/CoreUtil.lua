--[[
	Auctioneer Advanced
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds statistical history to the auction data that is collected
	when the auction is scanned, so that you can easily determine what price
	you will be able to sell an item for at auction or at a vendor whenever you
	mouse-over an item in the game

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
local lib = AucAdvanced
local private = {}

function lib.Print(...)
	local output, part
	for i=1, select("#", ...) do
		part = select(i, ...)
		part = tostring(part):gsub("{{", "|cffddeeff"):gsub("}}", "|r")
		if (output) then output = output .. " " .. part
		else output = part end
	end
	DEFAULT_CHAT_FRAME:AddMessage(output, 0.3, 0.9, 0.8)
end

local function breakHyperlink(match, matchlen, ...)
	local v
	local n = select("#", ...)
	for i = 2, n do
		v = select(i, ...)
		if (v:sub(1,matchlen) == match) then
			return strsplit(":", v:sub(2))
		end
	end
end
lib.breakHyperlink = breakHyperlink
lib.BreakHyperlink = breakHyperlink

function lib.GetFactor(suffix, seed)
	if (suffix < 0) then
		return bit.band(seed, 65535)
	end
	return 0
end

function lib.DecodeLink(link)
	local vartype = type(link)
	if (vartype == "string") then
		local lType,id,enchant,gem1,gem2,gem3,gemBonus,suffix,seed = breakHyperlink("Hitem:", 6, strsplit("|", link))
		if (lType ~= "item") then return end
		id = tonumber(id) or 0
		enchant = tonumber(enchant) or 0
		suffix = tonumber(suffix) or 0
		seed = tonumber(seed) or 0
		local factor = lib.GetFactor(suffix, seed)
		return lType, id, suffix, factor, enchant, seed
	elseif (vartype == "number") then
		return "item", link, 0, 0, 0, 0
	end
	return
end

function lib.GetFaction()
	local realmName = GetRealmName()
	local currentZone = GetMinimapZoneText()
	local factionGroup = lib.GetFactionGroup()
	if not factionGroup then return end

	if (factionGroup == "Neutral") then
		AucAdvanced.cutRate = 0.15
		AucAdvanced.depositRate = 0.25
	else
		AucAdvanced.cutRate = 0.05
		AucAdvanced.depositRate = 0.05
	end
	AucAdvanced.curFaction = realmName.."-"..factionGroup
	return AucAdvanced.curFaction, realmName, factionGroup
end

function lib.GetFactionGroup()
	local currentZone = GetMinimapZoneText()
	local factionGroup = UnitFactionGroup("player")

	if not AucAdvancedConfig.factions then AucAdvancedConfig.factions = {} end
	if AucAdvancedConfig.factions[currentZone] then
		factionGroup = AucAdvancedConfig.factions[currentZone]
	else
		SetMapToCurrentZone()
		local map = GetMapInfo()
		if ((map == "Taneris") or (map == "Winterspring") or (map == "Stranglethorn")) then
			factionGroup = "Neutral"
		end
	end
	AucAdvancedConfig.factions[currentZone] = factionGroup
	return factionGroup
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

function lib.AddTab(tabButton, tabFrame)
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

	-- If we inserted a tab in the middle, adjust the layout of the next tab button.
	if (tabIndex < tabCount) then
		nextTabButton = getglobal("AuctionFrameTab"..(tabIndex + 1));
		nextTabButton:SetPoint("TOPLEFT", tabButton:GetName(), "TOPRIGHT", -8, 0);
	end

	-- Update the tab count.
	PanelTemplates_SetNumTabs(AuctionFrame, tabCount)
end

local LibRecycle = LibStub("LibRecycle")

lib.Recycle = LibRecycle.Recycle
lib.Acquire = LibRecycle.Acquire
lib.Clone = LibRecycle.Clone
lib.Scrub = LibRecycle.Scrub


--[[
Functions for establishing a new copy of the library.
Recommended method:

  local libType, libName = "myType", "myName"
  local lib,parent,private = AucAdvanced.NewModule(libType, libName)
  if not lib then return end
  local print,decode,recycle,acquire,clone,scrub,get,set,default = AucAdvanced.GetModuleLocals()

--]]

--[[

Usage:
  local lib,parent,private = AucAdvanced.NewModule(libType, libName)

--]]
local moduleKit = {}
function lib.NewModule(libType, libName)
	assert(lib.Modules[libType], "Invalid AucAdvanced libType specified: "..tostring(libType))

	if not lib.Modules[libType][libName] then
		local module = {}
		local private = {}
		module.libType = libType
		module.libName = libName
		module.Private = private
		module.GetName = function() return libName end
		for k,v in pairs(moduleKit) do
			module[k] = v
		end

		lib.Modules[libType][libName] = module
		return module, lib, private
	end
end

--[[

Usage:
  local libCopy = AucAdvanced.GetModule(libType, libName)

--]]
function lib.GetModule(libType, libName)
	assert(lib.Modules[libType], "Invalid AucAdvanced libType specified: "..tostring(libType))
	
	if lib.Modules[libType][libName] then
		return lib.Modules[libType][libName], lib, private
	end
end

--[[

Usage:
  local print,decode,recycle,acquire,clone,scrub,get,set,default = AucAdvanced.GetModuleLocals()

-- ]]
function lib.GetModuleLocals()
	return lib.Print, lib.DecodeLink,
	lib.Recycle, lib.Acquire, lib.Clone, lib.Scrub,
	lib.Settings.GetSetting, lib.Settings.SetSetting, lib.Settings.SetDefault
end

