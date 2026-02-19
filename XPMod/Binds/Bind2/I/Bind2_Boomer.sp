void Bind2Press_Boomer(int iClient)
{
    if((g_iClientInfectedClass1[iClient] == BOOMER) || (g_iClientInfectedClass2[iClient] == BOOMER) || (g_iClientInfectedClass3[iClient] == BOOMER))
    {
        if(g_iNorovirusLevel[iClient] > 0)
        {
            if(g_iClientBindUses_2[iClient] < 3)
            {
                if(g_bIsSuicideBoomer[iClient] == false && g_bIsSuicideJumping[iClient] == false)
                {
                    g_bIsSuicideBoomer[iClient] = true;
                    PrintHintText(iClient, "You have inhaled %d Atomic Burritos! Jump to release.", g_iNorovirusLevel[iClient]);
                }
            }
            else
                PrintToChat(iClient, "\x03[XPMod] \x05You are out of Atomic Burritos");
        }
        else
            PrintToChat(iClient, "\x03[XPMod] \x05You must have a Noro-Virus for Bind 2");
    }
    else
        PrintToChat(iClient, "\x03[XPMod] \x05You dont have the Boomer as one of your classes");
}
