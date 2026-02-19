public void OnEntityCreated(int iEntity, const char[] classname)
{
	// Check if player presseed a button this round to ensure unwanted preloaded entities are 
	// not captured beyond this point.
	if (g_bPlayerPressedButtonThisRound == false)
		return;
	
	// PrintToServer("OnEntityCreated %i: classname: %s", iEntity, classname);

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

	if (RunEntityChecks(iEntity) == false)
		return;

	// Remove any hooks for Entities with health
	if (g_iXPModEntityType[iEntity] != XPMOD_ENTITY_TYPE_NONE)
	{
		g_iXPModEntityType[iEntity] = XPMOD_ENTITY_TYPE_NONE;
		g_fXPModEntityHealth[iEntity] = -1.0;

		SDKUnhook(iEntity, SDKHook_OnTakeDamage, OnTakeDamage);
	}

	// Get classname for the entity to check what it is later
	char strClassname[100];
	GetEntityClassname(iEntity,strClassname,100);

	// Handle Enhanced CI deaths
	if (IsCommonInfected(iEntity, strClassname))
	{
		SDKUnhook(iEntity, SDKHook_OnTakeDamage, OnTakeDamage);
		PopZombieOffEnhancedCIEntitiesList(iEntity);
	}

	//PrintToServer("OnEntityDestroyed %i", entity);
	if (IsTankRock(iEntity, strClassname))
	{
		HandleTankRockDestroy(iEntity);
		PopRockOffTankRockEntitiesList(iEntity);
	}
}

public Action OnTakeDamage(int iVictim, int &iAttacker, int &iInflictor, float &fDamage, int &iDamageType, int &iWeapon, float damageForce[3], float damagePosition[3]) 
{
	// PrintToChatAll("OnTakeDamage: %i", iVictim);

	// Check that this is an uncommon infected and not world or bot/human player
	if (iVictim > 0 &&
		RunClientChecks(iVictim) == false &&
		IsCommonInfected(iVictim, ""))
	{
		//PrintToServer("OnTakeDamage %i: damage: %f, damageType: %i, weapon: %i", iVictim, fDamage, damageType, weapon);

		// This is meant to be a cap for melee weapons, but may not be worth the check to do so.
		// If problems occur, add this check in using weapon.
		fDamage = fDamage > CI_MAX_DAMAGE_PER_HIT ? CI_MAX_DAMAGE_PER_HIT : fDamage;
		return Plugin_Changed;
	}

	// For tracked XPMod entities
	if (g_iXPModEntityType[iVictim] != XPMOD_ENTITY_TYPE_NONE)
	{
		// Handle the entities based on their types
		switch (g_iXPModEntityType[iVictim])
		{
			case XPMOD_ENTITY_TYPE_SMOKER_CLONE: OnTakeDamage_SmokerClone(iVictim, iAttacker, fDamage, iDamageType);
		}
	}

	// if (g_iSmokerSmokeCloudPlayer == iVictim)
	// {
	// 	fDamage = 0.0;
	// 	return Plugin_Changed;
	// }
	
	return Plugin_Continue;
}

// Doesnt seem like it will work for several reasons, the main one being that there is no way to tell if the
// damage actually happened or not.  Also, cannot pass the hitgroup to OnTakeDamage reliably without there being
// issues.  So, instead, if needed, to get headshots, use the damagetype variable, as this appears to change if
// there is an actual headshot. This will likely need to be done for each gun though.
// public Action TraceAttack(victim, &attacker, &inflictor, float &damage, &damageType, &ammotype, hitbox, hitgroup)
// {
// 	PrintToServer("TraceAttack %i: damage: %f, damageType: %i, hitgroup: %i", victim, damage, damageType, hitgroup);
// 	// damage = 0.0;
// 	// damageType = 0;
// 	// return Plugin_Changed;
// 	return Plugin_Continue;
// }
//+1073741826 CI gun headshot MP5
//+1073741826 CI gun headshot Pistol_Magnum
//-1071644668 CI melee headshot

void UnhookAllOnTakeDamage()
{
	for (int i=0; i <= MAXENTITIES; i++)
	{
		if (IsValidEntity(i) == false)
			continue;
		
		SDKUnhook(i, SDKHook_OnTakeDamage, OnTakeDamage);
	}
}

// THis is called on the next pre think after sdkhooked
// public void PreThink(int iClient)
// {
// 	// This is for the Smokers smoke cloud when hes shoved
// 	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, g_xyzPreShoveVelocity[iClient]);

// 	// Unhook now that the action is complete
// 	SDKUnhook(iClient, SDKHook_PreThink, PreThink);
// }
