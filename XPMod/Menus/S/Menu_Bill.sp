//Support (Bill) Menu////////////////////////////////////////////////////////////////

//Bill Menu Draw
Action SupportMenuDraw(iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	
	Menu menu = CreateMenu(SupportMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "%sLevel %d	XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Bill's Support Talents\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Inspirational Leadership", g_iInspirationalLevel[iClient]);
	AddMenuItem(menu, "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Ghillie Tactics", g_iGhillieLevel[iClient]);
	AddMenuItem(menu, "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Will to Live", g_iWillLevel[iClient]);
	AddMenuItem(menu, "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Exorcism in a Barrel", g_iExorcismLevel[iClient]);
	AddMenuItem(menu, "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Die Hard (Bind 1)", g_iDiehardLevel[iClient]);
	AddMenuItem(menu, "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Promotional Benefits (Bind 2)          \n ", g_iPromotionalLevel[iClient]);
	AddMenuItem(menu, "option6", text);
	
	AddMenuItem(menu, "option7", "Open In Website	\n ");
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

//Inspirational Leadership Draw
Action InspirationalMenuDraw(iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Inspirational[iClient] = WriteParticle(iClient, "md_bill_inspirational", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(InspirationalMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s				Inspirational Leadership (Level %d)\
		\n \
		\n(Team) +10 bonus XP per level for teammates on SI kill\
		\n \
		\nHold [CROUCH] to heal closest ally\
		\n	- Heals %i HP every %i second\
		\n	- Health Pool of %i HP shared with all Bills\
		\n	- Maximum distance of 100 ft\
		\n ",
		strStartingNewLines,
		g_iInspirationalLevel[iClient],
		BILL_TEAM_HEAL_HP_AMOUNT,
		BILL_TEAM_HEAL_FRAME_COUNTER_REQUIREMENT,
		BILL_TEAM_HEAL_HP_POOL);
	SetMenuTitle(menu, text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Ghillie Tactics
Action GhillieMenuDraw(iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Ghillie[iClient] = WriteParticle(iClient, "md_bill_ghillie", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	Menu menu = CreateMenu(GhillieMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	FormatEx(text, sizeof(text), "\
		%s				Ghillie Tactics(Level %d):\
		\n \
		\n+13%%%% cloaking per level\
		\n(Charge) +30 sprinting stamina per level\
		\n \
		\n \
		\nSkill Uses:\
		\n(Charge) sprinting stamina builds over time\
		\nHold [WALK] to activate\
		\nWorks while incapacitated\
		\n ",
		strStartingNewLines,
		g_iGhillieLevel[iClient]);
	SetMenuTitle(menu, text);

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

//Will to Live Draw
Action WillMenuDraw(iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Will[iClient] = WriteParticle(iClient, "md_bill_will", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(WillMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s					Will to Live(Level %d):\
		\n \
		\n+5 max health per level\
		\n+50 incap health per level\
		\n(Team) Allow crawling\
		\n(Stacks) (Team) +5 crawl speed per level\
		\n \
		\n \
		\nSkill Uses:\
		\nCrawl speed (Stacks) with itself\
		\nUnlimited stacks\
		\n ",
		strStartingNewLines,
		g_iWillLevel[iClient]);
	SetMenuTitle(menu, text);

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


//Exorcism in a Barrel Draw
Action ExorcismMenuDraw(iClient) 
{
	char text[512];
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Exorcism[iClient] = WriteParticle(iClient, "md_bill_exorcism", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(ExorcismMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s  Exorcism in a Barrel(Level %d):\
		\n \
		\n+6%%%% Assault Rifle damage per level\
		\n+20%%%% Reload speed per level\
		\n ",
		strStartingNewLines,
		g_iExorcismLevel[iClient]);
	SetMenuTitle(menu, text);
	
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

//Die Hard Draw
Action DiehardMenuDraw(iClient) 
{
	char text[512];
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Diehard[iClient] = WriteParticle(iClient, "md_bill_diehard", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(DiehardMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s					Die Hard(Level %d):\
		\n \
		\n+15 max health per level\
		\nRegen 9 health when ally incaps per level\
		\n+5hp to healing pool when ally incaps per level\
		\n \
		\n		Bind 1: Improvised Explosives\
		\n			+1 use every other level\
		\n \
		\nDrop +1 active pipebomb every other level\
		\n ",
		strStartingNewLines,
		g_iDiehardLevel[iClient]);
	SetMenuTitle(menu, text);

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

//Promotional Benefits Draw
Action PromotionalMenuDraw(iClient) 
{
	char text[512];
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Promotional[iClient] = WriteParticle(iClient, "md_bill_promotional", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(PromotionalMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s		Promotional Benefits(Level %d):\
		\n \
		\n+8%%%% reload speed & cloaking per level\
		\n+20 rifle clip size per level\
		\n+20%%%% M60 damage per level\
		\nAutomatic laser sight\
		\nHide glow from SI\
		\n \
		\n \
		\n				Bind 2: First Blood\
		\n			+1 use every other level\
		\n \
		\nSpawn M60\
		\n ",
		strStartingNewLines,
		g_iPromotionalLevel[iClient]);
	SetMenuTitle(menu, text);

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

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Bill Menu Handler
SupportMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Inspirational
			{
				InspirationalMenuDraw(iClient);
			}
			case 1: //Ghillie Tactics
			{
				GhillieMenuDraw(iClient);
			}
			case 2: //Will to Live
			{
				WillMenuDraw(iClient);
			}
			case 3: //Exorcism in a Barrel
			{
				ExorcismMenuDraw(iClient);
			}
			case 4: //Die Hard
			{
				DiehardMenuDraw(iClient);
			}
			case 5: //Promotional Benefits
			{
				PromotionalMenuDraw(iClient);
			}
			case 6: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/survivors/ceda%20files/bill/xpmod_ig_talents_survivors_bill.html", MOTDPANEL_TYPE_URL);
				SupportMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}


//Inspirational Handler
InspirationalMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				SupportMenuDraw(iClient);
			}
		}
	}
}

//Ghillie Tactics Menu Handler
GhillieMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				SupportMenuDraw(iClient);
            }
        }
    }
}


//Will to Live Handler
WillMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				SupportMenuDraw(iClient);
			}
		}
	}
}


//Exorcism in a Barrel Handler
ExorcismMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				SupportMenuDraw(iClient);
			}
		}
	}
}

//Die Hard Handler
DiehardMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				SupportMenuDraw(iClient);
			}
		}
	}
}

//Promotional Benefit Handler
PromotionalMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				SupportMenuDraw(iClient);
			}
		}
	}
}