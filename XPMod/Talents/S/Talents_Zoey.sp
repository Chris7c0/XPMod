void TalentsLoad_Zoey(int iClient)
{
	g_fZoeyResilienceEndTime[iClient] = -1.0;
	g_fZoeyResilienceDamageReduction[iClient] = 0.0;
	g_iZoeyQueuedReviveResumeTarget[iClient] = -1;
	g_fZoeyQueuedReviveResumeDuration[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeProgress[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeAllowedUntil[iClient] = -1.0;
	g_bZoeyExplosiveAmmoActive[iClient] = false;
	g_fZoeyExplosiveAmmoCooldownEndTime[iClient] = -1.0;
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
	g_fZoeyResilienceEndTime[iClient] = -1.0;
	g_fZoeyResilienceDamageReduction[iClient] = 0.0;
	g_iZoeyQueuedReviveResumeTarget[iClient] = -1;
	g_fZoeyQueuedReviveResumeDuration[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeProgress[iClient] = 0.0;
	g_fZoeyQueuedReviveResumeAllowedUntil[iClient] = -1.0;
	g_bZoeyExplosiveAmmoActive[iClient] = false;
	g_fZoeyExplosiveAmmoCooldownEndTime[iClient] = -1.0;
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

void TrackZoeySharingIsCaringBoostUse(int iClient)
{
	if (IsZoeySharingIsCaringActive(iClient) == false)
		return;

	int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (RunEntityChecks(iActiveWeaponID) == false ||
		iActiveWeaponID != GetPlayerWeaponSlot(iClient, 4))
		return;

	char strWeaponClass[32];
	GetEntityClassname(iActiveWeaponID, strWeaponClass, sizeof(strWeaponClass));
	if (StrEqual(strWeaponClass, "weapon_pain_pills", false) == false &&
		StrEqual(strWeaponClass, "weapon_adrenaline", false) == false)
		return;

	g_iZoeySharingTrackedTempHealth[iClient] = GetSurvivorTempHealth(iClient);
}

int ConsumeZoeySharingIsCaringTrackedBoostHealAmount(int iClient)
{
	int iTrackedTempHealth = g_iZoeySharingTrackedTempHealth[iClient];
	g_iZoeySharingTrackedTempHealth[iClient] = -1;

	if (IsZoeySharingIsCaringActive(iClient) == false ||
		iTrackedTempHealth < 0)
		return 0;

	int iCurrentTempHealth = GetSurvivorTempHealth(iClient);
	if (iCurrentTempHealth <= iTrackedTempHealth)
		return 0;

	return iCurrentTempHealth - iTrackedTempHealth;
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
			IsIncap(iTeammate) == true)
			continue;

		float xyzTeammateOrigin[3];
		GetClientAbsOrigin(iTeammate, xyzTeammateOrigin);
		if (GetVectorDistance(xyzZoeyOrigin, xyzTeammateOrigin) > fRadius)
			continue;

		ApplyZoeySharingIsCaringPermanentHeal(iTeammate, iSharedHealAmount);
	}
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
		g_bIsClientDown[iClient] == true ||
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
		if (g_bIsClientDown[iClient] == true ||
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

void OnGameFrame_Zoey(int iClient)
{
	if (iClient < 0 ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		(g_iZoeyTalent1Level[iClient] <= 0 && g_iZoeyTalent2Level[iClient] <= 0 && g_iZoeyTalent3Level[iClient] <= 0))
		return;

	if (g_iZoeyTalent1Level[iClient] > 0 || g_iZoeyTalent3Level[iClient] > 0)
		HandleZoeyHealingItemMoveSpeed(iClient);

	if (g_iZoeyTalent1Level[iClient] > 0)
	{
		HandleZoeyFastRevive(iClient);
	}

	if (g_iZoeyTalent2Level[iClient] > 0)
		HandleZoeyTriggerHappyState(iClient);

	if (g_iZoeyTalent3Level[iClient] > 0)
		HandleZoeySurvivorsWillState(iClient);
}

bool OnPlayerRunCmd_Zoey(int iClient, int &iButtons)
{
	if (iClient < 0)
		return false;

	bool bButtonsChanged = false;

	if (g_iZoeyTalent4Level[iClient] > 0 &&
		(iButtons & IN_ATTACK) != 0)
	{
		TrackZoeySharingIsCaringBoostUse(iClient);
	}

	if (g_iZoeyTalent1Level[iClient] > 0)
		HandleZoeyProtectedReviveResume(iClient, iButtons);

	if (g_iZoeyTalent2Level[iClient] > 0 || g_iZoeyTalent3Level[iClient] > 0)
		bButtonsChanged = HandleZoeyWalkUseInput(iClient, iButtons) || bButtonsChanged;

	if (g_iZoeyTalent2Level[iClient] > 0)
		bButtonsChanged = HandleZoeyTriggerHappyInput(iClient, iButtons) || bButtonsChanged;

	return bButtonsChanged;
}

void OGFSurvivorReload_Zoey(int iClient, const char[] strCurrentWeapon, int iActiveWeaponID, int iCurrentClipAmmo, int iOffset_Ammo)
{
	if (iClient < 0 || iActiveWeaponID < -1 || iCurrentClipAmmo < 0 || iOffset_Ammo < 0 || strCurrentWeapon[0] == '\0')
		return;

	if (g_iZoeyTalent2Level[iClient] > 0 &&
		StrEqual(strCurrentWeapon, "weapon_pistol", false) == true &&
		RunEntityChecks(iActiveWeaponID) == true &&
		iCurrentClipAmmo > 0 &&
		iCurrentClipAmmo < ZOEY_TRIGGER_HAPPY_CLIP_SIZE)
	{
		SetEntData(iActiveWeaponID, g_iOffset_Clip1, ZOEY_TRIGGER_HAPPY_CLIP_SIZE, true);
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
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

bool IsZoeyTriggerHappyWeaponClass(const char[] strWeaponClass)
{
	return StrEqual(strWeaponClass, "weapon_pistol", false);
}

bool IsZoeyTriggerHappyEventWeapon(const char[] strWeaponClass)
{
	return StrEqual(strWeaponClass, "pistol", false) ||
		StrEqual(strWeaponClass, "dual_pistols", false);
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
		ActivateZoeyExplosiveAmmo(iClient);
		iButtons &= ~IN_RELOAD;
		bButtonsChanged = true;
	}

	return bButtonsChanged;
}

void ActivateZoeyExplosiveAmmo(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		g_bIsClientDown[iClient] == true ||
		IsClientGrappled(iClient) == true)
		return;

	if (IsZoeyHoldingMachinePistols(iClient) == false)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Trigger Happy requires dual pistols equipped.");
		return;
	}

	if (g_bZoeyExplosiveAmmoActive[iClient] == true)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Explosive machine-pistol ammo is already active.");
		return;
	}

	float fCooldownRemaining = g_fZoeyExplosiveAmmoCooldownEndTime[iClient] - GetGameTime();
	if (fCooldownRemaining > 0.0)
	{
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Explosive ammo cooling down: %0.0f seconds", fCooldownRemaining);
		return;
	}

	int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (RunEntityChecks(iActiveWeaponID) == false)
		return;

	SetEntData(iActiveWeaponID, g_iOffset_Clip1, ZOEY_TRIGGER_HAPPY_CLIP_SIZE, true);
	g_bZoeyExplosiveAmmoActive[iClient] = true;

	if (IsFakeClient(iClient) == false)
		PrintHintText(iClient, "Explosive ammo loaded.\nCooldown begins after this clip runs dry.");
}

void DeactivateZoeyExplosiveAmmo(int iClient, bool bStartCooldown)
{
	if (g_bZoeyExplosiveAmmoActive[iClient] == false && bStartCooldown == false)
		return;

	g_bZoeyExplosiveAmmoActive[iClient] = false;

	if (bStartCooldown)
	{
		g_fZoeyExplosiveAmmoCooldownEndTime[iClient] = GetGameTime() + ZOEY_TRIGGER_HAPPY_EXPLOSIVE_AMMO_COOLDOWN;
		if (IsFakeClient(iClient) == false)
			PrintHintText(iClient, "Explosive ammo spent.\n30 second cooldown started.");
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

	char strCurrentWeapon[32];
	GetClientWeapon(iAttacker, strCurrentWeapon, sizeof(strCurrentWeapon));
	if (IsZoeyTriggerHappyWeaponClass(strCurrentWeapon) == false)
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
