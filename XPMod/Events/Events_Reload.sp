
/**************************************************************************************************************************
 *                                                   Reloading Event                                                      *
 **************************************************************************************************************************/

void Event_WeaponReload(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	//PrintToChatAll("Entered reload event...");
	int iClient = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	if (g_bTalentsConfirmed[iClient] == false)
		return;

	switch(g_iChosenSurvivor[iClient])
	{
		case BILL:		//Bill
		{
		
		}
		case ROCHELLE:		//Rochelle
		{
		
		}
		case COACH:		//Coach
		{
		
		}
		case ELLIS:		//Ellis
		{
			StoreCurrentPrimaryWeapon(iClient);
			StoreCurrentPrimaryWeaponAmmo(iClient);
		}
		case NICK:		//Nick
		{
		/*
			GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
			if((g_bCanNickStampedeReload[iClient] == true) && (StrEqual(strCurrentWeapon, "weapon_pistol_magnum", false) == true))
			{
				//PrintToChatAll("Stampede reloading...");
				//PrintToChatAll("Reload rate before %f", g_fReloadRate);
				g_fReloadRate = 1.0 - (g_iMagnumLevel[iClient] * 0.1);
				//PrintToChatAll("Reload rate after %f", g_fReloadRate);
				g_bCanNickStampedeReload[iClient] = false;
			}
			g_iNickMagnumShotCount[iClient] = 0;
		*/
		}
		case LOUIS:
		{

		}
	}

	//PrintToChatAll("Beggining check for current weapon...");
	char currentweapon[32];
	// PrintToChatAll("Weapon Reload");
	GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
	int ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	
	if(RunClientChecks(iClient) == false || IsFakeClient(iClient)==true || g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;
	
	if(g_bCoachShotgunForceReload[iClient] == true)
	{
		SetEntData(ActiveWeaponID, g_iOffset_ClipShotgun, g_iCoachShotgunSavedAmmo[iClient], true);
	}
	if(g_bForceReload[iClient] == true)
	{
		if(g_iRiskyLevel[iClient] > 0)
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iSavedClip[iClient], true);
		}
	}
	g_iReloadFrameCounter[iClient] = 0;
	g_bClientIsReloading[iClient] = true;
	g_bForceReload[iClient] = false;
	/*
	if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true) || (StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (g_iSprayLevel[iClient] > 0))
	{
		int ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
		int CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
		//g_iCoachShotgunIncreasedAmmo[iClient] = CurrentClipAmmo + 1;
		
		if(g_bCoachShotgunForceReload[iClient] == false)
		{
			g_iCoachShotgunSavedAmmo[iClient] = CurrentClipAmmo;
		}
		
	}
	*/
	if (g_iExorcismLevel[iClient]>0 || 
		g_iPromotionalLevel[iClient]>0 || 
		g_iWeaponsLevel[iClient]>0 || 
		g_iMagnumLevel[iClient]>0 || 
		g_iRiskyLevel[iClient]>0 || 
		g_iSprayLevel[iClient]>0 || 
		g_iSilentLevel[iClient]>0 || 
		g_iLouisTalent1Level[iClient] > 0)
	{
		int iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);//5565
		if (IsValidEntity(iEntid)==false)
			return;
		if(iEntid < 1) return;
		char stClass[32];
		GetEntityNetClass(iEntid,stClass,32);
		// PrintToChatAll("\x03-class of gun: \x01%s",stClass );
		if (StrContains(stClass,"Grenade",false) != -1)
			return;
		
		g_fReloadRate = 1.0 - (float(g_iExorcismLevel[iClient]) * 0.09) - (float(g_iPromotionalLevel[iClient]) * 0.04) - (float(g_iWeaponsLevel[iClient]) * 0.15);
		
		if(g_iRiskyLevel[iClient]>0)
		{
			if (StrContains(stClass,"CPistol",false) != -1)	//Just for pistol not magnum
				g_fReloadRate = 1.0 - (float(g_iRiskyLevel[iClient]) * 0.1);
		}
		else if(g_iSilentLevel[iClient]>0)
		{
			if(StrContains(stClass,"CSniperRifle",false) != -1)	//using Ruger Mini Sniper Rifle
				g_fReloadRate = 1.0 - (float(g_iSilentLevel[iClient]) * 0.08);
		}
		else if (g_iLouisTalent1Level[iClient] > 0)
		{
			if (StrContains(stClass,"CSubMachinegun",false) != -1 || 
				StrContains(stClass,"CSMG",false) != -1 ||
				StrContains(stClass,"CPistol",false) != -1)
				g_fReloadRate = 1.0 - (float(g_iLouisTalent1Level[iClient]) * 0.05);
		}

		char strCurrentWeapon[32];
		GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
		if((g_iNickMagnumHitsPerClip[iClient] > 0) && (StrEqual(strCurrentWeapon, "weapon_pistol_magnum", false) == true))
		{
			// Shouldnt happen, but just in case limit the value to the max
			if (g_iNickMagnumHitsPerClip[iClient] > NICK_CLIP_SIZE_MAX_MAGNUM)
				g_iNickMagnumHitsPerClip[iClient] = NICK_CLIP_SIZE_MAX_MAGNUM;

			// PrintToChatAll("Reload rate before %f", g_fReloadRate);
			g_fReloadRate = 1.0 - (g_iNickMagnumHitsPerClip[iClient] * 0.15);
			// PrintToChatAll("Reload rate after %f", g_fReloadRate);
		}

		g_iNickMagnumHitsPerClip[iClient] = 0;
		
		//PrintToChatAll("ReloadRate = %f", g_fReloadRate);
		
		if (StrContains(stClass,"shotgun",false) == -1)
		{
			float fGameTime = GetGameTime(); 
			float flNextTime_ret = GetEntDataFloat(iEntid,g_iOffset_NextPrimaryAttack);
				//this is a calculation of when the next primary attack
				//will be after applying sleight of hand values
				//NOTE: at this point, only calculate the interval itself,
				//without the actual game engine time factored in
			float flNextTime_calc = ( flNextTime_ret - fGameTime ) * g_fReloadRate;

				//we change the playback rate of the gun
				//just so the player can "see" the gun reloading faster
			SetEntDataFloat(iEntid, g_iOffset_PlaybackRate, 1.0/g_fReloadRate, true);

				//create a timer to reset the playrate after
				//time equal to the modified attack interval
			
			CreateTimer(flNextTime_calc, SoH_MagEnd, iEntid, TIMER_FLAG_NO_MAPCHANGE);

			//experiment to remove double-playback bug
			Handle hPack = CreateDataPack();
			WritePackCell(hPack, iClient);
			//this calculates the equivalent time for the reload to end
			//if the survivor didn't have the SoH perk
			float flStartTime_calc = fGameTime - ( flNextTime_ret - fGameTime ) * ( 1 - g_fReloadRate ) ;
			WritePackFloat(hPack, flStartTime_calc);
			
			//now we create the timer that will prevent the annoying double playback
			//was 0.08
			if(rspeed > 1.0)
			{
				float anispeed = FindAnimationSpeed(g_fReloadRate)//, stClass);
				CreateTimer(flNextTime_calc * anispeed, SoH_MagEnd2, hPack);
			}
			else
			{
				CreateTimer(flNextTime_calc * rspeed, SoH_MagEnd2, hPack);
			}
			
			//and finally we set the end reload time into the gun
			//so the player can actually shoot with it at the end
			flNextTime_calc += fGameTime;
			SetEntDataFloat(iEntid, g_iOffset_TimeWeaponIdle, flNextTime_calc, true);
			SetEntDataFloat(iEntid, g_iOffset_NextPrimaryAttack, flNextTime_calc, true);
			SetEntDataFloat(iClient, g_iOffset_NextAttack, flNextTime_calc, true);
		}
		else if (StrContains(stClass,"autoshotgun",false) != -1)
		{
			CreateTimer(0.1,SoH_AutoshotgunStart, iEntid, TIMER_FLAG_NO_MAPCHANGE);
			return;
		}

		else if (StrContains(stClass,"shotgun_spas",false) != -1)
		{
			CreateTimer(0.1,SoH_SpasShotgunStart,iEntid, TIMER_FLAG_NO_MAPCHANGE);
			return;
		}

		else if (StrContains(stClass,"pumpshotgun",false) != -1
			|| StrContains(stClass,"shotgun_chrome",false) != -1)
		{
			CreateTimer(0.1,SoH_PumpshotgunStart,iEntid, TIMER_FLAG_NO_MAPCHANGE);
			return;
		}
	}
	//PrintToChatAll("Reload Finished");
	return;
}

float FindAnimationSpeed(float reloadspeed) //, char[] gunname)
{
	float anispeed;
	anispeed = reloadspeed;
	return anispeed;
}

//this resets the playback rate on non-shotguns
Action SoH_MagEnd(Handle timer, any iEntid2)
{
	//PrintToChatAll("\x03SoH reset playback, magazine loader");

	if (iEntid2 <= 0 || IsValidEntity(iEntid2)==false)
		return Plugin_Stop;

	SetEntDataFloat(iEntid2, g_iOffset_PlaybackRate, 1.0, true);

	return Plugin_Stop;
}

Action SoH_MagEnd2(Handle timer, Handle hPack)
{
	//PrintToChatAll("\x03SoH reset playback, magazine loader");
	ResetPack(hPack);
	int iClient = ReadPackCell(hPack);
	float flStartTime_calc = ReadPackFloat(hPack);
	CloseHandle(hPack);

	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient)==false)
		return Plugin_Stop;

	//experimental, remove annoying double-playback
	int iViewModel = GetEntDataEnt2(iClient, g_iOffset_ViewModel);
	SetEntDataFloat(iViewModel, g_iOffset_LayerStartTime, flStartTime_calc, true);
	
	//PrintToChatAll("\x03- end SoH mag loader, iClient \x01%i\x03 starttime \x01%f\x03 gametime \x01%f", iClient, flStartTime_calc, GetGameTime());

	return Plugin_Stop;
}


//called for autoshotguns
Action SoH_AutoshotgunStart(Handle timer, any iEntid2)
{
	// //----DEBUG----
	// PrintToChatAll("\x03-autoshotgun detected, iEntid \x01%i\x03, startO \x01%i\x03, insertO \x01%i\x03, endO \x01%i",
	// 	iEntid,
	// 	g_iOffset_ReloadStartDuration,
	// 	g_iOffset_ReloadInsertDuration,
	// 	g_iOffset_ReloadEndDuration
	// 	);
	// PrintToChatAll("\x03- pre mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
	// 	g_flSoHAutoS,
	// 	g_flSoHAutoI,
	// 	g_flSoHAutoE
	// 	);

	if (iEntid2 <= 0 || IsValidEntity(iEntid2) == false)
		return Plugin_Stop;
				
	//then we set the new times in the gun
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadStartDuration,	g_flSoHAutoS*g_fReloadRate,	true);
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadInsertDuration,	g_flSoHAutoI*g_fReloadRate,	true);
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadEndDuration,	g_flSoHAutoE*g_fReloadRate,	true);

	//we change the playback rate of the gun
	//just so the player can "see" the gun reloading faster
	SetEntDataFloat(iEntid2, g_iOffset_PlaybackRate, 1.0/g_fReloadRate, true);

	//and then call a timer to periodically check whether the
	//gun is still reloading or not to reset the animation
	//but first check the reload state; if it's 2, then it
	//needs a pump/cock before it can shoot again, and thus
	//needs more time
	if (GetEntData(iEntid2,g_iOffset_ReloadState)==2)
		CreateTimer(0.3,SoH_ShotgunEndCock,iEntid2,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	else
		CreateTimer(0.3,SoH_ShotgunEnd,iEntid2,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	
	/*PrintToChatAll("\x03- after mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHAutoS,
		g_flSoHAutoI,
		g_flSoHAutoE
		);*/

	return Plugin_Continue;
}


Action SoH_SpasShotgunStart(Handle timer, any iEntid2)
{
	// PrintToChatAll("\x03-autoshotgun detected, iEntid \x01%i\x03, startO \x01%i\x03, insertO \x01%i\x03, endO \x01%i",
	// 	iEntid,
	// 	g_iOffset_ReloadStartDuration,
	// 	g_iOffset_ReloadInsertDuration,
	// 	g_iOffset_ReloadEndDuration
	// 	);
	// PrintToChatAll("\x03- pre mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
	// 	g_flSoHSpasS,
	// 	g_flSoHSpasI,
	// 	g_flSoHSpasE
	// 	);

	if (iEntid2 <= 0 || IsValidEntity(iEntid2) == false)
		return Plugin_Stop;
	
	//then we set the new times in the gun
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadStartDuration,	g_flSoHSpasS*g_fReloadRate,	true);
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadInsertDuration,	g_flSoHSpasI*g_fReloadRate,	true);
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadEndDuration,		g_flSoHSpasE*g_fReloadRate,	true);

	//we change the playback rate of the gun
	//just so the player can "see" the gun reloading faster
	SetEntDataFloat(iEntid2, g_iOffset_PlaybackRate, 1.0/g_fReloadRate, true);

	//and then call a timer to periodically check whether the
	//gun is still reloading or not to reset the animation
	//but first check the reload state; if it's 2, then it
	//needs a pump/cock before it can shoot again, and thus
	//needs more time
	if (GetEntData(iEntid2,g_iOffset_ReloadState)==2)
		CreateTimer(0.3,SoH_ShotgunEndCock,iEntid2,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	else
		CreateTimer(0.3,SoH_ShotgunEnd,iEntid2,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

	/*PrintToChatAll("\x03- after mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHSpasS,
		g_flSoHSpasI,
		g_flSoHSpasE
		);*/

	return Plugin_Stop;
}

//called for pump shotguns
Action SoH_PumpshotgunStart(Handle timer, any iEntid2)
{
	// PrintToChatAll("\x03-pumpshotgun detected, iEntid \x01%i\x03, startO \x01%i\x03, insertO \x01%i\x03, endO \x01%i",
	// 	iEntid,
	// 	g_iOffset_ReloadStartDuration,
	// 	g_iOffset_ReloadInsertDuration,
	// 	g_iOffset_ReloadEndDuration
	// 	);
	// PrintToChatAll("\x03- pre mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
	// 	g_flSoHPumpS,
	// 	g_flSoHPumpI,
	// 	g_flSoHPumpE
	// 	);

	if (iEntid2 <= 0 || IsValidEntity(iEntid2) == false)
		return Plugin_Stop;

	//then we set the new times in the gun
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadStartDuration,	g_flSoHPumpS*g_fReloadRate,	true);
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadInsertDuration,	g_flSoHPumpI*g_fReloadRate,	true);
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadEndDuration,		g_flSoHPumpE*g_fReloadRate,	true);

	//we change the playback rate of the gun
	//just so the player can "see" the gun reloading faster
	SetEntDataFloat(iEntid2, g_iOffset_PlaybackRate, 1.0/g_fReloadRate, true);

	//and then call a timer to periodically check whether the
	//gun is still reloading or not to reset the animation
	if (GetEntData(iEntid2,g_iOffset_ReloadState)==2)
		CreateTimer(0.3,SoH_ShotgunEndCock,iEntid2,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	else
		CreateTimer(0.3,SoH_ShotgunEnd,iEntid2,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	
	/*PrintToChatAll("\x03- after mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHPumpS,
		g_flSoHPumpI,
		g_flSoHPumpE
		);*/

	return Plugin_Stop;
}

//this resets the playback rate on shotguns
Action SoH_ShotgunEnd(Handle timer, any iEntid2)
{
	//PrintToChatAll("\x03-autoshotgun tick");

	if (iEntid2 <= 0 || IsValidEntity(iEntid2)==false)
		return Plugin_Stop;

	if (GetEntData(iEntid2, g_iOffset_ReloadState)==0)
	{
		//PrintToChatAll("\x03-shotgun end reload detected");
		SetEntDataFloat(iEntid2, g_iOffset_PlaybackRate, 1.0, true);

		float flTime=GetGameTime()+0.2;

		if (HasEntProp(iEntid2, Prop_Data, "m_hOwner") == false)
			return Plugin_Stop;

		int iClient = GetEntPropEnt(iEntid2,Prop_Data,"m_hOwner");
		if (RunClientChecks(iClient) == false || IsPlayerAlive(iClient) == false)
			return Plugin_Stop;

		SetEntDataFloat(iClient,	g_iOffset_NextAttack,	flTime,	true);
		SetEntDataFloat(iEntid2,	g_iOffset_TimeWeaponIdle,	flTime,	true);
		SetEntDataFloat(iEntid2,	g_iOffset_NextPrimaryAttack,	flTime,	true);

		return Plugin_Stop;
	}

	return Plugin_Continue;
}

//since cocking requires more time, this function does
//exactly as the above, except it adds slightly more time
Action SoH_ShotgunEndCock(Handle timer, any iEntid2)
{
	//PrintToChatAll("\x03-autoshotgun tick");

	if (iEntid2 <= 0 || IsValidEntity(iEntid2)==false)
		return Plugin_Stop;

	if (GetEntData(iEntid2,g_iOffset_ReloadState)==0)
	{
		//PrintToChatAll("\x03-shotgun end reload + cock detected");

		SetEntDataFloat(iEntid2, g_iOffset_PlaybackRate, 1.0, true);

		int iClient = GetEntPropEnt(iEntid2,Prop_Data,"m_hOwner");
		if (RunClientChecks(iClient) == false || IsPlayerAlive(iClient) == false)
			return Plugin_Stop;

		float flTime= GetGameTime() + 0.6;
		SetEntDataFloat(iClient,	g_iOffset_NextAttack,	flTime,	true);
		SetEntDataFloat(iEntid2,	g_iOffset_TimeWeaponIdle,	flTime,	true);
		SetEntDataFloat(iEntid2,	g_iOffset_NextPrimaryAttack,	flTime,	true);

		return Plugin_Stop;
	}
	return Plugin_Continue;
}
