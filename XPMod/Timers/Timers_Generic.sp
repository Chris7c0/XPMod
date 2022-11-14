//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////           TIMERS           ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Action:Timer_ResetGlow(Handle:timer, any:iClient)
{
	SetClientRenderAndGlowColor(iClient);
	
	g_hTimer_ResetGlow[iClient] = null;
	
	return Plugin_Stop;
}

Action:TimerGiveHudBack(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient) == true && IsFakeClient(iClient) == false)
		SetEntProp(iClient, Prop_Send, "m_iHideHUD", 0);
	
	return Plugin_Stop;
}

/*Action:TimerResetCommonLimit(Handle:timer, any:iClient)
{
	SetConVarInt(FindConVar("z_common_limit"), 30);
	
	return Plugin_Stop;
}*/

Action:TimerResetZombieDamage(Handle:timer, any:iClient)
{
	SetConVarInt(FindConVar("z_common_limit"), 30);
	g_bCommonInfectedDoMoreDamage = false;
	
	return Plugin_Stop;
}

Action:TimerUnfreezeNotification(Handle:timer, any:data)
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

Action:TimerChangeSpectator(Handle:timer, any:iClient)
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

Action:TimerResetPlayerChangeTeamCoolDown(Handle:timer, any:iClient)
{
	g_bPlayerInTeamChangeCoolDown[iClient] = false;

	return Plugin_Stop;
}

Action:TimerCheckTeam(Handle:timer, any:iClient)
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

Action:FreezeColor(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient) == false)
		return Plugin_Stop;
		
	decl Float:xyzVector[3];
	GetClientEyePosition(iClient, xyzVector);
	EmitAmbientSound(SOUND_FREEZE, xyzVector, iClient, SNDLEVEL_NORMAL);
	
	SetEntityRenderMode(iClient, RenderMode:3);
	SetEntityRenderColor(iClient, 0, 180, 255, 160);
	
	return Plugin_Stop;
}

Action:Timer2SecondGlobalRepeating(Handle:timer, any:data)
{
	

	for(new iClient = 1;iClient<= MaxClients; iClient++)
	{
		if (RunClientChecks(iClient)==false || 
			g_bTalentsConfirmed[iClient] == false ||
			IsPlayerAlive(iClient) == false)
			continue;
		
		if (GetClientTeam(iClient)==TEAM_SURVIVORS)
		{
			if (g_iChosenSurvivor[iClient] == ROCHELLE)
			{
				if (g_iSniperLevel[iClient]==5)
					SetEntData(iClient,g_iOffset_ShovePenalty,0);

				if (g_iGatherLevel[iClient] > 0 && g_bClientIDDToggle[iClient] == true)
					DetectionHud(iClient);
			}
			
			if (g_iChosenSurvivor[iClient] == COACH)
			{
				if (g_iHomerunLevel[iClient]==5)
					SetEntData(iClient,g_iOffset_ShovePenalty,0);

				if (g_iStrongLevel[iClient] > 0)
				{
					if(g_bIsJetpackOn[iClient]==true)
					{
						// Take away small amount of fuel for running jetpack on idle
						g_iClientJetpackFuel[iClient]--;

						PrintCoachJetpackFuelGauge(iClient);

						if(g_iClientJetpackFuel[iClient]<0)
						{
							CreateTimer(0.5, DeleteParticle, g_iPID_CoachJetpackStream[iClient], TIMER_FLAG_NO_MAPCHANGE);
							StopSound(iClient, SNDCHAN_AUTO, SOUND_JPHIGHREV);
							StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
							new Float:vec[3];
							GetClientAbsOrigin(iClient, vec);
							EmitSoundToAll(SOUND_JPDIE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
							g_bIsJetpackOn[iClient] = false;
							g_bIsFlyingWithJetpack[iClient] = false;
							SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
							g_iClientJetpackFuel[iClient] = 0;
							PrintCoachJetpackFuelGauge(iClient);
						}
					}
					else if (g_iClientJetpackFuel[iClient] < (g_iStrongLevel[iClient] * COACH_JETPACK_FUEL_PER_LEVEL))
					{
						// Jetpack fuel regeneration while jetpack is off
						g_iClientJetpackFuel[iClient] = g_iClientJetpackFuel[iClient] + COACH_JETPACK_FUEL_REGEN_PER_2_SEC_TICK > (g_iStrongLevel[iClient] * COACH_JETPACK_FUEL_PER_LEVEL) ? 
							(g_iStrongLevel[iClient] * COACH_JETPACK_FUEL_PER_LEVEL) :
							g_iClientJetpackFuel[iClient] + COACH_JETPACK_FUEL_REGEN_PER_2_SEC_TICK;
						
						PrintCoachJetpackFuelGauge(iClient);
					}
				}
			}
		}

		// TODO: replace this with a timer later
		HandleHunterVisibleBloodLustMeterGain(iClient);
	}

	return Plugin_Continue;
}

Action:TimerUnfreeze(Handle:timer, any:data)
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
				decl Float:vec[3];
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


Action:TimerDrugged(Handle:timer, any:iClient)
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