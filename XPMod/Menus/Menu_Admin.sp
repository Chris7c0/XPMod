Action:AdminMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(AdminMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	SetMenuTitle(g_hMenu_XPM[iClient], "XPMod Admin Menu\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Switch Player's Team");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Kick Player");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Ban Player");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Undo Griefing");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option7", g_bGamePaused ? "Unpause Game": "Pause Game");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back to Main Menu");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

AdminMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Switch Player Team
			{
				AdminMenuDraw(iClient);
			}
			case 1: //Kick Player
			{
				KickPlayerMenuDraw(iClient);
			}
			case 2: //Ban Player
			{
				BanPlayerMenuDraw(iClient);
			}
			case 3: //Undo Griefing
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
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(KickPlayerMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Select a player to Kick\n ");
	
	AddAllPlayersToMenu(iClient);

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

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
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(BanPlayerMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Select a player to Ban\n ");
	
	AddAllPlayersToMenu(iClient);

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

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




AddAllPlayersToMenu(iClient)
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

			AddMenuItem(g_hMenu_XPM[iClient], strSteamID, strTargetInfo);
		}
	}
}