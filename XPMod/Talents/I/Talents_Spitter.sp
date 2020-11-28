OnGameFrame_Spitter(iClient)
{
	if(g_iPuppetLevel[iClient] > 5)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		
		if(!(buttons & IN_SPEED))
			g_bWalkAndUseToggler[iClient] = false;
		
		if((g_bWalkAndUseToggler[iClient] == false) && (buttons & IN_SPEED))	//Toggle Goo Types
		{
			g_bWalkAndUseToggler[iClient] = true;
			//ChangeGooType(iClient);
			if(g_bBlockGooSwitching[iClient] == true)
			{
			PrintToChat(iClient, "\x03[XPMod] \x04Wait until your goo dissipates before changing goo types.");
			}
			else
			{
				GooTypeMenuDraw(iClient);
			}
		}
		
		if(g_bIsStealthSpitter[iClient] == false)
		{
			if(buttons & IN_DUCK)
			{
				if(g_iStealthSpitterChargePower[iClient] == 1)
					PrintHintText(iClient, "Casting Phase Shift...");
				else if(g_iStealthSpitterChargePower[iClient] > 49)
					PrintHintText(iClient, "Casting Phase Shift...%d%%", g_iStealthSpitterChargePower[iClient]);
				g_iStealthSpitterChargePower[iClient]++;
				if(g_iStealthSpitterChargePower[iClient] == 100)
				{
					g_bIsStealthSpitter[iClient] = true;
					
					SetEntityRenderMode(iClient, RenderMode:3);
					SetEntityRenderColor(iClient, 255, 255, 255, 1);
					
					g_iPID_SpitterSlimeTrail[iClient] = CreateParticle("spitter_slime_trail", 0.0, iClient, ATTACH_MOUTH);
					
					//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 2.0, true);
					g_fClientSpeedBoost[iClient] += 1.0;
					fnc_SetClientSpeed(iClient);
					
					g_iStealthSpitterChargePower[iClient] =  0;
				}
			}
			else
			{
				if(g_iStealthSpitterChargePower[iClient] > 0)
					g_iStealthSpitterChargePower[iClient] =  0;
				if(g_iStealthSpitterChargeMana[iClient] >= ((g_iHallucinogenicLevel[iClient] * 300) - 5) && g_iStealthSpitterChargeMana[iClient] < (g_iHallucinogenicLevel[iClient] * 300))
				{
					PrintHintText(iClient, "Phase Shift Spell Ready");
				}
				if(g_iStealthSpitterChargeMana[iClient] < (g_iHallucinogenicLevel[iClient] * 300))
					g_iStealthSpitterChargeMana[iClient]+=5;
			}
		}
		else
		{
			PrintHintText(iClient, "Mana Remaining: %d", g_iStealthSpitterChargeMana[iClient] / 20);
			g_iStealthSpitterChargeMana[iClient]--;
			if((buttons & IN_FORWARD) || (buttons & IN_BACK) || (buttons & (IN_LEFT|IN_MOVELEFT)) || (buttons & (IN_RIGHT|IN_MOVERIGHT)))
			{
				g_iStealthSpitterChargeMana[iClient]-=9;
				PrintHintText(iClient, "Mana Remaining: %d", g_iStealthSpitterChargeMana[iClient] / 20);
			}
			if(g_iStealthSpitterChargeMana[iClient] < 11)
			{
				PrintHintText(iClient, "Mana Depleted");
				
				DeleteParticleEntity(g_iPID_SpitterSlimeTrail[iClient]);
				g_iPID_SpitterSlimeTrail[iClient] = -1;
				
				SetEntityRenderMode(iClient, RenderMode:3);
				SetEntityRenderColor(iClient, 255, 255, 255, 255);
				
				//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0, true);
				g_fClientSpeedBoost[iClient] -= 1.0;
				fnc_SetClientSpeed(iClient);
				g_bIsStealthSpitter[iClient] = false;
			}
		}
	}
}
/*
ChangeGooType(iClient)
{
	if(g_bBlockGooSwitching[iClient] == true)
		PrintToChat(iClient, "\x03[XPMod] \x04Wait until your goo dissipates before changing goo types.");
	else
		g_iGooType[iClient]++;
	
	if(g_iClientLevel[iClient] < 6)
	{
		g_iGooType[iClient] = GOO_ADHESIVE;
	}
	else if(g_iClientLevel[iClient] < 11)
	{
		if(g_iGooType[iClient] > GOO_FLAMING)
			g_iGooType[iClient] = GOO_ADHESIVE;
	}
	else if(g_iClientLevel[iClient] < 16)
	{
		if(g_iGooType[iClient] > GOO_MELTING)
			g_iGooType[iClient] = GOO_ADHESIVE;
	}
	else if(g_iClientLevel[iClient] < 21)
	{
		if(g_iGooType[iClient] > GOO_DEMI)
			g_iGooType[iClient] = GOO_ADHESIVE;
	}
	else if(g_iClientLevel[iClient] < 26)
	{
		if(g_iGooType[iClient] > GOO_REPULSION)
			g_iGooType[iClient] = GOO_ADHESIVE;
	}
	else
	{
		if(g_iGooType[iClient] > GOO_VIRAL)
			g_iGooType[iClient] = GOO_ADHESIVE;
	}
	
	switch(g_iGooType[iClient])
	{
		case GOO_ADHESIVE: 	PrintHintText(iClient, "Goo Type: Adhesive Goo");
		case GOO_FLAMING: 	PrintHintText(iClient, "Goo Type: Flaming Goo");
		case GOO_MELTING: 	PrintHintText(iClient, "Goo Type: Melting Goo");
		case GOO_DEMI: 		PrintHintText(iClient, "Goo Type: Demi Goo");
		case GOO_REPULSION:	PrintHintText(iClient, "Goo Type: Repulsion Goo");
		case GOO_VIRAL: 	PrintHintText(iClient, "Goo Type: Viral Goo");
	}
}
*/
DealSpecialSpitterGooCollision(iAttacker, iVictim, iDamageTaken)
{
	/*
	if (g_hTimer_AdhesiveGooReset[iVictim] != INVALID_HANDLE)
	{
		KillTimer(g_hTimer_AdhesiveGooReset[iVictim]);
		g_hTimer_AdhesiveGooReset[iVictim] = INVALID_HANDLE;
	}
	*/
	if(g_bAdhesiveGooActive[iVictim] == false)
	{
		//SetEntDataFloat(iVictim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.5, true);
		decl RandomAdhesiveGooChance;
		RandomAdhesiveGooChance = GetRandomInt(1, 5);
		switch (RandomAdhesiveGooChance)
		{
			case 1:
			{
				decl RandomAdhesiveGooAffect;
				RandomAdhesiveGooAffect = GetRandomInt(1, 3);
				switch (RandomAdhesiveGooAffect)
				{
					case 1:
					{
						//SetEntDataFloat(iVictim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.5, true);
						g_fClientSpeedPenalty[iVictim] += (g_iPuppetLevel[iAttacker] * 0.03);
						g_fAdhesiveAffectAmount[iVictim] = (g_iPuppetLevel[iAttacker] * 0.03);
						//PrintToChatAll("Adhesive goo affect %d", g_fAdhesiveAffectAmount[iVictim]);
					}
					case 2:
					{
						g_fClientSpeedPenalty[iVictim] += (g_iPuppetLevel[iAttacker] * 0.06);
						g_fAdhesiveAffectAmount[iVictim] = (g_iPuppetLevel[iAttacker] * 0.06);
						//PrintToChatAll("Adhesive goo affect %d", g_fAdhesiveAffectAmount[iVictim]);
					}
					case 3:
					{
						g_fClientSpeedPenalty[iVictim] += (g_iPuppetLevel[iAttacker] * 0.09);
						g_fAdhesiveAffectAmount[iVictim] = (g_iPuppetLevel[iAttacker] * 0.09);
						//PrintToChatAll("Adhesive goo affect %d", g_fAdhesiveAffectAmount[iVictim]);
					}
				}
				g_bAdhesiveGooActive[iVictim] = true;
				fnc_SetClientSpeed(iVictim);
				//g_hTimer_AdhesiveGooReset[iVictim] = CreateTimer(5.0, TimerResetSpeedFromGoo, iVictim, TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(5.0, TimerResetSpeedFromGoo, iVictim, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	

	
	switch(g_iGooType[iAttacker])
	{
		/*
		case GOO_ADHESIVE:
		{
			if (g_hTimer_AdhesiveGooReset[iVictim] != INVALID_HANDLE)
			{
				KillTimer(g_hTimer_AdhesiveGooReset[iVictim]);
				g_hTimer_AdhesiveGooReset[iVictim] = INVALID_HANDLE;
			}
			else
			{
				SetEntDataFloat(iVictim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.5, true);
			}
			
			g_hTimer_AdhesiveGooReset[iVictim] = CreateTimer(3.0, TimerResetSpeedFromGoo, iVictim, TIMER_FLAG_NO_MAPCHANGE);
		}
		*/
		case GOO_MELTING:
		{
			if(GetEntProp(iVictim, Prop_Send, "m_isIncapacitated") == 0)
			{
				new iHealth = GetEntProp(iVictim, Prop_Data, "m_iHealth");
				new Float:fTempHealth = GetEntDataFloat(iVictim, g_iOffset_HealthBuffer);
				
				if(fTempHealth < 1.0)
					fTempHealth = 1.0;
				
				if(iHealth > iDamageTaken + 2)
				{
					SetEntProp(iVictim , Prop_Data,"m_iHealth", iHealth - 2);
					SetEntDataFloat(iVictim, g_iOffset_HealthBuffer, fTempHealth + iDamageTaken + 2.0, true);
				}
				else if(fTempHealth > iDamageTaken + 2.0)
				{
					SetEntProp(iVictim , Prop_Data,"m_iHealth", 1);
					SetEntDataFloat(iVictim, g_iOffset_HealthBuffer, fTempHealth - 2.0, true);
				}
			}
		}
		case GOO_DEMI:
		{
			if (g_hTimer_DemiGooReset[iVictim] != INVALID_HANDLE)
			{
				KillTimer(g_hTimer_DemiGooReset[iVictim]);
				g_hTimer_DemiGooReset[iVictim] = INVALID_HANDLE;
			}
			else
			{
				if(IsFakeClient(iVictim) == false)
					PrintHintText(iVictim, "Your gravity has been tripled by a Spitter's Demi Goo");
			
				g_bHasDemiGravity[iVictim] = true;
				SetEntityGravity(iVictim, 3.0);
				
				g_iPID_DemiGravityEffect[iVictim] = WriteParticle(iVictim, "demi_gravity_effect", 0.0);
			}
			
			g_hTimer_DemiGooReset[iVictim] = CreateTimer(15.0, TimerResetGravityFromGoo, iVictim, TIMER_FLAG_NO_MAPCHANGE);
		}
		case GOO_REPULSION:
		{
			if(g_bCanBePushedByRepulsion[iVictim] == true)
			{
				g_bCanBePushedByRepulsion[iVictim] = false;
				new Float:xyzNewVelocity[3];
				decl RandomRepulsionDirection;
				RandomRepulsionDirection = GetRandomInt(1, 9);
				switch (RandomRepulsionDirection)
				{
					case 1:
					{
						xyzNewVelocity[0] = 0.0;
						xyzNewVelocity[1] = 0.0;
						xyzNewVelocity[2] = 650.0;
					}
					case 2:
					{
						//xyzNewVelocity = {220.0, 220.0, 220.0};
						xyzNewVelocity[0] = 140.0;
						xyzNewVelocity[1] = 140.0;
						xyzNewVelocity[2] = 550.0;
					}
					case 3:
					{
						//xyzNewVelocity = {440.0, 0.0, 220.0};
						xyzNewVelocity[0] = 280.0;
						xyzNewVelocity[1] = 0.0;
						xyzNewVelocity[2] = 550.0;
					}
					case 4:
					{
						//xyzNewVelocity = {220.0, -220.0, 220.0};
						xyzNewVelocity[0] = 140.0;
						xyzNewVelocity[1] = -140.0;
						xyzNewVelocity[2] = 550.0;
					}
					case 5:
					{
						//xyzNewVelocity = {0.0, -440.0, 220.0};
						xyzNewVelocity[0] = 0.0;
						xyzNewVelocity[1] = -280.0;
						xyzNewVelocity[2] = 550.0;
					}
					case 6:
					{
						//xyzNewVelocity = {-220.0, -220.0, 220.0};
						xyzNewVelocity[0] = -140.0;
						xyzNewVelocity[1] = -140.0;
						xyzNewVelocity[2] = 550.0;
					}
					case 7:
					{
						//xyzNewVelocity = {-440.0, 0.0, 220.0};
						xyzNewVelocity[0] = -280.0;
						xyzNewVelocity[1] = 0.0;
						xyzNewVelocity[2] = 550.0;
					}
					case 8:
					{
						//xyzNewVelocity = {-220.0, 220.0, 220.0};
						xyzNewVelocity[0] = -140.0;
						xyzNewVelocity[1] = 140.0;
						xyzNewVelocity[2] = 550.0;
					}
					case 9:
					{
						//xyzNewVelocity = {0.0, 440.0, 220.0};
						xyzNewVelocity[0] = 0.0;
						xyzNewVelocity[1] = 280.0;
						xyzNewVelocity[2] = 550.0;
					}
				}
				//PrintToChatAll("X = %f, Y = %f, Z = %f", xyzNewVelocity[0], xyzNewVelocity[1], xyzNewVelocity[2]);
				TeleportEntity(iVictim, NULL_VECTOR, NULL_VECTOR, xyzNewVelocity);
				CreateTimer(8.0, TimerResetRepulsion, iVictim, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		case GOO_VIRAL:
		{
			VirallyInfectVictim(iVictim, iAttacker);
		}
	}
}

SpawnCommonInfectedMob(Float:xyzLocation[3], iAmount)
{
	xyzLocation[2] += 5;

	decl i;
	for(i = 0; i < iAmount; i++)
	{
		new zombie = CreateEntityByName("infected");
		
		new iRandomNumber = GetRandomInt(0,6);
		
		switch(iRandomNumber)
		{
			case 0: SetEntityModel(zombie, "models/infected/common_female_tanktop_jeans.mdl");
			case 1: SetEntityModel(zombie, "models/infected/common_female_tshirt_skirt.mdl");
			case 2: SetEntityModel(zombie, "models/infected/common_male_dressshirt_jeans.mdl");
			case 3: SetEntityModel(zombie, "models/infected/common_male_polo_jeans.mdl");
			case 4: SetEntityModel(zombie, "models/infected/common_male_tanktop_jeans.mdl");
			case 5: SetEntityModel(zombie, "models/infected/common_male_tanktop_overalls.mdl");
			case 6: SetEntityModel(zombie, "models/infected/common_male_tshirt_cargos.mdl");
		}
		
		new ticktime = RoundToNearest( GetGameTime() / GetTickInterval() ) + 5;
		SetEntProp(zombie, Prop_Data, "m_nNextThinkTick", ticktime);
		
		CreateTimer(0.1, TimerSetMobRush, zombie);
		
		DispatchSpawn(zombie);
		ActivateEntity(zombie);
		
		TeleportEntity(zombie, xyzLocation, NULL_VECTOR, NULL_VECTOR);
	}
}

VirallyInfectVictim(iVictim, iAttacker)
{
	if(g_bIsImmuneToVirus[iVictim] == false && g_iViralInfector[iVictim] == 0)
	{
		g_bIsImmuneToVirus[iVictim] = true;
		g_iViralInfector[iVictim] = iAttacker;
		g_iViralRuntimesCounter[iVictim] = 20;
	
		if (g_hTimer_ViralInfectionTick[iVictim] != INVALID_HANDLE)
			g_hTimer_ViralInfectionTick[iVictim] = INVALID_HANDLE;
						
		if(IsFakeClient(iVictim) == false)
			PrintHintText(iVictim, "You have been infected by a mutated virus crafted by a Spitter");
		
		SetEntityRenderMode(iVictim, RenderMode:0);
		SetEntityRenderColor(iVictim, 200, 255, 200, 255);
		
		g_hTimer_ViralInfectionTick[iVictim] = CreateTimer(0.5, TimerInfectedVictimTick, iVictim, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
}