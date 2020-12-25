//SQL Database File Functions
#include "XPMod/Models/Database/DB_Users.sp"

bool:ConnectDB()
{	

	if (SQL_CheckConfig(DB_CONF_NAME))
	{
		new String:Error[256];
		g_hDatabase = SQL_Connect(DB_CONF_NAME, true, Error, sizeof(Error));

		if (g_hDatabase == INVALID_HANDLE)
		{
			LogError("Failed to connect to XPMod database: %s", Error);
			return false;
		}
		// This SET NAMES 'utf8' doesnt look like its required.
		// else if (!SQL_FastQuery(g_hDatabase, "SET NAMES 'utf8'"))
		// {
		// 	if (SQL_GetError(g_hDatabase, Error, sizeof(Error)))
		// 		LogError("Failed to update XPMod DB encoding to UTF8: %s", Error);
		// 	else
		// 		LogError("Failed to update XPMod DB encoding to UTF8: unknown");
		// }
	}
	else
	{
		LogError("[XPMod] Databases.cfg missing '%s' entry!", DB_CONF_NAME);
		return false;
	}
	
	// This is used when connecting via the sourcecode
	// new Handle:hKeyValues = CreateKeyValues("sql");
	// KvSetString(hKeyValues, "driver", "mysql");
	// KvSetString(hKeyValues, "host", DB_HOST);
	// KvSetString(hKeyValues, "database", DB_DATABASE);
	// KvSetString(hKeyValues, "user", DB_USER);
	// KvSetString(hKeyValues, "pass", DB_PASSWORD);

	// decl String:error[255];
	// g_hDatabase = SQL_ConnectCustom(hKeyValues, error, sizeof(error), true);
	// CloseHandle(hKeyValues);

	// if (g_hDatabase == INVALID_HANDLE)
	// {
	// 	LogError("MySQL Connection For XPMod User Database Failed: %s", error);
	// 	return false;
	// }
	
	return true;
}


//Callback function for an SQL SQLGetUserIDAndToken
public SQLGetUserIDAndTokenCallback(Handle:owner, Handle:hQuery, const String:error[], any:iClient)
{
	// PrintToChatAll("SQLGetUserIDAndTokenCallback Started. %i: %N", iClient, iClient);
	// PrintToServer("SQLGetUserIDAndTokenCallback Started. %i: %N", iClient, iClient);

	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}

	if (IsValidEntity(iClient) == false || IsFakeClient(iClient))
	{
		LogError("SQLGetUserIDAndTokenCallback: INVALID ENTITY OR IS FAKE CLIENT");
		return;
	}
	
	if(!StrEqual("", error))
	{
		LogError("SQL Error: %s", error);
		return;
	}
	
	decl String:strData[50];
	
	if(SQL_FetchRow(hQuery))
	{
		//Get Client's User_ID SQL database
		if(SQL_FetchString(hQuery, 0, strData, sizeof(strData)) != 0)
		{
			g_iDBUserID[iClient] = StringToInt(strData);
		}
		else
		{
			LogError("SQL Error getting USER_ID string from query");
			return;
		}
		
		//Get Client's User Token from the SQL database
		if(SQL_FetchString(hQuery, 1, strData, sizeof(strData)) != 0)
		{
			Format(g_strDBUserToken[iClient], sizeof(g_strDBUserToken[]), "%s", strData);
		}
		else
		{
			LogError("SQL Error getting USER_ID string from query");
			return;
		}

		// Get all the user's data, now that the ID is available
		GetUserData(iClient);
	}

	// PrintToChatAll("GetUserIDAndToken Callback Complete.  %i: %N", iClient, iClient);
	// PrintToServer("GetUserIDAndToken Callback Complete.  %i: %N", iClient, iClient);
}

GetUserIDAndToken(any:iClient)
{
	// PrintToChatAll("GetUserIDAndToken. %i: %N", iClient, iClient);
	// PrintToServer("GetUserIDAndToken. %i: %N", iClient, iClient);
	if(iClient == 0)
		iClient = 1;
	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	if (!IsClientInGame(iClient) || IsFakeClient(iClient) || g_bClientLoggedIn[iClient])
		return;
	
	//Get SteamID
	decl String:strSteamID[32];
	GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID));
	
	// Save the new user data into the SQL database with the matching Steam ID
	decl String:strQuery[1024] = "";
	// Combine it all into the query
	Format(strQuery, sizeof(strQuery), "SELECT %s,%s FROM %s WHERE steam_id = %s", strUsersTableColumnNames[DB_COL_INDEX_USERS_USER_ID], strUsersTableColumnNames[DB_COL_INDEX_USERS_TOKEN], DB_TABLENAME, strSteamID);

	SQL_TQuery(g_hDatabase, SQLGetUserIDAndTokenCallback, strQuery, iClient);
}

//Callback function for an SQL GetUserData
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
	bool bDrawConfirmMenuAfter = ReadPackCell(hDataPack);
	bool bDrawTopMenuAfter = ReadPackCell(hDataPack);
	CloseHandle(hDataPack);

	// PrintToChatAll("GetUserData Callback Started. %i: %N, bOnlyWebsiteChangableData = %i", iClient, iClient, bOnlyWebsiteChangableData);
	// PrintToServer("GetUserData Callback Started. %i: %N, bOnlyWebsiteChangableData = %i", iClient, iClient, bOnlyWebsiteChangableData);

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
	
	decl String:strData[20];
	int iInfectedID[3], iEquipmentSlot[6], iOption[2];
	int iFieldIndex = 0, iSkillPointsUsed = 0;

	// Set the start index offset to caluclate the correct field index value, adding DB_COL_INDEX_USERS_USER_ID and DB_COL_INDEX_USERS_TOKEN
	int startFieldIndexOffset = DB_COL_INDEX_USERS_XP;
	
	if(SQL_FetchRow(hQuery))
	{
		if (bOnlyWebsiteChangableData == false)
		{
			//Get Client XP from the SQL database and level up player accordingly
			iFieldIndex = DB_COL_INDEX_USERS_XP - startFieldIndexOffset;
			if(SQL_FetchString(hQuery, iFieldIndex, strData, sizeof(strData)) != 0)
			{
				g_iClientXP[iClient] += StringToInt(strData);

				//Calculate level and next level g_iClientXP
				calclvlandnextxp(iClient);

				//Calculate g_iSkillPoints
				g_iSkillPoints[iClient] = g_iClientLevel[iClient] - iSkillPointsUsed;
				g_iInfectedLevel[iClient] = RoundToFloor(g_iClientLevel[iClient] * 0.5);
			}
			else
				LogError("SQL Error getting XP string from query");
		}

		//Get survivor character id from the SQL database
		iFieldIndex = DB_COL_INDEX_USERS_SURVIVOR_ID - startFieldIndexOffset;
		if(SQL_FetchString(hQuery, iFieldIndex, strData, sizeof(strData)) != 0)
			g_iChosenSurvivor[iClient] = StringToInt(strData);
		else
			LogError("SQL Error getting SurvivorID string from query");
		
		//Get Infecteed Talent ID from the SQL database
		iFieldIndex = DB_COL_INDEX_USERS_INFECTED_ID_1 - startFieldIndexOffset;
		for(new i = 0; i < 3; i++)
		{
			if(SQL_FetchString(hQuery, iFieldIndex++, strData, sizeof(strData)) != 0)
			{
				iInfectedID[i] = StringToInt(strData);
			}
			else
				LogError("SQL Error getting iInfectedID[%d] string from query", i);
		}
		
		if (bOnlyWebsiteChangableData == false)
		{
			iFieldIndex = DB_COL_INDEX_USERS_EQUIPMENT_PRIMARY - startFieldIndexOffset;
			//Get Equipment slot IDs from the SQL database
			for(new i = 0; i < 6; i++)
			{
				if(SQL_FetchString(hQuery, iFieldIndex++, strData, sizeof(strData)) != 0)
					iEquipmentSlot[i] = StringToInt(strData);
				else
					LogError("SQL Error getting iEquipmentSlot[%d] string from query", i);
			}
			
			iFieldIndex = DB_COL_INDEX_USERS_OPTION_ANNOUNCER - startFieldIndexOffset;
			//Get the user's Options from the SQL database
			for(new i = 0; i < 2; i++)
			{
				if(SQL_FetchString(hQuery, iFieldIndex++, strData, sizeof(strData)) != 0)
					iOption[i] = StringToInt(strData);
				else
					LogError("SQL Error getting iOption[%d] string from query", i);
			}
		}

		// Reset Survivor Classes and Talent Levels
		ResetSurvivorTalents(iClient, iClient);

		// Set Survivor Class Levels
		AutoLevelUpSurivovor(iClient);

		// Reset All infected Classes and Talent Levels
		ResetAllInfectedClasses(iClient);

		// Set the infected classes
		g_iClientInfectedClass1[iClient] = iInfectedID[0];
		g_iClientInfectedClass2[iClient] = iInfectedID[1];
		g_iClientInfectedClass3[iClient] = iInfectedID[2];

		// Set the infected class strings
		SetInfectedClassSlot(iClient, 1, g_iClientInfectedClass1[iClient]);
		SetInfectedClassSlot(iClient, 2, g_iClientInfectedClass2[iClient]);
		SetInfectedClassSlot(iClient, 3, g_iClientInfectedClass3[iClient]);

		if (bOnlyWebsiteChangableData == false)
		{
			//Set the user's survivor equipment
			g_iClientPrimarySlotID[iClient] = iEquipmentSlot[0];
			g_iClientSecondarySlotID[iClient] = iEquipmentSlot[1];
			g_iClientExplosiveSlotID[iClient] = iEquipmentSlot[2];
			g_iClientHealthSlotID[iClient] = iEquipmentSlot[3];
			g_iClientBoostSlotID[iClient] = iEquipmentSlot[4];
			g_iClientLaserSlotID[iClient] = iEquipmentSlot[5];
		
			//Get loadout weapon names and g_iClientXP costs
			GetWeaponNames(iClient);
		
			new i = 0;
			//Set the user's XPMod Options
			if(iOption[i++] == 1)
			{
				//Turn the Announcer on
				g_bAnnouncerOn[iClient] = true;
			
				//Play the Announcer Sound
				decl Float:vec[3];
				GetClientEyePosition(iClient, vec);
				EmitAmbientSound(SOUND_GETITON, vec, iClient, SNDLEVEL_NORMAL);
				
				//Tell the user that the Announcer is on
				PrintHintText(iClient, "Announcer is now ON.");
			}
			else
				g_bAnnouncerOn[iClient] = false;
			
			// //VGUI Particle Descriptions Option
			// if(iOption[i++] == 1)
			// 	g_bEnabledVGUI[iClient] = false;
			// else
			// 	g_bEnabledVGUI[iClient] = false;
			
			//XP Display Option
			switch(iOption[i++])
			{
				case 0:		g_iXPDisplayMode[iClient] = 0;
				case 1:		g_iXPDisplayMode[iClient] = 1;
				case 2:		g_iXPDisplayMode[iClient] = 2;
			}
			
			//Set the user to be logged in
			g_bClientLoggedIn[iClient] = true;

			// Show user the confirm menu
			g_iOpenCharacterSelectAndDrawMenuState[iClient] = WAITING_ON_FINAL_BUTTON_FOR_CONFIRM_MENU;
			
			new Float:vec[3];
			GetClientAbsOrigin(iClient, vec);
			vec[2] += 10;
			EmitAmbientSound(SOUND_LOGIN, vec, iClient, SNDLEVEL_RAIDSIREN);
			
			PrintToChatAll("\x05<-=- \x03%N (Level %d) logged in\x05 -=->", iClient, g_iClientLevel[iClient]);
			PrintToServer(":-=-=-=-=-<[%N (Level %d) logged in]>-=-=-=-=-:", iClient, g_iClientLevel[iClient]);
		}
	}
	else if (bOnlyWebsiteChangableData == false)
	{
		PrintToChatAll("\x03[XPMod] \x05%N has joined", iClient);
		PrintToServer("[XPMod] %N has joined", iClient);
	}
	
	if (bDrawConfirmMenuAfter == true && g_bTalentsConfirmed[iClient] == false)
	{
		g_bUserStoppedConfirmation[iClient] = false;
		g_iAutoSetCountDown[iClient] = 20;

		delete g_hTimer_ShowingConfirmTalents[iClient];
		g_hTimer_ShowingConfirmTalents[iClient] = CreateTimer(1.0, TimerShowTalentsConfirmed, iClient, TIMER_REPEAT);
	}
	else if (bDrawTopMenuAfter == true)
	{
		TopMenuDraw(iClient);
	}

	// PrintToChatAll("GetUserData Callback Complete.  %i: %N", iClient, iClient);
	// PrintToServer("GetUserData Callback Complete.  %i: %N", iClient, iClient);
}

GetUserData(any:iClient, bool:bOnlyWebsiteChangableData = false, bool:bDrawConfirmMenuAfter = false, bool:bDrawTopMenuAfter = false)
{
	// PrintToChatAll("GetUserData. %i: %N, bOnlyWebsiteChangableData = %i", iClient, iClient, bOnlyWebsiteChangableData);
	// PrintToServer("GetUserData. %i: %N, bOnlyWebsiteChangableData = %i", iClient, iClient, bOnlyWebsiteChangableData);
	if(iClient == 0)
		iClient = 1;
	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}

	// Check if the client has a user ID yet, if not thats required first
	if (g_iDBUserID[iClient] == -1)
	{
		GetUserIDAndToken(iClient);
		return;
	}
	
	if (!IsClientInGame(iClient) || 
		IsFakeClient(iClient) || 
		(g_bClientLoggedIn[iClient] 
		&& bOnlyWebsiteChangableData == false))
		return;

	// If player already confirmed talents, return, but draw menu if needed
	if (g_bTalentsConfirmed[iClient])
	{
		if (bDrawTopMenuAfter)
			TopMenuDraw(iClient);
		
		return;
	}

	//PrintToServer("GetUserData %N: %i",iClient, g_iDBUserID[iClient]);

	// Save the new user data into the SQL database with the matching Steam ID
	decl String:strQuery[1024] = "";
	decl String:strAttributes[1024] = "";
	// Build the attribute strings for the query
	GetAttributesStringForQuery(strAttributes, sizeof(strAttributes), DB_COL_INDEX_USERS_XP, DB_COL_INDEX_USERS_OPTION_DISPLAY_XP);
	// Combine it all into the query
	Format(strQuery, sizeof(strQuery), "SELECT %s FROM %s WHERE user_id = %i", strAttributes, DB_TABLENAME, g_iDBUserID[iClient]);
	
	// Create a data pack to pass multiple parameters to the callback
	new Handle:hDataPackage = CreateDataPack();
	WritePackCell(hDataPackage, iClient);
	WritePackCell(hDataPackage, bOnlyWebsiteChangableData);
	WritePackCell(hDataPackage, bDrawConfirmMenuAfter);
	WritePackCell(hDataPackage, bDrawTopMenuAfter);

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
	{
		LogError("SQL Error: %s", error);
		return;
	}
	
	GetUserIDAndToken(iClient);
	
	//PrintToChatAll("New User Creation Callback Complete.  %i: %N", iClient, iClient);
	//PrintToServer("New User Creation Callback Complete.  %i: %N", iClient, iClient);
}

CreateNewUser(iClient)
{
	//PrintToChatAll("New User Creation.  %i: %N", iClient, iClient);
	//PrintToServer("New User Creation.  %i: %N", iClient, iClient);
	if(iClient == 0)
		iClient = 1;
	
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
	//Sanitize client name for the query
	ReplaceString(strClientName, sizeof(strClientName), "'", "-", true);

	//Get a new user token
	decl String:strUserToken[41];
	GenerateNewHashToken(strSteamID, strUserToken);
	
	//PrintToChatAll(strClientName);
	
	//Give bonus XP
	g_iClientXP[iClient] += 10000;
	
	//Get Client XP
	decl String:strClientXP[10];
	if(g_iClientXP[iClient]>99999999)
		IntToString(99999999, strClientXP, sizeof(strClientXP));
	else
		IntToString(g_iClientXP[iClient], strClientXP, sizeof(strClientXP));
	
	//Create new entry into the SQL database with the users information
	decl String:strQuery[256] = "";
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s ( \
		steam_id, \
		user_name, \
		token, \
		xp, \
		survivor_id, \
		infected_id_1, \
		infected_id_2, \
		infected_id_3) \
		VALUES ('%s', '%s', '%s', %s, '%i', '%i', '%i', %i)", 
		DB_TABLENAME,
		strSteamID,
		strClientName,
		strUserToken,
		strClientXP,
		g_iDefaultSurvivor,
		g_iDefaultInfectedSlot1,
		g_iDefaultInfectedSlot2,
		g_iDefaultInfectedSlot3);
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

	// Check if the client has a user ID yet
	if (g_iDBUserID[iClient] == -1)
		return;
		
	decl String:strSteamID[32], String:strClientName[32], String:strClientXP[10], String:strSurvivorID[3], 
		String:strInfectedID[3][2], String:strEquipmentSlotID[6][3], String:strOption[3][2];
	
	//Get SteamID
	GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID));
	
	//Get Client Name
	GetClientName(iClient, strClientName, sizeof(strClientName));
	//Sanitize client name for the query
	ReplaceString(strClientName, sizeof(strClientName), "'", "-", true);
	
	//Get Client XP
	if(g_iClientXP[iClient]>99999999)
		IntToString(99999999, strClientXP, sizeof(strClientXP));
	else
		IntToString(g_iClientXP[iClient], strClientXP, sizeof(strClientXP));
		
	//Get SurvivorID
	IntToString(g_iChosenSurvivor[iClient], strSurvivorID, sizeof(strSurvivorID))
	
	// //Get Survivor Talent IDs
	// switch(g_iChosenSurvivor[iClient])
	// {
	// 	case BILL:
	// 	{
	// 		IntToString(g_iInspirationalLevel[iClient], strSurvivorTalent[0], 2);
	// 		IntToString(g_iGhillieLevel[iClient], strSurvivorTalent[1], 2);
	// 		IntToString(g_iWillLevel[iClient], strSurvivorTalent[2], 2);
	// 		IntToString(g_iExorcismLevel[iClient], strSurvivorTalent[3], 2);
	// 		IntToString(g_iDiehardLevel[iClient], strSurvivorTalent[4], 2);
	// 		IntToString(g_iPromotionalLevel[iClient], strSurvivorTalent[5], 2);
	// 	}
	// 	case ROCHELLE:
	// 	{
	// 		IntToString(g_iGatherLevel[iClient], strSurvivorTalent[0], 2);
	// 		IntToString(g_iHunterLevel[iClient], strSurvivorTalent[1], 2);
	// 		IntToString(g_iSniperLevel[iClient], strSurvivorTalent[2], 2);
	// 		IntToString(g_iSilentLevel[iClient], strSurvivorTalent[3], 2);
	// 		IntToString(g_iSmokeLevel[iClient], strSurvivorTalent[4], 2);
	// 		IntToString(g_iShadowLevel[iClient], strSurvivorTalent[5], 2);
	// 	}
	// 	case COACH:
	// 	{
	// 		IntToString(g_iBullLevel[iClient], strSurvivorTalent[0], 2);
	// 		IntToString(g_iWreckingLevel[iClient], strSurvivorTalent[1], 2);
	// 		IntToString(g_iSprayLevel[iClient], strSurvivorTalent[2], 2);
	// 		IntToString(g_iHomerunLevel[iClient], strSurvivorTalent[3], 2);
	// 		IntToString(g_iLeadLevel[iClient], strSurvivorTalent[4], 2);
	// 		IntToString(g_iStrongLevel[iClient], strSurvivorTalent[5], 2);
	// 	}
	// 	case ELLIS:
	// 	{
	// 		IntToString(g_iOverLevel[iClient], strSurvivorTalent[0], 2);
	// 		IntToString(g_iBringLevel[iClient], strSurvivorTalent[1], 2);
	// 		IntToString(g_iJamminLevel[iClient], strSurvivorTalent[2], 2);
	// 		IntToString(g_iWeaponsLevel[iClient], strSurvivorTalent[3], 2);
	// 		IntToString(g_iMetalLevel[iClient], strSurvivorTalent[4], 2);
	// 		IntToString(g_iFireLevel[iClient], strSurvivorTalent[5], 2);
	// 	}
	// 	case NICK:
	// 	{
	// 		IntToString(g_iSwindlerLevel[iClient], strSurvivorTalent[0], 2);
	// 		IntToString(g_iLeftoverLevel[iClient], strSurvivorTalent[1], 2);
	// 		IntToString(g_iRiskyLevel[iClient], strSurvivorTalent[2], 2);
	// 		IntToString(g_iEnhancedLevel[iClient], strSurvivorTalent[3], 2);
	// 		IntToString(g_iMagnumLevel[iClient], strSurvivorTalent[4], 2);
	// 		IntToString(g_iDesperateLevel[iClient], strSurvivorTalent[5], 2);
	// 	}
	// }
	
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
		xp = %s, \
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
		WHERE user_id = '%i'", 
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
		g_iDBUserID[iClient]);
	
	SQL_TQuery(g_hDatabase, SQLSaveUserDataCallback, strQuery, iClient);
}

Logout(iClient)
{
	//PrintToChatAll("Logout. %i: %N", iClient, iClient);
	//PrintToServer("Logout. %i: %N", iClient, iClient);
	if(iClient==0)
	{
		iClient = 1;
		//PrintToServer("Server host cannot login through the console, go into chat and type /login to login in.");
		//return Plugin_Handled;
	}
	if(!RunClientChecks(iClient))
	 	return;

	ResetTalentConfirmCountdown(iClient);
	
	ResetAllOptions(iClient);

	if(g_bClientLoggedIn[iClient] == true)
	{
		ResetAll(iClient, iClient);
		g_iDBUserID[iClient] = -1;
		g_strDBUserToken[iClient] = "";
		g_bClientLoggedIn[iClient] = false;

		PrintToServer("\x03[XPMod] \x04%N Logged Out", iClient, iClient);
		return;
	}

	//PrintToChatAll("Logout Complete. %i: %N", iClient, iClient);
	//PrintToServer("Logout Complete. %i: %N", iClient, iClient);
	
	return;
}


GetAttributesStringForQuery(char[] strAttributes, int bufferSize, int startIndex, int endIndex)
{
	for (int i=startIndex; i<=endIndex; i++)
	{
		StrCat(strAttributes, bufferSize, strUsersTableColumnNames[i]);
		int len = strlen(strAttributes);
		strAttributes[len] = ',';
		strAttributes[len+1] = '\0';
	}
	// Remove the last comma
	strAttributes[strlen(strAttributes)-1] = '\0';
}

GenerateNewHashToken(const char[] strSteamID, char[] strToken)
{
	// Generate 3 random numbers to append to the end of the steam id to act as salt for the hash
	int num1 = GetURandomInt();
	int num2 = GetURandomInt();
	int num3 = GetURandomInt();

	decl String:strValueToHash[64] = "";
	Format(strValueToHash, sizeof(strValueToHash), "%s%i%i%i", strSteamID, num1, num2, num3);

	SHA1String(strValueToHash, strToken, true);
}