Action:LouisTeleportReactivate(Handle:timer, any:iClient)
{
	g_bLouisTeleportCoolingDown[iClient] = false;
	return Plugin_Stop;
}

Action:TimerLouisTeleportChargeRegenerate(Handle:timer, any:iClient)
{
	g_iLouisTeleportChargeUses[iClient]--;

	if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
	{
		PrintLouisTeleportCharges(iClient);

		EmitSoundToClient(iClient, SOUND_LOUIS_TELEPORT_USE_REGEN);
		//EmitSoundToAll(SOUND_LOUIS_TELEPORT_USE_REGEN, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, pos, NULL_VECTOR, true, 0.0);
	}

	if (g_iLouisTeleportChargeUses[iClient] > 0)
		return Plugin_Continue;

	g_hTimer_LouisTeleportRegenerate[iClient] = null;
	return Plugin_Stop;
}

Action:TimerLouisTeleportChargeResetAll(Handle:timer, any:iClient)
{
	g_iLouisTeleportChargeUses[iClient] = 0;

	if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
	{
		PrintLouisTeleportCharges(iClient);

		EmitSoundToClient(iClient, SOUND_LOUIS_TELEPORT_USE_REGEN);
		//EmitSoundToAll(SOUND_LOUIS_TELEPORT_USE_REGEN, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, pos, NULL_VECTOR, true, 0.0);
	}
	
	return Plugin_Stop;
}

Action:TimerLouisCIHeadshotReduce(Handle:timer, any:iClient)
{
	g_iLouisCIHeadshotCounter[iClient]--;
	SetClientSpeed(iClient);
	
	return Plugin_Stop;
}

Action:TimerLouisSIHeadshotReduce(Handle:timer, any:iClient)
{
	g_iLouisSIHeadshotCounter[iClient]--;
	SetClientSpeed(iClient);
	
	return Plugin_Stop;
}