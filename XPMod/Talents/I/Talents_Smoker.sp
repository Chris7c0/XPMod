void TalentsLoad_Smoker(int iClient)
{
	if(g_iSmokerTalent1Level[iClient] > 0)
	{
		if(g_bHasInfectedHealthBeenSet[iClient] == false)
		{
			g_bHasInfectedHealthBeenSet[iClient] = true;
			SetPlayerMaxHealth(iClient, (g_iSmokerTalent1Level[iClient] * SMOKER_BONUS_MAX_HEALTH_PER_LEVEL), true);
		}
	}

	// Doppelganger Decoy clones
	g_fNextSmokerDoppelgangerRegenTime[iClient] = GetGameTime() + SMOKER_DOPPELGANGER_REGEN_PERIOD;
	g_bSmokerDoppelgangerCoolingDown[iClient] = false;

	// Smoker variable reset if left from other states
	if (g_iSmokerSmokeCloudPlayer == iClient || g_iSmokerInSmokeCloudLimbo == iClient)
	{
		g_iSmokerSmokeCloudPlayer = -1;
		g_iSmokerInSmokeCloudLimbo = -1;
	}
	g_bTeleportCoolingDown[iClient] = false;

	//Grapples reset
	g_bSmokerGrappled[iClient] = false;
	g_iChokingVictim[iClient] = -1;

	// Enable global smoker tongue console variable buffs
	SetSmokerConvarBuffs(FindHighestLevelSmokerAlive());

	if(g_iSmokerTalent1Level[iClient] > 0)
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Smoker Talents \x05have been loaded.");
	if(g_iSmokerTalent2Level[iClient] > 0)
		SetClientSpeed(iClient);
}

void OnGameFrame_Smoker(int iClient)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iSmokerTalent1Level[iClient] <= 0)
		return;

	// Regeneration of Smoker Doppelganger Decoy Clones
	if(g_iSmokerDoppelgangerCount[iClient] < SMOKER_DOPPELGANGER_MAX_CLONES && 
		g_fNextSmokerDoppelgangerRegenTime[iClient] <= GetGameTime())
	{
		g_iSmokerDoppelgangerCount[iClient]++;
		g_fNextSmokerDoppelgangerRegenTime[iClient] = GetGameTime() + SMOKER_DOPPELGANGER_REGEN_PERIOD;
		
		// Display message, but dont display the message if a smoker smoke cloud
		if (g_iSmokerSmokeCloudPlayer != iClient && g_iSmokerInSmokeCloudLimbo != iClient)
			PrintHintText(iClient, "Doppelganger Decoys: %i", g_iSmokerDoppelgangerCount[iClient]);
	}
	

	if(g_iSmokerTalent3Level[iClient] > 0 && g_iSmokerTransparency[iClient] != 0)
	{
		if(g_iSmokerTransparency[iClient] > 1)
		{
			g_iSmokerTransparency[iClient]--;
			SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iSmokerTransparency[iClient]) / 300))));		//300 because 10 total levels * 30 fps = 10 seconds
		}
		else
		{
			g_iSmokerTransparency[iClient] = 0;
			SetEntityRenderMode(iClient, RenderMode:0);
			SetEntityRenderColor(iClient, 255, 255, 255, 255);
		}
	}

	// This is potentially causing a glitch where the player is stuck afterwards.
	// The movement type can be set away from no clip from other events this just resets it every tick if its not
	if ((g_iSmokerSmokeCloudPlayer == iClient || g_iSmokerInSmokeCloudLimbo == iClient) &&
		GetEntProp(iClient, Prop_Send, "movetype") != MOVETYPE_NOCLIP)
	{
		LockPlayerFromAttacking(iClient);
		SetPlayerMoveType(iClient, MOVETYPE_NOCLIP);
	}
}

bool OnPlayerRunCmd_Smoker(int iClient, int &iButtons)
{
	// Smoker abilities
	if (g_iInfectedCharacter[iClient] != SMOKER ||
		g_iSmokerTalent3Level[iClient] <= 0 ||
		g_bIsGhost[iClient] == true ||
		g_iClientTeam[iClient] != TEAM_INFECTED || 
		RunClientChecks(iClient) == false ||
		g_bTalentsConfirmed[iClient] == false ||
		g_bGameFrozen == true)
		return false;

	// Smoker Teleport
	if (g_bTeleportCoolingDown[iClient] == false &&
		g_iChokingVictim[iClient] <= 0 &&
		iButtons & IN_SPEED)
		SmokerTeleport(iClient);

	// Smoker Dismount
	// Check if button is released before doing this Smoker dismount
	if (g_iChokingVictim[iClient] > 0 &&
		GetEntProp(iClient, Prop_Data, "m_afButtonReleased") & IN_ATTACK)
		g_bReadyForDismountButtonPress[iClient] = true;
	// Once the button is released and they click again, do the dismount
	if (g_iChokingVictim[iClient] > 0 &&
		g_bReadyForDismountButtonPress[iClient] == true &&
		iButtons & IN_ATTACK)
		SmokerDismount(iClient);

	// Toggle Cloaking
	if (g_iChokingVictim[iClient] > 0 &&
		g_bSmokerCloakingJustToggled[iClient] == false &&
		iButtons & IN_DUCK)
		ToggleSmokerCloaking(iClient);

	// Toggle Cloaking Button Release
	if (g_bSmokerCloakingJustToggled[iClient] == true &&
		GetEntProp(iClient, Prop_Data, "m_afButtonReleased") & IN_DUCK)
		g_bSmokerCloakingJustToggled[iClient] = false;

	// Creating Smoker Doppelganger clone
	if (g_iSmokerDoppelgangerCount[iClient] > 0 &&
		g_bSmokerDoppelgangerCoolingDown[iClient] == false &&
		iButtons & IN_RELOAD)
		CreateSmokerDoppelganger(iClient);

	// Create Smoke Screen around the victim
	if (g_iChokingVictim[iClient] > 0 &&
		iButtons & IN_SPEED)
		CreateSmokeScreenAroundVictim(iClient);
	
	return false;
}


void EventsHurt_AttackerSmoker(Handle hEvent, int iAttacker, int iVictim)
{
	if (IsFakeClient(iAttacker))
		return;

	if (g_iClientTeam[iVictim] != TEAM_SURVIVORS)
		return;
	
	char strWeapon[20];
	GetEventString(hEvent,"weapon", strWeapon, 20);

	// If the smoker is somehow in limbo or a smoke cloud, then kick them out.
	ReturnSmokerFromSmokeCloudIfCurrentlySmokeCloud(iVictim);
}

void EventsDeath_VictimSmoker(Handle hEvent, int iAttacker, int iVictim)
{
	if (g_iInfectedCharacter[iVictim] != SMOKER ||
		g_iClientTeam[iVictim] != TEAM_INFECTED)
		return;

	// Check if there are any more smoker ability clients alive
	// If not, then reset smoker convar buffs to default
	// Note this needs to be done any time a smoker dies.
	SetSmokerConvarBuffs(FindHighestLevelSmokerAlive());

	// If the smoker is somehow in limbo or a smoke cloud, then kick them out.
	ReturnSmokerFromSmokeCloudIfCurrentlySmokeCloud(iVictim);

	if (g_bTalentsConfirmed[iVictim] == false ||
		(g_iClientInfectedClass1[iVictim] != SMOKER &&
		g_iClientInfectedClass2[iVictim] != SMOKER &&
		g_iClientInfectedClass3[iVictim] != SMOKER) ||
		RunClientChecks(iVictim) == false ||
		IsFakeClient(iVictim) == true)
		return;

	SuppressNeverUsedWarning(hEvent, iAttacker);

	if(g_iSmokerTalent2Level[iVictim] > 0)
	{
		g_bHasSmokersPoisonCloudOut[iVictim] = true;
		GetClientEyePosition(iVictim, g_xyzPoisonCloudOriginArray[iVictim]);
		CreateTimer(0.1, TimerPoisonCloud, iVictim, TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer( (float(g_iSmokerTalent2Level[iVictim]) * 2.0), TimerStopPoisonCloud, iVictim, TIMER_FLAG_NO_MAPCHANGE);
	}
}

bool Event_TongueGrab_Smoker(int iAttacker, int iVictim)
{
	// Before proceeding check to ensure they have smoker talent confirmed
	if (g_bTalentsConfirmed[iAttacker] == false ||
		g_iSmokerTalent2Level[iAttacker] <= 0)
		return false;

	// If the smoker is somehow in limbo or a smoke cloud, then kick them out.
	ReturnSmokerFromSmokeCloudIfCurrentlySmokeCloud(iAttacker);

	g_bSmokerIsCloaked[iAttacker] = true;
	g_bSmokerVictimGlowDisabled[iVictim] = true;
	SetClientRenderAndGlowColor(iAttacker);

	return false;
}

bool Event_TongueRelease_Smoker(int iAttacker, int iVictim)
{
	// Before proceeding check to ensure they have smoker talent confirmed
	if (g_bTalentsConfirmed[iAttacker] == false ||
		g_iSmokerTalent1Level[iAttacker] <= 0)
		return false;

	SuppressNeverUsedWarning(iVictim);

	// Reset the smokers opacity
	g_bSmokerIsCloaked[iAttacker] = false;
	// Reset the victims glow
	g_bSmokerVictimGlowDisabled[iVictim] = false;
	SetClientRenderAndGlowColor(iAttacker);

	SetEntityMoveType(iAttacker, MOVETYPE_CUSTOM);
	SetClientSpeed(iAttacker);

	// Set the cooldown to enable the next tongue ability faster
	SetSIAbilityCooldown(iAttacker, SMOKER_DEFAULT_TONGUE_COOLDOWN - (RoundToNearest(g_iSmokerTalent1Level[iAttacker] / 3.0) * SMOKER_COOLDOWN_REDUCTION_EVERY_OTHER_LEVEL) );

	return false;
}



bool Event_ChokeStart_Smoker(int iAttacker, int iVictim)
{
	// Before proceeding check to ensure they have smoker talent confirmed
	if (g_bTalentsConfirmed[iAttacker] == false ||
		g_iSmokerTalent1Level[iAttacker] <= 0)
		return false;

	SuppressNeverUsedWarning(iVictim);

	// If the smoker is somehow in limbo or a smoke cloud, then kick them out.
	ReturnSmokerFromSmokeCloudIfCurrentlySmokeCloud(iAttacker);

	// Set ability for smoker to move
	SetEntityMoveType(iAttacker, MOVETYPE_ISOMETRIC);
	SetClientSpeed(iAttacker);

	if(g_iSmokerTalent2Level[iAttacker] <= 0)
		return false;

	SetClientRenderAndGlowColor(iAttacker);

	// If the player is holding the primary attack button down, then
	// make sure they release it later by first setting this flag
	int buttons;
	buttons = GetEntProp(iAttacker, Prop_Data, "m_nButtons", buttons);
	g_bReadyForDismountButtonPress[iAttacker] = (buttons & IN_ATTACK) ? false : true;

	return false;
}

int FindHighestLevelSmokerAlive()
{
	int iHighestLevel = 0;
	for (int iClient=1; iClient<=MaxClients; iClient++)
		if (g_iSmokerTalent1Level[iClient] > iHighestLevel &&
			g_bTalentsConfirmed[iClient] == true &&
			g_iClientTeam[iClient] == TEAM_INFECTED &&
			RunClientChecks(iClient) == true &&
			IsPlayerAlive(iClient) == true &&
			IsFakeClient(iClient) == false)
			iHighestLevel = g_iSmokerTalent1Level[iClient];

	return iHighestLevel;
}

// Setting iLevel to 0 will set to the default values
void SetSmokerConvarBuffs(int iLevel = 0)
{
	SetConVarFloat(FindConVar("tongue_range"), 
		float(CONVAR_SMOKER_TONGUE_RANGE_DEFAULT + (iLevel * CONVAR_SMOKER_TONGUE_RANGE_BUFF_PER_LEVEL)), false, false);
	SetConVarFloat(FindConVar("tongue_fly_speed"), 
		float(CONVAR_SMOKER_TONGUE_FLY_SPEED_DEFAULT + (iLevel * CONVAR_SMOKER_TONGUE_FLY_SPEED_BUFF_PER_LEVEL)),false,false);
	SetConVarFloat(FindConVar("tongue_victim_max_speed"), 
		float(CONVAR_SMOKER_TONGUE_DRAG_SPEED_DEFAULT + (iLevel * CONVAR_SMOKER_TONGUE_DRAG_SPEED_BUFF_PER_LEVEL)), false, false);
	SetConVarFloat(FindConVar("tongue_health"), 
		float(CONVAR_SMOKER_TONGUE_HEALTH_DEFAULT + (iLevel * CONVAR_SMOKER_TONGUE_HEALTH_BUFF_PER_LEVEL)), false, false);
}

void SmokerTeleport(int iClient)
{
	if(g_iChokingVictim[iClient] > 0)
	{
		PrintHintText(iClient, "You cannot teleport while choking a victim.");
		return;
	}

	if(g_bTeleportCoolingDown[iClient] == true)
	{
		PrintHintText(iClient, "You must wait %i seconds between teleportation.", RoundToNearest(SMOKER_TELEPORT_COOLDOWN_PERIOD));
		return;
	}


	float xyzOriginalLocation[3], xyzEndLocation[3], xyzEyeAngles[3];
	GetClientAbsOrigin(iClient, xyzOriginalLocation);
	if (GetCrosshairPosition(iClient, xyzEndLocation, xyzEyeAngles) == false)
		return;
	
	//Get direction in which iClient is facing, to push out from this vector
	float vDir[3];
	GetAngleVectors(xyzEyeAngles, vDir, NULL_VECTOR, NULL_VECTOR);

	// Stert figuring out where to teleport to
	xyzEndLocation[0]-=(vDir[0] * 50.0);		//Spawn iClient right ahead of where they were looking
	xyzEndLocation[1]-=(vDir[1] * 50.0);
	//xyzEndLocation[2]-=(vDir[2] * 50.0);
	float fDistance;
	fDistance = GetVectorDistance(xyzOriginalLocation, xyzEndLocation, false);
	fDistance = fDistance * 0.08;

	if(fDistance > (float(g_iSmokerTalent3Level[iClient]) * SMOKER_TELEPORT_MAX_DISTANCE_PER_LEVEL))
	{
		PrintHintText(iClient, "You cannot teleport beyond %.0f ft.", (float(g_iSmokerTalent3Level[iClient]) * SMOKER_TELEPORT_MAX_DISTANCE_PER_LEVEL));
		return;
	}
	
	TeleportEntity(iClient, xyzEndLocation, NULL_VECTOR, NULL_VECTOR);
	EmitSoundToAll(SOUND_WARP_LIFE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1,  xyzEndLocation, NULL_VECTOR, true, 0.0);
	EmitSoundToAll(SOUND_WARP, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1,  xyzEndLocation, NULL_VECTOR, true, 0.0);
	WriteParticle(iClient, "teleport_warp", 0.0, 7.0);
	g_fTeleportOriginalPositionX[iClient] = xyzOriginalLocation[0];
	g_fTeleportOriginalPositionY[iClient] = xyzOriginalLocation[1];
	g_fTeleportOriginalPositionZ[iClient] = xyzOriginalLocation[2];
	g_fTeleportEndPositionX[iClient] = xyzEndLocation[0];
	g_fTeleportEndPositionY[iClient] = xyzEndLocation[1];
	g_fTeleportEndPositionZ[iClient] = xyzEndLocation[2];
	CreateTimer(3.0, CheckIfStuck, iClient, TIMER_FLAG_NO_MAPCHANGE);		//Check if the player is stuck in a wall
	g_bTeleportCoolingDown[iClient] = true;
	CreateTimer(SMOKER_TELEPORT_COOLDOWN_PERIOD, ReAllowTeleport, iClient, TIMER_FLAG_NO_MAPCHANGE);	//After 10 seconds re-allow teleportation fot the iClient
	
	//Make smoker transparent and set him to gradually become more opaque
	g_iSmokerTransparency[iClient] = g_iSmokerTalent3Level[iClient] * 30;
	SetEntityRenderMode(iClient, RenderMode:3);
	SetEntityRenderColor(iClient, 0, 0, 0, 0);		
}

void SmokerDismount(int iClient)
{
	g_bMovementLocked[iClient] = true;
	SetClientSpeed(iClient);
	SetPlayerMoveType(iClient, MOVETYPE_NOCLIP);
	// Note this needs to be done with some delay for it to work
	CreateTimer(0.1, TimerResetPlayerMoveType, iClient);
}

void ToggleSmokerCloaking(int iClient)
{
	g_bSmokerCloakingJustToggled[iClient] = true;
	g_bSmokerIsCloaked[iClient] = !g_bSmokerIsCloaked[iClient];
	SetClientRenderAndGlowColor(iClient);
}

void CreateSmokeScreenAroundVictim(int iClient)
{
	if (RunEntityChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		IsFakeClient(iClient) == true ||
		RunEntityChecks(g_iChokingVictim[iClient]) == false ||
		IsPlayerAlive(g_iChokingVictim[iClient]) == false)
		return;

	if (g_bSmokerSmokeScreenOnCooldown[iClient] == true)
	{
		PrintHintText(iClient, "You don't have enough smoke for a Smoke Screen yet. Wait for it to regenerate.")
		return;
	}
	
	g_bSmokerSmokeScreenOnCooldown[iClient] = true;
	CreateTimer(SMOKER_SMOKE_VICTIM_COOLDOWN_DURATION, TimerResetSmokerSmokeScreenCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);

	float xyzLocation[3];
	CreateSmokeParticle(g_iChokingVictim[iClient], 
		xyzLocation,
		false,
		"",
		50, 200, 50, 100, 
		1, 
		100, 
		100, 
		400, 
		400, 
		20, 
		200, 
		10, 
		SMOKER_SMOKE_VICTIM_DURATION);
}

bool CreateSmokerDoppelganger(int iClient)
{
	g_bSmokerDoppelgangerCoolingDown[iClient] = true;
	CreateTimer(SMOKER_DOPPELGANGER_COOLDOWN_PERIOD, TimerResetSmokerDoppelgangerCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);

	float xyzLocation[3], xyzDirection[3];
	if (GetCrosshairPosition(iClient, xyzLocation, xyzDirection) == false)
		return false;
	
	float xyzPositionEnd[3];
	if (RunEntityChecks(g_iChokingVictim[iClient]))
	{
		GetClientAbsOrigin(g_iChokingVictim[iClient], xyzPositionEnd);
		GetLookAtAnglesFromPoints(xyzLocation, xyzPositionEnd, xyzDirection);
	}

	// Animation Strings (used before using m_nSequence instead)
	// Idle_Upper_KNIFE
	// tongue_attack_drag_survivor_idle
	// tongue_attack_incap_survivor_idle

	// Get the smoker's current animation sequence to use for the clone's animation
	int iAnimationSequence = GetEntProp(iClient, Prop_Data, "m_nSequence");
	// Replace the animation for blended states that dont work with the clone function
	switch (iAnimationSequence)
	{
		case 5: iAnimationSequence = 2;
		case 7: iAnimationSequence = 4;
	}

	// Create the actual clone that will be used as the doppelganger
	int iCloneEntity = CreatePlayerClone(iClient, xyzLocation, xyzDirection, iAnimationSequence);
	if (RunEntityChecks(iCloneEntity) == false)
		return false;

	//Create the fade in effect
	SetEntityRenderMode(iCloneEntity, RenderMode:3);
	SetEntityRenderColor(iCloneEntity, 255, 255, 255, 0);
	g_iSmokerDoppelgangerFadeRunTime[iCloneEntity] = 0.0;
	CreateTimer(0.1, TimerFadeInDoppelgangerAndThenHookOnTakeDamage, iCloneEntity, TIMER_REPEAT);

	CreateTimer(SMOKER_DOPPELGANGER_DURATION, TimerRemoveSmokerDoppelganger, iCloneEntity, TIMER_FLAG_NO_MAPCHANGE);






	g_iSmokerDoppelgangerCount[iClient]--;
	PrintHintText(iClient, "Doppelganger Decoys: %i", g_iSmokerDoppelgangerCount[iClient]);
	g_fNextSmokerDoppelgangerRegenTime[iClient] = GetGameTime() + SMOKER_DOPPELGANGER_REGEN_PERIOD;

	return true;
}


int CreatePlayerClone(int iClient, float xyzLocation[3], float xyzAngles[3], int iAnimationSequence = -1, char[] strAnimationName = "")
{
	char strModel[PLATFORM_MAX_PATH];
	GetEntPropString(iClient, Prop_Data, "m_ModelName", strModel, sizeof(strModel));

	//"models/infected/smoker.mdl"

	// Create survivor model that will be entangled
	int iClone = CreateEntityByName("prop_dynamic");		// Required for iAnimationSequence
	if (RunEntityChecks(iClone) == false)
		return -1;


	SetEntityModel(iClone, strModel);

	//https://forums.alliedmods.net/archive/index.php/t-124041.html
	//https://forums.alliedmods.net/showpost.php?p=644652&postcount=4?p=644652&postcount=4








	// Set angles and origin
	TeleportEntity(iClone, xyzLocation, xyzAngles, NULL_VECTOR);
	
	
	
	
	// // https://forums.alliedmods.net/showthread.php?t=325668

	SetEntProp(iClone, Prop_Data, "m_nSolidType", 2);
	SetEntProp(iClone, Prop_Send, "m_CollisionGroup", 1);

	DispatchSpawn(iClone);

	g_iXPModEntityType[iClone] = XPMOD_ENTITY_TYPE_SMOKER_CLONE;
	g_fXPModEntityHealth[iClone] = 1.0;
	

		// Set playback rate for animation
	SetEntPropFloat(iClone, Prop_Send, "m_flPlaybackRate", 1.0);
	// Set the actual animation (two methods)
	if (iAnimationSequence == -1)
	{
		SetVariantString(strAnimationName)
		AcceptEntityInput(iClone, "SetAnimation");
	}
	else
	{
		SetEntProp(iClone, Prop_Send, "m_nSequence", iAnimationSequence);
	}

	return iClone;
}

Action TimerFadeInDoppelgangerAndThenHookOnTakeDamage(Handle hTimer, int iEntity)
{
	if (RunEntityChecks(iEntity) == false)
		return Plugin_Stop;

	g_iSmokerDoppelgangerFadeRunTime[iEntity] += 0.1;

	if (g_iSmokerDoppelgangerFadeRunTime[iEntity] >= SMOKER_DOPPELGANGER_FADE_IN_PERIOD)
	{
		// Set the render mode back to normal
		SetEntityRenderMode(iEntity, RenderMode:0);
		SetEntityRenderColor(iEntity, 255, 255, 255, 255);

		// Hook the model so hits will register
		SDKHook(iEntity, SDKHook_OnTakeDamage, OnTakeDamage);

		return Plugin_Stop;
	}


	SetEntityRenderMode(iEntity, RenderMode:3);
	SetEntityRenderColor(iEntity, 255, 255, 255, 
		RoundToNearest((g_iSmokerDoppelgangerFadeRunTime[iEntity] / SMOKER_DOPPELGANGER_FADE_IN_PERIOD) * 255));

	return Plugin_Continue;
}


bool GetCrosshairPosition(int iClient, float xyzLocation[3], float xyzEyeAngles[3], bool bClipXZRotation = true)
{
	float xyzEyeOrigin[3];
	GetClientEyePosition(iClient, xyzEyeOrigin);
	GetClientEyeAngles(iClient, xyzEyeAngles);
	//Get direction in which iClient is facing, to push out from this vector later
	//GetAngleVectors(xyzEyeAngles, vDir, NULL_VECTOR, NULL_VECTOR);
	// GetClientEyeAngles(iClient, xyzEyeAngles);

	Handle trace = TR_TraceRayFilterEx(xyzEyeOrigin, xyzEyeAngles, MASK_SHOT, RayType_Infinite, TraceEntityFilter_NotAPlayer, iClient);
	
	if(TR_DidHit(trace) == false)
	{
		CloseHandle(trace);
		return false;
	}


	if (bClipXZRotation == true)
	{
		xyzEyeAngles[0] = 0.0;
		xyzEyeAngles[2] = 0.0;
	}
	
	// Get the actual location
	TR_GetEndPosition(xyzLocation, trace);
	CloseHandle(trace);

	// Get the world mesh bounds adn check that the player isnt aiming at the skybox
	float xyzWorldMaxs[3];
	GetEntPropVector(0, Prop_Data, "m_WorldMaxs", xyzWorldMaxs);
	if (FloatAbs(xyzWorldMaxs[2] - xyzLocation[2])  < 100.0)
		return false;

	// Check that the end location isnt almost outside the world
	float xyzTestLocation[3];
	xyzTestLocation[0] = xyzLocation[0];
	xyzTestLocation[1] = xyzLocation[1];
	xyzTestLocation[2] = xyzLocation[2] + 200.0;
	if (TR_PointOutsideWorld(xyzTestLocation) == true)
		return false;

	return true;
}

void OnTakeDamage_SmokerClone(int iEntity, int iAttacker, float fDamage, int iDamageType)
{
	if (g_fXPModEntityHealth[iEntity] <= 0.0 ||
		RunEntityChecks(iEntity) == false)
		return;

	// Dont take damage from anyone except for HUMAN Survivors
	if (RunClientChecks(iAttacker) == false || 
		IsFakeClient(iAttacker) == true ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS)
		return;

	// Handle the damage
	g_fXPModEntityHealth[iEntity] = g_fXPModEntityHealth[iEntity] - fDamage > 0.0 ? 
		g_fXPModEntityHealth[iEntity] - fDamage : 0.0;


	if (g_fXPModEntityHealth[iEntity] > 0.0)
		return;

	// Get the entity Location
	float xyzLocation[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", xyzLocation);

	// Spawn the Clowns
	SpawnCIAroundLocation(xyzLocation, SMOKER_DOPPELGANGER_CI_SPAWN_COUNT, UNCOMMON_CI_CLOWN, CI_REALLY_BIG, ENHANCED_CI_TYPE_RANDOM);
	SpawnCIAroundLocation(xyzLocation, 1, UNCOMMON_CI_JIMMY, CI_REALLY_BIG_JIMMY, ENHANCED_CI_TYPE_RANDOM);

	// Play the Sound Effect
	EmitAmbientSound(SOUND_CLOWN_SHOVE, xyzLocation, iEntity, SNDLEVEL_NORMAL);
	EmitAmbientSound(SOUND_CLOWN_SHOVE, xyzLocation, iEntity, SNDLEVEL_NORMAL);
	EmitSoundToClient(iAttacker, SOUND_CLOWN_SHOVE);


	// Kill the entity
	KillEntitySafely(iEntity);

	SuppressNeverUsedWarning(iDamageType);
}

