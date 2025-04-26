void Bind1Press_Louis(iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	if (g_iClientBindUses_1[iClient] >= 1)
	{
		PrintHintText(iClient, "You are out of Warez Stations.");
		return;
	}
	if (IsClientGrappled(iClient) || IsIncap(iClient) == true)
	{
		PrintHintText(iClient, "You cannot deploy a Warez Station while Grappled or Incapacitated.")
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

	// Warez station Sound
	new iSoundEntityAttachement = CreateEntityByName("env_smokestack");
	if (iSoundEntityAttachement != -1 && IsValidEntity(iSoundEntityAttachement))
	{
		// Spawn the dummy entity to attach the sound to and teleport it to our location
		DispatchSpawn(iSoundEntityAttachement);
		TeleportEntity(iSoundEntityAttachement, g_xyzWarezStationLocation[iClient], NULL_VECTOR, NULL_VECTOR);

		// PLay the sound
		EmitAmbientSound(SOUND_WAREZ_STATION, g_xyzWarezStationLocation[iClient], iSoundEntityAttachement, SNDLEVEL_NORMAL);

		// Turn off the sound and remove the sound entity once done
		CreateTimer(25.0, TimerWarezStationStopAndRemoveSound, iSoundEntityAttachement, TIMER_FLAG_NO_MAPCHANGE);
	}
	

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
				g_iWareStationOwnerIDOfCurrentlyViewedStation[iCandidate] = iClient;
				WarezStationMenuDraw(iCandidate);
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
	g_xyzWarezStationLocation[iClient][0] = EMPTY_VECTOR[0];
	g_xyzWarezStationLocation[iClient][1] = EMPTY_VECTOR[1];
	g_xyzWarezStationLocation[iClient][2] = EMPTY_VECTOR[2];

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
		\n  Brought to you by:\
		\n    %N\
		\n =========================\
		\n ",
		RunClientChecks(g_iWareStationOwnerIDOfCurrentlyViewedStation[iClient]) ? 
			g_iWareStationOwnerIDOfCurrentlyViewedStation[iClient] : iClient);
	SetMenuTitle(menu, text);

	AddMenuItem(menu, "option1", "+5% Speed Increase");
	AddMenuItem(menu, "option2", "+25 HP Max Health");
	AddMenuItem(menu, "option3", "-25% Team Screen Shake");
	AddMenuItem(menu, "option4", "+3 Bile Cleansing Kits");
	AddMenuItem(menu, "option5", "Receive Pills + Adrenaline");
	AddMenuItem(menu, "option6", "Receive Full Ammo");
	AddMenuItem(menu, "option7", "I'm Feeling Lucky\n ")
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option9", "", ITEMDRAW_NOTEXT);

	AddMenuItem(menu, "option10", "Nothing For Now.\
	\n =========================\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

// Warez Station Menu Handler
WarezStationMenuHandler(Menu menu, MenuAction:action, iClient, itemNum)
{	
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if (RunClientChecks(iClient) == false || 
			g_iClientTeam[iClient] != TEAM_SURVIVORS || 
			IsFakeClient(iClient))
			return;

		if (IsClientGrappled(iClient) || IsIncap(iClient) == true)
		{
			PrintHintText(iClient, "You cannot recieve Warez while Grappled or Incapacitated.")
			WarezStationMenuDraw(iClient);
			return;
		}

		switch (itemNum)
		{
			case 0: // Speed
			{
				// If louis warez boost for this player is already at cap, then redraw menu and let them choose again.
				if (g_fWarezStationSpeedBoost[iClient] >= 0.1)
				{
					PrintToChat(iClient, "\x03[XPMod] \x04Speed Increase is already at +10%%. Choose something else.");
					WarezStationMenuDraw(iClient);
					return;
				}

				g_fWarezStationSpeedBoost[iClient] += 0.05;
				SetClientSpeed(iClient);
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Speed Increase", iClient);
			}
			case 1: // Max Health
			{
				SetPlayerMaxHealth(iClient, 25, true, true);
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Max Health Boost", iClient);
			}
			case 2: // Team Screen Shake
			{
				// If screenshake is already 0, then redraw menu and let them choose again.
				if (g_iScreenShakeAmount <= 0)
				{
					PrintToChat(iClient, "\x03[XPMod] \x04Screen Shake is already at 0%%. Choose something else.");
					WarezStationMenuDraw(iClient);
					return;
				}
					
				// Print Message to Survivors
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Screen Shake Reduced", iClient);

				g_iScreenShakeAmount -= 5;
				SetSurvivorScreenShakeAmount();
			}
			case 3: // Bile Cleansing Kits
			{
				g_iBileCleansingKits[iClient] += 3;
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04+3 Bile Cleansing Kits", iClient);
				PrintToChat(iClient, "\x03[XPMod] \x04While biled, HOLD USE to use a Bile Cleansing Kit.");
			}
			case 4:	// Pills and Adrenaline
			{
				RunCheatCommand(iClient, "give", "give pain_pills");
				RunCheatCommand(iClient, "give", "give pain_pills");
				RunCheatCommand(iClient, "give", "give pain_pills");
				RunCheatCommand(iClient, "give", "give adrenaline");
				RunCheatCommand(iClient, "give", "give adrenaline");
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

		if (itemNum >= 0 && itemNum <= 7)
		{
			// Set that the iOwners Warez Station Serviced array to true for this iClient.
			new iOwner = g_iWareStationOwnerIDOfCurrentlyViewedStation[iClient];
			if (iOwner > 0)
				g_bWareStationClientAlreadyServiced[iOwner][iClient] = true;
			// Reset iClient's Warez Station Owner, they arent using a Warez Station any more.
			g_iWareStationOwnerIDOfCurrentlyViewedStation[iClient] = -1;
		}
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
			//For Louis, this is convertred to bind 1 since he doesnt have a bind 2 use count
			if (g_iChosenSurvivor[iClient] != LOUIS)
			{
				g_iClientBindUses_2[iClient]--;
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Extra Bind 2", iClient);
			}
			else 
			{
				g_iClientBindUses_1[iClient]--;
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Extra Bind 1", iClient);
			}
		}
		case 3: 	// Team Medical Supplies
		{
			RunCheatCommand(iClient, "give", "give defibrillator");
			RunCheatCommand(iClient, "give", "give first_aid_kit");
			RunCheatCommand(iClient, "give", "give first_aid_kit");
			RunCheatCommand(iClient, "give", "give first_aid_kit");
			RunCheatCommand(iClient, "give", "give adrenaline");
			RunCheatCommand(iClient, "give", "give adrenaline");
			RunCheatCommand(iClient, "give", "give pain_pills");
			RunCheatCommand(iClient, "give", "give pain_pills");

			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Team Medical Supplies", iClient);
		}
		case 4:		// Weapon Stash
		{
			// Check if its in cooldown first before giving (this is for performance reasons)
			if (g_bGiveAlotOfWeaponsOnCooldown == false)
			{
				GiveEveryWeaponToSurvivor(iClient);
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Weapons & Upgrades", iClient);
			}
			else
			{
				// Roll again if its in cooldown
				ImFeelingLuckyRoll(iClient);
			}
		}
		case 5:		// Self Revives
		{
			g_iSelfRevives[iClient] += 3;
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04+3 Self Revive Kits", iClient);
		}
		case 6:		// Deadly Electric zap damage
		{
			DealDamage(iClient, iClient, 99);
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Deadly Electricution", iClient);
		}
		case 7: 	// Electric zap damage
		{
			DealDamage(iClient, iClient, 50);
			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Electricution", iClient);
		}
		case 8:		// Convert all health to temp health
		{
			if (ConvertAllSurvivorHealthToTemporary(iClient))
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04All Health Now Temp Health", iClient);
			else
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Absolutely Nothing", iClient);
		}
		case 9:		// Lose 1 to 5 random items
		{
			// Find all equiped items
			int iEquippedItemsIDsArray[5] = {0, ...}, iItemCtr = 0;
			for (int i=0; i<5; i++)
			{
				int iItemID = GetPlayerWeaponSlot(iClient, i);
				if (iItemID > 0)
					iEquippedItemsIDsArray[iItemCtr++] = iItemID
			}

			// Player has no items so say they got nothing
			if (iItemCtr == 0)
				PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Absolutely Nothing", iClient);

			// Get number of items to destroy, also, cap it to all the items in their inventory
			int iNumItemsToRemove = GetRandomInt(1, 3);
			if (iNumItemsToRemove > iItemCtr)
				iNumItemsToRemove = iItemCtr;

			// Random sort the array 20 passes
			RandomSortIntArray(iEquippedItemsIDsArray, iItemCtr, 20);

			// Destroy the items
			for (int i=0; i<iNumItemsToRemove; i++)
			{
				if (iEquippedItemsIDsArray[i] > 0)
					KillEntitySafely(iEquippedItemsIDsArray[i]);
			}

			PrintToChatAll("\x03[XPMod] \x05%N r3C31v3D w4R3z: \x04Lost %i Random Equipped Items", iClient, iNumItemsToRemove);

			// TODO: Add some sort of way to handle things like extra items, grenades, pills, shots, etc.
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

	// Show the message to all that its been lowered, however don't show if its reset to 100%
	if (g_iScreenShakeAmount < 20.0)
		PrintToChatAll("\x03[XPMod] \x04Survivor Screen Shake on hit is at %i\%.", RoundToNearest((g_iScreenShakeAmount / 20.0) * 100.0) );
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
	TE_SetupBeamRingPoint(xyzOffsetLocation, 60.0, 59.0, g_iSprite_Laser, g_iSprite_Glow, 0, 15, 25.1, 5.0, 0.0, {0, 255, 30, 255}, 10, 0);
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

Action:TimerWarezStationStopAndRemoveSound(Handle:timer, any:iEntity)
{
	if (iEntity != -1 && IsValidEntity(iEntity))
	{
		EmitAmbientSound(SOUND_WAREZ_STATION, NULL_VECTOR, iEntity, SNDLEVEL_NORMAL, SND_STOPLOOPING);
		StopSound(iEntity, SNDCHAN_AUTO, SOUND_WAREZ_STATION);

		AcceptEntityInput(iEntity, "kill");
	}
	
	return Plugin_Stop;
}