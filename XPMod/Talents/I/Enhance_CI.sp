bool IsCommonInfected(int entity, const char[] classname)
{
	if (strlen(classname) > 0)
	{
		return StrEqual(classname, "infected");
	}
	else if (IsValidEntity(entity))
	{
		new String:strClassname[100];
		GetEntityClassname(entity,strClassname,100);
		return StrEqual(strClassname, "infected");
	}

	return false;
}

void EnhanceCIIfNeeded(int iEntity)
{
	//new iEnhanceCIChance = CalculateCIEnhancementChance();

	bool bRollInfectedChance = GetRandomInt(1, 100) <= 75 ? true : false;

	if (bRollInfectedChance)
		RandomlyEnhanceCommonInfected(iEntity, true, 100);
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
	
	PrintToServer("g_listEnhancedCIEntities %i: Type: %i", iEntity, iEnchancedCIType);
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
		PrintToServer("Enhanced CI Destroyed %i", iEntity);
	}
}

RandomlyEnhanceCommonInfected(iZombie, bool:bIsBigOrSmall = true, iAbilitiesChance = 0)
{
	if (bIsBigOrSmall)
	{
		new Float:fHealthAndSizeMultiplier = GetRandomFloat(0.0, 1.0);
		if(GetRandomInt(0, 1))
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

	if (GetRandomInt(1, 100) <= iAbilitiesChance)
	{
		switch(GetRandomInt(ENHANCED_CI_TYPE_FIRE, ENHANCED_CI_TYPE_VAMPIRIC))
		{
			case ENHANCED_CI_TYPE_FIRE: EnhanceCISet_Fire(iZombie);
			case ENHANCED_CI_TYPE_ICE: EnhanceCISet_Ice(iZombie);
			case ENHANCED_CI_TYPE_NECRO: EnhanceCISet_Necro(iZombie);
			case ENHANCED_CI_TYPE_VAMPIRIC: EnhanceCISet_Vampiric(iZombie);
		}
	}
}

EnhanceCISetScale(iZombie, Float:fScale = -1.0)
{
	if (fScale == -1.0)
		fScale = GetRandomFloat(CI_SMALL_MIN_SIZE, CI_BIG_MAX_SIZE);
	
	PrintToChatAll("CI_SCALE: %f", fScale);
	SetEntPropFloat(iZombie, Prop_Send, "m_flModelScale", fScale);
}

EnhanceCISetHealth(iZombie, iHealth = -1)
{
	if (iHealth == -1.0)
		iHealth = GetRandomInt(CI_SMALL_MIN_HEALTH, CI_BIG_MAX_HEALTH);

	PrintToChatAll("CI_HEALTH: %i", iHealth);
	SetEntProp(iZombie, Prop_Data, "m_iHealth", iHealth);
}

EnhanceCISet_Fire(iZombie)
{
	// Store the entity and type into the Enhanced CI Array List
	PushZombieOnEnhancedCIEntitiesList(iZombie, ENHANCED_CI_TYPE_FIRE);

	// Change Skin Color
	SetClientRenderColor(iZombie, 255, 200, 30, 255, RENDER_MODE_NORMAL);
	// Change Outline Glow
	SetClientGlow(iZombie, 250, 50, 20, GLOWTYPE_ONVISIBLE);
}

EnhanceCISet_Ice(iZombie)
{
	// Store the entity and type into the Enhanced CI Array List
	PushZombieOnEnhancedCIEntitiesList(iZombie, ENHANCED_CI_TYPE_ICE);

	// Change Skin Color
	SetClientRenderColor(iZombie, 0, 255, 255, 255, RENDER_MODE_NORMAL);
	// Change Outline Glow
	SetClientGlow(iZombie, 80, 240, 255, GLOWTYPE_ONVISIBLE);
}

EnhanceCISet_Necro(iZombie)
{
	// Store the entity and type into the Enhanced CI Array List
	PushZombieOnEnhancedCIEntitiesList(iZombie, ENHANCED_CI_TYPE_NECRO);

	// Change Skin Color
	SetClientRenderColor(iZombie, 0, 130, 40, 255, RENDER_MODE_NORMAL);
	// Change Outline Glow
	SetClientGlow(iZombie, 0, 130, 40, GLOWTYPE_ONVISIBLE);
}

EnhanceCISet_Vampiric(iZombie)
{
	// Store the entity and type into the Enhanced CI Array List
	PushZombieOnEnhancedCIEntitiesList(iZombie, ENHANCED_CI_TYPE_VAMPIRIC);

	// Change Skin Color
	SetClientRenderColor(iZombie, 100, 0, 255, 255, RENDER_MODE_NORMAL);
	// Change Outline Glow
	SetClientGlow(iZombie, 100, 0, 255, GLOWTYPE_ONVISIBLE);
}

EnhanceCIHandleDamage_Fire(iAttacker, iVictim)
{
	SuppressNeverUsedWarning(iAttacker);

	PrintToChatAll("FIRE**")

	IgniteEntity(iVictim, 5.0, false);
}

EnhanceCIHandleDamage_Ice(iAttacker, iVictim)
{
	SuppressNeverUsedWarning(iAttacker);

	CreateTimer(0.1, Timer_FreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(3.0, Timer_UnfreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
}

EnhanceCIHandleDamage_Necro(iAttacker, iVictim)
{
	SuppressNeverUsedWarning(iAttacker);

	SpawnCIAroundPlayer(iVictim, 1, true);
}

EnhanceCIHandleDamage_Vampiric(iAttacker, iVictim)
{
	DealDamage(iVictim, iAttacker, 1);

	new iCurrentHealth = GetEntProp(iAttacker,Prop_Data,"m_iHealth");
	//PrintToChatAll("ENHANCED_CI_HEALTH_START_STEAL %i", iCurrentHealth);
	SetEntProp(iAttacker, Prop_Data, "m_iHealth", iCurrentHealth + 30);
	//iCurrentHealth = GetEntProp(iAttacker,Prop_Data,"m_iHealth");
	//PrintToChatAll("ENHANCED_CI_HEALTH_POST_STEAL %i", iCurrentHealth);
}


// ResizeHitbox(entity, Float:fScale = 1.0)
// {
// 	decl Float:vecBossMin[3], Float:vecBossMax[3];
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

// 	decl Float:vecScaledBossMin[3], Float:vecScaledBossMax[3];

// 	vecScaledBossMin = vecBossMin;
// 	vecScaledBossMax = vecBossMax;

// 	ScaleVector(vecScaledBossMin, fScale);
// 	ScaleVector(vecScaledBossMax, fScale);
// 	SetEntPropVector(entity, Prop_Send, "m_vecMins", vecScaledBossMin);
// 	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", vecScaledBossMax);
// }


// UpdatePlayerHitbox(const client, Float:fScale = 1.0)
// {
// 	//static const Float:vecTF2PlayerMin[3] = { -24.5, -24.5, 0.0 }, Float:vecTF2PlayerMax[3] = { 24.5,  24.5, 83.0 };
// 	//static const Float:vecGenericPlayerMin[3] = { -16.5, -16.5, 0.0 }, Float:vecGenericPlayerMax[3] = { 216.5,  216.5, 173.0 };
// 	static const Float:vecGenericPlayerMin[3] = { -1.0, -1.0, -1.0 }, Float:vecGenericPlayerMax[3] = { 1.0,  1.0, 1.0 };
// 	decl Float:vecScaledPlayerMin[3], Float:vecScaledPlayerMax[3];

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