bool IsTankRock(int entity, const char[] classname)
{
	if (strlen(classname) > 0)
	{
		return StrEqual(classname, "tank_rock");
	}
	else if (IsValidEntity(entity))
	{
		new String:strClassname[100];
		GetEntityClassname(entity,strClassname,100);
		return StrEqual(strClassname, "tank_rock");
	}

	return false;
}

void PushRockOntoTankRockEntitiesList(int iEntity)
{
	if (g_listTankRockEntities == INVALID_HANDLE)
		return;

	// Push a new item onto the list
	new index = g_listTankRockEntities.Push(iEntity);
	// Store the entity ID
	g_listTankRockEntities.Set(index, iEntity, TANK_ROCK_ENTITY_ID);
	// Set the type for this item to be unknown until it can be determined later
	// what type it is.  This is done in OnGameFrame.
	g_listTankRockEntities.Set(index, TANK_ROCK_TYPE_UNKNOWN, TANK_ROCK_TYPE);
	g_listTankRockEntities.Set(index, -1, TANK_ROCK_PARTICLE_TRAIL);
	//PrintToServer("PushRockOntoTankRockEntitiesList %i", iEntity);
}

void PopRockOffTankRockEntitiesList(int iEntity)
{
	if (g_listTankRockEntities == INVALID_HANDLE)
		return;

	//Find the tank rock entity in the list
	new iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iEntity, TANK_ROCK_ENTITY_ID);
	
	//Remove it from the array if it was found
	if (iTankRockIndex >= 0)
		g_listTankRockEntities.Erase(iTankRockIndex);
		//RemoveFromArray(g_listTankRockEntities, iTankRockIndex);

	//PrintToServer("Rock Destroyed %i", iEntity);
}

void RemoveAllEntitiesFromArrayList(ArrayList:list)
{
	if (list == INVALID_HANDLE)
		return;

	for (int i=0; i < list.Length; i++)
		list.Erase(i);
}

void HandleTankRockDestroy(iRockEntity)
{
	if (g_listTankRockEntities == INVALID_HANDLE)
		return;

	//Find the tank rock entity in the list that will be used to gain the rock type
	new iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iRockEntity, TANK_ROCK_ENTITY_ID);
	
	switch (g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_TYPE))
	{
		case TANK_ROCK_TYPE_FIRE:
		{
			DestroyFireTankRock(iRockEntity);
		}
		case TANK_ROCK_TYPE_ICE:
		{
			CreateIceRockDestroyEffect(iRockEntity);
			FreezeEveryoneCloseToExplodingIceTankRock(iRockEntity);
		}
		case TANK_ROCK_TYPE_NECROTANKER:
		{
			CreateNecroTankerRockDestroyEffect(iRockEntity);
			BileEveryoneCloseToExplodingNecroTankerTankRock(iRockEntity);
			// Rock is destroyed early and replaced by special infected, ignore this
		}
		case TANK_ROCK_TYPE_GENERIC, TANK_ROCK_TYPE_UNKNOWN:
		{
			// Do nothing
		}
	}
}

// void PrintAllInTankRockEntityList()
// {
// 	if (g_listTankRockEntities == INVALID_HANDLE)
// 		return;

// 	PrintToServer("g_listTankRockEntities:");
// 	for (int i=0; i < g_listTankRockEntities.Length; i++)
// 	{
// 		new iEntityID = g_listTankRockEntities.Get(i, TANK_ROCK_ENTITY_ID);
// 		new iRockType = g_listTankRockEntities.Get(i, TANK_ROCK_TYPE);
// 		PrintToServer("    %i: id %i, type %i", i, iEntityID, iRockType);
// 	}
// }



void TrackAllRocks()
{
	for (int iTankRockIndex=0; iTankRockIndex < g_listTankRockEntities.Length; iTankRockIndex++)
	{
		new iTankRockEntity = g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_ENTITY_ID);

		//Get the tank rock type to determine the next course of action
		switch (g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_TYPE))
		{
			// If TANK_ROCK_TYPE_UNKNOWN, then we still need to figure out what type
			case TANK_ROCK_TYPE_UNKNOWN:
			{
				// Try to determine thee type of tank rock
				new bGotTankRockType = GetTankRockTypeAndOwner(iTankRockIndex);
				// If a valid tank rock was found, then handle its initial setup
				if (bGotTankRockType)
				{
					int iTankRockType = g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_TYPE);
					//PrintToChatAll("Initial Setup for tank rock type: %i", iTankRockType);

					// Do initial setup depending on the rock type
					switch (iTankRockType)
					{
						case TANK_ROCK_TYPE_FIRE:
						{
							SetEntityRenderMode(iTankRockEntity, RenderMode:0);
							SetEntityRenderColor(iTankRockEntity, 215, 53, 2,255);
							CreateTimer(0.1, WaitForNonZeroOriginVectorAndSetUpTankRock, iTankRockEntity, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
						}
						case TANK_ROCK_TYPE_ICE:
						{
							SetEntityRenderMode(iTankRockEntity, RenderMode:3);
							SetEntityRenderColor(iTankRockEntity, 180, 230, 255, 240);
							CreateTimer(0.1, WaitForNonZeroOriginVectorAndSetUpTankRock, iTankRockEntity, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
						}
						case TANK_ROCK_TYPE_NECROTANKER:
						{
							SetEntityModel(iTankRockEntity, "models/infected/boomer.mdl");
							CreateTimer(0.1, WaitForNonZeroOriginVectorAndSetUpTankRock, iTankRockEntity, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
						}
					}

					// Get the owner and set their cooldown for the next rock throw
					int iTankRockOwner = g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_OWNER_ID);

					switch(g_iTankChosen[iTankRockOwner])
					{
						case TANK_FIRE: 			SetSIAbilityCooldown(iTankRockOwner, 13.0);
						case TANK_ICE: 				SetSIAbilityCooldown(iTankRockOwner, 2.1);
						case TANK_NECROTANKER:
						{
							// Pay the mana cost
							g_iNecroTankerManaPool[iTankRockOwner] -= NECROTANKER_MANA_COST_BOOMER_THROW;
							// Clamp it
							if (g_iNecroTankerManaPool[iTankRockOwner] < 0)
								g_iNecroTankerManaPool[iTankRockOwner] = 0;
							DisplayNecroTankerManaMeter(iTankRockOwner);

							if (g_iNecroTankerManaPool[iTankRockOwner] >= NECROTANKER_MANA_COST_BOOMER_THROW)
								SetSIAbilityCooldown(iTankRockOwner, 6.0);
							else
								SetSIAbilityCooldown(iTankRockOwner, 99999.0);
						}
					}
				}
			}
			case TANK_ROCK_TYPE_FIRE:
			{
				
			}
			case TANK_ROCK_TYPE_ICE:
			{
				
			}
			case TANK_ROCK_TYPE_GENERIC:
			{
				// Do nothing
			}
		}			
	}
}

bool GetTankRockTypeAndOwner(iTankRockIndex)
{
	//If one tank is spawned in then we can determine the type of rock easily by checking this tank type
	if (g_iTankCounter <= 1)
	{
		// Determine Tank Rock type based on the tank spawned in:
		for (int iClient=1; iClient <= MaxClients; iClient++)
		{
			if(RunClientChecks(iClient) && 
				IsPlayerAlive(iClient) && 
				GetEntProp(iClient, Prop_Send, "m_zombieClass") == TANK)
			{
				// Store the rock thrower (owner)
				g_listTankRockEntities.Set(iTankRockIndex, iClient, TANK_ROCK_OWNER_ID);

				new iRockTankType = TANK_ROCK_TYPE_GENERIC;
				switch(g_iTankChosen[iClient])
				{
					case TANK_FIRE: 			iRockTankType = TANK_ROCK_TYPE_FIRE;
					case TANK_ICE: 				iRockTankType = TANK_ROCK_TYPE_ICE;
					case TANK_NECROTANKER: 		iRockTankType = TANK_ROCK_TYPE_NECROTANKER;
				}

				// Store the tank rock type
				g_listTankRockEntities.Set(iTankRockIndex, iRockTankType, TANK_ROCK_TYPE);

				return true;
			}
		}
	}
	// If multiple tanks are spawned in, then determine who threw the rock
	// based on how close each tank is relative to the rock
	else
	{
		// Get the actual rock game entity
		new iRockEntity = g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_ENTITY_ID);

		if (RunEntityChecks(iRockEntity) == false ||
			HasEntProp(iRockEntity, Prop_Send, "m_vecOrigin") == false)
			return false;

		// Get the rock entity position
		decl Float:xyzRockPosition[3];
		GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);
		
		// If the rock entities vectors are still 0, 0, 0 then we cant determine its proximity to the tank yet
		// return -1 and check again later
		if (xyzRockPosition[0] == 0 && xyzRockPosition[1] == 0 && xyzRockPosition[2] == 0)
			return false;

		// Loop through each client, determine if they are a tank, and finally check how close they are to the rock
		for (int iClient=1; iClient<= MaxClients; iClient++)
		{
			if(RunClientChecks(iClient) == true &&
				IsPlayerAlive(iClient) == true &&
				GetEntProp(iClient, Prop_Send, "m_zombieClass") == TANK)
			{
				decl Float:xyzTankOrigin[3];
				GetClientAbsOrigin(iClient, xyzTankOrigin);

				//PrintToChatAll("tank origin:  %f,%f,%f", xyzTankOrigin[0],xyzTankOrigin[1],xyzTankOrigin[2]);
				//PrintToChatAll("rock origin:  %f,%f,%f", xyzRockPosition[0],xyzRockPosition[1],xyzRockPosition[2]);
				//PrintToChatAll("rock distance from tank: %f\n ", GetVectorDistance(xyzTankOrigin,xyzRockPosition, false));

				if (GetVectorDistance(xyzTankOrigin,xyzRockPosition, false) < 400.0)
				{
					// Store the rock thrower (owner)
					g_listTankRockEntities.Set(iTankRockIndex, iClient, TANK_ROCK_OWNER_ID);

					new iRockTankType = TANK_ROCK_TYPE_GENERIC;
					switch(g_iTankChosen[iClient])
					{
						case TANK_FIRE: 			iRockTankType = TANK_ROCK_TYPE_FIRE;
						case TANK_ICE: 				iRockTankType = TANK_ROCK_TYPE_ICE;
						case TANK_NECROTANKER: 		iRockTankType = TANK_ROCK_TYPE_NECROTANKER;
					}

					// Store the tank rock type
					g_listTankRockEntities.Set(iTankRockIndex, iRockTankType, TANK_ROCK_TYPE);

					return true;
				}
			}
		}
	}

	return false;
}

Action:WaitForNonZeroOriginVectorAndSetUpTankRock(Handle:timer, any:iRockEntity)
{
	//Ensure there is a valid entitty here, remove it from the array otherwise
	if (IsValidEntity(iRockEntity) == false)
	{
		PopRockOffTankRockEntitiesList(iRockEntity);
		return Plugin_Stop;
	}

	new Float:xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);
	if (xyzRockPosition[0] == 0 && xyzRockPosition[1] == 0 && xyzRockPosition[2] == 0)
		return Plugin_Continue;
	
	//Find the tank rock entity in the list that will be used to gain the rock type
	new iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iRockEntity, TANK_ROCK_ENTITY_ID);
	// Check that a valid index was returned
	if (iTankRockIndex < 0)
		return Plugin_Stop;

	//Get the Rock Type and create the trail based on the type
	switch(g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_TYPE))
	{
		case TANK_ROCK_TYPE_FIRE: 			CreateFireRockTrailEffect(iRockEntity);
		case TANK_ROCK_TYPE_ICE: 			CreateIceRockTrailEffect(iRockEntity);
		case TANK_ROCK_TYPE_NECROTANKER:	CreateNecroTankerRockTrailEffect(iRockEntity);
	}
	
	return Plugin_Stop;
}