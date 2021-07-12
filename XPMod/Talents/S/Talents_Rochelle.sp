TalentsLoad_Rochelle(iClient)
{
	if((g_iHunterLevel[iClient] > 0) || (g_iShadowLevel[iClient] > 0) || (g_iSniperLevel[iClient] > 0))
	{
		SetClientSpeed(iClient);
	}
	//Sets the iClient to hear all the infected's voice comms
	if(g_iGatherLevel[iClient] == 5)
	{
		for(new i = 1; i <= MaxClients; i++)
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
		
		if(g_iShadowLevel[iClient] > 0)
			SetPlayerMaxHealth(iClient, 100 + (g_iShadowLevel[iClient] * 5) + (g_iSniperLevel[iClient] * 5) + (g_iCoachTeamHealthStack * 5), false, !g_bSurvivorTalentsGivenThisRound[iClient]);
	}
	
	if(g_bSurvivorTalentsGivenThisRound[iClient] == false)
	{
		if(g_iSmokeLevel[iClient]>0)
		{
			g_iRopeCountDownTimer[iClient] = 0;
		}
	}
	
	if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Ninja Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilties will be automatically set as you level.");
}

OnGameFrame_Rochelle(iClient)
{
	decl buttons;
	if(g_iSniperLevel[iClient] > 0 || g_iSmokeLevel[iClient] > 0 || g_iGatherLevel[iClient] > 0)
	{
		buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	}
	if(g_iGatherLevel[iClient] > 0)
	{					
		if(!(buttons & IN_SPEED) || !(buttons & IN_USE))
			g_bWalkAndUseToggler[iClient] = false;
		
		if((g_bWalkAndUseToggler[iClient] == false) && ((buttons & IN_SPEED) && (buttons & IN_USE)))	//Toggle The IDD
		{
			g_bWalkAndUseToggler[iClient] = true;
			ToggleDetectionHud(iClient);
		}
	}
	if(g_iSniperLevel[iClient] > 0)
	{
		if(g_bUsingTongueRope[iClient] == false)
		{
			if(g_bIsHighJumpCharged[iClient] == false)
			{
				if(canchangemovement[iClient] == true)
				{
					if(g_bIsHighJumping[iClient] == true)
						if(GetEntityFlags(iClient) & FL_ONGROUND)
						{
							g_bIsHighJumping[iClient] = false;
							SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
						}
				}
				if(buttons & IN_DUCK && g_bIsClientDown[iClient] == false && IsClientGrappled(iClient) == false)
				{
					if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
					{
						g_iHighJumpChargeCounter[iClient]++;
						if(g_iHighJumpChargeCounter[iClient]>60)
						{
							g_iHighJumpChargeCounter[iClient] = 0;
							g_bIsHighJumpCharged[iClient] = true;
							//EmitSoundToClient(iClient, SOUND_CHARGECOACH);
							g_iPID_RochelleJumpCharge[iClient] = WriteParticle(iClient,"rochelle_jump_charge",0.0);
							PrintHintText(iClient, "High Jump Charged!");
							//play sound and particle for charged here
						}
					}
				}
				else
				{
					if(g_iHighJumpChargeCounter[iClient] > 0)
						g_iHighJumpChargeCounter[iClient] = 0;
				}
			}
			else if(g_bIsHighJumpCharged[iClient] == true)	//If High Jump is charged do this
			{
				if(g_bIsClientDown[iClient] == true || IsClientGrappled(iClient) == true)
				{
					g_bIsHighJumping[iClient] = false;
					g_bIsHighJumpCharged[iClient] = false;
					DeleteParticleEntity(g_iPID_RochelleJumpCharge[iClient]);
				}
				else if(canchangemovement[iClient] == true)
				{
					if(buttons & IN_JUMP)
					{
						//PrintToChatAll("Jumping just happend");
						if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
						{
							g_bIsHighJumping[iClient] = true;
							g_bIsHighJumpCharged[iClient] = false;
							decl Float:jumpvec[3];
							jumpvec[0] = 0.0;
							jumpvec[1] = 0.0;
							jumpvec[2] = (60.0 * float(g_iSniperLevel[iClient])) + 400.0;
							TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, jumpvec);
							WriteParticle(iClient, "rochelle_jump_charge_release", 0.0, 5.0);
							WriteParticle(iClient, "rochelle_jump_charge_trail", 0.0, 5.0);
							DeleteParticleEntity(g_iPID_RochelleJumpCharge[iClient]);
							SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
						}
					}
				}
			}
		}
	}
	if(g_iSmokeLevel[iClient] > 0)
	{
		//Rope
		if(g_bUsingTongueRope[iClient])
		{			
			if(g_bHasDemiGravity[iClient] == false)
			{
				decl Float:clientloc[3];
				GetClientAbsOrigin(iClient,clientloc);
				if(g_xyzRopeEndLocation[iClient][2] < (clientloc[2] + 50.0))
					return;																											//Get rid of this return
				
				decl Float:velocity[3],Float:velocity2[3];
				
				velocity2[0] = (g_xyzRopeEndLocation[iClient][0] - clientloc[0]) * 3.0;
				velocity2[1] = (g_xyzRopeEndLocation[iClient][1] - clientloc[1]) * 3.0;
				new Float:y_coord,Float:x_coord;
				y_coord = velocity2[0]*velocity2[0] + velocity2[1]*velocity2[1];
				//x_coord=(GetConVarFloat(cvarRopeSpeed)*20.0)/SquareRoot(y_coord);
				x_coord = (10.0) / (SquareRoot(y_coord));
				
				GetEntDataVector(iClient, g_iOffset_VecVelocity, velocity);
				velocity[0] += velocity2[0] * x_coord;
				velocity[1] += velocity2[1] * x_coord;
				
				if(velocity[0] < 0.0)		//Limit the speed velocity for x and y
				{
					if(velocity[0] < -300.0)
						velocity[0] = -300.0;
				}
				else if(velocity[0] > 300.0)
					velocity[0] = 300.0;
				if(velocity[1] < 0.0)
				{
					if(velocity[1] < -300.0)
						velocity[1] = -300.0;
				}
				else if(velocity[1] > 300.0)
					velocity[1] = 300.0;
				
				velocity[2] = 33.333333;	//This is to counter act the falling rate.
				
				//Check the distance
				g_xyzRopeDistance[iClient] = GetVectorDistance(clientloc,g_xyzRopeEndLocation[iClient], false);
				g_xyzRopeDistance[iClient] *= 0.08;
				//PrintHintText(iClient, "Rope Distance = %f", g_xyzRopeDistance[iClient]);
				if(g_xyzRopeDistance[iClient] > ((float(g_iSmokeLevel[iClient])*40.0) + 5.0))
				{
					PrintHintText(iClient, "Your grappling hook doesnt reach beyond %.0f ft.", (float(g_iSmokeLevel[iClient]) * 40.0));
					velocity[0] *= -0.5;	//Somehow slowly bring to stop to smoothen it
					velocity[1] *= -0.5;
					if(g_xyzRopeEndLocation[iClient][2] > (clientloc[2] + 100.0))
						velocity[2] = 175.0;
				}
				
				if(buttons & IN_JUMP)
				{
					if(g_xyzRopeEndLocation[iClient][2] > (clientloc[2] + 100.0))
						velocity[2] = 175.0;
				}
				else if(buttons & IN_DUCK)
				{
					if(g_xyzRopeDistance[iClient] < ((float(g_iSmokeLevel[iClient])*40.0) + 5.0))
						velocity[2] = -230.0;
				}
				
				//PrintHintText(iClient, "velocity = %.1f, %.1f, %f      Rope Distance = %.1f", velocity[0], velocity[1], velocity[2], g_xyzRopeDistance[iClient]);
				TeleportEntity(iClient,NULL_VECTOR,NULL_VECTOR,velocity);
				
				g_xyzClientLocation[iClient][0] = clientloc[0];
				g_xyzClientLocation[iClient][1] = clientloc[1];
				g_xyzClientLocation[iClient][2] = clientloc[2] + 35.0;
				
				if(g_iRopeCountDownTimer[iClient] == 750)
					PrintHintText(iClient,"Your about to stretch your SMOKER tongue beyond its breaking point");
				if(g_iRopeCountDownTimer[iClient] >= 900)
				{
					EmitSoundToAll(SOUND_HOOKRELEASE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);	// Emit sound from the end of the rope
					g_bUsingTongueRope[iClient] = false;
					PrintHintText(iClient,"Your have broken your SMOKER tongue rope");
				}
				else
					g_iRopeCountDownTimer[iClient]++;
			}
			else
			{
				EmitSoundToAll(SOUND_HOOKRELEASE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);	// Emit sound from the end of the rope
				g_bUsingTongueRope[iClient] = false;
			}
		}
		else if(g_bUsedTongueRope[iClient]==true)
		{
			if(canchangemovement[iClient] == true)
			{
				if(g_bIsHighJumping[iClient] == false)
					if(GetEntityFlags(iClient) & FL_ONGROUND)
					{
						SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
						g_bUsedTongueRope[iClient] = false;
					}
			}
		}
		if(clienthanging[iClient] == true)
		{
			if(buttons & IN_SPEED)
			{

				RunCheatCommand(iClient, "give", "give health");

				SetPlayerHealth(iClient, preledgehealth[iClient]);
				if(preledgebuffer[iClient] > 1.1)
					SetEntDataFloat(iClient,g_iOffset_HealthBuffer, (preledgebuffer[iClient] - 1.0) ,true);
				else
					SetEntDataFloat(iClient,g_iOffset_HealthBuffer, 0.0 ,true);
				
				g_bIsClientDown[iClient] = false;
				clienthanging[iClient] = false;
			}
		}
		else
		{
			preledgehealth[iClient] = GetClientHealth(iClient);
			preledgebuffer[iClient] = GetEntDataFloat(iClient,g_iOffset_HealthBuffer);
		}
	}
	if(g_iSilentLevel[iClient] > 0)
	{
		buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if((buttons & IN_RELOAD) && g_bClientIsReloading[iClient] == false && g_bForceReload[iClient] == false)
		{
			decl String:currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (IsValidEntity(ActiveWeaponID) == false)
				return;
			new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			if((StrEqual(currentweapon, "weapon_sniper_military", false) == true) && (CurrentClipAmmo == 30))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
				if(iAmmo > 0)
				{
					g_bForceReload[iClient] = true;
					g_iSavedClip[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
					SetEntData(iClient, iOffset_Ammo + 40, iAmmo + g_iSavedClip[iClient]);
				}
			}
		}
	}
}

EventsHurt_AttackerRochelle(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(attacker))
		return;

	if (g_iClientTeam[victim] != TEAM_INFECTED)
		return;

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
				new hp = GetPlayerHealth(victim);
				new dmg = GetEventInt(hEvent,"dmg_health");

				dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.13));
				dmg = CalculateDamageTakenForVictimTalents(victim, dmg, weaponclass);

				//PrintToChat(attacker, "your doing %d hunting rifle damage", dmg);
				SetPlayerHealth(victim, hp - dmg);

			}
			else if(StrContains(weaponclass,"sniper_military",false) != -1)	//H&K MSG 90
			{
				IgniteEntity(victim, 5.0, false);
				new hp = GetPlayerHealth(victim);
				new dmg = GetEventInt(hEvent,"dmg_health");

				dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.08));
				dmg = CalculateDamageTakenForVictimTalents(victim, dmg, weaponclass);

				//PrintToChat(attacker, "your doing %d sniper_military damage", dmg);
				SetPlayerHealth(victim, hp - dmg);

			}
			else if(StrContains(weaponclass,"sniper_scout",false) != -1)
			{
				new hp = GetPlayerHealth(victim);
				new dmg = GetEventInt(hEvent,"dmg_health");

				dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.13)) + (g_iSilentSorrowHeadshotCounter[attacker] * g_iSilentLevel[attacker] * 3);
				dmg = CalculateDamageTakenForVictimTalents(victim, dmg, weaponclass);

				//PrintToChat(attacker, "your doing %d scout damage", dmg);
				SetPlayerHealth(victim, hp - dmg);

			}
			else if(StrContains(weaponclass,"sniper_awp",false) != -1)
			{
				new hp = GetPlayerHealth(victim);
				new dmg = GetEventInt(hEvent,"dmg_health");

				dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.40) );
				dmg = CalculateDamageTakenForVictimTalents(victim, dmg, weaponclass);

				//PrintToChat(attacker, "your doing %d extra awp damage", dmg);
				SetPlayerHealth(victim, hp - dmg);
			}
		}
	}
}

// EventsHurt_VictimRochelle(Handle:hEvent, attacker, victim)
// {
// 	if (IsFakeClient(victim))
// 		return;
// }

EventsDeath_AttackerRochelle(Handle:hEvent, iAttacker, iVictim)
{
	if (g_iChosenSurvivor[iAttacker] != ROCHELLE ||
		g_bTalentsConfirmed[iAttacker] == false ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		RunClientChecks(iAttacker) == false ||
		IsFakeClient(iAttacker) == true)
		return;
	
	SuppressNeverUsedWarning(iVictim);

	// Check if common infected headshot
	if(g_iSilentLevel[iAttacker] > 0 && 
		iVictim < 1 &&
		GetEventBool(hEvent, "headshot"))
	{
		if(g_iSilentSorrowHeadshotCounter[iAttacker] < 20)
			g_iSilentSorrowHeadshotCounter[iAttacker]++;
	}
}

// EventsDeath_VictimRochelle(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

	
bool Event_TongueGrab_Rochelle(int iAttacker, int iVictim)
{
	if (g_iChosenSurvivor[iVictim] != ROCHELLE || 
		g_iSmokeLevel[iVictim] <= 0 ||
		g_bTalentsConfirmed[iVictim] == false)
		return false;

	int percentchance;
	switch(g_iSmokeLevel[iVictim])
	{
		case 1:
			percentchance = GetRandomInt(1, 20);
		case 2:
			percentchance = GetRandomInt(1, 10);
		case 3:
			percentchance = GetRandomInt(1, 7);
		case 4:
			percentchance = GetRandomInt(1, 5);
		case 5:
			percentchance = GetRandomInt(1, 4);
	}
	if(percentchance == 1)
	{
		PrintHintText(iVictim, "You have ninja'd out of the Smoker's grasp");
		
		//Cloak
		SetEntityRenderMode(iVictim, RenderMode:3);
		SetEntityRenderColor(iVictim, 255, 255, 255, RoundToFloor(255 * (1.0 - (g_iSmokeLevel[iVictim] * 0.19))));
		//Disable Glow
		SetEntProp(iVictim, Prop_Send, "m_iGlowType", 3);
		SetEntProp(iVictim, Prop_Send, "m_nGlowRange", 0);
		SetEntProp(iVictim, Prop_Send, "m_glowColorOverride", 1);
		ChangeEdictState(iVictim, 12);
		
		delete g_hTimer_ResetGlow[iVictim];
		g_hTimer_ResetGlow[iVictim] = CreateTimer(5.0, Timer_ResetGlow, iVictim);

		if(IsFakeClient(iAttacker)==false)
		{
			PrintHintText(iAttacker, "%N has ninja'd out of your tongue", iVictim);
			SetEntProp(iAttacker, Prop_Send, "m_iHideHUD", 4);
			CreateTimer(5.0, TimerGiveHudBack, iAttacker, TIMER_FLAG_NO_MAPCHANGE); 
		}
		GetClientAbsOrigin(iVictim, g_xyzOriginalPositionRochelle[iVictim]);
		g_xyzOriginalPositionRochelle[iVictim][2] += 10;
		
		TeleportEntity(iVictim, g_xyzBreakFromSmokerVector, NULL_VECTOR, NULL_VECTOR);
		
		CreateTimer(0.1, Timer_BreakFreeOfSmoker, iVictim, TIMER_FLAG_NO_MAPCHANGE);

		SetClientRenderAndGlowColor(iVictim);
		return true;
	}

	return false;
}


DetectionHud(iClient)
{
	if(IsClientInGame(iClient)==false)
		return;
	if(IsPlayerAlive(iClient)==false)
		return;
	if(g_bGameFrozen == true)
		return;
	
	decl Float:detdistance;
	decl Float:clientvec[3];
	new Float:infectedvec[3];
	decl classnum;
	g_fDetectedDistance_Smoker[iClient] = 0.0;
	g_fDetectedDistance_Boomer[iClient] = 0.0;
	g_fDetectedDistance_Hunter[iClient] = 0.0;
	g_fDetectedDistance_Spitter[iClient] = 0.0;
	g_fDetectedDistance_Jockey[iClient] = 0.0;
	g_fDetectedDistance_Charger[iClient] = 0.0;
	g_fDetectedDistance_Tank[iClient] = 0.0;
	GetClientAbsOrigin(iClient, clientvec);
	g_bDrawIDD[iClient] = false;
	for(new infected = 1;infected<= MaxClients;infected++)
	{
		if(IsClientInGame(infected)==true)
		{
			if(GetClientTeam(infected)==TEAM_INFECTED)
			{
				if(IsPlayerAlive(infected)==true)
				{
					if(GetEntData(infected, g_iOffset_IsGhost, 1)!=1)
					{
						GetClientAbsOrigin(infected, infectedvec);
						detdistance = GetVectorDistance(clientvec, infectedvec);
						classnum= GetEntProp(infected, Prop_Send, "m_zombieClass");
						if(g_iGatherLevel[iClient]==5 || (detdistance <= (g_iGatherLevel[iClient] * 500)))
						{
							switch(classnum)
							{
								case 1:
									if(g_fDetectedDistance_Smoker[iClient] > detdistance || g_fDetectedDistance_Smoker[iClient] == 0.0)
									{
										
										g_bDrawIDD[iClient] = true;
										g_fDetectedDistance_Smoker[iClient] = detdistance * 0.08;
									}
								case 2:
									if(g_fDetectedDistance_Boomer[iClient] > detdistance || g_fDetectedDistance_Boomer[iClient] == 0.0)
									{
										g_bDrawIDD[iClient] = true;
										g_fDetectedDistance_Boomer[iClient] = detdistance * 0.08;
									}
								case 3:
									if(g_fDetectedDistance_Hunter[iClient] > detdistance || g_fDetectedDistance_Hunter[iClient] == 0.0)
									{
										g_bDrawIDD[iClient] = true;
										g_fDetectedDistance_Hunter[iClient] = detdistance * 0.08;
									}
								case 4:
									if((g_fDetectedDistance_Spitter[iClient] > detdistance) || g_fDetectedDistance_Spitter[iClient] == 0.0)
									{
										g_bDrawIDD[iClient] = true;
										g_fDetectedDistance_Spitter[iClient] = detdistance * 0.08;
									}
								case 5:
									if(g_fDetectedDistance_Jockey[iClient] > detdistance || g_fDetectedDistance_Jockey[iClient] == 0.0)
									{
										g_bDrawIDD[iClient] = true;
										g_fDetectedDistance_Jockey[iClient] = detdistance * 0.08;
									}
								case 6:
									if(g_fDetectedDistance_Charger[iClient] > detdistance || g_fDetectedDistance_Charger[iClient] == 0.0)
									{
										g_bDrawIDD[iClient] = true;
										g_fDetectedDistance_Charger[iClient] = detdistance * 0.08;
									}
								case 8:
									if(g_fDetectedDistance_Tank[iClient] > detdistance || g_fDetectedDistance_Tank[iClient] == 0.0)
									{
										g_bDrawIDD[iClient] = true;
										g_fDetectedDistance_Tank[iClient] = detdistance * 0.08;
									}
							}
						}
					}
				}
			}
		}
	}
	if(g_bDrawIDD[iClient]==true)
		DetectionHudMenuDraw(iClient);
}

OGFSurvivorReload_Rochelle(iClient, const char[] currentweapon, ActiveWeaponID, CurrentClipAmmo, iOffset_Ammo)
{
	if((StrEqual(currentweapon, "weapon_hunting_rifle", false) == true) && (g_iSilentLevel[iClient] > 1) && (CurrentClipAmmo != 0))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);	//for hunting rifle (+36)
		if((iAmmo + CurrentClipAmmo) > (17 - (g_iSilentLevel[iClient] * 2)))
		{
			SetEntData(iClient, iOffset_Ammo + 36, iAmmo + (CurrentClipAmmo - (17 - (g_iSilentLevel[iClient] * 2))));
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, 17 - (g_iSilentLevel[iClient] * 2), true);
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
	else if((StrEqual(currentweapon, "weapon_sniper_awp", false) == true) && (g_iSilentLevel[iClient] > 1) && (CurrentClipAmmo != 0))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
		if((iAmmo + CurrentClipAmmo) > 3)
		{
			SetEntData(iClient, iOffset_Ammo + 40, iAmmo + (CurrentClipAmmo - 3));
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, 3, true);
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
	else if((StrEqual(currentweapon, "weapon_sniper_scout", false) == true) && (g_iSilentLevel[iClient] > 1) && (CurrentClipAmmo != 0))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
		if((iAmmo + CurrentClipAmmo) > (20 - g_iSilentLevel[iClient]))
		{
			SetEntData(iClient, iOffset_Ammo + 40, iAmmo + (CurrentClipAmmo - (20 - g_iSilentLevel[iClient])));
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (20 - g_iSilentLevel[iClient]), true);
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
	else if((StrEqual(currentweapon, "weapon_sniper_military", false) == true) && (g_iSilentLevel[iClient] > 1) && (CurrentClipAmmo == 30))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
		if(iAmmo >= (g_iSilentLevel[iClient] * 6))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iSilentLevel[iClient] * 6)), true);
			SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iSilentLevel[iClient] * 6));
		}
		else if(iAmmo < (g_iSilentLevel[iClient] * 6))
		{
			new NewAmmo = ((g_iSilentLevel[iClient] * 6) - iAmmo);
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iSilentLevel[iClient] * 6) - NewAmmo)), true);
			SetEntData(iClient, iOffset_Ammo + 40, 0);
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
}

ToggleDetectionHud(iClient)
{
	if(iClient==0)
		iClient = 1;
	if(g_iGatherLevel[iClient]>0)
	{
		decl Float:xyzVector[3];
		GetClientAbsOrigin(iClient, xyzVector);
		
		g_bClientIDDToggle[iClient] = !g_bClientIDDToggle[iClient];
				
		if(g_bClientIDDToggle[iClient] == true)
		{
			EmitSoundToAll(SOUND_IDD_ACTIVATE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzVector, NULL_VECTOR, true, 0.0);
			PrintHintText(iClient, "D.E.A.D. Infected Detection Device is now on");
		}
		else
		{
			EmitSoundToAll(SOUND_IDD_DEACTIVATE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzVector, NULL_VECTOR, true, 0.0);
			PrintHintText(iClient, "D.E.A.D. Infected Detection Device is now off");
		}
	}
	else
		PrintHintText(iClient, "You do not have an Infected Detection Device");
	return;
}

bool HandleFastAttackingClients_Rochelle(const int iClient, const int iActiveWeaponID, const int iActiveWeaponSlot, const float fGameTime, const float fCurrentNextAttackTime, float &fAdjustedNextAttackTime)
{
	if (g_iShadowLevel[iClient] <= 0)
		return false;

	// Check if its a secondary weapon
	if (iActiveWeaponSlot != 1)
		return false;

	// Check to make sure its a melee weapon
	char strEntityClassName[32];
	GetEntityClassname(iActiveWeaponID, strEntityClassName, 32);
	// PrintToChat(iClient, "strEntityClassName: %s", strEntityClassName);
	if (StrContains(strEntityClassName, "weapon_melee", true) == -1)
		return false;

	// All checks were passed, set the speed
	fAdjustedNextAttackTime = ( fCurrentNextAttackTime - fGameTime ) * (1 / (1 + (g_iShadowLevel[iClient] * 0.3) ) )   + fGameTime;
	// Show the particle effect
	WriteParticle(iClient, "rochelle_silhouette", 0.0, 0.4);

	return true;
}

