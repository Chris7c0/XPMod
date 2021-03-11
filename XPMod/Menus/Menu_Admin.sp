Action:AdminMenuDraw(iClient)
{
	Menu menu = CreateMenu(AdminMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	SetMenuTitle(menu, "XPMod Admin Menu\n ");
	AddMenuItem(menu, "option1", "Auto-Balance Teams");
	AddMenuItem(menu, "option2", "Switch Player's Team");
	AddMenuItem(menu, "option3", "Force Client Popup"); //Like Help, Addon Download, Confirm Talents, etc.
	AddMenuItem(menu, "option4", "Kick Player");
	AddMenuItem(menu, "option5", "Ban Player");
	AddMenuItem(menu, "option6", "Undo Griefing");
	AddMenuItem(menu, "option7", g_bGamePaused ? "Unpause Game": "Pause Game");
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back to Main Menu");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

AdminMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Auto-Balance Teams
			{
				AdminMenuDraw(iClient);
			}
			case 1: //Switch Player Team
			{
				AdminMenuDraw(iClient);
			}
			case 2: //Force Client Popup
			{
				AdminMenuDraw(iClient);
			}
			case 3: //Kick Player
			{
				KickPlayerMenuDraw(iClient);
			}
			case 4: //Ban Player
			{
				BanPlayerMenuDraw(iClient);
			}
			case 5: //Undo Griefing
			{
				AdminMenuDraw(iClient);
			}
			case 6: //Pause Unpause Game
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
	
	SetMenuTitle(menu, "Select a player to Kick\n ");
	
	AddAllPlayersToMenu(menu, iClient);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


KickPlayerMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		decl String:strInfo[128];
		GetMenuItem(hmenu, itemNum, strInfo, sizeof(strInfo));
		KickClient(StringToInt(strInfo), "Peace!");
	}
}

Action:BanPlayerMenuDraw(iClient)
{
	Menu menu = CreateMenu(BanPlayerMenuHandler);
	
	SetMenuTitle(menu, "Select a player to Ban\n ");
	
	AddAllPlayersToMenu(menu, iClient);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


BanPlayerMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		decl String:strInfo[128];
		GetMenuItem(hmenu, itemNum, strInfo, sizeof(strInfo));
		// // Add user to the bans table in the xpmod database
		// SQLAddBannedUserToDatabase(iClient, 43200 * 60, "Banned by Admin");
		// // Ban the user, regardless of being able to add to the database or not
		// BanClient(iClient, 43200, BANFLAG_AUTHID, "Banned by Admin", "Banned from XPMod");
	}
}




AddAllPlayersToMenu(Menu menu, iClient)
{
	for(new iTarget = 1; iTarget <= MaxClients; iTarget++)
	{
		if(RunClientChecks(iTarget) && IsFakeClient(iTarget) == false)
		{
			//Get Steam Auth ID, if this returns false, then do not proceed
			decl String:strSteamID[32];
			if (GetClientAuthId(iClient, AuthId_SteamID64, strSteamID, sizeof(strSteamID)) == false)
			{
				LogError("AddAllPlayersToMenu: GetClientAuthId failed for %N", iClient);
				continue;
			}

			decl String:strTargetInfo[100];
			Format(strTargetInfo, sizeof(strTargetInfo), "%s: %N (%i)",
			strSteamID,
			iTarget,
			iTarget);

			AddMenuItem(menu, strSteamID, strTargetInfo);
		}
	}
}