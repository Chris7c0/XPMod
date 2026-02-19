//Boomer Menu

//Boomer Top Menu Draw
Action BoomerTopMenuDraw(int iClient) 
{
	DeleteAllMenuParticles(iClient);

	Menu menu = CreateMenu(BoomerTopMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	char title[256];
	FormatEx(title, sizeof(title), "%sLevel %d	XP: %d/%d\n==========================\nBoomer Talents:\n==========================\n \nRapid Regurgitation: Level %d\nAcidic Brew: Level %d\nNorovirus: Level %d\n \n", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iRapidLevel[iClient], g_iAcidicLevel[iClient], g_iNorovirusLevel[iClient]);
	SetMenuTitle(menu, title);
	AddMenuItem(menu, "option1", "Rapid Regurgitation");
	AddMenuItem(menu, "option2", "Acidic Brew");
	AddMenuItem(menu, "option3", "Norovirus\n ");
	
	AddMenuItem(menu, "option4", "Choose The Boomer\n ");
	
	AddMenuItem(menu, "option5", "Open In Website\n ");
	
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		\n==========================\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Talent Draws///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Rapid Regurgitation Menu Draw
Action RapidMenuDraw(int iClient)
{
	Menu menu = CreateMenu(RapidMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	SetMenuTitle(menu, "\
		%s  					Rapid Regurgitation (Level %d)\
		\n \
		\n-2 second vomit cooldown per level\
		\nReduce movement penalty after vomiting by 10%% per level\
		\n ",
		strStartingNewLines,
		g_iRapidLevel[iClient]);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Acidic Brew Menu Draw
Action AcidicMenuDraw(int iClient)
{
	Menu menu = CreateMenu(AcidicMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s						Acidic Brew (Level %d)\
		\n \
		\nVomit victims lose their HUD for 2 seconds per level\
		\n+1 damage per level to survivors near your death boom\
		\n \
		\n \
		\n						  Bind 1: Hot Meal\
		\n					3 uses; 9 second duration\
		\n \
		\nConstant vomiting while active\
		\n+10%% movement speed per level\
		\n ",
		strStartingNewLines,
		g_iAcidicLevel[iClient]);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Norovirus Menu Draw
Action NorovirusMenuDraw(int iClient)
{
	Menu menu = CreateMenu(NorovirusMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s							Norovirus (Level %d)\
		\n \
		\nLevel 1:\
		\n+4%% chance to make survivors vomit per level\
		\n \
		\nLevel 5:\
		\nRandom effect if you vomit on 3 survivors within 9 seconds\
		\n \
		\n \
		\n						Bind 2: Suicide Boomer\
		\n									3 uses\
		\n \
		\n+5x jump heighth per level\
		\n+2 boom damage per level\
		\n+20%% fling distance per level\
		\n+20%% boom distance per level\
		\n ",
		strStartingNewLines,
		g_iNorovirusLevel[iClient]);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Boomer Menu Draw
Action ChooseBoomerClassMenuDraw(int iClient) 
{
	DeleteAllMenuParticles(iClient);
	
	Menu menu = CreateMenu(ChooseBoomerClassMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	char title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Boomer:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(menu, title);
	AddMenuItem(menu, "option1", "Replace Class 1");
	AddMenuItem(menu, "option2", "Replace Class 2");
	AddMenuItem(menu, "option3", "Replace Class 3");
	AddMenuItem(menu, "option9", "Back");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Handlers/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Boomer Top Menu Handler
void BoomerTopMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Rapid Regurgitation
			{
				RapidMenuDraw(iClient);
			}
			case 1: //Acidic Brew
			{
				AcidicMenuDraw(iClient);
			}
			case 2: //Norovirus
			{
				NorovirusMenuDraw(iClient);
			}
			case 3: //Select This Class
			{
				if((g_iClientInfectedClass1[iClient] != BOOMER) && (g_iClientInfectedClass2[iClient] != BOOMER) && (g_iClientInfectedClass3[iClient] != BOOMER))
				{
					if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
						ChooseBoomerClassMenuDraw(iClient);
					else
					{
						PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
						BoomerTopMenuDraw(iClient);
					}
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04boomer\x05 as one of your classes.");
					BoomerTopMenuDraw(iClient);
				}
			}
			case 4: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/infected/ceda%20files/boomer/xpmod_ig_talents_infected_boomer.html", MOTDPANEL_TYPE_URL);
				BoomerTopMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}

//Rapid Regurgitation Menu Handler
void RapidMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				BoomerTopMenuDraw(iClient);
			}
/*			case 1: //Talent Info
			{
				RapidDescMenuDraw(iClient);
			}*/
		}
	}
}

//Acidic Brew Menu Handler
void AcidicMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				BoomerTopMenuDraw(iClient);
			}
/*			case 1: //Talent Info
			{
				AcidicDescMenuDraw(iClient);
			}
			case 2: //Bind Info
			{
				AcidicBindMenuDraw(iClient);
			}
			case 3: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}*/
		}
	}
}

//Norovirus Menu Handler
void NorovirusMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				BoomerTopMenuDraw(iClient);
			}
/*			case 1: //Talent Info
			{
				NorovirusDescMenuDraw(iClient);
			}
			case 2: //Bind Info
			{
				NorovirusBindMenuDraw(iClient);
			}
			case 3: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}*/
		}
	}
}
/*
//Acidic Brew Bind Handler
void AcidicBindMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				AcidicMenuDraw(iClient);
			}
			case 1: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}
		}
	}
}

//Norovirus Bind Handler
void NorovirusBindMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				NorovirusMenuDraw(iClient);
			}
			case 1: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}
		}
	}
}

//Rapid Regurgitation Description Handler
void RapidDescMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				RapidMenuDraw(iClient);
			}
		}
	}
}

//Acidic Brew Description Handler
void AcidicDescMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				AcidicMenuDraw(iClient);
			}
		}
	}
}

//Norovirus Description Handler
void NorovirusDescMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				NorovirusMenuDraw(iClient);
			}
		}
	}
}
*/
//Choose Boomer Top Menu Handler
void ChooseBoomerClassMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Replace Class 1
			{
				if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass1[iClient]);
					SetInfectedClassSlot(iClient, 1, BOOMER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 1\x05 with the \x04Boomer\x05.");
					BoomerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 1\x05 because it has already been confirmed.");
					ChooseBoomerClassMenuDraw(iClient);
				}
			}
			case 1: //Replace Class 2
			{
				if(g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, BOOMER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 2\x05 with the \x04Boomer\x05.");
					BoomerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 2\x05 because it has already been confirmed.");
					ChooseBoomerClassMenuDraw(iClient);
				}
			}
			case 2: //Replace Class 3
			{
				if(g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, BOOMER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 3\x05 with the \x04Boomer\x05.");
					BoomerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 3\x05 because it has already been confirmed.");
					ChooseBoomerClassMenuDraw(iClient);
				}
			}
			default: //Back
			{
				BoomerTopMenuDraw(iClient);
			}
		}
	}
}
