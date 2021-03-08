void Bind2Press_Smoker(iClient)
{
    if((g_iClientInfectedClass1[iClient] == SMOKER) || (g_iClientInfectedClass2[iClient] == SMOKER) || (g_iClientInfectedClass3[iClient] == SMOKER))
    {
        if(g_iDirtyLevel[iClient] > 0)
        {
            if(g_iClientBindUses_2[iClient] < 3)
            {
                if(g_bElectricutionCooldown[iClient] == false)
                {
                    if(g_iChokingVictim[iClient] > 0 && IsClientInGame(g_iChokingVictim[iClient]) == true)
                    {
                        if(g_bIsElectricuting[iClient] == false)
                        {
                            g_bIsElectricuting[iClient] = true;
                            g_bElectricutionCooldown[iClient] = true;
                            CreateTimer(15.0, Timer_ResetElectricuteCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
                            
                            g_iClientBindUses_2[iClient]++;
                            
                            decl Float:clientloc[3],Float:targetloc[3];
                            GetClientEyePosition(iClient,clientloc);
                            GetClientEyePosition(g_iChokingVictim[iClient],targetloc);
                            clientloc[2] -= 10.0;
                            targetloc[2] -= 20.0;
                            new rand = GetRandomInt(1, 3);
                            decl String:zap[23];
                            switch(rand)
                            {
                                case 1: zap = SOUND_ZAP1; 
                                case 2: zap = SOUND_ZAP2;
                                case 3: zap = SOUND_ZAP3;
                            }
                            new pitch = GetRandomInt(95, 130);
                            EmitSoundToAll(zap, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, clientloc, NULL_VECTOR, true, 0.0);
                            EmitSoundToAll(zap, g_iChokingVictim[iClient], SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, targetloc, NULL_VECTOR, true, 0.0);
                            TE_SetupBeamPoints(clientloc,targetloc,g_iSprite_Laser,0,0,66,0.3, 0.5, 0.5,0,4.0,{0,40,255,200},0);
                            TE_SendToAll();
                            CreateParticle("electrical_arc_01_system", 1.5, g_iChokingVictim[iClient], ATTACH_EYES, true);

                            new alpha = GetRandomInt(80,140);										
                            ShowHudOverlayColor(iClient, 255, 255, 255, alpha, 150, FADE_OUT);
                            ShowHudOverlayColor(g_iChokingVictim[iClient], 255, 255, 255, alpha, 150, FADE_OUT);
                            
                            DealDamage(g_iChokingVictim[iClient], iClient, g_iDirtyLevel[iClient]);
                            
                            g_iClientXP[iClient] += 10;
                            CheckLevel(iClient);
                            
                            if(g_iXPDisplayMode[iClient] == 0)
                                ShowXPSprite(iClient, g_iSprite_10XP_SI, g_iChokingVictim[iClient], 1.0);
                            
                            decl i;
                            for(i = 1;i <= MaxClients;i++)
                            {
                                if(i == g_iChokingVictim[iClient])
                                    continue;
                                
                                if(g_iChokingVictim[iClient] < 1 || IsValidEntity(i) == false || IsValidEntity(g_iChokingVictim[iClient]) == false)
                                    continue;
                                
                                if(IsClientInGame(i) && g_iClientTeam[i] == TEAM_SURVIVORS)
                                {
                                    GetClientEyePosition(g_iChokingVictim[iClient], clientloc);
                                    GetClientEyePosition(i, targetloc);
                                    
                                    if(IsVisibleTo(clientloc, targetloc))
                                    {
                                        targetloc[2] -= 20.0;
                                        rand = GetRandomInt(1, 3);
                                        switch(rand)
                                        {
                                            case 1: zap = SOUND_ZAP1; 
                                            case 2: zap = SOUND_ZAP2;
                                            case 3: zap = SOUND_ZAP3;
                                        }
                                        pitch = GetRandomInt(95, 130);
                                        EmitSoundToAll(zap, i, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, targetloc, NULL_VECTOR, true, 0.0);
                                        TE_SetupBeamPoints(clientloc,targetloc,g_iSprite_Laser,0,0,66,0.3, 0.5, 0.5,0,4.0,{0,40,255,200},0);
                                        TE_SendToAll();
                                        CreateParticle("electrical_arc_01_system", 0.8, i, ATTACH_EYES, true);
                                        
                                        alpha = GetRandomInt(120, 180);					
                                        ShowHudOverlayColor(i, 255, 255, 255, alpha, 150, FADE_OUT);
                                        
                                        DealDamage(i , iClient, RoundToCeil((g_iDirtyLevel[iClient] * 0.5)));
                                        
                                        g_iClientXP[iClient] += 10;
                                        CheckLevel(iClient);
                                        
                                        if(g_iXPDisplayMode[iClient] == 0)
                                            ShowXPSprite(iClient, g_iSprite_10XP_SI, i, 1.0);
                                    }
                                }
                            }
                            
                            CreateTimer(0.5, TimerElectricuteAgain, iClient, TIMER_FLAG_NO_MAPCHANGE);
                            CreateTimer(2.9, TimerStopElectricution, iClient, TIMER_FLAG_NO_MAPCHANGE);
                        }
                        else
                            PrintHintText(iClient, "You are already electricuting a victim.");
                    }
                    else
                        PrintHintText(iClient, "You must be choking a victim to electricute them.");
                }
                else
                    PrintHintText(iClient, "You must wait for your electricity to charge back up again.");
            }
            else
                PrintHintText(iClient, "You are out of Bind 2 uses.");
        }
        else
            PrintHintText(iClient, "You must have Dirty Tricks (Level 1) for Smoker Bind 2");
    }
    else
        PrintHintText(iClient, "You dont have the Smoker as one of your classes");
}