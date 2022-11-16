TalentsLoad_Hunter(iClient)
{
	g_iHunterShreddingVictim[iClient] = -1;
	g_iBloodLustStage[iClient] = 0;

	if(g_iPredatorialLevel[iClient] > 0)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Hunter Talents \x05have been loaded.");
		SetClientSpeed(iClient);

		g_bCanHunterDismount[iClient] = true;
	}
	if(g_iKillmeleonLevel[iClient] > 0)
	{
		if(g_bHasInfectedHealthBeenSet[iClient] == false)
		{
			g_bHasInfectedHealthBeenSet[iClient] = true;
			SetPlayerMaxHealth(iClient, 500, false);
		}

		// TODO: Check if this can be removed
		g_iHunterCloakCounter[iClient] = -1;	// -1 means iClient is cloaked
		g_bIsCloakedHunter[iClient] = true;
		SetEntityRenderMode(iClient, RenderMode:3);
		SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.095) )));
	}
}

OnGameFrame_Hunter(iClient)
{
	if (g_iPredatorialLevel[iClient] <= 0 ||
		g_bTalentsConfirmed[iClient] == false)
		return;

	HandleHunterLunging(iClient);
	HandleHunterCloaking(iClient);
	// HandleHunterVisibleBloodLustMeterGain(iClient);
	HandleAllSurvivorsInHunterMobilityZone(iClient);

	// Health Regeneration
	// Every frame give 1 hp, 30 fps, so 30 hp per second
	if (GetPlayerHealth(iClient) < SMOKER_STARTING_MAX_HEALTH + (g_iKillmeleonLevel[iClient] > 0 ? 250 : 0))
		SetPlayerHealth(iClient, g_iBloodLustStage[iClient], true);
}


bool OnPlayerRunCmd_Hunter(iClient, &iButtons)
{
	// Smoker abilities
	if (g_iInfectedCharacter[iClient] != HUNTER ||
		g_iPredatorialLevel[iClient] <= 0 ||
		g_bIsGhost[iClient] == true ||
		g_iClientTeam[iClient] != TEAM_INFECTED || 
		RunClientChecks(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_bGameFrozen == true)
		return false;

	// Hunter Dismount
	// Check if button is released before doing this dismount
	if (g_iHunterShreddingVictim[iClient] > 0 &&
		GetEntProp(iClient, Prop_Data, "m_afButtonReleased") & IN_ATTACK)
		g_bReadyForDismountButtonPress[iClient] = true;
	// Once the button is released and they click again, do the dismount
	if (g_iHunterShreddingVictim[iClient] > 0 &&
		g_bReadyForDismountButtonPress[iClient] == true &&
		iButtons & IN_ATTACK)
		{
			if (g_bCanHunterDismount[iClient] == true)
				HunterDismount(iClient);
			else
				PrintToChat(iClient, "\x03[XPMod] \x0415 second cooldown after dismounting.");
		}
		
	
	return false;
}

EventsHurt_AttackerHunter(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(attacker))
		return;

	if (g_iClientTeam[victim] != TEAM_SURVIVORS)
		return;

	decl String:weapon[20];
	GetEventString(hEvent,"weapon", weapon,20);

	if(StrEqual(weapon,"hunter_claw") == true)
	{
		if(g_bIsHunterReadyToPoison[attacker])
		{
			if(g_bIsHunterPoisoned[victim] == false)
			{
				g_bIsHunterPoisoned[victim] = true;
				g_iClientBindUses_2[attacker]++;

				SetClientSpeed(victim);

				new Handle:hunterpoisonpackage = CreateDataPack();
				WritePackCell(hunterpoisonpackage, victim);
				WritePackCell(hunterpoisonpackage, attacker);
				g_iHunterPoisonRunTimesCounter[victim] = g_iKillmeleonLevel[attacker];
				g_bHunterLethalPoisoned[victim] = true;

				delete g_hTimer_HunterPoison[victim];
				g_hTimer_HunterPoison[victim] = CreateTimer(1.0, TimerHunterPoison, hunterpoisonpackage, TIMER_REPEAT);
				if(IsFakeClient(victim)==false)
					PrintHintText(victim, "\%N has injected venom into your flesh", attacker);
				PrintHintText(attacker, "You poisoned %N, You have enough venom for %d more injections.", victim, (3 - g_iClientBindUses_2[attacker]) );
				
				
				g_bIsHunterReadyToPoison[attacker] = false;
				CreateTimer(5.0, TimerResetCanHunterPoison, attacker, TIMER_FLAG_NO_MAPCHANGE);
			}
			else
				PrintHintText(attacker, "%N has already been poisoned, find another victim", victim);
		}
	}

	if(g_iBloodLustLevel[attacker] > 0)
	{
		new dmgtype = GetEventInt(hEvent, "type");
		//decl String:weapon[20];
		//GetEventString(hEvent,"weapon", weapon,20);
		if(dmgtype == 128 &&  StrEqual(weapon,"hunter_claw") == true)
		{			
			if (g_iBloodLustStage[attacker] > 0)
				DealDamage(victim, attacker, g_iBloodLustStage[attacker]);
			
			BuildBloodLustMeter(attacker);
		}
	}
}

EventsHurt_VictimHunter(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(victim))
		return;

	new hitGroup = GetEventInt(hEvent, "hitgroup");
	
	if(hitGroup == 0)	// If victim is hunter and has beeen hit with explosive ammo, reset the pounced variables
	{
		g_bHunterGrappled[victim] = false;
		g_iHunterShreddingVictim[attacker] = -1;
		SetClientSpeed(victim);
	}

	if(g_bIsCloakedHunter[victim] == true)
	{
		//SetEntityRenderMode(victim, RenderMode:3);	// Probably dont need this
		SetEntityRenderColor(victim, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[victim]) * 0.012) )));
		g_bIsCloakedHunter[victim] = false;
		g_iHunterCloakCounter[victim] = 0;
	}
}

// EventsDeath_AttackerHunter(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

// EventsDeath_VictimHunter(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }


void Event_HunterPounceStart_Hunter(int iAttacker, int iVictim, int iDistance)
{
	if (g_iPredatorialLevel[iAttacker] <= 0 || 
		g_iInfectedCharacter[iAttacker] != HUNTER ||
		g_iClientTeam[iAttacker] != TEAM_INFECTED ||
		g_bTalentsConfirmed[iAttacker] == false)
		return;

	GiveClientXP(iAttacker, 50, g_iSprite_50XP_SI, iVictim, "Grappled A Survivor.");

	// If the player is holding the primary attack button down, then
	// make sure they release it later by first setting this flag
	int buttons;
	buttons = GetEntProp(iAttacker, Prop_Data, "m_nButtons", buttons);
	g_bReadyForDismountButtonPress[iAttacker] = (buttons & IN_ATTACK) ? false : true;

	// I'm making a guess that this distance is in 100 Hammer Units.
	// 100 HU * (1 FT / 12 HU) = 8.33333 FT per 100 HU
	// distance (in 100 HU) / 8.33333 FT = X FT
	int iDistanceFeet = RoundToNearest(float(iDistance) / 8.33333);

	if(iDistanceFeet < HUNTER_LUNGE_EXTRA_DAMAGE_DISTANCE_MIN)
	{
		PrintHintText(iAttacker, "Pounce Distance:	%i ft", iDistanceFeet);
		return;
	}

	float fNormalizedDistance = float(iDistanceFeet - HUNTER_LUNGE_EXTRA_DAMAGE_DISTANCE_MIN) /
		float(HUNTER_LUNGE_EXTRA_DAMAGE_DISTANCE_MAX - HUNTER_LUNGE_EXTRA_DAMAGE_DISTANCE_MIN);

	int iDamageAmount =  fNormalizedDistance >= 1.0 ? HUNTER_LUNGE_EXTRA_DAMAGE_MAX :
		RoundToNearest(fNormalizedDistance * HUNTER_LUNGE_EXTRA_DAMAGE_MAX);
	
	DealDamage(iVictim, iAttacker, iDamageAmount);
	
	PrintHintText(iAttacker, "Pounce Distance: %i ft\n\nPounce Damage: %i", iDistanceFeet, 25 + iDamageAmount);
}

// void Event_HunterPounceStopped_Hunter(int iAttacker, int iVictim, int iDistance)
// {

// }

void Event_AbilityUse_Hunter(int iClient, Handle hEvent)
{
	if (g_iPredatorialLevel[iClient] <= 0 || 
		g_iInfectedCharacter[iClient] != HUNTER ||
		g_bTalentsConfirmed[iClient] == false)
		return;

	char strAbility[20];
	GetEventString(hEvent,"ability", strAbility,20);
	if (StrEqual(strAbility,"ability_lunge",false) == false)
		return;
	
	g_bHunterIsLunging[iClient] = true;
	SetClientSpeed(iClient);
	
	g_bHunterLungeEndDelayCheck[iClient] = true;
	CreateTimer(0.1, TimerHandleHunterPostLunge, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

Action TimerHandleHunterPostLunge(Handle hTimer, int iClient)
{
	// Allow to check if the hunter is on the ground or not
	g_bHunterLungeEndDelayCheck[iClient] = false;

	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iInfectedCharacter[iClient] != HUNTER ||
		g_iPredatorialLevel[iClient] <= 0 ||
		g_bTalentsConfirmed[iClient] == false)
		return Plugin_Stop;

	// Set the initial velocity boost
	decl Float:velocity[3];
	GetEntPropVector(iClient, Prop_Data, "m_vecVelocity", velocity);
	velocity[0] *= (1.0 + HUNTER_LUNGE_VELOCITY_MULTIPLIER_START);
	velocity[1] *= (1.0 + HUNTER_LUNGE_VELOCITY_MULTIPLIER_START);
	velocity[2] *= (1.0 + HUNTER_LUNGE_VELOCITY_MULTIPLIER_START);
	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, velocity);
	

	return Plugin_Stop;
}

void HandleHunterLunging(int iClient)
{
	// If Hunter is lunging then check if on ground, if so reset the value to false
	if (g_bHunterIsLunging[iClient] == true && 
		g_bHunterLungeEndDelayCheck[iClient] == false &&
		GetEntityFlags(iClient) & FL_ONGROUND)
	{
		g_bHunterIsLunging[iClient] = false;
		g_iHunterLungeState[iClient] = HUNTER_LUNGE_STATE_NONE;
		SetClientSpeed(iClient);

		// PrintToChatAll("%N: g_bHunterIsLunging = false", iClient);
	}

	if(g_bHunterIsLunging[iClient] == false)
		return;

	// Get the Hunter's current velocity
	float velocity[3];
	GetEntPropVector(iClient, Prop_Data, "m_vecVelocity", velocity);

	// Get the buttons the Hunter is pressing
	int iButtons;
	iButtons = GetEntProp(iClient, Prop_Data, "m_nButtons", iButtons);

	// Dash Lunge (Check the velocity make sure they are falling down before continuing here)
	if (iButtons & IN_ATTACK && velocity[2] < 0.0)
	{
		// Set the speed if not set already
		if (g_iHunterLungeState[iClient] != HUNTER_LUNGE_STATE_DASH)
		{
			g_iHunterLungeState[iClient] = HUNTER_LUNGE_STATE_DASH;
			SetClientSpeed(iClient);
		}
		
		float xyzAngles[3];
		float vDirection[3];
		GetClientEyeAngles(iClient, xyzAngles);								// Get clients Eye Angles to know get what direction face
		GetAngleVectors(xyzAngles, vDirection, NULL_VECTOR, NULL_VECTOR);	// Get the direction the iClient is looking

		// if (IsFakeClient(iClient) == false) PrintToChat(iClient, "vDirection: %2f, %2f, %2f", vDirection[0], vDirection[1], vDirection[2]);

		// Grab thew new dash velocity
		velocity[0] += (vDirection[0] * HUNTER_LUNGE_VELOCITY_ADDITION_DASH_SPEED);
		velocity[1] += (vDirection[1] * HUNTER_LUNGE_VELOCITY_ADDITION_DASH_SPEED);
		// Cap the velocity
		if (velocity[0] > HUNTER_LUNGE_VELOCITY_SPEED_CAP_DASH) velocity[0] = HUNTER_LUNGE_VELOCITY_SPEED_CAP_DASH;
		if (velocity[0] < -1.0 * HUNTER_LUNGE_VELOCITY_SPEED_CAP_DASH) velocity[0] = -1.0 * HUNTER_LUNGE_VELOCITY_SPEED_CAP_DASH;
		if (velocity[1] > HUNTER_LUNGE_VELOCITY_SPEED_CAP_DASH) velocity[1] = HUNTER_LUNGE_VELOCITY_SPEED_CAP_DASH;
		if (velocity[1] < -1.0 * HUNTER_LUNGE_VELOCITY_SPEED_CAP_DASH) velocity[1] = -1.0 * HUNTER_LUNGE_VELOCITY_SPEED_CAP_DASH;
		TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, velocity);

		// PrintToChat(iClient, "DASH vel %0.1f, %0.1f, %0.1f", velocity[0], velocity[1], velocity[2]);
	}
	// Float Lunge (flying squirrel)
	else if(iButtons & IN_JUMP)
	{
		// Set the speed if not set already
		if (g_iHunterLungeState[iClient] != HUNTER_LUNGE_STATE_FLOAT)
		{
			g_iHunterLungeState[iClient] = HUNTER_LUNGE_STATE_FLOAT;
			SetClientSpeed(iClient);
		}

		// Remove some velocity and push the player up to give flying squirrel effect
		velocity[0] *= (1.0 - HUNTER_LUNGE_VELOCITY_MULTIPLIER_FLOAT);
		velocity[1] *= (1.0 - HUNTER_LUNGE_VELOCITY_MULTIPLIER_FLOAT);
		// If they are moving down at a rate fast enough, start to push them up
		if (velocity[2] < HUNTER_LUNGE_VELOCITY_FLOAT_Z_PUSH_START)
			velocity[2] += HUNTER_LUNGE_VELOCITY_ADDITION_FLOAT_SPEED;
		TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, velocity);

		// PrintToChat(iClient, "FLOAT vel %0.1f, %0.1f, %0.1f", velocity[0], velocity[1], velocity[2]);
	}
	// Base Lunge
	else
	{
		if (g_iHunterLungeState[iClient] != HUNTER_LUNGE_STATE_BASE)
		{
			g_iHunterLungeState[iClient] = HUNTER_LUNGE_STATE_BASE;
			SetClientSpeed(iClient);
		}
	}
}


// This code is so gross,
// TODO: Fix this later
void HandleHunterCloaking(int iClient)
{
	if (g_iKillmeleonLevel[iClient] <= 0 ||
		g_bTalentsConfirmed[iClient] == false)
		return;
	
	int buttons;
	buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	
	if(g_bIsCloakedHunter[iClient] == true)
	{
		if( (buttons) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
		{
			if( (!(buttons & IN_DUCK)) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
			{
				SetEntityRenderMode(iClient, RenderMode:3);
				SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.005) )));
				g_bIsCloakedHunter[iClient] = false;
				g_iHunterCloakCounter[iClient] = 0;
			}
		}
	}
	else
	{
		if(g_iHunterCloakCounter[iClient] >= 0)
		{
			g_iHunterCloakCounter[iClient]++;
			if( (buttons) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )			//If iClient moves or pushes buttons, reset the counter
			{
				if( (!(buttons & IN_DUCK)) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
				{
					if(g_iHunterCloakCounter[iClient] > 20)
					{
						SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.005) )));
					}
					g_iHunterCloakCounter[iClient] = 0;
				}
			}
			if(g_iHunterCloakCounter[iClient] == 100)
			{
				g_iHunterCloakCounter[iClient] = -1; // -1 means iClient is cloaked
				PrintCenterText(iClient, "Camouflaged");
				SetEntityRenderMode(iClient, RenderMode:3);
				SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.095) )));
				g_bIsCloakedHunter[iClient] = true;
			}
			else if(g_iHunterCloakCounter[iClient] > 20)
			{
				if(g_iHunterCloakCounter[iClient] == 35)
					PrintCenterText(iClient, "Blending in with surroundings");
				SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - ((float(g_iKillmeleonLevel[iClient]) * (0.0095 + (float(g_iHunterCloakCounter[iClient] - 20) * 0.001)))) )));
			}
		}
	}
}

void HunterDismount(iClient)
{
	// PrintToChatAll("Hunter attempting dismount...");
	SDKCall(g_hSDK_OnPounceEnd,iClient);
	SetClientSpeed(g_iHunterShreddingVictim[iClient]);
	//ResetSurvivorSpeed(g_iHunterShreddingVictim[iClient]);
	g_iHunterShreddingVictim[iClient] = -1;
	g_bCanHunterDismount[iClient] = false;
	CreateTimer(15.0, TimerResetHunterDismount, iClient,  TIMER_FLAG_NO_MAPCHANGE);
}

void BuildBloodLustMeter(int iClient, int iAmount = 0)
{
	if (g_iInfectedCharacter[iClient] != HUNTER || 
		g_bTalentsConfirmed[iClient] == false || 
		g_iBloodLustLevel[iClient] <= 0 ||
		g_iBloodLustStage[iClient] >= 3)
		return;

	if (iAmount > 0)
		g_iBloodLustMeter[iClient] += iAmount;
	else if (g_iHunterShreddingVictim[iClient] > 0)  // While on top of a victim
		g_iBloodLustMeter[iClient] += BLOOD_LUST_METER_GAINED_ON_VICTIM;
	else  										// While scratching a victim, not on them
		g_iBloodLustMeter[iClient] += BLOOD_LUST_METER_GAINED_OFF_VICTIM;

	if (g_iBloodLustMeter[iClient] >= 100)
	{
		g_iBloodLustMeter[iClient] = 0;
		g_iBloodLustStage[iClient]++;
		SetHunterBloodLustAbilities(iClient);
	}

	PrintBloodLustMeter(iClient);
}

void SetHunterBloodLustAbilities(int iClient)
{
	if (g_bTalentsConfirmed[iClient] == false)
		return;
	
	SetClientSpeed(iClient);

	if (g_iBloodLustStage[iClient] == 3)
		CreateTimer(BLOOD_LUST_RESET_TIMER_DURATION, TimerHunterBloodLustReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

void PrintBloodLustMeter(iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient))
		return;
	
	if (g_iBloodLustStage[iClient] == 3)
	{
		PrintHintText(iClient, "<<<Blood Lust Stage 3>>>");
		return;
	}
	
	decl String:strEntireHintTextString[556], String:strBloodLustMeter[256];
	strEntireHintTextString = NULL_STRING;
	strBloodLustMeter = NULL_STRING;

	// Create the actual amount in the "progress meter"
	for(int i = 0; i < RoundToCeil(g_iBloodLustMeter[iClient] / 10.0); i++)
		StrCat(strBloodLustMeter, sizeof(strBloodLustMeter), "▓")
	// Create the rest of the string to fill in the progress meter
	for(int i = RoundToCeil(100 / 10.0); i > RoundToCeil(g_iBloodLustMeter[iClient] / 10.0); i--)
		StrCat(strBloodLustMeter, sizeof(strBloodLustMeter), "░")

	if (g_iBloodLustStage[iClient] == 0)
		Format(strEntireHintTextString, sizeof(strEntireHintTextString), "Blood Lust\n<<<%s>>>", strBloodLustMeter);
	else
		Format(strEntireHintTextString, sizeof(strEntireHintTextString), "Blood Lust Stage %i\n<<%s>>", g_iBloodLustStage[iClient], strBloodLustMeter);

	PrintHintText(iClient, strEntireHintTextString);
}

void HandleHunterVisibleBloodLustMeterGain(int iClient)
{
	// PrintToChatAll("TEST1 %i: %i", RoundToFloor(GetGameTime()), RoundToFloor(GetGameTime()) % 3);

	// // Only run this every X seconds
	// // 5 will update every 5 second
	// // Needs to be ran only one time though
	// if ((RoundToFloor(GetGameTime()) % 3) != 0)
	// 	return;

	// PrintToChatAll("TEST2");


	if (g_bIsCloakedHunter[iClient] == false ||  // Ensure the hunter is cloaked
		g_iInfectedCharacter[iClient] != HUNTER || 
		g_bTalentsConfirmed[iClient] == false || 
		g_iBloodLustLevel[iClient] <= 0 ||
		g_iBloodLustStage[iClient] >= 3 ||
		g_bGameFrozen == true)
		return;

	// Check the hunter's current position against the last one stored, and if they moved, return
	float xyzCurrentPosition[3];
	GetClientAbsOrigin(iClient, xyzCurrentPosition);
	if (GetVectorDistance(xyzCurrentPosition, g_fLastHunterPosition[iClient], false) > 3.0)
	{
		// Store current position in last position for next time
		GetClientAbsOrigin(iClient, g_fLastHunterPosition[iClient]);
		return;
	}

	float xyzClientLocation[3], xyzTargetLocation[3], fDistance, fDistanceNormalized;

	// Loop through all of the clients to find the survivors
	// then check their distance from the hunter
	for(int iTarget = 0; iTarget < MaxClients; iTarget++)
	{
		if (iClient == iTarget ||
			RunClientChecks(iTarget) == false ||
			// g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
			IsPlayerAlive(iTarget) == false)
			continue;

		GetClientEyePosition(iClient, xyzClientLocation);
		GetClientEyePosition(iTarget, xyzTargetLocation);
		fDistance = GetVectorDistance(xyzClientLocation, xyzTargetLocation, false);
		
		if(IsVisibleTo(xyzClientLocation, xyzTargetLocation) == true)
		{
			if (fDistance <= 1500.0)
			{
				// Normalize the distance
				fDistanceNormalized = 1.0 - (fDistance / 1500.0);

				int iAmount = RoundToNearest(fDistanceNormalized * BLOOD_LUST_METER_GAINED_VISIBILITY_SCALE_FACTOR);
				// PrintToChat(iClient, "Distance: %f, Normalized: %f, iAmount: %i", fDistance, fDistanceNormalized, iAmount);
				BuildBloodLustMeter(iClient, iAmount);

			}
			// PrintToChatAll("VISIBLE %N %f", iTarget, fDistance);
		}
			
	}
	
}