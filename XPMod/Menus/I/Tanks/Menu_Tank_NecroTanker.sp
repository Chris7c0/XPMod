Action TankMenuDrawNecroTanker(int iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerNecroTanker);
	
	SetMenuTitle(menu,"NECROTANKER\
        \n\"Life is finite, whereas Death...ah, yes. Death is infinite.\"\
        \n \
        \nPassives\
        \n- %i Start HP, %i Max HP\
        \n- +%i HP Per CI Kill\
        \n- +%i HP Per UI Kill\
        \n- 15%% Faster\
        \n- Immune to Bile\
        \n- Hit Survivors To Summon Infected\
        \n \
        \nActives\
        \n- Mana Pool (Hits Regen Mana)\
        \n- [Hold USE] Summon CEDA\
        \n- [Hold RELOAD] Summon Enhanced UI\
        \n- [WALK] Teleport\
        \n- Throw Boomers!\
		\n ",
        TANK_HEALTH_NECROTANKER,
        NECROTANKER_MAX_HEALTH,
        NECROTANKER_CONSUME_COMMON_HP,
        NECROTANKER_CONSUME_UNCOMMON_HP);
	
	if (g_bTankInfoMenuFromSelection[iClient])
		AddMenuItem(menu, "option1", "Close");
	else
		AddMenuItem(menu, "option1", "Back");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, g_bTankInfoMenuFromSelection[iClient] ? 20 : MENU_TIME_FOREVER);

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
		if (g_bTankInfoMenuFromSelection[iClient])
		{
			g_bTankInfoMenuFromSelection[iClient] = false;
		}
		else
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
}
