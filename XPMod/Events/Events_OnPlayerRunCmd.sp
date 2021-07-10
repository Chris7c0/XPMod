public Action:OnPlayerRunCmd(iClient, &iButtons, &iImpulse, Float:fVelocity[3], Float:fAngles[3], &iWeapon)
{
	// if (g_bStopAllInput[iClient]) return Plugin_Handled;

	// if (g_bIsEntangledInSmokerTongue[iClient])
	// {
	// 	LockPlayerFromAttacking(iClient);
	// }

	bool bButtonsChanged = false;

	// If the round has not been unfrozen yet, check for input and then start unfreeze timer once input has been done
	if (g_bEndOfRound == false && g_bPlayerPressedButtonThisRound == false && iButtons)
	{
		g_bPlayerPressedButtonThisRound = true;
		// PrintToServer("**************************** Setting up unfreeze timer OnPlayerRunCmd");
		SetupUnfreezeGameTimer(20.0);
	}
	
	// // Get button released 
	// if( GetEntProp( iClient, Prop_Data, "m_afButtonReleased" ) )
	// 	PrintToServer("Button released =========================================< %i", GetEntProp( iClient, Prop_Data, "m_afButtonReleased" ));

	// Ensure is a real player before continuing to check for drawing choose character and confirm menu
	if (IsFakeClient(iClient) == false && g_iOpenCharacterSelectAndDrawMenuState[iClient] != FINISHED_AND_DREW_CONFIRM_MENU)
	{
		// Dont show this motd or menu if they have already confirmed
		if (g_bClientLoggedIn[iClient] == true && g_bTalentsConfirmed[iClient] == true)
			g_iOpenCharacterSelectAndDrawMenuState[iClient] = FINISHED_AND_DREW_CONFIRM_MENU;

		// Check if player pressed a certain button after joining game, if they did it will trigger a show choose character
		if (g_iOpenCharacterSelectAndDrawMenuState[iClient] == WAITING_ON_BUTTON_FOR_MOTD && (iButtons)
			// && (iButtons & IN_FORWARD || 
			// 	iButtons & IN_BACK || 
			// 	iButtons & IN_MOVELEFT || 
			// 	iButtons & IN_MOVERIGHT ||
			// 	iButtons & IN_JUMP || 
			// 	iButtons & IN_DUCK || 
			// 	iButtons & IN_ATTACK || 
			// 	iButtons & IN_ATTACK2)
			)
		{
			//PrintToServer("g_iOpenCharacterSelectAndDrawMenuState = WAITING_ON_RELEASE_FOR_CONFIRM_MENU: %i", iButtons);
			//PrintToChat(iClient, "g_iOpenCharacterSelectAndDrawMenuState = WAITING_ON_RELEASE_FOR_CONFIRM_MENU: %i", iButtons);
			g_iOpenCharacterSelectAndDrawMenuState[iClient] = WAITING_ON_RELEASE_FOR_CONFIRM_MENU;

			// This will open user chacter selection, then get the user data, then will draw confirm menu in callback
			// If they already chose to display this through the xpm menu, then dont display
			if (g_bClientAlreadyShownCharacterSelectMenu[iClient] == false)
				OpenCharacterSelectionPanel(iClient);
		}
		// Check if the user released any and all buttons that were pressed in the previous state
		if (g_iOpenCharacterSelectAndDrawMenuState[iClient] == WAITING_ON_RELEASE_FOR_CONFIRM_MENU && 
			iButtons == 0)
			//GetEntProp(iClient, Prop_Data, "m_afButtonReleased") & IN_FORWARD) //g_iButtonPressedbeforeCharacterMotd[iClient])
		{
			//PrintToServer("g_iOpenCharacterSelectAndDrawMenuState = ...");
			//PrintToChat(iClient, "g_iOpenCharacterSelectAndDrawMenuState = ...");

			// Set to 0 first to stop multiple calls
			g_iOpenCharacterSelectAndDrawMenuState[iClient] = 0;
			CreateTimer(1.0, StartWaitingForClientInputForDrawMenu, iClient);
		}
		// Check if the user pushed a button after the previous buttons were released
		if (g_iOpenCharacterSelectAndDrawMenuState[iClient] == WAITING_ON_FINAL_BUTTON_FOR_CONFIRM_MENU && iButtons)// & IN_FORWARD)
		{
			//PrintToChat(iClient, "g_iOpenCharacterSelectAndDrawMenuState = FINISHED_AND_DREW_CONFIRM_MENU");
			g_iOpenCharacterSelectAndDrawMenuState[iClient] = FINISHED_AND_DREW_CONFIRM_MENU;
			// This will get the user data, and the second true will draw confirm menu in callback
			// Make sure their talents aren't confirmed yet though, to not load or change multiple
			if (g_bTalentsConfirmed[iClient] == false)
				GetUserData(iClient, true, true);
		}
	}

	// Ghosts Spawn In
	// This is the best place I could find to capture ghost spawn in reliablly
	// Move this to on game frame if doing more with ghost and need it before input given
	if (g_bCanBeGhost[iClient] && 
		g_iClientTeam[iClient] == TEAM_INFECTED &&
		g_bIsGhost[iClient] == false &&
		RunClientChecks(iClient))
	{
		// Check if they have set a class already
		if (g_iInfectedCharacter[iClient] == UNKNOWN_INFECTED)
		{
			//Check if they are a ghost
			if (GetEntData(iClient, g_iOffset_IsGhost, 1) == 1)
			{
				g_bCanBeGhost[iClient] = false;
				g_bIsGhost[iClient] = true;
				//PrintToChat(iClient, "You are a ghost!");
				SetClientSpeed(iClient);
			}
		}
		// If they have an infected class set, then they are already spawned in
		else
		{
			g_bCanBeGhost[iClient] = false;
		}
	}
	
	OnPlayerRunCmd_BileCleanse(iClient, iButtons);

	OnPlayerRunCmd_SelfRevive(iClient, iButtons);

	bButtonsChanged = OnPlayerRunCmd_Louis(iClient, iButtons);
	
	//Charger Earthquake
	if(g_bIsHillbillyEarthquakeReady[iClient] == true && g_bCanChargerEarthquake[iClient] == true && iButtons & IN_ATTACK2 && g_iInfectedCharacter[iClient] == CHARGER)
	{
		new Float:xyzClientPosition[3], Float:xyzClientEyeAngles[3],Float:xyzRayTraceEndLocation[3];
		GetClientEyePosition(iClient, xyzClientPosition);
		GetClientEyeAngles(iClient,xyzClientEyeAngles); // Get the angle the player is looking
		
		TR_TraceRayFilter(xyzClientPosition,xyzClientEyeAngles,MASK_ALL,RayType_Infinite ,TraceRayTryToHit); // Create a ray that tells where the player is looking
		TR_GetEndPosition(xyzRayTraceEndLocation); // Get the end xyz coordinate of where a player is looking
		
		new Float:fDistanceOfTrace = GetVectorDistance(xyzClientPosition, xyzRayTraceEndLocation);
		if (fDistanceOfTrace <= 100.0)
		{
			//Create the earthquake effect and sound
			EmitSoundToAll(SOUND_EXPLODE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, xyzClientPosition, NULL_VECTOR, true, 0.0);
			
			TE_Start("BeamRingPoint");
			TE_WriteVector("m_vecCenter", xyzClientPosition);
			TE_WriteFloat("m_flStartRadius", 10.0);
			TE_WriteFloat("m_flEndRadius", 1000.0);
			TE_WriteNum("m_nModelIndex", g_iSprite_Laser);
			TE_WriteNum("m_nHaloIndex", g_iSprite_Halo);
			TE_WriteNum("m_nStartFrame", 0);
			TE_WriteNum("m_nFrameRate", 60);
			TE_WriteFloat("m_fLife", 0.5);
			TE_WriteFloat("m_fWidth", 100.0);
			TE_WriteFloat("m_fEndWidth", 5.0);
			TE_WriteFloat("m_fAmplitude",  0.5);
			TE_WriteNum("r", 20);
			TE_WriteNum("g", 20);
			TE_WriteNum("b", 20);
			TE_WriteNum("a", 200);
			TE_WriteNum("m_nSpeed", 10);
			TE_WriteNum("m_nFlags", 0);
			TE_WriteNum("m_nFadeLength", 0);
			TE_SendToAll();
		
			//Checking if there are survivors close enough to the blast and shaking them
			decl iTarget;
			for (iTarget = 1; iTarget <= MaxClients; iTarget++)
			{
				if(IsClientInGame(iTarget) && IsPlayerAlive(iTarget) && g_iClientTeam[iTarget] == TEAM_SURVIVORS && GetEntProp(iTarget, Prop_Send, "m_isIncapacitated") == 0)
				{
					decl Float:xyzTargetLocation[3];
					GetClientEyePosition(iTarget, xyzTargetLocation);
					new Float:fDistance = GetVectorDistance(xyzTargetLocation, xyzClientPosition);
					if(IsVisibleTo(xyzClientPosition, xyzTargetLocation) == true && fDistance < (200.0 + (float(g_iHillbillyLevel[iClient]) * 15.0)))
					{
						//Shake their screen
						new Handle:hShakeMessage;
						hShakeMessage = StartMessageOne("Shake", iTarget);
						
						BfWriteByte(hShakeMessage, 0);
						BfWriteFloat(hShakeMessage, 40.0);	//Intensity
						BfWriteFloat(hShakeMessage, 10.0);
						BfWriteFloat(hShakeMessage, 3.0);	//Time?
						EndMessage();
						
						//"Stagger the player by flinging them
						SDKCall(g_hSDK_Fling, iTarget, EMPTY_VECTOR, 96, iClient, 3.0);
						
						//Hurt the player
						DealDamage(iTarget, iClient, RoundToCeil(g_iHillbillyLevel[iClient] * 2.5));
					}
				}
			}
			g_bIsHillbillyEarthquakeReady[iClient] = false;
			g_iClientBindUses_2[iClient]++;
			
			//Set cooldown
			g_bCanChargerEarthquake[iClient] = false;
			CreateTimer(30.0, TimerEarthquakeCooldown, iClient, TIMER_FLAG_NO_MAPCHANGE);
		}
	}

	//Bill's Team Crawling
	if(g_iCrawlSpeedMultiplier > 0 && IsFakeClient(iClient) == false)
	{
		// gClone[iClient] == -1 check is to make sure Animation isnt already playing 
		if(gClone[iClient] == -1 && !g_bEndOfRound && iButtons & IN_FORWARD && GetEntProp(iClient, Prop_Send, "m_isIncapacitated")) 
		{
			CreateTimer(0.1,tmrPlayAnim,iClient);		// Delay so we can get the correct angle/direction after they have moved
			gClone[iClient] = -2;						// So we don't play the anim more than once if the player presses forward within the 0.1 delay
		}
		// Animation has been playing but no longer moving/incapped
		else if(gClone[iClient] > 1)
		{
			RestoreClient(iClient);
		}
	}

	// // Testing bot button presses
	// if (g_iTankChosen[iClient] == TANK_VAMPIRIC)
	// {
	// 	if (g_bShouldJump[iClient])
	// 	{
	// 		PrintToChatAll("Jumping");
	// 		iButtons &= IN_JUMP;
	// 		g_bShouldJump[iClient] = false;

	// 		return Plugin_Changed;
	// 	}
	// 	else
	// 	{
	// 		if (g_hShouldAttackTimer[iClient] == null) {
	// 			PrintToChatAll("Not Jumping");
	// 			iButtons |= IN_JUMP;

	// 			//delete g_hShouldAttackTimer[iClient];
	// 			g_hShouldAttackTimer[iClient] = CreateTimer(3.0, Timer_ShouldJump, iClient);
	// 		}
	// 	}
	// }

	// Louis's bind 2 player hacked, reverse movement and angles to cause confusion
	if (g_bIsPLayerHacked[iClient])
	{
		fVelocity[0] *= -1.0;
		fVelocity[1] *= -1.0;
		fAngles[0] *= -1.0;
		fAngles[1] *= -1.0;
		return Plugin_Changed;
	}

	if (bButtonsChanged)
		return Plugin_Changed;
		

	return Plugin_Continue;
}

// // Testing bot button presses
// bool g_bShouldJump[MAXPLAYERS + 1];
// Handle g_hShouldAttackTimer[MAXPLAYERS + 1];
// public Action Timer_ShouldJump(Handle timer, int client)
// {
// 	PrintToChatAll("Timer_ShouldJump");

// 	// check if client is the same has the one before when the timer started
// 	if (client != 0) {
// 		// set variable so next frame knows that client need to release attack
// 		g_bShouldJump[client] = true;
// 	}

// 	g_hShouldAttackTimer[client] = null;
// 	return Plugin_Handled;
// }