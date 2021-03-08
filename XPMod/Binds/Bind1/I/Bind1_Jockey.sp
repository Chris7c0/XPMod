void Bind1Press_Jockey(iClient)
{
    if((g_iClientInfectedClass1[iClient] == JOCKEY) || (g_iClientInfectedClass2[iClient] == JOCKEY) || (g_iClientInfectedClass3[iClient] == JOCKEY))
    {
        if(g_iErraticLevel[iClient] > 0)
        {
            if(g_iJockeyVictim[iClient] > 0)
            {
                if(g_iClientBindUses_1[iClient] < 3)
                {
                    if(g_bCanJockeyPee[iClient] == true)
                    {
                        if(IsValidEntity(g_iJockeyVictim[iClient]) == true)
                            if(IsClientInGame(g_iJockeyVictim[iClient]) == true)
                            {
                                g_bCanJockeyPee[iClient] = false;
                                
                                GiveClientXP(iClient, 25, g_iSprite_25XP_SI, g_iJockeyVictim[iClient], "Pissed on survivor.");
                                
                                new iRandomTankSpawn = GetRandomInt(1, 100);
                                switch (iRandomTankSpawn)
                                {
                                    case 1, 2, 3, 4, 5, 6, 7, 8 , 9, 10:
                                    {
                                        if(g_iErraticLevel[iClient] >= iRandomTankSpawn)
                                        {
                                            g_bTankStartingHealthXPModSpawn = true;
                                            RunCheatCommand(iClient, "z_spawn_old", "z_spawn_old tank auto");

                                            PrintToChatAll("\x03[XPMod] \x04Beware, a tank smells %N's jockey piss", iClient);
                                            PrintHintText(iClient, "You attracted a tank with your piss!");
                                        }
                                    }
                                }
                                
                                decl Float:vec[3];
                                GetClientEyePosition(iClient, vec);
                                EmitSoundToAll(SOUND_JOCKEYPEE, g_iJockeyVictim[iClient], SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
                                EmitSoundToAll(SOUND_JOCKEYPEE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
                                
                                SDKCall(g_hSDK_VomitOnPlayer, g_iJockeyVictim[iClient], iClient, true);
                                CreateTimer(11.0, TimerStopJockeyPee, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
                                CreateTimer(11.0, TimerStopJockeyPeeSound, iClient, TIMER_FLAG_NO_MAPCHANGE);
                                CreateTimer(11.0, TimerStopJockeyPeeSound, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
                                CreateTimer(30.0, TimerEnableJockeyPee, iClient, TIMER_FLAG_NO_MAPCHANGE);
                                CreateTimer(20.0, TimerRemovePeeFX, g_iJockeyVictim[iClient], TIMER_FLAG_NO_MAPCHANGE);
                                
                                if(g_bCanJockeyCloak[iClient] == true)
                                {
                                    SetEntityRenderMode(g_iJockeyVictim[iClient], RenderMode:3);
                                    SetEntityRenderColor(g_iJockeyVictim[iClient], 200, 255, 0, 255);
                                    SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_iGlowType", 2);
                                    SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_nGlowRange", 0);
                                    SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_glowColorOverride", 10900);	//Yellow-Orange
                                }
                                else 
                                {
                                    SetEntityRenderMode(g_iJockeyVictim[iClient], RenderMode:3);
                                    SetEntityRenderColor(g_iJockeyVictim[iClient], 255, 255, 255, RoundToFloor(255 * (1.0 -  (float(g_iUnfairLevel[iClient]) * 0.09))) );
                                    SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_iGlowType", 3);
                                    SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_nGlowRange", 0);
                                    SetEntProp(g_iJockeyVictim[iClient], Prop_Send, "m_glowColorOverride", 1);
                                }
                                
                                if(IsFakeClient(g_iJockeyVictim[iClient]) == false)
                                {
                                    PrintHintText(g_iJockeyVictim[iClient], "%N is pissing on you!", iClient);
                                    ShowHudOverlayColor(g_iJockeyVictim[iClient], 255, 255, 0, 65, 2900, FADE_OUT);
                                }
                                
                                if(g_iErraticLevel[iClient] == 10)
                                {
                                    RunCheatCommand(iClient, "z_spawn_old", "z_spawn_old mob auto");
                                    
                                    PrintHintText(iClient, "A hoard smells your piss, here they come!");
                                }
                                
                                g_iClientBindUses_1[iClient]++;
                            }
                    }
                    else
                        PrintHintText(iClient, "Wait 30 seconds to piss again");
                }
                else
                    PrintHintText(iClient, "Your out of piss");
            }
            else
                PrintHintText(iClient, "You must be riding a victim to piss on them");
        }
        else
            PrintHintText(iClient, "You must have Erratic Domination (Level 1) for Jockey Bind 1");
    }
    else
        PrintHintText(iClient, "You dont have the Jockey as one of your classes");
}