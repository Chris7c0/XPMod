
Event_AbilityUse(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	if (iClient < 1)
		return;
	decl String:ability[20];
	GetEventString(hEvent,"ability",ability,20);
	//new context = GetClientOfUserId(GetEventInt(hEvent, "context"));
	//PrintToChat(iClient, "ability used: %s, context = %d", ability, context);
	
	if(StrEqual(ability,"ability_vomit",false) == true)
	{
		g_bIsBoomerVomiting[iClient] = true;

		if(g_bIsServingHotMeal[iClient] == false)
		{
			SetClientSpeed(iClient);
			
			CreateTimer(1.5, TimerResetBoomerSpeed, iClient, TIMER_FLAG_NO_MAPCHANGE);
			if(g_iRapidLevel[iClient] > 0)
				CreateTimer(1.0, TimerSetBoomerCooldown, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	if(g_iPredatorialLevel[iClient] > 0)
	{
		if(StrEqual(ability,"ability_lunge",false) == true)
			CreateTimer(0.1, TimerLungeFurther, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
	return;
}

Action:Event_PlayerNowIt(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iAttacker = GetClientOfUserId(GetEventInt(hEvent,"attacker"));
	new iVictim = GetClientOfUserId(GetEventInt(hEvent,"userid"));

	if (iAttacker == 0 || iVictim == 0)
		return Plugin_Continue;
	
	if(IsClientInGame(iAttacker) == true && IsFakeClient(iAttacker) == false && g_iClientTeam[iAttacker] == TEAM_INFECTED)
	{
		g_iVomitVictimAttacker[iVictim] = iAttacker;
		CreateTimer(20.0, TimerResetPlayerIt, iVictim, TIMER_FLAG_NO_MAPCHANGE); 
	}

	// Handle the Boomer's abilities
	Event_BoomerVomitOnPlayer(iAttacker, iVictim);

	// Handle the bile on tanks, like removing vomit
	Event_BoomerVomitOnPlayerTank(iVictim);
	
	return Plugin_Continue;
}

Action:Event_ChargerChargeStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	
	g_bIsChargerCharging[attacker] = true;
	
	if(g_bIsSuperCharger[attacker] == true)
	{
		SetClientSpeed(attacker);
		g_iClientBindUses_1[attacker]++;
	}
	
	return Plugin_Continue;
}


Action:Event_ChargerChargeEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	
	g_bIsChargerCharging[attacker] = false;
	
	if(g_iHillbillyLevel[attacker] > 0)
		CreateTimer(1.0, TimerSetChargerCooldown, attacker,  TIMER_FLAG_NO_MAPCHANGE);
		
	if(g_bIsSuperCharger[attacker] == true)
	{
		g_bIsSuperCharger[attacker] = false;
		SetClientSpeed(attacker);

		CreateTimer(30.0, TimerResetSuperCharge, attacker,  TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}

Action:Event_ChargerImpact(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	if(g_iGroundLevel[attacker] > 0)
	{
		decl iDamage;
		
		if(g_iGroundLevel[attacker] < 4)
			iDamage = (g_iGroundLevel[attacker] - 1);
		else if(g_iGroundLevel[attacker] < 7)
			iDamage = (g_iGroundLevel[attacker] - 2);
		else if(g_iGroundLevel[attacker] < 10)
			iDamage = (g_iGroundLevel[attacker] - 3);
		else iDamage = 6;
		
		new iCurrentHealth = GetEntProp(victim,Prop_Data,"m_iHealth");
		SetEntProp(victim, Prop_Data, "m_iHealth", iCurrentHealth - iDamage);
	}
	if(g_iSpikedLevel[attacker] > 0)
	{
		
		new heal = GetEntProp(attacker,Prop_Data,"m_iHealth");
		SetEntProp(attacker, Prop_Data, "m_iHealth", heal + (g_iSpikedLevel[attacker] * 33));
	}

	return Plugin_Continue;
}
Action:Event_ChargerCarryStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	canchangemovement[victim]=false;
	
	g_bChargerCarrying[attacker] = true;
	
	GiveClientXP(attacker, 50, g_iSprite_50XP_SI, victim, "Grappled A Survivor.");
	
	if(g_iHillbillyLevel[attacker] > 0)
		g_iPID_ChargerShield[attacker] = WriteParticle(attacker, "charger_shield", 70.0);
		
	fnc_SetRendering(victim);
	return Plugin_Continue;
}

Action:Event_ChargerCarryEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	canchangemovement[victim]=true;
	
	g_bChargerCarrying[attacker] = false;
	
	if(g_iPID_ChargerShield[attacker] != -1)
	{
		DeleteParticleEntity(g_iPID_ChargerShield[attacker]);
		g_iPID_ChargerShield[attacker] = -1;
	}
	
	if(g_bUsingTongueRope[victim])
	{
		g_bUsingTongueRope[victim] = false;
		SetMoveType(victim, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
	}
	fnc_SetRendering(victim);
	return Plugin_Continue;
}

Action:Event_ChargerPummelStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	GiveClientXP(attacker, 50, g_iSprite_50XP_SI, victim, "Grappled A Survivor.");
	
	if(IsClientInGame(victim))
	{
		if(IsPlayerAlive(victim))
		{
			g_iChargerVictim[attacker] = victim;
			g_bChargerGrappled[victim] = true;
		}
	}
	fnc_SetRendering(victim);
	return Plugin_Continue;
}

Action:Event_ChargerPummelEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new chargerid = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	//PrintToChatAll("PummelEnd %N is no longer charged", victim);
	g_iChargerVictim[chargerid] = 0;
	g_bChargerGrappled[victim] = false;
	
	if(g_bDivineInterventionQueued[victim] == true)
	{
		new Float:fTempHealth = GetEntDataFloat(victim, g_iOffset_HealthBuffer);
		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
		FakeClientCommand(victim, "give health");
		fTempHealth = 0.0;
		SetEntDataFloat(victim,g_iOffset_HealthBuffer, fTempHealth ,true);
		PrintHintText(victim,"Rolled an 11\nYou have received divine intervention from above...or below.");
		PrintToChat(victim, "\x03[XPMod] \x05You were given a fresh life.");
		SetCommandFlags("give", g_iFlag_Give);
		g_bIsClientDown[victim] = false;
		g_bDivineInterventionQueued[victim] = false;
	}
	fnc_SetRendering(victim);
	return Plugin_Continue;
}

Action:Event_ChargerKilled(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//new attacker = GetClientOfUserId(GetEventInt(hEvent,"attacker"));
	new chargerid = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	//PrintToChatAll("Charger Killed %N is no longer charged", g_iChargerVictim[chargerid]);
	//PrintToChat(g_iChargerVictim[chargerid], "Charger Killed: You are no longer charged");
	g_bChargerGrappled[g_iChargerVictim[chargerid]] = false;
	
	return Plugin_Continue;
}

Action:Event_ChokeStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));

	g_bSmokerGrappled[victim] = true;
	g_iChokingVictim[attacker] = victim;
	
	if(g_iDirtyLevel[attacker] > 0)
	{
		SetEntityMoveType(attacker, MOVETYPE_ISOMETRIC);
		//Going to avoid using SetClientSpeed here because it would not fit well
		//SetEntDataFloat(attacker, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (0.01 * g_iDirtyLevel[attacker]) , true);
		SetClientSpeed(attacker);
		//CreateTimer(0.3, TimerCheckTongueDistance, attacker, TIMER_FLAG_NO_MAPCHANGE);
	}

	fnc_SetRendering(victim);
	return Plugin_Continue;
}

Action:Event_ChokeEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	SetEntityMoveType(attacker, MOVETYPE_CUSTOM);

	g_bSmokerGrappled[victim] = false;
	g_iChokingVictim[attacker] = -1;

	SetClientSpeed(attacker);
	
	if(g_bDivineInterventionQueued[victim] == true)
	{
		new Float:fTempHealth = GetEntDataFloat(victim, g_iOffset_HealthBuffer);
		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
		FakeClientCommand(victim, "give health");
		fTempHealth = 0.0;
		SetEntDataFloat(victim,g_iOffset_HealthBuffer, fTempHealth ,true);
		PrintHintText(victim,"Rolled an 11\nYou have received divine intervention from above...or below.");
		PrintToChat(victim, "\x03[XPMod] \x05You were given a fresh life.");
		SetCommandFlags("give", g_iFlag_Give);
		g_bIsClientDown[victim] = false;
		g_bDivineInterventionQueued[victim] = false;
	}
	fnc_SetRendering(victim);
	return Plugin_Continue;
}

Action:Event_TongueRelease(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	g_bSmokerGrappled[victim] = false;
	fnc_SetRendering(victim);
	return Plugin_Continue;
}


Action:Event_TongueGrab(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToChatAll("toungue grab triggered");
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	g_bSmokerGrappled[victim] = true;
	if(g_iSmokeLevel[victim]>0)
	{
		decl percentchance;
		switch(g_iSmokeLevel[victim])
		{
			case 1:
				percentchance = GetRandomInt(1, 20);
			case 2:
				percentchance = GetRandomInt(1, 10);
			case 3:
				percentchance = GetRandomInt(1, 7);
			case 4:
				percentchance = GetRandomInt(1, 5);
			case 5:
				percentchance = GetRandomInt(1, 4);
		}
		if(percentchance == 1)
		{
			PrintHintText(victim, "You have ninja'd out of the Smoker's grasp");
			
			//Cloak
			SetEntityRenderMode(victim, RenderMode:3);
			SetEntityRenderColor(victim, 255, 255, 255, RoundToFloor(255 * (1.0 - (g_iSmokeLevel[victim] * 0.19))));
			//Disable Glow
			SetEntProp(victim, Prop_Send, "m_iGlowType", 3);
			SetEntProp(victim, Prop_Send, "m_nGlowRange", 0);
			SetEntProp(victim, Prop_Send, "m_glowColorOverride", 1);
			ChangeEdictState(victim, 12);
			
			delete g_hTimer_ResetGlow[victim];
			g_hTimer_ResetGlow[victim] = CreateTimer(5.0, Timer_ResetGlow, victim);

			if(IsFakeClient(attacker)==false)
			{
				PrintHintText(attacker, "%N has ninja'd out of your tongue", victim);
				SetEntProp(attacker, Prop_Send, "m_iHideHUD", 4);
				CreateTimer(5.0, TimerGiveHudBack, attacker, TIMER_FLAG_NO_MAPCHANGE); 
			}
			GetClientAbsOrigin(victim, g_xyzOriginalPositionRochelle[victim]);
			g_xyzOriginalPositionRochelle[victim][2] += 10;
			
			
			TeleportEntity(victim, g_xyzBreakFromSmokerVector, NULL_VECTOR, NULL_VECTOR);
			
			CreateTimer(0.1, Timer_BreakFreeOfSmoker, victim, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	fnc_SetRendering(victim);
	return Plugin_Continue;
}


Action:Event_JockeyRide(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	new	classnum = GetEntProp(attacker, Prop_Send, "m_zombieClass");
	
	g_bJockeyIsRiding[attacker] = true;
	g_bJockeyGrappled[victim] = true;
	g_iJockeysVictim[attacker] = victim;
	fnc_SetRendering(victim);

	GiveClientXP(attacker, 50, g_iSprite_50XP_SI, victim, "Grappled A Survivor.");
	
	if(classnum == JOCKEY)	//If the attacker truely is the JOCKEY(this function is called for more than just JOCKEY for some reason)
	{
		g_iJockeyVictim[attacker] = victim;
		if(g_iClientTeam[victim] == TEAM_SURVIVORS)
		{
			if(g_iStrongLevel[victim] > 0)
			{
				g_fJockeyRideSpeed[victim] = 0.0;
				SetClientSpeed(victim);
			}
			else if(g_iErraticLevel[attacker] > 0)
			{
				//SetEntDataFloat(victim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), ((1.0 + (g_iErraticLevel[attacker] * 0.03)) - ((g_iStrongLevel[victim] * 0.2) + ((g_iErraticLevel[attacker] * 0.03) * (g_iStrongLevel[victim] * 0.2)))), true);
				//PrintToChatAll("JOCKEY RIDESPEED SET: %f", ( 1.0 - (g_iStrongLevel[victim] * 0.2) + (g_iErraticLevel[attacker] * 0.03)) );
				//SetEntDataFloat(victim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), ( 1.0 - (g_iStrongLevel[victim] * 0.2) + (g_iErraticLevel[attacker] * 0.03) ), true);
				g_fJockeyRideSpeed[victim] = 1.0 + (g_iErraticLevel[attacker] * 0.03);
				SetClientSpeed(victim);
			}
			else
			{
				g_fJockeyRideSpeed[victim] = 1.0;
				SetClientSpeed(victim);
			}

			if(g_iSmokeLevel[victim]>0)
			{
				decl percentchance;
				switch(g_iSmokeLevel[victim])
				{
					case 1:
						percentchance = GetRandomInt(1, 20);
					case 2:
						percentchance = GetRandomInt(1, 10);
					case 3:
						percentchance = GetRandomInt(1, 7);
					case 4:
						percentchance = GetRandomInt(1, 5);
					case 5:
						percentchance = GetRandomInt(1, 4);
				}
				if(percentchance == 1)
				{
					PrintHintText(victim, "You have ninja'd out of the Jockey's grasp");
					
					//Cloak
					SetEntityRenderMode(victim, RenderMode:3);
					SetEntityRenderColor(victim, 255, 255, 255, RoundToFloor(255 * (1.0 - (g_iSmokeLevel[victim] * 0.19))));
					//Disable Glow
					SetEntProp(victim, Prop_Send, "m_iGlowType", 3);
					SetEntProp(victim, Prop_Send, "m_nGlowRange", 0);
					SetEntProp(victim, Prop_Send, "m_glowColorOverride", 1);
					ChangeEdictState(victim, 12);
					
					delete g_hTimer_ResetGlow[victim];
					g_hTimer_ResetGlow[victim] = CreateTimer(5.0, Timer_ResetGlow, victim);
					
					if(IsFakeClient(attacker) == false)
					{
						PrintHintText(attacker, "%N has ninja'd out of your grasp", victim);
						SetEntProp(attacker, Prop_Send, "m_iHideHUD", 4);
						CreateTimer(5.0, TimerGiveHudBack, attacker, TIMER_FLAG_NO_MAPCHANGE); 
					}
					new cmdflags = GetCommandFlags("dismount");
					SetCommandFlags("dismount", cmdflags & ~FCVAR_CHEAT);
					FakeClientCommand(attacker, "dismount");
					SetCommandFlags("dismount", cmdflags);
					//WriteParticle(victim, "rochelle_smoke", 0.0, 10.0);
					CreateRochelleSmoke(victim);

					return Plugin_Continue;
				}
			}
			if(g_iUnfairLevel[attacker] > 0)
			{
				new iReserveAmmoDropChance = GetRandomInt(1, 10);
				if(iReserveAmmoDropChance <= g_iUnfairLevel[attacker])
				{
					fnc_DeterminePrimaryWeapon(victim);
					GetClientWeapon(victim, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
					if((StrEqual(g_strCurrentWeapon, "weapon_melee", false) == false) && (StrEqual(g_strCurrentWeapon, "weapon_pistol", false) == false) && (StrEqual(g_strCurrentWeapon, "weapon_pistol_magnum", false) == false))
					{
						//PrintToChatAll("Reserve ammo was %i ...", g_iReserveAmmo[victim]);
						//g_iReserveAmmo[victim] = (g_iReserveAmmo[victim] / 2)
						//PrintToChatAll("Is this a float = %i", g_iReserveAmmo[victim]);
						SetEntData(victim, g_iOffset_Ammo[victim] + g_iAmmoOffset[victim], (g_iReserveAmmo[victim] / 2));
						//PrintToChatAll("... and is now %i", GetEntData(victim, g_iOffset_Ammo[victim] + g_iAmmoOffset[victim]));
					}
				}
			}
		}
	}
	
	return Plugin_Continue;
}


Action:Event_JockeyRideEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new rider = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));

	if(g_iMutatedLevel[rider] > 0 && RunClientChecks(rider)  == true && IsPlayerAlive(rider) == true)
		CreateTimer(1.0, TimerSetJockeyCooldown, rider, TIMER_FLAG_NO_MAPCHANGE);
	
	g_iJockeyVictim[rider] = -1;
	g_bJockeyIsRiding[rider] = false;
	g_bJockeyGrappled[victim] = false;

	g_fJockeyRideSpeed[victim] = 1.0;
	g_fJockeyRideSpeedVanishingActBoost[victim] = 0.0;
	SetClientSpeed(victim);

	fnc_SetRendering(victim);
	return Plugin_Continue;
}


Action:Event_HunterPounceStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	g_iHunterPounceDistance[attacker] = GetEventInt(hEvent, "distance");
	// PrintToChatAll("Distance: %i", g_iHunterPounceDistance[attacker]);
	g_bHunterGrappled[victim] = true;
	g_iHunterShreddingVictim[attacker] = victim;
	
	//SetEntDataFloat(victim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.0, true);

	if(g_iClientTeam[attacker] == TEAM_INFECTED)
	{
		GiveClientXP(attacker, 50, g_iSprite_50XP_SI, victim, "Grappled A Survivor.");
		if(g_iKillmeleonLevel[attacker] > 0)
		{
			if(g_iHunterPounceDamageCharge[attacker] > 20)
			{
				decl iDamage;
				iDamage = RoundToFloor(g_iHunterPounceDamageCharge[attacker] / 21.0);
				new Handle:iDataPack = CreateDataPack();
				WritePackCell(iDataPack, victim);
				WritePackCell(iDataPack, attacker);
				WritePackCell(iDataPack, iDamage);
				CreateTimer(0.1, TimerHunterPounceDamage, iDataPack, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		if(g_iSmokeLevel[victim]>0)		//For ROCHELLE ninja break free skills
		{
			decl percentchance;
			switch(g_iSmokeLevel[victim])
			{
				case 1:
					percentchance = GetRandomInt(1, 20);
				case 2:
					percentchance = GetRandomInt(1, 10);
				case 3:
					percentchance = GetRandomInt(1, 7);
				case 4:
					percentchance = GetRandomInt(1, 5);
				case 5:
					percentchance = GetRandomInt(1, 4);
			}
			if(attacker > 0)
			{
				if(IsClientInGame(attacker) == true)
				{
					if(percentchance == 1)
					{
						if(attacker > 0 && victim > 0)
						{
							SDKCall(g_hSDK_OnPounceEnd,attacker);
							//WriteParticle(victim, "rochelle_smoke", 0.0, 10.0);
							CreateRochelleSmoke(victim);
							
							g_bHunterGrappled[victim] = false;
							g_iHunterShreddingVictim[attacker] = -1;
							
							SetClientSpeed(victim);
							//ResetSurvivorSpeed(victim);
							
							PrintHintText(victim, "You have ninja'd out of the Hunter's grasp");
							
							//Cloak
							SetEntityRenderMode(victim, RenderMode:3);
							SetEntityRenderColor(victim, 255, 255, 255, RoundToFloor(255 * (1.0 - (g_iSmokeLevel[victim] * 0.19))));
							//Disable Glow
							SetEntProp(victim, Prop_Send, "m_iGlowType", 3);
							SetEntProp(victim, Prop_Send, "m_nGlowRange", 0);
							SetEntProp(victim, Prop_Send, "m_glowColorOverride", 1);
							ChangeEdictState(victim, 12);
							
							delete g_hTimer_ResetGlow[victim];
							g_hTimer_ResetGlow[victim] = CreateTimer(5.0, Timer_ResetGlow, victim);
							
							if(IsFakeClient(attacker) == false)
							{
								PrintHintText(attacker, "%N has ninja'd out of your grasp", victim);
								SetEntProp(attacker, Prop_Send, "m_iHideHUD", 4);
								CreateTimer(5.0, TimerGiveHudBack, attacker, TIMER_FLAG_NO_MAPCHANGE); 
							}
						}
					}
				}
			}
		}
	}
	fnc_SetRendering(attacker);
	fnc_SetRendering(victim);
	return Plugin_Continue;
}

Action:Event_HunterPounceStopped(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	g_bHunterGrappled[victim] = false;
	g_iHunterShreddingVictim[attacker] = -1;
	
	SetClientSpeed(victim);
	//ResetSurvivorSpeed(victim);
	
	if(g_bDivineInterventionQueued[victim] == true)
	{
		new Float:fTempHealth = GetEntDataFloat(victim, g_iOffset_HealthBuffer);
		SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
		FakeClientCommand(victim, "give health");
		fTempHealth = 0.0;
		SetEntDataFloat(victim,g_iOffset_HealthBuffer, fTempHealth ,true);
		PrintHintText(victim,"Rolled an 11\nYou have received divine intervention from above...or below.");
		PrintToChat(victim, "\x03[XPMod] \x05You were given a fresh life.");
		SetCommandFlags("give", g_iFlag_Give);
		g_bIsClientDown[victim] = false;
		g_bDivineInterventionQueued[victim] = false;
	}
	fnc_SetRendering(attacker);
	fnc_SetRendering(victim);
	return Plugin_Continue;
}

Action:Event_InfectedHurt(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent, "attacker"));
	new victim = GetEventInt(hEvent, "entityid");
	//new hitGroup = GetEventInt(hEvent, "hitgroup");
	//new dmgHealth = GetEventInt(hEvent, "amount");
	//new dmgType = GetEventInt(hEvent, "type");
	//PrintToChatAll("Attacker = %d, Victim = %d, dmgHealth = %d, dmgType = %d, hitGroup = %d", attacker, victim, dmgHealth, dmgType, hitGroup);
	
	if(g_iClientTeam[attacker] == TEAM_SURVIVORS)
	{
		switch(g_iChosenSurvivor[attacker])
		{
			case 0:		//Bill
			{
			
			}
			case 1:		//Rochelle
			{
			
			}
			case 2:		//Coach
			{
			
			}
			case 3:		//Ellis
			{
			
			}
			case 4:		//Nick
			{
				if(g_iMagnumLevel[attacker] > 0)
				{
					GetClientWeapon(attacker, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
					if(StrEqual(g_strCurrentWeapon, "weapon_pistol_magnum", false) == true)
					{
						g_iNickMagnumShotCount[attacker]++;
						//PrintToChatAll("g_iNickMagnumShotCount = %d", g_iNickMagnumShotCount[attacker]);
						if((g_iNickMagnumShotCountCap[attacker] / 2) < g_iNickMagnumShotCount[attacker])
						{
							g_iNickMagnumShotCount[attacker] = (g_iNickMagnumShotCountCap[attacker] / 2);
							//PrintToChatAll("g_iNickMagnumShotCount After = %d", g_iNickMagnumShotCount[attacker]);
						}
						if(g_iNickMagnumShotCount[attacker] == 3)
						{
							//PrintToChatAll("Nick Magnum Count = 3, stampede reload = true");
							g_bCanNickStampedeReload[attacker] = true;
						}
					}
				}
			}
		}
	}
	
	if(g_bUsingFireStorm[attacker]==true)
	{
		new Float:time = (float(g_iFireLevel[attacker]) * 6.0);
		IgniteEntity(victim, time, false);
	}
	/*if(g_iSilentLevel[iClient]>0)
	{
		decl String:weaponclass[32];
		GetEventString(hEvent,"weapon",weaponclass,32);		//weapon and item does not work for this
		//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
		if(StrContains(weaponclass,"sniper_military",false) != -1)
		{
			IgniteEntity(target, 5.0, false);
		}
	}*/
	return Plugin_Continue;
}

Action:Event_WitchKilled(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new victim = GetEventInt(hEvent, "witchid");
	new instakill = GetEventBool(hEvent, "oneshot");
	if (iClient > 0 && iClient <= MaxClients)
	{
		if(IsFakeClient(iClient) == true)
			return Plugin_Continue;
		if((GetClientTeam(iClient)) == TEAM_SURVIVORS) 	//can make more efficeint by getting this before
		{
			if(instakill)
			{
				g_iClientXP[iClient] += 350;
				CheckLevel(iClient);
				
				if(g_iXPDisplayMode[iClient] == 0)
					ShowXPSprite(iClient, g_iSprite_350XP, victim, 5.0);
				else if(g_iXPDisplayMode[iClient] == 1)
					PrintToChat(iClient, "\x03[XPMod] Witch Owned! You gain 350 XP");
			}
			else
			{
				g_iClientXP[iClient] += 250;
				CheckLevel(iClient);
				
				if(g_iXPDisplayMode[iClient] == 0)
					ShowXPSprite(iClient, g_iSprite_250XP, victim, 5.0);
				else if(g_iXPDisplayMode[iClient] == 1)
					PrintToChat(iClient, "\x03[XPMod] Witch Killed. You gain 250 XP");
			}
		}
	}
	return Plugin_Continue;
}


Action:Event_TankSpawn(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToChatAll("userid = %i tankindex = %i", (GetEventInt(hEvent, "userid")), (GetEventInt(hEvent, "tankid")));
	g_iTankCounter++;
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	g_iInfectedCharacter[iClient] = TANK;
	g_bTankOnFire[iClient] = false;
	
	CreateTimer(0.1, Timer_AskWhatTankToUse, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	for(new i=1;i<=MaxClients;i++)
	{
		if(RunClientChecks(i))
			if(g_iClientTeam[i] == TEAM_SURVIVORS)
				if(g_iJamminLevel[i] > 0)		//can make more efficeint by getting this before
				{
					//g_fEllisJamminSpeed[i] = (g_iJamminLevel[i] * 0.04);
					PrintHintText(i,"Tank is near, your adrenaline pumps and you become stronger");
					//SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					//FakeClientCommand(i, "give molotov");
					//SetCommandFlags("give", g_iFlag_Give);
					//if(tankspawnlvl speed > current ELLIS speed)
					if(g_bGameFrozen == false)
					{
						if(g_iTankCounter > 0)
						{
							SetClientSpeed(i);
						}
					}

					// Give temp health to ellis for tank spawn
					AddTempHealthToSurvivor(i, float(g_iJamminLevel[i]) * 5);

					if(g_iJamminLevel[i] == 5)
					{
						g_iEllisJamminGrenadeCounter[i]++;
					}
				}
	}
	return Plugin_Continue;
}

Action:Event_ZombieIgnited(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new victim = GetEventInt(hEvent, "entityid");
	
	if (iClient > 0 && iClient <= MaxClients)
	{
		if(IsFakeClient(iClient) == true)
			return Plugin_Continue;
		decl String:victimname[12];
		GetEventString(hEvent, "victimname", victimname, sizeof(victimname));
		if(StrEqual(victimname,"Tank",false))
		{
			if(g_bTankOnFire[victim] == false)
			{
				g_bTankOnFire[victim] = true;
				g_iClientXP[iClient] += 150;
				CheckLevel(iClient);
				
				if(g_iXPDisplayMode[iClient] == 0)
					ShowXPSprite(iClient, g_iSprite_150XP, victim, 5.0);
				else if(g_iXPDisplayMode[iClient] == 1)
					PrintToChat(iClient,"\x03[XPMod] You burned the TANK. You gain 150 XP");
			}
		}
	}
	return Plugin_Continue;
}

Action:Event_SpitBurst(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new iSpitEntity = GetEventInt(hEvent,"subject");
	
	if(g_iPuppetLevel[iClient] > 0)
	{
		//Temporarily block switching goo types
		g_bBlockGooSwitching[iClient] = true;
		
		delete g_hTimer_BlockGooSwitching[iClient];
		g_hTimer_BlockGooSwitching[iClient] = CreateTimer(8.2, TimerAllowGooSwitching, iClient);
		
		//Deploying goo type effects
		new Float:position[3];
		GetEntPropVector(iSpitEntity, Prop_Send, "m_vecOrigin", position);
		
		if(g_iGooType[iClient] == GOO_FLAMING)
		{
			MolotovExplode(position);
		}
		else
		{
			new smoke = CreateEntityByName("env_smokestack");
															
			new String:clientName[128], String:vecString[32];
			Format(clientName, sizeof(clientName), "Smoke%i", iClient);
			Format(vecString, sizeof(vecString), "%f %f %f", position[0], position[1], position[2]);
		
			new String:strSpitColorRGB[16];
			new iRed, iGreen, iBlue;
			
			switch(g_iGooType[iClient])
			{
				case GOO_ADHESIVE:
				{
					iRed = 255; iGreen = 255; iBlue = 0;
					WriteParticle(iSpitEntity, "spitter_goo_adhesive",0.0, 10.0);
				}
				case GOO_MELTING:
				{
					iRed = 255; iGreen = 0; iBlue = 0;
					WriteParticle(iSpitEntity, "spitter_goo_melting",0.0, 10.0);
				}
				case GOO_DEMI:
				{
					iRed = 60; iGreen = 0; iBlue = 255;
					WriteParticle(iSpitEntity, "spitter_goo_demi",0.0, 10.0);
				}
				case GOO_REPULSION:
				{
					iRed = 0; iGreen = 0; iBlue = 255;
					WriteParticle(iSpitEntity, "spitter_goo_repulsion",0.0, 10.0);
				}
				case GOO_VIRAL:
				{
					iRed = 0; iGreen = 255; iBlue = 0;
					WriteParticle(iSpitEntity, "spitter_goo_viral",0.0, 10.0);
				}
			}
			
			Format(strSpitColorRGB, sizeof(strSpitColorRGB), "%i %i %i", iRed, iGreen, iBlue);
			
			DispatchKeyValue(smoke,"targetname", clientName);
			DispatchKeyValue(smoke,"Origin", vecString);
			DispatchKeyValue(smoke,"BaseSpread", "1");		//Gap in the middle
			DispatchKeyValue(smoke,"SpreadSpeed", "100");	//Speed the smoke moves outwards
			DispatchKeyValue(smoke,"Speed", "100");			//Speed the smoke moves up
			DispatchKeyValue(smoke,"StartSize", "200");
			DispatchKeyValue(smoke,"EndSize", "200");
			DispatchKeyValue(smoke,"Rate", "20");			//Amount of smoke created
			DispatchKeyValue(smoke,"JetLength", "200");		//Smoke jets outside of the original
			DispatchKeyValue(smoke,"Twist", "10"); 			//Amount of global twisting
			DispatchKeyValue(smoke,"RenderColor", strSpitColorRGB);
			DispatchKeyValue(smoke,"RenderAmt", "50");		//Transparency
			DispatchKeyValue(smoke,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
			
			DispatchSpawn(smoke);
			AcceptEntityInput(smoke, "TurnOn");
			
			CreateTimer(8.0, TimerStopSmokeEntity, smoke, TIMER_FLAG_NO_MAPCHANGE);	
		}
		
		if(g_iMaterialLevel[iClient] > 0)
		{			
			position[1] += 1.0;
			position[2] += 1.0;
			
			WriteParticle(iClient, "spitter_conjure", 180.0, 7.0, position);
			
			new Handle:hDataPackage = CreateDataPack();
			WritePackCell(hDataPackage, iClient);
			WritePackFloat(hDataPackage, position[0]);
			WritePackFloat(hDataPackage, position[1]);
			WritePackFloat(hDataPackage, position[2]);
			
			CreateTimer(2.3, TimerConjureUncommonInfected, hDataPackage);
			
			if(g_iAcidReflexLeft[iClient] > 0)
			{
				CreateTimer(1.0, TimerInstantSpitterCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
				
				if(--g_iAcidReflexLeft[iClient] == 0)
					CreateTimer(30.0, TimerResetCanUseAcidReflex, iClient, TIMER_FLAG_NO_MAPCHANGE);
			}
			
			if(g_iHallucinogenicLevel[iClient] > 0)
				CreateTimer(1.0, TimerSetSpitterCooldown, iClient,  TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

Action:Event_WitchSpawn(Handle:hEvent, const String:sName[], bool:bDontBroadcast)
{
	new iWitchID = GetEventInt(hEvent, "witchid");
	
	new bool:bOwnerFound = false;
	decl iClient;
	for(iClient = 1; iClient <= MaxClients; iClient++)
	{
		if(g_bJustSpawnedWitch[iClient] == true && g_iClientTeam[iClient] == TEAM_INFECTED && g_iInfectedCharacter[iClient] == SPITTER
			&& IsClientInGame(iClient) == true && IsFakeClient(iClient) == false)
		{
			g_bJustSpawnedWitch[iClient] = false;
			bOwnerFound = true;
			break;
		}
	}
	
	if(bOwnerFound == false)
		return Plugin_Continue;
	
	//PrintToChatAll("Owner = %N", iClient);
	
	SetEntityModel(iWitchID, "models/infected/common_female_tshirt_skirt.mdl");
		
	TeleportEntity(iWitchID, g_xyzWitchConjureLocation[iClient], NULL_VECTOR, NULL_VECTOR);
	
	CreateTimer(0.1, Timer_CheckWitchRage, iWitchID, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Continue;
}

Action:Timer_CheckWitchRage(Handle:timer, any:iWitchID)
{
	if(IsValidEntity(iWitchID) == false)
		return Plugin_Stop;

	//TESTING class name to stop this error:
	// L 11/19/2020 - 16:58:10: [SM] Exception reported: Property "m_rage" not found (entity 140/func_nav_blocker)
	// L 11/19/2020 - 16:58:10: [SM] Blaming: xpmod.smx
	// L 11/19/2020 - 16:58:10: [SM] Call stack trace:
	// L 11/19/2020 - 16:58:10: [SM]   [0] GetEntPropFloat
	// L 11/19/2020 - 16:58:10: [SM]   [1] Line 1151, XPMod/Events/Events_Infected.sp::Timer_CheckWitchRage

	// Got this after:
	// Timer_CheckWitchRage: id = 796, className = witch
	// Timer_CheckWitchRage: id = 796, className = witch
	decl String:className[32];
	GetEntityClassname(iWitchID, className, 32)
	//PrintToServer("Timer_CheckWitchRage: id = %d, className = %s", iWitchID, className)
	if (strcmp(className, "witch", true) != 0)
	{
		//LogError("[XPMod] Stoping Timer_CheckWitchRage className != witch.  className: %s", className);
		return Plugin_Stop;
	}
	
	new Float:fRage = GetEntPropFloat(iWitchID, Prop_Send, "m_rage");
	
	//PrintToChatAll("Witch Rage Check: id = %d, Rage = %f", iWitchID, fRage);
	
	if(fRage >= 1.0)
	{
		SetEntityModel(iWitchID, "models/infected/witch.mdl");
		
		new Float:position[3];
		GetEntPropVector(iWitchID, Prop_Send, "m_vecOrigin", position);

		new smoke = CreateEntityByName("env_smokestack");
		
		new String:clientName[128], String:vecString[32];
		Format(clientName, sizeof(clientName), "Smoke%i", iWitchID);
		Format(vecString, sizeof(vecString), "%f %f %f", position[0], position[1], position[2]);

		DispatchKeyValue(smoke,"targetname", clientName);
		DispatchKeyValue(smoke,"Origin", vecString);
		DispatchKeyValue(smoke,"BaseSpread", "0");		//Gap in the middle
		DispatchKeyValue(smoke,"SpreadSpeed", "75");	//Speed the smoke moves outwards
		DispatchKeyValue(smoke,"Speed", "60");			//Speed the smoke moves up
		DispatchKeyValue(smoke,"StartSize", "10");
		DispatchKeyValue(smoke,"EndSize", "80");
		DispatchKeyValue(smoke,"Rate", "20");			//Amount of smoke created
		DispatchKeyValue(smoke,"JetLength", "80");		//Smoke jets outside of the original
		DispatchKeyValue(smoke,"Twist", "1"); 			//Amount of global twisting
		DispatchKeyValue(smoke,"RenderColor", "0 255 0");
		DispatchKeyValue(smoke,"RenderAmt", "255");		//Transparency
		DispatchKeyValue(smoke,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");

		DispatchSpawn(smoke);
		AcceptEntityInput(smoke, "TurnOn");
		
		CreateTimer(1.0, TimerStopSmokeEntity, smoke, TIMER_FLAG_NO_MAPCHANGE);
		
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

// Action:Event_GhostSpawnTime(Handle:hEvent, const String:sName[], bool:bDontBroadcast)
// {
// 	new iSpawner = GetClientOfUserId(GetEventInt(hEvent,"userid"));
// 	new Float:fSpawnTime = GetEventFloat(hEvent, "spawntime");
// 	PrintToChatAll("Spawn Time = %f", fSpawnTime);
// 	CreateTimer(fSpawnTime + 1.5, TimerSpawnGhostClass, iSpawner, TIMER_FLAG_NO_MAPCHANGE);
// }

// Action:TimerSpawnGhostClass(Handle:timer, any:iClient)
// {
// 	SetClientSpeed(iClient);

// 	PrintToChatAll("Spawned as ghost!");
	
// 	// if (g_iClientTeam[iClient] == TEAM_INFECTED)
// 	// {
// 	// 	g_iInfectedCharacter[iClient] = GetEntProp(iClient, Prop_Send, "m_zombieClass");
// 	// 	PrintToChatAll("ZombieClass = %d", g_iInfectedCharacter[iClient]);
		
// 	// 	if(g_iInfectedCharacter[iClient] != g_iClientInfectedClass1[iClient] && g_iInfectedCharacter[iClient] != g_iClientInfectedClass2[iClient] && g_iInfectedCharacter[iClient] != g_iClientInfectedClass3[iClient])
// 	// 	{
// 	// 		PrintToChatAll("Infected Character %i does not equal class %i, %i, or %i", g_iInfectedCharacter[iClient], g_iClientInfectedClass1[iClient], g_iClientInfectedClass2[iClient], g_iClientInfectedClass3[iClient]);
// 	// 		new WeaponIndex;
// 	// 		while ((WeaponIndex = GetPlayerWeaponSlot(iClient, 0)) != -1)
// 	// 		{
// 	// 			RemovePlayerItem(iClient, WeaponIndex);
// 	// 			RemoveEdict(WeaponIndex);
// 	// 		}

// 	// 		int newClass = 0
// 	// 		switch (GetRandomInt(0, 2))
// 	// 		{
// 	// 			case 0:
// 	// 			{
// 	// 				newClass = g_iClientInfectedClass1[iClient]
// 	// 			}
// 	// 			case 1:
// 	// 			{
// 	// 				newClass = g_iClientInfectedClass2[iClient]
// 	// 			}
// 	// 			case 2:
// 	// 			{
// 	// 				newClass = g_iClientInfectedClass3[iClient]
// 	// 			}
// 	// 		}

// 	// 		PrintToChatAll("Attempting to change spawn to %i", newClass);
// 	// 		SDKCall(g_hSetClass, iClient, newClass);
// 	// 		int cAbility = GetEntPropEnt(iClient, Prop_Send, "m_customAbility");
// 	// 		if (cAbility > 0) AcceptEntityInput(cAbility, "Kill");
// 	// 		new entData = GetEntData(SDKCall(g_hCreateAbility, iClient), g_iAbility)
// 	// 		if (entData > 0) SetEntProp(iClient, Prop_Send, "m_customAbility", entData);
// 	// 		PrintToChatAll("Should be spawned as a %i", newClass);

// 	// 		// Example OLD Code
// 	// 		// PrintToChatAll("Spawning as %i", g_iClientInfectedClass3[iClient]);
// 	// 		// SDKCall(g_hSetClass, iClient, g_iClientInfectedClass3[iClient]);
// 	// 		// new entprop = GetEntProp(iClient, Prop_Send, "m_customAbility")
// 	// 		// AcceptEntityInput(MakeCompatEntRef(entprop), "Kill");
// 	// 		// new ent = GetEntData(SDKCall(g_hCreateAbility, iClient), g_iAbility);
// 	// 		// SetEntProp(iClient, Prop_Send, "m_customAbility", ent);
// 	// 		// PrintToChatAll("Should be spawned as a %i", g_iClientInfectedClass3[iClient]);
// 	// 	}
// 	// }
	
// 	return Plugin_Stop;
// }

// Action:Event_EnteredSpit(Handle:hEvent, const String:sName[], bool:bDontBroadcast)
// {
// 	//new userid = GetClientOfUserId(GetEventInt(hEvent,"userid"));
// 	//new subject = GetEventInt(hEvent,"subject");
// 	// PrintToChatAll("Entered Spit, userid = %i", userid);
// 	// PrintToChatAll("Entered Spit, subject = %i", subject);
// }