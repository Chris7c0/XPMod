/*======================================================================================
#################             A C S   C H A N G E   M A P              #################
======================================================================================*/

//Check to see if the current map is a finale, and if so, switch to the next campaign
void CheckMapForChange()
{
	char strCurrentMap[32];
	GetCurrentMap(strCurrentMap,32);					//Get the current map from the game
	
	for(int iMapIndex = 0; iMapIndex < NUMBER_OF_CAMPAIGNS; iMapIndex++)
	{
		if(StrEqual(strCurrentMap, g_strCampaignLastMap[iMapIndex], false) == true)
		{
			//Check to see if someone voted for a campaign, if so, then change to the winning campaign
			if(g_bVotingEnabled == true && g_iWinningMapVotes > 0 && g_iWinningMapIndex >= 0)
			{
				if(IsMapValid(g_strCampaignFirstMap[g_iWinningMapIndex]) == true)
				{
					PrintToChatAll("\x03[ACS] \x05Switching campaign to the vote winner: \x04%s", g_strCampaignName[g_iWinningMapIndex]);
					
					if(g_iGameMode == GAMEMODE_VERSUS)
						CreateTimer(WAIT_TIME_BEFORE_SWITCH_VERSUS, Timer_ChangeCampaign, g_iWinningMapIndex);
					else if(g_iGameMode == GAMEMODE_COOP)
						CreateTimer(WAIT_TIME_BEFORE_SWITCH_COOP, Timer_ChangeCampaign, g_iWinningMapIndex);
					
					return;
				}
				else
					LogError("Error: %s is an invalid map name, attempting normal map rotation.", g_strCampaignFirstMap[g_iWinningMapIndex]);
			}
			
			//If no map was chosen in the vote, then go with the automatic map rotation
			int iNextCampaignMapIndex = iMapIndex + 1;	// Get the next campaign map index
			if(iMapIndex == NUMBER_OF_CAMPAIGNS - 1)	// Check to see if its the end of the array
				iNextCampaignMapIndex = 0;				// If so, set it to the first map index
				
			if(IsMapValid(g_strCampaignFirstMap[iNextCampaignMapIndex]) == true)
			{
				PrintToChatAll("\x03[ACS] \x05Switching campaign to \x04%s", g_strCampaignName[iNextCampaignMapIndex]);
				
				if(g_iGameMode == GAMEMODE_VERSUS)
					CreateTimer(WAIT_TIME_BEFORE_SWITCH_VERSUS, Timer_ChangeCampaign, iNextCampaignMapIndex);
				else if(g_iGameMode == GAMEMODE_COOP)
					CreateTimer(WAIT_TIME_BEFORE_SWITCH_COOP, Timer_ChangeCampaign, iNextCampaignMapIndex);
			}
			else
				LogError("Error: %s is an invalid map name, unable to switch map.", g_strCampaignFirstMap[iNextCampaignMapIndex]);
			
			return;
		}
	}
}

//Change to the next scavenge map
void ChangeScavengeMap()
{
	//Check to see if someone voted for a map, if so, then change to the winning map
	if(g_bVotingEnabled == true && g_iWinningMapVotes > 0 && g_iWinningMapIndex >= 0)
	{
		if(IsMapValid(g_strScavengeMap[g_iWinningMapIndex]) == true)
		{
			PrintToChatAll("\x03[ACS] \x05Switching map to the vote winner: \x04%s", g_strScavengeMapName[g_iWinningMapIndex]);
			
			CreateTimer(WAIT_TIME_BEFORE_SWITCH_SCAVENGE, Timer_ChangeScavengeMap, g_iWinningMapIndex);
			
			return;
		}
		else
			LogError("Error: %s is an invalid map name, attempting normal map rotation.", g_strScavengeMap[g_iWinningMapIndex]);
	}
	
	//If no map was chosen in the vote, then go with the automatic map rotation
	
	char strCurrentMap[32];
	GetCurrentMap(strCurrentMap, 32);					//Get the current map from the game
	
	//Go through all maps and to find which map index it is on, and then switch to the next map
	for(int iMapIndex = 0; iMapIndex < NUMBER_OF_SCAVENGE_MAPS; iMapIndex++)
	{
		if(StrEqual(strCurrentMap, g_strScavengeMap[iMapIndex]) == true)
		{
			int iNextCampaignMapIndex = iMapIndex + 1;		// Get the next campaign map index
			if(iMapIndex == NUMBER_OF_SCAVENGE_MAPS - 1)	// Check to see if its the end of the array
				iNextCampaignMapIndex = 0;					// If so, set it to the first map index
			
			//Make sure the map is valid before changing and displaying the message
			if(IsMapValid(g_strScavengeMap[iNextCampaignMapIndex]) == true)
			{
				PrintToChatAll("\x03[ACS] \x05Switching map to \x04%s", g_strScavengeMapName[iNextCampaignMapIndex]);
				
				CreateTimer(WAIT_TIME_BEFORE_SWITCH_SCAVENGE, Timer_ChangeScavengeMap, iNextCampaignMapIndex);
			}
			else
				LogError("Error: %s is an invalid map name, unable to switch map.", g_strScavengeMap[iNextCampaignMapIndex]);
			
			return;
		}
	}
}

void ChangeSurvivalMap()
{
	//Check to see if someone voted for a map, if so, then change to the winning map
	if(g_bVotingEnabled == true && g_iWinningMapVotes > 0 && g_iWinningMapIndex >= 0)
	{
		if(IsMapValid(g_strSurvivalMap[g_iWinningMapIndex]) == true)
		{
			PrintToChatAll("\x03[ACS] \x05Switching map to the vote winner: \x04%s", g_strSurvivalMapName[g_iWinningMapIndex]);
			
			CreateTimer(WAIT_TIME_BEFORE_SWITCH_SCAVENGE, Timer_ChangeScavengeMap, g_iWinningMapIndex);
			
			return;
		}
		else
			LogError("Error: %s is an invalid map name, attempting normal map rotation.", g_strSurvivalMap[g_iWinningMapIndex]);
	}
	
	//If no map was chosen in the vote, then go with the automatic map rotation
	
	char strCurrentMap[32];
	GetCurrentMap(strCurrentMap, 32);					//Get the current map from the game
	
	//Go through all maps and to find which map index it is on, and then switch to the next map
	for(int iMapIndex = 0; iMapIndex < NUMBER_OF_SURVIVAL_MAPS; iMapIndex++)
	{
		if(StrEqual(strCurrentMap, g_strSurvivalMap[iMapIndex]) == true)
		{
			int iNextCampaignMapIndex = iMapIndex + 1;		// Get the next campaign map index
			if(iMapIndex == NUMBER_OF_SURVIVAL_MAPS - 1)	// Check to see if its the end of the array
				iNextCampaignMapIndex = 0;					// If so, set it to the first map index
			
			//Make sure the map is valid before changing and displaying the message
			if(IsMapValid(g_strSurvivalMap[iNextCampaignMapIndex]) == true)
			{
				PrintToChatAll("\x03[ACS] \x05Switching map to \x04%s", g_strSurvivalMapName[iNextCampaignMapIndex]);
				
				CreateTimer(WAIT_TIME_BEFORE_SWITCH_SURVIVAL, Timer_ChangeSurvivalMap, iNextCampaignMapIndex);
			}
			else
				LogError("Error: %s is an invalid map name, unable to switch map.", g_strSurvivalMap[iNextCampaignMapIndex]);
			
			return;
		}
	}
}

//Change campaign to its index
Action Timer_ChangeCampaign(Handle timer, int iCampaignIndex)
{
	ServerCommand("changelevel %s", g_strCampaignFirstMap[iCampaignIndex]);	//Change the campaign
	
	return Plugin_Stop;
}

//Change scavenge map to its index
Action Timer_ChangeScavengeMap(Handle timer, int iMapIndex)
{
	ServerCommand("changelevel %s", g_strScavengeMap[iMapIndex]);			//Change the map
	
	return Plugin_Stop;
}

//Change survival map to its index
Action Timer_ChangeSurvivalMap(Handle timer, int iMapIndex)
{
	ServerCommand("changelevel %s", g_strSurvivalMap[iMapIndex]);			//Change the map
	
	return Plugin_Stop;
}