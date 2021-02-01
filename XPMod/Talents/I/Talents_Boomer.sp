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
						new random = GetRandomInt(0, 6);
						switch(random)
						{
							case 0:		//Give 3 extra bind 1 and bind 2 uses
							{
								PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He gets an extra bind 1 and bind 2 charge.", iAttacker);
								g_iClientBindUses_1[iAttacker] --;
								g_iClientBindUses_2[iAttacker] --;
							}
							case 1:		//Set Health to 1000
							{
								if(IsPlayerAlive(iAttacker))
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He gets 1000 Health", iAttacker);
									SetEntProp(iAttacker,Prop_Data,"m_iMaxHealth", 1000);
									SetEntProp(iAttacker,Prop_Data,"m_iHealth", 1000);
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
								if(ok == false)	//If the iVictim is no longer alive, give health instead
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He gets 1000 Health", iAttacker);
									SetEntProp(iAttacker,Prop_Data,"m_iMaxHealth", 1000);
									SetEntProp(iAttacker,Prop_Data,"m_iHealth", 1000);
								}
							}
							case 3:		//Zombies do more damage
							{
								PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. Common Infected temporarily do more damage.", iAttacker);
								g_bCommonInfectedDoMoreDamage = true;
								CreateTimer(20.0, TimerResetZombieDamage, 0, TIMER_FLAG_NO_MAPCHANGE);
							}
							case 4:		//Get faster movement speed
							{
								if(IsPlayerAlive(iAttacker) == true)
								{
									PrintToChatAll("\x03[XPMod] \x04%N\x05 vomited on 3 survivors. He gets temporary super speed.", iAttacker);
									
									g_bIsSuperSpeedBoomer[iAttacker] = true;
									SetClientSpeed(iAttacker);

									
									CreateTimer(20.0, TimerResetFastBoomerSpeed, iAttacker, TIMER_FLAG_NO_MAPCHANGE);
								}
								else	//If their not alive then give them another reward
								{
									PrintToChatAll("\x03[XPMod] \x05%N vomited on 3 survivors.  He gets an extra Bind 1 and Bind 2 charge.", iAttacker);
									g_iClientBindUses_1[iAttacker]--;
									g_iClientBindUses_2[iAttacker]--;
								}
							}
							case 5:		//Crack Out
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
									SetCommandFlags("z_spawn_old", g_iFlag_SpawnOld & ~FCVAR_CHEAT);
									FakeClientCommand(iAttacker, "z_spawn_old mob auto");
									SetCommandFlags("z_spawn_old", g_iFlag_SpawnOld);
								}
							}
							case 6:
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
									for(i = 0; i < 6; i++)
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