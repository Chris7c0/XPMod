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
	if (g_bSmokerInSmokeCloudLimbo[iClient] == true)
	{
		TurnBackToSmokerAfterSmokeCloud(iClient);
		return;
	}

	if(g_iClientBindUses_1[iClient] >= 3)
	{
		PrintHintText(iClient, "You are out of Bind 1 uses.");
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
}


TurnSmokerIntoSmokeCloud(int iClient)
{
	// SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);

	g_bSmokerIsSmokeCloud[iClient] = true;
	g_bSmokerInSmokeCloudLimbo[iClient] = false;

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

	g_iSmokerSmokeCloudVictimCount[iClient] = 0;
	g_iSmokerSmokeCloudTicksUsed[iClient] = 0;
	g_iSmokerSmokeCloudTicksPool[iClient] = SMOKER_SMOKE_CLOUD_TICK_COUNT_STARTING_POOL;
	

	delete g_hTimer_HandleSmokerSmokeCloudTick[iClient];
	g_hTimer_HandleSmokerSmokeCloudTick[iClient] = CreateTimer(SMOKER_SMOKE_CLOUD_TICK_RATE, TimerHandleSmokerSmokeCloudTick, iClient, TIMER_REPEAT);

	if (RunClientChecks(iClient) == true && 
		IsPlayerAlive(iClient) == true && 
		IsFakeClient(iClient) == false)
		PrintHintText(iClient, "You're Now A Smoke Cloud.");

	// SetPlayerHealth(iClient, 30000);
}

TurnBackToSmokerAfterSmokeCloud(int iClient)
{
	g_bSmokerIsSmokeCloud[iClient] = false;
	g_bSmokerInSmokeCloudLimbo[iClient] = false;

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
		g_iInfectedCharacter[iClient] == SMOKER)
	{
		PrintHintText(iClient, "Returned to Smoker form.");
	}
}

PutSmokerWithExpiredSmokeCloudIntoLimbo(int iClient)
{
	g_bSmokerInSmokeCloudLimbo[iClient] = true;
	g_bSmokerIsSmokeCloud[iClient] = false;

	// Display the first message
	if (g_iInfectedCharacter[iClient] == SMOKER &&
		g_iClientTeam[iClient] == TEAM_INFECTED &&
		RunClientChecks(iClient) == true &&
		IsPlayerAlive(iClient) == true)
	{
		PrintHintText(iClient, "Smoke Cloud Dissipated.\n\nGet to a safe place then press Bind 1 again to return back to Smoker form.");
		PrintToChat(iClient, "\x03[XPMod] \x04Get to a safe place then press Bind 1 again to return back to Smoker form.");
	}

	CreateTimer(5.0, TimerHandleSmokerInSmokeCloudLimbo, iClient, TIMER_REPEAT);
}

Action TimerHandleSmokerInSmokeCloudLimbo(Handle:timer, int iClient)
{
	if (g_iInfectedCharacter[iClient] != SMOKER ||
		g_iClientTeam[iClient] != TEAM_INFECTED ||
		g_bSmokerInSmokeCloudLimbo[iClient] == false ||
		RunClientChecks(iClient) == false ||
		g_bIsGhost[iClient] == true ||
		IsPlayerAlive(iClient) == false)
	{
		TurnBackToSmokerAfterSmokeCloud(iClient)
		SetAllPlayersNotInSmokerCloud();
		
		return Plugin_Stop;
	}
	else
	{
		PrintHintText(iClient, "Smoke Cloud Dissipated.\n\nGet to a safe place then press Bind 1 again to return back to Smoker form.");
	}

	return Plugin_Continue;
}

Action TimerHandleSmokerSmokeCloudTick(Handle:timer, int iClient)
{
	if (g_iInfectedCharacter[iClient] != SMOKER ||
		g_bSmokerIsSmokeCloud[iClient] == false ||
		RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iSmokerSmokeCloudTicksUsed[iClient] >= g_iSmokerSmokeCloudTicksPool[iClient])
	{
		if (g_iInfectedCharacter[iClient] == SMOKER && 
			RunClientChecks(iClient) == true &&
			IsPlayerAlive(iClient) == true)
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

	// Add the ticks used to the used amount
	g_iSmokerSmokeCloudTicksUsed[iClient] += SMOKER_SMOKE_CLOUD_TICK_USE_RATE;

	// Display current victim count, remaining ticks, and the duration
	// Wait for x ticks before showing to allow hint text to pop up
	if (IsFakeClient(iClient) == false && g_iSmokerSmokeCloudTicksUsed[iClient] > SMOKER_SMOKE_CLOUD_TICK_USE_RATE * 10)
		PrintHintText(iClient, "%i Victims\nCloud Remaining: %0.1fs\nDuration: %0.1fs", 
			g_iSmokerSmokeCloudVictimCount[iClient],
			(g_iSmokerSmokeCloudTicksPool[iClient] - g_iSmokerSmokeCloudTicksUsed[iClient]) * SMOKER_SMOKE_CLOUD_TICK_RATE / SMOKER_SMOKE_CLOUD_TICK_USE_RATE,
			g_iSmokerSmokeCloudTicksUsed[iClient] * SMOKER_SMOKE_CLOUD_TICK_RATE / SMOKER_SMOKE_CLOUD_TICK_USE_RATE);

	// Create a new smoke cloud particle after 1 second
	if (g_iSmokerSmokeCloudTicksUsed[iClient] % (SMOKER_SMOKE_CLOUD_TICK_USE_RATE * 10) == 0)
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
				GetEntProp(iPlayer, Prop_Send, "m_isIncapacitated") == 1 ||
				IsClientGrappled(iPlayer) == true)
				continue;
		} // Handle checks players that were already in the cloud
		else
		{
			// Add the appropriate amount of smoke cloud ticks to the player's pool
			if (g_iClientTeam[iPlayer] == TEAM_SURVIVORS && 
				g_iSmokerSmokeCloudTicksPool[iClient] < SMOKER_SMOKE_CLOUD_TICK_COUNT_MAX_POOL_SIZE)
				g_iSmokerSmokeCloudTicksPool[iClient] += IsFakeClient(iPlayer) ? 
					SMOKER_SMOKE_CLOUD_TICK_GAIN_PER_SURVIVOR_BOT : 
					SMOKER_SMOKE_CLOUD_TICK_GAIN_PER_SURVIVOR_PLAYER;

			// Disable the cloud if they are no longer a valid target
			if (RunClientChecks(iPlayer) == false || 
				IsPlayerAlive(iPlayer) == false ||
				GetEntProp(iPlayer, Prop_Send, "m_isIncapacitated") == 1 ||
				IsClientGrappled(iPlayer) == true)
			{
				SetPlayerNotInSmokerCloud(iPlayer, iClient);
				continue;
			}
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
	
	SetClientSpeed(iClient);
	HackTargetPlayersControls(iClient, 60.0, false, true);
	
	// Add for the victim counter displayed to the smoker
	if (RunClientChecks(iSmoker)) g_iSmokerSmokeCloudVictimCount[iSmoker]++;
}

void SetPlayerNotInSmokerCloud(int iClient, int iSmoker = 0)
{
	g_bIsPlayerInSmokerSmokeCloud[iClient] = false;

	// The rest of this function only handle survivor tasks
	if (g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;
	
	SetClientSpeed(iClient);
	// Disable movement and random sound effects
	g_bIsPLayerHacked[iClient] = false;

	// Remove for the victim counter displayed to the smoker
	if (RunClientChecks(iSmoker)) g_iSmokerSmokeCloudVictimCount[iSmoker]--;
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
		// Convert some survivor health to temp health
		ConvertSomeSurvivorHealthToTemporary(iClient, SMOKER_SMOKE_CLOUD_TEMP_HEALTH_CONVERSION_PER_TICK);

		// Temp Blind the player
		ShowHudOverlayColor(iClient, 5, 255, 50, GetRandomInt(SMOKER_SMOKE_CLOUD_BLIND_AMOUNT_MIN,SMOKER_SMOKE_CLOUD_BLIND_AMOUNT_MAX), 1000, FADE_OUT);
	}
	else if (g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		// Give the infected some health for being in the smoker cloud
		SetPlayerHealth(iClient, SMOKER_SMOKE_CLOUD_INFECTED_HEAL_RATE_PER_TICK, true);

		// Temp Blind the player
		ShowHudOverlayColor(iClient, 255, 5, 50, 50, 1000, FADE_OUT);
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
		50, 255, 100, 	// Color of smoke
		255,			// How Opaque
		1,				// Gap in the middle
		100,			// Speed the smoke moves outwards
		100,			// Speed the smoke moves up
		200,			// Amount of smoke created
		400,			// Smoke jets outside of the original
		20,				// Amount of global twisting
		200,			// Color
		10,				// Transparency
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