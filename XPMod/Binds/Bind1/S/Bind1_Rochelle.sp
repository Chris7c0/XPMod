void Bind1Press_Rochelle(iClient)
{
	if (RunClientChecks(iClient) == false || 
		IsFakeClient(iClient) == true ||
		IsClientGrappled(iClient) || 
		IsIncap(iClient) == true ||
		g_bIsClientDown[iClient] == true ||
		g_iSmokeLevel[iClient] == 0 ||
		g_bTalentsConfirmed[iClient] == false ||
		canchangemovement[iClient] == false)
		return;

	if (g_bUsingTongueRope[iClient] == true)
	{
		DisableNinjaRope(iClient);
		return;
	}

	if (g_bHasDemiGravity[iClient] == true)
	{
		PrintHintText(iClient,"Smoker Tongue Rope cannot be used while weighted down by Demi Goo");
		return;
	}

	if (g_iRochelleRopeDurability[iClient] <= ROCHELLE_ROPE_DEPLOYMENT_COST)
	{
		PrintRochelleRopeDurability(iClient);
		return;
	}

	DeployNinjaRope(iClient);
}

void DeployNinjaRope(int iClient) 
{
	float xyzClientLocation[3], xyzClientAngles[3];
	GetClientEyePosition(iClient,xyzClientLocation); // Get the position of the player's ATTACH_EYES
	GetClientEyeAngles(iClient,xyzClientAngles); // Get the angle the player is looking
	TR_TraceRayFilter(xyzClientLocation,xyzClientAngles,MASK_ALL,RayType_Infinite,TraceRayTryToHit); // Create a ray that tells where the player is looking
	TR_GetEndPosition(g_xyzRopeEndLocation[iClient]); // Get the end xyz coordinate of where a player is looking

	float fRopeDistance = GetVectorDistance(xyzClientLocation,g_xyzRopeEndLocation[iClient], false);
	fRopeDistance *= 0.08;
	if(fRopeDistance > (float(g_iSmokeLevel[iClient]) * ROCHELLE_ROPE_MAX_DISTANCE_FT_PER_LEVEL))
	{
		PrintHintText(iClient, "Smoker Tongue Rope doesn't reach beyond %.0f ft.", (float(g_iSmokeLevel[iClient]) * ROCHELLE_ROPE_MAX_DISTANCE_FT_PER_LEVEL));
		return;
	}

	// Enable the rope
	g_bUsingTongueRope[iClient]=true;
	g_bUsedTongueRope[iClient] = true;
	EmitSoundToAll(SOUND_HOOKGRAB, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);	// Emit sound from the end of the rope
	SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);

	// Create the visual rope
	CreateSmokerTongueNinjaRope(iClient);

	// Pay the deployment cost
	g_iRochelleRopeDurability[iClient] -= ROCHELLE_ROPE_DEPLOYMENT_COST;

	// Show the durability change to the player immediately
	PrintRochelleRopeDurability(iClient);
}

void DisableNinjaRope(int iClient, bool bPlaySound = true)
{
	if (g_bUsingTongueRope[iClient] == false)
		return;

	g_bUsingTongueRope[iClient]=false;
	KillAllNinjaRopeEntities(iClient);

	if (bPlaySound && 
		RunClientChecks(iClient) && 
		IsPlayerAlive(iClient))
		EmitSoundToAll(SOUND_HOOKRELEASE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);	// Emit sound from the end of the rope
}

void CreateSmokerTongueNinjaRope(int iClient)
{
	float xyzLocation[3];
	g_iRochelleRopeDummyEntityAttachmentHand[iClient] = CreateDummyEntity(xyzLocation, -1.0, iClient, "muzzle_flash");
	g_iRochelleRopeDummyEntityAttachmentWall[iClient] = CreateDummyEntity(g_xyzRopeEndLocation[iClient]);
	
	CreateBeamEntity(
		g_iRochelleRopeDummyEntityAttachmentHand[iClient], 
		g_iRochelleRopeDummyEntityAttachmentWall[iClient],
		g_iSprite_SmokerTongue,
		125, 125, 125, 255,
		60.0,
		3.0,
		3.0);
}

void KillAllNinjaRopeEntities(int iClient)
{
	KillEntitySafely(g_iRochelleRopeDummyEntityAttachmentWall[iClient]);
	KillEntitySafely(g_iRochelleRopeDummyEntityAttachmentHand[iClient]);
}

void OnGameFrame_HandleNinjaRope(int iClient, int buttons)
{
	if (g_iSmokeLevel[iClient] == 0)
		return;

	HandleGettingUpFromLedge(iClient, buttons)
	
	// Disable Rope if grappled
	if (g_bUsingTongueRope[iClient] &&
		IsClientGrappled(iClient) == true)
		DisableNinjaRope(iClient);

	// Check if they have returned to the ground and reset movement type
	if (g_bUsingTongueRope[iClient] == false &&
		g_bUsedTongueRope[iClient]==true &&
		canchangemovement[iClient] == true &&
		g_bIsHighJumping[iClient] == false &&
		GetEntityFlags(iClient) & FL_ONGROUND)
	{
		SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
		g_bUsedTongueRope[iClient] = false;
	}

	// Make sure they are using rope from this point on
	if (g_bUsingTongueRope[iClient] == false)
		return;


	if(g_bHasDemiGravity[iClient] == true)
	{
		DisableNinjaRope(iClient);
		return;
	}

	HandleRochelleNinjaRopeMovement(iClient, buttons);
	
}

void HandleGettingUpFromLedge(int iClient, int iButtons)
{
	// If Rochelle isnt hanging from ledge then store her health for later
	if (clienthanging[iClient] == false)
	{
		preledgehealth[iClient] = GetClientHealth(iClient);
		preledgebuffer[iClient] = GetEntDataFloat(iClient,g_iOffset_HealthBuffer);
		return;
	}

	// Check if pushing the button to get up from ledge
	if (!(iButtons & IN_SPEED))
		return;

	// Get them up grom ledge
	RunCheatCommand(iClient, "give", "give health");

	// Restore health to preledge health
	SetPlayerHealth(iClient, preledgehealth[iClient]);
	if(preledgebuffer[iClient] > 1.1)
		SetEntDataFloat(iClient,g_iOffset_HealthBuffer, (preledgebuffer[iClient] - 1.0) ,true);
	else
		SetEntDataFloat(iClient,g_iOffset_HealthBuffer, 0.0 ,true);
	
	// Reset the values
	g_bIsClientDown[iClient] = false;
	clienthanging[iClient] = false;
}

HandleRochelleNinjaRopeMovement(iClient, iButtons)
{
	float clientloc[3];
	GetClientAbsOrigin(iClient,clientloc);
	if(g_xyzRopeEndLocation[iClient][2] < (clientloc[2] + 50.0))
		return;
	
	float velocity[3], velocity2[3];
	velocity2[0] = (g_xyzRopeEndLocation[iClient][0] - clientloc[0]) * 3.0;
	velocity2[1] = (g_xyzRopeEndLocation[iClient][1] - clientloc[1]) * 3.0;
	new Float:y_coord,Float:x_coord;
	y_coord = velocity2[0]*velocity2[0] + velocity2[1]*velocity2[1];
	//x_coord=(GetConVarFloat(cvarRopeSpeed)*20.0)/SquareRoot(y_coord);
	x_coord = (10.0) / (SquareRoot(y_coord));
	
	GetEntDataVector(iClient, g_iOffset_VecVelocity, velocity);
	velocity[0] += velocity2[0] * x_coord;
	velocity[1] += velocity2[1] * x_coord;
	
	// Limit the speed velocity for x and y
	if(velocity[0] < 0.0)		
	{
		if(velocity[0] < -300.0)
			velocity[0] = -300.0;
	}
	else if(velocity[0] > 300.0)
		velocity[0] = 300.0;
	if(velocity[1] < 0.0)
	{
		if(velocity[1] < -300.0)
			velocity[1] = -300.0;
	}
	else if(velocity[1] > 300.0)
		velocity[1] = 300.0;
	
	// This is to counter act the falling rate (z).
	velocity[2] = 33.333333;	
	
	// Check the distance
	float fDistance = GetVectorDistance(clientloc,g_xyzRopeEndLocation[iClient], false);
	fDistance *= 0.08;
	//PrintHintText(iClient, "Rope Distance = %f", fDistance);
	if(fDistance > ((float(g_iSmokeLevel[iClient]) * ROCHELLE_ROPE_MAX_DISTANCE_FT_PER_LEVEL) + 5.0))
	{
		// PrintHintText(iClient, "Smoker Tongue Rope does not reach beyond %.0f ft.", (float(g_iSmokeLevel[iClient]) * ROCHELLE_ROPE_MAX_DISTANCE_FT_PER_LEVEL));
		velocity[0] *= -0.5;	//Somehow slowly bring to stop to smoothen it
		velocity[1] *= -0.5;
		if(g_xyzRopeEndLocation[iClient][2] > (clientloc[2] + 100.0))
			velocity[2] = 175.0;
	}
	
	if(iButtons & IN_JUMP)
	{
		if(g_xyzRopeEndLocation[iClient][2] > (clientloc[2] + 100.0))
			velocity[2] = 175.0;
	}
	else if(iButtons & IN_DUCK)
	{
		if(fDistance < ((float(g_iSmokeLevel[iClient])*40.0) + 5.0))
			velocity[2] = -230.0;
	}
	
	//PrintHintText(iClient, "velocity = %.1f, %.1f, %f      Rope Distance = %.1f", velocity[0], velocity[1], velocity[2], fDistance);
	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, velocity);

	if(g_iRochelleRopeDurability[iClient] <= 0)
	{
		DisableNinjaRope(iClient);
		PrintRochelleRopeDurability(iClient);
		return;
	}

	g_iRochelleRopeDurability[iClient]--;
	
	// Print the durability every half second
	if(g_iRochelleRopeDurability[iClient] % 15 == 0)
		PrintRochelleRopeDurability(iClient);
}

void HandleRochelleRopeGain(iClient)
{
	if (g_bUsingTongueRope[iClient] == true ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iSmokeLevel[iClient] == 0)
		return;
	
	if (g_iRochelleRopeDurability[iClient] >= ROCHELLE_ROPE_MAX_DURABILITY)
		return;

	// Give more rope time
	g_iRochelleRopeDurability[iClient] = g_iRochelleRopeDurability[iClient] + ROCHELLE_ROPE_REGEN_PER_2_SEC_TICK  >= ROCHELLE_ROPE_MAX_DURABILITY ?
		ROCHELLE_ROPE_MAX_DURABILITY :
		g_iRochelleRopeDurability[iClient] + ROCHELLE_ROPE_REGEN_PER_2_SEC_TICK;

	PrintRochelleRopeDurability(iClient);
}


void PrintRochelleRopeDurability(iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient))
		return;
    
    // Print fuel level only if not doing wrecking ball charge
	if (g_iSmokeLevel[iClient] == 0)
		return;
    
	decl String:strEntireHintTextString[556], String:strDurabilityMeter[256];
	strEntireHintTextString = NULL_STRING;
	strDurabilityMeter = NULL_STRING;

    // Create the actual fuel amount in the "progress meter"
	for(int i = 0; i < RoundToCeil(g_iRochelleRopeDurability[iClient] / 20.0); i++)
		StrCat(strDurabilityMeter, sizeof(strDurabilityMeter), "▓")
	// Create the rest of the string to fill in the progress meter
	for(int i = RoundToCeil((ROCHELLE_ROPE_MAX_DURABILITY - 1) / 20.0); i > RoundToCeil(g_iRochelleRopeDurability[iClient] / 20.0); i--)
		StrCat(strDurabilityMeter, sizeof(strDurabilityMeter), "░")

	Format(strEntireHintTextString, sizeof(strEntireHintTextString), "%s\n%i Seconds\n|%s|",
		g_iRochelleRopeDurability[iClient] < ROCHELLE_ROPE_DEPLOYMENT_COST ? "Durability Depleted!": "Smoker Tongue Rope",
		RoundToNearest(g_iRochelleRopeDurability[iClient] / 30.0),
		strDurabilityMeter);
	PrintHintText(iClient, strEntireHintTextString);
}