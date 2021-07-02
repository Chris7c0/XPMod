TalentsLoad_Jockey(iClient)
{
	//g_iJockeyVictim[iClient] = -1;
	if(g_iMutatedLevel[iClient] > 0)
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Jockey Talents \x05have been loaded.");
	
	if(g_iUnfairLevel[iClient] > 0)
	{
		if(g_bHasInfectedHealthBeenSet[iClient] == false)
		{
			g_bHasInfectedHealthBeenSet[iClient] = true;
			SetPlayerMaxHealth(iClient, (g_iUnfairLevel[iClient] * 35), true);
		}
		
		SetClientSpeed(iClient);
		g_bCanJockeyPee[iClient] = true;
	}

	g_bCanJockeyJump[iClient] = false;
}

OnGameFrame_Jockey(iClient)
{
	if((g_iUnfairLevel[iClient] > 0) && (g_bJockeyIsRiding[iClient] == true))
	{
		//PrintToChatAll("g_iUnfairLevel is higher than 0 and the jockey is riding");
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(buttons & IN_JUMP)
		{
			if (RunClientChecks(iClient) == true && RunClientChecks(g_iJockeysVictim[iClient]) == true)
			{
				//PrintToChatAll("g_bCanJockeyJump = %i, g_bCanJockeyCloak = %i", g_bCanJockeyJump[iClient], g_bCanJockeyCloak[iClient]);
				if(g_bCanJockeyJump[iClient] == true && g_bCanJockeyCloak[iClient] == false)
				{
					new Float:xyzJumpVelocity[3];
					xyzJumpVelocity[0] = 0.0;
					xyzJumpVelocity[1] = 0.0;
					xyzJumpVelocity[2] = (g_iUnfairLevel[iClient] * 50.0);
					//PrintToChatAll("X = %f, Y = %f, Z = %f", xyzJumpVelocity[0], xyzJumpVelocity[1], xyzJumpVelocity[2]);
					TeleportEntity(g_iJockeysVictim[iClient], NULL_VECTOR, NULL_VECTOR, xyzJumpVelocity);
					g_bCanJockeyJump[iClient] = false;
					CreateTimer(2.5, TimerJockeyJumpReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}

EventsHurt_AttackerJockey(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(attacker))
		return;

	if (g_iClientTeam[victim] != TEAM_SURVIVORS)
		return;
	
	if(g_iMutatedLevel[attacker] > 0)
	{
		if(g_iJockeyVictim[attacker] < 0) //If they are NOT riding a victim
		{
			decl String:weapon[20];
			GetEventString(hEvent,"weapon", weapon,20);
			if(StrEqual(weapon,"jockey_claw") == true)
			{
				decl dmg;
				if(g_iMutatedLevel[attacker] < 5)
					dmg = 1;
				else if(g_iMutatedLevel[attacker] < 9)
					dmg = 2;
				else
					dmg = 3;
					
				new hp = GetPlayerHealth(victim);
				if(hp > dmg)
					DealDamage(victim, attacker, dmg);
			}
		}
	}

	if(g_iErraticLevel[attacker] > 0)
	{
		if(g_iJockeyVictim[attacker] > 0)	//If they ARE riding a victim
		{
			decl String:weapon[20];
			GetEventString(hEvent,"weapon", weapon,20);
			if(StrEqual(weapon,"jockey_claw") == true)
			{
				decl dmg;
				if(g_iMutatedLevel[attacker] < 5)
					dmg = 1;
				else if(g_iMutatedLevel[attacker] < 9)
					dmg = 2;
				else
					dmg = 3;
				//hp = GetPlayerHealth(victim);
				//PrintToChat(attacker, "pre hp = %d riding",hp);
				new hp = GetPlayerHealth(victim);
				if(hp > dmg)
					DealDamage(victim, attacker, dmg);
				//hp = GetPlayerHealth(victim);
				//PrintToChat(attacker, "    post hp = %d riding",hp);
			}
		}
	}
}

// EventsDeath_AttackerJockey(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

// EventsDeath_VictimJockey(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }