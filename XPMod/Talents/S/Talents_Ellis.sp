TalentsLoad_Ellis(iClient)
{
	SetEntProp(iClient,Prop_Data,"m_iMaxHealth", g_iEllisMaxHealth[iClient]);
	new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
	if(currentHP > g_iEllisMaxHealth[iClient])
		SetEntProp(iClient,Prop_Data,"m_iHealth", g_iEllisMaxHealth[iClient]);
	
	if(g_iMetalLevel[iClient]>0)
	{
		g_bDoesClientAttackFast[iClient] = true;
		g_bSomeoneAttacksFaster = true;
		push(iClient);
	}
	
	if(g_iMetalLevel[iClient] == 5)
	{
		g_bIsEllisLimitBreaking[iClient] = false;
		g_bCanEllisLimitBreak[iClient] = true;
		g_bEllisLimitBreakInCooldown[iClient] = false;
	}
	
	if(g_bSurvivorTalentsGivenThisRound[iClient] == false)
	{
		if((0.4 - (float(g_iWeaponsLevel[iClient])*0.08)) < g_fMaxLaserAccuracy)
		{
			g_fMaxLaserAccuracy = 0.4 - (float(g_iWeaponsLevel[iClient]) * 0.08);
			SetConVarFloat(FindConVar("upgrade_laser_sight_spread_factor"), g_fMaxLaserAccuracy);
		}
		
		g_iClientBindUses_1[iClient] = 3 - RoundToCeil(g_iMetalLevel[iClient] * 0.5);
	}
	
	if(g_iFireLevel[iClient] > 0)
	{
		if(g_iClientBindUses_2[iClient] < 3)
			g_iPID_EllisCharge3[iClient] = WriteParticle(iClient, "ellis_ulti_fire_charge3", 0.0);
		if(g_iClientBindUses_2[iClient] < 2)
			g_iPID_EllisCharge2[iClient] = WriteParticle(iClient, "ellis_ulti_fire_charge2", 0.0);
		if(g_iClientBindUses_2[iClient] < 1)
			g_iPID_EllisCharge1[iClient] = WriteParticle(iClient, "ellis_ulti_fire_charge1", 0.0);
	}
	
	if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Weapon Expert Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilties will be automatically set as you level.");
		
	if(g_iOverLevel[iClient] > 0)
	{
		new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
		new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
		if (iCurrentHealth < (iMaxHealth - ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT))
		{
			if(g_bEllisOverSpeedIncreased[iClient])
			{
				g_bEllisOverSpeedIncreased[iClient] = false;
				SetClientSpeed(iClient);
			}
		}
		else if (iCurrentHealth >= (iMaxHealth - ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT))
		{
			if(g_bEllisOverSpeedIncreased[iClient] == false)
			{
				g_bEllisOverSpeedIncreased[iClient] = true;
				SetClientSpeed(iClient);
			}
		}

		// Set adrenaline counter for global Ellis
		g_iEllisAdrenalineStackDuration += (g_iOverLevel[iClient] * 2);
		SetConVarFloat(FindConVar("adrenaline_duration"), float(g_iEllisAdrenalineStackDuration));
	}

	if(g_iJamminLevel[iClient] == 5)
	{
		g_iEllisJamminGrenadeCounter[iClient] = 0;
		g_iEllisJamminAdrenalineCounter[iClient] = 0;
	}
	
	if(g_iWeaponsLevel[iClient] == 5)
	{
		g_bIsInEllisInPrimaryCycle[iClient] = false;
		g_iEllisCurrentPrimarySlot[iClient] = 0;
		g_bCanEllisPrimaryCycle[iClient] = true;
		g_iEllisPrimarySlot0[iClient] = ITEM_EMPTY;
		g_iEllisPrimarySlot1[iClient] = ITEM_EMPTY;
		//PrintToChatAll("Ellis primary slots are now empty");
	}
}

OnGameFrame_Ellis(iClient)
{
	HandleEllisSwitchToStashedPrimaryWeapon(iClient);

	if(g_iMetalLevel[iClient] == 5)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		
		if(!(buttons & IN_SPEED) || !(buttons & IN_USE))
			g_bWalkAndUseToggler[iClient] = false;
			
		if((g_bWalkAndUseToggler[iClient] == false) && ((buttons & IN_SPEED) && (buttons & IN_USE)))
		{
			g_bWalkAndUseToggler[iClient] = true;
			if((g_bIsEllisLimitBreaking[iClient] == false) && (g_bCanEllisLimitBreak[iClient] == true))
			{
				g_bIsEllisLimitBreaking[iClient] = true;
				g_bCanEllisLimitBreak[iClient] = false;
				CreateTimer(5.0, TimerEllisLimitBreakReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(65.0, TimerEllisLimitBreakCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
				PrintHintText(iClient, "Double fire rate for 5 seconds; Your weapon will break afterward!");
			}
			else if(g_bEllisLimitBreakInCooldown[iClient] == true)
			{
				PrintHintText(iClient, "LIMIT BREAK is still cooling down");
			}
		}
	}
	if((g_iMetalLevel[iClient] > 0) || (g_iFireLevel[iClient] > 0))
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if((buttons & IN_RELOAD) && g_bClientIsReloading[iClient] == false && g_bForceReload[iClient] == false)
		{
			decl String:currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (IsValidEntity(ActiveWeaponID) == false)
				return;
			new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
				if(iAmmo > 0)
				{
					g_bForceReload[iClient] = true;
					g_iSavedClip[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
					SetEntData(iClient, iOffset_Ammo + 12, iAmmo + g_iSavedClip[iClient]);
				}
			}
			if(((StrEqual(currentweapon, "weapon_smg", false) == true) || (StrEqual(currentweapon, "weapon_smg_silenced", false) == true) || (StrEqual(currentweapon, "weapon_smg_mp5", false) == true)) && (CurrentClipAmmo == 50))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
				if(iAmmo > 0)
				{
					g_bForceReload[iClient] = true;
					g_iSavedClip[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
					SetEntData(iClient, iOffset_Ammo + 20, iAmmo + g_iSavedClip[iClient]);
				}
			}
			if((StrEqual(currentweapon, "weapon_hunting_rifle", false) == true) && (CurrentClipAmmo == 15))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
				if(iAmmo > 0)
				{
					g_bForceReload[iClient] = true;
					g_iSavedClip[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
					SetEntData(iClient, iOffset_Ammo + 36, iAmmo + g_iSavedClip[iClient]);
				}
			}
			if(((StrEqual(currentweapon, "weapon_sniper_awp", false) == true) && (CurrentClipAmmo == 20)) || ((StrEqual(currentweapon, "weapon_sniper_military", false) == true) && (CurrentClipAmmo == 30)) || ((StrEqual(currentweapon, "weapon_sniper_scout", false) == true) && (CurrentClipAmmo == 15)))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
				if(iAmmo > 0)
				{
					g_bForceReload[iClient] = true;
					g_iSavedClip[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
					SetEntData(iClient, iOffset_Ammo + 40, iAmmo + g_iSavedClip[iClient]);
				}
			}
		}
	}
}

OGFSurvivorReload_Ellis(iClient, const char[] currentweapon, ActiveWeaponID, CurrentClipAmmo, iOffset_Ammo)
{
	if(g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY || g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY)
	{
		fnc_DeterminePrimaryWeapon(iClient);
		new String:strCurrentWeapon[32];
		GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
		if((StrContains(strCurrentWeapon, "rifle", false) != -1) || (StrContains(strCurrentWeapon, "smg", false) != -1) || (StrContains(strCurrentWeapon, "shotgun", false) != -1) || (StrContains(strCurrentWeapon, "launcher", false) != -1) || (StrContains(strCurrentWeapon, "sniper", false) != -1))
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
}

EventsHurt_AttackerEllis(Handle:hEvent, iAttacker, iVictim)
{
	if (IsFakeClient(iAttacker))
		return;
	
	if (g_iClientTeam[iVictim] != TEAM_INFECTED)
		return;
	
	if(g_iFireLevel[iAttacker]>0)
	{
		if(g_iClientTeam[iVictim] == TEAM_INFECTED)
		{
			if(g_bUsingFireStorm[iAttacker]==true)
			{
				new Float:time = (float(g_iFireLevel[iAttacker]) * 6.0);
				IgniteEntity(iVictim, time, false);
			}
		}
	}
	
	if(g_iOverLevel[iAttacker] > 0)
	{
		if(g_iClientTeam[iVictim] == TEAM_INFECTED)
		{
			new iCurrentHealth = GetEntProp(iAttacker,Prop_Data,"m_iHealth");
			new iMaxHealth = GetEntProp(iAttacker,Prop_Data,"m_iMaxHealth");
			new iTempHealth = GetSurvivorTempHealth(iAttacker);

			decl String:strWeaponClass[32];
			GetEventString(hEvent,"weapon",strWeaponClass,32);
			//PrintToChatAll("\x03-class of gun: \x01%s",strWeaponClass);
			if ((StrContains(strWeaponClass,"shotgun",false) != -1) || 
				(StrContains(strWeaponClass,"rifle",false) != -1) || 
				(StrContains(strWeaponClass,"pistol",false) != -1) || 
				(StrContains(strWeaponClass,"smg",false) != -1) || 
				(StrContains(strWeaponClass,"sniper",false) != -1) || 
				(StrContains(strWeaponClass,"launcher",false) != -1))
			{
				// Give dmg buff for being in health range for over confidence
				if(iCurrentHealth + iTempHealth >= iMaxHealth - ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT)
				{
					new iVictimHealth = GetEntProp(iVictim,Prop_Data,"m_iHealth");
					// PrintToChatAll("Ellis iVictim %N START HP: %i", iVictim, iVictimHealth);

					new iDmgAmount = GetEventInt(hEvent,"dmg_health");
					new iAddtionalDmg = RoundToNearest(iDmgAmount * (g_iOverLevel[iAttacker] * 0.05));
					SetEntProp(iVictim, Prop_Data,"m_iHealth", iVictimHealth - CalculateDamageTakenForVictimTalents(iVictim, iAddtionalDmg, strWeaponClass));

					// PrintToChatAll("Ellis is doing %i original damage", iDmgAmount);
					// PrintToChatAll("Ellis is doing %i additional OVERCONFIDENCE damage", CalculateDamageTakenForVictimTalents(iVictim, iAddtionalDmg, strWeaponClass));

					// new iVictimHealth2 = GetEntProp(iVictim,Prop_Data,"m_iHealth");
					// PrintToChatAll("Ellis iVictim %N   END HP: %i", iVictim, iVictimHealth2);
				}

				// Give dmg buff for being on adrenaline
				if (g_bEllisHasAdrenalineBuffs[iAttacker])
				{
					new iVictimHealth = GetEntProp(iVictim,Prop_Data,"m_iHealth");
					// PrintToChatAll("Ellis iVictim %N START HP: %i", iVictim, iVictimHealth);

					new iDmgAmount = GetEventInt(hEvent,"dmg_health");
					new iAddtionalDmg = RoundToNearest(iDmgAmount * (g_iOverLevel[iAttacker] * 0.05));
					SetEntProp(iVictim, Prop_Data,"m_iHealth", iVictimHealth - CalculateDamageTakenForVictimTalents(iVictim, iAddtionalDmg, strWeaponClass));

					// PrintToChatAll("Ellis is doing %i original damage", iDmgAmount);
					// PrintToChatAll("Ellis is doing %i additional ADRENALINE damage", CalculateDamageTakenForVictimTalents(iVictim, iAddtionalDmg, strWeaponClass));

					// new iVictimHealth2 = GetEntProp(iVictim,Prop_Data,"m_iHealth");
					// PrintToChatAll("Ellis iVictim %N   END HP: %i", iVictim, iVictimHealth2);
				}
			}
		}
	}
}

EventsHurt_VictimEllis(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(victim))
		return;

	SuppressNeverUsedWarning(attacker);

	new dmgType = GetEventInt(hEvent, "type");
	new dmgHealth  = GetEventInt(hEvent,"dmg_health");

	if(g_iFireLevel[victim] > 0)
	{
		//Prevent Fire Damage
		if(dmgType == DAMAGETYPE_FIRE1 || dmgType == DAMAGETYPE_FIRE2)
		{
			//PrintToChat(victim, "Prevent fire damage");
			new currentHP = GetEventInt(hEvent,"health");
			SetEntProp(victim,Prop_Data,"m_iHealth", dmgHealth + currentHP);
		}
	}

	if(g_iOverLevel[victim] > 0)
	{
		new iCurrentHealth = GetEntProp(victim,Prop_Data,"m_iHealth");
		new iMaxHealth = GetEntProp(victim,Prop_Data,"m_iMaxHealth");
		//new Float:fTempHealth = GetEntDataFloat(victim, g_iOffset_HealthBuffer);
		//if(float(iCurrentHealth) + fTempHealth < (float(iMaxHealth) - float(ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT)))
		if(iCurrentHealth < (iMaxHealth - ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT))
		{
			if(g_bEllisOverSpeedIncreased[victim])
			{
				g_bEllisOverSpeedIncreased[victim] = false;

				SetClientSpeed(victim);
			}
		}
		//else if(float(iCurrentHealth) + fTempHealth > (float(iMaxHealth) - float(ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT)))
		else if(iCurrentHealth >= (iMaxHealth - ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT))
		{
			if(g_bEllisOverSpeedIncreased[victim] == false)
			{
				g_bEllisOverSpeedIncreased[victim] = true;

				SetClientSpeed(victim);						
			}
		}
	}
}

EventsDeath_AttackerEllis(Handle:hEvent, iAttacker, iVictim)
{
	// Handle Ellis's speed boost with the tanks dying
	if (g_iClientTeam[iVictim] == TEAM_INFECTED &&
		g_bEndOfRound == false && 
		RunClientChecks(iVictim) &&
		GetEntProp(iVictim, Prop_Send, "m_zombieClass") == TANK)
	{
		for(new i=1; i <= MaxClients; i++)
		{
			if (g_iChosenSurvivor[i] == ELLIS &&
				g_iJamminLevel[i] > 0 &&
				g_iClientTeam[i] == TEAM_SURVIVORS &&
				RunClientChecks(i) && 
				IsPlayerAlive(i) &&
				IsFakeClient(i) == false)
			{
				SetClientSpeed(i);
				if(g_iTankCounter == 0)
					PrintHintText(i, "You calm down knowing there are no Tanks around.");
			}
		}
	}
	
	// Now start Ellis's attacker abilities
	if (g_iChosenSurvivor[iAttacker] != ELLIS ||
		g_bTalentsConfirmed[iAttacker] != true ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		g_iClientTeam[iVictim] != TEAM_INFECTED ||
		RunClientChecks(iAttacker) == false ||
		IsPlayerAlive(iAttacker) == false)
		return;
	
	SuppressNeverUsedWarning(hEvent);

	if(g_iBringLevel[iAttacker] > 0)
	{
		// Give temp health on SI kill
		AddTempHealthToSurvivor(iAttacker, float(g_iBringLevel[iAttacker]), false);
		
		// Increase clip size
		new iEntid = GetEntDataEnt2(iAttacker, g_iOffset_ActiveWeapon);
		if (iEntid != -1)
		{
			decl String:wclass[32];
			GetEntityNetClass(iEntid, wclass, 32);
			//PrintToChatAll("\x03-class of gun: \x01%s",wclass);
			if (StrContains(wclass,"rifle",false) != -1 || 
				StrContains(wclass,"smg",false) != -1 || 
				StrContains(wclass,"sub",false) != -1 || 
				StrContains(wclass,"sniper",false) != -1)
			{
				new clip = GetEntProp(iEntid,Prop_Data,"m_iClip1");
				clip += g_iBringLevel[iAttacker] * 20;
				// Clamp the clip
				if(clip > 250)
					clip = 250;
				SetEntData(iEntid, g_iOffset_Clip1, clip, true);

				// Whats clip2 do??
				//clip2 = GetEntProp(iEntid,Prop_Data,"m_iClip2"); 			
				//SetEntData(iEntid, clipsize2, clip2+30, true);	
			}
		}
		if(g_iEllisSpeedBoostCounter[iAttacker] < (4 * g_iBringLevel[iAttacker]))
		{
			g_iEllisSpeedBoostCounter[iAttacker]++;
			SetClientSpeed(iAttacker);
		}
	}
}

// EventsDeath_VictimEllis(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

void EventsPillsUsed_Ellis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;

	// PrintToChat(iClient, "Pills Used: %i", GetPlayerWeaponSlot(iClient, 4));

	// Give stashed adrenaline if they have more
	if (g_iStashedInventoryAdrenaline[iClient] > 0)
		CreateTimer(0.1, TimerGiveAdrenalineFromStashedInventory, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

void EventsAdrenalineUsed_Ellis(int iClient)
{
	// Give stashed adrenaline if they have more
	if (g_iStashedInventoryAdrenaline[iClient] > 0)
		CreateTimer(0.1, TimerGiveAdrenalineFromStashedInventory, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

void EventsItemPickUp_Ellis(int iClient, const char[] strWeaponClass)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;

	// PrintToChat(iClient, "ELLIS ITEM PICKUP %s", strWeaponClass);

	if (g_iJamminLevel[iClient] > 0)
	{
		// Save that the health boost was empty on last pick up
		// This is for Ellis's Jamin ability on Player Use event
		if (g_bHealthBoostItemJustGivenByCheats[iClient] == false && 
			(StrEqual(strWeaponClass, "pain_pills", false) == true || 
			StrEqual(strWeaponClass, "adrenaline", false) == true))
			g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] = true;
		
		g_bHealthBoostItemJustGivenByCheats[iClient] = false;
	}

	new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");

	if(g_iMetalLevel[iClient]>0 || g_iFireLevel[iClient]>0)
	{
		//PrintToChat(iClient, "%s", strWeaponClass);
		if (StrContains(strWeaponClass,"rifle",false) != -1 || StrContains(strWeaponClass,"smg",false) != -1 || StrContains(strWeaponClass,"sub",false) != -1 || StrContains(strWeaponClass,"sniper",false) != -1)
		{
			//PrintToChatAll("Inside smg rifle etc.");
			new iEntid = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
			if(iEntid < 1)
				return;
			if(IsValidEntity(iEntid)==false)
				return;
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
	}
	if(g_iWeaponsLevel[iClient] == 5)
	{
		new iWeaponIndex = FindWeaponItemIndex(strWeaponClass, ITEM_CMD_NAME);
		if (iWeaponIndex <= ITEM_EMPTY)
			return;

		// PrintToChatAll("iWeaponIndex: %i, %s", iWeaponIndex, ITEM_CLASS_NAME[iWeaponIndex]);

		if((StrContains(strWeaponClass,"shotgun",false) != -1) || (StrContains(strWeaponClass,"rifle",false) != -1) || (StrContains(strWeaponClass,"smg",false) != -1) || (StrContains(strWeaponClass,"sniper",false) != -1) || (StrContains(strWeaponClass,"launcher",false) != -1))
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
			if(g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY && g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY)
			{
				new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
				if (RunEntityChecks(ActiveWeaponID) == false)
					return;

				//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
				if(g_iEllisCurrentPrimarySlot[iClient] == 0)
				{
					if((StrEqual(strWeaponClass, "rifle", false) == true) || (StrEqual(strWeaponClass, "rifle_ak47", false) == true) || (StrEqual(strWeaponClass, "rifle_sg552", false) == true) || (StrEqual(strWeaponClass, "rifle_desert", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(strWeaponClass, "smg", false) == true) || (StrEqual(strWeaponClass, "smg_mp5", false) == true) || (StrEqual(strWeaponClass, "smg_silenced", false) == true) || (StrEqual(strWeaponClass, "rifle_desert", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(strWeaponClass, "pumpshotgun", false) == true) || (StrEqual(strWeaponClass, "shotgun_chrome", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(strWeaponClass, "autoshotgun", false) == true) || (StrEqual(strWeaponClass, "shotgun_spas", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if(StrEqual(strWeaponClass, "hunting_rifle", false) == true)
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if((StrEqual(strWeaponClass, "sniper_military", false) == true) || (StrEqual(strWeaponClass, "sniper_awp", false) == true) || (StrEqual(strWeaponClass, "sniper_scout", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if(StrEqual(strWeaponClass, "grenade_launcher", false) == true)
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = iAmmo;
					}
					else if(StrEqual(strWeaponClass, "rifle_m60", false) == true)
					{
						//new iAmmo = GetEntData(iClient, iOffset_Ammo);
						g_iEllisPrimarySavedClipSlot1[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot1[iClient] = 0;
					}
				}
				else if(g_iEllisCurrentPrimarySlot[iClient] == 1)
				{
					if((StrEqual(strWeaponClass, "rifle", false) == true) || (StrEqual(strWeaponClass, "rifle_ak47", false) == true) || (StrEqual(strWeaponClass, "rifle_sg552", false) == true) || (StrEqual(strWeaponClass, "rifle_desert", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
						g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
					}
					else if((StrEqual(strWeaponClass, "smg", false) == true) || (StrEqual(strWeaponClass, "smg_mp5", false) == true) || (StrEqual(strWeaponClass, "smg_silenced", false) == true) || (StrEqual(strWeaponClass, "rifle_desert", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 20);
						g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
					}
					else if((StrEqual(strWeaponClass, "pumpshotgun", false) == true) || (StrEqual(strWeaponClass, "shotgun_chrome", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
						g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
					}
					else if((StrEqual(strWeaponClass, "autoshotgun", false) == true) || (StrEqual(strWeaponClass, "shotgun_spas", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
						g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
					}
					else if(StrEqual(strWeaponClass, "hunting_rifle", false) == true)
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 36);
						g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
					}
					else if((StrEqual(strWeaponClass, "sniper_military", false) == true) || (StrEqual(strWeaponClass, "sniper_awp", false) == true) || (StrEqual(strWeaponClass, "sniper_scout", false) == true))
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 40);
						g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
					}
					else if(StrEqual(strWeaponClass, "grenade_launcher", false) == true)
					{
						new iAmmo = GetEntData(iClient, iOffset_Ammo + 68);
						g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot2[iClient] = iAmmo;
					}
					else if(StrEqual(strWeaponClass, "rifle_m60", false) == true)
					{
						//new iAmmo = GetEntData(iClient, iOffset_Ammo);
						g_iEllisPrimarySavedClipSlot2[iClient] = CurrentClipAmmo;
						g_iEllisPrimarySavedAmmoSlot2[iClient] = 0;
					}
				}
			}
			if(g_bIsInEllisInPrimaryCycle[iClient] == true)
			{
				fnc_DeterminePrimaryWeapon(iClient);
				fnc_SetAmmo(iClient);
				fnc_SetAmmoUpgrade(iClient);

				g_bIsInEllisInPrimaryCycle[iClient] = false;
			}
			// Store the waeapon item index
			if (g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY)
			{
				g_iEllisCurrentPrimarySlot[iClient] = 0;
				g_iEllisPrimarySlot0[iClient] = iWeaponIndex;
				
				// PrintToChatAll("pick up: g_iEllisPrimarySlot0[iClient] = %s", ITEM_CLASS_NAME[g_iEllisPrimarySlot0[iClient]]);
			}
			else if (g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY)
			{
				g_iEllisCurrentPrimarySlot[iClient] = 1;
				g_iEllisPrimarySlot1[iClient] = iWeaponIndex;

				// PrintToChatAll("pick_up g_iEllisPrimarySlot1[iClient] = %s", ITEM_CLASS_NAME[g_iEllisPrimarySlot1[iClient]]);
			}
			// Handle when Ellis picks up the same weapon thats in the other slot 0
			else if(g_iEllisCurrentPrimarySlot[iClient] == 0 && iWeaponIndex == g_iEllisPrimarySlot1[iClient])
			{
				g_iEllisPrimarySlot1[iClient] = g_iEllisPrimarySlot0[iClient];
				g_iEllisPrimarySlot0[iClient] = iWeaponIndex;

				g_iEllisPrimarySavedClipSlot2[iClient] = g_iEllisPrimarySavedClipSlot1[iClient];
				g_iEllisPrimarySavedAmmoSlot2[iClient] = g_iEllisPrimarySavedAmmoSlot1[iClient];
			}
			// Handle when Ellis picks up the same weapon thats in the other slot 1
			else if(g_iEllisCurrentPrimarySlot[iClient] == 1 && iWeaponIndex == g_iEllisPrimarySlot0[iClient])
			{
				g_iEllisPrimarySlot0[iClient] = g_iEllisPrimarySlot1[iClient];
				g_iEllisPrimarySlot1[iClient] = iWeaponIndex;

				g_iEllisPrimarySavedClipSlot1[iClient] = g_iEllisPrimarySavedClipSlot2[iClient];
				g_iEllisPrimarySavedAmmoSlot1[iClient] = g_iEllisPrimarySavedAmmoSlot2[iClient];
			}
		}
	}
}

void EventsPlayerUse_Ellis(int iClient, int iTargetID)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;

	// PrintToChat(iClient, "iTargetID: %i", iTargetID);
	// PrintToChat(iClient, "Adrenaline Slot: %i", GetPlayerWeaponSlot(iClient, 4));

	int iSlotItemID = GetPlayerWeaponSlot(iClient, 4);
	// char strSlotItemClassName[35];
	// if (IsValidEntity(iSlotItemID))
	// 	GetEdictClassname(iSlotItemID, strSlotItemClassName, sizeof(strSlotItemClassName));
	// else
	// 	strSlotItemClassName = NULL_STRING;
	// PrintToChat(iClient, "strSlotItemClassName: %s" , strSlotItemClassName);

	// Check if the item when into their weapon slot, if not, then continue to stash it.
	if (g_iJamminLevel[iClient] > 0 && 
		iSlotItemID != iTargetID &&
		g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] == false)
	{
		char strTargetClassName[35];
		GetEdictClassname(iTargetID, strTargetClassName, sizeof(strTargetClassName));
		//PrintToChat(iClient, "strTargetClassName: %s" , strTargetClassName);

		if (StrContains(strTargetClassName,"weapon_adrenaline",false) != -1)
		{
			if (g_iStashedInventoryAdrenaline[iClient] < ELLIS_STASHED_INVENTORY_MAX_ADRENALINE)
			{
				if (iTargetID > 0 && IsValidEntity(iTargetID))
					AcceptEntityInput(iTargetID, "Kill");

				g_iStashedInventoryAdrenaline[iClient]++;
				PrintToChat(iClient, "\x03[XPMod] \x05+1 Adrenaline. \x04You have %i more Adrenaline Shot%s.",
					g_iStashedInventoryAdrenaline[iClient],
					g_iStashedInventoryAdrenaline[iClient] != 1 ? "s" : "");
			}
		}
	}

	g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] = false;
}

void EventsWeaponGiven_Ellis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;

	// Check if the player has the ability, has stashed adrenaline, and also if the weapon given
	if (g_iJamminLevel[iClient] > 0 && g_iStashedInventoryAdrenaline[iClient] > 0)
		CreateTimer(0.1, TimerGiveAdrenalineFromStashedInventory, iClient, TIMER_FLAG_NO_MAPCHANGE);
}


void HandleCheatCommandTasks_Ellis(int iClient, const char [] strCommandWithArgs)
{
	if (g_iChosenSurvivor[iClient] != ELLIS || g_bTalentsConfirmed[iClient] == false)
		return;
	
	// This is for the event ItemPickUp to not recognize this as a player use press pick up
	if (StrEqual(strCommandWithArgs,"give pain_pills",false) == true ||
		StrEqual(strCommandWithArgs,"give adrenaline",false) == true)
		g_bHealthBoostItemJustGivenByCheats[iClient] = true;
}

CyclePlayerWeapon_Ellis(int iClient)
{
	if((g_iEllisCurrentPrimarySlot[iClient] == 0) && g_iEllisPrimarySlot1[iClient] >= ITEM_EMPTY)
	{
		// Remove a laser upgrade counter to prevent flooding the server
		if(g_iLaserUpgradeCounter[iClient] > 0)
			g_iLaserUpgradeCounter[iClient]--;

		// Kill their current weapon before giving new one
		if (g_iPrimarySlotID[iClient] > 0 && IsValidEntity(g_iPrimarySlotID[iClient]))
			AcceptEntityInput(g_iPrimarySlotID[iClient], "Kill");

		if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
		{
			g_iEllisCurrentPrimarySlot[iClient] = 1;
			decl String:strCommandWithArgs[64];
			Format(strCommandWithArgs, sizeof(strCommandWithArgs), "give %s", ITEM_CMD_NAME[g_iEllisPrimarySlot1[iClient]]);
			RunCheatCommand(iClient, "give", strCommandWithArgs);
		}
	}
	else if((g_iEllisCurrentPrimarySlot[iClient] == 1) && g_iEllisPrimarySlot0[iClient] >= ITEM_EMPTY)
	{
		// Remove a laser upgrade counter to prevent flooding the server
		if(g_iLaserUpgradeCounter[iClient] > 0)
			g_iLaserUpgradeCounter[iClient]--;

		// Kill their current weapon before giving new one
		if (g_iPrimarySlotID[iClient] > 0 && IsValidEntity(g_iPrimarySlotID[iClient]))
			AcceptEntityInput(g_iPrimarySlotID[iClient], "Kill");
		
		if (RunClientChecks(iClient) && IsPlayerAlive(iClient))
		{
			g_iEllisCurrentPrimarySlot[iClient] = 0;
			decl String:strCommandWithArgs[64];
			Format(strCommandWithArgs, sizeof(strCommandWithArgs), "give %s", ITEM_CMD_NAME[g_iEllisPrimarySlot0[iClient]]);
			RunCheatCommand(iClient, "give", strCommandWithArgs);
		}
	}
}

HandleEllisSwitchToStashedPrimaryWeapon(iClient)
{
	// Check if Ellis can switch his weapon
	if (g_iWeaponsLevel[iClient] < 5 || 
		g_bCanEllisPrimaryCycle[iClient] == false)
		return;

	// Only continue if the appropriate buttons have been pressed
	new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
	if ( ((buttons & IN_SPEED) && (buttons & IN_ZOOM)) == false )
		return;

	// Only continue if the current weapon is a valid primary
	decl String:currentweapon[512];
	GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
	//PrintToChatAll("Current Weapon is %s", currentweapon);

	if ((StrContains(currentweapon,"shotgun",false) == -1) && 
		(StrContains(currentweapon,"rifle",false) == -1) &&
		(StrContains(currentweapon,"smg",false) == -1) &&
		(StrContains(currentweapon,"sniper",false) == -1) &&
		(StrContains(currentweapon,"launcher",false) == -1))
		return;

	// PrintToChatAll("%s g_iEllisPrimarySlot0[iClient]", g_iEllisPrimarySlot0[iClient]);
	// PrintToChatAll("%s g_iEllisPrimarySlot1[iClient]", g_iEllisPrimarySlot1[iClient]);
	
	// Check that they have a stashed at least one weapon
	if (g_iEllisPrimarySlot0[iClient] == ITEM_EMPTY && 
		g_iEllisPrimarySlot1[iClient] == ITEM_EMPTY)
		return;
	
	//PrintToChatAll("String contains a gun");
	g_bCanEllisPrimaryCycle[iClient] = false;
	g_bIsInEllisInPrimaryCycle[iClient] = true;
	CreateTimer(0.5, TimerEllisPrimaryCycleReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
	//new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);

	//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
	//new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
	//PrintToChatAll("CurrentClipAmmo %d", CurrentClipAmmo);
	fnc_DeterminePrimaryWeapon(iClient);
	fnc_SaveAmmo(iClient);
	CyclePlayerWeapon(iClient);
}
