LoadNecroTankerTalents(iClient)
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

	// PrintToChatAll("%N Loading NECROTANKER abilities.", iClient);
	
	g_iTankChosen[iClient] = TANK_NECROTANKER;

	g_iNecroTankerManaPool[iClient] = NECROTANKER_MANA_POOL_SIZE;

	SetTanksTalentHealth(iClient, IsFakeClient(iClient) ? NECROTANKER_MAX_HEALTH : TANK_HEALTH_NECROTANKER);

	//Stop Kiting (Bullet hits slowing tank down)
	SetConVarInt(FindConVar("z_tank_damage_slow_min_range"), 0);
	SetConVarInt(FindConVar("z_tank_damage_slow_max_range"), 0);
	
	//Set Movement Speed
	SetClientSpeed(iClient);

	// Change Tank's Skin Color
	SetClientRenderColor(iClient, 0, 130, 40, 255, RENDER_MODE_NORMAL);
	// Make the tank have a colored outline glow
	SetClientGlow(iClient, 0, 130, 40, GLOWTYPE_ONVISIBLE);

	// Create Effects
	CreateNecroTankerTrailEffect(iClient);
	WriteParticle(iClient, "boomer_vomit_infected", 0.0, 999.0);
	
	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "You have become the NecroTanker");
}

ResetAllTankVariables_NecroTanker(iClient)
{
	SuppressNeverUsedWarning(iClient);
}

// SetupTankForBot_NecroTanker(iClient)
// {
// 	LoadNecroTankerTalents(iClient);
// }


SetClientSpeedTankNecroTanker(iClient, float &fSpeed)
{
	if (g_iTankChosen[iClient] != TANK_NECROTANKER)
		return;

	fSpeed += 0.15;
}

OnGameFrame_Tank_NecroTanker(iClient)
{
	int buttons;
	buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	
	//Check to see if ducking and not attacking before starting the charge
	if((buttons & IN_SPEED || buttons & IN_DUCK) && !(buttons & IN_ATTACK2)) // && !(buttons & IN_ATTACK)
	{
		// CheckIfTankMovedWhileChargingAndIncrementCharge(iClient);
		g_iTankCharge[iClient]++;

		//Display the first message to the player while he is charging up
		if(g_iTankCharge[iClient] == 30 && IsFakeClient(iClient) == false)
			DisplayNecroTankerManaMeter(iClient);
		
		//Charged for long enough, now handle summoning for each type WALK or CROUCH
		if(buttons & IN_DUCK && g_iTankCharge[iClient] >= 31)
		{
			// If they have the mana, spawn zombie, otherwise, print message not enough mana
			if (g_iNecroTankerManaPool[iClient] >= NECROTANKER_MANA_COST_SUMMON_ENHANCED_CI)
				SummonNecroTankerCrouchAndWalkAbility(iClient, true);

			if(IsFakeClient(iClient) == false)
				DisplayNecroTankerManaMeter(iClient);

			g_iTankCharge[iClient] = 0;
		}
		else if(buttons & IN_SPEED && g_iTankCharge[iClient] >= 60)
		{
			// If they have the mana, spawn zombie, otherwise, print message not enough mana
			if (g_iNecroTankerManaPool[iClient] >= NECROTANKER_MANA_COST_SUMMON_NORMAL_CI)
				SummonNecroTankerCrouchAndWalkAbility(iClient, false);

			if(IsFakeClient(iClient) == false)
				DisplayNecroTankerManaMeter(iClient);

			g_iTankCharge[iClient] = 0;
		}
	}
	else if(g_iTankCharge[iClient] > 0)
	{
		// if(g_iTankCharge[iClient] > 31 && IsFakeClient(iClient) == false)
		// 	DisplayNecroTankerManaMeter(iClient);
		
		g_iTankCharge[iClient] = 0;
	}
}

EventsHurt_VictimTank_NecroTanker(Handle hEvent, iAttacker, iVictimTank)
{
	SuppressNeverUsedWarning(hEvent, iAttacker, iVictimTank);
}

EventsHurt_AttackerTank_NecroTanker(Handle hEvent, iAttackerTank, iVictim)
{
	char strWeapon[20];
	GetEventString(hEvent,"weapon", strWeapon, 20);

	if (g_iClientTeam[iVictim] == TEAM_SURVIVORS &&
		RunClientChecks(iVictim) == true &&
		IsPlayerAlive(iVictim) == true &&
		StrEqual(strWeapon,"tank_claw"))
	{
		SummonNecroTankerPunchZombies(iAttackerTank, iVictim);

		// Store Check Mana before increase if below boomer throw threshhole
		new iPreviousMana = g_iNecroTankerManaPool[iAttackerTank];

		g_iNecroTankerManaPool[iAttackerTank] += NECROTANKER_MANA_GAIN_PUNCH;
		// Clamp it
		if (g_iNecroTankerManaPool[iAttackerTank] > NECROTANKER_MANA_POOL_SIZE)
			g_iNecroTankerManaPool[iAttackerTank] = NECROTANKER_MANA_POOL_SIZE;

		DisplayNecroTankerManaMeter(iAttackerTank);

		// Reset boomer throw ability if they now have mana for it
		if (iPreviousMana < NECROTANKER_MANA_COST_BOOMER_THROW && 
			g_iNecroTankerManaPool[iAttackerTank] >= NECROTANKER_MANA_COST_BOOMER_THROW)
			SetSIAbilityCooldown(iAttackerTank, NECROTANKER_BOOMER_THROW_ABILITY_COOLDOWN);
	}
}

HandleNecroTankerInfectedConsumption(iClient, iInfectedEntity)
{
	//Check if player is NecroTanker
	if(g_iTankChosen[iClient] != TANK_NECROTANKER ||
		g_iClientTeam[iClient] != TEAM_INFECTED ||
		RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		GetEntProp(iClient, Prop_Send, "m_zombieClass") != TANK)
		return;

	// Get the model type to determine the amount of health to give
	decl iAdditionalHealth;
	if (IsEntityUncommonInfected(iInfectedEntity) == true)
		iAdditionalHealth = NECROTANKER_CONSUME_UNCOMMON_HP;
	else
		iAdditionalHealth = NECROTANKER_CONSUME_COMMON_HP;

	// Give the appropriate amount of Health & Max Health
	// Check if should increase max health
	new iCurrentMaxHealth = GetPlayerMaxHealth(iClient);
	new iAbsoluteMaxHealth = RoundToNearest(NECROTANKER_MAX_HEALTH * g_fTankStartingHealthMultiplier[iClient]);
	if (iCurrentMaxHealth < iAbsoluteMaxHealth)
	{
		// Add it, Cap it, Set it
		new iNewHealth = iCurrentMaxHealth + iAdditionalHealth > iAbsoluteMaxHealth ? iAbsoluteMaxHealth : iCurrentMaxHealth + iAdditionalHealth;
		SetPlayerMaxHealth(iClient,  iNewHealth, false, false);
	}
	// Check if should increase health
	new iCurrentHealth = GetPlayerHealth(iClient);
	if (iCurrentHealth < iAbsoluteMaxHealth)
	{
		// Add it, Cap it, Set it
		new iNewHealth = iCurrentHealth + iAdditionalHealth > iAbsoluteMaxHealth ? iAbsoluteMaxHealth : iCurrentHealth + iAdditionalHealth;
		SetPlayerHealth(iClient, -1, iNewHealth);
	}
}

CreateNecroTankerTrailEffect(int iClient)
{
	float xyzTankPosition[3];
	GetClientAbsOrigin(iClient, xyzTankPosition);
	xyzTankPosition[2] += 30.0;
	char vecString[32];
	Format(vecString, sizeof(vecString), "%f %f %f", xyzTankPosition[0], xyzTankPosition[1], xyzTankPosition[2]);

	g_iPID_TankTrail[iClient] = CreateEntityByName("env_smokestack");
	
	DispatchKeyValue(g_iPID_TankTrail[iClient],"Origin", vecString);
	DispatchKeyValue(g_iPID_TankTrail[iClient],"BaseSpread", "0");		//Gap in the middle
	DispatchKeyValue(g_iPID_TankTrail[iClient],"SpreadSpeed", "20");	//Speed the smoke moves outwards
	DispatchKeyValue(g_iPID_TankTrail[iClient],"Speed", "5");			//The speed at which the smoke particles move after they're spawned
	DispatchKeyValue(g_iPID_TankTrail[iClient],"StartSize", "35");
	DispatchKeyValue(g_iPID_TankTrail[iClient],"EndSize", "70");
	DispatchKeyValue(g_iPID_TankTrail[iClient],"Rate", "5");			//Amount of smoke created
	DispatchKeyValue(g_iPID_TankTrail[iClient],"JetLength", "20");		//Smoke jets outside of the original
	DispatchKeyValue(g_iPID_TankTrail[iClient],"Twist", "3"); 			//Amount of global twisting
	DispatchKeyValue(g_iPID_TankTrail[iClient],"RenderColor", "0 200 20");
	DispatchKeyValue(g_iPID_TankTrail[iClient],"RenderAmt", "50");		//Transparency
	DispatchKeyValue(g_iPID_TankTrail[iClient],"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
	
	
	SetVariantString("!activator");
	AcceptEntityInput(g_iPID_TankTrail[iClient], "SetParent", iClient, g_iPID_TankTrail[iClient], 0);

	DispatchSpawn(g_iPID_TankTrail[iClient]);
	AcceptEntityInput(g_iPID_TankTrail[iClient], "TurnOn");
}

// ReplaceTankRockWithSpecialInfected(iTankRockEntity)
// {	
// 	//Find the tank rock entity in the list that will be used to gain the rock type
// 	//new iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iTankRockEntity, TANK_ROCK_ENTITY_ID);


// 	//SetEntityModel(iTankRockEntity, "models/infected/boomer.mdl");
// 	// SetEntProp(iTankRockEntity, Prop_Data, "m_nNextThinkTick", 0.1);
// 	// //CreateTimer(0.1, TimerSetMobRush, iTankRockEntity);
// 	// //DispatchSpawn(iTankRockEntity);
// 	// ActivateEntity(EntRefToEntIndex(iTankRockEntity));
// 	// // ActivateEntity(iTankRockEntity);
// 	// SetVariantString("Vomit_Attack");
// 	//AcceptEntityInput(iTankRockEntity, "SetAnimation", -1, -1, 0); 
// 	// AcceptEntityInput(EntRefToEntIndex(iTankRockEntity), "SetAnimation");
// 	// AcceptEntityInput(EntRefToEntIndex(iTankRockEntity), "Enable");
// 	// AcceptEntityInput(EntRefToEntIndex(iTankRockEntity), "EnableMotion");
	

// 	float velocity[3];
// 	new g_iVelocity = FindSendPropInfo("CBasePlayer", "m_vecVelocity[0]");	
// 	GetEntDataVector(iTankRockEntity, g_iVelocity, velocity);

// 	new bot = CreateFakeClient("Boomer");
// 	if (bot > 0)
// 	{
// 		SpawnSpecialInfected(bot, BOOMER, true);
// 		float Pos[3];
// 		GetEntPropVector(iTankRockEntity, Prop_Send, "m_vecOrigin", Pos);
//		If (iTankRockEntity > 0 && IsValidEntity(iTankRockEntity))
// 			AcceptEntityInput(iTankRockEntity, "Kill");
// 		NormalizeVector(velocity, velocity);
// 		float speed = GetConVarFloat(FindConVar("z_tank_throw_force"));
// 		ScaleVector(velocity, speed*1.4);
// 		//PrintToChatAll("%f, %f, %f", Pos[0],Pos[1],Pos[2])
// 		TeleportEntity(bot, Pos, NULL_VECTOR, velocity);
// 		// Set it so thatt it knows the boomer is not on the ground
// 		new flags = GetEntityFlags(bot);
// 		SetEntityFlags(bot, flags&~FL_ONGROUND)
// 		// Wait for thte boomer to be on the ground, then explode it
// 		CreateTimer(0.1, WaitToExplodeNecroTankerBoomerRockThrow, bot, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
// 	}
// }

// Action WaitToExplodeNecroTankerBoomerRockThrow(Handle timer, any iClient)
// {
// 	// NecroTanker boomer throw
// 	if(IsPlayerAlive(iClient) == false || GetEntProp(iClient, Prop_Send, "m_zombieClass") != BOOMER)
// 	{
// 		if (IsFakeClient(iClient)) KickClient(iClient);
// 		return Plugin_Stop;
// 	}
	
// 	//PrintToChatAll("FL_ONGROUND: %i", (GetEntityFlags(iClient) & FL_ONGROUND));
// 	if ((GetEntityFlags(iClient) & FL_ONGROUND))
// 	{
// 		float xyzBoomerExplosionVector[3];
// 		GetClientEyePosition(iClient, xyzBoomerExplosionVector);
// 		//PrintToChatAll("xyzBoomerExplosionVector %f, %f, %f", xyzBoomerExplosionVector[0],xyzBoomerExplosionVector[1],xyzBoomerExplosionVector[2]);
// 		//PrintToChatAll("Exploding iClient %i", iClient);
// 		ForcePlayerSuicide(iClient);
// 		if (IsFakeClient(iClient)) KickClient(iClient);

// 		for (new target = 1; target <= MaxClients; target++)
// 		{
// 			if(IsClientInGame(target) && IsPlayerAlive(target) && g_iClientTeam[target] == TEAM_SURVIVORS)
// 			{
// 				//PrintToChatAll("trying for %N", target);
// 				float targetVector[3];
// 				GetClientEyePosition(target, targetVector);
// 				//PrintToChatAll("targetVector %f, %f, %f", targetVector[0],targetVector[1],targetVector[2]);
// 				float distance = GetVectorDistance(targetVector, xyzBoomerExplosionVector);
// 				//PrintToChatAll("distance: %f", distance);
// 				if(IsVisibleTo(xyzBoomerExplosionVector, targetVector) == true && distance < 175.0)
// 				{
// 					//PrintToChatAll("%N is in range", target);
// 					DealDamage(target, iClient, 3);
// 					SDKCall(g_hSDK_VomitOnPlayer, target, iClient, true);
// 				}
// 			}
// 		}

// 		return Plugin_Stop;
// 	}

// 	return Plugin_Continue;
// }

CreateNecroTankerRockDestroyEffect(int iRockEntity)
{
	float xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);
	xyzRockPosition[2] -= 20.0;
	
	//Create particle
	WriteParticle(iRockEntity, "boomer_explode", 0.0, 6.0, xyzRockPosition);

	// Player Boomer Explode noise
	EmitSoundToAll(SOUND_BOOMER_EXPLODE, iRockEntity, SNDCHAN_AUTO, SNDLEVEL_GUNFIRE, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzRockPosition, NULL_VECTOR, true, 0.0);
}

BileEveryoneCloseToExplodingNecroTankerTankRock(iRockEntity)
{
	if (RunEntityChecks(iRockEntity) == false)
		return;

	// Get the rock location
	float xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);

	// Find the tank rock entity in the list that will be used to gain Tank's ID
	new iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iRockEntity, TANK_ROCK_ENTITY_ID);
	// Get the Tank's ID, the Boomer rock's thrower
	new iTank = g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_OWNER_ID)

	for(new iClient=1; iClient <= MaxClients; iClient++)
	{
		if(RunClientChecks(iClient) &&
			IsPlayerAlive(iClient) &&
			g_iClientTeam[iClient] == TEAM_SURVIVORS)
		{
			// Get the survivor player location
			float xyzSurvivorPosition[3];
			GetClientAbsOrigin(iClient, xyzSurvivorPosition);
			//Check if player is within the radius
			// Get the distance
			float fDistance = GetVectorDistance(xyzSurvivorPosition, xyzRockPosition, false);
			//Bile if they are close enough
			if(fDistance <= 200.0)
			{
				SDKCall(g_hSDK_VomitOnPlayer, iClient, iTank, true);

				// Roll the dice for Big or Small
				new iBigOrSmall = GetRandomFloat(0.0, 1.0) <= NECROTANKER_ENHANCE_CI_CHANCE_THROW ? CI_SMALL_OR_BIG_RANDOM : CI_SMALL_OR_BIG_NONE;
				// Roll the dice for an Enhanced CI properties
				new iEnhancedCISpecifiedType = GetRandomFloat(0.0, 1.0) <= NECROTANKER_ENHANCE_CI_CHANCE_THROW ? ENHANCED_CI_TYPE_RANDOM : ENHANCED_CI_TYPE_NONE;

				// Delayed Spawn the CI around the player
				SpawnCIAroundPlayerDelayed(iClient, 0.1, 3, UNCOMMON_CI_NONE, iBigOrSmall, iEnhancedCISpecifiedType);
			}
		}
	}
}

CreateNecroTankerRockTrailEffect(int iRockEntity)
{
	float xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);

	// Play a random sound effect name from the the boomer throw selection
	new iRandomSoundNumber = GetRandomInt(0 ,sizeof(SOUND_BOOMER_THROW) - 1);
	// Play it twice because its to quiet (super dirty, but what do)
	EmitAmbientSound(SOUND_BOOMER_THROW[ iRandomSoundNumber ], xyzRockPosition, iRockEntity, SNDLEVEL_GUNFIRE);
	EmitAmbientSound(SOUND_BOOMER_THROW[ iRandomSoundNumber ], xyzRockPosition, iRockEntity, SNDLEVEL_GUNFIRE);
}

void SummonNecroTankerCrouchAndWalkAbility(iClient, bool bEnhancedCI)
{
	// Get a location in front of the player to spawn the infected to prevent collision with others
	float xyzLocation[3], xyzAngles[3];
	// Set a random distance in front of the player
	GetLocationVectorInfrontOfClient(iClient, xyzLocation, xyzAngles, GetRandomFloat(60.0, 81.0));
	// Offset X and Y also
	xyzLocation[0] += GetRandomFloat(-30.0, 30.0);
	xyzLocation[1] += GetRandomFloat(-30.0, 30.0);
	
	// Check if the NecroTanker is close enough to the survivors for the summoned zombies
	// to not disappear.  They wont disappear right away, you can set the mob timer on the
	// entity before the disappear happens, they will run and not be removed at any distance.
	// However, we want to keep them from mobbing if they are close enough, so the NecroTanker
	// can consume them without chasing.  Perhaps, if consume is changed to not be a slow punch
	// this check can be removed entirely and can mob at 2 seconds everytime.

	// Scrath all of this, they disappear seemingly randomly even if they are within range.
	// So, just set it to 2.0 no matter what.
	float fTimeToWaitForMob = 2.0;//FindClosestSurvivorDistance(iClient) > 1500.0 ? 2.0 : 2.0;

	int iZombie = -1;
	if (bEnhancedCI == false)
	{
		iZombie = SpawnCommonInfected(xyzLocation, 1, UNCOMMON_CI_NONE, CI_SMALL_OR_BIG_NONE, ENHANCED_CI_TYPE_NONE, true, fTimeToWaitForMob);
	}
	else
	{
		new iUncommonAndEnhancedChanceRoll = GetRandomInt(1,100);
		if (iUncommonAndEnhancedChanceRoll <= 25)
			iZombie = SpawnCommonInfected(xyzLocation, 1, UNCOMMON_CI_RANDOM, CI_SMALL_OR_BIG_RANDOM, ENHANCED_CI_TYPE_RANDOM, true, fTimeToWaitForMob);
		else if (iUncommonAndEnhancedChanceRoll <= 75)
			iZombie = SpawnCommonInfected(xyzLocation, 1, UNCOMMON_CI_NONE, CI_SMALL_OR_BIG_RANDOM, ENHANCED_CI_TYPE_RANDOM, true, fTimeToWaitForMob);
		else if (iUncommonAndEnhancedChanceRoll <= 100)
			iZombie = SpawnCommonInfected(xyzLocation, 1, UNCOMMON_CI_NONE, CI_SMALL_OR_BIG_NONE, ENHANCED_CI_TYPE_RANDOM, true, fTimeToWaitForMob);
	}
	

	// Create the effect on the summoned common infected
	if (iZombie > 0)
	{
		// Play a random sound effect name from the several zombie slices
		EmitSoundToAll(SOUND_ZOMBIE_SLASHES[ GetRandomInt(0 ,sizeof(SOUND_ZOMBIE_SLASHES) - 1) ], iZombie, SNDCHAN_AUTO, SNDLEVEL_TRAIN, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzLocation, NULL_VECTOR, true, 0.0);

		// Show the particle effect
		WriteParticle(iZombie, "vomit_jar_b", 0.0, 2.0);
	}

	g_iNecroTankerManaPool[iClient] -= bEnhancedCI ? NECROTANKER_MANA_COST_SUMMON_ENHANCED_CI : NECROTANKER_MANA_COST_SUMMON_NORMAL_CI;
	// Clamp it
	if (g_iNecroTankerManaPool[iClient] < 0)
		g_iNecroTankerManaPool[iClient] = 0;
	// Remove rock throw ability if no mana
	if (g_iNecroTankerManaPool[iClient] < NECROTANKER_MANA_COST_BOOMER_THROW)
		SetSIAbilityCooldown(iClient, 99999.0);
}

void SummonNecroTankerPunchZombies(iAttackerTank, iVictim)
{
	if (RunClientChecks(iAttackerTank) == false || 
		RunClientChecks(iVictim) == false ||
		IsIncap(iVictim) == true)
		return;
	
	int iRoll = GetRandomInt(1,100);
	
	// Testing different rolls
	//iRoll = 20;

	//Dont spawn anything
	if (iRoll > 70)
		return;
	
	// Spawn CI around victim
	if (iRoll > 35 && iRoll <= 70)
	{
		// Roll the dice for Big or Small
		new iBigOrSmall = GetRandomFloat(0.0, 1.0) <= NECROTANKER_ENHANCE_CI_CHANCE_PUNCH ? CI_SMALL_OR_BIG_RANDOM : CI_SMALL_OR_BIG_NONE;
		// Roll the dice for an Enhanced CI properties
		new iEnhancedCISpecifiedType = GetRandomFloat(0.0, 1.0) <= NECROTANKER_ENHANCE_CI_CHANCE_PUNCH ? ENHANCED_CI_TYPE_RANDOM : ENHANCED_CI_TYPE_NONE;

		SpawnCIAroundPlayerDelayed(iVictim, 1.0, 6, UNCOMMON_CI_NONE, iBigOrSmall, iEnhancedCISpecifiedType);
		return;
	}

	// Spawn CI and UI around player
	if (iRoll > 10 && iRoll <= 35)
	{
		// Roll the dice for Big or Small
		int iBigOrSmall = GetRandomFloat(0.0, 1.0) <= NECROTANKER_ENHANCE_CI_CHANCE_PUNCH ? CI_SMALL_OR_BIG_RANDOM : CI_SMALL_OR_BIG_NONE;
		// Roll the dice for an Enhanced CI properties
		int iEnhancedCISpecifiedType = GetRandomFloat(0.0, 1.0) <= NECROTANKER_ENHANCE_CI_CHANCE_PUNCH ? ENHANCED_CI_TYPE_RANDOM : ENHANCED_CI_TYPE_NONE;
		
		SpawnCIAroundPlayerDelayed(iVictim, 1.0, 5, UNCOMMON_CI_RANDOM, iBigOrSmall, iEnhancedCISpecifiedType);
		return;
	}

	// Spawn SI
	if (iRoll > 5 && iRoll <= 10)
	{
		SpawnSpecialInfected(iAttackerTank);
		return;
	}
	
	// Spawn Witch
	if (iRoll > 1 && iRoll <= 5)
	{
		SpawnSpecialInfected(iAttackerTank, INFECTED_NAME[WITCH]);
		return;
	}

	// // Spawn another tank if they roll a 1
	// if (iRoll == 1)
	// {
	// 	g_bTankStartingHealthXPModSpawn = true;
	// 	SpawnSpecialInfected(iAttackerTank, INFECTED_NAME[TANK]);
	// 	return;
	// }
}

void DisplayNecroTankerManaMeter(iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient))
		return;

	char strEntireManaMeter[556], strManaMeter[256];
	strEntireManaMeter = NULL_STRING;
	strManaMeter = NULL_STRING;

	// PrintToChatAll("g_iNecroTankerManaPool %i", RoundToCeil(g_iNecroTankerManaPool[iClient] / 3.0));
	// PrintToChatAll("NECROTANKER_MANA_POOL_SIZE %i", RoundToCeil((NECROTANKER_MANA_POOL_SIZE - 1) / 3.0));

	// Create the actual mana amount in the "progress meter"
	for(int i = 0; i < RoundToCeil(g_iNecroTankerManaPool[iClient] / 2.5); i++)
		StrCat(strManaMeter, sizeof(strManaMeter), "▓")
	// Create the rest of the string
	for(int i = RoundToCeil((NECROTANKER_MANA_POOL_SIZE - 1) / 2.5); i > RoundToCeil(g_iNecroTankerManaPool[iClient] / 2.5); i--)
		StrCat(strManaMeter, sizeof(strManaMeter), "░")

	Format(strEntireManaMeter, sizeof(strEntireManaMeter), "%s\n(%i/%i Mana)", strManaMeter, g_iNecroTankerManaPool[iClient], NECROTANKER_MANA_POOL_SIZE);
	PrintHintText(iClient, strEntireManaMeter);
}