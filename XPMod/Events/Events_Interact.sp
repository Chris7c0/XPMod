
Action:Event_WeaponPickUp(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	
	// PrintToChatAll("Event_WeaponPickUp");
	// new iWeaponID = GetEventInt(hEvent,"weaponid");
	// new iWeaponSlot = GetEventInt(hEvent,"weaponslot");
	// PrintToChatAll("iWeaponID = %d", iWeaponID);
	// PrintToChatAll("iWeaponSlot = %d", iWeaponSlot);
	// PrintToChatAll("Picking up a weapon");
	
	return Plugin_Continue;
}

Action:Event_SpawnerGiveItem(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	// PrintToChatAll("Event_SpawnerGiveItem");

	return Plugin_Continue;
}

Action:Event_UseTarget(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToChatAll("Event_UseTarget");
	return Plugin_Continue;
}

Action:Event_PlayerUse(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToChatAll("Event_PlayerUse");
	return Plugin_Continue;
}

Action:Event_ItemPickUp(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	int iUserID = GetEventInt(hEvent,"userid")
	new iClient = GetClientOfUserId(iUserID);
	if(RunClientChecks(iClient) == false || g_iClientTeam[iClient] != TEAM_SURVIVORS || IsPlayerAlive(iClient) == false)
		return Plugin_Continue;
	
	decl String:weaponclass[24];
	GetEventString(hEvent,"item",weaponclass,24);

	// if (IsFakeClient(iClient) == false)
	// 	PrintToChatAll("%N %i: Event_ItemPickUp: %s", iClient, iClient, weaponclass);
	
	new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
	if (RunEntityChecks(ActiveWeaponID) == false)
		return Plugin_Continue;
	new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
	new ClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");

	// if (IsFakeClient(iClient) == false)
	// 	PrintToChatAll("%N %i: ActiveWeaponID: %i", iClient, iClient, ActiveWeaponID);
	
	//PrintToChatAll("ClipSize = %d", GetEntProp(GetPlayerWeaponSlot(iClient, 1),Prop_Data,"m_iClip1"));
	if((StrEqual(weaponclass, "chainsaw", false) == true) && (g_iHighestLeadLevel > 0) && (ClipAmmo == 30))
	{
		SetEntData(ActiveWeaponID, g_iOffset_Clip1, ClipAmmo + (g_iHighestLeadLevel * 3), true);
	}
	if(g_bClientIsReloading[iClient] == true)
	{
		g_bCoachShotgunForceReload[iClient] = false;
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
	
	// if (IsFakeClient(iClient) == false)
	// 	PrintToChatAll("%N %i: g_iLaserUpgradeCounter: %i", iClient, iClient, g_iLaserUpgradeCounter[iClient]);

	// Automatic laser site upgrades
	if (g_bTalentsConfirmed[iClient] &&
		(g_iWeaponsLevel[iClient] > 0 || g_iPromotionalLevel[iClient] > 0) && 
		g_iLaserUpgradeCounter[iClient] < 10 &&
		(StrContains(weaponclass, "rifle", false) != -1 || StrContains(weaponclass, "shotgun", false) != -1 ||
		StrContains(weaponclass, "smg", false) != -1 || StrContains(weaponclass, "sniper", false) != -1 || 
		StrContains(weaponclass, "grenade", false) != -1))
	{

		RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");

		g_iLaserUpgradeCounter[iClient]++;
	}
	else if (g_bTalentsConfirmed[iClient] &&
		g_iLouisTalent2Level[iClient] > 0 && 
		g_iLaserUpgradeCounter[iClient] < 10 &&
		StrContains(weaponclass, "smg", false) != -1)
	{
		RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");

		g_iLaserUpgradeCounter[iClient]++;
	}
	
	if(g_iChosenSurvivor[iClient] == BILL)
	{
		if(g_iPromotionalLevel[iClient] > 0)
		{
			if (StrContains(weaponclass,"rifle",false) != -1)
			{
				if (StrContains(weaponclass,"CSniperRifle",false) == -1 && StrContains(weaponclass,"hunting_rifle",false) == -1 && StrContains(weaponclass,"m60",false) == -1)
				{
					new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
					if(iEntid  < 1)
						return Plugin_Continue;
					if(IsValidEntity(iEntid)==false)
						return Plugin_Continue;
					//PrintToChatAll("iEntid!=-1 and is valid entry");
					new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
					g_iClientPrimaryClipSize[iClient] = clip;
					SetEntData(iEntid, g_iOffset_Clip1, clip + (g_iPromotionalLevel[iClient] * 20), true);
					//new iOffset_Ammo=FindDataMapInfo(iClient,"m_iAmmo");
					clip = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
					SetEntData(iClient, iOffset_Ammo + 12, clip - (g_iPromotionalLevel[iClient] * 20));
				}
			}
		}
	}
	else if(g_iChosenSurvivor[iClient] == ROCHELLE)	//Rochelle
	{
		if(g_iSilentLevel[iClient]>0)
		{
			new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
			if(iEntid < 1)					//Changed to this was:   if(iEntid == -1)
				return Plugin_Continue;
			if(IsValidEntity(iEntid)==false)
				return Plugin_Continue;
			new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
			//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
			decl iAmmo;
			
			if (StrContains(weaponclass,"hunting_rifle",false) != -1)	//Rugar
			{
				if(clip > (17 - (g_iSilentLevel[iClient] * 2)))
				{
					iAmmo = GetEntData(iClient, iOffset_Ammo + 36);	//for huntingrifle (+36)
					SetEntData(iEntid, g_iOffset_Clip1, 17 - (g_iSilentLevel[iClient]*2), true);
					SetEntData(iClient, iOffset_Ammo + 36, iAmmo + (g_iSilentLevel[iClient]*2) + 2);
				}
			}
			else if (StrContains(weaponclass,"sniper_military",false) != -1)
			{
				iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for other snipers (+40)
				if(iAmmo >= (g_iClientPrimaryClipSize[iClient] + (g_iSilentLevel[iClient] * 6)))
				{
					SetEntData(iEntid, g_iOffset_Clip1, 30 + (g_iSilentLevel[iClient]*6), true);
					SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iSilentLevel[iClient]*6));
				}
			}
			else if (StrContains(weaponclass,"sniper_scout",false) != -1)
			{
				if(clip > (15 - g_iSilentLevel[iClient]))
				{
					iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for other snipers (+40)
					SetEntData(iEntid, g_iOffset_Clip1, clip - g_iSilentLevel[iClient], true);
					SetEntData(iClient, iOffset_Ammo + 40, iAmmo + g_iSilentLevel[iClient]);
				}
			}
			else if (StrContains(weaponclass,"sniper_awp",false) != -1)
			{
				iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for other snipers (+40)
				if(clip > 1)
				{
					SetEntData(iEntid, g_iOffset_Clip1, 3, true);
					SetEntData(iClient, iOffset_Ammo + 40, iAmmo + 17);
				}
			}
		}
	}
	if(g_iChosenSurvivor[iClient] == COACH)		//Coach
	{
		if(g_iSprayLevel[iClient] > 0)
		{
			if (StrContains(weaponclass,"shotgun",false) != -1)
			{
				new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(iEntid < 1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				clip += (g_iSprayLevel[iClient]*2);
				//new iOffset_Ammo=FindDataMapInfo(iClient,"m_iAmmo");
				new ammoamountpsg = GetEntData(iClient, iOffset_Ammo + 28);	//for pump shotgun (+28)
				new ammoamountasg = GetEntData(iClient, iOffset_Ammo + 32);	//for auto shotgun (+32)
				if(ammoamountpsg > 0)
				{
					if(clip > 7)
						if(ammoamountpsg>(g_iSprayLevel[iClient]*2))
						{
							SetEntData(iEntid, g_iOffset_Clip1, clip, true);
							SetEntData(iClient, iOffset_Ammo + 28, ammoamountpsg - (g_iSprayLevel[iClient]*2));
						}
				}
				else if(ammoamountasg > 0)
				{
					if(clip > 9)
						if(ammoamountasg > (g_iSprayLevel[iClient]*2))
						{
							SetEntData(iEntid, g_iOffset_Clip1, clip, true);
							SetEntData(iClient, iOffset_Ammo + 32, ammoamountasg - (g_iSprayLevel[iClient]*2));
						}
				}
				SetEntData(iEntid, g_iOffset_Clip1, clip, true);
			}
		}
		if(g_iStrongLevel[iClient] > 0)
		{
			if((StrContains(weaponclass, "vomitjar", false) != -1) || (StrContains(weaponclass, "molotov", false) != -1) || (StrContains(weaponclass, "pipe_bomb", false) != -1))
			{
				if(g_bIsCoachGrenadeFireCycling[iClient] == false)
				{
					if(g_bIsCoachInGrenadeCycle[iClient] == true)
					{
						g_bIsCoachInGrenadeCycle[iClient] = false;
					}
					else if(g_bIsCoachInGrenadeCycle[iClient] == false)
					{
						if((StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1) || (StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1) || (StrContains(g_strCoachGrenadeSlot3, "empty", false) != -1))
						{
							if(g_iStrongLevel[iClient] == 3 || g_iStrongLevel[iClient] == 4)
							{
								if(StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1)
								{
									g_iCoachCurrentGrenadeSlot[iClient] = 0;
									if(StrEqual(weaponclass, "vomitjar", false) == true)
									{
										g_strCoachGrenadeSlot1 = "weapon_vomitjar";
									}
									else if(StrEqual(weaponclass, "molotov", false) == true)
									{
										g_strCoachGrenadeSlot1 = "weapon_molotov";
									}
									else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
									{
										g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
									}
								}
								else if(StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1)
								{
									g_iCoachCurrentGrenadeSlot[iClient] = 1;
									if(StrEqual(weaponclass, "vomitjar", false) == true)
									{
										g_strCoachGrenadeSlot2 = "weapon_vomitjar";
									}
									else if(StrEqual(weaponclass, "molotov", false) == true)
									{
										g_strCoachGrenadeSlot2 = "weapon_molotov";
									}
									else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
									{
										g_strCoachGrenadeSlot2 = "weapon_pipe_bomb";
									}
								}
							}
							else if(g_iStrongLevel[iClient] == 5)
							{
								if(StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1)
								{
									g_iCoachCurrentGrenadeSlot[iClient] = 0;
									if(StrEqual(weaponclass, "vomitjar", false) == true)
									{
										g_strCoachGrenadeSlot1 = "weapon_vomitjar";
									}
									else if(StrEqual(weaponclass, "molotov", false) == true)
									{
										g_strCoachGrenadeSlot1 = "weapon_molotov";
									}
									else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
									{
										g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
									}
								}
								else if(StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1)
								{
									g_iCoachCurrentGrenadeSlot[iClient] = 1;
									if(StrEqual(weaponclass, "vomitjar", false) == true)
									{
										g_strCoachGrenadeSlot2 = "weapon_vomitjar";
									}
									else if(StrEqual(weaponclass, "molotov", false) == true)
									{
										g_strCoachGrenadeSlot2 = "weapon_molotov";
									}
									else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
									{
										g_strCoachGrenadeSlot2 = "weapon_pipe_bomb";
									}
								}
								else if(StrContains(g_strCoachGrenadeSlot3, "empty", false) != -1)
								{
									g_iCoachCurrentGrenadeSlot[iClient] = 2;
									if(StrEqual(weaponclass, "vomitjar", false) == true)
									{
										g_strCoachGrenadeSlot3 = "weapon_vomitjar";
									}
									else if(StrEqual(weaponclass, "molotov", false) == true)
									{
										g_strCoachGrenadeSlot3 = "weapon_molotov";
									}
									else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
									{
										g_strCoachGrenadeSlot3 = "weapon_pipe_bomb";
									}
								}
							}
							else
							{
								g_iCoachCurrentGrenadeSlot[iClient] = 0;
								if(StrEqual(weaponclass, "vomitjar", false) == true)
								{
									g_strCoachGrenadeSlot1 = "weapon_vomitjar";
								}
								else if(StrEqual(weaponclass, "molotov", false) == true)
								{
									g_strCoachGrenadeSlot1 = "weapon_molotov";
								}
								else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
								{
									g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
								}
							}
						}
						else
						{
							if(g_iCoachCurrentGrenadeSlot[iClient] == 0)
							{
								if(StrEqual(weaponclass, "vomitjar", false) == true)
								{
									g_strCoachGrenadeSlot1 = "weapon_vomitjar";
								}
								else if(StrEqual(weaponclass, "molotov", false) == true)
								{
									g_strCoachGrenadeSlot1 = "weapon_molotov";
								}
								else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
								{
									g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
								}
							}
							else if(g_iCoachCurrentGrenadeSlot[iClient] == 1)
							{
								if(StrEqual(weaponclass, "vomitjar", false) == true)
								{
									g_strCoachGrenadeSlot2 = "weapon_vomitjar";
								}
								else if(StrEqual(weaponclass, "molotov", false) == true)
								{
									g_strCoachGrenadeSlot2 = "weapon_molotov";
								}
								else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
								{
									g_strCoachGrenadeSlot2 = "weapon_pipe_bomb";
								}
							}
							else if(g_iCoachCurrentGrenadeSlot[iClient] == 2)
							{
								if(StrEqual(weaponclass, "vomitjar", false) == true)
								{
									g_strCoachGrenadeSlot3 = "weapon_vomitjar";
								}
								else if(StrEqual(weaponclass, "molotov", false) == true)
								{
									g_strCoachGrenadeSlot3 = "weapon_molotov";
								}
								else if(StrEqual(weaponclass, "pipe_bomb", false) == true) 
								{
									g_strCoachGrenadeSlot3 = "weapon_pipe_bomb";
								}
							}
						}
					}
				}
			}
		}
	}
	if(g_iChosenSurvivor[iClient] == ELLIS)		//Ellis
	{
		if(g_iMetalLevel[iClient]>0 || g_iFireLevel[iClient]>0)
		{
			//PrintToChat(iClient, "%s", weaponclass);
			if (StrContains(weaponclass,"rifle",false) != -1 || StrContains(weaponclass,"smg",false) != -1 || StrContains(weaponclass,"sub",false) != -1 || StrContains(weaponclass,"sniper",false) != -1)
			{
				//PrintToChatAll("Inside smg rifle etc.");
				new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(iEntid < 1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				//PrintToChatAll("iEntid!=-1 and is valid entry");
				new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				g_iClientPrimaryClipSize[iClient] = clip;
				SetEntData(iEntid, g_iOffset_Clip1, clip + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6), true);
				//new iOffset_Ammo=FindDataMapInfo(iClient,"m_iAmmo");
				clip = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
				SetEntData(iClient, iOffset_Ammo + 12, clip - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
				clip = GetEntData(iClient, iOffset_Ammo + 20);	//for smg (+20)
				SetEntData(iClient, iOffset_Ammo + 20, clip - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
				clip = GetEntData(iClient, iOffset_Ammo + 32);	//for huntingrifle (+32)
				SetEntData(iClient, iOffset_Ammo + 32, clip - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
				clip = GetEntData(iClient, iOffset_Ammo + 36);	//for huntingrifle2? (+36)
				SetEntData(iClient, iOffset_Ammo + 36, clip - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
			}
			/*else if(StrContains(weaponclass,"gren",false) != -1)
			{
				new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(iEntid==-1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				g_iClientPrimaryClipSize[iClient] = clip;
				new iOffset_Ammo=FindDataMapInfo(iClient,"m_iAmmo");
				iAmmo = GetEntData(iClient, iOffset_Ammo + 64);
				SetEntData(iEntid, g_iOffset_Clip1, clip + g_iFireLevel[iClient], true);
				SetEntData(iClient, iOffset_Ammo + 64, iAmmo - g_iFireLevel[iClient]);
			}*/
		}
		if(g_iWeaponsLevel[iClient] == 5)
		{
			//PrintToChatAll("Weapons level is = 5, continuing");
			if((StrContains(weaponclass,"shotgun",false) != -1) || (StrContains(weaponclass,"rifle",false) != -1) || (StrContains(weaponclass,"smg",false) != -1) || (StrContains(weaponclass,"sniper",false) != -1) || (StrContains(weaponclass,"launcher",false) != -1))
			{
				//PrintToChatAll("Picked up weapon qualifies, continuing");
				//PrintToChatAll("g_bIsEllisCyclingEmptyWeapon = %d", g_bIsEllisCyclingEmptyWeapon[iClient]);
				if(g_bIsEllisCyclingEmptyWeapon[iClient] == true)
				{
					//PrintToChatAll("Cycling empty weapon, setting ammo");
					fnc_DeterminePrimaryWeapon(iClient);
					fnc_SetAmmo(iClient);
					fnc_SetAmmoUpgrade(iClient);
					g_bIsEllisCyclingEmptyWeapon[iClient] = false;
				}
				if((StrEqual(g_strEllisPrimarySlot1, "empty", false) == true) && (StrEqual(g_strEllisPrimarySlot2, "empty", false) == true))
				{
					//new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
					//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
					new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
					if(g_iEllisCurrentPrimarySlot[iClient] == 0)
					{
						if((StrEqual(weaponclass, "rifle", false) == true) || (StrEqual(weaponclass, "rifle_ak47", false) == true) || (StrEqual(weaponclass, "rifle_sg552", false) == true) || (StrEqual(weaponclass, "rifle_desert", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "smg", false) == true) || (StrEqual(weaponclass, "smg_mp5", false) == true) || (StrEqual(weaponclass, "smg_silenced", false) == true) || (StrEqual(weaponclass, "rifle_desert", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "pumpshotgun", false) == true) || (StrEqual(weaponclass, "shotgun_chrome", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "autoshotgun", false) == true) || (StrEqual(weaponclass, "shotgun_spas", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "sniper_military", false) == true) || (StrEqual(weaponclass, "sniper_awp", false) == true) || (StrEqual(weaponclass, "sniper_scout", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "rifle_m60", false) == true)
						{
							//new iAmmo = GetEntData(iClient, iOffset_Ammo);
							g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
						}
					}
					else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
					{
						if((StrEqual(weaponclass, "rifle", false) == true) || (StrEqual(weaponclass, "rifle_ak47", false) == true) || (StrEqual(weaponclass, "rifle_sg552", false) == true) || (StrEqual(weaponclass, "rifle_desert", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "smg", false) == true) || (StrEqual(weaponclass, "smg_mp5", false) == true) || (StrEqual(weaponclass, "smg_silenced", false) == true) || (StrEqual(weaponclass, "rifle_desert", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "pumpshotgun", false) == true) || (StrEqual(weaponclass, "shotgun_chrome", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "autoshotgun", false) == true) || (StrEqual(weaponclass, "shotgun_spas", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if((StrEqual(weaponclass, "sniper_military", false) == true) || (StrEqual(weaponclass, "sniper_awp", false) == true) || (StrEqual(weaponclass, "sniper_scout", false) == true))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
						}
						else if(StrEqual(weaponclass, "rifle_m60", false) == true)
						{
							//new iAmmo = GetEntData(iClient, iOffset_Ammo);
							g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
							g_iEllisPrimarySavedAmmoSlot2[iClient] = 0;
						}
					}
				}
				if(g_bIsEllisInPrimaryCycle[iClient] == true)
				{
					fnc_DeterminePrimaryWeapon(iClient);
					fnc_SetAmmo(iClient);
					fnc_SetAmmoUpgrade(iClient);
					/*
					if(g_iEllisCurrentPrimarySlot[iClient] == 0)
					{
						if(StrEqual(weaponclass, "autoshotgun", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 68, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 36, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "pumpshotgun", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_ak47", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_desert", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_m60", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							//SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_sg552", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "shotgun_chrome", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "shotgun_spas", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "smg", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "smg_mp5", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "smg_silenced", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_awp", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_military", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_scout", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot1[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot1[iClient]);
						}
					}
					else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
					{
						if(StrEqual(weaponclass, "autoshotgun", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 68, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 36, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "pumpshotgun", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_ak47", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_desert", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_m60", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							//SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "rifle_sg552", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 12, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "shotgun_chrome", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 28, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "shotgun_spas", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 32, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "smg", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "smg_mp5", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "smg_silenced", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 20, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_awp", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_military", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
						else if(StrEqual(weaponclass, "sniper_scout", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iEllisPrimarySavedClipSlot2[iClient], true);
							SetEntData(iClient, iOffset_Ammo + 40, g_iEllisPrimarySavedAmmoSlot2[iClient]);
						}
					}
					*/
					g_bIsEllisInPrimaryCycle[iClient] = false;
				}
				/*
				if((StrContains(g_strEllisPrimarySlot1, "empty", false) != -1) && if(StrContains(g_strEllisPrimarySlot2, "empty", false) != -1))
				{
					if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if(StrEqual(currentweapon, "weapon_hunting_rifle", false) == true)
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(currentweapon, "weapon_sniper_military", false) == true) || (StrEqual(currentweapon, "weapon_sniper_awp", false) == true) || (StrEqual(currentweapon, "weapon_sniper_scout", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if(StrEqual(currentweapon, "weapon_grenade_launcher", false) == true)
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if(StrEqual(currentweapon, "weapon_rifle_m60", false) == true)
					{
						//new iAmmo = GetEntData(iClient, iOffset_Ammo);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
					}
				}
				*/
				if(StrContains(g_strEllisPrimarySlot1, "empty", false) != -1)
				{
					//PrintToChatAll("Filling a primary slot");
					g_iEllisCurrentPrimarySlot[iClient] = 0;
					if(StrEqual(weaponclass, "autoshotgun", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_autoshotgun";
					}
					else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_grenade_launcher";
					}
					else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_hunting_rifle";
					}
					else if(StrEqual(weaponclass, "pumpshotgun", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_pumpshotgun";
					}
					else if(StrEqual(weaponclass, "rifle", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_rifle";
					}
					else if(StrEqual(weaponclass, "rifle_ak47", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_rifle_ak47";
						//PrintToChatAll("Saved %s", g_strEllisPrimarySlot1);
					}
					else if(StrEqual(weaponclass, "rifle_desert", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_rifle_desert";
					}
					else if(StrEqual(weaponclass, "rifle_m60", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_rifle_m60";
					}
					else if(StrEqual(weaponclass, "rifle_sg552", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_rifle_sg552";
					}
					else if(StrEqual(weaponclass, "shotgun_chrome", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_shotgun_chrome";
					}
					else if(StrEqual(weaponclass, "shotgun_spas", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_shotgun_spas";
					}
					else if(StrEqual(weaponclass, "smg", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_smg";
					}
					else if(StrEqual(weaponclass, "smg_mp5", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_smg_mp5";
					}
					else if(StrEqual(weaponclass, "smg_silenced", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_smg_silenced";
					}
					else if(StrEqual(weaponclass, "sniper_awp", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_sniper_awp";
					}
					else if(StrEqual(weaponclass, "sniper_military", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_sniper_military";
					}
					else if(StrEqual(weaponclass, "sniper_scout", false) == true)
					{
						g_strEllisPrimarySlot1 = "weapon_sniper_scout";
					}
				}
				else if(StrContains(g_strEllisPrimarySlot2, "empty", false) != -1)
				{
					g_iEllisCurrentPrimarySlot[iClient] = 1;
					if(StrEqual(weaponclass, "autoshotgun", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_autoshotgun";
					}
					else if(StrEqual(weaponclass, "grenade_launcher", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_grenade_launcher";
					}
					else if(StrEqual(weaponclass, "hunting_rifle", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_hunting_rifle";
					}
					else if(StrEqual(weaponclass, "pumpshotgun", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_pumpshotgun";
					}
					else if(StrEqual(weaponclass, "rifle", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_rifle";
					}
					else if(StrEqual(weaponclass, "rifle_ak47", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_rifle_ak47";
					}
					else if(StrEqual(weaponclass, "rifle_desert", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_rifle_desert";
					}
					else if(StrEqual(weaponclass, "rifle_m60", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_rifle_m60";
					}
					else if(StrEqual(weaponclass, "rifle_sg552", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_rifle_sg552";
					}
					else if(StrEqual(weaponclass, "shotgun_chrome", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_shotgun_chrome";
					}
					else if(StrEqual(weaponclass, "shotgun_spas", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_shotgun_spas";
					}
					else if(StrEqual(weaponclass, "smg", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_smg";
					}
					else if(StrEqual(weaponclass, "smg_mp5", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_smg_mp5";
					}
					else if(StrEqual(weaponclass, "smg_silenced", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_smg_silenced";
					}
					else if(StrEqual(weaponclass, "sniper_awp", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_sniper_awp";
					}
					else if(StrEqual(weaponclass, "sniper_military", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_sniper_military";
					}
					else if(StrEqual(weaponclass, "sniper_scout", false) == true)
					{
						g_strEllisPrimarySlot2 = "weapon_sniper_scout";
					}
				}
			}
		}
	}
	else if(g_iChosenSurvivor[iClient] == NICK)	//Nick
	{
		if(g_bRamboModeActive[iClient] == true)
		{
			//PrintToChatAll("Picked up weapon with rambo mode active, running fnc_DeterminePrimaryWeapon");
			fnc_DeterminePrimaryWeapon(iClient);
			if(StrEqual(g_strCurrentWeapon, "weapon_rifle_m60", false) == false)
			{
				//PrintToChatAll("fnc_DeterminePrimaryWeapon showed the primary weapon is not the m60");
				fnc_SetAmmo(iClient);
				fnc_SetAmmoUpgrade(iClient);
				//PrintToChatAll("Ammo was set via weapon pickup");
				fnc_ClearSavedWeaponData(iClient);
				g_bRamboModeActive[iClient] = false;
			}
		}
		/*
		if(g_bRamboModeActive[iClient] == true)
		{
			//PrintToChatAll("Picked up weapon with rambo mode active, running fnc_DeterminePrimaryWeapon");
			fnc_DeterminePrimaryWeapon(iClient);
			if(StrEqual(g_strCurrentWeapon, "weapon_rifle_m60", false) == false)
			{
				//PrintToChatAll("fnc_DeterminePrimaryWeapon showed the primary weapon is not the m60");
				fnc_SetAmmo(iClient);
				fnc_SetAmmoUpgrade(iClient);
				//PrintToChatAll("Ammo was set via weapon pickup");
				fnc_ClearSavedWeaponData(iClient);
				g_bRamboModeActive[iClient] = false;
			}
		}
		*/
		//PrintToChat(iClient, "%s", weaponclass);
		if(g_iMagnumLevel[iClient]>0 || g_iRiskyLevel[iClient]>0)	//gives 68 with magnum pickup on loadout spawn
		{
			if (StrContains(weaponclass,"magnum",false) != -1)
			{
				new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(iEntid < 1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				SetEntData(iEntid, g_iOffset_Clip1, 3, true);
			}
			else if(StrContains(weaponclass,"pistol",false) != -1)
			{
				new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(iEntid < 1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				if(clip == 15)
				{
					SetEntData(iEntid, g_iOffset_Clip1, clip + (g_iRiskyLevel[iClient] * 6), true);
				}
				else if(clip == 30)
				{
					SetEntData(iEntid, g_iOffset_Clip1, clip + (g_iRiskyLevel[iClient] * 12), true);
				}
			}
		}
		/*
		if(g_iNicksRamboWeaponID[iClient] > 0)
		{
			if(StrContains(weaponclass,"m60",false) != -1)
			{
				//Set ammo to 250
				new wID = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(wID < 1)
					return Plugin_Continue;
				if(IsValidEntity(wID)==false)
					return Plugin_Continue;
				if(IsValidEntity(wID))
					SetEntData(wID, g_iOffset_Clip1, 250, true);
			}
		}
		*/
		if(g_iRiskyLevel[iClient] == 5 && g_bTalentsConfirmed[iClient] == true)
		{
			
			// PrintToChatAll("ClipSlot1 on pickup w slot undetermined = %d", g_iNickSecondarySavedClipSlot1[iClient]);
			// new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			// PrintToChatAll("Current Clip Ammo on Pickup = %d", CurrentClipAmmo);
			// PrintToChatAll("Current weaponclass on Pickup = %s", weaponclass);
			
			if((StrContains(weaponclass,"pistol",false) != -1) || (StrContains(weaponclass,"melee",false) != -1) || (StrContains(weaponclass,"chainsaw",false) != -1))
			{
				if(g_bIsNickInSecondaryCycle[iClient] == true)
				{
					if(g_iNickCurrentSecondarySlot[iClient] == 0)
					{
						if(StrEqual(weaponclass, "pistol_magnum", false) == true)
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iNickSecondarySavedClipSlot1[iClient], true);
							//PrintToChatAll("Setting slot 1 clip ammo to %d", g_iNickSecondarySavedClipSlot1[iClient]);
						}
					}
					else if((g_iNickCurrentSecondarySlot[iClient] == 1) && (StrEqual(weaponclass, "pistol", false) == true))
					{
						CreateTimer(0.1, TimerNickDualClipSize, iClient, TIMER_FLAG_NO_MAPCHANGE);
						//PrintToChatAll("Setting slot 2 clip ammo to %d", g_iNickSecondarySavedClipSlot2[iClient]);
						//PrintToChatAll("ClipSlot1 on pickup w slot 1 = %d", g_iNickSecondarySavedClipSlot1[iClient]);
					}
					g_bIsNickInSecondaryCycle[iClient] = false;
				}
				else if(g_bIsNickInSecondaryCycle[iClient] == false)
				{
					if(((StrContains(weaponclass,"melee",false) != -1) || (StrContains(weaponclass,"chainsaw",false) != -1)) && (StrEqual(g_strNickSecondarySlot1, "weapon_pistol_magnum", false) == true) && (g_iNickCurrentSecondarySlot[iClient] == 1))
					{
						//PrintToChatAll("Picked up melee with magnum saved in slot 1");
						decl Float:wepvorigin[3], Float:vangles[3], Float:vdir[3];
						GetClientEyeAngles(iClient, vangles);
						GetAngleVectors(vangles, vdir, NULL_VECTOR, NULL_VECTOR);
						vangles[0] = 0.0;
						vangles[2] = 0.0;
						GetClientAbsOrigin(iClient, wepvorigin);
						wepvorigin[0]+=(vdir[0] * 30.0);
						wepvorigin[1]+=(vdir[1] * 30.0);
						wepvorigin[2]+=(vdir[2] * 50.0);
						new weapon = CreateEntityByName("weapon_pistol_magnum");
						DispatchKeyValue(weapon, "ammo", "200");
						DispatchSpawn(weapon);
						TeleportEntity(weapon, wepvorigin, vangles, NULL_VECTOR);
					}
					//PrintToChatAll("Cycle is false");
					g_iNickCurrentSecondarySlot[iClient] = 0;
					//PrintToChatAll("Cycle false, weaponclass = %s", weaponclass);
					//PrintToChatAll("Cycle false, g_strNickSecondarySlot1 = %s", g_strNickSecondarySlot1);
					
					// if(StrContains(weaponclass, "chainsaw", false) != -1)
					// {
					// 	SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iNickSecondarySavedClipSlot1[iClient], true);
					// 	PrintToChatAll("Setting chainsaw clip ammo to %d", g_iNickSecondarySavedClipSlot1[iClient]);
					// }
					
					if((StrEqual(weaponclass, "pistol_magnum", false) == true) && (StrEqual(g_strNickSecondarySlot1, "weapon_pistol_magnum", false) == true))
					{
						//PrintToChatAll("weaponclass and slot 1 are both magnum");

						RunCheatCommand(iClient, "give", "give pistol_magnum");
					}
					if(StrContains(g_strNickSecondarySlot1, "empty", false) != -1)
					{
						//PrintToChatAll("Slot 1 is empty");
						//g_iNickCurrentSecondarySlot[iClient] = 0;
						if(StrEqual(weaponclass, "pistol_magnum", false) == true)
						{
							g_strNickSecondarySlot1 = "weapon_pistol_magnum";
							//PrintToChatAll("Slot 1 = %s", g_strNickSecondarySlot1);
						}
						else if(StrEqual(weaponclass, "pistol", false) == true)
						{
							g_strNickSecondarySlot1 = "weapon_pistol";
						}
						else if(StrContains(weaponclass,"melee",false) != -1)
						{
							g_strNickSecondarySlot1 = "weapon_melee";
						}
						else if(StrContains(weaponclass,"chainsaw",false) != -1)
						{
							g_strNickSecondarySlot1 = "weapon_chainsaw";
						}
					}
				}
				if(g_iNickCurrentSecondarySlot[iClient] == 0)
				{
					if(StrEqual(weaponclass, "pistol", false) == true)
					{
						g_iNickCurrentSecondarySlot[iClient] = 1;

						RunCheatCommand(iClient, "give", "give pistol");
						RunCheatCommand(iClient, "give", "give pistol");
						CreateTimer(0.1, TimerNickDualClipSize, iClient, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
	}
	else if(g_iChosenSurvivor[iClient] == LOUIS)
	{
		if (g_iLouisTalent2Level[iClient] > 0)
		{
			//PrintToChat(iClient, "LOUIS ITEM PICKUP %s", weaponclass);
			if (StrContains(weaponclass, "smg", false) != -1)
			{
				new iEntid = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
				if(iEntid  < 1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				

				new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
				SetEntData(iClient, iOffset_Ammo + 20, iAmmo - (g_iLouisTalent2Level[iClient] * 10));
				
				new iCurrentClipAmmo = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				SetEntData(iEntid, g_iOffset_Clip1, iCurrentClipAmmo + (g_iLouisTalent2Level[iClient] * 10), true);
				g_iClientPrimaryClipSize[iClient] = iCurrentClipAmmo + (g_iLouisTalent2Level[iClient] * 10);
			}
			else if (StrEqual(weaponclass, "pistol", false) == true)
			{
				new iEntid = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
				if(iEntid  < 1)
					return Plugin_Continue;
				if(IsValidEntity(iEntid)==false)
					return Plugin_Continue;
				
				new iCurrentClipAmmo = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				SetEntData(iEntid, g_iOffset_Clip1, iCurrentClipAmmo + (g_iLouisTalent2Level[iClient] * 10), true);
			}
		}
	}
	return Plugin_Continue;
}

Action:Event_WeaponDropped(Handle:hEvent, const String:strName[], bool:bDontBroadcast)		//When an item is removed from a survivor's inventory///////////////////////
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	decl String:droppeditem[32];
	GetEventString(hEvent, "item", droppeditem, 32);
	new iProp = GetEventInt(hEvent,"propid");
	// PrintToChatAll("droppeditem = %s", droppeditem);
	if(g_iStrongLevel[iClient] > 0)
	{
		if((StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1) || (StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1) || (StrContains(g_strCoachGrenadeSlot3, "empty", false) != -1))
		{
			if((StrContains(droppeditem, "pipe_bomb", false) != -1) || (StrContains(droppeditem, "molotov", false) != -1) || (StrContains(droppeditem, "vomitjar", false) != -1))
			{
				AcceptEntityInput(iProp, "Kill");
			}
		}
	}
	if(g_iWeaponsLevel[iClient] == 5)
	{
		if((StrContains(g_strEllisPrimarySlot1, "empty", false) != -1) || (StrContains(g_strEllisPrimarySlot2, "empty", false) != -1))
		{
			if((StrContains(droppeditem,"shotgun",false) != -1) || (StrContains(droppeditem,"rifle",false) != -1) || (StrContains(droppeditem,"smg",false) != -1) || (StrContains(droppeditem,"sniper",false) != -1) || (StrContains(droppeditem,"launcher",false) != -1))
			{
				//PrintToChatAll("Attempting to save dropped ammo...");
				//new targetgun = GetPlayerWeaponSlot(iClient, 0);
				//new iAmmoOffset = FindDataMapInfo(client, "m_iAmmo");
				//GetEntProp(targetgun, Prop_Data, "m_iExtraPrimaryAmmo", 4);
				//SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
				//new iOffset_Ammo = FindDataMapInfo(iProp,"m_iAmmo");
				//new iOffset_Ammo2 = FindDataMapInfo(droppeditem,"m_iAmmo");
				//new iOffset_Ammo3 = FindDataMapInfo(iProp,"m_iAmmo");
				//new iAmmo = GetEntData(iProp, iOffset_Ammo + 12);
				//PrintToChatAll("Attempting to save dropped ammo...");
				g_iEllisPrimarySavedClipSlot1[iClient] = GetEntProp(iProp, Prop_Data, "m_iClip1");
				//g_iEllisPrimarySavedAmmoSlot1[iClient] = GetEntProp(iProp, Prop_Send, "m_iExtraPrimaryAmmo");
				//g_iEllisPrimarySavedAmmoSlot1[iClient] = GetEntData(iProp, iOffset_Ammo + 12, iAmmo);
				//PrintToChatAll("g_iEllisPrimarySavedClipSlot1 %d", g_iEllisPrimarySavedClipSlot1[iClient]);
				//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot1 %d", g_iEllisPrimarySavedAmmoSlot1[iClient]);
				//g_iEllisPrimarySavedAmmoSlot1[iClient] = GetEntProp(iProp, Prop_Data, iOffset_Ammo2);
				//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot1 %d", g_iEllisPrimarySavedAmmoSlot1[iClient]);
				//g_iEllisPrimarySavedAmmoSlot1[iClient] = GetEntProp(iProp, Prop_Data, iOffset_Ammo3);
				//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot1 %d", g_iEllisPrimarySavedAmmoSlot1[iClient]);
				AcceptEntityInput(iProp, "Kill");
			}
		}
	}
	if((StrEqual(droppeditem, "pistol", false) == true) && (g_iRiskyLevel[iClient] == 5) && (g_bTalentsConfirmed[iClient] == true))
	{
		if(g_bNickStoresDroppedPistolAmmo[iClient] == true)
		{
			g_iNickSecondarySavedClipSlot2[iClient] = ((GetEntProp(iProp, Prop_Data, "m_iClip1") * 2));
		}
		else
		{
			g_bNickStoresDroppedPistolAmmo[iClient] = true;
		}
		//PrintToChatAll("Saving dropped pistol ammo");
		//PrintToChatAll("ClipSlot1 on drop w drop pistol = %d", g_iNickSecondarySavedClipSlot1[iClient]);
	}
	if((g_iRiskyLevel[iClient] == 5) && (g_bIsNickInSecondaryCycle[iClient] == false) && (StrEqual(droppeditem, "pistol", false) == true))
	{
		AcceptEntityInput(iProp, "Kill");
		AcceptEntityInput(iProp, "Kill");
		//PrintToChatAll("Killing nicks pistols");
	}
	//g_bIsNickInSecondaryCycle[iClient] == true
}
