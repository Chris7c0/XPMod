//Smoker Menu

//Smoker Top Menu Draw
Action SmokerTopMenuDraw(int iClient) 
{

	Menu menu = CreateMenu(SmokerTopMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32], strNewLines[512];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	char text[512];
	FormatEx(text, sizeof(text), "%sLevel %d	XP: %d/%d\n==========================\nSmoker Talents:\n==========================\n \nRapid Cell Division: Level %d\nIllusive Trickster: Level %d\nAcute Toxicity: Level %d\n \n", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iSmokerTalent1Level[iClient], g_iSmokerTalent2Level[iClient], g_iSmokerTalent3Level[iClient]);
	SetMenuTitle(menu, "%s", text);
	GetNewLinesAutomatic(text, strNewLines, 4+3);
	AddMenuItem(menu, "option1", "Rapid Cell Division");
	AddMenuItem(menu, "option2", "Illusive Trickster");
	AddMenuItem(menu, "option3", "Acute Toxicity\n ");
	
	AddMenuItem(menu, "option4", "Choose The Smoker\n ");
	
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		\n==========================\
		%s%s",
		strNewLines,
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

	char strStartingNewLines[32], strEndingNewLines[32], strNewLines[512];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	char text[512];
	FormatEx(text, sizeof(text), "\
		%sRapid Cell Division (Level %d)\
		\n \
		\n%d Max Health\
		\nWhile Choking A Victim:\
		\n	Regen 60 HP/s\
		\n	+2 Dmg/Hit\
		\n	Can Move Slowly\
		\n \
		\nTongue Cooldown Reduced\
		\n	-1s every 3 Lvls\
		\n \
		\nWhile Alive, All Smokers Gain:\
		\n	+10%% Tongue Range/Lvl\
		\n	+20%% Tongue Speed/Lvl\
		\n	+15%% Drag Speed/Lvl\
		\n	+20%% Tongue Strength/Lvl\
		\n ",
		strStartingNewLines,
		g_iSmokerTalent1Level[iClient],
		SMOKER_STARTING_MAX_HEALTH);
	SetMenuTitle(menu, "%s", text);
	GetNewLinesAutomatic(text, strNewLines);

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		\n %s%s",
		strNewLines,
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

	char strStartingNewLines[32], strEndingNewLines[32], strNewLines[512];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	char text[512];
	FormatEx(text, sizeof(text), "\
		%sIllusive Trickster (Lvl %d)\
		\n \
		\n85%% Invisible When Tonguing\
		\n	[PRESS CROUCH] Toggle\
		\n \
		\nWhen Choking:\
		\n	Hide Victim Glow\
		\n	[PRESS WALK] Create Smoke On Victim\
		\n \
		\nAim & [PRESS RELOAD] to Spawn Doppelganger\
		\n	Spawn Clowns & JumboJimmy If Hit\
		\n	Regens(Max 4)\
		\n \
		\nBind 1: Cloud Conversion\
		\n \
		\nBecome Fast Moving Invulnerable Smoke\
		\n3 Stages\
		\nIn Smoke:\
		\n	CI Enhance\
		\n	ECI Spawn on Victims\
		\n	SI Get +150 HP/s\
		\n	Fire, Bile, PipeBombs Vanish\
		\n ",
		strStartingNewLines,
		g_iSmokerTalent2Level[iClient]);
	SetMenuTitle(menu, "%s", text);
	GetNewLinesAutomatic(text, strNewLines);

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		\n %s%s",
		strNewLines,
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

	char strStartingNewLines[32], strEndingNewLines[32], strNewLines[512];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	char text[512];
	FormatEx(text, sizeof(text), "\
		%sAcute Toxicity (Level %d)\
		\n \
		\n+5%% Speed per Lvl\
		\n \
		\nClick [ATTACK] Release tongued victim\
		\n \
		\nPress [WALK] Teleport (10s CD)\
		\n	Brief Invisibility After\
		\n \
		\nSmoke Cloud on Death:\
		\n	2 HP -> Temp HP per tick\
		\n	-0.25s/Lvl tick rate (Base 3s)\
		\n	+2s Duration/Lvl\
		\n \
		\nBind 2: Electric Snare\
		\n \
		\nInstantly set Max HP to 500\
		\nShock 1 Dmg/Lvl every 0.5s for 3s\
		\nArcs to Survivors for half dmg\
		\n ",
		strStartingNewLines,
		g_iSmokerTalent3Level[iClient]);
	SetMenuTitle(menu, "%s", text);
	GetNewLinesAutomatic(text, strNewLines);

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		\n %s%s",
		strNewLines,
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Smoker Menu Draw
Action ChooseSmokerClassMenuDraw(int iClient) 
{

	
	Menu menu = CreateMenu(ChooseSmokerClassMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	char title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Smoker:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(menu, "%s", title);
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
