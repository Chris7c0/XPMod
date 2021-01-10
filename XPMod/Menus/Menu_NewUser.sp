
public Action:CreateNewUserMenuDraw(iClient)
{
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Handled;
	
	if(g_bTalentsConfirmed[iClient] == false)
	{
        CheckMenu(iClient);
        g_hMenu_XPM[iClient] = CreateMenu(CreateNewUserMenuHandler);
        
        decl String:text[300];
        FormatEx(text, sizeof(text), " \n\
            ==================================================\n \n                         \
            Welcome to XPMod!\n \n\
            XPMod adds RPG elements to Left4Dead2, enabling\n\
            you to gain powerful abilities and equipment\n\
            through earning XP.\n \n\
            Start playing XPMod?");
        SetMenuTitle(g_hMenu_XPM[iClient], text);
        
        AddMenuItem(g_hMenu_XPM[iClient], "option1", " Yes, Lets Go!");
        AddMenuItem(g_hMenu_XPM[iClient], "option2", " Not Now.\n \n\
            ==================================================\
            \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
        
        SetMenuExitButton(g_hMenu_XPM[iClient], false);
        DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	}
	
	return Plugin_Handled;
}

public CreateNewUserMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
		}
	}
}