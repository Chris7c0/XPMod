ToggleGamePaused(iClient)
{
	if (g_bGamePaused == false)
		PauseGame(iClient);
	else
		UnpauseGame(iClient);
}

PauseGame(int iClient)
{
	g_bGamePaused = true;
	SetConVarInt(FindConVar("sv_pausable"), 1);
	FakeClientCommand(iClient, "setpause");
	SetConVarInt(FindConVar("sv_pausable"), 0);
}

UnpauseGame(int iClient)
{
	g_bGamePaused = false;
	SetConVarInt(FindConVar("sv_pausable"), 1);
	FakeClientCommand(iClient, "unpause");
	SetConVarInt(FindConVar("sv_pausable"), 0);
}

Action TimerPauseGame(Handle:timer, any:iClient)
{
    PauseGame(iClient);
    return Plugin_Stop;
}

HealClientFully(iClient)
{
	if (RunClientChecks(iClient) == false || IsPlayerAlive(iClient) == false)
		return;

	RunCheatCommand(iClient, "give", "give health");
	ResetTempHealthToSurvivor(iClient);

	g_bIsClientDown[iClient] = false;
	
	// new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	// SetEntProp(iClient, Prop_Data, "m_iHealth", iMaxHealth);
}

HealAllSurvivorsFully()
{
	for(new i=1;i <= MaxClients;i++)
	{
		if (RunClientChecks(i) && 
			IsPlayerAlive(i) && 
			g_iClientTeam[i] == TEAM_SURVIVORS)
		{
			HealClientFully(i);
		}
	}
}

void MutePlayer(int iClient, bool bMute, bool bSilent = true)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
	{
		g_bIsPlayerMuted[iClient] = false;
		return;
	}

	g_bIsPlayerMuted[iClient] = bMute;
	BaseComm_SetClientMute(iClient, bMute);

	if (bSilent == false)
		PrintToChatAll("\x03[XPMod] \x04%N has been %s.", 
			iClient,
			bMute ? "muted" : "unmuted");
}

int FindAndResurrectSurvivor(iClient)
{
	int iTarget = FindDeadSurvivor();

	return ResurrectPlayer(iTarget, iClient);
}

int FindDeadSurvivor()
{
	// Check for valid player first (look for human player)
	for(new i = 1; i <= MaxClients; i++)
	{
		if (RunClientChecks(i) &&
			g_iClientTeam[i] == TEAM_SURVIVORS &&
			IsFakeClient(i) == false &&
			IsPlayerAlive(i) == false)
			return i;
	}

	// Check for valid player first (look for bot player)
	for(new i = 1; i <= MaxClients; i++)
	{
		if (RunClientChecks(i) &&
			g_iClientTeam[i] == TEAM_SURVIVORS &&
			IsPlayerAlive(i) == false)
			return i;
	}

	return -1;
}

int ResurrectPlayer(int iTarget, int iClient)
{
	if (RunClientChecks(iTarget) == false || RunClientChecks(iClient) == false)
		return -1;

	decl Float:xyzLocation[3];
	GetClientAbsOrigin(iClient, xyzLocation);

	SDKCall(g_hSDK_RoundRespawn, iTarget);
	TeleportEntity(iTarget, xyzLocation, NULL_VECTOR, NULL_VECTOR);
	PrintToChatAll("\x03[XPMod] \x04%N have been resurrected by %N", iTarget, iClient);
	g_bIsClientDown[iTarget] = false;

	GiveBasicLoadout(iTarget);

	GetClientAbsOrigin(iTarget, xyzLocation);
	EmitSoundToAll(SOUND_NICK_RESURRECT, iTarget, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzLocation, NULL_VECTOR, true, 0.0);

	WriteParticle(iTarget, "nick_ulti_resurrect_base", 0.0, 25.0);
	WriteParticle(iTarget, "nick_ulti_resurrect_mind", 0.0, 25.0);
	WriteParticle(iTarget, "nick_ulti_resurrect_body", 0.0, 25.0);
	WriteParticle(iTarget, "nick_ulti_resurrect_soul", 0.0, 25.0);
	WriteParticle(iTarget, "nick_ulti_resurrect_trail", 0.0, 25.0);

	SetEntProp(iTarget, Prop_Data,"m_iHealth", 50);

	return iTarget;
}

GiveBasicLoadout(iClient)
{
	RunCheatCommand(iClient, "give", "give rifle_ak47");
	RunCheatCommand(iClient, "give", "give machete");
	RunCheatCommand(iClient, "give", "give molotov");
	RunCheatCommand(iClient, "give", "give first_aid_kit");
	RunCheatCommand(iClient, "give", "give pain_pills");
}