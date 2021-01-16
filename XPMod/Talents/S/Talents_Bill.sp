OnGameFrame_Bill(iClient)
{
	if(g_bGameFrozen == false)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(g_iInspirationalLevel[iClient] > 0)
		{
			if(buttons & IN_DUCK && g_bIsClientDown[iClient] == false && IsClientGrappled(iClient) == false)
			{
				if(g_iBillTeamHealCounter[iClient] > 180)	//This determines the length between each pause
				{
					decl maxHP, currentHP, counter;
					if(g_iClientToHeal[iClient] < 1)	//Just in case
						g_iClientToHeal[iClient] = 1;
					counter = 0;
					for(;g_iClientToHeal[iClient] <= MaxClients; g_iClientToHeal[iClient]++)
					{
						if(counter++ == MaxClients)
							break;
						//PrintToChatAll("%d", g_iClientToHeal[iClient]);
						if(g_iClientToHeal[iClient] == MaxClients)
							g_iClientToHeal[iClient] = 1;
						if(IsClientInGame(g_iClientToHeal[iClient]) == true)
							if(g_iClientToHeal[iClient] != iClient)
								if(g_iClientTeam[g_iClientToHeal[iClient]] == TEAM_SURVIVORS)
								{
									if(IsPlayerAlive(g_iClientToHeal[iClient]) == true)
									{
										if(g_bIsClientDown[g_iClientToHeal[iClient]] == false && IsClientGrappled(g_iClientToHeal[iClient]) == false)
										{
											maxHP = GetEntProp(g_iClientToHeal[iClient],Prop_Data,"m_iMaxHealth");
											currentHP = GetEntProp(g_iClientToHeal[iClient],Prop_Data,"m_iHealth");
											if(currentHP == maxHP)
												continue;
											if((currentHP + g_iInspirationalLevel[iClient]) > maxHP)
												SetEntityHealth(g_iClientToHeal[iClient], maxHP);
											else
											{
												currentHP += g_iInspirationalLevel[iClient];
												SetEntityHealth(g_iClientToHeal[iClient], currentHP);
											}
											decl Float:clientloc[3],Float:targetloc[3];
											GetClientEyePosition(iClient,clientloc);
											GetClientEyePosition(g_iClientToHeal[iClient],targetloc);
											clientloc[2] -= 10.0;
											targetloc[2] -= 10.0;
											new rand = GetRandomInt(1, 3);
											decl String:zap[23];
											switch(rand)
											{
												case 1: zap = SOUND_ZAP1;
												case 2: zap = SOUND_ZAP2;
												case 3: zap = SOUND_ZAP3;
											}
											new pitch = GetRandomInt(95, 130);
											EmitSoundToAll(zap, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.1, pitch, -1, clientloc, NULL_VECTOR, true, 0.0);
											EmitSoundToAll(zap, g_iClientToHeal[iClient], SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.1, pitch, -1, targetloc, NULL_VECTOR, true, 0.0);
											TE_SetupBeamPoints(clientloc,targetloc,g_iSprite_Laser,0,0,66,0.3, 0.2, 0.2,0,4.0,{0,40,255,200},0);
											TE_SendToAll();
											g_iClientToHeal[iClient]++;
											break;
										}
									}
								}
					}
					g_iBillTeamHealCounter[iClient] = 0;
				}
				else
					g_iBillTeamHealCounter[iClient]++;
			}
		}
		if(g_bBillSprinting[iClient] == false)
		{
			if(buttons & IN_SPEED)
			{
				if(g_iBillSprintChargePower[iClient] == 1)
					PrintHintText(iClient, "Powering on sprinting device...");
				else if(g_iBillSprintChargePower[iClient] > 49)
					PrintHintText(iClient, "Powering on sprinting device...%d%%", g_iBillSprintChargePower[iClient]);
				g_iBillSprintChargePower[iClient]++;
				if(g_iBillSprintChargePower[iClient] == 100)
				{
					g_bBillSprinting[iClient] = true;
					//g_fBillSprintSpeed[iClient] = 1.0;
					//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), ((1.0 + g_fBillSprintSpeed[iClient]) - g_fClientSpeedPenalty[iClient]), true);
					g_fClientSpeedBoost[iClient] += 1.0;
					fnc_SetClientSpeed(iClient);
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
					decl Float:vec[3];
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
			if((buttons & IN_FORWARD) || (buttons & IN_BACK) || (buttons & (IN_LEFT|IN_MOVELEFT)) || (buttons & (IN_RIGHT|IN_MOVERIGHT)))
			{
				g_iBillSprintChargeCounter[iClient]-=9;
				PrintHintText(iClient, "Remaining Charge: %dW", g_iBillSprintChargeCounter[iClient] / 20);
			}
			if(g_iBillSprintChargeCounter[iClient] < 11)
			{
				PrintHintText(iClient, "Sprinting Charge Depleted");
				//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0, true);
				g_bBillSprinting[iClient] = false;
				//g_fBillSprintSpeed[iClient] = 0.0;
				g_fClientSpeedBoost[iClient] -= 1.0;
				fnc_SetClientSpeed(iClient);
			}
		}
	}
	if(g_iPromotionalLevel[iClient] > 0)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if((buttons & IN_RELOAD) && g_bClientIsReloading[iClient] == false && g_bForceReload[iClient] == false)
		{
			decl String:currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			if (IsValidEntity(ActiveWeaponID) ==  false)
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
		}
	}
}

OGFSurvivorReload_Bill(int iClient, const char[] currentweapon, int ActiveWeaponID, int CurrentClipAmmo, int iOffset_Ammo)
{
	//if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
	//if((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true) || (StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) || (StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo != 0))
	if((((StrEqual(currentweapon, "weapon_rifle", false) == true) || (StrEqual(currentweapon, "weapon_rifle_sg552", false) == true)) && (CurrentClipAmmo == 50)) || ((StrEqual(currentweapon, "weapon_rifle_ak47", false) == true) && (CurrentClipAmmo == 40)) || ((StrEqual(currentweapon, "weapon_rifle_desert", false) == true) && (CurrentClipAmmo == 60)))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 12);	//for rifle (+12)
		if(iAmmo >= (g_iPromotionalLevel[iClient]*20))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iPromotionalLevel[iClient]*20)), true);
			SetEntData(iClient, iOffset_Ammo + 12, iAmmo - (g_iPromotionalLevel[iClient]*20));
			g_bClientIsReloading[iClient] = false;
			g_iReloadFrameCounter[iClient] = 0;
			//PrintToChatAll("Clip Set");
		}
		else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
		{
			new NewAmmo = ((g_iPromotionalLevel[iClient]*20) - iAmmo);
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iPromotionalLevel[iClient]*20) - NewAmmo)), true);
			SetEntData(iClient, iOffset_Ammo + 12, 0);
			g_bClientIsReloading[iClient] = false;
			g_iReloadFrameCounter[iClient] = 0;
			//PrintToChatAll("Clip Set");
		}
	}
}

Action:tmrPlayAnim(Handle:timer,any:iClient)
	PlayAnim(iClient);

Action:PlayAnim(iClient)
{
	if (RunClientChecks(iClient) == false)
		return;

	decl iAnim;
	new String:s_Model[128];
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
	new iClone = CreateEntityByName("prop_dynamic");
	if (iClone == -1) return;
	SetEntityModel(iClone,s_Model);
	gClone[iClient] = iClone; // Global clone ID

	// Attach to survivor
	decl String:sValue[128];
	Format(sValue, sizeof(sValue), "target%i", iClient);
	DispatchKeyValue(iClient, "targetname", sValue);

	SetVariantString(sValue);
	AcceptEntityInput(iClone, "SetParent", iClone, iClone, 0);

	// Attach
	SetVariantString("bleedout");
	AcceptEntityInput(iClone,"SetParentAttachment");

	// Get origin
	decl Float:fAngles[3];
	decl Float:fOrigin[3];
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

RestoreClient(iClient)
{
	SetAlpha(iClient,255);		// Make visible
	RemoveClone(iClient);		// Delete clone
	fnc_SetRendering(iClient);
	//ResetGlow(iClient);
}

RemoveClone(iClient)
{
	new iClone = gClone[iClient];
	gClone[iClient] = -1;
	if (IsValidEntity(iClone)) RemoveEdict(iClone);
}

SetAlpha(target, alpha)
{
    SetEntityRenderMode(target, RENDER_TRANSCOLOR);
    SetEntityRenderColor(target, 255, 255, 255, alpha);
}