public Action:ShowTeamStatsToPlayer(iClient, args)
{
	decl String:strStatsTextBuffer[256];
	decl String:strLoggedIn[16];
	decl String:strConfirmed[16];

	// Construct the statistics string
	if(ProbeTeams(TEAM_SURVIVORS) == true)
	{
		PrintToServerOrClient(iClient, "\x03=	=	=	=	=	=	=	=	=	=	=	=	=	=");
		PrintToServerOrClient(iClient, "\x03|						Survivors						|");
		PrintToServerOrClient(iClient, "\x03=	=	=	=	=	=	=	=	=	=	=	=	=	=\n ");

		for(new i = 1; i<MaxClients; i++)
		{
			if(IsClientInGame(i) && IsFakeClient(i) == false && g_iClientTeam[i] == TEAM_SURVIVORS)
			{
				GetLoggedInAndConfirmedStrings(i, strLoggedIn, sizeof(strLoggedIn), strConfirmed, sizeof(strConfirmed));

				Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x04 [\x03%N\x04]\x05: \x03Lvl %d, %d XP\x03%s%s\n", 
					i,
					g_iClientLevel[i], 
					g_iClientXP[i], 
					strLoggedIn, 
					strConfirmed);
				PrintToServerOrClient(iClient, strStatsTextBuffer);

				if (g_bClientLoggedIn[i])
				{
					Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x05	%s - %s\x04	CI-Kills: %d SI-Kills: %d HS: %d\n",
						SURVIVOR_NAME[g_iChosenSurvivor[i]],
						SURVIVOR_CLASS_NAME[g_iChosenSurvivor[i]],
						g_iStat_ClientCommonKilled[i], 
						g_iStat_ClientInfectedKilled[i], 
						g_iStat_ClientCommonHeadshots[i]);
					PrintToServerOrClient(iClient, strStatsTextBuffer);
				}
			}
		}
		PrintToServerOrClient(iClient, " ");
	}
	if(ProbeTeams(TEAM_INFECTED) == true)
	{
		PrintToServerOrClient(iClient, "\x03=	=	=	=	=	=	=	=	=	=	=	=	=	=");
		PrintToServerOrClient(iClient, "\x03|						Infected						|");
		PrintToServerOrClient(iClient, "\x03=	=	=	=	=	=	=	=	=	=	=	=	=	=\n ");

		for(new i = 1; i<MaxClients; i++)
		{
			if(IsClientInGame(i) && IsFakeClient(i) == false && g_iClientTeam[i] == TEAM_INFECTED)
			{
				GetLoggedInAndConfirmedStrings(i, strLoggedIn, sizeof(strLoggedIn), strConfirmed, sizeof(strConfirmed));

				Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x04 [\x03%N\x04]\x05: \x03Lvl %d, %d XP\x03%s%s\n", 
					i,
					g_iClientLevel[i], 
					g_iClientXP[i], 
					strLoggedIn, 
					strConfirmed);
				PrintToServerOrClient(iClient, strStatsTextBuffer);

				if (g_bClientLoggedIn[i])
				{
					Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x05	%s, %s, %s\x04	Kills: %d Incaps: %d DMG: %d\n", 
						g_strClientInfectedClass1[i], 
						g_strClientInfectedClass2[i], 
						g_strClientInfectedClass3[i],
						g_iStat_ClientSurvivorsKilled[i], 
						g_iStat_ClientSurvivorsIncaps[i], 
						g_iStat_ClientDamageToSurvivors[i]);
					PrintToServerOrClient(iClient, strStatsTextBuffer);
				}
			}
		}
		PrintToServerOrClient(iClient, " ");
	}
	if(ProbeTeams(TEAM_SPECTATORS) == true)
	{
		PrintToServerOrClient(iClient, "\x03=	=	=	=	=	=	=	=	=	=	=	=	=	=");
		PrintToServerOrClient(iClient, "\x03|						Spectators						|");
		PrintToServerOrClient(iClient, "\x03=	=	=	=	=	=	=	=	=	=	=	=	=	=\n ");

		for(new i = 1; i<MaxClients; i++)
		{
			if(IsClientInGame(i) && IsFakeClient(i) == false && g_iClientTeam[i] == TEAM_SPECTATORS)
			{
				GetLoggedInAndConfirmedStrings(i, strLoggedIn, sizeof(strLoggedIn), strConfirmed, sizeof(strConfirmed));

				Format(strStatsTextBuffer, sizeof(strStatsTextBuffer), "\x04 [\x03%N\x04]\x05: \x03Lvl %d, %d XP\x03%s%s\n", 
					i,
					g_iClientLevel[i], 
					g_iClientXP[i], 
					strLoggedIn, 
					strConfirmed);
				PrintToServerOrClient(iClient, strStatsTextBuffer);
			}
		}
		PrintToServerOrClient(iClient, " ");
	}
	PrintToServerOrClient(iClient, "\x03=	=	=	=	=	=	=	=	=	=	=	=	=	=");
	// if (iClient > 0)
	// 	PrintToServerOrClient(iClient, "\x03[XPMod] \x04Open the console by pressing \x05~\x04 for a better view.");

	return Plugin_Handled;
}

PrintToServerOrClient(iClient, char[] text)
{
	// Print to the user
	if (iClient == 0)
		PrintToServer(text);
	else if(RunClientChecks(iClient))
		PrintToChat(iClient, text);
}

GetLoggedInAndConfirmedStrings(iClient, char[] strLoggedIn, int iLoggedInMaxLen, char[] strConfirmed, int iConfirmedMaxLen)
{
	if (g_bClientLoggedIn[iClient])
		Format(strLoggedIn, iLoggedInMaxLen, ", LoggedIn");
	else
		Format(strLoggedIn, iLoggedInMaxLen, "");

	if (g_bTalentsConfirmed[iClient])
		Format(strConfirmed, iConfirmedMaxLen, ", Confirmed");
	else
		Format(strConfirmed, iConfirmedMaxLen, "");
}