//Smoker Menu

//Smoker Top Menu Draw
Action:SmokerTopMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(SmokerTopMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "%sLevel %d	XP: %d/%d\n==========================\nSmoker Talents:\n==========================\n \nRapid Cell Division: Level %d\nIllusive Trickster: Level %d\nAcute Toxicity: Level %d\n \n", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSmokerTalent1Level[iClient], g_iSmokerTalent2Level[iClient], g_iSmokerTalent3Level[iClient]);
	SetMenuTitle(menu, title);
	AddMenuItem(menu, "option1", "Rapid Cell Division");
	AddMenuItem(menu, "option2", "Illusive Trickster");
	AddMenuItem(menu, "option3", "Acute Toxicity\n ");
	
	AddMenuItem(menu, "option4", "Choose The Smoker\n ");
	
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

//Envelopment Menu Draw
Action:EnvelopmentMenuDraw(iClient)
{
	Menu menu = CreateMenu(EnvelopmentMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s  				Rapid Cell Division (Level %d)\
		\n \
		\n+5 HP per Level\
		\n \
		\nRegenerate 60 HP per Second\
		\n \
		\nRecuded Tongue Ability Cooldown\
		\n	- -1 Second Every Three Levels\
		\n \
		\nCan Move Slowly While Choking A Victim\
		\n \
		\nWhile Alive as Smoker, All Smokers Receive:\
		\n	- +20%% Increased Tongue Range per Level\
		\n	- +20%% Increased Tongue Travel Speed per Level    \
		\n	- +15%% Increased Tongue Drag Speed per Level\
		\n	- +20%% Increased Tongue Strength per level\
		\n ",
		strStartingNewLines,
		g_iSmokerTalent1Level[iClient]);

	// SetMenuTitle(menu, "
	// 	%s  			Envelopment (Level %d)
	// 	n 
	// 	nLevel 1:
	// 	n(Stacks) +3%% tongue range & fly speed
	// 	n 
	// 	n 
	// 	nSkill Uses:
	// 	n+1 (Stack) for each Smoker with this talent
	// 	nUnlimited stacks
	// 	n ",
	// 	strStartingNewLines,
	// 	g_iSmokerTalent1Level[iClient]);
	
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

//Noxious Gasses Menu Draw
Action:NoxiousMenuDraw(iClient)
{
	Menu menu = CreateMenu(NoxiousMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s										Illusive Trickster (Level %d)\
		\n \
		\n 9.5%% Invisibility per Level While Pulling or Choking A Victim:\
		\n	- [PRESS CROUCH] Toggle Invisibility\
		\n \
		\n While Choking A Victim:\
		\n	- Hide Their Glow\
		\n	- [PRESS WALK] Create A Smoke Screen Around Them\
		\n \
		\n [PRESS RELOAD] Create Smoker Doppelganger Decoy On Your Crosshair\
		\n	- Regenerates While Alive as Smoker (Max 5 Decoys)\
		\n \
		\n					Bind 1: Smoke Cloud Confusion\
		\n	- Coming Soon!\
		\n ",
		strStartingNewLines,
		g_iSmokerTalent2Level[iClient]);

	// SetMenuTitle(menu, "
	// 	%s									Noxious Gasses (Level %d)
	// 	n 
	// 	nLevel 1:
	// 	n1 cloud damage every tick
	// 	n-0.25 seconds between cloud ticks per level (Base: 3 seconds)
	// 	n+2%% movement speed per level
	// 	n 
	// 	n 
	// 	n						    Bind 1: Disperse
	// 	n				Unlimited uses; 10 second cooldown
	// 	n 
	// 	nLevel 1:
	// 	nTeleport +30 feet per level
	// 	n100%% transparency after use, fades to 0%% over +1 second per level
	// 	n ",
	// 	strStartingNewLines,
	// 	g_iSmokerTalent2Level[iClient]);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Dirty Tricks Menu Draw
Action:DirtyMenuDraw(iClient)
{
	Menu menu = CreateMenu(DirtyMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s					Acute Toxicity (Level %d)\
		\n \
		\n +5%% Speed per Level\
		\n \
		\n [CLICK ATTACK] Release Your Choking Victim\
		\n \
		\n [PRESS WALK] Teleport (5 Sec CD)\
		\n	- Afterwards Briefly Become Invisible\
		\n \
		\n +1 Cloud Damage Every Tick\
		\n	-0.25 Secs on Cloud Ticks per Level (Base: 3 sec)\
		\n \
		\n Tar Fingers: Attacks infect for +2 sec per level\
		\n	- More Coming Soon.\
		\n \
		\n					Bind 2: The Electric Snare\
		\n \
		\n - Shock for 1 DMG per Level Every Half Sec for 3 Sec\
		\n - Arcs to survivors for half damage\
		\n ",
		strStartingNewLines,
		g_iSmokerTalent3Level[iClient]);

	// SetMenuTitle(menu, "
	// 	%s					Dirty Tricks (Level %d)
	// 	n 
	// 	nLevel 1:
	// 	nAttacks infect for +2 sec per level
	// 	n+1%% speed when choking per level
	// 	n(Stacks) +8%% drag speed per level
	// 	n 
	// 	n 
	// 	n					Bind 2: The Electric Snare
	// 	n						 3 uses; 3 sec duration
	// 	n 
	// 	nLevel 1:
	// 	nShock for 1 dmg per level every half sec
	// 	nArcs to survivors in line of sight for half damage
	// 	n 
	// 	n 
	// 	nSkill Uses:
	// 	n+1 (Stack) for each SMOKER w/ this talent
	// 	nUnlimited stacks
	// 	n ",
	// 	strStartingNewLines,
	// 	g_iSmokerTalent3Level[iClient]);
	
	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Smoker Menu Draw
Action:ChooseSmokerClassMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	
	Menu menu = CreateMenu(ChooseSmokerClassMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Smoker:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
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

//Smoker Top Menu Handler
SmokerTopMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Envelopment
			{
				EnvelopmentMenuDraw(iClient);
			}
			case 1: //Noxious Gasses
			{
				NoxiousMenuDraw(iClient);
			}
			case 2: //Dirty
			{
				DirtyMenuDraw(iClient);
			}
			case 3: //Select This Class
			{
				if((g_iClientInfectedClass1[iClient] != SMOKER) && (g_iClientInfectedClass2[iClient] != SMOKER) && (g_iClientInfectedClass3[iClient] != SMOKER))
				{
					if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
						ChooseSmokerClassMenuDraw(iClient);
					else
					{
						PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
						SmokerTopMenuDraw(iClient);
					}
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04smoker\x05 as one of your classes.");
					SmokerTopMenuDraw(iClient);
				}
			}
			case 4: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/infected/ceda%20files/smoker/xpmod_ig_talents_infected_smoker.html", MOTDPANEL_TYPE_URL);
				SmokerTopMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}

//Envelopment Menu Handler
EnvelopmentMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				SmokerTopMenuDraw(iClient);
			}
		}
	}
}

//Noxious Gasses Menu Handler
NoxiousMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				SmokerTopMenuDraw(iClient);
			}
		}
	}
}

//Dirty Menu Handler
DirtyMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
				SmokerTopMenuDraw(iClient);
			}
		}
	}
}

//Choose Smoker Top Menu Handler
ChooseSmokerClassMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
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
					SetInfectedClassSlot(iClient, 1, SMOKER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 1\x05 with the \x04Smoker\x05.");
					SmokerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 1\x05 because it has already been confirmed.");
					ChooseSmokerClassMenuDraw(iClient);
				}
			}
			case 1: //Replace Class 2
			{
				if(g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, SMOKER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 2\x05 with the \x04Smoker\x05.");
					SmokerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 2\x05 because it has already been confirmed.");
					ChooseSmokerClassMenuDraw(iClient);
				}
			}
			case 2: //Replace Class 3
			{
				if(g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, SMOKER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 3\x05 with the \x04Smoker\x05.");
					SmokerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 3\x05 because it has already been confirmed.");
					ChooseSmokerClassMenuDraw(iClient);
				}
			}
			default: //Back
			{
				SmokerTopMenuDraw(iClient);
			}
		}
	}
}