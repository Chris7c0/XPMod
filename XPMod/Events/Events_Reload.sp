
/**************************************************************************************************************************
 *                                                   Reloading Event                                                      *
 **************************************************************************************************************************/

Event_WeaponReload(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToChatAll("Entered reload event...");
	new iClient = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	switch(g_iChosenSurvivor[iClient])
	{
		case 0:		//Bill
		{
		
		}
		case 1:		//Rochelle
		{
		
		}
		case 2:		//Coach
		{
		
		}
		case 3:		//Ellis
		{
			//PrintToChatAll("Started switch for Ellis...");
			fnc_DeterminePrimaryWeapon(iClient);
			fnc_SaveAmmo(iClient);
			//PrintToChatAll("Ended switch for Ellis...");
		}
		case 4:		//Nick
		{
		/*
			GetClientWeapon(iClient, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
			if((g_bCanNickStampedeReload[iClient] == true) && (StrEqual(g_strCurrentWeapon, "weapon_pistol_magnum", false) == true))
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
	}
	//PrintToChatAll("Beggining check for current weapon...");
	decl String:currentweapon[32];
	//PrintToChatAll("Weapon Reload");
	GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
	new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	
	if(iClient==0 || IsFakeClient(iClient)==true || g_iClientTeam[iClient] != TEAM_SURVIVORS)
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
		new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
		new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
		//g_iCoachShotgunIncreasedAmmo[iClient] = CurrentClipAmmo + 1;
		
		if(g_bCoachShotgunForceReload[iClient] == false)
		{
			g_iCoachShotgunSavedAmmo[iClient] = CurrentClipAmmo;
		}
		
	}
	*/
	if(g_iExorcismLevel[iClient]>0 || g_iPromotionalLevel[iClient]>0 || g_iFireLevel[iClient]>0 || g_iOverLevel[iClient]>0 || g_iWeaponsLevel[iClient]>0 || g_iMetalLevel[iClient]>0 || g_iMagnumLevel[iClient]>0 || g_iRiskyLevel[iClient]>0 || g_iSprayLevel[iClient]>0 || g_iSilentLevel[iClient]>0)
	{
		new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);//5565
		if (IsValidEntity(iEntid)==false)
			return;
		if(iEntid < 1) return;
		decl String:stClass[32];
		GetEntityNetClass(iEntid,stClass,32);
		//PrintToChatAll("\x03-class of gun: \x01%s",stClass );
		if (StrContains(stClass,"Grenade",false) != -1)
			return;
		
		g_fReloadRate = 1.0 - (float(g_iExorcismLevel[iClient]) * 0.09) - (float(g_iPromotionalLevel[iClient]) * 0.04) - (float(g_iFireLevel[iClient]) * 0.05) - (float(g_iWeaponsLevel[iClient]) * 0.05) - (float(g_iOverLevel[iClient]) * 0.04) - (float(g_iMetalLevel[iClient]) * 0.04);
		
		if(g_iRiskyLevel[iClient]>0)
		{
			if (StrContains(stClass,"cpistol",false) != -1)	//Just for pistol not magnum
				g_fReloadRate = 1.0 - (float(g_iRiskyLevel[iClient]) * 0.1);
		}
		else if(g_iSilentLevel[iClient]>0)
		{
			if(StrContains(stClass,"CSniperRifle",false) != -1)	//using Ruger Mini Sniper Rifle
				g_fReloadRate = 1.0 - (float(g_iSilentLevel[iClient]) * 0.08);
		}
		GetClientWeapon(iClient, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
		if((g_bCanNickStampedeReload[iClient] == true) && (StrEqual(g_strCurrentWeapon, "weapon_pistol_magnum", false) == true))
		{
			//PrintToChatAll("Stampede reloading...");
			//PrintToChatAll("Reload rate before %f", g_fReloadRate);
			g_fReloadRate = 1.0 - (g_iMagnumLevel[iClient] * 0.1);
			//PrintToChatAll("Reload rate after %f", g_fReloadRate);
			g_bCanNickStampedeReload[iClient] = false;
		}
		g_iNickMagnumShotCount[iClient] = 0;
		g_iNickMagnumShotCountCap[iClient] = 0;
		
		//PrintToChatAll("ReloadRate = %f", g_fReloadRate);
		new Handle:clientEntPack = CreateDataPack();
		WritePackCell(clientEntPack, iEntid);
		WritePackCell(clientEntPack, iClient);
		WritePackString(clientEntPack, stClass);
		if (StrContains(stClass,"shotgun",false) == -1)
		{
			g_fGameTime = GetGameTime(); 
			flNextTime_ret = GetEntDataFloat(iEntid,g_iOffset_NextPrimaryAttack);
				//this is a calculation of when the next primary attack
				//will be after applying sleight of hand values
				//NOTE: at this point, only calculate the interval itself,
				//without the actual game engine time factored in
			flNextTime_calc = ( flNextTime_ret - g_fGameTime ) * g_fReloadRate;

				//we change the playback rate of the gun
				//just so the player can "see" the gun reloading faster
			SetEntDataFloat(iEntid, g_iOffset_PlaybackRate, 1.0/g_fReloadRate, true);

				//create a timer to reset the playrate after
				//time equal to the modified attack interval

			CreateTimer(flNextTime_calc, SoH_MagEnd, clientEntPack, TIMER_FLAG_NO_MAPCHANGE);

			//experiment to remove double-playback bug
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, iClient);
			//this calculates the equivalent time for the reload to end
			//if the survivor didn't have the SoH perk
			new Float:flStartTime_calc = g_fGameTime - ( flNextTime_ret - g_fGameTime ) * ( 1 - g_fReloadRate ) ;
			WritePackFloat(hPack, flStartTime_calc);
			
			//now we create the timer that will prevent the annoying double playback
			//was 0.08
			if(rspeed > 1.0)
			{
				new Float:anispeed = FindAnimationSpeed(g_fReloadRate)//, stClass);
				CreateTimer(flNextTime_calc * anispeed, SoH_MagEnd2, hPack, TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				CreateTimer(flNextTime_calc * rspeed, SoH_MagEnd2, hPack, TIMER_FLAG_NO_MAPCHANGE);
			}
			
			//and finally we set the end reload time into the gun
			//so the player can actually shoot with it at the end
			flNextTime_calc += g_fGameTime;
			SetEntDataFloat(iEntid, g_iOffset_TimeWeaponIdle, flNextTime_calc, true);
			SetEntDataFloat(iEntid, g_iOffset_NextPrimaryAttack, flNextTime_calc, true);
			SetEntDataFloat(iClient, g_iOffset_NextAttack, flNextTime_calc, true);
		}
		else if (StrContains(stClass,"autoshotgun",false) != -1)
		{
			CreateTimer(0.1,SoH_AutoshotgunStart, clientEntPack, TIMER_FLAG_NO_MAPCHANGE);
			return;
		}

		else if (StrContains(stClass,"shotgun_spas",false) != -1)
		{
			CreateTimer(0.1,SoH_SpasShotgunStart,clientEntPack, TIMER_FLAG_NO_MAPCHANGE);
			return;
		}

		else if (StrContains(stClass,"pumpshotgun",false) != -1
			|| StrContains(stClass,"shotgun_chrome",false) != -1)
		{
			CreateTimer(0.1,SoH_PumpshotgunStart,clientEntPack, TIMER_FLAG_NO_MAPCHANGE);
			return;
		}
	}
	//PrintToChatAll("Reload Finished");
	return;
}

Float:FindAnimationSpeed(Float:reloadspeed) //, String:gunname[])
{
	decl Float:anispeed;
	anispeed = reloadspeed;
	return anispeed;
	/*
	decl Float:anispeed;
	anispeed = 0.1;
	if(reloadspeed == 0.86)
	{
		if(StrEqual(gunname, "CMagnumPistol"))		//Magnum
			anispeed = 0.65;
		else if(StrEqual(gunname, "CSniper_Military")) //H&K MSG90
			anispeed = 0.9;
		else if(StrEqual(gunname, "CSniperRifle"))	//Ruger Mini-14
			anispeed = 0.9;
		else if(StrEqual(gunname, "CRifle_Desert"))	//Scar-L
			anispeed = 0.8;
		else if(StrEqual(gunname, "CRifle_SG552"))	//Sig SG552
			anispeed = 1.0;
		else if(StrEqual(gunname, "CSMG_MP5"))		//MP5
			anispeed = 0.9;
		else if(StrEqual(gunname, "CSniper_AWP"))	//AWP
			anispeed = 0.8;
		else if(StrEqual(gunname, "CSniper_Scout"))	//Scout
			anispeed = 0.9;
		else
			anispeed = 0.7;		//Default
	}
	else if(reloadspeed == 0.72)
	{
		if(StrEqual(gunname, "CMagnumPistol"))		//Magnum
			anispeed = 0.5;
		else if(StrEqual(gunname, "CSniper_Military")) //H&K MSG90
			anispeed = 0.75;
		else if(StrEqual(gunname, "CSniperRifle"))	//Ruger Mini-14
			anispeed = 0.75;
		else if(StrEqual(gunname, "CRifle_Desert"))	//Scar-L
			anispeed = 0.79;
		else if(StrEqual(gunname, "CRifle_SG552"))	//Sig SG552
			anispeed = 0.9;
		else if(StrEqual(gunname, "CSMG_MP5"))		//MP5
			anispeed = 0.9;
		else if(StrEqual(gunname, "CSniper_AWP"))	//AWP
			anispeed = 0.72;
		else if(StrEqual(gunname, "CSniper_Scout"))	//Scout
			anispeed = 0.9;
		else
			anispeed = 0.6;		//Default
	}
	else if(reloadspeed > 0.579 && reloadspeed < 0.581)
	{
		if(StrEqual(gunname, "CMagnumPistol"))		//Magnum
			anispeed = 0.4;
		else if(StrEqual(gunname, "CSniper_Military")) //H&K MSG90
			anispeed = 0.72;
		else if(StrEqual(gunname, "CSniperRifle"))	//Ruger Mini-14
			anispeed = 0.72;
		else if(StrEqual(gunname, "CRifle_Desert"))	//Scar-L
			anispeed = 0.745;
		else if(StrEqual(gunname, "CRifle_SG552"))	//Sig SG552
			anispeed = 0.875;
		else if(StrEqual(gunname, "CSMG_MP5"))		//MP5
			anispeed = 0.9;
		else if(StrEqual(gunname, "CSniper_AWP"))	//AWP
			anispeed = 0.65;
		else if(StrEqual(gunname, "CSniper_Scout"))	//Scout
			anispeed = 0.9;
		else
			anispeed = 0.5;		//Default
	}
	else if(reloadspeed > 0.439 && reloadspeed < 0.441)
	{
		if(StrEqual(gunname, "CMagnumPistol"))		//Magnum
			anispeed = 0.25;
		else if(StrEqual(gunname, "CSniper_Military")) //H&K MSG90
			anispeed = 0.6;
		else if(StrEqual(gunname, "CSniperRifle"))	//Ruger Mini-14
			anispeed = 0.6;
		else if(StrEqual(gunname, "CRifle_Desert"))	//Scar-L
			anispeed = 0.615;
		else if(StrEqual(gunname, "CRifle_SG552"))	//Sig SG552
			anispeed = 0.85;
		else if(StrEqual(gunname, "CSMG_MP5"))		//MP5
			anispeed = 0.8;
		else if(StrEqual(gunname, "CSniper_AWP"))	//AWP
			anispeed = 0.6;
		else if(StrEqual(gunname, "CSniper_Scout"))	//Scout
			anispeed = 0.8;
		else
			anispeed = 0.4;		//Default
	}
	else if(reloadspeed == 0.3)
	{
		if(StrEqual(gunname, "CMagnumPistol"))		//Magnum
			anispeed = 0.0;
		else if(StrEqual(gunname, "CSniper_Military")) //H&K MSG90
			anispeed = 0.475;
		else if(StrEqual(gunname, "CSniperRifle"))	//Ruger Mini-14
			anispeed = 0.475;
		else if(StrEqual(gunname, "CRifle_Desert"))	//Scar-L
			anispeed = 0.5;
		else if(StrEqual(gunname, "CRifle_SG552"))	//Sig SG552
			anispeed = 0.815;
		else if(StrEqual(gunname, "CSMG_MP5"))		//MP5
			anispeed = 0.8;
		else if(StrEqual(gunname, "CSniper_AWP"))	//AWP
			anispeed = 0.5;
		else if(StrEqual(gunname, "CSniper_Scout"))	//Scout
			anispeed = 0.8;
		else
			anispeed = 0.125;		//Default
	}
	else if(reloadspeed > 0.259 && reloadspeed < 0.261)
	{
		if(StrEqual(gunname, "CMagnumPistol"))		//Magnum
			anispeed = 0.0;
		else if(StrEqual(gunname, "CSniper_Military")) //H&K MSG90
			anispeed = 0.35;
		else if(StrEqual(gunname, "CSniperRifle"))	//Ruger Mini-14
			anispeed = 0.35;
		else if(StrEqual(gunname, "CRifle_Desert"))	//Scar-L
			anispeed = 0.38;
		else if(StrEqual(gunname, "CRifle_SG552"))	//Sig SG552
			anispeed = 0.74;
		else if(StrEqual(gunname, "CSMG_MP5"))		//MP5
			anispeed = 0.7;
		else if(StrEqual(gunname, "CSniper_AWP"))	//AWP
			anispeed = 0.4;
		else if(StrEqual(gunname, "CSniper_Scout"))	//Scout
			anispeed = 0.7;
		else
			anispeed = 0.09;		//Default
	}
	else if(reloadspeed == 0.22)
	{
		if(StrEqual(gunname, "CMagnumPistol"))		//Magnum
			anispeed = 0.0;
		else if(StrEqual(gunname, "CSniper_Military")) //H&K MSG90
			anispeed = 0.25;
		else if(StrEqual(gunname, "CSniperRifle"))	//Ruger Mini-14
			anispeed = 0.25;
		else if(StrEqual(gunname, "CRifle_Desert"))	//Scar-L
			anispeed = 0.3;
		else if(StrEqual(gunname, "CRifle_SG552"))	//Sig SG552
			anispeed = 0.685;
		else if(StrEqual(gunname, "CSMG_MP5"))		//MP5
			anispeed = 0.7;
		else if(StrEqual(gunname, "CSniper_AWP"))	//AWP
			anispeed = 0.33;
		else if(StrEqual(gunname, "CSniper_Scout"))	//Scout
			anispeed = 0.7;
		else
			anispeed = 0.001;		//Default
	}
	else if(reloadspeed == 0.18)
	{
		if(StrEqual(gunname, "CMagnumPistol"))		//Magnum
			anispeed = 0.0;
		else if(StrEqual(gunname, "CSniper_Military")) //H&K MSG90
			anispeed = 0.1;
		else if(StrEqual(gunname, "CSniperRifle"))	//Ruger Mini-14
			anispeed = 0.1;
		else if(StrEqual(gunname, "CRifle_Desert"))	//Scar-L
			anispeed = 0.1;
		else if(StrEqual(gunname, "CRifle_SG552"))	//Sig SG552
			anispeed = 0.625;
		else if(StrEqual(gunname, "CSMG_MP5"))		//MP5
			anispeed = 0.6;
		else if(StrEqual(gunname, "CSniper_AWP"))	//AWP
			anispeed = 0.2;
		else if(StrEqual(gunname, "CSniper_Scout"))	//Scout
			anispeed = 0.6;
		else
			anispeed = 0.0;		//Default
	}
	else if(reloadspeed == 0.14)
	{
		if(StrEqual(gunname, "CMagnumPistol"))		//Magnum
			anispeed = 0.0;
		else if(StrEqual(gunname, "CSniper_Military")) //H&K MSG90
			anispeed = 0.00002;
		else if(StrEqual(gunname, "CSniperRifle"))	//Ruger Mini-14
			anispeed = 0.00002;
		else if(StrEqual(gunname, "CRifle_Desert"))	//Scar-L
			anispeed = 0.0;
		else if(StrEqual(gunname, "CRifle_SG552"))	//Sig SG552
			anispeed = 0.55;
		else if(StrEqual(gunname, "CSMG_MP5"))		//MP5
			anispeed = 0.45;
		else if(StrEqual(gunname, "CSniper_AWP"))	//AWP
			anispeed = 0.01;
		else if(StrEqual(gunname, "CSniper_Scout"))	//Scout
			anispeed = 0.45;
		else
			anispeed = 0.0;		//Default
	}
	else if(reloadspeed == 0.1)
	{
		if(StrEqual(gunname, "CMagnumPistol"))		//Magnum
			anispeed = 0.0;
		else if(StrEqual(gunname, "CSniper_Military")) //H&K MSG90
			anispeed = 0.0;
		else if(StrEqual(gunname, "CSniperRifle"))	//Ruger Mini-14
			anispeed = 0.0;
		else if(StrEqual(gunname, "CRifle_Desert"))	//Scar-L
			anispeed = 0.0;
		else if(StrEqual(gunname, "CRifle_SG552"))	//Sig SG552
			anispeed = 0.2;
		else if(StrEqual(gunname, "CSMG_MP5"))		//MP5
			anispeed = 0.3;
		else if(StrEqual(gunname, "CSniper_AWP"))	//AWP
			anispeed = 0.0;
		else if(StrEqual(gunname, "CSniper_Scout"))	//Scout
			anispeed = 0.3;
		else
			anispeed = 0.0;		//Default
	}
	
	//PrintToChatAll("gun: %s     rate: %f     returning %f", gunname, reloadspeed, anispeed);
	return anispeed;
	*/
}

//this resets the playback rate on non-shotguns
Action:SoH_MagEnd (Handle:timer, any:pack)
{
	if (IsServerProcessing()==false)
	{
		CloseHandle(pack);
		return Plugin_Stop;
	}
	ResetPack(pack);
	new iEntid2 = ReadPackCell(pack);
	new iClient = ReadPackCell(pack);
	if(IsClientInGame(iClient)==false)
	{
		CloseHandle(pack);
		return Plugin_Continue;
	}
	//----DEBUG----
	//PrintToChatAll("\x03SoH reset playback, magazine loader");

	if (iEntid2 <= 0 || IsValidEntity(iEntid2)==false)
	{
		CloseHandle(pack);
		return Plugin_Stop;
	}

	SetEntDataFloat(iEntid2, g_iOffset_PlaybackRate, 1.0, true);
	
	//CreateTimer(0.1,IncreaseClip, pack, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}


// Action:IncreaseClip(Handle:timer, any:pack)
// {
// /*
// if(IsFakeClient(attacker) == false)	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 	{
// 		if(g_iClientTeam[attacker] == TEAM_SURVIVORS)
// 		{
// 			if(g_iClientTeam[victim] == TEAM_INFECTED)//////////////////////////////////////////////////////////////////////
// 			switch(g_iChosenSurvivor[attacker])
// 			{
// 				case 0:		//Bill Talents
// 				{
// 					if(g_iExorcismLevel[attacker]!=0 || g_iPromotionalLevel[attacker]!=0)
// 					{
// 						if(g_iClientTeam[victim] == TEAM_INFECTED)
// 						{
// 							decl String:weaponclass[32];
// 							GetEventString(hEvent,"weapon",weaponclass,32);
// 							//PrintToChat(attacker, "weaponclass = %s", weaponclass);
// 							if(StrContains(weaponclass,"rifle",false) != -1)
// 							{
// 								if(StrContains(weaponclass,"rifle_m60",false) == -1)
// 								{
// 									if(StrContains(weaponclass,"hunting_rifle",false) == -1)
// 									{
// 										new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 										new dmg = GetEventInt(hEvent,"dmg_health");
// 										dmg = RoundToNearest(dmg * (g_iExorcismLevel[attacker] * 0.04));
// 										//PrintToChat(attacker, "Your doing %d extra rifle damage", dmg);
// 										SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
// 									}
// 								}
// 								else
// 								{
// 									new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 									new dmg = GetEventInt(hEvent,"dmg_health");
// 									dmg = RoundToNearest(dmg * (g_iPromotionalLevel[attacker] * 0.20));
// 									//PrintToChat(attacker, "Your doing %d extra M60 damage", dmg);
// 									SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
// 								}
// 							}
// 						}
// 					}
// 					//return Plugin_Continue;
// 				}
// 				case 1:		//Rochelle
// 				{
// 					if(g_iHunterLevel[attacker] > 0)
// 					{
// 						if(g_iClientTeam[victim] == TEAM_INFECTED)
// 							if(g_bIsRochellePoisoned[victim] == false)	//If player not g_bIsRochellePoisoned poison them
// 							{
// 								g_bIsRochellePoisoned[victim] = true;
								
// 								g_iSlapRunTimes[victim] = 5 - g_iHunterLevel[attacker];
// 								delete g_hTimer_RochellePoison[victim];
// 								g_hTimer_RochellePoison[victim] = CreateTimer(5.0, TimerPoison, victim, TIMER_REPEAT);
// 								g_iPID_RochellePoisonBullet[victim] = WriteParticle(victim, "poison_bullet", 0.0);
// 								CreateTimer(30.1, DeleteParticle, g_iPID_RochellePoisonBullet[victim], TIMER_FLAG_NO_MAPCHANGE);
								
// 								if(IsFakeClient(victim)==false)
// 									ShowHudOverlayColor(victim, 0, 100, 0, 40, 8000, FADE_IN);
								
// 								PrintHintText(attacker,"You poisoned %N", victim);
// 							}
// 					}
// 					if(g_iSilentLevel[attacker] >0)
// 					{
// 						if(g_iClientTeam[victim] == TEAM_INFECTED)
// 						{
// 							decl String:weaponclass[32];
// 							GetEventString(hEvent,"weapon",weaponclass,32);
// 							//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
// 							if(StrContains(weaponclass,"hunting_rifle",false) != -1)	//Rugar
// 							{
// 								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 								new dmg = GetEventInt(hEvent,"dmg_health");
// 								dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.13));
// 								//PrintToChat(attacker, "your doing %d hunting rifle damage", dmg);
// 								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
// 								//return Plugin_Continue;
// 							}
// 							else if(StrContains(weaponclass,"sniper_military",false) != -1)	//H&K MSG 90
// 							{
// 								IgniteEntity(victim, 5.0, false);
// 								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 								new dmg = GetEventInt(hEvent,"dmg_health");
// 								dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.08));
// 								//PrintToChat(attacker, "your doing %d sniper_military damage", dmg);
// 								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
// 								//return Plugin_Continue;
// 							}
// 							else if(StrContains(weaponclass,"sniper_scout",false) != -1)
// 							{
// 								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 								new dmg = GetEventInt(hEvent,"dmg_health");
// 								dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.13)) + (g_iSilentSorrowHeadshotCounter[attacker] * g_iSilentLevel[attacker] * 3);
// 								//PrintToChat(attacker, "your doing %d scout damage", dmg);
// 								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
// 								//return Plugin_Continue;
// 							}
// 							else if(StrContains(weaponclass,"sniper_awp",false) != -1)
// 							{
// 								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 								new dmg = GetEventInt(hEvent,"dmg_health");
// 								dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.40) );
// 								PrintToChat(attacker, "your doing %d extra awp damage", dmg);
// 								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
// 								//return Plugin_Continue;
// 							}
// 						}
// 					}
// 				}
// 				case 2:		//Coach
// 				{
// 					if(g_iClientTeam[victim] == TEAM_INFECTED)
// 					{
// 						if(g_iMeleeDamageCounter[attacker]>0 || g_iSprayLevel[attacker]>0 || g_bIsWreckingBallCharged[attacker]==true || g_bCoachRageIsActive[attacker] == true)
// 						{
// 							decl String:weaponclass[32];
// 							GetEventString(hEvent,"weapon",weaponclass,32);
// 							//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
// 							if(StrContains(weaponclass,"melee",false) != -1)
// 							{
// 								if(g_bIsWreckingBallCharged[attacker]==true)
// 								{
// 									if(g_iWreckingLevel[attacker] == 5)
// 									{
// 										g_bWreckingChargeRetrigger[attacker] = true;
// 										//PrintToChatAll("Wrecking Ball Retrigger = true");
// 									}
// 									g_bIsWreckingBallCharged[attacker] = false;
// 									new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 									//new dmg = GetEventInt(hEvent,"dmg_health");
// 									//PrintToChat(attacker, "predmg = %d", dmg);
// 									//dmg = (g_iWreckingLevel[attacker]*200) + (g_iMeleeDamageCounter[attacker]);
// 									CreateTimer(0.1, DeleteParticle, g_iPID_CoachMeleeCharge1[attacker], TIMER_FLAG_NO_MAPCHANGE);
// 									CreateTimer(0.1, DeleteParticle, g_iPID_CoachMeleeCharge2[attacker], TIMER_FLAG_NO_MAPCHANGE);
// 									//PrintToChat(attacker, "\x03[XPMod] \x05You did %d extra CHARGED melee damage", ((g_iWreckingLevel[attacker]*100) + (g_iMeleeDamageCounter[attacker])));
// 									new Float:vec[3];
// 									GetClientAbsOrigin(attacker, vec);
// 									EmitSoundToAll(SOUND_COACH_CHARGE_HIT, attacker, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
// 									//CreateParticle("coach_melee_charge_splash", 0.0, attacker, NO_ATTACH);
// 									WriteParticle(victim, "coach_melee_charge_splash", 3.0);
// 									SetEntProp(victim,Prop_Data,"m_iHealth", hp - ((g_iWreckingLevel[attacker]*100) + g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
// 								}
// 								else if(g_iMeleeDamageCounter[attacker]>0)
// 								{
// 									new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 									//new dmg = GetEventInt(hEvent,"dmg_health");
// 									//PrintToChat(attacker, "predmg = %d", dmg);
// 									//dmg = g_iMeleeDamageCounter[attacker];
// 									PrintToChat(attacker, "\x03[XPMod] \x05You did %d extra melee damage", (g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
// 									SetEntProp(victim,Prop_Data,"m_iHealth", hp - (g_iMeleeDamageCounter[attacker] + g_iCoachRageMeleeDamage[attacker]));
// 								}
// 								else if(g_bCoachRageIsActive[attacker] == true)
// 								{
// 									new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 									PrintToChat(attacker, "\x03[XPMod] \x05You did %d extra melee damage", g_iCoachRageMeleeDamage[attacker]);
// 									SetEntProp(victim,Prop_Data,"m_iHealth", hp - g_iCoachRageMeleeDamage[attacker]);
// 								}
// 							}
// 							if(g_iSprayLevel[attacker]>0)
// 								if(StrContains(weaponclass,"shotgun",false) != -1)
// 								{
// 									new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 									//new dmg = GetEventInt(hEvent,"dmg_health");
// 									//dmg = dmg + (g_iSprayLevel[attacker] * 2);
// 									//PrintToChat(attacker, "your doing %d shotgun damage", (g_iSprayLevel[attacker] * 2));
// 									SetEntProp(victim,Prop_Data,"m_iHealth", hp - (g_iSprayLevel[attacker] * 2));
// 								}
// 						}
// 						//return Plugin_Continue;
// 					}
// 				}
// 				case 3:		//Ellis Talents
// 				{
// 					if(g_iFireLevel[attacker]>0)
// 					{
// 						if(g_iClientTeam[victim] == TEAM_INFECTED)
// 						{
// 							if(g_bUsingFireStorm[attacker]==true)
// 							{
// 								new Float:time = (float(g_iFireLevel[attacker]) * 6.0);
// 								IgniteEntity(victim, time, false);
// 							}
// 						}
// 					}
// 					if(g_iOverLevel[attacker] > 0)
// 					{
// 						if(g_iClientTeam[victim] == TEAM_INFECTED)
// 						{
// 							new iCurrentHealth = GetEntProp(attacker,Prop_Data,"m_iHealth");
// 							new iMaxHealth = GetEntProp(attacker,Prop_Data,"m_iMaxHealth");
// 							new Float:fTempHealth = GetEntDataFloat(attacker, g_iOffset_HealthBuffer);
// 							if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
// 							{
// 								decl String:weaponclass[32];
// 								GetEventString(hEvent,"weapon",weaponclass,32);
// 								//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
// 								if((StrContains(weaponclass,"shotgun",false) != -1) || (StrContains(weaponclass,"rifle",false) != -1) || (StrContains(weaponclass,"pistol",false) != -1) || (StrContains(weaponclass,"smg",false) != -1) || (StrContains(weaponclass,"sniper",false) != -1) || (StrContains(weaponclass,"launcher",false) != -1))
// 								{
// 									new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 									new dmg = GetEventInt(hEvent,"dmg_health");
// 									new newdmg = (dmg + (g_iOverLevel[attacker] * 2));
// 									SetEntProp(victim,Prop_Data,"m_iHealth", hp - newdmg);
// 									//DeleteCode
// 									//PrintToChatAll("Ellis is doing %d damage", dmg);
// 									//PrintToChatAll("Ellis is doing %d additional damage", (newdmg - dmg));
// 								}
// 							}
// 						}
// 					}
// 							//Removed
// 							decl String:weaponclass[32];
// 							GetEventString(hEvent,"weapon",weaponclass,32);
// 							//PrintToChatAll("\x03-class of gun: \x01%s",weaponclass);
// 							if(StrContains(weaponclass,"hunting_rifle",false) != -1)	//Rugar
// 							{
// 								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 								new dmg = GetEventInt(hEvent,"dmg_health");
// 								dmg = RoundToNearest(dmg * (g_iSilentLevel[attacker] * 0.13));
// 								//PrintToChat(attacker, "your doing %d hunting rifle damage", dmg);
// 								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
// 								//return Plugin_Continue;
// 							}
// 							//Removed
// 				}
// 				case 4:		//Nick Talents
// 				{
// 					if(g_iSwindlerLevel[attacker] > 0)
// 					{
// 						if(g_iClientTeam[victim] == TEAM_INFECTED)
// 							if(g_bNickIsStealingLife[victim][attacker] == false)	//If player not poisoned, poison them
// 							{
// 								g_bNickIsStealingLife[victim][attacker] = true;
								
// 								new Handle:lifestealingpackage = CreateDataPack();
// 								WritePackCell(lifestealingpackage, victim);
// 								WritePackCell(lifestealingpackage, attacker);
								
// 								g_iNickStealingLifeRuntimes[victim] = 0;

// 								delete g_hTimer_NickLifeSteal[victim];
// 								g_hTimer_NickLifeSteal[victim] = CreateTimer(2.0, TimerLifeStealing, lifestealingpackage, TIMER_REPEAT);
								
// 								decl Float:vec[3];
// 								GetClientAbsOrigin(victim, vec);
// 								EmitSoundToAll(SOUND_NICK_LIFESTEAL_HIT, victim, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
// 							}
// 					}
// 					if(g_iDesperateLevel[attacker] > 0 && g_iNickDesperateMeasuresStack > 0)
// 					{
// 						decl String:weaponclass[32];
// 						GetEventString(hEvent,"weapon",weaponclass,32);
						
// 						if(StrContains(weaponclass,"melee",false) == -1 && StrContains(weaponclass,"inferno",false) == -1 && 
// 							StrContains(weaponclass,"pipe_bomb",false) == -1 && StrContains(weaponclass,"entityflame",false) == -1)
// 						{
// 							new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 							new dmg = GetEventInt(hEvent,"dmg_health");
// 							dmg = RoundToNearest(dmg * (g_iDesperateLevel[attacker] * 0.05) * g_iNickDesperateMeasuresStack);
// 							PrintToChat(attacker, "your doing %d extra damage", dmg);
// 							SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
// 						}
// 					}
// 					if(g_iMagnumLevel[attacker]>0 || g_iRiskyLevel[attacker]>0)
// 					{
// 						if(g_iClientTeam[victim] == TEAM_INFECTED)
// 						{
// 							decl String:wclass[32];
// 							GetEventString(hEvent,"weapon",wclass,32);
// 							if (StrContains(wclass,"magnum",false) != -1)
// 							{
// 								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 								new dmg = GetEventInt(hEvent,"dmg_health");
// 								dmg = RoundToNearest(dmg * (g_iMagnumLevel[attacker] * 0.75));
// 								//PrintToChat(attacker, "your doing %d extra magnum damage", dmg);
// 								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
// 							}
// 							else if (StrContains(wclass,"pistol",false) != -1)
// 							{
// 								new hp = GetEntProp(victim,Prop_Data,"m_iHealth");
// 								new dmg = GetEventInt(hEvent,"dmg_health");
// 								dmg = RoundToNearest(dmg * (g_iRiskyLevel[attacker] * 0.2));
// 								//PrintToChat(attacker, "your doing %d extra damage", dmg);
// 								SetEntProp(victim,Prop_Data,"m_iHealth", hp - dmg);
// 							}
// 							//return Plugin_Continue;
// 						}
// 					}
// 				}
// 			}
// */
// /*
// 	//new iClient = GetClientOfUserId(GetEventInt(hEvent,"userid"));
// 	ResetPack(pack);
// 	new iEntid2 = ReadPackCell(pack);
// 	if(IsValidEntity(iEntid2)==false)
// 		return Plugin_Continue;
// 	new iClient = ReadPackCell(pack);
// 	if(IsClientInGame(iClient)==false)
// 		return Plugin_Continue;
// 	decl String:wclass[32];
// 	ReadPackString(pack, wclass, sizeof(wclass));
// 	CloseHandle(pack);
// 	//PrintToChatAll("iClient: %d with gun class: %s", iClient, wclass);
// 	//if(iClient==0 || IsFakeClient(iClient)==true)
// 	//	return Plugin_Continue;
	
// 	iEntid2 = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);		//Might need(these two lines were commented out before)
// 	if((iEntid2 < 1) || IsValidEntity(iEntid2)==false)
// 		return Plugin_Continue;
// 	GetEntityNetClass(iEntid2,wclass,32);
	
// 	if(g_iChosenSurvivor[iClient]==0 || g_iChosenSurvivor[iClient]==3)	//if character is support or ELLIS
// 	{
// 		if (StrContains(wclass,"rifle",false) != -1 || StrContains(wclass,"smg",false) != -1 || StrContains(wclass,"sub",false) != -1 || StrContains(wclass,"sniper",false) != -1 || StrContains(wclass,"gren",false) != -1)
// 		{
// 			new clip = GetEntProp(iEntid2,Prop_Data,"m_iClip1");
// 			new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
			
// 			new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
// 			if(iAmmo >= (g_iClientPrimaryClipSize[iClient] + (g_iPromotionalLevel[iClient]*20) + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)))
// 			{
// 				SetEntData(iEntid2, g_iOffset_Clip1, (clip + (g_iPromotionalLevel[iClient]*20) + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
// 				SetEntData(iClient, iOffset_Ammo + 12, iAmmo - (g_iPromotionalLevel[iClient]*20) - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
// 			}
			
// 			iAmmo = GetEntData(iClient, iOffset_Ammo + 20);	//for smg (+20)
// 			if(iAmmo >= (g_iClientPrimaryClipSize[iClient]+(g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)))
// 			{
// 				SetEntData(iEntid2, g_iOffset_Clip1, clip + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6), true);
// 				SetEntData(iClient, iOffset_Ammo + 20, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
// 			}
			
// 			iAmmo = GetEntData(iClient, iOffset_Ammo + 32);	//for huntingrifle (+32)
// 			if(iAmmo >= (g_iClientPrimaryClipSize[iClient]+(g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)))
// 			{
// 				SetEntData(iEntid2, g_iOffset_Clip1, clip + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6), true);
// 				SetEntData(iClient, iOffset_Ammo + 32, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
// 			}
			
// 			iAmmo = GetEntData(iClient, iOffset_Ammo + 36);	//for huntingrifle2? (+36)
// 			if(iAmmo >= (g_iClientPrimaryClipSize[iClient]+(g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)))
// 			{
// 				SetEntData(iEntid2, g_iOffset_Clip1, clip + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6), true);
// 				SetEntData(iClient, iOffset_Ammo + 36, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
// 			}
// 			//iAmmo = GetEntData(iClient, iOffset_Ammo + 64);	//for grenadelanucher (+36)
// 			//if(iAmmo >= (g_iClientPrimaryClipSize[iClient] + g_iFireLevel[iClient]))
// 			//{
// 			//	SetEntData(iEntid2, g_iOffset_Clip1, clip + g_iFireLevel[iClient], true);
// 			//	SetEntData(iClient, iOffset_Ammo + 64, iAmmo - g_iFireLevel[iClient]);
// 		//}
// 		}
// 	}
// 	else if(g_iMagnumLevel[iClient]>0 || g_iRiskyLevel[iClient]>0)
// 	{
// 		iEntid2 = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
// 		if(IsValidEntity(iEntid2)==false)
// 			return Plugin_Continue;
// 		GetEntityNetClass(iEntid2,wclass,32);
// 		if (StrContains(wclass,"magnum",false) != -1)
// 		{
// 			//new clip1 = GetEntProp(iEntid2,Prop_Data,"m_iClip1");
// 			SetEntData(iEntid2, g_iOffset_Clip1, 8 - g_iMagnumLevel[iClient], true);
// 		}
// 		else if (StrContains(wclass,"cpistol",false) != -1)
// 		{
// 			new clip = GetEntProp(iEntid2,Prop_Data,"m_iClip1");
// 			SetEntData(iEntid2, g_iOffset_Clip1, clip + (g_iRiskyLevel[iClient] * 12), true);
// 		}
// 	}
// 	else if(g_iSilentLevel[iClient]>0)
// 	{
// 		new clip = GetEntProp(iEntid2,Prop_Data,"m_iClip1");
// 		new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
// 		decl iAmmo;
		
// 		if (StrContains(wclass,"CSniperRifle",false) != -1)	//Rugar
// 		{
// 			if(clip > (17 - (g_iSilentLevel[iClient]*2)))
// 			{
// 				iAmmo = GetEntData(iClient, iOffset_Ammo + 36);	//for huntingrifle (+36)
// 				SetEntData(iEntid2, g_iOffset_Clip1, 17 - (g_iSilentLevel[iClient] * 2), true);
// 				SetEntData(iClient, iOffset_Ammo + 36, iAmmo + (g_iSilentLevel[iClient]*2) + 2);
// 			}
// 		}
// 		else if (StrContains(wclass,"CSniper_Military",false) != -1)
// 		{
// 			iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for other snipers (+40)
// 			if(iAmmo >= (g_iClientPrimaryClipSize[iClient] + (g_iSilentLevel[iClient] * 6)))
// 			{
// 				SetEntData(iEntid2, g_iOffset_Clip1, 30 + (g_iSilentLevel[iClient] * 6), true);
// 				SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iSilentLevel[iClient] * 6));
// 			}
// 		}
// 		else if (StrContains(wclass,"CSniper_scout",false) != -1)
// 		{
// 			if(clip > (15 - g_iSilentLevel[iClient]))
// 			{
// 				iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for other snipers (+40)
// 				SetEntData(iEntid2, g_iOffset_Clip1, 15 - g_iSilentLevel[iClient], true);
// 				SetEntData(iClient, iOffset_Ammo + 40, iAmmo + g_iSilentLevel[iClient]);
// 			}
// 		}
// 		else if (StrContains(wclass,"CSniper_AWP",false) != -1)
// 		{
// 			iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for other snipers (+40)
// 			if(clip > 1)
// 			{
// 				SetEntData(iEntid2, g_iOffset_Clip1, 3, true);
// 				SetEntData(iClient, iOffset_Ammo + 40, iAmmo + 17);
// 			}
// 		}
// 	}
// 	*/
// 	return Plugin_Continue;
// }

Action:SoH_MagEnd2 (Handle:timer, Handle:hPack)
{
	if (IsServerProcessing()==false)
	{
		CloseHandle(hPack);
		return Plugin_Stop;
	}

	//----DEBUG----
	//PrintToChatAll("\x03SoH reset playback, magazine loader");

	ResetPack(hPack);
	new iCid2 = ReadPackCell(hPack);
	new Float:flStartTime_calc = ReadPackFloat(hPack);
	CloseHandle(hPack);

	if (iCid2 <= 0 || IsValidEntity(iCid2)==false)
		return Plugin_Stop;		

	//experimental, remove annoying double-playback
	new iVMid = GetEntDataEnt2(iCid2,g_iOffset_ViewModel);
	SetEntDataFloat(iVMid, g_iOffset_LayerStartTime, flStartTime_calc, true);
	
	//----DEBUG----
	//PrintToChatAll("\x03- end SoH mag loader, icid2 \x01%i\x03 starttime \x01%f\x03 gametime \x01%f", iCid2, flStartTime_calc, GetGameTime());

	return Plugin_Stop;
}


//called for autoshotguns
Action:SoH_AutoshotgunStart (Handle:timer, any:pack)
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
	ResetPack(pack);
	new iEntid2 = ReadPackCell(pack);

	if (iEntid2 <= 0 || IsValidEntity(iEntid2) == false)
		return Plugin_Stop;
				
	//then we set the new times in the gun
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadStartDuration,	g_flSoHAutoS*g_fReloadRate,	true);
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadInsertDuration,	g_flSoHAutoI*g_fReloadRate,	true);
	SetEntDataFloat(iEntid2,	g_iOffset_ReloadEndDuration,		g_flSoHAutoE*g_fReloadRate,	true);

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
		CreateTimer(0.3,SoH_ShotgunEnd,pack,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

	//----DEBUG----
	/*PrintToChatAll("\x03- after mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHAutoS,
		g_flSoHAutoI,
		g_flSoHAutoE
		);*/

	return Plugin_Continue;
}


Action:SoH_SpasShotgunStart (Handle:timer, any:pack)
{
	//----DEBUG----
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
	
	ResetPack(pack);
	new iEntid2 = ReadPackCell(pack);

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
		CreateTimer(0.3,SoH_ShotgunEnd,pack,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

	//----DEBUG----
	/*PrintToChatAll("\x03- after mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHSpasS,
		g_flSoHSpasI,
		g_flSoHSpasE
		);*/

	return Plugin_Stop;
}

//called for pump shotguns
Action:SoH_PumpshotgunStart (Handle:timer, any:pack)
{
	//----DEBUG----
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

	ResetPack(pack);
	new iEntid2 = ReadPackCell(pack);

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
		CreateTimer(0.3,SoH_ShotgunEnd,pack,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

	//----DEBUG----
	/*PrintToChatAll("\x03- after mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHPumpS,
		g_flSoHPumpI,
		g_flSoHPumpE
		);*/

	return Plugin_Stop;
}

//this resets the playback rate on shotguns
Action:SoH_ShotgunEnd (Handle:timer, any:pack)
{
	ResetPack(pack);
	new iEntid2 = ReadPackCell(pack);
	//----DEBUG----
	//PrintToChatAll("\x03-autoshotgun tick");

	if (iEntid2 <= 0 || IsValidEntity(iEntid2)==false)
	{
		CloseHandle(pack);
		return Plugin_Stop;
	}

	if (GetEntData(iEntid2,g_iOffset_ReloadState)==0)
	{
		//----DEBUG----
		//PrintToChatAll("\x03-shotgun end reload detected");
		SetEntDataFloat(iEntid2, g_iOffset_PlaybackRate, 1.0, true);
		new iClient = ReadPackCell(pack);
		CloseHandle(pack);
		new Float:flTime=GetGameTime()+0.2;

		if (RunClientChecks(iClient) == false)
			return Plugin_Stop;

		SetEntDataFloat(iClient,	g_iOffset_NextAttack,	flTime,	true);
		SetEntDataFloat(iEntid2,	g_iOffset_TimeWeaponIdle,	flTime,	true);
		SetEntDataFloat(iEntid2,	g_iOffset_NextPrimaryAttack,	flTime,	true);
		/*
		if(g_iSprayLevel[iClient]>0)
		{
			new clip = GetEntProp(iEntid2,Prop_Data,"m_iClip1");
			clip += (g_iSprayLevel[iClient]*2);
			new iOffset_Ammo=FindDataMapInfo(iClient,"m_iAmmo");
			new ammoamountpsg = GetEntData(iClient, iOffset_Ammo + 28);	//for pump shotgun (+28)
			new ammoamountasg = GetEntData(iClient, iOffset_Ammo + 32);	//for auto shotgun (+32)
			if(ammoamountpsg > 0)
			{
				if(clip > 7)
					if(ammoamountpsg>(g_iSprayLevel[iClient]*2))
					{
						SetEntData(iEntid2, g_iOffset_Clip1, clip, true);
						SetEntData(iClient, iOffset_Ammo + 28, ammoamountpsg - (g_iSprayLevel[iClient]*2));
					}
			}
			else if(ammoamountasg > 0)
			{
				if(clip > 9)
					if(ammoamountasg > (g_iSprayLevel[iClient]*2))
					{
						SetEntData(iEntid2, g_iOffset_Clip1, clip, true);
						SetEntData(iClient, iOffset_Ammo + 32, ammoamountasg - (g_iSprayLevel[iClient]*2));
					}
			}
		}
		*/

		return Plugin_Stop;
	}
	return Plugin_Continue;
}

//since cocking requires more time, this function does
//exactly as the above, except it adds slightly more time
Action:SoH_ShotgunEndCock (Handle:timer, any:iEntid2)
{
	//----DEBUG----
	//PrintToChatAll("\x03-autoshotgun tick");

	if (iEntid2 <= 0 || IsValidEntity(iEntid2)==false)
		return Plugin_Stop;

	if (GetEntData(iEntid2,g_iOffset_ReloadState)==0)
	{
		//----DEBUG----
		//PrintToChatAll("\x03-shotgun end reload + cock detected");

		SetEntDataFloat(iEntid2, g_iOffset_PlaybackRate, 1.0, true);
		//PrintToChatAll("SoH_ShotgunEndCock");
		new iCid2=GetEntPropEnt(iEntid2,Prop_Data,"m_hOwner");
		new Float:flTime= GetGameTime() + 1.0;
		SetEntDataFloat(iCid2,	g_iOffset_NextAttack,	flTime,	true);
		SetEntDataFloat(iEntid2,	g_iOffset_TimeWeaponIdle,	flTime,	true);
		SetEntDataFloat(iEntid2,	g_iOffset_NextPrimaryAttack,	flTime,	true);

		return Plugin_Stop;
	}
	return Plugin_Continue;
}