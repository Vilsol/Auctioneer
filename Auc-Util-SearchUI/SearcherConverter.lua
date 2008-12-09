--[[
	Auctioneer Advanced - Search UI - Searcher Converter
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://auctioneeraddon.com/

	This is a plugin module for the SearchUI that assists in searching by refined paramaters

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
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]
-- Create a new instance of our lib with our parent
local lib, parent, private = AucSearchUI.NewSearcher("Converter")
if not lib then return end
local print,decode,_,_,replicate,empty,_,_,_,debugPrint,fill = AucAdvanced.GetModuleLocals()
local get,set,default,Const = AucSearchUI.GetSearchLocals()
lib.tabname = "Converter"

-- Set our constants
--Essences
local GCOSMIC = 34055
local GPLANAR = 22446
local GETERNAL = 16203
local GNETHER = 11175
local GMYSTIC = 11135
local GASTRAL = 11082
local GMAGIC = 10939
local LCOSMIC = 34056
local LPLANAR = 22447
local LETERNAL = 16202
local LNETHER = 11174
local LMYSTIC = 11134
local LASTRAL = 10998
local LMAGIC = 10938
--Motes/Primals
local PAIR = 22451
local MAIR = 22572
local PEARTH= 22452
local MEARTH = 22573
local PFIRE = 21884
local MFIRE = 22574
local PLIFE = 21886
local MLIFE = 22575
local PMANA = 22457
local MMANA = 22576
local PSHADOW = 22456
local MSHADOW = 22577
local PWATER = 21885
local MWATER = 22578
--Depleted items
local DCBRACER = 32676 -- Depleted Cloth Bracers
local DCBRACERTO = 32655 -- Crystalweave Bracers
local DMGAUNTLETS = 32675 -- Depleted Mail Gauntlets
local DMGAUNTLETSTO = 32656 -- Crystalhide Handwraps
local DBADGE = 32672 -- Depleted Badge
local DBADGETO = 32658 -- Badge of Tenacity
local DCLOAK = 32677 -- Depleted Cloak
local DCLOAKTO = 32665 -- Crystalweave Cape
local DDAGGER = 32673 -- Depleted Dagger
local DDAGGERTO = 32659	-- Crystal-Infused Shiv
local DMACE = 32671 -- Depleted Mace
local DMACETO = 32661 -- Apexis Crystal Mace
local DRING = 32678 -- Depleted Ring
local DRINGTO = 32664 -- Dreamcrystal Band
local DSTAFF = 32679 -- Depleted Staff
local DSTAFFTO = 32662 -- Flaming Quartz Staff
local DSWORD = 32674 -- Depleted Sword
local DSWORDTO = 32660 -- Crystalforged Sword
local DTHAXE = 32670 -- Depleted Two-Handed Axe
local DTHAXETO = 32663 -- Apexis Cleaver

-- Build a table to do all our work
-- findConvertable[itemID] = {conversionID, yield, checkstring}
local findConvertable = {}
do
	-- Temporary tables to help build the working table
	-- To add new conversions, edit these tables
	local lesser2greater = {
		[LCOSMIC] = GCOSMIC,
		[LPLANAR] = GPLANAR,
		[LETERNAL] = GETERNAL,
		[LNETHER] = GNETHER,
		[LMYSTIC] = GMYSTIC,
		[LASTRAL] = GASTRAL,
		[LMAGIC] = GMAGIC,
	}
	local greater2lesser = {
		[GCOSMIC] = LCOSMIC,
		[GPLANAR] = LPLANAR,
		[GETERNAL] = LETERNAL,
		[GNETHER] = LNETHER,
		[GMYSTIC] = LMYSTIC,
		[GASTRAL] = LASTRAL,
		[GMAGIC] = LMAGIC,
	}
	local mote2primal = {
		[MAIR] = PAIR,
		[MEARTH] = PEARTH,
		[MFIRE] = PFIRE,
		[MLIFE] = PLIFE,
		[MMANA] = PMANA,
		[MSHADOW] = PSHADOW,
		[MWATER] = PWATER,
	}
	local depleted2enhanced = {
		[DCBRACER] = DCBRACERTO,
		[DMGAUNTLETS] = DMGAUNTLETSTO,
		[DBADGE] = DBADGETO,
		[DCLOAK] = DCLOAKTO,
		[DDAGGER] = DDAGGERTO,
		[DMACE] = DMACETO,
		[DRING] = DRINGTO,
		[DSTAFF] = DSTAFFTO,
		[DSWORD] = DSWORDTO,
		[DTHAXE] = DTHAXETO,
	}
	--[[ placeholder for future development - not sure how this will work yet...
	-- Trade Professions need to be handled differently as yields may vary
	local smelt = {
		[10] = {
			[PEARTH] = MEARTH,
			[PFIRE] = MFIRE,
		},
	}
	--]]

	-- Build the table
	for id, idto in pairs (lesser2greater) do
		findConvertable[id] = {idto, 1/3, "converter.enableEssence"}
	end
	for id, idto in pairs (greater2lesser) do
		findConvertable[id] = {idto, 3, "converter.enableEssence"}
	end
	for id, idto in pairs (mote2primal) do
		findConvertable[id] = {idto, 0.1, "converter.enableMote"}
	end
	for id, idto in pairs (depleted2enhanced) do
		findConvertable[id] = {idto, 0.1, "converter.enableDepleted"}
	end

	-- delete temp tables (actually should not be needed as we're inside a do chunk, but just to be sure...)
	lesser2greater = nil
	greater2lesser = nil
	mote2primal = nil
	depleted2enhanced = nil
end

default("converter.profit.min", 1)
default("converter.profit.pct", 50)
default("converter.adjust.brokerage", true)
default("converter.adjust.deposit", true)
default("converter.adjust.deplength", 48)
default("converter.adjust.listings", 3)
default("converter.allow.bid", true)
default("converter.allow.buy", true)
default("converter.matching.check", true)
default("converter.buyout.check", true)
default("converter.enableEssence", true)
default("converter.enableMote", true)
default("converter.enableDepleted", true)

-- This function is automatically called when we need to create our search parameters
function lib:MakeGuiConfig(gui)
	-- Get our tab and populate it with our controls
	local id = gui:AddTab(lib.tabname, "Searchers")

	-- Add the help
	gui:AddSearcher("Converter", "Search for items which can be converted into other items for profit (essences, motes, etc)", 100)
	gui:AddHelp(id, "converter searcher",
		"What does this searcher do?",
		"This searcher provides the ability to search for items that can be converted to another item which is worth more money.")

	gui:AddControl(id, "Header",     0,      "Converter search criteria")
	local last = gui:GetLast(id)

	gui:AddControl(id, "MoneyFramePinned",  0, 1, "converter.profit.min", 1, 99999999, "Minimum Profit")
	gui:AddControl(id, "Slider",            0, 1, "converter.profit.pct", 1, 100, .5, "Min Discount: %0.01f%%")

	gui:AddControl(id, "Subhead",           0,   "Include in search")
	gui:AddControl(id, "Checkbox",          0, 1, "converter.enableEssence", "Essence: Greater <> Lesser")
	gui:AddControl(id, "Checkbox",          0, 1, "converter.enableMote", "Mote > Primal")
	gui:AddControl(id, "Checkbox",          0, 1, "converter.enableDepleted", "Depleted Items")
	gui:AddTip(id, "Warning: if you don't know about depleted items leave off!")

	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",          0.42, 1, "converter.allow.bid", "Allow Bids")
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",          0.56, 1,  "converter.allow.buy", "Allow Buyouts")

	gui:AddControl(id, "Subhead",           0.42,    "Fees Adjustment")
	gui:AddControl(id, "Checkbox",          0.42, 1, "converter.adjust.brokerage", "Subtract auction fees")
	gui:AddControl(id, "Checkbox",          0.42, 1, "converter.adjust.deposit", "Subtract deposit cost")
	gui:AddControl(id, "Selectbox",			0.42, 1, AucSearchUI.AucLengthSelector, "converter.adjust.deplength", "Length of auction for deposits")
	gui:AddControl(id, "Slider",            0.42, 1, "converter.adjust.listings", 1, 10, .1, "Ave relistings: %0.1fx")

	gui:AddControl(id, "Subhead",           0.42,  "Appraiser Value Origination")
	gui:AddControl(id, "Checkbox",          0.42, 1, "converter.matching.check", "Use Market Matched")
	gui:AddControl(id, "Checkbox",          0.42, 1, "converter.buyout.check", "Use buyout not bid")

	gui:SetLast(id, last)
end

function lib.Search (item)
	local convert = findConvertable[item[Const.ITEMID]]
	if not convert then
		return false, "Item not convertable"
	end
	
	local newID, yield, test = unpack(convert)
	if not get(test) then
		return false, "Category disabled"
	end
	
	local market, bid, buy
	local count = item[Const.COUNT] * yield
	
	-- todo: add option to use other market models; make Appraiser an optional dependancy, not required
	buy, bid = AucAdvanced.Modules.Util.Appraiser.GetPrice(newID, nil, get("converter.matching.check"))
	market = (get("converter.buyout.check") and buy or bid or buy) * count
	
	-- todo: better Neutral AH detection
	--adjust for brokerage/deposit costs
	local cutRate = AucAdvanced.cutRate or 0.05
	if get("converter.adjust.brokerage") then
		market = market * (1 - cutRate)
	end
	if get("converter.adjust.deposit") then
		local newfaction
		if cutRate ~= 0.05 then newfaction = "neutral" end
		-- note: GetDepositCost calls GetSellValue API, which handles numerical itemIDs (prefers them actually)
		local amount = GetDepositCost(newID, get("converter.adjust.deplength"), newfaction, count)
		if amount then
			market = market - amount * get("converter.adjust.listings")
		end
	end
	
	local value = min (market*(100-get("converter.profit.pct"))/100, market-get("converter.profit.min"))
	
	--Return bid or buy if item is below the searchers evaluated value
	if get("converter.allow.buy") and (item[Const.BUYOUT] > 0) and (item[Const.BUYOUT] <= value) then
		return "buy", market
	elseif get("converter.allow.bid") and (item[Const.PRICE] <= value) then
		return "bid", market
	end
	return false, "Not enough profit"
end

AucAdvanced.RegisterRevision("$URL$", "$Rev$")
