//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////      GLOBAL VARIABLES      ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define PLUGIN_VERSION "v0.8.4a"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////       Game Definitions       //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define MAXENTITIES			2048

//Define Teams
#define TEAM_SPECTATORS		1
#define TEAM_SURVIVORS 		2
#define TEAM_INFECTED 		3

//Define GameTypes
#define GAMEMODE_UNKNOWN	        -1
#define GAMEMODE_COOP 		        0
#define GAMEMODE_VERSUS 	        1
#define GAMEMODE_SCAVENGE 	        2
#define GAMEMODE_SURVIVAL 	        3
#define GAMEMODE_VERSUS_SURVIVAL 	4

//Gamemode
new g_iGameMode;

// Server Name
new String:g_strServerName[64]              = "";
// Log File Paths
new String:g_strXPMStatsFullFilePath[256]   = "";


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////       Database       //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//MySQL Database handle
new Handle:g_hDatabase = INVALID_HANDLE;

//Now defined in /addons/sourcemod/config/databases.cfg under "xpmod", DB_CONF_NAME
//#define DB_HOST 		"DB_HOST"
//#define DB_DATABASE	"DB_DATABASE"
//#define DB_USER		"DB_USER"
//#define DB_PASSWORD	"DB_PASSWORD"
#define DB_CONF_NAME 	        "xpmod"
#define DB_TABLENAME_USERS  	"users"
#define DB_TABLENAME_BANS  	    "bans"
#define DB_VIEWNAME_TOP_10  	"top10"


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////     MISC VARIABLES     /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Math
new Float:PI = 3.1415926;
new Float:EMPTY_VECTOR[3] = 0.0;

//Survivor Character ID Definitions
#define UNKNOWN_SURVIVOR    -1
#define BILL			    0
#define ROCHELLE		    1
#define COACH			    2
#define ELLIS			    3
#define NICK			    4
#define LOUIS     	        5

// These are the actual game values (change to later)
// #define UNKNOWN_SURVIVOR    -1
// #define     NICK     	0
// #define     ROCHELLE     1
// #define     COACH     	2
// #define     ELLIS     	3
// #define     BILL     	4
// #define     ZOEY     	5
// #define     FRANCIS      6
// #define     LOUIS     	7

public String:SURVIVOR_NAME[][] =          {"BILL", 
                                            "ROCHELLE",
                                            "COACH",
                                            "ELLIS",
                                            "NICK",
                                            "LOUIS"}

public String:SURVIVOR_CLASS_NAME[][] =    {"SUPPORT", 
                                            "NINJA",
                                            "BERSERKER",
                                            "WEAPONS EXPERT",
                                            "GAMBLER",
                                            "DISRUPTOR"}

// new String:SURVIVOR_NAME[][] =          {"BILL", 
//                                         "ROCHELLE",
//                                         "COACH",
//                                         "ELLIS",
//                                         "NICK",
//                                         "ZOEY",
//                                         "FRANCIS",
//                                         "LOUIS"}

// new String:SURVIVOR_CLASS_NAME[][] =    {"SUPPORT", 
//                                         "NINJA",
//                                         "BERSERKER",
//                                         "WEAPONS EXPERT",
//                                         "GAMBLER",
//                                         "HEALER",
//                                         "GRENADIER",
//                                         "DISRUPTOR"}

//Infected Class ID Definitions
#define UNKNOWN_INFECTED	0
#define SMOKER				1
#define BOOMER				2
#define HUNTER				3
#define SPITTER				4
#define JOCKEY				5
#define CHARGER				6
#define WITCH				7
#define TANK				8

new String:INFECTED_NAME[][] =          {"",
                                        "SMOKER",
                                        "BOOMER",
                                        "HUNTER",
                                        "SPITTER",
                                        "JOCKEY",
                                        "CHARGER",
                                        "WITCH",
                                        "TANK"}

// Damage Types
#define DAMAGETYPE_GENERIC      	0
#define DAMAGETYPE_INFECTED_MELEE	128
#define DAMAGETYPE_HUNTER_POUNCE	1
#define DAMAGETYPE_PISTOL           2
#define DAMAGETYPE_PISTOL_MAGNUM    -2147483646
#define DAMAGETYPE_FIRE1			8
#define DAMAGETYPE_FIRE2			2056
#define DAMAGETYPE_IGNITED_ENTITY	268435464
#define DAMAGETYPE_BLOCK_REVIVING	65536
#define DAMAGETYPE_SPITTER_GOO		263168

// Hitgroups
#define HITGROUP_HEAD               1

// Movement Collide
#define MOVECOLLIDE_DEFAULT     0	//Default behavior
#define MOVECOLLIDE_FLY_BOUNCE  1   //Entity bounces, reflects, based on elasticity of surface and object - applies friction (adjust velocity)
#define MOVECOLLIDE_FLY_CUSTOM  2   //ENTITY:Touch will modify the velocity however it likes
#define MOVECOLLIDE_FLY_SLIDE   3   //Entity slides along surfaces (no bounce) - applies friciton (adjusts velocity)
#define MOVECOLLIDE_COUNT       4	//Number of different movecollides
// Movement Types
#define MOVETYPE_WALK 			2
#define MOVETYPE_FLYGRAVITY 	5
#define MOVETYPE_PUSH           7
#define MOVETYPE_NOCLIP         8
// Solid Types
#define SOLID_NONE 0        // no solid model
#define SOLID_BSP 1         // a BSP tree
#define SOLID_BBOX 2        // an AABB
#define SOLID_OBB = 3       // an OBB (not implemented yet)
#define SOLID_OBB_YAW 4     // an OBB, constrained so that it can only yaw
#define SOLID_CUSTOM 5      // Always call into the entity for tests
#define SOLID_VPHYSICS 6    // Solid vphysics object, get vcollide from the model and collide with that
#define SOLID_LAST 7        //UNKNOWN



// // Move types to be used with network properties
// getconsttable()["MOVETYPE_NONE"] <- 0;		/**< never moves */
// getconsttable()["MOVETYPE_ISOMETRIC"] <- 1;		/**< For players */
// getconsttable()["MOVETYPE_WALK"] <- 2;		/**< Player only - moving on the ground */
// getconsttable()["MOVETYPE_STEP"] <- 3;		/**< gravity, special edge handling -- monsters use this */
// getconsttable()["MOVETYPE_FLY"] <- 4;		/**< No gravity, but still collides with stuff */
// getconsttable()["MOVETYPE_FLYGRAVITY"] <- 5;		/**< flies through the air + is affected by gravity */
// getconsttable()["MOVETYPE_VPHYSICS"] <- 6;		/**< uses VPHYSICS for simulation */
// getconsttable()["MOVETYPE_PUSH"] <- 7;		/**< no clip to world, push and crush */
// getconsttable()["MOVETYPE_NOCLIP"] <- 8;		/**< No gravity, no collisions, still do velocity/avelocity */
// getconsttable()["MOVETYPE_LADDER"] <- 9;		/**< Used by players only when going onto a ladder */
// getconsttable()["MOVETYPE_OBSERVER"] <- 9;		/**< Observer movement, depends on player's observer mode */
// getconsttable()["MOVETYPE_CUSTOM"] <- 10;		/**< Allows the entity to describe its own physics */

// // Flags to be used with the m_fFlags network property values
// getconsttable()["FL_ONGROUND"] <- (1 << 0);		/**< At rest / on the ground */
// getconsttable()["FL_DUCKING"] <- (1 << 1);		/**< Player flag -- Player is fully crouched */
// getconsttable()["FL_WATERJUMP"] <- (1 << 2);		/**< player jumping out of water */
// getconsttable()["FL_ONTRAIN"] <- (1 << 3);		/**< Player is _controlling_ a train, so movement commands should be ignored on client during prediction. */
// getconsttable()["FL_INRAIN"] <- (1 << 4);		/**< Indicates the entity is standing in rain */
// getconsttable()["FL_FROZEN"] <- (1 << 5);		/**< Player is frozen for 3rd person camera */
// getconsttable()["FL_ATCONTROLS"] <- (1 << 6);		/**< Player can't move, but keeps key inputs for controlling another entity */
// getconsttable()["FL_CLIENT"] <- (1 << 7);		/**< Is a player */
// getconsttable()["FL_FAKECLIENT"] <- (1 << 8);		/**< Fake client, simulated server side; don't send network messages to them */
// getconsttable()["FL_INWATER"] <- (1 << 9);		/**< In water */
// getconsttable()["FL_FLY"] <- (1 << 10);		/**< Changes the SV_Movestep() behavior to not need to be on ground */
// getconsttable()["FL_SWIM"] <- (1 << 11);		/**< Changes the SV_Movestep() behavior to not need to be on ground (but stay in water) */
// getconsttable()["FL_CONVEYOR"] <- (1 << 12);
// getconsttable()["FL_NPC"] <- (1 << 13);
// getconsttable()["FL_GODMODE"] <- (1 << 14);
// getconsttable()["FL_NOTARGET"] <- (1 << 15);
// getconsttable()["FL_AIMTARGET"] <- (1 << 16);		/**< set if the crosshair needs to aim onto the entity */
// getconsttable()["FL_PARTIALGROUND"] <- (1 << 17);		/**< not all corners are valid */
// getconsttable()["FL_STATICPROP"] <- (1 << 18);		/**< Eetsa static prop!		 */
// getconsttable()["FL_GRAPHED"] <- (1 << 19);		/**< worldgraph has this ent listed as something that blocks a connection */
// getconsttable()["FL_GRENADE"] <- (1 << 20);
// getconsttable()["FL_STEPMOVEMENT"] <- (1 << 21);		/**< Changes the SV_Movestep() behavior to not do any processing */
// getconsttable()["FL_DONTTOUCH"] <- (1 << 22);		/**< Doesn't generate touch functions, generates Untouch() for anything it was touching when this flag was set */
// getconsttable()["FL_BASEVELOCITY"] <- (1 << 23);		/**< Base velocity has been applied this frame (used to convert base velocity into momentum) */
// getconsttable()["FL_WORLDBRUSH"] <- (1 << 24);		/**< Not moveable/removeable brush entity (really part of the world, but represented as an entity for transparency or something) */
// getconsttable()["FL_OBJECT"] <- (1 << 25);		/**< Terrible name. This is an object that NPCs should see. Missiles, for example. */
// getconsttable()["FL_KILLME"] <- (1 << 26);		/**< This entity is marked for death -- will be freed by game DLL */
// getconsttable()["FL_ONFIRE"] <- (1 << 27);		/**< You know... */
// getconsttable()["FL_DISSOLVING"] <- (1 << 28);		/**< We're dissolving! */
// getconsttable()["FL_TRANSRAGDOLL"] <- (1 << 29);		/**< In the process of turning into a client side ragdoll. */
// getconsttable()["FL_UNBLOCKABLE_BY_PLAYER"] <- (1 << 30);		/**< pusher that can't be blocked by the player */
// getconsttable()["FL_FREEZING"] <- (1 << 31);		/**< We're becoming frozen! */
// getconsttable()["FL_EP2V_UNKNOWN1"] <- (1 << 31);		/**< Unknown */






#define GLOWTYPE_NORMAL         0
#define GLOWTYPE_ONUSE          1
#define GLOWTYPE_ONVISIBLE      2
#define GLOWTYPE_CONSTANT       3

#define RENDER_MODE_NORMAL      0
#define RENDER_MODE_TRANSPARENT 3

//Round/Map Variables
char g_strCurrentMap[32] = "";
//new bool:g_bRoundStarted = false;
new g_iRoundCount;
new bool:g_bEndOfRound = false;

//Player Switching Teams timer
new bool:g_bPlayerInTeamChangeCoolDown[MAXPLAYERS + 1];
new bool:g_bClientSpectating[MAXPLAYERS + 1] = false;

// Game Freezing Variables
new bool:g_bGameFrozen = false;
new bool:g_bPlayerPressedButtonThisRound = false;   // This is used to set the countdown timer, it wont start till someone presses a button
new g_iUnfreezeNotifyRunTimes = 1;				    // This is for the unfreeze notify runtimes

// Binds
new g_iClientBindUses_1[MAXPLAYERS + 1];
new g_iClientBindUses_2[MAXPLAYERS + 1];

// Storage of player health for when needed and not provided
new g_iPlayerHealth[MAXPLAYERS + 1];
new g_iPlayerHealthTemp[MAXPLAYERS + 1];

// Name Change Message Blocking
bool g_bHideNameChangeMessage = false;
#define NAME_CHANGE_STRING "#Cstrike_Name_Change"

// Weapon Physics Server Performance fix
#define WEAPON_PROXIMITY_CLEAN_UP_TRIGGER_ITEM_PICKUP_COUNT 8
#define WEAPON_PROXIMITY_CLEAN_UP_TRIGGER_THRESHOLD		    50.0

// Input restrictions
bool g_bMovementLocked[MAXPLAYERS +1];
bool g_bStopAllInput[MAXPLAYERS + 1];

// XPMod SDK Hooked Entities
int g_iXPModEntityType[MAXENTITIES + 1];
float g_fXPModEntityHealth[MAXENTITIES + 1];

// Entity types
#define XPMOD_ENTITY_TYPE_NONE          0
#define XPMOD_ENTITY_TYPE_SMOKER_CLONE  1

// Scripting variables
float g_fGameTimeOfLastGoalSet[MAXPLAYERS + 1];
float g_fGameTimeOfLastDamageTaken[MAXPLAYERS + 1];
float g_fGameTimeOfLastViableTargetSeen[MAXPLAYERS + 1];
bool g_bBotXPMGoalAccomplished[MAXPLAYERS + 1];
new g_iBotXPMGoalTarget[MAXPLAYERS + 1];
float g_xyzBotXPMGoalLocation[MAXPLAYERS + 1][3];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////     Test Variables     /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool g_bDebugModeEnabled;
bool g_bStopCISpawning;
bool g_bStopSISpawning;

new gClone[MAXPLAYERS + 1];
new bool:talentsJustGiven[MAXPLAYERS + 1] = false;
new bool:testtoggle[MAXPLAYERS + 1];
new Float:rspeed;
new bool:canchangemovement[MAXPLAYERS + 1];
new preledgehealth[MAXPLAYERS + 1];
new Float:preledgebuffer[MAXPLAYERS + 1];
new bool:clienthanging[MAXPLAYERS + 1];
//new g_iAbility = 0;
//new Float:g_fEllisTestFireRate = 0.0;
float g_testingSpeedOverride[MAXPLAYERS + 1];