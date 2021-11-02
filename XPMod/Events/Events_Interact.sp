
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
	// PrintToChatAll("Event_UseTarget");
	return Plugin_Continue;
}

Action:Event_PlayerUse(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//PrintToChatAll("Event_PlayerUse");

	int iClient = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	if(RunClientChecks(iClient) == false || g_iClientTeam[iClient] != TEAM_SURVIVORS || IsPlayerAlive(iClient) == false)
		return Plugin_Continue;

	int iTargetID = GetEventInt(hEvent,"targetid");

	if (IsValidEntity(iTargetID) == false)
		return Plugin_Continue;

	EventsPlayerUse_Ellis(iClient, iTargetID);
	EventsPlayerUse_Nick(iClient, iTargetID);
	EventsPlayerUse_Louis(iClient, iTargetID);

	return Plugin_Continue;
}

Action:Event_ItemPickUp(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId( GetEventInt(hEvent,"userid"));
	if (RunClientChecks(iClient) == false || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		IsPlayerAlive(iClient) == false)
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
		(StrContains(weaponclass, "rifle", false) != -1 || StrContains(weaponclass, "shotgun", false) != -1 ||
		StrContains(weaponclass, "smg", false) != -1 || StrContains(weaponclass, "sniper", false) != -1 || 
		StrContains(weaponclass, "grenade", false) != -1))
	{

		RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");

		g_iLaserUpgradeCounter[iClient]++;
	}
	else if (g_bTalentsConfirmed[iClient] &&
		g_iLouisTalent2Level[iClient] > 0 &&
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
	if(g_iChosenSurvivor[iClient] == ELLIS)
	{
		EventsItemPickUp_Ellis(iClient, weaponclass);
	}
	else if(g_iChosenSurvivor[iClient] == NICK)	
	{
		EventsItemPickUp_Nick(iClient, weaponclass);
	}
	else if(g_iChosenSurvivor[iClient] == LOUIS)
	{
		EventsItemPickUp_Louis(iClient, weaponclass);
	}

	// If the player picked up X number of lasers, then run a clean up to prevent server slowness
	if (g_iLaserUpgradeCounter[iClient] > WEAPON_PROXIMITY_CLEAN_UP_TRIGGER_ITEM_PICKUP_COUNT)
	{
		RunCloseProximityWeaponCleanUp();
		g_iLaserUpgradeCounter[iClient] = 0;
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
				KillEntitySafely(iProp);
			}
		}
	}
	if(g_iWeaponsLevel[iClient] == 5)
	{
		if(g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY || g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY)
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
				g_iEllisPrimarySavedClipSlot0[iClient] = GetEntProp(iProp, Prop_Data, "m_iClip1");
				//g_iEllisPrimarySavedAmmoSlot0[iClient] = GetEntProp(iProp, Prop_Send, "m_iExtraPrimaryAmmo");
				//g_iEllisPrimarySavedAmmoSlot0[iClient] = GetEntData(iProp, iOffset_Ammo + 12,w iAmmo);
				//PrintToChatAll("g_iEllisPrimarySavedClipSlot0 %d", g_iEllisPrimarySavedClipSlot0[iClient]);
				//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot0 %d", g_iEllisPrimarySavedAmmoSlot0[iClient]);
				//g_iEllisPrimarySavedAmmoSlot0[iClient] = GetEntProp(iProp, Prop_Data, iOffset_Ammo2);
				//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot0 %d", g_iEllisPrimarySavedAmmoSlot0[iClient]);
				//g_iEllisPrimarySavedAmmoSlot0[iClient] = GetEntProp(iProp, Prop_Data, iOffset_Ammo3);
				//PrintToChatAll("g_iEllisPrimarySavedAmmoSlot0 %d", g_iEllisPrimarySavedAmmoSlot0[iClient]);

				KillEntitySafely(iProp);
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
		// PrintToChatAll("Saving dropped pistol ammo");
		// PrintToChatAll("ClipSlot1 on drop w drop pistol = %d", g_iNickSecondarySavedClipSlot1[iClient]);
	}
	if((g_iRiskyLevel[iClient] == 5) && (g_bIsNickInSecondaryCycle[iClient] == false) && (StrEqual(droppeditem, "pistol", false) == true))
	{
		KillEntitySafely(iProp);
	}
	//g_bIsNickInSecondaryCycle[iClient] == true
	
}
