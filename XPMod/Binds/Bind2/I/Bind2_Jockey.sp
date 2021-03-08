void Bind2Press_Jockey(iClient)
{
    if((g_iClientInfectedClass1[iClient] == JOCKEY) || (g_iClientInfectedClass2[iClient] == JOCKEY) || (g_iClientInfectedClass3[iClient] == JOCKEY))
    {
        if(g_iUnfairLevel[iClient] > 0)
        {
            if(g_iJockeyVictim[iClient] > 0)
            {
                if(g_iClientBindUses_2[iClient] < 3)
                {
                    if(g_bCanJockeyCloak[iClient] == true)
                    {
                        g_bCanJockeyCloak[iClient] = false;
                        g_bCanJockeyJump[iClient] = true;
                        
                        CreateTimer(10.0, TimerRemoveJockeyCloak, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
                        CreateTimer(10.0, TimerRemoveJockeyCloak, iClient, TIMER_FLAG_NO_MAPCHANGE);

                        // Set the jockey ride speed
                        //SetEntDataFloat(g_iJockeyVictim[iClient] , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), ( 1.0 - (g_iStrongLevel[g_iJockeyVictim[iClient]] * 0.2) + (g_iErraticLevel[iClient] * 0.03) + (g_iUnfairLevel[iClient] * 0.1) ), true);
                        if (g_iStrongLevel[g_iJockeyVictim[iClient]] == 0)
                        {
                            g_fJockeyRideSpeedVanishingActBoost[g_iJockeyVictim[iClient]] = (g_iUnfairLevel[iClient] * 0.05);
                            SetClientSpeed(g_iJockeyVictim[iClient]);
                            CreateTimer(10.0, TimerRemoveVanishingActSpeed, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
                        }
                            
                        
                        //Disable Glow for Victim
                        if(IsValidEntity(g_iJockeyVictim[iClient]))
                        {
                            SetEntityRenderMode(g_iJockeyVictim[iClient], RenderMode:3);
                            SetEntityRenderColor(g_iJockeyVictim[iClient], 255, 255, 255, RoundToFloor(255 * (1.0 -  (float(g_iUnfairLevel[iClient]) * 0.09))) );
                            SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_iGlowType", 3);
                            SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_nGlowRange", 0);
                            SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_glowColorOverride", 1);
                        }
                        
                        //Disable Glow for Jockey Attacker
                        if(IsValidEntity(iClient))
                        {
                            SetEntityRenderMode(iClient, RenderMode:3);
                            SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 -  (float(g_iUnfairLevel[iClient]) * 0.09))) );
                            SetEntProp(iClient, Prop_Send, "m_iGlowType", 3);
                            SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
                            SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 1);
                        }
                        
                        g_iClientBindUses_2[iClient]++;
                    }
                    else
                        PrintHintText(iClient, "Wait 30 seconds to cloak again");
                }
                else
                    PrintHintText(iClient, "Your out Bind 2 charges");
            }
            else
                PrintHintText(iClient, "You must be riding a victim to cloak");
        }
        else
            PrintHintText(iClient, "You must have Unfair Advantage (Level 1) for Jockey Bind 2");
    }
    else
        PrintHintText(iClient, "You dont have the Jockey as one of your classes");
}