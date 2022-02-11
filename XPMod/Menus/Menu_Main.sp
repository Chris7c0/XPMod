//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////         XPMod Menus         ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ClosePanel(iClient)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	Panel panel = CreatePanel();
	SetPanelTitle(panel, " ");
	SendPanelToClient(panel, iClient, EmptyPanelHandler, 1);

	delete panel;
}

GetNewLinesToPushMenuDown(iClient, char strStartingNewLines[32])
{
	// if Client is specator or ghost
	if (g_iClientTeam[iClient] == TEAM_SPECTATORS)// || g_bIsGhost[iClient] == true)
		strStartingNewLines = "\n \n \n \n \n \n";
	else if (g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == false)
		strStartingNewLines = "\n \n \n \n \n \n \n \n";
	else
		strStartingNewLines = "\n \n";
}

GetNewLinesToPushMenuUp(iClient, char strEndingNewLines[32])
{
	// if Client is specator or ghost
	if (g_iClientTeam[iClient] == TEAM_SPECTATORS)// || g_bIsGhost[iClient] == true)
		strEndingNewLines = "\n \n ";
	else if (g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == false)
		strEndingNewLines = "";
	else
		strEndingNewLines = "\n \n \n \n \n \n ";
}

XPModMenuDraw(iClient)
{
	// For client hosted games
	if (iClient == 0)
		iClient=1;
	
	if (RunClientChecks(iClient))
	{		
		if(g_bClientLoggedIn[iClient] == false)
		{
			CreateNewUserMenuDraw(iClient);
			return;
		}
		
		// Turn off the client IDD menu in case they have it enabled
		g_bClientIDDToggle[iClient] = false;
		
		// This will get the user data, then draw the menu once its returned
		if(g_bClientLoggedIn[iClient] == true)
			GetUserData(iClient, true, false, true);
	}
}


//Menu Draw Functions                                                                                     
//Top XPMod Menu Draw
Action:TopMenuDraw(iClient) 
{
	RoundStatsPanel[iClient] = ROUND_STATS_PANEL_DONE;

	g_bUserStoppedConfirmation[iClient] = true;
	DeleteAllMenuParticles(iClient);

	CheckLevel(iClient);
	
	Menu menu = CreateMenu(TopMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	// Title
	if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
		switch(g_iChosenSurvivor[iClient])
		{
			case BILL: 		SetMenuTitle(menu, "%s				XP Mod\n			v %s\n▬▬▬▬▬▬▬▬▬▬▬▬▬\nLevel  %d  Support\nXP:   %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬", strStartingNewLines, PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case ROCHELLE:	SetMenuTitle(menu, "%s				XP Mod\n			v %s\n▬▬▬▬▬▬▬▬▬▬▬▬▬\nLevel  %d  Ninja\nXP:   %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬", strStartingNewLines, PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case COACH:		SetMenuTitle(menu, "%s				XP Mod\n			v %s\n▬▬▬▬▬▬▬▬▬▬▬▬▬\nLevel  %d  Berserker\nXP:   %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬", strStartingNewLines, PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case ELLIS:		SetMenuTitle(menu, "%s				XP Mod\n			v %s\n▬▬▬▬▬▬▬▬▬▬▬▬▬\nLevel %d Weapon Expert\nXP:   %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬", strStartingNewLines, PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case NICK:		SetMenuTitle(menu, "%s				XP Mod\n			v %s\n▬▬▬▬▬▬▬▬▬▬▬▬▬\nLevel  %d  Gambler\nXP:   %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬", strStartingNewLines, PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case LOUIS:		SetMenuTitle(menu, "%s				XP Mod\n			v %s\n▬▬▬▬▬▬▬▬▬▬▬▬▬\nLevel  %d  Disruptor\nXP:   %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬", strStartingNewLines, PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		}
	else if(g_iClientTeam[iClient] == TEAM_INFECTED)
		SetMenuTitle(menu, "%s				XP Mod\n			v %s\n▬▬▬▬▬▬▬▬▬▬▬▬▬\nLevel  %d  Infected\nXP:   %d/%d\n \nClass 1) %s\nClass 2) %s\nClass 3) %s\n▬▬▬▬▬▬▬▬▬▬▬▬▬", strStartingNewLines, PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	else
		SetMenuTitle(menu, "%s				XP Mod\n			v %s\n▬▬▬▬▬▬▬▬▬▬▬▬▬\nLevel %d\nXP:     %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬", strStartingNewLines, PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	
	// Option 1
	if (g_bTalentsConfirmed[iClient] == true)
	{
		AddMenuItem(menu, "option1", "Learn About Characters");
	}
	else
	{
		if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
			AddMenuItem(menu, "option1", "Change Your Survivor");
		else if (g_iClientTeam[iClient] == TEAM_INFECTED)
			AddMenuItem(menu, "option1", "Change Your Infected");
		else
			AddMenuItem(menu, "option1", "Change Your Characters");
	}
	
	// Options 2 and 3
	AddMenuItem(menu, "option2", "Change Your Equipment");
	AddMenuItem(menu, "option3", "Extras");

	// Options 4 and 5
	if(g_bTalentsConfirmed[iClient] == true)
	{
		AddMenuItem(menu, "option4", "Help\n ");
		AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	}
	else
	{
		AddMenuItem(menu, "option4", "Help\n \n   You need to Confirm\n   your Characters for\n   your abilities to work!");
		AddMenuItem(menu, "option5", "* Confirm Characters *\n ");
	}

	// Options 6 and 7
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);

	// Option 8
	if (GetClientAdminLevel(iClient) > 0)
		AddMenuItem(menu, "option8", "Admin Menu");
	else
		AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	// Option 9
	AddMenuItem(menu, "option9", "", ITEMDRAW_NOTEXT);

	// Option 10 (This is the tricky bit, to get the menu at the right height)
	// This must consider all the new lines for all the conditions above
	// Start with a baseline of newlines, then add the others for each condition
	decl String:strFinalOptionText[150];
	Format(strFinalOptionText, sizeof(strFinalOptionText), 
		"Exit the Menu\
		\n▬▬▬▬▬▬▬▬▬▬▬▬▬\
		%s\
		\n \n \n \n \n \n \n \n \n \n \n \
		%s%s%s",
		strEndingNewLines,
		g_iClientTeam[iClient] == TEAM_INFECTED ? "" : "\n \n \n \n ",
		g_bTalentsConfirmed[iClient] == false ? "" : "\n \n \n \n \n ",
		GetClientAdminLevel(iClient) > 0 ? "" : "\n ")
	AddMenuItem(menu, "option10", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}


// Learn about characters
Action:TopChooseCharactersMenuDraw(iClient)
{
	Menu menu = CreateMenu(TopChooseCharactersMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	SetMenuTitle(menu, "%s\
	\nChoose A Team\
	\n▬▬▬▬▬▬▬▬▬▬▬\n",
	strStartingNewLines);
	AddMenuItem(menu, "option1", "Survivors");
	AddMenuItem(menu, "option2", "Infected\n ");
	AddMenuItem(menu, "option3", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText), "Main Menu\n \nNote: Once you are\nconfirmed, you must\nwait until the next\nround to change any\nof your characters.\
	\n▬▬▬▬▬▬▬▬▬▬▬\
	%s\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
	strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


//Select Talents
Action:ExtrasMenuDraw(iClient)
{
	Menu menu = CreateMenu(ExtrasMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	SetMenuTitle(menu, "%s\
	XPMod Extras\
	\n▬▬▬▬▬▬▬▬▬▬▬\n",
	strStartingNewLines);
	AddMenuItem(menu, "option1", "Change Team");
	AddMenuItem(menu, "option2", "Statistics");
	AddMenuItem(menu, "option3", "Options");
	AddMenuItem(menu, "option4", "Get XPMod Addon");
	AddMenuItem(menu, "option5", "XPMod Website");
	AddMenuItem(menu, "option6", "Ban Me\n ");
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	decl String:strFinalOptionText[150];
	Format(strFinalOptionText, sizeof(strFinalOptionText), "Main Menu\
	\n▬▬▬▬▬▬▬▬▬▬▬\
	%s\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
	strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Team Menu Draw
Action:ChooseTeamMenuDraw(iClient)
{
	Menu menu = CreateMenu(ChooseTeamMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	SetMenuTitle(menu, "%s\
	Choose A Team\
	\n▬▬▬▬▬▬▬▬▬▬▬\n",
	strStartingNewLines);
	AddMenuItem(menu, "option1", "Survivors");
	AddMenuItem(menu, "option2", "Infected");
	AddMenuItem(menu, "option3", "Spectators\n ");
	AddMenuItem(menu, "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	decl String:strFinalOptionText[150];
	Format(strFinalOptionText, sizeof(strFinalOptionText), "Back\
	\n▬▬▬▬▬▬▬▬▬▬▬\
	%s\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
	strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


// Learn about characters
Action:ChooseStatisticsMenuDraw(iClient)
{
	Menu menu = CreateMenu(ChooseStatisticsMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	SetMenuTitle(menu, "%s\
	\nChoose The Statistics You Want To See\
	\n▬▬▬▬▬▬▬▬▬▬▬\n",
	strStartingNewLines);
	AddMenuItem(menu, "option1", "Last Round Stats");
	AddMenuItem(menu, "option2", "Current Round Stats\n ");
	AddMenuItem(menu, "option3", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	decl String:strFinalOptionText[150];
	Format(strFinalOptionText, sizeof(strFinalOptionText), "Back\
	\n▬▬▬▬▬▬▬▬▬▬▬\
	%s\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
	strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

Action:OptionMenuDraw(iClient)
{
	Menu menu = CreateMenu(OptionMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	SetMenuTitle(menu, "\
	%s		 XP Mod Options\
	\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬",
	strStartingNewLines);
	
	if(g_iXPDisplayMode[iClient]==0)
		AddMenuItem(menu, "option1", "XP Display Mode: In Game\n       - Requires XPMod Addon\n ");
	else if(g_iXPDisplayMode[iClient]==1)
		AddMenuItem(menu, "option1", "XP Display Mode: In Chat\n ");
	else
		AddMenuItem(menu, "option1", "XP Display Mode : Off\n ");
	
	if(g_bAnnouncerOn[iClient]==false)
		AddMenuItem(menu, "option2", "Turn Announcer On\n ");
	else
		AddMenuItem(menu, "option2", "Turn Announcer Off\n ");
	
	if(g_bEnabledVGUI[iClient]==true)
		AddMenuItem(menu, "option3", "Turn VGUI Descriptions Off\n       - Requires XPMod Addon\n ");
	else
		AddMenuItem(menu, "option3", "Turn VGUI Descriptions On\n       - Requires XPMod Addon\n ");
	
	AddMenuItem(menu, "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	decl String:strFinalOptionText[150];
	Format(strFinalOptionText, sizeof(strFinalOptionText), "Back\
	\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n\
	%s\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
	strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Menu Handler Functions                                                                                   
//Top Menu Handler

TopChooseCharactersMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Choose Survivors
			{
				TopSurvivorMenuDraw(iClient);
			}
			case 1: //Choose Infected
			{
				TopInfectedMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopMenuDraw(iClient);
			}
		}
	}
}

//Top Menu For Everything
TopMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Choose Characters
			{
				if(g_bTalentsConfirmed[iClient] == false)
				{
					OpenCharacterSelectionPanel(iClient);

					// Set this value to draw the confirmation once they close the motd and push a button
					g_iOpenCharacterSelectAndDrawMenuState[iClient] = WAITING_ON_RELEASE_FOR_CONFIRM_MENU;
				}
				else
				{
					TopChooseCharactersMenuDraw(iClient);
					// if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
					// 	TopSurvivorMenuDraw(iClient);
					// else if (g_iClientTeam[iClient] == TEAM_INFECTED)
					// 	TopInfectedMenuDraw(iClient);
					// else
					// 	TopChooseCharactersMenuDraw(iClient);
				}
				
				
				
			}
			case 1: //Choose Loadout
			{
				LoadoutMenuDraw(iClient);
			}
			case 2: //XPMod Extras
			{
				ExtrasMenuDraw(iClient);
			}
			case 3: //Help and HowTo
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/help/xpmod_ig_help.html", MOTDPANEL_TYPE_URL);
				//TopHelpMenuDraw(iClient);
			}
			case 4: //Confirm Talents
			{
				DrawConfirmationMenuToClient(iClient);
			}
			case 7: //Admin menu
			{
				if (GetClientAdminLevel(iClient) > 0)
					AdminMenuDraw(iClient);
			}
		}
	}
}

ExtrasMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Choose Team
			{
				ChooseTeamMenuDraw(iClient);
			}
			case 1: //Choose Stats Menu
			{
				ChooseStatisticsMenuDraw(iClient)
			}
			case 2: //Options
			{
				OptionMenuDraw(iClient);
			}
			case 3: //Get XPMod Addon
			{
				OpenMOTDPanel(iClient, "Download XPMod Addon", "\
					You can download while in game by:\
					\n \
					\n1: Click on Join this server's Steam Group... at the bottom right.\
					\n2: Click Get XPMod Addon.\
					\n3: Click on + Subscribe.\
					\n4: Relaunch Left4Dead2 or wait until next time.", MOTDPANEL_TYPE_TEXT);
			}
			case 4: //Website
			{
				OpenMOTDPanel(iClient, "Access XPMod.net", "\
					On your phone or any web browser, go to:\
					\n \
					\nxpmod.net\
					\n \
					\n \
					\nOr:\
					\n 1: Click Join this server's Steam Group... at the bottom right\
					\n 2: Click Visit XPMod.net on the left", MOTDPANEL_TYPE_TEXT);
			}
			case 5: //Ban Me
			{
				BanMeMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopMenuDraw(iClient);
			}
		}
	}
}

//Choose Team Menu Handler
ChooseTeamMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if(RunClientChecks(iClient) == false || IsFakeClient(iClient))
			return;

		if (g_bPlayerInTeamChangeCoolDown[iClient])
		{
			PrintToChat(iClient, "\x03[XPMod] \x05You can only change teams once every 3 seconds.");
			ChooseTeamMenuDraw(iClient);
			return;
		}

		if (itemNum == 8)
		{
			ExtrasMenuDraw(iClient);
			return;
		}

		new iTeam = TEAM_SPECTATORS;

		switch (itemNum)
		{
			case 0: iTeam = TEAM_SURVIVORS;
			case 1: iTeam = TEAM_INFECTED;
			case 2: iTeam = TEAM_SPECTATORS;
		}
		
		if (SwitchPlayerTeam(iClient, iClient, iTeam) == false)
			ChooseTeamMenuDraw(iClient);
	}
}

ChooseStatisticsMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Last Round Statistics
			{
				ShowRoundStatsPanelsToPlayer(iClient);
			}
			case 1: //Currnt Round Statistics
			{
				ShowTeamStatsToPlayer(iClient, iClient);
			}
			case 8: //Back
			{
				ExtrasMenuDraw(iClient);
			}
		}
	}
}

OptionMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch (itemNum)
		{			
			case 0: //Change XP Display Mode
			{
				ChangeXPDisplayMode(iClient);
				OptionMenuDraw(iClient);
			}
			case 1: //Toggle announcer
			{
				ToggleAnnouncerVoice(iClient);
				OptionMenuDraw(iClient);
			}
			case 2: //Toggle VGUI Particle Descriptions
			{
				ToggleVGUIDesc(iClient);
				OptionMenuDraw(iClient);
			}
			case 8: //Back
			{
				ExtrasMenuDraw(iClient);
			}
		}
	}
}


int EmptyPanelHandler(Menu menu, MenuAction action, int param1, int param2)
{

}