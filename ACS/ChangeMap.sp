/*======================================================================================
#################             A C S   C H A N G E   M A P              #################
======================================================================================*/

void ChangeMapIfNeeded()
{
	if (IsGameModeValid(g_iGameMode) == false)
		return;
	
	// This is required because the Events can fire multiple times
	g_bStopACSChangeMap = true;
	CreateTimer(REALLOW_ACS_MAP_CHANGE_DELAY, TimerResetCanACSChangeMap, _);

	//Check to see if someone voted for a map, if so, then change to the winning map
	if(g_bVotingEnabled == true && g_iWinningMapVotes > 0 && g_iWinningMapIndex >= 0)
	{
		if (IsMapIndexValid(g_iWinningMapIndex) == false)
			return;
		
		CreateTimer(g_fWaitTimeBeforeSwitch[g_iGameMode], Timer_ChangeMap, g_iWinningMapIndex);
		return;
	}
	
	//If no map was chosen in the vote, then go with the automatic map rotation
	int iNextMapIndex = FindNextMapIndex();
	if (IsMapIndexValid(iNextMapIndex) == false)
		return;

	// Delayed call to 
	CreateTimer(g_fWaitTimeBeforeSwitch[g_iGameMode], Timer_ChangeMap, iNextMapIndex);
}

// Change campaign using its index
Action Timer_ChangeMap(Handle timer, int iMapIndex)
{
	//Change the campaign using the array for its game mode
	switch (g_iGameMode)
	{
		case GAMEMODE_COOP:				ServerCommand("changelevel %s", g_strCampaignFirstMap[iMapIndex]);
		case GAMEMODE_VERSUS:			ServerCommand("changelevel %s", g_strCampaignFirstMap[iMapIndex]);
		case GAMEMODE_SCAVENGE:			ServerCommand("changelevel %s", g_strScavengeMap[iMapIndex]);
		case GAMEMODE_SURVIVAL:			ServerCommand("changelevel %s", g_strSurvivalMap[iMapIndex]);
		case GAMEMODE_VERSUS_SURVIVAL:	ServerCommand("changelevel %s", g_strSurvivalMap[iMapIndex]);
	}
	
	return Plugin_Stop;
}

// This is required because the Events can fire multiple times
Action TimerResetCanACSChangeMap(Handle timer, int iData)
{
	g_bStopACSChangeMap = false;

	return Plugin_Stop;
}


int FindCurrentMapIndex()
{
	char strCurrentMap[32];
	GetCurrentMap(strCurrentMap, 32);	//Get the current map from the game

	// PrintToServer("               ===========                                  FindCurrentMapIndex %i", GetMapListArraySizeForGameMode(g_iGameMode));

	//Go through all maps and to find which map index it is on, and then switch to the next map
	for(int iMapIndex = 0; iMapIndex < GetMapListArraySizeForGameMode(g_iGameMode); iMapIndex++)
	{
		switch(g_iGameMode)
		{
			case GAMEMODE_COOP:				if (StrEqual(strCurrentMap, g_strCampaignLastMap[iMapIndex]) == true) return iMapIndex;
			case GAMEMODE_VERSUS:			if (StrEqual(strCurrentMap, g_strCampaignLastMap[iMapIndex]) == true) return iMapIndex;
			case GAMEMODE_SCAVENGE:			if (StrEqual(strCurrentMap, g_strScavengeMap[iMapIndex]) == true) return iMapIndex;
			case GAMEMODE_SURVIVAL:			if (StrEqual(strCurrentMap, g_strSurvivalMap[iMapIndex]) == true) return iMapIndex;
			case GAMEMODE_VERSUS_SURVIVAL:	if (StrEqual(strCurrentMap, g_strSurvivalMap[iMapIndex]) == true) return iMapIndex;
		}
	}

	return -1;
}

int FindNextMapIndex()
{
	int iCurrentMapIndex = FindCurrentMapIndex();
	if (iCurrentMapIndex == -1)
		return -1;

	// PrintToServer("               ===========                                  FindCurrentMapIndex %i", iCurrentMapIndex);

	int iNextCampaignMapIndex = iCurrentMapIndex + 1;							// Get the next campaign map index

	if(iCurrentMapIndex == GetMapListArraySizeForGameMode(g_iGameMode) - 1)		// Check to see if its the end of the array
		iNextCampaignMapIndex = 0;												// If so, set it to the first map index

	// PrintToServer("               ===========                                  FindNextMapIndex %i", iNextCampaignMapIndex);

	return iNextCampaignMapIndex;
}