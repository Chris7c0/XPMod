public Action:Event_WeaponFire(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	
	//Delete the players particle menu (VGUI) if its open and firing their weapon
	if(g_bEnabledVGUI[iClient] == true && g_bShowingVGUI[iClient] == true)
		DeleteAllMenuParticles(iClient);
		
	decl String:wclass[32];
	GetEventString(hEvent,"weapon",wclass,32);
	
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill Firing
		{
		
		}
		case 1:		//Rochelle Firing
		{
		
		}
		case 2:		//Coach Firing
		{
		
		}
		case 3:		//Ellis Firing
		{
			if((StrEqual(g_strEllisPrimarySlot1, "empty", false) == true) || (StrEqual(g_strEllisPrimarySlot2, "empty", false) == true))
			{
				fnc_DeterminePrimaryWeapon(iClient);
				if((StrContains(g_strCurrentWeapon, "rifle", false) != -1) || (StrContains(g_strCurrentWeapon, "smg", false) != -1) || (StrContains(g_strCurrentWeapon, "shotgun", false) != -1) || (StrContains(g_strCurrentWeapon, "launcher", false) != -1) || (StrContains(g_strCurrentWeapon, "sniper", false) != -1))
				{
					fnc_SaveAmmo(iClient);
				}
			}
			new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (IsValidEntity(ActiveWeaponID) == false)
				return Plugin_Continue;
			new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");

			if((CurrentClipAmmo == 0) || (CurrentClipAmmo == 1))
			{
				fnc_DeterminePrimaryWeapon(iClient);
				if(g_iReserveAmmo[iClient] == 0)
				{
					//PrintToChatAll("Ammo is now 0");
					if((g_iEllisCurrentPrimarySlot[iClient] == 0) && (StrEqual(g_strEllisPrimarySlot2, "empty", false) == false) && ((g_iEllisPrimarySavedClipSlot2[iClient] > 0) || (g_iEllisPrimarySavedAmmoSlot2[iClient] > 0)))
					{
						//fnc_DeterminePrimaryWeapon(iClient);
						if((StrContains(g_strCurrentWeapon, "rifle", false) != -1) || (StrContains(g_strCurrentWeapon, "smg", false) != -1) || (StrContains(g_strCurrentWeapon, "shotgun", false) != -1) || (StrContains(g_strCurrentWeapon, "launcher", false) != -1) || (StrContains(g_strCurrentWeapon, "sniper", false) != -1))
						{
							g_bIsEllisCyclingEmptyWeapon[iClient] = true;
							fnc_SaveAmmo(iClient);
							fnc_CycleWeapon(iClient);
							//fnc_SetAmmo(iClient);
						}
					}
					else if((g_iEllisCurrentPrimarySlot[iClient] == 1) && (StrEqual(g_strEllisPrimarySlot1, "empty", false) == false) && ((g_iEllisPrimarySavedClipSlot1[iClient] > 0) || (g_iEllisPrimarySavedAmmoSlot1[iClient] > 0)))
					{
						//fnc_DeterminePrimaryWeapon(iClient);
						if((StrContains(g_strCurrentWeapon, "rifle", false) != -1) || (StrContains(g_strCurrentWeapon, "smg", false) != -1) || (StrContains(g_strCurrentWeapon, "shotgun", false) != -1) || (StrContains(g_strCurrentWeapon, "launcher", false) != -1) || (StrContains(g_strCurrentWeapon, "sniper", false) != -1))
						{
							g_bIsEllisCyclingEmptyWeapon[iClient] = true;
							fnc_SaveAmmo(iClient);
							fnc_CycleWeapon(iClient);
							//fnc_SetAmmo(iClient);
						}
					}
				}
			}
			/*
			decl String:currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			//PrintToChatAll("Current Weapon is %s", currentweapon);
			new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
			
			if((CurrentClipAmmo == 0) || (CurrentClipAmmo == 1))
			//if((CurrentClipAmmo == 0) || (CurrentClipAmmo == 1))
			//MAKE SURE TO CHECK IF THIS IS A WEAPON TOO, IT IS RUNNING ON WEAPON FIRE FROM MOLOTOVS AND ETC.
			{
				//PrintToChatAll("CurrentClipAmmo is 1 or 0");
				
				if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
				{
					
				}
				
				if((g_iEllisCurrentPrimarySlot[iClient] == 0) && (StrEqual(g_strEllisPrimarySlot2, "empty", false) == false) && ((g_iEllisPrimarySavedClipSlot2[iClient] != 0) && (g_iEllisPrimarySavedAmmoSlot2[iClient] != 0)))
				{
					if(StrEqual(g_strEllisPrimarySlot2, "weapon_autoshotgun", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give autoshotgun");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_grenade_launcher", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give grenade_launcher");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 68, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_hunting_rifle", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give hunting_rifle");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 36, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_pumpshotgun", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give pumpshotgun");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give rifle");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_ak47", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give rifle_ak47");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_desert", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give rifle_desert");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_m60", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give rifle_m60");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						//SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_sg552", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give rifle_sg552");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_shotgun_chrome", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give shotgun_chrome");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_shotgun_spas", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give shotgun_spas");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_smg", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give smg");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_smg_mp5", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give smg_mp5");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_smg_silenced", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give smg_silenced");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_sniper_awp", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give sniper_awp");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_sniper_military", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give sniper_military");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					else if(StrEqual(g_strEllisPrimarySlot2, "weapon_sniper_scout", false) == true)
					{
						RemoveEdict(ActiveWeaponID);
						g_iEllisCurrentPrimarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give sniper_scout");
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
					}
					g_iEllisCurrentPrimarySlot[iClient] = 1;
				}
			}
			*/
		}
		case 4:		//Nick Firing
		{
			fnc_DeterminePrimaryWeapon(iClient);
			if((g_bRamboModeActive[iClient] == true) && (StrEqual(g_strCurrentWeapon, "weapon_rifle_m60", false) == true))
			{
				//PrintToChatAll("Nick is firing with m60 and rambo mode");
				SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", 251);
			}
			//g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
			GetClientWeapon(iClient, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
			if((StrEqual(g_strCurrentWeapon, "weapon_pistol_magnum", false) == true) && (g_iMagnumLevel[iClient] > 0))
			{
				//PrintToChatAll("Weapon is magnum && Magnum level > 0");
				g_iActiveWeaponID[iClient] = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
				g_iCurrentClipAmmo[iClient] = GetEntProp(g_iActiveWeaponID[iClient],Prop_Data,"m_iClip1");
				if(g_iCurrentClipAmmo[iClient] > 3)
				{
					//PrintToChatAll("Magnums current clip ammo is greater than 3");
					SetEntData(g_iActiveWeaponID[iClient], g_iOffset_Clip1, 3, true);
				}
				g_iNickMagnumShotCountCap[iClient]++;
				//PrintToChatAll("g_iNickMagnumShotCountCap %d", g_iNickMagnumShotCountCap[iClient]);
			}
		}
	}
	
	if(g_bClientIsReloading[iClient] == true)
	{
		g_iReloadFrameCounter[iClient]++;
		// PrintToChatAll("Frame counter %d", g_iReloadFrameCounter[iClient]);
		decl String:currentweapon[32];
		GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
		//PrintToChatAll("Current Weapon is %s", currentweapon);
		new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
		new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
		new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
		
		switch(g_iChosenSurvivor[iClient])
		{
			case 0:		//Bill Reload
			{
				//if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
				//if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo != 0))
				if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)|| (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
				{
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
					if(iAmmo >= (g_iPromotionalLevel[iClient]*20))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, CurrentClipAmmo + (g_iPromotionalLevel[iClient]*20), true);
						SetEntData(iClient, iOffset_Ammo + 12, iAmmo - (g_iPromotionalLevel[iClient]*20));
						g_bClientIsReloading[iClient] = false;
						g_iReloadFrameCounter[iClient] = 0;
						//PrintToChatAll("Clip Set");
					}
					else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
					{
						new NewAmmo = ((g_iPromotionalLevel[iClient]*20) - iAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iPromotionalLevel[iClient]*20) - NewAmmo)), true);
						SetEntData(iClient, iOffset_Ammo + 12, 0);
						g_bClientIsReloading[iClient] = false;
						g_iReloadFrameCounter[iClient] = 0;
						//PrintToChatAll("Clip Set");
					}
				}
			}
			case 1:		//Rochelle Reload
			{
				if((StrEqual(currentweapon, "weapon_hunting_rifle", false) == true) && (g_iSilentLevel[iClient] > 0) && (CurrentClipAmmo != 0))
				{
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);	//for hunting rifle (+36)
					if((iAmmo + CurrentClipAmmo) > (17 - (g_iSilentLevel[iClient] * 2)))
					{
						SetEntData(iClient, iOffset_Ammo + 36, iAmmo + (CurrentClipAmmo - (17 - (g_iSilentLevel[iClient] * 2))));
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, 17 - (g_iSilentLevel[iClient] * 2), true);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
				if((StrEqual(currentweapon, "weapon_sniper_awp", false) == true) && (g_iSilentLevel[iClient] > 0) && (CurrentClipAmmo != 0))
				{
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
					if((iAmmo + CurrentClipAmmo) > 3)
					{
						SetEntData(iClient, iOffset_Ammo + 40, iAmmo + (CurrentClipAmmo - 3));
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, 3, true);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
				if((StrEqual(currentweapon, "weapon_sniper_scout", false) == true) && (g_iSilentLevel[iClient] > 0) && (CurrentClipAmmo != 0))
				{
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
					if((iAmmo + CurrentClipAmmo) > (20 - g_iSilentLevel[iClient]))
					{
						SetEntData(iClient, iOffset_Ammo + 40, iAmmo + (CurrentClipAmmo - (20 - g_iSilentLevel[iClient])));
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (20 - g_iSilentLevel[iClient]), true);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
				if((StrEqual(currentweapon, "weapon_sniper_military", false) == true) && (g_iSilentLevel[iClient] > 0))
				{
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
					if(iAmmo >= (g_iSilentLevel[iClient] * 6))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, CurrentClipAmmo + (g_iSilentLevel[iClient] * 6), true);
						SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iSilentLevel[iClient] * 6));
					}
					else if(iAmmo < (g_iSilentLevel[iClient] * 6))
					{
						new NewAmmo = ((g_iSilentLevel[iClient] * 6) - iAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iSilentLevel[iClient] * 6) - NewAmmo)), true);
						SetEntData(iClient, iOffset_Ammo + 40, 0);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
			}
			case 2:		//Coach Reload
			{
				if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true)) && (g_iSprayLevel[iClient] > 0))
				{
					/*
					if(g_bCoachShotgunForceReload[iClient] == true)
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iCoachShotgunSavedAmmo[iClient], true);
						//PrintToChatAll("g_iOffset_Clip1 %d", g_iOffset_Clip1);
						//PrintToChatAll("g_iCoachShotgunSavedAmmo %d", g_iCoachShotgunSavedAmmo[iClient]);
						g_bCoachShotgunForceReload[iClient] = false;
					}
					*/
					/*
					if(g_iReloadFrameCounter[iClient] == 1)
					{
						SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, ((g_iSprayLevel[iClient] * 2) + 8) - CurrentClipAmmo, true);
						//PrintToChatAll("g_iOffset_ReloadNumShells");
					}
					if(CurrentClipAmmo == (8 + (g_iSprayLevel[iClient] * 2)))
					{
						g_bCoachShotgunForceReload[iClient] = false;
						g_bClientIsReloading[iClient] = false;
						g_iReloadFrameCounter[iClient] = 0;
					}
					*/
					//SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, 18, true);
					//SetEntData(ActiveWeaponID, g_iOffset_ShellsInserted, 1, true);
					//g_iOffset_ShellsInserted
					//new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);	//for pump shotguns (+28)
					/*
					if(g_iReloadFrameCounter[iClient] == 1)
					{
						new IncreasedClipAmmo = CurrentClipAmmo + 1;
					}
					*/
					/*
					//PrintToChatAll("Coach and shotgun detected");
					if((CurrentClipAmmo == g_iCoachShotgunIncreasedAmmo[iClient]) && (g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) < (8 + g_iSprayLevel[iClient]))
					{
						g_iCoachShotgunAmmoCounter[iClient]++;
						g_iCoachShotgunIncreasedAmmo[iClient] = CurrentClipAmmo + 1;
						//PrintToChatAll("Ammo Counter Increased = %d", g_iCoachShotgunAmmoCounter[iClient]);
					}
					else if((g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) == (8 + g_iSprayLevel[iClient]))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]), true);
						//PrintToChatAll("Clip is full, setting clip size");
						g_bClientIsReloading[iClient] = false;
						g_iReloadFrameCounter[iClient] = 0;
					}
					if(CurrentClipAmmo <= 7 && ((g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) < (8 + g_iSprayLevel[iClient])))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, 1, true);
						//PrintToChatAll("Clip = 9 and Bullets < 18, CurrentClipAmmo = %d", CurrentClipAmmo);
						g_iCoachShotgunIncreasedAmmo[iClient] = CurrentClipAmmo + 1;
						//PrintToChatAll("Clip = 9 and Bullets < 18, IncreasedAmmo = %d", g_iCoachShotgunIncreasedAmmo[iClient]);
					}
					*/
					/*
					else if((g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) == (8 + g_iSprayLevel[iClient]))
					{
						
					}
					
					new IncreasedClipAmmo = CurrentClipAmmo + 1;
					if(CurrentClipAmmo < (8 + (g_iSprayLevel[iClient] * 2)))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
						SetEntData(iClient, iOffset_Ammo + 28, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
					}
					else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
					{
						new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
						SetEntData(iClient, iOffset_Ammo + 28, 0);
					}
					*/
					
				}
				/*
				if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (g_iSprayLevel[iClient] > 0))
				{
					if(g_iReloadFrameCounter[iClient] == 1)
					{
						SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, ((g_iSprayLevel[iClient] * 2) + 10) - CurrentClipAmmo, true);
						//PrintToChatAll("g_iOffset_ReloadNumShells");
					}
					if(CurrentClipAmmo == (10 + (g_iSprayLevel[iClient] * 2)))
					{
						g_bCoachShotgunForceReload[iClient] = false;
						g_bClientIsReloading[iClient] = false;
						g_iReloadFrameCounter[iClient] = 0;
					}
				}
				*/
				/*
				if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (CurrentClipAmmo == 10))
				{
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);	//for auto shotguns (+32)
					if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
						SetEntData(iClient, iOffset_Ammo + 32, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
					}
					else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
					{
						new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
						SetEntData(iClient, iOffset_Ammo + 32, 0);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
				*/
			}
			case 3:		//Ellis Reload
			{
				if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
				{
					/*
					decl iDefaultClip;
					if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true))
					{
						iDefaultClip = 50;
					}
					else if(StrEqual(currentweapon, "weapon_rifle_ak47", false) == true)
					{
						iDefaultClip = 40;
					}
					else if(StrEqual(currentweapon, "weapon_rifle_desert", false) == true)
					{
						iDefaultClip = 60;
					}
					new iMissingAmmo = (iDefaultClip - CurrentClipAmmo);
					//PrintToChatAll("iMissingAmmo = %d", iMissingAmmo);
					*/
					//PrintToChatAll("currentclipammo = %d", CurrentClipAmmo);
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
					if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						//SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iMissingAmmo), true);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6), true);
						SetEntData(iClient, iOffset_Ammo + 12, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
					}
					else if(iAmmo < (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
						//SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo - iMissingAmmo), true);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo), true);
						SetEntData(iClient, iOffset_Ammo + 12, 0);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
				if((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true))
				{
					/*
					new iDefaultClip = 50;
					new iMissingAmmo = (iDefaultClip - CurrentClipAmmo);
					*/
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);	//for smg (+20)
					if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6), true);
						SetEntData(iClient, iOffset_Ammo + 20, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
					}
					else if(iAmmo < (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
						SetEntData(iClient, iOffset_Ammo + 20, 0);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
				if(StrEqual(currentweapon, "weapon_hunting_rifle", false) == true)
				{
					/*
					new iDefaultClip = 15;
					new iMissingAmmo = (iDefaultClip - CurrentClipAmmo);
					*/
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);	//for hunting rifle (+36)
					if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6), true);
						SetEntData(iClient, iOffset_Ammo + 36, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
					}
					else if(iAmmo < (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
						SetEntData(iClient, iOffset_Ammo + 36, 0);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
				if((StrEqual(currentweapon, "weapon_sniper_awp", false) == true) || (StrEqual(currentweapon, "weapon_sniper_military", false) == true) || (StrEqual(currentweapon, "weapon_sniper_scout", false) == true))
				{
					/*
					decl iDefaultClip;
					if((StrEqual(currentweapon, "weapon_sniper_awp", false) == true) || (StrEqual(currentweapon, "weapon_sniper_scout", false) == true))
					{
						iDefaultClip = 20;
					}
					else if(StrEqual(currentweapon, "weapon_sniper_military", false) == true)
					{
						iDefaultClip = 30;
					}
					new iMissingAmmo = (iDefaultClip - CurrentClipAmmo);
					*/
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
					if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6), true);
						SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
					}
					else if(iAmmo < (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
						SetEntData(iClient, iOffset_Ammo + 40, 0);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
				/*
				if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true)) && (CurrentClipAmmo == 8))
				{
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);	//for pump shotguns (+28)
					if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
						SetEntData(iClient, iOffset_Ammo + 28, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
					}
					else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
					{
						new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
						SetEntData(iClient, iOffset_Ammo + 28, 0);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
				if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (CurrentClipAmmo == 10))
				{
					new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);	//for auto shotguns (+32)
					if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
					{
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
						SetEntData(iClient, iOffset_Ammo + 32, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
					}
					else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
					{
						new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
						SetEntData(iClient, iOffset_Ammo + 32, 0);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
				*/
			}
			case 4:		//Nicks Reload
			{
				if((StrEqual(currentweapon, "weapon_pistol_magnum", false) == true) && (g_iMagnumLevel[iClient] > 0))
				{
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 3, true);
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
					//PrintToChatAll("Magnum Fire Reloading");
				}
				if((StrEqual(currentweapon, "weapon_pistol", false) == true) && (g_iRiskyLevel[iClient] > 0))
				{
					if(CurrentClipAmmo == 15)
					{
						//PrintToChatAll("currentclipammo nick pistol 15 = %d", CurrentClipAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, CurrentClipAmmo + (g_iRiskyLevel[iClient] * 6), true);
					}
					else if(CurrentClipAmmo == 30)
					{
						//PrintToChatAll("currentclipammo nick pistol 30 = %d", CurrentClipAmmo);
						SetEntData(ActiveWeaponID, g_iOffset_Clip1, CurrentClipAmmo + (g_iRiskyLevel[iClient] * 12), true);
					}
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
				}
			}
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
		g_bCoachShotgunForceReload[iClient] = false;
	}
	
	//Give Nicks m60 explosive ammo if he is in rambo mode from gambling
	
	// if(g_iNicksRamboWeaponID[iClient] > 0 && StrEqual(wclass,"rifle_m60",false) == true)
	// {
	// 	new wID = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
	// 	if(wID == -1 || IsValidEntity(wID) == false)
	// 		return Plugin_Continue;
	// 	PrintToChatAll("Removing upgrades from Rambo Mode M60");
	// 	SetCommandFlags("upgrade_remove", g_iFlag_UpgradeRemove & ~FCVAR_CHEAT);
	// 	FakeClientCommand(iClient, "upgrade_remove EXPLOSIVE_AMMO");
	// 	SetCommandFlags("upgrade_remove", g_iFlag_UpgradeRemove);
	// 	PrintToChatAll("Setting upgrades for Rambo Mode M60");
	// 	SetEntData(wID, g_iOffset_Clip1, 251, true);
	// 	SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd & ~FCVAR_CHEAT);
	// 	FakeClientCommand(iClient, "upgrade_add EXPLOSIVE_AMMO");
	// 	SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd);
	// 	PrintToChatAll("Everything is set for Rambo Mode M60");
	// }
	
	
	//Give Coach extra explosives if he still has more
/*
	if(g_bExplosivesJustGiven[iClient] == false && g_iStrongLevel[iClient] > 0 && g_iExtraExplosiveUses[iClient] < 3 &&
		(StrEqual(wclass,"pipe_bomb",false) == true || StrEqual(wclass,"molotov",false) == true || StrEqual(wclass,"vomitjar",false) == true))
	{
		g_bExplosivesJustGiven[iClient] = true;
		CreateTimer(3.0, TimerGiveExplosive, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
*/
	if((g_iJamminLevel[iClient] == 5) && (g_iEllisJamminGrenadeCounter[iClient] > 0) && (StrEqual(wclass,"pipe_bomb",false) == true || StrEqual(wclass,"molotov",false) == true || StrEqual(wclass,"vomitjar",false) == true))
	{
		g_iEventWeaponFireCounter[iClient]++;
		if(g_iEventWeaponFireCounter[iClient] == 1)
		{
			CreateTimer(1.5, TimerEllisJamminGiveExplosive, iClient, TIMER_FLAG_NO_MAPCHANGE);
			g_iEllisJamminGrenadeCounter[iClient]--;
		}
	}
	if(g_iStrongLevel[iClient] > 0)
	{
		if(StrEqual(wclass, "vomitjar", false) == true || StrEqual(wclass, "molotov", false) == true || StrEqual(wclass, "pipe_bomb", false) == true)
		{
			if(g_iCoachCurrentGrenadeSlot[iClient] == 0)
			{
				g_bIsCoachGrenadeFireCycling[iClient] = true;
				g_iEventWeaponFireCounter[iClient]++;
				if(g_iEventWeaponFireCounter[iClient] == 1)
				{
					g_strCoachGrenadeSlot1 = "empty";
					CreateTimer(1.5, TimerCoachGrenadeFireCycle, iClient, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else if(g_iCoachCurrentGrenadeSlot[iClient] == 1)
			{
				g_bIsCoachGrenadeFireCycling[iClient] = true;
				g_iEventWeaponFireCounter[iClient]++;
				if(g_iEventWeaponFireCounter[iClient] == 1)
				{
					g_strCoachGrenadeSlot2 = "empty";
					CreateTimer(1.5, TimerCoachGrenadeFireCycle, iClient, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else if(g_iCoachCurrentGrenadeSlot[iClient] == 2)
			{
				g_bIsCoachGrenadeFireCycling[iClient] = true;
				g_iEventWeaponFireCounter[iClient]++;
				if(g_iEventWeaponFireCounter[iClient] == 1)
				{
					g_strCoachGrenadeSlot3 = "empty";
					CreateTimer(1.5, TimerCoachGrenadeFireCycle, iClient, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action:Event_ReviveSuccess(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new target = GetClientOfUserId(GetEventInt(hEvent, "subject"));
	g_bIsClientDown[target] = false;
	clienthanging[target] = false;
	if(iClient < 1)
		return Plugin_Continue;
	fnc_SetClientSpeed(target);
	fnc_SetRendering(target);
	/*
	if(g_iOverLevel[target] > 0)
	{
		new iCurrentHealth = GetEntProp(target,Prop_Data,"m_iHealth");
		new iMaxHealth = GetEntProp(target,Prop_Data,"m_iMaxHealth");
		//new Float:fTempHealth = GetEntDataFloat(target, g_iOffset_HealthBuffer);
		//if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - 20.0))
		if(iCurrentHealth < (iMaxHealth - 20.0))
		{
			//g_fEllisOverSpeed[target] = 0.0;
			SetEntDataFloat(target , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[target] + g_fEllisBringSpeed[target] + g_fEllisOverSpeed[target]), true);
			//DeleteCode
			//PrintToChatAll("Revive success, now setting g_fEllisOverSpeed");
			//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[target]);
			//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[target]);
			//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[target]);
		}
		//else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
		if(iCurrentHealth >= (iMaxHealth - 20.0))
		{
			g_fEllisOverSpeed[target] = (g_iOverLevel[target] * 0.02);
			SetEntDataFloat(target , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[target] + g_fEllisBringSpeed[target] + g_fEllisOverSpeed[target]), true);
		}
	}
	*/
	/*
	if(g_iNickDesperateMeasuresStack>0)
	{
		decl i;
		if(g_iNickDesperateMeasuresStack > 0)	//Dont allow desperate stack to go over 3 times
		{
			g_iNickDesperateMeasuresStack--;
			for(i=1;i<=MaxClients;i++)		//Check all the clients to see if they have despearate level up(Nick)
			{
				if(g_iDesperateLevel[i]>0)
				{
					if(RunClientChecks(i))
					{
						if(!IsFakeClient(i))
						{
							if(g_iClientTeam[i]==TEAM_SURVIVORS)
							{
								SetEntDataFloat(i , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0 + (float(g_iMagnumLevel[i]) * 0.03) + (float(g_iNickDesperateMeasuresStack) * float(g_iDesperateLevel[i]) * 0.02), true);
								PrintHintText(i, "A teammate has been revived, your senses return to a weaker state.");
							}
						}
					}
				}
			}
		}
	}
	*/
	//g_iNickDesperateMeasuresStack++;
	if(g_iNickDesperateMeasuresStack > 3)
	{
		g_iNickDesperateMeasuresStack--;
	}
	else
	{
		decl i;
		for(i=1;i<=MaxClients;i++)
		{
			if(RunClientChecks(i) && g_iClientTeam[i]==TEAM_SURVIVORS && IsPlayerAlive(i) == true)
			{
				g_fClientSpeedBoost[i] -= (g_iDesperateLevel[i] * 0.02);
				fnc_SetClientSpeed(i);
				PrintHintText(i, "A teammate has been revived, your senses return to a weaker state.");
			}
		}
		g_iNickDesperateMeasuresStack--;
	}
	/*
	g_iNickDesperateMeasuresStack--;
	if(g_iNickDesperateMeasuresStack < 0)
		g_iNickDesperateMeasuresStack = 0;
	decl i;
	for(i=1;i<=MaxClients;i++)
	{
		if(RunClientChecks(i) && g_iClientTeam[i]==TEAM_SURVIVORS && IsPlayerAlive(iClient) == false)
		{
			g_fClientSpeedBoost[i] += (g_iNickDesperateMeasuresStack * (g_iDesperateLevel[i] * 0.02));
			fnc_SetClientSpeed(i);
			PrintHintText(i, "A teammate has died, your senses sharpen.");
		}
	}
	*/
	if(IsFakeClient(iClient) == true)
		return Plugin_Continue;
	if (iClient > 0 && iClient <= MaxClients)
	{
		if (iClient != target)
		{
			g_iClientXP[iClient] += 50;
			CheckLevel(iClient);
			
			if(g_iXPDisplayMode[iClient] == 0)
				ShowXPSprite(iClient, g_iSprite_50XP, target);
			else if(g_iXPDisplayMode[iClient] == 1)
				PrintToChat(iClient, "\x03[XPMod] Revived a teammate. You gain 50 XP.");
		}
	}
	return Plugin_Continue;
}

public Event_LedgeGrab(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//need an event for if the iClient gets up off the ledge to make clienthanging false
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	clienthanging[iClient] = true;
}

public Action:Event_InfectedDecap(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//make a talent that makes you take no damage from your teammates friendly fire///////////////////////
{
	new iClient  = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	if(IsFakeClient(iClient) == false)
	{
		if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
		{
			g_iClientXP[iClient] += 5;
			CheckLevel(iClient);
			
			//PrintToChat(iClient, "\x03[XPMod] Infected Decapitaed! You gain 5 XP");
			if(g_iChosenSurvivor[iClient] == COACH && g_iHomerunLevel[iClient]>0)
			{
				if(g_iCoachDecapitationCounter[iClient] < 50)
				{
					g_iCoachDecapitationCounter[iClient]++;
					g_iMeleeDamageCounter[iClient]+=(g_iHomerunLevel[iClient]*2);
					//PrintToChat(iClient, "g_iMeleeDamageCounter = %d", g_iMeleeDamageCounter[iClient]);
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action:Event_WeaponPickUp(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//make a talent that makes you take no damage from your teammates friendly fire///////////////////////
{
	
	// PrintToChatAll("Event_WeaponPickUp");
	// new iWeaponID = GetEventInt(hEvent,"weaponid");
	// new iWeaponSlot = GetEventInt(hEvent,"weaponslot");
	// PrintToChatAll("iWeaponID = %d", iWeaponID);
	// PrintToChatAll("iWeaponSlot = %d", iWeaponSlot);
	// PrintToChatAll("Picking up a weapon");
	
	return Plugin_Continue;
}

public Action:Event_SpawnerGiveItem(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//make a talent that makes you take no damage from your teammates friendly fire///////////////////////
{
	//PrintToChatAll("Event_SpawnerGiveItem");
	return Plugin_Continue;
}

public Action:Event_UseTarget(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//make a talent that makes you take no damage from your teammates friendly fire///////////////////////
{
	//PrintToChatAll("Event_UseTarget");
	return Plugin_Continue;
}

public Action:Event_PlayerUse(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//make a talent that makes you take no damage from your teammates friendly fire///////////////////////
{
	//PrintToChatAll("Event_PlayerUse");
	return Plugin_Continue;
}

public Action:Event_ItemPickUp(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//make a talent that makes you take no damage from your teammates friendly fire///////////////////////
{
	int iUserID = GetEventInt(hEvent,"userid")
	if (RunEntityChecks(iUserID) == false)
		return Plugin_Continue;

	new iClient = GetClientOfUserId(iUserID);
	if(RunClientChecks(iClient) == false || g_iClientTeam[iClient] != TEAM_SURVIVORS || IsPlayerAlive(iClient) == false)
		return Plugin_Continue;
	
	decl String:weaponclass[24];
	GetEventString(hEvent,"item",weaponclass,24);
	//PrintToChat(iClient, "Picked up %s", weaponclass);
	
	new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (RunEntityChecks(ActiveWeaponID) == false)
		return Plugin_Continue;
	new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
	new ClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
	
	//PrintToChatAll("ClipSize = %d", GetEntProp(GetPlayerWeaponSlot(iClient, 1),Prop_Data,"m_iClip1"));
	if((StrEqual(weaponclass, "chainsaw", false) == true) && (g_iHighestLeadLevel > 0) && (ClipAmmo == 30))
	{
		SetEntData(ActiveWeaponID, g_iOffset_Clip1, ClipAmmo + (g_iHighestLeadLevel * 3), true);
	}
	if(g_bClientIsReloading[iClient] == true)
	{
		g_bCoachShotgunForceReload[iClient] = false;
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
	
	if((g_iWeaponsLevel[iClient] > 0 || g_iPromotionalLevel[iClient] > 0) && g_iLaserUpgradeCounter[iClient] < 10 &&
		(StrContains(weaponclass, "rifle", false) != -1 || StrContains(weaponclass, "shotgun", false) != -1 ||
		StrContains(weaponclass, "smg", false) != -1 || StrContains(weaponclass, "sniper", false) != -1 || 
		StrContains(weaponclass, "grenade", false) != -1))
	{
		SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd & ~FCVAR_CHEAT);
		FakeClientCommand(iClient, "upgrade_add LASER_SIGHT");
		SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd);
		g_iLaserUpgradeCounter[iClient]++;
	}
	
	if(g_iChosenSurvivor[iClient] == BILL)
	{
		if(g_iPromotionalLevel[iClient] > 0)
		{
			if (StrContains(weaponclass,"rifle",false) != -1)
			{
				if (StrContains(weaponclass,"CSniperRifle",false) == -1 && StrContains(weaponclass,"hunting_rifle",false) == -1 && StrContains(weaponclass,"m60",false) == -1)
				{
					new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
					if(iEntid  < 1)
						return Plugin_Continue;
					if(IsValidEntity(iEntid)==false)
						return Plugin_Continue;
					//PrintToChatAll("iEntid!=-1 and is valid entry");
					new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
					g_iClientPrimaryClipSize[iClient] = clip;
					SetEntData(iEntid, g_iOffset_Clip1, clip + (g_iPromotionalLevel[iClient] * 20), true);
					//new iOffset_Ammo=FindDataMapInfo(iClient,"m_iAmmo");
					clip = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
					SetEntData(iClient, iOffset_Ammo + 12, clip - (g_iPromotionalLevel[iClient] * 20));
				}
			}
		}
	}
	else if(g_iChosenSurvivor[iClient] == 1)	//Rochelle
	{
		if(g_iSilentLevel[iClient]>0)
		{
			new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
			if(iEntid < 1)					//Changed to this was:   if(iEntid == -1)
				return Plugin_Continue;
			if(IsValidEntity(iEntid)==false)
				return Plugin_Continue;
			new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
			//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
			decl iAmmo;
			
			if (StrContains(weaponclass,"hunting_rifle",false) != -1)	//Rugar
			{
				if(clip > (17 - (g_iSilentLevel[iClient] * 2)))
				{
					iAmmo = GetEntData(iClient, iOffset_Ammo + 36);	//for huntingrifle (+36)
					SetEntData(iEntid, g_iOffset_Clip1, 17 - (g_iSilentLevel[iClient]*2), true);
					SetEntData(iClient, iOffset_Ammo + 36, iAmmo + (g_iSilentLevel[iClient]*2) + 2);
				}
			}
			else if (StrContains(weaponclass,"sniper_military",false) != -1)
			{
				iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for other snipers (+40)
				if(iAmmo >= (g_iClientPrimaryClipSize[iClient] + (g_iSilentLevel[iClient] * 6)))
				{
					SetEntData(iEntid, g_iOffset_Clip1, 30 + (g_iSilentLevel[iClient]*6), true);
					SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iSilentLevel[iClient]*6));
				}
			}
			else if (StrContains(weaponclass,"sniper_scout",false) != -1)
			{
				if(clip > (15 - g_iSilentLevel[iClient]))
				{
					iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for other snipers (+40)
					SetEntData(iEntid, g_iOffset_Clip1, clip - g_iSilentLevel[iClient], true);
					SetEntData(iClient, iOffset_Ammo + 40, iAmmo + g_iSilentLevel[iClient]);
				}
			}
			else if (StrContains(weaponclass,"sniper_awp",false) != -1)
			{
				iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for other snipers (+40)
				if(clip > 1)
				{
					SetEntData(iEntid, g_iOffset_Clip1, 3, true);
					SetEntData(iClient, iOffset_Ammo + 40, iAmmo + 17);
				}
			}
		}
	}
	if(g_iChosenSurvivor[iClient] == 2)		//Coach
	{
		if(g_iSprayLevel[iClient] > 0)
		{
			if (StrContains(weaponclass,"shotgun",false) != -1)
			{
				new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(iEntid < 1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				clip += (g_iSprayLevel[iClient]*2);
				//new iOffset_Ammo=FindDataMapInfo(iClient,"m_iAmmo");
				new ammoamountpsg = GetEntData(iClient, iOffset_Ammo + 28);	//for pump shotgun (+28)
				new ammoamountasg = GetEntData(iClient, iOffset_Ammo + 32);	//for auto shotgun (+32)
				if(ammoamountpsg > 0)
				{
					if(clip > 7)
						if(ammoamountpsg>(g_iSprayLevel[iClient]*2))
						{
							SetEntData(iEntid, g_iOffset_Clip1, clip, true);
							SetEntData(iClient, iOffset_Ammo + 28, ammoamountpsg - (g_iSprayLevel[iClient]*2));
						}
				}
				else if(ammoamountasg > 0)
				{
					if(clip > 9)
						if(ammoamountasg > (g_iSprayLevel[iClient]*2))
						{
							SetEntData(iEntid, g_iOffset_Clip1, clip, true);
							SetEntData(iClient, iOffset_Ammo + 32, ammoamountasg - (g_iSprayLevel[iClient]*2));
						}
				}
				SetEntData(iEntid, g_iOffset_Clip1, clip, true);
			}
		}
		if(g_iStrongLevel[iClient] > 0)
		{
			if((StrContains(weaponclass, "vomitjar", false) != -1) || (StrContains(weaponclass, "molotov", false) != -1) || (StrContains(weaponclass, "pipe_bomb", false) != -1))
			{
				if(g_bIsCoachGrenadeFireCycling[iClient] == false)
				{
					if(g_bIsCoachInGrenadeCycle[iClient] == true)
					{
						g_bIsCoachInGrenadeCycle[iClient] = false;
					}
					else if(g_bIsCoachInGrenadeCycle[iClient] == false)
					{
						if((StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1) || (StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1) || (StrContains(g_strCoachGrenadeSlot3, "empty", false) != -1))
						{
							if(g_iStrongLevel[iClient] == 3 || g_iStrongLevel[iClient] == 4)
							{
								if(StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1)
								{
									g_iCoachCurrentGrenadeSlot[iClient] = 0;
									if(StrEqual(weaponclass, "vomitjar", false) == true)
									{
										g_strCoachGrenadeSlot1 = "weapon_vomitjar";
									}
									else if(StrEqual(weaponclass, "molotov", false) == true)
									{
										g_strCoachGrenadeSlot1 = "weapon_molotov";
									}
									else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
									{
										g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
									}
								}
								else if(StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1)
								{
									g_iCoachCurrentGrenadeSlot[iClient] = 1;
									if(StrEqual(weaponclass, "vomitjar", false) == true)
									{
										g_strCoachGrenadeSlot2 = "weapon_vomitjar";
									}
									else if(StrEqual(weaponclass, "molotov", false) == true)
									{
										g_strCoachGrenadeSlot2 = "weapon_molotov";
									}
									else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
									{
										g_strCoachGrenadeSlot2 = "weapon_pipe_bomb";
									}
								}
							}
							else if(g_iStrongLevel[iClient] == 5)
							{
								if(StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1)
								{
									g_iCoachCurrentGrenadeSlot[iClient] = 0;
									if(StrEqual(weaponclass, "vomitjar", false) == true)
									{
										g_strCoachGrenadeSlot1 = "weapon_vomitjar";
									}
									else if(StrEqual(weaponclass, "molotov", false) == true)
									{
										g_strCoachGrenadeSlot1 = "weapon_molotov";
									}
									else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
									{
										g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
									}
								}
								else if(StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1)
								{
									g_iCoachCurrentGrenadeSlot[iClient] = 1;
									if(StrEqual(weaponclass, "vomitjar", false) == true)
									{
										g_strCoachGrenadeSlot2 = "weapon_vomitjar";
									}
									else if(StrEqual(weaponclass, "molotov", false) == true)
									{
										g_strCoachGrenadeSlot2 = "weapon_molotov";
									}
									else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
									{
										g_strCoachGrenadeSlot2 = "weapon_pipe_bomb";
									}
								}
								else if(StrContains(g_strCoachGrenadeSlot3, "empty", false) != -1)
								{
									g_iCoachCurrentGrenadeSlot[iClient] = 2;
									if(StrEqual(weaponclass, "vomitjar", false) == true)
									{
										g_strCoachGrenadeSlot3 = "weapon_vomitjar";
									}
									else if(StrEqual(weaponclass, "molotov", false) == true)
									{
										g_strCoachGrenadeSlot3 = "weapon_molotov";
									}
									else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
									{
										g_strCoachGrenadeSlot3 = "weapon_pipe_bomb";
									}
								}
							}
							else
							{
								g_iCoachCurrentGrenadeSlot[iClient] = 0;
								if(StrEqual(weaponclass, "vomitjar", false) == true)
								{
									g_strCoachGrenadeSlot1 = "weapon_vomitjar";
								}
								else if(StrEqual(weaponclass, "molotov", false) == true)
								{
									g_strCoachGrenadeSlot1 = "weapon_molotov";
								}
								else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
								{
									g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
								}
							}
						}
						else
						{
							if(g_iCoachCurrentGrenadeSlot[iClient] == 0)
							{
								if(StrEqual(weaponclass, "vomitjar", false) == true)
								{
									g_strCoachGrenadeSlot1 = "weapon_vomitjar";
								}
								else if(StrEqual(weaponclass, "molotov", false) == true)
								{
									g_strCoachGrenadeSlot1 = "weapon_molotov";
								}
								else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
								{
									g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
								}
							}
							else if(g_iCoachCurrentGrenadeSlot[iClient] == 1)
							{
								if(StrEqual(weaponclass, "vomitjar", false) == true)
								{
									g_strCoachGrenadeSlot2 = "weapon_vomitjar";
								}
								else if(StrEqual(weaponclass, "molotov", false) == true)
								{
									g_strCoachGrenadeSlot2 = "weapon_molotov";
								}
								else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
								{
									g_strCoachGrenadeSlot2 = "weapon_pipe_bomb";
								}
							}
							else if(g_iCoachCurrentGrenadeSlot[iClient] == 2)
							{
								if(StrEqual(weaponclass, "vomitjar", false) == true)
								{
									g_strCoachGrenadeSlot3 = "weapon_vomitjar";
								}
								else if(StrEqual(weaponclass, "molotov", false) == true)
								{
									g_strCoachGrenadeSlot3 = "weapon_molotov";
								}
								else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
								{
									g_strCoachGrenadeSlot3 = "weapon_pipe_bomb";
								}
							}
						}
					}
				}
			}
		}
	}
	if(g_iChosenSurvivor[iClient] == 3)		//Ellis
	{
		if(g_iMetalLevel[iClient]>0 || g_iFireLevel[iClient]>0)
		{
			//PrintToChat(iClient, "%s", weaponclass);
			if (StrContains(weaponclass,"rifle",false) != -1 || StrContains(weaponclass,"smg",false) != -1 || StrContains(weaponclass,"sub",false) != -1 || StrContains(weaponclass,"sniper",false) != -1)
			{
				//PrintToChatAll("Inside smg rifle etc.");
				new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(iEntid < 1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				//PrintToChatAll("iEntid!=-1 and is valid entry");
				new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				g_iClientPrimaryClipSize[iClient] = clip;
				SetEntData(iEntid, g_iOffset_Clip1, clip + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6), true);
				//new iOffset_Ammo=FindDataMapInfo(iClient,"m_iAmmo");
				clip = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
				SetEntData(iClient, iOffset_Ammo + 12, clip - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
				clip = GetEntData(iClient, iOffset_Ammo + 20);	//for smg (+20)
				SetEntData(iClient, iOffset_Ammo + 20, clip - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
				clip = GetEntData(iClient, iOffset_Ammo + 32);	//for huntingrifle (+32)
				SetEntData(iClient, iOffset_Ammo + 32, clip - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
				clip = GetEntData(iClient, iOffset_Ammo + 36);	//for huntingrifle2? (+36)
				SetEntData(iClient, iOffset_Ammo + 36, clip - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
			}
			/*else if(StrContains(weaponclass,"gren",false) != -1)
			{
				new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(iEntid==-1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				g_iClientPrimaryClipSize[iClient] = clip;
				new iOffset_Ammo=FindDataMapInfo(iClient,"m_iAmmo");
				iAmmo = GetEntData(iClient, iOffset_Ammo + 64);
				SetEntData(iEntid, g_iOffset_Clip1, clip + g_iFireLevel[iClient], true);
				SetEntData(iClient, iOffset_Ammo + 64, iAmmo - g_iFireLevel[iClient]);
			}*/
		}
		if(g_iWeaponsLevel[iClient] == 5)
		{
			//PrintToChatAll("Weapons level is = 5, continuing");
			if((StrContains(weaponclass,"shotgun",false) != -1) || (StrContains(weaponclass,"rifle",false) != -1) || (StrContains(weaponclass,"smg",false) != -1) || (StrContains(weaponclass,"sniper",false) != -1) || (StrContains(weaponclass,"launcher",false) != -1))
			{
				//PrintToChatAll("Picked up weapon qualifies, continuing");
				//PrintToChatAll("g_bIsEllisCyclingEmptyWeapon = %d", g_bIsEllisCyclingEmptyWeapon[iClient]);
				if(g_bIsEllisCyclingEmptyWeapon[iClient] == true)
				{
					//PrintToChatAll("Cycling empty weapon, setting ammo");
					fnc_DeterminePrimaryWeapon(iClient);
					fnc_SetAmmo(iClient);
					fnc_SetAmmoUpgrade(iClient);
					g_bIsEllisCyclingEmptyWeapon[iClient] = false;
				}
				if((StrEqual(g_strEllisPrimarySlot1, "empty", false) == true) && (StrEqual(g_strEllisPrimarySlot2, "empty", false) == true))
				{
					//new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
					//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
					new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
					if(g_iEllisCurrentPrimarySlot[iClient] == 0)
					{
						if((StrEqual(weaponclass, "rifle", false) == true) || (StrEqual(weaponclass, "rifle_ak47", false) == true) || (StrEqual(weaponclass, "rifle_sg552", false) == true) || (StrEqual(weaponclass, "rifle_desert", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "smg", false) == true) || (StrEqual(weaponclass, "smg_mp5", false) == true) || (StrEqual(weaponclass, "smg_silenced", false) == true) || (StrEqual(weaponclass, "rifle_desert", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "pumpshotgun", false) == true) || (StrEqual(weaponclass, "shotgun_chrome", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "autoshotgun", false) == true) || (StrEqual(weaponclass, "shotgun_spas", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "sniper_military", false) == true) || (StrEqual(weaponclass, "sniper_awp", false) == true) || (StrEqual(weaponclass, "sniper_scout", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "rifle_m60", false) == true)
						{
							//new iAmmo = GetEntData(iClient, iOffset_Ammo);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
						}
					}
					else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
					{
						if((StrEqual(weaponclass, "rifle", false) == true) || (StrEqual(weaponclass, "rifle_ak47", false) == true) || (StrEqual(weaponclass, "rifle_sg552", false) == true) || (StrEqual(weaponclass, "rifle_desert", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "smg", false) == true) || (StrEqual(weaponclass, "smg_mp5", false) == true) || (StrEqual(weaponclass, "smg_silenced", false) == true) || (StrEqual(weaponclass, "rifle_desert", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "pumpshotgun", false) == true) || (StrEqual(weaponclass, "shotgun_chrome", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "autoshotgun", false) == true) || (StrEqual(weaponclass, "shotgun_spas", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "sniper_military", false) == true) || (StrEqual(weaponclass, "sniper_awp", false) == true) || (StrEqual(weaponclass, "sniper_scout", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "rifle_m60", false) == true)
						{
							//new iAmmo = GetEntData(iClient, iOffset_Ammo);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = 0;
						}
					}
				}
				if(g_bIsEllisInPrimaryCycle[iClient] == true)
				{
					fnc_DeterminePrimaryWeapon(iClient);
					fnc_SetAmmo(iClient);
					fnc_SetAmmoUpgrade(iClient);
					/*
					if(g_iEllisCurrentPrimarySlot[iClient] == 0)
					{
						if(StrEqual(weaponclass, "autoshotgun", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 68, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 36, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "pumpshotgun", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_ak47", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_desert", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_m60", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							//SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_sg552", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "shotgun_chrome", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "shotgun_spas", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "smg", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "smg_mp5", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "smg_silenced", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_awp", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_military", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_scout", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
					}
					else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
					{
						if(StrEqual(weaponclass, "autoshotgun", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 68, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 36, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "pumpshotgun", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_ak47", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_desert", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_m60", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							//SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_sg552", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "shotgun_chrome", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "shotgun_spas", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "smg", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "smg_mp5", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "smg_silenced", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_awp", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_military", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_scout", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
					}
					*/
					g_bIsEllisInPrimaryCycle[iClient] = false;
				}
				/*
				if((StrContains(g_strEllisPrimarySlot1, "empty", false) != -1) && if(StrContains(g_strEllisPrimarySlot2, "empty", false) != -1))
				{
					if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if(StrEqual(currentweapon, "weapon_hunting_rifle", false) == true)
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(currentweapon, "weapon_sniper_military", false) == true) || (StrEqual(currentweapon, "weapon_sniper_awp", false) == true) || (StrEqual(currentweapon, "weapon_sniper_scout", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if(StrEqual(currentweapon, "weapon_grenade_launcher", false) == true)
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if(StrEqual(currentweapon, "weapon_rifle_m60", false) == true)
					{
						//new iAmmo = GetEntData(iClient, iOffset_Ammo);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
					}
				}
				*/
				if(StrContains(g_strEllisPrimarySlot1, "empty", false) != -1)
				{
					//PrintToChatAll("Filling a primary slot");
					g_iEllisCurrentPrimarySlot[iClient] = 0;
					if(StrEqual(weaponclass, "autoshotgun", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_autoshotgun";
					}
					else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_grenade_launcher";
					}
					else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_hunting_rifle";
					}
					else if(StrEqual(weaponclass, "pumpshotgun", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_pumpshotgun";
					}
					else if(StrEqual(weaponclass, "rifle", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_rifle";
					}
					else if(StrEqual(weaponclass, "rifle_ak47", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_rifle_ak47";
						//PrintToChatAll("Saved %s", g_strEllisPrimarySlot1);
					}
					else if(StrEqual(weaponclass, "rifle_desert", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_rifle_desert";
					}
					else if(StrEqual(weaponclass, "rifle_m60", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_rifle_m60";
					}
					else if(StrEqual(weaponclass, "rifle_sg552", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_rifle_sg552";
					}
					else if(StrEqual(weaponclass, "shotgun_chrome", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_shotgun_chrome";
					}
					else if(StrEqual(weaponclass, "shotgun_spas", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_shotgun_spas";
					}
					else if(StrEqual(weaponclass, "smg", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_smg";
					}
					else if(StrEqual(weaponclass, "smg_mp5", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_smg_mp5";
					}
					else if(StrEqual(weaponclass, "smg_silenced", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_smg_silenced";
					}
					else if(StrEqual(weaponclass, "sniper_awp", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_sniper_awp";
					}
					else if(StrEqual(weaponclass, "sniper_military", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_sniper_military";
					}
					else if(StrEqual(weaponclass, "sniper_scout", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_sniper_scout";
					}
				}
				else if(StrContains(g_strEllisPrimarySlot2, "empty", false) != -1)
				{
					g_iEllisCurrentPrimarySlot[iClient] = 1;
					if(StrEqual(weaponclass, "autoshotgun", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_autoshotgun";
					}
					else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_grenade_launcher";
					}
					else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_hunting_rifle";
					}
					else if(StrEqual(weaponclass, "pumpshotgun", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_pumpshotgun";
					}
					else if(StrEqual(weaponclass, "rifle", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_rifle";
					}
					else if(StrEqual(weaponclass, "rifle_ak47", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_rifle_ak47";
					}
					else if(StrEqual(weaponclass, "rifle_desert", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_rifle_desert";
					}
					else if(StrEqual(weaponclass, "rifle_m60", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_rifle_m60";
					}
					else if(StrEqual(weaponclass, "rifle_sg552", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_rifle_sg552";
					}
					else if(StrEqual(weaponclass, "shotgun_chrome", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_shotgun_chrome";
					}
					else if(StrEqual(weaponclass, "shotgun_spas", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_shotgun_spas";
					}
					else if(StrEqual(weaponclass, "smg", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_smg";
					}
					else if(StrEqual(weaponclass, "smg_mp5", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_smg_mp5";
					}
					else if(StrEqual(weaponclass, "smg_silenced", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_smg_silenced";
					}
					else if(StrEqual(weaponclass, "sniper_awp", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_sniper_awp";
					}
					else if(StrEqual(weaponclass, "sniper_military", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_sniper_military";
					}
					else if(StrEqual(weaponclass, "sniper_scout", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_sniper_scout";
					}
				}
			}
		}
	}
	else if(g_iChosenSurvivor[iClient] == 4)	//Nick
	{
		if(g_bRamboModeActive[iClient] == true)
		{
			//PrintToChatAll("Picked up weapon with rambo mode active, running fnc_DeterminePrimaryWeapon");
			fnc_DeterminePrimaryWeapon(iClient);
			if(StrEqual(g_strCurrentWeapon, "weapon_rifle_m60", false) == false)
			{
				//PrintToChatAll("fnc_DeterminePrimaryWeapon showed the primary weapon is not the m60");
				fnc_SetAmmo(iClient);
				fnc_SetAmmoUpgrade(iClient);
				//PrintToChatAll("Ammo was set via weapon pickup");
				fnc_ClearSavedWeaponData(iClient);
				g_bRamboModeActive[iClient] = false;
			}
		}
		/*
		if(g_bRamboModeActive[iClient] == true)
		{
			//PrintToChatAll("Picked up weapon with rambo mode active, running fnc_DeterminePrimaryWeapon");
			fnc_DeterminePrimaryWeapon(iClient);
			if(StrEqual(g_strCurrentWeapon, "weapon_rifle_m60", false) == false)
			{
				//PrintToChatAll("fnc_DeterminePrimaryWeapon showed the primary weapon is not the m60");
				fnc_SetAmmo(iClient);
				fnc_SetAmmoUpgrade(iClient);
				//PrintToChatAll("Ammo was set via weapon pickup");
				fnc_ClearSavedWeaponData(iClient);
				g_bRamboModeActive[iClient] = false;
			}
		}
		*/
		//PrintToChat(iClient, "%s", weaponclass);
		if(g_iMagnumLevel[iClient]>0 || g_iRiskyLevel[iClient]>0)	//gives 68 with magnum pickup on loadout spawn
		{
			if (StrContains(weaponclass,"magnum",false) != -1)
			{
				new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(iEntid < 1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				SetEntData(iEntid, g_iOffset_Clip1, 3, true);
			}
			else if(StrContains(weaponclass,"pistol",false) != -1)
			{
				new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(iEntid < 1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				if(clip == 15)
				{
					SetEntData(iEntid, g_iOffset_Clip1, clip + (g_iRiskyLevel[iClient] * 6), true);
				}
				else if(clip == 30)
				{
					SetEntData(iEntid, g_iOffset_Clip1, clip + (g_iRiskyLevel[iClient] * 12), true);
				}
			}
		}
		/*
		if(g_iNicksRamboWeaponID[iClient] > 0)
		{
			if(StrContains(weaponclass,"m60",false) != -1)
			{
				//Set ammo to 250
				new wID = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(wID < 1)
					return Plugin_Continue;
				if(IsValidEntity(wID)==false)
					return Plugin_Continue;
				if(IsValidEntity(wID))
					SetEntData(wID, g_iOffset_Clip1, 250, true);
			}
		}
		*/
		if(g_iRiskyLevel[iClient] == 5 && g_bTalentsConfirmed[iClient] == true)
		{
			
			// PrintToChatAll("ClipSlot1 on pickup w slot undetermined = %d", g_iNickSecondarySavedClipSlot1[iClient]);
			// new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			// PrintToChatAll("Current Clip Ammo on Pickup = %d", CurrentClipAmmo);
			// PrintToChatAll("Current weaponclass on Pickup = %s", weaponclass);
			
			if((StrContains(weaponclass,"pistol",false) != -1) || (StrContains(weaponclass,"melee",false) != -1) || (StrContains(weaponclass,"chainsaw",false) != -1))
			{
				if(g_bIsNickInSecondaryCycle[iClient] == true)
				{
					if(g_iNickCurrentSecondarySlot[iClient] == 0)
					{
						if(StrEqual(weaponclass, "pistol_magnum", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iNickSecondarySavedClipSlot1[iClient], true);
							//PrintToChatAll("Setting slot 1 clip ammo to %d", g_iNickSecondarySavedClipSlot1[iClient]);
						}
					}
					else if((g_iNickCurrentSecondarySlot[iClient] == 1) && (StrEqual(weaponclass, "pistol", false) == true))
					{
						CreateTimer(0.1, TimerNickDualClipSize, iClient, TIMER_FLAG_NO_MAPCHANGE);
						//PrintToChatAll("Setting slot 2 clip ammo to %d", g_iNickSecondarySavedClipSlot2[iClient]);
						//PrintToChatAll("ClipSlot1 on pickup w slot 1 = %d", g_iNickSecondarySavedClipSlot1[iClient]);
					}
					g_bIsNickInSecondaryCycle[iClient] = false;
				}
				else if(g_bIsNickInSecondaryCycle[iClient] == false)
				{
					if(((StrContains(weaponclass,"melee",false) != -1) || (StrContains(weaponclass,"chainsaw",false) != -1)) && (StrEqual(g_strNickSecondarySlot1, "weapon_pistol_magnum", false) == true) && (g_iNickCurrentSecondarySlot[iClient] == 1))
					{
						//PrintToChatAll("Picked up melee with magnum saved in slot 1");
						decl Float:wepvorigin[3], Float:vangles[3], Float:vdir[3];
						GetClientEyeAngles(iClient, vangles);
						GetAngleVectors(vangles, vdir, NULL_VECTOR, NULL_VECTOR);
						vangles[0] = 0.0;
						vangles[2] = 0.0;
						GetClientAbsOrigin(iClient, wepvorigin);
						wepvorigin[0]+=(vdir[0] * 30.0);
						wepvorigin[1]+=(vdir[1] * 30.0);
						wepvorigin[2]+=(vdir[2] * 50.0);
						new weapon = CreateEntityByName("weapon_pistol_magnum");
						DispatchKeyValue(weapon, "ammo", "200");
						DispatchSpawn(weapon);
						TeleportEntity(weapon, wepvorigin, vangles, NULL_VECTOR);
					}
					//PrintToChatAll("Cycle is false");
					g_iNickCurrentSecondarySlot[iClient] = 0;
					//PrintToChatAll("Cycle false, weaponclass = %s", weaponclass);
					//PrintToChatAll("Cycle false, g_strNickSecondarySlot1 = %s", g_strNickSecondarySlot1);
					
					// if(StrContains(weaponclass, "chainsaw", false) != -1)
					// {
					// 	SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iNickSecondarySavedClipSlot1[iClient], true);
					// 	PrintToChatAll("Setting chainsaw clip ammo to %d", g_iNickSecondarySavedClipSlot1[iClient]);
					// }
					
					if((StrEqual(weaponclass, "pistol_magnum", false) == true) && (StrEqual(g_strNickSecondarySlot1, "weapon_pistol_magnum", false) == true))
					{
						//PrintToChatAll("weaponclass and slot 1 are both magnum");
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give pistol_magnum");
					}
					if(StrContains(g_strNickSecondarySlot1, "empty", false) != -1)
					{
						//PrintToChatAll("Slot 1 is empty");
						//g_iNickCurrentSecondarySlot[iClient] = 0;
						if(StrEqual(weaponclass, "pistol_magnum", false) == true)
						{
							g_strNickSecondarySlot1 = "weapon_pistol_magnum";
							//PrintToChatAll("Slot 1 = %s", g_strNickSecondarySlot1);
						}
						else if(StrEqual(weaponclass, "pistol", false) == true)
						{
							g_strNickSecondarySlot1 = "weapon_pistol";
						}
						else if(StrContains(weaponclass,"melee",false) != -1)
						{
							g_strNickSecondarySlot1 = "weapon_melee";
						}
						else if(StrContains(weaponclass,"chainsaw",false) != -1)
						{
							g_strNickSecondarySlot1 = "weapon_chainsaw";
						}
					}
				}
				if(g_iNickCurrentSecondarySlot[iClient] == 0)
				{
					if(StrEqual(weaponclass, "pistol", false) == true)
					{
						g_iNickCurrentSecondarySlot[iClient] = 1;
						SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						FakeClientCommand(iClient, "give pistol");
						FakeClientCommand(iClient, "give pistol");
						CreateTimer(0.1, TimerNickDualClipSize, iClient, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action:Event_WeaponDropped(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//When an item is removed from a survivor's inventory///////////////////////
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	decl String:droppeditem[32];
	GetEventString(hEvent, "item", droppeditem, 32);
	new iProp = GetEventInt(hEvent,"propid");
	//PrintToChatAll("droppeditem = %s", droppeditem);
	if(g_iStrongLevel[iClient] > 0)
	{
		if((StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1) || (StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1) || (StrContains(g_strCoachGrenadeSlot3, "empty", false) != -1))
		{
			if((StrContains(droppeditem, "pipe_bomb", false) != -1) || (StrContains(droppeditem, "molotov", false) != -1) || (StrContains(droppeditem, "vomitjar", false) != -1))
			{
				AcceptEntityInput(iProp, "Kill");
			}
		}
	}
	if(g_iWeaponsLevel[iClient] == 5)
	{
		if((StrContains(g_strEllisPrimarySlot1, "empty", false) != -1) || (StrContains(g_strEllisPrimarySlot2, "empty", false) != -1))
		{
			if((StrContains(droppeditem,"shotgun",false) != -1) || (StrContains(droppeditem,"rifle",false) != -1) || (StrContains(droppeditem,"smg",false) != -1) || (StrContains(droppeditem,"sniper",false) != -1) || (StrContains(droppeditem,"launcher",false) != -1))
			{
				//PrintToChatAll("Attempting to save dropped ammo...");
				//new targetgun = GetPlayerWeaponSlot(iClient, 0);
				//new iAmmoOffset = FindDataMapInfo(client, "m_iAmmo");
				//GetEntProp(targetgun, Prop_Data, "m_iExtraPrimaryAmmo", 4);
				//SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
				//new iOffset_Ammo = FindDataMapInfo(iProp,"m_iAmmo");
				//new iOffset_Ammo2 = FindDataMapInfo(droppeditem,"m_iAmmo");
				//new iOffset_Ammo3 = FindDataMapInfo(iProp,"m_iAmmo");
				//new iAmmo = GetEntData(iProp, iOffset_Ammo + 12);
				//PrintToChatAll("Attempting to save dropped ammo...");
				g_iEllisPrimarySavedClipSlot1[iClient] = GetEntProp(iProp, Prop_Data, "m_iClip1");
				//g_iEllisPrimarySavedAmmoSlot1[iClient] = GetEntProp(iProp, Prop_Send, "m_iExtraPrimaryAmmo");
				//g_iEllisPrimarySavedAmmoSlot1[iClient] = GetEntData(iProp, iOffset_Ammo + 12, iAmmo);
				//PrintToChatAll("g_iEllisPrimarySavedClipSlot1 %d", g_iEllisPrimarySavedClipSlot1[iClient]);
				//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot1 %d", g_iEllisPrimarySavedAmmoSlot1[iClient]);
				//g_iEllisPrimarySavedAmmoSlot1[iClient] = GetEntProp(iProp, Prop_Data, iOffset_Ammo2);
				//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot1 %d", g_iEllisPrimarySavedAmmoSlot1[iClient]);
				//g_iEllisPrimarySavedAmmoSlot1[iClient] = GetEntProp(iProp, Prop_Data, iOffset_Ammo3);
				//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot1 %d", g_iEllisPrimarySavedAmmoSlot1[iClient]);
				AcceptEntityInput(iProp, "Kill");
			}
		}
	}
	if((StrEqual(droppeditem, "pistol", false) == true) && (g_iRiskyLevel[iClient] == 5) && (g_bTalentsConfirmed[iClient] == true))
	{
		if(g_bNickStoresDroppedPistolAmmo[iClient] == true)
		{
			g_iNickSecondarySavedClipSlot2[iClient] = ((GetEntProp(iProp, Prop_Data, "m_iClip1") * 2));
		}
		else
		{
			g_bNickStoresDroppedPistolAmmo[iClient] = true;
		}
		//PrintToChatAll("Saving dropped pistol ammo");
		//PrintToChatAll("ClipSlot1 on drop w drop pistol = %d", g_iNickSecondarySavedClipSlot1[iClient]);
	}
	if((g_iRiskyLevel[iClient] == 5) && (g_bIsNickInSecondaryCycle[iClient] == false) && (StrEqual(droppeditem, "pistol", false) == true))
	{
		AcceptEntityInput(iProp, "Kill");
		AcceptEntityInput(iProp, "Kill");
		//PrintToChatAll("Killing nicks pistols");
	}
	//g_bIsNickInSecondaryCycle[iClient] == true
}

public Action:Event_PlayerIncap(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new incapper = GetClientOfUserId(GetEventInt(hEvent, "attacker"));
	
	g_bUsingTongueRope[iClient] = false;
	g_bIsClientDown[iClient] = true;
	g_iJockeyVictim[incapper] = -1;
	fnc_SetRendering(iClient);
	
	if(iClient < 1)
		return Plugin_Continue;
	if(g_iWillLevel[iClient]>0)
	{
		new currentHP=GetEntProp(iClient,Prop_Data,"m_iHealth");
		SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + (g_iWillLevel[iClient] * 50));
	}
	if(incapper > 0)
	{
		if(g_iClientTeam[incapper] == TEAM_INFECTED)
		{
			if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
			{
				if(IsClientInGame(incapper) == true)
					if(IsFakeClient(incapper) == false)
					{
						g_iStat_ClientSurvivorsIncaps[incapper]++;
						
						g_iClientXP[incapper] += 200;
						CheckLevel(incapper);
						
						if(g_iXPDisplayMode[incapper] == 0)
							ShowXPSprite(incapper, g_iSprite_200XP_SI, iClient, 6.0);
						else if(g_iXPDisplayMode[incapper] == 1)
							PrintCenterText(incapper, "\x03[XPMod] Incapacitated %d.  You gain 200 XP", iClient);
					}
			}
		}
	}
	if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
	{
		/*
		if(g_iNickDesperateMeasuresStack < 3)	//Dont allow desperate stack to go over 3 times
		{
			g_iNickDesperateMeasuresStack++;
			
			decl i;
			for(i=1;i<=MaxClients;i++)		//Check all the clients to see if they have despearate level up(Nick)
			{
				if(i == iClient)
					continue;
				if(g_iDesperateLevel[i] > 0)
				{
					if(RunClientChecks(i))
					{
						if(!IsFakeClient(i))
						{
							if(IsPlayerAlive(i) == true)
								if(g_iClientTeam[i]==TEAM_SURVIVORS)
								{
									SetEntDataFloat(i , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0 + (float(g_iMagnumLevel[i]) * 0.03) + (float(g_iNickDesperateMeasuresStack) * float(g_iDesperateLevel[i]) * 0.02), true);
									PrintHintText(i, "A teammate has fallen, your senses sharpen.");
								}
						}
					}
				}
				if(g_iDiehardLevel[i] > 0)
				{
					if(IsClientInGame(i)==true)
					{
						if(!IsFakeClient(i))
						{
							if(g_iClientTeam[i]==TEAM_SURVIVORS)
							{
								if(IsPlayerAlive(i) == true)
									if(g_bIsClientDown[i] == false)
									{
										new currentHP = GetEntProp(i,Prop_Data,"m_iHealth");
										if((currentHP + (g_iDiehardLevel[i] * 6)) < (100 + (g_iWillLevel[i]*5) + (g_iDiehardLevel[i]*15)))
											SetEntProp(i,Prop_Data,"m_iHealth", currentHP + (g_iDiehardLevel[i] * 6));
										else
											SetEntProp(i,Prop_Data,"m_iHealth", 100 + (g_iWillLevel[i]*5) + (g_iDiehardLevel[i]*15));
										PrintHintText(i, "A teammate has fallen, you gain %d health.", (g_iDiehardLevel[i] * 6));
									}
							}
						}
					}
				}
			}
		}
		*/
		g_iNickDesperateMeasuresStack++;
		decl i;
		for(i=1;i<=MaxClients;i++)
		{
			if(RunClientChecks(i) && g_iClientTeam[i]==TEAM_SURVIVORS && IsPlayerAlive(i) == true)
			{
				if(g_iNickDesperateMeasuresStack <= 3)
				{
					g_fClientSpeedBoost[i] += (g_iDesperateLevel[i] * 0.02);
					fnc_SetClientSpeed(i);
					PrintHintText(i, "A teammate has fallen, your senses sharpen.");
				}
			}
		}
		for(i=1;i<=MaxClients;i++)
		{
			if(g_iDiehardLevel[i] > 0)
			{
				if(RunClientChecks(i) && g_iClientTeam[i]==TEAM_SURVIVORS && IsPlayerAlive(i) == true)
				{
					if(g_bIsClientDown[i] == false)
					{
						new currentHP = GetEntProp(i,Prop_Data,"m_iHealth");
						if((currentHP + (g_iDiehardLevel[i] * 6)) < (100 + (g_iWillLevel[i]*5) + (g_iDiehardLevel[i]*15)))
							SetEntProp(i,Prop_Data,"m_iHealth", currentHP + (g_iDiehardLevel[i] * 6));
						else
							SetEntProp(i,Prop_Data,"m_iHealth", 100 + (g_iWillLevel[i]*5) + (g_iDiehardLevel[i]*15));
						PrintHintText(i, "A teammate has fallen, you gain %d health.", (g_iDiehardLevel[i] * 6));
					}
				}
			}
		}
		
		if(g_iClientTeam[incapper] == TEAM_INFECTED)
		{
			//Spitter conjure CI
			if(g_iPuppetLevel[incapper] > 0 && g_iInfectedCharacter[incapper] == SPITTER)
			{
				new Float:xyzLocation[3];
				GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", xyzLocation);
				
				xyzLocation[2] += 10.0;
				
				WriteParticle(iClient, "spitter_conjure", 180.0, 7.0, xyzLocation);
			
				new Handle:hDataPackage = CreateDataPack();
				WritePackCell(hDataPackage, incapper);
				WritePackFloat(hDataPackage, xyzLocation[0]);
				WritePackFloat(hDataPackage, xyzLocation[1]);
				WritePackFloat(hDataPackage, xyzLocation[2]);
				
				CreateTimer(2.3, TimerConjureCommonInfected, hDataPackage);
			}
		}
	}
	return Plugin_Continue;
}

public Action:Event_HealSuccess(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new target = GetClientOfUserId(GetEventInt(hEvent, "subject"));
	
	g_iKitsUsed++;
	//PrintToChatAll("g_iKitsUsed = %d", g_iKitsUsed);
	
	if(IsValidEntity(iClient) == false)
		return Plugin_Continue;
	if(IsClientInGame(iClient) == false)
		return Plugin_Continue;
	if(IsValidEntity(target) == false)
		return Plugin_Continue;
	if(IsClientInGame(target) == false)
		return Plugin_Continue;
	
	//Get their current health states
	new currentHP = GetEntProp(target,Prop_Data,"m_iHealth");
	new maxHP = GetEntProp(target,Prop_Data,"m_iMaxHealth");
	
	//Set what their health should be after health kit use
	if((currentHP + 100) > maxHP)
		SetEntProp(target,Prop_Data,"m_iHealth", maxHP);
	else
		SetEntProp(target,Prop_Data,"m_iHealth", currentHP + 100);
	if(g_iOverLevel[target] > 0)
	{
		new iCurrentHealth = GetEntProp(target,Prop_Data,"m_iHealth");
		new iMaxHealth = GetEntProp(target,Prop_Data,"m_iMaxHealth");
		//new Float:fTempHealth = GetEntDataFloat(target, g_iOffset_HealthBuffer);
		//if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - 20.0))
		if(iCurrentHealth < (iMaxHealth - 20.0))
		{
			if(g_bEllisOverSpeedDecreased[target] == false)
			{
				g_fClientSpeedBoost[target] -= (g_iOverLevel[target] * 0.02);
				fnc_SetClientSpeed(target);
				g_bEllisOverSpeedDecreased[target] = true;
				g_bEllisOverSpeedIncreased[target] = false;
			}
			//g_fEllisOverSpeed[target] = 0.0;
			//SetEntDataFloat(target , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[target] + g_fEllisBringSpeed[target] + g_fEllisOverSpeed[target]), true);
			//DeleteCode
			//PrintToChatAll("Heal success, now setting g_fEllisOverSpeed");
			//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[target]);
			//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[target]);
			//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[target]);
		}
		//else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
		if(iCurrentHealth >= (iMaxHealth - 20.0))
		{
			if(g_bEllisOverSpeedIncreased[target] == false)
			{
				g_fClientSpeedBoost[target] += (g_iOverLevel[target] * 0.02);
				fnc_SetClientSpeed(target);
				g_bEllisOverSpeedDecreased[target] = false;
				g_bEllisOverSpeedIncreased[target] = true;
			}
			//g_fEllisOverSpeed[target] = (g_iOverLevel[target] * 0.02);
			//SetEntDataFloat(target , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[target] + g_fEllisBringSpeed[target] + g_fEllisOverSpeed[target]), true);
			//DeleteCode
			//PrintToChatAll("Heal success, now setting g_fEllisOverSpeed");
			//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[target]);
			//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[target]);
			//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[target]);
		}
	}
	if(g_iChosenSurvivor[iClient] == 4)
	{
		if(g_iLeftoverLevel[iClient]>0)
		{
			decl number;
			number = GetRandomInt(1, 133);
			
			if(g_iLeftoverLevel[iClient]==1)
			{
				if(number<=8)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give pain_pills");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain pain pills");
				}
				else if(number>8 && number <=14)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give adrenaline");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain an adrenaline shot");
				}
				else if(number>14 && number <=18)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give defibrillator");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain a defibrillator");
				}
				else if(number>18 && number <=20)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give first_aid_kit");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain a medkit");
				}
				else
					PrintHintText(iClient, "No luck this time, You gain no items");
			}
			else if(g_iLeftoverLevel[iClient]==2)
			{
				if(number<=16)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give pain_pills");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain pain pills");
				}
				else if(number>16&& number <=28)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give adrenaline");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain an adrenaline shot");
				}
				else if(number>28 && number <=36)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give defibrillator");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain a defibrillator");
				}
				else if(number>36 && number <=40)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give first_aid_kit");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain a medkit");
				}
				else
					PrintHintText(iClient, "No luck this time, You gain no items");
			}
			else if(g_iLeftoverLevel[iClient]==3)
			{
				if(number<=24)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give pain_pills");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain pain pills");
				}
				else if(number>24 && number <=42)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give adrenaline");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain an adrenaline shot");
				}
				else if(number>42 && number <=54)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give defibrillator");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain a defibrillator");
				}
				else if(number>54 && number <=60)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give first_aid_kit");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain a medkit");
				}
				else
					PrintHintText(iClient, "No luck this time, You gain no items");
			}
			else if(g_iLeftoverLevel[iClient]==4)
			{
				if(number<=32)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give pain_pills");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain pain pills");
				}
				else if(number>32 && number <=56)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give adrenaline");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain an adrenaline shot");
				}
				else if(number>56 && number <=72)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give defibrillator");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain a defibrillator");
				}
				else if(number>72 && number <=80)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give first_aid_kit");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain a medkit");
				}
				else
					PrintHintText(iClient, "No luck this time, You gain no items");
			}
			else if(g_iLeftoverLevel[iClient]==5)
			{
				if(number<=40)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give pain_pills");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain pain pills");
				}
				else if(number>40 && number <=70)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give adrenaline");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain an adrenaline shot");
				}
				else if(number>70 && number <=90)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give defibrillator");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain a defibrillator");
				}
				else if(number>90 && number <=100)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give first_aid_kit");
					SetCommandFlags("give", g_iFlag_Give);
					PrintHintText(iClient, "You gain a medkit");
				}
				else
					PrintHintText(iClient, "No luck this time, You gain no items");
			}
		}
	}
	/*
	if((g_iChosenSurvivor[iClient] == 4) && (g_iSwindlerLevel[iClient] > 0))
	{
		if(g_bNickSwindlerHealthCapped[iClient] == false)
		{
			maxHP = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
			currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
			g_iNickSwindlerBonusHealth[iClient] += (g_iSwindlerLevel[iClient] * 3);
			if(g_iNickSwindlerBonusHealth[iClient] < 100)
			{
				SetEntProp(iClient,Prop_Data,"m_iMaxHealth", maxHP + (g_iSwindlerLevel[iClient] * 3));
				SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + (g_iSwindlerLevel[iClient] * 3));
				//PrintToChatAll("g_iNickSwindlerBonusHealth[iClient] < 100");
			}
			else if(g_iNickSwindlerBonusHealth[iClient] > 100)
			{
				SetEntProp(iClient,Prop_Data,"m_iMaxHealth", maxHP + (100 - (g_iNickSwindlerBonusHealth[iClient] - (g_iSwindlerLevel[iClient] * 3))));
				SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + (100 - (g_iNickSwindlerBonusHealth[iClient] - (g_iSwindlerLevel[iClient] * 3))));
				//PrintToChatAll("g_iNickSwindlerBonusHealth[iClient] > 100");
				g_bNickSwindlerHealthCapped[iClient] = true;
			}
			//g_iNickMaxHealth[iClient] = maxHP + (g_iSwindlerLevel[i] * 3);
			//PrintToChatAll("g_iNickSwindlerBonusHealth == %d", g_iNickSwindlerBonusHealth[iClient]);
		}
	}
	*/
	for(new i=1;i<=MaxClients;i++)		//For talents that change cvars get the highest level for each before unfreezing
	{
		if(RunClientChecks(i) && IsPlayerAlive(i) == true)
		{
			if((g_iSwindlerLevel[i]>0) && (g_bTalentsConfirmed[i] == true))
			{
				if(i!=iClient)
				{
					if(IsFakeClient(i) == false)
					{
						if(g_iClientTeam[i]==TEAM_SURVIVORS)
						{
							/*
							maxHP = GetEntProp(i,Prop_Data,"m_iMaxHealth");
							if(maxHP < 300)
							{
								SetEntProp(i,Prop_Data,"m_iMaxHealth", maxHP + (g_iSwindlerLevel[i] * 3));
								g_iNickMaxHealth[i] = maxHP + (g_iSwindlerLevel[i] * 3);
							}
							
							currentHP = GetEntProp(i,Prop_Data,"m_iHealth");
							if(currentHP < 300)
								SetEntProp(i,Prop_Data,"m_iHealth", currentHP + (g_iSwindlerLevel[i] * 3));
							else
								SetEntProp(i,Prop_Data,"m_iHealth", 300);
							*/
							if(g_bNickSwindlerHealthCapped[i] == false)
							{
								maxHP = GetEntProp(i,Prop_Data,"m_iMaxHealth");
								currentHP = GetEntProp(i,Prop_Data,"m_iHealth");
								g_iNickSwindlerBonusHealth[i] += (g_iSwindlerLevel[i] * 3);
								if(g_iNickSwindlerBonusHealth[i] < 100)
								{
									SetEntProp(i,Prop_Data,"m_iMaxHealth", maxHP + (g_iSwindlerLevel[i] * 3));
									SetEntProp(i,Prop_Data,"m_iHealth", currentHP + (g_iSwindlerLevel[i] * 3));
									//PrintToChatAll("g_iNickSwindlerBonusHealth[i] < 100");
								}
								else if(g_iNickSwindlerBonusHealth[i] > 100)
								{
									SetEntProp(i,Prop_Data,"m_iMaxHealth", maxHP + (100 - (g_iNickSwindlerBonusHealth[i] - (g_iSwindlerLevel[i] * 3))));
									SetEntProp(i,Prop_Data,"m_iHealth", currentHP + (100 - (g_iNickSwindlerBonusHealth[i] - (g_iSwindlerLevel[i] * 3))));
									//PrintToChatAll("g_iNickSwindlerBonusHealth[i] > 100");
									g_bNickSwindlerHealthCapped[i] = true;
								}
								//SetEntProp(i,Prop_Data,"m_iMaxHealth", maxHP + (g_iSwindlerLevel[i] * 3));
								//SetEntProp(i,Prop_Data,"m_iHealth", currentHP + (g_iSwindlerLevel[i] * 3));
								//g_iNickMaxHealth[i] = maxHP + (g_iSwindlerLevel[i] * 3);
								//PrintToChatAll("g_iNickSwindlerBonusHealth[iClient] < 100");
								//PrintToChatAll("g_iNickSwindlerBonusHealth == %d", g_iNickSwindlerBonusHealth[i]);
								
								// if(g_iNickSwindlerBonusHealth[iClient] < 100)
								// {
								// 	g_iNickSwindlerBonusHealth[iClient] += (g_iSwindlerLevel[i] * 3);
								// 	SetEntProp(i,Prop_Data,"m_iMaxHealth", maxHP + (g_iSwindlerLevel[i] * 3));
								// 	g_iNickMaxHealth[i] = maxHP + (g_iSwindlerLevel[i] * 3);
								// 	PrintToChatAll("g_iNickSwindlerBonusHealth[iClient] < 100");
								// 	PrintToChatAll("g_iNickSwindlerBonusHealth == %d", g_iNickSwindlerBonusHealth[iClient]);
								// }
								// else if(g_iNickSwindlerBonusHealth[iClient] > 100)
								// {
								// 	g_iNickSwindlerBonusHealth[iClient] == 100;
								// }
								
								// currentHP = GetEntProp(i,Prop_Data,"m_iHealth");
								// if(g_iNickSwindlerBonusHealth[iClient] < 100)
								// {
								// 	PrintToChatAll("");
								// 	SetEntProp(i,Prop_Data,"m_iHealth", currentHP + (g_iSwindlerLevel[i] * 3));
								// }
								
								/*
								else if(g_iNickSwindlerBonusHealth[iClient] > 100)
								{
									SetEntProp(i,Prop_Data,"m_iHealth", 300);
								}
								*/
							}
						}
					}
				}
			}
		}
	}
	if (iClient > 0 && iClient <= MaxClients)
	{
		if(IsFakeClient(iClient) == true)
			return Plugin_Continue;
		if (iClient != target)
		{
			g_iClientXP[iClient] += 50;
			CheckLevel(iClient);
			
			if(g_iXPDisplayMode[iClient] == 0)
				ShowXPSprite(iClient, g_iSprite_50XP, target);
			else if(g_iXPDisplayMode[iClient] == 1)
				PrintToChat(iClient, "\x03[XPMod] Healed a teammate. You gain 50 XP.");
		}
	}
	return Plugin_Continue;
}

public Action:Event_DefibUsed(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iSubject = GetClientOfUserId(GetEventInt(hEvent,"subject"));
	new iClient  = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	
	GiveClientXP(iClient, 100, g_iSprite_100XP, iSubject, "Defibrillated Player.");
	if(g_iOverLevel[iSubject] > 0)
	{
		new iCurrentHealth = GetEntProp(iSubject,Prop_Data,"m_iHealth");
		new iMaxHealth = GetEntProp(iSubject,Prop_Data,"m_iMaxHealth");
		//new Float:fTempHealth = GetEntDataFloat(iSubject, g_iOffset_HealthBuffer);
		//if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - 20.0))
		if(iCurrentHealth < (iMaxHealth - 20.0))
		{
			if(g_bEllisOverSpeedDecreased[iSubject] == false)
			{
				g_fClientSpeedBoost[iSubject] -= (g_iOverLevel[iSubject] * 0.02);
				fnc_SetClientSpeed(iSubject);
				g_bEllisOverSpeedDecreased[iSubject] = true;
				g_bEllisOverSpeedIncreased[iSubject] = false;
			}
			//g_fEllisOverSpeed[iSubject] = 0.0;
			//SetEntDataFloat(iSubject , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iSubject] + g_fEllisBringSpeed[iSubject] + g_fEllisOverSpeed[iSubject]), true);
		}
		//else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
		if(iCurrentHealth >= (iMaxHealth - 20.0))
		{
			if(g_bEllisOverSpeedIncreased[iSubject] == false)
			{
				g_fClientSpeedBoost[iSubject] += (g_iOverLevel[iSubject] * 0.02);
				fnc_SetClientSpeed(iSubject);
				g_bEllisOverSpeedDecreased[iSubject] = false;
				g_bEllisOverSpeedIncreased[iSubject] = true;
			}
			//g_fEllisOverSpeed[iSubject] = (g_iOverLevel[iSubject] * 0.02);
			//SetEntDataFloat(iSubject , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iSubject] + g_fEllisBringSpeed[iSubject] + g_fEllisOverSpeed[iSubject]), true);
		}
	}
	fnc_SetClientSpeed(iSubject);
	return Plugin_Continue;
}

public Action:Event_UpgradePackUsed(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient  = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	
	GiveClientXP(iClient, 25, g_iSprite_25XP, iClient, "Deployed iAmmo pack.");
	return Plugin_Continue;
}


public Action:Event_PillsUsed(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	
	if(iClient < 1)
		return Plugin_Continue;
	
	if(g_iOverLevel[iClient] > 0 && IsFakeClient(iClient) == false)
	{
		new iMaxHealth = GetEntProp(iClient, Prop_Data, "m_iMaxHealth");
		new iHealth = GetEntProp(iClient, Prop_Data, "m_iHealth");
		new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);
		
		if(float(iHealth) + fTempHealth + (float(g_iOverLevel[iClient]) * 4.0) <= float(iMaxHealth))
			fTempHealth = fTempHealth + (float(g_iOverLevel[iClient]) * 4.0);
		else
			fTempHealth = float(iMaxHealth) - float(iHealth);
		
		SetEntDataFloat(iClient,g_iOffset_HealthBuffer, fTempHealth ,true);
	}
	else if(g_iEnhancedLevel[iClient] > 0 && IsFakeClient(iClient) == false)
	{
		new iMaxHealth = GetEntProp(iClient, Prop_Data, "m_iMaxHealth");
		new iHealth = GetEntProp(iClient, Prop_Data, "m_iHealth");
		new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);
		
		if(float(iHealth) + fTempHealth + (float(g_iEnhancedLevel[iClient]) * 6.0) <= float(iMaxHealth))
			fTempHealth = fTempHealth + (float(g_iEnhancedLevel[iClient]) * 6.0);
		else
			fTempHealth = float(iMaxHealth) - float(iHealth);
		
		SetEntDataFloat(iClient,g_iOffset_HealthBuffer, fTempHealth ,true);
	}
	
	// if(g_iOverLevel[iClient] > 0)
	// {
	// 	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	// 	new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	// 	new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);
	// 	if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - 20.0))
	// 	{
	// 		g_fEllisOverSpeed[iClient] = 0.0;
	// 		SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iClient] + g_fEllisBringSpeed[iClient] + g_fEllisOverSpeed[iClient]), true);
	// 		//DeleteCode
	// 		PrintToChatAll("Pills used, now setting g_fEllisOverSpeed");
	// 		PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[iClient]);
	// 		PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[iClient]);
	// 		PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[iClient]);
	// 	}
	// 	else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
	// 	{
	// 		g_fEllisOverSpeed[iClient] = (g_iOverLevel[iClient] * 0.02);
	// 		SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iClient] + g_fEllisBringSpeed[iClient] + g_fEllisOverSpeed[iClient]), true);
	// 		//DeleteCode
	// 		PrintToChatAll("Pills used, now setting g_fEllisOverSpeed");
	// 		PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[iClient]);
	// 		PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[iClient]);
	// 		PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[iClient]);
	// 	}
	// }
	
	decl i, iLoopedClientMaxHP, iLoopedClientCurrentHP;
	for(i = 1; i <= MaxClients; i++)		//For all the Nicks on the team, increase their health for Enhanced Pain Killers Talent
	{
		if(g_iEnhancedLevel[i] > 0 && i != iClient && g_iClientTeam[i] == TEAM_SURVIVORS && IsClientInGame(i)==true && IsFakeClient(i) == false)
		{
			iLoopedClientMaxHP = GetEntProp(i, Prop_Data, "m_iMaxHealth");			
			iLoopedClientCurrentHP = GetEntProp(i, Prop_Data, "m_iHealth");
			if(g_iEnhancedLevel[i] < 5)
			{
				if(iLoopedClientCurrentHP + g_iEnhancedLevel[i] < iLoopedClientMaxHP)
					SetEntProp(i, Prop_Data, "m_iHealth", iLoopedClientCurrentHP + g_iEnhancedLevel[i]);
				else
					SetEntProp(i , Prop_Data,"m_iHealth", iLoopedClientMaxHP);
			}
			else
			{
				if(iLoopedClientCurrentHP + g_iEnhancedLevel[i] < iLoopedClientMaxHP)
					SetEntProp(i, Prop_Data, "m_iHealth", iLoopedClientCurrentHP + g_iEnhancedLevel[i] + 3);
				else
					SetEntProp(i , Prop_Data,"m_iHealth", iLoopedClientMaxHP);
			}
		}
	}
		
	return Plugin_Continue;
}

public Action:Event_AdrenalineUsed(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	
	if(iClient < 1)
		return Plugin_Continue;

	if(g_iOverLevel[iClient] > 0 && IsFakeClient(iClient) == false)
	{
		new iMaxHealth = GetEntProp(iClient, Prop_Data, "m_iMaxHealth");
		new iHealth = GetEntProp(iClient, Prop_Data, "m_iHealth");
		new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);
		
		if(float(iHealth) + fTempHealth + (float(g_iOverLevel[iClient]) * 4.0) <= float(iMaxHealth))
			fTempHealth = fTempHealth + (float(g_iOverLevel[iClient]) * 4.0);
		else
			fTempHealth = float(iMaxHealth) - float(iHealth);
		
		SetEntDataFloat(iClient,g_iOffset_HealthBuffer, fTempHealth ,true);
	}
	else if(g_iEnhancedLevel[iClient] > 0 && IsFakeClient(iClient) == false)
	{
		new iMaxHealth = GetEntProp(iClient, Prop_Data, "m_iMaxHealth");
		new iHealth = GetEntProp(iClient, Prop_Data, "m_iHealth");
		new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);
		
		if(float(iHealth) + fTempHealth + (float(g_iEnhancedLevel[iClient]) * 6.0) <= float(iMaxHealth))
			fTempHealth = fTempHealth + (float(g_iEnhancedLevel[iClient]) * 6.0);
		else
			fTempHealth = float(iMaxHealth) - float(iHealth);
		
		SetEntDataFloat(iClient,g_iOffset_HealthBuffer, fTempHealth ,true);
	}
	
	// if(g_iOverLevel[iClient] > 0)
	// {
	// 	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	// 	new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	// 	new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);
	// 	if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - 20.0))
	// 	{
	// 		g_fEllisOverSpeed[iClient] = 0.0;
	// 		SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iClient] + g_fEllisBringSpeed[iClient] + g_fEllisOverSpeed[iClient]), true);
	// 		//DeleteCode
	// 		PrintToChatAll("Adrenaline used, now setting g_fEllisOverSpeed");
	// 		PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[iClient]);
	// 		PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[iClient]);
	// 		PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[iClient]);
	// 	}
	// 	else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
	// 	{
	// 		g_fEllisOverSpeed[iClient] = (g_iOverLevel[iClient] * 0.02);
	// 		SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iClient] + g_fEllisBringSpeed[iClient] + g_fEllisOverSpeed[iClient]), true);
	// 		//DeleteCode
	// 		PrintToChatAll("Adrenaline used, now setting g_fEllisOverSpeed");
	// 		PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[iClient]);
	// 		PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[iClient]);
	// 		PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[iClient]);
	// 	}
	// }
	
	decl i, iLoopedClientMaxHP, iLoopedClientCurrentHP;
	for(i = 1; i <= MaxClients; i++)		//For all the Nicks on the team, increase their health for Enhanced Pain Killers Talent
	{
		if(g_iEnhancedLevel[i] > 0 && i != iClient && g_iClientTeam[i] == TEAM_SURVIVORS && IsClientInGame(i)==true && IsFakeClient(i) == false)
		{
			iLoopedClientMaxHP = GetEntProp(i, Prop_Data, "m_iMaxHealth");			
			iLoopedClientCurrentHP = GetEntProp(i, Prop_Data, "m_iHealth");
			if(g_iEnhancedLevel[i] < 5)
			{
				if(iLoopedClientCurrentHP + g_iEnhancedLevel[i] < iLoopedClientMaxHP)
					SetEntProp(i, Prop_Data, "m_iHealth", iLoopedClientCurrentHP + g_iEnhancedLevel[i]);
				else
					SetEntProp(i , Prop_Data,"m_iHealth", iLoopedClientMaxHP);
			}
			else
			{
				if(iLoopedClientCurrentHP + g_iEnhancedLevel[i] < iLoopedClientMaxHP)
					SetEntProp(i, Prop_Data, "m_iHealth", iLoopedClientCurrentHP + g_iEnhancedLevel[i] + 3);
				else
					SetEntProp(i , Prop_Data,"m_iHealth", iLoopedClientMaxHP);
			}
		}
	}
	return Plugin_Continue;
}

//Temporarily removed to contain an exploit

public Action:Event_WeaponGiven(Handle:hEvent, const String:strName[], bool:bDontBroadcast)	//For Pills and Shots
{
	//PrintToChatAll("Event_WeaponGiven");
	/*
	new iTaker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new iGiver  = GetClientOfUserId(GetEventInt(hEvent,"giver"));
	//Not needed because only adrenaline or pills can be given
	//new iWeapon  = GetClientOfUserId(GetEventInt(hEvent,"weapon"));	
	
	GiveClientXP(iGiver, 25, g_iSprite_25XP, iTaker, "Health Boost given to player.");
	*/
	return Plugin_Continue;
}

public Action:Event_ReceiveUpgrade(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	decl String:strUpgrade[32];
	GetEventString(hEvent, "upgrade", strUpgrade, sizeof(strUpgrade));
	//PrintToChatAll("g_strCurrentAmmoUpgrade = %s", g_strCurrentAmmoUpgrade);
	//g_strCurrentAmmoUpgrade = UpgradeString;
	//PrintToChat(iClient, "Picked up UPGRADE %s", UpgradeString);
	//PrintToChatAll("Received an upgrade");
	if((StrEqual(strUpgrade, "EXPLOSIVE_AMMO", false) == true) || (StrEqual(strUpgrade, "INCENDIARY_AMMO", false) == true))
	{
		g_strCurrentAmmoUpgrade = strUpgrade;
	}
	g_strCheckAmmoUpgrade = strUpgrade;
	//fnc_DeterminePrimaryWeapon(iClient);
	//fnc_SaveAmmo(iClient);
	fnc_DetermineMaxClipSize(iClient);
	//fnc_SetAmmoUpgrade(iClient);
	fnc_SetAmmoUpgradeToMaxClipSize(iClient);
}
