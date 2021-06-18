
//Testing Functions//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//new Float:g_fEllisTestFireRate = 0.0;
Action:TestFunction1(iClient, args)
{
	DebugLog(DEBUG_MODE_TESTING, "T1");
	//PrintToChat(iClient, "T1");
	
	char str1[99];
	char str2[99];
	GetCmdArg(1, str1, sizeof(str1));
	GetCmdArg(2, str2, sizeof(str2));

	// PrintToChat(iClient, "players down = %i", GetIncapOrDeadSurvivorCount());

	// new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	// PrintToChatAll("	ActiveWeaponID = %i", ActiveWeaponID);
	// PrintToChatAll("		+ g_iEllisCurrentPrimarySlot %i", g_iEllisCurrentPrimarySlot[iClient])
	// PrintToChatAll("		+ slot0 %s\n		+ slot1 %s", ITEM_NAME[g_iEllisPrimarySlot0[iClient]], ITEM_NAME[g_iEllisPrimarySlot1[iClient]]);

	// PrintToChatAll("		+ g_iStashedPrimarySlotWeaponIndex[iClient] %s", ITEM_CMD_NAME[g_iStashedPrimarySlotWeaponIndex[iClient]]);
	// PrintToChatAll("		+ g_iNickPrimarySavedClip = %d", g_iNickPrimarySavedClip[iClient]);
	// PrintToChatAll("		+ g_iNickPrimarySavedAmmo = %d", g_iNickPrimarySavedAmmo[iClient]);


	// char strEquipmentItem[32];
	// int iGrenadeSlotItemID = GetPlayerWeaponSlot(iClient, 2);
	// PrintToChatAll("%i", iGrenadeSlotItemID);
	// GetEntityClassname(iGrenadeSlotItemID, strEquipmentItem, sizeof(strEquipmentItem));
	// PrintToChatAll("%s", strEquipmentItem);

	// // Print all grappled users
	// for (int i=1; i <= MaxClients; i++)
	// {
	// 	if (RunClientChecks(i) == false)
	// 		continue;

	// 	if (IsClientGrappled(i) == true)
	// 		PrintToChatAll("Grappled: %N", i);

	// 	if (g_bIsClientDown[i])
	// 		PrintToChatAll("g_bIsClientDown: %N", i);

	// 	if (GetEntProp(i, Prop_Send, "m_isIncapacitated") == 1)
	// 		PrintToChatAll("Incap: %N", i);
	// }

	//if (args < 1) return Plugin_Stop;

	//AttachParticle(StringToInt(str1), "charger_motion_blur", 15.4, 0.0)

	// new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
	// new iAmmo = GetEntData(iClient, iOffset_Ammo + StringToInt(str1));
	// PrintToChatAll("iammo = %i", iAmmo);

	// PrintToChatAll("Gametime = %f; m_flProgressBarStartTime = %f; m_flProgressBarDuration = %f, revive = %i",
	// 	GetGameTime(),
	// 	GetEntPropFloat(iClient, Prop_Send, "m_flProgressBarStartTime"),
	// 	GetEntPropFloat(iClient, Prop_Send, "m_flProgressBarDuration"),
	// 	GetEntPropEnt(iClient, Prop_Send, "m_reviveOwner"));

	PrintAllInEnhancedCIEntityList();

	// SDKCall(g_hSDK_VomitOnPlayer, StringToInt(str1), iClient, true);
	
	//SetSIAbilityCooldown(iClient, StringToFloat(str1), StringToInt(str2) == 1 ? true : false);

	// z_ghost_delay_max 30
	// z_ghost_delay_min 20

	//g_fEllisTestFireRate = StringToFloat(str1);

	//VAMPIRIC_TANK_WING_FLAP_UP_VELOCITY = StringToFloat(str1);
	//VAMPIRIC_TANK_WING_DASH_VELOCITY = StringToFloat(str1);

	// Testing menu close detection, sad panda
	//PrintToChat(iClient, "GetClientMenu: %i", GetClientMenu(iClient));
	
	//SetClientInfo(iClient, "name", str1);
	//WriteParticle(iClient, str1, 0.0, 30.0);

	//AddTempHealthToSurvivor(iClient, StringToFloat(str));

	//OpenMOTDPanel(iClient, "t1" , str, MOTDPANEL_TYPE_FILE);
	//OpenMOTDPanel(iClient, "t1" , "http://xpmod.net/blah.html", MOTDPANEL_TYPE_URL);
	//OpenMOTDPanel(iClient, "t1." , "<html><head><title>a</title><meta http-equiv = \"Content-Type\" content = \"text / html; charset = utf-8\" ></head><body bgcolor = \"# 000000\" ><p>test</p></body></html>", MOTDPANEL_TYPE_URL);
	//OpenMOTDPanel(iClient, "t1." , "<html> <body> test <script> window.open('http://xpmod.net', '_blank'); </script> </body> </html>", MOTDPANEL_TYPE_URL);
	//Finding offset for SI cooldowns // Windows is 1084 Linux is +20 1104
	//g_iOffset_NextActivation = StringToInt(str);

	//DealDamage(StringToInt(str1), iClient, 1, StringToInt(str2));

	return Plugin_Stop;
}

Action:TestFunction2(iClient, args)
{
	DebugLog(DEBUG_MODE_TESTING, "T2");

	char str1[99];
	char str2[99];
	GetCmdArg(1, str1, sizeof(str1));
	GetCmdArg(2, str2, sizeof(str2));

	// DebugLog(DEBUG_MODE_TESTING, "DEBUG_MODE_TESTING %N, %i, %i, %i, %i, %f, %f, %s, %s", iClient, 1, 2, 3, 4, 5.5, 6.6, "testing", "another test string!");
	// DebugLog(DEBUG_MODE_TESTING, "DEBUG_MODE_TESTING");
	// DebugLog(DEBUG_MODE_ERRORS, "DEBUG_MODE_ERRORS %N", iClient);
	// DebugLog(DEBUG_MODE_TIMERS, "DEBUG_MODE_TIMERS %N", iClient);
	// DebugLog(DEBUG_MODE_VERBOSE, "DEBUG_MODE_VERBOSE %N", iClient);
	// DebugLog(DEBUG_MODE_EVERYTHING, "DEBUG_MODE_EVERYTHING %N", iClient);

	// g_iTesting =  StringToInt(str1);

	// decl Float:xyzClientLocation[3];
	// GetClientAbsOrigin(iClient, xyzClientLocation);
	// xyzClientLocation[2] += 30.0;
	// WriteParticle(iClient, "mini_fireworks", 0.0, 10.0, xyzClientLocation);

	// if (RunClientChecks(iClient) == false) PrintToChat(iClient, "T1");

	//PrintToChat(iClient, "m_healthBuffer %f", GetEntPropFloat(iClient, Prop_Send, "m_healthBuffer"));
	//PrintToChat(iClient, "settime %f, Gametime: %f, diff: %f", GetEntPropFloat(iClient, Prop_Send, "m_healthBufferTime"), GetGameTime(), GetGameTime() - GetEntPropFloat(iClient, Prop_Send, "m_healthBufferTime"));
	//PrintToChat(iClient, "temp_health %i", GetSurvivorTempHealth(iClient));

	//OpenMOTDPanel(iClient, "t2" , "http://xpmod.net/blah.html", MOTDPANEL_TYPE_URL);
	//OpenMOTDPanel(iClient, "t1." , "<html><head><title>a</title><meta http-equiv = \"Content-Type\" content = \"text / html; charset = utf-8\" ></head><body bgcolor = \"# 000000\" ><p>test</p></body></html>", MOTDPANEL_TYPE_INDEX);

	return Plugin_Stop;
}


Action:TestFunction3(iClient, args)
{
	DebugLog(DEBUG_MODE_TESTING, "T3");
	char str1[99];
	GetCmdArg(1, str1, sizeof(str1));
	char str2[99];
	GetCmdArg(2, str2, sizeof(str2));

	//Testing glow
	//SetClientGlow(StringToInt(str1), 0, 0, 0, StringToInt(str2));

	//SpawnSpecialInfected(iClient);

	//OpenMOTDPanel(iClient, "t3" , " .", MOTDPANEL_TYPE_URL);
	//OpenMOTDPanel(iClient, "t3." , "<html><head><title>a</title><meta http-equiv = \"Content-Type\" content = \"text / html; charset = utf-8\" ></head><body bgcolor = \"# 000000\" ><p>test</p></body></html>", MOTDPANEL_TYPE_TEXT);
	return Plugin_Stop;
}



Action:TestFunction4(iClient, args)
{
	DebugLog(DEBUG_MODE_TESTING, "T4");
	char str1[99];
	GetCmdArg(1, str1, sizeof(str1));

	// decl String:strTimeScaleCmd[32];
	// Format(strTimeScaleCmd, sizeof(strTimeScaleCmd), "host_timescale %3f", StringToFloat(str1));
	// PrintToChat(iClient, "%s", strTimeScaleCmd);

	// RunCheatCommand(iClient, "host_timescale", strTimeScaleCmd);

	
	//g_hTimeScale.FloatValue = StringToFloat(str1);

	//TimeScale(iClient, args)

	
	//OpenMOTDPanel(iClient, "t4" , " .", MOTDPANEL_TYPE_INDEX);
	//OpenMOTDPanel(iClient, "t4." , "<html><head><title>a</title><meta http-equiv = \"Content-Type\" content = \"text / html; charset = utf-8\" ></head><body bgcolor = \"# 000000\" ><p>test</p></body></html>", MOTDPANEL_TYPE_INDEX);
	return Plugin_Stop;
}

Action:TestFunction5(iClient, args)
{
	DebugLog(DEBUG_MODE_TESTING, "T5");

	RunCheatCommand(iClient, "z_spawn_old", "z_spawn_old tank auto");


	//OpenMOTDPanel(iClient, "t5" , " .", MOTDPANEL_TYPE_FILE);
	//OpenMOTDPanel(iClient, "t5." , "/cfg/server.cfg", MOTDPANEL_TYPE_FILE);

	return Plugin_Stop;
}

Action:GiveMoreBinds(admin, args)
{
	g_iClientBindUses_1[admin] = -99;
	g_iClientBindUses_2[admin] = -99;
}