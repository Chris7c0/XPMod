Action TimerCheckAndOpenCharacterSelectionMenuForAll(Handle timer, int data)
{
	int iClient;
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

void OpenCharacterSelectionPanel(int iClient)
{
	// Close any existing confirmation menu
	g_bUserStoppedConfirmation[iClient] = true;
	ClosePanel(iClient);
	// Prevent the user from seeing the menu twice for the round
	g_bClientAlreadyShownCharacterSelectMenu[iClient] = true;

	// Instead of drawing the MOTD, draw the menu
	if (g_bClientLoggedIn[iClient] == true)
		OpenCharacterSelectMenu(iClient);
	else
		CreateNewUserMenuDraw(iClient);
}

void ResetTalentConfirmCountdown(int iClient)
{
	g_bTalentsConfirmed[iClient] = false;
	ResetSurvivorClassTalentsRuntimeState(iClient);
	g_bConfirmedSurvivorTalentsGivenThisRound[iClient] = false;
	g_iAutoSetCountDown[iClient] = -1;
	g_bUserStoppedConfirmation[iClient] = false;
	g_iOpenCharacterSelectAndDrawMenuState[iClient] = STARTING_CHAR_SELECT_PROCESS;
	g_bClientAlreadyShownCharacterSelectMenu[iClient] = false;
}

Action StartWaitingForClientInputForDrawMenu(Handle timer, int iClient)
{
	// This will wait then 2nd button input for drawing the confirm menu
	g_iOpenCharacterSelectAndDrawMenuState[iClient] = WAITING_ON_FINAL_BUTTON_FOR_CONFIRM_MENU;
	return Plugin_Stop;
}

void OpenCharacterSelectMenu(int iClient)
{
	if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
		ChangeSurvivorMenuDraw(iClient);
	else if (g_iClientTeam[iClient] == TEAM_INFECTED)
		ChangeInfectedMenuDraw(iClient);
	else
		TopChooseCharactersMenuDraw(iClient);
}

Action TimerShowTalentsConfirmed(Handle timer, int iClient)
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

void DrawConfirmationMenuToClient(int iClient, int iDisplayTime = 60)
{
	// Auto confirm if the option is enabled
	if(g_bAutoConfirm[iClient] == true && g_bClientLoggedIn[iClient] == true)
	{
		g_bTalentsConfirmed[iClient] = true;
		g_iAutoSetCountDown[iClient] = -1;
		g_bUserStoppedConfirmation[iClient] = true;
		SaveUserData(iClient);
		SaveSurvivorPick(iClient);
		SaveInfectedPick(iClient);

		PrintHintText(iClient, "Characters Auto-Confirmed");
		LoadTalents(iClient);
		ClosePanel(iClient);

		RenamePlayerWithLevelTags(iClient);

		ShowRoundStatsPanelsToPlayer(iClient);
		return;
	}

	// Draw Confirmation menu
	g_bUserStoppedConfirmation[iClient] = false;
	g_iAutoSetCountDown[iClient] = iDisplayTime;

	ConfirmationMessageMenuDraw(iClient);

	delete g_hTimer_ShowingConfirmTalents[iClient];
	g_hTimer_ShowingConfirmTalents[iClient] = CreateTimer(1.0, TimerShowTalentsConfirmed, iClient, TIMER_REPEAT);
}

Action ConfirmationMessageMenuDraw(int iClient)
{
	if(RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) == true ||
		g_bClientLoggedIn[iClient] == false)
		return Plugin_Handled;

	if(g_bTalentsConfirmed[iClient] == true)
		return Plugin_Handled;

	if(g_iAutoSetCountDown[iClient] <= 0)
	{
		g_bUserStoppedConfirmation[iClient] = true;
		ClosePanel(iClient);
		return Plugin_Handled;
	}

	Menu menu = CreateMenu(ConfirmationMessageMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	// Survivor class name
	char surClass[32];
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL: 	surClass = "Bill - Support";
		case ROCHELLE:	surClass = "Rochelle - Ninja";
		case COACH:	surClass = "Coach - Berserker";
		case ELLIS:	surClass = "Ellis - Weapons Expert";
		case NICK:	surClass = "Nick - Gambler";
		case LOUIS:	surClass = "Louis - Disruptor";
		case ZOEY:	surClass = "Zoey - R.C. Medic";
		default:	surClass = "NONE";
	}

	// Title
	char text[512], strNewLines[512];
	FormatEx(text, sizeof(text), "%s===	===	===	===	===	===	===	===	===	===\n \n	Survivor:			   %s\n	Equipment Cost:	 %d XP\n	Infected:				%s	%s	%s\n \n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \nConfirm your Characters and Equipment for this round? \n ", strStartingNewLines, surClass, g_iClientTotalXPCost[iClient], g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(menu, "%s", text);

	// Calculate menu option newlines for automatic padding
	// 10 accounts for 3 option slots + 7 fixed newlines in option3 text
	GetNewLinesAutomatic(text, strNewLines, 10);

	// Option 1
	AddMenuItem(menu, "option1", "Yes, confirm!");

	// Option 2
	if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
		AddMenuItem(menu, "option2", "No, change Survivor/Equipment.");
	else if(g_iClientTeam[iClient] == TEAM_INFECTED)
		AddMenuItem(menu, "option2", "No, change Infected.");
	else
		AddMenuItem(menu, "option2", "No, change Characters.");

	// Option 3 - Countdown with bouncing arrow animation
	char strArrowLine[128];
	char strDigitPad[4] = "";
	if(g_iAutoSetCountDown[iClient] <= 9)
		strDigitPad = " ";

	switch(g_iAutoSetCountDown[iClient] % 3)
	{
		case 0: FormatEx(strArrowLine, sizeof(strArrowLine), "\t\t   ->           Closing in %s%d Seconds           <-", strDigitPad, g_iAutoSetCountDown[iClient]);
		case 1: FormatEx(strArrowLine, sizeof(strArrowLine), "\t\t            ->  Closing in %s%d Seconds  <-", strDigitPad, g_iAutoSetCountDown[iClient]);
		case 2: FormatEx(strArrowLine, sizeof(strArrowLine), "\t\t        ->      Closing in %s%d Seconds      <-", strDigitPad, g_iAutoSetCountDown[iClient]);
	}

	char strOption3Text[512];
	Format(strOption3Text, sizeof(strOption3Text), "No, not yet.\
	\n \
	\n ~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\
	\n \
	\n%s\
	\n \
	\n===	===	===	===	===	===	===	===	===	===\
	\n %s%s",
	strArrowLine, strNewLines, strEndingNewLines);
	AddMenuItem(menu, "option3", strOption3Text);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

void ConfirmationMessageMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				if(g_bClientLoggedIn[iClient] == true)
				{
					g_bTalentsConfirmed[iClient] = true;
					g_iAutoSetCountDown[iClient] = -1;
					SaveUserData(iClient);
					SaveSurvivorPick(iClient);
					SaveInfectedPick(iClient);

					PrintHintText(iClient, "Characters Confirmed");
					LoadTalents(iClient);
					ClosePanel(iClient);

					RenamePlayerWithLevelTags(iClient);

					ShowRoundStatsPanelsToPlayer(iClient);
				}
			}
			case 1: //No, change character
			{
				g_iAutoSetCountDown[iClient] = -1;
				g_bTalentsConfirmed[iClient] = false;
				g_bUserStoppedConfirmation[iClient] = true;
				ClosePanel(iClient);

				OpenCharacterSelectionPanel(iClient);

				// Set this value to draw the confirmation once they close the motd and push a button
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
