
//Class Select Menu Draw
public Action:ClassMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ClassMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\n===============================\nCurrent Character: Bill (Support)\n===============================                 ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case 1:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\n================================\nCurrent Character: Rochelle (Ninja)\n================================                 ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case 2:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\n===================================\nCurrent Character: Coach (Berserker)\n===================================                 ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case 3:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\n=====================================\nCurrent Character: Ellis (Weapon Expert)\n=====================================                 ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case 4:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\n===============================\nCurrent Character: Nick (Medic)\n===============================                 ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	}
	AddMenuItem(g_hMenu_XPM[iClient], "option1", " * Choose Your Survivor *\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Bill's Talents          (Support)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Rochelle's Talents  (Ninja)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Coach's Talents     (Berserker)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Ellis's Talents        (Weapons Expert)");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Nick's Talents        (Medic)");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Back\n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Character Menu Draw
public Action:ChangeCharacterMenuDraw(iClient)
{
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChangeCharacterMenuHandler);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d\n===============================\nCurrent Character: Bill (Support)\n===============================",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ROCHELLE:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d\n================================\nCurrent Character: Rochelle (Ninja)\n================================",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case COACH:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d\n===================================\nCurrent Character: Coach (Berserker)\n===================================",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case ELLIS:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d\n=====================================\nCurrent Character: Ellis (Weapon Expert)\n=====================================",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
		case NICK:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d\n===============================\nCurrent Character: Nick (Medic)\n===============================",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	}
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Switch to Bill         (Support)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Switch to Rochelle (Ninja)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Switch to Coach    (Berserker)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Switch to Ellis       (Weapon Expert)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Switch to Nick       (Medic)");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Back\n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


//Class Menu Handler
public ClassMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Choose Your Character
			{
				if(g_bTalentsConfirmed[iClient] == false)
				{
					ChangeCharacterMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character if your talents are confirmed.");
					ClassMenuDraw(iClient);
				}
			}
			case 1: //Select Bill
			{
				SupportMenuDraw(iClient);
			}
			case 2: //Select Rochelle
			{
				RochelleMenuDraw(iClient);
			}
			case 3: //Select Cooach
			{
				CoachMenuDraw(iClient);
			}
			case 4: //Select Ellis
			{
				EllisMenuDraw(iClient);
			}
			case 5: //Select Nick
			{
				NickMenuDraw(iClient);
			}
			case 6: //Back
			{
				ChooseTalentTopMenuDraw(iClient);
			}
		}
	}
}

//Change Character Handler
public ChangeCharacterMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Change to Bill
			{
				ResetSkillPoints(iClient, iClient);
				g_iChosenSurvivor[iClient] = BILL;
				AutoLevelUpSurivovor(iClient)
				ClassMenuDraw(iClient);
			}
			case 1: //Change to Rochelle
			{
				ResetSkillPoints(iClient, iClient);
				g_iChosenSurvivor[iClient] = ROCHELLE;
				AutoLevelUpSurivovor(iClient)
				ClassMenuDraw(iClient);
			}
			case 2: //Change to Coach
			{
				ResetSkillPoints(iClient, iClient);
				g_iChosenSurvivor[iClient] = COACH;
				AutoLevelUpSurivovor(iClient)
				ClassMenuDraw(iClient);
			}
			case 3: //Change to Ellis
			{
				ResetSkillPoints(iClient, iClient);
				g_iChosenSurvivor[iClient] = ELLIS;
				AutoLevelUpSurivovor(iClient)
				ClassMenuDraw(iClient);
			}
			case 4: //Change to Nick
			{
				ResetSkillPoints(iClient, iClient);
				g_iChosenSurvivor[iClient] = NICK;
				AutoLevelUpSurivovor(iClient)
				ClassMenuDraw(iClient);
			}
			case 5: //Back
			{
				ClassMenuDraw(iClient);
			}
		}
	}
}