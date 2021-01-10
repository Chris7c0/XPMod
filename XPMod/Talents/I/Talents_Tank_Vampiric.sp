LoadVampiricTankTalents(iClient)
{
	g_fClientSpeedBoost[iClient] = 0.0;
	g_fClientSpeedPenalty[iClient] = 0.0;

	if(iClient < 1 || g_iClientTeam[iClient] != TEAM_INFECTED || IsClientInGame(iClient) == false || 
		IsFakeClient(iClient) == true || GetEntProp(iClient, Prop_Send, "m_zombieClass") != TANK)
		return;
	
	if(IsPlayerAlive(iClient) == false)
	{
		PrintToChat(iClient, "\x04You cannot choose tank talents after you have died");
		return;
	}
	
	g_iTankChosen[iClient] = TANK_VAMPIRIC;
	
	g_bCanFlapVampiricTankWings[iClient] = true;
	g_bIsVampiricTankFlying[iClient] = false;
	
	//Give Health
	SetEntProp(iClient, Prop_Data,"m_iMaxHealth", TANK_HEALTH_VAMPIRIC);
	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	SetEntProp(iClient, Prop_Data,"m_iHealth", iCurrentHealth + TANK_HEALTH_VAMPIRIC - 6000);
	
	//Set Movement Speed
	//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), 1.0 - (RoundToCeil(g_iClientLevel[iClient] / 5.0) * 0.01), true);
	//g_fClientSpeedPenalty[iClient] += (RoundToCeil(g_iClientLevel[iClient] / 5.0) * 0.01);
	//fnc_SetClientSpeed(iClient);
	
	//Change Skin Color
	SetEntityRenderMode(iClient, RenderMode:0);
	SetEntityRenderColor(iClient, 100, 0, 255, 255);

	//Grow the tank, doesnt seem to work
	//SetEntPropFloat(iClient , Prop_Send,"m_flModelScale", 1.3); 
	
	//Particle effects
	CreateVampiricTankTrailEffect(iClient);

	PrintHintText(iClient, "You are now the Vampiric Tank");
}

OnGameFrame_Tank_Vampiric(iClient)
{
	new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);

	//Check to see if pressing the fly button, if so, start flappling those wings
	if(g_bCanFlapVampiricTankWings[iClient] && (buttons & IN_JUMP)) 
	{
		g_bIsVampiricTankFlying[iClient] = true;
		g_bCanFlapVampiricTankWings[iClient] = false;
		SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
		AddWingFlapVelocity(iClient, VAMPIRIC_TANK_WING_FLAP_UP_VELOCITY);
		decl Float:xyzClientPosition[3];
		GetClientEyePosition(iClient, xyzClientPosition);
		// Play a random sound effect name from the the boomer throw selection
		new iRandomSoundNumber = GetRandomInt(0 ,sizeof(SOUND_WING_FLAP) - 1);
		// Play it twice because its to quiet (super dirty, but what do)
		EmitAmbientSound(SOUND_WING_FLAP[ iRandomSoundNumber ], xyzClientPosition, iClient, SNDLEVEL_GUNFIRE);
		EmitAmbientSound(SOUND_WING_FLAP[ iRandomSoundNumber ], xyzClientPosition, iClient, SNDLEVEL_GUNFIRE);
		CreateTimer(1.0, TimerCanFlapVampiricTankWingsReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
	if(g_bIsVampiricTankFlying[iClient] && (GetEntityFlags(iClient) & FL_ONGROUND))
	{
		g_bIsVampiricTankFlying[iClient] = false;
		SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
	}
}

EventsHurt_TankVictim_Vampiric(iVictimTank, iDmgType, iDmgHealth)
{
	SuppressNeverUsedWarning(iVictimTank, iDmgType, iDmgHealth);
}

EventsHurt_TankAttacker_Vampiric(iAttackerTank, iVictim, Handle:hEvent, iDmgType, iDmgHealth)
{
	SuppressNeverUsedWarning(hEvent, iDmgType);

	if (RunClientChecks(iAttackerTank) == false || RunClientChecks(iVictim) == false ||
		IsPlayerAlive(iAttackerTank) == false || IsPlayerAlive(iVictim) == false)
		return;

	// Calculate the health to recieve and give to the Tank
	new iVampiricHealthGainAmount = iDmgHealth * VAMPIRIC_TANK_LIFESTEAL_MULTIPLIER;
	// Get the current life level
	new iCurrentHP = GetEntProp(iAttackerTank,Prop_Data,"m_iHealth");
	if(iCurrentHP < TANK_HEALTH_VAMPIRIC)
	{
		if(iCurrentHP + iVampiricHealthGainAmount < TANK_HEALTH_VAMPIRIC)
			SetEntProp(iAttackerTank,Prop_Data,"m_iHealth", iCurrentHP + iVampiricHealthGainAmount);
		else
			SetEntProp(iAttackerTank,Prop_Data,"m_iHealth", TANK_HEALTH_VAMPIRIC);

		// Show hud effect:
		if(IsFakeClient(iAttackerTank)==false)
			ShowHudOverlayColor(iAttackerTank, 100, 0, 255, 40, 440, FADE_OUT);
		
		if(IsFakeClient(iVictim)==false)
			ShowHudOverlayColor(iVictim, 180, 0, 100, 40, 440, FADE_OUT);
	}
}

AddWingFlapVelocity(iClient, Float:speed)
{
	new Float:vecVelocity[3];
	GetEntDataVector(iClient, g_iOffset_VecVelocity, vecVelocity);

	// if ((vecVelocity[2]+speed) > 2500.0)
	// 	vecVelocity[2] = 2500.0;
	// else
	vecVelocity[2] = speed;

	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vecVelocity);
}

public Action:TimerCanFlapVampiricTankWingsReset(Handle:timer, any:iClient)
{
	g_bCanFlapVampiricTankWings[iClient] = true;
	return Plugin_Stop;
}

CreateVampiricTankTrailEffect(int iClient)
{
	new Float:xyzTankPosition[3];
	GetClientAbsOrigin(iClient, xyzTankPosition);
	xyzTankPosition[2] += 30.0;
	new String:vecString[32];
	Format(vecString, sizeof(vecString), "%f %f %f", xyzTankPosition[0], xyzTankPosition[1], xyzTankPosition[2]);

	g_iPID_IceTankTrail[iClient] = CreateEntityByName("env_smokestack");
	
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"Origin", vecString);
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"BaseSpread", "0");		//Gap in the middle
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"SpreadSpeed", "20");	//Speed the smoke moves outwards
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"Speed", "5");			//The speed at which the smoke particles move after they're spawned
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"StartSize", "35");
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"EndSize", "70");
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"Rate", "5");			//Amount of smoke created
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"JetLength", "20");		//Smoke jets outside of the original
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"Twist", "3"); 			//Amount of global twisting
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"RenderColor", "200 0 200");
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"RenderAmt", "50");		//Transparency
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
	
	
	SetVariantString("!activator");
	AcceptEntityInput(g_iPID_IceTankTrail[iClient], "SetParent", iClient, g_iPID_IceTankTrail[iClient], 0);

	DispatchSpawn(g_iPID_IceTankTrail[iClient]);
	AcceptEntityInput(g_iPID_IceTankTrail[iClient], "TurnOn");
}