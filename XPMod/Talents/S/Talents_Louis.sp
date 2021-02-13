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

// OGFSurvivorReload_Louis(iClient, const char[] currentweapon, ActiveWeaponID, CurrentClipAmmo)
// {
// 	// if((StrEqual(currentweapon, "weapon_pistol_magnum", false) == true) && (g_iMagnumLevel[iClient] > 0) && (CurrentClipAmmo == 8))
// 	// {
// 	// 	SetEntData(ActiveWeaponID, g_iOffset_Clip1, 3, true);
// 	// 	g_bClientIsReloading[iClient] = false;
// 	// 	g_iReloadFrameCounter[iClient] = 0;
// 	// 	//PrintToChatAll("Setting Magnum Clip");
// 	// }
// 	// else if((StrEqual(currentweapon, "weapon_pistol", false) == true) && (g_iRiskyLevel[iClient] > 0) && ((CurrentClipAmmo == 15) || (CurrentClipAmmo == 30)))
// 	// {
// 	// 	if(CurrentClipAmmo == 15)
// 	// 	{
// 	// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iRiskyLevel[iClient] * 6)), true);
// 	// 	}
// 	// 	else if(CurrentClipAmmo == 30)
// 	// 	{
// 	// 		SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iRiskyLevel[iClient] * 12)), true);
// 	// 	}
// 	// 	g_bClientIsReloading[iClient] = false;
// 	// 	g_iReloadFrameCounter[iClient] = 0;
// 	// }
// }

// EventsHurt_AttackerLouis(Handle:hEvent, iAttacker, iVictim)
// {
	
// }

// EventsHurt_VictimNick(Handle:hEvent, iAttacker, iVictim)
// {
// 	if (IsFakeClient(iVictim))
// 		return;
// }

// EventsDeath_AttackerNick(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

// EventsDeath_VictimLouis(Handle:hEvent, iAttacker, iVictim)
// {
// 	if (g_iClientTeam[iVictim] != TEAM_SURVIVORS)
// 		return;

// 	SuppressNeverUsedWarning(hEvent, iAttacker);
	
// 	// Nick's DesperateMeasuresStack
// 	if(g_bWasClientDownOnDeath[iVictim] == true)
// 		g_bWasClientDownOnDeath[iVictim] = false;
// 	else
// 	{
// 		g_iNickDesperateMeasuresStack++;

// 		for(int i=1; i <= MaxClients; i++)
// 		{
// 			if (RunClientChecks(i) && 
// 				g_iClientTeam[i]==TEAM_SURVIVORS && 
// 				IsPlayerAlive(i) == true)
// 			{
// 				if(g_iNickDesperateMeasuresStack <= 3)
// 				{
// 					SetClientSpeed(i);
// 					PrintHintText(i, "A teammate has died, your senses sharpen.");
// 				}
// 			}
// 		}
// 	}
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