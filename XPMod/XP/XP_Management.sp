void CheckLevel(int iClient)
{
	if(g_iClientLevel[iClient] != 30 && g_iClientXP[iClient] >= g_iClientNextLevelXPAmount[iClient])
		LevelUpPlayer(iClient);
}

void RenamePlayerWithLevelTags(int iClient, bool bRemoveTags = false)
{
	if (RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) ==  true ||
		g_bClientLoggedIn[iClient] == false)
		return;

	char strClientName[32];
	char strClientBaseName[32];
	GetClientName(iClient, strClientName, sizeof(strClientName));

	// Create the Level Tag regex to check against
	// Needs to match tagged names below (one with prestige and one without)
	// [30] ChrisP
	// [☆111] Test
	Handle hTagRegex = CompileRegex("\\[.{0,3}[0-9]{0,3}\\] ..*");

	// Check if XPMod Level tag is already added before continuing
	// If its already there, then remove it to obtain base name
	if (MatchRegex(hTagRegex, strClientName))
		strcopy(strClientBaseName, sizeof(strClientBaseName), strClientName[StrContains(strClientName, "] ") + 2]);
	else
		strcopy(strClientBaseName, sizeof(strClientBaseName), strClientName);

	CloseHandle(hTagRegex);

	// The string [30] is 5 chars with the space. Max name length is 31.
	// So check to make sure the name is not longer than 31 - 5 = 26
	// before continuing.
	// This has changed with Prestige Points, now its 31 - 9 = 22
	if (strlen(strClientBaseName) > 22)
		return;


	// Add the tag to the players name if needed
	if (bRemoveTags == false)
	{
		// Get the client level into a string and combine it into the final name
		char strClientLevel[4];
		if (g_iClientPrestigePoints[iClient] == 0)
		{
			IntToString(g_iClientLevel[iClient], strClientLevel, sizeof(strClientLevel));
			Format(strClientName, sizeof(strClientName), "[%s] %s", strClientLevel, strClientBaseName);
		}
		else
		{
			IntToString(g_iClientPrestigePoints[iClient], strClientLevel, sizeof(strClientLevel));
			Format(strClientName, sizeof(strClientName), "[☆%s] %s", strClientLevel, strClientBaseName);
		}
	}
	


	g_bHideNameChangeMessage = true;
	
	// Set the client name to the new name
	if (bRemoveTags == false)
		SetClientName(iClient, strClientName);
	else
		SetClientName(iClient, strClientBaseName);

	delete g_hTimer_ResetHideNameChangeMessage;
	g_hTimer_ResetHideNameChangeMessage = CreateTimer(0.5, TimerSetHideChangeNameMessage, _);

}

Action TimerSetHideChangeNameMessage(Handle timer, int data)
{
	g_bHideNameChangeMessage = false;

	g_hTimer_ResetHideNameChangeMessage = null;
	return Plugin_Stop;
}

Action GiveXPbyID(int iClient, int args)
{
	if(args!=2)
	{
		if(iClient == 0)
			PrintToServer("[XPMod] Incorrect format. Example: givexpid 3 999");
		else
			PrintToChat(iClient, "\x03[XPMod] \x01Incorrect format. Example: \x05!givexpid 3 999");
		return Plugin_Handled;
	}
	
	char targetnum[128];
	GetCmdArg(1, targetnum, sizeof(targetnum));

	int target = StringToInt(targetnum);
	
	if (target < 1)
	{
		if(iClient == 0)
			PrintToServer("\x03[XPMod] \x01You must enter a valid client id.");
		else
			PrintToChat(iClient, "\x03[XPMod] \x01You must enter a valid client id.");
		return Plugin_Handled;
	}
	if(!IsClientInGame(target))
	{
		if(iClient == 0)
			PrintToServer("\x03[XPMod] \x01Client %d is not in game. You must enter a valid iClient id.", target);
		else
			PrintToChat(iClient, "\x03[XPMod] \x01Client %d is not in game. You must enter a valid iClient id.", target);
		return Plugin_Handled;
	}
	if (IsFakeClient(target) == true)
	{
		if(iClient == 0)
			PrintToServer("\x03[XPMod] \x01You cannot give experience to a bot.");
		else
			PrintToChat(iClient, "\x03[XPMod] \x01You cannot give experience to a bot.");
		return Plugin_Handled;
	}
	
	char xpstring[15];
	GetCmdArg(2, xpstring, sizeof(xpstring));
	
	int xpamount = StringToInt(xpstring);
	if(xpamount<0)
	{
		if(iClient == 0)
			PrintToServer("\x03[XPMod] \x01You must give a positive amount of XP.");
		else
			PrintToChat(iClient, "\x03[XPMod] \x01You must give a positive amount of XP.");
		return Plugin_Handled;
	}
	if(xpamount>99999999)
	{
		if(iClient == 0)
			PrintToServer("[XPMod] You cannot give more than 99999999 XP, clamping at 99999999 XP.");
		else
			PrintToChat(iClient, "\x03[XPMod] \x01You cannot give more than 99999999 XP, clamping at 99999999 XP.");
		g_iClientXP[target]=99999999;
		xpamount = 99999999;
	}
	else
		g_iClientXP[target]+=xpamount;
	
	if(g_iClientXP[target]>99999999)
		g_iClientXP[target]=99999999;
	
	if(iClient==0)
		PrintToServer("[XPMod] You gave %N %d XP.",target, xpamount);
	else
		PrintToChat(iClient,"\x03[XPMod] \x01You gave \x04%N \x05%d XP.",target, xpamount);
		
	if(iClient!=target)
		PrintToChat(target,"\x03[XPMod] \x01Admin \x04%N \x01gave you \x05%d XP.",iClient, xpamount);
	
	if(g_iClientXP[target] >= g_iClientNextLevelXPAmount[target] && g_iClientXP[target] <= LEVEL_30)
		LevelUpPlayer(target);
	
	CheckLevel(target);
	
	return Plugin_Handled;
}

Action GiveXP(int iClient, int args)
{
	/*if(iClient == 0)
	{
		PrintToServer("[XPMod] This cannot be done with through the server console");
		return Plugin_Handled;
	}*/
	if(args!=2)
	{
		if(iClient == 0)
			PrintToServer("[XPMod] Incorrect format. Example: givexp playername 999");
		else
			PrintToChat(iClient, "\x03[XPMod] \x01Incorrect format. Example: \x05!givexp playername 999");
		return Plugin_Handled;
	}
	
	char targetname[128];
	GetCmdArg(1, targetname, sizeof(targetname));

	int target = FindPlayerByName(iClient, targetname);
	if (target<1)
	{
		return Plugin_Handled;
	}
	
	char xpstring[15];
	GetCmdArg(2, xpstring, sizeof(xpstring));
	
	int xpamount = StringToInt(xpstring);
	if(xpamount<0)
	{
		if(iClient == 0)
			PrintToServer("\x03[XPMod] \x01You must give a positive amount of XP.");
		else
			PrintToChat(iClient, "\x03[XPMod] \x01You must give a positive amount of XP.");
		return Plugin_Handled;
	}
	if(xpamount>99999999)
	{
		if(iClient == 0)
			PrintToServer("[XPMod] You cannot give more than 99999999 XP, clamping at 99999999 XP.");
		else
			PrintToChat(iClient, "\x03[XPMod] \x01You cannot give more than 99999999 XP, clamping at 99999999 XP.");
		g_iClientXP[target]=99999999;
		xpamount = 99999999;
	}
	else
		g_iClientXP[target]+=xpamount;
	
	if(g_iClientXP[target]>99999999)
		g_iClientXP[target]=99999999;
	
	char clientname[128];
	if(iClient!=0)
		clientname = "Server Host";
	else
		GetClientName(iClient, clientname, sizeof(clientname));
	GetClientName(target, targetname, sizeof(targetname));
	
	if(iClient==0)
		PrintToServer("[XPMod] You gave %s %d XP.",targetname, xpamount);
	else
		PrintToChat(iClient,"\x03[XPMod] \x01You gave \x04%s \x05%d XP.",targetname, xpamount);
		
	if(iClient!=target)
		PrintToChat(target,"\x03[XPMod] \x01Admin \x04%s \x01gave you \x05%d XP.",clientname, xpamount);
	
	if(g_iClientXP[target] >= g_iClientNextLevelXPAmount[target] && g_iClientXP[target] <= LEVEL_30)
		LevelUpPlayer(target);
	
	CheckLevel(target);
	
	return Plugin_Handled;
}

//Resets XP, LVL, and Skillpoints, equipment and talents
void ResetAll(int iClient)
{
	g_bPlayerInTeamChangeCoolDown[iClient] = false;
	g_iClientXP[iClient] = 0;
	g_iClientLevel[iClient] = 0;
	g_iClientPrestigePoints[iClient] = 0;
	g_iInfectedLevel[iClient] = 0;
	g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_1 * XP_MULTIPLIER);
	//Equipment
	g_iClientPrimarySlotID[iClient] = 0;
	g_iClientLaserSlotID[iClient] = 0;
	g_iClientSecondarySlotID[iClient] = 0;
	g_iClientExplosiveSlotID[iClient] = 0;
	g_iClientHealthSlotID[iClient] = 0;
	g_iClientBoostSlotID[iClient] = 0;
	g_iClientPrimarySlotCost[iClient] = 0;
	g_iClientSecondarySlotCost[iClient] = 0;
	g_iClientExplosiveSlotCost[iClient] = 0;
	g_iClientHealthSlotCost[iClient] = 0;
	g_iClientBoostSlotCost[iClient] = 0;
	g_iClientLaserSlotCost[iClient] = 0;
	
	ResetAllOptions(iClient);
	ResetAllInfectedClasses(iClient); // Infected Talents
	ResetSurvivorTalents(iClient); // Survivors Talents

	if(RunClientChecks(iClient) && IsFakeClient(iClient) == false)
		PrintToChat(iClient,"\x03[XPMod]You have reset Level, XP, and Skill Points.", g_iClientXP[iClient]);
	
	return;
}

void ResetAllOptions(int iClient)
{
	g_iXPDisplayMode[iClient] = 0;
	g_bEnabledVGUI[iClient] = false;
	g_bAnnouncerOn[iClient] = true;
}


void ResetAllInfectedClasses(int iClient)
{

	//Infected Classes
	g_iClientInfectedClass1[iClient] = UNKNOWN_INFECTED;
	g_strClientInfectedClass1[iClient] = "None";
	g_iClientInfectedClass2[iClient] = UNKNOWN_INFECTED;
	g_strClientInfectedClass2[iClient] = "None";
	g_iClientInfectedClass3[iClient] = UNKNOWN_INFECTED;
	g_strClientInfectedClass3[iClient] = "None";
	//Smoker
	g_iSmokerTalent1Level[iClient] = 0;
	g_iSmokerTalent2Level[iClient] = 0;
	g_iSmokerTalent3Level[iClient] = 0;
	//Boomer
	g_iRapidLevel[iClient] = 0;
	g_iAcidicLevel[iClient] = 0;
	g_iNorovirusLevel[iClient] = 0;
	//Hunter
	g_iPredatorialLevel[iClient] = 0;
	g_iBloodLustLevel[iClient] = 0;
	g_iKillmeleonLevel[iClient] = 0;
	//Spitter
	g_iPuppetLevel[iClient] = 0;
	g_iMaterialLevel[iClient] = 0;
	g_iHallucinogenicLevel[iClient] = 0;
	//Jockey
	g_iMutatedLevel[iClient] = 0;
	g_iErraticLevel[iClient] = 0;
	g_iUnfairLevel[iClient] = 0;
	//Charger
	g_iGroundLevel[iClient] = 0;
	g_iSpikedLevel[iClient] = 0;
	g_iHillbillyLevel[iClient] = 0;
}

//Resets the skill points and talents that come with them
Action ResetSurvivorTalents(int iClient)
{
	if(IsClientInGame(iClient) == false)
		return Plugin_Handled;
	//reset all levels///////////////////////////////////////////////////////////////////////////////
	
	//Bill
	g_iInspirationalLevel[iClient] = 0;
	g_iGhillieLevel[iClient] = 0;
	g_iWillLevel[iClient] = 0;
	g_iDiehardLevel[iClient] = 0;
	g_iExorcismLevel[iClient] = 0;
	g_iPromotionalLevel[iClient] = 0;
	
	//Rochelle
	g_iGatherLevel[iClient] = 0;
	g_iHunterLevel[iClient] = 0;
	g_iSniperLevel[iClient] = 0;
	g_iSilentLevel[iClient] = 0;
	g_iSmokeLevel[iClient] = 0;
	g_iShadowLevel[iClient] = 0;
	
	//Coach
	g_iBullLevel[iClient] = 0;
	g_iWreckingLevel[iClient] = 0;
	g_iSprayLevel[iClient] = 0;
	g_iHomerunLevel[iClient] = 0;
	g_iLeadLevel[iClient] = 0;
	g_iStrongLevel[iClient] = 0;
	
	//Ellis
	g_iOverLevel[iClient] = 0;
	g_iBringLevel[iClient] = 0;
	g_iMetalLevel[iClient] = 0;
	g_iWeaponsLevel[iClient] = 0;
	g_iJamminLevel[iClient] = 0;
	g_iFireLevel[iClient] = 0;
	
	//Nick
	g_iSwindlerLevel[iClient] = 0;
	g_iLeftoverLevel[iClient] = 0;
	g_iMagnumLevel[iClient] = 0;
	g_iEnhancedLevel[iClient] = 0;
	g_iRiskyLevel[iClient] = 0;
	g_iDesperateLevel[iClient] = 0;

	//Louis
	g_iLouisTalent1Level[iClient] = 0;
	g_iLouisTalent2Level[iClient] = 0;
	g_iLouisTalent3Level[iClient] = 0;
	g_iLouisTalent4Level[iClient] = 0;
	g_iLouisTalent5Level[iClient] = 0;
	g_iLouisTalent6Level[iClient] = 0;
	
	//reset all abilities///////////////////////////////////////////////////////////////////////////
	//Turn off everything
	g_bUsingFireStorm[iClient] = false;
	g_bUsingShadowNinja[iClient] = false;
	g_bIsJetpackOn[iClient] = false;
	DisableNinjaRope(iClient, false);
	
	
	//For all talents
	if(g_bGameFrozen == false)
	{
		//Reset run speed
		SetEntDataFloat(iClient, FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0, true);	//Reset run speed
		//ghillie
		SetEntityRenderMode(iClient, RenderMode:0);		//Reset iClient tranparency
		SetEntityRenderColor(iClient, 255, 255, 255, 255);
	}
	SetEntProp(iClient, Prop_Send, "m_iGlowType", 0);
	SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
	SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 0);
	ChangeEdictState(iClient, 12);
	
	//Bill talents
	
	//Rochelle
	
	//Coach
	g_bIsJetpackOn[iClient] = false;
	
	//Ellis

	//Nick
	
	g_iSkillPoints[iClient] = g_iClientLevel[iClient];
	g_iInfectedLevel[iClient] = RoundToFloor(g_iClientLevel[iClient] * 0.5);
	//iskillpoints[iClient] = g_iInfectedLevel[iClient] * 3;

	
	//Delete all particles on the iClient
	DeleteAllClientParticles(iClient);
	
	return Plugin_Handled;
}

void LevelUpPlayer(int iClient)
{
	if(iClient > 0)
		if(IsClientInGame(iClient) == true)
		{
			int g_iClientOldLevel = g_iClientLevel[iClient];
			calclvlandnextxp(iClient);
			g_iSkillPoints[iClient] += (g_iClientLevel[iClient] - g_iClientOldLevel);
			
			if(g_iInfectedLevel[iClient] < RoundToFloor(g_iClientLevel[iClient] * 0.5))
			{
				//[iClient] += ((RoundToFloor(g_iClientLevel[iClient] * 0.5) - g_iInfectedLevel[iClient]) * 3);
				g_iInfectedLevel[iClient] += (RoundToFloor(g_iClientLevel[iClient] * 0.5) - g_iInfectedLevel[iClient]);
			}
			
			// Level up Surivivor Talents
			AutoLevelUpSurivovor(iClient);

			// Level Up Infected Talents
			SetInfectedClassSlot(iClient, 1, g_iClientInfectedClass1[iClient]);
			SetInfectedClassSlot(iClient, 2, g_iClientInfectedClass2[iClient]);
			SetInfectedClassSlot(iClient, 3, g_iClientInfectedClass3[iClient]);

			if (g_bClientLoggedIn[iClient])
			{
				// Print the level up message
				PrintHintText(iClient, "<-=-=-=-:[You have reached level %d]:-=-=-=->", g_iClientLevel[iClient]);
				PrintToChatAll("\x03[XPMod] %N is now level %d", iClient, g_iClientLevel[iClient]);
				// Play the level up sound
				float xyzClientLocation[3];
				GetClientAbsOrigin(iClient, xyzClientLocation);
				EmitAmbientSound(SOUND_LEVELUP, xyzClientLocation, iClient, SNDLEVEL_NORMAL);
				xyzClientLocation[2] += 22.0;
				WriteParticle(iClient, "mini_fireworks", 0.0, 10.0, xyzClientLocation);

				// Change their name if they are confirmed
				if (g_bTalentsConfirmed[iClient])
					RenamePlayerWithLevelTags(iClient);
			}
		}
}


void AutoLevelUpSurivovor(int iClient)
{
	//Set Survivor Class Levels
	switch(g_iChosenSurvivor[iClient])
	{
		case BILL: 		LevelUpAllBill(iClient);
		case ROCHELLE:	LevelUpAllRochelle(iClient);
		case COACH:		LevelUpAllCoach(iClient);
		case ELLIS:		LevelUpAllEllis(iClient);
		case NICK:		LevelUpAllNick(iClient);
		case LOUIS:		LevelUpAllLouis(iClient);
	}
}

void AutoLevelUpSurvivorTalents(int iClient, int[] talent1, int[] talent2, int[] talent3, int[] talent4, int[] talent5, int[] talent6)
{
	
	ResetSurvivorTalents(iClient);

	if(g_iSkillPoints[iClient] > 0)
	{
		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			talent1[iClient] += 5;
		}
		else
		{
			talent1[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}

		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			talent2[iClient] += 5;
		}
		else
		{
			talent2[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}

		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			talent3[iClient] += 5;
		}
		else
		{
			talent3[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}

		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			talent4[iClient] += 5;
		}
		else
		{
			talent4[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}

		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			talent5[iClient] += 5;
		}
		else
		{
			talent5[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}

		if(g_iSkillPoints[iClient] > 4)
		{
			g_iSkillPoints[iClient] -= 5;
			talent6[iClient] += 5;
		}
		else
		{
			talent6[iClient] += g_iSkillPoints[iClient];
			g_iSkillPoints[iClient] = 0;
		}
	}
}

void LevelUpAllBill(int iClient)
{
	if(g_iChosenSurvivor[iClient] != BILL)
		g_iChosenSurvivor[iClient] = BILL;

	AutoLevelUpSurvivorTalents( \
		iClient, \
		g_iInspirationalLevel, \
		g_iGhillieLevel, \
		g_iWillLevel, \
		g_iExorcismLevel, \
		g_iDiehardLevel, \
		g_iPromotionalLevel \
		);
}

void LevelUpAllRochelle(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ROCHELLE)
		g_iChosenSurvivor[iClient] = ROCHELLE;

	AutoLevelUpSurvivorTalents( \
		iClient, \
		g_iGatherLevel, \
		g_iHunterLevel, \
		g_iSniperLevel, \
		g_iSilentLevel, \
		g_iSmokeLevel, \
		g_iShadowLevel \
		);
}

void LevelUpAllCoach(int iClient)
{
	if (g_iChosenSurvivor[iClient] != COACH)
		g_iChosenSurvivor[iClient] = COACH;

	AutoLevelUpSurvivorTalents( \
		iClient, \
		g_iBullLevel, \
		g_iWreckingLevel, \
		g_iSprayLevel, \
		g_iHomerunLevel, \
		g_iLeadLevel, \
		g_iStrongLevel \
		);
}

void LevelUpAllEllis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != ELLIS)
		g_iChosenSurvivor[iClient] = ELLIS;

	AutoLevelUpSurvivorTalents( \
		iClient, \
		g_iOverLevel, \
		g_iBringLevel, \
		g_iJamminLevel, \
		g_iWeaponsLevel, \
		g_iMetalLevel, \
		g_iFireLevel \
		);
}

void LevelUpAllNick(int iClient)
{
	if (g_iChosenSurvivor[iClient] != NICK)
		g_iChosenSurvivor[iClient] = NICK;

	AutoLevelUpSurvivorTalents( \
		iClient, \
		g_iSwindlerLevel, \
		g_iLeftoverLevel, \
		g_iRiskyLevel, \
		g_iEnhancedLevel, \
		g_iMagnumLevel, \
		g_iDesperateLevel \
		);
}

void LevelUpAllLouis(int iClient)
{
	if (g_iChosenSurvivor[iClient] != LOUIS)
		g_iChosenSurvivor[iClient] = LOUIS;

	AutoLevelUpSurvivorTalents( \
		iClient, \
		g_iLouisTalent1Level, \
		g_iLouisTalent2Level, \
		g_iLouisTalent3Level, \
		g_iLouisTalent4Level, \
		g_iLouisTalent5Level, \
		g_iLouisTalent6Level \
		);
}

//Level Up Infected Talents
void LevelUpInfectedTalent(int iClient, int class)
{
	if(class == SMOKER)
	{
		if(g_iClientLevel[iClient] > 0 && g_iClientLevel[iClient] <= 10)
		{
			g_iSmokerTalent1Level[iClient] = g_iClientLevel[iClient];
		}
		else if(g_iClientLevel[iClient] > 10 && g_iClientLevel[iClient] <= 20)
		{
			g_iSmokerTalent1Level[iClient] = 10;
			g_iSmokerTalent2Level[iClient] = g_iClientLevel[iClient] - 10;
		}
		else if(g_iClientLevel[iClient] > 20)
		{
			g_iSmokerTalent1Level[iClient] = 10;
			g_iSmokerTalent2Level[iClient] = 10;
			g_iSmokerTalent3Level[iClient] = g_iClientLevel[iClient] - 20;
		}
	}
	else if(class == BOOMER)
	{
		if(g_iClientLevel[iClient] > 0 && g_iClientLevel[iClient] <= 10)
		{
			g_iRapidLevel[iClient] = g_iClientLevel[iClient];
		}
		else if(g_iClientLevel[iClient] > 10 && g_iClientLevel[iClient] <= 20)
		{
			g_iRapidLevel[iClient] = 10;
			g_iAcidicLevel[iClient] = g_iClientLevel[iClient] - 10;
		}
		else if(g_iClientLevel[iClient] > 20)
		{
			g_iRapidLevel[iClient] = 10;
			g_iAcidicLevel[iClient] = 10;
			g_iNorovirusLevel[iClient] = g_iClientLevel[iClient] - 20;
		}
	}
	else if(class == HUNTER)
	{
		if(g_iClientLevel[iClient] > 0 && g_iClientLevel[iClient] <= 10)
		{
			g_iPredatorialLevel[iClient] = g_iClientLevel[iClient];
		}
		else if(g_iClientLevel[iClient] > 10 && g_iClientLevel[iClient] <= 20)
		{
			g_iPredatorialLevel[iClient] = 10;
			g_iBloodLustLevel[iClient] = g_iClientLevel[iClient] - 10;
		}
		else if(g_iClientLevel[iClient] > 20)
		{
			g_iPredatorialLevel[iClient] = 10;
			g_iBloodLustLevel[iClient] = 10;
			g_iKillmeleonLevel[iClient] = g_iClientLevel[iClient] - 20;
		}
	}
	else if(class == SPITTER)
	{
		if(g_iClientLevel[iClient] > 0 && g_iClientLevel[iClient] <= 10)
		{
			g_iPuppetLevel[iClient] = g_iClientLevel[iClient];
		}
		else if(g_iClientLevel[iClient] > 10 && g_iClientLevel[iClient] <= 20)
		{
			g_iPuppetLevel[iClient] = 10;
			g_iMaterialLevel[iClient] = g_iClientLevel[iClient] - 10;
		}
		else if(g_iClientLevel[iClient] > 20)
		{
			g_iPuppetLevel[iClient] = 10;
			g_iMaterialLevel[iClient] = 10;
			g_iHallucinogenicLevel[iClient] = g_iClientLevel[iClient] - 20;
		}
	}
	else if(class == JOCKEY)
	{
		if(g_iClientLevel[iClient] > 0 && g_iClientLevel[iClient] <= 10)
		{
			g_iMutatedLevel[iClient] = g_iClientLevel[iClient];
		}
		else if(g_iClientLevel[iClient] > 10 && g_iClientLevel[iClient] <= 20)
		{
			g_iMutatedLevel[iClient] = 10;
			g_iErraticLevel[iClient] = g_iClientLevel[iClient] - 10;
		}
		else if(g_iClientLevel[iClient] > 20)
		{
			g_iMutatedLevel[iClient] = 10;
			g_iErraticLevel[iClient] = 10;
			g_iUnfairLevel[iClient] = g_iClientLevel[iClient] - 20;
		}
	}
	else if(class == CHARGER)
	{
		if(g_iClientLevel[iClient] > 0 && g_iClientLevel[iClient] <= 10)
		{
			g_iGroundLevel[iClient] = g_iClientLevel[iClient];
		}
		else if(g_iClientLevel[iClient] > 10 && g_iClientLevel[iClient] <= 20)
		{
			g_iGroundLevel[iClient] = 10;
			g_iSpikedLevel[iClient] = g_iClientLevel[iClient] - 10;
		}
		else if(g_iClientLevel[iClient] > 20)
		{
			g_iGroundLevel[iClient] = 10;
			g_iSpikedLevel[iClient] = 10;
			g_iHillbillyLevel[iClient] = g_iClientLevel[iClient] - 20;
		}
	}
}

//Level Up Infected Talents
void LevelDownInfectedTalent(int iClient, int class)
{
	if(class == SMOKER)
	{
		g_iSmokerTalent1Level[iClient] = 0;
		g_iSmokerTalent2Level[iClient] = 0;
		g_iSmokerTalent3Level[iClient] = 0;
	}
	else if(class == BOOMER)
	{
		g_iRapidLevel[iClient] = 0;
		g_iAcidicLevel[iClient] = 0;
		g_iNorovirusLevel[iClient] = 0;
	}
	else if(class == HUNTER)
	{
		g_iPredatorialLevel[iClient] = 0;
		g_iBloodLustLevel[iClient] = 0;
		g_iKillmeleonLevel[iClient] = 0;
	}
	else if(class == SPITTER)
	{
		g_iPuppetLevel[iClient] = 0;
		g_iMaterialLevel[iClient] = 0;
		g_iHallucinogenicLevel[iClient] = 0;
	}
	else if(class == JOCKEY)
	{
		g_iMutatedLevel[iClient] = 0;
		g_iErraticLevel[iClient] = 0;
		g_iUnfairLevel[iClient] = 0;
	}
	else if(class == CHARGER)
	{
		g_iGroundLevel[iClient] = 0;
		g_iSpikedLevel[iClient] = 0;
		g_iHillbillyLevel[iClient] = 0;
	}
}

void SetInfectedClassSlot(int iClient, int slotnum, int class)
{
	switch(slotnum)
	{
		case 1:	//Class 1
		{
			if(class == SMOKER)
			{
				g_iClientInfectedClass1[iClient] = SMOKER;
				g_strClientInfectedClass1[iClient] = "Smoker";
			}
			else if(class == BOOMER)
			{
				g_iClientInfectedClass1[iClient] = BOOMER;
				g_strClientInfectedClass1[iClient] = "Boomer";
			}
			else if(class == HUNTER)
			{
				g_iClientInfectedClass1[iClient] = HUNTER;
				g_strClientInfectedClass1[iClient] = "Hunter";
			}
			else if(class == SPITTER)
			{
				g_iClientInfectedClass1[iClient] = SPITTER;
				g_strClientInfectedClass1[iClient] = "Spitter";
			}
			else if(class == JOCKEY)
			{
				g_iClientInfectedClass1[iClient] = JOCKEY;
				g_strClientInfectedClass1[iClient] = "Jockey";
			}
			else if(class == CHARGER)
			{
				g_iClientInfectedClass1[iClient] = CHARGER;
				g_strClientInfectedClass1[iClient] = "Charger";
			}
			else if(class == TANK)
			{
				g_iClientInfectedClass1[iClient] = TANK;
				g_strClientInfectedClass1[iClient] = "Tank";
			}
		}
		case 2:	//Class 2
		{
			if(class == SMOKER)
			{
				g_iClientInfectedClass2[iClient] = SMOKER;
				g_strClientInfectedClass2[iClient] = "Smoker";
			}
			else if(class == BOOMER)
			{
				g_iClientInfectedClass2[iClient] = BOOMER;
				g_strClientInfectedClass2[iClient] = "Boomer";
			}
			else if(class == HUNTER)
			{
				g_iClientInfectedClass2[iClient] = HUNTER;
				g_strClientInfectedClass2[iClient] = "Hunter";
			}
			else if(class == SPITTER)
			{
				g_iClientInfectedClass2[iClient] = SPITTER;
				g_strClientInfectedClass2[iClient] = "Spitter";
			}
			else if(class == JOCKEY)
			{
				g_iClientInfectedClass2[iClient] = JOCKEY;
				g_strClientInfectedClass2[iClient] = "Jockey";
			}
			else if(class == CHARGER)
			{
				g_iClientInfectedClass2[iClient] = CHARGER;
				g_strClientInfectedClass2[iClient] = "Charger";
			}
			else if(class == TANK)
			{
				g_iClientInfectedClass2[iClient] = TANK;
				g_strClientInfectedClass2[iClient] = "Tank";
			}
		}
		case 3:	//Class 3
		{
			if(class == SMOKER)
			{
				g_iClientInfectedClass3[iClient] = SMOKER;
				g_strClientInfectedClass3[iClient] = "Smoker";
			}
			else if(class == BOOMER)
			{
				g_iClientInfectedClass3[iClient] = BOOMER;
				g_strClientInfectedClass3[iClient] = "Boomer";
			}
			else if(class == HUNTER)
			{
				g_iClientInfectedClass3[iClient] = HUNTER;
				g_strClientInfectedClass3[iClient] = "Hunter";
			}
			else if(class == SPITTER)
			{
				g_iClientInfectedClass3[iClient] = SPITTER;
				g_strClientInfectedClass3[iClient] = "Spitter";
			}
			else if(class == JOCKEY)
			{
				g_iClientInfectedClass3[iClient] = JOCKEY;
				g_strClientInfectedClass3[iClient] = "Jockey";
			}
			else if(class == CHARGER)
			{
				g_iClientInfectedClass3[iClient] = CHARGER;
				g_strClientInfectedClass3[iClient] = "Charger";
			}
			else if(class == TANK)
			{
				g_iClientInfectedClass3[iClient] = TANK;
				g_strClientInfectedClass3[iClient] = "Tank";
			}
		}
	}
	
	LevelUpInfectedTalent(iClient, class);
}

void calclvlandnextxp(int iClient)
{
	if(g_iClientXP[iClient] >= RoundToFloor(LEVEL_30 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 30;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_30 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_30 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_1 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 0;
		g_iClientPreviousLevelXPAmount[iClient] = 0;
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_1 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_2 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 1;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_1 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] =  RoundToFloor(LEVEL_2 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] <  RoundToFloor(LEVEL_3 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 2;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_2 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_3 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_4 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 3;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_3 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_4 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_5 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 4;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_4 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_5 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_6 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 5;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_5 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_6 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_7 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 6;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_6 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_7 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_8 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 7;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_7 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_8 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_9 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 8;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_8 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_9 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_10 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 9;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_9 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_10 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_11 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 10;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_10 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_11 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_12 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 11;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_11 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_12 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_13 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 12;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_12 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_13 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_14 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 13;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_13 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_14 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_15 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 14;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_14 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_15 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_16 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 15;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_15 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_16 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_17 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 16;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_16 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_17 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_18 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 17;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_17 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_18 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_19 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 18;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_18 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_19 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_20 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 19;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_19 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_20 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_21 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 20;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_20 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_21 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_22 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 21;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_21 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_22 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_23 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 22;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_22 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_23 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_24 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 23;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_23 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_24 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_25 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 24;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_24 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_25 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_26 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 25;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_25 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_26 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_27 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 26;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_26 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_27 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_28 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 27;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_27 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_28 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_29 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 28;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_28 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_29 * XP_MULTIPLIER);
	}
	else if(g_iClientXP[iClient] < RoundToFloor(LEVEL_30 * XP_MULTIPLIER))
	{
		g_iClientLevel[iClient] = 29;
		g_iClientPreviousLevelXPAmount[iClient] = RoundToFloor(LEVEL_29 * XP_MULTIPLIER);
		g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_30 * XP_MULTIPLIER);
	}
}

void ShowXPSprite(int iClient, int iXPSprite, int iEntity, float fLifeTime = 3.0)
{
	if(iClient < 1 || iEntity < 1 || IsClientInGame(iClient) == false || IsFakeClient(iClient) == true || IsValidEntity(iEntity) == false)
		return;
	
	float xyzEntityVector[3], xyzTopOffsetVector[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", xyzEntityVector);
	
	xyzEntityVector[2] += 75.0;
	xyzTopOffsetVector[0] = xyzEntityVector[0];
	xyzTopOffsetVector[1] = xyzEntityVector[1];
	xyzTopOffsetVector[2] = xyzEntityVector[2] + 30.0;
	
	//Raise the big sprites for the Special Infected
	if(iXPSprite == g_iSprite_25XP_SI || iXPSprite == g_iSprite_50XP_SI || iXPSprite == g_iSprite_200XP_SI || iXPSprite == g_iSprite_500XP_SI)
	{
		xyzEntityVector[2] += 12.0;
		xyzTopOffsetVector[2] += 12.0;
	}
	
	TE_SetupBeamPoints(xyzTopOffsetVector, xyzEntityVector, iXPSprite, 0, 0, 0, fLifeTime, 45.0, 45.0, 1, 0.0, {255, 255, 255, 255}, 0);
	TE_SendToClient(iClient);
}

void ChangeXPDisplayMode(int iClient)
{
	if(g_iXPDisplayMode[iClient] == 0)
		g_iXPDisplayMode[iClient] = 1;
	else if(g_iXPDisplayMode[iClient] == 1)
		g_iXPDisplayMode[iClient] = 2;
	else
		g_iXPDisplayMode[iClient] = 0;
}

void GiveRewards()
{
	for(int i = 1; i <= MaxClients; i++)
	{		
		if(RunClientChecks(i) == false || IsFakeClient(i) == true)
			continue;
		
		//Give Survivor Rewards
		if(g_iStat_ClientInfectedKilled[i] >= g_iReward_SIKills)
		{
			g_iReward_SIKills = g_iStat_ClientInfectedKilled[i];
			g_iReward_SIKillsID = i;
			GetClientName(i, g_strReward_SIKills, sizeof(g_strReward_SIKills));
		}
		if(g_iStat_ClientCommonKilled[i] >= g_iReward_CIKills)
		{
			g_iReward_CIKills = g_iStat_ClientCommonKilled[i];
			g_iReward_CIKillsID = i;
			GetClientName(i, g_strReward_CIKills, sizeof(g_strReward_CIKills));
		}
		if(g_iStat_ClientCommonHeadshots[i] >= g_iReward_HS)
		{
			g_iReward_HS = g_iStat_ClientCommonHeadshots[i];
			g_iReward_HSID = i;
			GetClientName(i, g_strReward_HS, sizeof(g_strReward_HS));
		}
		//Give Infected Rewards
		if(g_iStat_ClientSurvivorsKilled[i] >= g_iReward_SurKills)
		{
			g_iReward_SurKills = g_iStat_ClientSurvivorsKilled[i];
			g_iReward_SurKillsID = i;
			GetClientName(i, g_strReward_SurKills, sizeof(g_strReward_SurKills));
		}
		if(g_iStat_ClientSurvivorsIncaps[i] >= g_iReward_SurIncaps)
		{
			g_iReward_SurIncaps = g_iStat_ClientSurvivorsIncaps[i];
			g_iReward_SurIncapsID = i;
			GetClientName(i, g_strReward_SurIncaps, sizeof(g_strReward_SurIncaps));
		}
		if(g_iStat_ClientDamageToSurvivors[i] >= g_iReward_SurDmg)
		{
			g_iReward_SurDmg = g_iStat_ClientDamageToSurvivors[i];
			g_iReward_SurDmgID = i;
			GetClientName(i, g_strReward_SurDmg, sizeof(g_strReward_SurDmg));
		}
		
	}
	
	//Give reward XP
	if(g_iReward_SIKills > 0)
	{
		if(IsClientInGame(g_iReward_SIKillsID) == true)
			if(IsFakeClient(g_iReward_SIKillsID) == false)
				g_iClientXP[g_iReward_SIKillsID] += (20 * g_iReward_SIKills);
	}
	
	if(g_iReward_CIKillsID > 0)
	{
		if(IsClientInGame(g_iReward_CIKillsID) == true)
			if(IsFakeClient(g_iReward_CIKillsID) == false)
				g_iClientXP[g_iReward_CIKillsID] += (2 * g_iReward_CIKills);
	}
	
	if(g_iReward_HSID > 0)
	{
		if(IsClientInGame(g_iReward_HSID) == true)
			if(IsFakeClient(g_iReward_HSID) == false)
				g_iClientXP[g_iReward_HSID] += (10 * g_iReward_HS);
	}
	
	if(g_iReward_SurKillsID > 0)
	{
		if(IsClientInGame(g_iReward_SurKillsID) == true)
			if(IsFakeClient(g_iReward_SurKillsID) == false)
				g_iClientXP[g_iReward_SurKillsID] += (250 * g_iReward_SurKills);
	}
	
	if(g_iReward_SurIncapsID > 0)
	{
		if(IsClientInGame(g_iReward_SurIncapsID) == true)
			if(IsFakeClient(g_iReward_SurIncapsID) == false)
				g_iClientXP[g_iReward_SurIncapsID] += (100 * g_iReward_SurIncaps);
	}
	
	if(g_iReward_SurDmgID > 0)
	{
		if(IsClientInGame(g_iReward_SurDmgID) == true)
			if(IsFakeClient(g_iReward_SurDmgID) == false)
				g_iClientXP[g_iReward_SurDmgID] += g_iReward_SurDmg > 10000 ? 10000 : g_iReward_SurDmg;
	}
}
