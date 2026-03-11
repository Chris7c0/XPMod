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

	char strQuery[256];
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (steam_id, survivor_id) VALUES ('%s', %i)",
		DB_TABLENAME_SURVIVOR_PICKS, strSteamID, g_iChosenSurvivor[iClient]);

	SQL_TQuery(g_hDatabase, SQLSaveClassPickCallback, strQuery, iClient);
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

	char strQuery[512];
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (steam_id, infected_id) VALUES ('%s', %i), ('%s', %i), ('%s', %i)",
		DB_TABLENAME_INFECTED_PICKS,
		strSteamID, g_iClientInfectedClass1[iClient],
		strSteamID, g_iClientInfectedClass2[iClient],
		strSteamID, g_iClientInfectedClass3[iClient]);

	SQL_TQuery(g_hDatabase, SQLSaveClassPickCallback, strQuery, iClient);
}
