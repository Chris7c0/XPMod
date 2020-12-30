
public Event_AbilityUse(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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
		if(g_bIsServingHotMeal[iClient] == false)
		{
			g_fClientSpeedPenalty[iClient] += (1.0 - (g_iRapidLevel[iClient] * 0.1))
			fnc_SetClientSpeed(iClient);
			//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.0 + (g_iRapidLevel[iClient] * 0.1), true);
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

public Event_PlayerNowIt(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"attacker"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"userid"));

	if (attacker == 0 || victim == 0)
		return;
	
	if(IsClientInGame(attacker) == true)
		if(IsFakeClient(attacker) == false)
			if(g_iClientTeam[attacker] == TEAM_INFECTED)
			{
				g_iVomitVictimAttacker[victim] = attacker;
				CreateTimer(20.0, TimerResetPlayerIt, victim, TIMER_FLAG_NO_MAPCHANGE); 
			}
	if(g_iInfectedCharacter[attacker] ==  BOOMER)
	{
		GiveClientXP(attacker, 15, g_iSprite_15XP_SI, victim, "Puked on a survivor.", false, 1.0);
		
		if(g_iAcidicLevel[attacker] > 0)
		{
			SetEntProp(victim, Prop_Send, "m_iHideHUD", 64);
			CreateTimer((g_iAcidicLevel[attacker] * 2.0), TimerGiveHudBack, victim, TIMER_FLAG_NO_MAPCHANGE); 
		}
		if(g_iNorovirusLevel[attacker] >= 5)
		{
			g_iVomitVictimCounter[attacker]++;
			if(g_iVomitVictimCounter[attacker] >= 3)
			{
				if(IsClientInGame(attacker) == true)
					if(IsFakeClient(attacker) == false)
					{
						new random = GetRandomInt(0, 6);
						switch(random)
						{
							case 0:		//Give 3 extra bind 1 and bind 2 uses
							{
								PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He gets an extra bind 1 and bind 2 charge.", attacker);
								g_iClientBindUses_1[attacker] --;
								g_iClientBindUses_2[attacker] --;
							}
							case 1:		//Set Health to 1000
							{
								if(IsPlayerAlive(attacker))
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He gets 1000 Health", attacker);
									SetEntProp(attacker,Prop_Data,"m_iMaxHealth", 1000);
									SetEntProp(attacker,Prop_Data,"m_iHealth", 1000);
								}
								else	//If their not alive then give them another reward
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. Common Infected temporarily do more damage.", attacker);
									g_bCommonInfectedDoMoreDamage = true;
									CreateTimer(20.0, TimerResetZombieDamage, 0, TIMER_FLAG_NO_MAPCHANGE);
								}
							}
							case 2:		//Constant vaomit for 8 seconds on last survivor hit
							{
								new bool:ok = false;
								if(IsClientInGame(victim) == true)
								{
									if(IsPlayerAlive(victim) == true)
									{
										PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. \x04%N\x05 got sick and is vomiting uncontrollably.", attacker, victim);
										CreateParticle("boomer_vomit", 2.0, victim, ATTACH_MOUTH, true);
										g_bIsSurvivorVomiting[victim] = true;
										g_iShowSurvivorVomitCounter[victim] = 20;
										CreateTimer(1.0, TimerConstantVomitDisplay, victim, TIMER_FLAG_NO_MAPCHANGE);
										ok = true;
									}
								}
								if(ok == false)	//If the victim is no longer alive, give health instead
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He gets 1000 Health", attacker);
									SetEntProp(attacker,Prop_Data,"m_iMaxHealth", 1000);
									SetEntProp(attacker,Prop_Data,"m_iHealth", 1000);
								}
							}
							case 3:		//Zombies do more damage
							{
								PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. Common Infected temporarily do more damage.", attacker);
								g_bCommonInfectedDoMoreDamage = true;
								CreateTimer(20.0, TimerResetZombieDamage, 0, TIMER_FLAG_NO_MAPCHANGE);
							}
							case 4:		//Get faster movement speed
							{
								if(IsPlayerAlive(attacker) == true)
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He gets temporary super speed.", attacker);
									//SetEntDataFloat(attacker , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 3.0, true);
									g_fClientSpeedBoost[attacker] += 2.0;
									fnc_SetClientSpeed(attacker);
									g_bIsSuperSpeedBoomer[attacker] = true;
									CreateTimer(20.0, TimerResetFastBoomerSpeed, attacker, TIMER_FLAG_NO_MAPCHANGE);
								}
								else	//If their not alive then give them another reward
								{
									PrintToChatAll("\x03[XPMod] \x05%N vomited on 3 survivors.  He gets an extra Bind 1 and Bind 2 charge.", attacker);
									g_iClientBindUses_1[attacker]--;
									g_iClientBindUses_2[attacker]--;
								}
							}
							case 5:		//Crack Out
							{
								if((IsPlayerAlive(victim)) && (IsFakeClient(victim) == false))
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. \x04%N\x05 swallowed some pills he puked up.", attacker, victim);
									PrintHintText(victim,"You swallowed some pills that %N puked up.", attacker);
									
									new red = GetRandomInt(0,255);
									new green = GetRandomInt(0,255);
									new blue = GetRandomInt(0,255);
									new alpha = GetRandomInt(190,230);
									
									ShowHudOverlayColor(victim, red, green, blue, alpha, 700, FADE_IN);
									
									g_iDruggedRuntimesCounter[victim] = 0;

									delete g_hTimer_DrugPlayer[victim];
									g_hTimer_DrugPlayer[victim] = CreateTimer(2.5, TimerDrugged, victim, TIMER_REPEAT);
									
									WriteParticle(victim, "drugged_effect", 0.0, 30.0);
								}
								else
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. A hoard has been summoned.", attacker);
									new flags = GetCommandFlags("z_spawn");
									SetCommandFlags("z_spawn", flags & ~FCVAR_CHEAT);
									FakeClientCommand(attacker, "z_spawn mob auto");
									SetCommandFlags("z_spawn", flags);
								}
							}
							case 6:
							{
								if(IsPlayerAlive(attacker) == true)
								{
									//SetConVarInt(FindConVar("z_no_cull"), 1);
									//SetConVarInt(FindConVar("z_common_limit"), 36);
									
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. Jimmy Gibbs has come to play!", attacker);
									decl Float:location[3], Float:ang[3];
									GetClientAbsOrigin(attacker, location);
									GetClientEyeAngles(attacker, ang);
									
									location[0] = (location[0]+(50*(Cosine(DegToRad(ang[1])))));
									location[1] = (location[1]+(50*(Sine(DegToRad(ang[1])))));
									
									new ticktime = RoundToNearest(  GetGameTime() / GetTickInterval()) + 5;
									
									decl i;
									for(i = 0; i < 8; i++)
									{
										new zombie = CreateEntityByName("infected");
										SetEntityModel(zombie, "models/infected/common_male_jimmy.mdl");
										
										SetEntProp(zombie, Prop_Data, "m_nNextThinkTick", ticktime);
										CreateTimer(0.1, TimerSetMobRush, zombie);
										
										DispatchSpawn(zombie);
										ActivateEntity(zombie);
										location[0] += 10.0;
										TeleportEntity(zombie, location, NULL_VECTOR, NULL_VECTOR);
										
										
									}
									
									
									
									/*
									delete g_hTimer_ResetInfectedCull;									
									g_hTimer_ResetInfectedCull = CreateTimer(20.0, TimerResetInfectedCull);*/
								}
								else	//If their not alive then give them another reward
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. Common Infected temporarily do more damage.", attacker);
									g_bCommonInfectedDoMoreDamage = true;
									CreateTimer(20.0, TimerResetZombieDamage, 0, TIMER_FLAG_NO_MAPCHANGE);
								}
							}
						}
					}
				g_iVomitVictimCounter[attacker] = -10;	//Set it to this so that they cant get it more than 1 time per vomit, if they hit 6 survivors
			}
			if(g_bNowCountingVomitVictims[attacker] == false)
			{
				g_bNowCountingVomitVictims[attacker] = true;
				CreateTimer(9.0, TimerStopItCounting, attacker, TIMER_FLAG_NO_MAPCHANGE);
			}
			decl rand;
			rand = GetRandomInt(1, 100);
			if(rand <= (g_iNorovirusLevel[attacker] * 4))
			{
				CreateParticle("boomer_vomit", 2.0, victim, ATTACH_MOUTH, true);
				g_bIsSurvivorVomiting[victim] = true;
				g_iShowSurvivorVomitCounter[victim] = 3;
				CreateTimer(1.0, TimerConstantVomitDisplay, victim, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	return;
}

public Action:Event_ChargerChargeStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	
	g_bIsChargerCharging[attacker] = true;
	
	if(g_bIsSuperCharger[attacker] == true)
	{
		//SetEntDataFloat(attacker , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iSpikedLevel[attacker] * 0.10) + (g_iHillbillyLevel[attacker] * 0.06)), true);
		g_fClientSpeedBoost[attacker] += (g_iSpikedLevel[attacker] * 0.10);
		fnc_SetClientSpeed(attacker);
		g_iClientBindUses_1[attacker]++;
	}
	
	return Plugin_Continue;
}


public Action:Event_ChargerChargeEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	
	g_bIsChargerCharging[attacker] = false;
	
	if(g_iHillbillyLevel[attacker] > 0)
		CreateTimer(1.0, TimerSetChargerCooldown, attacker,  TIMER_FLAG_NO_MAPCHANGE);
		
	if(g_bIsSuperCharger[attacker] == true)
	{
		g_bIsSuperCharger[attacker] = false;
		CreateTimer(30.0, TimerResetSuperCharge, attacker,  TIMER_FLAG_NO_MAPCHANGE);
		//SetEntDataFloat(attacker , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iHillbillyLevel[attacker] * 0.03)), true);
		g_fClientSpeedBoost[attacker] -= (g_iSpikedLevel[attacker] * 0.10);
		fnc_SetClientSpeed(attacker);
	}

	return Plugin_Continue;
}

public Action:Event_ChargerImpact(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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
public Action:Event_ChargerCarryStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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

public Action:Event_ChargerCarryEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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

public Action:Event_ChargerPummelStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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

public Action:Event_ChargerPummelEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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

public Action:Event_ChargerKilled(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//new attacker = GetClientOfUserId(GetEventInt(hEvent,"attacker"));
	new chargerid = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	//PrintToChatAll("Charger Killed %N is no longer charged", g_iChargerVictim[chargerid]);
	//PrintToChat(g_iChargerVictim[chargerid], "Charger Killed: You are no longer charged");
	g_bChargerGrappled[g_iChargerVictim[chargerid]] = false;
	
	return Plugin_Continue;
}

public Action:Event_ChokeStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	if(g_iDirtyLevel[attacker] > 0)
	{
		SetEntityMoveType(attacker, MOVETYPE_ISOMETRIC);
		//Going to avoid using fnc_SetClientSpeed here simply because it would not fit well
		SetEntDataFloat(attacker, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (0.01 * g_iDirtyLevel[attacker]) , true);
		//CreateTimer(0.3, TimerCheckTongueDistance, attacker, TIMER_FLAG_NO_MAPCHANGE);
	}
	
	g_bSmokerGrappled[victim] = true;
	g_iChokingVictim[attacker] = victim;
	fnc_SetRendering(victim);
	return Plugin_Continue;
}

public Action:Event_ChokeEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	SetEntityMoveType(attacker, MOVETYPE_CUSTOM);
	//SetEntDataFloat(attacker , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iNoxiousLevel[attacker] * 0.02)), true);
	fnc_SetClientSpeed(attacker);
	
	g_bSmokerGrappled[victim] = false;
	g_iChokingVictim[attacker] = -1;
	
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

public Action:Event_TongueRelease(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	g_bSmokerGrappled[victim] = false;
	fnc_SetRendering(victim);
	return Plugin_Continue;
}


public Action:Event_TongueGrab(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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


public Action:Event_JockeyRide(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	new	classnum = GetEntProp(attacker, Prop_Send, "m_zombieClass");
	
	GiveClientXP(attacker, 50, g_iSprite_50XP_SI, victim, "Grappled A Survivor.");
	
	if(classnum == JOCKEY)	//If the attacker truely is the JOCKEY(this function is called for more than just JOCKEY for some reason)
	{
		g_iJockeyVictim[attacker] = victim;
		if(g_iClientTeam[victim] == TEAM_SURVIVORS)
		{
			if(g_iStrongLevel[victim] > 0)
			{
				SetEntDataFloat(victim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), ((1.0 + (g_iErraticLevel[attacker] * 0.03)) - ((g_iStrongLevel[victim] * 0.2) + ((g_iErraticLevel[attacker] * 0.03) * (g_iStrongLevel[victim] * 0.2)))), true);
			}
			else if(g_iErraticLevel[attacker] > 0)
			{
				SetEntDataFloat(victim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iErraticLevel[attacker] * 0.03)), true);
			}
			else
			{
				SetEntDataFloat(victim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0, true);
			}
			/*
			g_fClientSpeedBoost[attacker] += (g_iErraticLevel[attacker] * 0.03);
			if(g_iStrongLevel[victim] > 0)
			{
				g_fClientSpeedPenalty[attacker] += (g_iStrongLevel[victim] * 0.2) + (g_iErraticLevel[attacker] * 0.03);
			}
			fnc_SetClientSpeed(attacker);
			*/
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
	g_bJockeyIsRiding[attacker] = true;
	g_bJockeyGrappled[victim] = true;
	g_iJockeysVictim[attacker] = victim;
	fnc_SetRendering(victim);
	return Plugin_Continue;
}


public Action:Event_JockeyRideEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//if TANK spawned in set ELLIS's run speed to 1.5
{
	new rider = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));

	if(g_iMutatedLevel[rider] > 0 && RunClientChecks(rider)  == true && IsPlayerAlive(rider) == true)
		CreateTimer(1.0, TimerSetJockeyCooldown, rider, TIMER_FLAG_NO_MAPCHANGE);
	
	g_iJockeyVictim[rider] = -1;
	g_bJockeyIsRiding[rider] = false;
	g_bJockeyGrappled[victim] = false;
	fnc_SetClientSpeed(victim);
	//ResetSurvivorSpeed(victim);
	fnc_SetRendering(victim);
	return Plugin_Continue;
}


public Action:Event_HunterPounceStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	g_iHunterPounceDistance[attacker] = GetEventInt(hEvent, "distance");
	// PrintToChatAll("Distance: %i", g_iHunterPounceDistance[attacker]);
	g_bHunterGrappled[victim] = true;
	g_iHunterShreddingVictim[attacker] = victim;
	SetEntDataFloat(victim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.0, true);
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
							
							fnc_SetClientSpeed(victim);
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

public Action:Event_HunterPounceStopped(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	g_bHunterGrappled[victim] = false;
	g_iHunterShreddingVictim[attacker] = -1;
	
	fnc_SetClientSpeed(victim);
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

public Action:Event_InfectedHurt(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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

public Action:Event_WitchKilled(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new victim = GetEventInt(hEvent, "witchid");
	new instakill = GetEventBool(hEvent, "oneshot");
	if (iClient > 0 && iClient < (MAXPLAYERS + 1))
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


public Action:Event_TankSpawn(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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
						if(g_iTankCounter == 1)
						{
							//SetEntDataFloat(i , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[i] + g_fEllisBringSpeed[i] + g_fEllisOverSpeed[i]), true);
							g_fClientSpeedBoost[i] += (g_iJamminLevel[i] * 0.04);
							fnc_SetClientSpeed(i);
							//DeleteCode
							//PrintToChatAll("Tank has spawned, now setting g_fEllisJamminSpeed");
							//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[i]);
							//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[i]);
							//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[i]);
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

public Action:Event_ZombieIgnited(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new victim = GetEventInt(hEvent, "entityid");
	
	if (iClient > 0 && iClient < (MAXPLAYERS + 1))
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

public Action:Event_SpitBurst(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
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
			/*decl i;
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
				
				TeleportEntity(zombie, position, NULL_VECTOR, NULL_VECTOR);
			}*/
			
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

public Action:Event_WitchSpawn(Handle:hEvent, const String:sName[], bool:bDontBroadcast)
{
	new iWitchID = GetEventInt(hEvent, "witchid");
	
	new bool:bOwnerFound = false;
	decl iClient;
	for(iClient = 1; iClient < MaxClients; iClient++)
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

public Action:Timer_CheckWitchRage(Handle:timer, any:iWitchID)
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

public Action:Event_GhostSpawnTime(Handle:hEvent, const String:sName[], bool:bDontBroadcast)
{
	new iSpawner = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	new Float:fSpawnTime = GetEventFloat(hEvent, "spawntime");
	//PrintToChatAll("Spawn Time = %f", fSpawnTime);
	CreateTimer(fSpawnTime + 0.5, TimerSpawnGhostClass, iSpawner, TIMER_FLAG_NO_MAPCHANGE);
}

public Action:Event_EnteredSpit(Handle:hEvent, const String:sName[], bool:bDontBroadcast)
{
	//new userid = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	//new subject = GetEventInt(hEvent,"subject");
	// PrintToChatAll("Entered Spit, userid = %i", userid);
	// PrintToChatAll("Entered Spit, subject = %i", subject);
}