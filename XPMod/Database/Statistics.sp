//Callback function for SQLGetTopXPModPlayerStatistics
void SQLGetTopXPModPlayerStatisticsCallback(Handle owner, Handle hQuery, const char[] error, int empty)
{

	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	if(!StrEqual("", error))
	{
		LogError("SQL Error: %s", error);
		return;
	}

	if (SQL_MoreRows(hQuery) == false)
	{
		LogError("SQL Error no results returned for Top XPMod Player stats query");
		return;
	}

	// At least one row was returned, so clear out the old data
	g_strTopXPModPlayersStatsText = NULL_STRING;
	g_iTop10Count = 0;

	char strPlayerName[33], strXP[10], strSteamID[32];
	for (int i=0; i < 10; i++)
	{
		// Clear the steam ID slot
		g_strTop10SteamIDs[i][0] = '\0';

		// Start the new line, even if no row data for vertical alignment
		StrCat(g_strTopXPModPlayersStatsText, sizeof(g_strTopXPModPlayersStatsText), "\n");

		// Check for rows, otherwise no reason to fetch a row
		if (SQL_MoreRows(hQuery) == false)
			continue;

		// Get the data for the row
		if (SQL_FetchRow(hQuery))
		{
			// Get values from row data for this top player and append to the stats text
			if (SQL_FetchString(hQuery, 0, strPlayerName, sizeof(strPlayerName)) != 0 &&
				SQL_FetchString(hQuery, 1, strXP, sizeof(strXP)) != 0)
			{
				// Store the steam ID for leaderboard symbol lookup
				SQL_FetchString(hQuery, 2, strSteamID, sizeof(strSteamID));
				strcopy(g_strTop10SteamIDs[i], sizeof(g_strTop10SteamIDs[]), strSteamID);
				g_iTop10Count++;

				// Format and add row data
				char strRowData[60];
				Format(strRowData, sizeof(strRowData), "%i) %s\n	%s", i + 1, strPlayerName, strXP);
				StrCat(g_strTopXPModPlayersStatsText, sizeof(g_strTopXPModPlayersStatsText), strRowData);
			}
			else
			{
				LogError("SQL Error getting row %i data for Top XPMod Player stats query", i);
			}
		}
	}

}

void SQLGetTopXPModPlayerStatistics()
{	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	// Save the new user data into the SQL database with the matching Steam ID
	char strQuery[1024];
	strQuery[0] = '\0';
	// Combine it all into the query
	Format(strQuery, sizeof(strQuery), "SELECT %s,%s,%s FROM %s", strUsersTableColumnNames[DB_COL_INDEX_USERS_USER_NAME], strUsersTableColumnNames[DB_COL_INDEX_USERS_XP], strUsersTableColumnNames[DB_COL_INDEX_USERS_STEAM_ID], DB_VIEWNAME_TOP_10);

	SQL_TQuery(g_hDatabase, SQLGetTopXPModPlayerStatisticsCallback, strQuery, _);
}

void SQLGetTopPlayerLeaderboard()
{
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}

	char strQuery[256];
	Format(strQuery, sizeof(strQuery), "SELECT stat_type, user_name, stat_value, class_info FROM %s", DB_VIEWNAME_TOP_PLAYER_LEADERBOARD);

	SQL_TQuery(g_hDatabase, SQLGetTopPlayerLeaderboardCallback, strQuery, _);
}

void AbbreviateInfectedClassInfo(const char[] strClassInfo, char[] strOutput, int iMaxLen)
{
	char strClasses[3][16];
	int iCount = ExplodeString(strClassInfo, "/", strClasses, 3, 16);

	strOutput[0] = '\0';
	for (int i = 0; i < iCount; i++)
	{
		if (i > 0)
			StrCat(strOutput, iMaxLen, "/");

		TrimString(strClasses[i]);

		char strAbbrev[4];
		if (strlen(strClasses[i]) >= 2 &&
			(strClasses[i][0] == 'S' || strClasses[i][0] == 's'))
		{
			if (strClasses[i][1] == 'm' || strClasses[i][1] == 'M')
				strAbbrev = "SM";
			else if (strClasses[i][1] == 'p' || strClasses[i][1] == 'P')
				strAbbrev = "SP";
			else
			{
				strAbbrev[0] = 'S';
				strAbbrev[1] = '\0';
			}
		}
		else if (strlen(strClasses[i]) > 0)
		{
			strAbbrev[0] = strClasses[i][0];
			if (strAbbrev[0] >= 'a' && strAbbrev[0] <= 'z')
				strAbbrev[0] -= 32;
			strAbbrev[1] = '\0';
		}

		StrCat(strOutput, iMaxLen, strAbbrev);
	}
}

void SQLGetTopPlayerLeaderboardCallback(Handle owner, Handle hQuery, const char[] error, int empty)
{
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}

	if (!StrEqual("", error))
	{
		LogError("SQL Error (Top Player Leaderboard): %s", error);
		return;
	}

	if (SQL_MoreRows(hQuery) == false)
		return;

	// Clear old data
	g_strTopPlayerLeaderboardText[0] = '\0';

	char strStatType[16], strName[32], strClassInfo[32];
	char strLine[90];
	bool bInfectedSectionStarted = false;

	while (SQL_FetchRow(hQuery))
	{
		SQL_FetchString(hQuery, 0, strStatType, sizeof(strStatType));
		SQL_FetchString(hQuery, 1, strName, sizeof(strName));
		int iStatValue = SQL_FetchInt(hQuery, 2);
		SQL_FetchString(hQuery, 3, strClassInfo, sizeof(strClassInfo));

		// Add blank line separator before first infected/tank stat
		bool bIsInfectedStat = (StrEqual(strStatType, "inf_wins") || StrEqual(strStatType, "inf_kills") ||
			StrEqual(strStatType, "inf_dmg") || StrEqual(strStatType, "tank_dmg"));

		if (!bInfectedSectionStarted && bIsInfectedStat)
		{
			StrCat(g_strTopPlayerLeaderboardText, sizeof(g_strTopPlayerLeaderboardText), "\n ");
			bInfectedSectionStarted = true;
		}

		// Abbreviate infected class info (e.g. "Boomer/Spitter/Charger" -> "B/SP/C")
		if (bIsInfectedStat && StrEqual(strStatType, "tank_dmg") == false)
			AbbreviateInfectedClassInfo(strClassInfo, strClassInfo, sizeof(strClassInfo));

		if (StrEqual(strStatType, "sur_wins"))
			Format(strLine, sizeof(strLine), "\nSURVIVORS\nWins: %i	%s (%s)", iStatValue, strName, strClassInfo);
		else if (StrEqual(strStatType, "sur_ci"))
			Format(strLine, sizeof(strLine), "\nCI Kills: %i	%s (%s)", iStatValue, strName, strClassInfo);
		else if (StrEqual(strStatType, "sur_si"))
			Format(strLine, sizeof(strLine), "\nSI Kills: %i	%s (%s)", iStatValue, strName, strClassInfo);
		else if (StrEqual(strStatType, "sur_hs"))
			Format(strLine, sizeof(strLine), "\nHS: %i	%s (%s)", iStatValue, strName, strClassInfo);
		else if (StrEqual(strStatType, "inf_wins"))
			Format(strLine, sizeof(strLine), "\nINFECTED\nWins: %i	%s (%s)", iStatValue, strName, strClassInfo);
		else if (StrEqual(strStatType, "inf_kills"))
			Format(strLine, sizeof(strLine), "\nKills: %i	%s (%s)", iStatValue, strName, strClassInfo);
		else if (StrEqual(strStatType, "inf_dmg"))
			Format(strLine, sizeof(strLine), "\nDmg: %i	%s (%s)", iStatValue, strName, strClassInfo);
		else if (StrEqual(strStatType, "tank_dmg"))
			Format(strLine, sizeof(strLine), "\nTank Dmg: %i	%s (%s)", iStatValue, strName, strClassInfo);
		else
			continue;

		StrCat(g_strTopPlayerLeaderboardText, sizeof(g_strTopPlayerLeaderboardText), strLine);
	}
}

void SQLGetPersonalPlayerStatistics(int iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
		return;

	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	// Get Steam Auth ID
	char strSteamID[32];
	if (GetClientSteamID64(iClient, strSteamID, sizeof(strSteamID)) == false)
		return;

	// Clear previous data
	g_strPersonalDBStatsText[iClient][0] = '\0';

	char strQuery[2048];
	Format(strQuery, sizeof(strQuery),
		"SELECT 'sur_wr' AS stat_type, '' AS name_1, '' AS name_2, '' AS name_3, \
		ROUND(SUM(round_win = 1) * 100.0 / COUNT(*), 1) AS win_rate, \
		SUM(round_win = 1) AS val1, SUM(round_win = 0) AS val2, \
		COUNT(*) AS val3, \
		SUM(si_kills) AS val4, SUM(ci_kills) AS val5, SUM(headshots) AS val6 \
		FROM survivor_stats WHERE steam_id = '%s' \
		UNION ALL \
		SELECT 'inf_wr', '', '', '', \
		ROUND(SUM(round_win = 1) * 100.0 / COUNT(*), 1), \
		SUM(round_win = 1), SUM(round_win = 0), \
		COUNT(*), \
		SUM(survivor_kills), \
		SUM(damage_smoker + damage_boomer + damage_hunter + damage_spitter + damage_jockey + damage_charger + damage_tank), \
		0 \
		FROM infected_stats WHERE steam_id = '%s' \
		UNION ALL \
		(SELECT 'survivor', survivor_name, '', '', \
		win_rate, total_si_kills, avg_si_kills, total_ci_kills, avg_ci_kills, total_headshots, avg_headshots \
		FROM personal_survivor_class_stats WHERE steam_id = '%s' \
		ORDER BY win_rate DESC, total_si_kills DESC LIMIT 1) \
		UNION ALL \
		(SELECT 'infected', infected_name_1, infected_name_2, infected_name_3, \
		win_rate, total_survivor_kills, avg_survivor_kills, total_damage_to_survivors, avg_damage_to_survivors, 0, 0.0 \
		FROM personal_infected_combo_stats WHERE steam_id = '%s' \
		ORDER BY win_rate DESC, total_damage_to_survivors DESC LIMIT 1) \
		UNION ALL \
		(SELECT 'tank', tc.class_name, '', '', \
		0.0, 0, 0.0, 0, 0.0, 0, 0.0 \
		FROM infected_stats ist \
		JOIN tank_classes tc ON ist.tank_chosen = tc.class_id \
		WHERE ist.steam_id = '%s' AND ist.tank_chosen IS NOT NULL AND ist.tank_chosen > 0 \
		GROUP BY ist.tank_chosen \
		ORDER BY COUNT(*) DESC LIMIT 1)",
		strSteamID, strSteamID, strSteamID, strSteamID, strSteamID);

	SQL_TQuery(g_hDatabase, SQLGetPersonalPlayerStatisticsCallback, strQuery, iClient);
}

void SQLGetPersonalPlayerStatisticsCallback(Handle owner, Handle hQuery, const char[] error, int iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
		return;

	if (!StrEqual("", error))
	{
		LogError("SQL Error (Personal Stats): %s", error);
		return;
	}

	if (RunClientChecks(iClient) == false)
		return;

	// Survivor overall
	char strSurvivorSection[150];
	strSurvivorSection[0] = '\0';
	// Infected overall
	char strInfectedSection[150];
	strInfectedSection[0] = '\0';
	// Best survivor class
	char strBestSurvivor[200];
	strBestSurvivor[0] = '\0';
	// Best infected combo
	char strBestInfected[200];
	strBestInfected[0] = '\0';
	// Favorite tank
	char strFavTank[60];
	strFavTank[0] = '\0';

	char strStatType[16], strName1[24], strName2[24], strName3[24];

	while (SQL_FetchRow(hQuery))
	{
		SQL_FetchString(hQuery, 0, strStatType, sizeof(strStatType));
		SQL_FetchString(hQuery, 1, strName1, sizeof(strName1));
		SQL_FetchString(hQuery, 2, strName2, sizeof(strName2));
		SQL_FetchString(hQuery, 3, strName3, sizeof(strName3));

		float fWinRate = SQL_FetchFloat(hQuery, 4);
		int iVal1 = SQL_FetchInt(hQuery, 5);
		int iVal3 = SQL_FetchInt(hQuery, 7);

		if (StrEqual(strStatType, "sur_wr") && iVal3 > 0)
		{
			int iVal2 = SQL_FetchInt(hQuery, 6);
			int iVal4 = SQL_FetchInt(hQuery, 8);
			int iVal5 = SQL_FetchInt(hQuery, 9);
			int iVal6 = SQL_FetchInt(hQuery, 10);
			Format(strSurvivorSection, sizeof(strSurvivorSection),
				"\nSurvivor: %i Rounds  %.1f%% WR (%iW / %iL)\
				\n Total SI Kills: %i   Total CI Kills: %i\
				\n Total HS: %i",
				iVal3, fWinRate, iVal1, iVal2, iVal4, iVal5, iVal6);
		}
		else if (StrEqual(strStatType, "inf_wr") && iVal3 > 0)
		{
			int iVal2 = SQL_FetchInt(hQuery, 6);
			int iVal4 = SQL_FetchInt(hQuery, 8);
			int iVal5 = SQL_FetchInt(hQuery, 9);
			Format(strInfectedSection, sizeof(strInfectedSection),
				"\nInfected: %i Rounds  %.1f%% WR (%iW / %iL)\
				\n	Total Kills: %i\
				\n	Total DMG: %i",
				iVal3, fWinRate, iVal1, iVal2, iVal4, iVal5);
		}
		else if (StrEqual(strStatType, "survivor"))
		{
			float fAvgSI = SQL_FetchFloat(hQuery, 6);
			int iCIKills = SQL_FetchInt(hQuery, 7);
			float fAvgCI = SQL_FetchFloat(hQuery, 8);
			int iHS = SQL_FetchInt(hQuery, 9);
			float fAvgHS = SQL_FetchFloat(hQuery, 10);
			Format(strBestSurvivor, sizeof(strBestSurvivor),
				"\nBEST SURVIVOR: %s (%.1f%% WR)\
				\n	SI Kills: %i (%.1f avg)\
				\n	CI Kills: %i (%.1f avg)\
				\n	HS: %i (%.1f avg)",
				strName1, fWinRate, iVal1, fAvgSI, iCIKills, fAvgCI, iHS, fAvgHS);
		}
		else if (StrEqual(strStatType, "infected"))
		{
			float fAvgKills = SQL_FetchFloat(hQuery, 6);
			int iDmg = SQL_FetchInt(hQuery, 7);
			float fAvgDmg = SQL_FetchFloat(hQuery, 8);
			// Format combo name: "Hunter/Spitter/Charger"
			char strCombo[72];
			Format(strCombo, sizeof(strCombo), "%s/%s/%s", strName1, strName2, strName3);
			Format(strBestInfected, sizeof(strBestInfected),
				"\nBEST INFECTED: %s (%.1f%% WR)\
				\n	Kills: %i (%.1f avg)\
				\n	DMG: %i (%.1f avg)",
				strCombo, fWinRate, iVal1, fAvgKills, iDmg, fAvgDmg);
		}
		else if (StrEqual(strStatType, "tank"))
		{
			Format(strFavTank, sizeof(strFavTank), "\n \nFAVORITE TANK: %s", strName1);
		}
	}

	// No data — leave the buffer empty so the panel is silently skipped
	if (strSurvivorSection[0] == '\0' && strInfectedSection[0] == '\0')
		return;

	// Store raw stats content only — panel framing is done in Statistics_Panel.sp
	Format(g_strPersonalDBStatsText[iClient], sizeof(g_strPersonalDBStatsText[]),
		"%s%s\
		\n %s%s%s",
		strSurvivorSection, strInfectedSection,
		strBestSurvivor, strBestInfected, strFavTank);
}
