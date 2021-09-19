
//Testing Functions//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Action:TestFunction1(iClient, args)
{
	
	DebugLog(DEBUG_MODE_TESTING, "T1");
	//PrintToChat(iClient, "T1");

	char strArg[20][99];
	for (int i=0; i<20; i++)
		GetCmdArg(i+1, strArg[i], sizeof(strArg[]));

	float xyzPosition[3];
	xyzPosition[0] = StringToFloat(strArg[1]);
	xyzPosition[1] = StringToFloat(strArg[2]);
	xyzPosition[2] = StringToFloat(strArg[3]);

	PrintToChatAll("iClient = %i xyz: %f %f %f", StringToInt(strArg[0]), xyzPosition[0], xyzPosition[1], xyzPosition[2]);

	//t1 -1 1322.153564 3479.936279 624.377 255 255 255 255 1 100 100 200 400 20 200 10 10
	//t1 3 0 0 0 255 255 255 255 1 100 100 200 400 20 200 10 10
	// CreateSmokeParticle(StringToInt(strArg[0]),
	// 					xyzPosition,
	// 					false,
	// 					StringToInt(strArg[4]),
	// 					StringToInt(strArg[5]),
	// 					StringToInt(strArg[6]),
	// 					StringToInt(strArg[7]),
	// 					StringToInt(strArg[8]),
	// 					StringToInt(strArg[9]),
	// 					StringToInt(strArg[10]),
	// 					StringToInt(strArg[11]),
	// 					StringToInt(strArg[12]),
	// 					StringToInt(strArg[13]),
	// 					StringToInt(strArg[14]),
	// 					StringToInt(strArg[15]),
	// 					StringToFloat(strArg[16]));

	//SetPlayerAnimEvent(iClient, str1, str2, str3);

	// SmokerDismount(iClient);

	// if (g_bIsPlayerInSmokerSmokeCloud[iClient] == false)
	// 	SetPlayerInSmokerCloud(iClient, 23);
	// else
	// 	SetPlayerNotInSmokerCloud(iClient, 23);

	TarFingersBlindPlayerIncrementally(iClient);

	//CatchAndReleasePlayer(StringToInt(str1));
	//EntangleSurvivorInSmokerTongue(StringToInt(str1));

	
	//PrintToServer("%i", GetEntProp(iClient, Prop_Send, "m_nSequence"));
	//PlayAnimTest(iClient);
	//PrintToServer("%i", GetEntProp(iClient, Prop_Send, "m_nSequence"));

	//sendPlayerAnimToAll(StringToInt(arg1), )

	// SetVariantString("Idle_Tongued_choking_ground");
	// AcceptEntityInput(StringToInt(str1), "SetAnimation");

	// TogglePlayerNoClip(iClient);

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

	g_testingSpeedOverride[iClient] = StringToFloat(str1);
	SetClientSpeed(iClient);

	// char strEquipmentItem[32];
	// int iSlotItemID = GetPlayerWeaponSlot(iClient, StringToInt(str1));
	// PrintToChatAll("%i", iSlotItemID);
	// GetEntityClassname(iSlotItemID, strEquipmentItem, sizeof(strEquipmentItem));
	// PrintToChatAll("%s", strEquipmentItem);

	PrintToServer("strAnimationGrab1: %i", GetEntProp(iClient, Prop_Data, "m_nSequence"));

	//UntangleSurvivorFromSmokerTongue(StringToInt(str1));

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


public effect_beaments(entity, eentity)//, frate, Float:life, Float:width, Float:ewidth, flength, Float:amp, r, g, b, a, speed)
{
	//est_effect_03
	//new mindex = IsPrecached(model);
	new haloindex = PrecacheModel("materials/sprites/halo01.vmt");
	
	
	TE_Start("BeamEnts");
	TE_WriteNum("m_nStartEntity", entity);
	TE_WriteNum("m_nEndEntity", eentity);
	TE_WriteNum("m_nModelIndex", g_iSprite_SmokerTongue);//mindex);
	TE_WriteNum("m_nHaloIndex", haloindex);
	TE_WriteNum("m_nStartFrame", 0);
	TE_WriteNum("m_nFrameRate", 60);//frate);
	TE_WriteFloat("m_fLife", 30.0);//life);
	TE_WriteFloat("m_fWidth", 2.0);//width);
	TE_WriteFloat("m_fEndWidth", 5.0);//ewidth);
	TE_WriteNum("m_nFadeLength", 100);//flength);
	TE_WriteFloat("m_fAmplitude", 0.1);//amp);
	TE_WriteNum("m_nSpeed", 1);// speed);
	TE_WriteNum("r", 255);//r);
	TE_WriteNum("g", 255);//g);
	TE_WriteNum("b", 255);//b);
	TE_WriteNum("a", 255);//a);

	//TE_WriteNum("m_nFlags", flags);
	//SendEffect(filter);
	TE_SendToAll();
	
	return;
}


// public CreateLaser(player1,player2){

// 	new laser = CreateEntityByName("env_laser");
// 	new String:sz_lasername[32];
// 	Format(sz_lasername, sizeof(sz_lasername), "laser_%i", laser);
// 	DispatchKeyValue(laser, "targetname", sz_lasername);
// 	new String:steamid[20];
// 	new String:steamid1[20];
// 	GetClientAuthString(player1, steamid, sizeof(steamid));
// 	GetClientAuthString(player2, steamid1, sizeof(steamid1));
// 	DispatchKeyValue(laser, "targetname", steamid);
// 	DispatchKeyValue(laser, "parentname", steamid);

// 	// new String:clientName[128];
// 	// Format(clientName, sizeof(clientName), "Smoke%i", iClient);
// 	DispatchKeyValue(laser, "targetname", steamid);
// 	DispatchKeyValue(laser, "parentname", steamid);
// 	DispatchKeyValue(laser, "m_iszLaserTarget", steamid1);
// 	DispatchKeyValue(laser, "texture", "materials/sprites/halo01.vmt");//"sprites/physbeam.vmt");
	
// 	DispatchKeyValue(laser, "m_Color", "200 200 255");
// 	DispatchKeyValue(laser, "m_fWidth", "15");
	
	
// 	DispatchSpawn(laser);
	
// 	AcceptEntityInput(laser, "TurnOn");  
	
// 	new Float:loc[3];
// 	GetClientAbsOrigin(player1,loc);

// 	loc[2] += 70.0;
// 	ActivateEntity(laser);
	
// 	TeleportEntity(laser,loc,NULL_VECTOR,NULL_VECTOR);
// 	SetVariantString(steamid);
// 	AcceptEntityInput(laser, "SetParent");
// } 


Action:TestFunction3(iClient, args)
{
	DebugLog(DEBUG_MODE_TESTING, "T3");
	char str1[99];
	GetCmdArg(1, str1, sizeof(str1));
	char str2[99];
	GetCmdArg(2, str2, sizeof(str2));


	for (int i=1; i<=MaxClients; i++)
		if(RunClientChecks(i) && IsPlayerAlive(i))
			PrintToChatAll("%i: %N", i, i)

	//CreateLaser(StringToInt(str1), StringToInt(str2));
	effect_beaments(StringToInt(str1), StringToInt(str2));

	//GotoFirstPerson(iClient);

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

	// GiveEveryWeaponToSurvivor(iClient);

	int iTarget = StringToInt(str1);

	if (g_bIsPlayerInSmokerSmokeCloud[iTarget] == false)
		TurnSmokerIntoSmokeCloud(iTarget);
	else
		TurnBackToSmokerAfterSmokeCloud(iTarget);

	// decl Float:xyzLocation[3];
	// GetClientAbsOrigin(iClient, xyzLocation);
	// SendAllSurvivorBotsToLocation(xyzLocation);

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