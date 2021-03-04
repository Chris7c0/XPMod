
Action:CreateNewUserMenuDraw(iClient)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Handled;
	
	if(g_bTalentsConfirmed[iClient] == false)
	{
		CheckMenu(iClient);
		g_hMenu_XPM[iClient] = CreateMenu(CreateNewUserMenuHandler);
		SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
		
		decl String:text[500];
		FormatEx(text, sizeof(text), 
			"\n \n \
			\n							Welcome to XPMod!\n \
			\n\
			XPMod adds RPG elements to Left4Dead2, enabling you\n\
			to gain powerful abilities and equipment by earning XP.\n \
			\n\
			This is not a typical mod. It is complex with a lot of\n\
			depth that can take time to master. Those that choose\n\
			to play XPMod will encounter unique challenges and\n\
			be rewarded with intense gameplay.\n \
			\n\
			Start playing XPMod?");
		SetMenuTitle(g_hMenu_XPM[iClient], text);
		
		AddMenuItem(g_hMenu_XPM[iClient], "option1", " Yes, Lets Go!");
		AddMenuItem(g_hMenu_XPM[iClient], "option2", " Not Now.");
		AddMenuItem(g_hMenu_XPM[iClient], "option3", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option4", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option5", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
		AddMenuItem(g_hMenu_XPM[iClient], "option9", " No, Ban Me.\n \n\
			\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
		
		SetMenuExitButton(g_hMenu_XPM[iClient], false);
		DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	}
	
	return Plugin_Handled;
}

CreateNewUserMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: // Yes, Create New User
			{
				if (iClient == 0)
					iClient = 1;
				
				if (RunClientChecks(iClient) && g_bClientLoggedIn[iClient] == false)
					CreateNewUser(iClient);
			}
			case 2: // Not now
			{
				ClosePanel(iClient);
			}
			case 8: // No, Ban Me
			{
				BanMeMenuDraw(iClient);
			}
		}
	}
}

Action:BanMeMenuDraw(iClient)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Handled;
	
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(BanMeMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:text[500];
	FormatEx(text, sizeof(text), "\n \n\
		=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n\
		How long would you like to be banned from this server?   \n ");
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", " Nevermind!");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", " Kick Only");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", " 1 Day Ban");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", " 1 Week Ban");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", " 1 Month Ban\n \n\
		=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

BanMeMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: // Nevermind! (Dont ban or kick)
			{
				ClosePanel(iClient);
			}
			case 1: // Kick User Only
			{
				ClosePanel(iClient);
				KickClient(iClient, "Have a nice day");
			}
			case 2: // Ban for 1 Day
			{
				BanConfirmMenu(iClient, 1440);
			}
			case 3: // Ban for 1 Week
			{
				BanConfirmMenu(iClient, 10080);
			}
			case 4: // Ban for 1 Month
			{
				BanConfirmMenu(iClient, 43200);
			}
		}
	}
}

Action:BanConfirmMenu(int iClient, int iBanDurationInMinutes)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Handled;
	
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(BanConfirmMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);

	// Store the value for use in the handler
	g_iBanDurationInMinutes[iClient] = iBanDurationInMinutes;
	
	decl String:text[500];
	FormatEx(text, sizeof(text), "\n \n\
		=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n\
		You will be banned from all XPMod servers for %i days.    \n \n\
		Are you sure?\n ", (g_iBanDurationInMinutes[iClient] / 60 / 24) );
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", " Yes");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", " No\n \n\
		=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}


BanConfirmMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: // Yes
			{
				ClosePanel(iClient);
				// Add user to the bans table in the xpmod database
				SQLAddBannedUserToDatabase(iClient, g_iBanDurationInMinutes[iClient] * 60, "XPMod Banned");
				// Ban the user, regardless of being able to add to the database or not
				BanClient(iClient, g_iBanDurationInMinutes[iClient], BANFLAG_AUTHID, "XPMod Banned", "Banned from XPMod. Have a nice day");
			}
			case 1: // No
			{
				ClosePanel(iClient);
			}

			// case 2: // Ban for 1 Day
			// {
			// 	ClosePanel(iClient);
			// 	// Add user to the bans table in the xpmod database
			// 	SQLAddBannedUserToDatabase(iClient, 86400, "XPMod Banned for 1 Day");
			// 	// Ban the user, regardless of being able to add to the database or not
			// 	BanClient(iClient, 1440, BANFLAG_AUTHID, "XPMod Banned for 1 Day", "You are banned for 1 day. Thanks, have a nice day");
			// }
			// case 3: // Ban for 1 Week
			// {
			// 	ClosePanel(iClient);
			// 	// Add user to the bans table in the xpmod database
			// 	SQLAddBannedUserToDatabase(iClient, 604800, "XPMod Banned for 1 Week");
			// 	// Ban the user, regardless of being able to add to the database or not
			// 	BanClient(iClient, 10080, BANFLAG_AUTHID, "XPMod Banned for 1 Week", "You are banned for 1 week. Thanks, have a nice day");
			// }
			// case 4: // Ban for 1 Month
			// {
			// 	ClosePanel(iClient);
			// 	// Add user to the bans table in the xpmod database
			// 	SQLAddBannedUserToDatabase(iClient, 2592000, "XPMod Banned for 1 Month");
			// 	// Ban the user, regardless of being able to add to the database or not
			// 	BanClient(iClient, 43200, BANFLAG_AUTHID, "XPMod Banned for 1 Month", "You are banned for 1 month. Thanks, have a nice day");
			// }
		}
	}
}