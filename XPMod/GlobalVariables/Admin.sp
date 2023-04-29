// Ban from XPMod servers duration
new g_iBanDurationInMinutes[MAXPLAYERS + 1];

// Game Pausing by Admins
bool g_bGamePaused = false;

new g_bIsPlayerMuted[MAXPLAYERS + 1];

// Admin Menu Selections
new g_iAdminSelectedClientID[MAXPLAYERS + 1];
new g_iAdminSelectedSteamID[MAXPLAYERS + 1];
new g_iAdminSelectedDuration[MAXPLAYERS + 1];

// Recently Disconnected Connected Players
#define DISCONNECTED_PLAYER_STORAGE_COUNT 500
new g_iDisconnectedPlayerCnt;
char g_strDisconnectedConnectedPlayerNames[DISCONNECTED_PLAYER_STORAGE_COUNT][32];
char g_strDisconnectedConnectedPlayerSteamID[DISCONNECTED_PLAYER_STORAGE_COUNT][32];