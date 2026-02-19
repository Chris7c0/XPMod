
//Boomer
Action TimerConstantVomitDisplay(Handle timer, any iClient)
{
	if(IsClientInGame(iClient))
		if(IsPlayerAlive(iClient))
			if(g_iShowSurvivorVomitCounter[iClient] > 0)
			{
				g_bIsSurvivorVomiting[iClient] = true;
				g_iShowSurvivorVomitCounter[iClient]--;
				CreateParticle("boomer_vomit", 2.0, iClient, ATTACH_MOUTH, true);
				CreateTimer(1.0, TimerConstantVomitDisplay, iClient, TIMER_FLAG_NO_MAPCHANGE);
				return Plugin_Stop;
			}
	g_bIsSurvivorVomiting[iClient] = false;

	return Plugin_Stop;
}


Action TimerResetBoomerSpeed(Handle timer, any iClient)
{
	g_bIsBoomerVomiting[iClient] = false;

	if(IsClientInGame(iClient) && IsPlayerAlive(iClient) && g_bIsSuperSpeedBoomer[iClient] == false)
	{
		SetClientSpeed(iClient);
	}

	return Plugin_Stop;
}

Action TimerResetFastBoomerSpeed(Handle timer, any iClient)
{
	g_bIsSuperSpeedBoomer[iClient] = false;
	
	if(IsClientInGame(iClient) && IsPlayerAlive(iClient))
		SetClientSpeed(iClient);

	return Plugin_Stop;
}

Action TimerStopHotMeal(Handle timer, any iClient)
{
	g_bIsServingHotMeal[iClient] = false;
	g_bIsBoomerVomiting[iClient] = false;
	
	if(IsClientInGame(iClient) == true && IsPlayerAlive(iClient) == true)
	{
		SetClientSpeed(iClient);
			
		if(IsFakeClient(iClient) == false)
			CreateTimer(1.5, TimerSetBoomerCooldown, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Stop;
}

Action TimerStopItCounting(Handle timer, any iClient)
{
	g_bNowCountingVomitVictims[iClient] = false;
	g_iVomitVictimCounter[iClient] = 0;

	return Plugin_Stop;
}

Action TimerConstantVomit(Handle timer, any iClient)
{
	if (IsServerProcessing()==false || iClient <= 0 || IsClientInGame(iClient)==false || IsPlayerAlive(iClient)==false || g_bIsServingHotMeal[iClient] == false)
		return Plugin_Stop;
	
	new iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
	
	if (!IsValidEntity(iEntid))
		return Plugin_Stop;

	float flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+8);


	g_fTimeStamp[iClient] = flTimeStamp_ret;
	float flTimeStamp_calc = flTimeStamp_ret - 29.5;
	SetEntDataFloat(iEntid, g_iOffset_NextActivation+8, flTimeStamp_calc, true);
	
	return Plugin_Continue;
}

Action TimerSetBoomerCooldown(Handle timer, any iClient)
{
	//INITIAL CHECKS
	//--------------
	if (IsServerProcessing()==false
		|| iClient <= 0
		|| IsClientInGame(iClient)==false
		|| IsPlayerAlive(iClient)==false
		|| g_bIsServingHotMeal[iClient] == true)
	{
		return Plugin_Stop;
	}
	//----DEBUG----
	//PrintToChatAll("\x03 tick");

	//RETRIEVE VARIABLES
	//------------------
	//get the ability ent id
	new iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
	//if the retrieved gun id is -1, then move on
	//PrintToChatAll("iEntid = %d", iEntid);
	if (!IsValidEntity(iEntid))
		return Plugin_Stop;
	
	//retrieve the next act time
	//float flDuration_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+4);

	//----DEBUG----
	//if (g_iShow==1)
	//	PrintToChatAll("\x03- actsuppress dur \x01 %f\x03 timestamp \x01%f", GetEntDataFloat(iEntid, g_iSuppressO+4), GetEntDataFloat(iEntid, g_iSuppressO+8) );

	//retrieve current timestamp
	float flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+8);
	//PrintToChatAll("flTimeStamp_ret = %f", flTimeStamp_ret);
	//PrintToChatAll("\x03 after adjusted shot\n-pre, iClient \x01%i\x03; entid \x01%i\x03; enginetime\x01 %f\x03; nextactivation: dur \x01 %f\x03 timestamp \x01%f",iClient,iEntid,GetGameTime(),GetEntDataFloat(iEntid, g_iOffset_NextActivation+4), GetEntDataFloat(iEntid, g_iOffset_NextActivation+8) );
	if (g_fTimeStamp[iClient] < flTimeStamp_ret)
	{
		//----DEBUG----
		//PrintToChatAll("\x03 after adjusted shot\n-pre, iClient \x01%i\x03; entid \x01%i\x03; enginetime\x01 %f\x03; nextactivation: dur \x01 %f\x03 timestamp \x01%f",iClient,iEntid,GetGameTime(),GetEntDataFloat(iEntid, g_iOffset_NextActivation+4), GetEntDataFloat(iEntid, g_iOffset_NextActivation+8) );
		//PrintToChatAll("g_fTimeStamp %f is less than flTimeStamp_ret %f", g_fTimeStamp[iClient], flTimeStamp_ret);
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
		//float flTimeStamp_calc = flTimeStamp_ret - (GetConVarFloat(FindConVar("z_vomit_interval")) * (1.0 - 0.5) );	what it was in perkmod
		float flTimeStamp_calc = flTimeStamp_ret -  (30 - (30 - (g_iRapidLevel[iClient] * 2)) );
		//PrintToChatAll("flTimeStamp_calc = %f", flTimeStamp_calc);
		SetEntDataFloat(iEntid, g_iOffset_NextActivation+8, flTimeStamp_calc, true);

		//----DEBUG----
		//PrintToChatAll("\x03-post, nextactivation dur \x01 %f\x03 timestamp \x01%f", GetEntDataFloat(iEntid, g_iOffset_NextActivation+4), GetEntDataFloat(iEntid, g_iOffset_NextActivation+8) );
	}

	return Plugin_Continue;
}


Action TimerSuicideBoomerLaunch(Handle timer, any iClient)
{
	g_bIsSuicideBoomer[iClient] = false;
	SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"),2.0, true);
	float velocity[3];
	GetEntPropVector(iClient, Prop_Data, "m_vecVelocity", velocity);
	velocity[0] *= (1.0 + (g_iNorovirusLevel[iClient] * 0.04));
	velocity[1] *= (1.0 + (g_iNorovirusLevel[iClient] * 0.04));
	velocity[2] = (750.0 + (g_iNorovirusLevel[iClient] * 50.0));
	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, velocity);
	g_bIsSuicideJumping[iClient] = true;
	g_iClientBindUses_2[iClient]++;

	return Plugin_Stop;
}
