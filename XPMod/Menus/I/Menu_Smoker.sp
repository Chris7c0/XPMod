//Smoker Menu

//Smoker Top Menu Draw
Action SmokerTopMenuDraw(int iClient) 
{
	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(SmokerTopMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	char title[256];
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

	char strFinalOptionText[250];
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
Action EnvelopmentMenuDraw(int iClient)
{
	Menu menu = CreateMenu(EnvelopmentMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s  				Rapid Cell Division (Level %d)\
		\n \
		\nWhile Choking a Victim:\
		\n	- +5 Max Health per Level\
		\n	- Regenerate 30 HP per Second\
		\n	- Can Move Slowly\
		\n \
		\nReduced Tongue Ability Cooldown\
		\n	- -1 Second Every Three Levels\
		\n \
		\nWhile Alive as Smoker, All Smokers Receive:\
		\n	- +10%% Increased Tongue Range per Level\
		\n	- +20%% Increased Tongue Travel Speed per Level    \
		\n	- +15%% Increased Tongue Drag Speed per Level\
		\n	- +20%% Increased Tongue Strength per level\
		\n ",
		strStartingNewLines,
		g_iSmokerTalent1Level[iClient]);
	
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

//Noxious Gasses Menu Draw
Action NoxiousMenuDraw(int iClient)
{
	Menu menu = CreateMenu(NoxiousMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s					Illusive Trickster (Level %d)\
		\n \
		\n 8.5%% Invisibility per Lvl When Tonguing\
		\n	[PRESS CROUCH] Toggle\
		\n \
		\n When Choking:\
		\n	Hide Victim Glow\
		\n	[PRESS WALK] Create Smoke On Victim\
		\n \
		\n [PRESS RELOAD] Create Doppelganger On Crosshair\
		\n	Spawn Clowns & JumboJimmy If Hit\
		\n	Regens(Max 2)\
		\n \
		\n					Bind 1: Cloud Conversion\
		\n \
		\n Become Fast Moving Invulnerable Smoke\
		\n 3 Stages\
		\n In Smoke:\
		\n	CI Are Enhanced\
		\n	Enhanced CI Spawn on Survivors\
		\n	SI Get +150 HP/s\
		\n	Fire, Vomit, PipeBombs Vanish\
		\n ",
		strStartingNewLines,
		g_iSmokerTalent2Level[iClient]);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Dirty Tricks Menu Draw
Action DirtyMenuDraw(int iClient)
{
	Menu menu = CreateMenu(DirtyMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s				Acute Toxicity (Level %d)\
		\n \
		\n +5%% Speed per Level\
		\n \
		\n [CLICK ATTACK] Release Tongued Victim\
		\n \
		\n [PRESS WALK] Teleport (10 Sec CD)\
		\n	- Afterwards Briefly Become Invisible\
		\n \
		\n Smoke Cloud Created On Death\
		\n	2 HP Converted to Temp Every Tick\
		\n	-0.25 Secs per Level on Ticks (Base 3s)\
		\n	+2s Duration per Level\
		\n \
		\n				Bind 2: The Electric Snare\
		\n \
		\n Instantly Set Max HP to 500\
		\n Shock for 1 DMG per Level Every 0.5s for 3s\
		\n Arcs to Survivors for Half Damage\
		\n ",
		strStartingNewLines,
		g_iSmokerTalent3Level[iClient]);
	
	char strFinalOptionText[250];
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
Action ChooseSmokerClassMenuDraw(int iClient) 
{
	DeleteAllMenuParticles(iClient);
	
	Menu menu = CreateMenu(ChooseSmokerClassMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	char title[256];
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
void SmokerTopMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
void EnvelopmentMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
void NoxiousMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
void DirtyMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
void ChooseSmokerClassMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
