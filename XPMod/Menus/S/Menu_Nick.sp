//Nick Menu////////////////////////////////////////////////////////////////

//Nick Menu Draw
Action:NickMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(NickMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	FormatEx(text, sizeof(text), "Level %d   XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Nick's Medic Talents\n ", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Swindler", g_iSwindlerLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Leftover Supplies", g_iLeftoverLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Risky Business", g_iRiskyLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Enhanced Pain Killers", g_iEnhancedLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Magnum Stampede (Bind 1)", g_iMagnumLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Desperate Measures (Bind 2)         \n ", g_iDesperateLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option6", text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Detailed Talent Descriptions \n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Back\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Swindler
Action:SwindlerMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Swindler[iClient] = WriteParticle(iClient, "md_nick_swindler", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(SwindlerMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n						Swindler(Level %d):\n \nLevel 1:\n+3 max health per level when ally uses a kit (max +100)\n+1 life stealing recovery every other level\n+1 life stealing damage every level\n \n \nSkill Uses:\nLife stealing ticks every second for 5 seconds\nLife stealing only affects SI\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iSwindlerLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Leftover Supplies
Action:LeftoverMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Leftover[iClient] = WriteParticle(iClient, "md_nick_leftover", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(LeftoverMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n							Leftover Supplies(Level %d):\n \nLevel 1:\n+15%%%% chance to spawn items when you use a medkit per level\n \nLevel 5:\n [ZOOM] with a kit to destroy it and gain:\n1 random weapon\n1 random grenade\1 shot or pills\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iSkillPoints[iClient], g_iLeftoverLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Risky Business
Action:RiskyMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Risky[iClient] = WriteParticle(iClient, "md_nick_risky", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(RiskyMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=\n \n	Risky Business(Level %d):\n \nAll upgrades are (p220 & Glock):\n \nLevel 1:\n+20%%%% reload speed per level\n+20%%%% damage per level\n+6 clip size per level\n \nLevel 5:\n [WALK+ZOOM] cycle to dual pistols\nYou can cycle back to Magnums\n \n=	=	=	=	=	=	=	=	=",  g_iRiskyLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Enhanced Pain Killers
Action:EnhancedMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Enhanced[iClient] = WriteParticle(iClient, "md_nick_enhanced", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(EnhancedMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Enhanced Pain Killers(Level %d):\n \nLevel 1:\n+6 temp health from pills & shots per level\nRecover +1 health per level when anyone uses shots & pills (+8 at max)\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iEnhancedLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Magnum Stampede
Action:MagnumMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Magnum[iClient] = WriteParticle(iClient, "md_nick_magnum", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(MagnumMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=\n \n			Magnum Stampede(Level %d):\n			    Requires Level 11\n \nLevel 1:\n-5 clip size(Magnum Only)\n+75%%%% damage per level (Magnum Only)\n+3%%%% movement speed per level\n \nLevel 5:\n50% faster reload on 3 consecutive hits (Magnum only)\n \n			Bind 1: Gambling Problem\n			+1 use every other level\n \nLevel 1:\nGamble for one of eleven random effects  \n \n=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iMagnumLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	//SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=	=\n \n			Risky Business(Level %d):\n \nAll upgrades are (Pistol Only):\n \nLevel 1:\n+10%% reload speed per level\n+10 damage per level\n+6 clip size per level\n \n \n"
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Desperate Measures
Action:DesperateMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Nick_Desperate[iClient] = WriteParticle(iClient, "md_nick_desperate", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(DesperateMenuHandler);
	
	FormatEx(text, sizeof(text), "=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Desperate Measures(Level %d):\n					  Requires Level 26\n \nLevel 1:\n(Stacks) +2%%%% speed & +5%%%% gun damage per level\n \n \n				Bind 2: Cheating Death\n				+1 use every other level\n \nLevel 1:\nHeal team +4 health per level; 1 use\nLevel 3:\nRevive incapped ally; 2 uses\nLevel 5:\nResurrect an ally; 3 uses\n \n \nSkill Uses:\n+1 (Stack) when ally incaps or dies\n-1 (Stack) if ally recovers\nMax 3 stacks\n \n=	=	=	=	=	=	=	=	=	=	=	=	=",  g_iDesperateLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Nick Menu Handler
NickMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Swindler
			{
				SwindlerMenuDraw(iClient);
			}
			case 1: //Leftover Supplies
			{
				LeftoverMenuDraw(iClient);
			}
			case 2: //Risky Business
			{
				RiskyMenuDraw(iClient);
			}
			case 3: //Enhanced Pain Killers
			{
				EnhancedMenuDraw(iClient);
			}
			case 4: //Magnum Stampede
			{
				MagnumMenuDraw(iClient);
			}
			case 5: //Desperate Measures
			{
				DesperateMenuDraw(iClient);
			}
			case 6: //Detailed Talent Descriptions
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/survivors/ceda%20files/nick/xpmod_ig_talents_survivors_nick.html", MOTDPANEL_TYPE_URL);
				NickMenuDraw(iClient);
			}
			case 7: //Back
			{
				TopSurvivorMenuDraw(iClient);
			}
		}
	}
}

//Swindler Handler
SwindlerMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Leftover Supplies Handler
LeftoverMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Risky Business Handler
RiskyMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Enhanced Pain Killers Handler
EnhancedMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Magnum Stampede Handler
MagnumMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Desperate Measures Handler
DesperateMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}