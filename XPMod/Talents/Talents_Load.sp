//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////       XP AND TALENT FUNCTIONS       ///////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/**************************************************************************************************************************
 *                                                     Load Talents                                                       *
 **************************************************************************************************************************/
public LoadTalents(iClient)
{
	if(iClient < 1 || g_bClientLoggedIn[iClient] == false || g_iClientTeam[iClient] == TEAM_SPECTATORS || 
		g_bClientSpectating[iClient] == true || IsClientInGame(iClient) == false || IsFakeClient(iClient) == true || 
		GetEntData(iClient, g_iOffset_IsGhost, 1) == 1)	//Check if Ghost
		return;
	
	if (g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		g_iInfectedCharacter[iClient] = GetEntProp(iClient, Prop_Send, "m_zombieClass");
		
		if(g_iInfectedConvarsSet[iClient] == false)	//Set One Time Convars
		{
			g_iInfectedConvarsSet[iClient] = true;
			
			//Smoker
			if(g_iClientTeam[iClient] == TEAM_INFECTED)
			{
				if(g_iEnvelopmentLevel[iClient] > 0)
				{
					g_iMaxTongueLength += g_iEnvelopmentLevel[iClient];
					SetConVarFloat(FindConVar("tongue_range"), float(750 + (g_iMaxTongueLength * 25)), false, false);
					SetConVarFloat(FindConVar("tongue_fly_speed"), float(1000 + (g_iMaxTongueLength * 30)),false,false);
				}
				if(g_iDirtyLevel[iClient] > 0)
				{
					g_iMaxDragSpeed += g_iDirtyLevel[iClient];
					SetConVarFloat(FindConVar("tongue_victim_max_speed"), float(175 + (g_iMaxDragSpeed * 8)), false, false);
				}
				if(g_iPredatorialLevel[iClient] > 0)
				{
					g_iStumbleRadius += (g_iPredatorialLevel[iClient] * 8);
					SetConVarInt(FindConVar("z_pounce_stumble_radius"), g_iStumbleRadius, false, false);
					// PrintToChatAll("Stumble radius = %i", g_iStumbleRadius);
				}
				if(g_iMutatedLevel[iClient] > 0)
				{
					g_iStumbleRadius += (g_iMutatedLevel[iClient] * 8);
					SetConVarInt(FindConVar("z_pounce_stumble_radius"), g_iStumbleRadius, false, false);
					// PrintToChatAll("Stumble radius = %i", g_iStumbleRadius);
				}
			}
			
		}
		
		switch(g_iInfectedCharacter[iClient])
		{
			case SMOKER:
			{
				if(g_iEnvelopmentLevel[iClient] > 0)
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Smoker Talents \x05have been loaded.");
				if(g_iNoxiousLevel[iClient] > 0)
				{
					//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iNoxiousLevel[iClient] * 0.01)), true);
					g_fClientSpeedBoost[iClient] += (g_iNoxiousLevel[iClient] * 0.02);
					fnc_SetClientSpeed(iClient);
				}
			}
			case BOOMER:
			{
				if(g_iRapidLevel[iClient] > 0)
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Boomer Talents \x05have been loaded.");
			}
			case HUNTER:
			{					
				g_iHunterShreddingVictim[iClient] = -1;
				if(g_iPredatorialLevel[iClient] > 0)
				{
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Hunter Talents \x05have been loaded.");
					//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iPredatorialLevel[iClient] * 0.08)), true);
					g_fClientSpeedBoost[iClient] += (g_iPredatorialLevel[iClient] * 0.08);
					fnc_SetClientSpeed(iClient);
				}
				if(g_iBloodlustLevel[iClient] > 0)
				{
					//PrintToChatAll("g_bHasInfectedHealthBeenSet = %d", g_bHasInfectedHealthBeenSet[iClient]);
					if(g_bHasInfectedHealthBeenSet[iClient] == false)
					{
						g_bHasInfectedHealthBeenSet[iClient] = true;
						SetEntProp(iClient,Prop_Data,"m_iHealth", 250 + (g_iBloodlustLevel[iClient] * 25));
						SetEntProp(iClient,Prop_Data,"m_iMaxHealth", 250 + (g_iBloodlustLevel[iClient] * 25));
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
			case SPITTER:
			{
				if(g_iPuppetLevel[iClient] > 0)
				{
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Spitter Talents \x05have been loaded.");
					
					new Float:xyzLocation[3];
					GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", xyzLocation);
					
					xyzLocation[2] += 10.0;
					
					WriteParticle(iClient, "spitter_conjure", 180.0, 7.0, xyzLocation);
				
					new Handle:hDataPackage = CreateDataPack();
					WritePackCell(hDataPackage, iClient);
					WritePackFloat(hDataPackage, xyzLocation[0]);
					WritePackFloat(hDataPackage, xyzLocation[1]);
					WritePackFloat(hDataPackage, xyzLocation[2]);
					
					CreateTimer(2.3, TimerConjureCommonInfected, hDataPackage);
				}
				
				g_bBlockGooSwitching[iClient] = false;
				g_bJustSpawnedWitch[iClient] = false;
				g_iGooType[iClient] = GOO_ADHESIVE;
				g_bJustUsedAcidReflex[iClient] = false;
				g_iAcidReflexLeft[iClient] = 0;
				g_bIsStealthSpitter[iClient] = false;
				g_iStealthSpitterChargePower[iClient] =  0;
				g_iStealthSpitterChargeMana[iClient] =  0;
				g_xyzWitchConjureLocation[iClient][0] = 0.0;
				g_xyzWitchConjureLocation[iClient][1] = 0.0;
				g_xyzWitchConjureLocation[iClient][2] = 0.0;
			}
			case JOCKEY:
			{
				//g_iJockeyVictim[iClient] = -1;
				if(g_iMutatedLevel[iClient] > 0)
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Jockey Talents \x05have been loaded.");
				
				if(g_iUnfairLevel[iClient] > 0)
				{
					if(g_bHasInfectedHealthBeenSet[iClient] == false)
					{
						g_bHasInfectedHealthBeenSet[iClient] = true;
						SetEntProp(iClient,Prop_Data,"m_iHealth", 325 + (g_iUnfairLevel[iClient] * 35));
						SetEntProp(iClient,Prop_Data,"m_iMaxHealth", 325 + (g_iUnfairLevel[iClient] * 35));
					}
					//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iUnfairLevel[iClient] * 0.07)), true);
					g_fClientSpeedBoost[iClient] += (g_iUnfairLevel[iClient] * 0.07);
					fnc_SetClientSpeed(iClient);
					g_bCanJockeyPee[iClient] = true;
				}
				if(g_iErraticLevel[iClient] > 0)
				{
					g_bCanJockeyJump[iClient] = true;
				}
			}
			case CHARGER:
			{
				g_bIsChargerCharging[iClient] = false;
				g_bChargerCarrying[iClient] = false;
				
				if(g_iGroundLevel[iClient] > 0)
				{
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Charger Talents \x05have been loaded.");
				}
				if(g_iSpikedLevel[iClient] > 0)
				{
					//SetEntProp(iClient,Prop_Data,"m_iHealth", 600 + (g_iSpikedLevel[iClient] * 25));
					//SetEntProp(iClient,Prop_Data,"m_iMaxHealth", 600 + (g_iSpikedLevel[iClient] * 25));
					g_bIsChargerHealing[iClient] = false;
					g_bCanChargerSuperCharge[iClient] = true;
					g_bIsSpikedCharged[iClient] = false;
					g_bCanChargerSpikedCharge[iClient] = true;
					g_bIsHillbillyEarthquakeReady[iClient] = false;
					g_bIsSuperCharger[iClient] = false;
				}
				if(g_iHillbillyLevel[iClient] > 0)
				{
					//SetEntProp(iClient,Prop_Data,"m_iHealth", 600 + (g_iSpikedLevel[iClient] * 25) + (g_iHillbillyLevel[iClient] * 35));
					//SetEntProp(iClient,Prop_Data,"m_iMaxHealth", 600 + (g_iSpikedLevel[iClient] * 25) + (g_iHillbillyLevel[iClient] * 35));
					//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iHillbillyLevel[iClient] * 0.03)), true);
					g_fClientSpeedBoost[iClient] += (g_iHillbillyLevel[iClient] * 0.03);
					fnc_SetClientSpeed(iClient);
					g_bCanChargerEarthquake[iClient] = true;
				}
				if(g_bHasInfectedHealthBeenSet[iClient] == false)
				{
					g_bHasInfectedHealthBeenSet[iClient] = true;
					SetEntProp(iClient,Prop_Data,"m_iHealth", 600 + (g_iSpikedLevel[iClient] * 25) + (g_iHillbillyLevel[iClient] * 35));
					SetEntProp(iClient,Prop_Data,"m_iMaxHealth", 600 + (g_iSpikedLevel[iClient] * 25) + (g_iHillbillyLevel[iClient] * 35));
				}
			}
			case TANK:
			{
				PrintHintText(iClient, "Choose Your Tank Talents");
				return;
			}
			default: //Unknown
			{
				//PrintToChat(iClient, "				                TALENT LOAD spawned as UNKNOWN # %d", g_iInfectedCharacter[iClient]);
				return;
			}
		}
	}
	else if (g_iClientTeam[iClient] == TEAM_SURVIVORS)		//Survivor Talents
	{
		SetSurvivorModel(iClient);	//Spawn their character (change their character model)
		DeleteAllClientParticles(iClient);
		fnc_SetRendering(iClient);
		//ResetGlow(iClient);				//Sometimes players still have their frozen blue color after loaded, trying to fix with this
		
		if(g_bTalentsGiven[iClient] == false)
			SetEntProp(iClient, Prop_Send, "m_isGoingToDie", 0);		//I dont think this is working
			
		g_iSavedClip[iClient] = 0;
		g_bForceReload[iClient] = false;
		
		switch(g_iChosenSurvivor[iClient])
		{
			case 0:		//Bill Talents
			{
				//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0+(g_iInspirationalLevel[iClient]*0.02) + (g_iPromotionalLevel[iClient] * 0.02)), true);
				if(g_iGhillieLevel[iClient]>0 || g_iPromotionalLevel[iClient]>0)
				{
					if (g_bGameFrozen == false)
					{
						SetEntityRenderMode(iClient, RenderMode:3);
						SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (((float(g_iGhillieLevel[iClient]) * 0.13) + ((float(g_iPromotionalLevel[iClient]) * 0.04)))))));
						if(g_iPromotionalLevel[iClient] > 0)	//disable glow
						{
							SetEntProp(iClient, Prop_Send, "m_iGlowType", 3);
							SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
							SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 1);
							ChangeEdictState(iClient, 12);
						}
					}
				}
				/*
				if(g_iPromotionalLevel[iClient] > 0)
				{
					g_fClientSpeedBoost[iClient] += (g_iPromotionalLevel[iClient] * 0.02);
					fnc_SetClientSpeed(iClient);
				}
				*/
				if(g_iWillLevel[iClient] > 0)
				{
					SetEntProp(iClient,Prop_Data,"m_iMaxHealth", 100 + (g_iWillLevel[iClient]*5) + (g_iDiehardLevel[iClient]*15) + (g_iCoachTeamHealthStack * 4));
					new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
					if(currentHP > (100 + (g_iWillLevel[iClient]*5) + (g_iDiehardLevel[iClient]*15) + (g_iCoachTeamHealthStack * 4)))
						SetEntProp(iClient,Prop_Data,"m_iHealth", 100 + (g_iWillLevel[iClient]*5) + (g_iDiehardLevel[iClient]*15) + (g_iCoachTeamHealthStack * 4));
					if(g_bTalentsGiven[iClient] == false)
					{
						SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + (g_iWillLevel[iClient]*5) + (g_iDiehardLevel[iClient]*15) + (g_iCoachTeamHealthStack * 4));
						
						//Set Convar for crawling speed
						g_iCrawlSpeedMultiplier += g_iWillLevel[iClient] * 5;
						SetConVarInt(FindConVar("survivor_crawl_speed"), (15 + g_iCrawlSpeedMultiplier),false,false);
						SetConVarInt(FindConVar("survivor_allow_crawling"),1,false,false);
					}
				}
				
				if(g_bTalentsGiven[iClient] == false && g_iPromotionalLevel[iClient] > 0)
				{
					if(g_iPromotionalLevel[iClient]==1 || g_iPromotionalLevel[iClient]==2)
						g_iClientBindUses_2[iClient] = 2;
					else if(g_iPromotionalLevel[iClient]==3 || g_iPromotionalLevel[iClient]==4)
						g_iClientBindUses_2[iClient] = 1;
					else
						g_iClientBindUses_2[iClient] = 0;
				}
				
				if((g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Support Talents \x05have been loaded.");
				else
					PrintToChat(iClient, "\x03[XPMod]\x01 * \x05None of your talents are leveled up! \x01*\x05\n                Type \x04!xpm\x05 and choose \x03Survivor Talents \x05to level up.");
			}
			case 1:		//Rochelle Talents
			{
				if((g_iHunterLevel[iClient] > 0) || (g_iShadowLevel[iClient] > 0) || (g_iSniperLevel[iClient] > 0))
				{
					g_fClientSpeedBoost[iClient] += ((g_iHunterLevel[iClient]*0.02) + (g_iSniperLevel[iClient] * 0.02) + (g_iShadowLevel[iClient] * 0.02));
					fnc_SetClientSpeed(iClient);
					//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iHunterLevel[iClient]*0.02) + (g_iSniperLevel[iClient] * 0.02) + (g_iShadowLevel[iClient] * 0.02)), true);
				}
				//Sets the iClient to hear all the infected's voice comms
				if(g_iGatherLevel[iClient] == 5)
				{
					for(new i = 1; i < MaxClients; i++)
					{
						if(IsClientInGame(i) == true && GetClientTeam(i) == TEAM_INFECTED && IsFakeClient(i) == false)
							SetListenOverride(iClient, i, Listen_Yes);
					}
				}
				
				if(g_iShadowLevel[iClient] > 0)
				{
					if(g_iClientBindUses_2[iClient] < 3)
						g_iPID_RochelleCharge3[iClient] = WriteParticle(iClient, "rochelle_ulti_ninja_charge3", 0.0);
					if(g_iClientBindUses_2[iClient] < 2)
						g_iPID_RochelleCharge2[iClient] = WriteParticle(iClient, "rochelle_ulti_ninja_charge2", 0.0);
					if(g_iClientBindUses_2[iClient] < 1)
						g_iPID_RochelleCharge1[iClient] = WriteParticle(iClient, "rochelle_ulti_ninja_charge1", 0.0);
					
					if(g_iShadowLevel[iClient]>0)
					{
						SetEntProp(iClient,Prop_Data,"m_iMaxHealth", 100 + (g_iShadowLevel[iClient] * 5) + (g_iSniperLevel[iClient] * 5) + (g_iCoachTeamHealthStack * 4));
						new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
						if(currentHP > (100 + (g_iShadowLevel[iClient] * 5) + (g_iSniperLevel[iClient] * 5) + (g_iCoachTeamHealthStack * 4)))
							SetEntProp(iClient,Prop_Data,"m_iHealth", 100 + (g_iShadowLevel[iClient] * 5) + (g_iSniperLevel[iClient] * 5) + (g_iCoachTeamHealthStack * 4));
						
						if(g_bTalentsGiven[iClient] == false)
							SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + (g_iShadowLevel[iClient] * 5) + (g_iSniperLevel[iClient] * 5) + (g_iCoachTeamHealthStack * 4));
					}
				}
				
				if(g_bTalentsGiven[iClient] == false)
				{
					if(g_iSmokeLevel[iClient]>0)
					{
						g_iRopeCountDownTimer[iClient] = 0;
					}
				}
				
				if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Ninja Talents \x05have been loaded.");
				else
					PrintToChat(iClient, "\x03[XPMod]\x01 * \x05None of your talents are leveled up! \x01*\x05\n                Type \x04!xpm\x05 and choose \x03Survivor Talents \x05to level up.");
			}
			case 2:		//Coach Talents
			{
				if(g_iBullLevel[iClient]>0 || g_iWreckingLevel[iClient]>0 || g_iStrongLevel[iClient]>0)
				{
					//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0-(g_iBullLevel[iClient]*0.03)), true);
					
					g_iMeleeDamageCounter[iClient] = (g_iStrongLevel[iClient] * 30);
					
					g_iClientSurvivorMaxHealth[iClient] = 100 + (g_iBullLevel[iClient]*13) + (g_iWreckingLevel[iClient]*5) + (g_iStrongLevel[iClient]*8) + (g_iCoachTeamHealthStack * 4);
					SetEntProp(iClient,Prop_Data,"m_iMaxHealth", g_iClientSurvivorMaxHealth[iClient]);
					new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
					if(currentHP > (100 +  g_iClientSurvivorMaxHealth[iClient]))
							SetEntProp(iClient,Prop_Data,"m_iHealth", 100 +  g_iClientSurvivorMaxHealth[iClient]);
						
					if(g_bTalentsGiven[iClient] == false)
					{
						SetEntProp(iClient,Prop_Data,"m_iHealth", 100 + (g_iBullLevel[iClient]*13) + (g_iWreckingLevel[iClient]*5) + (g_iStrongLevel[iClient]*8) + (g_iCoachTeamHealthStack * 4));
						
						CreateTimer(3.0, TimerGiveFirstExplosive, iClient, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
				if(g_iBullLevel[iClient] > 0)
				{
					g_bCoachRageIsAvailable[iClient] = true;
				}
				if(g_iSprayLevel[iClient] > 0)
				{
					g_iCoachShotgunAmmoCounter[iClient] = 0;
					g_bCoachShotgunForceReload[iClient] = false;
				}
				if(g_iStrongLevel[iClient] > 0)
				{
					g_iCoachCurrentGrenadeSlot[iClient] = 0;
					g_bCanCoachGrenadeCycle[iClient] = true;
					CreateTimer(0.5, TimerCoachAssignGrenades, iClient, TIMER_FLAG_NO_MAPCHANGE);
					g_bIsCoachGrenadeFireCycling[iClient] = false;
					g_bIsCoachInGrenadeCycle[iClient] = false;
				}
				if(g_bTalentsGiven[iClient] == false)
				{
					if(g_iStrongLevel[iClient]>0)
					{
						g_iClientJetpackFuelUsed[iClient] = g_iStrongLevel[iClient] * 160;
					}
					
					if(g_iLeadLevel[iClient]> 0)
					{
						if(g_iLeadLevel[iClient]==1 || g_iLeadLevel[iClient]==2)
						{
							g_iClientBindUses_1[iClient] = 2;
							g_iPID_CoachCharge1[iClient] = WriteParticle(iClient, "coach_bind_turret_charge1", 0.0);
						}
						else if(g_iLeadLevel[iClient]==3 || g_iLeadLevel[iClient]==4)
						{
							g_iClientBindUses_1[iClient] = 1;
							g_iPID_CoachCharge1[iClient] = WriteParticle(iClient, "coach_bind_turret_charge1", 0.0);
							g_iPID_CoachCharge2[iClient] = WriteParticle(iClient, "coach_bind_turret_charge2", 0.0);
						}
						else
						{
							g_iClientBindUses_1[iClient] = 0;
							g_iPID_CoachCharge1[iClient] = WriteParticle(iClient, "coach_bind_turret_charge1", 0.0);
							g_iPID_CoachCharge2[iClient] = WriteParticle(iClient, "coach_bind_turret_charge2", 0.0);
							g_iPID_CoachCharge3[iClient] = WriteParticle(iClient, "coach_bind_turret_charge3", 0.0);
						}
					}
					
					if(g_iLeadLevel[iClient] > 0)
					{
						g_iCoachTeamHealthStack += g_iLeadLevel[iClient];
						if(g_iLeadLevel[iClient] > g_iHighestLeadLevel)	//Find the maximum level for setting the cvars
							g_iHighestLeadLevel = g_iLeadLevel[iClient];
						
						//Set Max Health for all surviovrs higher
						decl i;
						for(i=1;i<=MaxClients;i++)
						{
							if(RunClientChecks(i) && IsPlayerAlive(i) == true)
							{
								if(g_iClientTeam[i]==TEAM_SURVIVORS)
								{
									new currentmaxHP=GetEntProp(i,Prop_Data,"m_iMaxHealth");
									new currentHP=GetEntProp(i,Prop_Data,"m_iHealth");
									SetEntProp(i,Prop_Data,"m_iMaxHealth", currentmaxHP + (g_iLeadLevel[iClient] * 4));
									SetEntProp(i,Prop_Data,"m_iHealth", currentHP + (g_iLeadLevel[iClient] * 4));
								}
							}
						}
					}
					
					//Set Convars for all coaches
					if(g_iHighestLeadLevel>0)
					{
						if(g_iHighestLeadLevel==5)
						{
							//coachnoshake = true;
							SetConVarInt(FindConVar("z_claw_hit_pitch_max"), 0);
							SetConVarInt(FindConVar("z_claw_hit_pitch_min"), 0);
							SetConVarInt(FindConVar("z_claw_hit_yaw_max"), 0);
							SetConVarInt(FindConVar("z_claw_hit_yaw_min"), 0);
						}
						/*
						SetConVarInt(FindConVar("chainsaw_attack_force"), 400 + (g_iHighestLeadLevel * 40));
						SetConVarInt(FindConVar("chainsaw_damage"), 100 + (g_iHighestLeadLevel * 10));
						SetConVarFloat(FindConVar("chainsaw_hit_interval"), 0.1 - (float(g_iHighestLeadLevel) * 0.01),false,false);
						*/
					}
				}
				
				if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Berserker Talents \x05have been loaded.");
				else
					PrintToChat(iClient, "\x03[XPMod]\x01 * \x05None of your talents are leveled up! \x01*\x05\n                Type \x04!xpm\x05 and choose \x03Survivor Talents \x05to level up.");
			}
			case 3:		//Ellis Talents
			{
				SetEntProp(iClient,Prop_Data,"m_iMaxHealth", g_iEllisMaxHealth[iClient]);
				new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
				if(currentHP > g_iEllisMaxHealth[iClient])
					SetEntProp(iClient,Prop_Data,"m_iHealth", g_iEllisMaxHealth[iClient]);
				
				if(g_iMetalLevel[iClient]>0)
				{
					g_bDoesClientAttackFast[iClient] = true;
					g_bSomeoneAttacksFaster = true;
					push(iClient, 1);
				}
				
				if(g_iMetalLevel[iClient] == 5)
				{
					g_bIsEllisLimitBreaking[iClient] = false;
					g_bCanEllisLimitBreak[iClient] = true;
					g_bEllisLimitBreakInCooldown[iClient] = false;
				}
				
				if(g_bTalentsGiven[iClient] == false)
				{
					if((0.4 - (float(g_iWeaponsLevel[iClient])*0.08)) < g_fMaxLaserAccuracy)
					{
						g_fMaxLaserAccuracy = 0.4 - (float(g_iWeaponsLevel[iClient])*0.08);
						SetConVarFloat(FindConVar("upgrade_laser_sight_spread_factor"), g_fMaxLaserAccuracy);
					}
					
					g_iClientBindUses_1[iClient] = 3 - RoundToCeil(g_iMetalLevel[iClient] * 0.5);
				}
				
				
				
				if(g_iFireLevel[iClient] > 0)
				{
					if(g_iClientBindUses_2[iClient] < 3)
						g_iPID_EllisCharge3[iClient] = WriteParticle(iClient, "ellis_ulti_fire_charge3", 0.0);
					if(g_iClientBindUses_2[iClient] < 2)
						g_iPID_EllisCharge2[iClient] = WriteParticle(iClient, "ellis_ulti_fire_charge2", 0.0);
					if(g_iClientBindUses_2[iClient] < 1)
						g_iPID_EllisCharge1[iClient] = WriteParticle(iClient, "ellis_ulti_fire_charge1", 0.0);
				}
				
				if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Weapon Expert Talents \x05have been loaded.");
				else
					PrintToChat(iClient, "\x03[XPMod]\x01 * \x05None of your talents are leveled up! \x01*\x05\n                Type \x04!xpm\x05 and choose \x03Survivor Talents \x05to level up.");
					
				if(g_iOverLevel[iClient] > 0)
				{
					new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
					new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
					if(iCurrentHealth < (iMaxHealth - 20))
					{
						if(g_bEllisOverSpeedDecreased[iClient] == false)
						{
							g_fClientSpeedBoost[iClient] -= (g_iOverLevel[iClient] * 0.02);
							fnc_SetClientSpeed(iClient);
							g_bEllisOverSpeedDecreased[iClient] = true;
							g_bEllisOverSpeedIncreased[iClient] = false;
						}
						//g_fEllisOverSpeed[iClient] = 0.0;
						//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iClient] + g_fEllisBringSpeed[iClient] + g_fEllisOverSpeed[iClient]), true);
						//DeleteCode
						//PrintToChatAll("Talents loaded, now setting g_fEllisOverSpeed");
						//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[iClient]);
						//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[iClient]);
						//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[iClient]);
					}
					else if(iCurrentHealth >= (iMaxHealth - 20))
					{
						if(g_bEllisOverSpeedIncreased[iClient] == false)
						{
							g_fClientSpeedBoost[iClient] += (g_iOverLevel[iClient] * 0.02);
							fnc_SetClientSpeed(iClient);
							g_bEllisOverSpeedDecreased[iClient] = false;
							g_bEllisOverSpeedIncreased[iClient] = true;
						}
						//g_fEllisOverSpeed[iClient] = (g_iOverLevel[iClient] * 0.02);
						//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iClient] + g_fEllisBringSpeed[iClient] + g_fEllisOverSpeed[iClient]), true);
						//DeleteCode
						//PrintToChatAll("Talents loaded, now setting g_fEllisOverSpeed");
						//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[iClient]);
						//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[iClient]);
						//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[iClient]);
					}
				}
				/*
				if(g_iOverLevel[iClient] == 5)
				{
					
				}
				*/
				if(g_iJamminLevel[iClient] == 5)
				{
					g_iEllisJamminGrenadeCounter[iClient] = 0;
				}
				if(g_iWeaponsLevel[iClient] == 5)
				{
					g_bIsEllisInPrimaryCycle[iClient] = false;
					g_iEllisCurrentPrimarySlot[iClient] = 0;
					g_bCanEllisPrimaryCycle[iClient] = true;
					g_strEllisPrimarySlot1 = "empty";
					g_strEllisPrimarySlot2 = "empty";
					//PrintToChatAll("Ellis primary slots are now empty");
				}
			}
			case 4:		//Nick Talents
			{
				g_bDivineInterventionQueued[iClient] = false;
				g_iNickMagnumShotCountCap[iClient] = 0;
				g_bCanNickStampedeReload[iClient] = false;
				g_bNickSwindlerHealthCapped[iClient] = false;
				g_iNickSwindlerBonusHealth[iClient] = 0;
				g_bRamboModeActive[iClient] = false;
				new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
				new maxHP = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
				
				if((g_iKitsUsed * (g_iSwindlerLevel[iClient] * 3)) < 100)
				{
					SetEntProp(iClient,Prop_Data,"m_iMaxHealth", maxHP + (g_iKitsUsed * (g_iSwindlerLevel[iClient] * 3)));
					SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + (g_iKitsUsed * (g_iSwindlerLevel[iClient] * 3)));
				}
				else if((g_iKitsUsed * (g_iSwindlerLevel[iClient] * 3)) > 100)
				{
					SetEntProp(iClient,Prop_Data,"m_iMaxHealth", maxHP + 100);
					SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + 100);
				}
				//PrintToChatAll("MaxHP Post = %d", maxHP);
				/*
				SetEntProp(iClient,Prop_Data,"m_iMaxHealth", g_iNickMaxHealth[iClient]);
				new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
				if(currentHP > g_iNickMaxHealth[iClient])
					SetEntProp(iClient,Prop_Data,"m_iHealth", g_iNickMaxHealth[iClient]);
				*/
				
				if(g_iMagnumLevel[iClient] > 0)
				{
					//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iMagnumLevel[iClient] * 0.03)), true);
					g_fClientSpeedBoost[iClient] += (g_iMagnumLevel[iClient] * 0.03);
					fnc_SetClientSpeed(iClient);
				}
					
				
				if(g_bTalentsGiven[iClient] == false)
					g_iClientBindUses_1[iClient] = 3 - RoundToCeil(g_iMagnumLevel[iClient] * 0.5);
				
				if(g_iDesperateLevel[iClient] > 0)
				{
					if(g_iClientBindUses_2[iClient] < 3)
						g_iPID_NickCharge3[iClient] = WriteParticle(iClient, "nick_ulti_heal_charge3", 0.0);
					if(g_iClientBindUses_2[iClient] < 2)
						g_iPID_NickCharge2[iClient] = WriteParticle(iClient, "nick_ulti_heal_charge2", 0.0);
					if(g_iClientBindUses_2[iClient] < 1)
						g_iPID_NickCharge1[iClient] = WriteParticle(iClient, "nick_ulti_heal_charge1", 0.0);
				}
				if(g_iRiskyLevel[iClient] == 5)
				{
					g_bCanNickSecondaryCycle[iClient] = true;
					g_bIsNickInSecondaryCycle[iClient] = false;
					g_iNickSecondarySavedClipSlot2[iClient] = 90;
					// PrintToChatAll("Talents Confirmed: Clip Slot 2 = %i", g_iNickSecondarySavedClipSlot2[iClient]);
				}
				if(g_iLeftoverLevel[iClient] == 5)
				{
					g_bCanNickZoomKit[iClient] = true;
				}
				
				if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
					PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Medic Talents \x05have been loaded.");
				else
					PrintToChat(iClient, "\x03[XPMod]\x01 * \x05None of your talents are leveled up! \x01*\x05\n                Type \x04!xpm\x05 and choose \x03Survivor Talents \x05to level up.");
			}
		}
		
		if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))	//Show Ring Effect if they have leveled up a talent
		{
			decl Float:pos[3], color[4];
			switch(g_iChosenSurvivor[iClient])
			{
				case 0: { color[0] = 0;		color[1] = 0; 	color[2] = 255;	color[3] = 20; }
				case 1: { color[0] = 150;	color[1] = 0; 	color[2] = 255;	color[3] = 20; }
				case 2: { color[0] = 160;	color[1] = 0; 	color[2] = 0;	color[3] = 20; }
				case 3: { color[0] = 255;	color[1] = 80; 	color[2] = 0;	color[3] = 20; }
				case 4: { color[0] = 0;		color[1] = 255;	color[2] = 0;	color[3] = 20; }
			}
			
			GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", pos);
			
			decl i;
			for(i = 0; i < 15; i++)
			{
				pos[2] += 5.0;
				TE_Start("BeamRingPoint");
				TE_WriteVector("m_vecCenter", pos);
				TE_WriteFloat("m_flStartRadius", 10.0);
				TE_WriteFloat("m_flEndRadius", 70.0);
				TE_WriteNum("m_nModelIndex", g_iSprite_Laser);
				TE_WriteNum("m_nHaloIndex", g_iSprite_Halo);
				TE_WriteNum("m_nStartFrame", 0);
				TE_WriteNum("m_nFrameRate", 60);
				TE_WriteFloat("m_fLife", 1.5);
				TE_WriteFloat("m_fWidth", 5.0);
				TE_WriteFloat("m_fEndWidth", 5.0);
				TE_WriteFloat("m_fAmplitude",  0.5);
				TE_WriteNum("r", color[0]);
				TE_WriteNum("g", color[1]);
				TE_WriteNum("b", color[2]);
				TE_WriteNum("a", color[3]);
				TE_WriteNum("m_nSpeed", 10);
				TE_WriteNum("m_nFlags", 0);
				TE_WriteNum("m_nFadeLength", 0);
				TE_SendToAll();
			}
			
			EmitSoundToAll(SOUND_TALENTS_LOAD, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, pos, NULL_VECTOR, true, 0.0);
		}
		
		if(g_bTalentsGiven[iClient] == false)
			SpawnWeapons(iClient);				//Give them their weapons
		
		g_bTalentsGiven[iClient] = true;	//Block Surivor Talents from being given again to the same iClient
	}
}