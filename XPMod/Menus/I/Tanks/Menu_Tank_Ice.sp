public Action:TankMenuDrawIce(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(TankMenuHandlerIce);
	
	SetMenuTitle(g_hMenu_XPM[iClient],
        "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \
        \nICE TANK\
        \n\"You merely adopted the cold; I was born in it, moulded by it.\"\
        \n \
        \n Passive Abilities\
        \n - %i HP | Good At Close Range\
        \n - Freeze Survivors\
        \n - Weak To Fire, But Fire Goes Out Quickly\
        \n - 33%% Chance To Freeze Survivors On Punch\
        \n \
        \n Active Abilities\
        \n - [Hold CROUCH & Do Not Move] Regenerates Health\
        \n    - Freezes Survivors Inside The Blizard Storm\
        \n - Rock Throw Freezes Survivors (+10 Sec Cooldown)\
        \n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",
        TANK_HEALTH_ICE);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

public TankMenuHandlerIce(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				TankTopMenuDraw(iClient);
			}
		}
	}
}