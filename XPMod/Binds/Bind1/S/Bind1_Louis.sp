void Bind1Press_Louis(iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	if (g_iClientBindUses_1[iClient] >= 1)
	{
		PrintHintText(iClient, "You are out of Warez Stations.");
		return;
	}

	if (g_bWareStationActive[iClient])
	{
		PrintHintText(iClient, "You can only deploy one Warez Station at a time.");
		return;
	}
	
	CreateWarezStation(iClient);
}

void CreateWarezStation(iClient)
{
	// Reset values for warez station
	g_bWareStationActive[iClient] = true;
	for(new i=1;i <= MaxClients;i++)
		g_bWareStationClientAlreadyServiced[iClient][i] = false;

	decl Float:vAngles[3];
	GetLocationVectorInfrontOfClient(iClient, g_xyzWarezStationLocation[iClient], vAngles, 60.0);

	// Create the in game visuals
	CreateSphere(g_xyzWarezStationLocation[iClient], 50.0, 30, 0.1, {0, 255, 50, 255}, 25.0);
	// Fix this later to be on next game frame
	CreateTimer(0.1, TimerCreateInnerSphere, iClient);
	DrawRing(g_xyzWarezStationLocation[iClient]);
	// Create light
	char color[12];
	Format( color, sizeof( color ), "%i %i %i", 0, 255, 50 );
	int iLight = MakeLightDynamic(iClient);
	SetVariantEntity(iLight);
	SetVariantString(color);
	AcceptEntityInput(iLight, "color");
	AcceptEntityInput(iLight, "TurnOn");
	CreateTimer(25.0, TimerRemoveLightDynamicEntity, iLight, TIMER_FLAG_NO_MAPCHANGE);

	// Check if clients are close to the warez station
	CreateTimer(0.3, TimerWarezStationCheckForSurvivorToService, iClient, TIMER_REPEAT);

	// Disable Warez Station after its duration
	CreateTimer(25.0, TimerWarezStationDisable, iClient, TIMER_FLAG_NO_MAPCHANGE);

	g_iClientBindUses_1[iClient]++;
}

Action:TimerWarezStationCheckForSurvivorToService(Handle:timer, any:iClient)
{
	if (g_bWareStationActive[iClient] == false)
		return Plugin_Stop;
	
	for(new iCandidate=1;iCandidate <= MaxClients;iCandidate++)
	{
		if (RunClientChecks(iCandidate) && 
			IsFakeClient(iCandidate) == false && 
			g_iClientTeam[iCandidate] == TEAM_SURVIVORS)
		{
			// Valid candidate, now check the distance to the warez station
			decl Float:xyzCandidateLocation[3];
			GetClientAbsOrigin(iCandidate, xyzCandidateLocation);
			//PrintToChatAll("%f distance", GetVectorDistance(g_xyzWarezStationLocation[iClient], xyzCandidateLocation, false));
			if (GetVectorDistance(g_xyzWarezStationLocation[iClient], xyzCandidateLocation, false) > 45.0)
				continue;

			// The candidate has entered the warez station radius, check if they already used it.
			if (g_bWareStationClientAlreadyServiced[iClient][iCandidate] == false)
			{
				WarezStationMenuDraw(iClient);
				g_iWareStationOwnerIDOfCurrentlyViewedStation[iCandidate] = iClient;
			}
			else
			{
				// They already used this station, so print hint text that they cant use again.
				PrintHintText(iCandidate, "You have already used this Warez Station.");
			}
		}
	}

	return Plugin_Continue;
}

Action:TimerWarezStationDisable(Handle:timer, any:iClient)
{
	g_bWareStationActive[iClient] = false;
	g_xyzWarezStationLocation[iClient] = NULL_VECTOR;
	
	return Plugin_Stop;
}

// Warez Station Menu Draw
Action:WarezStationMenuDraw(iClient) 
{
	decl String:text[512];
	
	Menu menu = CreateMenu(WarezStationMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	FormatEx(text, sizeof(text), "\
		\n \
		\n	   cH0o53 joOr w4R3z\
		\n =========================\
		\n ",
		g_iLouisTalent6Level[iClient]);
	SetMenuTitle(menu, text);

	AddMenuItem(menu, "option1", "+2% Speed Increase");
	AddMenuItem(menu, "option2", "+10% Max Health");
	AddMenuItem(menu, "option3", "-33% Team Screen Shake");
	AddMenuItem(menu, "option4", "+1 Self revive");
	AddMenuItem(menu, "option5", "Receive Medkit + Pills");
	AddMenuItem(menu, "option6", "Receive Full Ammo");
	AddMenuItem(menu, "option7", "I'm Feeling Lucky\n ");

	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "", ITEMDRAW_NOTEXT);

	AddMenuItem(menu, "option10", "Nothing For Now.\
	\n =========================\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

// Warez Station Menu Handler
WarezStationMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{	
	if(action == MenuAction_Select)
	{
		if (RunClientChecks(iClient) == false || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS || 
		IsFakeClient(iClient))
		{
			return;
		}

		if (g_bIsClientGrappled[iClient] || GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1)
		{
			PrintHintText(iClient, "You cannot recieve Warez while Grappled or Incapacitated.")
			WarezStationMenuDraw(iClient);
			return;
		}

		switch (itemNum)
		{
			case 0: // Speed
			{
				g_fWarezStationSpeedBoost[iClient] += 0.02;
				SetClientSpeed(iClient);
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Speed Increase", iClient);
			}
			case 1: // Max Health
			{
				new iMaxHealth = GetEntProp(iClient, Prop_Data, "m_iMaxHealth");
				new iCurrentHealth = GetEntProp(iClient, Prop_Data, "m_iHealth");
				SetEntProp(iClient, Prop_Data, "m_iMaxHealth", iMaxHealth + 10);
				SetEntProp(iClient, Prop_Data, "m_iHealth", iCurrentHealth + 10);
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Max Health Boost", iClient);
			}
			case 2: // Team Screen Shake
			{
				g_iScreenShakeAmount -= 7;
				SetSurvivorScreenShakeAmount();

				// Print Message to Survivors
				for(new iSurvivor=1;iSurvivor <= MaxClients;iSurvivor++)
					if (RunClientChecks(iSurvivor) && 
						IsFakeClient(iSurvivor) == false && 
						g_iClientTeam[iSurvivor] == TEAM_SURVIVORS)
							PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Screen Shake Reduced", iClient);
			}
			case 3: // Self revive
			{
				g_iSelfRevives[iClient]++;
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Self Revive", iClient);
			}
			case 4:	// Med supplies
			{
				RunCheatCommand(iClient, "give", "give first_aid_kit");
				RunCheatCommand(iClient, "give", "give pain_pills");
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Medical Supplies", iClient);
			}
			case 5:	// Ammo
			{
				RunCheatCommand(iClient, "give", "give ammo");
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Full Ammo", iClient);
			}
			case 6:	// I'm Feeling Lucky
			{
				ImFeelingLuckyRoll(iClient);
			}
		}

		if (itemNum >= 0  && itemNum <= 6)
		{
			// Set that the iOwners Warez Station Serviced array to true for this iClient.
			new iOwner = g_iWareStationOwnerIDOfCurrentlyViewedStation[iClient];
			if (iOwner > 0)
				g_bWareStationClientAlreadyServiced[iOwner][iClient] = true;
			// Reset iClient's Warez Station Owner, they arent using a Warez Station any more.
			g_iWareStationOwnerIDOfCurrentlyViewedStation[iClient] = -1;
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

ImFeelingLuckyRoll(iClient)
{
	new iRoll = GetRandomInt(0, 9)

	switch (iRoll)
	{
		case 0: 	// Nothing
		{
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Absolutely Nothing", iClient);
		}
		case 1: 	// Extra Bind 1
		{
			g_iClientBindUses_1[iClient]--;
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Extra Bind 1", iClient);
		}
		case 2:  	// Extra Bind 2
		{
			g_iClientBindUses_2[iClient]--;
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Extra Bind 2", iClient);
		}
		case 3: 	// Team Medical Supplies
		{
			RunCheatCommand(iClient, "give", "give defibrillator");
			RunCheatCommand(iClient, "give", "give first_aid_kit");
			RunCheatCommand(iClient, "give", "give first_aid_kit");
			RunCheatCommand(iClient, "give", "give first_aid_kit");
			RunCheatCommand(iClient, "give", "give first_aid_kit");
			RunCheatCommand(iClient, "give", "give adrenaline");
			RunCheatCommand(iClient, "give", "give adrenaline");
			RunCheatCommand(iClient, "give", "give adrenaline");
			RunCheatCommand(iClient, "give", "give adrenaline");
			RunCheatCommand(iClient, "give", "give pain_pills");
			RunCheatCommand(iClient, "give", "give pain_pills");
			RunCheatCommand(iClient, "give", "give pain_pills");
			RunCheatCommand(iClient, "give", "give pain_pills");

			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Team Medical Supplies", iClient);
		}
		case 4:		// Weapon Stash
		{
			GiveEveryWeaponToSurvivor(iClient);
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Every Weapon & Upgrade", iClient);
		}
		case 5:		// Self Revives
		{
			g_iSelfRevives[iClient] += 10;
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04+10 Self Revives", iClient);
		}
		case 6:		// Electric zap damage
		{
			DealDamage(iClient, iClient, 30);
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Electricution", iClient);
		}
		case 7:		// Lose all primary ammo
		{
			// Replace this later
			DealDamage(iClient, iClient, 30);
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Electricution", iClient);

			//new iAmmoOffset = FindDataMapInfo(client, "m_iAmmo");
			//GetEntProp(targetgun, Prop_Data, "m_iExtraPrimaryAmmo", 4);
			//SetEntData(iClient, iOffset_Ammo + 40, iAmmo - (g_iMetalLevel[iClient]*4) - (g_iFireLevel[iClient]*6));

			//PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x0410 No Primary Ammo", iClient);
		}
		case 8:		// Convert all health to temp health
		{
			// Store current health numbers
			new iCurrentHealth = GetEntProp(iClient, Prop_Data, "m_iHealth");
			new iTempHealth = GetSurvivorTempHealth(iClient);
			// Change health to only be 1
			SetEntProp(iClient, Prop_Data,"m_iHealth", 1);
			// Change temp health to self revive health
			if (iCurrentHealth > 1)
			{
				ResetTempHealthToSurvivor(iClient);
				AddTempHealthToSurvivor(iClient, float(iCurrentHealth + iTempHealth));
			}

			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04All Health Now Temp Health", iClient);
		}
		case 9:		// Drop all currently equipped items
		{
			// Replace this later
			DealDamage(iClient, iClient, 30);
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Electricution", iClient);

			//PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x0410 Drop Gear", iClient);
		}
	}
}

SetSurvivorScreenShakeAmount()
{
	// Clamp the minimum value of the screenshake to 0
	if (g_iScreenShakeAmount < 0)
		g_iScreenShakeAmount = 0;

	SetConVarInt(FindConVar("z_claw_hit_pitch_max"), g_iScreenShakeAmount);
	SetConVarInt(FindConVar("z_claw_hit_pitch_min"), g_iScreenShakeAmount * -1);
	SetConVarInt(FindConVar("z_claw_hit_yaw_max"), g_iScreenShakeAmount);
	SetConVarInt(FindConVar("z_claw_hit_yaw_min"), g_iScreenShakeAmount * -1);

	PrintToChatAll("g_iScreenShakeAmount =  %i", g_iScreenShakeAmount);
}

Action:TimerCreateInnerSphere(Handle:timer, any:iClient)
{
	CreateSphere(g_xyzWarezStationLocation[iClient], 35.0, 30, 0.1, {0, 255, 50, 150}, 25.0);
	return Plugin_Stop;
}


void DrawRing(const float xyzLocation[3])
{
	float xyzOffsetLocation[3];
	xyzOffsetLocation[0] = xyzLocation[0];
	xyzOffsetLocation[1] = xyzLocation[1];
	xyzOffsetLocation[2] = xyzLocation[2] + 10.0;
	TE_SetupBeamRingPoint(xyzOffsetLocation, 60.0, 59.0, g_iSprite_Laser, g_iSprite_Halo, 0, 15, 60.0, 5.0, 0.0, {0, 255, 30, 255}, 10, 0);
	TE_SendToAll();
}


int MakeLightDynamic(int target) //, const float vPos[3])
{
	int entity = CreateEntityByName("light_dynamic");
	if( entity == -1 || IsValidEntity(entity) == false)
	{
		LogError("Failed to create 'light_dynamic'");
		return 0;
	}

	DispatchKeyValue(entity, "_light", "0 255 0 0");
	DispatchKeyValue(entity, "brightness", "0.1");
	DispatchKeyValueFloat(entity, "spotlight_radius", 100.0);
	DispatchKeyValueFloat(entity, "distance", 400.0);
	DispatchKeyValue(entity, "style", "6");
	DispatchSpawn(entity);
	AcceptEntityInput(entity, "TurnOff");
	
	new Float:vPos[3];
	GetClientEyePosition(target, vPos);

	TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);

	// // Attaching has many issues, lighting glitches, laggy, fps, just dont do it.
	// // Attach
	// if( target )
	// {
	// 	SetVariantString("!activator");
	// 	AcceptEntityInput(entity, "SetParent", target);
	// }

	return entity;
}

Action:TimerRemoveLightDynamicEntity(Handle:timer, any:iEntity)
{
	if (iEntity < 1 || IsValidEntity(iEntity) == false)
		return Plugin_Stop;

	decl String:strEntityClass[32];
	GetEntityNetClass(iEntity, strEntityClass, 32);
	// PrintToChatAll("strEntityClass: %s", strEntityClass);
	if (StrEqual(strEntityClass, "CDynamicLight", true) == false)
		return Plugin_Stop;

	AcceptEntityInput(iEntity, "TurnOff");
	AcceptEntityInput(iEntity, "Kill");

	return Plugin_Stop;
}

GiveEveryWeaponToSurvivor(iClient)
{
	RunCheatCommand(iClient, "give", "give smg");
	RunCheatCommand(iClient, "give", "give smg_silenced");
	RunCheatCommand(iClient, "give", "give smg_mp5");
	RunCheatCommand(iClient, "give", "give rifle");
	RunCheatCommand(iClient, "give", "give rifle_sg552");
	RunCheatCommand(iClient, "give", "give rifle_desert");
	RunCheatCommand(iClient, "give", "give pumpshotgun");
	RunCheatCommand(iClient, "give", "give shotgun_chrome");
	RunCheatCommand(iClient, "give", "give autoshotgun");
	RunCheatCommand(iClient, "give", "give shotgun_spas");
	RunCheatCommand(iClient, "give", "give hunting_rifle");
	RunCheatCommand(iClient, "give", "give sniper_military");
	RunCheatCommand(iClient, "give", "give sniper_scout");
	RunCheatCommand(iClient, "give", "give sniper_awp");
	RunCheatCommand(iClient, "give", "give grenade_launcher");
	RunCheatCommand(iClient, "give", "give rifle_m60");
	RunCheatCommand(iClient, "give", "give pistol");
	RunCheatCommand(iClient, "give", "give fireaxe");
	RunCheatCommand(iClient, "give", "give crowbar");
	RunCheatCommand(iClient, "give", "give cricket_bat");
	RunCheatCommand(iClient, "give", "give baseball_bat");
	RunCheatCommand(iClient, "give", "give katana");
	RunCheatCommand(iClient, "give", "give electric_guitar");
	RunCheatCommand(iClient, "give", "give machete");
	RunCheatCommand(iClient, "give", "give frying_pan");
	RunCheatCommand(iClient, "give", "give tonfa");
	RunCheatCommand(iClient, "give", "give chainsaw");
	//RunCheatCommand(iClient, "give", "give riotshield");
	RunCheatCommand(iClient, "give", "give knife");
	RunCheatCommand(iClient, "give", "give golfclub");
	RunCheatCommand(iClient, "give", "give pipe_bomb");
	RunCheatCommand(iClient, "give", "give molotov");
	RunCheatCommand(iClient, "give", "give vomitjar");
	RunCheatCommand(iClient, "give", "give upgradepack_explosive");
	RunCheatCommand(iClient, "give", "give upgradepack_incendiary");
	RunCheatCommand(iClient, "give", "give rifle_ak47");
	RunCheatCommand(iClient, "give", "give pistol_magnum");
}