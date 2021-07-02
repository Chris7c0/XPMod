MonitorVictimHealthMeterForSurvivorPlayer(iAttacker, iVictim)
{
	// Set the current target victim for the client
	g_iVictimHealthMeterWatchVictim[iAttacker] = iVictim;
	// Enable showing the client the victim health meter
	g_bVictimHealthMeterActive[iAttacker] = true;
	// Start or reset the timer to stop displaying victim health meter
	delete g_hTimer_VictimHealthMeterStop[iAttacker];
	g_hTimer_VictimHealthMeterStop[iAttacker] = CreateTimer(VICTIM_HEALTH_METER_DISPLAY_TIME, Timer_VictimHealthMeterStop, iAttacker);
}

Action Timer_VictimHealthMeterStop(Handle:timer, Handle:iClient)
{
	// Disable showing the client the victim health meter
	g_bVictimHealthMeterActive[iClient] = false;
	// Reset the current target victim for the client
	g_iVictimHealthMeterWatchVictim[iClient] = 0;

	g_hTimer_VictimHealthMeterStop[iClient] = null;
	return Plugin_Stop;
}

PrintVictimHealthMeterToSurvivorPlayer(int iClient)
{
	if (g_bVictimHealthMeterActive[iClient] == false)
		return;

	new iVictim = g_iVictimHealthMeterWatchVictim[iClient];

	if (RunClientChecks(iClient) == false ||
		RunClientChecks(iVictim) == false ||
		IsFakeClient(iClient) == true ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iClientTeam[iVictim] != TEAM_INFECTED)
		return;

	if (IsPlayerAlive(iVictim) == false)
	{
		PrintCenterText(iClient, "DEAD");
		// Disable any further updates, since they are dead
		g_bVictimHealthMeterActive[iClient] = false;
		g_iVictimHealthMeterWatchVictim[iClient] = 0;
		return;
	}

	new iCurrentMaxHealth = GetPlayerMaxHealth(iVictim);
	new iCurrentHealth = GetPlayerHealth(iVictim);
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

	PrintCenterText(iClient, 
		"%N\n\
		%s\n\
		%s ( %i / %i )",
		iVictim,
		strHealthBar,
		INFECTED_NAME[g_iInfectedCharacter[iVictim]],
		iCurrentHealth,
		iCurrentMaxHealth);
}