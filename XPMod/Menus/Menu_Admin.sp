Action:AdminMenuDraw(iClient)
{
	// if (iClient != -99)
	// {
	// 	PrintToChat(iClient, "Admin menu is not ready yet. Use sm_admin for now.")
	// 	return Plugin_Handled
	// }

	Menu menu = CreateMenu(AdminMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	SetMenuTitle(menu, "XPMod Admin Menu\n ");
	AddMenuItem(menu, "option1", "Auto-Balance Teams	[NOT READY]");
	AddMenuItem(menu, "option2", "Switch Player's Team  [NOT READY]");
	AddMenuItem(menu, "option3", "Force Client Popup		[NOT READY]"); //Like Help, Addon Download, Confirm Talents, etc.
	AddMenuItem(menu, "option4", "Mute Player					[NOT READY]");
	AddMenuItem(menu, "option5", "Kick Player");
	AddMenuItem(menu, "option6", "Ban Player");
	AddMenuItem(menu, "option7", "Undo Griefing				[NOT READY]");
	AddMenuItem(menu, "option8", g_bGamePaused ? "Unpause Game": "Pause Game");
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
				PrintToChat(iClient, "This feature is not ready yet.");
				AdminMenuDraw(iClient);
			}
			case 2: //Force Client Popup
			{
				PrintToChat(iClient, "This feature is not ready yet.");
				AdminMenuDraw(iClient);
			}
			case 3: //Mute Player
			{
				PrintToChat(iClient, "This feature is not ready yet.");
				AdminMenuDraw(iClient);
			}
			case 4: //Kick Player
			{
				KickPlayerMenuDraw(iClient);
			}
			case 5: //Ban Player
			{
				BanPlayerMenuDraw(iClient);
			}
			case 6: //Undo Griefing
			{
				PrintToChat(iClient, "This feature is not ready yet.");
				AdminMenuDraw(iClient);
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
		decl String:strInfo[128];
		GetMenuItem(menu, itemNum, strInfo, sizeof(strInfo));

		// PrintToChatAll("INFO=%s", strInfo);
		KickClient(StringToInt(strInfo), "Peace");
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
		decl String:strInfo[128];
		GetMenuItem(menu, itemNum, strInfo, sizeof(strInfo));

		// Note to chris, verify the steamid here (pass in and verify), because of time delay client id is not enough
		


		// Add user to the bans table in the xpmod database
		SQLAddBannedUserToDatabase(iClient, 0, "Banned by Admin");
		// Ban the user, regardless of being able to add to the database or not
		BanClient(iClient, 999999, BANFLAG_AUTHID, "Banned by Admin", "Banned from XPMod");
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
			decl String:strID[8];
			Format(strID, sizeof(strID),"%i", iTarget)
			
			// Combine the info into a string that the admin will see
			decl String:strTargetInfo[50];
			Format(strTargetInfo, sizeof(strTargetInfo), " (%s) %N",
			strID,
			iTarget);

			AddMenuItem(menu, strID, strTargetInfo);
		}
	}
}