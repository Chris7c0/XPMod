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

	new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");

	SetEntProp(iClient, Prop_Data, "m_iHealth", iMaxHealth);
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

MutePlayer(iClient)
{
	BaseComm_SetClientMute(iClient, true);
}