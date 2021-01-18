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

//Smoker
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

//Boomer
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

//Hunter
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

//Spitter
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
new bool:g_bJustUsedAcidReflex[MAXPLAYERS + 1];
new g_iAcidReflexLeft[MAXPLAYERS + 1];
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

//Jockey
new bool:g_bCanJockeyPee[MAXPLAYERS + 1] = true;
new bool:g_bCanJockeyCloak[MAXPLAYERS + 1] = true;
new bool:g_bJockeyIsRiding[MAXPLAYERS + 1] = false;
new g_iJockeysVictim[MAXPLAYERS + 1];
new bool:g_bCanJockeyJump[MAXPLAYERS + 1] = false;
new Float:g_fJockeyRideSpeed[MAXPLAYERS + 1] = 1.0;
new Float:g_fJockeyRideSpeedVanishingActBoost[MAXPLAYERS + 1] = 0.0;


//Charger
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

//Tank
new g_iTankCounter;
new bool:g_bTankOnFire[MAXPLAYERS + 1];     //prevents constant xp rewarding

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


//Fire Tank
#define TANK_HEALTH_FIRE                    9000
new g_iFireDamageCounter[MAXPLAYERS + 1];
new bool:g_bTankAttackCharged[MAXPLAYERS + 1];
new bool:g_bBlockTankFirePunchCharge[MAXPLAYERS + 1];
//new bool:g_bFireTankBaseSpeedIncreased[MAXPLAYERS + 1];
new Float:g_fFireTankExtraSpeed[MAXPLAYERS + 1];
//Ice Tank
#define TANK_HEALTH_ICE                     20000
#define TANK_ICE_REGEN_LIFE_POOL_SIZE       10000
new g_iIceTankLifePool[MAXPLAYERS + 1];
new bool:g_bShowingIceSphere[MAXPLAYERS + 1];
new bool:g_bFrozenByTank[MAXPLAYERS + 1];
new bool:g_bBlockTankFreezing[MAXPLAYERS + 1];
new Float:g_fTankHealthPercentage[MAXPLAYERS + 1];
new g_iTankCharge[MAXPLAYERS + 1];
new Float:g_xyzClientTankPosition[MAXPLAYERS + 1][3];
//NecroTanker
#define TANK_HEALTH_NECROTANKER             666
#define NECROTANKER_MAX_HEALTH              13666
#define NECROTANKER_CONSUME_COMMON_HP       500
#define NECROTANKER_CONSUME_UNCOMMON_HP     666
#define NECROTANKER_CONSUME_SI_HP           1000
//Vampiric Tank
#define TANK_HEALTH_VAMPIRIC                            10000
#define VAMPIRIC_TANK_LIFESTEAL_MULTIPLIER              15
#define VAMPIRIC_TANK_LIFESTEAL_INCAP_MULTIPLIER        30
#define VAMPIRIC_TANK_MELEE_DMG_TAKEN_MULTIPLIER        3
#define VAMPIRIC_TANK_GUN_DMG_TAKEN_MULTIPLIER          0.333333
new Float:VAMPIRIC_TANK_WING_FLAP_UP_VELOCITY = 600.0;
new Float:VAMPIRIC_TANK_WING_DASH_VELOCITY = 800.0;
new bool:g_bCanFlapVampiricTankWings[MAXPLAYERS + 1];
new bool:g_bIsVampiricTankFlying[MAXPLAYERS + 1];
new bool:g_bCanVampiricTankWingDash[MAXPLAYERS + 1];
new g_iVampiricTankWingDashChargeCount[MAXPLAYERS + 1];