Action:ChooseTankMenuDraw(iClient)
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
		\n ",
		RoundToNearest(TANK_HEALTH_FIRE * g_fTankStartingHealthMultiplier[iClient]) );
	AddMenuItem(g_hMenu_XPM[iClient], "option1", strText);
	FormatEx(strText, sizeof(strText), "Ice Tank\
		\n %i HP, Freeze Survivors\
		\n [Hold CROUCH] Regenerates Health\
		\n ",
		RoundToNearest(TANK_HEALTH_ICE * g_fTankStartingHealthMultiplier[iClient]) );
	AddMenuItem(g_hMenu_XPM[iClient], "option2", strText);
	FormatEx(strText, sizeof(strText), "NecroTanker\
		\n %i HP: Kill Infected for Health\
		\n Throw Boomers!\
		\n [Hold WALK or CROUCH] Summon CI\
		\n ",
		RoundToNearest(TANK_HEALTH_NECROTANKER * g_fTankStartingHealthMultiplier[iClient]) );
	AddMenuItem(g_hMenu_XPM[iClient], "option3", strText);
	FormatEx(strText, sizeof(strText), "Vampiric Tank\
		\n %i HP: Life Steal from Survivors\
		\n [Press JUMP] Fly\
		\n [Press MELEE] Wing Dash\
		\n \
		\n=	=	=	=	=	=	=	=	=	=	=\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		RoundToNearest(TANK_HEALTH_VAMPIRIC * g_fTankStartingHealthMultiplier[iClient]) );
	AddMenuItem(g_hMenu_XPM[iClient], "option4", strText);

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Tank Abilities Menu Draw
Action:TankTopMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(TankTopMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "Level %d	XP: %d/%d\
									\n==========================\
									\nTanks:\
									\n==========================\n \
									\nSelect a Tank to learn about\
									\ntheir abilities.\n \n", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Fire Tank");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Ice Tank");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "NecroTanker");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Vampiric Tank\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\
		\n==========================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


ChooseTankMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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

TankTopMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action == MenuAction_Select)
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