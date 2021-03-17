SQLCheckIfUserIsInBanListCallback(Handle:owner, Handle:hQuery, const String:error[], any:iClient)
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

	decl String:strData[50];
	if(SQL_FetchRow(hQuery))
	{		
		//Get the ban duration of the user, if null returned then ban for a long time
		if(SQL_FetchString(hQuery, 0, strData, sizeof(strData)) != 0)
		{
			new iBanDurationSeconds = StringToInt(strData);
			PrintToServer("[XPMod] BANNING FOR %i SECONDS", iBanDurationSeconds);

			// If the user was found in the bans table, ban them again
			// Note: this occurs when the server has been restarted and their ban is not currently in memory.
			// Once it has been added to memory, they will no longer be able to join to get to this point.
			if (iBanDurationSeconds > 60)
				BanClient(iClient, RoundToFloor(iBanDurationSeconds / 60.0), BANFLAG_AUTHID, "XPMod Banned", "You are currently banned from XPMod servers");
		}
		else
		{
			// User has been banned with a NULL expiration_timer so ban for a long time
			BanClient(iClient, 9999999, BANFLAG_AUTHID, "XPMod Banned", "You are permanently banned from XPMod servers");
		}
	}
	
	// PrintToChatAll("SQLCheckIfUserIsInBanList Callback Complete.");
	// PrintToServer("SQLCheckIfUserIsInBanList Callback Complete.");
}

SQLCheckIfUserIsInBanList(int iClient)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	// PrintToChatAll("SQLCheckIfUserIsInBanList  %i: %N", iClient, iClient);
	// PrintToServer("SQLCheckIfUserIsInBanList  %i: %N", iClient, iClient);
	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	//Get Steam Auth ID, if this returns false, then do not proceed
	decl String:strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
	{
		LogError("SQLCheckIfUserIsInBanList: GetClientAuthId failed for %N", iClient);
		return;
	}
	
	// Run a query to see if they are in the bans table
	// This gets the time in seconds of how long they are still banned, if they are indeed in the bans table.
	decl String:strQuery[1024] = "";
	Format(strQuery, sizeof(strQuery), "SELECT TIMESTAMPDIFF(SECOND,NOW(),expiration_time) FROM %s WHERE steam_id = %s", DB_TABLENAME_BANS, strSteamID);

	SQL_TQuery(g_hDatabase, SQLCheckIfUserIsInBanListCallback, strQuery, iClient);
}

//Callback function for an SQL AddBannedUserToDatabase
SQLAddBannedUserToDatabaseCallback(Handle:owner, Handle:hQuery, const String:error[], any:iClient)
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
	
	// PrintToChatAll("SQLAddBannedUserToDatabase Callback Complete.");
	// PrintToServer("SQLAddBannedUserToDatabase Callback Complete.");
}


SQLAddBannedUserToDatabase(iClient, int iBanDurationSeconds = 0, const char [] strBanReason)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;
	
	// PrintToChatAll("AddBannedUserToDatabase  %i: %N", iClient, iClient);
	// PrintToServer("AddBannedUserToDatabase  %i: %N", iClient, iClient);
	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	//Get Steam Auth ID, if this returns false, then do not proceed
	decl String:strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
	{
		LogError("AddBannedUserToDatabase: GetClientAuthId failed for %N", iClient);
		return;
	}
	
	//Get Client Name
	decl String:strClientName[32];
	GetClientName(iClient, strClientName, sizeof(strClientName));
	SanitizeValueStringForQuery(strClientName, sizeof(strClientName));

	char strExpiriationTime[32];
	GetBanExpirationTimestamp(strExpiriationTime, sizeof(strExpiriationTime), iBanDurationSeconds);
	
	//Create new entry into the SQL database with the users information
	decl String:strQuery[512] = "";
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (\
		steam_id,\
		user_name,\
		expiration_time,\
		reason)\
		VALUES ('%s','%s',%s,'%s')", 
		DB_TABLENAME_BANS,
		strSteamID,
		strClientName,
		strExpiriationTime,
		strBanReason);
	SQL_TQuery(g_hDatabase, SQLAddBannedUserToDatabaseCallback, strQuery, iClient);
}

GetBanExpirationTimestamp(char [] strExpirationTimeStampValue, int iExpirationTimeStampValueSize, int iBanDurationSeconds) 
{
	if (iBanDurationSeconds <= 0)
	{
		Format(strExpirationTimeStampValue, iExpirationTimeStampValueSize, "NULL");
		return;
	}
	
	decl String:strDateTime[30];
	FormatTime(strDateTime, sizeof(strDateTime), "%Y-%m-%d %H:%M:%S", GetTime() + iBanDurationSeconds);
	Format(strExpirationTimeStampValue, iExpirationTimeStampValueSize, "'%s'", strDateTime);
}