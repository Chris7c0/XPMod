Action:TankMenuDrawNecroTanker(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerNecroTanker);
	
	SetMenuTitle(menu,"\
	\n \
        \nNECROTANKER\
        \n\"Life is finite, whereas Death...ah, yes. Death is infinite.\"\
        \n \
        \n Passive Abilities\
        \n - %i Start HP, %i Max HP | Good At Close Range\
        \n - Consume Infected For Health\
        \n	+%i HP Per CI Kill\
        \n	+%i HP Per UI Kill\
        \n - 10%% Faster\
        \n - Immune to Bile\
        \n - Punching Survivors Summons Infected\
        \n	+60%% CI/UI Mob\
        \n	+5%% SI\
        \n	+5%% Witch\
        \n	+1%% Tank\
        \n \
        \n Active Abilities\
        \n - Mana Pool (Punches Regen Mana)\
        \n - [Hold WALK or CROUCH] Summon CI\
        \n - [Press MELEE] Throw Boomers\
        \n ",
        TANK_HEALTH_NECROTANKER,
        NECROTANKER_MAX_HEALTH,
        NECROTANKER_CONSUME_COMMON_HP,
        NECROTANKER_CONSUME_UNCOMMON_HP);
	
	AddMenuItem(menu, "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

TankMenuHandlerNecroTanker(Menu menu, MenuAction:action, iClient, itemNum)
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