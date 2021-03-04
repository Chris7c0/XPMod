//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////         XPMod Menus         ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////          Top Menu         ////////////////////////////////////////////////
CheckMenu(iClient)	//Checks the menu to see if it is not invalid handle, if it is close the handle to stop memory leaks
{
	if(g_hMenu_XPM[iClient] != INVALID_HANDLE)
	{
		CloseHandle(g_hMenu_XPM[iClient]);
		g_hMenu_XPM[iClient]=INVALID_HANDLE;
	}
}

CleanUpMenuHandles()	//Puts all the menu handles at invalid to minimize the amount of handles open
{
	for(new iClient = 0; iClient <= MaxClients; iClient++)
	{
		if(g_hMenu_XPM[iClient]!=INVALID_HANDLE)
		{
			CloseHandle(g_hMenu_XPM[iClient]);
			g_hMenu_XPM[iClient]=INVALID_HANDLE;
		}
		if(g_hMenu_IDD[iClient]!=INVALID_HANDLE)
		{
			CloseHandle(g_hMenu_IDD[iClient]);
			g_hMenu_IDD[iClient]=INVALID_HANDLE;
		}
	}
}

Action:CloseClientPanel(iClient, args)
{
	if(iClient < 1)
		iClient=1;
	if(IsClientInGame(iClient))
		if(IsFakeClient(iClient) == false)
			ClosePanel(iClient);
	
	return Plugin_Handled;
}

Action:ClosePanel(iClient)
{
	if(iClient< 1)
		iClient=1;
	if(IsClientInGame(iClient) == false)
		return Plugin_Handled;
	if(IsFakeClient(iClient) == true)
		return Plugin_Handled;
	
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreatePanel();
	SetPanelTitle(g_hMenu_XPM[iClient], " ");
	SendPanelToClient(g_hMenu_XPM[iClient], iClient, ConfirmationMessageMenuHandler, 1);
	//CloseHandle(g_hMenu_XPM[iClient]);
	CheckMenu(iClient);
	
	return Plugin_Handled;
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
	g_bUserStoppedConfirmation[iClient] = true;
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	CheckLevel(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(TopMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	// Title
	if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
		switch(g_iChosenSurvivor[iClient])
		{
			case BILL: 		SetMenuTitle(g_hMenu_XPM[iClient], "\n \n		  XP Mod %s\n=========================\nLevel  %d  Support\nXP:   %d/%d\n=========================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case ROCHELLE:	SetMenuTitle(g_hMenu_XPM[iClient], "\n \n		  XP Mod %s\n=========================\nLevel  %d  Ninja\nXP:   %d/%d\n=========================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case COACH:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \n		  XP Mod %s\n=========================\nLevel  %d  Berserker\nXP:   %d/%d\n=========================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case ELLIS:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \n		  XP Mod %s\n=========================\nLevel %d Weapon Expert\nXP:   %d/%d\n=========================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case NICK:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \n		  XP Mod %s\n=========================\nLevel  %d  Gambler\nXP:   %d/%d\n=========================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case LOUIS:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \n		  XP Mod %s\n=========================\nLevel  %d  Disruptor\nXP:   %d/%d\n=========================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		}
	else if(g_iClientTeam[iClient] == TEAM_INFECTED)
		SetMenuTitle(g_hMenu_XPM[iClient], "\n \n		  XP Mod %s\n=========================\nLevel  %d  Infected\nXP:   %d/%d\n \nClass 1) %s\nClass 2) %s\nClass 3) %s\n=========================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	else
		SetMenuTitle(g_hMenu_XPM[iClient], "\n \n		  XP Mod %s\n=========================\nLevel %d\nXP:     %d/%d\n=========================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	
	// Option 1
	if (g_bTalentsConfirmed[iClient] == true)
	{
		AddMenuItem(g_hMenu_XPM[iClient], "option1", "Learn About Characters");
	}
	else
	{
		if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
			AddMenuItem(g_hMenu_XPM[iClient], "option1", "Change Your Survivor");
		else if (g_iClientTeam[iClient] == TEAM_INFECTED)
			AddMenuItem(g_hMenu_XPM[iClient], "option1", "Change Your Infected");
		else
			AddMenuItem(g_hMenu_XPM[iClient], "option1", "Change Your Characters");
	}
	
	// Options 2 and 3
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Change Your Equipment");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Extras");

	// Options 4 and 5
	if(g_bTalentsConfirmed[iClient] == true)
	{
		AddMenuItem(g_hMenu_XPM[iClient], "option4", "Help\n ");
		AddMenuItem(g_hMenu_XPM[iClient], "option5", "", ITEMDRAW_NOTEXT);
	}
	else
	{
		AddMenuItem(g_hMenu_XPM[iClient], "option4", "Help\n \n   You need to Confirm\n   your Characters for\n  your abilities to work!");
		AddMenuItem(g_hMenu_XPM[iClient], "option5", "* Confirm Characters *\n ");
	}

	// Options 6 and 7
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);

	// Option 8
	if (GetClientAdminLevel(iClient) > 0 && iClient == -99)
		AddMenuItem(g_hMenu_XPM[iClient], "option8", "Admin Menu");
	else
		AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);

	// Option 9
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "", ITEMDRAW_NOTEXT);

	// Option 10 (This is the tricky bit, to get the menu at the right height)
	// This must consider all the new lines for all the conditions above
	// Start with a baseline of newlines, then add the others for each condition
	decl String:strFinalOptionText[150];
	Format(strFinalOptionText, sizeof(strFinalOptionText), 
		"Exit the Menu\
		\n=========================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \
		%s%s%s",
		g_iClientTeam[iClient] == TEAM_INFECTED ? "" : "\n \n \n \n ",
		g_bTalentsConfirmed[iClient] == false ? "" : "\n \n \n \n \n ",
		GetClientAdminLevel(iClient) > 0 && iClient == -99 ? "" : "\n ")
	AddMenuItem(g_hMenu_XPM[iClient], "option10", strFinalOptionText);

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}


// Learn about characters
Action:TopChooseCharactersMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(TopChooseCharactersMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);

	SetMenuTitle(g_hMenu_XPM[iClient], 
	"\n \n\
	Choose A Team\
	\n======================\n");
	//\n▬▬▬▬▬▬▬▬▬▬▬\n");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Survivors");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Infected\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Main Menu\n \nNote: Once you are\nconfirmed, you must\nwait until the next\nround to change any\nof your characters.\
	\n======================\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


//Select Talents
Action:ExtrasMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ExtrasMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);

	SetMenuTitle(g_hMenu_XPM[iClient], 
	"\n \n\
	XPMod Extras\
	\n======================\n");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Change Team");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Player Stats");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Options");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Get XPMod Addon");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "XPMod Website");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Ban Me\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Main Menu\
	\n======================\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Team Menu Draw
Action:ChooseTeamMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChooseTeamMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);

	SetMenuTitle(g_hMenu_XPM[iClient], "\n \nChoose A Team\n=====================\n");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Survivors");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Infected");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Spectators\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\
	\n=====================\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

Action:OptionMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(OptionMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);

	SetMenuTitle(g_hMenu_XPM[iClient], "\n \n		 XP Mod Options\n=	=	=	=	=	=	=	=	=\n");
	
	if(g_iXPDisplayMode[iClient]==0)
		AddMenuItem(g_hMenu_XPM[iClient], "option1", "XP Display Mode: In Game\n       - Requires XPMod Addon\n ");
	else if(g_iXPDisplayMode[iClient]==1)
		AddMenuItem(g_hMenu_XPM[iClient], "option1", "XP Display Mode: In Chat\n ");
	else
		AddMenuItem(g_hMenu_XPM[iClient], "option1", "XP Display Mode : Off\n ");
	
	if(g_bAnnouncerOn[iClient]==false)
		AddMenuItem(g_hMenu_XPM[iClient], "option2", "Turn Announcer On\n ");
	else
		AddMenuItem(g_hMenu_XPM[iClient], "option2", "Turn Announcer Off\n ");
	
	if(g_bEnabledVGUI[iClient]==true)
		AddMenuItem(g_hMenu_XPM[iClient], "option3", "Turn VGUI Descriptions Off\n       - Requires XPMod Addon\n ");
	else
		AddMenuItem(g_hMenu_XPM[iClient], "option3", "Turn VGUI Descriptions On\n       - Requires XPMod Addon\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\
	\n=	=	=	=	=	=	=	=	=\n\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Menu Handler Functions                                                                                   
//Top Menu Handler

TopChooseCharactersMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
TopMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action == MenuAction_Select)
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

ExtrasMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Choose Team
			{
				ChooseTeamMenuDraw(iClient);
			}
			case 1: //Player Stats
			{
				ShowTeamStatsToPlayer(iClient, iClient);
			}
			case 2: //Options
			{
				OptionMenuDraw(iClient);
			}
			case 3: //Get XPMod Addon
			{
				OpenMOTDPanel(iClient, "Download XPMod Addon", "http://xpmod.net/downloads/xpmod_ig_downloads.html", MOTDPANEL_TYPE_URL);
			}
			case 4: //Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/index.html", MOTDPANEL_TYPE_URL);
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
ChooseTeamMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		if(RunClientChecks(iClient) == false || IsFakeClient(iClient))
			return;

		if (g_bPlayerInTeamChangeCoolDown[iClient])
		{
			PrintToChat(iClient, "\x03[XPMod] \x05You can only change teams once every 3 seconds.");
			ChooseTeamMenuDraw(iClient);
			return;
		}

		switch (itemNum)
		{
			case 0: //Switch to Survivor
			{
				g_bClientSpectating[iClient] = false;
				if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You are already on the \x04Survivor Team\x05.");
					ChooseTeamMenuDraw(iClient);
					return;
				}

				if(!IsTeamFull(TEAM_SURVIVORS))
				{
					// First we switch to spectators
					ChangeClientTeam(iClient, TEAM_SPECTATORS); 

					// Look for a survivor bot then take them over
					for (int i=1; i <= MaxClients; i++)
					{
						if (RunClientChecks(i) && 
							IsFakeClient(i) &&
							GetClientTeam(i) == TEAM_SURVIVORS)
						{
							// Found a valid Survivor bot, force survivor bot to spectator
							SDKCall(g_hSDK_SetHumanSpec, i, iClient); 
							
							// Force player to take over survivor bot's place
							SDKCall(g_hSDK_TakeOverBot, iClient, true);
							g_iClientTeam[iClient] = TEAM_SURVIVORS;
							PrintToChatAll("\x03%N \x05moved to the \x04survivors", iClient);
							return;
						}
					}					
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05The \x04Survivor Team \x05is full.");
					ChooseTeamMenuDraw(iClient);
				}
			}
			case 1: //Switch to Infected
			{
				g_bClientSpectating[iClient] = false;
				if(g_iClientTeam[iClient] == TEAM_INFECTED)
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You are already on the \x04Infected Team\x05.");
					ChooseTeamMenuDraw(iClient);
					return;
				}
				if(g_iGameMode == GAMEMODE_VERSUS)
				{
					if(!IsTeamFull(TEAM_INFECTED))
					{
						ChangeClientTeam(iClient, TEAM_INFECTED);
						g_iClientTeam[iClient] = TEAM_INFECTED;
						PrintToChatAll("\x03%N \x05moved to the \x04infected", iClient);
					}
					else
					{
						PrintToChat(iClient, "\x03[XPMod] \x05The \x04Infected Team \x05is full.");
						ChooseTeamMenuDraw(iClient);
					}
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x04You can only switch to infected in a Versus game");
					ChooseTeamMenuDraw(iClient);
				}
			}
			case 2: //Switch to Spectator
			{
				if(g_iClientTeam[iClient] == TEAM_SPECTATORS)
				{
					g_bClientSpectating[iClient] = true;
					PrintToChat(iClient, "\x03[XPMod] \x05You are already a \x04spectator\x05.");
					ChooseTeamMenuDraw(iClient);
					return;
				}

				ChangeClientTeam(iClient, TEAM_SPECTATORS);
				g_iClientTeam[iClient] = TEAM_SPECTATORS;
				g_bClientSpectating[iClient] = true;
				PrintToChatAll("\x03%N \x05moved to the \x04specators", iClient);
				//ChooseTeamMenuDraw(iClient);
			}
			case 8: //Back
			{
				ExtrasMenuDraw(iClient);
			}
		}
	}
}

OptionMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
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