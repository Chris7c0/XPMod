void Bind2Press_Charger(iClient)
{
	if (g_iClientInfectedClass1[iClient] != CHARGER && g_iClientInfectedClass2[iClient] != CHARGER && g_iClientInfectedClass3[iClient] != CHARGER)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You dont have the Charger as one of your classes");
		return;
	}

	if (g_iHillbillyLevel[iClient] == 0)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You must have a Hillbilly Madness for Charger Bind 2");
		return;
	}

	if (g_iClientBindUses_2[iClient] >= 3)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You are out of Bind 2 uses");
		return;
	}

	if (g_bCanChargerEarthquake[iClient] == false)
	{
		PrintHintText(iClient, "You must wait for the 30 second cooldown on Earthquake before reuse");
		return;
	}

	g_bIsHillbillyEarthquakeReady[iClient] = true;
	PrintHintText(iClient, "Punch an object to trigger an earthquake!");
}

void HandleChargerEarthquake(int iClient, int iButtons)
{
	if (g_bIsHillbillyEarthquakeReady[iClient] == false || g_bCanChargerEarthquake[iClient] == false || !(iButtons & IN_ATTACK2) || g_iInfectedCharacter[iClient] != CHARGER)
		return;

	float xyzClientPosition[3], xyzClientEyeAngles[3], xyzRayTraceEndLocation[3];
	GetClientEyePosition(iClient, xyzClientPosition);
	GetClientEyeAngles(iClient, xyzClientEyeAngles);	// Get the angle the player is looking

	TR_TraceRayFilter(xyzClientPosition, xyzClientEyeAngles, MASK_ALL, RayType_Infinite, TraceRayTryToHit);	   // Create a ray that tells where the player is looking
	TR_GetEndPosition(xyzRayTraceEndLocation);																   // Get the end xyz coordinate of where a player is looking

	// Check this distance the player is to where they are "punching" to see if this should be triggered
	if (GetVectorDistance(xyzClientPosition, xyzRayTraceEndLocation) > 100.0)
		return;

	// Create the earthquake effect and sound
	EmitSoundToAll(SOUND_EXPLODE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzClientPosition, NULL_VECTOR, true, 0.0);

	// Create the earthquake effect
	TE_Start("BeamRingPoint");
	TE_WriteVector("m_vecCenter", xyzClientPosition);
	TE_WriteFloat("m_flStartRadius", 10.0);
	TE_WriteFloat("m_flEndRadius", 1000.0);
	TE_WriteNum("m_nModelIndex", g_iSprite_Laser);
	TE_WriteNum("m_nHaloIndex", g_iSprite_Halo);
	TE_WriteNum("m_nStartFrame", 0);
	TE_WriteNum("m_nFrameRate", 60);
	TE_WriteFloat("m_fLife", 0.5);
	TE_WriteFloat("m_fWidth", 100.0);
	TE_WriteFloat("m_fEndWidth", 5.0);
	TE_WriteFloat("m_fAmplitude", 0.5);
	TE_WriteNum("r", 20);
	TE_WriteNum("g", 20);
	TE_WriteNum("b", 20);
	TE_WriteNum("a", 200);
	TE_WriteNum("m_nSpeed", 10);
	TE_WriteNum("m_nFlags", 0);
	TE_WriteNum("m_nFadeLength", 0);
	TE_SendToAll();

	// Checking if there are survivors close enough to the blast and shaking them
	for (int iTarget = 1; iTarget <= MaxClients; iTarget++)
	{
		if (IsClientInGame(iTarget) == false || IsPlayerAlive(iTarget) == false || g_iClientTeam[iTarget] != TEAM_SURVIVORS || IsIncap(iTarget) == true)
			continue;

		float xyzTargetLocation[3];
		GetClientEyePosition(iTarget, xyzTargetLocation);

		// First make sure they are visible to the charger
		if (IsVisibleTo(xyzClientPosition, xyzTargetLocation) == false)
			continue;

		// Next do the first distance check for players in damage range
		if (GetVectorDistance(xyzTargetLocation, xyzClientPosition) > CHARGER_EARTHQUAKE_DISTANCE_SHOCKWAVE_DAMAGE)
			continue;

		// Hurt the player
		DealDamage(iTarget, iClient, RoundToCeil(g_iHillbillyLevel[iClient] * 2.5));

		// Do the last distance check for players in fling range
		if (GetVectorDistance(xyzTargetLocation, xyzClientPosition) > CHARGER_EARTHQUAKE_DISTANCE_STAGGER)
			continue;

		// Shake the victims screen
		Handle hShakeMessage;
		hShakeMessage = StartMessageOne("Shake", iTarget);

		BfWriteByte(hShakeMessage, 0);
		BfWriteFloat(hShakeMessage, 40.0);	  // Intensity
		BfWriteFloat(hShakeMessage, 10.0);
		BfWriteFloat(hShakeMessage, 3.0);	 // Time?
		EndMessage();

		// Stagger the player by flinging them
		SDKCall(g_hSDK_Fling, iTarget, EMPTY_VECTOR, 96, iClient, 3.0);
	}

	g_bIsHillbillyEarthquakeReady[iClient] = false;
	g_iClientBindUses_2[iClient]++;

	// Set cooldown
	g_bCanChargerEarthquake[iClient] = false;
	CreateTimer(30.0, TimerEarthquakeCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
}