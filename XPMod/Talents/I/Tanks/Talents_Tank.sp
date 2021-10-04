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
		new iCurrentHealth = GetPlayerHealth(iVictimTank);

		// PrintToChat(iVictimTank, "iCurrentHealth: %i, iMaxHealthConVarSetting: %i,  g_fTankStartingHealthMultiplier[iClient]: %f", iCurrentHealth, iMaxHealthConVarSetting,  g_fTankStartingHealthMultiplier[iVictimTank]);

		// Check if they lost enough HP yet
		if (iCurrentHealth < RoundToNearest(iMaxHealthConVarSetting * g_fTankStartingHealthMultiplier[iVictimTank]) - TANK_AUTOMATIC_SELECT_HP_LOSS)
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

	if (g_iTankChosen[iVictimTank] != TANK_FIRE && 
		(iDmgType == DAMAGETYPE_FIRE1 || 
		iDmgType == DAMAGETYPE_FIRE2 || 
		iDmgType == DAMAGETYPE_IGNITED_ENTITY))
	{
		// This will reset the timer each time they take new fire damage
		if (iDmgType == DAMAGETYPE_IGNITED_ENTITY && g_hTimer_ExtinguishTank[iVictimTank] == null)
		{
			delete g_hTimer_ExtinguishTank[iVictimTank];
			g_hTimer_ExtinguishTank[iVictimTank] = CreateTimer(TANK_BURN_DURATION, TimerExtinguishTank, iVictimTank);
		}
		else if(iDmgType != DAMAGETYPE_IGNITED_ENTITY)
		{
			delete g_hTimer_ExtinguishTank[iVictimTank];
			g_hTimer_ExtinguishTank[iVictimTank] = CreateTimer(TANK_BURN_DURATION, TimerExtinguishTank, iVictimTank);
		}
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

	// Decrement the global Tank counter
	g_iTankCounter--;

	// This is required for when a human or bot tank dies, to give full health if a transfer happens.
	g_bIsFrustratedTank[iVictimTank] = false;

	switch(g_iTankChosen[iVictimTank])
	{
		case TANK_FIRE:			EventsDeath_VictimTank_Fire(hEvent, iAttacker, iVictimTank);
		case TANK_ICE:			EventsDeath_VictimTank_Ice(hEvent, iAttacker, iVictimTank);
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

// This is a timed function written for the Tank Spawn event, which doesn't work unless its timed
Action:TimerResetAllTankVariables(Handle:timer, any:iClient)
{
	ResetAllTankVariables(iClient);
	return Plugin_Stop;
}

void ResetAllTankVariables(iClient)
{
	if (RunClientChecks(iClient) == false)
		return;

	//PrintToChatAll("%N ResetAllTankVariables", iClient);

	// Generic Tank Variables
	g_iTankChosen[iClient] = TANK_NOT_CHOSEN;
	g_bIsFrustratedTank[iClient] = false;
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

	// // if (RunClientChecks(iClient) && IsFakeClient(iClient) == false)
	// PrintToChatAll("%N g_iInfectedCharacter = %i  g_iClientTeam = %i  RunClientChecks = %i, IsPlayerAlive = %i  m_zombieClass = %i",
	// 	iClient,
	// 	g_iInfectedCharacter[iClient], 
	// 	g_iClientTeam[iClient], 
	// 	RunClientChecks(iClient), 
	// 	IsPlayerAlive(iClient), 
	// 	GetEntProp(iClient, Prop_Send, "m_zombieClass") );

	// Everything beyond here is for if the player is alive as a tank
	// This is for when a player becomes a tank after another tank
	if (g_iInfectedCharacter[iClient] != TANK ||
		g_iClientTeam[iClient] != TEAM_INFECTED ||
		RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false ||
		GetEntProp(iClient, Prop_Send, "m_zombieClass") != TANK)
		return;
	
	// Give bot XPMod abilities or ask the player to pick an XPMod tank
	CreateTimer(0.1, Timer_AskWhatTankToUse, iClient, TIMER_FLAG_NO_MAPCHANGE);

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
	//PrintToChatAll("%N ResetTankHealth", iClient)

	// Set Player Max Health to ConVar Setting of Tank Max health
	// Note: Valve multiplies the value with 1.5 so it becomes 4000 x 1.5 = 6000 hp.
	new iMaxHealthConVarSetting = RoundToCeil(GetConVarInt(FindConVar("z_tank_health")) * 1.5);
	SetPlayerMaxHealth(iClient, iMaxHealthConVarSetting);

	// Set player health to the new max
	new iNewHealth = iMaxHealthConVarSetting;

	//PrintToChatAll("1) %N ResetTankHealth g_fFrustratedTankTransferHealthPercentage: %f iMaxHealthConVarSetting = %i iNewHealth = %i", iClient, g_fFrustratedTankTransferHealthPercentage, iMaxHealthConVarSetting, iNewHealth);

	// If this was a transferred (passed or frustrated) tank, then set the health to this percentage
	if (g_bTankHealthJustSet[iClient] == false && g_fFrustratedTankTransferHealthPercentage > 0.0)
	{
		iNewHealth = RoundToNearest(iNewHealth * g_fFrustratedTankTransferHealthPercentage);
		// If they are a take over bot (temporary holding the tank until human gets the tank. Happens when player goes
		// to spectator, not when tank frustrated), then do not rest this value, because it will reset before the human gets it.
		// Tried using IsFakeClient(iClient) == false here but cant do this because if the bot tank is
		// still alive and there is a transfer then the next tank will get the percentage health.
		if (g_bIsFrustratedTank[iClient] == false && g_bTankTakeOverBot[iClient] == false)
			g_fFrustratedTankTransferHealthPercentage = 0.0;

		// Create a timer to reset the g_bTankTakeOverBot
		if (g_bTankTakeOverBot[iClient] == true)
			CreateTimer(1.0, TimerResetTankTakeOverBot, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}

	//PrintToChatAll("2) %N ResetTankHealth g_fFrustratedTankTransferHealthPercentage: %f iMaxHealthConVarSetting = %i iNewHealth = %i", iClient, g_fFrustratedTankTransferHealthPercentage, iMaxHealthConVarSetting, iNewHealth);

	if (g_bTankHealthJustSet[iClient] == false)
		SetPlayerHealth(iClient, iNewHealth);

	// This is so that the tank cant be set twice for the same player during a transfer
	// Its required because this is called a few times for each player, because multiple
	// events are required to capture every scenario
	g_bTankHealthJustSet[iClient] = true;
	CreateTimer(6.0, TimerResetTankHealthJustSet, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

Action:TimerResetTankHealthJustSet(Handle:timer, any:iClient)
{
	g_bTankHealthJustSet[iClient] = false;
	return Plugin_Stop;
}

Action:TimerResetTankTakeOverBot(Handle:timer, any:iClient)
{
	g_bTankTakeOverBot[iClient] = false;
	return Plugin_Stop;
}

SetTanksTalentHealth(int iClient, int iMaxHealthAmount)
{
	//PrintToChatAll("SetTanksTalentHealth %N", iClient);
	
	// Get the normalized health percentage to apply with the new tanks max health
	float fNormalizedHealthPercentage = float(GetPlayerHealth(iClient)) / float(GetPlayerMaxHealth(iClient));
	new iNewMaxHealth = RoundToNearest(iMaxHealthAmount * g_fTankStartingHealthMultiplier[iClient])
	new iNewHealth = RoundToNearest(iNewMaxHealth * fNormalizedHealthPercentage);

	//PrintToChatAll("fNormalizedHealthPercentage iHealth = %f iNewMaxHealth = %i iNewHealth = %i", fNormalizedHealthPercentage, iNewMaxHealth, iNewHealth);

	// Set New Health Values
	SetPlayerMaxHealth(iClient, iNewMaxHealth, false, false);
	SetPlayerHealth(iClient, iNewHealth > 100 ? iNewHealth : 100);
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


StorePassedOrFrustratedTanksHealthPercentage(iClient)
{
	// This is required to not set the value of g_fFrustratedTankTransferHealthPercentage if the player is not a tank
	// This function can be called from several places including player change team so need to check this.
	if (RunClientChecks(iClient) == false || g_iInfectedCharacter[iClient] != TANK)
	{
		//PrintToChatAll("StorePassedOrFrustratedTanksHealthPercentage not TANK");
		return;
	}

	// This is required for later to know if it can reset the g_fFrustratedTankTransferHealthPercentage variable
	// It needs to know if the player was frustrated since the death event is fired even when transferring tank.
	// Setting this this to true will make the tank reset skipped.
	g_bIsFrustratedTank[iClient] = true;

	new iMaxHealth = GetPlayerMaxHealth(iClient);
	new iCurrentHealth = GetPlayerHealth(iClient);
	g_fFrustratedTankTransferHealthPercentage = iCurrentHealth / float(iMaxHealth);
	
	//PrintToChatAll("%N StorePassedOrFrustratedTanksHealthPercentage iHealth = %i MaxHealth = %i g_fFrustratedTankTransferHealthPercentage: %f", iClient, iCurrentHealth, iMaxHealth, g_fFrustratedTankTransferHealthPercentage);
	//PrintToChatAll("\x03[XPMod] \x04%N's tank has been frustrated or passed. Transferring tank with %3f health.", iClient, g_fFrustratedTankTransferHealthPercentage);
}


CheckIfTankMovedWhileChargingAndIncrementCharge(iClient)
{
	decl Float:xyzCurrentPosition[3];
	GetClientAbsOrigin(iClient, xyzCurrentPosition);

	// Make sure the tank hasn't moved while charging(tanks position has changed)
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