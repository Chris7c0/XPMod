Action:TankMenuDrawIce(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerIce);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu,"\
		%s \
        ICE TANK\
        \n\"You merely adopted the cold; I was born in it, moulded by it.\"\
        \n \
        \n Passive Abilities\
        \n - %i HP | Good At Close Range\
        \n - Freeze Survivors\
		\n - Cold Aura: Slow Survivors When Near Them\
        \n - Weak To Fire, But Fire Goes Out Quickly\
        \n - 33%% Chance To Freeze Survivors On Punch\
        \n \
        \n Active Abilities\
        \n - [Hold CROUCH & Do Not Move] Regenerates Health\
        \n    - Freezes Survivors Inside The Blizzard Storm\
        \n - Rock Throw Freezes Survivors (No Cooldown)\
        \n ",
		strStartingNewLines,
        TANK_HEALTH_ICE);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

TankMenuHandlerIce(Menu menu, MenuAction:action, iClient, itemNum)
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