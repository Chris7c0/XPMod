Action TankMenuDrawVampiric(int iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerVampiric);

	SetMenuTitle(menu,"VAMPIRIC TANK\
        \n\"I never drink...wine.\"\
        \n \
        \nPassives\
        \n- %i HP | Good At Close Range, Safe At Long Range\
        \n- Life Steal On Punch\
        \n	- Life Steal More From Incapacitated Victims\
        \n- 30%% Faster\
        \n- Dodges Bullets (1/3rd Gun Dmg Taken)\
        \n- Weak To Melee (3X Melee Dmg Taken)\
        \n \
        \nActives\
        \n- [Press JUMP] Fly\
        \n- [Press MELEE] Wing Dash\
        \n	- 3 Uses (13 Sec CD) \
        \n- No Rock Throwing\
        \n ",
        TANK_HEALTH_VAMPIRIC);
	
	if (g_bTankInfoMenuFromSelection[iClient])
		AddMenuItem(menu, "option1", "Close");
	else
		AddMenuItem(menu, "option1", "Back");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, g_bTankInfoMenuFromSelection[iClient] ? 20 : MENU_TIME_FOREVER);

	return Plugin_Handled;
}

void TankMenuHandlerVampiric(Menu menu, MenuAction action, int iClient, int itemNum)
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
