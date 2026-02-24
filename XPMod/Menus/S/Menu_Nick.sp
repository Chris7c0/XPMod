//Nick Menu////////////////////////////////////////////////////////////////

//Nick Menu Draw
Action NickMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(NickMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "%sLevel %d	XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Nick's Gambler Talents\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, "%s", text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Swindler", g_iSwindlerLevel[iClient]);
	AddMenuItem(menu, "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Leftover Supplies", g_iLeftoverLevel[iClient]);
	AddMenuItem(menu, "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Risky Business", g_iRiskyLevel[iClient]);
	AddMenuItem(menu, "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Enhanced Pain Killers", g_iEnhancedLevel[iClient]);
	AddMenuItem(menu, "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Magnum Stampede (Bind 1)", g_iMagnumLevel[iClient]);
	AddMenuItem(menu, "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Desperate Measures (Bind 2)         \n ", g_iDesperateLevel[iClient]);
	AddMenuItem(menu, "option6", text);
	
	AddMenuItem(menu, "option7", "Open In Website \n ");
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Swindler
Action SwindlerMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Swindler[iClient] = WriteParticle(iClient, "md_nick_swindler", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(SwindlerMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s						Swindler(Level %d):\
		\n \
		\nLevel 1:\
		\n+3 max health per level when ally uses a kit (max +100)\
		\n+1 life stealing recovery every other level\
		\n+1 life stealing damage every level\
		\n \
		\n \
		\nSkill Uses:\
		\nLife stealing ticks every second for 5 seconds\
		\nLife stealing only affects SI\
		\n ",
		strStartingNewLines,
		g_iSwindlerLevel[iClient]);
	SetMenuTitle(menu, "%s", text);
	
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

//Leftover Supplies
Action LeftoverMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Leftover[iClient] = WriteParticle(iClient, "md_nick_leftover", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(LeftoverMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s							Leftover Supplies(Level %d):\
		\n \
		\nLevel 1:\
		\n+15%%%% chance to spawn items when you use a medkit per level\
		\n \
		\nLevel 5:\
		\n Press [ZOOM] with a kit out to destroy it and gain:\
		\n1 random weapon\
		\n1 random grenade, 1 shot, or 1 pill\
		\n ",
		strStartingNewLines,
		g_iSkillPoints[iClient],
		g_iLeftoverLevel[iClient]);
	SetMenuTitle(menu, "%s", text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Risky Business
Action RiskyMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Risky[iClient] = WriteParticle(iClient, "md_nick_risky", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(RiskyMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s	Risky Business(Level %d):\
		\n \
		\nAll upgrades are (p220 & Glock):\
		\n \
		\nLevel 1:\
		\n+20%%%% reload speed per level\
		\n+20%%%% damage per level\
		\n+6 clip size per level\
		\n \
		\nLevel 5:\
		\n Pistols are now automatic\
		\n Press [WALK+ZOOM] cycle to dual pistols\
		\nYou can cycle back to Magnums\
		\n ",
		strStartingNewLines,
		g_iRiskyLevel[iClient]);
	SetMenuTitle(menu, "%s", text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Enhanced Pain Killers
Action EnhancedMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Enhanced[iClient] = WriteParticle(iClient, "md_nick_enhanced", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(EnhancedMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s					Enhanced Pain Killers(Level %d):\
		\n \
		\nLevel 1:\
		\n+6 temp health per level from pills & shots\
		\nRecover +1 health per level when anyone uses shots &   \
		\npills (+8 at max)\
		\n \
		\nShoot Survivors with Pistols to heal them...at a cost.\
		\n   Pistols:     +2 HP for Teammate, -1 HP for You\
		\n   Magnum:  +7 HP for Teammate, -3 HP for You\
		\n ",
		strStartingNewLines,
		g_iEnhancedLevel[iClient]);
	SetMenuTitle(menu, "%s", text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Magnum Stampede
Action MagnumMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Magnum[iClient] = WriteParticle(iClient, "md_nick_magnum", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(MagnumMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s			Magnum Stampede(Level %d):\
		\n			    Requires Level 11\
		\n \
		\nLevel 1:\
		\n+3%%%% movement speed per level\
		\nMax clip size is 4 (Magnum Only)\
		\n+100%%%% damage per level (Magnum Only)\
		\n \
		\nLevel 5:\
		\n+15%%%% reload speed for infected hit that clip (Magnum only)\
		\n \
		\n			Bind 1: Gambling Problem\
		\n			+1 use every other level\
		\n \
		\nLevel 1:\
		\nGamble for a random effect  \
		\n ",
		strStartingNewLines,
		g_iMagnumLevel[iClient]);
	SetMenuTitle(menu, "%s", text);
		
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

//Desperate Measures
Action DesperateMenuDraw(int iClient) 
{
	char text[512];
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Desperate[iClient] = WriteParticle(iClient, "md_nick_desperate", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(DesperateMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s				Desperate Measures(Level %d):\
		\n					  Requires Level 26\
		\n \
		\nLevel 1:\
		\n(Stacks) +2%%%% speed & +10%%%% gun damage per level\
		\n \
		\n \
		\n				Bind 2: Cheating Death\
		\n				+1 use every other level\
		\n \
		\nLevel 1:\
		\nHeal team +4 health per level (costs 1 charge)\
		\nLevel 3:\
		\nRevive incapacitated ally (costs 2 charges)\
		\nLevel 5:\
		\nResurrect a dead ally (costs 3 charges)\
		\n \
		\n \
		\nSkill Uses:\
		\n+1 (Stack) when ally incaps or dies\
		\n-1 (Stack) if ally recovers\
		\nMax 3 stacks\
		\n ",
		strStartingNewLines,
		g_iDesperateLevel[iClient]);
	SetMenuTitle(menu, "%s", text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Nick Menu Handler
void NickMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Swindler
			{
				SwindlerMenuDraw(iClient);
			}
			case 1: //Leftover Supplies
			{
				LeftoverMenuDraw(iClient);
			}
			case 2: //Risky Business
			{
				RiskyMenuDraw(iClient);
			}
			case 3: //Enhanced Pain Killers
			{
				EnhancedMenuDraw(iClient);
			}
			case 4: //Magnum Stampede
			{
				MagnumMenuDraw(iClient);
			}
			case 5: //Desperate Measures
			{
				DesperateMenuDraw(iClient);
			}
			case 6: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/survivors/ceda%20files/nick/xpmod_ig_talents_survivors_nick.html", MOTDPANEL_TYPE_URL);
				NickMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}

//Swindler Handler
void SwindlerMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Leftover Supplies Handler
void LeftoverMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Risky Business Handler
void RiskyMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Enhanced Pain Killers Handler
void EnhancedMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Magnum Stampede Handler
void MagnumMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Desperate Measures Handler
void DesperateMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}
