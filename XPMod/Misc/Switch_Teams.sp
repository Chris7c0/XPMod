bool SwitchPlayerTeam(int iClient, int iTarget, int iTeam)
{
    bool bSuccess = false;

    switch(iTeam)
    {
        case TEAM_SURVIVORS: bSuccess = SwitchPlayerToSurvivors(iClient, iTarget);
        case TEAM_INFECTED: bSuccess = SwitchPlayerToInfected(iClient, iTarget);
        case TEAM_SPECTATORS: bSuccess = SwitchPlayerToSpectators(iClient, iTarget);
    }

    return bSuccess;
}

bool SwitchPlayerToSurvivors(int iClient, int iTarget)
{
    if (RunClientChecks(iClient) == false ||
        IsFakeClient(iClient) == true)
        return false;

    g_bClientSpectating[iTarget] = false;
    if(g_iClientTeam[iTarget] == TEAM_SURVIVORS)
    {
        PrintToChat(iClient, "\x03[XPMod] \x05%N is already on the \x04Survivor Team\x05.", iTarget);
        return false;
    }

    if(!IsTeamFull(TEAM_SURVIVORS))
    {
        // First we switch to spectators
        ChangeClientTeam(iClient, TEAM_SPECTATORS); 

        // Look for a survivor bot then take them over
        for (int i=1; i <= MaxClients; i++)
        {
            if (RunClientChecks(i) && 
                IsFakeClient(i) &&
                GetClientTeam(i) == TEAM_SURVIVORS)
            {
                // Found a valid Survivor bot, force survivor bot to spectator
                SDKCall(g_hSDK_SetHumanSpec, i, iTarget); 
                
                // Force player to take over survivor bot's place
                SDKCall(g_hSDK_TakeOverBot, iTarget, true);
                g_iClientTeam[iTarget] = TEAM_SURVIVORS;
                PrintToChatAll("\x03%N \x05moved to the \x04survivors", iTarget);
                return true;
            }
        }
    }
    else
    {
        PrintToChat(iClient, "\x03[XPMod] \x05The \x04Survivor Team \x05is full.");
    }

    return false;
}

bool SwitchPlayerToInfected(int iClient, int iTarget)
{
    if (RunClientChecks(iClient) == false ||
        IsFakeClient(iClient) == true)
        return false;

    g_bClientSpectating[iTarget] = false;
    if(g_iClientTeam[iTarget] == TEAM_INFECTED)
    {
        PrintToChat(iClient, "\x03[XPMod] \x05%N is already on the \x04Infected Team\x05.", iTarget);
        return false;
    }
    if (g_iGameMode == GAMEMODE_VERSUS || 
        g_iGameMode == GAMEMODE_VERSUS_SURVIVAL)
    {
        if(!IsTeamFull(TEAM_INFECTED))
        {
            ChangeClientTeam(iTarget, TEAM_INFECTED);
            g_iClientTeam[iTarget] = TEAM_INFECTED;
            PrintToChatAll("\x03%N \x05moved to the \x04infected", iTarget);
            return true;
        }
        else
        {
            PrintToChat(iClient, "\x03[XPMod] \x05The \x04Infected Team \x05is full.");
        }
    }
    else
    {
        PrintToChat(iClient, "\x03[XPMod] \x04You can only switch to infected in a Versus game");
    }

    return false;
}

bool SwitchPlayerToSpectators(int iClient, int iTarget)
{
    if (RunClientChecks(iClient) == false ||
        IsFakeClient(iClient) == true)
        return false;
    
    if(g_iClientTeam[iTarget] == TEAM_SPECTATORS)
    {
        g_bClientSpectating[iTarget] = true;
        PrintToChat(iClient, "\x03[XPMod] \x05%N is already a \x04spectator\x05.", iTarget);
        return false;
    }

    ChangeClientTeam(iTarget, TEAM_SPECTATORS);
    g_iClientTeam[iTarget] = TEAM_SPECTATORS;
    g_bClientSpectating[iTarget] = true;
    PrintToChatAll("\x03%N \x05moved to the \x04spectators", iTarget);

    return true;
}