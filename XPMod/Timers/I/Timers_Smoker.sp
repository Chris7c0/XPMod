//Smoker

// Action:TimerStopTarFingersInfection(Handle:timer, any:iClient)
// {
// 	g_bIsTarFingerVictim[iClient] = false;

// 	return Plugin_Stop;
// }


// Action TimerResetTarFingerVictimBlindAmount(Handle:timer, int iClient)
// {
// 	g_iTarFingerVictimBlindAmount[iClient] = 0;
// 	// PrintToChat(iClient, "ResetTarFingerVictimBlindAmount");

// 	g_hTimer_ResetTarFingerVictimBlindAmount[iClient] = null;
// 	return Plugin_Stop;
// }


Action:TimerRemoveSmokerDoppelganger(Handle:timer, any:iEntity)
{
	KillEntitySafely(iEntity);
	return Plugin_Stop;
}

Action:TimerResetSmokerDoppelgangerCooldown(Handle:timer, any:iClient)
{
	g_bSmokerDoppelgangerCoolingDown[iClient] = false;
	return Plugin_Stop;
}

Action:TimerResetSmokerSmokeScreenCooldown(Handle:timer, any:iClient)
{
	g_bSmokerSmokeScreenOnCooldown[iClient] = false;
	return Plugin_Stop;
}

Action:Timer_SmokerSmokeCloudCooldown(Handle:timer, any:iClient)
{
	g_bSmokerSmokeCloudInCooldown = false;
	return Plugin_Stop;
}

Action:Timer_ResetElectrocuteCooldown(Handle:timer, any:iClient)
{
	g_bElectrocutionCooldown[iClient] = false;
	return Plugin_Stop;
}

/*
Action:TimerCheckTongueDistance(Handle:timer, any:Smoker)
{
	if((IsClientInGame(Smoker) == false) || (g_iClientTeam[Smoker] != TEAM_INFECTED) || (IsFakeClient(Smoker) == true) || (g_iChokingVictim[Smoker] < 1))
	{
		return Plugin_Stop;
	}
	
	new Victim = g_iChokingVictim[Smoker];
	if((IsClientInGame(Victim) == false) || (g_iClientTeam[Victim] !=  TEAM_SURVIVORS))
	{
		return Plugin_Stop;
	}
			
	new Float:SmokerPosition[3];
	new Float:VictimPosition[3];
	GetClientAbsOrigin(Smoker,SmokerPosition);
	GetClientAbsOrigin(Victim,VictimPosition);
	new distance = RoundToNearest(GetVectorDistance(SmokerPosition, VictimPosition));
	//PrintToChatAll("Distance: %i", distance);
	if (distance > (g_iMaxTongueLength * 27))
	{
		SlapPlayer(Smoker, 0, false);
		PrintHintText(Smoker, "You have stretched your tongue beyond its breaking point.");
	}
	CreateTimer(0.3, TimerCheckTongueDistance, Smoker, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}*/

Action:TimerPoisonCloud(Handle:timer, any:iClient)
{
	if (RunClientChecks(iClient) == false || 
		IsClientInGame(iClient) == false ||
		g_bHasSmokersPoisonCloudOut[iClient] == false)
		return Plugin_Stop;
	
	decl Float:xyzVictimPosition[3];
	for (new iVictim = 1; iVictim <= MaxClients; iVictim++)
	{
		if (RunClientChecks(iVictim) == false ||
			IsClientInGame(iVictim) == false ||
			IsPlayerAlive(iVictim) == false ||
			g_iClientTeam[iVictim] != TEAM_SURVIVORS ||
			IsIncap(iVictim) == true)
			continue;
		
		// Check if they are in range (removed is visible to for consistency)
		GetClientEyePosition(iVictim, xyzVictimPosition);
		if (GetVectorDistance(xyzVictimPosition, g_xyzPoisonCloudOriginArray[iClient]) > 140.0)
			// || IsVisibleTo(g_xyzPoisonCloudOriginArray[iClient], xyzVictimPosition) == false)
			continue;
		
		if(IsFakeClient(iVictim) == false)
			PrintHintText(iVictim, "You have entered a poison cloud");
		
		DealDamage(iVictim, iClient, 1, DAMAGETYPE_GENERIC);
		SetPlayerHealth(iVictim, iClient, 1, true)
		ConvertSomeSurvivorHealthToTemporary(iVictim, 2);
		
		g_iClientXP[iClient] += 3;
		CheckLevel(iClient);
		
		if (g_iXPDisplayMode[iClient] == 0)
			ShowXPSprite(iClient, g_iSprite_3XP_SI, iVictim, 1.0);
	}
	
	CreateTimer((3.0 - (g_iSmokerTalent2Level[iClient] * 0.25)), TimerPoisonCloud, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

Action:TimerStopPoisonCloud(Handle:timer, any:iClient)
{
	g_bHasSmokersPoisonCloudOut[iClient] = false;
	
	return Plugin_Stop;
}

Action:CheckIfStuck(Handle:timer, any:iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return Plugin_Stop;

	decl Float:vorigin[3];
	GetClientAbsOrigin(iClient, vorigin);

	//PrintToChat(iClient, "vorigin = %f, %f, %f		endpos = %f, %f, %f", vorigin[0], vorigin[1], vorigin[2], g_fTeleportEndPositionX[iClient], g_fTeleportEndPositionY[iClient], g_fTeleportEndPositionZ[iClient]);
	if (vorigin[0] == g_fTeleportEndPositionX[iClient] && 
		vorigin[1] == g_fTeleportEndPositionY[iClient] &&
		vorigin[2] == g_fTeleportEndPositionZ[iClient])
	{
		PrintHintText(iClient, "\x03[XPMod] \x05You appear to be stuck. Sending you back.");
		decl Float:origpos[3];
		origpos[0] = g_fTeleportOriginalPositionX[iClient];
		origpos[1] = g_fTeleportOriginalPositionY[iClient];
		origpos[2] = g_fTeleportOriginalPositionZ[iClient];
		TeleportEntity(iClient, origpos, NULL_VECTOR, NULL_VECTOR);
		WriteParticle(iClient, "teleport_warp", 0.0, 3.0);
		g_bTeleportCoolingDown[iClient] = false;
	}
	
	return Plugin_Stop;
}

Action:ReAllowTeleport(Handle:timer, any:iClient)
{
	g_bTeleportCoolingDown[iClient] = false;
	return Plugin_Stop;
}