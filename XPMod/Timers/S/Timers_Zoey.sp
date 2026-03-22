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

	SDKCall(g_hSDK_UnVomitOnPlayer, iVictim);
	return Plugin_Stop;
}

Action TimerZoeySacrificialAidBleedoutCheck(Handle timer, int iUserID)
{
	int iTarget = GetClientOfUserId(iUserID);
	if (RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		IsIncap(iTarget) == false)
	{
		if (iTarget > 0)
			StopZoeySacrificialAidBleedoutProtection(iTarget);

		g_hTimer_ZoeySacrificialAidBleedoutCheck[iTarget] = null;
		return Plugin_Stop;
	}

	if (g_fZoeySacrificialAidBleedoutStopEndTime[iTarget] <= GetGameTime())
	{
		StopZoeySacrificialAidBleedoutProtection(iTarget);
		g_hTimer_ZoeySacrificialAidBleedoutCheck[iTarget] = null;
		return Plugin_Stop;
	}

	int iCurrentIncapHealth = GetEntProp(iTarget, Prop_Data, "m_iHealth");
	if (iCurrentIncapHealth <= 0)
	{
		StopZoeySacrificialAidBleedoutProtection(iTarget);
		g_hTimer_ZoeySacrificialAidBleedoutCheck[iTarget] = null;
		return Plugin_Stop;
	}

	int iLastRecordedHealth = g_iZoeySacrificialAidBleedoutLastHealth[iTarget];
	if (iLastRecordedHealth > 0 &&
		iCurrentIncapHealth < iLastRecordedHealth)
	{
		int iHealthLost = iLastRecordedHealth - iCurrentIncapHealth;
		if (iHealthLost == 1)
		{
			SetEntProp(iTarget, Prop_Data, "m_iHealth", iCurrentIncapHealth + 1);
			iCurrentIncapHealth++;
		}
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

	g_iZoeyInstantInterventionCircleTicksRemaining[iCircleEntity]--;
	if (g_iZoeyInstantInterventionCircleTicksRemaining[iCircleEntity] <= 0)
	{
		g_iZoeyInstantInterventionCircleTicksRemaining[iCircleEntity] = 0;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}
