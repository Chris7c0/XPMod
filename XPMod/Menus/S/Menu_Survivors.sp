//Class Select Menu Draw
Action:TopSurvivorMenuDraw(iClient)
{
	Menu menu = CreateMenu(TopSurvivorMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:		SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Bill (Support)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ROCHELLE:	SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Rochelle (Ninja)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case COACH:		SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Coach (Berserker)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ELLIS:		SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Ellis (Weapon Expert)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case NICK:		SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Nick (Gambler)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case LOUIS:		SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\nYour Survivor: Louis (Disruptor)\n  ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	}
	
	AddMenuItem(menu, "option1", "Bill			  (Support)");
	AddMenuItem(menu, "option2", "Rochelle	(Ninja)");
	AddMenuItem(menu, "option3", "Coach		(Berserker)");
	AddMenuItem(menu, "option4", "Ellis			(Weapons Expert)");
	AddMenuItem(menu, "option5", "Nick			(Gambler)");
	AddMenuItem(menu, "option6", "Louis		 (Disruptor)\n ");
	if (g_bTalentsConfirmed[iClient] == false)
		AddMenuItem(menu, "option7", " * Change Your Survivor *\n ");
	else
		AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back\
		\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Character Menu Draw
Action:ChangeSurvivorMenuDraw(iClient)
{
	Menu menu = CreateMenu(ChangeSurvivorMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:		SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Bill (Support)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ROCHELLE:	SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Rochelle (Ninja)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case COACH:		SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Coach (Berserker)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ELLIS:		SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Ellis (Weapon Expert)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case NICK:		SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Nick (Gambler)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case LOUIS:		SetMenuTitle(menu, "\n \nLevel %d	XP: %d/%d\n=================================\nYour Survivor: Louis (Disruptor)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	}
	AddMenuItem(menu, "option1", "Bill		   (Support)			   [EASY]");
	AddMenuItem(menu, "option2", "Rochelle (Ninja)					  [PRO]");
	AddMenuItem(menu, "option3", "Coach	 (Berserker)	 [NORMAL]");
	AddMenuItem(menu, "option4", "Ellis		 (Weapons Expert) [EASY]");
	AddMenuItem(menu, "option5", "Nick		 (Gambler)				[PRO]");
	AddMenuItem(menu, "option6", "Louis	  (Disruptor)			   [1337] <-- PREVIEW            \n ");

	AddMenuItem(menu, "option7", "Change Your Equipment");
	AddMenuItem(menu, "option8", "Confirm Your Survivor\
		\n=================================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

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