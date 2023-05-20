
//Testing Functions//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// float g_fFasterAttackSpeed = 1.0;

public Action Timer_Testing(Handle hTimer, int iClient)
{
	// float xyzLocation[3];
	// GetClientAbsOrigin(iClient, xyzLocation);
	// GetAllCommonInfectedInARadius(xyzLocation, 500.0);

	// // Hook the model so hits will register
	// SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);
	// //SDKHook(EntIndexToEntRef(iClient), SDKHook_OnTakeDamage, OnTakeDamage);
	// PrintToServer("HOOKING %i, %i", iClient, EntIndexToEntRef(iClient));

	//SDKHook(iClient, SDKHook_OnTakeDamageAlivePost, OnTakeDamageAlivePost);
	
	return Plugin_Continue;
}

int iSeenEntities[MAXENTITIES+1];

Action:TestFunction1(iClient, args)
{
	DebugLog(DEBUG_MODE_TESTING, "T1");
	//PrintToChat(iClient, "T1");

	char strArg[20][99];
	for (int i=0; i<20; i++)
		GetCmdArg(i+1, strArg[i], sizeof(strArg[]));
	
	for(int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (RunClientChecks(iPlayer) == false)
			continue;
		
		PrintToChat(iClient, "Player %i, %N", iPlayer, iPlayer);
	}

	// g_fFasterAttackSpeed = StringToFloat(strArg[0]);
	// PrintToChat(iClient, "g_fFasterAttackSpeed now %f", g_fFasterAttackSpeed);
	
	// SetPlayerHealth(iClient, -1, -1000, true);




	// new Float:xyzClientPosition[3], Float:xyzClientEyeAngles[3];
	// GetClientAbsOrigin(iClient, xyzClientPosition);
	// GetClientAbsAngles(iClient,xyzClientEyeAngles); // Get the angle the player is looking
	// PrintToChat(iClient, "position: %%f %f %f", xyzClientPosition[0], xyzClientPosition[1], xyzClientPosition[2]);
	// PrintToChat(iClient, "angles: %f %f %f", xyzClientEyeAngles[0], xyzClientEyeAngles[1], xyzClientEyeAngles[2]);

	// SetEntityRenderMode(StringToInt(strArg[0]), RenderMode:3);
	// SetEntityRenderColor(StringToInt(strArg[0]), 255, 255, 255, RoundToFloor( 255 * (1.0 - StringToFloat(strArg[1])) ) );

	// int testValue = StringToInt(strArg[0])
	// if (testValue > 0) {
	// 	StorePlayerInDisconnectedPlayerList(iClient, testValue);
	// }
	// else {
	// 	StorePlayerInDisconnectedPlayerList(iClient);
	// }

	// for(int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	// {
	// 	if (RunClientChecks(iPlayer) == false || g_iClientTeam[iPlayer] !=  TEAM_INFECTED)
	// 		continue;

	// 	SetEntityRenderMode(iPlayer, RenderMode:3);
	// 	SetEntityRenderColor(iPlayer, 255, 255, 255, RoundToFloor(255 * (1.0 - 0.9)));

	// 	// SetEntProp(iPlayer, Prop_Send, "m_fEffects", StringToInt(strArg[0]));
	// 	// PrintToChatAll("%i) m_fEffects: %i", iPlayer, GetEntProp(iPlayer, Prop_Send, "m_fEffects")); // maybe this is for flashlight only

	// 	//SetEntProp(iPlayer, Prop_Send, "m_iTextureFrameIndex", 0);
	// 	PrintToChatAll("%i) m_iTextureFrameIndex: %i", iPlayer, GetEntProp(iPlayer, Prop_Send, "m_iTextureFrameIndex"));
	// 	//PrintToChatAll("%i) m_OnUser1: %i", iPlayer, GetEntPropEnt(iPlayer, Prop_Send, "m_OnUser1"));

	// 	AcceptEntityInput(iPlayer, "DisableDamageForces");
		
	// }

	// for(int iEntity = 1; iEntity <= MAXENTITIES; iEntity++)
	// {
	// 	if (RunEntityChecks(iEntity) == false)
	// 		continue;
		
	// 	if (iSeenEntities[iEntity] != 0)
	// 		continue;
	// 	iSeenEntities[iEntity] = 1;

	// 	char className[32];
	// 	GetEntityClassname(iEntity, className, 32)

	// 	PrintToServer("%i	%s", iEntity, className);

	// 	if (StrContains(className, "particle", false) > -1)
	// 	{
	// 		PrintToChatAll("Killing Entity: %i", iEntity);
	// 		AcceptEntityInput(iEntity, "stop");
	// 		KillEntitySafely(iEntity);
	// 	}

	// 	if (StrContains(className, "ability_lunge", false) > -1)
	// 	{
	// 		TeleportEntity(iEntity, EMPTY_VECTOR, EMPTY_VECTOR, NULL_VECTOR);
	// 		PrintToChatAll("ability_lunge Entity: %i", iEntity);
	// 		// PrintToChatAll("m_fadeMinDist: %i", GetEntProp(iEntity, Prop_Data, "m_fadeMinDist"));
	// 		//m_vecOrigin
	// 		//m_vecAbsOrigin
	// 		//m_fadeMinDist
	// 		//m_fadeMaxDist
	// 		//m_flFadeScale
	// 		//KillEntitySafely(iEntity);
	// 		//SetEntProp(iEntity, Prop_Send, "m_fEffects", 32);
	// 		//PrintToChatAll("%i) ability_lunge m_fEffects: %i", iEntity, GetEntProp(iEntity, Prop_Send, "m_fEffects")); // maybe this is for flashlight only
	// 	}

	// 	// if (StrContains(className, "weapon_hunter_claw", false) > -1)
	// 	// {
	// 	// 	TeleportEntity(iEntity, EMPTY_VECTOR, EMPTY_VECTOR, NULL_VECTOR);
	// 	// 	PrintToChatAll("weapon_hunter_claw Entity: %i", iEntity);
	// 	// 	PrintToChatAll("m_nRenderFX: %i", GetEntProp(iEntity, Prop_Data, "m_nRenderFX"));
	// 	// 	PrintToChatAll("m_hEffectEntity: %i", GetEntPropEnt(iEntity, Prop_Data, "m_hEffectEntity"));
	// 	// 	KillEntitySafely(iEntity);
	// 	// }
	// }

	// PrintToChatAll("TESTING 1: %i", GetEntProp(iClient, Prop_Data, "m_hEffectEntity"));
	// PrintToChatAll("TESTING 2: %i", GetEntPropEnt(iClient, Prop_Data, "m_hEffectEntity"));	// Fire screen effect not blur particle
	//m_fEffects

	
	
	//PrintToChatAll("TESTING 1: %i", GetEntProp(iClient, Prop_Data, "m_hEffectEntity"));
	// PrintToChatAll("TESTING 2: %i", GetEntPropEnt(iClient, Prop_Data, "m_hEffectEntity"));

	// for(int iPlayer = 0; iPlayer <= MaxClients; iPlayer++)
	// {
	// 	if (RunClientChecks(iPlayer) == false || IsFakeClient(iPlayer) == true)
	// 		continue;

	// 	PrintToChatAll("%N: g_iChokingVictim %i, g_bIsElectrocuting %i,", iPlayer, g_iChokingVictim[iPlayer], g_bIsElectrocuting[iClient]);
	// }
	//CreateSmokerDoppelganger(iClient);

	// float xyzLocation[3], xyzDirection[3];
	// if (GetCrosshairPosition(iClient, xyzLocation, xyzDirection) == false)
	// 	return Plugin_Continue;

	// xyzLocation[2] += 20.0;

	// int iClone = CreatePlayerClone(iClient, xyzLocation, xyzDirection, 2);
	// CreateTimer(0.1, Timer_Testing, iClone);

	// int iCan = CreatGasCan(iClient, xyzLocation, xyzDirection, 2);
	// CreateTimer(0.1, Timer_Testing, iCan);


	// HandleEntitiesInSmokerCloudRadius(iClient, 100.0);

	// PrintToChatAll("g_iSmokerSmokeCloudPlayer: %i g_iSmokerInSmokeCloudLimbo %i", 
	// 	g_iSmokerSmokeCloudPlayer, 
	// 	g_iSmokerInSmokeCloudLimbo);

	// CreateTimer(0.1, Timer_Testing, iClient, TIMER_REPEAT);

	//TestingBeamEntsBars(iClient);

	// TestingTempEnts(iClient, strArg[0], strArg[1]);

	// float xyzPosition[3];
	// xyzPosition[0] = StringToFloat(strArg[1]);
	// xyzPosition[1] = StringToFloat(strArg[2]);
	// xyzPosition[2] = StringToFloat(strArg[3]);

	//PrintToChatAll("iClient = %i xyz: %f %f %f", StringToInt(strArg[0]), xyzPosition[0], xyzPosition[1], xyzPosition[2]);
	
	// Attach smoker particles
	//smoker_spore_trail
	//smoker_spore_trail_cheap (for the cloud)
	// int iParticle = AttachParticle(iCloneEntity, "smoker_spore_trail", -1.0, 10.0);
	// int iParticle2 = AttachParticle(iCloneEntity, "smoker_spore_trail_cheap", -1.0, 10.0);

	// for (int i = 1;i <= MaxClients;i++)
	// {
	// 	if (RunClientChecks(i) == false)// || 
	// 		// IsPlayerAlive(i) == false ||
	// 		// g_iClientTeam[i] != TEAM_INFECTED)
	// 		continue;
		
	// 	// PrintToChatAll("%N m_zombieClass = %i", i, GetEntProp(i, Prop_Send, "m_zombieClass"));
	// 	PrintToChatAll("%N g_bTankTakeOverBot[i] = %i, g_bIsFrustratedTank[i] = %i", i, g_bTankTakeOverBot[i], g_bIsFrustratedTank[i]);
	// }

	//PrintToChatAll("%N m_zombieClass = %i", i, GetEntProp(i, Prop_Send, "m_zombieClass"));

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

	//SmokerHitTarFingerVictim(iClient);
	// TarFingersBlindPlayerIncrementally(iClient);

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

	// 	if (IsIncap(i) == true)
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

	// PrintAllInEnhancedCIEntityList();

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

	for(int iEntity = 1; iEntity <= MAXENTITIES; iEntity++)
	{		
		iSeenEntities[iEntity] = 0;
	}

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

Action:XPModDebugModeToggle(iClient, args)
{
	ToggleDebugMode();
}

Action:Timer_ContinuallyKillAllCI(Handle:timer, any:data)
{
	// Debug Mode Kill all CI
	if (g_bStopCISpawning == false)
		return Plugin_Stop;
	
	KillAllCI(0);

	return Plugin_Continue;
}

public void TestingTempEnts(int iClient, char[] strArg1, char[] strArg2)
{
	AttachBeam(3);

	// TE_SetupBeamPoints(xyzLocation,xyzPositionEnd,g_iSprite_SmokerTongue,0,0,66,0.1,3.0,3.0,10,0.0,{70,40,15,255},1);
	// TE_SendToAll();
	// int smokerMouth = CreateParticle("boomer_vomit", 2.0, iCloneEntity, 99, false);

	//PrintToChatAll("SMOKERMOUTHPARTICLE: %i", smokerMouth);
	// effect_beaments(smokerMouth, StringToInt(strArg[0]));
	//effect_beaments(iClient, StringToInt(strArg[0]));
	// decl Float:vorigin[3], Float:vangles[3];
	// GetLocationVectorInfrontOfClient(StringToInt(strArg[0]), vorigin, vangles);
	// int iEntity = CreateEntityByName("prop_dynamic");
	// if (RunEntityChecks(iEntity))
	// {
	// 	SetVariantString("!activator");
	// 	AcceptEntityInput(iEntity, "SetParent", StringToInt(strArg[0]));

	// 	TeleportEntity(iEntity, EMPTY_VECTOR, EMPTY_VECTOR, NULL_VECTOR);

	// 	effect_beaments(iClient, iEntity);
	// }

	// char color[12];
	// Format( color, sizeof( color ), "%i %i %i", 0, 255, 50 );

	// g_iLight1 = MakeLightDynamic(StringToInt(strArg[0]));
	// SetVariantEntity(g_iLight1);
	// SetVariantString(color);
	// AcceptEntityInput(g_iLight1, "color");
	// AcceptEntityInput(g_iLight1, "TurnOn");

	// g_iLight2 = MakeLightDynamic(StringToInt(strArg[1]));
	// SetVariantEntity(g_iLight2);
	// SetVariantString(color);
	// AcceptEntityInput(g_iLight2, "color");
	// AcceptEntityInput(g_iLight2, "TurnOn");

	int g_iClient1 = StringToInt(strArg1);
	int g_iClient2 = StringToInt(strArg2);
	float xyzLocation1[3], xyzLocation2[3];
	GetClientEyePosition(g_iClient1, xyzLocation1);
	GetClientEyePosition(g_iClient2, xyzLocation2);

	
	// decl String:parentName[64];
	// Format(parentName, sizeof(parentName), "%i:%N", client, client);
	// DispatchKeyValue(client, "targetname", parentName);

	// g_iEntity1 = CreateEntityByName("prop_dynamic");
	// Format(end, sizeof(end), "end%i", g_iEntity1);
	// DispatchKeyValue(g_iEntity1, "targetname", end); 
	// DispatchKeyValue(g_iEntity1, "model", "models/advisor.mdl"); 
	// DispatchKeyValue(g_iEntity1, "solid", "0");
	// DispatchKeyValue(g_iEntity1, "rendermode", "10");
	// DispatchSpawn(g_iEntity1);
	// ActivateEntity(g_iEntity1);
	// TeleportEntity(g_iEntity1, xyzLocation1, NULL_VECTOR, NULL_VECTOR);
	// // SetVariantString(parentName);
	// // AcceptEntityInput(endent, "SetParent");
	// // SetVariantString("defusekit");
	// // AcceptEntityInput(endent, "SetParentAttachmentMaintainOffset");

	// g_iEntity2 = CreateEntityByName("prop_dynamic");
	// Format(end, sizeof(end), "end%i", g_iEntity2);
	// DispatchKeyValue(g_iEntity2, "targetname", end); 
	// DispatchKeyValue(g_iEntity2, "model", "models/advisor.mdl"); 
	// DispatchKeyValue(g_iEntity2, "solid", "0");
	// DispatchKeyValue(g_iEntity2, "rendermode", "10");
	// DispatchSpawn(g_iEntity2);
	// ActivateEntity(g_iEntity2);
	// TeleportEntity(g_iEntity2, xyzLocation2, NULL_VECTOR, NULL_VECTOR);
	// // SetVariantString(parentName);
	// // AcceptEntityInput(endent, "SetParent");
	// // SetVariantString("defusekit");
	// // AcceptEntityInput(endent, "SetParentAttachmentMaintainOffset");

	// Used to figure out specific attachment points locations, what works
	//CreateParticle("boomer_vomit", 2.0, 3, ATTACH_MUZZLE_FLASH, true);
	//CreateParticle("boomer_vomit", 2.0, 2, ATTACH_DEBRIS, true);


	// The below code works, now extracted to a helper function, CreateDummyEntity, in Particle_Effects.sp
	
	// float xyzClientLocation[3], xyzClientAngles[3];
	// GetEntPropVector(g_iClient2, Prop_Send, "m_vecOrigin", xyzClientLocation);
	// GetClientEyeAngles(g_iClient2, xyzClientAngles);

	// decl String:strEntity[30];
	// // decl String:strParentName[64];
	// // Format(strParentName, sizeof(strParentName), "%i:%N", g_iClient2, g_iClient2);
	
	// g_iEntity1 = CreateEntityByName("prop_dynamic");
	// Format(strEntity, sizeof(strEntity), "start%i", g_iEntity1);
	// DispatchKeyValue(g_iEntity1, "targetname", strEntity); 
	// DispatchKeyValue(g_iEntity1, "model", "models/NULL.mdl"); 
	// DispatchKeyValue(g_iEntity1, "solid", "0");
	// DispatchKeyValue(g_iEntity1, "rendermode", "10");

	// TeleportEntity(g_iEntity1, xyzClientLocation, xyzClientAngles, NULL_VECTOR);
	// SetVariantString("!activator");
	// AcceptEntityInput(g_iEntity1, "SetParent", g_iClient2, g_iEntity1, 0);
	// SetVariantString("muzzle_flash");
	// AcceptEntityInput(g_iEntity1, "SetParentAttachmentMaintainOffset", g_iEntity1, g_iEntity1, 0);

	// DispatchSpawn(g_iEntity1);
	// ActivateEntity(g_iEntity1);


	// decl Float:vorigin[3], Float:vangles[3];
	// GetLocationVectorInfrontOfClient(iClient, vorigin, vangles);
	// g_iEntity2 = CreateEntityByName("prop_dynamic");
	// Format(strEntity, sizeof(strEntity), "end%i", g_iEntity2);
	// DispatchKeyValue(g_iEntity2, "targetname", strEntity); 
	// DispatchKeyValue(g_iEntity2, "model", "models/NULL.mdl"); 
	// DispatchKeyValue(g_iEntity2, "solid", "0");
	// DispatchKeyValue(g_iEntity2, "rendermode", "10");
	// DispatchSpawn(g_iEntity2);
	// ActivateEntity(g_iEntity2);
	// TeleportEntity(g_iEntity2, vorigin, NULL_VECTOR, NULL_VECTOR);
	// // SetVariantString(parentName);
	// // AcceptEntityInput(g_iEntity2, "SetParent");
	// // SetVariantString("weapon_bone");
	// // AcceptEntityInput(g_iEntity2, "SetParentAttachmentMaintainOffset");



	float xyzLocation[3];
	int iDummyEntityAttachmentHand = CreateDummyEntity(xyzLocation, -1.0, g_iClient1, "muzzle_flash");

	decl Float:vorigin[3], Float:vangles[3];
	GetLocationVectorInfrontOfClient(iClient, vorigin, vangles);
	int iDummyEntityAttachmentWall = CreateDummyEntity(vorigin);

	CreateBeamEntity(iDummyEntityAttachmentHand, iDummyEntityAttachmentWall, g_iSprite_Glow);

	// float xyzLocationTest1[3];
	// GetEntPropVector(iDummyEntityAttachmentHand, Prop_Send, "m_vecOrigin", xyzLocationTest1);
	// PrintToChatAll("iDummyEntityAttachmentHand = %i xyz: %f %f %f", iDummyEntityAttachmentHand, xyzLocationTest1[0], xyzLocationTest1[1], xyzLocationTest1[2]);
	
	// float xyzLocationTest2[3];
	// GetEntPropVector(iDummyEntityAttachmentWall, Prop_Send, "m_vecOrigin", xyzLocationTest2);
	// PrintToChatAll("iDummyEntityAttachmentWall = %i xyz: %f %f %f", iDummyEntityAttachmentWall, xyzLocationTest2[0], xyzLocationTest2[1], xyzLocationTest2[2]);
	

	// CreateTimer(2.0, TimerAttaachRope, iClient, TIMER_FLAG_NO_MAPCHANGE);
}


public AttachBeam(client)
{
	decl String:beamindex[30],String:start[30],String:end[30],String:parentName[64];
	Format(parentName, sizeof(parentName), "%i:%N", client, client);
	DispatchKeyValue(client, "targetname", parentName);
	new Float:vec[3];
	GetClientAbsOrigin(client, vec);
	
	new startent = CreateEntityByName("prop_dynamic");
	Format(start, sizeof(start), "start%i", startent);
	DispatchKeyValue(startent, "targetname", start); 
	DispatchKeyValue(startent, "model", "models/advisor.mdl"); 
	DispatchKeyValue(startent, "solid", "0");
	DispatchKeyValue(startent, "rendermode", "10");
	DispatchSpawn(startent);
	ActivateEntity(startent);
	vec[1] += 100; //add 100 to the y axis, so it's away from the player itself
	TeleportEntity(startent, vec, NULL_VECTOR, NULL_VECTOR);
	SetVariantString(parentName);
	AcceptEntityInput(startent, "SetParent");
	// SetVariantString("defusekit");
	// AcceptEntityInput(startent, "SetParentAttachmentMaintainOffset");
	
	new endent = CreateEntityByName("prop_dynamic");
	Format(end, sizeof(end), "end%i", endent);
	DispatchKeyValue(endent, "targetname", end); 
	DispatchKeyValue(endent, "model", "models/advisor.mdl"); 
	DispatchKeyValue(endent, "solid", "0");
	DispatchKeyValue(endent, "rendermode", "10");
	DispatchSpawn(endent);
	ActivateEntity(endent);
	vec[1] -= 200; // do the same here, only reverse
	TeleportEntity(endent, vec, NULL_VECTOR, NULL_VECTOR);
	SetVariantString(parentName);
	AcceptEntityInput(endent, "SetParent");
	// SetVariantString("defusekit");
	// AcceptEntityInput(endent, "SetParentAttachmentMaintainOffset");
	
	new beament  = CreateEntityByName("env_beam");
	if (IsValidEdict(beament))
	{
		
		Format(beamindex, sizeof(beamindex), "Beam%i", beament);
		
		// Set keyvalues on the beam.
		DispatchKeyValue(beament, "damage", "0");
		DispatchKeyValue(beament, "framestart", "0");
		DispatchKeyValue(beament, "BoltWidth", "10");
		DispatchKeyValue(beament, "renderfx", "0");
		DispatchKeyValue(beament, "TouchType", "3");
		DispatchKeyValue(beament, "framerate", "0");
		DispatchKeyValue(beament, "decalname", "Bigshot");
		DispatchKeyValue(beament, "TextureScroll", "35");
		DispatchKeyValue(beament, "HDRColorScale", "1.0");
		DispatchKeyValue(beament, "texture", "materials/sprites/laserbeam.vmt");
		DispatchKeyValue(beament, "life", "0"); 
		DispatchKeyValue(beament, "targetname", beamindex);
		DispatchKeyValue(beament, "LightningStart", start);
		DispatchKeyValue(beament, "LightningEnd", end); 
		DispatchKeyValue(beament, "StrikeTime", "1"); 
		DispatchKeyValue(beament, "spawnflags", "8"); 
		DispatchKeyValue(beament, "NoiseAmplitude", "0"); 
		DispatchKeyValue(beament, "Radius", "256");
		DispatchKeyValue(beament, "rendercolor", "255 255 255");
		DispatchKeyValue(beament, "renderamt", "100");
		
		DispatchSpawn(beament);
		ActivateEntity(beament);
		TeleportEntity(beament, vec, NULL_VECTOR, NULL_VECTOR);
		CreateTimer(0.5, beam_enable, beament);
	}
}

public Action:beam_enable(Handle:timer, any:beam)
{
	AcceptEntityInput(beam, "TurnOn");
}
// Action:TimerAttaachRope(Handle:timer, any:iClient)
// {
// 	PrintToChatAll("clients: %i, %i", g_iClient1, g_iClient2)
// 	PrintToChatAll("ents: %i, %i", g_iEntity1, g_iEntity2)
// 	effect_beaments(iClient, g_iEntity1);
// 	// effect_beaments(g_iClient1, g_iEntity2);
// 	// effect_beaments(g_iClient2, g_iEntity1);
// 	//effect_beaments(g_iClient1, g_iClient2);

// 	return Plugin_Stop;
// }





// int CreateSpriteBarEyesForward(int entity, float height = 2.0, float width, float duration, int color[4], float offset[3])
// {
// 	float pos[3], angles[3];
// 	GetClientEyePosition(entity, pos);
// 	GetClientEyeAngles(entity, angles);
// 	pos[0]+=offset[0];
// 	pos[1]+=offset[1];
// 	pos[2]+=offset[2];
// 	int ent = CreateEntityByName("env_sprite");



// 	//Target Name:
// 	char tName[64];
// 	Format(tName, sizeof(tName), "Entity%d", entity);
// 	DispatchKeyValue(entity, "targetname", tName);
// 	GetEntPropString(entity, Prop_Data, "m_iName", tName, sizeof(tName));
// 	// DispatchKeyValue(ent, "parentname", tName);



// 	if (ent > 0)
// 	{
// 		// DispatchKeyValueVector(ent, "origin", pos);
// 		// DispatchKeyValueVector(ent, "rotation", angles);
// 		//TeleportEntity(ent, pos, angles, NULL_VECTOR);
// 		TeleportEntity(ent, pos, NULL_VECTOR, NULL_VECTOR);

// 		//DispatchKeyValue(ent, "scale", "0.2");
// 		DispatchKeyValue(ent, "model", "materials/sprites/white.vmt");
// 		DispatchSpawn(ent);

// 		DispatchKeyValue(ent, "parentname", tName);

// 		// SetVariantString("!activator");
// 		SetVariantString(tName);
// 		AcceptEntityInput(ent, "SetParent", ent, ent);
// 		// AcceptEntityInput(ent, "SetParent", entity, ent);

// 		SetVariantString("forward");
// 		AcceptEntityInput(ent, "SetParentAttachmentMaintainOffset", ent, ent, 0);

// 		AcceptEntityInput(ent, "HideSprite");
// 	}
// 	pos[2]+=height;
// 	int ent2 = CreateEntityByName("env_sprite");
// 	if (ent2 > 0)
// 	{
// 		// DispatchKeyValueVector(ent2, "origin", pos);
// 		// DispatchKeyValueVector(ent2, "rotation", angles);
// 		//TeleportEntity(ent2, pos, angles, NULL_VECTOR);
// 		TeleportEntity(ent2, pos, NULL_VECTOR, NULL_VECTOR);


// 		DispatchKeyValue(ent2, "model", "materials/sprites/white.vmt");
// 		DispatchSpawn(ent2);

// 		DispatchKeyValue(ent2, "parentname", tName);

// 		// SetVariantString("!activator");
// 		SetVariantString(tName);
// 		AcceptEntityInput(ent2, "SetParent", ent2, ent2);
// 		//AcceptEntityInput(ent2, "SetParent", entity, ent2);
		
// 		SetVariantString("forward");
// 		AcceptEntityInput(ent, "SetParentAttachmentMaintainOffset", ent, ent, 0);

// 		AcceptEntityInput(ent2, "HideSprite");
// 	}
// 	TE_SendBeamBar(ent, ent2, width, duration, color);
// 	return ent;
// }







public int CreateSpriteBar(int entity, float fHeight, float fWidth, float duration, int color[4], float offset[3], iSprite)
{
	float pos[3], angles[3];
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", pos);
	GetEntPropVector(entity, Prop_Send, "m_angRotation", angles);
	pos[0]+=offset[0];
	pos[1]+=offset[1];
	pos[2]+=offset[2];
	int ent = CreateEntityByName("env_sprite");



	// //Target Name:
	// char tName[64];
	// Format(tName, sizeof(tName), "Entity%d", entity);
	// DispatchKeyValue(entity, "targetname", tName);
	// GetEntPropString(entity, Prop_Data, "m_iName", tName, sizeof(tName));
	// // DispatchKeyValue(ent, "parentname", tName);



	if (ent > 0)
	{
		// DispatchKeyValueVector(ent, "origin", pos);
		// DispatchKeyValueVector(ent, "rotation", angles);
		//TeleportEntity(ent, pos, angles, NULL_VECTOR);
		TeleportEntity(ent, pos, NULL_VECTOR, NULL_VECTOR);

		//DispatchKeyValue(ent, "scale", "0.2");
		DispatchKeyValue(ent, "model", "materials/sprites/white.vmt");
		DispatchSpawn(ent);

		// DispatchKeyValue(ent, "parentname", tName);

		SetVariantString("!activator");
		// SetVariantString(tName);
		// AcceptEntityInput(ent, "SetParent", ent, ent);
		AcceptEntityInput(ent, "SetParent", entity, ent);

		// SetVariantString("spine");
		// AcceptEntityInput(ent, "SetParentAttachmentMaintainOffset", ent, ent, 0);

		AcceptEntityInput(ent, "HideSprite");
	}
	pos[2]+=fHeight;
	int ent2 = CreateEntityByName("env_sprite");
	if (ent2 > 0)
	{
		// DispatchKeyValueVector(ent2, "origin", pos);
		// DispatchKeyValueVector(ent2, "rotation", angles);
		//TeleportEntity(ent2, pos, angles, NULL_VECTOR);
		TeleportEntity(ent2, pos, NULL_VECTOR, NULL_VECTOR);


		DispatchKeyValue(ent2, "model", "materials/sprites/white.vmt");
		DispatchSpawn(ent2);

		// DispatchKeyValue(ent2, "parentname", tName);

		SetVariantString("!activator");
		// SetVariantString(tName);
		// AcceptEntityInput(ent2, "SetParent", ent2, ent2);
		AcceptEntityInput(ent2, "SetParent", entity, ent2);
		
		// SetVariantString("spine");
		// AcceptEntityInput(ent, "SetParentAttachmentMaintainOffset", ent, ent, 0);

		AcceptEntityInput(ent2, "HideSprite");
	}
	TE_SendBeamBar(ent2, ent, fWidth, duration, color, iSprite);
	return ent;
}

public TE_SendBeamBar(int startEnt, int endEnt, float size, float duration, int color[4], iSprite)
{
	TE_SetupBeamEnts(startEnt, endEnt, iSprite, g_iSprite_Glow, 0, 0, duration, size, size, 1, 1.0, color, 0);
	TE_SendToAll();
}

stock void TE_SetupBeamEnts(int StartEntity, int EndEntity, int ModelIndex, int HaloIndex, int StartFrame, int FrameRate, float Life, float Width, float EndWidth, int FadeLength, float Amplitude, const int Color[4], int Speed)
{
	TE_Start("BeamEnts");
	TE_WriteEncodedEnt("m_nStartEntity", StartEntity);
	TE_WriteEncodedEnt("m_nEndEntity", EndEntity);
	TE_WriteNum("m_nModelIndex", ModelIndex);
	TE_WriteNum("m_nHaloIndex", HaloIndex);
	TE_WriteNum("m_nStartFrame", StartFrame);
	TE_WriteNum("m_nFrameRate", FrameRate);
	TE_WriteFloat("m_fLife", Life);
	TE_WriteFloat("m_fWidth", Width);
	TE_WriteFloat("m_fEndWidth", EndWidth);
	TE_WriteFloat("m_fAmplitude", Amplitude);
	TE_WriteNum("r", Color[0]);
	TE_WriteNum("g", Color[1]);
	TE_WriteNum("b", Color[2]);
	TE_WriteNum("a", Color[3]);
	TE_WriteNum("m_nSpeed", Speed);
	TE_WriteNum("m_nFadeLength", FadeLength);
} 

public TestingBeamEntsBars(int iClient)
{
	// CreateSpriteBar(StringToInt(strArg[0]), 3.0, 10.0, 60.0, {0, 255, 0, 1500}, {0.0, 0.0, 80.0});
	// CreateSpriteBar(StringToInt(strArg[0]), 3.0, 30.0, 60.0, {255, 255, 255, 20}, {0.0, 0.0, 80.0});

	///////////////////////////////////////////////////////////////////////

	int iSprite = g_iSprite_Bar_Background;
	float xyzOffset[3], xyzClientLocation[3], xzyLocationInFrontOfClient[3], vAngles[3];
	GetClientAbsOrigin(iClient, xyzClientLocation);

	xyzOffset[2] = 37.0;

	GetLocationVectorInfrontOfClient(iClient, xzyLocationInFrontOfClient, vAngles, 10.2, 1.0);
	xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];
	CreateSpriteBar(iClient, 3.0, 10.0, 60.0, {255, 255, 255, 15}, xyzOffset, iSprite);
	GetLocationVectorInfrontOfClient(iClient, xzyLocationInFrontOfClient, vAngles, 10.1, 1.0);
	xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];
	CreateSpriteBar(iClient, 3.0, 8.0, 60.0, {0, 255, 0, 255}, xyzOffset, g_iSprite_Bar_Foreground);

	xyzOffset[2] = 33.0;

	GetLocationVectorInfrontOfClient(iClient, xzyLocationInFrontOfClient, vAngles, 10.2, 1.0);
	xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];
	CreateSpriteBar(iClient, 3.0, 10.0, 60.0, {255, 255, 255, 25}, xyzOffset, iSprite);
	GetLocationVectorInfrontOfClient(iClient, xzyLocationInFrontOfClient, vAngles, 10.1, 1.0);
	xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];
	CreateSpriteBar(iClient, 3.0, 6.0, 60.0, {0, 255, 0, 255}, xyzOffset, g_iSprite_Bar_Foreground);

	xyzOffset[2] = 5.0;

	GetLocationVectorInfrontOfClient(iClient, xzyLocationInFrontOfClient, vAngles, 20.2, 1.0, -0.5);
	xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];
	CreateSpriteBar(iClient, 3.0, 6.0, 60.0, {255, 255, 255, 15}, xyzOffset, iSprite);
	GetLocationVectorInfrontOfClient(iClient, xzyLocationInFrontOfClient, vAngles, 20.1, 1.0, -0.5);
	xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];
	CreateSpriteBar(iClient, 3.0, 1.0, 60.0, {25, 10, 255, 255}, xyzOffset, g_iSprite_Bar_Foreground);

	GetLocationVectorInfrontOfClient(iClient, xzyLocationInFrontOfClient, vAngles, 20.2, 1.0, 0.5);
	xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];
	CreateSpriteBar(iClient, 3.0, 6.0, 60.0, {255, 255, 255, 15}, xyzOffset, iSprite);
	GetLocationVectorInfrontOfClient(iClient, xzyLocationInFrontOfClient, vAngles, 20.1, 1.0, 0.5);
	xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];
	CreateSpriteBar(iClient, 3.0, 4.0, 60.0, {25, 10, 255, 255}, xyzOffset, g_iSprite_Bar_Foreground);

	/////////////////////////////////////////////////////////////////////////
	
	// float xyzOffset[3], xyzClientLocation[3], xzyLocationInFrontOfClient[3], vAngles[3];
	// GetClientAbsOrigin(iClient, xyzClientLocation);
	// xyzOffset[2] = 0.0;


	// GetLocationVectorInfrontOfClientEyes(iClient, xzyLocationInFrontOfClient, vAngles, 1.0, 1.0);
	// xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	// xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];

	// CreateSpriteBar(iClient, 3.0, 5.0, 60.0, {0, 255, 0, 150}, xyzOffset);
	// CreateSpriteBar(iClient, 3.0, 20.0, 60.0, {255, 255, 255, 20}, xyzOffset);


	// GetLocationVectorInfrontOfClientEyes(iClient, xzyLocationInFrontOfClient, vAngles, 1.0, 1.0, 0.9);

	// xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	// xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];

	// CreateSpriteBar(iClient, 3.0, 4.0, 60.0, {0, 255, 0, 150}, xyzOffset);
	// CreateSpriteBar(iClient, 3.0, 6.0, 60.0, {255, 255, 255, 20}, xyzOffset);

	// GetLocationVectorInfrontOfClientEyes(iClient, xzyLocationInFrontOfClient, vAngles, 1.0, 1.0, -0.9);

	// xyzOffset[0] = xzyLocationInFrontOfClient[0] - xyzClientLocation[0];
	// xyzOffset[1] = xzyLocationInFrontOfClient[1] - xyzClientLocation[1];

	// CreateSpriteBar(iClient, 3.0, 1.0, 60.0, {0, 255, 0, 150}, xyzOffset);
	// CreateSpriteBar(iClient, 3.0, 6.0, 60.0, {255, 255, 255, 20}, xyzOffset);
}