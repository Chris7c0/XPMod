Action TankMenuDrawIce(int iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerIce);

	SetMenuTitle(menu,"ICE TANK\
        \n\"You merely adopted the cold; I was born in it, moulded by it.\"\
        \n \
        \n Passives\
        \n - %i HP | Good At Close Range\
		\n - Cold Aura: Slow Survivors When Close\
        \n - Weak To Fire, But Fire Goes Out Quickly\
        \n - 33%% Chance To Freeze Survivors On Punch\
        \n \
        \n Actives\
        \n - [Hold CROUCH & Don't Move] Regens HP\
        \n    - Freezes Survivors In Blizzard Storm\
		\n - Hold [WALK] to Ice Slide\
        \n - Rocks Freeze Survivors(No CD)\
        \n ",
        TANK_HEALTH_ICE);
	
	AddMenuItem(menu, "option1", "Back");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

void TankMenuHandlerIce(Menu menu, MenuAction action, int iClient, int itemNum)
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
