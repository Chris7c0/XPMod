Action:TimerJumpFurther(Handle:timer, any:iClient)
{
	decl Float:velocity[3];
	GetEntPropVector(iClient, Prop_Data, "m_vecVelocity", velocity);
	velocity[0] *= (1.0 + (g_iMutatedLevel[iClient] * 0.06));
	velocity[1] *= (1.0 + (g_iMutatedLevel[iClient] * 0.06));
	velocity[2] *= (1.0 + (g_iMutatedLevel[iClient] * 0.06));
	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, velocity);
	
	return Plugin_Stop;
}

Action:TimerRemoveJockeyCloak(Handle:timer, any:iClient)
{
	g_bCanJockeyCloak[iClient] = true;
	SetClientRenderAndGlowColor(iClient);

	return Plugin_Stop;
}

Action:TimerRemoveVanishingActSpeed(Handle:timer, any:iClient)
{
	g_fJockeyRideSpeedVanishingActBoost[iClient] = 0.0;
	SetClientSpeed(iClient);

	return Plugin_Stop;
}

Action:TimerSetJockeyCooldown(Handle:timer, any:iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_bIsServingHotMeal[iClient] == true)
		return Plugin_Stop;
		
	//PrintToChatAll("\x03 jockey cooldown");
	
	// Get the ability ent id
	new iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
	if (!IsValidEntity(iEntid))
		return Plugin_Stop;

	//retrieve the next act time
	//new Float:flDuration_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+4);

	//----DEBUG----
	//if (g_iShow==1)
	//	PrintToChatAll("\x03- actsuppress dur \x01 %f\x03 timestamp \x01%f", GetEntDataFloat(iEntid, g_iSuppressO+4), GetEntDataFloat(iEntid, g_iSuppressO+8) );

	//retrieve current timestamp
	new Float:flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+8);

	if (g_fTimeStamp[iClient] < flTimeStamp_ret)
	{
		//----DEBUG----
		//PrintToChatAll("\x03 after adjusted shot\n-pre, iClient \x01%i\x03; entid \x01%i\x03; enginetime\x01 %f\x03; nextactivation: dur \x01 %f\x03 timestamp \x01%f",iClient,iEntid,GetGameTime(),GetEntDataFloat(iEntid, g_iOffset_NextActivation+4), GetEntDataFloat(iEntid, g_iOffset_NextActivation+8) );

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
		new Float:flTimeStamp_calc = flTimeStamp_ret - (g_iMutatedLevel[iClient] * 0.35);
		SetEntDataFloat(iEntid, g_iOffset_NextActivation+8, flTimeStamp_calc, true);
		
		//----DEBUG----
		//PrintToChatAll("\x03-post, nextactivation dur \x01 %f\x03 timestamp \x01%f", GetEntDataFloat(iEntid, g_iOffset_NextActivation+4), GetEntDataFloat(iEntid, g_iOffset_NextActivation+8) );
	}

	return Plugin_Continue;
}

Action:TimerJockeyJumpReset(Handle:timer, any:iClient)
{
	if (RunClientChecks(iClient) && 
		IsPlayerAlive(iClient) && 
		IsFakeClient(iClient) ==  false && 
		g_bJockeyIsRiding[iClient])
		g_bCanJockeyJump[iClient] = true;
	
	return Plugin_Stop;
}