SetupLoadouts()
{
	g_iFlag_Give 			= GetCommandFlags("give");
	g_iFlag_UpgradeAdd 		= GetCommandFlags("upgrade_add");
	//g_iFlag_UpgradeRemove 	= GetCommandFlags("upgrade_remove");
	
	for(new i=0;i<MAXPLAYERS;i++)			//need to reset these when player disconnects and probably somewhere else
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

public Action:LoadoutMenuDrawSetup(iClient,args)
{
	if(IsClientInGame(iClient))
		LoadoutMenuDraw(iClient);
	
	return Plugin_Handled;
}

//Draw Menus
public Action:LoadoutMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(LoadoutMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	GetWeaponNames(iClient);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	new totalcostid = g_iClientTotalXPCost[iClient]; 
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP (XP - Current Level XP):	%d\n \n*Note: You get this equipment on confirmation*\n \nPrimary:			  %s\nSecondary:		 %s\nExplosive:			%s\nHealth/Ammo:	 %s\nHealth Boost:	  %s\nLaser Sight:		%s\n_	_	_	_	_	_	_	_	_	_	_	_	_\nTotal Cost Per Round:	%d\n ",g_iClientUsableXP, g_strClientPrimarySlot, g_strClientSecondarySlot, g_strClientExplosiveSlot, g_strClientHealthSlot, g_strClientBoostSlot, g_strClientLaserSlot, totalcostid);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Primary Slot");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Secondary Slot");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Explosives Slot");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Health/Ammo Slot");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Health Boost Slot");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Laser Sight");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Reset All");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "Back");
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option10", "Exit Menu\n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public Action:PrimaryMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(PrimaryMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nSelect the Class of Weapon:", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Sub-Machine Guns");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Assault Rifles");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Shotguns");	
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Sniper Rifles");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Special Weapons");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "None");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public Action:SecondaryMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(SecondaryMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nSelect the Class of Weapon:",g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Sidearms");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Slashing Weapons");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Crushing Weapons");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "None");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public Action:ExplosivesMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ExplosivesMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nSelect Explosive:", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", " Pipe Bomb (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Molotov (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Bile Jar (40 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "None");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public Action:HealthMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(HealthMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nSelect Relief Supplies:", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "First Aid Kit (250 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Defibrillator (500 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Explosive Ammo (1000 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Incendiary Ammo (500 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "None");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public Action:BoostMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(BoostMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nSelect Enhancement:", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Pain Pills (50 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Adrenaline Shot (50 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "None");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public Action:CleanMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(CleanMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nReset Your Equipment Loadout?", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Yes");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "No");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//SubMachine Gun Draw
public Action:SMGMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(SMGMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nSub-Machine Guns\n", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Israeli UZI (55 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Silenced Mac-10 (60 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "MP5 (70 XP)");	
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Machine Gun Draw
public Action:MGMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(MGMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nAssault Rifles\n", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "AK-47 (80 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "M16A2 (80 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "SIG SG 552 (100 XP)");	
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "SCAR-L (60 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Shotgun Gun Draw
public Action:ShotgunMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ShotgunMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nShotguns\n", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Remington 870 (60 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Remington 870 Custom (60 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Benelli M1014 (80 XP)");	
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Franchi SPAS-12 (80 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Sniper Gun Draw
public Action:SniperMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(SniperMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nSniper Rifles\n", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Ruger Mini-14 (60 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "H&K MSG90 (80 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Scout (60 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "AWP (100 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Special Weapons Gun Draw
public Action:SpecialMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(SpecialMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nSpecial Weapons\n", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Grenade Launcher (400 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "M60 Machine Gun (500 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Chainsaw Gun Draw
public Action:CrushingMeleeMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(CrushingMeleeMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nCrushing Melee Weapons\n", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option0", "Cricket Bat (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Electric Guitar (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Frying Pan (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Nightstick (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Golf Club (30 XP)");
	//AddMenuItem(g_hMenu_XPM[iClient], "option5", "Riot Shield (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Baseball Bat (50 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Sidearms Gun Draw
public Action:SidearmMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(SidearmMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nSidearms\n", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "P220 (15 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Glock + P220 (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Magnum (40 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Melee Gun Draw
public Action:SlashingMeleeMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(SlashingMeleeMenuHandler);
	g_iClientLevel[iClient] = g_iClientLevel[iClient];
	
	if(g_iClientLevel[iClient]>0)
		g_iClientUsableXP = g_iClientXP[iClient] - g_iClientPreviousLevelXPAmount[iClient];
	else
		g_iClientUsableXP = g_iClientXP[iClient];
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Usable XP: %d\n \nSlashing Melee Weapons\n", g_iClientUsableXP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Axe (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Crowbar (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Katana (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Machete (30 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Combat Knife (50 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Chainsaw (250 XP)");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

//Menu Handlers

//Loadout Menu Handler(MAIN)
public LoadoutMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 7: //Back
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
public PrimaryMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 6: //Back
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//Secondary Slots Menu Handler
public SecondaryMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 4: //Back
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//Explosive Slots Menu Handler
public ExplosivesMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 4: //Back
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//Health Slots Menu Handler
public HealthMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 5: //Back
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//Boost Slots Menu Handler
public BoostMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 3: //Back
			{
				LoadoutMenuDraw(iClient);
			}
		}
	}
}

//Clean Loadout Menu Handler
public CleanMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
public SMGMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 3: //Back
			{
				PrimaryMenuDraw(iClient);
			}
		}
	}
}

//MG Menu Handler
public MGMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 4: //Back
			{
				PrimaryMenuDraw(iClient);
			}
		}
	}
}

//Shotgun Menu Handler
public ShotgunMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 4: //Back
			{
				PrimaryMenuDraw(iClient);
			}
		}
	}
}

//Sniper Menu Handler
public SniperMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 4: //Back
			{
				PrimaryMenuDraw(iClient);
			}
		}
	}
}

//Special Weapons Menu Handler
public SpecialMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 2: //Back
			{
				PrimaryMenuDraw(iClient);
			}
		}
	}
}

//Sidearms Menu Handler
public SidearmMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 3: //Back
			{
				SecondaryMenuDraw(iClient);
			}
		}
	}
}

//Crushing Melee Menu Handler
public CrushingMeleeMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
				g_iClientSecondarySlotID[iClient] = 16;
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
			case 6: //Back
			{
				SecondaryMenuDraw(iClient);
			}
		}
	}
}

//Slashing Melee Menu Handler
public SlashingMeleeMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
			case 4: //Combat Knife
			{
				g_iClientSecondarySlotID[iClient] = 14;
				LoadoutMenuDraw(iClient);
			}
			case 5: //Chainsaw
			{
				g_iClientSecondarySlotID[iClient] = 13;
				LoadoutMenuDraw(iClient);
			}
			case 6: //Back
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
			g_strClientPrimarySlot = "Scar-L (60 XP)";
			g_iClientPrimarySlotCost[iClient] = 60;
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
			g_strClientSecondarySlot = "Machete (50 XP)";
			g_iClientSecondarySlotCost[iClient] = 50;
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
			g_strClientExplosiveSlot = "Molotov (30 XP)";
			g_iClientExplosiveSlotCost[iClient] = 30;
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
			g_strClientHealthSlot = "First Aid Kit (250 XP)";
			g_iClientHealthSlotCost[iClient] = 250;
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
			g_strClientBoostSlot = "Pain Pills (50 XP)";
			g_iClientBoostSlotCost[iClient] = 50;
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
		
	SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
	SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd & ~FCVAR_CHEAT);
	
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
				FakeClientCommand(iClient, "give smg");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for an \x04Israeli UZI");
		}
		case 2: //Mac-10
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				FakeClientCommand(iClient, "give smg_silenced");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Mac-10");
		}
		case 3: //MP5
		{
			if((g_iClientXP[iClient]-70) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=70;
				FakeClientCommand(iClient, "give smg_mp5");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04MP5");
		}
		case 4: //AK-47
		{
			if((g_iClientXP[iClient]-80) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=80;
				FakeClientCommand(iClient, "give rifle_ak47");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for an \x04Ak-47");
		}
		case 5: //M16A2
		{
			if((g_iClientXP[iClient]-80) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=80;
				FakeClientCommand(iClient, "give rifle");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04M16A2");
		}
		case 6: //SIG SG 552
		{
			if((g_iClientXP[iClient]-100) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=100;
				FakeClientCommand(iClient, "give rifle_sg552");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04SIG SG 552");
		}
		case 7: //Scar-L
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				FakeClientCommand(iClient, "give rifle_desert");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Scar-L");
		}
		case 8: //Remington 870
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				FakeClientCommand(iClient, "give pumpshotgun");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Remington 870");
		}
		case 9: //Remington 870 Custom
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				FakeClientCommand(iClient, "give shotgun_chrome");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Remington 870 Custom");
		}
		case 10: //Benelli M1014
		{
			if((g_iClientXP[iClient]-80) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=80;
				FakeClientCommand(iClient, "give autoshotgun");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Benelli M1014");
		}
		case 11: //Franchi SPAS-12
		{
			if((g_iClientXP[iClient]-80) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=80;
				FakeClientCommand(iClient, "give shotgun_spas");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Franchi SPAS-12");
		}
		case 12: //Ruger Mini-14
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				FakeClientCommand(iClient, "give hunting_rifle");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Ruger Mini-14");
		}
		case 13: //H&K MSG90
		{
			if((g_iClientXP[iClient]-80) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=80;
				FakeClientCommand(iClient, "give sniper_military");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04H&K MSG90");
		}
		case 14: //Scout
		{
			if((g_iClientXP[iClient]-60) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=60;
				FakeClientCommand(iClient, "give sniper_scout");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Scout");
		}
		case 15: //AWP
		{
			if((g_iClientXP[iClient]-100) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=100;
				FakeClientCommand(iClient, "give sniper_awp");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for an \x04AWP");
		}
		case 16: //Grenade Launcher
		{
			if((g_iClientXP[iClient]-400) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=400;
				FakeClientCommand(iClient, "give grenade_launcher");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Grenade Launcher");
		}
		case 17: //M60
		{
			if((g_iClientXP[iClient]-500) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=500;
				FakeClientCommand(iClient, "give rifle_m60");
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
				FakeClientCommand(iClient, "give pistol");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04p220");
		}
		case 2: //Glock + P220
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give pistol");
				FakeClientCommand(iClient, "give pistol");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for the \x04p220 and Glock");
		}
		case 3: //Magnum
		{
			if((g_iClientXP[iClient]-40) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=40;
				FakeClientCommand(iClient, "give pistol_magnum");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Magnum");
		}
		case 4: //Axe
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give fireaxe");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Fireaxe");
		}
		case 5: //Crowbar
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give crowbar");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Crowbar");
		}
		case 6: //Cricket Bat
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give cricket_bat");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Cricket Bat");
		}
		case 7: //Baseball Bat
		{
			if((g_iClientXP[iClient]-50) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=50;
				FakeClientCommand(iClient, "give baseball_bat");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Baseball Bat");
		}
		case 8: //Katana
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give katana");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Katana");
		}
		case 9: //Electric Guitar
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give electric_guitar");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for an \x04Electric Guitar");
		}
		case 10: //Machete
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give machete");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Machete");
		}
		case 11: //Frying Pan
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give frying_pan");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Frying Pan");
		}
		case 12: //Nightstick
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give tonfa");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Nightstick");
		}
		case 13: //Chainsaw
		{
			if((g_iClientXP[iClient]-250) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=250;
				FakeClientCommand(iClient, "give chainsaw");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Chainsaw");
		}
		// case 14: //Riot Shield
		// {
		// 	if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
		// 	{
		// 		g_iClientXP[iClient]-=30;
		// 		FakeClientCommand(iClient, "give riotshield");
		// 	}
		// 	else
		// 		PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Riot Shield");
		// }
		case 14: //Combat Knife
		{
			if((g_iClientXP[iClient]-50) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=50;
				FakeClientCommand(iClient, "give knife");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Combat Knife");
		}
		case 15: //Golf Club
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give golfclub");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Golf Club");
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
				FakeClientCommand(iClient, "give pipe_bomb");
				if(g_iStrongLevel[iClient] > 0)
				{
					g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
				}
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Pipe Bomb");
		}
		case 2: //Molotov
		{
			if((g_iClientXP[iClient]-30) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=30;
				FakeClientCommand(iClient, "give molotov");
				if(g_iStrongLevel[iClient] > 0)
				{
					g_strCoachGrenadeSlot1 = "weapon_molotov";
				}
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Molotov");
		}
		case 3: //Bile Jar
		{
			if((g_iClientXP[iClient]-40) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=40;
				FakeClientCommand(iClient, "give vomitjar");
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
		case 1: //Med Kit
		{
			if((g_iClientXP[iClient] - 250) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient] -= 250;
				FakeClientCommand(iClient, "give first_aid_kit");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04First Aid Kit");
		}
		case 2: //Defib
		{
			if((g_iClientXP[iClient] - 500) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient] -= 500;
				FakeClientCommand(iClient, "give defibrillator");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Defibrillator");
		}
		case 3: //Explosive Ammo
		{
			if((g_iClientXP[iClient] - 1000) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient] -= 1000;
				FakeClientCommand(iClient, "give upgradepack_explosive");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for \x04Explosive Ammo");
		}
		case 4: //Incendiary Ammo
		{
			if((g_iClientXP[iClient] - 500) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient] -= 500;
				FakeClientCommand(iClient, "give upgradepack_incendiary");
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
		case 1: //Pain Pills
		{
			if((g_iClientXP[iClient]-50) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=50;
				FakeClientCommand(iClient, "give pain_pills");
			}
			else
				PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for \x04Pain Pills");
		}
		case 2: //Adrenaline Shot
		{
			if((g_iClientXP[iClient]-50) >= g_iClientPreviousLevelXPAmount[iClient])
			{
				g_iClientXP[iClient]-=50;
				FakeClientCommand(iClient, "give adrenaline");
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
			FakeClientCommand(iClient, "upgrade_add LASER_SIGHT");
		}
		else
			PrintToChat(iClient, "\x03[XPMod] \x05You dont have enough usable XP for a \x04Laser Sight");
	}
	
	SetCommandFlags("give", g_iFlag_Give);			//Turn off the cheats here
	SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd);
}