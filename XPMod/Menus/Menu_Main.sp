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
	for(new iClient = 0; iClient < (MAXPLAYERS + 1); iClient++)
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

public Action:CloseClientPanel(iClient,args)
{
	if(iClient < 1)
		iClient=1;
	if(IsClientInGame(iClient))
		if(IsFakeClient(iClient) == false)
			ClosePanel(iClient);
	
	return Plugin_Handled;
}

public Action:ClosePanel(iClient)
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

public Action:TopMenuDraw(iClient,args)
{
	if(iClient == 0)
		iClient=1;
	
	if(IsClientInGame(iClient))
	{		
		if(g_bClientLoggedIn[iClient] == false)
			CreateNewUser(iClient);
		
		g_bClientIDDToggle[iClient] = false;
		
		if(g_bClientLoggedIn[iClient] == true)
			TopSurvivorMenuDraw(iClient);
	}
	return Plugin_Handled;
}
//Menu Draw Functions                                                                                     
//Top XPMod Menu Draw
public Action:TopSurvivorMenuDraw(iClient) 
{
	g_bUserStoppedConfirmation[iClient] = true;
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	CheckLevel(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(TopSurvivorMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
		switch(g_iChosenSurvivor[iClient])
		{
			case 0: SetMenuTitle(g_hMenu_XPM[iClient], "    XP Mod %s\n====================\nLevel  %d  Support\nXP:   %d/%d\n====================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case 1: SetMenuTitle(g_hMenu_XPM[iClient], "    XP Mod %s\n====================\nLevel  %d  Ninja\nXP:   %d/%d\n====================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case 2: SetMenuTitle(g_hMenu_XPM[iClient], "    XP Mod %s\n====================\nLevel  %d  Berserker\nXP:   %d/%d\n====================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case 3: SetMenuTitle(g_hMenu_XPM[iClient], "      XP Mod %s\n=======================\nLevel %d Weapon Expert\nXP:   %d/%d\n=======================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
			case 4: SetMenuTitle(g_hMenu_XPM[iClient], "    XP Mod %s\n====================\nLevel  %d  Medic\nXP:   %d/%d\n====================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		}
	else if(g_iClientTeam[iClient] == TEAM_INFECTED)
		SetMenuTitle(g_hMenu_XPM[iClient], "     XP Mod %s\n====================\nLevel  %d  Infected\nXP:   %d/%d\n====================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	else
		SetMenuTitle(g_hMenu_XPM[iClient], "    XP Mod %s\n====================\nLevel %d\nXP:     %d/%d\n====================", PLUGIN_VERSION, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Choose Talents");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Choose Equipment");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Extras");
	
	if(g_bTalentsConfirmed[iClient] == true)
	{
		AddMenuItem(g_hMenu_XPM[iClient], "option4", "Help & How-To");
		AddMenuItem(g_hMenu_XPM[iClient], "option5", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option9", "", ITEMDRAW_NOTEXT);
		
		if((g_iClientTeam[iClient] == TEAM_SURVIVORS) && (g_iChosenSurvivor[iClient] == 3))
			AddMenuItem(g_hMenu_XPM[iClient], "option10", "Exit the Menu\n=======================\n \n ");
		else
			AddMenuItem(g_hMenu_XPM[iClient], "option10", "Exit the Menu\n====================\n \n ");
	}
	else
	{
		AddMenuItem(g_hMenu_XPM[iClient], "option4", "Help\n \n   You will NOT get\n talents or equipment\n   until you confirm!");
		AddMenuItem(g_hMenu_XPM[iClient], "option5", "* Confirm Talents *\n ");
		AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option9", "", ITEMDRAW_NOTEXT);
		
		if((g_iClientTeam[iClient] == TEAM_SURVIVORS) && (g_iChosenSurvivor[iClient] == 3))
			AddMenuItem(g_hMenu_XPM[iClient], "option10", "Exit the Menu\n=======================\n \n \n \n \n \n \n \n \n ");
		else
			AddMenuItem(g_hMenu_XPM[iClient], "option10", "Exit the Menu\n====================\n \n \n \n \n \n \n \n \n ");
	}
	

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}


//Select Talents
public Action:ChooseTalentTopMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChooseTalentsTopMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "Choose Which Talents\n=====================\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Survivor Talents");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Infected Talents");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \nNote: You can change\nany talents at any\ntime as long as you\nhave not confirmed.\n=====================\n");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


//Select Talents
public Action:ExtrasMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ExtrasMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "XPMod Extras");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Choose Team");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Player Stats");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Options");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Get XPMod Addon");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "XPMod Website");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Back");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Team Menu Draw
public Action:ChooseTeamMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChooseTeamMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "Choose A Team");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Survivors");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Infected");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Spectators");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Back");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

public Action:OptionMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(OptionMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	SetMenuTitle(g_hMenu_XPM[iClient], "		 XP Mod Options\n ");
	
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
	
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Back\n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Menu Handler Functions                                                                                   
//Top Menu Handler

public ChooseTalentsTopMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Choose Survivors
			{
				ClassMenuDraw(iClient);
			}
			case 1: //Choose Infected
			{
				if (g_iTalentSelectionMode == CONVAR_WEBSITE)
				{
					OpenInfectedCharacterSelectionSite(iClient);
				}
				else if (g_iTalentSelectionMode == CONVAR_MENU)
				{
					TopInfectedMenuDraw(iClient);
				}
			}
			case 2: //Back
			{
				TopMenuDraw(iClient, iClient);
			}
		}
	}
}

//Top Menu For Everything
public TopSurvivorMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Choose Talents
			{
				ChooseTalentTopMenuDraw(iClient);
			}
			case 1: //Choose Loadout
			{
				LoadoutMenuDraw(iClient);
			}
			case 2: //Choose Teams
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
				g_bUserStoppedConfirmation[iClient] = false;
				g_iAutoSetCountDown[iClient] = 10;

				delete g_hTimer_ShowingConfirmTalents[iClient];
				g_hTimer_ShowingConfirmTalents[iClient] = CreateTimer(1.0, TimerShowTalentsConfirmed, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
}

public ExtrasMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
			case 5: //Back
			{
				TopMenuDraw(iClient, iClient);
			}
		}
	}
}

//Choose Team Menu Handler
public ChooseTeamMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
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
					/*if ((!IsClientConnected(iClient)) || (!IsClientInGame(iClient)))
					{
						PrintToChat(iClient, "[SM] The player is not avilable anymore.");
						return;
					}*/
					
					// first we switch to spectators ..
					ChangeClientTeam(iClient, TEAM_SPECTATORS); 
					
					// Search for an empty bot
					new bot = 1;
					
					do
					{
						bot++;
					}
					while (((bot <= MaxClients) && IsValidEntity(bot) && IsClientInGame(bot) && IsFakeClient(bot) && (GetClientTeam(bot) == TEAM_SURVIVORS)) == false)

					if(bot < 1 || iClient < 1 || IsValidEntity(bot) == false)
						return;

					if(IsClientInGame(bot)== false)
					{
						PrintToChat(iClient, "[SM] Bot is not avilable anymore.");
						return;
					}
					// force player to spec humans
					SDKCall(g_hSDK_SetHumanSpec, bot, iClient); 
					
					// force player to take over bot
					SDKCall(g_hSDK_TakeOverBot, iClient, true);
					g_iClientTeam[iClient] = 2;
					PrintToChatAll("\x03%N \x05moved to the \x04survivors", iClient);
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
						g_iClientTeam[iClient] = 3;
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
				g_iClientTeam[iClient] = 1;
				g_bClientSpectating[iClient] = true;
				PrintToChatAll("\x03%N \x05moved to the \x04specators", iClient);
				//ChooseTeamMenuDraw(iClient);
			}
			case 3: //Back
			{
				ExtrasMenuDraw(iClient);
			}
		}
	}
}

public OptionMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
				ToggleAnnouncerVoice(iClient, iClient);
				OptionMenuDraw(iClient);
			}
			case 2: //Toggle VGUI Particle Descriptions
			{
				ToggleVGUIDesc(iClient,iClient);
				OptionMenuDraw(iClient);
			}
			case 3: //Back
			{
				ExtrasMenuDraw(iClient);
			}
		}
	}
}