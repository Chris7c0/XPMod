Action:ShowTeamStatsToPlayer(iClient, args)
{
	CreateXPMStatistics(iClient);

	return Plugin_Handled;
}

CreateXPMStatistics(iClient, char[] strStoreBuffer = "", iStoreBufferSize = -1)
{
	decl String:strStatsTextBuffer[256];
	decl String:strLoggedIn[16];
	decl String:strConfirmed[16];
	decl String:strState[64];

	PrintToBufferServerOrClient(iClient, "\x05[  =  =  =  =  =  =  =  =  =  =  =  =  =  ]", strStoreBuffer, iStoreBufferSize);

	// Store timestamp into a string
	decl String:strTime[16];
	FormatTime(strTime, sizeof(strTime), "%H:%M:%S", GetTime());

	// Add Server info
	Format(strStatsTextBuffer, sizeof(strStatsTextBuffer),
		"\x03  %s  \x04%i Humans  \x03%s\
		\n\x04  Round %i  %s  %.1f Mins\x03 ", 
		strTime,
		GetHumanPlayerCount(),
		g_strServerName,
		g_iRoundCount,
		g_strCurrentMap,
		GetGameTime() / 60.0);
	PrintToBufferServerOrClient(iClient, strStatsTextBuffer, strStoreBuffer, iStoreBufferSize);

	// Construct the statistics strings
	if(ProbeTeams(TEAM_SPECTATORS) == true)
	{
		PrintToBufferServerOrClient(iClient, "\x05[  =  =  =  =  = Spectators =  =  =  =  = ]\n ", strStoreBuffer, iStoreBufferSize);


		for(new i = 1; i<= MaxClients; i++)
		{
			if(RunClientChecks(i) && IsFakeClient(i) == false && g_iClientTeam[i] == TEAM_SPECTATORS)
			{
				Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x04 [\x03%N\x04]\x03 ", i);
				PrintToBufferServerOrClient(iClient, strStatsTextBuffer, strStoreBuffer, iStoreBufferSize);

				GetLoggedInAndConfirmedStrings(i, strLoggedIn, sizeof(strLoggedIn), strConfirmed, sizeof(strConfirmed));

				Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x05   Lvl %d %d XP%s%s", 
					g_iClientLevel[i], 
					g_iClientXP[i], 
					strLoggedIn, 
					strConfirmed);
				PrintToBufferServerOrClient(iClient, strStatsTextBuffer, strStoreBuffer, iStoreBufferSize);
			}
		}
		PrintToBufferServerOrClient(iClient, " ", strStoreBuffer, iStoreBufferSize);
	}

	if(ProbeTeams(TEAM_SURVIVORS) == true)
	{
		PrintToBufferServerOrClient(iClient, "\x05[  =  =  =  =  = Survivors =  =  =  =  =  ]\n ", strStoreBuffer, iStoreBufferSize);

		for(new i = 1; i<= MaxClients; i++)
		{
			if(RunClientChecks(i) && IsFakeClient(i) == false && g_iClientTeam[i] == TEAM_SURVIVORS)
			{
				// Determine the player state
				if (IsPlayerAlive(i) == false)
					strState = "DEAD";
				else if (GetEntProp(i, Prop_Send, "m_isIncapacitated") == 1)
					Format(strState, sizeof(strState), "INCAPACITATED");
				else if (GetEntProp(i,Prop_Data,"m_iHealth") > 0)
					Format(strState, sizeof(strState), "(%i+%i/%i HP) %.3f MS", 
						GetEntProp(i,Prop_Data,"m_iHealth"), 
						GetSurvivorTempHealth(i),
						GetEntProp(i,Prop_Data,"m_iMaxHealth"),
						GetEntDataFloat(i, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue")));
				else
					strState = "ERROR!";

				Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x04 [\x03%N\x04]\x05 %s\x03 ", i, strState);
				PrintToBufferServerOrClient(iClient, strStatsTextBuffer, strStoreBuffer, iStoreBufferSize);

				GetLoggedInAndConfirmedStrings(i, strLoggedIn, sizeof(strLoggedIn), strConfirmed, sizeof(strConfirmed));

				Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x05   Lvl %d %d XP%s%s", 
					g_iClientLevel[i], 
					g_iClientXP[i], 
					strLoggedIn, 
					strConfirmed);
				PrintToBufferServerOrClient(iClient, strStatsTextBuffer, strStoreBuffer, iStoreBufferSize);
				
				if (g_bClientLoggedIn[i])
				{
					Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x05   %s\x04 K-CI: %d K-SI: %d HS: %d\x05 ",
						SURVIVOR_NAME[g_iChosenSurvivor[i]],
						g_iStat_ClientCommonKilled[i], 
						g_iStat_ClientInfectedKilled[i], 
						g_iStat_ClientCommonHeadshots[i]);
					PrintToBufferServerOrClient(iClient, strStatsTextBuffer, strStoreBuffer, iStoreBufferSize);
				}
			}
		}
		PrintToBufferServerOrClient(iClient, " ", strStoreBuffer, iStoreBufferSize);
	}

	if(ProbeTeams(TEAM_INFECTED) == true)
	{
		PrintToBufferServerOrClient(iClient, "\x05[  =  =  =  =  = Infected  =  =  =  =  =  ]\n ", strStoreBuffer, iStoreBufferSize);

		for(new i = 1; i<= MaxClients; i++)
		{
			if (RunClientChecks(i) && 
				g_iClientTeam[i] == TEAM_INFECTED &&
				IsFakeClient(i) == false)
				// This portion can replace the last check, IsFakeClient, to show bots
				//(IsFakeClient(i) == false || (g_bIsGhost[i] == false && g_bCanBeGhost[i] == false)) )
			{
				//PrintToChat(i, "g_bIsGhost %i,g_bCanBeGhost %i, %s", g_bIsGhost[i], g_bCanBeGhost[i], INFECTED_NAME[g_iInfectedCharacter[i]])

				// Determine the player state
				if (g_bIsGhost[i])
					strState = "SPAWNING";
				else if (g_bCanBeGhost[i])
					strState = "DEAD";
				else if (IsPlayerAlive(i) && g_iInfectedCharacter[i] < 9)
					Format(strState, sizeof(strState), "%s (%i/%i HP) %.3f MS", 
						INFECTED_NAME[g_iInfectedCharacter[i]], 
						GetEntProp(i,Prop_Data,"m_iHealth"), 
						GetEntProp(i,Prop_Data,"m_iMaxHealth"), 
						GetEntDataFloat(i, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue")));
				else
					strState = "ERROR!";
				
				Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x04 [\x03%N\x04]\x05 %s\x03 ", i, strState);
				PrintToBufferServerOrClient(iClient, strStatsTextBuffer, strStoreBuffer, iStoreBufferSize);

				if (IsFakeClient(i) == false)
				{
					GetLoggedInAndConfirmedStrings(i, strLoggedIn, sizeof(strLoggedIn), strConfirmed, sizeof(strConfirmed));

					Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x05   Lvl %d %d XP%s%s", 
						g_iClientLevel[i], 
						g_iClientXP[i], 
						strLoggedIn, 
						strConfirmed);
					PrintToBufferServerOrClient(iClient, strStatsTextBuffer, strStoreBuffer, iStoreBufferSize);
				}
				
				if (g_bClientLoggedIn[i])
				{
					Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x05   %s|%s|%s\x04 K: %d I: %d DMG: %d\x05 ", 
						g_strClientInfectedClass1[i], 
						g_strClientInfectedClass2[i], 
						g_strClientInfectedClass3[i],
						g_iStat_ClientSurvivorsKilled[i], 
						g_iStat_ClientSurvivorsIncaps[i], 
						g_iStat_ClientDamageToSurvivors[i]);
					PrintToBufferServerOrClient(iClient, strStatsTextBuffer, strStoreBuffer, iStoreBufferSize);
				}
			}
		}
		PrintToBufferServerOrClient(iClient, " ", strStoreBuffer, iStoreBufferSize);
	}
	
	PrintToBufferServerOrClient(iClient, "\x05[  =  =  =  =  =  =  =  =  =  =  =  =  =  ]", strStoreBuffer, iStoreBufferSize);
}

PrintToBufferServerOrClient(iClient, const char[] strText, char[] strStoreBuffer = "", iStoreBufferSize = -1)
{
	// Print to buffer
	if (iStoreBufferSize > 0)
	{
		StrCat(strStoreBuffer, iStoreBufferSize, strText);
		StrCat(strStoreBuffer, iStoreBufferSize, "\n");
	}
	// Print to the server
	else if (iClient == 0)
	{
		PrintToServer(strText);
	}
	// Print to in game client
	else if(RunClientChecks(iClient))
	{
		PrintToChat(iClient, strText);
	}
}

GetLoggedInAndConfirmedStrings(iClient, char[] strLoggedIn, int iLoggedInMaxLen, char[] strConfirmed, int iConfirmedMaxLen)
{
	if (g_bClientLoggedIn[iClient])
		Format(strLoggedIn, iLoggedInMaxLen, " LoggedIn");
	else
		Format(strLoggedIn, iLoggedInMaxLen, "");

	if (g_bTalentsConfirmed[iClient])
		Format(strConfirmed, iConfirmedMaxLen, " Confirmed");
	else
		Format(strConfirmed, iConfirmedMaxLen, "");
}

Action:TimerLogXPMStatsToFile(Handle:timer, any:data)
{
	decl String:strStoreBuffer[2000];
	strStoreBuffer = NULL_STRING;

	CreateXPMStatistics(-1, strStoreBuffer, sizeof(strStoreBuffer));

	// Remove all the color codes
	ReplaceString(strStoreBuffer, sizeof(strStoreBuffer), "\x05", "", true);
	ReplaceString(strStoreBuffer, sizeof(strStoreBuffer), "\x04", "", true);
	ReplaceString(strStoreBuffer, sizeof(strStoreBuffer), "\x03", "", true);

	SaveXPMStatsBufferToLogFile(strStoreBuffer);

	return Plugin_Continue;
}

SaveXPMStatsBufferToLogFile(const char[] strBuffer)
{
	if (strlen(g_strXPMStatsFullFilePath) < 1)
		return;
	
	new Handle:hFileHandle;
	hFileHandle = OpenFile(g_strXPMStatsFullFilePath, "w");
	if (hFileHandle != null)
		WriteFileLine(hFileHandle, strBuffer);
	CloseHandle(hFileHandle);
}

SetXPMStatsLogFileName()
{
	// TODO: Sanitize the servername for Windows/Linux file paths
	new String:strFileLogPath[100];
	Format(strFileLogPath, sizeof(strFileLogPath), "/logs/xpmstats_%s.log", g_strServerName);
	
	BuildPath(Path_SM, g_strXPMStatsFullFilePath, PLATFORM_MAX_PATH, strFileLogPath);
}