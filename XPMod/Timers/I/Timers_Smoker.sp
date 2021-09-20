//Smoker

Action:TimerStopTarFingersInfection(Handle:timer, any:iClient)
{
	g_bIsTarFingerVictim[iClient] = false;

	return Plugin_Stop;
}


Action TimerResetTarFingerVictimBlindAmount(Handle:timer, int iClient)
{
	g_iTarFingerVictimBlindAmount[iClient] = 0;
	// PrintToChat(iClient, "ResetTarFingerVictimBlindAmount");

	g_hTimer_ResetTarFingerVictimBlindAmount[iClient] = null;
	return Plugin_Stop;
}

Action:TimerElectrocuteAgain(Handle:timer, any:iClient)
{
	if (g_bIsElectrocuting[iClient] == false || 
		RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false || 
		g_iChokingVictim[iClient] < 1 ||
		RunClientChecks(g_iChokingVictim[iClient]) == false ||
		IsPlayerAlive(g_iChokingVictim[iClient]) == false)
	{
		g_bIsElectrocuting[iClient] = false;
		
		return Plugin_Stop;
	}
	
	decl Float:clientloc[3],Float:targetloc[3];
	GetClientEyePosition(iClient,clientloc);
	GetClientEyePosition(g_iChokingVictim[iClient],targetloc);
	clientloc[2] -= 10.0;
	targetloc[2] -= 20.0;
	new rand = GetRandomInt(1, 3);
	decl String:zap[23];
	switch(rand)
	{
		case 1: zap = SOUND_ZAP1; 
		case 2: zap = SOUND_ZAP2;
		case 3: zap = SOUND_ZAP3;
	}
	new pitch = GetRandomInt(95, 130);
	EmitSoundToAll(zap, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, clientloc, NULL_VECTOR, true, 0.0);
	EmitSoundToAll(zap, g_iChokingVictim[iClient], SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, targetloc, NULL_VECTOR, true, 0.0);
	TE_SetupBeamPoints(clientloc,targetloc,g_iSprite_Laser,0,0,66,0.3, 0.5, 0.5,0,4.0,{0,40,255,200},0);
	TE_SendToAll();
	CreateParticle("electrical_arc_01_system", 0.8, g_iChokingVictim[iClient], ATTACH_EYES, true);
	
	new alpha = GetRandomInt(120,180);
	ShowHudOverlayColor(iClient, 255, 255, 255, alpha, 150, FADE_OUT);
	ShowHudOverlayColor(g_iChokingVictim[iClient], 255, 255, 255, alpha, 150, FADE_OUT);
	
	DealDamage(g_iChokingVictim[iClient], iClient, g_iSmokerTalent2Level[iClient]);
	
	g_iClientXP[iClient] += 10;
	CheckLevel(iClient);
	
	if(g_iXPDisplayMode[iClient] == 0)
		ShowXPSprite(iClient, g_iSprite_10XP_SI, g_iChokingVictim[iClient], 1.0);
	
	//Check for other players that are possible victims
	decl i;
	for(i = 1;i <= MaxClients;i++)
	{		
		if(i == g_iChokingVictim[iClient] ||
			g_iChokingVictim[iClient] < 1 || 
			IsValidEntity(i) == false || 
			IsValidEntity(g_iChokingVictim[iClient]) == false || 
			IsClientInGame(i) == false || 
			g_iClientTeam[i] != TEAM_SURVIVORS)
			continue;
		
		GetClientEyePosition(g_iChokingVictim[iClient], clientloc);
		GetClientEyePosition(i, targetloc);
		if(IsVisibleTo(clientloc, targetloc))
		{
			targetloc[2] -= 20.0;
			rand = GetRandomInt(1, 3);
			switch(rand)
			{
				case 1: zap = SOUND_ZAP1; 
				case 2: zap = SOUND_ZAP2;
				case 3: zap = SOUND_ZAP3;
			}
			pitch = GetRandomInt(95, 130);
			EmitSoundToAll(zap, i, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, targetloc, NULL_VECTOR, true, 0.0);
			TE_SetupBeamPoints(clientloc,targetloc,g_iSprite_Laser,0,0,66,0.3, 0.5, 0.5,0,4.0,{0,40,255,200},0);
			TE_SendToAll();
			CreateParticle("electrical_arc_01_system", 0.8, i, ATTACH_EYES, true);
			
			alpha = GetRandomInt(120,180);
			ShowHudOverlayColor(i, 255, 255, 255, alpha, 150, FADE_OUT);
			
			DealDamage(i , iClient, RoundToCeil((g_iSmokerTalent2Level[iClient] * 0.5)));
			
			g_iClientXP[iClient] += 10;
			CheckLevel(iClient);
			
			if(g_iXPDisplayMode[iClient] == 0)
				ShowXPSprite(iClient, g_iSprite_10XP_SI, i, 1.0);
		}
			
		
	}

	CreateTimer(0.5, TimerElectrocuteAgain, iClient, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Stop;
}


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
	g_bSmokerSmokeCloudInCooldown[iClient] = false;
	return Plugin_Stop;
}


Action:TimerStopElectrocution(Handle:timer, any:iClient)
{
	g_bIsElectrocuting[iClient] = false;
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
			g_iClientTeam[iVictim] != TEAM_SURVIVORS)
			continue;
		
		// Check if they are in range (removed is visible to for consistency)
		GetClientEyePosition(iVictim, xyzVictimPosition);
		if (GetVectorDistance(xyzVictimPosition, g_xyzPoisonCloudOriginArray[iClient]) > 140.0)
			// || IsVisibleTo(g_xyzPoisonCloudOriginArray[iClient], xyzVictimPosition) == false)
			continue;
		
		if(IsFakeClient(iVictim) == false)
			PrintHintText(iVictim, "You have entered a poison cloud");
		
		DealDamage(iVictim, iClient, 1, DAMAGETYPE_GENERIC);
		SetPlayerHealth(iVictim, 1, true)
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
	decl Float:vorigin[3];
	GetClientAbsOrigin(iClient, vorigin);
	//PrintToChat(iClient, "vorigin = %f, %f, %f		endpos = %f, %f, %f", vorigin[0], vorigin[1], vorigin[2], g_fTeleportEndPositionX[iClient], g_fTeleportEndPositionY[iClient], g_fTeleportEndPositionZ[iClient]);
	if (vorigin[0] == g_fTeleportEndPositionX[iClient] && 
		vorigin[1] == g_fTeleportEndPositionY[iClient] &&
		vorigin[2] == g_fTeleportEndPositionZ[iClient])
	{
		PrintHintText(iClient, "\x03[XPMod] \x05You appear to be stuck, Teleporting you back to where you started");
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