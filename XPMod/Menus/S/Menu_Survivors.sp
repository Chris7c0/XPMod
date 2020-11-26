
//Class Select Menu Draw
public Action:ClassMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ClassMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\nSkill Points: %d\n===============================\nCurrent Character: Bill (Support)\n===============================                 ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
		case 1:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\nSkill Points: %d\n================================\nCurrent Character: Rochelle (Ninja)\n================================                 ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
		case 2:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\nSkill Points: %d\n===================================\nCurrent Character: Coach (Berserker)\n===================================                 ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
		case 3:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\nSkill Points: %d\n=====================================\nCurrent Character: Ellis (Weapon Expert)\n=====================================                 ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
		case 4:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP:  %d/%d\nSkill Points: %d\n===============================\nCurrent Character: Nick (Medic)\n===============================                 ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
	}
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Bill's Talents          (Support)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Rochelle's Talents  (Ninja)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Coach's Talents     (Berserker)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Ellis's Talents        (Weapons Expert)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Nick's Talents        (Medic)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Change Your Character");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Back\n \n \n \n ");
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
		case 0:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d	Skill Points: %d\n===============================\nCurrent Character: Bill (Support)\n===============================",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
		case 1:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d	Skill Points: %d\n================================\nCurrent Character: Rochelle (Ninja)\n================================",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
		case 2:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d	Skill Points: %d\n===================================\nCurrent Character: Coach (Berserker)\n===================================",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
		case 3:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d	Skill Points: %d\n=====================================\nCurrent Character: Ellis (Weapon Expert)\n=====================================",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
		case 4:
			SetMenuTitle(g_hMenu_XPM[iClient], "Level %d	XP: %d/%d	Skill Points: %d\n===============================\nCurrent Character: Nick (Medic)\n===============================",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
	}
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Change Character to Bill         (Support)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Change Character to Rochelle (Ninja)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Change Character to Coach    (Berserker)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Change Character to Ellis       (Weapon Expert)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Change Character to Nick       (Medic)");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Back\n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
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
				ChangeChar(iClient, 0);
			}
			case 1: //Change to Rochelle
			{
				ChangeChar(iClient, 1);
			}
			case 2: //Change to Coach
			{
				ChangeChar(iClient, 2);
			}
			case 3: //Change to Ellis
			{
				ChangeChar(iClient, 3);
			}
			case 4: //Change to Nick
			{
				ChangeChar(iClient, 4);
			}
			case 5: //Back
			{
				ClassMenuDraw(iClient);
			}
		}
	}
}


//Class Menu Handler
public ClassMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
				{
					ChangeCharacterMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character if your talents are confirmed.");
					ClassMenuDraw(iClient);
				}
			}
			case 6: //Back
			{
				ChooseTalentTopMenuDraw(iClient);
			}
		}
	}
}

//Change Char to Bill Draw
public Action:ChangeCharSupportMenu(iClient) 
{
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChangeCharSupportMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "Change class to Bill?");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Yes");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "No");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Change Char to Rochelle Draw
public Action:ChangeCharRochelleMenu(iClient) 
{
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChangeCharRochelleMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "Change class to Rochelle?");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Yes");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "No");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Change Char to Nick Draw
public Action:ChangeCharCoachMenu(iClient) 
{
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChangeCharCoachMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "Change class to Coach?");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Yes");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "No");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Change Char to Ellis Draw
public Action:ChangeCharEllisMenu(iClient) 
{
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChangeCharEllisMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "Change class to Ellis?");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Yes");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "No");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Change Char to Nick Draw
public Action:ChangeCharNickMenu(iClient) 
{
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChangeCharNickMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "Change class to Nick?");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Yes");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "No");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Change Char to Bill Handler
public ChangeCharSupportMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				g_iChosenSurvivor[iClient] = 0;
				ResetSkillPoints(iClient, iClient);
				SupportMenuDraw(iClient);
			}
			case 1: //No
			{
				SupportMenuDraw(iClient);
			}
		}
	}
}

//Change Char to Rochelle Handler
public ChangeCharRochelleMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				g_iChosenSurvivor[iClient] = 1;
				ResetSkillPoints(iClient, iClient);
				RochelleMenuDraw(iClient);
			}
			case 1: //No
			{
				RochelleMenuDraw(iClient);
			}
		}
	}
}

//Change Char to Coach Handler
public ChangeCharCoachMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				g_iChosenSurvivor[iClient] = 2;
				ResetSkillPoints(iClient, iClient);
				CoachMenuDraw(iClient);
			}
			case 1: //No
			{
				CoachMenuDraw(iClient);
			}
		}
	}
}

//Change Char to Ellis Handler
public ChangeCharEllisMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				g_iChosenSurvivor[iClient] = 3;
				ResetSkillPoints(iClient, iClient);
				EllisMenuDraw(iClient);
			}
			case 1: //No
			{
				EllisMenuDraw(iClient);
			}
		}
	}
}

//Change Char to Nick Handler
public ChangeCharNickMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				g_iChosenSurvivor[iClient] = 4;
				ResetSkillPoints(iClient, iClient);
				NickMenuDraw(iClient);
			}
			case 1: //No
			{
				NickMenuDraw(iClient);
			}
		}
	}
}