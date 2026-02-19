Action Event_PlayerDeath(Handle hEvent, char[] Event_name, bool dontBroadcast)
{
	int iVictim = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	int iAttacker = GetClientOfUserId(GetEventInt(hEvent, "attacker"));


	// Handle giving out XP for kill rewards
	EventsDeath_GiveXP(hEvent, iAttacker, iVictim);
	
	// If iVictim was 0 then it was a common/uncommon infected
	if(iVictim < 1)
	{
		EventsDeath_PlayHeadshotDingSoundForCIHeadshots(hEvent, iAttacker);

		// Get Common Infected Victim from event int, Previously iVictim only gives player IDs
		int iCIVictim = GetEventInt(hEvent, "entityid");

		// Handle Enhanced CI deaths
		PopZombieOffEnhancedCIEntitiesList(iCIVictim);

		// Handle NecroTanker Common Infected consumption for health
		HandleNecroTankerInfectedConsumption(iAttacker, iCIVictim);
	}

	
	// If a Survivor, pop up the create XPMod account menu for new user if they die
	if(RunClientChecks(iVictim) && 
		g_bClientLoggedIn[iVictim] == false && 
		g_iClientTeam[iVictim] == TEAM_SURVIVORS &&
		IsFakeClient(iVictim) == false)
		XPModMenuDraw(iVictim);
	
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

void EventsDeath_PlayHeadshotDingSoundForCIHeadshots(Handle hEvent, int iAttacker)
{
	if (g_iClientTeam[iAttacker] != TEAM_SURVIVORS || 
		IsClientInGame(iAttacker) == false ||
		IsFakeClient(iAttacker) == true)
		return;
	
	if (GetEventBool(hEvent, "headshot"))
		EmitSoundToClient(iAttacker, SOUND_HEADSHOT);
}
