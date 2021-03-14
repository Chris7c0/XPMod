SetupLoadouts()
{	
	for(new i=0;i <= MaxClients;i++)			//need to reset these when player disconnects and probably somewhere else
	{
		g_iClientPrimarySlotID[i] = 0;
		g_iClientSecondarySlotID[i] = 0;
		g_iClientExplosiveSlotID[i] = 0;
		g_iClientHealthSlotID[i] = 0;
		g_iClientBoostSlotID[i] = 0;
		g_iClientLaserSlotID[i] = 0;
		g_iClientPrimarySlotCost[i] = 0;
		g_iClientSecondarySlotCost[i] = 0;
		g_iClientExplosiveSlotCost[i] = 0;
		g_iClientHealthSlotCost[i] = 0;
		g_iClientBoostSlotCost[i] = 0;
		g_iClientLaserSlotCost[i] = 0;
	}
}

// Action:LoadoutMenuDrawSetup(iClient)
// {
// 	if(IsClientInGame(iClient))
// 		LoadoutMenuDraw(iClient);
	
// 	return Plugin_Handled;
// }

Action:ShowUserLoadoutMenu(iClient, args)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient))
		return Plugin_Handled;

	// If client is logged in then show them the equipement menu, otherwise tell them this is xpm
	if (g_bClientLoggedIn[iClient])
		LoadoutMenuDraw(iClient);
	else
		XPModMenuDraw(iClient);

	PrintToChat(iClient, "\x03[XPMod] \x04You can use XP to buy Survivor equipment each round.");

	return Plugin_Handled;
}

//Draw Menus
Action:LoadoutMenuDraw(iClient)
{
	Menu menu = CreateMenu(LoadoutMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	GetWeaponNames(iClient);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, 
		"%sUsable XP: %d\
		\n \
		\n* You get equipment when you confirm *\
		\n \
		\nPrimary:			  %s\
		\nSecondary:		 %s\
		\nExplosive:			%s\
		\nHealth/Ammo:	 %s\
		\nHealth Boost:	  %s\
		\nLaser Sight:		%s\
		\n_	_	_	_	_	_	_	_	_	_	_	_\
		\nCost Per Round:	%d\
		\n ",
		strStartingNewLines,
		g_iClientUsableXP,
		g_strClientPrimarySlot,
		g_strClientSecondarySlot,
		g_strClientExplosiveSlot,
		g_strClientHealthSlot,
		g_strClientBoostSlot,
		g_strClientLaserSlot,
		g_iClientTotalXPCost[iClient]);
	
	AddMenuItem(menu, "option1", "Primary Slot");
	AddMenuItem(menu, "option2", "Secondary Slot");
	AddMenuItem(menu, "option3", "Explosives Slot");
	AddMenuItem(menu, "option4", "Health/Ammo Slot");
	AddMenuItem(menu, "option5", "Health Boost Slot");
	AddMenuItem(menu, "option6", "Laser Sight");
	AddMenuItem(menu, "option7", "Reset All");
	AddMenuItem(menu, "option8", "Change Your Survivor\n ");
	AddMenuItem(menu, "option9", "Main Menu");

	decl String:strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText), "Exit\
		%s\n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option10", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

Action:PrimaryMenuDraw(iClient) 
{
	Menu menu = CreateMenu(PrimaryMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nSelect the Class of Weapon:", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "Sub-Machine Guns");
	AddMenuItem(menu, "option2", "Assault Rifles");
	AddMenuItem(menu, "option3", "Shotguns");	
	AddMenuItem(menu, "option4", "Sniper Rifles");
	AddMenuItem(menu, "option5", "Special Weapons");
	AddMenuItem(menu, "option6", "None\n ");
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

Action:SecondaryMenuDraw(iClient) 
{
	Menu menu = CreateMenu(SecondaryMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nSelect the Class of Weapon:",g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "Sidearms");
	AddMenuItem(menu, "option2", "Slashing Weapons");
	AddMenuItem(menu, "option3", "Crushing Weapons");
	AddMenuItem(menu, "option4", "None\n ");
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

Action:ExplosivesMenuDraw(iClient) 
{
	Menu menu = CreateMenu(ExplosivesMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nSelect Explosive:", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", " Pipe Bomb (30 XP)");
	AddMenuItem(menu, "option2", "Molotov (30 XP)");
	AddMenuItem(menu, "option3", "Bile Jar (40 XP)");
	AddMenuItem(menu, "option4", "None\n ");
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

Action:HealthMenuDraw(iClient) 
{
	Menu menu = CreateMenu(HealthMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nSelect Relief Supplies:", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "First Aid Kit (250 XP)");
	AddMenuItem(menu, "option2", "Defibrillator (500 XP)");
	AddMenuItem(menu, "option3", "Explosive Ammo (1000 XP)");
	AddMenuItem(menu, "option4", "Incendiary Ammo (500 XP)");
	AddMenuItem(menu, "option5", "None\n ");
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

Action:BoostMenuDraw(iClient) 
{
	Menu menu = CreateMenu(BoostMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nSelect Enhancement:", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "Pain Pills (50 XP)");
	AddMenuItem(menu, "option2", "Adrenaline Shot (50 XP)");
	AddMenuItem(menu, "option3", "None\n ");
	AddMenuItem(menu, "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

Action:CleanMenuDraw(iClient) 
{
	Menu menu = CreateMenu(CleanMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nReset Your Equipment Loadout?", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "Yes");
	AddMenuItem(menu, "option2", "No");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//SubMachine Gun Draw
Action:SMGMenuDraw(iClient) 
{
	Menu menu = CreateMenu(SMGMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nSub-Machine Guns\n", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "Israeli UZI (55 XP)");
	AddMenuItem(menu, "option2", "Silenced Mac-10 (60 XP)");
	AddMenuItem(menu, "option3", "MP5 (70 XP)\n ");	
	AddMenuItem(menu, "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Machine Gun Draw
Action:MGMenuDraw(iClient) 
{
	Menu menu = CreateMenu(MGMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nAssault Rifles\n", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "AK-47 (80 XP)");
	AddMenuItem(menu, "option2", "M16A2 (80 XP)");
	AddMenuItem(menu, "option3", "SIG SG 552 (100 XP)");	
	AddMenuItem(menu, "option4", "SCAR-L (60 XP)\n ");
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Shotgun Gun Draw
Action:ShotgunMenuDraw(iClient) 
{
	Menu menu = CreateMenu(ShotgunMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nShotguns\n", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "Remington 870 (60 XP)");
	AddMenuItem(menu, "option2", "Remington 870 Custom (60 XP)");
	AddMenuItem(menu, "option3", "Benelli M1014 (80 XP)");	
	AddMenuItem(menu, "option4", "Franchi SPAS-12 (80 XP)\n ");
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Sniper Gun Draw
Action:SniperMenuDraw(iClient) 
{
	Menu menu = CreateMenu(SniperMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nSniper Rifles\n", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "Ruger Mini-14 (60 XP)");
	AddMenuItem(menu, "option2", "H&K MSG90 (80 XP)");
	AddMenuItem(menu, "option3", "Scout (60 XP)");
	AddMenuItem(menu, "option4", "AWP (100 XP)\n ");
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Special Weapons Gun Draw
Action:SpecialMenuDraw(iClient) 
{
	Menu menu = CreateMenu(SpecialMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nSpecial Weapons\n", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "Grenade Launcher (400 XP)");
	AddMenuItem(menu, "option2", "M60 Machine Gun (500 XP)\n ");
	AddMenuItem(menu, "option3", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Chainsaw Gun Draw
Action:CrushingMeleeMenuDraw(iClient) 
{
	Menu menu = CreateMenu(CrushingMeleeMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nCrushing Melee Weapons\n", g_iClientUsableXP);
	
	AddMenuItem(menu, "option0", "Cricket Bat (30 XP)");
	AddMenuItem(menu, "option1", "Electric Guitar (30 XP)");
	AddMenuItem(menu, "option2", "Frying Pan (30 XP)");
	AddMenuItem(menu, "option3", "Nightstick (30 XP)");
	AddMenuItem(menu, "option4", "Golf Club (30 XP)");
	//AddMenuItem(menu, "option5", "Riot Shield (30 XP)");
	AddMenuItem(menu, "option5", "Baseball Bat (50 XP)\n ");
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Sidearms Gun Draw
Action:SidearmMenuDraw(iClient) 
{
	Menu menu = CreateMenu(SidearmMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nSidearms\n", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "P220 (15 XP)");
	AddMenuItem(menu, "option2", "Glock + P220 (30 XP)");
	AddMenuItem(menu, "option3", "Magnum (40 XP)\n ");
	AddMenuItem(menu, "option4", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option5", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Melee Gun Draw
Action:SlashingMeleeMenuDraw(iClient) 
{
	Menu menu = CreateMenu(SlashingMeleeMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(menu, "Usable XP: %d\n \nSlashing Melee Weapons\n", g_iClientUsableXP);
	
	AddMenuItem(menu, "option1", "Axe (30 XP)");
	AddMenuItem(menu, "option2", "Crowbar (30 XP)");
	AddMenuItem(menu, "option3", "Katana (30 XP)");
	AddMenuItem(menu, "option4", "Machete (30 XP)");
	AddMenuItem(menu, "option5", "Pitch Fork (30 XP)");
	AddMenuItem(menu, "option6", "Combat Knife (50 XP)");
	AddMenuItem(menu, "option7", "Chainsaw (250 XP)\n ");
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Menu Handlers

//Loadout Menu Handler(MAIN)
LoadoutMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Primary Slot
			{
				PrimaryMenuDraw(iClient);
			}
			case 1: //Secondary Slot
			{
				SecondaryMenuDraw(iClient);
			}
			case 2: //Explosives Slot
			{
				ExplosivesMenuDraw(iClient);
			}
			case 3: //Health Slot
			{
				HealthMenuDraw(iClient);
			}
			case 4: //Boost Slot
			{
				BoostMenuDraw(iClient);
			}
			case 5: //Laser Sight
			{
				if(g_iClientLaserSlotID[iClient]==0)
					g_iClientLaserSlotID[iClient] = 1;
				else
					g_iClientLaserSlotID[iClient] = 0;
				
				LoadoutMenuDraw(iClient);
			}
			case 6: //Clear Loudout
			{
				CleanMenuDraw(iClient);
			}
			case 7: //Change Survivor
			{
				ChangeSurvivorMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopMenuDraw(iClient);
			}
			default: //Exit
			{
				
			}
		}
	}
}

//Primary Slots Menu Handler
PrimaryMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //SMGS
			{
				SMGMenuDraw(iClient);
			}
			case 1: //MGs
			{
				MGMenuDraw(iClient);
			}
			case 2: //Shotguns
			{
				ShotgunMenuDraw(iClient);
			}
			case 3: //Snipers
			{
				SniperMenuDraw(iClient);
			}
			case 4: //Special Weapons
			{
				SpecialMenuDraw(iClient);
			}
			case 5: //None
			{
				g_iClientPrimarySlotID[iClient] = 0;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//Secondary Slots Menu Handler
SecondaryMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Sidearms
			{
				SidearmMenuDraw(iClient);
			}
			case 1: //Melee
			{
				SlashingMeleeMenuDraw(iClient);
			}
			case 2: //Chainsaw
			{
				CrushingMeleeMenuDraw(iClient);
			}
			case 3: //None
			{
				g_iClientSecondarySlotID[iClient] = 0;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//Explosive Slots Menu Handler
ExplosivesMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Pipe Bomb
			{
				g_iClientExplosiveSlotID[iClient] = 1;
				LoadoutMenuDraw(iClient);
			}
			case 1: //Molotov
			{
				g_iClientExplosiveSlotID[iClient] = 2;
				LoadoutMenuDraw(iClient);
			}
			case 2: //Bile Jar
			{
				g_iClientExplosiveSlotID[iClient] = 3;
				LoadoutMenuDraw(iClient);
			}
			case 3: //None
			{
				g_iClientExplosiveSlotID[iClient] = 0;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//Health Slots Menu Handler
HealthMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Med Kit
			{
				g_iClientHealthSlotID[iClient] = 1;
				LoadoutMenuDraw(iClient);
			}
			case 1: //Defibrillator
			{
				g_iClientHealthSlotID[iClient] = 2;
				LoadoutMenuDraw(iClient);
			}
			case 2: //Explosive Ammo
			{
				g_iClientHealthSlotID[iClient] = 3;
				LoadoutMenuDraw(iClient);
			}
			case 3: //Incendiary Ammo
			{
				g_iClientHealthSlotID[iClient] = 4;
				LoadoutMenuDraw(iClient);
			}
			case 4: //None
			{
				g_iClientHealthSlotID[iClient] = 0;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//Boost Slots Menu Handler
BoostMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Pain Pills
			{
				g_iClientBoostSlotID[iClient] = 1;
				LoadoutMenuDraw(iClient);
			}
			case 1: //Adrenaline Shot
			{
				g_iClientBoostSlotID[iClient] = 2;
				LoadoutMenuDraw(iClient);
			}
			case 2: //None
			{
				g_iClientBoostSlotID[iClient] = 0;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//Clean Loadout Menu Handler
CleanMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				g_iClientPrimarySlotID[iClient] = 0;
				g_iClientLaserSlotID[iClient] = 0;
				g_iClientSecondarySlotID[iClient] = 0;
				g_iClientExplosiveSlotID[iClient] = 0;
				g_iClientHealthSlotID[iClient] = 0;
				g_iClientBoostSlotID[iClient] = 0;
				g_iClientPrimarySlotCost[iClient] = 0;
				g_iClientSecondarySlotCost[iClient] = 0;
				g_iClientExplosiveSlotCost[iClient] = 0;
				g_iClientHealthSlotCost[iClient] = 0;
				g_iClientBoostSlotCost[iClient] = 0;
				g_iClientLaserSlotCost[iClient] = 0;
				LoadoutMenuDraw(iClient);
			}
			case 1: //No
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//SMG Menu Handler
SMGMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Israeli UZI 
			{
				g_iClientPrimarySlotID[iClient] = 1;
				LoadoutMenuDraw(iClient);
			}
			case 1: //Mac-10
			{
				g_iClientPrimarySlotID[iClient] = 2;
				LoadoutMenuDraw(iClient);
			}
			case 2: //MP5
			{
				g_iClientPrimarySlotID[iClient] = 3;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				PrimaryMenuDraw(iClient);
			}
		}
	}
}

//MG Menu Handler
MGMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //AK-47
			{
				g_iClientPrimarySlotID[iClient] = 4;
				LoadoutMenuDraw(iClient);
			}
			case 1: //M16
			{
				g_iClientPrimarySlotID[iClient] = 5;
				LoadoutMenuDraw(iClient);
			}
			case 2: //SG552
			{
				g_iClientPrimarySlotID[iClient] = 6;
				LoadoutMenuDraw(iClient);
			}
			case 3: //Scar-L
			{
				g_iClientPrimarySlotID[iClient] = 7;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				PrimaryMenuDraw(iClient);
			}
		}
	}
}

//Shotgun Menu Handler
ShotgunMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Remington 870
			{
				g_iClientPrimarySlotID[iClient] = 8;
				LoadoutMenuDraw(iClient);
			}
			case 1: //Remington 870 Custom
			{
				g_iClientPrimarySlotID[iClient] = 9;
				LoadoutMenuDraw(iClient);
			}
			case 2: //Benelli M1014
			{
				g_iClientPrimarySlotID[iClient] = 10;
				LoadoutMenuDraw(iClient);
			}
			case 3: //Franchi SPAS-12
			{
				g_iClientPrimarySlotID[iClient] = 11;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				PrimaryMenuDraw(iClient);
			}
		}
	}
}

//Sniper Menu Handler
SniperMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Ruger Mini-14
			{
				g_iClientPrimarySlotID[iClient] = 12;
				LoadoutMenuDraw(iClient);
			}
			case 1: //H&K MSG90
			{
				g_iClientPrimarySlotID[iClient] = 13;
				LoadoutMenuDraw(iClient);
			}
			case 2: //Scout
			{
				g_iClientPrimarySlotID[iClient] = 14;
				LoadoutMenuDraw(iClient);
			}
			case 3: //AWP
			{
				g_iClientPrimarySlotID[iClient] = 15;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				PrimaryMenuDraw(iClient);
			}
		}
	}
}

//Special Weapons Menu Handler
SpecialMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Grenade Launcher
			{
				g_iClientPrimarySlotID[iClient] = 16;
				LoadoutMenuDraw(iClient);
			}
			case 1: //M60
			{
				g_iClientPrimarySlotID[iClient] = 17;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				PrimaryMenuDraw(iClient);
			}
		}
	}
}

//Sidearms Menu Handler
SidearmMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //P220
			{
				g_iClientSecondarySlotID[iClient] = 1;
				LoadoutMenuDraw(iClient);
			}
			case 1: //Glock + P220
			{
				g_iClientSecondarySlotID[iClient] = 2;
				LoadoutMenuDraw(iClient);
			}
			case 2: //Magnum
			{
				g_iClientSecondarySlotID[iClient] = 3;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				SecondaryMenuDraw(iClient);
			}
		}
	}
}

//Crushing Melee Menu Handler
CrushingMeleeMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Cricket Bat
			{
				g_iClientSecondarySlotID[iClient] = 6;
				LoadoutMenuDraw(iClient);
			}
			case 1: //Electric Guitar
			{
				g_iClientSecondarySlotID[iClient] = 9;
				LoadoutMenuDraw(iClient);
			}
			case 2: //Frying Pan
			{
				g_iClientSecondarySlotID[iClient] = 11;
				LoadoutMenuDraw(iClient);
			}
			case 3: //Nightstick
			{
				g_iClientSecondarySlotID[iClient] = 12;
				LoadoutMenuDraw(iClient);
			}
			case 4: //Golf Club
			{
				g_iClientSecondarySlotID[iClient] = 15;
				LoadoutMenuDraw(iClient);
			}
			// case 5: //Riot Shield
			// {
			// 	g_iClientSecondarySlotID[iClient] = 14;
			// 	LoadoutMenuDraw(iClient);
			// }
			case 5: //Baseball Bat
			{
				g_iClientSecondarySlotID[iClient] = 7;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				SecondaryMenuDraw(iClient);
			}
		}
	}
}

//Slashing Melee Menu Handler
SlashingMeleeMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Axe
			{
				g_iClientSecondarySlotID[iClient] = 4;
				LoadoutMenuDraw(iClient);
			}
			case 1: //Crowbar
			{
				g_iClientSecondarySlotID[iClient] = 5;
				LoadoutMenuDraw(iClient);
			}
			case 2: //Katana
			{
				g_iClientSecondarySlotID[iClient] = 8;
				LoadoutMenuDraw(iClient);
			}
			case 3: //Machete
			{
				g_iClientSecondarySlotID[iClient] = 10;
				LoadoutMenuDraw(iClient);
			}
			case 4: //Pitch Fork
			{
				g_iClientSecondarySlotID[iClient] = 16;
				LoadoutMenuDraw(iClient);
			}
			case 5: //Combat Knife
			{
				g_iClientSecondarySlotID[iClient] = 14;
				LoadoutMenuDraw(iClient);
			}
			case 6: //Chainsaw
			{
				g_iClientSecondarySlotID[iClient] = 13;
				LoadoutMenuDraw(iClient);
			}
			case 8: //Back
			{
				SecondaryMenuDraw(iClient);
			}
		}
	}
}

GetWeaponNames(iClient)
{
	switch(g_iClientPrimarySlotID[iClient])
	{
		case 0: //None
		{
			g_strClientPrimarySlot = "Empty";
			g_iClientPrimarySlotCost[iClient] = 0;
		}
		case 1: //Israeli UZI 
		{
			g_strClientPrimarySlot = "Israeli UZI (55 XP)";
			g_iClientPrimarySlotCost[iClient] = 55;
		}
		case 2: //Mac-10
		{
			g_strClientPrimarySlot = "Silenced MAC-10 (60 XP)";
			g_iClientPrimarySlotCost[iClient] = 60;
		}
		case 3: //MP5
		{
			g_strClientPrimarySlot = "MP5 (70 XP)";
			g_iClientPrimarySlotCost[iClient] = 70;
		}
		case 4: //AK-47
		{
			g_strClientPrimarySlot = "AK-47 (80 XP)";
			g_iClientPrimarySlotCost[iClient] = 80;
		}
		case 5: //M16A2
		{
			g_strClientPrimarySlot = "M16A2 (80 XP)";
			g_iClientPrimarySlotCost[iClient] = 80;
		}
		case 6: //SIG SG 552
		{
			g_strClientPrimarySlot = "SIG SG 552 (100 XP)";
			g_iClientPrimarySlotCost[iClient] = 100;
		}
		case 7: //Scar-L
		{
			g_strClientPrimarySlot = "Scar-L (DEFAULT)";
			g_iClientPrimarySlotCost[iClient] = 0;								// Default Loadout Item
		}
		case 8: //Remington 870
		{
			g_strClientPrimarySlot = "Remington 870 (60 XP)";
			g_iClientPrimarySlotCost[iClient] = 60;
		}
		case 9: //Remington 870 Custom
		{
			g_strClientPrimarySlot = "Remington 870 Custom (60 XP)";
			g_iClientPrimarySlotCost[iClient] = 60;
		}
		case 10: //Benelli M1014
		{
			g_strClientPrimarySlot = "Benelli M1014 (80 XP)";
			g_iClientPrimarySlotCost[iClient] = 80;
		}
		case 11: //Franchi SPAS-12
		{
			g_strClientPrimarySlot = "Franchi SPAS-12 (80 XP)";
			g_iClientPrimarySlotCost[iClient] = 80;
		}
		case 12: //Ruger Mini-14
		{
			g_strClientPrimarySlot = "Ruger Mini-14 (60 XP)";
			g_iClientPrimarySlotCost[iClient] = 60;
		}
		case 13: //H&K MSG90
		{
			g_strClientPrimarySlot = "H&K MSG90 (80 XP)";
			g_iClientPrimarySlotCost[iClient] = 80;
		}
		case 14: //Scout
		{
			g_strClientPrimarySlot = "Scout (60 XP)";
			g_iClientPrimarySlotCost[iClient] = 60;
		}
		case 15: //AWP
		{
			g_strClientPrimarySlot = "AWP (100 XP)";
			g_iClientPrimarySlotCost[iClient] = 100;
		}
		case 16: //Grenade Launcher
		{
			g_strClientPrimarySlot = "Grenade Launcher (400 XP)";
			g_iClientPrimarySlotCost[iClient] = 400;
		}
		case 17: //M60
		{
			g_strClientPrimarySlot = "M60 (500 XP)";
			g_iClientPrimarySlotCost[iClient] = 500;
		}
	}
	switch(g_iClientSecondarySlotID[iClient])
	{
		case 0: //None
		{
			g_strClientSecondarySlot = "Empty";
			g_iClientSecondarySlotCost[iClient] = 0;
		}
		case 1: //P220
		{
			g_strClientSecondarySlot = "P220 (15 XP)";
			g_iClientSecondarySlotCost[iClient] = 15;
		}
		case 2: //Glock + P220
		{
			g_strClientSecondarySlot = "Glock + P220 (30 XP)";
			g_iClientSecondarySlotCost[iClient] = 30;
		}
		case 3: //Magnum
		{
			g_strClientSecondarySlot = "Magnum (40 XP)";
			g_iClientSecondarySlotCost[iClient] = 40;
		}
		case 4: //Axe
		{
			g_strClientSecondarySlot = "Axe (20 XP)";
			g_iClientSecondarySlotCost[iClient] = 20;
		}
		case 5: //Crowbar
		{
			g_strClientSecondarySlot = "Crowbar (20 XP)";
			g_iClientSecondarySlotCost[iClient] = 20;
		}
		case 6: //Cricket Bat
		{
			g_strClientSecondarySlot = "Cricket Bat (25 XP)";
			g_iClientSecondarySlotCost[iClient] = 25;
		}
		case 7: //Baseball Bat
		{
			g_strClientSecondarySlot = "Baseball Bat (25 XP)";
			g_iClientSecondarySlotCost[iClient] = 25;
		}
		case 8: //Katana
		{
			g_strClientSecondarySlot = "Katana (40 XP)";
			g_iClientSecondarySlotCost[iClient] = 40;
		}
		case 9: //Electric Guitar
		{
			g_strClientSecondarySlot = "Electric Guitar (20 XP)";
			g_iClientSecondarySlotCost[iClient] = 20;
		}
		case 10: //Machete
		{
			g_strClientSecondarySlot = "Machete (DEFAULT)";
			g_iClientSecondarySlotCost[iClient] = 0;							// Default Loadout Item
		}
		case 11: //Frying Pan
		{
			g_strClientSecondarySlot = "Frying Pan (20 XP)";
			g_iClientSecondarySlotCost[iClient] = 20;
		}
		case 12: //Nightstick
		{
			g_strClientSecondarySlot = "Nightstick (50 XP)";
			g_iClientSecondarySlotCost[iClient] = 50;
		}
		case 13: //Chainsaw
		{
			g_strClientSecondarySlot = "Chainsaw (250 XP)";
			g_iClientSecondarySlotCost[iClient] = 250;
		}
		// case 14: //Riot Shield
		// {
		// 	g_strClientSecondarySlot = "Riot Shield (30 XP)";
		// 	g_iClientSecondarySlotCost[iClient] = 30;
		// }
		case 14: //Combat Knife
		{
			g_strClientSecondarySlot = "Combat Knife (50 XP)";
			g_iClientSecondarySlotCost[iClient] = 50;
		}
		case 15: //Golf Club
		{
			g_strClientSecondarySlot = "Golf Club (30 XP)";
			g_iClientSecondarySlotCost[iClient] = 30;
		}
		case 16: //Pitch Fork
		{
			g_strClientSecondarySlot = "Pitch Fork (30 XP)";
			g_iClientSecondarySlotCost[iClient] = 30;
		}
	}
	switch(g_iClientExplosiveSlotID[iClient])
	{
		case 0: //None
		{
			g_strClientExplosiveSlot = "Empty";
			g_iClientExplosiveSlotCost[iClient] = 0;
		}
		case 1: //Pipe Bomb
		{
			g_strClientExplosiveSlot = "Pipe Bomb (30 XP)";
			g_iClientExplosiveSlotCost[iClient] = 30;
		}
		case 2: //Molotov
		{
			g_strClientExplosiveSlot = "Molotov (DEFAULT)";
			g_iClientExplosiveSlotCost[iClient] = 0;							// Default Loadout Item
		}
		case 3: //Bile Jar
		{
			g_strClientExplosiveSlot = "Bile Jar (40 XP)";
			g_iClientExplosiveSlotCost[iClient] = 40;
		}
	}
	switch(g_iClientHealthSlotID[iClient])
	{
		case 0: //None
		{
			g_strClientHealthSlot = "Empty";
			g_iClientHealthSlotCost[iClient] = 0;
		}
		case 1: //Med Kit
		{
			g_strClientHealthSlot = "First Aid Kit (DEFAULT)";
			g_iClientHealthSlotCost[iClient] = 0;								// Default Loadout Item
		}
		case 2: //Defib
		{
			g_strClientHealthSlot = "Defibrillator (500 XP)";
			g_iClientHealthSlotCost[iClient] = 500;
		}
		case 3: //Explosive Ammo
		{
			g_strClientHealthSlot = "Explosive Ammo (1000 XP)";
			g_iClientHealthSlotCost[iClient] = 1000;
		}
		case 4: //Incendiary Ammo
		{
			g_strClientHealthSlot = "Incendiary Ammo (500 XP)";
			g_iClientHealthSlotCost[iClient] = 500;
		}
	}
	switch(g_iClientBoostSlotID[iClient])
	{
		case 0: //None
		{
			g_strClientBoostSlot = "Empty";
			g_iClientBoostSlotCost[iClient] = 0;
		}
		case 1: //Pain Pills
		{
			g_strClientBoostSlot = "Pain Pills (DEFAULT)";
			g_iClientBoostSlotCost[iClient] = 0;								// Default Loadout Item
		}
		case 2: //Adrenaline Shot
		{
			g_strClientBoostSlot = "Adrenaline Shot (50 XP)";
			g_iClientBoostSlotCost[iClient] = 50;
		}
	}
	if(g_iClientLaserSlotID[iClient]==0)
	{
		g_strClientLaserSlot = "No";
		g_iClientLaserSlotCost[iClient] = 0;
	}
	else
	{
		g_strClientLaserSlot = "Yes (100 XP)";
		g_iClientLaserSlotCost[iClient] = 100;
	}
	g_iClientTotalXPCost[iClient] = g_iClientPrimarySlotCost[iClient] + g_iClientSecondarySlotCost[iClient] + g_iClientExplosiveSlotCost[iClient] + g_iClientHealthSlotCost[iClient] + g_iClientBoostSlotCost[iClient] + g_iClientLaserSlotCost[iClient];	//add more to this when needed
}

SpawnWeapons(iClient)
{
	if(g_iClientLevel[iClient] < 1)
		g_iClientPreviousLevelXPAmount[iClient] = 0;
		


	
	switch(g_iClientPrimarySlotID[iClient])
	{
		case 0: //None
		{
			
		}
		case 1: //Israeli UZI
		{
			if((g_iClientXP[iClient]-55) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=55;
				RunCheatCommand(iClient, "give", "give smg");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for an \x04Israeli UZI");
		}
		case 2: //Mac-10
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				RunCheatCommand(iClient, "give", "give smg_silenced");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Mac-10");
		}
		case 3: //MP5
		{
			if((g_iClientXP[iClient]-70) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=70;
				RunCheatCommand(iClient, "give", "give smg_mp5");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04MP5");
		}
		case 4: //AK-47
		{
			if((g_iClientXP[iClient]-80) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=80;
				RunCheatCommand(iClient, "give", "give rifle_ak47");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for an \x04Ak-47");
		}
		case 5: //M16A2
		{
			if((g_iClientXP[iClient]-80) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=80;
				RunCheatCommand(iClient, "give", "give rifle");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04M16A2");
		}
		case 6: //SIG SG 552
		{
			if((g_iClientXP[iClient]-100) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=100;
				RunCheatCommand(iClient, "give", "give rifle_sg552");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04SIG SG 552");
		}
		case 7: //Scar-L DEFAULT
		{
			RunCheatCommand(iClient, "give", "give rifle_desert");
			// if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			// {
			// 	g_iClientXP[iClient]-=60;
			// 	RunCheatCommand(iClient, "give", "give rifle_desert");
			// }
			// else
			// 	PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Scar-L");
		}
		case 8: //Remington 870
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				RunCheatCommand(iClient, "give", "give pumpshotgun");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Remington 870");
		}
		case 9: //Remington 870 Custom
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				RunCheatCommand(iClient, "give", "give shotgun_chrome");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Remington 870 Custom");
		}
		case 10: //Benelli M1014
		{
			if((g_iClientXP[iClient]-80) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=80;
				RunCheatCommand(iClient, "give", "give autoshotgun");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Benelli M1014");
		}
		case 11: //Franchi SPAS-12
		{
			if((g_iClientXP[iClient]-80) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=80;
				RunCheatCommand(iClient, "give", "give shotgun_spas");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Franchi SPAS-12");
		}
		case 12: //Ruger Mini-14
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				RunCheatCommand(iClient, "give", "give hunting_rifle");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Ruger Mini-14");
		}
		case 13: //H&K MSG90
		{
			if((g_iClientXP[iClient]-80) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=80;
				RunCheatCommand(iClient, "give", "give sniper_military");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04H&K MSG90");
		}
		case 14: //Scout
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				RunCheatCommand(iClient, "give", "give sniper_scout");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Scout");
		}
		case 15: //AWP
		{
			if((g_iClientXP[iClient]-100) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=100;
				RunCheatCommand(iClient, "give", "give sniper_awp");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for an \x04AWP");
		}
		case 16: //Grenade Launcher
		{
			if((g_iClientXP[iClient]-400) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=400;
				RunCheatCommand(iClient, "give", "give grenade_launcher");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Grenade Launcher");
		}
		case 17: //M60
		{
			if((g_iClientXP[iClient]-500) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=500;
				RunCheatCommand(iClient, "give", "give rifle_m60");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for an \x04M60");
		}
	}
	switch(g_iClientSecondarySlotID[iClient])
	{
		case 0: //None
		{
			
		}
		case 1: //P220
		{
			if((g_iClientXP[iClient]-15) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=15;
				RunCheatCommand(iClient, "give", "give pistol");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04p220");
		}
		case 2: //Glock + P220
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give pistol");
				RunCheatCommand(iClient, "give", "give pistol");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for the \x04p220 and Glock");
		}
		case 3: //Magnum
		{
			if((g_iClientXP[iClient]-40) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=40;
				RunCheatCommand(iClient, "give", "give pistol_magnum");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Magnum");
		}
		case 4: //Axe
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give fireaxe");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Fireaxe");
		}
		case 5: //Crowbar
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give crowbar");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Crowbar");
		}
		case 6: //Cricket Bat
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give cricket_bat");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Cricket Bat");
		}
		case 7: //Baseball Bat
		{
			if((g_iClientXP[iClient]-50) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=50;
				RunCheatCommand(iClient, "give", "give baseball_bat");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Baseball Bat");
		}
		case 8: //Katana
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give katana");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Katana");
		}
		case 9: //Electric Guitar
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give electric_guitar");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for an \x04Electric Guitar");
		}
		case 10: //Machete DEFAULT
		{
			RunCheatCommand(iClient, "give", "give machete");
			// if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			// {
			// 	g_iClientXP[iClient]-=30;
			// 	RunCheatCommand(iClient, "give", "give machete");
			// }
			// else
			// 	PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Machete");
		}
		case 11: //Frying Pan
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give frying_pan");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Frying Pan");
		}
		case 12: //Nightstick
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give tonfa");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Nightstick");
		}
		case 13: //Chainsaw
		{
			if((g_iClientXP[iClient]-250) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=250;
				RunCheatCommand(iClient, "give", "give chainsaw");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Chainsaw");
		}
		// case 14: //Riot Shield
		// {
		// 	if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
		// 	{
		// 		g_iClientXP[iClient]-=30;
		// 		RunCheatCommand(iClient, "give", "give riotshield");
		// 	}
		// 	else
		// 		PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Riot Shield");
		// }
		case 14: //Combat Knife
		{
			if((g_iClientXP[iClient]-50) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=50;
				RunCheatCommand(iClient, "give", "give knife");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Combat Knife");
		}
		case 15: //Golf Club
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give golfclub");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Golf Club");
		}
		case 16: //Pitch Fork
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give pitchfork");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Pitch Fork");
		}
	}
	switch(g_iClientExplosiveSlotID[iClient])
	{
		case 0: //None
		{
			
		}
		case 1: //Pipe Bomb
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				RunCheatCommand(iClient, "give", "give pipe_bomb");
				if(g_iStrongLevel[iClient] > 0)
				{
					g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
				}
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Pipe Bomb");
		}
		case 2: //Molotov DEFAULT
		{
			RunCheatCommand(iClient, "give", "give molotov");
			if(g_iStrongLevel[iClient] > 0)
				g_strCoachGrenadeSlot1 = "weapon_molotov";
			// if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			// {
			// 	g_iClientXP[iClient]-=30;
			// 	RunCheatCommand(iClient, "give", "give molotov");
			// 	if(g_iStrongLevel[iClient] > 0)
			// 	{
			// 		g_strCoachGrenadeSlot1 = "weapon_molotov";
			// 	}
			// }
			// else
			// 	PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Molotov");
		}
		case 3: //Bile Jar
		{
			if((g_iClientXP[iClient]-40) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=40;
				RunCheatCommand(iClient, "give", "give vomitjar");
				if(g_iStrongLevel[iClient] > 0)
				{
					g_strCoachGrenadeSlot1 = "weapon_vomitjar";
				}
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Bile Jar");
		}
	}
	switch(g_iClientHealthSlotID[iClient])
	{
		case 0: //None
		{
			
		}
		case 1: //Med Kit DEFAULT
		{
			RunCheatCommand(iClient, "give", "give first_aid_kit");
			// if((g_iClientXP[iClient] - 250) >= g_iClientPreviousLevelXPAmount[iClient])
			// {
			// 	g_iClientXP[iClient] -= 250;
			// 	RunCheatCommand(iClient, "give", "give first_aid_kit");
			// }
			// else
			// 	PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04First Aid Kit");
		}
		case 2: //Defib
		{
			if((g_iClientXP[iClient] - 500) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient] -= 500;
				RunCheatCommand(iClient, "give", "give defibrillator");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Defibrillator");
		}
		case 3: //Explosive Ammo
		{
			if((g_iClientXP[iClient] - 1000) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient] -= 1000;
				RunCheatCommand(iClient, "give", "give upgradepack_explosive");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for \x04Explosive Ammo");
		}
		case 4: //Incendiary Ammo
		{
			if((g_iClientXP[iClient] - 500) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient] -= 500;
				RunCheatCommand(iClient, "give", "give upgradepack_incendiary");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for \x04Incendiary Ammo");
		}
	}
	switch(g_iClientBoostSlotID[iClient])
	{
		case 0: //None
		{
			
		}
		case 1: //Pain Pills DEFAULT
		{
			RunCheatCommand(iClient, "give", "give pain_pills");
			// if((g_iClientXP[iClient]-50) >= g_iClientPreviousLevelXPAmount[iClient])
			// {
			// 	g_iClientXP[iClient]-=50;
			// 	RunCheatCommand(iClient, "give", "give pain_pills");
			// }
			// else
			// 	PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for \x04Pain Pills");
		}
		case 2: //Adrenaline Shot
		{
			if((g_iClientXP[iClient]-50) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=50;
				RunCheatCommand(iClient, "give", "give adrenaline");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for an \x04Adrenaline Shot");
		}
	}
	if(g_iClientLaserSlotID[iClient]==1)
	{
		if((g_iClientXP[iClient]-100) >= g_iClientPreviousLevelXPAmount[iClient])
		{
			g_iClientXP[iClient]-=100;
			RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");
		}
		else
			PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Laser Sight");
	}
}