
//Class Select Menu Draw
Action:TopSurvivorMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(TopSurvivorMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\n====================================\nYour Survivor: Bill (Support)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case 1:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\n=====================================\nYour Survivor: Rochelle (Ninja)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case 2:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\n=====================================\nYour Survivor: Coach (Berserker)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case 3:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\n=====================================\nYour Survivor: Ellis (Weapon Expert)\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case 4:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\n=====================================\nYour Survivor: Nick (Medic)\n  ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	}
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Bill			  (Support)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Rochelle	(Ninja)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Coach		(Berserker)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Ellis			(Weapons Expert)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Nick			(Medic)\n ");
	if (g_bTalentsConfirmed[iClient] == false)
		AddMenuItem(g_hMenu_XPM[iClient], "option6", " * Change Your Survivor *\n ");
	else
		AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Back\n=====================================\n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Character Menu Draw
Action:ChangeSurvivorMenuDraw(iClient)
{
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChangeSurvivorMenuHandler);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d\n=================================\nYour Survivor: Bill (Support)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ROCHELLE:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d\n=================================\nYour Survivor: Rochelle (Ninja)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case COACH:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d\n=================================\nYour Survivor: Coach (Berserker)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ELLIS:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d\n=================================\nYour Survivor: Ellis (Weapon Expert)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case NICK:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d\n=================================\nYour Survivor: Nick (Medic)\n \n Change your Survivor to...",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	}
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Bill		   (Support)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Rochelle (Ninja)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Coach	 (Berserker)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Ellis		 (Weapons Expert)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Nick		 (Medic)\n ");

	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Change Your Equipment");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Do Nothing\n=================================\n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


//Top level Survivor Menu Handler
TopSurvivorMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Select Bill
			{
				SupportMenuDraw(iClient);
			}
			case 1: //Select Rochelle
			{
				RochelleMenuDraw(iClient);
			}
			case 2: //Select Cooach
			{
				CoachMenuDraw(iClient);
			}
			case 3: //Select Ellis
			{
				EllisMenuDraw(iClient);
			}
			case 4: //Select Nick
			{
				NickMenuDraw(iClient);
			}
			case 5: //Choose Your Character
			{
				if(g_bTalentsConfirmed[iClient] == false)
					ChangeSurvivorMenuDraw(iClient);
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
					TopSurvivorMenuDraw(iClient);
				}
			}
			case 6: //Back
			{
				TopChooseCharactersMenuDraw(iClient);
			}
		}
	}
}

//Change Character Handler
ChangeSurvivorMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Change to Bill
			{
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = BILL;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);
				TopSurvivorMenuDraw(iClient);
			}
			case 1: //Change to Rochelle
			{
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = ROCHELLE;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);
				TopSurvivorMenuDraw(iClient);
			}
			case 2: //Change to Coach
			{
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = COACH;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);
				TopSurvivorMenuDraw(iClient);
			}
			case 3: //Change to Ellis
			{
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = ELLIS;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);
				TopSurvivorMenuDraw(iClient);
			}
			case 4: //Change to Nick
			{
				ResetSurvivorTalents(iClient);
				g_iChosenSurvivor[iClient] = NICK;
				AutoLevelUpSurivovor(iClient);
				SaveUserData(iClient);
				TopSurvivorMenuDraw(iClient);
			}
			case 5: //Change Equipment
			{
				LoadoutMenuDraw(iClient);
			}
			case 6: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}