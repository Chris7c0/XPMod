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
char g_strClientPrimarySlot[32];
char g_strClientSecondarySlot[32];
char g_strClientExplosiveSlot[32];
char g_strClientHealthSlot[32];
char g_strClientBoostSlot[32];
char g_strClientLaserSlot[14];
//Slot IDs
int g_iClientPrimarySlotID[MAXPLAYERS + 1];
int g_iClientSecondarySlotID[MAXPLAYERS + 1];
int g_iClientExplosiveSlotID[MAXPLAYERS + 1];
int g_iClientHealthSlotID[MAXPLAYERS + 1];
int g_iClientBoostSlotID[MAXPLAYERS + 1];
int g_iClientLaserSlotID[MAXPLAYERS + 1];
//Slot XP Costs 
int g_iClientPrimarySlotCost[MAXPLAYERS + 1];
int g_iClientSecondarySlotCost[MAXPLAYERS + 1];
int g_iClientExplosiveSlotCost[MAXPLAYERS + 1];
int g_iClientHealthSlotCost[MAXPLAYERS + 1];
int g_iClientBoostSlotCost[MAXPLAYERS + 1];
int g_iClientLaserSlotCost[MAXPLAYERS + 1];

// Fast Attacking Weapons
int g_iFastAttackingCurrentWeaponID[MAXPLAYERS + 1];
int g_iFastAttackingCurrentItemIndex[MAXPLAYERS + 1];
float g_fPreviousNextPrimaryAttack[MAXPLAYERS + 1] = { 0.0, ...};
float g_fPreviousNextSecondaryAttack[MAXPLAYERS + 1] = { 0.0, ...};

///////////////////////////////////////////////     PLAYER SPECIFIC VARIABLES     ///////////////////////////////////////////////

// Misc Survivor Variables
#define SCREEN_SHAKE_AMOUNT_DEFAULT     20
int g_iScreenShakeAmount = SCREEN_SHAKE_AMOUNT_DEFAULT;
bool g_bClientIsReloading[MAXPLAYERS + 1];
int g_iReloadFrameCounter[MAXPLAYERS + 1];
int g_iLaserUpgradeCounter[MAXPLAYERS + 1];
int g_iSavedClip[MAXPLAYERS + 1];
bool g_bForceReload[MAXPLAYERS + 1];
int g_iEventWeaponFireCounter[MAXPLAYERS + 1];
int g_iReserveAmmo[MAXPLAYERS + 1];
int g_iAmmoOffset[MAXPLAYERS + 1];
int g_iActiveWeaponID[MAXPLAYERS + 1];
int g_iStashedPrimarySlotWeaponIndex[MAXPLAYERS + 1];
int g_iCurrentClipAmmo[MAXPLAYERS + 1];
int g_iOffset_Ammo[MAXPLAYERS + 1];
// new g_iCurrentMaxClipSize[MAXPLAYERS + 1];
char g_strCurrentAmmoUpgrade[32];
//char g_strCheckAmmoUpgrade[32];
int g_iKitsUsed = 0;
int g_iSlapRunTimes[MAXPLAYERS + 1];//for the slap timer for each iClient	//Remember to initialize this each time before use!
float g_fMaxLaserAccuracy = 0.4;	        //max accuracy increase for survivors
int g_iPrimarySlotID[MAXPLAYERS + 1];
int g_iClientPrimaryClipSize[MAXPLAYERS + 1];//g_iOffset_Clip1 for the clients primary weapon before addition of talents
bool g_bAdhesiveGooActive[MAXPLAYERS + 1];
// Victim Health Meter
#define VICTIM_HEALTH_METER_DISPLAY_TIME        3.0
bool g_bVictimHealthMeterActive[MAXPLAYERS + 1];
int g_iVictimHealthMeterWatchVictim[MAXPLAYERS + 1];
// Self Revives
#define SELF_REVIVE_TIME	    4.0
#define SELF_REVIVE_HEALTH	    1
#define SELF_REVIVE_TEMP_HEALTH 30
int g_iSelfRevives[MAXPLAYERS + 1];
bool g_bSelfReviving[MAXPLAYERS + 1];
float g_fSelfRevivingFinishTime[MAXPLAYERS + 1];
// Bile Removal Kits
#define BILE_CLEANSING_COMPLETION_FRAME             60
int g_iBileCleansingKits[MAXPLAYERS + 1];
int g_iBileCleansingFrameTimeCtr[MAXPLAYERS + 1];

// Give a lot of weapons
bool g_bGiveAlotOfWeaponsOnCooldown;
#define GIVE_ALOT_OF_WEAPONS_COOLDOWN_DURATION      300.0

// Grappled Checks
bool g_bChargerGrappled[MAXPLAYERS + 1];
bool g_bSmokerGrappled[MAXPLAYERS + 1];
bool g_bJockeyGrappled[MAXPLAYERS + 1];
bool g_bHunterGrappled[MAXPLAYERS + 1];
int g_iChargerVictim[MAXPLAYERS + 1];
int g_iJockeyVictim[MAXPLAYERS + 1];//g_iJockeyVictim[attacker] = victim;
int g_iHunterShreddingVictim[MAXPLAYERS + 1];

bool g_bIsClientDown[MAXPLAYERS + 1] = {false, ...};

// For calculating Temp Health
ConVar cvarPainPillsDecay;
float flPainPillsDecay = 0.27;

//Bill's Stuff (Support)/////////////////////////////////////////////////////////////////////////////////////////////////////////
int g_iCrawlSpeedMultiplier;
int g_iBillSprintChargeCounter[MAXPLAYERS + 1];
int g_iBillSprintChargePower[MAXPLAYERS + 1];
bool g_bBillSprinting[MAXPLAYERS + 1];
bool g_bCanDropPoopBomb[MAXPLAYERS + 1];
int g_iPoopBombOwnerID[MAXENTITIES + 1];
int g_iDropBombsTimes[MAXPLAYERS + 1];
#define BILL_TEAM_HEAL_FRAME_COUNTER_REQUIREMENT    2       // Seconds
#define BILL_TEAM_HEAL_HP_AMOUNT                    10      // HP per tick
#define BILL_TEAM_HEAL_HP_POOL                      400     // Health Pool for the round shared amongst all Bills
#define BILL_TEAM_HEAL_MAX_DISTANCE                 800.0    // Precalculated 8 * Ft = value -> 800.0 / 8 = 100 ft
int g_iBillTeamHealCounter[MAXPLAYERS + 1];
int g_iBillsTeamHealthPool;

//Rochelle's Stuff
#define ROCHELLE_ESCAPE_CHANCE_PER_LEVEL            3
//For the Infected Detection Device(IDD) hud menu
bool g_bDrawIDD[MAXPLAYERS + 1];
bool g_bClientIDDToggle[MAXPLAYERS + 1];
float g_fDetectedDistance_Smoker[MAXPLAYERS + 1];
float g_fDetectedDistance_Boomer[MAXPLAYERS + 1];
float g_fDetectedDistance_Hunter[MAXPLAYERS + 1];
float g_fDetectedDistance_Spitter[MAXPLAYERS + 1];
float g_fDetectedDistance_Jockey[MAXPLAYERS + 1];
float g_fDetectedDistance_Charger[MAXPLAYERS + 1];
float g_fDetectedDistance_Tank[MAXPLAYERS + 1];
//For Shadow Ninja
bool g_bUsingShadowNinja[MAXPLAYERS + 1];
//For High Jump
int g_iHighJumpChargeCounter[MAXPLAYERS + 1];
bool g_bIsHighJumpCharged[MAXPLAYERS + 1];
bool g_bIsHighJumping[MAXPLAYERS + 1];
//For Poisoned clients she has hurt
bool g_bIsRochellePoisoned[MAXPLAYERS + 1];
int g_iSilentSorrowHeadshotCounter[MAXPLAYERS + 1];
//To Remember Rochelles Location When Breaking Free From Smoker
float g_xyzOriginalPositionRochelle[MAXPLAYERS + 1][3];
float g_xyzBreakFromSmokerVector[3];
// Smoker Tongue Rope
bool g_bUsingTongueRope[MAXPLAYERS + 1];
bool g_bUsedTongueRope[MAXPLAYERS + 1];
int g_iRochelleRopeDurability[MAXPLAYERS + 1];
int g_iRochelleRopeDummyEntityAttachmentHand[MAXPLAYERS + 1];
int g_iRochelleRopeDummyEntityAttachmentWall[MAXPLAYERS + 1];
float g_xyzRopeEndLocation[MAXPLAYERS + 1][3];
#define ROCHELLE_ROPE_MAX_DURABILITY                300     // 30 = 1 second
#define ROCHELLE_ROPE_DEPLOYMENT_COST               15
#define ROCHELLE_ROPE_REGEN_PER_2_SEC_TICK          10
#define ROCHELLE_ROPE_MAX_DISTANCE_FT_PER_LEVEL     60.0
// SCOUT
#define ROCHELLE_SILENT_SORROW_SCOUT_MAX_HEADSHOT_COUNTER   8
#define ROCHELLE_SILENT_SORROW_SCOUT_EXTRA_DMG_PER_STACK    1.0     //Mulitplier
// Ruger
int g_iRochelleRugerHitCounter[MAXPLAYERS + 1];
int g_iRochelleRugerStacks[MAXPLAYERS + 1];
int g_iRochelleRugerLastHitStackCount[MAXPLAYERS + 1];
#define ROCHELLE_RUGER_MAX_STACKS           100
#define ROCHELLE_RUGER_DMG_PER_STACK        0.05
#define ROCHELLE_RUGER_STACKS_GAINED_CI     1
#define ROCHELLE_RUGER_STACKS_GAINED_SI     10
#define ROCHELLE_RUGER_STACKS_GAINED_TANK   2
#define ROCHELLE_RUGER_STACKS_LOST_ON_MISS  15
// AWP
int g_iRochelleAWPChargeLevel[MAXPLAYERS + 1];
bool g_bRochelleAWPCharged[MAXPLAYERS + 1];
#define ROCHELLE_AWP_CHARGED_SHOT_DAMAGE    2000

//Coach's Stuff
//For Coach's Jetpack
#define COACH_JETPACK_FUEL_PER_LEVEL                60
#define COACH_JETPACK_FUEL_REGEN_PER_2_SEC_TICK     5
bool g_bIsFlyingWithJetpack[MAXPLAYERS + 1];
int g_iClientJetpackFuel[MAXPLAYERS + 1];
bool g_bIsJetpackOn[MAXPLAYERS + 1];
bool g_bIsMovementTypeFly[MAXPLAYERS + 1];
int g_iExtraExplosiveUses[MAXPLAYERS + 1];
bool g_bExplosivesJustGiven[MAXPLAYERS + 1];
//For Coach's other talents
#define COACH_CLIP_GAINED_PER_SI_DECAP              10
int g_iCoachDecapitationCounter[MAXPLAYERS + 1];
int g_iMeleeDamageCounter[MAXPLAYERS + 1];
int g_iWreckingBallChargeCounter[MAXPLAYERS + 1];
int g_iCoachHealthRechargeCounter[MAXPLAYERS + 1];
bool g_bIsWreckingBallCharged[MAXPLAYERS + 1];
bool g_bShowingChargeHealParticle[MAXPLAYERS + 1];
int g_iHighestLeadLevel;
int g_iCoachTeamHealthStack;
//float g_fCoachCIHeadshotSpeed[MAXPLAYERS + 1];
//float g_fCoachSIHeadshotSpeed[MAXPLAYERS + 1];
//float g_fCoachRageSpeed[MAXPLAYERS + 1];
int g_iCoachRageRegenCounter[MAXPLAYERS + 1];
bool g_bCoachRageIsAvailable[MAXPLAYERS + 1];
bool g_bCoachRageIsActive[MAXPLAYERS + 1];
int g_iCoachRageMeleeDamage[MAXPLAYERS + 1];
bool g_bCoachRageIsInCooldown[MAXPLAYERS + 1];
bool g_bWreckingChargeRetrigger[MAXPLAYERS + 1];
int g_iCoachCurrentGrenadeSlot[MAXPLAYERS + 1];
char g_strCoachGrenadeSlot1[32];
char g_strCoachGrenadeSlot2[32];
char g_strCoachGrenadeSlot3[32];
bool g_bCanCoachGrenadeCycle[MAXPLAYERS + 1];
bool g_bIsCoachGrenadeFireCycling[MAXPLAYERS + 1];
int g_iCoachShotgunAmmoCounter[MAXPLAYERS + 1];
//new g_iCoachShotgunIncreasedAmmo[MAXPLAYERS + 1];
int g_iCoachShotgunSavedAmmo[MAXPLAYERS + 1];
bool g_bCoachShotgunForceReload[MAXPLAYERS + 1];
bool g_bIsCoachInGrenadeCycle[MAXPLAYERS + 1];
//g_bIsCoachInGrenadeCycle[iClient] = false;
bool g_bCoachInCISpeed[MAXPLAYERS + 1];
bool g_bCoachInSISpeed[MAXPLAYERS + 1];
int g_iCoachCIHeadshotCounter[MAXPLAYERS + 1];
int g_iCoachSIHeadshotCounter[MAXPLAYERS + 1];

//Ellis's Stuff
#define ELLIS_STARTING_MAX_HEALTH                       90
#define ELLIS_AMMO_GAINED_PER_SI_KILL_PER_LEVEL         8
bool g_bUsingFireStorm[MAXPLAYERS + 1];
int g_iEllisSpeedBoostCounter[MAXPLAYERS + 1];
bool g_bWalkAndUseToggler[MAXPLAYERS + 1];
float g_fEllisOverSpeed[MAXPLAYERS + 1];
float g_fEllisBringSpeed[MAXPLAYERS + 1];
float g_fEllisJamminSpeed[MAXPLAYERS + 1];
bool g_bCanEllisPrimaryCycle[MAXPLAYERS + 1];
int g_iEllisPrimarySlot0[MAXPLAYERS + 1];
int g_iEllisPrimarySlot1[MAXPLAYERS + 1];
int g_iEllisCurrentPrimarySlot[MAXPLAYERS + 1];
int g_iEllisPrimarySavedClipSlot0[MAXPLAYERS + 1];
int g_iEllisPrimarySavedClipSlot1[MAXPLAYERS + 1];
int g_iEllisPrimarySavedAmmoSlot0[MAXPLAYERS + 1];
int g_iEllisPrimarySavedAmmoSlot1[MAXPLAYERS + 1];
int g_iEllisJamminGrenadeCounter[MAXPLAYERS + 1];
int g_iEllisJamminAdrenalineCounter[MAXPLAYERS + 1];
bool g_bIsEllisWeaponCycling[MAXPLAYERS + 1];
bool g_bSetWeaponAmmoOnNextGameFrame[MAXPLAYERS + 1];
int g_iEllisUpgradeAmmoSlot1[MAXPLAYERS + 1];
int g_iEllisUpgradeAmmoSlot2[MAXPLAYERS + 1];
char g_strEllisUpgradeTypeSlot1[32];
char g_strEllisUpgradeTypeSlot2[32];
//bool g_bEllisHasCycled[MAXPLAYERS + 1];
bool g_bIsEllisLimitBreaking[MAXPLAYERS + 1];
bool g_bCanEllisLimitBreak[MAXPLAYERS + 1];
int g_iLimitBreakWeaponIndex[MAXPLAYERS + 1];
bool g_bEllisLimitBreakInCooldown[MAXPLAYERS + 1];
#define ELLIS_OVERCONFIDENCE_BUFF_HP_REQUIREMENT            40
bool g_bEllisOverSpeedIncreased[MAXPLAYERS + 1];
int g_iEllisAdrenalineStackDuration;
bool g_bEllisHasAdrenalineBuffs[MAXPLAYERS + 1];
#define ELLIS_STASHED_INVENTORY_MAX_ADRENALINE              3
#define ELLIS_STASHED_INVENTORY_MAX_TANK_SPAWN_ADRENALINE   5
int g_iStashedInventoryAdrenaline[MAXPLAYERS + 1];
#define ELLIS_HEAL_AMOUNT_PILLS                             15
#define ELLIS_MAX_TEMP_HEALTH                               125
int g_iTempHealthBeforeUsingHealthBoostSlotItem[MAXPLAYERS + 1];
#define ELLIS_ROF_OVER_PER_LEVEL         0.05
#define ELLIS_ROF_METAL_PER_LEVEL        0.05
#define ELLIS_ROF_ADRENALINE_PER_LEVEL   0.10
#define ELLIS_ROF_LIMIT_BREAK            3.0
#define ELLIS_ROF_PISTOLS                1.5

//Nicks Stuff
#define NICK_REVIVE_COOLDOWN         10.0
#define NICK_HEAL_COOLDOWN           5.0
bool g_bNickIsStealingLife[MAXPLAYERS + 1][MAXPLAYERS + 1];	//g_bNickIsStealingLife[victim][attacker]
int g_iNickStealingLifeRuntimes[MAXPLAYERS + 1];
int g_iNickResurrectUses = 0;
#define NICK_CLIP_SIZE_MAX_MAGNUM   4
bool g_bCanNickSecondaryCycle[MAXPLAYERS + 1];
char g_strNickSecondarySlot1[512];
// char g_strNickSecondarySlot2[512];
int g_iNickCurrentSecondarySlot[MAXPLAYERS + 1];
int g_iNickSecondarySavedClipSlot1[MAXPLAYERS + 1];
int g_iNickSecondarySavedClipSlot2[MAXPLAYERS + 1];
#define NICK_HEAL_PISTOL_GIVE       1
#define NICK_HEAL_PISTOL_TAKE       1
#define NICK_HEAL_MAGNUM_GIVE       7
#define NICK_HEAL_MAGNUM_TAKE       3
bool g_bCanNickZoomKit[MAXPLAYERS + 1];
bool g_bIsNickInSecondaryCycle[MAXPLAYERS + 1];
bool g_bRamboModeActive[MAXPLAYERS + 1];
//new g_iNickDesperateMeasuresDeathStack;
//new g_iNickDesperateMeasuresIncapStack;
bool g_bDivineInterventionQueued[MAXPLAYERS + 1];
bool g_bNickAlreadyGivenMoreBind2s = false;
int g_iNickDesperateMeasuresStack;
int g_iRamboWeaponID[MAXPLAYERS + 1];
//g_bIsNickInSecondaryCycle
//g_bCanNickZoomKit
//Drug Effects
int g_iDruggedRuntimesCounter[MAXPLAYERS + 1];
//Gambling
bool g_bNickIsInvisible[MAXPLAYERS + 1] = {false, ...};
bool g_bNickIsGettingBeatenUp[MAXPLAYERS + 1] = {false, ...};
int g_iNicksRamboWeaponID[MAXPLAYERS + 1];
int g_iNickMagnumHitsPerClip[MAXPLAYERS + 1];
int g_iNickPrimarySavedClip[MAXPLAYERS + 1];
int g_iNickPrimarySavedAmmo[MAXPLAYERS + 1];
int g_iNickUpgradeAmmo[MAXPLAYERS + 1];
char g_strNickUpgradeType[32];
bool g_bNickStoresDroppedPistolAmmo[MAXPLAYERS + 1] = {false, ...};
int g_bNickGambedSelfReviveUses = 0;
int g_bNickGambedDivineInterventionUses = 0;
bool g_bNickGambleLockedBinds[MAXPLAYERS + 1] = {false, ...};
bool g_bNickReviveCooldown;
bool g_bNickHealCooldown;

// Louis
#define LOUIS_TELEPORT_TOTAL_CHARGES                    3
#define LOUIS_TELEPORT_MOVEMENT_SPEED                   8.0
#define LOUIS_TELEPORT_CHARGE_REGENERATE_TIME_LASER     17.0
#define LOUIS_TELEPORT_CHARGE_REGENERATE_TIME_NOLASER   7.0
#define LOUIS_TELEPORT_CHARGE_MAXED_REGENERATE_TIME     90.0
#define LOUIS_TELEPORT_BLINDNESS_ADDITIVE_AMOUNT        69
#define LOUIS_TELEPORT_BLINDNESS_DURATION               4100
#define LOUIS_TELEPORT_BLINDNESS_FADE_TIME              12.0
#define LOUIS_TELEPORT_BLINDNESS_STAY_FACTOR            1.5
#define LOUIS_TELEPORT_MOVEMENT_PENALTY_TIME            10.0
#define LOUIS_TELEPORT_MOVEMENT_PENALTY_AMOUNT          0.05
#define LOUIS_SPEED_MAX_LASER                           1.10
#define LOUIS_SPEED_MAX_NOLASER                         1.25
bool g_bLouisLaserModeActivated[MAXPLAYERS + 1] = {true, ...};
bool g_bLouisLaserModeToggleCooldown[MAXPLAYERS + 1] = {false, ...};
#define LOUIS_BONUS_DAMAGE_PER_LEVEL                    0.20
#define LOUIS_LASER_MODE_TOGGLE_COOLDOWN                5.0
#define LOUIS_BODY_DAMAGE_REDUCTION_PER_LEVEL_LASER     0.20
#define LOUIS_BODY_DAMAGE_REDUCTION_PER_LEVEL_NOLASER   0.10
#define LOUIS_BODY_DAMAGE_REDUCTION_PER_LEVEL_PISTOL    0.15
#define LOUIS_HEADSHOT_DMG_MULITPLIER_PER_LEVEL_LASER   0.05
#define LOUIS_HEADSHOT_DMG_MULITPLIER_PER_LEVEL_NOLASER 0.30
#define LOUIS_HEADSHOT_DMG_MULITPLIER_PER_LEVEL_PISTOL  0.20
#define LOUIS_HEADSHOT_SPEED_RETENTION_TIME_CI          60.0
#define LOUIS_HEADSHOT_SPEED_RETENTION_TIME_SI          60.0
#define LOUIS_STASHED_INVENTORY_MAX_PILLS               4
#define LOUIS_PILLS_USED_BONUS_DURATION                 90.0
#define LOUIS_PILLS_USED_BONUS_DAMAGE_PER_LEVEL         0.04
#define LOUIS_PILLS_USED_HEALTH_REDUCTION_PER_LEVEL     2
#define LOUIS_PILLS_USED_MAX_STACKS                     3
bool g_bLouisTeleportCoolingDown[MAXPLAYERS + 1] = {false, ...};
bool g_bLouisTeleportActive[MAXPLAYERS + 1] = {false, ...};
int g_iLouisTeleportChargeUses[MAXPLAYERS + 1] = {0, ...};
float g_fLouisTeleportLastUseGameTime[MAXPLAYERS + 1] = {0.0, ...};
int g_iLouisTeleportBlindnessAmount[MAXPLAYERS + 1] = {0, ...};
int g_iLouisTeleportMovementPenaltyStacks[MAXPLAYERS + 1] = {0, ...};
int g_iLouisCIHeadshotCounter[MAXPLAYERS + 1] = {0, ...};
int g_iLouisSIHeadshotCounter[MAXPLAYERS + 1] = {0, ...};
#define LOUIS_NEUROSURGEON_CI_CHANCE                    5     // Percent Chance
#define LOUIS_NEUROSURGEON_SI_CHANCE                    1     // Percent Chance
#define LOUIS_NEUROSURGEON_SI_XMR_REWARD_AMOUNT         3.0   // XMR
int g_iStashedInventoryPills[MAXPLAYERS + 1] = {0, ...};
int g_iPillsUsedStack[MAXPLAYERS + 1] = {0, ...};
bool g_bHealthBoostItemJustGivenByCheats[MAXPLAYERS + 1] = {false, ...};
bool g_bHealthBoostSlotWasEmptyOnLastPickUp[MAXPLAYERS + 1] = {false, ...};
bool g_bWareStationActive[MAXPLAYERS + 1];
bool g_bWareStationClientAlreadyServiced[MAXPLAYERS + 1][MAXPLAYERS + 1];
int g_iWareStationOwnerIDOfCurrentlyViewedStation[MAXPLAYERS + 1];
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
#define LOUIS_HEADSHOP_XMR_AMOUNT_MED_HAX               8.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_HAXOR_TEH_SERVER      8.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_HAK_TARGET            8.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_TIME_OUT              8.0
bool g_bLouisSpeedHaxEnabled;
bool g_bSpeedHaxInCooldown;
#define LOUIS_SPEED_HAX_MOVEMENT_MULTIPLIER             2.0
#define LOUIS_SPEED_HAX_DURATION                        7.0
#define LOUIS_SPEED_HAX_COOLDOWN_DURATION               300.0
bool g_bLouisMedHaxEnabled;
#define LOUIS_MED_HAX_USE_DURATION                      1
#define LOUIS_MED_HAX_DURATION                          15.0
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
#define LOUIS_TIME_OUT_DURATION                         30.0
#define LOUIS_TIME_OUT_COOLDOWN_DURATION                300.0
#define LOUIS_NOOBWIPE_COOLDOWN_DURATION                15.0
bool g_bNoobWipeCooldown;


