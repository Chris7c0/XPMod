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

Action:TimerEllisJamminGiveMolotov(Handle:timer, any:iClient)
{
	// g_iEventWeaponFireCounter[iClient] = 0;

	if (RunClientChecks(iClient) == false || 
		IsFakeClient(iClient))
		return Plugin_Stop;

	RunCheatCommand(iClient, "give", "give molotov");

	return Plugin_Stop;
}

Action:TimerGiveAdrenalineFromStashedInventory(Handle:timer, int iClient)
{
	if (g_iStashedInventoryAdrenaline[iClient] > 0)
	{
		g_iStashedInventoryAdrenaline[iClient]--;
		
		RunCheatCommand(iClient, "give", "give adrenaline");
		PrintToChat(iClient, "\x03[XPMod] \x04You have %i more Adrenaline Shot%s.",
						g_iStashedInventoryAdrenaline[iClient],
						g_iStashedInventoryAdrenaline[iClient] != 1 ? "s" : "");
	}

	return Plugin_Stop;
}

Action:TimerRemoveEllisAdrenalineBuffs(Handle:timer, any:iClient)
{
	g_bEllisHasAdrenalineBuffs[iClient] = false;

	return Plugin_Stop;
}

Action:TimerEllisLimitBreakReset(Handle:timer, any:iClient)
{
	g_bIsEllisLimitBreaking[iClient] = false;
	g_bEllisLimitBreakInCooldown[iClient] = true;

	// Find Ellis's primary slot that has the limit break weapon
	int iLimitBreakWeaponSlot = g_iEllisPrimarySlot0[iClient] == g_iLimitBreakWeaponIndex[iClient] ? 0 : g_iEllisPrimarySlot1[iClient] == g_iLimitBreakWeaponIndex[iClient] ? 1 : -1;
	// Set this for later
	g_iLimitBreakWeaponIndex[iClient] = -1;

	// If they dont have the limit break weapon, then no need to continue
	if (iLimitBreakWeaponSlot == -1)
		return Plugin_Stop;

	// PrintToChat(iClient, "iLimitBreakWeaponSlot: %i", iLimitBreakWeaponSlot);	

	// Get their current primary weapon id
	int iCurrentPrimaryID = GetPlayerWeaponSlot(iClient, 0);
	if (RunEntityChecks(iCurrentPrimaryID) == false)
		return Plugin_Stop;

	// Get the weapon index
	int iCurrentPrimaryWeaponIndex = FindWeaponItemIndexOfWeaponID(iClient, iCurrentPrimaryID);
	if (iCurrentPrimaryWeaponIndex == ITEM_EMPTY)
		return Plugin_Stop;

	// PrintToChatAll("LIMIT BREAK RESET: %s, %s", ITEM_NAME[g_iEllisPrimarySlot0[iClient]], ITEM_NAME[g_iEllisPrimarySlot1[iClient]]);
	
	// Check if the user has slot the limit break weapon in slot 0
	if (iLimitBreakWeaponSlot == 0)
	{
		// If they currently have the limit break slot selected...
		if (g_iEllisCurrentPrimarySlot[iClient] == 0)
		{
			// PrintToChat(iClient, "g_iEllisPrimarySlot1[iClient]: %i", g_iEllisPrimarySlot1[iClient]);
			// Check if they have another weapon, if so weapon cycle to it then empty the other slot
			if (g_iEllisPrimarySlot1[iClient] != ITEM_EMPTY)
			{
				CyclePlayerWeapon(iClient);
				g_bSetWeaponAmmoOnNextGameFrame[iClient] = true;
			}
			// Otherwise kill their current primary weapon
			else
			{
				AcceptEntityInput(iCurrentPrimaryID, "Kill");
			}
		}

		// Clear the slot with the limit break weapon
		g_iEllisPrimarySlot0[iClient] = ITEM_EMPTY
		g_iEllisPrimarySavedClipSlot0[iClient] = 0;
		g_iEllisPrimarySavedAmmoSlot0[iClient] = 0;
	}
	// Check if the user has slot the limit break weapon in slot 1
	else if (iLimitBreakWeaponSlot == 1)
	{
		// If they currently have the limit break slot selected...
		if (g_iEllisCurrentPrimarySlot[iClient] == 1)
		{
			// PrintToChat(iClient, "g_iEllisPrimarySlot0[iClient]: %i", g_iEllisPrimarySlot0[iClient]);	
			// Check if they have another weapon, if so weapon cycle to it then empty the other slot
			if (g_iEllisPrimarySlot0[iClient] != ITEM_EMPTY)
			{
				CyclePlayerWeapon(iClient);
				g_bSetWeaponAmmoOnNextGameFrame[iClient] = true;
			}
			// Otherwise kill their current primary weapon
			else
			{
				AcceptEntityInput(iCurrentPrimaryID, "Kill");
			}
		}

		// Clear the slot with the limit break weapon
		g_iEllisPrimarySlot1[iClient] = ITEM_EMPTY
		g_iEllisPrimarySavedClipSlot1[iClient] = 0;
		g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
	}

	// PrintToChatAll("LIMIT BREAK AFTER: %s, %s", ITEM_NAME[g_iEllisPrimarySlot0[iClient]], ITEM_NAME[g_iEllisPrimarySlot1[iClient]]);	

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