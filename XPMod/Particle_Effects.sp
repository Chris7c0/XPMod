WriteParticle(iClient, String:strParticleName[], Float:fZOffset = 0.0, Float:fTime = 0.0, Float:xyzLocation[3] = {0.0, 0.0, 0.0})
{	
	if(IsValidEntity(iClient) == false)
		return -1;
	
	decl Particle;
	decl String:tName[64];

	//Initialize:
	Particle = CreateEntityByName("info_particle_system");
	
	//Validate:
	if(IsValidEdict(Particle))
	{
		//PrintToChatAll("Particle Entity ID: %d", Particle);
		//Declare:
		decl Float:position[3];
		decl Float:position2[3];
		//Origin:
		GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", position);
		GetEntPropVector(iClient, Prop_Send, "m_angRotation", position2);
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

CreateParticle(String:type[], Float:time, entity, attach = ATTACH_NONE, bool:useangles = false, Float:xOffs = 0.0, Float:yOffs = 0.0, Float:zOffs = 0.0)
{
	new particle = CreateEntityByName("info_particle_system");
	
	// Check if it was created correctly
	if (IsValidEdict(particle))
	{
		decl Float:pos[3];
		decl Float:angles[3];
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
		if(time > 0.0)
			CreateTimer(time, DeleteParticle, particle);
	} 
	else 
		LogError("[XPMod] (CreateParticle): Could not create info_particle_system");
	
	return particle;
}

//Delete:
public Action:DeleteParticle(Handle:timer, any:Particle)
{

	//Validate:
	if(IsValidEdict(Particle))
		if(IsValidEntity(Particle))
		{
			//Declare:
			decl String:Classname[64];
			
			//Initialize:
			GetEdictClassname(Particle, Classname, sizeof(Classname));
			
			//Is a Particle:
			if(StrEqual(Classname, "info_particle_system", false))
			{
				//Delete:
				AcceptEntityInput(Particle, "kill");
				RemoveEdict(Particle);
				//PrintToChatAll("Deleted particle system with id: %d", Particle);
			}
		}
	
	return Plugin_Stop;
}

public Action:DeleteParticleEntity(Particle)
{
	//Validate:
	if(IsValidEdict(Particle))
		if(IsValidEntity(Particle))
		{
			//Declare:
			decl String:Classname[64];
			
			//Initialize:
			GetEdictClassname(Particle, Classname, sizeof(Classname));
			
			//Is a Particle:
			if(StrEqual(Classname, "info_particle_system", false))
			{
				//Delete:
				AcceptEntityInput(Particle, "kill");
				RemoveEdict(Particle);
				//PrintToChatAll("Deleted particle system with id: %d", Particle);
			}
		}
}

//Precache Particle
PrecacheParticle(String:ParticleName[])
{
	//Declare:
	decl Particle;
	
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

//Delete All Particles attached to a Client
DeleteAllClientParticles(iClient)
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
	DeleteParticleEntity(g_iPID_IceTankChargeMist[iClient]);
	DeleteParticleEntity(g_iPID_IceTankChargeSnow[iClient]);
	DeleteParticleEntity(g_iPID_IceTankIcicles[iClient]);
	
	g_iPID_TankChargedFire[iClient] = -1;
	g_iPID_IceTankChargeMist[iClient] = -1;
	g_iPID_IceTankChargeSnow[iClient] = -1;
	g_iPID_IceTankIcicles[iClient] = -1;		
}

DeleteAllMenuParticles(iClient)
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