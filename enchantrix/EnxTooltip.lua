--[[
	Enchantrix Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$

	Tooltip functions.

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

-- Global functions
local addonLoaded	-- Enchantrix.Tooltip.AddonLoaded()
local tooltipFormat	-- Enchantrix.Tooltip.Format

-- Local functions
local itemTooltip
local enchantTooltip
local hookTooltip

function addonLoaded()
	-- Hook in new tooltip code
	Stubby.RegisterFunctionHook("EnhTooltip.AddTooltip", 400, hookTooltip)
end

tooltipFormat = {
	currentFormat = "fancy",
	format = {
		["fancy"] = {
			-- counts = off
			['off'] = "  $conf% |q$name|r $rate",
			-- counts = on
			['on'] = "  $conf% |q$name|r $rate |e(B=$bcount L=$lcount)|r",
		},
		["default"] = {
			['off'] = "  $name: $prob% $rate",
			['on'] = "  $name: $prob% $rate |e(B=$bcount L=$lcount)|r",
		},
	},
	patterns = {
		-- Strings
		["$prob"]	= "",			-- Probability: "75"
		["$conf"]	= "",			-- Confidence interval: "<1", "72-78", ">99"
		["$count"]	= "",			-- Local + base counts: "51"
		["$lcount"] = "",			-- Local count: "13"
		["$bcount"] = "",			-- Base count: "38"
		["$name"]	= "",			-- Name: "Lesser Magic Essence"
		["$rate"]	= "",			-- Avg drop amount: "x1.5"
		-- Colors
		["|q"]		= "",			-- Quality color
		["|E"]		= "|cffcccc33",	-- Yellow ("Enchantrix" color)
		["|e"]		= "|cff7f7f00",	-- Dark yellow
		["|r"]		= "|r",			-- Reset color
	},
	SelectFormat = function(this, fmt)
		if this.format[fmt] then
			this.currentFormat = fmt
		else
			this.currentFormat = "default"
		end
	end,
	SetFormat = function(this, fmt, val, counts)
		if counts == nil then
			counts = Enchantrix.Config.GetFilter('counts')
		end
		if counts then
			this.format[fmt]['on'] = val
		else
			this.format[fmt]['off'] = val
		end
	end,
	GetFormat = function(this, fmt, counts)
		if not this.format[fmt] then return end
		if counts == nil then
			counts = Enchantrix.Config.GetFilter('counts')
		end
		if counts then
			return this.format[fmt]['on']
		else
			return this.format[fmt]['off']
		end
	end,
	GetString = function(this, counts)
		local line
		if counts == nil then
			counts = Enchantrix.Config.GetFilter('counts')
		end
		if counts then
			line = this.format[this.currentFormat]['on']
		else
			line = this.format[this.currentFormat]['off']
		end
		-- Replace patterns
		for pat, repl in pairs(this.patterns) do
			line = line:gsub(pat, repl or "")
		end
		return line
	end,
	SetPattern = function(this, pat, repl)
		this.patterns[pat] = repl
	end,
}


function itemTooltip(funcVars, retVal, frame, name, link, quality, count)
	local embed = Enchantrix.Config.GetFilter('embed')

	local data = Enchantrix.Storage.GetItemDisenchants(link)
	if not data then
		-- error message would have been printed inside GetItemDisenchants
		return
	end

	local lines

	local total = data.total
	local totalFive = {}
	local totalHSP, totalMed, totalMkt = 0,0,0
	if (total and total[1] > 0) then
		local totalNumber, totalQuantity = unpack(total)
		for result, resData in pairs(data) do
			if (result ~= "total") then
				if (not lines) then lines = {} end

				local resNumber, resQuantity = unpack(resData)
				local dName = Enchantrix.Util.GetReagentInfo(result);
				if (not dName) then dName = "Item "..result end
				local hsp, med, mkt, five = Enchantrix.Util.GetReagentPrice(result)
				local resProb, resCount = resNumber/totalNumber, resQuantity/resNumber
				local resHSP, resMed, resMkt = (hsp or 0)*resProb, (med or 0)*resProb, (mkt or 0)*resProb
				if (five) then
					for engine, price in pairs(five) do
						totalFive[engine] = (totalFive[engine] or 0) + ((price or 0) * resProb)
					end
				end
				totalHSP = totalHSP + resHSP
				totalMed = totalMed + resMed
				totalMkt = totalMkt + resMkt

				local prob = resProb
				local pmin, pmax = Enchantrix.Util.ConfidenceInterval(prob, totalNumber)

				-- Probabilities
				prob, pmin, pmax = math.floor(prob * 100 + 0.5), math.floor(pmin * 100 + 0.5), math.floor(pmax * 100 + 0.5)
				tooltipFormat:SetPattern("$prob", tostring(prob))
				if pmin == 0 then
					tooltipFormat:SetPattern("$conf", "<"..max(pmax, 1))
				elseif pmax == 100 then
					tooltipFormat:SetPattern("$conf", ">"..min(pmin, 99))
				else
					if pmin ~= pmax then
						tooltipFormat:SetPattern("$conf", pmin.."-"..pmax)
					else
						tooltipFormat:SetPattern("$conf", tostring(prob))
					end
				end

				-- Counts
				tooltipFormat:SetPattern("$count", tostring(resQuantity))

				-- Name and quality
				local name, _, quality = Enchantrix.Util.GetReagentInfo(result)
				local _, _, _, color = GetItemQualityColor(quality or 0)
				tooltipFormat:SetPattern("|q", color or "|cffcccc33")
				tooltipFormat:SetPattern("$name", name)

				-- Rate
				if resCount ~= 1 then
					tooltipFormat:SetPattern("$rate", ("x%0.1f"):format(resCount))
				else
					tooltipFormat:SetPattern("$rate", "")
				end

				-- Store this line and sort key
				local line = tooltipFormat:GetString(Enchantrix.Config.GetFilter('counts'))
				table.insert(lines,  {str = line, sort = pmin})
			end
		end
	else
		return
	end

	-- Terse mode
	if Enchantrix.Config.GetFilter('terse') and not IsControlKeyDown() then
		if Enchantrix.Config.GetFilter('valuate-hsp') and totalHSP > 0 then
			EnhTooltip.AddLine(_ENCH('FrmtValueAuctHsp'), totalHSP, embed);
			EnhTooltip.LineColor(0.1,0.6,0.6);
		elseif Enchantrix.Config.GetFilter('valuate-median') and totalMed > 0 then
			EnhTooltip.AddLine(_ENCH('FrmtValueAuctMed'), totalMed, embed);
			EnhTooltip.LineColor(0.1,0.6,0.6);
		elseif Enchantrix.Config.GetFilter('valuate-val') and totalFive then
			for engine, price in pairs(totalFive) do
				EnhTooltip.AddLine(_ENCH('FrmtValueAuctVal').." ("..engine..")", price, embed);
				EnhTooltip.LineColor(0.1,0.6,0.6);
			end
		elseif Enchantrix.Config.GetFilter('valuate-baseline') and totalMkt > 0 then
			EnhTooltip.AddLine(_ENCH('FrmtValueMarket'), totalMkt, embed);
			EnhTooltip.LineColor(0.1,0.6,0.6);
		end
		return
	end

	-- Header
	local totalText = ""
	if (Enchantrix.Config.GetFilter('counts') and totalNumber) then
		totalText = (" |cff7f7f00(%d)|r"):format(totalNumber)
	end
	EnhTooltip.AddLine(_ENCH('FrmtDisinto')..totalText, nil, embed);
	EnhTooltip.LineColor(0.8,0.8,0.2);

	-- Sort in order of decreasing probability before adding to tooltip
	table.sort(lines, function(a, b) return a.sort > b.sort end)
	for n, line in ipairs(lines) do
		EnhTooltip.AddLine(line.str, nil, embed)
		EnhTooltip.LineColor(0.8, 0.8, 0.2);
		if n >= 5 then break end -- Don't add more than 5 lines
	end

	if (Enchantrix.Config.GetFilter('valuate')) then
		if (Enchantrix.Config.GetFilter('valuate-hsp') and totalHSP > 0) then
			EnhTooltip.AddLine(_ENCH('FrmtValueAuctHsp'), totalHSP, embed);
			EnhTooltip.LineColor(0.1,0.6,0.6);
		end
		if (Enchantrix.Config.GetFilter('valuate-median') and totalMed > 0) then
			EnhTooltip.AddLine(_ENCH('FrmtValueAuctMed'), totalMed, embed);
			EnhTooltip.LineColor(0.1,0.6,0.6);
		end
		if (Enchantrix.Config.GetFilter('valuate-baseline') and totalMkt > 0) then
			EnhTooltip.AddLine(_ENCH('FrmtValueMarket'), totalMkt, embed);
			EnhTooltip.LineColor(0.1,0.6,0.6);
		end
	end
end

local function getReagentsFromCraftFrame(craftIndex)
	local reagentList = {}

	local numReagents = GetCraftNumReagents(craftIndex)
	for i = 1, numReagents do
		local link = GetCraftReagentItemLink(craftIndex, i)
		if link then
			local hlink = EnhTooltip.HyperlinkFromLink(link)
			local reagentName, reagentTexture, reagentCount, playerReagentCount = GetCraftReagentInfo(craftIndex, i)
			table.insert(reagentList, {hlink, reagentCount})
		end
	end

	return reagentList
end

local function getReagentsFromTooltip(frame)
	local frameName = frame:GetName()
	local nLines = frame:NumLines()
	local reagents
	-- Find reagents line ("Reagents: ...")
	for i = 1, nLines do
		local text = getglobal(frameName.."TextLeft"..i):GetText()

		-- text:find("Reagents: (.+)")
		local _, _, r = text:find(_ENCH('PatReagents'))
		if r then
			reagents = r
			break
		end
	end
	if not reagents then return end

	local reagentList = {}
	local name, quality, color, hlink
	-- Process reagents separated by ","
	for reagent in Enchantrix.Util.Spliterator(reagents, ",") do
		-- Chomp whitespace
		reagent = reagent:gsub("^%s*", "")
		reagent = reagent:gsub("%s*$", "")
		-- ...and color codes
		reagent = reagent:gsub("^%|c%x%x%x%x%x%x%x%x", "")
		reagent = reagent:gsub("%|r$", "")

		-- Get and chomp counts, e.g "Strange Dust (2)"
		local _, _, count = reagent:find("%((%d+)%)$")
		if count then
			reagent = reagent:gsub("%s*%(%d+%)$", "")
			count = tonumber(count)
		else
			count = 1
		end

		hlink = Enchantrix.Util.GetLinkFromName(reagent)
		if hlink then
			table.insert(reagentList, {hlink, count})
		else
			return
		end
	end

	return reagentList
end

function enchantTooltip(funcVars, retVal, frame, name, link)
	local embed = Enchantrix.Config.GetFilter('embed');

	local craftIndex
	for i = 1, GetNumCrafts() do
		local craftName = GetCraftInfo(i)
		if name == craftName then
			craftIndex = i
			break
		end
	end

	-- Get reagent list
	local reagentList
	if craftIndex then
		reagentList = getReagentsFromCraftFrame(craftIndex)
	else
		reagentList = getReagentsFromTooltip(frame)
	end

	if not reagentList or (#reagentList < 1) then
		return
	end

	-- Append additional reagent info
	for _, reagent in ipairs(reagentList) do
		local name, link, quality = Enchantrix.Util.GetReagentInfo(reagent[1])
		local hsp, median, market = Enchantrix.Util.GetReagentPrice(reagent[1])
		local _, _, _, color = GetItemQualityColor(quality)

		reagent[1] = name
		table.insert(reagent, quality)
		table.insert(reagent, color)
		table.insert(reagent, hsp)
	end

	local NAME, COUNT, QUALITY, COLOR, PRICE = 1, 2, 3, 4, 5

	-- Sort by rarity and price
	table.sort(reagentList, function(a,b)
		if (not b) or (not a) then return end
		return ((b[QUALITY] or -1) < (a[QUALITY] or -1)) or ((b[PRICE] or 0) < (a[PRICE] or 0))
	end)

	-- Header
	if not embed then
		local icon
		if craftIndex then
			icon = GetCraftIcon(craftIndex)
		else
			icon = "Interface\\Icons\\Spell_Holy_GreaterHeal"
		end
		EnhTooltip.SetIcon(icon)
		EnhTooltip.AddLine(name)
		EnhTooltip.AddLine(EnhTooltip.HyperlinkFromLink(link))
	end
	EnhTooltip.AddLine(_ENCH('FrmtSuggestedPrice'), nil, embed)
	EnhTooltip.LineColor(0.8,0.8,0.2)

	local price = 0
	local unknownPrices
	-- Add reagent list to tooltip and sum reagent prices
	for _, reagent in pairs(reagentList) do
		local line = "  "

		if reagent[COLOR] then
			line = line..reagent[COLOR]
		end
		line = line..reagent[NAME]
		if reagent[COLOR] then
			line = line.."|r"
		end
		line = line.." x"..reagent[COUNT]
		if reagent[COUNT] > 1 and reagent[PRICE] then
			line = line.." ".._ENCH('FrmtPriceEach'):format(EnhTooltip.GetTextGSC(Enchantrix.Util.Round(reagent[PRICE], 3)))
			EnhTooltip.AddLine(line, Enchantrix.Util.Round(reagent[PRICE] * reagent[COUNT], 3), embed)
			price = price + reagent[PRICE] * reagent[COUNT]
		elseif reagent[PRICE] then
			EnhTooltip.AddLine(line, Enchantrix.Util.Round(reagent[PRICE], 3), embed)
			price = price + reagent[PRICE]
		else
			EnhTooltip.AddLine(line, nil, embed)
			unknownPrices = true
		end
		EnhTooltip.LineColor(0.7,0.7,0.1)
	end


	-- Totals
	if price > 0 then

		EnhTooltip.AddLine(_ENCH('FrmtTotal'), Enchantrix.Util.Round(price, 2.5), embed)
		EnhTooltip.LineColor(0.8,0.8,0.2)

		if not Enchantrix.State.Auctioneer_Loaded then
			EnhTooltip.AddLine(_ENCH('FrmtWarnAuctNotLoaded'))
			EnhTooltip.LineColor(0.6,0.6,0.1)
		end

		if unknownPrices then
			EnhTooltip.AddLine(_ENCH('FrmtWarnPriceUnavail'))
			EnhTooltip.LineColor(0.6,0.6,0.1)
		end
	else
		EnhTooltip.AddLine(_ENCH('FrmtWarnNoPrices'))
		EnhTooltip.LineColor(0.6,0.6,0.1)
	end
end

function hookTooltip(funcVars, retVal, frame, name, link, quality, count)
	-- nothing to do, if enchantrix is disabled
	if (not Enchantrix.Config.GetFilter('all')) then
		return
	end

	local ltype = EnhTooltip.LinkType(link)
	if ltype == "item" then
		itemTooltip(funcVars, retVal, frame, name, link, quality, count)
	elseif ltype == "enchant" then
		enchantTooltip(funcVars, retVal, frame, name, link)
	end
end

Enchantrix.Tooltip = {
	Revision		= "$Revision$",

	AddonLoaded		= addonLoaded,
	Format			= tooltipFormat,
}
