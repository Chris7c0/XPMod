Action TimerSetChargerCooldown(Handle timer, any iClient)
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
	if (iEntid == -1)
	{
		return Plugin_Stop;
	}
	//retrieve the next act time
	//float flDuration_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+4);

	//----DEBUG----
	//if (g_iShow==1)
	//	PrintToChatAll("\x03- actsuppress dur \x01 %f\x03 timestamp \x01%f", GetEntDataFloat(iEntid, g_iSuppressO+4), GetEntDataFloat(iEntid, g_iSuppressO+8) );

	//retrieve current timestamp
	float flTimeStamp_ret = GetEntDataFloat(iEntid,g_iOffset_NextActivation+8);

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
		//float flTimeStamp_calc = flTimeStamp_ret - (GetConVarFloat(FindConVar("z_vomit_interval")) * (1.0 - 0.5) );	what it was in perkmod
		float flTimeStamp_calc;
		if(g_iHillbillyLevel[iClient] < 3)
			flTimeStamp_calc = flTimeStamp_ret -  (12 - (12 - (1)) );
		else if(g_iHillbillyLevel[iClient] < 5)
			flTimeStamp_calc = flTimeStamp_ret -  (12 - (12 - (2)) );
		else if(g_iHillbillyLevel[iClient] < 7)
			flTimeStamp_calc = flTimeStamp_ret -  (12 - (12 - (3)) );
		else if(g_iHillbillyLevel[iClient] < 9)
			flTimeStamp_calc = flTimeStamp_ret -  (12 - (12 - (4)) );
		else
			flTimeStamp_calc = flTimeStamp_ret -  (12 - (12 - (5)) );
		SetEntDataFloat(iEntid, g_iOffset_NextActivation+8, flTimeStamp_calc, true);
		
		//----DEBUG----
		//PrintToChatAll("\x03-post, nextactivation dur \x01 %f\x03 timestamp \x01%f", GetEntDataFloat(iEntid, g_iOffset_NextActivation+4), GetEntDataFloat(iEntid, g_iOffset_NextActivation+8) );
	}

	return Plugin_Continue;
}

Action TimerResetSuperCharge(Handle timer, any iClient)
{
	g_bCanChargerSuperCharge[iClient] = true;
	return Plugin_Stop;
}

Action TimerResetSpikedCharge(Handle timer, any iClient)
{
	g_bCanChargerSpikedCharge[iClient] = true;
	return Plugin_Stop;
}

Action TimerResetChargerHealingColor(Handle timer, any iClient)
{
	g_bIsChargerHealing[iClient] = false;
	SetEntProp(iClient, Prop_Send, "m_iGlowType", 2);
	SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
	SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 1);
	
	return Plugin_Stop;
}

Action TimerEarthquakeCooldown(Handle timer, any iClient)
{
	g_bCanChargerEarthquake[iClient] = true;
	return Plugin_Stop;
}
