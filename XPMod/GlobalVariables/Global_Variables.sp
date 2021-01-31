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

//Gamemode
new g_iGameMode;

// Server Name
new String:g_strServerName[64]              = "";
// Log File Paths
//new String:g_strXPMStatsFullFilePath[256]   = "";


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
#define DB_CONF_NAME 	"xpmod"
#define DB_TABLENAME  	"users"


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////     MISC VARIABLES     /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Menus
new Handle:g_hMenu_XPM[MAXPLAYERS + 1]  = INVALID_HANDLE;
new Handle:g_hMenu_IDD[MAXPLAYERS + 1]  = INVALID_HANDLE;

// Math
new Float:PI = 3.1415926;
new Float:EMPTY_VECTOR[3] = 0.0;

//Survivor Character ID Definitions
#define BILL			0
#define ROCHELLE		1
#define COACH			2
#define ELLIS			3
#define NICK			4

// These are the actual game values (change to later)
// #define     NICK     	0
// #define     ROCHELLE    1
// #define     COACH     	2
// #define     ELLIS     	3
// #define     BILL     	4
// #define     ZOEY     	5
// #define     FRANCIS     6
// #define     LOUIS     	7

new String:SURVIVOR_NAME[][] =          {"BILL", 
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
#define DAMAGETYPE_INFECTED_MELEE	128
#define DAMAGETYPE_HUNTER_POUNCE	1
#define DAMAGETYPE_FIRE1			8
#define DAMAGETYPE_FIRE2			2056
#define DAMAGETYPE_IGNITED_ENTITY	268435464
#define DAMAGETYPE_BLOCK_REVIVING	65536
#define DAMAGETYPE_SPITTER_GOO		263168

// Movement Types
#define MOVECOLLIDE_DEFAULT 	0
#define MOVECOLLIDE_FLY_BOUNCE 	1
#define MOVETYPE_WALK 			2
#define MOVETYPE_FLYGRAVITY 	5

#define GLOWTYPE_NORMAL         0
#define GLOWTYPE_ONUSE          1
#define GLOWTYPE_ONVISIBLE      2
#define GLOWTYPE_CONSTANT       3

#define RENDER_MODE_NORMAL      0
#define RENDER_MODE_TRANSPARENT 3

//Round/Map Variables
//new bool:g_bRoundStarted = false;
new bool:g_bEndOfRound = false;

//Player Switching Teams timer
new bool:g_bPlayerInTeamChangeCoolDown[MAXPLAYERS + 1];
new bool:g_bClientSpectating[MAXPLAYERS + 1] = false;

// Game Freezing Variables
new bool:g_bGameFrozen = false;
new bool:g_bPlayerPressedButtonThisRound = false;   // This is used to set thte countdown timer, it wont start till  someone presses a button
new g_iUnfreezeNotifyRunTimes = 1;				    //for the unfreeze notify runtimes
new g_iPrintRunTimes = -1;							//for printing time left till unfreeze in unfreeze notification timer

// Cheat Flags
new g_iFlag_Give;
new g_iFlag_UpgradeAdd;
//new g_iFlag_UpgradeRemove;
new g_iFlag_SpawnOld;

// Binds
new g_iClientBindUses_1[MAXPLAYERS + 1];
new g_iClientBindUses_2[MAXPLAYERS + 1];

// Name Change Message Blocking
bool g_bHideNameChangeMessage = false;
#define NAME_CHANGE_STRING "#Cstrike_Name_Change"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////     Test Variables     /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

new gClone[MAXPLAYERS + 1];
new bool:talentsJustGiven[MAXPLAYERS + 1] = false;
new bool:testtoggle[MAXPLAYERS + 1];
new Float:rspeed;
new bool:canchangemovement[MAXPLAYERS + 1];
new preledgehealth[MAXPLAYERS + 1];
new Float:preledgebuffer[MAXPLAYERS + 1];
new bool:clienthanging[MAXPLAYERS + 1];
//new g_iAbility = 0;