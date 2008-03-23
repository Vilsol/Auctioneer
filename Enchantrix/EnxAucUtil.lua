--[[
	Enchantrix Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://enchantrix.org/

	This is an addon for World of Warcraft that add a list of what an item
	disenchants into to the items that you mouse-over in the game.

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

-- Provide fixed price data by registering ourselves as a bonafide legitimate AuctioneerAdvanced module.

if (not AucAdvanced) then return end

local lib = {}
Enchantrix.AucUtil = lib
AucAdvanced.Modules.Util.Enchantrix = lib

local print = AucAdvanced.Print
local acquire = AucAdvanced.Acquire
local recycle = AucAdvanced.Recycle

local get = Enchantrix.Settings.GetSetting

function lib.GetName() return "Enchantrix" end

local priceTable = {}
local priceTableAge
function lib.IsValidAlgorithm(hyperlink)
	if not get("export.aucadv") then return false end
    
    if get("ScanValueType") == "adv:stat:appraiser" then return false end  -- Stops infinite loop from using Appraiser prices which uses Market Price which uses Enchantrix.

	local linkType,itemId,property,factor = AucAdvanced.DecodeLink(hyperlink)
	if (linkType ~= "item") then return false end

	if Enchantrix.Constants.StaticPrices[itemId] then
		return true, itemId
	end
	return false
end

local array
function lib.GetPriceArray(link)
	local usable, itemId = lib.IsValidAlgorithm(link)
    if not usable then return end
	if array then recycle(array) end
	array = acquire()

	if not priceTableAge or priceTableAge < GetTime() - 15 then
		priceTable = Enchantrix.Util.CreateReagentPricingTable(priceTable)
		priceTableAge = GetTime()
	end

	array.price = priceTable[itemId]
	array.seen = 0
	array.confidence = 1
	return array
end
