/**************************************************************************************************************************
 *                                                    Bind 1 Pressed                                                      *
 **************************************************************************************************************************/

Action:Bind1Press(iClient, args)
{
	if(RunClientChecks(iClient) == false)
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
	if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
	{
		if(g_iDiehardLevel[iClient] > 0)
		{
			if(g_bCanDropPoopBomb[iClient] == true)
			{
				if(g_iClientBindUses_1[iClient] < 3)
				{
					g_bCanDropPoopBomb[iClient] = false;
					CreateTimer(20.0, TimerChangeCanDropBombs, iClient, TIMER_FLAG_NO_MAPCHANGE);
					
					if(g_iDiehardLevel[iClient] < 3)
						g_iDropBombsTimes[iClient] = 2;
					else if(g_iDiehardLevel[iClient] < 5)
						g_iDropBombsTimes[iClient] = 1;
					else if(g_iDiehardLevel[iClient] == 5)
						g_iDropBombsTimes[iClient] = 0;

					delete g_hTimer_BillDropBombs[iClient];
					g_hTimer_BillDropBombs[iClient] = CreateTimer(1.0, TimerDropBombs, iClient, TIMER_REPEAT);
					
					g_iClientBindUses_1[iClient]++;
					new uses = 3 - g_iClientBindUses_1[iClient];
					PrintHintText(iClient, "Sons of bitches gonna die! %d uses remain", uses);
				}
				else
				{
					PrintHintText(iClient, "You have run out of improvised explosive devices.");
				}
			}
			else
				PrintHintText(iClient, "Wait a few seconds for more improvised explosives.");
		}
		else if(g_iMetalLevel[iClient]> 0)	//Ellis's Ammo Bind
		{
			if(g_iClientBindUses_1[iClient]<3)
			{
				if((GetEntityFlags(iClient) & FL_ONGROUND))
				{
					decl Float:vorigin[3], Float:vangles[3], Float:topvec[3];
					GetLocationVectorInfrontOfClient(iClient, vorigin, vangles);
					
					new ammopile = CreateEntityByName("weapon_ammo_spawn");
					DispatchKeyValueVector(ammopile, "Origin", vorigin);
					DispatchKeyValueVector(ammopile, "Angles", vangles);
					DispatchKeyValue(ammopile, "solid", "2");
					DispatchKeyValue(ammopile, "spawnflags", "2");
					DispatchSpawn(ammopile);
					SetEntityModel(ammopile, "models/props_unique/spawn_apartment/coffeeammo.mdl");
					// Set the ammo pile to not be solid to prevent glitches like blocking saferoom door
					SetEntProp(ammopile, Prop_Send, "m_nSolidType", 0);
					
					//Show the arrow under the ammo sprite
					vorigin[2] += 10.0;
					topvec[0] = vorigin[0];
					topvec[1] = vorigin[1];
					topvec[2] = vorigin[2] + 125.0;
					TE_SetupBeamPoints(vorigin,topvec,g_iSprite_Arrow,0,0,0,20.0,2.0,6.0, 1,0.0,{255, 255, 255, 255}, 10);
					TE_SendToAll();
					//Show the ammo sprite
					vorigin[2] += 135.0;
					topvec[0] = vorigin[0];
					topvec[1] = vorigin[1];
					topvec[2] = vorigin[2] + 98.0;
					TE_SetupBeamPoints(topvec,vorigin,g_iSprite_AmmoBox,0,0,0,20.0,55.0,55.0, 1,0.0,{255, 255, 255, 255},0);
					TE_SendToAll();
					
					g_iClientBindUses_1[iClient]++;
					new uses = 3 - g_iClientBindUses_1[iClient];
					PrintHintText(iClient, "Your have deployed ammo for the team, %d ammo piles remain", uses);
				}
				else
					PrintHintText(iClient, "Your must be on the ground to deploy ammo.");
			}
			else
				PrintHintText(iClient, "You are out of ammo piles.");
		}
		else if(g_iSmokeLevel[iClient]> 0)
		{
			//Smokers tongue rope
			if((g_bIsClientDown[iClient] == false) && (g_bChargerGrappled[iClient] == false) && (g_bSmokerGrappled[iClient] == false) && (g_bHunterGrappled[iClient] == false))
			if(g_iRopeCountDownTimer[iClient] < 900)
			{
				if(g_bHasDemiGravity[iClient] == false)
				{
					if(!g_bUsingTongueRope[iClient])
					{
						if(canchangemovement[iClient] == true)
						{
							//precache_laser=PrecacheModel("materials/custom/nylonninjarope.vmt");
							
							new Float:clientloc[3],Float:clientang[3];
							GetClientEyePosition(iClient,clientloc); // Get the position of the player's ATTACH_EYES
							GetClientEyeAngles(iClient,clientang); // Get the angle the player is looking
							TR_TraceRayFilter(clientloc,clientang,MASK_ALL,RayType_Infinite,TraceRayTryToHit); // Create a ray that tells where the player is looking
							TR_GetEndPosition(g_xyzRopeEndLocation[iClient]); // Get the end xyz coordinate of where a player is looking
							g_xyzOriginalRopeDistance[iClient] = GetVectorDistance(clientloc,g_xyzRopeEndLocation[iClient], false);
							g_xyzOriginalRopeDistance[iClient] *= 0.08;
							if(g_xyzOriginalRopeDistance[iClient] > (float(g_iSmokeLevel[iClient]) * 40.0))
							{
								PrintHintText(iClient, "Your smoker tongue rope doesnt reach beyond %.0f ft.", (float(g_iSmokeLevel[iClient]) * 40.0));
								return Plugin_Handled;
							}
							//PrintToChat(iClient, "original rope distance = %f", g_xyzOriginalRopeDistance[iClient]);
							g_bUsingTongueRope[iClient]=true; // Tell plugin the player is roping
							EmitSoundToAll(SOUND_HOOKGRAB, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);	// Emit sound from the end of the rope
							SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
							g_bUsedTongueRope[iClient] = true;
							g_xyzClientLocation[iClient][0] = clientloc[0];
							g_xyzClientLocation[iClient][1] = clientloc[1];
							g_xyzClientLocation[iClient][2] = clientloc[2] - 5.0;
							CreateTimer(0.1, ShowRopeTimer, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
						}
					}
					else
					{
						EmitSoundToAll(SOUND_HOOKRELEASE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);	// Emit sound from the end of the rope
						g_bUsingTongueRope[iClient]=false;
					}
				}	
				else
					PrintHintText(iClient,"You Smoker tongue cannot be used while weighted down by Demi Goo");
			}
			else
				PrintHintText(iClient,"Your have already broken your SMOKER tongue rope");
		}
		else if(g_iLeadLevel[iClient]> 0)	//Coach's Turret Gun Bind
		{
			if(g_iClientBindUses_1[iClient]<3)
			{
				if((GetEntityFlags(iClient) & FL_ONGROUND))
				{
					decl Float:vorigin[3], Float:vangles[3];
					GetLocationVectorInfrontOfClient(iClient, vorigin, vangles);
					
					g_iClientBindUses_1[iClient]++;
					new uses = 3 - g_iClientBindUses_1[iClient];
					decl random_turret;
					random_turret = GetRandomInt(0,1);
					switch (random_turret)
					{
						case 0: //Minigun
						{
							new minigun = CreateEntityByName("prop_minigun_l4d1");	//Create the gun entity to spawn
							DispatchKeyValue(minigun, "model", "Minigun_1");
							SetEntityModel(minigun, "models/w_models/weapons/w_minigun.mdl");
							DispatchKeyValueFloat (minigun, "MaxYaw", 180.0);		//Set the guns shooting angle limits
							DispatchKeyValueFloat (minigun, "MinPitch", -90.0);
							DispatchKeyValueFloat (minigun, "MaxPitch", 90.0);
							DispatchKeyValueVector(minigun, "Angles", vangles);		//Angles for iClient pressing use to get on the gun
							DispatchKeyValueFloat(minigun, "spawnflags", 256.0);
							DispatchKeyValueFloat(minigun, "solid", 0.0);
							DispatchSpawn(minigun);
							TeleportEntity(minigun, vorigin, vangles, NULL_VECTOR);
							PrintHintText(iClient, "You mounted a minigun to help protect your team from the masses.\n%d uses remain.", uses);
						}
						case 1: //50cal
						{
							new minigun = CreateEntityByName("prop_minigun");	//Create the gun entity to spawn
							DispatchKeyValue(minigun, "model", "Minigun_1");
							SetEntityModel(minigun, "models/w_models/weapons/50cal.mdl");
							DispatchKeyValueFloat (minigun, "MaxYaw", 180.0);		//Set the guns shooting angle limits
							DispatchKeyValueFloat (minigun, "MinPitch", -90.0);
							DispatchKeyValueFloat (minigun, "MaxPitch", 90.0);
							DispatchKeyValueVector(minigun, "Angles", vangles);		//Angles for iClient pressing use to get on the gun
							DispatchKeyValueFloat(minigun, "spawnflags", 256.0);
							DispatchKeyValueFloat(minigun, "solid", 0.0);
							DispatchSpawn(minigun);
							TeleportEntity(minigun, vorigin, vangles, NULL_VECTOR);
							PrintHintText(iClient, "You mounted a 50 caliber machine gun to help protect your team from the masses.\n%d uses remain.", uses);
						}
					}
					switch(g_iClientBindUses_1[iClient])
					{
						case 1:
							DeleteParticleEntity(g_iPID_CoachCharge1[iClient]);
						case 2:
							DeleteParticleEntity(g_iPID_CoachCharge2[iClient]);
						case 3:
							DeleteParticleEntity(g_iPID_CoachCharge3[iClient]);
					}
				}
				else
					PrintHintText(iClient, "Your must be on the ground before deployment.");
			}
			else
				PrintHintText(iClient, "Your out of mountable turrets.");
		}
		else if(g_iMagnumLevel[iClient] > 0)	//Nick's Actionkey 1
		{
			if(g_bNickIsGettingBeatenUp[iClient] == false)
			{
				if(g_bRamboModeActive[iClient] == false)
				{
					if(g_iClientBindUses_1[iClient]<3)
					{
						//Gamble(Nick's hooked action)
						//check to see if alive before running this//////////////////
						decl rand;
						decl String:clientname[128];
						GetClientName(iClient, clientname, sizeof(clientname));
						/*
						g_bHunterGrappled
						g_bChargerGrappled
						g_bSmokerGrappled
						*/
						/*
						if((g_bHunterGrappled[iClient] == false) && (g_bChargerGrappled[iClient] == false) && (g_bSmokerGrappled[iClient] == false))
						{
							new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);

							RunCheatCommand(iClient, "give", "give health");
							fTempHealth = 0.0;
							SetEntDataFloat(iClient,g_iOffset_HealthBuffer, fTempHealth ,true);
							PrintHintText(iClient,"Rolled an 11\nYou have received divine intervention from above...or below.");
							PrintToChat(iClient, "\x03[XPMod] \x05You were given a fresh life.");

							g_bIsClientDown[iClient] = false;
						}
						else
						{
							g_bDivineInterventionQueued[iClient] = true;
							PrintToChat(iClient, "Divine intervention will be applied when you break free!");
						}
						*/
						/*
						//TEST
						fnc_DeterminePrimaryWeapon(iClient);
						fnc_SaveAmmo(iClient);
						RemoveEdict(g_iPrimarySlotID[iClient]);
						g_bRamboModeActive[iClient] = true;


						PrintHintText(iClient,"Rolled a 4\nAAAAAAAAAADDDRRRIIAAAAAAAAAAN!");
						PrintToChat(iClient, "\x03[XPMod] \x05You have become RAMBO!!!");
						RunCheatCommand(iClient, "give", "give rifle_m60");
						//g_iRamboWeaponID[iClient] = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
						fnc_DeterminePrimaryWeapon(iClient);
						fnc_DetermineMaxClipSize(iClient);
						RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");
						RunCheatCommand(iClient, "upgrade_add", "upgrade_add EXPLOSIVE_AMMO");
						CreateTimer(30.0, TimerStopRambo, iClient, TIMER_FLAG_NO_MAPCHANGE);
						//TEST
						*/
						rand = GetRandomInt(1,12);
						
						switch (rand)
						{
							case 1: //Raid the Medicine cabinet
							{
								PrintHintText(iClient,"Rolled a 1\nYou got in good with a random drug dealer.");
								PrintToChatAll("\x03[XPMod] \x05%N got \"Da Huk Up\"...pop those pillz.", iClient);
								RunCheatCommand(iClient, "give", "give pain_pills");
								RunCheatCommand(iClient, "give", "give pain_pills");
								RunCheatCommand(iClient, "give", "give pain_pills");
								RunCheatCommand(iClient, "give", "give pain_pills");
								RunCheatCommand(iClient, "give", "give pain_pills");
							}
							case 2: // Slap
							{
								new iCurrentHP = GetEntProp(iClient, Prop_Data, "m_iHealth");
								if(iCurrentHP > 15)
									SlapPlayer(iClient, 15);
								else
									SlapPlayer(iClient, iCurrentHP - 1);
								PrintHintText(iClient,"Rolled a 2\nYou were caught stealing and slapped at gunpoint by that shady dude on the corner.");
								PrintToChatAll("\x03[XPMod] \x05%N been pimp slapped by a drug dealer.", iClient);
							}
							case 3: // Raided a gun shop, holy crap
							{

								PrintHintText(iClient,"Rolled a 3\nYou raided a huge weapon store. Lock and Load!");
								PrintToChatAll("\x03[XPMod] \x05%N received a shite-ton of weapons.", iClient);
								RunCheatCommand(iClient, "give", "give smg");
								RunCheatCommand(iClient, "give", "give smg_silenced");
								RunCheatCommand(iClient, "give", "give smg_mp5");
								RunCheatCommand(iClient, "give", "give rifle");
								RunCheatCommand(iClient, "give", "give rifle_sg552");
								RunCheatCommand(iClient, "give", "give rifle_desert");
								RunCheatCommand(iClient, "give", "give pumpshotgun");
								RunCheatCommand(iClient, "give", "give shotgun_chrome");
								RunCheatCommand(iClient, "give", "give autoshotgun");
								RunCheatCommand(iClient, "give", "give shotgun_spas");
								RunCheatCommand(iClient, "give", "give hunting_rifle");
								RunCheatCommand(iClient, "give", "give sniper_military");
								RunCheatCommand(iClient, "give", "give sniper_scout");
								RunCheatCommand(iClient, "give", "give sniper_awp");
								RunCheatCommand(iClient, "give", "give grenade_launcher");
								RunCheatCommand(iClient, "give", "give rifle_m60");
								RunCheatCommand(iClient, "give", "give pistol");
								RunCheatCommand(iClient, "give", "give fireaxe");
								RunCheatCommand(iClient, "give", "give crowbar");
								RunCheatCommand(iClient, "give", "give cricket_bat");
								RunCheatCommand(iClient, "give", "give baseball_bat");
								RunCheatCommand(iClient, "give", "give katana");
								RunCheatCommand(iClient, "give", "give electric_guitar");
								RunCheatCommand(iClient, "give", "give machete");
								RunCheatCommand(iClient, "give", "give frying_pan");
								RunCheatCommand(iClient, "give", "give tonfa");
								RunCheatCommand(iClient, "give", "give chainsaw");
								//RunCheatCommand(iClient, "give", "give riotshield");
								RunCheatCommand(iClient, "give", "give knife");
								RunCheatCommand(iClient, "give", "give golfclub");
								RunCheatCommand(iClient, "give", "give pipe_bomb");
								RunCheatCommand(iClient, "give", "give molotov");
								RunCheatCommand(iClient, "give", "give vomitjar");
								RunCheatCommand(iClient, "give", "give upgradepack_explosive");
								RunCheatCommand(iClient, "give", "give upgradepack_incendiary");
								// The ones Nick will have after
								RunCheatCommand(iClient, "give", "give rifle_ak47");
								RunCheatCommand(iClient, "give", "give pistol_magnum");


							}
							case 4: //Rambo
							{
								fnc_DeterminePrimaryWeapon(iClient);
								fnc_SaveAmmo(iClient);
								RemoveEdict(g_iPrimarySlotID[iClient]);
								g_bRamboModeActive[iClient] = true;



								PrintHintText(iClient,"Rolled a 4\nAAAAAAAAAADDDRRRIIAAAAAAAAAAN!");
								PrintToChatAll("\x03[XPMod] \x05%N has become RAMBO!!!", iClient);

								RunCheatCommand(iClient, "give", "give rifle_m60");

								//g_iRamboWeaponID[iClient] = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
								fnc_DeterminePrimaryWeapon(iClient);
								fnc_DetermineMaxClipSize(iClient);
								RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");
								RunCheatCommand(iClient, "upgrade_add", "upgrade_add EXPLOSIVE_AMMO");
								CreateTimer(30.0, TimerStopRambo, iClient, TIMER_FLAG_NO_MAPCHANGE);

							}
							case 5: //Crack Out on drugs
							{
								PrintHintText(iClient,"Rolled a 5\nYou popped some colorful pills from some shady ass dude on fifth street.");
								PrintToChatAll("\x03[XPMod] \x05%N popped some shady pills...THE COLORRRRRSS...", iClient);
								
								new red = GetRandomInt(0,255);
								new green = GetRandomInt(0,255);
								new blue = GetRandomInt(0,255);
								new alpha = GetRandomInt(190,230);
								
								//Set Hud Overlay of The Random Color
								ShowHudOverlayColor(iClient, red, green, blue, alpha, 700, FADE_OUT);
								
								WriteParticle(iClient, "drugged_effect", 0.0, 30.0);
								
								g_iDruggedRuntimesCounter[iClient] = 0;

								delete g_hTimer_DrugPlayer[iClient];
								g_hTimer_DrugPlayer[iClient] = CreateTimer(2.5, TimerDrugged, iClient, TIMER_REPEAT);
							}
							case 6: //MegaSlap; Slaps Nick for 80 damage.
							{
								g_bNickIsGettingBeatenUp[iClient] = true;
								PrintHintText(iClient,"Rolled a 6\nYou were caught carrying a pistol by a self-loathing cop...better cover up!");
								PrintToChatAll("\x03[XPMod] \x05%N is being beaten by a self-loathing cop!", iClient);
								
								g_iSlapRunTimes[iClient] = 0;
								delete g_hTimer_SlapPlayer[iClient];
								g_hTimer_SlapPlayer[iClient] = CreateTimer(1.0, TimerSlap, iClient, TIMER_REPEAT);
							}
							case 7: //Party supplies++; Spawns 3 defibs, kits, pills, and shots
							{

								PrintHintText(iClient,"Rolled a 7\nYou raided a mega hospital's medicine cabinant for supplies.");
								PrintToChatAll("\x03[XPMod] \x05%N raided a mega hospital's medicine cabinet for supplies.", iClient);
								RunCheatCommand(iClient, "give", "give adrenaline");
								RunCheatCommand(iClient, "give", "give defibrillator");
								RunCheatCommand(iClient, "give", "give first_aid_kit");
								RunCheatCommand(iClient, "give", "give pain_pills");
								RunCheatCommand(iClient, "give", "give adrenaline");
								RunCheatCommand(iClient, "give", "give defibrillator");
								RunCheatCommand(iClient, "give", "give first_aid_kit");
								RunCheatCommand(iClient, "give", "give pain_pills");
								RunCheatCommand(iClient, "give", "give adrenaline");
								RunCheatCommand(iClient, "give", "give defibrillator");
								RunCheatCommand(iClient, "give", "give first_aid_kit");
								RunCheatCommand(iClient, "give", "give pain_pills");

							}
							case 8: //Get three more times to Gamble
							{
								PrintHintText(iClient,"Rolled an 8\nYou found a sucker to scam, three more chances to gamble this round.");
								g_iClientBindUses_1[iClient] -= 3;
								PrintToChatAll("\x03[XPMod] \x05%N received three more chances to gamble.", iClient);
							}
							case 9: //Party Supplies; Spawns 1 defib, kit, pills, and shot
							{

								PrintHintText(iClient,"Rolled a 9\nYou successfully raided some hospital's medicine cabinant for supplies.");
								PrintToChatAll("\x03[XPMod] \x05%N raided a medicine cabinet for supplies.", iClient);
								RunCheatCommand(iClient, "give", "give adrenaline");
								RunCheatCommand(iClient, "give", "give defibrillator");
								RunCheatCommand(iClient, "give", "give first_aid_kit");
								RunCheatCommand(iClient, "give", "give pain_pills");

							}
							case 10: //Blindness
							{
								PrintHintText(iClient,"Rolled a 10\nYou accidentally splashed questionable chemicals in your eyes.");
								PrintToChatAll("\x03[XPMod] \x05%N has been temporarily blinded by chemicals.", iClient);
																
								ShowHudOverlayColor(iClient, 0, 0, 0, 255, 300, FADE_OUT);
								
								CreateTimer(0.8, TimerBlindFade, iClient, TIMER_FLAG_NO_MAPCHANGE);
							}
							case 11: //Revival; Return to maximum health, even when incapped
							{
								if((g_bHunterGrappled[iClient] == false) && (g_bChargerGrappled[iClient] == false) && (g_bSmokerGrappled[iClient] == false))
								{
									new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);

									RunCheatCommand(iClient, "give", "give health");
									fTempHealth = 0.0;
									SetEntDataFloat(iClient,g_iOffset_HealthBuffer, fTempHealth ,true);

									PrintHintText(iClient,"Rolled an 11\nYou have received divine intervention from above...or below.");
									PrintToChatAll("\x03[XPMod] \x05%N was given a fresh life.", iClient);


									g_bIsClientDown[iClient] = false;
								}
								else
								{
									g_bDivineInterventionQueued[iClient] = true;
									PrintToChat(iClient, "Divine intervention will be applied when you break free!");
								}
							}
							case 12: //Gain 3 more bind2s
							{
								PrintHintText(iClient,"Rolled an 12\nA night of partying left you wanting more.");
								PrintToChatAll("\x03[XPMod] \x05%N feels ready for more! +3 to Bind2!", iClient);
								g_iClientBindUses_2[iClient] -= 3;
							}
						}
						WriteParticle(iClient, "nick_bind_gamble", 0.0, 35.0);
						g_iClientBindUses_1[iClient]++;
					}
					else
						PrintHintText(iClient, "Your out of money as well as people to scam money off of...for now.");
				}
				else
					PrintHintText(iClient, "You cannot gamble while rambo.");
			}
			else
				PrintHintText(iClient, "You cannot gamble while being bitch slapped.");
		}
		else
			PrintHintText(iClient, "You posses no talent for Bind 1");
	}
	else if(g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		switch(g_iInfectedCharacter[iClient])
		{
			case 1: //SMOKER
			{
				//Teleportation
				if((g_iClientInfectedClass1[iClient] == SMOKER) || (g_iClientInfectedClass2[iClient] == SMOKER) || (g_iClientInfectedClass3[iClient] == SMOKER))
				{
					if(g_iDirtyLevel[iClient] > 0)
					{
						if(g_bTeleportCoolingDown[iClient] == false)
						{
							if(g_iChokingVictim[iClient] < 1)
							{
								decl Float:eyeorigin[3], Float:eyeangles[3], Float:endpos[3], Float:vdir[3], Float:distance;
								GetClientEyePosition(iClient, eyeorigin);
								GetClientEyeAngles(iClient, eyeangles);
								GetAngleVectors(eyeangles, vdir, NULL_VECTOR, NULL_VECTOR);	//Get direction in which iClient is facing
								new Handle:trace = TR_TraceRayFilterEx(eyeorigin, eyeangles, MASK_SHOT, RayType_Infinite, TraceRayDontHitSelf, iClient);
								if(TR_DidHit(trace))
								{
									TR_GetEndPosition(endpos, trace);
									if(endpos[2] < g_fMapsMaxTeleportHeight)	//This limits the height of teleportation for each map, to prevent from walking in the sky
									{
										endpos[0]-=(vdir[0] * 50.0);		//Spawn iClient right ahead of where they were looking
										endpos[1]-=(vdir[1] * 50.0);
										//endpos[2]-=(vdir[2] * 50.0);
										//PrintToChat(iClient, "vdir = %.4f, %.4f, %.4f", vdir[0], vdir[1], vdir[2]);
										distance = GetVectorDistance(eyeorigin, endpos, false);
										distance = distance * 0.08;
										if(distance <= (float(g_iDirtyLevel[iClient]) * 30.0))
										{
											decl Float:vorigin[3];
											GetClientAbsOrigin(iClient, vorigin);
											TeleportEntity(iClient, endpos, NULL_VECTOR, NULL_VECTOR);
											EmitSoundToAll(SOUND_WARP_LIFE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1,  endpos, NULL_VECTOR, true, 0.0);
											EmitSoundToAll(SOUND_WARP, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1,  endpos, NULL_VECTOR, true, 0.0);
											WriteParticle(iClient, "teleport_warp", 0.0, 7.0);
											PrintHintText(iClient, "You teleported %.1f ft.", distance);
											PrintToChat(iClient, "<%f, %f, %f>", endpos[0], endpos[1], endpos[2]);
											g_fTeleportOriginalPositionX[iClient] = vorigin[0];
											g_fTeleportOriginalPositionY[iClient] = vorigin[1];
											g_fTeleportOriginalPositionZ[iClient] = vorigin[2];
											g_fTeleportEndPositionX[iClient] = endpos[0];
											g_fTeleportEndPositionY[iClient] = endpos[1];
											g_fTeleportEndPositionZ[iClient] = endpos[2];
											CreateTimer(3.0, CheckIfStuck, iClient, TIMER_FLAG_NO_MAPCHANGE);		//Check if the player is stuck in a wall
											g_bTeleportCoolingDown[iClient] = true;
											CreateTimer(10.0, ReallowTeleport, iClient, TIMER_FLAG_NO_MAPCHANGE);	//After 10 seconds reallow teleportation fot the iClient
											
											//Make smoker transparent and set him to gradually become more opaque
											g_iSmokerTransparency[iClient] = g_iDirtyLevel[iClient] * 30;
											SetEntityRenderMode(iClient, RenderMode:3);
											SetEntityRenderColor(iClient, 0, 0, 0, 0);
										}
										else
											PrintHintText(iClient, "You cannot teleport beyond %.0f ft.", (float(g_iDirtyLevel[iClient]) * 30.0));
									}
									else
										PrintHintText(iClient, "You cannot teleport to this location.");
								}
								else
									PrintHintText(iClient, "You cannot teleport to this location.");
									
								CloseHandle(trace);
							}
							else
								PrintHintText(iClient, "You cannot teleport while choking a victim.");
						}
						else
							PrintHintText(iClient, "You must wait 10 seconds between teleportations.");
					}
					else
						PrintHintText(iClient, "You must have Noxious Gasses (Level 1) for Smoker Bind 1");
				}
				else
					PrintHintText(iClient, "You dont have the Smoker as one of your classes");
			}
			case 2: //BOOMER
			{
				if((g_iClientInfectedClass1[iClient] == BOOMER) || (g_iClientInfectedClass2[iClient] == BOOMER) || (g_iClientInfectedClass3[iClient] == BOOMER))
				{
					if(g_iAcidicLevel[iClient] > 0)
					{
						if(g_iClientBindUses_1[iClient] < 3)
						{
							if(g_bIsServingHotMeal[iClient] == false)
							{
								g_iClientBindUses_1[iClient]++;
								PrintHintText(iClient, "Your serving up a hot meal. Don't forget to feed the hungry survivors!\nClick Rapidly!");
								g_bIsServingHotMeal[iClient] = true;
								g_bIsBoomerVomiting[iClient] = true;
								
								SetClientSpeed(iClient);

								//Start Vomiting
								new iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
								if (iEntid > 0)
								{
									new Float:flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+8);
									new Float:flTimeStamp_calc = flTimeStamp_ret - 29.5;
									SetEntDataFloat(iEntid, g_iOffset_NextActivation+8, flTimeStamp_calc, true);
								}
								CreateTimer(1.0, TimerConstantVomit, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
								CreateTimer(9.0, TimerStopHotMeal, iClient, TIMER_FLAG_NO_MAPCHANGE);
							}
							else
								PrintHintText(iClient, "You are already serving up a hot meal!");
						}
						else
								PrintHintText(iClient, "Your out of hot meals to serve.");
					}
					else
						PrintHintText(iClient, "You must have Acidic Brew (Level 1) for Boomer Bind 1");
				}
				else
					PrintHintText(iClient, "You dont have the Boomer as one of your classes");
			}
			case 3: //HUNTER
			{
				
				if((g_iClientInfectedClass1[iClient] == HUNTER) || (g_iClientInfectedClass2[iClient] == HUNTER) || (g_iClientInfectedClass3[iClient] == HUNTER))
				{
					// PrintToChatAll("Hunter is a chosen class...");
					if(g_iBloodlustLevel[iClient] > 0)
					{
						// PrintToChatAll("Bloodlust is greater than 0...");
						if(g_iHunterShreddingVictim[iClient] > 0)
						{
							// PrintToChatAll("Hunter is shredding a victim...");
							if(g_bCanHunterDismount[iClient] == true)
							{
								// PrintToChatAll("Hunter attempting dismount...");
								SDKCall(g_hSDK_OnPounceEnd,iClient);
								SetClientSpeed(g_iHunterShreddingVictim[iClient]);
								//ResetSurvivorSpeed(g_iHunterShreddingVictim[iClient]);
								g_iHunterShreddingVictim[iClient] = -1;
								g_bCanHunterDismount[iClient] = false;
								CreateTimer(15.0, TimerResetHunterDismount, iClient,  TIMER_FLAG_NO_MAPCHANGE);
							}
							else
								PrintHintText(iClient, "Wait 15 seconds after dismounting");
						}
						else
							PrintHintText(iClient, "You are not mounted on a victim");
					}
					else
						PrintHintText(iClient, "You must have Blood Lust (Level 1) for Hunter Bind 1");
				}
				else
					PrintHintText(iClient, "You dont have the Hunter as one of your classes");
			}
			case SPITTER:
			{
				if((g_iClientInfectedClass1[iClient] == SPITTER) || (g_iClientInfectedClass2[iClient] == SPITTER) || (g_iClientInfectedClass3[iClient] == SPITTER))
				{
					if(g_iMaterialLevel[iClient] > 0)
					{
						if(g_iClientBindUses_1[iClient] < 3)
						{
							BagOfSpitsMenuDraw(iClient);
						}
						else
							PrintHintText(iClient, "You are out of Bind 1 uses for this round");
					}
					else
						PrintHintText(iClient, "You must have Material Girl (Level 1) for Spitter Bind 1, Bag of Spits");
				}
				else
					PrintHintText(iClient, "You don't have the Spitter as one of your classes");
			}
			case 5: //JOCKEY
			{
				if((g_iClientInfectedClass1[iClient] == JOCKEY) || (g_iClientInfectedClass2[iClient] == JOCKEY) || (g_iClientInfectedClass3[iClient] == JOCKEY))
				{
					if(g_iErraticLevel[iClient] > 0)
					{
						if(g_iJockeyVictim[iClient] > 0)
						{
							if(g_iClientBindUses_1[iClient] < 3)
							{
								if(g_bCanJockeyPee[iClient] == true)
								{
									if(IsValidEntity(g_iJockeyVictim[iClient]) == true)
										if(IsClientInGame(g_iJockeyVictim[iClient]) == true)
										{
											g_bCanJockeyPee[iClient] = false;
											
											GiveClientXP(iClient, 25, g_iSprite_25XP_SI, g_iJockeyVictim[iClient], "Pissed on survivor.");
											
											new iRandomTankSpawn = GetRandomInt(1, 100);
											switch (iRandomTankSpawn)
											{
												case 1, 2, 3, 4, 5, 6, 7, 8 , 9, 10:
												{
													if(g_iErraticLevel[iClient] >= iRandomTankSpawn)
													{
														g_bTankStartingHealthXPModSpawn = true;
														RunCheatCommand(iClient, "z_spawn_old", "z_spawn_old tank auto");

														PrintToChatAll("\x03[XPMod] \x04Beware, a tank smells %N's jockey piss", iClient);
														PrintHintText(iClient, "You attracted a tank with your piss!");
													}
												}
											}
											
											decl Float:vec[3];
											GetClientEyePosition(iClient, vec);
											EmitSoundToAll(SOUND_JOCKEYPEE, g_iJockeyVictim[iClient], SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
											EmitSoundToAll(SOUND_JOCKEYPEE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
											
											SDKCall(g_hSDK_VomitOnPlayer, g_iJockeyVictim[iClient], iClient, true);
											CreateTimer(11.0, TimerStopJockeyPee, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
											CreateTimer(11.0, TimerStopJockeyPeeSound, iClient, TIMER_FLAG_NO_MAPCHANGE);
											CreateTimer(11.0, TimerStopJockeyPeeSound, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
											CreateTimer(30.0, TimerEnableJockeyPee, iClient, TIMER_FLAG_NO_MAPCHANGE);
											CreateTimer(20.0, TimerRemovePeeFX, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
											
											if(g_bCanJockeyCloak[iClient] == true)
											{
												SetEntityRenderMode(g_iJockeyVictim[iClient], RenderMode:3);
												SetEntityRenderColor(g_iJockeyVictim[iClient], 200, 255, 0, 255);
												SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_iGlowType", 2);
												SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_nGlowRange", 0);
												SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_glowColorOverride", 10900);	//Yellow-Orange
											}
											else 
											{
												SetEntityRenderMode(g_iJockeyVictim[iClient], RenderMode:3);
												SetEntityRenderColor(g_iJockeyVictim[iClient], 255, 255, 255, RoundToFloor(255 * (1.0 -  (float(g_iUnfairLevel[iClient]) * 0.09))) );
												SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_iGlowType", 3);
												SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_nGlowRange", 0);
												SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_glowColorOverride", 1);
											}
											
											if(IsFakeClient(g_iJockeyVictim[iClient]) == false)
											{
												PrintHintText(g_iJockeyVictim[iClient], "%N is pissing on you!", iClient);
												ShowHudOverlayColor(g_iJockeyVictim[iClient], 255, 255, 0, 65, 2900, FADE_OUT);
											}
											
											if(g_iErraticLevel[iClient] == 10)
											{
												RunCheatCommand(iClient, "z_spawn_old", "z_spawn_old mob auto");
												
												PrintHintText(iClient, "A hoard smells your piss, here they come!");
											}
											
											g_iClientBindUses_1[iClient]++;
										}
								}
								else
									PrintHintText(iClient, "Wait 30 seconds to piss again");
							}
							else
								PrintHintText(iClient, "Your out of piss");
						}
						else
							PrintHintText(iClient, "You must be riding a victim to piss on them");
					}
					else
						PrintHintText(iClient, "You must have Erratic Domination (Level 1) for Jockey Bind 1");
				}
				else
					PrintHintText(iClient, "You dont have the Jockey as one of your classes");
			}
			case 6: //CHARGER
			{
				if((g_iClientInfectedClass1[iClient] == CHARGER) || (g_iClientInfectedClass2[iClient] == CHARGER) || (g_iClientInfectedClass3[iClient] == CHARGER))
				{
					if(g_iSpikedLevel[iClient] > 0)
					{
						if(g_iClientBindUses_1[iClient] < 3)
						{
							if (g_bCanChargerSuperCharge[iClient] == true)
							{
								if(g_bIsSuperCharger[iClient] == false)
								{
									g_bIsSuperCharger[iClient] = true;
									g_bCanChargerSuperCharge[iClient] = false;
									new iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
									if (iEntid > 0)
									{
										new Float:flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+8);
										new Float:flTimeStamp_calc = flTimeStamp_ret - 12.0;
										SetEntDataFloat(iEntid, g_iOffset_NextActivation+8, flTimeStamp_calc, true);
									}
									PrintHintText(iClient, "Your next charge will be a super charge");
								}
								else
									PrintHintText(iClient, "This is already active");
							}
							else
								PrintHintText(iClient, "Wait 30 seconds to super charge again");
						}
						else
							PrintHintText(iClient, "You are out of Super Charges");
					}
					else
						PrintHintText(iClient, "You must have Spiked Carapace (Level 1) for Charger Bind 1");
				}
				else
					PrintHintText(iClient, "You dont have the Charger as one of your classes");
			}
			case 8: //TANK
			{
				PrintToChat(iClient, "not working yet");
			}
			default: //Unknown
			{
				PrintToChat(iClient, "				You cannot use bind 1 as UNKNOWN # %d", g_iInfectedCharacter[iClient]);
			}
		}
	}
	return Plugin_Handled;
}