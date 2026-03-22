void TalentsLoad_Zoey(int iClient)
{
	SetPlayerTalentMaxHealth_Zoey(iClient, !g_bConfirmedSurvivorTalentsGivenThisRound[iClient]);
	SetClientSpeed(iClient);

	if ((g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Rapid Combat Medic Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilties will be automatically set as you level.");
}

void ResetZoeyTalentsRuntimeState(int iClient)
{
	SetClientSpeed(iClient);
}

void SetPlayerTalentMaxHealth_Zoey(int iClient, bool bFillInHealthGap = true)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != ZOEY ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;

	SetPlayerMaxHealth(iClient, 100 + (g_iCoachTeamHealthStack * 5), false, bFillInHealthGap);
}

void OnGameFrame_Zoey(int iClient)
{
	if (iClient < 0)
		return;
}

bool OnPlayerRunCmd_Zoey(int iClient, int &iButtons)
{
	if (iClient < 0 && iButtons < 0)
		return true;

	return false;
}

void OGFSurvivorReload_Zoey(int iClient, const char[] strCurrentWeapon, int iActiveWeaponID, int iCurrentClipAmmo, int iOffset_Ammo)
{
	if (iClient < 0 || iActiveWeaponID < -1 || iCurrentClipAmmo < 0 || iOffset_Ammo < 0 || strCurrentWeapon[0] == '\0')
		return;
}
