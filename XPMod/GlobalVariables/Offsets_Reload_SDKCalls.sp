//SDK Calls
new Handle:g_hSDK_SetHumanSpec 		= INVALID_HANDLE;
new Handle:g_hSDK_TakeOverBot 		= INVALID_HANDLE;
new Handle:g_hSDK_RoundRespawn 		= INVALID_HANDLE;
//new Handle:g_hSDK_BecomeGhost 		= INVALID_HANDLE;
//new Handle:g_hSDK_StateTransition 	= INVALID_HANDLE;
new Handle:g_hSDK_OnPounceEnd		= INVALID_HANDLE;
new Handle:g_hSDK_VomitOnPlayer 	= INVALID_HANDLE;
new Handle:g_hSDK_UnVomitOnPlayer 	= INVALID_HANDLE;
new Handle:g_hSDK_Fling 			= INVALID_HANDLE;
//Testing SDK Calls
//new Handle:g_hSetClass 			= INVALID_HANDLE;
new Handle:g_hCreateAbility 			= INVALID_HANDLE;



//Note: pump and chrome have identical values
const Float:g_flSoHAutoS = 0.666666;
const Float:g_flSoHAutoI = 0.4;
const Float:g_flSoHAutoE = 0.675;
const Float:g_flSoHSpasS = 0.5;
const Float:g_flSoHSpasI = 0.375;
const Float:g_flSoHSpasE = 0.699999;
const Float:g_flSoHPumpS = 0.5;
const Float:g_flSoHPumpI = 0.5;
const Float:g_flSoHPumpE = 0.6;

//Offsets for Windows
new g_iOffset_NextActivation        = -1;
//new g_iOffset_NextActivation = 1068;
//new g_iOffset_NextActivation = 1084;   //Windows
//new g_iOffset_NextActivation = 1104;   //Linux
//new g_iAttackTimerO = 5436;
new g_iOffset_ShovePenalty			= -1;
new g_iOffset_ActiveWeapon			= -1;
new g_iOffset_NextPrimaryAttack		= -1;
// new g_iOffset_NextSecondaryAttack	= -1;
new g_iOffset_PlaybackRate			= -1;
new g_iOffset_TimeWeaponIdle		= -1;
new g_iOffset_NextAttack			= -1;
new g_iOffset_ReloadStartDuration	= -1;
new g_iOffset_ReloadInsertDuration	= -1;
new g_iOffset_ReloadEndDuration		= -1;
new g_iOffset_ReloadState			= -1;
//new g_iOffset_ReloadStartTime		= -1;
new g_iOffset_HealthBuffer			= -1;
//new g_iOffset_HealthBufferTime		= -1;
new g_iOffset_CustomAbility			= -1;
new g_iOffset_Clip1 				= -1;
new g_iOffset_ClipShotgun			= -1;
new g_iOffset_IsGhost				= -1;
new g_iOffset_ReloadNumShells		= -1;
//new g_iOffset_ShellsInserted		= -1;
new g_bOffset_InReload				= -1;
//new g_iOffset_Ammo					= -1;

//Reload Animation Reset
new g_iOffset_LayerStartTime		= -1;
new g_iOffset_ViewModel				= -1;
//For Coach's Jetpack
new g_iOffset_MoveCollide			= -1;
new g_iOffset_MoveType				= -1;
new g_iOffset_VecVelocity			= -1;
//new g_iOffset_OwnerEntity			= -1;

new Float:g_fReloadRate;

new Float:g_fTimeStamp[MAXPLAYERS + 1] = -1.0;


new g_iCurrentFasterAttackWeapon[64] = -1;
new Float:g_fNextFasterAttackTime[64] = -1.0;