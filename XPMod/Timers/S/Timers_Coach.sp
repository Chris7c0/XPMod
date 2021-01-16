public Action:TimerStartJetPack(Handle:timer, any:iClient)
{
	if(RunClientChecks(iClient)==false || IsPlayerAlive(iClient)==false)
		return Plugin_Stop;

	new Float:vec[3];
	GetClientAbsOrigin(iClient, vec);
	EmitSoundToAll(SOUND_JPIDLEREV, iClient, SNDCHAN_AUTO,	SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
	g_bIsJetpackOn[iClient] = true;
	return Plugin_Stop;
}

public Action:TimerGiveFirstExplosive(Handle:timer, any:iClient)
{
	if(RunClientChecks(iClient)==false || IsPlayerAlive(iClient)==false)
		return Plugin_Stop;
	
	if(GetPlayerWeaponSlot(iClient, 2) == -1)
	{
		if(g_iStrongLevel[iClient]==1 || g_iStrongLevel[iClient]==2)
		{
			CreateTimer(3.0, TimerGiveExplosive, iClient, TIMER_FLAG_NO_MAPCHANGE);
			g_iExtraExplosiveUses[iClient] = 2;
		}
		else if(g_iStrongLevel[iClient]==3 || g_iStrongLevel[iClient]==4)
		{
			CreateTimer(3.0, TimerGiveExplosive, iClient, TIMER_FLAG_NO_MAPCHANGE);
			g_iExtraExplosiveUses[iClient] = 1;
		}
		else
		{
			CreateTimer(3.0, TimerGiveExplosive, iClient, TIMER_FLAG_NO_MAPCHANGE);
			g_iExtraExplosiveUses[iClient] = 0;
		}
	}
	return Plugin_Stop;
}

public Action:TimerGiveExplosive(Handle:timer, any:iClient)
{
	if(RunClientChecks(iClient) == false || IsPlayerAlive(iClient) == false)
		return Plugin_Stop;
	
	g_iExtraExplosiveUses[iClient]++;
	new randnum = GetRandomInt(0, 2);
	SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
	switch(randnum)
	{
		case 0:	FakeClientCommand(iClient, "give pipe_bomb");
		case 1:	FakeClientCommand(iClient, "give molotov");
		case 2:	FakeClientCommand(iClient, "give vomitjar");
	}
	SetCommandFlags("give", g_iFlag_Give);
	
	g_bExplosivesJustGiven[iClient] = false;
	//CreateTimer(0.1, TimerGiveExplosive, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action:Timer_ResetExplosiveJustGiven(Handle:timer, any:iClient)
{
	g_bExplosivesJustGiven[iClient] = true;
	return Plugin_Stop;
}

public Action:TimerCoachCIHeadshotSpeedReset(Handle:timer, any:iClient)
{
	//g_fCoachCIHeadshotSpeed[iClient] = 0.0;
	//PrintToChatAll("g_fCoachCIHeadshotSpeed = %d", g_fCoachCIHeadshotSpeed[iClient]);
	//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + g_fCoachCIHeadshotSpeed[iClient] + g_fCoachSIHeadshotSpeed[iClient] + g_fCoachRageSpeed[iClient]), true);
	g_iCoachCIHeadshotCounter[iClient]--;
	if(g_iCoachCIHeadshotCounter[iClient] > 0)
	{
		CreateTimer(3.0, TimerCoachCIHeadshotSpeedReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{
		g_fClientSpeedBoost[iClient] -= (g_iBullLevel[iClient] * 0.05);
		fnc_SetClientSpeed(iClient);
		g_bCoachInCISpeed[iClient] = false;
	}
	return Plugin_Stop;
}

public Action:TimerCoachSIHeadshotSpeedReset(Handle:timer, any:iClient)
{
	//g_fCoachSIHeadshotSpeed[iClient] = 0.0;
	//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + g_fCoachCIHeadshotSpeed[iClient] + g_fCoachSIHeadshotSpeed[iClient] + g_fCoachRageSpeed[iClient]), true);
	//g_fClientSpeedBoost[iClient] -= (g_iHomerunLevel[iClient] * 0.05);
	//fnc_SetClientSpeed(iClient);
	g_iCoachSIHeadshotCounter[iClient]--;
	if(g_iCoachSIHeadshotCounter[iClient] > 0)
	{
		CreateTimer(6.0, TimerCoachSIHeadshotSpeedReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{
		g_fClientSpeedBoost[iClient] -= (g_iHomerunLevel[iClient] * 0.05);
		fnc_SetClientSpeed(iClient);
		g_bCoachInSISpeed[iClient] = false;
	}
	return Plugin_Stop;
}

public Action:TimerCoachRageReset(Handle:timer, any:iClient)
{
	//g_fCoachRageSpeed[iClient] = -0.1;
	g_iCoachRageMeleeDamage[iClient] = 0;
	//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + g_fCoachCIHeadshotSpeed[iClient] + g_fCoachSIHeadshotSpeed[iClient] + g_fCoachRageSpeed[iClient]), true);
	g_fClientSpeedBoost[iClient] -= (g_iBullLevel[iClient] * 0.04);
	fnc_SetClientSpeed(iClient);
	CreateTimer(60.0, TimerCoachRageCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
	g_bCoachRageIsInCooldown[iClient] = true;
	PrintHintText(iClient, "Rage is in cooldown, healing and speed talents disabled for 60 seconds");
	return Plugin_Stop;
}

public Action:TimerCoachRageCooldown(Handle:timer, any:iClient)
{
	//g_fCoachRageSpeed[iClient] = 0.0;
	//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + g_fCoachCIHeadshotSpeed[iClient] + g_fCoachSIHeadshotSpeed[iClient] + g_fCoachRageSpeed[iClient]), true);
	g_bCoachRageIsAvailable[iClient] = true;
	g_bCoachRageIsInCooldown[iClient] = false;
	return Plugin_Stop;
}

public Action:TimerCoachRageRegenTick(Handle:timer, any:iClient)
{
	if(g_iCoachRageRegenCounter[iClient] == 20)
	{
		g_iCoachRageRegenCounter[iClient] = 0;
		return Plugin_Stop;
	}
	
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
	//PrintToChatAll("Rage Regen Counter = %d", g_iCoachRageRegenCounter[iClient]);
	CreateTimer(1.0, TimerCoachRageRegenTick, iClient, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

public Action:TimerWreckingChargeRetrigger(Handle:timer, any:iClient)
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
	PrintHintText(iClient, "Wrecking Ball has been recharged!");
	return Plugin_Stop;
}

public Action:TimerCoachAssignGrenades(Handle:timer, any:iClient)
{
	decl AssignGrenadeSlot1, AssignGrenadeSlot2, AssignGrenadeSlot3;
	AssignGrenadeSlot1 = GetRandomInt(0,2);
	AssignGrenadeSlot2 = GetRandomInt(0,2);
	AssignGrenadeSlot3 = GetRandomInt(0,2);
	if(!StrContains(g_strCoachGrenadeSlot1, "vomitjar", false) && !StrContains(g_strCoachGrenadeSlot1, "molotov", false) && !StrContains(g_strCoachGrenadeSlot1, "pipe_bomb", false))
	{
		//PrintToChatAll("Slot 1 did not contain a grenade");
		switch (AssignGrenadeSlot1)
		{
			case 0:
			{
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give vomitjar");
				g_strCoachGrenadeSlot1 = "weapon_vomitjar";
				//PrintToChatAll("Slot 1 Assigned = %s", g_strCoachGrenadeSlot1);
			}
			case 1:
			{
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give molotov");
				g_strCoachGrenadeSlot1 = "weapon_molotov";
				//PrintToChatAll("Slot 1 Assigned = %s", g_strCoachGrenadeSlot1);
			}
			case 2:
			{
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give pipe_bomb");
				g_strCoachGrenadeSlot1 = "weapon_pipe_bomb";
				//PrintToChatAll("Slot 1 Assigned = %s", g_strCoachGrenadeSlot1);
			}
		}
	}
	if(g_iStrongLevel[iClient] == 2 || g_iStrongLevel[iClient] == 3)
	{
		//PrintToChatAll("Slot 2 was assigned a grenade");
		switch (AssignGrenadeSlot2)
		{
			case 0:
			{
				g_strCoachGrenadeSlot2 = "weapon_vomitjar";
				//PrintToChatAll("Slot 2 Assigned = %s", g_strCoachGrenadeSlot2);
			}
			case 1:
			{
				g_strCoachGrenadeSlot2 = "weapon_molotov";
				//PrintToChatAll("Slot 2 Assigned = %s", g_strCoachGrenadeSlot2);
			}
			case 2:
			{
				g_strCoachGrenadeSlot2 = "weapon_pipe_bomb";
				//PrintToChatAll("Slot 2 Assigned = %s", g_strCoachGrenadeSlot2);
			}
		}
	}
	else if(g_iStrongLevel[iClient] == 4 || g_iStrongLevel[iClient] == 5)
	{
		//PrintToChatAll("Slot 2 was assigned a grenade");
		switch (AssignGrenadeSlot2)
		{
			case 0:
			{
				g_strCoachGrenadeSlot2 = "weapon_vomitjar";
				//PrintToChatAll("Slot 2 Assigned = %s", g_strCoachGrenadeSlot2);
			}
			case 1:
			{
				g_strCoachGrenadeSlot2 = "weapon_molotov";
				//PrintToChatAll("Slot 2 Assigned = %s", g_strCoachGrenadeSlot2);
			}
			case 2:
			{
				g_strCoachGrenadeSlot2 = "weapon_pipe_bomb";
				//PrintToChatAll("Slot 2 Assigned = %s", g_strCoachGrenadeSlot2);
			}
		}
		//PrintToChatAll("Slot 3 was assigned a grenade");
		switch (AssignGrenadeSlot3)
		{
			case 0:
			{
				g_strCoachGrenadeSlot3 = "weapon_vomitjar";
				//PrintToChatAll("Slot 3 Assigned = %s", g_strCoachGrenadeSlot3);
			}
			case 1:
			{
				g_strCoachGrenadeSlot3 = "weapon_molotov";
				//PrintToChatAll("Slot 3 Assigned = %s", g_strCoachGrenadeSlot3);
			}
			case 2:
			{
				g_strCoachGrenadeSlot3 = "weapon_pipe_bomb";
				//PrintToChatAll("Slot 3 Assigned = %s", g_strCoachGrenadeSlot3);
			}
		}
	}
	return Plugin_Stop;
}

public Action:TimerCanCoachGrenadeCycleReset(Handle:timer, any:iClient)
{
	g_bCanCoachGrenadeCycle[iClient] = true;
	return Plugin_Stop;
}

public Action:TimerCoachGrenadeFireCycle(Handle:timer, any:iClient)
{
	if(g_iStrongLevel[iClient] == 2 || g_iStrongLevel[iClient] == 3)
	{
		if(g_iCoachCurrentGrenadeSlot[iClient] == 0)
		{
			if(StrContains(g_strCoachGrenadeSlot2, "vomitjar", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 1;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give vomitjar");
			}
			else if(StrContains(g_strCoachGrenadeSlot2, "molotov", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 1;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give molotov");
			}
			else if(StrContains(g_strCoachGrenadeSlot2, "pipe_bomb", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 1;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give pipe_bomb");
			}
		}
		else if(g_iCoachCurrentGrenadeSlot[iClient] == 1)
		{
			if(StrContains(g_strCoachGrenadeSlot1, "vomitjar", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 0;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give vomitjar");
			}
			else if(StrContains(g_strCoachGrenadeSlot1, "molotov", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 0;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give molotov");
			}
			else if(StrContains(g_strCoachGrenadeSlot1, "pipe_bomb", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 0;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give pipe_bomb");
			}
		}
	}
	else if(g_iStrongLevel[iClient] == 4 || g_iStrongLevel[iClient] == 5)
	{
		if(g_iCoachCurrentGrenadeSlot[iClient] == 0)
		{
			if(StrContains(g_strCoachGrenadeSlot2, "vomitjar", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 1;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give vomitjar");
			}
			else if(StrContains(g_strCoachGrenadeSlot2, "molotov", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 1;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give molotov");
			}
			else if(StrContains(g_strCoachGrenadeSlot2, "pipe_bomb", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 1;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give pipe_bomb");
			}
			else if(StrContains(g_strCoachGrenadeSlot2, "empty", false) != -1)
			{
				if(StrContains(g_strCoachGrenadeSlot3, "vomitjar", false) != -1)
				{
					g_iCoachCurrentGrenadeSlot[iClient] = 2;
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give vomitjar");
				}
				else if(StrContains(g_strCoachGrenadeSlot3, "molotov", false) != -1)
				{
					g_iCoachCurrentGrenadeSlot[iClient] = 2;
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give molotov");
				}
				else if(StrContains(g_strCoachGrenadeSlot3, "pipe_bomb", false) != -1)
				{
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
				g_iCoachCurrentGrenadeSlot[iClient] = 2;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give vomitjar");
			}
			else if(StrContains(g_strCoachGrenadeSlot3, "molotov", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 2;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give molotov");
			}
			else if(StrContains(g_strCoachGrenadeSlot3, "pipe_bomb", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 2;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give pipe_bomb");
			}
			else if(StrContains(g_strCoachGrenadeSlot3, "empty", false) != -1)
			{
				if(StrContains(g_strCoachGrenadeSlot1, "vomitjar", false) != -1)
				{
					g_iCoachCurrentGrenadeSlot[iClient] = 0;
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give vomitjar");
				}
				else if(StrContains(g_strCoachGrenadeSlot1, "molotov", false) != -1)
				{
					g_iCoachCurrentGrenadeSlot[iClient] = 0;
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give molotov");
				}
				else if(StrContains(g_strCoachGrenadeSlot1, "pipe_bomb", false) != -1)
				{
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
				g_iCoachCurrentGrenadeSlot[iClient] = 0;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give vomitjar");
			}
			else if(StrContains(g_strCoachGrenadeSlot1, "molotov", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 0;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give molotov");
			}
			else if(StrContains(g_strCoachGrenadeSlot1, "pipe_bomb", false) != -1)
			{
				g_iCoachCurrentGrenadeSlot[iClient] = 0;
				SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
				FakeClientCommand(iClient, "give pipe_bomb");
			}
			else if(StrContains(g_strCoachGrenadeSlot1, "empty", false) != -1)
			{
				if(StrContains(g_strCoachGrenadeSlot2, "vomitjar", false) != -1)
				{
					g_iCoachCurrentGrenadeSlot[iClient] = 1;
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give vomitjar");
				}
				else if(StrContains(g_strCoachGrenadeSlot2, "molotov", false) != -1)
				{
					g_iCoachCurrentGrenadeSlot[iClient] = 1;
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give molotov");
				}
				else if(StrContains(g_strCoachGrenadeSlot2, "pipe_bomb", false) != -1)
				{
					g_iCoachCurrentGrenadeSlot[iClient] = 1;
					SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
					FakeClientCommand(iClient, "give pipe_bomb");
				}
			}
		}
	}
	g_bIsCoachGrenadeFireCycling[iClient] = false;
	g_iEventWeaponFireCounter[iClient] = 0;
	return Plugin_Stop;
}
