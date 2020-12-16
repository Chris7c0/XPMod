//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////      GLOBAL VARIABLES      ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#define PLUGIN_VERSION "v0.8.4a"


///////////////////////   Game Definitions   ////////////////////////

#define MAXENTITIES			2048

//Define Teams
#define TEAM_SPECTATORS		1
#define TEAM_SURVIVORS 		2
#define TEAM_INFECTED 		3

//Define GameTypes
#define GAMEMODE_UNKNOWN	-1
#define GAMEMODE_COOP 		0
#define GAMEMODE_VERSUS 	1
#define GAMEMODE_SCAVENGE 	2
#define GAMEMODE_SURVIVAL 	3

///////////////////////   XP Amounts   ////////////////////////
//Multiplier amount for Talent levels (1.0 is default)
#define	XP_MULTIPLIER	0.08

//Default XP amount per level
#define LEVEL_1  1000
#define LEVEL_2  3000
#define LEVEL_3  6000
#define LEVEL_4  10000
#define LEVEL_5  15000
#define LEVEL_6  21000
#define LEVEL_7  28000
#define LEVEL_8  36000
#define LEVEL_9  45000
#define LEVEL_10 55000
#define LEVEL_11 66000
#define LEVEL_12 78000
#define LEVEL_13 91000
#define LEVEL_14 105000
#define LEVEL_15 120000
#define LEVEL_16 136000
#define LEVEL_17 153000
#define LEVEL_18 171000
#define LEVEL_19 190000
#define LEVEL_20 210000
#define LEVEL_21 231000
#define LEVEL_22 253000
#define LEVEL_23 276000
#define LEVEL_24 300000
#define LEVEL_25 325000
#define LEVEL_26 351000
#define LEVEL_27 378000
#define LEVEL_28 406000
#define LEVEL_29 435000
#define LEVEL_30 465000

///////////////////////   Database Definitions   ////////////////////////
//Now defined in /addons/sourcemod/config/databases.cfg under "xpmod", DB_CONF_NAME
//#define DB_HOST 		"DB_HOST"
//#define DB_DATABASE	"DB_DATABASE"
//#define DB_USER		"DB_USER"
//#define DB_PASSWORD	"DB_PASSWORD"
#define DB_CONF_NAME 	"xpmod"
#define DB_TABLENAME  	"users"

///////////////////////   Sound Definitions   ////////////////////////
//Stock Sounds//
#define SOUND_LEVELUP				"ui/critical_event_1.wav"
#define SOUND_FREEZE				"physics/glass/glass_impact_bullet4.wav"
#define SOUND_AMBTEST3				"music/stmusic/deathisacarousel.wav"
#define SOUND_PEEING				"ambient/spacial_loops/4b_hospatrium_waterleak.wav"
#define SOUND_AMBTEST2				"ambient/alarms/alarm1.wav"
#define SOUND_AMBTEST4				"player/jockey/voice/idle/jockey_lurk03.wav"
#define SOUND_LEVELUPORIG			"ui/beep_synthtone01.wav"
#define SOUND_IGNITE				"ambient/fire/gascan_ignite1.wav"
#define SOUND_ONFIRE				"ambient/fire/interior_fireclose01_mono.wav"
#define SOUND_JPHIGHREV				"weapons/chainsaw/chainsaw_high_speed_lp_01.wav"
#define SOUND_JPIDLEREV				"weapons/chainsaw/chainsaw_idle_lp_01.wav"
#define SOUND_JPSTART				"weapons/chainsaw/chainsaw_start_02.wav"
#define SOUND_JPDIE					"weapons/chainsaw/chainsaw_die_01.wav"
#define SOUND_JEBUS					"ambient/wind/wind_snippet1.wav"
#define SOUND_CHARGECOACH			"player/survivor/voice/coach/battlecry07.wav"
#define SOUND_SUITCHARGED			"items/suitchargeok1.wav"
#define SOUND_ZAP1					"ambient/energy/zap1.wav"
#define SOUND_ZAP2					"ambient/energy/zap2.wav"
#define SOUND_ZAP3					"ambient/energy/zap3.wav"
#define SOUND_BEEP					"weapons/hegrenade/beep.wav"
#define SOUND_COACH_CHARGE1			"player/survivor/voice/coach/battlecry07.wav"
#define SOUND_COACH_CHARGE2			"player/survivor/voice/coach/battlecry08.wav"
#define SOUND_COACH_CHARGE3			"player/survivor/voice/coach/battlecry09.wav"
#define SOUND_FLIES					"ambient/creatures/flies_loop.wav"
#define SOUND_HOOKGRAB				"player/smoker/miss/smoker_reeltonguein_02.wav"
#define SOUND_HOOKRELEASE			"player/smoker/miss/smoker_reeltonguein_01.wav"
#define SOUND_JOCKEYPEE				"ambient/spacial_loops/4b_hospatrium_waterleak.wav"
#define SOUND_JOCKEYLAUGH1			"player/jockey/voice/idle/jockey_lurk03.wav"
#define SOUND_JOCKEYLAUGH2			"player/jockey/voice/idle/jockey_lurk09.wav"
#define SOUND_EXPLODE				"ambient/explosions/explode_1.wav"

//Custom Sounds//
#define SOUND_TALENTS_LOAD			"xpmod/ui/talents_load.wav"
#define SOUND_NINJA_ACTIVATE		"xpmod/survivors/rochelle/rochelle_ulti_ninja_activate.wav"
#define SOUND_IDD_ACTIVATE			"xpmod/survivors/rochelle/rochelle_idd_activate.wav"
#define SOUND_IDD_DEACTIVATE		"xpmod/survivors/rochelle/rochelle_idd_deactivate.wav"
#define SOUND_NICK_HEAL				"xpmod/survivors/nick/nick_ulti_heal_success.wav"
#define SOUND_NICK_RESURRECT		"xpmod/survivors/nick/nick_ulti_resurrect_success.wav"
#define SOUND_NICK_REVIVE           "xpmod/survivors/nick/nick_ulti_revive_success.wav"
#define SOUND_NICK_LIFESTEAL_HIT    "xpmod/survivors/nick/nick_vampire_round_hit.wav"
#define SOUND_COACH_CHARGE_HIT		"xpmod/survivors/coach/coach_melee_charge_hit.wav"
#define SOUND_WARP					"xpmod/infected/smoker/teleport_warp.wav"
#define SOUND_WARP_LIFE				"xpmod/infected/smoker/teleport_warp_lifetime_sound.wav"
#define SOUND_1KILL					"xpmod/announcer/1_kill.wav"
#define SOUND_2KILLS				"xpmod/announcer/2_kills.wav"
#define SOUND_3KILLS				"xpmod/announcer/3_kills.wav"
#define SOUND_4KILLS				"xpmod/announcer/4_kills.wav"
#define SOUND_5KILLS				"xpmod/announcer/5_kills.wav"
#define SOUND_6KILLS				"xpmod/announcer/6_kills.wav"
#define SOUND_7KILLS				"xpmod/announcer/7_kills.wav"
#define SOUND_8KILLS				"xpmod/announcer/8_kills.wav"
#define SOUND_9KILLS				"xpmod/announcer/9_kills.wav"
#define SOUND_10KILLS				"xpmod/announcer/10_kills.wav"
#define SOUND_11KILLS				"xpmod/announcer/11_kills.wav"
#define SOUND_12KILLS				"xpmod/announcer/12_kills.wav"
#define SOUND_13KILLS				"xpmod/announcer/13_kills.wav"
#define SOUND_14KILLS				"xpmod/announcer/14_kills.wav"
#define SOUND_15KILLS				"xpmod/announcer/15_kills.wav"
#define SOUND_16KILLS				"xpmod/announcer/16_kills.wav"
#define SOUND_HEADSHOT1				"xpmod/announcer/headshot.wav"
#define SOUND_HEADSHOT2				"xpmod/announcer/headshot_boom.wav"
#define SOUND_HEADSHOT3				"xpmod/announcer/brain_surgeon.wav"
#define SOUND_GETITON				"xpmod/announcer/get_it_on.wav"

// Convars
// Talent Selection Mode
#define CONVAR_MENU			0
#define CONVAR_WEBSITE		1

//Survivor Character ID Definitions
#define BILL			0
#define ROCHELLE		1
#define COACH			2
#define ELLIS			3
#define NICK			4

new String:SURVIVOR_NAME[][] =  {"BILL", 
                                "ROCHELLE",
                                "COACH",
                                "ELLIS",
                                "NICK"}

new String:SURVIVOR_CLASS_NAME[][] =    {"SUPPORT", 
                                        "NINJA",
                                        "BERSERKER",
                                        "WEAPONS EXPERT",
                                        "MEDIC"}

//Infected Class ID Definitions
#define UNKNOWN_INFECTED	0
#define SMOKER				1
#define BOOMER				2
#define HUNTER				3
#define SPITTER				4
#define JOCKEY				5
#define CHARGER				6
//#define WITCH				7
#define TANK				8

//Chosen Tank Talents
#define NO_TANK_CHOSEN		0
#define FIRE_TANK			1
#define ICE_TANK			2

//Spitter Goo Types
#define GOO_ADHESIVE		0
#define GOO_FLAMING			1
#define GOO_MELTING			2
#define GOO_DEMI			3
#define GOO_REPULSION		4
#define GOO_VIRAL			5


//Damage Types
//#define DAMAGETYPE_INFECTED_MELEE	128
#define DAMAGETYPE_HUNTER_POUNCE	1
#define DAMAGETYPE_FIRE1			8
#define DAMAGETYPE_FIRE2			2056
#define DAMAGETYPE_IGNITED_ENTITY	268435464
#define DAMAGETYPE_BLOCK_REVIVING	65536
#define DAMAGETYPE_SPITTER_GOO		263168

//Movement Types
#define MOVECOLLIDE_DEFAULT 	0
#define MOVECOLLIDE_FLY_BOUNCE 	1
#define MOVETYPE_WALK 			2
#define MOVETYPE_FLYGRAVITY 	5

//Particle attatchment points
#define ATTACH_NONE				-1
#define ATTACH_NORMAL			0
#define ATTACH_MOUTH			1
#define ATTACH_EYES				2
#define ATTACH_MUZZLE_FLASH		3
#define ATTACH_WEAPON_BONE		4
#define ATTACH_DEBRIS			5
#define ATTACH_RSHOULDER		6

/*
#define ATTACH_MEDKIT			X
#define ATTACH_SHELL			X
#define ATTACH_SPINE			X
#define ATTACH_FORWARD			X
#define ATTACH_SURVIVOR_LIGHT	X
#define ATTACH_BLUR				X
*/

//Animations for crawling
#define ANIM_L4D2_NICK		631
#define ANIM_L4D2_ELLIS		636
#define ANIM_L4D2_ROCHELLE		639
#define ANIM_L4D2_ZOEY		658
#define ANIM_L4D2_LOUIS		539
#define ANIM_L4D2_FRANCIS	542
#define ANIM_L4D2_BILL		539


//For Hud Overlay Colors
//#define FADE_SOLID2	0x0000
#define FADE_SOLID	0x0008
#define FADE_OUT	0x0001
#define FADE_IN		0x0002
#define FADE_STOP	0x0010


//Testing stuff
new gClone[MAXPLAYERS + 1];
new testingparticle;
new bool:talentsJustGiven[MAXPLAYERS + 1] = false;
new bool:testtoggle[MAXPLAYERS + 1];
new Float:rspeed;
new bool:canchangemovement[MAXPLAYERS + 1];
new preledgehealth[MAXPLAYERS + 1];
new Float:preledgebuffer[MAXPLAYERS + 1];
new bool:clienthanging[MAXPLAYERS + 1];
new g_oAbility = 0;



//Global Variables ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//ConVars
//new Handle:g_hCVar_TalentSelectionMode      = INVALID_HANDLE;
//new g_iTalentSelectionMode                  = CONVAR_WEBSITE;
new Handle:g_hCVar_DefaultSurvivor          = INVALID_HANDLE;
new g_iDefaultSurvivor                      = BILL;
new Handle:g_hCVar_DefaultInfecttedSlot1    = INVALID_HANDLE;
new g_iDefaultInfectedSlot1                 = BOOMER;
new Handle:g_hCVar_DefaultInfecttedSlot2    = INVALID_HANDLE;
new g_iDefaultInfectedSlot2                 = JOCKEY;
new Handle:g_hCVar_DefaultInfecttedSlot3    = INVALID_HANDLE;
new g_iDefaultInfectedSlot3                 = SMOKER;


new Float:EMPTY_VECTOR[3] = 0.0;
new Float:PI = 3.1415926;

// Game Freezing Variables
new bool:g_bGameFrozen = false;
new bool:g_bPlayerPressedButtonThisRound = false;  // This is used to set thte countdown timer, it wont start till  someone presses a button

//Confirmation Variables

new bool:g_bTalentsConfirmed[MAXPLAYERS + 1];
new bool:g_bUserStoppedConfirmation[MAXPLAYERS + 1];
new bool:g_bClientAlreadyShownCharacterSelectMenu[MAXPLAYERS + 1];
new g_iAutoSetCountDown[MAXPLAYERS + 1];
new bool:g_bWaitinOnClientInputForChoosingCharacter[MAXPLAYERS + 1];
new g_iWaitinOnClientInputForDrawingMenu[MAXPLAYERS + 1];
#define WAITING             0
#define BUTTON_RELEASED     1
#define FINISHED_WAITING    2



//XPM Options
new g_iXPDisplayMode[MAXPLAYERS + 1];						//Default 0 = Show Sprites; 1 = Show In Chat, 2 = Disabled
new bool:g_bClientSpectating[MAXPLAYERS + 1] = false;

//Gamemode
new g_iGameMode;

new bool:g_bEnabledVGUI[MAXPLAYERS + 1];					//VGUI toggle for iClient menu descriptions
new bool:g_bShowingVGUI[MAXPLAYERS + 1];	

//Grappled Checks
new bool:g_bHunterGrappled[MAXPLAYERS + 1];
new bool:g_bChargerGrappled[MAXPLAYERS + 1];
new bool:g_bSmokerGrappled[MAXPLAYERS + 1];
new bool:g_bJockeyGrappled[MAXPLAYERS + 1];
new g_iChargerVictim[MAXPLAYERS + 1];
new g_iJockeyVictim[MAXPLAYERS + 1];		//g_iJockeyVictim[attacker] = victim;
new g_iHunterShreddingVictim[MAXPLAYERS + 1];

//Sprites
new g_iSprite_Laser;
new g_iSprite_Halo;
new g_iSprite_SmokerTongue;
new g_iSprite_AmmoBox;
new g_iSprite_Arrow;
//Experience Sprites
new g_iSprite_1XP;
new g_iSprite_5XP_HS;
new g_iSprite_25XP;
new g_iSprite_50XP;
new g_iSprite_75XP_HS;
new g_iSprite_100XP;
new g_iSprite_150XP;
new g_iSprite_250XP;
new g_iSprite_250XP_Team;
new g_iSprite_350XP;
new g_iSprite_10XP_Bill;
new g_iSprite_20XP_Bill;
new g_iSprite_30XP_Bill;
new g_iSprite_40XP_Bill;
new g_iSprite_50XP_Bill;
new g_iSprite_3XP_SI;
new g_iSprite_10XP_SI;
new g_iSprite_15XP_SI;
new g_iSprite_25XP_SI;
new g_iSprite_50XP_SI;
new g_iSprite_200XP_SI;
new g_iSprite_500XP_SI;



// Smoker Tongue Rope
new bool:g_bUsingTongueRope[MAXPLAYERS + 1];
new bool:g_bUsedTongueRope[MAXPLAYERS + 1];
new g_iRopeCountDownTimer[MAXPLAYERS + 1];
new Float:g_xyzRopeEndLocation[MAXPLAYERS + 1][3];
new Float:g_xyzClientLocation[MAXPLAYERS + 1][3];
new Float:g_xyzRopeDistance[MAXPLAYERS + 1];
new Float:g_xyzOriginalRopeDistance[MAXPLAYERS + 1];


// Common                                                           
new clientidname[MAXPLAYERS + 1][32];			//SHOULD BE A STRING?
new g_iClientTeam[MAXPLAYERS + 1];
new bool:g_bClientLoggedIn[MAXPLAYERS + 1];
new g_iDBUserID[MAXPLAYERS + 1] = -1;
new String:g_strDBUserToken[MAXPLAYERS + 1][41];
new bool:g_bCanSave = true;
new bool:g_bTalentsGiven[MAXPLAYERS + 1] = false;
new g_iClientXP[MAXPLAYERS + 1];
new g_iClientLevel[MAXPLAYERS + 1];
new g_iChosenSurvivor[MAXPLAYERS + 1];
new g_iClientNextLevelXPAmount[MAXPLAYERS + 1];
new g_iClientPreviousLevelXPAmount[MAXPLAYERS + 1];
new g_iSkillPoints[MAXPLAYERS + 1];
new g_iInfectedCharacter[MAXPLAYERS + 1];
new g_iInfectedLevel[MAXPLAYERS + 1];
new g_iClientUsableXP = -1;
new g_iClientTotalXPCost[MAXPLAYERS + 1];

new g_iClientSurvivorMaxHealth[MAXPLAYERS + 1];		//Survivor max health for the iClient
new bool:g_bIsClientDown[MAXPLAYERS + 1] = false;


new g_iClientBindUses_1[MAXPLAYERS + 1];
new g_iClientBindUses_2[MAXPLAYERS + 1];
new Float:g_fMaxLaserAccuracy = 0.4;					//max accuracy increase for survivors
new g_iClientPrimaryClipSize[MAXPLAYERS + 1];		//g_iOffset_Clip1 for the clients primary weapon before addition of talents


new bool:g_bTankOnFire[MAXPLAYERS + 1];				//prevents constant xp rewarding
new g_iSlapRunTimes[MAXPLAYERS + 1];				//for the slap timer for each iClient					//Remember to initialize this each time before use!
new g_iDropBombsTimes[MAXPLAYERS + 1];
new g_iUnfreezeNotifyRunTimes = 1;						//for the unfreeze notify runtimes
new g_iPrintRunTimes = -1;								//for printing time left till unfreeze in unfreeze notification timer

//Round/Map Stuff
new bool:g_bEndOfRound;

//Stats
new g_iStat_ClientInfectedKilled[MAXPLAYERS + 1];
new g_iStat_ClientCommonKilled[MAXPLAYERS + 1];	
new g_iStat_ClientCommonHeadshots[MAXPLAYERS + 1];
new g_iStat_ClientSurvivorsKilled[MAXPLAYERS + 1];
new g_iStat_ClientSurvivorsIncaps[MAXPLAYERS + 1];
new g_iStat_ClientDamageToSurvivors[MAXPLAYERS + 1];

//Rewards
new g_iReward_SIKills;
new g_iReward_SIKillsID;
new String:g_strReward_SIKills[32];
new g_iReward_CIKills;
new g_iReward_CIKillsID;
new String:g_strReward_CIKills[32];
new g_iReward_HS;
new g_iReward_HSID;
new String:g_strReward_HS[32];
new g_iReward_SurKills;
new g_iReward_SurKillsID;
new String:g_strReward_SurKills[32];
new g_iReward_SurIncaps;
new g_iReward_SurIncapsID;
new String:g_strReward_SurIncaps[32];
new g_iReward_SurDmg;
new g_iReward_SurDmgID;
new String:g_strReward_SurDmg[32];

//Announcer Sounds
new bool:g_bCanPlayHeadshotSound[MAXPLAYERS + 1];
new bool:g_bAnnouncerOn[MAXPLAYERS + 1];

//Faster Shooting Variables
new g_iFastAttackingClientsArray[MAXPLAYERS + 1];
new bool:g_bSomeoneAttacksFaster;
new bool:g_bDoesClientAttackFast[MAXPLAYERS + 1];


///////////////////////////////////////////////     TALENT VARIABLES     ///////////////////////////////////////////////

////////////////////////////////     SURVIVORS    /////////////////////////////////////

//Bill(Support) Talent Levels
new g_iInspirationalLevel[MAXPLAYERS + 1];
new g_iWillLevel[MAXPLAYERS + 1];
new g_iExorcismLevel[MAXPLAYERS + 1];
new g_iDiehardLevel[MAXPLAYERS + 1];
new g_iGhillieLevel[MAXPLAYERS + 1];
new g_iPromotionalLevel[MAXPLAYERS + 1];

//Rochelle Talent Levels
new g_iGatherLevel[MAXPLAYERS + 1];
new g_iHunterLevel[MAXPLAYERS + 1];
new g_iSniperLevel[MAXPLAYERS + 1];
new g_iSilentLevel[MAXPLAYERS + 1];
new g_iSmokeLevel[MAXPLAYERS + 1];
new g_iShadowLevel[MAXPLAYERS + 1];

//Coach Talent Levels
new g_iBullLevel[MAXPLAYERS + 1];
new g_iWreckingLevel[MAXPLAYERS + 1];
new g_iSprayLevel[MAXPLAYERS + 1];
new g_iHomerunLevel[MAXPLAYERS + 1];
new g_iLeadLevel[MAXPLAYERS + 1];
new g_iStrongLevel[MAXPLAYERS + 1];

//Ellis Talent Levels
new g_iOverLevel[MAXPLAYERS + 1];
new g_iBringLevel[MAXPLAYERS + 1];
new g_iMetalLevel[MAXPLAYERS + 1];
new g_iWeaponsLevel[MAXPLAYERS + 1];
new g_iJamminLevel[MAXPLAYERS + 1];
new g_iFireLevel[MAXPLAYERS + 1];

//Nick Talent Levels
new g_iSwindlerLevel[MAXPLAYERS + 1];
new g_iLeftoverLevel[MAXPLAYERS + 1];
new g_iMagnumLevel[MAXPLAYERS + 1];
new g_iEnhancedLevel[MAXPLAYERS + 1];
new g_iRiskyLevel[MAXPLAYERS + 1];
new g_iDesperateLevel[MAXPLAYERS + 1];



////////////////////////////////     INFECTED    /////////////////////////////////////

//Smoker
new g_iEnvelopmentLevel[MAXPLAYERS + 1];
new g_iNoxiousLevel[MAXPLAYERS + 1];
new g_iDirtyLevel[MAXPLAYERS + 1];

//Boomer
new g_iRapidLevel[MAXPLAYERS + 1];
new g_iAcidicLevel[MAXPLAYERS + 1];
new g_iNorovirusLevel[MAXPLAYERS + 1];

//Hunter
new g_iPredatorialLevel[MAXPLAYERS + 1];
new g_iBloodlustLevel[MAXPLAYERS + 1];
new g_iKillmeleonLevel[MAXPLAYERS + 1];

//Spitter
new g_iPuppetLevel[MAXPLAYERS + 1];
new g_iMaterialLevel[MAXPLAYERS +1];
new g_iHallucinogenicLevel[MAXPLAYERS +1];

//Jockey
new g_iMutatedLevel[MAXPLAYERS + 1];
new g_iErraticLevel[MAXPLAYERS + 1];
new g_iUnfairLevel[MAXPLAYERS + 1];

//Charger
new g_iGroundLevel[MAXPLAYERS + 1];
new g_iSpikedLevel[MAXPLAYERS +1];
new g_iHillbillyLevel[MAXPLAYERS +1];

//Tank
new g_iTankChosen[MAXPLAYERS + 1];	// 0 = NO_TANK_CHOSEN, 1 = FIRE_TANK, 2 = ICE_TANK

///////////////////////////////////////////////     PLAYER SPECIFIC VARIABLES     ///////////////////////////////////////////////

//Survivors
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
new String:g_strCheckAmmoUpgrade[32];
new g_iKitsUsed = 0;
new g_iPrimarySlotID[MAXPLAYERS + 1];
new bool:g_bDivineInterventionQueued[MAXPLAYERS + 1];
new Float:g_fClientSpeedPenalty[MAXPLAYERS + 1];
new Float:g_fClientSpeedBoost[MAXPLAYERS + 1];
new bool:g_bWasClientDownOnDeath[MAXPLAYERS + 1];
new bool:g_bAdhesiveGooActive[MAXPLAYERS + 1];
new bool:g_bIsClientGrappled[MAXPLAYERS + 1];

//Bill's Stuff (Support)/////////////////////////////////////////////////////////////////////////////////////////////////////////
new g_iBillTeamHealCounter[MAXPLAYERS + 1];
new g_iClientToHeal[MAXPLAYERS + 1] = 1;
new g_iCrawlSpeedMultiplier;
new g_iBillSprintChargeCounter[MAXPLAYERS + 1];
new g_iBillSprintChargePower[MAXPLAYERS + 1];
new bool:g_bBillSprinting[MAXPLAYERS + 1];
new bool:g_bCanDropPoopBomb[MAXPLAYERS + 1];
new g_iPoopBombOwnerID[MAXENTITIES + 1];
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
new bool:g_bEllisOverSpeedDecreased[MAXPLAYERS + 1];
new bool:g_bEllisOverSpeedIncreased[MAXPLAYERS + 1];

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


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////     INFECTED VARIABLES     ///////////////////////////////////////////////
new g_iClientInfectedClass1[MAXPLAYERS + 1]	= UNKNOWN_INFECTED;
new g_iClientInfectedClass2[MAXPLAYERS + 1]	= UNKNOWN_INFECTED;
new g_iClientInfectedClass3[MAXPLAYERS + 1]	= UNKNOWN_INFECTED;
new String:g_strClientInfectedClass1[MAXPLAYERS + 1][10]; 
new String:g_strClientInfectedClass2[MAXPLAYERS + 1][10]; 
new String:g_strClientInfectedClass3[MAXPLAYERS + 1][10];
new bool:g_iInfectedConvarsSet[MAXPLAYERS + 1];
//new Float:g_fAdhesiveAffectCase[MAXPLAYERS + 1];
new Float:g_fAdhesiveAffectAmount[MAXPLAYERS + 1];
new g_iTankCounter;
//new bool:g_bIsInfectedGrappling[MAXPLAYERS + 1];
new g_iStumbleRadius = 160;

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

//Jockey
new bool:g_bCanJockeyPee[MAXPLAYERS + 1] = true;
new bool:g_bCanJockeyCloak[MAXPLAYERS + 1] = true;
new bool:g_bJockeyIsRiding[MAXPLAYERS + 1] = false;
new g_iJockeysVictim[MAXPLAYERS + 1];
new bool:g_bCanJockeyJump[MAXPLAYERS + 1] = true;

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
new g_iFireDamageCounter[MAXPLAYERS + 1];
new bool:g_bFrozenByTank[MAXPLAYERS + 1];
new bool:g_bBlockTankFreezing[MAXPLAYERS + 1];
new bool:g_bBlockTankFirePunchCharge[MAXPLAYERS + 1];
new Float:g_fTankHealthPercentage[MAXPLAYERS + 1];
new g_iTankCharge[MAXPLAYERS + 1];
new Float:g_xyzClientPosition[MAXPLAYERS + 1][3];
//Fire Tank
new bool:g_bTankAttackCharged[MAXPLAYERS + 1];
//new bool:g_bFireTankBaseSpeedIncreased[MAXPLAYERS + 1];
new Float:g_fFireTankExtraSpeed[MAXPLAYERS + 1];
//Ice Tank
new g_iIceTankLifePool[MAXPLAYERS + 1];
new bool:g_bShowingIceSphere[MAXPLAYERS + 1];


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////     MISC VARIABLES     /////////////////////////////////////////////////

//This is for overlay colors
new UserMsg:g_umsgFade;

//Note: pump and chrome have identical values
const Float:g_flSoHAutoS = 0.666666;
const Float:g_flSoHAutoI = 0.4;
const Float:g_flSoHAutoE = 0.675;
const Float:g_flSoHSpasS = 0.5;
const Float:g_flSoHSpasI = 0.375;
const Float:g_flSoHSpasE = 0.699999;
const Float:g_flSoHPumpS = 0.5;
const Float:g_flSoHPumpI = 0.5;
const Float:g_flSoHPumpE = 0.6;

//Offsets for Windows
//new g_iOffset_NextAct = 1068;
new g_iOffset_NextAct = 1084;
//new g_iAttackTimerO = 5436;
new g_iOffset_ShovePenalty			= -1;
new g_iOffset_ActiveWeapon			= -1;
new g_iOffset_NextPrimaryAttack		= -1;
new g_iOffset_NextSecondaryAttack	= -1;
new g_iOffset_PlaybackRate			= -1;
new g_iOffset_TimeWeaponIdle		= -1;
new g_iOffset_NextAttack			= -1;
new g_iOffset_ReloadStartDuration	= -1;
new g_iOffset_ReloadInsertDuration	= -1;
new g_iOffset_ReloadEndDuration		= -1;
new g_iOffset_ReloadState			= -1;
//new g_iOffset_ReloadStartTime		= -1;
new g_iOffset_HealthBuffer			= -1;
//new g_iOffset_HealthBufferTime		= -1;
new g_iOffset_CustomAbility			= -1;
new g_iOffset_Clip1 				= -1;
new g_iOffset_ClipShotgun			= -1;
new g_iOffset_IsGhost				= -1;
new g_iOffset_ReloadNumShells		= -1;
//new g_iOffset_ShellsInserted		= -1;
new g_bOffset_InReload				= -1;
//new g_iOffset_Ammo					= -1;

//Reload Animation Reset
new g_iOffset_LayerStartTime		= -1;
new g_iOffset_ViewModel				= -1;
//For Coach's Jetpack
new g_iOffset_MoveCollide			= -1;
new g_iOffset_MoveType				= -1;
new g_iOffset_VecVelocity			= -1;
//new g_iOffset_OwnerEntity			= -1;

new Float:g_fReloadRate;

new Float:g_fTimeStamp[MAXPLAYERS + 1] = -1.0;

new Float:flNextTime_calc;
new Float:flNextTime_ret;
new Float:flNextTime2_ret;
new Float:g_fGameTime;
new g_iDTEntid[64] = -1;
new Float:g_flDTNextTime[64] = -1.0;

//Flags
new g_iFlag_Give;
new g_iFlag_UpgradeAdd;
//new g_iFlag_UpgradeRemove;
new g_iFlag_SpawnOld;


//Handles
//MySQL Database handle
new Handle:g_hDatabase = INVALID_HANDLE;

//Menus
new Handle:g_hMenu_IDD[MAXPLAYERS + 1] 		= INVALID_HANDLE;
new Handle:g_hMenu_XPM[MAXPLAYERS + 1] 		= INVALID_HANDLE;
//SDK Calls
new Handle:g_hSDK_SetHumanSpec 		= INVALID_HANDLE;
new Handle:g_hSDK_TakeOverBot 		= INVALID_HANDLE;
new Handle:g_hSDK_RoundRespawn 		= INVALID_HANDLE;
//new Handle:g_hSDK_BecomeGhost 		= INVALID_HANDLE;
//new Handle:g_hSDK_StateTransition 	= INVALID_HANDLE;
new Handle:g_hSDK_OnPounceEnd		= INVALID_HANDLE;
new Handle:g_hSDK_VomitOnPlayer 	= INVALID_HANDLE;
new Handle:g_hSDK_Fling 			= INVALID_HANDLE;
//Testing SDK Calls
new Handle:g_hSetClass 			= INVALID_HANDLE;
new Handle:g_hCreateAbility 			= INVALID_HANDLE;
//Timer Handles
new Handle:g_hTimer_FreezeCountdown 						= null;
new Handle:g_hTimer_ShowingConfirmTalents[MAXPLAYERS + 1]	= null;
new Handle:g_hTimer_DrugPlayer[MAXPLAYERS + 1] 				= null;
new Handle:g_hTimer_HallucinatePlayer[MAXPLAYERS + 1]		= null;
new Handle:g_hTimer_SlapPlayer[MAXPLAYERS + 1] 				= null;
new Handle:g_hTimer_RochellePoison[MAXPLAYERS + 1] 			= null;
new Handle:g_hTimer_HunterPoison[MAXPLAYERS + 1] 			= null;
new Handle:g_hTimer_NickLifeSteal[MAXPLAYERS + 1] 			= null;
new Handle:g_hTimer_BillDropBombs[MAXPLAYERS + 1] 			= null;
new Handle:g_hTimer_IceSphere[MAXPLAYERS + 1]				= null;
new Handle:g_hTimer_AdhesiveGooReset[MAXPLAYERS + 1] 		= null;
new Handle:g_hTimer_DemiGooReset[MAXPLAYERS + 1] 			= null;
new Handle:g_hTimer_ResetGlow[MAXPLAYERS + 1] 	            = null;
new Handle:g_hTimer_ViralInfectionTick[MAXPLAYERS + 1] 		= null;
new Handle:g_hTimer_BlockGooSwitching[MAXPLAYERS + 1] 		= null;



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

//Particles

//Bill Particles

//Rochelle Particles
new g_iPID_RochelleCharge1[MAXPLAYERS + 1];
new g_iPID_RochelleCharge2[MAXPLAYERS + 1];
new g_iPID_RochelleCharge3[MAXPLAYERS + 1];
new g_iPID_RochelleJumpCharge[MAXPLAYERS + 1];
new g_iPID_RochellePoisonBullet[MAXPLAYERS + 1];

//Coach Particles
new g_iPID_CoachMeleeCharge1[MAXPLAYERS + 1];
new g_iPID_CoachMeleeCharge2[MAXPLAYERS + 1];
new g_iPID_CoachCharge1[MAXPLAYERS + 1];
new g_iPID_CoachCharge2[MAXPLAYERS + 1];
new g_iPID_CoachCharge3[MAXPLAYERS + 1];
new g_iPID_CoachJetpackStream[MAXPLAYERS + 1];
new g_iPID_CoachMeleeChargeHeal[MAXPLAYERS + 1];

//Ellis Particles
new g_iPID_EllisCharge1[MAXPLAYERS + 1];
new g_iPID_EllisCharge2[MAXPLAYERS + 1];
new g_iPID_EllisCharge3[MAXPLAYERS + 1];
new g_iPID_EllisFireStorm[MAXPLAYERS + 1];

//Nicks Particles
new g_iPID_NickCharge1[MAXPLAYERS + 1];
new g_iPID_NickCharge2[MAXPLAYERS + 1];
new g_iPID_NickCharge3[MAXPLAYERS + 1];

//Spitter Particles
new g_iPID_DemiGravityEffect[MAXPLAYERS + 1];
new g_iPID_SpitterSlimeTrail[MAXPLAYERS + 1];

//Charger Particles
new g_iPID_ChargerShield[MAXPLAYERS + 1];

//Tank Particles
new g_iPID_TankChargedFire[MAXPLAYERS + 1];
new g_iPID_IceTankChargeMist[MAXPLAYERS + 1];
new g_iPID_IceTankChargeSnow[MAXPLAYERS + 1];
new g_iPID_IceTankIcicles[MAXPLAYERS + 1];

//Survivor Particle Menu Descriptions
new g_iPID_MD_Bill_Inspirational[MAXPLAYERS + 1];
new g_iPID_MD_Bill_Ghillie[MAXPLAYERS + 1];
new g_iPID_MD_Bill_Will[MAXPLAYERS + 1];
new g_iPID_MD_Bill_Exorcism[MAXPLAYERS + 1];
new g_iPID_MD_Bill_Diehard[MAXPLAYERS + 1];
new g_iPID_MD_Bill_Promotional[MAXPLAYERS + 1];

new g_iPID_MD_Rochelle_Gather[MAXPLAYERS + 1];
new g_iPID_MD_Rochelle_Hunter[MAXPLAYERS + 1];
new g_iPID_MD_Rochelle_Sniper[MAXPLAYERS + 1];
new g_iPID_MD_Rochelle_Silent[MAXPLAYERS + 1];
new g_iPID_MD_Rochelle_Smoke[MAXPLAYERS + 1];
new g_iPID_MD_Rochelle_Shadow[MAXPLAYERS + 1];

new g_iPID_MD_Coach_Bull[MAXPLAYERS + 1];
new g_iPID_MD_Coach_Wrecking[MAXPLAYERS + 1];
new g_iPID_MD_Coach_Spray[MAXPLAYERS + 1];
new g_iPID_MD_Coach_Homerun[MAXPLAYERS + 1];
new g_iPID_MD_Coach_Lead[MAXPLAYERS + 1];
new g_iPID_MD_Coach_Strong[MAXPLAYERS + 1];

new g_iPID_MD_Ellis_Over[MAXPLAYERS + 1];
new g_iPID_MD_Ellis_Bring[MAXPLAYERS + 1];
new g_iPID_MD_Ellis_Jammin[MAXPLAYERS + 1];
new g_iPID_MD_Ellis_Weapons[MAXPLAYERS + 1];
new g_iPID_MD_Ellis_Mechanic[MAXPLAYERS + 1];
new g_iPID_MD_Ellis_Fire[MAXPLAYERS + 1];

new g_iPID_MD_Nick_Swindler[MAXPLAYERS + 1];
new g_iPID_MD_Nick_Leftover[MAXPLAYERS + 1];
new g_iPID_MD_Nick_Magnum[MAXPLAYERS + 1];
new g_iPID_MD_Nick_Enhanced[MAXPLAYERS + 1];
new g_iPID_MD_Nick_Risky[MAXPLAYERS + 1];
new g_iPID_MD_Nick_Desperate[MAXPLAYERS + 1];