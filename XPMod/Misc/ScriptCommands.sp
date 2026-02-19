stock void L4D2_RunScript(const char[] sCode, any ...)
{
	static iScriptLogic = INVALID_ENT_REFERENCE;
	if(iScriptLogic == INVALID_ENT_REFERENCE || !IsValidEntity(iScriptLogic)) 
	{
		iScriptLogic = EntIndexToEntRef(CreateEntityByName("logic_script"));
		if(iScriptLogic == INVALID_ENT_REFERENCE || !IsValidEntity(iScriptLogic))
			SetFailState("Could not create 'logic_script'");
		
		DispatchSpawn(iScriptLogic);
	}
	
	static char sBuffer[512];
	VFormat(sBuffer, sizeof(sBuffer), sCode, 2);
	
	SetVariantString(sBuffer);
	AcceptEntityInput(iScriptLogic, "RunScriptCode");
}

stock void SendAllSurvivorBotsFocusedOnXPMGoal(float xyzLocation[3], int iTarget = -1)
{
	for (int iClient = 1; iClient <= MaxClients; iClient++)
		SetBotFocusedOnXPMGoal(iClient, xyzLocation, iTarget);
}

stock void SetBotFocusedOnXPMGoal(int iClient, float xyzLocation[3], int iTarget = -1)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		IsFakeClient(iClient) == false)
		return;

	g_iBotXPMGoalTarget[iClient] = iTarget;
	g_xyzBotXPMGoalLocation[iClient][0] = xyzLocation[0];
	g_xyzBotXPMGoalLocation[iClient][1] = xyzLocation[1];
	g_xyzBotXPMGoalLocation[iClient][2] = xyzLocation[2];
	g_bBotXPMGoalAccomplished[iClient] = false;
	delete g_hTimer_TimerKeepBotFocusedOnXPModGoal[iClient];
	g_hTimer_TimerKeepBotFocusedOnXPModGoal[iClient] = CreateTimer(0.1, TimerKeepBotFocusedOnXPMGoal, iClient, TIMER_REPEAT)

	PrintToServer("SetBotFocusedOnXPMGoal %i", iClient);
}

Action TimerKeepBotFocusedOnXPMGoal(Handle timer, int iClient)
{
	if (g_bBotXPMGoalAccomplished[iClient] == true ||
		RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false ||
		IsFakeClient(iClient) == false)
	{
		PrintToServer("Bot Lost Focus On Goal %i", iClient);

		g_hTimer_TimerKeepBotFocusedOnXPModGoal[iClient] = null;
		return Plugin_Stop;
	}


	float fGameTime = GetGameTime();
	if (fGameTime - g_fGameTimeOfLastGoalSet[iClient] <= 5.0 ||
		fGameTime - g_fGameTimeOfLastDamageTaken[iClient] <= 5.0 ||
		fGameTime - g_fGameTimeOfLastViableTargetSeen[iClient] <= 5.0)
		return Plugin_Continue;


	if (CheckForViableSITargetForSurvivor(iClient))
		return Plugin_Continue;


	// Set their focus on the goal
	g_fGameTimeOfLastGoalSet[iClient] = fGameTime;
	SendBotToLocation(iClient, g_xyzBotXPMGoalLocation[iClient]);

	return Plugin_Continue;
}

bool CheckForViableSITargetForSurvivor(int iClient)
{
	float xyzClientLocation[3], xyzTargetLocation[3];
	GetClientEyePosition(iClient, xyzClientLocation);

	// Check for visible targets that are within range
	for (int iTarget; iTarget <= MaxClients; iTarget++)
	{
		if (RunClientChecks(iTarget) == false || 
			g_iClientTeam[iTarget] != TEAM_INFECTED ||
			IsPlayerAlive(iTarget) == false)
			continue;

		GetClientEyePosition(iTarget, xyzTargetLocation);
		// Get if the target is visible to and check the range if target to worry about
		if (IsVisibleTo(xyzClientLocation, xyzTargetLocation) &&
			GetVectorDistance(xyzClientLocation, xyzTargetLocation) < 1500.0)
		{
			// Its a potential threat, reset focus and kill it
			PrintToChatAll("Viable Target %N Spotted by %N", iTarget, iClient);
			ResetBotCommand(iClient);
			g_fGameTimeOfLastViableTargetSeen[iClient] = GetGameTime();
			return true;
		}
	}

	return false;
}

stock void SendAllSurvivorBotsToLocation(float xyzLocation[3])
{
	for (int iClient = 1; iClient <= MaxClients; iClient++)
		SendBotToLocation(iClient, xyzLocation);
}

stock void SendBotToLocation(int iClient, float xyzLocation[3])
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false ||
		IsFakeClient(iClient) == false)
		return;

	PrintToChatAll("Sending bot %N to location.", iClient);
	// Note they will do this wihotut stopping to shoot, so need to handle dmamage elsewhere
	L4D2_RunScript("CommandABot({cmd=1,pos=Vector(%f,%f,%f),bot=GetPlayerFromUserID(%i)})",
		xyzLocation[0],
		xyzLocation[1],
		xyzLocation[2], 
		GetClientUserId(iClient));
}

stock void ResetBotCommand(int iClient)
{
	if (g_bBotXPMGoalAccomplished[iClient] == true ||
		RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) == false ||
		IsFakeClient(iClient) == false)
		return;

	PrintToChatAll("Resetting bot commands for %N", iClient);

	L4D2_RunScript("CommandABot({cmd=3,bot=GetPlayerFromUserID(%i)})",
		GetClientUserId(iClient));
}
