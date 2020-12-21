OnGameFrame_Tank(iClient)
{
	//Check to see if the charging has already taken place or depleted
	if((g_iTankChosen[iClient] == FIRE_TANK && g_bTankAttackCharged[iClient] == true) ||
		(g_iTankChosen[iClient] == ICE_TANK && g_iIceTankLifePool[iClient] < 1) ||
		g_iTankChosen[iClient] == NO_TANK_CHOSEN)
		return;
	
	new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	
	//Check to see if ducking and not attacking before starting the charge
	if((buttons & IN_DUCK) && !(buttons & IN_ATTACK) && !(buttons & IN_ATTACK2))
	{
		decl Float:xyzCurrentPosition[3];
		GetClientAbsOrigin(iClient, xyzCurrentPosition);
		
		//Make sure the tank hasnt moved while charging(tanks position has changed)
		if(g_xyzClientPosition[iClient][0] == xyzCurrentPosition[0] && 
			g_xyzClientPosition[iClient][1] == xyzCurrentPosition[1] && 
			g_xyzClientPosition[iClient][2] == xyzCurrentPosition[2])
		{
			g_iTankCharge[iClient]++;
		}
		else
		{
			if(g_iTankCharge[iClient] != 0)
			{
				if(g_iTankCharge[iClient] > 31)
					PrintHintText(iClient, "Charge Interrupted");
				
				g_iTankCharge[iClient] = 0;
				g_bShowingIceSphere[iClient] = false;
			}
			g_xyzClientPosition[iClient][0] = xyzCurrentPosition[0];
			g_xyzClientPosition[iClient][1] = xyzCurrentPosition[1];
			g_xyzClientPosition[iClient][2] = xyzCurrentPosition[2];
		}
		
		//Display the first message to the player while he is charging up
		if(g_iTankCharge[iClient] == 30)
		{
			if(g_iTankChosen[iClient] == FIRE_TANK)
			{
				if(g_bBlockTankFirePunchCharge[iClient] == false)
				{
					PrintHintText(iClient, "Charging Up Attack");
				}
				else
				{
					PrintHintText(iClient, "You must wait to charge your fire punch attack");
					g_iTankCharge[iClient] = 0;
				}
			}
			else if(g_iTankChosen[iClient] == ICE_TANK)
				PrintHintText(iClient, "Charging Up Health"); 
		}
		
		//Charged for long enough, now handle for each tank
		if(g_iTankCharge[iClient] >= 150)
		{
			if(g_iTankChosen[iClient] == FIRE_TANK)
			{
				g_bTankAttackCharged[iClient] = true;
				g_iTankCharge[iClient] = 0;				
				g_iPID_TankChargedFire[iClient] = CreateParticle("fire_small_01", 0.0, iClient, ATTACH_DEBRIS);
				
				PrintHintText(iClient, "Fire Punch Attack Charged", g_iTankCharge[iClient]);
			}
			else if(g_iTankChosen[iClient] == ICE_TANK)
			{
				decl Float:fCurrentTankHealthPercentage;
				new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
				
				if(g_iIceTankLifePool[iClient] > 0 && iCurrentHealth < 6000 + g_iClientLevel[iClient] * 400)
				{
					if(g_iIceTankLifePool[iClient] > 5)
					{
						SetEntProp(iClient, Prop_Data,"m_iHealth", iCurrentHealth + 5);
						fCurrentTankHealthPercentage = float(iCurrentHealth + 5) / float(6000 + g_iClientLevel[iClient] * 400);
						g_iIceTankLifePool[iClient] -= 5;
						
						PrintHintText(iClient, "Life Pool Remaining: %d", g_iIceTankLifePool[iClient]);
						
						//Show the ice sphere around the Ice Tank
						g_bShowingIceSphere[iClient] = true;
						
						if(g_iPID_IceTankChargeMist[iClient] == -1 && g_iPID_IceTankChargeSnow[iClient] == -1)
						{
							g_iPID_IceTankChargeMist[iClient] = WriteParticle(iClient, "ice_tank_charge_mist", 50.0);
							g_iPID_IceTankChargeSnow[iClient] = WriteParticle(iClient, "ice_tank_charge_snow", 50.0);
						}
						
						if(g_hTimer_IceSphere[iClient] == null)
							g_hTimer_IceSphere[iClient] = CreateTimer(0.1, Timer_CreateSmallIceSphere, iClient, TIMER_REPEAT);
						
						//Check to see if there is a player inside of the ice sphere and freeze him if he is
						for(new iVictim = 1; iVictim <= MaxClients; iVictim++)
						{
							if(g_bFrozenByTank[iVictim] == true || g_iClientTeam[iVictim] != TEAM_SURVIVORS 
								|| IsClientInGame(iVictim) == false || IsPlayerAlive(iVictim) == false)
								continue;
							
							decl Float:xyzVictimPosition[3];
							GetClientAbsOrigin(iVictim, xyzVictimPosition);
							
							new Float:fDistance = GetVectorDistance(xyzVictimPosition, xyzCurrentPosition, false);
							
							//The sphere radius is about 125.0 but check for 130.0 to be safe
							if(fDistance <= 130.0)
								CreateTimer(0.1, Timer_FreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
						}
					}
					else
					{
						SetEntProp(iClient, Prop_Data,"m_iHealth", iCurrentHealth + g_iIceTankLifePool[iClient]);
						fCurrentTankHealthPercentage = float(iCurrentHealth + g_iIceTankLifePool[iClient]) / float(6000 + g_iClientLevel[iClient] * 400);
						g_iIceTankLifePool[iClient] = 0;
						
						PrintHintText(iClient, "Life Pool Depleted");
						
						g_bShowingIceSphere[iClient] = false;
					}
					
					//Set the color of the tank to match his current health percentage
					new iGreen	= 20 + RoundToNearest(235 * fCurrentTankHealthPercentage);
					
					SetEntityRenderMode(iClient, RenderMode:0);
					SetEntityRenderColor(iClient, 0, iGreen, 255, 255);
				}
			}
		}
	}
	else if(g_iTankCharge[iClient] > 0)
	{
		if(g_iTankCharge[iClient] > 31)
			PrintHintText(iClient, "Charge Interrupted");
		
		g_iTankCharge[iClient] = 0;
		g_bShowingIceSphere[iClient] = false;
	}
}

LoadFireTankTalents(iClient)
{
	g_fClientSpeedBoost[iClient] = 0.0;
	g_fClientSpeedPenalty[iClient] = 0.0;
	
	if(iClient < 1 || g_iClientTeam[iClient] != TEAM_INFECTED || IsClientInGame(iClient) == false || 
		IsFakeClient(iClient) == true || GetEntProp(iClient, Prop_Send, "m_zombieClass") != TANK)
		return;
	
	if(IsPlayerAlive(iClient) == false)
	{
		PrintToChat(iClient, "\x04You cannot choose tank talents after you have died");
		return;
	}
	
	g_iTankChosen[iClient] = FIRE_TANK;
	g_fTankHealthPercentage[iClient] =  1.0;
	g_bBlockTankFirePunchCharge[iClient] = false;
	
	//Set On Fire
	IgniteEntity(iClient, 10000.0, false);
	CreateTimer(10000.0, Timer_ReigniteTank, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	//Give Health
	SetEntProp(iClient, Prop_Data,"m_iMaxHealth", (6000 + g_iClientLevel[iClient] * 100));
	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	SetEntProp(iClient, Prop_Data,"m_iHealth", iCurrentHealth + (g_iClientLevel[iClient] * 100));
	
	//Set Movement Speed
	//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), 1.2, true);
	g_fClientSpeedBoost[iClient] += 0.2;
	fnc_SetClientSpeed(iClient);
	
	//Change Skin Color
	SetEntityRenderMode(iClient, RenderMode:0);
	SetEntityRenderColor(iClient, 255, 200, 0, 255);
	//SetEntityRenderColor(iClient, 210, 88, 30, 255);
	
	PrintHintText(iClient, "You are now the Fire Tank");
}

LoadIceTankTalents(iClient)
{
	g_fClientSpeedBoost[iClient] = 0.0;
	g_fClientSpeedPenalty[iClient] = 0.0;

	if(iClient < 1 || g_iClientTeam[iClient] != TEAM_INFECTED || IsClientInGame(iClient) == false || 
		IsFakeClient(iClient) == true || GetEntProp(iClient, Prop_Send, "m_zombieClass") != TANK)
		return;
	
	if(IsPlayerAlive(iClient) == false)
	{
		PrintToChat(iClient, "\x04You cannot choose tank talents after you have died");
		return;
	}
	
	g_iTankChosen[iClient] = ICE_TANK;
	g_fTankHealthPercentage[iClient] =  1.0;
	g_iIceTankLifePool[iClient] = 200 * g_iClientLevel[iClient];
	
	//Stop Kiting
	SetConVarInt(FindConVar("z_tank_damage_slow_min_range"), 0);
	SetConVarInt(FindConVar("z_tank_damage_slow_max_range"), 0);
	//Stop Rock Throwing Cooldown
	SetConVarFloat(FindConVar("z_tank_throw_interval"), 1.0);
	
	//Give Health
	SetEntProp(iClient, Prop_Data,"m_iMaxHealth", (6000 + g_iClientLevel[iClient] * 400));
	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	SetEntProp(iClient, Prop_Data,"m_iHealth", iCurrentHealth + (g_iClientLevel[iClient] * 400));
	
	//Set Movement Speed
	//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), 1.0 - (RoundToCeil(g_iClientLevel[iClient] / 5.0) * 0.01), true);
	//g_fClientSpeedPenalty[iClient] += (RoundToCeil(g_iClientLevel[iClient] / 5.0) * 0.01);
	//fnc_SetClientSpeed(iClient);
	
	//Change Skin Color
	SetEntityRenderMode(iClient, RenderMode:0);
	SetEntityRenderColor(iClient, 0, 255, 255, 255);

	//Grow the tank, doesnt seem to work
	//SetEntPropFloat(iClient , Prop_Send,"m_flModelScale", 1.3); 
	
	//Attach particle effect
	g_iPID_IceTankIcicles[iClient] = CreateParticle("ice_tank_icicles", 0.0, iClient, ATTACH_RSHOULDER);
	
	PrintHintText(iClient, "You are now the Ice Tank");
}

SetFireToPlayer(iVictim, iAttacker, Float:fTime)
{
	if(iVictim < 1 || IsClientInGame(iVictim) == false)
		return;
	
	g_iFireDamageCounter[iVictim] = RoundToNearest(fTime * 2);
	IgniteEntity(iVictim, fTime, false);
	WriteParticle(iVictim, "fire_small_01", 40.0, fTime);
	
	new Handle:hEntityPack = CreateDataPack();
	WritePackCell(hEntityPack, iVictim);
	WritePackCell(hEntityPack, iAttacker);
	CreateTimer(0.5, Timer_DealFireDamage, hEntityPack, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

FreezePlayerByTank(iVictim, Float:fFreezeTime, Float:fStartTime = 0.2)
{
	if(iVictim < 1 || IsClientInGame(iVictim) == false)
		return;
	
	CreateTimer(fStartTime, Timer_FreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(fFreezeTime, Timer_UnfreezePlayerByTank, iVictim, TIMER_FLAG_NO_MAPCHANGE);
}

UnfreezePlayerByTank(iClient)
{
	if(iClient < 1 || g_iClientTeam[iClient] != TEAM_SURVIVORS || g_bFrozenByTank[iClient] == false || IsValidEntity(iClient) == false || 
		IsClientInGame(iClient) == false || IsPlayerAlive(iClient) == false)
		return;
	
	g_bFrozenByTank[iClient] =  false;
	g_bBlockTankFreezing[iClient] = true;
	
	//Reset To Allow The Player To Freeze Again
	CreateTimer(3.0, Timer_UnblockTankFreezing, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	//Play Ice Break Sound
	new Float:vec[3];
	GetClientAbsOrigin(iClient, vec);
	EmitAmbientSound(SOUND_FREEZE, vec, iClient, SNDLEVEL_NORMAL);
	
	StopHudOverlayColor(iClient)
	
	//Set Player Model Color
	fnc_SetRendering(iClient);
	//ResetGlow(iClient);
	
	//Reset Movement Speed
	fnc_SetClientSpeed(iClient);
	//ResetSurvivorSpeed(iClient);
}

CreateIceSphere(iClient, Float:fSphereDiameter, iRings, Float:fRingWidth, Float:fLifeTime, Float:fZOffset = 50.0)
{
	new Float:fRings = float(iRings);
	decl Float:fRingDiameter, Float:xyzOrigin[3];
	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", xyzOrigin);
	
	
	new Float:xyzRingPosition[3];
	
	xyzRingPosition[0] = xyzOrigin[0];
	xyzRingPosition[1] = xyzOrigin[1];
	//Raise the sphere to center it around the player
	xyzOrigin[2] += fZOffset;
	
	decl i;
	for(i = 1; i < iRings; i++)
	{
		fRingDiameter = 0.0 + fSphereDiameter * Sine(PI * (i / fRings));
		
		xyzRingPosition[2] = xyzOrigin[2] + ((fSphereDiameter / 2.0) * Cosine(PI * (i / fRings)));
		
		TE_Start("BeamRingPoint");
		TE_WriteVector("m_vecCenter", xyzRingPosition);
		TE_WriteFloat("m_flStartRadius",  fRingDiameter);
		TE_WriteFloat("m_flEndRadius", fRingDiameter + 0.1);
		TE_WriteNum("m_nModelIndex", g_iSprite_Laser);
		TE_WriteNum("m_nHaloIndex", g_iSprite_Halo);
		TE_WriteNum("m_nStartFrame", 0);
		TE_WriteNum("m_nFrameRate", 60);
		TE_WriteFloat("m_fLife", fLifeTime);
		TE_WriteFloat("m_fWidth", fRingWidth);
		TE_WriteFloat("m_fEndWidth", fRingWidth);
		TE_WriteFloat("m_fAmplitude",  0.1);	//0.5
		TE_WriteNum("r", 0);
		TE_WriteNum("g", 30);
		TE_WriteNum("b", 180);
		TE_WriteNum("a", 35);
		TE_WriteNum("m_nSpeed", 1);
		TE_WriteNum("m_nFlags", 0);
		TE_WriteNum("m_nFadeLength", 0);
		TE_SendToAll();
	}
}