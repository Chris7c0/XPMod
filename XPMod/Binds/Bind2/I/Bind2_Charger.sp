void Bind2Press_Charger(iClient)
{
    if((g_iClientInfectedClass1[iClient] == CHARGER) || (g_iClientInfectedClass2[iClient] == CHARGER) || (g_iClientInfectedClass3[iClient] == CHARGER))
    {
        if(g_iHillbillyLevel[iClient] > 0)
        {
            if(g_iClientBindUses_2[iClient] < 3)
            {
                if(g_bCanChargerEarthquake[iClient] == true)
                {
                    g_bIsHillbillyEarthquakeReady[iClient] = true;
                    PrintHintText(iClient, "Punch an object to trigger an earthquake!");
                }
                else
                    PrintHintText(iClient, "You must wait for the 30 second cooldown on Earthquake before reuse");
            }
            else
                PrintToChat(iClient, "\x03[XPMod] \x05You are out of Bind 2 uses");
        }
        else
            PrintToChat(iClient, "\x03[XPMod] \x05You must have a Hillbilly Madness for Charger Bind 2");
    }
    else
        PrintToChat(iClient, "\x03[XPMod] \x05You dont have the Charger as one of your classes");
}