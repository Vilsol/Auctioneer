--[[
	$Id$
	Version: <%version%>

	WARNING: This file is automatically generated from those in the
	locales directory. Do not edit it directly.

	You may find the source versions of this file at the
	project webpage, in the SVN repository.
	Please visit the homepage for more information.
		http://enchantrix.org/trac

	$Id$
	Version: <%version%>
]]






-- ============= AUTOMATICALLY GENERATED FILE =============
-- ================= DON'T EDIT THIS FILE =================

-- ============= AUTOMATICALLY GENERATED FILE =============
-- ================= DON'T EDIT THIS FILE =================

-- ============= AUTOMATICALLY GENERATED FILE =============
-- ================= DON'T EDIT THIS FILE =================

-- ============= AUTOMATICALLY GENERATED FILE =============
-- ================= DON'T EDIT THIS FILE =================

-- ============= AUTOMATICALLY GENERATED FILE =============
-- ================= DON'T EDIT THIS FILE =================

-- ============= AUTOMATICALLY GENERATED FILE =============
-- ================= DON'T EDIT THIS FILE =================






ENCH_VALID_LOCALES = {["deDE"] = true, ["enUS"] = true, ["esES"] = true};

function Enchantrix_SetLocaleStrings(locale)
	-- Default locale strings are defined in English
	
	
	
	
	ENCH_FRMT_WELCOME = "Enchantrix v%s loaded";
	ENCH_FRMT_CREDIT = "  (go to http://enchantrix.org/ to share your data)";
	
	ENCH_ARG_SPELLNAME = "Disenchant";
	
	ENCH_CMD_OFF = "off";
	ENCH_CMD_ON = "on";
	ENCH_CMD_TOGGLE = "toggle";
	ENCH_CMD_CLEAR = "clear";
	ENCH_CMD_CLEAR_ALL = "all";
	ENCH_CMD_LOCALE = "locale";
	
	ENCH_CMD_FIND_BUYAUCT = "percentless";
	ENCH_CMD_FIND_BIDAUCT = "bidbroker";
	
	ENCH_CMD_FIND_BUYAUCT_SHORT = "pl";
	ENCH_CMD_FIND_BIDAUCT_SHORT = "bb";
	
	ENCH_OPT_CLEAR = "([Item]|"..ENCH_CMD_CLEAR_ALL..")";
	ENCH_OPT_FIND_BUYAUCT = "<percent>";
	ENCH_OPT_FIND_BIDAUCT = "<silver>";
	
	ENCH_SHOW_EMBED = "show-embedded";
	ENCH_SHOW_HEADER = "show-header";
	ENCH_SHOW_COUNT = "show-count";
	ENCH_SHOW_RATE = "show-rate";
	ENCH_SHOW_VALUE = "show-value";
	ENCH_SHOW_GUESS_AUCTIONEER_HSP = "valuate-hsp";
	ENCH_SHOW_GUESS_AUCTIONEER_MED = "valuate-median";
	ENCH_SHOW_GUESS_BASELINE = "valuate-baseline";
	
	ENCH_HELP_ONOFF = "Turns the enchant data display on and off";
	ENCH_HELP_EMBED = "Embed the text in the original game tooltip (note: certain features are disabled when this is selected)";
	ENCH_HELP_HEADER = "Select whether to show the header line";
	ENCH_HELP_COUNT = "Select whether to show the exact counts in the database";
	ENCH_HELP_RATE = "Select whether to show the average quantity of disenchant";
	
	ENCH_HELP_VALUE = "Select whether to show item's estimated values based on the proportions of possible disenchants";
	ENCH_HELP_GUESS_AUCTIONEER_HSP = "If valuation is enabled, and you have auctioneer installed, display the sellable price (HSP) valuation of disenchanting the item.";
	ENCH_HELP_GUESS_AUCTIONEER_MEDIAN = "If valuation is enabled, and you have auctioneer installed, display the median based valuation of disenchanting the item.";
	ENCH_HELP_GUESS_NOAUCTIONEER = "The "..ENCH_SHOW_GUESS_AUCTIONEER_HSP.." and "..ENCH_SHOW_GUESS_AUCTIONEER_MED.." commands are not available because you do not have auctioneer installed";
	ENCH_HELP_GUESS_BASELINE = "If valuation is enabled, (auctioneer not needed) display the baseline valuation of disenchanting the item, based upon the inbuilt prices.";
	
	ENCH_HELP_CLEAR = "Clear the specified item's data (you must shift click insert the item(s) into the command) You may also specify the special keyword \"all\"";
	ENCH_HELP_FIND_BUYAUCT = "Find auctions whose possible disenchant value is a certain percent less than the buyout price";
	ENCH_HELP_FIND_BIDAUCT = "Find auctions whose possible disenchant value is a certain silver amount less than the bid price";
	
	ENCH_STAT_ON = "Displaying configured enchant data";
	ENCH_STAT_OFF = "Not displaying any enchant data";
	
	ENCH_FRMT_ACT_CLEARALL = "Clearing all auction data for %s";
	ENCH_FRMT_ACT_CLEAR_OK = "Cleared data for item: %s";
	ENCH_FRMT_ACT_CLEAR_FAIL = "Unable to find item: %s";
	ENCH_FRMT_ACT_ENABLE = "Displaying item's %s data";
	ENCH_FRMT_ACT_DISABLE = "Not displaying item's %s data";
	ENCH_FRMT_ACT_ENABLED_ON = "Displaying item's %s on %s";
	ENCH_FRMT_ACT_SET = "Set %s to '%s'";
	ENCH_FRMT_ACT_UNKNOWN = "Unknown command keyword: '%s'";
	ENCH_FRMT_ACT_UNKNOWN_LOCALE = "The locale you specified ('%s') is unknown. Valid locales are:";
	
	ENCH_FRMT_DISINTO = "Disenchants into:";
	ENCH_FRMT_FOUND = "Found that %s disenchants into:";
	ENCH_FRMT_USAGE = "Usage:";
	
	ENCH_FRMT_COUNTS = "    (base=%d, old=%d, new=%d)";
	ENCH_FRMT_VALUE_AUCT_HSP = "Disenchant value (HSP)";
	ENCH_FRMT_VALUE_AUCT_MED = "Disenchant value (Median)";
	ENCH_FRMT_VALUE_MARKET = "Disenchant value (Baseline)";
	
	ENCH_FRMT_BIDBROKER_HEADER = "Bids having %s silver savings on average disenchant value:";
	ENCH_FRMT_BIDBROKER_MINBID = "minBid"
	ENCH_FRMT_BIDBROKER_CURBID = "curBid"
	ENCH_FRMT_BIDBROKER_LINE = "%s, Valued at: %s, %s: %s, Save: %s, Less %s, Time: %s";
	ENCH_FRMT_BIDBROKER_DONE = "Bid brokering done";
	
	ENCH_FRMT_PCTLESS_HEADER = "Buyouts having %d%% savings over average item disenchant value:";
	ENCH_FRMT_PCTLESS_LINE = "%s, Valued at: %s, BO: %s, Save: %s, Less %s";
	ENCH_FRMT_PCTLESS_DONE = "Percent less done.";
	
	
	EssenceItemIDs = {};
	EssenceItemIDs["Greater Astral Essence"] = 11082;
	EssenceItemIDs["Greater Eternal Essence"] = 16203;
	EssenceItemIDs["Greater Magic Essence"] = 10939;
	EssenceItemIDs["Greater Mystic Essence"] = 11135;
	EssenceItemIDs["Greater Nether Essence"] = 11175;
	EssenceItemIDs["Lesser Astral Essence"] = 10998;
	EssenceItemIDs["Lesser Eternal Essence"] = 16202;
	EssenceItemIDs["Lesser Magic Essence"] = 10938;
	EssenceItemIDs["Lesser Mystic Essence"] = 11134;
	EssenceItemIDs["Lesser Nether Essence"] = 11174;
	EssenceItemIDs["Large Brilliant Shard"] = 14344;
	EssenceItemIDs["Large Glimmering Shard"] = 11084;
	EssenceItemIDs["Large Glowing Shard"] = 11139;
	EssenceItemIDs["Large Radiant Shard"] = 11178;
	EssenceItemIDs["Small Brilliant Shard"] = 14343;
	EssenceItemIDs["Small Glimmering Shard"] = 10978;
	EssenceItemIDs["Small Glowing Shard"] = 11138;
	EssenceItemIDs["Small Radiant Shard"] = 11177;
	EssenceItemIDs["Dream Dust"] = 11176;
	EssenceItemIDs["Illusion Dust"] = 16204;
	EssenceItemIDs["Soul Dust"] = 11083;
	EssenceItemIDs["Strange Dust"] = 10940;
	EssenceItemIDs["Vision Dust"] = 11137;


	-- Locale strings for the deDE locale
	if locale == "deDE" then
		-- Encoded in UTF8
		-- German localization for Enchantrix by FtKxDE
		-- http://norganna.org/bb/index.php?s=&showtopic=334&view=findpost&p=1561
		
		ENCH_FRMT_WELCOME="Enchantrix v%s geladen";
		ENCH_FRMT_CREDIT=" (gehe zu http://enchantrix.org/ um deine Daten zu \195\188bertragen)";
		
		ENCH_ARG_SPELLNAME="Entzaubern";
		
		ENCH_CMD_OFF="aus";
		ENCH_CMD_ON="an";
		ENCH_CMD_TOGGLE="toggle";
		ENCH_CMD_CLEAR="leeren";
		ENCH_CMD_CLEAR_ALL="alle";
		
		ENCH_CMD_FIND_BUYAUCT="prozentlos";
		ENCH_CMD_FIND_BIDAUCT="Angebotsmakler";
		
		ENCH_CMD_FIND_BUYAUCT_SHORT="pl";
		ENCH_CMD_FIND_BIDAUCT_SHORT="bb";
		
		ENCH_OPT_CLEAR="([Item]|"..ENCH_CMD_CLEAR_ALL..")";
		ENCH_OPT_FIND_BUYAUCT="<percent>";
		ENCH_OPT_FIND_BIDAUCT="<silver>";
		
		ENCH_SHOW_EMBED="zeige-eingebunden";
		ENCH_SHOW_HEADER="zeige-kopf";
		ENCH_SHOW_COUNT="zeige-anzahl";
		ENCH_SHOW_RATE="zeige-kurs";
		ENCH_SHOW_VALUE="zeige-wert";
		ENCH_SHOW_GUESS_AUCTIONEER_HSP="valuate-hvp";
		ENCH_SHOW_GUESS_AUCTIONEER_MED="valuate-median";
		ENCH_SHOW_GUESS_BASELINE="valuate-grundpreis";
		
		ENCH_HELP_ONOFF="Schaltet Anzeige Entzauberungsdaten ein oder aus";
		ENCH_HELP_EMBED="Zeige Text im normalen Tooltip (Hinweis: Einige Funktionen stehen dann nicht zur Verf\195\188gung)";
		ENCH_HELP_HEADER="Ausw\195\164hlen ob die Kopfzeile angezeigt werden soll";
		ENCH_HELP_COUNT="Ausw\195\164hlen ob genaue Anzahl angezeigt wird";
		ENCH_HELP_RATE="Ausw\195\164hlen ob ungef\195\164hrer Wert des Entzaubern angezeigt wird";
		
		ENCH_HELP_VALUE="Ausw\195\164hlen ob gesch\195\164tzte Werte der Entzauberung aufgrund \195\164hnlicher Gegenst\195\164nde angezeigt werden";
		ENCH_HELP_GUESS_AUCTIONEER_HSP="Wenn Wertebestimmung aktiv ist, und auctioneer installiert ist, zeige den h\195\182chsten Verkaufspreis (HVP) f\195\188r das Entzaubern";
		ENCH_HELP_GUESS_AUCTIONEER_MEDIAN="Wenn Wertebestimmung aktiv ist, und auctioneer installiert ist, zeige den durchschnittlichen Wert f\195\188r das Entzaubern";
		ENCH_HELP_GUESS_NOAUCTIONEER="Die Befehle "..ENCH_SHOW_GUESS_AUCTIONEER_HSP.." und "..ENCH_SHOW_GUESS_AUCTIONEER_MED.." sind nicht verf\195\188gbar weil Auctioneer nicht installiert ist";
		ENCH_HELP_GUESS_BASELINE="Wenn Wertebestimmung aktiv ist, (auctioneer nicht ben\195\182tigt) zeige Grundpreise aufgrund eingebauter fester Preisliste";
		
		ENCH_HELP_CLEAR="L\195\182sche Daten dieses Gegenstandes (Gegenst\195\164nde mit Shift-Klick einf\195\188gen zum Befehl) Alles l\195\182schen mit Befehl \"alle\"";
		ENCH_HELP_FIND_BUYAUCT="Suche Auktionen deren Entzauberwert einen gewissen Prozentsatz unter dem Sofortkaufpreis liegt";
		ENCH_HELP_FIND_BIDAUCT="Suche Auktionen deren Entzauberwert einen gewissen Wert unter dem Bietpreis liegt";
		
		ENCH_STAT_ON="Zeige eingestellte Entzauberungsdaten";
		ENCH_STAT_OFF="Zeige keine Entzauberungsdaten";
		
		ENCH_FRMT_ACT_CLEARALL="L\195\182sche alle Auktionsdaten f\195\188r %s";
		ENCH_FRMT_ACT_CLEAR_OK="L\195\182sche Daten f\195\188r Gegenstand %s";
		ENCH_FRMT_ACT_CLEAR_FAIL="Kann Gegenstand %s nicht finden";
		ENCH_FRMT_ACT_ENABLE="Zeige Daten von Gegenstand %s";
		ENCH_FRMT_ACT_DISABLE="Zeige keine Daten von Gegenstand %s";
		ENCH_FRMT_ACT_ENABLED_ON="Zeige Gegenstand %s auf %s";
		ENCH_FRMT_ACT_SET="Setze %s zu '%s'";
		ENCH_FRMT_ACT_UNKNOWN="Unbekannter Befehl: '%s'";
		
		ENCH_FRMT_DISINTO="Entzaubern zu:";
		ENCH_FRMT_FOUND="%s wird entzaubert zu:";
		ENCH_FRMT_USAGE="Benutzung:";
		
		ENCH_FRMT_COUNTS=" (basis=%d, alt=%d, neu=%d)";
		ENCH_FRMT_VALUE_AUCT_HSP="Entzaubern Gesamtwert (HSP)";
		ENCH_FRMT_VALUE_AUCT_MED="Entzaubern Gesamtwert (Median)";
		ENCH_FRMT_VALUE_MARKET="Entzaubern Gesamtwert (Baseline)";
		
		ENCH_FRMT_BIDBROKER_HEADER="Auktionen mit %s Silber Einsparung auf durchschnittlichen Entzauberungswert:";
		ENCH_FRMT_BIDBROKER_MINBID="minGeb"
		ENCH_FRMT_BIDBROKER_CURBID="aktGeb"
		ENCH_FRMT_BIDBROKER_LINE="%s, Wert bei: %s, %s: %s, Gespart: %s, weniger %s, Zeit: %s";
		ENCH_FRMT_BIDBROKER_DONE="Angebotsmakler fertig";
		
		ENCH_FRMT_PCTLESS_HEADER="Auktionen mit %d%% Einsparung auf durchschnittlichen Entzauberungswert:";
		ENCH_FRMT_PCTLESS_LINE="%s,Wert bei: %s, SK: %s, Erspart: %s, weniger %s";
		ENCH_FRMT_PCTLESS_DONE="Prozent weniger fertig.";
		
		
		EssenceItemIDs={};
		EssenceItemIDs["Gro\195\159e Astral-Essenz"] = 11082;
		EssenceItemIDs["Gro\195\159e ewige Essenz"] = 16203;
		EssenceItemIDs["Gro\195\159e Magie-Essenz"] = 10939;
		EssenceItemIDs["Gro\195\159e Mystiker-Essenz"] = 11135;
		EssenceItemIDs["Gro\195\159e Nether-Essenz"] = 11175;
		EssenceItemIDs["Geringe Astral-Essenz"] = 10998;
		EssenceItemIDs["Geringe ewige Essenz"] = 16202;
		EssenceItemIDs["Geringe Magie-Essenz"] = 10938;
		EssenceItemIDs["Geringe Mystiker-Essenz"] = 11134;
		EssenceItemIDs["Geringe Nether-Essenz"] = 11174;
		EssenceItemIDs["Gro\195\159er gl\195\164nzender Splitter"] = 14344;
		EssenceItemIDs["Gro\195\159er glei\195\159ender Splitter"] = 11084;
		EssenceItemIDs["Gro\195\159er leuchtender Splitter"] = 11139;
		EssenceItemIDs["Gro\195\159er strahlender Splitter"] = 11178;
		EssenceItemIDs["Kleiner gl\195\164nzender Splitter"] = 14343;
		EssenceItemIDs["Kleiner glei\195\159ender Splitter"] = 10978;
		EssenceItemIDs["Kleiner leuchtender Splitter"] = 11138;
		EssenceItemIDs["Kleiner strahlender Splitter"] = 11177;
		EssenceItemIDs["Traumstaub"] = 11176;
		EssenceItemIDs["Illusions Staub"] = 16204;
		EssenceItemIDs["Seelenstaub"] = 11083;
		EssenceItemIDs["Seltsamer Staub"] = 10940;
		EssenceItemIDs["Visionenstaub"] = 11137;

-- The following definitions are missing in this locale:
--	ENCH_CMD_LOCALE = "";
--	ENCH_FRMT_ACT_UNKNOWN_LOCALE = "";
	end



	-- Locale strings for the esES locale
	if locale == "esES" then
		-- Encoded in UTF8
		-- English localization for Enchantrix
		
		
		ENCH_FRMT_WELCOME="Enchantrix versi\195\179n %s cargado";
		ENCH_FRMT_CREDIT="  (vaya a http://enchantrix.org/ para compart\195\173r su data)";
		
		--ENCH_ARG_SPELLNAME = "Disenchant"; --Since there is currently no Spanish WoW client, changing this value to a localized version would essentially break Enchantrix.
		
		ENCH_CMD_OFF="apagado";
		ENCH_CMD_ON="prendido";
		ENCH_CMD_TOGGLE="invertir";
		ENCH_CMD_CLEAR="borrar";
		ENCH_CMD_CLEAR_ALL="todo";
		ENCH_CMD_LOCALE="localidad";
		
		ENCH_CMD_FIND_BUYAUCT="porcientomenos";
		ENCH_CMD_FIND_BIDAUCT="corredorofertas";
		
		ENCH_CMD_FIND_BUYAUCT_SHORT="pm";
		ENCH_CMD_FIND_BIDAUCT_SHORT="co";
		
		ENCH_OPT_CLEAR="([Item]|"..ENCH_CMD_CLEAR_ALL..")";
		ENCH_OPT_FIND_BUYAUCT="<percent>";
		ENCH_OPT_FIND_BIDAUCT="<silver>";
		
		ENCH_SHOW_EMBED="ver-integrado";
		ENCH_SHOW_HEADER="ver-titulo";
		ENCH_SHOW_COUNT="ver-cuenta";
		ENCH_SHOW_RATE="ver-razon";
		ENCH_SHOW_VALUE="ver-valor";
		ENCH_SHOW_GUESS_AUCTIONEER_HSP="valorizar-pmv";
		ENCH_SHOW_GUESS_AUCTIONEER_MED="valorizar-mediano";
		ENCH_SHOW_GUESS_BASELINE="valorizar-referencia";
		
		ENCH_HELP_ONOFF="Enciende o apaga la informaci\195\179n de encantos";
		ENCH_HELP_EMBED="Insertar el texto en la caja de ayuda original del juego (nota: Algunas capacidades se desabilitan cuando esta opci\195\179n es seleccionada)";
		ENCH_HELP_HEADER="Selecciona para mostrar la l\195\173nea del t\195\173tulo";
		ENCH_HELP_COUNT="Selecciona para mostrar los valores exactos de la base de datos";
		ENCH_HELP_RATE="Selecciona para mostrar las cantidades promedio de los desencantamientos";
		
		ENCH_HELP_VALUE="Selecciona para mostrar el precio estimado de los art\195\173culos basandose en la proporci\195\179n de los desencantamientos posibles";
		ENCH_HELP_GUESS_AUCTIONEER_HSP="Si la valorizaci\195\179n esta seleccionada, y usted tiene Auctioneer instalado, mostrar la valorizaci\195\179n de los desencantamientos del art\195\173culo basandose en los precios m\195\161ximos de venta (PMV) de Auctioneer.";
		ENCH_HELP_GUESS_AUCTIONEER_MEDIAN="Si la valorizaci\195\179n esta seleccionada, y usted tiene Auctioneer instalado, mostrar la valorizaci\195\179n de los desencantamientos del art\195\173culo basandose en los precios medianos de Auctioneer.";
		ENCH_HELP_GUESS_NOAUCTIONEER="Los comandos "..ENCH_SHOW_GUESS_AUCTIONEER_HSP.." y "..ENCH_SHOW_GUESS_AUCTIONEER_MED.." no estan disponibles porque usted no tiene Auctioneer instalado";
		ENCH_HELP_GUESS_BASELINE="Si la valorizaci\195\179n esta seleccionada, (Auctioneer no es necesario) mostrar la valorizaci\195\179n de los desencantamientos del art\195\173culo, basandose en los valores de referencia incluidos.";
		
		ENCH_HELP_CLEAR="Eliminar la informacion existente sobre el art\195\173culo(se debe usar shift-click para insertar el/los articulo(s) en el comando) Tambien se pueden especificar las palabra clave \"todo\"";
		ENCH_HELP_FIND_BUYAUCT="Encontrar subastas donde el valor posible de los desencantamientos es un cierto porciento menos que el precio de la opci\195\179n a compra";
		ENCH_HELP_FIND_BIDAUCT="Encontrar subastas donde el valor posible de los desencantamientos es una cierta cantidad de plata menos que el precio de oferta";
		
		ENCH_STAT_ON="Mostrando la configuracion corriente para la informacion de los desencantamientos";
		ENCH_STAT_OFF="Ocultando toda informaci\195\179n de los desencantamientos";
		
		ENCH_FRMT_ACT_CLEARALL="Eliminando toda informaci\195\179n de desencantamientos para %s";
		ENCH_FRMT_ACT_CLEAR_OK="Informacion eliminada para el art\195\173culo: %s";
		ENCH_FRMT_ACT_CLEAR_FAIL="Imposible encontrar art\195\173culo: %s";
		ENCH_FRMT_ACT_ENABLE="Mostrando informacion del art\195\173culo: %s ";
		ENCH_FRMT_ACT_DISABLE="Ocultando informacion de articulo: %s ";
		ENCH_FRMT_ACT_ENABLED_ON="Mostrando %s de los art\195\173culos usando %s";
		ENCH_FRMT_ACT_SET="%s ajustado(a) a '%s'";
		ENCH_FRMT_ACT_UNKNOWN="Comando o palabra clave desconocida: '%s'";
		ENCH_FRMT_ACT_UNKNOWN_LOCALE="La localizaci\195\179n que usted especifico ('%s') no es valida. Locales v\195\161lidos son:";
		
		ENCH_FRMT_DISINTO="Se convierte en:";
		ENCH_FRMT_FOUND="Se encontro que %s se convierte en:";
		ENCH_FRMT_USAGE="Uso:";
		
		ENCH_FRMT_COUNTS="    (referencia=%d, viejo=%d, nuevo=%d)";
		ENCH_FRMT_VALUE_AUCT_HSP="Valor de desencantamientos (PMV)";
		ENCH_FRMT_VALUE_AUCT_MED="Valor de desencantamientos (Mediano)";
		ENCH_FRMT_VALUE_MARKET="Valor de desencantamientos (Referencia)";
		
		ENCH_FRMT_BIDBROKER_HEADER="Ofertas teniendo promedios de ahorros de %s plata en el valor de los desencantamientos:";
		ENCH_FRMT_BIDBROKER_MINBID="ofertaMin"
		ENCH_FRMT_BIDBROKER_CURBID="ofertaCorr"
		ENCH_FRMT_BIDBROKER_LINE="%s, Valorado en: %s, %s: %s, Ahorra: %s, Menos %s, Tiempo: %s";
		ENCH_FRMT_BIDBROKER_DONE="Corredor de ofertas finalizado";
		
		ENCH_FRMT_PCTLESS_HEADER="Opciones a compra teniendo %d%% de ahorro sobre el precio promedio de desencantar el art\195\173culo:";
		ENCH_FRMT_PCTLESS_LINE="%s, Valorado en: %s, OC: %s, Ahorra: %s, Menos %s";
		ENCH_FRMT_PCTLESS_DONE="Porcentajes menores finalizado.";
		
		
		EssenceItemIDs={};
		EssenceItemIDs["Greater Astral Essence"] = 11082;
		EssenceItemIDs["Greater Eternal Essence"] = 16203;
		EssenceItemIDs["Greater Magic Essence"] = 10939;
		EssenceItemIDs["Greater Mystic Essence"] = 11135;
		EssenceItemIDs["Greater Nether Essence"] = 11175;
		EssenceItemIDs["Lesser Astral Essence"] = 10998;
		EssenceItemIDs["Lesser Eternal Essence"] = 16202;
		EssenceItemIDs["Lesser Magic Essence"] = 10938;
		EssenceItemIDs["Lesser Mystic Essence"] = 11134;
		EssenceItemIDs["Lesser Nether Essence"] = 11174;
		EssenceItemIDs["Large Brilliant Shard"] = 14344;
		EssenceItemIDs["Large Glimmering Shard"] = 11084;
		EssenceItemIDs["Large Glowing Shard"] = 11139;
		EssenceItemIDs["Large Radiant Shard"] = 11178;
		EssenceItemIDs["Small Brilliant Shard"] = 14343;
		EssenceItemIDs["Small Glimmering Shard"] = 10978;
		EssenceItemIDs["Small Glowing Shard"] = 11138;
		EssenceItemIDs["Small Radiant Shard"] = 11177;
		EssenceItemIDs["Dream Dust"] = 11176;
		EssenceItemIDs["Illusion Dust"] = 16204;
		EssenceItemIDs["Soul Dust"] = 11083;
		EssenceItemIDs["Strange Dust"] = 10940;
		EssenceItemIDs["Vision Dust"] = 11137;

-- The following definitions are missing in this locale:
--	ENCH_ARG_SPELLNAME = "";
	end

end

Enchantrix_SetLocaleStrings(GetLocale);

