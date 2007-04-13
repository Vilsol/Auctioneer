--[[
	Enchantrix Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$

	Configuration functions.

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
local addonLoaded		-- Enchantrix.Config.AddonLoaded()
local getFilterDefaults	-- Enchantrix.Config.GetFilterDefaults()
local setFilter			-- Enchantrix.Config.SetFilter()
local getFilter			-- Enchantrix.Config.GetFilter()
local setFrame			-- Enchantrix.Config.SetFrame()
local getFrameNames		-- Enchantrix.Config.GetFrameNames()
local getFrameIndex		-- Enchantrix.Config.GetFrameIndex()
local setLocale			-- Enchantrix.Config.SetLocale()
local getLocale			-- Enchantrix.Config.GetLocale()

-- Local functions
local isValidLocale

-- Default filter configuration
local filterDefaults = {
	['all'] = true,
	['counts'] = false,
	['embed'] = false,
	['locale'] = 'default',
	['printframe'] = 1,
	['terse'] = false,
	['valuate'] = true,
	['valuate-hsp'] = true,
	['valuate-median'] = true,
	['valuate-baseline'] = true,
}

-- True if this filter value should be saved per character
local perCharacterFilter = {
	['counts'] = true,
	['embed'] = true,
	['terse'] = true,
	['printframe'] = true,
}

function addonLoaded()
	-- Remove unused/unknown filter values
--	for key in pairs(EnchantConfig.filters) do
--		if getFilterDefaults(key) == nil then
--			setFilter(key, nil)
--		else
--			setFilter(key, getFilter(key))
--		end
--	end
end

function getFilterDefaults(key)
	return filterDefaults[key]
end

function getFilter(filter)
	local val-- = EnchantConfigChar.filters[filter]
	if val == nil then
		--val = EnchantConfig.filters[filter]
	end
	if val == nil then
		val = getFilterDefaults(filter)
	end
	return val
end

function setFilter(key, value)
	if (value == 'default') or (value == getFilterDefaults(key)) then
		-- Don't save default values
		value = nil
	elseif value == 'on' then
		value = true
	elseif value == 'off' then
		value = false
	end
	if perCharacterFilter[key] then
		EnchantConfigChar.filters[key] = value
	else
		EnchantConfigChar.filters[key] = nil
	end
	EnchantConfig.filters[key] = value
end

-- The following three functions were added by MentalPower to implement the /enx print-in command
function getFrameNames(index)

	local frames = {}
	local frameName

	for i = 1, NUM_CHAT_WINDOWS do
		-- name, fontSize, r, g, b, a, shown, locked, docked = GetChatWindowInfo(i)
		local name = GetChatWindowInfo(i)

		if ( name == "" ) then
			if (i == 1) then
				name = _ENCH('TextGeneral')
			elseif (i == 2) then
				name = _ENCH('TextCombat')
			end
		end
		frames[name] = i

		if i == index then
			frameName = name
		end
	end

	return frames, frameName or ""
end

function getFrameIndex()
	return Enchantrix.Config.GetFilter('printframe')
end

function setFrame(frame, chatprint)

	local frameNumber
	local frameVal
	frameVal = tonumber(frame)

	-- If no arguments are passed, then set it to the default frame.
	if not (frame) then
		frameNumber = 1;

	-- If the frame argument is a number then set our chatframe to that number.
	elseif ((frameVal) ~= nil) then
		frameNumber = frameVal;

	-- If the frame argument is a string, find out if there's a chatframe with that name, and set our chatframe to that index. If not set it to the default frame.
	elseif (type(frame) == "string") then
		allFrames = Enchantrix.Config.GetFrameNames();

		if (allFrames[frame]) then
			frameNumber = allFrames[frame];

		else
			frameNumber = 1;
		end

	-- If the argument is something else, set our chatframe to it's default value.
	else
		frameNumber = 1;
	end

	local _, frameName

	if (chatprint == true) then
		_, frameName = Enchantrix.Config.GetFrameNames(frameNumber);

		if (Enchantrix.Config.GetFrameIndex() ~= frameNumber) then
			Enchantrix.Util.ChatPrint(_ENCH('FrmtPrintin'):format(frameName));
		end
	end

	Enchantrix.Config.SetFilter("printframe", frameNumber);

	if (chatprint == true) then
		Enchantrix.Util.ChatPrint(_ENCH('FrmtPrintin'):format(frameName));
		Enchantrix.Command.SetKhaosSetKeyValue("printframe", frameNumber);
	end
end

function isValidLocale(param)
	return (EnchantrixLocalizations and EnchantrixLocalizations[param])
end

function setLocale(param, chatprint)
	param = Enchantrix.Locale.DelocalizeFilterVal(param)

	if (param == 'default') or (param == 'off') then
		Babylonian.SetOrder('')
		validLocale = true
	elseif (isValidLocale(param)) then
		Babylonian.SetOrder(param)
		validLocale = true
	else
		validLocale = false
	end

	if chatprint then
		if validLocale then
			Enchantrix.Util.ChatPrint(_ENCH('FrmtActSet'):format(_ENCH('CmdLocale'), param))
			Enchantrix.Command.SetKhaosSetKeyValue('locale', param)
		else
			Enchantrix.Util.ChatPrint(_ENCH("FrmtActUnknownLocale"):format(param))
			local locales = "    "
			for locale, data in pairs(EnchantrixLocalizations) do
				locales = locales .. " '" .. locale .. "' "
			end
			Enchantrix.Util.ChatPrint(locales)
		end
	end

	if (Enchantrix.State.Khaos_Registered) then
		Khaos.refresh(nil, nil, true)
	end

	Enchantrix.State.Locale_Changed = true
end

function getLocale()
	local locale = Enchantrix.Config.GetFilter('locale')
	if locale ~= 'default' then
		return locale
	end
	return GetLocale()
end

Enchantrix.Config = {
	Revision			= "$Revision$",
	AddonLoaded			= addonLoaded,

	GetFilterDefaults	= getFilterDefaults,
	GetFilter			= getFilter,
	SetFilter			= setFilter,

	GetFrameNames		= getFrameNames,
	GetFrameIndex		= getFrameIndex,
	SetFrame			= setFrame,

	SetLocale			= setLocale,
	GetLocale			= getLocale,
}
