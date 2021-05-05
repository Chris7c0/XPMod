void Bind2Press_Louis(iClient)
{
    if(g_fLouisXMRWallet[iClient] >= 0.1)
		ScriptKiddieExploitsMenuDraw(iClient);
	else
		PrintToChat(iClient, "\x03[XPMod] \x04You burned all your Monero. Go head hunting!");
}

// Script Kiddie Exploits Menu Draw
Action:ScriptKiddieExploitsMenuDraw(iClient)
{
	decl String:text[512];
	
	Menu menu = CreateMenu(ScriptKiddieExploitsMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	FormatEx(text, sizeof(text), "\
		\n \
		\n		H3D5h0P Pr353n7z\
		\n	5cR1PT k1Dd13 3xPl0172\
		\n=========================\
		\n  Monero Wallet: %.1f XMR\
		\n=========================\
		\n ",
		g_fLouisXMRWallet[iClient]);
	SetMenuTitle(menu, text);

	FormatEx(text, sizeof(text), "\
		5p3eD h4x\
		\n	%.1f XMR	%s",
		LOUIS_HEADSHOP_XMR_AMOUNT_SPEED_HAX,
		g_bSpeedHaxInCooldown == false ? "" : "SOLD OUT");
	AddMenuItem(menu, "option1", text);

	FormatEx(text, sizeof(text), "\
		m3d h4Ckz\
		\n	%.1f XMR	%s",
		LOUIS_HEADSHOP_XMR_AMOUNT_MED_HAX,
		g_bLouisMedHaxEnabled == false ? "" : "SOLD OUT");
	AddMenuItem(menu, "option2", text);

	FormatEx(text, sizeof(text), "\
		nUb w1p3\
		\n	%.1f XMR	%s",
		LOUIS_HEADSHOP_XMR_AMOUNT_NUB_WIPE,
		iClient != -1 ? "" : "SOLD OUT");
	AddMenuItem(menu, "option3", text);

	FormatEx(text, sizeof(text), "\
		h4k 74r9et\
		\n	%.1f XMR	%s",
		LOUIS_HEADSHOP_XMR_AMOUNT_HAK_TARGET,
		iClient == -1 ? "" : "SOLD OUT");
	AddMenuItem(menu, "option4",text);

	FormatEx(text, sizeof(text), "\
		t1m3 0u7\
		\n	%.1f XMR	%s",
		LOUIS_HEADSHOP_XMR_AMOUNT_TIME_OUT,
		iClient == -1 ? "" : "SOLD OUT");
	AddMenuItem(menu, "option5", text);

	FormatEx(text, sizeof(text), "\
		h4x0r 73h 53RV3r\
		\n	%.1f XMR	%s\n ",
		LOUIS_HEADSHOP_XMR_AMOUNT_HAXOR_TEH_SERVER,
		g_bHackTheServerInCooldown == false ? "" : "SOLD OUT");
	AddMenuItem(menu, "option6", text);

	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "", ITEMDRAW_NOTEXT);

	AddMenuItem(menu, "option10", "Nothing For Now.\
	\n=========================\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

// Scrip tKiddie Exploits Menu Handler
ScriptKiddieExploitsMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{	
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if (RunClientChecks(iClient) == false || 
			g_iClientTeam[iClient] != TEAM_SURVIVORS || 
			IsFakeClient(iClient))
			return;

		if (IsClientGrappled(iClient) || GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1)
		{
			PrintToChat(iClient, "\x03[XPMod] \x04You cannot use Script Kiddies Exploits while Grappled or Incapacitated.");
			ScriptKiddieExploitsMenuDraw(iClient);
			return;
		}

		switch (itemNum)
		{
			// 5p3eD h4x
			case 0: if (!SpeedHax(iClient)) ScriptKiddieExploitsMenuDraw(iClient);
			// m3D h4Kz
			case 1: if (!MedHax(iClient)) ScriptKiddieExploitsMenuDraw(iClient);
			// nUb w1p3
			case 2:	if (!NoobWipe(iClient)) ScriptKiddieExploitsMenuDraw(iClient);
			case 3: // h4k 74r9et
			{
				PrintToChat(iClient, "\x03[XPMod] \x04This item is SOLD OUT!");
				ScriptKiddieExploitsMenuDraw(iClient);
			}
			// t1m3 0u7
			case 4: 
			{
				PrintToChat(iClient, "\x03[XPMod] \x04This item is SOLD OUT!");
				ScriptKiddieExploitsMenuDraw(iClient);
			}
			// h4x0r 73h 53RV3r
			case 5:	if (!HackTheServer(iClient)) ScriptKiddieExploitsMenuDraw(iClient);
		}
	}
}

bool SpeedHax(iClient)
{
	// Check if the player has enough XMR
	if (g_fLouisXMRWallet[iClient] < LOUIS_HEADSHOP_XMR_AMOUNT_SPEED_HAX)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You don't have enough XMR...do some more brain surgery.");
		return false;
	}

	if (g_bSpeedHaxInCooldown)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05The server has been patched from previous 5p3eD h4k...looking for more exploitz...");
		return false;
	}

	// Set the cooldown
	g_bSpeedHaxInCooldown = true;
	CreateTimer(LOUIS_SPEED_HAX_COOLDOWN_DURATION, TimerLouisResetGlobalHeadShopCooldown, LOUIS_HEADSHOP_ITEM_SPEED_HAX, TIMER_FLAG_NO_MAPCHANGE);

	// Enable the speed hax override for all survivors
	g_bLouisSpeedHaxEnabled = true;
	SetClientSpeedForAllSurvivors();
	// Reset all survivor speed after duration has expired
	CreateTimer(LOUIS_SPEED_HAX_DURATION, TimerStopSpeedHax, _, TIMER_FLAG_NO_MAPCHANGE);

	PrintToChatAll("\x03[XPMod] \x04%N\x05 turned on 5p3Ed h4X for the Survivors.", iClient);

	// Remove the XMR from Louis's wallet for the hax
	g_fLouisXMRWallet[iClient] -= LOUIS_HEADSHOP_XMR_AMOUNT_SPEED_HAX;

	return true;
}

Action:TimerStopSpeedHax(Handle:timer, int blah)
{
	if (g_bLouisSpeedHaxEnabled == false)
		return Plugin_Stop;
	
	g_bLouisSpeedHaxEnabled = false;
	SetClientSpeedForAllSurvivors();

	PrintToChatAll("\x03[XPMod] \x05The 5p3Ed h4X have been patched.");
	
	return Plugin_Stop;
}

bool MedHax(iClient)
{
	// Check if the player has enough XMR
	if (g_fLouisXMRWallet[iClient] < LOUIS_HEADSHOP_XMR_AMOUNT_MED_HAX)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You don't have enough XMR...do some more brain surgery.");
		return false;
	}

	if (g_bLouisMedHaxEnabled)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05m3D h4Kz are already enabled on the server...");
		return false;
	}

	// Enable the med hax for all survivors
	g_bLouisMedHaxEnabled = true;
	SetConVarInt(FindConVar("survivor_revive_duration"), LOUIS_MED_HAX_USE_DURATION);
	SetConVarInt(FindConVar("first_aid_kit_use_duration"), LOUIS_MED_HAX_USE_DURATION);
	SetConVarInt(FindConVar("defibrillator_use_duration"), LOUIS_MED_HAX_USE_DURATION);
	// Reset to normal med use duration has expired
	CreateTimer(LOUIS_MED_HAX_DURATION, TimerStopMedHax, _, TIMER_FLAG_NO_MAPCHANGE);

	PrintToChatAll("\x03[XPMod] \x04%N\x05 used their m3D h4Kz. Survivors get instant medkits, revives, and defibs.", iClient);

	// Remove the XMR from Louis's wallet for the hax
	g_fLouisXMRWallet[iClient] -= LOUIS_HEADSHOP_XMR_AMOUNT_MED_HAX;

	return true;
}

Action:TimerStopMedHax(Handle:timer, int blah)
{
	if (g_bLouisMedHaxEnabled == false)
		return Plugin_Stop;
	
	g_bLouisMedHaxEnabled = false;
	// Reset to the default values
	SetConVarInt(FindConVar("survivor_revive_duration"), 5);
	SetConVarInt(FindConVar("first_aid_kit_use_duration"), 5);
	SetConVarInt(FindConVar("defibrillator_use_duration"), 3);

	PrintToChatAll("\x03[XPMod] \x05The m3D h4Kz have been patched.");
	
	return Plugin_Stop;
}


bool NoobWipe(iClient)
{
	// Check if the player has enough XMR
	if (g_fLouisXMRWallet[iClient] < LOUIS_HEADSHOP_XMR_AMOUNT_NUB_WIPE)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You don't have enough XMR...do some more brain surgery.");
		return false;
	}

	// if (g_bHackTheServerInCooldown)
	// {
	// 	PrintToChat(iClient, "\x03[XPMod] \x05The server has been patched from previous h4k...looking for more exploitz...");
	// 	return false;
	// }

	KillAllCI(iClient);

	// Remove the XMR from Louis's wallet for the hax
	g_fLouisXMRWallet[iClient] -= LOUIS_HEADSHOP_XMR_AMOUNT_NUB_WIPE;

	return true;
}


bool HackTheServer(iClient)
{
	// Check if the player has enough XMR
	if (g_fLouisXMRWallet[iClient] < LOUIS_HEADSHOP_XMR_AMOUNT_HAXOR_TEH_SERVER)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You don't have enough XMR...do some more brain surgery.");
		return false;
	}

	if (g_bHackTheServerInCooldown)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05The server has been patched from previous h4k...looking for more exploitz...");
		return false;
	}

	g_bHackTheServerInCooldown = true;
	CreateTimer(LOUIS_HAK_TEH_SERVER_COOLDOWN_DURATION, TimerLouisResetGlobalHeadShopCooldown, LOUIS_HEADSHOP_ITEM_HAXOR_TEH_SERVER, TIMER_FLAG_NO_MAPCHANGE);

	// Do the actual slow down time on the server
	TimeScale(LOUIS_HAK_TEH_SERVER_TIME_SCALE_FACTOR);
	// Reset the time scale after the the wait period
	CreateTimer(LOUIS_HAK_TEH_SERVER_DURATION, TimerResetTimeScale, iClient, TIMER_FLAG_NO_MAPCHANGE);
	// 
	PrintToChatAll("\x03[XPMod] \x04%N\x05 has H4X3D t3h 5erV3r", iClient);
	PrintToChatAll("Console: patching...", iClient);
	CreateTimer(LOUIS_HAK_TEH_SERVER_DURATION / 2.0, TimerPrintHakTehServerConsolePatchingMessage, _, TIMER_FLAG_NO_MAPCHANGE);

	// Remove the XMR from Louis's wallet for the hax
	g_fLouisXMRWallet[iClient] -= LOUIS_HEADSHOP_XMR_AMOUNT_HAXOR_TEH_SERVER;

	return true;
}

Action:TimerPrintHakTehServerConsolePatchingMessage(Handle:timer, int blah)
{
	switch(GetRandomInt(0, 6))
	{
		case 0: PrintToChatAll("Console: dammmit duritos alll ovr my fkin kebyoard");
		case 1: PrintToChatAll("Console: Who hacks a l4d2 server any way? what a loser.");
		case 2: PrintToChatAll("Console: learn to swim learn to swim learn to swim");
		case 3: PrintToChatAll("Console: Does anyone aaactually exist?");
		case 4: PrintToChatAll("Console: OHHHHH one zero ONE one!!");
		case 5: PrintToChatAll("Console: Think for yourself. Question authority.");
		case 6: PrintToChatAll("Console: okay server pat...wait shit.");
	}
	
	return Plugin_Stop;
}

Action:TimerResetTimeScale(Handle:timer, int iClient)
{
	TimeScale();
	PrintToChatAll("Console: okay server patched!", iClient);
	return Plugin_Stop;
}

TimeScale(float fScaleAmount = 1.0)
{
	if(fScaleAmount <= 0.0)
		return;

	int iTimeScaleEntity;
	char strScaleAmount[10];

	FloatToString(fScaleAmount, strScaleAmount, sizeof(strScaleAmount));

	iTimeScaleEntity = CreateEntityByName("func_timescale");
	DispatchKeyValue(iTimeScaleEntity, "desiredTimescale", strScaleAmount);
	DispatchKeyValue(iTimeScaleEntity, "acceleration", "2.0");
	DispatchKeyValue(iTimeScaleEntity, "minBlendRate", "1.0");
	DispatchKeyValue(iTimeScaleEntity, "blendDeltaMultiplier", "2.0");

	DispatchSpawn(iTimeScaleEntity);
	AcceptEntityInput(iTimeScaleEntity, "Start");
}

void KillAllCI(iClient)
{
	for (int i=1; i < MAXENTITIES; i++)
	{
		if (IsValidEntity(i) && IsCommonInfected(i, ""))
		{
			DealDamage(i, iClient, 9999);
			DealDamage(i, iClient, 9999);
			DealDamage(i, iClient, 9999);
			DealDamage(i, iClient, 9999);
			DealDamage(i, iClient, 9999);
		}
	}
}

Action:TimerLouisResetGlobalHeadShopCooldown(Handle:timer, int item)
{
	switch(item)
	{
		case LOUIS_HEADSHOP_ITEM_SPEED_HAX: 		g_bSpeedHaxInCooldown = false;
		case LOUIS_HEADSHOP_ITEM_HAXOR_TEH_SERVER: 	g_bHackTheServerInCooldown = false;
	}
	
	return Plugin_Stop;
}