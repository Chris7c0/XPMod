//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////     SURVIVOR VARIABLES     ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// New player buffs, until they reach max level (30)
// Damage Reduction for new Players
// This value at level 0, as leveling it goes lower.
// Reduction = ( iDmgAmount * ( NEW_PLAYER_MAX_DAMAGE_REDUCTION * (1.0 - (float(g_iClientLevel[iVictim]) / 30.0)) )
#define NEW_PLAYER_MAX_DAMAGE_REDUCTION     0.50
// Movement speed buff
// SpeedBuff = ( NEW_PLAYER_MAX_MOVEMENT_SPEED * ( 1.0 - (float(g_iClientLevel[iClient]) / 30.0) ) );
#define MOVEMENT_SPEED_NEW_PLAYER_MAX       0.25
#define MOVEMENT_SPEED_BOT                  0.40

//Loadout Variables
new String:g_strClientPrimarySlot[32];
new String:g_strClientSecondarySlot[32];
new String:g_strClientExplosiveSlot[32];
new String:g_strClientHealthSlot[32];
new String:g_strClientBoostSlot[32];
new String:g_strClientLaserSlot[14];
//Slot IDs
new g_iClientPrimarySlotID[MAXPLAYERS + 1];
new g_iClientSecondarySlotID[MAXPLAYERS + 1];
new g_iClientExplosiveSlotID[MAXPLAYERS + 1];
new g_iClientHealthSlotID[MAXPLAYERS + 1];
new g_iClientBoostSlotID[MAXPLAYERS + 1];
new g_iClientLaserSlotID[MAXPLAYERS + 1];
//Slot XP Costs 
new g_iClientPrimarySlotCost[MAXPLAYERS + 1];
new g_iClientSecondarySlotCost[MAXPLAYERS + 1];
new g_iClientExplosiveSlotCost[MAXPLAYERS + 1];
new g_iClientHealthSlotCost[MAXPLAYERS + 1];
new g_iClientBoostSlotCost[MAXPLAYERS + 1];
new g_iClientLaserSlotCost[MAXPLAYERS + 1];

// Fast Attacking Weapons
int g_iFastAttackingCurrentWeaponID[MAXPLAYERS + 1];
int g_iFastAttackingCurrentItemIndex[MAXPLAYERS + 1];
float g_fPreviousNextPrimaryAttack[MAXPLAYERS + 1] = 0.0;
float g_fPreviousNextSecondaryAttack[MAXPLAYERS + 1] = 0.0;

///////////////////////////////////////////////     PLAYER SPECIFIC VARIABLES     ///////////////////////////////////////////////

// Misc Survivor Variables
#define SCREEN_SHAKE_AMOUNT_DEFAULT     20
new g_iScreenShakeAmount = SCREEN_SHAKE_AMOUNT_DEFAULT;
new bool:g_bClientIsReloading[MAXPLAYERS + 1];
new g_iReloadFrameCounter[MAXPLAYERS + 1];
new g_iLaserUpgradeCounter[MAXPLAYERS + 1];
new g_iSavedClip[MAXPLAYERS + 1];
new bool:g_bForceReload[MAXPLAYERS + 1];
new g_iEventWeaponFireCounter[MAXPLAYERS + 1];
new g_iReserveAmmo[MAXPLAYERS + 1];
new g_iAmmoOffset[MAXPLAYERS + 1];
new g_iActiveWeaponID[MAXPLAYERS + 1];
new g_iStashedPrimarySlotWeaponIndex[MAXPLAYERS + 1];
new g_iCurrentClipAmmo[MAXPLAYERS + 1];
new g_iOffset_Ammo[MAXPLAYERS + 1];
// new g_iCurrentMaxClipSize[MAXPLAYERS + 1];
new String:g_strCurrentAmmoUpgrade[32];
//new String:g_strCheckAmmoUpgrade[32];
new g_iKitsUsed = 0;
new g_iSlapRunTimes[MAXPLAYERS + 1];			//for the slap timer for each iClient	//Remember to initialize this each time before use!
new Float:g_fMaxLaserAccuracy = 0.4;	        //max accuracy increase for survivors
new g_iPrimarySlotID[MAXPLAYERS + 1];
new g_iClientPrimaryClipSize[MAXPLAYERS + 1];   //g_iOffset_Clip1 for the clients primary weapon before addition of talents
new bool:g_bAdhesiveGooActive[MAXPLAYERS + 1];
// Victim Health Meter
#define VICTIM_HEALTH_METER_DISPLAY_TIME        3.0
new bool:g_bVictimHealthMeterActive[MAXPLAYERS + 1];
new g_iVictimHealthMeterWatchVictim[MAXPLAYERS + 1];
// Self Revives
#define SELF_REVIVE_TIME	    4.0
#define SELF_REVIVE_HEALTH	    1
#define SELF_REVIVE_TEMP_HEALTH 30
new g_iSelfRevives[MAXPLAYERS + 1];
new bool:g_bSelfReviving[MAXPLAYERS + 1];
new Float:g_fSelfRevivingFinishTime[MAXPLAYERS + 1];
// Bile Removal Kits
#define BILE_CLEANSING_COMPLETION_FRAME             60
new g_iBileCleansingKits[MAXPLAYERS + 1];
new g_iBileCleansingFrameTimeCtr[MAXPLAYERS + 1];

// Give a lot of weapons
bool g_bGiveAlotOfWeaponsOnCooldown;
#define GIVE_ALOT_OF_WEAPONS_COOLDOWN_DURATION      300.0

// Grappled Checks
new bool:g_bChargerGrappled[MAXPLAYERS + 1];
new bool:g_bSmokerGrappled[MAXPLAYERS + 1];
new bool:g_bJockeyGrappled[MAXPLAYERS + 1];
new bool:g_bHunterGrappled[MAXPLAYERS + 1];
new g_iChargerVictim[MAXPLAYERS + 1];
new g_iJockeyVictim[MAXPLAYERS + 1];    //g_iJockeyVictim[attacker] = victim;
new g_iHunterShreddingVictim[MAXPLAYERS + 1];

new bool:g_bIsClientDown[MAXPLAYERS + 1] = {false, ...};

// For calculating Temp Health
ConVar cvarPainPillsDecay;
float flPainPillsDecay = 0.27;

//Bill's Stuff (Support)/////////////////////////////////////////////////////////////////////////////////////////////////////////
new g_iCrawlSpeedMultiplier;
new g_iBillSprintChargeCounter[MAXPLAYERS + 1];
new g_iBillSprintChargePower[MAXPLAYERS + 1];
new bool:g_bBillSprinting[MAXPLAYERS + 1];
new bool:g_bCanDropPoopBomb[MAXPLAYERS + 1];
new g_iPoopBombOwnerID[MAXENTITIES + 1];
new g_iDropBombsTimes[MAXPLAYERS + 1];
#define BILL_TEAM_HEAL_FRAME_COUNTER_REQUIREMENT    2       // Seconds
#define BILL_TEAM_HEAL_HP_AMOUNT                    10      // HP per tick
#define BILL_TEAM_HEAL_HP_POOL                      400     // Health Pool for the round shared amongst all Bills
#define BILL_TEAM_HEAL_MAX_DISTANCE                 800.0    // Precalculated 8 * Ft = value -> 800.0 / 8 = 100 ft
new g_iBillTeamHealCounter[MAXPLAYERS + 1];
new g_iBillsTeamHealthPool;

//Rochelle's Stuff
#define ROCHELLE_ESCAPE_CHANCE_PER_LEVEL            3
//For the Infected Detection Device(IDD) hud menu
new bool:g_bDrawIDD[MAXPLAYERS + 1];
new bool:g_bClientIDDToggle[MAXPLAYERS + 1];
new Float:g_fDetectedDistance_Smoker[MAXPLAYERS + 1];
new Float:g_fDetectedDistance_Boomer[MAXPLAYERS + 1];
new Float:g_fDetectedDistance_Hunter[MAXPLAYERS + 1];
new Float:g_fDetectedDistance_Spitter[MAXPLAYERS + 1];
new Float:g_fDetectedDistance_Jockey[MAXPLAYERS + 1];
new Float:g_fDetectedDistance_Charger[MAXPLAYERS + 1];
new Float:g_fDetectedDistance_Tank[MAXPLAYERS + 1];
//For Shadow Ninja
new bool:g_bUsingShadowNinja[MAXPLAYERS + 1];
//For High Jump
new g_iHighJumpChargeCounter[MAXPLAYERS + 1];
new bool:g_bIsHighJumpCharged[MAXPLAYERS + 1];
new bool:g_bIsHighJumping[MAXPLAYERS + 1];
//For Poisoned clients she has hurt
new bool:g_bIsRochellePoisoned[MAXPLAYERS + 1];
new g_iSilentSorrowHeadshotCounter[MAXPLAYERS + 1];
//To Remember Rochelles Location When Breaking Free From Smoker
new Float:g_xyzOriginalPositionRochelle[MAXPLAYERS + 1][3];
new Float:g_xyzBreakFromSmokerVector[3];
// Smoker Tongue Rope
new bool:g_bUsingTongueRope[MAXPLAYERS + 1];
new bool:g_bUsedTongueRope[MAXPLAYERS + 1];
new g_iRochelleRopeDurability[MAXPLAYERS + 1];
new g_iRochelleRopeDummyEntityAttachmentHand[MAXPLAYERS + 1];
new g_iRochelleRopeDummyEntityAttachmentWall[MAXPLAYERS + 1];
float g_xyzRopeEndLocation[MAXPLAYERS + 1][3];
#define ROCHELLE_ROPE_MAX_DURABILITY                300     // 30 = 1 second
#define ROCHELLE_ROPE_DEPLOYMENT_COST               15
#define ROCHELLE_ROPE_REGEN_PER_2_SEC_TICK          10
#define ROCHELLE_ROPE_MAX_DISTANCE_FT_PER_LEVEL     60.0
// SCOUT
#define ROCHELLE_SILENT_SORROW_SCOUT_MAX_HEADSHOT_COUNTER   8
#define ROCHELLE_SILENT_SORROW_SCOUT_EXTRA_DMG_PER_STACK    1.0     //Mulitplier
// Ruger
new g_iRochelleRugerHitCounter[MAXPLAYERS + 1];
new g_iRochelleRugerStacks[MAXPLAYERS + 1];
new g_iRochelleRugerLastHitStackCount[MAXPLAYERS + 1];
#define ROCHELLE_RUGER_MAX_STACKS           100
#define ROCHELLE_RUGER_DMG_PER_STACK        0.05
#define ROCHELLE_RUGER_STACKS_GAINED_CI     1
#define ROCHELLE_RUGER_STACKS_GAINED_SI     10
#define ROCHELLE_RUGER_STACKS_GAINED_TANK   2
#define ROCHELLE_RUGER_STACKS_LOST_ON_MISS  15
// AWP
new g_iRochelleAWPChargeLevel[MAXPLAYERS + 1];
bool g_bRochelleAWPCharged[MAXPLAYERS + 1];
#define ROCHELLE_AWP_CHARGED_SHOT_DAMAGE    2000

//Coach's Stuff
//For Coach's Jetpack
#define COACH_JETPACK_FUEL_PER_LEVEL                60
#define COACH_JETPACK_FUEL_REGEN_PER_2_SEC_TICK     5
new bool:g_bIsFlyingWithJetpack[MAXPLAYERS + 1];
new g_iClientJetpackFuel[MAXPLAYERS + 1];
new bool:g_bIsJetpackOn[MAXPLAYERS + 1];
new bool:g_bIsMovementTypeFly[MAXPLAYERS + 1];
new g_iExtraExplosiveUses[MAXPLAYERS + 1];
new bool:g_bExplosivesJustGiven[MAXPLAYERS + 1];
//For Coach's other talents
new g_iCoachDecapitationCounter[MAXPLAYERS + 1];
new g_iMeleeDamageCounter[MAXPLAYERS + 1];
new g_iWreckingBallChargeCounter[MAXPLAYERS + 1];
new g_iCoachHealthRechargeCounter[MAXPLAYERS + 1];
new bool:g_bIsWreckingBallCharged[MAXPLAYERS + 1];
new bool:g_bShowingChargeHealParticle[MAXPLAYERS + 1];
new g_iHighestLeadLevel;
new g_iCoachTeamHealthStack;
//new Float:g_fCoachCIHeadshotSpeed[MAXPLAYERS + 1];
//new Float:g_fCoachSIHeadshotSpeed[MAXPLAYERS + 1];
//new Float:g_fCoachRageSpeed[MAXPLAYERS + 1];
new g_iCoachRageRegenCounter[MAXPLAYERS + 1];
new bool:g_bCoachRageIsAvailable[MAXPLAYERS + 1];
new bool:g_bCoachRageIsActive[MAXPLAYERS + 1];
new g_iCoachRageMeleeDamage[MAXPLAYERS + 1];
new bool:g_bCoachRageIsInCooldown[MAXPLAYERS + 1];
new bool:g_bWreckingChargeRetrigger[MAXPLAYERS + 1];
new g_iCoachCurrentGrenadeSlot[MAXPLAYERS + 1];
new String:g_strCoachGrenadeSlot1[32];
new String:g_strCoachGrenadeSlot2[32];
new String:g_strCoachGrenadeSlot3[32];
new bool:g_bCanCoachGrenadeCycle[MAXPLAYERS + 1];
new bool:g_bIsCoachGrenadeFireCycling[MAXPLAYERS + 1];
new g_iCoachShotgunAmmoCounter[MAXPLAYERS + 1];
//new g_iCoachShotgunIncreasedAmmo[MAXPLAYERS + 1];
new g_iCoachShotgunSavedAmmo[MAXPLAYERS + 1];
new bool:g_bCoachShotgunForceReload[MAXPLAYERS + 1];
new bool:g_bIsCoachInGrenadeCycle[MAXPLAYERS + 1];
//g_bIsCoachInGrenadeCycle[iClient] = false;
new bool:g_bCoachInCISpeed[MAXPLAYERS + 1];
new bool:g_bCoachInSISpeed[MAXPLAYERS + 1];
new g_iCoachCIHeadshotCounter[MAXPLAYERS + 1];
new g_iCoachSIHeadshotCounter[MAXPLAYERS + 1];

//Ellis's Stuff
#define ELLIS_STARTING_MAX_HEALTH                       90
#define ELLIS_AMMO_GAINED_PER_SI_KILL_PER_LEVEL         8
new bool:g_bUsingFireStorm[MAXPLAYERS + 1];
new g_iEllisSpeedBoostCounter[MAXPLAYERS + 1];
new bool:g_bWalkAndUseToggler[MAXPLAYERS + 1];
new Float:g_fEllisOverSpeed[MAXPLAYERS + 1];
new Float:g_fEllisBringSpeed[MAXPLAYERS + 1];
new Float:g_fEllisJamminSpeed[MAXPLAYERS + 1];
new bool:g_bCanEllisPrimaryCycle[MAXPLAYERS + 1];
new g_iEllisPrimarySlot0[MAXPLAYERS + 1];
new g_iEllisPrimarySlot1[MAXPLAYERS + 1];
new g_iEllisCurrentPrimarySlot[MAXPLAYERS + 1];
new g_iEllisPrimarySavedClipSlot0[MAXPLAYERS + 1];
new g_iEllisPrimarySavedClipSlot1[MAXPLAYERS + 1];
new g_iEllisPrimarySavedAmmoSlot0[MAXPLAYERS + 1];
new g_iEllisPrimarySavedAmmoSlot1[MAXPLAYERS + 1];
new g_iEllisJamminGrenadeCounter[MAXPLAYERS + 1];
new g_iEllisJamminAdrenalineCounter[MAXPLAYERS + 1];
new bool:g_bIsEllisWeaponCycling[MAXPLAYERS + 1];
new bool:g_bSetWeaponAmmoOnNextGameFrame[MAXPLAYERS + 1];
new g_iEllisUpgradeAmmoSlot1[MAXPLAYERS + 1];
new g_iEllisUpgradeAmmoSlot2[MAXPLAYERS + 1];
new String:g_strEllisUpgradeTypeSlot1[32];
new String:g_strEllisUpgradeTypeSlot2[32];
//new bool:g_bEllisHasCycled[MAXPLAYERS + 1];
new bool:g_bIsEllisLimitBreaking[MAXPLAYERS + 1];
new bool:g_bCanEllisLimitBreak[MAXPLAYERS + 1];
new g_iLimitBreakWeaponIndex[MAXPLAYERS + 1];
new bool:g_bEllisLimitBreakInCooldown[MAXPLAYERS + 1];
#define ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT            40
new bool:g_bEllisOverSpeedIncreased[MAXPLAYERS + 1];
new g_iEllisAdrenalineStackDuration;
new bool:g_bEllisHasAdrenalineBuffs[MAXPLAYERS + 1];
#define ELLIS_STASHED_INVENTORY_MAX_ADRENALINE              3
#define ELLIS_STASHED_INVENTORY_MAX_TANK_SPAWN_ADRENALINE   5
new g_iStashedInventoryAdrenaline[MAXPLAYERS + 1];
#define ELLIS_HEAL_AMOUNT_PILLS                             15
#define ELLIS_MAX_TEMP_HEALTH                               125
new g_iTempHealthBeforeUsingHealthBoostSlotItem[MAXPLAYERS + 1];
#define ELLIS_ROF_OVER_PER_LEVEL         0.05
#define ELLIS_ROF_METAL_PER_LEVEL        0.05
#define ELLIS_ROF_ADRENALINE_PER_LEVEL   0.10
#define ELLIS_ROF_LIMIT_BREAK            3.0
#define ELLIS_ROF_PISTOLS                1.5

//Nicks Stuff
new bool:g_bNickIsStealingLife[MAXPLAYERS + 1][MAXPLAYERS + 1];	//g_bNickIsStealingLife[victim][attacker]
new g_iNickStealingLifeRuntimes[MAXPLAYERS + 1];
new g_iNickResurrectUses = 0;
new bool:g_bCanNickSecondaryCycle[MAXPLAYERS + 1];
new String:g_strNickSecondarySlot1[512];
// new String:g_strNickSecondarySlot2[512];
new g_iNickCurrentSecondarySlot[MAXPLAYERS + 1];
new g_iNickSecondarySavedClipSlot1[MAXPLAYERS + 1];
new g_iNickSecondarySavedClipSlot2[MAXPLAYERS + 1];
#define NICK_HEAL_PISTOL_GIVE       2
#define NICK_HEAL_PISTOL_TAKE       1
#define NICK_HEAL_MAGNUM_GIVE       7
#define NICK_HEAL_MAGNUM_TAKE       3
new bool:g_bCanNickZoomKit[MAXPLAYERS + 1];
new bool:g_bIsNickInSecondaryCycle[MAXPLAYERS + 1];
new bool:g_bRamboModeActive[MAXPLAYERS + 1];
//new g_iNickDesperateMeasuresDeathStack;
//new g_iNickDesperateMeasuresIncapStack;
new bool:g_bDivineInterventionQueued[MAXPLAYERS + 1];
new bool:g_bNickAlreadyGivenMoreBind2s[MAXPLAYERS + 1];
new g_iNickDesperateMeasuresStack;
new g_iRamboWeaponID[MAXPLAYERS + 1];
//g_bIsNickInSecondaryCycle
//g_bCanNickZoomKit
//Drug Effects
new g_iDruggedRuntimesCounter[MAXPLAYERS + 1];
//Gambling
new bool:g_bNickIsInvisible[MAXPLAYERS + 1] = {false, ...};
new bool:g_bNickIsGettingBeatenUp[MAXPLAYERS + 1] = {false, ...};
new g_iNicksRamboWeaponID[MAXPLAYERS + 1];
new g_iNickMagnumShotCount[MAXPLAYERS + 1];
new bool:g_bCanNickStampedeReload[MAXPLAYERS + 1];
new g_iNickMagnumShotCountCap[MAXPLAYERS + 1];
new g_iNickPrimarySavedClip[MAXPLAYERS + 1];
new g_iNickPrimarySavedAmmo[MAXPLAYERS + 1];
new g_iNickUpgradeAmmo[MAXPLAYERS + 1];
new String:g_strNickUpgradeType[32];
new bool:g_bNickStoresDroppedPistolAmmo[MAXPLAYERS + 1] = {false, ...};


// Louis
#define LOUIS_TELEPORT_TOTAL_CHARGES                    3
#define LOUIS_TELEPORT_MOVEMENT_SPEED                   8.0
#define LOUIS_TELEPORT_CHARGE_REGENERATE_TIME           5.0
#define LOUIS_TELEPORT_CHARGE_MAXED_REGENERATE_TIME     90.0
#define LOUIS_TELEPORT_BLINDNESS_ADDITIVE_AMOUNT        69
#define LOUIS_TELEPORT_BLINDNESS_DURATION               4100
#define LOUIS_TELEPORT_BLINDNESS_FADE_TIME              12.0
#define LOUIS_TELEPORT_BLINDNESS_STAY_FACTOR            1.5
#define LOUIS_TELEPORT_MOVEMENT_PENALTY_TIME            10.0
#define LOUIS_TELEPORT_MOVEMENT_PENALTY_AMOUNT          0.05
#define LOUIS_SPEED_MAX                                 1.15
#define LOUIS_HEADSHOT_SPEED_RETENTION_TIME_CI          60.0
#define LOUIS_HEADSHOT_SPEED_RETENTION_TIME_SI          60.0
#define LOUIS_STASHED_INVENTORY_MAX_PILLS               4
#define LOUIS_PILLS_USED_BONUS_DURATION                 90.0
#define LOUIS_PILLS_USED_HEALTH_REDUCTION_PER_LEVEL     2
#define LOUIS_PILLS_USED_MAX_STACKS                     3
bool g_bLouisTeleportCoolingDown[MAXPLAYERS + 1] = {false, ...};
bool g_bLouisTeleportActive[MAXPLAYERS + 1] = {false, ...};
new g_iLouisTeleportChargeUses[MAXPLAYERS + 1] = {0, ...};
new Float:g_fLouisTeleportLastUseGameTime[MAXPLAYERS + 1] = {0.0, ...};
new g_iLouisTeleportBlindnessAmount[MAXPLAYERS + 1] = {0, ...};
new g_iLouisTeleportMovementPenaltyStacks[MAXPLAYERS + 1] = {0, ...};
new g_iLouisCIHeadshotCounter[MAXPLAYERS + 1] = {0, ...};
new g_iLouisSIHeadshotCounter[MAXPLAYERS + 1] = {0, ...};
#define LOUIS_NEUROSURGEON_CI_CHANCE                    5     // Percent Chance
#define LOUIS_NEUROSURGEON_SI_CHANCE                    1     // Percent Chance
#define LOUIS_NEUROSURGEON_SI_XMR_REWARD_AMOUNT         3.0   // XMR
new g_iStashedInventoryPills[MAXPLAYERS + 1] = {0, ...};
new g_iPillsUsedStack[MAXPLAYERS + 1] = {0, ...};
bool g_bHealthBoostItemJustGivenByCheats[MAXPLAYERS + 1] = {false, ...};
bool g_bHealthBoostSlotWasEmptyOnLastPickUp[MAXPLAYERS + 1] = {false, ...};
bool g_bWareStationActive[MAXPLAYERS + 1];
bool g_bWareStationClientAlreadyServiced[MAXPLAYERS + 1][MAXPLAYERS + 1];
new g_iWareStationOwnerIDOfCurrentlyViewedStation[MAXPLAYERS + 1];
float g_xyzWarezStationLocation[MAXPLAYERS + 1][3];
float g_fWarezStationSpeedBoost[MAXPLAYERS + 1];
float g_fLouisXMRWallet[MAXPLAYERS + 1];
#define LOUIS_HEADSHOT_XMR_STARTING_AMOUNT              2.6
#define LOUIS_HEADSHOT_XMR_AMOUNT_CI                    0.1
#define LOUIS_HEADSHOT_XMR_AMOUNT_SI                    0.5
#define LOUIS_HEADSHOP_ITEM_SPEED_HAX                   1
#define LOUIS_HEADSHOP_ITEM_NUB_WIPE                    2
#define LOUIS_HEADSHOP_ITEM_MED_HAX                     3
#define LOUIS_HEADSHOP_ITEM_HAXOR_TEH_SERVER            4
#define LOUIS_HEADSHOP_ITEM_HAK_TARGET                  5
#define LOUIS_HEADSHOP_ITEM_TIME_OUT                    6
#define LOUIS_HEADSHOP_XMR_AMOUNT_SPEED_HAX             6.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_NUB_WIPE              6.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_MED_HAX               7.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_HAXOR_TEH_SERVER      8.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_HAK_TARGET            8.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_TIME_OUT              8.0
bool g_bLouisSpeedHaxEnabled;
bool g_bSpeedHaxInCooldown;
#define LOUIS_SPEED_HAX_MOVEMENT_MULTIPLIER             2.0
#define LOUIS_SPEED_HAX_DURATION                        10.0
#define LOUIS_SPEED_HAX_COOLDOWN_DURATION               300.0
bool g_bLouisMedHaxEnabled;
#define LOUIS_MED_HAX_USE_DURATION                      1
#define LOUIS_MED_HAX_DURATION                          30.0
bool g_bIsPLayerHacked[MAXPLAYERS + 1];
#define LOUIS_HACK_TARGET_DURATION                      10.0
bool g_bHackTheServerEnabled;
bool g_bHackTheServerInCooldown;
#define LOUIS_HAK_TEH_SERVER_DURATION                   5.0     // The actual duration is a function of this...
#define LOUIS_HAK_TEH_SERVER_TIME_SCALE_FACTOR          0.25    // multiplied by 1 over this
#define LOUIS_HAK_TEH_SERVER_COOLDOWN_DURATION          300.0
#define LOUIS_HAK_TEH_SERVER_LOUIS_SPEED_MULTIPLIER     2.0
bool g_bTimeOutInCooldown;
bool g_bInfectedBindsDisabled;
#define LOUIS_TIME_OUT_DURATION                         60.0
#define LOUIS_TIME_OUT_COOLDOWN_DURATION                300.0


