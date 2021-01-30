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

		// CreateTimer(0.1, TrackRockPosition, iEntity, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
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