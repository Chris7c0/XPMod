//Nick Menu////////////////////////////////////////////////////////////////

//Nick Menu Draw
public Action:NickMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(NickMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	FormatEx(text, sizeof(text), "Level %d   XP: %d/%d   Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Nick's Medic Talents\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
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
	
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Level Up All Talents \n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Detailed Talent Descriptions \n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Level Up All Question for Nick
public Action:LevelUpAllNickFunc(iClient) 
{
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(LevelUpAllNickHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Are you sure you want to use all your skillpoints to level up talents for Nick?\n \n");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Yes");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "No");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Swindler
public Action:SwindlerMenuDraw(iClient) 
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
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n						Swindler(Level %d):\n \nLevel 1:\n+3 max health per level when ally uses a kit (max +100)\n+1 life stealing recovery every other level\n+1 life stealing damage every level\n \n \nSkill Uses:\nLife stealing ticks every second for 5 seconds\nLife stealing only affects SI\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iSwindlerLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level Down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Leftover Supplies
public Action:LeftoverMenuDraw(iClient) 
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
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n							Leftover Supplies(Level %d):\n \nLevel 1:\n+15%%%% chance to spawn items when you use a medkit per level\n \nLevel 5:\n[ZOOM] with a kit to destroy it and gain:\n1 random weapon\n1 random grenade\1 shot or pills\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=", g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iLeftoverLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level Down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Risky Business
public Action:RiskyMenuDraw(iClient) 
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
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=\n \n	Risky Business(Level %d):\n \nAll upgrades are (p220 & Glock):\n \nLevel 1:\n+20%%%% reload speed per level\n+20%%%% damage per level\n+6 clip size per level\n \nLevel 5:\n[WALK+ZOOM] cycle to dual pistols\nYou can cycle back to Magnums\n \n=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iRiskyLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level Down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Enhanced Pain Killers
public Action:EnhancedMenuDraw(iClient) 
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
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Enhanced Pain Killers(Level %d):\n \nLevel 1:\n+6 temp health from pills & shots per level\nRecover +1 health per level when anyone uses shots & pills (+8 at max)\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iEnhancedLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level Down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Magnum Stampede
public Action:MagnumMenuDraw(iClient) 
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
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=\n \n			Magnum Stampede(Level %d):\n			    Requires Level 11\n \nLevel 1:\n-5 clip size(Magnum Only)\n+75%%%% damage per level (Magnum Only)\n+3%%%% movement speed per level\n \nLevel 5:\n50% faster reload on 3 consecutive hits (Magnum only)\n \n			Bind 1: Gambling Problem\n			+1 use every other level\n \nLevel 1:\nGamble for one of eleven random effects  \n \n=	=	=	=	=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iMagnumLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	//SetMenuTitle(g_hMenu_XPM[iClient], "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=\n \n			Risky Business(Level %d):\n \nAll upgrades are (Pistol Only):\n \nLevel 1:\n+10%% reload speed per level\n+10 damage per level\n+6 clip size per level\n \n \n"
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level Down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Desperate Measures
public Action:DesperateMenuDraw(iClient) 
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
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Desperate Measures(Level %d):\n					  Requires Level 26\n \nLevel 1:\n(Stacks) +2%%%% speed & +5%%%% gun damage per level\n \n \n				Bind 2: Cheating Death\n				+1 use every other level\n \nLevel 1:\nHeal team +4 health per level; 1 use\nLevel 3:\nRevive incapped ally; 2 uses\nLevel 5:\nResurrect an ally; 3 uses\n \n \nSkill Uses:\n+1 (Stack) when ally incaps or dies\n-1 (Stack) if ally recovers\nMax 3 stacks\n \n=	=	=	=	=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iDesperateLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level Down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Handlers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Level Up All for Nick
public LevelUpAllNickHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				LevelUpAllNick(iClient);
				NickMenuDraw(iClient);
			}
			case 1: //No
			{
				NickMenuDraw(iClient);
			}
		}
	}
}


LevelUpAllNick(iClient)
{
	if(g_iChosenSurvivor[iClient] != 4)
		g_iChosenSurvivor[iClient] = 4;
	ResetSkillPoints(iClient,iClient);
	if(g_iSkillPoints[iClient]>0)
	{
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iSwindlerLevel[iClient] += 5;
		}
		else
		{
			g_iSwindlerLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iLeftoverLevel[iClient] += 5;
		}
		else
		{
			g_iLeftoverLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iRiskyLevel[iClient] += 5;
		}
		else
		{
			g_iRiskyLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iEnhancedLevel[iClient] += 5;
		}
		else
		{
			g_iEnhancedLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iMagnumLevel[iClient] += 5;
		}
		else
		{
			g_iMagnumLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iDesperateLevel[iClient] += 5;
		}
		else
		{
			g_iDesperateLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		PrintToChat(iClient, "\x03[XPMod] \x01All your skillpoints have been assigned to Nick.");
	}
	else
		PrintToChat(iClient, "\x03[XPMod] \x01You dont have any skillpoints.");
}

//Nick Menu Handler
public NickMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
			case 6: //Level Up All
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == NICK)
					LevelUpAllNickFunc(iClient);
				else
				{
					NickMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 7: //Detailed Talent Descriptions
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/survivors/ceda%20files/nick/xpmod_ig_talents_survivors_nick.html", MOTDPANEL_TYPE_URL);
				NickMenuDraw(iClient);
			}
			case 8: //Back
			{
				ClassMenuDraw(iClient);
			}
		}
	}
}

//Swindler Handler
public SwindlerMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iChosenSurvivor[iClient] == NICK)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iSwindlerLevel[iClient] <=4)
							{
								g_iSkillPoints[iClient]--;
								g_iSwindlerLevel[iClient]++;
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
								PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						SwindlerMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 4);
						PrintToChat(iClient, "\x03[XPMod] You dont have Nick selected.");
					}
				}
				else
				{
					SwindlerMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{
				if(g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iSwindlerLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iSwindlerLevel[iClient]--;
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Nick selected.");
				
				SwindlerMenuDraw(iClient);
			}
			case 2: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Leftover Supplies Handler
public LeftoverMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iChosenSurvivor[iClient] == NICK)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iLeftoverLevel[iClient] <=4)
							{
								g_iSkillPoints[iClient]--;
								g_iLeftoverLevel[iClient]++;
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
								PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						LeftoverMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 4);
						PrintToChat(iClient, "\x03[XPMod] You dont have Nick selected.");
					}
				}
				else
				{
					LeftoverMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{
				if(g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iLeftoverLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iLeftoverLevel[iClient]--;
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Nick selected.");
				
				LeftoverMenuDraw(iClient);
			}
			case 2: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Risky Business Handler
public RiskyMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iChosenSurvivor[iClient] == NICK)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iRiskyLevel[iClient] <=4)
							{
								g_iSkillPoints[iClient]--;
								g_iRiskyLevel[iClient]++;
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
							PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						RiskyMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 4);
						PrintToChat(iClient, "\x03[XPMod] You dont have Nick selected.");
					}
				}
				else
				{
					RiskyMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{
				if(g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iRiskyLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iRiskyLevel[iClient]--;
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Nick selected.");
				
				RiskyMenuDraw(iClient);
			}
			case 2: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Enhanced Pain Killers Handler
public EnhancedMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iChosenSurvivor[iClient] == NICK)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iEnhancedLevel[iClient] <=4)
							{
								g_iSkillPoints[iClient]--;
								g_iEnhancedLevel[iClient]++;
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
								PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						EnhancedMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 4);
						PrintToChat(iClient, "\x03[XPMod] You dont have Nick selected.");
					}
				}
				else
				{
					EnhancedMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{
				if(g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iEnhancedLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iEnhancedLevel[iClient]--;
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Nick selected.");
				
				EnhancedMenuDraw(iClient);
			}
			case 2: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Magnum Stampede Handler
public MagnumMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iChosenSurvivor[iClient] == NICK)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iMagnumLevel[iClient] <=4)
							{
								if(g_iClientLevel[iClient] > 10 + g_iMagnumLevel[iClient])
								{
									g_iSkillPoints[iClient]--;
									g_iMagnumLevel[iClient]++;
									/*
									if(g_bGameFrozen ==  false)
										SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iMagnumLevel[iClient] * 0.03)), true);
									*/
								}
								else
									PrintToChat(iClient, "\x03[XPMod] \x05You must be \x04level %d \x05to level up this talent.", (11 + g_iMagnumLevel[iClient]));
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
								PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						MagnumMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 4);
						PrintToChat(iClient, "\x03[XPMod] You dont have Nick selected.");
					}
				}
				else
				{
					MagnumMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{					
				if(g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iMagnumLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iMagnumLevel[iClient]--;
							/*
							if(g_bGameFrozen == false)
								SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iMagnumLevel[iClient] * 0.03)), true);
							*/
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Nick selected.");
				
				MagnumMenuDraw(iClient);
			}
			case 2: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}

//Desperate Measures Handler
public DesperateMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if (action==MenuAction_Select ) 
	{
		switch(itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iChosenSurvivor[iClient] == NICK)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iDesperateLevel[iClient] <=4)
							{
								if(g_iClientLevel[iClient] > 25 + g_iDesperateLevel[iClient])
								{
									g_iSkillPoints[iClient]--;
									g_iDesperateLevel[iClient]++;
								}
								else
									PrintToChat(iClient, "\x03[XPMod] \x05You must be \x04level %d \x05to level up this talent.", (26 + g_iDesperateLevel[iClient]));
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
								PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						DesperateMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 4);
						PrintToChat(iClient, "\x03[XPMod] You dont have Nick selected.");
					}
				}
				else
				{
					DesperateMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{
				if(g_iChosenSurvivor[iClient] == NICK)
				{
					if(g_iDesperateLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iDesperateLevel[iClient]--;
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Nick selected.");
				
				DesperateMenuDraw(iClient);
			}
			case 2: //Back
			{
				NickMenuDraw(iClient);
			}
		}
	}
}