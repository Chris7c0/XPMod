//Ellis Menu////////////////////////////////////////////////////////////////

//Ellis Menu Draw
Action EllisMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(EllisMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "%sLevel %d	XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n			Ellis's Weapons Expert Talents\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, "%s", text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Overconfidence", g_iOverLevel[iClient]);
	AddMenuItem(menu, "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Bring the Pain!", g_iBringLevel[iClient]);
	AddMenuItem(menu, "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Jammin' to the Music", g_iJamminLevel[iClient]);
	AddMenuItem(menu, "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Weapons Training", g_iWeaponsLevel[iClient]);
	AddMenuItem(menu, "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Mechanic Affinity (Bind 1)                ", g_iMetalLevel[iClient]);
	AddMenuItem(menu, "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Fire Storm (Bind 2)\n ", g_iFireLevel[iClient]);
	AddMenuItem(menu, "option6", text);
	
	AddMenuItem(menu, "option7", "Open In Website\n ");
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

//Overconfidence
Action OverMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Ellis_Over[iClient] = WriteParticle(iClient, "md_ellis_over", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(OverMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s 		  Overconfidence (Level %d):\
		\n \
		\nMax Health Reduced by 10 HP\
		\nMax Temp Health is 125 HP\
		\nPills Only Heal 15 HP\
		\nStart With An Extra Shot\
		\n \
		\nIf Within %i Points Of Max Health:\
		\n	+1%%%% Movement Speed\
		\n	+5%%%% RoF To All Guns per Level\
		\n \
		\nWhile On Adrenaline:\
		\n	+5 Temp Health per Level\
		\n	+10%%%% RoF To All Guns per Level\
		\n	(Team) +2 Seconds Duration per Level   \
		\n		- Stacks with every Ellis\
		\n \
		\n ",
		strStartingNewLines,
		g_iOverLevel[iClient],
		ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT);
	SetMenuTitle(menu, "%s", text);

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Bring the Pain!
Action BringMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Ellis_Bring[iClient] = WriteParticle(iClient, "md_ellis_bring", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(BringMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s			  Bring the Pain!(Level %d):\
		\n \
		\nAll Health Is Converted To Temp Health\
		\n \
		\nStart With A Self Revive Kit\
		\n \
		\n+1 Adrenaline Shot on Self Revive Kit Use\
		\n \
		\nOn Special Infected kill:\
		\n	Regen +1 Temp Health per Level\
		\n	+8 Clip Ammo per Level\
		\n	+1%%%% Movement Speed (Stacks)\
		\n		+2 Max Stacks per Level\
		\n ",
		strStartingNewLines,
		g_iBringLevel[iClient]);
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

//Jammin' to the Music
Action JamminMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Ellis_Jammin[iClient] = WriteParticle(iClient, "md_ellis_jammin", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(JamminMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s		Jammin' to the Music (Level %d):\
		\n \
		\n Stash Up To %i Extra Adrenaline Shots\
		\n	- Stash Up To %i On Tank Spawned Shots    \
		\n \
		\n On Tank Spawn:\
		\n \
		\n	Level 1:\
		\n	+1%%%% Movement Speed per Level\
		\n \
		\n	Level 5:\
		\n	+1 Adrenaline Shot\
		\n	+1 Molotov\
		\n ",
		strStartingNewLines,
		g_iJamminLevel[iClient],
		ELLIS_STASHED_INVENTORY_MAX_ADRENALINE,
		ELLIS_STASHED_INVENTORY_MAX_TANK_SPAWN_ADRENALINE);
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

//Weapons Training
Action WeaponsMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Ellis_Weapons[iClient] = WriteParticle(iClient, "md_ellis_weapons", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(WeaponsMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
		
	FormatEx(text, sizeof(text), "\
		%s		Weapons Training (Level %d):\
		\n \
		\nLevel 1:\
		\n+15%%%% Reload Speed per Level\
		\n(Team) +8%%%% Laser Accuracy per Level\
		\n \
		\nLevel 5:\
		\nAutomatic Laser Sight\
		\nEllis Can Carry 2 Primary Weapons\
		\n [WALK+ZOOM] To Cycle Weapons\
		\n ",
		strStartingNewLines,
		g_iWeaponsLevel[iClient]);
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

//Metal Storm (Mechanic Affinity)
Action MetalMenuDraw(int iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Ellis_Bring[iClient] = WriteParticle(iClient, "md_ellis_mechanic", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(MetalMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s				Mechanic Affinity (Level %d):\
		\n \
		\nLevel 1:\
		\n Can No Longer Hold Melee Weapons\
		\n +5%%%% Firing Rate per Level\
		\n All Guns Are Automatic Now\
		\n	- Excludes Snipers\
		\n \
		\nLevel 5:\
		\n [WALK+USE] Triple Firing Rate for 5 Seconds\
		\n	- Destroys Weapon After\
		\n \
		\n \
		\n					Bind 1: Ammo Refill\
		\n				+1 Use Every Other Level\
		\n \
		\nDeploy An Ammo Stash\
		\nInstantly Refill All Survivors Ammo\
		\n ",
		strStartingNewLines,
		g_iMetalLevel[iClient]);
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

//Fire Storm
Action FireMenuDraw(int iClient) 
{
	char text[512];
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Ellis_Fire[iClient] = WriteParticle(iClient, "md_ellis_fire", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(FireMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s						Fire Storm(Level %d):\
		\n \
		\nEllis Can Carry and Starts With +1 Molotov\
		\n+10 Clip Size per Level (SMG/Rifle/Sniper Only)\
		\nFire Immunity\
		\n \
		\n \
		\n			Bind 2: Summon Kagu-Tsuchi's Wrath\
		\n						+1 Use Every Other Level\
		\n \
		\nTemporarily Grants Ellis Incendiary\
		\nAttacks With All Weapons\
		\n	+3 Sec Duration Added per Level\
		\nBurning A Calm Witch\
		\nImmediately Neutralizes Her\
		\n ",
		strStartingNewLines,
		g_iFireLevel[iClient]);
	SetMenuTitle(menu, "%s", text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Ellis Menu Handler
void EllisMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Overconfidence
			{
				OverMenuDraw(iClient);
			}
			case 1: //Bring the Pain!
			{
				BringMenuDraw(iClient);
			}
			case 2: //Jammin to the Music
			{
				JamminMenuDraw(iClient);
			}
			case 3: //Weapons Training
			{
				WeaponsMenuDraw(iClient);
			}
			case 4: //Mechanic Affinity
			{
				MetalMenuDraw(iClient); //uses metal for mechanic affinity
			}
			case 5: //Fire Storm
			{
				FireMenuDraw(iClient);
			}
			case 6: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/survivors/ceda%20files/ellis/xpmod_ig_talents_survivors_ellis.html", MOTDPANEL_TYPE_URL);
				EllisMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}

//Overconfidence Handler
void OverMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
				EllisMenuDraw(iClient);
            }
        }
    }
}

//Bring the Pain Handler
void BringMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
				EllisMenuDraw(iClient);
            }
        }
    }
}

//Jammin to the Music Handler
void JamminMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
				EllisMenuDraw(iClient);
            }        
        }
    }
}

//Weapons Training Handler
void WeaponsMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
				EllisMenuDraw(iClient);
            }           
        }
    }
}

//Metal Storm Handler and Mechanic Affinity
void MetalMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
				EllisMenuDraw(iClient);
            }
        }
    }
}

//Fire Storm Handler
void FireMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
				EllisMenuDraw(iClient);
            }
        }
    }
}
