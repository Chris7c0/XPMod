Action:Event_PlayerHurt(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iAttacker = GetClientOfUserId(GetEventInt(hEvent,"attacker"));
	new iVictim  = GetClientOfUserId(GetEventInt(hEvent,"userid"));

	// // Reset bot action if hurt
	// if (RunClientChecks(iVictim) && IsFakeClient(iVictim) && IsPlayerAlive(iVictim))
	// {
	// 	ResetBotCommand(iVictim);
	// }

	// PrintToChatAll("Hitbox: %d | m_flModelScale %f | Collision: %d\nSolidType: %d | SolidFlags: %d\n",
	// 		GetEntProp(iVictim, Prop_Send, "m_nHitboxSet"),
	// 		GetEntPropFloat(iVictim, Prop_Send, "m_flModelScale"),
	// 		GetEntProp(iVictim, Prop_Send, "m_CollisionGroup"),
	// 		GetEntProp(iVictim, Prop_Send, "m_nSolidType"),
	// 		GetEntProp(iVictim, Prop_Send, "m_usSolidFlags"));

	// Note, this is never going to be called because this is not triggered for CI/UI
	// // Check if the iVictim is a CI/UI
	// if (iVictim < 1)
	// {
	// 	// No reason to address ci/ui being hurt. For now, its
	// 	// their death that matters, not hurt.
	// 	return Plugin_Continue;
	// }

	// // Testing Damage Here
	// new dmgHealth  = GetEventInt(hEvent,"dmg_health");
	// new dmgType = GetEventInt(hEvent, "type");
	// new hitGroup = GetEventInt(hEvent, "hitgroup");
	// PrintToChatAll("Attacker = %d, Victim = %d, dmgHealth = %d, dmgType = %d, hitGroup = %d", iAttacker, iVictim, dmgHealth, dmgType, hitGroup);
	// PrintToChatAll("%N dType = %d, Group = %d, dHealth = %d", iVictim, dmgType, hitGroup, dmgHealth);
	// PrintToChatAll("g_iInfectedCharacter[iAttacker] = %s", g_iInfectedCharacter[iAttacker]);
	// decl String:testweapon[32];
	// GetEventString(hEvent,"weapon", testweapon, 32);
	// PrintToChatAll("\x03-weapon: \x01%s, dmgHealth: %i",testweapon, dmgHealth);

	// Unfreeze player if they take any damage from SI
	if(g_bFrozenByTank[iVictim] == true && 
		g_iClientTeam[iVictim] == TEAM_SURVIVORS && 
		g_iClientTeam[iAttacker] == TEAM_INFECTED)
	{
		//Set Player Velocity To Zero
		TeleportEntity(iVictim, NULL_VECTOR, NULL_VECTOR, EMPTY_VECTOR);
		// Unfreeze them
		UnfreezePlayerByTank(iVictim);
	}
	
	EventsHurt_GiveXP(hEvent, iAttacker, iVictim);

	// Capture the players health for functionality like self revive on ledge
	StorePlayerHealth(iVictim);
	// This is to capture any extra damage that happens post player hurt
	CreateTimer(0.1, TimerStorePlayerHealth, iVictim, TIMER_FLAG_NO_MAPCHANGE);

	// Play headshot ding sound if they got one
	EventsHurt_PlayHeadshotDingSoundForHeadshots(hEvent, iAttacker, iVictim);

	// Reduce damage for low level human survivor players that are not incaped
	ReduceDamageTakenForNewPlayers(iVictim, GetEventInt(hEvent, "dmg_health"));
	
	EventsHurt_IncreaseCommonInfectedDamage(iAttacker, iVictim);

	new iDmgType = GetEventInt(hEvent, "type");

	// If iAttacker is a Common Infected, handle Enhanced CI abilites
	if(iAttacker < 1 && iDmgType == DAMAGETYPE_INFECTED_MELEE)
	{
		// Get the actual entity id of the CI
		new iCIEntity = GetEventInt(hEvent, "attackerentid");

		if (g_iClientTeam[iVictim] == TEAM_SURVIVORS)
		{
			// Find if the Enhanced CI entity in the list
			new iEnhancedCIIndex = FindIndexInArrayListUsingValue(g_listEnhancedCIEntities, iCIEntity, ENHANCED_CI_ENTITY_ID);

			// If the Enhanced CI is in the list continue
			if (iEnhancedCIIndex >= 0)
			{
				// Get the Enhanced Type
				new iEnhancedCIType = g_listEnhancedCIEntities.Get(iEnhancedCIIndex, ENHANCED_CI_TYPE);
				
				switch (iEnhancedCIType)
				{
					case ENHANCED_CI_TYPE_FIRE: EnhanceCIHandleDamage_Fire(iCIEntity, iVictim);
					case ENHANCED_CI_TYPE_ICE: EnhanceCIHandleDamage_Ice(iCIEntity, iVictim);
					case ENHANCED_CI_TYPE_NECRO: EnhanceCIHandleDamage_Necro(iCIEntity, iVictim);
					case ENHANCED_CI_TYPE_VAMPIRIC: EnhanceCIHandleDamage_Vampiric(iCIEntity, iVictim);
				}
			}
		}

		// No reason to continue beyond this point, because CI iAttacker will have no abilities
		return Plugin_Continue;
	}
		

	// Handle Survivors
	if (g_iClientTeam[iAttacker] == TEAM_SURVIVORS)
	{
		// Testing purposes (remove later once talents are in for it)
		MonitorVictimHealthMeterForSurvivorPlayer(iAttacker, iVictim);

		switch(g_iChosenSurvivor[iAttacker])
		{
			case BILL:		EventsHurt_AttackerBill(hEvent, iAttacker, iVictim);
			case ROCHELLE:	EventsHurt_AttackerRochelle(hEvent, iAttacker, iVictim);
			case COACH:		EventsHurt_AttackerCoach(hEvent, iAttacker, iVictim);
			case ELLIS:		EventsHurt_AttackerEllis(hEvent, iAttacker, iVictim);
			case NICK:		EventsHurt_AttackerNick(hEvent, iAttacker, iVictim);
			case LOUIS:		EventsHurt_AttackerLouis(hEvent, iAttacker, iVictim);
		}
	}
	if (g_iClientTeam[iVictim] == TEAM_SURVIVORS)
	{
		switch(g_iChosenSurvivor[iVictim])
		{
			// case BILL:		EventsHurt_VictimBill(hEvent, iAttacker, iVictim);
			// case ROCHELLE:	EventsHurt_VictimRochelle(hEvent, iAttacker, iVictim);
			// case COACH:		EventsHurt_VictimCoach(hEvent, iAttacker, iVictim);
			case ELLIS:		EventsHurt_VictimEllis(hEvent, iAttacker, iVictim);
			// case NICK:		EventsHurt_VictimNick(hEvent, iAttacker, iVictim);
			// case LOUIS:		EventsHurt_VictimLouis(hEvent, iAttacker, iVictim);
		}
	}

	// Handle Infected
	if (g_iClientTeam[iAttacker] == TEAM_INFECTED)
	{
		switch(g_iInfectedCharacter[iAttacker])
		{
			case SMOKER: 	EventsHurt_AttackerSmoker(hEvent, iAttacker, iVictim);
			// case BOOMER: 	EventsHurt_AttackerBoomer(hEvent, iAttacker, iVictim);
			case HUNTER: 	EventsHurt_AttackerHunter(hEvent, iAttacker, iVictim);
			case SPITTER: 	EventsHurt_AttackerSpitter(hEvent, iAttacker, iVictim);
			case JOCKEY:	EventsHurt_AttackerJockey(hEvent, iAttacker, iVictim);
			case CHARGER:	EventsHurt_AttackerCharger(hEvent, iAttacker, iVictim);
			case TANK: 		EventsHurt_AttackerTank(hEvent, iAttacker, iVictim);
		}
	}
	if (g_iClientTeam[iVictim] == TEAM_INFECTED)
	{
		switch(g_iInfectedCharacter[iVictim])
		{
			// case SMOKER: 	EventsHurt_VictimSmoker(hEvent, iAttacker, iVictim);
			// case BOOMER: 	EventsHurt_VictimBoomer(hEvent, iAttacker, iVictim);
			case HUNTER: 	EventsHurt_VictimHunter(hEvent, iAttacker, iVictim);
			// case SPITTER: 	EventsHurt_VictimSpitter(hEvent, iAttacker, iVictim);
			// case JOCKEY:	EventsHurt_VictimJockey(hEvent, iAttacker, iVictim);
			case CHARGER:	EventsHurt_VictimCharger(hEvent, iAttacker, iVictim);
			case TANK: 		EventsHurt_VictimTank(hEvent, iAttacker, iVictim);
		}
	}
	
	return Plugin_Continue;
}

void EventsHurt_GiveXP(Handle:hEvent, iAttacker, iVictim)
{
	new iDmgType = GetEventInt(hEvent, "type");
	new iDmgHealth  = GetEventInt(hEvent,"dmg_health");

	if (g_iClientTeam[iVictim] == TEAM_SURVIVORS && 
		g_iClientTeam[iAttacker] == TEAM_INFECTED && 
		IsClientInGame(iAttacker) == true && 
		IsFakeClient(iAttacker) == false)		//Damage XP Give
	{
		decl String:iWeaponClass[32];
		GetEventString(hEvent,"weapon",iWeaponClass,32);
		//PrintToChat(iAttacker, "weaponclass = %s", iWeaponClass);
		
		if(iDmgType == 263168 || iDmgType == 265216)
		{
			g_iClientXP[iAttacker] += 3;
			CheckLevel(iAttacker);
			
			if(g_iXPDisplayMode[iAttacker] == 0)
				ShowXPSprite(iAttacker, g_iSprite_3XP_SI, iVictim, 1.0);
		}
		else if((g_iChokingVictim[iAttacker] > 0 && StrEqual(iWeaponClass, "smoker_claw") == true) ||
			(g_iHunterShreddingVictim[iAttacker] > 0 && StrEqual(iWeaponClass, "hunter_claw") == true) || 
			(g_iJockeyVictim[iAttacker] > 0 && StrEqual(iWeaponClass, "jockey_claw") == true))
		{
			g_iClientXP[iAttacker] += 10;
			CheckLevel(iAttacker);
			
			if(g_iXPDisplayMode[iAttacker] == 0)
				ShowXPSprite(iAttacker, g_iSprite_10XP_SI, iVictim, 1.0);
		}
		else if(StrEqual(iWeaponClass, "hunter_claw") == true || StrEqual(iWeaponClass, "smoker_claw") == true || StrEqual(iWeaponClass, "jockey_claw") == true || 
				StrEqual(iWeaponClass, "boomer_claw") == true || StrEqual(iWeaponClass, "spitter_claw") == true || StrEqual(iWeaponClass, "charger_claw") == true  || 
				StrEqual(iWeaponClass, "tank_claw") == true ||	StrEqual(iWeaponClass, "tank_rock") == true)
		{
			g_iClientXP[iAttacker] += 15;
			CheckLevel(iAttacker);
			
			if(g_iXPDisplayMode[iAttacker] == 0)
				ShowXPSprite(iAttacker, g_iSprite_15XP_SI, iVictim, 1.0);
		}
		
		
		//Limit because some attacks may give too many points
		if(iDmgHealth < 750)
			g_iStat_ClientDamageToSurvivors[iAttacker] += iDmgHealth;
		else
			g_iStat_ClientDamageToSurvivors[iAttacker] += 750;
	}

	//Give Assitance XP for Boomer
	if(g_iVomitVictimAttacker[iVictim] > 0)
	{
		if(IsClientInGame(g_iVomitVictimAttacker[iVictim]) == true && IsFakeClient(g_iVomitVictimAttacker[iVictim]) == false)
		{
			if(iDmgHealth < 250)
				g_iStat_ClientDamageToSurvivors[g_iVomitVictimAttacker[iVictim]] += iDmgHealth;
			else
				g_iStat_ClientDamageToSurvivors[g_iVomitVictimAttacker[iVictim]] += 250;
			
			decl String:iMessage[64];
			Format(iMessage, sizeof(iMessage), "Assited against %N.", iVictim);
			GiveClientXP(g_iVomitVictimAttacker[iVictim], 3, g_iSprite_3XP_SI, iVictim, iMessage, true, 1.0);
		}
	}

	// Subtract XP for Friendly Fire
	if (iAttacker > 0 &&
		IsFakeClient(iAttacker) == false && 
		iAttacker != iVictim && 
		g_iClientTeam[iAttacker] == g_iClientTeam[iVictim] &&
		g_iClientXP[iAttacker] > g_iClientPreviousLevelXPAmount[iAttacker])
	{
		g_iClientXP[iAttacker] -= 2;
		//PrintCenterText(iAttacker, "Attacked Team. -2 XP");
	}
}

void EventsHurt_IncreaseCommonInfectedDamage(iAttacker, iVictim)
{
	if (iAttacker < 1 && // If iAttacker is a Common Infected
		g_bCommonInfectedDoMoreDamage == true &&
		g_iClientTeam[iVictim] == TEAM_SURVIVORS &&
		RunClientChecks(iVictim) &&
		IsPlayerAlive(iVictim))	
	{
		new hp = GetPlayerHealth(iVictim);
		new Float:fTempHealth = GetEntDataFloat(iVictim, g_iOffset_HealthBuffer);
		if(fTempHealth > 0)
		{
			fTempHealth -= 1.0;
			SetEntDataFloat(iVictim, g_iOffset_HealthBuffer, fTempHealth ,true);
		}
		else
			SetPlayerHealth(iVictim, hp - 1);
	}
}

void EventsHurt_PlayHeadshotDingSoundForHeadshots(Handle:hEvent, iAttacker, iVictim)
{
	if (g_iClientTeam[iAttacker] != TEAM_SURVIVORS || 
		g_iClientTeam[iVictim] != TEAM_INFECTED ||
		IsClientInGame(iAttacker) == false ||
		IsFakeClient(iAttacker) == true)
		return;
	
	if (GetEventInt(hEvent, "hitgroup") == HITGROUP_HEAD)
		EmitSoundToClient(iAttacker, SOUND_HEADSHOT);
}