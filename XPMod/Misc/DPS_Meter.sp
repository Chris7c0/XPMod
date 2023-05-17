AddDamageToDPSMeter(int iClient, int iDamage)
{
    if (g_iDPSTotalDamage[iClient] == 0)
        g_fDPSStartTime[iClient] = GetGameTime();

    g_fDPSTimeOfLastDamage[iClient] = GetGameTime();
    g_iDPSTotalDamage[iClient] += iDamage;

    PrintToChatAll("AddDamageToDPSMeter %i", iDamage);
}

Handle1SecondClientTimers_DPSMeter(int iClient)
{
    if (g_iDPSTotalDamage[iClient] == 0)
        return;
    
    float fCurrentGameTime = GetGameTime();

    PrintDPSMeter(iClient);

    // Check if still should be running
    if (fCurrentGameTime < g_fDPSTimeOfLastDamage[iClient] + DPS_METER_TIME_UNTIL_RESET)
        return;

    // Reset all the DPS Meter the values
    g_fDPSStartTime[iClient] == 0.0;
    g_fDPSTimeOfLastDamage[iClient] = 0.0;
    g_iDPSTotalDamage[iClient] = 0;
}

PrintDPSMeter(int iClient)
{
    if (RunClientChecks(iClient) == false ||
        IsFakeClient(iClient) == true)
        return;

    float fDamageTime = g_fDPSTimeOfLastDamage[iClient] - g_fDPSStartTime[iClient] > 0.1 ?
        g_fDPSTimeOfLastDamage[iClient] - g_fDPSStartTime[iClient] :
        0.1;
    
    PrintHintText(iClient, 
        "%i Dmg / %0.1f Secs\n \nDPS: %0.1f",
        g_iDPSTotalDamage[iClient],
        fDamageTime,
        g_iDPSTotalDamage[iClient] / fDamageTime);
}