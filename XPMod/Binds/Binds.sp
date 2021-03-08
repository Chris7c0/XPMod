/**************************************************************************************************************************
 *                                                    Bind Pressed                                                      *
 **************************************************************************************************************************/

void BindPress(int iClient, int iBindNumber)
{
	if(RunClientChecks(iClient) == false)
		return;
	
	if(g_bTalentsConfirmed[iClient] == false)
	{
		PrintToChat(iClient, "\x03[XPMod] \x04You must confirm your talents before using binds.");
		return;
	}

	if(!IsPlayerAlive(iClient))
	{
		PrintToChat(iClient, "\x03[XPMod] \x04You cannot use binds while you are dead.");
		return;
	}

	if(GetEntData(iClient, g_iOffset_IsGhost, 1) == 1)
	{
		PrintToChat(iClient, "\x03[XPMod] \x04You cannot use binds while your a ghost.");
		return;
	}

	if(g_bGameFrozen == true)
	{
		PrintToChat(iClient, "\x03[XPMod] \x04You must wait till the game is unfrozen before using binds.");
		return;
	}

	if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
	{
		switch(g_iChosenSurvivor[iClient])
		{
			case BILL:		iBindNumber == 1 ? Bind1Press_Bill(iClient) : Bind2Press_Bill(iClient);
			case ROCHELLE:	iBindNumber == 1 ? Bind1Press_Rochelle(iClient) : Bind2Press_Rochelle(iClient);
			case COACH:		iBindNumber == 1 ? Bind1Press_Coach(iClient) : Bind2Press_Coach(iClient);
			case ELLIS:		iBindNumber == 1 ? Bind1Press_Ellis(iClient) : Bind2Press_Ellis(iClient);
			case NICK:		iBindNumber == 1 ? Bind1Press_Nick(iClient) : Bind2Press_Nick(iClient);
			case LOUIS:		iBindNumber == 1 ? Bind1Press_Louis(iClient) : Bind2Press_Louis(iClient);
		}
	}
	else if(g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		switch(g_iInfectedCharacter[iClient])
		{
			case SMOKER:	iBindNumber == 1 ? Bind1Press_Smoker(iClient) : Bind2Press_Smoker(iClient);
			case BOOMER:	iBindNumber == 1 ? Bind1Press_Boomer(iClient) : Bind2Press_Boomer(iClient);
			case HUNTER:	iBindNumber == 1 ? Bind1Press_Hunter(iClient) : Bind2Press_Hunter(iClient);
			case SPITTER:	iBindNumber == 1 ? Bind1Press_Spitter(iClient) : Bind2Press_Spitter(iClient);
			case JOCKEY:	iBindNumber == 1 ? Bind1Press_Jockey(iClient) : Bind2Press_Jockey(iClient);
			case CHARGER:	iBindNumber == 1 ? Bind1Press_Charger(iClient) : Bind2Press_Charger(iClient);
		}
	}
}

Action:Bind1Press(iClient, args)
{
	// Handle Pressing the bind
	BindPress(iClient, 1);
	
	return Plugin_Handled;
}


Action:Bind2Press(iClient, args)
{
	// Handle Pressing the bind
	BindPress(iClient, 2);

	return Plugin_Handled;
}