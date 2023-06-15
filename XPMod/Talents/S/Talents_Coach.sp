TalentsLoad_Coach(iClient)
{
	SetPlayerTalentMaxHealth_Coach(iClient, !g_bSurvivorTalentsGivenThisRound[iClient]);
	SetClientSpeed(iClient);

	if(g_iBullLevel[iClient]>0 || g_iWreckingLevel[iClient]>0 || g_iStrongLevel[iClient]>0)
	{					
		g_iMeleeDamageCounter[iClient] = (g_iStrongLevel[iClient] * 30);
		
		if(g_bSurvivorTalentsGivenThisRound[iClient] == false)
		{
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
	if(g_bSurvivorTalentsGivenThisRound[iClient] == false)
	{
		if(g_iStrongLevel[iClient]>0)
			g_iClientJetpackFuel[iClient] = g_iStrongLevel[iClient] * COACH_JETPACK_FUEL_PER_LEVEL
		
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
			SetCoachesHealthStacks();
			
			if(g_iLeadLevel[iClient] > g_iHighestLeadLevel)	//Find the maximum level for setting the cvars
				g_iHighestLeadLevel = g_iLeadLevel[iClient];			

			g_iScreenShakeAmount -= 10;
			SetSurvivorScreenShakeAmount();
		}
		
		// //Set Convars for all coaches
		// if(g_iHighestLeadLevel>0)
		// {
		// 	/*
		// 	SetConVarInt(FindConVar("chainsaw_attack_force"), 400 + (g_iHighestLeadLevel * 40));
		// 	SetConVarInt(FindConVar("chainsaw_damage"), 100 + (g_iHighestLeadLevel * 10));
		// 	SetConVarFloat(FindConVar("chainsaw_hit_interval"), 0.1 - (float(g_iHighestLeadLevel) * 0.01),false,false);
		// 	*/
		// }
	}
	
	if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Berserker Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilties will be automatically set as you level.");
}

void SetPlayerTalentMaxHealth_Coach(int iClient, bool bFillInHealthGap = true)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != COACH ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;
	
	SetPlayerMaxHealth(iClient, 
	100 + 
	(g_iBullLevel[iClient]*5) + 
	(g_iWreckingLevel[iClient]*5) + 
	(g_iStrongLevel[iClient]*10) + 
	(g_iCoachTeamHealthStack * 5), 
	false, 
	bFillInHealthGap);
}

OnGameFrame_Coach(iClient)
{
	if(g_iStrongLevel[iClient] > 0)
	{
		int buttons;
		buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(clienthanging[iClient] == true)
		{
			if(g_bIsJetpackOn[iClient]==true)
			{
				if(buttons & IN_SPEED)
				{

					RunCheatCommand(iClient, "give", "give health");

					SetPlayerHealth(iClient, -1, preledgehealth[iClient]);
					if(preledgebuffer[iClient] > 1.1)
						SetEntDataFloat(iClient,g_iOffset_HealthBuffer, (preledgebuffer[iClient] - 1.0) ,true);
					else
						SetEntDataFloat(iClient,g_iOffset_HealthBuffer, 0.0 ,true);
					
					g_bIsClientDown[iClient] = false;
					clienthanging[iClient] = false;
				}
			}
		}
		else
		{
			preledgehealth[iClient] = GetClientHealth(iClient);
			preledgebuffer[iClient] = GetEntDataFloat(iClient,g_iOffset_HealthBuffer);
			//PrintToChat(iClient, "%d", preledgehealth[iClient]);
		}

		// Jetpack
		if(g_bIsJetpackOn[iClient] == true)
		{
			if (buttons & IN_SPEED && g_bIsClientDown[iClient] == false && IsClientGrappled(iClient) == false)
			{
				if(canchangemovement[iClient] == true)
					StartFlying(iClient);
			}
			else
			{
				if (g_bIsFlyingWithJetpack[iClient])
					StopFlying(iClient);
				
				if(g_bIsMovementTypeFly[iClient] == true)	//Reset movement type only if they are back on the ground again
				{
					if(canchangemovement[iClient] == true)
					{
						if(GetEntityFlags(iClient) & FL_ONGROUND)
						{
							SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
							g_bIsMovementTypeFly[iClient] = false;
						}
					}
				}
			}
		}

		if(g_bCanCoachGrenadeCycle[iClient] == true)
		{
			if((buttons & IN_SPEED) && (buttons & IN_ZOOM))
			{
				decl String:currentweapon[32];
				GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
				if((StrContains(currentweapon, "vomitjar", false) != -1) || (StrContains(currentweapon, "molotov", false) != -1) || (StrContains(currentweapon, "pipe_bomb", false) != -1))
				{
					if(g_iStrongLevel[iClient] == 2 || g_iStrongLevel[iClient] == 3)
					{
						g_bCanCoachGrenadeCycle[iClient] = false;
						g_bIsCoachInGrenadeCycle[iClient] = true;
						CreateTimer(0.5, TimerCanCoachGrenadeCycleReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
						new ActiveGrenadeID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
						if(g_iCoachCurrentGrenadeSlot[iClient] == 0)
						{
							if(StrContains(g_strCoachGrenadeSlot2, "vomitjar", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 1;

								RunCheatCommand(iClient, "give", "give vomitjar");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "molotov", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 1;

								RunCheatCommand(iClient, "give", "give molotov");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "pipe_bomb", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 1;

								RunCheatCommand(iClient, "give", "give pipe_bomb");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1)
							{
								//PrintToChatAll("The next grenade slot is empty");
							}
						}
						else if(g_iCoachCurrentGrenadeSlot[iClient] == 1)
						{
							if(StrContains(g_strCoachGrenadeSlot1, "vomitjar", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 0;

								RunCheatCommand(iClient, "give", "give vomitjar");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "molotov", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 0;

								RunCheatCommand(iClient, "give", "give molotov");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "pipe_bomb", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 0;

								RunCheatCommand(iClient, "give", "give pipe_bomb");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1)
							{
								//PrintToChatAll("The next grenade slot is empty");
							}
						}
					}
					if(g_iStrongLevel[iClient] == 4 || g_iStrongLevel[iClient] == 5)
					{
						g_bCanCoachGrenadeCycle[iClient] = false;
						g_bIsCoachInGrenadeCycle[iClient] = true;
						CreateTimer(0.5, TimerCanCoachGrenadeCycleReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
						new ActiveGrenadeID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
						if(g_iCoachCurrentGrenadeSlot[iClient] == 0)
						{
							if(StrContains(g_strCoachGrenadeSlot2, "vomitjar", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 1;

								RunCheatCommand(iClient, "give", "give vomitjar");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "molotov", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 1;

								RunCheatCommand(iClient, "give", "give molotov");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "pipe_bomb", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 1;

								RunCheatCommand(iClient, "give", "give pipe_bomb");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1)
							{
								//PrintToChatAll("Grenade Slot 2 is empty");
								if(StrContains(g_strCoachGrenadeSlot3, "vomitjar", false) != -1)
								{
									if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
										AcceptEntityInput(ActiveGrenadeID, "Kill");
									g_iCoachCurrentGrenadeSlot[iClient] = 2;

									RunCheatCommand(iClient, "give", "give vomitjar");
								}
								else if(StrContains(g_strCoachGrenadeSlot3, "molotov", false) != -1)
								{
									if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
										AcceptEntityInput(ActiveGrenadeID, "Kill");
									g_iCoachCurrentGrenadeSlot[iClient] = 2;

									RunCheatCommand(iClient, "give", "give molotov");
								}
								else if(StrContains(g_strCoachGrenadeSlot3, "pipe_bomb", false) != -1)
								{
									if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
										AcceptEntityInput(ActiveGrenadeID, "Kill");
									g_iCoachCurrentGrenadeSlot[iClient] = 2;

									RunCheatCommand(iClient, "give", "give pipe_bomb");
								}
							}
						}
						else if(g_iCoachCurrentGrenadeSlot[iClient] == 1)
						{
							if(StrContains(g_strCoachGrenadeSlot3, "vomitjar", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 2;

								RunCheatCommand(iClient, "give", "give vomitjar");
							}
							else if(StrContains(g_strCoachGrenadeSlot3, "molotov", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 2;

								RunCheatCommand(iClient, "give", "give molotov");
							}
							else if(StrContains(g_strCoachGrenadeSlot3, "pipe_bomb", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 2;

								RunCheatCommand(iClient, "give", "give pipe_bomb");
							}
							else if(StrContains(g_strCoachGrenadeSlot3, "empty", false) != -1)
							{
								//PrintToChatAll("Grenade Slot 3 is empty");
								if(StrContains(g_strCoachGrenadeSlot1, "vomitjar", false) != -1)
								{
									if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
										AcceptEntityInput(ActiveGrenadeID, "Kill");
									g_iCoachCurrentGrenadeSlot[iClient] = 0;

									RunCheatCommand(iClient, "give", "give vomitjar");
								}
								else if(StrContains(g_strCoachGrenadeSlot1, "molotov", false) != -1)
								{
									if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
										AcceptEntityInput(ActiveGrenadeID, "Kill");
									g_iCoachCurrentGrenadeSlot[iClient] = 0;

									RunCheatCommand(iClient, "give", "give molotov");
								}
								else if(StrContains(g_strCoachGrenadeSlot1, "pipe_bomb", false) != -1)
								{
									if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
										AcceptEntityInput(ActiveGrenadeID, "Kill");
									g_iCoachCurrentGrenadeSlot[iClient] = 0;

									RunCheatCommand(iClient, "give", "give pipe_bomb");
								}
							}
						}
						else if(g_iCoachCurrentGrenadeSlot[iClient] == 2)
						{
							if(StrContains(g_strCoachGrenadeSlot1, "vomitjar", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 0;

								RunCheatCommand(iClient, "give", "give vomitjar");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "molotov", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 0;

								RunCheatCommand(iClient, "give", "give molotov");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "pipe_bomb", false) != -1)
							{
								if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
									AcceptEntityInput(ActiveGrenadeID, "Kill");
								g_iCoachCurrentGrenadeSlot[iClient] = 0;

								RunCheatCommand(iClient, "give", "give pipe_bomb");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1)
							{
								//PrintToChatAll("Grenade Slot 1 is empty");
								if(StrContains(g_strCoachGrenadeSlot2, "vomitjar", false) != -1)
								{
									if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
										AcceptEntityInput(ActiveGrenadeID, "Kill");
									g_iCoachCurrentGrenadeSlot[iClient] = 1;

									RunCheatCommand(iClient, "give", "give vomitjar");
								}
								else if(StrContains(g_strCoachGrenadeSlot2, "molotov", false) != -1)
								{
									if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
										AcceptEntityInput(ActiveGrenadeID, "Kill");
									g_iCoachCurrentGrenadeSlot[iClient] = 1;

									RunCheatCommand(iClient, "give", "give molotov");
								}
								else if(StrContains(g_strCoachGrenadeSlot2, "pipe_bomb", false) != -1)
								{
									if (ActiveGrenadeID > 0 && IsValidEntity(ActiveGrenadeID))
										AcceptEntityInput(ActiveGrenadeID, "Kill");
									g_iCoachCurrentGrenadeSlot[iClient] = 1;

									RunCheatCommand(iClient, "give", "give pipe_bomb");
								}
							}
						}
					}
				}
			}
		}
	}
	if(g_iWreckingLevel[iClient] > 0 && g_bIsFlyingWithJetpack[iClient] == false && g_bIsClientDown[iClient] == false && IsClientGrappled(iClient) == false)		//Wrecking ball charge up
	{
		int buttons;
		buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(g_iWreckingLevel[iClient] == 5)
		{
			if(g_bCoachRageIsInCooldown[iClient] == false)
			{
				// Check that they are holding crouch and on the ground
				if(buttons & IN_DUCK && (GetEntityFlags(iClient) & FL_ONGROUND))
				{
					g_iCoachHealthRechargeCounter[iClient]++;
					
					if(g_bShowingChargeHealParticle[iClient] == false)
					{
						g_iPID_CoachMeleeChargeHeal[iClient] = WriteParticle(iClient,"coach_melee_charge_heal", 0.0);
						g_bShowingChargeHealParticle[iClient] = true;
					}
					
					if(g_iCoachHealthRechargeCounter[iClient] > 15)
					{
						g_iCoachHealthRechargeCounter[iClient] = 0;
						new currentHP=GetPlayerHealth(iClient);
						new maxHP = GetPlayerMaxHealth(iClient);
						if(currentHP < (maxHP - 1))
							SetPlayerHealth(iClient, -1, currentHP + 1);
						else if(currentHP >= (maxHP - 1))
							SetPlayerHealth(iClient, -1, maxHP);
					}
				}
				else
				{
					g_iCoachHealthRechargeCounter[iClient] = 0;
					DeleteParticleEntity(g_iPID_CoachMeleeChargeHeal[iClient]);
					g_bShowingChargeHealParticle[iClient] = false;
				}
			}
		}
		if(g_bIsWreckingBallCharged[iClient]==false)
		{
			if(buttons & IN_DUCK && (GetEntityFlags(iClient) & FL_ONGROUND))
			{
				g_iWreckingBallChargeCounter[iClient]++;
				if(g_iWreckingBallChargeCounter[iClient]==20)
				{
					PrintHintText(iClient, "Charging Melee Attack");
					//play sound and particle for charging here
				}
				if(g_iWreckingBallChargeCounter[iClient]>90)
				{
					g_iWreckingBallChargeCounter[iClient] = 0;
					g_bIsWreckingBallCharged[iClient] = true;
					new Float:vec[3];
					GetClientAbsOrigin(iClient, vec);
					new rand = GetRandomInt(1, 3);
					switch(rand)
					{
						case 1: EmitSoundToAll(SOUND_COACH_CHARGE1, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
						case 2: EmitSoundToAll(SOUND_COACH_CHARGE2, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
						case 3: EmitSoundToAll(SOUND_COACH_CHARGE3, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
					}
					
					g_iPID_CoachMeleeCharge1[iClient] = CreateParticle("coach_melee_charge_wepbone", 0.0, iClient, ATTACH_WEAPON_BONE);
					g_iPID_CoachMeleeCharge2[iClient] = CreateParticle("coach_melee_charge_muzbone", 0.0, iClient, ATTACH_MUZZLE_FLASH);
					//WriteParticle(iClient, "coach_melee_charge_arms", 0.0, 3.0);
					PrintHintText(iClient, "Melee Attack Charged!");
					//play sound and particle for charged here
				}
			}
			else
			{
				if(g_iWreckingBallChargeCounter[iClient] > 0)
				{
					PrintHintText(iClient, "Melee attack was not charged long enough");
					g_iWreckingBallChargeCounter[iClient] = 0;
				}
			}
		}
	}
	if(g_iBullLevel[iClient] > 0)
	{
		int buttons;
		buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(!(buttons & IN_SPEED) || !(buttons & IN_USE))
			g_bWalkAndUseToggler[iClient] = false;
		if((g_bWalkAndUseToggler[iClient] == false) && ((buttons & IN_SPEED) && (buttons & IN_USE)))
		{
			g_bWalkAndUseToggler[iClient] = true;
			if(g_bCoachRageIsAvailable[iClient] == true)
			{
				g_iCoachRageMeleeDamage[iClient] = (g_iBullLevel[iClient] * 40);
				CreateTimer(20.0, TimerCoachRageReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
				if(g_iCoachRageRegenCounter[iClient] < 2)
				{
					new currentHP = GetPlayerHealth(iClient);
					new maxHP = GetPlayerMaxHealth(iClient);
					if(currentHP < (maxHP - 5))
						SetPlayerHealth(iClient, -1, currentHP + 5);
					else if(currentHP >= (maxHP - 5))
						SetPlayerHealth(iClient, -1, maxHP);
				}
				else if(g_iCoachRageRegenCounter[iClient] < 5)
				{
					new currentHP = GetPlayerHealth(iClient);
					new maxHP = GetPlayerMaxHealth(iClient);
					if(currentHP < (maxHP - 4))
						SetPlayerHealth(iClient, -1, currentHP + 4);
					else if(currentHP >= (maxHP - 4))
						SetPlayerHealth(iClient, -1, maxHP);
				}
				else if(g_iCoachRageRegenCounter[iClient] < 9)
				{
					new currentHP = GetPlayerHealth(iClient);
					new maxHP = GetPlayerMaxHealth(iClient);
					if(currentHP < (maxHP - 3))
						SetPlayerHealth(iClient, -1, currentHP + 3);
					else if(currentHP >= (maxHP - 3))
						SetPlayerHealth(iClient, -1, maxHP);
				}
				else if(g_iCoachRageRegenCounter[iClient] < 14)
				{
					new currentHP = GetPlayerHealth(iClient);
					new maxHP = GetPlayerMaxHealth(iClient);
					if(currentHP < (maxHP - 2))
						SetPlayerHealth(iClient, -1, currentHP + 2);
					else if(currentHP >= (maxHP - 2))
						SetPlayerHealth(iClient, -1, maxHP);
				}
				else
				{
					new currentHP = GetPlayerHealth(iClient);
					new maxHP = GetPlayerMaxHealth(iClient);
					if(currentHP < (maxHP - 1))
						SetPlayerHealth(iClient, -1, currentHP + 1);
					else if(currentHP >= (maxHP - 1))
						SetPlayerHealth(iClient, -1, maxHP);
				}
				g_iCoachRageRegenCounter[iClient]++;
				CreateTimer(1.0, TimerCoachRageRegenTick, iClient, TIMER_FLAG_NO_MAPCHANGE);
				g_bCoachRageIsAvailable[iClient] = false;
				g_bCoachRageIsActive[iClient] = true;
				
				SetClientSpeed(iClient);

				PrintHintText(iClient, "You are now RAGING!");
			}
			else if(g_bCoachRageIsInCooldown[iClient] == true)
				PrintHintText(iClient, "Rage is still cooling down");
		}
	}
	if(g_iSprayLevel[iClient] > 0)
	{
		int buttons;
		buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if((buttons & IN_RELOAD) && g_bCoachShotgunForceReload[iClient] == false && g_bClientIsReloading[iClient] == false)
		{
			decl String:currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (IsValidEntity(ActiveWeaponID) == false)
				return;
			new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			
			if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true)) && (CurrentClipAmmo > 7) && (CurrentClipAmmo <= (7 + (g_iSprayLevel[iClient] * 2))))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
				if(iAmmo > 0)
				{
					g_bCoachShotgunForceReload[iClient] = true;
					g_iCoachShotgunSavedAmmo[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_ClipShotgun, 0, true);
				}
			}
			if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (CurrentClipAmmo > 9) && (CurrentClipAmmo <= (9 + (g_iSprayLevel[iClient] * 2))))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
				if(iAmmo > 0)
				{
					g_bCoachShotgunForceReload[iClient] = true;
					g_iCoachShotgunSavedAmmo[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_ClipShotgun, 0, true);
				}
			}
		}
	}
}

OGFSurvivorReload_Coach(iClient, const char[] currentweapon, ActiveWeaponID, CurrentClipAmmo, iOffset_Ammo)
{
	if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true)) && (g_iSprayLevel[iClient] > 0))
	{
		/*
		if(g_bCoachShotgunForceReload[iClient] == true)
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iCoachShotgunSavedAmmo[iClient], true);
			//PrintToChatAll("g_iOffset_Clip1 %d", g_iOffset_Clip1);
			//PrintToChatAll("g_iCoachShotgunSavedAmmo %d", g_iCoachShotgunSavedAmmo[iClient]);
			g_bCoachShotgunForceReload[iClient] = false;
		}
		*/
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
		if(g_iReloadFrameCounter[iClient] == 1)
		{
			if(iAmmo >= ((8 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, ((g_iSprayLevel[iClient] * 2) + 8) - CurrentClipAmmo, true);
				//PrintToChatAll("g_iOffset_ReloadNumShells");
			}
			else if(iAmmo < ((8 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, iAmmo, true);
			}
		}
		if((CurrentClipAmmo == (8 + (g_iSprayLevel[iClient] * 2))) || (CurrentClipAmmo == (CurrentClipAmmo + iAmmo)))
		{
			g_bCoachShotgunForceReload[iClient] = false;
			g_bClientIsReloading[iClient] = false;
			g_iReloadFrameCounter[iClient] = 0;
			SetEntData(ActiveWeaponID, g_bOffset_InReload, 0, true);
			SetEntData(iClient, g_bOffset_InReload, 0, true);
		}		
	}
	else if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (g_iSprayLevel[iClient] > 0))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
		if(g_iReloadFrameCounter[iClient] == 1)
		{
			if(iAmmo >= ((10 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, ((g_iSprayLevel[iClient] * 2) + 10) - CurrentClipAmmo, true);
				//PrintToChatAll("g_iOffset_ReloadNumShells");
			}
			else if(iAmmo < ((10 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, iAmmo, true);
			}
		}
		if((CurrentClipAmmo == (10 + (g_iSprayLevel[iClient] * 2))) || (CurrentClipAmmo == (CurrentClipAmmo + iAmmo)))
		{
			
			// new InReload = GetEntData(iClient, g_bOffset_InReload + 32);
			// new InReloadWep = GetEntData(ActiveWeaponID, g_bOffset_InReload + 32);
			// PrintToChatAll("InReload %d", InReload);
			// PrintToChatAll("InReloadWep %d", InReloadWep);
			
			g_bCoachShotgunForceReload[iClient] = false;
			g_bClientIsReloading[iClient] = false;
			g_iReloadFrameCounter[iClient] = 0;
			SetEntData(ActiveWeaponID, g_bOffset_InReload, 0, true);
			SetEntData(iClient, g_bOffset_InReload, 0, true);
		}
	}
}

EventsHurt_AttackerCoach(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(attacker))
		return;

	if (g_iClientTeam[victim] != TEAM_INFECTED)
		return;

	if (g_iMeleeDamageCounter[attacker] > 0 || 
		g_iSprayLevel[attacker]>0 || 
		g_bIsWreckingBallCharged[attacker]==true || 
		g_bCoachRageIsActive[attacker] == true)
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
				new hp = GetPlayerHealth(victim);
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
				SetPlayerHealth(victim, attacker, hp - ((g_iWreckingLevel[attacker]*100) + g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
			}
			else if(g_iMeleeDamageCounter[attacker]>0)
			{
				new hp = GetPlayerHealth(victim);
				//new dmg = GetEventInt(hEvent,"dmg_health");
				//PrintToChat(attacker, "predmg = %d", dmg);
				//dmg = g_iMeleeDamageCounter[attacker];
				//PrintToChat(attacker, "\x03[XPMod] \x05You did %d extra melee damage", (g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
				SetPlayerHealth(victim, attacker, hp - (g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
			}
			
			if(g_bCoachRageIsActive[attacker] == true)
			{
				new hp = GetPlayerHealth(victim);
				//PrintToChat(attacker, "\x03[XPMod] \x05You did %d extra melee damage", g_iCoachRageMeleeDamage[attacker]);
				SetPlayerHealth(victim, attacker, hp - g_iCoachRageMeleeDamage[attacker]);
			}
		}
		if(g_iSprayLevel[attacker] > 0 && StrContains(weaponclass,"shotgun",false) != -1)
		{
			new hp = GetPlayerHealth(victim);
			//new dmg = GetEventInt(hEvent,"dmg_health");
			//dmg = dmg + (g_iSprayLevel[attacker] * 2);
			//PrintToChat(attacker, "your doing %d shotgun damage", (g_iSprayLevel[attacker] * 2));
			SetPlayerHealth(victim, attacker, hp - CalculateDamageTakenForVictimTalents(victim, (g_iSprayLevel[attacker] * 2), weaponclass));
		}
	}
}

// EventsHurt_VictimCoach(Handle:hEvent, attacker, victim)
// {
// 	if (IsFakeClient(victim))
// 		return;
// }

EventsDeath_AttackerCoach(Handle:hEvent, iAttacker, iVictim)
{
	if (g_iChosenSurvivor[iAttacker] != COACH ||
		g_bTalentsConfirmed[iAttacker] == false ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		RunClientChecks(iAttacker) == false ||
		IsFakeClient(iAttacker) == true)
		return;

	decl String:weaponclass[32];
	GetEventString(hEvent,"weapon",weaponclass,32);
	//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);

	// Ensure that its a infected for his headshot speed boosts
	if (GetEventBool(hEvent, "headshot") &&
		g_bCoachRageIsInCooldown[iAttacker] == false &&
		StrContains(weaponclass,"melee",false) != -1)
	{
		// CI Headshot
		if (iVictim < 1)
		{
			// Bull Rush CI headshot boost
			if (g_iBullLevel[iAttacker] > 0)
			{
				g_iCoachCIHeadshotCounter[iAttacker]++;
				if(g_bCoachInCISpeed[iAttacker] == false)
				{
					g_bCoachInCISpeed[iAttacker] = true;
					SetClientSpeed(iAttacker);
					CreateTimer(5.0, TimerCoachCIHeadshotSpeedReset, iAttacker, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
		
		// SI Headshot
		if (iVictim > 0)
		{
			if (g_iHomerunLevel[iAttacker] > 0)
				GiveExtraAmmoForCurrentShotgun(iAttacker, COACH_CLIP_GAINED_PER_SI_DECAP);
			
			if (g_iHomerunLevel[iAttacker] > 0 && g_bCoachInSISpeed[iAttacker] == false)
			{
				g_iCoachSIHeadshotCounter[iAttacker]++;
				g_bCoachInSISpeed[iAttacker] = true;
				SetClientSpeed(iAttacker);
				CreateTimer(10.0, TimerCoachSIHeadshotSpeedReset, iAttacker, TIMER_FLAG_NO_MAPCHANGE);
			}

			if(g_bWreckingChargeRetrigger[iAttacker] == true)
				CreateTimer(0.5, TimerWreckingChargeRetrigger, iAttacker, TIMER_FLAG_NO_MAPCHANGE);
		}
	}	
}

EventsDeath_VictimCoach(Handle:hEvent, iAttacker, iVictim)
{
	if (g_iChosenSurvivor[iVictim] != COACH ||
		g_bTalentsConfirmed[iVictim] == false ||
		g_iClientTeam[iVictim] != TEAM_SURVIVORS ||
		RunClientChecks(iVictim) == false ||
		IsFakeClient(iVictim) == true)
		return;
	
	SuppressNeverUsedWarning(hEvent, iAttacker);

	// Handle the sound if his Jetpack if its still on
	if (g_iStrongLevel[iVictim] > 0 && g_bIsJetpackOn[iVictim])
		StopSound(iVictim, SNDCHAN_AUTO, SOUND_JPIDLEREV);
}


//Coach's Jetpack stuff
Action:StartFlying(iClient)
{
	if(g_bIsFlyingWithJetpack[iClient]==false)
	{
		SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
		g_bIsMovementTypeFly[iClient] = true;
		StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
		new Float:vec[3];
		GetClientAbsOrigin(iClient, vec);
		EmitSoundToAll(SOUND_JPHIGHREV, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
		g_iPID_CoachJetpackStream[iClient] = WriteParticle(iClient, "jetpack_stream", 0.0);
		//g_iPID_CoachJetpackStream[iClient] = CreateParticle("jetpack_stream", 0.0, iClient, ATTACH_SURVIVOR_LIGHT);
	}

	g_iClientJetpackFuel[iClient]--;
	PrintCoachJetpackFuelGauge(iClient);

	AddUpwardVelocity(iClient, 50.0);
	g_bIsFlyingWithJetpack[iClient]=true;
	if(g_iClientJetpackFuel[iClient] <= 0)
	{
		CreateTimer(0.5, DeleteParticle, g_iPID_CoachJetpackStream[iClient], TIMER_FLAG_NO_MAPCHANGE);
		StopSound(iClient, SNDCHAN_AUTO, SOUND_JPHIGHREV);
		StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
		new Float:vec[3];
		GetClientAbsOrigin(iClient, vec);
		EmitSoundToAll(SOUND_JPDIE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
		g_bIsJetpackOn[iClient] = false;
		g_bIsFlyingWithJetpack[iClient] = false;
		SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
		g_iClientJetpackFuel[iClient] = 0;
		PrintCoachJetpackFuelGauge(iClient);
	}

	return Plugin_Continue;
}

Action:StopFlying(iClient)
{
	g_bIsFlyingWithJetpack[iClient]=false;
	CreateTimer(0.5, DeleteParticle, g_iPID_CoachJetpackStream[iClient], TIMER_FLAG_NO_MAPCHANGE);
	StopSound(iClient, SNDCHAN_AUTO, SOUND_JPHIGHREV);
	new Float:vec[3];
	GetClientAbsOrigin(iClient, vec);
	EmitSoundToAll(SOUND_JPIDLEREV, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
	return Plugin_Continue;
}

AddUpwardVelocity(iClient, Float:speed)
{
	new Float:vecVelocity[3];
	GetEntDataVector(iClient, g_iOffset_VecVelocity, vecVelocity);

	if ((vecVelocity[2]+speed) > 250.0)
		vecVelocity[2] = 250.0;
	else
		vecVelocity[2] += speed;

	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vecVelocity);
}

//Find the number of coaches and set the health stack to that
SetCoachesHealthStacks()
{
	g_iCoachTeamHealthStack = 0;

	//Find the number of confirmed talent coaches and add it up
	for(int i=1 ; i <= MaxClients; i++)
		if (g_bTalentsConfirmed[i] == true &&
			g_iChosenSurvivor[i] == COACH &&
			g_iLeadLevel[i] > 0 &&
			RunClientChecks(i) &&
			IsPlayerAlive(i) == true &&
			g_iClientTeam[i]==TEAM_SURVIVORS)
			g_iCoachTeamHealthStack += g_iLeadLevel[i];
	
	// Cap this at 1 Coach (remove stacking)
	if (g_iCoachTeamHealthStack > 5)
		g_iCoachTeamHealthStack = 5;

	//Set Max Health for all survivors higher
	for(int i=1; i <= MaxClients; i++)
	{
		if (RunClientChecks(i) == false ||
			IsPlayerAlive(i) == false ||
			g_iClientTeam[i] != TEAM_SURVIVORS)
			continue;
		
		SetAppropriateMaxHealthForPlayer(i, true);
	}
}

GiveExtraAmmoForCurrentShotgun(int iClient, int iAmmoToGive = 1)
{
	int iActiveWeaponID = GetPlayerWeaponSlot(iClient, 0);
	if (RunEntityChecks(iActiveWeaponID) == false)
		return;

	int iWeaponIndex = FindWeaponItemIndexOfWeaponID(iClient, iActiveWeaponID);
	if (iWeaponIndex == ITEM_EMPTY)
		return;

	int iCurrentClipAmmo = GetEntProp(iActiveWeaponID,Prop_Data,"m_iClip1");

	// Check if its a shotgun
	if (iWeaponIndex < ITEM_REMINGTON_870 || iWeaponIndex > ITEM_FRANCHI_SPAS_12)
		return;

	int iBaseMaxClipAmmo = 0;
	// int iWeaponOffset = 0;
	if (iWeaponIndex == ITEM_REMINGTON_870 || iWeaponIndex == ITEM_REMINGTON_870_CUSTOM)
		iBaseMaxClipAmmo = 8;
	else if (iWeaponIndex == ITEM_BENELLI_M1014 || iWeaponIndex == ITEM_FRANCHI_SPAS_12)
		iBaseMaxClipAmmo = 10;
	int iNewAmmo =  iCurrentClipAmmo + iAmmoToGive < (iBaseMaxClipAmmo + (g_iSprayLevel[iClient] * 2)) ? iCurrentClipAmmo + iAmmoToGive : iBaseMaxClipAmmo + (g_iSprayLevel[iClient] * 2);
	
	SetEntData(iActiveWeaponID, g_iOffset_ClipShotgun, iNewAmmo, 4, true);
}