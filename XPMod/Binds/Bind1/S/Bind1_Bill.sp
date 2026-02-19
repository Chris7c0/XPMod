void Bind1Press_Bill(int iClient)
{
    if(g_iDiehardLevel[iClient] > 0)
    {
        if(g_bCanDropPoopBomb[iClient] == true)
        {
            if(g_iClientBindUses_1[iClient] < 3)
            {
                g_bCanDropPoopBomb[iClient] = false;
                CreateTimer(20.0, TimerChangeCanDropBombs, iClient, TIMER_FLAG_NO_MAPCHANGE);
                
                if(g_iDiehardLevel[iClient] < 3)
                    g_iDropBombsTimes[iClient] = 2;
                else if(g_iDiehardLevel[iClient] < 5)
                    g_iDropBombsTimes[iClient] = 1;
                else if(g_iDiehardLevel[iClient] == 5)
                    g_iDropBombsTimes[iClient] = 0;

                delete g_hTimer_BillDropBombs[iClient];
                g_hTimer_BillDropBombs[iClient] = CreateTimer(1.0, TimerDropBombs, iClient, TIMER_REPEAT);
                
                g_iClientBindUses_1[iClient]++;
                int uses = 3 - g_iClientBindUses_1[iClient];
                PrintHintText(iClient, "Sons of bitches gonna die! %d uses remain", uses);
            }
            else
            {
                PrintHintText(iClient, "You have run out of improvised explosive devices.");
            }
        }
        else
            PrintHintText(iClient, "Wait a few seconds for more improvised explosives.");
    }
}
