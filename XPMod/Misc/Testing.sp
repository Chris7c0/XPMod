
//Testing Functions//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

MonitorAndPrintHealthMeterToSurvivorPlayer(iAttacker, iVictim)
{
	// To get an immediate display print the current health
	PrintHealthMeterToSurvivorPlayer(iAttacker, iVictim);

	new Handle:hDataPackage = CreateDataPack();
	WritePackCell(hDataPackage, iAttacker);
	WritePackCell(hDataPackage, iVictim);
	
	CreateTimer(0.5, Timer_MonitorAndPrintHealthMeterToSurvivorPlayer, hDataPackage, TIMER_FLAG_NO_MAPCHANGE);
}

Action Timer_MonitorAndPrintHealthMeterToSurvivorPlayer(Handle:timer, Handle:hDataPackage)
{
	ResetPack(hDataPackage);
	new iAttacker = ReadPackCell(hDataPackage);
	new iVictim = ReadPackCell(hDataPackage);
	CloseHandle(hDataPackage);

	if (RunClientChecks(iAttacker) == false || 
		RunClientChecks(iVictim) == false)
		return Plugin_Stop;
	
	PrintHealthMeterToSurvivorPlayer(iAttacker, iVictim);

	return Plugin_Stop;
}

PrintHealthMeterToSurvivorPlayer(int iAttacker, int iVictim)
{
	if (RunClientChecks(iAttacker) == false ||
		RunClientChecks(iVictim) == false ||
		IsFakeClient(iAttacker) == true ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		g_iClientTeam[iVictim] != TEAM_INFECTED)
		return;

	if (IsPlayerAlive(iVictim) == false)
	{
		PrintCenterText(iAttacker, "DEAD");
		return;
	}

	new iCurrentMaxHealth = GetEntProp(iVictim,Prop_Data,"m_iMaxHealth");
	new iCurrentHealth = GetEntProp(iVictim,Prop_Data,"m_iHealth");
	if (iCurrentHealth < 0) iCurrentHealth = 0;
	new Float:fHealthPercentage = (iCurrentMaxHealth > 0) ? (float(iCurrentHealth) / float(iCurrentMaxHealth)) : 0.0;

	decl String:strHealthBar[256];
	strHealthBar = NULL_STRING;

	// Create the actual mana amount in the "progress meter"
	for(int i = 0; i < RoundToCeil(fHealthPercentage * 30.0); i++)
		StrCat(strHealthBar, sizeof(strHealthBar), "▓");
	// Create the rest of the string
	for(int i = 30; i > RoundToCeil(fHealthPercentage * 30.0); i--)
		StrCat(strHealthBar, sizeof(strHealthBar), "░");

	PrintCenterText(iAttacker, 
		"%N\n\
		%s\n\
		%s ( %i / %i )",
		iVictim,
		strHealthBar,
		INFECTED_NAME[g_iInfectedCharacter[iVictim]],
		iCurrentHealth,
		iCurrentMaxHealth);
}

void CreateWarezStation(iClient)
{
	decl Float:xyzOrigin[3];
	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", xyzOrigin);
	CreateSphere(xyzOrigin, 50.0, 30, 0.1, {0, 255, 50, 255}, 25.0);

	// Fix this later to be on next game frame
	CreateTimer(0.1, TimerTestingTE_SENDTOALL, iClient);
	
	//CreateSphere(xyzOrigin, 5.0, 30, 0.1, {0, 255, 50, 150}, 25.0);
	//TE_SendToAll();
	DrawRing(iClient);

	// Create light
	char color[12];
	Format( color, sizeof( color ), "%i %i %i", 0, 255, 50 );
	int iLight = MakeLightDynamic(iClient);
	SetVariantEntity(iLight);
	SetVariantString(color);
	AcceptEntityInput(iLight, "color");
	AcceptEntityInput(iLight, "TurnOn");
	CreateTimer(25.0, TimerRemoveLightDynamicEntity, iLight, TIMER_FLAG_NO_MAPCHANGE);
}

Action:TimerRemoveLightDynamicEntity(Handle:timer, any:iEntity)
{
	if (iEntity < 1 || IsValidEntity(iEntity) == false)
		return Plugin_Stop;

	decl String:strEntityClass[32];
	GetEntityNetClass(iEntity, strEntityClass, 32);
	// PrintToChatAll("strEntityClass: %s", strEntityClass);
	if (StrEqual(strEntityClass, "CDynamicLight", true) == false)
		return Plugin_Stop;

	AcceptEntityInput(iEntity, "TurnOff");
	AcceptEntityInput(iEntity, "kill");
	RemoveEdict(iEntity);

	return Plugin_Stop;
}

Action:TimerTestingTE_SENDTOALL(Handle:timer, any:iClient)
{
	decl Float:xyzOrigin2[3];
	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", xyzOrigin2);
	CreateSphere(xyzOrigin2, 35.0, 30, 0.1, {0, 255, 50, 150}, 25.0);
	return Plugin_Stop;
}

void DrawRing(iClient)
{
	new Float:vec[3];
	GetClientAbsOrigin(iClient, vec);

	vec[2] += 10;
	TE_SetupBeamRingPoint(vec, 60.0, 59.0, g_iSprite_Laser, g_iSprite_Halo, 0, 15, 60.0, 5.0, 0.0, {0, 255, 30, 255}, 10, 0);
	TE_SendToAll();
}


int MakeLightDynamic(int target) //, const float vPos[3])
{
	int entity = CreateEntityByName("light_dynamic");
	if( entity == -1 || IsValidEntity(entity) == false)
	{
		LogError("Failed to create 'light_dynamic'");
		return 0;
	}

	DispatchKeyValue(entity, "_light", "0 255 0 0");
	DispatchKeyValue(entity, "brightness", "0.1");
	DispatchKeyValueFloat(entity, "spotlight_radius", 100.0);
	DispatchKeyValueFloat(entity, "distance", 400.0);
	DispatchKeyValue(entity, "style", "6");
	DispatchSpawn(entity);
	AcceptEntityInput(entity, "TurnOff");
	
	new Float:vPos[3];
	GetClientEyePosition(target, vPos);

	TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);

	// // Attaching has many issues, lighting glitches, laggy, fps, just dont do it.
	// // Attach
	// if( target )
	// {
	// 	SetVariantString("!activator");
	// 	AcceptEntityInput(entity, "SetParent", target);
	// }

	return entity;
}


//new Float:g_fEllisTestFireRate = 0.0;
Action:TestFunction1(iClient, args)
{
	PrintToServer("T1");
	//PrintToChat(iClient, "T1");
	
	char str1[99];
	char str2[99];
	GetCmdArg(1, str1, sizeof(str1));
	GetCmdArg(2, str2, sizeof(str2));

	//if (args < 1) return Plugin_Stop;

	//AttachParticle(StringToInt(str1), "charger_motion_blur", 15.4, 0.0)

	// new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
	// new iAmmo = GetEntData(iClient, iOffset_Ammo + StringToInt(str1));
	// PrintToChatAll("iammo = %i", iAmmo);

	CreateWarezStation(iClient);

	PrintAllInEnhancedCIEntityList();

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
	PrintToServer("T2");

	decl Float:xyzClientLocation[3];
	GetClientAbsOrigin(iClient, xyzClientLocation);
	xyzClientLocation[2] += 30.0;
	WriteParticle(iClient, "mini_fireworks", 0.0, 10.0, xyzClientLocation);

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
	PrintToChat(iClient, "T3");
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
	PrintToServer("T4");
	char str1[99];
	GetCmdArg(1, str1, sizeof(str1));


	// decl String:strTimeScaleCmd[32];
	// Format(strTimeScaleCmd, sizeof(strTimeScaleCmd), "host_timescale %3f", StringToFloat(str1));
	// PrintToChat(iClient, "%s", strTimeScaleCmd);

	// RunCheatCommand(iClient, "host_timescale", strTimeScaleCmd);

	
	//g_hTimeScale.FloatValue = StringToFloat(str1);

	TimeScale(iClient, args)

	
	//OpenMOTDPanel(iClient, "t4" , " .", MOTDPANEL_TYPE_INDEX);
	//OpenMOTDPanel(iClient, "t4." , "<html><head><title>a</title><meta http-equiv = \"Content-Type\" content = \"text / html; charset = utf-8\" ></head><body bgcolor = \"# 000000\" ><p>test</p></body></html>", MOTDPANEL_TYPE_INDEX);
	return Plugin_Stop;
}

Action:TestFunction5(iClient, args)
{
	//PrintToChat(iClient, "T5");

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


public Action:TimeScale(client, args)
{
	decl i_Ent, String:arg[12];
	if(args == 1)
	{
		GetCmdArg(1, arg, sizeof(arg));
		new Float:scale = StringToFloat(arg);
		if(scale == 0.0)
		{
			ReplyToCommand(client, "[SM] Invalid Float!");
			return;
		}	
		i_Ent = CreateEntityByName("func_timescale");
		DispatchKeyValue(i_Ent, "desiredTimescale", arg);
		DispatchKeyValue(i_Ent, "acceleration", "2.0");
		DispatchKeyValue(i_Ent, "minBlendRate", "1.0");
		DispatchKeyValue(i_Ent, "blendDeltaMultiplier", "2.0");
		DispatchSpawn(i_Ent);
		AcceptEntityInput(i_Ent, "Start");
	}
	else
	{
		ReplyToCommand(client, "[SM] Usage: sm_timescale <float>");
	}	
}