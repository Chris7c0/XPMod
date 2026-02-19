bool IsTankRock(int entity, const char[] classname)
{
	if (strlen(classname) > 0)
	{
		return StrEqual(classname, "tank_rock");
	}
	else if (IsValidEntity(entity))
	{
		char strClassname[100];
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
	int index = g_listTankRockEntities.Push(iEntity);
	// Store the entity ID
	g_listTankRockEntities.Set(index, iEntity, TANK_ROCK_ENTITY_ID);
	// Set the type for this item to be unknown until it can be determined later
	// what type it is.  This is done in OnGameFrame.
	g_listTankRockEntities.Set(index, TANK_ROCK_TYPE_UNKNOWN, TANK_ROCK_TYPE);
	g_listTankRockEntities.Set(index, -1, TANK_ROCK_PARTICLE_TRAIL);
}

void PopRockOffTankRockEntitiesList(int iEntity)
{
	if (g_listTankRockEntities == INVALID_HANDLE)
		return;

	//Find the tank rock entity in the list
	int iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iEntity, TANK_ROCK_ENTITY_ID);
	
	//Remove it from the array if it was found
	if (iTankRockIndex >= 0)
		g_listTankRockEntities.Erase(iTankRockIndex);
		//RemoveFromArray(g_listTankRockEntities, iTankRockIndex);

}

void RemoveAllEntitiesFromArrayList(ArrayList list)
{
	if (list == INVALID_HANDLE)
		return;

	for (int i=0; i < list.Length; i++)
		list.Erase(i);
}

void HandleTankRockDestroy(int iRockEntity)
{
	if (g_listTankRockEntities == INVALID_HANDLE)
		return;

	//Find the tank rock entity in the list that will be used to gain the rock type
	int iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iRockEntity, TANK_ROCK_ENTITY_ID);
	
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

void TrackAllRocks()
{
	for (int iTankRockIndex=0; iTankRockIndex < g_listTankRockEntities.Length; iTankRockIndex++)
	{
		int iTankRockEntity = g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_ENTITY_ID);

		//Get the tank rock type to determine the next course of action
		switch (g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_TYPE))
		{
			// If TANK_ROCK_TYPE_UNKNOWN, then we still need to figure out what type
			case TANK_ROCK_TYPE_UNKNOWN:
			{
				// Try to determine thee type of tank rock
				bool bGotTankRockType = GetTankRockTypeAndOwner(iTankRockIndex);
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

bool GetTankRockTypeAndOwner(int iTankRockIndex)
{
	// Get the actual rock game entity
	int iRockEntityID = g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_ENTITY_ID);
	if (RunEntityChecks(iRockEntityID) == false ||
		HasEntProp(iRockEntityID, Prop_Send, "m_hOwnerEntity") == false)
		return false;
	
	// Get the rock's owner id, the tank that threw it
	int iRockOwner = GetEntPropEnt(iRockEntityID, Prop_Send, "m_hOwnerEntity");
	if (RunClientChecks(iRockOwner) == false || 
		IsPlayerAlive(iRockOwner) == false)
		return false;

	// Store the rock thrower (owner)
	g_listTankRockEntities.Set(iTankRockIndex, iRockOwner, TANK_ROCK_OWNER_ID);

	// Get the tank rock type using its owner's Tank type
	int iRockTankType = TANK_ROCK_TYPE_GENERIC;
	switch(g_iTankChosen[iRockOwner])
	{
		case TANK_FIRE: 			iRockTankType = TANK_ROCK_TYPE_FIRE;
		case TANK_ICE: 				iRockTankType = TANK_ROCK_TYPE_ICE;
		case TANK_NECROTANKER: 		iRockTankType = TANK_ROCK_TYPE_NECROTANKER;
	}

	// Store the tank rock type
	g_listTankRockEntities.Set(iTankRockIndex, iRockTankType, TANK_ROCK_TYPE);

	return true;
}

Action WaitForNonZeroOriginVectorAndSetUpTankRock(Handle timer, int iRockEntity)
{
	//Ensure there is a valid entitty here, remove it from the array otherwise
	if (IsValidEntity(iRockEntity) == false)
	{
		PopRockOffTankRockEntitiesList(iRockEntity);
		return Plugin_Stop;
	}

	float xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);
	if (xyzRockPosition[0] == 0 && xyzRockPosition[1] == 0 && xyzRockPosition[2] == 0)
		return Plugin_Continue;
	
	//Find the tank rock entity in the list that will be used to gain the rock type
	int iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iRockEntity, TANK_ROCK_ENTITY_ID);
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
