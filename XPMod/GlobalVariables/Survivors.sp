//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////     SURVIVOR VARIABLES     ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// New player buffs, until they reach max level (30)
// Damage Reduction for new Players
// This value at level 0, as leveling it goes lower.
// Reduction = ( iDmgAmount * ( NEW_PLAYER_MAX_DAMAGE_REDUCTION * (1.0 - (float(g_iClientLevel[iVictim]) / 30.0)) )
#define NEW_PLAYER_MAX_DAMAGE_REDUCTION     0.75
// Movement speed buff
// SpeedBuff = ( NEW_PLAYER_MAX_MOVEMENT_SPEED * ( 1.0 - (float(g_iClientLevel[iClient]) / 30.0) ) );
#define NEW_PLAYER_MAX_MOVEMENT_SPEED       0.15

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
new String:g_strCurrentWeaponCmdName[32];
new String:g_strNextWeaponCmdName[32];
new g_iReserveAmmo[MAXPLAYERS + 1];
new g_iAmmoOffset[MAXPLAYERS + 1];
new g_iActiveWeaponID[MAXPLAYERS + 1];
new g_iCurrentClipAmmo[MAXPLAYERS + 1];
new String:g_strCurrentWeapon[32];
new g_iOffset_Ammo[MAXPLAYERS + 1];
new g_iCurrentMaxClipSize[MAXPLAYERS + 1];
new String:g_strCurrentAmmoUpgrade[32];
//new String:g_strCheckAmmoUpgrade[32];
new g_iKitsUsed = 0;
new g_iSlapRunTimes[MAXPLAYERS + 1];			//for the slap timer for each iClient	//Remember to initialize this each time before use!
new Float:g_fMaxLaserAccuracy = 0.4;	        //max accuracy increase for survivors
new g_iPrimarySlotID[MAXPLAYERS + 1];
new g_iClientPrimaryClipSize[MAXPLAYERS + 1];   //g_iOffset_Clip1 for the clients primary weapon before addition of talents
new bool:g_bDivineInterventionQueued[MAXPLAYERS + 1];
new bool:g_bWasClientDownOnDeath[MAXPLAYERS + 1];
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
#define BILE_CLEANSING_COMPLETION_FRAME     60
new g_iBileCleansingKits[MAXPLAYERS + 1];
new g_iBileCleansingFrameTimeCtr[MAXPLAYERS + 1];

// Grappled Checks
new bool:g_bChargerGrappled[MAXPLAYERS + 1];
new bool:g_bSmokerGrappled[MAXPLAYERS + 1];
new bool:g_bJockeyGrappled[MAXPLAYERS + 1];
new bool:g_bHunterGrappled[MAXPLAYERS + 1];
new g_iChargerVictim[MAXPLAYERS + 1];
new g_iJockeyVictim[MAXPLAYERS + 1];    //g_iJockeyVictim[attacker] = victim;
new g_iHunterShreddingVictim[MAXPLAYERS + 1];

new g_iClientSurvivorMaxHealth[MAXPLAYERS + 1];		//Survivor max health for the iClient
new bool:g_bIsClientDown[MAXPLAYERS + 1] = false;
// Faster Shooting Variables
new g_iFastAttackingClientsArray[MAXPLAYERS + 1];
new bool:g_bSomeoneAttacksFaster;
new bool:g_bDoesClientAttackFast[MAXPLAYERS + 1];
// For calculating Temp Health
ConVar cvarPainPillsDecay;
float flPainPillsDecay = 0.27;

//Bill's Stuff (Support)/////////////////////////////////////////////////////////////////////////////////////////////////////////
new g_iBillTeamHealCounter[MAXPLAYERS + 1];
new g_iClientToHeal[MAXPLAYERS + 1] = 1;
new g_iCrawlSpeedMultiplier;
new g_iBillSprintChargeCounter[MAXPLAYERS + 1];
new g_iBillSprintChargePower[MAXPLAYERS + 1];
new bool:g_bBillSprinting[MAXPLAYERS + 1];
new bool:g_bCanDropPoopBomb[MAXPLAYERS + 1];
new g_iPoopBombOwnerID[MAXENTITIES + 1];
new g_iDropBombsTimes[MAXPLAYERS + 1];
//new Float:g_fBillSprintSpeed[MAXPLAYERS + 1];

//Rochelle's Stuff
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
new bool:g_bFirstShadowNinjaSwing[MAXPLAYERS + 1];
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
new g_iRopeCountDownTimer[MAXPLAYERS + 1];
new Float:g_xyzRopeEndLocation[MAXPLAYERS + 1][3];
new Float:g_xyzClientLocation[MAXPLAYERS + 1][3];
new Float:g_xyzRopeDistance[MAXPLAYERS + 1];
new Float:g_xyzOriginalRopeDistance[MAXPLAYERS + 1];


//Coach's Stuff
//For Coach's Jetpack
new bool:g_bIsFlyingWithJetpack[MAXPLAYERS + 1];
new g_iClientJetpackFuel;
new g_iClientJetpackFuelUsed[MAXPLAYERS + 1];
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
new bool:g_bUsingFireStorm[MAXPLAYERS + 1];
new g_iEllisMaxHealth[MAXPLAYERS + 1] = 100;
new g_iEllisSpeedBoostCounter[MAXPLAYERS + 1];
new bool:g_bWalkAndUseToggler[MAXPLAYERS + 1];
new Float:g_fEllisOverSpeed[MAXPLAYERS + 1];
new Float:g_fEllisBringSpeed[MAXPLAYERS + 1];
new Float:g_fEllisJamminSpeed[MAXPLAYERS + 1];
new bool:g_bCanEllisPrimaryCycle[MAXPLAYERS + 1];
new String:g_strEllisPrimarySlot1[512];
new String:g_strEllisPrimarySlot2[512];
new g_iEllisCurrentPrimarySlot[MAXPLAYERS + 1];
new g_iEllisPrimarySavedClipSlot1[MAXPLAYERS + 1];
new g_iEllisPrimarySavedClipSlot2[MAXPLAYERS + 1];
new g_iEllisPrimarySavedAmmoSlot1[MAXPLAYERS + 1];
new g_iEllisPrimarySavedAmmoSlot2[MAXPLAYERS + 1];
new g_iEllisJamminGrenadeCounter[MAXPLAYERS + 1];
new bool:g_bIsEllisInPrimaryCycle[MAXPLAYERS + 1];
//g_bIsEllisInPrimaryCycle[iClient]
new bool:g_bIsEllisCyclingEmptyWeapon[MAXPLAYERS + 1];
new g_iEllisUpgradeAmmoSlot1[MAXPLAYERS + 1];
new g_iEllisUpgradeAmmoSlot2[MAXPLAYERS + 1];
new String:g_strEllisUpgradeTypeSlot1[32];
new String:g_strEllisUpgradeTypeSlot2[32];
//new bool:g_bEllisHasCycled[MAXPLAYERS + 1];
new bool:g_bIsEllisLimitBreaking[MAXPLAYERS + 1];
new bool:g_bCanEllisLimitBreak[MAXPLAYERS + 1];
new bool:g_bEllisLimitBreakInCooldown[MAXPLAYERS + 1];
new bool:g_bEllisOverSpeedIncreased[MAXPLAYERS + 1];
new g_iEllisAdrenalineStack;

//Nicks Stuff
new bool:g_bNickIsStealingLife[MAXPLAYERS + 1][MAXPLAYERS + 1];	//g_bNickIsStealingLife[victim][attacker]
new g_iNickStealingLifeRuntimes[MAXPLAYERS + 1];
new g_iNickMaxHealth[MAXPLAYERS + 1];
new g_iNickResurrectUses = 0;
new bool:g_bCanNickSecondaryCycle[MAXPLAYERS + 1];
new String:g_strNickSecondarySlot1[512];
new String:g_strNickSecondarySlot2[512];
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
new g_iNickDesperateMeasuresStack;
//new g_iRamboWeaponID[MAXPLAYERS + 1];
//g_bIsNickInSecondaryCycle
//g_bCanNickZoomKit
//Drug Effects
new g_iDruggedRuntimesCounter[MAXPLAYERS + 1];
//Gambling
new bool:g_bNickIsInvisible[MAXPLAYERS + 1] = false;
new bool:g_bNickIsGettingBeatenUp[MAXPLAYERS + 1] = false;
new g_iNicksRamboWeaponID[MAXPLAYERS + 1];
new g_iNickSwindlerBonusHealth[MAXPLAYERS + 1];
new bool:g_bNickSwindlerHealthCapped[MAXPLAYERS + 1];
new g_iNickMagnumShotCount[MAXPLAYERS + 1];
new bool:g_bCanNickStampedeReload[MAXPLAYERS + 1];
new g_iNickMagnumShotCountCap[MAXPLAYERS + 1];
new g_iNickPrimarySavedClip[MAXPLAYERS + 1];
new g_iNickPrimarySavedAmmo[MAXPLAYERS + 1];
new g_iNickUpgradeAmmo[MAXPLAYERS + 1];
new String:g_strNickUpgradeType[32];
new String:g_strNickPrimarySaved[32];
new bool:g_bNickStoresDroppedPistolAmmo[MAXPLAYERS + 1] = false;


// Louis
#define LOUIS_TELEPORT_MOVEMENT_SPEED                   8.0
#define LOUIS_TELEPORT_CHARGE_REGENERATE_TIME           10.0
#define LOUIS_TELEPORT_CHARGE_MAXED_REGENERATE_TIME     90.0
#define LOUIS_TELEPORT_BLINDNESS_ADDITIVE_AMOUNT        86
#define LOUIS_TELEPORT_BLINDNESS_DURATION               4100
#define LOUIS_TELEPORT_BLINDNESS_FADE_TIME              12.0
#define LOUIS_TELEPORT_BLINDNESS_STAY_FACTOR            2.5
#define LOUIS_TELEPORT_MOVEMENT_PENALTY_TIME            20.0
#define LOUIS_TELEPORT_MOVEMENT_PENALTY_AMOUNT          0.05
#define LOUIS_SPEED_MAX                                 1.25
#define LOUIS_HEADSHOT_SPEED_RETENTION_TIME_CI          60.0
#define LOUIS_HEADSHOT_SPEED_RETENTION_TIME_SI          60.0
#define LOUIS_STASHED_INVENTORY_MAX_PILLS               4
#define LOUIS_PILLS_USED_BONUS_DURATION                 60.0
#define LOUIS_PILLS_USED_MAX_STACKS                     5
bool g_bLouisTeleportCoolingDown[MAXPLAYERS + 1] = false;
bool g_bLouisTeleportActive[MAXPLAYERS + 1] = false;
new g_iLouisTeleportChargeUses[MAXPLAYERS + 1] = 0;
new Float:g_fLouisTeleportLastUseGameTime[MAXPLAYERS + 1] = 0.0;
new g_iLouisTeleportBlindnessAmount[MAXPLAYERS + 1] = 0;
new g_iLouisTeleportMovementPenaltyStacks[MAXPLAYERS + 1] = 0;
new g_iLouisCIHeadshotCounter[MAXPLAYERS + 1] = 0;
new g_iLouisSIHeadshotCounter[MAXPLAYERS + 1] = 0;
#define LOUIS_NEUROSURGEON_CI_CHANCE                    5   // Percent Chance
#define LOUIS_NEUROSURGEON_SI_CHANCE                    1   // Percent Chance
#define LOUIS_NEUROSURGEON_SI_XMR_REWARD_AMOUNT         6.9 // XMR
new g_iStashedInventoryPills[MAXPLAYERS + 1] = 0;
new g_iPillsUsedStack[MAXPLAYERS + 1] = 0;
bool g_bHealthBoostItemJustGivenByCheats[MAXPLAYERS + 1] = false;
bool g_bHealthBoostSlotWasEmptyOnLastPickUp[MAXPLAYERS + 1] = false;
bool g_bWareStationActive[MAXPLAYERS + 1];
bool g_bWareStationClientAlreadyServiced[MAXPLAYERS + 1][MAXPLAYERS + 1];
new g_iWareStationOwnerIDOfCurrentlyViewedStation[MAXPLAYERS + 1];
float g_xyzWarezStationLocation[MAXPLAYERS + 1][3];
float g_fWarezStationSpeedBoost[MAXPLAYERS + 1];
float g_fLouisXMRWallet[MAXPLAYERS + 1];
#define LOUIS_HEADSHOT_XMR_AMOUNT_CI                    0.1
#define LOUIS_HEADSHOT_XMR_AMOUNT_SI                    0.5
#define LOUIS_HEADSHOP_ITEM_SPEED_HAX                   1
#define LOUIS_HEADSHOP_ITEM_MED_HAX                     2
#define LOUIS_HEADSHOP_ITEM_NUB_WIPE                    4
#define LOUIS_HEADSHOP_ITEM_HAK_TARGET                  4
#define LOUIS_HEADSHOP_ITEM_TIME_OUT                    5
#define LOUIS_HEADSHOP_ITEM_HAXOR_TEH_SERVER            6
#define LOUIS_HEADSHOP_XMR_AMOUNT_SPEED_HAX             3.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_MED_HAX               5.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_NUB_WIPE              4.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_HAK_TARGET            6.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_TIME_OUT              8.0
#define LOUIS_HEADSHOP_XMR_AMOUNT_HAXOR_TEH_SERVER      7.0
bool g_bLouisSpeedHaxEnabled;
bool g_bSpeedHaxInCooldown;
#define LOUIS_SPEED_HAX_MOVEMENT_MULTIPLIER             2.0
#define LOUIS_SPEED_HAX_DURATION                        10.0
#define LOUIS_SPEED_HAX_COOLDOWN_DURATION               300.0
bool g_bLouisMedHaxEnabled;
#define LOUIS_MED_HAX_USE_DURATION                      0
#define LOUIS_MED_HAX_DURATION                          30.0
bool g_bIsPLayerHacked[MAXPLAYERS + 1];
#define LOUIS_HACK_TARGET_DURATION                      10.0
bool g_bHackTheServerInCooldown;
#define LOUIS_HAK_TEH_SERVER_DURATION                   5.0     // The actual duration is a function of this...
#define LOUIS_HAK_TEH_SERVER_TIME_SCALE_FACTOR          0.25    // multiplied by 1 over this
#define LOUIS_HAK_TEH_SERVER_COOLDOWN_DURATION          300.0
bool g_bTimeOutInCooldown;
bool g_bInfectedBindsDisabled;
#define LOUIS_TIME_OUT_DURATION                         30.0
#define LOUIS_TIME_OUT_COOLDOWN_DURATION                300.0


