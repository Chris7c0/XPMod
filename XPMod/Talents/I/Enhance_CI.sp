bool IsCommonInfected(int iEntity, const char[] strKnownClassname)
{	
	if (strlen(strKnownClassname) > 0)
		return StrEqual(strKnownClassname, "infected");
	
	if (RunEntityChecks(iEntity))
	{
		char strClassname[100];
		GetEntityClassname(iEntity,strClassname,100);
		return StrEqual(strClassname, "infected");
	}

	return false;
}

// Check the CI is still alive, by checking health and also
// importantly if the CI is a ragdoll because health can not
// go to 0 and they are still dead in the game.
bool IsCommonInfectedAlive(int iEntity)
{
	if (RunEntityChecks(iEntity) &&
		GetEntProp(iEntity, Prop_Data, "m_iHealth") > 0 &&
		GetEntProp(iEntity, Prop_Data, "m_bClientSideRagdoll") == 0)
		return true;

	return false;
}

bool IsEnhancedCI(int iEntity)
{
	// Find if the Enhanced CI entity in the list, if so they are enchanced
	if (GetEnhancedCIListIndexID(iEntity) >= 0)
		return true;
	
	return false;
}

// Returns 0 if the infected is not in the enhanced infected list
int GetEnhancedCIListIndexID(int iEntity)
{
	// Find the Enhanced CI index ID using the entity ID in the list
	return FindIndexInArrayListUsingValue(g_listEnhancedCIEntities, iEntity, ENHANCED_CI_ENTITY_ID);
}

void EnhanceCIIfNeeded(int iEntity)
{
	// Use a timer, or size doesnt work properly
	if (GetRandomFloat(0.0, 1.0) <= CalculateCIEnhancementChance())
		CreateTimer(0.1, TimerSpawnRandomlyEnhancedCIForDirector, iEntity, TIMER_FLAG_NO_MAPCHANGE);
}

float CalculateCIEnhancementChance()
{
	int iCombinedSurvivorLevel = 0;
	float fNormalizedSurvivorLevel = 0.0;

	// Get all the survivor's levels add them up
	for (int i = 1; i <= MaxClients; i++)
	{
		if (RunClientChecks(i) && 
			g_iClientTeam[i] == TEAM_SURVIVORS &&
			g_bClientLoggedIn[i] == true &&
			IsFakeClient(i) == false &&
			IsPlayerAlive(i) == true)
			iCombinedSurvivorLevel += g_iClientLevel[i];
	}

	// Normalize the combined survivor level (note: this assumes 4 survivors)
	fNormalizedSurvivorLevel = iCombinedSurvivorLevel / 120.0;

	// Calculate and return the spawn chance based on normalized survivor level and max chance
	return fNormalizedSurvivorLevel * ENHANCEMENT_CI_CHANCE_MAX;
}

void PushZombieOnEnhancedCIEntitiesList(int iEntity, int iEnchancedCIType)
{
	if (g_listEnhancedCIEntities == INVALID_HANDLE)
		return;

	// Push a new item onto the list
	new index = g_listEnhancedCIEntities.Push(iEntity);
	// Store the entity ID
	g_listEnhancedCIEntities.Set(index, iEntity, ENHANCED_CI_ENTITY_ID);
	// Set the type for the Enhanced CI
	g_listEnhancedCIEntities.Set(index, iEnchancedCIType, ENHANCED_CI_TYPE);
	
	DebugLog(DEBUG_MODE_VERBOSE, "g_listEnhancedCIEntities %i: Type: %i", iEntity, iEnchancedCIType);
}

void PopZombieOffEnhancedCIEntitiesList(int iEntity)
{
	if (g_listEnhancedCIEntities == INVALID_HANDLE)
		return;

	// Find if the Enhanced CI entity in the list
	new iEnhancedCIIndex = FindIndexInArrayListUsingValue(g_listEnhancedCIEntities, iEntity, ENHANCED_CI_ENTITY_ID);
	
	// Remove it from the array if it was found
	if (iEnhancedCIIndex >= 0)
	{
		g_listEnhancedCIEntities.Erase(iEnhancedCIIndex);
		DebugLog(DEBUG_MODE_VERBOSE, "Enhanced CI Destroyed %i", iEntity);
	}
}

public void PrintAllInEnhancedCIEntityList()
{
	if (g_listEnhancedCIEntities == INVALID_HANDLE)
		return;

	PrintToServer("g_listEnhancedCIEntities:");
	for (int i=0; i < g_listEnhancedCIEntities.Length; i++)
	{
		new iEntityID = g_listEnhancedCIEntities.Get(i, ENHANCED_CI_ENTITY_ID);
		new iType = g_listEnhancedCIEntities.Get(i, ENHANCED_CI_TYPE);
		PrintToServer("    %i: id %i, type %i", i, iEntityID, iType);
	}
}

Action TimerSpawnRandomlyEnhancedCIForDirector(Handle timer, any iEntity)
{
	if (IsValidEntity(iEntity) && IsCommonInfected(iEntity, ""))
		EnhanceCommonInfected(iEntity, CI_SMALL_OR_BIG_RANDOM, ENHANCED_CI_TYPE_RANDOM);
	
	return Plugin_Stop;
}

EnhanceCommonInfected(iZombie, iBigOrSmall = CI_SMALL_OR_BIG_NONE, iEnhancedCISpecifiedType = ENHANCED_CI_TYPE_NONE)
{
	// Hook the CI so damage can be better handled, such as capping melee damage
	SDKHook(iZombie, SDKHook_OnTakeDamage, OnTakeDamage);

	if (iBigOrSmall == CI_SMALL_OR_BIG_RANDOM || iBigOrSmall == CI_BIG || iBigOrSmall == CI_SMALL)
	{
		float fHealthAndSizeMultiplier = GetRandomFloat(0.0, 1.0);
		// If CI_BIG is specified, then spawn a big zombie, otherwise, roll the dice for 50/50 BIG OR SMALL
		if(iBigOrSmall == CI_BIG || GetRandomInt(0, 1))
		{
			// Big Zombie, High Health
			EnhanceCISetScale(iZombie, (CI_BIG_MIN_SIZE + ( (CI_BIG_MAX_SIZE - CI_BIG_MIN_SIZE) * fHealthAndSizeMultiplier) ) );
			EnhanceCISetHealth(iZombie, RoundToNearest(CI_BIG_MIN_HEALTH + ( (CI_BIG_MAX_HEALTH - CI_BIG_MIN_HEALTH) * fHealthAndSizeMultiplier) ) );
		}
		else
		{
			// Small Zombie, Low Health
			EnhanceCISetScale(iZombie, (CI_SMALL_MIN_SIZE + ( (CI_SMALL_MAX_SIZE - CI_SMALL_MIN_SIZE) * fHealthAndSizeMultiplier) ) );
			EnhanceCISetHealth(iZombie, RoundToNearest(CI_SMALL_MIN_HEALTH + ( (CI_SMALL_MAX_HEALTH - CI_SMALL_MIN_HEALTH) * fHealthAndSizeMultiplier) ) );
		}
	}
	else if(iBigOrSmall == CI_REALLY_BIG)
	{
		// Really Big Zombie, Really High Health
		EnhanceCISetScale(iZombie, CI_REALLY_BIG_SIZE);
		EnhanceCISetHealth(iZombie, CI_REALLY_BIG_HEALTH);
	}
	else if(iBigOrSmall == CI_REALLY_SMALL)
	{
		// Really Small Zombie, Really Low Health
		EnhanceCISetScale(iZombie, CI_REALLY_SMALL_SIZE);
		EnhanceCISetHealth(iZombie, CI_REALLY_SMALL_HEALTH);
	}
	else if(iBigOrSmall == CI_REALLY_BIG_JIMMY)
	{
		// Really Big Zombie, Really High Health
		EnhanceCISetScale(iZombie, CI_REALLY_BIG_JIMMY_SIZE);
		EnhanceCISetHealth(iZombie, CI_REALLY_BIG_JIMMY_HEALTH);
	}

	// Handle randomly available enhanced properties
	if (iEnhancedCISpecifiedType != ENHANCED_CI_TYPE_NONE)
	{
		new iEnhancementType = iEnhancedCISpecifiedType == ENHANCED_CI_TYPE_RANDOM ? GetRandomInt(ENHANCED_CI_TYPE_FIRE, ENHANCED_CI_TYPE_VAMPIRIC) : iEnhancedCISpecifiedType;
		switch (iEnhancementType)
		{
			case ENHANCED_CI_TYPE_FIRE: 	EnhanceCISet_Fire(iZombie);
			case ENHANCED_CI_TYPE_ICE: 		EnhanceCISet_Ice(iZombie);
			case ENHANCED_CI_TYPE_NECRO: 	EnhanceCISet_Necro(iZombie);
			case ENHANCED_CI_TYPE_VAMPIRIC:	EnhanceCISet_Vampiric(iZombie);
		}
	}
}

EnhanceCISetScale(iZombie, float fScale = -1.0)
{
	if (fScale == -1.0)
		fScale = GetRandomFloat(CI_SMALL_MIN_SIZE, CI_BIG_MAX_SIZE);
	
	// PrintToChatAll("CI_SCALE: %f", fScale);
	SetEntPropFloat(iZombie, Prop_Send, "m_flModelScale", fScale);
}

EnhanceCISetHealth(iZombie, iHealth = -1)
{
	if (iHealth == -1.0)
		iHealth = GetRandomInt(CI_SMALL_MIN_HEALTH, CI_BIG_MAX_HEALTH);

	// PrintToChatAll("CI_HEALTH: %i", iHealth);
	SetPlayerHealth(iZombie, -1, iHealth);
}

EnhanceCISet_Fire(iZombie)
{
	// Store the entity and type into the Enhanced CI Array List
	PushZombieOnEnhancedCIEntitiesList(iZombie, ENHANCED_CI_TYPE_FIRE);

	// Change Skin Color (Doesn't appear to work in L4D2 for CI)
	// SetClientRenderColor(iZombie, 255, 200, 30, 255, RENDER_MODE_NORMAL);
	// Change Outline Glow
	SetClientGlow(iZombie, 250, 50, 20, GLOWTYPE_ONVISIBLE);
}

EnhanceCISet_Ice(iZombie)
{
	// Store the entity and type into the Enhanced CI Array List
	PushZombieOnEnhancedCIEntitiesList(iZombie, ENHANCED_CI_TYPE_ICE);

	// Change Skin Color (Doesn't appear to work in L4D2 for CI)
	// SetClientRenderColor(iZombie, 0, 255, 255, 255, RENDER_MODE_NORMAL);
	// Change Outline Glow
	SetClientGlow(iZombie, 80, 240, 255, GLOWTYPE_ONVISIBLE);
}

EnhanceCISet_Necro(iZombie)
{
	// Store the entity and type into the Enhanced CI Array List
	PushZombieOnEnhancedCIEntitiesList(iZombie, ENHANCED_CI_TYPE_NECRO);

	// Change Skin Color (Doesn't appear to work in L4D2 for CI)
	// SetClientRenderColor(iZombie, 0, 130, 40, 255, RENDER_MODE_NORMAL);
	// Change Outline Glow
	SetClientGlow(iZombie, 0, 130, 40, GLOWTYPE_ONVISIBLE);
}

EnhanceCISet_Vampiric(iZombie)
{
	// Store the entity and type into the Enhanced CI Array List
	PushZombieOnEnhancedCIEntitiesList(iZombie, ENHANCED_CI_TYPE_VAMPIRIC);

	// Change Skin Color (Doesn't appear to work in L4D2 for CI)
	// SetClientRenderColor(iZombie, 100, 0, 255, 255, RENDER_MODE_NORMAL);
	// Change Outline Glow
	SetClientGlow(iZombie, 100, 0, 255, GLOWTYPE_ONVISIBLE);
}

EnhanceCIHandleDamage_Fire(iAttacker, iVictim)
{
	SuppressNeverUsedWarning(iAttacker);

	SetFireToPlayer(iVictim, iAttacker, ENHANCED_CI_FIRE_BURN_DURATION);
	IgniteEntity(iVictim, ENHANCED_CI_FIRE_BURN_DURATION, false);
}

EnhanceCIHandleDamage_Ice(iAttacker, iVictim)
{
	SuppressNeverUsedWarning(iAttacker);

	CreateTimer(0.1, Timer_FreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(ENHANCED_CI_ICE_FREEZE_DURATION, Timer_UnfreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
}

EnhanceCIHandleDamage_Necro(iAttacker, iVictim)
{
	SuppressNeverUsedWarning(iAttacker);

	// Only spawn if the dice roll says to
	if (GetRandomFloat(0.0, 1.0) <= ENHANCED_CI_NECRO_SPAWN_CHANCE)
		return;

	if (RunClientChecks(iVictim) == false)
		return;
	
	// Get player location to spawn infected around
	float xyzLocation[3];
	GetClientAbsOrigin(iVictim, xyzLocation);

	// Roll the dice for a uncommon
	new iUncommon = GetRandomFloat(0.0, 1.0) <= ENHANCED_CI_NECRO_SPAWN_UNCOMMON_CHANCE ? UNCOMMON_CI_RANDOM : UNCOMMON_CI_NONE;

	// Roll the dice for big or small
	new iBigOrSmall = GetRandomFloat(0.0, 1.0) <= ENHANCED_CI_NECRO_SPAWN_BIG_SMALL_CHANCE ? CI_SMALL_OR_BIG_RANDOM : CI_SMALL_OR_BIG_NONE;

	// Roll the dice for an enahnced CI
	new iEnhancedCISpecifiedType = GetRandomFloat(0.0, 1.0) <= ENHANCED_CI_NECRO_SPAWN_ENHANCED_CHANCE ? ENHANCED_CI_TYPE_RANDOM : ENHANCED_CI_TYPE_NONE;

	SpawnCIAroundLocation(xyzLocation, 1, iUncommon, iBigOrSmall, iEnhancedCISpecifiedType);
}

EnhanceCIHandleDamage_Vampiric(iAttacker, iVictim)
{
	DealDamage(iVictim, iAttacker, 1);

	new iCurrentHealth = GetPlayerHealth(iAttacker);
	//PrintToChatAll("ENHANCED_CI_HEALTH_START_STEAL %i", iCurrentHealth);

	// Clamp health and apply
	if (iCurrentHealth + ENHANCED_CI_VAMPIRIC_LIFE_STEAL_AMOUNT <= CI_BIG_MAX_HEALTH)
		SetPlayerHealth(iAttacker, -1, iCurrentHealth + ENHANCED_CI_VAMPIRIC_LIFE_STEAL_AMOUNT);
	else
		SetPlayerHealth(iAttacker, -1, CI_BIG_MAX_HEALTH);
	
	//iCurrentHealth = GetPlayerHealth(iAttacker);
	//PrintToChatAll("ENHANCED_CI_HEALTH_POST_STEAL %i", iCurrentHealth);
}


// Spitter Specific Enhanced CI ////////////////////////////////////////////////////////////




// ResizeHitbox(entity, float fScale = 1.0)
// {
// 	float vecBossMin[3], vecBossMax[3];
// 	//   if (StrEqual(sEntityClass, "headless_hatman"))
// 	//   {
// 	//     vecBossMin[0] = -25.5, vecBossMin[1] = -38.5, vecBossMin[2] = -11.0;
// 	//     vecBossMax[0] = 18.0, vecBossMax[1] = 38.0, vecBossMax[2] = 138.5;
// 	//   }
// 	//   else if (StrEqual(sEntityClass, "eyeball_boss"))
// 	//   {
// 	//     vecBossMin[0] = -50.0, vecBossMin[1] = -50.0, vecBossMin[2] = -50.0;
// 	//     vecBossMax[0] = 50.0, vecBossMax[1] = 50.0, vecBossMax[2] = 50.0;
// 	//   }
// 	//   else if (StrEqual(sEntityClass, "merasmus"))
// 	//   {
// 	//     vecBossMin[0] = -58.5, vecBossMin[1] = -49.5, vecBossMin[2] = -30.5;
// 	//     vecBossMax[0] = 92.5, vecBossMax[1] = 49.5, vecBossMax[2] = 190.5;
// 	//   }

// 	vecBossMin[0] = -25.5, vecBossMin[1] = -38.5, vecBossMin[2] = -11.0;
// 	vecBossMax[0] = 18.0, vecBossMax[1] = 38.0, vecBossMax[2] = 138.5;

// 	float vecScaledBossMin[3], vecScaledBossMax[3];

// 	vecScaledBossMin = vecBossMin;
// 	vecScaledBossMax = vecBossMax;

// 	ScaleVector(vecScaledBossMin, fScale);
// 	ScaleVector(vecScaledBossMax, fScale);
// 	SetEntPropVector(entity, Prop_Send, "m_vecMins", vecScaledBossMin);
// 	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", vecScaledBossMax);
// }


// UpdatePlayerHitbox(const client, float fScale = 1.0)
// {
// 	//static const float vecTF2PlayerMin[3] = { -24.5, -24.5, 0.0 }, vecTF2PlayerMax[3] = { 24.5,  24.5, 83.0 };
// 	//static const float vecGenericPlayerMin[3] = { -16.5, -16.5, 0.0 }, vecGenericPlayerMax[3] = { 216.5,  216.5, 173.0 };
// 	static const float vecGenericPlayerMin[3] = { -1.0, -1.0, -1.0 }, vecGenericPlayerMax[3] = { 1.0,  1.0, 1.0 };
// 	float vecScaledPlayerMin[3], vecScaledPlayerMax[3];

// 	vecScaledPlayerMin = vecGenericPlayerMin;
// 	vecScaledPlayerMax = vecGenericPlayerMax;

// 	// ScaleVector(vecScaledPlayerMin, fScale);
// 	// ScaleVector(vecScaledPlayerMax, fScale);
// 	SetEntPropVector(client, Prop_Send, "m_vecSpecifiedSurroundingMins", vecScaledPlayerMin);
// 	SetEntPropVector(client, Prop_Send, "m_vecSpecifiedSurroundingMaxs", vecScaledPlayerMax);
// 	SetEntPropVector(client, Prop_Send, "m_vecMins", vecScaledPlayerMin);
// 	SetEntPropVector(client, Prop_Send, "m_vecMaxs", vecScaledPlayerMax);
// 	SetEntPropVector(client, Prop_Send, "m_vecSpecifiedSurroundingMins", vecScaledPlayerMin);
// 	SetEntPropVector(client, Prop_Send, "m_vecSpecifiedSurroundingMaxs", vecScaledPlayerMax);
// 	SetEntPropVector(client, Prop_Send, "m_vecMins", vecScaledPlayerMin);
// 	SetEntPropVector(client, Prop_Send, "m_vecMaxs", vecScaledPlayerMax);
// }