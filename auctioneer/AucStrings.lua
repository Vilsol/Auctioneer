--[[
	WARNING: This is a generated file.
	If you wish to perform or update localizations, please go to our Localizer website at:
	http://norganna.org/localizer/index.php

	AddOn: Auctioneer
	Revision: $Id$
	Version: <%version%> (<%codename%>)

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
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
Auctioneer_RegisterRevision("$URL$", "$Rev$")

AuctioneerLocalizations = {

	csCZ = {


		-- Section: AskPrice Messages
		AskPriceAd	= "Zjisti cenu sady/stacku %sx[ItemLink] (x = velikost sady) ";
		FrmtAskPriceBuyoutMedianHistorical	= "%sVykup-median historicky: %s%s";
		FrmtAskPriceBuyoutMedianSnapshot	= "%sVykup-median posledni zaznam: %s%s";
		FrmtAskPriceDisable	= "Vypinam nastaveni %s VychoziCena";
		FrmtAskPriceEach	= "(%s kazdy)";
		FrmtAskPriceEnable	= "Zapinam nastaveni %s VychoziCena";
		FrmtAskPriceVendorPrice	= "%sProdejne v obchode za: %s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "Predmet byl odstranen z aukce %s .";
		FrmtAuctinfoHist	= "%d zaznamy";
		FrmtAuctinfoLow	= "Nejnizsi cena";
		FrmtAuctinfoMktprice	= "Obvykla trzni cena";
		FrmtAuctinfoNolow	= "Predmet zatim nebyl v aukci zaznamenan.";
		FrmtAuctinfoOrig	= "Puvodni nabidka";
		FrmtAuctinfoSnap	= "%d posledni zaznam";
		FrmtAuctinfoSugbid	= "Pocatecni nabidka";
		FrmtAuctinfoSugbuy	= "Vykupni cena";
		FrmtWarnAbovemkt	= "Zvolena cena je NADprumerna";
		FrmtWarnMarkup	= "Navyseni vendor ceny o %s%%";
		FrmtWarnMyprice	= "Pouzita dosavadni cena";
		FrmtWarnNocomp	= "Neni konkurence";
		FrmtWarnNodata	= "Malo zaznamu k stanoveni nejvyssi vhodne ceny";
		FrmtWarnToolow	= "Existuje konkurencni nabidka pod cenou";
		FrmtWarnUndercut	= "Podcenuji objekt o %s%%";
		FrmtWarnUser	= "Pouzita jiz zvolena cena";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "Momentalne jste vedouci v teto aukci: %s (x%d)";
		FrmtBidAuction	= "Bid na aukci: %s (x%d)";
		FrmtBidQueueOutOfSync	= "Chyba: Bid fronta nebyla syncovana!";
		FrmtBoughtAuction	= "Vykoupena aukce: %s (x%d)";
		FrmtMaxBidsReached	= "Bylo nalezeno vice aukci %s (x%d), ale bidovaci limit byl jiz dosazen {%d)";
		FrmtNoAuctionsFound	= "Nenalezena zadna aukce: %s (x%d)";
		FrmtNoMoreAuctionsFound	= "Zadna dalsi aukce nebyla nalezenea: %s (x%d)";
		FrmtNotEnoughMoney	= "Nedostatek penez na bid teto aukce: %s (x%d)";
		FrmtSkippedAuctionWithHigherBid	= "Nelze bidovat s vyssim bidem: %s (x%d)";
		FrmtSkippedAuctionWithLowerBid	= "Nelze bidovat s mensim bidem: %s (x%d)";
		FrmtSkippedBiddingOnOwnAuction	= "Nelze bidovat na vlastni aukci: %s (x%d)";
		UiProcessingBidRequests	= "Provadim bidovaci pozadavek...";


		-- Section: Command Messages
		ConstantsCritical	= "V��N�: Soubor Auctioneera \"SavedVariables\" je u� naplnen z %.3f%%!";
		ConstantsMessage	= "Soubor Auctioneera \"SavedVariables\" je u� naplnen z %.3f%%!";
		ConstantsWarning	= "VAROV�N�: Soubor Auctioneera \"SavedVariables\" je u� naplnen z %.3f%%!";
		FrmtActClearall	= "Mazu vsechna aukcni data k %s";
		FrmtActClearFail	= "Nelze najit predmet: %s";
		FrmtActClearOk	= "Smazana data k predmetu: %s";
		FrmtActClearsnap	= "Mazu cely posledni zaznam z AH.";
		FrmtActDefault	= "Obnoveny z�kladn� hodnoty pro nastaven� %s ";
		FrmtActDefaultall	= "V�echna nastaven� Auctioneera byla vr�cena na z�kladn� hodnoty.";
		FrmtActDisable	= "Nezobrazuji data predmetu o %s";
		FrmtActEnable	= "Zobrazuji data predmetu o %s";
		FrmtActSet	= "Nastavuji %s na '%s'";
		FrmtActUnknown	= "Neznamy prikaz: '%s'";
		FrmtAuctionDuration	= "Zakladni trvani aukce nastaveno na: %s";
		FrmtAutostart	= "Auto-cena nastavena: %s naBIDka a %s Vykup (%dh)\n%s";
		FrmtFinish	= "Po skonceni skenu bude %s";
		FrmtPrintin	= "Zpravy z Auctioneeru se nyni budou zobrazovat v okne \"%s\"";
		FrmtProtectWindow	= "Ochrana AH okna proti zavreni nastavena na: %s";
		FrmtUnknownArg	= "'%s'neni platna hodnota pro '%s'";
		FrmtUnknownLocale	= "Zadany jazyk ('%s') je neznamy. Dostupne jsou:";
		FrmtUnknownRf	= "Neznamy parametr ('%s'). Platny format je: [server]-[strana]. Napriklad: Shadow Moon-Horde";


		-- Section: Command Options
		OptAlso	= "(server-frakce|protivnik)";
		OptAskPriceSend	= "(<PlayerName> <AskPrice Query>)";
		OptAuctionDuration	= "(trvani||2h||8h||24h)";
		OptBidbroker	= "<stribro_zisk>";
		OptBidLimit	= "<cislo>";
		OptBroker	= "<stribro_zisk>";
		OptClear	= "([Objekt]|vse|zaznam)";
		OptCompete	= "<stribro_mene>";
		OptDefault	= "(<nastaveni>|vse)";
		OptFinish	= "(off|logout|exit|reloadui)";
		OptLocale	= "<jazyk>";
		OptPctBidmarkdown	= "<procent>";
		OptPctMarkup	= "<procent>";
		OptPctMaxless	= "<procent>";
		OptPctNocomp	= "<procent>";
		OptPctUnderlow	= "<procento>";
		OptPctUndermkt	= "<procent>";
		OptPercentless	= "<procent>";
		OptPrintin	= "(<oknoIndex>[Cislo]|<oknoJmeno>[String])";
		OptProtectWindow	= "(nikdy||sken||vzdy)";
		OptScale	= "<rozmer_nasobek>";
		OptScan	= "<sken_parametr>";


		-- Section: Commands
		CmdAlso	= "take";
		CmdAlsoOpposite	= "protistrana";
		CmdAlt	= "Alt";
		CmdAskPriceAd	= "oznameni";
		CmdAskPriceGuild	= "guilda";
		CmdAskPriceParty	= "parta";
		CmdAskPriceSend	= "odeslat";
		CmdAskPriceSmart	= "chytre";
		CmdAskPriceSmartWord1	= "co";
		CmdAskPriceSmartWord2	= "cenny";
		CmdAskPriceTrigger	= "spoustec";
		CmdAskPriceVendor	= "vendor";
		CmdAskPriceWhispers	= "whispers";
		CmdAskPriceWord	= "word";
		CmdAuctionClick	= "aukcni-klik";
		CmdAuctionDuration	= "trvani-aukce";
		CmdAuctionDuration0	= "posledni";
		CmdAuctionDuration1	= "2hod";
		CmdAuctionDuration2	= "8hod";
		CmdAuctionDuration3	= "24hod";
		CmdAutofill	= "autoceny";
		CmdBidbroker	= "bidfiltr";
		CmdBidbrokerShort	= "bf";
		CmdBidLimit	= "bid-limit";
		CmdBroker	= "filtr";
		CmdClear	= "smazat";
		CmdClearAll	= "vse";
		CmdClearSnapshot	= "zapomen";
		CmdCompete	= "konkurfiltr";
		CmdCtrl	= "Ctrl";
		CmdDefault	= "vychozi";
		CmdDisable	= "deaktivovat";
		CmdEmbed	= "integrovat";
		CmdFinish	= "dokonci";
		CmdFinish0	= "vypni";
		CmdFinish1	= "logout";
		CmdFinish2	= "quit";
		CmdFinish3	= "realoadui";
		CmdFinishSound	= "konec-zvonec";
		CmdHelp	= "pomoc";
		CmdLocale	= "jazyk";
		CmdOff	= "vypnout";
		CmdOn	= "zapnout";
		CmdPctBidmarkdown	= "proc-snizit";
		CmdPctMarkup	= "proc-zvysit";
		CmdPctMaxless	= "proc-maxztr";
		CmdPctNocomp	= "proc-bezkonkr";
		CmdPctUnderlow	= "proc-nejsleva";
		CmdPctUndermkt	= "proc-podtrhem";
		CmdPercentless	= "procfiltr";
		CmdPercentlessShort	= "pf";
		CmdPrintin	= "zobrazovat-v";
		CmdProtectWindow	= "ochran-okno";
		CmdProtectWindow0	= "nikdy";
		CmdProtectWindow1	= "sken";
		CmdProtectWindow2	= "vzdy";
		CmdScan	= "skenuj";
		CmdShift	= "Shift";
		CmdToggle	= "prepnout";
		CmdUpdatePrice	= "update-cena";
		CmdWarnColor	= "varovat-barva";
		ShowAverage	= "zobraz-prumer";
		ShowEmbedBlank	= "integruj-oddelovac";
		ShowLink	= "zobraz-linky";
		ShowMedian	= "zobraz-stred";
		ShowRedo	= "zobraz-varovani";
		ShowStats	= "zobraz-statistiky";
		ShowSuggest	= "zobraz-doporuceni";
		ShowVerbose	= "zobraz-podrobnosti";


		-- Section: Config Text
		GuiAlso	= "Take zobraz data o";
		GuiAlsoDisplay	= "Zobrazuji data o %s";
		GuiAlsoOff	= "Nezobrazuji data o jinych serverech/frakcich.";
		GuiAlsoOpposite	= "Zobrazuji take data o protistrane.";
		GuiAskPrice	= "Zapnout AskPrice";
		GuiAskPriceAd	= "Zaslat data ";
		GuiAskPriceGuild	= "Odpovedet na guildchat";
		GuiAskPriceHeader	= "AskPrice nastaveni";
		GuiAskPriceHeaderHelp	= "Zmenit AskPrice chovani";
		GuiAskPriceParty	= "Odpovedet na partychat";
		GuiAskPriceSmart	= "Pouzit \"SmartWords\"";
		GuiAskPriceTrigger	= "AskPrice prepinac";
		GuiAskPriceVendor	= "Zaslat info o vendorovi";
		GuiAskPriceWhispers	= "Zobrazovat odesilane \"whispers\"";
		GuiAskPriceWord	= "Vlastn� \"SmartWord\" %d";
		GuiAuctionDuration	= "Zakladni trvani aukce";
		GuiAuctionHouseHeader	= "Aukci Dum - nastaveni";
		GuiAuctionHouseHeaderHelp	= "Tato nastaveni ovlivnuji fungovani Aukcniho Domu";
		GuiAutofill	= "Automaticke zadavani cen v Aukci";
		GuiAverages	= "Zobraz prumery";
		GuiBidmarkdown	= "Procento z ceny";
		GuiClearall	= "Smaz vsechny Auctioneer zaznamy";
		GuiClearallButton	= "Smaz Vse";
		GuiClearallHelp	= "Klikni zde pro smazani vsech zaznamu pro zvoleny server";
		GuiClearallNote	= "pro zvoleny server a frakci.";
		GuiClearHeader	= "Mazani zaznamu";
		GuiClearHelp	= "Smaze Auctioneerovi zaznamy. Vyberte - vse, nebo posledni zaznam. POZOR: Smazana data nelze obnovit.";
		GuiClearsnap	= "Smazat posledni zaznam";
		GuiClearsnapButton	= "Smazat zaznam";
		GuiClearsnapHelp	= "Klikni zde pro smazani posledniho Auctioneer zaznamu.";
		GuiDefaultAll	= "Obnov vsechna vychozi Auctioneer nastaveni.";
		GuiDefaultAllButton	= "Obnov vse";
		GuiDefaultAllHelp	= "Klikni zde pro navrat vsech Auctioneer nastaveni na vychozi hodnoty. POZOR: Nelze vratit! ";
		GuiDefaultOption	= "Obnov vychozi nastaveni";
		GuiEmbed	= "Vkl�dat informace do n�poved";
		GuiEmbedBlankline	= "Integruj oddelovac do popisek objektu";
		GuiEmbedHeader	= "Integrace";
		GuiFinish	= "Po skonceni scanu";
		GuiFinishSound	= "Po skoncen� skenu zahr�t zvuk";
		GuiLink	= "Zobraz cislo linku";
		GuiLoad	= "Spust Auctioneer";
		GuiLoad_Always	= "vzdy";
		GuiLoad_AuctionHouse	= "v Aukcnim Dome";
		GuiLoad_Never	= "nikdy";
		GuiLocale	= "Nastavit jazyk na";
		GuiMainEnable	= "Spustit Auctioneer";
		GuiMainHelp	= "Obsahuje nastaveni pro Auctioneer - AddOn ktery sbira a zobrazuje informace z aukce ohledne cen. Klikni na \"Sken\" v Aukci pro zaznamenani aktualnich statistik. ";
		GuiMarkup	= "Procento navyseni vendor ceny";
		GuiMaxless	= "Nejvyssi mozna sleva vuci trzni cene";
		GuiMedian	= "Zobrazuj stredni hodnoty";
		GuiNocomp	= "Neni konkurence - nelze slevit";
		GuiNoWorldMap	= "Auctioneer: Protekce Aukce - Zablokovano otevreni mapy!";
		GuiOtherHeader	= "Dalsi nastaveni";
		GuiOtherHelp	= "Rozlicna Auctioneer nastaveni ";
		GuiPercentsHeader	= "Procentuelne limitujici nastaveni";
		GuiPercentsHelp	= "POZOR: Nasledujici nastaveni urcuji trzni strategii nastavovani cen pomoci Auctioneeru. Jakekoliv zmeny proto zvazte, nejste-li zkuseni hraci a ekonomove.";
		GuiPrintin	= "Vyber textove okno";
		GuiProtectWindow	= "Ochran Aukci proti nechtenemu zavreni";
		GuiRedo	= "Zobraz varovani zasekleho skenu";
		GuiReloadui	= "Znovu nahraj interface\n";
		GuiReloaduiButton	= "NahrajInterface";
		GuiReloaduiFeedback	= "Nahravam interface";
		GuiReloaduiHelp	= "Klikni zde pro opetovne nahrani herniho interface vcetne zvoleneho jazyka. Nahravani muze trvat nekolik minut.";
		GuiRememberText	= "Ukladej ceny";
		GuiStatsEnable	= "Zobrazuj statistiky";
		GuiStatsHeader	= "Statistiky cen objektu";
		GuiStatsHelp	= "Zobrazuj tyto statistiky v popiskach";
		GuiSuggest	= "Zobrazuj doporucene ceny";
		GuiUnderlow	= "Nejnizsi zlevneni trzni ceny";
		GuiUndermkt	= "Krizova sleva z trzni ceny pro pripad ze \"maxztrata\" nestaci";
		GuiVerbose	= "Podrobny mod";
		GuiWarnColor	= "Barevny cenovy model";


		-- Section: Conversion Messages
		MesgConvert	= "Prevod Auctioneer databaze. Nejdriv si prosim zalohujte soubor SavedVariables\Auctioneer.lua first.%s%s";
		MesgConvertNo	= "Vypnout Auctioneer";
		MesgConvertYes	= "Prevest";
		MesgNotconverting	= "Neprevedli jste vasi databazi, Auctioneer ale nebude fungovat dokud tak neucinite. ";


		-- Section: Game Constants
		TimeLong	= "Dlouze";
		TimeMed	= "Stredne";
		TimeShort	= "Kratce";
		TimeVlong	= "Velmi douze";


		-- Section: Generic Messages
		ConfirmBidBuyout	= "Urcite chce� %s\n%dx%s pro:";
		DisableMsg	= "Deaktivuji automaticke zapinani Auctioneeru";
		FrmtWelcome	= "Auctioneer v%s poprve spusten, pripraven k akci!";
		MesgNotLoaded	= "Auctioneer neni spusten. Zadejte /auctioneer pro vice informaci. ";
		StatAskPriceOff	= "AskPrice je vypnut";
		StatAskPriceOn	= "AskPrice je zapnut";
		StatOff	= "Nezobrazuji zadna data.";
		StatOn	= "Zobrazuji (vami) nastavene polozky.";


		-- Section: Generic Strings
		TextAuction	= "Aukce";
		TextCombat	= "Boj";
		TextGeneral	= "Hlavni";
		TextNone	= "nic";
		TextScan	= "Sken\n";
		TextUsage	= "Uziti:";


		-- Section: Help Text
		HelpAlso	= "Prikaz Also zobrazi do popisku statistiky platne pro JINY server. Server a frakci zvolite zadanim nazvu nebo slovem \"protistrana\". Pouziti: /auctioneer also Shadow Moon-Horde.";
		HelpAskPrice	= "Zapnout nebo vypnout AskPrice.";
		HelpAskPriceAd	= "Zapnout nebo vypnout nove schopnosti AskPrice";
		HelpAskPriceGuild	= "Odpovedet na dotazy v guild chatu.";
		HelpAskPriceParty	= "Odpovedet na dotazy v party chatu.";
		HelpAskPriceSend	= "Rucne odeslat hr�ci v�sledek dotazu \"AskPrice\".";
		HelpAskPriceSmart	= "Zapnout nebo vypnout kontrolu SmartWords.";
		HelpAskPriceTrigger	= "Zmenit znak, ktery spousti AskPrice.";
		HelpAskPriceVendor	= "Zapnout nebo vypnout odesilani dat o cenach u prodavacu.";
		HelpAskPriceWhispers	= "Prep�n� zobrazen� odchoz�ch zpr�v \"AskPrice\" (viditeln� nebo neviditeln�).";
		HelpAskPriceWord	= "Pridat nebo zmenit vlastn� \"SmartWords\" pro \"AskPrice\".";
		HelpAuctionClick	= "Umoznuje automaticky vlozit predmet z inventare do aukce pomoci Alt-Kliku a zalo�it pro nej aukci.";
		HelpAuctionDuration	= "Pri otevreni Aukce nastavi zvolenou vychozi hodnotu jejiho trvani. ";
		HelpAutofill	= "Nastavi zda ma Auctioneer vyplnit doporucene ceny pri vytvareni aukce (ty vzdy lze zmenit)";
		HelpAverage	= "Nastavi zda se maji zobrazovat prumerne aukci ceny";
		HelpBidbroker	= "Zobrazi kratke a stredni aukce z posledniho zaznamu jejichz momentalni nabidka je pod cenou a tak na nich lze vydelat";
		HelpBidLimit	= "Maximalni pocet aukci, na ktere se da bidovat nebo buyoutovat, kdyz stisknete Bid nebo Buyout tlacitko na Search Auctions karte.";
		HelpBroker	= "Zobrazi vsechny aukce z posledniho zaznamu, ktere koupene za momentalni naBIDku lze pozdeji prodat se ziskem";
		HelpClear	= "Smaze zaznamy k vybranemu objektu (objekt vlozite do prikazu Shift-Klikem) nebo zadanim \"vse\" nebo jen posledni \"zaznam\". ";
		HelpCompete	= "Zobrazi vsechny aukce z posledniho zaznamu, jejichz Vykupni cena je nizsi, nez ta vase za stejny predmet";
		HelpDefault	= "Obnovi vychozu hodnotu zvoleneho nastaveni Auctioneeru. Take lze zadat \"vse\" pro obnoveni vsech nastaveni na vychozi hodnoty. ";
		HelpDisable	= "Deaktivuje automaticke zapinani Auctioneeru pri pristim prihlaseni ";
		HelpEmbed	= "Prida/integruje Auctioneer statistiky do puvodniho popisku objektu (ale nektere moznosti jsou v tomto modu nedostupne)";
		HelpEmbedBlank	= "Nastavi zda se ma zobrazovat prazdny radek mezi puvodnim popiskem predmetu a pridanymi statistikami, jsou-li integrovane do popisku objektu";
		HelpFinish	= "Nastavit, jestli automaticky odhlasit nebo vypnout hru po ukonceni skenovani aukci";
		HelpFinishSound	= "Nastav� zda se m� po skoncen� skenu zahr�t zvuk.";
		HelpLink	= "Nastavi zda se ma zobrazovat ID/cislo linku objektu do popisku";
		HelpLoad	= "Zmeni zapinani Auctioneeru pro tuto postavu";
		HelpLocale	= "Zmeni jazyk, v jakem s vami Auctioneer komunikuje";
		HelpMedian	= "Nastavi zda se ma zobrazovat \"median\" vykupni cena predmetu";
		HelpOnoff	= "Zapne nebo vypne zobrazovani ziskanych cenovych zaznamu";
		HelpPctBidmarkdown	= "Nastavi procento Vykupni ceny, podle ktereho se urci pocatecni nabidka";
		HelpPctMarkup	= "Nastavi procento, o ktere se nadsadi vykupni cena v obchode, nejsou-li k dispozici jine udaje";
		HelpPctMaxless	= "Nastavi maximalni procento, o ktere se Auctioneer pokusi slevit z bezne trzni ceny";
		HelpPctNocomp	= "Nastavi procento o ktere Auctioneer slevi z bezne trzni ceny, kdyz neexistuje konkurence";
		HelpPctUnderlow	= "Nastavi procento, o ktere ma Auctioneer \"podrazit\" nejnizsi cenu daneho objektu v aktualnim zaznamu";
		HelpPctUndermkt	= "Procento slevy z trzni ceny pro prekonani konkurence kdyz rozdil prekonal \"maxztrata\" limit";
		HelpPercentless	= "Zobrazi vsechny aukce z posledniho zaznamu, jejichz vykupni cena je o urcene procento nizsi, nez jejich zaznamenana nejvyssi uspesna vykupni cena";
		HelpPrintin	= "Nastavi v kterem okne ma Auctioneer vypisovat zpravy. Muzete zvolit jmeno okna nebo jeho index.";
		HelpProtectWindow	= "Zabrani nechtenemu zavreni Aukcniho okna";
		HelpRedo	= "Nastavi zda se ma zobrazovat varovani, kdyz nacitani aktualni aukcni stranky trva prilis dlouho kvuli pretizeni serveru.";
		HelpScan	= "Provede sken vybrannych aukci pri vasi pristi navsteve, nebo hned (take je zde \"sken\" tlacitko v aukcnim okne). Zaskrtnete ktere kategorie chcete naskenovat.";
		HelpStats	= "Nastavi zda se ma zobrazovat procenta u nabidky a vykupni ceny";
		HelpSuggest	= "Nastavi zda se ma zobrazovat doporucena aukci cena";
		HelpUpdatePrice	= "Automaticky updatuje pocatecni cenu pro aukci na tabulce Podavani aukci, pri zmene Vykupni ceny.";
		HelpVerbose	= "Nastavi zda se maji zobrazovat detailni prumerne a doporucene ceny (\"vypnuto\" znamena ze se budou zobrazovat v jednom radku)";
		HelpWarnColor	= "Vyber jestli ukazovat aktualni AH cenovy model v intuitivnich barvach.";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "Zadne volne pack misto pro vytvoreni aukce!";
		FrmtNotEnoughOfItem	= "Nedostatek %s penez pro vytvoreni aukce!";
		FrmtPostedAuction	= "Podana 1 aukce %s (x%d)";
		FrmtPostedAuctions	= "Podano %d aukci %s (x%d)";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "tedNabidka";
		FrmtBidbrokerDone	= "Vypis nabidek dokoncen";
		FrmtBidbrokerHeader	= "Minimalni zisk: %s, NDC = 'Nejvyssi Dosazitelna Cena'";
		FrmtBidbrokerLine	= "%s, poslecnich %s zaznamenanych, NDC: %s, %s: %s, Zisk: %s, Cas: %s";
		FrmtBidbrokerMinbid	= "minNabidka";
		FrmtBrokerDone	= "Vypis dokoncen";
		FrmtBrokerHeader	= "Minimalni zisk: %s, NDC = 'Nejvyssi Dosazitelna Cena'";
		FrmtBrokerLine	= "%s, poslednich %s zaznamenanych, NDC: %s, Vykup: %s, zisk: %s";
		FrmtCompeteDone	= "Prebijeni aukci dokonceno";
		FrmtCompeteHeader	= "Prebit aukce alespon o %s za 1 kus.";
		FrmtCompeteLine	= "%s, Nabidka: %s, Vykup %s vs %s, %s levnejsi";
		FrmtHspLine	= "Nejvyssi Dosazitelna Cena za jeden %s je: %s";
		FrmtLowLine	= "%s, Vykup: %s, Prodejce: %s, Za jeden: %s, Mene nez median: %s";
		FrmtMedianLine	= "U poslednich %d zaznamenanych, median Vykup za 1 kus %s je: %s";
		FrmtNoauct	= "Nenalezeny zadne aukce predmetu: %s";
		FrmtPctlessDone	= "Vypis \"percentless\" dokoncen. ";
		FrmtPctlessHeader	= "Procentuelni rozdil od Nejvyssi Dosazitelne Ceny (NDC): %d%%";
		FrmtPctlessLine	= "%s, Poslednich %d zaznamenanych, NDC: %s, Vykup: %s, Zisk: %s, Levnejsi %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "Neplatnych aukci odstraneno: %s";
		AuctionDiscrepancies	= "Odlisnosti: %s";
		AuctionNewAucts	= "Novych aukci zaznamenano: %s";
		AuctionOldAucts	= "Jiz drive zaznamenanych: %s";
		AuctionPageN	= "Auctioneer: skenuji %s, stranu %d z %d Aukci za vterinu: %s Odhadovany cas do konce: %s";
		AuctionScanDone	= "Auctioneer: Skenovani aukci ukonceno.";
		AuctionScanNexttime	= "Auctioneer provede kompletni sken aukci pri pristi navsteve.";
		AuctionScanNocat	= "Musi byt vybrana alespon jedna kategorie.";
		AuctionScanRedo	= "Posledni strana trvala pres %d vterin, zkousim to znovu...";
		AuctionScanStart	= "Auctioneer: Skenuji prvni stranu %s...";
		AuctionTotalAucts	= "Celkem zaznamenano aukci: %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "Videno %d -krat na %s";
		FrmtInfoAverage	= "%s min/%s Vykup (%s nabidka)";
		FrmtInfoBidMulti	= "Nabidnuto (%s%s za kus)";
		FrmtInfoBidOne	= "Nabidnuto %s";
		FrmtInfoBidrate	= "%d%% ma nabidku, %d%% ma Vykup";
		FrmtInfoBuymedian	= "Median vykup ";
		FrmtInfoBuyMulti	= "Vykup (%s%s za kus)";
		FrmtInfoBuyOne	= "Vykup %s";
		FrmtInfoForone	= "Za 1: %s min/%s Vykup (%s nabidka) [v %d's]";
		FrmtInfoHeadMulti	= "Prumery pro %d predmetu: ";
		FrmtInfoHeadOne	= "Prumery pro tento predmet: ";
		FrmtInfoHistmed	= "Poslednich %d, median vykup za kus";
		FrmtInfoMinMulti	= "Prvni nabidka (%s za kus)";
		FrmtInfoMinOne	= "Prvni nabidka";
		FrmtInfoNever	= "Nikdy nezaznamenano na %s";
		FrmtInfoSeen	= "Zaznamenano %d-krat na aukci";
		FrmtInfoSgst	= "Doporucena cena: %s min/%s Vykup";
		FrmtInfoSgststx	= "Doporucena cena za vasi %d sadu: %s min/%s Vykup";
		FrmtInfoSnapmed	= "Zaznamenano %d, stredni Vykup (za kus)";
		FrmtInfoStacksize	= "Prumerna velikost sady: %d objektu";


		-- Section: User Interface
		BuySortTooltip	= "Setr�dit str�nku v�sledku podle v�kupn� ceny (se SHIFT-em bude tr�dit podle n�zvu predmetu)";
		ClearTooltip	= "Vymazat v�echny hodnoty z pol�cek pro vyhled�v�n�.";
		FrmtLastSoldOn	= "Naposledy prod�no %s";
		RefreshTooltip	= "Odeslat znovu dotaz na t�to str�nce.";
		UiBid	= "Nab�dka";
		UiBidHeader	= "Nab�dka";
		UiBidPerHeader	= "Nab�dka za kus";
		UiBuyout	= "V�kup";
		UiBuyoutHeader	= "V�kup";
		UiBuyoutPerHeader	= "V�kup za kus";
		UiBuyoutPriceLabel	= "V�kupn� cena:";
		UiBuyoutPriceTooLowError	= "(Pr�li� n�zk�)";
		UiCategoryLabel	= "Omezen� kategorie:";
		UiDepositLabel	= "Z�loha:";
		UiDurationLabel	= "Trv�n�:";
		UiItemLevelHeader	= "Lvl";
		UiMakeFixedPriceLabel	= "Zapamatuj si cenu";
		UiMaxError	= "(%d Max)";
		UiMaximumPriceLabel	= "Nejvy��� cena:";
		UiMaximumTimeLeftLabel	= "Maximalni zbyvajici doba:";
		UiMinimumPercentLessLabel	= "Nejmensi procentualni rozdil:";
		UiMinimumProfitLabel	= "Nejmen�� zisk:";
		UiMinimumQualityLabel	= "Nejnizsi kvalita:";
		UiMinimumUndercutLabel	= "Nejmensi prebiti:";
		UiNameHeader	= "Jmeno";
		UiNoPendingBids	= "Vsechny pozadovane nabidky dokonceny!";
		UiNotEnoughError	= "(nedostatek)";
		UiPendingBidInProgress	= "1 pozadavek na nabidku se zpracovava...";
		UiPendingBidsInProgress	= "%d pozadavku na nabidky se zpracovava...";
		UiPercentLessHeader	= "Pct";
		UiPost	= "Podat";
		UiPostAuctions	= "Podat aukci";
		UiPriceBasedOnLabel	= "Cena podle:";
		UiPriceModelAuctioneer	= "Auctioneer ceny";
		UiPriceModelCustom	= "Vlastn� ceny";
		UiPriceModelFixed	= "Pevn� cena";
		UiPriceModelLastSold	= "Cena posledn�ho prodeje";
		UiProfitHeader	= "Zisk";
		UiProfitPerHeader	= "Zisk za kus";
		UiQuantityHeader	= "Mno�stv�";
		UiQuantityLabel	= "Mno�stv�:";
		UiRemoveSearchButton	= "Smazat";
		UiSavedSearchLabel	= "Ulo�en� vyhled�v�n�:";
		UiSaveSearchButton	= "Ulo�it";
		UiSaveSearchLabel	= "Ulozit toto vyhledavani:";
		UiSearch	= "Hledat";
		UiSearchAuctions	= "Prohledat aukce";
		UiSearchDropDownLabel	= "Hledat:";
		UiSearchForLabel	= "Vyhledat predmet:";
		UiSearchTypeBids	= "NaBIDky";
		UiSearchTypeBuyouts	= "V�kupy";
		UiSearchTypeCompetition	= "Konkurence";
		UiSearchTypePlain	= "Predmet";
		UiStacksLabel	= "Bal�cky";
		UiStackTooBigError	= "(Moc velk� bal�cek)";
		UiStackTooSmallError	= "(Moc mal� bal�cek)";
		UiStartingPriceLabel	= "Vychozi cena:";
		UiStartingPriceRequiredError	= "(Nutne)";
		UiTimeLeftHeader	= "Zbyvajici cas";
		UiUnknownError	= "(tajuplna chyba)";

	};

	daDK = {


		-- Section: AskPrice Messages
		AskPriceAd	= "Hent stak priser for %sx[ItemLink] (x = stacksize) ";
		FrmtAskPriceBuyoutMedianHistorical	= "%sOpk�bs-median historisk: %s%s ";
		FrmtAskPriceBuyoutMedianSnapshot	= "%sOpk�bs-median ved sidste skanning: %s%s";
		FrmtAskPriceDisable	= "Deaktiver AskPrices %s funktionen";
		FrmtAskPriceEach	= "(%s pr. stk.)";
		FrmtAskPriceEnable	= "Aktiverer AskPrices %s funktionen";
		FrmtAskPriceVendorPrice	= "%sS�lg til forhandler for: %s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "Fjerner auktion %s fra nuv�rende Auktionshus snapshot.";
		FrmtAuctinfoHist	= "%d historisk";
		FrmtAuctinfoLow	= "Mindste pris";
		FrmtAuctinfoMktprice	= "Markedspris";
		FrmtAuctinfoNolow	= "Ikke set ved sidste skanning";
		FrmtAuctinfoOrig	= "Oprindeligt bud";
		FrmtAuctinfoSnap	= "%d sidste scanning";
		FrmtAuctinfoSugbid	= "Foresl�et startbud";
		FrmtAuctinfoSugbuy	= "Foresl�et opk�bspris";
		FrmtWarnAbovemkt	= "Konkurrence ligger over markedet";
		FrmtWarnMarkup	= "Overbyder forhandlere med %s%%";
		FrmtWarnMyprice	= "Bruger min nuv�rende pris";
		FrmtWarnNocomp	= "Ingen konkurrence";
		FrmtWarnNodata	= "Ingen data for HSP";
		FrmtWarnToolow	= "Kan ikke konkurrere med laveste pris";
		FrmtWarnUndercut	= "Underbyder med %s%%";
		FrmtWarnUser	= "Anvender brugerdefineret pris";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "Allerede den h�jestbydende p� auktion: %s (x%d)";
		FrmtBidAuction	= "Byd p� auktion: %s (x%d)";
		FrmtBidQueueOutOfSync	= "Fejl: Bud k� ude af synkronisering!";
		FrmtBoughtAuction	= "Opk�bt auktion: %s (x%d)";
		FrmtMaxBidsReached	= "Flere auktioner af %s (x%d) fundet, men bud gr�nse n�et (%d)";
		FrmtNoAuctionsFound	= "Ingen auktioner fundet: %s (x%d)";
		FrmtNoMoreAuctionsFound	= "Ikke flere auktioner fundet: %s (x%d)";
		FrmtNotEnoughMoney	= "Ikke nok penge til at byde p� auktion: %s (x%d)";
		FrmtSkippedAuctionWithHigherBid	= "Sprang over auktion med h�jere bud: %s (x%d)";
		FrmtSkippedAuctionWithLowerBid	= "Sprang over auktion med lavere bud: %s (x%d)";
		FrmtSkippedBiddingOnOwnAuction	= "Sprang over egen auktion: %s (x%d)";
		UiProcessingBidRequests	= "Bearbejder bud foresp�rgelser...";


		-- Section: Command Messages
		ConstantsCritical	= "KRITISK ADVARSEL:Din Auctioneer SavedVariables fil er %.3f%% fuld";
		ConstantsMessage	= "Din Auctioneer SavedVariables fil er %.3f%% fuld";
		ConstantsWarning	= "ADVARSEL:Din Auctioneer SavedVariables fil er %.3f%% fuld";
		FrmtActClearall	= "Fjerner alle data for auktionen %s";
		FrmtActClearFail	= "Kan ikke finde genstand: %s";
		FrmtActClearOk	= "Fjerner data for genstand: %s";
		FrmtActClearsnap	= "Fjerner nuv�rende Auktionhus data.";
		FrmtActDefault	= "Auctioneers %s indstillinger er blevet nulstillet til standard v�rdier";
		FrmtActDefaultall	= "Alle Auctioneers indstillinger er blevet nulstillet til standard v�rdier.";
		FrmtActDisable	= "Viser ikke data for: %s ";
		FrmtActEnable	= "Viser data for: %s ";
		FrmtActSet	= "S�tter %s til '%s'";
		FrmtActUnknown	= "Ukendt kommando eller n�gleord: '%s'";
		FrmtAuctionDuration	= "Normal auktions tid sat til: %s";
		FrmtAutostart	= "Starter automatisk auktion for %s minimum, %s opk�b (%dh)\n%s";
		FrmtFinish	= "Efter en scanning er afsluttet, skal vi %s";
		FrmtPrintin	= "Auctioneers beskeder vil nu blive skrevet til \"%s\" chat ramme";
		FrmtProtectWindow	= "Auktionshus vinduebeskyttelse sat til: %s";
		FrmtUnknownArg	= "'%s' er ikke et gyldigt argument for '%s'";
		FrmtUnknownLocale	= "Sproget du har angivet: ('%s') er ukendt. Gyldige sprog er:";
		FrmtUnknownRf	= "Ugyldig parameter ('%s'). Parameteret skal se s�dan ud: [realm]-[faction]. Eksempelvis: Al'Akir-Horde";


		-- Section: Command Options
		OptAlso	= "(realm-faction|modsat|hjemme|neutral)";
		OptAuctionDuration	= "(sidst||2t||8t||24t)";
		OptBidbroker	= "<fortjeneste_i_s�lv>";
		OptBidLimit	= "<nummer>";
		OptBroker	= "<fortjeneste_i_s�lv>";
		OptClear	= "([Genstand]alt|snapshot)";
		OptCompete	= "<s�lv_under>";
		OptDefault	= "(<Indstilling>|alt)";
		OptFinish	= "(sluk|log af|slut|genindl�sUI) ";
		OptLocale	= "<lokal>";
		OptPctBidmarkdown	= "<procent>";
		OptPctMarkup	= "<procent>";
		OptPctMaxless	= "<procent>";
		OptPctNocomp	= "<procent>";
		OptPctUnderlow	= "<procent>";
		OptPctUndermkt	= "<procent>";
		OptPercentless	= "<procent>";
		OptPrintin	= "(<frameIndex>[Nummer]|<frameNavn>[Streng]) ";
		OptProtectWindow	= "(aldrig|scan|altid) ";
		OptScale	= "<skalerings_faktor>";
		OptScan	= "<>";


		-- Section: Commands
		CmdAlso	= "ogs�";
		CmdAlsoOpposite	= "modsatte";
		CmdAlt	= "alt";
		CmdAskPriceAd	= "reklame";
		CmdAskPriceGuild	= "guild";
		CmdAskPriceParty	= "gruppe";
		CmdAskPriceSmart	= "smart";
		CmdAskPriceSmartWord1	= "Hvad";
		CmdAskPriceSmartWord2	= "v�rd";
		CmdAskPriceTrigger	= "udl�ser";
		CmdAskPriceVendor	= "forhandler";
		CmdAskPriceWhispers	= "private beskeder";
		CmdAskPriceWord	= "ord";
		CmdAuctionClick	= "auktion-klik";
		CmdAuctionDuration	= "Auktionsvarighed";
		CmdAuctionDuration0	= "sidst";
		CmdAuctionDuration1	= "2t";
		CmdAuctionDuration2	= "8t";
		CmdAuctionDuration3	= "24t";
		CmdAutofill	= "auto udfyld";
		CmdBidbroker	= "bidbroker";
		CmdBidbrokerShort	= "bb";
		CmdBidLimit	= "bud-gr�nse";
		CmdBroker	= "broker";
		CmdClear	= "ryd";
		CmdClearAll	= "alt";
		CmdClearSnapshot	= "billede";
		CmdCompete	= "konkurrere";
		CmdCtrl	= "ctrl";
		CmdDefault	= "standard";
		CmdDisable	= "sl� fra";
		CmdEmbed	= "indkapsle";
		CmdFinish	= "f�rdig";
		CmdFinish0	= "sluk";
		CmdFinish1	= "log af";
		CmdFinish2	= "luk";
		CmdFinish3	= "genindl�sUI";
		CmdFinishSound	= "Slut lyd";
		CmdHelp	= "hj�lp";
		CmdLocale	= "lokal";
		CmdOff	= "sluk";
		CmdOn	= "t�nd";
		CmdPctBidmarkdown	= "pct-bidmarkdown ";
		CmdPctMarkup	= "pct-markup ";
		CmdPctMaxless	= "pct-maxless ";
		CmdPctNocomp	= "pct-nocomp ";
		CmdPctUnderlow	= "pct-underlow ";
		CmdPctUndermkt	= "pct-undermkt ";
		CmdPercentless	= "percentless ";
		CmdPercentlessShort	= "pl";
		CmdPrintin	= "print-til";
		CmdProtectWindow	= "beskyt-vindue";
		CmdProtectWindow0	= "aldrig";
		CmdProtectWindow1	= "scan";
		CmdProtectWindow2	= "altid";
		CmdScan	= "scan";
		CmdShift	= "skift";
		CmdToggle	= "t�nd/sluk";
		CmdUpdatePrice	= "opdater-pris";
		CmdWarnColor	= "advarsels-farve";
		ShowAverage	= "vis-gennemsnit";
		ShowEmbedBlank	= "vis-indkapsle-blanklinje";
		ShowLink	= "vis-link";
		ShowMedian	= "vis-median";
		ShowRedo	= "vis-advarsel";
		ShowStats	= "vis-stats";
		ShowSuggest	= "vis-forslag";
		ShowVerbose	= "vis-ordrig";


		-- Section: Config Text
		GuiAlso	= "Vis ogs� data for";
		GuiAlsoDisplay	= "Viser data for %s";
		GuiAlsoOff	= "Viser ikke l�ngere data fra andre realm-fraktioner.";
		GuiAlsoOpposite	= "Viser nu ogs� data for modsatte fraktion.";
		GuiAskPrice	= "Sl� AskPrice til";
		GuiAskPriceAd	= "Send reklame for egenskaber";
		GuiAskPriceGuild	= "Svar p� guildchat foresp�rgsler";
		GuiAskPriceHeader	= "AskPrice indstillinger";
		GuiAskPriceHeaderHelp	= "Skift AskPrices opf�rsel";
		GuiAskPriceParty	= "Svar p� partychat foresp�rgsler";
		GuiAskPriceSmart	= "Brug smarte ord";
		GuiAskPriceTrigger	= "AskPrice udl�ser";
		GuiAskPriceVendor	= "Send forhandler informationer";
		GuiAskPriceWhispers	= "Vis udg�ende private beskeder";
		GuiAskPriceWord	= "brugerdefineret SmartWord %d";
		GuiAuctionDuration	= "Normal auktions varighed";
		GuiAuctionHouseHeader	= "Auktionshus vindue";
		GuiAuctionHouseHeaderHelp	= "�ndr Auktionshusets vinduesindstillinger";
		GuiAutofill	= "Autoudfyld priser i Auktionshuset";
		GuiAverages	= "Vis middel";
		GuiBidmarkdown	= "Neds�t bud med xx procent";
		GuiClearall	= "Ryd alle data fra Auctioneer";
		GuiClearallButton	= "Ryd alt";
		GuiClearallHelp	= "Klik her for at fjerne alle data fra Auctioneer for den nuv�rende server-realm.";
		GuiClearallNote	= "for den nuv�rende server-fraktion";
		GuiClearHeader	= "Ryd data";
		GuiClearHelp	= "Ryd Auctioneer data. \nV�lg alle data eller det nuv�rende snapshot.\nADVARSEL: Disse handlinger kan IKKE fortrydes.";
		GuiClearsnap	= "Ryd Snapshotdata";
		GuiClearsnapButton	= "Fjern Snapshot";
		GuiClearsnapHelp	= "Klik her for at slette den sidste skanning af auktionen.";
		GuiDefaultAll	= "Nulstil alle Auctioneer indstillinger";
		GuiDefaultAllButton	= "Nulstil alt";
		GuiDefaultAllHelp	= "Klik her for at s�tte alle Auctioneer valg til standard v�rdier.\nADVARSEL: Denne handling kan IKKE fortrydes.";
		GuiDefaultOption	= "Nulstil denne ops�tning.";
		GuiEmbed	= "Indrammet info i spillets tooltip";
		GuiEmbedBlankline	= "Viser blank linje i spillets tooltip";
		GuiEmbedHeader	= "Indrammet";
		GuiFinish	= "Efter en skanning er afsluttet";
		GuiFinishSound	= "Afspil lyd n�r scaning er afsluttet";
		GuiLink	= "Viser LinkID";
		GuiLoad	= "Hent Auctioneer";
		GuiLoad_Always	= "altid";
		GuiLoad_AuctionHouse	= "ved Auktionshuset";
		GuiLoad_Never	= "aldrig";
		GuiLocale	= "S�t sprog til";
		GuiMainEnable	= "Start Auctioneer";
		GuiMainHelp	= "Indeholder v�rdier for Auctioneer. En AddOn som viser information om genstande og analysere auktionsdata. \nKlik p� \"Skan\" knappen p� Auktionshuset for at indsamle auktionsdata.";
		GuiMarkup	= "Procent overbud iht. forhandler";
		GuiMaxless	= "Procent maks. under markeds pris";
		GuiMedian	= "Vis medianer";
		GuiNocomp	= "Procent under markedets pris ved ingen konkurence";
		GuiNoWorldMap	= "Auctioneer: Undertrykker visningen af World Map";
		GuiOtherHeader	= "Andre indstillinger";
		GuiOtherHelp	= "Diverse indstillinger til Auctioneer";
		GuiPercentsHeader	= "Auctioneer graense procent";
		GuiPercentsHelp	= "Advarsel: De f�lgende valgmuligheder er KUN for Superbrugere.\nVed at �ndre p� f�lgende muligheder �ndrer du hvor aggresivt Auctioneer vil v�re n�r den udregner profit.";
		GuiPrintin	= "Vaelg den oenskede chat ramme.";
		GuiProtectWindow	= "Forhindrer lukning af Auktionshus vindue ved uheld";
		GuiRedo	= "Vis advarsel ved lang skanning.";
		GuiReloadui	= "Genindl�ser brugerflade.";
		GuiReloaduiButton	= "Genindl�sUI";
		GuiReloaduiFeedback	= "Genindl�ser nu WoW UI";
		GuiReloaduiHelp	= "Klik her for at genindlaese WoW brugerfladen efter at have �ndret sprog.\nBem�rk: Dette kan tage et par minutter.";
		GuiRememberText	= "Husk prisen";
		GuiStatsEnable	= "Vis Statistik";
		GuiStatsHeader	= "Genstand Pris Statistik";
		GuiStatsHelp	= "Vis f�lgende statistikker i tooltippet.";
		GuiSuggest	= "Vis foresl�ede priser";
		GuiUnderlow	= "Laveste auktionspris";
		GuiUndermkt	= "Underbyd markedet n�r der ingen maxpris findes.";
		GuiVerbose	= "Tekst Mode";
		GuiWarnColor	= "Farve Pris Model";


		-- Section: Conversion Messages
		MesgConvert	= "Konverterer Auctioneer Databasen. Tag venligst en backup af SavedVariables\\Auctioneer.lua inden.%s%s";
		MesgConvertNo	= "Indlaes ikke Auctioneer";
		MesgConvertYes	= "Konventer nu";
		MesgNotconverting	= "Auctioneer konventerer ikke din database, men vil ikke virke faar du goer.";


		-- Section: Game Constants
		TimeLong	= "Lang";
		TimeMed	= "Middel";
		TimeShort	= "Kort";
		TimeVlong	= "Meget Lang";


		-- Section: Generic Messages
		ConfirmBidBuyout	= "Er sikker p� du vil %s\n%dx%s til:";
		DisableMsg	= "Stopper automatisk indlaesning af Auctioneer";
		FrmtWelcome	= "Auctioneer v%s er indlaest";
		MesgNotLoaded	= "Auctioneer er ikke indlaest. Skriv /auctioneer for mere info.";
		StatAskPriceOff	= "AskPrice er nu deaktiveret.";
		StatAskPriceOn	= "AskPrice er nu aktiveret.";
		StatOff	= "Viser ikke nogen auktionsdata.";
		StatOn	= "Viser konfigureret auktionsdata.";


		-- Section: Generic Strings
		TextAuction	= "auktion";
		TextCombat	= "Kamp";
		TextGeneral	= "General";
		TextNone	= "ingen";
		TextScan	= "Scan";
		TextUsage	= "Brug:";


		-- Section: Help Text
		HelpAlso	= "Viser ogsaa en anden servers priser i tooltipet. For realm, indsaet realmnavnet og faction navnet. Som eksempel: \"/auctioneer also Al'Akir-Horde\". Det speciale noegleord \"opposite\" betyder den modstridne fraktion, \"off\" stopper denne funktion.";
		HelpAskPrice	= "Sl� AskPrice til eller fra";
		HelpAskPriceAd	= "Tillad eller bloker nye AskPrice funktions reklame.";
		HelpAskPriceGuild	= "Svarer p� en forsp�rgelse lavet i guild chat.";
		HelpAskPriceParty	= "Svarer p� en forsp�rgelse lavet i party chat.";
		HelpAskPriceSmart	= "Tillad eller bloker SmartWrods check";
		HelpAskPriceTrigger	= "�ndre AskPrice's kommando.";
		HelpAskPriceVendor	= "Tillad eller bloker sendingen af vendor pris data.";
		HelpAskPriceWhispers	= "Vis eller skjul prisforsp�rgelser i udg�ende private beskeder";
		HelpAskPriceWord	= "Tilf�je eller �ndre AskPrice�s brugerdefinerede SmartWords.";
		HelpAuctionClick	= "Tillader Alt-klik paa et objekt i dine tasker for automatisk at starte en auktion for det";
		HelpAuctionDuration	= "Saet den normale auktions varighed ved aabning af AH vindue";
		HelpAutofill	= "Saet om Auctioneer skal autoudfylde priser naar objekter overfoeres til auktionshusets boks.";
		HelpAverage	= "Vaelger om middelprisen paa en auktion skal vises.";
		HelpBidbroker	= "Viser korte og middel auktioner som kan blive budt paa og solgt med fortjeneste.";
		HelpBidLimit	= "Maksimalt antal af auktion p� bud eller opk�b n�r Byd eller Opk�b knappen er valgt p� S�g Auktioner fanen";
		HelpBroker	= "Viser auktioner fra sidste scanning som kan blive opkoebt og solgt med fortjeneste.";
		HelpClear	= "Sletter data for et specifikt objekt (du skal shift-klikke p� objektet s� det kommer ned i kommando boxen.) Du kan ogs� specifisere enkelte n�gle ord som \"all\" eller \"snapshot\"";
		HelpCompete	= "Viser objekter fra sidste skanning som har lavere opk�bspris end dine ting.";
		HelpDefault	= "S�tter Auctioneer til dens standard v�rdi. Du kan eventuelt bruge n�gleord som: \"all\" for at s�tte alle valg til deres standard v�rdier.";
		HelpDisable	= "Stopper Auctioneer s� det ikke indl�ses automatisk n�ste gang du logger ind.";
		HelpEmbed	= "Indrammer teksten i spillets egen tooltip (bem�rk: nogle muligheder vil v�re utilg�ngelige i denne mode.)";
		HelpEmbedBlank	= "V�lg om der skal v�re blanke linjer mellem tooltip info og auktions info n�r embedded mode er valgt";
		HelpFinish	= "set for automatisk logge ud eller exit spil ved auktions scan afslutning";
		HelpFinishSound	= "V�lg om der skal afspilles en lyd n�r skanning af aktionshuset er f�rdig.";
		HelpLink	= "V�lger om der skal vises link id i tooltippet.";
		HelpLoad	= "�ndre Auctioneers load indstillinger for denne karakter";
		HelpLocale	= "Skifter sprog p� auctioneer scriptet.";
		HelpMedian	= "V�lger om der skal vises middel opk�bspris.";
		HelpOnoff	= "Sl�r visning af auktions data til og fra.";
		HelpPctBidmarkdown	= "S�t procenter Auctioneer vil s�tte prisen under objektets opk�bspris.";
		HelpPctMarkup	= "Procenten som Auctioneer vil overbyde forhandleren p� et objekt hvor prisen ikke kendes.";
		HelpPctMaxless	= "Sæt den maksimale procent som Auctioneer vil gå under markeds værdi inden den giver op.";
		HelpPctNocomp	= "Procenten Auctioneer vil gå under markedet pris når der ikke findes konkurrenter";
		HelpPctUnderlow	= "Sæt procenter some Auctioneer vil gå under den laveste pris";
		HelpPctUndermkt	= "Procenter Auctioneer vil bruge hvis den ikke kan gå under konkurrenter (pga. maks/min)";
		HelpPercentless	= "Viser objekter fra sidste skanning hvis opkøbspris er en bestemt procent lavere end den højst sælgende pris.";
		HelpPrintin	= "V�lg hvilken ramme Auctioneer vil skrive til. Du kan enten angive et ramme navn eller rammens indeks nummer.";
		HelpProtectWindow	= "Forhindrer dig i at lukke AH vinduet ved et uheld";
		HelpRedo	= "Vælg om der skal vises en advarsel hvis den nuværende skanning har taget for lang tid på grund af server lag.";
		HelpScan	= "Udfører en scan af auktionshuset næste gang du besøger det, eller mens du er der.(Der er også en knap i auktionshuset under browse, der kan du også vælge hvilke katagorier du ønsker at skanne ved at bruge flueben..";
		HelpStats	= "Vaelger om der skal vises bud/opkoebs pris i procenter.";
		HelpSuggest	= "Vaelger om der skal vises foresl�et salgspris ved auktion.";
		HelpUpdatePrice	= "Automatisk opdater start prisen for en auktion p� Post Auctions fanebladdet n�r udk�bsprisen �ndres.";
		HelpVerbose	= "Vaelger hvordan teksten formuleres. (forslag, middelpriser eller off for at vise dem paa en enkelt linje.)";
		HelpWarnColor	= "V�lg at vise den nuv�rende AH pris model (Underbydde med...) i intuitive farver.";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "Ingen tomme pack rum fundet til at lave auktionen!";
		FrmtNotEnoughOfItem	= "Ikke nok %s fundet til at lave auktionen!";
		FrmtPostedAuction	= "(x%d) %s sat p� auktion";
		FrmtPostedAuctions	= "%d auktioner af (x%d) %s lavet";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "Nuvaerende bud";
		FrmtBidbrokerDone	= "Prisliste faerdig";
		FrmtBidbrokerHeader	= "Minimum profit: %s, HSP = 'Hoejeste Saelgende Pris'";
		FrmtBidbrokerLine	= "%s, sidst %s set, HSP: %s, %s: %s, Profit: %s, Tid: %s";
		FrmtBidbrokerMinbid	= "Mindste bud";
		FrmtBrokerDone	= "Liste faerdig.";
		FrmtBrokerHeader	= "Minimum profit: %s, HSP = 'Hoejeste Saelgende Pris'";
		FrmtBrokerLine	= "%s, Sidst %s set, HSP: %s, KoebNu: %s, Profit: %s";
		FrmtCompeteDone	= "Konkurerende auktioner er afsluttet";
		FrmtCompeteHeader	= "Konkurerende auktioner er mindst %s under pr. vare.";
		FrmtCompeteLine	= "%s, Bud: %s, BO %s mod %s, %s mindre";
		FrmtHspLine	= "Højeste Sælgende Pris for en %s er: %s";
		FrmtLowLine	= "%s, BO: %s, sælger: %s, For en: %s, under middel: %s";
		FrmtMedianLine	= "Af sidste %d set, middel BO for 1 %s er: %s";
		FrmtNoauct	= "Ingen auktioner blev fundet for: %s";
		FrmtPctlessDone	= "Udregning af Procenter faerdig.";
		FrmtPctlessHeader	= "Procent mindre end hoejeste saelgende pris(HSP): %d%%";
		FrmtPctlessLine	= "%s, sidst %d set, HSP: %s, BO: %s, Profit: %s, Mindre %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "Afsluttede auktioner fjernet: %s";
		AuctionDiscrepancies	= "Uoverensstemmelser: %s";
		AuctionNewAucts	= "Nye auktioner skannet: %s";
		AuctionOldAucts	= "Skannet foer: %s";
		AuctionPageN	= "Auctioneer: skanner nu %s side %d af %d\nAuktioner pr sekund: %s\nBeregnet tid tilbage: %s";
		AuctionScanDone	= "Auctioneer: Skanningen af auktionerne er faerdig.";
		AuctionScanNexttime	= "Auctioneer vil udfoere en komplet scanning af auktionshuset naeste gang du snakker med en auktioaer.";
		AuctionScanNocat	= "Du skal vaelge mindst en kategori for at kan skanne.";
		AuctionScanRedo	= "Nuvaerende side tog mere end %d sekunder at faerdigoere, forsoeger at indlaese siden igen.";
		AuctionScanStart	= "Auctioneer: skanner %s side 1...";
		AuctionTotalAucts	= "Auktioner skannet ialt: %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "Set %d gange paa %s";
		FrmtInfoAverage	= "%s min/%s BO (%s bud)";
		FrmtInfoBidMulti	= "Bud (%s%s stk.)";
		FrmtInfoBidOne	= "Bud%s";
		FrmtInfoBidrate	= "%d%% har budt, %d%% har BO";
		FrmtInfoBuymedian	= "Opk�b median";
		FrmtInfoBuyMulti	= "Opk�b (%s%s Stk)";
		FrmtInfoBuyOne	= "Opk�b%s";
		FrmtInfoForone	= "For 1: %s min/%s BO (%s bud) [i %d's]";
		FrmtInfoHeadMulti	= "Middel for %d stk.:";
		FrmtInfoHeadOne	= "Middel for denne vare:";
		FrmtInfoHistmed	= "Sidste %d, middel BO (stk)";
		FrmtInfoMinMulti	= "Start bud (%s stk.)";
		FrmtInfoMinOne	= "Start bud";
		FrmtInfoNever	= "Aldrig set paa %s";
		FrmtInfoSeen	= "Set %d gange paa auktion ialt";
		FrmtInfoSgst	= "Prisforslag: %s min/%s BO";
		FrmtInfoSgststx	= "Prisforslag for dine %d stk: %s min/%s BO";
		FrmtInfoSnapmed	= "Skannede %d, middel BO (stk)";
		FrmtInfoStacksize	= "Normal bundt stoerrelse: %d stk.";


		-- Section: User Interface
		FrmtLastSoldOn	= "Sidst solgt den";
		UiBid	= "bud";
		UiBidHeader	= "bud";
		UiBidPerHeader	= "Bud pr.";
		UiBuyout	= "Opk�b";
		UiBuyoutHeader	= "Opk�b";
		UiBuyoutPerHeader	= "Opk�b pr.";
		UiBuyoutPriceLabel	= "Opk�b bud:";
		UiBuyoutPriceTooLowError	= "(For lav)";
		UiCategoryLabel	= "kategori begr�nsning:";
		UiDepositLabel	= "Depositum";
		UiDurationLabel	= "Varighed:";
		UiItemLevelHeader	= "Lvl";
		UiMakeFixedPriceLabel	= "Opret fixed pris";
		UiMaxError	= "(%d - Max)";
		UiMaximumPriceLabel	= "Maximum pris:";
		UiMaximumTimeLeftLabel	= "Maximum tid tilbage:";
		UiMinimumPercentLessLabel	= "Minimum procent mindre:";
		UiMinimumProfitLabel	= "Minimum profit:";
		UiMinimumQualityLabel	= "Minimum kvalitet:";
		UiMinimumUndercutLabel	= "Minimum underbyder";
		UiNameHeader	= "Navn";
		UiNoPendingBids	= "Alle bud anmodninger f�rdige";
		UiNotEnoughError	= "(Ikke nok)";
		UiPendingBidInProgress	= "1 bud anmodning i gang...";
		UiPendingBidsInProgress	= "%d bud anmodninger i gang.";
		UiPercentLessHeader	= "procent";
		UiPost	= "Opret";
		UiPostAuctions	= "Set auktioner";
		UiPriceBasedOnLabel	= "Pris baseret p�:";
		UiPriceModelAuctioneer	= "Auctioneer Pris";
		UiPriceModelCustom	= "Personlig pris";
		UiPriceModelFixed	= "Fast pris";
		UiPriceModelLastSold	= "Sidste salgspris";
		UiProfitHeader	= "Profit";
		UiProfitPerHeader	= "Profit pr.";
		UiQuantityHeader	= "Kvalitet";
		UiQuantityLabel	= "M�ngde:";
		UiRemoveSearchButton	= "Slet";
		UiSavedSearchLabel	= "Gemte s�gninger:";
		UiSaveSearchButton	= "Gem";
		UiSaveSearchLabel	= "Gem denne s�gning:";
		UiSearch	= "S�g";
		UiSearchAuctions	= "S�g auktioner";
		UiSearchDropDownLabel	= "S�g:";
		UiSearchForLabel	= "S�g efter genstand:";
	    UiSearchForOwnerLabel   = "Search For Items Posted By:"; 
		UiSearchTypeBids	= "Bud";
		UiSearchTypeBuyouts	= "k�b";
		UiSearchTypeCompetition	= "Konkurrence";
		UiSearchTypePlain	= "Genstand";
		UiSearchTypeOwner	= "Owner";
		UiStacksLabel	= "Stakke";
		UiStackTooBigError	= "(Stak for stor)";
		UiStackTooSmallError	= "(Stak for lille)";
		UiStartingPriceLabel	= "Start pris:";
		UiStartingPriceRequiredError	= "(n�dvendig)";
		UiTimeLeftHeader	= "Tid tilbage";
		UiUnknownError	= "(ukendt fejl)";

	};

	deDE = {


		-- Section: AskPrice Messages
		AskPriceAd	= "Stapelpreis mit %sx[ItemLink] (x = Stapelgr��e)";
		FrmtAskPriceBuyoutMedianHistorical	= "%sSofortkauf Median: %s%s";
		FrmtAskPriceBuyoutMedianSnapshot	= "%sSofortkauf Median letzter Scan: %s%s";
		FrmtAskPriceDisable	= "Preisabfrage %s Option ausgeschaltet";
		FrmtAskPriceEach	= "(%s pro St�ck)";
		FrmtAskPriceEnable	= "Preisabfrage %s Option eingeschaltet";
		FrmtAskPriceVendorPrice	= "%sVerkauf an NPC f�r: %s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "Entferne Auktion %s vom derzeitigen AH-Abbild.";
		FrmtAuctinfoHist	= "%d historisch";
		FrmtAuctinfoLow	= "niedrigster Preis";
		FrmtAuctinfoMktprice	= "Marktpreis";
		FrmtAuctinfoNolow	= "Item nicht im letzten AH-Abbild enthalten";
		FrmtAuctinfoOrig	= "Originalgebot";
		FrmtAuctinfoSnap	= "%d aus letztem Scan";
		FrmtAuctinfoSugbid	= "Anfangsgebot";
		FrmtAuctinfoSugbuy	= "Empf. Sofortkauf";
		FrmtWarnAbovemkt	= "Konkurrenz keine Gefahr";
		FrmtWarnMarkup	= "%s%% erh�hter H�ndlerpreis";
		FrmtWarnMyprice	= "Verwende eigenen Preis";
		FrmtWarnNocomp	= "Monopol";
		FrmtWarnNodata	= "Keine HVP-Daten";
		FrmtWarnToolow	= "Konkurrenz zu g�nstig";
		FrmtWarnUndercut	= "Unterbiete um %s%%";
		FrmtWarnUser	= "Verwende Benutzer-Preisvorgabe";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "Bereits H�chstbietender f�r Auktion: %s (x%d)";
		FrmtBidAuction	= "Gebot f�r Auktion: %s (x%d) ";
		FrmtBidQueueOutOfSync	= "Fehler: Gebotsliste nicht synchron!";
		FrmtBoughtAuction	= "Direktkauf der Auktion: %s (x%d) ";
		FrmtMaxBidsReached	= "Mehr Auktionen von %s (x%d)gefunden, aber Gebotsbegrenzung erreicht (%d) ";
		FrmtNoAuctionsFound	= "Keine Auktionen gefunden: %s (x%d) ";
		FrmtNoMoreAuctionsFound	= "Keine weiteren Auktionen gefunden: %s (x%d) ";
		FrmtNotEnoughMoney	= "Nicht genug Geld f�r Gebot auf Auktion: %s (x%d) ";
		FrmtSkippedAuctionWithHigherBid	= "�berspringe Auktion mit h�herem Gebot: %s (x%d) ";
		FrmtSkippedAuctionWithLowerBid	= "�berspringe Auktion mit niedrigerem Gebot: %s (x%d)";
		FrmtSkippedBiddingOnOwnAuction	= "�berspringe Gebot auf eigene Auktion: %s (x%d)";
		UiProcessingBidRequests	= "Bearbeite Gebote...";


		-- Section: Command Messages
		ConstantsCritical	= "KRITISCH: Deine gespeicherten Auctioneer Daten sind zu %.3f%% voll!";
		ConstantsMessage	= "Deine gespeicherten Auctioneer Daten sind zu %.3f%% voll";
		ConstantsWarning	= "WARNUNG: Deine gespeicherten Auctioneer Daten sind zu %.3f%% voll";
		FrmtActClearall	= "L�sche alle Auktionsdaten f�r %s";
		FrmtActClearFail	= "Objekt nicht gefunden: %s";
		FrmtActClearOk	= "Daten gel�scht f�r: %s";
		FrmtActClearsnap	= "L�sche aktuelles Auktionshaus-Abbild.";
		FrmtActDefault	= "%s wurde auf den Standardwert zur�ckgesetzt.";
		FrmtActDefaultall	= "Alle Einstellungen wurden auf Standardwerte zur�ckgesetzt.";
		FrmtActDisable	= "%s wird nicht angezeigt";
		FrmtActEnable	= "%s wird angezeigt";
		FrmtActSet	= "Setze %s auf '%s'";
		FrmtActUnknown	= "Unbekannter Befehl: '%s'";
		FrmtAuctionDuration	= "Standard-Auktionsdauer wurde auf \"%s\" gesetzt";
		FrmtAutostart	= "Automatischer Start der Auktion f�r %s:\n%s Minimum, %s Sofortkauf (%dh)\n%s";
		FrmtFinish	= "Nach abgeschlossenem Scan werden wir %s";
		FrmtPrintin	= "Die Auctioneer-Meldungen werden nun im Chat-Fenster \"%s\" angezeigt";
		FrmtProtectWindow	= "Schutzmodus des Auktionshaus-Fensters auf \"%s\" gesetzt";
		FrmtUnknownArg	= "'%s' ist kein g�ltiges Argument f�r '%s'";
		FrmtUnknownLocale	= "Das angegebene Gebietsschema ('%s') ist unbekannt. G�ltige Gebietsschemen sind:";
		FrmtUnknownRf	= "Ung�ltiger Parameter ('%s'). Der Parameter erfordert das Format: [Realm]-[Fraktion]. Bspw.: Al'Akir-Horde";


		-- Section: Command Options
		OptAlso	= "([Realm]-[Fraktion]|opposite|home|neutral)";
		OptAskPriceSend	= "(<Spielername> <Preisnachfrage-Ergebnis>)";
		OptAuctionDuration	= "(last|2h|8h|24h)";
		OptBidbroker	= "<Profit in Silber>";
		OptBidLimit	= "<Nummer> ";
		OptBroker	= "<Profit in Silber>";
		OptClear	= "([Gegenstand]|all|snapshot)";
		OptCompete	= "<silber_weniger>";
		OptDefault	= "(<Option>|all)";
		OptFinish	= "(off|logout|exit|reloadui)";
		OptLocale	= "<Sprache>";
		OptPctBidmarkdown	= "<Prozent>";
		OptPctMarkup	= "<Prozent>";
		OptPctMaxless	= "<Prozent>";
		OptPctNocomp	= "<Prozent>";
		OptPctUnderlow	= "<Prozent>";
		OptPctUndermkt	= "<Prozent>";
		OptPercentless	= "<Prozent>";
		OptPrintin	= "(<Fenster-Index>[Nummer]|<Fenster-Name>[String])";
		OptProtectWindow	= "(never|scan|always)";
		OptScale	= "<Skalierungsfaktor>";
		OptScan	= "Befehlsformat der Scanparameter";


		-- Section: Commands
		CmdAlso	= "also";
		CmdAlsoOpposite	= "opposite";
		CmdAlt	= "alt";
		CmdAskPriceAd	= "ad";
		CmdAskPriceGuild	= "guild";
		CmdAskPriceParty	= "party";
		CmdAskPriceSend	= "send";
		CmdAskPriceSmart	= "smart";
		CmdAskPriceSmartWord1	= "what";
		CmdAskPriceSmartWord2	= "worth";
		CmdAskPriceTrigger	= "trigger";
		CmdAskPriceVendor	= "vendor";
		CmdAskPriceWhispers	= "whispers";
		CmdAskPriceWord	= "word";
		CmdAuctionClick	= "auction-click";
		CmdAuctionDuration	= "auction-duration";
		CmdAuctionDuration0	= "last";
		CmdAuctionDuration1	= "2h";
		CmdAuctionDuration2	= "8h";
		CmdAuctionDuration3	= "24h";
		CmdAutofill	= "autofill";
		CmdBidbroker	= "bidbroker";
		CmdBidbrokerShort	= "bb";
		CmdBidLimit	= "bid-limit";
		CmdBroker	= "broker";
		CmdClear	= "clear";
		CmdClearAll	= "all";
		CmdClearSnapshot	= "snapshot";
		CmdCompete	= "compete";
		CmdCtrl	= "strg";
		CmdDefault	= "default";
		CmdDisable	= "disable";
		CmdEmbed	= "embed";
		CmdFinish	= "finish";
		CmdFinish0	= "off";
		CmdFinish1	= "logout";
		CmdFinish2	= "exit";
		CmdFinish3	= "reloadui";
		CmdFinishSound	= "finish-sound";
		CmdHelp	= "help";
		CmdLocale	= "locale";
		CmdOff	= "off";
		CmdOn	= "on";
		CmdPctBidmarkdown	= "pct-bidmarkdown";
		CmdPctMarkup	= "pct-markup";
		CmdPctMaxless	= "pct-maxless";
		CmdPctNocomp	= "pct-nocomp";
		CmdPctUnderlow	= "pct-underlow";
		CmdPctUndermkt	= "pct-undermkt";
		CmdPercentless	= "percentless";
		CmdPercentlessShort	= "pl";
		CmdPrintin	= "print-in";
		CmdProtectWindow	= "protect-window";
		CmdProtectWindow0	= "never";
		CmdProtectWindow1	= "scan";
		CmdProtectWindow2	= "always";
		CmdScan	= "scan";
		CmdShift	= "shift";
		CmdToggle	= "toggle";
		CmdUpdatePrice	= "update-price";
		CmdWarnColor	= "warn-color";
		ShowAverage	= "show-average";
		ShowEmbedBlank	= "show-embed-blankline";
		ShowLink	= "show-link";
		ShowMedian	= "show-median";
		ShowRedo	= "show-warning";
		ShowStats	= "show-stats";
		ShowSuggest	= "show-suggest";
		ShowVerbose	= "show-verbose";


		-- Section: Config Text
		GuiAlso	= "Zeige zus�tzlich Daten von";
		GuiAlsoDisplay	= "Zeige Daten f�r %s an";
		GuiAlsoOff	= "Daten f�r andere Realm-Fraktion werden nicht mehr angezeigt.";
		GuiAlsoOpposite	= "Daten der gegnerischen Fraktion werden jetzt ebenfalls angezeigt.";
		GuiAskPrice	= "AskPrice einschalten";
		GuiAskPriceAd	= "Sende feature Werbung";
		GuiAskPriceGuild	= "Reagiere auf Gildenchat-Anfragen";
		GuiAskPriceHeader	= "AskPrice Optionen";
		GuiAskPriceHeaderHelp	= "�ndere AskPrice Verhalten";
		GuiAskPriceParty	= "Reagiere auf Gruppenchat-Anfragen";
		GuiAskPriceSmart	= "Benutze Schlagw�rter";
		GuiAskPriceTrigger	= "AskPrice Ausl�ser";
		GuiAskPriceVendor	= "Sende H�ndler Info";
		GuiAskPriceWhispers	= "Ausgehende Whispers anzeigen";
		GuiAskPriceWord	= "Eigenes SmartWord %d";
		GuiAuctionDuration	= "Auktionsstandarddauer";
		GuiAuctionHouseHeader	= "Auktionshausfenster";
		GuiAuctionHouseHeaderHelp	= "Verhalten des Auktionshausfensters �ndern";
		GuiAutofill	= "Preise im AH automatisch eintragen";
		GuiAverages	= "Durchschnitt anzeigen";
		GuiBidmarkdown	= "Gebot um %x unterbieten";
		GuiClearall	= "L�sche alle Auctioneerdaten";
		GuiClearallButton	= "Alles l�schen";
		GuiClearallHelp	= "Hier dr�cken, um die gesamten Auctioneerdaten des aktuellen Realms zu l�schen.";
		GuiClearallNote	= "der aktuellen Fraktion dieses Realms";
		GuiClearHeader	= "Daten l�schen";
		GuiClearHelp	= "Auctioneerdaten l�schen.\nW�hle entweder alle Daten oder das aktuelle Abbild.\nWARNUNG: Der L�schvorgang kann NICHT r�ckg�ngig gemacht werden!";
		GuiClearsnap	= "Abbilddaten l�schen";
		GuiClearsnapButton	= "Abbild l�schen";
		GuiClearsnapHelp	= "Zum L�schen der letzten Auctioneer-Abbild-Daten, hier klicken.";
		GuiDefaultAll	= "Alle Einstellungen zur�cksetzen";
		GuiDefaultAllButton	= "Alles zur�cksetzen";
		GuiDefaultAllHelp	= "Hier klicken, um alle Auctioneer-Optionen auf ihren Standardwert zu setzen.\nWARNUNG: Dieser Vorgang kann NICHT r�ckg�ngig gemacht werden.";
		GuiDefaultOption	= "Zur�cksetzen dieser Einstellung";
		GuiEmbed	= "Info im In-Game Tooltipp anzeigen";
		GuiEmbedBlankline	= "Leerzeile im In-Game Tooltipp einf�gen";
		GuiEmbedHeader	= "Art der Anzeige";
		GuiFinish	= "Nach abgeschlossenem Scan";
		GuiFinishSound	= "Spiele Ton ab nach Beenden des Scans";
		GuiLink	= "Zeige LinkID an";
		GuiLoad	= "Auctioneer laden";
		GuiLoad_Always	= "immer";
		GuiLoad_AuctionHouse	= "im Auktionshaus";
		GuiLoad_Never	= "nie";
		GuiLocale	= "Setze das Gebietsschema auf";
		GuiMainEnable	= "Auctioneer aktivieren";
		GuiMainHelp	= "Einstellungen f�r Auctioneer.\nEinem AddOn, das zus�tzliche Informationen zu Gegenst�nden anzeigt und Auktionsdaten analysiert.\nDr�cke den \"Scannen\"-Knopf im Auktionshaus, um Auktionsdaten zu sammeln.";
		GuiMarkup	= "H�ndlerpreis um x% erh�hen";
		GuiMaxless	= "Marktpreis um max. x% unterbieten";
		GuiMedian	= "Zeige Mediane an.";
		GuiNocomp	= "Marktpreis um x% bei Monopol\nverringern";
		GuiNoWorldMap	= "Auctioneer: Die Anzeige der Weltkarte wurde unterdr�ckt";
		GuiOtherHeader	= "Sonstige Einstellungen";
		GuiOtherHelp	= "Sonstige Auctioneer-Einstellungen";
		GuiPercentsHeader	= "Auctioneer Prozent-Schwellenwerte";
		GuiPercentsHelp	= "WARNUNG: Die folgenden Einstellungen sind NUR f�r erfahrene Benutzer.\nVer�ndere die folgenden Werte um festzulegen, wie aggressiv Auctioneer beim Bestimmen profitabler Preise vorgehen soll.";
		GuiPrintin	= "Fenster f�r Meldungen ausw�hlen";
		GuiProtectWindow	= "Versehentliches Schlie�en des AH-Fensters verhindern";
		GuiRedo	= "Zeige Warnung bei langer Scandauer";
		GuiReloadui	= "Benutzeroberfl�che neu laden";
		GuiReloaduiButton	= "Interface neu laden";
		GuiReloaduiFeedback	= "WoW-Benutzeroberfl�che wird neu geladen";
		GuiReloaduiHelp	= "Hier klicken, um die WoW-Benutzeroberfl�che nach einer \n�nderung des Gebietsschemas neu zu laden, so dass die Sprache des Konfigurationsmen�s diesem entspricht.\nHinweis: Dieser Vorgang kann einige Minuten dauern.";
		GuiRememberText	= "Preis merken";
		GuiStatsEnable	= "Statistiken anzeigen";
		GuiStatsHeader	= "Preisstatistiken";
		GuiStatsHelp	= "Zeigt die folgenden Statistiken im Tooltip an.";
		GuiSuggest	= "Zeige empfohlene Preise an.";
		GuiUnderlow	= "G�nstigste Auktion unterbieten";
		GuiUndermkt	= "Marktpreis unterbieten, wenn\nKonkurrenz zu g�nstig ist";
		GuiVerbose	= "Detaillierte Informationen";
		GuiWarnColor	= "Farbiges Preismodell";


		-- Section: Conversion Messages
		MesgConvert	= "Auctioneer Datenbankkonvertierung. Bitte zuerst eine Sicherung von SavedVariables\\Auctioneer.lua anlegen!%s%s";
		MesgConvertNo	= "Deaktivieren";
		MesgConvertYes	= "Konvertieren";
		MesgNotconverting	= "Auctioneer konvertiert die Datenbank nicht, bleibt aber au�er Funktion, bis dies erfolgt.";


		-- Section: Game Constants
		TimeLong	= "Lang";
		TimeMed	= "Mittel";
		TimeShort	= "Kurz";
		TimeVlong	= "Sehr lang";


		-- Section: Generic Messages
		ConfirmBidBuyout	= "Auktionskauf f\195\188r:";
		DisableMsg	= "Das automatische Laden von Auctioneer wird deaktiviert.";
		FrmtWelcome	= "Auctioneer v%s geladen.";
		MesgNotLoaded	= "Auctioneer ist nicht geladen. Gib /auctioneer f�r mehr Informationen ein.";
		ScanCancel	= "Scan abgebrochen";
		ScanComplete	= "Scan komplett";
		ScanFailed	= "Scan fehlgeschlagen";
		StatAskPriceOff	= "Preisnachfrage deaktiviert.";
		StatAskPriceOn	= "Preisnachfrage aktiviert.";
		StatOff	= "Auktionsdaten werden nicht angezeigt.";
		StatOn	= "Auktionsdaten werden angezeigt.";
		UIScanCanceled	= "Auctioneer: Auktionenscan abgebrochen";
		UIScanComplete	= "Auctioneer: Auktionenscan abgeschlossen";
		UIScanFailed	= "Auctioneer: Auktionenscan fehlgeschlagen";


		-- Section: Generic Strings
		TextAuction	= "Auktion";
		TextCombat	= "Kampflog";
		TextGeneral	= "Allgemein";
		TextNone	= "nichts";
		TextScan	= "Scannen";
		TextUsage	= "Syntax:";


		-- Section: Help Text
		HelpAlso	= "Zeigt ebenfalls die Werte anderer Server im Tooltip an. Setze den Namen des Realms f�r Realm und den Namen der Fraktion f�r Fraktion ein. Zum Beispiel: \"/auctioneer auch Kil'Jaeden-Alliance\". Das spezielle Schl�sselwort \"Gegenseite\" bezeichnet die gegnerische Fraktion, \"aus\" deaktiviert die Funktionalit�t.";
		HelpAskPrice	= "Preisnachfrage ein-/ausschalten.";
		HelpAskPriceAd	= "Anzeige der neuen Preisnachfrage-Eigenschaften ein-/ausschalten.";
		HelpAskPriceGuild	= "Auf Gildenchat-Anfragen reagieren.";
		HelpAskPriceParty	= "Auf Gruppenchat-Anfragen reagieren.";
		HelpAskPriceSend	= "Einem Spieler manuell das Ergebnis einer Preisnachfrage senden.";
		HelpAskPriceSmart	= "Schlagwortcheck ein-/ausschalten.";
		HelpAskPriceTrigger	= "�ndere AskPrice Ausl�ser.";
		HelpAskPriceVendor	= "Anzeige von H�ndlerinformationen ein-/ausschalten.";
		HelpAskPriceWhispers	= "Aktiviere oder deaktiviere das Verbergen von allen von AskPrice abgehenden gefl�sterten Meldungen.";
		HelpAskPriceWord	= "Hinzuf�gen bzw. modifizieren von eigenen AskPrice SmartWords.";
		HelpAuctionClick	= "Mittels Alt-Klick auf einen Gegenstand in einer Tasche wird automatisch eine Auktion daf�r erstellt.";
		HelpAuctionDuration	= "Setzt die Standard-Auktionsdauer beim �ffnen des Auktionshausfensters";
		HelpAutofill	= "Festlegen, ob die Preise automatisch ausgef�llt werden sollen, wenn ein Gegenstand in das Auktionshaus gelegt wird.";
		HelpAverage	= "Festlegen, ob der durchschnittliche Auktionspreis angezeigt wird.";
		HelpBidbroker	= "Zeigt vom letzten Abbild alle Auktionen mit kurzer oder mittlerer Laufzeit an, auf die f�r Profit geboten werden k�nnte.";
		HelpBidLimit	= "Maximum Auktionen auf die geboten werden soll oder Sofortkauf wenn der Gebots- oder Sofortkaufbutton geklickt wurde, w�hrend eine Suchaktion l�uft.";
		HelpBroker	= "Zeigt alle Auktionen vom letzten Abbild an, auf die geboten und die mit Gewinn wieder verkauft werden k�nnten.";
		HelpClear	= "L�scht die Daten der angegebenen Gegenst�nde (Gegenst�nde m�ssen dem Befehl mittels Shift + Klick hinzugef�gt werden). Es k�nnen auch die speziellen Schl�sselworte \"alle\" und \"Abbild\" hinzugef�gt werden.";
		HelpCompete	= "Zeigt alle Auktionen des letzten Scans an, deren Sofortkaufpreis geringer ist als der eines eigenen im AH angebotenen Gegenstandes.";
		HelpDefault	= "Setzt eine Auctioneer-Einstellung auf ihren Standardwert zur�ck. Mit dem Schl�sselwort \"alle\" werden alle Auctioneer-Einstellungen zur�ckgesetzt.";
		HelpDisable	= "Stoppt den Autostart von Auctioneer ab dem n�chsten Einloggen.";
		HelpEmbed	= "Bettet den Auktionsinfotext in den WoW-Tooltip ein (Hinweis: Einige Funktionen sind in diesem Modus deaktiviert)";
		HelpEmbedBlank	= "Schaltet die Anzeige einer Leerzeile zwischen der Tooltipinfo und der Auktionsinfo im Einbettungsmodus ein/aus.";
		HelpFinish	= "W�hle zwischen automatischem Ausloggen oder Beenden des Spieles nach abgeschlossenem Scan";
		HelpFinishSound	= "Legt fest, ob nach Beenden eines Scans ein Ton abgespielt werden soll.";
		HelpLink	= "Schaltet die Anzeige der Link-ID im Tooltip ein/aus.";
		HelpLoad	= "Ladeverhalten von Auctioneer f�r diesen Charakter �ndern";
		HelpLocale	= "�ndern des Gebietsschemas das zur Anzeige \nvon Auctioneer-Meldungen verwendet wird";
		HelpMedian	= "Schaltet die Anzeige des Median-Sofortkaufpreises ein/aus";
		HelpOnoff	= "Schaltet die Anzeige der Auktionsdaten ein/aus";
		HelpPctBidmarkdown	= "Legt den Prozentsatz fest, um den das Mindestgebot niedriger als der Sofortkaufpreis ist.";
		HelpPctMarkup	= "Legt den Prozentsatz f�r erh�hte H�ndlerpreise fest, der verwendet wird, falls sonst keine anderen Werte verf�gbar sind.";
		HelpPctMaxless	= "Legt den maximalen Prozentsatz fest, um den Auctioneer den Marktpreis h�chstens unterschreiten darf.";
		HelpPctNocomp	= "Legt den Prozentsatz fest, um den der Marktpreis bei Monopol unterboten wird.";
		HelpPctUnderlow	= "Legt den Prozentsatz fest, um den das g�nstigste konkurrierende Angebot unterboten wird.";
		HelpPctUndermkt	= "Legt den Prozentsatz fest, um den der Marktpreis unterboten wird, wenn durch den gew�hlten Prozentsatz f�r maxless ein konkurrierendes Angebot nicht unterboten werden kann.";
		HelpPercentless	= "Zeigt alle Auktionen des letzten Abbilds an, deren Sofortkaufpreis einen gewissen Prozentsatz unter dem h�chstm�glichen Verkaufspreis liegt.";
		HelpPrintin	= "Ausw�hlen in welchem Fenster die Auctioneer-Meldungen angezeigt werden. Es kann entweder der Fensterindex oder der Fenstername angegeben werden.";
		HelpProtectWindow	= "Verhindert das versehentliche Schlie�en des Auktionshaus-Fensters.";
		HelpRedo	= "Legt fest, ob eine Warnung angezeigt wird, wenn das Scannen der aktuellen Seite im Auktionshaus wegen Serverlag zu lange dauert.";
		HelpScan	= "F�hrt einen Scan des Auktionshauses beim n�chsten Besuch durch bzw. sofort, wenn man schon dort ist (es gibt ebenfalls einen Knopf im Auktionshausfenster). �ber die Auswahlboxen k�nnen die zu scannenden Kategorien gew�hlt werden.";
		HelpStats	= "Schaltet die Prozentanzeige vom Gebot/Sofortkauf ein/aus.";
		HelpSuggest	= "Schaltet die Anzeige des empfohlenen Auktionspreises ein/aus.";
		HelpUpdatePrice	= "Aktualisiert automatisch das Startgebot f�r eine Auktion auf der Auktionserstellungsseite wenn sich der Sofortkaufpreis �ndert.";
		HelpVerbose	= "Legt fest, ob Durchschnittswerte und Preisempfehlungen ausf�hrlich angezeigt werden (Ausschalten f�r Anzeige in einzelner Zeile)";
		HelpWarnColor	= "Festlegen, ob das aktuelle AH-Preismodell (Unterbiete um ...) mit intuitiven Farben angezeigt wird.";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "Keinen leeren Taschenplatz gefunden, um die Auktion zu erstellen!";
		FrmtNotEnoughOfItem	= "Nicht genug %s gefunden, um die Auktion zu erstellen!";
		FrmtPostedAuction	= "Es wurde 1 Auktion mit %s (x%d) erstellt.";
		FrmtPostedAuctions	= "Es wurden %d Auktionen mit %s (x%d) erstellt.";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "aktGebot";
		FrmtBidbrokerDone	= "Gebotsmakeln fertig";
		FrmtBidbrokerHeader	= "Mindestprofit: %s, HVP = 'H�chster Verkaufspreis'";
		FrmtBidbrokerLine	= "%s, zuletzt %s gesehen, HVP: %s, %s: %s, Profit: %s, Restzeit: %s";
		FrmtBidbrokerMinbid	= "niedrGebot";
		FrmtBrokerDone	= "Makeln beendet";
		FrmtBrokerHeader	= "Mindestprofit: %s, HVP = 'H�chster Verkaufspreis'";
		FrmtBrokerLine	= "%s, zuletzt %s gesehen, HVP: %s, Sofortkauf: %s, Profit: %s";
		FrmtCompeteDone	= "Konkurrierende Auktionen abgeschlossen.";
		FrmtCompeteHeader	= "Konkurrierende Auktionen mindestens %s billiger pro St�ck.";
		FrmtCompeteLine	= "%s, Gebot: %s, Sofortkauf %s gg. %s, %s billiger";
		FrmtHspLine	= "H�chster Verkaufspreis pro %s ist: %s";
		FrmtLowLine	= "%s, Sofortkauf: %s, Verk�ufer: %s, %s/St�ck, %s unter dem Median";
		FrmtMedianLine	= "Aus %d ist der Median-Sofortkaufpreis f�r 1 %s: %s";
		FrmtNoauct	= "Keine Aktionen f�r %s gefunden.";
		FrmtPctlessDone	= "Prozent unter HVP beendet.";
		FrmtPctlessHeader	= "Prozent billiger als der h�chste Verkaufspreis (HVP): %d%%";
		FrmtPctlessLine	= "%s, zuletzt %d gesehen, HVP: %s, Sofortkauf: %s, Profit: %s, Billiger %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "Abgelaufene Auktionen: %s";
		AuctionDiscrepancies	= "Unstimmigkeiten: %s";
		AuctionNewAucts	= "Davon neu: %s";
		AuctionOldAucts	= "Schon bekannt: %s";
		AuctionPageN	= "Auctioneer: Erfasse \"%s\", Seite %d von %d\nAuktionen pro Sekunde: %s\nGesch�tzte Restzeit: %s";
		AuctionScanDone	= "Auctioneer: Scan abgeschlossen";
		AuctionScanNexttime	= "Auctioneer wird einen vollst�ndigen Auktionsscan durchf�hren, wenn das n�chste Mal ein Auktionator angesprochen wird.";
		AuctionScanNocat	= "Zum Scannen muss mindestens eine Kategorie ausgew�hlt sein.";
		AuctionScanRedo	= "Das Erfassen der aktuelle Seite ben�tigte mehr als %d Sekunden, erneuter Versuch.";
		AuctionScanStart	= "Auctioneer: Scanne %s Seite 1...";
		AuctionTotalAucts	= "Insgesamt gescannte Auktionen: %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "%d mal f�r %s gesehen";
		FrmtInfoAverage	= "%s min/%s Sofortkauf (%s geboten)";
		FrmtInfoBidMulti	= "Geboten (%s%s pro St�ck)";
		FrmtInfoBidOne	= "Geboten %s";
		FrmtInfoBidrate	= "%d%% mit Gebot, %d%% mit Sofortkauf";
		FrmtInfoBuymedian	= "Sofortkaufsmedian";
		FrmtInfoBuyMulti	= "Sofortkauf (%s%s pro St�ck)";
		FrmtInfoBuyOne	= "Sofortkauf %s";
		FrmtInfoForone	= "Pro St�ck: %s min/%s Sofortkauf (%s geboten) [in %d]";
		FrmtInfoHeadMulti	= "Durchschnitt f�r %d St�ck:";
		FrmtInfoHeadOne	= "Durchschnitt f�r dieses Objekt:";
		FrmtInfoHistmed	= "Sofortkaufmedian (pro St�ck) der %d letzten Auktionen:";
		FrmtInfoMinMulti	= "Startgebot (%s pro St�ck)";
		FrmtInfoMinOne	= "Startgebot";
		FrmtInfoNever	= "Noch nie in %s gesehen";
		FrmtInfoSeen	= "Insgesamt %d mal in Auktionen gesehen";
		FrmtInfoSgst	= "Empfohlener Preis: %s min/%s Sofortkauf";
		FrmtInfoSgststx	= "Empfohlener Preis f�r diesen %der Stapel: %s min/%s Sofortkauf (%s/%s pro St�ck)";
		FrmtInfoSnapmed	= "Sofortkaufsmedian (pro St�ck) aus %d gescannten Auktionen:";
		FrmtInfoStacksize	= "Durchschnittliche Stapelgr��e: %d St�ck";


		-- Section: User Interface
		BuySortTooltip	= "Ergebnisseite nach Verkaufspreis sortieren (dr�cke SHIFT um nach Itemnamen zu sortieren)";
		ClearTooltip	= "Eingaben im Suchfeld l�schen";
		FrmtLastSoldOn	= "Zuletzt verkauft f�r %s";
		RefreshTooltip	= "Suchanfrage der aktuellen Seite wiederholen";
		UiBid	= "Gebot";
		UiBidHeader	= "Gebot";
		UiBidPerHeader	= "Gebot pro";
		UiBuyout	= "Sofortkauf";
		UiBuyoutHeader	= "Sofortkauf";
		UiBuyoutPerHeader	= "Sofortkauf pro";
		UiBuyoutPriceLabel	= "Sofortkaufpreis:";
		UiBuyoutPriceTooLowError	= "(zu niedrig)";
		UiCategoryLabel	= "Kategoriebeschr�nkung:";
		UiDepositLabel	= "Anzahlung:";
		UiDurationLabel	= "Dauer:";
		UiItemLevelHeader	= "Stufe";
		UiMakeFixedPriceLabel	= "Als Festpreis setzen";
		UiMaxError	= "(%d Max)";
		UiMaximumPriceLabel	= "Maximaler Preis:";
		UiMaximumTimeLeftLabel	= "Maximale Restzeit:";
		UiMinimumPercentLessLabel	= "Prozent unter HVP:";
		UiMinimumProfitLabel	= "Mindestgewinn:";
		UiMinimumQualityLabel	= "Mindestqualit�t:";
		UiMinimumUndercutLabel	= "Unterbieten um:";
		UiNameHeader	= "Name";
		UiNoPendingBids	= "Alle Gebotsanfragen komplett!";
		UiNotEnoughError	= "(nicht genug)";
		UiPendingBidInProgress	= "1 Gebotsanfrage in Bearbeitung...";
		UiPendingBidsInProgress	= "%d Gebotsanfragen in Bearbeitung...";
		UiPercentLessHeader	= "%";
		UiPost	= "Erstellen";
		UiPostAuctions	= "Erstelle Auktionen";
		UiPriceBasedOnLabel	= "Preis basiert auf:";
		UiPriceModelAuctioneer	= "Auctioneer-Preis";
		UiPriceModelCustom	= "Benutzerdef. Preis";
		UiPriceModelFixed	= "Festpreis";
		UiPriceModelLastSold	= "Zuletzt verkauft f�r";
		UiProfitHeader	= "Gewinn";
		UiProfitPerHeader	= "Gewinn pro";
		UiQuantityHeader	= "Anz.";
		UiQuantityLabel	= "Anzahl:";
		UiRemoveSearchButton	= "L�schen";
		UiSavedSearchLabel	= "Gespeicherte Suchen:";
		UiSaveSearchButton	= "Speichern";
		UiSaveSearchLabel	= "Suche speichern:";
		UiSearch	= "Suche";
		UiSearchAuctions	= "Durchsuche Auktionen";
		UiSearchDropDownLabel	= "Suche:";
		UiSearchForLabel	= "Gegenstand suchen:";
		UiSearchTypeBids	= "Gebote";
		UiSearchTypeBuyouts	= "Sofortk�ufe";
		UiSearchTypeCompetition	= "Konkurrenz";
		UiSearchTypePlain	= "Gegenstand";
		UiStacksLabel	= "Stapel";
		UiStackTooBigError	= "(Stapel zu gro�)";
		UiStackTooSmallError	= "(Stapel zu klein)";
		UiStartingPriceLabel	= "Startpreis:";
		UiStartingPriceRequiredError	= "(erforderlich)";
		UiTimeLeftHeader	= "Restzeit";
		UiUnknownError	= "(Unbekannt)";

	};

	enUS = {


		-- Section: AskPrice Messages
		AskPriceAd	= "Get stack prices with %sx[ItemLink] (x = stacksize)";
		FrmtAskPriceBuyoutMedianHistorical	= "%sBuyout-median historical: %s%s";
		FrmtAskPriceBuyoutMedianSnapshot	= "%sBuyout-median last scan: %s%s";
		FrmtAskPriceDisable	= "Disabling AskPrice's %s option";
		FrmtAskPriceEach	= "(%s each)";
		FrmtAskPriceEnable	= "Enabling AskPrice's %s option";
		FrmtAskPriceVendorPrice	= "%sSell to vendor for: %s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "Removing auction signature %s from current AH snapshot.";
		FrmtAuctinfoHist	= "%d historical";
		FrmtAuctinfoLow	= "Snapshot Low";
		FrmtAuctinfoMktprice	= "Market price";
		FrmtAuctinfoNolow	= "Item not seen last snapshot";
		FrmtAuctinfoOrig	= "Original Bid";
		FrmtAuctinfoSnap	= "%d last scan";
		FrmtAuctinfoSugbid	= "Starting bid";
		FrmtAuctinfoSugbuy	= "Suggested buyout";
		FrmtWarnAbovemkt	= "Competition above market";
		FrmtWarnMarkup	= "Marking up vendor by %s%%";
		FrmtWarnMyprice	= "Using my current price";
		FrmtWarnNocomp	= "No competition";
		FrmtWarnNodata	= "No data for HSP";
		FrmtWarnToolow	= "Cannot match lowest price";
		FrmtWarnUndercut	= "Undercutting by %s%%";
		FrmtWarnUser	= "Using user pricing";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "Already the high bidder on auction: %s (x%d)";
		FrmtBidAuction	= "Bid on auction: %s (x%d)";
		FrmtBidQueueOutOfSync	= "Error: Bid queue out of sync!";
		FrmtBoughtAuction	= "Bought out auction: %s (x%d)";
		FrmtMaxBidsReached	= "More auctions of %s (x%d) found, but bid limit reached (%d)";
		FrmtNoAuctionsFound	= "No auctions found: %s (x%d)";
		FrmtNoMoreAuctionsFound	= "No more auctions found: %s (x%d)";
		FrmtNotEnoughMoney	= "Not enough money to bid on auction: %s (x%d)";
		FrmtSkippedAuctionWithHigherBid	= "Skipped auction with higher bid: %s (x%d)";
		FrmtSkippedAuctionWithLowerBid	= "Skipped auction with lower bid: %s (x%d)";
		FrmtSkippedBiddingOnOwnAuction	= "Skipped bidding on own auction: %s (x%d)";
		UiProcessingBidRequests	= "Processing bid requests...";


		-- Section: Command Messages
		ConstantsCritical	= "CRITICAL: Your Auctioneer SavedVariables file is %.3f%% Full!";
		ConstantsMessage	= "Your Auctioneer SavedVariables file is %.3f%% Full";
		ConstantsWarning	= "WARNING: Your Auctioneer SavedVariables file is %.3f%% Full";
		FrmtActClearall	= "Clearing all auction data for %s";
		FrmtActClearFail	= "Unable to find item: %s";
		FrmtActClearOk	= "Cleared data for item: %s";
		FrmtActClearsnap	= "Clearing current Auction House snapshot.";
		FrmtActDefault	= "Auctioneer's %s option has been reset to its default setting";
		FrmtActDefaultall	= "All Auctioneer options have been reset to default settings.";
		FrmtActDisable	= "Not displaying item's %s data";
		FrmtActEnable	= "Displaying item's %s data";
		FrmtActSet	= "Set %s to '%s'";
		FrmtActUnknown	= "Unknown command or keyword: '%s'";
		FrmtAuctionDuration	= "Default action duration set to: %s";
		FrmtAutostart	= "Automatically starting auction for %s: %s minimum, %s buyout (%dh)\n%s";
		FrmtFinish	= "After a scan has finished, we will %s";
		FrmtPrintin	= "Auctioneer's messages will now print on the \"%s\" chat frame";
		FrmtProtectWindow	= "Auction House window protection set to: %s";
		FrmtUnknownArg	= "'%s' is no valid argument for '%s'";
		FrmtUnknownLocale	= "The locale you specified ('%s') is unknown. Valid locales are:";
		FrmtUnknownRf	= "Invalid parameter ('%s'). The parameter must be formated like: [realm]-[faction]. For example: Al'Akir-Horde";


		-- Section: Command Options
		OptAlso	= "(realm-faction||opposite||home||neutral)";
		OptAskPriceSend	= "(<PlayerName> <AskPrice Query>)";
		OptAuctionDuration	= "(last||2h||8h||24h)";
		OptBidbroker	= "<silver_profit>";
		OptBidLimit	= "<number>";
		OptBroker	= "<silver_profit>";
		OptClear	= "([Item]||all||snapshot)";
		OptCompete	= "<silver_less>";
		OptDefault	= "(<option>||all)";
		OptFinish	= "(off||logout||exit)";
		OptLocale	= "<locale>";
		OptPctBidmarkdown	= "<percent>";
		OptPctMarkup	= "<percent>";
		OptPctMaxless	= "<percent>";
		OptPctNocomp	= "<percent>";
		OptPctUnderlow	= "<percent>";
		OptPctUndermkt	= "<percent>";
		OptPercentless	= "<percent>";
		OptPrintin	= "(<frameIndex>[Number]||<frameName>[String])";
		OptProtectWindow	= "(never||scan||always)";
		OptScale	= "<scale_factor>";
		OptScan	= "<>";


		-- Section: Commands
		CmdAlso	= "also";
		CmdAlsoOpposite	= "opposite";
		CmdAlt	= "alt";
		CmdAskPriceAd	= "ad";
		CmdAskPriceGuild	= "guild";
		CmdAskPriceParty	= "party";
		CmdAskPriceSend	= "send";
		CmdAskPriceSmart	= "smart";
		CmdAskPriceSmartWord1	= "what";
		CmdAskPriceSmartWord2	= "worth";
		CmdAskPriceTrigger	= "trigger";
		CmdAskPriceVendor	= "vendor";
		CmdAskPriceWhispers	= "whispers";
		CmdAskPriceWord	= "word";
		CmdAuctionClick	= "auction-click";
		CmdAuctionDuration	= "auction-duration";
		CmdAuctionDuration0	= "last";
		CmdAuctionDuration1	= "2h";
		CmdAuctionDuration2	= "8h";
		CmdAuctionDuration3	= "24h";
		CmdAutofill	= "autofill";
		CmdBidbroker	= "bidbroker";
		CmdBidbrokerShort	= "bb";
		CmdBidLimit	= "bid-limit";
		CmdBroker	= "broker";
		CmdClear	= "clear";
		CmdClearAll	= "all";
		CmdClearSnapshot	= "snapshot";
		CmdCompete	= "compete";
		CmdCtrl	= "ctrl";
		CmdDefault	= "default";
		CmdDisable	= "disable";
		CmdEmbed	= "embed";
		CmdFinish	= "finish";
		CmdFinish0	= "off";
		CmdFinish1	= "logout";
		CmdFinish2	= "exit";
		CmdFinish3	= "reloadui";
		CmdFinishSound	= "finish-sound";
		CmdHelp	= "help";
		CmdLocale	= "locale";
		CmdOff	= "off";
		CmdOn	= "on";
		CmdPctBidmarkdown	= "pct-bidmarkdown";
		CmdPctMarkup	= "pct-markup";
		CmdPctMaxless	= "pct-maxless";
		CmdPctNocomp	= "pct-nocomp";
		CmdPctUnderlow	= "pct-underlow";
		CmdPctUndermkt	= "pct-undermkt";
		CmdPercentless	= "percentless";
		CmdPercentlessShort	= "pl";
		CmdPrintin	= "print-in";
		CmdProtectWindow	= "protect-window";
		CmdProtectWindow0	= "never";
		CmdProtectWindow1	= "scan";
		CmdProtectWindow2	= "always";
		CmdScan	= "scan";
		CmdShift	= "shift";
		CmdToggle	= "toggle";
		CmdUpdatePrice	= "update-price";
		CmdWarnColor	= "warn-color";
		ShowAverage	= "show-average";
		ShowEmbedBlank	= "show-embed-blankline";
		ShowLink	= "show-link";
		ShowMedian	= "show-median";
		ShowRedo	= "show-warning";
		ShowStats	= "show-stats";
		ShowSuggest	= "show-suggest";
		ShowVerbose	= "show-verbose";


		-- Section: Config Text
		GuiAlso	= "Also display data for";
		GuiAlsoDisplay	= "Displaying data for %s";
		GuiAlsoOff	= "No longer displaying other realm-faction data.";
		GuiAlsoOpposite	= "Now also displaying data for opposite faction.";
		GuiAskPrice	= "Enable AskPrice";
		GuiAskPriceAd	= "Send features ad";
		GuiAskPriceGuild	= "Respond to guildchat queries";
		GuiAskPriceHeader	= "AskPrice Options";
		GuiAskPriceHeaderHelp	= "Change AskPrice's behaviour";
		GuiAskPriceParty	= "Respond to partychat queries";
		GuiAskPriceSmart	= "Use smartwords";
		GuiAskPriceTrigger	= "AskPrice trigger";
		GuiAskPriceVendor	= "Send vendor info";
		GuiAskPriceWhispers	= "Show outgoing whispers";
		GuiAskPriceWord	= "Custom SmartWord %d";
		GuiAuctionDuration	= "Default auction duration";
		GuiAuctionHouseHeader	= "Auction House window";
		GuiAuctionHouseHeaderHelp	= "Change the behavior of the Auction House window";
		GuiAutofill	= "Autofill prices in the AH";
		GuiAverages	= "Show Averages";
		GuiBidmarkdown	= "Bid Markdown Percent";
		GuiClearall	= "Clear All Auctioneer Data";
		GuiClearallButton	= "Clear All";
		GuiClearallHelp	= "Click here to clear all of Auctioneer data for the current server-realm.";
		GuiClearallNote	= "for the current server-faction";
		GuiClearHeader	= "Clear Data";
		GuiClearHelp	= "Clears Auctioneer data. \nSelect either all data or the current snapshot.\nWARNING: These actions are NOT undoable.";
		GuiClearsnap	= "Clear Snapshot data";
		GuiClearsnapButton	= "Clear Snapshot";
		GuiClearsnapHelp	= "Click here to clear the last Auctioneer snapshot data.";
		GuiDefaultAll	= "Reset All Auctioneer Options";
		GuiDefaultAllButton	= "Reset All";
		GuiDefaultAllHelp	= "Click here to set all Auctioneer options to their default values.\nWARNING: This action is NOT undoable.";
		GuiDefaultOption	= "Reset this setting";
		GuiEmbed	= "Embed info in in-game tooltip";
		GuiEmbedBlankline	= "Show blankline in in-game tooltip";
		GuiEmbedHeader	= "Embed";
		GuiFinish	= "After a scan has finished";
		GuiFinishSound	= "Play sound on scan finish";
		GuiLink	= "Show LinkID";
		GuiLoad	= "Load Auctioneer";
		GuiLoad_Always	= "always";
		GuiLoad_AuctionHouse	= "at Auction House";
		GuiLoad_Never	= "never";
		GuiLocale	= "Set locale to";
		GuiMainEnable	= "Enable Auctioneer";
		GuiMainHelp	= "Contains settings for Auctioneer \nan AddOn that displays item info and analyzes auction data. \nClick the \"Scan\" button at the AH to collect auction data.";
		GuiMarkup	= "Vendor Price Markup Percent";
		GuiMaxless	= "Max Market Undercut Percent";
		GuiMedian	= "Show Medians";
		GuiNocomp	= "No Competition Undercut Percent";
		GuiNoWorldMap	= "Auctioneer: suppressed displaying of world map";
		GuiOtherHeader	= "Other Options";
		GuiOtherHelp	= "Miscellaneous Auctioneer Options";
		GuiPercentsHeader	= "Auctioneer Threshold Percents";
		GuiPercentsHelp	= "WARNING: The following setting are for Power Users ONLY.\nAdjust the following values to change how aggresive Auctioneer will be when deciding profitable levels.";
		GuiPrintin	= "Select the desired message frame";
		GuiProtectWindow	= "Prevent accidental closing of AH window";
		GuiRedo	= "Show Long Scan Warning";
		GuiReloadui	= "Reload User Interface";
		GuiReloaduiButton	= "ReloadUI";
		GuiReloaduiFeedback	= "Now Reloading the WoW UI";
		GuiReloaduiHelp	= "Click here to reload the WoW User Interface after changing the locale so that the language in this configuration screen matches the one you selected.\nNote: This operation may take a few minutes.";
		GuiRememberText	= "Remember price";
		GuiStatsEnable	= "Show Stats";
		GuiStatsHeader	= "Item Price Statistics";
		GuiStatsHelp	= "Show the following statistics in the tooltip.";
		GuiSuggest	= "Show Suggested Prices";
		GuiUnderlow	= "Lowest Auction Undercut";
		GuiUndermkt	= "Undercut Market When Maxless";
		GuiVerbose	= "Verbose Mode";
		GuiWarnColor	= "Color Pricing Model";


		-- Section: Conversion Messages
		MesgConvert	= "Auctioneer Database Conversion. Please backup your SavedVariables\\Auctioneer.lua first.%s%s";
		MesgConvertNo	= "Disable Auctioneer";
		MesgConvertYes	= "Convert";
		MesgNotconverting	= "Auctioneer is not converting your database, but will not function until you do.";


		-- Section: Game Constants
		TimeLong	= "Long";
		TimeMed	= "Medium";
		TimeShort	= "Short";
		TimeVlong	= "Very Long";


		-- Section: Generic Messages
		ConfirmBidBuyout	= "Are you sure you want to %s\n%dx%s for:";
		DisableMsg	= "Disabling automatic loading of Auctioneer";
		FrmtWelcome	= "Auctioneer v%s loaded";
		MesgNotLoaded	= "Auctioneer is not loaded. Type /auctioneer for more info.";
		ScanCancel	= "Scan canceled";
		ScanComplete	= "Scan complete";
		ScanFailed	= "Scan failed";
		StatAskPriceOff	= "AskPrice is now disabled.";
		StatAskPriceOn	= "AskPrice is now enabled.";
		StatOff	= "Not displaying any auction data";
		StatOn	= "Displaying configured auction data";
		UIScanCanceled	= "Auctioneer: Auction scanning canceled";
		UIScanComplete	= "Auctioneer: Auction scanning completed";
		UIScanFailed	= "Auctioneer: Auction scanning failed";


		-- Section: Generic Strings
		TextAuction	= "auction";
		TextCombat	= "Combat";
		TextGeneral	= "General";
		TextNone	= "none";
		TextScan	= "Scan";
		TextUsage	= "Usage:";


		-- Section: Help Text
		HelpAlso	= "Also display another server's values in the tooltip. For realm, insert the realmname and for faction the faction's name. For example: \"/auctioneer also Al'Akir-Horde\". The special keyword \"opposite\" means the opposite faction, \"off\" disables the functionality.";
		HelpAskPrice	= "Enable or disable AskPrice.";
		HelpAskPriceAd	= "Enable or disable new AskPrice features ad.";
		HelpAskPriceGuild	= "Respond to queries made in guild chat.";
		HelpAskPriceParty	= "Respond to queries made in party chat.";
		HelpAskPriceSend	= "Manually send a player the result of an AskPrice query.";
		HelpAskPriceSmart	= "Enable or disable SmartWords checking.";
		HelpAskPriceTrigger	= "Change AskPrice's trigger character.";
		HelpAskPriceVendor	= "Enable or disable the sending of vendor pricing data.";
		HelpAskPriceWhispers	= "Enable or disable the hiding of all AskPrice outgoing whispers.";
		HelpAskPriceWord	= "Add or modify AskPrice's custom SmartWords.";
		HelpAuctionClick	= "Allows you to Alt-Click an item in your bag to automatically start an auction for it";
		HelpAuctionDuration	= "Set the default auction duration upon opening the Auction House interface";
		HelpAutofill	= "Set whether to autofill prices when dropping new auction items into the auction house window";
		HelpAverage	= "Select whether to show item's average auction price";
		HelpBidbroker	= "Show short or medium term auctions from the recent scan that may be bid on for profit";
		HelpBidLimit	= "Maximum number of auctions to bid on or buyout when the Bid or Buyout button is clicked on the Search Auctions tab.";
		HelpBroker	= "Show any auctions from the most recent scan that may be bid on and then resold for profit";
		HelpClear	= "Clear the specified item's data (you must shift click insert the item(s) into the command) You may also specify the special keywords \"all\" or \"snapshot\"";
		HelpCompete	= "Show any recently scanned auctions whose buyout is less than one of your items";
		HelpDefault	= "Set an Auctioneer option to it's default value. You may also specify the special keyword \"all\" to set all Auctioneer options to their default values.";
		HelpDisable	= "Stops Auctioneer from automatically loading next time you log in";
		HelpEmbed	= "Embed the text in the original game tooltip (note: certain features are disabled when this is selected)";
		HelpEmbedBlank	= "Select whether to show a blank line between the tooltip info and the auction info when embedded mode is on";
		HelpFinish	= "Set whether to automatically logout or exit the game upon finishing an auction house scan";
		HelpFinishSound	= "Set whether to play a sound at the end of an Auction House scan.";
		HelpLink	= "Select whether to show the link id in the tooltip";
		HelpLoad	= "Change Auctioneer's load settings for this toon";
		HelpLocale	= "Change the locale that is used to display Auctioneer messages";
		HelpMedian	= "Select whether to show item's median buyout price";
		HelpOnoff	= "Turns the auction data display on and off";
		HelpPctBidmarkdown	= "Set the percentage that Auctioneer will mark down bids from the buyout price";
		HelpPctMarkup	= "The percentage that vendor prices will be marked up when no other values are available";
		HelpPctMaxless	= "Set the maximum percentage that Auctioneer will undercut market value before it gives up";
		HelpPctNocomp	= "The percentage that Auctioneer will undercut market value when there is no competition";
		HelpPctUnderlow	= "Set the percentage that Auctioneer will undercut the lowest auction price";
		HelpPctUndermkt	= "Percentage to cut market value by when unable to beat competition (due to maxless)";
		HelpPercentless	= "Show any recently scanned auctions whose buyout is a certain percent less than the highest sellable price";
		HelpPrintin	= "Select which frame Auctioneer will print out it's messages. You can either specify the frame's name or the frame's index.";
		HelpProtectWindow	= "Prevents you from accidentally closing the Auction House interface";
		HelpRedo	= "Select whether to show a warning when the currently scanned AH page has taken too long to scan due to server lag.";
		HelpScan	= "Perform a scan of the auction house at the next visit, or while you are there (there is also a button in the auction pane). Choose which categories you want to scan with the checkboxes.";
		HelpStats	= "Select whether to show item's bid/buyout percentages";
		HelpSuggest	= "Select whether to show item's suggested auction price";
		HelpUpdatePrice	= "Automatically update the starting price for an auction on the Post Auctions tab when the buyout price changes.";
		HelpVerbose	= "Select whether to show averages and suggestions verbosely (or off to show them on a single line)";
		HelpWarnColor	= "Select whether to show the current AH pricing model (Undercutting by...) in intuitive colors.";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "No empty pack space found to create auction!";
		FrmtNotEnoughOfItem	= "Not enough %s found to create auction!";
		FrmtPostedAuction	= "Posted 1 auction of %s (x%d)";
		FrmtPostedAuctions	= "Posted %d auctions of %s (x%d)";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "curBid";
		FrmtBidbrokerDone	= "Bid brokering done";
		FrmtBidbrokerHeader	= "Minimum profit: %s, HSP = 'Highest Sellable Price'";
		FrmtBidbrokerLine	= "%s, Last %s seen, HSP: %s, %s: %s, Prof: %s, Time: %s";
		FrmtBidbrokerMinbid	= "minBid";
		FrmtBrokerDone	= "Brokering done";
		FrmtBrokerHeader	= "Minimum profit: %s, HSP = 'Highest Sellable Price'";
		FrmtBrokerLine	= "%s, Last %s seen, HSP: %s, BO: %s, Prof: %s";
		FrmtCompeteDone	= "Competing auctions done.";
		FrmtCompeteHeader	= "Competing auctions at least %s less per item.";
		FrmtCompeteLine	= "%s, Bid: %s, BO %s vs %s, %s less";
		FrmtHspLine	= "Highest Sellable Price for one %s is: %s";
		FrmtLowLine	= "%s, BO: %s, Seller: %s, For one: %s, Less than median: %s";
		FrmtMedianLine	= "Of last %d seen, median BO for 1 %s is: %s";
		FrmtNoauct	= "No auctions found for the item: %s";
		FrmtPctlessDone	= "Percent less done.";
		FrmtPctlessHeader	= "Percent Less than Highest Sellable Price (HSP): %d%%";
		FrmtPctlessLine	= "%s, Last %d seen, HSP: %s, BO: %s, Prof: %s, Less %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "Defunct auctions removed: %s";
		AuctionDiscrepancies	= "Discrepancies: %s";
		AuctionNewAucts	= "New auctions scanned: %s";
		AuctionOldAucts	= "Previously scanned: %s";
		AuctionPageN	= "Auctioneer: scanning %s page %d of %d\nAuctions per second: %s\nEstimated time left: %s\nAdded to snapshot: %s";
		AuctionScanDone	= "Auctioneer: auction scanning finished";
		AuctionScanNexttime	= "Auctioneer will perform a full auction scan the next time you talk to an auctioneer.";
		AuctionScanNocat	= "You must have at least one category selected to scan.";
		AuctionScanRedo	= "Current page took more than %d seconds to complete, retrying page.";
		AuctionScanStart	= "Auctioneer: scanning %s page 1...";
		AuctionTotalAucts	= "Total auctions scanned: %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "Seen %d times at %s";
		FrmtInfoAverage	= "%s min/%s BO (%s bid)";
		FrmtInfoBidMulti	= "Bids (%s%s ea)";
		FrmtInfoBidOne	= "Bids%s";
		FrmtInfoBidrate	= "%d%% have bids, %d%% have BO";
		FrmtInfoBuymedian	= "Buyout median";
		FrmtInfoBuyMulti	= "Buyout (%s%s ea)";
		FrmtInfoBuyOne	= "Buyout%s";
		FrmtInfoForone	= "For 1: %s min/%s BO (%s bid) [in %d's]";
		FrmtInfoHeadMulti	= "Averages for %d items:";
		FrmtInfoHeadOne	= "Averages for this item:";
		FrmtInfoHistmed	= "Last %d, median BO (ea)";
		FrmtInfoMinMulti	= "Starting bid (%s ea)";
		FrmtInfoMinOne	= "Starting bid";
		FrmtInfoNever	= "Never seen at %s";
		FrmtInfoSeen	= "Seen %d times at auction total";
		FrmtInfoSgst	= "Suggested price: %s min/%s BO";
		FrmtInfoSgststx	= "Suggested price for your %d stack: %s min/%s BO (%s/%s ea)";
		FrmtInfoSnapmed	= "Scanned %d, median BO (ea)";
		FrmtInfoStacksize	= "Average stack size: %d items";


		-- Section: User Interface
		BuySortTooltip	= "Sort results page by buyout price (hold SHIFT to sort by item name instead)";
		ClearTooltip	= "Clear any custom search parameters from search fields.";
		FrmtLastSoldOn	= "Last Sold on %s";
		RefreshTooltip	= "Resubmit search query at the current page number.";
		UiBid	= "Bid";
		UiBidHeader	= "Bid";
		UiBidPerHeader	= "Bid Per";
		UiBuyout	= "Buyout";
		UiBuyoutHeader	= "Buyout";
		UiBuyoutPerHeader	= "Buyout Per";
		UiBuyoutPriceLabel	= "Buyout Price:";
		UiBuyoutPriceTooLowError	= "(Too Low)";
		UiCategoryLabel	= "Category Restriction:";
		UiDepositLabel	= "Deposit:";
		UiDurationLabel	= "Duration:";
		UiItemLevelHeader	= "Lvl";
		UiMakeFixedPriceLabel	= "Make fixed price";
		UiMaxError	= "(%d Max)";
		UiMaximumPriceLabel	= "Maximum Price:";
		UiMaximumTimeLeftLabel	= "Maximum Time Left:";
		UiMinimumPercentLessLabel	= "Minimum Percent Less:";
		UiMinimumProfitLabel	= "Minimum Profit:";
		UiMinimumQualityLabel	= "Minimum Quality:";
		UiMinimumUndercutLabel	= "Minimum Undercut:";
		UiNameHeader	= "Name";
		UiNoPendingBids	= "All bid requests complete!";
		UiNotEnoughError	= "(Not Enough)";
		UiPendingBidInProgress	= "1 bid request in progress...";
		UiPendingBidsInProgress	= "%d bid requests in progress...";
		UiPercentLessHeader	= "Pct";
		UiPost	= "Post";
		UiPostAuctions	= "Post Auctions";
		UiPriceBasedOnLabel	= "Price Based On:";
		UiPriceModelAuctioneer	= "Auctioneer Price";
		UiPriceModelCustom	= "Custom Price";
		UiPriceModelFixed	= "Fixed Price";
		UiPriceModelLastSold	= "Last Price Sold";
		UiProfitHeader	= "Profit";
		UiProfitPerHeader	= "Profit Per";
		UiQuantityHeader	= "Qty";
		UiQuantityLabel	= "Quantity:";
		UiRemoveSearchButton	= "Delete";
		UiSavedSearchLabel	= "Saved searches:";
		UiSaveSearchButton	= "Save";
		UiSaveSearchLabel	= "Save this search:";
		UiSearch	= "Search";
		UiSearchAuctions	= "Search Auctions";
		UiSearchDropDownLabel	= "Search:";
		UiSearchForLabel	= "Search For Item:";
		UiSearchTypeBids	= "Bids";
		UiSearchTypeBuyouts	= "Buyouts";
		UiSearchTypeCompetition	= "Competition";
		UiSearchTypePlain	= "Item";
		UiStacksLabel	= "Stacks";
		UiStackTooBigError	= "(Stack Too Big)";
		UiStackTooSmallError	= "(Stack Too Small)";
		UiStartingPriceLabel	= "Starting Price:";
		UiStartingPriceRequiredError	= "(Required)";
		UiTimeLeftHeader	= "Time Left";
		UiUnknownError	= "(Unknown)";

	};

	esES = {


		-- Section: AskPrice Messages
		AskPriceAd	= "Recibe precios para paquetes con %sx[Enlace de Art�culo] (x = tama�o del paquete)";
		FrmtAskPriceBuyoutMedianHistorical	= "%sMedia hist�rica: %s%s";
		FrmtAskPriceBuyoutMedianSnapshot	= "%sPromedio de compra en �ltima b�squeda: %s%s";
		FrmtAskPriceDisable	= "Deshabilitando la opci�n %s de PreguntarPrecios";
		FrmtAskPriceEach	= "(%s c/u)";
		FrmtAskPriceEnable	= "Activando la opci�n %s de PreguntarPrecios";
		FrmtAskPriceVendorPrice	= "%sVender a vendedor por: %s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "Quitando subasta %s de los datos actuales de la casa de subastas.";
		FrmtAuctinfoHist	= "%d Hist�rico";
		FrmtAuctinfoLow	= "Precio m�s bajo";
		FrmtAuctinfoMktprice	= "Precio de mercado";
		FrmtAuctinfoNolow	= "El objeto no ha sido visto antes en la Casa de Subastas";
		FrmtAuctinfoOrig	= "Puja Original";
		FrmtAuctinfoSnap	= "%d en la �ltima exploraci�n";
		FrmtAuctinfoSugbid	= "Puja inicial";
		FrmtAuctinfoSugbuy	= "Precio de compra sugerido";
		FrmtWarnAbovemkt	= "Competencia por encima del mercado";
		FrmtWarnMarkup	= "Superando vendedor por %s%%";
		FrmtWarnMyprice	= "Usando mi precio actual";
		FrmtWarnNocomp	= "Sin competencia";
		FrmtWarnNodata	= "Sin informaci�n para PMV";
		FrmtWarnToolow	= "Imposible igualar m�nimo";
		FrmtWarnUndercut	= "Rebajando en un %s%%";
		FrmtWarnUser	= "Usando precio de usuario";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "Ya eres el pujador m�s alto en la subasta: %s (x%d)";
		FrmtBidAuction	= "Puja en la subasta: %s (x%d)";
		FrmtBidQueueOutOfSync	= "Error: �Lista de pujas desincronizada!";
		FrmtBoughtAuction	= "Se compr� subasta: %s (x%d)";
		FrmtMaxBidsReached	= "Mas subastas de %s (x%d) encontradas, pero se lleg� al limite de pujas(%d)";
		FrmtNoAuctionsFound	= "No se ha encontrado la subasta: %s (x%d)";
		FrmtNoMoreAuctionsFound	= "No se encontraron m�s subastas: %s (x%d)";
		FrmtNotEnoughMoney	= "No tienes suficiente dinero para pujar en la subasta: %s (x%d)";
		FrmtSkippedAuctionWithHigherBid	= "Saltando subasta con puja mayor: %s (x%d)";
		FrmtSkippedAuctionWithLowerBid	= "Saltando subasta con puja menor: %s (x%d)";
		FrmtSkippedBiddingOnOwnAuction	= "Saltando puja en subasta propia: %s (x%d)";
		UiProcessingBidRequests	= "Procesando petici�n de pujas...";


		-- Section: Command Messages
		ConstantsCritical	= "CR�TICO: Su archivo de variables de Auctioneer est� %.3f%% Lleno!";
		ConstantsMessage	= "Su archivo de variables de Auctioneer est� %.3f%% Lleno";
		ConstantsWarning	= "ADVERTENCIA: Su archivo de variables de Auctioneer est� %.3f%% Lleno";
		FrmtActClearall	= "Eliminando toda la informaci�n de subastas para %s";
		FrmtActClearFail	= "Imposible encontrar art�culo: %s";
		FrmtActClearOk	= "Informaci�n eliminada para el art�culo: %s";
		FrmtActClearsnap	= "Eliminando informaci�n actual de la casa de subastas.";
		FrmtActDefault	= "La configuraci�n %s de Auctioneer ha sido restaurada a su estado original";
		FrmtActDefaultall	= "Todas las opciones de Auctioneer han sido cambiadas a su estado original";
		FrmtActDisable	= "Ocultando informaci�n de: %s ";
		FrmtActEnable	= "Mostrando informacion de: %s ";
		FrmtActSet	= "%s ajustado(a) a '%s'";
		FrmtActUnknown	= "Palabra clave o comando desconocido: '%s'";
		FrmtAuctionDuration	= "Duraci�n de las subastas fijado a: %s";
		FrmtAutostart	= "Comenzando subasta autom�ticamente para %s: %s m�nimo, %s compra (%dh)\n%s";
		FrmtFinish	= "Despu�s de que una exploraci�n haya terminado, nosotros %s";
		FrmtPrintin	= "Los mensajes de Auctioneer se imprimir�n en la ventana de chat \"%s\"";
		FrmtProtectWindow	= "Protecci�n de la ventana de la Casa de Subastas fijado a: %s";
		FrmtUnknownArg	= "'%s' no es un argumento v�lido para '%s'";
		FrmtUnknownLocale	= "La localizaci�n que ha especif�cado ('%s') no es v�lida. Las localizaciones v�lidas son:";
		FrmtUnknownRf	= "Par�metro inv�lido ('%s'). El par�metro debe de estar en la forma de: [reino]-[facci�n]. Por ejemplo: Al'Akir-Horda";


		-- Section: Command Options
		OptAlso	= "(reino-facci�n||opuesta||casa||neutral)";
		OptAskPriceSend	= "(<NombreDeJugador> <Pregunta para AskPrice>)";
		OptAuctionDuration	= "(�ltima|2h|8h|24h)";
		OptBidbroker	= "<ganancia_plata>";
		OptBidLimit	= "<n�mero>";
		OptBroker	= "<ganancia_plata>";
		OptClear	= "([Art�culo]||todo||imagen)";
		OptCompete	= "<plata_menos>";
		OptDefault	= "(<opci�n>||todo)";
		OptFinish	= "(apagado||de-registrarse||salir)";
		OptLocale	= "<localizaci�n>";
		OptPctBidmarkdown	= "<porciento>";
		OptPctMarkup	= "<porciento>";
		OptPctMaxless	= "<porciento>";
		OptPctNocomp	= "<porciento>";
		OptPctUnderlow	= "<porciento>";
		OptPctUndermkt	= "<porciento>";
		OptPercentless	= "<porciento>";
		OptPrintin	= "(<�ndiceVentana>[N�mero]||<nombreVentana>[Serie])";
		OptProtectWindow	= "(nunca||explorar||siempre)";
		OptScale	= "<escala>";
		OptScan	= "<>";


		-- Section: Commands
		CmdAlso	= "tambien";
		CmdAlsoOpposite	= "opuesta";
		CmdAlt	= "Alt";
		CmdAskPriceAd	= "anuncio";
		CmdAskPriceGuild	= "gremio";
		CmdAskPriceParty	= "grupo";
		CmdAskPriceSend	= "enviar";
		CmdAskPriceSmart	= "inteligente";
		CmdAskPriceSmartWord1	= "cuanto";
		CmdAskPriceSmartWord2	= "vale";
		CmdAskPriceTrigger	= "gatillo";
		CmdAskPriceVendor	= "vendedor";
		CmdAskPriceWhispers	= "susurros";
		CmdAskPriceWord	= "palabra";
		CmdAuctionClick	= "click-subasta";
		CmdAuctionDuration	= "duracion-subasta";
		CmdAuctionDuration0	= "�ltima";
		CmdAuctionDuration1	= "2h";
		CmdAuctionDuration2	= "8h";
		CmdAuctionDuration3	= "24h";
		CmdAutofill	= "autoinsertar";
		CmdBidbroker	= "corredor de ofertas";
		CmdBidbrokerShort	= "co";
		CmdBidLimit	= "limite-peticiones";
		CmdBroker	= "corredor";
		CmdClear	= "borrar";
		CmdClearAll	= "todo";
		CmdClearSnapshot	= "imagen";
		CmdCompete	= "competir";
		CmdCtrl	= "Ctrl";
		CmdDefault	= "original";
		CmdDisable	= "deshabilitar";
		CmdEmbed	= "integrado";
		CmdFinish	= "terminar";
		CmdFinish0	= "apagado";
		CmdFinish1	= "salir";
		CmdFinish2	= "salir";
		CmdFinish3	= "recargar";
		CmdFinishSound	= "sonido-terminar";
		CmdHelp	= "ayuda";
		CmdLocale	= "localidad";
		CmdOff	= "apagado";
		CmdOn	= "activar";
		CmdPctBidmarkdown	= "pct-menosoferta";
		CmdPctMarkup	= "pct-mas";
		CmdPctMaxless	= "pct-sinmaximo";
		CmdPctNocomp	= "pct-sincomp";
		CmdPctUnderlow	= "pct-bajomenor";
		CmdPctUndermkt	= "pct-bajomercado";
		CmdPercentless	= "porcientomenos";
		CmdPercentlessShort	= "pm";
		CmdPrintin	= "imprimir-en";
		CmdProtectWindow	= "protejer-ventana";
		CmdProtectWindow0	= "nunca";
		CmdProtectWindow1	= "explorar";
		CmdProtectWindow2	= "siempre";
		CmdScan	= "explorar";
		CmdShift	= "Shift";
		CmdToggle	= "invertir";
		CmdUpdatePrice	= "actualizaci�n-precio";
		CmdWarnColor	= "color-advertencia";
		ShowAverage	= "ver-promedio";
		ShowEmbedBlank	= "ver-integrado-lineavacia";
		ShowLink	= "ver-enlace";
		ShowMedian	= "ver-promedio";
		ShowRedo	= "ver-advertencia";
		ShowStats	= "ver-estad�sticas";
		ShowSuggest	= "ver-sugerencia";
		ShowVerbose	= "ver-literal";


		-- Section: Config Text
		GuiAlso	= "Tambi�n mostrar valores para";
		GuiAlsoDisplay	= "Mostrando informaci�n para %s";
		GuiAlsoOff	= "Dejar de mostrar informaci�n para otro(s) reino(s)-facci�n(es)";
		GuiAlsoOpposite	= "Mostrando informaci�n para la facci�n opuesta.";
		GuiAskPrice	= "Encender AskPrice";
		GuiAskPriceAd	= "Enviar anuncio";
		GuiAskPriceGuild	= "Responder a las peticiones del chat de hermandad";
		GuiAskPriceHeader	= "Opciones de AskPrice";
		GuiAskPriceHeaderHelp	= "Cambia el functionamiento de AskPrice";
		GuiAskPriceParty	= "Responder a las peticiones del chat de grupo";
		GuiAskPriceSmart	= "Usar palabras inteligentes";
		GuiAskPriceTrigger	= "Activador de AskPrice";
		GuiAskPriceVendor	= "Enviar informaci�n de Venta a Vendedores";
		GuiAskPriceWhispers	= "Ver susurros salientes";
		GuiAskPriceWord	= "Palabra inteligente particular %d";
		GuiAuctionDuration	= "Duraci�n por defecto de las subastas";
		GuiAuctionHouseHeader	= "Ventana de la Casa de Subastas";
		GuiAuctionHouseHeaderHelp	= "Modificar el comportamiento de la ventana de la Casa de Subastas";
		GuiAutofill	= "Autocompletar precios en la casa de subastas";
		GuiAverages	= "Mostrar Promedios";
		GuiBidmarkdown	= "Porcentaje de rebaja de la puja";
		GuiClearall	= "Eliminar toda la informaci�n";
		GuiClearallButton	= "Eliminar Todo";
		GuiClearallHelp	= "Clic aqu� para eliminar toda la informaci�n de Auctioneer para el servidor-reino actual.";
		GuiClearallNote	= "para el servidor-facci�n actual.";
		GuiClearHeader	= "Eliminar Informaci�n";
		GuiClearHelp	= "Elimina la informacion de Auctioneer. \nSelecciona si eliminar toda la informaci�n o solamente la im�gen actual.\nADVERTENCIA: Estas acciones NO son reversibles.";
		GuiClearsnap	= "Eliminar los datos de la imagen";
		GuiClearsnapButton	= "Eliminar Imagen";
		GuiClearsnapHelp	= "Clic aqu� para eliminar la �ltima imagen de informaci�n de Auctioneer.";
		GuiDefaultAll	= "Restaurar todas las opciones";
		GuiDefaultAllButton	= "Restaurar Todo";
		GuiDefaultAllHelp	= "Seleccione aqu� para restaurar todas las opciones de Auctioneer a sus configuraciones por defecto.\nADVERTENCIA: Esta acci�n NO es reversible.";
		GuiDefaultOption	= "Restaurar esta opci�n";
		GuiEmbed	= "Integrar informaci�n en la caja de ayuda";
		GuiEmbedBlankline	= "Mostrar linea en blanco en el tooltip.";
		GuiEmbedHeader	= "Integraci�n";
		GuiFinish	= "Despu�s de completar exploraci�n";
		GuiFinishSound	= "Reproducir sonido al completar exploraci�n";
		GuiLink	= "Ver n�mero de enlace";
		GuiLoad	= "Cargar Auctioneer";
		GuiLoad_Always	= "siempre";
		GuiLoad_AuctionHouse	= "en la Casa de Subastas";
		GuiLoad_Never	= "nunca";
		GuiLocale	= "Ajustar localizaci�n a";
		GuiMainEnable	= "Activar Auctioneer";
		GuiMainHelp	= "Contiene ajustes para Auctioneer \nun accesorio que muestra informaci�n sobre art�culos y analiza informaci�n de subastas. \nSeleccione \"Explorar\" en la casa de subastas para recopilar informaci�n sobre las subastas.";
		GuiMarkup	= "Porcentaje de margen sobre vendedor";
		GuiMaxless	= "Porcentaje m�ximo de rebaja de mercado";
		GuiMedian	= "Mostrar Promedios";
		GuiNocomp	= "Porcentaje de rebaja sin competencia.";
		GuiNoWorldMap	= "Auctioneer: no se mostrar� el mapa del mundo";
		GuiOtherHeader	= "Otras Opciones";
		GuiOtherHelp	= "Otras Opciones de Auctioneer";
		GuiPercentsHeader	= "L�mite de Porcentajes de Auctioneer";
		GuiPercentsHelp	= "ADVERTENCIA: Las siguientes opciones son para usuarios expertos SOLAMENTE.\nAjuste los siguientes valores para cambiar cuan agresivo es Auctioneer al determinar niveles provechosos.";
		GuiPrintin	= "Seleccione la ventana deseada";
		GuiProtectWindow	= "Prevenir el cierre accidental de la ventana de la Casa de Subastas";
		GuiRedo	= "Mostrar Advertencia de Exploraci�n Larga";
		GuiReloadui	= "Recargar Interfaz";
		GuiReloaduiButton	= "Recargar";
		GuiReloaduiFeedback	= "Recargando el Interfaz de WoW";
		GuiReloaduiHelp	= "Presione aqu� para recargar el interfaz de WoW tras haber seleccionado una localizaci�n diferente. Esto es para que el lenguaje de configuraci�n sea el mismo que el de Auctioneer.\nNota: Esta operaci�n puede llevar unos minutos.";
		GuiRememberText	= "Recordar precio";
		GuiStatsEnable	= "Ver estad�sticas";
		GuiStatsHeader	= "Estad�sticas de precios de art�culos";
		GuiStatsHelp	= "Mostrar las siguientes estad�sticas en la caja de ayuda.";
		GuiSuggest	= "Mostrar Precios Sugeridos";
		GuiUnderlow	= "Rebaja m�s baja de subasta";
		GuiUndermkt	= "Rebajar mercado cuando Sinm�ximo";
		GuiVerbose	= "Modo extendido";
		GuiWarnColor	= "Colorear Modelo de Valoraci�n";


		-- Section: Conversion Messages
		MesgConvert	= "Conversi�n de base de datos de Auctioneer. Por favor, haz primero una copia de seguridad de SavedVariables\\Auctioneer.lua.%s%s";
		MesgConvertNo	= "Desactivar Auctioneer";
		MesgConvertYes	= "Convertir";
		MesgNotconverting	= "Auctioneer no convertir� su base de datos, pero no funcionar� hasta que la base de datos sea convertida.";


		-- Section: Game Constants
		TimeLong	= "Largo";
		TimeMed	= "Medio";
		TimeShort	= "Corto";
		TimeVlong	= "Muy Largo";


		-- Section: Generic Messages
		ConfirmBidBuyout	= "Est�s seguro de que quieres %s\n%dx%s por:";
		DisableMsg	= "Desactivando la carga autom�tica de Auctioneer";
		FrmtWelcome	= "Auctioneer versi�n %s cargada";
		MesgNotLoaded	= "Auctioneer no est� cargado. Escriba /auctioneer para m�s informaci�n.";
		ScanCancel	= "Exploraci�n Cancelada";
		ScanComplete	= "Exploraci�n Completada";
		ScanFailed	= "Exploraci�n Fracasada";
		StatAskPriceOff	= "AskPrice ha sido desactivado";
		StatAskPriceOn	= "AskPrice ha sido activado";
		StatOff	= "Ocultando toda informaci�n de subastas";
		StatOn	= "Mostrando los datos de subasta configurados";
		UIScanCanceled	= "Auctioneer: La exploraci�n de las subastas se cancelo";
		UIScanComplete	= "Auctioneer: La exploraci�n de las subastas ha completado";
		UIScanFailed	= "Auctioneer: La exploraci�n de las subastas ha fallado";


		-- Section: Generic Strings
		TextAuction	= "Subasta";
		TextCombat	= "Combate";
		TextGeneral	= "General";
		TextNone	= "nada";
		TextScan	= "Explorar";
		TextUsage	= "Uso:";


		-- Section: Help Text
		HelpAlso	= "Mostrar tambi�n los valores de otros servidores en la caja de ayuda. Para el reino escribe el nombre del reino y para facci�n escribe el nombre de la facci�n. Por ejemplo: \"/auctioneer tambien Al'Akir-Horde\". La palabra clave \"opuesta\" significa facci�n opuesta, \"desactivar\" deshabilita la funcionalidad.";
		HelpAskPrice	= "Activa o desactiva AskPrice.";
		HelpAskPriceAd	= "Activa o desactiva el anuncio de AskPrice.";
		HelpAskPriceGuild	= "Responder a peticiones hechas en el chat de hermandad.";
		HelpAskPriceParty	= "Responder a peticiones hechas en el chat de grupo.";
		HelpAskPriceSend	= "Enviar manualmente a un jugador el resultado de una petici�n de AskPrice.";
		HelpAskPriceSmart	= "Activa o desactiva la comprobaci�n de palabras inteligentes.";
		HelpAskPriceTrigger	= "Cambiar el car�cter que activa AskPrice";
		HelpAskPriceVendor	= "Activa o desactiva el env�o de informaci�n del precio de vendedor.";
		HelpAskPriceWhispers	= "Activa o desactiva la ocultaci�n de todos los susurros salientes de AskPrice.";
		HelpAskPriceWord	= "A�ade o modifica las palabras inteligentes personalizadas de AskPrice.";
		HelpAuctionClick	= "Permite hacer Alt-Clic en un objeto en tu bolsa para subastarlo autom�ticamente.";
		HelpAuctionDuration	= "Establece la duraci�n por defecto de las subastas al abrir el interfaz de la Casa de Subastas";
		HelpAutofill	= "Auto-completar precios cuando se a�adan art�culos a subastar en el panel de la casa de subastas";
		HelpAverage	= "Determina si se muestra el precio medio de subasta de un objeto.";
		HelpBidbroker	= "Muestra subastas de corto o medio plazo de la exploraci�n m�s reciente en las que puedes pujar y obtener beneficios";
		HelpBidLimit	= "N�mero m�ximo de subastas a las que pujar o comprar cuando los botones de Pujar o Comprar son presionados en la pesta�a de Explorar Subastas.";
		HelpBroker	= "Muestra las subastas de la exploraci�n m�s reciente en las que puedes pujar y despu�s revender para obtener beneficios";
		HelpClear	= "Elimina la informacion especificada del art�culo (debes usar clic-may�sculas para insertar el/los articulo(s) en el comando) Tambi�n puedes especificar las palabras claves \"todo\" o \"imagen\"";
		HelpCompete	= "Muestra cualquier subasta explorada recientemente cuyo precio de compra es menor que alguno de tus art�culos";
		HelpDefault	= "Reajusta una opci�n de Auctioneer a su valor por defecto. Tambi�n puedes especificar la palabra clave \"todo\" para reajustar todas las opciones de Auctioneer a sus valores por defecto.";
		HelpDisable	= "Impide que Auctioneer se cargue autom�ticamente la pr�xima vez que te conectas";
		HelpEmbed	= "Inserta el texto en la caja de ayuda original del juego (nota: algunas caracter�sticas se desactivan cuando esta opci�n es seleccionada)";
		HelpEmbedBlank	= "Determina si se muestra una l�nea en blanco entre la informaci�n de la caja de ayuda y la informaci�n de subasta cuando el modo integrado est� seleccionado";
		HelpFinish	= "Determina si el juego se desconecta o finaliza tras terminar una exploraci�n de la casa de subastas";
		HelpFinishSound	= "Determina si se reproduce un sonido al finalizar una exploraci�n de la casa de subastas";
		HelpLink	= "Selecciona para mostrar el n�mero de enlace del art�culo en la caja de ayuda";
		HelpLoad	= "Cambia las opciones de carga de Auctioneer para este personaje";
		HelpLocale	= "Cambia la localizaci�n a utilizar para mostrar los mensajes de Auctioneer";
		HelpMedian	= "Determina si se muestra el precio promedio de compra del art�culo";
		HelpOnoff	= "Activa y desactiva la informaci�n sobre las subastas";
		HelpPctBidmarkdown	= "Determina el porcentaje en el que Auctioneer rebajar� las pujas del precio de compra";
		HelpPctMarkup	= "El porcentaje que ser� incrementado el precio del vendedor cuando no existan otros valores disponibles.";
		HelpPctMaxless	= "Establece el porcentaje m�ximo que Auctioneer usar� para rebajar el precio de mercado antes de rendirse";
		HelpPctNocomp	= "El porcentaje que Auctioneer rebajar� sobre el precio de mercado cuando no hay competencia";
		HelpPctUnderlow	= "Establece el porcentaje que Auctioneer rebajar� el precio de subasta m�s bajo";
		HelpPctUndermkt	= "Porcentaje a rebajar sobre el precio de mercado cuando sea imposible vencer a la competencia (debido a sinm�ximo)";
		HelpPercentless	= "Muestra cualquier subasta recientemente explorada en la que el precio de compra es un porcentaje menor que el precio de venta m�s alto.";
		HelpPrintin	= "Selecciona qu� ventana va a usar Auctioneer para imprimir su informaci�n. Puedes especificar tanto el nombre como el �ndice de la ventana.";
		HelpProtectWindow	= "Previene que cierres accidentalmente el interfaz de la Casa de Subastas";
		HelpRedo	= "Determina si se muestra un aviso cuando la p�gina de la Casa de Subastas actualmente explorada ha llevado demasiado tiempo de exploraci�n debido al lag del servidor.";
		HelpScan	= "Realiza una exploraci�n de la casa de subastas en la pr�xima visita, o mientras est�s all� (tambien existe un bot�n en el panel de subastas). Selecciona qu� categor�as quieres explorar  activando las casillas correspondientes.";
		HelpStats	= "Determina si se muestran los porcentajes de pujas/compras del art�culo";
		HelpSuggest	= "Determina si se muestra el precio de subasta sugerido para el art�culo";
		HelpUpdatePrice	= "Actualiza autom�ticamente el precio de salida de una subasta en la pesta�a Publicar Subastas cuando el precio de compra cambia.";
		HelpVerbose	= "Determina si se muestran los promedios y sugerencias en formato extendido (o en una sola l�nea si es desactivado)";
		HelpWarnColor	= "Determina si se muestra el modelo de precio actual de la casa de subastas (Rebajando un...) en colores intuitivos.";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "�No se encontr� espacio en tu inventario para crear la subasta!";
		FrmtNotEnoughOfItem	= "�No se encontr� suficiente %s para crear la subasta!";
		FrmtPostedAuction	= "Se cre� una subasta de %s (x%d)";
		FrmtPostedAuctions	= "Se crearon %d subastas de %s (x%d)";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "OfertaActual";
		FrmtBidbrokerDone	= "Corredor de pujas finalizado";
		FrmtBidbrokerHeader	= "Beneficio M�nimo: %s, PMV = 'Precio M�ximo de Venta'";
		FrmtBidbrokerLine	= "%s, �ltimo(s) %s visto(s), PMV: %s, %s: %s, Benef: %s, Tiempo: %s";
		FrmtBidbrokerMinbid	= "pujaM�nima";
		FrmtBrokerDone	= "Corredor finalizado";
		FrmtBrokerHeader	= "Beneficio M�nimo: %s, PMV = 'Precio Maximo de Venta'";
		FrmtBrokerLine	= "%s, �ltimo(s) %s visto(s), PMV: %s, C: %s, Benef: %s";
		FrmtCompeteDone	= "Subastas compitiendo finalizado.";
		FrmtCompeteHeader	= "Subastas compitiendo por al menos %s debajo por art�culo.";
		FrmtCompeteLine	= "%s, Puja: %s, C %s contra %s, %s menos";
		FrmtHspLine	= "El Precio M�ximo de Venta para un %s es: %s";
		FrmtLowLine	= "%s, C: %s, Vendedor: %s, Por uno: %s, Menor al promedio: %s";
		FrmtMedianLine	= "De los �ltimos(s) %d vistos, el precio medio de compra para 1 %s es: %s";
		FrmtNoauct	= "No se hallaron subastas para el art�culo: %s";
		FrmtPctlessDone	= "Porcentajes menores finalizado.";
		FrmtPctlessHeader	= "Porcentaje bajo el Precio Maximo de Venta (PMV): %d%%";
		FrmtPctlessLine	= "%s, �ltimo(s) %d visto(s), PMV: %s, C: %s, Benef: %s, menos %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "Subastas terminadas eliminadas: %s";
		AuctionDiscrepancies	= "Discrepancias: %s";
		AuctionNewAucts	= "Nuevas subastas exploradas: %s";
		AuctionOldAucts	= "Subastas exploradas previamente: %s";
		AuctionPageN	= "Auctioneer: Explorando \"%s\" p�gina %d de %d\nSubastas por segundo: %s\nTiempo estimado para completar: %s";
		AuctionScanDone	= "Auctioneer: La exploraci�n de las subastas ha finalizado";
		AuctionScanNexttime	= "Auctioneer realizar� una exploraci�n completa de las subastas la pr�xima vez que hables con un subastador.";
		AuctionScanNocat	= "Debes tener al menos una categor�a seleccionada para poder explorar.";
		AuctionScanRedo	= "La p�gina actual ha llevado m�s de %d segundos para ser completada. Reintentando la p�gina.";
		AuctionScanStart	= "Auctioneer: Explorando \"%s\" p�gina 1...";
		AuctionTotalAucts	= "Total de subastas exploradas: %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "Visto %d veces en %s";
		FrmtInfoAverage	= "%s min/%s C (%s puja)";
		FrmtInfoBidMulti	= "Pujas (%s%s c/u)";
		FrmtInfoBidOne	= " %s con pujas";
		FrmtInfoBidrate	= "%d%% tienen pujas, %d%% tienen precio de compra";
		FrmtInfoBuymedian	= "Promedio de precio de compra";
		FrmtInfoBuyMulti	= "  Compra (%s%s c/u)";
		FrmtInfoBuyOne	= " %s con opci�n a compra";
		FrmtInfoForone	= "Por 1: %s min/%s OC (%s puja) [en %d's]";
		FrmtInfoHeadMulti	= "Promedios para %d art�culos:";
		FrmtInfoHeadOne	= "Promedios para este art�culo:";
		FrmtInfoHistmed	= "�ltimo(s) %d, promedio de precio de compra (c/u)";
		FrmtInfoMinMulti	= "  Puja inicial (%s c/u)";
		FrmtInfoMinOne	= "  Puja inicial";
		FrmtInfoNever	= "Nunca visto en %s";
		FrmtInfoSeen	= "Visto un total de %d veces en subasta";
		FrmtInfoSgst	= "Precio sugerido: %s min/%s compra";
		FrmtInfoSgststx	= "Precio sugerido para su lote de %d: %s min/%s compra";
		FrmtInfoSnapmed	= "Explorados %d, promedio de precio de compra (c/u)";
		FrmtInfoStacksize	= "Tama�o promedio del paquete: %d artículos";


		-- Section: User Interface
		BuySortTooltip	= "Muestra la p�gina de resultados por precio de compra (mant�n pulsado MAY�SCULAS para ordenarlos por nombre de art�culo)";
		ClearTooltip	= "Limpia cualquier par�metro personalizado de los campos de b�squeda.";
		FrmtLastSoldOn	= "�ltima venta en %s";
		RefreshTooltip	= "Realizar de nuevo la b�squeda en el n�mero de p�gina actual.";
		UiBid	= "Puja";
		UiBidHeader	= "Pujas";
		UiBidPerHeader	= "Puja c/u";
		UiBuyout	= "Comprar";
		UiBuyoutHeader	= "Comprar";
		UiBuyoutPerHeader	= "Comprar c/u";
		UiBuyoutPriceLabel	= "Precio de Compra:";
		UiBuyoutPriceTooLowError	= "(Demasiado Bajo)";
		UiCategoryLabel	= "Restricci�n de Categor�a:";
		UiDepositLabel	= "Dep�sito:";
		UiDurationLabel	= "Duraci�n:";
		UiItemLevelHeader	= "Nivel";
		UiMakeFixedPriceLabel	= "Hacer precio fijo";
		UiMaxError	= "(%d Max)";
		UiMaximumPriceLabel	= "Precio M�ximo:";
		UiMaximumTimeLeftLabel	= "Tiempo Restante M�ximo:";
		UiMinimumPercentLessLabel	= "Porcentaje Menos M�nimo:";
		UiMinimumProfitLabel	= "Ganancia M�nima";
		UiMinimumQualityLabel	= "Calidad M�nima:";
		UiMinimumUndercutLabel	= "Rebaja M�nima:";
		UiNameHeader	= "Nombre";
		UiNoPendingBids	= "�Todas las peticiones de puja completadas!";
		UiNotEnoughError	= "(No Hay Suficiente)";
		UiPendingBidInProgress	= "1 petici�n de puja en marcha...";
		UiPendingBidsInProgress	= "%d peticiones de puja en marcha...";
		UiPercentLessHeader	= "Porcentaje";
		UiPost	= "Publicar";
		UiPostAuctions	= "Publicar Subastas";
		UiPriceBasedOnLabel	= "Precio Basado En:";
		UiPriceModelAuctioneer	= "Precio de Auctioneer";
		UiPriceModelCustom	= "Precio Personalizado";
		UiPriceModelFixed	= "Precio Fijo";
		UiPriceModelLastSold	= "�ltimo Precio Vendido";
		UiProfitHeader	= "Beneficio";
		UiProfitPerHeader	= "Beneficio c/u";
		UiQuantityHeader	= "Cantidad";
		UiQuantityLabel	= "Cantidad:";
		UiRemoveSearchButton	= "Borrar";
		UiSavedSearchLabel	= "B�squedas guardadas:";
		UiSaveSearchButton	= "Guardar";
		UiSaveSearchLabel	= "Guardar esta b�squeda";
		UiSearch	= "Buscar";
		UiSearchAuctions	= "Explorar Subastas";
		UiSearchDropDownLabel	= "Buscar:";
		UiSearchForLabel	= "Buscar por art�culo:";
		UiSearchTypeBids	= "Pujas";
		UiSearchTypeBuyouts	= "Compras";
		UiSearchTypeCompetition	= "Competencia";
		UiSearchTypePlain	= "Art�culo";
		UiStacksLabel	= "Lotes";
		UiStackTooBigError	= "(Lote Demasiado Grande)";
		UiStackTooSmallError	= "(Lote Demasiado Peque�o)";
		UiStartingPriceLabel	= "Precio Inicial:";
		UiStartingPriceRequiredError	= "(Requerido)";
		UiTimeLeftHeader	= "Tiempo restante";
		UiUnknownError	= "(Desconocido)";

	};

	frFR = {


		-- Section: AskPrice Messages
		AskPriceAd	= "Prix de la pile pour %sx[LienItem] (x=quantit�)";
		FrmtAskPriceBuyoutMedianHistorical	= "%sAchat imm�diat - historique m�dian: %s%s";
		FrmtAskPriceBuyoutMedianSnapshot	= "%sAchat imm�diat - m�dian dernier scan: %s%s";
		FrmtAskPriceDisable	= "D�sactiver l'option Demande Prix %s";
		FrmtAskPriceEach	= "(%s chaque)";
		FrmtAskPriceEnable	= "Activer l'option Demande Prix %s";
		FrmtAskPriceVendorPrice	= "%sVente au marchand pour : %s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "Suppression de %s de l'image de l'HV.";
		FrmtAuctinfoHist	= "%d historique";
		FrmtAuctinfoLow	= "Prix le plus bas";
		FrmtAuctinfoMktprice	= "Prix du march�";
		FrmtAuctinfoNolow	= "Objet non d�tect� � la derni�re analyse";
		FrmtAuctinfoOrig	= "Prix de d�part";
		FrmtAuctinfoSnap	= "%d � la derni�re analyse";
		FrmtAuctinfoSugbid	= "Mise � prix";
		FrmtAuctinfoSugbuy	= "AI sugg�r�";
		FrmtWarnAbovemkt	= "Concurrence au-dessus du march�";
		FrmtWarnMarkup	= "Prix marchand + %s%%";
		FrmtWarnMyprice	= "Utiliser mon prix actuel";
		FrmtWarnNocomp	= "Aucune concurrence";
		FrmtWarnNodata	= "Prix de vente maximum inconnu";
		FrmtWarnToolow	= "Plus bas prix pratiquable";
		FrmtWarnUndercut	= "Moins cher de %s%%";
		FrmtWarnUser	= "Prix d�fini par l'utilisateur";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "D�j� le plus haut ench�risseur sur l'ench�re : %s (x%d)";
		FrmtBidAuction	= "Offre sur l'ench�re : %s (x%d)";
		FrmtBidQueueOutOfSync	= "Erreur : File d'ench�re d�synchronis�e";
		FrmtBoughtAuction	= "Achat direct : %s (x%d)";
		FrmtMaxBidsReached	= "D'autres ench�res de %s (x%d) trouv�es, mais nombre limite d'ench�res atteint (%d)";
		FrmtNoAuctionsFound	= "Aucune ench�re trouv�e : %s (x%d)";
		FrmtNoMoreAuctionsFound	= "Plus d'autres ench�res trouv�es : %s (x%d)";
		FrmtNotEnoughMoney	= "Pas assez d'argent pour l'ench�re : %s (x%d)";
		FrmtSkippedAuctionWithHigherBid	= "Ignore ench�res avec une offre plus �lev�e : %s (x%d)";
		FrmtSkippedAuctionWithLowerBid	= "Ignore ench�res avec l'offre inf�rieure : %s (x%d)";
		FrmtSkippedBiddingOnOwnAuction	= "Ignore mes propres ench�res : %s (x%d)";
		UiProcessingBidRequests	= "Traitement des ench�res...";


		-- Section: Command Messages
		ConstantsCritical	= "CRITIQUE: Le fichier SavedVariables d'Auctioneer est %.3f%% plein";
		ConstantsMessage	= "Le fichier SavedVariables d'Auctioneer est %.3f%% plein";
		ConstantsWarning	= "ATTENTION: Le fichier SavedVariables d'Auctioneer est %.3f%% plein";
		FrmtActClearall	= "Effacer toutes les donn�es pour l'ench�re %s";
		FrmtActClearFail	= "Objet introuvable : %s";
		FrmtActClearOk	= "Effacer les infos de l'objet : %s";
		FrmtActClearsnap	= "Effacement de l'image actuelle de l'H�tel des Ventes";
		FrmtActDefault	= "R�initialisation de l'option %s � sa valeur par d�faut";
		FrmtActDefaultall	= "Toutes les options d'Auctioneer ont �t� r�initialis�es � leur valeur par d�faut";
		FrmtActDisable	= "Les donn�es de %s ne sont pas affich�es";
		FrmtActEnable	= "Les donn�es de %s sont affich�es";
		FrmtActSet	= "Valeur de %s chang�e en %s";
		FrmtActUnknown	= "Commande inconnue : %s";
		FrmtAuctionDuration	= "La dur�e par d�faut des ench�res est d�sormais de %s";
		FrmtAutostart	= "Ench�re automatique pour %s: mise � prix %s, achat imm�diat %s (%dh) %s";
		FrmtFinish	= "Apr�s la fin d'un scan, nous allons %s \n";
		FrmtPrintin	= "Les messages d'Auctioneer s'afficheront d�sormais dans la fen�tre de dialogue \"%s\"";
		FrmtProtectWindow	= "Protection de la fen�tre de l'H�tel des Ventes : \"%s\"";
		FrmtUnknownArg	= "'%s' : argument invalide pour '%s'";
		FrmtUnknownLocale	= "La langue que vous avez sp�cifi�e ('%s') est inconnue. Les langues valides sont :";
		FrmtUnknownRf	= "'%s' n'est pas un param�tre valide, doit �tre au format [Royaume]-[Faction] ! Ex : Medhiv-Alliance";


		-- Section: Command Options
		OptAlso	= "(royaume-faction|oppose|allie|neutre)";
		OptAuctionDuration	= "(court|2h|8h|24h)";
		OptBidbroker	= "<gain_argent>";
		OptBidLimit	= "<nombre>";
		OptBroker	= "<gain_argent>";
		OptClear	= "([Objet]|tout|capture)";
		OptCompete	= "<argent_moins>";
		OptDefault	= "(<option>|tout)";
		OptFinish	= "(arret|deconnecter|quitter|rechargeIU)";
		OptLocale	= "<langue>";
		OptPctBidmarkdown	= "<pourcentage>";
		OptPctMarkup	= "<pourcentage>";
		OptPctMaxless	= "<pourcentage>";
		OptPctNocomp	= "<pourcentage>";
		OptPctUnderlow	= "<pourcentage>";
		OptPctUndermkt	= "<pourcentage>";
		OptPercentless	= "<pourcentage>";
		OptPrintin	= "(<IndexFenetre>[Nombre]|<NomFenetre>[Chaine])";
		OptProtectWindow	= "(jamais|analyse|toujours)";
		OptScale	= "<facteur_�chelle>";
		OptScan	= "<parametre_d_analyse>";


		-- Section: Commands
		CmdAlso	= "aussi";
		CmdAlsoOpposite	= "oppose";
		CmdAlt	= "alt";
		CmdAskPriceAd	= "annonce";
		CmdAskPriceGuild	= "guilde";
		CmdAskPriceParty	= "groupe";
		CmdAskPriceSmart	= "intelligent";
		CmdAskPriceSmartWord1	= "que";
		CmdAskPriceSmartWord2	= "vaut";
		CmdAskPriceTrigger	= "declencheur";
		CmdAskPriceVendor	= "vendeur";
		CmdAskPriceWhispers	= "chuchotements";
		CmdAskPriceWord	= "mot-cle";
		CmdAuctionClick	= "enchere-clic";
		CmdAuctionDuration	= "duree-enchere";
		CmdAuctionDuration0	= "dernier";
		CmdAuctionDuration1	= "2h";
		CmdAuctionDuration2	= "8h";
		CmdAuctionDuration3	= "24h";
		CmdAutofill	= "remplissage-auto";
		CmdBidbroker	= "agent-enchere";
		CmdBidbrokerShort	= "ae";
		CmdBidLimit	= "limite-offre";
		CmdBroker	= "agent";
		CmdClear	= "effacer";
		CmdClearAll	= "tout";
		CmdClearSnapshot	= "capture";
		CmdCompete	= "concurrence";
		CmdCtrl	= "ctrl";
		CmdDefault	= "defaut";
		CmdDisable	= "desactiver";
		CmdEmbed	= "integrer";
		CmdFinish	= "fin";
		CmdFinish0	= "arret";
		CmdFinish1	= "deconnection";
		CmdFinish2	= "quitter";
		CmdFinish3	= "rechargeIU";
		CmdFinishSound	= "son-final";
		CmdHelp	= "aide";
		CmdLocale	= "langue";
		CmdOff	= "arret";
		CmdOn	= "marche";
		CmdPctBidmarkdown	= "pct-baisse";
		CmdPctMarkup	= "pct-hausse";
		CmdPctMaxless	= "pct-baissemaxi";
		CmdPctNocomp	= "pct-pasdeconcurrence";
		CmdPctUnderlow	= "pct-sousbas";
		CmdPctUndermkt	= "pct-sousmarche";
		CmdPercentless	= "pct-moins";
		CmdPercentlessShort	= "pm";
		CmdPrintin	= "afficher-dans";
		CmdProtectWindow	= "proteger-fenetre";
		CmdProtectWindow0	= "jamais";
		CmdProtectWindow1	= "analyse";
		CmdProtectWindow2	= "toujours";
		CmdScan	= "analyse";
		CmdShift	= "shift";
		CmdToggle	= "active-desactive";
		CmdUpdatePrice	= "actualiser-prix";
		CmdWarnColor	= "couleur-avertissement";
		ShowAverage	= "voir-moyenne";
		ShowEmbedBlank	= "voir-ligneblanche-integree";
		ShowLink	= "voir-lien";
		ShowMedian	= "voir-median";
		ShowRedo	= "voir-avertissement";
		ShowStats	= "voir-stats";
		ShowSuggest	= "voir-suggestion";
		ShowVerbose	= "voir-detail";


		-- Section: Config Text
		GuiAlso	= "Afficher aussi les donn�es pour";
		GuiAlsoDisplay	= "Affichage des donn�es pour %s";
		GuiAlsoOff	= "Ne plus afficher les donn�es provenant d'autres royaumes/factions.";
		GuiAlsoOpposite	= "Afficher maintenant les donn�es de la faction oppos�e.";
		GuiAskPrice	= "Activer DemandePrix";
		GuiAskPriceAd	= "Envoyer les dispositifs d'annonce";
		GuiAskPriceGuild	= "R�pondre aux demandes sur le canal de guilde";
		GuiAskPriceHeader	= "Options de DemandePrix";
		GuiAskPriceHeaderHelp	= "Changer le comportement de DemandePrix";
		GuiAskPriceParty	= "R�pondre aux requ�tes sur le canal de groupe";
		GuiAskPriceSmart	= "Utiliser mots-cl�s intelligents";
		GuiAskPriceTrigger	= "Activateur de DemandePrix";
		GuiAskPriceVendor	= "Envoyer les info du vendeur";
		GuiAskPriceWhispers	= "Montrer chuchotements envoy�s";
		GuiAskPriceWord	= "Mot-cl� intelligent personnalis� %d";
		GuiAuctionDuration	= "Dur�e de l'ench�re par d�faut";
		GuiAuctionHouseHeader	= "Fen�tre de l'H�tel des Ventes";
		GuiAuctionHouseHeaderHelp	= "Change le comportement de la fen�tre de l'H�tel des Ventes";
		GuiAutofill	= "Remplit automatiquement les prix � l'HV";
		GuiAverages	= "Voir moyennes";
		GuiBidmarkdown	= "Pourcentage de baisse d'ench�re";
		GuiClearall	= "Effacer toutes les donn�es d'Auctioneer";
		GuiClearallButton	= "Tout effacer";
		GuiClearallHelp	= "Cliquer ici pour effacer toutes les donn�es d'Auctioneer pour le royaume actuel.";
		GuiClearallNote	= "pour la faction courante du serveur";
		GuiClearHeader	= "Effacer les donn�es";
		GuiClearHelp	= "Effacement des donn�es d'Auctioneer. S�lectionnez toutes les donn�es ou l'image courante. ATTENTION : Ces op�rations sont irreversibles.";
		GuiClearsnap	= "Effacer les donn�es de l'image";
		GuiClearsnapButton	= "Effacer l'image";
		GuiClearsnapHelp	= "Cliquer ici pour effacer les donn�es de la derni�re image d'Auctioneer";
		GuiDefaultAll	= "R�initialisation de toutes les options d'Auctioneer";
		GuiDefaultAllButton	= "R�initialiser tout";
		GuiDefaultAllHelp	= "Cliquer ici pour r�initialiser toutes les options d'Auctioneer. ATTENTION : Cette op�ration est irr�versible.";
		GuiDefaultOption	= "R�initialiser ce param�tre";
		GuiEmbed	= "Int�grer les informations dans la bulle d'aide originale";
		GuiEmbedBlankline	= "Afficher une ligne blanche dans la bulle d'aide";
		GuiEmbedHeader	= "Int�grer";
		GuiFinish	= "Apr�s la fin d'une analyse";
		GuiFinishSound	= "Jouer un son � la fin d'une analyse";
		GuiLink	= "Montrer ID du Lien";
		GuiLoad	= "Charger Auctioneer";
		GuiLoad_Always	= "toujours";
		GuiLoad_AuctionHouse	= "� l'H�tel des Ventes";
		GuiLoad_Never	= "jamais";
		GuiLocale	= "Changer la langue en";
		GuiMainEnable	= "Activer Auctioneer";
		GuiMainHelp	= "Contient les r�glages d'Auctionner, un AddOn affichant les infos des objets et analyse les donn�es de vente aux ench�res. Cliquez le bouton \"Analyse\" de l'H�tel des Ventes pour r�cup�rer les donn�es.";
		GuiMarkup	= "Pourcentage de hausse du prix des vendeurs PNJ";
		GuiMaxless	= "Pourcentage maximal de remise par rapport au march�";
		GuiMedian	= "Voir prix m�dians";
		GuiNocomp	= "Pourcentage de remise en cas de monopole";
		GuiNoWorldMap	= "Auctioneer : affichage de la carte du monde bloqu�e";
		GuiOtherHeader	= "Autres Options";
		GuiOtherHelp	= "Options diverses d'Auctioneer";
		GuiPercentsHeader	= "Pourcentage de tol�rance d'Auctioneer";
		GuiPercentsHelp	= "ATTENTION: Les options suivantes sont pour les utilisateurs exp�riment�s SEULEMENT. La Modification de ces valeurs change l'aggressivit� d'Auctioneer sur le niveau de marge n�cessaire pour la profitabilit�.";
		GuiPrintin	= "S�lectionner la fen�tre de discussion voulue";
		GuiProtectWindow	= "Emp�che la fermeture accidentelle de la fen�tre de l'HV";
		GuiRedo	= "Afficher l'avertissement d'analyse trop longue";
		GuiReloadui	= "Recharger l'interface utilisateur";
		GuiReloaduiButton	= "RechargerUI";
		GuiReloaduiFeedback	= "Red�marrage de l'UI de WoW";
		GuiReloaduiHelp	= "Cliquer ici pour recharger l'Interface Utilisateur (UI) de WoW apr�s avoir chang� la langue afin de prendre en compte les changements dans cet �cran de configuration. Remarque : cette op�ration peut prendre quelques minutes.";
		GuiRememberText	= "M�moriser le prix";
		GuiStatsEnable	= "Voir Statistiques";
		GuiStatsHeader	= "Statistiques du Prix de l'Objet";
		GuiStatsHelp	= "Afficher les statistiques suivantes dans la bulle d'aide";
		GuiSuggest	= "Voir les Prix Sugg�r�s";
		GuiUnderlow	= "R�duire le prix de l'ench�re la plus basse";
		GuiUndermkt	= "En dessous du march� si inf�rieur";
		GuiVerbose	= "Mode d�taill�";
		GuiWarnColor	= "Couleur du mod�le de prix";


		-- Section: Conversion Messages
		MesgConvert	= "Conversion de la base de donn�es d'Auctioneer. Veuillez sauvegarder votre fichier SavedVariables\\Auctioneer.lua avant. %s%s";
		MesgConvertNo	= "D�sactiver Auctioneer";
		MesgConvertYes	= "Convertir";
		MesgNotconverting	= "Auctioneer ne convertit pas votre base de donn�es, mais ne fonctionnera pas tant que vous ne l'aurez pas fait.";


		-- Section: Game Constants
		TimeLong	= "Longue";
		TimeMed	= "Moyenne";
		TimeShort	= "Courte";
		TimeVlong	= "Tr�s Longue";


		-- Section: Generic Messages
		ConfirmBidBuyout	= "Etes-vous s�r que vous voulez %s\n%dx%s pour:";
		DisableMsg	= "D�sactiver le chargement automatique d'Auctioneer";
		FrmtWelcome	= "Auctioneer v%s est charg�";
		MesgNotLoaded	= "Auctioneer n'est pas charg�. Tapez /auctioneer pour plus d'informations.";
		StatAskPriceOff	= "La fonction DemandePrix est d�sormais d�sactiv�e.";
		StatAskPriceOn	= "La fonction DemandePrix est d�sormais activ�e.";
		StatOff	= "Aucune ench�re � afficher";
		StatOn	= "Afficher la configuration des ench�res";


		-- Section: Generic Strings
		TextAuction	= "Ench�re";
		TextCombat	= "Combat";
		TextGeneral	= "G�n�ral";
		TextNone	= "Aucun";
		TextScan	= "Analyser";
		TextUsage	= "Utilisation :";


		-- Section: Help Text
		HelpAlso	= "Afficher �galement les donn�es d'un autre serveur dans la bulle d'aide. Pour le royaume, ins�rer le nom du royaume et pour la faction, le nom de la faction. Par exemple : \"/auctioneer additionnel Medhiv-Horde\". Le mot-clef \"oppos�\" indique la faction oppos�e, \"arr�t\" d�sactive cette fonctionnalit�.";
		HelpAskPrice	= "Activer ou d�sactiver DemandePrix.";
		HelpAskPriceAd	= "Activer ou d�sactiver la nouvelle fonction d'annonce DemandePrix.";
		HelpAskPriceGuild	= "R�pondre aux demandes faites dans le canal de guilde.";
		HelpAskPriceParty	= "R�pondre aux demandes faites dans le canal de groupe.";
		HelpAskPriceSmart	= "Activer ou d�sactiver la v�rification de MotCl�";
		HelpAskPriceTrigger	= "Changer la clef d'amorcage de DemandePrix.";
		HelpAskPriceVendor	= "Activer ou d�sactiver l'envoie des infos de prix au marchand";
		HelpAskPriceWhispers	= "Cacher ou non les chuchotements envoy�s par DemandePrix\n";
		HelpAskPriceWord	= "Ajouter ou modifier un mot-cl� intelligent personnalis� de DemandePrix.";
		HelpAuctionClick	= "ALT-Clic d'un objet de votre sac pour le placer automatiquement aux ench�res";
		HelpAuctionDuration	= "D�finit la dur�e d'ench�re par d�faut lors de l'ouverture de la fen�tre de l'H�tel de Ventes";
		HelpAutofill	= "Active le remplissage automatique du prix de vente lors de la mise aux ench�res d'un objet dans la fen�tre de l'H�tel des Ventes";
		HelpAverage	= "Choisir d'afficher le prix moyen d'ench�re des objets";
		HelpBidbroker	= "Afficher les ench�res � court ou moyen terme de l'analyse la plus r�cente sur lesquelles ench�rir pour revendre avec b�n�fice";
		HelpBidLimit	= "Nombre maximum d'ench�res sur lesquelless ench�rir ou acheter imm�diatement lorsque le bouton Ench�rir ou Acheter est s�lectionn� dans l'onglet Recherche Ench�res";
		HelpBroker	= "Montrer toutes les ench�res de l'analyse la plus r�cente sur lesquelles ench�rir pour revendre avec b�n�fice";
		HelpClear	= "Effacer les donn�es d'un objet sp�cifi� (vous devez 'SHIFT-cliquer' l'objet dans la ligne de commande) Vous pouvez �galement sp�cifier les mots-cl�s \"tout\" ou \"capture\"";
		HelpCompete	= "Montrer parmi les ench�res r�cemment scann�es celles dont le prix d'achat imm�diat est inf�rieur � celui d'un de vos objets.";
		HelpDefault	= "R�initialise une option d'Auctionner � sa valeur par d�faut. Vous pouvez �galement sp�cifier le mot-cl� \"tout\" pour r�initialiser toutes les options d'Autionneer � leurs valeurs par d�faut.";
		HelpDisable	= "Emp�che le chargement automatique d'Auctioneer lors de votre prochaine connexion";
		HelpEmbed	= "Int�gre le texte dans les bulles d'aide originale (remarque: certaines fonctions seront d�sactiv�es)";
		HelpEmbedBlank	= "Choisir d'afficher une ligne vide entre les infos de bulle d'aide et d'ench�re en mode int�gr�";
		HelpFinish	= "Se d�connecter ou sortir du jeu apr�s avoir fini un scan de l'H�tel des ventes";
		HelpFinishSound	= "D�termine si il faut jouer un son � la fin d'une analyse de l'H�tel des ventes";
		HelpLink	= "Choisir d'afficher l'identifiant du lien dans la bulle d'aide";
		HelpLoad	= "Change les r�glages de chargement pour ce personnage";
		HelpLocale	= "Choisir la langue dans laquelle afficher les messages d'Auctioneer";
		HelpMedian	= "Choisir d'afficher le prix d'achat imm�diat moyen";
		HelpOnoff	= "Active ou d�sactive l'affichage des donn�es des ench�res";
		HelpPctBidmarkdown	= "D�finit le pourcentage de r�duction par rapport au prix d'achat imm�diat utilis� par Auctioneer";
		HelpPctMarkup	= "Pourcentage � utiliser par rapport au prix des marchands quand aucune autre donn�e n'est disponible";
		HelpPctMaxless	= "D�finit la r�duction maximale en pourcentage qu'Auctionner utilisera par rapport au prix du march� avant d'abandonner";
		HelpPctNocomp	= "Pourcentage qu'Auctionner doit utiliser pour g�n�rer  une r�duction par rapport au prix du march� quand il n'y a pas de concurrence";
		HelpPctUnderlow	= "D�finit le pourcentage de r�duction par rapport au prix le plus bas de l'H�tel des ventes qu'Auctionner doit utiliser ";
		HelpPctUndermkt	= "Pourcentage de r�duction par rapport au prix du march� quand la concurrence ne peut �tre battue (� cause du maxbas)";
		HelpPercentless	= "Afficher parmi les ench�res r�cemment scann�es celles dont le prix d'achat imm�diat est inf�rieur d'un certain pourcentage au prix de vente maximum";
		HelpPrintin	= "Choisir quelle fen�tre affichera les messages d'Auctioneer. Vous pouvez sp�cifier le nom de la fen�tre ou son indice.";
		HelpProtectWindow	= "Emp�che la fermeture accidentelle de la fen�tre de l'H�tel des Ventes";
		HelpRedo	= "Choisir d'afficher un avertissement lorsque l'analyse de la page actuelle de l'H�tel des Ventes prend trop longtemps en raison d'une latence du serveur.";
		HelpScan	= "Ex�cute une analyse de l'H�tel des ventes lors de votre prochaine visite, ou imm�diatement si vous y �tes (il y a �galement un bouton dans l'interface de l'H�tel des ventes). Choisissez les cat�gories que vous souhaitez analyser avec les cases � cocher.";
		HelpStats	= "Choisir d'afficher les pourcentages d'ench�re/achat imm�diat";
		HelpSuggest	= "Choisir d'afficher le prix sugg�r� pour l'objet";
		HelpUpdatePrice	= "Dans l'onglet 'Ventes avanc�es', mettre � jour automatiquement le prix de d�part quand le prix d'achat directe change.";
		HelpVerbose	= "Choisir d'afficher les moyennes et les suggestions de mani�re d�taill�e (ou \"arr�t\" pour les afficher sur une seule ligne)";
		HelpWarnColor	= "Choisir de montrer le mod�le de prix de l'HV courant (en dessous du march�, ...) avec des couleurs intuitives.";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "Aucun emplacement vide n'a �t� trouv� pour cr�er l'ench�re !";
		FrmtNotEnoughOfItem	= "Pas assez de %s trouv� pour cr�er l'ench�re !";
		FrmtPostedAuction	= "Cr�� 1 ench�re de %s (x%d)";
		FrmtPostedAuctions	= "Cr�� %d ench�res de %s (x%d)";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "EnchAct";
		FrmtBidbrokerDone	= "L'agent d'ench�re � termin�";
		FrmtBidbrokerHeader	= "Gain minimum : %s, PVM = 'Prix de Vente Maximum'";
		FrmtBidbrokerLine	= "%s, Derniers %s vus, PVM : %s, %s : %s, Gain : %s, Temps : %s";
		FrmtBidbrokerMinbid	= "EnchMin";
		FrmtBrokerDone	= "L'agent a termin�";
		FrmtBrokerHeader	= "Gain Minimum : %s, PVM = 'Prix de Vente Maximum'";
		FrmtBrokerLine	= "%s, Derniers %s vus, PVM : %s, AI : %s, Gain : %s";
		FrmtCompeteDone	= "Ench�res en concurrence termin�es.";
		FrmtCompeteHeader	= "Ench�res en concurrence d'au moins %s de moins par objet.";
		FrmtCompeteLine	= "%s, Ench : %s, AI %s vs %s, %s de moins";
		FrmtHspLine	= "Le prix de vente maximum pour un %s est de : %s";
		FrmtLowLine	= "%s, AI : %s, Vendeur : %s, L'unit�e : %s, Inf�rieur au m�dian de : %s";
		FrmtMedianLine	= "Des derniers %d vus, l'achat moyen pour 1 %s est de : %s";
		FrmtNoauct	= "Pas d'ench�res trouv�es pour l'objet : %s";
		FrmtPctlessDone	= "Pourcentage inf�rieur termin�.";
		FrmtPctlessHeader	= "R�duction par rapport au PVM : %d%%";
		FrmtPctlessLine	= "%s, Derniers %d vus, PVM : %s, AI : %s, Gain : %s, Moins %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "Ventes termin�es retir�es : %s";
		AuctionDiscrepancies	= "Ecarts : %s";
		AuctionNewAucts	= "Nouvelles ench�res analys�es : %s";
		AuctionOldAucts	= "Analys�es pr�c�demment : %s";
		AuctionPageN	= "Auctioneer : analyse en cours, cat�gorie '%s', \npage %d sur %d,\n%s ench�res/s. \nTemps restant estim� : %s";
		AuctionScanDone	= "Auctioneer : analyse termin�e";
		AuctionScanNexttime	= "Auctioneer fera une analyse compl�te de l'H�tel des Ventes la prochaine fois que vous parlerez � un commissaire-priseur.";
		AuctionScanNocat	= "Vous devez s�lectionner au moins une cat�gorie pour analyser.";
		AuctionScanRedo	= "La page actuelle a mis plus de %d secondes pour �tre analys�e, nouvelle tentative.";
		AuctionScanStart	= "Auctioneer : analyse '%s', page 1";
		AuctionTotalAucts	= "Nb total d'ench�res analys�es : %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "Vu %d fois � %s";
		FrmtInfoAverage	= "%s min/%s AI (%s ench�re)";
		FrmtInfoBidMulti	= "Offre (%s%s l'unit�)";
		FrmtInfoBidOne	= "Offre (%s)";
		FrmtInfoBidrate	= "%d%% avec offre, %d%% avec AI";
		FrmtInfoBuymedian	= "Achat Imm�diat m�dian";
		FrmtInfoBuyMulti	= "Achat imm�diat (%s%s l'unit�)";
		FrmtInfoBuyOne	= "Achat imm�diat (%s)";
		FrmtInfoForone	= "Pour 1 : %s min/%s AI (%s ench�re) [par %d]";
		FrmtInfoHeadMulti	= "Moyennes pour %d objets :";
		FrmtInfoHeadOne	= "Moyennes pour cet objet :";
		FrmtInfoHistmed	= "%d derniers vus. AI moyen (l'unit�) :";
		FrmtInfoMinMulti	= "Mise � prix initiale (%s l'unit�)";
		FrmtInfoMinOne	= "Mise � prix initiale";
		FrmtInfoNever	= "Jamais vu en %s";
		FrmtInfoSeen	= "Vu %d fois aux ench�res";
		FrmtInfoSgst	= "Prix sugg�r� : %s min/%s AI";
		FrmtInfoSgststx	= "Prix sugg�r� pour votre pile de %d : %s min/%s AI";
		FrmtInfoSnapmed	= "Vu %d fois � la derni�re analyse, AI moyen (pce) :";
		FrmtInfoStacksize	= "Nombre moyen d'objets par pile : %d";


		-- Section: User Interface
		FrmtLastSoldOn	= "Derni�re vente le %s";
		UiBid	= "Offre";
		UiBidHeader	= "Offre";
		UiBidPerHeader	= "Offre par";
		UiBuyout	= "Acheter";
		UiBuyoutHeader	= "Achat Imm�diat";
		UiBuyoutPerHeader	= "Achat Imm�diat par";
		UiBuyoutPriceLabel	= "Prix d'achat :";
		UiBuyoutPriceTooLowError	= "(Trop faible)";
		UiCategoryLabel	= "Restriction de cat�gorie : \n";
		UiDepositLabel	= "D�p�t :";
		UiDurationLabel	= "Dur�e :";
		UiItemLevelHeader	= "Niv";
		UiMakeFixedPriceLabel	= "M�moriser le prix";
		UiMaxError	= "(%d Max)";
		UiMaximumPriceLabel	= "Prix maximum :";
		UiMaximumTimeLeftLabel	= "Temps restant maximum :";
		UiMinimumPercentLessLabel	= "% min de gain :";
		UiMinimumProfitLabel	= "Gain minimum : ";
		UiMinimumQualityLabel	= "Qualit� minimum :";
		UiMinimumUndercutLabel	= "Marge minimum :";
		UiNameHeader	= "Nom";
		UiNoPendingBids	= "Toutes les offres ont �t� soumises!";
		UiNotEnoughError	= "(Pas assez)";
		UiPendingBidInProgress	= "1 offre en cours...";
		UiPendingBidsInProgress	= "%d offres en cours...";
		UiPercentLessHeader	= "% de";
		UiPost	= "Vendre";
		UiPostAuctions	= "Vendre";
		UiPriceBasedOnLabel	= "Prix Bas� sur :";
		UiPriceModelAuctioneer	= "Prix Auctioneer";
		UiPriceModelCustom	= "Prix personnalis�";
		UiPriceModelFixed	= "Prix m�moris�";
		UiPriceModelLastSold	= "Dernier prix de vente";
		UiProfitHeader	= "B�n�fices";
		UiProfitPerHeader	= "B�n�fices par";
		UiQuantityHeader	= "Qt�";
		UiQuantityLabel	= "Quantit� :";
		UiRemoveSearchButton	= "Supprimer";
		UiSavedSearchLabel	= "Recherches sauvegard�es :";
		UiSaveSearchButton	= "Sauvegarder";
		UiSaveSearchLabel	= "Sauvegarder cette recherche :";
		UiSearch	= "Recherche";
		UiSearchAuctions	= "Recherche Ench�res";
		UiSearchDropDownLabel	= "Recherche :";
		UiSearchForLabel	= "Recherche d'un objet :";
		UiSearchTypeBids	= "Offres";
		UiSearchTypeBuyouts	= "Achats Imm�diats";
		UiSearchTypeCompetition	= "Concurrence ";
		UiSearchTypePlain	= "Objet";
		UiStacksLabel	= "Piles";
		UiStackTooBigError	= "(Pile trop grosse)";
		UiStackTooSmallError	= "(Pile trop petite)";
		UiStartingPriceLabel	= "Prix de d�part :";
		UiStartingPriceRequiredError	= "(Requis)";
		UiTimeLeftHeader	= "Temps restant";
		UiUnknownError	= "(Inconnu)";

	};

	itIT = {


		-- Section: AskPrice Messages
		AskPriceAd	= "Prezzo di uno stack da %sx[ItemLink]";
		FrmtAskPriceBuyoutMedianHistorical	= "%sBuyout-medio degli scan: %s%s";
		FrmtAskPriceBuyoutMedianSnapshot	= "%sBuyout-medio ultimo scan: %s%s";
		FrmtAskPriceDisable	= "Disabilita l'opzione Prezzo Richiesto di %s";
		FrmtAskPriceEach	= "(%s l'una)";
		FrmtAskPriceEnable	= "Attivando l'opzione %s di AskPrice";
		FrmtAskPriceVendorPrice	= "%sVendi al vendor per: %s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "Asta %s rimossa dalla lista corrente.";
		FrmtAuctinfoHist	= "%d storico";
		FrmtAuctinfoLow	= "Prezzo minimo";
		FrmtAuctinfoMktprice	= "Prezzo di mercato";
		FrmtAuctinfoNolow	= "Oggetto non visto nell'ultimo scan";
		FrmtAuctinfoOrig	= "Offerta originale";
		FrmtAuctinfoSnap	= "%d ultimo scan";
		FrmtAuctinfoSugbid	= "Offerta suggerita";
		FrmtAuctinfoSugbuy	= "Prezzo d'acquisto suggerito";
		FrmtWarnAbovemkt	= "Prezzo superiore alla media di mercato.";
		FrmtWarnMarkup	= "Oltre il prezzo del vendor di %s%%";
		FrmtWarnMyprice	= "Sto usando il mio prezzo attuale";
		FrmtWarnNocomp	= "Nessuna competizione";
		FrmtWarnNodata	= "Nessun dato per HSP";
		FrmtWarnToolow	= "Minimo troppo inferiore al prezzo di mercato";
		FrmtWarnUndercut	= "Prezzo ribassato del %s%%";
		FrmtWarnUser	= "Il prezzo coincide con il prezzo del vendor";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "E' gi� la piu' alta richiesta all'asta: %s (x%d)";
		FrmtBidAuction	= "Offerta all'asta: %s (x%d)";
		FrmtBidQueueOutOfSync	= "Errore: La coda delle offerte e' fuori sincrono!";
		FrmtBoughtAuction	= "Comprato di Buyout: %s (x%d)";
		FrmtMaxBidsReached	= "Altre aste per %s (x%d) sono state trovate, ma il limite di offerta e' stato raggiunto (%d) ";
		FrmtNoAuctionsFound	= "Nessuna asta trovata: %s (x%d)";
		FrmtNoMoreAuctionsFound	= "Nessun'altra asta trovata: %s (x%d)";
		FrmtNotEnoughMoney	= "Denaro insufficiente per fare un offerta: %s (x%d)";
		FrmtSkippedAuctionWithHigherBid	= "Escluse aste con bid piu' alto: %s (x%d)";
		FrmtSkippedAuctionWithLowerBid	= "Escluse aste con bid piu' basso: %s (x%d)";
		FrmtSkippedBiddingOnOwnAuction	= "Saltata offerta su una propria asta: %s (x%d)";
		UiProcessingBidRequests	= "Analisi delle richieste di bid...";


		-- Section: Command Messages
		FrmtActClearall	= "Sto eliminando tutti i dati per %s";
		FrmtActClearFail	= "Impossibile trovare: %s";
		FrmtActClearOk	= "Rimossi dati per l'oggetto: %s";
		FrmtActClearsnap	= "Sto cancellando la lista attuale.";
		FrmtActDefault	= "Opzione %s riportata al valore predefinito";
		FrmtActDefaultall	= "Tutte le opzioni riportate ai valori predefiniti.";
		FrmtActDisable	= "I dati per %s non sono visualizzati";
		FrmtActEnable	= "I dati per %s sono visualizzati";
		FrmtActSet	= "Opzione %s impostata a '%s'";
		FrmtActUnknown	= "Comando non riconosciuto: '%s'";
		FrmtAuctionDuration	= "Durata predefinita: %s";
		FrmtAutostart	= "Asta automatica per %s minimo, %s buyout(%dh)\n%s";
		FrmtFinish	= "Quando lo scan sia finito, %s";
		FrmtPrintin	= "I messaggi di Auctioneer saranno visualizzati nella chat \"%s\"";
		FrmtProtectWindow	= "Protezione della finestra AH impostata a: %s";
		FrmtUnknownArg	= "'%s' non e' un argomento valido per '%s'";
		FrmtUnknownLocale	= "La lingua specificata ('%s') e' sconosciuta. Lingue valide:";
		FrmtUnknownRf	= "Parametro non valido('%s'). Il parametro deve avere un formato [reame]-[fazione]. Esempio: Al'Akir-Horde";


		-- Section: Command Options
		OptAlso	= "(reame-fazione|opposta)";
		OptAuctionDuration	= "(durata||2h||8h||24h)";
		OptBidbroker	= "<guadagno_silver>";
		OptBidLimit	= "<numero>";
		OptBroker	= "<guadagno_silver>";
		OptClear	= "([Oggetto]|tutto|lista) ";
		OptCompete	= "<silver_in_meno>";
		OptDefault	= "(<opzione>|tutto) ";
		OptFinish	= "(spento||stacca||esci)";
		OptLocale	= "<lingua>";
		OptPctBidmarkdown	= "<percento>";
		OptPctMarkup	= "<percento>";
		OptPctMaxless	= "<percento>";
		OptPctNocomp	= "<percento>";
		OptPctUnderlow	= "<percento>";
		OptPctUndermkt	= "<percento>";
		OptPercentless	= "<percento>";
		OptPrintin	= "(<Indiceframe>[Numero]|<Nomeframe>[Stringa]) ";
		OptProtectWindow	= "(mai||scan||sempre)";
		OptScale	= "<fattore_scala>";
		OptScan	= "parametri di scan";


		-- Section: Commands
		CmdAlso	= "anche";
		CmdAlsoOpposite	= "opposta";
		CmdAlt	= "alt";
		CmdAskPriceAd	= "aggiunto";
		CmdAskPriceGuild	= "gilda";
		CmdAskPriceParty	= "gruppo";
		CmdAskPriceSmart	= "corte";
		CmdAskPriceSmartWord1	= "che";
		CmdAskPriceSmartWord2	= "Ricerca multipla";
		CmdAskPriceTrigger	= "automatismo";
		CmdAskPriceVendor	= "Venditore";
		CmdAskPriceWhispers	= "Whispers";
		CmdAskPriceWord	= "word";
		CmdAuctionClick	= "auction-click";
		CmdAuctionDuration	= "durata-asta";
		CmdAuctionDuration0	= "precedente";
		CmdAuctionDuration1	= "2h";
		CmdAuctionDuration2	= "8h";
		CmdAuctionDuration3	= "24h";
		CmdAutofill	= "auto-riempimento";
		CmdBidbroker	= "Agente d'Offerta";
		CmdBidbrokerShort	= "ao";
		CmdBidLimit	= "limite-offerta";
		CmdBroker	= "Agente";
		CmdClear	= "cancella";
		CmdClearAll	= "tutto";
		CmdClearSnapshot	= "lista";
		CmdCompete	= "competere";
		CmdCtrl	= "ctrl";
		CmdDefault	= "default";
		CmdDisable	= "disabilita";
		CmdEmbed	= "integra";
		CmdFinish	= "finale";
		CmdFinish0	= "spento";
		CmdFinish1	= "stacca";
		CmdFinish2	= "esci";
		CmdFinish3	= "Ricarica l'Interfaccia";
		CmdFinishSound	= "avviso sonoro al termine";
		CmdHelp	= "aiuto";
		CmdLocale	= "lingua";
		CmdOff	= "disattivo";
		CmdOn	= "attivo";
		CmdPctBidmarkdown	= "pct-bidmarkdown";
		CmdPctMarkup	= "pct-markup";
		CmdPctMaxless	= "pct-senzamassimo";
		CmdPctNocomp	= "pct-nocomp";
		CmdPctUnderlow	= "pct-underlow";
		CmdPctUndermkt	= "pct-sottomercato";
		CmdPercentless	= "percentless";
		CmdPercentlessShort	= "pl";
		CmdPrintin	= "stampa-in";
		CmdProtectWindow	= "proteggere-finestra";
		CmdProtectWindow0	= "mai";
		CmdProtectWindow1	= "scan";
		CmdProtectWindow2	= "sempre";
		CmdScan	= "scan";
		CmdShift	= "shift";
		CmdToggle	= "attiva-disattiva";
		CmdUpdatePrice	= "aggiorna-prezzo";
		CmdWarnColor	= "avviso-colore";
		ShowAverage	= "mostra-media";
		ShowEmbedBlank	= "mostra-lineavuota-integrata";
		ShowLink	= "mostra-collegamento";
		ShowMedian	= "mostra-media";
		ShowRedo	= "mostra-avvertenze";
		ShowStats	= "mostra-statistiche";
		ShowSuggest	= "mostra-consigli";
		ShowVerbose	= "mostra-dettagliato";


		-- Section: Config Text
		GuiAlso	= "Mostra informazioni anche per";
		GuiAlsoDisplay	= "Mostra informazioni per %s";
		GuiAlsoOff	= "Visualizzazione informazioni di altri reami-fazioni disabilitata.";
		GuiAlsoOpposite	= "Visualizzazione informazioni di altri reami-fazioni abilitata.";
		GuiAskPrice	= "Attivare AskPrice";
		GuiAskPriceAd	= "Manda le novit�";
		GuiAskPriceGuild	= "Rispondi alle richieste in chat gilda";
		GuiAskPriceHeader	= "Opzioni di AskPrice";
		GuiAskPriceHeaderHelp	= "Cambia le opzioni del PrezzoRichiesto";
		GuiAskPriceParty	= "Rispondi alle richieste in chat gruppo";
		GuiAskPriceSmart	= "Usa parole-corte";
		GuiAskPriceTrigger	= "PrezzoRichiesto automatico";
		GuiAskPriceVendor	= "Manda le info del vendor";
		GuiAskPriceWhispers	= "Mostra i whispers in uscita";
		GuiAskPriceWord	= "Parola chiave personalizzata %d";
		GuiAuctionDuration	= "Durata asta predefinita";
		GuiAuctionHouseHeader	= "Finestra Casa d'Aste (AH)";
		GuiAuctionHouseHeaderHelp	= "Impostazioni della finestra Casa d'Aste (AH)";
		GuiAutofill	= "Inserimento automatico prezzi";
		GuiAverages	= "Mostra Medie";
		GuiBidmarkdown	= "Percentuale di bid markdown";
		GuiClearall	= "Cancella tutti i dati di Auctioneer";
		GuiClearallButton	= "Cancella dati fazione-reame attuali";
		GuiClearallHelp	= "Fare click qui per cancellare tutti i dati della fazione-reame attuale.";
		GuiClearallNote	= "per la fazione-reame attuale.";
		GuiClearHeader	= "Cancella Dati";
		GuiClearHelp	= "Cancella i dati di Auctioneer. Selezionare tutti i dati o solo la lista attuale. ATTENZIONE: queste operazioni NON sono annullabili.";
		GuiClearsnap	= "Cancella lista attuale";
		GuiClearsnapButton	= "Cancella lista";
		GuiClearsnapHelp	= "Fare click qui per canecllare l'ultima lista.";
		GuiDefaultAll	= "Reimposta tutte le opzioni di Auctioneer";
		GuiDefaultAllButton	= "Reimposta tutto";
		GuiDefaultAllHelp	= "Fare click qui per riportare tutte le opzioni ai loro valori predefiniti. ATTENZIONE: questa azione NON e' annullabile.";
		GuiDefaultOption	= "Reimposta al valore predefinito";
		GuiEmbed	= "Includi info nei tooltip";
		GuiEmbedBlankline	= "Mostra linea vuota nei tooltip";
		GuiEmbedHeader	= "Integra";
		GuiFinish	= "Dopo finita una scansione";
		GuiFinishSound	= "Avvisa con un suono quando lo scan � terminato";
		GuiLink	= "Mostra LinkID";
		GuiLoad	= "Carica Auctioneer";
		GuiLoad_Always	= "sempre";
		GuiLoad_AuctionHouse	= "nella Casa d'Aste (AH)";
		GuiLoad_Never	= "mai";
		GuiLocale	= "Imposta lingua a";
		GuiMainEnable	= "Attiva Auctioneer";
		GuiMainHelp	= "Contiene le impostazioni per Auctioneer, un AddOn che mostra informazioni sugli oggetti e analizza i dati delle aste. Fare click sul pulsante \"Scan\" nella Casa d'Aste (AH) per acquisire le informazioni.";
		GuiMarkup	= "Percentuale di Markup sul prezzo del vendor";
		GuiMaxless	= "Percentuale massima di ribasso";
		GuiMedian	= "Mostra mediane";
		GuiNocomp	= "Percentuale di ribasso senza concorrenti";
		GuiNoWorldMap	= "Auctioneer: visualizzazione Atlante impedita ";
		GuiOtherHeader	= "Altre opzioni";
		GuiOtherHelp	= "Opzioni varie";
		GuiPercentsHeader	= "Percentuali soglia di Auctioneer";
		GuiPercentsHelp	= "ATTENZIONE: I parametri seguenti sono SOLAMENTE per utenti esperti. Modifica i valori seguenti per impostare quanto aggressivo deve essere Auctioneer nel determinare i livelli di profitto.";
		GuiPrintin	= "Seleziona la finestra desiderata";
		GuiProtectWindow	= "Previeni chiusure accidentali della finestra della CdA";
		GuiRedo	= "Mostra avvertimento scansione lunga";
		GuiReloadui	= "Ricarica l'interfaccia utente";
		GuiReloaduiButton	= "RicaricaIU";
		GuiReloaduiFeedback	= "Caricamento Interfaccia di WoW";
		GuiReloaduiHelp	= "Clicca qui per ricaricare l'Interfaccia Utente di WoW dopo aver modificato la localizzazione. Facendo ci� la lingua delle schermate di configurazione coincider�  con quella di Auctioneer. Nota: questa operazione pu� richiedere alcuni minuti.";
		GuiRememberText	= "Ricorda il prezzo";
		GuiStatsEnable	= "Mostra statistiche";
		GuiStatsHeader	= "Statistiche del prezzo dell'oggetto";
		GuiStatsHelp	= "Mostra le seguenti statistiche nel Tooltip";
		GuiSuggest	= "Mostra prezzo consigliato";
		GuiUnderlow	= "Ribasso maggiore";
		GuiUndermkt	= "Ribasso se Maxless";
		GuiVerbose	= "Informazioni dettagliate";
		GuiWarnColor	= "Colora Modello Prezzi";


		-- Section: Conversion Messages
		MesgConvert	= "Conversione del Database di Auctioneer. Fate prima una copia del vostro SavedVariables\\Auctioneer.lua %s%s";
		MesgConvertNo	= "Disattiva Auctioneer";
		MesgConvertYes	= "Convertire";
		MesgNotconverting	= "Auctioneer non sta convertendo il tuo database, ma non funzioner� finch� il database non sar� convertito.";


		-- Section: Game Constants
		TimeLong	= "Lungo";
		TimeMed	= "Medio";
		TimeShort	= "Breve";
		TimeVlong	= "Molto Lungo";


		-- Section: Generic Messages
		DisableMsg	= "Disattiva il caricamento automatico di Auctioneer";
		FrmtWelcome	= "Auctioneer v%s caricato";
		MesgNotLoaded	= "Auctioneer non e' caricato. digita /auctioneer per maggiori informazioni.";
		StatAskPriceOff	= "AskPrice e' disattivato ora.";
		StatAskPriceOn	= "AskPrice e' attivato ora.";
		StatOff	= "Visualizzazione delle informazioni sulle aste disattivata";
		StatOn	= "Visualizzazione delle informazioni sulle aste attivata";


		-- Section: Generic Strings
		TextAuction	= "Asta";
		TextCombat	= "Combattimento";
		TextGeneral	= "Generale";
		TextNone	= "nessuno";
		TextScan	= "Scan";
		TextUsage	= "Sintassi:";


		-- Section: Help Text
		HelpAlso	= "Mostra anche i valori di un altro server nei suggerimenti. Occorre inserire nome del reame e della fazione. Esempio: \"/auctioneer also Al'Akir-Horde\". Con la parola chiave \"opposite\" si specifica la fazione opposta, mentre \"off\" disattiva la funzionalita' .";
		HelpAskPrice	= "Attiva o disattiva AskPrice.";
		HelpAskPriceAd	= "Attiva o disattiva l'annuncio delle caratteristiche nuove di AskPrice.";
		HelpAskPriceGuild	= "Rispondi alle richieste fatte nella chat di gilda";
		HelpAskPriceParty	= "Rispondi alle richieste fatte nella chat del gruppo";
		HelpAskPriceSmart	= "Attiva o disattiva il controllo sulle SmartWords";
		HelpAskPriceTrigger	= "Cambia il carattere del PrezzoRichiesto";
		HelpAskPriceVendor	= "Attiva o Disattiva l'invio dei prezzi del vendor.";
		HelpAskPriceWhispers	= "Attiva o disattiva l'occultamento di tutti i whispers AskPrice in uscita";
		HelpAskPriceWord	= "Aggiungi o modifica le SmartWords abituali dell'AskPrice";
		HelpAuctionClick	= "Consente di creare automaticamente un'asta tenendo premuto Alt e cliccando su di un oggetto nell'inventario";
		HelpAuctionDuration	= "Imposta la durata di default delle aste all'apertura dell'interfaccia della Casa d'Aste";
		HelpAutofill	= "Imposta se auto-inserire o meno i prezzi quando si mette all'asta un nuovo oggetto nella finestra della Casa d'Aste";
		HelpAverage	= "Imposta la visualizzazione del prezzo d'asta medio dell'oggetto";
		HelpBidbroker	= "Mostra le aste a breve o medio termine selezionate dall'ultima scansione su cui puoi fare un'offerta per trarne profitto";
		HelpBidLimit	= "Numero massimo le aste da fare un'offerta sopra o buyout di quando il tasto di buyout o di offerta � scattato sulla linguetta delle aste di ricerca.";
		HelpBroker	= "Mostra tutte le aste selezionate dall'ultima scansione su cui puoi fare un'offerta per trarne profitto rivendendo";
		HelpClear	= "Elimina i dati sull'oggetto specificato (inserisci l'oggetto nel comando con shift-click). Puoi anche usare le parole chiave \"all\" o \"snapshot\"";
		HelpCompete	= "Mostra tutte le aste scansionate di recente il cui buyout � inferiore ad uno dei tuoi oggetti";
		HelpDefault	= "Imposta un opzione di Auctioneer al valore di default. Puoi anche usare la parola chiave \"all\" per impostare tutte le opzioni di Auctioneer ai valori di default.";
		HelpDisable	= "Non attivare automaticamente Auctioneer la prossima volta che ti colleghi";
		HelpEmbed	= "Integra il testo nei tooltip originali del gioco (nota: alcune funzionalit�  vengono disabilitate quando quest'opzione � attiva)";
		HelpEmbedBlank	= "Imposta se visualizzare o meno una riga vuota fra le informazioni del tooltip e le informazioni sull'asta quando il modo integrato � attivo";
		HelpFinish	= "Imposta se effettuare il LogOut o Chiudere  automaticamente il gioco alla fine di uno scan dell AH";
		HelpFinishSound	= "Seleziona se avere o meno un avviso sonoro alla fine dello scan della casa d'aste";
		HelpLink	= "Imposta se visualizzare il link id nel tooltip";
		HelpLoad	= "Cambia le impostazioni di caricamento di Auctioneer per questo personaggio";
		HelpLocale	= "Cambia la lingua utilizzata per i messaggi di Auctioneer";
		HelpMedian	= "Imposta se visualizzare il buyout medio dell'oggetto";
		HelpOnoff	= "Attiva/disattiva la visualizzazione dei dati dell'asta";
		HelpPctBidmarkdown	= "Regola la percentuale con cui auctioneer contrassegner�  le offerte al ribasso dal prezzo di buyout";
		HelpPctMarkup	= "La percentuale dei prezzi del vendor sar� evidenziata quando non ci saranno altri valori disponibili";
		HelpPctMaxless	= "Regola la percentuale massima con cui auctioneer diminuira' il valore del mercato prima che scada";
		HelpPctNocomp	= "La percentuale con cui auctioneer diminuira' il valore del mercato dell'oggetto quando non c'� concorrenza";
		HelpPctUnderlow	= "Regola la percentuale con cui auctioneer abbassera' il prezzo dell'asta pi� basso";
		HelpPctUndermkt	= "Percentuale da diminuire al valore del mercato quando non si pu� battere la concorrenza (senza limiti)";
		HelpPercentless	= "Mostra tutte le aste nelle ultime scansioni il cui buyout e' piu' basso di una certa percentuale rispetto al prezzo di vendita pi� alto";
		HelpPrintin	= "Seleziona in quale frame Auctioneer visualizzera'  i suoi messaggi. Puoi specificare il nome del frame o il suo numero.";
		HelpProtectWindow	= "Impedisce la chiusura accidentale dell'interfaccia dell'AH";
		HelpRedo	= "Seleziona per mostare un avviso quando lo scan di una pagina dell'AH ha impiegato troppo tempo a causa del lag.";
		HelpScan	= "Eseguire uno scan dell'AH alla prossima visita, o mentre sei li (c'e' un bottone sulla finestra dell'asta). Scegli su quali categorie vuoi eseguire lo scan con i checkbox.";
		HelpStats	= "Seleziona per mostrare le percentuali di bid/buyout di un oggetto";
		HelpSuggest	= "Seleziona per mostrare i prezzi d'asta consigliati di un oggetto";
		HelpUpdatePrice	= "Aggiorni automaticamente il prezzo iniziante per un'asta sulla linguetta delle aste dell'alberino quando il prezzo buyout cambia.";
		HelpVerbose	= "Seleziona per mostrare le medie e i consigli completi (oppure disattiva per mostrarli su linea singola)";
		HelpWarnColor	= "Seleziona se mostrare il modello dei prezzi attuale (Ribassato da...) in colori intuitivi.";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "Non hai spazio sufficente per poter creare l'asta!";
		FrmtNotEnoughOfItem	= "%s insufficenti per creare l'asta!";
		FrmtPostedAuction	= "Inserita 1 asta su %s (x%d)";
		FrmtPostedAuctions	= "Inserite %d aste su %s (x%d)";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "OffertaCorrente";
		FrmtBidbrokerDone	= "Bid brokering completato.";
		FrmtBidbrokerHeader	= "Profitto minimo: %s, HSP ='Prezzo Massimo Applicabile(Vendibile)'";
		FrmtBidbrokerLine	= "%s, Ultimi %s visti, HSP: %s, %s: %s, Prof: %s, Volte: %s";
		FrmtBidbrokerMinbid	= "OffertaMinima";
		FrmtBrokerDone	= "Brokeraggio completato";
		FrmtBrokerHeader	= "Profitto minimo: %s, PMV = 'Prezzo Massimo di Vendita' ";
		FrmtBrokerLine	= "%s, Ultimi %s visti, HSP: %s, BO: %s, Prof: %s";
		FrmtCompeteDone	= "Confronto delle auction completato.";
		FrmtCompeteHeader	= "Confrontando auction con ribasso di almeno %s per oggetto.";
		FrmtCompeteLine	= "%s, Puntata: %s, BO %s vs %s, %s meno";
		FrmtHspLine	= "Prezzo Massimo di Vendita per un %s �: %s";
		FrmtLowLine	= "%s, BO: %s, Venditore: %s, Per uno: %s, Meno della mediana: %s";
		FrmtMedianLine	= "Degli ultimi %d visti, BO mediano per 1 %s �: %s ";
		FrmtNoauct	= "Nessuna asta trovata per: %s ";
		FrmtPctlessDone	= "Ribasso applicato.";
		FrmtPctlessHeader	= "Ribasso sul Prezzo Applicabile Massimo (HSP): %d%%";
		FrmtPctlessLine	= "%s, Ultime %d viste, HSP: %s, BO: %s, Prof: %s, Ribasso %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "Aste obsolete rimosse: %s ";
		AuctionDiscrepancies	= "Discrepanze: %s  ";
		AuctionNewAucts	= "Nuove aste scansionate: %s";
		AuctionOldAucts	= "Scansionate precedentemente: %s";
		AuctionPageN	= "Auctioneer: scansione %s pagina %d di %d,\nAste al secondo: %s,\nTempo rimasto: %s ";
		AuctionScanDone	= "Auctioneer: scansione delle aste completata";
		AuctionScanNexttime	= "Auctioneer eseguira' una scansione completa delle aste la prossima volta che parlerai con un banditore.";
		AuctionScanNocat	= "Selezionare almeno una categoria per la scansione.";
		AuctionScanRedo	= "La pagina corrente ha impiegato piu' di %d secondi per essere scansionata, nuovo tentativo di scansione .";
		AuctionScanStart	= "Auctioneer: scansione %s pagina 1... ";
		AuctionTotalAucts	= "Totale aste scansionate: %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "Visto %d volte a %s";
		FrmtInfoAverage	= "%s min/%s BO (%s offerta)";
		FrmtInfoBidMulti	= "Offerta (%s%s cad)";
		FrmtInfoBidOne	= "Con offerte%s";
		FrmtInfoBidrate	= "%d%% hanno offerte, %d%% hanno BO";
		FrmtInfoBuymedian	= "Buyout mediano";
		FrmtInfoBuyMulti	= "Buyout (%s%s cad) ";
		FrmtInfoBuyOne	= "Buyout%s";
		FrmtInfoForone	= "Per 1: %s min/%s BO (%s offerta) [in %d]";
		FrmtInfoHeadMulti	= "Medie per %d oggetti:";
		FrmtInfoHeadOne	= "Medie per questo oggetto:";
		FrmtInfoHistmed	= "Ultimo %d, BO mediano (cad)";
		FrmtInfoMinMulti	= "Offerta iniziale (%s cad)";
		FrmtInfoMinOne	= "Offerta iniziale";
		FrmtInfoNever	= "Mai visto a %s";
		FrmtInfoSeen	= "Visto un totale di %d volte all'asta";
		FrmtInfoSgst	= "Prezzo suggerito: %s min/%s BO";
		FrmtInfoSgststx	= "Prezzo suggerito per la tua pila di %d: %s min/%s BO";
		FrmtInfoSnapmed	= "Scansionato %d, BO mediano (cad)";
		FrmtInfoStacksize	= "Dimensione media della pila: %d oggetti";


		-- Section: User Interface
		FrmtLastSoldOn	= "Ultima Vendita a %s";
		UiBid	= "Bid";
		UiBidHeader	= "Bid";
		UiBidPerHeader	= "Percentuale Bid:";
		UiBuyout	= "Buyout";
		UiBuyoutHeader	= "Buyout";
		UiBuyoutPerHeader	= "Percentuale Buyout";
		UiBuyoutPriceLabel	= "Prezzo Buyout:";
		UiBuyoutPriceTooLowError	= "(Troppo Basso)";
		UiCategoryLabel	= "Filtro Categoria:";
		UiDepositLabel	= "Deposito:";
		UiDurationLabel	= "Durata:";
		UiItemLevelHeader	= "Liv";
		UiMakeFixedPriceLabel	= "Usa prezzo fisso";
		UiMaxError	= "(%d Max)";
		UiMaximumPriceLabel	= "Prezzo Massimo:";
		UiMaximumTimeLeftLabel	= "Massimo Tempo Mancante:";
		UiMinimumPercentLessLabel	= "Percentuale minima in meno:";
		UiMinimumProfitLabel	= "Profitto Minimo:";
		UiMinimumQualityLabel	= "Qualita' minima:";
		UiMinimumUndercutLabel	= "Ribasso minimo:";
		UiNameHeader	= "Nome";
		UiNoPendingBids	= "Tutte le richieste di bid completate!";
		UiNotEnoughError	= "(Non Abbastanza)";
		UiPendingBidInProgress	= "1 richiesta di bid in corso...";
		UiPendingBidsInProgress	= "%d richieste di bid in corso...";
		UiPercentLessHeader	= "%";
		UiPost	= "Inserisci";
		UiPostAuctions	= "Inserisci Asta";
		UiPriceBasedOnLabel	= "Prezzo basato su:";
		UiPriceModelAuctioneer	= "Prezzo Auctioneer";
		UiPriceModelCustom	= "Prezzo personale";
		UiPriceModelFixed	= "Prezzo fisso";
		UiPriceModelLastSold	= "Ultimo Prezzo di Vendita";
		UiProfitHeader	= "Guadagno";
		UiProfitPerHeader	= "Guadagno %";
		UiQuantityHeader	= "Q.ta'";
		UiQuantityLabel	= "Quantita':";
		UiRemoveSearchButton	= "Cancella";
		UiSavedSearchLabel	= "Ricerche salvate:";
		UiSaveSearchButton	= "Salva";
		UiSaveSearchLabel	= "Salva questa ricerca:";
		UiSearch	= "Cerca";
		UiSearchAuctions	= "Cerca Aste";
		UiSearchDropDownLabel	= "Cerca:";
		UiSearchForLabel	= "Cerca un oggetto:";
		UiSearchTypeBids	= "Offerte";
		UiSearchTypeBuyouts	= "Buyout";
		UiSearchTypeCompetition	= "Competizione";
		UiSearchTypePlain	= "Oggetto";
		UiStacksLabel	= "Pile";
		UiStackTooBigError	= "(Pila troppo grande)";
		UiStackTooSmallError	= "(Pila troppo piccola)";
		UiStartingPriceLabel	= "Prezzo di partenza:";
		UiStartingPriceRequiredError	= "(Obbligatorio)";
		UiTimeLeftHeader	= "Tempo rimanente";
		UiUnknownError	= "(Sconosciuto)";

	};

	koKR = {


		-- Section: AskPrice Messages
		AskPriceAd	= "%sx[?????]? ?? ?? ??? ?????.(x=????)";
		FrmtAskPriceBuyoutMedianHistorical	= "%s ?????? ?? ??? ???: %s%s";
		FrmtAskPriceBuyoutMedianSnapshot	= "%s ?? ??? ?? ??? ???: %s%s";
		FrmtAskPriceDisable	= "????? %s ?? ????";
		FrmtAskPriceEach	= "(?? %s)";
		FrmtAskPriceEnable	= "????? %s ?? ???";
		FrmtAskPriceVendorPrice	= "%s ?? ???: %s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "??? ????? %s|1?;?; ?????.";
		FrmtAuctinfoHist	= "?? %d?";
		FrmtAuctinfoLow	= "?? ??";
		FrmtAuctinfoMktprice	= "???";
		FrmtAuctinfoNolow	= "?? ??? ???? ? ?? ?? ???.";
		FrmtAuctinfoOrig	= "?? ???";
		FrmtAuctinfoSnap	= "?? ?? %d?";
		FrmtAuctinfoSugbid	= "??? ???";
		FrmtAuctinfoSugbuy	= "??? ?? ???";
		FrmtWarnAbovemkt	= "??? ??? ??";
		FrmtWarnMarkup	= "??? ?? %s%% ??";
		FrmtWarnMyprice	= "? ?? ?? ??";
		FrmtWarnNocomp	= "?? ??";
		FrmtWarnNodata	= "?? ?????(HSP)??? ??? ??";
		FrmtWarnToolow	= "???? ?? ? ????.";
		FrmtWarnUndercut	= "%s%% ?? ??";
		FrmtWarnUser	= "??? ?? ??";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "??? ?? ? ?? ???? ??: %s (x%d)";
		FrmtBidAuction	= "??? ??: %s (x%d)";
		FrmtBidQueueOutOfSync	= "??: ?? ??? ???? ??? ???????!";
		FrmtBoughtAuction	= "????? ??: %s (x%d)";
		FrmtMaxBidsReached	= "%s (x%d)? ????? ?? ????, ?? ??? ??????.(%d)";
		FrmtNoAuctionsFound	= "??? ?? ???: %s (x%d)";
		FrmtNoMoreAuctionsFound	= "??? ???? ?? ? ????: %s (x%d)";
		FrmtNotEnoughMoney	= "??? ???? ?? ???? ?????: %s (x%d)";
		FrmtSkippedAuctionWithHigherBid	= "? ?? ??? ?? ??? ??: %s (x%d)";
		FrmtSkippedAuctionWithLowerBid	= "? ?? ??? ?? ??? ??: %s (x$d)";
		FrmtSkippedBiddingOnOwnAuction	= "??? ???? ??? ???: %s (x%d)";
		UiProcessingBidRequests	= "?? ?? ???...";


		-- Section: Command Messages
		ConstantsCritical	= "??: Auctioneer SavedVariables ??? %.3f%% ?? ? ????.";
		ConstantsMessage	= "Auctioneer SavedVariables ??? %.3f%% ?? ? ????.";
		ConstantsWarning	= "??: Auctioneer SavedVariables ??? %.3f%% ?? ? ????.";
		FrmtActClearall	= "%s? ?? ?? ?? ??? ??";
		FrmtActClearFail	= "?? ? ?? ???: %s";
		FrmtActClearOk	= "????? ??? ???: %s";
		FrmtActClearsnap	= "?? ??? ?? ?? ??";
		FrmtActDefault	= "Auctioneer? %s ??? ????????.";
		FrmtActDefaultall	= "?? Auctioneer? ??? ????????.";
		FrmtActDisable	= "???? %s ??? ???? ??";
		FrmtActEnable	= "???? %s ??? ??";
		FrmtActSet	= "%s? ??? '%s'??";
		FrmtActUnknown	= "? ? ?? ???: '%s'";
		FrmtAuctionDuration	= "?? ?? ???? ???: %s ";
		FrmtAutostart	= "???? ?? ??: ??? %s, ?? ??? %s(%d??) %s";
		FrmtFinish	= "??? ???, %s|1?;?; ?????.";
		FrmtPrintin	= "Auctioneer? ???? \"%s\" ?? ?? ?????.";
		FrmtProtectWindow	= "AH? ??? ???: %s";
		FrmtUnknownArg	= "'%s'? '%s'? ???? ?? ???? ???.";
		FrmtUnknownLocale	= "??? ?? ('%s')? ?? ????. ??? ??:";
		FrmtUnknownRf	= "???? ?? ???? ('%s'). ????? ??? ??? ??? ?: [realm]-[faction]. ?: ???-??";


		-- Section: Command Options
		OptAlso	= "(??-??|???|????|????)";
		OptAskPriceSend	= "(<??????> <???? ??>)";
		OptAuctionDuration	= "(??|2??|8??|24??)";
		OptBidbroker	= "<??_??>";
		OptBidLimit	= "<??>";
		OptBroker	= "<??_??>";
		OptClear	= "([???]|??|???) ";
		OptCompete	= "<??_??>";
		OptDefault	= "(<??>|??)";
		OptFinish	= "(?|????|???|???) ";
		OptLocale	= "<??>";
		OptPctBidmarkdown	= "<???>";
		OptPctMarkup	= "<???>";
		OptPctMaxless	= "<???>";
		OptPctNocomp	= "<???>";
		OptPctUnderlow	= "<???>";
		OptPctUndermkt	= "<???>";
		OptPercentless	= "<???>";
		OptPrintin	= "(<??????>[??]|<?????>[???]) ";
		OptProtectWindow	= "(????|??|????) ";
		OptScale	= "<??_??> ";
		OptScan	= "<>";


		-- Section: Commands
		CmdAlso	= "also";
		CmdAlsoOpposite	= "???";
		CmdAlt	= "Alt";
		CmdAskPriceAd	= "??";
		CmdAskPriceGuild	= "??";
		CmdAskPriceParty	= "??";
		CmdAskPriceSend	= "???";
		CmdAskPriceSmart	= "???";
		CmdAskPriceSmartWord1	= "??";
		CmdAskPriceSmartWord2	= "??";
		CmdAskPriceTrigger	= "???";
		CmdAskPriceVendor	= "??";
		CmdAskPriceWhispers	= "???";
		CmdAskPriceWord	= "??";
		CmdAuctionClick	= "??-?? ";
		CmdAuctionDuration	= "??-??";
		CmdAuctionDuration0	= "??";
		CmdAuctionDuration1	= "2??";
		CmdAuctionDuration2	= "8??";
		CmdAuctionDuration3	= "24??";
		CmdAutofill	= "?? ??";
		CmdBidbroker	= "?????";
		CmdBidbrokerShort	= "bb ";
		CmdBidLimit	= "??-??";
		CmdBroker	= "???";
		CmdClear	= "??";
		CmdClearAll	= "??";
		CmdClearSnapshot	= "???";
		CmdCompete	= "??";
		CmdCtrl	= "Ctrl";
		CmdDefault	= "???";
		CmdDisable	= "????";
		CmdEmbed	= "??";
		CmdFinish	= "??";
		CmdFinish0	= "?";
		CmdFinish1	= "????";
		CmdFinish2	= "???";
		CmdFinish3	= "???";
		CmdFinishSound	= "?? ??";
		CmdHelp	= "???";
		CmdLocale	= "??";
		CmdOff	= "?";
		CmdOn	= "?";
		CmdPctBidmarkdown	= "pct-bidmarkdown";
		CmdPctMarkup	= "pct-markup";
		CmdPctMaxless	= "pct-maxless";
		CmdPctNocomp	= "pct-nocomp";
		CmdPctUnderlow	= "pct-underlow";
		CmdPctUndermkt	= "pct-undermkt";
		CmdPercentless	= "percentless";
		CmdPercentlessShort	= "pl";
		CmdPrintin	= "print-in";
		CmdProtectWindow	= "protect-window";
		CmdProtectWindow0	= "????";
		CmdProtectWindow1	= "??";
		CmdProtectWindow2	= "????";
		CmdScan	= "??";
		CmdShift	= "Shift";
		CmdToggle	= "??";
		CmdUpdatePrice	= "??-??";
		CmdWarnColor	= "??-??";
		ShowAverage	= "??-??";
		ShowEmbedBlank	= "??-??-???";
		ShowLink	= "??-??";
		ShowMedian	= "??-???";
		ShowRedo	= "??-??";
		ShowStats	= "??-??";
		ShowSuggest	= "??-???";
		ShowVerbose	= "??-??";


		-- Section: Config Text
		GuiAlso	= "Also ??? ??";
		GuiAlsoDisplay	= "%s? ?? ??? ??";
		GuiAlsoOff	= "??? ?? ??-?? ???? ???? ????.";
		GuiAlsoOpposite	= "Also? ?? ??? ?? ???? ?????.";
		GuiAskPrice	= "???? ???";
		GuiAskPriceAd	= "?? ?? ??";
		GuiAskPriceGuild	= "???? ?? ??";
		GuiAskPriceHeader	= "???? ??";
		GuiAskPriceHeaderHelp	= "????? ?? ??";
		GuiAskPriceParty	= "???? ?? ??";
		GuiAskPriceSmart	= "????? ??";
		GuiAskPriceTrigger	= "???? ???";
		GuiAskPriceVendor	= "?? ?? ??";
		GuiAskPriceWhispers	= "??? ???";
		GuiAskPriceWord	= "?? ????? %d";
		GuiAuctionDuration	= "?? ?? ??";
		GuiAuctionHouseHeader	= "??? ?";
		GuiAuctionHouseHeaderHelp	= "??? ?? ?? ??";
		GuiAutofill	= "????? ???? ?? ??";
		GuiAverages	= "??? ??";
		GuiBidmarkdown	= "?? ?? ?? ??";
		GuiClearall	= "?? Auctioneer ??? ??";
		GuiClearallButton	= "?? ??";
		GuiClearallHelp	= "?? ??-??? ?? ?? Auctioneer ???? ????? ??? ??????.";
		GuiClearallNote	= "?? ??-??";
		GuiClearHeader	= "??? ??";
		GuiClearHelp	= "Auctioneer ???? ?????. ?? ??? ?? ?? ??? ??????. ??: ??? ?? ??? ??? ? ????.";
		GuiClearsnap	= "?? ?? ??";
		GuiClearsnapButton	= "?? ??";
		GuiClearsnapHelp	= "??? Auctioneer ?? ??? ????? ??? ??????.";
		GuiDefaultAll	= "?? Auctioneer ?? ???";
		GuiDefaultAllButton	= "?? ???";
		GuiDefaultAllHelp	= "Auctioneer ??? ????? ????? ??? ??????. ??: ??? ???? ??? ? ????.";
		GuiDefaultOption	= "?? ???";
		GuiEmbed	= "?? ??? ??? ????";
		GuiEmbedBlankline	= "?? ??? ?? ??";
		GuiEmbedHeader	= "??";
		GuiFinish	= "??? ???";
		GuiFinishSound	= "??? ??? ?? ??";
		GuiLink	= "????? ??";
		GuiLoad	= "Auctioneer ????";
		GuiLoad_Always	= "????";
		GuiLoad_AuctionHouse	= "?????";
		GuiLoad_Never	= "????";
		GuiLocale	= "?? ??:";
		GuiMainEnable	= "Auctioneer ???";
		GuiMainHelp	= "??? ??? ?? ???? ???? ????? ???? Auctioneer? ?? ??? ??. ????? ?? ???? ????? \"??\" ??? ??????.";
		GuiMarkup	= "?? ?? ?? ??";
		GuiMaxless	= "?? ??? ?? ??";
		GuiMedian	= "??? ??";
		GuiNocomp	= "?? ?? ?? ??";
		GuiNoWorldMap	= "Auctioneer: ??? ??? ?? ???";
		GuiOtherHeader	= "?? ???";
		GuiOtherHelp	= "??? ??? ???";
		GuiPercentsHeader	= "Auctioneer ??? ???";
		GuiPercentsHelp	= "??: ?? ??? ?? ????? ?? ????. ?? ????? ??? ????? Auctioneer? ?? ??? ??? ???? ?? ????.";
		GuiPrintin	= "??? ??? ??? ??";
		GuiProtectWindow	= "??? ??? ? ?? ??";
		GuiRedo	= "?? ?? ?? ??";
		GuiReloadui	= "??? ????? ???";
		GuiReloaduiButton	= "UI???";
		GuiReloaduiFeedback	= "WoW UI? ??? ???";
		GuiReloaduiHelp	= "? ?? ??? ?? ?? ??? ??? ?? WoW ??? ?????? ?? ???? ?? ? ?? ??????.\n??: ? ??? ?? ?? ?? ? ????.";
		GuiRememberText	= "?? ??";
		GuiStatsEnable	= "?? ??";
		GuiStatsHeader	= "??? ?? ??";
		GuiStatsHelp	= "??? ?? ???? ?????.";
		GuiSuggest	= "??? ??";
		GuiUnderlow	= "?? ?? ??? ??";
		GuiUndermkt	= "Maxless? ? ??? ???";
		GuiVerbose	= "?? ??";
		GuiWarnColor	= "?? ?? ??";


		-- Section: Conversion Messages
		MesgConvert	= "Auctioneer ??????? ??? ?????. SavedVariables\\Auctioneer.lua ??? ?? ?????? ?????.%s%s";
		MesgConvertNo	= "Auctioneer ????";
		MesgConvertYes	= "??";
		MesgNotconverting	= "??????? ???? ?????. ??? ??? ?? ??? Auctioneer? ???? ?? ????.";


		-- Section: Game Constants
		TimeLong	= "??";
		TimeMed	= "??";
		TimeShort	= "??";
		TimeVlong	= "???";


		-- Section: Generic Messages
		ConfirmBidBuyout	= "%dx%s|1?;?; ??? %s???????\n??: ";
		DisableMsg	= "Auctioneer ???? ???? ????";
		FrmtWelcome	= "Auctioneer v%s ???.";
		MesgNotLoaded	= "Auctioneer ???? ??. ? ?? ??? ??? /auctioneer ?? ?????.";
		StatAskPriceOff	= "????? ???????.";
		StatAskPriceOn	= "????? ??????.";
		StatOff	= "?? ?? ???? ???? ??";
		StatOn	= "??? ?? ??? ??";


		-- Section: Generic Strings
		TextAuction	= "??";
		TextCombat	= "??";
		TextGeneral	= "??";
		TextNone	= "??";
		TextScan	= "??";
		TextUsage	= "???:";


		-- Section: Help Text
		HelpAlso	= "?? ????? ??? ??? ?????. ???? ??? ??? ???. ??: \"/auctioneer also ???-?????\". ?? ???? \"???\"? ?? ??? ????, \"?\"? ??? ???.";
		HelpAskPrice	= "????? ??? ?? ???????.";
		HelpAskPriceAd	= "??? ???? ??? ??? ??? ?? ???????.";
		HelpAskPriceGuild	= "?? ????? ??? ??? ?????.";
		HelpAskPriceParty	= "?? ????? ??? ??? ?????.";
		HelpAskPriceSend	= "???? ???? ??? ?? ??? ?????? ?????.";
		HelpAskPriceSmart	= "????? ??? ??? ?? ???????.";
		HelpAskPriceTrigger	= "????? ??? ??? ?????.";
		HelpAskPriceVendor	= "?? ?? ???? ??? ??? ?? ???????.";
		HelpAskPriceWhispers	= "????? ?? ??? ???? ??? ?? ???????.";
		HelpAskPriceWord	= "????? ?? ?????? ????? ?????.";
		HelpAuctionClick	= "??? ?? ???? Alt-???? ???? ??? ???? ???.";
		HelpAuctionDuration	= "??? ?? ?? ?? ?? ??? ?????.";
		HelpAutofill	= "??? ?? ???? ????? ???? ??? ???? ?????.";
		HelpAverage	= "???? ?? ??? ?? ??? ?????.";
		HelpBidbroker	= "?? ??? ??? ?? ??? ???? ?? ?? ??? ??? ?????.";
		HelpBidLimit	= "?? ?? ??? ?? ?? ?? ?? ??? ?? ??? ? ?? ?? ?? ??? ???? ?? ??";
		HelpBroker	= "?? ??? ???? ?? ? ?? ??? ??? ??? ???? ?? ?????.";
		HelpClear	= "?? ???? ?? ??? ?????. (??? Shift ??? ?? ???? ???? ???????.) ?? \"??\" ?? \"??\" ???? ???? ????.";
		HelpCompete	= "?? ??? ???? ???? ?? ?? ???? ?? ???? ?????.";
		HelpDefault	= "Auctioneer? ??? ????? ?????. \"??\" ???? ??? ?? ??? ????? ??? ? ????.";
		HelpDisable	= "?? ??? ?? ???? Auctioneer? ???? ????.";
		HelpEmbed	= "?? ?? ??? ???? ?????.(??: ??? ???? ?? ??? ???????.)";
		HelpEmbedBlank	= "??? ?? ??? ??? ? ?? ??? ?? ?? ??? ? ?? ???.";
		HelpFinish	= "?? ??? ??? ???? ???? ?? ??? ???? ?????.";
		HelpFinishSound	= "?? ??? ??? ??? ?????.";
		HelpLink	= "??? ?? ???? ?????.";
		HelpLoad	= "Auctioneer ?? ??? ?????.";
		HelpLocale	= "??? ??? ??? ???? ?? ??? ?????.";
		HelpMedian	= "???? ?? ??? ???? ?????.";
		HelpOnoff	= "?? ??? ??? ??? ???.";
		HelpPctBidmarkdown	= "Auctioneer? ?? ????? ?? ??? ??? ??? ?????.";
		HelpPctMarkup	= "?? ?? ?? ? ?? ??? ??? ?????.";
		HelpPctMaxless	= "???? ?? Auctioneer? ???? ??? ?? ??? ?????.";
		HelpPctNocomp	= "??? ?? ? Auctioneer? ???? ??? ?????.";
		HelpPctUnderlow	= "Auctioneer? ?? ?? ???? ??? ??? ?????.";
		HelpPctUndermkt	= "(maxless? ??) ???? ?? ? ?? ? ?? ??? ??? ??.";
		HelpPercentless	= "?? ??? ?? ?????? ?? ???? ?? ??????? ?? ??? ??? ??? ?????.";
		HelpPrintin	= "Auctioneer? ???? ??? ?? ?????. ?????? ?????? ???? ????.";
		HelpProtectWindow	= "??? ??? ?? ?? ?? ?????.";
		HelpRedo	= "?? ? ??? ?? ???? ?? ??? ?? ?? ?? ??? ????? ?????.";
		HelpScan	= "??? ??? ?? ? ?? ???? ?? ??(????? ??? ????.) ??? ??? ?????. ??? ??? ?? ??? ??????.";
		HelpStats	= "???? ??/?? ?? ??? ?? ??? ?????.";
		HelpSuggest	= "???? ?? ??? ?? ??? ?????.";
		HelpUpdatePrice	= "??? ??? ?? ???? ???? ???? ?? ???? ???? ?????.";
		HelpVerbose	= "?? ??? ?? ??? ???? ?????.(\"?\"?? ?? ??? ?????.)";
		HelpWarnColor	= "?? ??? ?? ??(?? ?)? ???? ???? ?????.";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "?? ??? ?? ? ??? ??";
		FrmtNotEnoughOfItem	= "?? ??? ?? %s|1?;?; ???? ????.";
		FrmtPostedAuction	= "%s (x%d) 1?? ???????.";
		FrmtPostedAuctions	= "%d?? %s (x%d) ??? ???????.";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "????";
		FrmtBidbrokerDone	= "?? ?? ??";
		FrmtBidbrokerHeader	= "?? ??: %s, HSP = '?? ?????'";
		FrmtBidbrokerLine	= "%s, ?? %s? ???, ?? ?????(HSP): %s, %s: %s, ??: %s, ??: %s";
		FrmtBidbrokerMinbid	= "????";
		FrmtBrokerDone	= "?? ?? ??";
		FrmtBrokerHeader	= "?? ??: %s, HSP = '?? ?????'";
		FrmtBrokerLine	= "%s, ?? %s? ???, ?? ?????(HSP): %s, ?? ???(BO): %s, ??: %s";
		FrmtCompeteDone	= "?? ?? ?? ??.";
		FrmtCompeteHeader	= "??? ??? ? %s ??? ?? ??? ??.";
		FrmtCompeteLine	= "%s, ??: %s, ?? ???(BO) %s ? %s, %s ??";
		FrmtHspLine	= "%s ?? ?? ??????: %s";
		FrmtLowLine	= "%s, ?? ???: %s, ???: %s, ??: %s, ??? ??: %s";
		FrmtMedianLine	= "?? %d? ???, %s ? ?? ?? ??? ???: %s";
		FrmtNoauct	= "?? ???? ?? ?? ? ??: %s";
		FrmtPctlessDone	= "???? ?? ??.";
		FrmtPctlessHeader	= "?? ?????(HSP)?? ?? ??: %d%%";
		FrmtPctlessLine	= "%s, ?? %d? ???, ?? ?????(HSP): %s, ?? ???(BO): %s, ??: %s, %s ??";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "??? ?? ?? ?? ??: %s";
		AuctionDiscrepancies	= "???? ??: %s";
		AuctionNewAucts	= "??? ??? ?? ?? ??: %s";
		AuctionOldAucts	= "??? ??? ?? ?? ??: %s";
		AuctionPageN	= "Auctioneer: %s %d/%d ??? ?? ?? ???: %s ?? ?? ??: %s";
		AuctionScanDone	= "Auctioneer: ?? ?? ?? ??";
		AuctionScanNexttime	= "??? ???? ??? ?, Auctioneer? ?? ??? ? ????.";
		AuctionScanNocat	= "??? ?? ??? ?? ??? ??? ????? ???.";
		AuctionScanRedo	= "?? ???? ????? %d ? ??? ?????. ???? ??????.";
		AuctionScanStart	= "Auctioneer: %s ??? 1 ???...";
		AuctionTotalAucts	= "??? ?? ?? ? ??: %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "%s?? %d? ???";
		FrmtInfoAverage	= "?? %s/%s ?? ??? (%s? ??)";
		FrmtInfoBidMulti	= "?? (%s%s ?)";
		FrmtInfoBidOne	= "?? %s";
		FrmtInfoBidrate	= "?? ?? %d%%, ?? ?? ?? %d%%";
		FrmtInfoBuymedian	= "?? ??? ???";
		FrmtInfoBuyMulti	= "?? ??? (%s%s ?)";
		FrmtInfoBuyOne	= "?? ??? %s";
		FrmtInfoForone	= "??: ?? %s/%s ?? ??? (%s ??) [%d?? ?? ?]";
		FrmtInfoHeadMulti	= "%d?? ??:";
		FrmtInfoHeadOne	= "??:";
		FrmtInfoHistmed	= "?? %d, ?? ??? ??? (?)";
		FrmtInfoMinMulti	= "?? ??? (%s ?)";
		FrmtInfoMinOne	= "?? ???";
		FrmtInfoNever	= "%s?? ???? ??";
		FrmtInfoSeen	= "?? ???? %d? ???";
		FrmtInfoSgst	= "?? ??: ?? %s /%s ?? ???";
		FrmtInfoSgststx	= "%d ?? ?? ?? ??: ??? %s/ ?? ??? %s";
		FrmtInfoSnapmed	= "%d? ???, ?? ??? ??? (?)";
		FrmtInfoStacksize	= "?? ? ?? ??: %d?";


		-- Section: User Interface
		BuySortTooltip	= "?? ??????? ?????. (??? ???? ????? SHIFT? ??? ????)";
		ClearTooltip	= "???? ???? ?????.";
		FrmtLastSoldOn	= "?? ??? : %s";
		RefreshTooltip	= "?? ???? ?? ?????.";
		UiBid	= "??";
		UiBidHeader	= "??";
		UiBidPerHeader	= "?? ??";
		UiBuyout	= "?? ??";
		UiBuyoutHeader	= "?? ??";
		UiBuyoutPerHeader	= "?? ?? ??";
		UiBuyoutPriceLabel	= "?? ???";
		UiBuyoutPriceTooLowError	= "(?? ??)";
		UiCategoryLabel	= "?? ??:";
		UiDepositLabel	= "???";
		UiDurationLabel	= "?? ??";
		UiItemLevelHeader	= "??";
		UiMakeFixedPriceLabel	= "?? ??";
		UiMaxError	= "(%d ??)";
		UiMaximumPriceLabel	= "???:";
		UiMaximumTimeLeftLabel	= "?? ?? ??";
		UiMinimumPercentLessLabel	= "?? ?? ??:";
		UiMinimumProfitLabel	= "?? ??";
		UiMinimumQualityLabel	= "?? ??:";
		UiMinimumUndercutLabel	= "?? ??:";
		UiNameHeader	= "??";
		UiNoPendingBids	= "?? ?? ??? ???????!";
		UiNotEnoughError	= "(???? ??)";
		UiPendingBidInProgress	= "1?? ?? ?? ???...";
		UiPendingBidsInProgress	= "%d?? ?????? ?? ?? ???...";
		UiPercentLessHeader	= "%";
		UiPost	= "??";
		UiPostAuctions	= "?? ??";
		UiPriceBasedOnLabel	= "?? ??:";
		UiPriceModelAuctioneer	= "Auctioneer ??";
		UiPriceModelCustom	= "??? ??";
		UiPriceModelFixed	= "??? ??";
		UiPriceModelLastSold	= "?? ???";
		UiProfitHeader	= "??";
		UiProfitPerHeader	= "?? ??";
		UiQuantityHeader	= "??";
		UiQuantityLabel	= "??:";
		UiRemoveSearchButton	= "??";
		UiSavedSearchLabel	= "??? ????:";
		UiSaveSearchButton	= "??";
		UiSaveSearchLabel	= "?? ?? ??:";
		UiSearch	= "??";
		UiSearchAuctions	= "?? ??";
		UiSearchDropDownLabel	= "??";
		UiSearchForLabel	= "????? ??:";
		UiSearchTypeBids	= "??";
		UiSearchTypeBuyouts	= "?? ??";
		UiSearchTypeCompetition	= "??";
		UiSearchTypePlain	= "???";
		UiStacksLabel	= "??";
		UiStackTooBigError	= "(??? ?? ?)";
		UiStackTooSmallError	= "(??? ?? ??)";
		UiStartingPriceLabel	= "?? ???:";
		UiStartingPriceRequiredError	= "(???)";
		UiTimeLeftHeader	= "?? ??";
		UiUnknownError	= "(????)";

	};

	nlNL = {


		-- Section: AskPrice Messages
		AskPriceAd	= "Verkrijg stapel prijzen met %sx[ItemLink] (x = stapelprijs)";
		FrmtAskPriceBuyoutMedianHistorical	= "%sOpkoop-mediaan historisch: %s%s";
		FrmtAskPriceBuyoutMedianSnapshot	= "%sOpkoop-mediaan laatste scan: %s%s";
		FrmtAskPriceDisable	= "AskPrice's %s optie uitgeschakeld";
		FrmtAskPriceEach	= "(%s ieder)";
		FrmtAskPriceEnable	= "AskPrice's %s optie ingeschakeld";
		FrmtAskPriceVendorPrice	= "%sVerkoop aan winkelier voor: %s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "Veiling-id %s verwijderd van huidige AH momentopname.";
		FrmtAuctinfoHist	= "%d historisch";
		FrmtAuctinfoLow	= "Momentopname Laag";
		FrmtAuctinfoMktprice	= "Marktprijs";
		FrmtAuctinfoNolow	= "Item niet gezien in laatste Momentopname";
		FrmtAuctinfoOrig	= "Oorspronkelijk Bod";
		FrmtAuctinfoSnap	= "%d laatste scan";
		FrmtAuctinfoSugbid	= "Startbod";
		FrmtAuctinfoSugbuy	= "Opkoop voorstel";
		FrmtWarnAbovemkt	= "Competitie boven de markt";
		FrmtWarnMarkup	= "Winkelprijs opgehoogd met %s%%";
		FrmtWarnMyprice	= "Gebruik mijn huidige prijs";
		FrmtWarnNocomp	= "Geen concurrentie";
		FrmtWarnNodata	= "Geen gegevens voor HVP";
		FrmtWarnToolow	= "Kan de laagste prijs niet matchen";
		FrmtWarnUndercut	= "Onderbieden met %s%%";
		FrmtWarnUser	= "Gebruik gebruikersprijs";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "Al hoogste bieder op veiling: %s (x%d)";
		FrmtBidAuction	= "Geboden op veiling: %s (x%d)";
		FrmtBidQueueOutOfSync	= "Error: ongesynchroniseerde bod rij";
		FrmtBoughtAuction	= "Veiling opgekocht: %s (x%d)";
		FrmtMaxBidsReached	= "Meer veilingen van %s (x%d) gevonden, maar bodlimiet bereikt (%d)";
		FrmtNoAuctionsFound	= "Geen veilingen gevonden: %s (x%d)";
		FrmtNoMoreAuctionsFound	= "Geen verdere veilingen gevonden: %s (x%d)";
		FrmtNotEnoughMoney	= "Niet genoeg geld om te bieden op veiling: %s (x%d)";
		FrmtSkippedAuctionWithHigherBid	= "Veiling met hoger bod overgeslagen: %s (x%d)";
		FrmtSkippedAuctionWithLowerBid	= "Veiling met lager bod overgeslagen: %s (x%d)";
		FrmtSkippedBiddingOnOwnAuction	= "Bieden op eigen veiling overgeslagen: %s (x%d)";
		UiProcessingBidRequests	= "Bezig biedingen te verwerken...";


		-- Section: Command Messages
		ConstantsCritical	= "KRITIEK: Je Auctioneer SavedVariables bestand is %.3f%% vol!";
		ConstantsMessage	= "Je Auctioneer SavedVariables bestand is %.3f%% vol";
		ConstantsWarning	= "WAARSCHUWING: Je Auctioneer SavedVariables bestand is %.3f%% vol";
		FrmtActClearall	= "Alle veiling-gegevens voor %s worden verwijderd";
		FrmtActClearFail	= "Kan item niet vinden: %s";
		FrmtActClearOk	= "Veiling-gegevens voor item verwijderd: %s";
		FrmtActClearsnap	= "Bezig huidige AH momentopname te wissen";
		FrmtActDefault	= "Auctioneers %s optie is hersteld naar zijn standaardwaarde";
		FrmtActDefaultall	= "Alle Auctioneer opties zijn hersteld naar de standaardwaarden.";
		FrmtActDisable	= "Verberg item's %s gegevens";
		FrmtActEnable	= "Toon item's %s gegevens";
		FrmtActSet	= "%s op '%s' gezet";
		FrmtActUnknown	= "Onbekend commando of sleutelwoord: '%s'";
		FrmtAuctionDuration	= "Standaard veilingduur ingesteld op: %s";
		FrmtAutostart	= "Automatisch veiling gemaakt voor %s: %s minimum, %s buyout (%d uur) %s";
		FrmtFinish	= "Nadat een scan is afgelopen, zullen we %s";
		FrmtPrintin	= "Auctioneers berichten worden nu naar het \"%s\" chat frame geprint";
		FrmtProtectWindow	= "AH-venster bescherming ingesteld op: %s";
		FrmtUnknownArg	= "'%s' is geen geldig argument voor '%s'";
		FrmtUnknownLocale	= "De opgegeven taal ('%s') is onbekend. Geldige talen zijn:";
		FrmtUnknownRf	= "Ongeldige parameter ('%s'). De parameter moet zo geformatteerd zijn: [realm]-[faction]. Bijvoorbeeld: Al'Akir-Horde";


		-- Section: Command Options
		OptAskPriceSend	= "(<SpelerNaam> <AskPrice Vraag>)";
		OptBidbroker	= "<opbrengst in zilver>";
		OptBidLimit	= "<nummer>";
		OptBroker	= "<opbrengst in zilver>";
		OptCompete	= "<verschil in zilver>";
		OptLocale	= "<taal>";
		OptPctBidmarkdown	= "<procent>";
		OptPctMarkup	= "<procent>";
		OptPctMaxless	= "<procent>";
		OptPctNocomp	= "<procent>";
		OptPctUnderlow	= "<procent>";
		OptPctUndermkt	= "<procent>";
		OptPercentless	= "<procent>";
		OptPrintin	= "(<frameIndex>[Nummer]|<frameNaam>[Tekst])";
		OptScale	= "<schaalfactor>";
		OptScan	= "<>";


		-- Section: Commands
		CmdAskPriceSend	= "stuur";
		CmdAskPriceWhispers	= "fluister berichten";
		CmdAskPriceWord	= "woord";
		CmdFinishSound	= "einde geluid";


		-- Section: Config Text
		GuiAlso	= "Toon ook gegevens voor";
		GuiAlsoDisplay	= "Gegevens voor %s worden getoond";
		GuiAlsoOff	= "Andere realm-faction gegevens worden niet meer getoond.";
		GuiAlsoOpposite	= "Gegevens voor tegengestelde faction worden nu ook getoond.";
		GuiAskPrice	= "Gebruik AskPrice";
		GuiAskPriceAd	= "Stuur nieuwe features";
		GuiAskPriceGuild	= "Reageer op guildchat vragen";
		GuiAskPriceHeader	= "AskPrice opties";
		GuiAskPriceHeaderHelp	= "Verander AskPrice's gedrag";
		GuiAskPriceParty	= "Reageer op partychat vragen";
		GuiAskPriceSmart	= "Gebruik smartwords";
		GuiAskPriceTrigger	= "VraagPrijs trigger";
		GuiAskPriceVendor	= "Verstuur verkoper info";
		GuiAskPriceWhispers	= "Toon uitgaande priv�berichten";
		GuiAskPriceWord	= "Custom SmartWord %d";
		GuiAuctionDuration	= "Standaard veiling duur";
		GuiAuctionHouseHeader	= "Veiling venster";
		GuiAuctionHouseHeaderHelp	= "Verander de standaard instellingen van het veiling venster";
		GuiAutofill	= "Vul prijzen in de AH automatisch aan";
		GuiAverages	= "Toon gemiddelden";
		GuiBidmarkdown	= "Bod verlaag percentage";
		GuiClearall	= "Verwijder alle auctioneer data";
		GuiClearallButton	= "Verwijder alles";
		GuiClearallHelp	= "Klik hier om alle auctioneer data voor de huidige realm te verwijderen";
		GuiClearallNote	= "voor de huidige server-factie";
		GuiClearHeader	= "Verwijder data";
		GuiClearHelp	= "Verwijdert auctioneer data. Selecteer alle data of de laatste scan. WAARSCHUWING: Deze acties zijn onomkeerbaar";
		GuiClearsnap	= "Verwijder scan data";
		GuiClearsnapButton	= "Verwijder scan";
		GuiClearsnapHelp	= "Klik hier om de data van de laatste scan te verwijderen";
		GuiDefaultAll	= "Herstel alle auctioneer opties";
		GuiDefaultAllButton	= "Herstel alles";
		GuiDefaultAllHelp	= "Klik hier om alle auctioneer opties te herstellen naar de originele waarden. WAARSCHUWING: Deze actie is onomkeerbaar.";
		GuiDefaultOption	= "Herstel deze instelling";
		GuiEmbed	= "Intergreer info in de in-game tooltip";
		GuiEmbedBlankline	= "Toon een lege regel in de in-game tooltip";
		GuiEmbedHeader	= "Intergreer";
		GuiFinish	= "Nadat een scan is voltooid";
		GuiFinishSound	= "Speel geluid na het voltooien van een scan";
		GuiLink	= "Toon linkID";
		GuiLoad	= "Laad Auctioneer";
		GuiLoad_Always	= "altijd";
		GuiLoad_AuctionHouse	= "bij het veilinghuis";
		GuiLoad_Never	= "nooit";
		GuiLocale	= "Stel de localisering in op";
		GuiMainEnable	= "Gebruik Auctioneer";
		GuiMainHelp	= "Bevat instellingen voor auctioneer, een AddOn die item info toont en auctionhouse data analiseert. Klik de 'scan' knop bij de auctionhouse om veiling gegevens te verzamelen";
		GuiMarkup	= "Verkoper prijs ophoog percentage";
		GuiMaxless	= "Max markt onderbod percentage";
		GuiMedian	= "Toon gemiddelden";
		GuiNocomp	= "Onderbod percentage zonder concurentie";
		GuiNoWorldMap	= "Auctioneer: Tonen van de wereldkaart onderdrukt";
		GuiOtherHeader	= "Andere opties";
		GuiOtherHelp	= "Andere auctioneer opties";
		GuiPercentsHeader	= "Auctioneer grens percentages";
		GuiPercentsHelp	= "WAARSCHUWING: De volgende instellingen zijn ALLEEN voor ervaren gebruikers. Pas de volgende waarden aan om te veranderen hoe aggressief auctioneer is bij het bepalen van winstgevende waarden";
		GuiPrintin	= "Selecteer het gewenste berichtscherm";
		GuiProtectWindow	= "Voorkom per ongeluk sluiten van het AH venster";
		GuiRedo	= "Toon langdurige scan waarschuwing";
		GuiReloadui	= "Herlaad gebruikers interface";
		GuiReloaduiButton	= "ReloadUI";
		GuiReloaduiFeedback	= "Nu de WoW UI aan het herladen";
		GuiReloaduiHelp	= "Klik hier om de WOW Gebruikers interface te herladen na het aanpassen van de localisatie zodat de taal in dit configuratiescherm gelijk wordt aan de gekozen taal. Let op: Dit kan enkele minuten duren.";
		GuiRememberText	= "Onthoud prijs";
		GuiStatsEnable	= "Toon statistieken";
		GuiStatsHeader	= "Item prijs statistieken";
		GuiStatsHelp	= "Toon de volgende statistieken in de tooltip";
		GuiSuggest	= "Toon geadviseerde prijs";
		GuiUnderlow	= "Laagste veiling onderbod";
		GuiUndermkt	= "Onderbied de maxloze markt";
		GuiVerbose	= "Verbose modus";
		GuiWarnColor	= "Kleur prijzenmodel";


		-- Section: Conversion Messages
		MesgConvert	= "Auctioneer Database Conversie. Backup uw SavedVariables\\Auctioneer.lua eerst. %s%s";
		MesgConvertNo	= "Uitschakelen van Auctioneer";
		MesgConvertYes	= "Converteer";
		MesgNotconverting	= "Auctioneer converteert uw database niet. Het zal dan ook niet functioneren totdat u dit wel doet.";


		-- Section: Game Constants
		TimeLong	= "Lang";
		TimeMed	= "Gemiddeld";
		TimeShort	= "Kort";
		TimeVlong	= "Zeer Lang";


		-- Section: Generic Messages
		ConfirmBidBuyout	= "Weet je zeker dat je dit wilt %s?\n%dx%s voor:";
		DisableMsg	= "Automatisch laden van Auctioneer uitgeschakeld";
		FrmtWelcome	= "Auctioneer v%s geladen";
		MesgNotLoaded	= "Auctioneer is niet geladen. Type /auctioneer voor meer info.";
		StatAskPriceOff	= "AskPrice is nu uitgeschakeld.";
		StatAskPriceOn	= "AskPrice is nu ingeschakeld.";
		StatOff	= "Veiling-gegevens worden niet weergegeven";
		StatOn	= "Ingestelde veiling-gegevens worden weergegeven";


		-- Section: Generic Strings
		TextAuction	= "veiling";
		TextCombat	= "Gevecht";
		TextGeneral	= "Algemeen";
		TextNone	= "geen";
		TextScan	= "Scan";
		TextUsage	= "Gebruik:";


		-- Section: Help Text
		HelpAlso	= "Toon ook gegevens van een andere server in de tooltip. Vul bij 'realm' de realmnaam in en bij 'faction' de naam van de faction. Bijvoorbeeld: \"/auctioneer also Al'Akir-Horde\". Het speciale sleutelwoord \"opposite\" betekent de andere faction, \"off\" schakelt de functionalitiet uit.";
		HelpAskPrice	= "Zet AskPrice aan of uit.";
		HelpAskPriceAd	= "Zet de nieuwe reclame-feature van AskPrice aan of uit.";
		HelpAskPriceGuild	= "Reageer op vragen in de guildchat.";
		HelpAskPriceParty	= "Reageer op vragen in de partychat.";
		HelpAskPriceSend	= "Stuur een speler handmatig het resultaat van een AskPrice vraag.";
		HelpAskPriceSmart	= "Zet SmartWords controle aan of uit.";
		HelpAskPriceTrigger	= "Verander het trigger-karakter van AskPrice.";
		HelpAskPriceVendor	= "Zet het verzenden van verkoper gegevens aan of uit.";
		HelpAskPriceWhispers	= "Zet het verbergen van alle uitgaande AskPrice priv�berichten aan of uit.";
		HelpAskPriceWord	= "Voeg persoonlijke AskPrice SmartWords toe of verander ze.";
		HelpAuctionClick	= "Stelt je in staat automatisch een veiling te beginnen voor een item in je inventaris door Alt-Klik.";
		HelpAuctionDuration	= "Stel de standaard veilingduur in met het openen van het AH venster";
		HelpAutofill	= "Stel in of prijzen automatisch ingevuld moeten worden wanneer er een item op de AH wordt gezet.";
		HelpAverage	= "Selecteer of de gemiddelde veilingprijs van items getoond moet worden";
		HelpBidbroker	= "Toon kort of gemiddeld durende veilingen van de recente scan waar met een bod winst te behalen is.";
		HelpBidLimit	= "Maximum aantal veilingen om op te bieden of op te kopen wanneer op de bod- of opkoopknop wordt geklikt in het Zoek Veilingen tabblad.";
		HelpBroker	= "Toon veilingen van de recentste scan waar op geboden kan worden om door te verkopen met winst.";
		HelpClear	= "Wis de data voor het aangegeven item (voeg de items in het commando met shift-klik). Je kunt ook de speciale sleutelwoorden \"all\" of \"snapshot\" aangeven.";
		HelpCompete	= "Toon alle recent gescande veilingen waarvan de opkoopprijs minder is dan die van een van jouw items.";
		HelpDefault	= "Zet een Auctioneer-optie op zijn standaardwaarde. Je kunt ook het speciale keyword \"all\" gebruiken om alle Auctioneer-opties op hun standaardwaarde te zetten.";
		HelpDisable	= "Stopt het automatisch laden van Auctioneer de volgende keer dat je inlogt.";
		HelpEmbed	= "Integreer de tekst in het originele spel tooltip (NB.: Bepaalde features worden uitgezet wanneer dit geselecteerd is)";
		HelpEmbedBlank	= "Selecteer of een lege regel getoond moet worden tussen de tooltip info en de auction info als embedded mode aan staat.";
		HelpFinish	= "Geef aan of World of Warcraft automatich moet afsluiten als het Scannen van het veilinghuis compleet is.";
		HelpFinishSound	= "Zet het spelen van een geluid aan aan het einde van een Auction House scan.";
		HelpLink	= "Selecteer of het link id in de tooltip getoond moet worden";
		HelpLoad	= "Verander Auctioneer's laad settings voor dit karakter.";
		HelpLocale	= "Verander de taal die gebruikt wordt om Auctioneer berichten te tonen.";
		HelpMedian	= "Selecteer dat de median buyout prijs van het item wordt getoond.";
		HelpOnoff	= "Zet het tonen van veilinggegevens aan en uit.";
		HelpPctBidmarkdown	= "Zet het percentage waarmee Auctioneer de bid-prijs onder de buyout prijs noteert.";
		HelpPctMarkup	= "Het percentage waarmee vendor prijzen hoger genoteerd worden wanneer geen andere waarden beschikbaar zijn";
		HelpPctMaxless	= "Legt percentage vast tot waar Auctioneer de markt prijs blijft onderbieden voordat het opgeeft";
		HelpPctNocomp	= "Het percentage waarmee Auctioneer onder de marktprijs bied als er geen concurentie is";
		HelpPctUnderlow	= "Legt het percentage vast waarmee Auctioneer onder de laagste auction prijs bied";
		HelpPctUndermkt	= "Percentage waarmee de marktprijs onderboden wordt wanneer de prijs van de concurentie niet meer onderboden kan worden (vanwege maxless)\n";
		HelpPercentless	= "Toon alle recent gescande veilingen waarvan de opkoopprijs een bepaald percentage minder is dan de maximale verkoopprijs.";
		HelpPrintin	= "Selecteer in welk frame Auctioneer zijn berichten toont. Je kunt of de naam van het frame of de index aangeven.";
		HelpProtectWindow	= "Voorkom dat je perongeluk het veilinghuis interface sluit";
		HelpRedo	= "Selecteer of je een waarschuwing wilt krijgen als de te scennen pagina van het veilinghuis er te lang over doet door een server probleem (Server Lag)";
		HelpScan	= "Doe een Veilinghuis scan bij het eerstvolgende bezoek aan het veilinghuis, of gelijk als je er al bent (er is ook een knop in het veilinghuis paneel) Kies welke catagorieen je wild scannen met de checkboxen (naast de catagorieen)";
		HelpStats	= "Selecteer of je het bod of opkoop percentage van items wilt zien.";
		HelpSuggest	= "Selecteer of je de adviesprijs wilt zien.";
		HelpUpdatePrice	= "Past automatisch de startprijs aan van een veiling in de \"plaats veiling tab\" als de opkoop prijs verandert";
		HelpVerbose	= "Selecteerd of gemiddelden en suggesties voledig getoond moeten worden (of off om ze op een enkele regel te tonen).\n";
		HelpWarnColor	= "Selecteer of het huidige AH prijs model (b.v. Undercutting by...) getoond moet worden in intuitieve kleuren.\n";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "Geen lege ruimte gevonden om veiling te starten!";
		FrmtNotEnoughOfItem	= "Niet genoeg %s gevonden om veiling te starten!";
		FrmtPostedAuction	= "1 Veiling van %s (x%d) geplaatst";
		FrmtPostedAuctions	= "%d veilingen van %s (x%d) geplaatst";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "HuidigBod";
		FrmtBidbrokerDone	= "Bod bepalen voltooid";
		FrmtBidbrokerHeader	= "Minimum winst: %s, HVP ='Hoogst Verkoopbare Prijs'";
		FrmtBidbrokerLine	= "%s, Laatst %s gezien, HVP: %s, %s, Winst: %s, Tijd: %s";
		FrmtBidbrokerMinbid	= "MinBod";
		FrmtBrokerDone	= "Prijsbepaling voltooid";
		FrmtBrokerHeader	= "Minimale winst: %s, HVP ='Hoogst Verkoopbare Prijs'";
		FrmtBrokerLine	= "%s, Laatst %s gezien, HVP: %s, BO: %s, Winst: %s";
		FrmtCompeteDone	= "Concurerende veilingen voltooid";
		FrmtCompeteHeader	= "Concurerende veilingen ten minste %s minder per item";
		FrmtCompeteLine	= "%s, Bod: %s, BO %s vs %s, %s minder";
		FrmtHspLine	= "Hoogst Verkoopbare Prijs voor 1 %s is: %s";
		FrmtLowLine	= "%s, BO: %s, Verkopen: %s, Voor 1: %s, Minder dan gemiddeld: %s";
		FrmtMedianLine	= "Van de laatste %d gezien, gemiddelde BO voor 1 %s is: %s";
		FrmtNoauct	= "Geen veilingen gevonden voor item: %s";
		FrmtPctlessDone	= "Procenten minder voltooid";
		FrmtPctlessHeader	= "Procent minder dan Hoogst verkoopbare prijs (HVP): %d%%";
		FrmtPctlessLine	= "%s, Laatste %d gezien, HVP: %s, BO: %s, Winst: %s, Minder: %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "Niet meer bestaande veilingen verwijderd: %s";
		AuctionDiscrepancies	= "Discrepanties: %s";
		AuctionNewAucts	= "Nieuwe veilingen gescand: %s";
		AuctionOldAucts	= "Eerder gescand: %s";
		AuctionPageN	= "Auctioneer: scannen van %s pagina %d van %d Veilingen per seconde: %s Verwachte tijdsduur: %s";
		AuctionScanDone	= "Auctioneer: veiling scan klaar";
		AuctionScanNexttime	= "Auctioneer zal een volledige scan uitvoeren de volgende keer dat gepraat wordt met een veilingmeester.";
		AuctionScanNocat	= "U moet tenminste ��n categorie hebben geselecteerd om te kunnen scannen.";
		AuctionScanRedo	= "Huidige pagina deed er meer dan %d secondes over om te laden, nieuwe poging.";
		AuctionScanStart	= "Auctioneer: scannen %s pagina 1...";
		AuctionTotalAucts	= "Totaal aantal veilingen gescand: %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "%d keer gezien voor %s";
		FrmtInfoAverage	= "%s min/%s BO (%s bod)";
		FrmtInfoBidMulti	= "Boden (%s%s ea)";
		FrmtInfoBidOne	= "Boden%s";
		FrmtInfoBidrate	= "%d%% hebben een bod, %d%% hebben BO";
		FrmtInfoBuymedian	= "BO gemiddelde";
		FrmtInfoBuyMulti	= "Buyout (%s%s ea)";
		FrmtInfoBuyOne	= "Buyout%s";
		FrmtInfoForone	= "Voor 1: %s min/%s BO (%s geboden) [in %d's]";
		FrmtInfoHeadMulti	= "Gemiddelden voor %d items:";
		FrmtInfoHeadOne	= "Gemiddelden voor dit item";
		FrmtInfoHistmed	= "Laatste %d, gemiddelde BO (ea)";
		FrmtInfoMinMulti	= "Begin bod (%s ea)";
		FrmtInfoMinOne	= "Begin bod";
		FrmtInfoNever	= "Nooit gezien in %s";
		FrmtInfoSeen	= "Totaal %d keer gezien bij de AH";
		FrmtInfoSgst	= "Geadviseerde prijs: %s min/%s BO";
		FrmtInfoSgststx	= "Geadviseerde prijs voor jouw %d stack: %s min/%s BO";
		FrmtInfoSnapmed	= "%d gescanned, gemiddelde BO (ea)";
		FrmtInfoStacksize	= "Gemiddelde stack grootte: %d items";


		-- Section: User Interface
		FrmtLastSoldOn	= "Laatst Verkocht op %s";
		UiBid	= "Bod";
		UiBidHeader	= "Bod";
		UiBidPerHeader	= "Bod Per";
		UiBuyout	= "Opkoop";
		UiBuyoutHeader	= "Opkoop";
		UiBuyoutPerHeader	= "Opkoop Per";
		UiBuyoutPriceLabel	= "Opkoopprijs:";
		UiBuyoutPriceTooLowError	= "(Te laag)";
		UiCategoryLabel	= "Categorie beperking:";
		UiDepositLabel	= "Storting:";
		UiDurationLabel	= "Duur:";
		UiItemLevelHeader	= "Lvl";
		UiMakeFixedPriceLabel	= "Maak vaste prijs";
		UiMaxError	= "(%d Max)";
		UiMaximumPriceLabel	= "Maximum Prijs:";
		UiMaximumTimeLeftLabel	= "Maximale Tijd Over:";
		UiMinimumPercentLessLabel	= "Laagste Verschil Percentage:";
		UiMinimumProfitLabel	= "Minimale Opbrengst:";
		UiMinimumQualityLabel	= "Minimum Kwaliteit:";
		UiMinimumUndercutLabel	= "Minimum Onderbieding:";
		UiNameHeader	= "Naam";
		UiNoPendingBids	= "Alle bodverzoeken compleet!";
		UiNotEnoughError	= "(Niet genoeg)";
		UiPendingBidInProgress	= "1 bodverzoek in behandeling...";
		UiPendingBidsInProgress	= "%d bodverzoeken in behandeling...";
		UiPercentLessHeader	= "Pct";
		UiPost	= "Plaats";
		UiPostAuctions	= "Plaats Veiling";
		UiPriceBasedOnLabel	= "Prijs Gebaseerd Op:";
		UiPriceModelAuctioneer	= "Auctioneer Prijs";
		UiPriceModelCustom	= "Eigen Prijs";
		UiPriceModelFixed	= "Vaste Prijs";
		UiPriceModelLastSold	= "Laatste verkoopprijs";
		UiProfitHeader	= "Winst";
		UiProfitPerHeader	= "Winst Per";
		UiQuantityHeader	= "Hoev.";
		UiQuantityLabel	= "Hoeveelheid:";
		UiRemoveSearchButton	= "Verwijder";
		UiSavedSearchLabel	= "Bewaarde zoekopdrachten:";
		UiSaveSearchButton	= "Bewaar";
		UiSaveSearchLabel	= "Bewaar deze zoekopdracht:";
		UiSearch	= "Zoek";
		UiSearchAuctions	= "Zoek Veilingen";
		UiSearchDropDownLabel	= "Zoek:";
		UiSearchForLabel	= "Zoek Naar Item:";
		UiSearchTypeBids	= "Biedingen";
		UiSearchTypeBuyouts	= "Opkopingen";
		UiSearchTypeCompetition	= "Concurrentie";
		UiSearchTypePlain	= "Item";
		UiStacksLabel	= "Stapels";
		UiStackTooBigError	= "(Stapel Te Groot)";
		UiStackTooSmallError	= "(Stapel Te Klein)";
		UiStartingPriceLabel	= "Start Prijs:";
		UiStartingPriceRequiredError	= "(Benodigd)";
		UiTimeLeftHeader	= "Tijd over";
		UiUnknownError	= "(Onbekend)";

	};

	ptPT = {


		-- Section: AskPrice Messages
		AskPriceAd	= "Obtenha pre�o da pilha com %sx[ItemLink] (x = stacksize) ";
		FrmtAskPriceBuyoutMedianHistorical	= "%sHist�rico m�dio das vendas: %s%s ";
		FrmtAskPriceBuyoutMedianSnapshot	= "%sHistorico medio do ultimo scan: %s%s ";
		FrmtAskPriceDisable	= "Desativar perguntar pre�o";
		FrmtAskPriceEach	= "(%s cada)";
		FrmtAskPriceEnable	= "Activar perguntar pre�o %s";
		FrmtAskPriceVendorPrice	= "%sVenda para fornecedor por: %s%s ";


		-- Section: Auction Messages
		FrmtActRemove	= "Removendo %s da image corrente da AH";
		FrmtAuctinfoHist	= "%d historial";
		FrmtAuctinfoLow	= "Pre�o mais baixo";
		FrmtAuctinfoMktprice	= "Pre�o de mercado";
		FrmtAuctinfoNolow	= "Objecto n�o visto no �ltimo leil�o";
		FrmtAuctinfoOrig	= "Oferta original";
		FrmtAuctinfoSnap	= "%d do �ltimo scan";
		FrmtAuctinfoSugbid	= "Oferta inicial";
		FrmtAuctinfoSugbuy	= "Pre�o de saida proposto";
		FrmtWarnAbovemkt	= "Pre�o acima do mercado";
		FrmtWarnMarkup	= "Colocando pre�o %s%% acima do vendedor";
		FrmtWarnMyprice	= "Usando pre�o actual";
		FrmtWarnNocomp	= "Sem competi��o";
		FrmtWarnNodata	= "Sem informa��oo para pre�o mais alto";
		FrmtWarnToolow	= "Impossivel igualar pre�o minimo";
		FrmtWarnUndercut	= "Baixando o pre�o em %s%%";
		FrmtWarnUser	= "Usando o seu pre�o actual";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "Esse bid � teu: %s (x%d) ";
		FrmtBidAuction	= "Bid no leil�o: %s (x%d)";
		FrmtBidQueueOutOfSync	= "Error: Bid queue out of sync!\nErro: Fila de ofertas fora de sincronia!";
		FrmtBoughtAuction	= "Leil�o comprado: %s (x%d)";
		FrmtMaxBidsReached	= "Mais auctions de %s (x%d)encontrado, mas ofere�a o limite alcan�ado (%d)";
		FrmtNoAuctionsFound	= "Nenhum leil�o encontrado: %s (x%d)";
		FrmtNoMoreAuctionsFound	= "N�o mais auctions encontrados: %s (x%d)";
		FrmtNotEnoughMoney	= "N�o bastante dinheiro a oferecer no auction: %s (x%d)";
		FrmtSkippedAuctionWithHigherBid	= "Auction saltado com oferta mais elevada:  %s (x%d)";
		FrmtSkippedAuctionWithLowerBid	= "Auction saltado com oferta mais elevada: %s (x%d)";
		FrmtSkippedBiddingOnOwnAuction	= "Oferecer saltado em pr�prio auction: %s (x%d)";
		UiProcessingBidRequests	= "Processando pedidos oferecidos...";


		-- Section: Command Messages
		FrmtActClearall	= "Removendo todos dados para o leilão %s";
		FrmtActClearFail	= "Impossivel encontrar o objeto: %s";
		FrmtActClearOk	= "Removida a informação para o objecto %s";
		FrmtActClearsnap	= "Removendo a informação actual da casa de leilões";
		FrmtActDefault	= "A opção %s do Auctioneer foi alterada para o modo original";
		FrmtActDefaultall	= "Todas as opções do Auctioneer foram alteradas para o modo original";
		FrmtActDisable	= "Ocultando informação para %s";
		FrmtActEnable	= "Mostrando informação para %s";
		FrmtActSet	= "%s alterado para '%s'";
		FrmtActUnknown	= "Comando ou palavra-chave desconhecida: '%s'";
		FrmtAuctionDuration	= "Tempo da acção original mudado para: %s";
		FrmtAutostart	= "Mudando leilão automático para %s minimo, %s preço de saída (%dh)\n%s";
		FrmtFinish	= "Depois de uma pesquisa terminar, n�s faremos %s";
		FrmtPrintin	= "Mensagens do Auctioneer vão agora ser mostradas na janela de comunicação \"%s\"";
		FrmtProtectWindow	= "Protecção da janela de leilões mudada para: %s";
		FrmtUnknownArg	= "'%s' não é um argumento valido para '%s'";
		FrmtUnknownLocale	= "A localização que especificou ('%s') é desconhecida. Localizações válidas são:";
		FrmtUnknownRf	= "Parametro inválido ('%s'). O parametro tem de estar na forma: [reino]-[facção]. Por exemplo: Al'Akir-Horde";


		-- Section: Command Options
		OptAlso	= "(reino-facção|oposto)";
		OptAuctionDuration	= "(�ltima||2h||8h||24h)";
		OptBidbroker	= "<proveito_prata>";
		OptBidLimit	= "<n�mero>";
		OptBroker	= "<proveito_prata>";
		OptClear	= "([Item]|todo|imagem)";
		OptCompete	= "<prata_menos>";
		OptDefault	= "(<opção>|todo)";
		OptFinish	= "(desligar||sair||terminar)";
		OptLocale	= "<localidade>";
		OptPctBidmarkdown	= "<porcento>";
		OptPctMarkup	= "<porcento>";
		OptPctMaxless	= "<porcento>";
		OptPctNocomp	= "<porcento>";
		OptPctUnderlow	= "<porcento>";
		OptPctUndermkt	= "<porcento>";
		OptPercentless	= "<porcento>";
		OptPrintin	= "(<indiceJanela>[Número]|<nomeJanela>[Serie])";
		OptProtectWindow	= "(nunca||pesquisa||sempre)";
		OptScale	= "<factor_escala>";
		OptScan	= "par�metro de pesquisa";


		-- Section: Commands
		CmdAlso	= "também";
		CmdAlsoOpposite	= "oposto";
		CmdAlt	= "alt";
		CmdAskPriceAd	= "ad";
		CmdAskPriceGuild	= "guild ";
		CmdAskPriceParty	= "party";
		CmdAskPriceSmart	= "esperto";
		CmdAskPriceSmartWord1	= "que";
		CmdAskPriceSmartWord2	= "valor";
		CmdAskPriceTrigger	= "disparador";
		CmdAskPriceVendor	= "vendor";
		CmdAskPriceWhispers	= "suspiros";
		CmdAskPriceWord	= "palavra";
		CmdAuctionClick	= "click-leilão";
		CmdAuctionDuration	= "duração-leilão";
		CmdAuctionDuration0	= "�ltimo";
		CmdAuctionDuration1	= "2h";
		CmdAuctionDuration2	= "8h";
		CmdAuctionDuration3	= "24h";
		CmdAutofill	= "autoinserir";
		CmdBidbroker	= "corretor-ofertas";
		CmdBidbrokerShort	= "co";
		CmdBidLimit	= "ofere�-limite";
		CmdBroker	= "corretor";
		CmdClear	= "limpar";
		CmdClearAll	= "tudo";
		CmdClearSnapshot	= "imagem";
		CmdCompete	= "competir";
		CmdCtrl	= "ctrl";
		CmdDefault	= "iriginal";
		CmdDisable	= "desligar";
		CmdEmbed	= "integrado";
		CmdFinish	= "finish";
		CmdFinish0	= "off";
		CmdFinish1	= "logout";
		CmdFinish2	= "exit";
		CmdFinish3	= "reloadui";
		CmdFinishSound	= "som final";
		CmdHelp	= "ajuda";
		CmdLocale	= "localização";
		CmdOff	= "desligado";
		CmdOn	= "ligado";
		CmdPctBidmarkdown	= "pct-menosoferta";
		CmdPctMarkup	= "pct-mais";
		CmdPctMaxless	= "pct-semmaximo";
		CmdPctNocomp	= "pct-semcomp";
		CmdPctUnderlow	= "pct-abaixomenor";
		CmdPctUndermkt	= "pct-abaixomercado";
		CmdPercentless	= "sempercentagem";
		CmdPercentlessShort	= "sp";
		CmdPrintin	= "imprimir-em";
		CmdProtectWindow	= "proteger-janela";
		CmdProtectWindow0	= "nunca";
		CmdProtectWindow1	= "scan";
		CmdProtectWindow2	= "sempre";
		CmdScan	= "scan";
		CmdShift	= "shift";
		CmdToggle	= "mudar";
		CmdUpdatePrice	= "update-pre�o ";
		CmdWarnColor	= "aviso-cor";
		ShowAverage	= "ver-media";
		ShowEmbedBlank	= "ver-integrado-linhavazia";
		ShowLink	= "ver-link";
		ShowMedian	= "ver-mediano";
		ShowRedo	= "ver-aviso";
		ShowStats	= "ver-estatisticas";
		ShowSuggest	= "ver-sugerido";
		ShowVerbose	= "ver-detalhe";


		-- Section: Config Text
		GuiAlso	= "Tamb�m mostrar informa��o para";
		GuiAlsoDisplay	= "Mostrando informa��o para %s";
		GuiAlsoOff	= "Não mostrando informa��o de outro reino-fac��o";
		GuiAlsoOpposite	= "Mostrando informa��o da fac��o oposta";
		GuiAskPrice	= "Permita AskPrice";
		GuiAskPriceAd	= "Emita caracter�sticas ad";
		GuiAskPriceGuild	= "Responda �s perguntas do guildchat";
		GuiAskPriceHeader	= "Op��es De AskPrice";
		GuiAskPriceHeaderHelp	= "Mude o comportamento de AskPrice";
		GuiAskPriceParty	= "Responda �s perguntas do partychat";
		GuiAskPriceSmart	= "Use smartwords";
		GuiAskPriceTrigger	= "Disparador de AskPrice";
		GuiAskPriceVendor	= "Emita o vendor info ";
		GuiAskPriceWhispers	= "Mostrar suspiros enviados";
		GuiAskPriceWord	= "SmartWord regular %d";
		GuiAuctionDuration	= "Dura��o de leil�es pre-definida";
		GuiAuctionHouseHeader	= "Janela da casa de leil�es";
		GuiAuctionHouseHeaderHelp	= "Mudar o comportamento da janela da casa de leil�es";
		GuiAutofill	= "Auto completar pre�os na casa de leil�es";
		GuiAverages	= "Mostrar medias";
		GuiBidmarkdown	= "Porcento menos oferta";
		GuiClearall	= "Eliminar toda a informa��o do Auctioneer";
		GuiClearallButton	= "Eliminar tudo";
		GuiClearallHelp	= "Seleccione aqui para eliminar toda a informa��o do Auctioneer para o reino-fac��o actual.";
		GuiClearallNote	= "para o reino-fac��o actual";
		GuiClearHeader	= "Eliminar informa��o";
		GuiClearHelp	= "Elimina a informa��o do Auctioneer. Selecione toda a informa��o ou s� a imagem actual. AVISO: Esta altera��o � irreversivel.";
		GuiClearsnap	= "Eliminar Imagem actual";
		GuiClearsnapButton	= "Eliminar Imagem";
		GuiClearsnapHelp	= "Pressione aqui para eliminar a ultima imagem de informa��o do Auctioneer.";
		GuiDefaultAll	= "Reverter todas as op��es";
		GuiDefaultAllButton	= "Reverter tudo";
		GuiDefaultAllHelp	= "Pressione aqui para reverter todas as op��es do Auctioneer de volta ao inicial. AVISO: Estas ac��es n�o s�o reversiveis.";
		GuiDefaultOption	= "Reverter esta op��o";
		GuiEmbed	= "Integrar informa��o na caixa de ajuda";
		GuiEmbedBlankline	= "Mostrar linha em branco na caixa de ajuda";
		GuiEmbedHeader	= "Integrar";
		GuiFinish	= "Depois da pesquisa acabar";
		GuiFinishSound	= "Tocar som quando acabar scan";
		GuiLink	= "Mostrar LinkID";
		GuiLoad	= "Carregar o Auctioneer";
		GuiLoad_Always	= "sempre";
		GuiLoad_AuctionHouse	= "na casa de leil�es";
		GuiLoad_Never	= "nunca";
		GuiLocale	= "Ajustar localidade para";
		GuiMainEnable	= "Activar Auctioneer";
		GuiMainHelp	= "Contém op��es para o Auctioneer, um AddOn que mostra informa��o acerca de items e analiza a casa de leil�es. Pressione \"Scan\" na janela de leil�es para receber a informa��o dos leil�es.";
		GuiMarkup	= "Percentagem sobre o vendedor";
		GuiMaxless	= "Percentagem m�xima abaixo do mercado";
		GuiMedian	= "Mostrar Medianos";
		GuiNocomp	= "Percentagem sem competi��o";
		GuiNoWorldMap	= "Auctioneer: suprimiu a mostra do mapa do mundo";
		GuiOtherHeader	= "Outras Op��es";
		GuiOtherHelp	= "Op��es diversas do Auctioneer";
		GuiPercentsHeader	= "Limites de Percentagem do Auctioneer";
		GuiPercentsHelp	= "AVISO: As seguintes op��es s�o apenas para utilizadores experientes. Ajuste os seguintes valores para mudar o quão agressivo o Auctioneer vai ser quando decidindo valores proveitosos.";
		GuiPrintin	= "Seleccione a janela desejada";
		GuiProtectWindow	= "Prevenir o encerrar acidental da janela de leil�es";
		GuiRedo	= "Mostrar advert�ncia de scan longo";
		GuiReloadui	= "Recarregar interface de utilizador";
		GuiReloaduiButton	= "RecarregarUI";
		GuiReloaduiFeedback	= "Recarregando o interface do WoW";
		GuiReloaduiHelp	= "Pressione aqui para recarregar o interface de utilizador ap�s mudar a localidade para que a linguagem neste ecr� de configura��o coincida com a que voc� escolheu. Nota: Esta opera��o pode durar alguns minutos.";
		GuiRememberText	= "Recordar pre�o";
		GuiStatsEnable	= "Mostrar estat�sticas";
		GuiStatsHeader	= "Estat�stissa de pre�o de itens";
		GuiStatsHelp	= "Mostrar as seguintes estat�sticas na tooltip.";
		GuiSuggest	= "Mostrar pre�os sugeridos";
		GuiUnderlow	= "Redu��o de leil�o mais baixa";
		GuiUndermkt	= "Abaixo de mercado quando sem m�ximo";
		GuiVerbose	= "Modo detalhe";
		GuiWarnColor	= "Modelo de colora��o dos pre�os";


		-- Section: Conversion Messages
		MesgConvert	= "Converção da informação do Auctioneer. Por favor guarde uma cópia de SavedVariables\Auctioneer.lua primeiro. %s%s";
		MesgConvertNo	= "Desactivar Auctioneer";
		MesgConvertYes	= "Converter";
		MesgNotconverting	= "O Auctioneer não está a converter a sua base de dados, mas não funcionará até que o faça.";


		-- Section: Game Constants
		TimeLong	= "Longo";
		TimeMed	= "Médio";
		TimeShort	= "Curto";
		TimeVlong	= "Muito Longo";


		-- Section: Generic Messages
		DisableMsg	= "Desactivando o carregamento automático do Auctioneer";
		FrmtWelcome	= "Auctioneer v%s inicializado. Boas Compras.";
		MesgNotLoaded	= "O Auctioneer não está inicializado. Estreca /auctioneer para mais informação.";
		StatAskPriceOff	= "AskPrice � incapacitado agora.";
		StatAskPriceOn	= "AskPrice � incapacitado agora.";
		StatOff	= "Ocultando informação de leilões";
		StatOn	= "Mostrando informação de leilões";


		-- Section: Generic Strings
		TextAuction	= "leilão";
		TextCombat	= "Combate";
		TextGeneral	= "Geral";
		TextNone	= "nenhum";
		TextScan	= "Scan";
		TextUsage	= "Utilização:";


		-- Section: Help Text
		HelpAlso	= "Mostrar tamb�m valores de outros servidores na janela. Para o reino, insira o nome do reino e para fac��o insira o nome da fac��o. Por exemplo: \"/auctioneer also Al'Akir-Horde\". A palavra chave \"oposto\" significa a fac��o oposta, \"off\" desliga a funcionalidade.";
		HelpAskPrice	= "Permita ou incapacite AskPrice.";
		HelpAskPriceAd	= "Permita ou incapacite caracter�sticas novas de AskPrice ad.";
		HelpAskPriceGuild	= "Responda �s perguntas feitas no bate-papo do guild.";
		HelpAskPriceParty	= "Responda �s perguntas feitas no bate-papo do partido.";
		HelpAskPriceSmart	= "Permita ou incapacite verificar de SmartWords.";
		HelpAskPriceTrigger	= "Mude o car�ter do disparador de AskPrice.";
		HelpAskPriceVendor	= "Permita ou incapacite a emiss�o de dados fixando o pre�o do vendor.";
		HelpAskPriceWhispers	= "Mostrar ou Esconder todos os suspiros de ida do AskPrice.";
		HelpAskPriceWord	= "Adicionar ou Modificar as SmartWords do AskPrice.";
		HelpAuctionClick	= "Permite fazer Alt-Click a um objecto nas suas malas para iniciar automaticamente um leil�o desse objecto";
		HelpAuctionDuration	= "Selecciona a dura��o padr�o de leil�es ao abrir a janela de leil�es";
		HelpAutofill	= "Define se auto-completa pre�os quando se coloca um novo leil�o na janela de leil�es";
		HelpAverage	= "Define se mostra o pre�o m�dio do produto em leil�o";
		HelpBidbroker	= "Mostrar leil�es de tempo curto ou m�dio do recente scan que podem ser comprados para proveito";
		HelpBidLimit	= "N�mero m�ximo dos auctions a oferecer sobre ou do buyout quando a tecla da oferta ou do buyout for estalada na aba dos auctions da busca.";
		HelpBroker	= "Mostrar leilões do recente scan que podem ser comprados e depois re-leiloados para proveito";
		HelpClear	= "Eliminar a informa��o do produto especificado (tem que premir Shift-Clique no(s) produto(s) para o colocar na caixa de texto) Tamb�m pode espicificar as palavras-chave \"todo\" ou \"imagem\"";
		HelpCompete	= "Mostrar leil�es recentes cujo pre�o de sa��da seja menor que um dos seus produtos.";
		HelpDefault	= "Reverter uma op��o ao seu valor original. Voc� tambem pode usar a palavra-chave \"tudo\" para reverter todas as op��es do Auctioneer ao seu valor inicial.";
		HelpDisable	= "Impede o Auctioneer de carregar automaticamente na proxima vez que entrar no jogo";
		HelpEmbed	= "Inserir o texto na caixa de ajuda original. (note: algumas capacidades s�o desactivadas quando esta op��o � seleccionada)";
		HelpEmbedBlank	= "Selecciona se mostra uma linha branca entre a janela de ajuda e a informa��o de leil�o quando o modo avan�ado est� seleccionado";
		HelpFinish	= "Selecciona se sai ou se termina ap�s o fim de uma pesquisa na casa de leil�es";
		HelpFinishSound	= "Escolher se quer tocar um som no fim do scan da Casa de Leil�es.";
		HelpLink	= "Seleccionar se mostra o LinkID na janela de ajuda";
		HelpLoad	= "Mudar as op��es e carregamento para este personagem";
		HelpLocale	= "Alterar o local que �usado para mostrar mensagens do Auctioneer";
		HelpMedian	= "Define se mostra a media do pre�o de saida";
		HelpOnoff	= "Define se a informação de leilões está ligada ou desligada";
		HelpPctBidmarkdown	= "Define a percentagem que o Auctioneer vai marcar preços abaixo do preço de saída";
		HelpPctMarkup	= "A percentagem que o preço de vendedores vai ser inflaccionada quando não existem outros valores disponiveis";
		HelpPctMaxless	= "Define a percentagem máxima que o Auctioneer vai reduzir em relação ao preço de mercado antes de desistir";
		HelpPctNocomp	= "A percentagem que o Auctioneer vai reduzir em relação ao preço de mercado quando não existir competência";
		HelpPctUnderlow	= "Define a percentagem qua o Auctioneer vai reduzir em relação ao leilão mais baixo";
		HelpPctUndermkt	= "Percentagem a reduzir em relação ao preço de mercado quando for impossivel bater a competência (devido ao semmáximo)";
		HelpPercentless	= "Mostra qualquer leilão scaneado recentemente cujo buyout apresenta porcentagem menor do que o mais alto preço de venda";
		HelpPrintin	= "Seleciona qual janela irá mostrar mensagens. Você pode também especificar o nome da janela ou o título.";
		HelpProtectWindow	= "Previne que você feche acidentalmente a janela";
		HelpRedo	= "Selecciona se mostra um aviso quando a pagina da AH actualmente a ser pesquisada demorou muito devido a lag no servidor.";
		HelpScan	= "Efectua uma pesquisa da casa de leilões na pr�xima visita, ou enquanto você l� est� (h� também um botão na janela de leilões). Escolha que categorias quer pesquisar usando as chackboxes.";
		HelpStats	= "Selecionar se mostra as percentagens de licita�ão/saíddd os itens.";
		HelpSuggest	= "Selecionar se mostra o preço de licita�ão/saíad dos itens";
		HelpUpdatePrice	= "Atualize automaticamente o pre�o come�ando para um auction na aba dos auctions do borne quando o pre�o buyout muda.";
		HelpVerbose	= "Selecionar se mostra medias e sugestões (ou desligar para mostr�-las numa linha �nica)";
		HelpWarnColor	= "Selecione se mostrar o atual AH fixando o pre�o do modelo (que undercutting por...) em cores intuitive.";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "Nenhum espa�o vazio do bloco encontrou para criar o auction!";
		FrmtNotEnoughOfItem	= "N�o bastantes %s encontrado para criar o auction! ";
		FrmtPostedAuction	= "Afixado 1 auction de %s (x%d)";
		FrmtPostedAuctions	= "Afixado %d auctions de %s (x%d) ";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "curOferta";
		FrmtBidbrokerDone	= "Brokering da oferta feito";
		FrmtBidbrokerHeader	= "Lucro m�nimo: %s, HSP = 'Valor de venda mais elevado'";
		FrmtBidbrokerLine	= "%s, visto �ltima vez, HSP: %s, %s: %s, Lucro: %s, Tempo: %s";
		FrmtBidbrokerMinbid	= "liciMin";
		FrmtBrokerDone	= "Corre�ão acabada";
		FrmtBrokerHeader	= "Lucro m�nimo: %s, HSP = 'Valor de venda mais elevado'";
		FrmtBrokerLine	= "%s,�ltimo %s visto, HSP: %s, BO: %s, lucro: %s";
		FrmtCompeteDone	= "Auctions competindo feitos.";
		FrmtCompeteHeader	= "Auctions competindo ao menos %s mais menos cada uns.";
		FrmtCompeteLine	= "%s, oferta: %s, BO %s vs %s, %s menos ";
		FrmtHspLine	= "O pre�o o mais elevado de Sellable para um %s �: %s";
		FrmtLowLine	= "%s, BO:  %s, seller:  %s, para um:  %s, menos do que o n�mero m�dio:  %s";
		FrmtMedianLine	= "De �ltimo %d visto, BO mediano para 1 %s �:  %s";
		FrmtNoauct	= "Nenhum auctions encontrou para o artigo:  %s";
		FrmtPctlessDone	= "Por cento feitos mais menos.";
		FrmtPctlessHeader	= "Pre�o de Sellable dos por cento menos do que o mais altamente (HSP):  %d%%";
		FrmtPctlessLine	= "%s, �ltimo %d visto, HSP:  %s, BO:  %s, prof:  %s, menos %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "Os auctions defunct removeram:  %s";
		AuctionDiscrepancies	= "Discrep�ncias:  %s";
		AuctionNewAucts	= "Auctions novos feitos a varredura:  %s";
		AuctionOldAucts	= "Feito a varredura previamente:  %s";
		AuctionPageN	= "Auctioneer:  p�gina %d da explora��o %s de auctions de %d por o segundo:  tempo de %s estimado deixado:  %s";
		AuctionScanDone	= "Auctioneer:  a explora��o do auction terminou";
		AuctionScanNexttime	= "Auctioneer irá iniciar o full scan na proxima vez que você falar com o com o auctioneer.";
		AuctionScanNocat	= "Voc� deve ter ao menos uma categoria selecionada para fazer a varredura";
		AuctionScanRedo	= "A p�gina atual f�z exame de mais do que segundos de %d para terminar, retrying a p�gina";
		AuctionScanStart	= "Auctioneer: Procurando %s página 1...";
		AuctionTotalAucts	= "Os auctions totais fizeram a varredura: %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "Visto %d vezes em %s";
		FrmtInfoAverage	= "%s min/%s BO (%s oferecido)";
		FrmtInfoBidMulti	= "Ofertas (%s%s ea)";
		FrmtInfoBidOne	= "Com o valor %s";
		FrmtInfoBidrate	= "%d%% tem oferta, %d%% tem compra directa";
		FrmtInfoBuymedian	= "Compra Directa valor médio";
		FrmtInfoBuyMulti	= "Compra Directa (%s%s)";
		FrmtInfoBuyOne	= "Compra Directa %s";
		FrmtInfoForone	= "Por 1: %s min/%s BO (%s oferta) [em %d]";
		FrmtInfoHeadMulti	= "Medias por %d unidades:";
		FrmtInfoHeadOne	= "Médias para esta unidade:";
		FrmtInfoHistmed	= "Ultima vez visto a %d, preço médio (ea)";
		FrmtInfoMinMulti	= "Oferta inicial (%s unidade)";
		FrmtInfoMinOne	= "Oferta inicial";
		FrmtInfoNever	= "Nunca visto na %s";
		FrmtInfoSeen	= "Visto %d vezes em leilão";
		FrmtInfoSgst	= "Preço recomendado: %s min/%s BO";
		FrmtInfoSgststx	= "Preço recomendado para os %d: %s min/%s BO";
		FrmtInfoSnapmed	= "Visto a %d, BO (ea)";
		FrmtInfoStacksize	= "Quantidade média: %d items";


		-- Section: User Interface
		FrmtLastSoldOn	= "Ultima Venda";
		UiBid	= "Oferta";
		UiBidHeader	= "Oferta";
		UiBidPerHeader	= "Oferta Por";
		UiBuyout	= "Compra Directa";
		UiBuyoutHeader	= "Compra Directa";
		UiBuyoutPerHeader	= "Compra Directa Por";
		UiBuyoutPriceLabel	= "Pre�o de Compra Directa:";
		UiBuyoutPriceTooLowError	= "(Demasiado Baixo)";
		UiCategoryLabel	= "Limita��o Da Categoria:";
		UiDepositLabel	= "Dep�sito:";
		UiDurationLabel	= "Dura��o:";
		UiItemLevelHeader	= "N�vel";
		UiMakeFixedPriceLabel	= "Fazer pre�o fixo";
		UiMaxError	= "(%d m�ximo)";
		UiMaximumPriceLabel	= "Pre�o M�ximo:";
		UiMaximumTimeLeftLabel	= "Tempo M�ximo Deixado:";
		UiMinimumPercentLessLabel	= "Menos Percentagem Minima:";
		UiMinimumProfitLabel	= "Lucro M�nimo:";
		UiMinimumQualityLabel	= "Qualidade M�nima:";
		UiMinimumUndercutLabel	= "O M�nimo Cortado:";
		UiNameHeader	= "Nome";
		UiNoPendingBids	= "Todos os pedidos completos!";
		UiNotEnoughError	= "(N�o Suficientes)";
		UiPendingBidInProgress	= "1 pedido oferecido em andamento... ";
		UiPendingBidsInProgress	= "%d a oferta pedida em progresso... ";
		UiPercentLessHeader	= "Pct";
		UiPost	= "Postado";
		UiPostAuctions	= "Leil�es Postados";
		UiPriceBasedOnLabel	= "Pre�o Baseado Sobre:";
		UiPriceModelAuctioneer	= "Pre�o De Auctioneer";
		UiPriceModelCustom	= "Pre�o Costume";
		UiPriceModelFixed	= "Pre�o Fixo";
		UiPriceModelLastSold	= "Ultimo Pre�o Vendido";
		UiProfitHeader	= "Lucro";
		UiProfitPerHeader	= "Lucro Por";
		UiQuantityHeader	= "Qtn";
		UiQuantityLabel	= "Quantidade:";
		UiRemoveSearchButton	= "Apagar";
		UiSavedSearchLabel	= "Salvar pesquisas:";
		UiSaveSearchButton	= "Salvar";
		UiSaveSearchLabel	= "Salvar esta Pesquisa:";
		UiSearch	= "Procurar";
		UiSearchAuctions	= "Procurar Leil�es";
		UiSearchDropDownLabel	= "Procurar:";
		UiSearchForLabel	= "Procurar Pelo Item:";
		UiSearchTypeBids	= "Ofertas";
		UiSearchTypeBuyouts	= "Compras Directas";
		UiSearchTypeCompetition	= "Competi��o";
		UiSearchTypePlain	= "Objecto";
		UiStacksLabel	= "Pacote";
		UiStackTooBigError	= "(Pacote Muito Grande)";
		UiStackTooSmallError	= "(Pacote Muito Pequeno)";
		UiStartingPriceLabel	= "Pre�o Inicial:";
		UiStartingPriceRequiredError	= "(Requerido)";
		UiTimeLeftHeader	= "Tempo Restante";
		UiUnknownError	= "(Desconhecido)";

	};

	ruRU = {


		-- Section: AskPrice Messages
		AskPriceAd	= "???????? ???? ?? ???? ? %sx[ItemLink] (x = ?????? ????)";
		FrmtAskPriceBuyoutMedianHistorical	= "%s??????? ????? ?? ??? ?????: %s%s\n";
		FrmtAskPriceBuyoutMedianSnapshot	= "%s??????? ????? ?? ????. ????????????: %s%s";
		FrmtAskPriceDisable	= "?????????? %s ????? AskPrice";
		FrmtAskPriceEach	= "(%s ??????)\n";
		FrmtAskPriceEnable	= "????????? %s ????? AskPrice\n";
		FrmtAskPriceVendorPrice	= "%s ??????? ? ???????: %s%s\n";


		-- Section: Auction Messages
		FrmtActRemove	= "??????? ?????????? ?? ???????? %s ?? ???????? ?????? ?????????.";
		FrmtAuctinfoHist	= "%d ?? ??? ?????";
		FrmtAuctinfoLow	= "???????? ? ??????";
		FrmtAuctinfoMktprice	= "???????? ????";
		FrmtAuctinfoNolow	= "??????? ?? ?????? ? ????????? ??????.";
		FrmtAuctinfoOrig	= "?????????????? ??????";
		FrmtAuctinfoSnap	= "%d ????????? ????";
		FrmtAuctinfoSugbid	= "????????? ??????";
		FrmtAuctinfoSugbuy	= "????????????? ???? ??????";
		FrmtWarnAbovemkt	= "??????????? ? ??????";
		FrmtWarnMarkup	= "?????????? ???? ??????? ?? %s%%";
		FrmtWarnMyprice	= "????????????? ???? ??????? ????";
		FrmtWarnNocomp	= "??? ???????????";
		FrmtWarnNodata	= "??? ?????? ??? ????. ???? ???????\n";
		FrmtWarnToolow	= "?????????? ??????????? ????? ?????? ????\n";
		FrmtWarnUndercut	= "?????? ?? %s%%";
		FrmtWarnUser	= "????, ???????????? ?????????????";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "???? ?????? ??? ????? ???????: %s (x%d)\n";
		FrmtBidAuction	= "??????? ?? ???????: %s (x%d)\n";
		FrmtBidQueueOutOfSync	= "??????: ?????? ?????????????????? ??????";
		FrmtBoughtAuction	= "?????????: %s (x%d)\n";
		FrmtMaxBidsReached	= "????????? %s (x%d) ???? ??????? ??????, ?? ????? ?????? ????????? (%d)";
		FrmtNoAuctionsFound	= "?? ???????: %s (x%d)\n";
		FrmtNoMoreAuctionsFound	= "?????? ?? ???????: %s (x%d)\n";
		FrmtNotEnoughMoney	= "?? ??????? ????? ??? ?????? ??: %s (x%d)";
		FrmtSkippedAuctionWithHigherBid	= "???????? ??????? ? ????? ??????? ???????: %s (x%d)\n";
		FrmtSkippedAuctionWithLowerBid	= "???????? ??????? ? ????? ?????? ???????: %s (x%d)\n";
		FrmtSkippedBiddingOnOwnAuction	= "????????? ?????? ?? ??????????? ???????: %s (x%d)";
		UiProcessingBidRequests	= "????????? ???????? ?? ??????...\n";


		-- Section: Command Messages
		FrmtActClearall	= "??????? ???? ?????????? ?????? ??? %s\n";
		FrmtActClearFail	= "?????????? ????? ???????: %s";
		FrmtActClearOk	= "?????? ??? ???????? ???????: %s\n";
		FrmtActClearsnap	= "??????? ???????? ?????? ? ????????.\n";
		FrmtActDefault	= "????????? ?????????? %s ???? ??????????????? ?? ???????? ?? ?????????";
		FrmtActDefaultall	= "??? ????????? ?????????? ???? ??????????????? ? ????????? ??????????.\n";
		FrmtActDisable	= "?? ?????????? %s ?????? ?? ????????";
		FrmtActEnable	= "?????????? %s ?????? ?? ????????";
		FrmtActSet	= "?????????? %s ? ' %s'\n";
		FrmtActUnknown	= "??????????? ??????? ??? ????: '%s' ";
		FrmtAuctionDuration	= "????????????????? ???????? ?? ????????? ??????????? ??: %s\n";
		FrmtAutostart	= "????????????? ???????? ??????? ??? ???????? %s, buyout %s (%dh) %s\n";
		FrmtFinish	= "?? %s ????? ???????????? ????????\n";
		FrmtPrintin	= "????????? ?????????? ?????? ?????? ????? ?????????? ? \"%s\" ???? ????\n";
		FrmtProtectWindow	= "?????? ???? ???????? ??????????? ?: %s\n";
		FrmtUnknownArg	= "'%s' ?? ???????? ?????????? ?????????? ??? '%s'\n";
		FrmtUnknownLocale	= "???????????, ????????? ???? ('%s') ???????????. ?????????? ???????????:";
		FrmtUnknownRf	= "???????? ???????? (' %s'). ????????? ??????: [ realm]-[faction ]. ????????: Al'Akir-Horde\n";


		-- Section: Command Options
		OptAlso	= "(???????-faction|opposite|home|neutral)";
		OptAuctionDuration	= "(????|2?|8?|24?) ";
		OptBidbroker	= "<???????_???????> ";
		OptBidLimit	= "<?????>";
		OptBroker	= "<???????_???????>";
		OptClear	= "([???????]|???|snapshot) ";
		OptCompete	= "<silver_less> ";
		OptDefault	= "(<?????????>|???) ";
		OptFinish	= " (?????????|?????|?????|???????????)  ";
		OptLocale	= "<???????????> ";
		OptPctBidmarkdown	= "<???????>";
		OptPctMarkup	= "<???????>";
		OptPctMaxless	= "<???????>";
		OptPctNocomp	= "<???????>";
		OptPctUnderlow	= "<???????>";
		OptPctUndermkt	= "<???????>";
		OptPercentless	= "<???????>";
		OptPrintin	= "(<frameIndex>[?????]|<frameName>[String]) ";
		OptProtectWindow	= "(?? ?????|????|????????) ";
		OptScale	= "<scale_factor> ";
		OptScan	= "<> ";


		-- Section: Commands
		CmdAlso	= "?????\n";
		CmdAlsoOpposite	= "??????????????\n";
		CmdAlt	= "alt";
		CmdAskPriceAd	= "??????????\n";
		CmdAskPriceGuild	= "???????\n";
		CmdAskPriceParty	= "??????\n";
		CmdAskPriceSmart	= "?????";
		CmdAskPriceSmartWord1	= "???";
		CmdAskPriceSmartWord2	= "????????";
		CmdAskPriceTrigger	= "???????";
		CmdAskPriceVendor	= "????????";
		CmdAskPriceWhispers	= "???????";
		CmdAskPriceWord	= "?????";
		CmdAuctionClick	= "???????-???? ????";
		CmdAuctionDuration	= "???????-????????????";
		CmdAuctionDuration0	= "???????";
		CmdAuctionDuration1	= "2?";
		CmdAuctionDuration2	= "8?";
		CmdAuctionDuration3	= "24?";
		CmdAutofill	= "?????????????  ";
		CmdBidbroker	= "??????-??????";
		CmdBidbrokerShort	= "??";
		CmdBidLimit	= "?????? ???????????";
		CmdBroker	= "??????";
		CmdClear	= "???????";
		CmdClearAll	= "???";
		CmdClearSnapshot	= "??????";
		CmdCompete	= "?????????????";
		CmdCtrl	= "ctrl";
		CmdDefault	= "????????";
		CmdDisable	= "?????????";
		CmdEmbed	= "????????";
		CmdFinish	= "?????";
		CmdFinish0	= "?????????";
		CmdFinish1	= "logout";
		CmdFinish2	= "?????";
		CmdFinish3	= "??????????? ?????????";
		CmdFinishSound	= "????-????????? ????????????";
		CmdHelp	= "??????";
		CmdLocale	= "????";
		CmdOff	= "?????????";
		CmdOn	= "????????";
		CmdPctBidmarkdown	= "%-????? ??????????? ????";
		CmdPctMarkup	= "%-????????";
		CmdPctMaxless	= "%-m??? ??????";
		CmdPctNocomp	= "%-??????? ????????????";
		CmdPctUnderlow	= "%-??? ?????";
		CmdPctUndermkt	= "%-??? ??????";
		CmdPercentless	= "??????? ??????";
		CmdPercentlessShort	= "??";
		CmdPrintin	= "??????-?";
		CmdProtectWindow	= "????????-????";
		CmdProtectWindow0	= "???????";
		CmdProtectWindow1	= "????????";
		CmdProtectWindow2	= "??????";
		CmdScan	= "????????";
		CmdShift	= "shift";
		CmdToggle	= "?????????-????????";
		CmdUpdatePrice	= "????-??-????????????";
		CmdWarnColor	= "??????????????? ????";
		ShowAverage	= "????????-???????";
		ShowEmbedBlank	= "????? ???????? ?????? ?????";
		ShowLink	= "????????-?????";
		ShowMedian	= "????????-???????";
		ShowRedo	= "????????-??????????????";
		ShowStats	= "????????-??????????";
		ShowSuggest	= "????????-?????????????";
		ShowVerbose	= "????????-??????????";


		-- Section: Config Text
		GuiAlso	= "????? ???????? ?????? ???";
		GuiAlsoDisplay	= "???????????? ?????? ??? %s";
		GuiAlsoOff	= "?????????? ?? ?????? ????? ?????? ?? ????????????.";
		GuiAlsoOpposite	= "?????? ????? ???????????? ?????? ?? ??????????????? ????.";
		GuiAskPrice	= "???????? AskPrice";
		GuiAskPriceAd	= "???????? ?????????? ? ????????????";
		GuiAskPriceGuild	= "???????? ?? ??????? ? ???? ???????";
		GuiAskPriceHeader	= "????????? AskPrice";
		GuiAskPriceHeaderHelp	= "????????? ????????? AskPrice";
		GuiAskPriceParty	= "???????? ?? ??????? ? ???? ??????";
		GuiAskPriceSmart	= "???????????? ????? ?????";
		GuiAskPriceTrigger	= "AskPrice ???????";
		GuiAskPriceVendor	= "???????? ?????????? ????????";
		GuiAskPriceWhispers	= "?????????? ????????? ???????";
		GuiAskPriceWord	= "??????????? ????????? SmartWord %d";
		GuiAuctionDuration	= "????????????????? ???????? ?? ?????????";
		GuiAuctionHouseHeader	= "???? ????????";
		GuiAuctionHouseHeaderHelp	= "????????? ????????? ???? ????????";
		GuiAutofill	= "?????????????? ??? ?? ????????";
		GuiAverages	= "?????????? ???????";
		GuiBidmarkdown	= "?????? ? ???? ?????? ";
		GuiClearall	= "???????? ??? ?????? ??????????";
		GuiClearallButton	= "???????? ???";
		GuiClearallHelp	= "??????? ???? ??? ????, ????? ???????? ??? ?????? ?????????? ??? ????? ???????.";
		GuiClearallNote	= "??? ??????? ???????";
		GuiClearHeader	= "??????? ??????";
		GuiClearHelp	= "??????? ?????? ??????????. ???????? ??? ??? ??????, ??? ??????? ??????. ?????????: ??? ???????? ???????? ??????????.";
		GuiClearsnap	= "???????? ?????? ??????";
		GuiClearsnapButton	= "???????? ??????";
		GuiClearsnapHelp	= "??????? ????? ??? ????, ????? ???????? ?????? ?? ?????????? ?????? ??????????.";
		GuiDefaultAll	= "????? ???? ???????? ??????????";
		GuiDefaultAllButton	= "???????? ???";
		GuiDefaultAllHelp	= "??????? ?????, ????? ???????? ??? ????????? ?????????? ? ?????????????? ?????????. ?????????: ??? ???????? ???????? ??????????.";
		GuiDefaultOption	= "???????? ??? ?????????";
		GuiEmbed	= "???????? ?????? ? ???? ????????";
		GuiEmbedBlankline	= "????????? ?????? ??????";
		GuiEmbedHeader	= "??????????";
		GuiFinish	= "????? ????????? ????????????";
		GuiFinishSound	= "??????????? ???? ?? ????????? ???????????? ????????";
		GuiLink	= "?????????? LinkID";
		GuiLoad	= "????????? ?????????";
		GuiLoad_Always	= "??????";
		GuiLoad_AuctionHouse	= "? ?????? ????????";
		GuiLoad_Never	= "???????";
		GuiLocale	= "???????????";
		GuiMainEnable	= "???????? ?????????";
		GuiMainHelp	= "???????? ????????? ??? ??????????. ??????, ????????????? ?????????? ? ????? ? ?????????????? ?????? ? ????????. ??????? ?????? \"????\" ?? ???????? ??? ????? ??????";
		GuiMarkup	= "??????? ???????? ?? ???? ???????";
		GuiMaxless	= "???????????? ??????? ???????? ???????? ????";
		GuiMedian	= "???????? ??????? ????";
		GuiNocomp	= "??????? ???????? ???? ???? ??? ????????????";
		GuiNoWorldMap	= "?????????: ????? ???? ?? ????????";
		GuiOtherHeader	= "??????";
		GuiOtherHelp	= "????????? ????? ??????????";
		GuiPercentsHeader	= "????????? ???????? ??????????";
		GuiPercentsHelp	= "????????: ?????? ??? ??????? ?????????????. ????????? ???????? ????, ????????? ?????????? ????? ?????????, ???????? ???????? ????????";
		GuiPrintin	= "???????? ???????? ???? ?????????";
		GuiProtectWindow	= "???????? ?? ?????????? ???????? ???? ????????";
		GuiRedo	= "?????????? ?????????????? ???????? ????????????";
		GuiReloadui	= "????????????? UI";
		GuiReloaduiButton	= "????????????? UI";
		GuiReloaduiFeedback	= "??????????????? ???????????????? ?????????";
		GuiReloaduiHelp	= "????? ????? ?????, ??????? ????? ????? ????????????? ?????????, ??? ???? ????? ????????? ???????? ? ????. ??? ???????? ????? ?????? ????????? ?????. ";
		GuiRememberText	= "?????????? ????";
		GuiStatsEnable	= "???????? ??????????";
		GuiStatsHeader	= "?????????? ????????";
		GuiStatsHelp	= "?????????? ????????? ?????????? ? ?????????";
		GuiSuggest	= "?????????? ???????????? ????";
		GuiUnderlow	= "????? ????????? ???????? ????";
		GuiUndermkt	= "???????? ?????";
		GuiVerbose	= "???????????? ?????";
		GuiWarnColor	= "???????? ????????? ???";


		-- Section: Conversion Messages
		MesgConvert	= "?????????? ?????????? ?????????????? ???? ?????? ??????????. ??????????, ?????????????? ???????? ????????? ????? ????? SavedVariables\\Auctioneer.lua";
		MesgConvertNo	= "????????? ?????????";
		MesgConvertYes	= "?????????????";
		MesgNotconverting	= "????????? ?? ??????????????? ???? ???? ? ?? ????????.";


		-- Section: Game Constants
		TimeLong	= "??????";
		TimeMed	= "???????";
		TimeShort	= "????????";
		TimeVlong	= "????? ??????";


		-- Section: Generic Messages
		DisableMsg	= "?????????? ?????????????? ???????? ??????????";
		FrmtWelcome	= "????????? v%s ????????";
		MesgNotLoaded	= "????????? ?? ????????. ???????? /auctioneer ??? ?????????????? ??????????.";
		StatAskPriceOff	= "AskPrice ?????? ????????.";
		StatAskPriceOn	= "AskPrice ?????? ???????.";
		StatOff	= "?? ???????????? ??????? ?????????? ?? ????????";
		StatOn	= "???????????? ?????????? ?? ????????";


		-- Section: Generic Strings
		TextAuction	= "???????";
		TextCombat	= "???";
		TextGeneral	= "????????";
		TextNone	= "???";
		TextScan	= "???????????";
		TextUsage	= "?????????????:";


		-- Section: Help Text
		HelpAlso	= "??? ?? ?????????? ?????? ?????? ???????? ? ?????????. ???????? ??? ???????, ? ??? ???????. ????????: \"/auctioneer also Warsong-Horde\". ????? \"opposite\" ?????????? ??????????????? ???????, \"off\" - ????????? ???????.";
		HelpAskPrice	= "???????? ??? ????????? AskPrice";
		HelpAskPriceGuild	= "???????? ?? ???????, ????????? ?? ?????? ???????";
		HelpAskPriceParty	= "???????? ?? ???????, ????????? ?? ?????? ??????";
		HelpAskPriceSmart	= "???????? ??? ????????? ???????? ?? ???????? ?????";
		HelpAskPriceVendor	= "???????? ??? ????????? ??????? ??? ????????.";
		HelpAuctionClick	= "????????? ???????? Alt-Click ?? ???? ? ????? ????????? ?????????????? ????????? ?? ?? ???????";
		HelpAuctionDuration	= "????????????? ????????????????? ????????, ??????????? ?? ?????????.";
		HelpAutofill	= "??????????, ????? ????????????? ????????? ???? ??? ???????? ?????? ????????";
		HelpAverage	= "????????, ????? ?????????? ??????? ???? ?? ???????? ?? ??? ????";
		HelpBidbroker	= "????????, ????? ???????????? ???????? ? ?????????? ???????????? ????? ??????????????? ?? ??????? ????????? ???????.";
		HelpBidLimit	= "???????????? ?????????? ????????? ?? ??????? ???????? ?????? ??? ?????????? ??? ??????? ?? ?????? ? ???? ??????.";
		HelpBroker	= "?????????? ??? ???????? ? ?????????? ????????????, ?? ??????? ????? ???? ??????? ?????? ? ????? ??????????? ????????? ???????.";
		HelpClear	= "???????? ?????? ?? ?????????? ???? (shift-click ??? ??????? ????????) ?? ????? ?????? ???????????? ?????: \"All\" (???) ? \"snapshot\" (????????? ????)";
		HelpDisable	= "?? ????????? ????????? ????????????? ??? ????????? ????? ? ????.";
		HelpOnoff	= "???????? ? ????????? ????? ?????? ??????????";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "?? ??????? ?????????? ????? ? ?????? ??? ???????? ????????!";
		FrmtNotEnoughOfItem	= "? ??? ???????????? %s ??? ???????? ????????!";
		FrmtPostedAuction	= "?????? 1 ??????? ?? %s (x%d)";
		FrmtPostedAuctions	= "??????? %d ????????? ?? %s (x%d)";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "?????????";
		FrmtBidbrokerMinbid	= "?????????";
		FrmtNoauct	= "?? ??????? ?? ?????? ???????? ??? ????????: %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "??????? ?? ???????????? ?????????: %s";
		AuctionDiscrepancies	= "??????? ??????????????: %s";
		AuctionNewAucts	= "????????????? ????? ?????????: %s";
		AuctionOldAucts	= "????????????? ?? ?????: %s";
		AuctionPageN	= "?????????: ??????????? %s ???????? %d ?? %d ????????? ? ???????: %s ???????? ??????? %s";
		AuctionScanDone	= "?????????: ???????????? ???????? ?????????.";
		AuctionScanNexttime	= "????????? ??????? ?????? ???????????? ????????, ????? ?? ? ????????? ??? ?????????? ? ???????????.";
		AuctionScanNocat	= "?? ?????? ??????? ?? ????? ????? ????????? ??? ????????????.";
		AuctionScanRedo	= "??????? ???????? ?????? ?????? ??? %d ?????? ??? ?????????. ????????? ?????????.";
		AuctionScanStart	= "?????????: ??????????? %s ???????? 1";
		AuctionTotalAucts	= "????? ????????? ?????????????: %s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "????? %d ??? ? %s";
		FrmtInfoAverage	= "%s ???/%s ????? (%s ??????)";
		FrmtInfoBidMulti	= "?????? (%s%s ?? ??)";
		FrmtInfoBidOne	= "??????%s";
		FrmtInfoBidrate	= "%d %% ????? ??????, %d %% ????? ???? ??????";
		FrmtInfoBuymedian	= "??????? ???? ??????";
		FrmtInfoBuyMulti	= "????? (%s%s ?? ??)";
		FrmtInfoBuyOne	= "?????%s";
		FrmtInfoForone	= "?? 1: %s ???/%s ????? (%s ??????) [? %d's]";
		FrmtInfoHeadMulti	= "??????? ?? %d ??:";
		FrmtInfoHeadOne	= "??????? ?? ??? ????:";
		FrmtInfoHistmed	= "????????? %d, ??????? ????? (?? ??)";
		FrmtInfoMinMulti	= "????????? ?????? (%s ?? ??)";
		FrmtInfoMinOne	= "????????? ??????";
		FrmtInfoNever	= "?? ???? ?? ??? ??????? ?? %s";
		FrmtInfoSeen	= "????? %d ??? ????? ?? ????????";
		FrmtInfoSgst	= "???????????? ????: %s ???/%s ?????";
		FrmtInfoSgststx	= "???????????? ???? ?? %d ??: %s ???/%s ?????";
		FrmtInfoSnapmed	= "????????????? %d, ??????? ????? (?? ??)";
		FrmtInfoStacksize	= "??????? ?????? ????: %d ??";


		-- Section: User Interface
		FrmtLastSoldOn	= "????????? ??????? %s";
		UiBid	= "???????????";
		UiBidHeader	= "???????????";
		UiBidPerHeader	= "?????? ??";
		UiBuyout	= "????????";
		UiBuyoutHeader	= "??????";
		UiBuyoutPerHeader	= "???????? ??";
		UiBuyoutPriceLabel	= "???? ?? ??????:";
		UiBuyoutPriceTooLowError	= "(??????? ??????)";
		UiCategoryLabel	= "??????????? ?????????:";
		UiDepositLabel	= "???????:";
		UiDurationLabel	= "????????????";
		UiItemLevelHeader	= "???????";
		UiMakeFixedPriceLabel	= "????. ????????????? ????";
		UiMaxError	= "(%d ????) ";
		UiMaximumPriceLabel	= "????. ????";
		UiMaximumTimeLeftLabel	= "????. ????? ????????:";
		UiMinimumPercentLessLabel	= "??????????? ??????? ??????:";
		UiMinimumProfitLabel	= "??????????? ???????:";
		UiMinimumQualityLabel	= "??????????? ???-??";
		UiMinimumUndercutLabel	= "??????????? ??????";
		UiNameHeader	= "???";
		UiNoPendingBids	= "??? ?????? ??????????!";
		UiNotEnoughError	= "(????????????)";
		UiPendingBidInProgress	= "1 ?????? ??????????????...";
		UiPendingBidsInProgress	= "%d ?????? ??????????????...";
		UiPercentLessHeader	= "%";
		UiPost	= "?????????";
		UiPostAuctions	= "????????? ?? ???????";
		UiPriceBasedOnLabel	= "???? ???????????? ??:";
		UiPriceModelAuctioneer	= "???? ??????????";
		UiPriceModelCustom	= "???? ???????";
		UiPriceModelFixed	= "????. ????";
		UiPriceModelLastSold	= "????????? ???? ???????";
		UiProfitHeader	= "???????";
		UiProfitPerHeader	= "??????? ??";
		UiQuantityHeader	= "???-??";
		UiQuantityLabel	= "???-??";
		UiRemoveSearchButton	= "???????";
		UiSavedSearchLabel	= "??????????? ??????";
		UiSaveSearchButton	= "?????????";
		UiSaveSearchLabel	= "????????? ?????";
		UiSearch	= "??????";
		UiSearchAuctions	= "?????? ? ?????????";
		UiSearchDropDownLabel	= "?????:";
		UiSearchForLabel	= "????? ????????:";
		UiSearchTypeBids	= "??????";
		UiSearchTypeBuyouts	= "???? ??????";
		UiSearchTypeCompetition	= "???????????";
		UiSearchTypePlain	= "???????";
		UiStacksLabel	= "????";
		UiStackTooBigError	= "(???? ??????? ??????)";
		UiStackTooSmallError	= "(???? ??????? ????)";
		UiStartingPriceLabel	= "???. ????";
		UiStartingPriceRequiredError	= "(?????????)";
		UiTimeLeftHeader	= "?????????? ?????";
		UiUnknownError	= "(???????????)";

	};

	zhCN = {


		-- Section: AskPrice Messages
		AskPriceAd	= "?%sx[????](x=????)???????";
		FrmtAskPriceBuyoutMedianHistorical	= "%s????????:%s%s";
		FrmtAskPriceBuyoutMedianSnapshot	= "%s??????????:%s%s";
		FrmtAskPriceDisable	= "????%s???";
		FrmtAskPriceEach	= "(??%s)";
		FrmtAskPriceEnable	= "????%s???";
		FrmtAskPriceVendorPrice	= "%s????:%s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "?????????????%s?";
		FrmtAuctinfoHist	= "??%d?";
		FrmtAuctinfoLow	= "?????";
		FrmtAuctinfoMktprice	= "????";
		FrmtAuctinfoNolow	= "??????????";
		FrmtAuctinfoOrig	= "????";
		FrmtAuctinfoSnap	= "????%d?";
		FrmtAuctinfoSugbid	= "?????";
		FrmtAuctinfoSugbuy	= "?????";
		FrmtWarnAbovemkt	= "??????";
		FrmtWarnMarkup	= "?????????%s%%";
		FrmtWarnMyprice	= "???????";
		FrmtWarnNocomp	= "???";
		FrmtWarnNodata	= "?????????";
		FrmtWarnToolow	= "???????";
		FrmtWarnUndercut	= "??%s%%";
		FrmtWarnUser	= "?????";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "????:%s (x%d)???????";
		FrmtBidAuction	= "????:%s (x%d)?";
		FrmtBidQueueOutOfSync	= "??:???????!";
		FrmtBoughtAuction	= "?????:%s (x%d)?";
		FrmtMaxBidsReached	= "??????:%s (x%d),?????????(%d)?";
		FrmtNoAuctionsFound	= "?????:%s (x%d)?";
		FrmtNoMoreAuctionsFound	= "???????:%s (x%d)?";
		FrmtNotEnoughMoney	= "??????:%s (x%d)?";
		FrmtSkippedAuctionWithHigherBid	= "?????????:%s (x%d)?";
		FrmtSkippedAuctionWithLowerBid	= "?????????:%s (x%d)?";
		FrmtSkippedBiddingOnOwnAuction	= "??????????:%s (x%d)?";
		UiProcessingBidRequests	= "???????...";


		-- Section: Command Messages
		ConstantsCritical	= "??:????????????(SavedVariables )%.3f%%??";
		ConstantsMessage	= "????????????(SavedVariables )%.3f%%??";
		ConstantsWarning	= "??:????????????(SavedVariables )%.3f%%??";
		FrmtActClearall	= "??%s????????";
		FrmtActClearFail	= "??????:%s?";
		FrmtActClearOk	= "%s???????";
		FrmtActClearsnap	= "??????????";
		FrmtActDefault	= "??????%s?????????";
		FrmtActDefaultall	= "?????????????????";
		FrmtActDisable	= "????%s????";
		FrmtActEnable	= "????%s????";
		FrmtActSet	= "??%s?'%s'?";
		FrmtActUnknown	= "????????:'%s'?";
		FrmtAuctionDuration	= "?????????:%s?";
		FrmtAutostart	= "??????:???%s,???%s(%d??)%s?";
		FrmtFinish	= "??????,?%s?";
		FrmtPrintin	= "????????????'%s'?????";
		FrmtProtectWindow	= "?????????:%s?";
		FrmtUnknownArg	= "?'%s'??,'%s'?????";
		FrmtUnknownLocale	= "????????('%s')???????????:";
		FrmtUnknownRf	= "?????('%s'):??????:[????]-[??],???????(??-Alliance,??-Horde)???:???-Alliance?";


		-- Section: Command Options
		OptAlso	= "(????-??|opposite??)";
		OptAuctionDuration	= "(last??||2h??||8h??||24h??)";
		OptBidbroker	= "<?????>";
		OptBidLimit	= "<??>";
		OptBroker	= "<?????>";
		OptClear	= "([??]|all??|snapshot??)";
		OptCompete	= "<?????>";
		OptDefault	= "(<??>|all??)";
		OptFinish	= "(off??||logout??||exit??)";
		OptLocale	= "<????>";
		OptPctBidmarkdown	= "<??>";
		OptPctMarkup	= "<??>";
		OptPctMaxless	= "<??>";
		OptPctNocomp	= "<??>";
		OptPctUnderlow	= "<??>";
		OptPctUndermkt	= "<??>";
		OptPercentless	= "<??>";
		OptPrintin	= "(<????>[??]|<????>[???])";
		OptProtectWindow	= "(never??|scan??|always??)";
		OptScale	= "<????>";
		OptScan	= "<>";


		-- Section: Commands
		CmdAlso	= "also??";
		CmdAlsoOpposite	= "opposite??";
		CmdAlt	= "Alt";
		CmdAskPriceAd	= "ad??";
		CmdAskPriceGuild	= "guild??";
		CmdAskPriceParty	= "party??";
		CmdAskPriceSmart	= "smart??";
		CmdAskPriceSmartWord1	= "what??";
		CmdAskPriceSmartWord2	= "worth??";
		CmdAskPriceTrigger	= "trigger???";
		CmdAskPriceVendor	= "vendor??";
		CmdAskPriceWhispers	= "whispers ??";
		CmdAskPriceWord	= "word ???";
		CmdAuctionClick	= "auction-click????";
		CmdAuctionDuration	= "auction-duration????";
		CmdAuctionDuration0	= "last??";
		CmdAuctionDuration1	= "2h??";
		CmdAuctionDuration2	= "8h??";
		CmdAuctionDuration3	= "24h??";
		CmdAutofill	= "autofill????";
		CmdBidbroker	= "bidbroker????";
		CmdBidbrokerShort	= "bb(???????)";
		CmdBidLimit	= "bid-limit????";
		CmdBroker	= "broker??";
		CmdClear	= "clear??";
		CmdClearAll	= "all??";
		CmdClearSnapshot	= "snapshot??";
		CmdCompete	= "compete??";
		CmdCtrl	= "Ctrl";
		CmdDefault	= "default??";
		CmdDisable	= "disable??";
		CmdEmbed	= "embed??";
		CmdFinish	= "finish??";
		CmdFinish0	= "off??";
		CmdFinish1	= "logout??";
		CmdFinish2	= "exit??";
		CmdFinish3	= "reloadui????????";
		CmdFinishSound	= "finish-sound??????";
		CmdHelp	= "help??";
		CmdLocale	= "locale????";
		CmdOff	= "off?";
		CmdOn	= "on?";
		CmdPctBidmarkdown	= "pct-bidmarkdown??????";
		CmdPctMarkup	= "pct-markup????";
		CmdPctMaxless	= "pct-maxless??????";
		CmdPctNocomp	= "pct-nocomp?????";
		CmdPctUnderlow	= "pct-underlow?????";
		CmdPctUndermkt	= "pct-undermkt???????";
		CmdPercentless	= "percentless????";
		CmdPercentlessShort	= "pl(???????)";
		CmdPrintin	= "print-in??";
		CmdProtectWindow	= "protect-window????";
		CmdProtectWindow0	= "never??";
		CmdProtectWindow1	= "scan??";
		CmdProtectWindow2	= "always??";
		CmdScan	= "scan??";
		CmdShift	= "Shift";
		CmdToggle	= "toggle????";
		CmdUpdatePrice	= "update-price????";
		CmdWarnColor	= "warn-color???";
		ShowAverage	= "show-average????";
		ShowEmbedBlank	= "show-embed-blankline??????";
		ShowLink	= "show-link????";
		ShowMedian	= "show-median????";
		ShowRedo	= "show-warning????";
		ShowStats	= "show-stats????";
		ShowSuggest	= "show-suggest????";
		ShowVerbose	= "show-verbose????";


		-- Section: Config Text
		GuiAlso	= "??????";
		GuiAlsoDisplay	= "??%s???";
		GuiAlsoOff	= "?????????-??????";
		GuiAlsoOpposite	= "????????????";
		GuiAskPrice	= "????";
		GuiAskPriceAd	= "??????";
		GuiAskPriceGuild	= "????????";
		GuiAskPriceHeader	= "????";
		GuiAskPriceHeaderHelp	= "??????";
		GuiAskPriceParty	= "????????";
		GuiAskPriceSmart	= "?????";
		GuiAskPriceTrigger	= "?????";
		GuiAskPriceVendor	= "??????";
		GuiAskPriceWhispers	= "???????";
		GuiAskPriceWord	= "???????? %d";
		GuiAuctionDuration	= "??????";
		GuiAuctionHouseHeader	= "?????";
		GuiAuctionHouseHeaderHelp	= "?????????";
		GuiAutofill	= "????????";
		GuiAverages	= "??????";
		GuiBidmarkdown	= "??????";
		GuiClearall	= "??????????";
		GuiClearallButton	= "????";
		GuiClearallHelp	= "???????????????????";
		GuiClearallNote	= "???????-??";
		GuiClearHeader	= "????";
		GuiClearHelp	= "???????????????????????????:?????????";
		GuiClearsnap	= "??????";
		GuiClearsnapButton	= "????";
		GuiClearsnapHelp	= "???????????????";
		GuiDefaultAll	= "??????????";
		GuiDefaultAllButton	= "????";
		GuiDefaultAllHelp	= "???????????????????:?????????";
		GuiDefaultOption	= "??????";
		GuiEmbed	= "??????????";
		GuiEmbedBlankline	= "??????????";
		GuiEmbedHeader	= "??";
		GuiFinish	= "??????";
		GuiFinishSound	= "?????????";
		GuiLink	= "??????";
		GuiLoad	= "??????";
		GuiLoad_Always	= "??";
		GuiLoad_AuctionHouse	= "????";
		GuiLoad_Never	= "??";
		GuiLocale	= "???????";
		GuiMainEnable	= "??????";
		GuiMainHelp	= "???? - ?????????????????,??????????????\"??\"??????????";
		GuiMarkup	= "???????";
		GuiMaxless	= "?????????";
		GuiMedian	= "????????";
		GuiNocomp	= "???????";
		GuiNoWorldMap	= "????:????????";
		GuiOtherHeader	= "????";
		GuiOtherHelp	= "??????";
		GuiPercentsHeader	= "????????";
		GuiPercentsHelp	= "??:????????????????????????????????????";
		GuiPrintin	= "??????????";
		GuiProtectWindow	= "????????????";
		GuiRedo	= "??????????";
		GuiReloadui	= "?????????";
		GuiReloaduiButton	= "??UI ";
		GuiReloaduiFeedback	= "??????????????";
		GuiReloaduiHelp	= "?????????????????????????????????????:???????????";
		GuiRememberText	= "????";
		GuiStatsEnable	= "????";
		GuiStatsHeader	= "??????";
		GuiStatsHelp	= "????????????";
		GuiSuggest	= "??????";
		GuiUnderlow	= "????????";
		GuiUndermkt	= "?????????????";
		GuiVerbose	= "????";
		GuiWarnColor	= "??????";


		-- Section: Conversion Messages
		MesgConvert	= "????????????????SavedVariables\Auctioneer.lua???%s%s";
		MesgConvertNo	= "??????";
		MesgConvertYes	= "??";
		MesgNotconverting	= "????????????,???????????";


		-- Section: Game Constants
		TimeLong	= "?";
		TimeMed	= "?";
		TimeShort	= "?";
		TimeVlong	= "???";


		-- Section: Generic Messages
		ConfirmBidBuyout	= "????? %s\n%dx%s :";
		DisableMsg	= "???????????";
		FrmtWelcome	= "????(Auctioneer) v%s???!";
		MesgNotLoaded	= "????(Auctioneer)??????/auctioneer??????";
		StatAskPriceOff	= "????????";
		StatAskPriceOn	= "????????";
		StatOff	= "??????????";
		StatOn	= "??????????";


		-- Section: Generic Strings
		TextAuction	= "??";
		TextCombat	= "??";
		TextGeneral	= "??";
		TextNone	= "?";
		TextScan	= "??";
		TextUsage	= "??:";


		-- Section: Help Text
		HelpAlso	= "?????????????????[????]-[??],???????(??-Alliance,??-Horde)???:\"/auctioneer also ???-Alliance\"???????:\"opposite\"??????,\"off\"??????";
		HelpAskPrice	= "????????";
		HelpAskPriceAd	= "??????????????";
		HelpAskPriceGuild	= "???????????";
		HelpAskPriceParty	= "???????????";
		HelpAskPriceSmart	= "???????????";
		HelpAskPriceTrigger	= "??????????";
		HelpAskPriceVendor	= "??????????????";
		HelpAskPriceWhispers	= "?????????????";
		HelpAskPriceWord	= "???????????????";
		HelpAuctionClick	= "???Alt????????????????";
		HelpAuctionDuration	= "??????????????????";
		HelpAutofill	= "???????????????????????";
		HelpAverage	= "????????????????";
		HelpBidbroker	= "???????????????????";
		HelpBidLimit	= "????????????????????,??????????????";
		HelpBroker	= "?????????????????????";
		HelpClear	= "?????????(????Shift+??????????)??????????\"all\"?\"snapshot\"?";
		HelpCompete	= "????????????????????";
		HelpDefault	= "???????????????,???????????\"all\"?????????????????";
		HelpDisable	= "?????????????????";
		HelpEmbed	= "????????????(??:????????????)?";
		HelpEmbedBlank	= "?????????????????????????????";
		HelpFinish	= "??????????????????????";
		HelpFinishSound	= "?????????????????";
		HelpLink	= "???????????????";
		HelpLoad	= "?????????????????";
		HelpLocale	= "??????????????????";
		HelpMedian	= "????????????????";
		HelpOnoff	= "??/??????????";
		HelpPctBidmarkdown	= "??????????????????";
		HelpPctMarkup	= "??????????????????";
		HelpPctMaxless	= "???????????????????????";
		HelpPctNocomp	= "???????????????????";
		HelpPctUnderlow	= "??????????????????";
		HelpPctUndermkt	= "??????????????????(????????)?";
		HelpPercentless	= "???????????????????????????";
		HelpPrintin	= "?????????????????????????????";
		HelpProtectWindow	= "????????????";
		HelpRedo	= "?????????????????????????????????";
		HelpScan	= "???????????????(??????????????)???????????";
		HelpStats	= "?????????????/?????????";
		HelpSuggest	= "????????????????";
		HelpUpdatePrice	= "???????,????????????????????";
		HelpVerbose	= "???????????????(????????)?";
		HelpWarnColor	= "????????????????????";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "?????????????!";
		FrmtNotEnoughOfItem	= "???%s??????!";
		FrmtPostedAuction	= "???1???:%s (x%d)?";
		FrmtPostedAuctions	= "???%d???:%s (x%d)?";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "????";
		FrmtBidbrokerDone	= "????????";
		FrmtBidbrokerHeader	= "????:%s,?????='????????????'";
		FrmtBidbrokerLine	= "%s,????%s?,?????:%s,%s:%s,??:%s,??:%s";
		FrmtBidbrokerMinbid	= "????";
		FrmtBrokerDone	= "?????";
		FrmtBrokerHeader	= "????:%s,?????='????????????'";
		FrmtBrokerLine	= "%s,????%s?,?????:%s,???:%s,??:%s";
		FrmtCompeteDone	= "?????";
		FrmtCompeteHeader	= "????????%s?";
		FrmtCompeteLine	= "%s,???:%s,???%s vs %s,??%s";
		FrmtHspLine	= "??%s???????:%s";
		FrmtLowLine	= "%s,???:%s,???:%s,??:%s,????:%s";
		FrmtMedianLine	= "????%d?,??%s???????:%s";
		FrmtNoauct	= "??:%s??????";
		FrmtPctlessDone	= "???????";
		FrmtPctlessHeader	= "?????????:%d%%";
		FrmtPctlessLine	= "%s,????%d?,?????:%s,???:%s,??:%s,??%s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "??????:%s?";
		AuctionDiscrepancies	= "????:%s?";
		AuctionNewAucts	= "??????:%s?";
		AuctionOldAucts	= "?????:%s?";
		AuctionPageN	= "????:???%s\n?%d? ?%d? %s?/?\n??????: %s";
		AuctionScanDone	= "????:???????";
		AuctionScanNexttime	= "??????????????????????";
		AuctionScanNocat	= "?????????????";
		AuctionScanRedo	= "???????%d?????,??????";
		AuctionScanStart	= "????:???%s\n?1?...";
		AuctionTotalAucts	= "???????:%s?";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "???%d??%s";
		FrmtInfoAverage	= "???%s/???%s(???%s)";
		FrmtInfoBidMulti	= "???(%s??%s)";
		FrmtInfoBidOne	= "???%s";
		FrmtInfoBidrate	= "???%d%%,???%d%%";
		FrmtInfoBuymedian	= "??????";
		FrmtInfoBuyMulti	= "???(%s??%s)";
		FrmtInfoBuyOne	= "???%s";
		FrmtInfoForone	= "??:???%s/???%s(???%s)[%d?]";
		FrmtInfoHeadMulti	= "%d?????:";
		FrmtInfoHeadOne	= "?????:";
		FrmtInfoHistmed	= "???%d?,??????(??)";
		FrmtInfoMinMulti	= "???(??%s)";
		FrmtInfoMinOne	= "???";
		FrmtInfoNever	= "???%s???";
		FrmtInfoSeen	= "???????%d?";
		FrmtInfoSgst	= "????:???%s/???%s";
		FrmtInfoSgststx	= "????%d??????:???%s/???%s";
		FrmtInfoSnapmed	= "???%d?,??????(??)";
		FrmtInfoStacksize	= "??????:%d?";


		-- Section: User Interface
		FrmtLastSoldOn	= "???%s??";
		UiBid	= "??";
		UiBidHeader	= "??";
		UiBidPerHeader	= "????";
		UiBuyout	= "???";
		UiBuyoutHeader	= "???";
		UiBuyoutPerHeader	= "????";
		UiBuyoutPriceLabel	= "???:";
		UiBuyoutPriceTooLowError	= "(??)";
		UiCategoryLabel	= "????";
		UiDepositLabel	= "???:";
		UiDurationLabel	= "????:";
		UiItemLevelHeader	= "??";
		UiMakeFixedPriceLabel	= "??????";
		UiMaxError	= "(??%d?)";
		UiMaximumPriceLabel	= "????";
		UiMaximumTimeLeftLabel	= "??????:";
		UiMinimumPercentLessLabel	= "??????:";
		UiMinimumProfitLabel	= "????:";
		UiMinimumQualityLabel	= "????:";
		UiMinimumUndercutLabel	= "????:";
		UiNameHeader	= "??";
		UiNoPendingBids	= "????????!";
		UiNotEnoughError	= "(??)";
		UiPendingBidInProgress	= "1?????????...";
		UiPendingBidsInProgress	= "%d?????????...";
		UiPercentLessHeader	= "??";
		UiPost	= "???";
		UiPostAuctions	= "????";
		UiPriceBasedOnLabel	= "????:";
		UiPriceModelAuctioneer	= "??????";
		UiPriceModelCustom	= "????";
		UiPriceModelFixed	= "????";
		UiPriceModelLastSold	= "????";
		UiProfitHeader	= "??";
		UiProfitPerHeader	= "????";
		UiQuantityHeader	= "??";
		UiQuantityLabel	= "??:";
		UiRemoveSearchButton	= "??";
		UiSavedSearchLabel	= "????:";
		UiSaveSearchButton	= "??";
		UiSaveSearchLabel	= "??????";
		UiSearch	= "??";
		UiSearchAuctions	= "????";
		UiSearchDropDownLabel	= "??";
		UiSearchForLabel	= "????";
		UiSearchTypeBids	= "??";
		UiSearchTypeBuyouts	= "???";
		UiSearchTypeCompetition	= "??";
		UiSearchTypePlain	= "??";
		UiStacksLabel	= "??";
		UiStackTooBigError	= "(????)";
		UiStackTooSmallError	= "(????)";
		UiStartingPriceLabel	= "???:";
		UiStartingPriceRequiredError	= "(???)";
		UiTimeLeftHeader	= "????";
		UiUnknownError	= "(??)";

	};

	zhTW = {


		-- Section: AskPrice Messages
		AskPriceAd	= "??????: %sx[ItemLink ] (x = stacksize)\n";
		FrmtAskPriceBuyoutMedianHistorical	= "%s???????: %s%s";
		FrmtAskPriceBuyoutMedianSnapshot	= "%s?????????: %s%s";
		FrmtAskPriceDisable	= "??????:%s";
		FrmtAskPriceEach	= "%s ??";
		FrmtAskPriceEnable	= "??????:%s";
		FrmtAskPriceVendorPrice	= "%sNPC???: %s%s";


		-- Section: Auction Messages
		FrmtActRemove	= "??????????? %s?";
		FrmtAuctinfoHist	= "%d ???";
		FrmtAuctinfoLow	= "????????";
		FrmtAuctinfoMktprice	= "???";
		FrmtAuctinfoNolow	= "???????????";
		FrmtAuctinfoOrig	= "???";
		FrmtAuctinfoSnap	= "%d ????";
		FrmtAuctinfoSugbid	= "?????";
		FrmtAuctinfoSugbuy	= "?????";
		FrmtWarnAbovemkt	= "???????";
		FrmtWarnMarkup	= "?????? %s%%";
		FrmtWarnMyprice	= "???????";
		FrmtWarnNocomp	= "????";
		FrmtWarnNodata	= "?????????";
		FrmtWarnToolow	= "????????";
		FrmtWarnUndercut	= "???? %s%%";
		FrmtWarnUser	= "??????";


		-- Section: Bid Messages
		FrmtAlreadyHighBidder	= "????????: %s (x%d) ";
		FrmtBidAuction	= "??:%s (x%d)";
		FrmtBidQueueOutOfSync	= "??:????????";
		FrmtBoughtAuction	= "????:%s (x%d)";
		FrmtMaxBidsReached	= "????????:%s (x%d), ????????????(%d)";
		FrmtNoAuctionsFound	= "?????:%s (x%d)";
		FrmtNoMoreAuctionsFound	= "?????????:%s (x%d) ";
		FrmtNotEnoughMoney	= "??????:%s (x%d) ";
		FrmtSkippedAuctionWithHigherBid	= "????????:%s (x%d) ";
		FrmtSkippedAuctionWithLowerBid	= "????????:%s (x%d) ";
		FrmtSkippedBiddingOnOwnAuction	= "?????????:%s (x%d)";
		UiProcessingBidRequests	= "???????...";


		-- Section: Command Messages
		FrmtActClearall	= "????%s??";
		FrmtActClearFail	= "???:%s";
		FrmtActClearOk	= "????:%s???";
		FrmtActClearsnap	= "???????????";
		FrmtActDefault	= "?????? %s ???????";
		FrmtActDefaultall	= "???????????";
		FrmtActDisable	= "???? %s ???";
		FrmtActEnable	= "????? %s ???";
		FrmtActSet	= "?? %s ? '%s'";
		FrmtActUnknown	= "????????:'%s'";
		FrmtAuctionDuration	= "?????????:%s";
		FrmtAutostart	= "??????:??? %s ,??? %s (%dh)%s";
		FrmtFinish	= "????????, ??%s";
		FrmtPrintin	= "???????????\"%s\"????";
		FrmtProtectWindow	= "??????????:%s";
		FrmtUnknownArg	= "?'%s'??,'%s'????";
		FrmtUnknownLocale	= "??????('%s')???????????????:";
		FrmtUnknownRf	= "????? ('%s').??????:[???]-[??],??:????-??.";


		-- Section: Command Options
		OptAlso	= "(???-??|??|opposite(????))";
		OptAuctionDuration	= "(last(??)|2h(2??)|8h(8??)|24h(24??))";
		OptBidbroker	= "<????>";
		OptBidLimit	= "<??>";
		OptBroker	= "<????>";
		OptClear	= "([????]|all(??)|snapshot(??))";
		OptCompete	= "<????>";
		OptDefault	= "(<????>|all(??))";
		OptFinish	= "(off(??)||logout(??)||exit(??))";
		OptLocale	= "<??>";
		OptPctBidmarkdown	= "<???>";
		OptPctMarkup	= "<???>";
		OptPctMaxless	= "<???>";
		OptPctNocomp	= "<???>";
		OptPctUnderlow	= "<%>";
		OptPctUndermkt	= "<%>";
		OptPercentless	= "<%>";
		OptPrintin	= "(<frameIndex>[Number]|<frameName>[String])";
		OptProtectWindow	= "(never(??)||scan(???)||always(??))";
		OptScale	= "<????>";
		OptScan	= "<>";


		-- Section: Commands
		CmdAlso	= "also";
		CmdAlsoOpposite	= "opposite";
		CmdAlt	= "alt";
		CmdAskPriceAd	= "ad";
		CmdAskPriceGuild	= "guild";
		CmdAskPriceParty	= "party";
		CmdAskPriceSmart	= "smart";
		CmdAskPriceSmartWord1	= "what";
		CmdAskPriceSmartWord2	= "worth";
		CmdAskPriceTrigger	= "trigger";
		CmdAskPriceVendor	= "vendor";
		CmdAskPriceWhispers	= "whispers";
		CmdAskPriceWord	= "word";
		CmdAuctionClick	= "auction-click";
		CmdAuctionDuration	= "auction-duration";
		CmdAuctionDuration0	= "last";
		CmdAuctionDuration1	= "2h";
		CmdAuctionDuration2	= "8h";
		CmdAuctionDuration3	= "24h";
		CmdAutofill	= "autofill";
		CmdBidbroker	= "bidbroker";
		CmdBidbrokerShort	= "bb";
		CmdBidLimit	= "bid-limit";
		CmdBroker	= "broker";
		CmdClear	= "clear";
		CmdClearAll	= "all";
		CmdClearSnapshot	= "snapshot";
		CmdCompete	= "compete";
		CmdCtrl	= "Ctrl";
		CmdDefault	= "default";
		CmdDisable	= "disable";
		CmdEmbed	= "embed";
		CmdFinish	= "finish";
		CmdFinish0	= "off";
		CmdFinish1	= "logout";
		CmdFinish2	= "exit";
		CmdFinish3	= "reloadui";
		CmdFinishSound	= "finish-sound";
		CmdHelp	= "help";
		CmdLocale	= "locale";
		CmdOff	= "off";
		CmdOn	= "on";
		CmdPctBidmarkdown	= "pct-bidmarkdown";
		CmdPctMarkup	= "pct-markup";
		CmdPctMaxless	= "pct-maxless";
		CmdPctNocomp	= "pct-nocomp";
		CmdPctUnderlow	= "pct-underlow";
		CmdPctUndermkt	= "pct-undermkt";
		CmdPercentless	= "percentless";
		CmdPercentlessShort	= "pl";
		CmdPrintin	= "print-in";
		CmdProtectWindow	= "protect-window";
		CmdProtectWindow0	= "never";
		CmdProtectWindow1	= "scan";
		CmdProtectWindow2	= "always";
		CmdScan	= "scan";
		CmdShift	= "Shift";
		CmdToggle	= "toggle";
		CmdUpdatePrice	= "update-price";
		CmdWarnColor	= "warn-color";
		ShowAverage	= "show-average";
		ShowEmbedBlank	= "show-embed-blankline";
		ShowLink	= "show-link";
		ShowMedian	= "show-median";
		ShowRedo	= "show-stats";
		ShowStats	= "show-stats";
		ShowSuggest	= "show-suggest";
		ShowVerbose	= "show-verbose";


		-- Section: Config Text
		GuiAlso	= "??????";
		GuiAlsoDisplay	= "?? %s ???";
		GuiAlsoOff	= "?????????-??????";
		GuiAlsoOpposite	= "????????????";
		GuiAskPrice	= "??????";
		GuiAskPriceAd	= "???????";
		GuiAskPriceGuild	= "?????????";
		GuiAskPriceHeader	= "????";
		GuiAskPriceHeaderHelp	= "????????";
		GuiAskPriceParty	= "?????????";
		GuiAskPriceSmart	= "????????(smartwords)\n";
		GuiAskPriceTrigger	= "??(AskPrice)???\n";
		GuiAskPriceVendor	= "??????\n";
		GuiAskPriceWhispers	= "???????";
		GuiAskPriceWord	= "????????(smartwords)";
		GuiAuctionDuration	= "??????";
		GuiAuctionHouseHeader	= "?????";
		GuiAuctionHouseHeaderHelp	= "?????????";
		GuiAutofill	= "??????????";
		GuiAverages	= "????????";
		GuiBidmarkdown	= "??%";
		GuiClearall	= "??????????";
		GuiClearallButton	= "????";
		GuiClearallHelp	= "??????????????????";
		GuiClearallNote	= "??????-??";
		GuiClearHeader	= "????";
		GuiClearHelp	= "?????????????????????????:?????????";
		GuiClearsnap	= "????????";
		GuiClearsnapButton	= "????";
		GuiClearsnapHelp	= "??????????.";
		GuiDefaultAll	= "??????????";
		GuiDefaultAllButton	= "????";
		GuiDefaultAllHelp	= "???????????????????:?????????";
		GuiDefaultOption	= "?????";
		GuiEmbed	= "??????????";
		GuiEmbedBlankline	= "??????????";
		GuiEmbedHeader	= "??";
		GuiFinish	= "???????";
		GuiFinishSound	= "??????????";
		GuiLink	= "?? LinkID";
		GuiLoad	= "??????";
		GuiLoad_Always	= "??????";
		GuiLoad_AuctionHouse	= "????????";
		GuiLoad_Never	= "??????";
		GuiLocale	= "?????";
		GuiMainEnable	= "??????";
		GuiMainHelp	= "??????????????????,?????????????????\"??\"??????????";
		GuiMarkup	= "??????";
		GuiMaxless	= "??????????";
		GuiMedian	= "?????";
		GuiNocomp	= "????????";
		GuiNoWorldMap	= "????:??????????";
		GuiOtherHeader	= "????";
		GuiOtherHelp	= "??????";
		GuiPercentsHeader	= "?????????";
		GuiPercentsHelp	= "??:????????????????????????????????";
		GuiPrintin	= "????????";
		GuiProtectWindow	= "???????????";
		GuiRedo	= "?????????????";
		GuiReloadui	= "?????????(UI)";
		GuiReloaduiButton	= "????UI";
		GuiReloaduiFeedback	= "????????????UI";
		GuiReloaduiHelp	= "?????????UI????????????:?????????????";
		GuiRememberText	= "????";
		GuiStatsEnable	= "????";
		GuiStatsHeader	= "??????";
		GuiStatsHelp	= "????????????";
		GuiSuggest	= "??????";
		GuiUnderlow	= "?????????";
		GuiUndermkt	= "????????";
		GuiVerbose	= "????";
		GuiWarnColor	= "??????";


		-- Section: Conversion Messages
		MesgConvert	= "?????????????? SavedVariables\Auctioneer.lua.%s%s";
		MesgConvertNo	= "??????";
		MesgConvertYes	= "??";
		MesgNotconverting	= "?????????????,?????????????????";


		-- Section: Game Constants
		TimeLong	= "?";
		TimeMed	= "?";
		TimeShort	= "?";
		TimeVlong	= "???";


		-- Section: Generic Messages
		DisableMsg	= "??????????";
		FrmtWelcome	= "???? v%s ???";
		MesgNotLoaded	= "????????? ?? /auctioneer ?????";
		StatAskPriceOff	= "???????";
		StatAskPriceOn	= "???????";
		StatOff	= "?????????";
		StatOn	= "??????????";


		-- Section: Generic Strings
		TextAuction	= "??";
		TextCombat	= "??";
		TextGeneral	= "??";
		TextNone	= "?";
		TextScan	= "??";
		TextUsage	= "??:";


		-- Section: Help Text
		HelpAlso	= "?????????????????: \"/auctioneer also ???-??\" ??????:opposite(????), off(????)";
		HelpAskPrice	= "?????????";
		HelpAskPriceAd	= "??????????????";
		HelpAskPriceGuild	= "??????????";
		HelpAskPriceParty	= "??????????";
		HelpAskPriceSmart	= "?????????????(SmartWords checking)?\n";
		HelpAskPriceTrigger	= "????(AskPrice)??????";
		HelpAskPriceVendor	= "??????????????\n";
		HelpAskPriceWhispers	= "?????????????";
		HelpAskPriceWord	= "?????????????(smartwords)";
		HelpAuctionClick	= "??? Alt+???????? ???????";
		HelpAuctionDuration	= "???????????,????????";
		HelpAutofill	= "??????????,?????????";
		HelpAverage	= "???????????????";
		HelpBidbroker	= "????????????????????????????";
		HelpBidLimit	= "?????,?????????????????";
		HelpBroker	= "????????,?????????????????????";
		HelpClear	= "?????????(???Shift+?????????????)???????????\"all\"?\"snapshot\"";
		HelpCompete	= "????????????????????";
		HelpDefault	= "???????????????,??????\"all\"????????????";
		HelpDisable	= "????????????????";
		HelpEmbed	= "??????????????(??:?????????????)";
		HelpEmbedBlank	= "?????????????????????(?????????on)";
		HelpFinish	= "????????,???????????";
		HelpFinishSound	= "???????????????";
		HelpLink	= "??????????link id";
		HelpLoad	= "???????????";
		HelpLocale	= "?????????????";
		HelpMedian	= "??????????????";
		HelpOnoff	= "??/????????";
		HelpPctBidmarkdown	= "????(???)????????????";
		HelpPctMarkup	= "????????????,????(???)?????????????";
		HelpPctMaxless	= "???????????,?????????(???)???,??????????????";
		HelpPctNocomp	= "?????????,????????????????(???)";
		HelpPctUnderlow	= "?????????????????????(???)";
		HelpPctUndermkt	= "?????????????????(???)????,??????(????????)";
		HelpPercentless	= "????????,??????????????????????";
		HelpPrintin	= "????????????????,?????????,??????";
		HelpProtectWindow	= "????????????";
		HelpRedo	= "?????????????????????????";
		HelpScan	= "??????(?????????,?????????)????????????????????????????????????";
		HelpStats	= "????????????/??????";
		HelpSuggest	= "?????????????";
		HelpUpdatePrice	= "?????,??????????????";
		HelpVerbose	= "???????????????????(??????????)";
		HelpWarnColor	= "???????????????????(??:????)";


		-- Section: Post Messages
		FrmtNoEmptyPackSpace	= "????????????";
		FrmtNotEnoughOfItem	= "????? %s ????????";
		FrmtPostedAuction	= "???????? 1 ? %s (x%d) ";
		FrmtPostedAuctions	= "???????? %d ? %s (x%d) ";


		-- Section: Report Messages
		FrmtBidbrokerCurbid	= "????";
		FrmtBidbrokerDone	= "?????(Bid broker)??";
		FrmtBidbrokerHeader	= "????:%s,??='?????'";
		FrmtBidbrokerLine	= "%s, ??? %s ?, ???:%s, %s:%s, ??:%s, ??:%s";
		FrmtBidbrokerMinbid	= "?????";
		FrmtBrokerDone	= "??(Broker)??";
		FrmtBrokerHeader	= "????:%s,??='?????'";
		FrmtBrokerLine	= "%s,??%s?,??:%s,????:%s,??:%s";
		FrmtCompeteDone	= "????";
		FrmtCompeteHeader	= "??????????%s";
		FrmtCompeteLine	= "%s, ??:%s, ???:%s vs %s, ?? %s";
		FrmtHspLine	= "?? %s ??????:%s";
		FrmtLowLine	= "%s, ???:%s, ???:%s, ??:%s, ?????:%s";
		FrmtMedianLine	= "???? %d ?, ?? %s ???????:%s";
		FrmtNoauct	= "?????????:%s";
		FrmtPctlessDone	= "????????";
		FrmtPctlessHeader	= "???????????(HSP):%d%%";
		FrmtPctlessLine	= "%s, ??? %d ?, ???:%s, ???:%s, ??:%s, ?? %s";


		-- Section: Scanning Messages
		AuctionDefunctAucts	= "????????:%s";
		AuctionDiscrepancies	= "??????:%s";
		AuctionNewAucts	= "???????:%s";
		AuctionOldAucts	= "??????:%s";
		AuctionPageN	= "????: \n???? %s ?%d? ?%d?\n??????:%s \n??????:%s";
		AuctionScanDone	= "????:??????";
		AuctionScanNexttime	= "??????????????????????";
		AuctionScanNocat	= "????????????????";
		AuctionScanRedo	= "???????? %d ???,?????";
		AuctionScanStart	= "????:???? %s ?1?...";
		AuctionTotalAucts	= "????????:%s";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "? %s ?? %d ?";
		FrmtInfoAverage	= "%s ??/%s ?? (%s ??)";
		FrmtInfoBidMulti	= "??(?? %s%s)";
		FrmtInfoBidOne	= "?? %s";
		FrmtInfoBidrate	= "%d%% ???, %d%% ????";
		FrmtInfoBuymedian	= "?????";
		FrmtInfoBuyMulti	= "??(?? %s%s)";
		FrmtInfoBuyOne	= "?? %s";
		FrmtInfoForone	= "??:?? %s/?? %s(?? %s) [%d ?]";
		FrmtInfoHeadMulti	= "%d ???????:";
		FrmtInfoHeadOne	= "???????:";
		FrmtInfoHistmed	= "??? %d ?,?????(??)";
		FrmtInfoMinMulti	= "???(?? %s)";
		FrmtInfoMinOne	= "???";
		FrmtInfoNever	= "????? %s ?";
		FrmtInfoSeen	= "???????? %d ?";
		FrmtInfoSgst	= "????:?? %s/?? %s";
		FrmtInfoSgststx	= "?????? %d ??????:?? %s/?? %s";
		FrmtInfoSnapmed	= "??? %d ?,?????(??)";
		FrmtInfoStacksize	= "??????:%d?";


		-- Section: User Interface
		FrmtLastSoldOn	= "??????";
		UiBid	= "??";
		UiBidHeader	= "??";
		UiBidPerHeader	= "????";
		UiBuyout	= "??";
		UiBuyoutHeader	= "??";
		UiBuyoutPerHeader	= "????";
		UiBuyoutPriceLabel	= "???:";
		UiBuyoutPriceTooLowError	= "(???????)";
		UiCategoryLabel	= "????:";
		UiDepositLabel	= "???:";
		UiDurationLabel	= "????:";
		UiItemLevelHeader	= "??";
		UiMakeFixedPriceLabel	= "??????";
		UiMaxError	= "(%d ??)";
		UiMaximumPriceLabel	= "????:";
		UiMaximumTimeLeftLabel	= "??????:";
		UiMinimumPercentLessLabel	= "??????:";
		UiMinimumProfitLabel	= "????:";
		UiMinimumQualityLabel	= "??????:";
		UiMinimumUndercutLabel	= "????:";
		UiNameHeader	= "??";
		UiNoPendingBids	= "?????????!";
		UiNotEnoughError	= "(??)";
		UiPendingBidInProgress	= "?1??????????...";
		UiPendingBidsInProgress	= "%d?????????...";
		UiPercentLessHeader	= "%";
		UiPost	= "????";
		UiPostAuctions	= "????";
		UiPriceBasedOnLabel	= "????:";
		UiPriceModelAuctioneer	= "????";
		UiPriceModelCustom	= "????";
		UiPriceModelFixed	= "????";
		UiPriceModelLastSold	= "?????";
		UiProfitHeader	= "??";
		UiProfitPerHeader	= "????";
		UiQuantityHeader	= "??";
		UiQuantityLabel	= "????:";
		UiRemoveSearchButton	= "??";
		UiSavedSearchLabel	= "??????:";
		UiSaveSearchButton	= "??";
		UiSaveSearchLabel	= "????????:";
		UiSearch	= "??";
		UiSearchAuctions	= "????";
		UiSearchDropDownLabel	= "??:";
		UiSearchForLabel	= "????:";
		UiSearchTypeBids	= "????";
		UiSearchTypeBuyouts	= "?????";
		UiSearchTypeCompetition	= "??";
		UiSearchTypePlain	= "??";
		UiStacksLabel	= "?";
		UiStackTooBigError	= "(????)";
		UiStackTooSmallError	= "(????)";
		UiStartingPriceLabel	= "????:";
		UiStartingPriceRequiredError	= "(????)";
		UiTimeLeftHeader	= "????";
		UiUnknownError	= "(??)";

	};

	elGR = {


		-- Section: Auction Messages
		FrmtActRemove	= "?fa??es? t?? ?p???af?? %s ap? t? d?�?p?as?a.";
		FrmtAuctinfoHist	= "%d ?st?????";
		FrmtAuctinfoMktprice	= "??�? ??st???";
		FrmtAuctinfoNolow	= "??t??e?�e?? de? e?e? e?d?8e? st? te?e?ta?a d?�?p?as?a";
		FrmtAuctinfoOrig	= "?????? ???sf??a";
		FrmtAuctinfoSnap	= "%d te?e?ta?a a?a??t?s?.";
		FrmtAuctinfoSugbid	= "???t? p??sf??a";
		FrmtAuctinfoSugbuy	= "???te???�e?? t?�? a???a?";
		FrmtWarnAbovemkt	= "??ta????s�?? se a??te?a ep?peda ap? t?? t?�? ??st???";
		FrmtWarnMyprice	= "???s? t?? t?????? t?�??";
		FrmtWarnNocomp	= "????? ??ta????s�?";
		FrmtWarnNodata	= "?e? ?pa????? p????f???e? ??a HSP ";
		FrmtWarnToolow	= "?e? �p??e? ?a p?aste? ? ?at?te?? t?�?";
		FrmtWarnUndercut	= "?e??s? ?ata %s%% ";
		FrmtWarnUser	= "???s? t?�?? t?? ???st?";


		-- Section: Game Constants
		TimeLong	= "?a???";
		TimeMed	= "?esa?a";
		TimeShort	= "S??t?�a";
		TimeVlong	= "??e?? ?a???";

	};

	trTR = {


		-- Section: Auction Messages
		FrmtActRemove	= "%s Bu parça Mevcut AH taramasından kaldırıldı.";
		FrmtAuctinfoHist	= "%d geçmişi";
		FrmtAuctinfoLow	= "En düşük fiyat";
		FrmtAuctinfoMktprice	= "Pazar fiyatı";
		FrmtAuctinfoNolow	= "Bu parça daha önce hiç görülmedi";
		FrmtAuctinfoOrig	= "Orijinal teklif";
		FrmtAuctinfoSnap	= "%d son tarama";
		FrmtAuctinfoSugbid	= "Başlangıç fiyatı";
		FrmtAuctinfoSugbuy	= "Tavsiye edilen hemen-al fiyatı";
		FrmtWarnAbovemkt	= "Fiyatınız pazarın üzerinde ";
		FrmtWarnMarkup	= "Fiyatı tüccar alış fiyatının %s%% fazlasına eşitliyor";
		FrmtWarnMyprice	= "Mevcut fiyat kullanılıyor";
		FrmtWarnNocomp	= "Rekabet yok";
		FrmtWarnNodata	= "HSP için veri yok";
		FrmtWarnToolow	= "En düşük fiyatla çakışmıyor";
		FrmtWarnUndercut	= "Rekabet: Fiyat eksi %s%% ";
		FrmtWarnUser	= "Kullanıcı fiyatlandırması kullanılıyor";


		-- Section: Bid Messages
		FrmtNoAuctionsFound	= "Subasta no encontrada: %s(x%d)";


		-- Section: Command Messages
		FrmtActClearall	= "%s için bütün açık artırma verileri siliniyor ";
		FrmtActClearFail	= "Parça bulunamadı: %s";
		FrmtActClearOk	= "Parça için tüm bilgiler temizlendi: %s";
		FrmtActClearsnap	= "Son müzayede evi (AH) taraması temizlendi";
		FrmtActDefault	= "%s seçeneği varsayılan değerine getirildi";
		FrmtActDefaultall	= "Bütün seçenekler varsayılan değere indirgendi.";
		FrmtActDisable	= "%s parçasının verisi gösterilmiyor";
		FrmtActEnable	= "%s parçasının verisi gösteriliyor";
		FrmtActSet	= "%s '%s' olarak ayarlandı";
		FrmtActUnknown	= "Bilinmeyen komut: '%s'";
		FrmtAuctionDuration	= "Varsayılan açık artırma süresi %s olarak ayarlandı";
		FrmtAutostart	= "Otomatik olarak müzayedeye başlanıyor. Minimum: %s / Hemen-al: %s (%dh)\n%s";
		FrmtPrintin	= "Auctioneer mesajı şimdi %s chat penceresinde yazılacak.";
		FrmtProtectWindow	= "Müzayede evinin penceresinin koruması %s olarak ayarlandı";
		FrmtUnknownArg	= "'%s' '%s' için geçerli bir komut değil ";
		FrmtUnknownLocale	= "Belirttiğiniz yer ('%s') bilinmiyor. Belirlenen yerler:";
		FrmtUnknownRf	= "Geçersiz komut ('%s').  Komut şu şekilde formatlanmalı: [sunucu]-[taraf]. Örnek: Al'Akir-Horde";


		-- Section: Command Options
		OptAlso	= "(sunucu-taraf|karşı)";
		OptAuctionDuration	= "(son||2s||8s||24s) ";
		OptBidbroker	= "<gümüş_kazanç>";
		OptBroker	= "<gümüş_kazanç>";
		OptClear	= "([Parça]|hepsi|son tarama) ";
		OptCompete	= "<gümüş_az> ";
		OptDefault	= "(<seçenek>|hepsi) ";
		OptLocale	= "<yer>";
		OptPctBidmarkdown	= "<yüzde>";
		OptPctMarkup	= "<yüzde>";
		OptPctMaxless	= "<yüzde>";
		OptPctNocomp	= "<yüzde>";
		OptPctUnderlow	= "<yüzde>";
		OptPctUndermkt	= "<yüzde>";
		OptPercentless	= "<yüzde>";
		OptPrintin	= "(<Başlangıç Penceresi>[Numara]|<Pencere Adı>[Yazı]) ";
		OptProtectWindow	= "(asla||taramada||her zaman)";
		OptScale	= "<oran_faktör>";
		OptScan	= "<Tarama parametresi> ";


		-- Section: Commands
		CmdAlso	= "ek olarak";
		CmdAlsoOpposite	= "karşı";
		CmdAlt	= "Alt";
		CmdAuctionClick	= "müzayede-tıklama";
		CmdAuctionDuration	= "müzayede süresi";
		CmdAuctionDuration0	= "son";
		CmdAuctionDuration1	= "2s";
		CmdAuctionDuration2	= "8s";
		CmdAuctionDuration3	= "24s";
		CmdAutofill	= "otomatik doldurma";
		CmdBidbroker	= "bidbroker";
		CmdBidbrokerShort	= "bb";
		CmdBroker	= "broker";
		CmdClear	= "sil";
		CmdClearAll	= "hepsi";
		CmdClearSnapshot	= "Sontarama";
		CmdCompete	= "Rekabet";
		CmdCtrl	= "Ctrl";
		CmdDefault	= "Orijinal";
		CmdDisable	= "iptal";
		CmdEmbed	= "yerlestir";
		CmdLocale	= "yerbelirle";
		CmdOff	= "kapat";
		CmdOn	= "ac";
		CmdPctBidmarkdown	= "fiyat-dus";
		CmdPctMarkup	= "fiyat-art";
		CmdPctMaxless	= "fiyat-max-az";
		CmdPctNocomp	= "fiyat-rekabet-yok";
		CmdPctUnderlow	= "fiyat-en-asagi";
		CmdPctUndermkt	= "fiyat-pazar-altı";
		CmdPercentless	= "yuzdeucuz";
		CmdPercentlessShort	= "yu";
		CmdPrintin	= "buraya_aktar";
		CmdProtectWindow	= "pencere-koru";
		CmdProtectWindow0	= "asla";
		CmdProtectWindow1	= "taramada";
		CmdProtectWindow2	= "daima";
		CmdScan	= "tara";
		CmdShift	= "shift";
		CmdToggle	= "degistir";
		ShowAverage	= "ortalamayı-goster";
		ShowEmbedBlank	= "goster-yerlestir-beyazcizgi";
		ShowLink	= "goster-sekme";
		ShowMedian	= "goster-ortanca";
		ShowRedo	= "goster-uyarı";
		ShowStats	= "goster-istatistik";
		ShowSuggest	= "goster-oneri";
		ShowVerbose	= "goster-detayli";


		-- Section: Config Text
		GuiAlso	= "Ek veri gösterlecek";
		GuiAlsoDisplay	= "%s için veri gösteriliyor";
		GuiAlsoOff	= "Diğer sunucu/taraf verisi gösterilmiyor";
		GuiAlsoOpposite	= "Diğer taraf için de bilgi gösteriliyor.";
		GuiAuctionDuration	= "Varsayılan müzayede süresi";
		GuiAuctionHouseHeader	= "Müzayede evi (AH) penceresi";
		GuiAuctionHouseHeaderHelp	= "Müzayede evi (AH) penceresinin ayarlarını değiştir";
		GuiAutofill	= "Müzayede evinde (AH) fiyatları otomatik olarak gir.";
		GuiAverages	= "Ortalamaları göster";
		GuiBidmarkdown	= "%x daha düşük fiyata koy";
		GuiClearall	= "Bütün Auctioneer verilerini sil";
		GuiClearallButton	= "Hepsini Sil";
		GuiClearallHelp	= "Aktif sunucudaki tüm Auctioneer verilerini siler";
		GuiClearallNote	= "Aktif sunucu ve tarafın tüm verileri";
		GuiClearHeader	= "Verileri Sil";
		GuiClearHelp	= "Auctioneer verilerini siler. Tüm verileri veya son taramayı seçiniz. UYARI: bu işlemin geri dönüşü yok";
		GuiClearsnap	= "Son tarama verilerini sil";
		GuiClearsnapButton	= "Son tarama sil";
		GuiClearsnapHelp	= "Auctioneer in son tarama verilerini silmek için tıklayın.";
		GuiDefaultAll	= "Auctioneer ayarlarını sıfırla";
		GuiDefaultAllButton	= "Hepsini Sıfırla";
		GuiDefaultAllHelp	= "Auctioneer ayarlarının hepsini sıfırlamak için tıklayınız. UYARI: Bu işlemin geri dönüşü yoktur";
		GuiDefaultOption	= "Bu ayarı sıfırla";
		GuiEmbed	= "Bilgileri oyun içi imgeç ucuna yerleştir";
		GuiEmbedBlankline	= "Oyun içi imgeç ucunda boş satır göster";
		GuiEmbedHeader	= "Yerleştir";
		GuiLink	= "LinkID göster";
		GuiLoad	= "Auctioneer i otomatik yükle";
		GuiLoad_Always	= "daima";
		GuiLoad_AuctionHouse	= "Müzayede Evinde";
		GuiLoad_Never	= "asla";
		GuiLocale	= "Yer ayarla";
		GuiMainEnable	= "Etkinkil Auctioneer";
		GuiMaxless	= "Max pazar fiyatinin altına inme yüzdesi";
		GuiMedian	= "Ortancaları göster";
		GuiNocomp	= "Rekabet yokken indirim yüzdesi";
		GuiNoWorldMap	= "Auctioneer: Dünya haritasının gösterimi engellendi";
		GuiOtherHeader	= "Diğer seçenekler";
		GuiOtherHelp	= "Diğer Auctioneer seçenekleri";
		GuiPercentsHeader	= "Auctioneer limit yüzdeleri";
		GuiPercentsHelp	= "DİKKAT: Takip eden seçenekler SADECE uzman oyuncular içindir. Auctioneer'in karlılık belirlemesi yaparken ne kadar hırslı olmasını istediğinizi bu değerleri değiştirerek ayarlayın. ";
		GuiPrintin	= "Çıktı penceresi seç";
		GuiProtectWindow	= "Müzayede penceresinin istenmeden kapanmasını engelle";
		GuiRedo	= "Uzun tarama uyarısı";
		GuiReloadui	= "Kullanıcı arabirimini yeniden yükler";
		GuiReloaduiFeedback	= "WoW arabirimi yükleniyor";
		GuiReloaduiHelp	= "Ayarlarınızı yaptıktan sonra WoW arayüzünü tekrar yüklemek için buraya tıklayınız ki ayarlarınız uyuşsun.";
		GuiRememberText	= "Fiyatı hatırla";
		GuiStatsEnable	= "İstatistikleri göster";
		GuiStatsHeader	= "Fiyat İstatistikleri";
		GuiStatsHelp	= "Bu İstatistikleri Tooltip'de göster";
		GuiSuggest	= "Tavsiye edilen fiyatı göster";
		GuiUnderlow	= "En düşük rakibin altına inme yüzdesi";
		GuiUndermkt	= "Pazar altına inme yüzdesi";
		GuiVerbose	= "Detaylı Mode";


		-- Section: Conversion Messages
		MesgConvert	= "Auctioneer veritabanı dnüştürümü. Lütfen önce SavedVariables\Auctioneer.lua dosyanızı yedekleyin.%s%s";
		MesgConvertNo	= "Auctioneer'i devre dışı bırak";
		MesgConvertYes	= "Dönüştür";
		MesgNotconverting	= "Auctioneer veritabanınızı dönüştürmüyor, fakat bu işlemi yapmadığınız sürece de çalışmayacaktır.";


		-- Section: Game Constants
		TimeLong	= "Uzun";
		TimeMed	= "Orta";
		TimeShort	= "Kısa";
		TimeVlong	= "Çok Uzun";


		-- Section: Generic Messages
		DisableMsg	= "Auctioneer'in otomatik yüklenmesini devre dışı bırak.";
		FrmtWelcome	= "Auctioneer v%s yüklendi";
		MesgNotLoaded	= "Auctioneer yüklenmedi. Daha fazla bilgi için /auctioneer yazınız.";
		StatOff	= "Açık arttırma verileri gösterilmiyor.";
		StatOn	= "Tanımlanmış açık arttırma verileri görüntüleniyor.";


		-- Section: Generic Strings
		TextAuction	= "açık arttırma";
		TextCombat	= "Dövüş";
		TextGeneral	= "Genel";
		TextNone	= "hiçbirşey";
		TextScan	= "Tarama";
		TextUsage	= "Kullanımı:";


		-- Section: Scanning Messages
		AuctionDiscrepancies	= "Tutarsızlıklar: %s";
		AuctionScanDone	= "Auctioneer: Tarama sonuçlandı";
		AuctionScanNocat	= "En azından bir kategori tarama için seçilmiş olmalı";
		AuctionScanRedo	= "Su anki sayfanın tamamlanması %d saniyeden uzun sürdü, sayfayı tekrar deniyor.";
		AuctionScanStart	= "Auctioneer: taranıyor %s sayfa 1... ";
		AuctionTotalAucts	= "Taranan toplam açık artırma: %s ";


		-- Section: Tooltip Messages
		FrmtInfoAlsoseen	= "%s 'de %d kere görüldü ";
		FrmtInfoAverage	= "%s min/%s SA (%s teklif almış) ";
		FrmtInfoBidMulti	= "Teklif edilen (%s%s herbir) ";
		FrmtInfoBidOne	= "Teklif edilen%s";
		FrmtInfoBidrate	= "%d%% sine teklif var, %d%% sinin SA si var";
		FrmtInfoBuymedian	= "Satın al ortancası";
		FrmtInfoBuyMulti	= "Satın al (%s%s herbir) ";
		FrmtInfoBuyOne	= "Satın al%s ";
		FrmtInfoForone	= "1 adet için: %s min/%s SA (%s teklif almış) [in %d's] ";
		FrmtInfoHeadMulti	= "%d adet için ortalama: ";
		FrmtInfoHeadOne	= "Bu cisim için ortalamalar";
		FrmtInfoHistmed	= "Son %d, ortanca SA () ";
		FrmtInfoMinMulti	= "Başlangıç fiyatı (%s herbir) ";
		FrmtInfoMinOne	= "Başlangıç fiyatı";
		FrmtInfoNever	= "%s 'de hiç görülmedi";
		FrmtInfoSeen	= "%d kere açık artırmada görüldü toplamda";
		FrmtInfoSgst	= "Tavsiye edilen fiyat: %s min/%s SA";
		FrmtInfoSgststx	= "%d adetlik grubunuz için tavsiye edilen fiyat: %s min/%s SA";
		FrmtInfoSnapmed	= "Taranan %d, ortanca SA (herbir) ";
		FrmtInfoStacksize	= "Ortalama grup büyüklüğü: %d adet";

	};