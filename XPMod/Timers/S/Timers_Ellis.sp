public Action:TimerStopFireStorm(Handle:timer, any:iClient)
{
	StopSound(iClient, SNDCHAN_AUTO, SOUND_ONFIRE);
	if(IsClientInGame(iClient)==false)
		return Plugin_Stop;
	if(IsPlayerAlive(iClient)==false)
		return Plugin_Stop;
	SetEntProp(iClient, Prop_Send, "m_iGlowType", 0);
	SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
	SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 0);
	ChangeEdictState(iClient, 12);
	SetEntityRenderMode(iClient, RenderMode:0);
	SetEntityRenderColor(iClient, 255, 255, 255, 255);
	g_bUsingFireStorm[iClient] = false;
	return Plugin_Stop;
}

public Action:TimerEllisPrimaryCycleReset(Handle:timer, any:iClient)
{
	g_bCanEllisPrimaryCycle[iClient] = true;
	return Plugin_Stop;
}

public Action:TimerEllisJamminGiveExplosive(Handle:timer, any:iClient)
{
	SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
	FakeClientCommand(iClient, "give molotov");
	g_iEventWeaponFireCounter[iClient] = 0;
	return Plugin_Stop;
}

public Action:TimerEllisLimitBreakReset(Handle:timer, any:iClient)
{
	g_bIsEllisLimitBreaking[iClient] = false;
	g_bEllisLimitBreakInCooldown[iClient] = true;
	PrintHintText(iClient, "Your weapon was destroyed and LIMIT BREAK is on cooldown! 60 seconds remaining");
	//PrintToChatAll("Ellis limit break has expired");
	if((StrEqual(g_strEllisPrimarySlot1, "empty", false) == false) && (StrEqual(g_strEllisPrimarySlot2, "empty", false) == false))
	{
		fnc_CycleWeapon(iClient);
		fnc_DeterminePrimaryWeapon(iClient);
		fnc_SetAmmo(iClient);
		fnc_SetAmmoUpgrade(iClient);
		fnc_ClearSavedWeaponData(iClient);
	}
	else
	{
		g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
		if (g_iPrimarySlotID[iClient] > -1) RemoveEdict(g_iPrimarySlotID[iClient]);
		fnc_ClearAllWeaponData(iClient);
	}
	/* //////////////Old setup///////////////
	fnc_ClearSavedWeaponData(iClient);
	g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
	RemoveEdict(g_iPrimarySlotID[iClient]);
	fnc_CycleWeapon(iClient);
	*/
	/* //Working but needs tweaking
	fnc_CycleWeapon(iClient);
	fnc_DeterminePrimaryWeapon(iClient);
	fnc_SetAmmo(iClient);
	fnc_SetAmmoUpgrade(iClient);
	fnc_ClearSavedWeaponData(iClient);
	*/
	/*
	if((StrEqual(g_strEllisPrimarySlot1, "empty", false) == true) || (StrEqual(g_strEllisPrimarySlot2, "empty", false) == true))
	{
		g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
		RemoveEdict(g_iPrimarySlotID[iClient]);
	}
	*/
	return Plugin_Stop;
}

public Action:TimerEllisLimitBreakCooldown(Handle:timer, any:iClient)
{
	g_bCanEllisLimitBreak[iClient] = true;
	g_bEllisLimitBreakInCooldown[iClient] = false;
	PrintHintText(iClient, "Your LIMIT BREAK is ready!");
	//PrintToChatAll("Ellis limit break has cooled down");
	return Plugin_Stop;
}
/*
public Action:TimerCheckEllisHealth(Handle:timer, any:iClient)
{
	new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
	new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);
	//fTempHealth = 0;
	//fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);
	new Float:fTempHealthTimer = GetEntDataFloat(iClient, g_iOffset_HealthBufferTime); //g_iOffset_HealthBufferTime
	//PrintToChatAll("Current Health = %d Max Health = %d Temp Health = %f Time = %f", iCurrentHealth, iMaxHealth, fTempHealth, fTempHealthTimer);
	if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - 20.0))
	{
		g_fEllisOverSpeed[iClient] = 0.0;
		SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iClient] + g_fEllisBringSpeed[iClient] + g_fEllisOverSpeed[iClient]), true);
		//DeleteCode
		//PrintToChatAll("Timer Tick: Ellis Over speed lost");
	}
	else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
	{
		g_fEllisOverSpeed[iClient] = (g_iOverLevel[iClient] * 0.02);
		SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer", "m_flLaggedMovementValue"), (1.0 + g_fEllisJamminSpeed[iClient] + g_fEllisBringSpeed[iClient] + g_fEllisOverSpeed[iClient]), true);
		//DeleteCode
		//PrintToChatAll("Timer Tick: Ellis Over speed still in effect");
		CreateTimer(1.0, TimerCheckEllisHealth, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
}
*/