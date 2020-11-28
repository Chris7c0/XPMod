public Action:Event_PlayerDeath(Handle:hEvent, String:Event_name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(hEvent, "attacker"));
	new headshot = GetEventBool(hEvent, "headshot");
	//If victim was 0 then it was a common infected
	if(victim < 1)
	{
		victim = GetEventInt(hEvent, "entityid");
		if(attacker < 1 || IsFakeClient(attacker) == true)
			return Plugin_Continue;
		if(g_iClientTeam[attacker] != TEAM_SURVIVORS)
			return Plugin_Continue;
			
		g_iStat_ClientCommonKilled[attacker]++;
		if(headshot)
		{
			g_iStat_ClientCommonHeadshots[attacker]++;
			g_iClientXP[attacker] += 5;
			CheckLevel(attacker);
			
			if(g_iXPDisplayMode[attacker] == 0)
				ShowXPSprite(attacker, g_iSprite_5XP_HS, victim, 2.0);
			else if(g_iXPDisplayMode[attacker] == 1)
				PrintCenterText(attacker, "HEADSHOT! +5 XP.");
			
			
			if(g_bCanPlayHeadshotSound[attacker] == true)
				PlayHeadshotSound(attacker);
			if(g_iSilentLevel[attacker] > 0)
			{
				if(g_iSilentSorrowHeadshotCounter[attacker] < 20)
					g_iSilentSorrowHeadshotCounter[attacker]++;
			}
			if(g_iBullLevel[attacker] > 0)
			{
				if(g_bCoachRageIsInCooldown[attacker] == false)
				{
					decl String:weaponclass[32];
					GetEventString(hEvent,"weapon",weaponclass,32);
					//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
					if(StrContains(weaponclass,"melee",false) != -1)
					{
						g_iCoachCIHeadshotCounter[attacker]++;
						if(g_bCoachInCISpeed[attacker] == false)
						{
							//g_fCoachCIHeadshotSpeed[attacker] = (g_iBullLevel[attacker] * 0.05);
							//PrintToChatAll("g_fCoachCIHeadshotSpeed = %d", g_fCoachCIHeadshotSpeed[attacker]);
							//SetEntDataFloat(attacker , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + g_fCoachCIHeadshotSpeed[attacker] + g_fCoachSIHeadshotSpeed[attacker] + g_fCoachRageSpeed[attacker]), true);
							g_fClientSpeedBoost[attacker] += (g_iBullLevel[attacker] * 0.05);
							fnc_SetClientSpeed(attacker);
							CreateTimer(3.0, TimerCoachCIHeadshotSpeedReset, attacker, TIMER_FLAG_NO_MAPCHANGE);
							g_bCoachInCISpeed[attacker] = true;
						}
					}
				}
			}
			return Plugin_Continue;
		}
		//If it wasnt a headshot, its a common regular common kill
		g_iClientXP[attacker]++;
		CheckLevel(attacker);
		
		if(g_iXPDisplayMode[attacker] == 0)
			ShowXPSprite(attacker, g_iSprite_1XP, victim, 1.0);
		
		return Plugin_Continue;
	}
	//PrintToChatAll("vicftim = %N, team = %d, g_iInfectedCharacter = %d", victim, g_iClientTeam[victim], g_iInfectedCharacter[victim]);
	if(g_bIsClientDown[victim] == true)
	{
		g_bWasClientDownOnDeath[victim] = true;
	}
	g_bIsClientDown[victim] = false;
	clienthanging[victim] = false;
	
	if(g_iHunterShreddingVictim[victim] > 0)
		fnc_SetClientSpeed(g_iHunterShreddingVictim[victim]);
		//ResetSurvivorSpeed(g_iHunterShreddingVictim[victim]);
	
	if(g_bEnabledVGUI[victim] == true && g_bShowingVGUI[victim] == true)
		DeleteAllMenuParticles(victim);
	
	if(g_iTankChosen[victim] == FIRE_TANK && GetEntProp(victim, Prop_Send, "m_zombieClass") == TANK)
	{
		decl Float:xyzLocation[3];
		GetClientAbsOrigin(victim, xyzLocation);
		
		PropaneExplode(xyzLocation);
		MolotovExplode(xyzLocation);
	}
	
	//Tank
	g_iTankChosen[victim] = NO_TANK_CHOSEN;
	g_xyzClientPosition[victim][0] = 0.0;
	g_xyzClientPosition[victim][1] = 0.0;
	g_xyzClientPosition[victim][2] = 0.0;
	g_iTankCharge[victim] = 0;
	g_bTankAttackCharged[victim] = false;
	DeleteParticleEntity(g_iPID_TankChargedFire[victim]);
	g_iIceTankLifePool[victim] = 0;
	g_hTimer_IceSphere[victim] = INVALID_HANDLE;
	DeleteParticleEntity(g_iPID_IceTankIcicles[victim]);
	
	//Grapples
	g_bHunterGrappled[victim] = false;
	g_iHunterShreddingVictim[victim] = -1;
	g_bHunterGrappled[attacker] = false;		//Need to do it for both of them
	g_iHunterShreddingVictim[attacker] = -1;
	g_bSmokerGrappled[victim] = false;
	g_bChargerGrappled[victim] = false;
	g_bSmokerGrappled[attacker] = false;
	g_bChargerGrappled[g_iChargerVictim[victim]] = false;
	g_bChargerGrappled[victim] = false;
	g_iChargerVictim[victim] = 0;
	g_iJockeyVictim[victim] = -1;
	
	g_iShowSurvivorVomitCounter[victim] = 0;
	
	//To Turn Kiting back on
	SetConVarInt(FindConVar("z_tank_damage_slow_min_range"), 200);
	SetConVarInt(FindConVar("z_tank_damage_slow_max_range"), 400);
	SetConVarFloat(FindConVar("z_tank_throw_interval"), 5.0);
	
	g_bUsingFireStorm[victim] = false;
	g_bUsingShadowNinja[victim] = false;
	g_bIsJetpackOn[victim] = false;
	g_bUsingTongueRope[victim] = false;
	DeleteAllClientParticles(victim);
	
	g_bHunterLethalPoisoned[victim] = false;
	
	if(victim > 0 && g_bClientLoggedIn[victim] == false && IsClientInGame(victim) == true && IsFakeClient(victim) == false)
		PrintHintText(victim, "Type !xpm to use XPMod");
	
	if(g_bIsRochellePoisoned[victim]==true)
	{
		DeleteParticleEntity(g_iPID_RochellePoisonBullet[victim]);
		WriteParticle(victim, "poison_bullet_pool", 0.0, 41.0);
	}
	
	if (victim < 1)
		return Plugin_Continue;
	
	if(attacker > 0 && g_iClientTeam[attacker] == TEAM_INFECTED && g_iClientTeam[victim] == TEAM_SURVIVORS && 
		IsClientInGame(attacker) == true && IsFakeClient(attacker) == false)		//Give XP for Infected killing a Survivor
	{	
		g_iStat_ClientSurvivorsKilled[attacker]++;
		
		g_iClientXP[attacker] += 500;
		CheckLevel(attacker);
		
		if(g_iXPDisplayMode[attacker] == 0)
			ShowXPSprite(attacker, g_iSprite_500XP_SI, victim, 6.0);
		else if(g_iXPDisplayMode[attacker] == 1)
			PrintCenterText(attacker, "\x03[XPMod] Killed %d.  You gain 500 XP", victim);
		
	}
	
	if(g_iClientTeam[victim] == TEAM_INFECTED)		//Give XP for killing the Tank
	{
		if(GetEntProp(victim, Prop_Send, "m_zombieClass") == TANK)
		{
			g_iTankCounter--;
			if(g_bEndOfRound == false)
			{
				StopHudOverlayColor(victim);
				
				for(new i=1;i<=MaxClients;i++)
				{
					if(RunClientChecks(i) && GetClientTeam(i) == TEAM_SURVIVORS && IsFakeClient(i) == false)
					{
						g_iClientXP[i] += 250;
						CheckLevel(i);
						
						if(g_iXPDisplayMode[i] == 0)
							ShowXPSprite(i, g_iSprite_250XP_Team, victim, 5.0);
						else if(g_iXPDisplayMode[i] == 1)
							PrintToChat(i,"\x03[XPMod] Tank Killed. Everyone alive on your team You gain 250 XP");
						
						
						g_bTankOnFire[i] = false;
						
						if(g_iJamminLevel[i] > 0)
						{
							if(g_iTankCounter == 0)
							{
								//g_fEllisJamminSpeed[i] = 0.0;
								//SetEntDataFloat(i , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[i] + g_fEllisBringSpeed[i] + g_fEllisOverSpeed[i]), true);
								g_fClientSpeedBoost[i] -= (g_iJamminLevel[i] * 0.04);
								fnc_SetClientSpeed(i);
								PrintHintText(i, "You calm down knowing the TANK is dead.");
								//DeleteCode
								//PrintToChatAll("Tank has died, now setting g_fEllisJamminSpeed");
								//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[i]);
								//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[i]);
								//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[i]);
							}
						}
					}
				}
			}
		}
	}
	
	if (attacker < 1)
		return Plugin_Continue;
	
	if (g_iClientTeam[victim] == TEAM_INFECTED)
	{
		switch(g_iInfectedCharacter[victim])
		{
			case 1: //SMOKER
			{
				if(g_iNoxiousLevel[victim] > 0)
				{
					g_bHasSmokersPoisonCloudOut[victim] = true;
					GetClientEyePosition(victim, g_xyzPoisonCloudOriginArray[victim]);
					CreateTimer(0.1, TimerPoisonCloud, victim, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer( (float(g_iNoxiousLevel[victim]) * 2.0), TimerStopPoisonCloud, victim, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			case 2: //BOOMER
			{
				if(g_iAcidicLevel[victim] > 0)
				{
					decl Float:vector[3];
					GetClientEyePosition(victim, vector);
					decl target;
					for (target = 1; target <= MaxClients; target++)
					{
						if(IsClientInGame(target))
						{
							if(IsPlayerAlive(target))
							{
								if(g_iClientTeam[target] == TEAM_SURVIVORS)
								{
									if(g_bIsSuicideJumping[victim] == true)
									{
										g_iClientBindUses_2[victim]++;
										//PrintToChatAll("trying for %N", target);
										decl Float:targetVector[3];
										GetClientEyePosition(target, targetVector);
										new Float:distance = GetVectorDistance(targetVector, vector);
										if(IsVisibleTo(vector, targetVector) == true)
										{
											//PrintToChatAll("%N is visible to you", target);
											if(distance < (200.0 + (float(g_iNorovirusLevel[victim]) * 15.0)))
											{
												//PrintToChatAll("%N is in range", target);
												DealDamage(target, victim, 10 + (g_iNorovirusLevel[victim] * 2));
												SDKCall(g_hSDK_VomitOnPlayer, target, victim, true);
												
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
													new Float:power =  100.0 + (float(g_iNorovirusLevel[victim]) * 30.0);
													
													ratio[0] =  distanceVec[0] / SquareRoot(distanceVec[1]*distanceVec[1] + distanceVec[0]*distanceVec[0]);//Ratio x/hypo
													ratio[1] =  distanceVec[1] / SquareRoot(distanceVec[1]*distanceVec[1] + distanceVec[0]*distanceVec[0]);//Ratio y/hypo
													
													GetEntPropVector(target, Prop_Data, "m_vecVelocity", svVector);
													
													addAmount[0] = ( -1.0 * (ratio[0] * power) );//multiply negative = away from TANK. multiply positive = towards TANK.
													addAmount[1] = ( -1.0 * (ratio[1] * power) );
													addAmount[2] = power;
													
													SDKCall(g_hSDK_Fling, target, addAmount, 96, victim, 3.0);
												}
												
												GiveClientXP(victim, 25, g_iSprite_25XP_SI, target, "Exploded on a survivor.");
											}
										}
									}
									else
									{
										decl Float:targetVector[3];
										GetClientAbsOrigin(target, targetVector);
										new Float:distance = GetVectorDistance(targetVector, vector);
										if(IsVisibleTo(vector, targetVector) == true)
											if(distance < 200.0)
											{
												DealDamage(target, victim, g_iAcidicLevel[victim]);
												GiveClientXP(victim, 25, g_iSprite_25XP_SI, target, "Exploded on a survivor.");
											}
									}
								}
							}
						}
					}
					g_bIsSuicideBoomer[victim] = false;
					g_bIsSuicideJumping[victim] = false;
				}
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
				g_bIsHillbillyEarthquakeReady[victim] = false;
			}
			case 8: //TANK
			{
				
			}
			default: //Unknown
			{
			}
		}
		//Reset Varibales
		g_bIsSuicideBoomer[victim] = false;	
		g_bIsSuicideJumping[victim] = false;
		g_bHasInfectedHealthBeenSet[victim] = false;
		g_fClientSpeedBoost[victim] = 0.0;
		g_fClientSpeedPenalty[victim] = 0.0;
		fnc_SetClientSpeed(victim);
	}
	if(IsFakeClient(attacker) == true)
		return Plugin_Continue;
	if (g_iClientTeam[attacker] == TEAM_SURVIVORS)
	{
		if (g_iClientTeam[victim] == TEAM_INFECTED)
		{
			if(headshot)
			{
				g_iStat_ClientCommonHeadshots[attacker]++;
				g_iClientXP[attacker] += 75;
				CheckLevel(attacker);
				
				if(g_iXPDisplayMode[attacker] == 0 && GetEntProp(victim, Prop_Send, "m_zombieClass") != TANK)
					ShowXPSprite(attacker, g_iSprite_75XP_HS, victim);
				else if(g_iXPDisplayMode[attacker] == 1)
					PrintToChat(attacker, "\x03[XPMod] HEADSHOT! Special Infected Killed. You gain 75 XP.");
					
				if(g_iHomerunLevel[attacker] > 1)
				{
					if(g_bCoachRageIsInCooldown[attacker] == false)
					{
						decl String:weaponclass[32];
						GetEventString(hEvent,"weapon",weaponclass,32);
						//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
						if(StrContains(weaponclass,"melee",false) != -1)
						{
							g_iCoachSIHeadshotCounter[attacker]++;
							if(g_bCoachInSISpeed[attacker] == false)
							{
								//g_fCoachSIHeadshotSpeed[attacker] = (g_iHomerunLevel[attacker] * 0.05);
								//PrintToChatAll("g_fCoachCIHeadshotSpeed = %d", g_fCoachCIHeadshotSpeed[attacker]);
								//SetEntDataFloat(attacker , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + g_fCoachCIHeadshotSpeed[attacker] + g_fCoachSIHeadshotSpeed[attacker] + g_fCoachRageSpeed[attacker]), true);
								g_fClientSpeedBoost[attacker] += (g_iHomerunLevel[attacker] * 0.05);
								fnc_SetClientSpeed(attacker);
								CreateTimer(6.0, TimerCoachSIHeadshotSpeedReset, attacker, TIMER_FLAG_NO_MAPCHANGE);
								g_bCoachInSISpeed[attacker] = true;
							}
						}
					}
				}
				decl String:weaponclass[32];
				GetEventString(hEvent,"weapon",weaponclass,32);
				//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
				if(StrContains(weaponclass,"melee",false) != -1)
				{
					if(g_bWreckingChargeRetrigger[attacker] == true)
					{
						CreateTimer(0.5, TimerWreckingChargeRetrigger, attacker, TIMER_FLAG_NO_MAPCHANGE);
						//PrintToChatAll("Wrecking Retriggering");
					}
					// PrintToChatAll("String");
				}
/*
				if(g_bIsWreckingBallCharged[attacker] == true && g_iWreckingLevel[attacker] == 5)
				{
					decl String:weaponclass[32];
					GetEventString(hEvent,"weapon",weaponclass,32);
					//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
					if(StrContains(weaponclass,"melee",false) != -1)
					{
						CreateTimer(0.5, TimerWreckingChargeRetrigger, attacker, TIMER_FLAG_NO_MAPCHANGE);
						//PrintToChatAll("Wrecking Ball Charged = True; Wrecking Level = 5");
					}
				}
*/
			}
			else
			{
				g_iClientXP[attacker] += 50;
				CheckLevel(attacker);
				
				if(g_iXPDisplayMode[attacker] == 0 && GetEntProp(victim, Prop_Send, "m_zombieClass") != TANK)
					ShowXPSprite(attacker, g_iSprite_50XP, victim);
				else if(g_iXPDisplayMode[attacker] == 1)
					PrintToChat(attacker, "\x03[XPMod] Special Infected Killed. You gain 50 XP.");
			}
			
			g_iStat_ClientInfectedKilled[attacker]++;
			if(g_iInspirationalLevel[attacker] > 0)
			{
				decl i;
				for(i = 1; i <= MaxClients;i++)
				{
					if(IsClientInGame(i) == true)
						if(IsPlayerAlive(i) == true)
							if(IsFakeClient(i) == false)
								if(g_iClientTeam[i] == TEAM_SURVIVORS)
								{
									if(i != attacker)
									{	
										g_iClientXP[i] += (g_iInspirationalLevel[attacker] * 10);
										CheckLevel(i);
										
										if(g_iXPDisplayMode[i] == 0)
										{
											switch(g_iInspirationalLevel[attacker])
											{
												case 1:	ShowXPSprite(i, g_iSprite_10XP_Bill, attacker);
												case 2:	ShowXPSprite(i, g_iSprite_20XP_Bill, attacker);
												case 3:	ShowXPSprite(i, g_iSprite_30XP_Bill, attacker);
												case 4:	ShowXPSprite(i, g_iSprite_40XP_Bill, attacker);
												case 5:	ShowXPSprite(i, g_iSprite_50XP_Bill, attacker);
											}
										}
										else if(g_iXPDisplayMode[i] == 1)
											PrintToChat(i, "\x03[XPMod] \x05%N \x03 killed a special infected. You gain %d XP.", attacker, (g_iInspirationalLevel[attacker] * 10));
									}
								}
				}
			}
			if(g_bAnnouncerOn[attacker] == true)
				PlayKillSound(attacker);
			if(g_iBringLevel[attacker] > 0)
			{
				new maxHP = GetEntProp(attacker,Prop_Data,"m_iMaxHealth");
				
				//Old way of doing this, changed to nerf ELLIS because he was OP
				/*if(maxHP < 250)
				{
					SetEntProp(attacker,Prop_Data,"m_iMaxHealth", maxHP + RoundToCeil(g_iBringLevel[attacker] * 0.5));
					g_iEllisMaxHealth[attacker] = maxHP + g_iBringLevel[attacker];
				}
				
				new currentHP=GetEntProp(attacker,Prop_Data,"m_iHealth");
				if(currentHP < 250)
					SetEntProp(attacker,Prop_Data,"m_iHealth", currentHP + RoundToCeil(g_iBringLevel[attacker] * 0.5));
				else
					SetEntProp(attacker,Prop_Data,"m_iHealth", 250);
					*/
					
				new currentHP = GetEntProp(attacker,Prop_Data,"m_iHealth");
				if(g_bIsClientDown[attacker] == false)
				{
					if(g_iBringLevel[attacker] < 5)
					{
						if((currentHP + g_iBringLevel[attacker]) >= maxHP)
							SetEntProp(attacker,Prop_Data,"m_iHealth", maxHP);
						else
							SetEntProp(attacker,Prop_Data,"m_iHealth", currentHP + g_iBringLevel[attacker]);
					}
					else if(g_iBringLevel[attacker] == 5)
					{
						if((currentHP + g_iBringLevel[attacker] + 3) >= maxHP)
							SetEntProp(attacker,Prop_Data,"m_iHealth", maxHP);
						else
							SetEntProp(attacker,Prop_Data,"m_iHealth", currentHP + g_iBringLevel[attacker] + 3);
					}
				}
				else
				{
					//SetEntProp(attacker,Prop_Data,"m_iHealth", currentHP + g_iBringLevel[attacker]);
					if(g_iBringLevel[attacker] < 5)
					{
						SetEntProp(attacker,Prop_Data,"m_iHealth", currentHP + g_iBringLevel[attacker]);
					}
					else if(g_iBringLevel[attacker] == 5)
					{
						SetEntProp(attacker,Prop_Data,"m_iHealth", currentHP + g_iBringLevel[attacker] + 3);
					}
				}
				
				new iEntid = GetEntDataEnt2(attacker,g_iOffset_ActiveWeapon);
				if(iEntid!=-1)
				{
					decl String:wclass[32];
					GetEntityNetClass(iEntid,wclass,32);
					//PrintToChatAll("\x03-class of gun: \x01%s",wclass);
					if (StrContains(wclass,"rifle",false) != -1 || StrContains(wclass,"smg",false) != -1 || StrContains(wclass,"sub",false) != -1 || StrContains(wclass,"sniper",false) != -1)
					{
						new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");		//put in if not grenade launcher
						clip += g_iBringLevel[attacker] * 20;
						if(clip > 250)
							clip = 250;
						SetEntData(iEntid, g_iOffset_Clip1, clip, true);
						//clip= GetEntProp(iEntid,Prop_Data,"m_iClip2"); 			//trying to figure out what clip2 does/////////////////////////////////
						//SetEntData(iEntid, clipsize2, clip+30, true);	
					}
				}
				if(g_iEllisSpeedBoostCounter[attacker] < (6 * g_iBringLevel[attacker]))
				{
					g_iEllisSpeedBoostCounter[attacker]++;
					/*
					if(g_iEllisSpeedBoostCounter[attacker] > (6 * g_iBringLevel[attacker]))
						g_iEllisSpeedBoostCounter[attacker] = (6 * g_iBringLevel[attacker]);
					*/
					//g_fEllisBringSpeed[attacker] = (g_iEllisSpeedBoostCounter[attacker] * 0.01);
					//SetEntDataFloat(attacker, FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[attacker] + g_fEllisBringSpeed[attacker] + g_fEllisOverSpeed[attacker]), true);
					g_fClientSpeedBoost[attacker] += 0.01;
					fnc_SetClientSpeed(attacker);
					//DeleteCode
					//PrintToChatAll("Killed an SI, now setting g_fEllisBringSpeed");
					//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[attacker]);
					//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[attacker]);
					//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[attacker]);
				}
			}
		}
	}
	else if (g_iClientTeam[victim] == TEAM_SURVIVORS)//(GetClientTeam(victim) == TEAM_SURVIVORS && (g_iClientTeam(victim)==TEAM_SURVIVORS))
	{
		/*
		decl i;
		if(g_iNickDesperateMeasuresStack > 0)	//Dont allow desperate stack to go over 3 times
		{
			g_iNickDesperateMeasuresStack--;
			for(i=1;i<=MaxClients;i++)		//Check all the clients to see if they have despearate level up(Nick)
			{
				if(g_iDesperateLevel[i]>0)
				{
					if(RunClientChecks(i))
					{
						if(!IsFakeClient(i))
						{
							if(g_iClientTeam[i]==TEAM_SURVIVORS)
							{
								//SetEntDataFloat(i , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0 + (float(g_iMagnumLevel[i]) * 0.03) + (float(g_iNickDesperateMeasuresStack) * float(g_iDesperateLevel[i]) * 0.02), true);
								g_fClientSpeedBoost[i] += (g_iNickDesperateMeasuresStack * (g_iDesperateLevel[i] * 0.02));
								fnc_SetClientSpeed(i);
								pop(i, 1);
								PrintHintText(i, "A teammate has died, your senses sharpen.");
							}
						}
					}
				}
			}
		}
		*/
		/*
		//g_bIsClientDown[iClient] = true
		if(g_bWasClientDownOnDeath[victim] == true)
		{
			g_iNickDesperateMeasuresIncapStack--;
			if(g_iNickDesperateMeasuresIncapStack < 0)
			{
				g_iNickDesperateMeasuresIncapStack = 0;
			}
			g_bWasClientDownOnDeath[victim] = false;
		}
		g_iNickDesperateMeasuresDeathStack++;
		if(g_iNickDesperateMeasuresDeathStack > 3)
		{
			g_iNickDesperateMeasuresDeathStack = 3;
		}
		g_iNickDesperateMeasuresTotalStack = (g_iNickDesperateMeasuresDeathStack + g_iNickDesperateMeasuresReviveStack);
		decl i;
		for(i=1;i<=MaxClients;i++)
		{
			if(RunClientChecks(i) && g_iClientTeam[i]==TEAM_SURVIVORS)
			{
				g_fClientSpeedBoost[i] += (g_iNickDesperateMeasuresTotalStack * (g_iDesperateLevel[i] * 0.02));
				fnc_SetClientSpeed(i);
				PrintHintText(i, "A teammate has died, your senses sharpen.");
			}
		}
		*/
		if(g_bWasClientDownOnDeath[victim] == true)
		{
			g_bWasClientDownOnDeath[victim] = false;
		}
		else if(g_bWasClientDownOnDeath[victim] == false)
		{
			g_iNickDesperateMeasuresStack++;
			decl i;
			for(i=1;i<=MaxClients;i++)
			{
				if(RunClientChecks(i) && g_iClientTeam[i]==TEAM_SURVIVORS && IsPlayerAlive(i) == true)
				{
					if(g_iNickDesperateMeasuresStack <= 3)
					{
						g_fClientSpeedBoost[i] += (g_iDesperateLevel[i] * 0.02);
						fnc_SetClientSpeed(i);
						PrintHintText(i, "A teammate has died, your senses sharpen.");
					}
				}
			}
		}
		g_fClientSpeedBoost[victim] = 0.0;
		g_fClientSpeedPenalty[victim] = 0.0;
		fnc_SetClientSpeed(victim);
	}
	return Plugin_Continue;
}