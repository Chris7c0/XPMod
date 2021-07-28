void Bind1Press_Nick(iClient)
{
	if(g_iMagnumLevel[iClient] <= 0)
	{
		PrintHintText(iClient, "You posses no talent for Bind 1");
		return;
	}

	if(g_iClientBindUses_1[iClient] >= 3)
	{
		PrintHintText(iClient, "Your out of money as well as people to scam money off of...for now.");
		return;
	}
	
	if(g_bNickIsGettingBeatenUp[iClient] == true)
	{
		PrintHintText(iClient, "You cannot gamble while being bitch slapped.");
		return;
	}

	if(g_bRamboModeActive[iClient] == true)
	{
		PrintHintText(iClient, "You cannot gamble while you're Rambo.");
		return;
	}
	
	NickGamblingProblemRollTheDice(iClient);

	// Draw the particles for his gamble, don't do this in the function as it can call itself for re-rolls
	WriteParticle(iClient, "nick_bind_gamble", 0.0, 35.0);
	g_iClientBindUses_1[iClient]++;

	PrintToChatAll("\x03[XPMod] \x04%You have \x05%i \x04gamble%s left.",
		3 - g_iClientBindUses_1[iClient],
		(3 - g_iClientBindUses_1[iClient]) != 1 ? "s" : "");
}

NickGamblingProblemRollTheDice(int iClient)
{	
	switch (GetRandomInt(1,12))
	{
		case 1: //Raid the Medicine cabinet
		{
			PrintHintText(iClient,"Rolled a 1\nYou got in good with a random drug dealer.");
			PrintToChatAll("\x03[XPMod] \x05%N got \"Da Huk Up\"...pop those pillz.", iClient);
			float xyzClientLocation[3];
			GetClientEyePosition(iClient, xyzClientLocation);
			SpawnItem(xyzClientLocation, ITEM_PAIN_PILLS, 1.0);
			SpawnItem(xyzClientLocation, ITEM_PAIN_PILLS, 1.0);
			SpawnItem(xyzClientLocation, ITEM_PAIN_PILLS, 1.0);
			SpawnItem(xyzClientLocation, ITEM_PAIN_PILLS, 1.0);
		}
		case 2: // Slap
		{
			new iCurrentHP = GetPlayerHealth(iClient);
			if(iCurrentHP > 15)
				SlapPlayer(iClient, 15);
			else
				SlapPlayer(iClient, iCurrentHP - 1);
			PrintHintText(iClient,"Rolled a 2\nYou were caught stealing and slapped at gunpoint by that shady dude on the corner.");
			PrintToChatAll("\x03[XPMod] \x05%N been pimp slapped by a drug dealer.", iClient);
		}
		case 3: // Raided a gun shop, holy crap
		{
			// Check if its in cooldown first before giving (this is for performance reasons)
			if (g_bGiveAlotOfWeaponsOnCooldown == false)
			{
				GiveEveryWeaponToSurvivor(iClient);

				PrintHintText(iClient,"Rolled a 3\nYou raided a huge weapon store. Lock and Load!");
				PrintToChatAll("\x03[XPMod] \x05%N received a shite-ton of weapons.", iClient);
			}
			else
			{
				// Roll again if its in cooldown
				NickGamblingProblemRollTheDice(iClient);
			}
		}
		case 4: //Rambo
		{
			StoreCurrentPrimaryWeapon(iClient);
			StoreCurrentPrimaryWeaponAmmo(iClient);
			
			if (RunEntityChecks(g_iPrimarySlotID[iClient]))
				AcceptEntityInput(g_iPrimarySlotID[iClient], "Kill");

			g_bRamboModeActive[iClient] = true;
			RunCheatCommand(iClient, "give", "give rifle_m60");
			// Store the rambo weapon id to give infinite ammo and destroy later
			g_iRamboWeaponID[iClient] = GetPlayerWeaponSlot(iClient, 0);
			// Update the ammo to infinite (must be done next game frame)
			g_bSetWeaponAmmoOnNextGameFrame[iClient] = true;

			RunCheatCommand(iClient, "upgrade_add", "upgrade_add LASER_SIGHT");
			RunCheatCommand(iClient, "upgrade_add", "upgrade_add EXPLOSIVE_AMMO");
			CreateTimer(30.0, TimerStopRambo, iClient, TIMER_FLAG_NO_MAPCHANGE);

			PrintHintText(iClient,"Rolled a 4\nAAAAAAAAAADDDRRRIIAAAAAAAAAAN!");
			PrintToChatAll("\x03[XPMod] \x05%N has become RAMBO!!!", iClient);

		}
		case 5: //Crack Out on drugs
		{
			PrintHintText(iClient,"Rolled a 5\nYou popped some colorful pills from some shady ass dude on fifth street.");
			PrintToChatAll("\x03[XPMod] \x05%N popped some shady pills...THE COLORRRRRSS...", iClient);
			
			new red = GetRandomInt(0,255);
			new green = GetRandomInt(0,255);
			new blue = GetRandomInt(0,255);
			new alpha = GetRandomInt(190,230);
			
			//Set Hud Overlay of The Random Color
			ShowHudOverlayColor(iClient, red, green, blue, alpha, 700, FADE_OUT);
			
			WriteParticle(iClient, "drugged_effect", 0.0, 30.0);
			
			g_iDruggedRuntimesCounter[iClient] = 0;

			delete g_hTimer_DrugPlayer[iClient];
			g_hTimer_DrugPlayer[iClient] = CreateTimer(2.5, TimerDrugged, iClient, TIMER_REPEAT);
		}
		case 6: //MegaSlap; Slaps Nick for 80 damage.
		{
			g_bNickIsGettingBeatenUp[iClient] = true;
			PrintHintText(iClient,"Rolled a 6\nYou were caught carrying a pistol by a self-loathing cop...better cover up!");
			PrintToChatAll("\x03[XPMod] \x05%N is being beaten by a self-loathing cop!", iClient);
			
			g_iSlapRunTimes[iClient] = 0;
			delete g_hTimer_SlapPlayer[iClient];
			g_hTimer_SlapPlayer[iClient] = CreateTimer(1.0, TimerSlap, iClient, TIMER_REPEAT);
		}
		case 7: //Party supplies++; Spawns 2 defibs, kits, pills, and shots
		{

			PrintHintText(iClient,"Rolled a 7\nYou raided a hospital's medicine cabinet for supplies.");
			PrintToChatAll("\x03[XPMod] \x05%N raided a hospital's medicine cabinet for supplies.", iClient);

			float xyzClientLocation[3];
			GetClientEyePosition(iClient, xyzClientLocation);
			SpawnItem(xyzClientLocation, ITEM_DEFIBRILLATOR, 1.0);
			SpawnItem(xyzClientLocation, ITEM_FIRST_AID_KIT, 1.0);
			SpawnItem(xyzClientLocation, ITEM_ADRENALINE_SHOT, 1.0);
			SpawnItem(xyzClientLocation, ITEM_PAIN_PILLS, 1.0);
			SpawnItem(xyzClientLocation, ITEM_DEFIBRILLATOR, 1.0);
			SpawnItem(xyzClientLocation, ITEM_FIRST_AID_KIT, 1.0);
			SpawnItem(xyzClientLocation, ITEM_ADRENALINE_SHOT, 1.0);
			SpawnItem(xyzClientLocation, ITEM_PAIN_PILLS, 1.0);

		}
		case 8: //Get three more times to Gamble
		{
			PrintHintText(iClient,"Rolled an 8\nYou found a sucker to scam, you get an extra gamble.");
			g_iClientBindUses_1[iClient] -= 2;
			PrintToChatAll("\x03[XPMod] \x05%N received an extra gamble.", iClient);
		}
		case 9: //Party Supplies; Spawns 1 defib, kit, pills, and shot
		{

			PrintHintText(iClient,"Rolled a 9\nYou found some medical supplies.");
			PrintToChatAll("\x03[XPMod] \x05%N found some medical supplies.", iClient);
			float xyzClientLocation[3];
			GetClientEyePosition(iClient, xyzClientLocation);
			SpawnItem(xyzClientLocation, ITEM_FIRST_AID_KIT, 1.0);
			SpawnItem(xyzClientLocation, ITEM_ADRENALINE_SHOT, 1.0);
			SpawnItem(xyzClientLocation, ITEM_PAIN_PILLS, 1.0);

		}
		case 10: //Blindness
		{
			PrintHintText(iClient,"Rolled a 10\nYou accidentally splashed questionable chemicals in your eyes.");
			PrintToChatAll("\x03[XPMod] \x05%N has been temporarily blinded by chemicals.", iClient);
											
			ShowHudOverlayColor(iClient, 0, 0, 0, 255, 300, FADE_OUT);
			
			CreateTimer(0.8, TimerBlindFade, iClient, TIMER_FLAG_NO_MAPCHANGE);
		}
		case 11: //Revival; Return to maximum health, even when incapped
		{
			if(IsClientGrappled(iClient) == false)
			{
				CreateTimer(0.1, TimerApplyDivineIntervention, iClient, TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				g_bDivineInterventionQueued[iClient] = true;
				PrintToChat(iClient, "\x03[XPMod] \x05Divine intervention will be applied when you break free!");
			}
		}
		case 12: //Gain 2 more bind2s
		{
			PrintHintText(iClient,"Rolled an 12\nA night of partying left you wanting more.");
			PrintToChatAll("\x03[XPMod] \x05%N feels ready for more! +2 to Bind2!", iClient);
			g_iClientBindUses_2[iClient] -= 2;
		}
	}
}


Action:TimerApplyDivineIntervention(Handle hTimer, int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return Plugin_Stop;

	RunCheatCommand(iClient, "give", "give health");
	ResetTempHealthToSurvivor(iClient);

	PrintHintText(iClient,"Rolled an 11\nYou have received divine intervention from above...or below.");
	PrintToChatAll("\x03[XPMod] \x05%N was given a fresh life.", iClient);
	
	g_bIsClientDown[iClient] = false;
	g_bDivineInterventionQueued[iClient] = false;

	return Plugin_Stop;
}