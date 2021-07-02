Action:AdminMenuDraw(iClient)
{
	// if (iClient != -99)
	// {
	// 	PrintToChat(iClient, "Admin menu is not ready yet. Use sm_admin for now.")
	// 	return Plugin_Handled
	// }

	// Reset all selected options so nothing is falsly selected
	ResetAllAdminMenuSelectionVariables(iClient);

	Menu menu = CreateMenu(AdminMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	SetMenuTitle(menu, "XPMod Admin Menu\n ");
	AddMenuItem(menu, "option1", "Auto-Balance Teams   [NOT READY]");
	AddMenuItem(menu, "option2", "Switch Player's Team");
	AddMenuItem(menu, "option3", "Force Client Popup     [NOT READY]"); //Like Help, Addon Download, Confirm Talents, etc.
	AddMenuItem(menu, "option4", "Mute Player");
	AddMenuItem(menu, "option5", "Kick Player");
	AddMenuItem(menu, "option6", "Ban Player");
	AddMenuItem(menu, "option7", "Griefing Undo Tools");
	AddMenuItem(menu, "option8", g_bGamePaused ? "Unpause Game\n ": "Pause Game\n ");
	AddMenuItem(menu, "option9", "Back to Main Menu");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

AdminMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Auto-Balance Teams
			{
				PrintToChat(iClient, "This feature is not ready yet.");
				AdminMenuDraw(iClient);
			}
			case 1: //Switch Player Team
			{
				SwitchPlayersTeamMenuDraw(iClient);
			}
			case 2: //Force Client Popup
			{
				PrintToChat(iClient, "This feature is not ready yet.");
				AdminMenuDraw(iClient);
			}
			case 3: //Mute Player
			{
				MutePlayerMenuDraw(iClient);
			}
			case 4: //Kick Player
			{
				KickPlayerMenuDraw(iClient);
			}
			case 5: //Ban Player
			{
				BanPlayerMenuDraw(iClient);
			}
			case 6: //Griefing Undo Tools
			{
				AdminGriefingUndoToolsMenuDraw(iClient)
			}
			case 7: //Pause Unpause Game
			{
				if (GetClientAdminLevel(iClient) > 0)
					ToggleGamePaused(iClient);
				
				AdminMenuDraw(iClient);
			}
			case 8: //Back to Main Menu
			{
				TopMenuDraw(iClient);
			}
		}
	}
}

void ResetAllAdminMenuSelectionVariables(int iClient)
{
	g_iAdminSelectedClientID[iClient] = -1;
	g_iAdminSelectedSteamID[iClient] = -1;
	g_iAdminSelectedDuration[iClient] = -1;
}

Action:SwitchPlayersTeamMenuDraw(iClient)
{
	Menu menu = CreateMenu(SwitchPlayersTeamMenuHandler);

	ResetAllAdminMenuSelectionVariables(iClient);
	
	SetMenuTitle(menu, "Select a team for Whom?\n ");
	
	AddAllPlayersToMenu(menu, iClient);

	SetMenuExitButton(menu, true);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


SwitchPlayersTeamMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		int iTarget; char strSteamID[32];
		if (GetTargetIDandSteamIDFromMenuParameters(iClient, menu, itemNum, iTarget, strSteamID, sizeof(strSteamID)) == false)
		{
			PrintToChat(iClient, "Error obtaining client info for team switch.");
			LogError("BanPlayerMenuHandler: Error obtaining client info for team switch", iTarget);
			return;
		}

		g_iAdminSelectedClientID[iClient] = iTarget;
		SwitchPlayersTeamSelectTeamMenuDraw(iClient);
	}
}

Action:SwitchPlayersTeamSelectTeamMenuDraw(iClient)
{
	Menu menu = CreateMenu(SwitchPlayersTeamMenuSelectTeamHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	if (RunClientChecks(g_iAdminSelectedClientID[iClient]) == false || 
		IsFakeClient(g_iAdminSelectedClientID[iClient]) == true)
	{
		SwitchPlayersTeamMenuDraw(iClient);
		return Plugin_Handled;
	}
	
	SetMenuTitle(menu, "Switching %N's team.\
		\nWhat Team?\n ", 
		g_iAdminSelectedClientID[iClient]);
	
	AddMenuItem(menu, "option1", "Survivors");
	AddMenuItem(menu, "option2", "Infected");
	AddMenuItem(menu, "option3", "Spectators\n ");
	AddMenuItem(menu, "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}


SwitchPlayersTeamMenuSelectTeamHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if (itemNum == 8)
		{
			AdminMenuDraw(iClient);
			return;
		}

		if (RunClientChecks(g_iAdminSelectedClientID[iClient]) == false || 
			IsFakeClient(g_iAdminSelectedClientID[iClient]) == true)
		{
			SwitchPlayersTeamMenuDraw(iClient);
			return;
		}

		new iTarget = g_iAdminSelectedClientID[iClient];
		new iTeam = TEAM_SPECTATORS;

		switch (itemNum)
		{
			case 0: iTeam = TEAM_SURVIVORS;
			case 1: iTeam = TEAM_INFECTED;
			case 2: iTeam = TEAM_SPECTATORS;
		}

		if (SwitchPlayerTeam(iClient, iTarget, iTeam) == false)
			SwitchPlayersTeamMenuDraw(iClient);
	}
}

Action:MutePlayerMenuDraw(iClient)
{
	Menu menu = CreateMenu(MutePlayerMenuHandler);
	
	SetMenuTitle(menu, "Mute or Unmute Whom?\n ");
	
	AddAllPlayersToMenu(menu, iClient);

	SetMenuExitButton(menu, true);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


MutePlayerMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		int iTarget; char strSteamID[32];
		if (GetTargetIDandSteamIDFromMenuParameters(iClient, menu, itemNum, iTarget, strSteamID, sizeof(strSteamID)) == false)
		{
			PrintToChat(iClient, "Error obtaining client info for ban.");
			LogError("BanPlayerMenuHandler: Error obtaining client info for ban", iTarget);
			return;
		}

		// Toggle mute on the player
		MutePlayer(iTarget, !g_bIsPlayerMuted[iTarget], false);

		MutePlayerMenuDraw(iClient);
	}
}


Action:KickPlayerMenuDraw(iClient)
{
	Menu menu = CreateMenu(KickPlayerMenuHandler);
	
	SetMenuTitle(menu, "Kick Whom?\n ");
	
	AddAllPlayersToMenu(menu, iClient);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


KickPlayerMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		int iTarget; char strSteamID[32];
		if (GetTargetIDandSteamIDFromMenuParameters(iClient, menu, itemNum, iTarget, strSteamID, sizeof(strSteamID)) == false)
		{
			PrintToChat(iClient, "Error obtaining client info for ban.");
			LogError("BanPlayerMenuHandler: Error obtaining client info for ban", iTarget);
			return;
		}
		
		PrintToChat(iClient, "\x03[XPMod] \x04Banning %N...", iTarget);
		KickClient(iTarget, "Peace");
	}
}

Action:BanPlayerMenuDraw(iClient)
{
	Menu menu = CreateMenu(BanPlayerMenuHandler);
	
	SetMenuTitle(menu, "Permanently Ban Whom?\n ");
	
	AddAllPlayersToMenu(menu, iClient);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


BanPlayerMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		int iTarget; char strSteamID[32];
		if (GetTargetIDandSteamIDFromMenuParameters(iClient, menu, itemNum, iTarget, strSteamID, sizeof(strSteamID)) == false)
		{
			PrintToChat(iClient, "Error obtaining client info for ban.");
			LogError("BanPlayerMenuHandler: Error obtaining client info for ban", iTarget);
			return;
		}

		PrintToChat(iClient, "\x03[XPMod] \x04Banning %N...", iTarget);
		
		// Add user to the bans table in the xpmod database
		SQLAddBannedUserToDatabase(iTarget, 0, "Banned by Admin");
		// Ban the user, regardless of being able to add to the database or not
		BanClient(iTarget, 999999, BANFLAG_AUTHID, "Banned by Admin", "Banned from XPMod");
	}
}

void AddAllPlayersToMenu(Menu menu, int iClient)
{
	for(new iTarget = 1; iTarget <= MaxClients; iTarget++)
	{
		if(RunClientChecks(iTarget) && IsFakeClient(iTarget) == false)
		{
			//Get Steam Auth ID, if this returns false, then do not proceed
			decl String:strSteamID[32];
			if (GetClientAuthId(iTarget, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
			{
				PrintToChat(iClient, "AddAllPlayersToMenu: GetClientAuthId failed for %N", iTarget);
				LogError("AddAllPlayersToMenu: GetClientAuthId failed for %N", iTarget);
				continue;
			}

			// Get the in game client id
			decl String:strParameters[32];
			Format(strParameters, sizeof(strParameters),"%i;%s", iTarget, strSteamID)
			
			// Combine the info into a string that the admin will see
			decl String:strTargetInfo[50];
			Format(strTargetInfo, sizeof(strTargetInfo), " (%s) %N",
			strParameters,
			iTarget);

			AddMenuItem(menu, strParameters, strTargetInfo);
		}
	}
}

bool GetTargetIDandSteamIDFromMenuParameters(int iClient, Menu menu, int itemNum, int &iTarget, char[] strSteamID, int iSteamIDSize)
{
	// Get the client parameters
	char strInfo[128], strParameters[2][32];
	GetMenuItem(menu, itemNum, strInfo, sizeof(strInfo));
	ExplodeString(strInfo, ";", strParameters, sizeof(strParameters), sizeof(strParameters[]));

	// PrintToChat(iClient, "param1: %s", strParameters[0]);
	// PrintToChat(iClient, "param2: %s", strParameters[1]);

	iTarget = StringToInt(strParameters[0]);

	if (RunClientChecks(iTarget) == false || IsFakeClient(iTarget))
	{
		PrintToChat(iClient, "Client %i is invalid.", iTarget);
		LogError("GetTargetIDandSteamIDFromMenuParameters: iTarget %i is invalid", iTarget);
		return false;
	}

	// Verify the steamid here (pass in and verify), because of time delay client id is not enough
	if (VerifyClientSteamIDMatches(iTarget, strParameters[1]) == false)
	{
		PrintToChat(iClient, "Client %i does not match the selected steamID, please try again.", iTarget);
		LogError("GetTargetIDandSteamIDFromMenuParameters: Client %i does not match the selected steamID", iTarget);
		return false;
	}

	// Store the steamid parameter
	Format(strSteamID, iSteamIDSize, "%s", strParameters[1]);

	return true;
}

bool VerifyClientSteamIDMatches(int iClient, char[] strSteamIDToCheck)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient))
		return false;

	//Get Steam Auth ID, if this returns false, then do not proceed
	decl String:strSteamID[32];
	if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
	{
		PrintToChat(iClient, "GetClientAuthId failed for %N", iClient);
		LogError("VerifyClientSteamIDMatches: GetClientAuthId failed for %N", iClient);
		return false;
	}

	if (strcmp(strSteamIDToCheck, strSteamID, false) == 0)
		return true;

	return false;
}

// Undo Griefing Tools
Action:AdminGriefingUndoToolsMenuDraw(iClient)
{
	Menu menu = CreateMenu(AdminGriefingUndoToolsMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	SetMenuTitle(menu, "Griefing Undo Tools\n ");
	AddMenuItem(menu, "option1", "Revive and Full Heal Survivor");
	AddMenuItem(menu, "option2", "Revive and Full Heal All Survivors");
	AddMenuItem(menu, "option3", "Resurrect Survivor\n ");
	AddMenuItem(menu, "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back to Admin Menu");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

AdminGriefingUndoToolsMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Revive and Full Heal Survivor
			{
				AdminReviveAndFullHealSurvivorMenuDraw(iClient);
			}
			case 1: //Revive and Full Heal All Survivors
			{
				HealAllSurvivorsFully();
				PrintToChat(iClient, "\x03[XPMod] \x04All Survivors have been revived and fully headed.");

				AdminGriefingUndoToolsMenuDraw(iClient);
			}
			case 2: //Resurrect Survivor
			{
				int iTarget = FindAndResurrectSurvivor(iClient);

				if (RunClientChecks(iTarget))
					HealClientFully(iTarget);
				else
					PrintToChat(iClient, "\x03[XPMod] \x04No dead Survivors were found.");

				AdminGriefingUndoToolsMenuDraw(iClient);
			}
			case 8: //Back to Main Menu
			{
				AdminMenuDraw(iClient);
			}
		}
	}
}

// ReviveAndFullHealSurvivor
Action:AdminReviveAndFullHealSurvivorMenuDraw(iClient)
{
	Menu menu = CreateMenu(AdminReviveAndFullHealSurvivorMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	SetMenuTitle(menu, "Revive and Full Heal Survivor\n ");

	for (int i=1; i <= MaxClients; i++)
	{
		if (RunClientChecks(i) &&
			g_iClientTeam[i] == TEAM_SURVIVORS && 
			IsPlayerAlive(i))
		{
			// Get the in game client name
			decl String:strSurvivorInfo[32];
			Format(strSurvivorInfo, sizeof(strSurvivorInfo),"(%i) %N - (%i HP)",
				i,
				i,
				GetPlayerHealth(i));

			decl String:strID[8];
			Format(strID, sizeof(strID), "%i", i);
			AddMenuItem(menu, strID, strSurvivorInfo);
		}
	}
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back to Admin Menu");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

AdminReviveAndFullHealSurvivorMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if (itemNum == 8)
		{
			AdminGriefingUndoToolsMenuDraw(iClient);
			return;
		}

		char strInfo[128];
		GetMenuItem(menu, itemNum, strInfo, sizeof(strInfo));
		new iTarget = StringToInt(strInfo);
		HealClientFully(iTarget);

		AdminReviveAndFullHealSurvivorMenuDraw(iClient);
	}
}