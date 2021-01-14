OnGameFrame_Jockey(iClient)
{
	if((g_iUnfairLevel[iClient] > 0) && (g_bJockeyIsRiding[iClient] == true))
	{
		//PrintToChatAll("g_iUnfairLevel is higher than 0 and the jockey is riding");
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(buttons & IN_JUMP)
		{
			if (RunClientChecks(iClient) == true && RunClientChecks(g_iJockeysVictim[iClient]) == true)
			{
				//PrintToChatAll("g_bCanJockeyJump = %i, g_bCanJockeyCloak = %i", g_bCanJockeyJump[iClient], g_bCanJockeyCloak[iClient]);
				if(g_bCanJockeyJump[iClient] == true && g_bCanJockeyCloak[iClient] == false)
				{
					new Float:xyzJumpVelocity[3];
					xyzJumpVelocity[0] = 0.0;
					xyzJumpVelocity[1] = 0.0;
					xyzJumpVelocity[2] = (g_iUnfairLevel[iClient] * 50.0);
					//PrintToChatAll("X = %f, Y = %f, Z = %f", xyzJumpVelocity[0], xyzJumpVelocity[1], xyzJumpVelocity[2]);
					TeleportEntity(g_iJockeysVictim[iClient], NULL_VECTOR, NULL_VECTOR, xyzJumpVelocity);
					g_bCanJockeyJump[iClient] = false;
					CreateTimer(2.5, TimerJockeyJumpReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}