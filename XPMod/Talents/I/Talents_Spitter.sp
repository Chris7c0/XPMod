TalentsLoad_Spitter(iClient)
{
	if(g_iPuppetLevel[iClient] > 0)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Spitter Talents \x05have been loaded.");
		
		new Float:xyzLocation[3];
		GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", xyzLocation);
		
		xyzLocation[2] += 10.0;
		
		WriteParticle(iClient, "spitter_conjure", 180.0, 7.0, xyzLocation);
	
		new Handle:hDataPackage = CreateDataPack();
		WritePackCell(hDataPackage, iClient);
		WritePackFloat(hDataPackage, xyzLocation[0]);
		WritePackFloat(hDataPackage, xyzLocation[1]);
		WritePackFloat(hDataPackage, xyzLocation[2]);
		
		CreateTimer(2.3, TimerConjureCommonInfected, hDataPackage);

		// Draw the select goo menu
		if (g_iPuppetLevel[iClient] > 5 || 
			g_iMaterialLevel[iClient] > 0 ||
			g_iHallucinogenicLevel[iClient] > 0)
			GooTypeMenuDraw(iClient);
	}
	
	g_bBlockGooSwitching[iClient] = false;
	g_bJustSpawnedWitch[iClient] = false;
	g_iGooType[iClient] = GOO_ADHESIVE;
	g_iBagOfSpitsSelectedSpit[iClient] = BAG_OF_SPITS_NONE;
	g_bIsStealthSpitter[iClient] = false;
	g_iStealthSpitterChargePower[iClient] =  0;
	g_iStealthSpitterChargeMana[iClient] =  0;
	g_xyzWitchConjureLocation[iClient][0] = 0.0;
	g_xyzWitchConjureLocation[iClient][1] = 0.0;
	g_xyzWitchConjureLocation[iClient][2] = 0.0;
}

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

					SetClientSpeed(iClient);
					
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
				
				g_bIsStealthSpitter[iClient] = false;
				SetClientSpeed(iClient);
			}
		}
	}
}

EventsHurt_AttackerSpitter(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(attacker))
		return;

	if (g_iClientTeam[victim] != TEAM_SURVIVORS)
		return;

	new dmgHealth  = GetEventInt(hEvent,"dmg_health");
	
	if(g_iPuppetLevel[attacker] > 0)
	{
		decl String:weapon[20];
		GetEventString(hEvent,"weapon", weapon, 20);
		if(StrEqual(weapon,"insect_swarm") == true)
		{
			DealSpecialSpitterGooCollision(attacker, victim, dmgHealth);
			
			if(g_iMaterialLevel[attacker] > 0 && IsIncap(victim) == true)
			{
				if (g_hTimer_ResetGlow[victim] == null)
				{
					SetEntProp(victim, Prop_Send, "m_iGlowType", 3);
					SetEntProp(victim, Prop_Send, "m_nGlowRange", 0);
					SetEntProp(victim, Prop_Send, "m_glowColorOverride", 1);
					SetEntityRenderMode(victim, RenderMode:3);
					SetEntityRenderColor(victim, 255, 255, 255, 255 - RoundToNearest(255.0 * 0.1 * g_iMaterialLevel[attacker]));
				}
				
				delete g_hTimer_ResetGlow[victim];
				g_hTimer_ResetGlow[victim] = CreateTimer(3.0, Timer_ResetGlow, victim);
			}
		}
		else if(g_bIsHallucinating[victim] == false && StrEqual(weapon,"spitter_claw") == true)
		{
			if(IsFakeClient(victim) == false)
				PrintHintText(victim, "A Spitter's hallucinogenic toxin seeps through your viens"); 
			
			g_bIsHallucinating[victim] = true;
			g_iHallucinogenRuntimesCounter[victim] = 0;
			WriteParticle(victim, "hallucinogenic_effect", 0.0, 30.0);
			
			delete g_hTimer_HallucinatePlayer[victim];
			g_hTimer_HallucinatePlayer[victim] = CreateTimer(2.5, TimerHallucinogen, victim, TIMER_REPEAT);
		}
	}
}

// EventsDeath_AttackerSpitter(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

// EventsDeath_VictimSpitter(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

DealSpecialSpitterGooCollision(iAttacker, iVictim, iDamageTaken)
{
	if(g_bAdhesiveGooActive[iVictim] == false)
	{
		decl RandomAdhesiveGooChance;
		RandomAdhesiveGooChance = GetRandomInt(1, 4);
		switch (RandomAdhesiveGooChance)
		{
			// 20% chance of causing adhession on hit
			case 1:
			{
				decl RandomAdhesiveGooAffect;
				RandomAdhesiveGooAffect = GetRandomInt(1, 3);
				
				switch (RandomAdhesiveGooAffect)
				{
					case 1:	g_fAdhesiveAffectAmount[iVictim] = (g_iPuppetLevel[iAttacker] * 0.02);
					case 2:	g_fAdhesiveAffectAmount[iVictim] = (g_iPuppetLevel[iAttacker] * 0.04);
					case 3:	g_fAdhesiveAffectAmount[iVictim] = (g_iPuppetLevel[iAttacker] * 0.06);
				}

				g_bAdhesiveGooActive[iVictim] = true;
				SetClientSpeed(iVictim);

				delete g_hTimer_AdhesiveGooReset[iVictim];
				g_hTimer_AdhesiveGooReset[iVictim] = CreateTimer(5.0, TimerResetSpeedFromGoo, iVictim);
			}
		}
	}
	
	switch(g_iGooType[iAttacker])
	{
		case GOO_MELTING:
		{
			if (IsIncap(iVictim) == false)
			{
				new iHealth = GetPlayerHealth(iVictim);
				new Float:fTempHealth = GetEntDataFloat(iVictim, g_iOffset_HealthBuffer);
				
				if(fTempHealth < 1.0)
					fTempHealth = 1.0;
				
				if(iHealth > iDamageTaken + 2)
				{
					SetPlayerHealth(iVictim , iHealth - 2);
					SetEntDataFloat(iVictim, g_iOffset_HealthBuffer, fTempHealth + iDamageTaken + 2.0, true);
				}
				else if(fTempHealth > iDamageTaken + 2.0)
				{
					SetPlayerHealth(iVictim , 1);
					SetEntDataFloat(iVictim, g_iOffset_HealthBuffer, fTempHealth - 2.0, true);
				}
			}
		}
		case GOO_DEMI:
		{
			if (g_hTimer_DemiGooReset[iVictim] == null)
			{
				if(IsFakeClient(iVictim) == false)
					PrintHintText(iVictim, "Your gravity has been tripled by a Spitter's Demi Goo");
			
				g_bHasDemiGravity[iVictim] = true;
				SetEntityGravity(iVictim, 3.0);
				
				g_iPID_DemiGravityEffect[iVictim] = WriteParticle(iVictim, "demi_gravity_effect", 0.0);
			}
			
			delete g_hTimer_DemiGooReset[iVictim];
			g_hTimer_DemiGooReset[iVictim] = CreateTimer(15.0, TimerResetGravityFromGoo, iVictim);
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


void VirallyInfectVictim(iVictim, iAttacker)
{
	if(g_bIsImmuneToVirus[iVictim] == false && g_iViralInfector[iVictim] == 0)
	{
		g_bIsImmuneToVirus[iVictim] = true;
		g_iViralInfector[iVictim] = iAttacker;
		g_iViralRuntimesCounter[iVictim] = 20;
						
		if(IsFakeClient(iVictim) == false)
			PrintHintText(iVictim, "You have been infected by a mutated virus crafted by a Spitter");
		
		SetEntityRenderMode(iVictim, RenderMode:0);
		SetEntityRenderColor(iVictim, 200, 255, 200, 255);
		
		delete g_hTimer_ViralInfectionTick[iVictim];
		g_hTimer_ViralInfectionTick[iVictim] = CreateTimer(0.5, TimerInfectedVictimTick, iVictim, TIMER_REPEAT);
	}
}

void ConjureFromBagOfSpits(iClient, Float:xyzLocation[3])
{
	if (g_bTalentsConfirmed[iClient] == false || 
		g_iMaterialLevel[iClient] == 0 || 
		g_iBagOfSpitsSelectedSpit[iClient] == BAG_OF_SPITS_NONE)
		return;
	
	switch (g_iBagOfSpitsSelectedSpit[iClient])
	{
		case BAG_OF_SPITS_MINI_ARMY: 		SpawnCIAroundLocation(xyzLocation, 12, UNCOMMON_CI_NONE, CI_REALLY_SMALL, ENHANCED_CI_TYPE_RANDOM, 0.1);
		case BAG_OF_SPITS_MUSCLE_CREW: 		SpawnCIAroundLocation(xyzLocation, 6, UNCOMMON_CI_NONE, CI_REALLY_BIG, ENHANCED_CI_TYPE_NONE, 0.1);
		case BAG_OF_SPITS_ENHANCED_JIMMY: 	SpawnCIAroundLocation(xyzLocation, 1, UNCOMMON_CI_JIMMY, CI_REALLY_BIG_JIMMY, ENHANCED_CI_TYPE_RANDOM, 0.1);
		case BAG_OF_SPITS_NECROFEASTER: 	SpawnCIAroundLocation(xyzLocation, 10, UNCOMMON_CI_CEDA, CI_BIG, ENHANCED_CI_TYPE_NECRO, 0.1);	// Add life stealing also, when code supports it
		case BAG_OF_SPITS_KILLER_KLOWNS: 	SpawnCIAroundLocation(xyzLocation, 5, UNCOMMON_CI_CLOWN, CI_REALLY_BIG, ENHANCED_CI_TYPE_VAMPIRIC, 0.1);
	}
	
	// Use a bind 1 charge
	g_iClientBindUses_1[iClient]++;
	g_iBagOfSpitsSelectedSpit[iClient] = BAG_OF_SPITS_NONE;
}