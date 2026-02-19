void Handle2SecondClientTimers_Rochelle(int iClient)
{
	if (g_iSniperLevel[iClient]==5)
		SetEntData(iClient,g_iOffset_ShovePenalty,0);

	if (g_iGatherLevel[iClient] > 0 && g_bClientIDDToggle[iClient] == true)
		DetectionHud(iClient);

	HandleRochelleRopeGain(iClient);
}

Action Timer_RochelleRugerHitCheck(Handle timer, any iClient)
{
	// Check for an Infected bullet Miss. It being greater than 0 means the stack was not removed
	// This will take back any pre given stacks that were given during the event hit processes
	if (g_iRochelleRugerHitCounter[iClient] > 0 ) {
		g_iRochelleRugerStacks[iClient] -= (ROCHELLE_RUGER_STACKS_LOST_ON_MISS + g_iRochelleRugerLastHitStackCount[iClient]);

		if (g_iRochelleRugerStacks[iClient] <= 0)
			g_iRochelleRugerStacks[iClient] = 0
	}
	
	// Reset the values for the next bullet shot
	g_iRochelleRugerHitCounter[iClient] = 0;
	g_iRochelleRugerLastHitStackCount[iClient] = 0;

	PrintToChat(iClient, "\x03[XPMod] \x04 Hunting Rifle Dmg: \x05+%i%", 
		RoundToNearest(100 * (g_iRochelleRugerStacks[iClient] * ROCHELLE_RUGER_DMG_PER_STACK)) );
	
	return Plugin_Stop;
}

Action Timer_RochelleAWPResetChargeLevel(Handle timer, any iClient)
{
	if (g_bRochelleAWPCharged[iClient] == true)
		PrintToChat(iClient, "\x03[XPMod] \x04AWP Charge: \x01EMPTY");

	g_bRochelleAWPCharged[iClient] = false;
	g_iRochelleAWPChargeLevel[iClient] = 0;

	return Plugin_Stop;
}


Action Timer_BreakFreeOfSmoker(Handle timer, any iClient)
{
	TeleportEntity(iClient, g_xyzOriginalPositionRochelle[iClient], NULL_VECTOR, NULL_VECTOR);
	CreateRochelleSmoke(iClient);
	
	return Plugin_Stop;
}

Action TimerStopShadowNinja(Handle timer, any iClient)
{
	g_bUsingShadowNinja[iClient] = false;
	
	if(IsValidEntity(iClient) == true && IsClientInGame(iClient) == true)
	{
		SetEntityRenderMode(iClient, RenderMode:0);
		SetEntityRenderColor(iClient, 255, 255, 255, 255);
		SetEntProp(iClient, Prop_Send, "m_iGlowType", 0);
		SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
		SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 0);
		ChangeEdictState(iClient, 12);
		SetClientSpeed(iClient);
		
		switch(g_iClientBindUses_2[iClient])
		{
			case 1:
			{
				g_iPID_RochelleCharge1[iClient] = WriteParticle(iClient, "rochelle_ulti_ninja_charge1", 0.0);
				g_iPID_RochelleCharge2[iClient] = WriteParticle(iClient, "rochelle_ulti_ninja_charge2", 0.0);
			}
			case 2:
			{
				g_iPID_RochelleCharge1[iClient] = WriteParticle(iClient, "rochelle_ulti_ninja_charge1", 0.0);
			}
		}
	}
	
	return Plugin_Stop;
}

Action TimerPoison(Handle timer, any iClient)
{
	if(IsValidEntity(iClient) == false || IsClientInGame(iClient) == false || IsPlayerAlive(iClient) == false || g_bIsRochellePoisoned[iClient] == false)
	{
		DeleteParticleEntity(g_iPID_RochellePoisonBullet[iClient]);
		g_bIsRochellePoisoned[iClient] = false;
		g_hTimer_RochellePoison[iClient] = null;
		return Plugin_Stop;
	}

	if(g_iSlapRunTimes[iClient]++ < 5)
	{
		if(IsFakeClient(iClient)==false)
			ShowHudOverlayColor(iClient, 0, 100, 0, 100, 300, FADE_IN);
		
		CreateTimer(0.8, TimerPoisonFade, iClient, TIMER_FLAG_NO_MAPCHANGE);	//Make the effect fade away and dmg iClient(victim)
		return Plugin_Continue;
	}

	g_bIsRochellePoisoned[iClient] = false;	
	g_hTimer_RochellePoison[iClient] = null;

	return Plugin_Stop;
}

Action TimerPoisonFade(Handle timer, any iClient)
{
	if(IsValidEntity(iClient) == false || IsClientInGame(iClient)==false || IsPlayerAlive(iClient)==false)
		return Plugin_Stop;
	
	int hp = GetPlayerHealth(iClient);
	if(hp < 16)
		ForcePlayerSuicide(iClient);
	else
		SetPlayerHealth(iClient, -1, hp - 25);
		
	WriteParticle(iClient, "poison_bubbles", 0.0, 3.0);
	
	if(IsFakeClient(iClient)==false)
		ShowHudOverlayColor(iClient, 0, 100, 0, 100, 300, FADE_OUT);
	
	return Plugin_Stop;
}

Action TimerIDD(Handle timer, any data)
{
	if (IsServerProcessing()==false)
		return Plugin_Continue;
	for (int iClient = 1;iClient<= MaxClients; iClient++)
	{
		if(IsClientInGame(iClient)==true)
		{
			if(g_iGatherLevel[iClient] > 0)
				if(g_bClientIDDToggle[iClient] == true)
					DetectionHud(iClient);
		}
	}
	return Plugin_Continue;
}
