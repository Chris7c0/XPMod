void LoadVampiricTankTalents(int iClient)
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
	g_iVampiricTankStamina[iClient] = VAMPIRIC_TANK_STAMINA_MAX;
	g_bVampiricTankCanRechargeStamina[iClient] = true;

	// Set a really high rock cooldown so that the rock throw ability is deactivated
	SetSIAbilityCooldown(iClient, 99999.0);

	SetTanksTalentHealth(iClient, TANK_HEALTH_VAMPIRIC);

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

void ResetAllTankVariables_Vampiric(int iClient)
{
	g_bCanFlapVampiricTankWings[iClient] = false;
	g_bIsVampiricTankFlying[iClient] = false;
	g_bCanVampiricTankWingDash[iClient] = false;
	g_iVampiricTankWingDashChargeCount[iClient] = 0;
}

// SetupTankForBot_Vampiric(iClient)
// {
// 	LoadVampiricTankTalents(iClient);
// }

void SetClientSpeedTankVampiric(int iClient, float &fSpeed)
{
	if (g_iTankChosen[iClient] != TANK_VAMPIRIC)
		return;

	fSpeed += 0.30;
}

void OnGameFrame_Tank_Vampiric(int iClient)
{
	int buttons;
	buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);

	//Check to see if pressing the fly button, if so, start flappling those wings
	if (g_bCanFlapVampiricTankWings[iClient] &&
		g_iVampiricTankStamina[iClient] >= VAMPIRIC_TANK_STAMINA_DEPLETION_FLAP &&
		(buttons & IN_JUMP)) 
	{
		g_iVampiricTankStamina[iClient] -= VAMPIRIC_TANK_STAMINA_DEPLETION_FLAP;

		g_bIsVampiricTankFlying[iClient] = true;
		g_bCanFlapVampiricTankWings[iClient] = false;

		//SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
		AddWingFlapVelocity(iClient, VAMPIRIC_TANK_WING_FLAP_UP_VELOCITY);

		float xyzClientPosition[3];
		GetClientEyePosition(iClient, xyzClientPosition);
		// Play a random sound effect name from the the boomer throw selection
		int iRandomSoundNumber = GetRandomInt(0 ,sizeof(SOUND_WING_FLAP) - 1);
		// Play it twice because its to quiet (super dirty, but what do)
		EmitAmbientSound(SOUND_WING_FLAP[ iRandomSoundNumber ], xyzClientPosition, iClient, SNDLEVEL_SCREAMING);
		EmitAmbientSound(SOUND_WING_FLAP[ iRandomSoundNumber ], xyzClientPosition, iClient, SNDLEVEL_SCREAMING);
		CreateTimer(1.0, TimerCanFlapVampiricTankWingsReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
		
		PrintVampiricTankMeters(iClient);

		// Stop stamina recharging temporarily
		g_bVampiricTankCanRechargeStamina[iClient] = false;
		delete g_hTimer_VampiricTankCanRechargeStamina[iClient];
		g_hTimer_VampiricTankCanRechargeStamina[iClient] = CreateTimer(VAMPIRIC_TANK_STAMINA_REGENERATION_DELAY, TimerVampiricTankCanRechargeStaminaReset, iClient);
	}

	// Flying Dash
	if (g_bCanVampiricTankWingDash[iClient] && 
		g_iVampiricTankStamina[iClient] >= VAMPIRIC_TANK_STAMINA_DEPLETION_DASH &&
		(buttons & IN_ATTACK2))
	{
		if (g_iVampiricTankWingDashChargeCount[iClient] > 0)
		{
			g_iVampiricTankStamina[iClient] -= VAMPIRIC_TANK_STAMINA_DEPLETION_DASH;

			g_iVampiricTankWingDashChargeCount[iClient]--;
			g_bCanVampiricTankWingDash[iClient] =  false;
			g_bIsVampiricTankFlying[iClient] = true;

			// Remove the rock throw ability just in case it wasn't previously set
			SetSIAbilityCooldown(iClient, 99999.0);
			
			//SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
			AddWingDashVelocity(iClient, VAMPIRIC_TANK_WING_DASH_VELOCITY);

			float xyzClientPosition[3];
			GetClientEyePosition(iClient, xyzClientPosition);
			// Play a random sound effect name from the the boomer throw selection
			int iRandomSoundNumber = GetRandomInt(0 ,sizeof(SOUND_WING_FLAP) - 1);
			// Play it twice because its to quiet (super dirty, but what do)
			EmitAmbientSound(SOUND_WING_FLAP[ iRandomSoundNumber ], xyzClientPosition, iClient, SNDLEVEL_SCREAMING);
			EmitAmbientSound(SOUND_WING_FLAP[ iRandomSoundNumber ], xyzClientPosition, iClient, SNDLEVEL_SCREAMING);

			PrintVampiricTankMeters(iClient);
			
			// Add a cooldown to the wing dash and start the regeneration timer
			CreateTimer(0.5, TimerVampiricTankWingDashReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
			delete g_hTimer_WingDashChargeRegenerate[iClient];
			g_hTimer_WingDashChargeRegenerate[iClient] = CreateTimer(VAMPIRIC_TANK_WING_DASH_COOLDOWN, TimerVampiricTankWingDashChargeRegenerate, iClient);

			// Stop stamina recharging temporarily
			g_bVampiricTankCanRechargeStamina[iClient] = false;
			delete g_hTimer_VampiricTankCanRechargeStamina[iClient];
			g_hTimer_VampiricTankCanRechargeStamina[iClient] = CreateTimer(VAMPIRIC_TANK_STAMINA_REGENERATION_DELAY, TimerVampiricTankCanRechargeStaminaReset, iClient);
		}
	}

	// Recharge Stamina
	if (g_bVampiricTankCanRechargeStamina[iClient] == true && g_iVampiricTankStamina[iClient] < VAMPIRIC_TANK_STAMINA_MAX)
	{
		g_iVampiricTankStamina[iClient] = g_iVampiricTankStamina[iClient] + VAMPIRIC_TANK_STAMINA_REGENERATION_RATE > VAMPIRIC_TANK_STAMINA_MAX ?
			VAMPIRIC_TANK_STAMINA_MAX :
			g_iVampiricTankStamina[iClient] + VAMPIRIC_TANK_STAMINA_REGENERATION_RATE;
		
		PrintVampiricTankMeters(iClient);
	}
		

	if (g_bIsVampiricTankFlying[iClient] && (GetEntityFlags(iClient) & FL_ONGROUND))
	{
		g_bIsVampiricTankFlying[iClient] = false;
		//SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
	}
}

void EventsHurt_VictimTank_Vampiric(Handle hEvent, int iAttacker, int iVictimTank)
{
	SuppressNeverUsedWarning(hEvent, iAttacker);

	int iDmgHealth = GetEventInt(hEvent,"dmg_health");

	char weaponclass[32];
	GetEventString(hEvent,"weapon",weaponclass,32);
	

	// Modify damage taken for the Vampric Tank
	if (StrContains(weaponclass,"melee",false) != -1)
	{
		// Increase the melee damage
		// Remember, the original damage will still process, so subtract that
		int iCurrentHP = GetPlayerHealth(iVictimTank);
		//if (IsFakeClient(iVictimTank) == false) PrintToChat(iVictimTank, "\x03iCurrentHP: %i", iCurrentHP);
		SetPlayerHealth(iVictimTank, iAttacker, iCurrentHP - ((iDmgHealth * VAMPIRIC_TANK_MELEE_DMG_TAKEN_MULTIPLIER) - iDmgHealth));
		//if (IsFakeClient(iVictimTank) == false) PrintToChat(iVictimTank, "\x03Subtracting health: %i", ((iDmgHealth * VAMPIRIC_TANK_MELEE_DMG_TAKEN_MULTIPLIER) - iDmgHealth));
		//new iCurrentHP2 = GetPlayerHealth(iVictimTank);
		//if (IsFakeClient(iVictimTank) == false) PrintToChat(iVictimTank, "\x03iCurrentHP: %i", iCurrentHP2);
	}
	else if(StrContains(weaponclass,"pistol",false) != -1 ||
		StrContains(weaponclass,"rifle",false) != -1 ||
		StrContains(weaponclass,"smg",false) != -1 ||
		StrContains(weaponclass,"sub",false) != -1 || // Needed?
		StrContains(weaponclass,"shotgun",false) != -1 ||
		StrContains(weaponclass,"sniper",false) != -1)
	{
		int iCurrentHP = GetPlayerHealth(iVictimTank);
		// The life will be taken away, so we need to convert the gun damage taken multiplier to be a reduction of this.
		// So, if we want to only take 1/3rd damage, then we add 2/3rds back here.  1 - 1/3rds = 2/3rds.
		SetPlayerHealth(iVictimTank, iAttacker, iCurrentHP + RoundToCeil(iDmgHealth * (1.0 - VAMPIRIC_TANK_GUN_DMG_TAKEN_MULTIPLIER)) );
		//if (IsFakeClient(iVictimTank) == false) PrintToChat(iVictimTank, "\x03Re-adding health: %i", RoundToCeil(iDmgHealth * (1.0 - VAMPIRIC_TANK_GUN_DMG_TAKEN_MULTIPLIER)) );
	}
	// else
	// {
	// 	if (IsFakeClient(iVictimTank) == false) PrintToChat(iVictimTank, "\x03NRMLDMG weapon: \x01%s \x03dmg: \x01%i",weaponclass, iDmgHealth);
	// }
}

void EventsHurt_AttackerTank_Vampiric(Handle hEvent, int iAttackerTank, int iVictim)
{
	SuppressNeverUsedWarning(hEvent);
	
	char strWeapon[20];
	GetEventString(hEvent,"weapon", strWeapon, 20);
	int iDmgHealth = GetEventInt(hEvent,"dmg_health");

	if (RunClientChecks(iAttackerTank) == false || RunClientChecks(iVictim) == false ||
		IsPlayerAlive(iAttackerTank) == false || IsPlayerAlive(iVictim) == false || 
		g_iClientTeam[iVictim] != TEAM_SURVIVORS ||
		StrEqual(strWeapon,"tank_claw") == false)
		return;

	// Calculate the health to recieve (more for incap players)
	int iVampiricHealthGainAmount;
	if (IsIncap(iVictim) == true)
		iVampiricHealthGainAmount = iDmgHealth * VAMPIRIC_TANK_LIFESTEAL_INCAP_MULTIPLIER;
	else
		iVampiricHealthGainAmount = iDmgHealth * VAMPIRIC_TANK_LIFESTEAL_MULTIPLIER;

	// Get the current life level
	int iCurrentHP = GetPlayerHealth(iAttackerTank);
	int iCurrentMaxHP = RoundToNearest(TANK_HEALTH_VAMPIRIC * g_fTankStartingHealthMultiplier[iAttackerTank]);
	if(iCurrentHP < iCurrentMaxHP)
	{
		if(iCurrentHP + iVampiricHealthGainAmount < iCurrentMaxHP)
			SetPlayerHealth(iAttackerTank, -1, iCurrentHP + iVampiricHealthGainAmount);
		else
			SetPlayerHealth(iAttackerTank, -1, iCurrentMaxHP);

		// Show hud effect:
		if(IsFakeClient(iAttackerTank)==false)
			ShowHudOverlayColor(iAttackerTank, 100, 0, 255, 40, 440, FADE_OUT);
		
		if(IsFakeClient(iVictim)==false)
			ShowHudOverlayColor(iVictim, 180, 0, 100, 40, 440, FADE_OUT);
	}
}

// NOTE: This function is for additional damage, not handling the original damage amount
int CalculateDamageForVictimTalents_Tank_Vampiric(int iVictim, int iDmgAmount, const char[] strWeaponClass = "")
{
	// Make sure its a Vampiric Tank
	if (g_iClientTeam[iVictim] != TEAM_INFECTED || 
		g_iTankChosen[iVictim] != TANK_VAMPIRIC ||
		GetEntProp(iVictim, Prop_Send, "m_zombieClass") != TANK)
		return 0;

	// Modify damage taken for the Vampric Tank
	if (StrContains(strWeaponClass,"melee",false) != -1)
	{
		// Increase the melee damage
		return (iDmgAmount * VAMPIRIC_TANK_MELEE_DMG_TAKEN_MULTIPLIER);
	}
	else if(StrContains(strWeaponClass,"pistol",false) != -1 ||
		StrContains(strWeaponClass,"rifle",false) != -1 ||
		StrContains(strWeaponClass,"smg",false) != -1 ||
		StrContains(strWeaponClass,"sub",false) != -1 || // Needed?
		StrContains(strWeaponClass,"shotgun",false) != -1 ||
		StrContains(strWeaponClass,"sniper",false) != -1)
	{
		// Decrease gun damage
		return RoundToNearest(iDmgAmount * VAMPIRIC_TANK_GUN_DMG_TAKEN_MULTIPLIER);
	}

	return 0;
}

void AddWingFlapVelocity(int iClient, float speed)
{
	float vecVelocity[3];
	GetEntDataVector(iClient, g_iOffset_VecVelocity, vecVelocity);

	float xyzAngles[3], vDirection[3];
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

void AddWingDashVelocity(int iClient, float speed)
{
	float vecVelocity[3];
	GetEntDataVector(iClient, g_iOffset_VecVelocity, vecVelocity);

	float xyzAngles[3], vDirection[3];
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

Action TimerCanFlapVampiricTankWingsReset(Handle timer, int iClient)
{
	g_bCanFlapVampiricTankWings[iClient] = true;
	return Plugin_Stop;
}

Action TimerVampiricTankCanRechargeStaminaReset(Handle timer, int iClient)
{
	g_bVampiricTankCanRechargeStamina[iClient] = true;
	
	g_hTimer_VampiricTankCanRechargeStamina[iClient] = null;
	return Plugin_Stop;
}

Action TimerVampiricTankWingDashReset(Handle timer, int iClient)
{
	g_bCanVampiricTankWingDash[iClient] = true;
	return Plugin_Stop;
}

Action TimerVampiricTankWingDashChargeRegenerate(Handle timer, int iClient)
{
	if (RunClientChecks(iClient) && 
		IsPlayerAlive(iClient))
	{
		g_iVampiricTankWingDashChargeCount[iClient] = 3;
		PrintVampiricTankMeters(iClient);
	}
	
	g_hTimer_WingDashChargeRegenerate[iClient] = null;
	return Plugin_Stop;
}

void PrintVampiricTankMeters(int iClient)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false || 
		IsFakeClient(iClient) == true)
		return;
	
	char strWingDashChargeMeter[80], strStaminaMeter[150];

	// Grab the parts of the string to print to the player
	BuildVampiricTankWingDashChargesString(iClient, strWingDashChargeMeter, sizeof(strWingDashChargeMeter));
	BuildVampiricTankStatusString(iClient, strStaminaMeter, sizeof(strStaminaMeter));

	PrintHintText(iClient,"%s\n\n%s", strWingDashChargeMeter, strStaminaMeter);
}


void BuildVampiricTankStatusString(int iClient, char[] strBuffer, int iBufferSize)
{
	char strStaminaBar[128];
	strStaminaBar = NULL_STRING;

	float fNormalizedStamina = g_iVampiricTankStamina[iClient] / float(VAMPIRIC_TANK_STAMINA_MAX);

	// Create the actual mana amount in the "progress meter"
	for(int i = 0; i < RoundToCeil(fNormalizedStamina * 29.0); i++)
		StrCat(strStaminaBar, sizeof(strStaminaBar), "▓");
	// Create the rest of the string
	for(int i = 29; i > RoundToCeil(fNormalizedStamina * 29.0); i--)
		StrCat(strStaminaBar, sizeof(strStaminaBar), "░");

	Format(strBuffer, iBufferSize, ":-=-=-<[%s]>-=-=-:", strStaminaBar);
}

void BuildVampiricTankWingDashChargesString(int iClient, char[] strBuffer, int iBufferSize)
{
	switch (g_iVampiricTankWingDashChargeCount[iClient])
	{
		case 0: Format(strBuffer, iBufferSize, ":-=-=-=-<[░░░░░░░░░░░░░░░░░░]>-=-=-=-:");
		case 1: Format(strBuffer, iBufferSize, ":-=-=-=-<[▓▓▓▓▓▓░░░░░░░░░░░░]>-=-=-=-:");
		case 2: Format(strBuffer, iBufferSize, ":-=-=-=-<[▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░]>-=-=-=-:");
		case 3: Format(strBuffer, iBufferSize, ":-=-=-=-<[▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓]>-=-=-=-:");
	}
}

void CreateVampiricTankTrailEffect(int iClient)
{
	float xyzTankPosition[3];
	GetClientAbsOrigin(iClient, xyzTankPosition);
	xyzTankPosition[2] += 30.0;
	char vecString[32];
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
