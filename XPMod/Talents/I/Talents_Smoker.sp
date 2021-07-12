void TalentsLoad_Smoker(iClient)
{
	if(g_iSmokerTalent1Level[iClient] > 0)
	{
		if(g_bHasInfectedHealthBeenSet[iClient] == false)
		{
			g_bHasInfectedHealthBeenSet[iClient] = true;
			SetPlayerMaxHealth(iClient, (g_iSmokerTalent1Level[iClient] * SMOKER_BONUS_MAX_HEALTH_PER_LEVEL), true);
		}
	}

	// Enable global smoker tongue console variable buffs
	SetSmokerConvarBuffs(FindHighestLevelSmokerAlive());

	if(g_iSmokerTalent1Level[iClient] > 0)
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Smoker Talents \x05have been loaded.");
	if(g_iSmokerTalent2Level[iClient] > 0)
		SetClientSpeed(iClient);
}

void OnGameFrame_Smoker(iClient)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iSmokerTalent1Level[iClient] <= 0)
		return;

	// if (SetMoveTypeBackToNormalOnNextGameFrame[iClient] == true)
	// {
	// 	SetMoveTypeBackToNormalOnNextGameFrame[iClient] = false;
	// 	SetPlayerMoveType(iClient, MOVETYPE_WALK);
	// }

	// Health Regeneration
	// Every frame give 1 hp, 30 fps, so 30 hp per second
	if (GetPlayerHealth(iClient) < SMOKER_STARTING_MAX_HEALTH + (g_iSmokerTalent1Level[iClient] * SMOKER_BONUS_MAX_HEALTH_PER_LEVEL))
		SetPlayerHealth(iClient, SMOKER_HEALTH_REGEN_PER_FRAME, true);
	
	// if(g_fSmokerNextHealthRegenTime[iClient] > GetGameFrame())
	// {

	// }

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
}


bool OnPlayerRunCmd_Smoker(iClient, &iButtons)
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
		iButtons & IN_SPEED)
		SmokerTeleport(iClient);

	// Smoker Dismount
	if (g_iChokingVictim[iClient] > 0 &&
		iButtons & IN_ATTACK)
		SmokerDismount(iClient);

	// Smoker Dismount
	if (g_iChokingVictim[iClient] > 0 &&
		iButtons & IN_RELOAD)
		CreateSmokerDoppelganger(iClient);
	
	return false;
}


void EventsHurt_AttackerSmoker(Handle:hEvent, attacker, victim)
{
	if (IsFakeClient(attacker))
		return;

	if (g_iClientTeam[victim] != TEAM_SURVIVORS)
		return;
	
	decl String:weapon[20];
	GetEventString(hEvent,"weapon", weapon,20);

	if (g_iSmokerTalent3Level[attacker] > 0 && 
		g_bIsSmokeInfected[victim] == false && 
		StrEqual(weapon, "smoker_claw") == true)
	{
		CreateParticle("bug_zapper_fly_cloud", 20.0, victim, ATTACH_MOUTH, true);
		CreateParticle("bug_zapper_fly_cloud", 20.0, victim, ATTACH_MOUTH, true);
		CreateParticle("bug_zapper_fly_cloud", 20.0, victim, ATTACH_MOUTH, true);
		//CreateParticle("smoke_gib_01", 10.0, iClient, ATTACH_MOUTH, true, 0.0, 0.0, -5.0);
		//CreateParticle("smoker_spore_attack", 20.0, victim, ATTACH_NORMAL, true);
		
		
		new Float:vec[3];
		GetClientEyePosition(victim, vec);
		
		//Play fly sounds
		//EmitSoundToAll(SOUND_FLIES, victim, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
		
		vec[2] -= 25.0;
		
		new smoke = CreateEntityByName("env_smokestack");
							
		new String:clientName[128], String:vecString[32];
		Format(clientName, sizeof(clientName), "Smoke%i", victim);
		Format(vecString, sizeof(vecString), "%f %f %f", vec[0], vec[1], vec[2]);
		
		DispatchKeyValue(smoke,"targetname", clientName);
		DispatchKeyValue(smoke,"Origin", vecString);
		DispatchKeyValue(smoke,"BaseSpread", "0");		//Gap in the middle
		DispatchKeyValue(smoke,"SpreadSpeed", "100");	//Speed the smoke moves outwards
		DispatchKeyValue(smoke,"Speed", "80");			//Speed the smoke moves up
		DispatchKeyValue(smoke,"StartSize", "100");
		DispatchKeyValue(smoke,"EndSize", "100");
		DispatchKeyValue(smoke,"Rate", "20");			//Amount of smoke created
		DispatchKeyValue(smoke,"JetLength", "100");		//Smoke jets outside of the original
		DispatchKeyValue(smoke,"Twist", "10"); 			//Amount of global twisting
		//DispatchKeyValue(smoke,"RenderColor", "200 200 40");
		DispatchKeyValue(smoke,"RenderColor", "50 130 1");
		DispatchKeyValue(smoke,"RenderAmt", "255");		//Transparency
		DispatchKeyValue(smoke,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");		//THIS WAS CHANGED FROM THE PRECACHED TO SEE HOW IT IS
		
		DispatchSpawn(smoke);
		AcceptEntityInput(smoke, "TurnOn");
		g_bIsSmokeInfected[victim] = true;
		g_iSmokerInfectionCloudEntity[victim] = smoke;
		CreateTimer(0.1, TimerMoveSmokePoof1, victim, TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(20.0, TimerStopInfection, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
}

// EventsDeath_AttackerSmoker(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

void EventsDeath_VictimSmoker(Handle:hEvent, iAttacker, iVictim)
{
	if (g_iInfectedCharacter[iVictim] != SMOKER ||
		g_iClientTeam[iVictim] != TEAM_INFECTED)
		return;

	// Check if there are any more smoker ability clients alive
	// If not, then reset smoker convar buffs to default
	// Note this needs to be done any time a smoker dies.
	SetSmokerConvarBuffs(FindHighestLevelSmokerAlive());

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

	g_bSmokerIsCloaked[iAttacker] = true;
	g_bSmokerVictimGlowDisabled[iVictim] = true;
	SetClientRenderAndGlowColor(iAttacker);

	return false;
}

bool Event_TongueRelease_Smoker(int iAttacker, iVictim)
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

	// Set the cooldown to enable the next tongue ability faster
	SetSIAbilityCooldown(iAttacker, SMOKER_DEFAULT_TONGUE_COOLDOWN - (RoundToNearest(g_iSmokerTalent1Level[iAttacker] / 2.0) * SMOKER_COOLDOWN_REDUCTION_EVERY_OTHER_LEVEL) );

	return false;
}

bool Event_ChokeStart_Smoker(int iAttacker, int iVictim)
{
	// Before proceeding check to ensure they have smoker talent confirmed
	if (g_bTalentsConfirmed[iAttacker] == false ||
		g_iSmokerTalent1Level[iAttacker] <= 0)
		return false;

	// Set ability for smoker to move
	SetEntityMoveType(iAttacker, MOVETYPE_ISOMETRIC);
	SetClientSpeed(iAttacker);

	if(g_iSmokerTalent2Level[iAttacker] <= 0)
		return false;

	SetClientRenderAndGlowColor(iAttacker);

	// Create smoke around the victim
	CreateSmokeParticle(iVictim, NULL_VECTOR, 0, 255, 50, 255, 1, 100, 100, 300, 300, 200, 200, 10, 15.0);

	return false;
}

bool Event_ChokeEnd_Smoker(int iAttacker, iVictim)
{
	SuppressNeverUsedWarning(iVictim);

	SetClientRenderAndGlowColor(iAttacker);

	SetEntityMoveType(iAttacker, MOVETYPE_CUSTOM);
	SetClientSpeed(iAttacker);

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

void SmokerTeleport(iClient)
{
	if(g_iChokingVictim[iClient] > 0)
	{
		PrintHintText(iClient, "You cannot teleport while choking a victim.");
		return;
	}

	if(g_bTeleportCoolingDown[iClient] == true)
	{
		PrintHintText(iClient, "You must wait %i seconds between teleportations.", RoundToNearest(SMOKER_TELEPORT_COOLDOWN_PERIOD));
		return;
	}

	decl Float:eyeorigin[3], Float:eyeangles[3], Float:endpos[3], Float:vdir[3], Float:distance;
	GetClientEyePosition(iClient, eyeorigin);
	GetClientEyeAngles(iClient, eyeangles);
	GetAngleVectors(eyeangles, vdir, NULL_VECTOR, NULL_VECTOR);	//Get direction in which iClient is facing
	new Handle:trace = TR_TraceRayFilterEx(eyeorigin, eyeangles, MASK_SHOT, RayType_Infinite, TraceRayDontHitSelf, iClient);
	if(TR_DidHit(trace) == false)
	{
		PrintHintText(iClient, "You cannot teleport to this location.");
		CloseHandle(trace);
		return;
	}
	
	TR_GetEndPosition(endpos, trace);
	CloseHandle(trace);

	// This limits the height of teleportation for each map, to prevent from walking in the sky
	if(endpos[2] > g_fMapsMaxTeleportHeight)	
	{
		PrintHintText(iClient, "You cannot teleport to this location.");
		return;
	}

	// Stert figuring out where to teleport to
	endpos[0]-=(vdir[0] * 50.0);		//Spawn iClient right ahead of where they were looking
	endpos[1]-=(vdir[1] * 50.0);
	//endpos[2]-=(vdir[2] * 50.0);
	//PrintToChat(iClient, "vdir = %.4f, %.4f, %.4f", vdir[0], vdir[1], vdir[2]);
	distance = GetVectorDistance(eyeorigin, endpos, false);
	distance = distance * 0.08;

	if(distance > (float(g_iSmokerTalent3Level[iClient]) * 30.0))
	{
		PrintHintText(iClient, "You cannot teleport beyond %.0f ft.", (float(g_iSmokerTalent3Level[iClient]) * 30.0));
		return;
	}

	decl Float:vorigin[3];
	GetClientAbsOrigin(iClient, vorigin);
	TeleportEntity(iClient, endpos, NULL_VECTOR, NULL_VECTOR);
	EmitSoundToAll(SOUND_WARP_LIFE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1,  endpos, NULL_VECTOR, true, 0.0);
	EmitSoundToAll(SOUND_WARP, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1,  endpos, NULL_VECTOR, true, 0.0);
	WriteParticle(iClient, "teleport_warp", 0.0, 7.0);
	PrintHintText(iClient, "You teleported %.1f ft.", distance);
	PrintToChat(iClient, "<%f, %f, %f>", endpos[0], endpos[1], endpos[2]);
	g_fTeleportOriginalPositionX[iClient] = vorigin[0];
	g_fTeleportOriginalPositionY[iClient] = vorigin[1];
	g_fTeleportOriginalPositionZ[iClient] = vorigin[2];
	g_fTeleportEndPositionX[iClient] = endpos[0];
	g_fTeleportEndPositionY[iClient] = endpos[1];
	g_fTeleportEndPositionZ[iClient] = endpos[2];
	CreateTimer(3.0, CheckIfStuck, iClient, TIMER_FLAG_NO_MAPCHANGE);		//Check if the player is stuck in a wall
	g_bTeleportCoolingDown[iClient] = true;
	CreateTimer(SMOKER_TELEPORT_COOLDOWN_PERIOD, ReallowTeleport, iClient, TIMER_FLAG_NO_MAPCHANGE);	//After 10 seconds reallow teleportation fot the iClient
	
	//Make smoker transparent and set him to gradually become more opaque
	g_iSmokerTransparency[iClient] = g_iSmokerTalent3Level[iClient] * 30;
	SetEntityRenderMode(iClient, RenderMode:3);
	SetEntityRenderColor(iClient, 0, 0, 0, 0);		
}


SmokerDismount(iClient)
{
	g_bMovementLocked[iClient] = true;
	SetClientSpeed(iClient);
	SetPlayerMoveType(iClient, MOVETYPE_NOCLIP);
	// Note this needs to be done with some delay for it to work
	CreateTimer(0.1, TimerResetPlayerMoveType, iClient);
}

void CreateSmokerDoppelganger(int iClient)
{

}