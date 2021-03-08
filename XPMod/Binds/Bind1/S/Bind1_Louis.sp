void Bind1Press_Louis(iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	if (g_iClientBindUses_1[iClient] >= 1)
	{
		PrintHintText(iClient, "You are out of Warez Stations.");
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
	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", g_xyzWarezStationLocation[iClient]);

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

	g_iClientBindUses_1[iClient]++;
}

Action:TimerWarezStationCheckForSurvivorToService(Handle:timer, any:iClient)
{
	if (g_bWareStationActive[iClient] == false)
		return Plugin_Stop;
	
	for(new iCandidate=1;iCandidate <= MaxClients;iCandidate++)
	{
		if (RunClientChecks(iCandidate) && 
			IsFakeClient(iCandidate) && 
			g_iClientTeam[iCandidate] == TEAM_SURVIVORS &&
			g_bWareStationClientAlreadyServiced[iClient][iCandidate] == false)
		{
			// Valid candidate, now check the distance to the warez station
			GetEntPropVector(iCandidate, Prop_Send, "m_vecOrigin", g_xyzWarezStationLocation[iClient]);
			WarezStationMenuDraw(iClient);
			g_bWareStationClientAlreadyServiced[iClient][iCandidate] = true;
		}
	}

	return Plugin_Continue;
}

// Warez Station Menu Draw
Action:WarezStationMenuDraw(iClient) 
{
	decl String:text[512];

	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(WarezStationMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	FormatEx(text, sizeof(text), "\
		\n \
		\n		cH0o53 joOr w4R3z\
		\n ===========================\
		\n ",
		g_iLouisTalent6Level[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], text);

	AddMenuItem(g_hMenu_XPM[iClient], "option1", "+2% Speed");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "+10% Max Health");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "-33% Team Screen Shake");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "+2 Self ledge revive");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "+1 Self revive");
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "Receive Medkit + Pills");
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "Receive Full Ammo");
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "I'm Feeling Lucky!\
	\n ===========================\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	// AddMenuItem(g_hMenu_XPM[iClient], "option9", "Nothing For Now.
	// \n ===========================
	// \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

// Warez Station Menu Handler
WarezStationMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0:	WarezStationMenuDraw(iClient);
			case 1:	WarezStationMenuDraw(iClient);
			case 2:
			{
				g_iScreenShakeAmount -= 7;
				SetSurvivorScreenShakeAmount();
			}
			case 3:	WarezStationMenuDraw(iClient);
			case 4:	WarezStationMenuDraw(iClient);
			case 5:	WarezStationMenuDraw(iClient);
			case 6:	WarezStationMenuDraw(iClient);
			case 7:	WarezStationMenuDraw(iClient);
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
