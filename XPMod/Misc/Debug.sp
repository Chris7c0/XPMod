void DebugLog(int iDebugLevel, const char[] strMessage, any ...)
{
    if (g_iDebugModeLogLevel == DEBUG_MODE_EVERYTHING ||
        (iDebugLevel != DEBUG_MODE_TESTING && g_iDebugModeLogLevel >= iDebugLevel) ||
        (g_iDebugModeLogLevel == DEBUG_MODE_TESTING && iDebugLevel == DEBUG_MODE_TESTING))
    {
        char strFormattedMessage[512];
        VFormat(strFormattedMessage, sizeof(strFormattedMessage), strMessage, 3);
        LogMessage("%s", strFormattedMessage);
    }
}

void ToggleDebugMode()
{
    SetDebugMode(!g_bDebugModeEnabled)
}

void SetDebugMode(bool bEnabled)
{
    g_bDebugModeEnabled = bEnabled;
    g_bStopCISpawning = bEnabled;
    g_bStopSISpawning = bEnabled;

    if (bEnabled)
        CreateTimer(1.0, Timer_ContinuallyKillAllCI, 0, TIMER_REPEAT);

    PrintToChatAll("\x05XPMod Debug Mode %s", bEnabled ? "ENABLED" : "DISABLED");
}
