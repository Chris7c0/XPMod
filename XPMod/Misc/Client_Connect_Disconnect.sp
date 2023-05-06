void HandleAnyConnectedUsers()
{
	for (int iClient=1; iClient <= MaxClients; iClient++)
		HandleClientConnect(iClient);
}

void HandleClientConnect(int iClient)
{
	if (RunClientChecks(iClient) == false)
		return;

	g_iClientTeam[iClient] = GetClientTeam(iClient);
	
	if (IsFakeClient(iClient) == true)
	{
		// PrintToChatAll("FAKE CLIENT: %i: %N", iClient, iClient);
		// PrintToServer("FAKE CLIENT: %i: %N", iClient, iClient);
		if(g_bClientLoggedIn[iClient] == true)
			Logout(iClient);
		return;
	}
	
	decl String:clientname[128];
	new bool:match = true;
	GetClientName(iClient, clientname, sizeof(clientname));

	// Fill in special characters with ?...to prevent errors..I guess?
	for(new l=0; l<22; l++)
	{
		if(clientname[l] != '\0')
		{
			if((clientname[l] < 1) || (clientname[l] > 127))
				clientname[l] = '?';
		}
		else
			break;
	}

	//Check if is the same as before
	if(clientidname[iClient][0] == clientname[0])
	{
		new l = 0;
		while((clientname[l]!='\0' || clientidname[iClient][l]!='\0') && (l < 22))
		{
			//PrintToChatAll("checking %c, %d = %c, %d", clientidname[iClient][l], clientidname[iClient][l], clientname[l], clientname[l]);
			if(clientidname[iClient][l] != clientname[l])
			{
				match = false;
				//PrintToConsole(iClient, "==========================Does not match");
			}
			l++;
		}
	}
	else 
		match = false;
		
	//if not the same as before logout/reset loudout and set the new clientname
	if(match==false)
	{
		// PrintToChatAll("Masmatch Name: %i: %N", iClient, iClient);
		// PrintToServer("Masmatch Name: %i: %N", iClient, iClient);
		Logout(iClient);
		g_bClientSpectating[iClient] = false;
		g_iAutoSetCountDown[iClient] = -1;
		g_bSurvivorTalentsGivenThisRound[iClient] = false;

		//ClientCommand(iClient, "bind ` toggleconsole");
		//ClientCommand(iClient, "con_enable 1");

		GetClientName(iClient, clientname, sizeof(clientname));
		for(new l=0; l<23; l++)
		{
			clientidname[iClient][l] = '\0';
		}
		for(new l=0; l<22; l++)
		{
			if(clientname[l] != '\0')
			{
				clientidname[iClient][l] = clientname[l];
				if((clientidname[iClient][l] < 1) || (clientidname[iClient][l] > 127))
					clientidname[iClient][l] = '?';
				//PrintToChatAll("l = %d   adding %c (%d)", l, clientname[l], clientname[l]);
				//PrintToChatAll("l = %d          %c (%d)", l, clientidname[iClient][l], clientidname[iClient][l]);
			}
			else
			{
				//clientidname[iClient][l] = '\0';
				//for(new i=0; i<22; i++)
				//{
				//	if(clientname[i] != '\0')
				//		PrintToChatAll("Client id name = %s", clientidname[iClient][i]);
				//	else break;
				//}
				break;
			}
		}
		//PrintToChatAll("PCONNECT FULL: %d: Clientname %s stored in database", iClient, clientname);
		//PrintToChatAll("\x03%N \x04has connected", iClient);

		SQLCheckIfUserIsInBanList(iClient);
		GetUserIDAndToken(iClient);

		// Set the AFK last button press time
		g_fLastPlayerLastButtonPressTime[iClient] =  GetGameTime();
	}
	else	//They were already in game
	{
		if(g_bClientSpectating[iClient] == true)
			CreateTimer(0.1, TimerChangeSpectator, iClient, TIMER_FLAG_NO_MAPCHANGE);
		//PrintToChatAll("PCONNECT FULL: %d: %s already in database", iClient, clientname);
	}

	

	// Close menu panel in case it was glitched out
	ClosePanel(iClient);
}

void HandleClientDisconnect(int iClient)
{
	if(iClient	< 1)
		return;
	
	// Reset the AFK last button press
	g_fLastPlayerLastButtonPressTime[iClient] =  0.0;

	g_bClientSpectating[iClient] = false;
	g_bSurvivorTalentsGivenThisRound[iClient] = false;

	if(IsFakeClient(iClient)==true)
	{
		// PrintToChatAll("Player Disconnect: %i: %N", iClient, iClient);
		// PrintToServer("Player Disconnect: %i: %N", iClient, iClient);
		
		if(g_bClientLoggedIn[iClient] == true)
			Logout(iClient);

		return;
	}

	SaveUserData(iClient);

	StorePlayerInDisconnectedPlayerList(iClient);

	for(new l=0; l<23; l++)
	{
		clientidname[iClient][l] = '\0';	//WAS clientidname[iClient][l] = 9999;
	}
	DeleteAllClientParticles(iClient);
	g_bClientLoggedIn[iClient] = false;
	g_iDBUserID[iClient] = -1;
	g_strDBUserToken[iClient] = "";
	g_iAutoSetCountDown[iClient] = -1;
	ResetAll(iClient);
	//PrintToChatAll("\x03%N \x04has disconnected", iClient);
	//Reset the arry for the player
	if(g_bDoesClientAttackFast[iClient] == true)
	{
		//PrintToChatAll("PLAYER DISCONNECTED! Removing from array iClient = %N(%d)", iClient, iClient);
		pop(iClient);
		testtoggle[iClient] = false;
	}
}

void StorePlayerInDisconnectedPlayerList(iClient)
{
	// Get Steam Auth ID, if this returns false, then do not proceed
	char strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
		return;

	// // Check if the steamid already exists in the disconnected player list
	int existingIndex = FindIndexInStringArrayUsingValue(
		g_strDisconnectedConnectedPlayerSteamID, 
		g_iDisconnectedPlayerCnt,
		strSteamID);
	
	// Choose the stopping point at the end if the value was not found, otherwise chose the location of the value to replace
	int iStoppingPoint = existingIndex >= 0 ? existingIndex : g_iDisconnectedPlayerCnt;

	// Shift the array of strings to make room for the new value at slot 0
	ShiftArrayOfStrings(g_strDisconnectedConnectedPlayerNames, 
		sizeof(g_strDisconnectedConnectedPlayerNames[]), 0, iStoppingPoint)
	ShiftArrayOfStrings(g_strDisconnectedConnectedPlayerSteamID, 
		sizeof(g_strDisconnectedConnectedPlayerSteamID[]), 0, iStoppingPoint)
	
	// Set the new player at the first item in the list
	Format(g_strDisconnectedConnectedPlayerNames[0], 
		sizeof(g_strDisconnectedConnectedPlayerNames[]),
		"%N", iClient);
	Format(g_strDisconnectedConnectedPlayerSteamID[0], 
		sizeof(g_strDisconnectedConnectedPlayerSteamID[]),
		"%s", strSteamID);
	
	// Increment the size of the array (note that array is fixed to size of DISCONNECTED_PLAYER_STORAGE_COUNT)
	if (existingIndex == -1)
		g_iDisconnectedPlayerCnt = g_iDisconnectedPlayerCnt >= DISCONNECTED_PLAYER_STORAGE_COUNT ? DISCONNECTED_PLAYER_STORAGE_COUNT : g_iDisconnectedPlayerCnt + 1;
	
	// // Print for debugging
	// PrintToServer("\n----------------------------------------");
	// PrintToServer("Existing index: %i", existingIndex);
	// for (int i = 0; i < DISCONNECTED_PLAYER_STORAGE_COUNT; i++)
	// {
	// 	PrintToServer("%i: %s, %s", i, 
	// 		g_strDisconnectedConnectedPlayerNames[i], 
	// 		g_strDisconnectedConnectedPlayerSteamID[i]);
	// }
	// PrintToServer("----------------------------------------\n ");
}

void LoopThroughAllPlayersAndHandleAFKPlayers()
{
	for(new iClient = 1;iClient <= MaxClients; iClient++)
	{
		if (RunClientChecks(iClient) == false ||
			IsFakeClient(iClient) == true ||
			GetClientTeam(iClient)==TEAM_SPECTATORS ||
			g_fLastPlayerLastButtonPressTime[iClient] == 0.0)
			continue;

		float fAFKTime = GetGameTime() - g_fLastPlayerLastButtonPressTime[iClient];

		if (fAFKTime >= AFK_IDLE_PLAYER_KICK_WARNING_START_TIME)
		{
			PrintToChat(iClient, "\x04You appear AFK. Move or be kicked in %0.0f seconds!", AFK_IDLE_PLAYER_KICK_TIME - fAFKTime);
		}

		if (fAFKTime >= AFK_IDLE_PLAYER_KICK_TIME)
			KickClient(iClient, "You were kicked for being AFK");
	}
}

void LoopThroughAllPlayersAndSetAFKRecordingTime(bool bStopRecording=false)
{
	float fCurrentGameTime = GetGameTime();

	for(new iClient = 1;iClient <= MaxClients; iClient++)
	{
		if (RunClientChecks(iClient) == false ||
			IsFakeClient(iClient) == true ||
			GetClientTeam(iClient) == TEAM_SPECTATORS)
			continue;
		
		g_fLastPlayerLastButtonPressTime[iClient] = bStopRecording == false ? fCurrentGameTime : 0.0;
	}
}