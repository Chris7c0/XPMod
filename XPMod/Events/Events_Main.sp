//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////           GAME EVENTS           /////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/**************************************************************************************************************************
 *                                                 Hook All Game Events                                                   *
 **************************************************************************************************************************/

SetupXPMEvents()
{
	//Hook user messages for silent renames for level tags
	HookUserMessage(GetUserMessageId("SayText2"), Hook_SayText2, true);

	//Map Events
	HookEvent("round_start", Event_RoundStart, EventHookMode_Post);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);
	
	//Player Events
	HookEvent("player_connect_full", Event_PlayerConnect);
	HookEvent("player_disconnect", Event_PlayerDisconnect);
	HookEvent("player_team", Event_PlayerChangeTeam);
	AddCommandListener(JoinTeamCmd, "jointeam"); // Specifically for interrupting M button
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("player_hurt", Event_PlayerHurt);
	HookEvent("player_incapacitated", Event_PlayerIncap);
	HookEvent("player_ledge_grab", Event_LedgeGrab);
	HookEvent("player_jump", Event_PlayerJump);
	HookEvent("player_use", Event_PlayerUse);
	HookEvent("friendly_fire", Event_FriendlyFire);
	
	//Survivor Events
	HookEvent("weapon_fire", Event_WeaponFire);
	HookEvent("weapon_reload", Event_WeaponReload);
	HookEvent("heal_success", Event_HealSuccess);
	HookEvent("revive_success", Event_ReviveSuccess);
	HookEvent("defibrillator_used", Event_DefibUsed);
	HookEvent("weapon_fire", Event_WeaponFire);
	HookEvent("pills_used", Event_PillsUsed);
	HookEvent("adrenaline_used", Event_AdrenalineUsed);
	HookEvent("item_pickup", Event_ItemPickUp);
	HookEvent("weapon_given", Event_WeaponGiven);
	HookEvent("upgrade_pack_used", Event_UpgradePackUsed);
	HookEvent("weapon_drop", Event_WeaponDropped);
	HookEvent("weapon_pickup", Event_WeaponPickUp);
	HookEvent("spawner_give_item", Event_SpawnerGiveItem);
	HookEvent("use_target", Event_UseTarget);
	HookEvent("receive_upgrade", Event_ReceiveUpgrade);
	
	//Infected Events
	HookEvent("infected_decapitated", Event_InfectedDecap);
	HookEvent("infected_hurt", Event_InfectedHurt);
	HookEvent("tank_spawn", Event_TankSpawn);
	HookEvent("witch_spawn", Event_WitchSpawn);
	HookEvent("witch_killed", Event_WitchKilled);
	HookEvent("zombie_ignited", Event_ZombieIgnited);
	HookEvent("jockey_ride", Event_JockeyRide);
	HookEvent("tongue_grab", Event_TongueGrab);
	HookEvent("tongue_release", Event_TongueRelease);
	HookEvent("choke_start", Event_ChokeStart);
	HookEvent("choke_end", Event_ChokeEnd);
	HookEvent("jockey_ride_end", Event_JockeyRideEnd);
	HookEvent("lunge_pounce", Event_HunterPounceStart);
	HookEvent("pounce_end", Event_HunterPounceStopped);
	HookEvent("charger_charge_start", Event_ChargerChargeStart);
	HookEvent("charger_charge_end", Event_ChargerChargeEnd);
	HookEvent("charger_impact", Event_ChargerImpact);
	HookEvent("charger_carry_start", Event_ChargerCarryStart);
	HookEvent("charger_carry_end", Event_ChargerCarryEnd);
	HookEvent("charger_pummel_start", Event_ChargerPummelStart);
	HookEvent("charger_pummel_end", Event_ChargerPummelEnd);
	HookEvent("charger_killed", Event_ChargerKilled);
	HookEvent("ability_use", Event_AbilityUse);
	HookEvent("spit_burst", Event_SpitBurst);
	HookEvent("player_now_it", Event_PlayerNowIt);
	//HookEvent("ghost_spawn_time", Event_GhostSpawnTime);
	//HookEvent("entered_spit", Event_EnteredSpit);
	
}

/**************************************************************************************************************************
 *                                                    Events Functions                                                    *
 **************************************************************************************************************************/

public Action:OnPlayerRunCmd(iClient, &iButtons, &iImpulse, Float:fVelocity[3], Float:fAngles[3], &iWeapon)
{
	// If the round has not been unfrozen yet, check for input and then start unfreeze timer once input has been done
	if (g_bPlayerPressedButtonThisRound == false && iButtons)
	{
		g_bPlayerPressedButtonThisRound = true;
		// PrintToServer("**************************** Setting up unfreeze timer OnPlayerRunCmd");
		SetupUnfreezeGameTimer(20.0);
	}

	// // Get button released 
	// if( GetEntProp( iClient, Prop_Data, "m_afButtonReleased" ) )
	// 	PrintToServer("Button released =========================================< %i", GetEntProp( iClient, Prop_Data, "m_afButtonReleased" ));

	// Ensure is a real player before continuing to check for drawing choose character and confirm menu
	if (IsFakeClient(iClient) == false && g_iOpenCharacterSelectAndDrawMenuState[iClient] != FINISHED_AND_DREW_CONFIRM_MENU)
	{
		// Dont show this motd or menu if they have already confirmed
		if (g_bClientLoggedIn[iClient] == true && g_bTalentsConfirmed[iClient] == true)
			g_iOpenCharacterSelectAndDrawMenuState[iClient] = FINISHED_AND_DREW_CONFIRM_MENU;

		// Check if player pressed a certain button after joining game, if they did it will trigger a show choose character
		if (g_iOpenCharacterSelectAndDrawMenuState[iClient] == WAITING_ON_BUTTON_FOR_MOTD && (iButtons)
			// && (iButtons & IN_FORWARD || 
			// 	iButtons & IN_BACK || 
			// 	iButtons & IN_MOVELEFT || 
			// 	iButtons & IN_MOVERIGHT ||
			// 	iButtons & IN_JUMP || 
			// 	iButtons & IN_DUCK || 
			// 	iButtons & IN_ATTACK || 
			// 	iButtons & IN_ATTACK2)
			)
		{
			//PrintToServer("g_iOpenCharacterSelectAndDrawMenuState = WAITING_ON_RELEASE_FOR_CONFIRM_MENU: %i", iButtons);
			//PrintToChat(iClient, "g_iOpenCharacterSelectAndDrawMenuState = WAITING_ON_RELEASE_FOR_CONFIRM_MENU: %i", iButtons);
			g_iOpenCharacterSelectAndDrawMenuState[iClient] = WAITING_ON_RELEASE_FOR_CONFIRM_MENU;

			// This will open user chacter selection, then get the user data, then will draw confirm menu in callback
			// If they already chose to display this through the xpm menu, then dont display
			if (g_bClientAlreadyShownCharacterSelectMenu[iClient] == false)
				OpenCharacterSelectionPanel(iClient);
		}
		// Check if the user released any and all buttons that were pressed in the previous state
		if (g_iOpenCharacterSelectAndDrawMenuState[iClient] == WAITING_ON_RELEASE_FOR_CONFIRM_MENU && 
			iButtons == 0)
			//GetEntProp(iClient, Prop_Data, "m_afButtonReleased") & IN_FORWARD) //g_iButtonPressedbeforeCharacterMotd[iClient])
		{
			//PrintToServer("g_iOpenCharacterSelectAndDrawMenuState = ...");
			//PrintToChat(iClient, "g_iOpenCharacterSelectAndDrawMenuState = ...");

			// Set to 0 first to stop multiple calls
			g_iOpenCharacterSelectAndDrawMenuState[iClient] = 0;
			CreateTimer(1.0, StartWaitingForClientInputForDrawMenu, iClient);
		}
		// Check if the user pushed a button after the previous buttons were released
		if (g_iOpenCharacterSelectAndDrawMenuState[iClient] == WAITING_ON_FINAL_BUTTON_FOR_CONFIRM_MENU && iButtons)// & IN_FORWARD)
		{
			//PrintToChat(iClient, "g_iOpenCharacterSelectAndDrawMenuState = FINISHED_AND_DREW_CONFIRM_MENU");
			g_iOpenCharacterSelectAndDrawMenuState[iClient] = FINISHED_AND_DREW_CONFIRM_MENU;
			// This will get the user data, and the second true will draw confirm menu in callback
			// Make sure their talents aren't confirmed yet though, to not load or change multiple
			if (g_bTalentsConfirmed[iClient] == false)
				GetUserData(iClient, true, true);
		}
	}

	// Ghosts Spawn In
	// This is the best place I could find to capture ghost spawn in reliablly
	// Move this to on game frame if doing more with ghost and need it before input given
	if (g_bCanBeGhost[iClient] && 
		g_iClientTeam[iClient] == TEAM_INFECTED &&
		g_bIsGhost[iClient] == false &&
		RunClientChecks(iClient))
	{
		// Check if they have set a class already
		if (g_iInfectedCharacter[iClient] == UNKNOWN_INFECTED)
		{
			//Check if they are a ghost
			if (GetEntData(iClient, g_iOffset_IsGhost, 1) == 1)
			{
				g_bCanBeGhost[iClient] = false;
				g_bIsGhost[iClient] = true;
				PrintToChat(iClient, "You are a ghost!");
				SetClientSpeed(iClient);
			}
		}
		// If they have an infected class set, then they are already spawned in
		else
		{
			g_bCanBeGhost[iClient] = false;
		}
	}

	//Charger Earthquake
	if(g_bIsHillbillyEarthquakeReady[iClient] == true && g_bCanChargerEarthquake[iClient] == true && iButtons & IN_ATTACK2 && g_iInfectedCharacter[iClient] == CHARGER)
	{
		new Float:xyzClientPosition[3], Float:xyzClientEyeAngles[3],Float:xyzRayTraceEndLocation[3];
		GetClientEyePosition(iClient, xyzClientPosition);
		GetClientEyeAngles(iClient,xyzClientEyeAngles); // Get the angle the player is looking
		
		TR_TraceRayFilter(xyzClientPosition,xyzClientEyeAngles,MASK_ALL,RayType_Infinite ,TraceRayTryToHit); // Create a ray that tells where the player is looking
		TR_GetEndPosition(xyzRayTraceEndLocation); // Get the end xyz coordinate of where a player is looking
		
		new Float:fDistanceOfTrace = GetVectorDistance(xyzClientPosition, xyzRayTraceEndLocation);
		if (fDistanceOfTrace <= 100.0)
		{
			//Create the earthquake effect and sound
			EmitSoundToAll(SOUND_EXPLODE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzClientPosition, NULL_VECTOR, true, 0.0);
			
			TE_Start("BeamRingPoint");
			TE_WriteVector("m_vecCenter", xyzClientPosition);
			TE_WriteFloat("m_flStartRadius", 10.0);
			TE_WriteFloat("m_flEndRadius", 1000.0);
			TE_WriteNum("m_nModelIndex", g_iSprite_Laser);
			TE_WriteNum("m_nHaloIndex", g_iSprite_Halo);
			TE_WriteNum("m_nStartFrame", 0);
			TE_WriteNum("m_nFrameRate", 60);
			TE_WriteFloat("m_fLife", 0.5);
			TE_WriteFloat("m_fWidth", 100.0);
			TE_WriteFloat("m_fEndWidth", 5.0);
			TE_WriteFloat("m_fAmplitude",  0.5);
			TE_WriteNum("r", 20);
			TE_WriteNum("g", 20);
			TE_WriteNum("b", 20);
			TE_WriteNum("a", 200);
			TE_WriteNum("m_nSpeed", 10);
			TE_WriteNum("m_nFlags", 0);
			TE_WriteNum("m_nFadeLength", 0);
			TE_SendToAll();
		
			//Checking if there are survivors close enough to the blast and shaking them
			decl iTarget;
			for (iTarget = 1; iTarget <= MaxClients; iTarget++)
			{
				if(IsClientInGame(iTarget) && IsPlayerAlive(iTarget) && g_iClientTeam[iTarget] == TEAM_SURVIVORS && GetEntProp(iTarget, Prop_Send, "m_isIncapacitated") == 0)
				{
					decl Float:xyzTargetLocation[3];
					GetClientEyePosition(iTarget, xyzTargetLocation);
					new Float:fDistance = GetVectorDistance(xyzTargetLocation, xyzClientPosition);
					if(IsVisibleTo(xyzClientPosition, xyzTargetLocation) == true && fDistance < (200.0 + (float(g_iHillbillyLevel[iClient]) * 15.0)))
					{
						//Shake their screen
						new Handle:hShakeMessage;
						hShakeMessage = StartMessageOne("Shake", iTarget);
						
						BfWriteByte(hShakeMessage, 0);
						BfWriteFloat(hShakeMessage, 40.0);	//Intensity
						BfWriteFloat(hShakeMessage, 10.0);
						BfWriteFloat(hShakeMessage, 3.0);	//Time?
						EndMessage();
						
						//"Stagger the player by flinging them
						SDKCall(g_hSDK_Fling, iTarget, EMPTY_VECTOR, 96, iClient, 3.0);
						
						//Hurt the player
						DealDamage(iTarget, iClient, RoundToCeil(g_iHillbillyLevel[iClient] * 2.5));
					}
				}
			}
			g_bIsHillbillyEarthquakeReady[iClient] = false;
			g_iClientBindUses_2[iClient]++;
			
			//Set cooldown
			g_bCanChargerEarthquake[iClient] = false;
			CreateTimer(30.0, TimerEarthquakeCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
		}
	}

	//Bill's Team Crawling
	if(g_iCrawlSpeedMultiplier > 0 && IsFakeClient(iClient) == false)
	{
		// gClone[iClient] == -1 check is to make sure Animation isnt already playing 
		if(gClone[iClient] == -1 && !g_bEndOfRound && iButtons & IN_FORWARD && GetEntProp(iClient, Prop_Send, "m_isIncapacitated")) 
		{
			CreateTimer(0.1,tmrPlayAnim,iClient);		// Delay so we can get the correct angle/direction after they have moved
			gClone[iClient] = -2;						// So we don't play the anim more than once if the player presses forward within the 0.1 delay
		}
		// Animation has been playing but no longer moving/incapped
		else if(gClone[iClient] > 1)
		{
			RestoreClient(iClient);
		}
	}

	// // Testing bot button presses
	// if (g_iTankChosen[iClient] == TANK_VAMPIRIC)
	// {
	// 	if (g_bShouldJump[iClient])
	// 	{
	// 		PrintToChatAll("Jumping");
	// 		iButtons &= IN_JUMP;
	// 		g_bShouldJump[iClient] = false;

	// 		return Plugin_Changed;
	// 	}
	// 	else
	// 	{
	// 		if (g_hShouldAttackTimer[iClient] == null) {
	// 			PrintToChatAll("Not Jumping");
	// 			iButtons |= IN_JUMP;

	// 			//delete g_hShouldAttackTimer[iClient];
	// 			g_hShouldAttackTimer[iClient] = CreateTimer(3.0, Timer_ShouldJump, iClient);
	// 		}
	// 	}
	// }

	return Plugin_Continue;
}

// // Testing bot button presses
// bool g_bShouldJump[MAXPLAYERS + 1];
// Handle g_hShouldAttackTimer[MAXPLAYERS + 1];
// public Action Timer_ShouldJump(Handle timer, int client)
// {
// 	PrintToChatAll("Timer_ShouldJump");

// 	// check if client is the same has the one before when the timer started
// 	if (client != 0) {
// 		// set variable so next frame knows that client need to release attack
// 		g_bShouldJump[client] = true;
// 	}

// 	g_hShouldAttackTimer[client] = null;
// 	return Plugin_Handled;
// } 


// This is purely to block the name change message when updating a name to have the XPMod Level tags
// Originally from https://forums.alliedmods.net/showthread.php?t=302085
Action Hook_SayText2(UserMsg msg_id, any msg, const int[] players, int playersNum, bool reliable, bool init)
{
	// Continue as usual if we arent hiding the name change messages currently
	if(g_bHideNameChangeMessage == false)
		return Plugin_Continue;

	// Get the message that will be checked if its the name change string
	char[] sMessage = new char[24];
	if(GetUserMessageType() == UM_Protobuf)
	{
		Protobuf pbmsg = msg;
		pbmsg.ReadString("msg_name", sMessage, 24);
	}
	else
	{
		BfRead bfmsg = msg;
		bfmsg.ReadByte();
		bfmsg.ReadByte();
		bfmsg.ReadString(sMessage, 24, false);
	}

	// If we have a name change, then prevent the message from being seen
	if(StrEqual(sMessage, NAME_CHANGE_STRING))
		return Plugin_Handled;

	// Otherwise, move on and continue displaying the message
	return Plugin_Continue;
}

Action:Event_RoundStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToServer("EVENT ROUND START=====================================================================================");
	//PrintToServer("**************************** FREEZING GAME");
	g_bGameFrozen = true;
	g_bPlayerPressedButtonThisRound = false;

	CleanUpMenuHandles();	// Puts all the menu handles at invalid to minimize the amount of handles open
	//g_bRoundStarted = true;
	g_bEndOfRound = false;
	g_bCanSave = true;

	// Show rewards from last round
	CreateTimer(50.0, TimerShowReward1, 0, TIMER_FLAG_NO_MAPCHANGE);	
	
	
	//Reset Variables
	for(new i = 1; i <= MaxClients; i++)
	{
		CheckLevel(i);
		
		//Reset all the client variables to their initial state
		ResetVariablesForMap(i);
		DeleteAllMenuParticles(i);
		
		//Sets voice comns back to default setting
		if(IsClientInGame(i) == true)
		{
			for(new other = 1; other <= MaxClients; other++)
			{
				if(IsClientInGame(other) == true && IsFakeClient(other) == false)
					SetListenOverride(i, other, Listen_Default);
			}
		}
	}
	
	for(new i = 0; i < MAXENTITIES; i++)
		g_iPoopBombOwnerID[i] = 0;
	
	//Reset CVars and XPMod Variables for the round
	SetConVarInt(FindConVar("z_frustration"), 0);
	SetConVarInt(FindConVar("z_common_limit"), 30);
	SetConVarInt(FindConVar("sv_disable_glow_survivors"), 0);
	SetConVarInt(FindConVar("z_claw_hit_pitch_max"), 20);
	SetConVarInt(FindConVar("z_claw_hit_pitch_min"), -20);
	SetConVarInt(FindConVar("z_claw_hit_yaw_max"), 20);
	SetConVarInt(FindConVar("z_claw_hit_yaw_min"), -20);
	SetConVarInt(FindConVar("chainsaw_attack_force"), 400);
	SetConVarInt(FindConVar("chainsaw_damage"), 100);
	SetConVarFloat(FindConVar("chainsaw_hit_interval"), 0.1, false, false);
	SetConVarInt(FindConVar("survivor_crawl_speed"), 15,false,false);
	SetConVarInt(FindConVar("survivor_allow_crawling"),0,false,false);
	SetConVarFloat(FindConVar("z_vomit_fatigue"),0.0,false,false);	//So players can move on vomit
	//////////////////////////////////////////////////////////////////////////////////////////////////////SetConVarFloat(FindConVar("z_spit_fatigue"),0.0,false,false);	//So players can move on spit
	SetConVarInt(FindConVar("first_aid_kit_max_heal"), 999);		//So everyone can heal to their max using medkit
	SetConVarFloat(FindConVar("first_aid_heal_percent"),0.0,false,false);	//So it doesnt heal at all (this is handled in the heal success event)
	SetConVarInt(FindConVar("pain_pills_health_threshold"), 999);	//So everyone can use pain pills above 99 health
	SetConVarInt(FindConVar("sb_stop"), 1);				//So the bots dont run off before unfrozen
	SetConVarFloat(FindConVar("upgrade_laser_sight_spread_factor"), 0.4);
	g_bCommonInfectedDoMoreDamage = false;
	g_iNickResurrectUses = 0;
	g_iHighestLeadLevel = 0;
	g_iCoachTeamHealthStack = 0;
	g_iCrawlSpeedMultiplier = 0;
	g_iNickDesperateMeasuresStack = 0;
	g_fMaxLaserAccuracy = 0.4;
	g_bSomeoneAttacksFaster = false;
	
	return Plugin_Continue;
}

Action:Event_RoundEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToServer("Event_RoundEnd =========================================================");

	g_bGameFrozen = true;
	//g_bRoundStarted = false;
	g_bEndOfRound = true;
	g_iKitsUsed = 0;
	
	if(g_bCanSave == true)	//To prevent more than one run at the end of the round
	{
		decl i;
		for(i = 1; i <= MaxClients; i++)	//Check if needed
		{
			g_bIsSmokeInfected[i] = false;
		}
		
		//Reset Rewards
		g_iReward_SIKills = 0;
		g_iReward_CIKills = 0;
		g_iReward_HS = 0;
		g_iReward_SurKills = 0;
		g_iReward_SurIncaps = 0;
		g_iReward_SurDmg = 0;
		
		GiveRewards();
		
		for(i = 1; i <= MaxClients; i++)
		{
			//Save their game
			if(IsClientInGame(i) == true)
				if(IsFakeClient(i) == false)
					if(g_bClientLoggedIn[i] == true)
						SaveUserData(i);
		}

		// Remove the player level tags until the next confirmation
		for(new iClient = 1; iClient <= MaxClients; iClient++)
			RenamePlayerWithLevelTags(iClient, true);
	}
	
	g_bCanSave = false;
	
	return Plugin_Continue;
}

Event_PlayerJump(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	if (iClient < 1)
		return;
	if(GetEntData(iClient, g_iOffset_IsGhost, 1) == 1)		//Check if they are ghost first
		return;
	if(IsClientInGame(iClient))
		if(!IsFakeClient(iClient))
			if(g_iClientTeam[iClient] == TEAM_INFECTED)
			{
				if(g_iInfectedCharacter[iClient] == JOCKEY)
				{
					if(g_iMutatedLevel[iClient] > 0)
					{
						CreateTimer(0.1, TimerJumpFurther, iClient, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
				else if(g_bIsSuicideBoomer[iClient] == true)
				{
					if(g_iInfectedCharacter[iClient] == BOOMER)
					{
						CreateTimer(0.1, TimerSuicideBoomerLaunch, iClient, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
	return;
}

Action:JoinTeamCmd(iClient, const String:command[], argc)
{
	// This is specifically for preventing user from changing team using M button on cool down
	if (g_bPlayerInTeamChangeCoolDown[iClient] == true)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You can only change teams once every 4 seconds.");
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action:Event_PlayerChangeTeam(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Continue;
	
	g_bPlayerInTeamChangeCoolDown[iClient] = true;
	CreateTimer(4.0, TimerResetPlayerChangeTeamCoolDown, iClient, TIMER_FLAG_NO_MAPCHANGE);

	CreateTimer(0.1, TimerCheckTeam, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Continue;
}

Action:Event_PlayerSpawn(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	// if (RunClientChecks(iClient) && IsFakeClient(iClient) == false)
	// 		PrintToChat(iClient, "Event_PlayerSpawn ================================================================");
	// PrintToServer("Event_PlayerSpawn ================================================================ %i", iClient);
	
	if(IsClientInGame(iClient) == false)
		return Plugin_Continue;
	if(IsValidEntity(iClient) ==  false)
		return Plugin_Continue;
	
	g_iClientTeam[iClient] = GetClientTeam(iClient);
	
	if(g_iClientTeam[iClient] == TEAM_INFECTED)
		g_iInfectedCharacter[iClient] = GetEntProp(iClient, Prop_Send, "m_zombieClass");
	
	fnc_SetRendering(iClient);
	//ResetGlow(iClient);
	SetEntProp(iClient, Prop_Send, "m_iHideHUD", 0);
	
	if(IsFakeClient(iClient) == false)
	{
		if(g_bClientSpectating[iClient] == true)
			CreateTimer(0.1, TimerChangeSpectator, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
	
	if(g_iClientLevel[iClient] == 0)
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_1 * XP_MULTIPLIER);
		
	if(g_bGameFrozen == false)
	{
		talentsJustGiven[iClient] = false;
		
		//This needs to be at 0.2 because ResetAllVariables is called at 0.1 twice on change team
		CreateTimer(0.2, TimerLoadTalentsDelay, iClient, TIMER_FLAG_NO_MAPCHANGE);	
	}
	else if ((GetClientTeam(iClient)) == TEAM_SURVIVORS)
		PlayerFreeze(iClient);

	SetClientSpeed(iClient);
	
	return Plugin_Continue;
}

SetupUnfreezeGameTimer(Float:unfreezeWaitTime)
{	
	if(g_iGameMode != GAMEMODE_SCAVENGE)
	{
		CreateTimer(unfreezeWaitTime, TimerUnfreeze, 0, TIMER_FLAG_NO_MAPCHANGE);

		g_iUnfreezeNotifyRunTimes = RoundFloat(unfreezeWaitTime / 5.0);
		
		// *For some reason, delete errors out when ran even though it doesnt appear to be 
		// equal to INVALID_HANDLE. The conclusion from the testing is to just not run the 
		// delete on this one. It looks like it should be handled fine anyway*
		// **delete g_hTimer_FreezeCountdown;
		//LogError("Setting g_hTimer_FreezeCountdown, Handle %i", g_hTimer_FreezeCountdown);
		g_hTimer_FreezeCountdown = CreateTimer(5.0, TimerUnfreezeNotification, _, TIMER_REPEAT);
		//LogError("Set g_hTimer_FreezeCountdown, Handle %i", g_hTimer_FreezeCountdown);

		// This line is literally only to remove the compiler warning.  It does nothing.
		if (g_hTimer_FreezeCountdown == null) {}
	}
	else
	{
		CreateTimer(0.3, TimerUnfreeze, 0, TIMER_FLAG_NO_MAPCHANGE);
	}
}

Action:Event_PlayerConnect(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	if(iClient==0)
		return Plugin_Continue;
	if(!IsClientInGame(iClient))
		return Plugin_Continue;
	if(IsFakeClient(iClient)==true)
	{
		// PrintToChatAll("FAKE CLIENT: %i: %N", iClient, iClient);
		// PrintToServer("FAKE CLIENT: %i: %N", iClient, iClient);
		if(g_bClientLoggedIn[iClient] == true)
			Logout(iClient);
		return Plugin_Continue;
	}
	decl String:clientname[128];
	new bool:match = true;
	GetClientName(iClient, clientname, sizeof(clientname));

	// Fill in special characters with ?...to prevent errors..I guess?
	for(new l=0; l<22; l++)
	{
		if(clientname[l] != '\0')
		{
			if((clientname[l] < 1) || (clientname[l] > 127))
				clientname[l] = '?';
		}
		else
			break;
	}

	//Check if is the same as before
	if(clientidname[iClient][0] == clientname[0])
	{
		new l = 0;
		while((clientname[l]!='\0' || clientidname[iClient][l]!='\0') && (l < 22))
		{
			//PrintToChatAll("checking %c, %d = %c, %d", clientidname[iClient][l], clientidname[iClient][l], clientname[l], clientname[l]);
			if(clientidname[iClient][l] != clientname[l])
			{
				match = false;
				//PrintToConsole(iClient, "==========================Does not match");
			}
			l++;
		}
	}
	else 
		match = false;
		
	//if not the same as before logout/reset loudout and set the new clientname
	if(match==false)
	{
		// PrintToChatAll("Masmatch Name: %i: %N", iClient, iClient);
		// PrintToServer("Masmatch Name: %i: %N", iClient, iClient);
		Logout(iClient);
		g_bClientSpectating[iClient] = false;
		g_iAutoSetCountDown[iClient] = -1;
		g_bTalentsGiven[iClient] = false;

		//ClientCommand(iClient, "bind ` toggleconsole");
		//ClientCommand(iClient, "con_enable 1");

		GetClientName(iClient, clientname, sizeof(clientname));
		for(new l=0; l<23; l++)
		{
			clientidname[iClient][l] = '\0';
		}
		for(new l=0; l<22; l++)
		{
			if(clientname[l] != '\0')
			{
				clientidname[iClient][l] = clientname[l];
				if((clientidname[iClient][l] < 1) || (clientidname[iClient][l] > 127))
					clientidname[iClient][l] = '?';
				//PrintToChatAll("l = %d   adding %c (%d)", l, clientname[l], clientname[l]);
				//PrintToChatAll("l = %d          %c (%d)", l, clientidname[iClient][l], clientidname[iClient][l]);
			}
			else
			{
				//clientidname[iClient][l] = '\0';
				//for(new i=0; i<22; i++)
				//{
				//	if(clientname[i] != '\0')
				//		PrintToChatAll("Client id name = %s", clientidname[iClient][i]);
				//	else break;
				//}
				break;
			}
		}
		//PrintToChatAll("PCONNECT FULL: %d: Clientname %s stored in database", iClient, clientname);
		//PrintToChatAll("\x03%N \x04has connected", iClient);
		GetUserIDAndToken(iClient);
	}
	else	//They were already in game
	{
		if(g_bClientSpectating[iClient] == true)
			CreateTimer(0.1, TimerChangeSpectator, iClient, TIMER_FLAG_NO_MAPCHANGE);
		//PrintToChatAll("PCONNECT FULL: %d: %s already in database", iClient, clientname);
	}

	// Close menu panel in case it was glitched out
	ClosePanel(iClient);

	return Plugin_Continue;
}


Action:Event_PlayerDisconnect(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	if(iClient	< 1)
		return Plugin_Continue;
	g_bClientSpectating[iClient] = false;
	g_bTalentsGiven[iClient] = false;
	if(IsFakeClient(iClient)==true)
	{
		// PrintToChatAll("Player Disconnect: %i: %N", iClient, iClient);
		// PrintToServer("Player Disconnect: %i: %N", iClient, iClient);
		
		if(g_bClientLoggedIn[iClient] == true)
			Logout(iClient);

		return Plugin_Continue;
	}
	SaveUserData(iClient);
	for(new l=0; l<23; l++)
	{
		clientidname[iClient][l] = '\0';	//WAS clientidname[iClient][l] = 9999;
	}
	DeleteAllClientParticles(iClient);
	g_bClientLoggedIn[iClient] = false;
	g_iDBUserID[iClient] = -1;
	g_strDBUserToken[iClient] = "";
	g_iAutoSetCountDown[iClient] = -1;
	ResetAll(iClient);
	//PrintToChatAll("\x03%N \x04has disconnected", iClient);
	//Reset the arry for the player
	if(g_bDoesClientAttackFast[iClient] == true)
	{
		//PrintToChatAll("PLAYER DISCONNECTED! Removing from array iClient = %N(%d)", iClient, iClient);
		pop(iClient);
		testtoggle[iClient] = false;
	}
	return Plugin_Continue;
}

Action:Event_FriendlyFire(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	
	// new attacker = GetClientOfUserId(GetEventInt(hEvent,"attacker"));
	// new victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	// new guilty = GetClientOfUserId(GetEventInt(hEvent,"guilty"));
	// new type = GetEventInt(hEvent,"type");
	// PrintToChatAll("Attacker = %d, Victim = %d, Guilty = %d, Type = %d", attacker, victim, guilty, type);
	
}