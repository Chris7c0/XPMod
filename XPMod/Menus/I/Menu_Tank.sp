public Action:ChooseTankMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChooseTankMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "			Choose Tank Talents\n=	=	=	=	=	=	=	=	=	=	=\n ");
	
	decl String:strText[512];
	FormatEx(strText, sizeof(strText), "Fire Tank\n - 20%% - %d%% Faster (Pain = Speed)\n - %d Health\n - Fire Immunity\n - %d%% Chance To Ignite Victim\n - Fire Punch [Hold CROUCH]\n ", 20 + g_iClientLevel[iClient], (6000 + g_iClientLevel[iClient] * 100), g_iClientLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", strText);
	FormatEx(strText, sizeof(strText), "Ice Tank\n - %d Health\n - Direct Fire Damage Hurts More\n - Fire Goes Out Quickly\n - %d%% Chance To Freeze Victim\n - Kiting Immunity\n - No Rock Cooldown\n - Rocks Freeze Victims\n - %d Health Regen. [Hold CROUCH]\n \n	*Movement Disrupts Charging*\n=	=	=	=	=	=	=	=	=	=	=", RoundToCeil(g_iClientLevel[iClient] / 5.0), (6000 + g_iClientLevel[iClient] * 400), 15 + g_iClientLevel[iClient], g_iClientLevel[iClient] * 200);
	AddMenuItem(g_hMenu_XPM[iClient], "option2", strText);
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

public ChooseTankMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0:
			{
				LoadFireTankTalents(iClient);
			}
			case 1:
			{
				LoadIceTankTalents(iClient);
			}
		}
	}
}