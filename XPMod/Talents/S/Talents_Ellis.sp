OnGameFrame_Ellis(iClient)
{
	if(g_iMetalLevel[iClient] == 5)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		
		if(!(buttons & IN_SPEED) || !(buttons & IN_USE))
			g_bWalkAndUseToggler[iClient] = false;
			
		if((g_bWalkAndUseToggler[iClient] == false) && ((buttons & IN_SPEED) && (buttons & IN_USE)))
		{
			g_bWalkAndUseToggler[iClient] = true;
			if((g_bIsEllisLimitBreaking[iClient] == false) && (g_bCanEllisLimitBreak[iClient] == true))
			{
				g_bIsEllisLimitBreaking[iClient] = true;
				g_bCanEllisLimitBreak[iClient] = false;
				CreateTimer(10.0, TimerEllisLimitBreakReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(70.0, TimerEllisLimitBreakCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
				PrintHintText(iClient, "Tripling firing speed for 10 seconds; Your weapon will break afterward!");
				//PrintToChatAll("Ellis is limit breaking");
			}
			else if(g_bEllisLimitBreakInCooldown[iClient] == true)
			{
				PrintHintText(iClient, "LIMIT BREAK is still cooling down");
			}
		}
	}
	if(g_iWeaponsLevel[iClient] == 5)
	{
		if(g_bCanEllisPrimaryCycle[iClient] == true)
		{
			new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
			
			if((buttons & IN_SPEED) && (buttons & IN_ZOOM))
			{
				decl String:currentweapon[512];
				GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
				//PrintToChatAll("Current Weapon is %s", currentweapon);
				if((StrContains(currentweapon,"shotgun",false) != -1) || (StrContains(currentweapon,"rifle",false) != -1) || (StrContains(currentweapon,"smg",false) != -1) || (StrContains(currentweapon,"sniper",false) != -1) || (StrContains(currentweapon,"launcher",false) != -1))
				{
					if((StrEqual(g_strEllisPrimarySlot1, "empty", false) == false) && (StrEqual(g_strEllisPrimarySlot2, "empty", false) == false))
					{
						//PrintToChatAll("String contains a gun");
						g_bCanEllisPrimaryCycle[iClient] = false;
						g_bIsEllisInPrimaryCycle[iClient] = true;
						CreateTimer(0.5, TimerEllisPrimaryCycleReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
						//new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
						//PrintToChatAll("%s g_strEllisPrimarySlot2", g_strEllisPrimarySlot2[iClient]);
						//PrintToChatAll("%s g_strEllisPrimarySlot1", g_strEllisPrimarySlot1[iClient]);
						//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
						//new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
						//PrintToChatAll("CurrentClipAmmo %d", CurrentClipAmmo);
						fnc_DeterminePrimaryWeapon(iClient);
						fnc_SaveAmmo(iClient);
						fnc_CycleWeapon(iClient);
						
						// if(g_iLaserUpgradeCounter[iClient] > 0)
						// {
						// 	g_iLaserUpgradeCounter[iClient]--;
						// }
						// if(g_iEllisCurrentPrimarySlot[iClient] == 0)
						// {
						// 	if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
						// 		g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						// 	}
						// 	else if((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
						// 		g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						// 	}
						// 	else if((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true))
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
						// 		g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						// 	}
						// 	else if((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true))
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
						// 		g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						// 	}
						// 	else if(StrEqual(currentweapon, "weapon_hunting_rifle", false) == true)
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
						// 		g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						// 	}
						// 	else if((StrEqual(currentweapon, "weapon_sniper_military", false) == true) || (StrEqual(currentweapon, "weapon_sniper_awp", false) == true) || (StrEqual(currentweapon, "weapon_sniper_scout", false) == true))
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
						// 		g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						// 	}
						// 	else if(StrEqual(currentweapon, "weapon_grenade_launcher", false) == true)
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
						// 		g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						// 	}
						// 	else if(StrEqual(currentweapon, "weapon_rifle_m60", false) == true)
						// 	{
						// 		//new iAmmo = GetEntData(iClient, iOffset_Ammo);
						// 		g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
						// 	}
							
						// 	PrintToChatAll("g_iEllisPrimarySavedClipSlot1 %d", g_iEllisPrimarySavedClipSlot1[iClient]);
						// 	PrintToChatAll("g_iEllisPrimarySavedAmmoSlot1 %d", g_iEllisPrimarySavedAmmoSlot1[iClient]);
							
						// 	if(StrEqual(g_strEllisPrimarySlot2, "weapon_autoshotgun", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give autoshotgun");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_grenade_launcher", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give grenade_launcher");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 68, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_hunting_rifle", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give hunting_rifle");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 36, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_pumpshotgun", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give pumpshotgun");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give rifle");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_ak47", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give rifle_ak47");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_desert", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give rifle_desert");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_m60", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give rifle_m60");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		//SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_sg552", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give rifle_sg552");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_shotgun_chrome", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give shotgun_chrome");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_shotgun_spas", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give shotgun_spas");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_smg", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give smg");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_smg_mp5", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give smg_mp5");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_smg_silenced", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give smg_silenced");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_sniper_awp", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give sniper_awp");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_sniper_military", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give sniper_military");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot2, "weapon_sniper_scout", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 1;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give sniper_scout");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						// 	}
						// 	else if(StrContains(g_strEllisPrimarySlot2[iClient], "empty", false) != -1)
						// 	{
						// 		PrintToChatAll("The next primary slot is empty");
						// 	}
						// }
						// else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
						// {
						// 	g_strEllisPrimarySlot2 = currentweapon;
						// 	PrintToChatAll("Current Weapon is %s", currentweapon);
						// 	PrintToChatAll("Second Check %s", g_strEllisPrimarySlot2[iClient]);
							
						// 	if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
						// 		g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						// 	}
						// 	else if((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true))
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
						// 		g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						// 	}
						// 	else if((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true))
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
						// 		g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						// 	}
						// 	else if((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true))
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
						// 		g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						// 	}
						// 	else if(StrEqual(currentweapon, "weapon_hunting_rifle", false) == true)
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
						// 		g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						// 	}
						// 	else if((StrEqual(currentweapon, "weapon_sniper_military", false) == true) || (StrEqual(currentweapon, "weapon_sniper_awp", false) == true) || (StrEqual(currentweapon, "weapon_sniper_scout", false) == true))
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
						// 		g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						// 	}
						// 	else if(StrEqual(currentweapon, "weapon_grenade_launcher", false) == true)
						// 	{
						// 		new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
						// 		g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						// 	}
						// 	else if(StrEqual(currentweapon, "weapon_rifle_m60", false) == true)
						// 	{
						// 		//new iAmmo = GetEntData(iClient, iOffset_Ammo);
						// 		g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						// 		g_iEllisPrimarySavedAmmoSlot2[iClient] = 0;
						// 	}
							
						// 	PrintToChatAll("g_iEllisPrimarySavedClipSlot2 %d", g_iEllisPrimarySavedClipSlot2[iClient]);
						// 	PrintToChatAll("g_iEllisPrimarySavedAmmoSlot2 %d", g_iEllisPrimarySavedAmmoSlot2[iClient]);
							
						// 	if(StrEqual(g_strEllisPrimarySlot1, "weapon_autoshotgun", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give autoshotgun");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_grenade_launcher", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give grenade_launcher");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 68, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_hunting_rifle", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give hunting_rifle");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 36, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_pumpshotgun", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give pumpshotgun");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_rifle", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give rifle");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_rifle_ak47", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give rifle_ak47");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_rifle_desert", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give rifle_desert");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_rifle_m60", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give rifle_m60");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		//SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_rifle_sg552", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give rifle_sg552");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_shotgun_chrome", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give shotgun_chrome");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_shotgun_spas", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give shotgun_spas");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_smg", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give smg");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_smg_mp5", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give smg_mp5");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_smg_silenced", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give smg_silenced");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_sniper_awp", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give sniper_awp");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_sniper_military", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give sniper_military");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrEqual(g_strEllisPrimarySlot1, "weapon_sniper_scout", false) == true)
						// 	{
						// 		RemoveEdict(ActiveWeaponID);
						// 		g_iEllisCurrentPrimarySlot[iClient] = 0;
						// 		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
						// 		FakeClientCommand(iClient, "give sniper_scout");
						// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
						// 		SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						// 	}
						// 	else if(StrContains(g_strEllisPrimarySlot1[iClient], "empty", false) != -1)
						// 	{
						// 		PrintToChatAll("The next primary slot is empty");
						// 	}
							
						// }
						
					}
					else
					{
						//PrintToChatAll("The next primary slot is empty");
					}
				}
			}
		}
	}
	if((g_iMetalLevel[iClient] > 0) || (g_iFireLevel[iClient] > 0))
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if((buttons & IN_RELOAD) && g_bClientIsReloading[iClient] == false && g_bForceReload[iClient] == false)
		{
			decl String:currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (IsValidEntity(ActiveWeaponID) == false)
				return;
			new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
				if(iAmmo > 0)
				{
					g_bForceReload[iClient] = true;
					g_iSavedClip[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
					SetEntData(iClient, iOffset_Ammo + 12, iAmmo + g_iSavedClip[iClient]);
				}
			}
			if(((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true)) && (CurrentClipAmmo == 50))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
				if(iAmmo > 0)
				{
					g_bForceReload[iClient] = true;
					g_iSavedClip[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
					SetEntData(iClient, iOffset_Ammo + 20, iAmmo + g_iSavedClip[iClient]);
				}
			}
			if((StrEqual(currentweapon, "weapon_hunting_rifle", false) == true) && (CurrentClipAmmo == 15))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
				if(iAmmo > 0)
				{
					g_bForceReload[iClient] = true;
					g_iSavedClip[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
					SetEntData(iClient, iOffset_Ammo + 36, iAmmo + g_iSavedClip[iClient]);
				}
			}
			if(((StrEqual(currentweapon, "weapon_sniper_awp", false) == true) && (CurrentClipAmmo == 20)) || ((StrEqual(currentweapon, "weapon_sniper_military", false) == true) && (CurrentClipAmmo == 30)) || ((StrEqual(currentweapon, "weapon_sniper_scout", false) == true) && (CurrentClipAmmo == 15)))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
				if(iAmmo > 0)
				{
					g_bForceReload[iClient] = true;
					g_iSavedClip[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
					SetEntData(iClient, iOffset_Ammo + 40, iAmmo + g_iSavedClip[iClient]);
				}
			}
		}
	}
}

OGFSurvivorReload_Ellis(iClient, const char[] currentweapon, ActiveWeaponID, CurrentClipAmmo, iOffset_Ammo)
{
	if((StrEqual(g_strEllisPrimarySlot1, "empty", false) == true) || (StrEqual(g_strEllisPrimarySlot2, "empty", false) == true))
	{
		fnc_DeterminePrimaryWeapon(iClient);
		if((StrContains(g_strCurrentWeapon, "rifle", false) != -1) || (StrContains(g_strCurrentWeapon, "smg", false) != -1) || (StrContains(g_strCurrentWeapon, "shotgun", false) != -1) || (StrContains(g_strCurrentWeapon, "launcher", false) != -1) || (StrContains(g_strCurrentWeapon, "sniper", false) != -1))
		{
			fnc_SaveAmmo(iClient);
		}
	}
	if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
		if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
			SetEntData(iClient, iOffset_Ammo + 12, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
		}
		else if(iAmmo < (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
		{
			new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo), true);
			SetEntData(iClient, iOffset_Ammo + 12, 0);
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
	else if(((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true)) && (CurrentClipAmmo == 50))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);	//for smg (+20)
		if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
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
	else if((StrEqual(currentweapon, "weapon_hunting_rifle", false) == true) && (CurrentClipAmmo == 15))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);	//for hunting rifle (+36)
		if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
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
	else if(((StrEqual(currentweapon, "weapon_sniper_awp", false) == true) && (CurrentClipAmmo == 20)) || ((StrEqual(currentweapon, "weapon_sniper_military", false) == true) && (CurrentClipAmmo == 30)) || ((StrEqual(currentweapon, "weapon_sniper_scout", false) == true) && (CurrentClipAmmo == 15)))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
		if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
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
	//Decided the following was not necessary. It was meant to save ammo during reloading in case a player changed weapons in the middle of a reload, but changing weapons already saves the weapons current data.
	/*
	if(g_iEllisCurrentPrimarySlot[iClient] == 0)
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
	else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
	{
		if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
		{
			new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
			g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
			g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
		}
		else if((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
		{
			new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
			g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
			g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
		}
		else if((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true))
		{
			new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
			g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
			g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
		}
		else if((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true))
		{
			new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
			g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
			g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
		}
		else if(StrEqual(currentweapon, "weapon_hunting_rifle", false) == true)
		{
			new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
			g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
			g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
		}
		else if((StrEqual(currentweapon, "weapon_sniper_military", false) == true) || (StrEqual(currentweapon, "weapon_sniper_awp", false) == true) || (StrEqual(currentweapon, "weapon_sniper_scout", false) == true))
		{
			new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
			g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
			g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
		}
		else if(StrEqual(currentweapon, "weapon_grenade_launcher", false) == true)
		{
			new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
			g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
			g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
		}
		else if(StrEqual(currentweapon, "weapon_rifle_m60", false) == true)
		{
			//new iAmmo = GetEntData(iClient, iOffset_Ammo);
			g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
			g_iEllisPrimarySavedAmmoSlot2[iClient] = 0;
		}
	}
	*/
}

EventsHurt_AttackerEllis(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(attacker))
		return;
	
	if (g_iClientTeam[victim] != TEAM_INFECTED)
		return;
	
	if(g_iFireLevel[attacker]>0)
	{
		if(g_iClientTeam[victim] == TEAM_INFECTED)
		{
			if(g_bUsingFireStorm[attacker]==true)
			{
				new Float:time = (float(g_iFireLevel[attacker]) * 6.0);
				IgniteEntity(victim, time, false);
			}
		}
	}
	
	if(g_iOverLevel[attacker] > 0)
	{
		if(g_iClientTeam[victim] == TEAM_INFECTED)
		{
			new iCurrentHealth = GetEntProp(attacker,Prop_Data,"m_iHealth");
			new iMaxHealth = GetEntProp(attacker,Prop_Data,"m_iMaxHealth");
			new Float:fTempHealth = GetEntDataFloat(attacker, g_iOffset_HealthBuffer);
			if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
			{
				decl String:weaponclass[32];
				GetEventString(hEvent,"weapon",weaponclass,32);
				//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
				if((StrContains(weaponclass,"shotgun",false) != -1) || (StrContains(weaponclass,"rifle",false) != -1) || (StrContains(weaponclass,"pistol",false) != -1) || (StrContains(weaponclass,"smg",false) != -1) || (StrContains(weaponclass,"sniper",false) != -1) || (StrContains(weaponclass,"launcher",false) != -1))
				{
					new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
					new dmg = GetEventInt(hEvent,"dmg_health");
					new newdmg = (dmg + (g_iOverLevel[attacker] * 2));
					SetEntProp(victim,Prop_Data,"m_iHealth", hp - newdmg);
					//DeleteCode
					//PrintToChatAll("Ellis is doing %d damage", dmg);
					//PrintToChatAll("Ellis is doing %d additional damage", (newdmg - dmg));
				}
			}
		}
	}
}

EventsHurt_VictimEllis(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(victim))
		return;

	SuppressNeverUsedWarning(attacker);

	new dmgType = GetEventInt(hEvent, "type");
	new dmgHealth  = GetEventInt(hEvent,"dmg_health");

	if(g_iFireLevel[victim] > 0)
	{
		//Prevent Fire Damage
		if(dmgType == DAMAGETYPE_FIRE1 || dmgType == DAMAGETYPE_FIRE2)
		{
			//PrintToChat(victim, "Prevent fire damage");
			new currentHP = GetEventInt(hEvent,"health");
			SetEntProp(victim,Prop_Data,"m_iHealth", dmgHealth + currentHP);
		}
	}

	if(g_iOverLevel[victim] > 0)
	{
		new iCurrentHealth = GetEntProp(victim,Prop_Data,"m_iHealth");
		new iMaxHealth = GetEntProp(victim,Prop_Data,"m_iMaxHealth");
		//new Float:fTempHealth = GetEntDataFloat(victim, g_iOffset_HealthBuffer);
		//if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - 20.0))
		if(iCurrentHealth < (iMaxHealth - 20.0))
		{
			if(g_bEllisOverSpeedIncreased[victim])
			{
				g_bEllisOverSpeedIncreased[victim] = false;

				SetClientSpeed(victim);
			}
		}
		//else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
		else if(iCurrentHealth >= (iMaxHealth - 20.0))
		{
			if(g_bEllisOverSpeedIncreased[victim] == false)
			{
				g_bEllisOverSpeedIncreased[victim] = true;

				SetClientSpeed(victim);						
			}
		}
	}
}