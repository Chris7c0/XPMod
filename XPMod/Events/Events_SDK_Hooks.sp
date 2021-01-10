public void OnEntityCreated(int entity, const char[] classname)
{
	// Check if player presseed a button this round to ensure unwanted preloaded entities are 
	// not captured beyond this point.
	if (g_bPlayerPressedButtonThisRound == false)
		return;
	
	//PrintToServer("OnEntityCreated %i", entity);
	if (IsTankRock(entity, classname))
	{
		PushRockOntoTankRockEntitiesList(entity);

		// new entityRef = EntIndexToEntRef(entity);
		// PrintToServer("Rock Created %i", entityRef);

		// CreateTimer(0.1, TrackRockPosition, entity, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
    }
}

public void OnEntityDestroyed(int iEntity)
{
	// Check if player presseed a button this round to ensure unwanted preloaded entities are 
	// not captured beyond this point.
	if (g_bPlayerPressedButtonThisRound == false)
		return;

	//PrintToServer("OnEntityDestroyed %i", entity);
	if (IsTankRock(iEntity, ""))
	{
		HandleTankRockDestroy(iEntity);
		PopRockOffTankRockEntitiesList(iEntity);
    }
}