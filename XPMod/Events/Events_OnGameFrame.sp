/**************************************************************************************************************************
 *                                                    On Game Frame                                                       *
 **************************************************************************************************************************/
 
public OnGameFrame()
{
	if (IsServerProcessing() == false)
		return;
	
	for(new iClient=1;iClient <= MaxClients; iClient++)
	{
		if(IsClientInGame(iClient)==false) continue;
		if(IsFakeClient(iClient)==true) continue;
		if(IsPlayerAlive(iClient)==false) continue;

		// Survivors
		if(g_iClientTeam[iClient] == TEAM_SURVIVORS)		
		{
			// Handle Victim Health Meters
			PrintVictimHealthMeterToSurvivorPlayer(iClient);

			if(g_bIsSmokeInfected[iClient] == true)
			{
				if(IsValidEntity(g_iSmokerInfectionCloudEntity[iClient]))
				{
					decl String:entclass[16];
					GetEntityNetClass(g_iSmokerInfectionCloudEntity[iClient], entclass, 16);
					if(StrEqual(entclass,"CSmokeStack",true) == true)
					{
						decl Float:xyzOrigin[3], Float:xyzAngles[3];
						if(g_bIsSmokeEntityOff == true)
						{
							//DispatchKeyValue(g_iSmokerInfectionCloudEntity[iClient],"Rate", "30");
							GetLocationVectorInfrontOfClient(iClient, xyzOrigin, xyzAngles, 1.0, -25.0);
							
							TeleportEntity(g_iSmokerInfectionCloudEntity[iClient], xyzOrigin, NULL_VECTOR, NULL_VECTOR);
							
							AcceptEntityInput(g_iSmokerInfectionCloudEntity[iClient], "TurnOn");
							g_bIsSmokeEntityOff =  false;
						}
						else
						{
							//DispatchKeyValue(g_iSmokerInfectionCloudEntity[iClient],"Rate", "0");
							GetLocationVectorInfrontOfClient(iClient, xyzOrigin, xyzAngles, 100.0, -25.0);
							
							TeleportEntity(g_iSmokerInfectionCloudEntity[iClient], xyzOrigin, NULL_VECTOR, NULL_VECTOR);
							AcceptEntityInput(g_iSmokerInfectionCloudEntity[iClient], "TurnOff");
							g_bIsSmokeEntityOff = true;
						}
					}
				}
			}
			
			if(g_bIsSurvivorVomiting[iClient] == true)
			{
				new victim = GetClientAimTarget(iClient, true);

				if (RunClientChecks(victim) && 
					g_bIsSurvivorVomiting[victim] == false && 
					IsPlayerAlive(victim) && 
					g_iClientTeam[victim] == TEAM_SURVIVORS)
				{
					decl Float:clientVec[3],Float:victimVec[3];
					GetClientEyePosition(iClient, clientVec);
					GetClientEyePosition(victim, victimVec);
					if(GetVectorDistance(clientVec, victimVec) <= 310.0)
					{
						// Set the attacker to the boomer that vomited on them, otherwise, set to the person vomiting
						new iAttacker = RunClientChecks(g_iVomitVictimAttacker[victim]) ? g_iVomitVictimAttacker[victim] : iClient;
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

				decl String:strCurrentWeapon[32];
				GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
				//PrintToChatAll("Current Weapon is %s", currentweapon);

				new iActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
				new iCurrentClipAmmo = 0;
				if (IsValidEntity(iActiveWeaponID))
					iCurrentClipAmmo = GetEntProp(iActiveWeaponID,Prop_Data,"m_iClip1");
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				
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
	
	//For faster shooting and melee attacks
	if (g_bSomeoneAttacksFaster == true)
		HandleFastAttackingClients();

	// Track tank rocks for special tank abilities
	TrackAllRocks();
}

// This handles the faster weapon attacks for the survivors
HandleFastAttackingClients()
{
	new iArrayLoop = 0;
	while(g_iFastAttackingClientsArray[iArrayLoop] != -1)
	{
		new iClient = g_iFastAttackingClientsArray[iArrayLoop++];

		// Run the basic checks before continuing
		if (g_bDoesClientAttackFast[iClient] == false || 
			RunClientChecks(iClient) == false ||
			IsClientInGame(iClient) == false || 
			IsFakeClient(iClient) == true ||
			g_bTalentsConfirmed[iClient] == false)
		{
			// PrintToServer("DEBUG: Popping from g_iFastAttackingClientsArray");
			pop(iClient);
			continue;
		}

		// Ensure they are an applicable survivor
		if (g_iChosenSurvivor[iClient] != ELLIS &&
			g_iChosenSurvivor[iClient] != ROCHELLE)
			continue;

		// Make sure they have an active weapon
		new iActiveWeaponID = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
		if (iActiveWeaponID == -1)
			continue;
		
		// Grab the current values for the next attack
		// Note that this is used for primary and secondary, despite primary being the named used offset
		float fCurrentNextAttackTime = GetEntDataFloat(iActiveWeaponID, g_iOffset_NextPrimaryAttack);
		// This was used to change depending on if using primary or secondary, but looks like only primary is needed
		//iActiveWeaponSlot == 1 ? GetEntDataFloat(iActiveWeaponID, g_iOffset_NextSecondaryAttack) : GetEntDataFloat(iActiveWeaponID, g_iOffset_NextPrimaryAttack);

		// PrintToChat(iClient, "GameTime: %f", GetGameTime());
		// PrintToChat(iClient, "		diff1: %f", GetGameTime() - fCurrentNextAttackTime);

		// This is a pretty important check for not wasting cycles when player is not shooting.
		// If the current weapon's next attack has already been set to the modified one, then
		// no need to proceed. This should update by itself when the player fires again. Which,
		// in theory, cannot happen until after the current attack has ended.
		if (g_iCurrentFasterAttackWeapon[iClient] == iActiveWeaponID && g_fNextFasterAttackTime[iClient] == fCurrentNextAttackTime)
			continue;

		// Get the slot they are using, then return if it isnt primary or secondary
		int iActiveWeaponSlot = GetActiveWeaponSlot(iClient, iActiveWeaponID);
		if (iActiveWeaponSlot < 0 || iActiveWeaponSlot > 1)
			continue;

		// PrintToChat(iClient, "Fast Attack Checkpoint 2");

		float fGameTime = GetGameTime();
		bool bFastAttackUpdated = false;
		float fAdjustedNextAttackTime = fCurrentNextAttackTime;

		switch (g_iChosenSurvivor[iClient])
		{
			case ELLIS:		bFastAttackUpdated = HandleFastAttackingClients_Ellis(iClient, iActiveWeaponID, iActiveWeaponSlot, fGameTime, fCurrentNextAttackTime, fAdjustedNextAttackTime);
			case ROCHELLE:	bFastAttackUpdated = HandleFastAttackingClients_Rochelle(iClient, iActiveWeaponID, iActiveWeaponSlot, fGameTime, fCurrentNextAttackTime, fAdjustedNextAttackTime);
		}

		// Update the next attack time to be the adjusted value if it was changed
		if (bFastAttackUpdated)
		{
			// PrintToChat(iClient, "Attacking Faster: %f", fAdjustedNextAttackTime);
			g_fNextFasterAttackTime[iClient] = fAdjustedNextAttackTime;
			// Note: even though this could be secondary weapon, you still update using primary offset here
			SetEntDataFloat(iActiveWeaponID, g_iOffset_NextPrimaryAttack, fAdjustedNextAttackTime, true);
		}

		// This is for if they have switched their current faster attacking weapon
		if (g_iCurrentFasterAttackWeapon[iClient] != iActiveWeaponID)
		{
			g_iCurrentFasterAttackWeapon[iClient] = iActiveWeaponID;
			// g_fNextFasterAttackTime[iClient] = fCurrentNextAttackTime;
		}
	}
}