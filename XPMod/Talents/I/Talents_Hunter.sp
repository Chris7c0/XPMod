OnGameFrame_Hunter(iClient)
{
	if(g_iKillmeleonLevel[iClient] > 0)		//Dynamic Cloaking for kill-meleon
	{						
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		//For pounce crouch charge
		/*
		if((buttons & IN_DUCK))
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{
				if(g_iHunterShreddingVictim[iClient]  > 0)
				{
					g_iHunterPounceDamageCharge[iClient] = 0;
				}
			}
			
			if(g_iHunterShreddingVictim[iClient] == -1)
				if((GetEntityFlags(iClient) & FL_ONGROUND))
					if(g_iHunterPounceDamageCharge[iClient] <= (g_iKillmeleonLevel[iClient] * 120))
						g_iHunterPounceDamageCharge[iClient]++;
			
			
			if(g_iHunterPounceDamageCharge[iClient] > 59)
				PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 60);
			else if(g_iHunterPounceDamageCharge[iClient] == 30)
				PrintHintText(iClient, "Pounce Attack Charge: 0");
		}
		else
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{	
				g_iHunterPounceDamageCharge[iClient] = 0;
				PrintHintText(iClient, "Pounce Attack Charge: 0");
			}
		}
		*/
		if((buttons & IN_DUCK))
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{
				if(g_iHunterShreddingVictim[iClient]  > 0)
				{
					g_iHunterPounceDamageCharge[iClient] = 0;
				}
			}
			
			if(g_iHunterShreddingVictim[iClient] == -1)
				if((GetEntityFlags(iClient) & FL_ONGROUND))
					if(g_iHunterPounceDamageCharge[iClient] <= (g_iKillmeleonLevel[iClient] * 42))
						g_iHunterPounceDamageCharge[iClient]++;
			
			
			/*
			if(g_iHunterPounceDamageCharge[iClient] == 21)
			{
				PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
			}
			*/
			/*
			new i = 21;
			//for(new i = 21; i == 420; i)
			while(i <= 420)
			{
				if(g_iHunterPounceDamageCharge[iClient] == i)
				{
					i += 21;
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				else if(g_iHunterPounceDamageCharge[iClient] == 0)
				{
					break;
				}
			}
			*/
			//else if(g_iHunterPounceDamageCharge[iClient] == 30)
				//PrintHintText(iClient, "Pounce Attack Charge: 0");
			
			switch(g_iHunterPounceDamageCharge[iClient])
			{
				case 21:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 42:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 63:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 84:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 105:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 126:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 147:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 168:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 189:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 210:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 231:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 252:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 273:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 294:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 315:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 336:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 357:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 378:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 399:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 420:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
			}
		}
		else
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{	
				g_iHunterPounceDamageCharge[iClient] = 0;
				PrintHintText(iClient, "Pounce Attack Charge: 0");
			}
		}
		//For camouflage
		if(g_bIsCloakedHunter[iClient] == true)
		{
			if( (buttons) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
			{
				if( (!(buttons & IN_DUCK)) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
				{
					//SetEntityRenderMode(iClient, RenderMode:3);	probably dont need this
					SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.010) )));
					g_bIsCloakedHunter[iClient] = false;
					g_iHunterCloakCounter[iClient] = 0;
				}
			}
		}
		else
		{
			if(g_iHunterCloakCounter[iClient] >= 0)
			{
				g_iHunterCloakCounter[iClient]++;
				if( (buttons) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )			//If iClient moves or pushes buttons, resset the counter
				{
					if( (!(buttons & IN_DUCK)) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
					{
						if(g_iHunterCloakCounter[iClient] > 20)
						{
							SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.010) )));
						}
						g_iHunterCloakCounter[iClient] = 0;
					}
				}
				if(g_iHunterCloakCounter[iClient] == 100)
				{
					g_iHunterCloakCounter[iClient] = -1; // -1 means iClient is cloaked
					PrintCenterText(iClient, "Camouflaged");
					SetEntityRenderMode(iClient, RenderMode:3);
					SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.090) )));
					g_bIsCloakedHunter[iClient] = true;
				}
				else if(g_iHunterCloakCounter[iClient] > 20)
				{
					if(g_iHunterCloakCounter[iClient] == 35)
						PrintCenterText(iClient, "Blending in with surroundings");
					SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - ((float(g_iKillmeleonLevel[iClient]) * (0.009 + (float(g_iHunterCloakCounter[iClient] - 20) * 0.001)))) )));
				}
			}
		}
		if(g_iHunterShreddingVictim[iClient] > 0)
		{
			
		}
	}
}

EventsHurt_AttackerHunter(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(attacker))
		return;

	if (g_iClientTeam[victim] != TEAM_SURVIVORS)
		return;

	decl String:weapon[20];
	GetEventString(hEvent,"weapon", weapon,20);

	if(StrEqual(weapon,"hunter_claw") == true)
	{
		if(g_bIsHunterReadyToPoison[attacker])
		{
			if(g_bIsHunterPoisoned[victim] == false)
			{
				g_bIsHunterPoisoned[victim] = true;
				g_iClientBindUses_2[attacker]++;

				SetClientSpeed(victim);

				new Handle:hunterpoisonpackage = CreateDataPack();
				WritePackCell(hunterpoisonpackage, victim);
				WritePackCell(hunterpoisonpackage, attacker);
				g_iHunterPoisonRuntimesCounter[victim] = g_iKillmeleonLevel[attacker];
				g_bHunterLethalPoisoned[victim] = true;

				delete g_hTimer_HunterPoison[victim];
				g_hTimer_HunterPoison[victim] = CreateTimer(1.0, TimerHunterPoison, hunterpoisonpackage, TIMER_REPEAT);
				//CreateTimer(20.0, TimerContinuousHunterPoison, hunterpoisonpackage, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				if(IsFakeClient(victim)==false)
					PrintHintText(victim, "\%N has injected venom into your flesh", attacker);
				PrintHintText(attacker, "You poisoned %N, You have enough venom for %d more injections.", victim, (3 - g_iClientBindUses_2[attacker]) );
				
				
				g_bIsHunterReadyToPoison[attacker] = false;
				CreateTimer(5.0, TimerResetCanHunterPoison, attacker, TIMER_FLAG_NO_MAPCHANGE);
			}
			else
				PrintHintText(attacker, "%N has already been poisoned, find another victim", victim);
		}
	}

	if(g_iBloodlustLevel[attacker] > 0)
	{
		new dmgtype = GetEventInt(hEvent, "type");
		//decl String:weapon[20];
		//GetEventString(hEvent,"weapon", weapon,20);
		if(dmgtype == 128 &&  StrEqual(weapon,"hunter_claw") == true)
		{
			//new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
			//new dmg = GetEventInt(hEvent,"dmg_health");
			decl dmg;
			if(g_iBloodlustLevel[attacker] < 5)
				dmg = 1;
			else if(g_iBloodlustLevel[attacker] < 9)
				dmg = 2;
			else
				dmg = 3;
			DealDamage(victim, attacker, dmg);
			//if((hp - dmg) > 1)
			//	SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
			new hp = GetEntProp(attacker,Prop_Data,"m_iHealth");
			new maxHP = GetEntProp(attacker,Prop_Data,"m_iHealth");
			if((hp + (g_iBloodlustLevel[attacker] * 3)) < (maxHP * 2))
				SetEntProp(attacker,Prop_Data,"m_iHealth", hp + (g_iBloodlustLevel[attacker] * 3));
			else
				SetEntProp(attacker,Prop_Data,"m_iHealth", (maxHP * 2));
		}
	}
}

EventsHurt_VictimHunter(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(victim))
		return;

	new hitGroup = GetEventInt(hEvent, "hitgroup");
	
	if(hitGroup == 0)	// If victim is hunter and has beeen hit with explosive ammo, reset the pounced variables
	{
		g_bHunterGrappled[victim] = false;
		g_iHunterShreddingVictim[attacker] = -1;
		SetClientSpeed(victim);
	}

	if(g_bIsCloakedHunter[victim] == true)
	{
		//SetEntityRenderMode(victim, RenderMode:3);	// Probably dont need this
		SetEntityRenderColor(victim, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[victim]) * 0.012) )));
		g_bIsCloakedHunter[victim] = false;
		g_iHunterCloakCounter[victim] = 0;
	}
}

// EventsDeath_AttackerHunter(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

// EventsDeath_VictimHunter(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }