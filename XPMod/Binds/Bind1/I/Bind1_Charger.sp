void Bind1Press_Charger(iClient)
{
    if((g_iClientInfectedClass1[iClient] == CHARGER) || (g_iClientInfectedClass2[iClient] == CHARGER) || (g_iClientInfectedClass3[iClient] == CHARGER))
    {
        if(g_iSpikedLevel[iClient] > 0)
        {
            if(g_iClientBindUses_1[iClient] < 3)
            {
                if (g_bCanChargerSuperCharge[iClient] == true)
                {
                    if(g_bIsSuperCharger[iClient] == false)
                    {
                        g_bIsSuperCharger[iClient] = true;
                        g_bCanChargerSuperCharge[iClient] = false;
                        new iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
                        if (iEntid > 0)
                        {
                            float flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+8);
                            float flTimeStamp_calc = flTimeStamp_ret - 12.0;
                            SetEntDataFloat(iEntid, g_iOffset_NextActivation+8, flTimeStamp_calc, true);
                        }
                        PrintHintText(iClient, "Your next charge will be a super charge");
                    }
                    else
                        PrintHintText(iClient, "This is already active");
                }
                else
                    PrintHintText(iClient, "Wait 30 seconds to super charge again");
            }
            else
                PrintHintText(iClient, "You are out of Super Charges");
        }
        else
            PrintHintText(iClient, "You must have Spiked Carapace (Level 1) for Charger Bind 1");
    }
    else
        PrintHintText(iClient, "You dont have the Charger as one of your classes");
}