LoadIceTankTalents(iClient)
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

	// PrintToChatAll("%N Loading Ice Tank abilities.", iClient);
	
	g_iTankChosen[iClient] = TANK_ICE;
	g_fTankHealthPercentage[iClient] =  1.0;
	
	// Stop Kiting (Bullet hits slowing tank down)
	SetConVarInt(FindConVar("z_tank_damage_slow_min_range"), 0);
	SetConVarInt(FindConVar("z_tank_damage_slow_max_range"), 0);

	g_bIceTankSliding[iClient] = false;
	g_bIceTankSlideInCooldown[iClient] = false;

	// Set Movement Speed
	SetClientSpeed(iClient);

	SetTanksTalentHealth(iClient, TANK_HEALTH_ICE);
	g_iIceTankLifePool[iClient] = GetPlayerMaxHealth(iClient);

	// Change Tank's Skin Color
	SetClientRenderColor(iClient, 0, 255, 255, 255, RENDER_MODE_NORMAL);
	// Make the tank have a colored outline glow
	SetClientGlow(iClient, 80, 240, 255, GLOWTYPE_ONVISIBLE);

	//Grow the tank, doesnt seem to work
	//SetEntPropFloat(iClient , Prop_Send,"m_flModelScale", 1.3); 
	
	//Particle effects
	CreateIceTankTrailEffect(iClient);
	g_iPID_IceTankIcicles[iClient] = CreateParticle("ice_tank_icicles", 0.0, iClient, ATTACH_RSHOULDER);
	
	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "You have become the Ice Tank");
}

ResetAllTankVariables_Ice(iClient)
{
	g_iIceTankLifePool[iClient] = 0;
	g_bShowingIceSphere[iClient] = false;
	g_bFrozenByTank[iClient] = false;
	g_bBlockTankFreezing[iClient] = false;
	g_fIceTankColdAuraSlowSpeedReduction[iClient] = 0.0;
	g_bIceTankColdAuraDisabled[iClient] = false;
	g_fTankHealthPercentage[iClient] = 0.0;
	
	DeleteParticleEntity(g_iPID_IceTankIcicles[iClient]);
}

// SetupTankForBot_Ice(iClient)
// {
// 	LoadIceTankTalents(iClient);
// }

SetClientSpeedTankIce(iClient, float &fSpeed)
{
	if (g_iTankChosen[iClient] != TANK_ICE)
		return;

	if (g_bIceTankSliding[iClient] == true)
	{
		fSpeed += TANK_ICE_SLIDE_SPEED;
		return;
	}

	fSpeed += 0.05;
}


OnGameFrame_Tank_Ice(iClient)
{
	//Check to see if the charging has already taken place or depleted
	if(g_iTankChosen[iClient] != TANK_ICE)
		return;
	
	// Check if there are players within the cold slow aura radius
	CheckForPlayersInIceTanksColdAuraSlowRange(iClient);

	int iButtons;
	iButtons = GetEntProp(iClient, Prop_Data, "m_nButtons", iButtons);
	if (g_bIceTankSliding[iClient] == true)
	{

		if(!(iButtons & IN_SPEED))
		{
			g_bIceTankSlideInCooldown[iClient] = true;
			g_bIceTankSliding[iClient] = false;
			SetClientSpeed(iClient);

			// Create a timer to reset the cooldown
			CreateTimer(TANK_ICE_SLIDE_COOLDOWN, TimerResetIceTankSlideCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
		}
		
		// Bleed off health as the Ice Tank is sliding
		SetPlayerHealth(iClient, -1, -1 * TANK_ICE_SLIDE_LIFE_DECAY, true);

		g_iIceTankLifePool[iClient] += RoundToNearest(TANK_ICE_SLIDE_LIFE_DECAY * 0.5);
	}

	if (g_iIceTankLifePool[iClient] < 1)
		return;

	int buttons;
	buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	
	//Check to see if ducking and not attacking before starting the charge
	if((buttons & IN_DUCK) && !(buttons & IN_ATTACK) && !(buttons & IN_ATTACK2) && !(buttons & IN_WALK))
	{
		CheckIfTankMovedWhileChargingAndIncrementCharge(iClient);

		//Display the first message to the player while he is charging up
		if(g_iTankCharge[iClient] == 30 && IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Charging Up Health Regeneration"); 
		
		//Charged for long enough, now handle ice tank regen
		if (g_iTankCharge[iClient] >= TANK_ICE_REGEN_START_DURATION_REQUIREMENT)
		{
			float fCurrentTankHealthPercentage;
			new iCurrentHealth = GetPlayerHealth(iClient);
			new iCurrentMaxHealth = RoundToNearest(TANK_HEALTH_ICE * g_fTankStartingHealthMultiplier[iClient]);
			
			if (g_iIceTankLifePool[iClient] > 0 && iCurrentHealth < iCurrentMaxHealth)
			{
				// Clamps health to Max Health
				int iExtraHealth = iCurrentHealth + TANK_ICE_REGEN_RATE > iCurrentMaxHealth ? iCurrentMaxHealth : iCurrentHealth + TANK_ICE_REGEN_RATE;
				// clamp to g_iIceTankLifePool
				iExtraHealth = g_iIceTankLifePool[iClient] < TANK_ICE_REGEN_RATE ? g_iIceTankLifePool[iClient] : TANK_ICE_REGEN_RATE;
				SetPlayerHealth(iClient, -1, iExtraHealth, true);
				fCurrentTankHealthPercentage = float(iCurrentHealth + iExtraHealth) / float(iCurrentMaxHealth);
				// Set new Life Pool and clamp to 0
				g_iIceTankLifePool[iClient] = g_iIceTankLifePool[iClient] - TANK_ICE_REGEN_RATE > 0 ? g_iIceTankLifePool[iClient] - TANK_ICE_REGEN_RATE : 0;
				
				if (IsFakeClient(iClient) == false)
				{
					if (g_iIceTankLifePool[iClient] > 0)
						PrintHintText(iClient, "Life Pool Remaining: %d", g_iIceTankLifePool[iClient]);
					else
						PrintHintText(iClient, "Life Pool Depleted");
				}

				if (g_iIceTankLifePool[iClient] == 0)
				{
					g_bShowingIceSphere[iClient] = false;
				}
				else
				{
					//Show the ice sphere around the Ice Tank
					g_bShowingIceSphere[iClient] = true;
					
					if(g_iPID_IceTankChargeMistStock[iClient] == -1 && g_iPID_IceTankChargeMistAddon[iClient] == -1 && g_iPID_IceTankChargeSnow[iClient] == -1)
					{
						g_iPID_IceTankChargeMistAddon[iClient] = WriteParticle(iClient, "ice_tank_charge_mist", 50.0);
						g_iPID_IceTankChargeSnow[iClient] = WriteParticle(iClient, "ice_tank_charge_snow", 50.0);

						//Make Ice Fog Entity
						g_iPID_IceTankChargeMistStock[iClient] = CreateEntityByName("env_smokestack");
						char vecString[32];
						Format(vecString, sizeof(vecString), "%f %f %f", g_xyzClientTankPosition[iClient][0], g_xyzClientTankPosition[iClient][1], g_xyzClientTankPosition[iClient][2]);

						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"Origin", vecString);
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"BaseSpread", "0");		//Gap in the middle
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"SpreadSpeed", "90");	//Speed the smoke moves outwards
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"Speed", "50");			//Speed the smoke moves up
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"StartSize", "1");
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"EndSize", "150");
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"Rate", "60");			//Amount of smoke created
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"JetLength", "200");		//Smoke jets outside of the original
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"Twist", "30"); 			//Amount of global twisting
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"RenderColor", "200 230 255");
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"RenderAmt", "50");		//Transparency
						DispatchKeyValue(g_iPID_IceTankChargeMistStock[iClient],"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
						
						DispatchSpawn(g_iPID_IceTankChargeMistStock[iClient]);
						AcceptEntityInput(g_iPID_IceTankChargeMistStock[iClient], "TurnOn");
					}
					
					if(g_hTimer_IceSphere[iClient] == null)
						g_hTimer_IceSphere[iClient] = CreateTimer(0.1, Timer_CreateSmallIceSphere, iClient, TIMER_REPEAT);

					float xyzCurrentPosition[3];
					GetClientAbsOrigin(iClient, xyzCurrentPosition);
					
					//Check to see if there is a player inside of the ice sphere and freeze him if he is
					for(new iVictim = 1; iVictim <= MaxClients; iVictim++)
					{
						if(g_bFrozenByTank[iVictim] == true || g_iClientTeam[iVictim] != TEAM_SURVIVORS 
							|| IsClientInGame(iVictim) == false || IsPlayerAlive(iVictim) == false)
							continue;
						
						float xyzVictimPosition[3];
						GetClientAbsOrigin(iVictim, xyzVictimPosition);
						
						float fDistance = GetVectorDistance(xyzVictimPosition, xyzCurrentPosition, false);
						
						//The sphere radius is about 125.0 but check for 130.0 to be safe
						if(fDistance <= 130.0)
							CreateTimer(0.1, Timer_FreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
				
				//Set the color of the tank to match his current health percentage
				new iGreen	= 20 + RoundToNearest(235 * fCurrentTankHealthPercentage);
				
				SetEntityRenderMode(iClient, RenderMode:0);
				SetEntityRenderColor(iClient, 0, iGreen, 255, 255);
			}
		}
	}
	else if(g_iTankCharge[iClient] > 0 && g_bIceTankSliding[iClient] == false && !(buttons & IN_WALK))
	{
		// PrintToChatAll("g_iIceTankLifePool[iClient]: %i", g_iIceTankLifePool[iClient]);

		if (g_iIceTankLifePool[iClient] > 0 && 
			g_iTankCharge[iClient] > 31 && 
			IsFakeClient(iClient) == false &&
			IsPlayerAlive(iClient) == true &&
			GetPlayerHealth(iClient) < RoundToNearest(TANK_HEALTH_ICE * g_fTankStartingHealthMultiplier[iClient]))
			PrintHintText(iClient, "Health Regeneration Charge Interrupted");
		
		g_iTankCharge[iClient] = 0;
		g_bShowingIceSphere[iClient] = false;
	}
}

OnPlayerRunCmd_Tank_Ice(iClient, iButtons)
{
	if (g_iTankChosen[iClient] != TANK_ICE)
		return;

	HandleIceTankSlideRunCommand(iClient, iButtons);
}



EventsHurt_VictimTank_Ice(Handle hEvent, iAttacker, iVictimTank)
{
	SuppressNeverUsedWarning(hEvent, iAttacker);

	new iDmgHealth  = GetEventInt(hEvent,"dmg_health");
	new iDmgType = GetEventInt(hEvent, "type");

	new iCurrentHealth = GetPlayerHealth(iVictimTank);
	float fCurrentTankHealthPercentage;

	// Add More Fire Damage
	HandleFireDamageVictimIceTank(iAttacker, iVictimTank, iDmgHealth, iDmgType);

	// Add More Damage if the Tank is sliding
	if (g_bIceTankSliding[iVictimTank] == true)
		SetPlayerHealth(iVictimTank, iAttacker, RoundToNearest(-1.0 * iDmgHealth * TANK_ICE_SLIDE_DAMAGE_RECIEVED_MULTIPLIER) + iDmgHealth, true);
	
	fCurrentTankHealthPercentage = float(iCurrentHealth + iDmgHealth) / (TANK_HEALTH_ICE * g_fTankStartingHealthMultiplier[iVictimTank]);
	
	//Check to see if the difference in stored health and current health percentage is significant
	if(g_fTankHealthPercentage[iVictimTank] - fCurrentTankHealthPercentage >= 0.01)
	{
		g_fTankHealthPercentage[iVictimTank] = fCurrentTankHealthPercentage;
		
		//Change the actual color of the tank to reflect his health
		//Go from Light Blue to Dark Blue by lowering the green value
		new iGreen	= 20 + RoundToNearest(235 * fCurrentTankHealthPercentage);
		
		SetEntityRenderMode(iVictimTank, RenderMode:0);
		SetEntityRenderColor(iVictimTank, 0, iGreen, 255, 255);
	}
}

EventsHurt_AttackerTank_Ice(Handle hEvent, iAttackerTank, iVictim)
{
	SuppressNeverUsedWarning(iAttackerTank);

	char weapon[20];
	GetEventString(hEvent,"weapon", weapon, 20);

	// Temporarily disable Tank Slow Aura after the tank hits a victim only if they are already in the aura
	if (g_fIceTankColdAuraSlowSpeedReduction[iVictim] > 0.0 &&
		(StrEqual(weapon,"tank_rock") == true || 
		StrEqual(weapon,"tank_claw") == true))
	{
		// PrintToChatAll("___ Disabling COLD AURA for %N", iVictim);
		g_bIceTankColdAuraDisabled[iVictim] = true;
		SetClientSpeed(iVictim);

		// Reset the timer to enable cold aura again, if punched again it will wait an additional X seconds.
		delete g_hTimer_IceTankColdSlowAuraEnableAgain[iVictim];
		g_hTimer_IceTankColdSlowAuraEnableAgain[iVictim] = CreateTimer(TANK_ICE_COLD_SLOW_AURA_HIT_DISABLE_DURATION, Timer_EnableIceTankColdSlowAura, iVictim);

	}

	if(g_bFrozenByTank[iVictim] == false && g_bBlockTankFreezing[iVictim] == false)
	{
		if(StrEqual(weapon,"tank_rock") == true)
			FreezePlayerByTank(iVictim, TANK_ICE_FREEZE_DURATION_ROCK_DIRECT);
		else if((StrEqual(weapon,"tank_claw") == true && GetRandomInt(1, 3) == 1))
			FreezePlayerByTank(iVictim, TANK_ICE_FREEZE_DURATION_PUNCH);
	}
	else
		UnfreezePlayerByTank(iVictim);
}

EventsDeath_VictimTank_Ice(Handle hEvent, iAttacker, iVictimTank)
{
	// if (RunClientChecks(iVictimTank) == false)
	// 	return;

	SuppressNeverUsedWarning(hEvent, iVictimTank, iAttacker);

	ResetAllPlayersInIceTanksColdAuraSlowRange();
}

void HandleFireDamageVictimIceTank(int iAttacker, int iVictimTank, int iDmgHealth, int iDmgType)
{
	//PrintToChatAll("DMG TYPE: %i, DMG_HEALTH: %i, ", iDmgType, iDmgHealth);

	if (iDmgType == DAMAGETYPE_FIRE1 || iDmgType == DAMAGETYPE_FIRE2)
	{
		SetPlayerHealth(iVictimTank, iAttacker, (-1 * TANK_FIRE_DAMAGE_IN_FIRE), true);
		return;
	}

	if (iDmgType == DAMAGETYPE_IGNITED_ENTITY)
	{
		ExtinguishEntity(iVictimTank);
		return;
	}

	// From here on, make sure the attacker is a Survivor
	if (g_iClientTeam[iAttacker] != TEAM_SURVIVORS)
		return;

	int iWeapon = GetEntPropEnt(iAttacker, Prop_Send, "m_hActiveWeapon");

	// Check if the Attacker is Ellis with bind 2 enabled
	if (g_iChosenSurvivor[iAttacker] == ELLIS && g_bUsingFireStorm[iAttacker] == true)
	{
		//Check if the player is using anything other than a melee before proceeding
		char strEntityClassName[32];
		GetEntityClassname(iWeapon, strEntityClassName, 32);
		if (StrContains(strEntityClassName, "weapon_melee", true) == -1)
		{
			// Handle the extra damage and return
			SetPlayerHealth(iVictimTank, iAttacker, RoundToNearest(-1.0 * iDmgHealth * TANK_FIRE_DAMAGE_FIRE_BULLETS_ADD_MULTIPLIER) + iDmgHealth, true);
			return;
		}
	}
	
	// Find out of they are currently using a primary weapon and if have has fire bullets, exit if not
	if (RunEntityChecks(iWeapon) == false || 
		iWeapon != GetPlayerWeaponSlot(iAttacker, 0) ||
		HasEntProp(iWeapon, Prop_Send, "m_nUpgradedPrimaryAmmoLoaded") == false)
		return;

	int iUpgradedType = GetEntProp(iWeapon, Prop_Send, "m_upgradeBitVec");

	// If its not fire rounds, then return
	if (!(iUpgradedType & UPGRADETYPE_INCENDIARY))
		return;
	
	//PrintToChatAll("FIRE AMMO DMG: %i", RoundToNearest(-1.0 * iDmgHealth * TANK_FIRE_DAMAGE_FIRE_BULLETS_ADD_MULTIPLIER) + iDmgHealth);
	SetPlayerHealth(iVictimTank, iAttacker, RoundToNearest(-1.0 * iDmgHealth * TANK_FIRE_DAMAGE_FIRE_BULLETS_ADD_MULTIPLIER) + iDmgHealth, true);
}

FreezePlayerByTank(iVictim, float fFreezeTime, float fStartTime = 0.2)
{
	if (RunClientChecks(iVictim) == false)
		return;
	
	CreateTimer(fStartTime, Timer_FreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(fFreezeTime, Timer_UnfreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
}

UnfreezePlayerByTank(iClient)
{
	if(iClient < 1 || g_iClientTeam[iClient] != TEAM_SURVIVORS || g_bFrozenByTank[iClient] == false || IsValidEntity(iClient) == false || 
		IsClientInGame(iClient) == false || IsPlayerAlive(iClient) == false)
		return;
	
	g_bFrozenByTank[iClient] =  false;
	g_bBlockTankFreezing[iClient] = true;
	
	//Reset To Allow The Player To Be Frozen Again
	CreateTimer(TANK_ICE_FREEZE_COOLDOWN_AFTER_UNFREEZE, Timer_UnblockTankFreezing, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	//Play Ice Break Sound
	float vec[3];
	GetClientAbsOrigin(iClient, vec);
	EmitAmbientSound(SOUND_FREEZE, vec, iClient, SNDLEVEL_NORMAL);
	
	StopHudOverlayColor(iClient)
	
	//Set Player Model Color
	SetClientRenderAndGlowColor(iClient);
	//ResetGlow(iClient);
	
	//Reset Movement Speed
	SetClientSpeed(iClient);
	//ResetSurvivorSpeed(iClient);
}

CreateIceRockDestroyEffect(int iRockEntity)
{
	// Find the tank rock entity in the list that will be used to the trail particle entity
	new iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iRockEntity, TANK_ROCK_ENTITY_ID);
	new iTankRockTrailParticle = g_listTankRockEntities.Get(iTankRockIndex, TANK_ROCK_PARTICLE_TRAIL);
	// Stop the trail particle and remove it
	TurnOffAndDeleteSmokeStackParticle(iTankRockTrailParticle);

	float xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);
	xyzRockPosition[2] -= 20.0;

	char vecString[32];
	Format(vecString, sizeof(vecString), "%f %f %f", xyzRockPosition[0], xyzRockPosition[1], xyzRockPosition[2]);

	//Create particles
	WriteParticle(iRockEntity, "impact_glass", 0.0, 5.0, xyzRockPosition);
	WriteParticle(iRockEntity, "impact_glass_cheap", 0.0, 5.0, xyzRockPosition);
	WriteParticle(iRockEntity, "water_child_water6", 0.0, 5.0, xyzRockPosition);
	WriteParticle(iRockEntity, "tank_rock_throw_impact_chunks", 0.0, 5.0, xyzRockPosition);
	
	//Make Smoke Entity
	new smoke = CreateEntityByName("env_smokestack");
	
	DispatchKeyValue(smoke,"Origin", vecString);
	DispatchKeyValue(smoke,"BaseSpread", "0");		//Gap in the middle
	DispatchKeyValue(smoke,"SpreadSpeed", "350");	//Speed the smoke moves outwards
	DispatchKeyValue(smoke,"Speed", "200");			//Speed the smoke moves up
	DispatchKeyValue(smoke,"StartSize", "10");
	DispatchKeyValue(smoke,"EndSize", "550");
	DispatchKeyValue(smoke,"Rate", "150");			//Amount of smoke created
	DispatchKeyValue(smoke,"JetLength", "300");		//Smoke jets outside of the original
	DispatchKeyValue(smoke,"Twist", "10"); 			//Amount of global twisting
	DispatchKeyValue(smoke,"RenderColor", "200 230 255");
	DispatchKeyValue(smoke,"RenderAmt", "105");		//Transparency
	DispatchKeyValue(smoke,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
	
	DispatchSpawn(smoke);
	AcceptEntityInput(smoke, "TurnOn");
	
	CreateTimer(1.5, TimerStopSmokeEntity, smoke, TIMER_FLAG_NO_MAPCHANGE);
}

CreateIceRockTrailEffect(int iRockEntity)
{
	float xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);
	char vecString[32];
	Format(vecString, sizeof(vecString), "%f %f %f", xyzRockPosition[0], xyzRockPosition[1], xyzRockPosition[2]);

	// Make Smoke Entity
	new iTankRockTrailParticle = CreateEntityByName("env_smokestack");
	// Find the tank rock entity in the list that will be used store the trail particle entity
	new iTankRockIndex = FindIndexInArrayListUsingValue(g_listTankRockEntities, iRockEntity, TANK_ROCK_ENTITY_ID);
	// Store it for stopping and destroying it later
	g_listTankRockEntities.Set(iTankRockIndex, iTankRockTrailParticle, TANK_ROCK_PARTICLE_TRAIL);
	
	DispatchKeyValue(iTankRockTrailParticle,"Origin", vecString);
	DispatchKeyValue(iTankRockTrailParticle,"BaseSpread", "0");		//Gap in the middle
	DispatchKeyValue(iTankRockTrailParticle,"SpreadSpeed", "30");	//Speed the smoke moves outwards
	DispatchKeyValue(iTankRockTrailParticle,"Speed", "2");			//The speed at which the smoke particles move after they're spawned
	DispatchKeyValue(iTankRockTrailParticle,"StartSize", "40");
	DispatchKeyValue(iTankRockTrailParticle,"EndSize", "80");
	DispatchKeyValue(iTankRockTrailParticle,"Rate", "100");			//Amount of smoke created
	DispatchKeyValue(iTankRockTrailParticle,"JetLength", "8");		//Smoke jets outside of the original
	DispatchKeyValue(iTankRockTrailParticle,"Twist", "3"); 			//Amount of global twisting
	DispatchKeyValue(iTankRockTrailParticle,"RenderColor", "200 230 255");
	DispatchKeyValue(iTankRockTrailParticle,"RenderAmt", "205");		//Transparency
	DispatchKeyValue(iTankRockTrailParticle,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
	
	
	SetVariantString("!activator");
	AcceptEntityInput(iTankRockTrailParticle, "SetParent", iRockEntity, iTankRockTrailParticle, 0);

	DispatchSpawn(iTankRockTrailParticle);
	AcceptEntityInput(iTankRockTrailParticle, "TurnOn");
	
	CreateTimer(30.0, TimerStopSmokeEntity, iTankRockTrailParticle, TIMER_FLAG_NO_MAPCHANGE);
}


CreateIceTankTrailEffect(int iClient)
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
	DispatchKeyValue(g_iPID_TankTrail[iClient],"RenderColor", "200 230 255");
	DispatchKeyValue(g_iPID_TankTrail[iClient],"RenderAmt", "50");		//Transparency
	DispatchKeyValue(g_iPID_TankTrail[iClient],"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
	
	
	SetVariantString("!activator");
	AcceptEntityInput(g_iPID_TankTrail[iClient], "SetParent", iClient, g_iPID_TankTrail[iClient], 0);

	DispatchSpawn(g_iPID_TankTrail[iClient]);
	AcceptEntityInput(g_iPID_TankTrail[iClient], "TurnOn");
}

FreezeEveryoneCloseToExplodingIceTankRock(iRockEntity)
{
	// Get the rock location
	float xyzRockPosition[3];
	GetEntPropVector(iRockEntity, Prop_Send, "m_vecOrigin", xyzRockPosition);

	for(new iClient=1; iClient <= MaxClients; iClient++)
	{
		if(RunClientChecks(iClient) &&
			IsPlayerAlive(iClient) &&
			g_iClientTeam[iClient] == TEAM_SURVIVORS)
		{
			// Get the survivor player location
			float xyzSurvivorPosition[3];
			GetClientAbsOrigin(iClient, xyzSurvivorPosition);
			//Check if player is within the radius to freeze
			// Get the distance
			float fDistance = GetVectorDistance(xyzSurvivorPosition, xyzRockPosition, false);		
			//Freeze if they are close enough
			if (fDistance <= TANK_ICE_ROCK_FREEZE_INDIRECT_HIT_RADIUS)
				FreezePlayerByTank(iClient, TANK_ICE_FREEZE_DURATION_ROCK_INDIRECT);
		}
	}
}

CheckForPlayersInIceTanksColdAuraSlowRange(iTank)
{
	// Stop Cold Aura if the player is or has just been ice sliding
	if (g_bIceTankSliding[iTank] == true ||
		g_bIceTankSlideInCooldown[iTank] == true)
		return;

	float xyzTankPosition[3];
	GetClientEyePosition(iTank, xyzTankPosition);

	for(new iClient=1; iClient <= MaxClients; iClient++)
	{
		if(RunClientChecks(iClient) == false ||
			IsPlayerAlive(iClient) == false ||
			g_iClientTeam[iClient] != TEAM_SURVIVORS)
			continue;

		// Get the survivor player location
		float xyzSurvivorPosition[3];
		GetClientEyePosition(iClient, xyzSurvivorPosition);
		// Check if player is within the radius to slow
		// Get the distance
		float fDistance = GetVectorDistance(xyzSurvivorPosition, xyzTankPosition, false);		
		//Freeze if they are close enough
		if (fDistance < TANK_ICE_COLD_SLOW_AURA_RADIUS)
		{
			// Get the normalized distance and set their speed to be reduced that factor
			float fSpeedReductionCalc = (1.0 - (fDistance / TANK_ICE_COLD_SLOW_AURA_RADIUS)) * TANK_ICE_COLD_SLOW_AURA_SPEED_REDUCE_AMOUNT;
			
			// Only set a new value if the delta is beyond a threshold
			if (FloatAbs(fSpeedReductionCalc - g_fIceTankColdAuraSlowSpeedReduction[iClient]) > 0.01)
			{
				g_fIceTankColdAuraSlowSpeedReduction[iClient] = fSpeedReductionCalc;
				SetClientSpeed(iClient);
			}
		}
		// Reset the value of g_fIceTankColdAuraSlowSpeedReduction if its set and its beyond the distance
		else if (g_fIceTankColdAuraSlowSpeedReduction[iClient] > 0.0)
		{
			// PrintToChatAll("*** RESETTING COLD AURA SPEED %N", iClient);
			g_fIceTankColdAuraSlowSpeedReduction[iClient] = 0.0;
			SetClientSpeed(iClient);
		}
	}
}

// On death, reset all players cold aura, it will be set again on next game frame if there is another Ice Tank
ResetAllPlayersInIceTanksColdAuraSlowRange()
{
	for(new iClient=1; iClient <= MaxClients; iClient++)
	{
		// Reset for everyone
		g_fIceTankColdAuraSlowSpeedReduction[iClient] = 0.0;
		
		// Reset the speed for any potential survivors
		if(RunClientChecks(iClient) &&
			IsPlayerAlive(iClient) &&
			g_iClientTeam[iClient] == TEAM_SURVIVORS)
			SetClientSpeed(iClient);
	}
}

HandleIceTankSlideRunCommand(iClient, iButtons)
{
	if (!(iButtons & IN_SPEED))
		return;

	if (g_bIceTankSlideInCooldown[iClient] == true)
	{
		PrintHintText(iClient, "Ice Slide is in cooldown");
		return;
	}
	
	if (g_iTankCharge[iClient] > 0 && g_iIceTankLifePool[iClient] > 0)
	{
		PrintHintText(iClient, "Cannot use Ice Slide while regenerating health");
		return;
	}
	
	g_bIceTankSliding[iClient] = true;
	SetClientSpeed(iClient);
}

Action TimerResetIceTankSlideCooldown(Handle timer, int iClient)
{
	g_bIceTankSlideInCooldown[iClient] = false;
	return Plugin_Stop;
}