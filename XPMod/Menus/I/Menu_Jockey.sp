//Jockey Menu

//Jockey Menu Draw
Action:JockeyTopMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(JockeyTopMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "%sLevel %d	XP: %d/%d\n==========================\nJockey Talents:\n==========================\n \nMutated Tenacity: Level %d\nErratic Domination: Level %d\nUnfair Advantage: Level %d\n \n", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iMutatedLevel[iClient], g_iErraticLevel[iClient], g_iUnfairLevel[iClient]);
	SetMenuTitle(menu, title);
	AddMenuItem(menu, "option1", "Mutated Tenacity");
	AddMenuItem(menu, "option2", "Erratic Domination");
	AddMenuItem(menu, "option3", "Unfair Advantage\n ");
	
	AddMenuItem(menu, "option4", "Choose The Jockey\n ");
	
	AddMenuItem(menu, "option5", "Open In Website\n ");
	
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	decl String:strFinalOptionText[250];
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

//Mutated Tenacity Menu Draw
Action:MutatedMenuDraw(iClient)
{
	Menu menu = CreateMenu(MutatedMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s  				Mutated Tenacity (Level %d)\
		\n \
		\n+1 melee damage every 3 levels\
		\n+6%% lunge distance per level\
		\n-0.35 seconds from all lunge cooldowns per level\
		\n ",
		strStartingNewLines,
		g_iMutatedLevel[iClient]);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Erratic Domination Menu Draw
Action:ErraticMenuDraw(iClient)
{
	Menu menu = CreateMenu(ErraticMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s						Erratic Domination (Level %d)\
		\n \
		\n+1 riding damage every 3 levels\
		\n+3%% riding speed per level\
		\n \
		\n Drag Race:\
		\n	- Drag Victims for Tiered Rewards\
		\n	- Tier 1: 50 Ft.\
		\n	- Tier 2: 100 Ft.\
		\n	- Tier 3: 150 Ft.\
		\n \
		\n						  Bind 1: Golden Shower\
		\n							 		3 uses\
		\n \
		\nLevel 1:\
		\nWhile riding, urinate on your victim, attracting infected\
		\nDisables survivors cloaking\
		\nAll Nearby CI Are Upgraded to BIG Enhanced CEDA Workers\
		\n \
		\nLevel 10:\
		\nSummon a horde\
		\n ",
		strStartingNewLines,
		g_iErraticLevel[iClient]);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Unfair Advantage Menu Draw
Action:UnfairMenuDraw(iClient)
{
	Menu menu = CreateMenu(UnfairMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s	Unfair Advantage (Level %d)\
		\n \
		\n+35 max health per level\
		\n+7%% movement speed per level\
		\n \
		\n \
		\n		Bind 2: Vanishing Act\
		\n	3 uses; 10 second duration\
		\n \
		\n+9%% cloaking per level\
		\nDisable Jockey & survivor glow\
		\n+5%% riding speed per level\
		\nJumping Enabled (+50 height per level)\
		\n ",
		strStartingNewLines,
		g_iUnfairLevel[iClient]);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Jockey Menu Draw
Action:ChooseJockeyClassMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	
	Menu menu = CreateMenu(ChooseJockeyClassMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Jockey:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
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

//Jockey Top Menu Handler
JockeyTopMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Predatorial Evolution
			{
				MutatedMenuDraw(iClient);
			}
			case 1: //Blood Lust
			{
				ErraticMenuDraw(iClient);
			}
			case 2: //Kill-meleon
			{
				UnfairMenuDraw(iClient);
			}
			case 3: //Select This Class
			{
				if((g_iClientInfectedClass1[iClient] != JOCKEY) && (g_iClientInfectedClass2[iClient] != JOCKEY) && (g_iClientInfectedClass3[iClient] != JOCKEY))
				{
					if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
						ChooseJockeyClassMenuDraw(iClient);
					else
					{
						PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
						JockeyTopMenuDraw(iClient);
					}
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04jockey\x05 as one of your classes.");
					JockeyTopMenuDraw(iClient);
				}
			}
			case 4: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/infected/ceda%20files/jockey/xpmod_ig_talents_infected_jockey.html", MOTDPANEL_TYPE_URL);
				JockeyTopMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}

//Mutated Tenacity Menu Handler
MutatedMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				JockeyTopMenuDraw(iClient);
			}
		}
	}
}

//Erratic Domination Menu Handler
ErraticMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				JockeyTopMenuDraw(iClient);
			}
		}
	}
}

//Unfair Advantage Menu Handler
UnfairMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				JockeyTopMenuDraw(iClient);
			}
		}
	}
}

//Choose Jockey Top Menu Handler
ChooseJockeyClassMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
					SetInfectedClassSlot(iClient, 1, JOCKEY);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 1\x05 with the \x04Jockey\x05.");
					JockeyTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 1\x05 because it has already been confirmed.");
					ChooseJockeyClassMenuDraw(iClient);
				}
			}
			case 1: //Replace Class 2
			{
				if(g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, JOCKEY);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 2\x05 with the \x04Jockey\x05.");
					JockeyTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 2\x05 because it has already been confirmed.");
					ChooseJockeyClassMenuDraw(iClient);
				}
			}
			case 2: //Replace Class 3
			{
				if(g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, JOCKEY);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 3\x05 with the \x04Jockey\x05.");
					JockeyTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 3\x05 because it has already been confirmed.");
					ChooseJockeyClassMenuDraw(iClient);
				}
			}
			default: //Back
			{
				JockeyTopMenuDraw(iClient);
			}
		}
	}
}