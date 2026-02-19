void Bind1Press_Boomer(int iClient)
{
    if((g_iClientInfectedClass1[iClient] == BOOMER) || (g_iClientInfectedClass2[iClient] == BOOMER) || (g_iClientInfectedClass3[iClient] == BOOMER))
    {
        if(g_iAcidicLevel[iClient] > 0)
        {
            if(g_iClientBindUses_1[iClient] < 3)
            {
                if(g_bIsServingHotMeal[iClient] == false)
                {
                    g_iClientBindUses_1[iClient]++;
                    PrintHintText(iClient, "Your serving up a hot meal. Don't forget to feed the hungry survivors!\nClick Rapidly!");
                    g_bIsServingHotMeal[iClient] = true;
                    g_bIsBoomerVomiting[iClient] = true;
                    
                    SetClientSpeed(iClient);

                    //Start Vomiting
                    int iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
                    if (iEntid > 0)
                    {
                        float flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+8);
                        float flTimeStamp_calc = flTimeStamp_ret - 29.5;
                        SetEntDataFloat(iEntid, g_iOffset_NextActivation+8, flTimeStamp_calc, true);
                    }
                    CreateTimer(1.0, TimerConstantVomit, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
                    CreateTimer(9.0, TimerStopHotMeal, iClient, TIMER_FLAG_NO_MAPCHANGE);
                }
                else
                    PrintHintText(iClient, "You are already serving up a hot meal!");
            }
            else
                    PrintHintText(iClient, "Your out of hot meals to serve.");
        }
        else
            PrintHintText(iClient, "You must have Acidic Brew (Level 1) for Boomer Bind 1");
    }
    else
        PrintHintText(iClient, "You dont have the Boomer as one of your classes");
}
