void Bind2Press_Bill(int iClient)
{
    if(g_iPromotionalLevel[iClient]>0)
    {
        if(g_iClientBindUses_2[iClient]<3)
        {
            RunCheatCommand(iClient, "give", "give rifle_m60");
            RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");
            g_iClientBindUses_2[iClient]++;
        }
        else 
            PrintHintText(iClient, "You are out of M60 machine guns.");
    }
}
