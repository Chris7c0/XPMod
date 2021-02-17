//Louis Menu////////////////////////////////////////////////////////////////

//Louis Menu Draw
Action:LouisMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(LouisMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	FormatEx(text, sizeof(text), "Level %d   XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=\n \n			Louis's Disruptor Talents\n ", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Manager's Prep", g_iLouisTalent1Level[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	9mm Augmentation", g_iLouisTalent2Level[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Time Dilation", g_iLouisTalent3Level[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	BOOM HEADSHOT!", g_iLouisTalent4Level[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Explosivo (Bind 1)                  ", g_iLouisTalent5Level[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	PILLS HERE! (Bind 2)\n ", g_iLouisTalent6Level[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option6", text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Open In Website\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Back\n \n=	=	=	=	=	=	=	=	=	=	=	=\n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//LouisTalent1MenuDraw
Action:LouisTalent1MenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	g_hMenu_XPM[iClient] = CreateMenu(LouisTalent1MenuHandler);
	
	FormatEx(text, sizeof(text), 
		"=	=	=	=	=	=	=	=	=	=	=	=\
		\n \
		\n 		Manager's Prep (Level %d):\
		\n \
		\n +10 HP per Level\
		\n +2%\% Movement Speed per Level\
		\n SMG and Pistol (Not Magnum) Buffs:     \
		\n 	- +15\% Reload Speed per Level\
		\n \
		\n=	=	=	=	=	=	=	=	=	=	=	=",  g_iLouisTalent1Level[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//LouisTalent2MenuDraw
Action:LouisTalent2MenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	g_hMenu_XPM[iClient] = CreateMenu(LouisTalent2MenuHandler);
	
	FormatEx(text, sizeof(text), 
		"=	=	=	=	=	=	=	=	=	=	=	=	=\
		\n \
		\n 		9mm Augmentation (Level %d):\
		\n \
		\n SMG and Pistol (Not Magnum) Buffs:\
		\n 	- +30%% Damage per Level\
		\n 	- +10 Clip Size per Level\
		\n 	- Automatic Laser Sight (SMGs Only)         \
		\n \
		\n=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iLouisTalent2Level[iClient]);
	
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//LouisTalent3MenuDraw
Action:LouisTalent3MenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	g_hMenu_XPM[iClient] = CreateMenu(LouisTalent3MenuHandler);
	
	FormatEx(text, sizeof(text), 
		"=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\
		\n \
		\n 						Time Dilation (Level %d):\
		\n \
		\n [Press DIRECTION + Tap WALK] Move 30 ft in any direction.\
		\n   - +1 Use per level. Uses regenerate over time.\
		\n   - +1 Overload Use. Causes a much longer cooldown period.\
		\n   - Progressively blinds you with each use. Fades away over time.     \
		\n   - Cannot move through walls. Cannot go through CI or SI.\
		\n   - Travel less distance while severely hurt and limping.\
		\n \
		\n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iLouisTalent3Level[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//LouisTalent4MenuDraw
Action:LouisTalent4MenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	g_hMenu_XPM[iClient] = CreateMenu(LouisTalent4MenuHandler);
	
	FormatEx(text, sizeof(text), 
		"=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	= 	=\
		\n \
		\n 					BOOM HEADSHOT! (Level %d):\
		\n \
		\n +30% Headshot Damage Multiplier per Level\
		\n Headshot Kill Bonuses:\
		\n 	- CI: +1 HP, +1%% Speed for 20 Seconds, +2 Clip Ammo per Level\
		\n 	- SI: +5 HP, +5%% Speed for 20 Seconds, +10 Clip Ammo per Level      \
		\n \
		\n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iLouisTalent4Level[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//LouisTalent5MenuDraw
Action:LouisTalent5MenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	g_hMenu_XPM[iClient] = CreateMenu(LouisTalent5MenuHandler);
	
	FormatEx(text, sizeof(text), 
		"=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\
		\n \
		\n 					Explosivo (Level %d):\
		\n \
		\n COMING SOON                                                           \
		\n \
		\n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iLouisTalent5Level[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//LouisTalent6MenuDraw
Action:LouisTalent6MenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	// DeleteAllMenuParticles(iClient);
	// if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	// {
	// 	g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
	// 	g_bShowingVGUI[iClient] =  true;
	// }
	
	g_hMenu_XPM[iClient] = CreateMenu(LouisTalent6MenuHandler);
	
	FormatEx(text, sizeof(text), 
		"=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\
		\n \
		\n 					PILLS HERE! (Level %d):\
		\n \
		\n COMING SOON                                                           \
		\n \
		\n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iLouisTalent6Level[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Louis Menu Handler
LouisMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 7: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}

//LouisTalent1 Menu Handler
LouisTalent1MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if( action == MenuAction_Select )
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
LouisTalent2MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if( action == MenuAction_Select )
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
LouisTalent3MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if( action == MenuAction_Select )
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
LouisTalent4MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if( action == MenuAction_Select )
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
LouisTalent5MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if( action == MenuAction_Select )
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
LouisTalent6MenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if( action == MenuAction_Select )
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

