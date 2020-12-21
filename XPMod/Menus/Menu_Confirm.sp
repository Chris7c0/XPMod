public Action:TimerCheckAndOpenCharacterSelectionMenuForAll(Handle:timer, any:data)
{
	decl iClient;
	for(iClient = 1; iClient <= MaxClients; iClient++)
	{
		if(g_bClientAlreadyShownCharacterSelectMenu[iClient] == false &&
			g_bUserStoppedConfirmation[iClient] == false &&
			g_iAutoSetCountDown[iClient] == -1 && 
			g_bClientLoggedIn[iClient] == true && 
			g_bTalentsConfirmed[iClient] == false && 
			IsClientInGame(iClient) == true && 
			GetClientMenu(iClient) == MenuSource_None && 
			IsFakeClient(iClient) == false &&
			g_iClientTeam[iClient] != TEAM_SPECTATORS)
		{
			// Sets the next state of the g_iOpenCharacterMotdAndDrawMenuState which will be handled in OnPlayerRunCmd
			if(g_iOpenCharacterMotdAndDrawMenuState[iClient] == STARTING_CHAR_SELECT_PROCESS)
				g_iOpenCharacterMotdAndDrawMenuState[iClient] = WAITING_ON_BUTTON_FOR_MOTD;
		}
	}
	
	return Plugin_Continue;
}

// public Action:TimerOpenCharacterSelectionMenuForUser(Handle:timer, any:iClient)
// {
// 	if (g_iAutoSetCountDown[iClient] == -1 && 
// 		g_bClientLoggedIn[iClient] == true && 
// 		g_bTalentsConfirmed[iClient] == false && 
// 		IsClientInGame(iClient) == true && 
// 		GetClientMenu(iClient) == MenuSource_None && 
// 		IsFakeClient(iClient) == false)
// 	{
// 		//g_iAutoSetCountDown[iClient] = 30;
// 		//CreateTimer((0.1 * iClient), TimerShowTalentsConfirmed, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
// 		//CreateTimer((10.0), CheckIfUserMovedThenOpenCharacterSelectionSite, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
// 		OpenCharacterSelectionSite(iClient);
// 	}
	
// 	return Plugin_Stop;
// }

OpenCharacterSelectionSite(iClient)
{
	// Close any existing confirmation menu
	g_bUserStoppedConfirmation[iClient] = true;
	ClosePanel(iClient);
	// Prevent the user from seeing the menu twice for the round
	g_bClientAlreadyShownCharacterSelectMenu[iClient] = true;
	
	// Draw multiple times to prevent from not showing
	CreateTimer(0.1, DelayedCharacterSelectDrawMOTDPanel, iClient);
	CreateTimer(0.5, DelayedCharacterSelectDrawMOTDPanel, iClient);
}

ResetTalentConfirmCountdown(iClient)
{
	g_bTalentsConfirmed[iClient] = false;
	g_iAutoSetCountDown[iClient] = -1;
	g_bUserStoppedConfirmation[iClient] = false;
	g_iOpenCharacterMotdAndDrawMenuState[iClient] = STARTING_CHAR_SELECT_PROCESS;
	g_bClientAlreadyShownCharacterSelectMenu[iClient] = false;
}

public Action:StartWaitingForClientInputForDrawMenu(Handle:timer, any:iClient)
{
	// This will wait then 2nd button input for drawing the confirm menu
	g_iOpenCharacterMotdAndDrawMenuState[iClient] = WAITING_ON_FINAL_BUTTON_FOR_CONFIRM_MENU;
	//PrintToChat(iClient, "g_iOpenCharacterMotdAndDrawMenuState = WAITING_ON_FINAL_BUTTON_FOR_CONFIRM_MENU");
	return Plugin_Stop;
}

public Action:DelayedCharacterSelectDrawMOTDPanel(Handle:timer, any:iClient)
{
	// PrintToServer("Drawing MOTD");
	decl String:url[256];

	if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
		Format(url, sizeof(url), "http://xpmod.net/select/s/survivor_select.php?id=%i&t=%s", g_iDBUserID[iClient], g_strDBUserToken[iClient]);
	else if (g_iClientTeam[iClient] == TEAM_INFECTED)
		Format(url, sizeof(url), "http://xpmod.net/select/i/infected_select.php?id=%i&t=%s", g_iDBUserID[iClient], g_strDBUserToken[iClient]);
	else
		Format(url, sizeof(url), "http://xpmod.net/select/character_select.php?id=%i&t=%s", g_iDBUserID[iClient], g_strDBUserToken[iClient]);

	PrintToServer("%s", url);
	
	OpenMOTDPanel(iClient, " ", url, MOTDPANEL_TYPE_URL);

	return Plugin_Stop;
}

public Action:TimerShowTalentsConfirmed(Handle:timer, any:iClient)
{
	if(RunClientChecks(iClient) &&
		IsFakeClient(iClient) == false &&
		g_bClientLoggedIn[iClient] == true &&
		g_bTalentsConfirmed[iClient] == false &&
		g_bUserStoppedConfirmation[iClient] == false)
	{
		ConfirmationMessageMenuDraw(iClient);
		g_iAutoSetCountDown[iClient]--;

		return Plugin_Continue;
	}
	
	g_hTimer_ShowingConfirmTalents[iClient] = null;
	return Plugin_Stop;
}


public Action:ConfirmationMessageMenuDraw(iClient)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Handled;
	
	if(g_bTalentsConfirmed[iClient] == false)
	{
		if(g_iAutoSetCountDown[iClient] > 0)
		{
			CheckMenu(iClient);
			g_hMenu_XPM[iClient] = CreateMenu(ConfirmationMessageMenuHandler);
			
			decl String:surClass[16];
			switch(g_iChosenSurvivor[iClient])
			{
				case 0: surClass =  "Support";
				case 1: surClass =  "Ninja";
				case 2: surClass =  "Berserker";
				case 3: surClass =  "Weapons Expert";
				case 4: surClass =  "Medic";
				default: surClass = "NONE";
			}
			
			decl String:text[300];
			FormatEx(text, sizeof(text), "===	===	===	===	===	===	===	===	===	===\n \n	Survivor:       %s\n	Equipment Cost:      %d XP\n	Infected:    %s	%s	%s\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \nConfirm your talents and equipment for this round?     \n ", surClass, g_iClientTotalXPCost[iClient], g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
			SetMenuTitle(g_hMenu_XPM[iClient], text);
			
			AddMenuItem(g_hMenu_XPM[iClient], "option1", " Yes, confirm.");

			if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
				AddMenuItem(g_hMenu_XPM[iClient], "option2", " No, change Survivor.");
			else if(g_iClientTeam[iClient] == TEAM_INFECTED)
				AddMenuItem(g_hMenu_XPM[iClient], "option2", " No, change Infected.");
			else
				AddMenuItem(g_hMenu_XPM[iClient], "option2", " No, change characters.");

			if(g_iAutoSetCountDown[iClient] > 9)
			{
				switch( (g_iAutoSetCountDown[iClient] % 3) )
				{
					case 0: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		   ->           Closing in %d Seconds           <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 1: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		            ->  Closing in %d Seconds  <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 2: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		        ->      Closing in %d Seconds      <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
				}
			}
			else
			{
				switch( (g_iAutoSetCountDown[iClient] % 3) )
				{
					case 0: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		   ->           Closing in  %d Seconds           <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 1: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		            ->  Closing in  %d Seconds  <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 2: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		        ->      Closing in  %d Seconds      <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
				}
			}
			
			
			AddMenuItem(g_hMenu_XPM[iClient], "option3", text);
			
			SetMenuExitButton(g_hMenu_XPM[iClient], false);
			DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
		}
		else
		{
			ClosePanel(iClient);
			// No longer auto confirm, it will auto close instead
			// if(g_bClientLoggedIn[iClient] == true)
			// {
			// 	g_bTalentsConfirmed[iClient] = true;
			// 	g_iAutoSetCountDown[iClient] = -1;
			// 	PrintHintText(iClient, "Talents Confirmed");
			// 	LoadTalents(iClient);
			// }
		}
	}
	
	return Plugin_Handled;
}

public ConfirmationMessageMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				if(g_bClientLoggedIn[iClient] == true)
				{
					g_bTalentsConfirmed[iClient] = true;
					g_iAutoSetCountDown[iClient] = -1;
					
					PrintHintText(iClient, "Talents Confirmed");
					LoadTalents(iClient);
					ClosePanel(iClient);
				}
			}
			case 1: //No, change character
			{
				g_iAutoSetCountDown[iClient] = -1;
				g_bTalentsConfirmed[iClient] = false;
				g_bUserStoppedConfirmation[iClient] = true;
				ClosePanel(iClient);

				if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
					OpenCharacterSelectionSite(iClient);
				else if (g_iClientTeam[iClient] == TEAM_INFECTED)
					OpenCharacterSelectionSite(iClient);
				else
					OpenCharacterSelectionSite(iClient);

				// Set this value to draw the confirmation once they close the motd and push a button
				if (g_bTalentsConfirmed[iClient] == false)
					g_iOpenCharacterMotdAndDrawMenuState[iClient] = WAITING_ON_RELEASE_FOR_CONFIRM_MENU;
			}
			case 2: //No
			{
				g_iAutoSetCountDown[iClient] = -1;
				g_bTalentsConfirmed[iClient] = false;
				g_bUserStoppedConfirmation[iClient] = true;
				ClosePanel(iClient);
			}
		}
	}
}