//Timer Handles
new Handle:g_hTimer_ResetHideNameChangeMessage 				= null;
new Handle:g_hTimer_FreezeCountdown 						= null;
new Handle:g_hTimer_ShowingConfirmTalents[MAXPLAYERS + 1]	= null;
new Handle:g_hTimer_ExtinguishTank[MAXPLAYERS + 1]		    = null;
new Handle:g_hTimer_VictimHealthMeterStop[MAXPLAYERS + 1]	= null;
new Handle:g_hTimer_SelfReviveCheck[MAXPLAYERS + 1]	        = null;
new Handle:g_hTimer_DrugPlayer[MAXPLAYERS + 1] 				= null;
new Handle:g_hTimer_HallucinatePlayer[MAXPLAYERS + 1]		= null;
new Handle:g_hTimer_SlapPlayer[MAXPLAYERS + 1] 				= null;
new Handle:g_hTimer_RochellePoison[MAXPLAYERS + 1] 			= null;
new Handle:g_hTimer_HunterPoison[MAXPLAYERS + 1] 			= null;
new Handle:g_hTimer_NickLifeSteal[MAXPLAYERS + 1] 			= null;
new Handle:g_hTimer_BillDropBombs[MAXPLAYERS + 1] 			= null;
new Handle:g_hTimer_LouisTeleportRegenerate[MAXPLAYERS + 1] = null;
new Handle:g_hTimer_UntangleSurvivorCheck[MAXPLAYERS + 1]   = null;
new Handle:g_hTimer_TimerKeepBotFocusedOnXPModGoal[MAXPLAYERS + 1] =  null;
new Handle:g_hTimer_IceSphere[MAXPLAYERS + 1]				= null;
new Handle:g_hTimer_WingDashChargeRegenerate[MAXPLAYERS + 1]= null;
new Handle:g_hTimer_AdhesiveGooReset[MAXPLAYERS + 1] 		= null;
new Handle:g_hTimer_DemiGooReset[MAXPLAYERS + 1] 			= null;
new Handle:g_hTimer_ResetGlow[MAXPLAYERS + 1] 	            = null;
new Handle:g_hTimer_ViralInfectionTick[MAXPLAYERS + 1] 		= null;
new Handle:g_hTimer_BlockGooSwitching[MAXPLAYERS + 1] 		= null;