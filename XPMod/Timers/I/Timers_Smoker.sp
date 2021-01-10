//Smoker
public Action:TimerStopInfection(Handle:timer, any:iClient)
{
	g_bIsSmokeInfected[iClient] = false;
	
	if(IsValidEntity(g_iSmokerInfectionCloudEntity[iClient]))
	{
		//StopSound(g_iSmokerInfectionCloudEntity[iClient], SNDCHAN_AUTO, SOUND_FLIES);	//didnt work
		//StopSound(iClient, SNDCHAN_AUTO, SOUND_FLIES);
		
		decl String:entclass[16];
		GetEntityNetClass(g_iSmokerInfectionCloudEntity[iClient], entclass, 16);
		if(StrEqual(entclass,"CSmokeStack",true)==true)
		{
			//DispatchKeyValue(g_iSmokerInfectionCloudEntity[iClient],"Rate", "0");
			//AcceptEntityInput(g_iSmokerInfectionCloudEntity[iClient], "TurnOn");
			CreateTimer(6.0, TimerRemoveSmoke, g_iSmokerInfectionCloudEntity[iClient], TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	
	return Plugin_Stop;
}

public Action:TimerRemoveSmoke(Handle:timer, any:entity)
{
	if(IsValidEntity(entity))	//check if is actually smoke too
	{
		decl String:entclass[16];
		GetEntityNetClass(entity, entclass, 16);
		if(StrEqual(entclass,"CSmokeStack",true)==true)
		{
			RemoveEdict(entity);
		}
	}
	
	return Plugin_Stop;
}

public Action:TimerMoveSmokePoof1(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient) == false)
		return Plugin_Stop;
	
	if(IsValidEntity(g_iSmokerInfectionCloudEntity[iClient]))
	{
		decl Float:xyzOrigin[3], Float:xyzAngles[3];
		GetLocationVectorInfrontOfClient(iClient, xyzOrigin, xyzAngles, 50.0, -25.0);
		
		TeleportEntity(g_iSmokerInfectionCloudEntity[iClient], xyzOrigin, NULL_VECTOR, NULL_VECTOR);
		AcceptEntityInput(g_iSmokerInfectionCloudEntity[iClient], "TurnOff");
		CreateTimer(0.1, TimerMoveSmokePoof2, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
	
	return Plugin_Stop;
}

public Action:TimerMoveSmokePoof2(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient) == false)
		return Plugin_Stop;
	
	if(IsValidEntity(g_iSmokerInfectionCloudEntity[iClient]))
	{
		decl Float:xyzOrigin[3], Float:xyzAngles[3];
		GetLocationVectorInfrontOfClient(iClient, xyzOrigin, xyzAngles, 50.0, -25.0);
		
		TeleportEntity(g_iSmokerInfectionCloudEntity[iClient], xyzOrigin, NULL_VECTOR, NULL_VECTOR);
		AcceptEntityInput(g_iSmokerInfectionCloudEntity[iClient], "TurnOn");
		CreateTimer(0.1, TimerMoveSmokePoof1, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
	
	return Plugin_Stop;
}

public Action:TimerElectricuteAgain(Handle:timer, any:iClient)
{
	if (g_bIsElectricuting[iClient] == false || 
		RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false || 
		g_iChokingVictim[iClient] < 1 ||
		IsClientInGame(g_iChokingVictim[iClient]) ||
		IsPlayerAlive(g_iChokingVictim[iClient]))
	{
		g_bIsElectricuting[iClient] = false;
		
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
	
	DealDamage(g_iChokingVictim[iClient], iClient, g_iNoxiousLevel[iClient]);
	
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
			
			DealDamage(i , iClient, RoundToCeil((g_iNoxiousLevel[iClient] * 0.5)));
			
			g_iClientXP[iClient] += 10;
			CheckLevel(iClient);
			
			if(g_iXPDisplayMode[iClient] == 0)
				ShowXPSprite(iClient, g_iSprite_10XP_SI, i, 1.0);
		}
			
		
	}

	CreateTimer(0.5, TimerElectricuteAgain, iClient, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Stop;
}

public Action:TimerStopElectricution(Handle:timer, any:iClient)
{
	g_bIsElectricuting[iClient] = false;
	return Plugin_Stop;
}


public Action:Timer_ResetElectricuteCooldown(Handle:timer, any:iClient)
{
	g_bElectricutionCooldown[iClient] = false;
	return Plugin_Stop;
}

/*
public Action:TimerCheckTongueDistance(Handle:timer, any:Smoker)
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

public Action:TimerPoisonCloud(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient) == false || g_bHasSmokersPoisonCloudOut[iClient] == false)
		return Plugin_Stop;
	
	decl victim;
	decl Float:victimVec[3];
	decl Float:distance;
	
	for (victim = 1; victim <= MaxClients; victim++)
	{
		if((IsClientInGame(victim) == false) || (IsPlayerAlive(victim) == false) || (g_iClientTeam[victim] != TEAM_SURVIVORS))
			continue;
		
		GetClientEyePosition(victim, victimVec);
		distance = GetVectorDistance(victimVec, g_xyzPoisonCloudOriginArray[iClient]);
		
		if ((distance > 140.0) || IsVisibleTo(g_xyzPoisonCloudOriginArray[iClient], victimVec) == false) continue;
		
		if(IsFakeClient(victim) == false)
			PrintHintText(victim, "You have entered a poison cloud");
		
		DealDamage(victim, iClient, 1, DAMAGETYPE_SPITTER_GOO);
		
		g_iClientXP[iClient] += 3;
		CheckLevel(iClient);
		
		if(g_iXPDisplayMode[iClient] == 0)
			ShowXPSprite(iClient, g_iSprite_3XP_SI, victim, 1.0);
	}
	
	CreateTimer((3.0 - (g_iNoxiousLevel[iClient] * 0.25)), TimerPoisonCloud, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action:TimerStopPoisonCloud(Handle:timer, any:iClient)
{
	g_bHasSmokersPoisonCloudOut[iClient] = false;
	
	return Plugin_Stop;
}

public Action:CheckIfStuck(Handle:timer, any:iClient)
{
	decl Float:vorigin[3];
	GetClientAbsOrigin(iClient, vorigin);
	//PrintToChat(iClient, "vorigin = %f, %f, %f		endpos = %f, %f, %f", vorigin[0], vorigin[1], vorigin[2], g_fTeleportEndPositionX[iClient], g_fTeleportEndPositionY[iClient], g_fTeleportEndPositionZ[iClient]);
	if (vorigin[0] == g_fTeleportEndPositionX[iClient] && 
		vorigin[1] == g_fTeleportEndPositionY[iClient] &&
		vorigin[2] == g_fTeleportEndPositionZ[iClient])
	{
		PrintHintText(iClient, "You appear to be stuck, Teleporting you back to where you started");
		decl Float:origpos[3];
		origpos[0] = g_fTeleportOriginalPositionX[iClient];
		origpos[1] = g_fTeleportOriginalPositionY[iClient];
		origpos[2] = g_fTeleportOriginalPositionZ[iClient];
		TeleportEntity(iClient, origpos, NULL_VECTOR, NULL_VECTOR);
		WriteParticle(iClient, "teleport_warp", 0.0, 7.0);
		g_bTeleportCoolingDown[iClient] = false;
	}
	return Plugin_Stop;
}

public Action:ReallowTeleport(Handle:timer, any:iClient)
{
	g_bTeleportCoolingDown[iClient] = false;
	return Plugin_Stop;
}