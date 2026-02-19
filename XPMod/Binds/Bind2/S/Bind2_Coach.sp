void Bind2Press_Coach(int iClient)
{
    if(g_iStrongLevel[iClient] > 0)	//Coaches's actionkey 2
    {
        if(g_bIsJetpackOn[iClient] == false && g_iClientJetpackFuel[iClient] > 0)
        {
            float vec[3];
            GetClientAbsOrigin(iClient, vec);
            StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
            EmitSoundToAll(SOUND_JPSTART, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
            CreateTimer(3.0, TimerStartJetPack, iClient, TIMER_FLAG_NO_MAPCHANGE);
            //SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
        }
        else
        {
            StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
            float vec[3];
            GetClientAbsOrigin(iClient, vec);
            EmitSoundToAll(SOUND_JPDIE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
            g_bIsJetpackOn[iClient] = false;
            PrintCoachJetpackFuelGauge(iClient)
            
            if(clienthanging[iClient]==false)
                SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
            if(g_iClientJetpackFuel[iClient] <= 0)
                PrintHintText(iClient, "Out Of Fuel");
        }
    }
    else
        PrintHintText(iClient, "You posses no talent for Bind 2");
}

void PrintCoachJetpackFuelGauge(int iClient)
{
    if (RunClientChecks(iClient) == false || IsFakeClient(iClient))
		return;
    
    // Print fuel level only if not doing wrecking ball charge
    if(g_iWreckingBallChargeCounter[iClient] != 0)
        return;
    
    char strEntireHintTextString[556], strFuelMeter[256];
    strEntireHintTextString = NULL_STRING;
    strFuelMeter = NULL_STRING;

    // Create the actual fuel amount in the "progress meter"
    for(int i = 0; i < RoundToCeil(g_iClientJetpackFuel[iClient] / 10.0); i++)
        StrCat(strFuelMeter, sizeof(strFuelMeter), "▓")
    // Create the rest of the string to fill in the progress meter
    for(int i = RoundToCeil(((g_iStrongLevel[iClient] * COACH_JETPACK_FUEL_PER_LEVEL) - 1) / 10.0); i > RoundToCeil(g_iClientJetpackFuel[iClient] / 10.0); i--)
        StrCat(strFuelMeter, sizeof(strFuelMeter), "░")

    Format(strEntireHintTextString, sizeof(strEntireHintTextString), "CEDA JPack Mk. 6%s\n|%s|", g_bIsJetpackOn[iClient] ? " [Active Flight Mode]": " [Regenerative Mode]", strFuelMeter);
    PrintHintText(iClient, strEntireHintTextString);
}

void HandleCoachJetPack2SecondTick(int iClient)
{
    if (g_iStrongLevel[iClient] == 0)
        return;

    if(g_bIsJetpackOn[iClient] == true)
    {
        // Take away small amount of fuel for running jetpack on idle
        g_iClientJetpackFuel[iClient]--;

        PrintCoachJetpackFuelGauge(iClient);

        if(g_iClientJetpackFuel[iClient]<0)
        {
            CreateTimer(0.5, DeleteParticle, g_iPID_CoachJetpackStream[iClient], TIMER_FLAG_NO_MAPCHANGE);
            StopSound(iClient, SNDCHAN_AUTO, SOUND_JPHIGHREV);
            StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
            float vec[3];
            GetClientAbsOrigin(iClient, vec);
            EmitSoundToAll(SOUND_JPDIE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
            
            g_bIsJetpackOn[iClient] = false;
            g_bIsFlyingWithJetpack[iClient] = false;
            SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
            g_iClientJetpackFuel[iClient] = 0;
            PrintCoachJetpackFuelGauge(iClient);
        }
    }
    else if (g_iClientJetpackFuel[iClient] < (g_iStrongLevel[iClient] * COACH_JETPACK_FUEL_PER_LEVEL))
    {
        // Jetpack fuel regeneration while jetpack is off
        g_iClientJetpackFuel[iClient] = g_iClientJetpackFuel[iClient] + COACH_JETPACK_FUEL_REGEN_PER_2_SEC_TICK > (g_iStrongLevel[iClient] * COACH_JETPACK_FUEL_PER_LEVEL) ? 
            (g_iStrongLevel[iClient] * COACH_JETPACK_FUEL_PER_LEVEL) :
            g_iClientJetpackFuel[iClient] + COACH_JETPACK_FUEL_REGEN_PER_2_SEC_TICK;
        
        PrintCoachJetpackFuelGauge(iClient);
    }
}
