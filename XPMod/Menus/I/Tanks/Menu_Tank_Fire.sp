Action TankMenuDrawFire(int iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerFire);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu,"\
		%s \
        FIRE TANK\
        \n\"MoRE PAiN?! MOrE FUUuN!!\"\
        \n \
        \n Passive Abilities\
        \n - %i HP | Good At All Ranges\
        \n - High Damage Output, Immune To Fire\
        \n - 20-70%% Faster (More Pain = More Speed)\
        \n - 20%% Chance To Ignite Survivors On Punch\
        \n - Loses %i HP Per Second\
        \n \
        \n Active Abilities\
        \n - [Hold CROUCH] Charges Fire Punch\
        \n    - \"PuNCh FAcE...MAkE BoOM!\"\
        \n - Rock Throw Spreads Fire (15 Sec Cooldown)\
        \n - [SPRINT + Move] Fire Dash (%i Sec CD)\
        \n    - Costs %i HP (Free Below %i HP)\
        \n ",
		strStartingNewLines,
        TANK_HEALTH_FIRE,
        FIRE_TANK_HP_DRAIN_PER_SECOND,
        RoundToNearest(FIRE_TANK_DASH_COOLDOWN),
        FIRE_TANK_DASH_HP_COST,
        FIRE_TANK_DASH_HP_COST);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

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
