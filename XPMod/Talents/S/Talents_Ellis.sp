void TalentsLoad_Ellis(int iClient)
{
	SetPlayerTalentMaxHealth_Ellis(iClient, !g_bSurvivorTalentsGivenThisRound[iClient]);
	SetClientSpeed(iClient);
	EllisDropMeleeWeaponsIfNecessary(iClient);
	
	if(g_iMetalLevel[iClient] == 5)
	{
		g_bIsEllisLimitBreaking[iClient] = false;
		g_bCanEllisLimitBreak[iClient] = true;
		g_bEllisLimitBreakInCooldown[iClient] = false;
	}
	
	if(g_bSurvivorTalentsGivenThisRound[iClient] == false)
	{
		if((0.4 - (float(g_iWeaponsLevel[iClient])*0.08)) < g_fMaxLaserAccuracy)
		{
			g_fMaxLaserAccuracy = 0.4 - (float(g_iWeaponsLevel[iClient]) * 0.08);
			SetConVarFloat(FindConVar("upgrade_laser_sight_spread_factor"), g_fMaxLaserAccuracy);
		}
		
		g_iClientBindUses_1[iClient] = 3 - RoundToCeil(g_iMetalLevel[iClient] * 0.5);
	}
	
	if(g_iFireLevel[iClient] > 0)
	{
		if(g_iClientBindUses_2[iClient] < 3)
			g_iPID_EllisCharge3[iClient] = WriteParticle(iClient, "ellis_ulti_fire_charge3", 0.0);
		if(g_iClientBindUses_2[iClient] < 2)
			g_iPID_EllisCharge2[iClient] = WriteParticle(iClient, "ellis_ulti_fire_charge2", 0.0);
		if(g_iClientBindUses_2[iClient] < 1)
			g_iPID_EllisCharge1[iClient] = WriteParticle(iClient, "ellis_ulti_fire_charge1", 0.0);
	}
	
	if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Weapon Expert Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilities will be automatically set as you level.");
		
	if(g_iOverLevel[iClient] > 0)
	{
		int iCurrentHealth = GetPlayerHealth(iClient);
		int iMaxHealth = GetPlayerMaxHealth(iClient);
		if (iCurrentHealth < (iMaxHealth - ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT))
		{
			if(g_bEllisOverSpeedIncreased[iClient])
			{
				g_bEllisOverSpeedIncreased[iClient] = false;
				SetClientSpeed(iClient);
			}
		}
		else if (iCurrentHealth >= (iMaxHealth - ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT))
		{
			if(g_bEllisOverSpeedIncreased[iClient] == false)
			{
				g_bEllisOverSpeedIncreased[iClient] = true;
				SetClientSpeed(iClient);
			}
		}

		// Give Ellis an extra adrenaline but do it delayed to give after any initial equipment
		CreateTimer(0.1, TimerDelayedGiveEllisAnExtraAdrenaline, iClient, TIMER_FLAG_NO_MAPCHANGE);

		// Give Ellis his self revive kit
		if(g_iBringLevel[iClient] > 0)
		{
			g_iSelfRevives[iClient]++;
			PrintToChat(iClient, "\x03[XPMod] \x05+1 Self Revive Kit.");
		}

		// Set adrenaline counter for global Ellis
		g_iEllisAdrenalineStackDuration += (g_iOverLevel[iClient] * 2);
		SetConVarFloat(FindConVar("adrenaline_duration"), float(g_iEllisAdrenalineStackDuration));
	}

	// Give Ellis a molotov for Fire Storm
	if (g_iFireLevel[iClient] > 0)
	{
		CreateTimer(0.1, TimerDelayedGiveEllisAnExtraMolotovForFireStorm, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}

	if(g_iJamminLevel[iClient] == 5)
	{
		g_iEllisJamminGrenadeCounter[iClient] = 0;
		g_iEllisJamminAdrenalineCounter[iClient] = 0;
	}
	
	if(g_iWeaponsLevel[iClient] == 5)
	{
		g_iEllisCurrentPrimarySlot[iClient] = 0;
		g_bCanEllisPrimaryCycle[iClient] = true;
		g_iEllisPrimarySlot0[iClient] = ITEM_EMPTY;
		g_iEllisPrimarySlot1[iClient] = ITEM_EMPTY;
	}
}

void SetPlayerTalentMaxHealth_Ellis(int iClient, bool bFillInHealthGap = true)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ELLIS ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;

	SetPlayerMaxHealth(iClient, 
		ELLIS_STARTING_MAX_HEALTH + 
		(g_iCoachTeamHealthStack * 5),
		false,
		bFillInHealthGap);
}

void OnGameFrame_Ellis(int iClient)
{
	if(g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;
	
	HandleEllisSwitchToStashedPrimaryWeapon(iClient);
	HandleEllisLimitBreak(iClient);

	// For Ellis's Weapon Cycling, set his ammo and clip after switching
	if (g_bSetWeaponAmmoOnNextGameFrame[iClient] == true)
	{
		g_bSetWeaponAmmoOnNextGameFrame[iClient] = false;
		fnc_SetAmmo(iClient);
		fnc_SetAmmoUpgrade(iClient);
	}
	
	if((g_iMetalLevel[iClient] > 0) || (g_iFireLevel[iClient] > 0))
	{
		int buttons;
		buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if((buttons & IN_RELOAD) && g_bClientIsReloading[iClient] == false && g_bForceReload[iClient] == false)
		{
			char currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			int ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (RunEntityChecks(ActiveWeaponID) == false)
				return;
			int CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
			{
				int iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				int iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
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
				int iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				int iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
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
				int iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				int iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
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
				int iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				int iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
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

void OGFSurvivorReload_Ellis(int iClient, const char[] currentweapon, int ActiveWeaponID, int CurrentClipAmmo, int iOffset_Ammo)
{
	if(g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;
	
	if(g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY || g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY)
	{
		StoreCurrentPrimaryWeapon(iClient);
		char strCurrentWeapon[32];
		GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
		if((StrContains(strCurrentWeapon, "rifle", false) != -1) || (StrContains(strCurrentWeapon, "smg", false) != -1) || (StrContains(strCurrentWeapon, "shotgun", false) != -1) || (StrContains(strCurrentWeapon, "launcher", false) != -1) || (StrContains(strCurrentWeapon, "sniper", false) != -1))
		{
			StoreCurrentPrimaryWeaponAmmo(iClient);
		}
	}
	
	SetEllisClipSize(iClient, currentweapon, ActiveWeaponID, CurrentClipAmmo, iOffset_Ammo);
}


bool OnPlayerRunCmd_Ellis(int iClient, int &iButtons)
{
	// Ellis abilities
	if (g_iChosenSurvivor[iClient] != ELLIS || 
		g_bTalentsConfirmed[iClient] == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS || 
		g_bGameFrozen == true)
		return false;

	// Handle Adrenaline/Pills Max Health Reset Bug
	// Check the boost slot to see if they currently have a adrenaline or pain pill
	if (g_iOverLevel[iClient] > 0 &&
		iButtons & IN_ATTACK)
	{
		// Ensure they are holding the weapon in the health boost slot
		int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
		if (RunEntityChecks(iActiveWeaponID) && iActiveWeaponID == GetPlayerWeaponSlot(iClient, 4))
		{
			g_iTempHealthBeforeUsingHealthBoostSlotItem[iClient] = GetSurvivorTempHealth(iClient);
		}
	}

	return false;
}

void HandleFasterAttacking_Ellis(int iClient, int iButtons)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || 
		g_bTalentsConfirmed[iClient] == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iOverLevel[iClient] <= 0)
		return;

	if (!(iButtons & IN_ATTACK))
		return;

	// Make sure they have an active weapon
	int iActiveWeaponID = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
	if (iActiveWeaponID == -1)
		return;

	// Get the slot they are using, then return if it isnt primary or secondary
	int iActiveWeaponSlot = GetActiveWeaponSlot(iClient, iActiveWeaponID);
	if (iActiveWeaponSlot < 0 || iActiveWeaponSlot > 1)
		return;

	// Ellis's limit break ability
	// Ensure they are using their primary slot weapon
	// Limit break should disabled elsewhere if they do a primary weapon switch or pick up another primary
	if (g_bIsEllisLimitBreaking[iClient] == true && iActiveWeaponSlot == 0)
	{
		// Also ensure that the class name matches the active weapon
		// Do as last check for performance reasons
		char strWeaponClassName[32];
		GetEntityClassname(iActiveWeaponID, strWeaponClassName, 32);
		if (strcmp(strWeaponClassName, ITEM_CLASS_NAME[g_iLimitBreakWeaponIndex[iClient]], true) == 0)
		{
			ChangeWeaponSpeed(iClient, ELLIS_ROF_LIMIT_BREAK, iActiveWeaponSlot);
			return;
		}
	}

	// Check to make sure its a melee weapon
	char strEntityClassName[32];
	GetEntityClassname(iActiveWeaponID, strEntityClassName, 32);
	if (StrContains(strEntityClassName, "weapon_melee", true) != -1)
		return;

	// Set the weapon speed depending on what weapon slot (faster pistols)
	float fNewWeaponSpeed = iActiveWeaponSlot == 0 ? 
		1.0 + (g_iMetalLevel[iClient] * ELLIS_ROF_METAL_PER_LEVEL) + (g_iOverLevel[iClient] * ELLIS_ROF_OVER_PER_LEVEL): 
		ELLIS_ROF_PISTOLS;

	// // Set custom speed for certain weapons
	// char strCurrentWeapon[32];
	// GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
	// // This enaables full auto all the weapons, pistols, etc, but we want to exclude snipers
	// if (StrContains(strCurrentWeapon, "shotgun", false) != -1 || StrContains(strCurrentWeapon, "sniper", false)  != -1)
	// 	fNewWeaponSpeed = (g_iMetalLevel[iClient] * ELLIS_ROF_OVER_PER_LEVEL) + (g_iOverLevel[iClient] * ELLIS_ROF_OVER_PER_LEVEL);

	// Add Adrenaline buff
	if (g_bEllisHasAdrenalineBuffs[iClient] == true)
		fNewWeaponSpeed += (g_iOverLevel[iClient] * ELLIS_ROF_ADRENALINE_PER_LEVEL);

	ChangeWeaponSpeed(iClient, fNewWeaponSpeed, iActiveWeaponSlot);
}

void EventsHurt_AttackerEllis(Handle hEvent, int iAttacker, int iVictim)
{
	if(g_iChosenSurvivor[iAttacker] != ELLIS || g_bTalentsConfirmed[iAttacker] == false)
		return;

	if (IsFakeClient(iAttacker))
		return;
	
	if (g_iClientTeam[iVictim] != TEAM_INFECTED)
		return;
	
	if(g_iFireLevel[iAttacker]>0)
	{
		if(g_iClientTeam[iVictim] == TEAM_INFECTED)
		{
			if(g_bUsingFireStorm[iAttacker]==true)
			{
				float time = (float(g_iFireLevel[iAttacker]) * 6.0);
				IgniteEntity(iVictim, time, false);
			}
		}
	}

	SuppressNeverUsedWarning(hEvent);
}

void EventsHurt_VictimEllis(Handle hEvent, int attacker, int victim)
{
	if(g_iChosenSurvivor[victim] != ELLIS || g_bTalentsConfirmed[victim] == false)
		return;

	if (IsFakeClient(victim))
		return;

	SuppressNeverUsedWarning(attacker);

	int dmgType = GetEventInt(hEvent, "type");
	int dmgHealth = GetEventInt(hEvent,"dmg_health");

	if(g_iFireLevel[victim] > 0)
	{
		//Prevent Fire Damage
		if(dmgType == DAMAGETYPE_FIRE1 || dmgType == DAMAGETYPE_FIRE2)
		{
			// Still doesn't work while Ellis is incap
			// It seems that temp health works a little different while incap
			AddTempHealthToSurvivor(victim, float(dmgHealth), false);
		}
	}

	if(g_iOverLevel[victim] > 0)
	{
		int iCurrentHealth = GetPlayerHealth(victim);
		int iMaxHealth = GetPlayerMaxHealth(victim);
		//if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - float(ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT)))
		if(iCurrentHealth < (iMaxHealth - ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT))
		{
			if(g_bEllisOverSpeedIncreased[victim])
			{
				g_bEllisOverSpeedIncreased[victim] = false;

				SetClientSpeed(victim);
			}
		}
		//else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - float(ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT)))
		else if(iCurrentHealth >= (iMaxHealth - ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT))
		{
			if(g_bEllisOverSpeedIncreased[victim] == false)
			{
				g_bEllisOverSpeedIncreased[victim] = true;

				SetClientSpeed(victim);						
			}
		}
	}
}

void EventsDeath_AttackerEllis(Handle hEvent, int iAttacker, int iVictim)
{
	if(g_iChosenSurvivor[iAttacker] != ELLIS || g_bTalentsConfirmed[iAttacker] == false)
		return;

	// Handle Ellis's speed boost with the tanks dying
	if (g_iClientTeam[iVictim] == TEAM_INFECTED &&
		g_bEndOfRound == false && 
		RunClientChecks(iVictim) &&
		GetEntProp(iVictim, Prop_Send, "m_zombieClass") == TANK)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (g_iChosenSurvivor[i] == ELLIS &&
				g_iJamminLevel[i] > 0 &&
				g_iClientTeam[i] == TEAM_SURVIVORS &&
				RunClientChecks(i) && 
				IsPlayerAlive(i) &&
				IsFakeClient(i) == false)
			{
				SetClientSpeed(i);
				if(g_iTankCounter == 0)
					PrintHintText(i, "You calm down knowing there are no Tanks around.");
			}
		}
	}
	
	// Now start Ellis's attacker abilities
	if (g_iChosenSurvivor[iAttacker] != ELLIS ||
		g_bTalentsConfirmed[iAttacker] != true ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		g_iClientTeam[iVictim] != TEAM_INFECTED ||
		RunClientChecks(iAttacker) == false ||
		IsPlayerAlive(iAttacker) == false)
		return;
	
	SuppressNeverUsedWarning(hEvent);

	if(g_iBringLevel[iAttacker] > 0)
	{
		// Give temp health on SI kill
		if (GetSurvivorTempHealth(iAttacker) + g_iBringLevel[iAttacker] <= ELLIS_MAX_TEMP_HEALTH)
		{
			AddTempHealthToSurvivor(iAttacker, float(g_iBringLevel[iAttacker]), false);
		}
		else
		{
			ResetTempHealthToSurvivor(iAttacker);
			AddTempHealthToSurvivor(iAttacker, float(ELLIS_MAX_TEMP_HEALTH), false);
		}
		
		// Increase clip size
		int iEntid = GetEntDataEnt2(iAttacker, g_iOffset_ActiveWeapon);
		if (iEntid != -1)
		{
			char wclass[32];
			GetEntityNetClass(iEntid, wclass, 32);
			if (StrContains(wclass,"rifle",false) != -1 || 
				StrContains(wclass,"smg",false) != -1 || 
				StrContains(wclass,"sub",false) != -1 || 
				StrContains(wclass,"sniper",false) != -1)
			{
				int clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				clip += g_iBringLevel[iAttacker] * ELLIS_AMMO_GAINED_PER_SI_KILL_PER_LEVEL;
				// Clamp the clip
				if(clip > 250)
					clip = 250;
				SetEntData(iEntid, g_iOffset_Clip1, clip, true);

				// Whats clip2 do??
				//clip2 = GetEntProp(iEntid,Prop_Data,"m_iClip2"); 			
				//SetEntData(iEntid, clipsize2, clip2+30, true);	
			}
		}
		if(g_iEllisSpeedBoostCounter[iAttacker] < (2 * g_iBringLevel[iAttacker]))
		{
			g_iEllisSpeedBoostCounter[iAttacker]++;
			SetClientSpeed(iAttacker);
		}
	}
}

void EventsWeaponFire_Ellis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS ||
		g_bTalentsConfirmed[iClient] != true ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return;

	char strCurrentWeapon[32];
	GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon))
	int iWeaponItemIndex = FindWeaponItemIndex(strCurrentWeapon, ITEM_CLASS_NAME);

	// TODO: refactor this function using the weapon index instead for performace reasons
	// Additionaly, maybe also add helper functions for IsSniper, IsSMG, etc.

	if(g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY || g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY)
	{
		StoreCurrentPrimaryWeapon(iClient);
		// GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
		if((StrContains(strCurrentWeapon, "rifle", false) != -1) || (StrContains(strCurrentWeapon, "smg", false) != -1) || (StrContains(strCurrentWeapon, "shotgun", false) != -1) || (StrContains(strCurrentWeapon, "launcher", false) != -1) || (StrContains(strCurrentWeapon, "sniper", false) != -1))
		{
			StoreCurrentPrimaryWeaponAmmo(iClient);
		}
	}
	int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (IsValidEntity(iActiveWeaponID) == false)
		return;
	int CurrentClipAmmo = GetEntProp(iActiveWeaponID,Prop_Data,"m_iClip1");

	if((CurrentClipAmmo == 0) || (CurrentClipAmmo == 1))
	{
		StoreCurrentPrimaryWeapon(iClient);


		if(g_iReserveAmmo[iClient] == 0)
		{
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

	// Make all guns automatic, except for sniper rifles
	if (g_iMetalLevel[iClient] > 0 && (iWeaponItemIndex >= ITEM_RANGE_MIN_SNIPER && iWeaponItemIndex <= ITEM_RANGE_MAX_SNIPER) == false)
		SetEntProp(iActiveWeaponID, Prop_Send, "m_isHoldingFireButton", 0);
}

void EventsPillsUsed_Ellis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || 
		g_bTalentsConfirmed[iClient] == false ||
		g_iOverLevel[iClient] <= 0)
		return;


	// Give proper temp health to Ellis
	int iPillHealthBonus = ELLIS_HEAL_AMOUNT_PILLS;
	SetEllisHealthAfterUsingAdrenalineOrPills(iClient, iPillHealthBonus);

	// Give stashed adrenaline if they have more
	if (g_iStashedInventoryAdrenaline[iClient] > 0)
		CreateTimer(0.1, TimerGiveAdrenalineFromStashedInventory, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

void EventsAdrenalineUsed_Ellis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || 
		g_iOverLevel[iClient] <= 0 ||
		g_bTalentsConfirmed[iClient] == false ||
		IsFakeClient(iClient) == true)
		return;

	// Give proper temp health to Ellis
	int iAdrenalineHealthBonus = ELLIS_HEAL_AMOUNT_ADRENALINE;
	SetEllisHealthAfterUsingAdrenalineOrPills(iClient, iAdrenalineHealthBonus);

	// Set the variable that will allow for damage buffs during adrenaline duration
	g_bEllisHasAdrenalineBuffs[iClient] = true;
	CreateTimer(float(g_iEllisAdrenalineStackDuration), TimerRemoveEllisAdrenalineBuffs, iClient, TIMER_FLAG_NO_MAPCHANGE);


	// Give stashed adrenaline if they have more
	if (g_iStashedInventoryAdrenaline[iClient] > 0)
		CreateTimer(0.1, TimerGiveAdrenalineFromStashedInventory, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

void EventsItemPickUp_Ellis(int iClient, const char[] strWeaponClass)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;


	EllisDropMeleeWeaponsIfNecessary(iClient);

	if (g_iJamminLevel[iClient] > 0)
	{
		// Save that the health boost was empty on last pick up
		// This is for Ellis's Jamin ability on Player Use event
		if (g_bHealthBoostItemJustGivenByCheats[iClient] == false && 
			(StrEqual(strWeaponClass, "pain_pills", false) == true || 
			StrEqual(strWeaponClass, "adrenaline", false) == true))
			g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] = true;
		
		g_bHealthBoostItemJustGivenByCheats[iClient] = false;
	}

	if (g_iFireLevel[iClient] > 0)
	{
		if (g_bGrenadeItemJustGivenByCheats[iClient] == false &&
			StrEqual(strWeaponClass, "molotov", false) == true)
			g_bGrenadeSlotWasEmptyOnLastPickUp[iClient] = true;

		g_bGrenadeItemJustGivenByCheats[iClient] = false;
	}

	int iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");

	if(g_iMetalLevel[iClient]>0 || g_iFireLevel[iClient]>0)
	{
		if (StrContains(strWeaponClass,"rifle",false) != -1 || StrContains(strWeaponClass,"smg",false) != -1 || StrContains(strWeaponClass,"sub",false) != -1 || StrContains(strWeaponClass,"sniper",false) != -1)
		{
			int iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
			if(iEntid < 1)
				return;
			if(IsValidEntity(iEntid)==false)
				return;
			int clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
			g_iClientPrimaryClipSize[iClient] = clip;
			SetEntData(iEntid, g_iOffset_Clip1, clip + (g_iFireLevel[iClient] * 10), true);
			clip = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
			SetEntData(iClient, iOffset_Ammo + 12, clip - (g_iFireLevel[iClient] * 10));
			clip = GetEntData(iClient, iOffset_Ammo + 20);	//for smg (+20)
			SetEntData(iClient, iOffset_Ammo + 20, clip - (g_iFireLevel[iClient] * 10));
			clip = GetEntData(iClient, iOffset_Ammo + 32);	//for huntingrifle (+32)
			SetEntData(iClient, iOffset_Ammo + 32, clip - (g_iFireLevel[iClient] * 10));
			clip = GetEntData(iClient, iOffset_Ammo + 36);	//for huntingrifle2? (+36)
			SetEntData(iClient, iOffset_Ammo + 36, clip - (g_iFireLevel[iClient] * 10));
		}
	}
}

void ConvertEllisHealthToTemporary(int iClient)
{
	if (g_iBringLevel[iClient] <= 0 ||
		g_iChosenSurvivor[iClient] != ELLIS ||
		RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return;

	ConvertAllSurvivorHealthToTemporary(iClient);
}

void HandlePostSetPlayerHealth_Ellis(int iClient)
{
	ConvertEllisHealthToTemporary(iClient);
}

void EventsPlayerUse_Ellis(int iClient, int iTargetID)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;


	int iSlotItemID = GetPlayerWeaponSlot(iClient, 4);

	// Check if the item when into their weapon slot, if not, then continue to stash it.
	if (g_iJamminLevel[iClient] > 0 && 
		iSlotItemID != iTargetID &&
		g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] == false)
	{
		char strTargetClassName[35];
		GetEdictClassname(iTargetID, strTargetClassName, sizeof(strTargetClassName));

		if (StrContains(strTargetClassName,"weapon_adrenaline",false) != -1)
		{
			if (g_iStashedInventoryAdrenaline[iClient] < ELLIS_STASHED_INVENTORY_MAX_ADRENALINE)
			{
				if (iTargetID > 0 && IsValidEntity(iTargetID))
					AcceptEntityInput(iTargetID, "Kill");

				g_iStashedInventoryAdrenaline[iClient]++;
				PrintToChat(iClient, "\x03[XPMod] \x05+1 Adrenaline. \x04You have %i more Adrenaline Shot%s.",
					g_iStashedInventoryAdrenaline[iClient],
					g_iStashedInventoryAdrenaline[iClient] != 1 ? "s" : "");
			}
		}
	}

	int iGrenadeSlotItemID = GetPlayerWeaponSlot(iClient, 2);

	if (g_iFireLevel[iClient] > 0 &&
		iGrenadeSlotItemID != iTargetID &&
		g_bGrenadeSlotWasEmptyOnLastPickUp[iClient] == false)
	{
		char strTargetClassName[35];
		GetEdictClassname(iTargetID, strTargetClassName, sizeof(strTargetClassName));

		if (StrContains(strTargetClassName,"weapon_molotov",false) != -1)
		{
			if (g_iStashedInventoryMolotov[iClient] < ELLIS_STASHED_INVENTORY_MAX_MOLOTOV)
			{
				if (iTargetID > 0 && IsValidEntity(iTargetID))
					AcceptEntityInput(iTargetID, "Kill");

				g_iStashedInventoryMolotov[iClient]++;
				PrintToChat(iClient, "\x03[XPMod] \x05+1 Molotov. \x04You have %i more Molotov%s.",
					g_iStashedInventoryMolotov[iClient],
					g_iStashedInventoryMolotov[iClient] != 1 ? "s" : "");
			}
		}
	}

	g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] = false;
	g_bGrenadeSlotWasEmptyOnLastPickUp[iClient] = false;
	
	// Weapon Cycling
	HandleWeaponPickUpForWeaponCycling(iClient);
}

void EventsWeaponGiven_Ellis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;

	// Check if the player has the ability, has stashed adrenaline, and also if the weapon given
	if (g_iJamminLevel[iClient] > 0 && g_iStashedInventoryAdrenaline[iClient] > 0)
		CreateTimer(0.1, TimerGiveAdrenalineFromStashedInventory, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

void HandleCheatCommandTasks_Ellis(int iClient, const char[] strCommandWithArgs)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;
	
	// This is for the event ItemPickUp to not recognize this as a player use press pick up
	if (StrEqual(strCommandWithArgs,"give pain_pills",false) == true ||
		StrEqual(strCommandWithArgs,"give adrenaline",false) == true)
		g_bHealthBoostItemJustGivenByCheats[iClient] = true;

	if (StrEqual(strCommandWithArgs,"give molotov",false) == true)
		g_bGrenadeItemJustGivenByCheats[iClient] = true;

	HandleWeaponPickUpForWeaponCycling(iClient);
}

void SetEllisClipSize(int iClient, const char[] currentweapon, int ActiveWeaponID, int CurrentClipAmmo, int iOffset_Ammo)
{
	if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || 
		((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
	{
		int iAmmo = GetEntData(iClient, iOffset_Ammo + 12);//for rifle (+12)
		if(iAmmo >=  (g_iFireLevel[iClient] * 10))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iFireLevel[iClient] * 10)), true);
			SetEntData(iClient, iOffset_Ammo + 12, iAmmo - (g_iFireLevel[iClient] * 10));
		}
		else if(iAmmo <  (g_iFireLevel[iClient] * 10))
		{
			int NewAmmo = ( (g_iFireLevel[iClient] * 10) - iAmmo);
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iFireLevel[iClient] * 10) - NewAmmo), true);
			SetEntData(iClient, iOffset_Ammo + 12, 0);
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
	else if(((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true)) && (CurrentClipAmmo == 50))
	{
		int iAmmo = GetEntData(iClient, iOffset_Ammo + 20);//for smg (+20)
		if(iAmmo >=  (g_iFireLevel[iClient] * 10))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iFireLevel[iClient] * 10)), true);
			SetEntData(iClient, iOffset_Ammo + 20, iAmmo - (g_iFireLevel[iClient] * 10));
		}
		else if(iAmmo <  (g_iFireLevel[iClient] * 10))
		{
			int NewAmmo = ( (g_iFireLevel[iClient] * 10) - iAmmo);
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ( (g_iFireLevel[iClient] * 10) - NewAmmo)), true);
			SetEntData(iClient, iOffset_Ammo + 20, 0);
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
	else if((StrEqual(currentweapon, "weapon_hunting_rifle", false) == true) && (CurrentClipAmmo == 15))
	{
		int iAmmo = GetEntData(iClient, iOffset_Ammo + 36);//for hunting rifle (+36)
		if(iAmmo >=  (g_iFireLevel[iClient] * 10))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo +  (g_iFireLevel[iClient] * 10)), true);
			SetEntData(iClient, iOffset_Ammo + 36, iAmmo - (g_iFireLevel[iClient] * 10));
		}
		else if(iAmmo <  (g_iFireLevel[iClient] * 10))
		{
			int NewAmmo = ( (g_iFireLevel[iClient] * 10) - iAmmo);
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ( (g_iFireLevel[iClient] * 10) - NewAmmo)), true);
			SetEntData(iClient, iOffset_Ammo + 36, 0);
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
	else if(
		((StrEqual(currentweapon, "weapon_sniper_awp", false) == true) && (CurrentClipAmmo == 20)) || 
		((StrEqual(currentweapon, "weapon_sniper_military", false) == true) && (CurrentClipAmmo == 30)) || 
		((StrEqual(currentweapon, "weapon_sniper_scout", false) == true) && (CurrentClipAmmo == 15)))
	{
		int iAmmo = GetEntData(iClient, iOffset_Ammo + 40);//for AWP, Scout, and Military Sniper (+40)
		if(iAmmo >=  (g_iFireLevel[iClient] * 10))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo +  (g_iFireLevel[iClient] * 10)), true);
			SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iFireLevel[iClient] * 10));
		}
		else if(iAmmo <  (g_iFireLevel[iClient] * 10))
		{
			int NewAmmo = ( (g_iFireLevel[iClient] * 10) - iAmmo);
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ( (g_iFireLevel[iClient] * 10) - NewAmmo)), true);
			SetEntData(iClient, iOffset_Ammo + 40, 0);
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
}

void CyclePlayerWeapon_Ellis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;

	if((g_iEllisCurrentPrimarySlot[iClient] == 0) && g_iEllisPrimarySlot1[iClient] > ITEM_EMPTY)
	{
		// Remove a laser upgrade counter to allow for infinite swapping
		if(g_iLaserUpgradeCounter[iClient] > 0)
			g_iLaserUpgradeCounter[iClient]--;

		// Kill their current weapon before giving new one
		if (g_iPrimarySlotID[iClient] > 0 && IsValidEntity(g_iPrimarySlotID[iClient]))
			AcceptEntityInput(g_iPrimarySlotID[iClient], "Kill");

		if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
		{
			g_bIsEllisWeaponCycling[iClient] = true;
			g_iEllisCurrentPrimarySlot[iClient] = 1;
			char strCommandWithArgs[64];
			Format(strCommandWithArgs, sizeof(strCommandWithArgs), "give %s", ITEM_CMD_NAME[g_iEllisPrimarySlot1[iClient]]);
			RunCheatCommand(iClient, "give", strCommandWithArgs);
		}
	}
	else if((g_iEllisCurrentPrimarySlot[iClient] == 1) && g_iEllisPrimarySlot0[iClient] > ITEM_EMPTY)
	{
		// Remove a laser upgrade counter to allow for infinite swapping
		if(g_iLaserUpgradeCounter[iClient] > 0)
			g_iLaserUpgradeCounter[iClient]--;

		// Kill their current weapon before giving new one
		if (g_iPrimarySlotID[iClient] > 0 && IsValidEntity(g_iPrimarySlotID[iClient]))
			AcceptEntityInput(g_iPrimarySlotID[iClient], "Kill");
		
		if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
		{
			g_bIsEllisWeaponCycling[iClient] = true;
			g_iEllisCurrentPrimarySlot[iClient] = 0;
			char strCommandWithArgs[64];
			Format(strCommandWithArgs, sizeof(strCommandWithArgs), "give %s", ITEM_CMD_NAME[g_iEllisPrimarySlot0[iClient]]);
			RunCheatCommand(iClient, "give", strCommandWithArgs);
		}
	}
}


// Note: This function is typically called when the user has already picked up their weapon, so its not possible
// To get the old weapon that was dropped unless storing it seomewhere else first.
void HandleWeaponPickUpForWeaponCycling(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;

	if(g_iWeaponsLevel[iClient] == 5)
	{

		int iWeaponIndex = FindWeaponItemIndexOfWeaponID(iClient);
		// This check is required if its a cmd name (if its given through cheats)
		if (iWeaponIndex <= ITEM_EMPTY || IsWeaponIndexPrimarySlotItem(iWeaponIndex) == false)
			return;



		if(g_bIsEllisWeaponCycling[iClient] == true)
		{
			StoreCurrentPrimaryWeapon(iClient);

			// On the next game frame, call the set the weapon ammo
			g_bSetWeaponAmmoOnNextGameFrame[iClient] = true;
			g_bIsEllisWeaponCycling[iClient] = false;
		}
		// Store the weapon item index
		else if (g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY && iWeaponIndex != g_iEllisPrimarySlot1[iClient])
		{
			g_iEllisCurrentPrimarySlot[iClient] = 0;
			StoreCurrentPrimaryWeapon(iClient);
			StoreCurrentPrimaryWeaponAmmo(iClient);
			
		}
		else if (g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY && iWeaponIndex != g_iEllisPrimarySlot0[iClient])
		{
			g_iEllisCurrentPrimarySlot[iClient] = 1;
			StoreCurrentPrimaryWeapon(iClient);
			StoreCurrentPrimaryWeaponAmmo(iClient);

		}
		// Handle when Ellis picks up the same weapon thats in the other slot
		else if(g_iEllisCurrentPrimarySlot[iClient] == 0 && iWeaponIndex == g_iEllisPrimarySlot1[iClient])
		{
			g_iEllisPrimarySlot1[iClient] = g_iEllisPrimarySlot0[iClient];
			g_iEllisPrimarySlot0[iClient] = iWeaponIndex;

			g_iEllisPrimarySavedClipSlot1[iClient] = g_iEllisPrimarySavedClipSlot0[iClient];
			g_iEllisPrimarySavedAmmoSlot1[iClient] = g_iEllisPrimarySavedAmmoSlot0[iClient];
		}
		// Handle when Ellis picks up the same weapon thats in the other slot
		else if(g_iEllisCurrentPrimarySlot[iClient] == 1 && iWeaponIndex == g_iEllisPrimarySlot0[iClient])
		{
			g_iEllisPrimarySlot0[iClient] = g_iEllisPrimarySlot1[iClient];
			g_iEllisPrimarySlot1[iClient] = iWeaponIndex;

			g_iEllisPrimarySavedClipSlot0[iClient] = g_iEllisPrimarySavedClipSlot1[iClient];
			g_iEllisPrimarySavedAmmoSlot0[iClient] = g_iEllisPrimarySavedAmmoSlot1[iClient];
		}
		else
		{
			// Store the current weapon
			StoreCurrentPrimaryWeapon(iClient);
			// Dont call save ammo here, it will overwrite with the newly picked up weapon
		}


	}
}

void HandleEllisSwitchToStashedPrimaryWeapon(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;

	// Check if Ellis can switch his weapon
	if (g_iWeaponsLevel[iClient] < 5 || 
		g_bCanEllisPrimaryCycle[iClient] == false)
		return;

	// Only continue if the appropriate buttons have been pressed
	int buttons;
	buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	if ( !(buttons & IN_SPEED) || !(buttons & IN_ZOOM) )
		return;

	// Only continue if the current weapon is a valid primary
	char currentweapon[512];
	GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));

	if ((StrContains(currentweapon,"shotgun",false) == -1) && 
		(StrContains(currentweapon,"rifle",false) == -1) &&
		(StrContains(currentweapon,"smg",false) == -1) &&
		(StrContains(currentweapon,"sniper",false) == -1) &&
		(StrContains(currentweapon,"launcher",false) == -1))
		return;

	
	// Check that they have a stashed at least one weapon
	if (g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY && 
		g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY)
		return;
	
	g_bCanEllisPrimaryCycle[iClient] = false;
	CreateTimer(0.5, TimerEllisPrimaryCycleReset, iClient, TIMER_FLAG_NO_MAPCHANGE);

	StoreCurrentPrimaryWeapon(iClient);
	StoreCurrentPrimaryWeaponAmmo(iClient);
	CyclePlayerWeapon(iClient);
}

void HandleEllisLimitBreak(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;

	// Check if they have the ability and havn't already toggled it
	if (g_bTalentsConfirmed[iClient] == false || 
		g_iMetalLevel[iClient] != 5)
		return;

	// Check if they have released the buttons after its been toggle already
	int buttons;
	buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	if(!(buttons & IN_SPEED) || !(buttons & IN_USE))
	{
		g_bWalkAndUseToggler[iClient] = false;
		return;
	}

	// Check if already toggled it
	if (g_bWalkAndUseToggler[iClient] == true)
		return;
	
	// Ensure they are pressing the buttons, exit otherwise
	if(((buttons & IN_SPEED) && (buttons & IN_USE)) == false)
		return;

	// Check if they are in cooldown
	if(g_bEllisLimitBreakInCooldown[iClient] == true)
	{
		PrintHintText(iClient, "LIMIT BREAK is still cooling down");
		return;
	}

	// Check that not already limit breaking, and that he can use limit break
	if(g_bIsEllisLimitBreaking[iClient] == true || g_bCanEllisLimitBreak[iClient] == false)
		return;
	
	// Get the currently active weapon index
	int iWeaponIndex = FindWeaponItemIndexOfWeaponID(iClient);

	// Check if they have a primary weapon
	if (IsWeaponIndexPrimarySlotItem(iWeaponIndex) == false)
		return;

	// At this point, they have toggled it and passed all checks. Do the limit break
	g_iLimitBreakWeaponIndex[iClient] = iWeaponIndex;
	g_bWalkAndUseToggler[iClient] = true;
	g_bIsEllisLimitBreaking[iClient] = true;
	g_bCanEllisLimitBreak[iClient] = false;
	CreateTimer(5.0, TimerEllisLimitBreakReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(65.0, TimerEllisLimitBreakCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
	PrintHintText(iClient, "Triple fire rate for 5 seconds; Your weapon will break afterward!");
}


void SetEllisHealthAfterUsingAdrenalineOrPills(int iClient, int iHealthBoostHealth)
{
	// The pills are capped at MAX Health by the game. To fix this, the temp health is stored
	// in OnPlayerRunCMD and is applied here if needed.
	if (g_iTempHealthBeforeUsingHealthBoostSlotItem[iClient] > 0)
	{
		int iNewTempHealth = g_iTempHealthBeforeUsingHealthBoostSlotItem[iClient] + iHealthBoostHealth >= ELLIS_MAX_TEMP_HEALTH ? 
			ELLIS_MAX_TEMP_HEALTH :
			g_iTempHealthBeforeUsingHealthBoostSlotItem[iClient] + iHealthBoostHealth;

		// First reset to put them at 0
		ResetTempHealthToSurvivor(iClient);
		// Then add the temp health back (cap it at the max setting, if beyond)
		AddTempHealthToSurvivor(iClient, 
			float(iNewTempHealth), 
			false);
		g_iTempHealthBeforeUsingHealthBoostSlotItem[iClient] = 0;
	}
}

void GiveEllisAnExtraMolotov(int iClient)
{
	if (RunClientChecks(iClient) == false)
		return;

	// Check the grenade slot to see if they currently have a grenade
	if (GetPlayerWeaponSlot(iClient, 2) > 0)
	{
		if (g_iEllisJamminGrenadeCounter[iClient] < ELLIS_STASHED_INVENTORY_MAX_TANK_SPAWN_ADRENALINE)
			g_iEllisJamminGrenadeCounter[iClient]++;
	}
	else
	{
		RunCheatCommand(iClient, "give", "give molotov");
	}
}

void GiveEllisAnExtraAdrenaline(int iClient)
{
	if (RunClientChecks(iClient) == false)
		return;

	// Check the boost slot to see if they currently have a adrenaline or pain pill
	if (GetPlayerWeaponSlot(iClient, 4) > 0)
	{
		if (g_iStashedInventoryAdrenaline[iClient] < ELLIS_STASHED_INVENTORY_MAX_TANK_SPAWN_ADRENALINE)
		{
			g_iStashedInventoryAdrenaline[iClient]++;
			PrintToChat(iClient, "\x03[XPMod] \x05+1 Adrenaline. \x04You have %i more Adrenaline Shot%s.",
				g_iStashedInventoryAdrenaline[iClient],
				g_iStashedInventoryAdrenaline[iClient] != 1 ? "s" : "");
		}
	}
	else
	{
		RunCheatCommand(iClient, "give", "give adrenaline");
	}
}

Action TimerDelayedGiveEllisAnExtraAdrenaline(Handle timer, int iClient)
{
	GiveEllisAnExtraAdrenaline(iClient);
	return Plugin_Stop;
}

void GiveEllisAnExtraMolotovForFireStorm(int iClient)
{
	if (RunClientChecks(iClient) == false)
		return;

	if (GetPlayerWeaponSlot(iClient, 2) > 0)
	{
		if (g_iStashedInventoryMolotov[iClient] < ELLIS_STASHED_INVENTORY_MAX_MOLOTOV)
		{
			g_iStashedInventoryMolotov[iClient]++;
			PrintToChat(iClient, "\x03[XPMod] \x05+1 Molotov. \x04You have %i more Molotov%s.",
				g_iStashedInventoryMolotov[iClient],
				g_iStashedInventoryMolotov[iClient] != 1 ? "s" : "");
		}
	}
	else
	{
		RunCheatCommand(iClient, "give", "give molotov");
	}
}

Action TimerDelayedGiveEllisAnExtraMolotovForFireStorm(Handle timer, int iClient)
{
	GiveEllisAnExtraMolotovForFireStorm(iClient);
	return Plugin_Stop;
}

void HandleEllisSelfRevive(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;

	if (g_iBringLevel[iClient] > 0)
		GiveEllisAnExtraAdrenaline(iClient);
}

void EllisDropMeleeWeaponsIfNecessary(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		g_iMetalLevel[iClient] <= 0 ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ELLIS ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;
	
	DropMeleeItem(iClient);
}
