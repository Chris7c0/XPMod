//Coach Menu////////////////////////////////////////////////////////////////

//Coach Menu Draw
Action CoachMenuDraw(int iClient)
{
	char text[512];


	Menu menu = CreateMenu(CoachMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "%sLevel %d	XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Coach's Berserker Talents\n ", strStartingNewLines,g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, "%s", text);
	
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

	char strFinalOptionText[250];
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
Action BullMenuDraw(int iClient)
{
	char text[512];



	Menu menu = CreateMenu(BullMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s			Bull Rush(Level %d):\
		\n \
		\n+5 max health per level\
		\nOn CI headshot with a melee weapon:\
		\n+5%%%% speed per level for 5 seconds\
		\n \
		\nWith Melee:\
		\n [WALK+Movement] to Dash\
		\n  - 2 Charges\
		\n \
		\n [WALK+USE] to rage! For 30 seconds:\
		\n+5%%%% speed per level\
		\n+40 melee damage per level\
		\n+1 Dash Charge\
		\nHealth regeneration\
		\n3 Minute Cooldown. During Cooldown:\
		\n-3%%%% speed per level\
		\nCoach cannot regen or speed up\
		\n ",
		strStartingNewLines,
		g_iBullLevel[iClient]);
	SetMenuTitle(menu, "%s", text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Wrecking Ball
Action WreckingMenuDraw(int iClient) 
{
	char text[512];



	Menu menu = CreateMenu(WreckingMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s						Wrecking Ball(Level %d):\
		\n \
		\n+5 Max Health per Level\
		\nHold [CROUCH] to Heal Yourself\
		\n	+1 Health Regen Every Half Second\
		\n \
		\nMelee Attacks Lunge at Nearby Infected Within Range\
		\n	All CI and SI(<30%% HP)\
		\n	[CROUCH+USE] with Melee to Toggle Off\
		\n \
		\nHold [CROUCH] to Power Up Wrecking Ball Attack:\
		\n	+100 Melee Dmg per Level Expelled on SI Hit\
		\n	On SI Melee Headshot While Wrecking Ball Active:\
		\n		- Instantly Recharge It\
		\n ",
		strStartingNewLines,
		g_iWreckingLevel[iClient]);
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

//Spray n' Pray
Action SprayMenuDraw(int iClient) 
{
	char text[512];



	Menu menu = CreateMenu(SprayMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s			Spray n' Pray(Level %d):\
		\n \
		\n+2 shotgun clip size per level\
		\n+2 shotgun pellet damage per level\
		\n \
		\n			Hotkey: CEDA JPack Mk. 6\
		\n \
		\nLevel 1:\
		\n [USE+ZOOM] to Turn On Jetpack\
		\n+%i Max Fuel per Level\
		\nWhile Jetpack Is Off, Fuel Regenerates Over Time\
		\nBlocks Bull Rush Dash\
		\n \
		\nSkill Uses:\
		\nHold [WALK] to Fly When Jetpack Is On\
		\n ",
		strStartingNewLines,
		g_iSprayLevel[iClient],
		COACH_JETPACK_FUEL_PER_LEVEL);
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

//Homerun
Action HomerunMenuDraw(int iClient) 
{
	char text[512];



	Menu menu = CreateMenu(HomerunMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s				Homerun!(Level %d):\
		\n \
		\nOn CI Decapitation with Melee Weapon:\
		\n	+1 Homerun Stack (Max 50)\
		\n	+2 Melee Damage per Level per Homerun Stack\
		\n	+1 Shotgun Clip Ammo (Until Clip Maxed)\
		\n \
		\nOn SI Decapitation with Melee Weapon:\
		\n	+5%% Speed per Level for 10 Seconds\
		\n	+10 Shotgun Clip Ammo (Until Clip Maxed)\
		\n \
		\nLevel 5:\
		\nNo Melee Fatigue\
		\n ",
		strStartingNewLines,
		g_iHomerunLevel[iClient]);
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

//Lead by Example
Action LeadMenuDraw(int iClient) 
{
	char text[512];



	Menu menu = CreateMenu(LeadMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s				Lead by Example(Level %d):\
		\n \
		\nLevel 1:\
		\n(Team) +10%%%% chainsaw fuel per level\
		\n(Team) +5 max health per level\
		\n \
		\nLevel 5:\
		\n(Team) (Stacks) Reduce screen shaking when\
		\n   taking damage by 50%%%%\
		\n \
		\n \
		\n				 Bind 1: Heavy Gunner\
		\n				+1 use every other level\
		\n \
		\nLevel 1:\
		\nDeploy Turrets\
		\n ",
		strStartingNewLines,
		g_iLeadLevel[iClient]);
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

//Strong Arm
Action StrongMenuDraw(int iClient) 
{
	char text[512];
	


	Menu menu = CreateMenu(StrongMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s					Strong Arm(Level %d):\
		\n \
		\nLevel 1:\
		\n+30 Melee Damage per Level\
		\n+5 Max Health per Level\
		\n+16%% Jockey Resistance per Level\
		\nStart The Round With A Random Explosive\
		\n \
		\nLevel 2:\
		\n+1 Explosive Storage Every Other Level\
		\n [CROUCH+RELOAD] to Cycle Explosives\
		\n ",
		strStartingNewLines,
		g_iStrongLevel[iClient]);
	SetMenuTitle(menu, "%s", text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void CoachMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
void BullMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
void WreckingMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
void SprayMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
void HomerunMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
void LeadMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
void StrongMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
