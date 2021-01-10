LoadNecroTankerTalents(iClient)
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
	
	g_iTankChosen[iClient] = TANK_NECROTANKER;
	
	//Give Health
	SetEntProp(iClient, Prop_Data,"m_iMaxHealth", TANK_HEALTH_NECROTANKER);
	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	SetEntProp(iClient, Prop_Data,"m_iHealth", iCurrentHealth + TANK_HEALTH_NECROTANKER - 6000);
	
	//Set Movement Speed
	//g_fClientSpeedBoost[iClient] += 0.2;
	//fnc_SetClientSpeed(iClient);
	
	//Change Skin Color
	SetEntityRenderMode(iClient, RenderMode:0);
	SetEntityRenderColor(iClient, 0, 130, 0, 255);

	// Create Effects
	CreateNecroTankerTrailEffect(iClient);
	WriteParticle(iClient, "boomer_vomit_infected", 0.0, 999.0);
	
	PrintHintText(iClient, "You are now the NecroTanker");
}

OnGameFrame_Tank_NecroTanker(iClient)
{	
	new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	
	//Check to see if ducking and not attacking before starting the charge
	if((buttons & IN_DUCK) && !(buttons & IN_ATTACK2)) // && !(buttons & IN_ATTACK)
	{
		CheckIfTankMovedWhileChargingAndIncrementCharge(iClient);

		//Display the first message to the player while he is charging up
		if(g_iTankCharge[iClient] == 30)
			PrintHintText(iClient, "Spawning Infected");
		
		//Charged for long enough, now handle for each tank
		if(g_iTankCharge[iClient] >= 31)
		{
			// Get a location in front of the player to spawn the infected to prevent collision with others
			decl Float:xyzLocation[3], Float:xyzAngles[3];
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
			new Float:fTimeToWaitForMob = 2.0;//FindClosestSurvivorDistance(iClient) > 1500.0 ? 2.0 : 2.0;

			new iZombie = -1;
			new iUncommonChanceRoll = GetRandomInt(1,100);
			if (iUncommonChanceRoll <= 20)
				iZombie = SpawnRandomCommonInfectedMob(xyzLocation, 1, true, fTimeToWaitForMob);
			else
				iZombie = SpawnRandomCommonInfectedMob(xyzLocation, 1, false, fTimeToWaitForMob);

			// Create the effect on the summoned common infected
			if (iZombie > 0)
			{
				// Play a random sound effect name from the several zombie slices
				EmitSoundToAll(SOUND_ZOMBIE_SLASHES[ GetRandomInt(0 ,sizeof(SOUND_ZOMBIE_SLASHES) - 1) ], iZombie, SNDCHAN_AUTO, SNDLEVEL_TRAIN, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzLocation, NULL_VECTOR, true, 0.0);

				// Show the particle effect
				WriteParticle(iZombie, "vomit_jar_b", 0.0, 2.0);
			}
				
			
			g_iTankCharge[iClient] = 0;
		}
	}
	else if(g_iTankCharge[iClient] > 0)
	{
		if(g_iTankCharge[iClient] > 31)
			PrintHintText(iClient, " ");
		
		g_iTankCharge[iClient] = 0;
	}
}

EventsHurt_TankVictim_NecroTanker(iVictimTank, iDmgType, iDmgHealth)
{
	SuppressNeverUsedWarning(iVictimTank, iDmgType, iDmgHealth);
}

HandleNecroTankerInfectedConsumption(iClient, iInfectedEntity)
{
	//Check if player is NecroTanker
	if(g_iTankChosen[iClient] != TANK_NECROTANKER ||
		g_iClientTeam[iClient] != TEAM_INFECTED ||
		RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) == true ||
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
	new iCurrentMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	if (iCurrentMaxHealth < NECROTANKER_MAX_HEALTH)
	{
		// Add it, Cap it, Set it
		new iNewHealth = iCurrentMaxHealth + iAdditionalHealth > NECROTANKER_MAX_HEALTH ? NECROTANKER_MAX_HEALTH : iCurrentMaxHealth + iAdditionalHealth;
		SetEntProp(iClient, Prop_Data,"m_iMaxHealth", iNewHealth);
	}
	// Check if should increase health
	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	if (iCurrentHealth < NECROTANKER_MAX_HEALTH)
	{
		// Add it, Cap it, Set it
		new iNewHealth = iCurrentHealth + iAdditionalHealth > NECROTANKER_MAX_HEALTH ? NECROTANKER_MAX_HEALTH : iCurrentHealth + iAdditionalHealth;
		SetEntProp(iClient, Prop_Data,"m_iHealth", iNewHealth);
	}
}

CreateNecroTankerTrailEffect(int iClient)
{
	new Float:xyzTankPosition[3];
	GetClientAbsOrigin(iClient, xyzTankPosition);
	xyzTankPosition[2] += 30.0;
	new String:vecString[32];
	Format(vecString, sizeof(vecString), "%f %f %f", xyzTankPosition[0], xyzTankPosition[1], xyzTankPosition[2]);

	g_iPID_IceTankTrail[iClient] = CreateEntityByName("env_smokestack");
	
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"Origin", vecString);
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"BaseSpread", "0");		//Gap in the middle
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"SpreadSpeed", "20");	//Speed the smoke moves outwards
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"Speed", "5");			//The speed at which the smoke particles move after they're spawned
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"StartSize", "35");
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"EndSize", "70");
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"Rate", "5");			//Amount of smoke created
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"JetLength", "20");		//Smoke jets outside of the original
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"Twist", "3"); 			//Amount of global twisting
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"RenderColor", "0 200 20");
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"RenderAmt", "50");		//Transparency
	DispatchKeyValue(g_iPID_IceTankTrail[iClient],"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
	
	
	SetVariantString("!activator");
	AcceptEntityInput(g_iPID_IceTankTrail[iClient], "SetParent", iClient, g_iPID_IceTankTrail[iClient], 0);

	DispatchSpawn(g_iPID_IceTankTrail[iClient]);
	AcceptEntityInput(g_iPID_IceTankTrail[iClient], "TurnOn");
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
	

// 	new Float:velocity[3];
// 	new g_iVelocity = FindSendPropInfo("CBasePlayer", "m_vecVelocity[0]");	
// 	GetEntDataVector(iTankRockEntity, g_iVelocity, velocity);

// 	new bot = CreateFakeClient("Boomer");
// 	if (bot > 0)
// 	{
// 		SpawnSpecialInfected(bot, BOOMER, true);
// 		new Float:Pos[3];
// 		GetEntPropVector(iTankRockEntity, Prop_Send, "m_vecOrigin", Pos);	
// 		//RemoveEntity(iTankRockEntity);
// 		AcceptEntityInput(iTankRockEntity, "Kill");
// 		NormalizeVector(velocity, velocity);
// 		new Float:speed = GetConVarFloat(FindConVar("z_tank_throw_force"));
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

// public Action:WaitToExplodeNecroTankerBoomerRockThrow(Handle:timer, any:iClient)
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
// 		decl Float:xyzBoomerExplosionVector[3];
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
// 				decl Float:targetVector[3];
// 				GetClientEyePosition(target, targetVector);
// 				//PrintToChatAll("targetVector %f, %f, %f", targetVector[0],targetVector[1],targetVector[2]);
// 				new Float:distance = GetVectorDistance(targetVector, xyzBoomerExplosionVector);
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
	new Float:xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);
	xyzRockPosition[2] -= 20.0;
	
	//Create particle
	WriteParticle(iRockEntity, "boomer_explode", 0.0, 6.0, xyzRockPosition);

	// Player Boomer Explode noise
	EmitSoundToAll(SOUND_BOOMER_EXPLODE, iRockEntity, SNDCHAN_AUTO, SNDLEVEL_GUNFIRE, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzRockPosition, NULL_VECTOR, true, 0.0);
}

BileEveryoneCloseToExplodingNecroTankerTankRock(iRockEntity)
{
	// Get the rock location
	new Float:xyzRockPosition[3];
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
			new Float:xyzSurvivorPosition[3];
			GetClientAbsOrigin(iClient, xyzSurvivorPosition);
			//Check if player is within the radius
			// Get the distance
			new Float:fDistance = GetVectorDistance(xyzSurvivorPosition, xyzRockPosition, false);
			//Bile if they are close enough
			if(fDistance <= 200.0)
				SDKCall(g_hSDK_VomitOnPlayer, iClient, iTank, true);
		}
	}
}

CreateNecroTankerRockTrailEffect(int iRockEntity)
{
	new Float:xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);

	// Play a random sound effect name from the the boomer throw selection
	new iRandomSoundNumber = GetRandomInt(0 ,sizeof(SOUND_BOOMER_THROW) - 1);
	// Play it twice because its to quiet (super dirty, but what do)
	EmitAmbientSound(SOUND_BOOMER_THROW[ iRandomSoundNumber ], xyzRockPosition, iRockEntity, SNDLEVEL_GUNFIRE);
	EmitAmbientSound(SOUND_BOOMER_THROW[ iRandomSoundNumber ], xyzRockPosition, iRockEntity, SNDLEVEL_GUNFIRE);
}