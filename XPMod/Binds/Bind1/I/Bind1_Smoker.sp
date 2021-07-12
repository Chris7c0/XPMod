void Bind1Press_Smoker(iClient)
{
    if (g_iClientInfectedClass1[iClient] != SMOKER && 
        g_iClientInfectedClass2[iClient] != SMOKER &&
        g_iClientInfectedClass3[iClient] != SMOKER)
    {
        PrintHintText(iClient, "You dont have the Smoker as one of your classes");
        return;
    }

    if (g_iSmokerTalent2Level[iClient] <= 0)
    {
        PrintHintText(iClient, "You are not high enough level for Smoker Bind 1");
        return;
    }
    
            
}