Action:TimerShowReward1(Handle:timer, any:iClient)
{
	if(g_iReward_SIKillsID > 0 && g_iReward_SIKills > 0)
	{
		PrintToChatAll("\x03[XPMod] \x05Most S.I. Killed: \x04%s\x05 (\x03%d Killed\x05)", g_strReward_SIKills, g_iReward_SIKills);
		
		if(IsClientInGame(g_iReward_SIKillsID) && IsFakeClient(g_iReward_SIKillsID) == false)
			PrintToChat(g_iReward_SIKillsID, "\x03      - You were rewarded %d bonus XP",  (20 * g_iReward_SIKills));
		
		CreateTimer(3.0, TimerShowReward2, 0, TIMER_FLAG_NO_MAPCHANGE);
	}
	else
		CreateTimer(0.1, TimerShowReward2, 0, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

Action:TimerShowReward2(Handle:timer, any:iClient)
{
	if(g_iReward_CIKillsID > 0 && g_iReward_CIKills > 0)
	{
		PrintToChatAll("\x03[XPMod] \x05Most C.I. Killed: \x04%s\x05 (\x03%d Killed\x05)", g_strReward_CIKills, g_iReward_CIKills);
		
		if(IsClientInGame(g_iReward_CIKillsID) && IsFakeClient(g_iReward_CIKillsID) == false)
			PrintToChat(g_iReward_CIKillsID, "\x03      - You were rewarded %d bonus XP",  (2 * g_iReward_CIKills));
			
		CreateTimer(3.0, TimerShowReward3, 0, TIMER_FLAG_NO_MAPCHANGE);
	}
	else
		CreateTimer(0.1, TimerShowReward3, 0, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

Action:TimerShowReward3(Handle:timer, any:iClient)
{
	if(g_iReward_HSID > 0 && g_iReward_HS > 0)
	{
		PrintToChatAll("\x03[XPMod] \x05Most Headshots: \x04%s\x05 (\x03%d HS\x05)", g_strReward_HS, g_iReward_HS);
		
		if(IsClientInGame(g_iReward_HSID) && IsFakeClient(g_iReward_HSID) == false)
			PrintToChat(g_iReward_HSID, "\x03      - You were rewarded %d bonus XP",  (10 * g_iReward_HS));
		
		CreateTimer(3.0, TimerShowReward4, 0, TIMER_FLAG_NO_MAPCHANGE);
	}
	else
		CreateTimer(0.1, TimerShowReward4, 0, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

Action:TimerShowReward4(Handle:timer, any:iClient)
{
	if(g_iReward_SurKillsID > 0 && g_iReward_SurKills > 0)
	{
		PrintToChatAll("\x03[XPMod] \x05Most Survivors Killed: \x04%s\x05 (\x03%d Killed\x05)", g_strReward_SurKills, g_iReward_SurKills);
		
		if(IsClientInGame(g_iReward_SurKillsID) && IsFakeClient(g_iReward_SurKillsID) == false)
			PrintToChat(g_iReward_SurKillsID, "\x03      - You were rewarded %d bonus XP",  (250 * g_iReward_SurKills));
		
		CreateTimer(3.0, TimerShowReward5, 0, TIMER_FLAG_NO_MAPCHANGE);
	}
	else
		CreateTimer(0.1, TimerShowReward5, 0, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

Action:TimerShowReward5(Handle:timer, any:iClient)
{
	if(g_iReward_SurIncapsID > 0 && g_iReward_SurIncaps > 0)
	{
		PrintToChatAll("\x03[XPMod] \x05Most Survivor Incaps: \x04%s\x05 (\x03%d Incaps\x05)", g_strReward_SurIncaps, g_iReward_SurIncaps);
		
		if(IsClientInGame(g_iReward_SurIncapsID) && IsFakeClient(g_iReward_SurIncapsID) == false)
			PrintToChat(g_iReward_SurIncapsID, "\x03      - You were rewarded %d bonus XP",  (100 * g_iReward_SurIncaps));
		
		CreateTimer(3.0, TimerShowReward6, 0, TIMER_FLAG_NO_MAPCHANGE);
	}
	else
		CreateTimer(0.1, TimerShowReward6, 0, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

Action:TimerShowReward6(Handle:timer, any:iClient)
{
	if(g_iReward_SurDmgID > 0 && g_iReward_SurDmg > 0)
	{
		PrintToChatAll("\x03[XPMod] \x05Most DMG To Survivors: \x04%s\x05 (\x03%d DMG\x05)", g_strReward_SurDmg, g_iReward_SurDmg);
		
		if(IsClientInGame(g_iReward_SurDmgID) && IsFakeClient(g_iReward_SurDmgID) == false)
			PrintToChat(g_iReward_SurDmgID, "\x03      - You were rewarded %d bonus XP",  g_iReward_SurDmg);
	}
	
	return Plugin_Stop;
}