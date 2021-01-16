//Support (Bill) Menu////////////////////////////////////////////////////////////////

//Bill Menu Draw
Action:SupportMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(SupportMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	FormatEx(text, sizeof(text), "Level %d   XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Bill's Support Talents\n ", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Inspirational Leadership", g_iInspirationalLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Ghillie Tactics", g_iGhillieLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Will to Live", g_iWillLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Exorcism in a Barrel", g_iExorcismLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Die Hard (Bind 1)", g_iDiehardLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Promotional Benefits (Bind 2)          \n ", g_iPromotionalLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option6", text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Detailed Talent Descriptions	\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Back\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Inspirational Leadership Draw
Action:InspirationalMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Inspirational[iClient] = WriteParticle(iClient, "md_bill_inspirational", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(InspirationalMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Inspirational Leadership (Level %d)\n \nLevel 1:\n(Team) +10 bonus XP per level for teammates on SI kill\n(Charge) Regenerate 1 life to random ally per level\n \n \nSkill Uses:\n(Charge) HP Regeneration: Hold [CROUCH] to heal allies\nevery 6 seconds\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=",g_iInspirationalLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Ghillie Tactics
Action:GhillieMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Ghillie[iClient] = WriteParticle(iClient, "md_bill_ghillie", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	g_hMenu_XPM[iClient] = CreateMenu(GhillieMenuHandler);

	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Ghillie Tactics(Level %d):\n \nLevel 1:\n+13%%%% cloaking per level\n(Charge) +30 sprinting stamina per level\n \n \nSkill Uses:\n(Charge) sprinting stamina builds over time\nHold [WALK] to activate\nWorks while incapacitated\n \n=	=	=	=	=	=	=	=	=	=	=	=	=", g_iGhillieLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Will to Live Draw
Action:WillMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Will[iClient] = WriteParticle(iClient, "md_bill_will", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(WillMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Will to Live(Level %d):\n \nLevel 1:\n+5 max health per level\n+50 incap health per level\n(Team) Allow crawling\n(Stacks) (Team) +5 crawl speed per level\n \n \nSkill Uses:\nCrawl speed (Stacks) with itself\nUnlimited stacks\n \n=	=	=	=	=	=	=	=	=	=	=	=	=", g_iWillLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


//Exorcism in a Barrel Draw
Action:ExorcismMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Exorcism[iClient] = WriteParticle(iClient, "md_bill_exorcism", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(ExorcismMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=\n \n  Exorcism in a Barrel(Level %d):\n \nLevel 1:\n+4%%%% assault rifle damage per level\n+20%%%% reload speed per level\n \n=	=	=	=	=	=	=	=	=	=", g_iExorcismLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Die Hard Draw
Action:DiehardMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Diehard[iClient] = WriteParticle(iClient, "md_bill_diehard", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(DiehardMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Die Hard(Level %d):\n					Requires Level 11\n \nLevel 1:\n+15 max health per level\nRegen 6 health when ally incaps per level\n \n \n		Bind 1: Improvised Explosives\n			+1 use every other level\n \nLevel 1:\nDrop +1 active pipebomb every other level\n \n=	=	=	=	=	=	=	=	=	=	=	=	=", g_iDiehardLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Promotional Benefits Draw
Action:PromotionalMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Promotional[iClient] = WriteParticle(iClient, "md_bill_promotional", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(PromotionalMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=\n \n		Promotional Benefits(Level %d):\n			   Requires Level 26\n \nLevel 1:\n+8%%%% reload speed & cloaking per level\n+20 rifle clip size per level\n+20%%%% M60 damage per level\nAutomatic laser sight\nHide glow from SI\n \n \n				Bind 2: First Blood\n			+1 use every other level\n \nLevel 1:\nSpawn M60\n \n=	=	=	=	=	=	=	=	=	=	=", g_iPromotionalLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Bill Menu Handler
SupportMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 6: //Detailed Talent Descriptions
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/survivors/ceda%20files/bill/xpmod_ig_talents_survivors_bill.html", MOTDPANEL_TYPE_URL);
				SupportMenuDraw(iClient);
			}
			case 7: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}


//Inspirational Handler
InspirationalMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
GhillieMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if( action == MenuAction_Select )
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
WillMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
ExorcismMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
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
DiehardMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
PromotionalMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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