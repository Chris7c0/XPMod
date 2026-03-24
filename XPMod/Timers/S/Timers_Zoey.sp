void Handle1SecondClientTimers_Zoey(int iClient)
{
	if (g_iZoeySacrificialAidRegenTicksRemaining[iClient] <= 0)
		return;

	int iTarget = GetClientOfUserId(g_iZoeySacrificialAidRegenTargetUserId[iClient]);
	if (RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		IsZoeyClientDownedOrHanging(iTarget) ||
		IsIncap(iTarget))
	{
		g_iZoeySacrificialAidRegenTicksRemaining[iClient] = 0;
		g_iZoeySacrificialAidRegenTargetUserId[iClient] = 0;
		return;
	}

	ApplyZoeySharingIsCaringPermanentHeal(iTarget, ZOEY_SACRIFICIAL_AID_MAJOR_REGEN_HP_PER_TICK);

	g_iZoeySacrificialAidRegenTicksRemaining[iClient]--;
	if (g_iZoeySacrificialAidRegenTicksRemaining[iClient] <= 0)
		g_iZoeySacrificialAidRegenTargetUserId[iClient] = 0;
}

Action TimerZoeyMeleeSwapCooldown(Handle timer, int iClient)
{
	g_bCanZoeyMeleeSwap[iClient] = true;
	return Plugin_Stop;
}

Action TimerZoeyRestoreStashedMelee(Handle timer, int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_bTalentsConfirmed[iClient] == false ||
		g_strZoeyStashedMelee[iClient][0] == '\0')
	{
		return Plugin_Stop;
	}

	char strGiveCmd[64];
	FormatEx(strGiveCmd, sizeof(strGiveCmd), "give %s", g_strZoeyStashedMelee[iClient]);
	RunCheatCommand(iClient, "give", strGiveCmd);

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "%s", g_strZoeyStashedMelee[iClient]);

	return Plugin_Stop;
}

Action TimerZoeyCleanupDirectStashWorldEntity(Handle timer, int iEntityRef)
{
	int iEntity = EntRefToEntIndex(iEntityRef);
	if (RunEntityChecks(iEntity) == true)
		KillEntitySafely(iEntity);

	return Plugin_Stop;
}

Action TimerZoeyMedicalExpertiseEndBile(Handle timer, Handle hDataPackage)
{
	ResetPack(hDataPackage);
	int iUserID = ReadPackCell(hDataPackage);
	int iSerial = ReadPackCell(hDataPackage);
	delete hDataPackage;

	int iVictim = GetClientOfUserId(iUserID);
	if (RunClientChecks(iVictim) == false ||
		IsPlayerAlive(iVictim) == false ||
		g_iClientTeam[iVictim] != TEAM_SURVIVORS ||
		g_iZoeyMedicalExpertiseBileSerial[iVictim] != iSerial)
	{
		return Plugin_Stop;
	}

	RemoveSurvivorBile(iVictim);
	return Plugin_Stop;
}

Action TimerZoeySacrificialAidBleedoutCheck(Handle timer, int iTarget)
{
	if (RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		IsIncap(iTarget) == false)
	{
		g_fZoeySacrificialAidBleedoutStopEndTime[iTarget] = -1.0;
		g_iZoeySacrificialAidBleedoutLastHealth[iTarget] = 0;
		g_hTimer_ZoeySacrificialAidBleedoutCheck[iTarget] = null;
		return Plugin_Stop;
	}

	if (g_fZoeySacrificialAidBleedoutStopEndTime[iTarget] <= GetGameTime())
	{
		g_fZoeySacrificialAidBleedoutStopEndTime[iTarget] = -1.0;
		g_iZoeySacrificialAidBleedoutLastHealth[iTarget] = 0;
		g_hTimer_ZoeySacrificialAidBleedoutCheck[iTarget] = null;
		return Plugin_Stop;
	}

	int iCurrentIncapHealth = GetEntProp(iTarget, Prop_Data, "m_iHealth");
	if (iCurrentIncapHealth <= 0)
	{
		g_fZoeySacrificialAidBleedoutStopEndTime[iTarget] = -1.0;
		g_iZoeySacrificialAidBleedoutLastHealth[iTarget] = 0;
		g_hTimer_ZoeySacrificialAidBleedoutCheck[iTarget] = null;
		return Plugin_Stop;
	}

	int iLastRecordedHealth = g_iZoeySacrificialAidBleedoutLastHealth[iTarget];
	if (iLastRecordedHealth > 0 &&
		iCurrentIncapHealth < iLastRecordedHealth)
	{
		SetEntProp(iTarget, Prop_Data, "m_iHealth", iLastRecordedHealth);
		iCurrentIncapHealth = iLastRecordedHealth;
	}

	g_iZoeySacrificialAidBleedoutLastHealth[iTarget] = iCurrentIncapHealth;
	return Plugin_Continue;
}

Action TimerZoeyInstantInterventionHealingCircleTick(Handle timer, int iCircleEntity)
{
	if (RunEntityChecks(iCircleEntity) == false ||
		g_iZoeyInstantInterventionCircleTicksRemaining[iCircleEntity] <= 0)
	{
		g_iZoeyInstantInterventionCircleTicksRemaining[iCircleEntity] = 0;
		return Plugin_Stop;
	}

	HealZoeyInstantInterventionCircle(g_xyzZoeyInstantInterventionCircleOrigin[iCircleEntity]);
	DrawZoeyHealingCircleRing(g_xyzZoeyInstantInterventionCircleOrigin[iCircleEntity]);

	g_iZoeyInstantInterventionCircleTicksRemaining[iCircleEntity]--;
	if (g_iZoeyInstantInterventionCircleTicksRemaining[iCircleEntity] <= 0)
	{
		g_iZoeyInstantInterventionCircleTicksRemaining[iCircleEntity] = 0;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}
