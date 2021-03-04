Action:TimerCheckAndOpenCharacterSelectionMenuForAll(Handle:timer, any:data)
{
	decl iClient;
	for(iClient = 1; iClient <= MaxClients; iClient++)
	{
		if(g_bClientAlreadyShownCharacterSelectMenu[iClient] == false &&
			g_bUserStoppedConfirmation[iClient] == false &&
			g_iAutoSetCountDown[iClient] == -1 && 
			//g_bClientLoggedIn[iClient] == true && 
			g_bTalentsConfirmed[iClient] == false && 
			IsClientInGame(iClient) == true && 
			GetClientMenu(iClient) == MenuSource_None && 
			IsFakeClient(iClient) == false &&
			g_iClientTeam[iClient] != TEAM_SPECTATORS)
		{
			// Sets the next state of the g_iOpenCharacterSelectAndDrawMenuState which will be handled in OnPlayerRunCmd
			if(g_iOpenCharacterSelectAndDrawMenuState[iClient] == STARTING_CHAR_SELECT_PROCESS)
				g_iOpenCharacterSelectAndDrawMenuState[iClient] = WAITING_ON_BUTTON_FOR_MOTD;
		}
	}
	
	return Plugin_Continue;
}

// Action:TimerOpenCharacterSelectionMenuForUser(Handle:timer, any:iClient)
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
// 		//CreateTimer((10.0), CheckIfUserMovedThenOpenCharacterSelectionPanel, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
// 		OpenCharacterSelectionPanel(iClient);
// 	}
	
// 	return Plugin_Stop;
// }

OpenCharacterSelectionPanel(iClient)
{
	// Close any existing confirmation menu
	g_bUserStoppedConfirmation[iClient] = true;
	ClosePanel(iClient);
	// Prevent the user from seeing the menu twice for the round
	g_bClientAlreadyShownCharacterSelectMenu[iClient] = true;
	
	// Temporarily disabled until valve fixes MOTDs when people join after joining a different server
	// Draw multiple times to prevent from not showing
	//CreateTimer(0.1, DelayedCharacterSelectDrawMOTDPanel, iClient);
	//CreateTimer(0.5, DelayedCharacterSelectDrawMOTDPanel, iClient);

	// Instead of drawing the MOTD, draw the menu
	if (g_bClientLoggedIn[iClient] == true)
		OpenCharacterSelectMenu(iClient);
	else
		CreateNewUserMenuDraw(iClient);
}

ResetTalentConfirmCountdown(iClient)
{
	g_bTalentsConfirmed[iClient] = false;
	g_iAutoSetCountDown[iClient] = -1;
	g_bUserStoppedConfirmation[iClient] = false;
	g_iOpenCharacterSelectAndDrawMenuState[iClient] = STARTING_CHAR_SELECT_PROCESS;
	g_bClientAlreadyShownCharacterSelectMenu[iClient] = false;
}

Action:StartWaitingForClientInputForDrawMenu(Handle:timer, any:iClient)
{
	// This will wait then 2nd button input for drawing the confirm menu
	g_iOpenCharacterSelectAndDrawMenuState[iClient] = WAITING_ON_FINAL_BUTTON_FOR_CONFIRM_MENU;
	//PrintToChat(iClient, "g_iOpenCharacterSelectAndDrawMenuState = WAITING_ON_FINAL_BUTTON_FOR_CONFIRM_MENU");
	return Plugin_Stop;
}

// Action:DelayedCharacterSelectDrawMOTDPanel(Handle:timer, any:iClient)
// {
// 	// PrintToServer("Drawing MOTD");
// 	decl String:url[256];

// 	if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
// 		Format(url, sizeof(url), "http://xpmod.net/select/s/survivor_select.php?id=%i&t=%s", g_iDBUserID[iClient], g_strDBUserToken[iClient]);
// 	else if (g_iClientTeam[iClient] == TEAM_INFECTED)
// 		Format(url, sizeof(url), "http://xpmod.net/select/i/infected_select.php?id=%i&t=%s", g_iDBUserID[iClient], g_strDBUserToken[iClient]);
// 	else
// 		Format(url, sizeof(url), "http://xpmod.net/select/character_select.php?id=%i&t=%s", g_iDBUserID[iClient], g_strDBUserToken[iClient]);
	
// 	OpenMOTDPanel(iClient, " ", url, MOTDPANEL_TYPE_URL);

// 	return Plugin_Stop;
// }

OpenCharacterSelectMenu(iClient)
{
	if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
		ChangeSurvivorMenuDraw(iClient);
	else if (g_iClientTeam[iClient] == TEAM_INFECTED)
		ChangeInfectedMenuDraw(iClient);
	else
		TopChooseCharactersMenuDraw(iClient);
}

Action:TimerShowTalentsConfirmed(Handle:timer, any:iClient)
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

DrawConfirmationMenuToClient(iClient, iDisplayTime = 60)
{
	// Draw Confirmation menu
	g_bUserStoppedConfirmation[iClient] = false;
	g_iAutoSetCountDown[iClient] = iDisplayTime;

	ConfirmationMessageMenuDraw(iClient);

	delete g_hTimer_ShowingConfirmTalents[iClient];
	g_hTimer_ShowingConfirmTalents[iClient] = CreateTimer(1.0, TimerShowTalentsConfirmed, iClient, TIMER_REPEAT);
}

Action:ConfirmationMessageMenuDraw(iClient)
{
	if(RunClientChecks(iClient) == false || 
		IsFakeClient(iClient) == true ||
		g_bClientLoggedIn[iClient] == false)
		return Plugin_Handled;
	
	if(g_bTalentsConfirmed[iClient] == false)
	{
		if(g_iAutoSetCountDown[iClient] > 0)
		{
			CheckMenu(iClient);
			g_hMenu_XPM[iClient] = CreateMenu(ConfirmationMessageMenuHandler);
			
			decl String:surClass[32];
			switch(g_iChosenSurvivor[iClient])
			{
				case BILL: surClass =  "Bill - Support";
				case ROCHELLE: surClass =  "Rochelle - Ninja";
				case COACH: surClass =  "Coach - Berserker";
				case ELLIS: surClass =  "Ellis - Weapons Expert";
				case NICK: surClass =  "Nick - Gambler";
				case LOUIS: surClass =  "Louis - Disruptor";
				default: surClass = "NONE";
			}
			
			decl String:text[300];
			FormatEx(text, sizeof(text), "\n \n===	===	===	===	===	===	===	===	===	===\n \n	Survivor:			   %s\n	Equipment Cost:	 %d XP\n	Infected:				%s	%s	%s\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \nConfirm your Characters and Equipment for this round?     \n ", surClass, g_iClientTotalXPCost[iClient], g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
			SetMenuTitle(g_hMenu_XPM[iClient], text);
			
			AddMenuItem(g_hMenu_XPM[iClient], "option1", " Yes, confirm.");

			if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
				AddMenuItem(g_hMenu_XPM[iClient], "option2", " No, change Survivor/Equipment.");
			else if(g_iClientTeam[iClient] == TEAM_INFECTED)
				AddMenuItem(g_hMenu_XPM[iClient], "option2", " No, change Infected.");
			else
				AddMenuItem(g_hMenu_XPM[iClient], "option2", " No, change Characters.");

			if(g_iAutoSetCountDown[iClient] > 9)
			{
				switch( (g_iAutoSetCountDown[iClient] % 3) )
				{
					case 0: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		   ->           Closing in %d Seconds           <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 1: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		            ->  Closing in %d Seconds  <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 2: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		        ->      Closing in %d Seconds      <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
				}
			}
			else
			{
				switch( (g_iAutoSetCountDown[iClient] % 3) )
				{
					case 0: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		   ->           Closing in  %d Seconds           <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 1: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		            ->  Closing in  %d Seconds  <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 2: FormatEx(text, sizeof(text), " No, not yet.\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n		        ->      Closing in  %d Seconds      <-\n \n===	===	===	===	===	===	===	===	===	===\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
				}
			}
			
			
			AddMenuItem(g_hMenu_XPM[iClient], "option3", text);
			
			SetMenuExitButton(g_hMenu_XPM[iClient], false);
			DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
		}
		else
		{
			g_bUserStoppedConfirmation[iClient] = true;
			ClosePanel(iClient);
		}
	}
	
	return Plugin_Handled;
}

ConfirmationMessageMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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

					PrintHintText(iClient, "Characters Confirmed");
					LoadTalents(iClient);
					ClosePanel(iClient);
					
					RenamePlayerWithLevelTags(iClient);
				}
			}
			case 1: //No, change character
			{
				g_iAutoSetCountDown[iClient] = -1;
				g_bTalentsConfirmed[iClient] = false;
				g_bUserStoppedConfirmation[iClient] = true;
				ClosePanel(iClient);

				if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
					OpenCharacterSelectionPanel(iClient);
				else if (g_iClientTeam[iClient] == TEAM_INFECTED)
					OpenCharacterSelectionPanel(iClient);
				else
					OpenCharacterSelectionPanel(iClient);

				// Set this value to draw the confirmation once they close the motd and push a button
				if (g_bTalentsConfirmed[iClient] == false)
					g_iOpenCharacterSelectAndDrawMenuState[iClient] = WAITING_ON_RELEASE_FOR_CONFIRM_MENU;
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