void Bind2Press_Hunter(iClient)
{
    if((g_iClientInfectedClass1[iClient] == HUNTER) || (g_iClientInfectedClass2[iClient] == HUNTER) || (g_iClientInfectedClass3[iClient] == HUNTER))
    {
        if(g_iKillmeleonLevel[iClient] > 0)
        {
            if(g_iClientBindUses_2[iClient] < 3)
            {
                if(g_bIsHunterReadyToPoison[iClient] == false)
                {
                    if(g_bCanHunterPoisonVictim[iClient] == true)
                    {
                        g_bIsHunterReadyToPoison[iClient] = true;
                        g_bCanHunterPoisonVictim[iClient] = false;
                        PrintHintText(iClient, "The next victim you hit will be injected with your hunter venom");
                    }
                    else
                        PrintHintText(iClient, "Wait 5 seconds to regenerate your poison");
                }
                else
                    PrintToChat(iClient, "\x03[XPMod] \x05You already injected your claws with venom");
            }
            else
                PrintToChat(iClient, "\x03[XPMod] \x05You are out of venom");
        }
        else
            PrintToChat(iClient, "\x03[XPMod] \x05You must have a Kill-meleon for Bind 2");
    }
    else
        PrintToChat(iClient, "\x03[XPMod] \x05You dont have the Hunter as one of your classes");
}