// Common                                                           
new clientidname[MAXPLAYERS + 1][32];			//SHOULD BE A STRING?
new g_iClientTeam[MAXPLAYERS + 1];
new bool:g_bClientLoggedIn[MAXPLAYERS + 1];
new g_iDBUserID[MAXPLAYERS + 1] = -1;
new String:g_strDBUserToken[MAXPLAYERS + 1][41];
new bool:g_bCanSave = true;
new bool:g_bSurvivorTalentsGivenThisRound[MAXPLAYERS + 1] = false;
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

//Announcer Sound Variables
new bool:g_bCanPlayHeadshotSound[MAXPLAYERS + 1];
new bool:g_bAnnouncerOn[MAXPLAYERS + 1];

// Confirmation Variables
new bool:g_bTalentsConfirmed[MAXPLAYERS + 1];
new bool:g_bUserStoppedConfirmation[MAXPLAYERS + 1];
new bool:g_bClientAlreadyShownCharacterSelectMenu[MAXPLAYERS + 1];
new g_iAutoSetCountDown[MAXPLAYERS + 1];
//Drawing Character Select MOTD and Talents Confirm Menu
#define STARTING_CHAR_SELECT_PROCESS                1
#define WAITING_ON_BUTTON_FOR_MOTD                  2
#define WAITING_ON_RELEASE_FOR_CONFIRM_MENU         3
#define WAITING_ON_FINAL_BUTTON_FOR_CONFIRM_MENU    4
#define FINISHED_AND_DREW_CONFIRM_MENU              5
new g_iOpenCharacterSelectAndDrawMenuState[MAXPLAYERS + 1];