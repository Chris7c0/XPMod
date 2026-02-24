//Charger Menu

//Charger Menu Draw
Action ChargerTopMenuDraw(int iClient)
{
	CheckLevel(iClient);
	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(ChargerTopMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	char title[256];
	FormatEx(title, sizeof(title), "%sLevel %d	XP: %d/%d\n==========================\nCharger Talents:\n==========================\n \nGround 'n Pound: Level %d\nSpiked Carapace: Level %d\nHillbilly Madness!: Level %d\n \n", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iGroundLevel[iClient], g_iSpikedLevel[iClient], g_iHillbillyLevel[iClient]);
	SetMenuTitle(menu, "%s", title);
	
	AddMenuItem(menu, "option1", "Ground 'n Pound");
	AddMenuItem(menu, "option2", "Spiked Carapace");
	AddMenuItem(menu, "option3", "Hillbilly Madness!\n ");
	AddMenuItem(menu, "option4", "Choose The Charger\n ");
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

//Ground 'n Pound Menu Draw
Action GroundMenuDraw(int iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(GroundMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s  				Ground 'n Pound (Level %d)\
		\n \
		\n+1 knock damage per level\
		\n+1 punch, pound, and slam damage every 3rd level\
		\nafter the 1st level\
		\n ",
		strStartingNewLines,
		g_iGroundLevel[iClient]);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Spiked Carapace Menu Draw
Action SpikedMenuDraw(int iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(SpikedMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s				Spiked Carapace (Level %d)\
		\n \
		\nReflect 1 damage per level when meleed\
		\n+25 max health per level\
		\n+33 health per level when knocking survivors\
		\n \
		\nCROUCH to charge Uppercut, on next melee:\
		\n \
		\nThrow survivors up, 5 fall damage, short stun\
		\n \
		\n \
		\n					Bind 1: Heavy Carry\
		\n				3 uses; 30 second cooldown\
		\n \
		\n+10%% per level to carry distance and speed\
		\non next charge\
		\nReset charge cooldown\
		\n ",
		strStartingNewLines,
		g_iSpikedLevel[iClient]);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Hillbilly Madness! Menu Draw
Action HillbillyMenuDraw(int iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(HillbillyMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s						Hillbilly Madness! (Level %d)\
		\n \
		\n+35 Max Health per level\
		\n+3%% Movement Speed & Carry Range per level\
		\n-1 Second from Charger cooldown every other level\
		\n \
		\nOn successful grapple (until end of charge):\
		\n \
		\nInvincibility\
		\n+5%% of damage taken is converted to health per level\
		\n \
		\n						Bind 2: Earthquake\
		\n								3 uses\
		\n \
		\nPunch ground to:\
		\n	Damage visible survivors in a larger radius\
		\n	Stun visible survivors in a smaller radius\
		\n ",
		strStartingNewLines,
		g_iHillbillyLevel[iClient]);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Charger Menu Draw
Action ChooseChargerClassMenuDraw(int iClient) 
{
	DeleteAllMenuParticles(iClient);
	
	CheckLevel(iClient);
	Menu menu = CreateMenu(ChooseChargerClassMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	char title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Charger:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	
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

//Charger Top Menu Handler
void ChargerTopMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Ground 'n Pound
			{
				GroundMenuDraw(iClient);
			}
			case 1: //Spiked Carapace
			{
				SpikedMenuDraw(iClient);
			}
			case 2: //Hillbilly Madness!
			{
				HillbillyMenuDraw(iClient);
			}
			case 3: //Select This Class
			{
				if((g_iClientInfectedClass1[iClient] != CHARGER) && (g_iClientInfectedClass2[iClient] != CHARGER) && (g_iClientInfectedClass3[iClient] != CHARGER))
				{
					if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
						ChooseChargerClassMenuDraw(iClient);
					else
					{
						PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
						ChargerTopMenuDraw(iClient);
					}
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04Charger\x05 as one of your classes.");
					ChargerTopMenuDraw(iClient);
				}
			}
			case 4: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/infected/ceda%20files/charger/xpmod_ig_talents_infected_charger.html", MOTDPANEL_TYPE_URL);
				ChargerTopMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}

//Ground 'n Pound Menu Handler
void GroundMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
				ChargerTopMenuDraw(iClient);
			}
		}
	}
}

//Spiked Carapace Menu Handler
void SpikedMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
				ChargerTopMenuDraw(iClient);
			}
		}
	}
}

//Hillbilly Madness! Menu Handler
void HillbillyMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
				ChargerTopMenuDraw(iClient);
			}
		}
	}
}

//Choose Charger Top Menu Handler
void ChooseChargerClassMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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
					SetInfectedClassSlot(iClient, 1, CHARGER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 1\x05 with the \x04Charger\x05.");
					ChargerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 1\x05 because it has already been confirmed.");
					ChooseChargerClassMenuDraw(iClient);
				}
			}
			case 1: //Replace Class 2
			{
				if(g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, CHARGER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 2\x05 with the \x04Charger\x05.");
					ChargerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 2\x05 because it has already been confirmed.");
					ChooseChargerClassMenuDraw(iClient);
				}
			}
			case 2: //Replace Class 3
			{
				if(g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, CHARGER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 3\x05 with the \x04Charger\x05.");
					ChargerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 3\x05 because it has already been confirmed.");
					ChooseChargerClassMenuDraw(iClient);
				}
			}
			default: //Back
			{
				ChargerTopMenuDraw(iClient);
			}
		}
	}
}
