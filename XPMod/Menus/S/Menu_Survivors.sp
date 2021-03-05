//Class Select Menu Draw
Action:TopSurvivorMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(TopSurvivorMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Bill (Support)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ROCHELLE:	SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Rochelle (Ninja)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case COACH:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Coach (Berserker)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ELLIS:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Ellis (Weapon Expert)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case NICK:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Nick (Gambler)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case LOUIS:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Louis (Disruptor)\n  ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	}
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Bill			  (Support)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Rochelle	(Ninja)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Coach		(Berserker)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Ellis			(Weapons Expert)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Nick			(Gambler)");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Louis		 (Disruptor)\n ");
	if (g_bTalentsConfirmed[iClient] == false)
		AddMenuItem(g_hMenu_XPM[iClient], "option7", " * Change Your Survivor *\n ");
	else
		AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\
		\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Character Menu Draw
Action:ChangeSurvivorMenuDraw(iClient)
{
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChangeSurvivorMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Bill (Support)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ROCHELLE:	SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Rochelle (Ninja)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case COACH:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Coach (Berserker)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ELLIS:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Ellis (Weapon Expert)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case NICK:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Nick (Gambler)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case LOUIS:		SetMenuTitle(g_hMenu_XPM[iClient], "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Louis (Disruptor)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	}
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Bill		   (Support)			   [EASY]");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Rochelle (Ninja)					  [PRO]");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Coach	 (Berserker)	 [NORMAL]");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Ellis		 (Weapons Expert) [EASY]");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Nick		 (Gambler)				[PRO]");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Louis	  (Disruptor)			   [1337] <-- PREVIEW            \n ");

	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Change Your Equipment");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Confirm Your Survivor\
		\n=================================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


//Top level Survivor Menu Handler
TopSurvivorMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case BILL: 		SupportMenuDraw(iClient);
			case ROCHELLE:	RochelleMenuDraw(iClient);
			case COACH:		CoachMenuDraw(iClient);
			case ELLIS:		EllisMenuDraw(iClient);
			case NICK:		NickMenuDraw(iClient);
			case LOUIS:		LouisMenuDraw(iClient);
			case 6: //Choose Your Character
			{
				if(g_bTalentsConfirmed[iClient] == false)
					ChangeSurvivorMenuDraw(iClient);
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
					TopSurvivorMenuDraw(iClient);
				}
			}
			case 8: //Back
			{
				TopChooseCharactersMenuDraw(iClient);
			}
		}
	}
}

//Change Character Handler
ChangeSurvivorMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action == MenuAction_Select)
	{
		switch (itemNum)
		{
			case BILL: //Change to Bill
			{
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = BILL;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);
				
				DrawConfirmationMenuToClient(iClient);
			}
			case ROCHELLE: //Change to Rochelle
			{
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = ROCHELLE;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);

				DrawConfirmationMenuToClient(iClient);
			}
			case COACH: //Change to Coach
			{
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = COACH;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);
				
				DrawConfirmationMenuToClient(iClient);
			}
			case ELLIS: //Change to Ellis
			{
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = ELLIS;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);

				DrawConfirmationMenuToClient(iClient);
			}
			case NICK: //Change to Nick
			{
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = NICK;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);

				DrawConfirmationMenuToClient(iClient);
			}
			case LOUIS: //Change to Louis
			{
				// PrintToChat(iClient, "\x03[XPMod] \x05Louis abilities are coming soon!");
				// ChangeSurvivorMenuDraw(iClient);
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = LOUIS;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);

				DrawConfirmationMenuToClient(iClient);
			}
			case 6: //Change Equipment
			{
				LoadoutMenuDraw(iClient);
			}
			case 7: //Confirm
			{
				DrawConfirmationMenuToClient(iClient);
			}
		}
	}
}