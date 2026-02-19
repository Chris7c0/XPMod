void LoadFireTankTalents(int iClient)
{
	if (RunClientChecks(iClient) == false || 
		g_iClientTeam[iClient] != TEAM_INFECTED ||
		g_iTankChosen[iClient] != TANK_NOT_CHOSEN ||
		GetEntProp(iClient, Prop_Send, "m_zombieClass") != TANK)
		return;
	
	if(IsPlayerAlive(iClient) == false)
	{
		if (IsFakeClient(iClient) == false)
			PrintToChat(iClient, "\x04You cannot choose tank talents after you have died");
		return;
	}

	// PrintToChatAll("%N Loading Fire Tank abilities.", iClient);
	
	g_iTankChosen[iClient] = TANK_FIRE;
	g_fTankHealthPercentage[iClient] =  1.0;
	g_bBlockTankFirePunchCharge[iClient] = false;
	
	// Set On Fire
	IgniteEntity(iClient, 10000.0, false);
	CreateTimer(10000.0, Timer_ReigniteFireTank, iClient, TIMER_FLAG_NO_MAPCHANGE);

	SetTanksTalentHealth(iClient, TANK_HEALTH_FIRE);
	
	// Stop Kiting (Bullet hits slowing tank down)
	SetConVarInt(FindConVar("z_tank_damage_slow_min_range"), 0);
	SetConVarInt(FindConVar("z_tank_damage_slow_max_range"), 0);
	
	// Set Movement Speed	
	SetClientSpeed(iClient);

	// Change Tank's Skin Color
	SetClientRenderColor(iClient, 255, 200, 30, 255, RENDER_MODE_NORMAL);
	// Make the tank have a colored outline glow
	SetClientGlow(iClient, 250, 50, 20, GLOWTYPE_ONVISIBLE);
	//Ellis firestorm 210, 88, 30
	
	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "You have become the Fire Tank");
}

void ResetAllTankVariables_Fire(int iClient)
{
	g_iFireDamageCounter[iClient] = 0;
	g_bFireTankAttackCharged[iClient] = false;
	g_bBlockTankFirePunchCharge[iClient] = false;
	g_fFireTankExtraSpeed[iClient] = 0.0;

	DeleteParticleEntity(g_iPID_TankChargedFire[iClient]);
}

// SetupTankForBot_Fire(iClient)
// {
// 	LoadFireTankTalents(iClient);
// }

void SetClientSpeedTankFire(int iClient, float &fSpeed)
{
	if (g_iTankChosen[iClient] != TANK_FIRE)
		return;
	
	fSpeed += (TANK_FIRE_BASE_SPEED + g_fFireTankExtraSpeed[iClient]);
}

void OnGameFrame_Tank_Fire(int iClient)
{
	//Check to see if the charging has already taken place or depleted
	if(g_iTankChosen[iClient] == TANK_FIRE && g_bFireTankAttackCharged[iClient] == true)
		return;
	
	int buttons;
	buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	
	//Check to see if ducking and not attacking before starting the charge
	if((buttons & IN_DUCK) && !(buttons & IN_ATTACK) && !(buttons & IN_ATTACK2))
	{
		// CheckIfTankMovedWhileChargingAndIncrementCharge(iClient);
		g_iTankCharge[iClient]++;  

		//Display the first message to the player while he is charging up
		if(g_iTankCharge[iClient] == 30)
		{
			if(g_bBlockTankFirePunchCharge[iClient] == false)
			{
				if (IsFakeClient(iClient) == false)
					PrintHintText(iClient, "Charging Up Attack");
			}
			else
			{
				if (IsFakeClient(iClient) == false)
					PrintHintText(iClient, "You must wait to charge your fire punch attack");
				g_iTankCharge[iClient] = 0;
			}
		}
		
		//Charged for long enough, now handle fire tank charged punch
		if(g_iTankCharge[iClient] >= 150)
		{
			g_bFireTankAttackCharged[iClient] = true;
			g_iTankCharge[iClient] = 0;				
			g_iPID_TankChargedFire[iClient] = CreateParticle("fire_small_01", 0.0, iClient, ATTACH_DEBRIS);
			
			PrintHintText(iClient, "Fire Punch Attack Charged", g_iTankCharge[iClient]);
		}
	}
	else if(g_iTankCharge[iClient] > 0)
	{
		if(g_iTankCharge[iClient] > 31 && IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Charge Interrupted");
		
		g_iTankCharge[iClient] = 0;
	}
}

void EventsHurt_VictimTank_Fire(Handle hEvent, int iAttacker, int iVictimTank)
{
	SuppressNeverUsedWarning(hEvent, iAttacker);

	int iDmgHealth = GetEventInt(hEvent,"dmg_health");
	int iDmgType = GetEventInt(hEvent, "type");

	int iCurrentHealth = GetPlayerHealth(iVictimTank);
	float fCurrentTankHealthPercentage;

	//Prevent Fire Damage
	if(iDmgType == DAMAGETYPE_FIRE1 || iDmgType == DAMAGETYPE_FIRE2 || iDmgType == DAMAGETYPE_IGNITED_ENTITY)
		SetPlayerHealth(iVictimTank, -1, iCurrentHealth + iDmgHealth);
	
	fCurrentTankHealthPercentage = float(iCurrentHealth + iDmgHealth) / (TANK_HEALTH_FIRE * g_fTankStartingHealthMultiplier[iVictimTank]);
	
	//Check to see if the difference in stored health and current health percentage is significant
	if(g_fTankHealthPercentage[iVictimTank] - fCurrentTankHealthPercentage >= 0.01)
	{
		//Change to the speed to match health percentage and level
		g_fTankHealthPercentage[iVictimTank] = fCurrentTankHealthPercentage;
		g_fFireTankExtraSpeed[iVictimTank] = TANK_FIRE_EXTRA_SPEED_MAX * (1.0 - fCurrentTankHealthPercentage);
		SetClientSpeed(iVictimTank);
		
		//Change the actual color of the tank to reflect his health
		//Go from Orange to Red by lowering the green value
		int iGreen = 20 + RoundToNearest(180 * fCurrentTankHealthPercentage);
		
		SetEntityRenderMode(iVictimTank, RenderMode:0);
		SetEntityRenderColor(iVictimTank, 255, iGreen, 0, 255);
	}
}

void EventsHurt_AttackerTank_Fire(Handle hEvent, int iAttackerTank, int iVictim)
{	
	char weapon[20];
	GetEventString(hEvent,"weapon", weapon, 20);

	//Lay down a molotov explosion if player is hit by fire tank's rock
	if(StrEqual(weapon,"tank_rock") == true)
	{
		float xyzLocation[3];
		GetClientAbsOrigin(iVictim, xyzLocation);
		MolotovExplode(xyzLocation);
	}
	
	if(StrEqual(weapon,"tank_claw") == true)
	{
		//Set fire to iVictim if charged or percent chance happens(5 seconds)
		if(g_bFireTankAttackCharged[iAttackerTank] == true)
		{
			float xyzLocation[3];
			GetClientAbsOrigin(iVictim, xyzLocation);
			xyzLocation[2] += 30.0;
			PropaneExplode(xyzLocation);
			MolotovExplode(xyzLocation);
			
			g_bFireTankAttackCharged[iAttackerTank] = false;
			DeleteParticleEntity(g_iPID_TankChargedFire[iAttackerTank]);
			SetFireToPlayer(iVictim, iAttackerTank, 5.0);
			
			g_bBlockTankFirePunchCharge[iAttackerTank] = true;
			CreateTimer(FIRE_TANK_FIRE_PUNCH_COOLDOWN_DURATION, Timer_UnblockFirePunchCharge, iAttackerTank, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		else if(GetRandomInt(1, 5) == 1)
		{
			SetFireToPlayer(iVictim, iAttackerTank, 5.0);
		}
	}
}

// EventsDeath_AttackerTank_Fire(Handle hEvent, iAttackerTank, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttackerTank, iVictim);
// }

void EventsDeath_VictimTank_Fire(Handle hEvent, int iAttacker, int iVictimTank)
{
	if (RunClientChecks(iVictimTank) == false)
		return;

	SuppressNeverUsedWarning(hEvent, iAttacker);

	// Explode the tank and set a fire
	float xyzLocation[3];
	GetClientAbsOrigin(iVictimTank, xyzLocation);
	PropaneExplode(xyzLocation);
	MolotovExplode(xyzLocation);
}

void SetFireToPlayer(int iVictim, int iAttacker, float fTime)
{
	if (iVictim < 1 || IsClientInGame(iVictim) == false)
		return;
	
	g_iFireDamageCounter[iVictim] = RoundToNearest(fTime * 2);
	IgniteEntity(iVictim, fTime, false);
	WriteParticle(iVictim, "fire_small_01", 40.0, fTime);
	
	Handle hEntityPack = CreateDataPack();
	WritePackCell(hEntityPack, iVictim);
	WritePackCell(hEntityPack, iAttacker);
	CreateTimer(0.5, Timer_DealFireDamage, hEntityPack, TIMER_REPEAT);
}

void CreateFireRockTrailEffect(int iRockEntity)
{
	float xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);
	char vecString[32];
	Format(vecString, sizeof(vecString), "%f %f %f", xyzRockPosition[0], xyzRockPosition[1], xyzRockPosition[2]);

	// Make Fire Entity
	int iTankRockTrailParticle = AttachParticle(iRockEntity, "aircraft_destroy_fastFireTrail", 20.0, 0.0);
	// Find the tank rock entity in the list that will be used store the trail particle entity
	int iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iRockEntity, TANK_ROCK_ENTITY_ID);
	// Store it for stopping and destroying it later
	g_listTankRockEntities.Set(iTankRockIndex, iTankRockTrailParticle, TANK_ROCK_PARTICLE_TRAIL);
	
	// SetVariantString("!activator");
	// AcceptEntityInput(iTankRockTrailParticle, "SetParent", iRockEntity, iTankRockTrailParticle, 0);

	// DispatchSpawn(iTankRockTrailParticle);
	// AcceptEntityInput(iTankRockTrailParticle, "TurnOn");
	
	// CreateTimer(10.0, TimerStopSmokeEntity, iTankRockTrailParticle, TIMER_FLAG_NO_MAPCHANGE);
}

void DestroyFireTankRock(int iRockEntity)
{
	float xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);

	MolotovExplode(xyzRockPosition);
}
