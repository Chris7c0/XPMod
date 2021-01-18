// ConVars
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


//XPM Options
new g_iXPDisplayMode[MAXPLAYERS + 1];						//Default 0 = Show Sprites; 1 = Show In Chat, 2 = Disabled
// Talent Selection Mode
#define CONVAR_MENU			0
#define CONVAR_WEBSITE		1