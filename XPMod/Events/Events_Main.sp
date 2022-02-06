//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////           GAME EVENTS           /////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/**************************************************************************************************************************
 *                                                 Hook All Game Events                                                   *
 **************************************************************************************************************************/

SetupXPMEvents()
{
	//AddTempEntHook("PlayerAnimEvent", OnPlayerAnimEvent);

	//Hook user messages for silent renames for level tags
	HookUserMessage(GetUserMessageId("SayText2"), Hook_SayText2, true);

	//Map Events
	HookEvent("round_start", Event_RoundStart, EventHookMode_Post);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);

	//Command Listeners
	//Pause Game
	AddCommandListener(CommandListener_Pause,	"pause");
	AddCommandListener(CommandListener_Setpause,"setpause");
	AddCommandListener(CommandListener_Unpause,	"unpause");
	//Vote Preventions
	AddCommandListener(CommandListener_CallVote, "callvote");
	
	//Player Events
	HookEvent("player_connect_full", Event_PlayerConnect);
	HookEvent("player_disconnect", Event_PlayerDisconnect);
	HookEvent("player_team", Event_PlayerChangeTeam);
	AddCommandListener(CommandListener_JoinTeam, "jointeam"); // Specifically for interrupting M button
	HookEvent("player_bot_replace", Event_PlayerReplacedByBot);
	HookEvent("bot_player_replace", Event_BotReplacedByPlayer);
	HookEvent("survivor_rescued", Event_SurvivorRescued);
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("player_hurt", Event_PlayerHurt);
	HookEvent("player_incapacitated", Event_PlayerIncap);
	HookEvent("player_jump", Event_PlayerJump);
	HookEvent("player_use", Event_PlayerUse);
	HookEvent("friendly_fire", Event_FriendlyFire);
	HookEvent("player_shoved", Event_PlayerShoved);
	
	//Survivor Events
	HookEvent("weapon_fire", Event_WeaponFire);
	HookEvent("weapon_reload", Event_WeaponReload);
	HookEvent("heal_success", Event_HealSuccess);
	HookEvent("player_ledge_grab", Event_LedgeGrab);
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
	HookEvent("tank_frustrated", Event_TankFrustrated);
	HookEvent("witch_spawn", Event_WitchSpawn);
	HookEvent("witch_killed", Event_WitchKilled);
	HookEvent("zombie_ignited", Event_ZombieIgnited);
	HookEvent("jockey_ride", Event_JockeyRide);
	HookEvent("tongue_grab", Event_TongueGrab);
	HookEvent("tongue_release", Event_TongueRelease);
	HookEvent("choke_start", Event_ChokeStart);
	// HookEvent("choke_end", Event_ChokeEnd);
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
	HookEvent("player_no_longer_it", Event_PlayerNoLongerIt);
	//HookEvent("ghost_spawn_time", Event_GhostSpawnTime);
	//HookEvent("entered_spit", Event_EnteredSpit);
	
}

/**************************************************************************************************************************
 *                                                    Events Functions                                                    *
 **************************************************************************************************************************/

//Chat
Action:SayCmd(iClient, args)
{
	if (iClient < 1 || IsClientInGame(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Continue;
	
	//Check to see if they typed in xpm or xpmod, indifferent to the case used
	decl String:strArgument1[16];
	GetCmdArg(1, strArgument1, sizeof(strArgument1));
	if(StrEqual(strArgument1, "xpm", false) == true || StrEqual(strArgument1, "!xpm", false) == true ||
		StrEqual(strArgument1, "xpmod", false) == true || StrEqual(strArgument1, "!xpmod", false) == true)
		{
			XPModMenuDraw(iClient);
		}
	
	if(StrEqual(strArgument1, "/xpm", false) == true)
	{
		XPModMenuDraw(iClient);
		return Plugin_Handled;
	}
		
	
	//Change the color of the admin text in the chat to green
	if(GetUserAdmin(iClient) != INVALID_ADMIN_ID)
	{
		decl String:input[256];
		
		GetCmdArgString(input, sizeof(input));
		if(input[0] ==  '/' || input[1] ==  '/')
			return Plugin_Handled;
			
		if(input[0] ==  '"')
			input[0] = ' ';
		if(input[strlen(input) - 1] == '"')
			input[strlen(input) - 1] = '\0';
		
		PrintToChatAll("\x03%N\x01 : %s", iClient, input);
		PrintToServer("[Admin] %N : %s", iClient, input);
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

Action:SayTeamCmd(iClient, args)
{
	if (iClient < 1 || IsClientInGame(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Continue;
	
	decl String:input[256];
	GetCmdArgString(input,sizeof(input));

	decl String:strArgument1[6];
	GetCmdArg(1, strArgument1, 6);
	if(StrEqual(strArgument1, "xpm", false) == true || StrEqual(strArgument1, "!xpm", false) == true ||
		StrEqual(strArgument1, "xpmod", false) == true || StrEqual(strArgument1, "!xpmod", false) == true)
		XPModMenuDraw(iClient);
		
	if(StrEqual(strArgument1, "/xpm", false) == true)
	{
		XPModMenuDraw(iClient);
		return Plugin_Handled;
	}
	
	decl i;
	for(i = 1; i <= MaxClients; i++)
	{
		if(g_iGatherLevel[i] == 5 && IsClientInGame(i) && IsFakeClient(i) == false && GetClientTeam(i)==TEAM_SURVIVORS && GetClientTeam(iClient)==TEAM_INFECTED)
		{
			decl String:clientname[25];
			GetClientName(iClient, clientname, sizeof(clientname));
			PrintToChat(i, "\x04[\x05IDD Survalence\x04] \x05%s\x04: \x01%s", clientname, input);
		}
	}
	
	return Plugin_Continue;
}

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


public OnMapStart()
{
	//PrintToServer("OnMapStart ========================================================================================================")
	
	//Get current map name
	GetCurrentMap(g_strCurrentMap,32);

	GetXPMConVarValues();

	SQLGetTopXPModPlayerStatistics();

	// Increase the uncommon limit for the NecroTanker and Spitter conjurer abilities
	// Also, more is better...
	SetConVarInt(FindConVar("z_common_limit"), 45);
	//SetConVarInt(FindConVar("z_background_limit"), 45);		// Not required

	// This can be set so that the survivor bots dont teleport if they are entangled
	//SetConVarInt(FindConVar("sb_enforce_proximity_range"), CONVAR_SB_ENFORCE_PROXIMITY_RANGE_DEFAULT);
	
	// Increases the spawn distance
	// Commented out to ensure that zombies spawn closer to the action
	//SetConVarInt(FindConVar("z_spawn_range"), 2500);	//Required or common will disappear when spawned out of range of NecroTanker
	//SetConVarInt(FindConVar("z_discard_range"), 3000); 	//Required or common will disappear when spawned out of range of NecroTanker
	
	// Set the filename for the log to the server name
	GetConVarString(FindConVar("hostname"), g_strServerName, sizeof(g_strServerName));
	// Remove the spaces if there are any, this is helpful when accessing in Linux
	ReplaceString(g_strServerName, sizeof(g_strServerName), " ", "_");
	// Get the log file name
	SetXPMStatsLogFileName();

	g_iRoundCount = 1;

	DispatchKeyValue(0, "timeofday", "1"); //Set time of day to midnight
	
	//Set the g_iGameMode variable
	FindGameMode();
	
	//Precache everything needed for XPMod
	PrecacheAllTextures();	
	PrecacheAllModels();
	PrecacheAllParticles();
	PrecacheAllSounds();
	
	//Set the max teleport height for the map
	//SetMapsMaxTeleportHeight();
}

Action:Event_RoundStart(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToServer("EVENT ROUND START=====================================================================================");
	//PrintToServer("**************************** FREEZING GAME");
	g_bGameFrozen = true;
	g_bPlayerPressedButtonThisRound = false;
	
	//g_bRoundStarted = true;
	g_iRoundCount++;
	g_bEndOfRound = false;
	g_bCanSave = true;
	
	ResetAllVariablesForRound();
		
	return Plugin_Continue;
}

Action:Event_RoundEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToServer("Event_RoundEnd =========================================================");

	g_bGameFrozen = true;
	//g_bRoundStarted = false;
	g_bEndOfRound = true;
	g_bPlayerPressedButtonThisRound = false;
	
	if(g_bCanSave == true)	//To prevent more than one run at the end of the round
	{		
		//Reset Rewards
		g_iReward_SIKills = 0;
		g_iReward_CIKills = 0;
		g_iReward_HS = 0;
		g_iReward_SurKills = 0;
		g_iReward_SurIncaps = 0;
		g_iReward_SurDmg = 0;
		
		GiveRewards();
		StoreLastRoundClientsStats();
		
		for(new i = 1; i <= MaxClients; i++)
		{
			//Save their game
			if (IsClientInGame(i) == true &&
				IsFakeClient(i) == false &&
				g_bClientLoggedIn[i] == true)
					SaveUserData(i);
		}

		// Remove the player level tags until the next confirmation
		for(new iClient = 1; iClient <= MaxClients; iClient++)
			RenamePlayerWithLevelTags(iClient, true);
	}
	
	g_bCanSave = false;
	
	return Plugin_Continue;
}

public Action:CommandListener_Pause(client, const String:command[], argc) {
	return Plugin_Handled; 
}

public Action:CommandListener_Setpause(client, const String:command[], argc) {
	if (g_bGamePaused)
		return Plugin_Continue;
	
	return Plugin_Handled;
}

public Action:CommandListener_Unpause(client, const String:command[], argc) {
	if (g_bGamePaused == false)
		return Plugin_Continue;
	
	return Plugin_Handled;
}

public Action:CommandListener_CallVote(int iVoteCaller, const String:strCommand[], argc)
{
	char strVoteType[32], strVoteTarget[32];
	GetCmdArg(1, strVoteType, sizeof(strVoteType));
	GetCmdArg(2, strVoteTarget, sizeof(strVoteTarget));
	int iTarget = GetClientOfUserId(StringToInt(strVoteTarget));

	//PrintToChat(iVoteCaller, "Vote Called: %s", strVoteType);

	// Check each of the vote types and return plugin handled if it should be prevented
	if (HandleCallVote_Kick(iVoteCaller, iTarget, strVoteType)) return Plugin_Handled;

	// Nothing has prevented the vote so allow it
	return Plugin_Continue;
}

bool HandleCallVote_Kick(int iVoteCaller, int iTarget, char[] strVoteType)
{
	// Ensure its a kick vote before continuing
	if (StrEqual(strVoteType, "kick", false) == false)
		return false;

	// Check client level if they are under threshold allow the vote
	if (g_iClientXP[iTarget] < VOTE_KICK_IMMUNITY_XP_THRESHOLD)
		return false;

	PrintToChat(iVoteCaller, "\x03[XPMod] \x05Player is immune to vote kicking.\n    You can report players at xpmod.net/discord.");
	
	// Interrupt the vote
	return true;
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

Action:CommandListener_JoinTeam(iClient, const String:command[], argc)
{
	// This is specifically for preventing user from changing team using M button on cool down
	if (g_bPlayerInTeamChangeCoolDown[iClient] == true)
	{
		PrintToChat(iClient, "\x03[XPMod] \x05You can only change teams once every 3 seconds.");
		return Plugin_Stop;
	}

	CreateTimer(0.1, TimerCheckTeam, iClient, TIMER_FLAG_NO_MAPCHANGE);

	//This needs to be at 0.2 because ResetAllVariables is called at 0.1 twice on change team
	CreateTimer(0.2, TimerLoadTalentsDelay, iClient, TIMER_FLAG_NO_MAPCHANGE);

	StorePassedOrFrustratedTanksHealthPercentage(iClient);

	// We now do not know which infected they have, because they switched teams
	// These need to take place in this order, set UNKNOWN, then set CanBeGhost
	g_iInfectedCharacter[iClient] = UNKNOWN_INFECTED;
	// For checking if the player is a ghost
	g_bCanBeGhost[iClient] = true;
	g_bIsGhost[iClient] = false;

	return Plugin_Continue;
}

Action:Event_PlayerChangeTeam(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	if(RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Continue;
	
	g_bPlayerInTeamChangeCoolDown[iClient] = true;
	CreateTimer(3.0, TimerResetPlayerChangeTeamCoolDown, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	CreateTimer(0.1, TimerCheckTeam, iClient, TIMER_FLAG_NO_MAPCHANGE);

	//This needs to be at 0.2 because ResetAllVariables is called at 0.1 twice on change team
	CreateTimer(0.2, TimerLoadTalentsDelay, iClient, TIMER_FLAG_NO_MAPCHANGE);

	StorePassedOrFrustratedTanksHealthPercentage(iClient);

	// We now do not know which infected they have, because they switched teams
	// These need to take place in this order, set UNKNOWN, then set CanBeGhost
	g_iInfectedCharacter[iClient] = UNKNOWN_INFECTED;
	// For checking if the player is a ghost
	g_bCanBeGhost[iClient] = true;
	g_bIsGhost[iClient] = false;
	
	return Plugin_Continue;
}

Action:Event_PlayerSpawn(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	// if (RunClientChecks(iClient) && IsFakeClient(iClient) == false)
	// 		PrintToChat(iClient, "Event_PlayerSpawn ================================================================");
	//PrintToServer("Event_PlayerSpawn ================================================================ %i", iClient);
	
	if(IsClientInGame(iClient) == false)
		return Plugin_Continue;
	if(IsValidEntity(iClient) ==  false)
		return Plugin_Continue;
	
	g_iClientTeam[iClient] = GetClientTeam(iClient);
	
	if(g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		g_bIsGhost[iClient] = false;
		g_bCanBeGhost[iClient] = false;
		g_iInfectedCharacter[iClient] = GetEntProp(iClient, Prop_Send, "m_zombieClass");
	}
	
	SetClientRenderAndGlowColor(iClient);
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

	// Capture the players health for functionality like self revive on ledge
	CreateTimer(0.1, TimerStorePlayerHealth, iClient, TIMER_FLAG_NO_MAPCHANGE);

	SetClientSpeed(iClient);

	// If they just spawned then for sure they are not a frustrated tank
	// Removed this because they should have it reset in the TimerResetAllTankVariables
	//g_bIsFrustratedTank[iClient] = false;
	CreateTimer(0.1, TimerResetAllTankVariables, iClient, TIMER_FLAG_NO_MAPCHANGE);

	// Debug Mode Kill Bot SI
	if (g_bStopSISpawning && 
		IsFakeClient(iClient) == true &&
		g_iInfectedCharacter[iClient] != TANK &&
		g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		DealDamage(iClient, 0, 99999);
	}

	
	return Plugin_Continue;
}



Action:Event_PlayerReplacedByBot(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iReplacedPlayer = GetClientOfUserId(GetEventInt(hEvent, "player"));
	new iBot = GetClientOfUserId(GetEventInt(hEvent, "bot"));

	// PrintToChatAll("Event_PlayerReplacedByBot: %i %i", iReplacedPlayer, iBot);

	if(RunClientChecks(iBot) == false)
		return Plugin_Continue;

	if (g_iInfectedCharacter[iReplacedPlayer] == TANK)
		g_bTankTakeOverBot[iBot] = true;
	
	return Plugin_Continue;
}

Action:Event_BotReplacedByPlayer(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iPlayer = GetClientOfUserId(GetEventInt(hEvent, "player"));
	// new iReplacedBot = GetClientOfUserId(GetEventInt(hEvent, "bot"));

	// PrintToChatAll("Event_BotReplacedByPlayer: %i %i", iPlayer, iReplacedBot);

	if(RunClientChecks(iPlayer) == false)
		return Plugin_Continue;

	// This is for when the player goes idle
	// set the bots health to the players health after the game does it
	if (g_iClientTeam[iPlayer] == TEAM_SURVIVORS)
		SetPlayerTalentMaxHealth(iPlayer, false);
	
	return Plugin_Continue;
}

Action:Event_SurvivorRescued(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "victim"));

	// PrintToChatAll("Event_SurvivorRescued: %N", iClient);

	if(RunClientChecks(iClient) == false)
		return Plugin_Continue;

	// This is for when the player goes idle
	// set the bots health to the players health after the game does it
	if (g_iClientTeam[iClient] == TEAM_SURVIVORS)
		SetPlayerTalentMaxHealth(iClient, false);
	
	return Plugin_Continue;
}


SetupUnfreezeGameTimer(Float:unfreezeWaitTime)
{	
	if(g_iGameMode != GAMEMODE_SCAVENGE)
	{
		CreateTimer(unfreezeWaitTime, TimerUnfreeze, 0, TIMER_FLAG_NO_MAPCHANGE);

		g_iUnfreezeNotifyRunTimes = RoundFloat(unfreezeWaitTime);
		
		// *For some reason, delete errors out when ran even though it doesnt appear to be 
		// equal to INVALID_HANDLE. The conclusion from the testing is to just not run the 
		// delete on this one. It looks like it should be handled fine anyway*
		// **delete g_hTimer_FreezeCountdown;
		//LogError("Setting g_hTimer_FreezeCountdown, Handle %i", g_hTimer_FreezeCountdown);
		g_hTimer_FreezeCountdown = CreateTimer(1.0, TimerUnfreezeNotification, _, TIMER_REPEAT);
		//LogError("Set g_hTimer_FreezeCountdown, Handle %i", g_hTimer_FreezeCountdown);

		// This line is literally only to remove the compiler warning.  It does nothing.
		if (g_hTimer_FreezeCountdown == null) {}
	}
	else
	{
		CreateTimer(0.3, TimerUnfreeze, 0, TIMER_FLAG_NO_MAPCHANGE);
	}
}





public OnClientPutInServer(iClient)
{
	if (g_bGamePaused && IsFakeClient(iClient) == false)
	{
		UnpauseGame(iClient);
		CreateTimer(1.0, TimerPauseGame, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
}

// public OnClientConnected(iClient)
// {
// 	if (g_bGamePaused && IsFakeClient(iClient) == false)
// 	{
// 		UnpauseGame(iClient);
// 		CreateTimer(1.0, TimerPauseGame, iClient, TIMER_FLAG_NO_MAPCHANGE);
// 	}
// }

// public OnClientDisconnect(iClient)
// {

// }

Action:Event_PlayerConnect(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	HandleClientConnect(iClient);

	return Plugin_Continue;
}


Action:Event_PlayerDisconnect(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	HandleClientDisconnect(iClient);
	
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

Action:Event_PlayerShoved(Event event, const char[] name, bool dontBroadcast)
{
	// int iClient = GetClientOfUserId(event.GetInt("userid"));
	// if (RunClientChecks(iClient) == false)
	// 	return Plugin_Continue;

	// if (g_iSmokerSmokeCloudPlayer == iClient &&
	// 	g_iClientTeam[iClient] == TEAM_INFECTED)
	// {
	// 	GetEntPropVector(iClient, Prop_Data, "m_vecVelocity", g_xyzPreShoveVelocity[iClient]);
	// 	SDKHook(iClient, SDKHook_PreThink, PreThink);
	// 	return Plugin_Stop;
	// }

	// return Plugin_Continue;
}