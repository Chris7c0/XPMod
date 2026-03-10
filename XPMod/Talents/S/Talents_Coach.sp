void TalentsLoad_Coach(int iClient)
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

void OnGameFrame_Coach(int iClient)
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
		}

		if (g_bIsFlyingWithJetpack[iClient] == true ||
			g_bIsMovementTypeFly[iClient] == true)
			RefreshAbilityImpactDamageImmunity(iClient);

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
							GiveAbilityImpactDamageGracePeriod(iClient);
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
				char currentweapon[32];
				GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
				if((StrContains(currentweapon, "vomitjar", false) != -1) || (StrContains(currentweapon, "molotov", false) != -1) || (StrContains(currentweapon, "pipe_bomb", false) != -1))
				{
					if(g_iStrongLevel[iClient] == 2 || g_iStrongLevel[iClient] == 3)
					{
						g_bCanCoachGrenadeCycle[iClient] = false;
						g_bIsCoachInGrenadeCycle[iClient] = true;
						CreateTimer(0.5, TimerCanCoachGrenadeCycleReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
						int ActiveGrenadeID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
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
						}
					}
					if(g_iStrongLevel[iClient] == 4 || g_iStrongLevel[iClient] == 5)
					{
						g_bCanCoachGrenadeCycle[iClient] = false;
						g_bIsCoachInGrenadeCycle[iClient] = true;
						CreateTimer(0.5, TimerCanCoachGrenadeCycleReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
						int ActiveGrenadeID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
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
						int currentHP = GetPlayerHealth(iClient);
						int maxHP = GetPlayerMaxHealth(iClient);
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
					float vec[3];
					GetClientAbsOrigin(iClient, vec);
					int rand = GetRandomInt(1, 3);
					switch(rand)
					{
						case 1: EmitSoundToAll(SOUND_COACH_CHARGE1, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
						case 2: EmitSoundToAll(SOUND_COACH_CHARGE2, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
						case 3: EmitSoundToAll(SOUND_COACH_CHARGE3, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
					}
					
					g_iPID_CoachMeleeCharge1[iClient] = CreateParticle("coach_melee_charge_wepbone", 0.0, iClient, ATTACH_WEAPON_BONE);
					g_iPID_CoachMeleeCharge2[iClient] = CreateParticle("coach_melee_charge_muzbone", 0.0, iClient, ATTACH_MUZZLE_FLASH);
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
	// Wrecking Ball Lunge - performed from OnPlayerRunCmd_Coach when right-click detected
	if(g_bCoachLungeTriggered[iClient] == true)
	{
		g_bCoachLungeTriggered[iClient] = false;

		// Find lunge target - prioritize crosshair target, then closest in front
		float xyzClientPos[3];
		GetClientAbsOrigin(iClient, xyzClientPos);

		float fClosestDist = COACH_LUNGE_RANGE + 1.0;
		float xyzClosestTarget[3];
		bool bFoundTarget = false;

		// First check: is there a target directly in the crosshair?
		int iAimTarget = GetClientAimTarget(iClient, false);
		if(iAimTarget > 0 && IsValidEntity(iAimTarget))
		{
			bool bValidAimTarget = false;
			float xyzAimPos[3];

			// Check if aim target is an SI player (must be below 30% health)
			if(iAimTarget <= MaxClients && RunClientChecks(iAimTarget) && IsPlayerAlive(iAimTarget) && g_iClientTeam[iAimTarget] == TEAM_INFECTED)
			{
				int iSIHealth = GetPlayerHealth(iAimTarget);
				int iSIMaxHealth = GetPlayerMaxHealth(iAimTarget);
				if(iSIMaxHealth > 0 && float(iSIHealth) / float(iSIMaxHealth) < 0.30)
				{
					GetClientAbsOrigin(iAimTarget, xyzAimPos);
					bValidAimTarget = true;
				}
			}
			// Check if aim target is a CI entity
			else if(iAimTarget > MaxClients)
			{
				char strAimClassName[32];
				GetEntityClassname(iAimTarget, strAimClassName, sizeof(strAimClassName));
				if(StrEqual(strAimClassName, "infected") && GetEntProp(iAimTarget, Prop_Data, "m_iHealth") > 0)
				{
					GetEntPropVector(iAimTarget, Prop_Send, "m_vecOrigin", xyzAimPos);
					bValidAimTarget = true;
				}
			}

			if(bValidAimTarget)
			{
				float fAimDist = GetVectorDistance(xyzClientPos, xyzAimPos);
				if(fAimDist <= COACH_LUNGE_RANGE)
				{
					fClosestDist = fAimDist;
					xyzClosestTarget = xyzAimPos;
					bFoundTarget = true;
				}
			}
		}

		// Fallback: find closest infected in front of player
		if(bFoundTarget == false)
		{
			// Get player's facing direction (horizontal only)
			float xyzEyeAngles[3], vFacing[3];
			GetClientEyeAngles(iClient, xyzEyeAngles);
			GetAngleVectors(xyzEyeAngles, vFacing, NULL_VECTOR, NULL_VECTOR);
			vFacing[2] = 0.0;
			NormalizeVector(vFacing, vFacing);

			// SI only via crosshair (handled above), fallback only checks CI

			// Check CI entities
			for(int iEntity = MaxClients + 1; iEntity < MAXENTITIES; iEntity++)
			{
				if(IsValidEntity(iEntity) == false)
					continue;
				if(HasEntProp(iEntity, Prop_Send, "m_vecOrigin") == false)
					continue;

				char strClassName[32];
				GetEntityClassname(iEntity, strClassName, sizeof(strClassName));
				if(StrEqual(strClassName, "infected") == false)
					continue;
				if(GetEntProp(iEntity, Prop_Data, "m_iHealth") <= 0)
					continue;

				float xyzEntityPos[3];
				GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", xyzEntityPos);

				float vToTarget[3];
				SubtractVectors(xyzEntityPos, xyzClientPos, vToTarget);
				vToTarget[2] = 0.0;
				NormalizeVector(vToTarget, vToTarget);
				if(GetVectorDotProduct(vFacing, vToTarget) < 0.5)
					continue;

				float fDist = GetVectorDistance(xyzClientPos, xyzEntityPos);
				if(fDist < fClosestDist)
				{
					fClosestDist = fDist;
					xyzClosestTarget = xyzEntityPos;
					bFoundTarget = true;
				}
			}
		}

		PrintToChat(iClient, "\x03[Lunge Debug] \x05Target: %s | Dist: %.1f", bFoundTarget ? "YES" : "NO", fClosestDist);

		// Teleport to right in front of the closest target (only if not already in melee range)
		if(bFoundTarget && fClosestDist > COACH_LUNGE_MIN_DISTANCE)
		{
			float vDirection[3];
			SubtractVectors(xyzClosestTarget, xyzClientPos, vDirection);
			vDirection[2] = 0.0;
			NormalizeVector(vDirection, vDirection);

			// Teleport to COACH_LUNGE_STOP_DISTANCE units away from target
			float xyzTeleportPos[3];
			xyzTeleportPos[0] = xyzClosestTarget[0] - (vDirection[0] * COACH_LUNGE_STOP_DISTANCE);
			xyzTeleportPos[1] = xyzClosestTarget[1] - (vDirection[1] * COACH_LUNGE_STOP_DISTANCE);
			xyzTeleportPos[2] = xyzClosestTarget[2] + 10.0;  // Slightly above ground level at target

			// Check line of sight from player to destination (no walls in the way)
			float xyzEyePos[3];
			GetClientEyePosition(iClient, xyzEyePos);
			Handle hLOSTrace = TR_TraceRayFilterEx(xyzEyePos, xyzTeleportPos, MASK_PLAYERSOLID, RayType_EndPoint, TraceFilter_NotSelf, iClient);
			bool bWallBlocked = TR_DidHit(hLOSTrace);
			CloseHandle(hLOSTrace);

			// Check if the destination is clear using a hull trace (survivor bounding box)
			bool bDestBlocked = false;
			if(bWallBlocked == false)
			{
				float vHullMins[3], vHullMaxs[3], vEndPos[3];
				vHullMins[0] = -16.0; vHullMins[1] = -16.0; vHullMins[2] = 0.0;
				vHullMaxs[0] = 16.0;  vHullMaxs[1] = 16.0;  vHullMaxs[2] = 72.0;
				vEndPos = xyzTeleportPos;
				vEndPos[2] += 1.0;

				Handle hHullTrace = TR_TraceHullFilterEx(xyzTeleportPos, vEndPos, vHullMins, vHullMaxs, MASK_PLAYERSOLID, TraceFilter_NotSelf, iClient);
				bDestBlocked = TR_DidHit(hHullTrace);
				CloseHandle(hHullTrace);
			}

			if(bWallBlocked || bDestBlocked)
			{
				PrintToChat(iClient, "\x03[Lunge Debug] \x05Blocked by geometry, cannot lunge");
				g_bCoachLungeOnCooldown[iClient] = false;
			}
			else
			{
				float vZeroVelocity[3];
				vZeroVelocity[0] = 0.0;
				vZeroVelocity[1] = 0.0;
				vZeroVelocity[2] = 0.0;

				// Keep current pitch, only change yaw to face target
				float vCurrentAngles[3];
				GetClientEyeAngles(iClient, vCurrentAngles);
				float vAimAngles[3];
				vAimAngles[0] = vCurrentAngles[0];  // Keep existing pitch (up/down)
				vAimAngles[1] = RadToDeg(ArcTangent2(vDirection[1], vDirection[0]));  // Yaw: face target
				vAimAngles[2] = 0.0;

				TeleportEntity(iClient, xyzTeleportPos, vAimAngles, vZeroVelocity);

				PrintToChat(iClient, "\x03[Lunge Debug] \x04LUNGED! Dist: %.1f", fClosestDist);
			}

			g_bCoachLungeOnCooldown[iClient] = true;
			CreateTimer(COACH_LUNGE_COOLDOWN_DURATION, TimerCoachLungeCooldownReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
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
					int currentHP = GetPlayerHealth(iClient);
					int maxHP = GetPlayerMaxHealth(iClient);
					if(currentHP < (maxHP - 5))
						SetPlayerHealth(iClient, -1, currentHP + 5);
					else if(currentHP >= (maxHP - 5))
						SetPlayerHealth(iClient, -1, maxHP);
				}
				else if(g_iCoachRageRegenCounter[iClient] < 5)
				{
					int currentHP = GetPlayerHealth(iClient);
					int maxHP = GetPlayerMaxHealth(iClient);
					if(currentHP < (maxHP - 4))
						SetPlayerHealth(iClient, -1, currentHP + 4);
					else if(currentHP >= (maxHP - 4))
						SetPlayerHealth(iClient, -1, maxHP);
				}
				else if(g_iCoachRageRegenCounter[iClient] < 9)
				{
					int currentHP = GetPlayerHealth(iClient);
					int maxHP = GetPlayerMaxHealth(iClient);
					if(currentHP < (maxHP - 3))
						SetPlayerHealth(iClient, -1, currentHP + 3);
					else if(currentHP >= (maxHP - 3))
						SetPlayerHealth(iClient, -1, maxHP);
				}
				else if(g_iCoachRageRegenCounter[iClient] < 14)
				{
					int currentHP = GetPlayerHealth(iClient);
					int maxHP = GetPlayerMaxHealth(iClient);
					if(currentHP < (maxHP - 2))
						SetPlayerHealth(iClient, -1, currentHP + 2);
					else if(currentHP >= (maxHP - 2))
						SetPlayerHealth(iClient, -1, maxHP);
				}
				else
				{
					int currentHP = GetPlayerHealth(iClient);
					int maxHP = GetPlayerMaxHealth(iClient);
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
		// If force reload is active but player switched away from the shotgun, restore saved ammo
		if(g_bCoachShotgunForceReload[iClient] == true)
		{
			char currentweaponcheck[32];
			GetClientWeapon(iClient, currentweaponcheck, sizeof(currentweaponcheck));
			if(StrContains(currentweaponcheck, "shotgun", false) == -1)
			{
				int iShotgunID = GetPlayerWeaponSlot(iClient, 0);
				if(IsValidEntity(iShotgunID) && g_iCoachShotgunSavedAmmo[iClient] > 0)
				{
					SetEntData(iShotgunID, g_iOffset_ClipShotgun, g_iCoachShotgunSavedAmmo[iClient], true);
				}
				g_bCoachShotgunForceReload[iClient] = false;
				g_iCoachShotgunSavedAmmo[iClient] = 0;
			}
		}

		int buttons;
		buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if((buttons & IN_RELOAD) && g_bCoachShotgunForceReload[iClient] == false && g_bClientIsReloading[iClient] == false)
		{
			char currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			int ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (IsValidEntity(ActiveWeaponID) == false)
				return;
			int CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			
			if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true)) && (CurrentClipAmmo > 7) && (CurrentClipAmmo <= (7 + (g_iSprayLevel[iClient] * 2))))
			{
				int iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				int iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
				if(iAmmo > 0)
				{
					g_bCoachShotgunForceReload[iClient] = true;
					g_iCoachShotgunSavedAmmo[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_ClipShotgun, 0, true);
				}
			}
			if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (CurrentClipAmmo > 9) && (CurrentClipAmmo <= (9 + (g_iSprayLevel[iClient] * 2))))
			{
				int iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				int iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
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

void OGFSurvivorReload_Coach(int iClient, const char[] currentweapon, int ActiveWeaponID, int CurrentClipAmmo, int iOffset_Ammo)
{
	if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true)) && (g_iSprayLevel[iClient] > 0))
	{
		/*
		if(g_bCoachShotgunForceReload[iClient] == true)
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iCoachShotgunSavedAmmo[iClient], true);
			g_bCoachShotgunForceReload[iClient] = false;
		}
		*/
		int iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
		if(g_iReloadFrameCounter[iClient] == 1)
		{
			if(iAmmo >= ((8 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, ((g_iSprayLevel[iClient] * 2) + 8) - CurrentClipAmmo, true);
			}
			else if(iAmmo < ((8 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, iAmmo, true);
			}
		}
		if(CurrentClipAmmo > g_iCoachShotgunSavedAmmo[iClient])
		{
			g_iCoachShotgunSavedAmmo[iClient] = CurrentClipAmmo;
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
		int iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
		if(g_iReloadFrameCounter[iClient] == 1)
		{
			if(iAmmo >= ((10 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, ((g_iSprayLevel[iClient] * 2) + 10) - CurrentClipAmmo, true);
			}
			else if(iAmmo < ((10 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, iAmmo, true);
			}
		}
		if(CurrentClipAmmo > g_iCoachShotgunSavedAmmo[iClient])
		{
			g_iCoachShotgunSavedAmmo[iClient] = CurrentClipAmmo;
		}
		if((CurrentClipAmmo == (10 + (g_iSprayLevel[iClient] * 2))) || (CurrentClipAmmo == (CurrentClipAmmo + iAmmo)))
		{
						
			g_bCoachShotgunForceReload[iClient] = false;
			g_bClientIsReloading[iClient] = false;
			g_iReloadFrameCounter[iClient] = 0;
			SetEntData(ActiveWeaponID, g_bOffset_InReload, 0, true);
			SetEntData(iClient, g_bOffset_InReload, 0, true);
		}
	}
}

void EventsHurt_AttackerCoach(Handle hEvent, int attacker, int victim)
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
		char weaponclass[32];
		GetEventString(hEvent,"weapon",weaponclass,32);
		if(StrContains(weaponclass,"melee",false) != -1)
		{
			if(g_bIsWreckingBallCharged[attacker]==true)
			{
				if(g_iWreckingLevel[attacker] == 5)
				{
					g_bWreckingChargeRetrigger[attacker] = true;
				}

				g_bIsWreckingBallCharged[attacker] = false;
				int hp = GetPlayerHealth(victim);
				//dmg = (g_iWreckingLevel[attacker]*200) + (g_iMeleeDamageCounter[attacker]);
				CreateTimer(0.1, DeleteParticle, g_iPID_CoachMeleeCharge1[attacker], TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(0.1, DeleteParticle, g_iPID_CoachMeleeCharge2[attacker], TIMER_FLAG_NO_MAPCHANGE);
				float vec[3];
				GetClientAbsOrigin(attacker, vec);
				EmitSoundToAll(SOUND_COACH_CHARGE_HIT, attacker, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
				//CreateParticle("coach_melee_charge_splash", 0.0, attacker, NO_ATTACH);
				WriteParticle(victim, "coach_melee_charge_splash", 3.0);
				SetPlayerHealth(victim, attacker, hp - ((g_iWreckingLevel[attacker]*100) + g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
			}
			else if(g_iMeleeDamageCounter[attacker]>0)
			{
				int hp = GetPlayerHealth(victim);
				SetPlayerHealth(victim, attacker, hp - (g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
			}
			
			if(g_bCoachRageIsActive[attacker] == true)
			{
				int hp = GetPlayerHealth(victim);
				SetPlayerHealth(victim, attacker, hp - g_iCoachRageMeleeDamage[attacker]);
			}
		}
		if(g_iSprayLevel[attacker] > 0 && StrContains(weaponclass,"shotgun",false) != -1)
		{
			int hp = GetPlayerHealth(victim);
			SetPlayerHealth(victim, attacker, hp - CalculateDamageTakenForVictimTalents(victim, (g_iSprayLevel[attacker] * 2), weaponclass));
		}
	}
}

void EventsDeath_AttackerCoach(Handle hEvent, int iAttacker, int iVictim)
{
	if (g_iChosenSurvivor[iAttacker] != COACH ||
		g_bTalentsConfirmed[iAttacker] == false ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		RunClientChecks(iAttacker) == false ||
		IsFakeClient(iAttacker) == true)
		return;

	char weaponclass[32];
	GetEventString(hEvent,"weapon",weaponclass,32);

	if (StrContains(weaponclass,"melee",false) == -1)
		return;

	// Headshot-dependent bonuses
	if (GetEventBool(hEvent, "headshot") &&
		g_bCoachRageIsInCooldown[iAttacker] == false)
	{
		// CI Headshot
		if (iVictim < 1)
		{
			// Homerun - CI melee headshot gives stacks and ammo (all melee weapons, not just ones that can do decapitations)
			if (g_iHomerunLevel[iAttacker] > 0)
			{
				GiveExtraAmmoForCurrentShotgun(iAttacker);

				if (g_iCoachDecapitationCounter[iAttacker] < 50)
				{
					g_iCoachDecapitationCounter[iAttacker]++;
					g_iMeleeDamageCounter[iAttacker] += (g_iHomerunLevel[iAttacker] * 2);
				}
			}

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

void EventsDeath_VictimCoach(Handle hEvent, int iAttacker, int iVictim)
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
Action StartFlying(int iClient)
{
	if(g_bIsFlyingWithJetpack[iClient]==false)
	{
		SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
		g_bIsMovementTypeFly[iClient] = true;
		StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
		float vec[3];
		GetClientAbsOrigin(iClient, vec);
		EmitSoundToAll(SOUND_JPHIGHREV, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
		g_iPID_CoachJetpackStream[iClient] = WriteParticle(iClient, "jetpack_stream", 0.0);
		//g_iPID_CoachJetpackStream[iClient] = CreateParticle("jetpack_stream", 0.0, iClient, ATTACH_SURVIVOR_LIGHT);
	}

	g_iClientJetpackFuel[iClient]--;
	PrintCoachJetpackFuelGauge(iClient);

	RefreshAbilityImpactDamageImmunity(iClient);
	AddUpwardVelocity(iClient, 50.0);
	g_bIsFlyingWithJetpack[iClient]=true;
	if(g_iClientJetpackFuel[iClient] <= 0)
	{
		CreateTimer(0.5, DeleteParticle, g_iPID_CoachJetpackStream[iClient], TIMER_FLAG_NO_MAPCHANGE);
		StopSound(iClient, SNDCHAN_AUTO, SOUND_JPHIGHREV);
		StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
		float vec[3];
		GetClientAbsOrigin(iClient, vec);
		EmitSoundToAll(SOUND_JPDIE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
		GiveAbilityImpactDamageGracePeriod(iClient);
		g_bIsJetpackOn[iClient] = false;
		g_bIsFlyingWithJetpack[iClient] = false;
		g_bIsMovementTypeFly[iClient] = false;
		SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
		g_iClientJetpackFuel[iClient] = 0;
		PrintCoachJetpackFuelGauge(iClient);
	}

	return Plugin_Continue;
}

Action StopFlying(int iClient)
{
	g_bIsFlyingWithJetpack[iClient]=false;
	GiveAbilityImpactDamageGracePeriod(iClient);
	CreateTimer(0.5, DeleteParticle, g_iPID_CoachJetpackStream[iClient], TIMER_FLAG_NO_MAPCHANGE);
	StopSound(iClient, SNDCHAN_AUTO, SOUND_JPHIGHREV);
	float vec[3];
	GetClientAbsOrigin(iClient, vec);
	EmitSoundToAll(SOUND_JPIDLEREV, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
	return Plugin_Continue;
}

void AddUpwardVelocity(int iClient, float speed)
{
	float vecVelocity[3];
	GetEntDataVector(iClient, g_iOffset_VecVelocity, vecVelocity);

	if ((vecVelocity[2]+speed) > 250.0)
		vecVelocity[2] = 250.0;
	else
		vecVelocity[2] += speed;

	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vecVelocity);
}

//Find the number of coaches and set the health stack to that
void SetCoachesHealthStacks()
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

void GiveExtraAmmoForCurrentShotgun(int iClient, int iAmmoToGive = 1)
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
	if (iWeaponIndex == ITEM_REMINGTON_870 || iWeaponIndex == ITEM_REMINGTON_870_CUSTOM)
		iBaseMaxClipAmmo = 8;
	else if (iWeaponIndex == ITEM_BENELLI_M1014 || iWeaponIndex == ITEM_FRANCHI_SPAS_12)
		iBaseMaxClipAmmo = 10;
	int iNewAmmo =  iCurrentClipAmmo + iAmmoToGive < (iBaseMaxClipAmmo + (g_iSprayLevel[iClient] * 2)) ? iCurrentClipAmmo + iAmmoToGive : iBaseMaxClipAmmo + (g_iSprayLevel[iClient] * 2);
	
	SetEntData(iActiveWeaponID, g_iOffset_ClipShotgun, iNewAmmo, 4, true);
}

bool TraceFilter_NotSelf(int iEntity, int iMask, any iClient)
{
	return iEntity != iClient;
}

void OnPlayerRunCmd_Coach(int iClient, int iButtons)
{
	if(g_iChosenSurvivor[iClient] != COACH || g_bTalentsConfirmed[iClient] == false)
		return;

	if(g_iWreckingLevel[iClient] > 0)
	{
		char strRunCmdWeapon[32];
		GetClientWeapon(iClient, strRunCmdWeapon, sizeof(strRunCmdWeapon));
		bool bHoldingMelee = (StrContains(strRunCmdWeapon, "melee", false) != -1);

		// Toggle lunge on/off with CROUCH+USE while holding melee
		if(bHoldingMelee && (iButtons & IN_DUCK) && (iButtons & IN_USE) && g_bCoachLungeToggleCooldown[iClient] == false)
		{
			g_bCoachLungeEnabled[iClient] = !g_bCoachLungeEnabled[iClient];
			g_bCoachLungeToggleCooldown[iClient] = true;
			CreateTimer(0.5, TimerCoachLungeToggleCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
			PrintHintText(iClient, "Wrecking Ball Lunge: %s", g_bCoachLungeEnabled[iClient] ? "ON" : "OFF");
		}

		// Wrecking Ball Lunge - attack while holding melee
		if(bHoldingMelee &&
			g_bCoachLungeEnabled[iClient] &&
			g_bCoachLungeOnCooldown[iClient] == false &&
			g_bIsFlyingWithJetpack[iClient] == false &&
			g_bIsClientDown[iClient] == false &&
			IsClientGrappled(iClient) == false &&
			(iButtons & IN_ATTACK))
		{
			g_bCoachLungeTriggered[iClient] = true;
		}
	}
}
