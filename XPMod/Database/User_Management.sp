//Callback function for an SQL SQLGetUserIDAndToken
SQLGetUserIDAndTokenCallback(Handle owner, Handle hQuery, const char[] error, any iClient)
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
		//LogError("SQLGetUserIDAndTokenCallback: INVALID ENTITY OR IS FAKE CLIENT");
		return;
	}
	
	if(!StrEqual("", error))
	{
		LogError("SQL Error: %s", error);
		return;
	}
	
	char strData[50];
	
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

GetUserIDAndToken(any iClient)
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
	
	//Get Steam Auth ID, if this returns false, then do not proceed
	char strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
	{
		KickClientCannotGetSteamID(iClient);
		return;
	}
	
	// Save the new user data into the SQL database with the matching Steam ID
	char strQuery[1024];
	strQuery[0] = '\0';
	// Combine it all into the query
	Format(strQuery, sizeof(strQuery), "SELECT %s,%s FROM %s WHERE steam_id = '%s'", strUsersTableColumnNames[DB_COL_INDEX_USERS_USER_ID], strUsersTableColumnNames[DB_COL_INDEX_USERS_TOKEN], DB_TABLENAME_USERS, strSteamID);

	SQL_TQuery(g_hDatabase, SQLGetUserIDAndTokenCallback, strQuery, iClient);
}

//Callback function for an SQL GetUserData
SQLGetUserDataCallback(Handle owner, Handle hQuery, const char[] error, any hDataPack)
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
		//LogError("SQLGetUserDataCallback: INVALID ENTITY OR IS FAKE CLIENT");
		return;
	}
	
	if(!StrEqual("", error))
	{
		LogError("SQL Error: %s", error);
		return;
	}
	
	char strData[20];
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

		//Get Client Prestige Points from the SQL database and level up player accordingly
		iFieldIndex = DB_COL_INDEX_PRESTIGE_POINTS - startFieldIndexOffset;
		if(SQL_FetchString(hQuery, iFieldIndex, strData, sizeof(strData)) != 0)
		{
			g_iClientPrestigePoints[iClient] = StringToInt(strData);
		}
		else
			LogError("SQL Error getting Prestige Points string from query");

		// Reset Survivor Classes and Talent Levels
		ResetSurvivorTalents(iClient);

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
				float vec[3];
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
			
			float vec[3];
			GetClientAbsOrigin(iClient, vec);
			vec[2] += 10;
			EmitAmbientSound(SOUND_LOGIN, vec, iClient, SNDLEVEL_RAIDSIREN);
			
			// PrintToChatAll("\x05<-=- \x03[%i] %N logged in\x05 -=->", g_iClientLevel[iClient], iClient);
			PrintToServer(":-=-=-=-=-<[%N (%d) logged in]>-=-=-=-=-:", iClient, g_iClientLevel[iClient]);
		}
	}
	else if (bOnlyWebsiteChangableData == false)
	{
		PrintToChatAll("\x03[XPMod] \x05%N has joined", iClient);
		PrintToServer("[XPMod] %N has joined", iClient);
	}
	
	// Draw the appropriate menu
	if (bDrawConfirmMenuAfter == true && g_bTalentsConfirmed[iClient] == false)
		DrawConfirmationMenuToClient(iClient);
	else if (bDrawTopMenuAfter == true)
		TopMenuDraw(iClient);
	
	// PrintToChatAll("GetUserData Callback Complete.  %i: %N", iClient, iClient);
	// PrintToServer("GetUserData Callback Complete.  %i: %N", iClient, iClient);
}

GetUserData(any iClient, bool bOnlyWebsiteChangableData = false, bool bDrawConfirmMenuAfter = false, bool bDrawTopMenuAfter = false)
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
	char strQuery[1024], strAttributes[1024];
	strQuery[0] = '\0';
	strAttributes[0] = '\0';
	// Build the attribute strings for the query
	GetAttributesStringForQuery(strAttributes, sizeof(strAttributes), DB_COL_INDEX_USERS_XP, DB_COL_INDEX_PUSH_UPDATE_FROM_DB);
	// Combine it all into the query
	Format(strQuery, sizeof(strQuery), "SELECT %s FROM %s WHERE user_id = %i", strAttributes, DB_TABLENAME_USERS, g_iDBUserID[iClient]);
	
	// Create a data pack to pass multiple parameters to the callback
	Handle hDataPackage = CreateDataPack();
	WritePackCell(hDataPackage, iClient);
	WritePackCell(hDataPackage, bOnlyWebsiteChangableData);
	WritePackCell(hDataPackage, bDrawConfirmMenuAfter);
	WritePackCell(hDataPackage, bDrawTopMenuAfter);
	
	SQL_TQuery(g_hDatabase, SQLGetUserDataCallback, strQuery, hDataPackage);
}

//Callback function for an SQL CreateNewUser
SQLCreateNewUserCallback(Handle owner, Handle hQuery, const char[] error, any iClient)
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
	
	//Get Steam Auth ID, if this returns false, then do not proceed
	char strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
	{
		KickClientCannotGetSteamID(iClient);
		return;
	}
	
	//Get Client Name
	char strClientName[32];
	GetClientName(iClient, strClientName, sizeof(strClientName));
	SanitizeValueStringForQuery(strClientName, sizeof(strClientName));

	//Get a new user token
	char strUserToken[41];
	GenerateNewHashToken(strSteamID, strUserToken);
	
	//Give bonus XP (called twice apparently)
	//g_iClientXP[iClient] += 10000;
	
	//Get Client XP
	char strClientXP[10];
	if(g_iClientXP[iClient]>99999999)
		IntToString(99999999, strClientXP, sizeof(strClientXP));
	else
		IntToString(g_iClientXP[iClient], strClientXP, sizeof(strClientXP));
	
	//Create new entry into the SQL database with the users information
	char strQuery[512];
	strQuery[0] = '\0';
	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (\
		steam_id,\
		user_name,\
		token,\
		xp,\
		prestige_points,\
		survivor_id,\
		infected_id_1,\
		infected_id_2,\
		infected_id_3,\
		equipment_primary,\
		equipment_secondary,\
		equipment_health,\
		equipment_explosive,\
		equipment_boost)\
		VALUES ('%s','%s','%s',%s,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i)", 
		DB_TABLENAME_USERS,
		strSteamID,
		strClientName,
		strUserToken,
		strClientXP,
		0,
		g_iDefaultSurvivor,
		g_iDefaultInfectedSlot1,
		g_iDefaultInfectedSlot2,
		g_iDefaultInfectedSlot3,
		DEFAULT_LOADOUT_PRIMARY_ID,
		DEFAULT_LOADOUT_SECONDARY_ID,
		DEFAULT_LOADOUT_HEALTH_ID,
		DEFAULT_LOADOUT_EXPLOSIVE_ID,
		DEFAULT_LOADOUT_BOOST_ID);
	SQL_TQuery(g_hDatabase, SQLCreateNewUserCallback, strQuery, iClient);
}

SaveUserData(int iClient)
{
	// First get if the player has updated data from the database
	// After this, this will save the new data in the database
	SQLCheckForChangeThenSaveData(iClient);
}

//Callback function for an SQL SaveUserData
SQLSaveUserDataInDatabaseCallback(Handle owner, Handle hQuery, const char[] error, any iClient)
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

SaveUserDataInDatabase(iClient)
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

	if (RunClientChecks(iClient) == false)
		return;
	
	if (!g_bClientLoggedIn[iClient] || g_iClientXP[iClient]<0)
		return;

	// Check if the client has a user ID yet
	if (g_iDBUserID[iClient] == -1)
		return;
		
	char strClientName[32], strClientXP[10], strSurvivorID[3], 
		strInfectedID[3][2], strEquipmentSlotID[6][3], strOption[3][2];
	
	//Get Steam Auth ID, if this returns false, then do not proceed
	char strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
	{
		KickClientCannotGetSteamID(iClient);
		return;
	}
	
	//Get Client Name
	GetClientName(iClient, strClientName, sizeof(strClientName));
	//Sanitize client name for the query
	SanitizeValueStringForQuery(strClientName, sizeof(strClientName));
	
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

	// Build the user's query data to save
	char strQuery[1024], strQueryPart[1024];
	// Start the query
	Format(strQuery, sizeof(strQuery), "\
		UPDATE %s SET ", 
		DB_TABLENAME_USERS);

	// Client Name update
	Format(strQueryPart, sizeof(strQuery), "\
		user_name = '%s', ", 
		strClientName);
	StrCat(strQuery, sizeof(strQuery), strQueryPart);

	// XP
	// Only save new xp if its enabled or the player is below 2x the Max Level XP Amount
	if (XPSaveForHighLevelsEnabled || g_iClientXP[iClient] < LEVEL_30 * 2)
	{
		Format(strQueryPart, sizeof(strQueryPart), "\
		xp = %s, ", 
		strClientXP);
		StrCat(strQuery, sizeof(strQuery), strQueryPart);
	}

	// Classes
	Format(strQueryPart, sizeof(strQueryPart), "\
		survivor_id = %s, \
		infected_id_1 = %s, \
		infected_id_2 = %s, \
		infected_id_3 = %s, ", 
		strSurvivorID,
		strInfectedID[0],
		strInfectedID[1],
		strInfectedID[2]);
	StrCat(strQuery, sizeof(strQuery), strQueryPart);

	// Equipment
	Format(strQueryPart, sizeof(strQueryPart), "\
		equipment_primary = %s, \
		equipment_secondary = %s, \
		equipment_explosive = %s, \
		equipment_health = %s, \
		equipment_boost = %s, \
		equipment_laser = %s, ", 
		strEquipmentSlotID[0],
		strEquipmentSlotID[1],
		strEquipmentSlotID[2],
		strEquipmentSlotID[3],
		strEquipmentSlotID[4],
		strEquipmentSlotID[5]);
	StrCat(strQuery, sizeof(strQuery), strQueryPart);

	// Options
	Format(strQueryPart, sizeof(strQueryPart), "\
		option_announcer  = %s, \
		option_display_xp = %s, ", 
		strOption[0],
		strOption[2]);
	StrCat(strQuery, sizeof(strQuery), strQueryPart);

	// Set the Push Update Flag to 0 since
	// it should have already grabbed before running this
	Format(strQueryPart, sizeof(strQueryPart), "\
		push_update_from_db = %i ", 
		0);
	StrCat(strQuery, sizeof(strQuery), strQueryPart);

	// WHERE Criteria Clause
	Format(strQueryPart, sizeof(strQueryPart), "\
		WHERE user_id = '%i'", 
		g_iDBUserID[iClient]);
	StrCat(strQuery, sizeof(strQuery), strQueryPart);

	// PrintToServer("                   %s", strQuery);
	
	SQL_TQuery(g_hDatabase, SQLSaveUserDataInDatabaseCallback, strQuery, iClient);
}

//Callback function for an SQL SQLCheckForChangeThenSaveData
SQLCheckForChangeThenSaveDataCallback(Handle owner, Handle hQuery, const char[] error, any iClient)
{
	// PrintToChatAll("SQLCheckForChangeThenSaveDataCallback Started. %i: %N", iClient, iClient);
	// PrintToServer("SQLCheckForChangeThenSaveDataCallback Started. %i: %N", iClient, iClient);

	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}

	if (IsValidEntity(iClient) == false || IsFakeClient(iClient))
	{
		//LogError("SQLGetUserIDAndTokenCallback: INVALID ENTITY OR IS FAKE CLIENT");
		return;
	}
	
	if(!StrEqual("", error))
	{
		LogError("SQL Error: %s", error);
		return;
	}
	
	char strData[50];
	
	if(SQL_FetchRow(hQuery) == false)
	{
		LogError("SQL Error SQL_FetchRow failed");
		return;
	}

	// Get Client's Push Update From Database flag
	if(SQL_FetchString(hQuery, 0, strData, sizeof(strData)) == 0)
	{
		LogError("SQL Error getting USER_ID string from query");
		return;
	}

	
	if (StringToInt(strData) == 1)
	{
		// Get Client's XP from the database and overwrite current xp in the server
		if(SQL_FetchString(hQuery, 1, strData, sizeof(strData)) == 0)
		{
			LogError("SQL Error getting XP string from query");
			return;
		}

		g_iClientXP[iClient] = StringToInt(strData);
	}
	
	// Now we can safely save the XP
	SaveUserDataInDatabase(iClient);

	// PrintToChatAll("SQLCheckForChangeThenSaveData Callback Complete.  %i: %N", iClient, iClient);
	// PrintToServer("SQLCheckForChangeThenSaveData Callback Complete.  %i: %N", iClient, iClient);
}

// This is for when an update happens in the database and the user connected needs to have his XP force updated on the server they are playing
void SQLCheckForChangeThenSaveData(any iClient)
{
	// PrintToChatAll("SQLCheckForChangeThenSaveData. %i: %N", iClient, iClient);
	// PrintToServer("SQLCheckForChangeThenSaveData. %i: %N", iClient, iClient);
	if(iClient == 0)
		iClient = 1;
	
	if (g_hDatabase == INVALID_HANDLE)
	{
		PrintToChatAll("Unable to connect to XPMod SQL Database.");
		return;
	}
	
	if (RunClientChecks(iClient) == false || g_bClientLoggedIn[iClient] == false)
		return;
	
	//Get Steam Auth ID, if this returns false, then do not proceed
	char strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
	{
		KickClientCannotGetSteamID(iClient);
		return;
	}
	
	// Get if there was an update we need to force push to the player in the server SQL database with the matching Steam ID
	char strQuery[1024];
	strQuery[0] = '\0';
	// Combine it all into the query
	Format(strQuery, sizeof(strQuery), "SELECT %s,%s FROM %s WHERE steam_id = '%s'", strUsersTableColumnNames[DB_COL_INDEX_PUSH_UPDATE_FROM_DB], strUsersTableColumnNames[DB_COL_INDEX_USERS_XP], DB_TABLENAME_USERS, strSteamID);

	// PrintToServer("                   %s", strQuery);

	SQL_TQuery(g_hDatabase, SQLCheckForChangeThenSaveDataCallback, strQuery, iClient);
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
		ResetAll(iClient);
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
	// Ensure callers never inherit stale stack data.
	strAttributes[0] = '\0';

	for (int i=startIndex; i<=endIndex; i++)
	{
		if (strAttributes[0] != '\0')
			StrCat(strAttributes, bufferSize, ",");

		StrCat(strAttributes, bufferSize, strUsersTableColumnNames[i]);
	}
}

GenerateNewHashToken(const char[] strSteamID, char[] strToken)
{
	// Generate 3 random numbers to append to the end of the steam id to act as salt for the hash
	int num1 = GetURandomInt();
	int num2 = GetURandomInt();
	int num3 = GetURandomInt();

	char strValueToHash[64];
	strValueToHash[0] = '\0';
	Format(strValueToHash, sizeof(strValueToHash), "%s%i%i%i", strSteamID, num1, num2, num3);

	SHA1String(strValueToHash, strToken, true);
}

SanitizeValueStringForQuery(char[] strValue, iStringSize)
{
	// Remove all the characters that can exploit or break a query
	ReplaceString(strValue, iStringSize, "'", "-", true);
	ReplaceString(strValue, iStringSize, "\"", "-", true);
	ReplaceString(strValue, iStringSize, "\\", "-", true);
}

KickClientCannotGetSteamID(iClient)
{
	KickClient(iClient, "Unable to obtain your Steam Auth ID. \
		Please close L4D2, restart Steam, then restart L4D2 with Steam already open");
	LogError("GetClientAuthId failed for %N", iClient);
}
