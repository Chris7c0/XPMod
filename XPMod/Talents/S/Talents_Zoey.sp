void TalentsLoad_Zoey(int iClient)
{
	ClearZoeyInstantInterventionState(iClient);
	g_fZoeyResilienceEndTime[iClient] = -1.0;
	g_fZoeyResilienceDamageReduction[iClient] = 0.0;
	g_iZoeyQueuedReviveResumeTarget[iClient] = -1;
	g_fZoeyQueuedReviveResumeDuration[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeProgress[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeAllowedUntil[iClient] = -1.0;
	g_bZoeyExplosiveAmmoActive[iClient] = false;
	g_fZoeyExplosiveAmmoCooldownEndTime[iClient] = -1.0;
	g_bZoeyExplosiveAmmoLoadPending[iClient] = false;
	g_fZoeyLastTriggerHappyShotTime[iClient] = -1.0;
	g_bZoeyMopArmed[iClient] = false;
	g_iZoeyMopCharge[iClient] = 0;
	g_iZoeyMopHitCounter[iClient] = 0;
	g_bZoeyWalkReloadHeld[iClient] = false;
	g_bZoeyWalkUseHeld[iClient] = false;
	g_fZoeyPrimaryStripHintCooldown[iClient] = 0.0;
	g_bZoeySuppressSyntheticCIHurt[iClient] = false;
	g_bZoeySurvivorsWillCharging[iClient] = false;
	g_fZoeySurvivorsWillChargeStartTime[iClient] = -1.0;
	g_fZoeySurvivorsWillRevealEndTime[iClient] = -1.0;
	g_fZoeySurvivorsWillNextMistTime[iClient] = 0.0;
	g_iZoeySharingTrackedTempHealth[iClient] = -1;
	g_iZoeySharingTrackedBoostType[iClient] = ZOEY_SHARING_TRACKED_BOOST_NONE;
	g_iZoeySharingTrackedMedkitTargetUserId[iClient] = 0;
	g_iZoeySharingTrackedMedkitTargetHealthBefore[iClient] = -1;
	g_iZoeyMedicalExpertisePillsReviveCounter[iClient] = 0;
	g_iZoeyMedicalExpertiseMedkitReviveCounter[iClient] = 0;
	g_iZoeySacrificialAidMenuTarget[iClient] = -1;
	g_iZoeySacrificialAidMaxHealthPenalty[iClient] = 0;
	g_fZoeySacrificialAidBleedoutStopEndTime[iClient] = -1.0;
	g_iZoeySacrificialAidBleedoutLastHealth[iClient] = 0;
	g_iZoeyMedicalExpertiseBileSerial[iClient] = 0;

	if (g_bConfirmedSurvivorTalentsGivenThisRound[iClient] == false &&
		g_bClientBindUsesRestored[iClient] == false)
		g_iClientBindUses_2[iClient] = 3 - RoundToCeil(float(g_iZoeyTalent6Level[iClient]) * 0.5);

	SetAllZoeyInstantInterventionDownedCount();
	SetPlayerTalentMaxHealth_Zoey(iClient, !g_bConfirmedSurvivorTalentsGivenThisRound[iClient]);
	SetClientSpeed(iClient);

	if (g_iZoeyTalent2Level[iClient] > 0)
		EnsureZoeyDualPistols(iClient);

	if ((g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Rapid Combat Medic Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilties will be automatically set as you level.");
}

void ResetZoeyTalentsRuntimeState(int iClient)
{
	ClearZoeyInstantInterventionState(iClient);
	g_fZoeyResilienceEndTime[iClient] = -1.0;
	g_fZoeyResilienceDamageReduction[iClient] = 0.0;
	g_iZoeyQueuedReviveResumeTarget[iClient] = -1;
	g_fZoeyQueuedReviveResumeDuration[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeProgress[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeAllowedUntil[iClient] = -1.0;
	g_bZoeyExplosiveAmmoActive[iClient] = false;
	g_fZoeyExplosiveAmmoCooldownEndTime[iClient] = -1.0;
	g_bZoeyExplosiveAmmoLoadPending[iClient] = false;
	g_fZoeyLastTriggerHappyShotTime[iClient] = -1.0;
	g_bZoeyMopArmed[iClient] = false;
	g_iZoeyMopCharge[iClient] = 0;
	g_iZoeyMopHitCounter[iClient] = 0;
	g_bZoeyWalkReloadHeld[iClient] = false;
	g_bZoeyWalkUseHeld[iClient] = false;
	g_fZoeyPrimaryStripHintCooldown[iClient] = 0.0;
	g_bZoeySuppressSyntheticCIHurt[iClient] = false;
	g_bZoeySurvivorsWillCharging[iClient] = false;
	g_fZoeySurvivorsWillChargeStartTime[iClient] = -1.0;
	g_fZoeySurvivorsWillRevealEndTime[iClient] = -1.0;
	g_fZoeySurvivorsWillNextMistTime[iClient] = 0.0;
	g_iZoeySharingTrackedTempHealth[iClient] = -1;
	g_iZoeySharingTrackedBoostType[iClient] = ZOEY_SHARING_TRACKED_BOOST_NONE;
	g_iZoeySharingTrackedMedkitTargetUserId[iClient] = 0;
	g_iZoeySharingTrackedMedkitTargetHealthBefore[iClient] = -1;
	g_iZoeyMedicalExpertisePillsReviveCounter[iClient] = 0;
	g_iZoeyMedicalExpertiseMedkitReviveCounter[iClient] = 0;
	g_iZoeySacrificialAidMenuTarget[iClient] = -1;
	g_iZoeySacrificialAidMaxHealthPenalty[iClient] = 0;
	g_fZoeySacrificialAidBleedoutStopEndTime[iClient] = -1.0;
	g_iZoeySacrificialAidBleedoutLastHealth[iClient] = 0;
	g_iZoeyMedicalExpertiseBileSerial[iClient] = 0;
	delete g_hTimer_ZoeySacrificialAidBleedoutCheck[iClient];

	SetClientSpeed(iClient);
	RefreshManagedSurvivorReviveDuration();
	RefreshManagedFirstAidKitUseDuration();
}

void ClearZoeyInstantInterventionState(int iClient)
{
	g_iZoeyInstantInterventionTargetUserId[iClient] = 0;
	g_bZoeyInstantInterventionWalkHeld[iClient] = false;
	g_fZoeyInstantInterventionReviveSpeedEndTime[iClient] = -1.0;
}

bool IsZoeyClientDownedOrHanging(int iClient)
{
	return RunClientChecks(iClient) &&
		IsPlayerAlive(iClient) &&
		g_iClientTeam[iClient] == TEAM_SURVIVORS &&
		(g_bIsClientDown[iClient] == true ||
		clienthanging[iClient] == true ||
		GetEntProp(iClient, Prop_Send, "m_isHangingFromLedge") == 1);
}

void SetPlayerTalentMaxHealth_Zoey(int iClient, bool bFillInHealthGap = true)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;
	
	int iDesiredMaxHealth = 100 - g_iZoeySacrificialAidMaxHealthPenalty[iClient];
	if (iDesiredMaxHealth < 1)
		iDesiredMaxHealth = 1;

	SetPlayerMaxHealth(iClient, iDesiredMaxHealth, false, bFillInHealthGap);
}

void ClearZoeySurvivorsWillCharge(int iClient)
{
	g_bZoeySurvivorsWillCharging[iClient] = false;
	g_fZoeySurvivorsWillChargeStartTime[iClient] = -1.0;
}

void ClearZoeySurvivorsWillReveal(int iClient)
{
	g_fZoeySurvivorsWillRevealEndTime[iClient] = -1.0;
	g_fZoeySurvivorsWillNextMistTime[iClient] = 0.0;
}

float GetZoeyInstantInterventionGlobalCooldownRemaining()
{
	float fRemaining = g_fZoeyInstantInterventionGlobalCooldownEndTime - GetGameTime();
	return fRemaining > 0.0 ? fRemaining : 0.0;
}

int GetZoeyInstantInterventionDownedSurvivorCount()
{
	int iDownedCount = 0;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (RunClientChecks(i) == false ||
			IsPlayerAlive(i) == false ||
			g_iClientTeam[i] != TEAM_SURVIVORS ||
			IsZoeySacrificialAidTargetDowned(i) == false)
		{
			continue;
		}

		iDownedCount++;
		if (iDownedCount >= ZOEY_INSTANT_INTERVENTION_MAX_DOWNED_SPEED_STACKS)
			return ZOEY_INSTANT_INTERVENTION_MAX_DOWNED_SPEED_STACKS;
	}

	return iDownedCount;
}

bool SetAllZoeyInstantInterventionDownedCount()
{
	int iDownedCount = GetZoeyInstantInterventionDownedSurvivorCount();
	if (g_iZoeyInstantInterventionDownedCount == iDownedCount)
		return false;

	g_iZoeyInstantInterventionDownedCount = iDownedCount;
	return true;
}

void SetAllZoeyInstantInterventionSpeed(const char[] strMessage = "")
{
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (g_iChosenSurvivor[iPlayer] != ZOEY ||
			g_iZoeyTalent6Level[iPlayer] <= 0 ||
			g_iClientTeam[iPlayer] != TEAM_SURVIVORS ||
			RunClientChecks(iPlayer) == false ||
			IsPlayerAlive(iPlayer) == false)
		{
			continue;
		}

		SetClientSpeed(iPlayer);

		if (strMessage[0] != '\0' && IsFakeClient(iPlayer) == false)
			PrintHintText(iPlayer, "%s", strMessage);
	}
}

void GrantZoeyResilienceBuff(int iTarget, float fDamageReduction, float fDuration)
{
	if (RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		fDamageReduction <= 0.0 ||
		fDuration <= 0.0)
	{
		return;
	}

	float fNewEndTime = GetGameTime() + fDuration;
	if (g_fZoeyResilienceEndTime[iTarget] < fNewEndTime)
		g_fZoeyResilienceEndTime[iTarget] = fNewEndTime;

	if (g_fZoeyResilienceDamageReduction[iTarget] < fDamageReduction)
		g_fZoeyResilienceDamageReduction[iTarget] = fDamageReduction;
}

bool IsZoeyHoldingMedkit(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return false;

	int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (RunEntityChecks(iActiveWeaponID) == false)
		return false;

	char strWeaponClass[32];
	GetEntityClassname(iActiveWeaponID, strWeaponClass, sizeof(strWeaponClass));
	return StrEqual(strWeaponClass, "weapon_first_aid_kit", false);
}

bool IsZoeySharingIsCaringActive(int iClient)
{
	return RunClientChecks(iClient) &&
		IsPlayerAlive(iClient) &&
		g_bTalentsConfirmed[iClient] == true &&
		g_iChosenSurvivor[iClient] == ZOEY &&
		g_iClientTeam[iClient] == TEAM_SURVIVORS &&
		g_iZoeyTalent4Level[iClient] > 0;
}

bool IsZoeyMedicalExpertiseActive(int iClient)
{
	return RunClientChecks(iClient) &&
		IsPlayerAlive(iClient) &&
		g_bTalentsConfirmed[iClient] == true &&
		g_iChosenSurvivor[iClient] == ZOEY &&
		g_iClientTeam[iClient] == TEAM_SURVIVORS &&
		g_iZoeyTalent5Level[iClient] > 0;
}

bool DoesSurvivorTeamHaveZoeyMedicalExpertise()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsZoeyMedicalExpertiseActive(i))
			return true;
	}

	return false;
}

float GetZoeySharingIsCaringRadius(int iClient)
{
	if (IsZoeySharingIsCaringActive(iClient) == false)
		return 0.0;

	return ZOEY_SHARING_IS_CARING_RADIUS_BASE +
		(float(g_iZoeyTalent4Level[iClient]) * ZOEY_SHARING_IS_CARING_RADIUS_PER_LEVEL);
}

float GetZoeySharingIsCaringMedkitShareMultiplier(int iClient)
{
	return IsZoeySharingIsCaringActive(iClient) ?
		float(g_iZoeyTalent4Level[iClient]) * ZOEY_SHARING_IS_CARING_MEDKIT_SHARE_PER_LEVEL :
		0.0;
}

float GetZoeySharingIsCaringPillsShareMultiplier(int iClient)
{
	return IsZoeySharingIsCaringActive(iClient) ?
		float(g_iZoeyTalent4Level[iClient]) * ZOEY_SHARING_IS_CARING_PILLS_SHARE_PER_LEVEL :
		0.0;
}

float GetZoeySharingIsCaringAdrenalineShareMultiplier(int iClient)
{
	return IsZoeySharingIsCaringActive(iClient) ?
		float(g_iZoeyTalent4Level[iClient]) * ZOEY_SHARING_IS_CARING_ADRENALINE_SHARE_PER_LEVEL :
		0.0;
}

int GetZoeySharingTrackedBoostBaseHealAmount(int iBoostType)
{
	switch (iBoostType)
	{
		case ZOEY_SHARING_TRACKED_BOOST_PILLS:
			return ZOEY_SHARING_IS_CARING_PILLS_BASE_HEAL;
		case ZOEY_SHARING_TRACKED_BOOST_ADRENALINE:
			return ZOEY_SHARING_IS_CARING_ADRENALINE_BASE_HEAL;
	}

	return 0;
}

void TrackZoeySharingIsCaringBoostUse(int iClient)
{
	if (IsZoeySharingIsCaringActive(iClient) == false &&
		IsZoeyMedicalExpertiseActive(iClient) == false)
		return;

	int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (RunEntityChecks(iActiveWeaponID) == false ||
		iActiveWeaponID != GetPlayerWeaponSlot(iClient, 4))
		return;

	char strWeaponClass[32];
	GetEntityClassname(iActiveWeaponID, strWeaponClass, sizeof(strWeaponClass));
	int iBoostType = ZOEY_SHARING_TRACKED_BOOST_NONE;
	if (StrEqual(strWeaponClass, "weapon_pain_pills", false))
		iBoostType = ZOEY_SHARING_TRACKED_BOOST_PILLS;
	else if (StrEqual(strWeaponClass, "weapon_adrenaline", false))
		iBoostType = ZOEY_SHARING_TRACKED_BOOST_ADRENALINE;
	else
		return;

	g_iZoeySharingTrackedTempHealth[iClient] = GetSurvivorTempHealth(iClient);
	g_iZoeySharingTrackedBoostType[iClient] = iBoostType;
}

int ConsumeZoeySharingIsCaringTrackedBoostHealAmount(int iClient)
{
	int iTrackedTempHealth = g_iZoeySharingTrackedTempHealth[iClient];
	int iBoostType = g_iZoeySharingTrackedBoostType[iClient];
	g_iZoeySharingTrackedTempHealth[iClient] = -1;
	g_iZoeySharingTrackedBoostType[iClient] = ZOEY_SHARING_TRACKED_BOOST_NONE;

	if ((IsZoeySharingIsCaringActive(iClient) == false &&
		IsZoeyMedicalExpertiseActive(iClient) == false) ||
		iTrackedTempHealth < 0)
		return 0;

	int iCurrentTempHealth = GetSurvivorTempHealth(iClient);
	int iTrackedHealAmount = iCurrentTempHealth > iTrackedTempHealth ? iCurrentTempHealth - iTrackedTempHealth : 0;
	int iBaseHealAmount = GetZoeySharingTrackedBoostBaseHealAmount(iBoostType);

	return iTrackedHealAmount > iBaseHealAmount ? iTrackedHealAmount : iBaseHealAmount;
}

int ApplyZoeySharingIsCaringPermanentHeal(int iTarget, int iHealAmount)
{
	if (iHealAmount <= 0 ||
		RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		IsIncap(iTarget) == true)
		return 0;

	int iHealthBefore = GetPlayerHealth(iTarget);
	if (iHealthBefore <= 0)
		return 0;

	if (SetPlayerHealth(iTarget, -1, iHealAmount, true) == false)
		return 0;

	int iHealthAfter = GetPlayerHealth(iTarget);
	if (iHealthAfter <= iHealthBefore)
		return 0;

	return iHealthAfter - iHealthBefore;
}

void ShareZoeyHealingToNearbyTeammates(int iZoey, int iSharedHealAmount, int iPrimaryTargetToSkip)
{
	if (IsZoeySharingIsCaringActive(iZoey) == false ||
		iSharedHealAmount <= 0)
		return;

	float fRadius = GetZoeySharingIsCaringRadius(iZoey);
	if (fRadius <= 0.0)
		return;

	float xyzZoeyOrigin[3];
	GetClientAbsOrigin(iZoey, xyzZoeyOrigin);

	for (int iTeammate = 1; iTeammate <= MaxClients; iTeammate++)
	{
		if (iTeammate == iZoey ||
			iTeammate == iPrimaryTargetToSkip ||
			RunClientChecks(iTeammate) == false ||
			IsPlayerAlive(iTeammate) == false ||
			g_iClientTeam[iTeammate] != TEAM_SURVIVORS ||
			g_iChosenSurvivor[iTeammate] == ZOEY ||
			IsIncap(iTeammate) == true)
			continue;

		float xyzTeammateOrigin[3];
		GetClientAbsOrigin(iTeammate, xyzTeammateOrigin);
		if (GetVectorDistance(xyzZoeyOrigin, xyzTeammateOrigin) > fRadius)
			continue;

		ApplyZoeySharingIsCaringPermanentHeal(iTeammate, iSharedHealAmount);
	}
}

float GetZoeySacrificialAidGlobalCooldownRemaining()
{
	float fRemaining = g_fZoeySacrificialAidGlobalCooldownEndTime - GetGameTime();
	return fRemaining > 0.0 ? fRemaining : 0.0;
}

bool IsZoeySacrificialAidTargetHanging(int iTarget)
{
	return RunClientChecks(iTarget) &&
		IsPlayerAlive(iTarget) &&
		g_iClientTeam[iTarget] == TEAM_SURVIVORS &&
		(clienthanging[iTarget] == true || GetEntProp(iTarget, Prop_Send, "m_isHangingFromLedge") == 1);
}

bool IsZoeySacrificialAidTargetDowned(int iTarget)
{
	return RunClientChecks(iTarget) &&
		IsPlayerAlive(iTarget) &&
		g_iClientTeam[iTarget] == TEAM_SURVIVORS &&
		(IsIncap(iTarget) == true || IsZoeySacrificialAidTargetHanging(iTarget) == true);
}

bool GetZoeySacrificialAidTarget(int iClient, int &iTarget)
{
	iTarget = GetClientAimTarget(iClient, true);
	if (RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		iTarget == iClient)
	{
		iTarget = -1;
		return false;
	}

	float xyzClientEye[3], xyzTargetEye[3];
	GetClientEyePosition(iClient, xyzClientEye);
	GetClientEyePosition(iTarget, xyzTargetEye);
	if (IsVisibleTo(xyzClientEye, xyzTargetEye) == false)
	{
		iTarget = -1;
		return false;
	}

	return true;
}

bool CanZoeySacrificialAidPayCost(int iClient, int iCost)
{
	return GetPlayerMaxHealth(iClient) > iCost;
}

bool ApplyZoeySacrificialAidCost(int iClient, int iCost)
{
	if (CanZoeySacrificialAidPayCost(iClient, iCost) == false)
		return false;

	g_iZoeySacrificialAidMaxHealthPenalty[iClient] += iCost;
	SetPlayerTalentMaxHealth_Zoey(iClient, false);
	return true;
}

int ApplyZoeyMedicalExpertiseBonusTempHealth(int iClient, int iBaseHealAmount, float fBonusMultiplier)
{
	if (IsZoeyMedicalExpertiseActive(iClient) == false ||
		iBaseHealAmount <= 0 ||
		fBonusMultiplier <= 0.0)
		return 0;

	int iTempHealthBefore = GetSurvivorTempHealth(iClient);
	int iBonusHealAmount = RoundToFloor(float(iBaseHealAmount) * fBonusMultiplier);
	if (iBonusHealAmount <= 0)
		return 0;

	AddTempHealthToSurvivor(iClient, float(iBonusHealAmount));

	int iTempHealthAfter = GetSurvivorTempHealth(iClient);
	int iAppliedBonusAmount = iTempHealthAfter > iTempHealthBefore ? iTempHealthAfter - iTempHealthBefore : 0;

	return iAppliedBonusAmount > iBonusHealAmount ? iAppliedBonusAmount : iBonusHealAmount;
}

float GetZoeyMedicalExpertiseMedkitUseDuration(int iClient)
{
	float fDesiredDuration = g_fDefaultFirstAidKitUseDuration;
	bool bModified = false;

	if (IsZoeyMedicalExpertiseActive(iClient))
	{
		fDesiredDuration *= (1.0 - ZOEY_MEDICAL_EXPERTISE_HEAL_ITEM_USE_SPEED_BONUS);
		bModified = true;
	}

	if (g_iZoeyTalent6Level[iClient] > 0 &&
		g_fZoeyInstantInterventionReviveSpeedEndTime[iClient] > GetGameTime())
	{
		fDesiredDuration *= (1.0 - ZOEY_INSTANT_INTERVENTION_MEDKIT_USE_SPEED_BONUS);
		bModified = true;
	}

	return bModified ? fDesiredDuration : 0.0;
}

bool IsZoeyActivelyUsingManagedMedkit(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		(IsZoeyMedicalExpertiseActive(iClient) == false &&
		g_iZoeyTalent6Level[iClient] <= 0))
	{
		return false;
	}

	if (HasEntProp(iClient, Prop_Send, "m_bPerformingAction") == false ||
		GetEntProp(iClient, Prop_Send, "m_bPerformingAction") != 1)
	{
		return false;
	}

	int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (RunEntityChecks(iActiveWeaponID) == false)
		return false;

	char strWeaponClass[32];
	GetEntityClassname(iActiveWeaponID, strWeaponClass, sizeof(strWeaponClass));
	return StrEqual(strWeaponClass, "weapon_first_aid_kit", false);
}

float GetManagedFirstAidKitUseDuration(int iHealBeginClient = -1)
{
	float fDesiredDuration = g_fDefaultFirstAidKitUseDuration;

	if (g_bLouisMedHaxEnabled)
		fDesiredDuration = float(LOUIS_MED_HAX_USE_DURATION);

	if (RunClientChecks(iHealBeginClient) &&
		g_bTalentsConfirmed[iHealBeginClient] == true &&
		g_iChosenSurvivor[iHealBeginClient] == ZOEY &&
		g_iClientTeam[iHealBeginClient] == TEAM_SURVIVORS)
	{
		float fZoeyDuration = GetZoeyMedicalExpertiseMedkitUseDuration(iHealBeginClient);
		if (fZoeyDuration > 0.0 && fZoeyDuration < fDesiredDuration)
			fDesiredDuration = fZoeyDuration;
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		if (i == iHealBeginClient ||
			IsZoeyActivelyUsingManagedMedkit(i) == false)
		{
			continue;
		}

		float fZoeyDuration = GetZoeyMedicalExpertiseMedkitUseDuration(i);
		if (fZoeyDuration > 0.0 && fZoeyDuration < fDesiredDuration)
			fDesiredDuration = fZoeyDuration;
	}

	return fDesiredDuration;
}

void RefreshManagedFirstAidKitUseDuration(int iHealBeginClient = -1)
{
	if (g_hCVar_FirstAidKitUseDuration == null)
		return;

	float fDesiredDuration = GetManagedFirstAidKitUseDuration(iHealBeginClient);
	if (fDesiredDuration <= 0.0)
		fDesiredDuration = g_fDefaultFirstAidKitUseDuration;

	if (FloatAbs(g_hCVar_FirstAidKitUseDuration.FloatValue - fDesiredDuration) > 0.01)
		g_hCVar_FirstAidKitUseDuration.FloatValue = fDesiredDuration;
}

float GetZoeyMedicalExpertiseBoostUseDuration(int iClient, int iActiveWeaponID)
{
	if (RunEntityChecks(iActiveWeaponID) == false)
		return 0.0;

	char strWeaponClass[32];
	GetEntityClassname(iActiveWeaponID, strWeaponClass, sizeof(strWeaponClass));

	if (StrEqual(strWeaponClass, "weapon_pain_pills", false) ||
		StrEqual(strWeaponClass, "weapon_adrenaline", false))
	{
		if (IsZoeyMedicalExpertiseActive(iClient) == false)
			return 0.0;

		return ZOEY_MEDICAL_EXPERTISE_BOOST_USE_DURATION *
			(1.0 - ZOEY_MEDICAL_EXPERTISE_HEAL_ITEM_USE_SPEED_BONUS);
	}

	return 0.0;
}

void ApplyZoeyMedicalExpertiseUseSpeedToEntity(int iEntity, float fDesiredDuration)
{
	if (RunEntityChecks(iEntity) == false ||
		fDesiredDuration <= 0.0)
		return;

	float fCurrentDuration = GetEntPropFloat(iEntity, Prop_Send, "m_flProgressBarDuration");
	if (fCurrentDuration <= 0.0 ||
		fCurrentDuration <= fDesiredDuration + 0.01)
		return;

	float fCurrentTime = GetGameTime();
	float fCurrentStartTime = GetEntPropFloat(iEntity, Prop_Send, "m_flProgressBarStartTime");
	float fCurrentProgress = (fCurrentTime - fCurrentStartTime) / fCurrentDuration;

	if (fCurrentProgress < 0.0)
		fCurrentProgress = 0.0;
	else if (fCurrentProgress > 1.0)
		fCurrentProgress = 1.0;

	SetEntPropFloat(iEntity, Prop_Send, "m_flProgressBarStartTime", fCurrentTime - (fCurrentProgress * fDesiredDuration));
	SetEntPropFloat(iEntity, Prop_Send, "m_flProgressBarDuration", fDesiredDuration);
}

void HandleZoeyMedicalExpertiseUseSpeed(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
	{
		return;
	}

	RefreshManagedFirstAidKitUseDuration(iClient);

	if (IsZoeyMedicalExpertiseActive(iClient) == false)
		return;

	int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	// Medkits now use the real first_aid_kit_use_duration convar override.
	// Only pills/adrenaline still need the client progress bar rewrite.
	float fDesiredDuration = GetZoeyMedicalExpertiseBoostUseDuration(iClient, iActiveWeaponID);
	if (fDesiredDuration <= 0.0)
		return;

	ApplyZoeyMedicalExpertiseUseSpeedToEntity(iClient, fDesiredDuration);

	if (RunEntityChecks(iActiveWeaponID) &&
		HasEntProp(iActiveWeaponID, Prop_Send, "m_helpingHandTarget"))
	{
		int iHelpingHandTarget = GetEntPropEnt(iActiveWeaponID, Prop_Send, "m_helpingHandTarget");
		if (RunClientChecks(iHelpingHandTarget) &&
			IsPlayerAlive(iHelpingHandTarget) &&
			g_iClientTeam[iHelpingHandTarget] == TEAM_SURVIVORS)
		{
			ApplyZoeyMedicalExpertiseUseSpeedToEntity(iHelpingHandTarget, fDesiredDuration);
		}
	}
}

void GiveZoeyScrapRecycleReward(int iClient, const char[] strGiveCommand, const char[] strHintText)
{
	RunCheatCommand(iClient, "give", strGiveCommand);

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "%s", strHintText);
}

void HandleZoeyMedicalExpertiseReviveRewards(int iClient, int iTarget)
{
	if (IsZoeyMedicalExpertiseActive(iClient) == false ||
		RunClientChecks(iTarget) == false ||
		iTarget == iClient)
		return;

	g_iZoeyMedicalExpertisePillsReviveCounter[iClient]++;
	if (g_iZoeyMedicalExpertisePillsReviveCounter[iClient] >= ZOEY_MEDICAL_EXPERTISE_SCRAP_RECYCLE_PILLS_REVIVES)
	{
		g_iZoeyMedicalExpertisePillsReviveCounter[iClient] -= ZOEY_MEDICAL_EXPERTISE_SCRAP_RECYCLE_PILLS_REVIVES;
		GiveZoeyScrapRecycleReward(iClient, "give pain_pills", "Scrap Recycle: +1 Pills");
	}

	g_iZoeyMedicalExpertiseMedkitReviveCounter[iClient]++;
	if (g_iZoeyMedicalExpertiseMedkitReviveCounter[iClient] >= ZOEY_MEDICAL_EXPERTISE_SCRAP_RECYCLE_MEDKIT_REVIVES)
	{
		g_iZoeyMedicalExpertiseMedkitReviveCounter[iClient] -= ZOEY_MEDICAL_EXPERTISE_SCRAP_RECYCLE_MEDKIT_REVIVES;
		GiveZoeyScrapRecycleReward(iClient, "give first_aid_kit", "Scrap Recycle: +1 Medkit");
	}
}

void ApplyZoeyMedicalExpertiseBileReduction(int iVictim)
{
	if (RunClientChecks(iVictim) == false ||
		IsPlayerAlive(iVictim) == false ||
		g_iClientTeam[iVictim] != TEAM_SURVIVORS ||
		DoesSurvivorTeamHaveZoeyMedicalExpertise() == false)
		return;

	ConVar cvBileDuration = FindConVar("survivor_it_duration");
	float fBaseDuration = cvBileDuration != null ? cvBileDuration.FloatValue : 20.0;
	float fReducedDuration = fBaseDuration * ZOEY_MEDICAL_EXPERTISE_BILE_DURATION_MULTIPLIER;
	if (fReducedDuration <= 0.0)
		return;

	g_iZoeyMedicalExpertiseBileSerial[iVictim]++;
	Handle hDataPackage = CreateDataPack();
	WritePackCell(hDataPackage, GetClientUserId(iVictim));
	WritePackCell(hDataPackage, g_iZoeyMedicalExpertiseBileSerial[iVictim]);
	CreateTimer(fReducedDuration, TimerZoeyMedicalExpertiseEndBile, hDataPackage, TIMER_FLAG_NO_MAPCHANGE);
}

void StopZoeySacrificialAidBleedoutProtection(int iTarget)
{
	g_fZoeySacrificialAidBleedoutStopEndTime[iTarget] = -1.0;
	g_iZoeySacrificialAidBleedoutLastHealth[iTarget] = 0;
	delete g_hTimer_ZoeySacrificialAidBleedoutCheck[iTarget];
}

void StartZoeySacrificialAidBleedoutProtection(int iTarget, float fDuration)
{
	if (RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		IsIncap(iTarget) == false ||
		fDuration <= 0.0)
		return;

	g_fZoeySacrificialAidBleedoutStopEndTime[iTarget] = GetGameTime() + fDuration;
	g_iZoeySacrificialAidBleedoutLastHealth[iTarget] = GetEntProp(iTarget, Prop_Data, "m_iHealth");

	delete g_hTimer_ZoeySacrificialAidBleedoutCheck[iTarget];
	g_hTimer_ZoeySacrificialAidBleedoutCheck[iTarget] = CreateTimer(ZOEY_SACRIFICIAL_AID_BLEEDOUT_CHECK_INTERVAL, TimerZoeySacrificialAidBleedoutCheck, GetClientUserId(iTarget), TIMER_REPEAT);
}

void ReviveZoeySacrificialAidTarget(int iClient, int iTarget)
{
	bool bWasHanging = IsZoeySacrificialAidTargetHanging(iTarget);

	StopZoeySacrificialAidBleedoutProtection(iTarget);

	RunCheatCommand(iTarget, "give", "give health");

	if (bWasHanging)
	{
		if (g_iPlayerHealth[iTarget] <= 1)
			g_iPlayerHealth[iTarget] = 1;

		SetPlayerHealth(iTarget, -1, g_iPlayerHealth[iTarget]);
		ResetTempHealthToSurvivor(iTarget);

		if (g_iPlayerHealthTemp[iTarget] > 0)
			AddTempHealthToSurvivor(iTarget, float(g_iPlayerHealthTemp[iTarget]));
	}
	else
	{
		SetPlayerHealth(iTarget, -1, SELF_REVIVE_HEALTH);
		ResetTempHealthToSurvivor(iTarget);
		AddTempHealthToSurvivor(iTarget, float(SELF_REVIVE_TEMP_HEALTH));
	}

	g_bIsClientDown[iTarget] = false;
	clienthanging[iTarget] = false;
	EndSelfRevive(iTarget);
	SetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarStartTime", GetGameTime());
	SetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarDuration", 0.0);
	SetEntPropEnt(iTarget, Prop_Send, "m_reviveOwner", -1);

	if (bWasHanging == false && SetAllNicksDesprateMeasuresStacks())
		SetAllNicksDesprateMeasureSpeed("A teammate has been revived, your senses return to a weaker state.");

	if (SetAllZoeyInstantInterventionDownedCount())
		SetAllZoeyInstantInterventionSpeed("A teammate is back up. Instant Intervention slows to normal.");

	SetClientRenderAndGlowColor(iTarget);
	SetClientSpeed(iTarget);

	// Instant pickups do not fire revive_success, so mirror Zoey's revive passives here.
	ApplyZoeyResilientResuscitation(iClient, iTarget);
	ConvertZoeyReviveHealthToPermanent(iClient, iTarget);
	HandleZoeyMedicalExpertiseReviveRewards(iClient, iTarget);
}

bool TryUseZoeySacrificialAid(int iClient, int iTarget, int iCost)
{
	if (RunClientChecks(iClient) == false ||
		RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iClient) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		g_iZoeyTalent5Level[iClient] <= 0 ||
		IsZoeyClientDownedOrHanging(iClient) == true ||
		IsClientGrappled(iClient) == true ||
		iClient == iTarget)
	{
		return false;
	}

	if (iCost != ZOEY_SACRIFICIAL_AID_MAJOR_COST &&
		iCost != ZOEY_SACRIFICIAL_AID_MEDIUM_COST &&
		iCost != ZOEY_SACRIFICIAL_AID_MINOR_COST)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Sacrificial Aid received an invalid sacrifice tier.");
		return false;
	}

	float fCooldownRemaining = GetZoeySacrificialAidGlobalCooldownRemaining();
	if (fCooldownRemaining > 0.0)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Sacrificial Aid cooling down: %0.0f seconds", fCooldownRemaining);
		return false;
	}

	float xyzClientEye[3], xyzTargetEye[3];
	GetClientEyePosition(iClient, xyzClientEye);
	GetClientEyePosition(iTarget, xyzTargetEye);
	if (IsVisibleTo(xyzClientEye, xyzTargetEye) == false)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Sacrificial Aid requires a visible teammate.");
		return false;
	}

	bool bTargetDowned = IsZoeySacrificialAidTargetDowned(iTarget);
	bool bTargetHanging = IsZoeySacrificialAidTargetHanging(iTarget);
	if (bTargetDowned && bTargetHanging == true && iCost != ZOEY_SACRIFICIAL_AID_MAJOR_COST)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Only the 100 HP option can instantly pick up a ledge-hanging teammate.");
		return false;
	}

	if (bTargetDowned == false)
	{
		int iCurrentHealth = GetPlayerHealth(iTarget);
		int iMaxHealth = GetPlayerMaxHealth(iTarget);
		int iTempHealth = GetSurvivorTempHealth(iTarget);

		if ((iCost == ZOEY_SACRIFICIAL_AID_MAJOR_COST || iCost == ZOEY_SACRIFICIAL_AID_MINOR_COST) &&
			iCurrentHealth + iTempHealth >= iMaxHealth)
		{
			if (IsFakeClient(iClient) == false)
				PrintHintText(iClient, "%N is already at full health.", iTarget);
			return false;
		}

		if (iCost == ZOEY_SACRIFICIAL_AID_MEDIUM_COST &&
			iCurrentHealth + iTempHealth >= iMaxHealth)
		{
			if (IsFakeClient(iClient) == false)
				PrintHintText(iClient, "%N cannot gain more temporary health right now.", iTarget);
			return false;
		}
	}

	if (ApplyZoeySacrificialAidCost(iClient, iCost) == false)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Sacrificial Aid needs more remaining max health.");
		return false;
	}

	g_fZoeySacrificialAidGlobalCooldownEndTime = GetGameTime() + ZOEY_SACRIFICIAL_AID_GLOBAL_COOLDOWN;

	if (bTargetDowned)
	{
		switch (iCost)
		{
			case ZOEY_SACRIFICIAL_AID_MAJOR_COST:
			{
				ReviveZoeySacrificialAidTarget(iClient, iTarget);

				if (IsFakeClient(iClient) == false)
					PrintHintText(iClient, "Sacrificial Aid: Instantly picked up %N", iTarget);
				if (IsFakeClient(iTarget) == false)
					PrintHintText(iTarget, "%N sacrificed max health to instantly pick you up.", iClient);
			}
			case ZOEY_SACRIFICIAL_AID_MEDIUM_COST:
			{
				StartZoeySacrificialAidBleedoutProtection(iTarget, ZOEY_SACRIFICIAL_AID_MEDIUM_BLEEDOUT_DURATION);

				if (IsFakeClient(iClient) == false)
					PrintHintText(iClient, "Sacrificial Aid: %N stops bleeding out for %.0f seconds", iTarget, ZOEY_SACRIFICIAL_AID_MEDIUM_BLEEDOUT_DURATION);
				if (IsFakeClient(iTarget) == false)
					PrintHintText(iTarget, "%N stopped your bleedout for %.0f seconds.", iClient, ZOEY_SACRIFICIAL_AID_MEDIUM_BLEEDOUT_DURATION);
			}
			case ZOEY_SACRIFICIAL_AID_MINOR_COST:
			{
				StartZoeySacrificialAidBleedoutProtection(iTarget, ZOEY_SACRIFICIAL_AID_MINOR_BLEEDOUT_DURATION);

				if (IsFakeClient(iClient) == false)
					PrintHintText(iClient, "Sacrificial Aid: %N stops bleeding out for %.0f seconds", iTarget, ZOEY_SACRIFICIAL_AID_MINOR_BLEEDOUT_DURATION);
				if (IsFakeClient(iTarget) == false)
					PrintHintText(iTarget, "%N stopped your bleedout for %.0f seconds.", iClient, ZOEY_SACRIFICIAL_AID_MINOR_BLEEDOUT_DURATION);
			}
		}

		return true;
	}

	switch (iCost)
	{
		case ZOEY_SACRIFICIAL_AID_MAJOR_COST:
		{
			ApplyZoeySharingIsCaringPermanentHeal(iTarget, ZOEY_SACRIFICIAL_AID_MAJOR_HEAL);

			if (IsFakeClient(iClient) == false)
				PrintHintText(iClient, "Sacrificial Aid: Healed %N for %d HP", iTarget, ZOEY_SACRIFICIAL_AID_MAJOR_HEAL);
			if (IsFakeClient(iTarget) == false)
				PrintHintText(iTarget, "%N sacrificed max health to heal you for %d HP.", iClient, ZOEY_SACRIFICIAL_AID_MAJOR_HEAL);
		}
		case ZOEY_SACRIFICIAL_AID_MEDIUM_COST:
		{
			AddTempHealthToSurvivor(iTarget, ZOEY_SACRIFICIAL_AID_MEDIUM_TEMP_HEALTH);

			if (IsFakeClient(iClient) == false)
				PrintHintText(iClient, "Sacrificial Aid: Gave %N %.0f temp HP", iTarget, ZOEY_SACRIFICIAL_AID_MEDIUM_TEMP_HEALTH);
			if (IsFakeClient(iTarget) == false)
				PrintHintText(iTarget, "%N sacrificed max health to give you %.0f temp HP.", iClient, ZOEY_SACRIFICIAL_AID_MEDIUM_TEMP_HEALTH);
		}
		case ZOEY_SACRIFICIAL_AID_MINOR_COST:
		{
			ApplyZoeySharingIsCaringPermanentHeal(iTarget, ZOEY_SACRIFICIAL_AID_MINOR_HEAL);

			if (IsFakeClient(iClient) == false)
				PrintHintText(iClient, "Sacrificial Aid: Healed %N for %d HP", iTarget, ZOEY_SACRIFICIAL_AID_MINOR_HEAL);
			if (IsFakeClient(iTarget) == false)
				PrintHintText(iTarget, "%N sacrificed max health to heal you for %d HP.", iClient, ZOEY_SACRIFICIAL_AID_MINOR_HEAL);
		}
	}

	return true;
}

float GetZoeySurvivorsWillChargeDuration(int iClient)
{
	if (g_bZoeySurvivorsWillCharging[iClient] == false ||
		g_fZoeySurvivorsWillChargeStartTime[iClient] < 0.0)
		return 0.0;

	float fDuration = GetGameTime() - g_fZoeySurvivorsWillChargeStartTime[iClient];
	if (fDuration < 0.0)
		return 0.0;

	return fDuration > ZOEY_SURVIVORS_WILL_CHARGE_MAX_DURATION ?
		ZOEY_SURVIVORS_WILL_CHARGE_MAX_DURATION :
		fDuration;
}

float GetZoeySurvivorsWillGlobalCooldownRemaining()
{
	float fRemaining = g_fZoeySurvivorsWillGlobalCooldownEndTime - GetGameTime();
	return fRemaining > 0.0 ? fRemaining : 0.0;
}

int GetZoeySurvivorsWillTeamIncapHealthBonus()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (RunClientChecks(i) == false ||
			IsPlayerAlive(i) == false ||
			g_iClientTeam[i] != TEAM_SURVIVORS ||
			g_bTalentsConfirmed[i] == false ||
			g_iChosenSurvivor[i] != ZOEY ||
			g_iZoeyTalent3Level[i] <= 0)
			continue;

		return ZOEY_SURVIVORS_WILL_INCAP_HEALTH_BONUS;
	}

	return 0;
}

void ApplyZoeySurvivorsWillIncapHealthBonus(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;

	int iBonus = GetZoeySurvivorsWillTeamIncapHealthBonus();
	if (iBonus <= 0)
		return;

	int iCurrentIncapHealth = GetEntProp(iClient, Prop_Data, "m_iHealth");
	if (iCurrentIncapHealth <= 0)
		return;

	SetEntProp(iClient, Prop_Data, "m_iHealth", iCurrentIncapHealth + iBonus);
}

bool ShouldApplyZoeySurvivorsWillIncapReduction(int iVictim, int iDmgType)
{
	if (RunClientChecks(iVictim) == false ||
		IsPlayerAlive(iVictim) == false ||
		g_iClientTeam[iVictim] != TEAM_SURVIVORS ||
		g_bTalentsConfirmed[iVictim] == false ||
		g_iChosenSurvivor[iVictim] != ZOEY ||
		g_iZoeyTalent3Level[iVictim] <= 0 ||
		IsIncap(iVictim) == false)
		return false;

	if ((iDmgType & (DMG_DROWN | DMG_DISSOLVE | DMG_REMOVENORAGDOLL | DMG_FALL | DMG_CRUSH)) != 0)
		return false;

	return true;
}

void TryStartZoeySurvivorsWillCharge(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iZoeyTalent3Level[iClient] <= 0 ||
		IsZoeyClientDownedOrHanging(iClient) == true ||
		IsClientGrappled(iClient) == true)
		return;

	if (IsZoeyHoldingMedkit(iClient) == false)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Survivor's Will requires a medkit equipped.");
		return;
	}

	float fCooldownRemaining = GetZoeySurvivorsWillGlobalCooldownRemaining();
	if (fCooldownRemaining > 0.0)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Survivor's Will cooling down: %0.0f seconds", fCooldownRemaining);
		return;
	}

	if (g_bZoeySurvivorsWillCharging[iClient] == true)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Survivor's Will charge: %0.1f / %.0f seconds", GetZoeySurvivorsWillChargeDuration(iClient), ZOEY_SURVIVORS_WILL_CHARGE_MAX_DURATION);
		return;
	}

	g_bZoeySurvivorsWillCharging[iClient] = true;
	g_fZoeySurvivorsWillChargeStartTime[iClient] = GetGameTime();

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Survivor's Will charging.\nKeep the medkit out, then switch away.");
}

void CreateZoeySurvivorsWillMist(int iClient, float xyzLocation[3])
{
	int iSmokeEntity = CreateSmokeParticle(-1, xyzLocation, false, "", 205, 225, 205, 80, 0, 30, 35, 30, 60, 8, 60, 4, ZOEY_SURVIVORS_WILL_REVEAL_MIST_DURATION);
	if (RunEntityChecks(iSmokeEntity) == false)
		return;

	g_iZoeySurvivorsWillMistOwner[iSmokeEntity] = iClient;
	SDKHook(iSmokeEntity, SDKHook_SetTransmit, OnSetTransmit_ZoeySurvivorsWillMist);
}

void RevealZoeySurvivorsWillGhosts(int iClient)
{
	float xyzClientEye[3];
	GetClientEyePosition(iClient, xyzClientEye);

	for (int iGhost = 1; iGhost <= MaxClients; iGhost++)
	{
		if (RunClientChecks(iGhost) == false ||
			IsPlayerAlive(iGhost) == false ||
			g_iClientTeam[iGhost] != TEAM_INFECTED ||
			GetEntData(iGhost, g_iOffset_IsGhost, 1) != 1)
			continue;

		float xyzGhostEye[3];
		GetClientEyePosition(iGhost, xyzGhostEye);
		if (IsVisibleTo(xyzClientEye, xyzGhostEye) == false)
			continue;

		float xyzGhostLocation[3];
		GetClientAbsOrigin(iGhost, xyzGhostLocation);
		xyzGhostLocation[2] += 20.0;
		CreateZoeySurvivorsWillMist(iClient, xyzGhostLocation);
	}
}

void ActivateZoeySurvivorsWillReveal(int iClient, float fDuration)
{
	ClearZoeySurvivorsWillCharge(iClient);

	float fCooldownRemaining = GetZoeySurvivorsWillGlobalCooldownRemaining();
	if (fCooldownRemaining > 0.0)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Survivor's Will cooling down: %0.0f seconds", fCooldownRemaining);
		return;
	}

	if (fDuration <= 0.0)
		return;

	if (fDuration > ZOEY_SURVIVORS_WILL_CHARGE_MAX_DURATION)
		fDuration = ZOEY_SURVIVORS_WILL_CHARGE_MAX_DURATION;

	g_fZoeySurvivorsWillRevealEndTime[iClient] = GetGameTime() + fDuration;
	g_fZoeySurvivorsWillNextMistTime[iClient] = GetGameTime() + ZOEY_SURVIVORS_WILL_REVEAL_MIST_INTERVAL;
	g_fZoeySurvivorsWillGlobalCooldownEndTime = GetGameTime() + ZOEY_SURVIVORS_WILL_GLOBAL_COOLDOWN;

	RevealZoeySurvivorsWillGhosts(iClient);

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Survivor's Will active for %0.1f seconds.\nGlobal cooldown: %.0f seconds.", fDuration, ZOEY_SURVIVORS_WILL_GLOBAL_COOLDOWN);
}

void HandleZoeySurvivorsWillState(int iClient)
{
	if (g_iZoeyTalent3Level[iClient] <= 0)
	{
		ClearZoeySurvivorsWillCharge(iClient);
		ClearZoeySurvivorsWillReveal(iClient);
		return;
	}

	if (g_bZoeySurvivorsWillCharging[iClient] == true)
	{
		if (IsZoeyClientDownedOrHanging(iClient) == true ||
			IsClientGrappled(iClient) == true)
		{
			ClearZoeySurvivorsWillCharge(iClient);
		}
		else if (IsZoeyHoldingMedkit(iClient) == false)
		{
			ActivateZoeySurvivorsWillReveal(iClient, GetZoeySurvivorsWillChargeDuration(iClient));
		}
	}

	if (g_fZoeySurvivorsWillRevealEndTime[iClient] < GetGameTime())
	{
		ClearZoeySurvivorsWillReveal(iClient);
		return;
	}

	if (g_fZoeySurvivorsWillRevealEndTime[iClient] > 0.0 &&
		g_fZoeySurvivorsWillNextMistTime[iClient] <= GetGameTime())
	{
		g_fZoeySurvivorsWillNextMistTime[iClient] = GetGameTime() + ZOEY_SURVIVORS_WILL_REVEAL_MIST_INTERVAL;
		RevealZoeySurvivorsWillGhosts(iClient);
	}
}

public Action OnSetTransmit_ZoeySurvivorsWillMist(int iEntity, int iClient)
{
	int iOwner = g_iZoeySurvivorsWillMistOwner[iEntity];
	if (RunClientChecks(iClient) == false ||
		iOwner != iClient ||
		RunClientChecks(iOwner) == false ||
		IsPlayerAlive(iOwner) == false ||
		g_fZoeySurvivorsWillRevealEndTime[iOwner] < GetGameTime())
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

bool FindZoeyInstantInterventionTeleportDestination(int iClient, int iTarget, float xyzDestination[3])
{
	if (RunClientChecks(iClient) == false ||
		RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iTarget) == false)
	{
		return false;
	}

	float xyzTargetOrigin[3];
	GetClientAbsOrigin(iTarget, xyzTargetOrigin);

	float fCandidateRadii[4] = {48.0, 80.0, 112.0, 144.0};
	float vHullMins[3] = {-16.0, -16.0, 0.0};
	float vHullMaxs[3] = {16.0, 16.0, 72.0};

	for (int iRadius = 0; iRadius < sizeof(fCandidateRadii); iRadius++)
	{
		for (int iAngle = 0; iAngle < 8; iAngle++)
		{
			float fRadians = DegToRad(float(iAngle) * 45.0);
			float xyzCandidate[3];
			xyzCandidate[0] = xyzTargetOrigin[0] + (Cosine(fRadians) * fCandidateRadii[iRadius]);
			xyzCandidate[1] = xyzTargetOrigin[1] + (Sine(fRadians) * fCandidateRadii[iRadius]);
			xyzCandidate[2] = xyzTargetOrigin[2] + 24.0;

			float xyzTraceStart[3], xyzTraceEnd[3];
			xyzTraceStart = xyzCandidate;
			xyzTraceEnd = xyzCandidate;
			xyzTraceStart[2] += 48.0;
			xyzTraceEnd[2] -= 128.0;

			Handle hGroundTrace = TR_TraceRayFilterEx(xyzTraceStart, xyzTraceEnd, MASK_PLAYERSOLID, RayType_EndPoint, TraceEntityFilter_NotAPlayer, iClient);
			if (TR_DidHit(hGroundTrace) == false)
			{
				CloseHandle(hGroundTrace);
				continue;
			}

			TR_GetEndPosition(xyzCandidate, hGroundTrace);
			CloseHandle(hGroundTrace);
			xyzCandidate[2] += 2.0;

			float xyzCandidateEnd[3];
			xyzCandidateEnd = xyzCandidate;
			xyzCandidateEnd[2] += 1.0;

			Handle hHullTrace = TR_TraceHullFilterEx(xyzCandidate, xyzCandidateEnd, vHullMins, vHullMaxs, MASK_PLAYERSOLID, TraceFilter_NotSelf, iClient);
			bool bBlocked = TR_DidHit(hHullTrace);
			CloseHandle(hHullTrace);

			if (bBlocked)
				continue;

			xyzDestination = xyzCandidate;
			return true;
		}
	}

	return false;
}

int FindZoeyInstantInterventionPickupTarget(float xyzCenter[3], float fRadius)
{
	int iClosestTarget = -1;
	float fClosestDistance = fRadius + 1.0;

	for (int iTarget = 1; iTarget <= MaxClients; iTarget++)
	{
		if (RunClientChecks(iTarget) == false ||
			IsPlayerAlive(iTarget) == false ||
			g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
			IsZoeySacrificialAidTargetDowned(iTarget) == false)
		{
			continue;
		}

		float xyzTargetOrigin[3];
		GetClientAbsOrigin(iTarget, xyzTargetOrigin);
		float fDistance = GetVectorDistance(xyzCenter, xyzTargetOrigin);
		if (fDistance > fRadius || fDistance >= fClosestDistance)
			continue;

		fClosestDistance = fDistance;
		iClosestTarget = iTarget;
	}

	return iClosestTarget;
}

int KillZoeyCommonInfectedAroundLocation(int iClient, float xyzLocation[3], float fRadius)
{
	char strClasses[1][32] = {"infected"};
	int iNearbyEntities[MAXENTITIES];
	int iFoundEntities = GetAllEntitiesInRadiusOfVector(xyzLocation, fRadius, iNearbyEntities, strClasses, sizeof(strClasses));
	int iKilled = 0;

	for (int iIndex = 0; iIndex < iFoundEntities; iIndex++)
	{
		int iEntity = iNearbyEntities[iIndex];
		if (RunEntityChecks(iEntity) == false ||
			IsCommonInfectedAlive(iEntity) == false)
		{
			continue;
		}

		DealZoeySyntheticCIDamage(iClient, iEntity, 9999, DMG_BLAST);
		iKilled++;
	}

	if (iKilled > 0)
		DetonateZoeyTriggerHappyImpact(iClient);

	return iKilled;
}

void HealZoeyInstantInterventionCircle(float xyzLocation[3])
{
	for (int iTarget = 1; iTarget <= MaxClients; iTarget++)
	{
		if (RunClientChecks(iTarget) == false ||
			IsPlayerAlive(iTarget) == false ||
			g_iClientTeam[iTarget] != TEAM_SURVIVORS)
		{
			continue;
		}

		float xyzTargetOrigin[3];
		GetClientAbsOrigin(iTarget, xyzTargetOrigin);
		if (GetVectorDistance(xyzLocation, xyzTargetOrigin) > ZOEY_INSTANT_INTERVENTION_HEALING_CIRCLE_RADIUS)
			continue;

		if (IsZoeySacrificialAidTargetDowned(iTarget))
		{
			int iCurrentIncapHealth = GetEntProp(iTarget, Prop_Data, "m_iHealth");
			if (iCurrentIncapHealth > 0)
				SetEntProp(iTarget, Prop_Data, "m_iHealth", iCurrentIncapHealth + ZOEY_INSTANT_INTERVENTION_HEALING_PER_TICK);

			continue;
		}

		ApplyZoeySharingIsCaringPermanentHeal(iTarget, ZOEY_INSTANT_INTERVENTION_HEALING_PER_TICK);
	}
}

void StartZoeyInstantInterventionHealingCircle(float xyzLocation[3])
{
	int iCircleEntity = CreateSmokeParticle(-1,
		xyzLocation,
		false,
		"",
		140,
		220,
		140,
		120,
		0,
		30,
		10,
		110,
		180,
		10,
		90,
		4,
		ZOEY_INSTANT_INTERVENTION_HEALING_CIRCLE_DURATION);

	if (RunEntityChecks(iCircleEntity) == false)
		return;

	g_xyzZoeyInstantInterventionCircleOrigin[iCircleEntity] = xyzLocation;
	g_iZoeyInstantInterventionCircleTicksRemaining[iCircleEntity] = RoundToFloor(ZOEY_INSTANT_INTERVENTION_HEALING_CIRCLE_DURATION / ZOEY_INSTANT_INTERVENTION_HEALING_CIRCLE_INTERVAL);
	CreateTimer(ZOEY_INSTANT_INTERVENTION_HEALING_CIRCLE_INTERVAL, TimerZoeyInstantInterventionHealingCircleTick, iCircleEntity, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

bool TryActivateZoeyInstantIntervention(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iZoeyTalent6Level[iClient] <= 0)
	{
		return false;
	}

	if (IsZoeyClientDownedOrHanging(iClient) == true || IsClientGrappled(iClient) == true)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Instant Intervention cannot be used while downed, hanging, or grappled.");
		return false;
	}

	if (g_iClientBindUses_2[iClient] >= 3)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "You are out of Instant Intervention uses.");
		return false;
	}

	float fCooldownRemaining = GetZoeyInstantInterventionGlobalCooldownRemaining();
	if (fCooldownRemaining > 0.0)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Instant Intervention cooling down: %0.0f seconds", fCooldownRemaining);
		return false;
	}

	int iTarget = GetClientOfUserId(g_iZoeyInstantInterventionTargetUserId[iClient]);
	if (RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		iTarget == iClient)
	{
		g_iZoeyInstantInterventionTargetUserId[iClient] = 0;
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Instant Intervention target is no longer valid.");
		return false;
	}

	float xyzDestination[3];
	if (FindZoeyInstantInterventionTeleportDestination(iClient, iTarget, xyzDestination) == false)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Instant Intervention could not find a safe landing point.");
		return false;
	}

	g_iClientBindUses_2[iClient]++;
	g_fZoeyInstantInterventionGlobalCooldownEndTime = GetGameTime() + ZOEY_INSTANT_INTERVENTION_GLOBAL_COOLDOWN;
	g_fZoeyInstantInterventionReviveSpeedEndTime[iClient] = GetGameTime() + ZOEY_INSTANT_INTERVENTION_BUFF_DURATION;
	g_iZoeyInstantInterventionTargetUserId[iClient] = 0;

	float xyzAngles[3];
	GetClientEyeAngles(iClient, xyzAngles);
	TeleportEntity(iClient, xyzDestination, xyzAngles, EMPTY_VECTOR);
	WriteParticle(iClient, "teleport_warp", 0.0, 3.0, xyzDestination);
	GrantZoeyResilienceBuff(iClient, ZOEY_INSTANT_INTERVENTION_DAMAGE_REDUCTION, ZOEY_INSTANT_INTERVENTION_BUFF_DURATION);

	int iPickupTarget = FindZoeyInstantInterventionPickupTarget(xyzDestination, ZOEY_INSTANT_INTERVENTION_HEALING_CIRCLE_RADIUS);
	if (RunClientChecks(iPickupTarget))
		ReviveZoeySacrificialAidTarget(iClient, iPickupTarget);

	KillZoeyCommonInfectedAroundLocation(iClient, xyzDestination, ZOEY_INSTANT_INTERVENTION_CI_KILL_RADIUS);
	StartZoeyInstantInterventionHealingCircle(xyzDestination);
	SetClientSpeed(iClient);

	if (IsFakeClient(iClient) == false)
	{
		PrintHintText(iClient, "Instant Intervention activated.\nRevive speed and resilience increased for %.0f seconds.", ZOEY_INSTANT_INTERVENTION_BUFF_DURATION);
		PrintToChat(iClient, "\x03[XPMod] \x04Instant Intervention\x05 used. %d use%s remain.", 3 - g_iClientBindUses_2[iClient], (3 - g_iClientBindUses_2[iClient]) != 1 ? "s" : "");
	}

	return true;
}

void OnGameFrame_Zoey(int iClient)
{
	if (iClient < 0 ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		(g_iZoeyTalent1Level[iClient] <= 0 && g_iZoeyTalent2Level[iClient] <= 0 && g_iZoeyTalent3Level[iClient] <= 0 && g_iZoeyTalent5Level[iClient] <= 0 && g_iZoeyTalent6Level[iClient] <= 0))
		return;

	if (g_iZoeyTalent1Level[iClient] > 0 || g_iZoeyTalent3Level[iClient] > 0)
		HandleZoeyHealingItemMoveSpeed(iClient);

	if (g_iZoeyTalent1Level[iClient] > 0 ||
		g_fZoeyInstantInterventionReviveSpeedEndTime[iClient] > GetGameTime())
	{
		HandleZoeyFastRevive(iClient);
	}

	if (g_iZoeyTalent2Level[iClient] > 0)
		HandleZoeyTriggerHappyState(iClient);

	if (g_iZoeyTalent3Level[iClient] > 0)
		HandleZoeySurvivorsWillState(iClient);

	if (g_iZoeyTalent5Level[iClient] > 0 || g_iZoeyTalent6Level[iClient] > 0)
		HandleZoeyMedicalExpertiseUseSpeed(iClient);
}

bool OnPlayerRunCmd_Zoey(int iClient, int &iButtons)
{
	if (iClient < 0)
		return false;

	bool bButtonsChanged = false;

	if ((g_iZoeyTalent4Level[iClient] > 0 || g_iZoeyTalent5Level[iClient] > 0) &&
		(iButtons & IN_ATTACK) != 0)
	{
		TrackZoeySharingIsCaringBoostUse(iClient);
	}

	if (g_iZoeyTalent1Level[iClient] > 0)
		HandleZoeyProtectedReviveResume(iClient, iButtons);

	if (g_iZoeyTalent6Level[iClient] > 0)
		bButtonsChanged = HandleZoeyInstantInterventionInput(iClient, iButtons) || bButtonsChanged;

	if (g_iZoeyTalent2Level[iClient] > 0 || g_iZoeyTalent3Level[iClient] > 0)
		bButtonsChanged = HandleZoeyWalkUseInput(iClient, iButtons) || bButtonsChanged;

	if (g_iZoeyTalent2Level[iClient] > 0)
		bButtonsChanged = HandleZoeyTriggerHappyInput(iClient, iButtons) || bButtonsChanged;

	return bButtonsChanged;
}

bool HandleZoeyInstantInterventionInput(int iClient, int &iButtons)
{
	SuppressNeverUsedWarning(iButtons);

	bool bWalkPressed = (iButtons & IN_SPEED) != 0 &&
		(iButtons & IN_USE) == 0 &&
		(iButtons & IN_RELOAD) == 0;

	if (bWalkPressed == false)
	{
		g_bZoeyInstantInterventionWalkHeld[iClient] = false;
		return false;
	}

	if (g_bZoeyInstantInterventionWalkHeld[iClient] == true ||
		g_iZoeyInstantInterventionTargetUserId[iClient] == 0)
	{
		return false;
	}

	g_bZoeyInstantInterventionWalkHeld[iClient] = true;
	TryActivateZoeyInstantIntervention(iClient);
	return false;
}

void OGFSurvivorReload_Zoey(int iClient, const char[] strCurrentWeapon, int iActiveWeaponID, int iCurrentClipAmmo, int iOffset_Ammo)
{
	if (iClient < 0 || iActiveWeaponID < -1 || iCurrentClipAmmo < 0 || iOffset_Ammo < 0 || strCurrentWeapon[0] == '\0')
		return;

	if (g_iZoeyTalent2Level[iClient] > 0 &&
		StrEqual(strCurrentWeapon, "weapon_pistol", false) == true &&
		RunEntityChecks(iActiveWeaponID) == true &&
		IsZoeyTriggerHappyNormalClipAmmo(iCurrentClipAmmo))
	{
		if (g_bZoeyExplosiveAmmoLoadPending[iClient] == true)
			LoadZoeyExplosiveAmmoClip(iClient, iActiveWeaponID);
		else
			SetEntData(iActiveWeaponID, g_iOffset_Clip1, ZOEY_TRIGGER_HAPPY_CLIP_SIZE, true);

		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
}

float GetZoeyResilientResuscitationReviveDuration(int iClient)
{
	float fDuration = ZOEY_RESILIENT_RESUSCITATION_BASE_REVIVE_DURATION *
		(1.0 - (float(g_iZoeyTalent1Level[iClient]) * ZOEY_RESILIENT_RESUSCITATION_REVIVE_SPEED_PER_LEVEL));

	if (g_fZoeyInstantInterventionReviveSpeedEndTime[iClient] > GetGameTime())
		fDuration *= (1.0 - ZOEY_INSTANT_INTERVENTION_REVIVE_SPEED_BONUS);

	return fDuration;
}

float GetZoeyResilientResuscitationDamageReduction(int iClient)
{
	return float(g_iZoeyTalent1Level[iClient]) * ZOEY_RESILIENT_RESUSCITATION_DAMAGE_REDUCTION_PER_LEVEL;
}

bool IsZoeyReviveSpeedOverrideActive(int iClient)
{
	return IsZoeyActivelyReviving(iClient) ||
		(g_iZoeyQueuedReviveResumeTarget[iClient] > 0 &&
		g_fZoeyQueuedReviveResumeAllowedUntil[iClient] >= GetGameTime());
}

float GetManagedSurvivorReviveDuration(int iReviveBeginClient = -1)
{
	float fDesiredDuration = g_fDefaultSurvivorReviveDuration;

	if (g_bLouisMedHaxEnabled)
		fDesiredDuration = float(LOUIS_MED_HAX_USE_DURATION);

	if (RunClientChecks(iReviveBeginClient) &&
		g_bTalentsConfirmed[iReviveBeginClient] == true &&
		g_iChosenSurvivor[iReviveBeginClient] == ZOEY &&
		g_iClientTeam[iReviveBeginClient] == TEAM_SURVIVORS &&
		g_iZoeyTalent1Level[iReviveBeginClient] > 0)
	{
		float fZoeyDuration = GetZoeyResilientResuscitationReviveDuration(iReviveBeginClient);
		if (fZoeyDuration > 0.0 && fZoeyDuration < fDesiredDuration)
			fDesiredDuration = fZoeyDuration;
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		if (i == iReviveBeginClient ||
			IsZoeyReviveSpeedOverrideActive(i) == false)
		{
			continue;
		}

		float fZoeyDuration = GetZoeyResilientResuscitationReviveDuration(i);
		if (fZoeyDuration > 0.0 && fZoeyDuration < fDesiredDuration)
			fDesiredDuration = fZoeyDuration;
	}

	return fDesiredDuration;
}

void RefreshManagedSurvivorReviveDuration(int iReviveBeginClient = -1)
{
	if (g_hCVar_SurvivorReviveDuration == null)
		return;

	float fDesiredDuration = GetManagedSurvivorReviveDuration(iReviveBeginClient);
	if (fDesiredDuration <= 0.0)
		fDesiredDuration = g_fDefaultSurvivorReviveDuration;

	if (FloatAbs(g_hCVar_SurvivorReviveDuration.FloatValue - fDesiredDuration) > 0.01)
		g_hCVar_SurvivorReviveDuration.FloatValue = fDesiredDuration;
}

bool CanZoeyContinueReviveTarget(int iClient, int iTarget)
{
	if (RunClientChecks(iClient) == false ||
		RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iClient) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		g_iZoeyTalent1Level[iClient] <= 0 ||
		IsZoeyClientDownedOrHanging(iClient) == true ||
		IsClientGrappled(iClient) == true ||
		IsZoeySacrificialAidTargetDowned(iTarget) == false)
	{
		return false;
	}

	if ((GetEntProp(iClient, Prop_Data, "m_nButtons") & IN_USE) == 0)
		return false;

	float xyzClientEye[3], xyzTargetEye[3];
	GetClientEyePosition(iClient, xyzClientEye);
	GetClientEyePosition(iTarget, xyzTargetEye);

	if (GetVectorDistance(xyzClientEye, xyzTargetEye) > ZOEY_RESILIENT_RESUSCITATION_MAX_REVIVE_DISTANCE)
		return false;

	return IsVisibleTo(xyzClientEye, xyzTargetEye);
}

bool IsZoeyHealingItemWeaponClass(const char[] strWeaponClass)
{
	return StrEqual(strWeaponClass, "weapon_first_aid_kit", false) ||
		StrEqual(strWeaponClass, "weapon_defibrillator", false) ||
		StrEqual(strWeaponClass, "weapon_pain_pills", false) ||
		StrEqual(strWeaponClass, "weapon_adrenaline", false);
}

bool IsZoeyHoldingHealingItem(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return false;

	return IsZoeyHealingItemWeaponClass(g_strActiveWeaponClass[iClient]);
}

bool IsZoeyActivelyReviving(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iZoeyTalent1Level[iClient] <= 0 ||
		IsZoeyClientDownedOrHanging(iClient) == true ||
		IsClientGrappled(iClient) == true)
		return false;

	for (int iTarget = 1; iTarget <= MaxClients; iTarget++)
	{
		if (iTarget == iClient ||
			IsClientInGame(iTarget) == false ||
			GetClientTeam(iTarget) != TEAM_SURVIVORS ||
			GetEntPropEnt(iTarget, Prop_Send, "m_reviveOwner") != iClient)
			continue;

		return true;
	}

	return false;
}

int GetZoeyCurrentReviveTarget(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return -1;

	for (int iTarget = 1; iTarget <= MaxClients; iTarget++)
	{
		if (iTarget == iClient ||
			IsClientInGame(iTarget) == false ||
			GetClientTeam(iTarget) != TEAM_SURVIVORS ||
			GetEntPropEnt(iTarget, Prop_Send, "m_reviveOwner") != iClient)
			continue;

		return iTarget;
	}

	return -1;
}

bool IsClientBeingRevivedByZoey(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return false;

	int iReviveOwner = GetEntPropEnt(iClient, Prop_Send, "m_reviveOwner");
	return RunClientChecks(iReviveOwner) &&
		g_bTalentsConfirmed[iReviveOwner] == true &&
		g_iChosenSurvivor[iReviveOwner] == ZOEY &&
		g_iClientTeam[iReviveOwner] == TEAM_SURVIVORS &&
		g_iZoeyTalent1Level[iReviveOwner] > 0;
}

void QueueZoeyReviveResume(int iZoey, int iTarget)
{
	if (RunClientChecks(iZoey) == false ||
		RunClientChecks(iTarget) == false ||
		g_bTalentsConfirmed[iZoey] == false ||
		g_iChosenSurvivor[iZoey] != ZOEY ||
		g_iClientTeam[iZoey] != TEAM_SURVIVORS ||
		g_iZoeyTalent1Level[iZoey] <= 0)
		return;

	float fProgressBarDuration = GetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarDuration");
	if (fProgressBarDuration <= 0.0)
		return;

	float fProgressBarStartTime = GetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarStartTime");
	float fCurrentProgress = (GetGameTime() - fProgressBarStartTime) / fProgressBarDuration;

	if (fCurrentProgress < 0.0)
		fCurrentProgress = 0.0;
	else if (fCurrentProgress > 1.0)
		fCurrentProgress = 1.0;

	g_iZoeyQueuedReviveResumeTarget[iZoey] = iTarget;
	g_fZoeyQueuedReviveResumeDuration[iZoey] = GetZoeyResilientResuscitationReviveDuration(iZoey);
	g_fZoeyQueuedReviveResumeProgress[iZoey] = fCurrentProgress;
	g_fZoeyQueuedReviveResumeAllowedUntil[iZoey] = GetGameTime() + ZOEY_RESILIENT_RESUSCITATION_RESUME_GRACE_DURATION;
	RefreshManagedSurvivorReviveDuration(iZoey);
}

void QueueZoeyReviveResumeFromCommonHit(int iVictim)
{
	if (IsZoeyActivelyReviving(iVictim))
	{
		int iTarget = GetZoeyCurrentReviveTarget(iVictim);
		if (RunClientChecks(iTarget))
			QueueZoeyReviveResume(iVictim, iTarget);

		return;
	}

	if (IsClientBeingRevivedByZoey(iVictim))
	{
		int iZoey = GetEntPropEnt(iVictim, Prop_Send, "m_reviveOwner");
		if (RunClientChecks(iZoey))
			QueueZoeyReviveResume(iZoey, iVictim);
	}
}

void ClearZoeyQueuedReviveResume(int iZoey)
{
	g_iZoeyQueuedReviveResumeTarget[iZoey] = -1;
	g_fZoeyQueuedReviveResumeDuration[iZoey] = 0.0;
	g_fZoeyQueuedReviveResumeProgress[iZoey] = 0.0;
	g_fZoeyQueuedReviveResumeAllowedUntil[iZoey] = -1.0;
	RefreshManagedSurvivorReviveDuration();
}

void HandleZoeyProtectedReviveResume(int iZoey, int iButtons)
{
	SuppressNeverUsedWarning(iButtons);

	if (g_iZoeyQueuedReviveResumeTarget[iZoey] <= 0)
		return;

	int iTarget = g_iZoeyQueuedReviveResumeTarget[iZoey];
	float fProgress = g_fZoeyQueuedReviveResumeProgress[iZoey];

	if (g_fZoeyQueuedReviveResumeAllowedUntil[iZoey] < GetGameTime())
	{
		ClearZoeyQueuedReviveResume(iZoey);
		return;
	}

	if (CanZoeyContinueReviveTarget(iZoey, iTarget) == false)
	{
		ClearZoeyQueuedReviveResume(iZoey);
		return;
	}

	if (GetEntPropEnt(iTarget, Prop_Send, "m_reviveOwner") == iZoey)
	{
		ClearZoeyQueuedReviveResume(iZoey);
		return;
	}

	int iExistingReviveOwner = GetEntPropEnt(iTarget, Prop_Send, "m_reviveOwner");
	if (iExistingReviveOwner != -1 && iExistingReviveOwner != iZoey)
	{
		ClearZoeyQueuedReviveResume(iZoey);
		return;
	}

	float fDuration = GetZoeyResilientResuscitationReviveDuration(iZoey);

	if (fProgress < 0.0)
		fProgress = 0.0;
	else if (fProgress > 1.0)
		fProgress = 1.0;

	SetEntPropEnt(iTarget, Prop_Send, "m_reviveOwner", iZoey);
	SetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarDuration", fDuration);
	SetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarStartTime", GetGameTime() - (fProgress * fDuration));
	ClearZoeyQueuedReviveResume(iZoey);
	RefreshManagedSurvivorReviveDuration(iZoey);
}

void HandleZoeyHealingItemMoveSpeed(int iClient)
{
	int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (RunEntityChecks(iActiveWeaponID) == false)
	{
		if (g_iLastActiveWeaponRef[iClient] != -1)
		{
			g_iLastActiveWeaponRef[iClient] = -1;
			g_strActiveWeaponClass[iClient] = "";
			SetClientSpeed(iClient);
		}
		return;
	}

	if (iActiveWeaponID != g_iLastActiveWeaponRef[iClient])
	{
		g_iLastActiveWeaponRef[iClient] = iActiveWeaponID;
		GetEntityClassname(iActiveWeaponID, g_strActiveWeaponClass[iClient], sizeof(g_strActiveWeaponClass[]));
		SetClientSpeed(iClient);
	}
}

void HandleZoeyFastRevive(int iClient)
{
	SuppressNeverUsedWarning(iClient);
	RefreshManagedSurvivorReviveDuration();
	RefreshManagedFirstAidKitUseDuration();
}

void ApplyZoeyResilientResuscitation(int iClient, int iTarget)
{
	if (RunClientChecks(iClient) == false ||
		RunClientChecks(iTarget) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iZoeyTalent1Level[iClient] <= 0 ||
		iClient == iTarget)
		return;

	float fDamageReduction = GetZoeyResilientResuscitationDamageReduction(iClient);
	if (fDamageReduction <= 0.0)
		return;

	GrantZoeyResilienceBuff(iTarget, fDamageReduction, ZOEY_RESILIENT_RESUSCITATION_DURATION);

	int iReductionPercent = RoundToNearest(fDamageReduction * 100.0);
	int iDurationSeconds = RoundToNearest(ZOEY_RESILIENT_RESUSCITATION_DURATION);

	if (IsFakeClient(iTarget) == false)
		PrintHintText(iTarget, "%N revived you.\nYou gain %d%% damage reduction for %d seconds.", iClient, iReductionPercent, iDurationSeconds);

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "%N gains %d%% resilience for %d seconds.", iTarget, iReductionPercent, iDurationSeconds);
}

void ConvertZoeyReviveHealthToPermanent(int iClient, int iTarget)
{
	if (RunClientChecks(iClient) == false ||
		RunClientChecks(iTarget) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iZoeyTalent1Level[iClient] <= 0 ||
		iClient == iTarget ||
		IsPlayerAlive(iTarget) == false ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS)
		return;

	int iCurrentHealth = GetPlayerHealth(iTarget);
	int iTempHealth = GetSurvivorTempHealth(iTarget);
	if (iTempHealth <= 0)
		return;

	SetPlayerHealth(iTarget, -1, iCurrentHealth + iTempHealth, false, false);
	ResetTempHealthToSurvivor(iTarget);
}

void EventsHurt_ApplyZoeyResilience(int iAttacker, int iVictim, int iDamage, int iDmgType)
{
	if (RunClientChecks(iVictim) == false ||
		g_iClientTeam[iVictim] != TEAM_SURVIVORS)
		return;

	float fCurrentTime = GetGameTime();
	if (g_fZoeyResilienceEndTime[iVictim] < fCurrentTime ||
		g_fZoeyResilienceDamageReduction[iVictim] <= 0.0)
	{
		g_fZoeyResilienceEndTime[iVictim] = -1.0;
		g_fZoeyResilienceDamageReduction[iVictim] = 0.0;
		return;
	}

	if ((iDmgType & (DMG_DROWN | DMG_DISSOLVE | DMG_REMOVENORAGDOLL | DMG_FALL | DMG_CRUSH)) ||
		canchangemovement[iVictim] == false ||
		g_bChargerGrappled[iVictim] == true ||
		(iAttacker <= 0 && iDmgType != DAMAGETYPE_INFECTED_MELEE))
		return;

	int iReductionAmount = RoundToFloor(float(iDamage) * g_fZoeyResilienceDamageReduction[iVictim]);
	if (iReductionAmount >= iDamage)
		iReductionAmount = iDamage - 1;

	if (iReductionAmount > 0)
		SetPlayerHealth(iVictim, -1, iReductionAmount, true);
}

void EventsDeath_VictimZoey(Handle hEvent, int iAttacker, int iVictim)
{
	SuppressNeverUsedWarning(hEvent, iAttacker);

	if (g_iClientTeam[iVictim] != TEAM_SURVIVORS ||
		g_iChosenSurvivor[iVictim] != ZOEY)
	{
		return;
	}

	ClearZoeyInstantInterventionState(iVictim);
	RefreshManagedSurvivorReviveDuration();
}

bool IsZoeyTriggerHappyWeaponClass(const char[] strWeaponClass)
{
	return StrEqual(strWeaponClass, "weapon_pistol", false);
}

bool IsZoeyTriggerHappyNormalClipAmmo(int iClipAmmo)
{
	return iClipAmmo == 15 || iClipAmmo == 30;
}

bool IsZoeyTriggerHappyEventWeapon(const char[] strWeaponClass)
{
	return StrEqual(strWeaponClass, "weapon_pistol", false) ||
		StrEqual(strWeaponClass, "pistol", false) ||
		StrEqual(strWeaponClass, "dual_pistols", false);
}

void RecordZoeyTriggerHappyShot(int iClient, const char[] strWeaponClass)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iZoeyTalent2Level[iClient] <= 0 ||
		IsZoeyTriggerHappyEventWeapon(strWeaponClass) == false)
	{
		return;
	}

	g_fZoeyLastTriggerHappyShotTime[iClient] = GetGameTime();
}

bool DidZoeyRecentlyFireTriggerHappyWeapon(int iClient)
{
	return RunClientChecks(iClient) &&
		IsPlayerAlive(iClient) &&
		g_bTalentsConfirmed[iClient] &&
		g_iChosenSurvivor[iClient] == ZOEY &&
		g_iClientTeam[iClient] == TEAM_SURVIVORS &&
		g_iZoeyTalent2Level[iClient] > 0 &&
		(g_fZoeyLastTriggerHappyShotTime[iClient] + ZOEY_TRIGGER_HAPPY_SHOT_EVENT_WINDOW) >= GetGameTime();
}

bool IsZoeyHoldingMachinePistols(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return false;

	char strCurrentWeapon[32];
	GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
	return IsZoeyTriggerHappyWeaponClass(strCurrentWeapon);
}

void EnsureZoeyDualPistols(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return;

	int iSecondaryWeapon = GetPlayerWeaponSlot(iClient, 1);
	if (RunEntityChecks(iSecondaryWeapon) == false)
		return;

	char strWeaponClass[32];
	GetEntityClassname(iSecondaryWeapon, strWeaponClass, sizeof(strWeaponClass));
	if (IsZoeyTriggerHappyWeaponClass(strWeaponClass) == false)
		return;

	int iCurrentClipAmmo = GetEntProp(iSecondaryWeapon, Prop_Data, "m_iClip1");
	if (iCurrentClipAmmo <= 15)
		RunCheatCommand(iClient, "give", "give pistol");

	if (RunEntityChecks(iSecondaryWeapon))
	{
		iCurrentClipAmmo = GetEntProp(iSecondaryWeapon, Prop_Data, "m_iClip1");
		if (iCurrentClipAmmo > 0 && iCurrentClipAmmo < ZOEY_TRIGGER_HAPPY_CLIP_SIZE)
			SetEntData(iSecondaryWeapon, g_iOffset_Clip1, ZOEY_TRIGGER_HAPPY_CLIP_SIZE, true);
	}
}

void StripZoeyPrimaryWeapon(int iClient)
{
	int iPrimaryWeapon = GetPlayerWeaponSlot(iClient, 0);
	if (RunEntityChecks(iPrimaryWeapon) == false)
		return;

	if (GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon) == iPrimaryWeapon)
		ClientCommand(iClient, "slot2");

	SDKHooks_DropWeapon(iClient, iPrimaryWeapon);

	if (g_fZoeyPrimaryStripHintCooldown[iClient] <= GetGameTime() &&
		IsFakeClient(iClient) == false)
	{
		PrintHintText(iClient, "Trigger Happy disables primary weapons.");
		g_fZoeyPrimaryStripHintCooldown[iClient] = GetGameTime() + 2.0;
	}
}

void HandleZoeyTriggerHappyState(int iClient)
{
	StripZoeyPrimaryWeapon(iClient);

	if (g_bZoeyExplosiveAmmoActive[iClient] == false)
		return;

	int iSecondaryWeapon = GetPlayerWeaponSlot(iClient, 1);
	if (RunEntityChecks(iSecondaryWeapon) == false)
		return;

	char strWeaponClass[32];
	GetEntityClassname(iSecondaryWeapon, strWeaponClass, sizeof(strWeaponClass));
	if (IsZoeyTriggerHappyWeaponClass(strWeaponClass) == false)
		return;

	int iCurrentClipAmmo = GetEntProp(iSecondaryWeapon, Prop_Data, "m_iClip1");
	if (iCurrentClipAmmo > ZOEY_TRIGGER_HAPPY_CLIP_SIZE)
	{
		SetEntData(iSecondaryWeapon, g_iOffset_Clip1, ZOEY_TRIGGER_HAPPY_CLIP_SIZE, true);
		iCurrentClipAmmo = ZOEY_TRIGGER_HAPPY_CLIP_SIZE;
	}

	if (iCurrentClipAmmo <= 0)
		DeactivateZoeyExplosiveAmmo(iClient, true);
}

bool HandleZoeyWalkUseInput(int iClient, int &iButtons)
{
	bool bWalkUsePressed = (iButtons & IN_SPEED) && (iButtons & IN_USE);

	if (bWalkUsePressed == false)
	{
		g_bZoeyWalkUseHeld[iClient] = false;
		return false;
	}

	if (g_bZoeyWalkUseHeld[iClient] == true)
		return false;

	g_bZoeyWalkUseHeld[iClient] = true;

	if (g_iZoeyTalent3Level[iClient] > 0 &&
		IsZoeyHoldingMedkit(iClient) == true)
	{
		TryStartZoeySurvivorsWillCharge(iClient);
		iButtons &= ~IN_USE;
		return true;
	}

	if (g_iZoeyTalent2Level[iClient] > 0 &&
		IsZoeyHoldingMachinePistols(iClient) == true)
	{
		ToggleZoeyMopArmed(iClient);
		iButtons &= ~IN_USE;
		return true;
	}

	return false;
}

bool HandleZoeyTriggerHappyInput(int iClient, int &iButtons)
{
	bool bButtonsChanged = false;
	bool bWalkReloadPressed = (iButtons & IN_SPEED) && (iButtons & IN_RELOAD);

	if (bWalkReloadPressed == false)
		g_bZoeyWalkReloadHeld[iClient] = false;

	if (bWalkReloadPressed &&
		g_bZoeyWalkReloadHeld[iClient] == false)
	{
		g_bZoeyWalkReloadHeld[iClient] = true;
		if (ActivateZoeyExplosiveAmmo(iClient) == true)
		{
			iButtons &= ~IN_RELOAD;
			bButtonsChanged = true;
		}
	}

	return bButtonsChanged;
}

void LoadZoeyExplosiveAmmoClip(int iClient, int iActiveWeaponID)
{
	if (RunEntityChecks(iActiveWeaponID) == false)
		return;

	SetEntData(iActiveWeaponID, g_iOffset_Clip1, ZOEY_TRIGGER_HAPPY_CLIP_SIZE, true);
	g_bZoeyExplosiveAmmoActive[iClient] = true;
	g_bZoeyExplosiveAmmoLoadPending[iClient] = false;

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Explosive ammo loaded.\nCooldown begins after this clip runs dry.");
}

void CancelZoeyExplosiveAmmoPendingLoad(int iClient)
{
	g_bZoeyExplosiveAmmoLoadPending[iClient] = false;
}

void TryCancelZoeyExplosiveAmmoOnPrematureReload(int iClient, const char[] strCurrentWeapon, int iActiveWeaponID)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iZoeyTalent2Level[iClient] <= 0 ||
		g_bZoeyExplosiveAmmoActive[iClient] == false ||
		StrEqual(strCurrentWeapon, "weapon_pistol", false) == false ||
		RunEntityChecks(iActiveWeaponID) == false)
	{
		return;
	}

	int iCurrentClipAmmo = GetEntProp(iActiveWeaponID, Prop_Data, "m_iClip1");
	if (iCurrentClipAmmo > 0 && iCurrentClipAmmo < ZOEY_TRIGGER_HAPPY_CLIP_SIZE)
		DeactivateZoeyExplosiveAmmo(iClient, true);
}

bool ActivateZoeyExplosiveAmmo(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		IsZoeyClientDownedOrHanging(iClient) == true ||
		IsClientGrappled(iClient) == true)
	{
		return false;
	}

	if (IsZoeyHoldingMachinePistols(iClient) == false)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Trigger Happy requires dual pistols equipped.");
		return false;
	}

	if (g_bZoeyExplosiveAmmoActive[iClient] == true)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Explosive machine-pistol ammo is already active.");
		return false;
	}

	if (g_bZoeyExplosiveAmmoLoadPending[iClient] == true)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Explosive ammo is queued.\nFinish the reload to load the clip.");
		return false;
	}

	float fCooldownRemaining = g_fZoeyExplosiveAmmoCooldownEndTime[iClient] - GetGameTime();
	if (fCooldownRemaining > 0.0)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Explosive ammo cooling down: %0.0f seconds", fCooldownRemaining);
		return false;
	}

	int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (RunEntityChecks(iActiveWeaponID) == false)
		return false;

	int iCurrentClipAmmo = GetEntProp(iActiveWeaponID, Prop_Data, "m_iClip1");
	if (IsZoeyTriggerHappyNormalClipAmmo(iCurrentClipAmmo))
	{
		LoadZoeyExplosiveAmmoClip(iClient, iActiveWeaponID);
		return true;
	}

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Explosive ammo primed.\nFinish reloading to load the clip.");

	g_bZoeyExplosiveAmmoLoadPending[iClient] = true;
	return false;
}

void DeactivateZoeyExplosiveAmmo(int iClient, bool bStartCooldown)
{
	if (g_bZoeyExplosiveAmmoActive[iClient] == false && bStartCooldown == false)
		return;

	g_bZoeyExplosiveAmmoActive[iClient] = false;
	g_bZoeyExplosiveAmmoLoadPending[iClient] = false;

	if (bStartCooldown)
	{
		g_fZoeyExplosiveAmmoCooldownEndTime[iClient] = GetGameTime() + ZOEY_TRIGGER_HAPPY_EXPLOSIVE_AMMO_COOLDOWN;
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Explosive ammo ended.\n30 second cooldown started.");
	}
}

void ToggleZoeyMopArmed(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;

	if (g_iZoeyMopCharge[iClient] <= 0)
	{
		g_bZoeyMopArmed[iClient] = false;
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Mop 'Til They Drop has no stored charge.");
		return;
	}

	g_bZoeyMopArmed[iClient] = !g_bZoeyMopArmed[iClient];
	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Mop 'Til They Drop: %s\nStored Charge: %d", g_bZoeyMopArmed[iClient] ? "ARMED" : "DISARMED", g_iZoeyMopCharge[iClient]);
}

void AddZoeyMopHit(int iClient)
{
	if (g_iZoeyTalent2Level[iClient] <= 0)
		return;

	g_iZoeyMopHitCounter[iClient]++;
	if (g_iZoeyMopHitCounter[iClient] < ZOEY_MOP_THE_FLOOR_HITS_PER_CHARGE)
		return;

	g_iZoeyMopHitCounter[iClient] -= ZOEY_MOP_THE_FLOOR_HITS_PER_CHARGE;
	g_iZoeyMopCharge[iClient]++;

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Mop Charge: %d", g_iZoeyMopCharge[iClient]);
}

void DetonateZoeyTriggerHappyImpact(int iEntity)
{
	if (RunEntityChecks(iEntity) == false)
		return;

	float xyzImpactLocation[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", xyzImpactLocation);
	WriteParticle(iEntity, "boomer_explode", 0.0, 1.0, xyzImpactLocation);
	EmitSoundToAll(SOUND_EXPLODE, iEntity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzImpactLocation, NULL_VECTOR, true, 0.0);
}

void DealZoeySyntheticCIDamage(int iClient, int iVictim, int iDamage, int iDamageType)
{
	g_bZoeySuppressSyntheticCIHurt[iClient] = true;
	DealDamage(iVictim, iClient, iDamage, iDamageType);
	g_bZoeySuppressSyntheticCIHurt[iClient] = false;
}

void TryTriggerZoeyMop(int iClient, int iTargetEntity)
{
	if (g_bZoeyMopArmed[iClient] == false)
		return;

	g_bZoeyMopArmed[iClient] = false;

	if (g_iZoeyMopCharge[iClient] <= 0)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Mop 'Til They Drop fizzles.\nNo stored charge.");
		return;
	}

	int iKillLimit = g_iZoeyMopCharge[iClient];
	int iKilled = KillZoeyCommonInfectedAroundTarget(iClient, iTargetEntity, iKillLimit);
	g_iZoeyMopCharge[iClient] = 0;

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Mop The Floor triggered.\nKilled %d common infected.", iKilled);
}

int KillZoeyCommonInfectedAroundTarget(int iClient, int iTargetEntity, int iKillLimit)
{
	if (RunEntityChecks(iTargetEntity) == false || iKillLimit <= 0)
		return 0;

	float xyzTargetLocation[3];
	GetEntPropVector(iTargetEntity, Prop_Send, "m_vecOrigin", xyzTargetLocation);

	char strClasses[1][32] = {"infected"};
	int iNearbyEntities[MAXENTITIES];
	int iFoundEntities = GetAllEntitiesInRadiusOfVector(xyzTargetLocation, ZOEY_MOP_THE_FLOOR_RADIUS, iNearbyEntities, strClasses, sizeof(strClasses));
	int iKilled = 0;

	for (int iIndex = 0; iIndex < iFoundEntities && iKilled < iKillLimit; iIndex++)
	{
		int iEntity = iNearbyEntities[iIndex];
		if (RunEntityChecks(iEntity) == false ||
			IsCommonInfectedAlive(iEntity) == false)
			continue;

		DealZoeySyntheticCIDamage(iClient, iEntity, 9999, DMG_BLAST);
		iKilled++;
	}

	if (iKilled > 0)
		DetonateZoeyTriggerHappyImpact(iTargetEntity);

	return iKilled;
}

void EventsHurt_AttackerZoey(Handle hEvent, int iAttacker, int iVictim)
{
	if (g_iChosenSurvivor[iAttacker] != ZOEY ||
		g_bTalentsConfirmed[iAttacker] == false ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		g_iClientTeam[iVictim] != TEAM_INFECTED ||
		RunClientChecks(iAttacker) == false ||
		IsFakeClient(iAttacker) == true ||
		g_iZoeyTalent2Level[iAttacker] <= 0)
		return;

	char strWeaponClass[32];
	GetEventString(hEvent, "weapon", strWeaponClass, sizeof(strWeaponClass));
	if (IsZoeyTriggerHappyEventWeapon(strWeaponClass) == false)
		return;

	TryTriggerZoeyMop(iAttacker, iVictim);
	AddZoeyMopHit(iAttacker);

	if (g_bZoeyExplosiveAmmoActive[iAttacker] == false)
		return;

	int iVictimHealth = GetPlayerHealth(iVictim);
	int iDamage = GetEventInt(hEvent, "dmg_health");
	int iBonusDamage = RoundToNearest(float(iDamage) * ZOEY_TRIGGER_HAPPY_EXPLOSIVE_SI_DAMAGE_MULTIPLIER);
	if (iBonusDamage <= 0)
		return;

	iBonusDamage = CalculateDamageTakenForVictimTalents(iVictim, iBonusDamage, strWeaponClass);
	SetPlayerHealth(iVictim, iAttacker, iVictimHealth - iBonusDamage);
	DetonateZoeyTriggerHappyImpact(iVictim);
}

void EventsInfectedHurt_Zoey(Handle hEvent, int iAttacker, int iVictim)
{
	SuppressNeverUsedWarning(hEvent);

	if (g_iChosenSurvivor[iAttacker] != ZOEY ||
		g_bTalentsConfirmed[iAttacker] == false ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		RunClientChecks(iAttacker) == false ||
		IsFakeClient(iAttacker) == true ||
		g_iZoeyTalent2Level[iAttacker] <= 0 ||
		RunEntityChecks(iVictim) == false)
		return;

	if (g_bZoeySuppressSyntheticCIHurt[iAttacker] == true)
		return;

	// infected_hurt does not expose the shot weapon, so consume the recent weapon_fire record instead.
	if (DidZoeyRecentlyFireTriggerHappyWeapon(iAttacker) == false)
		return;

	TryTriggerZoeyMop(iAttacker, iVictim);
	AddZoeyMopHit(iAttacker);

	if (g_bZoeyExplosiveAmmoActive[iAttacker])
	{
		DealZoeySyntheticCIDamage(iAttacker, iVictim, 9999, DMG_BLAST);
		DetonateZoeyTriggerHappyImpact(iVictim);
	}
}

void EventsItemPickUp_Zoey(int iClient, const char[] strWeaponClass)
{
	if (g_iChosenSurvivor[iClient] != ZOEY ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iZoeyTalent2Level[iClient] <= 0)
		return;

	if (StrEqual(strWeaponClass, "pistol", false) == true)
	{
		EnsureZoeyDualPistols(iClient);

		int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
		if (RunEntityChecks(iActiveWeaponID))
			SetEntData(iActiveWeaponID, g_iOffset_Clip1, ZOEY_TRIGGER_HAPPY_CLIP_SIZE, true);
		return;
	}

	if (StrContains(strWeaponClass, "rifle", false) != -1 ||
		StrContains(strWeaponClass, "shotgun", false) != -1 ||
		StrContains(strWeaponClass, "smg", false) != -1 ||
		StrContains(strWeaponClass, "sniper", false) != -1 ||
		StrContains(strWeaponClass, "launcher", false) != -1 ||
		StrContains(strWeaponClass, "m60", false) != -1)
		StripZoeyPrimaryWeapon(iClient);
}
