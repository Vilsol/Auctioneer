--[[
	Auctioneer Advanced - StatDebug
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
--]]

local libType, libName = "Stat", "Debug"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local print,decode,recycle,acquire,clone,scrub,get,set,default = AucAdvanced.GetModuleLocals()

local data

function lib.CommandHandler(command, ...)
	local myFaction = AucAdvanced.GetFaction()
	if (command == "help") then
		print("Help for Auctioneer Advanced - "..libName)
		local line = AucAdvanced.Config.GetCommandLead(libType, libName)
		print(line, "help}} - this", libName, "help")
		print(line, "clear}} - clear current", myFaction, libName, "price database")
		print(line, "push}} - force the", myFaction, libName, "daily stats to archive (start a new day)")
	elseif (command == "clear") then
		print("Clearing Simple stats for {{", myFaction, "}}")
		private.ClearData()
	elseif (command == "push") then
		print("Archiving {{", myFaction, "}} daily stats and starting a new day")
		private.PushStats(myFaction)
	end
end

function lib.Processor(callbackType, ...)
	if (callbackType == "tooltip") then
		private.ProcessTooltip(...)
	elseif (callbackType == "config") then
		--Called when you should build your Configator tab.
		private.SetupConfigGui(...)
	elseif (callbackType == "load") then
		lib.OnLoad(...)
	end
end


lib.ScanProcessors = {}
function lib.ScanProcessors.create(operation, itemData, oldData)
	-- This function is responsible for processing and storing the stats after each scan
	-- Note: itemData gets reused over and over again, so do not make changes to it, or use
	-- it in places where you rely on it. Make a deep copy of it if you need it after this
	-- function returns.

	-- We're only interested in items with buyouts.
	local buyout = itemData.buyoutPrice
	if not buyout or buyout == 0 then return end
	local count = itemData.stackSize or 1
	if count < 1 then count = 1 end

	-- In this case, we're only interested in the initial create, other
	-- Get the signature of this item and find it's stats.
	local itemType, itemId, property, factor = AucAdvanced.DecodeLink(itemData.link)
	local id = strjoin(":", itemId, property, factor)

	local data = private.GetPriceData()
	if not data[id] then data[id] = {} end

	while (#data[id] >= 10) do table.remove(data[id], 1) end
	table.insert(data[id], buyout/count)
end

function lib.GetPrice(hyperlink)
	local linkType,itemId,property,factor = AucAdvanced.DecodeLink(hyperlink)
	if (linkType ~= "item") then return end

	local id = strjoin(":", itemId, property, factor)
	local data = private.GetPriceData()
	if not data then return end
	return unpack(data[id])
end

local array = {}
function lib.GetPriceArray(hyperlink)
	-- Clean out the old array
	while (#array > 0) do table.remove(array) end

	local linkType,itemId,property,factor = AucAdvanced.DecodeLink(hyperlink)
	if (linkType ~= "item") then return end

	local id = strjoin(":", itemId, property, factor)
	local data = private.GetPriceData()
	if not data then return end
	if not data[id] then return end

	array.seen = #data[id]
	array.price = data[id][array.seen]
	array.pricelist = data[id]

	-- Return a temporary array. Data in this array is
	-- only valid until this function is called again.
	return array
end

function lib.OnLoad(addon)

end

function lib.CanSupplyMarket()
	return false
end

AucAdvanced.Settings.SetDefault("stat.debug.tooltip", true)

function private.SetupConfigGui(gui)
	id = gui:AddTab(lib.libName, lib.libType.." Modules")
	--gui:MakeScrollable(id)
	
	gui:AddHelp(id, "what debug stats",
		"What are debug stats?",
		"Debug stats are the numbers that are generated by the debug module, these are used "..
		"to assist the developers in determining whether a stats module is working properly.\n\n"..
		""..
		"If you are not a developer, these numbers will not add any information that is "..
		"meaningful, and therefore, this should be unchecked.")
	
	gui:AddControl(id, "Header",     0,    libName.." options")
	gui:AddControl(id, "Checkbox",   0, 1, "stat.debug.tooltip", "Show debug stats in the tooltips?")
	gui:AddTip(id, "Toggle display of stats from the debug module on or off")
	
end

--[[ Local functions ]]--

function private.ProcessTooltip(frame, name, hyperlink, quality, quantity, cost)
	-- In this function, you are afforded the opportunity to add data to the tooltip should you so
	-- desire. You are passed a hyperlink, and it's up to you to determine whether or what you should
	-- display in the tooltip.
	
	if not AucAdvanced.Settings.GetSetting("stat.debug.tooltip") then return end

	if not quantity or quantity < 1 then quantity = 1 end
	local array = lib.GetPriceArray(hyperlink)
	if not array then
		EnhTooltip.AddLine("  Debug: No price data")
		EnhTooltip.LineColor(0.3, 0.9, 0.8)
		return
	end

	for i = 1, #array.pricelist do
		EnhTooltip.AddLine("  Debug "..i..":", array.pricelist[i])
		EnhTooltip.LineColor(0.3, 0.9, 0.8)
	end
end

local StatData

function private.LoadData()
	if (StatData) then return end
	if (not AucAdvancedStatDebugData) then AucAdvancedStatDebugData = {Version='1.0', Data = {}} end
	StatData = AucAdvancedStatDebugData
	private.DataLoaded()
end

function private.ClearData(faction, realmName)
	if (not StatData) then private.LoadData() end
	print("Clearing "..libName.." stats")
	StatData.Data =  {}
end

function private.GetPriceData()
	if (not StatData) then private.LoadData() end
	return StatData.Data
end

function private.DataLoaded()
	if (not StatData) then return end
end

AucAdvanced.RegisterRevision("$URL$", "$Rev$")