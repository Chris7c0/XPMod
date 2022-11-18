//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////     INFECTED VARIABLES     ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

new g_iClientInfectedClass1[MAXPLAYERS + 1]	= {UNKNOWN_INFECTED, ...};
new g_iClientInfectedClass2[MAXPLAYERS + 1]	= {UNKNOWN_INFECTED, ...};
new g_iClientInfectedClass3[MAXPLAYERS + 1]	= {UNKNOWN_INFECTED, ...};
new String:g_strClientInfectedClass1[MAXPLAYERS + 1][10]; 
new String:g_strClientInfectedClass2[MAXPLAYERS + 1][10]; 
new String:g_strClientInfectedClass3[MAXPLAYERS + 1][10];
new bool:g_iInfectedConvarsSet[MAXPLAYERS + 1];

// Dismounting
bool g_bReadyForDismountButtonPress[MAXPLAYERS + 1];

// Ghost Spawn Capturing
new bool:g_bCanBeGhost[MAXPLAYERS + 1];
new bool:g_bIsGhost[MAXPLAYERS + 1];

// CI hit max damage from survivor hit (meant for melee)
#define CI_MAX_DAMAGE_PER_HIT   500.0
// Uncommon Infected (Note: these correspond to their model string index)
#define UNCOMMON_CI_NONE        -1
#define UNCOMMON_CI_RANDOM      -2
#define UNCOMMON_CI_JIMMY       0
#define UNCOMMON_CI_CLOWN       1
#define UNCOMMON_CI_CEDA        2
#define UNCOMMON_CI_MUD         3
#define UNCOMMON_CI_RIOT        4
#define UNCOMMON_CI_ROADCREW    5
// Common Infected Enhancements
// (Combined Survivor Levels / 120) * ENHANCEMENT_CI_CHANCE_MAX
// 0.1 would be 10% chance if all level 30s, 2.5% (2.5 in 100) chance if 1 level 30
// 0.01 would be 1% chance if all level 30s, 0.25% (1 in 400) chance if 1 level 30
#define ENHANCEMENT_CI_CHANCE_MAX   0.1
// Big Small (health + size) options and constraints
#define CI_SMALL_OR_BIG_RANDOM      -1
#define CI_SMALL_OR_BIG_NONE        0
#define CI_REALLY_SMALL             1
#define CI_SMALL                    2
#define CI_BIG                      3
#define CI_REALLY_BIG               4
#define CI_REALLY_BIG_JIMMY         5
// Size
#define CI_REALLY_SMALL_SIZE        0.33
#define CI_SMALL_MIN_SIZE           0.60
#define CI_SMALL_MAX_SIZE           0.80
#define CI_BIG_MIN_SIZE             1.10
#define CI_BIG_MAX_SIZE             1.35
#define CI_REALLY_BIG_SIZE          1.50
#define CI_REALLY_BIG_JIMMY_SIZE    1.6
// Health
#define CI_REALLY_SMALL_HEALTH      30
#define CI_SMALL_MIN_HEALTH         100
#define CI_SMALL_MAX_HEALTH         200
#define CI_BIG_MIN_HEALTH           1000
#define CI_BIG_MAX_HEALTH           2000
#define CI_REALLY_BIG_HEALTH        3000
#define CI_REALLY_BIG_JIMMY_HEALTH  8000
// Enhanced CI Types
#define ENHANCED_CI_TYPE_RANDOM     -1
#define ENHANCED_CI_TYPE_NONE       0
#define ENHANCED_CI_TYPE_FIRE       1
#define ENHANCED_CI_TYPE_ICE        2
#define ENHANCED_CI_TYPE_NECRO      3
#define ENHANCED_CI_TYPE_VAMPIRIC   4
// Enhanced CI Array List Properties
#define ENHANCED_CI_ENTITY_ID		0
#define ENHANCED_CI_TYPE			1
// List that contains enhanced CI entities and their abilities properties
new ArrayList:g_listEnhancedCIEntities;
// The size of the above array list
#define ENHANCED_CI_ENTITIES_ARRAY_LIST_SIZE       2
// Enhanced CI Type Specific Variables
// Fire CI
#define ENHANCED_CI_FIRE_BURN_DURATION              2.5
// Ice CI
#define ENHANCED_CI_ICE_FREEZE_DURATION             3.0
// Necro CI
#define ENHANCED_CI_NECRO_SPAWN_CHANCE              0.50
#define ENHANCED_CI_NECRO_SPAWN_UNCOMMON_CHANCE     0.33
#define ENHANCED_CI_NECRO_SPAWN_BIG_SMALL_CHANCE    0.66
#define ENHANCED_CI_NECRO_SPAWN_ENHANCED_CHANCE     0.66
// Vampiric CI
#define ENHANCED_CI_VAMPIRIC_LIFE_STEAL_AMOUNT      250

// Smoker
#define SMOKER_STARTING_MAX_HEALTH                      250
// #define SMOKER_BONUS_MAX_HEALTH_PER_LEVEL               2
#define SMOKER_HEALTH_REGEN_PER_FRAME                   2
#define SMOKER_DEFAULT_TONGUE_COOLDOWN                  15.0
#define SMOKER_COOLDOWN_REDUCTION_EVERY_OTHER_LEVEL     1.0
// Global Smoker Tongue Buffs
#define CONVAR_SMOKER_TONGUE_RANGE_DEFAULT              750
#define CONVAR_SMOKER_TONGUE_RANGE_BUFF_PER_LEVEL       57
#define CONVAR_SMOKER_TONGUE_FLY_SPEED_DEFAULT          1000
#define CONVAR_SMOKER_TONGUE_FLY_SPEED_BUFF_PER_LEVEL   200
#define CONVAR_SMOKER_TONGUE_DRAG_SPEED_DEFAULT         175
#define CONVAR_SMOKER_TONGUE_DRAG_SPEED_BUFF_PER_LEVEL  27
#define CONVAR_SMOKER_TONGUE_HEALTH_DEFAULT             100
#define CONVAR_SMOKER_TONGUE_HEALTH_BUFF_PER_LEVEL      20
new g_iChokingVictim[MAXPLAYERS + 1];
bool g_bSmokerSmokeScreenOnCooldown[MAXPLAYERS + 1];
#define SMOKER_SMOKE_VICTIM_DURATION                    15.0
#define SMOKER_SMOKE_VICTIM_COOLDOWN_DURATION           30.0
bool g_bSmokerCloakingJustToggled[MAXPLAYERS + 1];
bool g_bSmokerIsCloaked[MAXPLAYERS + 1];
bool g_bSmokerVictimGlowDisabled[MAXPLAYERS + 1];
bool SetMoveTypeBackToNormalOnNextGameFrame[MAXPLAYERS + 1];
new bool:g_bIsElectrocuting[MAXPLAYERS + 1];
new bool:g_bIsTarFingerVictim[MAXPLAYERS + 1];
#define SMOKER_DOPPELGANGER_MAX_CLONES                  2
#define SMOKER_DOPPELGANGER_DURATION                    15.0
#define SMOKER_DOPPELGANGER_REGEN_PERIOD                30.0
#define SMOKER_DOPPELGANGER_COOLDOWN_PERIOD             0.5
#define SMOKER_DOPPELGANGER_FADE_IN_PERIOD              2.5
#define SMOKER_DOPPELGANGER_CI_SPAWN_COUNT              5
float g_fNextSmokerDoppelgangerRegenTime[MAXPLAYERS + 1];
new g_iSmokerDoppelgangerCount[MAXPLAYERS + 1];
bool g_bSmokerDoppelgangerCoolingDown[MAXPLAYERS + 1];
float g_iSmokerDoppelgangerFadeRunTime[MAXENTITIES + 1];
new g_iSmokerInfectionCloudEntity[MAXPLAYERS + 1];
new bool:g_bHasSmokersPoisonCloudOut[MAXPLAYERS + 1];
new Float:g_xyzPoisonCloudOriginArray[MAXPLAYERS + 1][3];
bool:g_bTeleportCoolingDown[MAXPLAYERS + 1];
bool:g_bElectrocutionCooldown[MAXPLAYERS + 1];
bool:g_bIsEntangledInSmokerTongue[MAXPLAYERS + 1];
new g_iEntangledSurvivorModelIndex[MAXPLAYERS + 1];
new g_iEntangledTongueModelIndex[MAXPLAYERS + 1];
int g_iSmokerSmokeCloudPlayer = -1;
int g_iSmokerInSmokeCloudLimbo = -1;
new g_iSmokeCloudLimboTicks[MAXPLAYERS + 1];
bool g_bSmokerSmokeCloudInCooldown;
bool g_bIsPlayerInSmokerSmokeCloud[MAXPLAYERS + 1];
int g_iSmokerSmokeCloudVictimCount;
int g_iSmokerSmokeCloudTicksPool;
int g_iSmokerSmokeCloudTicksUsed;
#define SMOKER_SMOKE_CLOUD_GLOBAL_COOLDOWN_DURATION         180.0
#define SMOKER_SMOKE_CLOUD_TICK_RATE                        0.1
#define SMOKER_SMOKE_CLOUD_TICK_COUNT_MAX_POOL_SIZE         40000   //Max amount of smoker smoke cloud time
#define SMOKER_SMOKE_CLOUD_TICK_COUNT_STARTING_POOL         15000   //Determines duration which is Tick Count * Tick Rate / Tick Use Rate
#define SMOKER_SMOKE_CLOUD_TICK_USE_RATE                    100     //Amount of Ticks used per timer tick rate
#define SMOKER_SMOKE_CLOUD_TICK_GAIN_PER_SURVIVOR_PLAYER    20
#define SMOKER_SMOKE_CLOUD_TICK_GAIN_PER_SURVIVOR_BOT       10
int g_iSmokerSmokeCloudStage;
#define SMOKER_SMOKE_CLOUD_USAGE_STAGE_1                    0
#define SMOKER_SMOKE_CLOUD_USAGE_STAGE_2                    15000
#define SMOKER_SMOKE_CLOUD_USAGE_STAGE_3                    30000
#define SMOKER_SMOKE_CLOUD_SPAWN_CI_ON_PLAYER_INTERVAL      7.4
#define SMOKER_SMOKE_CLOUD_SPAWN_CI_ON_PLAYER_AMOUNT_S1     1
#define SMOKER_SMOKE_CLOUD_SPAWN_CI_ON_PLAYER_AMOUNT_S2     1
#define SMOKER_SMOKE_CLOUD_SPAWN_CI_ON_PLAYER_AMOUNT_S3     2
#define SMOKER_SMOKE_CLOUD_SPAWN_CI_S3_JIMMY_CHANCE         10
bool g_bSmokeCloudVictimCanCISpawnOn[MAXPLAYERS + 1];
#define SMOKER_SMOKE_CLOUD_RADIUS                           375.0 // (45 ft radius, 90 ft diameter)
#define SMOKER_SMOKE_CLOUD_TARGETED_PLAYER_TICK_RATE        1.0
#define SMOKER_SMOKE_CLOUD_BLIND_AMOUNT_MIN                 175
#define SMOKER_SMOKE_CLOUD_BLIND_AMOUNT_MAX                 205
#define SMOKER_SMOKE_CLOUD_INFECTED_HEAL_RATE_PER_TICK      150
#define SMOKER_UNTANGLE_PLAYER_DISTANCE                     100.0
new g_iTarFingerVictimBlindAmount[MAXPLAYERS + 1];
#define SMOKER_TAR_FINGERS_BLIND_FADE_DURATION_VALUE        4500
#define SMOKER_TAR_FINGERS_BLIND_DURATION                   10.0
#define SMOKER_TAR_FINGERS_BLIND_AMOUNT_START               225
#define SMOKER_TAR_FINGERS_BLIND_AMOUNT_INCREMENT           25
#define SMOKER_TAR_FINGERS_BLIND_AMOUNT_MAX                 255
//For Teleport
#define SMOKER_TELEPORT_COOLDOWN_PERIOD             5.0
// new Float:g_fMapsMaxTeleportHeight;
new g_iSmokerTransparency[MAXPLAYERS + 1];
new Float:g_fTeleportOriginalPositionX[MAXPLAYERS + 1];
new Float:g_fTeleportOriginalPositionY[MAXPLAYERS + 1];
new Float:g_fTeleportOriginalPositionZ[MAXPLAYERS + 1];
new Float:g_fTeleportEndPositionX[MAXPLAYERS + 1];
new Float:g_fTeleportEndPositionY[MAXPLAYERS + 1];
new Float:g_fTeleportEndPositionZ[MAXPLAYERS + 1];
bool g_bBlockBotFromShooting[MAXPLAYERS + 1];

// Boomer
new bool:g_bIsSuicideBoomer[MAXPLAYERS + 1];
new bool:g_bIsSuicideJumping[MAXPLAYERS + 1];
new bool:g_bIsBoomerVomiting[MAXPLAYERS + 1];
new bool:g_bIsServingHotMeal[MAXPLAYERS + 1];
new g_iShowSurvivorVomitCounter[MAXPLAYERS + 1];
new g_iVomitVictimAttacker[MAXPLAYERS + 1];
new bool:g_bIsSurvivorVomiting[MAXPLAYERS + 1];
new bool:g_bNowCountingVomitVictims[MAXPLAYERS + 1];
new g_iVomitVictimCounter[MAXPLAYERS + 1];
new bool:g_bIsSuperSpeedBoomer[MAXPLAYERS + 1];
new bool:g_bCommonInfectedDoMoreDamage;

// Hunter
#define HUNTER_STARTING_MAX_HEALTH                  250
bool g_bHunterIsLunging[MAXPLAYERS + 1];
int g_iHunterLungeState[MAXPLAYERS + 1];
bool g_bHunterLungeEndDelayCheck[MAXPLAYERS + 1];
#define HUNTER_LUNGE_STATE_NONE                     0
#define HUNTER_LUNGE_STATE_BASE                     1
#define HUNTER_LUNGE_STATE_FLOAT                    2
#define HUNTER_LUNGE_STATE_DASH                     3
#define HUNTER_LUNGE_MOVEMENT_SPEED_BASE            1.4     // Controls the gravity drop as well as how fast
#define HUNTER_LUNGE_MOVEMENT_SPEED_FLOAT           0.9     // Controls the gravity drop as well as how fast
#define HUNTER_LUNGE_MOVEMENT_SPEED_DASH            1.65    // Controls the gravity drop as well as how fast
#define HUNTER_LUNGE_VELOCITY_MULTIPLIER_START      1.1     // 1.0 + X
#define HUNTER_LUNGE_VELOCITY_MULTIPLIER_FLOAT      0.005   // 1.0 - X
#define HUNTER_LUNGE_VELOCITY_FLOAT_Z_PUSH_START    -150.0  // Z velocity required before start pushing hunter up
#define HUNTER_LUNGE_VELOCITY_ADDITION_FLOAT_SPEED  12.0    // OGF additional Up direction push (Z)
#define HUNTER_LUNGE_VELOCITY_ADDITION_DASH_SPEED   70.0    // OGF additional Forward direction push (X & Y)
#define HUNTER_LUNGE_VELOCITY_SPEED_CAP_DASH        1350.0  // Velocity cap to limit insane speeds from dash
#define HUNTER_LUNGE_EXTRA_DAMAGE_DISTANCE_MIN      150     // The min amount of distance (FT) before extra damage
#define HUNTER_LUNGE_EXTRA_DAMAGE_DISTANCE_MAX      350     // The max amount of distance (FT) to get all extra damage
#define HUNTER_LUNGE_EXTRA_DAMAGE_MAX               20      // The max amount of extra damage if max distance reached
int g_iBloodLustStage[MAXPLAYERS + 1];                      // Blood Lust Stage per client
int g_iBloodLustMeter[MAXPLAYERS + 1];                      // Blood Lust Meter per client
#define BLOOD_LUST_METER_GAINED_ON_VICTIM           10      // Blood Lust Meter gained per scratch on victim (to 100)
#define BLOOD_LUST_METER_GAINED_OFF_VICTIM          50      // Blood Lust Meter gained per scratch off victim (to 100)
#define BLOOD_LUST_METER_GAINED_VISIBILITY_SCALE_FACTOR 25.0       // Blood Lust Meter gained while visible to survivors in stealth mode
#define BLOOD_LUST_RESET_TIMER_DURATION             30.0    // Blood Lust Meter reset timer duration
#define BLOOD_LUST_SPEED_BOOST_PER_STAGE            0.60    // Speed boost per Blood Lust stage
#define BLOOD_LUST_STEALTH_PER_STAGE                0.3     // % Non Lunge Stealth per Blood Lust stage
#define BLOOD_LUST_EXTRA_SHRED_DAMAGE_PER_STAGE     1       // Speed boost per Blood Lust stage
float g_fLastHunterPosition[MAXPLAYERS + 1][3];             // Last Hunter position for Blood Lust meter gain
bool g_bIsCloakedHunter[MAXPLAYERS + 1];
int g_iHunterCloakCounter[MAXPLAYERS + 1];
bool g_bCanHunterDismount[MAXPLAYERS + 1];
#define HUNTER_POISON_VICTIM_SPEED                  0.25
bool g_bCanHunterPoisonVictim[MAXPLAYERS + 1];
bool g_bIsHunterReadyToPoison[MAXPLAYERS + 1];
int g_iHunterPounceDamageCharge[MAXPLAYERS + 1];                            
bool g_bIsHunterPoisoned[MAXPLAYERS + 1];
int g_iHunterPoisonRunTimesCounter[MAXPLAYERS + 1];
bool g_bHasInfectedHealthBeenSet[MAXPLAYERS + 1];
bool g_bHunterLethalPoisoned[MAXPLAYERS + 1];
float g_fHunterImmobilityZone[MAXPLAYERS + 1][3];
bool g_bIsInImmobilityZone[MAXPLAYERS + 1];
bool g_bIsImmobilityZoneOnGlobalCooldown;
#define HUNTER_IMMOBILITY_ZONE_RADIUS               150.0
#define HUNTER_IMMOBILITY_ZONE_DURATION             30.0
#define HUNTER_IMMOBILITY_ZONE_GLOBAL_COOLDOWN      120.0
#define HUNTER_IMMOBILITY_ZONE_SPEED                0.15

// Spitter
new bool:g_bBlockGooSwitching[MAXPLAYERS + 1];
new bool:g_bJustSpawnedWitch[MAXPLAYERS + 1];
new g_iGooType[MAXPLAYERS + 1];
new bool:g_bCanConjureWitch[MAXPLAYERS + 1];
new bool:g_bHasDemiGravity[MAXPLAYERS + 1];
new g_iHallucinogenRuntimesCounter[MAXPLAYERS + 1];
new bool:g_bIsHallucinating[MAXPLAYERS + 1];
new g_iViralInfector[MAXPLAYERS + 1];
new g_iViralRuntimesCounter[MAXPLAYERS + 1];
new bool:g_bIsImmuneToVirus[MAXPLAYERS + 1];
new bool:g_bCanBePushedByRepulsion[MAXPLAYERS + 1];
new bool:g_bIsStealthSpitter[MAXPLAYERS + 1];
new g_iStealthSpitterChargePower[MAXPLAYERS + 1];
new g_iStealthSpitterChargeMana[MAXPLAYERS + 1];
new Float:g_xyzWitchConjureLocation[MAXPLAYERS + 1][3];
//new Float:g_fAdhesiveAffectCase[MAXPLAYERS + 1];
new Float:g_fAdhesiveAffectAmount[MAXPLAYERS + 1];
//Spitter Goo Types
#define GOO_ADHESIVE		0
#define GOO_FLAMING			1
#define GOO_MELTING			2
#define GOO_DEMI			3
#define GOO_REPULSION		4
#define GOO_VIRAL			5
// Bag of Spits (BIND 1)
#define BAG_OF_SPITS_NONE           -1
#define BAG_OF_SPITS_MINI_ARMY      0
#define BAG_OF_SPITS_MUSCLE_CREW    1
#define BAG_OF_SPITS_ENHANCED_JIMMY 2
#define BAG_OF_SPITS_NECROFEASTER   3
#define BAG_OF_SPITS_KILLER_KLOWNS  4

#define BAG_OF_SPITS_SPIT_COUNT     5
new g_iBagOfSpitsSelectedSpit[MAXPLAYERS + 1] = {BAG_OF_SPITS_NONE, ...};


// Jockey
bool:g_bCanJockeyPee[MAXPLAYERS + 1] = {true, ...};
bool:g_bJockeyPissVictim[MAXPLAYERS + 1] = {true, ...};
bool:g_bCanJockeyCloak[MAXPLAYERS + 1] = {true, ...};
bool:g_bJockeyIsRiding[MAXPLAYERS + 1] = {false, ...};
g_iJockeysVictim[MAXPLAYERS + 1];
bool:g_bCanJockeyJump[MAXPLAYERS + 1] = {false, ...};
Float:g_fJockeyRideSpeed[MAXPLAYERS + 1] = {1.0, ...};
Float:g_fJockeyRideSpeedVanishingActBoost[MAXPLAYERS + 1] = {0.0, ...};
#define JOCKEY_PISS_CONVERSION_RADIUS           200.0
//#define JOCKEY_PISS_SPAWN_JIMMY_CHANCE       10 //%


// Charger
new bool:g_bIsChargerCharging[MAXPLAYERS +1];
new bool:g_bIsSpikedCharged[MAXPLAYERS +1];
new bool:g_bCanChargerSpikedCharge[MAXPLAYERS +1];
new g_iSpikedChargeCounter[MAXPLAYERS + 1];
new bool:g_bIsHillbillyEarthquakeReady[MAXPLAYERS + 1];
new bool:g_bIsSuperCharger[MAXPLAYERS + 1];
new bool:g_bCanChargerSuperCharge[MAXPLAYERS + 1];
new bool:g_bChargerCarrying[MAXPLAYERS + 1];
new bool:g_bIsChargerHealing[MAXPLAYERS + 1];
new bool:g_bCanChargerEarthquake[MAXPLAYERS +1];

// Tank
#define TANK_BURN_DURATION                                  15.0
new g_iTankCounter;
bool g_bIsFrustratedTank[MAXPLAYERS +1];
float g_fFrustratedTankTransferHealthPercentage;
bool g_bTankTakeOverBot[MAXPLAYERS +1];
bool g_bTankHealthJustSet[MAXPLAYERS +1];
#define TANK_FRUSTRATION_TIME_IN_SECONDS                    90
// The calculated amount of starting HP multiplier for scaling to skill level of survivors
new Float:g_fTankStartingHealthMultiplier[MAXPLAYERS + 1];
#define TANK_STARTING_HEALTH_MULTIPLIER_MIN                 0.5
#define TANK_STARTING_HEALTH_MULTIPLIER_MAX                 1.0
// Required level to get tank health max
// 120 would require a team of 4 (4x30) before getting max tank health.
// 90 would require a team of 3 (3x30) before getting max tank health.
#define TANK_STARTING_HEALTH_REQUIRED_TEAM_LEVEL_FOR_MAX    60
new bool:g_bTankStartingHealthXPModSpawn;
#define TANK_STARTING_HEALTH_MULTIPLIER_XPMOD_SPAWN         0.33
// The amount of HP loss before a XPMod tank type is automatically selected for the player
#define TANK_AUTOMATIC_SELECT_HP_LOSS   1000
#define TANK_AUTOMATIC_SELECT_TYPE      TANK_FIRE
new bool:g_bTankOnFire[MAXPLAYERS + 1];     // Prevents constant XP rewarding

//Chosen Tank Talents
#define TANK_NOT_CHOSEN		0
#define TANK_FIRE			1
#define TANK_ICE			2
#define TANK_NECROTANKER    3
#define TANK_VAMPIRIC       4
// Tank Rock Types
#define TANK_ROCK_TYPE_UNKNOWN		0
#define TANK_ROCK_TYPE_GENERIC		1
#define TANK_ROCK_TYPE_ICE 			2
#define TANK_ROCK_TYPE_FIRE			3
#define TANK_ROCK_TYPE_NECROTANKER  4
// Tank Rock Type storage in the 
#define TANK_ROCK_ENTITY_ID			0
// Tank Rock Thrower (Owner)
#define TANK_ROCK_OWNER_ID			1
// Tank Rock Type storage in the
#define TANK_ROCK_TYPE				2
#define TANK_ROCK_PARTICLE_TRAIL	3
// Tank Rock Entities that stores rock types
new ArrayList:g_listTankRockEntities;
// The size of the above array list
#define TANK_ROCK_ENTITIES_ARRAY_LIST_SIZE 4


// Fire Tank
#define TANK_HEALTH_FIRE                            11000
#define FIRE_TANK_FIRE_PUNCH_COOLDOWN_DURATION      5.0
new g_iFireDamageCounter[MAXPLAYERS + 1];
new bool:g_bFireTankAttackCharged[MAXPLAYERS + 1];
new bool:g_bBlockTankFirePunchCharge[MAXPLAYERS + 1];
//new bool:g_bFireTankBaseSpeedIncreased[MAXPLAYERS + 1];
new Float:g_fFireTankExtraSpeed[MAXPLAYERS + 1];
// Ice Tank
#define TANK_HEALTH_ICE                                 14000
#define TANK_ICE_REGEN_RATE                             40
#define TANK_FIRE_DAMAGE_IN_FIRE                        350
#define TANK_FIRE_DAMAGE_FIRE_BULLETS_ADD_MULTIPLIER    1.5     // Adds this multiplier value to the damage
#define TANK_ICE_FREEZE_DURATION_PUNCH                  5.0
#define TANK_ICE_FREEZE_DURATION_ROCK_INDIRECT          6.0
#define TANK_ICE_FREEZE_DURATION_ROCK_DIRECT            10.0
#define TANK_ICE_FREEZE_COOLDOWN_AFTER_UNFREEZE         7.0
#define TANK_ICE_ROCK_FREEZE_INDIRECT_HIT_RADIUS        350.0
#define TANK_ICE_COLD_SLOW_AURA_RADIUS                  400.0
#define TANK_ICE_COLD_SLOW_AURA_SPEED_REDUCE_AMOUNT     0.75    // This will set their speed to 1.0 - this speed reduce amount
#define TANK_ICE_COLD_SLOW_AURA_HIT_DISABLE_DURATION    5.0     // The amount of time to disable the cold aura
new g_iIceTankLifePool[MAXPLAYERS + 1];
bool g_bShowingIceSphere[MAXPLAYERS + 1];
bool g_bFrozenByTank[MAXPLAYERS + 1];
bool g_bBlockTankFreezing[MAXPLAYERS + 1];
float g_fIceTankColdAuraSlowSpeedReduction[MAXPLAYERS + 1];
bool g_bIceTankColdAuraDisabled[MAXPLAYERS + 1];
new Float:g_fTankHealthPercentage[MAXPLAYERS + 1];
new g_iTankCharge[MAXPLAYERS + 1];
new Float:g_xyzClientTankPosition[MAXPLAYERS + 1][3];
// NecroTanker
#define TANK_HEALTH_NECROTANKER                     6660
#define NECROTANKER_MAX_HEALTH                      13666
#define NECROTANKER_CONSUME_COMMON_HP               250
#define NECROTANKER_CONSUME_UNCOMMON_HP             500
#define NECROTANKER_CONSUME_SI_HP                   1000    //Currently not used
#define NECROTANKER_MANA_POOL_SIZE                  100
#define NECROTANKER_MANA_GAIN_PUNCH                 30
#define NECROTANKER_MANA_COST_SUMMON_NORMAL_CI      2
#define NECROTANKER_MANA_COST_SUMMON_ENHANCED_CI    5
#define NECROTANKER_MANA_COST_BOOMER_THROW          30
#define NECROTANKER_BOOMER_THROW_ABILITY_COOLDOWN   10.0
#define NECROTANKER_ENHANCE_CI_CHANCE_THROW         33
#define NECROTANKER_ENHANCE_CI_CHANCE_PUNCH         33
new g_iNecroTankerManaPool[MAXPLAYERS + 1];
// Vampiric Tank
#define TANK_HEALTH_VAMPIRIC                            8000
#define VAMPIRIC_TANK_LIFESTEAL_MULTIPLIER              8
#define VAMPIRIC_TANK_LIFESTEAL_INCAP_MULTIPLIER        12
#define VAMPIRIC_TANK_MELEE_DMG_TAKEN_MULTIPLIER        3
#define VAMPIRIC_TANK_GUN_DMG_TAKEN_MULTIPLIER          0.333333
#define VAMPIRIC_TANK_WING_FLAP_UP_VELOCITY             600.0
#define VAMPIRIC_TANK_WING_DASH_VELOCITY                800.0
#define VAMPIRIC_TANK_WING_DASH_COOLDOWN                13.0
#define VAMPIRIC_TANK_STAMINA_MAX                       600
#define VAMPIRIC_TANK_STAMINA_DEPLETION_FLAP            30
#define VAMPIRIC_TANK_STAMINA_DEPLETION_DASH            60
#define VAMPIRIC_TANK_STAMINA_REGENERATION_DELAY        2.0
#define VAMPIRIC_TANK_STAMINA_REGENERATION_RATE         1       // Per GameFrame (30 FPS)
bool g_bCanFlapVampiricTankWings[MAXPLAYERS + 1];
bool g_bIsVampiricTankFlying[MAXPLAYERS + 1];
bool g_bCanVampiricTankWingDash[MAXPLAYERS + 1];
new g_iVampiricTankWingDashChargeCount[MAXPLAYERS + 1];
new g_iVampiricTankStamina[MAXPLAYERS + 1];
bool g_bVampiricTankCanRechargeStamina[MAXPLAYERS + 1];