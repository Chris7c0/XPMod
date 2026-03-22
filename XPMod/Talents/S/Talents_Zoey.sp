void TalentsLoad_Zoey(int iClient)
{
	g_fZoeyResilienceEndTime[iClient] = -1.0;
	g_fZoeyResilienceDamageReduction[iClient] = 0.0;
	g_iZoeyQueuedReviveResumeTarget[iClient] = -1;
	g_fZoeyQueuedReviveResumeDuration[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeProgress[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeAllowedUntil[iClient] = -1.0;

	SetPlayerTalentMaxHealth_Zoey(iClient, !g_bConfirmedSurvivorTalentsGivenThisRound[iClient]);
	SetClientSpeed(iClient);

	if ((g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Rapid Combat Medic Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilties will be automatically set as you level.");
}

void ResetZoeyTalentsRuntimeState(int iClient)
{
	g_fZoeyResilienceEndTime[iClient] = -1.0;
	g_fZoeyResilienceDamageReduction[iClient] = 0.0;
	g_iZoeyQueuedReviveResumeTarget[iClient] = -1;
	g_fZoeyQueuedReviveResumeDuration[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeProgress[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeAllowedUntil[iClient] = -1.0;

	SetClientSpeed(iClient);
}

void SetPlayerTalentMaxHealth_Zoey(int iClient, bool bFillInHealthGap = true)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;
	
	SetPlayerMaxHealth(iClient, 100, false, bFillInHealthGap);
}

void OnGameFrame_Zoey(int iClient)
{
	if (iClient < 0 ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_iZoeyTalent1Level[iClient] <= 0)
		return;

	HandleZoeyHealingItemMoveSpeed(iClient);
	HandleZoeyFastRevive(iClient);
}

bool OnPlayerRunCmd_Zoey(int iClient, int &iButtons)
{
	if (iClient < 0 && iButtons < 0)
		return true;

	HandleZoeyProtectedReviveResume(iClient, iButtons);

	return false;
}

void OGFSurvivorReload_Zoey(int iClient, const char[] strCurrentWeapon, int iActiveWeaponID, int iCurrentClipAmmo, int iOffset_Ammo)
{
	if (iClient < 0 || iActiveWeaponID < -1 || iCurrentClipAmmo < 0 || iOffset_Ammo < 0 || strCurrentWeapon[0] == '\0')
		return;
}

float GetZoeyResilientResuscitationReviveDuration(int iClient)
{
	return ZOEY_RESILIENT_RESUSCITATION_BASE_REVIVE_DURATION *
		(1.0 - (float(g_iZoeyTalent1Level[iClient]) * ZOEY_RESILIENT_RESUSCITATION_REVIVE_SPEED_PER_LEVEL));
}

float GetZoeyResilientResuscitationDamageReduction(int iClient)
{
	return float(g_iZoeyTalent1Level[iClient]) * ZOEY_RESILIENT_RESUSCITATION_DAMAGE_REDUCTION_PER_LEVEL;
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
		g_bIsClientDown[iClient] == true ||
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
	g_fZoeyQueuedReviveResumeDuration[iZoey] = fProgressBarDuration;
	g_fZoeyQueuedReviveResumeProgress[iZoey] = fCurrentProgress;
	g_fZoeyQueuedReviveResumeAllowedUntil[iZoey] = GetGameTime() + 0.25;
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
}

void HandleZoeyProtectedReviveResume(int iZoey, int iButtons)
{
	if (g_iZoeyQueuedReviveResumeTarget[iZoey] <= 0)
		return;

	int iTarget = g_iZoeyQueuedReviveResumeTarget[iZoey];
	float fDuration = g_fZoeyQueuedReviveResumeDuration[iZoey];
	float fProgress = g_fZoeyQueuedReviveResumeProgress[iZoey];

	if (g_fZoeyQueuedReviveResumeAllowedUntil[iZoey] < GetGameTime())
	{
		ClearZoeyQueuedReviveResume(iZoey);
		return;
	}

	if (RunClientChecks(iZoey) == false ||
		RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iZoey) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_bTalentsConfirmed[iZoey] == false ||
		g_iChosenSurvivor[iZoey] != ZOEY ||
		g_iClientTeam[iZoey] != TEAM_SURVIVORS ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
		g_iZoeyTalent1Level[iZoey] <= 0 ||
		g_bIsClientDown[iZoey] == true ||
		IsClientGrappled(iZoey) == true ||
		(iButtons & IN_USE) == 0 ||
		IsIncap(iTarget) == false)
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

	if (fDuration <= 0.0)
		fDuration = GetZoeyResilientResuscitationReviveDuration(iZoey);

	if (fProgress < 0.0)
		fProgress = 0.0;
	else if (fProgress > 1.0)
		fProgress = 1.0;

	SetEntPropEnt(iTarget, Prop_Send, "m_reviveOwner", iZoey);
	SetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarDuration", fDuration);
	SetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarStartTime", GetGameTime() - (fProgress * fDuration));
	ClearZoeyQueuedReviveResume(iZoey);
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
	float fDesiredDuration = GetZoeyResilientResuscitationReviveDuration(iClient);
	float fCurrentTime = GetGameTime();

	for (int iTarget = 1; iTarget <= MaxClients; iTarget++)
	{
		if (iTarget == iClient ||
			IsClientInGame(iTarget) == false ||
			GetClientTeam(iTarget) != TEAM_SURVIVORS ||
			GetEntPropEnt(iTarget, Prop_Send, "m_reviveOwner") != iClient)
			continue;

		float fProgressBarDuration = GetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarDuration");
		if (fProgressBarDuration <= 0.0 ||
			fProgressBarDuration <= fDesiredDuration + 0.01)
			continue;

		float fProgressBarStartTime = GetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarStartTime");
		float fCurrentProgress = (fCurrentTime - fProgressBarStartTime) / fProgressBarDuration;

		if (fCurrentProgress < 0.0)
			fCurrentProgress = 0.0;
		else if (fCurrentProgress > 1.0)
			fCurrentProgress = 1.0;

		SetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarStartTime", fCurrentTime - (fCurrentProgress * fDesiredDuration));
		SetEntPropFloat(iTarget, Prop_Send, "m_flProgressBarDuration", fDesiredDuration);
	}
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

	g_fZoeyResilienceEndTime[iTarget] = GetGameTime() + ZOEY_RESILIENT_RESUSCITATION_DURATION;
	g_fZoeyResilienceDamageReduction[iTarget] = fDamageReduction;

	int iReductionPercent = RoundToNearest(fDamageReduction * 100.0);
	int iDurationSeconds = RoundToNearest(ZOEY_RESILIENT_RESUSCITATION_DURATION);

	if (IsFakeClient(iTarget) == false)
		PrintHintText(iTarget, "%N revived you.\nYou gain %d%% damage reduction for %d seconds.", iClient, iReductionPercent, iDurationSeconds);

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "%N gains %d%% resilience for %d seconds.", iTarget, iReductionPercent, iDurationSeconds);
}

void ConvertZoeyReviveHealthToPermanent(int iTarget)
{
	if (RunClientChecks(iTarget) == false ||
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
