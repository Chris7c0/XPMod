public Action:Event_PlayerHurt(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(hEvent,"attacker"));
	new victim  = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	if(victim < 1)
		return Plugin_Continue;
	new dmgHealth  = GetEventInt(hEvent,"dmg_health");
	//new Float:dmgArmor  = GetEventFloat(hEvent,"dmg_armor");
	
	new dmgType = GetEventInt(hEvent, "type");
	new hitGroup = GetEventInt(hEvent, "hitgroup");
	//PrintToChatAll("Attacker = %d, Victim = %d, dmgHealth = %d, dmgType = %d, hitGroup = %d", attacker, victim, dmgHealth, dmgType, hitGroup);
	//PrintToChatAll("%N dType = %d, Group = %d, dHealth = %d", victim, dmgType, hitGroup, dmgHealth);
	// PrintToChatAll("g_iInfectedCharacter[attacker] = %s", g_iInfectedCharacter[attacker]);
	decl String:testweapon[20];
	GetEventString(hEvent,"weapon", testweapon, 20);
	// PrintToChatAll("Weapon of attacker is %s", testweapon);
		
	//Unfreeze player if they take any damage
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
					if(g_bEllisOverSpeedDecreased[victim] == false)
					{
						g_fClientSpeedBoost[victim] -= (g_iOverLevel[victim] * 0.02);
						fnc_SetClientSpeed(victim);
						g_bEllisOverSpeedDecreased[victim] = true;
						g_bEllisOverSpeedIncreased[victim] = false;
						//g_fEllisOverSpeed[victim] = 0.0;
						//SetEntDataFloat(victim , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[victim] + g_fEllisBringSpeed[victim] + g_fEllisOverSpeed[victim]), true);
						//DeleteCode
						//PrintToChatAll("Hurt, now setting g_fEllisOverSpeed");
						//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[victim]);
						//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[victim]);
						//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[victim]);
					}
				}
				//else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
				else if(iCurrentHealth >= (iMaxHealth - 20.0))
				{
					if(g_bEllisOverSpeedIncreased[victim] == false)
					{
						//g_fEllisOverSpeed[victim] = (g_iOverLevel[victim] * 0.02);
						//SetEntDataFloat(victim , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[victim] + g_fEllisBringSpeed[victim] + g_fEllisOverSpeed[victim]), true);
						g_fClientSpeedBoost[victim] += (g_iOverLevel[victim] * 0.02);
						fnc_SetClientSpeed(victim);
						//DeleteCode
						//PrintToChatAll("Hurt, now setting g_fEllisOverSpeed");
						//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[victim]);
						//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[victim]);
						//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[victim]);
						//CreateTimer(1.0, TimerCheckEllisHealth, victim, TIMER_FLAG_NO_MAPCHANGE);
						g_bEllisOverSpeedIncreased[victim] = true;
						g_bEllisOverSpeedDecreased[victim] = false;
					}
				}
			}
		}
	}
	else if(g_iClientTeam[victim] == TEAM_INFECTED)
	{
		if(g_iInfectedCharacter[victim] == TANK)
		{
			EventsHurt_TankVictim(victim, dmgType, dmgHealth);
		}
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
	if(attacker < 1)	//If attacker is a Common Infected
	{
		if(g_iClientTeam[victim] == TEAM_SURVIVORS)
		{
			if(g_bCommonInfectedDoMoreDamage == true)	//Add damage if supposed to
			{
				if(IsClientInGame(victim))
					if(IsPlayerAlive(victim))
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
		}
		//PrintToChatAll("Exiting, attacker < 1");
		return Plugin_Continue;
	}
	
	if(g_iClientTeam[victim] == TEAM_SURVIVORS && g_iClientTeam[attacker] == TEAM_INFECTED && IsClientInGame(attacker) == true && IsFakeClient(attacker) == false)		//Damage XP Give
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
	
	if(g_iClientTeam[victim] == TEAM_INFECTED)
	{
		//PrintToChatAll("%N: g_iInfectedCharacter = %d", victim, g_iInfectedCharacter[victim]);
		switch(g_iInfectedCharacter[victim])
		{
			case SMOKER:
			{
				
			}
			case BOOMER:
			{
				
			}
			case HUNTER:
			{
				//PrintToChatAll("Hunter Hit");
				if(hitGroup == 0)	//If victim is hunter and has beeen hit with explosive ammo, reset the pounced variables
				{
					//PrintToChatAll("Hunter Hit INSIDE, YAY TACOS");
					g_bHunterGrappled[victim] = false;
					g_iHunterShreddingVictim[attacker] = -1;
					fnc_SetClientSpeed(victim);
					//ResetSurvivorSpeed(victim);
				}
				
				if(g_bIsCloakedHunter[victim] == true)
				{
					//SetEntityRenderMode(victim, RenderMode:3);	probably dont need this
					SetEntityRenderColor(victim, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[victim]) * 0.012) )));
					g_bIsCloakedHunter[victim] = false;
					g_iHunterCloakCounter[victim] = 0;
				}
			}
			case SPITTER:
			{
				
			}
			case JOCKEY:
			{
				
			}
			case CHARGER:
			{
				
			}
			case TANK:
			{
				
			}
		}
	}
	
	if(IsFakeClient(attacker) == false)	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	{
		if(g_iClientTeam[attacker] == TEAM_SURVIVORS)
		{
			if(g_iClientTeam[victim] == TEAM_INFECTED)//////////////////////////////////////////////////////////////////////
			switch(g_iChosenSurvivor[attacker])
			{
				case 0:		//Bill Talents
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
					//return Plugin_Continue;
				}
				case 1:		//Rochelle
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
								//return Plugin_Continue;
							}
							else if(StrContains(weaponclass,"sniper_military",false) != -1)	//H&K MSG 90
							{
								IgniteEntity(victim, 5.0, false);
								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
								new dmg = GetEventInt(hEvent,"dmg_health");
								dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.08));
								//PrintToChat(attacker, "your doing %d sniper_military damage", dmg);
								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
								//return Plugin_Continue;
							}
							else if(StrContains(weaponclass,"sniper_scout",false) != -1)
							{
								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
								new dmg = GetEventInt(hEvent,"dmg_health");
								dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.13)) + (g_iSilentSorrowHeadshotCounter[attacker] * g_iSilentLevel[attacker] * 3);
								//PrintToChat(attacker, "your doing %d scout damage", dmg);
								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
								//return Plugin_Continue;
							}
							else if(StrContains(weaponclass,"sniper_awp",false) != -1)
							{
								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
								new dmg = GetEventInt(hEvent,"dmg_health");
								dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.40) );
								PrintToChat(attacker, "your doing %d extra awp damage", dmg);
								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
								//return Plugin_Continue;
							}
						}
					}
				}
				case 2:		//Coach
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
						//return Plugin_Continue;
					}
				}
				case 3:		//Ellis Talents
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
					/*
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
								//return Plugin_Continue;
							}
					*/
				}
				case 4:		//Nick Talents
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
					if(g_iMagnumLevel[attacker]>0 || g_iRiskyLevel[attacker]>0)
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
							//return Plugin_Continue;
						}
					}
					/*
					if(g_iMagnumLevel[attacker] == 5)
					{
						if(g_iClientTeam[victim] == TEAM_INFECTED)
						{
							GetClientWeapon(attacker, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
							if(StrEqual(g_strCurrentWeapon, "weapon_pistol_magnum", false) == true)
							{
								g_iNickMagnumShotCount[attacker]++;
								//PrintToChatAll("g_iNickMagnumShotCount = %d", g_iNickMagnumShotCount[attacker]);
								if(g_iNickMagnumShotCount[attacker] == 3)
								{
									//PrintToChatAll("Nick Magnum Count = 3, stampede reload = true");
									g_bCanNickStampedeReload[attacker] = true;
								}
							}
						}
					}
					*/
				}
			}
			switch(g_iInfectedCharacter[victim])
			{
				case 1: //SMOKER
				{
					
				}
				case 2: //BOOMER
				{
					
				}
				case 3: //HUNTER
				{
					
				}
				case 4: //SPITTER
				{
					
				}
				case 5: //JOCKEY
				{
					
				}
				case 6: //CHARGER
				{
					if(g_iSpikedLevel[victim] > 0)
					{
						decl String:weapon[20];
						GetEventString(hEvent, "weapon", weapon, 20);
						
						if(StrEqual(weapon, "melee") == true)
						{
							decl iDamage;
							iDamage = g_iSpikedLevel[victim];
							DealDamage(attacker, victim, iDamage);
						}
						
						if(g_iHillbillyLevel[victim] > 0)
						{
							if(g_bChargerCarrying[victim] == true)
							{
								new iCurrentHP = GetEntProp(victim, Prop_Data, "m_iHealth");
								SetEntProp(victim, Prop_Data, "m_iHealth", iCurrentHP + dmgHealth + RoundToNearest(dmgHealth * g_iHillbillyLevel[victim] * 0.05));
								
								//Add particle effect here later since Charger glow and color cannot be changed
								
								if(g_bIsChargerHealing[victim] == false)
								{
									//g_bIsChargerHealing[victim] = true;
									//SetEntityRenderMode(victim, RenderMode:0);
									//SetEntityRenderColor(victim, 1, 1, 255, 254);
									CreateTimer(0.1, TimerResetChargerHealingColor, victim,  TIMER_FLAG_NO_MAPCHANGE);
									SetEntProp(victim, Prop_Send, "m_iGlowType", 2);
									SetEntProp(victim, Prop_Send, "m_nGlowRange", 0);
									SetEntProp(victim, Prop_Send, "m_glowColorOverride", 52000);
								}
							}
						}
					}
				}
				case 8: //TANK
				{
					
				}
			}
		}
		else if(g_iClientTeam[attacker] == TEAM_INFECTED)
		{
			if(g_iClientTeam[victim] == TEAM_SURVIVORS)
				switch(g_iInfectedCharacter[attacker])
				{
					case 1: //SMOKER
					{
						decl String:weapon[20];
						GetEventString(hEvent,"weapon", weapon,20);
						if(StrEqual(weapon, "smoker_claw") == true)
						{
							if(g_iDirtyLevel[attacker] > 0)
							{
								if(g_bIsSmokeInfected[victim] == false)
								{
									CreateParticle("bug_zapper_fly_cloud", 20.0, victim, ATTACH_MOUTH, true);
									CreateParticle("bug_zapper_fly_cloud", 20.0, victim, ATTACH_MOUTH, true);
									CreateParticle("bug_zapper_fly_cloud", 20.0, victim, ATTACH_MOUTH, true);
									//CreateParticle("smoke_gib_01", 10.0, iClient, ATTACH_MOUTH, true, 0.0, 0.0, -5.0);
									//CreateParticle("smoker_spore_attack", 20.0, victim, ATTACH_NORMAL, true);
									
									
									new Float:vec[3];
									GetClientEyePosition(victim, vec);
									
									//Play fly sounds
									//EmitSoundToAll(SOUND_FLIES, victim, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
									
									vec[2] -= 25.0;
									
									new smoke = CreateEntityByName("env_smokestack");
														
									new String:clientName[128], String:vecString[32];
									Format(clientName, sizeof(clientName), "Smoke%i", victim);
									Format(vecString, sizeof(vecString), "%f %f %f", vec[0], vec[1], vec[2]);
									
									DispatchKeyValue(smoke,"targetname", clientName);
									DispatchKeyValue(smoke,"Origin", vecString);
									DispatchKeyValue(smoke,"BaseSpread", "0");		//Gap in the middle
									DispatchKeyValue(smoke,"SpreadSpeed", "100");	//Speed the smoke moves outwards
									DispatchKeyValue(smoke,"Speed", "80");			//Speed the smoke moves up
									DispatchKeyValue(smoke,"StartSize", "100");
									DispatchKeyValue(smoke,"EndSize", "100");
									DispatchKeyValue(smoke,"Rate", "20");			//Amount of smoke created
									DispatchKeyValue(smoke,"JetLength", "100");		//Smoke jets outside of the original
									DispatchKeyValue(smoke,"Twist", "10"); 			//Amount of global twisting
									//DispatchKeyValue(smoke,"RenderColor", "200 200 40");
									DispatchKeyValue(smoke,"RenderColor", "50 130 1");
									DispatchKeyValue(smoke,"RenderAmt", "255");		//Transparency
									DispatchKeyValue(smoke,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");		//THIS WAS CHANGED FROM THE PRECACHED TO SEE HOW IT IS
									
									DispatchSpawn(smoke);
									AcceptEntityInput(smoke, "TurnOn");
									g_bIsSmokeInfected[victim] = true;
									g_iSmokerInfectionCloudEntity[victim] = smoke;
									CreateTimer(0.1, TimerMoveSmokePoof1, victim, TIMER_FLAG_NO_MAPCHANGE);
									CreateTimer(20.0, TimerStopInfection, victim, TIMER_FLAG_NO_MAPCHANGE);
								}
							}
						}
					}
					case 2: //BOOMER
					{
						
					}
					case 3: //HUNTER
					{
						decl String:weapon[20];
						GetEventString(hEvent,"weapon", weapon,20);
						if(StrEqual(weapon,"hunter_claw") == true)
						{
							if(g_bIsHunterReadyToPoison[attacker])
							{
								if(g_bIsHunterPoisoned[victim] == false)	//If player not g_bIsRochellePoisoned poison them
								{
									g_bIsHunterPoisoned[victim] = true;
									g_iClientBindUses_2[attacker]++;

									new Handle:hunterpoisonpackage = CreateDataPack();
									WritePackCell(hunterpoisonpackage, victim);
									WritePackCell(hunterpoisonpackage, attacker);
									g_iHunterPoisonRuntimesCounter[victim] = g_iKillmeleonLevel[attacker];
									g_bHunterLethalPoisoned[victim] = true;

									delete g_hTimer_HunterPoison[victim];
									g_hTimer_HunterPoison[victim] = CreateTimer(1.0, TimerHunterPoison, hunterpoisonpackage, TIMER_REPEAT);
									//CreateTimer(20.0, TimerContinuousHunterPoison, hunterpoisonpackage, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
									if(IsFakeClient(victim)==false)
										PrintHintText(victim, "\%N has injected venom into your flesh", attacker);
									PrintHintText(attacker, "You poisoned %N, You have enough venom for %d more injections.", victim, (3 - g_iClientBindUses_2[attacker]) );
									SetEntDataFloat(victim, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.25, true);
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
								//new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
								//new dmg = GetEventInt(hEvent,"dmg_health");
								decl dmg;
								if(g_iBloodlustLevel[attacker] < 5)
									dmg = 1;
								else if(g_iBloodlustLevel[attacker] < 9)
									dmg = 2;
								else
									dmg = 3;
								DealDamage(victim, attacker, dmg);
								//if((hp - dmg) > 1)
								//	SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
								new hp = GetEntProp(attacker,Prop_Data,"m_iHealth");
								new maxHP = GetEntProp(attacker,Prop_Data,"m_iHealth");
								if((hp + (g_iBloodlustLevel[attacker] * 3)) < (maxHP * 2))
									SetEntProp(attacker,Prop_Data,"m_iHealth", hp + (g_iBloodlustLevel[attacker] * 3));
								else
									SetEntProp(attacker,Prop_Data,"m_iHealth", (maxHP * 2));
							}
						}
					}
					case 4: //SPITTER
					{
						if(g_iPuppetLevel[attacker] > 0)
						{
							decl String:weapon[20];
							GetEventString(hEvent,"weapon", weapon, 20);
							if(StrEqual(weapon,"insect_swarm") == true)
							{
								DealSpecialSpitterGooCollision(attacker, victim, dmgHealth);
								
								if(g_iMaterialLevel[attacker] > 0 && GetEntProp(victim, Prop_Send, "m_isIncapacitated") != 0)
								{
									if (g_hTimer_ResetGlow[victim] == null)
									{
										SetEntProp(victim, Prop_Send, "m_iGlowType", 3);
										SetEntProp(victim, Prop_Send, "m_nGlowRange", 0);
										SetEntProp(victim, Prop_Send, "m_glowColorOverride", 1);
										SetEntityRenderMode(victim, RenderMode:3);
										SetEntityRenderColor(victim, 255, 255, 255, 255 - RoundToNearest(255.0 * 0.1 * g_iMaterialLevel[attacker]));
									}
									


									delete g_hTimer_ResetGlow[victim];
									g_hTimer_ResetGlow[victim] = CreateTimer(3.0, Timer_ResetGlow, victim);
								}
							}
							else if(g_bIsHallucinating[victim] == false && StrEqual(weapon,"spitter_claw") == true)
							{
								if(IsFakeClient(victim) == false)
									PrintHintText(victim, "A Spitter's hallucinogenic toxin seeps through your viens"); 
								
								g_bIsHallucinating[victim] = true;
								g_iHallucinogenRuntimesCounter[victim] = 0;
								WriteParticle(victim, "hallucinogenic_effect", 0.0, 30.0);
								
								delete g_hTimer_HallucinatePlayer[victim];
								g_hTimer_HallucinatePlayer[victim] = CreateTimer(2.5, TimerHallucinogen, victim, TIMER_REPEAT);
							}
						}
					}
					case 5: //JOCKEY
					{
						if(g_iMutatedLevel[attacker] > 0)
						{
							if(g_iJockeyVictim[attacker] < 0) //If they are not riding a victim
							{
								decl String:weapon[20];
								GetEventString(hEvent,"weapon", weapon,20);
								if(StrEqual(weapon,"jockey_claw") == true)
								{
									decl dmg;
									if(g_iMutatedLevel[attacker] < 5)
										dmg = 1;
									else if(g_iMutatedLevel[attacker] < 9)
										dmg = 2;
									else
										dmg = 3;
										
									new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
									if(hp > dmg)
										DealDamage(victim, attacker, dmg);
								}
							}
						}
						if(g_iErraticLevel[attacker] > 0)
						{
							if(g_iJockeyVictim[attacker] > 0)	//If they ARE riding a victim
							{
								decl String:weapon[20];
								GetEventString(hEvent,"weapon", weapon,20);
								if(StrEqual(weapon,"jockey_claw") == true)
								{
									decl dmg;
									if(g_iMutatedLevel[attacker] < 5)
										dmg = 1;
									else if(g_iMutatedLevel[attacker] < 9)
										dmg = 2;
									else
										dmg = 3;
									//hp = GetEntProp(victim,Prop_Data,"m_iHealth");
									//PrintToChat(attacker, "pre hp = %d riding",hp);
									new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
									if(hp > dmg)
										DealDamage(victim, attacker, dmg);
									//hp = GetEntProp(victim,Prop_Data,"m_iHealth");
									//PrintToChat(attacker, "    post hp = %d riding",hp);
								}
							}
						}
					}
					case 6: //CHARGER
					{
						if(g_iGroundLevel[attacker] > 0)
						{
							decl String:weapon[20];
							GetEventString(hEvent,"weapon", weapon,20);
							new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
							if(StrEqual(weapon,"charger_claw") == true)
							{
								decl dmg;
								if(g_iGroundLevel[attacker] < 4)
									dmg = 1;
								else if(g_iGroundLevel[attacker] < 7)
									dmg = 2;
								else if(g_iGroundLevel[attacker] < 10)
									dmg = 3;
								else
									dmg = 4;
								if(hp > dmg)
									DealDamage(victim, attacker, dmg);
							}
							if(g_bIsSpikedCharged[attacker] == true)
							{
								if(g_iChargerVictim[attacker] <= 0 && g_bIsChargerCharging[attacker] == false)
								{
									if(StrEqual(weapon,"charger_claw") == true)
									{
										if(GetEntProp(victim, Prop_Send, "m_isIncapacitated") == 0)
										{												
											decl Float: addAmount[3];
											new Float:power = 577.0;

											addAmount[0] = 0.0;
											addAmount[1] = 0.0;
											addAmount[2] = power;
											
											SDKCall(g_hSDK_Fling, victim, addAmount, 96, attacker, 3.0);
											
											g_bIsSpikedCharged[attacker] = false;
											g_bCanChargerSpikedCharge[attacker] = false;
											CreateTimer(30.0, TimerResetSpikedCharge, attacker,  TIMER_FLAG_NO_MAPCHANGE);
										}
									}
								}
							}
						}
					}
					case 8: //TANK
					{
						EventsHurt_TankAttacker(attacker, victim, hEvent, dmgType, dmgHealth);
					}
					default: //Unknown
					{
						
					}
				}
		}
	}
	
	if(IsFakeClient(attacker) == false && attacker != victim && g_iClientTeam[attacker] == g_iClientTeam[victim])
	{
		if(g_iClientXP[attacker] > g_iClientPreviousLevelXPAmount[attacker])
		{
			g_iClientXP[attacker] -= 2;
			PrintCenterText(attacker, "Attacked Team. -2 XP");
		}
	}
	
	return Plugin_Continue;
}