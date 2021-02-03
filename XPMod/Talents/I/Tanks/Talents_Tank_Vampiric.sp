LoadVampiricTankTalents(iClient)
{
	if (RunClientChecks(iClient) == false || 
		g_iClientTeam[iClient] != TEAM_INFECTED || 
		g_iTankChosen[iClient] != TANK_NOT_CHOSEN ||
		GetEntProp(iClient, Prop_Send, "m_zombieClass") != TANK)
		return;
	
	if(IsPlayerAlive(iClient) == false)
	{
		if (IsFakeClient(iClient) == false)
			PrintToChat(iClient, "\x04You cannot choose tank talents after you have died");
		return;
	}

	// PrintToChatAll("%N Loading VAMPIRIC TANK abilities.", iClient);
	
	g_iTankChosen[iClient] = TANK_VAMPIRIC;
	
	g_bCanFlapVampiricTankWings[iClient] = true;
	g_bIsVampiricTankFlying[iClient] = false;
	g_bCanVampiricTankWingDash[iClient] = true;
	g_iVampiricTankWingDashChargeCount[iClient] = 3;

	// Set a really high rock cooldown so that the rock throw ability is deactivated
	SetSIAbilityCooldown(iClient, 99999.0);
	
	// Set Health
	// Get Current Health/MaxHealth first, to add it back later
	new iCurrentMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	SetEntProp(iClient, Prop_Data,"m_iMaxHealth", TANK_HEALTH_VAMPIRIC);
	SetEntProp(iClient, Prop_Data,"m_iHealth", iCurrentHealth + TANK_HEALTH_VAMPIRIC - iCurrentMaxHealth);

	// Stop Kiting (Bullet hits slowing tank down)
	SetConVarInt(FindConVar("z_tank_damage_slow_min_range"), 0);
	SetConVarInt(FindConVar("z_tank_damage_slow_max_range"), 0);
	
	// Set Movement Speed
	SetClientSpeed(iClient);

	// Change Tank's Skin Color
	SetClientRenderColor(iClient, 100, 0, 255, 255, RENDER_MODE_NORMAL);
	// Make the tank have a colored outline glow
	SetClientGlow(iClient, 100, 0, 255, GLOWTYPE_ONVISIBLE);

	//Grow the tank, doesnt seem to work
	//SetEntPropFloat(iClient , Prop_Send,"m_flModelScale", 1.3); 
	
	// Particle effects
	CreateVampiricTankTrailEffect(iClient);

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "You have become the Vampiric Tank");
}

ResetAllTankVariables_Vampiric(iClient)
{
	g_bCanFlapVampiricTankWings[iClient] = false;
	g_bIsVampiricTankFlying[iClient] = false;
	g_bCanVampiricTankWingDash[iClient] = false;
	g_iVampiricTankWingDashChargeCount[iClient] = 0;

	delete g_hTimer_WingDashChargeRegenerate[iClient];
}

// SetupTankForBot_Vampiric(iClient)
// {
// 	LoadVampiricTankTalents(iClient);
// }

SetClientSpeedTankVampiric(iClient, &Float:fSpeed)
{
	if (g_iTankChosen[iClient] != TANK_VAMPIRIC)
		return;

	fSpeed += 0.1;
}

OnGameFrame_Tank_Vampiric(iClient)
{
	new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);

	//Check to see if pressing the fly button, if so, start flappling those wings
	if (g_bCanFlapVampiricTankWings[iClient] && (buttons & IN_JUMP)) 
	{
		g_bIsVampiricTankFlying[iClient] = true;
		g_bCanFlapVampiricTankWings[iClient] = false;

		//SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
		AddWingFlapVelocity(iClient, VAMPIRIC_TANK_WING_FLAP_UP_VELOCITY);

		decl Float:xyzClientPosition[3];
		GetClientEyePosition(iClient, xyzClientPosition);
		// Play a random sound effect name from the the boomer throw selection
		new iRandomSoundNumber = GetRandomInt(0 ,sizeof(SOUND_WING_FLAP) - 1);
		// Play it twice because its to quiet (super dirty, but what do)
		EmitAmbientSound(SOUND_WING_FLAP[ iRandomSoundNumber ], xyzClientPosition, iClient, SNDLEVEL_SCREAMING);
		EmitAmbientSound(SOUND_WING_FLAP[ iRandomSoundNumber ], xyzClientPosition, iClient, SNDLEVEL_SCREAMING);
		CreateTimer(1.0, TimerCanFlapVampiricTankWingsReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}

	// Flying Dash
	if (g_bCanVampiricTankWingDash[iClient] && (buttons & IN_ATTACK2))
	{
		if (g_iVampiricTankWingDashChargeCount[iClient] > 0)
		{
			g_iVampiricTankWingDashChargeCount[iClient]--;
			g_bCanVampiricTankWingDash[iClient] =  false;
			g_bIsVampiricTankFlying[iClient] = true;

			// Remove the rock throw ability just in case it wasn't previously set
			SetSIAbilityCooldown(iClient, 99999.0);
			
			//SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
			AddWingDashVelocity(iClient, VAMPIRIC_TANK_WING_DASH_VELOCITY);

			decl Float:xyzClientPosition[3];
			GetClientEyePosition(iClient, xyzClientPosition);
			// Play a random sound effect name from the the boomer throw selection
			new iRandomSoundNumber = GetRandomInt(0 ,sizeof(SOUND_WING_FLAP) - 1);
			// Play it twice because its to quiet (super dirty, but what do)
			EmitAmbientSound(SOUND_WING_FLAP[ iRandomSoundNumber ], xyzClientPosition, iClient, SNDLEVEL_SCREAMING);
			EmitAmbientSound(SOUND_WING_FLAP[ iRandomSoundNumber ], xyzClientPosition, iClient, SNDLEVEL_SCREAMING);

			PrintVampiricTankWingDashCharges(iClient);
			
			CreateTimer(0.5, TimerVampiricTankWingDashReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
			delete g_hTimer_WingDashChargeRegenerate[iClient];
			g_hTimer_WingDashChargeRegenerate[iClient] = CreateTimer(VAMPIRIC_TANK_WING_DASH_COOLDOWN, TimerVampiricTankWingDashChargeRegenerate, iClient);
		}
	}

	if (g_bIsVampiricTankFlying[iClient] && (GetEntityFlags(iClient) & FL_ONGROUND))
	{
		g_bIsVampiricTankFlying[iClient] = false;
		//SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
	}
}

EventsHurt_TankVictim_Vampiric(Handle:hEvent, iAttacker, iVictimTank)
{
	SuppressNeverUsedWarning(hEvent, iAttacker);

	new iDmgHealth  = GetEventInt(hEvent,"dmg_health");

	decl String:weaponclass[32];
	GetEventString(hEvent,"weapon",weaponclass,32);
	

	// Modify damage taken for the Vampric Tank
	if (StrContains(weaponclass,"melee",false) != -1)
	{
		// Increase the melee damage
		// Remember, the original damage will still process, so subtract that
		new iCurrentHP = GetEntProp(iVictimTank,Prop_Data,"m_iHealth");
		//if (IsFakeClient(iVictimTank) == false) PrintToChat(iVictimTank, "\x03iCurrentHP: %i", iCurrentHP);
		SetEntProp(iVictimTank,Prop_Data,"m_iHealth", iCurrentHP - ((iDmgHealth * VAMPIRIC_TANK_MELEE_DMG_TAKEN_MULTIPLIER) - iDmgHealth));
		//if (IsFakeClient(iVictimTank) == false) PrintToChat(iVictimTank, "\x03Subtracting health: %i", ((iDmgHealth * VAMPIRIC_TANK_MELEE_DMG_TAKEN_MULTIPLIER) - iDmgHealth));
		//new iCurrentHP2 = GetEntProp(iVictimTank,Prop_Data,"m_iHealth");
		//if (IsFakeClient(iVictimTank) == false) PrintToChat(iVictimTank, "\x03iCurrentHP: %i", iCurrentHP2);
	}
	else if(StrContains(weaponclass,"pistol",false) != -1 ||
		StrContains(weaponclass,"rifle",false) != -1 ||
		StrContains(weaponclass,"smg",false) != -1 ||
		StrContains(weaponclass,"sub",false) != -1 || // Needed?
		StrContains(weaponclass,"shotgun",false) != -1 ||
		StrContains(weaponclass,"sniper",false) != -1)
	{
		new iCurrentHP = GetEntProp(iVictimTank,Prop_Data,"m_iHealth");
		// The life will be taken away, so we need to convert the gun damage taken multiplier to be a reduction of this.
		// So, if we want to only take 1/3rd damage, then we add 2/3rds back here.  1 - 1/3rds = 2/3rds.
		SetEntProp(iVictimTank,Prop_Data,"m_iHealth", iCurrentHP + RoundToCeil(iDmgHealth * (1.0 - VAMPIRIC_TANK_GUN_DMG_TAKEN_MULTIPLIER)) );
		//if (IsFakeClient(iVictimTank) == false) PrintToChat(iVictimTank, "\x03Re-adding health: %i", RoundToCeil(iDmgHealth * (1.0 - VAMPIRIC_TANK_GUN_DMG_TAKEN_MULTIPLIER)) );
	}
	else
	{
		if (IsFakeClient(iVictimTank) == false) PrintToChat(iVictimTank, "\x03NRMLDMG weapon: \x01%s \x03dmg: \x01%i",weaponclass, iDmgHealth);
	}
}

EventsHurt_TankAttacker_Vampiric(Handle:hEvent, iAttackerTank, iVictim)
{
	SuppressNeverUsedWarning(hEvent);
	
	new iDmgHealth  = GetEventInt(hEvent,"dmg_health");

	if (RunClientChecks(iAttackerTank) == false || RunClientChecks(iVictim) == false ||
		IsPlayerAlive(iAttackerTank) == false || IsPlayerAlive(iVictim) == false)
		return;

	// Calculate the health to recieve (more for incap players)
	decl iVampiricHealthGainAmount;
	if (GetEntProp(iVictim, Prop_Send, "m_isIncapacitated") != 0)
		iVampiricHealthGainAmount = iDmgHealth * VAMPIRIC_TANK_LIFESTEAL_INCAP_MULTIPLIER;
	else
		iVampiricHealthGainAmount = iDmgHealth * VAMPIRIC_TANK_LIFESTEAL_MULTIPLIER;

	// Get the current life level
	new iCurrentHP = GetEntProp(iAttackerTank,Prop_Data,"m_iHealth");
	if(iCurrentHP < TANK_HEALTH_VAMPIRIC)
	{
		if(iCurrentHP + iVampiricHealthGainAmount < TANK_HEALTH_VAMPIRIC)
			SetEntProp(iAttackerTank,Prop_Data,"m_iHealth", iCurrentHP + iVampiricHealthGainAmount);
		else
			SetEntProp(iAttackerTank,Prop_Data,"m_iHealth", TANK_HEALTH_VAMPIRIC);

		// Show hud effect:
		if(IsFakeClient(iAttackerTank)==false)
			ShowHudOverlayColor(iAttackerTank, 100, 0, 255, 40, 440, FADE_OUT);
		
		if(IsFakeClient(iVictim)==false)
			ShowHudOverlayColor(iVictim, 180, 0, 100, 40, 440, FADE_OUT);
	}
}

AddWingFlapVelocity(iClient, Float:speed)
{
	new Float:vecVelocity[3];
	GetEntDataVector(iClient, g_iOffset_VecVelocity, vecVelocity);

	decl Float:xyzAngles[3], Float:vDirection[3];
	GetClientEyeAngles(iClient, xyzAngles);								// Get clients Eye Angles to know get what direction face
	GetAngleVectors(xyzAngles, vDirection, NULL_VECTOR, NULL_VECTOR);	// Get the direction the iClient is looking

	// Add a little forward momentem in the direction they are facing
	vecVelocity[0] += (vDirection[0] * 50);
	vecVelocity[1] += (vDirection[1] * 50);

	//if (IsFakeClient(iClient) == false) PrintToChat(iClient, "vecVelocity: %2f, %2f, %2f", vecVelocity[0], vecVelocity[1], vecVelocity[2]);

	// if ((vecVelocity[2]+speed) > 2500.0)
	// 	vecVelocity[2] = 2500.0;
	// else
	vecVelocity[2] = speed;

	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vecVelocity);
}

AddWingDashVelocity(iClient, Float:speed)
{
	new Float:vecVelocity[3];
	GetEntDataVector(iClient, g_iOffset_VecVelocity, vecVelocity);

	decl Float:xyzAngles[3], Float:vDirection[3];
	GetClientEyeAngles(iClient, xyzAngles);								// Get clients Eye Angles to know get what direction face
	GetAngleVectors(xyzAngles, vDirection, NULL_VECTOR, NULL_VECTOR);	// Get the direction the iClient is looking

	//if (IsFakeClient(iClient) == false) PrintToChat(iClient, "vDirection: %2f, %2f, %2f", vDirection[0], vDirection[1], vDirection[2]);

	vecVelocity[0] = (vDirection[0] * speed);
	vecVelocity[1] = (vDirection[1] * speed);
	vecVelocity[2] = (vDirection[2] * speed);
	if ((GetEntityFlags(iClient) & FL_ONGROUND) && vecVelocity[2] < 300.0)
		vecVelocity[2] = 300.0;

	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vecVelocity);
}

Action:TimerCanFlapVampiricTankWingsReset(Handle:timer, any:iClient)
{
	g_bCanFlapVampiricTankWings[iClient] = true;
	return Plugin_Stop;
}

Action:TimerVampiricTankWingDashReset(Handle:timer, any:iClient)
{
	g_bCanVampiricTankWingDash[iClient] = true;
	return Plugin_Stop;
}

Action:TimerVampiricTankWingDashChargeRegenerate(Handle:timer, any:iClient)
{
	if (RunClientChecks(iClient) && 
		IsPlayerAlive(iClient))
	{
		g_iVampiricTankWingDashChargeCount[iClient] = 3;
		PrintVampiricTankWingDashCharges(iClient);
	}
	
	g_hTimer_WingDashChargeRegenerate[iClient] = null;
	return Plugin_Stop;
}

PrintVampiricTankWingDashCharges(iClient)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false || 
		IsFakeClient(iClient) == true)
		return;
	
	// Print the Wing Dash charges
	switch (g_iVampiricTankWingDashChargeCount[iClient])
	{
		case 0: PrintHintText(iClient, ":-=-=-=-<[░░░░░░░░░░░░░░░░░░]>-=-=-=-:");

		case 1: PrintHintText(iClient, ":-=-=-=-<[▓▓▓▓▓▓░░░░░░░░░░░░]>-=-=-=-:");

		case 2: PrintHintText(iClient, ":-=-=-=-<[▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░]>-=-=-=-:");

		case 3: PrintHintText(iClient, ":-=-=-=-<[▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓]>-=-=-=-:");
		// case 0: PrintHintText(iClient, ":-=-=-=-=-<[         ]>-=-=-=-=-:");
		// case 1: PrintHintText(iClient, ":-=-=-=-=-<[[[[      ]>-=-=-=-=-:");
		// case 2: PrintHintText(iClient, ":-=-=-=-=-<[[[[[[[   ]>-=-=-=-=-:");
		// case 3: PrintHintText(iClient, ":-=-=-=-=-<[]]]]]]]]]]>-=-=-=-=-:");
		// case 0: PrintHintText(iClient, ":-=-=-=-=-<[         ]>-=-=-=-=-:");
		// case 1: PrintHintText(iClient, ":-=-=-=-=-<[|||      ]>-=-=-=-=-:");
		// case 2: PrintHintText(iClient, ":-=-=-=-=-<[||||||   ]>-=-=-=-=-:");
		// case 3: PrintHintText(iClient, ":-=-=-=-=-<[|||||||||]>-=-=-=-=-:");
		// case 0: PrintHintText(iClient, ":-=-=-=-=-<[         ]>-=-=-=-=-:");
		// case 1: PrintHintText(iClient, ":-=-=-=-=-<[ *       ]>-=-=-=-=-:");
		// case 2: PrintHintText(iClient, ":-=-=-=-=-<[ *  *    ]>-=-=-=-=-:");
		// case 3: PrintHintText(iClient, ":-=-=-=-=-<[ *  *  * ]>-=-=-=-=-:");
		// case 0: PrintHintText(iClient, ":-=-=-=-=-<[         ]>-=-=-=-=-:");
		// case 1: PrintHintText(iClient, ":-=-=-=-=-<[    *    ]>-=-=-=-=-:");
		// case 2: PrintHintText(iClient, ":-=-=-=-=-<[  *   *  ]>-=-=-=-=-:");
		// case 3: PrintHintText(iClient, ":-=-=-=-=-<[ *  *  * ]>-=-=-=-=-:");
	}
}

CreateVampiricTankTrailEffect(int iClient)
{
	new Float:xyzTankPosition[3];
	GetClientAbsOrigin(iClient, xyzTankPosition);
	xyzTankPosition[2] += 30.0;
	new String:vecString[32];
	Format(vecString, sizeof(vecString), "%f %f %f", xyzTankPosition[0], xyzTankPosition[1], xyzTankPosition[2]);

	g_iPID_TankTrail[iClient] = CreateEntityByName("env_smokestack");
	
	DispatchKeyValue(g_iPID_TankTrail[iClient],"Origin", vecString);
	DispatchKeyValue(g_iPID_TankTrail[iClient],"BaseSpread", "0");		//Gap in the middle
	DispatchKeyValue(g_iPID_TankTrail[iClient],"SpreadSpeed", "20");	//Speed the smoke moves outwards
	DispatchKeyValue(g_iPID_TankTrail[iClient],"Speed", "5");			//The speed at which the smoke particles move after they're spawned
	DispatchKeyValue(g_iPID_TankTrail[iClient],"StartSize", "35");
	DispatchKeyValue(g_iPID_TankTrail[iClient],"EndSize", "70");
	DispatchKeyValue(g_iPID_TankTrail[iClient],"Rate", "5");			//Amount of smoke created
	DispatchKeyValue(g_iPID_TankTrail[iClient],"JetLength", "20");		//Smoke jets outside of the original
	DispatchKeyValue(g_iPID_TankTrail[iClient],"Twist", "3"); 			//Amount of global twisting
	DispatchKeyValue(g_iPID_TankTrail[iClient],"RenderColor", "200 0 200");
	DispatchKeyValue(g_iPID_TankTrail[iClient],"RenderAmt", "50");		//Transparency
	DispatchKeyValue(g_iPID_TankTrail[iClient],"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
	
	
	SetVariantString("!activator");
	AcceptEntityInput(g_iPID_TankTrail[iClient], "SetParent", iClient, g_iPID_TankTrail[iClient], 0);

	DispatchSpawn(g_iPID_TankTrail[iClient]);
	AcceptEntityInput(g_iPID_TankTrail[iClient], "TurnOn");
}