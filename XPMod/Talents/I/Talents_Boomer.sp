TalentsLoad_Boomer(iClient)
{
	if(g_iRapidLevel[iClient] > 0)
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Boomer Talents \x05have been loaded.");
}

OnGameFrame_Boomer(iClient)
{
	if(g_iAcidicLevel[iClient] > 0)
	{
		if(IsPlayerAlive(iClient) == true)
		{
			if(GetEntityFlags(iClient) & FL_ONGROUND)
			{
				if(g_bIsSuicideJumping[iClient] == true)
				{
					if(GetEntProp(iClient, Prop_Send, "m_zombieClass") == BOOMER)
						ForcePlayerSuicide(iClient);
				}
			}
		}
	}
}

Event_BoomerVomitOnPlayer(iAttacker, iVictim)
{
	if(g_iInfectedCharacter[iAttacker] ==  BOOMER)
	{
		GiveClientXP(iAttacker, 15, g_iSprite_15XP_SI, iVictim, "Puked on a survivor.", false, 1.0);
		
		if(g_iAcidicLevel[iAttacker] > 0)
		{
			SetEntProp(iVictim, Prop_Send, "m_iHideHUD", 64);
			CreateTimer((g_iAcidicLevel[iAttacker] * 2.0), TimerGiveHudBack, iVictim, TIMER_FLAG_NO_MAPCHANGE); 
		}
		if(g_iNorovirusLevel[iAttacker] >= 5)
		{
			g_iVomitVictimCounter[iAttacker]++;
			if(g_iVomitVictimCounter[iAttacker] >= 3)
			{
				if(IsClientInGame(iAttacker) == true)
					if(IsFakeClient(iAttacker) == false)
					{
						new random = GetRandomInt(0, 5);
						switch(random)
						{
							case 0:		//Give 3 extra bind 1 and bind 2 uses
							{
								PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He gets an extra bind 1 and bind 2 charge.", iAttacker);
								g_iClientBindUses_1[iAttacker] --;
								g_iClientBindUses_2[iAttacker] --;
							}
							case 1:		//Set Health
							{
								if(IsPlayerAlive(iAttacker))
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He becomes a \x04FAT Ninja!\x05", iAttacker);
									SetPlayerMaxHealth(iAttacker, 750, false, true);
									SetPlayerHealth(iAttacker, 750)
									g_bIsSuperSpeedBoomer[iAttacker] = true;
									SetClientSpeed(iAttacker);
									
									CreateTimer(20.0, TimerResetFastBoomerSpeed, iAttacker, TIMER_FLAG_NO_MAPCHANGE);
								}
								else	//If their not alive then give them another reward
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. Common Infected temporarily do more damage.", iAttacker);
									g_bCommonInfectedDoMoreDamage = true;
									CreateTimer(20.0, TimerResetZombieDamage, 0, TIMER_FLAG_NO_MAPCHANGE);
								}
							}
							case 2:		//Constant vomit for 8 seconds on last survivor hit
							{
								new bool:ok = false;
								if(IsClientInGame(iVictim) == true)
								{
									if(IsPlayerAlive(iVictim) == true)
									{
										PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. \x04%N\x05 got sick and is vomiting uncontrollably.", iAttacker, iVictim);
										CreateParticle("boomer_vomit", 2.0, iVictim, ATTACH_MOUTH, true);
										g_bIsSurvivorVomiting[iVictim] = true;
										g_iShowSurvivorVomitCounter[iVictim] = 20;
										CreateTimer(1.0, TimerConstantVomitDisplay, iVictim, TIMER_FLAG_NO_MAPCHANGE);
										ok = true;
									}
								}
								if(ok == false)	//If the iVictim is no longer alive, fat ninja instead
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He becomes a \x04FAT Ninja!\x05", iAttacker);
									SetPlayerMaxHealth(iAttacker, 750, false, true);
									SetPlayerHealth(iAttacker, 750)
									g_bIsSuperSpeedBoomer[iAttacker] = true;
									SetClientSpeed(iAttacker);
									
									CreateTimer(20.0, TimerResetFastBoomerSpeed, iAttacker, TIMER_FLAG_NO_MAPCHANGE);
								}
							}
							case 3:		//Zombies do more damage
							{
								PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. Common Infected temporarily do more damage.", iAttacker);
								g_bCommonInfectedDoMoreDamage = true;
								CreateTimer(20.0, TimerResetZombieDamage, 0, TIMER_FLAG_NO_MAPCHANGE);
							}
							case 4:		//Crack Out
							{
								if((IsPlayerAlive(iVictim)) && (IsFakeClient(iVictim) == false))
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. \x04%N\x05 swallowed some pills he puked up.", iAttacker, iVictim);
									PrintHintText(iVictim,"You swallowed some pills that %N puked up.", iAttacker);
									
									new red = GetRandomInt(0,255);
									new green = GetRandomInt(0,255);
									new blue = GetRandomInt(0,255);
									new alpha = GetRandomInt(190,230);
									
									ShowHudOverlayColor(iVictim, red, green, blue, alpha, 700, FADE_IN);
									
									g_iDruggedRuntimesCounter[iVictim] = 0;

									delete g_hTimer_DrugPlayer[iVictim];
									g_hTimer_DrugPlayer[iVictim] = CreateTimer(2.5, TimerDrugged, iVictim, TIMER_REPEAT);
									
									WriteParticle(iVictim, "drugged_effect", 0.0, 30.0);
								}
								else
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. A hoard has been summoned.", iAttacker);
									RunCheatCommand(iAttacker, "z_spawn_old", "z_spawn_old mob auto");
								}
							}
							case 5:
							{
								if(IsPlayerAlive(iAttacker) == true)
								{
									//SetConVarInt(FindConVar("z_no_cull"), 1);
									//SetConVarInt(FindConVar("z_common_limit"), 36);
									
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. Jimmy Gibbs has come to play!", iAttacker);
									decl Float:location[3], Float:ang[3];
									GetClientAbsOrigin(iAttacker, location);
									GetClientEyeAngles(iAttacker, ang);
									
									location[0] = (location[0]+(50*(Cosine(DegToRad(ang[1])))));
									location[1] = (location[1]+(50*(Sine(DegToRad(ang[1])))));
									
									new ticktime = RoundToNearest(  GetGameTime() / GetTickInterval()) + 5;
									
									decl i;
									for(i = 0; i < 4; i++)
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
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. Common Infected temporarily do more damage.", iAttacker);
									g_bCommonInfectedDoMoreDamage = true;
									CreateTimer(20.0, TimerResetZombieDamage, 0, TIMER_FLAG_NO_MAPCHANGE);
								}
							}
						}
					}
				g_iVomitVictimCounter[iAttacker] = -10;	//Set it to this so that they cant get it more than 1 time per vomit, if they hit 6 survivors
			}
			if(g_bNowCountingVomitVictims[iAttacker] == false)
			{
				g_bNowCountingVomitVictims[iAttacker] = true;
				CreateTimer(9.0, TimerStopItCounting, iAttacker, TIMER_FLAG_NO_MAPCHANGE);
			}
			decl rand;
			rand = GetRandomInt(1, 100);
			if(rand <= (g_iNorovirusLevel[iAttacker] * 4))
			{
				CreateParticle("boomer_vomit", 2.0, iVictim, ATTACH_MOUTH, true);
				g_bIsSurvivorVomiting[iVictim] = true;
				g_iShowSurvivorVomitCounter[iVictim] = 3;
				CreateTimer(1.0, TimerConstantVomitDisplay, iVictim, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
}

// EventsDeath_AttackerBoomer(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

EventsDeath_VictimBoomer(Handle:hEvent, iAttacker, iVictim)
{
	if (g_iInfectedCharacter[iVictim] != BOOMER ||
		g_iClientTeam[iVictim] != TEAM_INFECTED ||
		g_bTalentsConfirmed[iVictim] == false ||
		(g_iClientInfectedClass1[iVictim] != BOOMER &&
		g_iClientInfectedClass2[iVictim] != BOOMER &&
		g_iClientInfectedClass3[iVictim] != BOOMER) ||
		RunClientChecks(iVictim) == false ||
		IsFakeClient(iVictim) == true)
		return;

	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);

	if(g_iAcidicLevel[iVictim] > 0)
	{
		decl Float:vector[3];
		GetClientEyePosition(iVictim, vector);
		decl target;
		for (target = 1; target <= MaxClients; target++)
		{
			if (RunClientChecks(target) &&
				IsPlayerAlive(target) && 
				g_iClientTeam[target] == TEAM_SURVIVORS)
			{
				if (g_bIsSuicideJumping[iVictim] == true)
				{
					//PrintToChatAll("trying for %N", target);
					decl Float:targetVector[3];
					GetClientEyePosition(target, targetVector);
					new Float:distance = GetVectorDistance(targetVector, vector);
					if(IsVisibleTo(vector, targetVector) == true)
					{
						//PrintToChatAll("%N is visible to you", target);
						if(distance < (200.0 + (float(g_iNorovirusLevel[iVictim]) * 15.0)))
						{
							//PrintToChatAll("%N is in range", target);
							DealDamage(target, iVictim, 10 + RoundToNearest(g_iNorovirusLevel[iVictim] * 1.5));
							SDKCall(g_hSDK_VomitOnPlayer, target, iVictim, true);
							
							//Fling Target Survivor (taken from "Tankroar 2.2" by Karma)
							if(GetEntProp(target, Prop_Send, "m_isIncapacitated") == 0)
							{
								decl Float:svPos[3];
								GetClientEyePosition(target, svPos);
								
								decl Float:distanceVec[3];
								
								distanceVec[0] = (vector[0] - svPos[0]);
								distanceVec[1] = (vector[1] - svPos[1]);
								distanceVec[2] = (vector[2] - svPos[2]);
								
								decl Float: addAmount[3], Float: svVector[3], Float: ratio[2];
								new Float:power =  100.0 + (float(g_iNorovirusLevel[iVictim]) * 30.0);
								
								ratio[0] =  distanceVec[0] / SquareRoot(distanceVec[1]*distanceVec[1] + distanceVec[0]*distanceVec[0]);//Ratio x/hypo
								ratio[1] =  distanceVec[1] / SquareRoot(distanceVec[1]*distanceVec[1] + distanceVec[0]*distanceVec[0]);//Ratio y/hypo
								
								GetEntPropVector(target, Prop_Data, "m_vecVelocity", svVector);
								
								addAmount[0] = ( -1.0 * (ratio[0] * power) );//multiply negative = away from TANK. multiply positive = towards TANK.
								addAmount[1] = ( -1.0 * (ratio[1] * power) );
								addAmount[2] = power;
								
								SDKCall(g_hSDK_Fling, target, addAmount, 96, iVictim, 3.0);
							}
							
							GiveClientXP(iVictim, 25, g_iSprite_25XP_SI, target, "Exploded on a survivor.");
						}
					}
				}
				else
				{
					decl Float:targetVector[3];
					GetClientAbsOrigin(target, targetVector);
					new Float:distance = GetVectorDistance(targetVector, vector);
					if(IsVisibleTo(vector, targetVector) == true && distance < 200.0)
					{
						DealDamage(target, iVictim, g_iAcidicLevel[iVictim]);
						GiveClientXP(iVictim, 25, g_iSprite_25XP_SI, target, "Exploded on a survivor.");
					}
				}
			}
		}
	}
}