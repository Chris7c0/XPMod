Action:TankMenuDrawVampiric(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerVampiric);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu,"\
		%s \
        VAMPIRIC TANK\
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
		strStartingNewLines,
        TANK_HEALTH_VAMPIRIC);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

TankMenuHandlerVampiric(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
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