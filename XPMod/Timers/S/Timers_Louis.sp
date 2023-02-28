Action:LouisTeleportReenable(Handle:timer, any:iClient)
{
	g_bLouisTeleportCoolingDown[iClient] = false;
	return Plugin_Stop;
}

Action:TimerSetLouisTeleportInactive(Handle:timer, any:iClient)
{
	g_bLouisTeleportActive[iClient] = false;
	SetClientSpeed(iClient);
	
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

Action:TimerLouisTeleportRemoveMovementSpeedPenalty(Handle:timer, any:iClient)
{
	g_iLouisTeleportMovementPenaltyStacks[iClient]--;

	if (g_iLouisTeleportMovementPenaltyStacks[iClient] < 0)
		g_iLouisTeleportMovementPenaltyStacks[iClient] = 0;

	if (g_bLouisTeleportActive[iClient] == false)
		SetClientSpeed(iClient);
	
	return Plugin_Stop;
}

Action:TimerLouisCIHeadshotReduce(Handle:timer, any:iClient)
{
	g_iLouisCIHeadshotCounter[iClient]--;

	if (g_iLouisCIHeadshotCounter[iClient] < 0)
		g_iLouisCIHeadshotCounter[iClient] = 0;

	if (g_bLouisTeleportActive[iClient] == false)
		SetClientSpeed(iClient);
	
	return Plugin_Stop;
}

Action:TimerLouisSIHeadshotReduce(Handle:timer, any:iClient)
{
	g_iLouisSIHeadshotCounter[iClient]--;

	if (g_iLouisSIHeadshotCounter[iClient] < 0)
		g_iLouisSIHeadshotCounter[iClient] = 0;

	if (g_bLouisTeleportActive[iClient] == false)
		SetClientSpeed(iClient);
	
	return Plugin_Stop;
}

Action:TimerLouisPillsUsedStackReduce(Handle:timer, any:iClient)
{
	g_iPillsUsedStack[iClient]--;

	if (RunClientChecks(iClient) && IsFakeClient(iClient) == false)
		PrintToChat(iClient, "\x03[XPMod] \x04Pills x%i", g_iPillsUsedStack[iClient]);
	
	if (g_iPillsUsedStack[iClient] < 0)
		g_iPillsUsedStack[iClient] = 0;

	if (g_bLouisTeleportActive[iClient] == false)
		SetClientSpeed(iClient);
	
	return Plugin_Stop;
}

Action:TimerGivePillsFromStashedInventory(Handle:timer, int iClient)
{
	if (g_iStashedInventoryPills[iClient] > 0)
	{
		g_iStashedInventoryPills[iClient]--;
		
		RunCheatCommand(iClient, "give", "give pain_pills");
		PrintToChat(iClient, "\x03[XPMod] \x04You have %i more Pill Bottle%s.",
						g_iStashedInventoryPills[iClient],
						g_iStashedInventoryPills[iClient] != 1 ? "s" : "");
	}

	return Plugin_Stop;
}