EventsDeath_GiveXP(Handle:hEvent, iAttacker, iVictim)
{
	// Give XP to Survivors for killing the Tank
	if (g_iClientTeam[iVictim] == TEAM_INFECTED &&
		g_bEndOfRound == false && 
		RunClientChecks(iVictim) &&
		GetEntProp(iVictim, Prop_Send, "m_zombieClass") == TANK)
	{		
		for(new i=1;i<=MaxClients;i++)
		{
			if (RunClientChecks(i) && 
				GetClientTeam(i) == TEAM_SURVIVORS && 
				IsFakeClient(i) == false)
			{
				g_iClientXP[i] += 250;
				CheckLevel(i);
				
				if(g_iXPDisplayMode[i] == 0)
					ShowXPSprite(i, g_iSprite_250XP_Team, iVictim, 5.0);
				else if(g_iXPDisplayMode[i] == 1)
					PrintToChat(i,"\x03[XPMod] Tank Killed. Everyone alive on your team You gain 250 XP");
			}
		}
	}

	// From this point on we are only concerned if the attacker is a human player
	if (RunClientChecks(iAttacker) == false || IsFakeClient(iAttacker) == true)
		return;

	new headshot = GetEventBool(hEvent, "headshot");

	// Give Survivors XP for Common Infected kills
	if (g_iClientTeam[iAttacker] == TEAM_SURVIVORS && 
		iVictim < 1)
	{
		new iCIVictim = GetEventInt(hEvent, "entityid");

		g_iStat_ClientCommonKilled[iAttacker]++;
		//If it was a headshot, give headshot XP and play sound
		if(headshot)
		{
			g_iStat_ClientCommonHeadshots[iAttacker]++;
			g_iClientXP[iAttacker] += 5;
			CheckLevel(iAttacker);
			
			if(g_iXPDisplayMode[iAttacker] == 0)
				ShowXPSprite(iAttacker, g_iSprite_5XP_HS, iCIVictim, 2.0);
			// else if(g_iXPDisplayMode[iAttacker] == 1)
			// 	PrintCenterText(iAttacker, "HEADSHOT! +5 XP.");
			
			if(g_bCanPlayHeadshotSound[iAttacker] == true)
				PlayHeadshotSound(iAttacker);
		}
		//If it wasnt a headshot, its a regular common kill
		else
		{
			g_iClientXP[iAttacker]++;
			CheckLevel(iAttacker);
			
			if(g_iXPDisplayMode[iAttacker] == 0)
				ShowXPSprite(iAttacker, g_iSprite_1XP, iCIVictim, 1.0);
		}
	}

	// Give Survivors XP for killing Special Infected
	if (g_iClientTeam[iAttacker] == TEAM_SURVIVORS && 
		g_iClientTeam[iVictim] == TEAM_INFECTED)
	{
		// Handle headshots giving more
		if(headshot)
		{
			g_iStat_ClientCommonHeadshots[iAttacker]++;
			g_iClientXP[iAttacker] += 75;
			CheckLevel(iAttacker);
			
			if(g_iXPDisplayMode[iAttacker] == 0)
				ShowXPSprite(iAttacker, g_iSprite_75XP_HS, iVictim);
			else if(g_iXPDisplayMode[iAttacker] == 1)
				PrintToChat(iAttacker, "\x03[XPMod] HEADSHOT! Special Infected Killed. You gain 75 XP.");
		}
		// If its not a headshot and it wasnt a Tank, give SI Kill XP
		else if (GetEntProp(iVictim, Prop_Send, "m_zombieClass") != TANK)
		{
			g_iClientXP[iAttacker] += 50;
			CheckLevel(iAttacker);
			
			if(g_iXPDisplayMode[iAttacker] == 0)
				ShowXPSprite(iAttacker, g_iSprite_50XP, iVictim);
			else if(g_iXPDisplayMode[iAttacker] == 1)
				PrintToChat(iAttacker, "\x03[XPMod] Special Infected Killed. You gain 50 XP.");
		}
		
		g_iStat_ClientInfectedKilled[iAttacker]++;

		// Handle Bill's Team XP gain
		if(g_iInspirationalLevel[iAttacker] > 0)
		{
			for(int i=1; i <= MaxClients; i++)
			{
				if(	g_iClientTeam[i] == TEAM_SURVIVORS && 
					i != iAttacker && 
					RunClientChecks(i) && 
					IsPlayerAlive(i) && 
					IsFakeClient(i) == false)
				{
					g_iClientXP[i] += (g_iInspirationalLevel[iAttacker] * 10);
					CheckLevel(i);
					
					if(g_iXPDisplayMode[i] == 0)
					{
						switch(g_iInspirationalLevel[iAttacker])
						{
							case 1:	ShowXPSprite(i, g_iSprite_10XP_Bill, iAttacker);
							case 2:	ShowXPSprite(i, g_iSprite_20XP_Bill, iAttacker);
							case 3:	ShowXPSprite(i, g_iSprite_30XP_Bill, iAttacker);
							case 4:	ShowXPSprite(i, g_iSprite_40XP_Bill, iAttacker);
							case 5:	ShowXPSprite(i, g_iSprite_50XP_Bill, iAttacker);
						}
					}
					else if(g_iXPDisplayMode[i] == 1)
					{
						PrintToChat(i, "\x03[XPMod] \x05%N \x03 killed a special infected. You gain %d XP.", iAttacker, (g_iInspirationalLevel[iAttacker] * 10));
					}
						
				}
			}
		}

		if(g_bAnnouncerOn[iAttacker] == true)
			PlayKillSound(iAttacker);
	}

	//Give XP to Infected killing a Survivor
	if (g_iClientTeam[iAttacker] == TEAM_INFECTED && 
		g_iClientTeam[iVictim] == TEAM_SURVIVORS)		
	{	
		g_iStat_ClientSurvivorsKilled[iAttacker]++;
		
		g_iClientXP[iAttacker] += 500;
		CheckLevel(iAttacker);
		
		if(g_iXPDisplayMode[iAttacker] == 0)
			ShowXPSprite(iAttacker, g_iSprite_500XP_SI, iVictim, 6.0);		
	}
}