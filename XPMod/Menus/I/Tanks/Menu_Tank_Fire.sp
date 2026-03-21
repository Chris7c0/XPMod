Action TankMenuDrawFire(int iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerFire);
	int iStartSpeedPct = RoundToNearest(TANK_FIRE_BASE_SPEED * 100.0);
	int iMaxSpeedPct = RoundToNearest((TANK_FIRE_BASE_SPEED + TANK_FIRE_EXTRA_SPEED_MAX) * 100.0);
	
	SetMenuTitle(menu,"FIRE TANK\
        \n\"MoRE PAiN?! MOrE FUUuN!!\"\
        \n \
        \nPassives\
        \n- %i HP | Good At All Ranges\
        \n- High Damage Output, Immune To Fire\
        \n- %i-%i%% Faster (Pain = Speed)\
        \n- 20%% Chance To Ignite Victim On Punch\
        \n- Lose %i HP/Sec\
        \n- Fire Punch every %i hits\
        \n	- \"PuNCh FAcE...MAkE BoOM!\"\
        \n \
        \nActives\
        \n- Throw Fire Rocks\
        \n- [WALK + Move] Fire Dash\
        \n	- Lose %i HP\
        \n ",
        TANK_HEALTH_FIRE,
        iStartSpeedPct,
        iMaxSpeedPct,
        FIRE_TANK_HP_DRAIN_PER_SECOND,
        FIRE_TANK_FIRE_PUNCH_EVERY_N_HITS,
        FIRE_TANK_DASH_HP_COST);
	
	if (g_bTankInfoMenuFromSelection[iClient])
		AddMenuItem(menu, "option1", "Close");
	else
		AddMenuItem(menu, "option1", "Back");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, g_bTankInfoMenuFromSelection[iClient] ? 20 : MENU_TIME_FOREVER);

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
