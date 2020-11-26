//SQL Database File Functions

bool:ConnectDB()
{	
	new Handle:hKeyValues = CreateKeyValues("sql");
	KvSetString(hKeyValues, "driver", "mysql");
	KvSetString(hKeyValues, "host", DB_HOST);
	KvSetString(hKeyValues, "database", DB_DATABASE);
	KvSetString(hKeyValues, "user", DB_USER);
	KvSetString(hKeyValues, "pass", DB_PASSWORD);

	decl String:error[255];
	g_hDatabase = SQL_ConnectCustom(hKeyValues, error, sizeof(error), true);
	CloseHandle(hKeyValues);

	if (g_hDatabase == INVALID_HANDLE)
	{
		LogError("MySQL Connection For XPMod User Database Failed: %s", error);
		return false;
	}
	
	return true;
}

//Callback function for an SQL SaveUserData
public SQLGetUserDataCallback(Handle:owner, Handle:hQuery, const String:error[], any:hDataPack)
{
	if (hDataPack == INVALID_HANDLE)
	{
		LogError("SQLGetUserDataCallback: INVALID HANDLE on hDataPack");
		return;
	}
	ResetPack(hDataPack);
	new iClient = ReadPackCell(hDataPack);
	bool bOnlyWebsiteChangableData = ReadPackCell(hDataPack);
	CloseHandle(hDataPack);

	// PrintToChatAll("GetUserData Callback Started. %i: %N", iClient, iClient);
	// PrintToServer("GetUserData Callback Started. %i: %N", iClient, iClient);

	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}

	if (IsValidEntity(iClient) == false || IsFakeClient(iClient))
	{
		LogError("SQLGetUserDataCallback: INVALID ENTITY OR IS FAKE CLIENT");
		return;
	}
	
	if(!StrEqual("", error))
	{
		LogError("SQL Error: %s", error);
		return;
	}
	
	decl String:strData[16], iSurvivorTalent[6],  iInfectedID[3], iEquipmentSlot[6], iOption[3];
	new iColumn = 0, iSkillPointsUsed = 0;
	
	if (bOnlyWebsiteChangableData == false)
	{
		ResetSkillPoints(iClient, iClient);
	}
	
	if(SQL_FetchRow(hQuery))
	{
		if (bOnlyWebsiteChangableData == false)
		{			
			//Get Survivor Talent Levels from the SQL database
			for(new i = 0; i < 4; i++)
			{
				if(SQL_FetchString(hQuery, iColumn++, strData, sizeof(strData)) != 0)
				{
					PrintToServer("strData[%i]: %s", i, strData);
					PrintToChatAll("strData[%i]: %s", i, strData);
				}
				else
					LogError("SQL Error getting SurvivorTalent[%d] string from query", i);
			}
		}

		//Set the user to be logged in
		g_bClientLoggedIn[iClient] = true;
		
		PrintToChatAll("\x05<-=- \x03%N (Level %d) has joined\x05 -=->", iClient, g_iClientLevel[iClient]);
		PrintToServer(":-=-=-=-=-<[%N (Level %d) logged in]>-=-=-=-=-:", iClient, g_iClientLevel[iClient]);
		PrintHintText(iClient, "Welcome back %N", iClient);
	}
	else if (bOnlyWebsiteChangableData == false)
	{
		PrintToChatAll("\x03[XPMod] %N has no account.", iClient);
		PrintToServer("[XPMod] %N has no account.", iClient);
	}

	// PrintToChatAll("GetUserData Callback Complete.  %i: %N", iClient, iClient);
	// PrintToServer("GetUserData Callback Complete.  %i: %N", iClient, iClient);
}

GetUserData(any:iClient, bool:bOnlyWebsiteChangableData = false)
{
	// PrintToChatAll("GetUserData. %i: %N", iClient, iClient);
	// PrintToServer("GetUserData. %i: %N", iClient, iClient);
	if(iClient == 0)
		iClient = 1;
	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	if (!IsClientInGame(iClient) || IsFakeClient(iClient) || (g_bClientLoggedIn[iClient] && bOnlyWebsiteChangableData == false))
		return;
	
	//Get SteamID
	decl String:strSteamID[32];
	GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID));
	
	//Save the new user data into the SQL database with the matching Steam ID
	decl String:strQuery[1024];
	Format(strQuery, sizeof(strQuery), "SELECT user_id, user_name, xp, survivor_id, infected_id_1 FROM %s WHERE steam_id = %s", DB_TABLENAME, strSteamID);
	
	// Create a data pack to pass multiple parameters to the callback
	new Handle:hDataPackage = CreateDataPack();
	WritePackCell(hDataPackage, iClient);
	WritePackCell(hDataPackage, bOnlyWebsiteChangableData);

	SQL_TQuery(g_hDatabase, SQLGetUserDataCallback, strQuery, hDataPackage);
}

//Callback function for an SQL CreateNewUser
public SQLCreateNewUserCallback(Handle:owner, Handle:hQuery, const String:error[], any:iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	if (!IsClientInGame(iClient) || IsFakeClient(iClient))
		return;
	
	if(!StrEqual("", error))
		LogError("SQL Error: %s", error);
	else
		g_bClientLoggedIn[iClient] = true;
	
	//PrintToChatAll("New User Creation Callback Complete.  %i: %N", iClient, iClient);
	//PrintToServer("New User Creation Callback Complete.  %i: %N", iClient, iClient);
}

CreateNewUser(iClient)
{
	//PrintToChatAll("New User Creation.  %i: %N", iClient, iClient);
	//PrintToServer("New User Creation.  %i: %N", iClient, iClient);
	if(iClient == 0)
		iClient = 1;
	
	//g_bClientLoggedIn[iClient] = true;
	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
		
	if(!IsClientInGame(iClient) || IsFakeClient(iClient) || g_bClientLoggedIn[iClient])
		return;
	
	//Get SteamID
	decl String:strSteamID[32];
	GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID));
	
	//Get Client Name
	decl String:strClientName[32];
	GetClientName(iClient, strClientName, sizeof(strClientName));
	
	//PrintToChatAll(strClientName);
	
	//Give bonus XP
	//g_iClientXP[iClient] += 10000;
	
	//Get Client XP
	decl String:strClientXP[10];
	if(g_iClientXP[iClient]>99999999)
		IntToString(99999999, strClientXP, sizeof(strClientXP));
	else
		IntToString(g_iClientXP[iClient], strClientXP, sizeof(strClientXP));
	
	//Create new entry into the SQL database with the users information
	decl String:strQuery[256];
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (steam_id, user_name, xp) VALUES ('%s', '%s', %s)", DB_TABLENAME, strSteamID, strClientName, strClientXP);
	SQL_TQuery(g_hDatabase, SQLCreateNewUserCallback, strQuery, iClient);
}

//Callback function for an SQL SaveUserData
public SQLSaveUserDataCallback(Handle:owner, Handle:hQuery, const String:error[], any:iClient)
{
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	if(!StrEqual("", error))
		LogError("SQL Error: %s", error);

	// PrintToChatAll("Save User Data Callback Complete. %i: %N", iClient, iClient);
	// PrintToServer("Save User Data Callback Complete. %i: %N", iClient, iClient);
}

SaveUserData(iClient)
{
	// PrintToChatAll("Save User Data. %i: %N", iClient, iClient);
	// PrintToServer("Save User Data. %i: %N", iClient, iClient);
	if(iClient == 0)
		iClient = 1;
	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}	
	
	if (!g_bClientLoggedIn[iClient] || g_iClientXP[iClient]<0)
		return;
		
	decl String:strSteamID[32], String:strClientName[32], String:strClientXP[10], String:strSurvivorID[3], 
		String:strSurvivorTalent[6][2], String:strInfectedID[3][2], String:strEquipmentSlotID[6][3], String:strOption[3][2];
	
	//Get SteamID
	GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID));
	
	//Get Client Name
	GetClientName(iClient, strClientName, sizeof(strClientName));
	
	//Get Client XP
	if(g_iClientXP[iClient]>99999999)
		IntToString(99999999, strClientXP, sizeof(strClientXP));
	else
		IntToString(g_iClientXP[iClient], strClientXP, sizeof(strClientXP));
		
	//Get SurvivorID
	IntToString(g_iChosenSurvivor[iClient], strSurvivorID, sizeof(strSurvivorID))
	
	//Get Survivor Talent IDs
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:
		{
			IntToString(g_iInspirationalLevel[iClient], strSurvivorTalent[0], 2);
			IntToString(g_iGhillieLevel[iClient], strSurvivorTalent[1], 2);
			IntToString(g_iWillLevel[iClient], strSurvivorTalent[2], 2);
			IntToString(g_iExorcismLevel[iClient], strSurvivorTalent[3], 2);
			IntToString(g_iDiehardLevel[iClient], strSurvivorTalent[4], 2);
			IntToString(g_iPromotionalLevel[iClient], strSurvivorTalent[5], 2);
		}
		case ROCHELLE:
		{
			IntToString(g_iGatherLevel[iClient], strSurvivorTalent[0], 2);
			IntToString(g_iHunterLevel[iClient], strSurvivorTalent[1], 2);
			IntToString(g_iSniperLevel[iClient], strSurvivorTalent[2], 2);
			IntToString(g_iSilentLevel[iClient], strSurvivorTalent[3], 2);
			IntToString(g_iSmokeLevel[iClient], strSurvivorTalent[4], 2);
			IntToString(g_iShadowLevel[iClient], strSurvivorTalent[5], 2);
		}
		case COACH:
		{
			IntToString(g_iBullLevel[iClient], strSurvivorTalent[0], 2);
			IntToString(g_iWreckingLevel[iClient], strSurvivorTalent[1], 2);
			IntToString(g_iSprayLevel[iClient], strSurvivorTalent[2], 2);
			IntToString(g_iHomerunLevel[iClient], strSurvivorTalent[3], 2);
			IntToString(g_iLeadLevel[iClient], strSurvivorTalent[4], 2);
			IntToString(g_iStrongLevel[iClient], strSurvivorTalent[5], 2);
		}
		case ELLIS:
		{
			IntToString(g_iOverLevel[iClient], strSurvivorTalent[0], 2);
			IntToString(g_iBringLevel[iClient], strSurvivorTalent[1], 2);
			IntToString(g_iJamminLevel[iClient], strSurvivorTalent[2], 2);
			IntToString(g_iWeaponsLevel[iClient], strSurvivorTalent[3], 2);
			IntToString(g_iMetalLevel[iClient], strSurvivorTalent[4], 2);
			IntToString(g_iFireLevel[iClient], strSurvivorTalent[5], 2);
		}
		case NICK:
		{
			IntToString(g_iSwindlerLevel[iClient], strSurvivorTalent[0], 2);
			IntToString(g_iLeftoverLevel[iClient], strSurvivorTalent[1], 2);
			IntToString(g_iRiskyLevel[iClient], strSurvivorTalent[2], 2);
			IntToString(g_iEnhancedLevel[iClient], strSurvivorTalent[3], 2);
			IntToString(g_iMagnumLevel[iClient], strSurvivorTalent[4], 2);
			IntToString(g_iDesperateLevel[iClient], strSurvivorTalent[5], 2);
		}
	}
	
	//Get Infected Class IDs
	IntToString(g_iClientInfectedClass1[iClient], strInfectedID[0], 2);
	IntToString(g_iClientInfectedClass2[iClient], strInfectedID[1], 2);
	IntToString(g_iClientInfectedClass3[iClient], strInfectedID[2], 2);
	
	//Get Equpiment Slot IDs
	IntToString(g_iClientPrimarySlotID[iClient], strEquipmentSlotID[0], 3);
	IntToString(g_iClientSecondarySlotID[iClient], strEquipmentSlotID[1], 3);
	IntToString(g_iClientExplosiveSlotID[iClient], strEquipmentSlotID[2], 3);
	IntToString(g_iClientHealthSlotID[iClient], strEquipmentSlotID[3], 3);
	IntToString(g_iClientBoostSlotID[iClient], strEquipmentSlotID[4], 3);
	IntToString(g_iClientLaserSlotID[iClient], strEquipmentSlotID[5], 3);
	
	new i = 0;
	IntToString(g_bAnnouncerOn[iClient], strOption[i++], 2);
	IntToString(g_bEnabledVGUI[iClient], strOption[i++], 2);
	IntToString(g_iXPDisplayMode[iClient], strOption[i++], 2);
	
	//Save the new user data into the SQL database with the matching Steam ID
	decl String:strQuery[1024];
	Format(strQuery, sizeof(strQuery), "\
		UPDATE %s SET \
		user_name = '%s', \
		XP = %s, \
		survivor_id = %s, \
		infected_id_1 = %s, \
		infected_id_2 = %s, \
		infected_id_3 = %s, \
		equipment_primary = %s, \
		equipment_secondary = %s, \
		equipment_explosive = %s, \
		equipment_health = %s, \
		equipment_boost = %s, \
		equipment_laser = %s, \
		option_announcer  = %s, \
		option_display_xp = %s \
		WHERE steam_id = '%s'", 
		DB_TABLENAME, 
		strClientName, 
		strClientXP, 
		strSurvivorID,
		strInfectedID[0],
		strInfectedID[1],
		strInfectedID[2],
		strEquipmentSlotID[0],
		strEquipmentSlotID[1],
		strEquipmentSlotID[2],
		strEquipmentSlotID[3],
		strEquipmentSlotID[4],
		strEquipmentSlotID[5],
		strOption[0],
		strOption[2],
		strSteamID);
	
	SQL_TQuery(g_hDatabase, SQLSaveUserDataCallback, strQuery, iClient);
}


//Logout                                                                                                        
Logout(iClient)
{
	//PrintToChatAll("Logout. %i: %N", iClient, iClient);
	//PrintToServer("Logout. %i: %N", iClient, iClient);
	if(iClient==0)
	{
		iClient = 1;			//Changed this and the folwogin two lines
		//PrintToServer("Server host cannot login through the console, go into chat and type /login to login in.");
		//return Plugin_Handled;
	}
	if(!IsClientInGame(iClient))
		return;
	g_bTalentsConfirmed[iClient] = false;
	g_bUserStoppedConfirmation[iClient] = false;
	g_bAnnouncerOn[iClient] = false;
	g_bEnabledVGUI[iClient] = false;
	if(g_bClientLoggedIn[iClient] == true)
	{
		ResetAll(iClient, iClient);
		g_bClientLoggedIn[iClient] = false;
		//PrintToChatAll("\x03[XPMod] \x04%N Logged Out", iClient, iClient);
		return;
	}

	//PrintToChatAll("Logout Complete. %i: %N", iClient, iClient);
	//PrintToServer("Logout Complete. %i: %N", iClient, iClient);
	
	return;
}
