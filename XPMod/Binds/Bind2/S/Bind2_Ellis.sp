void Bind2Press_Ellis(iClient)
{
    if(g_iFireLevel[iClient]>0)	//Ellis's actionkey 2
    {
        if(g_iClientBindUses_2[iClient]<3)
        {
            if(g_bUsingFireStorm[iClient] == false)
            {
                new Float:vec[3];
                GetClientAbsOrigin(iClient, vec);
                vec[2] += 10;
                EmitAmbientSound(SOUND_IGNITE, vec, iClient, SNDLEVEL_NORMAL);
                EmitSoundToAll(SOUND_ONFIRE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
                g_bUsingFireStorm[iClient] = true;
                new Float:time = (float(g_iFireLevel[iClient]) * 3.0);
                switch(g_iClientBindUses_2[iClient])
                {
                    case 0:
                        DeleteParticleEntity(g_iPID_EllisCharge3[iClient]);
                    case 1:
                        DeleteParticleEntity(g_iPID_EllisCharge2[iClient]);
                    case 2:
                        DeleteParticleEntity(g_iPID_EllisCharge1[iClient]);
                }
                //ForcePrecache("ellis_ulti_firestorm");
                g_iPID_EllisFireStorm[iClient] = WriteParticle(iClient, "ellis_ulti_firewalk",0.0, time);
                IgniteEntity(iClient, time, false);		//simply for the firefx on the survivor
                SetEntProp(iClient, Prop_Send, "m_iGlowType", 2);
                SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
                SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 255);
                ChangeEdictState(iClient, 12);
                CreateTimer(time, TimerStopFireStorm, iClient, TIMER_FLAG_NO_MAPCHANGE);
                SetEntityRenderMode(iClient, RenderMode:3);
                //SetEntityRenderColor(iClient, 255, 99, 18, 255);
                SetEntityRenderColor(iClient, 210, 88, 30, 255);
                PrintHintText(iClient, "You have pleased the fire god Kagu-Tsuchi and are granted the gift of fire for%3.0f seconds.", time);
                g_iClientBindUses_2[iClient]++;
            }
        }
        else
            PrintHintText(iClient, "Kagu-Tsuchi grows tired of you for now, don't piss him off!");
    }
}