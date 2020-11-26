
CheckLevel(iClient)
{
	if(g_iClientLevel[iClient] != 30 && g_iClientXP[iClient] >= g_iClientNextLevelXPAmount[iClient])
		LevelUpPlayer(iClient);
}

public Action:GiveXPbyID(iClient,args)
{
	if(args!=2)
	{
		if(iClient == 0)
			PrintToServer("[XPMod] Incorrect format. Example: givexpid 3 999");
		else
			PrintToChat(iClient, "\x03[XPMod] \x01Incorrect format. Example: \x05!givexpid 3 999");
		return Plugin_Handled;
	}
	
	decl String:targetnum[128];
	GetCmdArg(1, targetnum, sizeof(targetnum));

	decl target;
	target = StringToInt(targetnum);
	
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
	
	decl String:xpstring[15];
	GetCmdArg(2, xpstring, sizeof(xpstring));
	
	new xpamount;
	xpamount = StringToInt(xpstring);
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

public Action:GiveXP(iClient,args)
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
	
	decl String:targetname[128];
	GetCmdArg(1, targetname, sizeof(targetname));

	decl target;
	target = FindPlayerByName(iClient, targetname);
	if (target<1)
	{
		return Plugin_Handled;
	}
	
	decl String:xpstring[15];
	GetCmdArg(2, xpstring, sizeof(xpstring));
	
	new xpamount;
	xpamount = StringToInt(xpstring);
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
	
	decl String:clientname[128];
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

//Resets XP, LVL, and Skillpoints, equipment and talents				//Make admin commmand and this wont work if canchange != true so make it work independent of the reset skill points function
public Action:ResetAll(iClient,args)
{
	g_iClientXP[iClient] = 0;
	g_iClientLevel[iClient] = 0;
	g_iInfectedLevel[iClient] = 0;
	g_iClientNextLevelXPAmount[iClient] = RoundToFloor(LEVEL_1 * XP_MULTIPLIER);
	//Equipemnt
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
	ResetAllInfectedClasses(iClient);
	ResetSkillPoints(iClient, iClient); //Call function that resets talent levels and talents
	if(IsClientInGame(iClient))
		if(IsFakeClient(iClient) == false)
			PrintToChat(iClient,"\x03[XPMod]You have reset Level, XP, and Skill Points.",g_iClientXP[iClient]);
	return Plugin_Handled;
}

ResetAllOptions(iClient)
{
	g_iXPDisplayMode[iClient] = 0;
	g_bEnabledVGUI[iClient] = false;
	g_bAnnouncerOn[iClient] = true;
}


public ResetAllInfectedClasses(iClient)
{
	//Infected Classes
	g_iClientInfectedClass1[iClient] = UNKNOWN_INFECTED;
	g_strClientInfectedClass1[iClient] = "None";
	g_iClientInfectedClass2[iClient] = UNKNOWN_INFECTED;
	g_strClientInfectedClass2[iClient] = "None";
	g_iClientInfectedClass3[iClient] = UNKNOWN_INFECTED;
	g_strClientInfectedClass3[iClient] = "None";
	//Smoker
	g_iEnvelopmentLevel[iClient] = 0;
	g_iNoxiousLevel[iClient] = 0;
	g_iDirtyLevel[iClient] = 0;
	//Boomer
	g_iRapidLevel[iClient] = 0;
	g_iAcidicLevel[iClient] = 0;
	g_iNorovirusLevel[iClient] = 0;
	//Hunter
	g_iPredatorialLevel[iClient] = 0;
	g_iBloodlustLevel[iClient] = 0;
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
public Action:ResetSkillPoints(iClient,args)
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
	
	//reset all abilities///////////////////////////////////////////////////////////////////////////
	//Turn of everything
	g_bUsingFireStorm[iClient] = false;
	g_bUsingShadowNinja[iClient] = false;
	g_bIsJetpackOn[iClient] = false;
	g_bUsingTongueRope[iClient] = false;
	
	
	//For all talents
	if(g_bGameFrozen == false)
	{
		//Reset run speed
		SetEntDataFloat(iClient, FindSendPropOffs("CTerrorPlayer","m_flLaggedMovementValue"), 1.0, true);	//Reset run speed
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
	//metal(mechanic affinity)
	pop(iClient, 1);
	if(g_iFastAttackingClientsArray[0]==-1)
		g_bSomeoneAttacksFaster = false;
	//Nick
	
	g_iSkillPoints[iClient] = g_iClientLevel[iClient];
	g_iInfectedLevel[iClient] = RoundToFloor(g_iClientLevel[iClient] * 0.5);
	//iskillpoints[iClient] = g_iInfectedLevel[iClient] * 3;
	if(IsFakeClient(iClient) == false)
		PrintToChat(iClient,"\x0r[XPMod] All of your chosen skill points have been reset.",g_iClientXP[iClient]);
	
	//Delete all particles on the iClient
	DeleteAllClientParticles(iClient);
	
	return Plugin_Handled;
}

LevelUpPlayer(iClient)
{
	if(iClient > 0)
		if(IsClientInGame(iClient) == true)
		{
			new g_iClientOldLevel = g_iClientLevel[iClient];
			calclvlandnextxp(iClient);
			g_iSkillPoints[iClient] += (g_iClientLevel[iClient] - g_iClientOldLevel);
			
			if(g_iInfectedLevel[iClient] < RoundToFloor(g_iClientLevel[iClient] * 0.5))
			{
				//iskillpoints[iClient] += ((RoundToFloor(g_iClientLevel[iClient] * 0.5) - g_iInfectedLevel[iClient]) * 3);
				g_iInfectedLevel[iClient] += (RoundToFloor(g_iClientLevel[iClient] * 0.5) - g_iInfectedLevel[iClient]);
			}
			
			//Level Up Infected Talents
			SetInfectedClassSlot(iClient, 1, g_iClientInfectedClass1[iClient]);
			SetInfectedClassSlot(iClient, 2, g_iClientInfectedClass2[iClient]);
			SetInfectedClassSlot(iClient, 3, g_iClientInfectedClass3[iClient]);
			//Print the message
			g_iClientLevel[iClient] = g_iClientLevel[iClient];
			//PrintHintText(iClient, "You have leveled up!");
			//decl String:string[256];
			//FormatEx(string, sizeof(string), "<-=-=-=-:[You have reached level %d]:-=-=-=->", g_iClientLevel[iClient]);
			PrintHintText(iClient, "<-=-=-=-:[You have reached level %d]:-=-=-=->", g_iClientLevel[iClient]);
			//PrintInstructorText(iClient, string, "255 0 0", "ATTACH_NONE");
			PrintToChatAll("\x03[XPMod] %N is now level %d", iClient, g_iClientLevel[iClient]);
			decl Float:vec[3];
			GetClientAbsOrigin(iClient, vec);
			EmitAmbientSound(SOUND_LEVELUP, vec, iClient, SNDLEVEL_NORMAL);
		}
}

//Level Up Infected Talents
public LevelUpInfectedTalent(iClient, class)
{
	if(class == SMOKER)
	{
		if(g_iClientLevel[iClient] > 0 && g_iClientLevel[iClient] <= 10)
		{
			g_iEnvelopmentLevel[iClient] = g_iClientLevel[iClient];
		}
		else if(g_iClientLevel[iClient] > 10 && g_iClientLevel[iClient] <= 20)
		{
			g_iEnvelopmentLevel[iClient] = 10;
			g_iNoxiousLevel[iClient] = g_iClientLevel[iClient] - 10;
		}
		else if(g_iClientLevel[iClient] > 20)
		{
			g_iEnvelopmentLevel[iClient] = 10;
			g_iNoxiousLevel[iClient] = 10;
			g_iDirtyLevel[iClient] = g_iClientLevel[iClient] - 20;
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
			g_iBloodlustLevel[iClient] = g_iClientLevel[iClient] - 10;
		}
		else if(g_iClientLevel[iClient] > 20)
		{
			g_iPredatorialLevel[iClient] = 10;
			g_iBloodlustLevel[iClient] = 10;
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
public LevelDownInfectedTalent(iClient, class)
{
	if(class == SMOKER)
	{
		g_iEnvelopmentLevel[iClient] = 0;
		g_iNoxiousLevel[iClient] = 0;
		g_iDirtyLevel[iClient] = 0;
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
		g_iBloodlustLevel[iClient] = 0;
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

public SetInfectedClassSlot(iClient, slotnum, class)
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

calclvlandnextxp(iClient)
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

ShowXPSprite(iClient, iXPSprite, iEntity, Float:fLifeTime = 3.0)
{
	if(iClient < 1 || iEntity < 1 || IsClientInGame(iClient) == false || IsFakeClient(iClient) == true || IsValidEntity(iEntity) == false)
		return;
	
	decl Float:xyzEntityVector[3], Float:xyzTopOffsetVector[3];
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

ChangeXPDisplayMode(iClient)
{
	if(g_iXPDisplayMode[iClient] == 0)
		g_iXPDisplayMode[iClient] = 1;
	else if(g_iXPDisplayMode[iClient] == 1)
		g_iXPDisplayMode[iClient] = 2;
	else
		g_iXPDisplayMode[iClient] = 0;
}

GiveRewards()
{
	decl i;
	for(i = 1; i <= MaxClients; i++)
	{
		g_bTalentsConfirmed[i] = false;				//I don't know why these are here, check if needed
		g_bUserStoppedConfirmation[i] = false;
		
		if(IsClientInGame(i) == false)
			continue;
		
		if(IsFakeClient(i) == true)
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
				g_iClientXP[g_iReward_SurDmgID] += g_iReward_SurDmg;
	}
}