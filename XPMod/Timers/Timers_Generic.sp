//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////           TIMERS           ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Action Timer1SecondGlobalRepeating(Handle timer, any data)
{
	// Non Client specific Functions
	LoopThroughAllPlayersAndHandleAFKPlayers();

	// Client specific Functions
	for(int iClient = 1;iClient <= MaxClients; iClient++)
	{
		if (RunClientChecks(iClient)==false || 
			g_bTalentsConfirmed[iClient] == false ||
			IsPlayerAlive(iClient) == false)
			continue;

		// Handle DPS Meters
		Handle1SecondClientTimers_DPSMeter(iClient);
		
		if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
		{
			// switch(g_iChosenSurvivor[iClient])
			// {
			// 	case BILL:		Handle1SecondClientTimers_Bill(iClient);
			// 	case ROCHELLE:	Handle1SecondClientTimers_Rochelle(iClient);
			// 	case COACH:		Handle1SecondClientTimers_Coach(iClient);
			// 	case ELLIS:		Handle1SecondClientTimers_Ellis(iClient);
			// 	case NICK:		Handle1SecondClientTimers_Nick(iClient);
			// 	case LOUIS:		Handle1SecondClientTimers_Louis(iClient);
			// }
		}
		else if(g_iClientTeam[iClient] == TEAM_INFECTED)
		{
			switch(g_iInfectedCharacter[iClient])
			{
				// case SMOKER:	Handle1SecondClientTimers_Smoker(iClient);
				// case BOOMER:	Handle1SecondClientTimers_Boomer(iClient);
				case HUNTER:	Handle1SecondClientTimers_Hunter(iClient);
				// case SPITTER:	Handle1SecondClientTimers_Spitter(iClient);
				case JOCKEY:	Handle1SecondClientTimers_Jockey(iClient);
				// case CHARGER:	Handle1SecondClientTimers_Charger(iClient);
			}
		}
	}

	return Plugin_Continue;
}

Action Timer2SecondGlobalRepeating(Handle timer, any data)
{
	// Non Client specific Functions


	// Client specific Functions
	for(int iClient = 1;iClient <= MaxClients; iClient++)
	{
		if (RunClientChecks(iClient)==false || 
			g_bTalentsConfirmed[iClient] == false ||
			IsPlayerAlive(iClient) == false)
			continue;
		
		if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
		{
			switch(g_iChosenSurvivor[iClient])
			{
				// case BILL:		Handle2SecondClientTimers_Bill(iClient);
				case ROCHELLE:	Handle2SecondClientTimers_Rochelle(iClient);
				case COACH:		Handle2SecondClientTimers_Coach(iClient);
				// case ELLIS:		Handle2SecondClientTimers_Ellis(iClient);
				// case NICK:		Handle2SecondClientTimers_Nick(iClient);
				// case LOUIS:		Handle2SecondClientTimers_Louis(iClient);
			}
		}
		// else if(g_iClientTeam[iClient] == TEAM_INFECTED)
		// {
		// 	switch(g_iInfectedCharacter[iClient])
		// 	{
		// 		case SMOKER:	Handle2SecondClientTimers_Smoker(iClient);
		// 		case BOOMER:	Handle2SecondClientTimers_Boomer(iClient);
		// 		case HUNTER:	Handle2SecondClientTimers_Hunter(iClient);
		// 		case SPITTER:	Handle2SecondClientTimers_Spitter(iClient);
		// 		case JOCKEY:	Handle2SecondClientTimers_Jockey(iClient);
		// 		case CHARGER:	Handle2SecondClientTimers_Charger(iClient);
		// 	}
		// }
	}

	return Plugin_Continue;
}



Action Timer_ResetGlow(Handle timer, any iClient)
{
	SetClientRenderAndGlowColor(iClient);
	
	g_hTimer_ResetGlow[iClient] = null;
	
	return Plugin_Stop;
}

Action TimerGiveHudBack(Handle timer, any iClient)
{
	if(IsClientInGame(iClient) == true && IsFakeClient(iClient) == false)
		SetEntProp(iClient, Prop_Send, "m_iHideHUD", 0);
	
	return Plugin_Stop;
}

Action ResetBind1AttemptCooldown(Handle timer, int iClient)
{
	g_bBind1InCooldown[iClient] = false;
	return Plugin_Handled;
}

// Action ResetBind2AttemptCooldown(Handle timer, int iClient)
// {
// 	g_bBind2InCooldown[iClient] = false;
// 	return Plugin_Handled;
// }


/*Action TimerResetCommonLimit(Handle timer, any iClient)
{
	SetConVarInt(FindConVar("z_common_limit"), 30);
	
	return Plugin_Stop;
}*/

Action TimerResetZombieDamage(Handle timer, any iClient)
{
	SetConVarInt(FindConVar("z_common_limit"), 30);
	g_bCommonInfectedDoMoreDamage = false;
	
	return Plugin_Stop;
}

Action TimerUnfreezeNotification(Handle timer, any data)
{
	if(g_iUnfreezeNotifyRunTimes-- > 1)
	{
		PrintHintTextToAll("Survivors will be unfrozen in %i seconds", g_iUnfreezeNotifyRunTimes);
		//LogError("TimerUnfreezeNotification Continue, Handle %i", g_hTimer_FreezeCountdown);
		return Plugin_Continue;
	}

	//LogError("TimerUnfreezeNotification Setting g_hTimer_FreezeCountdown to null, Handle %i", g_hTimer_FreezeCountdown);
	g_hTimer_FreezeCountdown = null;
	//LogError("TimerUnfreezeNotification Plugin_Stop, Handle %i", g_hTimer_FreezeCountdown);
	
	return Plugin_Stop;
}

Action TimerChangeSpectator(Handle timer, any iClient)
{
	if(iClient > 0 && g_bClientSpectating[iClient] == true && IsClientInGame(iClient) && IsFakeClient(iClient) == false)
	{
		ChangeClientTeam(iClient, TEAM_SPECTATORS);
		g_iClientTeam[iClient] = 1;
		PrintToChat(iClient, "\n\x03[XPMod] \x04You're Spectator until you change teams in the XPM Menu.\n ");
		PrintHintText(iClient, "You're Spectator until you change teams in the XPM Menu.");
	}
	
	return Plugin_Stop;
}

Action TimerResetPlayerChangeTeamCoolDown(Handle timer, any iClient)
{
	g_bPlayerInTeamChangeCoolDown[iClient] = false;

	return Plugin_Stop;
}

Action TimerCheckTeam(Handle timer, any iClient)
{
	if (RunClientChecks(iClient) == false)
		return Plugin_Stop;
	
	if(g_bClientSpectating[iClient] == true && IsFakeClient(iClient) == false)
	{
		ChangeClientTeam(iClient, TEAM_SPECTATORS);
		g_iClientTeam[iClient] = 1;
	}
	
	// Get their team and store it for fast retrieval
	g_iClientTeam[iClient] = GetClientTeam(iClient);
	
	DeleteAllClientParticles(iClient);
	ResetAllVariables(iClient);
	
	if(g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		// We now do not know which infected they have, because they switched team
		g_iInfectedCharacter[iClient] = UNKNOWN_INFECTED;

		// For checking if the player is a ghost
		g_bCanBeGhost[iClient] = true;
		g_bIsGhost[iClient] = false;

		// Rochelle's Listening Abilities
		for(new i = 1; i <= MaxClients; i++)
		{
			if(g_iGatherLevel[i] == 5 && IsClientInGame(i) == true && GetClientTeam(i) == TEAM_SURVIVORS)
				SetListenOverride(i, iClient, Listen_Yes);	//Sets the iClient to hear all the infected's voice comms
		}
	}

	// Display the Spectator message
	if (g_iClientTeam[iClient] == TEAM_SPECTATORS)
	{
		PrintToChat(iClient, "\n\x03[XPMod] \x04You're Spectator until you change teams in the XPM Menu.\n ");
		PrintHintText(iClient, "You're Spectator until you change teams in the XPM Menu.");
	}
	
	return Plugin_Stop;
}

Action FreezeColor(Handle timer, any iClient)
{
	if(IsClientInGame(iClient) == false)
		return Plugin_Stop;
		
	float xyzVector[3];
	GetClientEyePosition(iClient, xyzVector);
	EmitAmbientSound(SOUND_FREEZE, xyzVector, iClient, SNDLEVEL_NORMAL);
	
	SetEntityRenderMode(iClient, RenderMode:3);
	SetEntityRenderColor(iClient, 0, 180, 255, 160);
	
	return Plugin_Stop;
}

Action TimerUnfreeze(Handle timer, any data)
{
	// PrintToServer("**************************** UNFREEZING GAME");
	g_bGameFrozen = false;
	
	SetConVarInt(FindConVar("sb_stop"), 0);	//Turn the bots back on
	
	decl i;
	for(i=1;i<=MaxClients;i++)
	{
		if(RunClientChecks(i) && IsPlayerAlive(i) == true)
		{
			if(g_iClientTeam[i] == TEAM_SURVIVORS)
			{
				//Play Ice Breaking Sound
				float vec[3];
				GetClientAbsOrigin(i, vec);
				EmitAmbientSound(SOUND_FREEZE, vec, i, SNDLEVEL_NORMAL);
			}
			
			SetClientRenderAndGlowColor(i);
			SetClientSpeed(i);

			SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);	//Player can take damage now
			SetEntProp(i, Prop_Send, "m_isGoingToDie", 0);		//Fix the black and white at the beginning of the round           (Working?>
			
			if(IsFakeClient(i)==false)
			{
				if(g_bClientLoggedIn[i] == true)
				{
					if(g_iClientTeam[i]==TEAM_SURVIVORS)
					{
						if(g_bTalentsConfirmed[i] == false)
						{
							AdvertiseConfirmXPModTalents(i);
						}
						//LoadTalents(i);
					}
				}
				else
					AdvertiseXPModToNewUser(i);
				//OpenMOTDPanel(i, " ", "make", MOTDPANEL_TYPE_INDEX);
				//OpenMOTDPanel(i, "How To Create And Login To Your Account", "http://xpmod.atspace.com/makeaccount.html", MOTDPANEL_TYPE_URL);
			}			
		}
	}
	
	PrintHintTextToAll("Survivors Are Unfrozen");
	
	return Plugin_Stop;
}


Action TimerDrugged(Handle timer, any iClient)
{
	if(IsClientInGame(iClient) == false || IsPlayerAlive(iClient) == false)
	{
		g_hTimer_DrugPlayer[iClient] = null;
		return Plugin_Stop;
	}
	
	if(g_iDruggedRuntimesCounter[iClient]++ < 10)
	{
		if(IsFakeClient(iClient)==false)
		{
			new red = GetRandomInt(0,255);
			new green = GetRandomInt(0,255);
			new blue = GetRandomInt(0,255);
			new alpha = GetRandomInt(190,230);
			ShowHudOverlayColor(iClient, red, green, blue, alpha, 700, FADE_IN);
		}
		
		DealDamage(iClient, iClient, 1);
		
		return Plugin_Continue;
	}
	
	//Do one long lasting final hud color overlay to fade it out
	if(IsFakeClient(iClient)==false)
	{
		new red = GetRandomInt(0,255);
		new green = GetRandomInt(0,255);
		new blue = GetRandomInt(0,255);
		new alpha = GetRandomInt(190,230);
		ShowHudOverlayColor(iClient, red, green, blue, alpha, 1600, FADE_OUT);
	}
	
	//Reset Client run speed
	//ResetSurvivorSpeed(iClient);
	
	g_hTimer_DrugPlayer[iClient] = null;
	return Plugin_Stop;
}