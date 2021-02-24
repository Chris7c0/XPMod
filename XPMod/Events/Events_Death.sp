Action:Event_PlayerDeath(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iVictim = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new iAttacker = GetClientOfUserId(GetEventInt(hEvent, "attacker"));

	//PrintToChatAll("Event_PlayerDeath: iVictim %N, iAttacker: %N", iVictim, iAttacker);

	// Handle giving out XP for kill rewards
	EventsDeath_GiveXP(hEvent, iAttacker, iVictim);
	
	// If iVictim was 0 then it was a common/uncommon infected
	if(iVictim < 1)
	{
		EventsDeath_PlayHeadshotDingSoundForCIHeadshots(hEvent, iAttacker);

		// Get Common Infected Victim from event int, Previously iVictim only gives player IDs
		new iCIVictim = GetEventInt(hEvent, "entityid");

		// Handle Enhanced CI deaths
		PopZombieOffEnhancedCIEntitiesList(iCIVictim);

		// Handle NecroTanker Common Infected consumption for health
		HandleNecroTankerInfectedConsumption(iAttacker, iCIVictim);
	}

	//PrintToChatAll("iVictim = %N, team = %d, g_iInfectedCharacter = %d", iVictim, g_iClientTeam[iVictim], g_iInfectedCharacter[iVictim]);
	
	// If a Survivor, pop up the create XPMod account menu for new user if they die
	if(RunClientChecks(iVictim) && 
		g_bClientLoggedIn[iVictim] == false && 
		g_iClientTeam[iVictim] == TEAM_SURVIVORS &&
		IsFakeClient(iVictim) == false)
		XPModMenuDraw(iVictim);
	
	// This could be the cause of some issues, but also might be required in some places, put it in the appropriate places.
	// if (iAttacker < 1)
	// 	return Plugin_Continue;




	// Infected Attackers ///////////////////////////////////////////////////////////////////////////
	// EventsDeath_AttackerSmoker(hEvent, iAttacker, iVictim);
	// EventsDeath_AttackerBoomer(hEvent, iAttacker, iVictim);
	// EventsDeath_AttackerHunter(hEvent, iAttacker, iVictim);
	// EventsDeath_AttackerSpitter(hEvent, iAttacker, iVictim);
	// EventsDeath_AttackerJockey(hEvent, iAttacker, iVictim);
	// EventsDeath_AttackerCharger(hEvent, iAttacker, iVictim);
	// EventsDeath_AttackerTank(hEvent, iAttacker, iVictim);

	// Infected Victims /////////////////////////////////////////////////////////////////////////////
	EventsDeath_VictimSmoker(hEvent, iAttacker, iVictim);
	EventsDeath_VictimBoomer(hEvent, iAttacker, iVictim);
	//EventsDeath_VictimHunter(hEvent, iAttacker, iVictim);
	//EventsDeath_VictimSpitter(hEvent, iAttacker, iVictim);
	//EventsDeath_VictimJockey(hEvent, iAttacker, iVictim);
	//EventsDeath_VictimCharger(hEvent, iAttacker, iVictim);
	EventsDeath_VictimTank(hEvent, iAttacker, iVictim);

	// Survivor Attackers ////////////////////////////////////////////////////////////////////////////
	// EventsDeath_AttackerBill(hEvent, iAttacker, iVictim);
	EventsDeath_AttackerRochelle(hEvent, iAttacker, iVictim);
	EventsDeath_AttackerCoach(hEvent, iAttacker, iVictim);
	EventsDeath_AttackerEllis(hEvent, iAttacker, iVictim);
	// EventsDeath_AttackerNick(hEvent, iAttacker, iVictim);
	EventsDeath_AttackerLouis(hEvent, iAttacker, iVictim);
	
	// Survivor Victims //////////////////////////////////////////////////////////////////////////////
	// EventsDeath_VictimBill(hEvent, iAttacker, iVictim);
	// EventsDeath_VictimRochelle(hEvent, iAttacker, iVictim);
	EventsDeath_VictimCoach(hEvent, iAttacker, iVictim);
	// EventsDeath_VictimEllis(hEvent, iAttacker, iVictim);
	EventsDeath_VictimNick(hEvent, iAttacker, iVictim);
	//EventsDeath_VictimLouis(hEvent, iAttacker, iVictim);

	// Reset all the variables that should be here
	Event_DeathResetAllVariables(iAttacker, iVictim);

	// Reset the client's current speed
	if (iVictim > 0 && iAttacker > 0)
	{
		SetClientSpeed(iVictim);
		SetClientSpeed(iAttacker);
	}

	return Plugin_Continue;
}



Event_DeathResetAllVariables(iAttacker, iVictim)
{
	if(g_bIsClientDown[iVictim] == true)
	{
		g_bWasClientDownOnDeath[iVictim] = true;
	}
	g_bIsClientDown[iVictim] = false;
	clienthanging[iVictim] = false;

	if(g_bEnabledVGUI[iVictim] == true && g_bShowingVGUI[iVictim] == true)
		DeleteAllMenuParticles(iVictim);

	// Infected //////////////////////////////////////////////////////////////////////////

	// We now do not know which infected they have, because they dead
	// These need to take place in this order, set UNKNOWN, then set CanBeGhost
	g_iInfectedCharacter[iVictim] = UNKNOWN_INFECTED;
	// For checking if the player is a ghost
	g_bCanBeGhost[iVictim] = true;
	g_bIsGhost[iVictim] = false;

	g_bIsBoomerVomiting[iVictim] = false;
	g_bIsSuicideBoomer[iVictim] = false;
	g_bIsSuicideJumping[iVictim] = false;
	g_bHasInfectedHealthBeenSet[iVictim] = false;
	g_bIsHillbillyEarthquakeReady[iVictim] = false;
	g_iBagOfSpitsSelectedSpit[iVictim] = BAG_OF_SPITS_NONE;

	if(g_iHunterShreddingVictim[iVictim] > 0)
		SetClientSpeed(g_iHunterShreddingVictim[iVictim]);
	
	//Tank
	ResetAllTankVariables(iVictim);

	//Grapples
	g_bHunterGrappled[iVictim] = false;
	g_iHunterShreddingVictim[iVictim] = -1;
	g_bHunterGrappled[iAttacker] = false;		//Need to do it for both of them
	g_iHunterShreddingVictim[iAttacker] = -1;
	g_bSmokerGrappled[iVictim] = false;
	g_bChargerGrappled[iVictim] = false;
	g_bSmokerGrappled[iAttacker] = false;
	g_bChargerGrappled[g_iChargerVictim[iVictim]] = false;
	g_bChargerGrappled[iVictim] = false;
	g_iChargerVictim[iVictim] = 0;
	g_iJockeyVictim[iVictim] = -1;
	
	g_iShowSurvivorVomitCounter[iVictim] = 0;

	// Survivors //////////////////////////////////////////////////////////////////////////
	
	g_bUsingFireStorm[iVictim] = false;
	g_bUsingShadowNinja[iVictim] = false;
	g_bIsJetpackOn[iVictim] = false;
	g_bUsingTongueRope[iVictim] = false;
	DeleteAllClientParticles(iVictim);

	if(g_bIsRochellePoisoned[iVictim]==true)
	{
		DeleteParticleEntity(g_iPID_RochellePoisonBullet[iVictim]);
		WriteParticle(iVictim, "poison_bullet_pool", 0.0, 41.0);
	}
	g_bHunterLethalPoisoned[iVictim] = false;
}

EventsDeath_PlayHeadshotDingSoundForCIHeadshots(Handle:hEvent, iAttacker)
{
	if (g_iClientTeam[iAttacker] != TEAM_SURVIVORS || 
		IsClientInGame(iAttacker) == false ||
		IsFakeClient(iAttacker) == true)
		return;
	
	if (GetEventBool(hEvent, "headshot"))
		EmitSoundToClient(iAttacker, SOUND_HEADSHOT);
}