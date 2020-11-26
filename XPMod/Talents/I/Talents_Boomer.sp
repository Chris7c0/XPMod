OnGameFrame_Boomer(iClient)
{
	if(g_iAcidicLevel[iClient] > 0)
	{
		if(IsPlayerAlive(iClient) == true)
		{
			if(GetEntityFlags(iClient) & FL_ONGROUND)
			{
				if(g_bIsSuicideJumping[iClient] == true)
				{
					if(GetEntProp(iClient, Prop_Send, "m_zombieClass") == BOOMER)
						ForcePlayerSuicide(iClient);
				}
			}
		}
	}
}