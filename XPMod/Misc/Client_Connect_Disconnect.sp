const float AUTH_READY_RETRY_INTERVAL = 2.0;
const int AUTH_READY_MAX_RETRIES = 60;

const float AUTH_VALIDATE_RETRY_INTERVAL = 5.0;
const int AUTH_VALIDATE_MAX_RETRIES = 120; // 5s * 120 = 10 minutes

bool g_bClientAuthInitPending[MAXPLAYERS + 1];
bool g_bClientAuthInitCompleted[MAXPLAYERS + 1];
int g_iClientAuthInitRetryCount[MAXPLAYERS + 1];
bool g_bClientAuthValidationPending[MAXPLAYERS + 1];
int g_iClientAuthValidationRetryCount[MAXPLAYERS + 1];

void HandleAnyConnectedUsers()
{
	for (int iClient=1; iClient <= MaxClients; iClient++)
		HandleClientConnect(iClient);
}

void HandleClientConnect(int iClient)
{
	if (RunClientChecks(iClient) == false)
		return;

	SDKUnhook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);
	SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);
	g_fAbilityImpactDamageImmunityEndTime[iClient] = -1.0;

	g_iClientTeam[iClient] = GetClientTeam(iClient);
	
	if (IsFakeClient(iClient) == true)
	{
		if(g_bClientLoggedIn[iClient] == true)
			Logout(iClient);
		return;
	}
	
	char clientname[128];
	bool match = true;
	GetClientName(iClient, clientname, sizeof(clientname));
	strcopy(g_strClientBaseName[iClient], sizeof(g_strClientBaseName[]), clientname);

	// Fill in special characters with ?...to prevent errors..I guess?
	for (int l = 0; l<22; l++)
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
		int l = 0;
		while((clientname[l]!='\0' || clientidname[iClient][l]!='\0') && (l < 22))
		{
			if(clientidname[iClient][l] != clientname[l])
			{
				match = false;
			}
			l++;
		}
	}
	else 
		match = false;
		
	//if not the same as before logout/reset loudout and set the new clientname
	if(match==false)
	{
		g_bClientAuthInitPending[iClient] = false;
		g_bClientAuthInitCompleted[iClient] = false;
		g_iClientAuthInitRetryCount[iClient] = 0;
		g_bClientAuthValidationPending[iClient] = false;
		g_iClientAuthValidationRetryCount[iClient] = 0;

		Logout(iClient);
		ClearClientSteamID64(iClient);
		g_bClientSpectating[iClient] = false;
		g_iAutoSetCountDown[iClient] = -1;
		g_bSurvivorSpawnLoadoutGivenThisRound[iClient] = false;
		g_bConfirmedSurvivorTalentsGivenThisRound[iClient] = false;

		//ClientCommand(iClient, "bind ` toggleconsole");
		//ClientCommand(iClient, "con_enable 1");

		GetClientName(iClient, clientname, sizeof(clientname));
		for (int l = 0; l<23; l++)
		{
			clientidname[iClient][l] = '\0';
		}
		for (int l = 0; l<22; l++)
		{
			if(clientname[l] != '\0')
			{
				clientidname[iClient][l] = clientname[l];
				if((clientidname[iClient][l] < 1) || (clientidname[iClient][l] > 127))
					clientidname[iClient][l] = '?';
			}
			else
			{
				break;
			}
		}

		StartClientAuthReadyInitialization(iClient);

		// Set the AFK last button press time
		g_fLastPlayerLastButtonPressTime[iClient] =  GetGameTime();
	}
	else	//They were already in game
	{
		if(g_bClientSpectating[iClient] == true)
			CreateTimer(0.1, TimerChangeSpectator, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}

	

	// Close menu panel in case it was glitched out
	ClosePanel(iClient);
}

void HandleClientDisconnect(int iClient)
{
	if(iClient	< 1)
		return;

	bool bWasDownedSurvivor = g_iClientTeam[iClient] == TEAM_SURVIVORS &&
		(g_bIsClientDown[iClient] == true || clienthanging[iClient] == true);

	SDKUnhook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);
	g_fAbilityImpactDamageImmunityEndTime[iClient] = -1.0;
	
	// Reset the AFK last button press
	g_fLastPlayerLastButtonPressTime[iClient] =  0.0;

	g_bClientSpectating[iClient] = false;
	g_bSurvivorSpawnLoadoutGivenThisRound[iClient] = false;
	g_bConfirmedSurvivorTalentsGivenThisRound[iClient] = false;

	if(IsFakeClient(iClient)==true)
	{

		if(g_bClientLoggedIn[iClient] == true)
			Logout(iClient);

		return;
	}

	SaveRoundStats(iClient);
	SaveUserData(iClient);

	StorePlayerBindUses(iClient);
	StorePlayerInDisconnectedPlayerList(iClient);

	for (int l = 0; l<23; l++)
	{
		clientidname[iClient][l] = '\0';	//WAS clientidname[iClient][l] = 9999;
	}
	g_strClientBaseName[iClient][0] = '\0';
	DeleteAllClientParticles(iClient);
	g_bClientLoggedIn[iClient] = false;
	g_iDBUserID[iClient] = -1;
	g_strDBUserToken[iClient] = "";
	g_iAutoSetCountDown[iClient] = -1;
	g_bClientAuthInitPending[iClient] = false;
	g_bClientAuthInitCompleted[iClient] = false;
	g_iClientAuthInitRetryCount[iClient] = 0;
	g_bClientAuthValidationPending[iClient] = false;
	g_iClientAuthValidationRetryCount[iClient] = 0;
	ClearClientSteamID64(iClient);
	ResetAll(iClient);

	if (bWasDownedSurvivor && SetAllZoeyInstantInterventionDownedCount())
		SetAllZoeyInstantInterventionSpeed("A downed teammate disconnected. Instant Intervention slows to normal.");
}

void StartClientAuthReadyInitialization(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) == true ||
		g_bClientAuthInitCompleted[iClient] == true)
		return;

	// Attempt immediately first, then retry for a short period while auth validates.
	if (TryRunClientAuthReadyInitialization(iClient))
		return;

	if (g_bClientAuthInitPending[iClient] == true)
		return;

	g_bClientAuthInitPending[iClient] = true;
	g_iClientAuthInitRetryCount[iClient] = 0;
	CreateTimer(AUTH_READY_RETRY_INTERVAL, TimerRetryClientAuthReadyInitialization, GetClientUserId(iClient), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

bool TryRunClientAuthReadyInitialization(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) == true ||
		g_bClientAuthInitCompleted[iClient] == true)
		return false;

	char strSteamID[32];
	if (GetClientSteamID64(iClient, strSteamID, sizeof(strSteamID)) == false)
		return false;

	g_bClientAuthInitPending[iClient] = false;
	g_iClientAuthInitRetryCount[iClient] = 0;
	g_bClientAuthInitCompleted[iClient] = true;

	// If the Steam ID was obtained without backend validation, start background validation
	if (g_bClientSteamIDValidated[iClient] == false)
		StartBackgroundSteamIDValidation(iClient);

	RestorePlayerBindUses(iClient);
	SQLCheckIfUserIsInBanList(iClient);
	GetUserIDAndToken(iClient);
	return true;
}

Action TimerRetryClientAuthReadyInitialization(Handle hTimer, int iUserID)
{
	int iClient = GetClientOfUserId(iUserID);
	if (iClient == 0)
		return Plugin_Stop;

	if (g_bClientAuthInitPending[iClient] == false)
		return Plugin_Stop;

	if (TryRunClientAuthReadyInitialization(iClient))
		return Plugin_Stop;

	g_iClientAuthInitRetryCount[iClient]++;
	if (g_iClientAuthInitRetryCount[iClient] < AUTH_READY_MAX_RETRIES)
		return Plugin_Continue;

	g_bClientAuthInitPending[iClient] = false;
	g_iClientAuthInitRetryCount[iClient] = 0;
	KickClientCannotGetSteamID(iClient);
	return Plugin_Stop;
}

void StartBackgroundSteamIDValidation(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) == true ||
		g_bClientSteamIDValidated[iClient] == true)
		return;

	if (g_bClientAuthValidationPending[iClient] == true)
		return;

	g_bClientAuthValidationPending[iClient] = true;
	g_iClientAuthValidationRetryCount[iClient] = 0;
	CreateTimer(AUTH_VALIDATE_RETRY_INTERVAL, TimerBackgroundSteamIDValidation, GetClientUserId(iClient), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

Action TimerBackgroundSteamIDValidation(Handle hTimer, int iUserID)
{
	int iClient = GetClientOfUserId(iUserID);
	if (iClient == 0)
		return Plugin_Stop;

	if (g_bClientAuthValidationPending[iClient] == false ||
		g_bClientSteamIDValidated[iClient] == true)
		return Plugin_Stop;

	// Try to get the validated Steam ID from the backend
	char strValidatedSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strValidatedSteamID, sizeof(strValidatedSteamID)) == false)
	{
		g_iClientAuthValidationRetryCount[iClient]++;
		if (g_iClientAuthValidationRetryCount[iClient] < AUTH_VALIDATE_MAX_RETRIES)
			return Plugin_Continue;

		// Timed out after 10 minutes — log but don't kick since they've been playing
		g_bClientAuthValidationPending[iClient] = false;
		g_iClientAuthValidationRetryCount[iClient] = 0;
		LogError("Background Steam ID validation timed out for %N", iClient);
		return Plugin_Stop;
	}

	// Validation succeeded — check if it matches the cached unvalidated ID
	g_bClientAuthValidationPending[iClient] = false;
	g_iClientAuthValidationRetryCount[iClient] = 0;

	if (StrEqual(strValidatedSteamID, g_strClientSteamID64[iClient]))
	{
		// Match — mark as validated
		g_bClientSteamIDValidated[iClient] = true;
	}
	else
	{
		// Mismatch — possible ID spoof, kick the player
		LogError("Steam ID mismatch for %N: cached=%s validated=%s", iClient, g_strClientSteamID64[iClient], strValidatedSteamID);
		KickClient(iClient, "Steam ID validation failed. Please restart Steam and reconnect.");
	}

	return Plugin_Stop;
}

void StorePlayerInDisconnectedPlayerList(int iClient)
{
	// Get Steam Auth ID, if this returns false, then do not proceed
	char strSteamID[32];
	if (GetClientSteamID64(iClient, strSteamID, sizeof(strSteamID)) == false)
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
}

void StorePlayerBindUses(int iClient)
{
	char strSteamID[32];
	if (GetClientSteamID64(iClient, strSteamID, sizeof(strSteamID)) == false)
		return;

	// Check if this SteamID already has a slot
	int iSlot = -1;
	for (int i = 0; i < g_iBindTrackCount; i++)
	{
		if (StrEqual(g_strBindTrackSteamID[i], strSteamID))
		{
			iSlot = i;
			break;
		}
	}

	// If not found, allocate a new slot
	if (iSlot == -1)
	{
		if (g_iBindTrackCount >= BIND_TRACK_STORAGE_COUNT)
			return;
		iSlot = g_iBindTrackCount;
		g_iBindTrackCount++;
	}

	strcopy(g_strBindTrackSteamID[iSlot], sizeof(g_strBindTrackSteamID[]), strSteamID);
	g_iBindTrackUses1[iSlot] = g_iClientBindUses_1[iClient];
	g_iBindTrackUses2[iSlot] = g_iClientBindUses_2[iClient];
}

void RestorePlayerBindUses(int iClient)
{
	char strSteamID[32];
	if (GetClientSteamID64(iClient, strSteamID, sizeof(strSteamID)) == false)
		return;

	g_bClientBindUsesRestored[iClient] = false;

	for (int i = 0; i < g_iBindTrackCount; i++)
	{
		if (StrEqual(g_strBindTrackSteamID[i], strSteamID))
		{
			g_iClientBindUses_1[iClient] = g_iBindTrackUses1[i];
			g_iClientBindUses_2[iClient] = g_iBindTrackUses2[i];
			g_bClientBindUsesRestored[iClient] = true;

			// Remove the entry by shifting the last element into this slot
			g_iBindTrackCount--;
			if (i < g_iBindTrackCount)
			{
				strcopy(g_strBindTrackSteamID[i], sizeof(g_strBindTrackSteamID[]), g_strBindTrackSteamID[g_iBindTrackCount]);
				g_iBindTrackUses1[i] = g_iBindTrackUses1[g_iBindTrackCount];
				g_iBindTrackUses2[i] = g_iBindTrackUses2[g_iBindTrackCount];
			}
			g_strBindTrackSteamID[g_iBindTrackCount][0] = '\0';
			g_iBindTrackUses1[g_iBindTrackCount] = 0;
			g_iBindTrackUses2[g_iBindTrackCount] = 0;
			return;
		}
	}
}

void LoopThroughAllPlayersAndHandleAFKPlayers()
{
	if (g_bAFKIdleKickingEnabled == false ||
		g_bDevModeEnabled == true)
		return;

	for (int iClient = 1;iClient <= MaxClients; iClient++)
	{
		if (RunClientChecks(iClient) == false ||
			IsFakeClient(iClient) == true ||
			g_fLastPlayerLastButtonPressTime[iClient] == 0.0)
			continue;

		float fAFKTime = GetGameTime() - g_fLastPlayerLastButtonPressTime[iClient];
		if (RoundToCeil(fAFKTime) % 10 == 0 && fAFKTime >= AFK_IDLE_PLAYER_KICK_WARNING_START_TIME - 2.0)
		{
			PrintToChat(iClient, "\x04You appear AFK. Move or be kicked in %0.0f seconds!", AFK_IDLE_PLAYER_KICK_TIME - fAFKTime);
		}

		if (fAFKTime >= AFK_IDLE_PLAYER_KICK_TIME)
			KickClient(iClient, "You were kicked for being AFK");
	}
}

void LoopThroughAllPlayersAndSetAFKRecordingTime(bool bStopRecording=false)
{
	if (g_bAFKIdleKickingEnabled == false)
		return;

	float fCurrentGameTime = GetGameTime();

	for (int iClient = 1;iClient <= MaxClients; iClient++)
	{
		if (RunClientChecks(iClient) == false ||
			IsFakeClient(iClient) == true)
			continue;
		
		g_fLastPlayerLastButtonPressTime[iClient] = bStopRecording == false ? fCurrentGameTime : 0.0;
	}
}
