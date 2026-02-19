// Find Weapon Item Index
int FindWeaponItemIndex(const char[] strWeaponClass, const char[][] strCompareIndex)
{
	for(int iItemIndex=0; iItemIndex <= ITEM_COUNT; iItemIndex++)
		if (StrEqual(strWeaponClass, strCompareIndex[iItemIndex], false) == true)
			return iItemIndex;

	return ITEM_EMPTY;
}

int FindWeaponItemIndexOfWeaponID(int iClient, int iActiveWeaponID = -1)
{
	if (iActiveWeaponID == -1)
		iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	
	if (RunEntityChecks(iActiveWeaponID) == false)
		return ITEM_EMPTY;

	char strEntityClassName[32];
	GetEntityClassname(iActiveWeaponID, strEntityClassName, 32);
	// PrintToChat(iClient, "strEntityClassName: %s", strEntityClassName);

	return FindWeaponItemIndex(strEntityClassName, ITEM_CLASS_NAME);
}

int GetWeaponIndexByFindingAndComparingViewModelString(int iClient, int iWeaponID = -1)
{
	if (iWeaponID == -1)
		iWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);

	if (RunEntityChecks(iWeaponID) == false)
		return ITEM_EMPTY;

	char strWeaponModelName[64];
	GetEntPropString(iWeaponID, Prop_Data, "m_ModelName", strWeaponModelName, sizeof(strWeaponModelName));
	// PrintToChat(iClient, "strWeaponModelName %s", strWeaponModelName);

	for(int iItemIndex=0; iItemIndex <= ITEM_COUNT; iItemIndex++)
		if (StrEqual(strWeaponModelName, ITEM_VIEW_MODEL_PATH[iItemIndex], false) == true)
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

public bool IsWeaponIndexMeleeWeapon(int iWeaponIndex)
{
	if (iWeaponIndex < ITEM_RANGE_MIN_MELEE ||
		iWeaponIndex > ITEM_RANGE_MAX_MELEE)
		return false
	
	return true;
}

int GetActiveWeaponSlot(const int iClient, int iActiveWeaponID = -1)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return -1;

	// If there was no weapon id provided, get it
	if (RunEntityChecks(iActiveWeaponID) == false)
	{
		iActiveWeaponID = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
	
		// No valid weapon id was found
		if (iActiveWeaponID == -1)
			return -1;
	} 

	// return the slot they are using
	for (int i=0; i < 5; i++)
		if (GetPlayerWeaponSlot(iClient, i) == iActiveWeaponID)
			return i;

	return -1;
}

void SetAmmoOffsetForPrimarySlotID(int iClient, int iWeaponIndex)
{
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
}

void StoreCurrentPrimaryWeapon(int iClient)
{
	// Check if in rambo mode and have the M60 out
	if (g_bRamboModeActive[iClient] && g_iRamboWeaponID[iClient] == GetPlayerWeaponSlot(iClient, 0))
		return;

	g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
	// PrintToChatAll("g_iPrimarySlotID = %d", g_iPrimarySlotID[iClient]);

	char strCurrentWeapon[32];
	GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));

	// Get the weapon index and ensure its a primary weapon
	int iWeaponIndex = FindWeaponItemIndex(strCurrentWeapon, ITEM_CLASS_NAME);
	if (iWeaponIndex <= 0 || IsWeaponIndexPrimarySlotItem(iWeaponIndex) == false)
		return;

	SetAmmoOffsetForPrimarySlotID(iClient, iWeaponIndex);

	// PrintToChatAll("iWeaponIndex = %s", ITEM_NAME[iWeaponIndex]);
	// PrintToChatAll("DETERMINE strCurrentWeapon = %s", strCurrentWeapon);
	// PrintToChatAll("DETERMINE PRIOR g_iEllisPrimarySlot0[iClient] = %s", ITEM_CLASS_NAME[g_iEllisPrimarySlot0[iClient]]);
	// PrintToChatAll("DETERMINE PRIOR g_iEllisPrimarySlot1[iClient] = %s", ITEM_CLASS_NAME[g_iEllisPrimarySlot1[iClient]]);

	// Store the weapon names for Ellis
	if (g_iEllisCurrentPrimarySlot[iClient] == 0)
		g_iEllisPrimarySlot0[iClient] = iWeaponIndex;
	else if (g_iEllisCurrentPrimarySlot[iClient] == 1)
		g_iEllisPrimarySlot1[iClient] = iWeaponIndex;
	
	// Store for Nick's Rambo gamble
	g_iStashedPrimarySlotWeaponIndex[iClient] = iWeaponIndex;

	// PrintToChatAll("DETERMINE AFTER g_iStashedPrimarySlotWeaponIndex[iClient] = %s", ITEM_CLASS_NAME[g_iStashedPrimarySlotWeaponIndex[iClient]]);
	
	// PrintToChatAll("DETERMINE AFTER g_iEllisPrimarySlot0[iClient] = %s", ITEM_CLASS_NAME[g_iEllisPrimarySlot0[iClient]]);
	// PrintToChatAll("DETERMINE AFTER g_iEllisPrimarySlot1[iClient] = %s", ITEM_CLASS_NAME[g_iEllisPrimarySlot1[iClient]]);
}
 
void StoreCurrentPrimaryWeaponAmmo(int iClient)
{
	// PrintToChat(iClient, "StoreCurrentPrimaryWeaponAmmo start");
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:		//Bill
		{
		
		}
		case ROCHELLE:		//Rochelle
		{
		
		}
		case COACH:		//Coach
		{
			
		}
		case ELLIS:		//Ellis
		{
			char strCurrentWeapon[32];
			GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
			if((StrEqual(strCurrentWeapon, "weapon_melee", false) == false) && (StrEqual(strCurrentWeapon, "weapon_pistol", false) == false) && (StrEqual(strCurrentWeapon, "weapon_pistol_magnum", false) == false))
			{
				// PrintToChatAll("Saving Ammo: g_iEllisCurrentPrimarySlot[iClient] = %i, g_iCurrentClipAmmo[iClient] = %i, g_iReserveAmmo[iClient] = %i", g_iEllisCurrentPrimarySlot[iClient], g_iCurrentClipAmmo[iClient], g_iReserveAmmo[iClient]);
				if(g_iEllisCurrentPrimarySlot[iClient] == 0)
				{
					g_iEllisPrimarySavedClipSlot0[iClient] = g_iCurrentClipAmmo[iClient];
					g_iEllisPrimarySavedAmmoSlot0[iClient] = g_iReserveAmmo[iClient];
					//PrintToChatAll("Saving upgrade ammo to variable");

					if (IsValidEntity(g_iPrimarySlotID[iClient]) && IsValidEdict(g_iPrimarySlotID[iClient]))
					{
						//char strClassname[99];
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
					//PrintToChatAll("g_iEllisPrimarySavedClipSlot0 = %d", g_iEllisPrimarySavedClipSlot0[iClient]);
					//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot0 = %d", g_iEllisPrimarySavedAmmoSlot0[iClient]);
					//PrintToChatAll("StoreCurrentPrimaryWeaponAmmo: Slot = %i, Clip1 = %i, Ammo1 = %i, Upgrade1 = %s", g_iEllisCurrentPrimarySlot[iClient], g_iEllisPrimarySavedClipSlot0[iClient], g_iEllisPrimarySavedAmmoSlot0[iClient], g_strEllisUpgradeTypeSlot1);
				}
				else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
				{
					g_iEllisPrimarySavedClipSlot1[iClient] = g_iCurrentClipAmmo[iClient];
					g_iEllisPrimarySavedAmmoSlot1[iClient] = g_iReserveAmmo[iClient];
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
					//PrintToChatAll("g_iEllisPrimarySavedClipSlot1 = %d", g_iEllisPrimarySavedClipSlot1[iClient]);
					//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot1 = %d", g_iEllisPrimarySavedAmmoSlot1[iClient]);
					//PrintToChatAll("StoreCurrentPrimaryWeaponAmmo: Slot = %i, Clip2 = %i, Ammo2 = %i, Upgrade2 = %s", g_iEllisCurrentPrimarySlot[iClient], g_iEllisPrimarySavedClipSlot1[iClient], g_iEllisPrimarySavedAmmoSlot1[iClient], g_strEllisUpgradeTypeSlot2);
				}
				//PrintToChatAll("g_iCurrentClipAmmo = %d", g_iCurrentClipAmmo[iClient]);
				//PrintToChatAll("g_iReserveAmmo = %d", g_iReserveAmmo[iClient]);
			}
		}
		case NICK:		//Nick
		{
			int iCurrentPrimaryID = GetPlayerWeaponSlot(iClient, 0);
			// PrintToChatAll("StoreCurrentPrimaryWeaponAmmo weapon %i", iCurrentPrimaryID);
			if (RunEntityChecks(iCurrentPrimaryID) == false)
			{
				g_iNickPrimarySavedClip[iClient] = 0;
				g_iNickPrimarySavedAmmo[iClient] = 0;
				g_strNickUpgradeType = "empty";
				g_strCurrentAmmoUpgrade = "empty";
				return;
			}

			// PrintToChatAll("StoreCurrentPrimaryWeaponAmmo past RunEntityChecks");

			// Don't store ammo of the rambo weapon
			if (iCurrentPrimaryID == g_iRamboWeaponID[iClient])
				return;

			// PrintToChatAll("StoreCurrentPrimaryWeaponAmmo past g_iRamboWeaponID check");

			//PrintToChatAll("Saved g_iStashedPrimarySlotWeaponIndex[iClient] = %s", ITEM_NAME[g_iStashedPrimarySlotWeaponIndex[iClient]]);
			g_iNickPrimarySavedClip[iClient] = GetEntProp(iCurrentPrimaryID,Prop_Data,"m_iClip1");
			// PrintToChatAll("Saved g_iNickPrimarySavedClip = %d", g_iNickPrimarySavedClip[iClient]);
			g_iOffset_Ammo[iClient] = FindDataMapInfo(iClient,"m_iAmmo");
			g_iReserveAmmo[iClient] = GetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient]);
			g_iNickPrimarySavedAmmo[iClient] = g_iReserveAmmo[iClient];
			// PrintToChatAll("Saved g_iNickPrimarySavedAmmo = %d", g_iNickPrimarySavedAmmo[iClient]);
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

void CyclePlayerWeapon(int iClient)
{
	//new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
	switch(g_iChosenSurvivor[iClient])
	{
		// case BILL:
		// case ROCHELLE:
		// case COACH:
		case ELLIS:		CyclePlayerWeapon_Ellis(iClient);
		case NICK:		CyclePlayerWeapon_Nick(iClient);
		// case LOUIS:
	}
}

void fnc_SetAmmo(int iClient)
{
	if(RunClientChecks(iClient) ==  false || RunEntityChecks(g_iPrimarySlotID[iClient]) == false)
		return;
	
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:		//Bill
		{
		
		}
		case ROCHELLE:		//Rochelle
		{
		
		}
		case COACH:		//Coach
		{
		
		}
		case ELLIS:		//Ellis
		{
			if(g_iEllisCurrentPrimarySlot[iClient] == 0)
			{
				SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot0[iClient], true);
				SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iEllisPrimarySavedAmmoSlot0[iClient]);
			}
			else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
			{
				SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
				SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iEllisPrimarySavedAmmoSlot1[iClient]);
			}
			//PrintToChatAll("Setting weapon ammo using functions...");
		}
		case NICK:		//Nick
		{
			// PrintToChatAll("Set ammo via fnc_SetAmmo. Clip = %d, Ammo = %d", g_iNickPrimarySavedClip[iClient], g_iNickPrimarySavedAmmo[iClient]);
			SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iNickPrimarySavedClip[iClient], true);
			SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iNickPrimarySavedAmmo[iClient]);
		}
	}
}

// fnc_DetermineMaxClipSize(iClient)
// {
// 	char strCurrentWeapon[32];
// 	GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
// 	switch(g_iChosenSurvivor[iClient])
// 	{
// 		case 0:		//Bill
// 		{
// 			if(StrEqual(strCurrentWeapon, "weapon_rifle", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (50 + (g_iPromotionalLevel[iClient] * 20));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_rifle_ak47", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (40 + (g_iPromotionalLevel[iClient] * 20));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_rifle_sg552", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (50 + (g_iPromotionalLevel[iClient] * 20));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_rifle_desert", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (60 + (g_iPromotionalLevel[iClient] * 20));
// 			}
// 		}
// 		case 1:		//Rochelle
// 		{
// 			if(StrEqual(strCurrentWeapon, "weapon_hunting_rifle", false) == true)
// 			{
// 				if(g_iSilentLevel[iClient] > 0)
// 				{
// 					g_iCurrentMaxClipSize[iClient] = (17 - (g_iSilentLevel[iClient] * 2));
// 				}
// 				else
// 				{
// 					g_iCurrentMaxClipSize[iClient] = 15;
// 				}
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_sniper_awp", false) == true)
// 			{
// 				if(g_iSilentLevel[iClient] > 0)
// 				{
// 					g_iCurrentMaxClipSize[iClient] = 3;
// 				}
// 				else
// 				{
// 					g_iCurrentMaxClipSize[iClient] = 20;
// 				}
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_sniper_scout", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (20 - g_iSilentLevel[iClient]);
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_sniper_military", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (30 + (g_iSilentLevel[iClient] * 6));
// 			}
// 		}
// 		case 2:		//Coach
// 		{
// 			if((StrEqual(strCurrentWeapon, "weapon_pumpshotgun", false) == true) || (StrEqual(strCurrentWeapon, "weapon_shotgun_chrome", false) == true))
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (8 + (g_iSprayLevel[iClient] * 2));
// 			}
// 			else if((StrEqual(strCurrentWeapon, "weapon_autoshotgun", false) == true) || (StrEqual(strCurrentWeapon, "weapon_shotgun_spas", false) == true))
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (10 + (g_iSprayLevel[iClient] * 2));
// 			}
// 		}
// 		case 3:		//Ellis
// 		{
// 			if(StrEqual(strCurrentWeapon, "weapon_rifle", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_rifle_ak47", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (40 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_rifle_sg552", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_rifle_desert", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (60 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_smg", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_smg_mp5", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_smg_silenced", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_hunting_rifle", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (15 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_sniper_military", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (30 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_sniper_awp", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (20 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 			else if(StrEqual(strCurrentWeapon, "weapon_sniper_scout", false) == true)
// 			{
// 				g_iCurrentMaxClipSize[iClient] = (20 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
// 			}
// 		}
// 		case 4:		//Nick
// 		{
// 			if((g_bRamboModeActive[iClient] == true) && (StrEqual(strCurrentWeapon, "weapon_rifle_m60", false) == true))
// 			{
// 				g_iCurrentMaxClipSize[iClient] = 250;
// 			}
// 			else if((g_bRamboModeActive[iClient] == false) && (StrEqual(strCurrentWeapon, "weapon_rifle_m60", false) == true))
// 			{
// 				g_iCurrentMaxClipSize[iClient] = 150;
// 			}
// 		}
// 	}
// }

void fnc_SetAmmoUpgrade(int iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:
		{
		
		}
		case ROCHELLE:
		{
		
		}
		case COACH:
		{
		
		}
		case ELLIS:
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
					char strCommandWithArgs[64];
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

					char strCommandWithArgs[64];
					Format(strCommandWithArgs, sizeof(strCommandWithArgs), "upgrade_add %s", g_strEllisUpgradeTypeSlot2);
					RunCheatCommand(iClient, "upgrade_add", strCommandWithArgs);
					//PrintToChatAll("Setting upgrade clip size based on saved ammo slot");
				}
				if (IsValidEntity(g_iPrimarySlotID[iClient]) && HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
				{
					SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iEllisUpgradeAmmoSlot2[iClient]);
					SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisUpgradeAmmoSlot2[iClient], true);
				}
			}
		}
		case NICK:
		{
			if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
			{
				if(g_iNickUpgradeAmmo[iClient] > 0)
				{
					char strCommandWithArgs[64];
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

// fnc_ClearSavedWeaponData(iClient)
// {
// 	switch(g_iChosenSurvivor[iClient])
// 	{
// 		case BILL:
// 		{
		
// 		}
// 		case ROCHELLE:
// 		{
		
// 		}
// 		case COACH:
// 		{
		
// 		}
// 		case ELLIS:
// 		{
// 			if(g_iEllisCurrentPrimarySlot[iClient] == 1)
// 			{
// 				g_iEllisPrimarySavedClipSlot0[iClient] = 0;
// 				g_iEllisPrimarySavedAmmoSlot0[iClient] = 0;
// 				g_iEllisUpgradeAmmoSlot1[iClient] = 0;
// 				g_strEllisUpgradeTypeSlot1 = "empty";
// 				g_strCurrentAmmoUpgrade = "empty";
// 				g_iEllisPrimarySlot0[iClient] = ITEM_EMPTY;
// 				//PrintToChatAll("g_iEllisPrimarySlot0[iClient] is now %s", g_iEllisPrimarySlot0[iClient]);
// 			}
// 			else if(g_iEllisCurrentPrimarySlot[iClient] == 0)
// 			{
// 				g_iEllisPrimarySavedClipSlot1[iClient] = 0;
// 				g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
// 				g_iEllisUpgradeAmmoSlot2[iClient] = 0;
// 				g_strEllisUpgradeTypeSlot2 = "empty";
// 				g_strCurrentAmmoUpgrade = "empty";
// 				g_iEllisPrimarySlot1[iClient] = ITEM_EMPTY;
// 				//PrintToChatAll("g_iEllisPrimarySlot1[iClient] is now %s", g_iEllisPrimarySlot1[iClient]);
// 			}
// 		}
// 		case NICK:
// 		{
// 			g_iNickPrimarySavedClip[iClient] = 0;
// 			g_iNickPrimarySavedAmmo[iClient] = 0;
// 			g_iNickUpgradeAmmo[iClient] = 0;
// 			g_strNickUpgradeType = "empty";
// 			g_strCurrentAmmoUpgrade = "empty";
// 			g_iStashedPrimarySlotWeaponIndex[iClient] = ITEM_EMPTY;
// 		}
// 	}
// }

void fnc_ClearAllWeaponData(int iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:
		{
		
		}
		case ROCHELLE:
		{
		
		}
		case COACH:
		{
		
		}
		case ELLIS:
		{
			g_iEllisPrimarySavedClipSlot0[iClient] = 0;
			g_iEllisPrimarySavedAmmoSlot0[iClient] = 0;
			g_iEllisUpgradeAmmoSlot1[iClient] = 0;
			g_strEllisUpgradeTypeSlot1 = "empty";
			g_strCurrentAmmoUpgrade = "empty";
			g_iEllisPrimarySlot0[iClient] = ITEM_EMPTY;
			//PrintToChatAll("g_iEllisPrimarySlot0[iClient] is now %s", g_iEllisPrimarySlot0[iClient]);

			g_iEllisPrimarySavedClipSlot1[iClient] = 0;
			g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
			g_iEllisUpgradeAmmoSlot2[iClient] = 0;
			g_strEllisUpgradeTypeSlot2 = "empty";
			g_strCurrentAmmoUpgrade = "empty";
			g_iEllisPrimarySlot1[iClient] = ITEM_EMPTY;
			//PrintToChatAll("g_iEllisPrimarySlot1[iClient] is now %s", g_iEllisPrimarySlot1[iClient]);
		}
		case NICK:		//Nick
		{
			g_strNickSecondarySlot1 = "empty";
			// g_strNickSecondarySlot2 = "empty";
			g_iNickCurrentSecondarySlot[iClient] = ITEM_EMPTY;
			g_iStashedPrimarySlotWeaponIndex[iClient] = ITEM_EMPTY;
			g_iNickPrimarySavedClip[iClient] = 0;
			g_iNickPrimarySavedAmmo[iClient] = 0;
		}
	}
}


void MolotovExplode(float xyzLocation[3])
{
	xyzLocation[2] += 5.0;
	
	int iEntity = CreateEntityByName("prop_physics");
	if(IsValidEntity(iEntity) == false)
		return;
	
	DispatchKeyValue(iEntity, "model", "models/props_junk/gascan001a.mdl");
	DispatchSpawn(iEntity);
	
	SetEntData(iEntity, GetEntSendPropOffs(iEntity, "m_CollisionGroup"), 1, 1, true);
	TeleportEntity(iEntity, xyzLocation, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(iEntity, "Break");
}

void PropaneExplode(float xyzLocation[3])
{
	xyzLocation[2] += 5.0;
	
	int iEntity = CreateEntityByName("prop_physics");
	if(IsValidEntity(iEntity) == false)
		return;
	
	DispatchKeyValue(iEntity, "model", "models/props_junk/propanecanister001a.mdl");
	DispatchSpawn(iEntity);
	
	SetEntData(iEntity, GetEntSendPropOffs(iEntity, "m_CollisionGroup"), 1, 1, true);
	TeleportEntity(iEntity, xyzLocation, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(iEntity, "Break");
}

int SpawnItem(float xyzLocation[3], int itemIndex, const float fZOffset = 0.0)
{
	//PrintToChatAll("spawn loc: %f, %f, %f", xyzLocation[0], xyzLocation[1], xyzLocation[2]);

	int iEntity = -1;
	iEntity = CreateEntityByName(ITEM_CLASS_NAME[itemIndex]);
	if( iEntity == -1 )
	{
		ThrowError("Failed to create entity '%s'", ITEM_CLASS_NAME[itemIndex]);
		return -1;
	}
	DispatchKeyValue(iEntity, "solid", "6");
	DispatchKeyValue(iEntity, "model", ITEM_MODEL_PATH[itemIndex]);

	//Add the required script name if its melee, otherwise it spawns hunter claws
	if (IsWeaponIndexMeleeWeapon(itemIndex))
		DispatchKeyValue(iEntity, "melee_script_name", ITEM_CMD_NAME[itemIndex]);
	
	DispatchKeyValue(iEntity, "rendermode", "3");
	DispatchKeyValue(iEntity, "disableshadows", "1");

	xyzLocation[2] += fZOffset;
	float xyzVelocity[3] = {0.0, 0.0, 300.0};
	DispatchSpawn(iEntity);

	// Add ammo to the weapon if its a primary weapon
	// Note that this conveniently gives the max amount of reserve ammo
	if (RunEntityChecks(iEntity) == true && IsWeaponIndexPrimarySlotItem(itemIndex))
		SetEntProp(iEntity, Prop_Send, "m_iExtraPrimaryAmmo", 999);

	// Its required to teleport after spawn or velocity wont work
	TeleportEntity(iEntity, xyzLocation, NULL_VECTOR, xyzVelocity);

	return iEntity;
}

void GiveEveryWeaponToSurvivor(int iClient)
{
	int iWeaponsToSpawn[] = {
		ITEM_MP5,
		ITEM_AK47,
		ITEM_M16A2,
		ITEM_SIG_SG_552,
		ITEM_BENELLI_M1014,
		ITEM_FRANCHI_SPAS_12,
		ITEM_HK_MSG90,
		ITEM_SCOUT,
		ITEM_M60,
		ITEM_MAGNUM,
		ITEM_KATANA,
		ITEM_NIGHTSTICK,
		ITEM_CHAINSAW,
		ITEM_PIPE_BOMB,
		ITEM_PIPE_BOMB,
		ITEM_BILE_JAR,
		ITEM_BILE_JAR,
		ITEM_MOLOTOV,
		ITEM_MOLOTOV,
		ITEM_INCENDIARY_AMMO
	};


	float xyzClientLocation[3];
	GetClientEyePosition(iClient, xyzClientLocation);

	for (int i=0; i < sizeof(iWeaponsToSpawn); i++)
	{
		// PrintToChat(iClient, "INDEX: %i, size %i", iWeaponsToSpawn[i], sizeof(iWeaponsToSpawn));
		SpawnItem(xyzClientLocation, iWeaponsToSpawn[i], 1.0);
	}

	// Add a cooldown to prevent the server from being overloaded with entities that have physics
	g_bGiveAlotOfWeaponsOnCooldown =  true;
	CreateTimer(GIVE_ALOT_OF_WEAPONS_COOLDOWN_DURATION, Timer_ResetGiveAlotOfWeaponsOnCooldown, _, TIMER_FLAG_NO_MAPCHANGE);
}

Action Timer_ResetGiveAlotOfWeaponsOnCooldown(Handle timer, any data)
{
	g_bGiveAlotOfWeaponsOnCooldown = false;
	return Plugin_Stop;
}



// This is to remove all the weapons that are too close to each other
// For cleaning up weapons so server does not crash or slow down from physics
void RunCloseProximityWeaponCleanUp()
{
	char strClassName[32];
	float fAllPrimaryEntityLocations[MAXENTITIES + 1][3]; 

	for (int iEntity=1; iEntity <= MAXENTITIES; iEntity++)
	{
		if (RunEntityChecks(iEntity) == false)
			continue;
		
		// Get the class name to check
		strClassName = "";
		GetEntityClassname(iEntity, strClassName, 32);
		if (StrContains(strClassName, "weapon") == -1)
			continue;
		if (StrContains(strClassName, "spawn") > -1)
			continue;

		// Do not check if has it an owner
		if (GetEntProp(iEntity, Prop_Send, "m_hOwnerEntity") != -1)
			continue;

		// Get the weapon item index
		int iWeaponIndex = FindWeaponItemIndex(strClassName, ITEM_CLASS_NAME);
		
		// If the weapon is a primary weapon, then store the location for check later
		if (IsWeaponIndexPrimarySlotItem(iWeaponIndex))
		{
			// PrintToServer("%i) %i: %s", iEntity, iWeaponIndex, strClassName);
			GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", fAllPrimaryEntityLocations[iEntity]);
		}
	}

	// Loop through array of fAllPrimaryEntityLocations and check if 
	// there are any more weapons too close to it. Note we dont do the last
	// item entity here
	for (int iEntity1=1; iEntity1 < MAXENTITIES; iEntity1++)
	{
		if (fAllPrimaryEntityLocations[iEntity1][0] == 0.0)
			continue;
		
		// Check all the secondary entities that can be close to Entity1.  Note: Only
		// check the ones that are after iEntity1 since the previous have already been checked
		for (int iEntity2=iEntity1 + 1; iEntity2 <= MAXENTITIES; iEntity2++)
		{
			if (fAllPrimaryEntityLocations[iEntity2][0] == 0.0)
				continue;

			// PrintToChatAll("%0.1f, %0.1f, %0.1f", fAllPrimaryEntityLocations[iEntity1][0], fAllPrimaryEntityLocations[iEntity1][1], fAllPrimaryEntityLocations[iEntity1][2])
			// PrintToChatAll("GetVectorDistance: %f", GetVectorDistance(fAllPrimaryEntityLocations[iEntity1], fAllPrimaryEntityLocations[iEntity2]));

			if (GetVectorDistance(fAllPrimaryEntityLocations[iEntity1], 
				fAllPrimaryEntityLocations[iEntity2], false) <
				WEAPON_PROXIMITY_CLEAN_UP_TRIGGER_THRESHOLD)
			{
				// PrintToChatAll("%0.1f, %0.1f, %0.1f", fAllPrimaryEntityLocations[iEntity2][0], fAllPrimaryEntityLocations[iEntity2][1], fAllPrimaryEntityLocations[iEntity2][2])
				// PrintToChatAll("GetVectorDistance: %f", GetVectorDistance(fAllPrimaryEntityLocations[iEntity1], fAllPrimaryEntityLocations[iEntity2]));
				KillEntitySafely(iEntity2);
				fAllPrimaryEntityLocations[iEntity2][0] = 0.0;
				fAllPrimaryEntityLocations[iEntity2][1] = 0.0;
				fAllPrimaryEntityLocations[iEntity2][2] = 0.0;
			}
		}
	}
}


// This is to remove all pistols, created for Nicks swapping glitch
// For cleaning up weapons so server does not crash or slow down from physics
void PistolWeaponCleanUp()
{
	char strClassName[32];
	for (int iEntity=1; iEntity <= MAXENTITIES; iEntity++)
	{
		if (RunEntityChecks(iEntity) == false)
			continue;
		
		// Get the class name to check
		strClassName = "";
		GetEntityClassname(iEntity, strClassName, 32);
		if (StrEqual(strClassName, "weapon_pistol", false) == false &&
			StrEqual(strClassName, "weapon_pistol_magnum", false) == false)
			continue;

		// Do not remove if the pistol has an owner
		if (GetEntProp(iEntity, Prop_Send, "m_hOwnerEntity") != -1)
			continue;

		// PrintToServer("%i, %s: owner %i", iEntity, strClassName, 
		// 	GetEntProp(iEntity, Prop_Send, "m_hOwnerEntity"));

		// Remove the pistol
		KillEntitySafely(iEntity);
	}
}


void DropMeleeItem(int iClient)
{
	int iSecondaryWeaponID = GetPlayerWeaponSlot(iClient, 1);

	// Find the weapon item index
	int iItemIndex = GetWeaponIndexByFindingAndComparingViewModelString(iClient, iSecondaryWeaponID);
	if (RunEntityChecks(iItemIndex) == false)
		return;

	if (IsWeaponIndexMeleeWeapon(iItemIndex) == false)
		return;

	RunCheatCommand(iClient, "give", "give pistol");

	// Get the player's currently held and active weapon
	int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (RunEntityChecks(iActiveWeaponID) == false)
		return;

	// Make sure the player is actively using the specified weapon slot
	if (iActiveWeaponID != GetPlayerWeaponSlot(iClient, 1))
		return;

	KillEntitySafely(iActiveWeaponID);
}
