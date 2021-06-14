void OnPlayerRunCmd_BileCleanse(int iClient, &iButtons)
{
	// If they started a bile cleanse, handle if something prevented contiuation
	if (g_iBileCleansingFrameTimeCtr[iClient] >= 0 && 
		(!(iButtons & IN_USE) || 
		 IsClientGrappled(iClient) == true || 
		 GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1) )
	{
		g_iBileCleansingFrameTimeCtr[iClient] = -1;

		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Bile Cleansing Interrupted...");
	}
	
	// Make sure the player is actually biled before continuing
	if (g_iVomitVictimAttacker[iClient] == 0)
		return;

	// Check that the player has a self revive and is pressing the button while incap
	if (g_iBileCleansingKits[iClient] <= 0 ||
		!(iButtons & IN_USE) ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS || 
		RunClientChecks(iClient) == false ||
		IsClientGrappled(iClient) == true ||
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1 ||
		IsFakeClient(iClient) == true)
		return;

	DebugLog(DEBUG_MODE_VERBOSE, "OnPlayerRunCmd_BileCleanse");

	// Increment the frame counter to measure time the USE button has been pressed
	g_iBileCleansingFrameTimeCtr[iClient]++;

	// Display that they are using the kit
	if (g_iBileCleansingFrameTimeCtr[iClient] == 15)
		PrintHintText(iClient, "Using Bile Cleansing Kit...");

	// Use the bile cleansing kit
	if (g_iBileCleansingFrameTimeCtr[iClient] >= BILE_CLEANSING_COMPLETION_FRAME)
	{
		g_iBileCleansingFrameTimeCtr[iClient] = -1;
		g_iBileCleansingKits[iClient]--;

		SDKCall(g_hSDK_UnVomitOnPlayer, iClient);

		PrintHintText(iClient, "%i Bile Cleansing Kit%s Remaining",
			g_iBileCleansingKits[iClient],
			g_iBileCleansingKits[iClient] == 1 ? "" : "s");
	}
}

void OnPlayerRunCmd_SelfRevive(int iClient, &iButtons)
{
	// The GetEntProp method for getting buttons doesnt work for IN_USE
	// while incap, but it will still be caught in here. So, stop the
	// self revive if they let go.
	// Note: this is apparently stoppeed by being hit by CI. In order
	// to disable this, perhaps make a counter to check how long the
	// IN_USE has been let go before calling EndSelfRevive
	if (g_bSelfReviving[iClient] == true && !(iButtons & IN_USE))
		EndSelfRevive(iClient);

	// Check that the player has a self revive and is pressing the button while incap
	if (g_iSelfRevives[iClient] <= 0 ||
		!(iButtons & IN_USE) ||
		g_bSelfReviving[iClient] == true ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS || 
		RunClientChecks(iClient) == false ||
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 0 ||
		IsFakeClient(iClient))
		return;

	DebugLog(DEBUG_MODE_VERBOSE, "OnPlayerRunCmd_SelfRevive");

	StartSelfRevive(iClient);
}

void StartSelfRevive(int iClient)
{
	DebugLog(DEBUG_MODE_VERBOSE, "StartSelfRevive");

	// Note, its very important to check if someone else is reviving
	// here. Notice the last line of this if statement.  If they are,
	// then do not continue with self revive or they will never to go down
	if (g_bSelfReviving[iClient] == true ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS || 
		IsClientGrappled(iClient) ||
		RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) ||
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 0 ||
		GetEntPropEnt(iClient, Prop_Send, "m_reviveOwner") != -1)
		return;
	
	g_bSelfReviving[iClient] = true;
	g_fSelfRevivingFinishTime[iClient] = GetGameTime() + SELF_REVIVE_TIME;
	SetEntPropFloat(iClient, Prop_Send, "m_flProgressBarStartTime", GetGameTime());
	SetEntPropFloat(iClient, Prop_Send, "m_flProgressBarDuration", SELF_REVIVE_TIME);
	SetEntPropEnt(iClient, Prop_Send, "m_reviveOwner", iClient);

	delete g_hTimer_SelfReviveCheck[iClient];
	g_hTimer_SelfReviveCheck[iClient] = CreateTimer(0.1, TimerSelfReviveCheck, iClient, TIMER_REPEAT);
}

Action:TimerSelfReviveCheck(Handle:timer, any:iClient)
{
	DebugLog(DEBUG_MODE_VERBOSE, "TimerSelfReviveCheck");
	if (g_iClientTeam[iClient] != TEAM_SURVIVORS || 
		IsClientGrappled(iClient) ||
		RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) ||
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 0)
	{
		EndSelfRevive(iClient);
		g_hTimer_SelfReviveCheck[iClient] = null;
		return Plugin_Stop;
	}
	
	//Check for a completed self revive
	if (g_fSelfRevivingFinishTime[iClient] <= GetGameTime() && 
		g_fSelfRevivingFinishTime[iClient] > 0 &&
		g_bSelfReviving[iClient])
	{
		SuccessfulSelfRevive(iClient);
	}
	// Check if still self reviving and continue
	else if (g_bSelfReviving[iClient])
	{
		return Plugin_Continue;
	}

	EndSelfRevive(iClient);
	g_hTimer_SelfReviveCheck[iClient] = null;
	return Plugin_Stop;
}

void SuccessfulSelfRevive(int iClient)
{
	DebugLog(DEBUG_MODE_VERBOSE, "SuccessfulSelfRevive");
	bool bIsLedgeRevive = GetEntProp(iClient, Prop_Send, "m_isHangingFromLedge") == 1;

	// Revive them by using cheat command to give full health
	RunCheatCommand(iClient, "give", "give health");

	g_bIsClientDown[iClient] = false;

	if (bIsLedgeRevive)
	{
		// If its a self revive off ledge, Use the stored health values
		if (g_iPlayerHealth[iClient] <= 1)
			g_iPlayerHealth[iClient] = 1;
		// Change health to self revive health
		SetEntProp(iClient, Prop_Data,"m_iHealth", g_iPlayerHealth[iClient]);
		// Change temp health to self revive health
		ResetTempHealthToSurvivor(iClient);
		AddTempHealthToSurvivor(iClient, float(g_iPlayerHealthTemp[iClient]));
	}
	else
	{
		// Change health to self revive health
		SetEntProp(iClient, Prop_Data,"m_iHealth", SELF_REVIVE_HEALTH);
		// Change temp health to self revive health
		ResetTempHealthToSurvivor(iClient);
		AddTempHealthToSurvivor(iClient, float(SELF_REVIVE_TEMP_HEALTH));
	}

	// We must now handle this, instead of the game.
	SetEntPropFloat(iClient, Prop_Send, "m_flProgressBarStartTime", GetGameTime());
	SetEntPropFloat(iClient, Prop_Send, "m_flProgressBarDuration", 0.0);
	SetEntPropEnt(iClient, Prop_Send, "m_reviveOwner", -1);

	// Remove the self revive from the client
	g_iSelfRevives[iClient]--;
}

void EndSelfRevive(int iClient)
{
	DebugLog(DEBUG_MODE_VERBOSE, "EndSelfRevive");
	if (RunClientChecks(iClient) == false)
		return;
	
	g_bSelfReviving[iClient] = false;
	g_fSelfRevivingFinishTime[iClient] = -1.0;

	// We must now handle this, instead of the game, if the player stoppeed a self revive
	if (GetEntPropEnt(iClient, Prop_Send, "m_reviveOwner") == iClient)
	{
		SetEntPropFloat(iClient, Prop_Send, "m_flProgressBarStartTime", GetGameTime());
		SetEntPropFloat(iClient, Prop_Send, "m_flProgressBarDuration", 0.0);
		SetEntPropEnt(iClient, Prop_Send, "m_reviveOwner", -1);
	}
}

void ResetTempHealthToSurvivor(iClient)
{
	if (!RunClientChecks(iClient) || 
		!IsPlayerAlive(iClient) || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1)
        return;
	
	SetEntPropFloat(iClient, Prop_Send, "m_healthBuffer", 0.0);
}

void AddTempHealthToSurvivor(int iClient, float fAdditionalTempHealth, bool bRespectMaxHealth = true)
{
	if (!RunClientChecks(iClient) || 
		!IsPlayerAlive(iClient) || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
        return;
	
	// Calculate the current surivivors temp health
	new iTempHealth = GetSurvivorTempHealth(iClient);
	if (iTempHealth < 0)
		return;

	// Cap fAdditionalTempHealth to Max Health if option selected
	if (bRespectMaxHealth)
	{
		new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
		new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");

		// This will go over max health, so cap the additional amount given if true
		if (iCurrentHealth + iTempHealth + RoundToNearest(fAdditionalTempHealth) > iMaxHealth)
			fAdditionalTempHealth = float(iMaxHealth - iCurrentHealth - iTempHealth);
	}
	
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

int GetActiveWeaponSlot(const int iClient, int iActiveWeaponID = -1)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return -1;

	// If there was no weapon id provided, get it
	if (RunEntityChecks(iActiveWeaponID) == false)
	{
		iActiveWeaponID = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
	
		// No valid weapon id was found
		if (iActiveWeaponID == -1)
			return -1;
	}

	// return the slot they are using
	for (int i=0; i < 5; i++)
		if (GetPlayerWeaponSlot(iClient, i) == iActiveWeaponID)
			return i;

	return -1;
}

int SpawnItem(float xyzLocation[3], int itemIndex, const float fZOffset = 0.0)
{
	//PrintToChatAll("spawn loc: %f, %f, %f", xyzLocation[0], xyzLocation[1], xyzLocation[2]);

	int iEntity = -1;
	iEntity = CreateEntityByName(ITEM_CLASS_NAME[itemIndex]);
	if( iEntity == -1 )
	{
		ThrowError("Failed to create entity '%s'", ITEM_CLASS_NAME[itemIndex]);
		return -1;
	}
	DispatchKeyValue(iEntity, "solid", "6");
	DispatchKeyValue(iEntity, "model", ITEM_MODEL_PATH[itemIndex]);
	DispatchKeyValue(iEntity, "rendermode", "3");
	DispatchKeyValue(iEntity, "disableshadows", "1");

	xyzLocation[2] += fZOffset;
	float xyzVelocity[3] = {0.0, 0.0, 300.0};
	DispatchSpawn(iEntity);

	// Its required to teleport after spawn or velocity wont work
	TeleportEntity(iEntity, xyzLocation, NULL_VECTOR, xyzVelocity);

	return iEntity;
}