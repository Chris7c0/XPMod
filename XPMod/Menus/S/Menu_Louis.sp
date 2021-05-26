//Louis Menu////////////////////////////////////////////////////////////////

//Louis Menu Draw
Action:LouisMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(LouisMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "%sLevel %d	XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=\n \n			Louis's Disruptor Talents\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Manager's Prep", g_iLouisTalent1Level[iClient]);
	AddMenuItem(menu, "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	9mm Augmentation", g_iLouisTalent2Level[iClient]);
	AddMenuItem(menu, "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Time Dilation", g_iLouisTalent3Level[iClient]);
	AddMenuItem(menu, "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	BOOM HEADSHOT!", g_iLouisTalent4Level[iClient]);
	AddMenuItem(menu, "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Neurosurgeon (Bind 1)           ", g_iLouisTalent5Level[iClient]);
	AddMenuItem(menu, "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	PILLS HERE! (Bind 2)\n ", g_iLouisTalent6Level[iClient]);
	AddMenuItem(menu, "option6", text);
	
	AddMenuItem(menu, "option7", "Open In Website\n ");
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\n \n=	=	=	=	=	=	=	=	=	=	=	=\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//LouisTalent1MenuDraw
Action:LouisTalent1MenuDraw(iClient) 
{
	decl String:text[512];

	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	Menu menu = CreateMenu(LouisTalent1MenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s			Manager's Prep (Level %d):\
		\n \
		\n +10 HP per Level\
		\n \
		\n +3%%%%% Movement Speed per Level\
		\n 	- Louis Always Capped At +25%%%% Speed     \
		\n \
		\n SMG and Pistol (Not Magnum) Buffs:     \
		\n 	- +5%%%% Reload Speed per Level\
		\n ",
		strStartingNewLines,
		g_iLouisTalent1Level[iClient]);
	SetMenuTitle(menu, text);

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//LouisTalent2MenuDraw
Action:LouisTalent2MenuDraw(iClient) 
{
	decl String:text[512];

	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	Menu menu = CreateMenu(LouisTalent2MenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s 		9mm Augmentation (Level %d):\
		\n \
		\n SMG and Pistol (Not Magnum) Buffs:\
		\n 	- +10%%%% Damage per Level\
		\n 	- +10 Clip Size per Level\
		\n 	- Automatic Laser Sight (SMGs Only)         \
		\n ",
		strStartingNewLines,
		g_iLouisTalent2Level[iClient]);
	
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

//LouisTalent3MenuDraw
Action:LouisTalent3MenuDraw(iClient) 
{
	decl String:text[512];

	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	Menu menu = CreateMenu(LouisTalent3MenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s 						Time Dilation (Level %d):\
		\n \
		\n [Press DIRECTION + Tap WALK] Move 30 ft in any direction.    \
		\n	- +1 Use per level. Uses regenerate over time.\
		\n	- +1 Overload Use. Causes much longer cooldown period.\
		\n	- -5%%%% Speed for 20 secs after each use.\
		\n	- Progressively blinds you with each use. Fades over time.\
		\n	- Cannot move through walls, CI, or SI.\
		\n	- Travel less distance while severely hurt and limping.\
		\n ",
		strStartingNewLines,
		g_iLouisTalent3Level[iClient]);
	SetMenuTitle(menu, text);

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//LouisTalent4MenuDraw
Action:LouisTalent4MenuDraw(iClient) 
{
	decl String:text[512];

	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	Menu menu = CreateMenu(LouisTalent4MenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s 							BOOM HEADSHOT! (Level %d):\
		\n \
		\n +40%%%% Headshot Damage Multiplier per Level\
		\n \
		\n Headshot Kill Bonuses:\
		\n 	- CI: +1 HP, +1%%%% Speed for 60 Seconds, +5 Clip Ammo per Level\
		\n 	- SI: +5 HP, +5%%%% Speed for 60 Seconds, +15 Clip Ammo per Level   \
		\n 	- Louis Is Always Capped At +25%%%% Speed\
		\n ",
		strStartingNewLines,
		g_iLouisTalent4Level[iClient]);
	SetMenuTitle(menu, text);

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//LouisTalent5MenuDraw
Action:LouisTalent5MenuDraw(iClient) 
{
	decl String:text[512];

	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	Menu menu = CreateMenu(LouisTalent5MenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s 					Neurosurgeon (Level %d):\
		\n \
		\n Every Common Infected Headshot Kill Has A 5%%%% Chance To Drop:\
		\n	- Pain Pills\
		\n	- First Aid Kit\
		\n	- Molotov\
		\n	- Bile Jar\
		\n	- Pipe bomb\
		\n Every Special Infected Headshot Kill Has A 1%%%% Chance To:\
		\n	- Get %0.1f Monero (XMR)\
		\n	- Get Extra Warez Station\
		\n \
		\n Bind 1: w4R3z 574t10n u53r\
		\n \
		\n	Deploy and share your Warez with your team quickly and easily!\
		\n ",
		strStartingNewLines,
		g_iLouisTalent5Level[iClient],
		LOUIS_NEUROSURGEON_SI_XMR_REWARD_AMOUNT);
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

//LouisTalent6MenuDraw
Action:LouisTalent6MenuDraw(iClient) 
{
	decl String:text[512];
	
	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	Menu menu = CreateMenu(LouisTalent6MenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s 					PILLS HERE! (Level %d):\
		\n \
		\n Hold Up To 5 Pill Bottles At Once\
		\n \
		\n [PRESS ZOOM] While Holding A MedKit:\
		\n 	- Turn MedKit Into 3 Pill Bottles\
		\n \
		\n When Taking Pills (Stacks):\
		\n	- +1 Temp Health Per Level\
		\n	- +1%%%% Speed per Level for 60 Seconds\
		\n		- Louis Capped At +25%%%% Speed\
		\n	- +3%%%% Damage per Level for 60 Seconds  \
		\n	- 5 Stacks Max\
		\n \
		\n Bind 2: H3D 5h0p\
		\n	- Unlock 5cR1PT k1Dd13 3xPl0172 m3Nu\
		\n		+ %0.1f XMR per CI Headshot Kill\
		\n		+ %0.1f XMR per SI Headshot Kill\
		\n ",
		strStartingNewLines,
		g_iLouisTalent6Level[iClient],
		LOUIS_HEADSHOT_XMR_AMOUNT_CI,
		LOUIS_HEADSHOT_XMR_AMOUNT_SI);
	SetMenuTitle(menu, text);

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Louis Menu Handler
LouisMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0:	LouisTalent1MenuDraw(iClient);
			case 1:	LouisTalent2MenuDraw(iClient);
			case 2:	LouisTalent3MenuDraw(iClient);
			case 3:	LouisTalent4MenuDraw(iClient);
			case 4:	LouisTalent5MenuDraw(iClient);
			case 5:	LouisTalent6MenuDraw(iClient);
			case 6: //Open In Website
			{
				//OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/survivors/ceda%20files/ellis/xpmod_ig_talents_survivors_ellis.html", MOTDPANEL_TYPE_URL);
				PrintToChatAll("Unavailable for Louis...for now.");
				LouisMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}

//LouisTalent1 Menu Handler
LouisTalent1MenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				LouisMenuDraw(iClient);
            }
        }
    }
}

//LouisTalent2 Menu Handler
LouisTalent2MenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				LouisMenuDraw(iClient);
            }
        }
    }
}

//LouisTalent3 Menu Handler
LouisTalent3MenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				LouisMenuDraw(iClient);
            }
        }
    }
}

//LouisTalent4 Menu Handler
LouisTalent4MenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				LouisMenuDraw(iClient);
            }
        }
    }
}

//LouisTalent5 Menu Handler
LouisTalent5MenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				LouisMenuDraw(iClient);
            }
        }
    }
}

//LouisTalent6 Menu Handler
LouisTalent6MenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				LouisMenuDraw(iClient);
            }
        }
    }
}

