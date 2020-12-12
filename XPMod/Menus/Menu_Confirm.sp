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
			IsFakeClient(iClient) == false)
		{
			//g_iAutoSetCountDown[iClient] = 30;
			//CreateTimer((0.1 * iClient), TimerShowTalentsConfirmed, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			//CreateTimer((10.0), CheckIfUserMovedThenOpenCharacterSelectionSite, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

			// Show the players their character selection menu for the round after they press a button
			if(g_bWaitinOnClientInputForChoosingCharacter[iClient] == false)
			{
				g_bWaitinOnClientInputForChoosingCharacter[iClient] = true;
				CreateTimer(0.3, CheckIfUserPressedThenOpenCharacterSelectionSite, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	
	return Plugin_Continue;
}

public Action:TimerOpenCharacterSelectionMenuForUser(Handle:timer, any:iClient)
{

	if (g_iAutoSetCountDown[iClient] == -1 && 
		g_bClientLoggedIn[iClient] == true && 
		g_bTalentsConfirmed[iClient] == false && 
		IsClientInGame(iClient) == true && 
		GetClientMenu(iClient) == MenuSource_None && 
		IsFakeClient(iClient) == false)
	{
		//g_iAutoSetCountDown[iClient] = 30;
		//CreateTimer((0.1 * iClient), TimerShowTalentsConfirmed, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		//CreateTimer((10.0), CheckIfUserMovedThenOpenCharacterSelectionSite, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		OpenInfectedCharacterSelectionSite(iClient);
	}
	
	return Plugin_Stop;
}

public Action:CheckIfUserPressedThenGetDataAndDrawConfirmMenu(Handle:timer, any:iClient)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Stop;
	
	if (g_bWaitinOnClientInputForDrawingMenu[iClient] == true)
		return Plugin_Continue;
	
	PrintToChat(iClient, "CheckIfUserPressedThenGetDataAndDrawConfirmMenu STOP");

	// This will get the user data, and the second true will draw confirm menu in callback
	GetUserData(iClient, true, true);
	return Plugin_Stop;
}

public Action:CheckIfUserPressedThenOpenCharacterSelectionSite(Handle:timer, any:iClient)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Stop;
	
	if (g_bWaitinOnClientInputForChoosingCharacter[iClient] == true)
		return Plugin_Continue;
	
	PrintToChat(iClient, "CheckIfUserPressedThenOpenCharacterSelectionSite STOP");

	// This will open user chacter selection, then get the user data, then will draw confirm menu in callback
	OpenInfectedCharacterSelectionSite(iClient);
	return Plugin_Stop;
}



OpenInfectedCharacterSelectionSite(iClient)
{
	// Prevent the user from seeing the menu twice for the round
	g_bClientAlreadyShownCharacterSelectMenu[iClient] = true;

	// Draw multiple times to prevent from not showing
	CreateTimer(0.1, DrawMultipleMOTDPanels, iClient);
	CreateTimer(0.3, DrawMultipleMOTDPanels, iClient);
	CreateTimer(0.5, DrawMultipleMOTDPanels, iClient);
	CreateTimer(0.7, DrawMultipleMOTDPanels, iClient);
	CreateTimer(1.0, DrawMultipleMOTDPanels, iClient);

	CreateTimer(0.1, StartWaitingForClientInputForDrawMenu, iClient, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.0, CheckIfUserPressedThenGetDataAndDrawConfirmMenu, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action:StartWaitingForClientInputForDrawMenu(Handle:timer, any:iClient)
{
	g_bWaitinOnClientInputForDrawingMenu[iClient] = true;
	return Plugin_Stop;
}

public Action:DrawMultipleMOTDPanels(Handle:timer, any:iClient)
{
	PrintToServer("Drawing MOTD");
	decl String:url[256];
	Format(url, sizeof(url), "http://xpmod.net/select/infected_select.php?i=%i&t=%s", g_iDBUserID[iClient], g_strDBUserToken[iClient]);
	OpenMOTDPanel(iClient, "CHOOSE YOUR INFECTED", url, MOTDPANEL_TYPE_URL);

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
	if(iClient < 1)
		return Plugin_Handled;
	if(IsClientInGame(iClient) == false)
		return Plugin_Handled;
	if(IsFakeClient(iClient) == true)
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
			FormatEx(text, sizeof(text), "================================================\n \n	Survivor Class:       %s\n	Equipment Cost:      %d XP\n	Infected Classes:    %s	%s	%s\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \nConfirm your talents and equipment for this round?\n ", surClass, g_iClientTotalXPCost[iClient], g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
			SetMenuTitle(g_hMenu_XPM[iClient], text);
			
			AddMenuItem(g_hMenu_XPM[iClient], "option1", " Yes, I want these talents for this round.");
			if(g_iAutoSetCountDown[iClient] > 9)
			{
				switch( (g_iAutoSetCountDown[iClient] % 3) )
				{
					case 0: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n   ->           Auto-Confirming in %d Seconds           <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 1: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n            ->  Auto-Confirming in %d Seconds  <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 2: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n        ->      Auto-Confirming in %d Seconds      <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
				}
			}
			else
			{
				switch( (g_iAutoSetCountDown[iClient] % 3) )
				{
					case 0: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n   ->           Auto-Confirming in  %d Seconds           <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 1: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n            ->  Auto-Confirming in  %d Seconds  <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 2: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n        ->      Auto-Confirming in  %d Seconds      <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
				}
			}
			
			AddMenuItem(g_hMenu_XPM[iClient], "option2", text);
			
			SetMenuExitButton(g_hMenu_XPM[iClient], false);
			DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
		}
		else
		{
			ClosePanel(iClient);
			if(g_bClientLoggedIn[iClient] == true)
			{
				g_bTalentsConfirmed[iClient] = true;
				g_iAutoSetCountDown[iClient] = -1;
				PrintHintText(iClient, "Talents Confirmed");
				LoadTalents(iClient);
			}
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
				}
			}
			case 1: //No
			{
				g_iAutoSetCountDown[iClient] = -1;
				g_bTalentsConfirmed[iClient] = false;
				g_bUserStoppedConfirmation[iClient] = true;
			}
		}
	}
}