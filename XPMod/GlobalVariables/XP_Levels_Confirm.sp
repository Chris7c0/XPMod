// Common                                                           
char clientidname[MAXPLAYERS + 1][32];//SHOULD BE A STRING?
int g_iClientTeam[MAXPLAYERS + 1];
bool g_bClientLoggedIn[MAXPLAYERS + 1];
int g_iDBUserID[MAXPLAYERS + 1] = {-1, ...};
char g_strDBUserToken[MAXPLAYERS + 1][41];
bool g_bCanSave = true;
bool g_bSurvivorTalentsGivenThisRound[MAXPLAYERS + 1] = {false, ...};
int g_iClientXP[MAXPLAYERS + 1];
int g_iClientLevel[MAXPLAYERS + 1];
int g_iClientPrestigePoints[MAXPLAYERS + 1];
int g_iChosenSurvivor[MAXPLAYERS + 1];
int g_iClientNextLevelXPAmount[MAXPLAYERS + 1];
int g_iClientPreviousLevelXPAmount[MAXPLAYERS + 1];
int g_iSkillPoints[MAXPLAYERS + 1];
int g_iInfectedCharacter[MAXPLAYERS + 1];
int g_iInfectedLevel[MAXPLAYERS + 1];
int g_iClientUsableXP = -1;
int g_iClientTotalXPCost[MAXPLAYERS + 1];

///////////////////////   XP Amounts   ////////////////////////
// Multiplier amount for player levels (1.0 is default)
// The higher this number is, the more xp it takes for
// a player to reach each level.
#define	XP_MULTIPLIER	1.0

//Default XP amount required to reach each level
#define LEVEL_1  100
#define LEVEL_2  300
#define LEVEL_3  600
#define LEVEL_4  1000
#define LEVEL_5  1500
#define LEVEL_6  2100
#define LEVEL_7  2800
#define LEVEL_8  3600
#define LEVEL_9  4500
#define LEVEL_10 5500
#define LEVEL_11 6600
#define LEVEL_12 7800
#define LEVEL_13 9100
#define LEVEL_14 10500
#define LEVEL_15 12000
#define LEVEL_16 13600
#define LEVEL_17 15300
#define LEVEL_18 17100
#define LEVEL_19 19000
#define LEVEL_20 21000
#define LEVEL_21 23100
#define LEVEL_22 25300
#define LEVEL_23 27600
#define LEVEL_24 30000
#define LEVEL_25 32500
#define LEVEL_26 35100
#define LEVEL_27 37800
#define LEVEL_28 40600
#define LEVEL_29 43500
#define LEVEL_30 46500

//Vote Kick Immunity
#define VOTE_KICK_IMMUNITY_XP_THRESHOLD 200000

//Stats
int g_iStat_ClientInfectedKilled[MAXPLAYERS + 1];
int g_iStat_ClientCommonKilled[MAXPLAYERS + 1];
int g_iStat_ClientCommonHeadshots[MAXPLAYERS + 1];
int g_iStat_ClientSurvivorsKilled[MAXPLAYERS + 1];
int g_iStat_ClientSurvivorsIncaps[MAXPLAYERS + 1];
int g_iStat_ClientDamageToSurvivors[MAXPLAYERS + 1];
//Last Round Stats
int g_iStat_LastRound_ClientInfectedKilled[MAXPLAYERS + 1];
int g_iStat_LastRound_ClientCommonKilled[MAXPLAYERS + 1];
int g_iStat_LastRound_ClientCommonHeadshots[MAXPLAYERS + 1];
int g_iStat_LastRound_ClientSurvivorsKilled[MAXPLAYERS + 1];
int g_iStat_LastRound_ClientSurvivorsIncaps[MAXPLAYERS + 1];
int g_iStat_LastRound_ClientDamageToSurvivors[MAXPLAYERS + 1];
//Top XPMod Players
char g_strTopXPModPlayersStatsText[600];

//Rewards
int g_iReward_SIKills;
int g_iReward_SIKillsID;
char g_strReward_SIKills[32];
int g_iReward_CIKills;
int g_iReward_CIKillsID;
char g_strReward_CIKills[32];
int g_iReward_HS;
int g_iReward_HSID;
char g_strReward_HS[32];
int g_iReward_SurKills;
int g_iReward_SurKillsID;
char g_strReward_SurKills[32];
int g_iReward_SurIncaps;
int g_iReward_SurIncapsID;
char g_strReward_SurIncaps[32];
int g_iReward_SurDmg;
int g_iReward_SurDmgID;
char g_strReward_SurDmg[32];
//Statistic Panel Shown After Confirmation
int RoundStatsPanel[MAXPLAYERS + 1];
#define ROUND_STATS_PANEL_LAST_ROUND_INDIVIDUAL     0
#define ROUND_STATS_PANEL_LAST_ROUND_TOP_PLAYERS    1
#define ROUND_STATS_PANEL_XPMOD_TOP_PLAYERS         2
#define ROUND_STATS_PANEL_DONE                      3
#define ROUND_STATS_PANEL_LIFETIME                  7.0

//Announcer Sound Variables
bool g_bCanPlayHeadshotSound[MAXPLAYERS + 1];
bool g_bAnnouncerOn[MAXPLAYERS + 1];

// Confirmation Variables
bool g_bTalentsConfirmed[MAXPLAYERS + 1];
bool g_bUserStoppedConfirmation[MAXPLAYERS + 1];
bool g_bClientAlreadyShownCharacterSelectMenu[MAXPLAYERS + 1];
int g_iAutoSetCountDown[MAXPLAYERS + 1];
//Drawing Character Select MOTD and Talents Confirm Menu
#define STARTING_CHAR_SELECT_PROCESS                1
#define WAITING_ON_BUTTON_FOR_MOTD                  2
#define WAITING_ON_RELEASE_FOR_CONFIRM_MENU         3
#define WAITING_ON_FINAL_BUTTON_FOR_CONFIRM_MENU    4
#define FINISHED_AND_DREW_CONFIRM_MENU              5
int g_iOpenCharacterSelectAndDrawMenuState[MAXPLAYERS + 1];
