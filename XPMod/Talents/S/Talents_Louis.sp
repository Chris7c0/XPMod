TalentsLoad_Louis(iClient)
{
	g_bLouisTeleportCoolingDown[iClient] = false;
	g_iLouisTeleportChargeUses[iClient] = 0;

	if(g_iLouisTalent1Level[iClient] > 0)
	{
		new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
		new maxHP = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
		
		SetEntProp(iClient, Prop_Data, "m_iMaxHealth", maxHP + (g_iLouisTalent1Level[iClient] * 10));
		SetEntProp(iClient, Prop_Data, "m_iHealth", currentHP + (g_iLouisTalent1Level[iClient] * 10));

		SetClientSpeed(iClient);
	}
	
	if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Disruptor Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilties will be automatically set as you level.");
}


// OnGameFrame_Louis(iClient)
// {
	
// }

bool OnPlayerRunCmd_Louis(iClient, &iButtons)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || 
		g_iLouisTalent3Level[iClient] <= 0 ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS || 
		g_bGameFrozen == true)
		return false;

	// Handle Medkit Conversion to Pills
	if (g_iLouisTalent6Level[iClient] > 0 && iButtons & IN_ZOOM)
	{
		char strCurrentWeapon[32];
		GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
		if(StrContains(strCurrentWeapon, "first_aid_kit", false) != -1)
		{
			// Remove medkit
			int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (IsValidEntity(iActiveWeaponID))
			{
				AcceptEntityInput(iActiveWeaponID, "kill");

				// Give 3 pills
				RunCheatCommand(iClient, "give", "give pain_pills");
				RunCheatCommand(iClient, "give", "give pain_pills");
				RunCheatCommand(iClient, "give", "give pain_pills");

				PrintToChat(iClient, "\x03[XPMod] \x05MedKit turned into 3 Pill Bottles.")
			}
		}
	}

	// Louis Teleport
	if (g_iLouisTeleportChargeUses[iClient] <= g_iLouisTalent3Level[iClient] &&
		g_bLouisTeleportCoolingDown[iClient] == false && 
		iButtons & IN_SPEED && 
		(iButtons & IN_FORWARD || iButtons & IN_BACK || iButtons & IN_MOVELEFT || iButtons & IN_MOVERIGHT) &&
		(GetEntityFlags(iClient) & FL_ONGROUND))
	{
		// Check and update if Louis is grappled or down first
		if(IsClientGrappled(iClient) == false && g_bIsClientDown[iClient] == false)
			LouisTeleport(iClient);
	}

	// Disable walk key while teleporting
	if(g_bLouisTeleportActive[iClient] == true && iButtons & IN_SPEED)
	{
		iButtons &= ~IN_SPEED;
		return true;
	}

	return false;
}

OGFSurvivorReload_Louis(iClient, const char[] currentweapon, ActiveWeaponID, CurrentClipAmmo, int iOffset_Ammo)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_bTalentsConfirmed[iClient] == false ||
		RunClientChecks(iClient) == false ||
		IsFakeClient(iClient))
		return;

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

EventsHurt_AttackerLouis(Handle:hEvent, iAttacker, iVictim)
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
		decl String:weaponclass[32];
		GetEventString(hEvent,"weapon",weaponclass,32);
		//PrintToChatAll("HURT \x03-class of gun: \x01%s, hitgroup: %i, dmg = %i",weaponclass, GetEventInt(hEvent, "hitgroup"), GetEventInt(hEvent,"dmg_health"));
		// Check for SMGs or Pistols then give more damage
		if (StrContains(weaponclass,"SMG",false) != -1 || 
			StrContains(weaponclass,"SubMachine",false) != -1 || 
			StrEqual(weaponclass,"pistol",false) == true ||
			StrEqual(weaponclass,"dual_pistols",false) == true)
		{
			new iVictimHealth = GetEntProp(iVictim,Prop_Data,"m_iHealth");
			// PrintToChatAll("Louis iVictim %N START HP: %i", iVictim, iVictimHealth);

			new iDmgHealth  = GetEventInt(hEvent,"dmg_health");
			new iAddtionalDamageAmount = RoundToNearest(float(iDmgHealth) * 
				( (g_iLouisTalent2Level[iAttacker] * 0.15) + 
				  (g_iPillsUsedStack[iAttacker] * g_iLouisTalent6Level[iAttacker] * 0.03) ));
			new iNewDamageAmount = iDmgHealth + iAddtionalDamageAmount;

			// Add even more damage if its a headshot
			if (GetEventInt(hEvent, "hitgroup") == HITGROUP_HEAD)
				iNewDamageAmount = iNewDamageAmount + (iNewDamageAmount * RoundToNearest(g_iLouisTalent4Level[iAttacker] * 0.40));

			// Add or remove damage based on victim talents (Also subtract damage that will be already)
			iNewDamageAmount = CalculateDamageTakenForVictimTalents(iVictim, iNewDamageAmount, weaponclass) - CalculateDamageTakenForVictimTalents(iVictim, iDmgHealth, weaponclass);

			// Apply the new damage
			SetEntProp(iVictim, Prop_Data, "m_iHealth", iVictimHealth - iNewDamageAmount);

			// PrintToChat(iAttacker, "\x03Original Dmg: %i, New Add Dmg: %i ", iDmgHealth, iNewDamageAmount);

			// new iVictimHealth2 = GetEntProp(iVictim,Prop_Data,"m_iHealth");
			// PrintToChatAll("Louis iVictim %N END HP: %i", iVictim, iVictimHealth2);
		}
	}
}

// EventsHurt_VictimLouis(Handle:hEvent, iAttacker, iVictim)
// {
// 	if (IsFakeClient(iVictim))
// 		return;
// }

EventsDeath_AttackerLouis(Handle:hEvent, iAttacker, iVictim)
{
	if (g_iChosenSurvivor[iAttacker] != LOUIS ||
		g_bTalentsConfirmed[iAttacker] == false ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		RunClientChecks(iAttacker) == false ||
		IsFakeClient(iAttacker) == true)
		return;

	if (g_iLouisTalent4Level[iAttacker] > 0)
	{
		decl String:weaponclass[32];
		GetEventString(hEvent,"weapon",weaponclass,32);
		// PrintToChatAll("DEATH \x03-class of gun: \x01%s",weaponclass);

		// Check for headshot and the SMGs or Pistols then give appropriate boosts
		if (GetEventBool(hEvent, "headshot") &&
			(StrContains(weaponclass,"SMG",false) != -1 || 
			StrContains(weaponclass,"SubMachine",false) != -1 || 
			StrEqual(weaponclass,"pistol",false) == true ||
			StrEqual(weaponclass,"dual_pistols",false) == true))
		{
			// CI Headshot
			if (iVictim < 1)
			{
				// Give health
				new iAttackerMaxHealth = GetEntProp(iAttacker, Prop_Data, "m_iMaxHealth");
				new iAttackerHealth = GetEntProp(iAttacker, Prop_Data, "m_iHealth");
				if (iAttackerHealth + 1 <= iAttackerMaxHealth)
					SetEntProp(iAttacker, Prop_Data, "m_iHealth", iAttackerHealth + 1);

				// Increase Clip Ammo
				new iActiveWeaponID = GetEntDataEnt2(iAttacker, g_iOffset_ActiveWeapon);
				new iCurrentClipAmmo = 0;
				if (IsValidEntity(iActiveWeaponID))
				{
					iCurrentClipAmmo = GetEntProp(iActiveWeaponID, Prop_Data, "m_iClip1");
					SetEntData(iActiveWeaponID, g_iOffset_Clip1, iCurrentClipAmmo + (g_iLouisTalent4Level[iAttacker] * 5), true);
				}
				
				g_iLouisCIHeadshotCounter[iAttacker]++;
				SetClientSpeed(iAttacker);
				CreateTimer(LOUIS_HEADSHOT_SPEED_RETENTION_TIME_CI, TimerLouisCIHeadshotReduce, iAttacker, TIMER_FLAG_NO_MAPCHANGE);

				// Give XMR
				g_fLouisXMRWallet[iAttacker] += LOUIS_HEADSHOT_XMR_AMOUNT_CI;
			}
			
			// SI Headshot
			if (iVictim > 0)
			{
				// Give health
				new iAttackerMaxHealth = GetEntProp(iAttacker, Prop_Data, "m_iMaxHealth");
				new iAttackerHealth = GetEntProp(iAttacker, Prop_Data, "m_iHealth");
				if (iAttackerHealth + 5 <= iAttackerMaxHealth)
					SetEntProp(iAttacker, Prop_Data, "m_iHealth", iAttackerHealth + 5);

				// Increase Clip Ammo
				new iActiveWeaponID = GetEntDataEnt2(iAttacker, g_iOffset_ActiveWeapon);
				new iCurrentClipAmmo = 0;
				if (IsValidEntity(iActiveWeaponID))
				{
					iCurrentClipAmmo = GetEntProp(iActiveWeaponID,Prop_Data,"m_iClip1");
					SetEntData(iActiveWeaponID, g_iOffset_Clip1, iCurrentClipAmmo + (g_iLouisTalent4Level[iAttacker] * 15), true);
				}

				g_iLouisSIHeadshotCounter[iAttacker]++;
				SetClientSpeed(iAttacker);
				CreateTimer(LOUIS_HEADSHOT_SPEED_RETENTION_TIME_SI, TimerLouisSIHeadshotReduce, iAttacker, TIMER_FLAG_NO_MAPCHANGE);

				// Give XMR
				g_fLouisXMRWallet[iAttacker] += LOUIS_HEADSHOT_XMR_AMOUNT_SI;
			}
		}
	}
}

// EventsDeath_VictimLouis(Handle:hEvent, iAttacker, iVictim)
// {
// 	if (g_iClientTeam[iVictim] != TEAM_SURVIVORS)
// 		return;
// 	SuppressNeverUsedWarning(hEvent, iAttacker);
// }

void EventsPillsUsed_Louis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || g_bTalentsConfirmed[iClient] == false)
		return;

	// PrintToChat(iClient, "Pills Used: %i", GetPlayerWeaponSlot(iClient, 4));
	
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

	// Give extra temp health
	AddTempHealthToSurvivor(iClient, float(g_iLouisTalent6Level[iClient] * 5));

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

	//PrintToChat(iClient, "LOUIS ITEM PICKUP %s", strWeaponClass);

	if (g_iLouisTalent2Level[iClient] > 0)
	{
		new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");

		if (StrContains(strWeaponClass, "smg", false) != -1)
		{
			new iEntid = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if(iEntid  < 1 || IsValidEntity(iEntid) == false)
				return;
			
			new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
			SetEntData(iClient, iOffset_Ammo + 20, iAmmo - (g_iLouisTalent2Level[iClient] * 10));
			
			new iCurrentClipAmmo = GetEntProp(iEntid,Prop_Data,"m_iClip1");
			SetEntData(iEntid, g_iOffset_Clip1, iCurrentClipAmmo + (g_iLouisTalent2Level[iClient] * 10), true);
			g_iClientPrimaryClipSize[iClient] = iCurrentClipAmmo + (g_iLouisTalent2Level[iClient] * 10);
		}
		else if (StrEqual(strWeaponClass, "pistol", false) == true)
		{
			new iEntid = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if(iEntid  < 1 || IsValidEntity(iEntid) == false)
				return;
			
			new iCurrentClipAmmo = GetEntProp(iEntid,Prop_Data,"m_iClip1");
			SetEntData(iEntid, g_iOffset_Clip1, iCurrentClipAmmo + (g_iLouisTalent2Level[iClient] * 10), true);
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

void EventsPlayerUse_Louis(int iClient, int iTargetID)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || g_bTalentsConfirmed[iClient] == false)
		return;

	// PrintToChat(iClient, "iTargetID: %i", iTargetID);
	// PrintToChat(iClient, "Pills Slot: %i", GetPlayerWeaponSlot(iClient, 4));

	int iSlotItemID = GetPlayerWeaponSlot(iClient, 4);
	// char strSlotItemClassName[35];
	// if (IsValidEntity(iSlotItemID))
	// 	GetEdictClassname(iSlotItemID, strSlotItemClassName, sizeof(strSlotItemClassName));
	// else
	// 	strSlotItemClassName = NULL_STRING;
	// PrintToChat(iClient, "strSlotItemClassName: %s" , strSlotItemClassName);

	// Check if the item when into their weapon slot, if not, then continue to stash it.
	if (g_iLouisTalent6Level[iClient] > 0 && 
		iSlotItemID != iTargetID &&
		g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] == false)
	{
		char strTargetClassName[35];
		GetEdictClassname(iTargetID, strTargetClassName, sizeof(strTargetClassName));
		// PrintToChat(iClient, "strTargetClassName: %s" , strTargetClassName);

		if (StrContains(strTargetClassName,"weapon_pain_pills",false) != -1)
		{
			if (g_iStashedInventoryPills[iClient] < LOUIS_STASHED_INVENTORY_MAX_PILLS)
			{
				AcceptEntityInput(iTargetID, "Kill");

				g_iStashedInventoryPills[iClient]++;
				PrintToChat(iClient, "\x03[XPMod] \x05+1 Pills. \x04You have %i more Pill Bottle%s.",
					g_iStashedInventoryPills[iClient],
					g_iStashedInventoryPills[iClient] != 1 ? "s" : "");
			}
		}
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


void HandleCheatCommandTasks_Louis(int iClient, const char [] strCommandWithArgs)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || g_bTalentsConfirmed[iClient] == false)
		return;
	
	// This is for the event ItemPickUp to not recognize this as a player use press pick up
	if (StrEqual(strCommandWithArgs,"give pain_pills",false) == true ||
		StrEqual(strCommandWithArgs,"give adrenaline",false) == true)
		g_bHealthBoostItemJustGivenByCheats[iClient] = true;
}

LouisTeleport(iClient)
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

HandleLouisTeleportChargeUses(iClient)
{
	// Add a charge use
	g_iLouisTeleportChargeUses[iClient]++;
	PrintLouisTeleportCharges(iClient);

	// If they burned 5 charges, punish them with a longer cooldown
	if (g_iLouisTeleportChargeUses[iClient] == g_iLouisTalent3Level[iClient] + 1)
	{
		delete g_hTimer_LouisTeleportRegenerate[iClient];
		CreateTimer(LOUIS_TELEPORT_CHARGE_MAXED_REGENERATE_TIME, TimerLouisTeleportChargeResetAll, iClient, TIMER_FLAG_NO_MAPCHANGE);

		EmitSoundToClient(iClient, SOUND_LOUIS_TELEPORT_OVERLOAD);
		//EmitSoundToAll(SOUND_LOUIS_TELEPORT_OVERLOAD, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, pos, NULL_VECTOR, true, 0.0);
	}
	else
	{
		delete g_hTimer_LouisTeleportRegenerate[iClient];
		g_hTimer_LouisTeleportRegenerate[iClient] = CreateTimer(LOUIS_TELEPORT_CHARGE_REGENERATE_TIME, TimerLouisTeleportChargeRegenerate, iClient, TIMER_REPEAT);
	}

}



HandleLouisTeleportBlindingEffect(iClient)
{
	new Float:fCurrentGameTime = GetGameTime();
	// Subtract the fade amount they lost since last use
	if (g_iLouisTeleportBlindnessAmount[iClient] > 0 )
	{
		new Float:fGameTimeSinceLastUse = fCurrentGameTime - g_fLouisTeleportLastUseGameTime[iClient];

		// if enough time has passed then just reset to 0
		if (fGameTimeSinceLastUse < 0.0 || fGameTimeSinceLastUse > LOUIS_TELEPORT_BLINDNESS_FADE_TIME)
			g_iLouisTeleportBlindnessAmount[iClient] = 0;
		else
		{
			//PrintToChat(iClient, "normalized time since use: %f", fGameTimeSinceLastUse / LOUIS_TELEPORT_BLINDNESS_FADE_TIME);
			g_iLouisTeleportBlindnessAmount[iClient] -= RoundToNearest( 
				(fGameTimeSinceLastUse / LOUIS_TELEPORT_BLINDNESS_FADE_TIME) * ( (g_iLouisTeleportBlindnessAmount[iClient] / LOUIS_TELEPORT_BLINDNESS_STAY_FACTOR) ) );
		}
			
	}

	// Add this use to the blindness amount
	g_iLouisTeleportBlindnessAmount[iClient] += LOUIS_TELEPORT_BLINDNESS_ADDITIVE_AMOUNT;
	// Clamp it
	if (g_iLouisTeleportBlindnessAmount[iClient] > 255)
		g_iLouisTeleportBlindnessAmount[iClient] = 255;

	//PrintToChat(iClient, "Blindness amount: %i", g_iLouisTeleportBlindnessAmount[iClient]);

	g_fLouisTeleportLastUseGameTime[iClient] = fCurrentGameTime;
	ShowHudOverlayColor(iClient, 40, 0, 5, g_iLouisTeleportBlindnessAmount[iClient], 3000, FADE_OUT);
}

HandleLouisTeleportMovementSpeedPenalty(iClient)
{
	g_iLouisTeleportMovementPenaltyStacks[iClient]++;

	CreateTimer(LOUIS_TELEPORT_MOVEMENT_PENALTY_TIME, TimerLouisTeleportRemoveMovementSpeedPenalty, iClient, TIMER_FLAG_NO_MAPCHANGE);
}


PrintLouisTeleportCharges(iClient)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false || 
		IsFakeClient(iClient) == true ||
		IsClientGrappled(iClient) ||
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1)
		return;
	
	// Print the Louis Teleport charges
	switch (g_iLouisTalent3Level[iClient] + 1 - g_iLouisTeleportChargeUses[iClient])
	{
		case 0: PrintHintText(iClient, "( XxX.xX.xX..xXX.X..Xxx.xX..XxxX..xX.XXx.xx.X.Xxx..xX )");

		case 1: PrintHintText(iClient, "( ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ )");

		case 2: PrintHintText(iClient, "( ▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░ )");

		case 3: PrintHintText(iClient, "( ▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░ )");

		case 4: PrintHintText(iClient, "( ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░ )");

		case 5: PrintHintText(iClient, "( ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░ )");

		case 6: PrintHintText(iClient, "( ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ )");
	}
}