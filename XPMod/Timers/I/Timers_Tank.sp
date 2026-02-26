Action Timer_AskWhatTankToUse(Handle timer, int iClient)
{
	if (g_iTankChosen[iClient] != TANK_NOT_CHOSEN ||
		RunClientChecks(iClient) == false || 
		g_iClientTeam[iClient] != TEAM_INFECTED ||
		IsPlayerAlive(iClient) == false || 
		GetEntProp(iClient, Prop_Send, "m_zombieClass") != TANK)
		return Plugin_Stop;

	// if its a bot, then handle this by automatically choosing a random tank
	if (IsFakeClient(iClient))
	{
		SetupTankForBot(iClient);
		return Plugin_Stop;
	}
	// If its a human player, then show them the selection menu
	else
	{
		ChooseTankMenuDraw(iClient);
		CreateTimer(5.0, Timer_AskWhatTankToUse, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
	
	return Plugin_Stop;
}

Action Timer_ReigniteFireTank(Handle timer, int iClient)
{
	if(iClient < 1 || g_iClientTeam[iClient] != TEAM_INFECTED || g_iTankChosen[iClient] != TANK_FIRE || IsValidEntity(iClient) == false || 
		IsClientInGame(iClient) == false || IsFakeClient(iClient) == true || IsPlayerAlive(iClient) == false)
		return Plugin_Stop;
		
	IgniteEntity(iClient, 10000.0, false);
	CreateTimer(10000.0, Timer_ReigniteFireTank, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

Action TimerExtinguishTank(Handle timer, int iClient)
{
	if(RunClientChecks(iClient) && IsPlayerAlive(iClient))
		ExtinguishEntity(iClient);

	g_hTimer_ExtinguishTank[iClient] = null;
	return Plugin_Stop;
}


Action Timer_UnblockFirePunchCharge(Handle timer, int iClient)
{
	g_bBlockTankFirePunchCharge[iClient] = false;

	return Plugin_Stop;
}

Action Timer_FireTankHPDrain(Handle timer, int iClient)
{
	if (RunClientChecks(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_INFECTED ||
		IsPlayerAlive(iClient) == false ||
		g_iTankChosen[iClient] != TANK_FIRE)
		return Plugin_Stop;

	int iCurrentHealth = GetPlayerHealth(iClient);
	if (iCurrentHealth <= FIRE_TANK_HP_DRAIN_PER_SECOND)
		return Plugin_Continue;

	SetPlayerHealth(iClient, -1, iCurrentHealth - FIRE_TANK_HP_DRAIN_PER_SECOND);
	return Plugin_Continue;
}

Action Timer_FireTankDashEnd(Handle timer, int iClient)
{
	g_bFireTankDashActive[iClient] = false;
	if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
		SetClientSpeed(iClient);

	return Plugin_Stop;
}

Action Timer_FireTankDashCooldownEnd(Handle timer, int iClient)
{
	g_bFireTankDashCoolingDown[iClient] = false;

	if (RunClientChecks(iClient) && IsPlayerAlive(iClient) && IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Fire Dash Ready");

	return Plugin_Stop;
}

Action Timer_DealFireDamage(Handle timer, Handle hDataPack)
{
	ResetPack(hDataPack);
	int iVictim = ReadPackCell(hDataPack);
	int iAttacker = ReadPackCell(hDataPack);
	
	if (RunClientChecks(iVictim) == false ||
		g_iClientTeam[iVictim] != TEAM_SURVIVORS ||
		IsPlayerAlive(iVictim) == false ||
		g_bGameFrozen == true)
	{
		CloseHandle(hDataPack);
		return Plugin_Stop;
	}
	
	if(g_iFireDamageCounter[iVictim]-- > 0)
	{
		DealDamage(iVictim, iAttacker, 1);
		return Plugin_Continue;
	}
	
	CloseHandle(hDataPack);
	return Plugin_Stop;
}

Action Timer_FreezePlayerByTank(Handle timer, int iClient)
{
	if(iClient < 1 || g_iClientTeam[iClient] != TEAM_SURVIVORS || g_bFrozenByTank[iClient] == true || 
		IsValidEntity(iClient) == false || 	IsClientInGame(iClient) == false || IsPlayerAlive(iClient) == false)
		return Plugin_Stop;
	
	g_bFrozenByTank[iClient] = true;
	
	//Play Ice Break Sound
	float vec[3];
	GetClientAbsOrigin(iClient, vec);
	EmitAmbientSound(SOUND_FREEZE, vec, iClient, SNDLEVEL_NORMAL);
	
	//Set Player Model Color
	SetEntityRenderMode(iClient, RenderMode:3);
	SetEntityRenderColor(iClient, 0, 180, 255, 255);
	
	//Set Movement Speed To Zero
	SetEntDataFloat(iClient, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.0, true);
	
	//Set Frozen Color Overlay On Victim
	ShowHudOverlayColor(iClient, 0, 180, 255, 128, 1200);
	
	return Plugin_Stop;
}

Action Timer_UnfreezePlayerByTank(Handle timer, int iClient)
{
	if(iClient < 1 || g_iClientTeam[iClient] != TEAM_SURVIVORS || g_bFrozenByTank[iClient] == false || IsValidEntity(iClient) == false || 
		IsClientInGame(iClient) == false || IsPlayerAlive(iClient) == false)
		return Plugin_Stop;
	
	//Set Player Velocity To Zero
	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, EMPTY_VECTOR);
	
	UnfreezePlayerByTank(iClient);
	
	return Plugin_Stop;
}

Action Timer_EnableIceTankColdSlowAura(Handle timer, int iClient)
{
	g_bIceTankColdAuraDisabled[iClient] = false;
	SetClientSpeed(iClient);

	g_hTimer_IceTankColdSlowAuraEnableAgain[iClient] = null;
	return Plugin_Stop;
}

bool GetCurrentIceTankColdAuraSlowSpeedReduction(int iSurvivor, float &fSpeedReduction)
{
	fSpeedReduction = 0.0;

	if (RunClientChecks(iSurvivor) == false ||
		g_iClientTeam[iSurvivor] != TEAM_SURVIVORS ||
		IsPlayerAlive(iSurvivor) == false)
		return false;

	float xyzSurvivorPosition[3];
	GetClientEyePosition(iSurvivor, xyzSurvivorPosition);

	float fBestSpeedReduction = 0.0;
	for (int iTank = 1; iTank <= MaxClients; iTank++)
	{
		if (RunClientChecks(iTank) == false ||
			g_iClientTeam[iTank] != TEAM_INFECTED ||
			IsPlayerAlive(iTank) == false ||
			GetEntProp(iTank, Prop_Send, "m_zombieClass") != TANK ||
			g_iTankChosen[iTank] != TANK_ICE ||
			g_bIceTankSliding[iTank] == true ||
			g_bIceTankSlideInCooldown[iTank] == true)
			continue;

		float xyzTankPosition[3];
		GetClientEyePosition(iTank, xyzTankPosition);
		float fDistance = GetVectorDistance(xyzSurvivorPosition, xyzTankPosition, false);
		if (fDistance >= TANK_ICE_COLD_SLOW_AURA_RADIUS)
			continue;

		float fSpeedReductionCalc = (1.0 - (fDistance / TANK_ICE_COLD_SLOW_AURA_RADIUS)) * TANK_ICE_COLD_SLOW_AURA_SPEED_REDUCE_AMOUNT;
		if (fSpeedReductionCalc > fBestSpeedReduction)
			fBestSpeedReduction = fSpeedReductionCalc;
	}

	if (fBestSpeedReduction <= 0.0)
		return false;

	fSpeedReduction = fBestSpeedReduction;
	return true;
}

Action Timer_UpdateIceTankColdSlowAuraVictimEffect(Handle timer, int iClient)
{
	if (RunClientChecks(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		IsPlayerAlive(iClient) == false ||
		g_bIceTankColdAuraDisabled[iClient] == true)
	{
		if (g_fIceTankColdAuraSlowSpeedReduction[iClient] > 0.0)
		{
			g_fIceTankColdAuraSlowSpeedReduction[iClient] = 0.0;
			SetClientSpeed(iClient);
		}

		StopIceTankColdSlowAuraVictimEffect(iClient);
		g_hTimer_IceTankColdSlowAuraEffectUpdate[iClient] = null;
		return Plugin_Stop;
	}

	float fCurrentSpeedReduction;
	if (GetCurrentIceTankColdAuraSlowSpeedReduction(iClient, fCurrentSpeedReduction) == false)
	{
		if (g_fIceTankColdAuraSlowSpeedReduction[iClient] > 0.0)
		{
			g_fIceTankColdAuraSlowSpeedReduction[iClient] = 0.0;
			SetClientSpeed(iClient);
		}

		StopIceTankColdSlowAuraVictimEffect(iClient);
		g_hTimer_IceTankColdSlowAuraEffectUpdate[iClient] = null;
		return Plugin_Stop;
	}

	if (FloatAbs(fCurrentSpeedReduction - g_fIceTankColdAuraSlowSpeedReduction[iClient]) > 0.01)
	{
		g_fIceTankColdAuraSlowSpeedReduction[iClient] = fCurrentSpeedReduction;
		SetClientSpeed(iClient);
	}

	StartIceTankColdSlowAuraVictimEffect(iClient);

	return Plugin_Continue;
}


Action Timer_UnblockTankFreezing(Handle timer, int iClient)
{
	g_bBlockTankFreezing[iClient] = false;
	
	return Plugin_Stop;
}

Action Timer_CreateSmallIceSphere(Handle timer, int iClient)
{
	if(iClient < 1 || g_bShowingIceSphere[iClient] == false || g_iClientTeam[iClient] != TEAM_INFECTED 
		|| IsValidEntity(iClient) == false || IsClientInGame(iClient) == false || IsPlayerAlive(iClient) == false)
	{		
		//Delete the particle effects for the Ice Sphere and set to -1 for next time
		DeleteParticleEntity(g_iPID_IceTankChargeMistAddon[iClient]);
		TurnOffAndDeleteSmokeStackParticle(g_iPID_IceTankChargeMistStock[iClient]);
		DeleteParticleEntity(g_iPID_IceTankChargeSnow[iClient]);
		g_iPID_IceTankChargeMistAddon[iClient] = -1;
		g_iPID_IceTankChargeMistStock[iClient] = -1;
		g_iPID_IceTankChargeSnow[iClient] = -1;
		

		//Unfreeze victim if they are frozen
		for (int iVictim = 1; iVictim <= MaxClients; iVictim++)
		{
			if(g_bFrozenByTank[iVictim] == false || g_iClientTeam[iVictim] != TEAM_SURVIVORS || IsClientInGame(iVictim) != true)
				continue;
			
			CreateTimer(4.0, Timer_UnfreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
		}
		
		g_hTimer_IceSphere[iClient] = null;
		return Plugin_Stop;
	}
	
	float xyzOrigin[3];
	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", xyzOrigin);
	CreateSphere(xyzOrigin, 250.0, 30, 10.0, {0, 30, 180, 20}, 1.0);
	
	return Plugin_Continue;
}
