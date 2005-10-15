--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: <%version%>
	Revision: $Id$

	Auctioneer command functions.
	Functions to allow setting of values, switching commands etc.
]]


-- GUI Init Variables (Added by MentalPower)
Auctioneer_GUI_Registered = nil;
Auctioneer_Khaos_Registered = nil;


function Auctioneer_Register()
	if (Khaos) then
		if (not Auctioneer_Khaos_Registered) then
			Auctioneer_GUI_Registered = Auctioneer_Register_Khaos();
		end
	end
	-- The following check is to accomodate other GUI libraries other than Khaos relatively easily.
	if (Auctioneer_GUI_Registered == true) then
		return true;
	else 
		return false;
	end
end

function Auctioneer_Register_Khaos()
	local optionSet = {
		id="Auctioneer";
		text="Auctioneer";
		helptext=_AUCT['GuiMainHelp'];
		difficulty=1;
		default={checked=true};
		options={
			{
				id="Header";
				text="Auctioneer";
				helptext=_AUCT['GuiMainHelp'];
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="AuctioneerEnable";
				type=K_TEXT;
				text=_AUCT['GuiMainEnable'];
				helptext=_AUCT['HelpOnoff'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_OnOff(_AUCT['CmdOn']);
					else
						Auctioneer_OnOff(_AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return _AUCT['StatOn'];
					else
						return _AUCT['StatOff'];
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				difficulty=1;
			};
			{
				id="AuctioneerLocale";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=_AUCT['GuiLocale'];
				helptext=_AUCT['HelpLocale'];
				callback = function(state)
					Auctioneer_SetLocale(state.value);
				end;
				feedback = function (state)
					return string.format(_AUCT['FrmtActSet'], _AUCT['CmdLocale'], state.value);
				end;
				default = {
					value = Auctioneer_GetLocale();
				};
				disabled = {
					value = Auctioneer_GetLocale();
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=2;				
			};
			{
				id="ReloadUI";
				type=K_BUTTON;
				setup={
					buttonText = _AUCT['GuiReloaduiButton'];
				};
				text=_AUCT['GuiReloadui'];
				helptext=_AUCT['GuiReloaduiHelp'];
				callback=function()
					ReloadUI();
				end;
				feedback=function()
					return _AUCT['GuiReloaduiFeedback'];
				end;
				difficulty=3;
			};
			{
				id=_AUCT['ShowRedo'];
				type=K_TEXT;
				text=_AUCT['GuiRedo'];
				helptext=_AUCT['HelpRedo'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['ShowRedo'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['ShowRedo'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowRedo']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowRedo']));
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id=_AUCT['ShowVerbose'];
				type=K_TEXT;
				text=_AUCT['GuiVerbose'];
				helptext=_AUCT['HelpVerbose'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['ShowVerbose'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['ShowVerbose'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowVerbose']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowVerbose']));
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id="AuctioneerStatsHeader";
				type=K_HEADER;
				text=_AUCT['GuiStatsHeader'];
				helptext=_AUCT['GuiStatsHelp'];
				difficulty=2;
			};
			{
				id=_AUCT['ShowStats'];
				type=K_TEXT;
				text=_AUCT['GuiStatsEnable'];
				helptext=_AUCT['HelpStats'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['ShowStats'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['ShowStats'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowStats']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowStats']));
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id=_AUCT['ShowAverage'];
				type=K_TEXT;
				text=_AUCT['GuiAverages'];
				helptext=_AUCT['HelpAverage'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['ShowAverage'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['ShowAverage'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowAverage']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowAverage']));
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			{
				id=_AUCT['ShowMedian'];
				type=K_TEXT;
				text=_AUCT['GuiMedian'];
				helptext=_AUCT['HelpMedian'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['ShowMedian'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['ShowMedian'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowMedian']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowMedian']));
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			{
				id=_AUCT['ShowSuggest'];
				type=K_TEXT;
				text=_AUCT['GuiSuggest'];
				helptext=_AUCT['HelpSuggest'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['ShowSuggest'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['ShowSuggest'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowSuggest']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowSuggest']));
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			--These functions have been removed from Auctioneer and placed in the Informant AddOn, as such their Khaos config options have been removed to prevent confusion.
			--[[{
				id="AuctioneerVendorHeader";
				type=K_HEADER;
				text=_AUCT['GuiVendorHeader'];
				helptext=_AUCT['GuiVendorHelp'];
				difficulty=1;
			};
			{
				id=_AUCT['ShowVendor'];
				type=K_TEXT;
				text=_AUCT['GuiVendor'];
				helptext=_AUCT['HelpVendor'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['ShowVendor'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['ShowVendor'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowVendor']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowVendor']));
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id=_AUCT['ShowVendorBuy'];
				type=K_TEXT;
				text=_AUCT['GuiVendorBuy'];
				helptext=_AUCT['HelpVendorBuy'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['ShowVendorBuy'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['ShowVendorBuy'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowVendorBuy']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowVendorBuy']));
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerVendor={checked=true;}, AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			{
				id=_AUCT['ShowVendorSell'];
				type=K_TEXT;
				text=_AUCT['GuiVendorSell'];
				helptext=_AUCT['HelpVendorSell'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['ShowVendorSell'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['ShowVendorSell'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowVendorSell']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowVendorSell']));
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerVendor={checked=true;}, AuctioneerEnable={checked=true;}};
				difficulty=2;
			};]]
			{
				id="AuctioneerEmbedHeader";
				type=K_HEADER;
				text=_AUCT['GuiEmbedHeader'];
				helptext=_AUCT['HelpEmbed'];
				difficulty=1;
			};
			{
				id=_AUCT['CmdEmbed'];
				type=K_TEXT;
				text=_AUCT['GuiEmbed'];
				helptext=_AUCT['HelpEmbed'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['CmdEmbed'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['CmdEmbed'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['CmdEmbed']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['CmdEmbed']));
					end
				end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id=_AUCT['ShowEmbedBlank'];
				type=K_TEXT;
				text=_AUCT['GuiEmbedBlankline'];
				helptext=_AUCT['HelpEmbedBlank'];
				callback=function(state)
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['ShowEmbedBlank'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['ShowEmbedBlank'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowEmbedBlank']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowEmbedBlank']));
					end
				end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				dependencies={AuctioneerEmbed={checked=true;}, AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id="AuctioneerClearHeader";
				type=K_HEADER;
				text=_AUCT['GuiClearHeader'];
				helptext=_AUCT['GuiClearHelp'];
				difficulty=3;
			};
			{
				id="AuctioneerClearAll";
				type=K_BUTTON;
				setup={
					buttonText = _AUCT['GuiClearallButton'];
				};
				text=_AUCT['GuiClearall'];
				helptext=_AUCT['GuiClearallHelp'];
				callback=function()
					Auctioneer_Clear(_AUCT['CmdClearAll']);
				end;
				feedback=function()
					return string.format(_AUCT['FrmtActClearall'],  _AUCT['GuiClearallNote']);
				end;
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
			{
				id="AuctioneerClearSnapshot";
				type=K_BUTTON;
				setup={
					buttonText=_AUCT['GuiClearsnapButton'];
				};
				text=_AUCT['GuiClearsnap'];
				helptext=_AUCT['GuiClearsnapHelp'];
				callback=function()
					Auctioneer_Clear(_AUCT['CmdClearSnapshot']);
				end;
				feedback=function()
					return _AUCT['FrmtActClearsnap'];
				end;
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
			{
				id="AuctioneerPercentsHeader";
				type=K_HEADER;
				text=_AUCT['GuiPercentsHeader'];
				helptext=_AUCT['GuiPercentsHelp'];
				difficulty=4;
			};
			{
				id=_AUCT['CmdPctBidmarkdown'];
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=_AUCT['GuiBidmarkdown'];
				helptext=_AUCT['HelpPctBidmarkdown'];
				callback = function(state)
					Auctioneer_PercentVarSet(_AUCT['CmdPctBidmarkdown'], state.value);
				end;
				feedback = function (state)
					return string.format(_AUCT['FrmtActSet'], _AUCT['CmdPctBidmarkdown'], state.value.."%");
				end;
				default = {
					value = _AUCT['OptPctBidmarkdownDefault'];
				};
				disabled = {
					value = _AUCT['OptPctBidmarkdownDefault'];
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;				
			};
			{
				id=_AUCT['CmdPctMarkup'];
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=_AUCT['GuiMarkup'];
				helptext=_AUCT['HelpPctMarkup'];
				callback = function(state)
					Auctioneer_PercentVarSet(_AUCT['CmdPctMarkup'], state.value);
				end;
				feedback = function (state)
					return string.format(_AUCT['FrmtActSet'], _AUCT['CmdPctMarkup'], state.value.."%");
				end;
				default = {
					value = _AUCT['OptPctMarkupDefault'];
				};
				disabled = {
					value = _AUCT['OptPctMarkupDefault'];
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};
			{
				id=_AUCT['CmdPctMaxless'];
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=_AUCT['GuiMaxless'];
				helptext=_AUCT['HelpPctMaxless'];
				callback = function(state)
					Auctioneer_PercentVarSet(_AUCT['CmdPctMaxless'], state.value);
				end;
				feedback = function (state)
					return string.format(_AUCT['FrmtActSet'], _AUCT['CmdPctMaxless'], state.value.."%");
				end;
				default = {
					value = _AUCT['OptPctMaxlessDefault'];
				};
				disabled = {
					value = _AUCT['OptPctMaxlessDefault'];
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};
			{
				id=_AUCT['CmdPctNocomp'];
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=_AUCT['GuiNocomp'];
				helptext=_AUCT['HelpPctNocomp'];
				callback = function(state)
					Auctioneer_PercentVarSet(_AUCT['CmdPctNocomp'], state.value);
				end;
				feedback = function (state)
					return string.format(_AUCT['FrmtActSet'], _AUCT['CmdPctNocomp'], state.value.."%");
				end;
				default = {
					value = _AUCT['OptPctNocompDefault'];
				};
				disabled = {
					value = _AUCT['OptPctNocompDefault'];
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};
			{
				id=_AUCT['CmdPctUnderlow'];
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=_AUCT['GuiUnderlow'];
				helptext=_AUCT['HelpPctUnderlow'];
				callback = function(state)
					Auctioneer_PercentVarSet(_AUCT['CmdPctUnderlow'], state.value);
				end;
				feedback = function (state)
					return string.format(_AUCT['FrmtActSet'], _AUCT['CmdPctUnderlow'], state.value.."%");
				end;
				default = {
					value = _AUCT['OptPctUnderlowDefault'];
				};
				disabled = {
					value = _AUCT['OptPctUnderlowDefault'];
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};
			{
				id=_AUCT['CmdPctUndermkt'];
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=_AUCT['GuiUndermkt'];
				helptext=_AUCT['HelpPctUndermkt'];
				callback = function(state)
					Auctioneer_PercentVarSet(_AUCT['CmdPctUndermkt'], state.value);
				end;
				feedback = function (state)
					return string.format(_AUCT['FrmtActSet'], _AUCT['CmdPctUndermkt'], state.value.."%");
				end;
				default = {
					value = _AUCT['OptPctUndermktDefault'];
				};
				disabled = {
					value = _AUCT['OptPctUndermktDefault'];
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};
			{
				id="AuctioneerOtherHeader";
				type=K_HEADER;
				text=_AUCT['GuiOtherHeader'];
				helptext=_AUCT['GuiOtherHelp'];
				difficulty=1;
			};
			{
				id=_AUCT['CmdAutofill'];
				type=K_TEXT;
				text=_AUCT['GuiAutofill'];
				helptext=_AUCT['HelpAutofill'];
				callback=function(state) 
					if (state.checked) then
						Auctioneer_GenVarSet(_AUCT['CmdAutofill'], _AUCT['CmdOn']);
					else
						Auctioneer_GenVarSet(_AUCT['CmdAutofill'], _AUCT['CmdOff']);
					end
				end;
				feedback=function(state)
					if (state.checked) then
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['CmdAutofill']));
					else
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['CmdAutofill']));
					end
				end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id="AuctioneerInclude";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=_AUCT['GuiAlso'];
				helptext=_AUCT['HelpAlso'];
				callback = function(state)
					Auctioneer_AlsoInclude(state.value);
				end;
				feedback = function (state)
					if (state.value == _AUCT['CmdAlsoOpposite']) then
						return _AUCT['GuiAlsoOpposite'];
					elseif (state.value == _AUCT['CmdOff']) then
						return _AUCT['GuiAlsoOff'];
					elseif (not Auctioneer_IsValidAlso(param)) then
						string.format(_AUCT['FrmtUnknownRf'], state.value)
					else
						return string.format(_AUCT['GuiAlsoDisplay'], state.value);
					end
				end;
				default = {
					value = _AUCT['CmdOff'];
				};
				disabled = {
					value = _AUCT['CmdOff'];
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=2;
			};
			{
				id="DefaultAll";
				type=K_BUTTON;
				setup={
					buttonText = _AUCT['GuiDefaultAllButton'];
				};
				text=_AUCT['GuiDefaultAll'];
				helptext=_AUCT['GuiDefaultAllHelp'];
				callback=function() 
					Auctioneer_Default(_AUCT['CmdClearAll']);
				end;
				feedback=function()
					return _AUCT['FrmtActDefaultall'];
				end;
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=1;
			};
			{
				id="DefaultOption";
				type=K_EDITBOX;
				setup = {
					callOn = {"enter", "tab"};
				};
				text=_AUCT['GuiDefaultOption'];
				helptext=_AUCT['HelpDefault'];
				callback = function(state)
					Auctioneer_Default(state.value);
				end;
				feedback = function (state)
					if (state.value == _AUCT['CmdClearAll']) then
						return _AUCT['FrmtActDefaultall'];
					else
						return string.format(_AUCT['FrmtActDefault'], state.value);
					end
				end;
				default = {
					value = "";
				};
				disabled = {
					value = "";
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=4;
			};		
			{
				id="AuctioneerPrintFrame";
				type=K_PULLDOWN;
				setup = {
					options = Auctioneer_GetFrameNames();
					multiSelect = false;
				};
				text=_AUCT['GuiPrintin'];
				helptext=_AUCT['HelpPrintin'];
				callback=function(state)
					Auctioneer_SetFrame(state.value);
				end;
				feedback=function(state)
					local _, frameName = Auctioneer_GetFrameNames(state.value)
					return string.format(_AUCT['FrmtPrintin'], frameName);
				end;
				default = {
					value=1;
				};
				disabled = {
					value=1;
				};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
			{
				id=_AUCT['ShowLink'];
				type=K_TEXT;
				text=_AUCT['GuiLink'];
				helptext=_AUCT['HelpLink'];
				callback=function(state) 
					if (state.checked) then 
						Auctioneer_GenVarSet(_AUCT['ShowLink'],_AUCT['CmdOn']);
					else 
						Auctioneer_GenVarSet(_AUCT['ShowLink'],_AUCT['CmdOff']);
					end 
				end;
				feedback=function(state) 
					if (state.checked) then 
						return (string.format(_AUCT['FrmtActEnable'], _AUCT['ShowLink'])) 
					else 
						return (string.format(_AUCT['FrmtActDisable'], _AUCT['ShowLink'])) 
					end 
				end;
				check=true;
				default={checked=false};
				disabled={checked=false};
				dependencies={AuctioneerEnable={checked=true;}};
				difficulty=3;
			};
		};
	};

	Khaos.registerOptionSet("tooltip",optionSet);
	Auctioneer_Khaos_Registered = true;
	
	return true;
end

--Cleaner Command Handling Functions (added by MentalPower)
function Auctioneer_Command(command, source)
	
	--To print or not to print, that is the question...
	local chatprint = nil;
	if (source == "GUI") then 
		chatprint = false;
	else 
		chatprint = true;
	end;
	
	--Divide the large command into smaller logical sections (Shameless copy from the original function)
	local i,j, cmd, param = string.find(command, "^([^ ]+) (.+)$");

	if (not cmd) then
		cmd = command;
	end

	if (not cmd) then
		cmd = "";
	end

	if (not param) then
		param = "";
	end

	--Now for the real Command handling
	if ((cmd == "") or (cmd == "help")) then
		Auctioneer_ChatPrint_Help();
		return;

	elseif (((cmd == _AUCT['CmdOn']) or (cmd == "on")) or ((cmd == _AUCT['CmdOff']) or (cmd == "off")) or ((cmd == _AUCT['CmdToggle']) or (cmd == "toggle"))) then
		Auctioneer_OnOff(cmd, chatprint);

	elseif ((cmd == _AUCT['CmdDisable']) or (cmd == "disable")) then
		Auctioneer_ChatPrint(_AUCT['DisableMsg']);
		Stubby.SetConfig("Auctioneer", "LoadType", "never");

	elseif ((cmd == _AUCT['CmdClear']) or (cmd == "clear")) then
		Auctioneer_Clear(param, chatprint);

	elseif ((cmd == _AUCT['CmdAlso']) or (cmd == "also")) then
		Auctioneer_AlsoInclude(param, chatprint);
	
	elseif ((cmd == _AUCT['CmdLocale']) or (cmd == "locale")) then
		Auctioneer_SetLocale(param, chatprint);

	elseif ((cmd == _AUCT['CmdDefault']) or (cmd == "default")) then
		Auctioneer_Default(param, chatprint);
	
	elseif ((cmd == _AUCT['CmdPrintin']) or (cmd == "printin")) then
		Auctioneer_SetFrame(param, chatprint)

	--The following are copied verbatim from the original function. These functions are not supported in the current Khaos-based GUI implementation and as such have been left intact.
	elseif ((cmd == _AUCT['CmdBroker']) or (cmd == "broker")) then
		Auctioneer_DoBroker(param);

	elseif ((cmd == _AUCT['CmdBidbroker']) or (cmd == _AUCT['CmdBidbrokerShort'])
		or (cmd == "bidbroker") or (cmd == "bb")) then
		Auctioneer_DoBidBroker(param);

	elseif ((cmd == _AUCT['CmdPercentless']) or (cmd == _AUCT['CmdPercentlessShort'])
		or (cmd == "percentless") or (cmd == "pl")) then
		Auctioneer_DoPercentLess(param);

	elseif ((cmd == _AUCT['CmdCompete']) or (cmd == "compete")) then
		Auctioneer_DoCompeting(param);

	elseif ((cmd == _AUCT['CmdScan']) or (cmd == "scan")) then
		Auctioneer_RequestAuctionScan();

	elseif (cmd == "low") then
		Auctioneer_DoLow(param);

	elseif (cmd == "med") then
		Auctioneer_DoMedian(param);

	elseif (cmd == "hsp") then
		Auctioneer_DoHSP(param);

	elseif (
		((cmd == _AUCT['CmdEmbed']) or (cmd == "embed")) or
		((cmd == _AUCT['CmdAutofill']) or (cmd == "autofill")) or
		((cmd == _AUCT['ShowVerbose']) or (cmd == "show-verbose")) or
		((cmd == _AUCT['ShowAverage']) or (cmd == "show-average")) or
		((cmd == _AUCT['ShowLink']) or (cmd == "show-link")) or
		((cmd == _AUCT['ShowMedian']) or (cmd == "show median")) or
		((cmd == _AUCT['ShowStack']) or (cmd == "show-stack")) or
		((cmd == _AUCT['ShowStats']) or (cmd == "show-stats")) or
		((cmd == _AUCT['ShowSuggest']) or (cmd == "show-suggest")) or
		((cmd == _AUCT['ShowUsage']) or (cmd == "show-usage")) or
		((cmd == _AUCT['ShowVendor']) or (cmd == "show-vendor")) or
		((cmd == _AUCT['ShowVendorBuy']) or (cmd == "show-vendor-buy")) or
		((cmd == _AUCT['ShowVendorSell']) or (cmd == "show-vendor-sell")) or		
		((cmd == _AUCT['ShowEmbedBlank']) or (cmd == "show-embed-blankline")) or
		((cmd == _AUCT['ShowRedo']) or (cmd == "show-redowarning")) or
		((cmd == AUCT_SHOW_HSP) or (cmd == "show-hsp")) --This command has not yet been implemented.
	) then
		Auctioneer_GenVarSet(cmd, param, chatprint);

	elseif (
		((cmd == _AUCT['CmdPctBidmarkdown']) or(cmd == "pct-bidmarkdown")) or
		((cmd == _AUCT['CmdPctMarkup']) or(cmd == "pct-markup")) or
		((cmd == _AUCT['CmdPctMaxless']) or(cmd == "pct-maxless")) or
		((cmd == _AUCT['CmdPctNocomp']) or(cmd == "pct-nocomp")) or
		((cmd == _AUCT['CmdPctUnderlow']) or(cmd == "pct-underlow")) or
		((cmd == _AUCT['CmdPctUndermkt']) or (cmd == "pct-undermkt"))
	) then
		Auctioneer_PercentVarSet(cmd, param, chatprint);

	else
		if (chatprint == true) then
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtActUnknown'], cmd));
		end
	end
end

--Help ME!! (The Handler) (Another shameless copy from the original function)
function Auctioneer_ChatPrint_Help()

	local onOffToggle = " (".._AUCT['CmdOn'].."|".._AUCT['CmdOff'].."|".._AUCT['CmdToggle']..")";
	local lineFormat = "  |cffffffff/auctioneer %s "..onOffToggle.."|r |cff2040ff[%s]|r - %s";

	Auctioneer_ChatPrint(_AUCT['TextUsage']);
	Auctioneer_ChatPrint("  |cffffffff/auctioneer "..onOffToggle.."|r |cff2040ff["..Auctioneer_GetFilterVal("all").."]|r - " .. _AUCT['HelpOnoff']);
	Auctioneer_ChatPrint("  |cffffffff/auctioneer ".._AUCT['CmdDisable'].."|r - " .. _AUCT['HelpDisable']);
	
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowVerbose'], Auctioneer_GetFilterVal(_AUCT['ShowVerbose']), _AUCT['HelpVerbose']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowAverage'], Auctioneer_GetFilterVal(_AUCT['ShowAverage']), _AUCT['HelpAverage']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowMedian'], Auctioneer_GetFilterVal(_AUCT['ShowMedian']), _AUCT['HelpMedian']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowSuggest'], Auctioneer_GetFilterVal(_AUCT['ShowSuggest']), _AUCT['HelpSuggest']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowStats'], Auctioneer_GetFilterVal(_AUCT['ShowStats']), _AUCT['HelpStats']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowVendor'], Auctioneer_GetFilterVal(_AUCT['ShowVendor']), _AUCT['HelpVendor']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowVendorSell'], Auctioneer_GetFilterVal(_AUCT['ShowVendorSell']), _AUCT['HelpVendorSell']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowVendorBuy'], Auctioneer_GetFilterVal(_AUCT['ShowVendorBuy']), _AUCT['HelpVendorBuy']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowUsage'], Auctioneer_GetFilterVal(_AUCT['ShowUsage']), _AUCT['HelpUsage']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowStack'], Auctioneer_GetFilterVal(_AUCT['ShowStack']), _AUCT['HelpStack']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowLink'], Auctioneer_GetFilterVal(_AUCT['ShowLink']), _AUCT['HelpLink']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdAutofill'], Auctioneer_GetFilterVal(_AUCT['CmdAutofill']), _AUCT['HelpAutofill']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdEmbed'], Auctioneer_GetFilterVal(_AUCT['CmdEmbed']), _AUCT['HelpEmbed']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowEmbedBlank'], Auctioneer_GetFilterVal(_AUCT['ShowEmbedBlank']), _AUCT['HelpEmbedBlank']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['ShowRedo'], Auctioneer_GetFilterVal(_AUCT['ShowRedo']), _AUCT['HelpRedo']));

	lineFormat = "  |cffffffff/auctioneer %s %s|r |cff2040ff[%s]|r - %s";
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdLocale'], _AUCT['OptLocale'], Auctioneer_GetFilterVal('locale'), _AUCT['HelpLocale']));

	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdPctMarkup'], _AUCT['OptPctMarkup'], Auctioneer_GetFilterVal(_AUCT['CmdPctMarkup'], _AUCT['OptPctMarkupDefault']), _AUCT['HelpPctMarkup']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdPctBidmarkdown'], _AUCT['OptPctBidmarkdown'], Auctioneer_GetFilterVal(_AUCT['CmdPctBidmarkdown'], _AUCT['OptPctBidmarkdownDefault']), _AUCT['HelpPctBidmarkdown']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdPctNocomp'], _AUCT['OptPctNocomp'], Auctioneer_GetFilterVal(_AUCT['CmdPctNocomp'], _AUCT['OptPctNocompDefault']), _AUCT['HelpPctNocomp']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdPctUnderlow'], _AUCT['OptPctUnderlow'], Auctioneer_GetFilterVal(_AUCT['CmdPctUnderlow'], _AUCT['OptPctUnderlowDefault']), _AUCT['HelpPctUnderlow']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdPctUndermkt'], _AUCT['OptPctUndermkt'], Auctioneer_GetFilterVal(_AUCT['CmdPctUndermkt'], _AUCT['OptPctUndermktDefault']), _AUCT['HelpPctUndermkt']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdPctMaxless'], _AUCT['OptPctMaxless'], Auctioneer_GetFilterVal(_AUCT['CmdPctMaxless'], _AUCT['OptPctMaxlessDefault']), _AUCT['HelpPctMaxless']));

	lineFormat = "  |cffffffff/auctioneer %s %s|r - %s";
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdClear'], _AUCT['OptClear'], _AUCT['HelpClear']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdAlso'], _AUCT['OptAlso'], _AUCT['HelpAlso']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdBroker'], _AUCT['OptBroker'], _AUCT['HelpBroker']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdBidbroker'], _AUCT['OptBidbroker'], _AUCT['HelpBidbroker']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdPercentless'], _AUCT['OptPercentless'], _AUCT['HelpPercentless']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdCompete'], _AUCT['OptCompete'], _AUCT['HelpCompete']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdScan'], _AUCT['OptScan'], _AUCT['HelpScan']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdDefault'], _AUCT['OptDefault'], _AUCT['HelpDefault']));
	Auctioneer_ChatPrint(string.format(lineFormat, _AUCT['CmdPrintin'], _AUCT['OptPrintin'], _AUCT['HelpPrintin']));

end

--The Auctioneer_OnOff(state, chatprint) function handles the state of the Auctioneer AddOn (whether it is currently on or off)
--If "on" or "off" is specified in the " state" variable then Auctioneer's state is changed to that value,
--If "toggle" is specified then it will toggle Auctioneer's state (if currently on then it will be turned off and vice-versa)
--If no keyword is specified then the function will simply return the current state
--
--If chatprint is "true" then the state will also be printed to the user.

function Auctioneer_OnOff(state, chatprint)

	if ((state == nil) or (state == "")) then
		state = Auctioneer_GetFilterVal("all");


	elseif ((state == _AUCT['CmdOn']) or (state == "on")) then
		Auctioneer_SetFilter("all", "on");


	elseif ((state == _AUCT['CmdOff']) or (state == "off")) then
		Auctioneer_SetFilter("all", "off");


	elseif ((state == _AUCT['CmdToggle']) or (state == "toggle")) then
		state = Auctioneer_GetFilterVal("all");

		if (state == "off") then
			Auctioneer_SetFilter("all", "on");
		else
			Auctioneer_SetFilter("all", "off");
		end
	end

	--Print the change and alert the GUI if the command came from slash commands. Do nothing if they came from the GUI.
	if (chatprint == true) then
		if ((state == _AUCT['CmdOn']) or (state == "on")) then
			Auctioneer_ChatPrint(_AUCT['StatOn']);

			if (Auctioneer_Khaos_Registered) then
				Khaos.setSetKeyParameter("Auctioneer", "AuctioneerEnable", "checked", true);

				if (Enchantrix) then
					Khaos.setSetKeyParameter("Enchantrix", "ValuateKey", "checked", true);
					Khaos.setSetKeyParameter("Enchantrix", "ENCH_SHOW_GUESS_AUCTIONEER_HSP", "helptext", ENCH_HELP_GUESS_AUCTIONEER_HSP);
					Khaos.setSetKeyParameter("Enchantrix", "ENCH_SHOW_GUESS_AUCTIONEER_MED", "helptext", ENCH_HELP_GUESS_AUCTIONEER_MEDIAN);
				end
			end
		else
			Auctioneer_ChatPrint(_AUCT['StatOff']);

			if (Auctioneer_Khaos_Registered) then
				Khaos.setSetKeyParameter("Auctioneer", "AuctioneerEnable", "checked", false);

				if (Enchantrix) then
					Khaos.setSetKeyParameter("Enchantrix", "ValuateKey", "checked", false);
					Khaos.setSetKeyParameter("Enchantrix", "ENCH_SHOW_GUESS_AUCTIONEER_HSP", "helptext", ENCH_HELP_GUESS_NOAUCTIONEER);
					Khaos.setSetKeyParameter("Enchantrix", "ENCH_SHOW_GUESS_AUCTIONEER_MED", "helptext", ENCH_HELP_GUESS_NOAUCTIONEER);
				end
			end
		end
	end

	return state;	
end

--The following functions are almost verbatim copies of the original functions but modified in order to make them compatible with direct GUI access.
function Auctioneer_Clear(param, chatprint)

	local aKey = Auctioneer_GetAuctionKey();
	local clearok = nil;

	if ((param == _AUCT['CmdClearAll']) or (param == "all")) then

		AuctionConfig.data = {};
		AuctionConfig.info = {};
		AuctionConfig.snap = {};
		AuctionConfig.sbuy = {};

	elseif ((param == _AUCT['CmdClearSnapshot']) or (param == "snapshot")) then

		AuctionConfig.snap = {};
		AuctionConfig.sbuy = {};
		lSnapshotItemPrices = {}; 

	else

		local items = Auctioneer_GetItems(param);
		if (items) then
			for pos,itemKey in pairs(items) do
				if (AuctionConfig.data[aKey][itemKey] ~= nil) then
					AuctionConfig.data[aKey][itemKey] = nil;

					if (AuctionConfig.stats[snapmed][aKey][itemKey] ~= nil) then
						AuctionConfig.stats[snapmed][aKey][itemKey] = nil;
					end

					if (AuctionConfig.stats[histmed][aKey][itemKey] ~= nil) then
						AuctionConfig.stats[histmed][aKey][itemKey] = nil;
					end

					if (AuctionConfig.stats[histcount][aKey][itemKey] ~= nil) then 
						AuctionConfig.stats[histcount][aKey][itemKey] = nil;
					end

					if (AuctionConfig.stats[snapcount][aKey][itemKey] ~= nil) then
						AuctionConfig.stats[snapcount][aKey][itemKey] = nil;
					end

					if (AuctionConfig.sbuy[aKey][itemKey] ~= nil) then
						AuctionConfig.sbuy[aKey][itemKey] = nil;
					end

					local count = 0;
					while (AuctionConfig.snap[aKey][count] ~= nil) do

						if (AuctionConfig.snap[aKey][count][itemKey] ~= nil) then
							AuctionConfig.snap[aKey][count][itemKey] =nil;
						end

					count = count+1;
					end

					if (Auctioneer_HSPCache[aKey][itemKey] ~= nil) then
						Auctioneer_HSPCache[aKey][itemKey] = nil;
					end

					--These are not included in the print statemet below because there could be the possiblity that an item's data was cleared but another's was not
					if (chatprint == true) then
						Auctioneer_ChatPrint(string.format(_AUCT['FrmtActClearOk'], param));
					end
				else
					if (chatprint == true) then
						Auctioneer_ChatPrint(string.format(_AUCT['FrmtActClearFail'], param));
					end
				end
			end
		end
	end

	if (chatprint == true) then

		if ((param == _AUCT['CmdClearAll']) or (param == "all")) then
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtActClearall'], aKey));

		elseif ((param == _AUCT['CmdClearSnapshot']) or (param == "snapshot")) then
			Auctioneer_ChatPrint(_AUCT['FrmtActClearsnap']);
		end
	end
end


function Auctioneer_AlsoInclude(param, chatprint)

	if ((param == _AUCT['CmdAlsoOpposite']) or (param == "opposite")) then
		param = "opposite";
	end

	if (not Auctioneer_IsValidAlso(param)) then

		if (chatprint == true) then 
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtUnknownRf'], param));
		end
		return
	end
	
	Auctioneer_SetFilter("also", param);
	
	if (chatprint == true) then 
		
		if (Auctioneer_Khaos_Registered) then 
			Khaos.setSetKeyParameter("Auctioneer", "AuctioneerInclude", "value", param);
		end

		if ((param == _AUCT['CmdOff']) or (param == "off")) then
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtActDisable'], _AUCT['CmdAlso']));	

		else
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtActSet'], _AUCT['CmdAlso'], param));
		end	
	end
end


function Auctioneer_SetLocale(param, chatprint)

local validLocale=nil;

	if (param == Auctioneer_GetLocale()) then
		--Do Nothing
		validLocale=true;
	elseif (AUCT_VALID_LOCALES[param]) then
		Auctioneer_SetFilter('locale', param);
		Auctioneer_SetLocaleStrings(Auctioneer_GetLocale());
		validLocale=true;

	elseif ((param == '') or (param == _AUCT['CmdDefault']) or (param == 'default') or (param == _AUCT['CmdOff']) or (param == 'off')) then
		Auctioneer_SetFilter('locale', _AUCT['CmdDefault']);
		Auctioneer_SetLocaleStrings(Auctioneer_GetLocale());
		validLocale=true;
	end
	
	
	if (chatprint == true) then

		if ((validLocale == true) and (AUCT_VALID_LOCALES[param])) then
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtActSet'], _AUCT['CmdLocale'], param));
			
			if (Auctioneer_Khaos_Registered) then
				Khaos.setSetKeyParameter("Auctioneer", "AuctioneerLocale", "value", param);
			end

		elseif (validLocale == nil) then
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtUnknownLocale'], param));

			if (AUCT_VALID_LOCALES) then
				for locale, x in pairs(AUCT_VALID_LOCALES) do
					Auctioneer_ChatPrint("  "..locale);
				end
			end

		else
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtActSet'], _AUCT['CmdLocale'], _AUCT['CmdDefault']));

			if (Auctioneer_Khaos_Registered) then
				Khaos.setSetKeyParameter("Auctioneer", "AuctioneerLocale", "value", _AUCT['CmdDefault']);
			end
		end
	end
end

--This function was added by MentalPower to implement the /auc default command
function Auctioneer_Default(param, chatprint)

	if ( (param == nil) or (param == "") ) then
		return

	elseif ((param == _AUCT['CmdClearAll']) or (param == "all")) then
		AuctionConfig = {};

	else
		Auctioneer_SetFilter(param, nil);
	end

	--@TODO: Move the default setting for the different functions over here to be able to communicate to Khaos what those setting are.
	if (chatprint == true) then
		if ((param == _AUCT['CmdClearAll']) or (param == "all") or (param == "") or (param == nil)) then
			Auctioneer_ChatPrint(_AUCT['FrmtActDefaultall']);

		else
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtActDefault'], param));
		end
	end
end

--The following three functions were added by MentalPower to implement the /auc print-in command
function Auctioneer_GetFrameNames(index)

	local frames = {};
	local frameName = "";

	for i=1,10 do 
		local name, fontSize, r, g, b, a, shown, locked, docked = GetChatWindowInfo(i);

		if ( name == "" ) then 
			if (i == 1) then
				frames["General"] = 1;
			elseif (i == 2) then
				frames["Combat"] = 2;
			end
		else 
			frames[name] = i;
		end
	end

	if (index) then
		local name, fontSize, r, g, b, a, shown, locked, docked = GetChatWindowInfo(index);

		if ( name == "" ) then 
			if (index == 1) then
				frameName = "General";
			elseif (index == 2) then
				frameName = "Combat";
			end
		else 
			frameName = name;
		end
	end
	
	return frames, frameName;
end


function Auctioneer_GetFrameIndex()

	if (not AuctionConfig.filters) then AuctionConfig.filters = {}; end
	local value = AuctionConfig.filters["printframe"];

	if (not value) then
		return 1;
	end
	return value;
end


function Auctioneer_SetFrame(frame, chatprint)
	local frameNumber
	local frameVal
	frameVal = tonumber(frame)

	--If no arguments are passed, then set it to the default frame.
	if not (frame) then 
		frameNumber = 1;

	--If the frame argument is a number then set our chatframe to that number.
	elseif ((frameVal) ~= nil) then 
		frameNumber = frameVal;

	--If the frame argument is a string, find out if there's a chatframe with that name, and set our chatframe to that index. If not set it to the default frame.
	elseif (type(frame) == "string") then
		allFrames = Auctioneer_GetFrameNames();
		if (allFrames[frame]) then
			frameNumber = allFrames[frame];
		else
			frameNumber = 1;
		end

	--If the argument is something else, set our chatframe to it's default value.
	else
		frameNumber = 1;
	end

	Auctioneer_SetFilter("printframe", frameNumber);

	if (chatprint == true) then
		local _, frameName = Auctioneer_GetFrameNames(frameNumber);
		Auctioneer_ChatPrint(string.format(_AUCT['FrmtPrintin'], frameName));

		if (Auctioneer_Khaos_Registered) then
			Khaos.setSetKeyParameter("Auctioneer", "AuctioneerPrintFrame", "state.value", frameNumber);
		end
	end
end


function Auctioneer_GenVarSet(variable, param, chatprint)

	if ((param == _AUCT['CmdOn']) or (param == "on")) then
		Auctioneer_SetFilter(variable, "on");

	elseif ((param == _AUCT['CmdOff']) or (param == "off")) then
		Auctioneer_SetFilter(variable, "off");

	elseif ((param == _AUCT['CmdToggle']) or (param == "toggle") or (param == nil) or (param == "")) then
		param = Auctioneer_GetFilterVal(variable);

		if ((param == _AUCT['CmdOn']) or (param == "on")) then
			param = _AUCT['CmdOff'];

		else
			param = _AUCT['CmdOn'];
		end

		Auctioneer_SetFilter(variable, param);
	end

	if (chatprint == true) then	

		if ((param == _AUCT['CmdOn']) or (param == "on")) then
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtActEnable'], variable));
			if (Auctioneer_Khaos_Registered) then
				Khaos.setSetKeyParameter("Auctioneer", variable, "checked", true);
			end

		elseif ((param == _AUCT['CmdOff']) or (param == "off")) then
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtActDisable'], variable));
			if (Auctioneer_Khaos_Registered) then
				Khaos.setSetKeyParameter("Auctioneer", variable, "checked", false);
			end
		end
	end
end


function Auctioneer_PercentVarSet(variable, param, chatprint)

	local paramVal = tonumber(param);
	if paramVal == nil then
		-- failed to convert the param to a number
		if chatprint then
			Auctioneer_ChatPrint(string.format(_AUCT['FrmtUnknownArg'], param, variable));
		end
		return -- invalid argument, don't do anything
	end
	-- param is a valid number, save it
	Auctioneer_SetFilter(variable, paramVal);

	if (chatprint == true) then
		Auctioneer_ChatPrint(string.format(_AUCT['FrmtActSet'], variable, paramVal.."%"));

		if (Auctioneer_Khaos_Registered) then
			Khaos.setSetKeyParameter("Auctioneer", variable, "value", paramVal);
		end
	end
end

--This marks the end of the New Command processing code.
function Auctioneer_SetFilter(type, value)
	if (not AuctionConfig.filters) then AuctionConfig.filters = {}; end
	AuctionConfig.filters[type] = value;
end

function Auctioneer_GetFilterVal(type, default)
	if (default == nil) then default = "on"; end
	if (not AuctionConfig.filters) then AuctionConfig.filters = {}; end
	local value = AuctionConfig.filters[type];
	if (not value) then
		if (type == _AUCT['ShowLink']) then return "off"; end
		if (type == _AUCT['CmdEmbed']) then return "off"; end
		return default;
	end
	return value;
end

function Auctioneer_GetFilter(filter)
	value = Auctioneer_GetFilterVal(filter);
	if ((value == _AUCT['CmdOn']) or (value == "on")) then return true;
	elseif ((value == _AUCT['CmdOff']) or (value == "off")) then return false; end
	return true;
end



function Auctioneer_FindFilterClass(text)
	local totalFilters = getn(CLASS_FILTERS);
	for currentFilter=1, totalFilters do
		if (text == CLASS_FILTERS[currentFilter]) then
			return currentFilter, totalFilters;
		end
	end
	return 0, totalFilters;
end

function AuctFilter_SetFilter(checkbox, filter)
	checkbox.filterVal = filter;
	checkbox:SetChecked(Auctioneer_GetFilter(filter));
	checkbox:Show();
end

function Auctioneer_GetLocale()
	local locale = Auctioneer_GetFilterVal('locale');
	if (locale ~= 'on') and (locale ~= 'off') and (locale ~= 'default') then
		return locale;
	end
	return GetLocale();
end

function Auctioneer_FilterButton_SetType(button, type, text, isLast)
	Auctioneer_Old_FilterButton_SetType(button, type, text, isLast);
	EnhTooltip.DebugPrint("Setting button", button:GetName(), type, text, isLast);

	local buttonName = button:GetName();
	local i,j, buttonID = string.find(buttonName, "(%d+)$");
	buttonID = tonumber(buttonID);

	local checkbox = getglobal(button:GetName().."Checkbox");
	if (type == "class") then
		local classid, maxid = Auctioneer_FindFilterClass(text);
		if (classid > 0) then
			AuctFilter_SetFilter(checkbox, "scan-class"..classid);
			if (classid == maxid) and (buttonID < 15) then
				for i=buttonID+1, 15 do
					getglobal("AuctionFilterButton"..i):Hide();
				end
			end
		else
			checkbox:Hide();
		end
	else
		checkbox:Hide();
	end
end


-- execute the '/auctioneer low <itemName>' that returns the auction for an item with the lowest buyout
function Auctioneer_DoLow(link)
	local itemID, randomProp, enchant, uniqID, itemName = EnhTooltip.BreakLink(link);
	local itemKey = itemID..":"..randomProp..":"..enchant;

	local auctionSignature = Auctioneer_FindLowestAuctions(itemKey);
	if (not auctionSignature) then
		Auctioneer_ChatPrint(string.format(_AUCT['FrmtNoauct'], Auctioneer_ColorTextWhite(itemName)));
	else
		local auctKey = Auctioneer_GetAuctionKey();
		local itemCat = Auctioneer_GetCatForKey(itemKey);
		local auction = Auctioneer_GetSnapshot(auctKey, itemCat, auctionSignature);
		local x,x,x, x, count, x, buyout, x = Auctioneer_GetItemSignature(auctionSignature);
		Auctioneer_ChatPrint(string.format(_AUCT['FrmtLowLine'], Auctioneer_ColorTextWhite(count.."x")..auction.itemLink, EnhTooltip.GetTextGSC(buyout), Auctioneer_ColorTextWhite(auction.owner), EnhTooltip.GetTextGSC(buyout / count), Auctioneer_ColorTextWhite(Auctioneer_PercentLessThan(Auctioneer_GetUsableMedian(itemKey), buyout / count).."%")));
	end
end

function Auctioneer_DoHSP(link)
	local itemID, randomProp, enchant, uniqID, itemName = EnhTooltip.BreakLink(link);
	local itemKey = itemID..":"..randomProp..":"..enchant;
	local highestSellablePrice = Auctioneer_GetHSP(itemKey, Auctioneer_GetAuctionKey());
	Auctioneer_ChatPrint(string.format(_AUCT['FrmtHspLine'], Auctioneer_ColorTextWhite(itemName), EnhTooltip.GetTextGSC(nilSafeString(highestSellablePrice))));
end


