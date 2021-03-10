void Bind1Press_Nick(iClient)
{
    if(g_iMagnumLevel[iClient] > 0)	//Nick's Actionkey 1
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
						AcceptEntityInput(g_iPrimarySlotID[iClient]);
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
								
								GiveEveryWeaponToSurvivor(iClient);
								// The ones Nick will have after
								RunCheatCommand(iClient, "give", "give rifle_ak47");
								RunCheatCommand(iClient, "give", "give pistol_magnum");
							}
							case 4: //Rambo
							{
								fnc_DeterminePrimaryWeapon(iClient);
								fnc_SaveAmmo(iClient);
								AcceptEntityInput(g_iPrimarySlotID[iClient], "Kill");
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