void Bind2Press_Coach(iClient)
{
    if(g_iStrongLevel[iClient] > 0)	//Coaches's actionkey 2
    {
        if(g_bIsJetpackOn[iClient] == false && g_iClientJetpackFuel[iClient] > 0)
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

void PrintCoachJetpackFuelGauge(iClient)
{
    if (RunClientChecks(iClient) == false || IsFakeClient(iClient))
		return;
    
    // Print fuel level only if not doing wrecking ball charge
    if(g_iWreckingBallChargeCounter[iClient] != 0)
        return;
    
    decl String:strEntireHintTextString[556], String:strFuelMeter[256];
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