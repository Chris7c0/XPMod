// Ban from XPMod servers duration
int g_iBanDurationInMinutes[MAXPLAYERS + 1];

// Game Pausing by Admins
bool g_bGamePaused = false;

bool g_bIsPlayerMuted[MAXPLAYERS + 1];

// Admin Menu Selections
int g_iAdminSelectedClientID[MAXPLAYERS + 1];
int g_iAdminSelectedDuration[MAXPLAYERS + 1];
bool g_bAdminSelectedTargetIsConnected[MAXPLAYERS + 1];
char g_strAdminSelectedTargetSteamID[MAXPLAYERS + 1][32];
char g_strAdminSelectedTargetName[MAXPLAYERS + 1][32];

// Recently Disconnected Connected Players
#define DISCONNECTED_PLAYER_STORAGE_COUNT 500
int g_iDisconnectedPlayerCnt;
char g_strDisconnectedConnectedPlayerNames[DISCONNECTED_PLAYER_STORAGE_COUNT][32];
char g_strDisconnectedConnectedPlayerSteamID[DISCONNECTED_PLAYER_STORAGE_COUNT][32];
