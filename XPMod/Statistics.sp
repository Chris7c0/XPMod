/* Display Players in each Team */
public Action:ShowTeamStatsToPlayer(iClient, args)
{
	if(iClient==0)
	{
		ShowTeamStatsToServer();
		return Plugin_Continue;
	}
	if(IsClientInGame(iClient) == false)
		return Plugin_Continue;
	new bool:probe;
	probe = ProbeTeams(TEAM_SURVIVORS);
	if(probe == true)
	{
		PrintToChat(iClient, "\x03=======================================================================================");
		PrintToChat(iClient, "\x03|                                     Survivors                                       |");
		PrintToChat(iClient, "\x03=======================================================================================\n ");
		for(new i = 1; i<MaxClients; i++)
		{
			if(IsClientInGame(i))
			{
				if(!IsFakeClient(i))
					if(g_iClientTeam[i] == 2)
					{
						switch(g_iChosenSurvivor[i])
						{
							case 0:
							{
								PrintToChat(iClient, "\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  Character: \x04Support  \x03LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
								PrintToChat(iClient, "\x05     Levels: Inspirational: %d  Will: %d  Exorcism: %d  DieHard: %d  Ghillie: %d  Promotional: %d", g_iInspirationalLevel[i],g_iWillLevel[i],g_iExorcismLevel[i],g_iDiehardLevel[i],g_iGhillieLevel[i],g_iPromotionalLevel[i]);
								PrintToChat(iClient, "\x05     This Map: Common Infected Kills: %d  Special Infected Kills: %d  Headshots: %d", g_iStat_ClientCommonKilled[i], g_iStat_ClientInfectedKilled[i], g_iStat_ClientCommonHeadshots[i]);
								PrintToChat(iClient, " ");
							}
							case 1:
							{
								PrintToChat(iClient, "\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  Character: \x04Rochelle  \x03LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
								PrintToChat(iClient, "\x05     Levels: Gather: %d  Hunter: %d  Sniper: %d  Silent: %d  Smoke: %d  Shadow: %d", g_iGatherLevel[i],g_iHunterLevel[i],g_iSniperLevel[i],g_iSilentLevel[i],g_iSmokeLevel[i],g_iShadowLevel[i]);
								PrintToChat(iClient, "\x05     This Map: Common Infected Kills: %d  Special Infected Kills: %d  Headshots: %d", g_iStat_ClientCommonKilled[i], g_iStat_ClientInfectedKilled[i], g_iStat_ClientCommonHeadshots[i]);
								PrintToChat(iClient, " ");
							}
							case 2:
							{
								PrintToChat(iClient, "\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  Character: \x04Coach  \x03LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
								PrintToChat(iClient, "\x05     Levels: Bull: %d  Wrecking: %d  Spray: %d  Homerun: %d  Lead: %d  Strong: %d", g_iBullLevel[i],g_iWreckingLevel[i],g_iSprayLevel[i],g_iHomerunLevel[i],g_iLeadLevel[i],g_iStrongLevel[i]);
								PrintToChat(iClient, "\x05     This Map: Common Infected Kills: %d  Special Infected Kills: %d  Headshots: %d", g_iStat_ClientCommonKilled[i], g_iStat_ClientInfectedKilled[i], g_iStat_ClientCommonHeadshots[i]);
								PrintToChat(iClient, " ");
							}
							case 3:
							{
								PrintToChat(iClient, "\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  Character: \x04Ellis  \x03LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
								PrintToChat(iClient, "\x05     Levels: Over: %d  Bring: %d  Metal: %d  Weapons: %d  Jammin: %d  Fire: %d", g_iOverLevel[i],g_iBringLevel[i],g_iMetalLevel[i],g_iWeaponsLevel[i],g_iJamminLevel[i],g_iFireLevel[i]);
								PrintToChat(iClient, "\x05     This Map: Common Infected Kills: %d  Special Infected Kills: %d  Headshots: %d", g_iStat_ClientCommonKilled[i], g_iStat_ClientInfectedKilled[i], g_iStat_ClientCommonHeadshots[i]);
								PrintToChat(iClient, " ");
							}
							case 4:
							{
								PrintToChat(iClient, "\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  Character: \x04Nick  \x03LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
								PrintToChat(iClient, "\x05     Levels: Swindler: %d  Leftover: %d  Magnum: %d  Enhanced: %d  Risky: %d  Desperate: %d", g_iSwindlerLevel[i],g_iLeftoverLevel[i],g_iMagnumLevel[i],g_iEnhancedLevel[i],g_iRiskyLevel[i],g_iDesperateLevel[i]);
								PrintToChat(iClient, "\x05     This Map: Common Infected Kills: %d  Special Infected Kills: %d  Headshots: %d", g_iStat_ClientCommonKilled[i], g_iStat_ClientInfectedKilled[i], g_iStat_ClientCommonHeadshots[i]);
								PrintToChat(iClient, " ");
							}
						}
					}
			}
		}
	}
	probe = ProbeTeams(TEAM_INFECTED);
	if(probe == true)
	{
		PrintToChat(iClient, "\x03=======================================================================================");
		PrintToChat(iClient, "\x03|                                      Infected                                       |");
		PrintToChat(iClient, "\x03=======================================================================================\n ");
		for(new i = 1; i<MaxClients; i++)
		{
			if(IsClientInGame(i))
			{
				if(!IsFakeClient(i))
					if(g_iClientTeam[i] == 3)
					{
						PrintToChat(iClient, "\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  \x03LoggedIn: %d\n\x5    Class 1: %s	Class 2: %s	Class 3: %s\n    \x05This Map: Survivors Killed: %d  Survivors Incapped: %d  Damage Dealt: %d", i, g_iClientLevel[i], g_iClientXP[i],  g_bClientLoggedIn[i], g_strClientInfectedClass1[i], g_strClientInfectedClass2[i], g_strClientInfectedClass3[i], g_iStat_ClientSurvivorsKilled[i], g_iStat_ClientSurvivorsIncaps[i], g_iStat_ClientDamageToSurvivors[i]);
						PrintToChat(iClient, " ");
					}
			}
		}
	}
	probe = ProbeTeams(TEAM_SPECTATORS);
	if(probe == true)
	{
		PrintToChat(iClient, "\x03=======================================================================================");
		PrintToChat(iClient, "\x03|                                     Spectators                                      |");
		PrintToChat(iClient, "\x03=======================================================================================\n ");
		for(new i = 1; i<MaxClients; i++)
		{
			if(IsClientInGame(i))
			{
				if(!IsFakeClient(i))
					if(g_iClientTeam[i] == 1)
					{
						PrintToChat(iClient, "\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
						PrintToChat(iClient, " ");
					}
			}
		}
	}
	PrintToChat(iClient, "\x03=======================================================================================");
	PrintToChat(iClient, "\x03|                                                                                     |");
	PrintToChat(iClient, "\x03=======================================================================================\n ");
	/*PrintToChat(iClient, "\x03=======================================================================================");
	PrintToChat(iClient, "\x03|                \x04Go to the \x05console \x04for a better view of these stats.                  \x03|");
	PrintToChat(iClient, "\x03=======================================================================================");*/
	//PrintTeamsToClient(iClient);
	//SendPanelToClient(PrintTeamsToClient(iClient),iClient,TeamPanelHandler,MENU_TIME_FOREVER);
	return Plugin_Handled;
}

ShowTeamStatsToServer()
{
	decl String:clientname[22];
	PrintToServer("=======================================================================================");
	PrintToServer("|                                     Survivors                                       |");
	PrintToServer("=======================================================================================\n");
	for(new i = 1; i<MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(g_iClientTeam[i] == 2)
			{
				switch(g_iChosenSurvivor[i])
				{
					case 0:
					{
						PrintToServer("\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  Character: \x04Support  LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
						PrintToServer("\x05     Levels: Inspirational: %d  Will: %d  Exorcism: %d  DieHard: %d  Ghillie: %d  Promotional: %d", g_iInspirationalLevel[i],g_iWillLevel[i],g_iExorcismLevel[i],g_iDiehardLevel[i],g_iGhillieLevel[i],g_iPromotionalLevel[i]);
						PrintToServer("\x05     This Map: Common Infected Kills: %d  Special Infected Kills: %d  Headshots: %d", g_iStat_ClientCommonKilled[i], g_iStat_ClientInfectedKilled[i], g_iStat_ClientCommonHeadshots[i]);
						PrintToServer(" ");
					}
					case 1:
					{
						PrintToServer("\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  Character: \x04Rochelle  LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
						PrintToServer("\x05     Levels: Gather: %d  Hunter: %d  Sniper: %d  Silent: %d  Smoke: %d  Shadow: %d", g_iGatherLevel[i],g_iHunterLevel[i],g_iSniperLevel[i],g_iSilentLevel[i],g_iSmokeLevel[i],g_iShadowLevel[i]);
						PrintToServer("\x05     This Map: Common Infected Kills: %d  Special Infected Kills: %d  Headshots: %d", g_iStat_ClientCommonKilled[i], g_iStat_ClientInfectedKilled[i], g_iStat_ClientCommonHeadshots[i]);
						PrintToServer(" ");
					}
					case 2:
					{
						PrintToServer("\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  Character: \x04Coach  LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
						PrintToServer("\x05     Levels: Bull: %d  Wrecking: %d  Spray: %d  Homerun: %d  Lead: %d  Strong: %d", g_iBullLevel[i],g_iWreckingLevel[i],g_iSprayLevel[i],g_iHomerunLevel[i],g_iLeadLevel[i],g_iStrongLevel[i]);
						PrintToServer("\x05     This Map: Common Infected Kills: %d  Special Infected Kills: %d  Headshots: %d", g_iStat_ClientCommonKilled[i], g_iStat_ClientInfectedKilled[i], g_iStat_ClientCommonHeadshots[i]);
						PrintToServer(" ");
					}
					case 3:
					{
						PrintToServer("\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  Character: \x04Ellis  LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
						PrintToServer("\x05     Levels: Over: %d  Bring: %d  Metal: %d  Weapons: %d  Jammin: %d  Fire: %d", g_iOverLevel[i],g_iBringLevel[i],g_iMetalLevel[i],g_iWeaponsLevel[i],g_iJamminLevel[i],g_iFireLevel[i]);
						PrintToServer("\x05     This Map: Common Infected Kills: %d  Special Infected Kills: %d  Headshots: %d", g_iStat_ClientCommonKilled[i], g_iStat_ClientInfectedKilled[i], g_iStat_ClientCommonHeadshots[i]);
						PrintToServer(" ");
					}
					case 4:
					{
						PrintToServer("\x04 [\x03%N\x04]\x05: \x03Level %d  XP: %d  Character: \x04Nick  LoggedIn: %d", i, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
						PrintToServer("\x05     Levels: Swindler: %d  Leftover: %d  Magnum: %d  Enhanced: %d  Risky: %d  Desperate: %d", g_iSwindlerLevel[i],g_iLeftoverLevel[i],g_iMagnumLevel[i],g_iEnhancedLevel[i],g_iRiskyLevel[i],g_iDesperateLevel[i]);
						PrintToServer("\x05     This Map: Common Infected Kills: %d  Special Infected Kills: %d  Headshots: %d", g_iStat_ClientCommonKilled[i], g_iStat_ClientInfectedKilled[i], g_iStat_ClientCommonHeadshots[i]);
						PrintToServer(" ");
					}
				}
			}
		}
	}
	PrintToServer("\x03=======================================================================================");
	PrintToServer("\x03|                                      Infected                                       |");
	PrintToServer("\x03=======================================================================================\n");
	for(new i = 1; i<MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(g_iClientTeam[i] == 3)
			{
				GetClientName(i, clientname, sizeof(clientname));
				PrintToServer("\x04 [\x03%s\x04]\x05: \x03Level %d  XP: %d  LoggedIn: %d\n	Class 1: %s	Class 2: %s	Class 3: %s\n	\nx05This Map: Survivors Killed: %d  Survivors Incapped: %d  Damage Dealt: %d", clientname, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i], g_strClientInfectedClass1[i], g_strClientInfectedClass2[i], g_strClientInfectedClass3[i], g_iStat_ClientSurvivorsKilled[i], g_iStat_ClientSurvivorsIncaps[i], g_iStat_ClientDamageToSurvivors[i]);
				PrintToServer(" ");
			}
		}
	}
	PrintToServer("\x03=======================================================================================");
	PrintToServer("\x03|                                     Spectators                                      |");
	PrintToServer("\x03=======================================================================================\n");
	for(new i = 1; i<MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(g_iClientTeam[i] == 1)
			{
				GetClientName(i, clientname, sizeof(clientname));
				PrintToServer("\x04 [\x03%s\x04]\x05: \x03Level %d  XP: %d  LoggedIn: %d", clientname, g_iClientLevel[i], g_iClientXP[i], g_bClientLoggedIn[i]);
				PrintToServer(" ");
			}
		}
	}
	
	return;
}