Action:TankMenuDrawVampiric(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(TankMenuHandlerVampiric);
	
	SetMenuTitle(g_hMenu_XPM[iClient],
        "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \
        \nVAMPIRIC TANK\
        \n\"I never drink...wine.\"\
        \n \
        \n Passive Abilities\
        \n - %i HP | Good At Close Range, Safe At Long Range\
        \n - Life Steal On Punch\
        \n    - Life Steal More From Incapacitated Victims\
        \n - 10%% Faster\
        \n - Dodges Bullets (1/3rd Gun Damage Taken)\
        \n - Weak To Melee (3X Melee Damage Taken)\
        \n \
        \n Active Abilities\
        \n - [Press JUMP] Fly\
        \n - [Press MELEE] Wing Dash\
        \n    - 3 Uses (13 Sec Cooldown) \
        \n - No Rock Throwing\
        \n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",
        TANK_HEALTH_VAMPIRIC);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

TankMenuHandlerVampiric(Handle:hmenu, MenuAction:action, iClient, itemNum)
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