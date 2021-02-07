
//Testing Functions//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// AddLouisTeleportVelocity(iClient, Float:speed)
// {
// 	new Float:vecVelocity[3];
// 	GetEntDataVector(iClient, g_iOffset_VecVelocity, vecVelocity);

// 	decl Float:xyzAngles[3], Float:vDirection[3];
// 	GetClientEyeAngles(iClient, xyzAngles);								// Get clients Eye Angles to know get what direction face
// 	GetAngleVectors(xyzAngles, vDirection, NULL_VECTOR, NULL_VECTOR);	// Get the direction the iClient is looking

// 	//if (IsFakeClient(iClient) == false) PrintToChat(iClient, "vDirection: %2f, %2f, %2f", vDirection[0], vDirection[1], vDirection[2]);

// 	vecVelocity[0] = (vDirection[0] * speed);
// 	vecVelocity[1] = (vDirection[1] * speed);
// 	//vecVelocity[2] = 300.0;
// 	//vecVelocity[2] = -500.0;//(vDirection[2] * speed);
// 	// if ((GetEntityFlags(iClient) & FL_ONGROUND) && vecVelocity[2] < 300.0)
// 	// 	vecVelocity[2] = 300.0;
	
// 	//SetEntProp(iClient, Prop_Send, "m_nSolidType", 0);
// 	//SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
// 	//SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_FLY_SLIDE);
// 	//SetMoveType(iClient, MOVETYPE_NOCLIP, MOVETYPE_NOCLIP);

// 	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vecVelocity);
// }

// Action:ResetPlayerVelocity(Handle:timer,  any:iClient)
// {
// 	SetClientSpeed(iClient);
// 	//SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
// 	//TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, EMPTY_VECTOR);
// 	return Plugin_Stop;
// }


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
	WriteParticle(iClient, str1, 0.0, 30.0);

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