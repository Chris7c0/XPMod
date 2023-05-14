// Debug Modes
#define DEBUG_MODE_TESTING      -1
#define DEBUG_MODE_OFF          0
#define DEBUG_MODE_ERRORS       1
#define DEBUG_MODE_TIMERS       2
#define DEBUG_MODE_VERBOSE      3
#define DEBUG_MODE_EVERYTHING   4

//XPM Options
new g_iXPDisplayMode[MAXPLAYERS + 1];						//Default 0 = Show Sprites; 1 = Show In Chat, 2 = Disabled
// Talent Selection Mode
#define CONVAR_MENU			0
#define CONVAR_WEBSITE		1

// Default Loadout
#define DEFAULT_LOADOUT_PRIMARY_ID              7
#define DEFAULT_LOADOUT_SECONDARY_ID            10
#define DEFAULT_LOADOUT_HEALTH_ID               1
#define DEFAULT_LOADOUT_EXPLOSIVE_ID            2
#define DEFAULT_LOADOUT_BOOST_ID                1


// ConVars
ConVar g_hCVar_DebugModeLogLevel;
new g_iDebugModeLogLevel = DEBUG_MODE_OFF;
ConVar g_hCVar_DebugModeEnabled;
ConVar g_hCVar_IdleKickEnabled;
// XP Loadout Use and Gain Enabled
ConVar g_hCVar_XPSaveForHighLevelsEnabled;
new XPSaveForHighLevelsEnabled = true;
// Talent selection mode website or through in game menu
// ConVar g_hCVar_TalentSelectionMode ;
//new g_iTalentSelectionMode                    = CONVAR_WEBSITE;
// Default Classes
ConVar g_hCVar_DefaultSurvivor;
new g_iDefaultSurvivor                          = BILL;
ConVar g_hCVar_DefaultInfecttedSlot1;
new g_iDefaultInfectedSlot1                     = BOOMER;
ConVar g_hCVar_DefaultInfecttedSlot2;
new g_iDefaultInfectedSlot2                     = JOCKEY;
ConVar g_hCVar_DefaultInfecttedSlot3;
new g_iDefaultInfectedSlot3                     = SMOKER;



//Default and Max L4D2 Convar values
#define CONVAR_SB_ENFORCE_PROXIMITY_RANGE_DEFAULT   1500
#define CONVAR_SB_ENFORCE_PROXIMITY_RANGE_MAX       99999999