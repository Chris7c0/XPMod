Action:Event_WeaponFire(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
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
			if(g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY || g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY)
			{
				StoreCurrentPrimaryWeapon(iClient);
				new String:strCurrentWeapon[32];
				GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
				if((StrContains(strCurrentWeapon, "rifle", false) != -1) || (StrContains(strCurrentWeapon, "smg", false) != -1) || (StrContains(strCurrentWeapon, "shotgun", false) != -1) || (StrContains(strCurrentWeapon, "launcher", false) != -1) || (StrContains(strCurrentWeapon, "sniper", false) != -1))
				{
					StoreCurrentPrimaryWeaponAmmo(iClient);
				}
			}
			new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (IsValidEntity(ActiveWeaponID) == false)
				return Plugin_Continue;
			new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");

			if((CurrentClipAmmo == 0) || (CurrentClipAmmo == 1))
			{
				StoreCurrentPrimaryWeapon(iClient);
				new String:strCurrentWeapon[32];
				GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));

				if(g_iReserveAmmo[iClient] == 0)
				{
					//PrintToChatAll("Ammo is now 0");
					if (g_iEllisCurrentPrimarySlot[iClient] == 0 &&
						g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY && 
						(g_iEllisPrimarySavedClipSlot1[iClient] > 0 || g_iEllisPrimarySavedAmmoSlot1[iClient] > 0))
					{
						//StoreCurrentPrimaryWeapon(iClient);
						if((StrContains(strCurrentWeapon, "rifle", false) != -1) || (StrContains(strCurrentWeapon, "smg", false) != -1) || (StrContains(strCurrentWeapon, "shotgun", false) != -1) || (StrContains(strCurrentWeapon, "launcher", false) != -1) || (StrContains(strCurrentWeapon, "sniper", false) != -1))
						{
							StoreCurrentPrimaryWeaponAmmo(iClient);
							CyclePlayerWeapon(iClient);
							//fnc_SetAmmo(iClient);
						}
					}
					else if (g_iEllisCurrentPrimarySlot[iClient] == 1 && 
							g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY && 
							(g_iEllisPrimarySavedClipSlot0[iClient] > 0 || g_iEllisPrimarySavedAmmoSlot0[iClient] > 0))
					{
						//StoreCurrentPrimaryWeapon(iClient);
						if((StrContains(strCurrentWeapon, "rifle", false) != -1) || (StrContains(strCurrentWeapon, "smg", false) != -1) || (StrContains(strCurrentWeapon, "shotgun", false) != -1) || (StrContains(strCurrentWeapon, "launcher", false) != -1) || (StrContains(strCurrentWeapon, "sniper", false) != -1))
						{
							StoreCurrentPrimaryWeaponAmmo(iClient);
							CyclePlayerWeapon(iClient);
							//fnc_SetAmmo(iClient);
						}
					}
				}
			}
		}
		case 4:		//Nick Firing
		{
			new String:strCurrentWeapon[32];
			GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
			
			// Handle Rambo Mode
			if(g_bRamboModeActive[iClient] == true)
			{
				new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
				if (RunEntityChecks(ActiveWeaponID) == false)
					return Plugin_Continue;

				// Check if the currently active weapon is the rambo weapon
				if (ActiveWeaponID == g_iRamboWeaponID[iClient])
				{
					//PrintToChatAll("Nick is firing with m60 and rambo mode");
					if (IsValidEntity(g_iRamboWeaponID[iClient]) && HasEntProp(g_iRamboWeaponID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
					{
						SetEntData(g_iRamboWeaponID[iClient], g_iOffset_Clip1, 250, true);
						SetEntProp(g_iRamboWeaponID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", 251);
					}
				}
				// Otherwise, store the ammo of the current weapon if its not rambo
				else
				{
					StoreCurrentPrimaryWeaponAmmo(iClient);
				}
			}
			//g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
			
			if((StrEqual(strCurrentWeapon, "weapon_pistol_magnum", false) == true) && (g_iMagnumLevel[iClient] > 0))
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
			case BILL:		//Bill Reload
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
			case ROCHELLE:		//Rochelle Reload
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
			case COACH:		//Coach Reload
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
			case ELLIS:		//Ellis Reload
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
			case NICK:		//Nicks Reload
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
			case LOUIS:
			{
				if (g_iLouisTalent2Level[iClient] > 0)
				{
					//PrintToChat(iClient, "LOUIS currentweapon: %s, CurrentClipAmmo: %i", currentweapon, CurrentClipAmmo);
					if (CurrentClipAmmo > 0 &&
						(StrContains(currentweapon, "weapon_smg", false) != -1) )
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
						SetEntData(iClient, iOffset_Ammo + 20, iAmmo - (g_iLouisTalent2Level[iClient] * 10));

						SetEntData(ActiveWeaponID, g_iOffset_Clip1, CurrentClipAmmo + (g_iLouisTalent2Level[iClient] * 10), true);

						g_bClientIsReloading[iClient] = false;
						g_iReloadFrameCounter[iClient] = 0;
					}
					else if (((CurrentClipAmmo == 15) || (CurrentClipAmmo == 30)) &&
						(StrEqual(currentweapon, "weapon_pistol", false) == true) )
					{
						// 1 pistol
						if(CurrentClipAmmo == 15)
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iLouisTalent2Level[iClient] * 10)), true);
						// 2 pistols
						else if(CurrentClipAmmo == 30)
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iLouisTalent2Level[iClient] * 10 * 2)), true);

						g_bClientIsReloading[iClient] = false;
						g_iReloadFrameCounter[iClient] = 0;
					}
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

	// 	RunCheatCommand(iClient, "upgrade_remove", "upgrade_remove EXPLOSIVE_AMMO");

	// 	PrintToChatAll("Setting upgrades for Rambo Mode M60");
	// 	SetEntData(wID, g_iOffset_Clip1, 251, true);

	// 	RunCheatCommand(iClient, "upgrade_add", "upgrade_add EXPLOSIVE_AMMO");

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

	// PrintToChat(iClient, "g_iEllisJamminGrenadeCounter %i", g_iEllisJamminGrenadeCounter[iClient]);
	// PrintToChat(iClient, "g_iEventWeaponFireCounter %i", g_iEventWeaponFireCounter[iClient]);

	if((g_iJamminLevel[iClient] == 5) && 
		g_iEllisJamminGrenadeCounter[iClient] > 0 &&
		(StrEqual(wclass,"pipe_bomb",false) == true || 
		 StrEqual(wclass,"molotov",false) == true ||
		 StrEqual(wclass,"vomitjar",false) == true))
	{
		CreateTimer(1.5, TimerEllisJamminGiveMolotov, iClient, TIMER_FLAG_NO_MAPCHANGE);
		g_iEllisJamminGrenadeCounter[iClient]--;
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

Action:Event_ReviveSuccess(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	int iTarget = GetClientOfUserId(GetEventInt(hEvent, "subject"));
	bool bWasHanging = GetEventBool(hEvent, "ledge_hang");
	
	//DebugLog(DEBUG_MODE_VERBOSE, "Event_ReviveSuccess, iClient %i, iTarget %i", iClient, iTarget);

	g_bIsClientDown[iTarget] = false;
	clienthanging[iTarget] = false;
	EndSelfRevive(iTarget);

	if(RunClientChecks(iTarget) == false)
		return Plugin_Continue;

	// Nicks Desperate Measures (dont run this on ledges)
	if (!bWasHanging && SetAllNicksDesprateMeasuresStacks())
		SetAllNicksDesprateMeasureSpeed("A teammate has been revived, your senses return to a weaker state.");
	
	SetClientSpeed(iTarget);
	SetClientRenderAndGlowColor(iTarget);

	if(IsFakeClient(iClient) == true)
		return Plugin_Continue;
	
	if (iClient > 0 && iClient <= MaxClients)
	{
		if (iClient != iTarget)
		{
			g_iClientXP[iClient] += 50;
			CheckLevel(iClient);
			
			if(g_iXPDisplayMode[iClient] == 0)
				ShowXPSprite(iClient, g_iSprite_50XP, iTarget);
			else if(g_iXPDisplayMode[iClient] == 1)
				PrintToChat(iClient, "\x03[XPMod] Revived a teammate. You gain 50 XP.");
		}
	}
	return Plugin_Continue;
}

Event_LedgeGrab(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//need an event for if the iClient gets up off the ledge to make clienthanging false
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	clienthanging[iClient] = true;

	// Self Revive Message
	if (g_iSelfRevives[iClient] > 0 && IsFakeClient(iClient) == false)
	{
		PrintHintText(iClient, "You have %i Self Revive%s.\nHOLD USE to revive yourself.", g_iSelfRevives[iClient], g_iSelfRevives[iClient] != 1 ? "s" : "");
	}
}

Action:Event_InfectedDecap(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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

Action:Event_PlayerIncap(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new incapper = GetClientOfUserId(GetEventInt(hEvent, "attacker"));
	
	g_bUsingTongueRope[iClient] = false;
	g_bIsClientDown[iClient] = true;
	g_iJockeyVictim[incapper] = -1;
	SetClientRenderAndGlowColor(iClient);
	
	if(RunClientChecks(iClient) == false)
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
		// Update Nicks Desperate Measures Stacks
		if (SetAllNicksDesprateMeasuresStacks())
			SetAllNicksDesprateMeasureSpeed("A teammate has fallen, your senses sharpen.");

		for(int i=1;i<=MaxClients;i++)
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

		// Self Revive Message
		if (g_iSelfRevives[iClient] > 0 && IsFakeClient(iClient) == false)
		{
			PrintHintText(iClient, "You have %i Self Revive%s.\nHOLD USE to revive yourself.", g_iSelfRevives[iClient], g_iSelfRevives[iClient] != 1 ? "s" : "");
		}
	}
	return Plugin_Continue;
}

Action:Event_HealSuccess(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
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
			if(g_bEllisOverSpeedIncreased[target])
			{
				g_bEllisOverSpeedIncreased[target] = false;

				SetClientSpeed(target);
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
				g_bEllisOverSpeedIncreased[target] = true;

				SetClientSpeed(target);
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

					RunCheatCommand(iClient, "give", "give pain_pills");

					PrintHintText(iClient, "You gain pain pills");
				}
				else if(number>8 && number <=14)
				{

					RunCheatCommand(iClient, "give", "give adrenaline");

					PrintHintText(iClient, "You gain an adrenaline shot");
				}
				else if(number>14 && number <=18)
				{

					RunCheatCommand(iClient, "give", "give defibrillator");

					PrintHintText(iClient, "You gain a defibrillator");
				}
				else if(number>18 && number <=20)
				{

					RunCheatCommand(iClient, "give", "give first_aid_kit");

					PrintHintText(iClient, "You gain a medkit");
				}
				else
					PrintHintText(iClient, "No luck this time, You gain no items");
			}
			else if(g_iLeftoverLevel[iClient]==2)
			{
				if(number<=16)
				{

					RunCheatCommand(iClient, "give", "give pain_pills");

					PrintHintText(iClient, "You gain pain pills");
				}
				else if(number>16&& number <=28)
				{

					RunCheatCommand(iClient, "give", "give adrenaline");

					PrintHintText(iClient, "You gain an adrenaline shot");
				}
				else if(number>28 && number <=36)
				{

					RunCheatCommand(iClient, "give", "give defibrillator");

					PrintHintText(iClient, "You gain a defibrillator");
				}
				else if(number>36 && number <=40)
				{

					RunCheatCommand(iClient, "give", "give first_aid_kit");

					PrintHintText(iClient, "You gain a medkit");
				}
				else
					PrintHintText(iClient, "No luck this time, You gain no items");
			}
			else if(g_iLeftoverLevel[iClient]==3)
			{
				if(number<=24)
				{

					RunCheatCommand(iClient, "give", "give pain_pills");

					PrintHintText(iClient, "You gain pain pills");
				}
				else if(number>24 && number <=42)
				{

					RunCheatCommand(iClient, "give", "give adrenaline");

					PrintHintText(iClient, "You gain an adrenaline shot");
				}
				else if(number>42 && number <=54)
				{

					RunCheatCommand(iClient, "give", "give defibrillator");

					PrintHintText(iClient, "You gain a defibrillator");
				}
				else if(number>54 && number <=60)
				{

					RunCheatCommand(iClient, "give", "give first_aid_kit");

					PrintHintText(iClient, "You gain a medkit");
				}
				else
					PrintHintText(iClient, "No luck this time, You gain no items");
			}
			else if(g_iLeftoverLevel[iClient]==4)
			{
				if(number<=32)
				{

					RunCheatCommand(iClient, "give", "give pain_pills");

					PrintHintText(iClient, "You gain pain pills");
				}
				else if(number>32 && number <=56)
				{

					RunCheatCommand(iClient, "give", "give adrenaline");

					PrintHintText(iClient, "You gain an adrenaline shot");
				}
				else if(number>56 && number <=72)
				{

					RunCheatCommand(iClient, "give", "give defibrillator");

					PrintHintText(iClient, "You gain a defibrillator");
				}
				else if(number>72 && number <=80)
				{

					RunCheatCommand(iClient, "give", "give first_aid_kit");

					PrintHintText(iClient, "You gain a medkit");
				}
				else
					PrintHintText(iClient, "No luck this time, You gain no items");
			}
			else if(g_iLeftoverLevel[iClient]==5)
			{
				if(number<=40)
				{

					RunCheatCommand(iClient, "give", "give pain_pills");

					PrintHintText(iClient, "You gain pain pills");
				}
				else if(number>40 && number <=70)
				{

					RunCheatCommand(iClient, "give", "give adrenaline");

					PrintHintText(iClient, "You gain an adrenaline shot");
				}
				else if(number>70 && number <=90)
				{

					RunCheatCommand(iClient, "give", "give defibrillator");

					PrintHintText(iClient, "You gain a defibrillator");
				}
				else if(number>90 && number <=100)
				{

					RunCheatCommand(iClient, "give", "give first_aid_kit");

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

Action:Event_DefibUsed(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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
			if(g_bEllisOverSpeedIncreased[iSubject])
			{
				g_bEllisOverSpeedIncreased[iSubject] = false;

				SetClientSpeed(iSubject);
			}
			//g_fEllisOverSpeed[iSubject] = 0.0;
			//SetEntDataFloat(iSubject , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iSubject] + g_fEllisBringSpeed[iSubject] + g_fEllisOverSpeed[iSubject]), true);
		}
		//else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
		if(iCurrentHealth >= (iMaxHealth - 20.0))
		{
			if(g_bEllisOverSpeedIncreased[iSubject] == false)
			{
				g_bEllisOverSpeedIncreased[iSubject] = true;

				SetClientSpeed(iSubject);
			}
			//g_fEllisOverSpeed[iSubject] = (g_iOverLevel[iSubject] * 0.02);
			//SetEntDataFloat(iSubject , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iSubject] + g_fEllisBringSpeed[iSubject] + g_fEllisOverSpeed[iSubject]), true);
		}
	}
	
	// Update Nicks Desperate Measures Stacks
	if (SetAllNicksDesprateMeasuresStacks())
		SetAllNicksDesprateMeasureSpeed("A teammate has been brought back, your senses return to a weaker state.");
	
	SetClientSpeed(iSubject);
	return Plugin_Continue;
}

Action:Event_UpgradePackUsed(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient  = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	
	GiveClientXP(iClient, 25, g_iSprite_25XP, iClient, "Deployed iAmmo pack.");
	return Plugin_Continue;
}


Action:Event_PillsUsed(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	
	if(RunClientChecks(iClient) == false)
		return Plugin_Continue;

	// Ellis
	if (g_iJamminLevel[iClient] > 0)
	{
		if(g_iEllisJamminAdrenalineCounter[iClient] > 0)
		{
			g_iEllisJamminAdrenalineCounter[iClient]--;
			RunCheatCommand(iClient, "give", "give adrenaline");
		}
	}
	EventsPillsUsed_Ellis(iClient);

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

	EventsPillsUsed_Louis(iClient);
		
	return Plugin_Continue;
}

Action:Event_AdrenalineUsed(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	
	if(RunClientChecks(iClient) == false)
		return Plugin_Continue;

	// Ellis
	if (g_iOverLevel[iClient] > 0 && IsFakeClient(iClient) == false)
	{
		// Give health to Ellis
		new iMaxHealth = GetEntProp(iClient, Prop_Data, "m_iMaxHealth");
		new iHealth = GetEntProp(iClient, Prop_Data, "m_iHealth");
		new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);
		
		if(float(iHealth) + fTempHealth + (float(g_iOverLevel[iClient]) * 5.0) <= float(iMaxHealth))
			fTempHealth = fTempHealth + (float(g_iOverLevel[iClient]) * 5.0);
		else
			fTempHealth = float(iMaxHealth) - float(iHealth);
		
		SetEntDataFloat(iClient,g_iOffset_HealthBuffer, fTempHealth ,true);

		// Set the variable that will allow for damage buffs during adrenaline duration
		g_bEllisHasAdrenalineBuffs[iClient] = true;
		CreateTimer(float(g_iEllisAdrenalineStackDuration), TimerRemoveEllisAdrenalineBuffs, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
	EventsAdrenalineUsed_Ellis(iClient);


	// Nick
	if(g_iEnhancedLevel[iClient] > 0 && IsFakeClient(iClient) == false)
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

	EventsAdrenalineUsed_Louis(iClient);

	return Plugin_Continue;
}

//For Pills and Shots
Action:Event_WeaponGiven(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToChatAll("Event_WeaponGiven");
	
	new iGiver  = GetClientOfUserId(GetEventInt(hEvent,"giver"));
	// new iTaker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	// new iWeapon  = GetEventInt(hEvent,"weapon");	
	
	// Removed because of hand back and forth between two players
	// GiveClientXP(iGiver, 25, g_iSprite_25XP, iTaker, "Health Boost given to player.");

	EventsWeaponGiven_Ellis(iGiver);
	EventsWeaponGiven_Louis(iGiver);
	
	return Plugin_Continue;
}

// This was function was removed to prevent glitches
// TODO: Re-add this later
Action:Event_ReceiveUpgrade(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	// new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	// decl String:strUpgrade[32];
	// GetEventString(hEvent, "upgrade", strUpgrade, sizeof(strUpgrade));
	// //PrintToChatAll("g_strCurrentAmmoUpgrade = %s", g_strCurrentAmmoUpgrade);
	// //g_strCurrentAmmoUpgrade = UpgradeString;
	// //PrintToChat(iClient, "Picked up UPGRADE %s", UpgradeString);
	// //PrintToChatAll("Received an upgrade");
	// if((StrEqual(strUpgrade, "EXPLOSIVE_AMMO", false) == true) || (StrEqual(strUpgrade, "INCENDIARY_AMMO", false) == true))
	// {
	// 	g_strCurrentAmmoUpgrade = strUpgrade;
	// }
	// g_strCheckAmmoUpgrade = strUpgrade;
	// // //StoreCurrentPrimaryWeapon(iClient);
	// // //StoreCurrentPrimaryWeaponAmmo(iClient);
	// // fnc_DetermineMaxClipSize(iClient);
	// // //fnc_SetAmmoUpgrade(iClient);

	// // This was removed to prevent glitches
	// // TODO: Re-add this later
	// // This SetAmmo is the issue.  After someone has gotten rambo, it gives 250 exposive ammo for grenadeluancher
	// // Also, before, it sets everyone to be 0 ammo, that didnt meet the criteria
	// fnc_DetermineMaxClipSize(iClient);
	// fnc_SetAmmoUpgradeToMaxClipSize(iClient);
}
