OnGameFrame_Tank(iClient)
{
	switch (g_iTankChosen[iClient])
	{
		case TANK_FIRE:			OnGameFrame_Tank_Fire(iClient);
		case TANK_ICE:			OnGameFrame_Tank_Ice(iClient);
		case TANK_NECROTANKER:	OnGameFrame_Tank_NecroTanker(iClient);
		case TANK_VAMPIRIC:		OnGameFrame_Tank_Vampiric(iClient);
	}
}

EventsHurt_VictimTank(Handle:hEvent, iAttacker, iVictimTank)
{
	// Globally for all tanks, put them out after X seconds
	new iDmgType = GetEventInt(hEvent, "type");
	if(g_iTankChosen[iVictimTank] != TANK_FIRE && (iDmgType == DAMAGETYPE_FIRE1 || iDmgType == DAMAGETYPE_FIRE2))
	{
		// This will reset the timer each time they take new fire damage
		delete g_hTimer_ExtinguishTank[iVictimTank];
		g_hTimer_ExtinguishTank[iVictimTank] = CreateTimer(30.0, TimerExtinguishTank, iVictimTank);
	}
	
	switch(g_iTankChosen[iVictimTank])
	{
		case TANK_FIRE:			EventsHurt_TankVictim_Fire(hEvent, iAttacker, iVictimTank);
		case TANK_ICE:			EventsHurt_TankVictim_Ice(hEvent, iAttacker, iVictimTank);
		case TANK_NECROTANKER:	EventsHurt_TankVictim_NecroTanker(hEvent, iAttacker, iVictimTank);
		case TANK_VAMPIRIC:		EventsHurt_TankVictim_Vampiric(hEvent, iAttacker, iVictimTank);
	}
}

EventsHurt_AttackerTank(Handle:hEvent, iAttackerTank, iVictim)
{
	switch(g_iTankChosen[iAttackerTank])
	{
		case TANK_FIRE:			EventsHurt_TankAttacker_Fire(hEvent, iAttackerTank, iVictim);
		case TANK_ICE:			EventsHurt_TankAttacker_Ice(hEvent, iAttackerTank, iVictim);
		case TANK_NECROTANKER:	EventsHurt_TankAttacker_NecroTanker(hEvent, iAttackerTank, iVictim);
		case TANK_VAMPIRIC:		EventsHurt_TankAttacker_Vampiric(hEvent, iAttackerTank, iVictim);
	}
}

SetupTankForBot(iClient)
{
	// Choose a random tank for the bot to use
	switch(GetRandomInt(TANK_FIRE, TANK_VAMPIRIC))
	{
		case TANK_FIRE:			LoadFireTankTalents(iClient);
		case TANK_ICE:			LoadIceTankTalents(iClient);
		case TANK_NECROTANKER:	LoadNecroTankerTalents(iClient);
		case TANK_VAMPIRIC:		LoadVampiricTankTalents(iClient);
	}
}

// This is a timed fucntion writen for the Tank Spawn event, which doesnt work unless its timed
Action:TimerResetAllTankVariables(Handle:timer, any:iClient)
{
	ResetAllTankVariables(iClient);
	return Plugin_Stop;
}

ResetAllTankVariables(iClient)
{
	// Generic Tank Variables
	g_iTankChosen[iClient] = TANK_NOT_CHOSEN;
	g_bTankOnFire[iClient] = false;
	g_iTankCharge[iClient] = 0;
	g_xyzClientTankPosition[iClient][0] = 0.0;
	g_xyzClientTankPosition[iClient][1] = 0.0;
	g_xyzClientTankPosition[iClient][2] = 0.0;
	TurnOffAndDeleteSmokeStackParticle(g_iPID_TankTrail[iClient]);

	// Class specific tank variables
	ResetAllTankVariables_Fire(iClient);
	ResetAllTankVariables_Ice(iClient);
	ResetAllTankVariables_NecroTanker(iClient);
	ResetAllTankVariables_Vampiric(iClient);

	// if (RunClientChecks(iClient) && IsFakeClient(iClient) == false)
	// 	PrintToChatAll("%N g_iInfectedCharacter = %i  g_iClientTeam = %i  IsPlayerAlive = %i  m_zombieClass = %i",
	// 		iClient,
	// 		g_iInfectedCharacter[iClient], 
	// 		g_iClientTeam[iClient], 
	// 		RunClientChecks(iClient), 
	// 		IsPlayerAlive(iClient), 
	// 		GetEntProp(iClient, Prop_Send, "m_zombieClass") );

	// Everything beyond here is for if the player is alive as a tank
	// This is for when a player becomes a tank after another tank
	if (g_iInfectedCharacter[iClient] != TANK ||
		g_iClientTeam[iClient] != TEAM_INFECTED ||
		RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false ||
		GetEntProp(iClient, Prop_Send, "m_zombieClass") != TANK)
		return;

	// Clamp Player Max Health to ConVar Setting of Tank Max health
	// Note: Valve multiplies the value with 1.5 so it becomes 4000 x 1.5 = 6000 hp.
	new iMaxHealthConVarSetting = RoundToCeil(GetConVarInt(FindConVar("z_tank_health")) * 1.5);
	new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	// PrintToChatAll("%N ResetAllTankVariables m_iMaxHealth = %i iMaxHealthConVarSetting = %i", iClient, iMaxHealth, iMaxHealthConVarSetting);
	if (iMaxHealth > iMaxHealthConVarSetting)
		SetEntProp(iClient, Prop_Data, "m_iMaxHealth", iMaxHealthConVarSetting);
	// Clamp Player Health to Max Health
	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	// iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	// PrintToChatAll("%N ResetAllTankVariables m_iHealth = %i m_iMaxHealth = %i iMaxHealthConVarSetting = %i", iClient, iCurrentHealth, iMaxHealth, iMaxHealthConVarSetting);
	if (iCurrentHealth > iMaxHealthConVarSetting)
		SetEntProp(iClient, Prop_Data, "m_iHealth", iMaxHealthConVarSetting);
	// PrintToChatAll("%N ResetAllTankVariables m_iHealth = %i m_iMaxHealth = %i iMaxHealthConVarSetting = %i", iClient, iCurrentHealth, iMaxHealth, iMaxHealthConVarSetting);

	// Reset their cooldown
	SetSIAbilityCooldown(iClient);

	// Remove fire if the previous tank was a Fire Tank
	ExtinguishEntity(iClient);

	// PrintToChatAll("%N ResetAllTankVariables Ended", iClient);
}

CheckIfTankMovedWhileChargingAndIncrementCharge(iClient)
{
	decl Float:xyzCurrentPosition[3];
	GetClientAbsOrigin(iClient, xyzCurrentPosition);



	//Make sure the tank hasnt moved while charging(tanks position has changed)
	new Float:distance = GetVectorDistance(g_xyzClientTankPosition[iClient], xyzCurrentPosition, false);
	if(distance < 5.0)
	{
		g_iTankCharge[iClient]++;
	}
	else
	{
		if(g_iTankCharge[iClient] != 0)
		{
			if(g_iTankCharge[iClient] > 31 && IsFakeClient(iClient) == false)
				PrintHintText(iClient, "Interrupted");
			
			g_iTankCharge[iClient] = 0;
			g_bShowingIceSphere[iClient] = false;
		}
		g_xyzClientTankPosition[iClient][0] = xyzCurrentPosition[0];
		g_xyzClientTankPosition[iClient][1] = xyzCurrentPosition[1];
		g_xyzClientTankPosition[iClient][2] = xyzCurrentPosition[2];
	}
}

Event_BoomerVomitOnPlayerTank(iVictim)
{
	if (RunClientChecks(iVictim) == false || 
		g_iClientTeam[iVictim] != TEAM_INFECTED || 
		IsPlayerAlive(iVictim) == false || 
		GetEntProp(iVictim, Prop_Send, "m_zombieClass") != TANK)
		return;
	
	if (g_iTankChosen[iVictim] == TANK_NECROTANKER)
		SDKCall(g_hSDK_UnVomitOnPlayer, iVictim);
}