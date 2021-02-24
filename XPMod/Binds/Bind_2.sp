/**************************************************************************************************************************
 *                                                    Bind 2 Pressed                                                      *
 **************************************************************************************************************************/

Action:Bind2Press(iClient, args)
{
	if(iClient==0)
		return Plugin_Handled;
	if(!IsClientInGame(iClient))
		return Plugin_Handled;
	if(g_bTalentsConfirmed[iClient] == false)
	{
		PrintToChat(iClient, "\x03[XPMod] \x04You must confirm your talents before using binds.");
		return Plugin_Handled;
	}
	if(!IsPlayerAlive(iClient))
	{
		PrintToChat(iClient, "\x03[XPMod] \x04You cannot use binds while you are dead.");
		return Plugin_Handled;
	}
	if(GetEntData(iClient, g_iOffset_IsGhost, 1) == 1)
	{
		PrintToChat(iClient, "\x03[XPMod] \x04You cannot use binds while your a ghost.");
		return Plugin_Handled;
	}
	if(g_bGameFrozen == true)
	{
		PrintToChat(iClient, "\x03[XPMod] \x04You must wait till the game is unfrozen before using binds.");
		return Plugin_Handled;
	}
	if(iClient>0)
	{
		if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
		{
			if(g_iPromotionalLevel[iClient]>0)	//Bill's actionkey 2
			{
				if(g_iClientBindUses_2[iClient]<3)
				{
					RunCheatCommand(iClient, "give", "give rifle_m60");
					RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");
					g_iClientBindUses_2[iClient]++;
				}
				else 
					PrintHintText(iClient, "You are out of M60 machine guns.");
			}
			else if(g_iShadowLevel[iClient]>0)	//Rochelle's actionkey 2
			{
				if(g_iClientBindUses_2[iClient] < 3)
				{
					if(g_bUsingShadowNinja[iClient]==false && GetEntProp(iClient, Prop_Send, "m_isIncapacitated") != 1)
					{
						push(iClient);
						g_bUsingShadowNinja[iClient] = true;
						g_bFirstShadowNinjaSwing[iClient] = true;
						g_iClientBindUses_2[iClient]++;
						//PrintHintTextToAll("Rochelle disabled everyones glow for 12 seconds");
						//SetConVarInt(FindConVar("sv_disable_glow_survivors"), 1);
						SetEntProp(iClient, Prop_Send, "m_iGlowType", 3);
						SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
						SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 1);
						ChangeEdictState(iClient, 12);
						DeleteParticleEntity(g_iPID_RochelleCharge1[iClient]);
						DeleteParticleEntity(g_iPID_RochelleCharge2[iClient]);
						DeleteParticleEntity(g_iPID_RochelleCharge3[iClient]);
						new Float:vec[3];
						GetClientAbsOrigin(iClient, vec);
						EmitSoundToAll(SOUND_NINJA_ACTIVATE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);

						RunCheatCommand(iClient, "give", "give katana");

						SetEntityRenderMode(iClient, RenderMode:3);
						SetEntityRenderColor(iClient, 0, 0, 0, RoundToFloor(255 * (1.0 - (float(g_iShadowLevel[iClient]) * 0.19))));

						SetClientSpeed(iClient);
						
						//CreateParticle("rochelle_weapon_trail", 12.0, iClient, ATTACH_BLUR);
						CreateTimer(12.0, TimerStopShadowNinja, iClient, TIMER_FLAG_NO_MAPCHANGE);
						
						//WriteParticle(iClient, "rochelle_smoke", 0.0, 10.0);
						
						CreateRochelleSmoke(iClient);
					}
				}
				else
					PrintHintText(iClient, "Not enough focus for a shadow ninja. You rack disciprine!");
			}
			else if(g_iFireLevel[iClient]>0)	//Ellis's actionkey 2
			{
				if(g_iClientBindUses_2[iClient]<3)
				{
					if(g_bUsingFireStorm[iClient] == false)
					{
						new Float:vec[3];
						GetClientAbsOrigin(iClient, vec);
						vec[2] += 10;
						EmitAmbientSound(SOUND_IGNITE, vec, iClient, SNDLEVEL_NORMAL);
						EmitSoundToAll(SOUND_ONFIRE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
						g_bUsingFireStorm[iClient] = true;
						new Float:time = (float(g_iFireLevel[iClient]) * 6.0);
						switch(g_iClientBindUses_2[iClient])
						{
							case 0:
								DeleteParticleEntity(g_iPID_EllisCharge3[iClient]);
							case 1:
								DeleteParticleEntity(g_iPID_EllisCharge2[iClient]);
							case 2:
								DeleteParticleEntity(g_iPID_EllisCharge1[iClient]);
						}
						//ForcePrecache("ellis_ulti_firestorm");
						g_iPID_EllisFireStorm[iClient] = WriteParticle(iClient, "ellis_ulti_firewalk",0.0, time);
						IgniteEntity(iClient, time, false);		//simply for the firefx on the survivor
						SetEntProp(iClient, Prop_Send, "m_iGlowType", 2);
						SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
						SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 255);
						ChangeEdictState(iClient, 12);
						CreateTimer(time, TimerStopFireStorm, iClient, TIMER_FLAG_NO_MAPCHANGE);
						SetEntityRenderMode(iClient, RenderMode:3);
						//SetEntityRenderColor(iClient, 255, 99, 18, 255);
						SetEntityRenderColor(iClient, 210, 88, 30, 255);
						PrintHintText(iClient, "You have pleased the fire god Kagu-Tsuchi and are granted the gift of fire for %3.0f seconds.", time);
						g_iClientBindUses_2[iClient]++;
					}
				}
				else
					PrintHintText(iClient, "Kagu-Tsuchi grows tired of you for now, don't piss him off!");
			}
			else if(g_iDesperateLevel[iClient]>0)	//Nick's actionkey 2
			{
				if(g_iClientBindUses_2[iClient]<3)
				{
					JebusHandBindMenuDraw(iClient);
				}
				else
					PrintHintText(iClient, "You are too tired to use any more of your medical expertise for now.");
			}
			else if(g_iStrongLevel[iClient]>0)	//Coaches's actionkey 2
			{
				if(g_bIsJetpackOn[iClient] == false && g_iClientJetpackFuelUsed[iClient]>0)
				{
					new Float:vec[3];
					GetClientAbsOrigin(iClient, vec);
					StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
					EmitSoundToAll(SOUND_JPSTART, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
					CreateTimer(3.0, TimerStartJetPack, iClient, TIMER_FLAG_NO_MAPCHANGE);
					//SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
				}
				else
				{
					StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
					new Float:vec[3];
					GetClientAbsOrigin(iClient, vec);
					EmitSoundToAll(SOUND_JPDIE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
					g_bIsJetpackOn[iClient] = false;
					if(clienthanging[iClient]==false)
						SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
					if(g_iClientJetpackFuelUsed[iClient]<1)
						PrintHintText(iClient, "Out Of Fuel");
				}
			}
			else
				PrintHintText(iClient, "You posses no talent for Bind 2");
		}
		else if(g_iClientTeam[iClient] == TEAM_INFECTED)
		{
			switch(g_iInfectedCharacter[iClient])
			{
				case SMOKER:
				{
					if((g_iClientInfectedClass1[iClient] == SMOKER) || (g_iClientInfectedClass2[iClient] == SMOKER) || (g_iClientInfectedClass3[iClient] == SMOKER))
					{
						if(g_iDirtyLevel[iClient] > 0)
						{
							if(g_iClientBindUses_2[iClient] < 3)
							{
								if(g_bElectricutionCooldown[iClient] == false)
								{
									if(g_iChokingVictim[iClient] > 0 && IsClientInGame(g_iChokingVictim[iClient]) == true)
									{
										if(g_bIsElectricuting[iClient] == false)
										{
											g_bIsElectricuting[iClient] = true;
											g_bElectricutionCooldown[iClient] = true;
											CreateTimer(15.0, Timer_ResetElectricuteCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
											
											g_iClientBindUses_2[iClient]++;
											
											decl Float:clientloc[3],Float:targetloc[3];
											GetClientEyePosition(iClient,clientloc);
											GetClientEyePosition(g_iChokingVictim[iClient],targetloc);
											clientloc[2] -= 10.0;
											targetloc[2] -= 20.0;
											new rand = GetRandomInt(1, 3);
											decl String:zap[23];
											switch(rand)
											{
												case 1: zap = SOUND_ZAP1; 
												case 2: zap = SOUND_ZAP2;
												case 3: zap = SOUND_ZAP3;
											}
											new pitch = GetRandomInt(95, 130);
											EmitSoundToAll(zap, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, clientloc, NULL_VECTOR, true, 0.0);
											EmitSoundToAll(zap, g_iChokingVictim[iClient], SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, targetloc, NULL_VECTOR, true, 0.0);
											TE_SetupBeamPoints(clientloc,targetloc,g_iSprite_Laser,0,0,66,0.3, 0.5, 0.5,0,4.0,{0,40,255,200},0);
											TE_SendToAll();
											CreateParticle("electrical_arc_01_system", 1.5, g_iChokingVictim[iClient], ATTACH_EYES, true);

											new alpha = GetRandomInt(80,140);										
											ShowHudOverlayColor(iClient, 255, 255, 255, alpha, 150, FADE_OUT);
											ShowHudOverlayColor(g_iChokingVictim[iClient], 255, 255, 255, alpha, 150, FADE_OUT);
											
											DealDamage(g_iChokingVictim[iClient], iClient, g_iDirtyLevel[iClient]);
											
											g_iClientXP[iClient] += 10;
											CheckLevel(iClient);
											
											if(g_iXPDisplayMode[iClient] == 0)
												ShowXPSprite(iClient, g_iSprite_10XP_SI, g_iChokingVictim[iClient], 1.0);
											
											decl i;
											for(i = 1;i <= MaxClients;i++)
											{
												if(i == g_iChokingVictim[iClient])
													continue;
												
												if(g_iChokingVictim[iClient] < 1 || IsValidEntity(i) == false || IsValidEntity(g_iChokingVictim[iClient]) == false)
													continue;
												
												if(IsClientInGame(i) && g_iClientTeam[i] == TEAM_SURVIVORS)
												{
													GetClientEyePosition(g_iChokingVictim[iClient], clientloc);
													GetClientEyePosition(i, targetloc);
													
													if(IsVisibleTo(clientloc, targetloc))
													{
														targetloc[2] -= 20.0;
														rand = GetRandomInt(1, 3);
														switch(rand)
														{
															case 1: zap = SOUND_ZAP1; 
															case 2: zap = SOUND_ZAP2;
															case 3: zap = SOUND_ZAP3;
														}
														pitch = GetRandomInt(95, 130);
														EmitSoundToAll(zap, i, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, targetloc, NULL_VECTOR, true, 0.0);
														TE_SetupBeamPoints(clientloc,targetloc,g_iSprite_Laser,0,0,66,0.3, 0.5, 0.5,0,4.0,{0,40,255,200},0);
														TE_SendToAll();
														CreateParticle("electrical_arc_01_system", 0.8, i, ATTACH_EYES, true);
														
														alpha = GetRandomInt(120, 180);					
														ShowHudOverlayColor(i, 255, 255, 255, alpha, 150, FADE_OUT);
														
														DealDamage(i , iClient, RoundToCeil((g_iDirtyLevel[iClient] * 0.5)));
														
														g_iClientXP[iClient] += 10;
														CheckLevel(iClient);
														
														if(g_iXPDisplayMode[iClient] == 0)
															ShowXPSprite(iClient, g_iSprite_10XP_SI, i, 1.0);
													}
												}
											}
											
											CreateTimer(0.5, TimerElectricuteAgain, iClient, TIMER_FLAG_NO_MAPCHANGE);
											CreateTimer(2.9, TimerStopElectricution, iClient, TIMER_FLAG_NO_MAPCHANGE);
										}
										else
											PrintHintText(iClient, "You are already electricuting a victim.");
									}
									else
										PrintHintText(iClient, "You must be choking a victim to electricute them.");
								}
								else
									PrintHintText(iClient, "You must wait for your electricity to charge back up again.");
							}
							else
								PrintHintText(iClient, "You are out of Bind 2 uses.");
						}
						else
							PrintHintText(iClient, "You must have Dirty Tricks (Level 1) for Smoker Bind 2");
					}
					else
						PrintHintText(iClient, "You dont have the Smoker as one of your classes");
				}
				case BOOMER:
				{
					if((g_iClientInfectedClass1[iClient] == BOOMER) || (g_iClientInfectedClass2[iClient] == BOOMER) || (g_iClientInfectedClass3[iClient] == BOOMER))
					{
						if(g_iNorovirusLevel[iClient] > 0)
						{
							if(g_iClientBindUses_2[iClient] < 3)
							{
								if(g_bIsSuicideBoomer[iClient] == false && g_bIsSuicideJumping[iClient] == false)
								{
									g_bIsSuicideBoomer[iClient] = true;
									PrintHintText(iClient, "You have inhaled %d Atomic Burritos! Jump to release.", g_iNorovirusLevel[iClient]);
								}
							}
							else
								PrintToChat(iClient, "\x03[XPMod] \x05You are out of Atomic Burritos");
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You must have a Noro-Virus for Bind 2");
					}
					else
						PrintToChat(iClient, "\x03[XPMod] \x05You dont have the Boomer as one of your classes");
				}
				case HUNTER:
				{
					if((g_iClientInfectedClass1[iClient] == HUNTER) || (g_iClientInfectedClass2[iClient] == HUNTER) || (g_iClientInfectedClass3[iClient] == HUNTER))
					{
						if(g_iKillmeleonLevel[iClient] > 0)
						{
							if(g_iClientBindUses_2[iClient] < 3)
							{
								if(g_bIsHunterReadyToPoison[iClient] == false)
								{
									if(g_bCanHunterPoisonVictim[iClient] == true)
									{
										g_bIsHunterReadyToPoison[iClient] = true;
										g_bCanHunterPoisonVictim[iClient] = false;
										PrintHintText(iClient, "The next victim you hit will be injected with your hunter venom");
									}
									else
										PrintHintText(iClient, "Wait 5 seconds to regenerate your poison");
								}
								else
									PrintToChat(iClient, "\x03[XPMod] \x05You already injected your claws with venom");
							}
							else
								PrintToChat(iClient, "\x03[XPMod] \x05You are out of venom");
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You must have a Kill-meleon for Bind 2");
					}
					else
						PrintToChat(iClient, "\x03[XPMod] \x05You dont have the Hunter as one of your classes");
				}
				case SPITTER:
				{
					if((g_iClientInfectedClass1[iClient] == SPITTER) || (g_iClientInfectedClass2[iClient] == SPITTER) || (g_iClientInfectedClass3[iClient] == SPITTER))
					{
						if(g_iHallucinogenicLevel[iClient] > 0)
						{
							if(g_iClientBindUses_2[iClient] < 3)
							{
								if(g_bCanConjureWitch[iClient] == true)
								{									
									if((GetEntityFlags(iClient) & FL_ONGROUND))
									{
										g_bCanConjureWitch[iClient] = false;
										
										decl Float:xyzAngles[3];
										GetLocationVectorInfrontOfClient(iClient, g_xyzWitchConjureLocation[iClient], xyzAngles);
										
										WriteParticle(iClient, "spitter_conjure", 180.0, 7.0, g_xyzWitchConjureLocation[iClient]);
										
										PrintHintText(iClient, "Conjuring Witch...");
										
										CreateTimer(2.3, TimerConjureWitch, iClient, TIMER_FLAG_NO_MAPCHANGE);
									}
									else
										PrintHintText(iClient, "You must be standing on the ground to conjure witches");
								}
								else
									PrintHintText(iClient, "Wait 3 minutes after conjuring a witch");
							}
							else
								PrintHintText(iClient, "Your out of Bind 2 uses");
						}
						else
							PrintHintText(iClient, "You must have Hallucinogenic Nightmare (Level 1) for Spitter Bind 2");
					}
					else
						PrintHintText(iClient, "You dont have the Spitter as one of your classes");
				}
				case JOCKEY:
				{
					if((g_iClientInfectedClass1[iClient] == JOCKEY) || (g_iClientInfectedClass2[iClient] == JOCKEY) || (g_iClientInfectedClass3[iClient] == JOCKEY))
					{
						if(g_iUnfairLevel[iClient] > 0)
						{
							if(g_iJockeyVictim[iClient] > 0)
							{
								if(g_iClientBindUses_2[iClient] < 3)
								{
									if(g_bCanJockeyCloak[iClient] == true)
									{
										g_bCanJockeyCloak[iClient] = false;
										g_bCanJockeyJump[iClient] = true;
										
										CreateTimer(10.0, TimerRemoveJockeyCloak, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
										CreateTimer(10.0, TimerRemoveJockeyCloak, iClient, TIMER_FLAG_NO_MAPCHANGE);

										// Set the jockey ride speed
										//SetEntDataFloat(g_iJockeyVictim[iClient] , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), ( 1.0 - (g_iStrongLevel[g_iJockeyVictim[iClient]] * 0.2) + (g_iErraticLevel[iClient] * 0.03) + (g_iUnfairLevel[iClient] * 0.1) ), true);
										if (g_iStrongLevel[g_iJockeyVictim[iClient]] == 0)
										{
											g_fJockeyRideSpeedVanishingActBoost[g_iJockeyVictim[iClient]] = (g_iUnfairLevel[iClient] * 0.05);
											SetClientSpeed(g_iJockeyVictim[iClient]);
											CreateTimer(10.0, TimerRemoveVanishingActSpeed, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
										}
											
										
										//Disable Glow for Victim
										if(IsValidEntity(g_iJockeyVictim[iClient]))
										{
											SetEntityRenderMode(g_iJockeyVictim[iClient], RenderMode:3);
											SetEntityRenderColor(g_iJockeyVictim[iClient], 255, 255, 255, RoundToFloor(255 * (1.0 -  (float(g_iUnfairLevel[iClient]) * 0.09))) );
											SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_iGlowType", 3);
											SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_nGlowRange", 0);
											SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_glowColorOverride", 1);
										}
										
										//Disable Glow for Jockey Attacker
										if(IsValidEntity(iClient))
										{
											SetEntityRenderMode(iClient, RenderMode:3);
											SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 -  (float(g_iUnfairLevel[iClient]) * 0.09))) );
											SetEntProp(iClient, Prop_Send, "m_iGlowType", 3);
											SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
											SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 1);
										}
										
										g_iClientBindUses_2[iClient]++;
									}
									else
										PrintHintText(iClient, "Wait 30 seconds to cloak again");
								}
								else
									PrintHintText(iClient, "Your out Bind 2 charges");
							}
							else
								PrintHintText(iClient, "You must be riding a victim to cloak");
						}
						else
							PrintHintText(iClient, "You must have Unfair Advantage (Level 1) for Jockey Bind 2");
					}
					else
						PrintHintText(iClient, "You dont have the Jockey as one of your classes");
				}
				case CHARGER:
				{
					if((g_iClientInfectedClass1[iClient] == CHARGER) || (g_iClientInfectedClass2[iClient] == CHARGER) || (g_iClientInfectedClass3[iClient] == CHARGER))
					{
						if(g_iHillbillyLevel[iClient] > 0)
						{
							if(g_iClientBindUses_2[iClient] < 3)
							{
								if(g_bCanChargerEarthquake[iClient] == true)
								{
									g_bIsHillbillyEarthquakeReady[iClient] = true;
									PrintHintText(iClient, "Punch an object to trigger an earthquake!");
								}
								else
									PrintHintText(iClient, "You must wait for the 30 second cooldown on Earthquake before reuse");
							}
							else
								PrintToChat(iClient, "\x03[XPMod] \x05You are out of Bind 2 uses");
						}
						else
							PrintToChat(iClient, "\x03[XPMod] \x05You must have a Hillbilly Madness for Charger Bind 2");
					}
					else
						PrintToChat(iClient, "\x03[XPMod] \x05You dont have the Charger as one of your classes");
				}
				case TANK:
				{
					PrintToChat(iClient, "not working yet");
				}
				default: //Unknown
				{
					//PrintToChat(iClient, "				You cannot use BIND 2 as UNKNOWN # %d", g_iInfectedCharacter[iClient]);
					return Plugin_Handled;
				}
			}
		}
	}
	return Plugin_Handled;
}