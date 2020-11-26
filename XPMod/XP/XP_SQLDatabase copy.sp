//SQL Database File Functions

// bool:ConnectDB()
// {	
// 	new Handle:hKeyValues = CreateKeyValues("sql");
// 	KvSetString(hKeyValues, "driver", "mysql");
// 	KvSetString(hKeyValues, "host", DB_HOST);
// 	KvSetString(hKeyValues, "database", DB_DATABASE);
// 	KvSetString(hKeyValues, "user", DB_USER);
// 	KvSetString(hKeyValues, "pass", DB_PASSWORD);

// 	decl String:error[255];
// 	g_hDatabase = SQL_ConnectCustom(hKeyValues, error, sizeof(error), true);
// 	CloseHandle(hKeyValues);

// 	if (g_hDatabase == INVALID_HANDLE)
// 	{
// 		LogError("MySQL Connection For XPMod User Database Failed: %s", error);
// 		return false;
// 	}
	
// 	return true;
// }

// //Callback function for an SQL SaveUserData
// public SQLGetUserDataCallback(Handle:owner, Handle:hQuery, const String:error[], any:hDataPack)
// {
// 	if (hDataPack == INVALID_HANDLE)
// 	{
// 		LogError("SQLGetUserDataCallback: INVALID HANDLE on hDataPack");
// 		return;
// 	}
// 	ResetPack(hDataPack);
// 	new iClient = ReadPackCell(hDataPack);
// 	bool bOnlyWebsiteChangableData = ReadPackCell(hDataPack);
// 	CloseHandle(hDataPack);

// 	// PrintToChatAll("GetUserData Callback Started. %i: %N", iClient, iClient);
// 	// PrintToServer("GetUserData Callback Started. %i: %N", iClient, iClient);

// 	if (g_hDatabase == INVALID_HANDLE)
// 	{
// 		PrintToChatAll("Unable to connect to XPMod SQL Database.");
// 		return;
// 	}

// 	if (IsValidEntity(iClient) == false || IsFakeClient(iClient))
// 	{
// 		LogError("SQLGetUserDataCallback: INVALID ENTITY OR IS FAKE CLIENT");
// 		return;
// 	}
	
// 	if(!StrEqual("", error))
// 	{
// 		LogError("SQL Error: %s", error);
// 		return;
// 	}
	
// 	decl String:strData[16], iSurvivorTalent[6],  iInfectedID[3], iEquipmentSlot[6], iOption[3];
// 	new iColumn = 0, iSkillPointsUsed = 0;
	
// 	if (bOnlyWebsiteChangableData == false)
// 	{
// 		ResetSkillPoints(iClient, iClient);
// 	}
	
// 	if(SQL_FetchRow(hQuery))
// 	{
// 		if (bOnlyWebsiteChangableData == false)
// 		{
// 			//Get Client XP from the SQL database
// 			if(SQL_FetchString(hQuery, iColumn++, strData, sizeof(strData)) != 0)
// 				g_iClientXP[iClient] += StringToInt(strData);
// 			else
// 				LogError("SQL Error getting XP string from query");
		
// 			//Get survivor character id from the SQL database
// 			if(SQL_FetchString(hQuery, iColumn++, strData, sizeof(strData)) != 0)
// 				g_iChosenSurvivor[iClient] = StringToInt(strData);
// 			else
// 				LogError("SQL Error getting SurvivorID string from query");
			
// 			//Get Survivor Talent Levels from the SQL database
// 			for(new i = 0; i < 6; i++)
// 			{
// 				if(SQL_FetchString(hQuery, iColumn++, strData, sizeof(strData)) != 0)
// 					iSurvivorTalent[i] = StringToInt(strData);
// 				else
// 					LogError("SQL Error getting SurvivorTalent[%d] string from query", i);
// 			}
// 		}
		
// 		//Get Infecteed Talent ID from the SQL database
// 		iColumn = 8;
// 		for(new i = 0; i < 3; i++)
// 		{
// 			if(SQL_FetchString(hQuery, iColumn++, strData, sizeof(strData)) != 0)
// 			{
// 				PrintToServer("iInfectedID[%d] strData:&s ", i, strData)
// 				iInfectedID[i] = StringToInt(strData);
// 			}
// 			else
// 				LogError("SQL Error getting iInfectedID[%d] string from query", i);
// 		}
		
// 		if (bOnlyWebsiteChangableData == false)
// 		{
// 			//Get Equipment slot IDs from the SQL database
// 			for(new i = 0; i < 6; i++)
// 			{
// 				if(SQL_FetchString(hQuery, iColumn++, strData, sizeof(strData)) != 0)
// 					iEquipmentSlot[i] = StringToInt(strData);
// 				else
// 					LogError("SQL Error getting iEquipmentSlot[%d] string from query", i);
// 			}
			
// 			//Get the user's Options from the SQL database
// 			for(new i = 0; i < 3; i++)
// 			{
// 				if(SQL_FetchString(hQuery, iColumn++, strData, sizeof(strData)) != 0)
// 					iOption[i] = StringToInt(strData);
// 				else
// 					LogError("SQL Error getting iOption[%d] string from query", i);
// 			}
			
// 			//Set Survivor Classe Levels
// 			switch(g_iChosenSurvivor[iClient])
// 			{
// 				case BILL:
// 				{
// 					g_iInspirationalLevel[iClient] = iSurvivorTalent[0];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iInspirationalLevel[iClient];
					
// 					g_iGhillieLevel[iClient] = iSurvivorTalent[1];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iGhillieLevel[iClient];
					
// 					g_iWillLevel[iClient] = iSurvivorTalent[2];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iWillLevel[iClient];
					
// 					g_iExorcismLevel[iClient] = iSurvivorTalent[3];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iExorcismLevel[iClient];
					
// 					g_iDiehardLevel[iClient] = iSurvivorTalent[4];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iDiehardLevel[iClient];
					
// 					g_iPromotionalLevel[iClient] = iSurvivorTalent[5];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iPromotionalLevel[iClient];
// 				}
// 				case ROCHELLE:
// 				{
// 					g_iGatherLevel[iClient] = iSurvivorTalent[0];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iGatherLevel[iClient];
					
// 					g_iHunterLevel[iClient] = iSurvivorTalent[1];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iHunterLevel[iClient];
					
// 					g_iSniperLevel[iClient] = iSurvivorTalent[2];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iSniperLevel[iClient];
					
// 					g_iSilentLevel[iClient] = iSurvivorTalent[3];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iSilentLevel[iClient];
					
// 					g_iSmokeLevel[iClient] = iSurvivorTalent[4];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iSmokeLevel[iClient];
					
// 					g_iShadowLevel[iClient] = iSurvivorTalent[5];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iShadowLevel[iClient];
// 				}
// 				case COACH:
// 				{
// 					g_iBullLevel[iClient] = iSurvivorTalent[0];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iBullLevel[iClient];
					
// 					g_iWreckingLevel[iClient] = iSurvivorTalent[1];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iWreckingLevel[iClient];
					
// 					g_iSprayLevel[iClient] = iSurvivorTalent[2];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iSprayLevel[iClient];
					
// 					g_iHomerunLevel[iClient] = iSurvivorTalent[3];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iHomerunLevel[iClient];
					
// 					g_iLeadLevel[iClient] = iSurvivorTalent[4];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iLeadLevel[iClient];
					
// 					g_iStrongLevel[iClient] = iSurvivorTalent[5];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iStrongLevel[iClient];
// 				}
// 				case ELLIS:
// 				{
// 					g_iOverLevel[iClient] = iSurvivorTalent[0];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iOverLevel[iClient];
					
// 					g_iBringLevel[iClient] = iSurvivorTalent[1];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iBringLevel[iClient];
					
// 					g_iJamminLevel[iClient] = iSurvivorTalent[2];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iJamminLevel[iClient];
					
// 					g_iWeaponsLevel[iClient] = iSurvivorTalent[3];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iWeaponsLevel[iClient];
					
// 					g_iMetalLevel[iClient] = iSurvivorTalent[4];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iMetalLevel[iClient];
					
// 					g_iFireLevel[iClient] = iSurvivorTalent[5];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iFireLevel[iClient];
// 				}
// 				case NICK:
// 				{
// 					g_iSwindlerLevel[iClient] = iSurvivorTalent[0];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iSwindlerLevel[iClient];
					
// 					g_iLeftoverLevel[iClient] = iSurvivorTalent[1];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iLeftoverLevel[iClient];
					
// 					g_iRiskyLevel[iClient] = iSurvivorTalent[2];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iRiskyLevel[iClient];
					
// 					g_iEnhancedLevel[iClient] = iSurvivorTalent[3];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iEnhancedLevel[iClient];
					
// 					g_iMagnumLevel[iClient] = iSurvivorTalent[4];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iMagnumLevel[iClient];
					
// 					g_iDesperateLevel[iClient] = iSurvivorTalent[5];
// 					iSkillPointsUsed = iSkillPointsUsed + g_iDesperateLevel[iClient];
// 				}
// 			}
// 		}
		
// 		//Set Infected Classes
// 		g_iClientInfectedClass1[iClient] = iInfectedID[0];
// 		g_iClientInfectedClass2[iClient] = iInfectedID[1];
// 		g_iClientInfectedClass3[iClient] = iInfectedID[2];

// 		//Set the infected class strings
// 		SetInfectedClassSlot(iClient, 1, g_iClientInfectedClass1[iClient]);
// 		SetInfectedClassSlot(iClient, 2, g_iClientInfectedClass2[iClient]);
// 		SetInfectedClassSlot(iClient, 3, g_iClientInfectedClass3[iClient]);

// 		if (bOnlyWebsiteChangableData == false)
// 		{
// 			//Calculate level and next level g_iClientXP
// 			calclvlandnextxp(iClient);
			
// 			//Calculate g_iSkillPoints
// 			g_iSkillPoints[iClient] = g_iClientLevel[iClient] - iSkillPointsUsed;
// 			g_iInfectedLevel[iClient] = RoundToFloor(g_iClientLevel[iClient] * 0.5);
// 			//iskillpoints[iClient] = g_iInfectedLevel[iClient] * 3;
		

		
// 			//Set the user's survivor equipment
// 			g_iClientPrimarySlotID[iClient] = iEquipmentSlot[0];
// 			g_iClientSecondarySlotID[iClient] = iEquipmentSlot[1];
// 			g_iClientExplosiveSlotID[iClient] = iEquipmentSlot[2];
// 			g_iClientHealthSlotID[iClient] = iEquipmentSlot[3];
// 			g_iClientBoostSlotID[iClient] = iEquipmentSlot[4];
// 			g_iClientLaserSlotID[iClient] = iEquipmentSlot[5];
		
// 			//Get loadout weapon names and g_iClientXP costs
// 			GetWeaponNames(iClient);
		
// 			new i = 0;
// 			//Set the user's XPMod Options
// 			if(iOption[i++] == 1)
// 			{
// 				//Turn the Announcer on
// 				g_bAnnouncerOn[iClient] = true;
			
// 				//Play the Announcer Sound
// 				decl Float:vec[3];
// 				GetClientEyePosition(iClient, vec);
// 				EmitAmbientSound(SOUND_GETITON, vec, iClient, SNDLEVEL_NORMAL);
				
// 				//Tell the user that the Announcer is on
// 				PrintHintText(iClient, "Announcer is now ON.");
// 			}
// 			else
// 				g_bAnnouncerOn[iClient] = false;
			
// 			//VGUI Particle Descriptions Option
// 			if(iOption[i++] == 1)
// 				g_bEnabledVGUI[iClient] = false;
// 			else
// 				g_bEnabledVGUI[iClient] = false;
			
// 			//XP Display Option
// 			switch(iOption[i++])
// 			{
// 				case 0:		g_iXPDisplayMode[iClient] = 0;
// 				case 1:		g_iXPDisplayMode[iClient] = 1;
// 				case 2:		g_iXPDisplayMode[iClient] = 2;
// 			}
			
// 			//Set the user to be logged in
// 			g_bClientLoggedIn[iClient] = true;
			
// 			PrintToChatAll("\x05<-=- \x03%N (Level %d) has joined\x05 -=->", iClient, g_iClientLevel[iClient]);
// 			PrintToServer(":-=-=-=-=-<[%N (Level %d) logged in]>-=-=-=-=-:", iClient, g_iClientLevel[iClient]);
// 			PrintHintText(iClient, "Welcome back %N", iClient);
// 		}
// 	}
// 	else if (bOnlyWebsiteChangableData == false)
// 	{
// 		PrintToChatAll("\x03[XPMod] %N has no account.", iClient);
// 		PrintToServer("[XPMod] %N has no account.", iClient);
// 	}

// 	// PrintToChatAll("GetUserData Callback Complete.  %i: %N", iClient, iClient);
// 	// PrintToServer("GetUserData Callback Complete.  %i: %N", iClient, iClient);
// }

// GetUserData(any:iClient, bool:bOnlyWebsiteChangableData = false)
// {
// 	// PrintToChatAll("GetUserData. %i: %N", iClient, iClient);
// 	// PrintToServer("GetUserData. %i: %N", iClient, iClient);
// 	if(iClient == 0)
// 		iClient = 1;
	
// 	if (g_hDatabase == INVALID_HANDLE)
// 	{
// 		PrintToChatAll("Unable to connect to XPMod SQL Database.");
// 		return;
// 	}
	
// 	if (!IsClientInGame(iClient) || IsFakeClient(iClient) || (g_bClientLoggedIn[iClient] && bOnlyWebsiteChangableData == false))
// 		return;
	
// 	//Get SteamID
// 	decl String:strSteamID[32];
// 	GetClientAuthString(iClient, strSteamID, sizeof(strSteamID));
	
// 	//Save the new user data into the SQL database with the matching Steam ID
// 	decl String:strQuery[1024];
// 	Format(strQuery, sizeof(strQuery), "SELECT XP, SurvivorID, SurvivorTalent1, SurvivorTalent2, SurvivorTalent3, SurvivorTalent4, SurvivorTalent5, SurvivorTalent6, InfectedID1, InfectedID2, InfectedID3, EquipmentPrimary, EquipmentSecondary, EquipmentExplosive, EquipmentHealth, EquipmentBoost, EquipmentLaser, OptionAnnouncer, OptionSurvivorVGUI, OptionXPDisplay FROM %s WHERE SteamID = '%s'", DB_TABLENAME, strSteamID);
	
// 	// Create a data pack to pass multiple parameters to the callback
// 	new Handle:hDataPackage = CreateDataPack();
// 	WritePackCell(hDataPackage, iClient);
// 	WritePackCell(hDataPackage, bOnlyWebsiteChangableData);

// 	SQL_TQuery(g_hDatabase, SQLGetUserDataCallback, strQuery, hDataPackage);
// }

// //Callback function for an SQL CreateNewUser
// public SQLCreateNewUserCallback(Handle:owner, Handle:hQuery, const String:error[], any:iClient)
// {
// 	if (g_hDatabase == INVALID_HANDLE)
// 	{
// 		PrintToChatAll("Unable to connect to XPMod SQL Database.");
// 		return;
// 	}
	
// 	if (!IsClientInGame(iClient) || IsFakeClient(iClient))
// 		return;
	
// 	if(!StrEqual("", error))
// 		LogError("SQL Error: %s", error);
// 	else
// 		g_bClientLoggedIn[iClient] = true;
	
// 	//PrintToChatAll("New User Creation Callback Complete.  %i: %N", iClient, iClient);
// 	//PrintToServer("New User Creation Callback Complete.  %i: %N", iClient, iClient);
// }

// CreateNewUser(iClient)
// {
// 	//PrintToChatAll("New User Creation.  %i: %N", iClient, iClient);
// 	//PrintToServer("New User Creation.  %i: %N", iClient, iClient);
// 	if(iClient == 0)
// 		iClient = 1;
	
// 	//g_bClientLoggedIn[iClient] = true;
	
// 	if (g_hDatabase == INVALID_HANDLE)
// 	{
// 		PrintToChatAll("Unable to connect to XPMod SQL Database.");
// 		return;
// 	}
		
// 	if(!IsClientInGame(iClient) || IsFakeClient(iClient) || g_bClientLoggedIn[iClient])
// 		return;
	
// 	//Get SteamID
// 	decl String:strSteamID[32];
// 	GetClientAuthString(iClient, strSteamID, sizeof(strSteamID));
	
// 	//Get Client Name
// 	decl String:strClientName[32];
// 	GetClientName(iClient, strClientName, sizeof(strClientName));
	
// 	//PrintToChatAll(strClientName);
	
// 	//Give bonus XP
// 	//g_iClientXP[iClient] += 10000;
	
// 	//Get Client XP
// 	decl String:strClientXP[10];
// 	if(g_iClientXP[iClient]>99999999)
// 		IntToString(99999999, strClientXP, sizeof(strClientXP));
// 	else
// 		IntToString(g_iClientXP[iClient], strClientXP, sizeof(strClientXP));
	
// 	//Create new entry into the SQL database with the users information
// 	decl String:strQuery[256];
// 	Format(strQuery, sizeof(strQuery), "INSERT INTO %s (SteamID, ClientName, XP) VALUES ('%s', '%s', %s)", DB_TABLENAME, strSteamID, strClientName, strClientXP);
// 	SQL_TQuery(g_hDatabase, SQLCreateNewUserCallback, strQuery, iClient);
// }

// //Callback function for an SQL SaveUserData
// public SQLSaveUserDataCallback(Handle:owner, Handle:hQuery, const String:error[], any:iClient)
// {
// 	if (g_hDatabase == INVALID_HANDLE)
// 	{
// 		PrintToChatAll("Unable to connect to XPMod SQL Database.");
// 		return;
// 	}
	
// 	if(!StrEqual("", error))
// 		LogError("SQL Error: %s", error);

// 	// PrintToChatAll("Save User Data Callback Complete. %i: %N", iClient, iClient);
// 	// PrintToServer("Save User Data Callback Complete. %i: %N", iClient, iClient);
// }

// SaveUserData(iClient)
// {
// 	// PrintToChatAll("Save User Data. %i: %N", iClient, iClient);
// 	// PrintToServer("Save User Data. %i: %N", iClient, iClient);
// 	if(iClient == 0)
// 		iClient = 1;
	
// 	if (g_hDatabase == INVALID_HANDLE)
// 	{
// 		PrintToChatAll("Unable to connect to XPMod SQL Database.");
// 		return;
// 	}	
	
// 	if (!g_bClientLoggedIn[iClient] || g_iClientXP[iClient]<0)
// 		return;
		
// 	decl String:strSteamID[32], String:strClientName[32], String:strClientXP[10], String:strSurvivorID[3], 
// 		String:strSurvivorTalent[6][2], String:strInfectedID[3][2], String:strEquipmentSlotID[6][3], String:strOption[3][2];
	
// 	//Get SteamID
// 	GetClientAuthString(iClient, strSteamID, sizeof(strSteamID));
	
// 	//Get Client Name
// 	GetClientName(iClient, strClientName, sizeof(strClientName));
	
// 	//Get Client XP
// 	if(g_iClientXP[iClient]>99999999)
// 		IntToString(99999999, strClientXP, sizeof(strClientXP));
// 	else
// 		IntToString(g_iClientXP[iClient], strClientXP, sizeof(strClientXP));
		
// 	//Get SurvivorID
// 	IntToString(g_iChosenSurvivor[iClient], strSurvivorID, sizeof(strSurvivorID))
	
// 	//Get Survivor Talent IDs
// 	switch(g_iChosenSurvivor[iClient])
// 	{
// 		case BILL:
// 		{
// 			IntToString(g_iInspirationalLevel[iClient], strSurvivorTalent[0], 2);
// 			IntToString(g_iGhillieLevel[iClient], strSurvivorTalent[1], 2);
// 			IntToString(g_iWillLevel[iClient], strSurvivorTalent[2], 2);
// 			IntToString(g_iExorcismLevel[iClient], strSurvivorTalent[3], 2);
// 			IntToString(g_iDiehardLevel[iClient], strSurvivorTalent[4], 2);
// 			IntToString(g_iPromotionalLevel[iClient], strSurvivorTalent[5], 2);
// 		}
// 		case ROCHELLE:
// 		{
// 			IntToString(g_iGatherLevel[iClient], strSurvivorTalent[0], 2);
// 			IntToString(g_iHunterLevel[iClient], strSurvivorTalent[1], 2);
// 			IntToString(g_iSniperLevel[iClient], strSurvivorTalent[2], 2);
// 			IntToString(g_iSilentLevel[iClient], strSurvivorTalent[3], 2);
// 			IntToString(g_iSmokeLevel[iClient], strSurvivorTalent[4], 2);
// 			IntToString(g_iShadowLevel[iClient], strSurvivorTalent[5], 2);
// 		}
// 		case COACH:
// 		{
// 			IntToString(g_iBullLevel[iClient], strSurvivorTalent[0], 2);
// 			IntToString(g_iWreckingLevel[iClient], strSurvivorTalent[1], 2);
// 			IntToString(g_iSprayLevel[iClient], strSurvivorTalent[2], 2);
// 			IntToString(g_iHomerunLevel[iClient], strSurvivorTalent[3], 2);
// 			IntToString(g_iLeadLevel[iClient], strSurvivorTalent[4], 2);
// 			IntToString(g_iStrongLevel[iClient], strSurvivorTalent[5], 2);
// 		}
// 		case ELLIS:
// 		{
// 			IntToString(g_iOverLevel[iClient], strSurvivorTalent[0], 2);
// 			IntToString(g_iBringLevel[iClient], strSurvivorTalent[1], 2);
// 			IntToString(g_iJamminLevel[iClient], strSurvivorTalent[2], 2);
// 			IntToString(g_iWeaponsLevel[iClient], strSurvivorTalent[3], 2);
// 			IntToString(g_iMetalLevel[iClient], strSurvivorTalent[4], 2);
// 			IntToString(g_iFireLevel[iClient], strSurvivorTalent[5], 2);
// 		}
// 		case NICK:
// 		{
// 			IntToString(g_iSwindlerLevel[iClient], strSurvivorTalent[0], 2);
// 			IntToString(g_iLeftoverLevel[iClient], strSurvivorTalent[1], 2);
// 			IntToString(g_iRiskyLevel[iClient], strSurvivorTalent[2], 2);
// 			IntToString(g_iEnhancedLevel[iClient], strSurvivorTalent[3], 2);
// 			IntToString(g_iMagnumLevel[iClient], strSurvivorTalent[4], 2);
// 			IntToString(g_iDesperateLevel[iClient], strSurvivorTalent[5], 2);
// 		}
// 	}
	
// 	//Get Infected Class IDs
// 	IntToString(g_iClientInfectedClass1[iClient], strInfectedID[0], 2);
// 	IntToString(g_iClientInfectedClass2[iClient], strInfectedID[1], 2);
// 	IntToString(g_iClientInfectedClass3[iClient], strInfectedID[2], 2);
	
// 	//Get Equpiment Slot IDs
// 	IntToString(g_iClientPrimarySlotID[iClient], strEquipmentSlotID[0], 3);
// 	IntToString(g_iClientSecondarySlotID[iClient], strEquipmentSlotID[1], 3);
// 	IntToString(g_iClientExplosiveSlotID[iClient], strEquipmentSlotID[2], 3);
// 	IntToString(g_iClientHealthSlotID[iClient], strEquipmentSlotID[3], 3);
// 	IntToString(g_iClientBoostSlotID[iClient], strEquipmentSlotID[4], 3);
// 	IntToString(g_iClientLaserSlotID[iClient], strEquipmentSlotID[5], 3);
	
// 	new i = 0;
// 	IntToString(g_bAnnouncerOn[iClient], strOption[i++], 2);
// 	IntToString(g_bEnabledVGUI[iClient], strOption[i++], 2);
// 	IntToString(g_iXPDisplayMode[iClient], strOption[i++], 2);
	
	
// 	//Save the new user data into the SQL database with the matching Steam ID
// 	decl String:strQuery[1024];
// 	Format(strQuery, sizeof(strQuery), "UPDATE %s SET ClientName = '%s', XP = %s, SurvivorID = %s, SurvivorTalent1 = %s, SurvivorTalent2 = %s, SurvivorTalent3 = %s, SurvivorTalent4 = %s, SurvivorTalent5 = %s, SurvivorTalent6 = %s, InfectedID1 = %s, InfectedID2 = %s, InfectedID3 = %s, EquipmentPrimary = %s, EquipmentSecondary = %s, EquipmentExplosive = %s, EquipmentHealth = %s, EquipmentBoost = %s, EquipmentLaser = %s, OptionAnnouncer = %s, OptionSurvivorVGUI = %s, OptionXPDisplay = %s WHERE SteamID = '%s'", 
// 			DB_TABLENAME, 
// 			strClientName, 
// 			strClientXP, 
// 			strSurvivorID,
// 			strSurvivorTalent[0],
// 			strSurvivorTalent[1],
// 			strSurvivorTalent[2],
// 			strSurvivorTalent[3],
// 			strSurvivorTalent[4],
// 			strSurvivorTalent[5],
// 			strInfectedID[0],
// 			strInfectedID[1],
// 			strInfectedID[2],
// 			strEquipmentSlotID[0],
// 			strEquipmentSlotID[1],
// 			strEquipmentSlotID[2],
// 			strEquipmentSlotID[3],
// 			strEquipmentSlotID[4],
// 			strEquipmentSlotID[5],
// 			strOption[0],
// 			strOption[1],
// 			strOption[2],
// 			strSteamID);
	
// 	SQL_TQuery(g_hDatabase, SQLSaveUserDataCallback, strQuery, iClient);
// }


// //Logout                                                                                                        
// Logout(iClient)
// {
// 	//PrintToChatAll("Logout. %i: %N", iClient, iClient);
// 	//PrintToServer("Logout. %i: %N", iClient, iClient);
// 	if(iClient==0)
// 	{
// 		iClient = 1;			//Changed this and the folwogin two lines
// 		//PrintToServer("Server host cannot login through the console, go into chat and type /login to login in.");
// 		//return Plugin_Handled;
// 	}
// 	if(!IsClientInGame(iClient))
// 		return;
// 	g_bTalentsConfirmed[iClient] = false;
// 	g_bUserStoppedConfirmation[iClient] = false;
// 	g_bAnnouncerOn[iClient] = false;
// 	g_bEnabledVGUI[iClient] = false;
// 	if(g_bClientLoggedIn[iClient] == true)
// 	{
// 		ResetAll(iClient, iClient);
// 		g_bClientLoggedIn[iClient] = false;
// 		//PrintToChatAll("\x03[XPMod] \x04%N Logged Out", iClient, iClient);
// 		return;
// 	}

// 	//PrintToChatAll("Logout Complete. %i: %N", iClient, iClient);
// 	//PrintToServer("Logout Complete. %i: %N", iClient, iClient);
	
// 	return;
// }
