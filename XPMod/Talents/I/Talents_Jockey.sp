TalentsLoad_Jockey(iClient)
{
	if (g_bTalentsConfirmed[iClient] == false ||
		g_iMutatedLevel[iClient] < 0)
		return;

	PrintToChat(iClient, "\x03[XPMod] \x05Your \x04Jockey Talents \x05have been loaded.");

	// Reset the Jockey Super speed every time spawn because this is set later here
	g_bHasSuperJockeySpeed[iClient] = false;

	if (g_bHasInfectedHealthBeenSet[iClient] == false)
	{
		g_bHasInfectedHealthBeenSet[iClient] = true;

		// Set player health depending on if they are an upgraded jockey
		switch (g_fJockeyNextSpawnUpgradeLevel[iClient])
		{
			case 0: { SetPlayerMaxHealth(iClient, (g_iUnfairLevel[iClient] * 35), true); }
			case 1: { PrintToChat(iClient, "\x03[XPMod] \x05You've Become \x04High Health Jockey"); SetPlayerMaxHealth(iClient, 1000); }
			case 2: { PrintToChat(iClient, "\x03[XPMod] \x05You've Become \x04Super Jockey"); SetPlayerMaxHealth(iClient, 1500); g_bHasSuperJockeySpeed[iClient] = true; }
			case 3: { PrintToChat(iClient, "\x03[XPMod] \x05You've Become \x04Supreme Jockey"); SetPlayerMaxHealth(iClient, 2000); g_bHasSuperJockeySpeed[iClient] = true; }
		}
	}

	SetClientSpeed(iClient);
	g_bCanJockeyPee[iClient] = true;

	g_bCanJockeyJump[iClient]				= false;
	g_fJockeyRideDistance[iClient]			= 0.0;
	g_fJockeyNextSpawnUpgradeLevel[iClient] = 0;

	
}

OnGameFrame_Jockey(iClient)
{
	if ((g_iUnfairLevel[iClient] > 0) && (g_bJockeyIsRiding[iClient] == true))
	{
		// PrintToChatAll("g_iUnfairLevel is higher than 0 and the jockey is riding");
		int buttons;
		buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if (buttons & IN_JUMP)
		{
			if (RunClientChecks(iClient) == true && RunClientChecks(g_iJockeysVictim[iClient]) == true)
			{
				// PrintToChatAll("g_bCanJockeyJump = %i, g_bCanJockeyCloak = %i", g_bCanJockeyJump[iClient], g_bCanJockeyCloak[iClient]);
				if (g_bCanJockeyJump[iClient] == true && g_bCanJockeyCloak[iClient] == false)
				{
					float xyzJumpVelocity[3];
					xyzJumpVelocity[0] = 0.0;
					xyzJumpVelocity[1] = 0.0;
					xyzJumpVelocity[2] = (g_iUnfairLevel[iClient] * 50.0);
					// PrintToChatAll("X = %f, Y = %f, Z = %f", xyzJumpVelocity[0], xyzJumpVelocity[1], xyzJumpVelocity[2]);
					TeleportEntity(g_iJockeysVictim[iClient], NULL_VECTOR, NULL_VECTOR, xyzJumpVelocity);
					g_bCanJockeyJump[iClient] = false;
					CreateTimer(2.5, TimerJockeyJumpReset, iClient, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}

EventsHurt_AttackerJockey(Handle hEvent, iAttacker, iVictim)
{
	if (IsFakeClient(iAttacker))
		return;

	if (g_iClientTeam[iVictim] != TEAM_SURVIVORS)
		return;

	if (g_iMutatedLevel[iAttacker] > 0)
	{
		if (g_iJockeyVictim[iAttacker] < 0)	   // If they are NOT riding a victim
		{
			char weapon[20];
			GetEventString(hEvent, "weapon", weapon, 20);
			if (StrEqual(weapon, "jockey_claw") == true)
			{
				decl dmg;
				if (g_iMutatedLevel[iAttacker] < 5)
					dmg = 1;
				else if (g_iMutatedLevel[iAttacker] < 9)
					dmg = 2;
				else
					dmg = 3;

				new hp = GetPlayerHealth(iVictim);
				if (hp > dmg)
					DealDamage(iVictim, iAttacker, dmg);
			}
		}
	}

	if (g_iErraticLevel[iAttacker] > 0)
	{
		if (g_iJockeyVictim[iAttacker] > 0)	   // If they ARE riding a victim
		{
			char weapon[20];
			GetEventString(hEvent, "weapon", weapon, 20);
			if (StrEqual(weapon, "jockey_claw") == true)
			{
				decl dmg;
				if (g_iMutatedLevel[iAttacker] < 5)
					dmg = 1;
				else if (g_iMutatedLevel[iAttacker] < 9)
					dmg = 2;
				else
					dmg = 3;
				// hp = GetPlayerHealth(iVictim);
				// PrintToChat(iAttacker, "pre hp = %d riding",hp);
				new hp = GetPlayerHealth(iVictim);
				if (hp > dmg)
					DealDamage(iVictim, iAttacker, dmg);

				// PrintToChat(iAttacker, "dmg");
				// hp = GetPlayerHealth(iVictim);
				// PrintToChat(iAttacker, "    post hp = %d riding",hp);
			}
		}
	}
}

// EventsDeath_AttackerJockey(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

// EventsDeath_VictimJockey(Handle:hEvent, iAttacker, iVictim)
// {
// 	SuppressNeverUsedWarning(hEvent, iAttacker, iVictim);
// }

Event_JockeyRide_Jockey(iAttacker, iVictim)
{
	g_bJockeyIsRiding[iAttacker]	 = true;
	g_bJockeyGrappled[iVictim]		 = true;
	g_iJockeysVictim[iAttacker]		 = iVictim;
	g_fJockeyRideDistance[iAttacker] = 0.0;
	SetClientRenderAndGlowColor(iVictim);

	GiveClientXP(iAttacker, 50, g_iSprite_50XP_SI, iVictim, "Grappled A Survivor.");

	g_iJockeyVictim[iAttacker] = iVictim;
	// Store the Jockey's location for determining drag distance
	GetClientAbsOrigin(iAttacker, g_xyzJockeyStartRideLocation[iAttacker]);

	if (g_iUnfairLevel[iAttacker] > 0)
	{
		new iReserveAmmoDropChance = GetRandomInt(1, 10);
		if (iReserveAmmoDropChance <= g_iUnfairLevel[iAttacker])
		{
			StoreCurrentPrimaryWeapon(iVictim);
			char strCurrentWeapon[32];
			GetClientWeapon(iVictim, strCurrentWeapon, sizeof(strCurrentWeapon));
			if (StrEqual(strCurrentWeapon, "weapon_melee", false) == false && StrEqual(strCurrentWeapon, "weapon_pistol", false) == false && StrEqual(strCurrentWeapon, "weapon_pistol_magnum", false) == false && g_iOffset_Ammo[iVictim] > 0 && g_iAmmoOffset[iVictim] > 0 && g_iReserveAmmo[iVictim] > 0)
			{
				// PrintToChatAll("Reserve ammo was %i ...", g_iReserveAmmo[iVictim]);
				// g_iReserveAmmo[iVictim] = (g_iReserveAmmo[victim] / 2)
				// PrintToChatAll("Is this a float = %i", g_iReserveAmmo[victim]);
				SetEntData(iVictim, g_iOffset_Ammo[iVictim] + g_iAmmoOffset[iVictim], (g_iReserveAmmo[iVictim] / 2));
				// PrintToChatAll("... and is now %i", GetEntData(victim, g_iOffset_Ammo[victim] + g_iAmmoOffset[victim]));
			}
		}
	}

	// Set Ride Speed for Coach
	if (g_bTalentsConfirmed[iVictim] == true &&
		g_iStrongLevel[iVictim] > 0)
	{
		g_fJockeyRideSpeed[iVictim] = 0.0;
		SetClientSpeed(iVictim);
		return;
	}

	if (g_bTalentsConfirmed[iAttacker] == false)
	{
		// Normal Jockey Ride Speed
		g_fJockeyRideSpeed[iVictim] = 1.0;
		SetClientSpeed(iVictim);
		return;
	}

	if (g_iErraticLevel[iAttacker] > 0)
	{
		// SetEntDataFloat(iVictim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), ((1.0 + (g_iErraticLevel[iAttacker] * 0.03)) - ((g_iStrongLevel[iVictim] * 0.2) + ((g_iErraticLevel[iAttacker] * 0.03) * (g_iStrongLevel[iVictim] * 0.2)))), true);
		// PrintToChatAll("JOCKEY RIDESPEED SET: %f", ( 1.0 - (g_iStrongLevel[iVictim] * 0.2) + (g_iErraticLevel[iAttacker] * 0.03)) );
		// SetEntDataFloat(iVictim , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), ( 1.0 - (g_iStrongLevel[iVictim] * 0.2) + (g_iErraticLevel[iAttacker] * 0.03) ), true);
		g_fJockeyRideSpeed[iVictim] = 1.0 + (g_iErraticLevel[iAttacker] * 0.03);
		SetClientSpeed(iVictim);
	}
}

CheckDistanceRidenAndPrintMessage(iClient)
{
	if (g_bTalentsConfirmed[iClient] == false || 
		g_bJockeyIsRiding[iClient] == false || 
		g_iErraticLevel[iClient] < 0 ||
		RunClientChecks(iClient) == false || 
		IsFakeClient(iClient) == true)
		return;

	float xyzCurrentLocation[3];
	GetClientAbsOrigin(iClient, xyzCurrentLocation);
	g_fJockeyRideDistance[iClient] = GetVectorDistance(g_xyzJockeyStartRideLocation[iClient], xyzCurrentLocation) / 16.0;

	PrintHintText(iClient, "Ride Distance: %0.0f Ft.", g_fJockeyRideDistance[iClient]);
}

HandleDragRaceRewards(int iClient, int iVictim)
{
	if (g_bTalentsConfirmed[iClient] == false || RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	PrintToChat(iClient, "\x03[XPMod] \x05You Rode \x04%N\x05 %0.0f Feet.", iVictim, g_fJockeyRideDistance[iClient]);

	if (g_fJockeyRideDistance[iClient] >= 150.0)
		HandleTier3Rewards(iClient, iVictim);
	else if (g_fJockeyRideDistance[iClient] >= 100.0)
		HandleTier2Rewards(iClient, iVictim);
	else if (g_fJockeyRideDistance[iClient] >= 50.0)
		HandleTier1Rewards(iClient, iVictim);
}

HandleTier1Rewards(int iClient, int iVictim)
{
	int iRoll = GetRandomInt(1, 2);

	switch (iRoll)
	{
		case 1:
		{
			float xyzLocation[3];
			// Get the location of where to spawn new enhanced CI
			GetEntPropVector(iVictim, Prop_Send, "m_vecOrigin", xyzLocation);
			// Spawn an Enhanced CI in the location of the killed CI's place
			SpawnCIAroundLocation(xyzLocation, 4, UNCOMMON_CI_NONE, CI_SMALL_OR_BIG_NONE, ENHANCED_CI_TYPE_RANDOM, false);

			PrintToChat(iClient, "\x03[XPMod] \x05Common Infected Spawned on Victim");
		}
		case 2:
		{
			g_fJockeyNextSpawnUpgradeLevel[iClient] = 1;
			PrintToChat(iClient, "\x03[XPMod] \x05High Health Jockey on Next Spawn");
		}
	}
}

HandleTier2Rewards(int iClient, int iVictim)
{
	int iRoll = GetRandomInt(1, 3);

	switch (iRoll)
	{
		case 1:
		{
			float xyzLocation[3];
			// Get the location of where to spawn new enhanced CI
			GetEntPropVector(iVictim, Prop_Send, "m_vecOrigin", xyzLocation);
			// Spawn an Enhanced CI in the location of the killed CI's place
			SpawnCIAroundLocation(xyzLocation, 4, UNCOMMON_CI_NONE, CI_SMALL_OR_BIG_NONE, ENHANCED_CI_TYPE_RANDOM, false);
			PrintToChat(iClient, "\x03[XPMod] \x05Ehanced Common Infected Spawned on Victim");
		}
		case 2:
		{
			g_fJockeyNextSpawnUpgradeLevel[iClient] = g_fJockeyNextSpawnUpgradeLevel[iClient] < 2 ? 2 : g_fJockeyNextSpawnUpgradeLevel[iClient];
			PrintToChat(iClient, "\x03[XPMod] \x05Super Jockey on Next Spawn");
		}
		case 3:
		{
			PrintToChatAll("\x03[XPMod] \x04%N\x05 Rode %N.\nCommon Infected Temporarily Do More Damage.", iClient, iVictim);
			g_bCommonInfectedDoMoreDamage = true;
			CreateTimer(30.0, TimerResetZombieDamage, 0, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

HandleTier3Rewards(int iClient, int iVictim)
{
	int iRoll = GetRandomInt(1, 3);

	switch (iRoll)
	{
		case 1:
		{
			float xyzLocation[3];
			// Get the location of where to spawn new enhanced CI
			GetEntPropVector(iVictim, Prop_Send, "m_vecOrigin", xyzLocation);
			// Spawn an Enhanced CI in the location of the killed CI's place
			SpawnCIAroundLocation(xyzLocation, 4, UNCOMMON_CI_JIMMY, CI_REALLY_BIG_JIMMY, ENHANCED_CI_TYPE_NONE, false);
			PrintToChat(iClient, "\x03[XPMod] \x05Jimmies Spawned on Victim");
		}
		case 2:
		{
			g_fJockeyNextSpawnUpgradeLevel[iClient] = g_fJockeyNextSpawnUpgradeLevel[iClient] < 3 ? 3 : g_fJockeyNextSpawnUpgradeLevel[iClient];
			PrintToChat(iClient, "\x03[XPMod] \x05Supreme Jockey on Next Spawn");
		}
		case 3:
		{
			// Give Extra Bind1 or Bind 2
			if (GetRandomInt(1, 2) == 1)
			{
				g_iClientBindUses_1[iClient]--;
				PrintToChat(iClient, "\x03[XPMod] \x05You Gain An Extra Bind 1");
			}
			else
			{
				g_iClientBindUses_2[iClient]--;
				PrintToChat(iClient, "\x03[XPMod] \x05You Gain An Extra Bind 2");
			}
		}
	}
}