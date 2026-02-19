//Rochelle Menu Draw
Action RochelleMenuDraw(iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(RochelleMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "%sLevel %d	XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Rochelle's Ninja Talents\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Gather Intelligence", g_iGatherLevel[iClient]);
	AddMenuItem(menu, "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Hunter Killer", g_iHunterLevel[iClient]);
	AddMenuItem(menu, "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Sniper's Endurance", g_iSniperLevel[iClient]);
	AddMenuItem(menu, "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Silent Sorrow", g_iSilentLevel[iClient]);
	AddMenuItem(menu, "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Smoke and Mirrors (Bind 1)            ", g_iSmokeLevel[iClient]);
	AddMenuItem(menu, "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Shadow Ninja (Bind 2)\n ", g_iShadowLevel[iClient]);
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

//Gather Intelligence
Action GatherMenuDraw(iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Gather[iClient] = WriteParticle(iClient, "md_rochelle_gather", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(GatherMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s					Gather Intelligence(Level %d):\
		\n \
		\nLevel 1:\
		\nD.E.A.D. Infected Detection Device upgrade every level\
		\n \
		\nLevel 5:\
		\nHack the Infected communications to read their chat messages\
		\n \
		\nSkill Uses:\
		\nPress [Walk + Use] to turn on or off\
		\nDefault: [Shift + E]\		
		\n ",
		strStartingNewLines,
		g_iGatherLevel[iClient]);
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

//Hunter Killer
Action HunterMenuDraw(iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Hunter[iClient] = WriteParticle(iClient, "md_rochelle_hunter", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	Menu menu = CreateMenu(HunterMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s									Hunter Killer(Level %d):\
		\n \
		\nLevel 1:\
		\n+25 poison damage when shooting SI\
		\n+2%%%% movement speed per level\
		\n \
		\nLevel 5:\
		\nTracking rounds when shooting SI (Requires XPMod Addon File)\
		\n \
		\n \
		\nSkill Uses:\
		\nPoison damage every 5 seconds, +1 tick per level\
		\n ",
		strStartingNewLines,
		g_iHunterLevel[iClient]);
	SetMenuTitle(menu, text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Sniper's Endurance
Action SnipersEnduranceMenuDraw(iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Sniper[iClient] = WriteParticle(iClient, "md_rochelle_sniper", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	Menu menu = CreateMenu(SnipersEnduranceMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s					Sniper's Endurance(Level %d):\
		\n \
		\nLevel 1:\
		\n(Charge) Jump +1x higher per level\
		\n+2%%%% movement speed per level\
		\n \
		\nLevel 5:\
		\nNo melee fatigue\
		\n \
		\n \
		\nSkill Uses:\
		\n(Charge) Super Jump: Hold [CROUCH] to power up\
		\n(Charge) Super Jump: Expelled on next [JUMP]\
		\nFall damage immunity while super jumping\
		\n ",
		strStartingNewLines,
		g_iSniperLevel[iClient]);
	SetMenuTitle(menu, text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Silent Sorrow
Action SilentMenuDraw(iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Silent[iClient] = WriteParticle(iClient, "md_rochelle_silent", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(SilentMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s			Silent Sorrow(Level %d):\
		\n \
		\nSniper Weapon Upgrades\
		\n \
		\n AWP:\
		\n	+85%%%% Dmg per Level\
		\n	3 Round Clip\
		\n	3 SI Kills Gain: Charged Shot:\
		\n		2000 Dmg\
		\n		1 Round Clip\
		\n \
		\n Ruger Mini-14 (Hunting Rifle):\
		\n	+5%%%% Dmg per Stack (+500%%%% Max)\
		\n	Hit: Gain Stacks\
		\n	Miss: -15 Stacks\
		\n \
		\n H & K (Miliatry Rifle):\
		\n	+12% Dmg per Level\
		\n	+6 Clip Size per Level\
		\n	Ignite Enemies\
		\n \
		\n Steyr Scout:\
		\n	+100%%%% Dmg per Headshot (Max 8)     \
		\n	-5 Clip Size\
		\n ",
		strStartingNewLines,
		g_iSilentLevel[iClient]);
	SetMenuTitle(menu, text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Smoke and Mirrors
Action SmokeMenuDraw(iClient) 
{
	char text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Smoke[iClient] = WriteParticle(iClient, "md_rochelle_smoke", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	Menu menu = CreateMenu(SmokeMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s				Smoke and Mirrors(Level %d):\
		\n \
		\n +3%%%% Chance to Escape a Hold per Level     \
		\n On Break: For 5 Seconds:\
		\n	Cloak Glow & Hide Infected HUD\
		\n	+19%%%% Stealth per Level\
		\n \
		\n \
		\n					Bind 1: Rope Master\
		\n \
		\n 10 Second Max Durability (Regenerates)\
		\n +60 Feet Rope Distance per Level\
		\n [JUMP]/[CROUCH] to Climb/Descend\
		\n Fall Damage Immunity\
		\n ",
		strStartingNewLines,
		g_iSmokeLevel[iClient]);
	SetMenuTitle(menu, text);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Shadow Ninja
Action ShadowMenuDraw(iClient) 
{
	char text[512];
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Shadow[iClient] = WriteParticle(iClient, "md_rochelle_shadow", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	Menu menu = CreateMenu(ShadowMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	FormatEx(text, sizeof(text), "\
		%s				Shadow Ninja(Level %d):\
		\n \
		\n+2%%%% movement speed per level\
		\n+5 max health per level\
		\n \
		\n				Bind 2: Silent Assassin\
		\n+1 use every other level; 12 second duration\
		\n \
		\n+6%%%% movement speed per level\
		\n+30%%%% melee attack speed per level\
		\n+19%%%% stealth per level\
		\nHide glow from SI\
		\nGain a Katana\
		\n ",
		strStartingNewLines,
		g_iShadowLevel[iClient]);
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

//Rochelle'sMenu Handler
RochelleMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Gather Intelligence
			{
				GatherMenuDraw(iClient);
			}
			case 1: //Hunter Killer
			{
				HunterMenuDraw(iClient);
			}
			case 2: //Sniper's Endurance
			{
				SnipersEnduranceMenuDraw(iClient);
			}
			case 3: //Silent Sorrow
			{
				SilentMenuDraw(iClient);
			}
			case 4: //Smoke and Mirrors
			{
				SmokeMenuDraw(iClient);
			}
			case 5: //Shadow Ninja
			{
				ShadowMenuDraw(iClient);
			}
			case 6: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/survivors/ceda%20files/rochelle/xpmod_ig_talents_survivors_rochelle.html", MOTDPANEL_TYPE_URL);
				RochelleMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}

//Gather Training Handler
GatherMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				RochelleMenuDraw(iClient);
			}
		}
	}
}

//Hunter Killer Handler
HunterMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				RochelleMenuDraw(iClient);
			}
		}
	}
}

//Sniper's Endurance Handler
SnipersEnduranceMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				RochelleMenuDraw(iClient);
			}
		}
	}
}

//Silent Handler
SilentMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				RochelleMenuDraw(iClient);
			}
		}
	}
}

//Smoke and Mirrors Handler
SmokeMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				RochelleMenuDraw(iClient);
			}
		}
	}
}

//Shadow Ninja Handler
ShadowMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
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
				RochelleMenuDraw(iClient);
			}
		}
	}
}


Action DetectionHudMenuDraw(iClient) 
{
	if(g_iClientTeam[iClient] != TEAM_SURVIVORS || g_bDrawIDD[iClient]== false || IsPlayerAlive(iClient) == false)
		return Plugin_Handled;
	
	char strDetectedText[128];
	
	Menu menu = CreateMenu(DetectionHudMenuHandler);
	SetMenuTitle(menu, "    D.E.A.D. I.D. Device %.1f\n=========================\n            WARNING!\n=========================", (1.0 + (g_iGatherLevel[iClient] * 0.2)));
	
	if(g_fDetectedDistance_Smoker[iClient] > 0.0)
		FormatEx(strDetectedText, sizeof(strDetectedText), "Smoker Detected %.0f ft.", g_fDetectedDistance_Smoker[iClient]);
	else
		FormatEx(strDetectedText, sizeof(strDetectedText), "N/A");
	AddMenuItem(menu, "option1", strDetectedText);
	
	if(g_fDetectedDistance_Boomer[iClient] > 0.0)
		FormatEx(strDetectedText, sizeof(strDetectedText), "Boomer Detected %.0f ft.", g_fDetectedDistance_Boomer[iClient]); 
	else
		FormatEx(strDetectedText, sizeof(strDetectedText), "N/A");
	AddMenuItem(menu, "option2", strDetectedText);
	
	if(g_fDetectedDistance_Hunter[iClient] > 0.0)
		FormatEx(strDetectedText, sizeof(strDetectedText), "Hunter Detected %.0f ft.", g_fDetectedDistance_Hunter[iClient]); 
	else
		FormatEx(strDetectedText, sizeof(strDetectedText), "N/A");
	AddMenuItem(menu, "option3", strDetectedText);
	
	if(g_fDetectedDistance_Spitter[iClient] > 0.0)
		FormatEx(strDetectedText, sizeof(strDetectedText), "Spitter Detected %.0f ft.", g_fDetectedDistance_Spitter[iClient]); 
	else
		FormatEx(strDetectedText, sizeof(strDetectedText), "N/A");
	AddMenuItem(menu, "option4", strDetectedText);
	
	if(g_fDetectedDistance_Jockey[iClient] > 0.0)
		FormatEx(strDetectedText, sizeof(strDetectedText), "Jockey Detected %.0f ft.", g_fDetectedDistance_Jockey[iClient]); 
	else
		FormatEx(strDetectedText, sizeof(strDetectedText), "N/A");
	AddMenuItem(menu, "option5", strDetectedText);
	
	if(g_fDetectedDistance_Charger[iClient] > 0.0)
		FormatEx(strDetectedText, sizeof(strDetectedText), "Charger Detected %.0f ft.", g_fDetectedDistance_Charger[iClient]); 
	else
		FormatEx(strDetectedText, sizeof(strDetectedText), "N/A");
	AddMenuItem(menu, "option6", strDetectedText);
	
	if(g_fDetectedDistance_Tank[iClient] > 0.0)
		FormatEx(strDetectedText, sizeof(strDetectedText), "Tank Detected! %.0f ft.\n=========================\n         TANK WARNING!\n=========================", g_fDetectedDistance_Tank[iClient]); 
	else
		FormatEx(strDetectedText, sizeof(strDetectedText), "N/A\n=========================");
	AddMenuItem(menu, "option7", strDetectedText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, 1);
		
	return Plugin_Handled;
}

DetectionHudMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Switch to Slot 1 (Primary Weapon)
			{
				ClientCommand(iClient, "slot0");
				ClientCommand(iClient, "slot1");
			}
			case 1: //Switch to Slot 2 (Secondary Weapon)
			{
				ClientCommand(iClient, "slot0");
				ClientCommand(iClient, "slot2");
			}
			case 2: //Switch to Slot 3 (Explosive Weapon)
			{
				ClientCommand(iClient, "slot0");
				ClientCommand(iClient, "slot3");
			}
			case 3: //Switch to Slot 4 (Health Slot)
			{
				ClientCommand(iClient, "slot0");
				ClientCommand(iClient, "slot4");
			}
			case 4: //Switch to Slot 5 (Boost Slot)
			{
				ClientCommand(iClient, "slot0");
				ClientCommand(iClient, "slot5");
			}
		}
	}
}
