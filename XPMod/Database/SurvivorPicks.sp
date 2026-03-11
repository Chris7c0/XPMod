void SQLSaveSurvivorPickCallback(Handle owner, Handle hQuery, const char[] error, int iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}

	if(!StrEqual("", error))
		LogError("SQL Error saving survivor pick: %s", error);
}

void SaveSurvivorPick(int iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
		return;

	if (RunClientChecks(iClient) == false)
		return;

	// Only record picks for players at level 30 or above
	if (g_iClientLevel[iClient] < 30)
		return;

	// Get Steam Auth ID
	char strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
		return;

	char strQuery[256];
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (steam_id, survivor_id) VALUES ('%s', %i)",
		DB_TABLENAME_SURVIVOR_PICKS, strSteamID, g_iChosenSurvivor[iClient]);

	SQL_TQuery(g_hDatabase, SQLSaveSurvivorPickCallback, strQuery, iClient);
}
