//Coach Menu////////////////////////////////////////////////////////////////

//Coach Menu Draw
Action:CoachMenuDraw(iClient)
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(CoachMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "%sLevel %d	XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Coach's Berserker Talents\n ", strStartingNewLines,g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Bull Rush", g_iBullLevel[iClient]);
	AddMenuItem(menu, "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Wrecking Ball", g_iWreckingLevel[iClient]);
	AddMenuItem(menu, "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Spray n' Pray", g_iSprayLevel[iClient]);
	AddMenuItem(menu, "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Homerun!", g_iHomerunLevel[iClient]);
	AddMenuItem(menu, "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Lead by Example (Bind 1)        ", g_iLeadLevel[iClient]);
	AddMenuItem(menu, "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Strong Arm (Bind 2)\n ", g_iStrongLevel[iClient]);
	AddMenuItem(menu, "option6", text);
	
	AddMenuItem(menu, "option7", "Open In Website\n ");
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\n \n=	=	=	=	=	=	=	=	=	=	=	=	=\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Bull Rush
Action:BullMenuDraw(iClient)
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Bull[iClient] = WriteParticle(iClient, "md_coach_bull", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(BullMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s			Bull Rush(Level %d):\
		\n \
		\nLevel 1:\
		\n+5 max health per level\
		\nOn CI headshot with a melee weapon:\
		\n+5%%%% speed per level for 5 seconds\
		\n \
		\n [WALK+USE] to rage! For 20 seconds:\
		\n+5%%%% speed per level\
		\n+40 melee damage per level\
		\nHealth regeneration\
		\n3 Minute Cooldown. During Cooldown:\
		\n-3%%%% speed per level\
		\nCoach cannot regen or speed up\
		\n ",
		strStartingNewLines,
		g_iBullLevel[iClient]);
	SetMenuTitle(menu, text);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Wrecking Ball
Action:WreckingMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Wrecking[iClient] = WriteParticle(iClient, "md_coach_wrecking", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(WreckingMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s									Wrecking Ball(Level %d):\
		\n \
		\nLevel 1:\
		\n(Charge) +100 melee dmg per level\
		\n+10 max health per level\
		\n \
		\nLevel 5:\
		\nOn SI headshot w/ melee weapon & Wrecking Ball charged:\
		\nInstantly recharge Wrecking Ball\
		\n(Charge) +1 health regen every 2 seconds\
		\n \
		\n \
		\nSkill Uses:\
		\n(Charge) Melee dmg bonus: Hold [CROUCH] to power up\
		\n(Charge) Melee dmg bonus expelled on next [MELEE] against SI\
		\n(Charge) HP regen: Hold [CROUCH] to heal yourself\
		\n ",
		strStartingNewLines,
		g_iWreckingLevel[iClient]);
	SetMenuTitle(menu, text);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Spray n' Pray
Action:SprayMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Spray[iClient] = WriteParticle(iClient, "md_coach_spray", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(SprayMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s			Spray n' Pray(Level %d):\
		\n \
		\n+2 shotgun clip size per level\
		\n+2 shotgun pellet damage per level\
		\n ",
		strStartingNewLines,
		g_iSprayLevel[iClient]);
	SetMenuTitle(menu, text);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Homerun
Action:HomerunMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Homerun[iClient] = WriteParticle(iClient, "md_coach_homerun", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(HomerunMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s				Homerun!(Level %d):\
		\n \
		\nLevel 1:\
		\nOn SI headshot with melee weapon:\
		\n+5%% speed per level for 10 seconds\
		\n \
		\n(Stacks) +2 melee damage per level\
		\n \
		\nLevel 5:\
		\nNo melee fatigue\
		\n \
		\n \
		\nSkill Uses:\
		\n+1 (Stack) when decapitating infected\
		\nMax 50 stacks\
		\n ",
		strStartingNewLines,
		g_iHomerunLevel[iClient]);
	SetMenuTitle(menu, text);

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Lead by Example
Action:LeadMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Lead[iClient] = WriteParticle(iClient, "md_coach_lead", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(LeadMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s				Lead by Example(Level %d):\
		\n					Requires Level 11\
		\n \
		\nLevel 1:\
		\n(Team) +10%%%% chainsaw fuel per level\
		\n(Stacks) (Team) +5 max health per level\
		\n \
		\nLevel 5:\
		\n(Stacks) (Team) Reduce screen shaking when\
		\n   taking damage by 50%%%%\
		\n \
		\n \
		\n				 Bind 1: Heavy Gunner\
		\n				+1 use every other level\
		\n \
		\nLevel 1:\
		\nDeploy Turrets\
		\n \
		\n \
		\nSkill Uses:\
		\n(Team) max health (Stacks) with itself\
		\n ",
		strStartingNewLines,
		g_iLeadLevel[iClient]);
	SetMenuTitle(menu, text);
	
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

//Strong Arm
Action:StrongMenuDraw(iClient) 
{
	decl String:text[512];
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Strong[iClient] = WriteParticle(iClient, "md_coach_strong", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(StrongMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s					Strong Arm(Level %d):\
		\n					 Requires Level 26\
		\n \
		\nLevel 1:\
		\n+30 melee damage per level\
		\n+10 max health per level\
		\n+20%% Jockey resistance per level\
		\nStart the round with a random explosive\
		\n \
		\nLevel 2:\
		\n+1 explosive storage every other level\
		\n [WALK+ZOOM] to cycle explosives\
		\n \
		\n \
		\n			Bind 2: D.E.A.D. Jetpack (Charge)\
		\n						Limited Fuel\
		\n \
		\nLevel 1:\
		\n+160 fuel per level\
		\n \
		\nSkill Uses:\
		\n(Charge): Hold [WALK] to fly when jetpack is on\
		\n ",
		strStartingNewLines,
		g_iStrongLevel[iClient]);
	SetMenuTitle(menu, text);
	
	decl String:strFinalOptionText[250];
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
CoachMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Bull Rush
			{
				BullMenuDraw(iClient);
			}
			case 1: //Wrecking Ball
			{
				WreckingMenuDraw(iClient);
			}
			case 2: //Spray n' Pray
			{
				SprayMenuDraw(iClient);
			}
			case 3: //Homerun
			{
				HomerunMenuDraw(iClient);
			}
			case 4: //Lead by Example
			{
				LeadMenuDraw(iClient);
			}
			case 5: //Strong Arm
			{
				StrongMenuDraw(iClient);
			}
			case 6: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/survivors/ceda%20files/coach/xpmod_ig_talents_survivors_coach.html", MOTDPANEL_TYPE_URL);
				CoachMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}

//Bull Training Handler
BullMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				CoachMenuDraw(iClient);
			}
		}
	}
}

//Wrecking Ball Handler
WreckingMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				CoachMenuDraw(iClient);
			}
		}
	}
}

//Spray n' Pray Handler
SprayMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				CoachMenuDraw(iClient);
			}
		}
	}
}

//Homerun Handler
HomerunMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				CoachMenuDraw(iClient);
			}
		}
	}
}

//Lead by Example Handler
LeadMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				CoachMenuDraw(iClient);
			}
		}
	}
}

//Strong Arm Handler
StrongMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				CoachMenuDraw(iClient);
			}
		}
	}
}