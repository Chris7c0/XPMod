void PrecacheParticle(char[] ParticleName)
{
	//Declare:
	int Particle;
	
	//Initialize:
	Particle = CreateEntityByName("info_particle_system");
	
	//Validate:
	if(IsValidEdict(Particle))
	{
		//Properties:
		DispatchKeyValue(Particle, "effect_name", ParticleName);
		
		//Spawn:
		DispatchSpawn(Particle);
		ActivateEntity(Particle);
		AcceptEntityInput(Particle, "start");
		//AcceptEntityInput(Particle, "m_iParticleSystemIndex", stridx);
		
		//Delete:
		CreateTimer(0.1, DeleteParticle, Particle, TIMER_FLAG_NO_MAPCHANGE);
	}
}

int WriteParticle(int iClient, char[] strParticleName, float fZOffset = 0.0, float fTime = 0.0, float xyzLocation[3] = {0.0, 0.0, 0.0})
{	
	if(IsValidEntity(iClient) == false)
		return -1;
	
	int Particle;
	char tName[64];

	//Initialize:
	Particle = CreateEntityByName("info_particle_system");
	
	//Validate:
	if(IsValidEdict(Particle))
	{
		//PrintToChatAll("Particle Entity ID: %d", Particle);
		//Declare:
		float position[3];
		// float position2[3];
		//Origin:
		GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", position);
		// GetEntPropVector(iClient, Prop_Send, "m_angRotation", position2);
		if(fZOffset != 0.0)
			position[2] += fZOffset;
		//Send:
		if(xyzLocation[0] == 0.0 && xyzLocation[1] == 0.0 && xyzLocation[2] == 0.0)
			TeleportEntity(Particle, position, NULL_VECTOR, NULL_VECTOR);
		else
			TeleportEntity(Particle, xyzLocation, NULL_VECTOR, NULL_VECTOR);
		
		//Target Name:
		if(xyzLocation[0] == 0.0 && xyzLocation[1] == 0.0 && xyzLocation[2] == 0.0)
		{
			Format(tName, sizeof(tName), "Entity%d", iClient);
			DispatchKeyValue(iClient, "targetname", tName);
			GetEntPropString(iClient, Prop_Data, "m_iName", tName, sizeof(tName));
			DispatchKeyValue(Particle, "parentname", tName);
		}
		
		//Properties:
		DispatchKeyValue(Particle, "targetname", "L4DParticle");
		DispatchKeyValue(Particle, "effect_name", strParticleName);
		
		//Spawn:
		DispatchSpawn(Particle);
		
		//Parent:
		if(xyzLocation[0] == 0.0 && xyzLocation[1] == 0.0 && xyzLocation[2] == 0.0)
		{
			SetVariantString(tName);
			AcceptEntityInput(Particle, "SetParent", Particle, Particle);
		}
		ActivateEntity(Particle);
		AcceptEntityInput(Particle, "start");
		//AcceptEntityInput(Particle, "m_iParticleSystemIndex", stridx);
	}
	
	if(fTime != 0.0)
		CreateTimer(fTime, DeleteParticle, Particle);
	
	return Particle;
}

int CreateParticle(char[] type, float time, int entity, int attach = ATTACH_NONE, bool useangles = false, float xOffs = 0.0, float yOffs = 0.0, float zOffs = 0.0)
{
	int particle = CreateEntityByName("info_particle_system");
	
	// Check if it was created correctly
	if (IsValidEdict(particle))
	{
		float pos[3];
		float angles[3];
		// Get position of entity
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);
		
		// Add position offsets
		pos[0] += xOffs;
		pos[1] += yOffs;
		pos[2] += zOffs;
		
		// Teleport, set up
		if(useangles == true)
		{
			GetClientEyeAngles(entity, angles);
			TeleportEntity(particle, pos, angles, NULL_VECTOR);
		}
		else
			TeleportEntity(particle, pos, NULL_VECTOR, NULL_VECTOR);
			
		DispatchKeyValue(particle, "effect_name", type);
		
		if (attach != ATTACH_NONE) 
		{
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity, particle, 0);
			
			switch(attach)
			{
				case ATTACH_MOUTH:				SetVariantString("mouth");
				case ATTACH_EYES:				SetVariantString("eyes");
				case ATTACH_MUZZLE_FLASH:		SetVariantString("muzzle_flash");
				case ATTACH_WEAPON_BONE:		SetVariantString("weapon_bone");
				case ATTACH_DEBRIS:				SetVariantString("debris");
				case ATTACH_RSHOULDER:			SetVariantString("rshoulder");
				case 99:						SetVariantString("smoker_mouth");
				
				/*
				case ATTACH_FORWARD:			SetVariantString("forward");
				case ATTACH_SPINE:				SetVariantString("spine");
				case ATTACH_SHELL:				SetVariantString("shell");
				case ATTACH_SURVIVOR_LIGHT:		SetVariantString("survivor_light");
				case ATTACH_BLUR:				SetVariantString("attach_blur");
				case ATTACH_MEDKIT:				SetVariantString("medkit");
				*/
			}
			
			AcceptEntityInput(particle, "SetParentAttachmentMaintainOffset", particle, particle, 0);
		}
		// All entities in presents are given a targetname to make clean up easier
		//DispatchKeyValue(particle, "targetname", "present");
		DispatchKeyValue(particle, "targetname", "L4DParticle");
		
		// Spawn and start
		DispatchSpawn(particle);
		ActivateEntity(particle);
		AcceptEntityInput(particle, "Start");
		if (time > 0.0)
			CreateTimer(time, DeleteParticle, particle);
	} 
	else 
		LogError("[XPMod] (CreateParticle): Could not create info_particle_system");
	
	return particle;
}

int AttachParticle(int target, char[] particlename, float fTime = -1.0, float originOffset = 0.0)
{
	if (target > 0 && IsValidEntity(target))
	{
   		int particle = CreateEntityByName("info_particle_system");
		
		if (IsValidEntity(particle))
		{
			float pos[3];
			GetEntPropVector(target, Prop_Send, "m_vecOrigin", pos);
			pos[2] += originOffset;
			TeleportEntity(particle, pos, NULL_VECTOR, NULL_VECTOR);
			char tName[64];
			Format(tName, sizeof(tName), "Attach%d", target);
			DispatchKeyValue(target, "targetname", tName);
			GetEntPropString(target, Prop_Data, "m_iName", tName, sizeof(tName));
			DispatchKeyValue(particle, "scale", "");
			DispatchKeyValue(particle, "effect_name", particlename);
			DispatchKeyValue(particle, "parentname", tName);
			DispatchKeyValue(particle, "targetname", "particle");
			DispatchSpawn(particle);
			ActivateEntity(particle);
			SetVariantString(tName);
			AcceptEntityInput(particle, "SetParent", particle, particle);
			AcceptEntityInput(particle, "Enable");
			AcceptEntityInput(particle, "start");
			if (fTime > 0.0) CreateTimer(fTime, DeleteParticle, particle, TIMER_FLAG_NO_MAPCHANGE);
			return particle;
		}
	}

	return -1;
}

//Delete:
Action DeleteParticle(Handle timer, int Particle)
{
	//Validate:
	if(Particle > 0 && IsValidEdict(Particle) &&IsValidEntity(Particle))
	{
		//Declare:
		char Classname[64];
		
		//Initialize:
		GetEdictClassname(Particle, Classname, sizeof(Classname));
		
		//Is a Particle:
		if(StrEqual(Classname, "info_particle_system", false))
		{
			//Delete:
			AcceptEntityInput(Particle, "Kill");
			//PrintToChatAll("Deleted particle system with id: %d", Particle);
		}
	}
	
	return Plugin_Stop;
}

void DeleteParticleEntity(int iParticle)
{
	if(iParticle > 0 && IsValidEdict(iParticle) && IsValidEntity(iParticle))
	{
		char Classname[64];
		GetEdictClassname(iParticle, Classname, sizeof(Classname));
		
		// Is it a Particle?
		if(StrEqual(Classname, "info_particle_system", false))
		{
			// Delete it
			AcceptEntityInput(iParticle, "Kill");
			//PrintToChatAll("Deleted particle system with id: %d", Particle);
		}
	}
}

void CreateRochelleSmoke(int iClient)
{
	//Make Smoke Entity
	float vec[3];
	GetClientAbsOrigin(iClient, vec);
	
	int smoke = CreateEntityByName("env_smokestack");
	
	char clientName[128], vecString[32];
	Format(clientName, sizeof(clientName), "Smoke%i", iClient);
	Format(vecString, sizeof(vecString), "%f %f %f", vec[0], vec[1], vec[2]);
	
	DispatchKeyValue(smoke,"targetname", clientName);
	DispatchKeyValue(smoke,"Origin", vecString);
	DispatchKeyValue(smoke,"BaseSpread", "0");		//Gap in the middle
	DispatchKeyValue(smoke,"SpreadSpeed", "100");	//Speed the smoke moves outwards
	DispatchKeyValue(smoke,"Speed", "100");			//Speed the smoke moves up
	DispatchKeyValue(smoke,"StartSize", "200");
	DispatchKeyValue(smoke,"EndSize", "250");
	DispatchKeyValue(smoke,"Rate", "15");			//Amount of smoke created
	DispatchKeyValue(smoke,"JetLength", "350");		//Smoke jets outside of the original
	DispatchKeyValue(smoke,"Twist", "30"); 			//Amount of global twisting
	DispatchKeyValue(smoke,"RenderColor", "100 0 255");
	DispatchKeyValue(smoke,"RenderAmt", "255");		//Transparency
	DispatchKeyValue(smoke,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
	
	DispatchSpawn(smoke);
	AcceptEntityInput(smoke, "TurnOn");
	
	CreateTimer(8.0, TimerStopSmokeEntity, smoke, TIMER_FLAG_NO_MAPCHANGE);
}


// Generic Function for creating a smoke particle in the environment that all players can see
int CreateSmokeParticle(
	int iClient = -1,									// Target to attach to
	float xyzPosition[3],								// Position to create it 0,0,0 will force getting client location
	bool bAttachToTarget = false,						// Attach to the target entity or not
	const char[] strAttachTarget = "",						// Target to attach to
	int iRed = 255, int iGreen = 255, int iBlue = 255, 	// Color of smoke
	int iAlpha = 255,									// How Opaque
	int iMiddleGapSize = 1,		// Gap in the middle
	int iOutwardSpeed = 100,	// Speed the smoke moves outwards
	int iUpwardSpeed = 100,		// Speed the smoke moves up
	int iStartSize = 200,		// Original Size
	int iEndSize = 400,			// End Size
	int iSmokeRate = 20,		// Amount of smoke created
	int iJetLength = 200,		// Smoke jets outside of the original
	int iTwist = 10,			// Amount of global twisting
	float fDuration = -1.0		// Duration (-1.0 is never destroy)
	)
{
	// Create the smoke entity
	int iSmokeEntity = CreateEntityByName("env_smokestack");
													
	if (RunClientChecks(iClient))
	{
		char strClientName[128];
		//PrintToChatAll("SMOKE CLIENT: [%N]", iClient);
		Format(strClientName, sizeof(strClientName), "Smoke%i", iClient);
		DispatchKeyValue(iSmokeEntity,"targetname", strClientName);

		if (xyzPosition[0] == 0.0 && xyzPosition[1] == 0.0 && xyzPosition[2] == 0.0)
			GetClientEyePosition(iClient, xyzPosition);
	}

	char strPosition[32];
	Format(strPosition, sizeof(strPosition), "%f %f %f", xyzPosition[0], xyzPosition[1], xyzPosition[2]);
	//PrintToChatAll("SMOKE POSTION: [%s]", strPosition);

	char strTemp[16];
	DispatchKeyValue(iSmokeEntity,"Origin", strPosition);
	Format(strTemp, sizeof(strTemp), "%i", iMiddleGapSize);
	DispatchKeyValue(iSmokeEntity,"BaseSpread", strTemp);
	Format(strTemp, sizeof(strTemp), "%i", iOutwardSpeed);
	DispatchKeyValue(iSmokeEntity,"SpreadSpeed", strTemp);
	Format(strTemp, sizeof(strTemp), "%i", iUpwardSpeed);
	DispatchKeyValue(iSmokeEntity,"Speed", strTemp);
	Format(strTemp, sizeof(strTemp), "%i", iStartSize);
	DispatchKeyValue(iSmokeEntity,"StartSize", strTemp);
	Format(strTemp, sizeof(strTemp), "%i", iEndSize);
	DispatchKeyValue(iSmokeEntity,"EndSize", strTemp);
	Format(strTemp, sizeof(strTemp), "%i", iSmokeRate);
	DispatchKeyValue(iSmokeEntity,"Rate", strTemp);
	Format(strTemp, sizeof(strTemp), "%i", iJetLength);
	DispatchKeyValue(iSmokeEntity,"JetLength", strTemp);
	Format(strTemp, sizeof(strTemp), "%i", iTwist);
	DispatchKeyValue(iSmokeEntity,"Twist", strTemp);
	Format(strTemp, sizeof(strTemp), "%i %i %i", iRed, iGreen, iBlue);
	DispatchKeyValue(iSmokeEntity,"RenderColor", strTemp);
	Format(strTemp, sizeof(strTemp), "%i", iAlpha);
	DispatchKeyValue(iSmokeEntity,"RenderAmt", strTemp);
	DispatchKeyValue(iSmokeEntity,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");		//THIS WAS CHANGED FROM THE PRECACHED TO SEE HOW IT IS
	
	if (bAttachToTarget)
	{
		SetVariantString("!activator");
		AcceptEntityInput(iSmokeEntity, "SetParent", iClient, iSmokeEntity, 0);

		SetVariantString(strAttachTarget);
		AcceptEntityInput(iSmokeEntity, "SetParentAttachmentMaintainOffset", iSmokeEntity, iSmokeEntity, 0);
	}

	DispatchSpawn(iSmokeEntity);
	AcceptEntityInput(iSmokeEntity, "TurnOn");
	
	if (fDuration > 0.0)
		CreateTimer(fDuration, TimerStopSmokeEntity, iSmokeEntity, TIMER_FLAG_NO_MAPCHANGE);

	return iSmokeEntity;
}

void TurnOffAndDeleteSmokeStackParticle(int iSmokeStackEntity)
{
	//PrintToChatAll("TurnOffAndDeleteSmokeStackParticle %i", iSmokeStackEntity);
	if(iSmokeStackEntity > 0 && IsValidEdict(iSmokeStackEntity) && IsValidEntity(iSmokeStackEntity))
	{
		char Classname[99];
		GetEdictClassname(iSmokeStackEntity, Classname, sizeof(Classname));
		//PrintToChatAll("edict classname: %s", Classname);
		
		// Is it a smoke stack particle entity?
		if(StrEqual(Classname, "env_smokestack", false))
		{
			//PrintToChatAll("Turning off particle %i", iSmokeStackEntity);
			AcceptEntityInput(iSmokeStackEntity, "ClearParent");
			AcceptEntityInput(iSmokeStackEntity, "TurnOff");
			CreateTimer(10.0, TimerRemoveSmokeEntity, iSmokeStackEntity, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

Action TimerStopSmokeEntity(Handle timer, int iSmokeStackEntity)
{
	TurnOffAndDeleteSmokeStackParticle(iSmokeStackEntity);
	return Plugin_Stop;
}

Action TimerRemoveSmokeEntity(Handle timer, int iSmokeStackEntity)
{
	if(iSmokeStackEntity > 0 && IsValidEdict(iSmokeStackEntity) && IsValidEntity(iSmokeStackEntity))
	{
		char Classname[99];
		GetEdictClassname(iSmokeStackEntity, Classname, sizeof(Classname));
		//PrintToChatAll("edict classname: %s", Classname);
		
		// Is it a smoke stack particle entity?
		if(StrEqual(Classname, "env_smokestack", false))
			AcceptEntityInput(iSmokeStackEntity, "Kill");
	}
	
	return Plugin_Stop;
}

//Delete All Particles attached to a Client
void DeleteAllClientParticles(int iClient)
{
	DeleteAllMenuParticles(iClient);
	
	//Bill
	
	//Rochelle
	DeleteParticleEntity(g_iPID_RochelleCharge1[iClient]);
	DeleteParticleEntity(g_iPID_RochelleCharge2[iClient]);
	DeleteParticleEntity(g_iPID_RochelleCharge3[iClient]);
	DeleteParticleEntity(g_iPID_RochelleJumpCharge[iClient]);
	//DeleteParticleEntity(g_iPID_RochellePoisonBullet[iClient]);
	
	g_iPID_RochelleCharge1[iClient] = -1;
	g_iPID_RochelleCharge2[iClient] = -1;
	g_iPID_RochelleCharge3[iClient] = -1;
	g_iPID_RochelleJumpCharge[iClient] = -1;
	
	//Coach
	DeleteParticleEntity(g_iPID_CoachMeleeCharge1[iClient]);
	DeleteParticleEntity(g_iPID_CoachMeleeCharge2[iClient]);
	DeleteParticleEntity(g_iPID_CoachCharge1[iClient]);
	DeleteParticleEntity(g_iPID_CoachCharge2[iClient]);
	DeleteParticleEntity(g_iPID_CoachCharge3[iClient]);
	DeleteParticleEntity(g_iPID_CoachMeleeChargeHeal[iClient]);
	
	g_iPID_CoachMeleeCharge1[iClient] = -1;
	g_iPID_CoachMeleeCharge2[iClient] = -1;
	g_iPID_CoachCharge1[iClient] = -1;
	g_iPID_CoachCharge2[iClient] = -1;
	g_iPID_CoachCharge3[iClient] = -1;
	g_iPID_CoachMeleeChargeHeal[iClient] = -1;
	
	//Ellis
	DeleteParticleEntity(g_iPID_EllisCharge1[iClient]);
	DeleteParticleEntity(g_iPID_EllisCharge2[iClient]);
	DeleteParticleEntity(g_iPID_EllisCharge3[iClient]);
	DeleteParticleEntity(g_iPID_EllisFireStorm[iClient]);
	
	g_iPID_EllisCharge1[iClient] = -1;
	g_iPID_EllisCharge2[iClient] = -1;
	g_iPID_EllisCharge3[iClient] = -1;	
	g_iPID_EllisFireStorm[iClient] = -1;
	
	//Nick
	DeleteParticleEntity(g_iPID_NickCharge1[iClient]);
	DeleteParticleEntity(g_iPID_NickCharge2[iClient]);
	DeleteParticleEntity(g_iPID_NickCharge3[iClient]);
	
	g_iPID_NickCharge1[iClient] = -1;
	g_iPID_NickCharge2[iClient] = -1;
	g_iPID_NickCharge3[iClient] = -1;
	
	//Spitter
	DeleteParticleEntity(g_iPID_DemiGravityEffect[iClient]);
	DeleteParticleEntity(g_iPID_SpitterSlimeTrail[iClient]);
	
	g_iPID_DemiGravityEffect[iClient] = -1;
	g_iPID_SpitterSlimeTrail[iClient] = -1;
	
	//Charger
	DeleteParticleEntity(g_iPID_ChargerShield[iClient]);
	
	g_iPID_ChargerShield[iClient] = -1;
	
	//Tank
	DeleteParticleEntity(g_iPID_TankChargedFire[iClient]);
	DeleteParticleEntity(g_iPID_IceTankChargeMistAddon[iClient]);
	DeleteParticleEntity(g_iPID_IceTankChargeMistStock[iClient]);
	DeleteParticleEntity(g_iPID_IceTankChargeSnow[iClient]);
	DeleteParticleEntity(g_iPID_IceTankIcicles[iClient]);
	TurnOffAndDeleteSmokeStackParticle(g_iPID_TankTrail[iClient]);
	
	g_iPID_TankChargedFire[iClient] = -1;
	g_iPID_IceTankChargeMistAddon[iClient] = -1;
	g_iPID_IceTankChargeMistStock[iClient] = -1;
	g_iPID_IceTankChargeSnow[iClient] = -1;
	g_iPID_IceTankIcicles[iClient] = -1;
	g_iPID_TankTrail[iClient] = -1;	
}

void DeleteAllMenuParticles(int iClient)
{
	g_bShowingVGUI[iClient] =  false;
	
	//Bill
	if(g_iPID_MD_Bill_Inspirational[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Bill_Inspirational[iClient]);
		g_iPID_MD_Bill_Inspirational[iClient] = -1;
	}
	if(g_iPID_MD_Bill_Ghillie[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Bill_Ghillie[iClient]);
		g_iPID_MD_Bill_Ghillie[iClient] = -1;
	}
	if(g_iPID_MD_Bill_Will[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Bill_Will[iClient]);
		g_iPID_MD_Bill_Will[iClient] = -1;
	}
	if(g_iPID_MD_Bill_Exorcism[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Bill_Exorcism[iClient]);
		g_iPID_MD_Bill_Exorcism[iClient] = -1;
	}
	if(g_iPID_MD_Bill_Diehard[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Bill_Diehard[iClient]);
		g_iPID_MD_Bill_Diehard[iClient] = -1;
	}
	if(g_iPID_MD_Bill_Promotional[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Bill_Promotional[iClient]);
		g_iPID_MD_Bill_Promotional[iClient] = -1;
	}

	//Rochelle
	if(g_iPID_MD_Rochelle_Gather[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Rochelle_Gather[iClient]);
		g_iPID_MD_Rochelle_Gather[iClient] = -1;
	}
	if(g_iPID_MD_Rochelle_Hunter[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Rochelle_Hunter[iClient]);
		g_iPID_MD_Rochelle_Hunter[iClient] = -1;
	}
	if(g_iPID_MD_Rochelle_Sniper[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Rochelle_Sniper[iClient]);
		g_iPID_MD_Rochelle_Sniper[iClient] = -1;
	}
	if(g_iPID_MD_Rochelle_Silent[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Rochelle_Silent[iClient]);
		g_iPID_MD_Rochelle_Silent[iClient] = -1;
	}
	if(g_iPID_MD_Rochelle_Smoke[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Rochelle_Smoke[iClient]);
		g_iPID_MD_Rochelle_Smoke[iClient] = -1;
	}
	if(g_iPID_MD_Rochelle_Shadow[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Rochelle_Shadow[iClient]);
		g_iPID_MD_Rochelle_Shadow[iClient] = -1;
	}
	
	//Coach
	if(g_iPID_MD_Coach_Bull[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Coach_Bull[iClient]);
		g_iPID_MD_Coach_Bull[iClient] = -1;
	}
	if(g_iPID_MD_Coach_Wrecking[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Coach_Wrecking[iClient]);
		g_iPID_MD_Coach_Wrecking[iClient] = -1;
	}
	if(g_iPID_MD_Coach_Spray[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Coach_Spray[iClient]);
		g_iPID_MD_Coach_Spray[iClient] = -1;
	}
	if(g_iPID_MD_Coach_Homerun[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Coach_Homerun[iClient]);
		g_iPID_MD_Coach_Homerun[iClient] = -1;
	}
	if(g_iPID_MD_Coach_Lead[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Coach_Lead[iClient]);
		g_iPID_MD_Coach_Lead[iClient] = -1;
	}
	if(g_iPID_MD_Coach_Strong[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Coach_Strong[iClient]);
		g_iPID_MD_Coach_Strong[iClient] = -1;
	}
	
	//Ellis
	if(g_iPID_MD_Ellis_Over[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Ellis_Over[iClient]);
		g_iPID_MD_Ellis_Over[iClient] = -1;
	}
	if(g_iPID_MD_Ellis_Bring[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Ellis_Bring[iClient]);
		g_iPID_MD_Ellis_Bring[iClient] = -1;
	}
	if(g_iPID_MD_Ellis_Weapons[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Ellis_Weapons[iClient]);
		g_iPID_MD_Ellis_Weapons[iClient] = -1;
	}
	if(g_iPID_MD_Ellis_Jammin[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Ellis_Jammin[iClient]);
		g_iPID_MD_Ellis_Jammin[iClient] = -1;
	}
	if(g_iPID_MD_Ellis_Mechanic[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Ellis_Mechanic[iClient]);
		g_iPID_MD_Ellis_Mechanic[iClient] = -1;
	}
	if(g_iPID_MD_Ellis_Fire[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Ellis_Fire[iClient]);
		g_iPID_MD_Ellis_Fire[iClient] = -1;
	}
	
	//Nick
	if(g_iPID_MD_Nick_Swindler[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Nick_Swindler[iClient]);
		g_iPID_MD_Nick_Swindler[iClient] = -1;
	}
	if(g_iPID_MD_Nick_Leftover[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Nick_Leftover[iClient]);
		g_iPID_MD_Nick_Leftover[iClient] = -1;
	}
	if(g_iPID_MD_Nick_Magnum[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Nick_Magnum[iClient]);
		g_iPID_MD_Nick_Magnum[iClient] = -1;
	}
	if(g_iPID_MD_Nick_Enhanced[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Nick_Enhanced[iClient]);
		g_iPID_MD_Nick_Enhanced[iClient] = -1;
	}
	if(g_iPID_MD_Nick_Risky[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Nick_Risky[iClient]);
		g_iPID_MD_Nick_Risky[iClient] = -1;
	}
	if(g_iPID_MD_Nick_Desperate[iClient] != -1)
	{
		DeleteParticleEntity(g_iPID_MD_Nick_Desperate[iClient]);
		g_iPID_MD_Nick_Desperate[iClient] = -1;
	}
	
}

void CreateSphere(const float xyzOrigin[3], float fSphereDiameter, int iRings, float fRingWidth, const int vColor[4], float fLifeTime, float fZOffset = 50.0)
{
	float fRingDiameter;
	
	float xyzSpherePosition[3], xyzRingPosition[3];
	xyzSpherePosition[0] = xyzOrigin[0];
	xyzSpherePosition[1] = xyzOrigin[1];
	// Apply the zoffset to raise it or lower it.
	xyzSpherePosition[2] = xyzOrigin[2] + fZOffset;
	// Set x and y for ring positions
	xyzRingPosition[0] = xyzOrigin[0];
	xyzRingPosition[1] = xyzOrigin[1];

	// Create the rings to make the spehere
	int i;
	for(i = 1; i < iRings; i++)
	{
		fRingDiameter = 0.0 + fSphereDiameter * Sine( PI * (i / float(iRings)) );
		xyzRingPosition[2] = xyzSpherePosition[2] + ( (fSphereDiameter / 2.0) * Cosine( PI * (i / float(iRings)) ) );
		
		TE_Start("BeamRingPoint");
		TE_WriteVector("m_vecCenter", xyzRingPosition);
		TE_WriteFloat("m_flStartRadius",  fRingDiameter);
		TE_WriteFloat("m_flEndRadius", fRingDiameter + 0.1);
		TE_WriteNum("m_nModelIndex", g_iSprite_Laser);
		TE_WriteNum("m_nHaloIndex", g_iSprite_Glow);
		TE_WriteNum("m_nStartFrame", 0);
		TE_WriteNum("m_nFrameRate", 15); // 60
		TE_WriteFloat("m_fLife", fLifeTime);
		TE_WriteFloat("m_fWidth", fRingWidth);
		TE_WriteFloat("m_fEndWidth", fRingWidth);
		TE_WriteFloat("m_fAmplitude",  0.0); // 0.1 // Wiggles it, but makes it look messed up
		TE_WriteNum("r", vColor[0]);
		TE_WriteNum("g", vColor[1]);
		TE_WriteNum("b", vColor[2]);
		TE_WriteNum("a", vColor[3]);
		TE_WriteNum("m_nSpeed", 10); // 1
		TE_WriteNum("m_nFlags", 0);
		TE_WriteNum("m_nFadeLength", 0);
		TE_SendToAll();
	}
}

int CreateDummyEntity(
	float xyzLocation[3],
	float fLifetime = -1.0,
	int iEntityToAttachTo = -1,
	char[] strAttachmentPoint = "NONE")
{
	// Create the entity
	int iEntity = CreateEntityByName("env_sprite");
	if (RunEntityChecks(iEntity) == false)
		return -1;
	
	// Set up the model (material for env_sprite, required for it to work)
	DispatchKeyValue(iEntity, "model", "materials/sprites/white.vmt");
	DispatchSpawn(iEntity);
	AcceptEntityInput(iEntity, "HideSprite");

	// set the attachment location if required
	if (RunEntityChecks(iEntityToAttachTo) ==  true)
		GetEntPropVector(iEntityToAttachTo, Prop_Send, "m_vecOrigin", xyzLocation);

	// Teleport the entity to appropriate location
	DispatchKeyValueVector(iEntity, "origin", xyzLocation);

	// Attachment if required
	if (RunEntityChecks(iEntityToAttachTo) ==  true)
	{
		SetVariantString("!activator");
		AcceptEntityInput(iEntity, "SetParent", iEntityToAttachTo, iEntity, 0);
		SetVariantString(strAttachmentPoint);
		AcceptEntityInput(iEntity, "SetParentAttachmentMaintainOffset", iEntity, iEntity, 0);
	}

	ActivateEntity(iEntity);

	if (fLifetime > 0.0)
		PrintToChatAll("CreateDummyEntity: fLifeTime not implemented yet.");

	return iEntity;
}

void CreateBeamEntity(
	int iStartEntity,
	int iEndEntity,
	int iPrecachedModelIndex,
	int iRed = 255, int iGreen = 255, int iBlue = 255, int iAlpha = 255,
	float fLifeTime = 120.0,
	float fStartWidth = 5.0, 
	float fEndWidth = 5.0,
	int iFadeLength = 100,
	float fAmplitude = 0.1,
	int iSpeed = 1,
	int iFrameRate = 60)
{		
	TE_Start("BeamEnts");
	TE_WriteEncodedEnt("m_nStartEntity", iStartEntity);
	TE_WriteEncodedEnt("m_nEndEntity", iEndEntity);
	TE_WriteNum("m_nModelIndex", iPrecachedModelIndex);
	TE_WriteNum("m_nHaloIndex", g_iSprite_Glow);
	TE_WriteNum("r", iRed);
	TE_WriteNum("g", iGreen);
	TE_WriteNum("b", iBlue);
	TE_WriteNum("a", iAlpha);
	TE_WriteFloat("m_fLife", fLifeTime);
	TE_WriteFloat("m_fWidth", fStartWidth);
	TE_WriteFloat("m_fEndWidth", fEndWidth);
	TE_WriteNum("m_nFadeLength", iFadeLength);
	TE_WriteFloat("m_fAmplitude", fAmplitude);
	TE_WriteNum("m_nSpeed", iSpeed);
	TE_WriteNum("m_nStartFrame", 0);
	TE_WriteNum("m_nFrameRate", iFrameRate);

	TE_SendToAll();
}
