Action ChooseTankMenuDraw(int iClient)
{
	// If they still had the confirmation menu open, close it so they can choose a tank
	g_bUserStoppedConfirmation[iClient] = true;
	
	Menu menu = CreateMenu(ChooseTankMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	SetMenuTitle(menu, "\
		%s			Choose Your Tank\
		\n=	=	=	=	=	=	=	=	=	=	=\n ",
		strStartingNewLines);
	
	char strText[512];
	FormatEx(strText, sizeof(strText), "Fire Tank\
		\n %i HP, High Damage\
		\n [Hold CROUCH] Fire Punch\
		\n ",
		RoundToNearest(TANK_HEALTH_FIRE * g_fTankStartingHealthMultiplier[iClient]) );
	AddMenuItem(menu, "option1", strText);
	FormatEx(strText, sizeof(strText), "Ice Tank\
		\n %i HP, Freeze Survivors\
		\n [Hold CROUCH] Regenerates Health\
		\n ",
		RoundToNearest(TANK_HEALTH_ICE * g_fTankStartingHealthMultiplier[iClient]) );
	AddMenuItem(menu, "option2", strText);
	FormatEx(strText, sizeof(strText), "NecroTanker\
		\n %i HP: Kill Infected for Health\
		\n Throw Boomers!\
		\n [Hold WALK or CROUCH] Summon CI\
		\n ",
		RoundToNearest(TANK_HEALTH_NECROTANKER * g_fTankStartingHealthMultiplier[iClient]) );
	AddMenuItem(menu, "option3", strText);
	FormatEx(strText, sizeof(strText), "Vampiric Tank\
		\n %i HP: Life Steal from Survivors\
		\n [Press JUMP] Fly\
		\n [Press MELEE] Wing Dash\
		\n \
		\n=	=	=	=	=	=	=	=	=	=	=\
		%s\n \n \n \n \n \n \n \n \n \n \n \n ",
		RoundToNearest(TANK_HEALTH_VAMPIRIC * g_fTankStartingHealthMultiplier[iClient]),
		strEndingNewLines);
	AddMenuItem(menu, "option4", strText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Tank Abilities Menu Draw
Action TankTopMenuDraw(int iClient)
{
	
	CheckLevel(iClient);
	DeleteAllMenuParticles(iClient);

	Menu menu = CreateMenu(TankTopMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	char title[256];
	FormatEx(title, sizeof(title), "\
		%sLevel %d	XP: %d/%d\
		\n==========================\
		\nTanks:\
		\n==========================\n \
		\nSelect a Tank to learn about\
		\ntheir abilities.\n \n",
		strStartingNewLines,
		g_iClientLevel[iClient],
		g_iClientXP[iClient],
		g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, title);
	
	AddMenuItem(menu, "option1", "Fire Tank");
	AddMenuItem(menu, "option2", "Ice Tank");
	AddMenuItem(menu, "option3", "NecroTanker");
	AddMenuItem(menu, "option4", "Vampiric Tank\n ");
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		\n==========================\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


void ChooseTankMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
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

void TankTopMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: TankMenuDrawFire(iClient);
			case 1:	TankMenuDrawIce(iClient);
			case 2:	TankMenuDrawNecroTanker(iClient);
			case 3:	TankMenuDrawVampiric(iClient);
			case 8:	TopInfectedMenuDraw(iClient);
		}
	}
}
