DebugLog(int iDebugLevel, const char[] strMessage, any ...)
{
    if (g_iDebugMode == DEBUG_MODE_EVERYTHING ||
        (iDebugLevel != DEBUG_MODE_TESTING && g_iDebugMode >= iDebugLevel) ||
        (g_iDebugMode == DEBUG_MODE_TESTING && iDebugLevel == DEBUG_MODE_TESTING))
    {
        char strFormattedMessage[512];
        VFormat(strFormattedMessage, sizeof(strFormattedMessage), strMessage, 3);
        LogMessage(strFormattedMessage);
    }
}