void Bind2Press_Nick(int iClient)
{
	if (g_bNickGambleLockedBinds[iClient] == true)
	{
		PrintHintText(iClient, "Your gambling problem has locked you out of your binds for 1 minute.");
		return;
	}

	if (g_iDesperateLevel[iClient] > 0)	   // Nick's actionkey 2
	{
		if (g_iClientBindUses_2[iClient] < 3)
		{
			JebusHandBindMenuDraw(iClient);
		}
		else
			PrintHintText(iClient, "You are too tired to use any more of your medical expertise for now.");
	}
}
