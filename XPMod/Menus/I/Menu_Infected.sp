//Infected Talents Menu

//Top Infected Menu Draw
public Action:TopInfectedMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(TopImfectedMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "Level %d	XP: %d/%d\n==========================\n		 Infected Talents\n \n Class 1)	%s\n Class 2)	%s\n Class 3)	%s\n \nNote:   After Your Classes\nHave Been Chosen, Infected\nTalents Level Automatically\n==========================\n ", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", " * Choose Your Infected *\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Smoker Talents");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Boomer Talents");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Hunter Talents");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Spitter Talents");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Jockey Talents");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Charger Talents");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Tank Talents    (Coming)\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back");
	AddMenuItem(g_hMenu_XPM[iClient], "option10", "Exit the Menu\n==========================\n \n  \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Top Infected Menu Draw
public Action:ChooseClassesMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChooseClassesMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "Level %d	XP: %d/%d\n==========================\n	 Change Your Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient],g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Change Class 1");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Change Class 2");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Change Class 3");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Reset All Classes");
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Confirm Reset Draw
public Action:ConfirmResetClassesMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ConfirmResetClassesHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Reset all your classes?");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Yes");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "No!");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Change Infected Class 1
public Action:ChangeClass1MenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChangeClass1MenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	SetMenuTitle(g_hMenu_XPM[iClient], "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nChoose a special infected for Class 1:", g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Smoker");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Boomer");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Hunter");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Spitter");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Jockey");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Charger");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "None");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Back");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}
//Change Infected Class 2
public Action:ChangeClass2MenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChangeClass2MenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	SetMenuTitle(g_hMenu_XPM[iClient], "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nChoose a special infected for Class 1:", g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Smoker");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Boomer");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Hunter");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Spitter");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Jockey");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Charger");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "None");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Back");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}
//Change Infected Class 3
public Action:ChangeClass3MenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChangeClass3MenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	SetMenuTitle(g_hMenu_XPM[iClient], "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nChoose a special infected for Class 1:", g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Smoker");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Boomer");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Hunter");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Spitter");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Jockey");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Charger");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "None");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Back");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Infected Menu Handlers

//Top Infected Menu Handler
public TopImfectedMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Select Infected Classes
			{
				ChooseClassesMenuDraw(iClient);
			}
			case 1: //Smoker
			{
				SmokerTopMenuDraw(iClient);
			}
			case 2: //Boomer
			{
				BoomerTopMenuDraw(iClient);
			}
			case 3: //Hunter
			{
				HunterTopMenuDraw(iClient);
			}
			case 4: //Spitter
			{
				SpitterTopMenuDraw(iClient);
			}
			case 5: //Jockey
			{
				JockeyTopMenuDraw(iClient);
			}
			case 6: //Charger
			{
				ChargerTopMenuDraw(iClient);
			}
			case 7: //Tank
			{
				TopInfectedMenuDraw(iClient);
			}
			case 8: //Back
			{
				ChooseTalentTopMenuDraw(iClient);
			}
			default: //Exit
			{
				if(g_hMenu_XPM[iClient]!=INVALID_HANDLE)
				{
					CloseHandle(g_hMenu_XPM[iClient]);
					g_hMenu_XPM[iClient]=INVALID_HANDLE;
				}
			}
		}
	}
}

//Choose Infected Classes Menu
public ChooseClassesMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Change Class 1
			{
				if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
					ChangeClass1MenuDraw(iClient);
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your infected classes after confirming your talents");
					ChooseClassesMenuDraw(iClient);
				}
			}
			case 1: //Change Class 2
			{
				if(g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
					ChangeClass2MenuDraw(iClient);
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your infected classes after confirming your talents");
					ChooseClassesMenuDraw(iClient);
				}
			}
			case 2: //Change Class 3
			{
				if(g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
					ChangeClass3MenuDraw(iClient);
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your infected classes after confirming your talents");
					ChooseClassesMenuDraw(iClient);
				}
			}
			case 3: //Reset All
			{
				if(g_bTalentsConfirmed[iClient] == false)
					ConfirmResetClassesMenuDraw(iClient);
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your infected classes after confirming your talents");
					ChooseClassesMenuDraw(iClient);
				}
			}
			case 4: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}


//Confirm Reset All Classes Menu
public ConfirmResetClassesHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				ResetAllInfectedClasses(iClient);
				PrintToChat(iClient, "\x03[XPMod] \x05All of your Special Infected Classes have been reset.");
				ChooseClassesMenuDraw(iClient);
			}
			case 1: //No
			{
				ChooseClassesMenuDraw(iClient);
			}
		}
	}
}

//Change Infected Class 1
public ChangeClass1MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Smoker
			{
				if((g_iClientInfectedClass2[iClient] != SMOKER) && (g_iClientInfectedClass3[iClient] != SMOKER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass1[iClient]);
					SetInfectedClassSlot(iClient, 1, SMOKER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04smoker\x05 as one of your classes.");
					ChangeClass1MenuDraw(iClient);
				}
			}
			case 1: //Boomer
			{
				if((g_iClientInfectedClass2[iClient] != BOOMER) && (g_iClientInfectedClass3[iClient] != BOOMER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass1[iClient]);
					SetInfectedClassSlot(iClient, 1, BOOMER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04boomer\x05 as one of your classes.");
					ChangeClass1MenuDraw(iClient);
				}
			}
			case 2: //Hunter
			{
				if((g_iClientInfectedClass2[iClient] != HUNTER) && (g_iClientInfectedClass3[iClient] != HUNTER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass1[iClient]);
					SetInfectedClassSlot(iClient, 1, HUNTER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04hunter\x05 as one of your classes.");
					ChangeClass1MenuDraw(iClient);
				}
			}
			case 3: //Spitter
			{
				if((g_iClientInfectedClass2[iClient] != SPITTER) && (g_iClientInfectedClass3[iClient] != SPITTER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass1[iClient]);
					SetInfectedClassSlot(iClient, 1, SPITTER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04spitter\x05 as one of your classes.");
					ChangeClass1MenuDraw(iClient);
				}
			}
			case 4: //Jockey
			{
				if((g_iClientInfectedClass2[iClient] != JOCKEY) && (g_iClientInfectedClass3[iClient] != JOCKEY))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass1[iClient]);
					SetInfectedClassSlot(iClient, 1, JOCKEY);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04jockey\x05 as one of your classes.");
					ChangeClass1MenuDraw(iClient);
				}
			}
			case 5: //Charger
			{
				if((g_iClientInfectedClass2[iClient] != CHARGER) && (g_iClientInfectedClass3[iClient] != CHARGER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass1[iClient]);
					SetInfectedClassSlot(iClient, 1, CHARGER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04charger\x05 as one of your classes.");
					ChangeClass1MenuDraw(iClient);
				}
			}
			case 6: //None
			{
				LevelDownInfectedTalent(iClient, g_iClientInfectedClass1[iClient]);
				g_iClientInfectedClass1[iClient] = UNKNOWN_INFECTED;
				g_strClientInfectedClass1[iClient] = "None";
				ChooseClassesMenuDraw(iClient);
			}
			case 7: //Back
			{
				ChooseClassesMenuDraw(iClient);
			}
			default: //Exit
			{}
		}

		// Store the new changes in the db
		SaveUserData(iClient);
	}
}
//Change Infected Class 2
public ChangeClass2MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Smoker
			{
				if((g_iClientInfectedClass1[iClient] != SMOKER) && (g_iClientInfectedClass3[iClient] != SMOKER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, SMOKER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04smoker\x05 as one of your classes.");
					ChangeClass2MenuDraw(iClient);
				}
			}
			case 1: //Boomer
			{
				if((g_iClientInfectedClass1[iClient] != BOOMER) && (g_iClientInfectedClass3[iClient] != BOOMER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, BOOMER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04boomer\x05 as one of your classes.");
					ChangeClass2MenuDraw(iClient);
				}
			}
			case 2: //Hunter
			{
				if((g_iClientInfectedClass1[iClient] != HUNTER) && (g_iClientInfectedClass3[iClient] != HUNTER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, HUNTER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04hunter\x05 as one of your classes.");
					ChangeClass2MenuDraw(iClient);
				}
			}
			case 3: //Spitter
			{
				if((g_iClientInfectedClass1[iClient] != SPITTER) && (g_iClientInfectedClass3[iClient] != SPITTER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, SPITTER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04spitter\x05 as one of your classes.");
					ChangeClass2MenuDraw(iClient);
				}
			}
			case 4: //Jockey
			{
				if((g_iClientInfectedClass1[iClient] != JOCKEY) && (g_iClientInfectedClass3[iClient] != JOCKEY))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, JOCKEY);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04jockey\x05 as one of your classes.");
					ChangeClass2MenuDraw(iClient);
				}
			}
			case 5: //Charger
			{
				if((g_iClientInfectedClass1[iClient] != CHARGER) && (g_iClientInfectedClass3[iClient] != CHARGER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, CHARGER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04charger\x05 as one of your classes.");
					ChangeClass2MenuDraw(iClient);
				}
			}
			case 6: //None
			{
				LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
				g_iClientInfectedClass2[iClient] = UNKNOWN_INFECTED;
				g_strClientInfectedClass2[iClient] = "None";
				ChooseClassesMenuDraw(iClient);
			}
			case 7: //Back
			{
				ChooseClassesMenuDraw(iClient);
			}
			default: //Exit
			{}
		}

		// Store the new changes in the db
		SaveUserData(iClient);
	}
}
//Change Infected Class 3
public ChangeClass3MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Smoker
			{
				if((g_iClientInfectedClass1[iClient] != SMOKER) && (g_iClientInfectedClass2[iClient] != SMOKER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, SMOKER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04smoker\x05 as one of your classes.");
					ChangeClass3MenuDraw(iClient);
				}
			}
			case 1: //Boomer
			{
				if((g_iClientInfectedClass1[iClient] != BOOMER) && (g_iClientInfectedClass2[iClient] != BOOMER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, BOOMER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04boomer\x05 as one of your classes.");
					ChangeClass3MenuDraw(iClient);
				}
			}
			case 2: //Hunter
			{
				if((g_iClientInfectedClass1[iClient] != HUNTER) && (g_iClientInfectedClass2[iClient] != HUNTER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, HUNTER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04hunter\x05 as one of your classes.");
					ChangeClass3MenuDraw(iClient);
				}
			}
			case 3: //Spitter
			{
				if((g_iClientInfectedClass1[iClient] != SPITTER) && (g_iClientInfectedClass2[iClient] != SPITTER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, SPITTER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04spitter\x05 as one of your classes.");
					ChangeClass3MenuDraw(iClient);
				}
			}
			case 4: //Jockey
			{
				if((g_iClientInfectedClass1[iClient] != JOCKEY) && (g_iClientInfectedClass2[iClient] != JOCKEY))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, JOCKEY);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04jockey\x05 as one of your classes.");
					ChangeClass3MenuDraw(iClient);
				}
			}
			case 5: //Charger
			{
				if((g_iClientInfectedClass1[iClient] != CHARGER) && (g_iClientInfectedClass2[iClient] != CHARGER))
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, CHARGER);
					ChooseClassesMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04charger\x05 as one of your classes.");
					ChangeClass3MenuDraw(iClient);
				}
			}
			case 6: //None
			{
				LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
				g_iClientInfectedClass3[iClient] = UNKNOWN_INFECTED;
				g_strClientInfectedClass3[iClient] = "None";
				ChooseClassesMenuDraw(iClient);
			}
			case 7: //Back
			{
				ChooseClassesMenuDraw(iClient);
			}
			default: //Exit
			{}
		}

		// Store the new changes in the db
		SaveUserData(iClient);
	}
}
