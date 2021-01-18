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