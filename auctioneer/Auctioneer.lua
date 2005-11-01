-- Auctioneer
AUCTIONEER_VERSION="<%version%>";
-- Revision: $Id$
-- Original version written by Norganna.
-- Contributors: Araband
--
-- This is an addon for World of Warcraft that adds statistical history to the auction data that is collected
-- when the auction is scanned, so that you can easily determine what price
-- you will be able to sell an item for at auction or at a vendor whenever you
-- mouse-over an item in the game
--
--

-- If you want to see debug messages, create a window called "Debug" within the client.
if (AUCTIONEER_VERSION == "<".."%version%>") then
	AUCTIONEER_VERSION = "3.1.DEV";
end

function Auctioneer_OnLoad()
	-- Hook in new tooltip code
	Stubby.RegisterFunctionHook("EnhTooltip.AddTooltip", 100, Auctioneer_HookTooltip);

	-- Register our temporary command hook with stubby
	Stubby.RegisterBootCode("Auctioneer", "CommandHandler", [[
		local function cmdHandler(msg)
			local i,j, cmd, param = string.find(string.lower(msg), "^([^ ]+) (.+)$")
			if (not cmd) then cmd = string.lower(msg) end 
			if (not cmd) then cmd = "" end 
			if (not param) then param = "" end
			if (cmd == "load") then
				if (param == "") then
					Stubby.Print("Manually loading Auctioneer...")
					LoadAddOn("Auctioneer")
				elseif (param == "auctionhouse") then
					Stubby.Print("Setting Auctioneer to load when this character visits the auction house")
					Stubby.SetConfig("Auctioneer", "LoadType", param) 
				elseif (param == "always") then
					Stubby.Print("Setting Auctioneer to always load for this character")
					Stubby.SetConfig("Auctioneer", "LoadType", param)
					LoadAddOn("Auctioneer")
				elseif (param == "never") then
					Stubby.Print("Setting Auctioneer to never load automatically for this character (you may still load manually)")
					Stubby.SetConfig("Auctioneer", "LoadType", param)
				else
					Stubby.Print("Your command was not understood")
				end
			else
				Stubby.Print("Auctioneer is currently not loaded.")
				Stubby.Print("  You may load it now by typing |cffffffff/auctioneer load|r")
				Stubby.Print("  You may also set your loading preferences for this character by using the following commands:")
				Stubby.Print("  |cffffffff/auctioneer load auctionhouse|r - Auctioneer will load when you visit the auction house")
				Stubby.Print("  |cffffffff/auctioneer load always|r - Auctioneer will always load for this character")
				Stubby.Print("  |cffffffff/auctioneer load never|r - Auctioneer will never load automatically for this character (you may still load it manually)")
			end
		end
		SLASH_AUCTIONEER1 = "/auctioneer"
		SLASH_AUCTIONEER2 = "/auction"
		SLASH_AUCTIONEER3 = "/auc"
		SlashCmdList["AUCTIONEER"] = cmdHandler
	]]);
	Stubby.RegisterBootCode("Auctioneer", "Triggers", [[
		local function checkLoad(event)
			local loadType = Stubby.GetConfig("Auctioneer", "LoadType")
			if (loadType == "auctionhouse" or not loadType) then
				LoadAddOn("Auctioneer")
				Auctioneer_AuctHouseShow()
			else
				BrowseNoResultsText:SetText("]].._AUCT['MesgNotLoaded']..[[");
			end
		end
		Stubby.RegisterEventHook("AUCTION_HOUSE_SHOW", "Auctioneer", checkLoad)
		local loadType = Stubby.GetConfig("Auctioneer", "LoadType")
		if (loadType == "always") then
			LoadAddOn("Auctioneer")
		else
			Stubby.Print("]].._AUCT['MesgNotLoaded']..[[");
		end
	]]);
end


