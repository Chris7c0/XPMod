//Ellis Menu////////////////////////////////////////////////////////////////

//Ellis Menu Draw
Action:EllisMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(EllisMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "%sLevel %d	XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n			Ellis's Weapons Expert Talents\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, text);
	
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

	decl String:strFinalOptionText[250];
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
Action:OverMenuDraw(iClient) 
{
	decl String:text[512];

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
		%s 					Overconfidence (Level %d):\
		\n \
		\nLevel 1:\
		\n+4 pill & shot health per level\
		\n+8%%%% reload speed per level\
		\n(Stacks) (Team) +2 seconds adrenaline duration per level\
		\nIf within 30 points of max health:\
		\n+2%%%% speed && +5%%%% damage to all guns per level\
		\n \
		\n \
		\nSkill Uses:\
		\nAdrenaline (Stacks) with itself\
		\nUnlimited stacks\
		\n ",
		strStartingNewLines,
		g_iOverLevel[iClient]);
	SetMenuTitle(menu, text);

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Bring the Pain!
Action:BringMenuDraw(iClient) 
{
	decl String:text[512];

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
		%s		Bring the Pain!(Level %d):\
		\n \
		\nOn Special Infected kill:\
		\n \
		\nLevel 1:\
		\nRegen +1 temp health per level\
		\n+20 clip ammo per level\
		\n(Stacks) +1%%%% movement speed\
		\n \
		\n \
		\nSkill Uses:\
		\n+4 max (Stacks) per level\
		\n ",
		strStartingNewLines,
		g_iBringLevel[iClient]);
	SetMenuTitle(menu, text);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Weapons Training
Action:WeaponsMenuDraw(iClient) 
{
	decl String:text[512];

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
		\n+10%%%% reload speed per level\
		\n(Team) +8%%%% laser accuracy per level\
		\n \
		\nLevel 5:\
		\nAutomatic laser sight\
		\nEllis can carry 2 primary weapons\
		\n [WALK+ZOOM] to cycle weapons\
		\n ",
		strStartingNewLines,
		g_iWeaponsLevel[iClient]);
	SetMenuTitle(menu, text);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Jammin' to the Music
Action:JamminMenuDraw(iClient) 
{
	decl String:text[512];

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
		\nOn Tank spawn:\
		\n \
		\nLevel 1:\
		\n+1%%%% movement speed per level\
		\n+5 temp health per level\
		\n \
		\nLevel 5:\
		\nGain a molotov\
		\n ",
		strStartingNewLines,
		g_iJamminLevel[iClient]);
	SetMenuTitle(menu, text);
	
	decl String:strFinalOptionText[250];
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
Action:MetalMenuDraw(iClient) 
{
	decl String:text[512];

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
		\n					Requires Level 11\
		\n \
		\nLevel 1:\
		\n+4 clip size per level (SMG/Rifle/Sniper only)\
		\n+7%%%% firing rate per level\
		\n+8%%%% reload speed per level\
		\n \
		\nLevel 5:\
		\n [WALK+USE] Double firing rate for 5 seconds\
		\nDestroys weapon after\
		\n \
		\n \
		\n					Bind 1: Ammo Refill\
		\n				+1 use every other level\
		\n \
		\nLevel 1:\
		\nDeploy an ammo stash\
		\n ",
		strStartingNewLines,
		g_iMetalLevel[iClient]);
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

//Fire Storm
Action:FireMenuDraw(iClient) 
{
	decl String:text[512];
	
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
		\n						Requires Level 26\
		\n \
		\nLevel 1:\
		\n+6 clip size per level (SMG/Rifle/Sniper only)\
		\n+10%%%% reload speed per level\
		\n+7%%%% firing rate per level\
		\nFire immunity\
		\n \
		\n \
		\n			Bind 2: Summon Kagu-Tsuchi's Wrath\
		\n						+1 use every other level\
		\n \
		\nLevel 1: +6 seconds of incendiary attacks\
		\nand burn duration per level\
		\nBurning a calm Witch\
		\nimmediately neutralizes her\
		\n ",
		strStartingNewLines,
		g_iFireLevel[iClient]);
	SetMenuTitle(menu, text);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Ellis Menu Handler
EllisMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
OverMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
BringMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
WeaponsMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
JamminMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
MetalMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
FireMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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