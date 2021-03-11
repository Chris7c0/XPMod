Action:TankMenuDrawVampiric(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerVampiric);
	
	SetMenuTitle(menu,"\
	\n \
        \nVAMPIRIC TANK\
        \n\"I never drink...wine.\"\
        \n \
        \n Passive Abilities\
        \n - %i HP | Good At Close Range, Safe At Long Range\
        \n - Life Steal On Punch\
        \n    - Life Steal More From Incapacitated Victims\
        \n - 20%% Faster\
        \n - Dodges Bullets (1/3rd Gun Damage Taken)\
        \n - Weak To Melee (3X Melee Damage Taken)\
        \n \
        \n Active Abilities\
        \n - [Press JUMP] Fly\
        \n - [Press MELEE] Wing Dash\
        \n    - 3 Uses (13 Sec Cooldown) \
        \n - No Rock Throwing\
        \n ",
        TANK_HEALTH_VAMPIRIC);
	
	AddMenuItem(menu, "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

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