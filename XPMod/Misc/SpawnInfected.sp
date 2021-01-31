int  SpawnRandomCommonInfectedMob(Float:xyzLocation[3], int iAmount = 1, bool:bUncommon = false, int iEnhancedPropertiesChance = -1, Float:fTimeToWaitForMob = -1.0)
{
	xyzLocation[2] += 1;

	for(new i = 0; i < iAmount; i++)
	{
		new iZombie = CreateEntityByName("infected");
		
		// Get the number of possible models
		new iRandomModelNumber = bUncommon ? GetRandomInt(0,sizeof(UNCOMMON_INFECTED_MODELS) - 1) : GetRandomInt(0,sizeof(COMMON_INFECTED_MODELS) - 1)
		
		// If its Jimmy, roll only keep 1/3rd of the time...because way too many Jimmys up in this biyyah
		if (bUncommon && iRandomModelNumber == 0 && GetRandomInt(1,3) != 1)
			iRandomModelNumber = GetRandomInt(1,sizeof(UNCOMMON_INFECTED_MODELS) - 1);

		// Set the model, which sets the infected type, for uncommon changing behavior etc.
		if (bUncommon)
			SetEntityModel(iZombie, UNCOMMON_INFECTED_MODELS[iRandomModelNumber]);
		else
			SetEntityModel(iZombie, COMMON_INFECTED_MODELS[iRandomModelNumber]);
		
		new ticktime = RoundToNearest( GetGameTime() / GetTickInterval() ) + 5;
		SetEntProp(iZombie, Prop_Data, "m_nNextThinkTick", ticktime);
		
		// This is the wait time before they go mad and try to find survivors
		// This will also enable them to spawn outside of the director's spawn area
		// But it must be triggered before thte ttime of destroy happens (2-3secs)
		if (fTimeToWaitForMob >=0)
			CreateTimer(fTimeToWaitForMob, TimerSetMobRush, iZombie);

		// Teleport needs to happen first or problems occur.
		TeleportEntity(iZombie, xyzLocation, NULL_VECTOR, NULL_VECTOR);
		//	Activate the common infected
		ActivateEntity(iZombie);
		DispatchSpawn(iZombie);

		// Add Enhancements to the CI/UI
		// iEnhancedPropertiesChance -1 disables it here, iEnhancedPropertiesChance 0 disables Enhanced CI abilities (properties)
		if (iEnhancedPropertiesChance != -1)
			RandomlyEnhanceCommonInfected(iZombie, CI_SMALL_OR_BIG_RANDOM, iEnhancedPropertiesChance);

		// Create the FX
		// Play a random sound effect name from the several zombie slices
		EmitSoundToAll(SOUND_ZOMBIE_SLASHES[ GetRandomInt(0 ,sizeof(SOUND_ZOMBIE_SLASHES) - 1) ], iZombie, SNDCHAN_AUTO, SNDLEVEL_TRAIN, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzLocation, NULL_VECTOR, true, 0.0);
		// Show the particle effect
		WriteParticle(iZombie, "vomit_jar_b", 0.0, 2.0);

		if (iAmount == 1)
			return iZombie;
	}
	
	return -1;
}

Action:TimerSetMobRush(Handle:timer, any:iZombieEntity)
{
	if (iZombieEntity > 0 && IsValidEntity(iZombieEntity))
	{
		// Check that this entity is still an infected
		decl String:strClassname[99];
		GetEdictClassname(iZombieEntity, strClassname, sizeof(strClassname));
		if (StrEqual(strClassname, "infected", true))
			SetEntProp(iZombieEntity, Prop_Send, "m_mobRush", 1);
	}
	
	return Plugin_Stop;
}

SpawnCIAroundPlayer(iClient, iAmount = 1, bool:bChanceForUncommon = false)
{
	if (RunClientChecks(iClient) == false)
		return;

	// Get player location to spawn infected around
	decl Float:xyzLocation[3];
	GetClientAbsOrigin(iClient, xyzLocation);

	// Get the angle increments then convert to radians
	// We need it in radians so convert it by multiplying by 0.0174532925
	new Float:fAngleIncrement = (360.0 / iAmount) * 0.0174532925;

	for (new i=0; i < iAmount; i++)
	{
		// Calculate the spawn points in a circle around the player
		// Note: angle must be in radians, 
		// x = radius * cos(angle)
		// y = radius * sin(angle)
		new Float:fRadius = 50.0;
		new Float:fXOffset = (fRadius * Cosine(fAngleIncrement * i)) - (fRadius / 2);
		new Float:fYOffset = (fRadius * Sine(fAngleIncrement * i)) - (fRadius / 2);
		//PrintToServer("%f %f", fXOffset, fYOffset);

		xyzLocation[0] += fXOffset;
		xyzLocation[1] += fYOffset;

		SpawnRandomCommonInfectedMob(xyzLocation, 1, bChanceForUncommon && GetRandomInt(0, 5) == 0 ? true : false, false, 0.1);
	}
		
}

Action:TimerSpawnCIAroundPlayer(Handle:timer, any:hDataPackage)
{
	ResetPack(hDataPackage);
	new iClient = ReadPackCell(hDataPackage);
	new iAmount = ReadPackCell(hDataPackage);
	new bool:bChanceForUncommon = ReadPackCell(hDataPackage);
	CloseHandle(hDataPackage);

	SpawnCIAroundPlayer(iClient, iAmount, bChanceForUncommon);

	return Plugin_Stop;
}


SpawnSpecialInfected(iClient, char[] strInfectedToSpawn = "")
{
	new iRandomSIID = GetRandomInt(1,6);
	decl String:strSpawnCommand[32];
	Format(strSpawnCommand, sizeof(strSpawnCommand), 
		"z_spawn_old %s auto", 
		strlen(strInfectedToSpawn) == 0 ?
		INFECTED_NAME[iRandomSIID]:
		strInfectedToSpawn);

	PrintToChatAll("\x03[XPMod] \x04%N\x05 Summoned a \x04%s\x05.", 
		iClient,
		strlen(strInfectedToSpawn) == 0 ?
		INFECTED_NAME[iRandomSIID]:
		strInfectedToSpawn);

	g_iFlag_SpawnOld = GetCommandFlags("z_spawn_old");
	SetCommandFlags("z_spawn_old", g_iFlag_SpawnOld & ~FCVAR_CHEAT);
	FakeClientCommand(iClient, strSpawnCommand);
	SetCommandFlags("z_spawn_old", g_iFlag_SpawnOld);
}




// SpawnSpecialInfected(client, Class, bool:bAuto=true)
// {
// 	new bool:resetGhostState[MaxClients+1];
// 	new bool:resetIsAlive[MaxClients+1];
// 	new bool:resetLifeState[MaxClients+1];
// 	ChangeClientTeam(client, 3);
// 	new String:g_sBossNames[9+1][10]={"","smoker","boomer","hunter","spitter","jockey","charger","witch","tank","survivor"};
// 	decl String:options[30];
// 	if (Class < 1 || Class > 8) return false;
// 	if (GetClientTeam(client) != 3) return false;
// 	if (!IsClientInGame(client)) return false;
// 	if (IsPlayerAlive(client)) return false;
	
// 	for (new i=1; i<=MaxClients; i++){ 
// 		if (i == client) continue; //dont disable the chosen one
// 		if (!IsClientInGame(i)) continue; //not ingame? skip
// 		if (GetClientTeam(i) != 3) continue; //not infected? skip
// 		if (IsFakeClient(i)) continue; //a bot? skip
		
// 		if (IsPlayerGhost(i)){
// 			resetGhostState[i] = true;
// 			SetPlayerGhostStatus(i, false);
// 			resetIsAlive[i] = true; 
// 			SetPlayerIsAlive(i, true);
// 		}
// 		else if (!IsPlayerAlive(i)){
// 			resetLifeState[i] = true;
// 			SetPlayerLifeState(i, false);
// 		}
// 	}
// 	Format(options,sizeof(options),"%s%s",g_sBossNames[Class],(bAuto?" auto":""));

// 	//CheatCommand(client, "z_spawn_old", options);
// 	new flags = GetCommandFlags("z_spawn_old");
// 	SetCommandFlags("z_spawn_old", flags & ~FCVAR_CHEAT);
// 	FakeClientCommand(client, "%s %s", "z_spawn_old", options);
// 	SetCommandFlags("z_spawn_old", flags | FCVAR_CHEAT);

// 	//if (IsFakeClient(client)) KickClient(client);
// 	//We restore the player's status
// 	for (new i=1; i<=MaxClients; i++){
// 		if (resetGhostState[i]) SetPlayerGhostStatus(i, true);
// 		if (resetIsAlive[i]) SetPlayerIsAlive(i, false);
// 		if (resetLifeState[i]) SetPlayerLifeState(i, true);
// 	}

// 	return true;
// }

// stock bool:IsPlayerGhost(client)
// {
// 	if (GetEntProp(client, Prop_Send, "m_isGhost", 1)) return true;
// 	return false;
// }

// stock SetPlayerGhostStatus(client, bool:ghost)
// {
// 	if(ghost){	
// 		SetEntProp(client, Prop_Send, "m_isGhost", 1, 1);
// 	}else{
// 		SetEntProp(client, Prop_Send, "m_isGhost", 0, 1);
// 	}
// }

// stock SetPlayerIsAlive(client, bool:alive)
// {
// 	new offset = FindSendPropInfo("CTransitioningPlayer", "m_isAlive");
// 	if (alive) SetEntData(client, offset, 1, 1, true);
// 	else SetEntData(client, offset, 0, 1, true);
// }

// stock SetPlayerLifeState(client, bool:ready)
// {
// 	if (ready) SetEntProp(client, Prop_Data, "m_lifeState", 1, 1);
// 	else SetEntProp(client, Prop_Data, "m_lifeState", 0, 1);
// }