/*======================================================================================
#################                     E V E N T S                      #################
======================================================================================*/

void SetUpEvents()
{
    //Hook the game events
	HookEvent("player_left_start_area", Event_PlayerLeftStartArea);
	// HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("finale_win", Event_FinaleWin);
	// HookEvent("scavenge_match_finished", Event_ScavengeMapFinished);
	HookEvent("player_disconnect", Event_PlayerDisconnect);

	//Hook the Return to Lobby vote and Finale End return to lobby events
	HookUserMessage(GetUserMessageId("VotePass"), OnDisconnectToLobby, true);
	HookUserMessage(GetUserMessageId("DisconnectToLobby"), OnDisconnectToLobby, true);
	// https://wiki.alliedmods.net/User_messages
	HookUserMessage(GetUserMessageId("PZEndGamePanelMsg"), OnPZEndGamePanelMsg, true);
	//HookUserMessage(GetUserMessageId("VoteStart"), OnVoteStart, true);
}

public void OnMapStart()
{
	//Execute config file
	char strFileName[64];
	Format(strFileName, sizeof(strFileName), "Automatic_Campaign_Switcher_%s", PLUGIN_VERSION);
	AutoExecConfig(true, strFileName);
	
	//Set the game mode
	bool bGameModeChanged = FindGameMode();

	if (bGameModeChanged == true)
		SetCurrentMapIndexRangeForCurrentGameMode();
	
	//Precache models (This fixes missing Witch model on "The Passing")
	if(IsModelPrecached("models/infected/witch.mdl") == false)
		PrecacheModel("models/infected/witch.mdl");
	if(IsModelPrecached("models/infected/witch_bride.mdl") == false)
		PrecacheModel("models/infected/witch_bride.mdl");

	//Precache sounds
	PrecacheSound(SOUND_NEW_VOTE_START);
	PrecacheSound(SOUND_NEW_VOTE_WINNER);
	
	g_iRoundEndCounter = 0;			//Reset the round end counter on every map start
	g_bCanIncrementRoundEndCounter = true;
	g_iCoopFinaleFailureCount = 0;	//Reset the amount of Survivor failures
	g_bFinaleWon = false;			//Reset the finale won variable
	ResetAllVotes();				//Reset every player's vote
}


//Event fired when the Survivors leave the start area
public Action Event_PlayerLeftStartArea(Handle hEvent, const char[] strName, bool bDontBroadcast)
{		
	PrintToServer("*************************** Event_PlayerLeftStartArea Event triggered");

	if(g_bVotingEnabled == true && OnFinaleOrScavengeOrSurvivalMap() == true)
		CreateTimer(g_fVotingAdDelayTime, Timer_DisplayVoteAdToAll, _, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Continue;
}


// //Event fired when the Round Starts
// public Action Event_RoundStart(Handle hEvent, const char[] strName, bool bDontBroadcast)
// {
// 	PrintToServer("*************************** Event_RoundStart Event triggered");

// 	return Plugin_Continue;
// }

//Event fired when the Round Ends
public Action Event_RoundEnd(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	PrintToServer("*************************** Event_RoundEnd Event triggered");

	//Check to see if on a finale map, if so change to the next campaign after two rounds
	switch (g_iGameMode)
	{
		// case GAMEMODE_VERSUS:
		// {
		// 	if (OnFinaleOrScavengeOrSurvivalMap() == false)
		// 		return Plugin_Continue;

		// 	if(IncrementRoundEndCounter() >= 2)
		// 		ChangeMapIfNeeded();
		// }
		//If in Coop and on a finale, check to see if the survivors have lost the max amount of times
		case GAMEMODE_COOP:
		{
			if (OnFinaleOrScavengeOrSurvivalMap() == true &&
				g_iMaxCoopFinaleFailures > 0 && 
				g_bFinaleWon == false &&
				++g_iCoopFinaleFailureCount >= g_iMaxCoopFinaleFailures)
				ChangeMapIfNeeded();
		}
		case GAMEMODE_SURVIVAL:
		{
			if (IncrementRoundEndCounter() >= 2)	
				ChangeMapIfNeeded();
		}
		// case GAMEMODE_VERSUS_SURVIVAL:
		// {
		// 	// The new rounds start indefinitely until the current team does worse than the previous team.
		// 	// If no score is placed then it will just keep going until a score is placed.
		// 	// Then the next team will have a chance to beat that score. This will keep going until
		// 	// the current team does worse than the last team.
		// 	if(IncrementRoundEndCounter() >= 12)	
		// 		ChangeMapIfNeeded();
		// }
	}
	return Plugin_Continue;
}

//Event fired when a finale is won
public Action Event_FinaleWin(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	PrintToServer("*************************** Event_FinaleWin Event triggered");

	g_bFinaleWon = true;	//This is used so that the finale does not switch twice if this event
							//happens to land on a max failure count as well as this
	
	//Change to the next campaign
	if(g_iGameMode == GAMEMODE_COOP)
		ChangeMapIfNeeded();
	
	return Plugin_Continue;
}

// //Event fired when a map is finished for scavenge
// public Action Event_ScavengeMapFinished(Handle hEvent, const char[] strName, bool bDontBroadcast)
// {
// 	PrintToServer("*************************** Event_ScavengeMapFinished Event triggered");

// 	//Change to the next Scavenge map
// 	if(g_iGameMode == GAMEMODE_SCAVENGE)
// 		ChangeMapIfNeeded();
	
// 	return Plugin_Continue;
// }

// //Event fired when the Vote Starts
// public Action Event_VoteStarted(Handle hEvent, const char[] strName, bool bDontBroadcast)
// {
// 	PrintToServer("*************************** Event_VoteStarted Event triggered");

// 	int iVoterInt = GetEventInt(hEvent,"initiator");
// 	PrintToServer("*************************** iVoterInt: %i", iVoterInt);
// 	int iVoterUser  = GetClientOfUserId(GetEventInt(hEvent,"initiator"));
// 	PrintToServer("*************************** iVoterUser: %i", iVoterUser);

// 	return Plugin_Continue;
// }


//Event fired when a player disconnects from the server
public Action Event_PlayerDisconnect(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	
	if(iClient	< 1)
		return Plugin_Continue;
	
	//Reset the client's votes
	g_bClientVoted[iClient] = false;
	g_iClientVote[iClient] = -1;
	
	//Check to see if there is a new vote winner
	SetTheCurrentVoteWinner();
	
	return Plugin_Continue;
}

// This function was written by MasterMind420 preventing the Return to Lobby issue
public Action OnDisconnectToLobby(UserMsg msg_id, Handle bf, const int[] players, int playersNum, bool reliable, bool init)
{
	static bool bAllowDisconnect;

	char sBuffer[64];
	BfReadString(bf, sBuffer, sizeof(sBuffer));

	if (StrContains(sBuffer, "vote_passed_return_to_lobby") > -1)
	{
		bAllowDisconnect = true;
		return Plugin_Continue;
	}
	else if (StrContains(sBuffer, "vote_passed") > -1)
		return Plugin_Continue;

	if (bAllowDisconnect)
	{
		bAllowDisconnect = false;
		return Plugin_Continue;
	}

	return Plugin_Handled;
}

// Event
public Action OnPZEndGamePanelMsg(UserMsg msg_id, Handle bf, const int[] players, int playersNum, bool reliable, bool init)
{
	if (g_bStopACSChangeMap == true)
		return Plugin_Handled;

	char sBuffer[128];
	BfReadString(bf, sBuffer, sizeof(sBuffer));
	PrintToServer("OnPZEndGamePanelMsg ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| %s", sBuffer);

	ChangeMapIfNeeded();

	return Plugin_Handled;
}