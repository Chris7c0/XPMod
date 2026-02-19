
void Event_AbilityUse(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	if (RunClientChecks(iClient) == false)
		return;
	
	Event_AbilityUse_Boomer(iClient, hEvent);
	Event_AbilityUse_Hunter(iClient, hEvent);

	return;
}

Action Event_PlayerNowIt(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int iAttacker = GetClientOfUserId(GetEventInt(hEvent,"attacker"));
	int iVictim = GetClientOfUserId(GetEventInt(hEvent,"userid"));

	if (iAttacker == 0 || iVictim == 0)
		return Plugin_Continue;
	
	if(RunClientChecks(iAttacker) == true)
	{
		g_iVomitVictimAttacker[iVictim] = iAttacker;
	}

	if (g_iBileCleansingKits[iVictim] > 0 &&
		RunClientChecks(iVictim) == true &&
		IsPlayerAlive(iVictim) == true &&
		IsFakeClient(iVictim) == false)
		PrintHintText(iVictim, "HOLD USE to Cleanse Bile\
			\n%i Bile Cleansing Kit%s Remaining",
			g_iBileCleansingKits[iVictim],
			g_iBileCleansingKits[iVictim] == 1 ? "" : "s");

	// Handle the Boomer's abilities
	Event_BoomerVomitOnPlayer(iAttacker, iVictim);

	// Handle the bile on tanks, like removing vomit
	Event_BoomerVomitOnPlayerTank(iVictim);
	
	return Plugin_Continue;
}

Action Event_PlayerNoLongerIt(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int iVictim = GetClientOfUserId(GetEventInt(hEvent,"userid"));

	g_iVomitVictimAttacker[iVictim] = 0;


	return Plugin_Continue;
}

Action Event_ChargerChargeStart(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	
	g_bIsChargerCharging[attacker] = true;
	
	if(g_bIsSuperCharger[attacker] == true)
	{
		SetClientSpeed(attacker);
		g_iClientBindUses_1[attacker]++;
	}
	
	return Plugin_Continue;
}


Action Event_ChargerChargeEnd(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	
	int attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	
	g_bIsChargerCharging[attacker] = false;
	
	if(g_iHillbillyLevel[attacker] > 0)
		CreateTimer(1.0, TimerSetChargerCooldown, attacker,  TIMER_FLAG_NO_MAPCHANGE);
		
	if(g_bIsSuperCharger[attacker] == true)
	{
		g_bIsSuperCharger[attacker] = false;
		SetClientSpeed(attacker);

		CreateTimer(30.0, TimerResetSuperCharge, attacker,  TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}

Action Event_ChargerImpact(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	if(g_iGroundLevel[attacker] > 0)
	{
		int iDamage;
		
		if(g_iGroundLevel[attacker] < 4)
			iDamage = (g_iGroundLevel[attacker] - 1);
		else if(g_iGroundLevel[attacker] < 7)
			iDamage = (g_iGroundLevel[attacker] - 2);
		else if(g_iGroundLevel[attacker] < 10)
			iDamage = (g_iGroundLevel[attacker] - 3);
		else iDamage = 6;
		
		int iCurrentHealth = GetPlayerHealth(victim);
		SetPlayerHealth(victim, attacker, iCurrentHealth - iDamage);
	}
	if(g_iSpikedLevel[attacker] > 0)
	{
		
		int heal = GetPlayerHealth(attacker);
		SetPlayerHealth(attacker, -1, heal + (g_iSpikedLevel[attacker] * 33));
	}

	return Plugin_Continue;
}
Action Event_ChargerCarryStart(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	canchangemovement[victim]=false;
	
	g_bChargerCarrying[attacker] = true;
	
	GiveClientXP(attacker, 50, g_iSprite_50XP_SI, victim, "Grappled A Survivor.");
	
	if(g_iHillbillyLevel[attacker] > 0)
		g_iPID_ChargerShield[attacker] = WriteParticle(attacker, "charger_shield", 70.0);
		
	SetClientRenderAndGlowColor(victim);
	return Plugin_Continue;
}

Action Event_ChargerCarryEnd(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	canchangemovement[victim]=true;
	
	g_bChargerCarrying[attacker] = false;
	
	if(g_iPID_ChargerShield[attacker] != -1)
	{
		DeleteParticleEntity(g_iPID_ChargerShield[attacker]);
		g_iPID_ChargerShield[attacker] = -1;
	}
	
	if(g_bUsingTongueRope[victim])
	{
		DisableNinjaRope(victim);
		SetMoveType(victim, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
	}
	SetClientRenderAndGlowColor(victim);
	return Plugin_Continue;
}

Action Event_ChargerPummelStart(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	GiveClientXP(attacker, 50, g_iSprite_50XP_SI, victim, "Grappled A Survivor.");
	
	if(IsClientInGame(victim))
	{
		if(IsPlayerAlive(victim))
		{
			g_iChargerVictim[attacker] = victim;
			g_bChargerGrappled[victim] = true;
		}
	}
	SetClientRenderAndGlowColor(victim);
	return Plugin_Continue;
}

Action Event_ChargerPummelEnd(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int chargerid = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	g_iChargerVictim[chargerid] = 0;
	g_bChargerGrappled[victim] = false;
	
	if(g_bDivineInterventionQueued[victim] == true)
		CreateTimer(0.1, TimerApplyDivineIntervention, victim, TIMER_FLAG_NO_MAPCHANGE);

	SetClientRenderAndGlowColor(victim);
	return Plugin_Continue;
}

Action Event_ChargerKilled(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int chargerid = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	g_bChargerGrappled[g_iChargerVictim[chargerid]] = false;
	
	return Plugin_Continue;
}

Action Event_TongueGrab(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int iAttacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int iVictim = GetClientOfUserId(GetEventInt(hEvent,"victim"));


	g_bSmokerGrappled[iVictim] = true;
	
	if (Event_TongueGrab_Rochelle(iAttacker, iVictim) == true)
		return Plugin_Continue;
	Event_TongueGrab_Smoker(iAttacker, iVictim);
	
	// Reset the players glow
	SetClientRenderAndGlowColor(iVictim);
	return Plugin_Continue;
}

Action Event_TongueRelease(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int iAttacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int iVictim = GetClientOfUserId(GetEventInt(hEvent,"victim"));


	g_bSmokerGrappled[iVictim] = false;
	g_iChokingVictim[iAttacker] = -1;

	SetClientRenderAndGlowColor(iVictim);
	Event_TongueRelease_Nick(iAttacker, iVictim);

	Event_TongueRelease_Smoker(iAttacker, iVictim);
	

	return Plugin_Continue;
}

Action Event_ChokeStart(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int iAttacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int iVictim = GetClientOfUserId(GetEventInt(hEvent,"victim"));


	g_bSmokerGrappled[iVictim] = true;
	g_iChokingVictim[iAttacker] = iVictim;
	
	Event_ChokeStart_Smoker(iAttacker, iVictim);

	SetClientRenderAndGlowColor(iVictim);
	return Plugin_Continue;
}

Action Event_JockeyRide(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int iAttacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int iVictim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	int iClassNum = GetEntProp(iAttacker, Prop_Send, "m_zombieClass");

	if (iClassNum != JOCKEY)	//If the attacker truely is the JOCKEY(this function is called for more than just JOCKEY for some reason)
		return Plugin_Continue;

	// Rochelle's ninja escape
	if (g_iSmokeLevel[iVictim] > 0)
		HandleRochelleNinjaEscapeGrasp(iAttacker, iVictim);
	
	Event_JockeyRide_Jockey(iAttacker, iVictim);
	
	return Plugin_Continue;
}


Action Event_JockeyRideEnd(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int rider = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));

	HandleDragRaceRewards(rider, victim);

	if(g_iMutatedLevel[rider] > 0 && RunClientChecks(rider)  == true && IsPlayerAlive(rider) == true)
		CreateTimer(1.0, TimerSetJockeyCooldown, rider, TIMER_FLAG_NO_MAPCHANGE);
	
	g_iJockeyVictim[rider] = -1;
	g_bJockeyIsRiding[rider] = false;
	g_bJockeyGrappled[victim] = false;

	g_fJockeyRideSpeed[victim] = 1.0;
	g_fJockeyRideSpeedVanishingActBoost[victim] = 0.0;
	SetClientSpeed(victim);

	if(g_bDivineInterventionQueued[victim] == true)
		CreateTimer(0.1, TimerApplyDivineIntervention, victim, TIMER_FLAG_NO_MAPCHANGE);

	SetClientRenderAndGlowColor(victim);

	return Plugin_Continue;
}


Action Event_HunterPounceStart(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int iAttacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int iVictim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	int iDistance = GetEventInt(hEvent, "distance");

	g_bHunterGrappled[iVictim] = true;
	g_iHunterShreddingVictim[iAttacker] = iVictim;

	SetClientRenderAndGlowColor(iAttacker);
	SetClientRenderAndGlowColor(iVictim);

	if (RunClientChecks(iVictim) == false ||
		RunClientChecks(iAttacker) == false)
		return Plugin_Continue;
	
	Event_HunterPounceStart_Hunter(iAttacker, iVictim, iDistance);
		
	Event_HunterPounceStart_Rochelle(iAttacker, iVictim, iDistance);
	
	return Plugin_Continue;
}

Action Event_HunterPounceStopped(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int victim = GetClientOfUserId(GetEventInt(hEvent,"victim"));
	
	g_bHunterGrappled[victim] = false;
	g_iHunterShreddingVictim[attacker] = -1;
	
	SetClientSpeed(victim);
	//ResetSurvivorSpeed(victim);
	
	if(g_bDivineInterventionQueued[victim] == true)
		CreateTimer(0.1, TimerApplyDivineIntervention, victim, TIMER_FLAG_NO_MAPCHANGE);
	
	SetClientRenderAndGlowColor(attacker);
	SetClientRenderAndGlowColor(victim);
	return Plugin_Continue;
}

Action Event_InfectedHurt(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(hEvent, "attacker"));
	int victim = GetEventInt(hEvent, "entityid");
	int iDamage = GetEventInt(hEvent, "amount");

	AddDamageToDPSMeter(attacker, iDamage);
	
	if(g_iClientTeam[attacker] == TEAM_SURVIVORS)
	{
		switch(g_iChosenSurvivor[attacker])
		{
			case 0:		//Bill
			{
			
			}
			case 1:		//Rochelle
			{
				EventsInfectedHurt_Rochelle(hEvent, attacker, victim);
			}
			case 2:		//Coach
			{
			
			}
			case 3:		//Ellis
			{
			
			}
			case 4:		//Nick
			{
				if(g_iMagnumLevel[attacker] > 0)
				{
					char strCurrentWeapon[32];
					GetClientWeapon(attacker, strCurrentWeapon, sizeof(strCurrentWeapon));
					if(StrEqual(strCurrentWeapon, "weapon_pistol_magnum", false) == true)
					{
						g_iNickMagnumHitsPerClip[attacker]++;
					}
				}
			}
		}
	}
	
	if(g_bUsingFireStorm[attacker]==true)
	{
		float time = (float(g_iFireLevel[attacker]) * 6.0);
		IgniteEntity(victim, time, false);
	}
	
	return Plugin_Continue;
}

Action Event_WitchKilled(Handle hEvent, char[] Event_name, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	int victim = GetEventInt(hEvent, "witchid");
	bool instakill = GetEventBool(hEvent, "oneshot");
	if (iClient > 0 && iClient <= MaxClients)
	{
		if(IsFakeClient(iClient) == true)
			return Plugin_Continue;
		if((GetClientTeam(iClient)) == TEAM_SURVIVORS) 	//can make more efficeint by getting this before
		{
			if(instakill)
			{
				g_iClientXP[iClient] += 350;
				CheckLevel(iClient);
				
				if(g_iXPDisplayMode[iClient] == 0)
					ShowXPSprite(iClient, g_iSprite_350XP, victim, 5.0);
				else if(g_iXPDisplayMode[iClient] == 1)
					PrintToChat(iClient, "\x03[XPMod] Witch Owned! You gain 350 XP");
			}
			else
			{
				g_iClientXP[iClient] += 250;
				CheckLevel(iClient);
				
				if(g_iXPDisplayMode[iClient] == 0)
					ShowXPSprite(iClient, g_iSprite_250XP, victim, 5.0);
				else if(g_iXPDisplayMode[iClient] == 1)
					PrintToChat(iClient, "\x03[XPMod] Witch Killed. You gain 250 XP");
			}
		}
	}
	return Plugin_Continue;
}


Action Event_TankSpawn(Handle hEvent, const char[] strName, bool bDontBroadcast)
{	
	int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	if(RunClientChecks(iClient) == false || IsPlayerAlive(iClient) == false)
		return Plugin_Continue;
	
	
	g_iTankCounter++;
	g_iClientTeam[iClient] = TEAM_INFECTED;
	g_iInfectedCharacter[iClient] = TANK;
	// Get the calculated hp multiplier to scale health based on survivor team
	g_fTankStartingHealthMultiplier[iClient] = CalculateTankHealthPercentageMultiplier();
	// Reset all tank abilities if transitioning from another tank
	// Note: this IS called for the bot, then the player, when officially giving tank to player and not haxored in
	// Note2: This requires a timer, or it does not apply
	CreateTimer(0.1, TimerResetAllTankVariables, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	for (int i = 1;i<=MaxClients;i++)
	{
		if (RunClientChecks(i) == false || 
			IsFakeClient(i) || 
			g_bTalentsConfirmed[i] == false ||
			IsPlayerAlive(i) == false ||
			g_iClientTeam[i] != TEAM_SURVIVORS)
			continue;

		// Ellis's Jamin to the Music Talent Buffs
		if(g_iJamminLevel[i] > 0)
		{
			// Set Ellis's speed for the give amount of tanks spawned
			if(g_iTankCounter > 0)
				SetClientSpeed(i);

			if(g_iJamminLevel[i] == 5)
			{
				GiveEllisAnExtraMolotov(i);
				GiveEllisAnExtraAdrenaline(i);
			}

			PrintHintText(i,"Tank is near, your adrenaline pumps and you become stronger");
		}
	}
	return Plugin_Continue;
}

Action Event_TankFrustrated(Handle hEvent, const char[] strName, bool bDontBroadcast)
{	
	g_iTankCounter--;

	int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	if(RunClientChecks(iClient) == false || IsPlayerAlive(iClient) == false)
		return Plugin_Continue;

	StorePassedOrFrustratedTanksHealthPercentage(iClient);

	g_iInfectedCharacter[iClient] = UNKNOWN_INFECTED;

	PrintToChatAll("\x03[XPMod] \x04%N's tank has been frustrated or passed. Transferring tank with %3f health.", iClient, g_fFrustratedTankTransferHealthPercentage);

	return Plugin_Continue;
}

Action Event_ZombieIgnited(Handle hEvent, char[] Event_name, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	int victim = GetEventInt(hEvent, "entityid");
	
	if (iClient > 0 && iClient <= MaxClients)
	{
		if(IsFakeClient(iClient) == true)
			return Plugin_Continue;
		char victimname[12];
		GetEventString(hEvent, "victimname", victimname, sizeof(victimname));
		if(StrEqual(victimname,"Tank",false))
		{
			if(g_bTankOnFire[victim] == false)
			{
				g_bTankOnFire[victim] = true;
				g_iClientXP[iClient] += 150;
				CheckLevel(iClient);
				
				if(g_iXPDisplayMode[iClient] == 0)
					ShowXPSprite(iClient, g_iSprite_150XP, victim, 5.0);
				else if(g_iXPDisplayMode[iClient] == 1)
					PrintToChat(iClient,"\x03[XPMod] You burned the TANK. You gain 150 XP");
			}
		}
	}
	return Plugin_Continue;
}

Action Event_SpitBurst(Handle hEvent, const char[] strName, bool bDontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(hEvent,"userid"));
	int iSpitEntity = GetEventInt(hEvent,"subject");
	
	if(g_bTalentsConfirmed[iClient] && g_iPuppetLevel[iClient] > 0)
	{
		//Temporarily block switching goo types
		g_bBlockGooSwitching[iClient] = true;
		
		delete g_hTimer_BlockGooSwitching[iClient];
		g_hTimer_BlockGooSwitching[iClient] = CreateTimer(8.2, TimerAllowGooSwitching, iClient);
		
		//Deploying goo type effects
		float position[3];
		GetEntPropVector(iSpitEntity, Prop_Send, "m_vecOrigin", position);
		
		if(g_iGooType[iClient] == GOO_FLAMING)
		{
			MolotovExplode(position);
		}
		else
		{
			int smoke = CreateEntityByName("env_smokestack");
															
			char clientName[128], vecString[32];
			Format(clientName, sizeof(clientName), "Smoke%i", iClient);
			Format(vecString, sizeof(vecString), "%f %f %f", position[0], position[1], position[2]);
		
			char strSpitColorRGB[16];
			int iRed, iGreen, iBlue;
			
			switch(g_iGooType[iClient])
			{
				case GOO_ADHESIVE:
				{
					iRed = 255; iGreen = 255; iBlue = 0;
					WriteParticle(iSpitEntity, "spitter_goo_adhesive",0.0, 10.0);
				}
				case GOO_MELTING:
				{
					iRed = 255; iGreen = 0; iBlue = 0;
					WriteParticle(iSpitEntity, "spitter_goo_melting",0.0, 10.0);
				}
				case GOO_DEMI:
				{
					iRed = 60; iGreen = 0; iBlue = 255;
					WriteParticle(iSpitEntity, "spitter_goo_demi",0.0, 10.0);
				}
				case GOO_REPULSION:
				{
					iRed = 0; iGreen = 0; iBlue = 255;
					WriteParticle(iSpitEntity, "spitter_goo_repulsion",0.0, 10.0);
				}
				case GOO_VIRAL:
				{
					iRed = 0; iGreen = 255; iBlue = 0;
					WriteParticle(iSpitEntity, "spitter_goo_viral",0.0, 10.0);
				}
			}
			
			Format(strSpitColorRGB, sizeof(strSpitColorRGB), "%i %i %i", iRed, iGreen, iBlue);
			
			DispatchKeyValue(smoke,"targetname", clientName);
			DispatchKeyValue(smoke,"Origin", vecString);
			DispatchKeyValue(smoke,"BaseSpread", "1");		//Gap in the middle
			DispatchKeyValue(smoke,"SpreadSpeed", "100");	//Speed the smoke moves outwards
			DispatchKeyValue(smoke,"Speed", "100");			//Speed the smoke moves up
			DispatchKeyValue(smoke,"StartSize", "200");
			DispatchKeyValue(smoke,"EndSize", "200");
			DispatchKeyValue(smoke,"Rate", "20");			//Amount of smoke created
			DispatchKeyValue(smoke,"JetLength", "200");		//Smoke jets outside of the original
			DispatchKeyValue(smoke,"Twist", "10"); 			//Amount of global twisting
			DispatchKeyValue(smoke,"RenderColor", strSpitColorRGB);
			DispatchKeyValue(smoke,"RenderAmt", "50");		//Transparency
			DispatchKeyValue(smoke,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");
			
			DispatchSpawn(smoke);
			AcceptEntityInput(smoke, "TurnOn");
			
			CreateTimer(8.0, TimerStopSmokeEntity, smoke, TIMER_FLAG_NO_MAPCHANGE);
		}
		
			if(g_iMaterialLevel[iClient] > 0)
			{			
				position[1] += 1.0;
				position[2] += 1.0;
			
			WriteParticle(iClient, "spitter_conjure", 180.0, 7.0, position);
			
			Handle hDataPackage = CreateDataPack();
			WritePackCell(hDataPackage, iClient);
			WritePackFloat(hDataPackage, position[0]);
			WritePackFloat(hDataPackage, position[1]);
			WritePackFloat(hDataPackage, position[2]);
			
			CreateTimer(0.5, TimerConjureUncommonInfected, hDataPackage);

			// Handle Bag of Spits, if they have a Bind 1 and have selected something
			if (g_iClientBindUses_1[iClient] < 3 && g_iBagOfSpitsSelectedSpit[iClient] != BAG_OF_SPITS_NONE)
			{
				Handle hBagOfSpitsDataPackage = CreateDataPack();
				WritePackCell(hBagOfSpitsDataPackage, iClient);
				WritePackFloat(hBagOfSpitsDataPackage, position[0]);
				WritePackFloat(hBagOfSpitsDataPackage, position[1]);
				WritePackFloat(hBagOfSpitsDataPackage, position[2]);
				CreateTimer(0.5, TimerConjureFromBagOfSpits, hBagOfSpitsDataPackage);
			}
			
				if(g_iHallucinogenicLevel[iClient] > 0)
					CreateTimer(1.0, TimerSetSpitterCooldown, iClient,  TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		return Plugin_Continue;
}

Action Event_WitchSpawn(Handle hEvent, const char[] sName, bool bDontBroadcast)
{
	int iWitchID = GetEventInt(hEvent, "witchid");
	
	bool bOwnerFound = false;
	int iClient;
	for(iClient = 1; iClient <= MaxClients; iClient++)
	{
		if(g_bJustSpawnedWitch[iClient] == true && g_iClientTeam[iClient] == TEAM_INFECTED && g_iInfectedCharacter[iClient] == SPITTER
			&& IsClientInGame(iClient) == true && IsFakeClient(iClient) == false)
		{
			g_bJustSpawnedWitch[iClient] = false;
			bOwnerFound = true;
			break;
		}
	}
	
	if(bOwnerFound == false)
		return Plugin_Continue;
	
	
	SetEntityModel(iWitchID, "models/infected/common_female_tshirt_skirt.mdl");
		
	TeleportEntity(iWitchID, g_xyzWitchConjureLocation[iClient], NULL_VECTOR, NULL_VECTOR);
	
	CreateTimer(0.1, Timer_CheckWitchRage, iWitchID, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Continue;
}

Action Timer_CheckWitchRage(Handle timer, int iWitchID)
{
	if(IsValidEntity(iWitchID) == false)
		return Plugin_Stop;

	// Timer_CheckWitchRage: id = 796, className = witch
	char className[32];
	GetEntityClassname(iWitchID, className, 32)
	if (strcmp(className, "witch", true) != 0)
	{
		return Plugin_Stop;
	}
	
	float fRage = GetEntPropFloat(iWitchID, Prop_Send, "m_rage");
	if(fRage >= 1.0)
	{
		SetEntityModel(iWitchID, "models/infected/witch.mdl");
		
		float position[3];
		GetEntPropVector(iWitchID, Prop_Send, "m_vecOrigin", position);

		int smoke = CreateEntityByName("env_smokestack");
		
		char clientName[128], vecString[32];
		Format(clientName, sizeof(clientName), "Smoke%i", iWitchID);
		Format(vecString, sizeof(vecString), "%f %f %f", position[0], position[1], position[2]);

		DispatchKeyValue(smoke,"targetname", clientName);
		DispatchKeyValue(smoke,"Origin", vecString);
		DispatchKeyValue(smoke,"BaseSpread", "0");		//Gap in the middle
		DispatchKeyValue(smoke,"SpreadSpeed", "75");	//Speed the smoke moves outwards
		DispatchKeyValue(smoke,"Speed", "60");			//Speed the smoke moves up
		DispatchKeyValue(smoke,"StartSize", "10");
		DispatchKeyValue(smoke,"EndSize", "80");
		DispatchKeyValue(smoke,"Rate", "20");			//Amount of smoke created
		DispatchKeyValue(smoke,"JetLength", "80");		//Smoke jets outside of the original
		DispatchKeyValue(smoke,"Twist", "1"); 			//Amount of global twisting
		DispatchKeyValue(smoke,"RenderColor", "0 255 0");
		DispatchKeyValue(smoke,"RenderAmt", "255");		//Transparency
		DispatchKeyValue(smoke,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");

		DispatchSpawn(smoke);
		AcceptEntityInput(smoke, "TurnOn");
		
		CreateTimer(1.0, TimerStopSmokeEntity, smoke, TIMER_FLAG_NO_MAPCHANGE);
		
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}
