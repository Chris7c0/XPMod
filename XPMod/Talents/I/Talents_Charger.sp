OnGameFrame_Charger(iClient)
{
	if (g_iSpikedLevel[iClient] > 0)
	{
		if(g_bIsSpikedCharged[iClient] == false)
		{
			new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
			if(buttons & IN_DUCK)
			{
				if(g_bCanChargerSpikedCharge[iClient] == true)
				{
					g_iSpikedChargeCounter[iClient]++;
					if(g_iSpikedChargeCounter[iClient] == 20)
					{
						PrintHintText(iClient, "Charging Uppercut");
						//play sound and particle for charging here
					}
					if(g_iSpikedChargeCounter[iClient]>90)
					{
						g_iSpikedChargeCounter[iClient] = 0;
						g_bIsSpikedCharged[iClient] = true;
						PrintHintText(iClient, "Uppercut charged!");
						//play sound and particle for charged here
					}
				}
				else if(g_iSpikedChargeCounter[iClient] == 0)
				{
					g_iSpikedChargeCounter[iClient] = -1;
					PrintHintText(iClient, "Wait 30 seconds to charge your Uppercut again");
				}
			}
			else
			{
				if(g_iSpikedChargeCounter[iClient] > 0)
				{
					PrintHintText(iClient, "Failed to charge Uppercut");
					g_iSpikedChargeCounter[iClient] = 0;
				}
			}
		}
	}
/*
	if (g_iHillbillyLevel[iClient] == 10)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		//decl Float:originalVector[3];
		//decl Float:eyeAngles[3];
		//decl Float:vectorDirection[3];
		decl Float:vectorVelocity[3];
		if (buttons & IN_MOVELEFT)
		{
			//RunCheatCommand(iClient, "+left", "+left");
			//GetClientEyePosition(iClient, originalVector);
			//GetClientEyeAngles(iClient, eyeAngles);
			//GetAngleVectors(eyeAngles, vectorDirection, NULL_VECTOR, NULL_VECTOR);
			//originalVector[1]--;
			GetEntDataVector(iClient, g_iOffset_VecVelocity, vectorVelocity);
			vectorVelocity[0] -= 250.0;
			TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vectorVelocity);
		}
		if (buttons & IN_MOVERIGHT)
		{
			//RunCheatCommand(iClient, "+right", "+right");
			//GetClientEyePosition(iClient, originalVector);
			//originalVector[1]++;
			GetEntDataVector(iClient, g_iOffset_VecVelocity, vectorVelocity);
			vectorVelocity[0] += 250.0;
			TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vectorVelocity);
		}
	}*/
	/*if (g_iHillbillyLevel[iClient] == 10)
	{
		if (g_bIsChargerCharging[iClient] == true)
		{
			new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
			decl Float:originalVector[3];
			if (buttons & IN_MOVELEFT)
			{
				//RunCheatCommand(iClient, "+left", "+left");
				GetClientEyePosition(iClient, originalVector);
				originalVector[0]--;
				TeleportEntity(iClient, originalVector, NULL_VECTOR, NULL_VECTOR);
			}
			if (buttons & IN_MOVERIGHT)
			{
				//RunCheatCommand(iClient, "+right", "+right");
				GetClientEyePosition(iClient, originalVector);
				originalVector[0]++;
				TeleportEntity(iClient, originalVector, NULL_VECTOR, NULL_VECTOR);
			}
		}
	}*/
	/*if (g_iHillbillyLevel[iClient] == 10)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if ((g_bIsChargerCharging[iClient] == true) && (buttons & IN_MOVELEFT))
		{
			RunCheatCommand(iClient, "+left", "+left");
		}
		if ((g_bIsChargerCharging[iClient] == true) && (buttons & IN_MOVERIGHT))
		{
			RunCheatCommand(iClient, "+right","+right");
		}
	}*/
}

EventsHurt_AttackerCharger(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(attacker))
		return;

	if (g_iClientTeam[victim] != TEAM_SURVIVORS)
		return;

	if(g_iGroundLevel[attacker] > 0)
	{
		decl String:weapon[20];
		GetEventString(hEvent,"weapon", weapon,20);
		new hp = GetEntProp(victim,Prop_Data,"m_iHealth");

		if(StrEqual(weapon,"charger_claw") == true)
		{
			decl dmg;
			if(g_iGroundLevel[attacker] < 4)
				dmg = 1;
			else if(g_iGroundLevel[attacker] < 7)
				dmg = 2;
			else if(g_iGroundLevel[attacker] < 10)
				dmg = 3;
			else
				dmg = 4;
			if(hp > dmg)
				DealDamage(victim, attacker, dmg);
		}

		if (g_bIsSpikedCharged[attacker] == true && 
			g_iChargerVictim[attacker] <= 0 && 
			g_bIsChargerCharging[attacker] == false &&
			StrEqual(weapon,"charger_claw") == true && 
			GetEntProp(victim, Prop_Send, "m_isIncapacitated") == 0)
		{
			decl Float: addAmount[3];
			new Float:power = 577.0;

			addAmount[0] = 0.0;
			addAmount[1] = 0.0;
			addAmount[2] = power;
			
			SDKCall(g_hSDK_Fling, victim, addAmount, 96, attacker, 3.0);
			
			g_bIsSpikedCharged[attacker] = false;
			g_bCanChargerSpikedCharge[attacker] = false;
			CreateTimer(30.0, TimerResetSpikedCharge, attacker,  TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

EventsHurt_VictimCharger(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(victim))
		return;
	
	if (g_iClientTeam[attacker] != TEAM_SURVIVORS)
		return;

	new dmgHealth  = GetEventInt(hEvent,"dmg_health");

	if(g_iSpikedLevel[victim] > 0)
	{
		decl String:weapon[20];
		GetEventString(hEvent, "weapon", weapon, 20);
		
		if(StrEqual(weapon, "melee") == true)
		{
			decl iDamage;
			iDamage = g_iSpikedLevel[victim];
			DealDamage(attacker, victim, iDamage);
		}
		
		if(g_iHillbillyLevel[victim] > 0)
		{
			if(g_bChargerCarrying[victim] == true)
			{
				new iCurrentHP = GetEntProp(victim, Prop_Data, "m_iHealth");
				SetEntProp(victim, Prop_Data, "m_iHealth", iCurrentHP + dmgHealth + RoundToNearest(dmgHealth * g_iHillbillyLevel[victim] * 0.05));
				
				//Add particle effect here later since Charger glow and color cannot be changed
				
				if(g_bIsChargerHealing[victim] == false)
				{
					//g_bIsChargerHealing[victim] = true;
					//SetEntityRenderMode(victim, RenderMode:0);
					//SetEntityRenderColor(victim, 1, 1, 255, 254);
					CreateTimer(0.1, TimerResetChargerHealingColor, victim,  TIMER_FLAG_NO_MAPCHANGE);
					SetEntProp(victim, Prop_Send, "m_iGlowType", 2);
					SetEntProp(victim, Prop_Send, "m_nGlowRange", 0);
					SetEntProp(victim, Prop_Send, "m_glowColorOverride", 52000);
				}
			}
		}
	}
}

// EventsDeath_AttackerCharger(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

// EventsDeath_VictimCharger(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }