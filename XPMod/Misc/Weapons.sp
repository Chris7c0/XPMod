// Find Weapon Item Index
int FindWeaponItemIndex(const char [] strWeaponClass, const String:strCompareIndex[][])
{
	for(int iItemIndex=0; iItemIndex <= ITEM_COUNT; iItemIndex++)
		if (StrEqual(strWeaponClass, strCompareIndex[iItemIndex], false) == true)
			return iItemIndex;

	return ITEM_EMPTY;
}

public bool IsWeaponIndexPrimarySlotItem(int iWeaponIndex)
{
	if (iWeaponIndex < ITEM_RANGE_MIN_SLOT_PRIMARY ||
		iWeaponIndex > ITEM_RANGE_MAX_SLOT_PRIMARY)
		return false
	
	return true;
}

public bool IsWeaponIndexSecondarySlotItem(int iWeaponIndex)
{
	if (iWeaponIndex < ITEM_RANGE_MIN_SLOT_SECONDARY||
		iWeaponIndex > ITEM_RANGE_MAX_SLOT_SECONDARY)
		return false
	
	return true;
}

public bool IsWeaponIndexExplosiveSlotItem(int iWeaponIndex)
{
	if (iWeaponIndex < ITEM_RANGE_MIN_SLOT_EXPLOSIVE ||
		iWeaponIndex > ITEM_RANGE_MAX_SLOT_EXPLOSIVE)
		return false
	
	return true;
}

public bool IsWeaponIndexHealthSlotItem(int iWeaponIndex)
{
	if (iWeaponIndex < ITEM_RANGE_MIN_SLOT_HEALTH ||
		iWeaponIndex > ITEM_RANGE_MAX_SLOT_HEALTH)
		return false
	
	return true;
}

public bool IsWeaponIndexBoostSlotItem(int iWeaponIndex)
{
	if (iWeaponIndex < ITEM_RANGE_MIN_SLOT_BOOST ||
		iWeaponIndex > ITEM_RANGE_MAX_SLOT_BOOST)
		return false
	
	return true;
}


fnc_DeterminePrimaryWeapon(iClient)
{	
	new String:strCurrentWeapon[32];
	GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));

	// Get the weapon index and ensure its a primary weapon
	new iWeaponIndex = FindWeaponItemIndex(strCurrentWeapon, ITEM_CLASS_NAME);
	if (iWeaponIndex <= 0 || IsWeaponIndexPrimarySlotItem(iWeaponIndex) == false)
		return;

	g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
	// PrintToChatAll("g_iPrimarySlotID = %d", g_iPrimarySlotID[iClient]);

	if (g_iPrimarySlotID[iClient] > 0 && IsValidEntity(g_iPrimarySlotID[iClient]))
		g_iCurrentClipAmmo[iClient] = GetEntProp(g_iPrimarySlotID[iClient],Prop_Data,"m_iClip1");
	
	if(iWeaponIndex >= ITEM_RANGE_MIN_RIFLE && iWeaponIndex <= ITEM_RANGE_MAX_RIFLE)
		g_iAmmoOffset[iClient] = 12;
	else if(iWeaponIndex >= ITEM_RANGE_MIN_SMG && iWeaponIndex <= ITEM_RANGE_MAX_SMG)
		g_iAmmoOffset[iClient] = 20;
	else if(iWeaponIndex == ITEM_REMINGTON_870 || iWeaponIndex == ITEM_REMINGTON_870_CUSTOM)
		g_iAmmoOffset[iClient] = 28;
	else if(iWeaponIndex == ITEM_BENELLI_M1014 || iWeaponIndex == ITEM_FRANCHI_SPAS_12)
		g_iAmmoOffset[iClient] = 32;
	else if(iWeaponIndex == ITEM_RUGER_MINI_14)
		g_iAmmoOffset[iClient] = 36;
	else if(iWeaponIndex == ITEM_HK_MSG90 || iWeaponIndex == ITEM_SCOUT || iWeaponIndex == ITEM_AWP)
		g_iAmmoOffset[iClient] = 40;
	else if(iWeaponIndex == ITEM_GRENADE_LAUNCHER)
		g_iAmmoOffset[iClient] = 68;
	else
		g_iAmmoOffset[iClient] = 0;
	//PrintToChatAll("g_iAmmoOffset = %d", g_iAmmoOffset[iClient]);
	
	
	g_iOffset_Ammo[iClient] = FindDataMapInfo(iClient,"m_iAmmo");
	g_iReserveAmmo[iClient] = GetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient]);
	//PrintToChatAll("g_iReserveAmmo = %d", g_iReserveAmmo[iClient]);

	//PrintToChatAll("iWeaponIndex = %s", ITEM_NAME[iWeaponIndex]);
	// PrintToChatAll("DETERMINE strCurrentWeapon = %s", strCurrentWeapon);
	// PrintToChatAll("DETERMINE PRIOR g_iEllisPrimarySlot0[iClient] = %s", ITEM_CLASS_NAME[g_iEllisPrimarySlot0[iClient]]);
	// PrintToChatAll("DETERMINE PRIOR g_iEllisPrimarySlot1[iClient] = %s", ITEM_CLASS_NAME[g_iEllisPrimarySlot1[iClient]]);

	// Store the weapon names for Ellis
	if (g_iEllisCurrentPrimarySlot[iClient] == 0)
		g_iEllisPrimarySlot0[iClient] = iWeaponIndex;
	else if (g_iEllisCurrentPrimarySlot[iClient] == 1)
		g_iEllisPrimarySlot1[iClient] = iWeaponIndex;
	
	// Store for Nick
	g_iStashedPrimarySlotWeaponIndex[iClient] = iWeaponIndex;

	// PrintToChatAll("DETERMINE AFTER g_iEllisPrimarySlot0[iClient] = %s", ITEM_CLASS_NAME[g_iEllisPrimarySlot0[iClient]]);
	// PrintToChatAll("DETERMINE AFTER g_iEllisPrimarySlot1[iClient] = %s", ITEM_CLASS_NAME[g_iEllisPrimarySlot1[iClient]]);
}
 
fnc_SaveAmmo(iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			new String:strCurrentWeapon[32];
			GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
			if((StrEqual(strCurrentWeapon, "weapon_melee", false) == false) && (StrEqual(strCurrentWeapon, "weapon_pistol", false) == false) && (StrEqual(strCurrentWeapon, "weapon_pistol_magnum", false) == false))
			{
				if(g_iEllisCurrentPrimarySlot[iClient] == 0)
				{
					g_iEllisPrimarySavedClipSlot1[iClient] = g_iCurrentClipAmmo[iClient];
					g_iEllisPrimarySavedAmmoSlot1[iClient] = g_iReserveAmmo[iClient];
					//PrintToChatAll("Saving upgrade ammo to variable");

					if (IsValidEntity(g_iPrimarySlotID[iClient]) && IsValidEdict(g_iPrimarySlotID[iClient]))
					{
						//decl String:strClassname[99];
						//GetEdictClassname(g_iPrimarySlotID[iClient], strClassname, sizeof(strClassname));
						//PrintToChatAll("g_iPrimarySlotID[%N]: %s", iClient, strClassname);
						if (HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
							g_iEllisUpgradeAmmoSlot1[iClient] = GetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
						//PrintToChatAll("g_iEllisUpgradeAmmoSlot1[%N]: %i", iClient, g_iEllisUpgradeAmmoSlot1[iClient]);
					}
					
					//PrintToChatAll("Amount to save is %d", g_iEllisUpgradeAmmoSlot1[iClient]);
					if(g_iEllisUpgradeAmmoSlot1[iClient] == 0)
					{
						//PrintToChatAll("Upgrade slot is equal to 0, setting strings to empty");
						g_strEllisUpgradeTypeSlot1 = "empty";
						g_strCurrentAmmoUpgrade = "empty";
					}
					else
					{
						//PrintToChatAll("Upgrade slot is great than 0, setting Type Slot to g_strCurrentAmmoUpgrade");
						g_strEllisUpgradeTypeSlot1 = g_strCurrentAmmoUpgrade;
						//PrintToChatAll("g_strEllisUpgradeTypeSlot1 = %s", g_strEllisUpgradeTypeSlot1);
					}
					//PrintToChatAll("g_iEllisPrimarySavedClipSlot1 = %d", g_iEllisPrimarySavedClipSlot1[iClient]);
					//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot1 = %d", g_iEllisPrimarySavedAmmoSlot1[iClient]);
					//PrintToChatAll("fnc_SaveAmmo: Slot = %i, Clip1 = %i, Ammo1 = %i, Upgrade1 = %s", g_iEllisCurrentPrimarySlot[iClient], g_iEllisPrimarySavedClipSlot1[iClient], g_iEllisPrimarySavedAmmoSlot1[iClient], g_strEllisUpgradeTypeSlot1);
				}
				else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
				{
					g_iEllisPrimarySavedClipSlot2[iClient] = g_iCurrentClipAmmo[iClient];
					g_iEllisPrimarySavedAmmoSlot2[iClient] = g_iReserveAmmo[iClient];
					//PrintToChatAll("Saving upgrade ammo to variable");
					if (IsValidEntity(g_iPrimarySlotID[iClient]) && HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
						g_iEllisUpgradeAmmoSlot2[iClient] = GetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
					//PrintToChatAll("Amount to save is %d", g_iEllisUpgradeAmmoSlot2[iClient]);
					if(g_iEllisUpgradeAmmoSlot2[iClient] == 0)
					{
						//PrintToChatAll("Upgrade slot is equal to 0, setting strings to empty");
						g_strEllisUpgradeTypeSlot2 = "empty";
						g_strCurrentAmmoUpgrade = "empty";
					}
					else
					{
						//PrintToChatAll("Upgrade slot is great than 0, setting Type Slot to g_strCurrentAmmoUpgrade");
						g_strEllisUpgradeTypeSlot2 = g_strCurrentAmmoUpgrade;
						//PrintToChatAll("g_strEllisUpgradeTypeSlot2 = %s", g_strEllisUpgradeTypeSlot2);
					}
					//PrintToChatAll("g_iEllisPrimarySavedClipSlot2 = %d", g_iEllisPrimarySavedClipSlot2[iClient]);
					//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot2 = %d", g_iEllisPrimarySavedAmmoSlot2[iClient]);
					//PrintToChatAll("fnc_SaveAmmo: Slot = %i, Clip2 = %i, Ammo2 = %i, Upgrade2 = %s", g_iEllisCurrentPrimarySlot[iClient], g_iEllisPrimarySavedClipSlot2[iClient], g_iEllisPrimarySavedAmmoSlot2[iClient], g_strEllisUpgradeTypeSlot2);
				}
				//PrintToChatAll("g_iCurrentClipAmmo = %d", g_iCurrentClipAmmo[iClient]);
				//PrintToChatAll("g_iReserveAmmo = %d", g_iReserveAmmo[iClient]);
			}
		}
		case 4:		//Nick
		{
			//PrintToChatAll("Saved g_iStashedPrimarySlotWeaponIndex[iClient] = %s", ITEM_NAME[g_iStashedPrimarySlotWeaponIndex[iClient]]);
			g_iNickPrimarySavedClip[iClient] = g_iCurrentClipAmmo[iClient];
			//PrintToChatAll("Saved g_iNickPrimarySavedClip = %d", g_iNickPrimarySavedClip[iClient]);
			g_iNickPrimarySavedAmmo[iClient] = g_iReserveAmmo[iClient];
			//PrintToChatAll("Saved g_iNickPrimarySavedAmmo = %d", g_iNickPrimarySavedAmmo[iClient]);
			//PrintToChatAll("Saving upgrade ammo to variable");
			if (IsValidEntity(g_iPrimarySlotID[iClient]) && HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded")) 
				g_iNickUpgradeAmmo[iClient] = GetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
			//PrintToChatAll("Amount to save is %d", g_iNickUpgradeAmmo[iClient]);
			if(g_iNickUpgradeAmmo[iClient] == 0)
			{
				//PrintToChatAll("Upgrade slot is equal to 0, setting strings to empty");
				g_strNickUpgradeType = "empty";
				g_strCurrentAmmoUpgrade = "empty";
			}
			else
			{
				//PrintToChatAll("Upgrade slot is great than 0, setting Type Slot to g_strCurrentAmmoUpgrade");
				g_strNickUpgradeType = g_strCurrentAmmoUpgrade;
				//PrintToChatAll("g_strNickUpgradeType = %s", g_strNickUpgradeType);
			}
		}
	}
}

CyclePlayerWeapon(iClient)
{
	//new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
	switch(g_iChosenSurvivor[iClient])
	{
		// case BILL:
		// case ROCHELLE:
		// case COACH:
		case ELLIS:	CyclePlayerWeapon_Ellis(iClient);
		case NICK:		//Nick
		{
			if (g_iPrimarySlotID[iClient] > 0 && IsValidEdict(g_iPrimarySlotID[iClient]))
				AcceptEntityInput(g_iPrimarySlotID[iClient], "Kill");
			
			if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
			{
				//PrintToChatAll("Removed current weapon via CyclePlayerWeapon");
				decl String:strCommandWithArgs[64];
				Format(strCommandWithArgs, sizeof(strCommandWithArgs), "give %s", ITEM_CMD_NAME[g_iStashedPrimarySlotWeaponIndex[iClient]]);
				RunCheatCommand(iClient, "give", strCommandWithArgs);
				PrintToChatAll("Gave %s via CyclePlayerWeapon", ITEM_CMD_NAME[g_iStashedPrimarySlotWeaponIndex[iClient]]);
				//SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iNickPrimarySavedClip[iClient], true);
				//SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iNickPrimarySavedAmmo[iClient]);
				
				// PrintToChatAll("Gave Weapon, now setting ammo/clip");
				// SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
				// PrintToChatAll("Clip has been set");
				// SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iEllisPrimarySavedAmmoSlot2[iClient]);
				// PrintToChatAll("Ammo has been set");
				// PrintToChatAll("Cycling to next weapon using function...");
			}
		}
		// case LOUIS:
	}
}

fnc_SetAmmo(iClient)
{
	if(RunClientChecks(iClient) ==  false || IsValidEntity(g_iPrimarySlotID[iClient]) == false)
		return;
	
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			if(g_iEllisCurrentPrimarySlot[iClient] == 0)
			{
				SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
				SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iEllisPrimarySavedAmmoSlot1[iClient]);
			}
			else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
			{
				SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
				SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iEllisPrimarySavedAmmoSlot2[iClient]);
			}
			//PrintToChatAll("Setting weapon ammo using functions...");
		}
		case 4:		//Nick
		{
			//PrintToChatAll("Set ammo via fnc_SetAmmo. Clip = %d, Ammo = %d", g_iNickPrimarySavedClip[iClient], g_iNickPrimarySavedAmmo[iClient]);
			SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iNickPrimarySavedClip[iClient], true);
			SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iNickPrimarySavedAmmo[iClient]);
		}
	}
}

fnc_DetermineMaxClipSize(iClient)
{
	new String:strCurrentWeapon[32];
	GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
			if(StrEqual(strCurrentWeapon, "weapon_rifle", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iPromotionalLevel[iClient] * 20));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_rifle_ak47", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (40 + (g_iPromotionalLevel[iClient] * 20));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_rifle_sg552", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iPromotionalLevel[iClient] * 20));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_rifle_desert", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (60 + (g_iPromotionalLevel[iClient] * 20));
			}
		}
		case 1:		//Rochelle
		{
			if(StrEqual(strCurrentWeapon, "weapon_hunting_rifle", false) == true)
			{
				if(g_iSilentLevel[iClient] > 0)
				{
					g_iCurrentMaxClipSize[iClient] = (17 - (g_iSilentLevel[iClient] * 2));
				}
				else
				{
					g_iCurrentMaxClipSize[iClient] = 15;
				}
			}
			else if(StrEqual(strCurrentWeapon, "weapon_sniper_awp", false) == true)
			{
				if(g_iSilentLevel[iClient] > 0)
				{
					g_iCurrentMaxClipSize[iClient] = 3;
				}
				else
				{
					g_iCurrentMaxClipSize[iClient] = 20;
				}
			}
			else if(StrEqual(strCurrentWeapon, "weapon_sniper_scout", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (20 - g_iSilentLevel[iClient]);
			}
			else if(StrEqual(strCurrentWeapon, "weapon_sniper_military", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (30 + (g_iSilentLevel[iClient] * 6));
			}
		}
		case 2:		//Coach
		{
			if((StrEqual(strCurrentWeapon, "weapon_pumpshotgun", false) == true) || (StrEqual(strCurrentWeapon, "weapon_shotgun_chrome", false) == true))
			{
				g_iCurrentMaxClipSize[iClient] = (8 + (g_iSprayLevel[iClient] * 2));
			}
			else if((StrEqual(strCurrentWeapon, "weapon_autoshotgun", false) == true) || (StrEqual(strCurrentWeapon, "weapon_shotgun_spas", false) == true))
			{
				g_iCurrentMaxClipSize[iClient] = (10 + (g_iSprayLevel[iClient] * 2));
			}
		}
		case 3:		//Ellis
		{
			if(StrEqual(strCurrentWeapon, "weapon_rifle", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_rifle_ak47", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (40 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_rifle_sg552", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_rifle_desert", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (60 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_smg", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_smg_mp5", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_smg_silenced", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_hunting_rifle", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (15 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_sniper_military", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (30 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_sniper_awp", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (20 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(strCurrentWeapon, "weapon_sniper_scout", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (20 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
		}
		case 4:		//Nick
		{
			if((g_bRamboModeActive[iClient] == true) && (StrEqual(strCurrentWeapon, "weapon_rifle_m60", false) == true))
			{
				g_iCurrentMaxClipSize[iClient] = 250;
			}
			else if((g_bRamboModeActive[iClient] == false) && (StrEqual(strCurrentWeapon, "weapon_rifle_m60", false) == true))
			{
				g_iCurrentMaxClipSize[iClient] = 150;
			}
		}
	}
}

fnc_SetAmmoUpgrade(iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			//PrintToChatAll("SWITCH REACHED");
			/*
			if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
			{

				RunCheatCommand(iClient, "upgrade_add", "upgrade_add EXPLOSIVE_AMMO");

			}
			*/
			if((g_iEllisCurrentPrimarySlot[iClient] == 0) && (g_iEllisUpgradeAmmoSlot1[iClient] > 0))
			{
				if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
				{
					decl String:strCommandWithArgs[64];
					Format(strCommandWithArgs, sizeof(strCommandWithArgs), "upgrade_add %s", g_strEllisUpgradeTypeSlot1);
					RunCheatCommand(iClient, "upgrade_add", strCommandWithArgs);
					//PrintToChatAll("Setting upgrade clip size based on saved ammo slot");
				}
				if (IsValidEntity(g_iPrimarySlotID[iClient]) && HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
				{
					SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iEllisUpgradeAmmoSlot1[iClient]);
					SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisUpgradeAmmoSlot1[iClient], true);
				}
				


				//g_iEllisUpgradeAmmoSlot1[iClient] = 0;
			}
			else if((g_iEllisCurrentPrimarySlot[iClient] == 1) && (g_iEllisUpgradeAmmoSlot2[iClient] > 0))
			{
				if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
				{
					//PrintToChatAll("Setting Cheat Flags");

					decl String:strCommandWithArgs[64];
					Format(strCommandWithArgs, sizeof(strCommandWithArgs), "upgrade_add %s", g_strEllisUpgradeTypeSlot2);
					RunCheatCommand(iClient, "upgrade_add", strCommandWithArgs);
					//PrintToChatAll("Setting upgrade clip size based on saved ammo slot");
				}
				if (IsValidEntity(g_iPrimarySlotID[iClient]) && HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
				{
					SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iEllisUpgradeAmmoSlot2[iClient]);
					SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisUpgradeAmmoSlot2[iClient], true);
				}
				


				//g_iEllisUpgradeAmmoSlot2[iClient] = 0;
			}
		}
		case 4:		//Nick
		{
			if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
			{
				if(g_iNickUpgradeAmmo[iClient] > 0)
				{
					decl String:strCommandWithArgs[64];
					Format(strCommandWithArgs, sizeof(strCommandWithArgs), "upgrade_add %s", g_strNickUpgradeType);
					RunCheatCommand(iClient, "upgrade_add", strCommandWithArgs);

					//PrintToChatAll("Setting upgrade clip size based on saved ammo slot");
					if (IsValidEntity(g_iPrimarySlotID[iClient]) && HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
					{
						SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iNickUpgradeAmmo[iClient]);
						SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iNickUpgradeAmmo[iClient], true);
					}
				}
				if(g_bRamboModeActive[iClient] == true)
				{
					RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");
				}


			}
		}
	}
}

// This was function was removed to prevent glitches
// TODO: Re-add this later
// fnc_SetAmmoUpgradeToMaxClipSize(iClient)
// {
// 	/*
// 	if(g_iNicksRamboWeaponID[iClient] != 0)
// 		return Plugin_Continue;
// 	*/
// 	//PrintToChatAll("Setting Ammo Upgrade");
// 	g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
// 	if((StrEqual(g_strCheckAmmoUpgrade, "EXPLOSIVE_AMMO", false) == true) || (StrEqual(g_strCheckAmmoUpgrade, "INCENDIARY_AMMO", false) == true))
// 	{
// 		//PrintToChatAll("g_strCurrentAmmoUpgrade is acceptable, setting upgrade ammo based on max clip size");
// 		if (IsValidEntity(g_iPrimarySlotID[iClient]) && HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
// 		{
// 			SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iCurrentMaxClipSize[iClient]);
// 			SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iCurrentMaxClipSize[iClient], true);
// 			g_strCheckAmmoUpgrade = "empty";
// 		}
// 	}
	
// 	// switch(g_iChosenSurvivor[iClient])
// 	// {
// 	// 	case 0:		//Bill
// 	// 	{
		
// 	// 	}
// 	// 	case 1:		//Rochelle
// 	// 	{
		
// 	// 	}
// 	// 	case 2:		//Coach
// 	// 	{
		
// 	// 	}
// 	// 	case 3:		//Ellis
// 	// 	{
// 	// 		if(((StrEqual(g_strCheckAmmoUpgrade, "EXPLOSIVE_AMMO", false) == true) || (StrEqual(g_strCheckAmmoUpgrade, "INCENDIARY_AMMO", false) == true)) && (g_bEllisHasCycled[iClient] == false))
// 	// 		{
// 	// 			PrintToChatAll("g_strCurrentAmmoUpgrade is acceptable, setting upgrade ammo based on max clip size");
// 	// 			SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iCurrentMaxClipSize[iClient]);
// 	// 			SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iCurrentMaxClipSize[iClient], true);
// 	// 			g_strCheckAmmoUpgrade = "empty";
// 	// 		}
// 	// 		else if(g_bEllisHasCycled[iClient] == true)
// 	// 		{
// 	// 			g_bEllisHasCycled[iClient] = false;
// 	// 		}
// 	// 	}
// 	// 	case 4:		//Nick
// 	// 	{
			
// 	// 	}
// 	// }
	
// }

fnc_ClearSavedWeaponData(iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			if(g_iEllisCurrentPrimarySlot[iClient] == 1)
			{
				g_iEllisPrimarySavedClipSlot1[iClient] = 0;
				g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
				g_iEllisUpgradeAmmoSlot1[iClient] = 0;
				g_strEllisUpgradeTypeSlot1 = "empty";
				g_strCurrentAmmoUpgrade = "empty";
				g_iEllisPrimarySlot0[iClient] = ITEM_EMPTY;
				//PrintToChatAll("g_iEllisPrimarySlot0[iClient] is now %s", g_iEllisPrimarySlot0[iClient]);
			}
			else if(g_iEllisCurrentPrimarySlot[iClient] == 0)
			{
				g_iEllisPrimarySavedClipSlot2[iClient] = 0;
				g_iEllisPrimarySavedAmmoSlot2[iClient] = 0;
				g_iEllisUpgradeAmmoSlot2[iClient] = 0;
				g_strEllisUpgradeTypeSlot2 = "empty";
				g_strCurrentAmmoUpgrade = "empty";
				g_iEllisPrimarySlot1[iClient] = ITEM_EMPTY;
				//PrintToChatAll("g_iEllisPrimarySlot1[iClient] is now %s", g_iEllisPrimarySlot1[iClient]);
			}
		}
		case 4:		//Nick
		{
			g_iNickPrimarySavedClip[iClient] = 0;
			g_iNickPrimarySavedAmmo[iClient] = 0;
			g_iNickUpgradeAmmo[iClient] = 0;
			g_strNickUpgradeType = "empty";
			g_strCurrentAmmoUpgrade = "empty";
			g_iStashedPrimarySlotWeaponIndex[iClient] = ITEM_EMPTY;
		}
	}
}

fnc_ClearAllWeaponData(iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			g_iEllisPrimarySavedClipSlot1[iClient] = 0;
			g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
			g_iEllisUpgradeAmmoSlot1[iClient] = 0;
			g_strEllisUpgradeTypeSlot1 = "empty";
			g_strCurrentAmmoUpgrade = "empty";
			g_iEllisPrimarySlot0[iClient] = ITEM_EMPTY;
			//PrintToChatAll("g_iEllisPrimarySlot0[iClient] is now %s", g_iEllisPrimarySlot0[iClient]);
			g_iEllisPrimarySavedClipSlot2[iClient] = 0;
			g_iEllisPrimarySavedAmmoSlot2[iClient] = 0;
			g_iEllisUpgradeAmmoSlot2[iClient] = 0;
			g_strEllisUpgradeTypeSlot2 = "empty";
			g_strCurrentAmmoUpgrade = "empty";
			g_iEllisPrimarySlot1[iClient] = ITEM_EMPTY;
			//PrintToChatAll("g_iEllisPrimarySlot1[iClient] is now %s", g_iEllisPrimarySlot1[iClient]);
		}
		case 4:		//Nick
		{
			g_strNickSecondarySlot1 = "empty";
			g_strNickSecondarySlot2 = "empty";
			g_iNickCurrentSecondarySlot[iClient] = 0;
		}
	}
}


MolotovExplode(Float:xyzLocation[3])
{
	xyzLocation[2] += 5.0;
	
	new iEntity = CreateEntityByName("prop_physics");
	if(IsValidEntity(iEntity) == false)
		return;
	
	DispatchKeyValue(iEntity, "model", "models/props_junk/gascan001a.mdl");
	DispatchSpawn(iEntity);
	
	SetEntData(iEntity, GetEntSendPropOffs(iEntity, "m_CollisionGroup"), 1, 1, true);
	TeleportEntity(iEntity, xyzLocation, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(iEntity, "Break");
}

PropaneExplode(Float:xyzLocation[3])
{
	xyzLocation[2] += 5.0;
	
	new iEntity = CreateEntityByName("prop_physics");
	if(IsValidEntity(iEntity) == false)
		return;
	
	DispatchKeyValue(iEntity, "model", "models/props_junk/propanecanister001a.mdl");
	DispatchSpawn(iEntity);
	
	SetEntData(iEntity, GetEntSendPropOffs(iEntity, "m_CollisionGroup"), 1, 1, true);
	TeleportEntity(iEntity, xyzLocation, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(iEntity, "Break");
}
