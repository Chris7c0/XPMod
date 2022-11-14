void Bind1Press_Hunter(iClient)
{
    if((g_iClientInfectedClass1[iClient] == HUNTER) || (g_iClientInfectedClass2[iClient] == HUNTER) || (g_iClientInfectedClass3[iClient] == HUNTER))
    {
        // PrintToChatAll("Hunter is a chosen class...");
        if(g_iBloodLustLevel[iClient] > 0)
        {
            // PrintToChatAll("Bloodlust is greater than 0...");
            if(g_iHunterShreddingVictim[iClient] > 0)
            {
                // PrintToChatAll("Hunter is shredding a victim...");
                if(g_bCanHunterDismount[iClient] == true)
                {
                    HunterDismount(iClient);
                }
                else
                    PrintToChat(iClient, "\x03[XPMod] \x0415 second cooldown after dismounting.");
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