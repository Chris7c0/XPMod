public Action:TimerDropBombs(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient)==false)
	{
		return Plugin_Stop;
	}
	if(IsPlayerAlive(iClient)==false)
	{
		return Plugin_Stop;
	}
	//old code
	/*if(g_iDropBombsTimes[iClient]++ < 3)
	{
		if(IsFakeClient(iClient)==false)
		{
			new Handle:cvar = FindConVar("sv_cheats"), flags = GetConVarFlags(cvar);
			SetConVarFlags(cvar, flags^(FCVAR_NOTIFY|FCVAR_REPLICATED));
			SetConVarBool(cvar, true);
			SendConVarValue(iClient, FindConVar("sv_cheats"), "1");
			FakeClientCommand(iClient, "boom");
			SendConVarValue(iClient, FindConVar("sv_cheats"), "0");
			SetConVarBool(cvar, false);
			SetConVarFlags(cvar, flags);
			CloseHandle(cvar);
			
			//Set the cvars back to ATTACH_NORMAL after using the sv
			SetConVarInt(FindConVar("first_aid_kit_max_heal"), 999);		//So everyone can heal to their max using medkit
			SetConVarInt(FindConVar("pain_pills_health_threshold"), 999);	//So everyone can use pain pills above 99 health
			SetConVarFloat(FindConVar("upgrade_laser_sight_spread_factor"), g_fMaxLaserAccuracy);
			SetConVarInt(FindConVar("survivor_crawl_speed"), (15 + g_iCrawlSpeedMultiplier),false,false);
			SetConVarInt(FindConVar("survivor_allow_crawling"),1,false,false);	//this can be done because only BILL can use this talent
			if(coachnoshake == true)
			{
				SetConVarInt(FindConVar("z_claw_hit_pitch_max"), 0);
				SetConVarInt(FindConVar("z_claw_hit_pitch_min"), 0);
				SetConVarInt(FindConVar("z_claw_hit_yaw_max"), 0);
				SetConVarInt(FindConVar("z_claw_hit_yaw_min"), 0);
			}
			if(g_bUsingShadowNinja[iClient] == true)
				SetConVarInt(FindConVar("sv_disable_glow_survivors"), 1);
			SetConVarInt(FindConVar("chainsaw_attack_force"), 400 + (g_iHighestLeadLevel * 40));
			SetConVarInt(FindConVar("chainsaw_damage"), 100 + (g_iHighestLeadLevel * 10));
			SetConVarFloat(FindConVar("chainsaw_hit_interval"), 0.1 - (float(g_iHighestLeadLevel) * 0.01),false,false);
		}
		return Plugin_Continue;
	}*/
	
	if(g_iDropBombsTimes[iClient]++ < 3)
	{
		if(IsFakeClient(iClient)==false)
		{
			decl i_Ent, Float:f_Position[3], Float:f_Angles[3], Float:f_Speed[3];
			decl String:s_TargetName[32];
			i_Ent = CreateEntityByName("pipe_bomb_projectile");
			
			if (IsValidEntity(i_Ent))
			{
				SetEntPropEnt(i_Ent, Prop_Data, "m_hOwnerEntity", iClient);
				SetEntityModel(i_Ent, "models/w_models/weapons/w_eq_pipebomb.mdl");
				FormatEx(s_TargetName, sizeof(s_TargetName), "pipebomb%d", i_Ent);
				DispatchKeyValue(i_Ent, "targetname", s_TargetName);
				DispatchSpawn(i_Ent);
			}
			GetClientEyePosition(iClient, f_Position);
			GetClientEyeAngles(iClient, f_Angles);
			GetAngleVectors(f_Angles, f_Speed, NULL_VECTOR, NULL_VECTOR);
			TeleportEntity(i_Ent, f_Position, f_Angles, f_Speed);
			
			CreateParticle("weapon_pipebomb_blinking_light", 0.0, i_Ent, ATTACH_NORMAL);
			CreateParticle("weapon_pipebomb_fuse", 0.0, i_Ent, ATTACH_NORMAL);
			
			g_iPoopBombOwnerID[i_Ent] = iClient;
			
			AttachInfected(i_Ent, f_Position);
						
			if(g_iDropBombsTimes[iClient] == 1)
				CreateTimer(1.0, TimerPoopBombBeep1, i_Ent, TIMER_FLAG_NO_MAPCHANGE);
			if(g_iDropBombsTimes[iClient] == 2)
				CreateTimer(1.0, TimerPoopBombBeep2, i_Ent, TIMER_FLAG_NO_MAPCHANGE);
			if(g_iDropBombsTimes[iClient] == 3)
				CreateTimer(1.0, TimerPoopBombBeep3, i_Ent, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(6.0, TimerBlowUpPoopBomb, i_Ent, TIMER_FLAG_NO_MAPCHANGE);
		}
		return Plugin_Continue;
	}
	
	return Plugin_Stop;
}

public Action:TimerPoopBombBeep1(Handle:timer, any:iEntity)
{
	if(IsValidEntity(iEntity))
	{
		static Float:poopbombbeeptime1 = 1.0;
		poopbombbeeptime1 -= 0.1;
		decl Float:f_Origin[3];
		GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", f_Origin);
		EmitAmbientSound(SOUND_BEEP, f_Origin, iEntity, SNDLEVEL_NORMAL);
		AttachInfected(iEntity, f_Origin);
		//PrintToChatAll("time1 = %f", poopbombbeeptime1);
		if(poopbombbeeptime1 > 0.0)
			CreateTimer(poopbombbeeptime1, TimerPoopBombBeep1, iEntity, TIMER_FLAG_NO_MAPCHANGE);
		else
			poopbombbeeptime1 = 1.0;
	}
	return Plugin_Stop;
}
public Action:TimerPoopBombBeep2(Handle:timer, any:iEntity)
{
	if(IsValidEntity(iEntity))
	{
		static Float:poopbombbeeptime2 = 1.0;
		poopbombbeeptime2 -= 0.1;
		decl Float:f_Origin[3];
		GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", f_Origin);
		EmitAmbientSound(SOUND_BEEP, f_Origin, iEntity, SNDLEVEL_NORMAL);
		AttachInfected(iEntity, f_Origin);
		//PrintToChatAll("time2 = %f", poopbombbeeptime2);
		if(poopbombbeeptime2 > 0.0)
			CreateTimer(poopbombbeeptime2, TimerPoopBombBeep2, iEntity, TIMER_FLAG_NO_MAPCHANGE);
		else
			poopbombbeeptime2 = 1.0;
	}
	return Plugin_Stop;
}
public Action:TimerPoopBombBeep3(Handle:timer, any:iEntity)
{
	if(IsValidEntity(iEntity))
	{
		static Float:poopbombbeeptime3 = 1.0;
		poopbombbeeptime3 -= 0.1;
		decl Float:f_Origin[3];
		GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", f_Origin);
		EmitAmbientSound(SOUND_BEEP, f_Origin, iEntity, SNDLEVEL_NORMAL);
		AttachInfected(iEntity, f_Origin);
		//PrintToChatAll("time3 = %f", poopbombbeeptime3);
		if(poopbombbeeptime3 > 0.0)
			CreateTimer(poopbombbeeptime3, TimerPoopBombBeep3, iEntity, TIMER_FLAG_NO_MAPCHANGE);
		else
			poopbombbeeptime3 = 1.0;
	}
	return Plugin_Stop;
}

public Action:TimerBlowUpPoopBomb(Handle:timer, any:iEntity)
{
	decl Float:xyzEntityOrigin[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", xyzEntityOrigin);
	if(IsValidEntity(iEntity))
		RemoveEdict(iEntity);
	new i_Ent = CreateEntityByName("prop_physics");
	//DispatchKeyValue(i_Ent, "physdamagescale", "0.0");
	DispatchKeyValue(i_Ent, "model", "models/props_junk/propanecanister001a.mdl");
	//DispatchKeyValue(i_Ent, "model", "models/w_models/weapons/w_eq_pipebomb.mdl");
	//DispatchKeyValue(i_Ent, "DamageType", "0");		//134217792
	//DispatchKeyValue(i_Ent, "BreakableType", "0");
	
	//decl String:clientname[64];
	//GetClientName(1, clientname, sizeof(clientname));
	//PrintToChatAll("%s", clientname);
	//DispatchKeyValue(i_Ent, "parentname", clientname);
	
	DispatchSpawn(i_Ent);
	TeleportEntity(i_Ent, xyzEntityOrigin, NULL_VECTOR, NULL_VECTOR);
	//SetEntityMoveType(i_Ent, MOVETYPE_VPHYSICS);
	AcceptEntityInput(i_Ent, "Break");
	
	//Deal extra damage to the special infected in near the poopbomb explosion
	decl Float:xyzVictimOrigin[3], Float:fDistance;
	
	for(new iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if(g_iClientTeam[iPlayer] == TEAM_INFECTED && IsClientInGame(iPlayer) == true && 
			IsPlayerAlive(iPlayer) == true)
		{
			GetEntPropVector(iPlayer, Prop_Send, "m_vecOrigin", xyzVictimOrigin);
			
			fDistance = GetVectorDistance(xyzEntityOrigin, xyzVictimOrigin, false);
			
			if(fDistance <= 400.0)
			{
				if(g_iPoopBombOwnerID[iEntity] > 0 && IsClientInGame(g_iPoopBombOwnerID[iEntity]) == true)
					DealDamage(iPlayer, g_iPoopBombOwnerID[iEntity], 200 - RoundToNearest(200.0 * (fDistance / 400.0)));
				else
					DealDamage(iPlayer, iPlayer, 200 - RoundToNearest(200.0 * (fDistance / 400.0)));
			}
		}
	}
	
	g_iPoopBombOwnerID[iEntity] = 0;
	
	return Plugin_Stop;
}

public Action:TimerChangeCanDropBombs(Handle:timer, any:iClient)
{
	g_bCanDropPoopBomb[iClient] = true;
	return Plugin_Stop;
}