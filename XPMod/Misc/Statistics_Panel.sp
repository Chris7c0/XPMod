
void ShowRoundStatsLastRoundIndividual(int iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	char strStatsText[700];
	Format(strStatsText, sizeof(strStatsText),
		"\n \
		\nYour Stats Last Round\
		\n \
		\nSURVIVOR\
		\n S.I. Killed:		%i Killed\
		\n C.I. Killed:		%i Killed\
		\n Headshots:	 %i HS\
		\n \
		\nINFECTED\
		\n Survivors Killed:		  %i Killed\
		\n Survivor Incaps:		  %i Incaps      \
		\n Damage To Survivors: %i DMG\
		\n \
		\nPRESS 0 to Hide\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		g_iStat_LastRound_ClientInfectedKilled[iClient],
		g_iStat_LastRound_ClientCommonKilled[iClient],
		g_iStat_LastRound_ClientCommonHeadshots[iClient],
		g_iStat_LastRound_ClientSurvivorsKilled[iClient],
		g_iStat_LastRound_ClientSurvivorsIncaps[iClient],
		g_iStat_LastRound_ClientDamageToSurvivors[iClient]);
	
	RoundStatsMenuDraw(iClient, strStatsText);
}

void ShowRoundStatsLastRoundTopPlayers(int iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	char strStatsText[700];
	Format(strStatsText, sizeof(strStatsText),
		"\n \
		\nTop Players Last Round\
		\n \
		\nSURVIVORS\
		\n Most S.I. Killed:		%s (%i Killed)\
		\n Most C.I. Killed:		%s (%i Killed)\
		\n Most Headshots:	 %s (%i HS)\
		\n \
		\nINFECTED\
		\n Most Survivors Killed:		  %s (%i Killed)\
		\n Most Survivor Incaps:		  %s (%i Incaps)      \
		\n Most Damage To Survivors: %s (%i DMG)\
		\n \
		\nPRESS 0 to Hide\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		g_strReward_SIKills, g_iReward_SIKills,
		g_strReward_CIKills, g_iReward_CIKills,
		g_strReward_HS, g_iReward_HS,
		g_strReward_SurKills, g_iReward_SurKills,
		g_strReward_SurIncaps, g_iReward_SurIncaps,
		g_strReward_SurDmg, g_iReward_SurDmg);
	
	RoundStatsMenuDraw(iClient, strStatsText);
}

void ShowRoundStatsXPModTopPlayers(int iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	// If we dont have the the TopXPModPlayers yet, then don't display
	if (strlen(g_strTopXPModPlayersStatsText) <= 1)
		return;

	char strStatsText[700];
	Format(strStatsText, sizeof(strStatsText),
		"\n \
		\nTop XPMod Players\
		\n \
		%s\
		\n \
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		g_strTopXPModPlayersStatsText);
	
	RoundStatsMenuDraw(iClient, strStatsText);
}

 
void RoundStatsMenuDraw(int iClient, const char[] strStatsText)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	char strPanelText[1024];
	Format(strPanelText, sizeof(strPanelText),
		"%s\
		​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​\
		.",
		strStatsText)

	Panel panel = new Panel();
	panel.SetTitle(strPanelText);
	panel.DrawItem(" ");
	panel.DrawItem(" ");
	panel.DrawItem(" ");
	panel.DrawItem(" ");
	panel.DrawItem(" ");
	panel.DrawItem(" ");
	panel.DrawItem(" ");
	panel.DrawItem(" ");
	panel.DrawItem(" ");
	panel.DrawItem(" ");
	
	panel.Send(iClient, RoundStatsMenuHandler, RoundToNearest(ROUND_STATS_PANEL_LIFETIME));
 
	delete panel;
}

void RoundStatsMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_Select) 
	{
		HandleMenuPanelWeaponSwitching(iClient, itemNum);

		if (itemNum >= 1 && itemNum <= 9)
			CreateTimer(0.1, TimerShowCurrentRoundStatsPanel, iClient, TIMER_FLAG_NO_MAPCHANGE);

		if (itemNum == 10)
			RoundStatsPanel[iClient] = ROUND_STATS_PANEL_DONE;
	}
}

void ShowRoundStatsPanelsToPlayer(int iClient)
{
	// Last Round Stats Panels
	RoundStatsPanel[iClient] = ROUND_STATS_PANEL_LAST_ROUND_INDIVIDUAL;
	CreateTimer(0.1, TimerShowCurrentRoundStatsPanel, iClient, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(ROUND_STATS_PANEL_LIFETIME, TimerSetAndShowNewRoundStatsPanel, iClient, TIMER_REPEAT);
}

Action TimerShowCurrentRoundStatsPanel(Handle timer, any iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Stop;
	
	switch (RoundStatsPanel[iClient])
	{
		case ROUND_STATS_PANEL_LAST_ROUND_INDIVIDUAL: 	ShowRoundStatsLastRoundIndividual(iClient);
		case ROUND_STATS_PANEL_LAST_ROUND_TOP_PLAYERS: 	ShowRoundStatsLastRoundTopPlayers(iClient);
		case ROUND_STATS_PANEL_XPMOD_TOP_PLAYERS: 		ShowRoundStatsXPModTopPlayers(iClient);
	}

	return Plugin_Stop;
}

Action TimerSetAndShowNewRoundStatsPanel(Handle timer, any iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Stop;

	// Set the the next stat type
	RoundStatsPanel[iClient]++;

	if (RoundStatsPanel[iClient] >= ROUND_STATS_PANEL_DONE)
	{
		RoundStatsPanel[iClient] = ROUND_STATS_PANEL_DONE;
		return Plugin_Stop;
	}

	CreateTimer(0.2, TimerShowCurrentRoundStatsPanel, iClient, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Continue;
}

void HandleMenuPanelWeaponSwitching(int iClient, int itemNum)
{
	switch (itemNum)
	{
		case 1: //Switch to Slot 1 (Primary Weapon)
		{
			ClientCommand(iClient, "slot0");
			ClientCommand(iClient, "slot1");
			
		}
		case 2: //Switch to Slot 2 (Secondary Weapon)
		{
			ClientCommand(iClient, "slot0");
			ClientCommand(iClient, "slot2");
		}
		case 3: //Switch to Slot 3 (Explosive Weapon)
		{
			ClientCommand(iClient, "slot0");
			ClientCommand(iClient, "slot3");
		}
		case 4: //Switch to Slot 4 (Health Slot)
		{
			ClientCommand(iClient, "slot0");
			ClientCommand(iClient, "slot4");
		}
		case 5: //Switch to Slot 5 (Boost Slot)
		{
			ClientCommand(iClient, "slot0");
			ClientCommand(iClient, "slot5");
		}
	}
}

void StoreLastRoundClientsStats()
{
	for(int iClient = 1; iClient <= MaxClients; iClient++)
	{		
		if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
			continue;
		
		// Survivor Stats
		g_iStat_LastRound_ClientInfectedKilled[iClient] = g_iStat_ClientInfectedKilled[iClient];
		g_iStat_LastRound_ClientCommonKilled[iClient] = g_iStat_ClientCommonKilled[iClient];
		g_iStat_LastRound_ClientCommonHeadshots[iClient] = g_iStat_ClientCommonHeadshots[iClient];
		// Infected Stats
		g_iStat_LastRound_ClientSurvivorsKilled[iClient] = g_iStat_ClientSurvivorsKilled[iClient];
		g_iStat_LastRound_ClientSurvivorsIncaps[iClient] = g_iStat_ClientSurvivorsIncaps[iClient];
		g_iStat_LastRound_ClientDamageToSurvivors[iClient] = g_iStat_ClientDamageToSurvivors[iClient];
	}
}
