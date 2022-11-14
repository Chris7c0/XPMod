void Bind1Press_Hunter(iClient)
{
	if ((g_iClientInfectedClass1[iClient] != HUNTER) && 
		(g_iClientInfectedClass2[iClient] != HUNTER) && 
		(g_iClientInfectedClass3[iClient] != HUNTER))
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You dont have the Hunter as one of your classes");
		return;
	}

	if (g_iBloodLustLevel[iClient] == 0)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You must have Blood Lust (Level 1) for Hunter Bind 1");
		return;
	}

	if (g_iClientBindUses_1[iClient] >= 3)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You are out of Bind 1 uses for this round");
		return;
	}

	if (g_bIsImmobilityZoneOnGlobalCooldown == true)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05Immobility Zone is on global cooldown");
		return;
	}

	// Check if the Hunter can be seen by any survivors
	bool bCanBeSeen;
	float fVisibleClientDistance[MAXPLAYERS+1];
	GetAllVisiblePlayersForClient(iClient, fVisibleClientDistance, TEAM_SURVIVORS);
	for(int iTarget; iTarget < MaxClients; iTarget++)
		if(fVisibleClientDistance[iTarget] > 0.0)
			bCanBeSeen = true;
	
	if (bCanBeSeen)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You must be hidden from all survivors to use Hunter Bind 1");
		return;
	}

	int iSize = RoundToNearest(HUNTER_IMMOBILITY_ZONE_RADIUS) + 50;

	// Store location of the Immobility Zone
	GetClientEyePosition(iClient, g_fHunterImmobilityZone[iClient]);

	// Create the Immobility Zone Smoke Particle
	CreateSmokeParticle(
		iClient,		// Target to attach to
		g_fHunterImmobilityZone[iClient],	// Position to create it 0,0,0 will force getting client location
		false,
		"",
		200, 51, 1, 		// Color of smoke
		255,			// How Opaque
		1,				// Gap in the middle
		100,			// Speed the smoke moves outwards
		100,			// Speed the smoke moves up
		iSize,			// Original Size
		iSize,			// End Size
		15,				// Amount of smoke created (this value 15 was tested on a 1050ti to have keep 144 fps)
		50,				// Smoke jets outside of the original
		100,				// Amount of global twisting
		HUNTER_IMMOBILITY_ZONE_DURATION				// Duration (-1.0 is never destroy)
	);

	g_iClientBindUses_1[iClient]++;
	
	CreateTimer(HUNTER_IMMOBILITY_ZONE_DURATION, RemoveHunterImmobilityZone, iClient, TIMER_FLAG_NO_MAPCHANGE);

	g_bIsImmobilityZoneOnGlobalCooldown = true;
	CreateTimer(HUNTER_IMMOBILITY_ZONE_GLOBAL_COOLDOWN, ResetGlobalHunterImmobilityZoneCooldown, _, TIMER_FLAG_NO_MAPCHANGE);
}

Action RemoveHunterImmobilityZone(Handle timer, int iClient)
{
	g_fHunterImmobilityZone[iClient] = NULL_VECTOR;
	return Plugin_Handled;
}

Action ResetGlobalHunterImmobilityZoneCooldown(Handle timer, any data)
{
	g_bIsImmobilityZoneOnGlobalCooldown = false;
	return Plugin_Handled;
}

void HandleAllSurvivorsInHunterMobilityZone(int iClient)
{
	// if (g_fHunterImmobilityZone[iClient] == NULL_VECTOR)
	// 	return;

	int iSurvivor;
	float flDistance;
	for(iSurvivor = 1; iSurvivor <= MaxClients; iSurvivor++)
	{
		if (RunClientChecks(iSurvivor) == false ||
			IsPlayerAlive(iSurvivor) == false ||
			g_iClientTeam[iSurvivor] != TEAM_SURVIVORS)
			continue;
		
		float xyzSurvivorLocation[3];
		GetClientEyePosition(iSurvivor, xyzSurvivorLocation);
		flDistance = GetVectorDistance(g_fHunterImmobilityZone[iClient], xyzSurvivorLocation, false);

		if (g_bIsInImmobilityZone[iSurvivor] == true && flDistance > HUNTER_IMMOBILITY_ZONE_RADIUS)
		{
			g_bIsInImmobilityZone[iSurvivor] = false;
			SetClientSpeed(iSurvivor);
		}
		else if(flDistance <= HUNTER_IMMOBILITY_ZONE_RADIUS)
		{
			g_bIsInImmobilityZone[iSurvivor] = true;
			SetClientSpeed(iSurvivor);
		}
	}
}