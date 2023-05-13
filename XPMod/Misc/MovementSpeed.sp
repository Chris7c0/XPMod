// Calculate player movement speed given all values
SetClientSpeed(iClient)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false ||
		g_bGameFrozen == true)
		return;

	new Float:fSpeed = 1.0;

	// Interrupt speed abilities
	if (SetClientSpeedOverrides(iClient, fSpeed))
	{
		SetEntDataFloat(iClient, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), fSpeed, true);
		// if (IsFakeClient(iClient) == false)
		// 	PrintToChat(iClient, "SetClientSpeedOverride: %N: %f", iClient, fSpeed);
		// PrintToChatAll("SetClientSpeedOverride: %N: %f", iClient, fSpeed);
		return;
	}
	
	// Survivors
	if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
	{
		SetClientSpeedBill(iClient, fSpeed);
		SetClientSpeedRochelle(iClient, fSpeed);
		SetClientSpeedCoach(iClient, fSpeed);
		SetClientSpeedEllis(iClient, fSpeed);
		SetClientSpeedNick(iClient, fSpeed);
		SetClientSpeedLouis(iClient, fSpeed);
	}
	// Infected
	if (g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		SetClientSpeedSmoker(iClient, fSpeed);
		SetClientSpeedBoomer(iClient, fSpeed);
		SetClientSpeedHunter(iClient, fSpeed);
		SetClientSpeedSpitter(iClient, fSpeed);
		SetClientSpeedJockey(iClient, fSpeed);
		SetClientSpeedCharger(iClient, fSpeed);
		SetClientSpeedTank(iClient, fSpeed);
	}

	// Give sub max level players more speed and scale down as they level
	SetClientSpeedNewPlayer(iClient, fSpeed);

	SetEntDataFloat(iClient, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), fSpeed, true);
	// if (IsFakeClient(iClient) == false)
	// 	PrintToChat(iClient, "SetClientSpeed: %N: %f", iClient, fSpeed);
	// PrintToChatAll("SetClientSpeed: %N: %f", iClient, fSpeed);
}

SetClientSpeedForAllSurvivors()
{
	for (int iClient=1; iClient <= MaxClients; iClient++)
		if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
			SetClientSpeed(iClient);
}

// Action:TimerResetClientSpeed(Handle:timer, any:iClient)
// {
// 	SetClientSpeed(iClient);
// 	return Plugin_Stop;
// }

// Survivors =======================================================================================================================
SetClientSpeedBill(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iChosenSurvivor[iClient] != BILL)
		return;

	// Ghillie Suit Sprinting
	if (g_bBillSprinting[iClient])
		fSpeed += 1.0;

	//PrintToChat(iClient, "SetClientSpeedBill: %f", fSpeed);
}

SetClientSpeedRochelle(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ROCHELLE)
		return;
	
	// Passive speed boosts
	fSpeed += ((g_iHunterLevel[iClient] * 0.02) + (g_iSniperLevel[iClient] * 0.02) + (g_iShadowLevel[iClient] * 0.02));

	// Silent Assassin
	if (g_bUsingShadowNinja[iClient])
		fSpeed += (g_iShadowLevel[iClient] * 0.06);

	// PrintToChat(iClient, "SetClientSpeedRochelle: %f", fSpeed);
}

SetClientSpeedCoach(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != COACH)
		return;
	
	// Bull Rush CI Kill boost
	if (g_bCoachInCISpeed[iClient])
		fSpeed += (g_iBullLevel[iClient] * 0.05);

	// Homerun SI Kill boost
	if (g_bCoachInSISpeed[iClient])
		fSpeed += (g_iHomerunLevel[iClient] * 0.05);

	// Bull Rush Rage boost
	if (g_bCoachRageIsActive[iClient])
		fSpeed += (g_iBullLevel[iClient] * 0.05);
	else if (g_bCoachRageIsInCooldown[iClient])
		fSpeed -= (g_iBullLevel[iClient] * 0.03);

	//PrintToChat(iClient, "SetClientSpeedCoach: %f", fSpeed);
}

SetClientSpeedEllis(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ELLIS)
		return;

	// Overconfidence speed boost
	if (g_bEllisOverSpeedIncreased[iClient])
		fSpeed += (g_iOverLevel[iClient] * 0.01);

	// Bring The Pain SI Kill counter speed boost
	if (g_iEllisSpeedBoostCounter[iClient] > 0)
		fSpeed += (g_iEllisSpeedBoostCounter[iClient] * 0.01);
	
	// Jammin To The Music Tank Count speed boost
	if (g_iTankCounter > 0)
		fSpeed += (g_iTankCounter * g_iJamminLevel[iClient] * 0.01);
	
	//PrintToChat(iClient, "SetClientSpeedEllis: %f, g_iTankCounter: %i", fSpeed, g_iTankCounter);
}

SetClientSpeedNick(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != NICK)
		return;

	// Magnum Stampede
	if (g_iMagnumLevel[iClient] > 0)
		fSpeed += (g_iMagnumLevel[iClient] * 0.03);

	// Desperate Measures Incap movement speed boost
	if (g_iNickDesperateMeasuresStack > 0)
	{
		fSpeed += g_iNickDesperateMeasuresStack >= 3 ? 
			(3 * (g_iDesperateLevel[iClient] * 0.02)) : 
			(g_iNickDesperateMeasuresStack * (g_iDesperateLevel[iClient] * 0.02));
	}
	
	//PrintToChat(iClient, "SetClientSpeedNick: %f", fSpeed);
}

SetClientSpeedLouis(iClient, &Float:fSpeed)
{
	// Warez Station boost
	fSpeed += g_fWarezStationSpeedBoost[iClient];

	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != LOUIS)
		return;
	
	// Make sure Louis is not using his teleporter
	if (g_bLouisTeleportActive[iClient] == true)
	{
		fSpeed = LOUIS_TELEPORT_MOVEMENT_SPEED;
		return;
	}

	// Teleport penalty
	if (g_iLouisTeleportMovementPenaltyStacks[iClient] > 0)
		fSpeed -= (g_iLouisTeleportMovementPenaltyStacks[iClient] * LOUIS_TELEPORT_MOVEMENT_PENALTY_AMOUNT);

	// CI Kill speed
	if (g_iLouisCIHeadshotCounter[iClient] > 0)
		fSpeed += (g_iLouisCIHeadshotCounter[iClient] * 0.01);

	// SI Kill speed
	if (g_iLouisSIHeadshotCounter[iClient] > 0)
		fSpeed += (g_iLouisSIHeadshotCounter[iClient] * 0.05);

	// Pills Used Stack speed
	if (g_iPillsUsedStack[iClient] > 0)
		fSpeed += (g_iPillsUsedStack[iClient] * g_iLouisTalent6Level[iClient] * 0.02);

	// Cap Louis's speed
	if (fSpeed > LOUIS_SPEED_MAX)
		fSpeed = LOUIS_SPEED_MAX;
	
	// PrintToChat(iClient, "SetClientSpeedLouis: %f", fSpeed);
}


SetClientSpeedNewPlayer(iClient, &Float:fSpeed)
{
	if (g_iClientTeam[iClient] != TEAM_SURVIVORS || 
		g_iClientLevel[iClient] == 30)
		return;

	fSpeed += ( NEW_PLAYER_MAX_MOVEMENT_SPEED * ( 1.0 - (float(g_iClientLevel[iClient]) / 30.0) ) );
	
	// PrintToChatAll("%N: SetClientSpeedNewPlayer: %f", iClient, fSpeed);
}


// Infected =======================================================================================================================
SetClientSpeedSmoker(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iInfectedCharacter[iClient] != SMOKER ||
		(g_iClientInfectedClass1[iClient] != SMOKER &&
		g_iClientInfectedClass2[iClient] != SMOKER &&
		g_iClientInfectedClass3[iClient] != SMOKER))
		return;

	if(g_iSmokerTalent1Level[iClient] > 0)
		fSpeed += (g_iSmokerTalent1Level[iClient] * 0.05);

	//PrintToChat(iClient, "SetClientSpeedSmoker: %f", fSpeed);
}

SetClientSpeedBoomer(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iInfectedCharacter[iClient] != BOOMER ||
		(g_iClientInfectedClass1[iClient] != BOOMER &&
		g_iClientInfectedClass2[iClient] != BOOMER &&
		g_iClientInfectedClass3[iClient] != BOOMER))
		return;
	
	// Bind 1 Hot Meal speed
	if (g_bIsServingHotMeal[iClient])
		fSpeed += (g_iAcidicLevel[iClient] * 0.1);
	// Vomited on 3 survivors and got super speed
	else if(g_bIsSuperSpeedBoomer[iClient])
		fSpeed = 3.0;
	// Rapid Regurgitation allow Boomer speed while vomiting
	else if(g_bIsBoomerVomiting[iClient] && g_iRapidLevel[iClient] > 0)
	 	fSpeed = (g_iRapidLevel[iClient] * 0.1);

	//PrintToChat(iClient, "SetClientSpeedBoomer: %f", fSpeed);
}

SetClientSpeedHunter(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iInfectedCharacter[iClient] != HUNTER ||
		(g_iClientInfectedClass1[iClient] != HUNTER &&
		g_iClientInfectedClass2[iClient] != HUNTER &&
		g_iClientInfectedClass3[iClient] != HUNTER))
		return;

	if (g_iPredatorialLevel[iClient] > 0)
		fSpeed += (g_iPredatorialLevel[iClient] * 0.05);

	if (g_iBloodLustStage[iClient] > 0)
		fSpeed += (g_iBloodLustStage[iClient] * BLOOD_LUST_SPEED_BOOST_PER_STAGE);
	
	// PrintToChat(iClient, "SetClientSpeedHunter: %f", fSpeed);
}

SetClientSpeedSpitter(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iInfectedCharacter[iClient] != SPITTER ||
		(g_iClientInfectedClass1[iClient] != SPITTER &&
		g_iClientInfectedClass2[iClient] != SPITTER &&
		g_iClientInfectedClass3[iClient] != SPITTER))
		return;

	if (g_bIsStealthSpitter[iClient] == true)
		fSpeed += 1.0;
	
	//PrintToChat(iClient, "SetClientSpeedSpitter: %f", fSpeed);
}

SetClientSpeedJockey(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iInfectedCharacter[iClient] != JOCKEY ||
		(g_iClientInfectedClass1[iClient] != JOCKEY &&
		g_iClientInfectedClass2[iClient] != JOCKEY &&
		g_iClientInfectedClass3[iClient] != JOCKEY))
		return;
	
	if (g_iUnfairLevel[iClient] > 0)
		fSpeed += (g_iUnfairLevel[iClient] * 0.07);

	if (g_bHasSuperJockeySpeed[iClient] == true)
		fSpeed += (g_iUnfairLevel[iClient] * 0.03);
	
	// PrintToChat(iClient, "SetClientSpeedJockey: %f", fSpeed);
}

SetClientSpeedCharger(iClient, &Float:fSpeed)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iInfectedCharacter[iClient] != CHARGER ||
		(g_iClientInfectedClass1[iClient] != CHARGER &&
		g_iClientInfectedClass2[iClient] != CHARGER &&
		g_iClientInfectedClass3[iClient] != CHARGER))
		return;

	// Hillbilly Madness speed
	if(g_iHillbillyLevel[iClient] > 0)
		fSpeed += (g_iHillbillyLevel[iClient] * 0.03);

	// Heavy Carry Bind 1 speed
	if(g_bIsSuperCharger[iClient] == true)
		fSpeed += (g_iSpikedLevel[iClient] * 0.10);
	
	//PrintToChat(iClient, "SetClientSpeedCharger: %f", fSpeed);
}

SetClientSpeedTank(iClient, &Float:fSpeed)
{
	if (g_iInfectedCharacter[iClient] != TANK)
		return;

	SetClientSpeedTankFire(iClient, fSpeed);
	SetClientSpeedTankIce(iClient, fSpeed);
	SetClientSpeedTankNecroTanker(iClient, fSpeed);
	SetClientSpeedTankVampiric(iClient, fSpeed);

	//PrintToChat(iClient, "SetClientSpeedTank: %f", fSpeed);
}

bool SetClientSpeedOverrides(iClient, &Float:fSpeed)
{
	if (g_testingSpeedOverride[iClient] > 0.0)
	{
		fSpeed = g_testingSpeedOverride[iClient];
		return true;
	}

	if (g_bMovementLocked[iClient] == true)
	{
		fSpeed = 0.0;
		return true;
	}

	// If they are an infected ghost, then give them fast speed.
	if(g_iClientTeam[iClient] == TEAM_INFECTED &&
		GetEntData(iClient, g_iOffset_IsGhost, 1) == 1)
	{
		fSpeed = 1.75;
		return true;
	}

	// If choking a victim, dont give other movement speed buffs
	if (g_iSmokerTalent1Level[iClient] > 0 &&
		g_iInfectedCharacter[iClient] == SMOKER &&
		g_bTalentsConfirmed[iClient] == true &&
		g_iChokingVictim[iClient] > 0 && 
		g_iClientTeam[iClient] == TEAM_INFECTED &&
		g_bSmokerGrappled[g_iChokingVictim[iClient]])
	{
		fSpeed = (0.01 * g_iSmokerTalent1Level[iClient])
		return true;
	}

	// Jockey Riding speed (set on the victim, not the jockey thats riding)
	if (g_bJockeyGrappled[iClient] && 
		g_iClientTeam[iClient] == TEAM_SURVIVORS &&
		(g_fJockeyRideSpeed[iClient] != 1.0 || g_fJockeyRideSpeedVanishingActBoost[iClient] > 0.0))
	{
		fSpeed = g_fJockeyRideSpeed[iClient] + g_fJockeyRideSpeedVanishingActBoost[iClient];
		return true;
	}
	
	// Hunter lunging speed value
	if (g_iInfectedCharacter[iClient] == HUNTER &&
		g_bHunterIsLunging[iClient] == true &&
		g_iHunterLungeState[iClient] != HUNTER_LUNGE_STATE_NONE)
	{
		switch (g_iHunterLungeState[iClient])
		{
			case HUNTER_LUNGE_STATE_BASE: fSpeed = HUNTER_LUNGE_MOVEMENT_SPEED_BASE;
			case HUNTER_LUNGE_STATE_DASH: fSpeed = HUNTER_LUNGE_MOVEMENT_SPEED_DASH;
			case HUNTER_LUNGE_STATE_FLOAT: fSpeed = HUNTER_LUNGE_MOVEMENT_SPEED_FLOAT;
		}

		return true;
	}

	// Hunter Immobility Zone Speed
	if (g_bIsInImmobilityZone[iClient] == true)
	{
		fSpeed = HUNTER_IMMOBILITY_ZONE_SPEED;
		return true;
	}

	// Lethal Injection poison slow
	if (g_bIsHunterPoisoned[iClient] &&
		g_iClientTeam[iClient] == TEAM_SURVIVORS)
	{
		fSpeed = HUNTER_POISON_VICTIM_SPEED;
		return true;
	}
	
	// Spitter adhession spit
	if (g_fAdhesiveAffectAmount[iClient] > 0 &&
		g_iClientTeam[iClient] == TEAM_SURVIVORS)
	{
		fSpeed = (1.0 - g_fAdhesiveAffectAmount[iClient]);
		return true;
	}

	// Louis's Bind 2 Global Survivor Speed Override
	if (g_bLouisSpeedHaxEnabled == true &&
		g_iClientTeam[iClient] == TEAM_SURVIVORS && 
		IsClientGrappled(iClient) == false)
	{
		fSpeed = LOUIS_SPEED_HAX_MOVEMENT_MULTIPLIER;
		return true;
	}

	// Ice Tank's cold slow AOE Aura
	if (g_bIceTankColdAuraDisabled[iClient] == false &&
		g_fIceTankColdAuraSlowSpeedReduction[iClient] > 0.0 &&
		g_iClientTeam[iClient] == TEAM_SURVIVORS)
	{
		fSpeed = 1.0 - g_fIceTankColdAuraSlowSpeedReduction[iClient];
		// PrintToChatAll("SETTING COLD AURA SPEED %N: %f", iClient, 1.0 - g_fIceTankColdAuraSlowSpeedReduction[iClient]);
		return true;
	}

	// Smoker's Smoke Cloud Speed
	if (g_iSmokerSmokeCloudPlayer == iClient &&
		g_iInfectedCharacter[iClient] == SMOKER &&
		g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		fSpeed = 0.4;
		return true;
	}
	

	return false;
}