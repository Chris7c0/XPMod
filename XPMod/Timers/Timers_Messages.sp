Action PrintUnsetClassesMessage(Handle timer, int data)
{
	for (int i = 1; i <= MaxClients; i++)
	{
			if(IsClientInGame(i) && IsFakeClient(i) == false && g_bClientLoggedIn[i] == true && g_bTalentsConfirmed[i] == true)
			{
				if(g_iSkillPoints[i] == 1)
					PrintToChat(i, "\x03[XPMod]\x01 * \x05You have\x01 1\x05 unused Skill Point!\x01 *\x05\n                Type \x04xpm\x05 and choose \x03Survivor Talents \x05to level up.");
				else if(g_iSkillPoints[i] > 1)
					PrintToChat(i, "\x03[XPMod]\x01 * \x05You have \x01%d\x05 unused Skill Points!\x01 *\x05\n                Type \x04xpm\x05 and choose \x03Survivor Talents \x05to level up.", g_iSkillPoints[i]);
				else if((g_iClientInfectedClass1[i] == UNKNOWN_INFECTED) || (g_iClientInfectedClass2[i] == UNKNOWN_INFECTED) || (g_iClientInfectedClass3[i] == UNKNOWN_INFECTED))
				{
					int num = 0;
					if(g_iClientInfectedClass1[i] == UNKNOWN_INFECTED)
						num++;
					if(g_iClientInfectedClass2[i] == UNKNOWN_INFECTED)
						num++;
					if(g_iClientInfectedClass3[i] == UNKNOWN_INFECTED)
						num++;
					switch(num)
					{
						case 1: PrintToChat(i, "\x03[XPMod]\x01 * \x05You have\x01 1\x05 unchosen class in your \x01Infected Talents \x05!\x01 *\x05\n                Type \x04xpm\x05 and choose your infected classes.");
						case 2: PrintToChat(i, "\x03[XPMod]\x01 * \x05You have\x01 2\x05 unchosen classes in your \x01Infected Talents \x05!\x01 *\x05\n                Type \x04xpm\x05 and choose your infected classes.");
						case 3: PrintToChat(i, "\x03[XPMod]\x01 * \x05You have\x01 3\x05 unchosen classes in your \x01Infected Talents \x05!\x01 *\x05\n                Type \x04xpm\x05 and choose your infected classes.");
					}
				}
			}
	}
	
	return Plugin_Continue;
}

Action PrintXPModCreateAndConfirmMessageToAll(Handle timer, int data)
{
	for (int i = 1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
			if(g_bClientLoggedIn[i] == false)
				AdvertiseXPModToNewUser(i, true);
			else if(g_bTalentsConfirmed[i] == false && g_bGameFrozen == false)
				AdvertiseConfirmXPModTalents(i);
	}
	return Plugin_Continue;
}

Action PrintXPModAdvertisementMessageToAll(Handle timer, int data)
{
	static iAdvertisementIndex;
	if (++iAdvertisementIndex > 5)
		iAdvertisementIndex = 0;
	
	char strAdvertisementText[256];
	switch (iAdvertisementIndex)
	{
		case 0: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05You can go to \x03xpmod.net\x05 to learn about XPMod abilities.");
		case 1: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05\x03xpmod.net\x05 works on Mobile Phone and Desktop browsers.");
		case 2: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Need XPMod help? There is a Help section at \x03xpmod.net\x05 ");
		case 3: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Want to join a XPMod server later? Join the XPMod Steam Group.");
		case 4: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Want to see Special Effects? Get the XPMod Addon at \x03xpmod.net\x05 ");
		case 5: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Join us in Discord: \x03xpmod.net/discord\x05\n  You can get updates, give suggestions, or ask for help.");
	}

	PrintToChatAll(strAdvertisementText);
	return Plugin_Continue;
}

Action TimerLoadTalentsDelay(Handle timer, int iClient)
{
	if(g_bClientLoggedIn[iClient] == true && 
		talentsJustGiven[iClient] == false && 
		g_bTalentsConfirmed[iClient] == true && 
		IsValidEntity(iClient) && 
		IsClientInGame(iClient) && 
		IsFakeClient(iClient) == false && 
		IsPlayerAlive(iClient))
	{
		LoadTalents(iClient);
		talentsJustGiven[iClient] = true;
	}
	
	return Plugin_Stop;
}
