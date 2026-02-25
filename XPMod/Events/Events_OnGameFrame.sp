/**************************************************************************************************************************
 *                                                    On Game Frame                                                       *
 **************************************************************************************************************************/
 
public void OnGameFrame()
{
	if (IsServerProcessing() == false)
		return;
	
	for (int iClient = 1;iClient <= MaxClients; iClient++)
	{
		if(IsClientInGame(iClient)==false) continue;
		if(IsFakeClient(iClient)==true) continue;
		if(IsPlayerAlive(iClient)==false) continue;

		// Survivors
		if(g_iClientTeam[iClient] == TEAM_SURVIVORS)		
		{
			// Handle Victim Health Meters
			PrintVictimHealthMeterToSurvivorPlayer(iClient);
			
			if(g_bIsSurvivorVomiting[iClient] == true)
			{
				int victim = GetClientAimTarget(iClient, true);

				if (RunClientChecks(victim) && 
					g_bIsSurvivorVomiting[victim] == false && 
					IsPlayerAlive(victim) && 
					g_iClientTeam[victim] == TEAM_SURVIVORS)
				{
					float clientVec[3], victimVec[3];
					GetClientEyePosition(iClient, clientVec);
					GetClientEyePosition(victim, victimVec);
					if(GetVectorDistance(clientVec, victimVec) <= 310.0)
					{
						// Set the attacker to the boomer that vomited on them, otherwise, set to the person vomiting
						int iAttacker = RunClientChecks(g_iVomitVictimAttacker[victim]) ? g_iVomitVictimAttacker[victim] : iClient;
						SDKCall(g_hSDK_VomitOnPlayer, victim, iAttacker, true);
						CreateParticle("boomer_vomit", 2.0, victim, ATTACH_MOUTH, true);
						g_bIsSurvivorVomiting[victim] = true;
						g_iShowSurvivorVomitCounter[victim] = 3;
						CreateTimer(1.0, TimerConstantVomitDisplay, victim, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
			
			if(g_bGameFrozen == true)
			{
				// Stop frozen player from using health items
				int weapon = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
				if(weapon > 0)
				{
					char wclass[32];
					GetEntityNetClass(weapon,wclass,32);
					if((StrEqual(wclass,"CPainPills",false)==true) || (StrEqual(wclass,"CFirstAidKit",false)==true) || (StrEqual(wclass,"CItemDefibrillator",false)==true) || (StrEqual(wclass,"CItem_Adrenaline",false)==true))
					{
						ClientCommand(iClient, "slot0");
						ClientCommand(iClient, "slot2");
						PrintToChat(iClient, "\x03[XPMod]\x05 You cannot use health items when frozen");
					}
				}
			}
			
			// Handle Survivor On Game Frame Talents
			switch(g_iChosenSurvivor[iClient])
			{
				case BILL:		OnGameFrame_Bill(iClient);
				case ROCHELLE:	OnGameFrame_Rochelle(iClient);
				case COACH:		OnGameFrame_Coach(iClient);
				case ELLIS:		OnGameFrame_Ellis(iClient);
				case NICK:		OnGameFrame_Nick(iClient);
			}

			// OnGameFrame Reloads
			if(g_bClientIsReloading[iClient] == true)
			{
				g_iReloadFrameCounter[iClient]++;
				//PrintToChatAll("Frame counter %d", g_iReloadFrameCounter[iClient]);

				char strCurrentWeapon[32];
				GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
				//PrintToChatAll("Current Weapon is %s", currentweapon);

				int iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
				int iCurrentClipAmmo = 0;
				if (IsValidEntity(iActiveWeaponID))
					iCurrentClipAmmo = GetEntProp(iActiveWeaponID,Prop_Data,"m_iClip1");
				int iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				
				switch(g_iChosenSurvivor[iClient])
				{
					case BILL:		OGFSurvivorReload_Bill(iClient, strCurrentWeapon, iActiveWeaponID, iCurrentClipAmmo, iOffset_Ammo);
					case ROCHELLE:	OGFSurvivorReload_Rochelle(iClient, strCurrentWeapon, iActiveWeaponID, iCurrentClipAmmo, iOffset_Ammo);
					case COACH:		OGFSurvivorReload_Coach(iClient, strCurrentWeapon, iActiveWeaponID, iCurrentClipAmmo, iOffset_Ammo);
					case ELLIS:		OGFSurvivorReload_Ellis(iClient, strCurrentWeapon, iActiveWeaponID, iCurrentClipAmmo, iOffset_Ammo);
					case NICK:		OGFSurvivorReload_Nick(iClient, strCurrentWeapon, iActiveWeaponID, iCurrentClipAmmo);
					case LOUIS:		OGFSurvivorReload_Louis(iClient, strCurrentWeapon, iActiveWeaponID, iCurrentClipAmmo,iOffset_Ammo);
				}

				if(g_iReloadFrameCounter[iClient] == 300)
				{
					g_bClientIsReloading[iClient] = false;
					g_iReloadFrameCounter[iClient] = 0;
					g_bCoachShotgunForceReload[iClient] = false;
				}
			}
		}
		// Infected
		else if(g_iClientTeam[iClient] == TEAM_INFECTED)
		{
			//Check if they are ghost first
			if(GetEntData(iClient, g_iOffset_IsGhost, 1) == 1)	
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
	
	// //For faster shooting and melee attacks
	// if (g_bSomeoneAttacksFaster == true)
	// 	HandleFastAttackingClients();

	// Track tank rocks for special tank abilities
	TrackAllRocks();

	if (g_iBillGlobalTauntCooldown > 0)
	{
		g_iBillGlobalTauntCooldown--;
	}
}
