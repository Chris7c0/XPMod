Action TankMenuDrawNecroTanker(int iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerNecroTanker);
	
	SetMenuTitle(menu,"NECROTANKER\
        \n\"Life is finite, whereas Death...ah, yes. Death is infinite.\"\
        \n \
        \n Passives\
        \n - %i Start HP, %i Max HP\
        \n - +%i HP Per CI Kill\
        \n - +%i HP Per UI Kill\
        \n - 15%% Faster\
        \n - Immune to Bile\
        \n - Hit Survivors To Summon Infected\
        \n	+60%% CI/UI Mob\
        \n	+5%% SI\
        \n	+5%% Witch\
        \n \
        \n Actives\
        \n - Mana Pool (Hits Regen Mana)\
        \n - [Hold WALK/CROUCH] Summon CI\
        \n - Throw Boomers!",
        TANK_HEALTH_NECROTANKER,
        NECROTANKER_MAX_HEALTH,
        NECROTANKER_CONSUME_COMMON_HP,
        NECROTANKER_CONSUME_UNCOMMON_HP);
	
	AddMenuItem(menu, "option1", "Back");
        
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

void TankMenuHandlerNecroTanker(Menu menu, MenuAction action, int iClient, int itemNum)
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
