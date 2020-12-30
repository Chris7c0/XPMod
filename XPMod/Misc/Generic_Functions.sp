//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////        MISCELLANEOUS FUNCTIONS       //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**************************************************************************************************************************
 *                                                Show XPMod Info To Server                                               *
 **************************************************************************************************************************/
 
public ShowXPModInfoToServer()
{
	PrintToServer(":---------<|============================================|>---------:");
	PrintToServer(":---------<|                XP Mod %s              |>---------:", PLUGIN_VERSION);
	PrintToServer(":---------<|============================================|>---------:");
	PrintToServer(":---------<| Created by: Chris Pringle & Ezekiel Keener |>---------:");
	PrintToServer(":---------<|============================================|>---------:");
}

bool RunClientChecks(int iClient)
{
	if (iClient < 1 || (IsValidEntity(iClient) == false) || (IsClientInGame(iClient) == false))
		return false;

	return true;
}

bool RunEntityChecks(iEnt)
{
	if (iEnt < 0 || (IsValidEntity(iEnt) == false))
		return false;

	return true;
}

public Action:Timer_ShowXPModInfoToServer(Handle:timer, any:data)
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
	if(IsClientInGame(iClient) == false)
		return;
	if(IsFakeClient(iClient) == true)
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

public Action:MotdPanel(iClient,args)
{
	
	//OpenMOTDPanel(iClient, "Choose Your Survivor", "addons/sourcemod/plugins/xpmod/XPMod Website - InGame/Home/xpmod_ig_home.html", MOTDPANEL_TYPE_FILE);
	OpenMOTDPanel(iClient, "XPMod Website", "http://xpmod.net", MOTDPANEL_TYPE_URL);
	return;
}

//Probe Teams for Real Players.   Returns true if there is a non-bot player on inputed team
public bool:ProbeTeams(team)
{
	for(new i = 1; i<MaxClients; i++)
		if(IsClientInGame(i))
			if(!IsFakeClient(i))
				if(g_iClientTeam[i] == team)
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
		for (i=1;i<MaxClients;i++)
			if ((IsClientInGame(i))&&(!IsFakeClient(i))&&(GetClientTeam(i)==2))
				count++;
	}
	else if (team == 3) // we count the players in the infected's team
	{
		max = GetConVarInt(FindConVar("z_max_player_zombies"));
		count = 0;
		for (i=1;i<MaxClients;i++)
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
public Action:ToggleAnnouncerVoice(iClient,args)	//Toggles the announcers voice
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

public Action:ToggleVGUIDesc(iClient,args)	//Toggles the vgui menu descriptions for talents
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

public Action:ShowBindsRemaining(iClient, args)
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
		else
			PrintCenterText(iClient, "%s You gain %d XP", strMessage, iAmount);
	}	
}

public bool:IsClientGrappled(iClient)
{
	if(g_bHunterGrappled[iClient] == true || g_bChargerGrappled[iClient] == true || g_bSmokerGrappled[iClient] == true || IsJockeyGrappled(iClient) == true)
		return true;
	
	return false;
}

public bool:IsJockeyGrappled(iClient)
{
	decl i;
	for(i = 0; i < MaxClients; i++)
		if(g_iJockeyVictim[i] == iClient)
			return true;
	
	return false;
}


MolotovExplode(Float:xyzLocation[3])
{
	xyzLocation[2] += 5.0;
	
	new iEntity = CreateEntityByName("prop_physics");
	if(IsValidEntity(iEntity) == false)
		return;
	
	DispatchKeyValue(iEntity, "model", "models/props_junk/gascan001a.mdl");
	DispatchSpawn(iEntity);
	
	SetEntData(iEntity, GetEntSendPropOffs(iEntity, "m_CollisionGroup"), 1, 1, true);
	TeleportEntity(iEntity, xyzLocation, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(iEntity, "Break");
}

PropaneExplode(Float:xyzLocation[3])
{
	xyzLocation[2] += 5.0;
	
	new iEntity = CreateEntityByName("prop_physics");
	if(IsValidEntity(iEntity) == false)
		return;
	
	DispatchKeyValue(iEntity, "model", "models/props_junk/propanecanister001a.mdl");
	DispatchSpawn(iEntity);
	
	SetEntData(iEntity, GetEntSendPropOffs(iEntity, "m_CollisionGroup"), 1, 1, true);
	TeleportEntity(iEntity, xyzLocation, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(iEntity, "Break");
}

DealDamage(iVictim, iAttacker, iAmount, iDamageType = DAMAGETYPE_INFECTED_MELEE)
{
	//This function was originally written by AtomikStryker
	decl Float:iVictimPosition[3], String:strDamage[16], String:strDamageType[16], String:strDamageTarget[16];
	
	GetClientEyePosition(iVictim, iVictimPosition);		
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
	AcceptEntityInput(entPointHurt, "Hurt", (iAttacker > 0 && iAttacker < MaxClients && IsClientInGame(iAttacker)) ? iAttacker : -1);
	
	// Config, delete point_hurt
	DispatchKeyValue(entPointHurt, "classname", "point_hurt");
	DispatchKeyValue(iVictim, "targetname", "null");
	RemoveEdict(entPointHurt);
	///////////////////////////////////////////////////////////////////////
}

//This function was originally written by AtomikStryker
public bool:IsVisibleTo(Float:position[3], Float:targetposition[3])
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

public AttachInfected(i_Ent, Float:fOrigin[3])
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
 
public Action:FreezeGame(admin, args)
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

public PlayerFreeze(iClient)
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


public FindAllPlayers(clients[])
{
	new ctr = 0;
	decl i;
	for(i = 1;i <= MaxClients;i++)
	{
		if(IsClientInGame(i))
		{
			clients[ctr] = i;
			ctr++;
		}
	}
	return ctr;
}

FindPlayerByName(iClient, const String:targetname[])
{
	new String:name[128];
	new i, temp;
	for (i=1;i < MaxClients;i++)
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
 *                                                Reset Surivor's Speed                                                   *
 **************************************************************************************************************************/
/* 
ResetSurvivorSpeed(iClient)
{
	if(iClient < 1 || g_iClientTeam[iClient] != TEAM_SURVIVORS || IsClientInGame(iClient) == false)
		return;
	
	if(IsFakeClient(iClient) == true)
	{
		SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0, true);
	}
	else 
	{
		switch(g_iChosenSurvivor[iClient])
		{
			case BILL:
			{
				if(g_bBillSprinting[iClient])
					SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 2.0, true);
				else
					SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0, true);
			}
			case ROCHELLE:
			{
				if(g_bUsingShadowNinja[iClient] == true)
					SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iShadowLevel[iClient] * 0.12) + (g_iSniperLevel[iClient] * 0.02) + (g_iHunterLevel[iClient] * 0.02)), true);
				else
					SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iHunterLevel[iClient] * 0.02) + (g_iSniperLevel[iClient] * 0.02) + (g_iShadowLevel[iClient] * 0.02)), true);
			}
			case COACH:
			{
				SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 - (g_iBullLevel[iClient] * 0.03)), true);
			}
			case ELLIS:
			{
				//Check if there is a tank in game and alive for Ellis's speed boost
				for(new iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
				{
					if(g_iClientTeam[iPlayer] == TEAM_INFECTED && IsClientInGame(iPlayer) == true && 
						IsPlayerAlive(iPlayer) == true && GetEntProp(iPlayer, Prop_Send, "m_zombieClass") == TANK)
					{
						SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iJamminLevel[iClient] * 0.08)), true);
						return;
					}
				}
				
				SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iClient] + g_fEllisBringSpeed[iClient] + g_fEllisOverSpeed[iClient]), true);
				//DeleteCode
				//PrintToChatAll("All speeds are being reset");
				//PrintToChatAll("g_fEllisJamminSpeed = %f", g_fEllisJamminSpeed[iClient]);
				//PrintToChatAll("g_fEllisBringSpeed = %f", g_fEllisBringSpeed[iClient]);
				//PrintToChatAll("g_fEllisOverSpeed = %f", g_fEllisOverSpeed[iClient]);
			}
			case NICK:
			{
				SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iMagnumLevel[iClient] * 0.03) + (float(g_iNickDesperateMeasuresStack) * float(g_iDesperateLevel[iClient]) * 0.02)), true);
			}
		}
	}	
}
*/

/**************************************************************************************************************************
 *                                                Reset Player's Glow                                                     *
 **************************************************************************************************************************/
 
fnc_SetRendering(int iClient)
{
	if (RunClientChecks(iClient) == false)
		return;

	new iGlowType = 0, iGlowColor = 0, iRenderMode = 0, iRed = 255, iGreen = 255, iBlue = 255, iAlpha = 255;
	if(g_bGameFrozen == false && g_bTalentsConfirmed[iClient] == true)
	{
		if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
		{
			switch(g_iChosenSurvivor[iClient])
			{
				case 0:		//Bill
				{
					fnc_CheckGrapple(iClient);
					//PrintToChatAll("Calling FNC g_bIsClientGrappled = %s", g_bIsClientGrappled[iClient]);
					//PrintToChatAll("Calling FNC g_bIsClientGrappled = %i", g_bIsClientGrappled[iClient]);
					if(g_bIsClientGrappled[iClient] == false && g_bIsClientDown[iClient] == false)
					{
						//PrintToChatAll("g_bIsClientGrappled[iClient] == false && g_bIsClientDown[iClient] == false");
						iGlowType = 3;
						iGlowColor = 1;
						iRenderMode = 3;
						iAlpha = RoundToFloor(255 * (1.0 - (((float(g_iGhillieLevel[iClient]) * 0.13) + ((float(g_iPromotionalLevel[iClient]) * 0.04))))));
					}
					else if(g_bIsClientGrappled[iClient] == true || g_bIsClientDown[iClient] == true)
					{
						//PrintToChatAll("g_bIsClientGrappled[iClient] == true || g_bIsClientDown[iClient] == true");
						iGlowType = 0;
						iGlowColor = 0;
						iRenderMode = 0;
						iAlpha = 255;
					}
				}
				case 1:		//Rochelle
				{
					if(g_bUsingShadowNinja[iClient] == true)
					{
						iGlowType = 3;
						iGlowColor = 1;
						iRenderMode = 3;
						iRed = 0; iGreen = 0; iBlue = 0;
						iAlpha = RoundToFloor(255 * (1.0 - (float(g_iShadowLevel[iClient]) * 0.19)));
					}
				}
				case 2:		//Coach
				{
					//Coach doesnt have any glow stuff
				}
				case 3:		//Ellis
				{
					if(g_bUsingFireStorm[iClient] == true)
					{
						iGlowType = 2;
						iGlowColor = 255;
						iRenderMode = 3;
						iRed = 210; iGreen = 88; iBlue = 30; iAlpha = 255;
					}
				}
				case 4:		//Nick
				{
					if(g_bNickIsInvisible[iClient] == true)
					{
						iGlowType = 3;
						iGlowColor = 1;
						iRenderMode = 3;
						iAlpha = 0;
					}
				}
			}
		}
		else if(g_iClientTeam[iClient] == TEAM_INFECTED)
		{
			switch(g_iInfectedCharacter[iClient])
			{
				case 3: //Hunter
				{
					if((g_iHunterShreddingVictim[iClient] != -1) && (g_iKillmeleonLevel[iClient] >= 5))
					{
						iGlowType = 3;
						iGlowColor = 1;
						iRenderMode = 3;
					}
					else if((g_iHunterShreddingVictim[iClient] == -1) && (g_iKillmeleonLevel[iClient] >= 5))
					{
						iGlowType = 0;
						iGlowColor = 0;
						iRenderMode = 0;
					}
				}
			}
		}
	}
	SetEntProp(iClient, Prop_Send, "m_iGlowType", iGlowType);
	SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
	SetEntProp(iClient, Prop_Send, "m_glowColorOverride", iGlowColor);
	ChangeEdictState(iClient, 12);
	SetEntityRenderMode(iClient, RenderMode:iRenderMode);
	SetEntityRenderColor(iClient, iRed, iGreen, iBlue, iAlpha);
}
/*
ResetGlow(iClient)
{
	if(iClient < 0)
		return;
	if(IsClientInGame(iClient) == false)
		return;
	
	new glowtype = 0, glowcolor = 0, rendermode = 0, r = 255, g = 255, b = 255, a = 255;
	
	if(IsFakeClient(iClient) == false)
	{
		if(g_bGameFrozen == false && g_bTalentsConfirmed[iClient] == true)
		{
			if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
			{
				switch(g_iChosenSurvivor[iClient])
				{
					case 0:		//Bill
					{
						glowtype = 3;
						glowcolor = 1;
						rendermode = 3;
						a = RoundToFloor(255 * (1.0 - (((float(g_iGhillieLevel[iClient]) * 0.13) + ((float(g_iPromotionalLevel[iClient]) * 0.04))))));
					}
					case 1:		//Rochelle
					{
						if(g_bUsingShadowNinja[iClient] == true)
						{
							glowtype = 3;
							glowcolor = 1;
							rendermode = 3;
							r = g = b = 0;
							a = RoundToFloor(255 * (1.0 - (float(g_iShadowLevel[iClient]) * 0.19)));
						}
					}
					case 2:		//Coach
					{
						//Coach doesnt have any glow stuff
					}
					case 3:		//Ellis
					{
						if(g_bUsingFireStorm[iClient] == true)
						{
							glowtype = 2;
							glowcolor = 255;
							rendermode = 3;
							r = 210; g = 88; b = 30; a = 255;
						}
					}
					case 4:		//Nick
					{
						if(g_bNickIsInvisible[iClient] == true)
						{
							glowtype = 3;
							glowcolor = 1;
							rendermode = 3;
							a = 0;
						}
					}
				}
			}
		}
		//else if(g_iClientTeam[iClient] == TEAM_INFECTED)	Not needed yet
		//{
		//}
	}
	
	SetEntProp(iClient, Prop_Send, "m_iGlowType", glowtype);
	SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
	SetEntProp(iClient, Prop_Send, "m_glowColorOverride", glowcolor);
	ChangeEdictState(iClient, 12);
	SetEntityRenderMode(iClient, RenderMode:rendermode);
	SetEntityRenderColor(iClient, r, g, b, a);
}
*/

/**************************************************************************************************************************
 *                                              Push/Pop Player From Stack                                                *
 **************************************************************************************************************************/

public Action:push(iClient, args)
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
		while(g_iFastAttackingClientsArray[a] != -1 && done==false  && a<MAXPLAYERS)
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

public Action:pop(iClient, args)
{
	if(iClient==0)
		return Plugin_Handled;
	new a = 0;
	new bool:done = false;
	while(g_iFastAttackingClientsArray[a] != -1 && done ==false  && a<MAXPLAYERS)
	{
		if(g_iFastAttackingClientsArray[a] == iClient)
		{
			done = true;
			//PrintToChatAll("found! It is in array slot %d, iClient = %d", a, iClient);		//for debugging
		}
		a++;
	}
	if(a>0 && done==true)
		while(g_iFastAttackingClientsArray[a-1] != -1 && a<MAXPLAYERS)
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

public bool:TraceRayTryToHit(entity,mask)
{
	if((entity > 0) && (entity <= 64))	// Check if the beam hit a player and tell it to keep tracing if it did
		return false;
	
	return true;
}

public bool:TraceRayGrabEnt(entity,mask)
{
	if(entity > 0)	// Check if the beam hit an entity other than the grabber, and stop if it does
	{
		if((entity <= 64) && (!g_bUsingTongueRope[entity]))
			return true;
		if(entity > 64)
			return true;
	}
	
	return false;
}

public bool:TraceRayDontHitSelf(entity, mask, any:data)
{
    if(entity == data)	// Check if the TraceRay hit the itself.
        return false;	// Don't let the entity be hit
		
    return true;		// It didn't hit itself
}

/**************************************************************************************************************************
 *                                                      Determine Primary Information                                     *
 **************************************************************************************************************************/

fnc_DeterminePrimaryWeapon(iClient)
{	
	GetClientWeapon(iClient, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
	if((StrEqual(g_strCurrentWeapon, "weapon_melee", false) == false) && (StrEqual(g_strCurrentWeapon, "weapon_pistol", false) == false) && (StrEqual(g_strCurrentWeapon, "weapon_pistol_magnum", false) == false))
	{
		//decl String:currentweapon[512];
		//GetClientWeapon(iClient, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
		//PrintToChatAll("Current Weapon is %s & weapon is not melee/pistol/magnum", g_strCurrentWeapon);

		g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
		//PrintToChatAll("g_iPrimarySlotID = %d", g_iPrimarySlotID[iClient]);
		if (g_iPrimarySlotID[iClient] > -1) g_iCurrentClipAmmo[iClient] = GetEntProp(g_iPrimarySlotID[iClient],Prop_Data,"m_iClip1");
		
		if((StrEqual(g_strCurrentWeapon, "weapon_rifle", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_rifle_ak47", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_rifle_sg552", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_rifle_desert", false) == true))
		{
			g_iAmmoOffset[iClient] = 12;
		}
		else if((StrEqual(g_strCurrentWeapon, "weapon_smg", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_smg_mp5", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_smg_silenced", false) == true))
		{
			g_iAmmoOffset[iClient] = 20;
		}
		else if((StrEqual(g_strCurrentWeapon, "weapon_pumpshotgun", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_shotgun_chrome", false) == true))
		{
			g_iAmmoOffset[iClient] = 28;
		}
		else if((StrEqual(g_strCurrentWeapon, "weapon_autoshotgun", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_shotgun_spas", false) == true))
		{
			g_iAmmoOffset[iClient] = 32;
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_hunting_rifle", false) == true)
		{
			g_iAmmoOffset[iClient] = 36;
		}
		else if((StrEqual(g_strCurrentWeapon, "weapon_sniper_military", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_sniper_awp", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_sniper_scout", false) == true))
		{
			g_iAmmoOffset[iClient] = 40;
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_grenade_launcher", false) == true)
		{
			g_iAmmoOffset[iClient] = 68;
		}
		else
		{
			g_iAmmoOffset[iClient] = 0;
		}
		//PrintToChatAll("g_iAmmoOffset = %d", g_iAmmoOffset[iClient]);
		
		
		g_iOffset_Ammo[iClient] = FindDataMapInfo(iClient,"m_iAmmo");
		//DONT FORGET THIS "g_iReserveAmmo" variable is here!
		g_iReserveAmmo[iClient] = GetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient]);
		//PrintToChatAll("g_iReserveAmmo = %d", g_iReserveAmmo[iClient]);
		//DONT FORGET THIS "g_iReserveAmmo" variable is here!
		
		
		if(StrEqual(g_strCurrentWeapon, "weapon_rifle", false) == true)
		{
			g_strCurrentWeaponCmdName = "rifle";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_ak47", false) == true)
		{
			g_strCurrentWeaponCmdName = "rifle_ak47";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_sg552", false) == true)
		{
			g_strCurrentWeaponCmdName = "rifle_sg552";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_desert", false) == true)
		{
			g_strCurrentWeaponCmdName = "rifle_desert";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_smg", false) == true)
		{
			g_strCurrentWeaponCmdName = "smg";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_smg_mp5", false) == true)
		{
			g_strCurrentWeaponCmdName = "smg_mp5";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_smg_silenced", false) == true)
		{
			g_strCurrentWeaponCmdName = "smg_silenced";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_pumpshotgun", false) == true)
		{
			g_strCurrentWeaponCmdName = "pumpshotgun";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_shotgun_chrome", false) == true)
		{
			g_strCurrentWeaponCmdName = "shotgun_chrome";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_autoshotgun", false) == true)
		{
			g_strCurrentWeaponCmdName = "autoshotgun";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_shotgun_spas", false) == true)
		{
			g_strCurrentWeaponCmdName = "shotgun_spas";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_hunting_rifle", false) == true)
		{
			g_strCurrentWeaponCmdName = "hunting_rifle";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_sniper_military", false) == true)
		{
			g_strCurrentWeaponCmdName = "sniper_military";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_sniper_awp", false) == true)
		{
			g_strCurrentWeaponCmdName = "sniper_awp";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_sniper_scout", false) == true)
		{
			g_strCurrentWeaponCmdName = "sniper_scout";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_grenade_launcher", false) == true)
		{
			g_strCurrentWeaponCmdName = "grenade_launcher";
		}
		else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_m60", false) == true)
		{
			g_strCurrentWeaponCmdName = "rifle_m60";
		}
		//PrintToChatAll("g_strCurrentWeaponCmdName = %s", g_strCurrentWeaponCmdName);
		if(g_iEllisCurrentPrimarySlot[iClient] == 0)
		{
			g_strEllisPrimarySlot1 = g_strCurrentWeapon;
		}
		else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
		{
			g_strEllisPrimarySlot2 = g_strCurrentWeapon;
		}
	}
}
 
fnc_SaveAmmo(iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			GetClientWeapon(iClient, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
			if((StrEqual(g_strCurrentWeapon, "weapon_melee", false) == false) && (StrEqual(g_strCurrentWeapon, "weapon_pistol", false) == false) && (StrEqual(g_strCurrentWeapon, "weapon_pistol_magnum", false) == false))
			{
				if(g_iEllisCurrentPrimarySlot[iClient] == 0)
				{
					g_iEllisPrimarySavedClipSlot1[iClient] = g_iCurrentClipAmmo[iClient];
					g_iEllisPrimarySavedAmmoSlot1[iClient] = g_iReserveAmmo[iClient];
					//PrintToChatAll("Saving upgrade ammo to variable");
					g_iEllisUpgradeAmmoSlot1[iClient] = GetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
					//PrintToChatAll("Amount to save is %d", g_iEllisUpgradeAmmoSlot1[iClient]);
					if(g_iEllisUpgradeAmmoSlot1[iClient] == 0)
					{
						//PrintToChatAll("Upgrade slot is equal to 0, setting strings to empty");
						g_strEllisUpgradeTypeSlot1 = "empty";
						g_strCurrentAmmoUpgrade = "empty";
					}
					else
					{
						//PrintToChatAll("Upgrade slot is great than 0, setting Type Slot to g_strCurrentAmmoUpgrade");
						g_strEllisUpgradeTypeSlot1 = g_strCurrentAmmoUpgrade;
						//PrintToChatAll("g_strEllisUpgradeTypeSlot1 = %s", g_strEllisUpgradeTypeSlot1);
					}
					//PrintToChatAll("g_iEllisPrimarySavedClipSlot1 = %d", g_iEllisPrimarySavedClipSlot1[iClient]);
					//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot1 = %d", g_iEllisPrimarySavedAmmoSlot1[iClient]);
					//PrintToChatAll("fnc_SaveAmmo: Slot = %i, Clip1 = %i, Ammo1 = %i, Upgrade1 = %s", g_iEllisCurrentPrimarySlot[iClient], g_iEllisPrimarySavedClipSlot1[iClient], g_iEllisPrimarySavedAmmoSlot1[iClient], g_strEllisUpgradeTypeSlot1);
				}
				else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
				{
					g_iEllisPrimarySavedClipSlot2[iClient] = g_iCurrentClipAmmo[iClient];
					g_iEllisPrimarySavedAmmoSlot2[iClient] = g_iReserveAmmo[iClient];
					//PrintToChatAll("Saving upgrade ammo to variable");
					g_iEllisUpgradeAmmoSlot2[iClient] = GetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
					//PrintToChatAll("Amount to save is %d", g_iEllisUpgradeAmmoSlot2[iClient]);
					if(g_iEllisUpgradeAmmoSlot2[iClient] == 0)
					{
						//PrintToChatAll("Upgrade slot is equal to 0, setting strings to empty");
						g_strEllisUpgradeTypeSlot2 = "empty";
						g_strCurrentAmmoUpgrade = "empty";
					}
					else
					{
						//PrintToChatAll("Upgrade slot is great than 0, setting Type Slot to g_strCurrentAmmoUpgrade");
						g_strEllisUpgradeTypeSlot2 = g_strCurrentAmmoUpgrade;
						//PrintToChatAll("g_strEllisUpgradeTypeSlot2 = %s", g_strEllisUpgradeTypeSlot2);
					}
					//PrintToChatAll("g_iEllisPrimarySavedClipSlot2 = %d", g_iEllisPrimarySavedClipSlot2[iClient]);
					//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot2 = %d", g_iEllisPrimarySavedAmmoSlot2[iClient]);
					//PrintToChatAll("fnc_SaveAmmo: Slot = %i, Clip2 = %i, Ammo2 = %i, Upgrade2 = %s", g_iEllisCurrentPrimarySlot[iClient], g_iEllisPrimarySavedClipSlot2[iClient], g_iEllisPrimarySavedAmmoSlot2[iClient], g_strEllisUpgradeTypeSlot2);
				}
				//PrintToChatAll("g_iCurrentClipAmmo = %d", g_iCurrentClipAmmo[iClient]);
				//PrintToChatAll("g_iReserveAmmo = %d", g_iReserveAmmo[iClient]);
			}
		}
		case 4:		//Nick
		{
			g_strNickPrimarySaved = g_strCurrentWeaponCmdName;
			//PrintToChatAll("Saved g_strNickPrimarySaved = %s", g_strNickPrimarySaved);
			g_iNickPrimarySavedClip[iClient] = g_iCurrentClipAmmo[iClient];
			//PrintToChatAll("Saved g_iNickPrimarySavedClip = %d", g_iNickPrimarySavedClip[iClient]);
			g_iNickPrimarySavedAmmo[iClient] = g_iReserveAmmo[iClient];
			//PrintToChatAll("Saved g_iNickPrimarySavedAmmo = %d", g_iNickPrimarySavedAmmo[iClient]);
			//PrintToChatAll("Saving upgrade ammo to variable");
			g_iNickUpgradeAmmo[iClient] = GetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
			//PrintToChatAll("Amount to save is %d", g_iNickUpgradeAmmo[iClient]);
			if(g_iNickUpgradeAmmo[iClient] == 0)
			{
				//PrintToChatAll("Upgrade slot is equal to 0, setting strings to empty");
				g_strNickUpgradeType = "empty";
				g_strCurrentAmmoUpgrade = "empty";
			}
			else
			{
				//PrintToChatAll("Upgrade slot is great than 0, setting Type Slot to g_strCurrentAmmoUpgrade");
				g_strNickUpgradeType = g_strCurrentAmmoUpgrade;
				//PrintToChatAll("g_strNickUpgradeType = %s", g_strNickUpgradeType);
			}
		}
	}
}

fnc_CycleWeapon(iClient)
{
	//new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			if((g_iEllisCurrentPrimarySlot[iClient] == 0) && (StrEqual(g_strEllisPrimarySlot2, "empty", false) == false))
			{
				if(g_iLaserUpgradeCounter[iClient] > 0)
				{
					g_iLaserUpgradeCounter[iClient]--;
				}
				if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle", false) == true)
				{
					g_strNextWeaponCmdName = "rifle";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_ak47", false) == true)
				{
					g_strNextWeaponCmdName = "rifle_ak47";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_sg552", false) == true)
				{
					g_strNextWeaponCmdName = "rifle_sg552";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_desert", false) == true)
				{
					g_strNextWeaponCmdName = "rifle_desert";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_smg", false) == true)
				{
					g_strNextWeaponCmdName = "smg";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_smg_mp5", false) == true)
				{
					g_strNextWeaponCmdName = "smg_mp5";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_smg_silenced", false) == true)
				{
					g_strNextWeaponCmdName = "smg_silenced";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_pumpshotgun", false) == true)
				{
					g_strNextWeaponCmdName = "pumpshotgun";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_shotgun_chrome", false) == true)
				{
					g_strNextWeaponCmdName = "shotgun_chrome";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_autoshotgun", false) == true)
				{
					g_strNextWeaponCmdName = "autoshotgun";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_shotgun_spas", false) == true)
				{
					g_strNextWeaponCmdName = "shotgun_spas";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_hunting_rifle", false) == true)
				{
					g_strNextWeaponCmdName = "hunting_rifle";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_sniper_military", false) == true)
				{
					g_strNextWeaponCmdName = "sniper_military";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_sniper_awp", false) == true)
				{
					g_strNextWeaponCmdName = "sniper_awp";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_sniper_scout", false) == true)
				{
					g_strNextWeaponCmdName = "sniper_scout";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_grenade_launcher", false) == true)
				{
					g_strNextWeaponCmdName = "grenade_launcher";
				}
				else if(StrEqual(g_strEllisPrimarySlot2, "weapon_rifle_m60", false) == true)
				{
					g_strNextWeaponCmdName = "rifle_m60";
				}
				if (IsValidEdict(g_iPrimarySlotID[iClient]))
					RemoveEdict(g_iPrimarySlotID[iClient]);
				g_iEllisCurrentPrimarySlot[iClient] = 1;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give %s", g_strNextWeaponCmdName);
				//PrintToChatAll("Cycle function called, Primary Slot is %i, NextWpnCmdName = %s", g_iEllisCurrentPrimarySlot[iClient], g_strNextWeaponCmdName);
				
				// PrintToChatAll("Gave Weapon, now setting ammo/clip");
				// SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
				// PrintToChatAll("Clip has been set");
				// SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iEllisPrimarySavedAmmoSlot2[iClient]);
				// PrintToChatAll("Ammo has been set");
				// PrintToChatAll("Cycling to next weapon using function...");
				
			}
			else if((g_iEllisCurrentPrimarySlot[iClient] == 1) && (StrEqual(g_strEllisPrimarySlot1, "empty", false) == false))
			{
				if(g_iLaserUpgradeCounter[iClient] > 0)
				{
					g_iLaserUpgradeCounter[iClient]--;
				}
				if(StrEqual(g_strEllisPrimarySlot1, "weapon_rifle", false) == true)
				{
					g_strNextWeaponCmdName = "rifle";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_rifle_ak47", false) == true)
				{
					g_strNextWeaponCmdName = "rifle_ak47";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_rifle_sg552", false) == true)
				{
					g_strNextWeaponCmdName = "rifle_sg552";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_rifle_desert", false) == true)
				{
					g_strNextWeaponCmdName = "rifle_desert";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_smg", false) == true)
				{
					g_strNextWeaponCmdName = "smg";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_smg_mp5", false) == true)
				{
					g_strNextWeaponCmdName = "smg_mp5";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_smg_silenced", false) == true)
				{
					g_strNextWeaponCmdName = "smg_silenced";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_pumpshotgun", false) == true)
				{
					g_strNextWeaponCmdName = "pumpshotgun";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_shotgun_chrome", false) == true)
				{
					g_strNextWeaponCmdName = "shotgun_chrome";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_autoshotgun", false) == true)
				{
					g_strNextWeaponCmdName = "autoshotgun";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_shotgun_spas", false) == true)
				{
					g_strNextWeaponCmdName = "shotgun_spas";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_hunting_rifle", false) == true)
				{
					g_strNextWeaponCmdName = "hunting_rifle";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_sniper_military", false) == true)
				{
					g_strNextWeaponCmdName = "sniper_military";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_sniper_awp", false) == true)
				{
					g_strNextWeaponCmdName = "sniper_awp";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_sniper_scout", false) == true)
				{
					g_strNextWeaponCmdName = "sniper_scout";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_grenade_launcher", false) == true)
				{
					g_strNextWeaponCmdName = "grenade_launcher";
				}
				else if(StrEqual(g_strEllisPrimarySlot1, "weapon_rifle_m60", false) == true)
				{
					g_strNextWeaponCmdName = "rifle_m60";
				}

				if (IsValidEdict(g_iPrimarySlotID[iClient]))
				{
					RemoveEdict(g_iPrimarySlotID[iClient]);
				}
				g_iEllisCurrentPrimarySlot[iClient] = 0;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give %s", g_strNextWeaponCmdName);
				//PrintToChatAll("Cycle function called, Primary Slot is %i, NextWpnCmdName = %s", g_iEllisCurrentPrimarySlot[iClient], g_strNextWeaponCmdName);
				//g_bEllisHasCycled[iClient] = true;
				
				// PrintToChatAll("Gave Weapon, now setting ammo/clip");
				// SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
				// PrintToChatAll("Clip has been set");
				// SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iEllisPrimarySavedAmmoSlot1[iClient]);
				// PrintToChatAll("Ammo has been set");
				// PrintToChatAll("Cycling to next weapon using function...");
				
			}
			else
			{
				//PrintToChatAll("The next primary slot is empty");
			}
		}
		case 4:		//Nick
		{
			RemoveEdict(g_iPrimarySlotID[iClient]);
			//PrintToChatAll("Removed current weapon via fnc_CycleWeapon");
			SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
			FakeClientCommand(iClient, "give %s", g_strNickPrimarySaved);
			//PrintToChatAll("Gave %s via fnc_CycleWeapon", g_strNickPrimarySaved);
			//SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iNickPrimarySavedClip[iClient], true);
			//SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iNickPrimarySavedAmmo[iClient]);
			
			// PrintToChatAll("Gave Weapon, now setting ammo/clip");
			// SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
			// PrintToChatAll("Clip has been set");
			// SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iEllisPrimarySavedAmmoSlot2[iClient]);
			// PrintToChatAll("Ammo has been set");
			// PrintToChatAll("Cycling to next weapon using function...");
			
		}
	}
}

fnc_SetAmmo(iClient)
{
	if(RunClientChecks(iClient) ==  false || IsValidEntity(g_iPrimarySlotID[iClient]) == false)
		return;
	
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			if(g_iEllisCurrentPrimarySlot[iClient] == 0)
			{
				SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
				SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iEllisPrimarySavedAmmoSlot1[iClient]);
			}
			else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
			{
				SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
				SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iEllisPrimarySavedAmmoSlot2[iClient]);
			}
			//PrintToChatAll("Setting weapon ammo using functions...");
		}
		case 4:		//Nick
		{
			//PrintToChatAll("Set ammo via fnc_SetAmmo. Clip = %d, Ammo = %d", g_iNickPrimarySavedClip[iClient], g_iNickPrimarySavedAmmo[iClient]);
			SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iNickPrimarySavedClip[iClient], true);
			SetEntData(iClient, g_iOffset_Ammo[iClient] + g_iAmmoOffset[iClient], g_iNickPrimarySavedAmmo[iClient]);
		}
	}
}
fnc_DetermineMaxClipSize(iClient)
{
	GetClientWeapon(iClient, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
			if(StrEqual(g_strCurrentWeapon, "weapon_rifle", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iPromotionalLevel[iClient] * 20));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_ak47", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (40 + (g_iPromotionalLevel[iClient] * 20));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_sg552", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iPromotionalLevel[iClient] * 20));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_desert", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (60 + (g_iPromotionalLevel[iClient] * 20));
			}
		}
		case 1:		//Rochelle
		{
			if(StrEqual(g_strCurrentWeapon, "weapon_hunting_rifle", false) == true)
			{
				if(g_iSilentLevel[iClient] > 0)
				{
					g_iCurrentMaxClipSize[iClient] = (17 - (g_iSilentLevel[iClient] * 2));
				}
				else
				{
					g_iCurrentMaxClipSize[iClient] = 15;
				}
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_sniper_awp", false) == true)
			{
				if(g_iSilentLevel[iClient] > 0)
				{
					g_iCurrentMaxClipSize[iClient] = 3;
				}
				else
				{
					g_iCurrentMaxClipSize[iClient] = 20;
				}
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_sniper_scout", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (20 - g_iSilentLevel[iClient]);
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_sniper_military", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (30 + (g_iSilentLevel[iClient] * 6));
			}
		}
		case 2:		//Coach
		{
			if((StrEqual(g_strCurrentWeapon, "weapon_pumpshotgun", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_shotgun_chrome", false) == true))
			{
				g_iCurrentMaxClipSize[iClient] = (8 + (g_iSprayLevel[iClient] * 2));
			}
			else if((StrEqual(g_strCurrentWeapon, "weapon_autoshotgun", false) == true) || (StrEqual(g_strCurrentWeapon, "weapon_shotgun_spas", false) == true))
			{
				g_iCurrentMaxClipSize[iClient] = (10 + (g_iSprayLevel[iClient] * 2));
			}
		}
		case 3:		//Ellis
		{
			if(StrEqual(g_strCurrentWeapon, "weapon_rifle", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_ak47", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (40 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_sg552", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_desert", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (60 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_smg", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_smg_mp5", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_smg_silenced", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (50 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			/*
			else if(StrEqual(g_strCurrentWeapon, "weapon_pumpshotgun", false) == true)
			{
				g_strNextWeaponCmdName = "pumpshotgun";
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_shotgun_chrome", false) == true)
			{
				g_strNextWeaponCmdName = "shotgun_chrome";
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_autoshotgun", false) == true)
			{
				g_strNextWeaponCmdName = "autoshotgun";
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_shotgun_spas", false) == true)
			{
				g_strNextWeaponCmdName = "shotgun_spas";
			}
			*/
			else if(StrEqual(g_strCurrentWeapon, "weapon_hunting_rifle", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (15 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_sniper_military", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (30 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_sniper_awp", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (20 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_sniper_scout", false) == true)
			{
				g_iCurrentMaxClipSize[iClient] = (20 + (g_iMetalLevel[iClient] * 4) + (g_iFireLevel[iClient] * 6));
			}
			/*
			else if(StrEqual(g_strCurrentWeapon, "weapon_grenade_launcher", false) == true)
			{
				g_strNextWeaponCmdName = "grenade_launcher";
			}
			else if(StrEqual(g_strCurrentWeapon, "weapon_rifle_m60", false) == true)
			{
				g_strNextWeaponCmdName = "rifle_m60";
			}
			*/
		}
		case 4:		//Nick
		{
			if((g_bRamboModeActive[iClient] == true) && (StrEqual(g_strCurrentWeapon, "weapon_rifle_m60", false) == true))
			{
				g_iCurrentMaxClipSize[iClient] = 250;
			}
			else if((g_bRamboModeActive[iClient] == false) && (StrEqual(g_strCurrentWeapon, "weapon_rifle_m60", false) == true))
			{
				g_iCurrentMaxClipSize[iClient] = 150;
			}
		}
	}
}

fnc_SetAmmoUpgrade(iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			//PrintToChatAll("SWITCH REACHED");
			/*
			SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd & ~FCVAR_CHEAT);
			FakeClientCommand(iClient, "upgrade_add EXPLOSIVE_AMMO");
			SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd);
			*/
			if((g_iEllisCurrentPrimarySlot[iClient] == 0) && (g_iEllisUpgradeAmmoSlot1[iClient] > 0))
			{
				//PrintToChatAll("Setting Cheat Flags");
				//SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "upgrade_add %s", g_strEllisUpgradeTypeSlot1);
				//PrintToChatAll("Setting upgrade clip size based on saved ammo slot");
				SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iEllisUpgradeAmmoSlot1[iClient]);
				SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisUpgradeAmmoSlot1[iClient], true);
				//SetCommandFlags("give", g_iFlag_Give);
				SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd);
				//g_iEllisUpgradeAmmoSlot1[iClient] = 0;
			}
			else if((g_iEllisCurrentPrimarySlot[iClient] == 1) && (g_iEllisUpgradeAmmoSlot2[iClient] > 0))
			{
				//PrintToChatAll("Setting Cheat Flags");
				//SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "upgrade_add %s", g_strEllisUpgradeTypeSlot2);
				//PrintToChatAll("Setting upgrade clip size based on saved ammo slot");
				SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iEllisUpgradeAmmoSlot2[iClient]);
				SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iEllisUpgradeAmmoSlot2[iClient], true);
				//SetCommandFlags("give", g_iFlag_Give);
				SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd);
				//g_iEllisUpgradeAmmoSlot2[iClient] = 0;
			}
		}
		case 4:		//Nick
		{
			if(g_iNickUpgradeAmmo[iClient] > 0)
			{
				SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "upgrade_add %s", g_strNickUpgradeType);
				//PrintToChatAll("Setting upgrade clip size based on saved ammo slot");
				SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iNickUpgradeAmmo[iClient]);
				SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iNickUpgradeAmmo[iClient], true);
				//SetCommandFlags("give", g_iFlag_Give);
				SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd);
			}
			if(g_bRamboModeActive[iClient] == true)
			{
				SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "upgrade_add LASER_SIGHT");
			}
		}
	}
}
fnc_SetAmmoUpgradeToMaxClipSize(iClient)
{
	/*
	if(g_iNicksRamboWeaponID[iClient] != 0)
		return Plugin_Continue;
	*/
	//PrintToChatAll("Setting Ammo Upgrade");
	g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
	if((StrEqual(g_strCheckAmmoUpgrade, "EXPLOSIVE_AMMO", false) == true) || (StrEqual(g_strCheckAmmoUpgrade, "INCENDIARY_AMMO", false) == true))
	{
		//PrintToChatAll("g_strCurrentAmmoUpgrade is acceptable, setting upgrade ammo based on max clip size");
		SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iCurrentMaxClipSize[iClient]);
		SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iCurrentMaxClipSize[iClient], true);
		g_strCheckAmmoUpgrade = "empty";
	}
	
	// switch(g_iChosenSurvivor[iClient])
	// {
	// 	case 0:		//Bill
	// 	{
		
	// 	}
	// 	case 1:		//Rochelle
	// 	{
		
	// 	}
	// 	case 2:		//Coach
	// 	{
		
	// 	}
	// 	case 3:		//Ellis
	// 	{
	// 		if(((StrEqual(g_strCheckAmmoUpgrade, "EXPLOSIVE_AMMO", false) == true) || (StrEqual(g_strCheckAmmoUpgrade, "INCENDIARY_AMMO", false) == true)) && (g_bEllisHasCycled[iClient] == false))
	// 		{
	// 			PrintToChatAll("g_strCurrentAmmoUpgrade is acceptable, setting upgrade ammo based on max clip size");
	// 			SetEntProp(g_iPrimarySlotID[iClient], Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", g_iCurrentMaxClipSize[iClient]);
	// 			SetEntData(g_iPrimarySlotID[iClient], g_iOffset_Clip1, g_iCurrentMaxClipSize[iClient], true);
	// 			g_strCheckAmmoUpgrade = "empty";
	// 		}
	// 		else if(g_bEllisHasCycled[iClient] == true)
	// 		{
	// 			g_bEllisHasCycled[iClient] = false;
	// 		}
	// 	}
	// 	case 4:		//Nick
	// 	{
			
	// 	}
	// }
	
}

fnc_ClearSavedWeaponData(iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			if(g_iEllisCurrentPrimarySlot[iClient] == 1)
			{
				g_iEllisPrimarySavedClipSlot1[iClient] = 0;
				g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
				g_iEllisUpgradeAmmoSlot1[iClient] = 0;
				g_strEllisUpgradeTypeSlot1 = "empty";
				g_strCurrentAmmoUpgrade = "empty";
				g_strEllisPrimarySlot1 = "empty";
				//PrintToChatAll("g_strEllisPrimarySlot1 is now %s", g_strEllisPrimarySlot1);
			}
			else if(g_iEllisCurrentPrimarySlot[iClient] == 0)
			{
				g_iEllisPrimarySavedClipSlot2[iClient] = 0;
				g_iEllisPrimarySavedAmmoSlot2[iClient] = 0;
				g_iEllisUpgradeAmmoSlot2[iClient] = 0;
				g_strEllisUpgradeTypeSlot2 = "empty";
				g_strCurrentAmmoUpgrade = "empty";
				g_strEllisPrimarySlot2 = "empty";
				//PrintToChatAll("g_strEllisPrimarySlot2 is now %s", g_strEllisPrimarySlot2);
			}
		}
		case 4:		//Nick
		{
			g_iNickPrimarySavedClip[iClient] = 0;
			g_iNickPrimarySavedAmmo[iClient] = 0;
			g_iNickUpgradeAmmo[iClient] = 0;
			g_strNickUpgradeType = "empty";
			g_strCurrentAmmoUpgrade = "empty";
			g_strNickPrimarySaved = "empty";
		}
	}
}

fnc_ClearAllWeaponData(iClient)
{
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			g_iEllisPrimarySavedClipSlot1[iClient] = 0;
			g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
			g_iEllisUpgradeAmmoSlot1[iClient] = 0;
			g_strEllisUpgradeTypeSlot1 = "empty";
			g_strCurrentAmmoUpgrade = "empty";
			g_strEllisPrimarySlot1 = "empty";
			//PrintToChatAll("g_strEllisPrimarySlot1 is now %s", g_strEllisPrimarySlot1);
			g_iEllisPrimarySavedClipSlot2[iClient] = 0;
			g_iEllisPrimarySavedAmmoSlot2[iClient] = 0;
			g_iEllisUpgradeAmmoSlot2[iClient] = 0;
			g_strEllisUpgradeTypeSlot2 = "empty";
			g_strCurrentAmmoUpgrade = "empty";
			g_strEllisPrimarySlot2 = "empty";
			//PrintToChatAll("g_strEllisPrimarySlot2 is now %s", g_strEllisPrimarySlot2);
		}
		case 4:		//Nick
		{
			g_strNickSecondarySlot1 = "empty";
			g_strNickSecondarySlot2 = "empty";
			g_iNickCurrentSecondarySlot[iClient] = 0;
		}
	}
}

fnc_SetClientSpeed(iClient)
{
	if (iClient < 1 || 
	IsValidEntity(iClient) == false || 
	IsClientInGame(iClient) == false || 
	IsPlayerAlive(iClient) == false ||
	g_bGameFrozen == true
	)
		return;
	
	//new iCurrentSpeed = GetEntDataFloat(iClient, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"));
	SetEntDataFloat(iClient, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), ((1.0 + g_fClientSpeedBoost[iClient]) - g_fClientSpeedPenalty[iClient]), true);
	//PrintToChatAll("Client %i current speed = Boost %f + Penalty %f = Total %f", iClient, g_fClientSpeedBoost[iClient], g_fClientSpeedPenalty[iClient], ((1.0 + g_fClientSpeedBoost[iClient]) - g_fClientSpeedPenalty[iClient]));
	//g_fClientSpeedPenalty[iClient] =+ fSpeedReduction;
	//g_fClientSpeedPenalty[iClient];
	//g_fClientSpeedBoost[iClient];
	
	// switch(g_iChosenSurvivor[iClient])
	// {
	// 	case 0:		//Bill
	// 	{
	// 		SetEntDataFloat(iClient, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), ((1.0 + g_fBillSprintSpeed[iClient]) - g_fClientSpeedPenalty[iClient]), true);
	// 		PrintToChatAll("Bills current speed = %d", iCurrentSpeed);
	// 	}
	// 	case 1:		//Rochelle
	// 	{
			
	// 		PrintToChatAll("Rochelles current speed = %d", iCurrentSpeed);
	// 	}
	// 	case 2:		//Coach
	// 	{
			
	// 		PrintToChatAll("Coach current speed = %d", iCurrentSpeed);
	// 	}
	// 	case 3:		//Ellis
	// 	{
			
	// 		PrintToChatAll("Ellis current speed = %d", iCurrentSpeed);
	// 	}
	// 	case 4:		//Nick
	// 	{
			
	// 		PrintToChatAll("Nicks current speed = %d", iCurrentSpeed);
	// 	}
	// }
	
}

fnc_CheckGrapple(iClient)
{
	if(g_bChargerCarrying[iClient] == true || g_bChargerGrappled[iClient] == true || g_bSmokerGrappled[iClient] == true || g_bJockeyGrappled[iClient] == true || g_bHunterGrappled[iClient] == true)
	{
		g_bIsClientGrappled[iClient] = true;
	}
	else
	{
		g_bIsClientGrappled[iClient] = false;
	}
	//PrintToChatAll("g_bIsClientGrappled = %s", g_bIsClientGrappled[iClient]);
	//PrintToChatAll("g_bIsClientGrappled = %i", g_bIsClientGrappled[iClient]);
}

void AddTempHealthToSurvivor(iClient, Float:fAdditionalTempHealth)
{
	// Calculate the current surivivors temp health
	new iTempHealth = GetSurvivorTempHealth(iClient);
	if (iTempHealth < 0)
		return;
	
	// If the temp health is not set or is expired (passed buffer time), then
	// reset the buffer time and set a new temp health buffer with the new value.
	// Else, simply add the additional health to the existing players temp health,
	// without resetting the time buffer.
	if (iTempHealth == 0)
	{
		SetEntPropFloat(iClient, Prop_Send, "m_healthBufferTime", GetGameTime());
		SetEntPropFloat(iClient, Prop_Send, "m_healthBuffer", fAdditionalTempHealth);
	}
	else
	{
		// Get tthe current health buffer and add the specified amount to it
		new Float:fTempHealth = GetEntPropFloat(iClient, Prop_Send, "m_healthBuffer")
		fTempHealth += fAdditionalTempHealth;

		// Cap the temp health
		//if(fTempHealth > 160.0)
		//	fTempHealth = 160.0;

		// Set it
		SetEntPropFloat(iClient, Prop_Send, "m_healthBuffer", fTempHealth);
	}
}

// This function calculates a survivors temp health, since there is no direct way to 
// obtain this information.  It takes health buffer ammount and subtracts the gametime minus
// buffer time times the decay rate for temp health.
int GetSurvivorTempHealth(int iClient)
{
    if (!RunClientChecks(iClient) || 
		!IsPlayerAlive(iClient) || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
        return -1;
    
    if (cvarPainPillsDecay == INVALID_HANDLE)
    {
        cvarPainPillsDecay = FindConVar("pain_pills_decay_rate");
        if (cvarPainPillsDecay == INVALID_HANDLE)
            return -1;
        
        HookConVarChange(cvarPainPillsDecay, OnPainPillsDecayChanged);
        flPainPillsDecay = cvarPainPillsDecay.FloatValue;
    }
    
    int tempHealth = RoundToCeil(GetEntPropFloat(iClient, Prop_Send, "m_healthBuffer") - ((GetGameTime() - GetEntPropFloat(iClient, Prop_Send, "m_healthBufferTime")) * flPainPillsDecay)) - 1;
    return tempHealth < 0 ? 0 : tempHealth;
}

public Action:OpenHelpMotdPanel(iClient,args)
{
	OpenMOTDPanel(iClient, "", "http://xpmod.net/help/xpmod_ig_help.html", MOTDPANEL_TYPE_URL);
	return Plugin_Handled;
}

 
/**************************************************************************************************************************/

// public bool DidClientMoveEyesOrPosition(iClient)
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