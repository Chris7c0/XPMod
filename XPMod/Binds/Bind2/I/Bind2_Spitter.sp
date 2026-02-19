void Bind2Press_Spitter(iClient)
{
    if((g_iClientInfectedClass1[iClient] == SPITTER) || (g_iClientInfectedClass2[iClient] == SPITTER) || (g_iClientInfectedClass3[iClient] == SPITTER))
    {
        if(g_iHallucinogenicLevel[iClient] > 0)
        {
            if(g_iClientBindUses_2[iClient] < 3)
            {
                if(g_bCanConjureWitch[iClient] == true)
                {									
                    if((GetEntityFlags(iClient) & FL_ONGROUND))
                    {
                        g_bCanConjureWitch[iClient] = false;
                        
                        float xyzAngles[3];
                        GetLocationVectorInfrontOfClient(iClient, g_xyzWitchConjureLocation[iClient], xyzAngles, 40.0, 30.0);
                        
                        WriteParticle(iClient, "spitter_conjure", 180.0, 7.0, g_xyzWitchConjureLocation[iClient]);
                        
                        PrintHintText(iClient, "Conjuring Witch...");
                        
                        CreateTimer(2.3, TimerConjureWitch, iClient, TIMER_FLAG_NO_MAPCHANGE);
                    }
                    else
                        PrintHintText(iClient, "You must be standing on the ground to conjure witches");
                }
                else
                    PrintHintText(iClient, "Wait 3 minutes after conjuring a witch");
            }
            else
                PrintHintText(iClient, "Your out of Bind 2 uses");
        }
        else
            PrintHintText(iClient, "You must have Hallucinogenic Nightmare (Level 1) for Spitter Bind 2");
    }
    else
        PrintHintText(iClient, "You dont have the Spitter as one of your classes");
}