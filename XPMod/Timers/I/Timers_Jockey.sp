public Action:TimerJumpFurther(Handle:timer, any:iClient)
{
	decl Float:velocity[3];
	GetEntPropVector(iClient, Prop_Data, "m_vecVelocity", velocity);
	velocity[0] *= (1.0 + (g_iMutatedLevel[iClient] * 0.06));
	velocity[1] *= (1.0 + (g_iMutatedLevel[iClient] * 0.06));
	velocity[2] *= (1.0 + (g_iMutatedLevel[iClient] * 0.06));
	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, velocity);
	
	return Plugin_Stop;
}

public Action:TimerStopJockeyPeeSound(Handle:timer, any:iClient)
{
	StopSound(iClient, SNDCHAN_AUTO, SOUND_JOCKEYPEE);
	
	return Plugin_Stop;
}

public Action:TimerStopJockeyPee(Handle:timer, any:iClient)
{
	if(iClient > 0)
		return Plugin_Stop;
	if(IsClientInGame(iClient) == false)
		return Plugin_Stop;
	
	StopSound(iClient, SNDCHAN_AUTO, SOUND_JOCKEYPEE);

	if(IsFakeClient(iClient) == false)
		ShowHudOverlayColor(iClient, 255, 255, 0, 65, 1000, FADE_OUT);
		
	return Plugin_Stop;
}

public Action:TimerRemovePeeFX(Handle:timer, any:iClient)
{
	if(IsValidEntity(iClient) ==  false)
		return Plugin_Stop;
	if(IsClientInGame(iClient) ==  false)
		return Plugin_Stop;
	
	fnc_SetRendering(iClient);
	//ResetGlow(iClient);
	
	return Plugin_Stop;
}
	
public Action:TimerEnableJockeyPee(Handle:timer, any:iClient)
{
	g_bCanJockeyPee[iClient] = true;
	return Plugin_Stop;
}

public Action:TimerRemoveJockeyCloak(Handle:timer, any:iClient)
{
	g_bCanJockeyCloak[iClient] = true;
	fnc_SetRendering(iClient);
	//ResetGlow(iClient);
	return Plugin_Stop;
}

public Action:TimerSetJockeyCooldown(Handle:timer, any:iClient)
{
	//INITIAL CHECKS
	//--------------
	if (IsServerProcessing()==false
		|| iClient <= 0
		|| IsClientInGame(iClient)==false
		|| IsPlayerAlive(iClient)==false)
	{
		//KillTimer(timer);
		return Plugin_Stop;
	}
	if(g_bIsServingHotMeal[iClient] == true)
		return Plugin_Stop;

	//----DEBUG----
	//PrintToChatAll("\x03 tick");

	//RETRIEVE VARIABLES
	//------------------
	//get the ability ent id
	new iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
	//if the retrieved gun id is -1, then move on
	if (iEntid == -1)
	{
		//KillTimer(timer);
		return Plugin_Stop;
	}
	//retrieve the next act time
	//new Float:flDuration_ret = GetEntDataFloat(iEntid,g_iOffset_NextAct+4);

	//----DEBUG----
	//if (g_iShow==1)
	//	PrintToChatAll("\x03- actsuppress dur \x01 %f\x03 timestamp \x01%f", GetEntDataFloat(iEntid, g_iSuppressO+4), GetEntDataFloat(iEntid, g_iSuppressO+8) );

	//retrieve current timestamp
	new Float:flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextAct+8);

	if (g_fTimeStamp[iClient] < flTimeStamp_ret)
	{
		//----DEBUG----
		//PrintToChatAll("\x03 after adjusted shot\n-pre, iClient \x01%i\x03; entid \x01%i\x03; enginetime\x01 %f\x03; nextactivation: dur \x01 %f\x03 timestamp \x01%f",iClient,iEntid,GetGameTime(),GetEntDataFloat(iEntid, g_iOffset_NextAct+4), GetEntDataFloat(iEntid, g_iOffset_NextAct+8) );

		//update the timestamp stored in plugin
		g_fTimeStamp[iClient] = flTimeStamp_ret;

		//this calculates the time that the player theoretically
		//should have used his ability in order to use it
		//with the shortened cooldown
		//FOR EXAMPLE:
		//vomit, ATTACH_NORMAL cooldown 30s, desired cooldown 6s
		//player uses it at T = 1:30
		//normally, game predicts it to be ready at T + 30s
		//so if we modify T to 1:06, it will be ready at 1:36
		//which is 6s after the player used the ability
		//new Float:flTimeStamp_calc = flTimeStamp_ret - (GetConVarFloat(FindConVar("z_vomit_interval")) * (1.0 - 0.5) );	what it was in perkmod
		new Float:flTimeStamp_calc = flTimeStamp_ret + (g_iMutatedLevel[iClient] * 0.35);
		SetEntDataFloat(iEntid, g_iOffset_NextAct+8, flTimeStamp_calc, true);
		
		//----DEBUG----
		//PrintToChatAll("\x03-post, nextactivation dur \x01 %f\x03 timestamp \x01%f", GetEntDataFloat(iEntid, g_iOffset_NextAct+4), GetEntDataFloat(iEntid, g_iOffset_NextAct+8) );
	}

	return Plugin_Continue;
}

public Action:TimerJockeyJumpReset(Handle:timer, any:iClient)
{
	g_bCanJockeyJump[iClient] = true;
	return Plugin_Continue;
}