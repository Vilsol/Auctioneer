﻿--[[
	Itemizer Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id$

	Itemizer core functions and variables.
	Functions central to the major operation of Itemizer.

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
]]

local inspect
local onEvent
local scanBank
local getItemLinks
local processLinks
local createFrames
local scanInventory
local scanMerchant
local registerEvents
local scanItemCache
local variablesLoaded
local addLinkToProcessStack

local inspectTargets = {};

local itemCacheScanCeiling = 30000; --At the time of writing, the item with the highest ItemID is "Undercity Pledge Collection" with an ItemID of 22300 (thanks to zeeg for the info [http://www.wowguru.com/db/items/id22300/]), so a ceiling of 30,000 is more than reasonable IMHO.

local eventsToRegister = {
	--General Events
	"ADDON_LOADED",
	"MERCHANT_SHOW",
	"BANKFRAME_OPENED",
	"UPDATE_MOUSEOVER_UNIT",
	"UNIT_INVENTORY_CHANGED",
	"PLAYER_TARGET_CHANGED",

	--Chat Events
	"CHAT_MSG_SAY",
	"CHAT_MSG_RAID",
	"CHAT_MSG_YELL",
	"CHAT_MSG_LOOT",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_SYSTEM",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_TEXT_EMOTE",
}

local bankSlots = {
	BANK_CONTAINER, 5, 6, 7, 8, 9, 10
}

function createFrames()
	if (ItemizerFrame) then
		return;
	end

	ItemizerFrame = CreateFrame("Frame", "ItemizerFrame", UIParent);
	ItemizerFrame:SetScript("OnEvent", Itemizer.Core.OnEvent);

	ItemizerTooltip = CreateFrame("GameTooltip", "ItemizerTooltip", nil, "GameTooltipTemplate");
	ItemizerHidden = CreateFrame("GameTooltip", "ItemizerHidden", nil, "GameTooltipTemplate");
	ItemizerHidden:Show();
	ItemizerHidden:SetOwner(this,"ANCHOR_NONE");
	ItemizerHidden:Show();

	ItemizerScanFrame = CreateFrame("Frame", "ItemizerScanFrame", UIParent);
	ItemizerScanFrame:SetScript("OnUpdate", function() Itemizer.Scanner.OnUpdate(arg1) end);
	ItemizerScanFrame:Show();
end

function registerEvents()
	for index, event in pairs(eventsToRegister) do
		ItemizerFrame:RegisterEvent(event)
	end
end

function onEvent()
	EnhTooltip.DebugPrint("Itemizer: OnEvent called", event);

	if (event == "UPDATE_MOUSEOVER_UNIT") then
		if (UnitIsPlayer("mouseover") and (UnitFactionGroup("mouseover") == Itemizer.Core.Constants.PlayerFaction)) then
			if CheckInteractDistance("mouseover", 1) then
				debugprofilestart()
				inspect("mouseover");
			end
		end

	elseif (event == "PLAYER_TARGET_CHANGED") then
		if (UnitIsPlayer("target") and (not UnitIsUnit("target", "player"))) then
			if CheckInteractDistance("target", 1) then
				debugprofilestart()
				inspect("target");
			end
		end

	elseif (string.find(event, "CHAT_MSG")) then
		debugprofilestart()
		processLinks(arg1);

	elseif (event == "UNIT_INVENTORY_CHANGED" and arg1 == "player") then
		debugprofilestart()
		scanInventory(arg1);
		inspect(arg1);

	elseif (event == "BANKFRAME_OPENED") then
		scanBank();

	elseif (event == "MERCHANT_SHOW") then
		debugprofilestart()
		scanMerchant();

	elseif (event == "ADDON_LOADED" and string.lower(arg1) == "itemizer") then
		variablesLoaded();
	end
end

function processLinks(str, fromAPI)
	local items

	if (fromAPI) then
		items = { str };

	else
		items = Itemizer.Util.GetItemLinks(str);
		if (table.getn(items) > 0) then
			EnhTooltip.DebugPrint("Itemizer: Found Item(s) in chat, number of items", table.getn(items), "Time taken", debugprofilestop());
		end
	end

	if (items) then
		for index, link in pairs(items) do

			--This debug call increases inspect time 20 fold, if the debugging frame is visible.
			--EnhTooltip.DebugPrint("Itemizer: Found Item", link);
			addLinkToProcessStack(link)
		end
	end
end

function inspect(unit)
	local name = UnitName(unit)
	local curTime = time()
	if ((not inspectTargets[name]) or (curTime - inspectTargets[name] > 30)) then
		EnhTooltip.DebugPrint("Itemizer: Inspecting Player", name);
		inspectTargets[name] = curTime
		local currentItem
		local numItems = 0

		for slot = 0, 19 do
			currentItem = GetInventoryItemLink(unit, slot)
			if (currentItem) then
				numItems = numItems + 1
				processLinks(currentItem, true)
			end
		end
	EnhTooltip.DebugPrint("Itemizer: Finished inspecting player", name, "Number of Items", numItems, "Time taken", debugprofilestop());
	end
end

function variablesLoaded()
	EnhTooltip.DebugPrint("Itemizer: ItemCache Size", Itemizer.Util.ItemCacheSize())
	ItemizerHidden:SetOwner(ItemizerHidden, "ANCHOR_NONE")
end

function scanMerchant()
	for index = 1, GetMerchantNumItems() do
		processLinks(GetMerchantItemLink(index), true)
	end

	EnhTooltip.DebugPrint("Itemizer: Finished scanning merchant", "Number of Items", GetMerchantNumItems(), "Time taken", debugprofilestop());
end

function scanItemCache()
	debugprofilestart()

	local link
	local itemsFound = 0
	local buildLink = Itemizer.Util.BuildLink

	for index = 1, Itemizer.Core.Constants.ItemCacheScanCeiling do
		link = buildLink(index)
		if (link) then
			processLinks(link, true)
			itemsFound = itemsFound + 1
		end
	end

	local totalTimeTaken = debugprofilestop()
	EnhTooltip.DebugPrint(
		"Itemizer: ScanitemCache() ItemCache entries scanned", Itemizer.Core.Constants.ItemCacheScanCeiling,
		"Number of Items found", itemsFound,
		"Time taken", totalTimeTaken,
		"Average time per found item", totalTimeTaken/itemsFound,
		"Average time per attempt", totalTimeTaken/Itemizer.Core.Constants.ItemCacheScanCeiling
	)
end

function scanInventory()
	local currentItem
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			currentItem = GetContainerItemLink(bag, slot)
			if (currentItem) then
				processLinks(currentItem, true)
			end
		end
	end
end

function scanBank()
	local currentItem
	for index, bag in pairs(bankSlots) do
		for slot = 1, GetContainerNumSlots(bag) do
			currentItem = GetContainerItemLink(bag, slot)
			if (currentItem) then
				processLinks(currentItem, true)
			end
		end
	end
end

function addLinkToProcessStack(link)
	if (not ItemizerProcessStack[link]) then
		ItemizerProcessStack[link] = { timer = GetTime(), lines = 0 }
	end
end

Itemizer.Core = {
	Constants = {},
	Inspect = inspect,
	OnEvent = onEvent,
	ScanBank = scanBank,
	ProcessLinks = processLinks,
	CreateFrames = createFrames,
	ScanInventory = scanInventory,
	ScanMerchant = scanMerchant,
	RegisterEvents = registerEvents,
	ScanItemCache = scanItemCache,
	VariablesLoaded = variablesLoaded,
	AddLinkToProcessStack = addLinkToProcessStack,
}

Itemizer.Core.Constants = {
	BankSlots = bankSlots,
	EventsToRegister = eventsToRegister,
	PlayerFaction = UnitFactionGroup("player"),
	ItemCacheScanCeiling = itemCacheScanCeiling,
}