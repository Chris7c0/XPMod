Action:TimerStopFireStorm(Handle:timer, any:iClient)
{
	g_bUsingFireStorm[iClient] = false;

	if(RunClientChecks(iClient)==false || IsPlayerAlive(iClient)==false)
		return Plugin_Stop;

	StopSound(iClient, SNDCHAN_AUTO, SOUND_ONFIRE);
	
	SetEntProp(iClient, Prop_Send, "m_iGlowType", 0);
	SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
	SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 0);

	ChangeEdictState(iClient, 12);

	SetEntityRenderMode(iClient, RenderMode:0);
	SetEntityRenderColor(iClient, 255, 255, 255, 255);
	
	return Plugin_Stop;
}

Action:TimerEllisPrimaryCycleReset(Handle:timer, any:iClient)
{
	g_bCanEllisPrimaryCycle[iClient] = true;
	return Plugin_Stop;
}

Action:TimerEllisJamminGiveExplosive(Handle:timer, any:iClient)
{
	g_iEventWeaponFireCounter[iClient] = 0;
	
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient))
		return Plugin_Stop;
	

	RunCheatCommand(iClient, "give", "give molotov");
	
	return Plugin_Stop;
}

Action:TimerEllisLimitBreakReset(Handle:timer, any:iClient)
{
	g_bIsEllisLimitBreaking[iClient] = false;
	g_bEllisLimitBreakInCooldown[iClient] = true;

	if (RunClientChecks(iClient) && IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Your weapon was destroyed and LIMIT BREAK is on cooldown! 60 seconds remaining");
	
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

		if (g_iPrimarySlotID[iClient] > -1)
			AcceptEntityInput(g_iPrimarySlotID[iClient], "Kill");

		fnc_ClearAllWeaponData(iClient);
	}
	/* //////////////Old setup///////////////
	fnc_ClearSavedWeaponData(iClient);
	g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
	AcceptEntityInput(g_iPrimarySlotID[iClient]);
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
		AcceptEntityInput(g_iPrimarySlotID[iClient]);
	}
	*/
	return Plugin_Stop;
}

Action:TimerEllisLimitBreakCooldown(Handle:timer, any:iClient)
{
	g_bCanEllisLimitBreak[iClient] = true;
	g_bEllisLimitBreakInCooldown[iClient] = false;

	if (RunClientChecks(iClient) && IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Your LIMIT BREAK is ready!");
	
	return Plugin_Stop;
}