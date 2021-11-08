TalentsLoad_Hunter(iClient)
{
	g_iHunterShreddingVictim[iClient] = -1;
	if(g_iPredatorialLevel[iClient] > 0)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Hunter Talents \x05have been loaded.");
		SetClientSpeed(iClient);
	}
	if(g_iBloodlustLevel[iClient] > 0)
	{
		//PrintToChatAll("g_bHasInfectedHealthBeenSet = %d", g_bHasInfectedHealthBeenSet[iClient]);
		if(g_bHasInfectedHealthBeenSet[iClient] == false)
		{
			g_bHasInfectedHealthBeenSet[iClient] = true;
			SetPlayerMaxHealth(iClient, (g_iBloodlustLevel[iClient] * 25), true);
		}
		g_bCanHunterDismount[iClient] = true;
	}
	if(g_iKillmeleonLevel[iClient] > 0)
	{
		g_iHunterCloakCounter[iClient] = -1;	// -1 means iClient is cloaked
		g_bIsCloakedHunter[iClient] = true;
		SetEntityRenderMode(iClient, RenderMode:3);
		SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.09) )));
	}
}

OnGameFrame_Hunter(iClient)
{
	if (g_bTalentsConfirmed[iClient] == false)
		return;

	HandleHunterLunging(iClient);

	if(g_iKillmeleonLevel[iClient] > 0)		//Dynamic Cloaking for kill-meleon
	{						
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		//For pounce crouch charge
		/*
		if((buttons & IN_DUCK))
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{
				if(g_iHunterShreddingVictim[iClient]  > 0)
				{
					g_iHunterPounceDamageCharge[iClient] = 0;
				}
			}
			
			if(g_iHunterShreddingVictim[iClient] == -1)
				if((GetEntityFlags(iClient) & FL_ONGROUND))
					if(g_iHunterPounceDamageCharge[iClient] <= (g_iKillmeleonLevel[iClient] * 120))
						g_iHunterPounceDamageCharge[iClient]++;
			
			
			if(g_iHunterPounceDamageCharge[iClient] > 59)
				PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 60);
			else if(g_iHunterPounceDamageCharge[iClient] == 30)
				PrintHintText(iClient, "Pounce Attack Charge: 0");
		}
		else
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{	
				g_iHunterPounceDamageCharge[iClient] = 0;
				PrintHintText(iClient, "Pounce Attack Charge: 0");
			}
		}
		*/

		
			


		if((buttons & IN_DUCK))
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{
				if(g_iHunterShreddingVictim[iClient]  > 0)
				{
					g_iHunterPounceDamageCharge[iClient] = 0;
				}
			}
			
			if(g_iHunterShreddingVictim[iClient] == -1)
				if((GetEntityFlags(iClient) & FL_ONGROUND))
					if(g_iHunterPounceDamageCharge[iClient] <= (g_iKillmeleonLevel[iClient] * 42))
						g_iHunterPounceDamageCharge[iClient]++;
			
			switch(g_iHunterPounceDamageCharge[iClient])
			{
				case 21:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 42:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 63:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 84:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 105:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 126:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 147:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 168:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 189:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 210:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 231:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 252:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 273:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 294:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 315:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 336:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 357:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 378:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 399:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 420:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
			}
		}
		else
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{	
				g_iHunterPounceDamageCharge[iClient] = 0;
				PrintHintText(iClient, "Pounce Attack Charge: 0");
			}
		}
		//For camouflage
		if(g_bIsCloakedHunter[iClient] == true)
		{
			if( (buttons) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
			{
				if( (!(buttons & IN_DUCK)) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
				{
					//SetEntityRenderMode(iClient, RenderMode:3);	probably dont need this
					SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.010) )));
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
				if( (buttons) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )			//If iClient moves or pushes buttons, resset the counter
				{
					if( (!(buttons & IN_DUCK)) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
					{
						if(g_iHunterCloakCounter[iClient] > 20)
						{
							SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.010) )));
						}
						g_iHunterCloakCounter[iClient] = 0;
					}
				}
				if(g_iHunterCloakCounter[iClient] == 100)
				{
					g_iHunterCloakCounter[iClient] = -1; // -1 means iClient is cloaked
					PrintCenterText(iClient, "Camouflaged");
					SetEntityRenderMode(iClient, RenderMode:3);
					SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.090) )));
					g_bIsCloakedHunter[iClient] = true;
				}
				else if(g_iHunterCloakCounter[iClient] > 20)
				{
					if(g_iHunterCloakCounter[iClient] == 35)
						PrintCenterText(iClient, "Blending in with surroundings");
					SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - ((float(g_iKillmeleonLevel[iClient]) * (0.009 + (float(g_iHunterCloakCounter[iClient] - 20) * 0.001)))) )));
				}
			}
		}
		if(g_iHunterShreddingVictim[iClient] > 0)
		{
			
		}
	}
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
				//CreateTimer(20.0, TimerContinuousHunterPoison, hunterpoisonpackage, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
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

	if(g_iBloodlustLevel[attacker] > 0)
	{
		new dmgtype = GetEventInt(hEvent, "type");
		//decl String:weapon[20];
		//GetEventString(hEvent,"weapon", weapon,20);
		if(dmgtype == 128 &&  StrEqual(weapon,"hunter_claw") == true)
		{
			//new hp = GetPlayerHealth(victim);
			//new dmg = GetEventInt(hEvent,"dmg_health");
			decl dmg;
			if(g_iBloodlustLevel[attacker] < 5)
				dmg = 1;
			else if(g_iBloodlustLevel[attacker] < 9)
				dmg = 2;
			else
				dmg = 3;
			DealDamage(victim, attacker, dmg);
			
			new iHealth = GetPlayerHealth(attacker);
			new iMaxHealth = GetPlayerMaxHealth(attacker);
			new iAdditionalHealth = g_iBloodlustLevel[attacker] * HUNTER_LIFE_STEAL_AMOUNT_PER_HIT_PER_LEVEL;

			if (iHealth + iAdditionalHealth <= iMaxHealth)
				SetPlayerHealth(attacker, iAdditionalHealth, true, true);
			else if(iMaxHealth + iAdditionalHealth <= HUNTER_MAX_LIFE_STEAL_HEALTH)
				SetPlayerMaxHealth(attacker, iAdditionalHealth, true, true);
			else
				SetPlayerMaxHealth(attacker, HUNTER_MAX_LIFE_STEAL_HEALTH, false);
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
	
	g_iHunterPounceDistance[iAttacker] = iDistance;
	PrintToChat(iAttacker, "\x03[XPMod] \x04Pounce Distance: %i", g_iHunterPounceDistance[iAttacker]);

	if(g_iClientTeam[iAttacker] != TEAM_INFECTED)
		return;
	
	GiveClientXP(iAttacker, 50, g_iSprite_50XP_SI, iVictim, "Grappled A Survivor.");

	// if(g_iKillmeleonLevel[attacker] <= 0 && g_iHunterPounceDamageCharge[attacker] <= 20)
	// 	return;
	
	// decl iDamage;
	// iDamage = RoundToFloor(g_iHunterPounceDamageCharge[attacker] / 21.0);
	// new Handle:iDataPack = CreateDataPack();
	// WritePackCell(iDataPack, victim);
	// WritePackCell(iDataPack, attacker);
	// WritePackCell(iDataPack, iDamage);
	// CreateTimer(0.1, TimerHunterPounceDamage, iDataPack);
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
		IsPlayerAlive(iClient) == false)
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
	int iButtons = GetEntProp(iClient, Prop_Data, "m_nButtons", iButtons);

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