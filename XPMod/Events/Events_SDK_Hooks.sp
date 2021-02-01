public void OnEntityCreated(int iEntity, const char[] classname)
{
	// Check if player presseed a button this round to ensure unwanted preloaded entities are 
	// not captured beyond this point.
	if (g_bPlayerPressedButtonThisRound == false)
		return;
	
	//PrintToServer("OnEntityCreated %i", iEntity);
	if (IsCommonInfected(iEntity, classname))
	{
		EnhanceCIIfNeeded(iEntity);
    }

	if (IsTankRock(iEntity, classname))
	{
		PushRockOntoTankRockEntitiesList(iEntity);

		// new iEntityRef = EntIndexToEntRef(iEntity);
		// PrintToServer("Rock Created %i", iEntityRef);

		// CreateTimer(0.1, TrackRockPosition, iEntity, TIMER_FLAG_NO_MAPCHANGE);
    }
}

public void OnEntityDestroyed(int iEntity)
{
	// Check if player presseed a button this round to ensure unwanted preloaded entities are 
	// not captured beyond this point.
	if (g_bPlayerPressedButtonThisRound == false)
		return;

	if (IsValidEntity(iEntity) ==  false)
		return;

	// Get classname for the entity to check what it is later
	new String:strClassname[100];
	GetEntityClassname(iEntity,strClassname,100);

	// Handle Enhanced CI deaths
	if (IsCommonInfected(iEntity, strClassname))
	{
		PopZombieOffEnhancedCIEntitiesList(iEntity);
    }

	//PrintToServer("OnEntityDestroyed %i", entity);
	if (IsTankRock(iEntity, strClassname))
	{
		HandleTankRockDestroy(iEntity);
		PopRockOffTankRockEntitiesList(iEntity);
    }
}