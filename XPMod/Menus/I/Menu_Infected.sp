//Infected Talents Menu

//Top Infected Menu Draw
Action:TopInfectedMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(TopInfectedMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "\n \nLevel %d	XP: %d/%d\n==========================\n		 Your Infected\n \n Class 1)	%s\n Class 2)	%s\n Class 3)	%s\n ", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Smoker");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Boomer");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Hunter");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Spitter");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Jockey");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Charger");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Tanks\n ");

	if (g_bTalentsConfirmed[iClient] == false)
		AddMenuItem(g_hMenu_XPM[iClient], "option8", " * Change Your Infected *\n ");
	else
		AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back");
	AddMenuItem(g_hMenu_XPM[iClient], "option10", "Exit the Menu\
		\n==========================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Change Your Infected Menu Draw
Action:ChangeInfectedMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChangeInfectedMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "\n \nLevel %d	XP: %d/%d\n==========================\n	Change Your Infected\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n ", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient],g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Change Class 1");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Change Class 2");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Change Class 3\n ");

	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Confirm Your Infected\n==========================\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Change Infected Class 1
Action:ChangeClass1MenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChangeClass1MenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	SetMenuTitle(g_hMenu_XPM[iClient], "\n \nChange Your Infected\n==========================\n		Your Infected\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n \nChange Class 1 to...", g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Smoker");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Boomer");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Hunter");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Spitter");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Jockey");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Charger");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "None\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\
		\n==========================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}
//Change Infected Class 2
Action:ChangeClass2MenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChangeClass2MenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	SetMenuTitle(g_hMenu_XPM[iClient], "\n \nChange Your Infected\n==========================\n		Your Infected\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n \nChange Class 2 to...", g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Smoker");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Boomer");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Hunter");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Spitter");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Jockey");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Charger");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "None\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\
		\n==========================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}
//Change Infected Class 3
Action:ChangeClass3MenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChangeClass3MenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	SetMenuTitle(g_hMenu_XPM[iClient], "\n \nChange Your Infected\n==========================\n		Your Infected\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n \nChange Class 3 to...", g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Smoker");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Boomer");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Hunter");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Spitter");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Jockey");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Charger");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "None\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\
		\n==========================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Infected Menu Handlers

//Top Infected Menu Handler
TopInfectedMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Smoker
			{
				SmokerTopMenuDraw(iClient);
			}
			case 1: //Boomer
			{
				BoomerTopMenuDraw(iClient);
			}
			case 2: //Hunter
			{
				HunterTopMenuDraw(iClient);
			}
			case 3: //Spitter
			{
				SpitterTopMenuDraw(iClient);
			}
			case 4: //Jockey
			{
				JockeyTopMenuDraw(iClient);
			}
			case 5: //Charger
			{
				ChargerTopMenuDraw(iClient);
			}
			case 6: //Tank
			{
				TankTopMenuDraw(iClient);
			}
			case 7: //Select Infected Classes
			{
				if(g_bTalentsConfirmed[iClient] == false)
					ChangeInfectedMenuDraw(iClient);
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
					TopInfectedMenuDraw(iClient);
				}
			}
			case 8: //Back
			{
				TopChooseCharactersMenuDraw(iClient);
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
ChangeInfectedMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
					ChangeInfectedMenuDraw(iClient);
				}
			}
			case 1: //Change Class 2
			{
				if(g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
					ChangeClass2MenuDraw(iClient);
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
					ChangeInfectedMenuDraw(iClient);
				}
			}
			case 2: //Change Class 3
			{
				if(g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
					ChangeClass3MenuDraw(iClient);
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
					ChangeInfectedMenuDraw(iClient);
				}
			}
			case 3: //Confirm
			{
				DrawConfirmationMenuToClient(iClient);
			}
		}
	}
}


// //Confirm Reset All Classes Menu
// ConfirmResetClassesHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
// {
// 	if(action==MenuAction_Select) 
// 	{
// 		switch (itemNum)
// 		{
// 			case 0: //Yes
// 			{
// 				ResetAllInfectedClasses(iClient);
// 				PrintToChat(iClient, "\x03[XPMod] \x05All of your Special Infected Classes have been reset.");
// 				ChangeInfectedMenuDraw(iClient);
// 			}
// 			case 1: //No
// 			{
// 				ChangeInfectedMenuDraw(iClient);
// 			}
// 		}
// 	}
// }

//Change Infected Class 1
ChangeClass1MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
				ChangeInfectedMenuDraw(iClient);
			}
			case 8: //Back
			{
				ChangeInfectedMenuDraw(iClient);
			}
			default: //Exit
			{}
		}

		// Store the new changes in the db
		SaveUserData(iClient);
	}
}
//Change Infected Class 2
ChangeClass2MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
				ChangeInfectedMenuDraw(iClient);
			}
			case 8: //Back
			{
				ChangeInfectedMenuDraw(iClient);
			}
			default: //Exit
			{}
		}

		// Store the new changes in the db
		SaveUserData(iClient);
	}
}
//Change Infected Class 3
ChangeClass3MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
					ChangeInfectedMenuDraw(iClient);
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
				ChangeInfectedMenuDraw(iClient);
			}
			case 8: //Back
			{
				ChangeInfectedMenuDraw(iClient);
			}
			default: //Exit
			{}
		}

		// Store the new changes in the db
		SaveUserData(iClient);
	}
}
