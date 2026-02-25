void TalentsLoad_Louis(int iClient)
{
	g_bLouisTeleportCoolingDown[iClient] = false;
	g_iLouisTeleportChargeUses[iClient] = 0;
	g_iLouisTeleportMovementPenaltyStacks[iClient] = 0;

	SetPlayerTalentMaxHealth_Louis(iClient, !g_bSurvivorTalentsGivenThisRound[iClient]);
	SetClientSpeed(iClient);

	// Give starting XMR
	g_fLouisXMRWallet[iClient] = LOUIS_HEADSHOT_XMR_STARTING_AMOUNT;

	// Set Louis's default Laser mode
	g_bLouisLaserModeActivated[iClient] = true;
	g_bLouisLaserModeToggleCooldown[iClient] = false;

	// Add laser sight
	if (g_iLouisTalent2Level[iClient] > 0)
		RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");
	
	if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Disruptor Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilties will be automatically set as you level.");
}

void SetPlayerTalentMaxHealth_Louis(int iClient, bool bFillInHealthGap = true)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != LOUIS ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;

	SetPlayerMaxHealth(iClient,
		100 + 
		(g_iLouisTalent1Level[iClient] * 5) + 
		(g_iCoachTeamHealthStack * 5), 
		false, 
		bFillInHealthGap);
}


bool OnPlayerRunCmd_Louis(int iClient, int &iButtons)
{
	// Louis abilities
	if (g_iChosenSurvivor[iClient] != LOUIS || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS || 
		g_bGameFrozen == true)
		return false;

	if (g_iLouisTalent2Level[iClient] > 0 && 
		g_bLouisLaserModeToggleCooldown[iClient] == false &&
		iButtons & IN_DUCK && 
		iButtons & IN_USE)
	{
		// Handle toggling between laser mode on or off
		g_bLouisLaserModeActivated[iClient] = !g_bLouisLaserModeActivated[iClient];
		PrintToChat(iClient, "\x03[XPMod] \x05Laser Mode is now \x04%s\x05.", g_bLouisLaserModeActivated[iClient] ? "Enabled" : "Disabled");

		// Set the speed depending on the mode
		SetClientSpeed(iClient);

		// Add or remove laser sight depending on the mode
		if (g_bLouisLaserModeActivated[iClient])
			RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");
		else
			RunCheatCommand(iClient, "upgrade_remove", "upgrade_remove LASER_SIGHT");

		g_bLouisLaserModeToggleCooldown[iClient] = true;
		CreateTimer(LOUIS_LASER_MODE_TOGGLE_COOLDOWN, LouisLaserModeToggleReenable, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}

	// Handle Medkit Conversion to Pills
	if (g_iLouisTalent6Level[iClient] > 0 &&
		g_iStashedInventoryPills[iClient] < LOUIS_STASHED_INVENTORY_MAX_PILLS &&
		iButtons & IN_ZOOM &&
		!(iButtons & IN_ATTACK))
	{
		char strCurrentWeapon[32];
		GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
		if(StrContains(strCurrentWeapon, "first_aid_kit", false) != -1)
		{
			// Remove medkit
			int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (iActiveWeaponID > 0 && IsValidEntity(iActiveWeaponID))
			{
				AcceptEntityInput(iActiveWeaponID, "kill");

				// Convert into 3 pills
				// Check if they already have something equiped
				// Put the first one into their equipment if they dont have one
				if (GetPlayerWeaponSlot(iClient, 4) <= 0)
					RunCheatCommand(iClient, "give", "give pain_pills");
				else
					StashPillsForLouis(iClient);
				
				// Stash the rest
				StashPillsForLouis(iClient);
				StashPillsForLouis(iClient);				
			}
		}
	}

	// Louis Teleport
	if (g_iLouisTalent3Level[iClient] > 0 && 
		g_iLouisTeleportChargeUses[iClient] <= LOUIS_TELEPORT_TOTAL_CHARGES && //g_iLouisTalent3Level[iClient] &&
		g_bLouisTeleportCoolingDown[iClient] == false && 
		iButtons & IN_SPEED && 
		(iButtons & IN_FORWARD || iButtons & IN_BACK || iButtons & IN_MOVELEFT || iButtons & IN_MOVERIGHT) &&
		(GetEntityFlags(iClient) & FL_ONGROUND))
	{
		// Check and update if Louis is grappled or down first
		if(IsClientGrappled(iClient) == false && g_bIsClientDown[iClient] == false)
			LouisTeleport(iClient);
	}

	// Handle Pills Here Health give Health Reset Bug
	// Check the boost slot to see if they currently have a adrenaline or pain pill
	if (g_iLouisTalent5Level[iClient] > 0 &&
		iButtons & IN_ATTACK)
	{
		// Ensure they are holding the weapon in the health boost slot
		int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
		if (RunEntityChecks(iActiveWeaponID) && iActiveWeaponID == GetPlayerWeaponSlot(iClient, 4))
		{
			g_iTempHealthBeforeUsingHealthBoostSlotItem[iClient] = GetSurvivorTempHealth(iClient);
		}
	}

	// Disable walk key while teleporting
	if(g_bLouisTeleportActive[iClient] == true && iButtons & IN_SPEED)
	{
		iButtons &= ~IN_SPEED;
		return true;
	}

	return false;
}

bool IsLouisSMGWeaponClass(const char[] strWeaponClass)
{
	return StrEqual(strWeaponClass, "weapon_smg", false) ||
		StrEqual(strWeaponClass, "weapon_smg_silenced", false) ||
		StrEqual(strWeaponClass, "weapon_smg_mp5", false);
}

bool IsLouisPistolWeaponClass(const char[] strWeaponClass)
{
	return StrEqual(strWeaponClass, "weapon_pistol", false);
}

bool IsLouisEventWeaponSMG(const char[] strWeaponClass)
{
	return StrContains(strWeaponClass, "SMG", false) != -1 ||
		StrContains(strWeaponClass, "SubMachine", false) != -1;
}

bool IsLouisEventWeaponPistol(const char[] strWeaponClass)
{
	return StrEqual(strWeaponClass, "pistol", false) ||
		StrEqual(strWeaponClass, "dual_pistols", false);
}

int GetLouisTalent2ReserveAmmoBonus(int iClient)
{
	return g_iLouisTalent2Level[iClient] * 10;
}

int SpendLouisSMGReserveAmmoForClipBonus(int iClient, int iOffset_Ammo, int iRequestedBonus)
{
	int iReserveAmmo = GetEntData(iClient, iOffset_Ammo + 20);
	if (iReserveAmmo <= 0)
		return 0;

	int iGrantedBonus = iRequestedBonus > iReserveAmmo ? iReserveAmmo : iRequestedBonus;
	SetEntData(iClient, iOffset_Ammo + 20, iReserveAmmo - iGrantedBonus);

	return iGrantedBonus;
}

bool TryApplyLouisTalent2ReloadBonus(int iClient, const char[] strCurrentWeapon, int iActiveWeaponID, int iCurrentClipAmmo, int iOffset_Ammo)
{
	if (g_iLouisTalent2Level[iClient] <= 0 ||
		RunEntityChecks(iActiveWeaponID) == false)
		return false;

	int iBonusPerLevel = GetLouisTalent2ReserveAmmoBonus(iClient);

	if (iCurrentClipAmmo > 0 && IsLouisSMGWeaponClass(strCurrentWeapon))
	{
		int iGrantedBonus = SpendLouisSMGReserveAmmoForClipBonus(iClient, iOffset_Ammo, iBonusPerLevel);
		if (iGrantedBonus <= 0)
			return false;

		SetEntData(iActiveWeaponID, g_iOffset_Clip1, iCurrentClipAmmo + iGrantedBonus, true);
		return true;
	}

	if (IsLouisPistolWeaponClass(strCurrentWeapon) &&
		(iCurrentClipAmmo == 15 || iCurrentClipAmmo == 30))
	{
		int iPistolBonus = iCurrentClipAmmo == 15 ? iBonusPerLevel : iBonusPerLevel * 2;
		SetEntData(iActiveWeaponID, g_iOffset_Clip1, iCurrentClipAmmo + iPistolBonus, true);
		return true;
	}

	return false;
}

int GetLouisHeadshotRewardWeaponID(int iClient, const char[] strWeaponClass)
{
	int iWeaponID = -1;

	if (IsLouisEventWeaponPistol(strWeaponClass))
	{
		iWeaponID = GetPlayerWeaponSlot(iClient, 1);
		if (RunEntityChecks(iWeaponID) == false)
			return -1;

		char strEntityClass[32];
		GetEntityClassname(iWeaponID, strEntityClass, sizeof(strEntityClass));
		if (IsLouisPistolWeaponClass(strEntityClass) == false)
			return -1;

		return iWeaponID;
	}

	if (IsLouisEventWeaponSMG(strWeaponClass))
	{
		iWeaponID = GetPlayerWeaponSlot(iClient, 0);
		if (RunEntityChecks(iWeaponID) == false)
			return -1;

		char strEntityClass[32];
		GetEntityClassname(iWeaponID, strEntityClass, sizeof(strEntityClass));
		if (IsLouisSMGWeaponClass(strEntityClass) == false)
			return -1;

		return iWeaponID;
	}

	return -1;
}

void GiveLouisHeadshotClipBonus(int iClient, const char[] strWeaponClass, int iClipBonus)
{
	if (iClipBonus <= 0)
		return;

	int iWeaponID = GetLouisHeadshotRewardWeaponID(iClient, strWeaponClass);
	if (RunEntityChecks(iWeaponID) == false)
		return;

	int iCurrentClipAmmo = GetEntProp(iWeaponID, Prop_Data, "m_iClip1");
	int iNewClipAmmo = iCurrentClipAmmo + iClipBonus >= 250 ? 250 : iCurrentClipAmmo + iClipBonus;
	SetEntData(iWeaponID, g_iOffset_Clip1, iNewClipAmmo, true);
}

void OGFSurvivorReload_Louis(int iClient, const char[] currentweapon, int ActiveWeaponID, int CurrentClipAmmo, int iOffset_Ammo)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_bTalentsConfirmed[iClient] == false ||
		RunClientChecks(iClient) == false ||
		IsFakeClient(iClient))
		return;

	if (TryApplyLouisTalent2ReloadBonus(iClient, currentweapon, ActiveWeaponID, CurrentClipAmmo, iOffset_Ammo))
	{
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
}

void EventsHurt_AttackerLouis(Handle hEvent, int iAttacker, int iVictim)
{
	if (g_iChosenSurvivor[iAttacker] != LOUIS || 
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		g_iClientTeam[iVictim] == TEAM_SURVIVORS ||
		g_bTalentsConfirmed[iAttacker] == false ||
		RunClientChecks(iAttacker) == false ||
		IsFakeClient(iAttacker))
		return;

	if (g_iLouisTalent2Level[iAttacker] > 0 || g_iLouisTalent4Level[iAttacker] > 0)
	{
		char weaponclass[32];
		GetEventString(hEvent,"weapon",weaponclass,32);
		// Check for SMGs or Pistols then give more damage
		if (IsLouisEventWeaponSMG(weaponclass) ||
			IsLouisEventWeaponPistol(weaponclass))
		{
			int iVictimHealth = GetPlayerHealth(iVictim);

			// Store if its a headshot and pistol for use below
			bool bIsHeadshot = GetEventInt(hEvent, "hitgroup") == HITGROUP_HEAD;
			bool bIsPistol = StrEqual(weaponclass,"pistol",false) == true || StrEqual(weaponclass,"dual_pistols",false) == true;

			int iDmgHealth = GetEventInt(hEvent,"dmg_health");
			int iAddtionalDamageAmount = RoundToNearest(float(iDmgHealth) * 
				( (g_iLouisTalent2Level[iAttacker] * LOUIS_BONUS_DAMAGE_PER_LEVEL) + 	// Damage Buff
				  (bIsHeadshot ? 0.0 : (-1.0 * 											// Non-Headshot Penality
				  	(bIsPistol ? LOUIS_BODY_DAMAGE_REDUCTION_PER_LEVEL_PISTOL :			// Non-Headshot Pistol Penality
					g_iLouisTalent4Level[iAttacker] * (g_bLouisLaserModeActivated[iAttacker] ? LOUIS_BODY_DAMAGE_REDUCTION_PER_LEVEL_LASER : LOUIS_BODY_DAMAGE_REDUCTION_PER_LEVEL_NOLASER)))) + // Check if laser mode activated
				  (g_iPillsUsedStack[iAttacker] * g_iLouisTalent6Level[iAttacker] * LOUIS_PILLS_USED_BONUS_DAMAGE_PER_LEVEL) )); // Pills here buff dmg
			int iNewDamageAmount = iDmgHealth + iAddtionalDamageAmount;

			// Add even more damage if its a headshot
			if (bIsHeadshot)
			{
				iNewDamageAmount = iNewDamageAmount + (iNewDamageAmount * RoundToNearest(g_iLouisTalent4Level[iAttacker] * 
					(bIsPistol ? LOUIS_HEADSHOT_DMG_MULITPLIER_PER_LEVEL_PISTOL :	// Check if pistol
					g_bLouisLaserModeActivated[iAttacker] ?	LOUIS_HEADSHOT_DMG_MULITPLIER_PER_LEVEL_LASER : LOUIS_HEADSHOT_DMG_MULITPLIER_PER_LEVEL_NOLASER)));  // Check if laser mode activated
			}

			// Add or remove damage based on victim talents (Also subtract damage that will be already)
			iNewDamageAmount = CalculateDamageTakenForVictimTalents(iVictim, iNewDamageAmount, weaponclass) - CalculateDamageTakenForVictimTalents(iVictim, iDmgHealth, weaponclass);

			// Apply the new damage
			SetPlayerHealth(iVictim, iAttacker, iVictimHealth - iNewDamageAmount);


		}
	}
}


void EventsDeath_AttackerLouis(Handle hEvent, int iAttacker, int iVictim)
{
	if (g_iChosenSurvivor[iAttacker] != LOUIS ||
		g_bTalentsConfirmed[iAttacker] == false ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		RunClientChecks(iAttacker) == false ||
		IsFakeClient(iAttacker) == true)
		return;

	if (g_iLouisTalent4Level[iAttacker] > 0)
	{
		char weaponclass[32];
		GetEventString(hEvent,"weapon",weaponclass,32);

		// Check for headshot and the SMGs or Pistols then give appropriate boosts
		if (GetEventBool(hEvent, "headshot") &&
			(IsLouisEventWeaponSMG(weaponclass) ||
			IsLouisEventWeaponPistol(weaponclass)))
		{
			// CI Headshot
			if (iVictim < 1)
			{
				// Give health
				int iAttackerMaxHealth = GetPlayerMaxHealth(iAttacker);
				int iAttackerHealth = GetPlayerHealth(iAttacker);
				if (iAttackerHealth + 1 <= iAttackerMaxHealth)
					SetPlayerHealth(iAttacker, -1, iAttackerHealth + 1);

				// Increase clip ammo on the weapon that actually triggered the headshot
				GiveLouisHeadshotClipBonus(iAttacker, weaponclass, g_iLouisTalent4Level[iAttacker] * 3);
				
				g_iLouisCIHeadshotCounter[iAttacker]++;
				SetClientSpeed(iAttacker);
				CreateTimer(LOUIS_HEADSHOT_SPEED_RETENTION_TIME_CI, TimerLouisCIHeadshotReduce, iAttacker, TIMER_FLAG_NO_MAPCHANGE);

				// Give random item if chance rolled for the CI HS Kill
				if (GetRandomInt(1,100) <= LOUIS_NEUROSURGEON_CI_CHANCE)
				{
					// Get the actual CI entity
					int iCIVictim = GetEventInt(hEvent, "entityid");
					// Get the CI entity's location to spawn the item
					float xyzVictimLocation[3];
					GetEntPropVector(iCIVictim, Prop_Send, "m_vecOrigin", xyzVictimLocation);
					// Get a random item and spawn in the item on the CI entity
					int iItemIndex = ITEM_EMPTY;
					switch (GetRandomInt(0, 3))
					{
						case 0: iItemIndex = ITEM_PAIN_PILLS;
						case 1: iItemIndex = ITEM_ADRENALINE_SHOT;
						case 2: iItemIndex = ITEM_BILE_JAR;
						case 3: iItemIndex = ITEM_PIPE_BOMB;
					}
					int iItem = SpawnItem(xyzVictimLocation, iItemIndex, 50.0);
					// Attach particle effects to entity for awareness
					//AttachParticle(iItem, "item_defibrillator_body", 10.0);
					AttachParticle(iItem, "item_defibrillator_body_b", 2.0);
					//AttachParticle(iItem, "railroad_light_blink1", 10.0);
					//AttachParticle(iItem, "railroad_light_blink1b", 10.0);
					AttachParticle(iItem, "railroad_light_blink2", 10.0, 10.0);
					//AttachParticle(iItem, "railroad_light_blink2b", 10.0);
					// Play sound so its more apparent
					EmitSoundToClient(iAttacker, SOUND_HEADSHOT_REWARD);
					EmitSoundToClient(iAttacker, SOUND_HEADSHOT_REWARD);
				}

				// Give XMR
				g_fLouisXMRWallet[iAttacker] += LOUIS_HEADSHOT_XMR_AMOUNT_CI;
			}

			// SI Headshot
			if (iVictim > 0)
			{
				// Give health
				int iAttackerMaxHealth = GetPlayerMaxHealth(iAttacker);
				int iAttackerHealth = GetPlayerHealth(iAttacker);
				if (iAttackerHealth + 5 <= iAttackerMaxHealth)
					SetPlayerHealth(iAttacker, -1, iAttackerHealth + 5);

				// Increase clip ammo on the weapon that actually triggered the headshot
				GiveLouisHeadshotClipBonus(iAttacker, weaponclass, g_iLouisTalent4Level[iAttacker] * 10);

				g_iLouisSIHeadshotCounter[iAttacker]++;
				SetClientSpeed(iAttacker);
				CreateTimer(LOUIS_HEADSHOT_SPEED_RETENTION_TIME_SI, TimerLouisSIHeadshotReduce, iAttacker, TIMER_FLAG_NO_MAPCHANGE);

				// Give random item if chance rolled for the SI HS Kill
				if (GetRandomInt(1,100) <= LOUIS_NEUROSURGEON_SI_CHANCE)
				{
					// Get a random item
					switch (GetRandomInt(1, 2))
					{
						case 1:
						{
							// Give XMR Reward
							g_fLouisXMRWallet[iAttacker] += LOUIS_NEUROSURGEON_SI_XMR_REWARD_AMOUNT;
							PrintToChat(iAttacker, "\x03[XPMod] \x05You earned %0.1f XMR for your neurosurgery efforts!", LOUIS_NEUROSURGEON_SI_XMR_REWARD_AMOUNT);
						}
						case 2:
						{
							// Extra warez station
							g_iClientBindUses_1[iAttacker] -= 1;
							PrintToChat(iAttacker, "\x03[XPMod] \x05You earned an extra Warez Station for your neurosurgery efforts!");
						}
					}

					// Play sound so its more apparent
					EmitSoundToClient(iAttacker, SOUND_HEADSHOT_REWARD);
					EmitSoundToClient(iAttacker, SOUND_HEADSHOT_REWARD);
				}

				// Give XMR
				g_fLouisXMRWallet[iAttacker] += LOUIS_HEADSHOT_XMR_AMOUNT_SI;
			}
		}
	}
}

void EventsPillsUsed_Louis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS || 
		g_bTalentsConfirmed[iClient] == false)
		return;

	
	// Add to their pills used stack then reduce by 1 in 60 seconds
	// This controls the damage and speed of Louis
	if (g_iPillsUsedStack[iClient] < LOUIS_PILLS_USED_MAX_STACKS)
	{
		g_iPillsUsedStack[iClient]++;
		CreateTimer(LOUIS_PILLS_USED_BONUS_DURATION, TimerLouisPillsUsedStackReduce, iClient, TIMER_FLAG_NO_MAPCHANGE);
		PrintToChat(iClient, "\x03[XPMod] \x04Pills x%i", g_iPillsUsedStack[iClient]);
	}

	// Give extra speed (set by g_iPillsUsedStack)
	SetClientSpeed(iClient);

	// Take Temp Health away from player for Pills Here talent, only if its not going enough above max health already
	if (g_iLouisTalent5Level[iClient] > 0 &&
		(GetPlayerHealth(iClient) +
		g_iTempHealthBeforeUsingHealthBoostSlotItem[iClient] + 
		50 - // Pill health default setting
		(g_iLouisTalent5Level[iClient] * LOUIS_PILLS_USED_HEALTH_REDUCTION_PER_LEVEL) < 
		GetPlayerMaxHealth(iClient)))
	{
		int iCurrentTempHealth = GetSurvivorTempHealth(iClient);
		ResetTempHealthToSurvivor(iClient);
		AddTempHealthToSurvivor(iClient, float(iCurrentTempHealth - g_iLouisTalent5Level[iClient] * LOUIS_PILLS_USED_HEALTH_REDUCTION_PER_LEVEL));

		g_iTempHealthBeforeUsingHealthBoostSlotItem[iClient] = 0;
	}

	// Give stashed pills of they have more
	if (g_iStashedInventoryPills[iClient] > 0)
		CreateTimer(0.1, TimerGivePillsFromStashedInventory, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

void EventsAdrenalineUsed_Louis(int iClient)
{
	// Give stashed pills of they have more
	if (g_iStashedInventoryPills[iClient] > 0)
		CreateTimer(0.1, TimerGivePillsFromStashedInventory, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

void EventsItemPickUp_Louis(int iClient, const char[] strWeaponClass)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || g_bTalentsConfirmed[iClient] == false)
		return;


	if (g_iLouisTalent2Level[iClient] > 0)
	{
		int iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
		int iBonusPerLevel = GetLouisTalent2ReserveAmmoBonus(iClient);

		if (StrContains(strWeaponClass, "smg", false) != -1)
		{
			// Remove laser sights
			if (g_bLouisLaserModeActivated[iClient] == false)
				RunCheatCommand(iClient, "upgrade_remove", "upgrade_remove LASER_SIGHT");

			int iEntid = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if(iEntid  < 1 || IsValidEntity(iEntid) == false)
				return;

			int iCurrentClipAmmo = GetEntProp(iEntid,Prop_Data,"m_iClip1");
			int iGrantedBonus = SpendLouisSMGReserveAmmoForClipBonus(iClient, iOffset_Ammo, iBonusPerLevel);
			if (iGrantedBonus > 0)
			{
				SetEntData(iEntid, g_iOffset_Clip1, iCurrentClipAmmo + iGrantedBonus, true);
				g_iClientPrimaryClipSize[iClient] = iCurrentClipAmmo + iGrantedBonus;
			}
		}
		else if (StrEqual(strWeaponClass, "pistol", false) == true)
		{
			int iEntid = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if(iEntid  < 1 || IsValidEntity(iEntid) == false)
				return;
			
			int iCurrentClipAmmo = GetEntProp(iEntid,Prop_Data,"m_iClip1");
			SetEntData(iEntid, g_iOffset_Clip1, iCurrentClipAmmo + iBonusPerLevel, true);
		}
	}

	if (g_iLouisTalent6Level[iClient] > 0)
	{
		// Save that the health boost was empty on last pick up
		// This is for Louis's Pills here ability on Player Use event
		if (g_bHealthBoostItemJustGivenByCheats[iClient] == false && 
			(StrEqual(strWeaponClass, "pain_pills", false) == true || 
			StrEqual(strWeaponClass, "adrenaline", false) == true))
			g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] = true;

		g_bHealthBoostItemJustGivenByCheats[iClient] = false;
	}
}

void EventsReceiveUpgrade_Louis(int iClient, const char[] strUpgrade)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || g_bTalentsConfirmed[iClient] == false)
		return;

	if (g_iLouisTalent2Level[iClient] > 0 && g_bLouisLaserModeActivated[iClient] == false)
	{
		if (StrEqual(strUpgrade, "LASER_SIGHT", false) == true)
			RunCheatCommand(iClient, "upgrade_remove", "upgrade_remove LASER_SIGHT");
	}
}

void EventsPlayerUse_Louis(int iClient, int iTargetID)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || g_bTalentsConfirmed[iClient] == false)
		return;


	int iSlotItemID = GetPlayerWeaponSlot(iClient, 4);

	if (g_iLouisTalent2Level[iClient] > 0 && g_bLouisLaserModeActivated[iClient] == false)
	 	RunCheatCommand(iClient, "upgrade_remove", "upgrade_remove LASER_SIGHT");

	// Check if the item when into their weapon slot, if not, then continue to stash it.
	if (g_iLouisTalent6Level[iClient] > 0 && 
		iSlotItemID != iTargetID &&
		g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] == false)
	{
		char strTargetClassName[35];
		GetEdictClassname(iTargetID, strTargetClassName, sizeof(strTargetClassName));

		// Stash Louis's pills, and kill the target if successful
		if (StrContains(strTargetClassName,"weapon_pain_pills",false) != -1)
			if(StashPillsForLouis(iClient))
				if (iTargetID > 0 && IsValidEntity(iTargetID))
					AcceptEntityInput(iTargetID, "Kill");
	}

	g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] = false;
}

void EventsWeaponGiven_Louis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || g_bTalentsConfirmed[iClient] == false)
		return;

	// Check if the player has the ability, has stashed pills, and also if the weapon given
	if (g_iLouisTalent6Level[iClient] > 0 && g_iStashedInventoryPills[iClient] > 0)
		CreateTimer(0.1, TimerGivePillsFromStashedInventory, iClient, TIMER_FLAG_NO_MAPCHANGE);
}


void HandleCheatCommandTasks_Louis(int iClient, const char[] strCommandWithArgs)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || g_bTalentsConfirmed[iClient] == false)
		return;
	
	// This is for the event ItemPickUp to not recognize this as a player use press pick up
	if (StrEqual(strCommandWithArgs,"give pain_pills",false) == true ||
		StrEqual(strCommandWithArgs,"give adrenaline",false) == true)
		g_bHealthBoostItemJustGivenByCheats[iClient] = true;
}

bool StashPillsForLouis(int iClient)
{
	if (g_iStashedInventoryPills[iClient] >= LOUIS_STASHED_INVENTORY_MAX_PILLS)
		return false;

	g_iStashedInventoryPills[iClient]++;
	PrintToChat(iClient, "\x03[XPMod] \x05+1 Pills. \x04You have %i more Pill Bottle%s.",
		g_iStashedInventoryPills[iClient],
		g_iStashedInventoryPills[iClient] != 1 ? "s" : "");

	return true;
}
					

void LouisTeleport(int iClient)
{
	g_bLouisTeleportCoolingDown[iClient] = true;
	CreateTimer(1.0, LouisTeleportReenable, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	g_bLouisTeleportActive[iClient] = true;
	SetClientSpeed(iClient);
	//SetEntDataFloat(iClient, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), LOUIS_TELEPORT_MOVEMENT_SPEED, true);
	CreateTimer(0.3, TimerSetLouisTeleportInactive, iClient, TIMER_FLAG_NO_MAPCHANGE);
	EmitSoundToClient(iClient, SOUND_LOUIS_TELEPORT_USE);

	HandleLouisTeleportChargeUses(iClient);
	
	AttachParticle(iClient, "charger_motion_blur", 5.4, 0.0);
	//AttachParticle("hunter_motion_blur")

	// Create the blinding effect
	HandleLouisTeleportBlindingEffect(iClient);

	// Penalize movement speed for teleport usage
	HandleLouisTeleportMovementSpeedPenalty(iClient);
}

void HandleLouisTeleportChargeUses(int iClient)
{
	// Add a charge use
	g_iLouisTeleportChargeUses[iClient]++;
	PrintLouisTeleportCharges(iClient);

	// If they burned 5 charges, punish them with a longer cooldown
	if (g_iLouisTeleportChargeUses[iClient] == LOUIS_TELEPORT_TOTAL_CHARGES + 1) //g_iLouisTalent3Level[iClient] + 1)
	{
		delete g_hTimer_LouisTeleportRegenerate[iClient];
		CreateTimer(LOUIS_TELEPORT_CHARGE_MAXED_REGENERATE_TIME, TimerLouisTeleportChargeResetAll, iClient, TIMER_FLAG_NO_MAPCHANGE);

		EmitSoundToClient(iClient, SOUND_LOUIS_TELEPORT_OVERLOAD);
	}
	else
	{
		delete g_hTimer_LouisTeleportRegenerate[iClient];
		g_hTimer_LouisTeleportRegenerate[iClient] = CreateTimer(g_bLouisLaserModeActivated[iClient] ? LOUIS_TELEPORT_CHARGE_REGENERATE_TIME_LASER : LOUIS_TELEPORT_CHARGE_REGENERATE_TIME_NOLASER, TimerLouisTeleportChargeRegenerate, iClient, TIMER_REPEAT);
	}

}

void HandleLouisTeleportBlindingEffect(int iClient)
{
	float fCurrentGameTime = GetGameTime();
	// Subtract the fade amount they lost since last use
	if (g_iLouisTeleportBlindnessAmount[iClient] > 0 )
	{
		float fGameTimeSinceLastUse = fCurrentGameTime - g_fLouisTeleportLastUseGameTime[iClient];

		// if enough time has passed then just reset to 0
		if (fGameTimeSinceLastUse < 0.0 || fGameTimeSinceLastUse > LOUIS_TELEPORT_BLINDNESS_FADE_TIME)
			g_iLouisTeleportBlindnessAmount[iClient] = 0;
		else
		{
			g_iLouisTeleportBlindnessAmount[iClient] -= RoundToNearest( 
				(fGameTimeSinceLastUse / LOUIS_TELEPORT_BLINDNESS_FADE_TIME) * ( (g_iLouisTeleportBlindnessAmount[iClient] / LOUIS_TELEPORT_BLINDNESS_STAY_FACTOR) ) );
		}
			
	}

	// Add this use to the blindness amount
	g_iLouisTeleportBlindnessAmount[iClient] += LOUIS_TELEPORT_BLINDNESS_ADDITIVE_AMOUNT;
	// Clamp it
	if (g_iLouisTeleportBlindnessAmount[iClient] > 255)
		g_iLouisTeleportBlindnessAmount[iClient] = 255;


	g_fLouisTeleportLastUseGameTime[iClient] = fCurrentGameTime;
	ShowHudOverlayColor(iClient, 40, 0, 5, g_iLouisTeleportBlindnessAmount[iClient], LOUIS_TELEPORT_BLINDNESS_DURATION, FADE_OUT);
}

void HandleLouisTeleportMovementSpeedPenalty(int iClient)
{
	g_iLouisTeleportMovementPenaltyStacks[iClient]++;

	CreateTimer(LOUIS_TELEPORT_MOVEMENT_PENALTY_TIME, TimerLouisTeleportRemoveMovementSpeedPenalty, iClient, TIMER_FLAG_NO_MAPCHANGE);
}


void PrintLouisTeleportCharges(int iClient)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false || 
		IsFakeClient(iClient) == true ||
		IsClientGrappled(iClient) ||
		IsIncap(iClient) == true)
		return;
	
	// Print the Louis Teleport charges
	// switch (g_iLouisTalent3Level[iClient] + 1 - g_iLouisTeleportChargeUses[iClient])
	switch (LOUIS_TELEPORT_TOTAL_CHARGES + 1 - g_iLouisTeleportChargeUses[iClient])
	{
		case 0: PrintHintText(iClient, "( XxX.xX.xX..xXX.X..Xxx.xX..XxxX..xX.XXx.xx.X.Xxx..xX )");

		case 1: PrintHintText(iClient, "( ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ )");

		case 2: PrintHintText(iClient, "( ▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░ )");

		case 3: PrintHintText(iClient, "( ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░ )");

		case 4: PrintHintText(iClient, "( ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ )");
	}
}
