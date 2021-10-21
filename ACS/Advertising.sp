/*======================================================================================
#################            A C S   A D V E R T I S I N G             #################
======================================================================================*/

Action Timer_AdvertiseNextMap(Handle timer)
{
	//Display the ACS next map advertisement to everyone
	if(g_iNextMapAdDisplayMode != DISPLAY_MODE_DISABLED)
		DisplayNextMapToAll();
	
	return Plugin_Continue;
}

void DisplayNextMapToAll()
{
	//If there is a winner to the vote display the winner if not display the next map in rotation
	if(g_iWinningMapIndex >= 0)
	{
		if(g_iNextMapAdDisplayMode == DISPLAY_MODE_HINT)
		{
			//Display the map that is currently winning the vote to all the players using hint text
			if(g_iGameMode == GAMEMODE_SCAVENGE)
				PrintHintTextToAll("The next map is currently %s", g_strScavengeMapName[g_iWinningMapIndex]);
			else
				PrintHintTextToAll("The next campaign is currently %s", g_strCampaignName[g_iWinningMapIndex]);
		}
		else if(g_iNextMapAdDisplayMode == DISPLAY_MODE_CHAT)
		{
			//Display the map that is currently winning the vote to all the players using chat text
			if(g_iGameMode == GAMEMODE_SCAVENGE)
				PrintToChatAll("\x03[ACS] \x05The next map is currently \x04%s", g_strScavengeMapName[g_iWinningMapIndex]);
			else
				PrintToChatAll("\x03[ACS] \x05The next campaign is currently \x04%s", g_strCampaignName[g_iWinningMapIndex]);
		}
	}
	else
	{
		char strCurrentMap[32];
		GetCurrentMap(strCurrentMap, 32);					//Get the current map from the game
		
		if(g_iGameMode == GAMEMODE_SCAVENGE)
		{
			//Go through all maps and to find which map index it is on, and then switch to the next map
			for(int iMapIndex = 0; iMapIndex < NUMBER_OF_SCAVENGE_MAPS; iMapIndex++)
			{
				if(StrEqual(strCurrentMap, g_strScavengeMap[iMapIndex]) == true)
				{
					int iNextCampaignMapIndex = iMapIndex + 1;		// Set to the next upcoming map index item
					if(iMapIndex == NUMBER_OF_SCAVENGE_MAPS - 1)	// Check to see if its the end of the array
						iNextCampaignMapIndex = 0;					// If so, then set the map index to the first one
					
					//Display the next map in the rotation in the appropriate way
					if(g_iNextMapAdDisplayMode == DISPLAY_MODE_HINT)
						PrintHintTextToAll("The next map is currently %s", g_strScavengeMapName[iNextCampaignMapIndex]);
					else if(g_iNextMapAdDisplayMode == DISPLAY_MODE_CHAT)
						PrintToChatAll("\x03[ACS] \x05The next map is currently \x04%s", g_strScavengeMapName[iNextCampaignMapIndex]);
				}
			}
		}
		else
		{
			//Go through all maps and to find which map index it is on, and then switch to the next map
			for(int iMapIndex = 0; iMapIndex < NUMBER_OF_CAMPAIGNS; iMapIndex++)
			{
				if(StrEqual(strCurrentMap, g_strCampaignLastMap[iMapIndex], false) == true)
				{
					int iNextCampaignMapIndex = iMapIndex + 1;	// Set to the next upcoming map index item
					if(iMapIndex == NUMBER_OF_CAMPAIGNS - 1)	// Check to see if its the end of the array
						iNextCampaignMapIndex = 0;				// If so, then set the map index to the first one
					
					//Display the next map in the rotation in the appropriate way
					if(g_iNextMapAdDisplayMode == DISPLAY_MODE_HINT)
						PrintHintTextToAll("The next campaign is currently %s", g_strCampaignName[iNextCampaignMapIndex]);
					else if(g_iNextMapAdDisplayMode == DISPLAY_MODE_CHAT)
						PrintToChatAll("\x03[ACS] \x05The next campaign is currently \x04%s", g_strCampaignName[iNextCampaignMapIndex]);
				}
			}
		}
	}
}