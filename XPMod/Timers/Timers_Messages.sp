Action:PrintUnsetClassesMessage(Handle:timer, any:data)
{
	for(new i = 1; i <= MaxClients; i++)
	{
			if(IsClientInGame(i) && IsFakeClient(i) == false && g_bClientLoggedIn[i] == true && g_bTalentsConfirmed[i] == true)
			{
				if(g_iSkillPoints[i] == 1)
					PrintToChat(i, "\x03[XPMod]\x01 * \x05You have\x01 1\x05 unused Skill Point!\x01 *\x05\n                Type \x04xpm\x05 and choose \x03Survivor Talents \x05to level up.");
				else if(g_iSkillPoints[i] > 1)
					PrintToChat(i, "\x03[XPMod]\x01 * \x05You have \x01%d\x05 unused Skill Points!\x01 *\x05\n                Type \x04xpm\x05 and choose \x03Survivor Talents \x05to level up.", g_iSkillPoints[i]);
				else if((g_iClientInfectedClass1[i] == UNKNOWN_INFECTED) || (g_iClientInfectedClass2[i] == UNKNOWN_INFECTED) || (g_iClientInfectedClass3[i] == UNKNOWN_INFECTED))
				{
					new num = 0;
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

Action:PrintXPModCreateAndConfirmMessageToAll(Handle:timer, any:data)
{
	for(new i=1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
			if(g_bClientLoggedIn[i] == false)
				AdvertiseXPModToNewUser(i, true);
			else if(g_bTalentsConfirmed[i] == false && g_bGameFrozen == false)
				AdvertiseConfirmXPModTalents(i);
	}
	return Plugin_Continue;
}

Action:PrintXPModAdvertisementMessageToAll(Handle:timer, any:data)
{
	static iAdvertisementIndex;
	if (++iAdvertisementIndex > 6)
		iAdvertisementIndex = 0;
	
	decl String:strAdvertisementText[256];
	switch (iAdvertisementIndex)
	{
		case 0: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Confused about XPMod? You can go to \x03xpmod.net\x05 to learn more.");
		case 1: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Enjoy XPMod? You can support us at \x03xpmod.net/donate");
		case 2: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Go to \x03xpmod.net\x05 on your phone to learn about XPMod abilities.");
		case 3: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Found a bug in XPMod? Report it in Discord \x03xpmod.net/discord.");
		case 4: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Want to try the XPMod Addon? It adds new special effects.\n  Press \x03H\x05\n  Click \x03Join this server's Steam Group\x05\n  Click \x03Get XPMod Addons\x05\n  Click \x03Subscribe\x05\n  Restart Left4Dead2");
		case 5: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Want to join a XPMod server later? Then join our Steam Group.\n  Search for\x03XPMod Steam Group\x05 in your browser and Join.\n  You'll see all XPMod servers on the right when opening L4D2.");
		case 6: Format(strAdvertisementText, sizeof(strAdvertisementText), "\x05Join us in Discord: \x03xpmod.net/discord");
	}

	PrintToChatAll(strAdvertisementText);
	return Plugin_Continue;
}

Action:TimerLoadTalentsDelay(Handle:timer, any:iClient)
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