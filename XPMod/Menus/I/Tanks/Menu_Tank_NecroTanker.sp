Action:TankMenuDrawNecroTanker(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerNecroTanker);

        char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu,"\
	%s \
        NECROTANKER\
        \n\"Life is finite, whereas Death...ah, yes. Death is infinite.\"\
        \n \
        \n Passive Abilities\
        \n - %i Start HP, %i Max HP | Good At Close Range\
        \n - Consume Infected For Health\
        \n	+%i HP Per CI Kill\
        \n	+%i HP Per UI Kill\
        \n - 20%% Faster\
        \n - Immune to Bile\
        \n - Punching Survivors Summons Infected\
        \n	+60%% CI/UI Mob\
        \n	+5%% SI\
        \n	+5%% Witch\
        \n \
        \n Active Abilities\
        \n - Mana Pool (Punches Regen Mana)\
        \n - [Hold WALK or CROUCH] Summon CI\
        \n - [Press MELEE] Throw Boomers\
        \n ",
	strStartingNewLines,
        TANK_HEALTH_NECROTANKER,
        NECROTANKER_MAX_HEALTH,
        NECROTANKER_CONSUME_COMMON_HP,
        NECROTANKER_CONSUME_UNCOMMON_HP);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
                "Back\
                %s\n \n \n \n \n \n \n \n \n \n \n \n ",
                strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);
        
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