/**************************************************************************************************************************
 *                                                    On Game Frame                                                       *
 **************************************************************************************************************************/
 
public OnGameFrame()
{
	if (IsServerProcessing() == false)
		return;
	for(new iClient=1;iClient < MaxClients; iClient++)
	{		
		if(IsClientInGame(iClient)==false) continue;
		if(IsFakeClient(iClient)==true) continue;
		if(IsPlayerAlive(iClient)==false) continue;
		if(g_iClientTeam[iClient] == TEAM_SURVIVORS)		//Survivors OGF Talents
		{			
			if(g_bIsSmokeInfected[iClient] == true)
			{
				if(IsValidEntity(g_iSmokerInfectionCloudEntity[iClient]))
				{
					decl String:entclass[16];
					GetEntityNetClass(g_iSmokerInfectionCloudEntity[iClient], entclass, 16);
					if(StrEqual(entclass,"CSmokeStack",true) == true)
					{
						if(g_bIsSmokeEntityOff == true)
						{
							//DispatchKeyValue(g_iSmokerInfectionCloudEntity[iClient],"Rate", "30");
							decl Float:vorigin[3], Float:vangles[3], Float:vdir[3];
							GetClientEyeAngles(iClient, vangles);	//Get clients Eye Angles to know get what direction to spawn gun
							GetAngleVectors(vangles, vdir, NULL_VECTOR, NULL_VECTOR);	//Get the direction the iClient is looking
							vangles[0] = 0.0;		//Lock x and z axis
							vangles[2] = 0.0;
							GetClientEyePosition(iClient, vorigin);	//Get clients location origin vectors
							vorigin[0] += (vdir[0] * 1.0);		//Place the minigun infront of the players view
							vorigin[1] += (vdir[1] * 1.0);
							vorigin[2] -= 25.0;
							//vorigin[2] += vdir[2] + 1.0;			//Raise it up slightly to prevent glitches
							
							TeleportEntity(g_iSmokerInfectionCloudEntity[iClient], vorigin, NULL_VECTOR, NULL_VECTOR);
							
							AcceptEntityInput(g_iSmokerInfectionCloudEntity[iClient], "TurnOn");
							g_bIsSmokeEntityOff =  false;
						}
						else
						{
							//DispatchKeyValue(g_iSmokerInfectionCloudEntity[iClient],"Rate", "0");
							decl Float:vorigin[3], Float:vangles[3], Float:vdir[3];
							GetClientEyeAngles(iClient, vangles);	//Get clients Eye Angles to know get what direction to spawn gun
							GetAngleVectors(vangles, vdir, NULL_VECTOR, NULL_VECTOR);	//Get the direction the iClient is looking
							vangles[0] = 0.0;		//Lock x and z axis
							vangles[2] = 0.0;
							GetClientEyePosition(iClient, vorigin);	//Get clients location origin vectors
							vorigin[0] += (vdir[0] * 100.0);		//Place the minigun infront of the players view
							vorigin[1] += (vdir[1] * 100.0);
							vorigin[2] -= 25.0;
							//vorigin[2] += vdir[2] + 1.0;			//Raise it up slightly to prevent glitches
							
							TeleportEntity(g_iSmokerInfectionCloudEntity[iClient], vorigin, NULL_VECTOR, NULL_VECTOR);
							AcceptEntityInput(g_iSmokerInfectionCloudEntity[iClient], "TurnOff");
							g_bIsSmokeEntityOff = true;
						}
					}
				}
			}
			
			if(g_bIsSurvivorVomiting[iClient] == true)
			{
				new victim = GetClientAimTarget(iClient, true);
				if(victim > 0)
				{
					if(IsClientInGame(victim))
						if(IsPlayerAlive(victim))
							if(g_iClientTeam[victim] == TEAM_SURVIVORS)
							{
								decl Float:clientVec[3],Float:victimVec[3];
								GetClientEyePosition(iClient, clientVec);
								GetClientEyePosition(victim, victimVec);
								if(GetVectorDistance(clientVec, victimVec) <= 310.0)
									if(g_bIsSurvivorVomiting[victim] == false)
									{
										SDKCall(g_hSDK_VomitOnPlayer, victim, iClient, true);
										CreateParticle("boomer_vomit", 2.0, victim, ATTACH_MOUTH, true);
										g_bIsSurvivorVomiting[victim] = true;
										g_iShowSurvivorVomitCounter[victim] = 3;
										CreateTimer(1.0, TimerConstantVomitDisplay, victim, TIMER_FLAG_NO_MAPCHANGE);
									}
							}
				}
			}
			
			if(g_bGameFrozen == true)
			{
				new weapon = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(weapon > 0)
				{
					decl String:wclass[32];
					GetEntityNetClass(weapon,wclass,32);
					if((StrEqual(wclass,"CPainPills",false)==true) || (StrEqual(wclass,"CFirstAidKit",false)==true) || (StrEqual(wclass,"CItemDefibrillator",false)==true) || (StrEqual(wclass,"CItem_Adrenaline",false)==true))
					{
						ClientCommand(iClient, "slot0");
						ClientCommand(iClient, "slot2");
						PrintToChat(iClient, "\x03[XPMod]\x05 You cannot use health items when frozen");
					}
				}
			}
			
			//Handle Survivor On Game Frame Talents
			switch(g_iChosenSurvivor[iClient])
			{
				case BILL:		OnGameFrame_Bill(iClient);
				case ROCHELLE:	OnGameFrame_Rochelle(iClient);
				case COACH:		OnGameFrame_Coach(iClient);
				case ELLIS:		OnGameFrame_Ellis(iClient);
				case NICK:		OnGameFrame_Nick(iClient);
			}
			if(g_bClientIsReloading[iClient] == true)
			{
				g_iReloadFrameCounter[iClient]++;
				//PrintToChatAll("Frame counter %d", g_iReloadFrameCounter[iClient]);
				decl String:currentweapon[32];
				GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
				//PrintToChatAll("Current Weapon is %s", currentweapon);
				new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
				new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
				new iOffset_Ammo = FindDataMapOffs(iClient,"m_iAmmo");
				
				switch(g_iChosenSurvivor[iClient])
				{
					case 0:		//Bill Reload
					{
						//if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
						//if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo != 0))
						if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
							if(iAmmo >= (g_iPromotionalLevel[iClient]*20))
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iPromotionalLevel[iClient]*20)), true);
								SetEntData(iClient, iOffset_Ammo + 12, iAmmo - (g_iPromotionalLevel[iClient]*20));
								g_bClientIsReloading[iClient] = false;
								g_iReloadFrameCounter[iClient] = 0;
								//PrintToChatAll("Clip Set");
							}
							else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
							{
								new NewAmmo = ((g_iPromotionalLevel[iClient]*20) - iAmmo);
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iPromotionalLevel[iClient]*20) - NewAmmo)), true);
								SetEntData(iClient, iOffset_Ammo + 12, 0);
								g_bClientIsReloading[iClient] = false;
								g_iReloadFrameCounter[iClient] = 0;
								//PrintToChatAll("Clip Set");
							}
						}
					}
					case 1:		//Rochelle Reload
					{
						if((StrEqual(currentweapon, "weapon_hunting_rifle", false) == true) && (g_iSilentLevel[iClient] > 1) && (CurrentClipAmmo != 0))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);	//for hunting rifle (+36)
							if((iAmmo + CurrentClipAmmo) > (17 - (g_iSilentLevel[iClient] * 2)))
							{
								SetEntData(iClient, iOffset_Ammo + 36, iAmmo + (CurrentClipAmmo - (17 - (g_iSilentLevel[iClient] * 2))));
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, 17 - (g_iSilentLevel[iClient] * 2), true);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
						else if((StrEqual(currentweapon, "weapon_sniper_awp", false) == true) && (g_iSilentLevel[iClient] > 1) && (CurrentClipAmmo != 0))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
							if((iAmmo + CurrentClipAmmo) > 3)
							{
								SetEntData(iClient, iOffset_Ammo + 40, iAmmo + (CurrentClipAmmo - 3));
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, 3, true);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
						else if((StrEqual(currentweapon, "weapon_sniper_scout", false) == true) && (g_iSilentLevel[iClient] > 1) && (CurrentClipAmmo != 0))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
							if((iAmmo + CurrentClipAmmo) > (20 - g_iSilentLevel[iClient]))
							{
								SetEntData(iClient, iOffset_Ammo + 40, iAmmo + (CurrentClipAmmo - (20 - g_iSilentLevel[iClient])));
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (20 - g_iSilentLevel[iClient]), true);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
						else if((StrEqual(currentweapon, "weapon_sniper_military", false) == true) && (g_iSilentLevel[iClient] > 1) && (CurrentClipAmmo == 30))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
							if(iAmmo >= (g_iSilentLevel[iClient] * 6))
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iSilentLevel[iClient] * 6)), true);
								SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iSilentLevel[iClient] * 6));
							}
							else if(iAmmo < (g_iSilentLevel[iClient] * 6))
							{
								new NewAmmo = ((g_iSilentLevel[iClient] * 6) - iAmmo);
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iSilentLevel[iClient] * 6) - NewAmmo)), true);
								SetEntData(iClient, iOffset_Ammo + 40, 0);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
					}
					case 2:		//Coach Reload
					{
						if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true)) && (g_iSprayLevel[iClient] > 0))
						{
							/*
							if(g_bCoachShotgunForceReload[iClient] == true)
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iCoachShotgunSavedAmmo[iClient], true);
								//PrintToChatAll("g_iOffset_Clip1 %d", g_iOffset_Clip1);
								//PrintToChatAll("g_iCoachShotgunSavedAmmo %d", g_iCoachShotgunSavedAmmo[iClient]);
								g_bCoachShotgunForceReload[iClient] = false;
							}
							*/
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
							if(g_iReloadFrameCounter[iClient] == 1)
							{
								if(iAmmo >= ((8 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
								{
									SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, ((g_iSprayLevel[iClient] * 2) + 8) - CurrentClipAmmo, true);
									//PrintToChatAll("g_iOffset_ReloadNumShells");
								}
								else if(iAmmo < ((8 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
								{
									SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, iAmmo, true);
								}
							}
							if((CurrentClipAmmo == (8 + (g_iSprayLevel[iClient] * 2))) || (CurrentClipAmmo == (CurrentClipAmmo + iAmmo)))
							{
								g_bCoachShotgunForceReload[iClient] = false;
								g_bClientIsReloading[iClient] = false;
								g_iReloadFrameCounter[iClient] = 0;
								SetEntData(ActiveWeaponID, g_bOffset_InReload, 0, true);
								SetEntData(iClient, g_bOffset_InReload, 0, true);
							}
							//SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, 18, true);
							//SetEntData(ActiveWeaponID, g_iOffset_ShellsInserted, 1, true);
							//g_iOffset_ShellsInserted
							//new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);	//for pump shotguns (+28)
							/*
							if(g_iReloadFrameCounter[iClient] == 1)
							{
								new IncreasedClipAmmo = CurrentClipAmmo + 1;
							}
							*/
							
							// PrintToChatAll("Coach and shotgun detected");
							// if((CurrentClipAmmo == g_iCoachShotgunIncreasedAmmo[iClient]) && (g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) < (8 + g_iSprayLevel[iClient]))
							// {
							// 	g_iCoachShotgunAmmoCounter[iClient]++;
							// 	g_iCoachShotgunIncreasedAmmo[iClient] = CurrentClipAmmo + 1;
							// 	PrintToChatAll("Ammo Counter Increased = %d", g_iCoachShotgunAmmoCounter[iClient]);
							// }
							// else if((g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) == (8 + g_iSprayLevel[iClient]))
							// {
							// 	SetEntData(ActiveWeaponID, g_iOffset_Clip1, (g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]), true);
							// 	PrintToChatAll("Clip is full, setting clip size");
							// 	g_bClientIsReloading[iClient] = false;
							// 	g_iReloadFrameCounter[iClient] = 0;
							// }
							// if(CurrentClipAmmo <= 7 && ((g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) < (8 + g_iSprayLevel[iClient])))
							// {
							// 	SetEntData(ActiveWeaponID, g_iOffset_Clip1, 1, true);
							// 	//PrintToChatAll("Clip = 9 and Bullets < 18, CurrentClipAmmo = %d", CurrentClipAmmo);
							// 	g_iCoachShotgunIncreasedAmmo[iClient] = CurrentClipAmmo + 1;
							// 	//PrintToChatAll("Clip = 9 and Bullets < 18, IncreasedAmmo = %d", g_iCoachShotgunIncreasedAmmo[iClient]);
							// }
							
							/*
							else if((g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) == (8 + g_iSprayLevel[iClient]))
							{
								
							}
							
							new IncreasedClipAmmo = CurrentClipAmmo + 1;
							if(CurrentClipAmmo < (8 + (g_iSprayLevel[iClient] * 2)))
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
								SetEntData(iClient, iOffset_Ammo + 28, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
							}
							else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
							{
								new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
								SetEntData(iClient, iOffset_Ammo + 28, 0);
							}
							*/
							
						}
						else if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (g_iSprayLevel[iClient] > 0))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
							if(g_iReloadFrameCounter[iClient] == 1)
							{
								if(iAmmo >= ((10 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
								{
									SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, ((g_iSprayLevel[iClient] * 2) + 10) - CurrentClipAmmo, true);
									//PrintToChatAll("g_iOffset_ReloadNumShells");
								}
								else if(iAmmo < ((10 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
								{
									SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, iAmmo, true);
								}
							}
							if((CurrentClipAmmo == (10 + (g_iSprayLevel[iClient] * 2))) || (CurrentClipAmmo == (CurrentClipAmmo + iAmmo)))
							{
								
								// new InReload = GetEntData(iClient, g_bOffset_InReload + 32);
								// new InReloadWep = GetEntData(ActiveWeaponID, g_bOffset_InReload + 32);
								// PrintToChatAll("InReload %d", InReload);
								// PrintToChatAll("InReloadWep %d", InReloadWep);
								
								g_bCoachShotgunForceReload[iClient] = false;
								g_bClientIsReloading[iClient] = false;
								g_iReloadFrameCounter[iClient] = 0;
								SetEntData(ActiveWeaponID, g_bOffset_InReload, 0, true);
								SetEntData(iClient, g_bOffset_InReload, 0, true);
							}
						}
						/*
						if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (CurrentClipAmmo == 10))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);	//for auto shotguns (+32)
							if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
								SetEntData(iClient, iOffset_Ammo + 32, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
							}
							else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
							{
								new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
								SetEntData(iClient, iOffset_Ammo + 32, 0);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
						*/
					}
					case 3:		//Ellis Reload
					{
						if((StrEqual(g_strEllisPrimarySlot1, "empty", false) == true) || (StrEqual(g_strEllisPrimarySlot2, "empty", false) == true))
						{
							fnc_DeterminePrimaryWeapon(iClient);
							if((StrContains(g_strCurrentWeapon, "rifle", false) != -1) || (StrContains(g_strCurrentWeapon, "smg", false) != -1) || (StrContains(g_strCurrentWeapon, "shotgun", false) != -1) || (StrContains(g_strCurrentWeapon, "launcher", false) != -1) || (StrContains(g_strCurrentWeapon, "sniper", false) != -1))
							{
								fnc_SaveAmmo(iClient);
							}
						}
						if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
							if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
								SetEntData(iClient, iOffset_Ammo + 12, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
							}
							else if(iAmmo < (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo), true);
								SetEntData(iClient, iOffset_Ammo + 12, 0);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
						else if(((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true)) && (CurrentClipAmmo == 50))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);	//for smg (+20)
							if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
								SetEntData(iClient, iOffset_Ammo + 20, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
							}
							else if(iAmmo < (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
								SetEntData(iClient, iOffset_Ammo + 20, 0);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
						else if((StrEqual(currentweapon, "weapon_hunting_rifle", false) == true) && (CurrentClipAmmo == 15))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);	//for hunting rifle (+36)
							if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
								SetEntData(iClient, iOffset_Ammo + 36, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
							}
							else if(iAmmo < (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
								SetEntData(iClient, iOffset_Ammo + 36, 0);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
						else if(((StrEqual(currentweapon, "weapon_sniper_awp", false) == true) && (CurrentClipAmmo == 20)) || ((StrEqual(currentweapon, "weapon_sniper_military", false) == true) && (CurrentClipAmmo == 30)) || ((StrEqual(currentweapon, "weapon_sniper_scout", false) == true) && (CurrentClipAmmo == 15)))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);	//for AWP, Scout, and Military Sniper (+40)
							if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
								SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
							}
							else if(iAmmo < (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
								SetEntData(iClient, iOffset_Ammo + 40, 0);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
						/*
						if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true)) && (CurrentClipAmmo == 8))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);	//for pump shotguns (+28)
							if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
								SetEntData(iClient, iOffset_Ammo + 28, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
							}
							else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
							{
								new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
								SetEntData(iClient, iOffset_Ammo + 28, 0);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
						if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (CurrentClipAmmo == 10))
						{
							new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);	//for auto shotguns (+32)
							if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
								SetEntData(iClient, iOffset_Ammo + 32, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
							}
							else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
							{
								new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
								SetEntData(iClient, iOffset_Ammo + 32, 0);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
						*/
						//Decided the following was not necessary. It was meant to save ammo during reloading in case a player changed weapons in the middle of a reload, but changing weapons already saves the weapons current data.
						/*
						if(g_iEllisCurrentPrimarySlot[iClient] == 0)
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
						else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
						{
							if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
							{
								new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
								g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
								g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
							}
							else if((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true))
							{
								new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
								g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
								g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
							}
							else if((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true))
							{
								new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
								g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
								g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
							}
							else if((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true))
							{
								new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
								g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
								g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
							}
							else if(StrEqual(currentweapon, "weapon_hunting_rifle", false) == true)
							{
								new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
								g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
								g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
							}
							else if((StrEqual(currentweapon, "weapon_sniper_military", false) == true) || (StrEqual(currentweapon, "weapon_sniper_awp", false) == true) || (StrEqual(currentweapon, "weapon_sniper_scout", false) == true))
							{
								new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
								g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
								g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
							}
							else if(StrEqual(currentweapon, "weapon_grenade_launcher", false) == true)
							{
								new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
								g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
								g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
							}
							else if(StrEqual(currentweapon, "weapon_rifle_m60", false) == true)
							{
								//new iAmmo = GetEntData(iClient, iOffset_Ammo);
								g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
								g_iEllisPrimarySavedAmmoSlot2[iClient] = 0;
							}
						}
						*/
					}
					case 4:		//Nicks Reload
					{
						if((StrEqual(currentweapon, "weapon_pistol_magnum", false) == true) && (g_iMagnumLevel[iClient] > 0) && (CurrentClipAmmo == 8))
						{
							SetEntData(ActiveWeaponID, g_iOffset_Clip1, 3, true);
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
							//PrintToChatAll("Setting Magnum Clip");
						}
						else if((StrEqual(currentweapon, "weapon_pistol", false) == true) && (g_iRiskyLevel[iClient] > 0) && ((CurrentClipAmmo == 15) || (CurrentClipAmmo == 30)))
						{
							if(CurrentClipAmmo == 15)
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iRiskyLevel[iClient] * 6)), true);
							}
							else if(CurrentClipAmmo == 30)
							{
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iRiskyLevel[iClient] * 12)), true);
							}
							g_bClientIsReloading[iClient] = false;
							g_iReloadFrameCounter[iClient] = 0;
						}
					}
				}
				if(g_iReloadFrameCounter[iClient] == 300)
				{
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
					g_bCoachShotgunForceReload[iClient] = false;
				}
			}
		}
		else if(g_iClientTeam[iClient] == TEAM_INFECTED)/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		{
			if(GetEntData(iClient, g_iOffset_IsGhost, 1) == 1)		//Check if they are ghost first
				continue;
			
			switch(g_iInfectedCharacter[iClient])
			{
				case SMOKER:	OnGameFrame_Smoker(iClient);
				case BOOMER:	OnGameFrame_Boomer(iClient);
				case HUNTER:	OnGameFrame_Hunter(iClient);
				case SPITTER:	OnGameFrame_Spitter(iClient);
				case JOCKEY:	OnGameFrame_Jockey(iClient);
				case CHARGER:	OnGameFrame_Charger(iClient);
				case TANK:		OnGameFrame_Tank(iClient);
			}
		}
	}
	
	//For faster shooting and melee attacks
	if (g_bSomeoneAttacksFaster == true)
		HandleFastAttackingClients();
}

HandleFastAttackingClients()
{
	new looper = 0; 
	while(g_iFastAttackingClientsArray[looper] != -1)
	{
		new iClient = g_iFastAttackingClientsArray[looper];
		if(g_bDoesClientAttackFast[iClient] == false || IsClientInGame(iClient)==false || IsFakeClient(iClient)==true)
		{
			pop(iClient, 1);
			continue;
		}
		
		looper++;

		g_fGameTime = GetGameTime();
		new iActiveWeapon = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);

		if(iActiveWeapon == -1)
			continue;
		
		flNextTime_ret = GetEntDataFloat(iActiveWeapon,g_iOffset_NextPrimaryAttack);
		
		flNextTime2_ret = GetEntDataFloat(iActiveWeapon,g_iOffset_NextSecondaryAttack);
		
		if (g_iDTEntid[iClient] == iActiveWeapon && g_flDTNextTime[iClient] >= flNextTime_ret) continue;
		
		if(g_iMetalLevel[iClient] > 0)
			if (flNextTime2_ret > g_fGameTime) continue;
					
		if(g_bFirstShadowNinjaSwing[iClient] == false)
			if(g_iShadowLevel[iClient] > 0)
				if (flNextTime2_ret < g_fGameTime) continue;
		
		if (g_iDTEntid[iClient] == iActiveWeapon && g_flDTNextTime[iClient] < flNextTime_ret)
		{
			if((g_iMetalLevel[iClient] > 0) && (g_bIsEllisLimitBreaking[iClient] == false))		//For Ellis's firerate
			{
				flNextTime_calc = ( flNextTime_ret - g_fGameTime ) * (1.0 - (0.5 * g_fEllisFireRate[iClient] * (g_iMetalLevel[iClient] * 0.08 + g_iFireLevel[iClient] * 0.12))) + g_fGameTime;
			}
			else if(g_bIsEllisLimitBreaking[iClient] == true)		//For Ellis's firerate
			{
				flNextTime_calc = ( flNextTime_ret - g_fGameTime ) * (1.0 - (0.75)) + g_fGameTime;
			}
			
			if(g_iShadowLevel[iClient] > 0)	//For Rochelles ninja mode
			{
				if(g_bFirstShadowNinjaSwing[iClient])	//This makes it work on the first swing
				{
					g_bFirstShadowNinjaSwing[iClient] = false;
					flNextTime_calc = g_fGameTime;
				}
				else
					flNextTime_calc = ( flNextTime_ret - g_fGameTime ) * (1.0 - (g_iShadowLevel[iClient] * 0.1))  + g_fGameTime;
				
				WriteParticle(iClient, "rochelle_silhouette", 0.0, 0.4);
			}
			
			g_flDTNextTime[iClient] = flNextTime_calc;
			
			SetEntDataFloat(iActiveWeapon, g_iOffset_NextPrimaryAttack, flNextTime_calc, true);
			continue;
		}
		
		if (g_iDTEntid[iClient] != iActiveWeapon)
		{
			g_iDTEntid[iClient] = iActiveWeapon;
			g_flDTNextTime[iClient] = flNextTime_ret;
			continue;
		}
	}
}