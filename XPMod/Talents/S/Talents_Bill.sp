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

public Action:tmrPlayAnim(Handle:timer,any:i_Client)
	PlayAnim(i_Client);

public Action:PlayAnim(i_Client)
{
	decl i_Anim;
	new String:s_Model[128];
	GetEntPropString(i_Client, Prop_Data, "m_ModelName", s_Model, 128);

	if( StrEqual(s_Model, "models/survivors/survivor_gambler.mdl") )
		i_Anim = ANIM_L4D2_NICK;	// Nick
	else if( StrEqual(s_Model, "models/survivors/survivor_mechanic.mdl") )
		i_Anim = ANIM_L4D2_ELLIS;	// Ellis
	else if( StrEqual(s_Model, "models/survivors/survivor_producer.mdl") )
		i_Anim = ANIM_L4D2_ROCH;	// Rochelle
	else if( StrEqual(s_Model, "models/survivors/survivor_teenangst.mdl") )
		i_Anim = ANIM_L4D2_ZOEY;	// Zoey
	else if( StrEqual(s_Model, "models/survivors/survivor_manager.mdl") )
		i_Anim = ANIM_L4D2_LOUIS;	// Louis
	else if( StrEqual(s_Model, "models/survivors/survivor_biker.mdl") )
		i_Anim = ANIM_L4D2_FRANCIS;	// Francis
	else if( StrEqual(s_Model, "models/survivors/survivor_namvet.mdl") )
		i_Anim = ANIM_L4D2_BILL;	// Bill
	else if( StrEqual(s_Model, "models/survivors/survivor_coach.mdl") )
		return;
	

	// Create survivor clone
	g_Clone[i_Client] = -1;
	new i_Clone = CreateEntityByName("prop_dynamic");
	if (i_Clone == -1) return;
	SetEntityModel(i_Clone,s_Model);
	g_Clone[i_Client] = i_Clone; // Global clone ID

	// Attach to survivor
	decl String:s_Value[128];
	Format(s_Value, sizeof(s_Value), "target%i", i_Client);
	DispatchKeyValue(i_Client, "targetname", s_Value);

	SetVariantString(s_Value);
	AcceptEntityInput(i_Clone, "SetParent", i_Clone, i_Clone, 0);

	// Attach
	SetVariantString("bleedout");
	AcceptEntityInput(i_Clone,"SetParentAttachment");

	// Get origin
	decl Float:f_Angles[3];
	decl Float:f_Origin[3];
	GetClientAbsAngles(i_Client, f_Angles);
	GetClientAbsOrigin(i_Client, f_Origin);

	// Correct origin
	f_Origin[0] += (10 * (Cosine(DegToRad(f_Angles[1] - 23))));
	f_Origin[1] += (10 * (Sine(DegToRad(f_Angles[1] - 23))));
	f_Origin[2] -= 0.5;

	// Set origin
	DispatchKeyValueVector(i_Clone, "Origin", f_Origin);

	// Set angle
	Format(s_Value,65," %f %f %f",-330.0,f_Angles[1]-100,70.0);
	DispatchKeyValue(i_Clone, "angles", s_Value);

	// Set animation
	SetEntProp(i_Clone, Prop_Send, "m_nSequence", i_Anim);
	SetEntPropFloat(i_Clone, Prop_Send, "m_flPlaybackRate", 1.0);

	// Make Survivor Invisible
	SetAlpha(i_Client,0);
}

RestoreClient(i_Client)
{
	SetAlpha(i_Client,255);		// Make visible
	RemoveClone(i_Client);		// Delete clone
	fnc_SetRendering(i_Client);
	//ResetGlow(i_Client);
}

RemoveClone(i_Client)
{
	new i_Clone = g_Clone[i_Client];
	g_Clone[i_Client] = -1;
	if (IsValidEntity(i_Clone)) RemoveEdict(i_Clone);
}

SetAlpha(target, alpha)
{
    SetEntityRenderMode(target, RENDER_TRANSCOLOR);
    SetEntityRenderColor(target, 255, 255, 255, alpha);
}