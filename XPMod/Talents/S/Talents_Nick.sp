TalentsLoad_Nick(iClient)
{
	g_bDivineInterventionQueued[iClient] = false;
	g_iNickMagnumShotCountCap[iClient] = 0;
	g_bCanNickStampedeReload[iClient] = false;
	g_bNickSwindlerHealthCapped[iClient] = false;
	g_iNickSwindlerBonusHealth[iClient] = 0;
	g_bRamboModeActive[iClient] = false;
	new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
	new maxHP = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	
	if((g_iKitsUsed * (g_iSwindlerLevel[iClient] * 3)) < 100)
	{
		SetEntProp(iClient,Prop_Data,"m_iMaxHealth", maxHP + (g_iKitsUsed * (g_iSwindlerLevel[iClient] * 3)));
		SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + (g_iKitsUsed * (g_iSwindlerLevel[iClient] * 3)));
	}
	else if((g_iKitsUsed * (g_iSwindlerLevel[iClient] * 3)) > 100)
	{
		SetEntProp(iClient,Prop_Data,"m_iMaxHealth", maxHP + 100);
		SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + 100);
	}
	//PrintToChatAll("MaxHP Post = %d", maxHP);
	/*
	SetEntProp(iClient,Prop_Data,"m_iMaxHealth", g_iNickMaxHealth[iClient]);
	new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
	if(currentHP > g_iNickMaxHealth[iClient])
		SetEntProp(iClient,Prop_Data,"m_iHealth", g_iNickMaxHealth[iClient]);
	*/
	
	if(g_iMagnumLevel[iClient] > 0)
	{
		SetClientSpeed(iClient);
	}
		
	
	if(g_bTalentsGiven[iClient] == false)
		g_iClientBindUses_1[iClient] = 3 - RoundToCeil(g_iMagnumLevel[iClient] * 0.5);
	
	if(g_iDesperateLevel[iClient] > 0)
	{
		if(g_iClientBindUses_2[iClient] < 3)
			g_iPID_NickCharge3[iClient] = WriteParticle(iClient, "nick_ulti_heal_charge3", 0.0);
		if(g_iClientBindUses_2[iClient] < 2)
			g_iPID_NickCharge2[iClient] = WriteParticle(iClient, "nick_ulti_heal_charge2", 0.0);
		if(g_iClientBindUses_2[iClient] < 1)
			g_iPID_NickCharge1[iClient] = WriteParticle(iClient, "nick_ulti_heal_charge1", 0.0);
	}
	if(g_iRiskyLevel[iClient] == 5)
	{
		g_bCanNickSecondaryCycle[iClient] = true;
		g_bIsNickInSecondaryCycle[iClient] = false;
		g_iNickSecondarySavedClipSlot2[iClient] = 90;
		// PrintToChatAll("Talents Confirmed: Clip Slot 2 = %i", g_iNickSecondarySavedClipSlot2[iClient]);
	}
	if(g_iLeftoverLevel[iClient] == 5)
	{
		g_bCanNickZoomKit[iClient] = true;
	}
	
	if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Gambler Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilties will be automatically set as you level.");
}

OnGameFrame_Nick(iClient)
{
	if(g_iNicksRamboWeaponID[iClient] > 0)
	{
		new wID = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
		
		if(wID==-1 || IsValidEntity(wID)==false)
			return;
			
		//Set ammo to 250
		decl String:weaponclass[32];
		GetEntityNetClass(wID,weaponclass,32);
		
		if(StrEqual(weaponclass,"CRifle_M60",false) == true)
			SetEntData(wID, g_iOffset_Clip1, 250, true);
	}
	if(g_iLeftoverLevel[iClient] == 5)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(buttons & IN_ZOOM)
		{
			if(g_bCanNickZoomKit[iClient] == true)
			{
				g_bCanNickZoomKit[iClient] = false;
				CreateTimer(0.5, TimerNickZoomKitReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
				decl String:currentweapon[32];
				GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
				if(StrContains(currentweapon, "first_aid_kit", false) != -1)
				{
					new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
					decl Float:wepvorigin[3], Float:grevorigin[3], Float:boovorigin[3], Float:vangles[3], Float:vdir[3];
					GetClientEyeAngles(iClient, vangles);	//Get clients Eye Angles to know get what direction to spawn gun
					GetAngleVectors(vangles, vdir, NULL_VECTOR, NULL_VECTOR);	//Get the direction the iClient is looking
					vangles[0] = 0.0;		//Lock x and z axis
					vangles[2] = 0.0;
					GetClientAbsOrigin(iClient, wepvorigin);	//Get clients location origin vectors
					GetClientAbsOrigin(iClient, grevorigin);
					GetClientAbsOrigin(iClient, boovorigin);
					wepvorigin[0]+=(vdir[0] * 30.0);		
					wepvorigin[1]+=(vdir[1] * 30.0);
					wepvorigin[2]+=(vdir[2] + 30.0);
					grevorigin[0]+=(vdir[0] * 15.0);		
					grevorigin[1]+=(vdir[1] * 15.0);
					grevorigin[2]+=(vdir[2] + 30.0);
					boovorigin[0]+=(vdir[0] * 45.0);		
					boovorigin[1]+=(vdir[1] * 45.0);
					boovorigin[2]+=(vdir[2] + 30.0);

					new random_grenade = GetRandomInt(0,2);
					new random_weapon = GetRandomInt(0,19);
					new random_boost = GetRandomInt(0,1);
					
					decl grenade, weapon, boost;
					

							
					
					switch (random_grenade)
					{
						case 0:
						{
							grenade = CreateEntityByName("weapon_pipe_bomb");
						}
						case 1:
						{
							grenade = CreateEntityByName("weapon_molotov");
						}
						case 2:
						{
							grenade = CreateEntityByName("weapon_vomitjar");
						}
					}
					switch (random_weapon)
					{
						case 0:
						{
							weapon = CreateEntityByName("weapon_autoshotgun");
						}
						case 1:
						{
							weapon = CreateEntityByName("weapon_grenade_launcher");
						}
						case 2:
						{
							weapon = CreateEntityByName("weapon_hunting_rifle");
						}
						case 3:
						{
							weapon = CreateEntityByName("weapon_pistol");
						}
						case 4:
						{
							weapon = CreateEntityByName("weapon_pistol_magnum");
						}
						case 5:
						{
							weapon = CreateEntityByName("weapon_pumpshotgun");
						}
						case 6:
						{
							weapon = CreateEntityByName("weapon_rifle");
						}
						case 7:
						{
							weapon = CreateEntityByName("weapon_rifle_ak47");
						}
						case 8:
						{
							weapon = CreateEntityByName("weapon_rifle_desert");
						}
						case 9:
						{
							weapon = CreateEntityByName("weapon_rifle_m60");
						}
						case 10:
						{
							weapon = CreateEntityByName("weapon_rifle_sg552");
						}
						case 11:
						{
							weapon = CreateEntityByName("weapon_shotgun_chrome");
						}
						case 12:
						{
							weapon = CreateEntityByName("weapon_shotgun_spas");
						}
						case 13:
						{
							weapon = CreateEntityByName("weapon_smg");
						}
						case 14:
						{
							weapon = CreateEntityByName("weapon_smg_mp5");
						}
						case 15:
						{
							weapon = CreateEntityByName("weapon_smg_silenced");
						}
						case 16:
						{
							weapon = CreateEntityByName("weapon_sniper_awp");
						}
						case 17:
						{
							weapon = CreateEntityByName("weapon_sniper_military");
						}
						case 18:
						{
							weapon = CreateEntityByName("weapon_sniper_scout");
						}
						case 19:
						{
							weapon = CreateEntityByName("weapon_gnome");
						}
					}
					switch (random_boost)
					{
						case 0:
						{
							boost = CreateEntityByName("weapon_adrenaline");
						}
						case 1:
						{
							boost = CreateEntityByName("weapon_pain_pills");
						}
					}
					DispatchKeyValue(weapon, "ammo", "200");
					AcceptEntityInput(ActiveWeaponID, "Kill");
					DispatchSpawn(grenade);
					DispatchSpawn(weapon);
					DispatchSpawn(boost);
					TeleportEntity(grenade, grevorigin, vangles, NULL_VECTOR);
					TeleportEntity(weapon, wepvorigin, vangles, NULL_VECTOR);
					TeleportEntity(boost, boovorigin, vangles, NULL_VECTOR);
				}
			}
		}
	}
	if(g_iRiskyLevel[iClient] == 5)
	{
		if(g_bCanNickSecondaryCycle[iClient] == true)
		{
			new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
			
			if((buttons & IN_SPEED) && (buttons & IN_ZOOM))
			{
				decl String:currentweapon[512];
				GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
				//PrintToChatAll("Current Weapon is %s", currentweapon);
				if((StrContains(currentweapon,"pistol",false) != -1) || (StrContains(currentweapon,"melee",false) != -1) || (StrContains(currentweapon,"chainsaw",false) != -1))
				{
					//PrintToChatAll("String contains a gun");
					g_bCanNickSecondaryCycle[iClient] = false;
					g_bIsNickInSecondaryCycle[iClient] = true;
					CreateTimer(0.5, TimerNickSecondaryCycleReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
					new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
					if (IsValidEntity(ActiveWeaponID) == false)
						return;
					//PrintToChatAll("%s g_strNickSecondarySlot2", g_strNickSecondarySlot2[iClient]);
					//PrintToChatAll("%s g_strNickSecondarySlot1", g_strNickSecondarySlot1[iClient]);
					//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
					new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
					//PrintToChatAll("CurrentClipAmmo %d", CurrentClipAmmo);
					
					if(StrEqual(currentweapon, "weapon_pistol", false) == false)
					{
						g_iNickCurrentSecondarySlot[iClient] = 0;
						//PrintToChatAll("Is not pistol, slot = %d", g_iNickCurrentSecondarySlot[iClient]);
					}
					else if(StrEqual(currentweapon, "weapon_pistol", false) == true)
					{
						g_iNickCurrentSecondarySlot[iClient] = 1;
						//PrintToChatAll("Is pistol, slot = %d", g_iNickCurrentSecondarySlot[iClient]);
					}
					
					if(StrEqual(g_strNickSecondarySlot1, "empty", false) == true)
					{
						g_bIsNickInSecondaryCycle[iClient] = false;
					}
					
					if(g_iNickCurrentSecondarySlot[iClient] == 0)
					{
						g_strNickSecondarySlot1 = currentweapon;
						
						//if((StrEqual(currentweapon, "weapon_pistol", false) == true) || (StrEqual(currentweapon, "weapon_pistol_magnum", false) == true))
						if((StrEqual(currentweapon, "weapon_pistol", false) == true) || (StrEqual(currentweapon, "weapon_pistol_magnum", false) == true) || (StrEqual(currentweapon, "weapon_chainsaw", false) == true))
						{
							g_iNickSecondarySavedClipSlot1[iClient] = CurrentClipAmmo;
							//PrintToChatAll("ClipSlot1 on cycle w slot 0 = %d", g_iNickSecondarySavedClipSlot1[iClient]);
						}
						else if(StrEqual(currentweapon, "weapon_melee", false) == true)
						{
							g_iNickSecondarySavedClipSlot1[iClient] = 0;
						}
						
						//PrintToChatAll("g_iNickSecondarySavedClipSlot1 %d", g_iNickSecondarySavedClipSlot1[iClient]);
						
						if((StrEqual(currentweapon, "weapon_melee", false) == true) || (StrEqual(currentweapon, "weapon_chainsaw", false) == true))
						{
							g_strNickSecondarySlot1 = "empty";
						}
						else
						{
							AcceptEntityInput(ActiveWeaponID, "Kill");
						}
						g_iNickCurrentSecondarySlot[iClient] = 1;

						RunCheatCommand(iClient, "give", "give pistol");
						RunCheatCommand(iClient, "give", "give pistol");
						//SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iNickSecondarySavedClipSlot2[iClient], true);	//This was causing the chainsaws clip to increase, redundant code
					}
					else if(g_iNickCurrentSecondarySlot[iClient] == 1)
					{
						g_strNickSecondarySlot2 = currentweapon;
						//PrintToChatAll("Current Weapon is %s", currentweapon);
						//PrintToChatAll("Second Check %s", g_strNickSecondarySlot2[iClient]);
						
						if((StrEqual(currentweapon, "weapon_pistol", false) == true) || (StrEqual(currentweapon, "weapon_pistol_magnum", false) == true))
						{
							g_iNickSecondarySavedClipSlot2[iClient] = CurrentClipAmmo;
							//PrintToChatAll("ClipSlot2 on cycle w slot 2 = %d", g_iNickSecondarySavedClipSlot2[iClient]);
						}
						else if(StrEqual(currentweapon, "weapon_melee", false) == true)
						{
							g_iNickSecondarySavedClipSlot2[iClient] = 0;
						}
						
						//PrintToChatAll("g_iNickSecondarySavedClipSlot2 %d", g_iNickSecondarySavedClipSlot2[iClient]);
						
						if(StrEqual(g_strNickSecondarySlot1, "weapon_pistol_magnum", false) == true)
						{
							AcceptEntityInput(ActiveWeaponID, "Kill");
							g_iNickCurrentSecondarySlot[iClient] = 0;

							RunCheatCommand(iClient, "give", "give pistol_magnum");
							if (IsValidEntity(ActiveWeaponID) == true)
								SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iNickSecondarySavedClipSlot1[iClient], true);
						}
						
						// if(StrEqual(g_strNickSecondarySlot1, "weapon_melee", false) == true)
						// {
						// 	new weaponcheck = GetEntPropString(GetPlayerWeaponSlot(client, 1), Prop_Data, "m_strMapSetScriptName", currentweapon, sizeof(currentweapon));
						// 	PrintToChatAll("Test %d", weaponcheck);
						// 	if (StrEqual(weaponname, "weapon_melee"))
						// 	{
						// 		GetEntPropString(GetPlayerWeaponSlot(client, 1), Prop_Data, "m_strMapSetScriptName", currentweapon, sizeof(currentweapon));
						// 	}  
						// }
						
					}
				}
			}
		}
	}
}

OGFSurvivorReload_Nick(iClient, const char[] currentweapon, ActiveWeaponID, CurrentClipAmmo)
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

EventsHurt_AttackerNick(Handle:hEvent, iAttacker, iVictim)
{
	if (IsFakeClient(iAttacker) || g_bTalentsConfirmed[iAttacker] == false)
		return;

	if (g_iEnhancedLevel[iAttacker] > 0 && g_iClientTeam[iVictim] == TEAM_SURVIVORS)
	{
		decl String:strCurrentWeapon[32];
		GetClientWeapon(iAttacker, strCurrentWeapon, sizeof(strCurrentWeapon));

		// Check that its a pistol
		if (StrEqual(strCurrentWeapon, "weapon_pistol_magnum", false) == true)
		{
			new iCurrentAttackerHealth = GetEntProp(iAttacker, Prop_Data, "m_iHealth");
			new iCurrentVictimHealth = GetEntProp(iVictim, Prop_Data, "m_iHealth");
			new iCurrentVictimMaxHealth = GetEntProp(iVictim, Prop_Data, "m_iMaxHealth");
			// Need this to remove friendly fire damage
			new iDmgAmount = GetEventInt(hEvent, "dmg_health");

			// If theres enough life in Nick's pool then make the transaction
			if (iCurrentAttackerHealth > NICK_HEAL_MAGNUM_TAKE && iCurrentVictimHealth + iDmgAmount < iCurrentVictimMaxHealth)
			{
				new iHealAmount = iCurrentVictimHealth + iDmgAmount + NICK_HEAL_MAGNUM_GIVE < iCurrentVictimMaxHealth ? 
					iDmgAmount + NICK_HEAL_MAGNUM_GIVE : 
					iCurrentVictimMaxHealth - iCurrentVictimHealth;
				SetEntProp(iAttacker,Prop_Data,"m_iHealth", iCurrentAttackerHealth - NICK_HEAL_MAGNUM_TAKE);
				SetEntProp(iVictim,Prop_Data,"m_iHealth", iCurrentVictimHealth + iHealAmount);

				// Effects
				WriteParticle(iVictim, "nick_lifesteal_recovery", 0.0, 3.0);
				// HUD effects
				if(IsFakeClient(iVictim)==false)
					ShowHudOverlayColor(iVictim, 0, 100, 255, 40, 440, FADE_OUT);
				
				if(IsFakeClient(iAttacker)==false)
					ShowHudOverlayColor(iAttacker, 180, 0, 40, 40, 440, FADE_OUT);
			}
			// Otherwise, just give friendly fire damage back to the survivor he shot
			else
			{
				SetEntProp(iVictim,Prop_Data,"m_iHealth", iCurrentVictimHealth + iDmgAmount);
			}
		}
		else if(StrEqual(strCurrentWeapon, "weapon_pistol", false) == true)
		{
			new iCurrentAttackerHealth = GetEntProp(iAttacker, Prop_Data, "m_iHealth");
			new iCurrentVictimHealth = GetEntProp(iVictim, Prop_Data, "m_iHealth");
			new iCurrentVictimMaxHealth = GetEntProp(iVictim, Prop_Data, "m_iMaxHealth");
			// Need this to remove friendly fire damage
			new iDmgAmount = GetEventInt(hEvent, "dmg_health");

			// If theres enough life in Nick's pool then make the transaction
			if (iCurrentAttackerHealth > NICK_HEAL_PISTOL_TAKE && iCurrentVictimHealth + iDmgAmount < iCurrentVictimMaxHealth)
			{
				new iHealAmount = iCurrentVictimHealth + iDmgAmount + NICK_HEAL_PISTOL_GIVE < iCurrentVictimMaxHealth ? 
					iDmgAmount + NICK_HEAL_PISTOL_GIVE : 
					iCurrentVictimMaxHealth - iCurrentVictimHealth;
				SetEntProp(iAttacker,Prop_Data,"m_iHealth", iCurrentAttackerHealth - NICK_HEAL_PISTOL_TAKE);
				SetEntProp(iVictim,Prop_Data,"m_iHealth", iCurrentVictimHealth + iHealAmount);

				// Effects
				WriteParticle(iVictim, "nick_lifesteal_recovery", 0.0, 3.0);
				// HUD effects
				if(IsFakeClient(iVictim)==false)
					ShowHudOverlayColor(iVictim, 0, 100, 255, 40, 440, FADE_OUT);
				
				if(IsFakeClient(iAttacker)==false)
					ShowHudOverlayColor(iAttacker, 180, 0, 40, 40, 440, FADE_OUT);
			}
			// Otherwise, just give friendly fire damage back to the survivor he shot
			else
			{
				SetEntProp(iVictim,Prop_Data,"m_iHealth", iCurrentVictimHealth + iDmgAmount);
			}
		}
	}

	// From this point on only deal with infected iVictims
	if (g_iClientTeam[iVictim] != TEAM_INFECTED)
		return;

	if(g_iSwindlerLevel[iAttacker] > 0)
	{
		if(g_iClientTeam[iVictim] == TEAM_INFECTED)
			if(g_bNickIsStealingLife[iVictim][iAttacker] == false)	//If player not poisoned, poison them
			{
				g_bNickIsStealingLife[iVictim][iAttacker] = true;
				
				new Handle:lifestealingpackage = CreateDataPack();
				WritePackCell(lifestealingpackage, iVictim);
				WritePackCell(lifestealingpackage, iAttacker);
				g_iNickStealingLifeRuntimes[iVictim] = 0;

				delete g_hTimer_NickLifeSteal[iVictim];
				g_hTimer_NickLifeSteal[iVictim] = CreateTimer(2.0, TimerLifeStealing, lifestealingpackage, TIMER_REPEAT);
				
				decl Float:vec[3];
				GetClientAbsOrigin(iVictim, vec);
				EmitSoundToAll(SOUND_NICK_LIFESTEAL_HIT, iVictim, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
			}
	}

	if(g_iDesperateLevel[iAttacker] > 0 && g_iNickDesperateMeasuresStack > 0)
	{
		decl String:weaponclass[32];
		GetEventString(hEvent,"weapon",weaponclass,32);
		
		if(StrContains(weaponclass,"melee",false) == -1 && StrContains(weaponclass,"inferno",false) == -1 && 
			StrContains(weaponclass,"pipe_bomb",false) == -1 && StrContains(weaponclass,"entityflame",false) == -1)
		{
			new hp = GetEntProp(iVictim,Prop_Data,"m_iHealth");
			new dmg = GetEventInt(hEvent,"dmg_health");
			
			if(g_iNickDesperateMeasuresStack > 3)
				dmg = RoundToNearest(dmg * (g_iDesperateLevel[iAttacker] * 0.05) * 3);
			else
				dmg = RoundToNearest(dmg * (g_iDesperateLevel[iAttacker] * 0.05) * g_iNickDesperateMeasuresStack);

			dmg = CalculateDamageTakenForVictimTalents(iVictim, dmg, weaponclass);

			//PrintToChat(iAttacker, "You are doing %d extra damage", dmg);
			SetEntProp(iVictim,Prop_Data,"m_iHealth", hp - dmg);
		}
	}
	
	if(g_iMagnumLevel[iAttacker] > 0 || g_iRiskyLevel[iAttacker] > 0)
	{
		if(g_iClientTeam[iVictim] == TEAM_INFECTED)
		{
			decl String:weaponclass[32];
			GetEventString(hEvent,"weapon",weaponclass,32);
			if (StrContains(weaponclass,"magnum",false) != -1)
			{
				new hp = GetEntProp(iVictim,Prop_Data,"m_iHealth");
				new dmg = GetEventInt(hEvent,"dmg_health");

				dmg = RoundToNearest(dmg * (g_iMagnumLevel[iAttacker] * 0.75));
				dmg = CalculateDamageTakenForVictimTalents(iVictim, dmg, weaponclass);

				//PrintToChat(iAttacker, "your doing %d extra magnum damage", dmg);
				SetEntProp(iVictim,Prop_Data,"m_iHealth", hp - dmg);
			}
			else if (StrContains(weaponclass,"pistol",false) != -1)
			{
				new hp = GetEntProp(iVictim,Prop_Data,"m_iHealth");
				new dmg = GetEventInt(hEvent,"dmg_health");

				dmg = RoundToNearest(dmg * (g_iRiskyLevel[iAttacker] * 0.2));
				dmg = CalculateDamageTakenForVictimTalents(iVictim, dmg, weaponclass);

				//PrintToChat(iAttacker, "your doing %d extra damage", dmg);
				SetEntProp(iVictim,Prop_Data,"m_iHealth", hp - dmg);
			}
			GetClientWeapon(iAttacker, g_strCurrentWeapon, sizeof(g_strCurrentWeapon));
			if(StrEqual(g_strCurrentWeapon, "weapon_pistol_magnum", false) == true)
			{
				g_iNickMagnumShotCount[iAttacker]++;
				//PrintToChatAll("g_iNickMagnumShotCount = %d", g_iNickMagnumShotCount[iAttacker]);
				if((g_iNickMagnumShotCountCap[iAttacker] / 2) < g_iNickMagnumShotCount[iAttacker])
				{
					g_iNickMagnumShotCount[iAttacker] = (g_iNickMagnumShotCountCap[iAttacker] / 2);
					//PrintToChatAll("g_iNickMagnumShotCount After = %d", g_iNickMagnumShotCount[iAttacker]);
				}
				if(g_iNickMagnumShotCount[iAttacker] == 3)
				{
					//PrintToChatAll("Nick Magnum Count = 3, stampede reload = true");
					g_bCanNickStampedeReload[iAttacker] = true;
				}
			}
		}
	}
}

// EventsHurt_VictimNick(Handle:hEvent, iAttacker, iVictim)
// {
// 	if (IsFakeClient(iVictim))
// 		return;
// }

// EventsDeath_AttackerNick(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

EventsDeath_VictimNick(Handle:hEvent, iAttacker, iVictim)
{
	if (g_iClientTeam[iVictim] != TEAM_SURVIVORS)
		return;

	SuppressNeverUsedWarning(hEvent, iAttacker);
	
	// Nick's DesperateMeasuresStack
	if(g_bWasClientDownOnDeath[iVictim] == true)
		g_bWasClientDownOnDeath[iVictim] = false;
	else
	{
		g_iNickDesperateMeasuresStack++;

		for(int i=1; i <= MaxClients; i++)
		{
			if (RunClientChecks(i) && 
				g_iClientTeam[i]==TEAM_SURVIVORS && 
				IsPlayerAlive(i) == true)
			{
				if(g_iNickDesperateMeasuresStack <= 3)
				{
					SetClientSpeed(i);
					PrintHintText(i, "A teammate has died, your senses sharpen.");
				}
			}
		}
	}
}


//Jebus Hand Menu
Action:JebusHandBindMenuDraw(iClient) 
{
	CheckMenu(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(JebusHandMenuHandler);
	
	g_iOverLevel[iClient] = 3 - g_iClientBindUses_2[iClient];
	SetMenuTitle(g_hMenu_XPM[iClient], "     Jebus Hand Menu\n================================\n%d Charges Remain\n================================", g_iOverLevel[iClient]);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Heal Every Teammate        (1 Charge)");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Revive Downed Teammate     (2 Charges)");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Resurrect A Dead Teammate  (3 Charges)");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Do Nothing For Now\n ");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Nick Menu Handler
JebusHandMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(RunClientChecks(iClient) == false)
		return;
	
	if(IsPlayerAlive(iClient) == false)
	{
		if(IsFakeClient(iClient) == false)
			PrintToChat(iClient, "\x03[XPMod] \x01You cannot use Jebus Hand after you have died.");
		return;
	}
	
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Heal Every Teammate
			{
				decl currentHP;
				decl maxHP;

				for(new i = 1; i <= MaxClients; i++)
				{
					if (RunClientChecks(i) && g_iClientTeam[i]==TEAM_SURVIVORS)
					{
						if(IsPlayerAlive(i)==true && g_bIsClientDown[i] == false)
						{
							currentHP = GetEntProp(i,Prop_Data,"m_iHealth");
							maxHP = GetEntProp(i,Prop_Data,"m_iMaxHealth");
							//PrintToChatAll("max health for %N is %d", i, maxHP);
							PrintHintText(i, "You have been partially healed by %N", iClient);
							if((currentHP + (g_iDesperateLevel[iClient] * 4)) >= maxHP)
								SetEntProp(i,Prop_Data,"m_iHealth", maxHP);
							else
								SetEntProp(i,Prop_Data,"m_iHealth", currentHP + (g_iDesperateLevel[iClient] * 4));
						}
						// Handle Ellis
						if(g_iOverLevel[i] > 0)
						{
							new iCurrentHealth = GetEntProp(i,Prop_Data,"m_iHealth");
							new iMaxHealth = GetEntProp(i,Prop_Data,"m_iMaxHealth");
							//new Float:fTempHealth = GetEntDataFloat(iClient, g_iOffset_HealthBuffer);
							//if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - 20.0))
							if(iCurrentHealth < (iMaxHealth - 20.0))
							{
								if(g_bEllisOverSpeedIncreased[i])
								{
									g_bEllisOverSpeedIncreased[i] = false;
									SetClientSpeed(i);
								}
							}
							//else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - 20.0))
							else if(iCurrentHealth >= (iMaxHealth - 20.0))
							{
								if(g_bEllisOverSpeedIncreased[i] == false)
								{
									g_bEllisOverSpeedIncreased[i] = true;
									SetClientSpeed(i);
								}
							}
						}
					}
				}

				new Float:vec[3];
				GetClientAbsOrigin(iClient, vec);
				EmitSoundToAll(SOUND_NICK_HEAL, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
				WriteParticle(iClient, "nick_ulti_heal", 3.0, 15.0);
				switch(g_iClientBindUses_2[iClient])
				{
					case 0:
						DeleteParticleEntity(g_iPID_NickCharge3[iClient]);
					case 1:
						DeleteParticleEntity(g_iPID_NickCharge2[iClient]);
					case 2:
						DeleteParticleEntity(g_iPID_NickCharge1[iClient]);
				}
				PrintHintText(iClient, "You have partially healed everyone on your team.");
				g_iClientBindUses_2[iClient]++;
			}
			case 1: //Revive Downed Teammate
			{
				if(g_iClientBindUses_2[iClient] < 2)
				{
					new foundvalident = 0;
					for(new i = 1; i <= MaxClients; i++)
					{
						if(IsClientInGame(i)==true)
							if(GetClientTeam(i)==2 && IsPlayerAlive(i)==true && g_bIsClientDown[i]==true && IsFakeClient(i)==false  && g_bHunterGrappled[i] == false && g_bChargerGrappled[i] == false && g_bSmokerGrappled[i] == false)
							{
								RunCheatCommand(i, "give", "give health");
								PrintHintText(i, "You have been instantly revived by %N", iClient);
								SetEntProp(i,Prop_Data,"m_iHealth", 20);
								g_bIsClientDown[i] = false;
								g_iClientBindUses_2[iClient] += 2;
								decl Float:vec[3];
								GetClientAbsOrigin(i, vec);
								EmitSoundToAll(SOUND_NICK_REVIVE, i, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
								WriteParticle(i, "nick_ulti_revive", 0.0, 15.0);
								
								foundvalident++;
								switch(g_iClientBindUses_2[iClient])
								{
									case 1:
										DeleteParticleEntity(g_iPID_NickCharge3[iClient]);
									case 2:
										DeleteParticleEntity(g_iPID_NickCharge2[iClient]);
									case 3:
										DeleteParticleEntity(g_iPID_NickCharge1[iClient]);
								}
								
								if(foundvalident > 0 || g_iClientBindUses_2[iClient]>2)
									break;
							}
					}
					for(new i = 1; i <= MaxClients; i++)
					{
						if(IsClientInGame(i)==true)
							if(GetClientTeam(i)==2 && IsPlayerAlive(i)==true && g_bIsClientDown[i]==true && IsFakeClient(i)==true  && g_bHunterGrappled[i] == false && g_bChargerGrappled[i] == false && g_bSmokerGrappled[i] == false)
							{
								if(foundvalident > 0  || g_iClientBindUses_2[iClient]>2)
									break;

								RunCheatCommand(i, "give", "give health");

								SetEntProp(i,Prop_Data,"m_iHealth", 20);
								g_bIsClientDown[i] = false;
								g_iClientBindUses_2[iClient] += 2;
								decl Float:vec[3];
								GetClientAbsOrigin(i, vec);
								EmitSoundToAll(SOUND_NICK_REVIVE, i, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
								WriteParticle(i, "nick_ulti_revive", 0.0, 15.0);
								
								foundvalident++;
								switch(g_iClientBindUses_2[iClient])
								{
									case 1:
										DeleteParticleEntity(g_iPID_NickCharge3[iClient]);
									case 2:
										DeleteParticleEntity(g_iPID_NickCharge2[iClient]);
									case 3:
										DeleteParticleEntity(g_iPID_NickCharge1[iClient]);
								}
							}
					}
					/*if(foundvalident!=0)
					{
						new Float:vec[3];
						GetClientAbsOrigin(iClient, vec);
						EmitSoundToAll(SOUND_NICK_REVIVE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
						WriteParticle(iClient, "nick_ulti_revive", 0.0, 15.0);
					}*/
					if(foundvalident==0)
					{
						PrintHintText(iClient, "No one is down that can be revived.");
						JebusHandBindMenuDraw(iClient);
					}
					else if(foundvalident > 1)
						PrintHintText(iClient, "You have revived a downed teammate.");
				}
				else
				{
					PrintHintText(iClient, "You dont have enough charges to use revive again.");
					JebusHandBindMenuDraw(iClient);
				}
			}
			case 2: //Clone Fallen Teammate
			{
				if(g_iNickResurrectUses < 1)		//Only allow once per round
				{
					if(g_iClientBindUses_2[iClient] <= 0)
					{
						new foundvalident = 0;
						for(new i = 1; i <= MaxClients; i++)
						{
							if(IsClientInGame(i)==true)
								if(GetClientTeam(i)==2 && IsPlayerAlive(i)==false && IsFakeClient(i)==false)
								{
									decl Float:vec[3];
									GetClientAbsOrigin(iClient, vec);
									
									SDKCall(g_hSDK_RoundRespawn, i);
									TeleportEntity(i, vec, NULL_VECTOR, NULL_VECTOR);
									PrintHintText(i, "You have been resurrected by %N", iClient);
									g_bIsClientDown[i] = false;
									g_iClientBindUses_2[iClient] += 3;
									g_iNickResurrectUses++;
									decl Float:vec2[3];
									
									GetClientAbsOrigin(i, vec2);
									EmitSoundToAll(SOUND_NICK_RESURRECT, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec2, NULL_VECTOR, true, 0.0);
									foundvalident = 2;
									WriteParticle(i, "nick_ulti_resurrect_base", 0.0, 25.0);
									WriteParticle(i, "nick_ulti_resurrect_mind", 0.0, 25.0);
									WriteParticle(i, "nick_ulti_resurrect_body", 0.0, 25.0);
									WriteParticle(i, "nick_ulti_resurrect_soul", 0.0, 25.0);
									WriteParticle(i, "nick_ulti_resurrect_trail", 0.0, 25.0);
									DeleteParticleEntity(g_iPID_NickCharge1[iClient]);
									DeleteParticleEntity(g_iPID_NickCharge2[iClient]);
									DeleteParticleEntity(g_iPID_NickCharge3[iClient]);
									SetEntProp(i,Prop_Data,"m_iHealth", 50);
									if(foundvalident == 2)
										break;
								}
						}
						for(new i = 1; i <= MaxClients; i++)
						{
							if(IsClientInGame(i)==true)
								if(GetClientTeam(i)==2 && IsPlayerAlive(i)==false)
								{
									if(foundvalident==2)
										break;
									decl Float:vec[3];
									
									GetClientAbsOrigin(iClient, vec);
									SDKCall(g_hSDK_RoundRespawn, i);
									TeleportEntity(i, vec, NULL_VECTOR, NULL_VECTOR);
									g_bIsClientDown[i] = false;
									g_iClientBindUses_2[iClient] += 3;
									g_iNickResurrectUses++;
									EmitSoundToAll(SOUND_NICK_RESURRECT, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
									foundvalident = 2;
									WriteParticle(i, "nick_ulti_resurrect_base", 0.0, 25.0);
									WriteParticle(i, "nick_ulti_resurrect_mind", 0.0, 25.0);
									WriteParticle(i, "nick_ulti_resurrect_body", 0.0, 25.0);
									WriteParticle(i, "nick_ulti_resurrect_soul", 0.0, 25.0);
									WriteParticle(i, "nick_ulti_resurrect_trail", 0.0, 25.0);
									DeleteParticleEntity(g_iPID_NickCharge1[iClient]);
									DeleteParticleEntity(g_iPID_NickCharge2[iClient]);
									DeleteParticleEntity(g_iPID_NickCharge3[iClient]);
									SetEntProp(i,Prop_Data,"m_iHealth", 50);
								}
						}
						if(foundvalident==0)
						{
							PrintHintText(iClient, "No one is dead.");
							JebusHandBindMenuDraw(iClient);
						}
						else if(foundvalident==1)
							PrintHintText(iClient, "You have resurrected a fallen teammate.");
					}
					else
					{
						PrintHintText(iClient, "You need 3 charges to clone dead teammates.");
						JebusHandBindMenuDraw(iClient);
					}
				}
				else
				{
					PrintHintText(iClient, "Resurrect has already been used this round.");
					JebusHandBindMenuDraw(iClient);
				}
			}
		}
	}
	if(g_iRiskyLevel[iClient] > 0)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if((buttons & IN_RELOAD) && g_bClientIsReloading[iClient] == false && g_bForceReload[iClient] == false)
		{
			decl String:currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			if((StrEqual(currentweapon, "weapon_pistol", false) == true) && ((CurrentClipAmmo == 15) || (CurrentClipAmmo == 30)))
			{
				g_bForceReload[iClient] = true;
				g_iSavedClip[iClient] = CurrentClipAmmo;
				SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
			}
		}
	}
	return;
}