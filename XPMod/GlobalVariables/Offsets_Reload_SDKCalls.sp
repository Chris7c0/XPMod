//SDK Calls
Handle g_hSDK_SetHumanSpec 		= INVALID_HANDLE;
Handle g_hSDK_TakeOverBot 		= INVALID_HANDLE;
Handle g_hSDK_RoundRespawn 		= INVALID_HANDLE;
//Handle g_hSDK_BecomeGhost 		= INVALID_HANDLE;
//Handle g_hSDK_StateTransition 	= INVALID_HANDLE;
Handle g_hSDK_OnPounceEnd		= INVALID_HANDLE;
Handle g_hSDK_VomitOnPlayer 	= INVALID_HANDLE;
Handle g_hSDK_UnVomitOnPlayer 	= INVALID_HANDLE;
Handle g_hSDK_Fling 			= INVALID_HANDLE;
//Testing SDK Calls
//Handle g_hSetClass 			= INVALID_HANDLE;
Handle g_hCreateAbility 			= INVALID_HANDLE;



//Note: pump and chrome have identical values
const float g_flSoHAutoS = 0.666666;
const float g_flSoHAutoI = 0.4;
const float g_flSoHAutoE = 0.675;
const float g_flSoHSpasS = 0.5;
const float g_flSoHSpasI = 0.375;
const float g_flSoHSpasE = 0.699999;
const float g_flSoHPumpS = 0.5;
const float g_flSoHPumpI = 0.5;
const float g_flSoHPumpE = 0.6;

//Offsets for Windows
int g_iOffset_NextActivation = -1;
//new g_iOffset_NextActivation = 1068;
//new g_iOffset_NextActivation = 1084;   //Windows
//new g_iOffset_NextActivation = 1104;   //Linux
//new g_iAttackTimerO = 5436;
int g_iOffset_ShovePenalty = -1;
int g_iOffset_ActiveWeapon = -1;
int g_iOffset_NextPrimaryAttack = -1;
// new g_iOffset_NextSecondaryAttack	= -1;
int g_iOffset_PlaybackRate = -1;
int g_iOffset_TimeWeaponIdle = -1;
int g_iOffset_NextAttack = -1;
int g_iOffset_ReloadStartDuration = -1;
int g_iOffset_ReloadInsertDuration = -1;
int g_iOffset_ReloadEndDuration = -1;
int g_iOffset_ReloadState = -1;
//new g_iOffset_ReloadStartTime		= -1;
int g_iOffset_HealthBuffer = -1;
//new g_iOffset_HealthBufferTime		= -1;
int g_iOffset_CustomAbility = -1;
int g_iOffset_Clip1 = -1;
int g_iOffset_ClipShotgun = -1;
int g_iOffset_IsGhost = -1;
int g_iOffset_ReloadNumShells = -1;
//new g_iOffset_ShellsInserted		= -1;
int g_bOffset_InReload = -1;
//new g_iOffset_Ammo					= -1;

//Reload Animation Reset
int g_iOffset_LayerStartTime = -1;
int g_iOffset_ViewModel = -1;
//For Coach's Jetpack
int g_iOffset_MoveCollide = -1;
int g_iOffset_MoveType = -1;
int g_iOffset_VecVelocity = -1;
//new g_iOffset_OwnerEntity			= -1;

float g_fReloadRate;

float g_fTimeStamp[MAXPLAYERS + 1] = {-1.0, ...};
