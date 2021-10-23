
/*======================================================================================
#################              F I N D   G A M E   M O D E             #################
======================================================================================*/

//Find the current Game Mode and store it into this plugin
void FindGameMode()
{
	//Get the gamemode string from the game
	char strGameMode[20];
	GetConVarString(FindConVar("mp_gamemode"), strGameMode, sizeof(strGameMode));
	
	//Set the global gamemode int for this plugin
	if(StrEqual(strGameMode, "coop"))
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "realism"))
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode,"versus"))
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "teamversus"))
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "scavenge"))
		g_iGameMode = GAMEMODE_SCAVENGE;
	else if(StrEqual(strGameMode, "teamscavenge"))
		g_iGameMode = GAMEMODE_SCAVENGE;
	else if(StrEqual(strGameMode, "survival"))
		g_iGameMode = GAMEMODE_SURVIVAL;
	else if(StrEqual(strGameMode, "mutation1"))		//Last Man On Earth
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation2"))		//Headshot!
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation3"))		//Bleed Out
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation4"))		//Hard Eight
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation5"))		//Four Swordsmen
		g_iGameMode = GAMEMODE_COOP;
	//else if(StrEqual(strGameMode, "mutation6"))	//Nothing here
	//	g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation7"))		//Chainsaw Massacre
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation8"))		//Ironman
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation9"))		//Last Gnome On Earth
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation10"))	//Room For One
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation11"))	//Healthpackalypse!
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "mutation12"))	//Realism Versus
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "mutation13"))	//Follow the Liter
		g_iGameMode = GAMEMODE_SCAVENGE;
	else if(StrEqual(strGameMode, "mutation14"))	//Gib Fest
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation15"))	//Versus Survival
		g_iGameMode = GAMEMODE_VERSUS_SURVIVAL;
	else if(StrEqual(strGameMode, "mutation16"))	//Hunting Party
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation17"))	//Lone Gunman
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation18"))	//Bleed Out Versus
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "mutation19"))	//Taaannnkk!
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "mutation20"))	//Healing Gnome
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "community1"))	//Special Delivery
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "community2"))	//Flu Season
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "community3"))	//Riding My Survivor
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "community4"))	//Nightmare
		g_iGameMode = GAMEMODE_SURVIVAL;
	else if(StrEqual(strGameMode, "community5"))	//Death's Door
		g_iGameMode = GAMEMODE_COOP;
	else
		g_iGameMode = GAMEMODE_UNKNOWN;
}

bool IsGameModeValid(int iGameMode)
{
	if (iGameMode != GAMEMODE_UNKNOWN)
		return true;
	
	LogError("ACS Error: Invalid Game Mode!");
	return false;
}

int GetMapListArraySizeForGameMode(int iGameMode)
{
	switch(iGameMode)
	{
		case GAMEMODE_COOP:				return sizeof(g_strCampaignLastMap);
		case GAMEMODE_VERSUS:			return sizeof(g_strCampaignLastMap);
		case GAMEMODE_SCAVENGE:			return sizeof(g_strScavengeMap);
		case GAMEMODE_SURVIVAL:			return sizeof(g_strSurvivalMap);
		case GAMEMODE_VERSUS_SURVIVAL:	return sizeof(g_strSurvivalMap);
	}

	return 0;
}

//Check if the current map is the last in the campaign if not in the Scavenge game mode
bool OnFinaleOrScavengeOrSurvivalMap()
{
	if (g_iGameMode == GAMEMODE_SCAVENGE ||
		g_iGameMode == GAMEMODE_SURVIVAL ||
		g_iGameMode == GAMEMODE_VERSUS_SURVIVAL)
		return true;
	
	char strCurrentMap[32];
	GetCurrentMap(strCurrentMap,32);			//Get the current map from the game
	
	//Run through all the maps, if the current map is a last campaign map, return true
	for(int iMapIndex = 0; iMapIndex < NUMBER_OF_CAMPAIGNS; iMapIndex++)
		if(StrEqual(strCurrentMap, g_strCampaignLastMap[iMapIndex], false) == true)
			return true;
	
	return false;
}

bool IsMapIndexValid(int iMapIndex)
{
	bool bIsMapValid = false;
	switch(g_iGameMode)
	{
		case GAMEMODE_COOP:				bIsMapValid = IsMapValid(g_strCampaignLastMap[iMapIndex]);
		case GAMEMODE_VERSUS:			bIsMapValid = IsMapValid(g_strCampaignLastMap[iMapIndex]);
		case GAMEMODE_SCAVENGE:			bIsMapValid = IsMapValid(g_strScavengeMap[iMapIndex]);
		case GAMEMODE_SURVIVAL:			bIsMapValid = IsMapValid(g_strSurvivalMap[iMapIndex]);
		case GAMEMODE_VERSUS_SURVIVAL:	bIsMapValid = IsMapValid(g_strSurvivalMap[iMapIndex]);
	}

	if (bIsMapValid == false)
		LogError("ACS Error: %i is an invalid map index!", iMapIndex);

	return bIsMapValid;
}

int IncrementRoundEndCounter()
{
	if (g_bCanIncrementRoundEndCounter == false)
		return g_iRoundEndCounter;
	
	g_bCanIncrementRoundEndCounter = false;
	CreateTimer(REALLOW_ROUND_END_INCREMENT_DELAY, TimerResetCanIncrementRoundEndCounter, _, TIMER_FLAG_NO_MAPCHANGE);
	
	PrintToServer("======================== INCREMENTING g_iRoundEndCounter: %i", g_iRoundEndCounter + 1);

	return ++g_iRoundEndCounter;
}

// This is required because the RoundEnd can fire multiple times
Action TimerResetCanIncrementRoundEndCounter(Handle timer, int iData)
{
	g_bCanIncrementRoundEndCounter = true;

	return Plugin_Stop;
}