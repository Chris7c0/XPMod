//Charger Menu

//Charger Menu Draw
Action:ChargerTopMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChargerTopMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "Level %d	XP: %d/%d\n==========================\nCharger Talents:\n==========================\n \nGround 'n Pound: Level %d\nSpiked Carapace: Level %d\nHillbilly Madness!: Level %d\n \n", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iGroundLevel[iClient], g_iSpikedLevel[iClient], g_iHillbillyLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Ground 'n Pound");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Spiked Carapace");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Hillbilly Madness!\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Choose The Charger\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Detailed Talent Descriptions\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Back\n==========================\n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Talent Draws///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Ground 'n Pound Menu Draw
Action:GroundMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(GroundMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n  				Ground 'n Pound (Level %d)\n \nLevel 1:\n+1 knock damage per level\n+1 punch, pound, and slam damage every 3rd level\nafter the 1st level\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iGroundLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
//	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Talent Info\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Spiked Carapace Menu Draw
Action:SpikedMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(SpikedMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Spiked Carapace (Level %d)\n \nLevel 1:\nReflect 1 damage per level when meleed\n+25 max health per level\n+33 health per level when knocking survivors\n \nCROUCH to charge Uppercut, on next melee:\n \nThrow survivors up, 5 fall damage, short stun\n \n \n					Bind 1: Heavy Carry\n				3 uses; 30 second cooldown\n \nLevel 1:\n+10%% per level to carry distance and speed\non next charge\nReset charge cooldown\n \n=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iSpikedLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
//	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Talent Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Bind Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option4", "How To Use Binds\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Hillbilly Madness! Menu Draw
Action:HillbillyMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(HillbillyMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n						Hillbilly Madness! (Level %d)\n \nLevel 1:\n+35 max health per level\n+3%% movement speed & carry range per level\n-1 second from charger cooldown every other level\n \nOn successful grapple (until end of charge):\n \nInvincibility\n+5%% of damage taken is converted to health per level\n \n \n						Bind 2: Earthquake\n								3 uses\n \nEarthquake stuns all survivors in a large radius\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iHillbillyLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
//	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Talent Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Bind Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option4", "How To Use Binds\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Charger Menu Draw
Action:ChooseChargerClassMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChooseChargerClassMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Charger:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Replace Class 1");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Replace Class 2");	//implemented in loadouts.sp
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Replace Class 3");
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Handlers/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Charger Top Menu Handler
ChargerTopMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 4: //Detailed Talent Descriptions
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/infected/ceda%20files/charger/xpmod_ig_talents_infected_charger.html", MOTDPANEL_TYPE_URL);
				ChargerTopMenuDraw(iClient);
			}
			case 5: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}

//Ground 'n Pound Menu Handler
GroundMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
SpikedMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
HillbillyMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
ChooseChargerClassMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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