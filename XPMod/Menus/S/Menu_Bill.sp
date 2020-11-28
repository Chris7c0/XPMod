//Support (Bill) Menu////////////////////////////////////////////////////////////////

//Bill Menu Draw
public Action:SupportMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(SupportMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	FormatEx(text, sizeof(text), "Level %d   XP: %d/%d   Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Bill's Support Talents\n ",g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSkillPoints[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);
	
	FormatEx(text, sizeof(text), "	[Level %d]	Inspirational Leadership", g_iInspirationalLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Ghillie Tactics", g_iGhillieLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option2", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Will to Live", g_iWillLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option3", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Exorcism in a Barrel", g_iExorcismLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option4", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Die Hard (Bind 1)", g_iDiehardLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option5", text);
	FormatEx(text, sizeof(text), "	[Level %d]	Promotional Benefits (Bind 2)          \n ", g_iPromotionalLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option6", text);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Level Up All Talents	\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Detailed Talent Descriptions	\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Level Up All Question for Bill
public Action:LevelUpAllBillFunc(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(LevelUpAllBillHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Are you sure you want to use all your skill points to level up talents for Bill?\n \n");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Yes");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "No");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Inspirational Leadership Draw
public Action:InspirationalMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Inspirational[iClient] = WriteParticle(iClient, "md_bill_inspirational", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(InspirationalMenuHandler);
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Inspirational Leadership (Level %d)\n \nLevel 1:\n(Team) +10 bonus XP per level for teammates on SI kill\n(Charge) Regenerate 1 life to random ally per level\n \n \nSkill Uses:\n(Charge) HP Regeneration: Hold [CROUCH] to heal allies\nevery 6 seconds\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iInspirationalLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level Up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level Down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Ghillie Tactics
public Action:GhillieMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Ghillie[iClient] = WriteParticle(iClient, "md_bill_ghillie", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
				
	g_hMenu_XPM[iClient] = CreateMenu(GhillieMenuHandler);

	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Ghillie Tactics(Level %d):\n \nLevel 1:\n+13%%%% cloaking per level\n(Charge) +30 sprinting stamina per level\n \n \nSkill Uses:\n(Charge) sprinting stamina builds over time\nHold [WALK] to activate\nWorks while incapacitated\n \n=	=	=	=	=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iGhillieLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level Up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level Down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Will to Live Draw
public Action:WillMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Will[iClient] = WriteParticle(iClient, "md_bill_will", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(WillMenuHandler);
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Will to Live(Level %d):\n \nLevel 1:\n+5 max health per level\n+50 incap health per level\n(Team) Allow crawling\n(Stacks) (Team) +5 crawl speed per level\n \n \nSkill Uses:\nCrawl speed (Stacks) with itself\nUnlimited stacks\n \n=	=	=	=	=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iWillLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level Up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level Down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


//Exorcism in a Barrel Draw
public Action:ExorcismMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Exorcism[iClient] = WriteParticle(iClient, "md_bill_exorcism", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(ExorcismMenuHandler);
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=\n \n  Exorcism in a Barrel(Level %d):\n \nLevel 1:\n+4%%%% assault rifle damage per level\n+20%%%% reload speed per level\n \n=	=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iExorcismLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level Up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level Down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Die Hard Draw
public Action:DiehardMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Diehard[iClient] = WriteParticle(iClient, "md_bill_diehard", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(DiehardMenuHandler);
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=	=	=\n \n					Die Hard(Level %d):\n					Requires Level 11\n \nLevel 1:\n+15 max health per level\nRegen 6 health when ally incaps per level\n \n \n		Bind 1: Improvised Explosives\n			+1 use every other level\n \nLevel 1:\nDrop +1 active pipebomb every other level\n \n=	=	=	=	=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iDiehardLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Promotional Benefits Draw
public Action:PromotionalMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	
	DeleteAllMenuParticles(iClient);
	if(g_bEnabledVGUI[iClient] == true && g_iClientTeam[iClient] == TEAM_SURVIVORS && IsPlayerAlive(iClient) == true)
	{
		g_iPID_MD_Bill_Promotional[iClient] = WriteParticle(iClient, "md_bill_promotional", 0.0);
		g_bShowingVGUI[iClient] =  true;
	}
	
	g_hMenu_XPM[iClient] = CreateMenu(PromotionalMenuHandler);
	
	FormatEx(text, sizeof(text), "Level %d		Skill Points: %d\n=	=	=	=	=	=	=	=	=	=	=\n \n		Promotional Benefits(Level %d):\n			   Requires Level 26\n \nLevel 1:\n+8%%%% reload speed & cloaking per level\n+20 rifle clip size per level\n+20%%%% M60 damage per level\nAutomatic laser sight\nHide glow from SI\n \n \n				Bind 2: First Blood\n			+1 use every other level\n \nLevel 1:\nSpawn M60\n \n=	=	=	=	=	=	=	=	=	=	=",g_iClientLevel[iClient], g_iSkillPoints[iClient], g_iPromotionalLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Level up");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Level down");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Level Up All for Bill
public LevelUpAllBillHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				LevelUpAllBill(iClient);
				SupportMenuDraw(iClient);
			}
			case 1: //No
			{
				SupportMenuDraw(iClient);
			}
		}
	}
}

LevelUpAllBill(iClient)
{
	if(g_iChosenSurvivor[iClient] != 0)
		g_iChosenSurvivor[iClient] = 0;
	ResetSkillPoints(iClient,iClient);
	if(g_iSkillPoints[iClient] > 0)
	{
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iInspirationalLevel[iClient] += 5;
		}
		else
		{
			g_iInspirationalLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iGhillieLevel[iClient] += 5;
		}
		else
		{
			g_iGhillieLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iWillLevel[iClient] += 5;
		}
		else
		{
			g_iWillLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iExorcismLevel[iClient] += 5;
		}
		else
		{
			g_iExorcismLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iDiehardLevel[iClient] += 5;
		}
		else
		{
			g_iDiehardLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			g_iPromotionalLevel[iClient] += 5;
		}
		else
		{
			g_iPromotionalLevel[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
		PrintToChat(iClient, "\x03[XPMod] \x01All your skillpoints have been assigned to \x04Bill\x01.");
	}
	else
		PrintToChat(iClient, "\x03[XPMod] \x01You dont have any skillpoints.");
}

//Bill Menu Handler
public SupportMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Inspirational
			{
				InspirationalMenuDraw(iClient);
			}
			case 1: //Ghillie Tactics
			{
				GhillieMenuDraw(iClient);
			}
			case 2: //Will to Live
			{
				WillMenuDraw(iClient);
			}
			case 3: //Exorcism in a Barrel
			{
				ExorcismMenuDraw(iClient);
			}
			case 4: //Die Hard
			{
				DiehardMenuDraw(iClient);
			}
			case 5: //Promotional Benefits
			{
				PromotionalMenuDraw(iClient);
			}
			case 6: //Level Up All
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == BILL)
					LevelUpAllBillFunc(iClient);
				else
				{
					SupportMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 7: //Detailed Talent Descriptions
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/survivors/ceda%20files/bill/xpmod_ig_talents_survivors_bill.html", MOTDPANEL_TYPE_URL);
				SupportMenuDraw(iClient);
			}
			case 8: //Back
			{
				ClassMenuDraw(iClient);
			}
		}
	}
}


//Inspirational Handler
public InspirationalMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iChosenSurvivor[iClient] == BILL)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iInspirationalLevel[iClient] <=4)
							{
								g_iSkillPoints[iClient]--;
								g_iInspirationalLevel[iClient]++;
								/*
								if(g_bGameFrozen == false)
									SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0+(g_iInspirationalLevel[iClient]*0.02) + (g_iPromotionalLevel[iClient] * 0.02)), true);
								*/
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
							PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						InspirationalMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 0);
						PrintToChat(iClient, "\x03[XPMod] You don't have Bill selected.");
					}
				}
				else
				{
					InspirationalMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{
				if(g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iInspirationalLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iInspirationalLevel[iClient]--;
							/*
							if(g_bGameFrozen == false)
								SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0+(g_iInspirationalLevel[iClient]*0.02) + (g_iPromotionalLevel[iClient] * 0.02)), true);
							*/
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Bill selected.");
				
				InspirationalMenuDraw(iClient);
			}
			case 2: //Back
			{
				SupportMenuDraw(iClient);
			}
		}
	}
}

//Ghillie Tactics Menu Handler
public GhillieMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if( action == MenuAction_Select )
	{
		switch (itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iChosenSurvivor[iClient] == BILL)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iGhillieLevel[iClient] <=4 )
							{
								g_iSkillPoints[iClient]--;
								g_iGhillieLevel[iClient]++;
								if(g_bGameFrozen == false)
								{
									SetEntityRenderMode(iClient, RenderMode:3);
									SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (((float(g_iGhillieLevel[iClient]) * 0.13) + ((float(g_iPromotionalLevel[iClient]) * 0.04)))))));
								}
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
							PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						GhillieMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 0);
						PrintToChat(iClient, "\x03[XPMod] You don't have the Support Class selected.");
					}
				}
				else
				{
					GhillieMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
            {					
				if(g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iGhillieLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iGhillieLevel[iClient]--;
							if(g_bGameFrozen == false)
							{
								SetEntityRenderMode(iClient, RenderMode:3);
								SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (((float(g_iGhillieLevel[iClient]) * 0.13) + ((float(g_iPromotionalLevel[iClient]) * 0.04)))))));
								if(g_iGhillieLevel[iClient]==0 && g_iPromotionalLevel[iClient]==0)
								{
									
									SetEntityRenderMode(iClient, RenderMode:0);
									SetEntityRenderColor(iClient, 255, 255, 255, 255);
								}
							}
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Bill selected.");
				
				GhillieMenuDraw(iClient);
            }
            case 2: //Back
            {
				SupportMenuDraw(iClient);
            }
        }
    }
}


//Will to Live Handler
public WillMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iChosenSurvivor[iClient] == BILL)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iWillLevel[iClient] <=4)
							{
								g_iSkillPoints[iClient]--;
								g_iWillLevel[iClient]++;
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
							PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						WillMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 0);
						PrintToChat(iClient, "\x03[XPMod] You don't have the Support Class selected.");
					}
				}
				else
				{
					WillMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{
				if(g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iWillLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iWillLevel[iClient]--;
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Bill selected.");
				
				WillMenuDraw(iClient);
			}
			case 2: //Back
			{
				SupportMenuDraw(iClient);
			}
		}
	}
}


//Exorcism in a Barrel Handler
public ExorcismMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iChosenSurvivor[iClient] == BILL)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iExorcismLevel[iClient] <=4)
							{
								g_iSkillPoints[iClient]--;
								g_iExorcismLevel[iClient]++;
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
							PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						ExorcismMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 0);
						PrintToChat(iClient, "\x03[XPMod] You don't have the Support Class selected.");
					}
				}
				else
				{
					ExorcismMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{
				if(g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iExorcismLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iExorcismLevel[iClient]--;
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Bill selected.");
				
				ExorcismMenuDraw(iClient);
			}
			case 2: //Back
			{
				SupportMenuDraw(iClient);
			}
		}
	}
}

//Die Hard Handler
public DiehardMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iChosenSurvivor[iClient] == BILL)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iDiehardLevel[iClient] <=4)
							{
								if(g_iClientLevel[iClient] > 10 + g_iDiehardLevel[iClient])
								{
									g_iSkillPoints[iClient]--;
									g_iDiehardLevel[iClient]++;
								}
								else
									PrintToChat(iClient, "\x03[XPMod] \x05You must be \x04level %d \x05to level up this talent.", (11 + g_iDiehardLevel[iClient]));
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
							PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						DiehardMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 0);
						PrintToChat(iClient, "\x03[XPMod] You don't have the Support Class selected.");
					}
				}
				else
				{
					DiehardMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{
				if(g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iDiehardLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iDiehardLevel[iClient]--;
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Bill selected.");
				
				DiehardMenuDraw(iClient);
			}
			case 2: //Back
			{
				SupportMenuDraw(iClient);
			}
		}
	}
}

//Promotional Benefit Handler
public PromotionalMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Level up
			{
				if(g_bTalentsConfirmed[iClient] == false || g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iChosenSurvivor[iClient] == BILL)
					{
						if(g_iSkillPoints[iClient]>0)
						{
							if(g_iPromotionalLevel[iClient] <=4)
							{
								if(g_iClientLevel[iClient] > 25 + g_iPromotionalLevel[iClient])
								{
									g_iSkillPoints[iClient]--;
									g_iPromotionalLevel[iClient]++;
									/*
									if(g_bGameFrozen == false)
									{
										SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0+(g_iInspirationalLevel[iClient]*0.02) + (g_iPromotionalLevel[iClient] * 0.02)), true);
										SetEntityRenderMode(iClient, RenderMode:3);
										SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (((float(g_iGhillieLevel[iClient]) * 0.13) + ((float(g_iPromotionalLevel[iClient]) * 0.04)))))));
									}
									*/
								}
								else
									PrintToChat(iClient, "\x03[XPMod] \x05You must be \x04level %d \x05to level up this talent.", (26 + g_iPromotionalLevel[iClient]));
							}
							else
								PrintToChat(iClient, "\x03[XPMod] This talent is already maxed out.");
						}
						else
							PrintToChat(iClient, "\x03[XPMod] No skill points remaining.");
						PromotionalMenuDraw(iClient);
					}
					else
					{
						ChangeChar(iClient, 0);
						PrintToChat(iClient, "\x03[XPMod] You don't have the Support Class selected.");
					}
				}
				else
				{
					PromotionalMenuDraw(iClient);
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your character after confirming it for the round."); 
				}
			}
			case 1: //Drop Level
			{
				if(g_iChosenSurvivor[iClient] == BILL)
				{
					if(g_iPromotionalLevel[iClient]>0)
					{
						if(g_bTalentsConfirmed[iClient] == false)
						{
							g_iSkillPoints[iClient]++;
							g_iPromotionalLevel[iClient]--;
							/*
							if(g_bGameFrozen == false)
							{
								SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0+(g_iInspirationalLevel[iClient]*0.02) + (g_iPromotionalLevel[iClient] * 0.02)), true);
								SetEntityRenderMode(iClient, RenderMode:3);
								SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (((float(g_iGhillieLevel[iClient]) * 0.13) + ((float(g_iPromotionalLevel[iClient]) * 0.04)))))));
								if(g_iGhillieLevel[iClient]==0 && g_iPromotionalLevel[iClient]==0)
								{
									SetEntityRenderMode(iClient, RenderMode:0);
									SetEntityRenderColor(iClient, 255, 255, 255, 255);
								}
							}
							*/
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You cannot drop any levels after confirming your talents for the round."); 
					}
					else
						PrintToChat(iClient, "\x03[XPMod] This talent level is already at zero.");
				}
				else
					PrintToChat(iClient, "\x03[XPMod] You don't have Bill selected.");
				
				PromotionalMenuDraw(iClient);
			}
			case 2: //Back
			{
				SupportMenuDraw(iClient);
			}
		}
	}
}