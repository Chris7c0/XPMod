void SQLSaveClassPickCallback(Handle owner, Handle hQuery, const char[] error, int iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}

	if(!StrEqual("", error))
		LogError("SQL Error saving class pick: %s", error);
}

void GetGameModeString(char[] strGameMode, int maxLength)
{
	GetConVarString(FindConVar("mp_gamemode"), strGameMode, maxLength);
}

void SaveSurvivorPick(int iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
		return;

	if (RunClientChecks(iClient) == false)
		return;

	// Only record picks for players at level 30 or above on the survivor team
	if (g_iClientLevel[iClient] < 30)
		return;

	if (GetClientTeam(iClient) != TEAM_SURVIVORS)
		return;

	// Get Steam Auth ID
	char strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
		return;

	// Only record once per round per steam ID
	int dummy;
	if (g_smSurvivorPickSavedThisRound.GetValue(strSteamID, dummy))
		return;

	char strGameMode[20];
	GetGameModeString(strGameMode, sizeof(strGameMode));

	char strQuery[512];
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (steam_id, survivor_id, server_name, game_mode, map_name) VALUES ('%s', %i, '%s', '%s', '%s')",
		DB_TABLENAME_SURVIVOR_PICKS, strSteamID, g_iChosenSurvivor[iClient],
		g_strServerName, strGameMode, g_strCurrentMap);

	SQL_TQuery(g_hDatabase, SQLSaveClassPickCallback, strQuery, iClient);
	g_smSurvivorPickSavedThisRound.SetValue(strSteamID, 1);
}

void SaveInfectedPick(int iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
		return;

	if (RunClientChecks(iClient) == false)
		return;

	// Only record picks for players at level 30 or above on the infected team
	if (g_iClientLevel[iClient] < 30)
		return;

	if (GetClientTeam(iClient) != TEAM_INFECTED)
		return;

	// Get Steam Auth ID
	char strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
		return;

	// Only record once per round per steam ID
	int dummy;
	if (g_smInfectedPickSavedThisRound.GetValue(strSteamID, dummy))
		return;

	char strGameMode[20];
	GetGameModeString(strGameMode, sizeof(strGameMode));

	char strQuery[512];
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (steam_id, infected_id, server_name, game_mode, map_name) VALUES ('%s', %i, '%s', '%s', '%s'), ('%s', %i, '%s', '%s', '%s'), ('%s', %i, '%s', '%s', '%s')",
		DB_TABLENAME_INFECTED_PICKS,
		strSteamID, g_iClientInfectedClass1[iClient], g_strServerName, strGameMode, g_strCurrentMap,
		strSteamID, g_iClientInfectedClass2[iClient], g_strServerName, strGameMode, g_strCurrentMap,
		strSteamID, g_iClientInfectedClass3[iClient], g_strServerName, strGameMode, g_strCurrentMap);

	SQL_TQuery(g_hDatabase, SQLSaveClassPickCallback, strQuery, iClient);
	g_smInfectedPickSavedThisRound.SetValue(strSteamID, 1);
}
