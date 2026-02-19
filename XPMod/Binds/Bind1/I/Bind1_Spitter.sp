void Bind1Press_Spitter(int iClient)
{
    if((g_iClientInfectedClass1[iClient] == SPITTER) || (g_iClientInfectedClass2[iClient] == SPITTER) || (g_iClientInfectedClass3[iClient] == SPITTER))
    {
        if(g_iMaterialLevel[iClient] > 0)
        {
            if(g_iClientBindUses_1[iClient] < 3)
            {
                BagOfSpitsMenuDraw(iClient);
            }
            else
                PrintHintText(iClient, "You are out of Bind 1 uses for this round");
        }
        else
            PrintHintText(iClient, "You must have Material Girl (Level 1) for Spitter Bind 1, Bag of Spits");
    }
    else
        PrintHintText(iClient, "You don't have the Spitter as one of your classes");
}
