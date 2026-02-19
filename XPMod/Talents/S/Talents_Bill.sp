void TalentsLoad_Bill(int iClient)
{
	SetPlayerTalentMaxHealth_Bill(iClient, !g_bSurvivorTalentsGivenThisRound[iClient]);
	SetClientSpeed(iClient);

	if (g_iGhillieLevel[iClient] > 0 || g_iPromotionalLevel[iClient] > 0)
	{
		if (g_bGameFrozen == false)
		{
			SetEntityRenderMode(iClient, RenderMode:3);
			SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (((float(g_iGhillieLevel[iClient]) * 0.13) + ((float(g_iPromotionalLevel[iClient]) * 0.04)))))));
			if(g_iPromotionalLevel[iClient] > 0)	//disable glow
			{
				SetEntProp(iClient, Prop_Send, "m_iGlowType", 3);
				SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
				SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 1);
				ChangeEdictState(iClient, 12);
			}
		}
	}
	
	if(g_iWillLevel[iClient] > 0)
	{

		if(g_bSurvivorTalentsGivenThisRound[iClient] == false)
		{			
			//Set Convar for crawling speed
			g_iCrawlSpeedMultiplier += g_iWillLevel[iClient] * 5;
			SetConVarInt(FindConVar("survivor_crawl_speed"), (15 + g_iCrawlSpeedMultiplier),false,false);
			SetConVarInt(FindConVar("survivor_allow_crawling"),1,false,false);
		}
	}
	
	if(g_bSurvivorTalentsGivenThisRound[iClient] == false && g_iPromotionalLevel[iClient] > 0)
	{
		if(g_iPromotionalLevel[iClient]==1 || g_iPromotionalLevel[iClient]==2)
			g_iClientBindUses_2[iClient] = 2;
		else if(g_iPromotionalLevel[iClient]==3 || g_iPromotionalLevel[iClient]==4)
			g_iClientBindUses_2[iClient] = 1;
		else
			g_iClientBindUses_2[iClient] = 0;
	}
	
	if((g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))
		PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Support Talents \x05have been loaded.");
	else
		PrintToChat(iClient, "\x03[XPMod] \x05Your abilties will be automatically set as you level.");
}


void SetPlayerTalentMaxHealth_Bill(int iClient, bool bFillInHealthGap = true)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iChosenSurvivor[iClient] != BILL ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;
	
	SetPlayerMaxHealth(iClient,
	100 + 
	(g_iWillLevel[iClient]*5) + 
	(g_iDiehardLevel[iClient]*15) + 
	(g_iCoachTeamHealthStack * 5), 
	false, 
	bFillInHealthGap);
}

void OnGameFrame_Bill(int iClient)
{
	if (g_bGameFrozen)
		return;

	int iButtons;
	iButtons = GetEntProp(iClient, Prop_Data, "m_nButtons", iButtons);
	
	HandleBillsTeamHealing(iClient, iButtons);

	if(g_bBillSprinting[iClient] == false)
	{
		if(iButtons & IN_SPEED)
		{
			if(g_iBillSprintChargePower[iClient] == 1)
				PrintHintText(iClient, "Powering on sprinting device...");
			else if(g_iBillSprintChargePower[iClient] > 49)
				PrintHintText(iClient, "Powering on sprinting device...%d%%", g_iBillSprintChargePower[iClient]);
			
			g_iBillSprintChargePower[iClient]++;

			if(g_iBillSprintChargePower[iClient] == 100)
			{
				g_bBillSprinting[iClient] = true;
				SetClientSpeed(iClient);
				g_iBillSprintChargePower[iClient] =  0;
			}
		}
		else
		{
			if(g_iBillSprintChargePower[iClient] > 0)
				g_iBillSprintChargePower[iClient] =  0;
			if(g_iBillSprintChargeCounter[iClient] == ((g_iGhillieLevel[iClient] * 600) - 1))
			{
				PrintHintText(iClient, "Your suit's sprinting device is fully charged");
				float vec[3];
				GetClientAbsOrigin(iClient, vec);
				EmitSoundToAll(SOUND_SUITCHARGED, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
			}
			if(g_iBillSprintChargeCounter[iClient] < (g_iGhillieLevel[iClient] * 600))
				g_iBillSprintChargeCounter[iClient]++;
		}
	}
	else
	{
		PrintHintText(iClient, "Remaining Charge: %dW", g_iBillSprintChargeCounter[iClient] / 20);
		g_iBillSprintChargeCounter[iClient]--;
		if ((iButtons & IN_FORWARD) ||
			(iButtons & IN_BACK) ||
			(iButtons & (IN_LEFT|IN_MOVELEFT)) ||
			(iButtons & (IN_RIGHT|IN_MOVERIGHT)))
		{
			g_iBillSprintChargeCounter[iClient]-=9;
			PrintHintText(iClient, "Remaining Charge: %dW", g_iBillSprintChargeCounter[iClient] / 20);
		}
		if(g_iBillSprintChargeCounter[iClient] < 11)
		{
			PrintHintText(iClient, "Sprinting Charge Depleted");
			g_bBillSprinting[iClient] = false;
			SetClientSpeed(iClient);
		}
	}

	if(g_iPromotionalLevel[iClient] > 0)
	{
		if ((iButtons & IN_RELOAD) && 
			g_bClientIsReloading[iClient] == false && 
			g_bForceReload[iClient] == false)
		{
			char currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			int ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (IsValidEntity(ActiveWeaponID) ==  false)
				return;

			int CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			
			if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
			{
				int iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				int iAmmo = GetEntData(iClient, iOffset_Ammo + 12);
				if(iAmmo > 0)
				{
					g_bForceReload[iClient] = true;
					g_iSavedClip[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_Clip1, 0, true);
					SetEntData(iClient, iOffset_Ammo + 12, iAmmo + g_iSavedClip[iClient]);
				}
			}
		}
	}
}

void OGFSurvivorReload_Bill(int iClient, const char[] currentweapon, int ActiveWeaponID, int CurrentClipAmmo, int iOffset_Ammo)
{
	//if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
	//if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo != 0))
	if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
	{
		int iAmmo = GetEntData(iClient, iOffset_Ammo + 12);//for rifle (+12)
		if(iAmmo >= (g_iPromotionalLevel[iClient]*20))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iPromotionalLevel[iClient]*20)), true);
			SetEntData(iClient, iOffset_Ammo + 12, iAmmo - (g_iPromotionalLevel[iClient]*20));
			g_bClientIsReloading[iClient] = false;
			g_iReloadFrameCounter[iClient] = 0;
		}
		else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
		{
			int NewAmmo = ((g_iPromotionalLevel[iClient]*20) - iAmmo);
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iPromotionalLevel[iClient]*20) - NewAmmo)), true);
			SetEntData(iClient, iOffset_Ammo + 12, 0);
			g_bClientIsReloading[iClient] = false;
			g_iReloadFrameCounter[iClient] = 0;
		}
	}
}

void EventsHurt_AttackerBill(Handle hEvent, int iAttacker, int iVictim)
{
	if (RunClientChecks(iAttacker) == false ||
		g_bTalentsConfirmed[iAttacker] == false ||
		g_iExorcismLevel[iAttacker] <= 0 ||
		g_iClientTeam[iAttacker] != TEAM_SURVIVORS ||
		g_iClientTeam[iVictim] != TEAM_INFECTED ||
		IsFakeClient(iAttacker) == true)
		return;

	char strWeaponClass[32];
	GetEventString(hEvent,"weapon",strWeaponClass,32);
	if (StrContains(strWeaponClass,"rifle",false) == -1 || 
		StrContains(strWeaponClass,"hunting_rifle",false) != -1)
		return;

	int iDmgAmount = CalculateDamageTakenForVictimTalents(
		iVictim,
		StrContains(strWeaponClass,"rifle_m60",false) == -1 ?
			RoundToNearest(GetEventInt(hEvent, "dmg_health") * (g_iExorcismLevel[iAttacker] * 0.06)) : 
			RoundToNearest(GetEventInt(hEvent, "dmg_health") * (g_iPromotionalLevel[iAttacker] * 0.20)),
		strWeaponClass);
	
	SetPlayerHealth(iVictim, iAttacker, -1 * iDmgAmount, true);
}

Action tmrPlayAnim(Handle timer, int iClient)
{
	PlayAnim(iClient);
	return Plugin_Stop;
}

void PlayAnim(int iClient)
{
	if (RunClientChecks(iClient) == false)
		return;

	int iAnim;
	char s_Model[128];
	GetEntPropString(iClient, Prop_Data, "m_ModelName", s_Model, 128);

	if( StrEqual(s_Model, "models/survivors/survivor_gambler.mdl") )
		iAnim = ANIM_L4D2_NICK;		// Nick
	else if( StrEqual(s_Model, "models/survivors/survivor_mechanic.mdl") )
		iAnim = ANIM_L4D2_ELLIS;	// Ellis
	else if( StrEqual(s_Model, "models/survivors/survivor_producer.mdl") )
		iAnim = ANIM_L4D2_ROCHELLE;	// Rochelle
	else if( StrEqual(s_Model, "models/survivors/survivor_teenangst.mdl") )
		iAnim = ANIM_L4D2_ZOEY;		// Zoey
	else if( StrEqual(s_Model, "models/survivors/survivor_manager.mdl") )
		iAnim = ANIM_L4D2_LOUIS;	// Louis
	else if( StrEqual(s_Model, "models/survivors/survivor_biker.mdl") )
		iAnim = ANIM_L4D2_FRANCIS;	// Francis
	else if( StrEqual(s_Model, "models/survivors/survivor_namvet.mdl") )
		iAnim = ANIM_L4D2_BILL;		// Bill
	else if( StrEqual(s_Model, "models/survivors/survivor_coach.mdl") )
		return;
	

	// Create survivor clone
	gClone[iClient] = -1;
	int iClone = CreateEntityByName("prop_dynamic");
	if (iClone == -1) return;
	SetEntityModel(iClone,s_Model);
	gClone[iClient] = iClone; // Global clone ID

	// Attach to survivor
	char sValue[128];
	Format(sValue, sizeof(sValue), "target%i", iClient);
	DispatchKeyValue(iClient, "targetname", sValue);

	SetVariantString(sValue);
	AcceptEntityInput(iClone, "SetParent", iClone, iClone, 0);

	// Attach
	SetVariantString("bleedout");
	AcceptEntityInput(iClone,"SetParentAttachment");

	// Get origin
	float fAngles[3];
	float fOrigin[3];
	GetClientAbsAngles(iClient, fAngles);
	GetClientAbsOrigin(iClient, fOrigin);

	// Correct origin
	fOrigin[0] += (10 * (Cosine(DegToRad(fAngles[1] - 23))));
	fOrigin[1] += (10 * (Sine(DegToRad(fAngles[1] - 23))));
	fOrigin[2] -= 0.5;

	// Set origin
	DispatchKeyValueVector(iClone, "Origin", fOrigin);

	// Set angle
	Format(sValue,65," %f %f %f",-330.0,fAngles[1]-100,70.0);
	DispatchKeyValue(iClone, "angles", sValue);

	// Set animation
	SetEntProp(iClone, Prop_Send, "m_nSequence", iAnim);
	SetEntPropFloat(iClone, Prop_Send, "m_flPlaybackRate", 1.0);

	// Make Survivor Invisible
	SetAlpha(iClient,0);
}

void RestoreClient(int iClient)
{
	SetAlpha(iClient,255);		// Make visible
	RemoveClone(iClient);		// Delete clone
	SetClientRenderAndGlowColor(iClient);
	//ResetGlow(iClient);
}

void RemoveClone(int iClient)
{
	int iClone = gClone[iClient];
	gClone[iClient] = -1;
	if (iClone > 0 && IsValidEntity(iClone))
		AcceptEntityInput(iClone, "Kill");
}

void SetAlpha(int target, int alpha)
{
	SetEntityRenderMode(target, RENDER_TRANSCOLOR);
	SetEntityRenderColor(target, 255, 255, 255, alpha);
}

void HandleBillsTeamHealing(int iClient, int iButtons)
{
	if (RunClientChecks(iClient) == false ||
		g_bTalentsConfirmed[iClient] ==  false ||
		g_iInspirationalLevel[iClient] < 0 ||
		g_bIsClientDown[iClient] == true ||
		IsClientGrappled(iClient) == true ||
		IsPlayerAlive(iClient) == false)
		return;

	// If Bill has run out of healing pool then return
	if (g_iBillsTeamHealthPool <= 0)
		return;

	//This determines the length between each heal
	if ((iButtons & IN_DUCK))
		g_iBillTeamHealCounter[iClient]++;
	else
		g_iBillTeamHealCounter[iClient] = 0;

	// If the length is not long enough then return;
	if(g_iBillTeamHealCounter[iClient] < BILL_TEAM_HEAL_FRAME_COUNTER_REQUIREMENT * 30) // 30 FPS	
		return;

	// Reset after the heal time requirement has been met
	g_iBillTeamHealCounter[iClient] = 0;

	// Search for the closest survivor and heal them
	int iTargetToHeal = FindClosestSurvivor(iClient, true);
	if (iTargetToHeal == -1)
		return;

	float xyzClientLocation[3], xyzTargetLocation[3];
	GetClientEyePosition(iClient, xyzClientLocation);
	GetClientEyePosition(iTargetToHeal, xyzTargetLocation);
	if (GetVectorDistance(xyzClientLocation, xyzTargetLocation) > BILL_TEAM_HEAL_MAX_DISTANCE)
		return;
	
	int iCurrentHealth = GetPlayerHealth(iTargetToHeal);
	int iMaxHealth = GetPlayerMaxHealth(iTargetToHeal);
	int iTempHealth = GetSurvivorTempHealth(iTargetToHeal);

	if (iCurrentHealth + iTempHealth >= iMaxHealth)
		return;

	int iHealAmount = iMaxHealth - iCurrentHealth - iTempHealth > BILL_TEAM_HEAL_HP_AMOUNT ? BILL_TEAM_HEAL_HP_AMOUNT : iMaxHealth - iCurrentHealth - iTempHealth;

	// Check that the pool has enough health to heal the full amount, cap if not
	iHealAmount = iHealAmount > g_iBillsTeamHealthPool ? g_iBillsTeamHealthPool : iHealAmount;

	SetPlayerHealth(iTargetToHeal, -1, iHealAmount, true);

	g_iBillsTeamHealthPool -= iHealAmount;

	// Print health pool message
	PrintHintText(iClient, "Team Support Health Pool: %i", g_iBillsTeamHealthPool);

	// Create the sound and particle effects
	xyzClientLocation[2] -= 10.0;
	xyzTargetLocation[2] -= 10.0;
	int iRandomSound = GetRandomInt(1, 3);
	char strZapSound[23];
	switch(iRandomSound)
	{
		case 1: strcopy(strZapSound, sizeof(strZapSound),SOUND_ZAP1);
		case 2: strcopy(strZapSound, sizeof(strZapSound),SOUND_ZAP2);
		case 3: strcopy(strZapSound, sizeof(strZapSound),SOUND_ZAP3);
	}
	int pitch = GetRandomInt(95, 130);
	EmitSoundToAll(strZapSound, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.1, pitch, -1, xyzClientLocation, NULL_VECTOR, true, 0.0);
	EmitSoundToAll(strZapSound, iTargetToHeal, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.1, pitch, -1, xyzTargetLocation, NULL_VECTOR, true, 0.0);
	TE_SetupBeamPoints(xyzClientLocation, xyzTargetLocation, g_iSprite_Laser, 0, 0, 66, 0.3, 0.2, 0.2, 0, 4.0, {0,40,255,200}, 0);
	TE_SendToAll();
}
