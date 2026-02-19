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

	g_iOffset_Ammo[iClient] = FindDataMapInfo(iClient,"m_iAmmo");
	g_iReserveAmmo[iClient] = GetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient]);
}

void StoreCurrentPrimaryWeapon(int iClient)
{
	// Check if in rambo mode and have the M60 out
	if (g_bRamboModeActive[iClient] && g_iRamboWeaponID[iClient] == GetPlayerWeaponSlot(iClient, 0))
		return;

	g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);

	char strCurrentWeapon[32];
	GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));

	// Get the weapon index and ensure its a primary weapon
	int iWeaponIndex = FindWeaponItemIndex(strCurrentWeapon, ITEM_CLASS_NAME);
	if (iWeaponIndex <= 0 || IsWeaponIndexPrimarySlotItem(iWeaponIndex) == false)
		return;

	SetAmmoOffsetForPrimarySlotID(iClient, iWeaponIndex);


	// Store the weapon names for Ellis
	if (g_iEllisCurrentPrimarySlot[iClient] == 0)
		g_iEllisPrimarySlot0[iClient] = iWeaponIndex;
	else if (g_iEllisCurrentPrimarySlot[iClient] == 1)
		g_iEllisPrimarySlot1[iClient] = iWeaponIndex;
	
	// Store for Nick's Rambo gamble
	g_iStashedPrimarySlotWeaponIndex[iClient] = iWeaponIndex;
}
 
void StoreCurrentPrimaryWeaponAmmo(int iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:		//Bill
		{
		
		}
		case ROCHELLE:	//Rochelle
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
				if(g_iEllisCurrentPrimarySlot[iClient] == 0)
				{
					g_iEllisPrimarySavedClipSlot0[iClient] = g_iCurrentClipAmmo[iClient];
					g_iEllisPrimarySavedAmmoSlot0[iClient] = g_iReserveAmmo[iClient];

					if (IsValidEntity(g_iPrimarySlotID[iClient]) && IsValidEdict(g_iPrimarySlotID[iClient]))
					{
						if (HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
							g_iEllisUpgradeAmmoSlot1[iClient] = GetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
					}
					
					if(g_iEllisUpgradeAmmoSlot1[iClient] == 0)
					{
						g_strEllisUpgradeTypeSlot1 = "empty";
						g_strCurrentAmmoUpgrade = "empty";
					}
					else
					{
						g_strEllisUpgradeTypeSlot1 = g_strCurrentAmmoUpgrade;
					}
				}
				else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
				{
					g_iEllisPrimarySavedClipSlot1[iClient] = g_iCurrentClipAmmo[iClient];
					g_iEllisPrimarySavedAmmoSlot1[iClient] = g_iReserveAmmo[iClient];
					if (IsValidEntity(g_iPrimarySlotID[iClient]) && HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
						g_iEllisUpgradeAmmoSlot2[iClient] = GetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
					if(g_iEllisUpgradeAmmoSlot2[iClient] == 0)
					{
						g_strEllisUpgradeTypeSlot2 = "empty";
						g_strCurrentAmmoUpgrade = "empty";
					}
					else
					{
						g_strEllisUpgradeTypeSlot2 = g_strCurrentAmmoUpgrade;
					}
				}
			}
		}
		case NICK:		//Nick
		{
			int iCurrentPrimaryID = GetPlayerWeaponSlot(iClient, 0);
			if (RunEntityChecks(iCurrentPrimaryID) == false)
			{
				g_iNickPrimarySavedClip[iClient] = 0;
				g_iNickPrimarySavedAmmo[iClient] = 0;
				g_strNickUpgradeType = "empty";
				g_strCurrentAmmoUpgrade = "empty";
				return;
			}


			// Don't store ammo of the rambo weapon
			if (iCurrentPrimaryID == g_iRamboWeaponID[iClient])
				return;


			g_iNickPrimarySavedClip[iClient] = GetEntProp(iCurrentPrimaryID,Prop_Data,"m_iClip1");
			g_iOffset_Ammo[iClient] = FindDataMapInfo(iClient,"m_iAmmo");
			g_iReserveAmmo[iClient] = GetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient]);
			g_iNickPrimarySavedAmmo[iClient] = g_iReserveAmmo[iClient];
			if (IsValidEntity(g_iPrimarySlotID[iClient]) && HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded")) 
				g_iNickUpgradeAmmo[iClient] = GetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
			if(g_iNickUpgradeAmmo[iClient] == 0)
			{
				g_strNickUpgradeType = "empty";
				g_strCurrentAmmoUpgrade = "empty";
			}
			else
			{
				g_strNickUpgradeType = g_strCurrentAmmoUpgrade;
			}
		}
	}
}

void CyclePlayerWeapon(int iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		// case BILL:
		// case ROCHELLE:
		// case COACH:
		case ELLIS:		CyclePlayerWeapon_Ellis(iClient);
		case NICK:		CyclePlayerWeapon_Nick(iClient);
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
		}
		case NICK:		//Nick
		{
			SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iNickPrimarySavedClip[iClient], true);
			SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iNickPrimarySavedAmmo[iClient]);
		}
	}
}

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
			if((g_iEllisCurrentPrimarySlot[iClient] == 0) && (g_iEllisUpgradeAmmoSlot1[iClient] > 0))
			{
				if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
				{
					char strCommandWithArgs[64];
					Format(strCommandWithArgs, sizeof(strCommandWithArgs), "upgrade_add %s", g_strEllisUpgradeTypeSlot1);
					RunCheatCommand(iClient, "upgrade_add", strCommandWithArgs);
				}
				if (IsValidEntity(g_iPrimarySlotID[iClient]) && HasEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded"))
				{
					SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iEllisUpgradeAmmoSlot1[iClient]);
					SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisUpgradeAmmoSlot1[iClient], true);
				}
			}
			else if((g_iEllisCurrentPrimarySlot[iClient] == 1) && (g_iEllisUpgradeAmmoSlot2[iClient] > 0))
			{
				if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
				{
					char strCommandWithArgs[64];
					Format(strCommandWithArgs, sizeof(strCommandWithArgs), "upgrade_add %s", g_strEllisUpgradeTypeSlot2);
					RunCheatCommand(iClient, "upgrade_add", strCommandWithArgs);
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

			g_iEllisPrimarySavedClipSlot1[iClient] = 0;
			g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
			g_iEllisUpgradeAmmoSlot2[iClient] = 0;
			g_strEllisUpgradeTypeSlot2 = "empty";
			g_strCurrentAmmoUpgrade = "empty";
			g_iEllisPrimarySlot1[iClient] = ITEM_EMPTY;
		}
		case NICK:		//Nick
		{
			g_strNickSecondarySlot1 = "empty";
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
		SpawnItem(xyzClientLocation, iWeaponsToSpawn[i], 1.0);
	}

	// Add a cooldown to prevent the server from being overloaded with entities that have physics
	g_bGiveAlotOfWeaponsOnCooldown =  true;
	CreateTimer(GIVE_ALOT_OF_WEAPONS_COOLDOWN_DURATION, Timer_ResetGiveAlotOfWeaponsOnCooldown, _, TIMER_FLAG_NO_MAPCHANGE);
}

Action Timer_ResetGiveAlotOfWeaponsOnCooldown(Handle timer, int data)
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


			if (GetVectorDistance(fAllPrimaryEntityLocations[iEntity1], 
				fAllPrimaryEntityLocations[iEntity2], false) <
				WEAPON_PROXIMITY_CLEAN_UP_TRIGGER_THRESHOLD)
			{
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
