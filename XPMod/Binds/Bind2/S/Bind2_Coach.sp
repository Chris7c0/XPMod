void Bind2Press_Coach(iClient)
{
    if(g_iStrongLevel[iClient]>0)	//Coaches's actionkey 2
    {
        if(g_bIsJetpackOn[iClient] == false && g_iClientJetpackFuelUsed[iClient]>0)
        {
            new Float:vec[3];
            GetClientAbsOrigin(iClient, vec);
            StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
            EmitSoundToAll(SOUND_JPSTART, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
            CreateTimer(3.0, TimerStartJetPack, iClient, TIMER_FLAG_NO_MAPCHANGE);
            //SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
        }
        else
        {
            StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
            new Float:vec[3];
            GetClientAbsOrigin(iClient, vec);
            EmitSoundToAll(SOUND_JPDIE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
            g_bIsJetpackOn[iClient] = false;
            if(clienthanging[iClient]==false)
                SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
            if(g_iClientJetpackFuelUsed[iClient]<1)
                PrintHintText(iClient, "Out Of Fuel");
        }
    }
    else
        PrintHintText(iClient, "You posses no talent for Bind 2");
}