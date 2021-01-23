Action:Event_PlayerHurt(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"attacker"));
	new victim  = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	if(victim < 1)
		return Plugin_Continue;

	new dmgHealth  = GetEventInt(hEvent,"dmg_health");
	new dmgType = GetEventInt(hEvent, "type");
	//new hitGroup = GetEventInt(hEvent, "hitgroup");

	//PrintToChatAll("Attacker = %d, Victim = %d, dmgHealth = %d, dmgType = %d, hitGroup = %d", attacker, victim, dmgHealth, dmgType, hitGroup);
	//PrintToChatAll("%N dType = %d, Group = %d, dHealth = %d", victim, dmgType, hitGroup, dmgHealth);
	// PrintToChatAll("g_iInfectedCharacter[attacker] = %s", g_iInfectedCharacter[attacker]);
	//decl String:testweapon[32];
	//GetEventString(hEvent,"weapon", testweapon, 32);
	//PrintToChatAll("\x03-weapon: \x01%s, dmgHealth: %i",testweapon, dmgHealth);
		
	// Unfreeze player if they take any damage
	if(g_iClientTeam[victim] == TEAM_SURVIVORS && g_bFrozenByTank[victim] == true)
	{
		//Set Player Velocity To Zero
		TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, EMPTY_VECTOR);
		
		UnfreezePlayerByTank(victim);
	}
	
	//Prevent Damage or Add Damage
	if(g_iClientTeam[victim] == TEAM_SURVIVORS)
	{
		if(g_iChosenSurvivor[victim] == ELLIS)
		{
			if(g_iFireLevel[victim] > 0)
			{
				//Prevent Fire Damage
				if(dmgType == DAMAGETYPE_FIRE1 || dmgType == DAMAGETYPE_FIRE2)
				{
					//PrintToChat(victim, "Prevent fire damage");
					new currentHP = GetEventInt(hEvent,"health");
					SetEntProp(victim,Prop_Data,"m_iHealth", dmgHealth + currentHP);
				}
			}
			if(g_iOverLevel[victim] > 0)
			{
				new iCurrentHealth = GetEntProp(victim,Prop_Data,"m_iHealth");
				new iMaxHealth = GetEntProp(victim,Prop_Data,"m_iMaxHealth");
				//new Float:fTempHealth = GetEntDataFloat(victim, g_iOffset_HealthBuffer);
				//if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - 20.0))
				if(iCurrentHealth < (iMaxHealth - 20.0))
				{
					if(g_bEllisOverSpeedIncreased[victim])
					{
						g_bEllisOverSpeedIncreased[victim] = false;

						SetClientSpeed(victim);
					}
				}
				//else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
				else if(iCurrentHealth >= (iMaxHealth - 20.0))
				{
					if(g_bEllisOverSpeedIncreased[victim] == false)
					{
						g_bEllisOverSpeedIncreased[victim] = true;

						SetClientSpeed(victim);						
					}
				}
			}
		}
	}
	else if(g_iClientTeam[victim] == TEAM_INFECTED)
	{
		if(g_iInfectedCharacter[victim] == TANK)
		{
			EventsHurt_TankVictim(hEvent, attacker, victim, dmgType, dmgHealth);
		}
	}

	EventsHurt_GiveXP(hEvent, attacker, victim);
	
	EventsHurt_IncreaseCommonInfectedDamage(attacker, victim);

	//If attacker is a Common Infected, do not continue
	if(attacker < 1)
		return Plugin_Continue;
	
	
	if(g_iClientTeam[attacker] == TEAM_SURVIVORS)
	{
		if(g_iClientTeam[victim] == TEAM_INFECTED)//////////////////////////////////////////////////////////////////////
		switch(g_iChosenSurvivor[attacker])
		{
			case BILL:
			{
				if(g_iExorcismLevel[attacker]!=0 || g_iPromotionalLevel[attacker]!=0)
				{
					if(g_iClientTeam[victim] == TEAM_INFECTED)
					{
						decl String:weaponclass[32];
						GetEventString(hEvent,"weapon",weaponclass,32);
						//PrintToChat(attacker, "weaponclass = %s", weaponclass);
						if(StrContains(weaponclass,"rifle",false) != -1)
						{
							if(StrContains(weaponclass,"rifle_m60",false) == -1)
							{
								if(StrContains(weaponclass,"hunting_rifle",false) == -1)
								{
									new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
									new dmg = GetEventInt(hEvent,"dmg_health");
									dmg = RoundToNearest(dmg * (g_iExorcismLevel[attacker] * 0.04));
									//PrintToChat(attacker, "Your doing %d extra rifle damage", dmg);
									SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
								}
							}
							else
							{
								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
								new dmg = GetEventInt(hEvent,"dmg_health");
								dmg = RoundToNearest(dmg * (g_iPromotionalLevel[attacker] * 0.20));
								//PrintToChat(attacker, "Your doing %d extra M60 damage", dmg);
								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
							}
						}
					}
				}
			}
			case ROCHELLE:
			{
				if(g_iHunterLevel[attacker] > 0)
				{
					if(g_iClientTeam[victim] == TEAM_INFECTED)
						if(g_bIsRochellePoisoned[victim] == false)	//If player not g_bIsRochellePoisoned poison them
						{
							g_bIsRochellePoisoned[victim] = true;
							
							g_iSlapRunTimes[victim] = 5 - g_iHunterLevel[attacker];

							delete g_hTimer_RochellePoison[victim];
							g_hTimer_RochellePoison[victim] = CreateTimer(5.0, TimerPoison, victim, TIMER_REPEAT);

							g_iPID_RochellePoisonBullet[victim] = WriteParticle(victim, "poison_bullet", 0.0);
							CreateTimer(30.1, DeleteParticle, g_iPID_RochellePoisonBullet[victim], TIMER_FLAG_NO_MAPCHANGE);
							
							if(IsFakeClient(victim)==false)
								ShowHudOverlayColor(victim, 0, 100, 0, 40, 8000, FADE_IN);
							
							PrintHintText(attacker,"You poisoned %N", victim);
						}
				}
				if(g_iSilentLevel[attacker] >0)
				{
					if(g_iClientTeam[victim] == TEAM_INFECTED)
					{
						decl String:weaponclass[32];
						GetEventString(hEvent,"weapon",weaponclass,32);
						//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
						if(StrContains(weaponclass,"hunting_rifle",false) != -1)	//Rugar
						{
							new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
							new dmg = GetEventInt(hEvent,"dmg_health");
							dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.13));
							//PrintToChat(attacker, "your doing %d hunting rifle damage", dmg);
							SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);

						}
						else if(StrContains(weaponclass,"sniper_military",false) != -1)	//H&K MSG 90
						{
							IgniteEntity(victim, 5.0, false);
							new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
							new dmg = GetEventInt(hEvent,"dmg_health");
							dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.08));
							//PrintToChat(attacker, "your doing %d sniper_military damage", dmg);
							SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);

						}
						else if(StrContains(weaponclass,"sniper_scout",false) != -1)
						{
							new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
							new dmg = GetEventInt(hEvent,"dmg_health");
							dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.13)) + (g_iSilentSorrowHeadshotCounter[attacker] * g_iSilentLevel[attacker] * 3);
							//PrintToChat(attacker, "your doing %d scout damage", dmg);
							SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);

						}
						else if(StrContains(weaponclass,"sniper_awp",false) != -1)
						{
							new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
							new dmg = GetEventInt(hEvent,"dmg_health");
							dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.40) );
							PrintToChat(attacker, "your doing %d extra awp damage", dmg);
							SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
						}
					}
				}
			}
			case COACH:
			{
				if(g_iClientTeam[victim] == TEAM_INFECTED)
				{
					if(g_iMeleeDamageCounter[attacker]>0 || g_iSprayLevel[attacker]>0 || g_bIsWreckingBallCharged[attacker]==true || g_bCoachRageIsActive[attacker] == true)
					{
						decl String:weaponclass[32];
						GetEventString(hEvent,"weapon",weaponclass,32);
						//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
						if(StrContains(weaponclass,"melee",false) != -1)
						{
							if(g_bIsWreckingBallCharged[attacker]==true)
							{
								if(g_iWreckingLevel[attacker] == 5)
								{
									g_bWreckingChargeRetrigger[attacker] = true;
									//PrintToChatAll("Wrecking Ball Retrigger = true");
								}
								g_bIsWreckingBallCharged[attacker] = false;
								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
								//new dmg = GetEventInt(hEvent,"dmg_health");
								//PrintToChat(attacker, "predmg = %d", dmg);
								//dmg = (g_iWreckingLevel[attacker]*200) + (g_iMeleeDamageCounter[attacker]);
								CreateTimer(0.1, DeleteParticle, g_iPID_CoachMeleeCharge1[attacker], TIMER_FLAG_NO_MAPCHANGE);
								CreateTimer(0.1, DeleteParticle, g_iPID_CoachMeleeCharge2[attacker], TIMER_FLAG_NO_MAPCHANGE);
								//PrintToChat(attacker, "\x03[XPMod] \x05You did %d extra CHARGED melee damage", ((g_iWreckingLevel[attacker]*100) + (g_iMeleeDamageCounter[attacker])));
								new Float:vec[3];
								GetClientAbsOrigin(attacker, vec);
								EmitSoundToAll(SOUND_COACH_CHARGE_HIT, attacker, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
								//CreateParticle("coach_melee_charge_splash", 0.0, attacker, NO_ATTACH);
								WriteParticle(victim, "coach_melee_charge_splash", 3.0);
								SetEntProp(victim,Prop_Data,"m_iHealth", hp - ((g_iWreckingLevel[attacker]*100) + g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
							}
							else if(g_iMeleeDamageCounter[attacker]>0)
							{
								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
								//new dmg = GetEventInt(hEvent,"dmg_health");
								//PrintToChat(attacker, "predmg = %d", dmg);
								//dmg = g_iMeleeDamageCounter[attacker];
								PrintToChat(attacker, "\x03[XPMod] \x05You did %d extra melee damage", (g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
								SetEntProp(victim,Prop_Data,"m_iHealth", hp - (g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
							}
							else if(g_bCoachRageIsActive[attacker] == true)
							{
								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
								PrintToChat(attacker, "\x03[XPMod] \x05You did %d extra melee damage", g_iCoachRageMeleeDamage[attacker]);
								SetEntProp(victim,Prop_Data,"m_iHealth", hp - g_iCoachRageMeleeDamage[attacker]);
							}
						}
						if(g_iSprayLevel[attacker]>0)
							if(StrContains(weaponclass,"shotgun",false) != -1)
							{
								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
								//new dmg = GetEventInt(hEvent,"dmg_health");
								//dmg = dmg + (g_iSprayLevel[attacker] * 2);
								//PrintToChat(attacker, "your doing %d shotgun damage", (g_iSprayLevel[attacker] * 2));
								SetEntProp(victim,Prop_Data,"m_iHealth", hp - (g_iSprayLevel[attacker] * 2));
							}
					}
				}
			}
			case ELLIS:
			{
				if(g_iFireLevel[attacker]>0)
				{
					if(g_iClientTeam[victim] == TEAM_INFECTED)
					{
						if(g_bUsingFireStorm[attacker]==true)
						{
							new Float:time = (float(g_iFireLevel[attacker]) * 6.0);
							IgniteEntity(victim, time, false);
						}
					}
				}
				if(g_iOverLevel[attacker] > 0)
				{
					if(g_iClientTeam[victim] == TEAM_INFECTED)
					{
						new iCurrentHealth = GetEntProp(attacker,Prop_Data,"m_iHealth");
						new iMaxHealth = GetEntProp(attacker,Prop_Data,"m_iMaxHealth");
						new Float:fTempHealth = GetEntDataFloat(attacker, g_iOffset_HealthBuffer);
						if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
						{
							decl String:weaponclass[32];
							GetEventString(hEvent,"weapon",weaponclass,32);
							//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
							if((StrContains(weaponclass,"shotgun",false) != -1) || (StrContains(weaponclass,"rifle",false) != -1) || (StrContains(weaponclass,"pistol",false) != -1) || (StrContains(weaponclass,"smg",false) != -1) || (StrContains(weaponclass,"sniper",false) != -1) || (StrContains(weaponclass,"launcher",false) != -1))
							{
								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
								new dmg = GetEventInt(hEvent,"dmg_health");
								new newdmg = (dmg + (g_iOverLevel[attacker] * 2));
								SetEntProp(victim,Prop_Data,"m_iHealth", hp - newdmg);
								//DeleteCode
								//PrintToChatAll("Ellis is doing %d damage", dmg);
								//PrintToChatAll("Ellis is doing %d additional damage", (newdmg - dmg));
							}
						}
					}
				}
			}
			case NICK:
			{
				if(g_iSwindlerLevel[attacker] > 0)
				{
					if(g_iClientTeam[victim] == TEAM_INFECTED)
						if(g_bNickIsStealingLife[victim][attacker] == false)	//If player not poisoned, poison them
						{
							g_bNickIsStealingLife[victim][attacker] = true;
							
							new Handle:lifestealingpackage = CreateDataPack();
							WritePackCell(lifestealingpackage, victim);
							WritePackCell(lifestealingpackage, attacker);
							g_iNickStealingLifeRuntimes[victim] = 0;

							delete g_hTimer_NickLifeSteal[victim];
							g_hTimer_NickLifeSteal[victim] = CreateTimer(2.0, TimerLifeStealing, lifestealingpackage, TIMER_REPEAT);
							
							decl Float:vec[3];
							GetClientAbsOrigin(victim, vec);
							EmitSoundToAll(SOUND_NICK_LIFESTEAL_HIT, victim, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
						}
				}
				if(g_iDesperateLevel[attacker] > 0 && g_iNickDesperateMeasuresStack > 0)
				{
					decl String:weaponclass[32];
					GetEventString(hEvent,"weapon",weaponclass,32);
					
					if(StrContains(weaponclass,"melee",false) == -1 && StrContains(weaponclass,"inferno",false) == -1 && 
						StrContains(weaponclass,"pipe_bomb",false) == -1 && StrContains(weaponclass,"entityflame",false) == -1)
					{
						new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
						new dmg = GetEventInt(hEvent,"dmg_health");
						if(g_iNickDesperateMeasuresStack > 3)
						{
							dmg = RoundToNearest(dmg * (g_iDesperateLevel[attacker] * 0.05) * 3);
						}
						else
						{
							dmg = RoundToNearest(dmg * (g_iDesperateLevel[attacker] * 0.05) * g_iNickDesperateMeasuresStack);
						}
						PrintToChat(attacker, "You are doing %d extra damage", dmg);
						SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
					}
				}
				if(g_iMagnumLevel[attacker] > 0 || g_iRiskyLevel[attacker] > 0)
				{
					if(g_iClientTeam[victim] == TEAM_INFECTED)
					{
						decl String:wclass[32];
						GetEventString(hEvent,"weapon",wclass,32);
						if (StrContains(wclass,"magnum",false) != -1)
						{
							new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
							new dmg = GetEventInt(hEvent,"dmg_health");
							dmg = RoundToNearest(dmg * (g_iMagnumLevel[attacker] * 0.75));
							//PrintToChat(attacker, "your doing %d extra magnum damage", dmg);
							SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
						}
						else if (StrContains(wclass,"pistol",false) != -1)
						{
							new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
							new dmg = GetEventInt(hEvent,"dmg_health");
							dmg = RoundToNearest(dmg * (g_iRiskyLevel[attacker] * 0.2));
							//PrintToChat(attacker, "your doing %d extra damage", dmg);
							SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
						}
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
		
		switch(g_iInfectedCharacter[victim])
		{
			// case SMOKER: 	EventsHurt_SmokerVictim(hEvent, attacker, victim);
			// case BOOMER: 	EventsHurt_BoomerVictim(hEvent, attacker, victim);
			case HUNTER: 	EventsHurt_HunterVictim(hEvent, attacker, victim);
			// case SPITTER: 	EventsHurt_SpitterVictim(hEvent, attacker, victim);
			// case JOCKEY:	EventsHurt_JockeyVictim(hEvent, attacker, victim);
			case CHARGER:	EventsHurt_ChargerVictim(hEvent, attacker, victim);
			// case TANK: 		EventsHurt_TankVictim(hEvent, attacker, victim, dmgType, dmgHealth);
		}
	}
	else if(g_iClientTeam[attacker] == TEAM_INFECTED && g_iClientTeam[victim] == TEAM_SURVIVORS)
	{
		switch(g_iInfectedCharacter[attacker])
		{
			case SMOKER: 	EventsHurt_SmokerAttacker(hEvent, attacker, victim);
			// case BOOMER: 	EventsHurt_BoomerAttacker(hEvent, attacker, victim);
			case HUNTER: 	EventsHurt_HunterAttacker(hEvent, attacker, victim);
			case SPITTER: 	EventsHurt_SpitterAttacker(hEvent, attacker, victim);
			case JOCKEY:	EventsHurt_JockeyAttacker(hEvent, attacker, victim);
			case CHARGER:	EventsHurt_ChargerAttacker(hEvent, attacker, victim);
			case TANK: 		EventsHurt_TankAttacker(hEvent, attacker, victim, dmgType, dmgHealth);
		}
	}
	
	if (IsFakeClient(attacker) == false && 
		attacker != victim && 
		g_iClientTeam[attacker] == g_iClientTeam[victim])
	{
		if(g_iClientXP[attacker] > g_iClientPreviousLevelXPAmount[attacker])
		{
			g_iClientXP[attacker] -= 2;
			PrintCenterText(attacker, "Attacked Team. -2 XP");
		}
	}
	
	return Plugin_Continue;
}

EventsHurt_GiveXP(Handle:hEvent, attacker, victim)
{
	new dmgType = GetEventInt(hEvent, "type");

	if (g_iClientTeam[victim] == TEAM_SURVIVORS && 
		g_iClientTeam[attacker] == TEAM_INFECTED && 
		IsClientInGame(attacker) == true && 
		IsFakeClient(attacker) == false)		//Damage XP Give
	{
		decl String:iWeaponClass[32];
		GetEventString(hEvent,"weapon",iWeaponClass,32);
		//PrintToChat(attacker, "weaponclass = %s", iWeaponClass);
		
		if(dmgType == 263168 || dmgType == 265216)
		{
			g_iClientXP[attacker] += 3;
			CheckLevel(attacker);
			
			if(g_iXPDisplayMode[attacker] == 0)
				ShowXPSprite(attacker, g_iSprite_3XP_SI, victim, 1.0);
		}
		else if((g_iChokingVictim[attacker] > 0 && StrEqual(iWeaponClass, "smoker_claw") == true) ||
			(g_iHunterShreddingVictim[attacker] > 0 && StrEqual(iWeaponClass, "hunter_claw") == true) || 
			(g_iJockeyVictim[attacker] > 0 && StrEqual(iWeaponClass, "jockey_claw") == true))
		{
			g_iClientXP[attacker] += 10;
			CheckLevel(attacker);
			
			if(g_iXPDisplayMode[attacker] == 0)
				ShowXPSprite(attacker, g_iSprite_10XP_SI, victim, 1.0);
		}
		else if(StrEqual(iWeaponClass, "hunter_claw") == true || StrEqual(iWeaponClass, "smoker_claw") == true || StrEqual(iWeaponClass, "jockey_claw") == true || 
				StrEqual(iWeaponClass, "boomer_claw") == true || StrEqual(iWeaponClass, "spitter_claw") == true || StrEqual(iWeaponClass, "charger_claw") == true  || 
				StrEqual(iWeaponClass, "tank_claw") == true ||	StrEqual(iWeaponClass, "tank_rock") == true)
		{
			g_iClientXP[attacker] += 15;
			CheckLevel(attacker);
			
			if(g_iXPDisplayMode[attacker] == 0)
				ShowXPSprite(attacker, g_iSprite_15XP_SI, victim, 1.0);
		}
		
		
		//Limit because some attacks may give too many points
		if(dmgHealth < 750)
			g_iStat_ClientDamageToSurvivors[attacker] += dmgHealth;
		else
			g_iStat_ClientDamageToSurvivors[attacker] += 750;
	}

	if(g_iVomitVictimAttacker[victim] > 0)	//Give Assitance XP for Boomer
	{
		if(IsClientInGame(g_iVomitVictimAttacker[victim]) == true)
			if(IsFakeClient(g_iVomitVictimAttacker[victim]) == false)
			{
				if(dmgHealth < 250)
					g_iStat_ClientDamageToSurvivors[g_iVomitVictimAttacker[victim]] += dmgHealth;
				else
					g_iStat_ClientDamageToSurvivors[g_iVomitVictimAttacker[victim]] += 250;
				
				decl String:iMessage[64];
				Format(iMessage, sizeof(iMessage), "Assited against %N.", victim);
				GiveClientXP(g_iVomitVictimAttacker[victim], 3, g_iSprite_3XP_SI, victim, iMessage, true, 1.0);
			}
	}
}

bool:EventsHurt_IncreaseCommonInfectedDamage(attacker, victim)
{
	if (attacker < 1 && //If attacker is a Common Infected
		g_bCommonInfectedDoMoreDamage == true &&
		g_iClientTeam[victim] == TEAM_SURVIVORS &&
		RunClientChecks(victim) &&
		IsPlayerAlive(victim))	
	{
		new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
		new Float:fTempHealth = GetEntDataFloat(victim, g_iOffset_HealthBuffer);
		if(fTempHealth > 0)
		{
			fTempHealth -= 1.0;
			SetEntDataFloat(victim, g_iOffset_HealthBuffer, fTempHealth ,true);
		}
		else
			SetEntProp(victim,Prop_Data,"m_iHealth", hp - 1);
	}
}