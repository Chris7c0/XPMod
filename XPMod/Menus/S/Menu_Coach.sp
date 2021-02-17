//Coach Menu////////////////////////////////////////////////////////////////

//Coach Menu Draw
Action:CoachMenuDraw(iClient)
{
	decl String:text[512];
	
	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(CoachMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	FormatEx(text, sizeof(text), "Level %d   XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Coach's Berserker Talents\n ", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Bull Rush", g_iBullLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Wrecking Ball", g_iWreckingLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Spray n' Pray", g_iSprayLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Homerun!", g_iHomerunLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Lead by Example (Bind 1)", g_iLeadLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Strong Arm (Bind 2)\n ", g_iStrongLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option6", text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Open In Website\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Back\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Bull Rush
Action:BullMenuDraw(iClient)
{
	decl String:text[512];
	
	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Bull[iClient] = WriteParticle(iClient, "md_coach_bull", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(BullMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=\n \n			Bull Rush(Level %d):\n \nLevel 1:\n+15 max health per level\nOn CI headshot with a melee weapon:\n+5%% speed per level for 5 seconds\n \n [WALK+USE] to rage! For 20 seconds:\n+4%% speed per level\n+20 melee damage per level\nHealth regeneration\n60 second cooldown. During cooldown:\nCoach cannot regen or speed up\n \n=	=	=	=	=	=	=	=	=",  g_iSkillPoints[iClient], g_iBullLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Wrecking Ball
Action:WreckingMenuDraw(iClient) 
{
	decl String:text[512];
	
	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Wrecking[iClient] = WriteParticle(iClient, "md_coach_wrecking", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(WreckingMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n									Wrecking Ball(Level %d):\n \nLevel 1:\n(Charge) +100 melee dmg per level\n+10 max health per level\n \nLevel 5:\nOn SI headshot w/ melee weapon & Wrecking Ball charged:\nInstantly recharge Wrecking Ball\n(Charge) +1 health regen every 0.75 seconds\n \n \nSkill Uses:\n(Charge) Melee dmg bonus: Hold [CROUCH] to power up\n(Charge) Melee dmg bonus expelled on next [MELEE] against SI\n(Charge) HP regen: Hold [CROUCH] to heal yourself\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iWreckingLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Spray n' Pray
Action:SprayMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Spray[iClient] = WriteParticle(iClient, "md_coach_spray", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(SprayMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=\n \n			Spray n' Pray(Level %d):\n \nLevel 1:\n+2 shotgun clip size per level\n+2 shotgun pellet damage per level\n \n=	=	=	=	=	=	=	=	=	=	=",  g_iSprayLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Homerun
Action:HomerunMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Homerun[iClient] = WriteParticle(iClient, "md_coach_homerun", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(HomerunMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=\n \n				Homerun!(Level %d):\n \nLevel 1:\nOn SI headshot with melee weapon:\n+5%% speed per level for 10 seconds\n \n(Stacks) +2 melee damage per level\n \nLevel 5:\nNo melee fatigue\n \n \nSkill Uses:\n+1 (Stack) when decapitating infected\nMax 50 stacks\n \n=	=	=	=	=	=	=	=	=	=	=",  g_iHomerunLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Lead by Example
Action:LeadMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Lead[iClient] = WriteParticle(iClient, "md_coach_lead", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(LeadMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Lead by Example(Level %d):\n					Requires Level 11\n \nLevel 1:\n(Team) +10%% chainsaw fuel per level\n(Stacks) (Team) +5 max health per level\n \nLevel 5:\n(Team) Prevent screen shaking on damage\n \n \n				 Bind 1: Heavy Gunner\n				+1 use every other level\n \nLevel 1:\nDeploy Turrets\n \n \nSkill Uses:\n(Team) max health (Stacks) with itself\n \n=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iLeadLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Strong Arm
Action:StrongMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Coach_Strong[iClient] = WriteParticle(iClient, "md_coach_strong", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(StrongMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Strong Arm(Level %d):\n					 Requires Level 26\n \nLevel 1:\n+30 melee damage per level\n+10 max health per level\n+20%% Jockey resistance per level\nStart the round with grenades\n \nLevel 2:\n+1 bomb storage every other level\n [WALK+ZOOM] to cycle grenades\n \n \n			Bind 2: D.E.A.D. Jetpack (Charge)\n						Limited Fuel\n \nLevel 1:\n+160 fuel per level\n \n \nSkill Uses:\n(Charge): Hold [WALK] to fly when jetpack is on\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iStrongLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Nick Menu Handler
CoachMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 7: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}

//Bull Training Handler
BullMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
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
WreckingMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
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
SprayMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
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
HomerunMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
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
LeadMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
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
StrongMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
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