OnGameFrame_Coach(iClient)
{
	if(g_iStrongLevel[iClient] > 0)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(clienthanging[iClient] == true)
		{
			if(g_bIsJetpackOn[iClient]==true)
			{
				if(buttons & IN_SPEED)
				{
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give health");
					SetCommandFlags("give", g_iFlag_Give);
					SetEntProp(iClient,Prop_Data,"m_iHealth", preledgehealth[iClient]);
					if(preledgebuffer[iClient] > 1.1)
						SetEntDataFloat(iClient,g_iOffset_HealthBuffer, (preledgebuffer[iClient] - 1.0) ,true);
					else
						SetEntDataFloat(iClient,g_iOffset_HealthBuffer, 0.0 ,true);
					clienthanging[iClient] = false;
				}
			}
		}
		else
		{
			preledgehealth[iClient] = GetClientHealth(iClient);
			preledgebuffer[iClient] = GetEntDataFloat(iClient,g_iOffset_HealthBuffer);
			//PrintToChat(iClient, "%d", preledgehealth[iClient]);
		}
		if(g_bIsJetpackOn[iClient] == true)
		{
			
			if (buttons & IN_SPEED && g_bIsClientDown[iClient] == false && IsClientGrappled(iClient) == false)
			{
				if(canchangemovement[iClient] == true)
					StartFlying(iClient);
			}
			else
			{
				if (g_bIsFlyingWithJetpack[iClient])
					StopFlying(iClient);
				
				if(g_bIsMovementTypeFly[iClient] == true)	//Reset movement type only if they are back on the ground again
				{
					if(canchangemovement[iClient] == true)
					{
						if(GetEntityFlags(iClient) & FL_ONGROUND)
						{
							SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
							g_bIsMovementTypeFly[iClient] = false;
						}
					}
				}
			}
		}
		if(g_bCanCoachGrenadeCycle[iClient] == true)
		{
			if((buttons & IN_SPEED) && (buttons & IN_ZOOM))
			{
				decl String:currentweapon[32];
				GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
				if((StrContains(currentweapon, "vomitjar", false) != -1) || (StrContains(currentweapon, "molotov", false) != -1) || (StrContains(currentweapon, "pipe_bomb", false) != -1))
				{
					if(g_iStrongLevel[iClient] == 2 || g_iStrongLevel[iClient] == 3)
					{
						g_bCanCoachGrenadeCycle[iClient] = false;
						g_bIsCoachInGrenadeCycle[iClient] = true;
						CreateTimer(0.5, TimerCanCoachGrenadeCycleReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
						new ActiveGrenadeID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
						if(g_iCoachCurrentGrenadeSlot[iClient] == 0)
						{
							if(StrContains(g_strCoachGrenadeSlot2, "vomitjar", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 1;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give vomitjar");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "molotov", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 1;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give molotov");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "pipe_bomb", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 1;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give pipe_bomb");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1)
							{
								//PrintToChatAll("The next grenade slot is empty");
							}
						}
						else if(g_iCoachCurrentGrenadeSlot[iClient] == 1)
						{
							if(StrContains(g_strCoachGrenadeSlot1, "vomitjar", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 0;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give vomitjar");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "molotov", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 0;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give molotov");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "pipe_bomb", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 0;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give pipe_bomb");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1)
							{
								//PrintToChatAll("The next grenade slot is empty");
							}
						}
					}
					if(g_iStrongLevel[iClient] == 4 || g_iStrongLevel[iClient] == 5)
					{
						g_bCanCoachGrenadeCycle[iClient] = false;
						g_bIsCoachInGrenadeCycle[iClient] = true;
						CreateTimer(0.5, TimerCanCoachGrenadeCycleReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
						new ActiveGrenadeID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
						if(g_iCoachCurrentGrenadeSlot[iClient] == 0)
						{
							if(StrContains(g_strCoachGrenadeSlot2, "vomitjar", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 1;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give vomitjar");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "molotov", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 1;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give molotov");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "pipe_bomb", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 1;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give pipe_bomb");
							}
							else if(StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1)
							{
								//PrintToChatAll("Grenade Slot 2 is empty");
								if(StrContains(g_strCoachGrenadeSlot3, "vomitjar", false) != -1)
								{
									RemoveEdict(ActiveGrenadeID);
									g_iCoachCurrentGrenadeSlot[iClient] = 2;
									SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
									FakeClientCommand(iClient, "give vomitjar");
								}
								else if(StrContains(g_strCoachGrenadeSlot3, "molotov", false) != -1)
								{
									RemoveEdict(ActiveGrenadeID);
									g_iCoachCurrentGrenadeSlot[iClient] = 2;
									SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
									FakeClientCommand(iClient, "give molotov");
								}
								else if(StrContains(g_strCoachGrenadeSlot3, "pipe_bomb", false) != -1)
								{
									RemoveEdict(ActiveGrenadeID);
									g_iCoachCurrentGrenadeSlot[iClient] = 2;
									SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
									FakeClientCommand(iClient, "give pipe_bomb");
								}
							}
						}
						else if(g_iCoachCurrentGrenadeSlot[iClient] == 1)
						{
							if(StrContains(g_strCoachGrenadeSlot3, "vomitjar", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 2;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give vomitjar");
							}
							else if(StrContains(g_strCoachGrenadeSlot3, "molotov", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 2;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give molotov");
							}
							else if(StrContains(g_strCoachGrenadeSlot3, "pipe_bomb", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 2;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give pipe_bomb");
							}
							else if(StrContains(g_strCoachGrenadeSlot3, "empty", false) != -1)
							{
								//PrintToChatAll("Grenade Slot 3 is empty");
								if(StrContains(g_strCoachGrenadeSlot1, "vomitjar", false) != -1)
								{
									RemoveEdict(ActiveGrenadeID);
									g_iCoachCurrentGrenadeSlot[iClient] = 0;
									SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
									FakeClientCommand(iClient, "give vomitjar");
								}
								else if(StrContains(g_strCoachGrenadeSlot1, "molotov", false) != -1)
								{
									RemoveEdict(ActiveGrenadeID);
									g_iCoachCurrentGrenadeSlot[iClient] = 0;
									SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
									FakeClientCommand(iClient, "give molotov");
								}
								else if(StrContains(g_strCoachGrenadeSlot1, "pipe_bomb", false) != -1)
								{
									RemoveEdict(ActiveGrenadeID);
									g_iCoachCurrentGrenadeSlot[iClient] = 0;
									SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
									FakeClientCommand(iClient, "give pipe_bomb");
								}
							}
						}
						else if(g_iCoachCurrentGrenadeSlot[iClient] == 2)
						{
							if(StrContains(g_strCoachGrenadeSlot1, "vomitjar", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 0;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give vomitjar");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "molotov", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 0;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give molotov");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "pipe_bomb", false) != -1)
							{
								RemoveEdict(ActiveGrenadeID);
								g_iCoachCurrentGrenadeSlot[iClient] = 0;
								SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
								FakeClientCommand(iClient, "give pipe_bomb");
							}
							else if(StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1)
							{
								//PrintToChatAll("Grenade Slot 1 is empty");
								if(StrContains(g_strCoachGrenadeSlot2, "vomitjar", false) != -1)
								{
									RemoveEdict(ActiveGrenadeID);
									g_iCoachCurrentGrenadeSlot[iClient] = 1;
									SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
									FakeClientCommand(iClient, "give vomitjar");
								}
								else if(StrContains(g_strCoachGrenadeSlot2, "molotov", false) != -1)
								{
									RemoveEdict(ActiveGrenadeID);
									g_iCoachCurrentGrenadeSlot[iClient] = 1;
									SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
									FakeClientCommand(iClient, "give molotov");
								}
								else if(StrContains(g_strCoachGrenadeSlot2, "pipe_bomb", false) != -1)
								{
									RemoveEdict(ActiveGrenadeID);
									g_iCoachCurrentGrenadeSlot[iClient] = 1;
									SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
									FakeClientCommand(iClient, "give pipe_bomb");
								}
							}
						}
					}
				}
			}
		}
	}
	if(g_iWreckingLevel[iClient] > 0 && g_bIsFlyingWithJetpack[iClient] == false && g_bIsClientDown[iClient] == false && IsClientGrappled(iClient) == false)		//Wrecking ball charge up
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(g_iWreckingLevel[iClient] == 5)
		{
			if(g_bCoachRageIsInCooldown[iClient] == false)
			{
				if(buttons & IN_DUCK)
				{
					g_iCoachHealthRechargeCounter[iClient]++;
					
					if(g_bShowingChargeHealParticle[iClient] == false)
					{
						g_iPID_CoachMeleeChargeHeal[iClient] = WriteParticle(iClient,"coach_melee_charge_heal",0.0);
						g_bShowingChargeHealParticle[iClient] = true;
					}
					
					if(g_iCoachHealthRechargeCounter[iClient]>23)
					{
						g_iCoachHealthRechargeCounter[iClient] = 0;
						new currentHP=GetEntProp(iClient,Prop_Data,"m_iHealth");
						new maxHP = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
						if(currentHP < (maxHP - 1))
							SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + 1);
						else if(currentHP >= (maxHP - 1))
							SetEntProp(iClient,Prop_Data,"m_iHealth", maxHP);
					}
				}
				else
				{
					g_iCoachHealthRechargeCounter[iClient] = 0;
					DeleteParticleEntity(g_iPID_CoachMeleeChargeHeal[iClient]);
					g_bShowingChargeHealParticle[iClient] = false;
				}
			}
		}
		if(g_bIsWreckingBallCharged[iClient]==false)
		{
			if(buttons & IN_DUCK)
			{
				g_iWreckingBallChargeCounter[iClient]++;
				if(g_iWreckingBallChargeCounter[iClient]==20)
				{
					PrintHintText(iClient, "Charging Melee Attack");
					//play sound and particle for charging here
				}
				if(g_iWreckingBallChargeCounter[iClient]>90)
				{
					g_iWreckingBallChargeCounter[iClient] = 0;
					g_bIsWreckingBallCharged[iClient] = true;
					new Float:vec[3];
					GetClientAbsOrigin(iClient, vec);
					new rand = GetRandomInt(1, 3);
					switch(rand)
					{
						case 1: EmitSoundToAll(SOUND_COACH_CHARGE1, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
						case 2: EmitSoundToAll(SOUND_COACH_CHARGE2, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
						case 3: EmitSoundToAll(SOUND_COACH_CHARGE3, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
					}
					
					g_iPID_CoachMeleeCharge1[iClient] = CreateParticle("coach_melee_charge_wepbone", 0.0, iClient, ATTACH_WEAPON_BONE);
					g_iPID_CoachMeleeCharge2[iClient] = CreateParticle("coach_melee_charge_muzbone", 0.0, iClient, ATTACH_MUZZLE_FLASH);
					//WriteParticle(iClient, "coach_melee_charge_arms", 0.0, 3.0);
					PrintHintText(iClient, "Melee Attack Charged!");
					//play sound and particle for charged here
				}
			}
			else
			{
				if(g_iWreckingBallChargeCounter[iClient] > 0)
				{
					PrintHintText(iClient, "Melee attack was not charged long enough");
					g_iWreckingBallChargeCounter[iClient] = 0;
				}
			}
		}
	}
	if(g_iBullLevel[iClient] > 0)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(!(buttons & IN_SPEED) || !(buttons & IN_USE))
			g_bWalkAndUseToggler[iClient] = false;
		if((g_bWalkAndUseToggler[iClient] == false) && ((buttons & IN_SPEED) && (buttons & IN_USE)))
		{
			g_bWalkAndUseToggler[iClient] = true;
			if(g_bCoachRageIsAvailable[iClient] == true)
			{
				//g_fCoachRageSpeed[iClient] = (g_iBullLevel[iClient] * 0.04);
				//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + g_fCoachCIHeadshotSpeed[iClient] + g_fCoachSIHeadshotSpeed[iClient] + g_fCoachRageSpeed[iClient]), true);
				g_fClientSpeedBoost[iClient] += (g_iBullLevel[iClient] * 0.04);
				fnc_SetClientSpeed(iClient);
				g_iCoachRageMeleeDamage[iClient] = (g_iBullLevel[iClient] * 20);
				CreateTimer(20.0, TimerCoachRageReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
				if(g_iCoachRageRegenCounter[iClient] < 2)
				{
					new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
					new maxHP = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
					if(currentHP < (maxHP - 5))
						SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + 5);
					else if(currentHP >= (maxHP - 5))
						SetEntProp(iClient,Prop_Data,"m_iHealth", maxHP);
				}
				else if(g_iCoachRageRegenCounter[iClient] < 5)
				{
					new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
					new maxHP = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
					if(currentHP < (maxHP - 4))
						SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + 4);
					else if(currentHP >= (maxHP - 4))
						SetEntProp(iClient,Prop_Data,"m_iHealth", maxHP);
				}
				else if(g_iCoachRageRegenCounter[iClient] < 9)
				{
					new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
					new maxHP = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
					if(currentHP < (maxHP - 3))
						SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + 3);
					else if(currentHP >= (maxHP - 3))
						SetEntProp(iClient,Prop_Data,"m_iHealth", maxHP);
				}
				else if(g_iCoachRageRegenCounter[iClient] < 14)
				{
					new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
					new maxHP = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
					if(currentHP < (maxHP - 2))
						SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + 2);
					else if(currentHP >= (maxHP - 2))
						SetEntProp(iClient,Prop_Data,"m_iHealth", maxHP);
				}
				else
				{
					new currentHP = GetEntProp(iClient,Prop_Data,"m_iHealth");
					new maxHP = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
					if(currentHP < (maxHP - 1))
						SetEntProp(iClient,Prop_Data,"m_iHealth", currentHP + 1);
					else if(currentHP >= (maxHP - 1))
						SetEntProp(iClient,Prop_Data,"m_iHealth", maxHP);
				}
				g_iCoachRageRegenCounter[iClient]++;
				CreateTimer(1.0, TimerCoachRageRegenTick, iClient, TIMER_FLAG_NO_MAPCHANGE);
				g_bCoachRageIsAvailable[iClient] = false;
				g_bCoachRageIsActive[iClient] = true;
				PrintHintText(iClient, "You are now RAGING!");
			}
			else if(g_bCoachRageIsInCooldown[iClient] == true)
				PrintHintText(iClient, "Rage is still cooling down");
		}
	}
	if(g_iSprayLevel[iClient] > 0)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if((buttons & IN_RELOAD) && g_bCoachShotgunForceReload[iClient] == false && g_bClientIsReloading[iClient] == false)
		{
			decl String:currentweapon[32];
			GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
			new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
			new CurrentClipAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
			if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true)) && (CurrentClipAmmo > 7) && (CurrentClipAmmo <= (7 + (g_iSprayLevel[iClient] * 2))))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
				if(iAmmo > 0)
				{
					g_bCoachShotgunForceReload[iClient] = true;
					g_iCoachShotgunSavedAmmo[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_ClipShotgun, 0, true);
				}
			}
			if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (CurrentClipAmmo > 9) && (CurrentClipAmmo <= (9 + (g_iSprayLevel[iClient] * 2))))
			{
				new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
				new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
				if(iAmmo > 0)
				{
					g_bCoachShotgunForceReload[iClient] = true;
					g_iCoachShotgunSavedAmmo[iClient] = CurrentClipAmmo;
					SetEntData(ActiveWeaponID, g_iOffset_ClipShotgun, 0, true);
				}
			}
		}
	}
}

OGFSurvivorReload_Coach(iClient, const char[] currentweapon, ActiveWeaponID, CurrentClipAmmo, iOffset_Ammo)
{
	if(((StrEqual(currentweapon, "weapon_pumpshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_chrome", false) == true)) && (g_iSprayLevel[iClient] > 0))
	{
		/*
		if(g_bCoachShotgunForceReload[iClient] == true)
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, g_iCoachShotgunSavedAmmo[iClient], true);
			//PrintToChatAll("g_iOffset_Clip1 %d", g_iOffset_Clip1);
			//PrintToChatAll("g_iCoachShotgunSavedAmmo %d", g_iCoachShotgunSavedAmmo[iClient]);
			g_bCoachShotgunForceReload[iClient] = false;
		}
		*/
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);
		if(g_iReloadFrameCounter[iClient] == 1)
		{
			if(iAmmo >= ((8 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, ((g_iSprayLevel[iClient] * 2) + 8) - CurrentClipAmmo, true);
				//PrintToChatAll("g_iOffset_ReloadNumShells");
			}
			else if(iAmmo < ((8 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, iAmmo, true);
			}
		}
		if((CurrentClipAmmo == (8 + (g_iSprayLevel[iClient] * 2))) || (CurrentClipAmmo == (CurrentClipAmmo + iAmmo)))
		{
			g_bCoachShotgunForceReload[iClient] = false;
			g_bClientIsReloading[iClient] = false;
			g_iReloadFrameCounter[iClient] = 0;
			SetEntData(ActiveWeaponID, g_bOffset_InReload, 0, true);
			SetEntData(iClient, g_bOffset_InReload, 0, true);
		}
		//SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, 18, true);
		//SetEntData(ActiveWeaponID, g_iOffset_ShellsInserted, 1, true);
		//g_iOffset_ShellsInserted
		//new iAmmo = GetEntData(iClient, iOffset_Ammo + 28);	//for pump shotguns (+28)
		/*
		if(g_iReloadFrameCounter[iClient] == 1)
		{
			new IncreasedClipAmmo = CurrentClipAmmo + 1;
		}
		*/
		
		// PrintToChatAll("Coach and shotgun detected");
		// if((CurrentClipAmmo == g_iCoachShotgunIncreasedAmmo[iClient]) && (g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) < (8 + g_iSprayLevel[iClient]))
		// {
		// 	g_iCoachShotgunAmmoCounter[iClient]++;
		// 	g_iCoachShotgunIncreasedAmmo[iClient] = CurrentClipAmmo + 1;
		// 	PrintToChatAll("Ammo Counter Increased = %d", g_iCoachShotgunAmmoCounter[iClient]);
		// }
		// else if((g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) == (8 + g_iSprayLevel[iClient]))
		// {
		// 	SetEntData(ActiveWeaponID, g_iOffset_Clip1, (g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]), true);
		// 	PrintToChatAll("Clip is full, setting clip size");
		// 	g_bClientIsReloading[iClient] = false;
		// 	g_iReloadFrameCounter[iClient] = 0;
		// }
		// if(CurrentClipAmmo <= 7 && ((g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) < (8 + g_iSprayLevel[iClient])))
		// {
		// 	SetEntData(ActiveWeaponID, g_iOffset_Clip1, 1, true);
		// 	//PrintToChatAll("Clip = 9 and Bullets < 18, CurrentClipAmmo = %d", CurrentClipAmmo);
		// 	g_iCoachShotgunIncreasedAmmo[iClient] = CurrentClipAmmo + 1;
		// 	//PrintToChatAll("Clip = 9 and Bullets < 18, IncreasedAmmo = %d", g_iCoachShotgunIncreasedAmmo[iClient]);
		// }
		
		/*
		else if((g_iCoachShotgunSavedAmmo[iClient] + g_iCoachShotgunAmmoCounter[iClient]) == (8 + g_iSprayLevel[iClient]))
		{
			
		}
		
		new IncreasedClipAmmo = CurrentClipAmmo + 1;
		if(CurrentClipAmmo < (8 + (g_iSprayLevel[iClient] * 2)))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
			SetEntData(iClient, iOffset_Ammo + 28, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
		}
		else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
		{
			new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
			SetEntData(iClient, iOffset_Ammo + 28, 0);
		}
		*/
		
	}
	else if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (g_iSprayLevel[iClient] > 0))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);
		if(g_iReloadFrameCounter[iClient] == 1)
		{
			if(iAmmo >= ((10 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, ((g_iSprayLevel[iClient] * 2) + 10) - CurrentClipAmmo, true);
				//PrintToChatAll("g_iOffset_ReloadNumShells");
			}
			else if(iAmmo < ((10 + (g_iSprayLevel[iClient] * 2)) - CurrentClipAmmo))
			{
				SetEntData(ActiveWeaponID, g_iOffset_ReloadNumShells, iAmmo, true);
			}
		}
		if((CurrentClipAmmo == (10 + (g_iSprayLevel[iClient] * 2))) || (CurrentClipAmmo == (CurrentClipAmmo + iAmmo)))
		{
			
			// new InReload = GetEntData(iClient, g_bOffset_InReload + 32);
			// new InReloadWep = GetEntData(ActiveWeaponID, g_bOffset_InReload + 32);
			// PrintToChatAll("InReload %d", InReload);
			// PrintToChatAll("InReloadWep %d", InReloadWep);
			
			g_bCoachShotgunForceReload[iClient] = false;
			g_bClientIsReloading[iClient] = false;
			g_iReloadFrameCounter[iClient] = 0;
			SetEntData(ActiveWeaponID, g_bOffset_InReload, 0, true);
			SetEntData(iClient, g_bOffset_InReload, 0, true);
		}
	}
	/*
	if(((StrEqual(currentweapon, "weapon_autoshotgun", false) == true) || (StrEqual(currentweapon, "weapon_shotgun_spas", false) == true)) && (CurrentClipAmmo == 10))
	{
		new iAmmo = GetEntData(iClient, iOffset_Ammo + 32);	//for auto shotguns (+32)
		if(iAmmo >= (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6))
		{
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + (g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6)), true);
			SetEntData(iClient, iOffset_Ammo + 32, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));
		}
		else if(iAmmo < (g_iPromotionalLevel[iClient]*20))
		{
			new NewAmmo = ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - iAmmo);
			SetEntData(ActiveWeaponID, g_iOffset_Clip1, (CurrentClipAmmo + ((g_iMetalLevel[iClient]*4) + (g_iFireLevel[iClient]*6) - NewAmmo)), true);
			SetEntData(iClient, iOffset_Ammo + 32, 0);
		}
		g_bClientIsReloading[iClient] = false;
		g_iReloadFrameCounter[iClient] = 0;
	}
	*/
}

//Coach's Jetpack stuff
public Action:StartFlying(iClient)
{
	if(g_bIsFlyingWithJetpack[iClient]==false)
	{
		SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
		g_bIsMovementTypeFly[iClient] = true;
		StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
		new Float:vec[3];
		GetClientAbsOrigin(iClient, vec);
		EmitSoundToAll(SOUND_JPHIGHREV, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
		g_iPID_CoachJetpackStream[iClient] = WriteParticle(iClient, "jetpack_stream", 0.0);
		//g_iPID_CoachJetpackStream[iClient] = CreateParticle("jetpack_stream", 0.0, iClient, ATTACH_SURVIVOR_LIGHT);
	}
	g_iClientJetpackFuel = g_iClientJetpackFuelUsed[iClient]--;
	PrintHintText(iClient, "%d Fuel Left", g_iClientJetpackFuel);
	AddVelocity(iClient, 50.0);
	g_bIsFlyingWithJetpack[iClient]=true;
	if(g_iClientJetpackFuelUsed[iClient]<0)
	{
		CreateTimer(0.5, DeleteParticle, g_iPID_CoachJetpackStream[iClient], TIMER_FLAG_NO_MAPCHANGE);
		StopSound(iClient, SNDCHAN_AUTO, SOUND_JPHIGHREV);
		StopSound(iClient, SNDCHAN_AUTO, SOUND_JPIDLEREV);
		new Float:vec[3];
		GetClientAbsOrigin(iClient, vec);
		EmitSoundToAll(SOUND_JPDIE, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
		g_bIsJetpackOn[iClient] = false;
		SetMoveType(iClient, MOVETYPE_WALK, MOVECOLLIDE_DEFAULT);
		PrintHintText(iClient, "Out Of Fuel");
	}
	return Plugin_Continue;
}

public Action:StopFlying(iClient)
{
	g_bIsFlyingWithJetpack[iClient]=false;
	CreateTimer(0.5, DeleteParticle, g_iPID_CoachJetpackStream[iClient], TIMER_FLAG_NO_MAPCHANGE);
	StopSound(iClient, SNDCHAN_AUTO, SOUND_JPHIGHREV);
	new Float:vec[3];
	GetClientAbsOrigin(iClient, vec);
	EmitSoundToAll(SOUND_JPIDLEREV, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
	return Plugin_Continue;
}

AddVelocity(iClient, Float:speed)
{
	new Float:vecVelocity[3];
	GetEntDataVector(iClient, g_iOffset_VecVelocity, vecVelocity);

	if ((vecVelocity[2]+speed) > 250.0)
		vecVelocity[2] = 250.0;
	else
		vecVelocity[2] += speed;

	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vecVelocity);
}