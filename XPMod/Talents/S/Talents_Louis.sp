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

	if (g_iLouisTeleportChargeUses[iClient] <= g_iLouisTalent3Level[iClient] &&
		g_bLouisTeleportCoolingDown[iClient] == false && 
		iButtons & IN_SPEED && 
		(iButtons & IN_FORWARD || iButtons & IN_BACK || iButtons & IN_MOVELEFT || iButtons & IN_MOVERIGHT) &&
		(GetEntityFlags(iClient) & FL_ONGROUND))
	{
		// Check and update if bill is grappled or not
		fnc_CheckGrapple(iClient);
		
		if(g_bIsClientGrappled[iClient] == false && g_bIsClientDown[iClient] == false)
			LouisTeleport(iClient);
	}
	// Disable walk key
	if(iButtons & IN_SPEED)
	{
		iButtons &= ~IN_SPEED;
		return true;
	}

	return false;
}

OGFSurvivorReload_Louis(iClient, const char[] currentweapon, ActiveWeaponID, CurrentClipAmmo)
{
	if (g_iChosenSurvivor[iClient] != LOUIS || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_bTalentsConfirmed[iClient] == false ||
		RunClientChecks(iClient) == false ||
		IsFakeClient(iClient))
		return;

	if (g_iLouisTalent1Level[iClient] > 0)
	{
		PrintToChat(iClient, "LOUIS currentweapon: %s, CurrentClipAmmo: %i", currentweapon, CurrentClipAmmo);
		if (CurrentClipAmmo > 0 &&
			(StrContains(currentweapon, "weapon_smg", false) != -1 || StrEqual(currentweapon, "weapon_pistol", false) == true) )
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, CurrentClipAmmo + (g_iLouisTalent1Level[iClient] * 10), true);
			g_bClientIsReloading[iClient] = false;
			g_iReloadFrameCounter[iClient] = 0;
		}
	}	
}

EventsHurt_AttackerLouis(Handle:hEvent, iAttacker, iVictim)
{
	if (g_iChosenSurvivor[iAttacker] != LOUIS || 
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		g_bTalentsConfirmed[iAttacker] == false ||
		RunClientChecks(iAttacker) == false ||
		IsFakeClient(iAttacker))
		return;

	if (g_iLouisTalent2Level[iAttacker] <= 0)
	{
		decl String:weaponclass[32];
		GetEventString(hEvent,"weapon",weaponclass,32);
		PrintToChatAll("HURT \x03-class of gun: \x01%s",weaponclass);
		// Check for headshot and the SMGs or Pistols then give more damage
		if (GetEventBool(hEvent, "headshot") &&
			(StrContains(weaponclass,"SMG",false) != -1 || 
			StrContains(weaponclass,"SubMachine",false) != -1 || 
			StrContains(weaponclass,"CPistol",false) != -1))
		{
			new iVictimHealth = GetEntProp(iVictim, Prop_Data, "m_iHealth");
			new iDmgHealth  = GetEventInt(hEvent,"dmg_health");
			new iExtraDamage = RoundToNearest(float(iDmgHealth) * (g_iLouisTalent2Level[iAttacker] * 0.05));
			SetEntProp(iVictim, Prop_Data, "m_iHealth", iVictimHealth - iExtraDamage);
			PrintToChat(iAttacker, "You did %i extra damage", iExtraDamage);
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

	if (g_iLouisTalent2Level[iAttacker] > 0)
	{
		decl String:weaponclass[32];
		GetEventString(hEvent,"weapon",weaponclass,32);
		PrintToChatAll("DEATH \x03-class of gun: \x01%s",weaponclass);

		// Check for headshot and the SMGs or Pistols then give appropriate boosts
		if (GetEventBool(hEvent, "headshot") &&
			(StrContains(weaponclass,"SMG",false) != -1 || 
			StrContains(weaponclass,"SubMachine",false) != -1 || 
			StrContains(weaponclass,"CPistol",false) != -1))
		{
			// CI Headshot
			if (iVictim < 1)
			{
				PrintToChat(iAttacker, "LOUIS CI headshot kill");

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
					SetEntData(iActiveWeaponID, g_iOffset_Clip1, iCurrentClipAmmo + (g_iLouisTalent2Level[iAttacker] * 2), true);
				}
				
				// g_iCoachCIHeadshotCounter[iAttacker]++;
				// if(g_bCoachInCISpeed[iAttacker] == false)
				// {
				// 	g_bCoachInCISpeed[iAttacker] = true;
				// 	SetClientSpeed(iAttacker);
				// 	CreateTimer(5.0, TimerCoachCIHeadshotSpeedReset, iAttacker, TIMER_FLAG_NO_MAPCHANGE);
				// }
			}
			
			// SI Headshot
			if (iVictim > 0)
			{
				PrintToChat(iAttacker, "LOUIS SI headshot kill");

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
					SetEntData(iActiveWeaponID, g_iOffset_Clip1, iCurrentClipAmmo + (g_iLouisTalent2Level[iAttacker] * 5), true);
				}

				// if(g_iHomerunLevel[iAttacker] > 1 && g_bCoachInSISpeed[iAttacker] == false)
				// {
				// 	g_iCoachSIHeadshotCounter[iAttacker]++;
				// 	g_bCoachInSISpeed[iAttacker] = true;
				// 	SetClientSpeed(iAttacker);
				// 	CreateTimer(10.0, TimerCoachSIHeadshotSpeedReset, iAttacker, TIMER_FLAG_NO_MAPCHANGE);
				// }

				// if(g_bWreckingChargeRetrigger[iAttacker] == true)
				// 	CreateTimer(0.5, TimerWreckingChargeRetrigger, iAttacker, TIMER_FLAG_NO_MAPCHANGE);
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

LouisTeleport(iClient)
{
	g_bLouisTeleportCoolingDown[iClient] = true;
	CreateTimer(1.0, LouisTeleportReactivate, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	SetEntDataFloat(iClient, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), LOUIS_TELEPORT_MOVEMENT_SPEED, true);
	CreateTimer(0.3, TimerResetClientSpeed, iClient, TIMER_FLAG_NO_MAPCHANGE);
	EmitSoundToClient(iClient, SOUND_LOUIS_TELEPORT_USE);

	HandleLouisTeleportChargeUses(iClient);
	
	AttachParticle(iClient, "charger_motion_blur", 5.4, 0.0);
	//AttachParticle("hunter_motion_blur")

	// Create the blinding effect
	HandleLouisTeleportBlindingEffect(iClient);
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

	PrintToChat(iClient, "Blindness amount: %i", g_iLouisTeleportBlindnessAmount[iClient]);

	g_fLouisTeleportLastUseGameTime[iClient] = fCurrentGameTime;
	ShowHudOverlayColor(iClient, 40, 0, 5, g_iLouisTeleportBlindnessAmount[iClient], 3000, FADE_OUT);
}


PrintLouisTeleportCharges(iClient)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false || 
		IsFakeClient(iClient) == true)
		return;
	
	// Print the Wing Dash charges
	switch (6 - g_iLouisTeleportChargeUses[iClient])
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