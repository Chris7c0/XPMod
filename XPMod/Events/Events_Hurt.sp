Action:Event_PlayerHurt(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"attacker"));
	new victim  = GetClientOfUserId(GetEventInt(hEvent,"userid"));

	// Theres currently no reason to address ci/ui being hurt. Typically, its
	// their death that matters, not hurt.
	if(victim < 1)
		return Plugin_Continue;

	// // Testing Damage Here
	// new dmgHealth  = GetEventInt(hEvent,"dmg_health");
	// new dmgType = GetEventInt(hEvent, "type");
	// new hitGroup = GetEventInt(hEvent, "hitgroup");
	// PrintToChatAll("Attacker = %d, Victim = %d, dmgHealth = %d, dmgType = %d, hitGroup = %d", attacker, victim, dmgHealth, dmgType, hitGroup);
	// PrintToChatAll("%N dType = %d, Group = %d, dHealth = %d", victim, dmgType, hitGroup, dmgHealth);
	// PrintToChatAll("g_iInfectedCharacter[attacker] = %s", g_iInfectedCharacter[attacker]);
	// decl String:testweapon[32];
	// GetEventString(hEvent,"weapon", testweapon, 32);
	// PrintToChatAll("\x03-weapon: \x01%s, dmgHealth: %i",testweapon, dmgHealth);

	// Unfreeze player if they take any damage
	if(g_bFrozenByTank[victim] == true && g_iClientTeam[victim] == TEAM_SURVIVORS)
	{
		//Set Player Velocity To Zero
		TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, EMPTY_VECTOR);
		// Unfreeze them
		UnfreezePlayerByTank(victim);
	}
	
	EventsHurt_GiveXP(hEvent, attacker, victim);
	
	EventsHurt_IncreaseCommonInfectedDamage(attacker, victim);

	new iDmgType = GetEventInt(hEvent, "type");

	// If attacker is a Common Infected, no reason to continue beyond this point
	if(attacker < 1 && iDmgType == DAMAGETYPE_INFECTED_MELEE)
		return Plugin_Continue;

	// Handle Survivors
	if (g_iClientTeam[attacker] == TEAM_SURVIVORS) // && g_iClientTeam[victim] == TEAM_INFECTED)
	{
		switch(g_iChosenSurvivor[attacker])
		{
			case BILL:		EventsHurt_AttackerBill(hEvent, attacker, victim);
			case ROCHELLE:	EventsHurt_AttackerRochelle(hEvent, attacker, victim);
			case COACH:		EventsHurt_AttackerCoach(hEvent, attacker, victim);
			case ELLIS:		EventsHurt_AttackerEllis(hEvent, attacker, victim);
			case NICK:		EventsHurt_AttackerNick(hEvent, attacker, victim);
		}
	}
	if (g_iClientTeam[victim] == TEAM_SURVIVORS)
	{
		switch(g_iChosenSurvivor[victim])
		{
			// case BILL:		EventsHurt_VictimBill(hEvent, attacker, victim);
			// case ROCHELLE:	EventsHurt_VictimRochelle(hEvent, attacker, victim);
			// case COACH:		EventsHurt_VictimCoach(hEvent, attacker, victim);
			case ELLIS:		EventsHurt_VictimEllis(hEvent, attacker, victim);
			// case NICK:		EventsHurt_VictimNick(hEvent, attacker, victim);
		}
	}

	// Handle Infected
	if (g_iClientTeam[attacker] == TEAM_INFECTED)
	{
		switch(g_iInfectedCharacter[attacker])
		{
			case SMOKER: 	EventsHurt_AttackerSmoker(hEvent, attacker, victim);
			// case BOOMER: 	EventsHurt_AttackerBoomer(hEvent, attacker, victim);
			case HUNTER: 	EventsHurt_AttackerHunter(hEvent, attacker, victim);
			case SPITTER: 	EventsHurt_AttackerSpitter(hEvent, attacker, victim);
			case JOCKEY:	EventsHurt_AttackerJockey(hEvent, attacker, victim);
			case CHARGER:	EventsHurt_AttackerCharger(hEvent, attacker, victim);
			case TANK: 		EventsHurt_AttackerTank(hEvent, attacker, victim);
		}
	}
	if (g_iClientTeam[victim] == TEAM_INFECTED)
	{
		switch(g_iInfectedCharacter[victim])
		{
			// case SMOKER: 	EventsHurt_VictimSmoker(hEvent, attacker, victim);
			// case BOOMER: 	EventsHurt_VictimBoomer(hEvent, attacker, victim);
			case HUNTER: 	EventsHurt_VictimHunter(hEvent, attacker, victim);
			// case SPITTER: 	EventsHurt_VictimSpitter(hEvent, attacker, victim);
			// case JOCKEY:	EventsHurt_VictimJockey(hEvent, attacker, victim);
			case CHARGER:	EventsHurt_VictimCharger(hEvent, attacker, victim);
			case TANK: 		EventsHurt_VictimTank(hEvent, attacker, victim);
		}
	}
	
	return Plugin_Continue;
}

EventsHurt_GiveXP(Handle:hEvent, attacker, victim)
{
	new iDmgType = GetEventInt(hEvent, "type");
	new iDmgHealth  = GetEventInt(hEvent,"dmg_health");

	if (g_iClientTeam[victim] == TEAM_SURVIVORS && 
		g_iClientTeam[attacker] == TEAM_INFECTED && 
		IsClientInGame(attacker) == true && 
		IsFakeClient(attacker) == false)		//Damage XP Give
	{
		decl String:iWeaponClass[32];
		GetEventString(hEvent,"weapon",iWeaponClass,32);
		//PrintToChat(attacker, "weaponclass = %s", iWeaponClass);
		
		if(iDmgType == 263168 || iDmgType == 265216)
		{
			g_iClientXP[attacker] += 3;
			CheckLevel(attacker);
			
			if(g_iXPDisplayMode[attacker] == 0)
				ShowXPSprite(attacker, g_iSprite_3XP_SI, victim, 1.0);
		}
		else if((g_iChokingVictim[attacker] > 0 && StrEqual(iWeaponClass, "smoker_claw") == true) ||
			(g_iHunterShreddingVictim[attacker] > 0 && StrEqual(iWeaponClass, "hunter_claw") == true) || 
			(g_iJockeyVictim[attacker] > 0 && StrEqual(iWeaponClass, "jockey_claw") == true))
		{
			g_iClientXP[attacker] += 10;
			CheckLevel(attacker);
			
			if(g_iXPDisplayMode[attacker] == 0)
				ShowXPSprite(attacker, g_iSprite_10XP_SI, victim, 1.0);
		}
		else if(StrEqual(iWeaponClass, "hunter_claw") == true || StrEqual(iWeaponClass, "smoker_claw") == true || StrEqual(iWeaponClass, "jockey_claw") == true || 
				StrEqual(iWeaponClass, "boomer_claw") == true || StrEqual(iWeaponClass, "spitter_claw") == true || StrEqual(iWeaponClass, "charger_claw") == true  || 
				StrEqual(iWeaponClass, "tank_claw") == true ||	StrEqual(iWeaponClass, "tank_rock") == true)
		{
			g_iClientXP[attacker] += 15;
			CheckLevel(attacker);
			
			if(g_iXPDisplayMode[attacker] == 0)
				ShowXPSprite(attacker, g_iSprite_15XP_SI, victim, 1.0);
		}
		
		
		//Limit because some attacks may give too many points
		if(iDmgHealth < 750)
			g_iStat_ClientDamageToSurvivors[attacker] += iDmgHealth;
		else
			g_iStat_ClientDamageToSurvivors[attacker] += 750;
	}

	//Give Assitance XP for Boomer
	if(g_iVomitVictimAttacker[victim] > 0)
	{
		if(IsClientInGame(g_iVomitVictimAttacker[victim]) == true && IsFakeClient(g_iVomitVictimAttacker[victim]) == false)
		{
			if(iDmgHealth < 250)
				g_iStat_ClientDamageToSurvivors[g_iVomitVictimAttacker[victim]] += iDmgHealth;
			else
				g_iStat_ClientDamageToSurvivors[g_iVomitVictimAttacker[victim]] += 250;
			
			decl String:iMessage[64];
			Format(iMessage, sizeof(iMessage), "Assited against %N.", victim);
			GiveClientXP(g_iVomitVictimAttacker[victim], 3, g_iSprite_3XP_SI, victim, iMessage, true, 1.0);
		}
	}

	// Subtract XP for Friendly Fire
	if (attacker > 0 &&
		IsFakeClient(attacker) == false && 
		attacker != victim && 
		g_iClientTeam[attacker] == g_iClientTeam[victim] &&
		g_iClientXP[attacker] > g_iClientPreviousLevelXPAmount[attacker])
	{
		g_iClientXP[attacker] -= 2;
		PrintCenterText(attacker, "Attacked Team. -2 XP");
	}
}

EventsHurt_IncreaseCommonInfectedDamage(attacker, victim)
{
	if (attacker < 1 && // If attacker is a Common Infected
		g_bCommonInfectedDoMoreDamage == true &&
		g_iClientTeam[victim] == TEAM_SURVIVORS &&
		RunClientChecks(victim) &&
		IsPlayerAlive(victim))	
	{
		new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
		new Float:fTempHealth = GetEntDataFloat(victim, g_iOffset_HealthBuffer);
		if(fTempHealth > 0)
		{
			fTempHealth -= 1.0;
			SetEntDataFloat(victim, g_iOffset_HealthBuffer, fTempHealth ,true);
		}
		else
			SetEntProp(victim,Prop_Data,"m_iHealth", hp - 1);
	}
}