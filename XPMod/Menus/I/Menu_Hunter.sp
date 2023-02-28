//Hunter Menu

//Hunter Menu Draw
Action:HunterTopMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(HunterTopMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "%sLevel %d	XP: %d/%d\n==========================\nHunter Talents:\n==========================\n \nPredatorial Evolution: Level %d\nBlood Lust: Level %d\nKill-meleon: Level %d\n \n", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iPredatorialLevel[iClient], g_iBloodLustLevel[iClient], g_iKillmeleonLevel[iClient]);
	SetMenuTitle(menu, title);
	AddMenuItem(menu, "option1", "Predatorial Evolution");
	AddMenuItem(menu, "option2", "Blood Lust");
	AddMenuItem(menu, "option3", "Kill-meleon\n ");
	
	AddMenuItem(menu, "option4", "Choose The Hunter\n ");
	
	AddMenuItem(menu, "option5", "Open In Website\n ");
	
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		\n==========================\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Talent Draws///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Predatorial Evolution Menu Draw
Action:PredatorialMenuDraw(iClient)
{
	Menu menu = CreateMenu(PredatorialMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s       Predatorial Evolution (Level %d)        \
		\n \
		\n [HOLD ATTACK] Dismount Victims\
		\n \
		\n +5%% Movement Speed per Level\
		\n \
		\n Gain Evolved Lunge:\
		\n	- Lunge Much Faster and Further\
		\n \
		\n	- Extra Damage For A Far Pounce\
		\n		- Up To 20 Extra Damage\
		\n		- Min: 150 FT\
		\n		- Max: 350 FT\
		\n \
		\n	- [HOLD JUMP] Controlled Descent\
		\n		- Like A Flying Squirrel\
		\n \
		\n	- [HOLD ATTACK] Dive Bomb\
		\n		- Dash Forward Toward Target\
		\n		- Uses Momentum and Aim Direction\
		\n ",
		strStartingNewLines,
		g_iPredatorialLevel[iClient]);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Blood Lust Menu Draw
Action:BloodLustMenuDraw(iClient)
{
	Menu menu = CreateMenu(BloodLustMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s					Blood Lust (Level %d)\
		\n \
		\nPounce or Claw a Victim to Feed Your\
		\nBlood Lust Meter.\
		\n \
		\n3 Blood Lust Stages:\
		\n	+35% Movement Speed per Stage\
		\n	+25% Non Lunging Stealth per Stage\
		\n	+1 Shredding Damage per Stage\
		\n	+30 Health/Second Regeneration per Stage\
		\n \
		\n			Bind 1: Immobilization Area\
		\n \
		\nDeploy an Immobilization Cloud\
		\n	- Survivors Speed While In Cloud 15%%\
		\n	- Cannot be activated while seen by Survivors    \
		\n	- 30 Sec Duration\
		\n	- 120 Sec Global Cooldown\
		\n ",
		strStartingNewLines,
		g_iBloodLustLevel[iClient]);
	
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

//Kill-meleon Menu Draw
Action:KillmeleonMenuDraw(iClient)
{
	Menu menu = CreateMenu(KillmeleonMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s				Kill-meleon (Level %d)\
		\n \
		\n+250 Max Health\
		\nHide Glow\
		\n \
		\nDo Not Move to Build Your Stealth\
		\n	- Up to 95%% Invisible\
		\n	- While Invisible and Survivors Can See You:\
		\n		- Rapidly Charges Blood Lust Meter\
		\n		- The Closer the Survivors, The Faster The       \
		\n			Blood Lust Meter Fills\
		\n \
		\n				Bind 2: Lethal Injection\
		\n						3 uses\
		\n \
		\nNext Attack Does 4 Dmg/Sec\
		\n+1 Sec/Lvl\
		\nPoison Prevents Item Exchanging\
		\nSlow Victims to 25%%\
		\n \
		\n ",
		strStartingNewLines,
		g_iKillmeleonLevel[iClient]);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Hunter Menu Draw
Action:ChooseHunterClassMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	
	Menu menu = CreateMenu(ChooseHunterClassMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Hunter:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(menu, title);
	AddMenuItem(menu, "option1", "Replace Class 1");
	AddMenuItem(menu, "option2", "Replace Class 2");
	AddMenuItem(menu, "option3", "Replace Class 3");
	AddMenuItem(menu, "option9", "Back");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Handlers/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Hunter Top Menu Handler
HunterTopMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Predatorial Evolution
			{
				PredatorialMenuDraw(iClient);
			}
			case 1: //Blood Lust
			{
				BloodLustMenuDraw(iClient);
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
						PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
						HunterTopMenuDraw(iClient);
					}
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04hunter\x05 as one of your classes.");
					HunterTopMenuDraw(iClient);
				}
			}
			case 4: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/infected/ceda%20files/hunter/xpmod_ig_talents_infected_hunter.html", MOTDPANEL_TYPE_URL);
				HunterTopMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}

//Predatorial Evolution Menu Handler
PredatorialMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
BloodLustMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				HunterTopMenuDraw(iClient);
			}
/*			case 1: //Talent Info
			{
				BloodLustDescMenuDraw(iClient);
			}
			case 2: //Bind Info
			{
				BloodLustBindMenuDraw(iClient);
			}
			case 3: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}*/
		}
	}
}

//Kill-meleon Menu Handler
KillmeleonMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
ChooseHunterClassMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
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