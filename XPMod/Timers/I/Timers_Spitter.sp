public Action:TimerSetSpitterCooldown(Handle:timer, any:iClient)
{
	//INITIAL CHECKS
	//--------------
	if (IsServerProcessing()==false
		|| iClient <= 0
		|| IsClientInGame(iClient)==false
		|| IsPlayerAlive(iClient)==false
		|| g_bIsServingHotMeal[iClient] == true)
	{
		return Plugin_Stop;
	}

	//----DEBUG----
	//PrintToChatAll("\x03 tick");

	//RETRIEVE VARIABLES
	//------------------
	//get the ability ent id
	new iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
	//if the retrieved gun id is -1, then move on
	if (!IsValidEntity(iEntid))
	{
		return Plugin_Stop;
	}
	//retrieve the next act time
	//new Float:flDuration_ret = GetEntDataFloat(iEntid,g_iOffset_NextAct+4);

	//----DEBUG----
	//if (g_iShow==1)
	//	PrintToChatAll("\x03- actsuppress dur \x01 %f\x03 timestamp \x01%f", GetEntDataFloat(iEntid, g_iSuppressO+4), GetEntDataFloat(iEntid, g_iSuppressO+8) );

	//retrieve current timestamp
	new Float:flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextAct+8);

	if (g_fTimeStamp[iClient] < flTimeStamp_ret)
	{
		//----DEBUG----
		//PrintToChatAll("\x03 after adjusted shot\n-pre, iClient \x01%i\x03; entid \x01%i\x03; enginetime\x01 %f\x03; nextactivation: dur \x01 %f\x03 timestamp \x01%f",iClient,iEntid,GetGameTime(),GetEntDataFloat(iEntid, g_iOffset_NextAct+4), GetEntDataFloat(iEntid, g_iOffset_NextAct+8) );

		//update the timestamp stored in plugin
		g_fTimeStamp[iClient] = flTimeStamp_ret;

		//this calculates the time that the player theoretically
		//should have used his ability in order to use it
		//with the shortened cooldown
		//FOR EXAMPLE:
		//vomit, ATTACH_NORMAL cooldown 30s, desired cooldown 6s
		//player uses it at T = 1:30
		//normally, game predicts it to be ready at T + 30s
		//so if we modify T to 1:06, it will be ready at 1:36
		//which is 6s after the player used the ability
		//new Float:flTimeStamp_calc = flTimeStamp_ret - (GetConVarFloat(FindConVar("z_vomit_interval")) * (1.0 - 0.5) );	what it was in perkmod
		decl Float:flTimeStamp_calc;
		
		flTimeStamp_calc = flTimeStamp_ret -  (20.0 - (20.0 - (g_iHallucinogenicLevel[iClient] * 0.5)) );
		
		SetEntDataFloat(iEntid, g_iOffset_NextAct+8, flTimeStamp_calc, true);
		
		//----DEBUG----
		//PrintToChatAll("\x03-post, nextactivation dur \x01 %f\x03 timestamp \x01%f", GetEntDataFloat(iEntid, g_iOffset_NextAct+4), GetEntDataFloat(iEntid, g_iOffset_NextAct+8) );
	}

	return Plugin_Continue;
}

public Action:TimerResetSpeedFromGoo(Handle:timer, any:iClient)
{
	g_fClientSpeedPenalty[iClient] -= g_fAdhesiveAffectAmount[iClient];
	fnc_SetClientSpeed(iClient);
	g_bAdhesiveGooActive[iClient] = false;
	g_hTimer_AdhesiveGooReset[iClient] = null;
}

public Action:TimerResetGravityFromGoo(Handle:timer, any:iClient)
{
	if (RunClientChecks(iClient))
	{
		SetEntityGravity(iClient, 1.0);
		DeleteParticleEntity(g_iPID_DemiGravityEffect[iClient]);

		if(IsFakeClient(iClient) == false)
			PrintHintText(iClient, "The Spitter's Demi Goo effects wore off. Your gravity is back to normal");
	}

	g_bHasDemiGravity[iClient] = false;
	g_iPID_DemiGravityEffect[iClient] = -1;
	g_hTimer_DemiGooReset[iClient] = null;

	return Plugin_Stop;
}

public Action:TimerConjureWitch(Handle:timer, any:iClient)
{
	g_bCanConjureWitch[iClient] = false;
	g_bJustSpawnedWitch[iClient] = true;
	
	CreateTimer(180.0, TimerResetCanConjureWitch, iClient, TIMER_FLAG_NO_MAPCHANGE);

	//Spawn witch
	new flags = GetCommandFlags("z_spawn");
	SetCommandFlags("z_spawn", flags & ~FCVAR_CHEAT);
	FakeClientCommand(iClient, "z_spawn witch");
	SetCommandFlags("z_spawn", flags);

	g_iClientBindUses_2[iClient]++;
	
	return Plugin_Stop;
}

public Action:TimerConjureCommonInfected(Handle:timer, any:hDataPackage)
{
	ResetPack(hDataPackage);
	new iClient = ReadPackCell(hDataPackage);
	decl Float:xyzLocation[3];
	xyzLocation[0] = ReadPackFloat(hDataPackage);
	xyzLocation[1] = ReadPackFloat(hDataPackage);
	xyzLocation[2] = ReadPackFloat(hDataPackage);
	
	CloseHandle(hDataPackage);
	
	SpawnCommonInfectedMob(xyzLocation, g_iPuppetLevel[iClient]);
	
	return Plugin_Stop;
}

public Action:TimerConjureUncommonInfected(Handle:timer, any:hDataPackage)
{
	ResetPack(hDataPackage);
	new iClient = ReadPackCell(hDataPackage);
	decl Float:xyzLocation[3];
	xyzLocation[0] = ReadPackFloat(hDataPackage);
	xyzLocation[1] = ReadPackFloat(hDataPackage);
	xyzLocation[2] = ReadPackFloat(hDataPackage);
	
	CloseHandle(hDataPackage);
	
	decl i;
	for(i = 0; i < RoundToFloor(g_iMaterialLevel[iClient] * 0.5); i++)
	{
		new zombie = CreateEntityByName("infected");
		
		new iRandomNumber = GetRandomInt(0,5);
		
		switch(iRandomNumber)
		{
			case 0: SetEntityModel(zombie, "models/infected/common_male_ceda.mdl");
			case 1: SetEntityModel(zombie, "models/infected/common_male_clown.mdl");
			case 2: SetEntityModel(zombie, "models/infected/common_male_jimmy.mdl");
			case 3: SetEntityModel(zombie, "models/infected/common_male_mud.mdl");
			case 4: SetEntityModel(zombie, "models/infected/common_male_riot.mdl");
			case 5: SetEntityModel(zombie, "models/infected/common_male_roadcrew.mdl");
		}

		new ticktime = RoundToNearest( GetGameTime() / GetTickInterval() ) + 5;
		SetEntProp(zombie, Prop_Data, "m_nNextThinkTick", ticktime);
		
		CreateTimer(0.1, TimerSetMobRush, zombie);

		DispatchSpawn(zombie);
		ActivateEntity(zombie);
		
		TeleportEntity(zombie, xyzLocation, NULL_VECTOR, NULL_VECTOR);
	}
	
	return Plugin_Stop;
}


public Action:TimerResetCanConjureWitch(Handle:timer, any:iClient)
{
	g_bCanConjureWitch[iClient] = true;
	
	return Plugin_Stop;
}

public Action:TimerSetMobRush(Handle:timer, any:iClient)
{
	SetEntProp(iClient,Prop_Send,"m_mobRush",1);
	
	return Plugin_Stop;
}


public Action:TimerHallucinogen(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient) == false || IsPlayerAlive(iClient) == false)
	{
		g_bIsHallucinating[iClient] = false;
		g_hTimer_HallucinatePlayer[iClient] = null;
		return Plugin_Stop;
	}
	
	//Add laughing and other evil sounds
	
	if(g_iHallucinogenRuntimesCounter[iClient]++ < 10)
	{
		if(IsFakeClient(iClient)==false)
		{
			new red = GetRandomInt(20,255);
			new green = GetRandomInt(0, 30);
			new blue = GetRandomInt(0, 30);
			new alpha = GetRandomInt(180,200);
			ShowHudOverlayColor(iClient, red, green, blue, alpha, 700, FADE_IN);
		}
		
		DealDamage(iClient, iClient, 1);
		
		return Plugin_Continue;
	}
	
	//Do one long lasting final hud color overlay to fade it out
	if(IsFakeClient(iClient)==false)
	{
		new red = GetRandomInt(100,255);
		new green = GetRandomInt(0, 10);
		new blue = GetRandomInt(0, 10);
		new alpha = GetRandomInt(180,200);
		ShowHudOverlayColor(iClient, red, green, blue, alpha, 1600, FADE_OUT);
		
		PrintHintText(iClient, "The Spitter's hallucinogenic toxin effects have worn off"); 
	}		
		
	g_bIsHallucinating[iClient] = false;
	g_hTimer_HallucinatePlayer[iClient] = null;

	return Plugin_Stop;
}

public Action:TimerInfectedVictimTick(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient) == false || IsPlayerAlive(iClient) == false)
	{
		g_hTimer_ViralInfectionTick[iClient] = null;
		return Plugin_Stop;
	}
	
	new Float:xyzVictimLocation[3], Float:xyzPotentialVictimLocation[3], Float:fDistance;
	GetClientEyePosition(iClient, xyzVictimLocation);
	
	//Check the distance of all the survivors near to infect them if they are not immune
	decl i;
	for(i = 1;i <= MaxClients;i++)
	{
		if(i == iClient || g_bIsImmuneToVirus[i] == true || IsValidEntity(i) == false || 
			IsClientInGame(i) == false || IsPlayerAlive(i) == false || g_iClientTeam[i] != TEAM_SURVIVORS)
			continue;
		
		GetClientEyePosition(i, xyzPotentialVictimLocation);
		
		fDistance = GetVectorDistance(xyzVictimLocation, xyzPotentialVictimLocation, false);
		fDistance *= 0.08;
		
		if(fDistance <= 10.0)
			VirallyInfectVictim(i, g_iViralInfector[iClient])
	}
	
	if(g_iViralRuntimesCounter[iClient]-- > 0)
	{
		if(IsFakeClient(iClient)==false)
		{
			new red = GetRandomInt(0,1);
			new green = GetRandomInt(0, 255);
			new blue = GetRandomInt(0, 40);
			new alpha = GetRandomInt(80,100);
			ShowHudOverlayColor(iClient, red, green, blue, alpha, 300, FADE_IN);
		}
		
		SetEntityRenderMode(iClient, RenderMode:0);
		SetEntityRenderColor(iClient, 100, 255, 100, 255);
		
		DealDamage(iClient, g_iViralInfector[iClient], 1);		//************************************************Remeber to give credit to the attacker here and in hallucinogen
		
		//WriteParticle(iClient, "viral_infection", 0.0, 3.0);
		
		return Plugin_Continue;
	}
	
	//Do one long lasting final hud color overlay to fade it out
	if(IsFakeClient(iClient)==false)
	{
		new red = GetRandomInt(0,1);
		new green = GetRandomInt(0, 255);
		new blue = GetRandomInt(0, 40);
		new alpha = GetRandomInt(80,100);
		ShowHudOverlayColor(iClient, red, green, blue, alpha, 1600, FADE_OUT);
		
		PrintHintText(iClient, "Your body has finished fighting off the virus.\nYou are immune until the next mutated virus infects you."); 
	}
	
	//Reset the survivor's color
	fnc_SetRendering(iClient);
	//ResetGlow(iClient);
	
	//Set the attacker back to zero to signify that the victim is no longer infected
	g_iViralInfector[iClient] = 0;
	
	//Give temp immunity to this strand of the virus
	CreateTimer(60.0, TimerResetVirusImmunity, iClient, TIMER_FLAG_NO_MAPCHANGE);

	g_hTimer_ViralInfectionTick[iClient] = null;
	
	return Plugin_Stop;
}


public Action:TimerResetVirusImmunity(Handle:timer, any:iClient)
{
	g_bIsImmuneToVirus[iClient] = false;
}

public Action:TimerResetCanUseAcidReflex(Handle:timer, any:iClient)
{
	g_bJustUsedAcidReflex[iClient] = false;
}

public Action:TimerInstantSpitterCooldown(Handle:timer, any:iClient)
{
	new iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
	if (iEntid > 0)
	{
		new Float:flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextAct+8);
		new Float:flTimeStamp_calc = flTimeStamp_ret - 20.0;
		SetEntDataFloat(iEntid, g_iOffset_NextAct+8, flTimeStamp_calc, true);
	}
	PrintHintText(iClient, "SPIT AGAIN!");
}

public Action:TimerAllowGooSwitching(Handle:timer, any:iClient)
{
	g_bBlockGooSwitching[iClient] = false;
	g_hTimer_BlockGooSwitching[iClient] = null;
}

public Action:TimerResetRepulsion(Handle:timer, any:iClient)
{
	g_bCanBePushedByRepulsion[iClient] = true;
}

