public Action:ChooseTankMenuDraw(iClient)
{
	// If they still had the confirmation menu open, close it so they can choose a tank
	g_bUserStoppedConfirmation[iClient] = true;
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChooseTankMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "			Choose Your Tank\n=	=	=	=	=	=	=	=	=	=	=\n ");
	
	decl String:strText[512];
	FormatEx(strText, sizeof(strText), "Fire Tank\
		\n %i HP, High Damage\
		\n [Hold CROUCH] Fire Punch\
		\n ",TANK_HEALTH_FIRE);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", strText);
	FormatEx(strText, sizeof(strText), "Ice Tank\
		\n %i HP, Freeze Survivors\
		\n [Hold CROUCH] Regenerates Health\
		\n ",TANK_HEALTH_ICE);
	AddMenuItem(g_hMenu_XPM[iClient], "option2", strText);
	FormatEx(strText, sizeof(strText), "NecroTanker\
		\n %i HP: Kill Infected for Health\
		\n Throw Boomers!\
		\n [Hold CROUCH] Summon Infected\
		\n ",TANK_HEALTH_NECROTANKER);
	AddMenuItem(g_hMenu_XPM[iClient], "option3", strText);
	FormatEx(strText, sizeof(strText), "Vampiric Tank\
		\n %i HP: Life Steal from Survivors\
		\n [Press JUMP] Fly\
		\n [Press MELEE] Wing Dash\
		\n \
		\n=	=	=	=	=	=	=	=	=	=	=\
		\n \n \n \n \n \n ",TANK_HEALTH_VAMPIRIC);
	AddMenuItem(g_hMenu_XPM[iClient], "option4", strText);

	// FormatEx(strText, sizeof(strText), "Fire Tank\n - 20%% - %d%% Faster (Pain = Speed)\n - %d Health\n - Fire Immunity\n - %d%% Chance To Ignite Victim\n - Fire Punch [Hold CROUCH]\n ", 20 + g_iClientLevel[iClient], (6000 + g_iClientLevel[iClient] * 100), g_iClientLevel[iClient]);
	// AddMenuItem(g_hMenu_XPM[iClient], "option1", strText);
	// FormatEx(strText, sizeof(strText), "Ice Tank\n - 18000 HP\n - Direct Fire Damage Hurts More\n - Fire Goes Out Quickly\n - %d%% Chance To Freeze Victim\n - Kiting Immunity\n - No Rock Cooldown\n - Rocks Freeze Victims\n - %d Health Regen. [Hold CROUCH]\n \n	*Movement Disrupts Charging*\n ", RoundToCeil(g_iClientLevel[iClient] / 5.0), (6000 + g_iClientLevel[iClient] * 400), 15 + g_iClientLevel[iClient], g_iClientLevel[iClient] * 200);
	// AddMenuItem(g_hMenu_XPM[iClient], "option2", strText);
	// FormatEx(strText, sizeof(strText), "NecroTanker\n - 2000 HP\n - Consume (Kill) Zombies for health\n - Holding CROUCH summons Infected\n - MELEE Survivors summons powerful Infected\n - Throw Boomers instead of rocks\n=	=	=	=	=	=	=	=	=	=	=");
	// AddMenuItem(g_hMenu_XPM[iClient], "option3", strText);
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Tank Abilities Menu Draw
public Action:TankTopMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(TankTopMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "Level %d	XP: %d/%d\n==============================\nTanks:\n==============================\n \nSelect a Tank to learn about their abilities.\n \n", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Fire Tank");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Ice Tank");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "NecroTanker");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Vampiric Tank\n ");
	//AddMenuItem(g_hMenu_XPM[iClient], "option5", "Detailed Descriptions\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Back\n==============================\n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


public ChooseTankMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: LoadFireTankTalents(iClient);
			case 1:	LoadIceTankTalents(iClient);
			case 2:	LoadNecroTankerTalents(iClient);
			case 3:	LoadVampiricTankTalents(iClient);
		}
	}
}

public TankTopMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: TankMenuDrawFire(iClient);
			case 1:	TankMenuDrawIce(iClient);
			case 2:	TankMenuDrawNecroTanker(iClient);
			case 3:	TankMenuDrawVampiric(iClient);
			case 4:	TopInfectedMenuDraw(iClient);
		}
	}
}