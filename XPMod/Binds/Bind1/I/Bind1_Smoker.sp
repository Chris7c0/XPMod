void Bind1Press_Smoker(iClient)
{
	if (g_iClientInfectedClass1[iClient] != SMOKER && 
		g_iClientInfectedClass2[iClient] != SMOKER &&
		g_iClientInfectedClass3[iClient] != SMOKER)
	{
		PrintHintText(iClient, "You dont have the Smoker as one of your classes");
		return;
	}

	// If the player has an expired smoke cloud and needs to turn back into smoker (in limbo)
	if (g_iSmokerInSmokeCloudLimbo == iClient)
	{
		TurnBackToSmokerAfterSmokeCloud(iClient);
		return;
	}

	if(g_iClientBindUses_1[iClient] >= 3)
	{
		PrintHintText(iClient, "You are out of Bind 1 uses.");
		return;
	}

	if(g_bSmokerSmokeCloudInCooldown == true)
	{
		PrintHintText(iClient, "Global cooldown triggered. You must wait to use the Smoke Cloud.");
		return;
	}

	if (g_iSmokerTalent2Level[iClient] <= 0)
	{
		PrintHintText(iClient, "You are not high enough level for Smoker Bind 1");
		return;
	}

	if (g_iChokingVictim[iClient] > 0)
	{
		PrintHintText(iClient, "You cannot turn into smoke while choking a victim");
		return;
	}

	TurnSmokerIntoSmokeCloud(iClient);

	g_iClientBindUses_1[iClient]++;

	// Create the cooldown
	g_bSmokerSmokeCloudInCooldown = true;
	CreateTimer(SMOKER_SMOKE_CLOUD_GLOBAL_COOLDOWN_DURATION, Timer_SmokerSmokeCloudCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
}


TurnSmokerIntoSmokeCloud(int iClient)
{
	// SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);

	g_iSmokerSmokeCloudPlayer = iClient;
	g_iSmokerInSmokeCloudLimbo = -1;
	g_iSmokerSmokeCloudStage = 1

	// Disable the Smoker's teleport
	g_bTeleportCoolingDown[iClient] = true;

	// Stop Melee Attacking
	LockPlayerFromAttacking(iClient);

	SetPlayerMoveType(iClient, MOVETYPE_NOCLIP);

	SetEntProp(iClient, Prop_Send, "m_bDrawViewmodel", 0);

	// PrintToChatAll("m_CollisionGroup %i", GetEntProp(iClient, Prop_Data, "m_CollisionGroup"));
	// PrintToChatAll("m_usSolidFlags %i", GetEntProp(iClient, Prop_Data, "m_usSolidFlags"));
	// PrintToChatAll("m_nSolidType %i", GetEntProp(iClient, Prop_Data, "m_nSolidType"));

	// SetEntProp(iClient, Prop_Data, "m_CollisionGroup", 1);
	// SetEntProp(iClient, Prop_Data, "m_usSolidFlags", 4);
	SetEntProp(iClient, Prop_Send, "m_nSolidType", 0);

	SetClientSpeed(iClient);

	SetClientRenderAndGlowColor(iClient);

	CreateSmokerSmokeCloudParticle(iClient);

	g_iSmokerSmokeCloudVictimCount = 0;
	g_iSmokerSmokeCloudTicksUsed = 0;
	g_iSmokerSmokeCloudTicksPool = SMOKER_SMOKE_CLOUD_TICK_COUNT_STARTING_POOL;
	

	delete g_hTimer_HandleSmokerSmokeCloudTick[iClient];
	g_hTimer_HandleSmokerSmokeCloudTick[iClient] = CreateTimer(SMOKER_SMOKE_CLOUD_TICK_RATE, TimerHandleSmokerSmokeCloudTick, iClient, TIMER_REPEAT);

	if (RunClientChecks(iClient) == true && 
		IsPlayerAlive(iClient) == true && 
		IsFakeClient(iClient) == false)
		PrintHintText(iClient, "You're Now A Smoke Cloud.");

	// SetPlayerHealth(iClient, 30000);
}

// This is for if the smoker is able to attack or something happens while in smoke cloud or limbo, return them.
ReturnSmokerFromSmokeCloudIfCurrentlySmokeCloud(iClient)
{
	if (g_iSmokerSmokeCloudPlayer != iClient && 
		g_iSmokerInSmokeCloudLimbo != iClient)
		return;

	TurnBackToSmokerAfterSmokeCloud(iClient);
}

TurnBackToSmokerAfterSmokeCloud(int iClient)
{
	g_iSmokerSmokeCloudPlayer = -1;
	g_iSmokerInSmokeCloudLimbo = -1;

	// Enable the Smoker's teleport
	g_bTeleportCoolingDown[iClient] = false;

	// Allow Melee Attacking
	UnlockPlayerFromAttacking(iClient);

	// Check if the player is alive before continuing
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return;

	SetPlayerMoveType(iClient, MOVETYPE_WALK);

	SetEntProp(iClient, Prop_Send, "m_bDrawViewmodel", 1);

	// SetEntProp(iClient, Prop_Data, "m_CollisionGroup", 5);
	// SetEntProp(iClient, Prop_Data, "m_usSolidFlags", 16);
	SetEntProp(iClient, Prop_Send, "m_nSolidType", 2);

	SetClientSpeed(iClient);

	SetClientRenderAndGlowColor(iClient);

	if (RunClientChecks(iClient) == true && 
		IsPlayerAlive(iClient) == true && 
		IsFakeClient(iClient) == false &&
		g_iInfectedCharacter[iClient] == SMOKER &&
		GetEntData(iClient, g_iOffset_IsGhost, 1) != 1)
	{
		PrintHintText(iClient, "Returned to Smoker form.");
	}
}

PutSmokerWithExpiredSmokeCloudIntoLimbo(int iClient)
{
	g_iSmokerInSmokeCloudLimbo = iClient;
	g_iSmokerSmokeCloudPlayer = iClient;

	// Display the first message
	if (g_iInfectedCharacter[iClient] == SMOKER &&
		g_iClientTeam[iClient] == TEAM_INFECTED &&
		RunClientChecks(iClient) == true &&
		IsPlayerAlive(iClient) == true)
	{
		PrintHintText(iClient, "Smoke Cloud Dissipated.\n\nGet to a safe place then press Bind 1 again to return back to Smoker form.");
		PrintToChat(iClient, "\x03[XPMod] \x04Get to a safe place then press Bind 1 again to return back to Smoker form.");
	}

	g_iSmokeCloudLimboTicks[iClient] =  0;
	CreateTimer(5.0, TimerHandleSmokerInSmokeCloudLimbo, iClient, TIMER_REPEAT);
}

Action TimerHandleSmokerInSmokeCloudLimbo(Handle:timer, int iClient)
{
	if (g_iSmokeCloudLimboTicks[iClient] == 3 ||
		g_iInfectedCharacter[iClient] != SMOKER ||
		g_iClientTeam[iClient] != TEAM_INFECTED ||
		g_iSmokerInSmokeCloudLimbo != iClient ||
		RunClientChecks(iClient) == false ||
		GetEntData(iClient, g_iOffset_IsGhost, 1) == 1 ||
		IsPlayerAlive(iClient) == false)
	{
		TurnBackToSmokerAfterSmokeCloud(iClient)
		SetAllPlayersNotInSmokerCloud();
		
		return Plugin_Stop;
	}
	else
	{
		g_iSmokeCloudLimboTicks[iClient]++;

		PrintHintText(iClient, "Get to a safe place then press Bind 1 again to return back to Smoker form.\
			\n\nYou will be automatically returned in %i seconds.",
			20 - g_iSmokeCloudLimboTicks[iClient] * 5);
	}

	return Plugin_Continue;
}

Action TimerHandleSmokerSmokeCloudTick(Handle:timer, int iClient)
{
	if (g_iInfectedCharacter[iClient] != SMOKER ||
		g_iSmokerSmokeCloudPlayer != iClient ||
		RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		GetEntData(iClient, g_iOffset_IsGhost, 1) == 1 ||
		g_iSmokerSmokeCloudTicksUsed >= g_iSmokerSmokeCloudTicksPool)
	{
		if (g_iInfectedCharacter[iClient] == SMOKER && 
			RunClientChecks(iClient) == true &&
			IsPlayerAlive(iClient) == true &&
			GetEntData(iClient, g_iOffset_IsGhost, 1) != 1)
			// Set player in limbo if they are the Smoker still and are still valid and alive
			PutSmokerWithExpiredSmokeCloudIntoLimbo(iClient);
		else
			// Otherwise disable or revert all the smoker cloud changes
			TurnBackToSmokerAfterSmokeCloud(iClient)
		
		SetAllPlayersNotInSmokerCloud();
		
		g_hTimer_HandleSmokerSmokeCloudTick[iClient] = null;
		return Plugin_Stop;
	}

	HandlePlayersInSmokeCloud(iClient);
	HandleEntitiesInSmokerCloudRadius(iClient, SMOKER_SMOKE_CLOUD_RADIUS);

	// Add the ticks used to the used amount
	g_iSmokerSmokeCloudTicksUsed += SMOKER_SMOKE_CLOUD_TICK_USE_RATE;

	// Display current victim count, remaining ticks, and the duration
	// Wait for x ticks before showing to allow hint text to pop up
	if (IsFakeClient(iClient) == false && g_iSmokerSmokeCloudTicksUsed > SMOKER_SMOKE_CLOUD_TICK_USE_RATE * 10)
		PrintHintText(iClient, "%i Victim%s        Stage %i\nCloud Remaining: %0.1fs\nDuration: %0.1fs",
			g_iSmokerSmokeCloudVictimCount,
			g_iSmokerSmokeCloudVictimCount == 1 ? "" : "s",
			g_iSmokerSmokeCloudStage,
			(g_iSmokerSmokeCloudTicksPool - g_iSmokerSmokeCloudTicksUsed) * SMOKER_SMOKE_CLOUD_TICK_RATE / SMOKER_SMOKE_CLOUD_TICK_USE_RATE,
			g_iSmokerSmokeCloudTicksUsed * SMOKER_SMOKE_CLOUD_TICK_RATE / SMOKER_SMOKE_CLOUD_TICK_USE_RATE);

	// Create a new smoke cloud particle after 1 second
	if (g_iSmokerSmokeCloudTicksUsed % (SMOKER_SMOKE_CLOUD_TICK_USE_RATE * 10) == 0)
		CreateSmokerSmokeCloudParticle(iClient);

	return Plugin_Continue;
}

void HandlePlayersInSmokeCloud(int iClient)
{
	float xyzClientLocation[3];
	GetClientAbsOrigin(iClient, xyzClientLocation);

	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (iPlayer == iClient)
			continue;

		// Handle checks for players that were previously not in the cloud
		if (g_bIsPlayerInSmokerSmokeCloud[iPlayer] == false)
		{
			// Check for a valid target
			if (RunClientChecks(iPlayer) == false || 
				IsPlayerAlive(iPlayer) == false ||
				IsIncap(iPlayer) == true ||
				IsClientGrappled(iPlayer) == true)
				continue;
		} // Handle checks players that were already in the cloud
		else
		{
			// Disable the cloud if they are no longer a valid target
			if (RunClientChecks(iPlayer) == false || 
				IsPlayerAlive(iPlayer) == false ||
				IsIncap(iPlayer) == true ||
				IsClientGrappled(iPlayer) == true)
			{
				SetPlayerNotInSmokerCloud(iPlayer, iClient);
				continue;
			}

			// Add the appropriate amount of smoke cloud ticks to the player's pool
			if (g_iClientTeam[iPlayer] == TEAM_SURVIVORS && 
				g_iSmokerSmokeCloudTicksPool < SMOKER_SMOKE_CLOUD_TICK_COUNT_MAX_POOL_SIZE)
				g_iSmokerSmokeCloudTicksPool += IsFakeClient(iPlayer) ? 
					SMOKER_SMOKE_CLOUD_TICK_GAIN_PER_SURVIVOR_BOT : 
					SMOKER_SMOKE_CLOUD_TICK_GAIN_PER_SURVIVOR_PLAYER;
		}

		// Handle check for distance from Smoker Cloud to target
		float xyzPlayerLocation[3];
		GetClientAbsOrigin(iPlayer, xyzPlayerLocation);

		//PrintToChatAll("distance: %f ", GetVectorDistance(xyzClientLocation, xyzPlayerLocation, false));

		//Check if the player is in range of the client that is tangled
		if (GetVectorDistance(xyzClientLocation, xyzPlayerLocation, false) <= SMOKER_SMOKE_CLOUD_RADIUS)
		{
			// They are a valid target in the cloud. If they are new in the cloud, set them up
			if (g_bIsPlayerInSmokerSmokeCloud[iPlayer] == false)
				SetPlayerInSmokerCloud(iPlayer, iClient);
		}
		else
		{
			// Not in the smoker cloud, if were previously in the cloud remove them from the effects
			if (g_bIsPlayerInSmokerSmokeCloud[iPlayer] == true)
				SetPlayerNotInSmokerCloud(iPlayer, iClient);
		}		
	}
}

void SetPlayerInSmokerCloud(int iClient, int iSmoker = 0)
{
	g_bIsPlayerInSmokerSmokeCloud[iClient] = true;

	CreateTimer(SMOKER_SMOKE_CLOUD_TARGETED_PLAYER_TICK_RATE, TimerHandleSmokerCloudTickOnPlayer, iClient, TIMER_REPEAT);
	
	// The rest of this function only handle survivor tasks
	if (g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;
	
	// Add for the victim counter displayed to the smoker
	if (RunClientChecks(iSmoker)) g_iSmokerSmokeCloudVictimCount++;
}

void SetPlayerNotInSmokerCloud(int iClient, int iSmoker = 0)
{
	g_bIsPlayerInSmokerSmokeCloud[iClient] = false;

	// The rest of this function only handle survivor tasks
	if (g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;

	// Remove for the victim counter displayed to the smoker
	if (RunClientChecks(iSmoker)) g_iSmokerSmokeCloudVictimCount--;
}

void SetAllPlayersNotInSmokerCloud()
{
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
		SetPlayerNotInSmokerCloud(iPlayer);
}

Action:TimerHandleSmokerCloudTickOnPlayer(Handle:timer, int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bIsPlayerInSmokerSmokeCloud[iClient] == false)
		return Plugin_Stop;

	if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
	{
		// Temp Blind the player
		ShowHudOverlayColor(iClient, 40, 51, 1, GetRandomInt(SMOKER_SMOKE_CLOUD_BLIND_AMOUNT_MIN,SMOKER_SMOKE_CLOUD_BLIND_AMOUNT_MAX), 1300, FADE_OUT);

		// Handle spawning entities on directly on players
		SmokerSmokeCloudSpawnCIOnPlayer(iClient);
	}
	else if (g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		// Give the infected some health for being in the smoker cloud
		SetPlayerHealth(iClient, SMOKER_SMOKE_CLOUD_INFECTED_HEAL_RATE_PER_TICK, true);

		// Temp Blind the player
		ShowHudOverlayColor(iClient, 255, 5, 50, 50, 1300, FADE_OUT);
	}

	return Plugin_Continue;
}

CreateSmokerSmokeCloudParticle(iClient)
{
	float xyzPosition[3];
	CreateSmokeParticle(
		iClient,		// Target to attach to
		xyzPosition,	// Position to create it 0,0,0 will force getting client location
		true,
		"smoker_mouth",
		40, 51, 1, 		// Color of smoke
		150,			// How Opaque
		1,				// Gap in the middle
		100,			// Speed the smoke moves outwards
		100,			// Speed the smoke moves up
		1300,			// Original Size
		1500,			// End Size
		20,				// Amount of smoke created
		RoundToNearest(SMOKER_SMOKE_CLOUD_RADIUS),			// Smoke jets outside of the original
		10,				// Amount of global twisting
		1.5				// Duration (-1.0 is never destroy)
	);
}

// UpdateSmokerSmokeCloudParticleLocation(iClient)
// {
// 	if (RunClientChecks(iClient) == false ||
// 		RunEntityChecks(g_iSmokerSmokeCloudParticleEntity[iClient]) == false)
// 		return;

// 	float xyzPosition[3];
// 	GetClientEyePosition(iClient, xyzPosition);
// 	TeleportEntity(g_iSmokerSmokeCloudParticleEntity[iClient], EMPTY_VECTOR, EMPTY_VECTOR, EMPTY_VECTOR);

// 	SetVariantString("!activator");
// 	AcceptEntityInput(g_iSmokerSmokeCloudParticleEntity[iClient], "SetParent", iClient, g_iSmokerSmokeCloudParticleEntity[iClient], 0);
// }

void HandleEntitiesInSmokerCloudRadius(int iClient, float fRadius)
{
	char strClassName[32];
	float xyzEntityLocation[3], xyzClientLocation[3];
	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", xyzClientLocation);

	SetSmokerCloudSmokeStage();

	for (int iEntity=1; iEntity < MAXENTITIES; iEntity++)
	{
		if (IsValidEntity(iEntity) == false)
			continue;

		// Any entities needed will have vecOrigin property so check for that first
		if (HasEntProp(iEntity, Prop_Send, "m_vecOrigin") == false)
			continue;

		// Get the radius location and check how far away the entity is before continuing
		GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", xyzEntityLocation);
		if (GetVectorDistance(xyzClientLocation, xyzEntityLocation) > fRadius)
			continue;

		strClassName = "";
		GetEntityClassname(iEntity, strClassName, 32);
		// PrintToServer("HandleEntitiesInSmokerCloudRadius: i: %i, className = %s", iEntity, strClassName)

		// Handle putting out molotov or other sources of fires and projectiles
		if (StrEqual(strClassName, "inferno", true) ||					// Molotov and gascan
			StrEqual(strClassName, "pipe_bomb_projectile", true) ||		// Pipe bomb
			StrEqual(strClassName, "info_goal_infected_chase", true))	// Bile Jar
		{
			KillEntitySafely(iEntity);
			continue;
		}
		
		// Handle CI that are not already enhanced
		// Check the CI is still alive, by checking health and also
		// importantly if the CI is a ragdoll because health can not
		// go to 0 and they are still dead in the game.
		if (IsCommonInfected(iEntity, strClassName) && 
			GetEntProp(iEntity, Prop_Data, "m_iHealth") > 0 &&
			GetEntProp(iEntity, Prop_Data, "m_bClientSideRagdoll") == 0)
		{
			ExtinguishEntity(iEntity);

			// Find if the Enhanced CI entity in the list
			int iEnhancedCIIndex = FindIndexInArrayListUsingValue(g_listEnhancedCIEntities, iEntity, ENHANCED_CI_ENTITY_ID);
			// If the Enhanced CI is in the list, move on and continue the search
			if (iEnhancedCIIndex >= 0)
				continue;

			// PrintToChatAll("%i) iHealth = %i", iEntity, GetEntProp(iEntity, Prop_Data, "m_iHealth"));
			// PrintToChatAll("%i) m_bClientSideRagdoll = %i", iEntity, GetEntProp(iEntity, Prop_Data, "m_bClientSideRagdoll"));
			// PrintToChatAll("fDistance = %f", GetVectorDistance(xyzClientLocation, xyzEntityLocation));
			// PrintToChatAll("%f, %f, %f", xyzEntityLocation[0], xyzEntityLocation[1], xyzEntityLocation[2]);

			SetEntProp(iEntity, Prop_Data, "m_iHealth", 0); 

			switch (g_iSmokerSmokeCloudStage)
			{
				case 1:	SpawnCIAroundLocation(xyzEntityLocation, 1, UNCOMMON_CI_NONE, CI_SMALL_OR_BIG_NONE, ENHANCED_CI_TYPE_RANDOM, 0.1);
				case 2:	SpawnCIAroundLocation(xyzEntityLocation, 1, UNCOMMON_CI_NONE, CI_SMALL_OR_BIG_RANDOM, ENHANCED_CI_TYPE_RANDOM, 0.1);
				case 3:	SpawnCIAroundLocation(xyzEntityLocation, 1, UNCOMMON_CI_RANDOM, CI_REALLY_SMALL, ENHANCED_CI_TYPE_RANDOM, 0.1);
			}
		}
	}
}

void SmokerSmokeCloudSpawnCIOnPlayer(int iClient)
{
	if (RunClientChecks(g_iSmokerSmokeCloudPlayer) == false ||
		g_bSmokeCloudVictimCanCISpawnOn[iClient] == false)
		return;

	g_bSmokeCloudVictimCanCISpawnOn[iClient] = false;
	CreateTimer(SMOKER_SMOKE_CLOUD_SPAWN_CI_ON_PLAYER_INTERVAL, TimerResetCanSmokerSmokeCloudSpawnCIOnPlayer, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	SetSmokerCloudSmokeStage();

	switch(g_iSmokerSmokeCloudStage)
	{
		case 1:	SpawnCIAroundPlayer(iClient, SMOKER_SMOKE_CLOUD_SPAWN_CI_ON_PLAYER_AMOUNT_S1, UNCOMMON_CI_NONE, CI_SMALL_OR_BIG_NONE, ENHANCED_CI_TYPE_RANDOM);
		case 2: SpawnCIAroundPlayer(iClient, SMOKER_SMOKE_CLOUD_SPAWN_CI_ON_PLAYER_AMOUNT_S2, UNCOMMON_CI_NONE, CI_SMALL_OR_BIG_RANDOM, ENHANCED_CI_TYPE_RANDOM);
		case 3:
		{
			// Roll for a chance to spawn enlarged jimmy
			if (GetRandomInt(1, 100) <= SMOKER_SMOKE_CLOUD_SPAWN_CI_S3_JIMMY_CHANCE)
				SpawnCIAroundPlayer(iClient, 1, UNCOMMON_CI_JIMMY, CI_REALLY_BIG_JIMMY, ENHANCED_CI_TYPE_RANDOM);
			else
				SpawnCIAroundPlayer(iClient, SMOKER_SMOKE_CLOUD_SPAWN_CI_ON_PLAYER_AMOUNT_S3, UNCOMMON_CI_RANDOM, CI_REALLY_BIG, ENHANCED_CI_TYPE_RANDOM);	
		}
	}
		
}

Action TimerResetCanSmokerSmokeCloudSpawnCIOnPlayer(Handle hTimer, int iClient)
{
	g_bSmokeCloudVictimCanCISpawnOn[iClient] = true;
	return Plugin_Stop;
}

int SetSmokerCloudSmokeStage()
{
	switch (g_iSmokerSmokeCloudStage)
	{
		case 1: if (g_iSmokerSmokeCloudTicksUsed >= SMOKER_SMOKE_CLOUD_USAGE_STAGE_2) g_iSmokerSmokeCloudStage = 2;
		case 2: if (g_iSmokerSmokeCloudTicksUsed >= SMOKER_SMOKE_CLOUD_USAGE_STAGE_3) g_iSmokerSmokeCloudStage = 3;
	}

	return g_iSmokerSmokeCloudStage;
}