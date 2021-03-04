//Jockey Menu

//Jockey Menu Draw
Action:JockeyTopMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(JockeyTopMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "\n \nLevel %d	XP: %d/%d\n==========================\nJockey Talents:\n==========================\n \nMutated Tenacity: Level %d\nErratic Domination: Level %d\nUnfair Advantage: Level %d\n \n", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iMutatedLevel[iClient], g_iErraticLevel[iClient], g_iUnfairLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Mutated Tenacity");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Erratic Domination");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Unfair Advantage\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Choose The Jockey\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Open In Website\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\
		\n==========================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Talent Draws///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Mutated Tenacity Menu Draw
Action:MutatedMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(MutatedMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n  				Mutated Tenacity (Level %d)\n \nLevel 1:\n+1 melee damage every 3 levels\n+6%% lunge distance per level\n-0.35 seconds from all lunge cooldowns per level\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iMutatedLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Erratic Domination Menu Draw
Action:ErraticMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ErraticMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n						Erratic Domination (Level %d)\n \nLevel 1:\n+1 riding damage every 3 levels\n+3%% riding speed per level\n \n \n						  Bind 1: Golden Shower\n							 		3 uses\n \nLevel 1:\nWhile riding, urinate on your victim, attracting infected\nDisables survivors cloaking\n+1% per level to summon a tank\n \nLevel 10:\nSummon a horde\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iErraticLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Unfair Advantage Menu Draw
Action:UnfairMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(UnfairMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=\n \n	Unfair Advantage (Level %d)\n \nLevel 1:\n+35 max health per level\n+7%% movement speed per level\n \n \n		Bind 2: Vanishing Act\n	3 uses; 10 second duration\n \nLevel 1:\n+9%% cloaking per level\nDisable Jockey & survivor glow\n+5%% riding speed per level\nJumping Enabled (+50 height per level)\n \n=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iUnfairLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Jockey Menu Draw
Action:ChooseJockeyClassMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChooseJockeyClassMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Jockey:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Replace Class 1");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Replace Class 2");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Replace Class 3");
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Handlers/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Jockey Top Menu Handler
JockeyTopMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
MutatedMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
ErraticMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
UnfairMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
ChooseJockeyClassMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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