void Bind2Press_Nick(iClient)
{
    if(g_iDesperateLevel[iClient]>0)	//Nick's actionkey 2
    {
        if(g_iClientBindUses_2[iClient]<3)
        {
            JebusHandBindMenuDraw(iClient);
        }
        else
            PrintHintText(iClient, "You are too tired to use any more of your medical expertise for now.");
    }
}