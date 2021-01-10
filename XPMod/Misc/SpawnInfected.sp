int  SpawnRandomCommonInfectedMob(Float:xyzLocation[3], iAmount = 1, bool:bUncommon = false, Float:fTimeToWaitForMob = -1.0)
{
	xyzLocation[2] += 1;

	for(new i = 0; i < iAmount; i++)
	{
		new zombie = CreateEntityByName("infected");
		
		// Get thte number of possible models
		new iRandomModelNumber = bUncommon ? GetRandomInt(0,sizeof(UNCOMMON_INFECTED_MODELS) - 1) : GetRandomInt(0,sizeof(COMMON_INFECTED_MODELS) - 1)
		
		// Set the model, which sets the infected type, for uncommon changing behavior etc.
		if (bUncommon)
			SetEntityModel(zombie, UNCOMMON_INFECTED_MODELS[iRandomModelNumber]);
		else
			SetEntityModel(zombie, COMMON_INFECTED_MODELS[iRandomModelNumber]);
		
		new ticktime = RoundToNearest( GetGameTime() / GetTickInterval() ) + 5;
		SetEntProp(zombie, Prop_Data, "m_nNextThinkTick", ticktime);
		
		// This is the wait time before they go mad and try to find survivors
		// This will also enable them to spawn outside of the director's spawn area
		// But it must be triggered before thte ttime of destroy happens (2-3secs)
		if (fTimeToWaitForMob >=0)
			CreateTimer(fTimeToWaitForMob, TimerSetMobRush, zombie);
		
		// Teleport needs to happen first or problems occur.
		TeleportEntity(zombie, xyzLocation, NULL_VECTOR, NULL_VECTOR);
		//	Activate the common infected
		ActivateEntity(zombie);
		DispatchSpawn(zombie);

		if (iAmount == 1)
			return zombie;
	}
	
	return -1;
}


public Action:TimerSetMobRush(Handle:timer, any:iZombieEntity)
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