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

void SQLSaveSurvivorPickCallback(Handle owner, Handle hQuery, const char[] error, int iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}

	if(!StrEqual("", error))
	{
		LogError("SQL Error saving survivor pick: %s", error);
		return;
	}

	g_iSurvivorPickRecordID[iClient] = SQL_GetInsertId(hQuery);
	g_fSurvivorPickSaveTime[iClient] = GetGameTime();
}

void SQLSaveInfectedPickCallback(Handle owner, Handle hQuery, const char[] error, int iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}

	if(!StrEqual("", error))
	{
		LogError("SQL Error saving infected pick: %s", error);
		return;
	}

	g_iInfectedPickRecordID[iClient] = SQL_GetInsertId(hQuery);
	g_fInfectedPickSaveTime[iClient] = GetGameTime();
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
	if (GetClientSteamID64(iClient, strSteamID, sizeof(strSteamID)) == false)
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

	SQL_TQuery(g_hDatabase, SQLSaveSurvivorPickCallback, strQuery, iClient);
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
	if (GetClientSteamID64(iClient, strSteamID, sizeof(strSteamID)) == false)
		return;

	// Only record once per round per steam ID
	int dummy;
	if (g_smInfectedPickSavedThisRound.GetValue(strSteamID, dummy))
		return;

	char strGameMode[20];
	GetGameModeString(strGameMode, sizeof(strGameMode));

	char strQuery[512];
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (steam_id, infected_id_1, infected_id_2, infected_id_3, server_name, game_mode, map_name) VALUES ('%s', %i, %i, %i, '%s', '%s', '%s')",
		DB_TABLENAME_INFECTED_PICKS,
		strSteamID, g_iClientInfectedClass1[iClient], g_iClientInfectedClass2[iClient], g_iClientInfectedClass3[iClient],
		g_strServerName, strGameMode, g_strCurrentMap);

	SQL_TQuery(g_hDatabase, SQLSaveInfectedPickCallback, strQuery, iClient);
	g_smInfectedPickSavedThisRound.SetValue(strSteamID, 1);
}

void SaveRoundStats(int iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
		return;

	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	// Prevent double-save on round end + disconnect
	if (g_bStatsSavedThisRound[iClient] == true)
		return;

	g_bStatsSavedThisRound[iClient] = true;

	float fGameTime = GetGameTime();
	char strQuery[512];

	// Determine round_win for each team: NULL if unknown, 1 if won, 0 if lost
	char strSurvivorRoundWin[8];
	char strInfectedRoundWin[8];
	if (g_iRoundWinnerTeam == 0)
	{
		strcopy(strSurvivorRoundWin, sizeof(strSurvivorRoundWin), "NULL");
		strcopy(strInfectedRoundWin, sizeof(strInfectedRoundWin), "NULL");
	}
	else
	{
		strcopy(strSurvivorRoundWin, sizeof(strSurvivorRoundWin), g_iRoundWinnerTeam == TEAM_SURVIVORS ? "1" : "0");
		strcopy(strInfectedRoundWin, sizeof(strInfectedRoundWin), g_iRoundWinnerTeam == TEAM_INFECTED ? "1" : "0");
	}

	if (g_iSurvivorPickRecordID[iClient] > 0)
	{
		int iSurvivorTimePlayed = 0;
		if (g_fSurvivorPickSaveTime[iClient] > 0.0)
			iSurvivorTimePlayed = RoundToFloor(fGameTime - g_fSurvivorPickSaveTime[iClient]);

		Format(strQuery, sizeof(strQuery),
			"UPDATE %s SET si_kills=%i, ci_kills=%i, headshots=%i, damage_taken=%i, friendly_fire_damage=%i, time_played=%i, round_win=%s WHERE id=%i",
			DB_TABLENAME_SURVIVOR_PICKS,
			g_iStat_ClientInfectedKilled[iClient],
			g_iStat_ClientCommonKilled[iClient],
			g_iStat_ClientCommonHeadshots[iClient],
			g_iStat_ClientDamageTakenSurvivor[iClient],
			g_iStat_ClientFriendlyFireDamage[iClient],
			iSurvivorTimePlayed,
			strSurvivorRoundWin,
			g_iSurvivorPickRecordID[iClient]);

		SQL_TQuery(g_hDatabase, SQLSaveClassPickCallback, strQuery, iClient);
	}

	if (g_iInfectedPickRecordID[iClient] > 0)
	{
		int iInfectedTimePlayed = 0;
		char strTankChosen[8];
		if (g_fInfectedPickSaveTime[iClient] > 0.0)
			iInfectedTimePlayed = RoundToFloor(fGameTime - g_fInfectedPickSaveTime[iClient]);

		if (g_bClientWasTankThisRound[iClient] == true)
			IntToString(g_iTankChosen[iClient], strTankChosen, sizeof(strTankChosen));
		else
			strcopy(strTankChosen, sizeof(strTankChosen), "NULL");

		Format(strQuery, sizeof(strQuery),
			"UPDATE %s SET survivor_kills=%i, survivor_incaps=%i, damage_smoker=%i, damage_boomer=%i, damage_hunter=%i, damage_spitter=%i, damage_jockey=%i, damage_charger=%i, damage_tank=%i, tank_chosen=%s, damage_taken=%i, time_played=%i, round_win=%s WHERE id=%i",
			DB_TABLENAME_INFECTED_PICKS,
			g_iStat_ClientSurvivorsKilled[iClient],
			g_iStat_ClientSurvivorsIncaps[iClient],
			g_iStat_ClientDamageSmoker[iClient],
			g_iStat_ClientDamageBoomer[iClient],
			g_iStat_ClientDamageHunter[iClient],
			g_iStat_ClientDamageSpitter[iClient],
			g_iStat_ClientDamageJockey[iClient],
			g_iStat_ClientDamageCharger[iClient],
			g_iStat_ClientDamageTank[iClient],
			strTankChosen,
			g_iStat_ClientDamageTakenInfected[iClient],
			iInfectedTimePlayed,
			strInfectedRoundWin,
			g_iInfectedPickRecordID[iClient]);

		SQL_TQuery(g_hDatabase, SQLSaveClassPickCallback, strQuery, iClient);
	}
}
