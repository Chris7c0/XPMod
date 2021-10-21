/*======================================================================================
################            C O N S O L E   C O M M A N D S             ################
======================================================================================*/

void SetupConsoleCommands()
{
    //Register custom console commands
	RegConsoleCmd("mapvote", MapVote);
	RegConsoleCmd("mapvotes", DisplayCurrentVotes);
}

//Command that a player can use to vote/revote for a map/campaign
Action MapVote(int iClient, int args)
{
	if(g_bVotingEnabled == false)
	{
		PrintToChat(iClient, "\x03[ACS] \x05Voting has been disabled on this server.");
		return;
	}
	
	if(OnFinaleOrScavengeOrSurvivalMap() == false)
	{
		PrintToChat(iClient, "\x03[ACS] \x05Voting is only enabled on a Scavenge or finale map.");
		return;
	}
	
	//Open the vote menu for the client if they arent using the server console
	if(iClient < 1)
		PrintToServer("You cannot vote for a map from the server console, use the in-game chat");
	else
		VoteMenuDraw(iClient);
}

//Command that a player can use to see the total votes for all maps/campaigns
Action DisplayCurrentVotes(int iClient, int args)
{
	if(g_bVotingEnabled == false)
	{
		PrintToChat(iClient, "\x03[ACS] \x05Voting has been disabled on this server.");
		return;
	}
	
	if(OnFinaleOrScavengeOrSurvivalMap() == false)
	{
		PrintToChat(iClient, "\x03[ACS] \x05Voting is only enabled on a Scavenge or finale map.");
		return;
	}
	
	int iPlayer, iMap, iNumberOfMaps;
	
	//Get the total number of maps for the current game mode
	if(g_iGameMode == GAMEMODE_SCAVENGE)
		iNumberOfMaps = NUMBER_OF_SCAVENGE_MAPS;
	else
		iNumberOfMaps = NUMBER_OF_CAMPAIGNS;
		
	//Display to the client the current winning map
	if(g_iWinningMapIndex != -1)
	{
		if(g_iGameMode == GAMEMODE_SCAVENGE)
			PrintToChat(iClient, "\x03[ACS] \x05Currently winning the vote: \x04%s", g_strScavengeMapName[g_iWinningMapIndex]);
		else
			PrintToChat(iClient, "\x03[ACS] \x05Currently winning the vote: \x04%s", g_strCampaignName[g_iWinningMapIndex]);
	}
	else
		PrintToChat(iClient, "\x03[ACS] \x05No one has voted yet.");
	
	//Loop through all maps and display the ones that have votes
	int[] iMapVotes = new int[iNumberOfMaps];
	
	for(iMap = 0; iMap < iNumberOfMaps; iMap++)
	{
		iMapVotes[iMap] = 0;
		
		//Tally votes for the current map
		for(iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
			if(g_iClientVote[iPlayer] == iMap)
				iMapVotes[iMap]++;
		
		//Display this particular map and its amount of votes it has to the client
		if(iMapVotes[iMap] > 0)
		{
			if(g_iGameMode == GAMEMODE_SCAVENGE)
				PrintToChat(iClient, "\x04          %s: \x05%d votes", g_strScavengeMapName[iMap], iMapVotes[iMap]);
			else
				PrintToChat(iClient, "\x04          %s: \x05%d votes", g_strCampaignName[iMap], iMapVotes[iMap]);
		}
	}
}