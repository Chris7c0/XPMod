/*======================================================================================
#################             A C S   C H A N G E   M A P              #################
======================================================================================*/

void ChangeMapIfNeeded()
{
	if (IsGameModeValid(g_iGameMode) == false)
		return;
	
	// This is required because the Events can fire multiple times
	g_bStopACSChangeMap = true;
	CreateTimer(REALLOW_ACS_MAP_CHANGE_DELAY, TimerResetCanACSChangeMap);

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
	ServerCommand("changelevel %s", g_strMapListArray[iMapIndex][MAP_LIST_COLUMN_MAP_NAME_START]);

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
	if (g_iMapsIndexStartForCurrentGameMode == -1)
		return -1;

	char strCurrentMap[32];
	GetCurrentMap(strCurrentMap, 32);	//Get the current map from the game

	//Go through all maps and to find which map index it is on
	for(int iMapIndex = g_iMapsIndexStartForCurrentGameMode; iMapIndex <= g_iMapsIndexEndForCurrentGameMode; iMapIndex++)
		if (StrEqual(g_strMapListArray[iMapIndex][MAP_LIST_COLUMN_MAP_NAME_END], strCurrentMap, false) == true)
			return iMapIndex;

	return -1;
}

int FindNextMapIndex()
{
	int iCurrentMapIndex = FindCurrentMapIndex();
	if (iCurrentMapIndex == -1)
		return -1;

	PrintToServer("               ===========                                  FindCurrentMapIndex %i", iCurrentMapIndex);

	int iNextCampaignMapIndex = iCurrentMapIndex + 1;				// Get the next campaign map index
	if (iNextCampaignMapIndex > g_iMapsIndexEndForCurrentGameMode)	// Check to see if its the end of the array. If so,
		iNextCampaignMapIndex = 0;									// set it to the first map index fro the game mode

	PrintToServer("               ===========                                  FindNextMapIndex %i", iNextCampaignMapIndex);

	return iNextCampaignMapIndex;
}