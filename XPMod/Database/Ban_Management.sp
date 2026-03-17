void SQLCheckIfUserIsInBanListCallback(Handle owner, Handle hQuery, const char[] error, int iClient)
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

	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	char strData[50];
	if(SQL_FetchRow(hQuery))
	{		
		//Get the ban duration of the user, if null returned then ban for a long time
		if(SQL_FetchString(hQuery, 0, strData, sizeof(strData)) != 0)
		{
			int iBanDurationSeconds = StringToInt(strData);
			PrintToServer("[XPMod] BANNING FOR %i SECONDS", iBanDurationSeconds);

			// If the user was found in the bans table, ban them again
			// Note: this occurs when the server has been restarted and their ban is not currently in memory.
			// Once it has been added to memory, they will no longer be able to join to get to this point.
			// if (iBanDurationSeconds > 60)
			// 	BanClient(iClient, RoundToFloor(iBanDurationSeconds / 60.0), BANFLAG_AUTHID, "XPMod Banned", "You are currently banned from XPMod servers");

			// Banning was changed to only kick, to fix issue with lingering bans after unban
			if (iBanDurationSeconds > 0)
				KickClient(iClient, "You are currently banned from XPMod servers")
		}
		else
		{
			// User has been banned with a NULL expiration_timer so ban for a long time
			// BanClient(iClient, 9999999, BANFLAG_AUTHID, "XPMod Banned", "You are permanently banned from XPMod servers");
			// Banning was changed to only kick, to fix issue with lingering bans after unban
			KickClient(iClient, "You are permanently banned from XPMod servers")
		}
	}
	
}

void SQLCheckIfUserIsInBanList(int iClient)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	//Get Steam Auth ID, if this returns false, then do not proceed
	char strSteamID[32];
	if (GetClientSteamID64(iClient, strSteamID, sizeof(strSteamID)) == false)
		return;
	
	// Run a query to see if they are in the bans table
	// This gets the time in seconds of how long they are still banned, if they are indeed in the bans table.
	char strQuery[1024];
	strQuery[0] = '\0';
	Format(strQuery, sizeof(strQuery), "SELECT TIMESTAMPDIFF(SECOND,NOW(),expiration_time) FROM %s WHERE steam_id = '%s'", DB_TABLENAME_BANS, strSteamID);

	SQL_TQuery(g_hDatabase, SQLCheckIfUserIsInBanListCallback, strQuery, iClient);
}

//Callback function for an SQL AddBannedUserToDatabase
void SQLAddBannedUserToDatabaseCallback(Handle owner, Handle hQuery, const char[] error, int iClient)
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
	
}

void GetBanAdminDataForQuery(int iAdminClient, char[] strAdminName, int iAdminNameSize, char[] strAdminSteamID, int iAdminSteamIDSize)
{
	strAdminName[0] = '\0';
	strcopy(strAdminSteamID, iAdminSteamIDSize, "0");

	if (RunClientChecks(iAdminClient) == false || IsFakeClient(iAdminClient) == true)
		return;

	GetClientName(iAdminClient, strAdminName, iAdminNameSize);
	SanitizeValueStringForQuery(strAdminName, iAdminNameSize);

	if (GetClientSteamID64(iAdminClient, strAdminSteamID, iAdminSteamIDSize) == false)
		strcopy(strAdminSteamID, iAdminSteamIDSize, "0");
}

void SQLAddBannedUserToDatabaseUsingClientID(int iClient, int iBanDurationSeconds = 0, const char[] strBanReason, int iAdminClient = 0)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;
	
	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	//Get Steam Auth ID, if this returns false, then do not proceed
	char strSteamID[32];
	if (GetClientSteamID64(iClient, strSteamID, sizeof(strSteamID)) == false)
	{
		LogError("AddBannedUserToDatabase: GetClientAuthId failed for %N", iClient);
		return;
	}
	
	//Get Client Name
	char strClientName[32];
	GetClientName(iClient, strClientName, sizeof(strClientName));
	SanitizeValueStringForQuery(strClientName, sizeof(strClientName));

	char strSanitizedBanReason[100];
	strcopy(strSanitizedBanReason, sizeof(strSanitizedBanReason), strBanReason);
	SanitizeValueStringForQuery(strSanitizedBanReason, sizeof(strSanitizedBanReason));

	char strAdminName[32], strAdminSteamID[32];
	GetBanAdminDataForQuery(iAdminClient, strAdminName, sizeof(strAdminName), strAdminSteamID, sizeof(strAdminSteamID));

	char strExpiriationTime[32];
	GetBanExpirationTimestamp(strExpiriationTime, sizeof(strExpiriationTime), iBanDurationSeconds);
	
	// Insert or refresh the existing ban row for this Steam ID.
	char strQuery[1024];
	strQuery[0] = '\0';
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (\
		steam_id,\
		user_name,\
		ban_timestamp,\
		expiration_time,\
		reason,\
		admin_user_name,\
		admin_steam_id)\
		VALUES ('%s','%s',CURRENT_TIMESTAMP,%s,'%s','%s','%s') \
		ON DUPLICATE KEY UPDATE \
		user_name = '%s', \
		ban_timestamp = CURRENT_TIMESTAMP, \
		expiration_time = %s, \
		reason = '%s', \
		admin_user_name = '%s', \
		admin_steam_id = '%s'", 
		DB_TABLENAME_BANS,
		strSteamID,
		strClientName,
		strExpiriationTime,
		strSanitizedBanReason,
		strAdminName,
		strAdminSteamID,
		strClientName,
		strExpiriationTime,
		strSanitizedBanReason,
		strAdminName,
		strAdminSteamID);
	SQL_TQuery(g_hDatabase, SQLAddBannedUserToDatabaseCallback, strQuery, iClient);
}

void SQLAddBannedUserToDatabaseUsingNameAndSteamID(char[] strClientName, const int iClientNameSize, const char[] strSteamID, int iBanDurationSeconds = 0, const char[] strBanReason, int iAdminClient = 0)
{	
	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	// Sanitize Inputs for Query
	SanitizeValueStringForQuery(strClientName, iClientNameSize);

	char strSanitizedBanReason[100];
	strcopy(strSanitizedBanReason, sizeof(strSanitizedBanReason), strBanReason);
	SanitizeValueStringForQuery(strSanitizedBanReason, sizeof(strSanitizedBanReason));

	char strAdminName[32], strAdminSteamID[32];
	GetBanAdminDataForQuery(iAdminClient, strAdminName, sizeof(strAdminName), strAdminSteamID, sizeof(strAdminSteamID));

	char strExpiriationTime[32];
	GetBanExpirationTimestamp(strExpiriationTime, sizeof(strExpiriationTime), iBanDurationSeconds);
	
	// Insert or refresh the existing ban row for this Steam ID.
	char strQuery[1024];
	strQuery[0] = '\0';
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (\
		steam_id,\
		user_name,\
		ban_timestamp,\
		expiration_time,\
		reason,\
		admin_user_name,\
		admin_steam_id)\
		VALUES ('%s','%s',CURRENT_TIMESTAMP,%s,'%s','%s','%s') \
		ON DUPLICATE KEY UPDATE \
		user_name = '%s', \
		ban_timestamp = CURRENT_TIMESTAMP, \
		expiration_time = %s, \
		reason = '%s', \
		admin_user_name = '%s', \
		admin_steam_id = '%s'", 
		DB_TABLENAME_BANS,
		strSteamID,
		strClientName,
		strExpiriationTime,
		strSanitizedBanReason,
		strAdminName,
		strAdminSteamID,
		strClientName,
		strExpiriationTime,
		strSanitizedBanReason,
		strAdminName,
		strAdminSteamID);
	SQL_TQuery(g_hDatabase, SQLAddBannedUserToDatabaseCallback, strQuery, 0);
}

void GetBanExpirationTimestamp(char[] strExpirationTimeStampValue, int iExpirationTimeStampValueSize, int iBanDurationSeconds) 
{
	if (iBanDurationSeconds <= 0)
	{
		Format(strExpirationTimeStampValue, iExpirationTimeStampValueSize, "NULL");
		return;
	}
	
	char strDateTime[30];
	FormatTime(strDateTime, sizeof(strDateTime), "%Y-%m-%d %H:%M:%S", GetTime() + iBanDurationSeconds);
	Format(strExpirationTimeStampValue, iExpirationTimeStampValueSize, "'%s'", strDateTime);
}
