//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////     INFECTED VARIABLES     ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

new g_iClientInfectedClass1[MAXPLAYERS + 1]	= UNKNOWN_INFECTED;
new g_iClientInfectedClass2[MAXPLAYERS + 1]	= UNKNOWN_INFECTED;
new g_iClientInfectedClass3[MAXPLAYERS + 1]	= UNKNOWN_INFECTED;
new String:g_strClientInfectedClass1[MAXPLAYERS + 1][10]; 
new String:g_strClientInfectedClass2[MAXPLAYERS + 1][10]; 
new String:g_strClientInfectedClass3[MAXPLAYERS + 1][10];
new bool:g_iInfectedConvarsSet[MAXPLAYERS + 1];

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
#define ENCHANCED_CI_ENTITIES_ARRAY_LIST_SIZE       2
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
new g_iMaxTongueLength;
new g_iMaxDragSpeed;
new g_iChokingVictim[MAXPLAYERS + 1];
new bool:g_bIsElectricuting[MAXPLAYERS + 1];
new bool:g_bIsSmokeInfected[MAXPLAYERS + 1];
new bool:g_bIsSmokeEntityOff;
new g_iSmokerInfectionCloudEntity[MAXPLAYERS + 1];
new bool:g_bHasSmokersPoisonCloudOut[MAXPLAYERS + 1];
new Float:g_xyzPoisonCloudOriginArray[MAXPLAYERS + 1][3];
new bool:g_bTeleportCoolingDown[MAXPLAYERS + 1];
new bool:g_bElectricutionCooldown[MAXPLAYERS + 1];
//For Teleport
new Float:g_fMapsMaxTeleportHeight;
new g_iSmokerTransparency[MAXPLAYERS + 1];
new Float:g_fTeleportOriginalPositionX[MAXPLAYERS + 1];
new Float:g_fTeleportOriginalPositionY[MAXPLAYERS + 1];
new Float:g_fTeleportOriginalPositionZ[MAXPLAYERS + 1];
new Float:g_fTeleportEndPositionX[MAXPLAYERS + 1];
new Float:g_fTeleportEndPositionY[MAXPLAYERS + 1];
new Float:g_fTeleportEndPositionZ[MAXPLAYERS + 1];

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
new bool:g_bIsCloakedHunter[MAXPLAYERS + 1];
new g_iHunterCloakCounter[MAXPLAYERS + 1];
new bool:g_bCanHunterDismount[MAXPLAYERS + 1];
new bool:g_bCanHunterPoisonVictim[MAXPLAYERS + 1];
new bool:g_bIsHunterReadyToPoison[MAXPLAYERS + 1];
new g_iHunterPounceDamageCharge[MAXPLAYERS + 1];
new bool:g_bIsHunterPoisoned[MAXPLAYERS + 1];
new g_iHunterPoisonRuntimesCounter[MAXPLAYERS + 1];
new bool:g_bHasInfectedHealthBeenSet[MAXPLAYERS + 1];
new bool:g_bHunterLethalPoisoned[MAXPLAYERS + 1];
new g_iHunterPounceDistance[MAXPLAYERS + 1];

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
new g_iBagOfSpitsSelectedSpit[MAXPLAYERS + 1] = BAG_OF_SPITS_NONE;


// Jockey
new bool:g_bCanJockeyPee[MAXPLAYERS + 1] = true;
new bool:g_bCanJockeyCloak[MAXPLAYERS + 1] = true;
new bool:g_bJockeyIsRiding[MAXPLAYERS + 1] = false;
new g_iJockeysVictim[MAXPLAYERS + 1];
new bool:g_bCanJockeyJump[MAXPLAYERS + 1] = false;
new Float:g_fJockeyRideSpeed[MAXPLAYERS + 1] = 1.0;
new Float:g_fJockeyRideSpeedVanishingActBoost[MAXPLAYERS + 1] = 0.0;


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
new g_iTankCounter;
float g_fFrustratedTankTransferHealthPercentage;
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
#define TANK_STARTING_HEALTH_MULTIPLIER_XPMOD_SPAWN         0.50
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
#define TANK_HEALTH_FIRE                    11000
new g_iFireDamageCounter[MAXPLAYERS + 1];
new bool:g_bFireTankAttackCharged[MAXPLAYERS + 1];
new bool:g_bBlockTankFirePunchCharge[MAXPLAYERS + 1];
//new bool:g_bFireTankBaseSpeedIncreased[MAXPLAYERS + 1];
new Float:g_fFireTankExtraSpeed[MAXPLAYERS + 1];
// Ice Tank
#define TANK_HEALTH_ICE                     20000
#define TANK_ICE_REGEN_LIFE_POOL_SIZE       10000
new g_iIceTankLifePool[MAXPLAYERS + 1];
new bool:g_bShowingIceSphere[MAXPLAYERS + 1];
new bool:g_bFrozenByTank[MAXPLAYERS + 1];
new bool:g_bBlockTankFreezing[MAXPLAYERS + 1];
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
#define NECROTANKER_MANA_COST_BOOMER_THROW          15
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
new bool:g_bCanFlapVampiricTankWings[MAXPLAYERS + 1];
new bool:g_bIsVampiricTankFlying[MAXPLAYERS + 1];
new bool:g_bCanVampiricTankWingDash[MAXPLAYERS + 1];
new g_iVampiricTankWingDashChargeCount[MAXPLAYERS + 1];