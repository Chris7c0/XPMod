public Action:PrintXPMmessage(Handle:timer, any:data)
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

public Action:PrintDonationMessage(Handle:timer, any:data)
{
	// PrintToChatAll("\x03[XPMod]\x05  Do you enjoy XPMod? Help us out at:\n               \x03l4d2xpmod.com/donate");
	return Plugin_Continue;
}

public Action:PrintXPModAdvertisementsToAll(Handle:timer, any:data)
{
	for(new i=1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i))
			if(!IsFakeClient(i))
				if(g_bClientLoggedIn[i] == false)
					AdvertiseXPModToNewUser(i, true);
				else if(g_bTalentsConfirmed[i] == false && g_bGameFrozen == false)
					AdvertiseConfirmXPModTalents(i);
	}
	return Plugin_Continue;
}

public Action:TimerLoadTalentsDelay(Handle:timer, any:iClient)
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