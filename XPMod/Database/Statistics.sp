//Callback function for SQLGetTopXPModPlayerStatistics
SQLGetTopXPModPlayerStatisticsCallback(Handle owner, Handle hQuery, const char[] error, any empty)
{
	// PrintToChatAll("SQLGetTopXPModPlayerStatisticsCallback Started.");
	// PrintToServer("SQLGetTopXPModPlayerStatisticsCallback Started.");

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
	
	char strPlayerName[33], strXP[10];
	for (int i=0; i < 10; i++)
	{
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
				// Format and add row data
				char strRowData[60];
				Format(strRowData, sizeof(strRowData), "%2i) %25s\n	XP: %s", i + 1, strPlayerName, strXP);
				StrCat(g_strTopXPModPlayersStatsText, sizeof(g_strTopXPModPlayersStatsText), strRowData);
			}
			else
			{
				LogError("SQL Error getting row %i data for Top XPMod Player stats query", i);
			}			
		}
	}

	// PrintToChatAll("SQLGetTopXPModPlayerStatisticsCallback Callback Complete.");
	// PrintToServer("SQLGetTopXPModPlayerStatisticsCallback Callback Complete.");
}

SQLGetTopXPModPlayerStatistics()
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
	Format(strQuery, sizeof(strQuery), "SELECT %s,%s FROM %s", strUsersTableColumnNames[DB_COL_INDEX_USERS_USER_NAME], strUsersTableColumnNames[DB_COL_INDEX_USERS_XP], DB_VIEWNAME_TOP_10);

	SQL_TQuery(g_hDatabase, SQLGetTopXPModPlayerStatisticsCallback, strQuery, _);
}
