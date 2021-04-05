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

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damageType, &weapon, Float:damageForce[3], Float:damagePosition[3]) 
{
	// Check that this is an uncommon infected and not world or bot/human player
	if (victim > 0 &&
		RunClientChecks(victim) == false &&
		IsCommonInfected(victim, ""))
	{
		//PrintToServer("OnTakeDamage %i: damage: %f, damageType: %i, weapon: %i", victim, damage, damageType, weapon);

		// This is meant to be a cap for melee weapons, but may not be worth the check to do so.
		// If problems occur, add this check in using weapon.
		damage = damage > CI_MAX_DAMAGE_PER_HIT ? CI_MAX_DAMAGE_PER_HIT : damage;
		return Plugin_Changed;
	}
	
	return Plugin_Continue;
}

// Doesnt seem like it will work for several reasons, the main one being that there is no way to tell if the
// damage actually happened or not.  Also, cannot pass the hitgroup to OnTakeDamage reliably without there being
// issues.  So, instead, if needed, to get headshots, use the damagetype variable, as this appears to change if
// there is an actual headshot. This will likely need to be done for each gun though.
// public Action:TraceAttack(victim, &attacker, &inflictor, &Float:damage, &damageType, &ammotype, hitbox, hitgroup)
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