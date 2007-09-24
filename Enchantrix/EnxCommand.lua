--[[
	Enchantrix Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://enchantrix.org/

	Slash command and GUI functions.

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
local addonLoaded				-- Enchantrix.Command.AddonLoaded()
local auctioneerLoaded			-- Enchantrix.Command.AuctioneerLoaded()
local handleCommand				-- Enchantrix.Command.HandleCommand()
local register					-- Enchantrix.Command.Register()
local resetKhaos				-- Enchantrix.Command.ResetKhaos()
local setKhaosSetKeyValue		-- Enchantrix.Command.SetKhaosSetKeyValue()
local setKhaosSetKeyParameter	-- Enchantrix.Command.SetKhaosSetKeyParameter()

-- Local functions
local getKhaosLocaleList
local getKhaosLoadList
local registerKhaos
local registerAuctioneerOptions
local chatPrintHelp
local onOff
local clear
local default
local genVarSet
local percentLessFilter
local bidBrokerFilter
local findMaterialFIlter
local profitComparisonSort
local bidBrokerSort
local doBidBroker
local doPercentLess
local doFindMaterial

-- GUI Init Variables (Added by MentalPower)
Enchantrix.State.GUI_Registered = nil
Enchantrix.State.Khaos_Registered = nil

-- Local variables
local optionSet			-- used by Khaos UI
local profitMargins		-- used by PercentLess and BidBroker


function addonLoaded()
	if IsAddOnLoaded("Khaos") then
		registerKhaos()
	end
end

function getKhaosLocaleList()
	local options = { [_ENCH('CmdDefault')] = 'default' };
	for locale, data in pairs(EnchantrixLocalizations) do
		options[locale] = locale;
	end
	return options
end

function getKhaosLoadList()
	return {
		[_ENCH('GuiLoad_Always')] = 'always',
		[_ENCH('GuiLoad_Never')] = 'never',
	}
end

function registerKhaos()
	optionSet = {
		id="Enchantrix";
		text="Enchantrix";
		helptext=function()
			return _ENCH('GuiMainHelp');
		end;
		difficulty=1;
		default={checked=true};
		options={
			{
				id="Header";
				text="Enchantrix";
				helptext=function()
					return _ENCH('GuiMainHelp')
				end;
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="all";
				type=K_TEXT;
				text=function()
					return _ENCH('GuiMainEnable')
				end;
				helptext=function()
					return _ENCH('HelpOnoff')
				end;
				callback=function(state)
					if (state.checked) then
						onOff('on');
					else
						onOff('off');
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return _ENCH('StatOn');
					else
						return _ENCH('StatOff');
					end
				end;
				check=true;
				default={checked=Enchantrix.Settings.GetDefault('all')};
				disabled={checked=false};
				difficulty=1;
			};
			{
				id="locale";
				type=K_PULLDOWN;
				setup = {
					options = getKhaosLocaleList;
					multiSelect = false;
				};
				text=function()
					return _ENCH('GuiLocale')
				end;
				helptext=function()
					return _ENCH('HelpLocale')
				end;
				callback = function(state)
				end;
				feedback = function (state)
					Enchantrix.Config.SetLocale(state.value);
					return _ENCH('FrmtActSet'):format(_ENCH('CmdLocale'), state.value);
				end;
				default = {
					value = Enchantrix.Config.GetLocale();
				};
				disabled = {
					value = Enchantrix.Config.GetLocale();
				};
				dependencies={all={checked=true;}};
				difficulty=2;
			};
			{
				id="LoadSettings";
				type=K_PULLDOWN;
				setup = {
					options = getKhaosLoadList;
					multiSelect = false;
				};
				text=function()
					return _ENCH('GuiLoad')
				end;
				helptext=function()
					return _ENCH('HelpLoad')
				end;
				callback=function(state) end;
				feedback=function(state)
					handleCommand("load " .. state.value, "GUI");
				end;
				default={value = 'always'};
				disabled={value = 'never'};
				difficulty=1;
			};
			{
				id="ToolTipEmbedInGameTip";
				type=K_TEXT;
				text=function()
					return _ENCH('GuiEmbed')
				end;
				helptext=function()
					return _ENCH('HelpEmbed')
				end;
				callback=function(state)
					genVarSet('ToolTipEmbedInGameTip', state.checked);
				end;
				feedback=function(state)
					if (state.checked) then
						return (_ENCH('FrmtActEnable'):format(_ENCH('ShowEmbed')));
					else
						return (_ENCH('FrmtActDisable'):format(_ENCH('ShowEmbed')));
					end
				end;
				check=true;
				default={checked=Enchantrix.Settings.GetDefault('ToolTipEmbedInGameTip')};
				disabled={checked=false};
				dependencies={all={checked=true;}};
				difficulty=1;
			};
			{
				id="ToolTipTerseFormat";
				type=K_TEXT;
				text=function()
					return _ENCH('GuiTerse')
				end;
				helptext=function()
					return _ENCH('HelpTerse')
				end;
				callback=function(state)
					genVarSet('ToolTipTerseFormat', state.checked);
				end;
				feedback=function(state)
					if (state.checked) then
						return (_ENCH('FrmtActEnable'):format(_ENCH('ShowTerse')));
					else
						return (_ENCH('FrmtActDisable'):format(_ENCH('ShowTerse')));
					end
				end;
				check=true;
				default={checked=Enchantrix.Settings.GetDefault('ToolTipTerseFormat')};
				disabled={checked=false};
				dependencies={all={checked=true;}};
				difficulty=2;
			};
			{
				id="levels";
				type=K_TEXT;
				text=function()
					return _ENCH('GuiDELevels')
				end;
				helptext=function()
					return _ENCH('HelpShowDELevels')
				end;
				callback=function(state)
					genVarSet('TooltipShowDisenchantLevel', state.checked);
				end;
				feedback=function(state)
					if (state.checked) then
						return (_ENCH('FrmtActEnable'):format(_ENCH('ShowDELevels')));
					else
						return (_ENCH('FrmtActDisable'):format(_ENCH('ShowDELevels')));
					end
				end;
				check=true;
				default={checked=Enchantrix.Settings.GetDefault('TooltipShowDisenchantLevel')};
				disabled={checked=false};
				dependencies={all={checked=true;}};
				difficulty=3;
			};
			{
				id="materials";
				type=K_TEXT;
				text=function()
					return _ENCH('GuiDEMaterials')
				end;
				helptext=function()
					return _ENCH('HelpShowDEMaterials')
				end;
				callback=function(state)
					genVarSet('TooltipShowDisenchantMats', state.checked);
				end;
				feedback=function(state)
					if (state.checked) then
						return (_ENCH('FrmtActEnable'):format(_ENCH('ShowDEMaterials')));
					else
						return (_ENCH('FrmtActDisable'):format(_ENCH('ShowDEMaterials')));
					end
				end;
				check=true;
				default={checked=Enchantrix.Settings.GetDefault('TooltipShowDisenchantMats')};
				disabled={checked=false};
				dependencies={all={checked=true;}};
				difficulty=3;
			};
			{
				id="EnchantrixValuateHeader";
				type=K_HEADER;
				text=function()
					return _ENCH('GuiValuateHeader')
				end;
				helptext=function()
					return _ENCH('HelpValue')
				end;
				difficulty=2;
			};
			{
				id="TooltipShowValues";
				type=K_TEXT;
				text=function()
					return _ENCH('GuiValuateEnable')
				end;
				helptext=function()
					return _ENCH('HelpValue').."\n".._ENCH('HelpGuessNoauctioneer')
				end;
				callback=function(state)
					genVarSet('TooltipShowValues', state.checked);
				end;
				feedback=function(state)
					if (state.checked) then
						return (_ENCH('FrmtActEnable'):format(_ENCH('ShowValue')));
					else
						return (_ENCH('FrmtActDisable'):format(_ENCH('ShowValue')));
					end
				end;
				check=true;
				default={checked=Enchantrix.Settings.GetDefault('TooltipShowValues')};
				disabled={checked=false};
				dependencies={all={checked=true;}};
				difficulty=1;
			};
			{
				id="TooltipShowBaselineValue";
				type=K_TEXT;
				text=function()
					return _ENCH('GuiValuateBaseline')
				end;
				helptext=function()
					return _ENCH('HelpGuessBaseline')
				end;
				callback=function(state)
					genVarSet('TooltipShowBaselineValue', state.checked);
				end;
				feedback=function(state)
					if (state.checked) then
						return (_ENCH('FrmtActEnable'):format(_ENCH('ShowGuessBaseline')));
					else
						return (_ENCH('FrmtActDisable'):format(_ENCH('ShowGuessBaseline')));
					end
				end;
				check=true;
				default={checked=Enchantrix.Settings.GetDefault('TooltipShowBaselineValue')};
				disabled={checked=false};
				dependencies={TooltipShowValues={checked=true;}, all={checked=true;}};
				difficulty=2;
			};
			{
				id="EnchantrixOtherHeader";
				type=K_HEADER;
				text=function()
					return _ENCH('GuiOtherHeader')
				end;
				helptext=function()
					return _ENCH('GuiOtherHelp')
				end;
				difficulty=1;
			};
			{
				id="EnchantrixClearAll";
				type=K_BUTTON;
				setup={
					buttonText = function()
						return _ENCH('GuiClearallButton')
					end;
				};
				text=function()
					return _ENCH('GuiClearall')
				end;
				helptext=function()
					return _ENCH('GuiClearallHelp')
				end;
				callback=function()
					clear(_ENCH('CmdClearAll'));
				end;
				feedback=function()
					return _ENCH('FrmtActClearall'):format(_ENCH('GuiClearallNote'));
				end;
				dependencies={all={checked=true;}};
				difficulty=3;
			};
			{
				id="DefaultAll";
				type=K_BUTTON;
				setup={
					buttonText = function()
						return _ENCH('GuiDefaultAllButton')
					end;
				};
				text=function()
					return _ENCH('GuiDefaultAll')
				end;
				helptext=function()
					return _ENCH('GuiDefaultAllHelp')
				end;
				callback=function()
					default(_ENCH('CmdClearAll'));
				end;
				feedback=function()
					return _ENCH('FrmtActDefaultAll');
				end;
				dependencies={all={checked=true;}};
				difficulty=1;
			};
			{
				id="printframe";
				type=K_PULLDOWN;
				setup = {
					options = Enchantrix.Config.GetFrameNames;
					multiSelect = false;
				};
				text=function()
					return _ENCH('GuiPrintin')
				end;
				helptext=function()
					return _ENCH('HelpPrintin')
				end;
				callback=function(state)
					Enchantrix.Config.SetFrame(state.value);
				end;
				feedback=function(state)
					local _, frameName = Enchantrix.Config.GetFrameNames(state.value)
					return _ENCH('FrmtPrintin'):format(frameName);
				end;
				default = {
					value=Enchantrix.Config.GetFrameIndex();
				};
				disabled = {
					value=Enchantrix.Config.GetFrameIndex();
				};
				dependencies={all={checked=true;}};
				difficulty=3;
			};
			{
				id="DefaultOption";
				type=K_EDITBOX;
				setup = {
					callOn = {"tab", "escape", "enter"};
				};
				text=function()
					return _ENCH('GuiDefaultOption')
				end;
				helptext=function()
					return _ENCH('HelpDefault')
				end;
				callback = function(state)
					default(state.value);
				end;
				feedback = function (state)
					if (state.value == _ENCH('CmdClearAll')) then
						return _ENCH('FrmtActDefaultAll');
					else
						return _ENCH('FrmtActDefault'):format(state.value);
					end
				end;
				default = {
					value = "";
				};
				disabled = {
					value = "";
				};
				dependencies={all={checked=true;}};
				difficulty=4;
			};
		};
	};

	Khaos.registerOptionSet("tooltip",optionSet);
	Enchantrix.State.Khaos_Registered = true;
	Khaos.refresh();

	return true;
end

function registerAuctioneerOptions()
	local insertPos
	for key, value in ipairs(optionSet.options) do
		if value.id == "TooltipShowValues" then
			insertPos = key + 1
		end
	end

	if (optionSet.options[insertPos].id == 'TooltipShowAuctValueHSP') then
		return
	end

	local AuctioneerOptions = {
		{
			id="TooltipShowAuctValueHSP";
			type=K_TEXT;
			text=function()
				return _ENCH('GuiValuateAverages')
			end;
			helptext=function()
				return _ENCH('HelpGuessAuctioneerHsp')
			end;
			callback=function(state)
				genVarSet('TooltipShowAuctValueHSP', state.checked);
			end;
			feedback=function(state)
				if (state.checked) then
					return (_ENCH('FrmtActEnable'):format(_ENCH('ShowGuessAuctioneerHsp')));
				else
					return (_ENCH('FrmtActDisable'):format(_ENCH('ShowGuessAuctioneerHsp')));
				end
			end;
			check=true;
			default={checked = Enchantrix.Settings.GetDefault('TooltipShowAuctValueHSP')};
			disabled={checked = false};
			dependencies={TooltipShowValues={checked=true;}, all={checked=true;}};
			difficulty=2;
		};
		{
			id="TooltipShowAuctValueMedian";
			type=K_TEXT;
			text=function()
				return _ENCH('GuiValuateMedian')
			end;
			helptext=function()
				return _ENCH('HelpGuessAuctioneerMedian')
			end;
			callback=function(state)
				genVarSet('TooltipShowAuctValueMedian', state.checked);
			end;
			feedback=function(state)
				if (state.checked) then
					return (_ENCH('FrmtActEnable'):format(_ENCH('ShowGuessAuctioneerMed')));
				else
					return (_ENCH('FrmtActDisable'):format(_ENCH('ShowGuessAuctioneerMed')));
				end
			end;
			check=true;
			default={checked = Enchantrix.Settings.GetDefault('TooltipShowAuctValueMedian')};
			disabled={checked = false};
			dependencies={TooltipShowValues={checked=true;}, all={checked=true;}};
			difficulty=2;
		};
	};

	optionSet.options[insertPos - 1].helptext = function() return _ENCH('HelpValue') end;

	for i, opt in ipairs(AuctioneerOptions) do
		tinsert(optionSet.options, insertPos + i - 1, opt);
	end

	Khaos.unregisterOptionSet("Enchantrix");
	Khaos.registerOptionSet("tooltip", optionSet);
	Khaos.refresh();
end


function auctioneerLoaded()

	-- Make sure we have a usable version of Auctioneer loaded (3.4 or higher)

	if AucAdvanced and AucAdvanced.Version then
		local major,minor,patch,revision = strsplit('.', AucAdvanced.Version, 4)
		local major = tonumber(major) or 0
		local minor = tonumber(minor) or 0
		if patch == "DEV" then
			minor = minor + 1
			patch = 0
			revision = 0
		end

		if major >= 5 then
			Enchantrix.State.Auctioneer_Loaded = true
			Enchantrix.State.Auctioneer_Five = true
		end

	elseif Auctioneer and Auctioneer.Version then
		local major,minor,patch,revision = strsplit('.', Auctioneer.Version, 4)
		local major = tonumber(major) or 0
		local minor = tonumber(minor) or 0
		if patch == "DEV" then
			minor = minor + 1
			patch = 0
			revision = 0
		end

		if major >= 5 then
			Enchantrix.State.Auctioneer_Loaded = true
			Enchantrix.State.Auctioneer_Five = true
		elseif major > 3 or (major == 3 and minor >= 4) then
			Enchantrix.State.Auctioneer_Loaded = true
		end
	end

	if not Enchantrix.State.Auctioneer_Loaded then

		-- Don't complain if we are still waiting for Auctioneer to load
		local aucLoadPending =    (not Auctioneer and Stubby.GetConfig("Auctioneer", "LoadType") == "always")
		                       or (not AucAdvanced and Stubby.GetConfig("Auc-Advanced", "LoadType") == "always")

		if not aucLoadPending then
			-- Old version of Auctioneer
			if not EnchantConfig.displayedAuctioneerWarning then
				-- Yell at the user, but only once
				message(_ENCH('MesgAuctVersion'))
				EnchantConfig.displayedAuctioneerWarning = true
			else
				Enchantrix.Util.ChatPrint(_ENCH('MesgAuctVersion'))
			end
		end

		return
	end

-- ccox - with this enabled, we'll warn the user every single time they log in
-- that's very, very annoying
--	EnchantConfig.displayedAuctioneerWarning = nil

	if Enchantrix.State.Khaos_Registered then
		registerAuctioneerOptions()
	end
end

function setKhaosSetKeyParameter(key, parameter, value)
	if (Enchantrix.State.Khaos_Registered) then
		if (Khaos.getSetKey("Enchantrix", key)) then
			Khaos.setSetKeyParameter("Enchantrix", key, parameter, value)
		else
			Enchantrix.Util.DebugPrintQuick("setKhaosSetKeyParameter(): key " .. key .. " does not exist")
		end
	end
end

function setKhaosSetKeyValue(key, value)
	if (Enchantrix.State.Khaos_Registered) then
		local kKey = Khaos.getSetKey("Enchantrix", key)

		if (not kKey) then
			Enchantrix.Util.DebugPrintQuick("setKhaosSetKeyParameter(): key " .. key .. " does not exist")
		elseif (kKey.checked ~= nil) then
			Khaos.setSetKeyParameter("Enchantrix", key, "checked", value)
		elseif (kKey.value ~= nil) then
			Khaos.setSetKeyParameter("Enchantrix", key, "value", value)
		else
			Enchantrix.Util.DebugPrintQuick("setKhaosSetKeyParameter(): don't know how to update key ", key)
		end
	end
end


-- TODO - ccox - merge this somewhere sane
-- we have too many locations for these commands
-- can we use commandmap for this?

local commandToSettingLookup = {
	['terse'] = 'ToolTipTerseFormat',
	['embed'] = 'ToolTipEmbedInGameTip',
	['valuate'] = 'TooltipShowValues',
	['valuate-hsp'] = 'TooltipShowAuctValueHSP',
	['valuate-median'] = 'TooltipShowAuctValueMedian',
	['valuate-baseline'] = 'TooltipShowBaselineValue',
	['levels'] = 'TooltipShowDisenchantLevel',
	['materials'] = 'TooltipShowDisenchantMats',
}

-- Cleaner Command Handling Functions (added by MentalPower)
function handleCommand(command, source)

	-- To print or not to print, that is the question...
	local chatprint = nil;
	if (source == "GUI") then
		chatprint = false;
	else
		chatprint = true;
	end;

	-- Divide the large command into smaller logical sections (Shameless copy from the original function)
	local cmd, param, param2 = command:match("^([%w%-]+)%s*([^%s]*)%s*(.*)$");

	cmd = cmd or command or ""
	param = param or ""
	param2 = param2 or ""

	--delocalize the command so we can work on it in English in here
	cmd = Enchantrix.Locale.DelocalizeCommand(cmd);

	if ((cmd == "") or (cmd == "help")) then
		-- /enchantrix help
		chatPrintHelp();
		return;

	elseif ((cmd == "on") or (cmd == "off") or (cmd == "toggle")) then
		-- /enchantrix on|off|toggle
		onOff(cmd, chatprint);

	elseif (cmd == 'disable') then
		-- /enchantrix disable
		Enchantrix.Util.ChatPrint(_ENCH('MesgDisable'));
		Stubby.SetConfig("Enchantrix", "LoadType", "never");

	elseif (cmd == 'load') then
		-- /enchantrix load always|never
		if (param == "always") or (param == "never") then
			Stubby.SetConfig("Enchantrix", "LoadType", param);
			if (chatprint) then
				Enchantrix.Util.ChatPrint("Setting Enchantrix to "..param.." load for this toon");
				setKhaosSetKeyValue("LoadSettings", param)
			end
		end

	elseif (cmd == 'show') then
		-- show or hide our settings UI
		Enchantrix.Settings.MakeGuiConfig()
		local gui = Enchantrix.Settings.Gui
		if (gui:IsVisible()) then
			gui:Hide()
		else
			gui:Show()
		end

	elseif (cmd == 'clear') then
		-- /enchantrix clear
		clear(param, chatprint);

	elseif (cmd == 'locale') then
		-- /enchantrix locale
		Enchantrix.Config.SetLocale(param, chatprint);

	elseif (cmd == 'default') then
		-- /enchantrix default
		default(param, chatprint);

	elseif (cmd == 'print-in') then
		-- /enchantrix print-in
		Enchantrix.Config.SetFrame(param, chatprint)

	elseif (cmd == 'bidbroker' or cmd == 'bb') then
		-- /enchantrix bidbroker
		doBidBroker(param, param2);

	elseif (cmd == 'percentless' or cmd == 'pl') then
		doPercentLess(param, param2);

	elseif (cmd == 'findmaterial' or cmd == 'findmat' or cmd == 'fm') then
		doFindMaterial(param, param2);

	else

		-- lookup conversion to internal variable names
		if (commandToSettingLookup[cmd]) then
			cmd = commandToSettingLookup[cmd];
		end

		-- try direct access
		if (Enchantrix.Settings.GetDefault(cmd) ~= nil) then
			genVarSet(cmd, param, chatprint);

		elseif (chatprint) then
			Enchantrix.Util.ChatPrint(_ENCH('FrmtActUnknown'):format(cmd));
		end
	end
end

-- Help ME!! (The Handler) (Another shameless copy from the original function)
function chatPrintHelp()
	Enchantrix.Util.ChatPrint(_ENCH('FrmtUsage'));
	local onOffToggle = " (".._ENCH('CmdOn').."|".._ENCH('CmdOff').."|".._ENCH('CmdToggle')..")";
	local lineFormat = "  |cffffffff/enchantrix %s "..onOffToggle.."|r |cff2040ff[%s]|r - %s";

	Enchantrix.Util.ChatPrint("  |cffffffff/enchantrix "..onOffToggle.."|r |cff2040ff["..Enchantrix.Locale.GetLocalizedFilterVal('all').."]|r - " .. _ENCH('HelpOnoff'));
	Enchantrix.Util.ChatPrint("  |cffffffff/enchantrix ".._ENCH('CmdDisable').."|r - " .. _ENCH('HelpDisable'));
	Enchantrix.Util.ChatPrint("  |cffffffff/enchantrix ".._ENCH('ShowUI').."|r - " .. _ENCH('HelpShowUI'));

	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('ShowTerse'), Enchantrix.Locale.GetLocalizedFilterVal('terse'), _ENCH('HelpTerse')));
	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('ShowEmbed'), Enchantrix.Locale.GetLocalizedFilterVal('embed'), _ENCH('HelpEmbed')));
	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('ShowDELevels'), Enchantrix.Locale.GetLocalizedFilterVal('levels'), _ENCH('HelpShowDELevels')));
	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('ShowDEMaterials'), Enchantrix.Locale.GetLocalizedFilterVal('materials'), _ENCH('HelpShowDEMaterials')));

	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('ShowValue'), Enchantrix.Locale.GetLocalizedFilterVal('valuate'), _ENCH('HelpValue')));
	if AucAdvanced then
		Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('ShowGuessAuctioneerVal'), Enchantrix.Locale.GetLocalizedFilterVal('valuate-val'), _ENCH('HelpGuessAuctioneer5Val')));
	elseif Enchantrix.State.Auctioneer_Loaded then
		Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('ShowGuessAuctioneerHsp'), Enchantrix.Locale.GetLocalizedFilterVal('valuate-hsp'), _ENCH('HelpGuessAuctioneerHsp')));
		Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('ShowGuessAuctioneerMed'), Enchantrix.Locale.GetLocalizedFilterVal('valuate-median'), _ENCH('HelpGuessAuctioneerMedian')));
	else
		Enchantrix.Util.ChatPrint(_ENCH('HelpGuessNoauctioneer'));
	end
	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('ShowGuessBaseline'), Enchantrix.Locale.GetLocalizedFilterVal('valuate-baseline'), _ENCH('HelpGuessBaseline')));

	lineFormat = "  |cffffffff/enchantrix %s %s|r - %s";
	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('CmdLocale'), _ENCH('OptLocale'), _ENCH('HelpLocale')));
	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('CmdClear'), _ENCH('OptClear'), _ENCH('HelpClear')));

	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('CmdFindBidauct'), _ENCH('OptFindBidauct'), _ENCH('HelpFindBidauct')));
	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('CmdFindBuyauct'), _ENCH('OptFindBuyauct'), _ENCH('HelpFindBuyauct')));
-- TODO - ccox - localize!
	Enchantrix.Util.ChatPrint(lineFormat:format("findmaterial", "material <percentless>", "Find auctions where disenchanting can yield a given material (and, optionally, a minimum percentage less than auction value for that material)" ));
	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('CmdDefault'), _ENCH('OptDefault'), _ENCH('HelpDefault')));
	Enchantrix.Util.ChatPrint(lineFormat:format(_ENCH('CmdPrintin'), _ENCH('OptPrintin'), _ENCH('HelpPrintin')));
end


--[[
	The onOff(state, chatprint) function handles the state of the Enchantrix AddOn (whether it is currently on or off)
	If "on" or "off" is specified in the "state" variable then Enchantrix's state is changed to that value,
	If "toggle" is specified then it will toggle Enchantrix's state (if currently on then it will be turned off and vice-versa)

	If a boolean (or nil) value is passed as the first argument the conversion is as follows:
	"true" is the same as "on"
	"false" is the same as "off"
	"nil" is the same as "toggle"

	If chatprint is "true" then the state will also be printed to the user.
]]
function onOff(state, chatprint)
	if (type(state) == "string") then
		state = Enchantrix.Locale.DelocalizeFilterVal(state)

	elseif (state == true) then
		state = 'on'

	elseif (state == false) then
		state = 'off'

	elseif (state == nil) then
		state = 'toggle'
	end

	if (state == 'on') or (state == 'off') then
		Enchantrix.Settings.SetSetting('all', state);
	elseif (state == "toggle") then
		Enchantrix.Settings.SetSetting('all', not Enchantrix.Settings.GetSetting('all'))
	end

	-- Print the change and alert the GUI if the command came from slash commands. Do nothing if they came from the GUI.
	if (chatprint) then
		state = Enchantrix.Settings.GetSetting('all')
		setKhaosSetKeyParameter('all', "checked", state);

		if (state) then
			Enchantrix.Util.ChatPrint(_ENCH('StatOn'));

		else
			Enchantrix.Util.ChatPrint(_ENCH('StatOff'));
		end
	end

	return state;
end

-- The following functions are almost verbatim copies of the original functions but modified in order to make them compatible with direct GUI access.
function clear(param, chatprint)
	if (param == _ENCH('CmdClearAll')) or (param == "all") then
		DisenchantList = {}
		EnchantedLocal = {}
		EnchantedBaseItems = {}

		if (chatprint) then
			Enchantrix.Util.ChatPrint(_ENCH('FrmtActClearall'));
		end

	else
		local items = Enchantrix.Util.GetItemHyperlinks(param);

		if (items) then
			for pos, itemKey in ipairs(items) do
				local sig = Enchantrix.Util.GetSigFromLink(itemKey)
				local itemID = Enchantrix.Util.GetItemIdFromSig(sig)
				EnchantedLocal[sig] = nil
				EnchantedBaseItems[itemID] = nil

				if (chatprint) then
					Enchantrix.Util.ChatPrint(_ENCH('FrmtActClearOk'):format(itemKey))
				end
			end
		end
	end
end

-- This function was added by MentalPower to implement the /enx default command
function default(param, chatprint)
	local paramLocalized

	if  ( (param == nil) or (param == "") ) then
		return
	elseif (param == _ENCH('CmdClearAll')) or (param == "all") then
		param = "all"
	else
		paramLocalized = param
		param = Enchantrix.Locale.DelocalizeCommand(param)
		Enchantrix.Settings.SetSetting(param, nil)
	end

	if (chatprint) then
		if (param == "all") then
			Enchantrix.Util.ChatPrint(_ENCH('FrmtActDefaultAll'));
			Enchantrix.Settings.SetSetting('profile.default', true );

		--[[
			for k,v in pairs(EnchantConfig.filters) do
				setKhaosSetKeyValue(k, Enchantrix.Settings.GetSetting(k));
			end
		]]

		else
			Enchantrix.Util.ChatPrint(_ENCH('FrmtActDefault'):format(paramLocalized));
			setKhaosSetKeyValue(param, Enchantrix.Settings.GetSetting(param));
		end
	end
end

function genVarSet(variable, param, chatprint)

	param = Enchantrix.Locale.DelocalizeFilterVal(param);

	if (param == 'on' or param == 'off' or param == true or param == false) then
		Enchantrix.Settings.SetSetting(variable, param);

	elseif (param == 'toggle' or param == nil or param == "") then
		Enchantrix.Settings.SetSetting(variable, not Enchantrix.Settings.GetSetting(variable))
	end

	if (chatprint) then
		if (Enchantrix.Settings.GetSetting(variable)) then
			Enchantrix.Util.ChatPrint(_ENCH('FrmtActEnable'):format(Enchantrix.Locale.LocalizeCommand(variable)));
			setKhaosSetKeyParameter(variable, "checked", true);

		else
			Enchantrix.Util.ChatPrint(_ENCH('FrmtActDisable'):format(Enchantrix.Locale.LocalizeCommand(variable)));
			setKhaosSetKeyParameter(variable, "checked", false);
		end
	end
end

---------------------------------------
--   Auctioneer dependant commands   --
---------------------------------------

local function percentLessThan(v1, v2)
    if v1 and v1 > 0 and v2 and v2 < v1 then
		return 100 - math.floor((100 * v2)/v1);
    else
        return 0;
    end
end

local function whiteText(text)
	local COLORING_START = "|cff%s%s|r";
	local WHITE_COLOR = "e6e6e6";
	return COLORING_START:format(WHITE_COLOR, tostring(text or ""));
end

local function timeLeftString(timeleft)
	return (getglobal("AUCTION_TIME_LEFT"..timeleft))
end


function percentLessFilter(auction, args)
	local filterAuction = true;

	if not Auctioneer and AucAdvanced then
		auction = AucAdvanced.API.UnpackImageItem(auction)
		auction.auctionId = auction.id
		auction.count = auction.stackSize
		auction.itemId = EnhTooltip.BreakLink(auction.link)
		if (auction.sellerName == UnitName("player") or auction.amBidder) then
			return false
		end
	end

	local percentLess = args['percentLess'];
	local reagentPriceTable = args['reagentPriceTable'];

	-- this returns the disenchant value for a SINGLE item, not a stack (if that ever happens)
	local myValue = Enchantrix.Storage.GetItemDisenchantFromTable(auction.itemId, reagentPriceTable);
	if (not myValue) then return filterAuction; end

	local buyout = auction.buyoutPrice or 0;
	local count = auction.count or 1;

	-- margin is percentage PER ITEM
	local margin = percentLessThan(myValue, buyout/count);
	-- profit is for all items in the stack
	local profit = (myValue * count) - buyout;

	local results = {
		value = myValue,
		margin = margin,
		profit = profit,
		auction = auction,
	};

	if (buyout > 0)
		and (margin >= tonumber(percentLess))
		and (profit >= Enchantrix.Settings.GetSetting('minProfitMargin'))
		and (buyout <= Enchantrix.Settings.GetSetting('maxBuyoutPrice')) then
--		If we return false, then this item will be removed from the list, and we won't be able to find it later...
--		filterAuction = false;
		table.insert(profitMargins, results);
		return true;
	end

	return filterAuction;
end

function bidBrokerFilter(auction, args)
	local filterAuction = true;

	if not Auctioneer and AucAdvanced then
		auction = AucAdvanced.API.UnpackImageItem(auction)
		auction.auctionId = auction.id
		auction.count = auction.stackSize
		auction.itemId = EnhTooltip.BreakLink(auction.link)
		if (auction.sellerName == UnitName("player") or auction.amBidder) then
			return false
		end
	end

	local minProfit = args['minProfit'];
	local reagentPriceTable = args['reagentPriceTable'];

	-- this returns the disenchant value for a SINGLE item, not a stack (if that ever happens)
	local myValue = Enchantrix.Storage.GetItemDisenchantFromTable(auction.itemId, reagentPriceTable);
	if (not myValue) then return filterAuction; end

	local currentBid = auction.bidAmount or 0;
	local minBid = auction.minBid or 0;
	local count = auction.count or 0;

	currentBid = math.max( currentBid, minBid );

	-- margin is percentage PER ITEM
	local margin = percentLessThan(myValue, currentBid/count);
	-- profit is for all items in the stack
	local profit = (myValue * count) - currentBid;
	-- profitPricePercent is for all items in the stack
	local profitPricePercent = math.floor((profit / currentBid) * 100);

	local results = {
		value = myValue,
		margin = margin,
		profit = profit,
		auction = auction,
	};

	if (currentBid <= Enchantrix.Settings.GetSetting('maxBuyoutPrice'))
			 and (profit >= tonumber(minProfit))
			 and (profit >= Enchantrix.Settings.GetSetting('minProfitMargin'))
			 and (profitPricePercent >= Enchantrix.Settings.GetSetting('minProfitPricePercent')) then
--		If we return false, then this item will be removed from the list, and we won't be able to find it later...
--		filterAuction = false;
		table.insert(profitMargins, results);
		return true;
	end

	return filterAuction;
end


function findMaterialFilter(auction, args)
	local filterAuction = true;

	if not Auctioneer and AucAdvanced then
		auction = AucAdvanced.API.UnpackImageItem(auction)
		auction.auctionId = auction.id
		auction.count = auction.stackSize
		auction.itemId = EnhTooltip.BreakLink(auction.link)
		if (auction.sellerName == UnitName("player") or auction.amBidder) then
			return false
		end
	end

	local reagentPriceTable = args['reagentPriceTable'];
	local materialID = args['materialID'];
	local percentLess = args['percentLess'];

	-- this returns the disenchant value for a SINGLE item, not a stack (if that ever happens)
	local myValue, percentChance, yield = Enchantrix.Storage.GetItemDisenchantFromTableForOneMaterial(auction.itemId, reagentPriceTable, materialID);
	if (not myValue) then return filterAuction; end

	local buyout = auction.buyoutPrice or 0;
	local count = auction.count or 1;

	-- margin is percentage PER ITEM
	local margin = percentLessThan(myValue, buyout/count);
	-- profit is for all items in the stack
	local profit = (myValue * count) - buyout;

	local results = {
		value = myValue,
		margin = margin,
		profit = profit,
		auction = auction,
		percentChance = percentChance,
		yield = yield,
	};

	if (buyout > 0)
		and (margin >= tonumber(percentLess))
--		and (profit >= Enchantrix.Settings.GetSetting('minProfitMargin'))
		and (buyout <= Enchantrix.Settings.GetSetting('maxBuyoutPrice')) then
		table.insert(profitMargins, results);
		return true;
	end

	return filterAuction;
end

-- greatest profit first
-- greatest margin first
-- greatest value first
function profitComparisonSort(a, b)
	local aProfit = profitMargins[a].profit or 0;
	local bProfit = profitMargins[b].profit or 0;
	if (aProfit > bProfit) then return true; end
	if (aProfit < bProfit) then return false; end
	local aMargin = profitMargins[a].margin or 0;
	local bMargin = profitMargins[b].margin or 0;
	if (aMargin > bMargin) then return true; end
	if (aMargin < bMargin) then return false; end
	local aValue  = profitMargins[a].value or 0;
	local bValue  = profitMargins[b].value or 0;
	if (aValue > bValue) then return true; end
	if (aValue < bValue) then return false; end
	return false;
end

-- shortest time first
-- then profit (above)
function bidBrokerSort(a, b)
	local aTime = profitMargins[a].auction.timeLeft or 0;
	local bTime = profitMargins[b].auction.timeLeft or 0;
	if (aTime > bTime) then return false; end
	if (aTime < bTime) then return true; end
	return profitComparisonSort(a, b);
end


-- greatest margin first
-- greatest chance first
-- greatest yield first
function findMaterialComparisonSort(a, b)

	local aMargin = profitMargins[a].margin or 0;
	local bMargin = profitMargins[b].margin or 0;
	if (aMargin > bMargin) then return true; end
	if (aMargin < bMargin) then return false; end

	local aChance = profitMargins[a].percentChance or 0;
	local bChance = profitMargins[b].percentChance or 0;
	if (aChance > bChance) then return true; end
	if (aChance < bChance) then return false; end

	local aYield = profitMargins[a].yield or 0;
	local bYield = profitMargins[b].yield or 0;
	if (aYield > bYield) then return true; end
	if (aYield < bYield) then return false; end

	return false;
end

local function CheckAuctioneerScanAvailable()

	local adv = false

	if not Auctioneer then
		if AucAdvanced then
			adv = true
		else
			Enchantrix.Util.ChatPrint(_ENCH("AuctionScanAuctNotInstalled"));
			return false, false;
		end
	elseif not (Auctioneer.Filter or Auctioneer.Filter.QuerySnapshot) then
		Enchantrix.Util.ChatPrint(_ENCH("AuctionScanVersionTooOld"));
		return false, false;
	end

	return true, adv;
end

function doPercentLess(percentLess, minProfit)

	local aucAvail, adv = CheckAuctioneerScanAvailable();
	if (not aucAvail) then
		return;
	end

	-- get the maximum item level the user can disenchant
	local skill = Enchantrix.Util.GetUserEnchantingSkill();
	local maxLevel = Enchantrix.Util.MaxDisenchantItemLevel(skill);

	--if string->number conversion fails, use defaults
	percentLess = tonumber(percentLess) or Enchantrix.Settings.GetSetting('defaultPercentLessThanHSP');
	minProfit = (tonumber(minProfit) or Enchantrix.Settings.GetSetting('defaultProfitMargin')/100) * 100

	percentLess = math.max(percentLess, Enchantrix.Settings.GetSetting('minPercentLessThanHSP'))
	minProfit = math.max(minProfit, Enchantrix.Settings.GetSetting('minProfitMargin'))

	Enchantrix.Util.ChatPrint(_ENCH('FrmtPctlessHeader'):format(percentLess, EnhTooltip.GetTextGSC(minProfit)));

	profitMargins = {};

	-- setup the reagent pricing table
	local reagentPriceTable = Enchantrix.Util.CreateReagentPricingTable();

	local percentless_args = {
		['percentLess'] = percentLess,
		['reagentPriceTable'] = reagentPriceTable,
		}

	local targetAuctions

	if adv then
		targetAuctions = AucAdvanced.API.QueryImage({filter=percentLessFilter}, nil, nil, percentless_args);
	else
		targetAuctions = Auctioneer.SnapshotDB.Query(nil, nil, percentLessFilter, percentless_args);
	end

	-- sort by profit into temporary array
	local sortedTable = {}
	for n in pairs(profitMargins) do table.insert(sortedTable, n) end
	table.sort(sortedTable, profitComparisonSort);

	local skipped_auctions = 0;
	local skipped_skill = 0;
	local name, link, _, itemLevel, hasBid

	-- output the list of auctions, iterating over our temp array
	for _, n in ipairs(sortedTable) do
		auctionItem = profitMargins[ n ];
		local profit = auctionItem.profit;
		local a = auctionItem.auction;
		-- note: profit value already includes the item count
		if (profit >= minProfit) then
			if adv then
				name = a.itemName
				link = a.link
				itemLevel = a.itemLevel
			else
				name, link, _, itemLevel = GetItemInfo( a.itemId );
			end
			if ((not Enchantrix.Settings.GetSetting('RestrictToLevel')) or (itemLevel <= maxLevel)) then
				local value = auctionItem.value;
				local margin = auctionItem.margin;
				local output = _ENCH('FrmtPctlessLine'):format(
					whiteText(a.count.."x")..link,
					EnhTooltip.GetTextGSC(value * a.count),
					EnhTooltip.GetTextGSC(a.buyoutPrice),
					EnhTooltip.GetTextGSC(profit * a.count),
					whiteText(margin.."%")
				);
				Enchantrix.Util.ChatPrint(output);
			else
				skipped_skill = skipped_skill + 1;
			end
		else
			skipped_auctions = skipped_auctions + 1;
		end
	end

	if (skipped_auctions > 0) then
		Enchantrix.Util.ChatPrint(_ENCH('FrmtPctlessSkipped'):format(skipped_auctions, EnhTooltip.GetTextGSC(minProfit)));
	end

	if (skipped_skill > 0) then
		Enchantrix.Util.ChatPrint(_ENCH('FrmtPctlessSkillSkipped'):format(skipped_skill, skill));
	end

	-- so we free all the references
	profitMargins = {};

	Enchantrix.Util.ChatPrint(_ENCH('FrmtPctlessDone'));
end

function doBidBroker(minProfit, percentLess)

	local aucAvail, adv = CheckAuctioneerScanAvailable();
	if (not aucAvail) then
		return;
	end


	-- get the maximum item level the user can disenchant
	local skill = Enchantrix.Util.GetUserEnchantingSkill();
	local maxLevel = Enchantrix.Util.MaxDisenchantItemLevel(skill);

	--if string->number conversion fails, use defaults
	percentLess = tonumber(percentLess) or Enchantrix.Settings.GetSetting('defaultPercentLessThanHSP');
	minProfit = (tonumber(minProfit) or Enchantrix.Settings.GetSetting('defaultProfitMargin')/100) * 100

	percentLess = math.max(percentLess, Enchantrix.Settings.GetSetting('minPercentLessThanHSP'))
	min_profit_value = math.max(minProfit, Enchantrix.Settings.GetSetting('minProfitMargin'))

	Enchantrix.Util.ChatPrint(_ENCH('FrmtBidbrokerHeader'):format(EnhTooltip.GetTextGSC(minProfit), percentLess));

	profitMargins = {};

	-- setup the reagent pricing table
	local reagentPriceTable = Enchantrix.Util.CreateReagentPricingTable();

	local bidbroker_args = {
		['minProfit'] = minProfit,
		['reagentPriceTable'] = reagentPriceTable,
		}

	local targetAuctions
	if adv then
		targetAuctions = AucAdvanced.API.QueryImage({filter=bidBrokerFilter}, nil, nil, bidbroker_args);
	else
		targetAuctions = Auctioneer.SnapshotDB.Query(nil, nil, bidBrokerFilter, bidbroker_args);
	end

	-- sort by profit into temporary array
	local sortedTable = {}
	for n in pairs(profitMargins) do table.insert(sortedTable, n) end
	table.sort(sortedTable, bidBrokerSort);

	local skipped_auctions = 0;
	local skipped_hasbid = 0;
	local skipped_skill = 0;
	local name, link, _, itemLevel, hasBid

	-- output the list of auctions
	for _, n in ipairs(sortedTable) do
		auctionItem = profitMargins[ n ];
		local a = auctionItem.auction;
		local currentBid = a.bidAmount or 0;
		local min = a.minBid or 0;
		if adv then
			if a.increment > 0 then
				currentBid = a.curBid + a.increment
				hasBid = true
			else
				currentBid = a.minBid
				hasBid = false
			end
		elseif currentBid == 0 then
			hasBid = false
			currentBid = min
		else
			hasBid = true
		end
		local value = auctionItem.value;
		local margin = auctionItem.margin;
		local profit = auctionItem.profit;
		local bidText;
		if (margin >= percentLess) then
			if adv then
				name = a.itemName
				link = a.link
				itemLevel = a.itemLevel
			else
				name, link, _, itemLevel = GetItemInfo( a.itemId );
			end
			if ((not Enchantrix.Settings.GetSetting('RestrictToLevel')) or (itemLevel <= maxLevel)) then
				if not (Enchantrix.Settings.GetSetting('RestrictUnbidded') and hasBid) then
					if (currentBid == min) then
						bidText = _ENCH('FrmtBidbrokerMinbid');
					else
						bidText = _ENCH('FrmtBidbrokerCurbid');
					end
					local output = _ENCH('FrmtBidbrokerLine'):format(
						whiteText(a.count.."x")..link,
						EnhTooltip.GetTextGSC(value * a.count),
						bidText,
						EnhTooltip.GetTextGSC(currentBid),
						EnhTooltip.GetTextGSC(profit * a.count),
						whiteText(margin.."%"),
						whiteText(timeLeftString(a.timeLeft))
					);
					Enchantrix.Util.ChatPrint(output);
				else
					skipped_hasbid = skipped_hasbid + 1;
				end
			else
				skipped_skill = skipped_skill + 1;
			end
		else
			if (currentBid == min) then
				bidText = _ENCH('FrmtBidbrokerMinbid');
			else
				bidText = _ENCH('FrmtBidbrokerCurbid');
			end

			skipped_auctions = skipped_auctions + 1;
		end
	end

	if (skipped_auctions > 0) then
		-- if this line fails, then someone changed the case of the localization key again, check the string file
		Enchantrix.Util.ChatPrint(_ENCH('FrmtBidBrokerSkipped'):format(skipped_auctions, percentLess));
	end

	if (skipped_skill > 0) then
		Enchantrix.Util.ChatPrint(_ENCH('FrmtPctlessSkillSkipped'):format(skipped_skill, skill));
	end

	if (skipped_hasbid > 0) then
		Enchantrix.Util.ChatPrint((_ENCH("FrmtBidBrokerSkippedBids")):format(skipped_hasbid));
	end

	-- so we free all the references
	profitMargins = {};

	Enchantrix.Util.ChatPrint(_ENCH('FrmtBidbrokerDone'));
end


-- ccox - TODO - this could be a lot more efficient
-- but for now, we won't be calling it often, and the list is short
local function resolveDisenchantMaterial( mat )

	local n = #Enchantrix.Constants.DisenchantReagentList;

	matID = tonumber(mat);
	if (matID) then
		for i = 1, n do
			local reagent = Enchantrix.Constants.DisenchantReagentList[i];
			reagent = tonumber(reagent);
			if (matID == reagent) then
				return reagent;
			end
		end
	else
		local matLower = mat:lower();
		for i = 1, n do
			local reagentID = Enchantrix.Constants.DisenchantReagentList[i];
			reagentID = tonumber(reagentID);
			local reagentName = Enchantrix.Util.GetReagentInfo(reagentID);
			if (matLower == reagentName) then
				return reagentID;
			end
		end
	end

	return nil;
end


-- ccox - TODO - this should also take material names or something similar
--		needs to handle capitalization, needs to deal with misspelling, localization, etc.
-- ccox - TODO -- handleCommand command line parsing is breaking up item names
--			need a better way to handle string input on command line
function doFindMaterial(material, percentLess)

	if (not material) then
		return;
	end

	local aucAvail, adv = CheckAuctioneerScanAvailable();
	if (not aucAvail) then
		return;
	end

	local materialID = resolveDisenchantMaterial(material);

	if (not materialID) then
-- ccox - TODO - localize
		Enchantrix.Util.ChatPrint( material.." is not a disenchantable material." );
		return;
	end

	if (not materialID) then return end

	--if string->number conversion fails, use defaults
	percentLess = tonumber(percentLess) or Enchantrix.Settings.GetSetting('defaultPercentLessThanHSP');
	percentLess = math.max(percentLess, Enchantrix.Settings.GetSetting('minPercentLessThanHSP'))

-- ccox - TODO - localize
	Enchantrix.Util.ChatPrint("Starting Find Material scan for "..materialID.." with price "..percentLess.." % less than market.");


	profitMargins = {};

	-- setup the reagent pricing table
	local reagentPriceTable = Enchantrix.Util.CreateReagentPricingTable();

	local find_material_args = {
		['percentLess'] = percentLess,
		['materialID'] = materialID,
		['reagentPriceTable'] = reagentPriceTable,
		}

	local targetAuctions

	if adv then
		targetAuctions = AucAdvanced.API.QueryImage({filter=findMaterialFilter}, nil, nil, find_material_args);
	else
		targetAuctions = Auctioneer.SnapshotDB.Query(nil, nil, findMaterialFilter, find_material_args);
	end

	-- sort by profit into temporary array
	local sortedTable = {}
	for n in pairs(profitMargins) do table.insert(sortedTable, n) end
	table.sort(sortedTable, findMaterialComparisonSort);

	-- get the maximum item level the user can disenchant
	local skill = Enchantrix.Util.GetUserEnchantingSkill();
	local maxLevel = Enchantrix.Util.MaxDisenchantItemLevel(skill);

	local skipped_skill = 0;
	local name, link, _, itemLevel, hasBid

	-- output the list of auctions, iterating over our temp array
	for _, n in ipairs(sortedTable) do
		auctionItem = profitMargins[ n ];
		local profit = auctionItem.profit;
		local a = auctionItem.auction;
		-- note: profit value already includes the item count
		if adv then
			name = a.itemName
			link = a.link
			itemLevel = a.itemLevel
		else
			name, link, _, itemLevel = GetItemInfo( a.itemId );
		end
		if ((not Enchantrix.Settings.GetSetting('RestrictToLevel')) or (itemLevel <= maxLevel)) then
			local value = auctionItem.value or 0;
			local margin = auctionItem.margin or 0;
			local percentChance = auctionItem.percentChance or 0;
			local yield = auctionItem.yield or 0;

-- TODO - ccox - localize
			local output = ("%s, Valued at: %s, BO: %s, Save: %s, Less %s, Chance %s, Yield %s"):format(
				whiteText(a.count.."x")..link,
				EnhTooltip.GetTextGSC(value * a.count),
				EnhTooltip.GetTextGSC(a.buyoutPrice),
				EnhTooltip.GetTextGSC(profit * a.count),
				whiteText(margin.."%"),
				whiteText((100 * percentChance).."%"),
				whiteText(yield * a.count)
			);
			Enchantrix.Util.ChatPrint(output);
		else
			skipped_skill = skipped_skill + 1;
		end
	end

	if (skipped_skill > 0) then
		Enchantrix.Util.ChatPrint(_ENCH('FrmtPctlessSkillSkipped'):format(skipped_skill, skill));
	end

	-- so we free all the references
	profitMargins = {};

-- TODO - ccox - localize
	Enchantrix.Util.ChatPrint("Find material done.");
end


Enchantrix.Command = {
	Revision				= "$Revision$",

	AddonLoaded				= addonLoaded,
	AuctioneerLoaded		= auctioneerLoaded,

	HandleCommand			= handleCommand,
	ChatPrintHelp			= chatPrintHelp,

	Register				= register,
	SetKhaosSetKeyValue		= setKhaosSetKeyValue,
	SetKhaosSetKeyParameter	= setKhaosSetKeyParameter,
	SetKhaosSetKeyValue		= setKhaosSetKeyValue,
}
