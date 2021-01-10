//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////           TIMERS           ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public Action:Timer_ResetGlow(Handle:timer, any:iClient)
{
	fnc_SetRendering(iClient);
	
	g_hTimer_ResetGlow[iClient] = null;
	
	return Plugin_Stop;
}

public Action:TimerGiveHudBack(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient) == true && IsFakeClient(iClient) == false)
		SetEntProp(iClient, Prop_Send, "m_iHideHUD", 0);
	
	return Plugin_Stop;
}

/*public Action:TimerResetCommonLimit(Handle:timer, any:iClient)
{
	SetConVarInt(FindConVar("z_common_limit"), 30);
	
	return Plugin_Stop;
}*/

public Action:TimerResetZombieDamage(Handle:timer, any:iClient)
{
	SetConVarInt(FindConVar("z_common_limit"), 30);
	g_bCommonInfectedDoMoreDamage = false;
	
	return Plugin_Stop;
}

public Action:TimerUnfreezeNotification(Handle:timer, any:data)
{
	if(g_iUnfreezeNotifyRunTimes-- > 1)
	{
		g_iPrintRunTimes = g_iUnfreezeNotifyRunTimes * 5;
		PrintHintTextToAll("Survivors will be unfrozen in %i seconds", g_iPrintRunTimes);
		//LogError("TimerUnfreezeNotification Continue, Handle %i", g_hTimer_FreezeCountdown);
		return Plugin_Continue;
	}

	//LogError("TimerUnfreezeNotification Setting g_hTimer_FreezeCountdown to null, Handle %i", g_hTimer_FreezeCountdown);
	g_hTimer_FreezeCountdown = null;
	//LogError("TimerUnfreezeNotification Plugin_Stop, Handle %i", g_hTimer_FreezeCountdown);
	
	return Plugin_Stop;
}

public Action:TimerChangeSpectator(Handle:timer, any:iClient)
{
	if(iClient > 0 && g_bClientSpectating[iClient] == true && IsClientInGame(iClient) && IsFakeClient(iClient) == false)
	{
		ChangeClientTeam(iClient, TEAM_SPECTATORS);
		g_iClientTeam[iClient] = 1;
		PrintToChat(iClient, "\n\x03[XPMod] \x04You are a Spectator until you change teams through the XPM Menu.\n ");
		PrintHintText(iClient, "You are a Spectator until you change teams through the XPM Menu.");
	}
	
	return Plugin_Stop;
}

public Action:TimerResetPlayerChangeTeamCoolDown(Handle:timer, any:iClient)
{
	g_bPlayerInTeamChangeCoolDown[iClient] = false;

	return Plugin_Stop;
}

public Action:TimerCheckTeam(Handle:timer, any:iClient)
{
	if(iClient < 1 || IsClientInGame(iClient) == false)
		return Plugin_Stop;
	
	if(g_bClientSpectating[iClient] == true && IsFakeClient(iClient) == false)
	{
		ChangeClientTeam(iClient, TEAM_SPECTATORS);
		g_iClientTeam[iClient] = 1;
		PrintToChat(iClient, "\n\x03[XPMod] \x04You are a Spectator until you change teams through the XPM Menu.\n ");
		PrintHintText(iClient, "You are a Spectator until you change teams through the XPM Menu.");
	}
	
	g_iClientTeam[iClient] = GetClientTeam(iClient);
	
	DeleteAllClientParticles(iClient);
	ResetAllVariables(iClient);
	
	if(GetClientTeam(iClient) == TEAM_INFECTED)
	{
		for(new i = 1; i <= MaxClients; i++)
		{
			if(g_iGatherLevel[i] == 5 && IsClientInGame(i) == true && GetClientTeam(i) == TEAM_SURVIVORS)
				SetListenOverride(i, iClient, Listen_Yes);	//Sets the iClient to hear all the infected's voice comms
		}
	}
	
	return Plugin_Stop;
}

public Action:FreezeColor(Handle:timer, any:iClient)
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

public Action:TimerResetMelee(Handle:timer, any:data)
{
	if (IsServerProcessing()==false)
		return Plugin_Continue;
	//PrintToChatAll("timer called");
	for(new iClient = 1;iClient<= MaxClients; iClient++)
	{
		if(IsClientInGame(iClient)==true)
		{
			if(g_iSniperLevel[iClient]==5)
			{
				if(IsClientInGame(iClient)==true)
				{
					if(GetClientTeam(iClient)==TEAM_SURVIVORS)
					{
						SetEntData(iClient,g_iOffset_ShovePenalty,0);
					}
				}
			}
			else if(g_iHomerunLevel[iClient]==5)
			{
				if(IsClientInGame(iClient)==true)
				{
					if(GetClientTeam(iClient)==TEAM_SURVIVORS)
					{
						SetEntData(iClient,g_iOffset_ShovePenalty,0);
					}
				}
			}
			if(g_bIsJetpackOn[iClient]==true)
			{
				g_iClientJetpackFuel = g_iClientJetpackFuelUsed[iClient]--;
				if(g_iWreckingBallChargeCounter[iClient]==0)
					PrintHintText(iClient, "%d Fuel Left", g_iClientJetpackFuel);
				if(g_iClientJetpackFuelUsed[iClient]<0)
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
					PrintHintText(iClient, "Out Of Fuel");
				}
			}
			if(g_iGatherLevel[iClient]>0)
				if(g_bClientIDDToggle[iClient]==true)
					DetectionHud(iClient);
		}
	}
	return Plugin_Continue;
}

public Action:TimerUnfreeze(Handle:timer, any:data)
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
			
			fnc_SetRendering(i);
			//ResetGlow(i);
			
			//SetEntDataFloat(i , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0, true);
			fnc_SetClientSpeed(i);
			SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);	//Player can take damage now
			SetEntProp(i, Prop_Send, "m_isGoingToDie", 0);		//Fix the black and white at the beginning of the round           (Working?>
			SetEntDataFloat(i ,g_iOffset_HealthBuffer, 0.0 ,true);		//set temp health to 0
			
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
			
			/*if(g_iClientTeam[i] == TEAM_SURVIVORS)
			{
				if(g_iChosenSurvivor[i] == 0)		//Bills will to live crawling
				{
					if(g_iWillLevel[i] > 0)
					{
						g_iCrawlSpeedMultiplier += g_iWillLevel[i] * 5;
						SetConVarInt(FindConVar("survivor_crawl_speed"), (15 + g_iCrawlSpeedMultiplier),false,false);
						SetConVarInt(FindConVar("survivor_allow_crawling"),1,false,false);
					}
				}
			}*/
			
		}
	}
	
	//Set CVars for all talents that use them.
	/*if(g_iHighestLeadLevel>0)
	{
		if(g_iHighestLeadLevel==5)
		{
			//coachnoshake = true;
			SetConVarInt(FindConVar("z_claw_hit_pitch_max"), 0);
			SetConVarInt(FindConVar("z_claw_hit_pitch_min"), 0);
			SetConVarInt(FindConVar("z_claw_hit_yaw_max"), 0);
			SetConVarInt(FindConVar("z_claw_hit_yaw_min"), 0);
		}
		
		SetConVarInt(FindConVar("chainsaw_attack_force"), 400 + (g_iHighestLeadLevel * 40));
		SetConVarInt(FindConVar("chainsaw_damage"), 100 + (g_iHighestLeadLevel * 10));
		SetConVarFloat(FindConVar("chainsaw_hit_interval"), 0.1 - (float(g_iHighestLeadLevel) * 0.01),false,false);
	}*/
	
	/*for(i=1;i<=MaxClients;i++)
	{
		if(RunClientChecks(i) && IsPlayerAlive(iClient) == true)
		{
			if(g_iClientTeam[i]==TEAM_SURVIVORS)
			{
				new currentmaxHP=GetEntProp(i,Prop_Data,"m_iMaxHealth");
				SetEntProp(i,Prop_Data,"m_iMaxHealth", currentmaxHP + (g_iCoachTeamHealthStack * 5));
				SetEntProp(i,Prop_Data,"m_iHealth", currentmaxHP + (g_iCoachTeamHealthStack * 5));
			}
		}
	}*/
	
	PrintHintTextToAll("Survivors Are Unfrozen");
	
	return Plugin_Stop;
}


public Action:TimerDrugged(Handle:timer, any:iClient)
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

public Action:TimerSpawnGhostClass(Handle:timer, any:iClient)
{
	// PrintToChatAll("Spawned as ghost!");
	
	// if (g_iClientTeam[iClient] == TEAM_INFECTED)
	// {
	// 	g_iInfectedCharacter[iClient] = GetEntProp(iClient, Prop_Send, "m_zombieClass");
	// 	PrintToChatAll("ZombieClass = %d", g_iInfectedCharacter[iClient]);
		
	// 	if(g_iInfectedCharacter[iClient] != g_iClientInfectedClass1[iClient] && g_iInfectedCharacter[iClient] != g_iClientInfectedClass2[iClient] && g_iInfectedCharacter[iClient] != g_iClientInfectedClass3[iClient])
	// 	{
	// 		PrintToChatAll("Infected Character %i does not equal class %i, %i, or %i", g_iInfectedCharacter[iClient], g_iClientInfectedClass1[iClient], g_iClientInfectedClass2[iClient], g_iClientInfectedClass3[iClient]);
	// 		new WeaponIndex;
	// 		while ((WeaponIndex = GetPlayerWeaponSlot(iClient, 0)) != -1)
	// 		{
	// 			RemovePlayerItem(iClient, WeaponIndex);
	// 			RemoveEdict(WeaponIndex);
	// 		}

	// 		int newClass = 0
	// 		switch (GetRandomInt(0, 2))
	// 		{
	// 			case 0:
	// 			{
	// 				newClass = g_iClientInfectedClass1[iClient]
	// 			}
	// 			case 1:
	// 			{
	// 				newClass = g_iClientInfectedClass2[iClient]
	// 			}
	// 			case 2:
	// 			{
	// 				newClass = g_iClientInfectedClass3[iClient]
	// 			}
	// 		}

	// 		PrintToChatAll("Attempting to change spawn to %i", newClass);
	// 		SDKCall(g_hSetClass, iClient, newClass);
	// 		int cAbility = GetEntPropEnt(iClient, Prop_Send, "m_customAbility");
	// 		if (cAbility > 0) AcceptEntityInput(cAbility, "Kill");
	// 		new entData = GetEntData(SDKCall(g_hCreateAbility, iClient), g_iAbility)
	// 		if (entData > 0) SetEntProp(iClient, Prop_Send, "m_customAbility", entData);
	// 		PrintToChatAll("Should be spawned as a %i", newClass);

	// 		// Example OLD Code
	// 		// PrintToChatAll("Spawning as %i", g_iClientInfectedClass3[iClient]);
	// 		// SDKCall(g_hSetClass, iClient, g_iClientInfectedClass3[iClient]);
	// 		// new entprop = GetEntProp(iClient, Prop_Send, "m_customAbility")
	// 		// AcceptEntityInput(MakeCompatEntRef(entprop), "Kill");
	// 		// new ent = GetEntData(SDKCall(g_hCreateAbility, iClient), g_iAbility);
	// 		// SetEntProp(iClient, Prop_Send, "m_customAbility", ent);
	// 		// PrintToChatAll("Should be spawned as a %i", g_iClientInfectedClass3[iClient]);
	// 	}
	// }
	
	return Plugin_Stop;
}