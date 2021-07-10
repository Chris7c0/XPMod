//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////        MISCELLANEOUS FUNCTIONS       //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**************************************************************************************************************************
 *                                                Show XPMod Info To Server                                               *
 **************************************************************************************************************************/
 
void ShowXPModInfoToServer()
{
	PrintToServer(":---------<|============================================|>---------:");
	PrintToServer(":---------<|                XP Mod %s              |>---------:", PLUGIN_VERSION);
	PrintToServer(":---------<|============================================|>---------:");
	PrintToServer(":---------<| Created by: Chris Pringle & Ezekiel Keener |>---------:");
	PrintToServer(":---------<|============================================|>---------:");
}

bool RunClientChecks(int iClient)
{
	if (iClient < 1 || 
		iClient > MaxClients || 
		IsValidEntity(iClient) == false || 
		IsClientInGame(iClient) == false)
		return false;

	return true;
}

bool RunEntityChecks(int iEntity)
{
	if (iEntity < 1 || IsValidEntity(iEntity) == false)
		return false;

	return true;
}

bool KillEntitySafely(int iEntity)
{
	if (RunEntityChecks(iEntity) == false)
		return false;

	AcceptEntityInput(iEntity, "Kill");
	return true;
}

int GetHumanPlayerCount()
{
	int iCount = 0;
	for(int i=1;i <= MaxClients; i++)
		if (RunClientChecks(i) && IsClientInGame(i) && !IsFakeClient(i))
			iCount++;
	
	return iCount;
}

void StorePlayerHealth(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1)
		return;
	
	g_iPlayerHealth[iClient] = GetPlayerHealth(iClient);
	g_iPlayerHealthTemp[iClient] =  GetSurvivorTempHealth(iClient);
}

Action:TimerStorePlayerHealth(Handle timer, int iClient)
{
	StorePlayerHealth(iClient);

	return Plugin_Continue;
}

Action:TimerRepeatStoreAllPlayersHealth(Handle timer, int iNothing)
{
	for (int i=1; i <= MaxClients; i++)
		StorePlayerHealth(i);

	return Plugin_Continue;
}

// This is purely a time saver, just to get rid of the warning that a variable is 
// not being used. It can be used for simlar functions that might have a need for
// a variable later, its just not used yet.
void SuppressNeverUsedWarning(any:var1=0, any:var2=0, any:var3=0, any:var4=0, any:var5=0, any:var6=0, any:var7=0, any:var8=0, any:var9=0, any:var10=0)
{
	bool ignore;
	if(ignore) PrintToServer("THIS IS NEVER GOING TO BE RAN",var1, var2, var3, var4, var5, var6, var7, var8, var9, var10);
}

int GetClientAdminLevel(iClient)
{
	if (CheckCommandAccess(iClient, "", ADMFLAG_BAN, true))
		return ADMFLAG_BAN;
	if (CheckCommandAccess(iClient, "", ADMFLAG_KICK, true))
		return ADMFLAG_KICK;
	if (CheckCommandAccess(iClient, "", ADMFLAG_SLAY, true))
		return ADMFLAG_SLAY;
	if (CheckCommandAccess(iClient, "", ADMFLAG_GENERIC, true))
		return ADMFLAG_GENERIC;

	return -1;
}

void FindGameMode()
{
	decl String:g_strGameMode[20];
	GetConVarString(FindConVar("mp_gamemode"), g_strGameMode, sizeof(g_strGameMode));
	
	if (StrEqual(g_strGameMode,"coop",true))
		g_iGameMode = GAMEMODE_COOP;
	else if (StrEqual(g_strGameMode,"versus",true))
		g_iGameMode = GAMEMODE_VERSUS;
	else if (StrEqual(g_strGameMode,"teamversus",true))
		g_iGameMode = GAMEMODE_UNKNOWN;
	else if (StrEqual(g_strGameMode,"teamscavenge",true))
		g_iGameMode = GAMEMODE_SCAVENGE;
	else if (StrEqual(g_strGameMode,"scavenge",true))
		g_iGameMode = GAMEMODE_SCAVENGE;
	else if (StrEqual(g_strGameMode,"survival",true))
		g_iGameMode = GAMEMODE_SURVIVAL;
	else if (StrEqual(g_strGameMode,"realism",true))
		g_iGameMode = GAMEMODE_UNKNOWN;
	else
		g_iGameMode = GAMEMODE_UNKNOWN;
}

bool RunCheatCommand(int iClient, const char [] strCommandName, const char [] strCommandWithArgs)
{
	if (RunClientChecks(iClient) == false)
		return false;

	// Get the command flags
	new iFlag = GetCommandFlags(strCommandName);
	if (iFlag == INVALID_FCVAR_FLAGS)
	{
		PrintToServer("ERROR GETTING COMMAND FLAGS!");
		return false;
	}

	// Handle XPMod Related Tasks
	HandleCheatCommandTasks(iClient, strCommandWithArgs);

	// Temp turn on the cheats for this command, run command,
	// and then turn off the cheats again
	SetCommandFlags(strCommandName, iFlag & ~FCVAR_CHEAT);
	FakeClientCommand(iClient, strCommandWithArgs);
	SetCommandFlags(strCommandName, iFlag);

	return true;
}

void HandleCheatCommandTasks(int iClient, const char [] strCommandWithArgs)
{
	HandleCheatCommandTasks_Ellis(iClient, strCommandWithArgs);
	HandleCheatCommandTasks_Nick(iClient);
	HandleCheatCommandTasks_Louis(iClient, strCommandWithArgs);
}

Action:Timer_ShowXPModInfoToServer(Handle:timer, any:data)
{
	ShowXPModInfoToServer();
	
	return Plugin_Stop;
}

AdvertiseXPModToNewUser(iClient, bool:bShowInChat = false)
{
	EmitSoundToClient(iClient, SOUND_XPM_ADVERTISEMENT, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_TRAIN);
	PrintHintText(iClient, "Type xpm in chat to use XPMod");
	if(bShowInChat)
		PrintToChat(iClient, "\x05Type \x04xpm\x05 in chat to use \x03XPMod\x05!");
}

AdvertiseConfirmXPModTalents(iClient)
{
	PrintHintText(iClient, "Your abilities are NOT loaded. Type xpm in chat and confirm to gain them.");
	//PrintToChat(iClient, "\x03[XPMod] \x05Your talents are NOT loaded. Type \x04xpm\x05 and confirm them.");
}

/**************************************************************************************************************************
 *                                                                                                        *
 **************************************************************************************************************************/

OpenMOTDPanel(iClient, const String:title[], const  String:msg[], type = MOTDPANEL_TYPE_INDEX)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;
	
	decl String:num[3];
	new Handle:Kv = CreateKeyValues("data");
	IntToString(type, num, sizeof(num));
	
	KvSetString(Kv, "title", title);
	KvSetString(Kv, "type", num);
	KvSetString(Kv, "msg", msg);
	ShowVGUIPanel(iClient, "info", Kv, true);
	CloseHandle(Kv);
}

Action:MotdPanel(iClient, args)
{
	//OpenMOTDPanel(iClient, "Choose Your Survivor", "addons/sourcemod/plugins/xpmod/XPMod Website - InGame/Home/xpmod_ig_home.html", MOTDPANEL_TYPE_FILE);
	OpenMOTDPanel(iClient, "XPMod Website", "http://xpmod.net", MOTDPANEL_TYPE_URL);
	return;
}

//Probe Teams for Real Players.   Returns true if there is a non-bot player on inputed team
bool:ProbeTeams(team)
{
	for(new i = 1; i <= MaxClients; i++)
		if(IsClientInGame(i)  && g_iClientTeam[i] == team && IsFakeClient(i) == false)
			return true;
	
	return false;
}

//Taken from djromero's switch players plugin
bool:IsTeamFull(team)
{
	// Spectator's team is never full
	if (team == 1)
		return false;
	
	new max;
	new count;
	new i;
	
	// we count the players in the survivor's team
	if (team == 2)
	{
		max = GetConVarInt(FindConVar("survivor_limit"));
		count = 0;
		for (i=1;i<= MaxClients;i++)
			if ((IsClientInGame(i))&&(!IsFakeClient(i))&&(GetClientTeam(i)==2))
				count++;
	}
	else if (team == 3) // we count the players in the infected's team
	{
		max = GetConVarInt(FindConVar("z_max_player_zombies"));
		count = 0;
		for (i=1;i<= MaxClients;i++)
			if ((IsClientInGame(i))&&(!IsFakeClient(i))&&(GetClientTeam(i)==3))
				count++;
	}
	
	// If full ...
	if (count >= max)
		return true;

	return false;
}

SetMoveType(iClient, movetype, movecollide)
{
	SetEntData(iClient, g_iOffset_MoveType, movetype);
	SetEntData(iClient, g_iOffset_MoveCollide, movecollide);
}

SetSurvivorModel(iClient)
{
	if (GetClientTeam(iClient) != TEAM_SURVIVORS)
	{
		PrintToChat (iClient, "\x03You are not on the Survivors.");
		return;
	}
	
	
	switch(g_iChosenSurvivor[iClient])
	{
		// Note: SetEntProp works, but it causes the characters (bot or human) to
		// disappear from the ui like tab menu and the bottom of the screen.  So,
		// its better to just not set this and leave the character hands/voice/icon.
		case BILL:
		{
			//SetEntProp(iClient, Prop_Send, "m_survivorCharacter", 4);
			SetEntityModel(iClient, "models/survivors/survivor_namvet.mdl");
		}
		case ROCHELLE:
		{
			//SetEntProp(iClient, Prop_Send, "m_survivorCharacter", 1);
			SetEntityModel(iClient, "models/survivors/survivor_producer.mdl");
		}
		case COACH:
		{
			//SetEntProp(iClient, Prop_Send, "m_survivorCharacter", 2);
			SetEntityModel(iClient, "models/survivors/survivor_coach.mdl");
		} 	
		case ELLIS:
		{
			//SetEntProp(iClient, Prop_Send, "m_survivorCharacter", 3);
			SetEntityModel(iClient, "models/survivors/survivor_mechanic.mdl");
		} 	
		case NICK:
		{
			//SetEntProp(iClient, Prop_Send, "m_survivorCharacter", 0);
			SetEntityModel(iClient, "models/survivors/survivor_gambler.mdl");
		}
		case LOUIS:
		{
			//SetEntProp(iClient, Prop_Send, "m_survivorCharacter", 0);
			SetEntityModel(iClient, "models/survivors/survivor_manager.mdl");
		}

		// NOTE, when adding zoey here, there could be issues...
		// This SCS survivor_chat_select plugin changes to a differnt model
		// https://forums.alliedmods.net/showthread.php?p=2399163#post2399163

		// Probably need a fix for l4d1 survivors on the passing campaign (Francis was specifically mentioned)
		// Recommended plugin: The Passing CSM Fix 2.0 (prevents game breaking bugs if L4D1 survivors are used in The Passing)
		// Fixes the bug where players with L4D1 survivors are teleported away or kicked on The Passing
		// https://forums.alliedmods.net/showthread.php?p=2407497#post2407497 
	}
}

//Toggles
Action:ToggleAnnouncerVoice(iClient)	//Toggles the announcers voice
{
	if(iClient!=0)
	{
		if(g_bAnnouncerOn[iClient]==false)
		{
			decl Float:vec[3];
			GetClientEyePosition(iClient, vec);
			EmitAmbientSound(SOUND_GETITON, vec, iClient, SNDLEVEL_NORMAL);
			g_bAnnouncerOn[iClient] = true;
			PrintHintText(iClient, "Announcer is now ON.");
		}
		else
		{
			PrintHintText(iClient, "Announcer is now OFF.");
			g_bAnnouncerOn[iClient] = false;
		}
	}
	return Plugin_Handled;
}

Action:ToggleVGUIDesc(iClient)	//Toggles the vgui menu descriptions for talents
{
	if(iClient!=0)
	{
		if(g_bEnabledVGUI[iClient]==false)
		{
			g_bEnabledVGUI[iClient] = true;
			PrintHintText(iClient, "VGUI Menu Descriptions are now ON.");
		}
		else
		{
			PrintHintText(iClient, "VGUI Menu Descriptions are now OFF.");
			g_bEnabledVGUI[iClient] = false;
		}
	}
	
	return Plugin_Handled;
}

ShowHudOverlayColor(iClient, iRed, iGreen, iBlue, iAlpha, iDuration, iBehavior = FADE_SOLID)
{
	decl clients[1];
	clients[0] = iClient;
	new Handle:message = StartMessageEx(g_umsgFade, clients, 1);
	
	BfWriteShort(message, iDuration);
	BfWriteShort(message, iDuration);
	BfWriteShort(message, iBehavior);
	BfWriteByte(message, iRed);
	BfWriteByte(message, iGreen);
	BfWriteByte(message, iBlue);
	BfWriteByte(message, iAlpha);
	EndMessage();
}

StopHudOverlayColor(iClient)
{
	ShowHudOverlayColor(iClient, 0, 0, 0, 0, 100, FADE_STOP);
}

Action:ShowBindsRemaining(iClient, args)
{
	if(iClient < 1 || IsClientInGame(iClient) == false || IsFakeClient(iClient) == true)
		return;
	
	decl String:strText[64];
	FormatEx(strText, sizeof(strText), "\x05Bind 1: %d Uses Remain\nBind 2: %d Uses Remain", (3 - g_iClientBindUses_1[iClient]), (3 - g_iClientBindUses_2[iClient]));
	PrintToChat(iClient, strText);
}

GiveClientXP(iClient, iAmount, iSprite, iVictim, String:strMessage[64], bool:bCenterText = false, Float:fLifeTime = 3.0)
{
	if(iClient < 1 || IsClientInGame(iClient) == false || IsFakeClient(iClient) == true)
		return;
	
	g_iClientXP[iClient] += iAmount;
	CheckLevel(iClient);
	
	if(g_iXPDisplayMode[iClient] == 0)
		ShowXPSprite(iClient, iSprite, iVictim, fLifeTime);
	else if(g_iXPDisplayMode[iClient] == 1)
	{
		if(bCenterText == false)
			PrintToChat(iClient, "\x03[XPMod] %s You gain %d XP", strMessage, iAmount);
		// else
		// 	PrintCenterText(iClient, "%s You gain %d XP", strMessage, iAmount);
	}	
}


// Note: this actually creates a damage event, so no need to reduce damage here
DealDamage(iVictim, iAttacker, iAmount, iDamageType = DAMAGETYPE_INFECTED_MELEE)
{
	//This function was originally written by AtomikStryker
	decl Float:iVictimPosition[3], String:strDamage[16], String:strDamageType[16], String:strDamageTarget[16];
	
	//GetClientEyePosition(iVictim, iVictimPosition);
	GetEntPropVector(iVictim, Prop_Send, "m_vecOrigin", iVictimPosition);
	IntToString(iAmount, strDamage, sizeof(strDamage));
	IntToString(iDamageType, strDamageType, sizeof(strDamageType));
	Format(strDamageTarget, sizeof(strDamageTarget), "hurtme%d", iVictim);
	
	new entPointHurt = CreateEntityByName("point_hurt");
	if(!entPointHurt)
		return;
	
	// Config, create point_hurt
	DispatchKeyValue(iVictim, "targetname", strDamageTarget);
	DispatchKeyValue(entPointHurt, "DamageTarget", strDamageTarget);
	DispatchKeyValue(entPointHurt, "Damage", strDamage);
	//DispatchKeyValue(entPointHurt, "DamageType", blockreviving ? "65536" : "128");
	DispatchKeyValue(entPointHurt, "DamageType", strDamageType);
	DispatchSpawn(entPointHurt);
	
	// Teleport, activate point_hurt
	TeleportEntity(entPointHurt, iVictimPosition, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(entPointHurt, "Hurt", (iAttacker > 0 && iAttacker <= MaxClients && IsClientInGame(iAttacker)) ? iAttacker : -1);
	
	// Config, delete point_hurt
	DispatchKeyValue(entPointHurt, "classname", "point_hurt");
	DispatchKeyValue(iVictim, "targetname", "null");

	if (entPointHurt > 0 && IsValidEntity(entPointHurt))
		AcceptEntityInput(entPointHurt, "Kill");
}

void ReduceDamageTakenForNewPlayers(int iVictim, int iDmgAmount)
{
	// Reduce damage for low level human survivor players that are not incaped
	if (g_iClientTeam[iVictim] != TEAM_SURVIVORS || 
		g_iClientLevel[iVictim] == 30 || 
		RunClientChecks(iVictim) == false ||
		IsFakeClient(iVictim) || 
		GetEntProp(iVictim, Prop_Send, "m_isIncapacitated") == 1)
		return;

	new iCurrentHealth = GetPlayerHealth(iVictim);
	new iReductionAmount = RoundToNearest(( iDmgAmount * ( NEW_PLAYER_MAX_DAMAGE_REDUCTION * (1.0 - (float(g_iClientLevel[iVictim]) / 30.0)) ) ) );
	//Ensure at least 1 damage is done
	if (iReductionAmount >= iDmgAmount)
		iReductionAmount = iDmgAmount - 1;
	//Dont take more health
	if (iReductionAmount < 1)
		return;

	// new Float:fTempHealth = GetEntDataFloat(iVictim, g_iOffset_HealthBuffer);
	// if(fTempHealth > 0)
	// {
	// 	fTempHealth -= 1.0;
	// 	SetEntDataFloat(iVictim, g_iOffset_HealthBuffer, fTempHealth ,true);
	// }
	// else
	// 	SetPlayerHealth(iVictim, hp - 1);

	// PrintToChatAll("%N iCurrentHealth = %i dmg = %i, reduction %i", iVictim, iCurrentHealth, iDmgAmount, iReductionAmount);
	SetPlayerHealth(iVictim, iCurrentHealth + iReductionAmount);
}

// NOTE: This function is for additional damage, not handling the original damage amount
int CalculateDamageTakenForVictimTalents(int iVictim, int iDmgAmount, const char[] strWeaponClass = "")
{
	if (RunClientChecks(iVictim) == false || 
		IsPlayerAlive(iVictim) == false)
		return 0;
	
	int iDmgReductionOrAddition = 0;

	iDmgReductionOrAddition = CalculateDamageForVictimTalents_Tank_Vampiric(iVictim, iDmgAmount, strWeaponClass);

	return iDmgReductionOrAddition == 0 ? iDmgAmount : iDmgReductionOrAddition;
}

//This function was originally written by AtomikStryker
bool:IsVisibleTo(Float:position[3], Float:targetposition[3])
{
	decl Float:vAngles[3], Float:vLookAt[3];
	
	MakeVectorFromPoints(position, targetposition, vLookAt); // compute vector from start to target
	GetVectorAngles(vLookAt, vAngles); // get angles from vector for trace
	
	// execute Trace
	new Handle:trace = TR_TraceRayFilterEx(position, vAngles, MASK_SHOT, RayType_Infinite, TraceRayTryToHit);
	
	new bool:isVisible = false;
	
	if (TR_DidHit(trace))
	{
		decl Float:vStart[3];
		TR_GetEndPosition(vStart, trace); // retrieve our trace endpoint
		
		if ((GetVectorDistance(position, vStart, false) + 25.0) >= GetVectorDistance(position, targetposition))
		{
			isVisible = true; // if trace ray lenght plus tolerance equal or bigger absolute distance, you hit the target
		}
	}
	//else
	//	isVisible = true;
	
	CloseHandle(trace);
	
	return isVisible;
}

AttachInfected(i_Ent, Float:fOrigin[3])
{
	decl i_InfoEnt, String:s_TargetName[32];
	
	i_InfoEnt = CreateEntityByName("info_goal_infected_chase");
	
	if (IsValidEdict(i_InfoEnt))
	{
		fOrigin[2] += 20.0;
		DispatchKeyValueVector(i_InfoEnt, "origin", fOrigin);
		FormatEx(s_TargetName, sizeof(s_TargetName), "goal_infected%d", i_Ent);
		DispatchKeyValue(i_InfoEnt, "targetname", s_TargetName);
		GetEntPropString(i_Ent, Prop_Data, "m_iName", s_TargetName, sizeof(s_TargetName));
		DispatchKeyValue(i_InfoEnt, "parentname", s_TargetName);
		DispatchSpawn(i_InfoEnt);
		SetVariantString(s_TargetName);
		AcceptEntityInput(i_InfoEnt, "SetParent", i_InfoEnt, i_InfoEnt, 0);
		ActivateEntity(i_InfoEnt);
		AcceptEntityInput(i_InfoEnt, "Enable");
	}

	return i_InfoEnt;
}



/**************************************************************************************************************************
 *                                                     Player Freezing                                                    *
 **************************************************************************************************************************/
 
Action:FreezeGame(admin, args)
{
	g_bGameFrozen = true;
	new String:time[20];
	GetCmdArg(1, time, sizeof(time));
	new freezetime;
	for(new i=1;i<=MaxClients;i++)
	{
		if(RunClientChecks(i) && GetClientTeam(i) == TEAM_SURVIVORS)
		{
			decl Float:vec[3];
			//GetClientAbsOrigin(i, vec);
			//vec[2] += 10;
			GetClientEyePosition(i, vec);
			EmitAmbientSound(SOUND_FREEZE, vec, i, SNDLEVEL_NORMAL);
			SetEntityRenderMode(i, RenderMode:3);
			SetEntityRenderColor(i, 0, 180, 255, 160);
			SetEntDataFloat(i , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.0, true);
			SetEntProp(i, Prop_Data, "m_takedamage", 0, 1);
			new Float:cvec[3];
			cvec[0] = 10.0;
			cvec[1] = 10.0;
			cvec[2] = 10.0;
			g_iClientBindUses_1[i] = 0;
			g_iClientBindUses_2[i] = 0;
			//new gc = FindDataMapInfo(i,"m_glowColor");
			//SetEntDataVector(i, gc, cvec, true);
			//SetEntPropVector(i, Prop_Data, "glowcolor", cvec);
			//DispatchKeyValue(i, "m_glowColor", "0 0 0");
			//m_glowColor (Save|Key)(4 Bytes) - glowcolor
		}
	}
	freezetime = StringToInt(time);
	CreateTimer(float(freezetime), TimerUnfreeze, 0, TIMER_FLAG_NO_MAPCHANGE);
	PrintHintTextToAll("Survivors are frozen for %d more seconds to choose your talents.", freezetime);
}

PlayerFreeze(iClient)
{
	if(IsClientInGame(iClient)==true)
	{
		CreateTimer(0.1, FreezeColor, iClient, TIMER_FLAG_NO_MAPCHANGE);
		SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.0, true);
		SetEntProp(iClient, Prop_Data, "m_takedamage", 0, 1);
	}
	PrintHintText(iClient, "Survivors are temporarily frozen to choose your talents.");
}

/**************************************************************************************************************************
 *                                                     Find Playerrs                                                      *
 **************************************************************************************************************************/


// FindAllPlayers(clients[])
// {
// 	new ctr = 0;
// 	decl i;
// 	for(i = 1;i <= MaxClients;i++)
// 	{
// 		if(IsClientInGame(i))
// 		{
// 			clients[ctr] = i;
// 			ctr++;
// 		}
// 	}
// 	return ctr;
// }

FindPlayerByName(iClient, const String:targetname[])
{
	new String:name[128];
	new i, temp;
	for (i=1;i <= MaxClients;i++)
	{
		if(!IsClientInGame(i))
			continue;
		if(IsFakeClient(i))
			continue;
		GetClientName(i, name, sizeof(name));
		temp = StrContains(name,targetname,false);
		if(temp > -1)
			return i;
	}
	if(iClient==0)
		PrintToServer("[XPMod] Could not find player with %s in their name.", targetname);
	else
		PrintToChat(iClient, "\x03[XPMod] \x01Could not find player with \x04%s \x01in their name.", targetname);
	return -1;
}

CreateRochelleSmoke(iClient)
{
	//Make Smoke Entity
	decl Float:vec[3];
	GetClientAbsOrigin(iClient, vec);
	
	new smoke = CreateEntityByName("env_smokestack");
	
	new String:clientName[128], String:vecString[32];
	Format(clientName, sizeof(clientName), "Smoke%i", iClient);
	Format(vecString, sizeof(vecString), "%f %f %f", vec[0], vec[1], vec[2]);
	
	DispatchKeyValue(smoke,"targetname", clientName);
	DispatchKeyValue(smoke,"Origin", vecString);
	DispatchKeyValue(smoke,"BaseSpread", "0");		//Gap in the middle
	DispatchKeyValue(smoke,"SpreadSpeed", "100");	//Speed the smoke moves outwards
	DispatchKeyValue(smoke,"Speed", "100");			//Speed the smoke moves up
	DispatchKeyValue(smoke,"StartSize", "200");
	DispatchKeyValue(smoke,"EndSize", "250");
	DispatchKeyValue(smoke,"Rate", "15");			//Amount of smoke created
	DispatchKeyValue(smoke,"JetLength", "350");		//Smoke jets outside of the original
	DispatchKeyValue(smoke,"Twist", "30"); 			//Amount of global twisting
	DispatchKeyValue(smoke,"RenderColor", "100 0 255");
	DispatchKeyValue(smoke,"RenderAmt", "255");		//Transparency
	DispatchKeyValue(smoke,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
	
	DispatchSpawn(smoke);
	AcceptEntityInput(smoke, "TurnOn");
	
	CreateTimer(8.0, TimerStopSmokeEntity, smoke, TIMER_FLAG_NO_MAPCHANGE);
}

/**************************************************************************************************************************
 *                                                Reset Player's Render Color and Glow                                                     *
 **************************************************************************************************************************/
 
SetClientRenderAndGlowColor(int iClient)
{
	if (RunClientChecks(iClient) == false || IsPlayerAlive(iClient) ==  false)
		return;

	if (g_bGameFrozen)
		return;

	if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
	{
		switch(g_iChosenSurvivor[iClient] && g_bTalentsConfirmed[iClient])
		{
			case BILL:
			{
				if (g_iGhillieLevel[iClient] > 0)
				{
					// Check and update if bill is grappled or down
					if (IsClientGrappled(iClient) == false && g_bIsClientDown[iClient] == false)
					{					
						// Cloaking Suit values
						new iAlpha = RoundToFloor(255 * (1.0 - (((float(g_iGhillieLevel[iClient]) * 0.13) + ((float(g_iPromotionalLevel[iClient]) * 0.04))))));
						SetClientRenderColor(iClient, 255, 255, 255, iAlpha, RENDER_MODE_TRANSPARENT);
						SetClientGlow(iClient, 1, 0, 0, GLOWTYPE_CONSTANT);
						return;
					}
					else if (IsClientGrappled(iClient) == true || g_bIsClientDown[iClient] == true)
					{
						// Reset to normal rendering
						SetClientRenderColor(iClient);
						SetClientGlow(iClient)
						return;
					}
				}
			}
			case ROCHELLE:
			{
				if(g_bUsingShadowNinja[iClient] == true)
				{
					// Shadow Ninja colors
					new iAlpha = RoundToFloor(255 * (1.0 - (float(g_iShadowLevel[iClient]) * 0.19)));
					SetClientRenderColor(iClient, 255, 255, 255, iAlpha, RENDER_MODE_TRANSPARENT);
					SetClientGlow(iClient, 1, 0, 0, GLOWTYPE_CONSTANT);
					return;
				}
			}
			case ELLIS:
			{
				if(g_bUsingFireStorm[iClient] == true)
				{
					// Fire Storm colors
					SetClientRenderColor(iClient, 210, 88, 30, 255, RENDER_MODE_NORMAL);
					SetClientGlow(iClient, 210, 88, 30, GLOWTYPE_CONSTANT);
					return;
				}
			}
			case NICK:
			{
				if(g_bNickIsInvisible[iClient] == true)
				{
					// Make Nick invisible
					SetClientRenderColor(iClient, 255, 255, 255, 0, RENDER_MODE_TRANSPARENT);
					SetClientGlow(iClient, 1, 0, 0, GLOWTYPE_CONSTANT);
					return;
				}
			}
		}
	}
	else if(g_iClientTeam[iClient] == TEAM_INFECTED && g_bTalentsConfirmed[iClient])
	{
		switch(g_iInfectedCharacter[iClient])
		{
			case HUNTER:
			{
				// Hunter Killmeleon hidden glow and transparency
				// Note, the transisitioning transparency is handled elsewhere, being called frequently
				if((g_iHunterShreddingVictim[iClient] != -1) && (g_iKillmeleonLevel[iClient] >= 5))
				{
					// Hide the glow
					SetClientRenderColor(iClient, 255, 255, 255, 255, RENDER_MODE_TRANSPARENT);
					SetClientGlow(iClient, 1, 0, 0, GLOWTYPE_CONSTANT);
					return;
				}
				else if((g_iHunterShreddingVictim[iClient] == -1) && (g_iKillmeleonLevel[iClient] >= 5))
				{
					// Show the glow
					SetClientRenderColor(iClient);
					SetClientGlow(iClient);
					return;
				}
			}
		}
	}

	// Set to default glow/color, if no other value was set
	SetClientRenderColor(iClient);
	SetClientGlow(iClient);
}

SetClientRenderColor(iClient, iRed = 255, iGreen = 255, iBlue = 255, iAlpha = 255, iRenderMode = RENDER_MODE_NORMAL)
{
	if (IsValidEntity(iClient) == false)
		return;
	
	SetEntityRenderMode(iClient, RenderMode:iRenderMode);
	SetEntityRenderColor(iClient, iRed, iGreen, iBlue, iAlpha);
}

// 0 0 0 and GLOWTYPE_NORMAL sets normal glow
// 1 0 0 and GLOWTYPE_CONSTANT needs to be used to hide glow
SetClientGlow(iClient, iRed = 0, iGreen = 0, iBlue = 0, iGlowType = GLOWTYPE_NORMAL)
{
	if (IsValidEntity(iClient) ==  false)
		return;
	
	SetEntProp(iClient, Prop_Send, "m_iGlowType", iGlowType);
	SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
	SetEntProp(iClient, Prop_Send, "m_glowColorOverride", iRed + (iGreen * 256) + (iBlue * 65536));	
	//ChangeEdictState(iClient, 12);	// This was here before, but not needed
}

/**************************************************************************************************************************
 *                                              Push/Pop Player From Stack                                                *
 **************************************************************************************************************************/

Action:push(iClient)
{
	if(iClient==0)
		return Plugin_Handled;
	if(IsClientInGame(iClient) == false)
		return Plugin_Handled;
	if(g_iFastAttackingClientsArray[0] == iClient)
	{
		g_bSomeoneAttacksFaster = true;				//just in case, shouldnt hurt
		g_bDoesClientAttackFast[iClient] = true;	//...
		for(new i = 0; i<5;i++)
		{
			//PrintToChatAll("g_iFastAttackingClientsArray[%d] = %d", i, g_iFastAttackingClientsArray[i]);		//for debugging
		}
		return Plugin_Handled;
	}
	if(g_iFastAttackingClientsArray[0]==-1)
	{
		g_iFastAttackingClientsArray[0] = iClient;
	}
	else
	{
		new a;
		new bool:done;
		a = 0;
		done = false;
		while(g_iFastAttackingClientsArray[a] != -1 && done==false  && a <= MaxClients)
		{
			if(g_iFastAttackingClientsArray[a] == iClient || g_iFastAttackingClientsArray[a+1] == iClient)
			{
				done = true;
				//PrintToChatAll("iClient already in array");
			}
			if(g_iFastAttackingClientsArray[a+1]==-1)
			{
				if(IsFakeClient(iClient)==false)
				{
					g_iFastAttackingClientsArray[a+1] = iClient;
					done = true;
					//PrintToChatAll("g_iFastAttackingClientsArray[%d] now = %d", (a+1), iClient);
				}
			}
			a++;
		}
	}
	g_bSomeoneAttacksFaster = true;
	g_bDoesClientAttackFast[iClient] = true;
	
	// for(new i = 0; i<5;i++)
	// {
	// 	PrintToChatAll("g_iFastAttackingClientsArray[%d] = %d", i, g_iFastAttackingClientsArray[i]);		//for debugging
	// }
	
	return Plugin_Handled;
}

Action:pop(iClient)
{
	if(iClient==0)
		return Plugin_Handled;
	new a = 0;
	new bool:done = false;
	while(g_iFastAttackingClientsArray[a] != -1 && done ==false  && a <= MaxClients)
	{
		if(g_iFastAttackingClientsArray[a] == iClient)
		{
			done = true;
			//PrintToChatAll("found! It is in array slot %d, iClient = %d", a, iClient);		//for debugging
		}
		a++;
	}
	if(a>0 && done==true)
		while(g_iFastAttackingClientsArray[a-1] != -1 && a <= MaxClients)
		{
			g_iFastAttackingClientsArray[a-1] = g_iFastAttackingClientsArray[a];
			//PrintToChatAll("replacing %d with %d", (a-1), a);			//FOr debuging
			a++;
		}
	//else
		//PrintToChatAll("iClient not found inside the array or a>0");	//for debugging
	
	// for(new i = 0; i<5;i++)
	// {
	// 	PrintToChatAll("popping g_iFastAttackingClientsArray[%d] = %d", i, g_iFastAttackingClientsArray[i]);		//For debugging
	// }
	
	g_bDoesClientAttackFast[iClient] = false;
	
	if(g_iFastAttackingClientsArray[0] == -1)
		g_bSomeoneAttacksFaster = false;
	
	return Plugin_Handled;
}

/**************************************************************************************************************************
 *                                                Play Sounds for Events                                                  *
 **************************************************************************************************************************/

PlayKillSound(iClient)
{
	switch(g_iStat_ClientInfectedKilled[iClient])
	{
		case 1:
		{
			EmitSoundToClient(iClient, SOUND_1KILL);
		}
		case 2:
		{
			EmitSoundToClient(iClient, SOUND_2KILLS);
		}
		case 3:
		{
			EmitSoundToClient(iClient, SOUND_3KILLS);
		}
		case 4:
		{
			EmitSoundToClient(iClient, SOUND_4KILLS);
		}
		case 5:
		{
			EmitSoundToClient(iClient, SOUND_5KILLS);
		}
		case 6:
		{
			EmitSoundToClient(iClient, SOUND_6KILLS);
		}
		case 7:
		{
			EmitSoundToClient(iClient, SOUND_7KILLS);
		}
		case 8:
		{
			EmitSoundToClient(iClient, SOUND_8KILLS);
		}
		case 9:
		{
			EmitSoundToClient(iClient, SOUND_9KILLS);
		}
		case 10:
		{
			EmitSoundToClient(iClient, SOUND_10KILLS);
		}
		case 11:
		{
			EmitSoundToClient(iClient, SOUND_11KILLS);
		}
		case 12:
		{
			EmitSoundToClient(iClient, SOUND_12KILLS);
		}
		case 13:
		{
			EmitSoundToClient(iClient, SOUND_13KILLS);
		}
		case 14:
		{
			EmitSoundToClient(iClient, SOUND_14KILLS);
		}
		case 15:
		{
			EmitSoundToClient(iClient, SOUND_15KILLS);
		}
		default:
		{
			EmitSoundToClient(iClient, SOUND_16KILLS);
		}
	}
}

PlayHeadshotSound(iClient)
{
	decl random;
	random = GetRandomInt(1,3);
	switch(random)
	{
		case 1:
		{
			EmitSoundToClient(iClient, SOUND_HEADSHOT1);
		}
		case 2:
		{
			EmitSoundToClient(iClient, SOUND_HEADSHOT2);
		}
		case 3:
		{
			EmitSoundToClient(iClient, SOUND_HEADSHOT3);
		}
	}
	g_bCanPlayHeadshotSound[iClient] = false;
}

/**************************************************************************************************************************
 *                                                      Trace Filters                                                     *
 **************************************************************************************************************************/

bool:TraceRayTryToHit(entity,mask)
{
	if((entity > 0) && (entity <= 64))	// Check if the beam hit a player and tell it to keep tracing if it did
		return false;
	
	return true;
}

// bool:TraceRayGrabEnt(entity,mask)
// {
// 	if(entity > 0)	// Check if the beam hit an entity other than the grabber, and stop if it does
// 	{
// 		if((entity <= 64) && (!g_bUsingTongueRope[entity]))
// 			return true;
// 		if(entity > 64)
// 			return true;
// 	}
	
// 	return false;
// }

bool:TraceRayDontHitSelf(entity, mask, any:data)
{
    if(entity == data)	// Check if the TraceRay hit the itself.
        return false;	// Don't let the entity be hit
		
    return true;		// It didn't hit itself
}


bool IsClientGrappled(iClient)
{
	if (g_bChargerCarrying[iClient] == true || 
		g_bChargerGrappled[iClient] == true || 
		g_bSmokerGrappled[iClient] == true || 
		g_bJockeyGrappled[iClient] == true || 
		g_bHunterGrappled[iClient] == true)
	{
		DebugLog(DEBUG_MODE_VERBOSE, "IsClientGrappled(%N): true", iClient);
		return true;
	}
		
	DebugLog(DEBUG_MODE_VERBOSE, "IsClientGrappled(%N): false", iClient);
	return false;
}

// bool:IsJockeyGrappled(iClient)
// {
// 	decl i;
// 	for(i = 0; i <= MaxClients; i++)
// 		if(g_iJockeyVictim[i] == iClient)
// 			return true;
	
// 	return false;
// }

Action:OpenHelpMotdPanel(iClient, args)
{
	OpenMOTDPanel(iClient, "", "http://xpmod.net/help/xpmod_ig_help.html", MOTDPANEL_TYPE_URL);
	return Plugin_Handled;
}

int FindIndexInArrayListUsingValue(ArrayList list, iValueToFind, iColumn=0)
{
	if (list == INVALID_HANDLE)
		return -1;

	for (int i=0; i < list.Length; i++)
	{
		new currentValue = list.Get(i, iColumn);
		if (currentValue == iValueToFind)
			return i;
	}

	return -1;
}

bool IsEntityUncommonInfected(iInfectedEntity)
{
	// Get the infected entity type (common or uncommon)
	decl String:strClassname[99];
	GetEdictClassname(iInfectedEntity, strClassname, sizeof(strClassname));
	//PrintToChatAll("edict classname: %s", strClassname);
	if (StrEqual(strClassname, "infected", true) == false)
		return false;

	// Get the infected model name
	new String:strModelName[128];
	GetEntPropString(iInfectedEntity, Prop_Data, "m_ModelName", strModelName, 128);

	// Check if the model name corresponds to an uncommon one
	for (new i; i < sizeof(UNCOMMON_INFECTED_MODELS); i++)
	{
		//PrintToChatAll("CHECKING %s", UNCOMMON_INFECTED_MODELS[i]);
		if (StrEqual(strModelName, UNCOMMON_INFECTED_MODELS[i], false))
			return true;
	}

	return false;		
}

// float FindClosestSurvivorDistance(iClient)
// {
// 	if (RunClientChecks(iClient) == false)
// 		return 999999.0;

// 	new Float:fdistance = 999999.0;
// 	decl Float:xyzClientOrigin[3], Float:xyzTargetOrigin[3];
// 	GetClientEyePosition(iClient, xyzClientOrigin);	//Get clients location origin vectors

// 	// Check if the model name corresponds to an uncommon one
// 	for (new iTarget; iTarget <= MaxClients; iTarget++)
// 	{
// 		if (RunClientChecks(iTarget) && g_iClientTeam[iTarget] == TEAM_SURVIVORS)
// 		{
// 			GetClientEyePosition(iTarget, xyzTargetOrigin);
// 			new Float:fNewDistance = GetVectorDistance(xyzTargetOrigin, xyzClientOrigin);
// 			//PrintToChatAll("Checking: %N -> %f", iTarget, fNewDistance);
// 			if (fNewDistance < fdistance)
// 				fdistance = fNewDistance;
// 		}
// 	}

// 	//PrintToChatAll("FindClosestSurvivorDistance %f", fdistance);
// 	return fdistance;		
// }

void GetLocationVectorInfrontOfClient(iClient, Float:xyzLocation[3], Float:xyzAngles[3], Float:fForwardOffset = 40.0, Float:fVerticleOffset = 1.0)
{
	decl Float:vDirection[3];

	GetClientEyeAngles(iClient, xyzAngles);							// Get clients Eye Angles to know get what direction face
	GetAngleVectors(xyzAngles, vDirection, NULL_VECTOR, NULL_VECTOR);	// Get the direction the iClient is looking
	xyzAngles[0] = 0.0;	//Lock x and z axis, in other words, only do rotation as if a person is standing up and turning
	xyzAngles[2] = 0.0;

	GetClientAbsOrigin(iClient, xyzLocation);		// Get Clients location origin vectors
	xyzLocation[0] += (vDirection[0] * fForwardOffset);	// Offset x and y a bit forward of the players view
	xyzLocation[1] += (vDirection[1] * fForwardOffset);
	xyzLocation[2] += vDirection[2] + fVerticleOffset;			// Raise it up slightly to prevent glitches
}

 
/**************************************************************************************************************************/

// bool DidClientMoveEyesOrPosition(iClient)
// {
// 	if (!RunClientChecks(iClient))
// 		return true;

// 	decl Float:currentvorigin[3], Float:currentvangles[3];
// 	GetClientEyePosition(iClient, currentvorigin);	//Get clients location origin vectors
// 	GetClientEyeAngles(iClient, currentvangles);	//Get clients Eye Angles
// 	PrintToServer("currentvorigin %f, %f, %f", currentvorigin[0], currentvorigin[1], currentvorigin[2]);
// 	PrintToServer("currentvangles %f, %f, %f", currentvangles[0], currentvangles[1], currentvangles[2]);

// 	// Set a minimum threshold that must be passed in order to trigger a move
// 	new Float:vOriginMovementThreshold = 30.0;
// 	new Float:vAnglesmovementThreshold = 20.0;

// 	if (FloatAbs(currentvorigin[0] - g_xyzClientVOrigin[iClient][0]) > vOriginMovementThreshold ||
// 		FloatAbs(currentvorigin[1] - g_xyzClientVOrigin[iClient][1]) > vOriginMovementThreshold ||
// 		FloatAbs(currentvorigin[2] - g_xyzClientVOrigin[iClient][2]) > vOriginMovementThreshold) //||
// 		//FloatAbs(currentvangles[0] - g_xyzClientVAngles[iClient][0]) > vAnglesmovementThreshold ||
// 		//FloatAbs(currentvangles[1] - g_xyzClientVAngles[iClient][1]) > vAnglesmovementThreshold)
// 		return true;

// 	return false;
// }



// Setting a really high positive value will cause the ability to never cooldown. Abilties can be used to deactivate with this.
// Setting a negative value will subtract time (seconds) away from the cooldown.  Setting a value to the existing game time 
// will cause an instant cooldown allowing for the abilty to be used instantly (bCalculateFromCurrentGameTime true & fTimeToWait 0)
// Note: The game is going to do a comparison of fNextActivationGameTime and the game time to see if
// this ability is in cooldown. So if fNextActivationGameTime was previously set to a high value, use 
// bCalculateFromCurrentGameTime to switch the mode the activate + or - from the current game time instead.
SetSIAbilityCooldown(iClient, Float:fTimeToWait = 0.0, bool bCalculateFromCurrentGameTime = true)
{
	if (RunClientChecks(iClient)== false || 
		IsPlayerAlive(iClient) == false || 
		g_iClientTeam[iClient] != TEAM_INFECTED)
		return;

	new iEntID = GetEntDataEnt2(iClient, g_iOffset_CustomAbility);
	if (!IsValidEntity(iEntID))
		return;

	// Get the actual cooldown wait period, this is the next activation game time at which the ability will be activated once reached
	new Float:fNextActivationGameTime = GetEntDataFloat(iEntID, g_iOffset_NextActivation + 8);
	new Float:fGameTime = GetGameTime();
	//PrintToChatAll("PRE fNextActivationGameTime: %f, GetGameTime() %f", fNextActivationGameTime, fGameTime);

	// Calculate the new ability activation game time
	decl Float:fNewNextActivationGameTime;
	// If bCalculateFromCurrentGameTime, then the coder wants to calc next activation starting with the current game time
	if (bCalculateFromCurrentGameTime)
		fNewNextActivationGameTime = fGameTime + fTimeToWait;
	// If its false, then set it to new activation starting with the existing next activation + or - time to wait
	else
		fNewNextActivationGameTime = fNextActivationGameTime + fTimeToWait;
	
	SetEntDataFloat(iEntID, g_iOffset_NextActivation + 8, fNewNextActivationGameTime, true);

	//PrintToChatAll("POST fNextActivationGameTime: %f, GetGameTime()%f", fNewNextActivationGameTime, GetGameTime());
}