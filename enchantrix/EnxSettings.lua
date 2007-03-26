--[[
	Enchantrix Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$

	Settings GUI

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

local lib = {}
Enchantrix.Settings = lib
local gui

local function getUserSig()
	local userSig = string.format("users.%s.%s", GetRealmName(), UnitName("player"))
	return userSig
end

local function getUserProfileName()
	if (not EnchantConfig) then EnchantConfig = {} end
	local userSig = getUserSig()
	return EnchantConfig[userSig] or "Default"
end

local itc = 0
local function getUserProfile()
	if (not EnchantConfig) then EnchantConfig = {} end
	local profileName = getUserProfileName()
	if (not EnchantConfig["profile."..profileName]) then
		if profileName ~= "Default" then
			profileName = "Default"
			EnchantConfig[getUserSig()] = "Default"
		end
		if profileName == "Default" then
			EnchantConfig["profile."..profileName] = {}
		end
	end
	return EnchantConfig["profile."..profileName]
end

local function getDefault(setting)
	local a,b,c = strsplit(".", setting)
	if (a == "show") then return true end
	if (b == "enable") then return true end
	if (a == "value") then
		return Enchantrix.Constants.StaticPrices[tonumber(b) or 0]
	end
	if (setting == "miniicon.angle")          then return 118     end
	if (setting == "miniicon.distance")       then return 12      end
end

local function setter(setting, value)
	if (not EnchantConfig) then EnchantConfig = {} end
	local a,b,c = strsplit(".", setting)
	if (a == "profile") then
		if (setting == "profile.save") then
			value = gui.elements["profile.name"]:GetText()

			-- Create the new profile
			EnchantConfig["profile."..value] = {}

			-- Set the current profile to the new profile
			EnchantConfig[getUserSig()] = value
			-- Get the new current profile
			local newProfile = getUserProfile()
			-- Clean it out and then resave all data
			cleanse(newProfile)
			gui.Resave()

			-- Add the new profile to the profiles list
			local profiles = EnchantConfig["profiles"]
			if (not profiles) then
				profiles = { "Default" }
				EnchantConfig["profiles"] = profiles
			end
			-- Check to see if it already exists
			local found = false
			for pos, name in ipairs(profiles) do
				if (name == value) then found = true end
			end
			-- If not, add it and then sort it
			if (not found) then
				table.insert(profiles, value)
				table.sort(profiles)
			end
			DEFAULT_CHAT_FRAME:AddMessage("Saved profile: "..value)
		elseif (setting == "profile.delete") then
			-- User clicked the Delete button, see what the select box's value is.
			value = gui.elements["profile"].value

			-- If there's a profile name supplied
			if (value) then
				-- Clean it's profile container of values
				cleanse(EnchantConfig["profile."..value])
				-- Delete it's profile container
				EnchantConfig["profile."..value] = nil
				-- Find it's entry in the profiles list
				local profiles = EnchantConfig["profiles"]
				if (profiles) then
					for pos, name in ipairs(profiles) do
						-- If this is it, then extract it
						if (name == value and name ~= "Default") then
							table.remove(profiles, pos)
						end
					end
				end
				-- If the user was using this one, then move them to Default
				if (getUserProfileName() == value) then
					EnchantConfig[getUserSig()] = 'Default'
				end
				DEFAULT_CHAT_FRAME:AddMessage("Deleted profile: "..value)
			end
		elseif (setting == "profile") then
			-- User selected a different value in the select box, get it
			value = gui.elements["profile"].value

			-- Change the user's current profile to this new one
			EnchantConfig[getUserSig()] = value
			DEFAULT_CHAT_FRAME:AddMessage("Changing profile: "..value)
		end

		-- Refresh all values to reflect current data
		gui.Refresh()
	else
		-- Set the value for this setting in the current profile
		local db = getUserProfile()
		db[setting] = value
		--setUpdated()
	end

	if (a == "miniicon") then
		Enchantrix.MiniIcon.Reposition()
	end
		
end
function lib.SetSetting(...)
	setter(...)
	if (gui) then
		gui.Refresh()
	end
end
	

local function getter(setting)
	if (not EnchantConfig) then EnchantConfig = {} end
	if not setting then return end

	local a,b,c = strsplit(".", setting)
	if (a == 'profile') then
		if (b == 'profiles') then
			local pList = EnchantConfig["profiles"]
			if (not pList) then
				pList = { "Default" }
			end
			return pList
		end
	end
	if (setting == 'profile') then
		return getUserProfileName()
	end
	if (setting == 'track.styles') then
		return {
			"Black",
			"Blue",
			"Cyan",
			"Green",
			"Magenta",
			"Red",
			"Test",
			"White",
			"Yellow",
		}
	end
	local db = getUserProfile()
	if ( db[setting] ~= nil ) then
		return db[setting]
	else
		return getDefault(setting)
	end
end
function lib.GetSetting(setting, default)
	local option = getter(setting)
	if ( option ~= nil ) then
		return option
	else
		return default
	end
end

local function gsc(value)
	return EnhTooltip.GetTextGSC(value, true)
end

function lib.MakeGuiConfig()
	if gui then return end

	local id, last, cont
	gui = Configator.NewConfigator(setter, getter)
	lib.Gui = gui

  	gui.AddCat("Enchantrix")
	id = gui.AddTab("Profiles")
	gui.AddControl(id, "Header",     0,    "Setup, configure and edit profiles")
	gui.AddControl(id, "Subhead",    0,    "Activate a current profile")
	gui.AddControl(id, "Selectbox",  0, 1, "profile.profiles", "profile", "Switch to given profile")
	gui.AddControl(id, "Button",     0, 1, "profile.delete", "Delete")
	gui.AddControl(id, "Subhead",    0,    "Create or replace a profile")
	gui.AddControl(id, "Text",       0, 1, "profile.name", "New profile name:")
	gui.AddControl(id, "Button",     0, 1, "profile.save", "Save")

	id = gui.AddTab("General")
	gui.AddControl(id, "Header",         0,    "General Enchantrix options")
	gui.AddControl(id, "Subhead",        0,    "Minimap display options")
	gui.AddControl(id, "Checkbox",       0, 1, "miniicon.enable", "Display Minimap button")
	gui.AddControl(id, "Slider",         0, 2, "miniicon.angle", 0, 360, 1, "Button angle: %d")
	gui.AddControl(id, "Slider",         0, 2, "miniicon.distance", -80, 80, 1, "Distance: %d")
end
