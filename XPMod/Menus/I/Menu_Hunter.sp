//Hunter Menu

//Hunter Menu Draw
public Action:HunterTopMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(HunterTopMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "Level %d	XP: %d/%d\n==========================\nHunter Talents:\n==========================\n \nPredatorial Evolution: Level %d\nBlood Lust: Level %d\nKill-meleon: Level %d\n \n", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iPredatorialLevel[iClient], g_iBloodlustLevel[iClient], g_iKillmeleonLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Predatorial Evolution");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Blood Lust");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Kill-meleon\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Choose The Hunter\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Detailed Talent Descriptions\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Back\n==========================\n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Talent Draws///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Predatorial Evolution Menu Draw
public Action:PredatorialMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(PredatorialMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=\n \n  Predatorial Evolution (Level %d)\n \nLevel 1:\n+5%% movement speed per level\n+10%% pounce distance per level\n(Team)(Stacks)+5% stumble radius for Hunter/Jockey\n \n=	=	=	=	=	=	=	=	=	=\n \n",g_iPredatorialLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
//	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Talent Info\n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Blood Lust Menu Draw
public Action:BloodlustMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(BloodlustMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=\n \n				Blood Lust (Level %d)\n \nLevel 1:\n+1 shredding damage every 4 levels\n+25 max health per level\n+3 life stealing while shredding per level\n \n \n				Bind 1: Dismount\n	Unlimited uses; 15 second cooldown\n \nLevel 1:\nDismount a pounced survivor\n \n=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iBloodlustLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
//	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Talent Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Bind Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option4", "How To Use Binds\n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Kill-meleon Menu Draw
public Action:KillmeleonMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(KillmeleonMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n											Kill-meleon (Level %d)\n \nLevel 1:\n(Charge) +9%% stealth & pounce damage per 0.35 seconds\nLevel 5:\nHide glow when pounced\n \n \n											Bind 2: Lethal Injection\n													3 uses\n \nLevel 1:\nNext attack does 4 damage per second\n+1 second per level\nPoison prevents item exchanging\nSlow victims to 25%\n3 damage per 20 seconds permanently\n \n \nSkill Uses:\n(Charge) Hold [CROUCH] to stealth & build damage\n+2 damage per level\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iKillmeleonLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
//	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Talent Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Bind Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option4", "How To Use Binds\n \n \n \n \n \n \n \n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Hunter Menu Draw
public Action:ChooseHunterClassMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChooseHunterClassMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Hunter:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Replace Class 1");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Replace Class 2");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Replace Class 3");
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Handlers/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Hunter Top Menu Handler
public HunterTopMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Predatorial Evolution
			{
				PredatorialMenuDraw(iClient);
			}
			case 1: //Blood Lust
			{
				BloodlustMenuDraw(iClient);
			}
			case 2: //Kill-meleon
			{
				KillmeleonMenuDraw(iClient);
			}
			case 3: //Select This Class
			{
				if((g_iClientInfectedClass1[iClient] != HUNTER) && (g_iClientInfectedClass2[iClient] != HUNTER) && (g_iClientInfectedClass3[iClient] != HUNTER))
				{
					if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
						ChooseHunterClassMenuDraw(iClient);
					else
					{
						PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your infected classes after confirming your talents");
						HunterTopMenuDraw(iClient);
					}
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04hunter\x05 as one of your classes.");
					HunterTopMenuDraw(iClient);
				}
			}
			case 4: //Detailed Talent Descriptions
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/infected/ceda%20files/hunter/xpmod_ig_talents_infected_hunter.html", MOTDPANEL_TYPE_URL);
				HunterTopMenuDraw(iClient);
			}
			case 5: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}

//Predatorial Evolution Menu Handler
public PredatorialMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				HunterTopMenuDraw(iClient);
			}
/*			case 1: //Talent Info
			{
				PredatorialDescMenuDraw(iClient);
			}*/
		}
	}
}

//Blood Lust Menu Handler
public BloodlustMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				HunterTopMenuDraw(iClient);
			}
/*			case 1: //Talent Info
			{
				BloodlustDescMenuDraw(iClient);
			}
			case 2: //Bind Info
			{
				BloodlustBindMenuDraw(iClient);
			}
			case 3: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}*/
		}
	}
}

//Kill-meleon Menu Handler
public KillmeleonMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				HunterTopMenuDraw(iClient);
			}
/*			case 1: //Talent Info
			{
				KillmeleonDescMenuDraw(iClient);
			}
			case 2: //Bind Info
			{
				KillmeleonBindMenuDraw(iClient);
			}
			case 3: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}*/
		}
	}
}

//Choose Hunter Top Menu Handler
public ChooseHunterClassMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Replace Class 1
			{
				if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass1[iClient]);
					SetInfectedClassSlot(iClient, 1, HUNTER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 1\x05 with the \x04Hunter\x05.");
					HunterTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 1\x05 because it has already been confirmed.");
					ChooseHunterClassMenuDraw(iClient);
				}
			}
			case 1: //Replace Class 2
			{
				if(g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, HUNTER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 2\x05 with the \x04Hunter\x05.");
					HunterTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 2\x05 because it has already been confirmed.");
					ChooseHunterClassMenuDraw(iClient);
				}
			}
			case 2: //Replace Class 3
			{
				if(g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, HUNTER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 3\x05 with the \x04Hunter\x05.");
					HunterTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 3\x05 because it has already been confirmed.");
					ChooseHunterClassMenuDraw(iClient);
				}
			}
			default: //Back
			{
				HunterTopMenuDraw(iClient);
			}
		}
	}
}