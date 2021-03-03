TalentsLoad_Tank(iClient)
{
	PrintHintText(iClient, "\x03[XPMod] \x04Choose your Tank using the menu.");
}

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

EventsHurt_AttackerTank(Handle:hEvent, iAttackerTank, iVictim)
{
	switch(g_iTankChosen[iAttackerTank])
	{
		case TANK_FIRE:			EventsHurt_AttackerTank_Fire(hEvent, iAttackerTank, iVictim);
		case TANK_ICE:			EventsHurt_AttackerTank_Ice(hEvent, iAttackerTank, iVictim);
		case TANK_NECROTANKER:	EventsHurt_AttackerTank_NecroTanker(hEvent, iAttackerTank, iVictim);
		case TANK_VAMPIRIC:		EventsHurt_AttackerTank_Vampiric(hEvent, iAttackerTank, iVictim);
	}
}

EventsHurt_VictimTank(Handle:hEvent, iAttacker, iVictimTank)
{
	// If the player has not selected a tank type, and they have take enough damage, then
	// automatically select a tank type for them.  This will be for people that never select
	if (g_iTankChosen[iVictimTank] == TANK_NOT_CHOSEN && 
		RunClientChecks(iVictimTank) && 
		IsFakeClient(iVictimTank) == false)
	{
		// Note: Valve multiplies the value with 1.5 so it becomes 4000 x 1.5 = 6000 hp.
		new iMaxHealthConVarSetting = RoundToCeil(GetConVarInt(FindConVar("z_tank_health")) * 1.5);
		new iCurrentHealth = GetEntProp(iVictimTank, Prop_Data, "m_iHealth");
		// Check if they lost enough HP yet
		if (iCurrentHealth < iMaxHealthConVarSetting - TANK_AUTOMATIC_SELECT_HP_LOSS)
		{
			// Close their Tank selection menu
			ClosePanel(iVictimTank);

			// They lost enough HP, load their auto-selected XPMod Tank abilities
			switch (TANK_AUTOMATIC_SELECT_TYPE)
			{
				case TANK_FIRE: LoadFireTankTalents(iVictimTank);
				case TANK_ICE:	LoadIceTankTalents(iVictimTank);
				case TANK_NECROTANKER:	LoadNecroTankerTalents(iVictimTank);
				case TANK_VAMPIRIC:	LoadVampiricTankTalents(iVictimTank);
			}

			// Display a message to the user saying it was automatically selected
			PrintToChat(iVictimTank, "\x03[XPMod] \x04Automatic Tank selection applied.\n                 You lost too much HP before choosing your Tank.");
		}
	}
	

	// Globally for all tanks, put them out after X seconds
	new iDmgType = GetEventInt(hEvent, "type");
	if (g_iTankChosen[iVictimTank] != TANK_FIRE && (iDmgType == DAMAGETYPE_FIRE1 || iDmgType == DAMAGETYPE_FIRE2))
	{
		// This will reset the timer each time they take new fire damage
		delete g_hTimer_ExtinguishTank[iVictimTank];
		g_hTimer_ExtinguishTank[iVictimTank] = CreateTimer(30.0, TimerExtinguishTank, iVictimTank);
	}
	
	switch(g_iTankChosen[iVictimTank])
	{
		case TANK_FIRE:			EventsHurt_VictimTank_Fire(hEvent, iAttacker, iVictimTank);
		case TANK_ICE:			EventsHurt_VictimTank_Ice(hEvent, iAttacker, iVictimTank);
		case TANK_NECROTANKER:	EventsHurt_VictimTank_NecroTanker(hEvent, iAttacker, iVictimTank);
		case TANK_VAMPIRIC:		EventsHurt_VictimTank_Vampiric(hEvent, iAttacker, iVictimTank);
	}
}


// EventsDeath_AttackerTank(Handle:hEvent, iAttackerTank, iVictim)
// {
// 	switch(g_iTankChosen[iAttackerTank])
// 	{
// 		// case TANK_FIRE:			EventsDeath_AttackerTank_Fire(hEvent, iAttackerTank, iVictim);
// 		// case TANK_ICE:			EventsDeath_AttackerTank_Ice(hEvent, iAttackerTank, iVictim);
// 		// case TANK_NECROTANKER:	EventsDeath_AttackerTank_NecroTanker(hEvent, iAttackerTank, iVictim);
// 		// case TANK_VAMPIRIC:		EventsDeath_AttackerTank_Vampiric(hEvent, iAttackerTank, iVictim);
// 	}
// }

EventsDeath_VictimTank(Handle:hEvent, iAttacker, iVictimTank)
{
	if (g_iClientTeam[iVictimTank] != TEAM_INFECTED ||
		g_bEndOfRound == true ||
		RunClientChecks(iVictimTank) == false ||
		GetEntProp(iVictimTank, Prop_Send, "m_zombieClass") != TANK)
		return;

	// Decriment the global Tank counter
	g_iTankCounter--;

	switch(g_iTankChosen[iVictimTank])
	{
		case TANK_FIRE:			EventsDeath_VictimTank_Fire(hEvent, iAttacker, iVictimTank);
		// case TANK_ICE:			EventsDeath_VictimTank_Ice(hEvent, iAttacker, iVictimTank);
		// case TANK_NECROTANKER:	EventsDeath_VictimTank_NecroTanker(hEvent, iAttacker, iVictimTank);
		// case TANK_VAMPIRIC:		EventsDeath_VictimTank_Vampiric(hEvent, iAttacker, iVictimTank);
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

	ResetTankHealth(iClient);
	
	// Reset their cooldown
	SetSIAbilityCooldown(iClient);

	// Remove fire if the previous tank was a Fire Tank
	ExtinguishEntity(iClient);

	if(g_bEndOfRound == false)
		StopHudOverlayColor(iClient);

	// PrintToChatAll("%N ResetAllTankVariables Ended", iClient);
}

ResetTankHealth(int iClient)
{
	// Clamp Player Max Health to ConVar Setting of Tank Max health
	// Note: Valve multiplies the value with 1.5 so it becomes 4000 x 1.5 = 6000 hp.
	new iMaxHealthConVarSetting = RoundToCeil(GetConVarInt(FindConVar("z_tank_health")) * 1.5);
	// Scale the max health to the survivors levels or for XPMod spawn
	iMaxHealthConVarSetting = RoundToNearest(iMaxHealthConVarSetting * g_fTankStartingHealthMultiplier[iClient]);
	//PrintToChatAll("iMaxHealthConVarSetting: %i", iMaxHealthConVarSetting);
	new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	// PrintToChatAll("%N ResetAllTankVariables m_iHealth = %i m_iMaxHealth = %i iMaxHealthConVarSetting = %i", iClient, iCurrentHealth, iMaxHealth, iMaxHealthConVarSetting);
	
	// Clamp Player MaxHealth to ConVar Health
	if (iMaxHealth > iMaxHealthConVarSetting)
		SetEntProp(iClient, Prop_Data, "m_iMaxHealth", iMaxHealthConVarSetting);

	// iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	// PrintToChatAll("%N ResetAllTankVariables m_iHealth = %i m_iMaxHealth = %i iMaxHealthConVarSetting = %i", iClient, iCurrentHealth, iMaxHealth, iMaxHealthConVarSetting);

	// Clamp Player Health to Max Health
	if (iCurrentHealth > iMaxHealthConVarSetting)
		SetEntProp(iClient, Prop_Data, "m_iHealth", iMaxHealthConVarSetting);
	// PrintToChatAll("%N ResetAllTankVariables m_iHealth = %i m_iMaxHealth = %i iMaxHealthConVarSetting = %i", iClient, iCurrentHealth, iMaxHealth, iMaxHealthConVarSetting);
}

float CalculateTankHealthPercentageMultiplier()
{
	int iCombinedSurvivorLevel = 0;
	float fNormalizedTankHealthPercentageMultiplier = 0.0;

	// For XPMod Tank spawns (Jockey pee spawn, NecroTanker, etc.) give the proper health
	if (g_bTankStartingHealthXPModSpawn)
	{
		g_bTankStartingHealthXPModSpawn = false;
		return TANK_STARTING_HEALTH_MULTIPLIER_XPMOD_SPAWN;
	}

	// Get all the survivor's levels add them up
	for (int i = 1; i <= MaxClients; i++)
	{
		if (RunClientChecks(i) && 
			g_iClientTeam[i] == TEAM_SURVIVORS &&
			IsFakeClient(i) == false &&
			g_bClientLoggedIn[i] == true &&
			IsPlayerAlive(i) == true)
			iCombinedSurvivorLevel += g_iClientLevel[i];
	}

	// Normalize the combined survivor level with a base min multiplier
	fNormalizedTankHealthPercentageMultiplier = TANK_STARTING_HEALTH_MULTIPLIER_MIN + ((1.0 - TANK_STARTING_HEALTH_MULTIPLIER_MIN) * (iCombinedSurvivorLevel / float(TANK_STARTING_HEALTH_REQUIRED_TEAM_LEVEL_FOR_MAX)) );

	// Cap upper bounds
	if (fNormalizedTankHealthPercentageMultiplier > TANK_STARTING_HEALTH_MULTIPLIER_MAX)
		fNormalizedTankHealthPercentageMultiplier = TANK_STARTING_HEALTH_MULTIPLIER_MAX;

	// Return the health multiplier
	return fNormalizedTankHealthPercentageMultiplier;
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