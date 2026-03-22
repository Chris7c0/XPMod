//Class Select Menu Draw
Action TopSurvivorMenuDraw(int iClient)
{
	Menu menu = CreateMenu(TopSurvivorMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:		SetMenuTitle(menu, "%sLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Bill (Support)\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ROCHELLE:	SetMenuTitle(menu, "%sLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Rochelle (Ninja)\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case COACH:		SetMenuTitle(menu, "%sLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Coach (Berserker)\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ELLIS:		SetMenuTitle(menu, "%sLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Ellis (Weapon Expert)\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case NICK:		SetMenuTitle(menu, "%sLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Nick (Gambler)\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case LOUIS:		SetMenuTitle(menu, "%sLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Louis (Disruptor)\n  ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ZOEY:		SetMenuTitle(menu, "%sLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Zoey (R.C. Medic)\n  ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	}
		
	AddMenuItem(menu, "option1", "Bill			  (Support)");
	AddMenuItem(menu, "option2", "Rochelle	(Ninja)");
	AddMenuItem(menu, "option3", "Coach		(Berserker)");
	AddMenuItem(menu, "option4", "Ellis			(Weapons Expert)");
	AddMenuItem(menu, "option5", "Nick			(Gambler)");
	AddMenuItem(menu, "option6", "Louis		  (Disruptor)");
	AddMenuItem(menu, "option7", "Zoey		   (Medic)");
	AddMenuItem(menu, "option8", "Francis	   (Grenadier)\n ");

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText), "Back\
		\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\
		%s\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Character Menu Draw
Action ChangeSurvivorMenuDraw(int iClient)
{
	// Check that they are not already confirmed
	if (g_bTalentsConfirmed[iClient])
		return Plugin_Handled;
	
	Menu menu = CreateMenu(ChangeSurvivorMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:		SetMenuTitle(menu, "%s=	=	=	=	=	=	=	=	=	=	=\nYour Survivor: Bill (Support)\n \n Change your Survivor to...", strStartingNewLines);
		case ROCHELLE:	SetMenuTitle(menu, "%s=	=	=	=	=	=	=	=	=	=	=\nYour Survivor: Rochelle (Ninja)\n \n Change your Survivor to...", strStartingNewLines);
		case COACH:		SetMenuTitle(menu, "%s=	=	=	=	=	=	=	=	=	=	=\nYour Survivor: Coach (Berserker)\n \n Change your Survivor to...", strStartingNewLines);
		case ELLIS:		SetMenuTitle(menu, "%s=	=	=	=	=	=	=	=	=	=	=\nYour Survivor: Ellis (Weapon Expert)\n \n Change your Survivor to...", strStartingNewLines);
		case NICK:		SetMenuTitle(menu, "%s=	=	=	=	=	=	=	=	=	=	=\nYour Survivor: Nick (Gambler)\n \n Change your Survivor to...", strStartingNewLines);
		case LOUIS:		SetMenuTitle(menu, "%s=	=	=	=	=	=	=	=	=	=	=\nYour Survivor: Louis (Disruptor)\n \n Change your Survivor to...", strStartingNewLines);
		case ZOEY:		SetMenuTitle(menu, "%s=	=	=	=	=	=	=	=	=	=	=\nYour Survivor: Zoey (R.C. Medic)\n \n Change your Survivor to...", strStartingNewLines);
	}
	AddMenuItem(menu, "option1", "Bill		   (Support)			   [EASY]");
	AddMenuItem(menu, "option2", "Rochelle (Ninja)					  [PRO]");
	AddMenuItem(menu, "option3", "Coach	 (Berserker)	  [NORMAL]");
	AddMenuItem(menu, "option4", "Ellis        (Weapons Expert)   [PRO] ");
	AddMenuItem(menu, "option5", "Nick		 (Gambler)				[PRO]");
	AddMenuItem(menu, "option6", "Louis	  (Disruptor)			   [1337]");
	AddMenuItem(menu, "option7", "Zoey		(R.C. Medic)			 [PRO]");
	AddMenuItem(menu, "option8", "Francis	(Grenadier)  				[?]\n ");

	AddMenuItem(menu, "option9", "Change Equipment");

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText), "Exit\
		\n=	=	=	=	=	=	=	=	=	=	=\
		%s\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option10", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


//Top level Survivor Menu Handler
void TopSurvivorMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case BILL: 		SupportMenuDraw(iClient);
			case ROCHELLE:	RochelleMenuDraw(iClient);
			case COACH:		CoachMenuDraw(iClient);
			case ELLIS:		EllisMenuDraw(iClient);
			case NICK:		NickMenuDraw(iClient);
			case LOUIS:		LouisMenuDraw(iClient);
			case ZOEY:		ZoeyMenuDraw(iClient);
			case FRANCIS:
			{
				PrintToChat(iClient, "\x03[XPMod] \x05Not Available Yet.");
				TopSurvivorMenuDraw(iClient);
			}
			case 8: // Back 
			{
				TopChooseCharactersMenuDraw(iClient);
			}
		}
	}
}

//Change Character Handler
void ChangeSurvivorMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case FRANCIS: //Change to Francis
			{
				PrintToChat(iClient, "\x03[XPMod] \x05Not Available Yet.");
				ChangeSurvivorMenuDraw(iClient);
				return;
			}
			case 8: //Change Equipment
			{
				LoadoutMenuDraw(iClient);
				return;
			}
		}

		// ItemNum 0-7 are survivor choices that align with the survivor enums
		// So, we can just set the chosen survivor to the itemNum they clicked on
		if (itemNum >= 0 && itemNum <= 7)
		{
			ResetSurvivorTalents(iClient);
			// Set the chosen survivor to the one they just clicked on
			g_iChosenSurvivor[iClient] = itemNum;
			AutoLevelUpSurivovor(iClient);
			SaveUserData(iClient);
			DrawConfirmationMenuToClient(iClient);
		}
	}
}
