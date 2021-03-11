//Rochelle Menu Draw
Action:RochelleMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(RochelleMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	FormatEx(text, sizeof(text), "\n \nLevel %d	XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Rochelle's Ninja Talents\n ", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
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
	AddMenuItem(menu, "option9", "Back\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Gather Intelligence
Action:GatherMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Gather[iClient] = WriteParticle(iClient, "md_rochelle_gather", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(GatherMenuHandler);
	
	FormatEx(text, sizeof(text), "\
		\n \
		\n					Gather Intelligence(Level %d):\
		\n \
		\nLevel 1:\
		\nD.E.A.D. Infected Detection Device upgrade every level\
		\n \
		\n \
		\nSkill Uses:\
		\nPress [Walk + Use] to turn on or off\
		\nDefault: [Shift + E]\
		\n ",
		g_iGatherLevel[iClient]);
	SetMenuTitle(menu, text);
	
	AddMenuItem(menu, "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Hunter Killer
Action:HunterMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Hunter[iClient] = WriteParticle(iClient, "md_rochelle_hunter", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	Menu menu = CreateMenu(HunterMenuHandler);
	
	FormatEx(text, sizeof(text), "\
		\n \
		\n									Hunter Killer(Level %d):\
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
		g_iHunterLevel[iClient]);
	SetMenuTitle(menu, text);
	
	AddMenuItem(menu, "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Sniper's Endurance
Action:SnipersEnduranceMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Sniper[iClient] = WriteParticle(iClient, "md_rochelle_sniper", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	Menu menu = CreateMenu(SnipersEnduranceMenuHandler);
	
	FormatEx(text, sizeof(text), "\
		\n \
		\n					Sniper's Endurance(Level %d):\
		\n \
		\nLevel 1:\
		\n(Charge) Jump +1x higher per level\
		\n+5 max health per level\
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
		g_iSniperLevel[iClient]);
	SetMenuTitle(menu, text);
	
	AddMenuItem(menu, "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Silent Sorrow
Action:SilentMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Silent[iClient] = WriteParticle(iClient, "md_rochelle_silent", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	Menu menu = CreateMenu(SilentMenuHandler);
	
	FormatEx(text, sizeof(text), "\
		\n \
		\n			Silent Sorrow(Level %d):\
		\n \
		\nLevel 1:\
		\nSniper upgrades every level\
		\n \
		\nSee \"Open In Website\" in the\
		\nprevious menu for upgrade details\
		\n ",
		g_iSilentLevel[iClient]);
	SetMenuTitle(menu, text);
	
	AddMenuItem(menu, "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Smoke and Mirrors
Action:SmokeMenuDraw(iClient) 
{
	decl String:text[512];

	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Smoke[iClient] = WriteParticle(iClient, "md_rochelle_smoke", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	Menu menu = CreateMenu(SmokeMenuHandler);
	
	FormatEx(text, sizeof(text), "\
		\n \
		\n				Smoke and Mirrors(Level %d):\
		\n					  Requires Level 11\
		\n \
		\nLevel 1:\
		\n+5%%%% chance to escape a hold per level\
		\n \
		\nOn break for 5 seconds:\
		\nCloak glow & Hide infected HUD\
		\n+19%%%% stealth per level\
		\n \
		\n \
		\n					Bind 1: Rope Master\
		\n					30 second lifetime\
		\n \
		\nLevel 1:\
		\n+40 feet rope distance per level\
		\n \
		\n \
		\nSkill Uses:\
		\nRope:[JUMP]/[CROUCH] to climb/descend,\
		\nfall damage immunity\
		\n ",
		g_iSmokeLevel[iClient]);
	SetMenuTitle(menu, text);
	
	AddMenuItem(menu, "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Shadow Ninja
Action:ShadowMenuDraw(iClient) 
{
	decl String:text[512];
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Rochelle_Shadow[iClient] = WriteParticle(iClient, "md_rochelle_shadow", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	Menu menu = CreateMenu(ShadowMenuHandler);
	
	FormatEx(text, sizeof(text), "\
		\n \
		\n				Shadow Ninja(Level %d):\
		\n				  Requires Level 26\
		\n \
		\nLevel 1:\
		\n+2%%%% movement speed per level\
		\n+5 max health per level\
		\n \
		\n				Bind 2: Silent Assassin\
		\n+1 use every other level; 12 second duration\
		\n \
		\nLevel 1:\
		\n+10%%%% movement speed per level\
		\n+30%%%% melee attack speed per level\
		\n+19%%%% stealth per level\
		\nCloak glow from SI\
		\nGain a Katana\
		\n ",
		g_iShadowLevel[iClient]);
	SetMenuTitle(menu, text);

	AddMenuItem(menu, "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Rochelle'sMenu Handler
RochelleMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
GatherMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
HunterMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
SnipersEnduranceMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
SilentMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
SmokeMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
ShadowMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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


Action:DetectionHudMenuDraw(iClient) 
{
	if(g_iClientTeam[iClient] != TEAM_SURVIVORS || g_bDrawIDD[iClient]== false || IsPlayerAlive(iClient) == false)
		return Plugin_Handled;
	
	decl String:strDetectedText[128];
	
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

DetectionHudMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
