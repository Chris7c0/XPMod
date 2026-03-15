void Bind2Press_Coach(int iClient)
{
    if(g_iStrongLevel[iClient] <= 0)
    {
        PrintHintText(iClient, "You possess no talent for Bind 2");
        return;
    }

    if(g_iClientBindUses_2[iClient] >= 3)
    {
        PrintHintText(iClient, "You are out of Chainsaw Massacres.");
        return;
    }

    if(g_bCoachChainsawMassacreActive[iClient] == true)
    {
        PrintHintText(iClient, "Chainsaw Massacre is already active!");
        return;
    }

    if(g_bCoachChainsawCooldown[iClient] == true)
    {
        PrintHintText(iClient, "Chainsaw Massacre is cooling down");
        return;
    }

    if(IsPlayerAlive(iClient) == false || g_bIsClientDown[iClient] == true || IsClientGrappled(iClient) == true)
        return;

    // Save the current secondary weapon (slot 1) before giving chainsaw
    int iSecondaryWeapon = GetPlayerWeaponSlot(iClient, 1);
    if(iSecondaryWeapon != -1 && IsValidEntity(iSecondaryWeapon))
    {
        char strWeaponClass[32];
        GetEntityClassname(iSecondaryWeapon, strWeaponClass, sizeof(strWeaponClass));

        if(StrEqual(strWeaponClass, "weapon_melee"))
        {
            // Save the specific melee type (baseball_bat, katana, etc.)
            GetEntPropString(iSecondaryWeapon, Prop_Data, "m_strMapSetScriptName", g_strCoachSavedMeleeWeapon[iClient], sizeof(g_strCoachSavedMeleeWeapon[]));
        }
        else if(StrEqual(strWeaponClass, "weapon_chainsaw"))
        {
            g_strCoachSavedMeleeWeapon[iClient] = "chainsaw";
        }
        else if(StrEqual(strWeaponClass, "weapon_pistol"))
        {
            g_strCoachSavedMeleeWeapon[iClient] = "pistol";
        }
        else if(StrEqual(strWeaponClass, "weapon_pistol_magnum"))
        {
            g_strCoachSavedMeleeWeapon[iClient] = "pistol_magnum";
        }
        else
        {
            g_strCoachSavedMeleeWeapon[iClient] = "";
        }
    }
    else
    {
        g_strCoachSavedMeleeWeapon[iClient] = "";
    }

    // Activate Chainsaw Massacre
    g_iClientBindUses_2[iClient]++;
    g_bCoachChainsawMassacreActive[iClient] = true;
    g_iCoachChainsawKillCount[iClient] = 0;
    g_iCoachChainsawMeleeDamage[iClient] = 0;

    // Give chainsaw
    RunCheatCommand(iClient, "give", "give chainsaw");

    // Start health regen timer
    CreateTimer(1.0, TimerCoachChainsawRegenTick, iClient, TIMER_FLAG_NO_MAPCHANGE);

    // End massacre after duration
    CreateTimer(COACH_CHAINSAW_DURATION, TimerCoachChainsawMassacreEnd, iClient, TIMER_FLAG_NO_MAPCHANGE);

    SetClientSpeed(iClient);

    PrintHintText(iClient, "CHAINSAW MASSACRE! You have %0.0f seconds!", COACH_CHAINSAW_DURATION);
    PrintToChat(iClient, "\x03[XPMod] \x04CHAINSAW MASSACRE! \x05Go on a killing spree for %0.0f seconds!", COACH_CHAINSAW_DURATION);
}
