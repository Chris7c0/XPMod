void Bind2Press_Rochelle(iClient)
{
    if(g_iShadowLevel[iClient]>0)	//Rochelle's actionkey 2
    {
        if(g_iClientBindUses_2[iClient] < 3)
        {
            if(g_bUsingShadowNinja[iClient]==false && IsIncap(iClient) == false)
            {
                g_bUsingShadowNinja[iClient] = true;
                g_iClientBindUses_2[iClient]++;
                //PrintHintTextToAll("Rochelle disabled everyones glow for 12 seconds");
                //SetConVarInt(FindConVar("sv_disable_glow_survivors"), 1);
                SetEntProp(iClient, Prop_Send, "m_iGlowType", 3);
                SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
                SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 1);
                ChangeEdictState(iClient, 12);
                DeleteParticleEntity(g_iPID_RochelleCharge1[iClient]);
                DeleteParticleEntity(g_iPID_RochelleCharge2[iClient]);
                DeleteParticleEntity(g_iPID_RochelleCharge3[iClient]);
                float vec[3];
                GetClientAbsOrigin(iClient, vec);
                EmitSoundToAll(SOUND_NINJA_ACTIVATE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);

                RunCheatCommand(iClient, "give", "give katana");
                
                SetEntityRenderMode(iClient, RenderMode:3);
                SetEntityRenderColor(iClient, 0, 0, 0, RoundToFloor(255 * (1.0 - (float(g_iShadowLevel[iClient]) * 0.19))));

                SetClientSpeed(iClient);
                
                //CreateParticle("rochelle_weapon_trail", 12.0, iClient, ATTACH_BLUR);
                CreateTimer(12.0, TimerStopShadowNinja, iClient, TIMER_FLAG_NO_MAPCHANGE);
                
                //WriteParticle(iClient, "rochelle_smoke", 0.0, 10.0);
                
                CreateRochelleSmoke(iClient);
            }
        }
        else
            PrintHintText(iClient, "Not enough focus for a shadow ninja. You rack disciprine!");
    }
}