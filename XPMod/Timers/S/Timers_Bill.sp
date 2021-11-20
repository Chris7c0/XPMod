Action:TimerDropBombs(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient)==false || IsPlayerAlive(iClient)==false)
	{
		g_hTimer_BillDropBombs[iClient] = null;
		return Plugin_Stop;
	}
	
	if(g_iDropBombsTimes[iClient]++ < 3)
	{
		if(IsFakeClient(iClient)==false)
		{
			decl i_Ent, Float:f_Position[3], Float:fAngles[3], Float:f_Speed[3];
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
			GetClientEyeAngles(iClient, fAngles);
			GetAngleVectors(fAngles, f_Speed, NULL_VECTOR, NULL_VECTOR);
			TeleportEntity(i_Ent, f_Position, fAngles, f_Speed);
			
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
	
	g_hTimer_BillDropBombs[iClient] = null;
	return Plugin_Stop;
}

Action:TimerPoopBombBeep1(Handle:timer, any:iEntity)
{
	if(IsValidEntity(iEntity))
	{
		static Float:poopbombbeeptime1 = 1.0;
		poopbombbeeptime1 -= 0.1;
		decl Float:fOrigin[3];
		GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", fOrigin);
		EmitAmbientSound(SOUND_BEEP, fOrigin, iEntity, SNDLEVEL_NORMAL);
		AttachInfected(iEntity, fOrigin);
		//PrintToChatAll("time1 = %f", poopbombbeeptime1);
		if(poopbombbeeptime1 > 0.0)
			CreateTimer(poopbombbeeptime1, TimerPoopBombBeep1, iEntity, TIMER_FLAG_NO_MAPCHANGE);
		else
			poopbombbeeptime1 = 1.0;
	}
	return Plugin_Stop;
}
Action:TimerPoopBombBeep2(Handle:timer, any:iEntity)
{
	if(IsValidEntity(iEntity))
	{
		static Float:poopbombbeeptime2 = 1.0;
		poopbombbeeptime2 -= 0.1;
		decl Float:fOrigin[3];
		GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", fOrigin);
		EmitAmbientSound(SOUND_BEEP, fOrigin, iEntity, SNDLEVEL_NORMAL);
		AttachInfected(iEntity, fOrigin);
		//PrintToChatAll("time2 = %f", poopbombbeeptime2);
		if(poopbombbeeptime2 > 0.0)
			CreateTimer(poopbombbeeptime2, TimerPoopBombBeep2, iEntity, TIMER_FLAG_NO_MAPCHANGE);
		else
			poopbombbeeptime2 = 1.0;
	}
	return Plugin_Stop;
}
Action:TimerPoopBombBeep3(Handle:timer, any:iEntity)
{
	if(IsValidEntity(iEntity))
	{
		static Float:poopbombbeeptime3 = 1.0;
		poopbombbeeptime3 -= 0.1;
		decl Float:fOrigin[3];
		GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", fOrigin);
		EmitAmbientSound(SOUND_BEEP, fOrigin, iEntity, SNDLEVEL_NORMAL);
		AttachInfected(iEntity, fOrigin);
		//PrintToChatAll("time3 = %f", poopbombbeeptime3);
		if(poopbombbeeptime3 > 0.0)
			CreateTimer(poopbombbeeptime3, TimerPoopBombBeep3, iEntity, TIMER_FLAG_NO_MAPCHANGE);
		else
			poopbombbeeptime3 = 1.0;
	}
	return Plugin_Stop;
}

Action:TimerBlowUpPoopBomb(Handle:timer, any:iEntity)
{
	if (RunEntityChecks(iEntity) == false ||
		HasEntProp(iEntity, Prop_Send, "m_vecOrigin") == false)
		return Plugin_Stop;

	decl Float:xyzEntityOrigin[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", xyzEntityOrigin);
	if(iEntity > 0 && IsValidEntity(iEntity))
		AcceptEntityInput(iEntity, "Kill");
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

Action:TimerChangeCanDropBombs(Handle:timer, any:iClient)
{
	g_bCanDropPoopBomb[iClient] = true;
	return Plugin_Stop;
}