void Bind2Press_Louis(int iClient)
{
    if(g_fLouisXMRWallet[iClient] >= 0.1)
		ScriptKiddieExploitsMenuDraw(iClient);
	else
		PrintToChat(iClient, "\x03[XPMod] \x04You burned all your Monero. Go head hunting!");
}

// Script Kiddie Exploits Menu Draw
Action ScriptKiddieExploitsMenuDraw(int iClient)
{
	char text[512];
	
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
		nUb w1p3\
		\n	%.1f XMR	%s",
		LOUIS_HEADSHOP_XMR_AMOUNT_NUB_WIPE,
		iClient != -1 ? "" : "SOLD OUT");
	AddMenuItem(menu, "option2", text);

	FormatEx(text, sizeof(text), "\
		m3d h4Ckz\
		\n	%.1f XMR	%s",
		LOUIS_HEADSHOP_XMR_AMOUNT_MED_HAX,
		g_bLouisMedHaxEnabled == false ? "" : "SOLD OUT");
	AddMenuItem(menu, "option3", text);

	FormatEx(text, sizeof(text), "\
		h4x0r 73h 53RV3r\
		\n	%.1f XMR	%s",
		LOUIS_HEADSHOP_XMR_AMOUNT_HAXOR_TEH_SERVER,
		g_bHackTheServerInCooldown == false ? "" : "SOLD OUT");
	AddMenuItem(menu, "option5", text);

	FormatEx(text, sizeof(text), "\
		h4k 74r9et\
		\n	%.1f XMR	%s",
		LOUIS_HEADSHOP_XMR_AMOUNT_HAK_TARGET,
		iClient != -1 ? "" : "SOLD OUT");
	AddMenuItem(menu, "option4",text);

	FormatEx(text, sizeof(text), "\
		t1m3 0u7\
		\n	%.1f XMR	%s\n ",
		LOUIS_HEADSHOP_XMR_AMOUNT_TIME_OUT,
		g_bTimeOutInCooldown == false ? "" : "SOLD OUT");
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
void ScriptKiddieExploitsMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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

		if (IsClientGrappled(iClient))
		{
			PrintToChat(iClient, "\x03[XPMod] \x04You cannot use Script Kiddies Exploits while Grappled.");
			ScriptKiddieExploitsMenuDraw(iClient);
			return;
		}

		switch (itemNum)
		{
			// 5p3eD h4x
			case 0: if (!SpeedHax(iClient)) ScriptKiddieExploitsMenuDraw(iClient);
			// nUb w1p3
			case 1:	if (!NoobWipe(iClient)) ScriptKiddieExploitsMenuDraw(iClient);
			// m3D h4Kz
			case 2: if (!MedHax(iClient)) ScriptKiddieExploitsMenuDraw(iClient);
			// h4x0r 73h 53RV3r
			case 3:	if (!HackTheServer(iClient)) ScriptKiddieExploitsMenuDraw(iClient);
			// hak 7arG3t
			case 4: if (!HackTargetPlayer(iClient)) ScriptKiddieExploitsMenuDraw(iClient);
			// t1m3 0u7
			case 5: if (!TimeOut(iClient)) ScriptKiddieExploitsMenuDraw(iClient);
		}
	}
}

bool SpeedHax(int iClient)
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

Action TimerStopSpeedHax(Handle timer, int blah)
{
	if (g_bLouisSpeedHaxEnabled == false)
		return Plugin_Stop;
	
	g_bLouisSpeedHaxEnabled = false;
	SetClientSpeedForAllSurvivors();

	PrintToChatAll("\x03[XPMod] \x05The 5p3Ed h4X have been patched.");
	
	return Plugin_Stop;
}

bool MedHax(int iClient)
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

Action TimerStopMedHax(Handle timer, int blah)
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


bool NoobWipe(int iClient)
{
	// Check if the player has enough XMR
	if (g_fLouisXMRWallet[iClient] < LOUIS_HEADSHOP_XMR_AMOUNT_NUB_WIPE)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You don't have enough XMR...do some more brain surgery.");
		return false;
	}

	if(g_bNoobWipeCooldown == true) {
		PrintHintText(iClient,"Global cooldown triggered. You must wait 15 seconds to use NoobWipe again.");
		return false;
	}

	// if (g_bHackTheServerInCooldown)
	// {
	// 	PrintToChat(iClient, "\x03[XPMod] \x05The server has been patched from previous h4k...looking for more exploitz...");
	// 	return false;
	// }

	KillAllCI(iClient);
	PrintToChatAll("\x03[XPMod] \x04%N\x05 Noob Wiped all the Common Infected.", iClient);
	g_bNoobWipeCooldown = true;
	CreateTimer(LOUIS_NOOBWIPE_COOLDOWN_DURATION, TimerReEnableNoobWipe, iClient, TIMER_FLAG_NO_MAPCHANGE);

	// Remove the XMR from Louis's wallet for the hax
	g_fLouisXMRWallet[iClient] -= LOUIS_HEADSHOP_XMR_AMOUNT_NUB_WIPE;

	return true;
}


bool HackTargetPlayer(int iClient)
{
	// Check if the player has enough XMR
	if (g_fLouisXMRWallet[iClient] < LOUIS_HEADSHOP_XMR_AMOUNT_HAK_TARGET)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You don't have enough XMR...do some more brain surgery.");
		return false;
	}

	// Draw the hack target menu for the player to use
	HackTargetPlayerMenuDraw(iClient)
	
	// // Remove the XMR from Louis's wallet for the hax
	// g_fLouisXMRWallet[iClient] -= LOUIS_HEADSHOP_XMR_AMOUNT_HAK_TARGET;

	return true;
}

// Hack Target Player Menu Draw
Action HackTargetPlayerMenuDraw(int iClient)
{
	char text[512], strTargetID[10];
	
	Menu menu = CreateMenu(HackTargetPlayerMenuHandler);
	
	FormatEx(text, sizeof(text), "\
		\n				H4K  T@RG37\
		\n					  v1.4.3\
		\n			3XP10i7 |3Y ChrisP\
		\n===============================\
		\n		Select A Target To Hack\
		\n		 Target Must Be Visible\
		\n===============================\
		\n ");
	SetMenuTitle(menu, text);

	AddMenuItem(menu, "Option0", " ***  Rescan  ***\n ");

	// Store the client's position to use for checking if they can see the targets
	float xyzClientLocation[3], xyzTargetLocation[3];
	GetClientEyePosition(iClient, xyzClientLocation);

	for (int iTarget=1; iTarget <= MaxClients; iTarget++)
	{
		if(RunClientChecks(iTarget) == false ||
			g_iClientTeam[iTarget] != TEAM_INFECTED ||
			IsPlayerAlive(iTarget) ==  false)
			continue;

		// Get the target location
		GetClientEyePosition(iTarget, xyzTargetLocation);
		// Check that the client can see the target or not
		if(IsVisibleTo(xyzClientLocation, xyzTargetLocation) == false)
			continue;

		FormatEx(text, sizeof(text), "\
			%s: %N",
			INFECTED_NAME[g_iInfectedCharacter[iTarget]],
			iTarget);
		FormatEx(strTargetID, sizeof(strTargetID), "%i", iTarget)
		AddMenuItem(menu, strTargetID, text);
	}

	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

// Hack Target Player Menu Handler
void HackTargetPlayerMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{	
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if (RunClientChecks(iClient) == false || 
			IsPlayerAlive(iClient) == false || 
			g_iClientTeam[iClient] != TEAM_SURVIVORS || 
			IsFakeClient(iClient))
			return;

		// "Rescan" redraw the menu again
		if (itemNum == 0)
		{
			HackTargetPlayerMenuDraw(iClient);
			return;
		}

		char strInfo[128];
		GetMenuItem(menu, itemNum, strInfo, sizeof(strInfo));
		int iTarget = StringToInt(strInfo);

		// Check if the selected target is viable
		if (RunClientChecks(iTarget) == false ||
			g_iClientTeam[iTarget] != TEAM_INFECTED ||
			IsPlayerAlive(iTarget) == false)
		{
			PrintToChat(iClient, "\x03[XPMod] \x04Invalid Target Selected.");
			HackTargetPlayerMenuDraw(iClient);
			return;
		}

		// Check if the selected target is already hacked
		if (g_bIsPLayerHacked[iTarget] == true)
		{
			PrintToChat(iClient, "\x03[XPMod] \x04Target has already been hacked.");
			HackTargetPlayerMenuDraw(iClient);
			return;
		}

		if (HackTargetPlayersControls(iTarget, LOUIS_HACK_TARGET_DURATION))
		{
			// If successful, then remove the XMR from Louis's wallet for the hax
			g_fLouisXMRWallet[iClient] -= LOUIS_HEADSHOP_XMR_AMOUNT_HAK_TARGET;
		}

		PrintToChatAll("\x03[XPMod] \x04%N\x05 has hacked %\x04N.", iClient, iTarget);
	}		
}

bool HackTargetPlayersControls(int iClient, float fDuration, bool bSpamChat = true, bool bSpamSounds =  true)
{
	if (RunClientChecks(iClient) == false || IsPlayerAlive(iClient) == false)
		return false;

	g_bIsPLayerHacked[iClient] = true;

	// Do the extras if booleans are true for them
	if (bSpamChat) CreateTimer(0.1, TimerSpamChatForHackedTargetPlayer, iClient, TIMER_REPEAT);
	if (bSpamSounds) CreateTimer(1.0, TimerSpamRandomSoundsToHackedTargetPlayer, iClient, TIMER_REPEAT);

	CreateTimer(fDuration, TimerUnhackTargetPlayersControls, iClient, TIMER_FLAG_NO_MAPCHANGE);

	return true;
}

Action TimerUnhackTargetPlayersControls(Handle timer, int iClient)
{
	g_bIsPLayerHacked[iClient] = false;
	return Plugin_Stop;
}

Action TimerSpamChatForHackedTargetPlayer(Handle timer, int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) == true ||
		IsPlayerAlive(iClient) == false ||
		g_bIsPLayerHacked[iClient] == false)
		return Plugin_Stop;

	static iSpamMessageIndex;
	if (++iSpamMessageIndex > 10) iSpamMessageIndex = 0;

	switch(iSpamMessageIndex)
	{
		case 0: PrintToChat(iClient, "\x03O9@N?CHR15PLO#SH6')4s/g5-mz#a#fLyZ#KJ=cbjNR#>~o>h1");
		case 1: PrintToChat(iClient, "\x03p,:]p5UM#+Z.jPB1WK3^WkNrDLV]1zRV<o'8Q)Lv1QbIOfl(H4X;Mzj");
		case 2: PrintToChat(iClient, "\x03/b#Z<Kvg^}ovA6e~?n2]K2h'gz9@&|uIWJ~FAJR++8NmKX9o2");
		case 3: PrintToChat(iClient, "\x03kLUd#2c&iP!!?1337(YiEV`-A505$i-}YT#3^f}qy&4/ypwe.9Mz}^J");
		case 4: PrintToChat(iClient, "\x03ScH~bIt<vvH2~.[_~F`$CCDZY-;(6fkz?qeLJLd#v+WoT~QCh=}O");
		case 5: PrintToChat(iClient, "\x03+;SM@l.Bo@GQjD~#nQW9Jp|-P$c_`?|&vYf$n&kC&1hi/_:5z+!#");
		case 6: PrintToChat(iClient, "\x03-7PObfgEe!q&](1M)_\\PT|P63o|G$.P3N15$fYJ:Pd?fK~Qf1;a~k_|");
		case 7: PrintToChat(iClient, "\x03D@b`O!gXJ-g[OKC2.0U,WBtBnG5oG@1Y_&z2^g_XPelhC3!o3koYF");
		case 8: PrintToChat(iClient, "\x03+u+5D7bkx(.2wlhojKQNb4]Hli4d+|c+HQBaVHo,/^h#;Z<sc3W@");
		case 9: PrintToChat(iClient, "\x03z3+Y|[WKkuY!Qe(,H}pLn\\N-R#1`Y>}f7[PeXz:>3_?Qg|HDa\\4d`");
		case 10: PrintToChat(iClient, "\x03EM[dc#pjuZ^.s=vQ\\1*gp+~/u(1o=#R4Cf4^}9tC}*v,6<h,jBO+");
	}
	
	return Plugin_Continue;
}

Action TimerSpamRandomSoundsToHackedTargetPlayer(Handle timer, int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) == true ||
		IsPlayerAlive(iClient) == false ||
		g_bIsPLayerHacked[iClient] == false)
		return Plugin_Stop;

	switch(GetRandomInt(0, 21))
	{
		case 0: EmitSoundToClient(iClient, SOUND_WING_FLAP[0]);
		case 1: EmitSoundToClient(iClient, SOUND_IGNITE);
		case 2: EmitSoundToClient(iClient, SOUND_JPSTART);
		case 3: EmitSoundToClient(iClient, SOUND_JEBUS);
		case 4: EmitSoundToClient(iClient, SOUND_CHARGECOACH);
		case 5: EmitSoundToClient(iClient, SOUND_SUITCHARGED);
		case 6: EmitSoundToClient(iClient, SOUND_ZAP1);
		case 7: EmitSoundToClient(iClient, SOUND_BOOMER_THROW[6]);
		case 8: EmitSoundToClient(iClient, SOUND_JOCKEYLAUGH1);
		case 9: EmitSoundToClient(iClient, SOUND_JOCKEYLAUGH2);
		case 10: EmitSoundToClient(iClient, SOUND_BOOMER_EXPLODE);
		case 11: EmitSoundToClient(iClient, SOUND_HOOKGRAB);
		case 12: EmitSoundToClient(iClient, SOUND_BEEP);
		case 13: EmitSoundToClient(iClient, SOUND_LOUIS_TELEPORT_OVERLOAD);
		case 14: EmitSoundToClient(iClient, SOUND_AMBTEST3);
		case 15: EmitSoundToClient(iClient, SOUND_FREEZE);
		case 16: EmitSoundToClient(iClient, SOUND_LOUIS_TELEPORT_USE_REGEN);
		case 17: EmitSoundToClient(iClient, SOUND_LEVELUPORIG);
		case 18: EmitSoundToClient(iClient, SOUND_JOCKEYLAUGH1);
		case 19: EmitSoundToClient(iClient, SOUND_JOCKEYLAUGH2);
		case 20: EmitSoundToClient(iClient, SOUND_JOCKEYLAUGH1);
		case 21: EmitSoundToClient(iClient, SOUND_JOCKEYLAUGH2);
	}
	
	return Plugin_Continue;
}


bool HackTheServer(int iClient)
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

	g_bHackTheServerEnabled = true;
	// Do the actual slow down time on the server
	TimeScale(LOUIS_HAK_TEH_SERVER_TIME_SCALE_FACTOR);	
	SetClientSpeedForAllSurvivors();
	
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

Action TimerPrintHakTehServerConsolePatchingMessage(Handle timer, int blah)
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

Action TimerResetTimeScale(Handle timer, int iClient)
{
	TimeScale();

	g_bHackTheServerEnabled = false;
	PrintToChatAll("Console: okay server patched!", iClient);

	SetClientSpeedForAllSurvivors(); 
	return Plugin_Stop;
}

void TimeScale(float fScaleAmount = 1.0)
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

void KillAllCI(int iClient)
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

bool TimeOut(int iClient)
{
	// Check if the player has enough XMR
	if (g_fLouisXMRWallet[iClient] < LOUIS_HEADSHOP_XMR_AMOUNT_TIME_OUT)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You don't have enough XMR...do some more brain surgery.");
		return false;
	}

	if (g_bTimeOutInCooldown)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05The server has been patched from previous h4k...looking for more exploitz...");
		return false;
	}

	g_bTimeOutInCooldown = true;
	CreateTimer(LOUIS_TIME_OUT_COOLDOWN_DURATION, TimerLouisResetGlobalHeadShopCooldown, LOUIS_HEADSHOP_ITEM_TIME_OUT, TIMER_FLAG_NO_MAPCHANGE);

	g_bInfectedBindsDisabled = true;
	PrintToChatAll("\x03[XPMod] \x04%N\x05 hacked the Infected putting them in Time Out. Binds disabled for %0.0f seconds!", iClient, LOUIS_TIME_OUT_DURATION);
	CreateTimer(LOUIS_TIME_OUT_DURATION, TimerReenableInfectedBinds, _, TIMER_FLAG_NO_MAPCHANGE);

	// Remove the XMR from Louis's wallet for the hax
	g_fLouisXMRWallet[iClient] -= LOUIS_HEADSHOP_XMR_AMOUNT_TIME_OUT;

	return true;
}

Action TimerReenableInfectedBinds(Handle timer, int iClient)
{
	g_bInfectedBindsDisabled = false;
	PrintToChatAll("\x03[XPMod] \x05Infected Binds have been fixed. Time Out is over.", iClient);
	return Plugin_Stop;
}

Action TimerLouisResetGlobalHeadShopCooldown(Handle timer, int item)
{
	switch(item)
	{
		case LOUIS_HEADSHOP_ITEM_SPEED_HAX: 		{ g_bSpeedHaxInCooldown = false; }
		case LOUIS_HEADSHOP_ITEM_HAXOR_TEH_SERVER: 	{ g_bHackTheServerInCooldown = false; }
		case LOUIS_HEADSHOP_ITEM_TIME_OUT: 			{ g_bTimeOutInCooldown = false; }
	}
	
	return Plugin_Stop;
}
