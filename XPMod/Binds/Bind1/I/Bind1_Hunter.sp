void Bind1Press_Hunter(iClient)
{
    if((g_iClientInfectedClass1[iClient] == HUNTER) || (g_iClientInfectedClass2[iClient] == HUNTER) || (g_iClientInfectedClass3[iClient] == HUNTER))
    {
        // PrintToChatAll("Hunter is a chosen class...");
        if(g_iBloodlustLevel[iClient] > 0)
        {
            // PrintToChatAll("Bloodlust is greater than 0...");
            if(g_iHunterShreddingVictim[iClient] > 0)
            {
                // PrintToChatAll("Hunter is shredding a victim...");
                if(g_bCanHunterDismount[iClient] == true)
                {
                    // PrintToChatAll("Hunter attempting dismount...");
                    SDKCall(g_hSDK_OnPounceEnd,iClient);
                    SetClientSpeed(g_iHunterShreddingVictim[iClient]);
                    //ResetSurvivorSpeed(g_iHunterShreddingVictim[iClient]);
                    g_iHunterShreddingVictim[iClient] = -1;
                    g_bCanHunterDismount[iClient] = false;
                    CreateTimer(15.0, TimerResetHunterDismount, iClient,  TIMER_FLAG_NO_MAPCHANGE);
                }
                else
                    PrintHintText(iClient, "Wait 15 seconds after dismounting");
            }
            else
                PrintHintText(iClient, "You are not mounted on a victim");
        }
        else
            PrintHintText(iClient, "You must have Blood Lust (Level 1) for Hunter Bind 1");
    }
    else
        PrintHintText(iClient, "You dont have the Hunter as one of your classes");
}