Action:TimerStopRambo(Handle:timer, any:iClient)
{
	//new Float:vec[3];
	//GetClientAbsOrigin(iClient, vec);
	//EmitSoundToAll(SOUND_JPIDLEREV, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
	
	
	//fnc_DetermineMaxClipSize(iClient);
	fnc_CycleWeapon(iClient);
	g_bRamboModeActive[iClient] = false;
	//fnc_DeterminePrimaryWeapon(iClient);
	//fnc_SetAmmo(iClient);
	//fnc_SetAmmoUpgrade(iClient);
	
	//PrintToChatAll("Cycled weapon via rambo stop timer");
	//fnc_SetAmmo(iClient);
	//fnc_SetAmmoUpgrade(iClient);
	//fnc_ClearSavedWeaponData(iClient);
	
	//RemoveEdict(g_iRamboWeaponID[iClient]);
	/*
	if(iClient > 0)
		if(IsClientInGame(iClient) == true)
			PrintHintText(iClient, "Rambo mode is now off");
	new wID = g_iNicksRamboWeaponID[iClient];
	decl String:weaponclass[32];
	GetEntityNetClass(wID, weaponclass, 32);
	if(iClient > 1 && IsClientInGame(iClient) == true && IsPlayerAlive(iClient) == true)
	{
		SetCommandFlags("upgrade_remove", g_iFlag_UpgradeRemove & ~FCVAR_CHEAT);
		FakeClientCommand(iClient, "upgrade_remove EXPLOSIVE_AMMO");
		SetCommandFlags("upgrade_remove", g_iFlag_UpgradeRemove);
	}
	if(wID > 0 && IsValidEntity(wID))
	{
		SetEntData(wID, g_iOffset_Clip1, 0, true);	//remove entity if this is working good
		RemoveEdict(wID);
	}
	g_iNicksRamboWeaponID[iClient] = 0;
	*/
	return Plugin_Stop;
}

Action:TimerSlap(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient)==false || IsPlayerAlive(iClient)==false)
	{
		g_hTimer_SlapPlayer[iClient] = null;
		return Plugin_Stop;
	}
	if(g_iSlapRunTimes[iClient]++ < 5)
	{
		new iCurrentHP = GetEntProp(iClient, Prop_Data, "m_iHealth");
		if(iCurrentHP > 15)
			SlapPlayer(iClient, 15);
		else
			SlapPlayer(iClient, iCurrentHP - 1);
		
		return Plugin_Continue;
	}
	g_bNickIsGettingBeatenUp[iClient] = false;
	
	g_hTimer_SlapPlayer[iClient] = null;
	return Plugin_Stop;
}

// Action:TimerMakeVisible(Handle:timer, any:iClient)
// {
// 	g_bNickIsInvisible[iClient] = false;
// 	if(IsValidEntity(iClient) == true && IsClientInGame(iClient) == true)
// 	{
// 		SetEntProp(iClient, Prop_Send, "m_iGlowType", 0);
// 		SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
// 		SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 0);
// 		SetEntityRenderMode(iClient, RenderMode:0);
// 		SetEntityRenderColor(iClient, 255, 255, 255, 255);
// 		if(IsFakeClient(iClient) == false)
// 			PrintHintText(iClient, "The phenomenon has passed and you are now visible agian.");
// 	}
// 	return Plugin_Stop;
// }

Action:TimerBlindFade(Handle:timer, any:iClient)
{
	if(IsFakeClient(iClient)==false)
		ShowHudOverlayColor(iClient, 0, 0, 0, 255, 4000, FADE_OUT);
	
	return Plugin_Stop;
}

Action:TimerLifeStealing(Handle:timer, any:pack)
{
	if (pack == INVALID_HANDLE)
		return Plugin_Stop;
	ResetPack(pack);
	new victim = ReadPackCell(pack);
	new attacker = ReadPackCell(pack);
	if(IsValidEntity(attacker)==false || IsClientInGame(attacker)==false || IsPlayerAlive(attacker)==false ||
		IsValidEntity(victim)==false || IsClientInGame(victim)==false || IsPlayerAlive(victim)==false)
	{
		CloseHandle(pack);
		g_bNickIsStealingLife[victim][attacker] = false;
		g_hTimer_NickLifeSteal[victim] = null;
		return Plugin_Stop;
	}
	
	if(g_iNickStealingLifeRuntimes[victim] == 0)
	{
		if(attacker > 0)
			if(IsFakeClient(attacker)==false)
				PrintHintText(attacker,"Your stealing life from %N", victim);
		//if(victim > 0)
		//	if(IsFakeClient(victim)==false)
		//		PrintHintText(victim,"%N robs some of your lifeforce", attacker);
	}
	if(g_iNickStealingLifeRuntimes[victim]++ < 5)	//Runs 5 Times
	{
		if(IsFakeClient(attacker)==false)
			ShowHudOverlayColor(attacker, 0, 100, 255, 40, 400, FADE_IN);
		
		if(IsFakeClient(victim)==false)
			ShowHudOverlayColor(victim, 180, 0, 40, 40, 400, FADE_IN);
		
		CreateTimer(1.0, TimerLifeStealingFade, pack, TIMER_FLAG_NO_MAPCHANGE);	//Make the effect fade away and dmg victim(victim)	//was .8
		return Plugin_Continue;
	}
	g_bNickIsStealingLife[victim][attacker] = false;
	
	//if(IsFakeClient(victim)==false)
	//	PrintHintText(victim, "The life stealing effects have worn off");
	
	//PrintToChatAll( "victim %d, attacker %d", victim, attacker);

	CloseHandle(pack);
	g_hTimer_NickLifeSteal[victim] = null;
	return Plugin_Stop;
}

Action:TimerLifeStealingFade(Handle:timer, any:pack)
{
	if (pack == INVALID_HANDLE)
		return Plugin_Stop;
	ResetPack(pack);					//Reading this might cause problems if read at the wrong time
	new victim = ReadPackCell(pack);	//because it could be an invalid package (check this)
	new attacker = ReadPackCell(pack);
	if((victim < 1) || (attacker < 1))
		return Plugin_Stop;
	if((IsClientInGame(victim) == false) || (IsClientInGame(attacker) == false))
		return Plugin_Stop;
	if((IsValidEntity(victim) == false) || (IsValidEntity(attacker) == false))
		return Plugin_Stop;
	if((IsPlayerAlive(victim) == false) || (IsPlayerAlive(attacker) == false))
		return Plugin_Stop;
	if(attacker > 0)
	{
		decl stealamt;
		stealamt = g_iSwindlerLevel[attacker];
		//Take life from victim
		new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
		if(hp <= stealamt)
			ForcePlayerSuicide(victim);
		else
			SetEntProp(victim,Prop_Data,"m_iHealth", hp - stealamt);
		//Give life to shooter
		hp = GetEntProp(attacker,Prop_Data,"m_iHealth");
		new maxhp = GetEntProp(attacker,Prop_Data,"m_iMaxHealth");
		if(hp!=maxhp)
		{
			if(g_bIsClientDown[attacker] == false)
			{
				if(maxhp > (hp + RoundToCeil(stealamt*0.5)))
					SetEntProp(attacker,Prop_Data,"m_iHealth", hp + RoundToCeil(stealamt*0.5));
				else
					SetEntProp(attacker,Prop_Data,"m_iHealth", maxhp);
			}
			else
				SetEntProp(attacker,Prop_Data,"m_iHealth", hp + RoundToCeil(stealamt*0.5));
				
			WriteParticle(attacker, "nick_lifesteal_recovery", 0.0, 3.0);
		}
	}
	
	// HUD effects
	if(IsFakeClient(attacker)==false)
		ShowHudOverlayColor(attacker, 0, 100, 255, 40, 440, FADE_OUT);
	
	if(IsFakeClient(victim)==false)
		ShowHudOverlayColor(victim, 180, 0, 40, 40, 440, FADE_OUT);
	
	return Plugin_Stop;
}

Action:TimerNickSecondaryCycleReset(Handle:timer, any:iClient)
{
	g_bCanNickSecondaryCycle[iClient] = true;
	return Plugin_Stop;
}

Action:TimerNickDualClipSize(Handle:timer, any:iClient)
{
	decl String:currentweapon[512];
	GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
	new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	//PrintToChatAll("In Timer: About to set clip size... Clip Slot 2 = %i", g_iNickSecondarySavedClipSlot2[iClient]);
	if(StrEqual(currentweapon, "weapon_pistol", false) == true)
	{
		//PrintToChatAll("In Timer: Weapon is pistol, setting clip size now... Clip Slot 2 = %i", g_iNickSecondarySavedClipSlot2[iClient]);
		SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iNickSecondarySavedClipSlot2[iClient], true);
	}
	return Plugin_Stop;
}

Action:TimerNickZoomKitReset(Handle:timer, any:iClient)
{
	g_bCanNickZoomKit[iClient] = true;
	return Plugin_Stop;
}

//TimerIsNickInSecondaryCycleReset
//TimerNickZoomKitReset
//TimerNickDualClipSize
//SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iNickSecondarySavedClipSlot2[iClient], true);
