Action:TimerLungeFurther(Handle:timer, any:iClient)
{
	decl Float:velocity[3];
	GetEntPropVector(iClient, Prop_Data, "m_vecVelocity", velocity);
	velocity[0] *= (1.0 + (g_iPredatorialLevel[iClient] * 0.05));
	velocity[1] *= (1.0 + (g_iPredatorialLevel[iClient] * 0.05));
	velocity[2] *= (1.0 + (g_iPredatorialLevel[iClient] * 0.05));
	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, velocity);
	return Plugin_Stop;
}

Action:TimerHunterPounceDamage(Handle:timer, any:pack)
{	
	ResetPack(pack);
	new iVictim = ReadPackCell(pack);
	new iAttacker = ReadPackCell(pack);
	new iDamage = ReadPackCell(pack);
	CloseHandle(pack);
	
	if(IsClientInGame(iVictim)==false || IsPlayerAlive(iVictim)==false || IsValidEntity(iVictim) == false)
		return Plugin_Stop;
	
	DealDamage(iVictim, iAttacker, iDamage, DAMAGETYPE_BLOCK_REVIVING);
	
	if(IsClientInGame(iAttacker) == true && IsPlayerAlive(iAttacker) == true)
		PrintHintText(iAttacker, "You did %d extra pounce damage",  iDamage);
	
	return Plugin_Stop;
}

Action:TimerResetHunterDismount(Handle:timer, any:iClient)
{
	g_bCanHunterDismount[iClient] = true;
	return Plugin_Stop;
}

Action:TimerResetCanHunterPoison(Handle:timer, any:iClient)
{
	g_bCanHunterPoisonVictim[iClient] = true;
	return Plugin_Stop;
}

Action:TimerHunterPoison(Handle:timer, any:pack)
{
	if (pack == INVALID_HANDLE)
		return Plugin_Stop;
	ResetPack(pack);
	new iClient = ReadPackCell(pack); //iClient = victim

	if(IsClientInGame(iClient)==false || IsPlayerAlive(iClient)==false || g_iClientTeam[iClient] != TEAM_SURVIVORS)
	{
		CloseHandle(pack);
		
		g_bIsHunterPoisoned[iClient] = false;
		g_hTimer_HunterPoison[iClient] = null;
		return Plugin_Stop;
	}

	if(--g_iHunterPoisonRuntimesCounter[iClient] > 0)
	{
		if(IsFakeClient(iClient)==false)
			ShowHudOverlayColor(iClient, 0, 255, 0, 40, 140, FADE_IN);
		
		CreateTimer(0.5, TimerHunterPoisonFade, pack, TIMER_FLAG_NO_MAPCHANGE);	//Make the effect fade away and dmg iClient(victim)
		return Plugin_Continue;
	}
	
	CloseHandle(pack);

	g_bIsHunterPoisoned[iClient] = false;
	SetClientSpeed(iClient);

	if(IsFakeClient(iClient)==false)
		PrintHintText(iClient, "The venom has passed through your body.");
	
	g_hTimer_HunterPoison[iClient] = null;
	
	return Plugin_Stop;
}

Action:TimerHunterPoisonFade(Handle:timer, any:pack)
{
	if (pack == INVALID_HANDLE)
		return Plugin_Stop;
	ResetPack(pack);
	new victim = ReadPackCell(pack);
	new attacker = ReadPackCell(pack);

	if(IsValidEntity(victim) == false || IsClientInGame(victim)==false || IsPlayerAlive(victim)==false)
		return Plugin_Stop;
	
	DealDamage(victim, attacker, 4, DAMAGETYPE_BLOCK_REVIVING);
	
	g_iClientXP[attacker] += 10;
	CheckLevel(attacker);
	
	if(g_iXPDisplayMode[attacker] == 0)
		ShowXPSprite(attacker, g_iSprite_10XP_SI, victim, 1.0);
	
	WriteParticle(victim, "poison_bubbles", 0.0, 3.0);
	
	if(IsFakeClient(victim)==false)
		ShowHudOverlayColor(victim, 0, 255, 0, 40, 200, FADE_OUT);
	
	return Plugin_Stop;
}

// Action:TimerContinuousHunterPoison(Handle:timer, any:pack)
// {
// 	if (pack == INVALID_HANDLE)
// 		return Plugin_Stop;
	
// 	ResetPack(pack);
// 	new victim = ReadPackCell(pack);
// 	new attacker = ReadPackCell(pack);

// 	if( (IsValidEntity(victim) == false) || (IsClientInGame(victim) == false) || (IsPlayerAlive(victim) == false) || (g_bHunterLethalPoisoned[victim] == false))
// 	{
// 		PrintToChatAll("Stopping Lethal poison on victim");
// 		//Closing the handle to prevent invalid handle error
// 		CloseHandle(pack)
// 		return Plugin_Stop;
// 	}
// 	else
// 	{
// 		DealDamage(victim, attacker, 3, DAMAGETYPE_BLOCK_REVIVING);
// 		return Plugin_Continue;
// 	}
// }