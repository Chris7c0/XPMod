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