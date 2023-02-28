void Bind1Press_Jockey(iClient)
{
	if ((g_iClientInfectedClass1[iClient] != JOCKEY) && 
		(g_iClientInfectedClass2[iClient] != JOCKEY) && 
		(g_iClientInfectedClass3[iClient] != JOCKEY))
	{
		PrintHintText(iClient, "You dont have the Jockey as one of your classes");
		return;
	}

	if (g_iErraticLevel[iClient] <= 0)
	{
		PrintHintText(iClient, "You must have Erratic Domination (Level 1) for Jockey Bind 1");
		return;
	}

	if (g_iClientBindUses_1[iClient] >= 3)
	{
		PrintHintText(iClient, "You're out of piss");
		return;
	}

	if(g_bCanJockeyPee[iClient] == false)
	{
		PrintHintText(iClient, "Wait 30 seconds to piss again");
		return;
	}

	if (g_iJockeyVictim[iClient] <= 0 || RunClientChecks(g_iJockeyVictim[iClient]) == false)
	{
		PrintHintText(iClient, "You must be riding a victim to piss on them");
		return;
	}

	HandleJockeyPiss(iClient);
	
	GiveClientXP(iClient, 25, g_iSprite_25XP_SI, g_iJockeyVictim[iClient], "Pissed on survivor.");
	
	g_iClientBindUses_1[iClient]++;
}

void HandleJockeyPiss(int iClient)
{
	g_bCanJockeyPee[iClient] = false;
	g_bJockeyPissVictim[g_iJockeyVictim[iClient]] = true;

	HandleJockeyPissEffects(iClient);
	
	// Boomer Bile the victim
	SDKCall(g_hSDK_VomitOnPlayer, g_iJockeyVictim[iClient], iClient, true);
	
	PrintHintText(iClient, "You're pissing on %N!\n\nAll Infected near them become stronger as they smell it.", g_iJockeyVictim[iClient]);

	if (IsFakeClient(g_iJockeyVictim[iClient]) == false)
	{
		PrintHintText(g_iJockeyVictim[iClient], "%N is pissing on you!\n\nAll Infected near you become stronger as they smell it.", iClient);
		ShowHudOverlayColor(g_iJockeyVictim[iClient], 255, 255, 0, 65, 2900, FADE_OUT);
	}

	if(g_iErraticLevel[iClient] == 10)
		RunCheatCommand(iClient, "z_spawn_old", "z_spawn_old mob auto");

	HandleSurvivorInJockeyPiss(g_iJockeyVictim[iClient]);

	// new iRandomTankSpawn = GetRandomInt(1, 100);
	// if (iRandomTankSpawn <= JOCKEY_PISS_SPAWN_TANK_CHANCE && 
	//     g_iErraticLevel[iClient] >= iRandomTankSpawn)
	// {
	//     g_bTankStartingHealthXPModSpawn = true;
	//     RunCheatCommand(iClient, "z_spawn_old", "z_spawn_old tank auto");

	//     PrintToChatAll("\x03[XPMod] \x04Beware, a tank smells %N's jockey piss", iClient);
	//     PrintHintText(iClient, "You attracted a tank with your piss!");
	// }

	CreateTimer(30.0, TimerReEnableJockeyPee, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

void HandleJockeyPissEffects(int iClient)
{
	float xyzPosition[3];
	GetClientEyePosition(iClient, xyzPosition);

	EmitSoundToAll(SOUND_JOCKEYPEE, g_iJockeyVictim[iClient], SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzPosition, NULL_VECTOR, true, 0.0);
	EmitSoundToAll(SOUND_JOCKEYPEE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzPosition, NULL_VECTOR, true, 0.0);
	CreateTimer(11.0, TimerStopJockeyPeeSound, iClient, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(11.0, TimerStopJockeyPeeSound, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);

	
	CreateTimer(11.0, TimerStopJockeyPeeEffects, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(20.0, TimerRemovePeeRenderAndGlow, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);

	// Handle victim cloaking for bind 2, otherwise make the victim glow orange
	if (g_bCanJockeyCloak[iClient] == true)
	{
		SetEntityRenderMode(g_iJockeyVictim[iClient], RenderMode:3);
		SetEntityRenderColor(g_iJockeyVictim[iClient], 200, 255, 0, 255);
		SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_iGlowType", 2);
		SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_nGlowRange", 0);
		SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_glowColorOverride", 10900);	//Yellow-Orange
	}
	else 
	{
		SetEntityRenderMode(g_iJockeyVictim[iClient], RenderMode:3);
		SetEntityRenderColor(g_iJockeyVictim[iClient], 255, 255, 255, RoundToFloor(255 * (1.0 -  (float(g_iUnfairLevel[iClient]) * 0.09))) );
		SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_iGlowType", 3);
		SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_nGlowRange", 0);
		SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_glowColorOverride", 1);
	}
}

Action TimerStopJockeyPeeSound(Handle timer, int iClient)
{
	StopSound(iClient, SNDCHAN_AUTO, SOUND_JOCKEYPEE);
	
	return Plugin_Stop;
}

Action TimerRemovePeeRenderAndGlow(Handle timer, int iClient)
{
	if (RunClientChecks(iClient) == false)
		return Plugin_Stop;
	
	SetClientRenderAndGlowColor(iClient);
	
	return Plugin_Stop;
}

Action TimerStopJockeyPeeEffects(Handle timer, any:iClient)
{
	if(RunClientChecks(iClient) == false)
		return Plugin_Stop;

	StopSound(iClient, SNDCHAN_AUTO, SOUND_JOCKEYPEE);

	if(IsFakeClient(iClient) == false)
		ShowHudOverlayColor(iClient, 255, 255, 0, 65, 1000, FADE_OUT);
	
	return Plugin_Stop;
}

Action TimerReEnableJockeyPee(Handle timer, int iClient)
{
	g_bCanJockeyPee[iClient] = true;

	return Plugin_Stop;
}

Action TimerResetIsJockeyPissVictim(Handle timer, int iClient)
{
	g_bJockeyPissVictim[iClient] = false;

	return Plugin_Stop;
}

void HandleSurvivorInJockeyPiss(int iClient)
{
	CreateTimer(0.25, TimerCheckForZombiesNearJockeyPissVictim, iClient, TIMER_REPEAT);
	CreateTimer(20.0, TimerResetIsJockeyPissVictim, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

Action TimerCheckForZombiesNearJockeyPissVictim(Handle timer, int iClient)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false || 
		g_bJockeyPissVictim[iClient] == false)
		return Plugin_Stop;

	ConvertCINearJockeyPissVictim(iClient);

	return Plugin_Continue;
}

void ConvertCINearJockeyPissVictim(int iClient)
{
	float xyzEntityLocation[3];
	int iAllVaiableEntities[MAXENTITIES];
	char strClasses[1][32] = {"infected"};
	for (int iIndex=0; iIndex < GetAllEntitiesInRadiusOfEntity(iClient, JOCKEY_PISS_CONVERSION_RADIUS, iAllVaiableEntities, strClasses, sizeof(strClasses)); iIndex++)
	{
		//PrintToChatAll("ConvertCINearJockeyPissVictim: CI entity i: %i", iAllVaiableEntities[iIndex]);

		if (IsCommonInfectedAlive(iAllVaiableEntities[iIndex]) == false)
			continue
		
		// If already Enhanced CI, move on and continue the search
		if (IsEnhancedCI(iAllVaiableEntities[iIndex]) == true)
			continue;

		// Get the location of where to spawn new enhanced CI
		GetEntPropVector(iAllVaiableEntities[iIndex], Prop_Send, "m_vecOrigin", xyzEntityLocation);

		// Kill the current non enhanced CI entity
		SetEntProp(iAllVaiableEntities[iIndex], Prop_Data, "m_iHealth", 0);

		// Spawn an Enhanced CI in the location of the killed CI's place
		SpawnCIAroundLocation(xyzEntityLocation, 1, UNCOMMON_CI_CEDA, CI_REALLY_BIG, ENHANCED_CI_TYPE_RANDOM, false);
		// switch (GetRandomInt(1,2))
		// {
		// 	case 1: SpawnCIAroundLocation(xyzEntityLocation, 1, UNCOMMON_CI_RANDOM, CI_REALLY_SMALL, ENHANCED_CI_TYPE_RANDOM, false);
		// 	case 2: SpawnCIAroundLocation(xyzEntityLocation, 1, UNCOMMON_CI_RANDOM, CI_REALLY_BIG, ENHANCED_CI_TYPE_RANDOM, false);
		// }
	}
}