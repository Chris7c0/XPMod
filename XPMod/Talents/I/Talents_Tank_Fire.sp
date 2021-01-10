LoadFireTankTalents(iClient)
{
	g_fClientSpeedBoost[iClient] = 0.0;
	g_fClientSpeedPenalty[iClient] = 0.0;
	
	if(iClient < 1 || g_iClientTeam[iClient] != TEAM_INFECTED || IsClientInGame(iClient) == false || 
		IsFakeClient(iClient) == true || GetEntProp(iClient, Prop_Send, "m_zombieClass") != TANK)
		return;
	
	if(IsPlayerAlive(iClient) == false)
	{
		PrintToChat(iClient, "\x04You cannot choose tank talents after you have died");
		return;
	}
	
	g_iTankChosen[iClient] = TANK_FIRE;
	g_fTankHealthPercentage[iClient] =  1.0;
	g_bBlockTankFirePunchCharge[iClient] = false;
	
	//Set On Fire
	IgniteEntity(iClient, 10000.0, false);
	CreateTimer(10000.0, Timer_ReigniteFireTank, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	//Give Health
	SetEntProp(iClient, Prop_Data,"m_iMaxHealth", TANK_HEALTH_FIRE);
	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	SetEntProp(iClient, Prop_Data,"m_iHealth", iCurrentHealth + TANK_HEALTH_FIRE - 6000);
	
	//Set Movement Speed
	//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), 1.2, true);
	g_fClientSpeedBoost[iClient] += 0.2;
	fnc_SetClientSpeed(iClient);
	
	//Change Skin Color
	SetEntityRenderMode(iClient, RenderMode:0);
	SetEntityRenderColor(iClient, 255, 200, 0, 255);
	//SetEntityRenderColor(iClient, 210, 88, 30, 255);
	
	PrintHintText(iClient, "You are now the Fire Tank");
}

OnGameFrame_Tank_Fire(iClient)
{
	//Check to see if the charging has already taken place or depleted
	if(g_iTankChosen[iClient] == TANK_FIRE && g_bTankAttackCharged[iClient] == true)
		return;
	
	new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	
	//Check to see if ducking and not attacking before starting the charge
	if((buttons & IN_DUCK) && !(buttons & IN_ATTACK) && !(buttons & IN_ATTACK2))
	{
		CheckIfTankMovedWhileChargingAndIncrementCharge(iClient);

		//Display the first message to the player while he is charging up
		if(g_iTankCharge[iClient] == 30)
		{
			if(g_bBlockTankFirePunchCharge[iClient] == false)
			{
				PrintHintText(iClient, "Charging Up Attack");
			}
			else
			{
				PrintHintText(iClient, "You must wait to charge your fire punch attack");
				g_iTankCharge[iClient] = 0;
			}
		}
		
		//Charged for long enough, now handle fire tank charged punch
		if(g_iTankCharge[iClient] >= 150)
		{
			g_bTankAttackCharged[iClient] = true;
			g_iTankCharge[iClient] = 0;				
			g_iPID_TankChargedFire[iClient] = CreateParticle("fire_small_01", 0.0, iClient, ATTACH_DEBRIS);
			
			PrintHintText(iClient, "Fire Punch Attack Charged", g_iTankCharge[iClient]);
		}
	}
	else if(g_iTankCharge[iClient] > 0)
	{
		if(g_iTankCharge[iClient] > 31)
			PrintHintText(iClient, "Charge Interrupted");
		
		g_iTankCharge[iClient] = 0;
	}
}

EventsHurt_TankVictim_Fire(iVictimTank, iDmgType, iDmgHealth)
{
	new iCurrentHealth = GetEntProp(iVictimTank,Prop_Data,"m_iHealth");
	decl Float:fCurrentTankHealthPercentage;

	//Prevent Fire Damage
	if(iDmgType == DAMAGETYPE_FIRE1 || iDmgType == DAMAGETYPE_FIRE2 || iDmgType == DAMAGETYPE_IGNITED_ENTITY)
		SetEntProp(iVictimTank, Prop_Data, "m_iHealth", iCurrentHealth + iDmgHealth);
	
	fCurrentTankHealthPercentage = float(iCurrentHealth + iDmgHealth) / float(TANK_HEALTH_FIRE);
	
	//Check to see if the difference in stored health and current health percentage is significant
	if(g_fTankHealthPercentage[iVictimTank] - fCurrentTankHealthPercentage >= 0.01)
	{
		g_fTankHealthPercentage[iVictimTank] = fCurrentTankHealthPercentage;
		g_fClientSpeedBoost[iVictimTank] -= g_fFireTankExtraSpeed[iVictimTank];
		//Change to the speed to match health percentage and level
		g_fFireTankExtraSpeed[iVictimTank] = g_iClientLevel[iVictimTank] * 0.01 * (1.0 - fCurrentTankHealthPercentage);
		g_fClientSpeedBoost[iVictimTank] += g_fFireTankExtraSpeed[iVictimTank];
		//SetEntDataFloat(iVictimTank , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), 1.2 + fExtraSpeed, true);
		//g_fClientSpeedBoost[iVictimTank] += (0.2 + fExtraSpeed);
		/*
		if(g_bFireTankBaseSpeedIncreased[iVictimTank] == false)
		{
			g_fClientSpeedBoost[iVictimTank] += 0.2;
			g_bFireTankBaseSpeedIncreased[iVictimTank] = true;
		}
		*/
		fnc_SetClientSpeed(iVictimTank);
		
		//Change the actual color of the tank to reflect his health
		//Go from Orange to Red by lowering the green value
		new iGreen	= 20 + RoundToNearest(180 * fCurrentTankHealthPercentage);
		
		SetEntityRenderMode(iVictimTank, RenderMode:0);
		SetEntityRenderColor(iVictimTank, 255, iGreen, 0, 255);
	}
}

SetFireToPlayer(iVictim, iAttacker, Float:fTime)
{
	if(iVictim < 1 || IsClientInGame(iVictim) == false)
		return;
	
	g_iFireDamageCounter[iVictim] = RoundToNearest(fTime * 2);
	IgniteEntity(iVictim, fTime, false);
	WriteParticle(iVictim, "fire_small_01", 40.0, fTime);
	
	new Handle:hEntityPack = CreateDataPack();
	WritePackCell(hEntityPack, iVictim);
	WritePackCell(hEntityPack, iAttacker);
	CreateTimer(0.5, Timer_DealFireDamage, hEntityPack, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

CreateFireRockTrailEffect(int iRockEntity)
{
	new Float:xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);
	new String:vecString[32];
	Format(vecString, sizeof(vecString), "%f %f %f", xyzRockPosition[0], xyzRockPosition[1], xyzRockPosition[2]);

	// Make Fire Entity
	new iTankRockTrailParticle = AttachParticle(iRockEntity, "aircraft_destroy_fastFireTrail", 20.0, 0.0);
	// Find the tank rock entity in the list that will be used store the trail particle entity
	new iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iRockEntity, TANK_ROCK_ENTITY_ID);
	// Store it for stopping and destroying it later
	g_listTankRockEntities.Set(iTankRockIndex, iTankRockTrailParticle, TANK_ROCK_PARTICLE_TRAIL);
	
	// SetVariantString("!activator");
	// AcceptEntityInput(iTankRockTrailParticle, "SetParent", iRockEntity, iTankRockTrailParticle, 0);

	// DispatchSpawn(iTankRockTrailParticle);
	// AcceptEntityInput(iTankRockTrailParticle, "TurnOn");
	
	// CreateTimer(10.0, TimerStopSmokeEntity, iTankRockTrailParticle, TIMER_FLAG_NO_MAPCHANGE);
}

DestroyFireTankRock(iRockEntity)
{
	new Float:xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);

	MolotovExplode(xyzRockPosition);
}