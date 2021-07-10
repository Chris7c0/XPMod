void Bind2Press_Smoker(iClient)
{
	if ((g_iClientInfectedClass1[iClient] != SMOKER) &&
		(g_iClientInfectedClass2[iClient] != SMOKER) &&
		(g_iClientInfectedClass3[iClient] != SMOKER))
	{
		PrintHintText(iClient, "You dont have the Smoker as one of your classes");
		return;
	}
	
	if (g_iDirtyLevel[iClient] <= 0)
	{
		PrintHintText(iClient, "You must have Dirty Tricks (Level 1) for Smoker Bind 2");
		return;
	}
		
	if (g_iClientBindUses_2[iClient] >= 3)
	{
		PrintHintText(iClient, "You are out of Bind 2 uses.");
		return;
	}

	if(g_iChokingVictim[iClient] < 0 || IsClientInGame(g_iChokingVictim[iClient]) == false)
	{
		PrintHintText(iClient, "You must be choking a victim to use your Bind 2.");
		return;
	}

	//CatchAndReleasePlayer(iClient);

	ElectrocutePlayer(iClient);
}

SmokerDismount(iClient)
{
	g_bMovementLocked[iClient] = true;
	SetClientSpeed(iClient);
	SetPlayerMoveType(iClient, MOVETYPE_NOCLIP);
	// Note this needs to be done with some delay for it to work
	CreateTimer(0.1, TimerResetPlayerMoveType, iClient);
}

CatchAndReleasePlayer(iClient)
{
	SmokerDismount(iClient);
	EntangleSurvivorInSmokerTongue(g_iChokingVictim[iClient]);
}

EntangleSurvivorInSmokerTongue(iClient)
{
	PrintToChatAll("Entangling %N", iClient);

	g_bIsEntangledInSmokerTongue[iClient] = true;

	// Probably remove all these and just use g_bIsEntangledInSmokerTongue
	//g_bStopAllInput[iClient] = true;
	g_bMovementLocked[iClient] = true;
	SetPlayerMoveType(iClient, MOVETYPE_NOCLIP);
	SetClientSpeed(iClient);
	LockPlayerFromAttacking(iClient);
	CreateEntangledSurvivorClone(iClient);

	// AcceptEntityInput(iClient, "TurnOff");

	GotoThirdPerson(iClient);



	delete g_hTimer_UntangleSurvivorCheck[iClient];
	g_hTimer_UntangleSurvivorCheck[iClient] = CreateTimer(0.5, TimerCheckIfPlayerIsInRangeToUntangle, iClient, TIMER_REPEAT);

	decl Float:xyzLocation[3];
	GetClientAbsOrigin(iClient, xyzLocation);
	SendAllSurvivorBotsFocusedOnXPMGoal(xyzLocation, iClient);

	// Prevent bots from teleporting:
	if (IsFakeClient(iClient) == true)
		SetConVarInt(FindConVar("sb_enforce_proximity_range"), CONVAR_SB_ENFORCE_PROXIMITY_RANGE_MAX);
}

UntangleSurvivorFromSmokerTongue(iClient)
{
	g_bIsEntangledInSmokerTongue[iClient] = false;
	g_bStopAllInput[iClient] = false;
	g_bMovementLocked[iClient] = false;
	SetClientSpeed(iClient);
	SetPlayerMoveType(iClient, MOVETYPE_WALK);
	UnlockPlayerFromAttacking(iClient);

	//Unhook the model ontakedamage since its not longer needed
	if (RunEntityChecks(KillEntitySafely(g_iEntangledSurvivorModelIndex[iClient])))
		SDKUnhook(EntIndexToEntRef(g_iEntangledSurvivorModelIndex[iClient]), SDKHook_OnTakeDamage, OnTakeDamage);

	//Delete the clone of the model and tongue
	KillEntitySafely(g_iEntangledSurvivorModelIndex[iClient]);
	KillEntitySafely(g_iEntangledTongueModelIndex[iClient]);
	g_iEntangledSurvivorModelIndex[iClient] = -1;
	g_iEntangledTongueModelIndex[iClient] = -1;


	// Set player back to first person mode
	GotoFirstPerson(iClient);

	// AcceptEntityInput(iClient, "TurnOn");

	// Make player visible again
	SetEntityRenderMode(iClient, RenderMode:RENDER_MODE_NORMAL);

	// TODO Fix this for player transparency (bills suit)



	// Set the goal acomplished for all the bots that were searching for this player
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (g_iBotXPMGoalTarget[iPlayer] == iClient)
		{
			PrintToServer("Goal accomplished for %i", iPlayer);
			g_bBotXPMGoalAccomplished[iPlayer] = true;

			// Now that the goal is accomplished if there are other viable goals, 
			// then set them to focus on those.
			for (int iTarget = 1; iTarget <= MaxClients; iTarget++)
			{
				if (g_bIsEntangledInSmokerTongue[iTarget] == true)
				{
					decl Float:xyzLocation[3];
					GetClientAbsOrigin(iTarget, xyzLocation);
					SetBotFocusedOnXPMGoal(iPlayer, xyzLocation, iTarget);
				}
			}
		}
	}


	// Check all other bots to see if there are any that are entangled, if not then reset the convar for teleporting to default
	if (CheckIfAnyBotsAreEntangled() == false)
		SetConVarInt(FindConVar("sb_enforce_proximity_range"), CONVAR_SB_ENFORCE_PROXIMITY_RANGE_DEFAULT);
}

Action TimerCheckIfPlayerIsInRangeToUntangle(Handle:timer, int iClient)
{
	if (g_bIsEntangledInSmokerTongue[iClient] == false ||
		RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
	{
		UntangleSurvivorFromSmokerTongue(iClient);
		
		g_hTimer_UntangleSurvivorCheck[iClient] = null;
		return Plugin_Stop;
	}

	decl Float:xyzClientLocation[3];
	GetClientAbsOrigin(iClient, xyzClientLocation);

	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
	{
		if (iPlayer == iClient ||
			RunClientChecks(iPlayer) == false ||
			g_iClientTeam[iPlayer] != TEAM_SURVIVORS ||
			IsPlayerAlive(iPlayer) == false ||
			IsClientGrappled(iPlayer) == true)
			continue;

		decl Float:xyzPlayerLocation[3];
		GetClientAbsOrigin(iPlayer, xyzPlayerLocation);

		//PrintToChatAll("distance: %f ", GetVectorDistance(xyzClientLocation, xyzPlayerLocation, false));

		//Check if the player is in range of the client that is tangled
		if (GetVectorDistance(xyzClientLocation, xyzPlayerLocation, false) > SMOKER_UNTANGLE_PLAYER_DISTANCE)
			continue;
		
		UntangleSurvivorFromSmokerTongue(iClient);

		g_hTimer_UntangleSurvivorCheck[iClient] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

bool CheckIfAnyBotsAreEntangled()
{
	// Check all other bots to see if there are any that are entangled, if not then reset the convar for teleporting to default
	for (int iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
		if (g_bIsEntangledInSmokerTongue[iPlayer] == true &&
			RunClientChecks(iPlayer) == true &&
			g_iClientTeam[iPlayer] == TEAM_SURVIVORS &&
			IsPlayerAlive(iPlayer) == true)
			return true;

	return false;
}

Action TimerResetPlayerMoveType(Handle:timer, int iClient)
{
	g_bMovementLocked[iClient] = false;
	SetClientSpeed(iClient);
	SetPlayerMoveType(iClient);
	return Plugin_Stop;
}

int SetPlayerMoveType(int iClient, int iMoveType = MOVETYPE_WALK)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return -1;

	SetEntProp(iClient, Prop_Send, "movetype", iMoveType, 1);

	PrintToChat(iClient, "movetype now %i", GetEntProp(iClient, Prop_Send, "movetype", 1));

	return  GetEntProp(iClient, Prop_Send, "movetype", 1);
}

CreateEntangledSurvivorClone(int iClient)
{
	char strModel[PLATFORM_MAX_PATH];
	GetEntPropString(iClient, Prop_Data, "m_ModelName", strModel, sizeof(strModel));

	// Create survivor model that will be entangled
	int iClone = CreateEntityByName("commentary_dummy");
	if (RunEntityChecks(iClone))
	{
		// Set the global reference that can be removed later
		g_iEntangledSurvivorModelIndex[iClient] = iClone;

		SetEntityModel(iClone, strModel);
		
		// Attach to survivor
		// SetVariantString("!activator");
		// AcceptEntityInput(iClone, "SetParent", iClient);
		// SetVariantString("bleedout");
		// AcceptEntityInput(iClone, "SetParentAttachment");

		// Get location the model should be placed
		float xyzLocation[3], xyzAngles[3];
		GetClientAbsOrigin(iClient, xyzLocation);
		GetClientAbsAngles(iClient, xyzAngles);

		// Set angles and origin
		TeleportEntity(iClone, xyzLocation, xyzAngles, NULL_VECTOR);

		// Set playback rate for animation
		SetEntPropFloat(iClone, Prop_Send, "m_flPlaybackRate", 1.0);
		// Set the actual animation
		SetVariantString("Idle_Tongued_choking_ground")
		AcceptEntityInput(iClone, "SetAnimation");

		SetEntProp(iClone, Prop_Send, "m_nSolidType", 1);

		// Hook the model so hits will register
		SDKHook(iClone, SDKHook_OnTakeDamage, OnTakeDamage);
		PrintToServer("HOOKING %i, %i", iClone, EntIndexToEntRef(iClone));
	}

	// Create the smoker tongue that wraps around the survivor
	int iSmokerTongue = CreateEntityByName("prop_dynamic");
	if (RunEntityChecks(iSmokerTongue))
	{
		// Set the global reference that can be removed later
		g_iEntangledTongueModelIndex[iClient] = iSmokerTongue;

		SetEntityModel(iSmokerTongue, "models/infected/smoker_tongue_attach.mdl");

		SetVariantString("!activator");
		AcceptEntityInput(iSmokerTongue, "SetParent", iClone);

		TeleportEntity(iSmokerTongue, EMPTY_VECTOR, EMPTY_VECTOR, NULL_VECTOR);

		// Set playback rate for animation
		SetEntPropFloat(iSmokerTongue, Prop_Send, "m_flPlaybackRate", 1.0);
		// Set the actual animation
		SetVariantString("NamVet_idle_ground_smokerchoke")
		AcceptEntityInput(iSmokerTongue, "SetAnimation");

		// AttachParticle(iSmokerTongue, "tongue_wrap", 10.0);
		// AttachParticle(iSmokerTongue, "smoker_tongue", 10.0);
		// AttachParticle(iSmokerTongue, "smoker_tongue_joint", 10.0);
		//tongue_wrap
		//smoker_tongue
		//smoker_tongue_joint
	}

	// Make Survivor Invisible
	SetEntityRenderMode(iClient, RENDER_NONE);

	// Disable Glow
	SetEntProp(iClient, Prop_Send, "m_bSurvivorGlowEnabled", 0);

	// Hide weapons
}

void GotoThirdPerson(int iClient)
{
	SetEntPropEnt(iClient, Prop_Send, "m_hObserverTarget", 0);
	SetEntProp(iClient, Prop_Send, "m_iObserverMode", 1);
	SetEntProp(iClient, Prop_Send, "m_bDrawViewmodel", 0);
}

void GotoFirstPerson(int iClient)
{
	SetEntPropEnt(iClient, Prop_Send, "m_hObserverTarget", -1);
	SetEntProp(iClient, Prop_Send, "m_iObserverMode", 0);
	SetEntProp(iClient, Prop_Send, "m_bDrawViewmodel", 1);
}

void LockPlayerFromAttacking(int iClient)
{
	PrintToChat(iClient, "LockPlayerFromAttacking start");
	new iWeaponEntity = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
	if (RunEntityChecks(iWeaponEntity) == false)
		return;
	
	//float flNextTime_ret = GetEntDataFloat(iWeaponEntity,g_iOffset_NextPrimaryAttack);

	SetEntDataFloat(iWeaponEntity, g_iOffset_TimeWeaponIdle, 999999.9, true);
	SetEntDataFloat(iWeaponEntity, g_iOffset_NextPrimaryAttack, 999999.0, true);
	SetEntDataFloat(iClient, g_iOffset_NextAttack, 999999.0, true);

	PrintToChat(iClient, "LockPlayerFromAttacking end");
}

void UnlockPlayerFromAttacking(int iClient)
{
	PrintToChat(iClient, "UnlockPlayerFromAttacking start");
	new iWeaponEntity = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
	if (RunEntityChecks(iWeaponEntity) == false)
		return;
	
	//float flNextTime_ret = GetEntDataFloat(iWeaponEntity,g_iOffset_NextPrimaryAttack);

	float fGameTime = GetGameTime();

	SetEntDataFloat(iWeaponEntity, g_iOffset_TimeWeaponIdle, fGameTime, true);
	SetEntDataFloat(iWeaponEntity, g_iOffset_NextPrimaryAttack, fGameTime, true);
	SetEntDataFloat(iClient, g_iOffset_NextAttack, fGameTime, true);

	PrintToChat(iClient, "UnlockPlayerFromAttacking end");
}


ElectrocutePlayer(iClient)
{
	if(g_bElectricutionCooldown[iClient] == true)
	{
		PrintHintText(iClient, "You must wait for your electricity to charge back up again.");
		return;
	}

	if(g_bIsElectricuting[iClient] == true)
	{
		PrintHintText(iClient, "You are already electricuting a victim.");
		return;
	}

	// Electrocute	
	g_bIsElectricuting[iClient] = true;
	g_bElectricutionCooldown[iClient] = true;
	CreateTimer(15.0, Timer_ResetElectricuteCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	g_iClientBindUses_2[iClient]++;
	
	decl Float:clientloc[3],Float:targetloc[3];
	GetClientEyePosition(iClient,clientloc);
	GetClientEyePosition(g_iChokingVictim[iClient],targetloc);
	clientloc[2] -= 10.0;
	targetloc[2] -= 20.0;
	new rand = GetRandomInt(1, 3);
	decl String:zap[23];
	switch(rand)
	{
		case 1: zap = SOUND_ZAP1; 
		case 2: zap = SOUND_ZAP2;
		case 3: zap = SOUND_ZAP3;
	}
	new pitch = GetRandomInt(95, 130);
	EmitSoundToAll(zap, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, clientloc, NULL_VECTOR, true, 0.0);
	EmitSoundToAll(zap, g_iChokingVictim[iClient], SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, targetloc, NULL_VECTOR, true, 0.0);
	TE_SetupBeamPoints(clientloc,targetloc,g_iSprite_Laser,0,0,66,0.3, 0.5, 0.5,0,4.0,{0,40,255,200},0);
	TE_SendToAll();
	CreateParticle("electrical_arc_01_system", 1.5, g_iChokingVictim[iClient], ATTACH_EYES, true);

	new alpha = GetRandomInt(80,140);										
	ShowHudOverlayColor(iClient, 255, 255, 255, alpha, 150, FADE_OUT);
	ShowHudOverlayColor(g_iChokingVictim[iClient], 255, 255, 255, alpha, 150, FADE_OUT);
	
	DealDamage(g_iChokingVictim[iClient], iClient, g_iDirtyLevel[iClient]);
	
	g_iClientXP[iClient] += 10;
	CheckLevel(iClient);
	
	if(g_iXPDisplayMode[iClient] == 0)
		ShowXPSprite(iClient, g_iSprite_10XP_SI, g_iChokingVictim[iClient], 1.0);
	
	decl i;
	for(i = 1;i <= MaxClients;i++)
	{
		if(i == g_iChokingVictim[iClient])
			continue;
		
		if(g_iChokingVictim[iClient] < 1 || IsValidEntity(i) == false || IsValidEntity(g_iChokingVictim[iClient]) == false)
			continue;
		
		if(IsClientInGame(i) && g_iClientTeam[i] == TEAM_SURVIVORS)
		{
			GetClientEyePosition(g_iChokingVictim[iClient], clientloc);
			GetClientEyePosition(i, targetloc);
			
			if(IsVisibleTo(clientloc, targetloc))
			{
				targetloc[2] -= 20.0;
				rand = GetRandomInt(1, 3);
				switch(rand)
				{
					case 1: zap = SOUND_ZAP1; 
					case 2: zap = SOUND_ZAP2;
					case 3: zap = SOUND_ZAP3;
				}
				pitch = GetRandomInt(95, 130);
				EmitSoundToAll(zap, i, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, pitch, -1, targetloc, NULL_VECTOR, true, 0.0);
				TE_SetupBeamPoints(clientloc,targetloc,g_iSprite_Laser,0,0,66,0.3, 0.5, 0.5,0,4.0,{0,40,255,200},0);
				TE_SendToAll();
				CreateParticle("electrical_arc_01_system", 0.8, i, ATTACH_EYES, true);
				
				alpha = GetRandomInt(120, 180);					
				ShowHudOverlayColor(i, 255, 255, 255, alpha, 150, FADE_OUT);
				
				DealDamage(i , iClient, RoundToCeil((g_iDirtyLevel[iClient] * 0.5)));
				
				g_iClientXP[iClient] += 10;
				CheckLevel(iClient);
				
				if(g_iXPDisplayMode[iClient] == 0)
					ShowXPSprite(iClient, g_iSprite_10XP_SI, i, 1.0);
			}
		}
	}
	
	CreateTimer(0.5, TimerElectricuteAgain, iClient, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.9, TimerStopElectricution, iClient, TIMER_FLAG_NO_MAPCHANGE);
}