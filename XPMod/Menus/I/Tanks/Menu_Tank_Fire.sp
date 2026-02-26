Action TankMenuDrawFire(int iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerFire);
	
	SetMenuTitle(menu,"FIRE TANK\
        \n\"MoRE PAiN?! MOrE FUUuN!!\"\
        \n \
        \n Passives\
        \n - %i HP | Good At All Ranges\
        \n - High Damage Output, Immune To Fire\
        \n - 20-70%% Faster (Pain = Speed)\
        \n - 20%% Chance To Ignite Victim On Punch\
        \n - Lose %i HP/Sec\
        \n \
        \n Actives\
        \n - [Hold CROUCH] Charge Fire Punch\
        \n    - \"PuNCh FAcE...MAkE BoOM!\"\
        \n - Throw Fire Rocks\
        \n - [WALK + Move] Fire Dash\
        \n    - Lose %i HP\
        \n ",
        TANK_HEALTH_FIRE,
        FIRE_TANK_HP_DRAIN_PER_SECOND,
        FIRE_TANK_DASH_HP_COST,
        FIRE_TANK_DASH_HP_COST);
	
	AddMenuItem(menu, "option1", "Back");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

void TankMenuHandlerFire(Menu menu, MenuAction action, int iClient, int itemNum)
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
