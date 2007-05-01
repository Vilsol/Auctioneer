﻿--[[

	Enchantrix v<%version%> (<%codename%>)
	$Id: EnchantrixBarker.lua 1748 2007-04-25 00:32:05Z luke1410 $

	By Norganna
	http://enchantrix.org/

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
EnchantrixBarker_RegisterRevision("$URL: http://norganna@norganna.org/svn/auctioneer/trunk5/enchantrix/EnchantrixBarker.lua $", "$Rev: 1748 $")

local priorityList = {};

local categories = { --TODO: Localize
	Bracer = {search = "Bracer", print = "Bracer" },
	Gloves = {search = "Gloves", print = "Gloves" },
	Boots = {search = "Boots", print = "Boots" },
	Shield = {search = "Shield", print = "Shield" },
	Chest = {search = "Chest", print = "Chest" },
	Cloak = {search = "Cloak", print = "Cloak" },
	TwoHanded = {search = "2H", print = "2H Weapon"},
	AnyWeapon = {search = "Enchant Weapon", print = "Any Weapon" }
};

local print_order = { --TODO: Localize
	'Bracer',
	'Gloves',
	'Boots',
	'Chest', 
	'Cloak', 
	'Shield', 
	'TwoHanded', 
	'AnyWeapon'
};

local attributes = { --TODO: Localize
	'intellect',
	'stamina',
	'spirit',
	'strength',
	'agility',
	'fire resistance',
	'resistance to fire',
	'frost resistance',
	'nature resistance',
	'resistance to shadow',
	'resistance',
	'all stats',
	'mana',
	'health',
	'additional armor',
	'additional points of armor',
	'increase armor',
	'increase its armor',
	'absorption',
	'damage to beasts',
	'points? of damage',
	'\+[0-9]+ damage',
	'defense'
};

local short_attributes = { --TODO: Localize
	'INT',
	'STA',
	'SPI',
	'STR',
	'AGI',
	'fire res',
	'fire res',
	'frost res',
	'nature res',
	'shadow res',
	'all res',
	'all stats',
	'mana',
	'health',
	'armour',
	'armour',
	'armour',
	'armour',
	'DMG absorb',
	'Beastslayer',
	'DMG',
	'DMG',
	'DEF'
};

local short_location = {
	[_BARKLOC('Orgrimmar')] = _BARKLOC('ShortOrgrimmar'),
	[_BARKLOC('ThunderBluff')] = _BARKLOC('ShortThunderBluff'), 
	[_BARKLOC('Undercity')] = _BARKLOC('ShortUndercity'),
	[_BARKLOC('StormwindCity')] = _BARKLOC('ShortStormwind'),
	[_BARKLOC('Darnassus')] = _BARKLOC('ShortDarnassus'),
	[_BARKLOC('Ironforge')] = _BARKLOC('ShortIronForge'),
	[_BARKLOC('Shattrath')] = _BARKLOC('ShortShattrath')
};

local config_defaults = {
	lowest_price = 5000,
	sweet_price = 50000,
	high_price = 500000,
	profit_margin = 10,
	highest_profit = 100000,
	randomise = 10,
	AnyWeapon = 100,
	TwoHanded = 90,
	Bracer = 70,
	Gloves = 70,
	Boots = 70,
	Chest = 70,
	Cloak = 70,
	Shield = 70,
	INT = 90,
	STA = 70,
	AGI = 70,
	STR = 70,
	SPI = 45,
	["all stats"] = 75,
	["all res"] = 55,
	armour = 65,
	["fire res"] = 85,
	["frost res"] = 85,
	["nature res"] = 85,
	["shadow res"] = 85,
	mana = 35,
	health = 40,
	DMG = 90,
	DEF = 60,
	other = 70,
	factor_price = 20,
	factor_item = 40,
	factor_stat = 40,
	barker_chan_default = _BARKLOC('ChannelDefault')
};

local relevelFrame;
local relevelFrames;

local addonName = "Enchantrix Barker"

-- UI code

function EnchantrixBarker_OnEvent()
	--Barker.Util.ChatPrint("GotUIEvent...");

	--Returns "Enchanting" for enchantwindow and nil for Beast Training
	local craftName, rank, maxRank = GetCraftDisplaySkillLine()

	if craftName then
		--Barker.Util.ChatPrint("Barker config is "..tostring(Barker.Settings.GetSetting('barker')) );
		if( event == "CRAFT_SHOW" ) then
			if( Barker.Settings.GetSetting('barker') ) then
--				Enchantrix_BarkerButton:Show();
--				Enchantrix_BarkerButton.tooltipText = 'Posts a sales message to the Trade channel, if available.'; --TODO: Localize

				Enchantrix_BarkerDisplayButton:Show();
				Enchantrix_BarkerDisplayButton.tooltipText = 'Opens the trade barker window.'; --TODO: Localize
			else
				Enchantrix_BarkerDisplayButton:Hide();
				Enchantrix_BarkerOptions_Frame:Hide();
			end
		elseif( event == "CRAFT_CLOSE" )then
			Enchantrix_BarkerDisplayButton:Hide();
			Enchantrix_BarkerOptions_Frame:Hide();
		--elseif(	event == "ZONE_CHANGED" ) then
		--	Enchantrix_BarkerOptions_ChanFilterDropDown_Initialize();
		end
	end
end

function Enchantrix_BarkerOptions_OnShow()
	Enchantrix_BarkerOptions_ShowFrame(1);
end

function Enchantrix_BarkerOnClick()
	local barker = Enchantrix_CreateBarker();
	local id = GetChannelName("Trade - City") --TODO: Localize
	Barker.Util.DebugPrintQuick("Attempting to send barker "..barker.." Trade Channel ID "..id)

	if (id and (not(id == 0))) then
		if (barker) then
			SendChatMessage(barker,"CHANNEL", GetDefaultLanguage("player"), id);
		end
	else
		Barker.Util.ChatPrint("Enchantrix: You aren't in a trade zone."); --TODO: Localize
	end
end

function Barker.Barker.AddonLoaded()
	Barker.Util.ChatPrint("Barker Loaded...");
end

function relevelFrame(frame)
	return relevelFrames(frame:GetFrameLevel() + 2, frame:GetChildren())
end

function relevelFrames(myLevel, ...)
	for i = 1, select("#", ...) do
		local child = select(i, ...)
		child:SetFrameLevel(myLevel)
		relevelFrame(child)
	end
end

local function craftUILoaded()

	Stubby.UnregisterAddOnHook("Blizzard_CraftUI", "Enchantrix")
	local useFrame = CraftFrame;
	
	if (ATSWFrame ~= nil) then
		Stubby.UnregisterAddOnHook("ATSWFrame", "Enchantrix")
		useFrame = ATSWFrame;
	end

	--Enchantrix_BarkerButton:SetParent(useFrame);
	--Enchantrix_BarkerButton:SetPoint("TOPRIGHT", useFrame, "TOPRIGHT", -185, -55 );

	Enchantrix_BarkerDisplayButton:SetParent(useFrame);
	--Enchantrix_BarkerDisplayButton:SetPoint("BOTTOMRIGHT", Enchantrix_BarkerButton, "BOTTOMLEFT");
	Enchantrix_BarkerDisplayButton:SetPoint("TOPRIGHT", useFrame, "TOPRIGHT", -185, -55 );

	Enchantrix_BarkerOptions_Frame:SetParent(useFrame);
	Enchantrix_BarkerOptions_Frame:SetPoint("TOPLEFT", useFrame, "TOPRIGHT");
	relevelFrame(Enchantrix_BarkerOptions_Frame)
end

function EnchantrixBarker_OnLoad()
	if (ATSWFrame ~= nil) then
		Stubby.RegisterAddOnHook("ATSWFrame", "Enchantrix", craftUILoaded)
	end
	Stubby.RegisterAddOnHook("Blizzard_CraftUI", "Enchantrix", craftUILoaded)
end

function Enchantrix_BarkerGetConfig( key )
	return Barker.Settings.GetSetting("barker."..key)
end

function Enchantrix_BarkerSetConfig( key, value )
	Barker.Settings.SetSetting("barker."..key, value)
end

function Enchantrix_BarkerOptions_SetDefaults()
	--Barker.Util.ChatPrint("Enchantrix: Setting Barker to defaults"); -- TODO: Localize
	Barker.Settings.SetSetting("barker.profit_margin", nil)
	Barker.Settings.SetSetting("barker.randomize", nil)
	Barker.Settings.SetSetting("barker.lowest_price", nil)

	if Enchantrix_BarkerOptions_Frame:IsVisible() then
		Enchantrix_BarkerOptions_Refresh()
	end
end

function Enchantrix_BarkerOptions_TestButton_OnClick()
	local barker = Enchantrix_CreateBarker();
	local id = GetChannelName("Trade - City") --TODO: Localize
	Barker.Util.DebugPrintQuick("Attempting to send test barker "..barker.."Trade Channel ID "..id)

	if (id and (not(id == 0))) then
		if (barker) then
			Barker.Util.ChatPrint(barker);
		end
	else
		Barker.Util.ChatPrint("Enchantrix: You aren't in a trade zone."); --TODO: Localize
	end
end

function Enchantrix_BarkerOptions_Factors_Slider_GetValue(id)
	if (not id) then
		id = this:GetID();
	end
	return Enchantrix_BarkerGetConfig(Enchantrix_BarkerOptions_TabFrames[Enchantrix_BarkerOptions_ActiveTab].options[id].key);
end

function Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged(id)
	if (not id) then
		id = this:GetID();
	end
	Enchantrix_BarkerSetConfig(Enchantrix_BarkerOptions_TabFrames[Enchantrix_BarkerOptions_ActiveTab].options[id].key, this:GetValue());
end

Enchantrix_BarkerOptions_ActiveTab = -1;

Enchantrix_BarkerOptions_TabFrames = { --TODO: Localize
	{
		title = _BARKLOC('BarkerOptionsTab1Title'),
		options = {
			{
				name = _BARKLOC('BarkerOptionsProfitMarginTitle'),
				tooltip = _BARKLOC('BarkerOptionsProfitMarginTooltip'),
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'profit_margin',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = _BARKLOC('BarkerOptionsHighestProfitTitle'),
				tooltip = _BARKLOC('BarkerOptionsHighestProfitTooltip'),
				units = 'money',
				min = 0,
				max = 250000,
				step = 500,
				key = 'highest_profit',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = _BARKLOC('BarkerOptionsLowestPriceTitle'),
				tooltip = _BARKLOC('BarkerOptionsLowestPriceTooltip'),
				units = 'money',
				min = 0,
				max = 50000,
				step = 500,
				key = 'lowest_price',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = _BARKLOC('BarkerOptionsPricePriorityTitle'),
				tooltip = _BARKLOC('BarkerOptionsPricePriorityTooltip'),
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_price',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = _BARKLOC('BarkerOptionsPriceSweetspotTitle'),
				tooltip = _BARKLOC('BarkerOptionsPriceSweetspotTooltip'),
				units = 'money',
				min = 0,
				max = 500000,
				step = 5000,
				key = 'sweet_price',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = _BARKLOC('BarkerOptionsHighestPriceForFactorTitle'),
				tooltip = _BARKLOC('BarkerOptionsHighestPriceForFactorTooltip'),
				units = 'money',
				min = 0,
				max = 1000000,
				step = 50000,
				key = 'high_price',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = _BARKLOC('BarkerOptionsRandomFactorTitle'),
				tooltip = _BARKLOC('BarkerOptionsRandomFactorTooltip'),
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'randomise',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			}
		}
	},
	{
		title = 'Item Priorities',
		options = {
			{
				name = 'Overall Items Priority',
				tooltip = 'This sets how important the item is to the overall priority for advertising.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_item',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = '2H Weapon',
				tooltip = 'The priority score for 2H weapon enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_item.2hweap',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Any Weapon',
				tooltip = 'The priority score for enchants to any weapon.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_item.weapon',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Bracer',
				tooltip = 'The priority score for bracer enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_item.bracer',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Gloves',
				tooltip = 'The priority score for glove enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_item.gloves',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Boots',
				tooltip = 'The priority score for boots enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_item.boots',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Chest',
				tooltip = 'The priority score for chest enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_item.chest',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Cloak',
				tooltip = 'The priority score for cloak enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_item.cloak',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Shield',
				tooltip = 'The priority score for shield enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_item.shield',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			}
		}
	},
	{
		title = 'Stats 1',
		options = {
			{
				name = 'Overall Stats Priority',
				tooltip = 'This sets how important the stat is to the overall priority for advertising.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Intellect',
				tooltip = 'The priority score for Intellect enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.int',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Strength',
				tooltip = 'The priority score for Strength enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.str',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Agility',
				tooltip = 'The priority score for Agility enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.agi',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Stamina',
				tooltip = 'The priority score for Stamina enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.sta',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Spirit',
				tooltip = 'The priority score for Spirit enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.spi',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Armour',
				tooltip = 'The priority score for Armour enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.arm',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'All Stats',
				tooltip = 'The priority score for enchants that increase all stats.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.all',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			}
		}
	},
	{
		title = 'Stats 2',
		options = {
			{
				name = 'All Resistances',
				tooltip = 'The priority score for enchants that boost all resistances.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.res',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Fire Resistance',
				tooltip = 'The priority score for Fire Resistance enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.fir',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Frost Resistance',
				tooltip = 'The priority score for Frost Resistance enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.frr',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Nature Resistance',
				tooltip = 'The priority score for Nature Resistance enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.nar',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Shadow Resistance',
				tooltip = 'The priority score for Shadow Resistance enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.shr',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Mana',
				tooltip = 'The priority score for Mana enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.mp',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Health',
				tooltip = 'The priority score for Health enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.hp',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Damage',
				tooltip = 'The priority score for Damage enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.dmg',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Defense',
				tooltip = 'The priority score for Defense enchants.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.def',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
			{
				name = 'Other',
				tooltip = 'The priority score for enchants such as skinning, mining, riding etc.',
				units = 'percentage',
				min = 0,
				max = 100,
				step = 1,
				key = 'factor_stat.ski',
				getvalue = Enchantrix_BarkerOptions_Factors_Slider_GetValue,
				valuechanged = Enchantrix_BarkerOptions_Factors_Slider_OnValueChanged
			},
		}
	}
};

function EnchantrixBarker_OptionsSlider_OnValueChanged()
	if Enchantrix_BarkerOptions_ActiveTab ~= -1 then
		--Barker.Util.ChatPrint( "Tab - Slider changed: "..Enchantrix_BarkerOptions_ActiveTab..' - '..this:GetID() );
		Enchantrix_BarkerOptions_TabFrames[Enchantrix_BarkerOptions_ActiveTab].options[this:GetID()].valuechanged();
		value = this:GetValue();
		--Enchantrix_BarkerOptions_TabFrames[Enchantrix_BarkerOptions_ActiveTab].options[this:GetID()].getvalue();

		valuestr = EnchantrixBarker_OptionsSlider_GetTextFromValue( value, Enchantrix_BarkerOptions_TabFrames[Enchantrix_BarkerOptions_ActiveTab].options[this:GetID()].units );

		getglobal(this:GetName().."Text"):SetText(Enchantrix_BarkerOptions_TabFrames[Enchantrix_BarkerOptions_ActiveTab].options[this:GetID()].name.." - "..valuestr );
	end
end

function EnchantrixBarker_OptionsSlider_GetTextFromValue( value, units )

	local valuestr = ''

	if units == 'percentage' then
		valuestr = value..'%'
	elseif units == 'money' then
		local p_gold,p_silver,p_copper = EnhTooltip.GetGSC(value);

		if( p_gold > 0 ) then
			valuestr = p_gold.."g";
		end
		if( p_silver > 0 ) then
			valuestr = valuestr..p_silver.."s";
		end
	end
	return valuestr;
end

function Enchantrix_BarkerOptions_Tab_OnClick()
	--Barker.Util.ChatPrint( "Clicked Tab: "..this:GetID() );
	Enchantrix_BarkerOptions_ShowFrame( this:GetID() )

end

function Enchantrix_BarkerOptions_Refresh()
	local cur = Enchantrix_BarkerOptions_ActiveTab
	if (cur and cur > 0) then
		Enchantrix_BarkerOptions_ShowFrame(cur)
	end
end

function Enchantrix_BarkerOptions_ShowFrame( frame_index )
	Enchantrix_BarkerOptions_ActiveTab = -1
	for index, frame in pairs(Enchantrix_BarkerOptions_TabFrames) do
		if ( index == frame_index ) then
			--Barker.Util.ChatPrint( "Showing Frame: "..index );
			for i = 1,10 do
				local slider = getglobal('EnchantrixBarker_OptionsSlider_'..i);
				slider:Hide();
			end
			for i, opt in pairs(frame.options) do
				local slidername = 'EnchantrixBarker_OptionsSlider_'..i
				local slider = getglobal(slidername);
				slider:SetMinMaxValues(opt.min, opt.max);
				slider:SetValueStep(opt.step);
				slider.tooltipText = opt.tooltip;
				getglobal(slidername.."High"):SetText();
				getglobal(slidername.."Low"):SetText();
				slider:Show();
			end
			Enchantrix_BarkerOptions_ActiveTab = index
			for i, opt in pairs(frame.options) do
				local slidername = 'EnchantrixBarker_OptionsSlider_'..i
				local slider = getglobal(slidername);
				local newValue = opt.getvalue(i);
				slider:SetValue(newValue);
				getglobal(slidername.."Text"):SetText(opt.name..' - '..EnchantrixBarker_OptionsSlider_GetTextFromValue(slider:GetValue(),opt.units));
			end
		end
	end
end

function Enchantrix_BarkerOptions_OnClick()
	--Barker.Util.ChatPrint("You pressed the options button." );
	--showUIPanel(Enchantrix_BarkerOptions_Frame);
	if not Enchantrix_BarkerOptions_Frame:IsShown() then
		Enchantrix_BarkerOptions_Frame:Show();
	else
		Enchantrix_BarkerOptions_Frame:Hide();
	end
end

function Enchantrix_CheckButton_OnShow()
end
function Enchantrix_CheckButton_OnClick()
end
function Enchantrix_CheckButton_OnEnter()
end
function Enchantrix_CheckButton_OnLeave()
end

--[[
function Enchantrix_BarkerOptions_ChanFilterDropDown_Initialize()

		local dropdown = this:GetParent();
		local frame = dropdown:GetParent();

		ChnPtyBtn		= {};
		ChnPtyBtn.text	= _BARKLOC('ChannelParty');
		ChnPtyBtn.func	= Enchantrix_BarkerOptions_ChanFilterDropDownItem_OnClick;
		ChnPtyBtn.owner	= dropdown
		UIDropDownMenu_AddButton(ChnPtyBtn)

		ChnRdBtn		= {};
	    ChnRdBtn.text	= _BARKLOC('ChannelRaid');
		ChnRdBtn.func	= Enchantrix_BarkerOptions_ChanFilterDropDownItem_OnClick;
		ChnRdBtn.owner	= dropdown
		UIDropDownMenu_AddButton(ChnRdBtn)

		ChnGldBtn		= {};
		ChnGldBtn.text	= _BARKLOC('ChannelGuild');
		ChnGldBtn.func	= Enchantrix_BarkerOptions_ChanFilterDropDownItem_OnClick;
		ChnGldBtn.owner	= dropdown
		UIDropDownMenu_AddButton(ChnGldBtn)

		ChnTlRBtn		= {};
		ChnTlRBtn.text	= _BARKLOC('ChannelTellRec');
		ChnTlRBtn.func	= Enchantrix_BarkerOptions_ChanFilterDropDownItem_OnClick;
		ChnTlRBtn.owner	= dropdown
		UIDropDownMenu_AddButton(ChnTlRBtn)

		ChnTlSBtn		= {};
		ChnTlSBtn.text	= _BARKLOC('ChannelTellSent');
		ChnTlSBtn.func	= Enchantrix_BarkerOptions_ChanFilterDropDownItem_OnClick;
		ChnTlSBtn.owner	= dropdown
		UIDropDownMenu_AddButton(ChnTlSBtn)

		ChnSayBtn		= {};
		ChnSayBtn.text	= _BARKLOC('ChannelSay');
		ChnSayBtn.func	= Enchantrix_BarkerOptions_ChanFilterDropDownItem_OnClick;
		ChnSayBtn.owner	= dropdown
		UIDropDownMenu_AddButton(ChnSayBtn)

		local chanlist = {GetChannelList()}; --GetChannelList can be buggy.
		local ZoneName = GetRealZoneText();

		for i = 1, table.getn(chanlist) do
			id, channame = GetChannelName(i);

			if ((channame) and  (channame ~= (_BARKLOC('ChannelGeneral')..ZoneName)) and 
			 (channame ~= (_BARKLOC('ChannelLocalDefense')..ZoneName)) and (channame ~= _BARKLOC('ChannelWorldDefense')) and 
			 (channame ~= _BARKLOC('ChannelGuildRecruitment')) and (channame ~= _BARKLOC('ChannelBlock1')) ) then
					info	= {};
				info.text	= channame;
				info.value	= i; 
				info.func	= Enchantrix_BarkerOptions_ChanFilterDropDownItem_OnClick;
				info.owner	= dropdown;
				UIDropDownMenu_AddButton(info)
			end
       end
end

function Enchantrix_BarkerOptions_ChanFilterDropDown_OnClick() 
       ToggleDropDownMenu(1, nil, Enchantrix_BarkerOptions_ChanFilterDropDown, "cursor");
end

-- The following is shamelessly lifted from auctioneer/UserInterace/AuctioneerUI.lua
-------------------------------------------------------------------------------
-- Wrapper for UIDropDownMenu_Initialize() that sets 'this' before calling
-- UIDropDownMenu_Initialize().
-------------------------------------------------------------------------------
function dropDownMenuInitialize(dropdown, func)
	-- Hide all the buttons to prevent any calls to Hide() inside
	-- UIDropDownMenu_Initialize() which will screw up the value of this.
	local button, dropDownList;
	for i = 1, UIDROPDOWNMENU_MAXLEVELS, 1 do
		dropDownList = getglobal("DropDownList"..i);
		if ( i >= UIDROPDOWNMENU_MENU_LEVEL or dropdown:GetName() ~= UIDROPDOWNMENU_OPEN_MENU ) then
			dropDownList.numButtons = 0;
			dropDownList.maxWidth = 0;
			for j=1, UIDROPDOWNMENU_MAXBUTTONS, 1 do
				button = getglobal("DropDownList"..i.."Button"..j);
				button:Hide();
			end
		end
	end

	-- Call the UIDropDownMenu_Initialize() after swapping in a value for 'this'.
	local oldThis = this;
	this = getglobal(dropdown:GetName().."Button");
	local newThis = this;
	UIDropDownMenu_Initialize(dropdown, func);
	-- Double check that the value of 'this' didn't change... this can screw us
	-- up and prevent the reason for this method!
	if (newThis ~= this) then
		Barker.Util.DebugPrintQuick("WARNING: The value of this changed during dropDownMenuInitialize()")
	end
	this = oldThis;
end

-------------------------------------------------------------------------------
-- Wrapper for UIDropDownMenu_SetSeletedID() that sets 'this' before calling
-- UIDropDownMenu_SetSelectedID().
-------------------------------------------------------------------------------
function dropDownMenuSetSelectedID(dropdown, index)
	local oldThis = this;
	this = dropdown;
	local newThis = this;
	UIDropDownMenu_SetSelectedID(dropdown, index);
	-- Double check that the value of 'this' didn't change... this can screw us
	-- up and prevent the reason for this method!
	if (newThis ~= this) then
		Barker.Util.DebugPrintQuick("WARNING: The value of this changed during dropDownMenuSetSelectedID()")
	end
	this = oldThis;
end

function Enchantrix_BarkerOptions_ChanFilterDropDownItem_OnClick()
	local index = this:GetID();
	local dropdown = this.owner;

	dropDownMenuSetSelectedID(dropdown, index);
	Enchantrix_BarkerSetConfig("barker_chan", this:GetText())
end
]]

-- end UI code

function Enchantrix_CreateBarker()
	local availableEnchants = {};
	local numAvailable = 0;
	local temp = GetCraftSkillLine(1);
	if EnchantrixBarker_BarkerGetZoneText() then
		EnchantrixBarker_ResetBarkerString();
		EnchantrixBarker_ResetPriorityList();
		if (temp) then
			Barker.Util.DebugPrintQuick("Starting creation of EnxBarker")
			for index=1, GetNumCrafts() do
				local craftName, craftSubSpellName, craftType, numEnchantsAvailable, isExpanded = GetCraftInfo(index);
				if((numEnchantsAvailable > 0) and (craftName:find("Enchant"))) then --have reagents and it is an enchant
					local cost = 0;
					for j=1,GetCraftNumReagents(index),1 do
						local a,b,c = GetCraftReagentInfo(index,j);
						reagent = GetCraftReagentItemLink(index,j);

						cost = cost + (Enchantrix_GetReagentHSP(reagent)*c);
					end

					local profit = cost * Enchantrix_BarkerGetConfig("profit_margin")*0.01;
					if( profit > Enchantrix_BarkerGetConfig("highest_profit") ) then
						profit = Enchantrix_BarkerGetConfig("highest_profit");
					end
					local price = EnchantrixBarker_RoundPrice(cost + profit);

					local enchant = {
						index = index,
						name = craftName,
						type = craftType,
						available = numEnchantsAvailable,
						isExpanded = isExpanded,
						cost = cost,
						price = price,
						profit = price - cost
					};
					availableEnchants[ numAvailable] = enchant;

					local p_gold,p_silver,p_copper = EnhTooltip.GetGSC(enchant.price);
					local pr_gold,pr_silver,pr_copper = EnhTooltip.GetGSC(enchant.profit);

					EnchantrixBarker_AddEnchantToPriorityList( enchant )
					numAvailable = numAvailable + 1;
				end
			end

			if numAvailable == 0 then
				Barker.Util.ChatPrint(_BARKLOC('BarkerNoEnchantsAvail'));
				return nil
			end

			for i,element in ipairs(priorityList) do
				EnchantrixBarker_AddEnchantToBarker( element.enchant );
			end

			return EnchantrixBarker_GetBarkerString();

		else
			Barker.Util.ChatPrint(_BARKLOC('BarkerEnxWindowNotOpen'));
		end
	end

	return nil
end

function EnchantrixBarker_ScoreEnchantPriority( enchant )

	local score_item = 0;

	if Enchantrix_BarkerGetConfig( EnchantrixBarker_GetItemCategoryKey(enchant.index) ) then
		score_item = Enchantrix_BarkerGetConfig( EnchantrixBarker_GetItemCategoryKey(enchant.index) );
		score_item = score_item * Enchantrix_BarkerGetConfig( 'factor_item' )*0.01;
	end

	local score_stat = 0;

	if Enchantrix_BarkerGetConfig( EnchantrixBarker_GetEnchantStat(enchant) ) then
		score_stat = Enchantrix_BarkerGetConfig( EnchantrixBarker_GetEnchantStat(enchant));
	else
		score_stat = Enchantrix_BarkerGetConfig( 'other' );
	end

	score_stat = score_stat * Enchantrix_BarkerGetConfig( 'factor_stat' )*0.01;

	local score_price = 0;
	local price_score_floor = Enchantrix_BarkerGetConfig("sweet_price");
	local price_score_ceiling = Enchantrix_BarkerGetConfig("high_price");

	if enchant.price < price_score_floor then
		score_price = (price_score_floor - (price_score_floor - enchant.price))/price_score_floor * 100;
	elseif enchant.price < price_score_ceiling then
		range = (price_score_ceiling - price_score_floor);
		score_price = (range - (enchant.price - price_score_floor))/range * 100;
	end

	score_price = score_price * Enchantrix_BarkerGetConfig( 'factor_price' )*0.01;
	score_total = (score_item + score_stat + score_price);

	return score_total * (1 - Enchantrix_BarkerGetConfig("randomise")*0.01) + math.random(300) * Enchantrix_BarkerGetConfig("randomise")*0.01;
end

function EnchantrixBarker_ResetPriorityList()
	priorityList = {};
end

function EnchantrixBarker_AddEnchantToPriorityList(enchant)

	local enchant_score = EnchantrixBarker_ScoreEnchantPriority( enchant );

	for i,priorityentry in ipairs(priorityList) do
		if( priorityentry.score < enchant_score ) then
			table.insert( priorityList, i, {score = enchant_score, enchant = enchant} );
			return;
		end
	end

	table.insert( priorityList, {score = enchant_score, enchant = enchant} );
end

function EnchantrixBarker_RoundPrice( price )

	local round

	if( price < 5000 ) then
		round = 1000;
	elseif ( price < 20000 ) then
		round = 2500;
	else
		round = 5000;
	end

	odd = math.fmod(price,round);

	price = price + (round - odd);

	if( price < Enchantrix_BarkerGetConfig("lowest_price") ) then
		price = Enchantrix_BarkerGetConfig("lowest_price");
	end

	return price
end

function Enchantrix_GetReagentHSP( itemLink )

	local hsp, median, market, prices = Enchantrix.Util.GetReagentPrice( itemLink );

--[[
	local itemID = Barker.Util.GetItemIdFromLink(itemLink);
	local itemKey = ("%s:0:0"):format(itemID);

	-- Work out what version if any of auctioneer is installed
	local auctVerStr;
	if (not Auctioneer) then
		auctVerStr = AUCTIONEER_VERSION or "0.0.0";
	else
		auctVerStr = AUCTIONEER_VERSION or Auctioneer.Version or "0.0.0";
	end
	local auctVer = Barker.Util.Split(auctVerStr, ".");
	local major = tonumber(auctVer[1]) or 0;
	local minor = tonumber(auctVer[2]) or 0;
	local rev = tonumber(auctVer[3]) or 0;
	if (auctVer[3] == "DEV") then rev = 0; minor = minor + 1; end
	local hsp = nil;

	if (major == 3 and minor == 0 and rev <= 11) then
		--Barker.Util.ChatPrint("Calling Auctioneer_GetHighestSellablePriceForOne");

		if (rev == 11) then
			hsp = Auctioneer_GetHighestSellablePriceForOne(itemKey, false, Auctioneer_GetAuctionKey());
		else
			if (Auctioneer_GetHighestSellablePriceForOne) then
				hsp = Auctioneer_GetHighestSellablePriceForOne(itemKey, false);
			elseif (getHighestSellablePriceForOne) then
				hsp = getHighestSellablePriceForOne(itemKey, false);
			end
		end
	elseif (major == 3 and (minor > 0 and minor <= 3) and (rev > 11 and rev < 675)) then
		--Barker.Util.ChatPrint("Calling GetHSP");
		hsp = Auctioneer_GetHSP(itemKey, Auctioneer_GetAuctionKey());
	elseif (major >= 3 and minor >= 3 and (rev >= 675 or (rev >= 0 and rev <=5))) then
		--Barker.Util.ChatPrint("Calling Statistic.GetHSP");
		hsp = Auctioneer.Statistic.GetHSP(itemKey, Auctioneer.Util.GetAuctionKey());
	else
		Barker.Util.ChatPrint("Calling Nothing: (Auctioneer not loaded?) "..major..", "..minor..", "..rev);
	end
]]


	if hsp == nil then
		hsp = 0;
	end

	return hsp;
end

local barkerString = '';
local barkerCategories = {};

function EnchantrixBarker_ResetBarkerString()
	barkerString = "("..EnchantrixBarker_BarkerGetZoneText()..") ".._BARKLOC('BarkerOpening');
	barkerCategories = {};
end

function EnchantrixBarker_BarkerGetZoneText()
	--Barker.Util.ChatPrint(GetZoneText());
	return short_location[GetZoneText()];
end

function EnchantrixBarker_AddEnchantToBarker( enchant )

	local currBarker = EnchantrixBarker_GetBarkerString();

	local category_key = EnchantrixBarker_GetItemCategoryKey( enchant.index )
	local category_string = "";
	local test_category = {};
	if barkerCategories[ category_key ] then
		for i,element in ipairs(barkerCategories[category_key]) do
			--Barker.Util.ChatPrint("Inserting: "..i..", elem: "..element.index );
			table.insert(test_category, element);
		end
	end

	table.insert(test_category, enchant);

	category_string = EnchantrixBarker_GetBarkerCategoryString( test_category );


	if #currBarker + #category_string > 255 then
		return false;
	end

	if not barkerCategories[ category_key ] then
		barkerCategories[ category_key ] = {};
	end

	table.insert( barkerCategories[ category_key ],enchant );

	return true;
end

function EnchantrixBarker_GetBarkerString()
	if not barkerString then EnchantrixBarker_ResetBarkerString() end

	local barker = ""..barkerString;

	for index, key in ipairs(print_order) do
		if( barkerCategories[key] ) then
			barker = barker..EnchantrixBarker_GetBarkerCategoryString( barkerCategories[key] )
		end
	end

	return barker;
end

function EnchantrixBarker_GetBarkerCategoryString( barkerCategory )
	local barkercat = ""
	barkercat = barkercat.." ["..EnchantrixBarker_GetItemCategoryString(barkerCategory[1].index)..": ";
	for j,enchant in ipairs(barkerCategory) do
		if( j > 1) then
			barkercat = barkercat..", "
		end
		barkercat = barkercat..EnchantrixBarker_GetBarkerEnchantString(enchant);
	end
	barkercat = barkercat.."]"

	return barkercat
end

function EnchantrixBarker_GetBarkerEnchantString( enchant )
	local p_gold,p_silver,p_copper = EnhTooltip.GetGSC(enchant.price);

	enchant_barker = Enchantrix_GetShortDescriptor(enchant.index).." - ";
	if( p_gold > 0 ) then
		enchant_barker = enchant_barker..p_gold.._BARKLOC('OneLetterGold');
	end
	if( p_silver > 0 ) then
		enchant_barker = enchant_barker..p_silver.._BARKLOC('OneLetterSilver');
	end
	--enchant_barker = enchant_barker..", ";
	return enchant_barker
end

function EnchantrixBarker_GetItemCategoryString( index )

	local enchant = GetCraftInfo( index );

	for key,category in pairs(categories) do
		--Barker.Util.ChatPrint( "cat key: "..key);
		if( enchant:find(category.search ) ~= nil ) then
			--Barker.Util.ChatPrint( "cat key: "..key..", name: "..category.print..", enchant: "..enchant );
			return category.print;
		end
	end

	return 'Unknown';
end

function EnchantrixBarker_GetItemCategoryKey( index )

	local enchant = GetCraftInfo( index );

	for key,category in pairs(categories) do
		--Barker.Util.ChatPrint( "cat key: "..key..", name: "..category );
		if( enchant:find(category.search ) ~= nil ) then
			return key;
		end
	end

	return 'Unknown';

end

function EnchantrixBarker_GetCraftDescription( index )
	return GetCraftDescription(index) or "";
end

function Enchantrix_GetShortDescriptor( index )
	local long_str = EnchantrixBarker_GetCraftDescription(index):lower();

	for index,attribute in ipairs(attributes) do
		if( long_str:find(attribute ) ~= nil ) then
			statvalue = long_str:sub(long_str:find('[0-9]+[^%%]'));
			statvalue = statvalue:sub(statvalue:find('[0-9]+'));
			return "+"..statvalue..' '..short_attributes[index];
		end
	end
	local enchant = Barker.Util.Split(GetCraftInfo(index), "-");

	return enchant[#enchant];
end

function EnchantrixBarker_GetEnchantStat( enchant )
	local index = enchant.index;
	local long_str = EnchantrixBarker_GetCraftDescription(index):lower();

	for index,attribute in ipairs(attributes) do
		if( long_str:find(attribute ) ~= nil ) then
			return short_attributes[index];
		end
	end
	local enchant = Barker.Util.Split(GetCraftInfo(index), "-");

	return enchant[#enchant];
end
