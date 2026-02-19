
//Boomer
Action TimerConstantVomitDisplay(Handle timer, int iClient)
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


Action TimerResetBoomerSpeed(Handle timer, int iClient)
{
	g_bIsBoomerVomiting[iClient] = false;

	if(IsClientInGame(iClient) && IsPlayerAlive(iClient) && g_bIsSuperSpeedBoomer[iClient] == false)
	{
		SetClientSpeed(iClient);
	}

	return Plugin_Stop;
}

Action TimerResetFastBoomerSpeed(Handle timer, int iClient)
{
	g_bIsSuperSpeedBoomer[iClient] = false;
	
	if(IsClientInGame(iClient) && IsPlayerAlive(iClient))
		SetClientSpeed(iClient);

	return Plugin_Stop;
}

Action TimerStopHotMeal(Handle timer, int iClient)
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

Action TimerStopItCounting(Handle timer, int iClient)
{
	g_bNowCountingVomitVictims[iClient] = false;
	g_iVomitVictimCounter[iClient] = 0;

	return Plugin_Stop;
}

Action TimerConstantVomit(Handle timer, int iClient)
{
	if (IsServerProcessing()==false || iClient <= 0 || IsClientInGame(iClient)==false || IsPlayerAlive(iClient)==false || g_bIsServingHotMeal[iClient] == false)
		return Plugin_Stop;
	
	int iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
	
	if (!IsValidEntity(iEntid))
		return Plugin_Stop;

	float flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+8);


	g_fTimeStamp[iClient] = flTimeStamp_ret;
	float flTimeStamp_calc = flTimeStamp_ret - 29.5;
	SetEntDataFloat(iEntid, g_iOffset_NextActivation+8, flTimeStamp_calc, true);
	
	return Plugin_Continue;
}

Action TimerSetBoomerCooldown(Handle timer, int iClient)
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

	//RETRIEVE VARIABLES
	//------------------
	//get the ability ent id
	int iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
	//if the retrieved gun id is -1, then move on
	if (!IsValidEntity(iEntid))
		return Plugin_Stop;
	
	//retrieve the next act time

	//----DEBUG----
	//if (g_iShow==1)

	//retrieve current timestamp
	float flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+8);
	if (g_fTimeStamp[iClient] < flTimeStamp_ret)
	{
		//----DEBUG----
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
		float flTimeStamp_calc = flTimeStamp_ret -  (30 - (30 - (g_iRapidLevel[iClient] * 2)) );
		SetEntDataFloat(iEntid, g_iOffset_NextActivation+8, flTimeStamp_calc, true);

		//----DEBUG----
	}

	return Plugin_Continue;
}


Action TimerSuicideBoomerLaunch(Handle timer, int iClient)
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
