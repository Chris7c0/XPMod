void ResetAllVariablesForRound()
{
	//Reset Variables
	for (int i = 1; i <= MaxClients; i++)
	{
		CheckLevel(i);
		
		//Reset all the client variables to their initial state
		ResetClientVariablesForRound(i);
		DeleteAllMenuParticles(i);
		
		//Sets voice comns back to default setting
		if(IsClientInGame(i) == true)
		{
			for (int other = 1; other <= MaxClients; other++)
			{
				if(IsClientInGame(other) == true && IsFakeClient(other) == false)
					SetListenOverride(i, other, Listen_Default);
			}
		}
	}
		
	
	//Reset CVars and XPMod Variables for the round
	//SetConVarInt(FindConVar("z_frustration"), 0);
	SetConVarInt(FindConVar("z_frustration_lifetime"), TANK_FRUSTRATION_TIME_IN_SECONDS);
	SetConVarInt(FindConVar("z_common_limit"), 30);
	g_iScreenShakeAmount = SCREEN_SHAKE_AMOUNT_DEFAULT;
	SetSurvivorScreenShakeAmount();
	SetConVarInt(FindConVar("sv_disable_glow_survivors"), 0);
	SetConVarInt(FindConVar("chainsaw_attack_force"), 400);
	SetConVarInt(FindConVar("chainsaw_damage"), 100);
	SetConVarFloat(FindConVar("chainsaw_hit_interval"), 0.1, false, false);
	SetConVarInt(FindConVar("survivor_crawl_speed"), 15,false,false);
	SetConVarInt(FindConVar("survivor_allow_crawling"),0,false,false);
	SetConVarFloat(FindConVar("z_vomit_fatigue"),0.0,false,false);	//So players can move on vomit
	//////////////////////////////////////////////////////////////////////////////////////////////////////SetConVarFloat(FindConVar("z_spit_fatigue"),0.0,false,false);	//So players can move on spit
	SetConVarInt(FindConVar("first_aid_kit_max_heal"), 999);		//So everyone can heal to their max using medkit
	SetConVarFloat(FindConVar("first_aid_heal_percent"),0.0,false,false);	//So it doesnt heal at all (this is handled in the heal success event)
	SetConVarInt(FindConVar("pain_pills_health_threshold"), 999);	//So everyone can use pain pills above 99 health
	SetConVarInt(FindConVar("sb_stop"), 1);				//So the bots dont run off before unfrozen
	SetConVarFloat(FindConVar("upgrade_laser_sight_spread_factor"), 0.4);
	// Louis's Bind2 abilities reset to the default values
	SetConVarInt(FindConVar("survivor_revive_duration"), 5);
	SetConVarInt(FindConVar("first_aid_kit_use_duration"), 5);
	SetConVarInt(FindConVar("defibrillator_use_duration"), 3);
	g_bCommonInfectedDoMoreDamage = false;
	g_bNickAlreadyGivenMoreBind2s = false;
	g_iNickResurrectUses = 0;
	g_bNickGambedSelfReviveUses = 0;
	g_bNickGambedDivineInterventionUses = 0;
	g_iHighestLeadLevel = 0;
	g_iCoachTeamHealthStack = 0;
	g_iCrawlSpeedMultiplier = 0;
	g_iNickDesperateMeasuresStack = 0;
	g_fMaxLaserAccuracy = 0.4;
	// g_bSomeoneAttacksFaster = false;
}

void ResetClientVariablesForRound(int iClient)
{
	ResetAllEntityVariablesForRound();
	ResetTalentConfirmCountdown(iClient);
	g_iFastAttackingCurrentWeaponID[iClient] = -1;
	g_iFastAttackingCurrentItemIndex[iClient] = ITEM_EMPTY;
	g_bWalkAndUseToggler[iClient] = false;
	g_bSurvivorTalentsGivenThisRound[iClient] = false;
	g_bPlayerInTeamChangeCoolDown[iClient] = false;
	g_fTimeStamp[iClient] = -1.0;
	g_bMovementLocked[iClient] = false;
	g_bStopAllInput[iClient] = false;
	g_iClientBindUses_1[iClient] = 0;
	g_iClientBindUses_2[iClient] = 0;
	g_bBind1InCooldown[iClient] = false;
	g_bBind2InCooldown[iClient] = false;
	g_iEllisSpeedBoostCounter[iClient] = 0;
	g_bIsFlyingWithJetpack[iClient] = false;
	g_iClientJetpackFuel[iClient] = 0;
	g_bIsJetpackOn[iClient] = false;
	g_iCoachDecapitationCounter[iClient] = 0;
	g_iMeleeDamageCounter[iClient] = 0;
	g_bIsHighJumpCharged[iClient] = false;
	g_bIsWreckingBallCharged[iClient] = false;
	g_iExtraExplosiveUses[iClient] = 0;
	g_iBillSprintChargeCounter[iClient] = 0;
	g_bBillSprinting[iClient] = false;
	g_bBillTaunting[iClient] = false;
	g_iBillTauntDuration[iClient] = 0;
	g_iSilentSorrowHeadshotCounter[iClient] = 0;
	g_iRochelleAWPChargeLevel[iClient] = 0;
	g_bRochelleAWPCharged[iClient] = false;
	g_bUsingFireStorm[iClient] = false;
	g_bUsingShadowNinja[iClient] = false;
	g_iStat_ClientInfectedKilled[iClient] = 0;
	g_iStat_ClientCommonKilled[iClient] = 0;
	g_iStat_ClientCommonHeadshots[iClient] = 0;
	g_iStat_ClientSurvivorsKilled[iClient] = 0;
	g_iStat_ClientSurvivorsIncaps[iClient] = 0;
	g_iStat_ClientDamageToSurvivors[iClient] = 0;
	g_bCanPlayHeadshotSound[iClient] = true;
	g_bUsingTongueRope[iClient]=false;
	g_iRochelleRopeDurability[iClient] = ROCHELLE_ROPE_MAX_DURABILITY;
	g_iRochelleRugerHitCounter[iClient] = 0;
	g_iRochelleRugerStacks[iClient] = 0;
	g_iRochelleRugerLastHitStackCount[iClient] = 0;
	g_iRochelleRopeDummyEntityAttachmentHand[iClient] = 0;
	g_iRochelleRopeDummyEntityAttachmentWall[iClient] = 0;
	canchangemovement[iClient]=true;
	g_bIsMovementTypeFly[iClient] = false;
	preledgehealth[iClient] = 1;
	g_bIsClientDown[iClient] = false;
	clienthanging[iClient] = false;
	g_iKitsUsed = 0;
	g_iBillTeamHealCounter[iClient] = 0;
	g_iBillsTeamHealthPool = BILL_TEAM_HEAL_HP_POOL;
	g_iBillGlobalTauntCooldown = 0;
	g_iNicksRamboWeaponID[iClient] = 0;
	g_bNickIsInvisible[iClient] = false;
	g_bCanDropPoopBomb[iClient] = true;
	g_bIsFrustratedTank[iClient] = false;
	g_bTankTakeOverBot[iClient] = false;
	g_bTankHealthJustSet[iClient] = false;
	g_fFrustratedTankTransferHealthPercentage = 0.0;
	g_bTankOnFire[iClient] = false;
	g_bShowingVGUI[iClient] = false;
	g_bExplosivesJustGiven[iClient] = false;
	g_iLaserUpgradeCounter[iClient] = 0;
	// Victim Health Meter
	g_bVictimHealthMeterActive[iClient] = false;
	g_iVictimHealthMeterWatchVictim[iClient] =  0;
	// Self Revives
	g_iSelfRevives[iClient] = 0;
	g_bSelfReviving[iClient] = false;
	g_fSelfRevivingFinishTime[iClient] = -1.0;
	// Bile Cleansing Kits
	g_iBileCleansingKits[iClient] = 0;
	g_iBileCleansingFrameTimeCtr[iClient] = -1;
	// Give a Weapon Pile Cooldown
	g_bGiveAlotOfWeaponsOnCooldown = false;

	// Scripting variables
	g_fGameTimeOfLastGoalSet[iClient] =  -9999.0
	g_fGameTimeOfLastDamageTaken[iClient] = -9999.0;
	g_fGameTimeOfLastViableTargetSeen[iClient] = -9999.0;
	g_bBotXPMGoalAccomplished[iClient] = true;
	g_iBotXPMGoalTarget[iClient] = -1;
	g_xyzBotXPMGoalLocation[iClient][0] = EMPTY_VECTOR[0];
	g_xyzBotXPMGoalLocation[iClient][1] = EMPTY_VECTOR[1];
	g_xyzBotXPMGoalLocation[iClient][2] = EMPTY_VECTOR[2];

	// Unhook all of the OnTakeDamage in case there
	// were any left over from the last map
	UnhookAllOnTakeDamage();

	g_iInfectedCharacter[iClient] = UNKNOWN_INFECTED;
	RemoveAllEntitiesFromArrayList(g_listEnhancedCIEntities);
	g_bCanBeGhost[iClient] = true;
	g_bIsGhost[iClient] = false;
	
	g_iTankCounter = 0;
	g_fFrustratedTankTransferHealthPercentage = 0.0;
	g_bTankStartingHealthXPModSpawn = false;
	g_fTankStartingHealthMultiplier[iClient] = 1.0;
	RemoveAllEntitiesFromArrayList(g_listTankRockEntities);
	
	
	// g_bSomeoneAttacksFaster = false;
	
	//Bill
	gClone[iClient] = -1;
	
	//Rochelle
	g_bIsRochellePoisoned[iClient] = false;
	
	//Coach
	g_bCoachRageIsActive[iClient] = false;
	g_iCoachRageMeleeDamage[iClient] = 0;
	g_bCoachRageIsAvailable[iClient] = true;
	g_bCoachRageIsInCooldown[iClient] = false;
	g_bShowingChargeHealParticle[iClient] = false;
	g_bCoachInCISpeed[iClient] = false;
	g_bCoachInSISpeed[iClient] = false;
	g_iCoachCIHeadshotCounter[iClient] = 0;
	g_iCoachSIHeadshotCounter[iClient] = 0;

	
	//Ellis
	g_bWalkAndUseToggler[iClient] = false;
	g_fEllisBringSpeed[iClient] = 0.0;
	g_fEllisOverSpeed[iClient] = 0.0;
	g_fEllisJamminSpeed[iClient] = 0.0;
	g_bEllisOverSpeedIncreased[iClient] = false;
	g_iEllisAdrenalineStackDuration = 15;
	g_bEllisHasAdrenalineBuffs[iClient] = false;
	g_iStashedInventoryAdrenaline[iClient] = 0;
	g_iStashedInventoryMolotov[iClient] = 0;
	g_bGrenadeSlotWasEmptyOnLastPickUp[iClient] = false;
	g_iTempHealthBeforeUsingHealthBoostSlotItem[iClient] = 0;
	g_bIsEllisLimitBreaking[iClient] = false;
	g_bCanEllisLimitBreak[iClient] = false;
	g_iLimitBreakWeaponIndex[iClient] = -1;
	
	//Nick
	g_bNickIsGettingBeatenUp[iClient] = false;
	g_bDivineInterventionQueued[iClient] = false;
	g_iNickDesperateMeasuresStack = 0;
	g_iRamboWeaponID[iClient] = -1;
	g_iNickPistolSwaps[iClient] = 0;
	g_bNickGambleLockedBinds[iClient] = false;
	g_bNickReviveCooldown = false;
	g_bNickHealCooldown = false;

	//Louis
	g_bLouisLaserModeActivated[iClient] = true;
	g_bLouisLaserModeToggleCooldown[iClient] = false;
	g_bLouisTeleportCoolingDown[iClient] = false;
	g_bLouisTeleportActive[iClient] = false;
	g_iLouisTeleportChargeUses[iClient] = 0;
	g_iLouisCIHeadshotCounter[iClient] = 0;
	g_iLouisSIHeadshotCounter[iClient] = 0;
	g_iStashedInventoryPills[iClient] = 0;
	g_iPillsUsedStack[iClient] = 0;
	g_bHealthBoostItemJustGivenByCheats[iClient] = false;
	g_bHealthBoostSlotWasEmptyOnLastPickUp[iClient] = false;
	g_bGrenadeItemJustGivenByCheats[iClient] = false;
	g_bWareStationActive[iClient] = false;
	for (int i = 1;i <= MaxClients;i++)
		g_bWareStationClientAlreadyServiced[iClient][i] = false;
	g_iWareStationOwnerIDOfCurrentlyViewedStation[iClient] = -1;
	g_xyzWarezStationLocation[iClient][0] = EMPTY_VECTOR[0];
	g_xyzWarezStationLocation[iClient][1] = EMPTY_VECTOR[1];
	g_xyzWarezStationLocation[iClient][2] = EMPTY_VECTOR[2];
	g_fWarezStationSpeedBoost[iClient] = 0.0;
	g_fLouisXMRWallet[iClient] = 0.0;
	g_bLouisSpeedHaxEnabled = false;
	g_bSpeedHaxInCooldown = false;
	g_bLouisMedHaxEnabled = false;
	g_bIsPLayerHacked[iClient] = false;
	g_bHackTheServerEnabled = false;
	g_bHackTheServerInCooldown = false;
	g_bTimeOutInCooldown =  false;
	g_bNoobWipeCooldown = false;
	g_bInfectedBindsDisabled = false;
	
	//Infected Talents
	g_iInfectedConvarsSet[iClient] = false;
	
	//Smoker
	g_iChokingVictim[iClient] = -1;
	SetMoveTypeBackToNormalOnNextGameFrame[iClient] = false;
	g_bHasSmokersPoisonCloudOut[iClient] = false;
	g_bIsElectrocuting[iClient] = false;
	// g_bIsTarFingerVictim[iClient] = false;
	g_iSmokerInfectionCloudEntity[iClient] = -1;
	g_bSmokerSmokeScreenOnCooldown[iClient] = false;
	g_bTeleportCoolingDown[iClient] = false;
	g_iSmokerTransparency[iClient] = 0;
	g_bSmokerIsCloaked[iClient] = false;
	g_bSmokerVictimGlowDisabled[iClient] = false;
	g_iSmokerDoppelgangerCount[iClient] =  SMOKER_DOPPELGANGER_MAX_CLONES;
	g_bSmokerDoppelgangerCoolingDown[iClient] =  false;
	g_bElectrocutionCooldown[iClient] = false;
	g_bIsEntangledInSmokerTongue[iClient] = false;
	g_iEntangledSurvivorModelIndex[iClient] = -1;
	g_iEntangledTongueModelIndex[iClient] = -1;
	g_iSmokerSmokeCloudPlayer = -1;
	g_iSmokerInSmokeCloudLimbo = -1;
	g_bSmokerSmokeCloudInCooldown = false;
	g_bSmokerSmokeCloudRoundStartWaiting = true;
	g_bSmokeCloudVictimCanCISpawnOn[iClient] = true;
	g_iTarFingerVictimBlindAmount[iClient] = 0;
	SetSmokerConvarBuffs();
	g_bBlockBotFromShooting[iClient] = false;
	
	//Boomer
	g_bIsBoomerVomiting[iClient] = false;
	g_iVomitVictimAttacker[iClient] = 0;
	g_bIsServingHotMeal[iClient] = false;
	g_iVomitVictimCounter[iClient] = 0;
	g_iShowSurvivorVomitCounter[iClient] = 0;
	g_bIsSuicideBoomer[iClient] = false;
	g_bIsSuicideJumping[iClient] = false;
	g_bIsSurvivorVomiting[iClient] = false;
	g_bIsSuperSpeedBoomer[iClient] = false;

	//Hunter
	g_bHunterIsLunging[iClient] = false;
	g_iHunterLungeState[iClient] = HUNTER_LUNGE_STATE_NONE;
	g_bHunterLungeEndDelayCheck[iClient] = false;
	g_iBloodLustStage[iClient] = 0;
	g_bIsCloakedHunter[iClient] = false;
	g_bCanHunterDismount[iClient] = true;
	g_bHunterPounceMessageVisible[iClient] = false;
	g_bHunterInPounceLandCooldown[iClient] = false;
	g_bCanHunterPoisonVictim[iClient] = true;
	g_iHunterShreddingVictim[iClient] = -1;
	g_iHunterPounceDamageCharge[iClient] = 0;
	g_bIsHunterReadyToPoison[iClient] = false;
	g_bIsHunterPoisoned[iClient] = false;
	g_bIsInImmobilityZone[iClient] = false;
	g_bIsImmobilityZoneOnGlobalCooldown = false;
	
	//Jockey
	g_bCanJockeyPee[iClient] = true;
	g_bJockeyPissVictim[iClient] = false;
	g_bCanJockeyCloak[iClient] = true;
	g_bJockeyIsRiding[iClient] = false;
	g_iJockeyVictim[iClient] = -1;
	g_bCanJockeyJump[iClient] = false;
	g_fJockeyRideSpeed[iClient] = 1.0;
	g_fJockeyRideSpeedVanishingActBoost[iClient] = 0.0;
	
	//Spitter
	g_bAdhesiveGooActive[iClient] = false;
	g_bBlockGooSwitching[iClient] = false;
	g_bJustSpawnedWitch[iClient] = false;
	g_bCanConjureWitch[iClient] = true;
	g_bHasDemiGravity[iClient] = false;
	g_bIsHallucinating[iClient] = false;
	g_iViralInfector[iClient] = 0;
	g_bIsImmuneToVirus[iClient] = false;
	g_iBagOfSpitsSelectedSpit[iClient] = BAG_OF_SPITS_NONE;
	g_bCanBePushedByRepulsion[iClient] = true;
	g_bIsStealthSpitter[iClient] = false;
	g_iStealthSpitterChargePower[iClient] =  0;
	g_iStealthSpitterChargeMana[iClient] =  0;
	g_xyzWitchConjureLocation[iClient][0] = 0.0;
	g_xyzWitchConjureLocation[iClient][1] = 0.0;
	g_xyzWitchConjureLocation[iClient][2] = 0.0;
	g_fAdhesiveAffectAmount[iClient] = 0.0;
	
	//Charger
	g_bCanChargerSuperCharge[iClient] = true;
	g_bIsSpikedCharged[iClient] = false;
	g_bCanChargerSpikedCharge[iClient] = true;
	g_bIsChargerCharging[iClient] = false;
	g_bIsHillbillyEarthquakeReady[iClient] = false;
	g_bIsSuperCharger[iClient] = false;
	g_bChargerCarrying[iClient] = false;
	g_bIsChargerHealing[iClient] = false;
	g_bCanChargerEarthquake[iClient] = true;
	
	//Tank
	g_fFireTankExtraSpeed[iClient] = 0.0;
	//g_bFireTankBaseSpeedIncreased[iClient] = false;
	
	ResetAllVariables(iClient);
	//Delete all the global timer handles at the end of the round
	DeleteAllGlobalTimerHandles(iClient);
	
	for (int j = 1;j <= MaxClients;j++)
		g_bNickIsStealingLife[iClient][j] = false;
}

void ResetAllVariables(int iClient)
{
	g_iBanDurationInMinutes[iClient] = 0;
	
	g_bUsingFireStorm[iClient] = false;
	g_bUsingTongueRope[iClient] = false;
	clienthanging[iClient] = false;
	g_bIsJetpackOn[iClient] = false;
	g_bIsFlyingWithJetpack[iClient] = false;
	g_bIsHighJumpCharged[iClient] = false;
	g_bIsWreckingBallCharged[iClient] = false;
	g_bIsMovementTypeFly[iClient] = false;
	g_iNicksRamboWeaponID[iClient] = 0;
	g_bUsingShadowNinja[iClient] = false;
	g_bBillSprinting[iClient] = false;
	g_bBillTaunting[iClient] = false;
	g_iBillTauntDuration[iClient] = 0;
	g_iBillTeamHealCounter[iClient] = 0;
	g_bIsClientDown[iClient] = false;
	
	if (g_iSmokerSmokeCloudPlayer == iClient || g_iSmokerInSmokeCloudLimbo == iClient)
	{
		g_iSmokerSmokeCloudPlayer = -1;
		g_iSmokerInSmokeCloudLimbo = -1;
	}

	//Grapples
	g_bHunterGrappled[iClient] = false;
	g_iHunterShreddingVictim[iClient] = -1;
	g_bChargerGrappled[iClient] = false;
	g_iChargerVictim[iClient] = 0;
	g_bSmokerGrappled[iClient] = false;
	g_iChokingVictim[iClient] = -1;
	g_bJockeyGrappled[iClient] = false;
	g_iJockeyVictim[iClient] = -1;

	//Reset the stashed weapons
	g_bIsEllisWeaponCycling[iClient] = false;
	g_bSetWeaponAmmoOnNextGameFrame[iClient] = false;
	fnc_ClearAllWeaponData(iClient);

	//Reset Tank (Needed here for changing teams)
	g_iTankChosen[iClient] = TANK_NOT_CHOSEN;
	ResetAllTankVariables(iClient);
}

void ResetAllEntityVariablesForRound()
{

	for (int iEntity=0; iEntity <= MAXENTITIES; iEntity++)
	{
		g_iXPModEntityType[iEntity] = XPMOD_ENTITY_TYPE_NONE;
		g_fXPModEntityHealth[iEntity] = -1.0;
		g_iPoopBombOwnerID[iEntity] = 0;
	}
}

void Event_DeathResetAllVariables(int iAttacker, int iVictim)
{
	g_bIsClientDown[iVictim] = false;
	clienthanging[iVictim] = false;

	if(g_bEnabledVGUI[iVictim] == true && g_bShowingVGUI[iVictim] == true)
		DeleteAllMenuParticles(iVictim);

	// Infected //////////////////////////////////////////////////////////////////////////

	// We now do not know which infected they have, because they dead
	// These need to take place in this order, set UNKNOWN, then set CanBeGhost
	g_iInfectedCharacter[iVictim] = UNKNOWN_INFECTED;
	// For checking if the player is a ghost
	g_bCanBeGhost[iVictim] = true;
	g_bIsGhost[iVictim] = false;

	g_bIsBoomerVomiting[iVictim] = false;
	g_bIsSuicideBoomer[iVictim] = false;
	g_bIsSuicideJumping[iVictim] = false;
	g_bHasInfectedHealthBeenSet[iVictim] = false;
	g_bIsHillbillyEarthquakeReady[iVictim] = false;
	g_iBagOfSpitsSelectedSpit[iVictim] = BAG_OF_SPITS_NONE;

	g_bHunterIsLunging[iVictim] = false;
	g_iHunterLungeState[iVictim] = HUNTER_LUNGE_STATE_NONE;
	g_bHunterLungeEndDelayCheck[iVictim] = false;
	if(g_iHunterShreddingVictim[iVictim] > 0)
		SetClientSpeed(g_iHunterShreddingVictim[iVictim]);
	
	//Tank
	ResetAllTankVariables(iVictim);

	//Grapples
	g_bHunterGrappled[iVictim] = false;
	g_bHunterGrappled[iAttacker] = false;		//Need to do it for both of them
	g_iHunterShreddingVictim[iVictim] = -1;
	g_iHunterShreddingVictim[iAttacker] = -1;
	
	g_bChargerGrappled[g_iChargerVictim[iVictim]] = false;
	g_bChargerGrappled[iVictim] = false;
	g_iChargerVictim[iVictim] = 0;

	g_bSmokerGrappled[iVictim] = false;
	g_bSmokerGrappled[iAttacker] = false;
	g_iChokingVictim[iVictim] = -1;

	g_bJockeyGrappled[iVictim] = false;
	g_bJockeyGrappled[iAttacker] = false;
	g_iJockeyVictim[iVictim] = -1;
	
	g_iShowSurvivorVomitCounter[iVictim] = 0;

	// Survivors //////////////////////////////////////////////////////////////////////////
	
	g_bUsingFireStorm[iVictim] = false;
	g_bUsingShadowNinja[iVictim] = false;
	g_bIsJetpackOn[iVictim] = false;
	g_bUsingTongueRope[iVictim] = false;
	DeleteAllClientParticles(iVictim);

	if(g_bIsRochellePoisoned[iVictim]==true)
	{
		DeleteParticleEntity(g_iPID_RochellePoisonBullet[iVictim]);
		WriteParticle(iVictim, "poison_bullet_pool", 0.0, 41.0);
	}
	g_bHunterLethalPoisoned[iVictim] = false;
}

void DeleteAllGlobalTimerHandles(int iClient)
{
	delete g_hTimer_ShowingConfirmTalents[iClient];
	delete g_hTimer_VictimHealthMeterStop[iClient];
	delete g_hTimer_SelfReviveCheck[iClient];
	delete g_hTimer_DrugPlayer[iClient];
	delete g_hTimer_HallucinatePlayer[iClient];
	delete g_hTimer_SlapPlayer[iClient];
	delete g_hTimer_RochellePoison[iClient];
	delete g_hTimer_HunterPoison[iClient];
	delete g_hTimer_HunterImmobilityZone[iClient];
	delete g_hTimer_NickLifeSteal[iClient];
	delete g_hTimer_BillDropBombs[iClient];
	delete g_hTimer_LouisTeleportRegenerate[iClient];
	delete g_hTimer_UntangleSurvivorCheck[iClient];
	delete g_hTimer_HandleSmokerSmokeCloudTick[iClient];
	delete g_hTimer_ResetTarFingerVictimBlindAmount[iClient];
	delete g_hTimer_TimerKeepBotFocusedOnXPModGoal[iClient];
	delete g_hTimer_AdhesiveGooReset[iClient];
	delete g_hTimer_DemiGooReset[iClient];
	delete g_hTimer_ResetGlow[iClient];
	delete g_hTimer_ViralInfectionTick[iClient];
	delete g_hTimer_BlockGooSwitching[iClient];	
	delete g_hTimer_ExtinguishTank[iClient];
	delete g_hTimer_IceSphere[iClient];
	delete g_hTimer_IceTankColdSlowAuraEffectUpdate[iClient];
	delete g_hTimer_WingDashChargeRegenerate[iClient];
	delete g_hTimer_VampiricTankCanRechargeStamina[iClient];
}
