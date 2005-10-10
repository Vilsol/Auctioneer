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
if (AUCTIONEER_VERSION == "<".."%version%>") then
	AUCTIONEER_VERSION = "3.1.DEV";
end

function Auctioneer_OnLoad()
	-- Hook in new tooltip code
	EnhTooltip.AddHook("tooltip", Auctioneer_HookTooltip, 50);

	this:RegisterEvent("VARIABLES_LOADED"); -- get called when our vars have loaded
end


function Auctioneer_OnEvent(event)
--	Auctioneer_p("Event", event);
	if (event=="NEW_AUCTION_UPDATE") then
		Auctioneer_NewAuction();
	elseif (event=="AUCTION_HOUSE_SHOW") then
		Auctioneer_AuctHouseShow();
	elseif(event == "AUCTION_HOUSE_CLOSED") then
		Auctioneer_AuctHouseClose();
	elseif(event == "AUCTION_ITEM_LIST_UPDATE" and Auctioneer_isScanningRequested) then
		Auctioneer_AuctHouseUpdate();
	elseif (event == "VARIABLES_LOADED") then
		Auctioneer_AddonLoaded();
	end
end

