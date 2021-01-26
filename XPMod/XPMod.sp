/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
//  ___/\\\_______/\\\___/\\\\\\\\\\\\\__________/\\\\____________/\\\\_________________________/\\\__         //
// | \_\///\\\___/\\\/___\/\\\/////////\\\_______\/\\\\\\________/\\\\\\________________________\/\\\__        //
//  \ \___\///\\\\\\/_____\/\\\_______\/\\\_______\/\\\//\\\____/\\\//\\\________________________\/\\\__       //
//   \ \_____\//\\\\_______\/\\\\\\\\\\\\\/________\/\\\\///\\\/\\\/_\/\\\______/\\\\\____________\/\\\__      //
//    \ \______\/\\\\_______\/\\\/////////__________\/\\\__\///\\\/___\/\\\____/\\\///\\\_____/\\\\\\\\\__     //
//     \ \______/\\\\\\______\/\\\___________________\/\\\____\///_____\/\\\___/\\\__\//\\\___/\\\////\\\__    //
//      \ \____/\\\////\\\____\/\\\___________________\/\\\_____________\/\\\__\//\\\__/\\\___\/\\\__\/\\\__   //
//       \ \__/\\\/___\///\\\__\/\\\___________________\/\\\_____________\/\\\___\///\\\\\/____\//\\\\\\\/\\_  //
//        \ \_\///_______\///___\///____________________\///______________\///______\/////_______\///////\//__ //
//         \////////////////////////////////////////////////////////////////////////////////////////////////// //
//                                                                                                             //
//                                                                                                             //
//          Created by: Chris Pringle and Ezekiel Keener                                                       //
//                                                                                                             //
//                                                                                                             //
//			Many thanks to the developers at the Allied Modders forums! This mod would not be what it          //
//          is today if not for the time spent attempting to understand the code written and posted by         //
//          the kind people on this forum. A huge thanks to TPoncho for all of his hard work on Perkmod.       //
//          Also, many thanks to AtomicStryker, McFlurry, Pan Xiaohai, sumguy14, djromero, and to the          //
//          countless others that are too plentiful to mention here. Thank you guys!                           //
//                                                                                                             //
//          We hope you enjoy XP Mod.                                                                          //
//                                                                                                             //
//                                                                                                             //
//          Contact Information:                                                                               //
//                                                                                                             //
//            Chris Pringle: chris7c0@gmail.com          Ezekiel Keener: ezekiel.keener@yahoo.com              //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <regex>

// Added custom includes
#include <sha1>

// XPMod Include Files
// Global Variables
#include "XPMod/GlobalVariables/Global_Variables.sp"
#include "XPMod/GlobalVariables/ConVars.sp"
#include "XPMod/GlobalVariables/Infected.sp"
#include "XPMod/GlobalVariables/Models_Particles_Anims.sp"
#include "XPMod/GlobalVariables/Offsets_Reload_SDKCalls.sp"
#include "XPMod/GlobalVariables/Sounds.sp"
#include "XPMod/GlobalVariables/Survivors.sp"
#include "XPMod/GlobalVariables/Talent_Levels.sp"
#include "XPMod/GlobalVariables/Timers.sp"
#include "XPMod/GlobalVariables/XP_Levels_Confirm.sp"
// Misc
#include "XPMod/Misc/Generic_Functions.sp"
#include "XPMod/Misc/ConVars.sp"
#include "XPMod/Misc/Particle_Effects.sp"
#include "XPMod/Misc/Precache.sp"
#include "XPMod/Misc/Statistics.sp"
#include "XPMod/Misc/SpawnInfected.sp"
#include "XPMod/Misc/MovementSpeed.sp"
//#include "XPMod/Misc/Abilities.sp"
#include "XPMod/Misc/Testing.sp"	                   //Remove before relase/////////////////////////////////////////////////////////////////////////
//Experience and User Data Management
#include "XPMod/XP/XP_Management.sp"
#include "XPMod/XP/XP_SQLDatabase.sp"
//Menu Navigation Files
#include "XPMod/Menus/Menu_Main.sp"
#include "XPMod/Menus/Menu_NewUser.sp"
#include "XPMod/Menus/Menu_Confirm.sp"
#include "XPMod/Menus/Menu_Loadouts.sp"
#include "XPMod/Menus/S/Menu_Survivors.sp"
#include "XPMod/Menus/S/Menu_Rochelle.sp"
#include "XPMod/Menus/S/Menu_Coach.sp"
#include "XPMod/Menus/S/Menu_Ellis.sp"
#include "XPMod/Menus/S/Menu_Nick.sp"
#include "XPMod/Menus/S/Menu_Bill.sp"
#include "XPMod/Menus/I/Menu_Infected.sp"
#include "XPMod/Menus/I/Menu_Boomer.sp"
#include "XPMod/Menus/I/Menu_Smoker.sp"
#include "XPMod/Menus/I/Menu_Hunter.sp"
#include "XPMod/Menus/I/Menu_Spitter.sp"
#include "XPMod/Menus/I/Menu_Charger.sp"
#include "XPMod/Menus/I/Menu_Jockey.sp"
#include "XPMod/Menus/I/Tanks/Menu_Tank.sp"
#include "XPMod/Menus/I/Tanks/Menu_Tank_Fire.sp"
#include "XPMod/Menus/I/Tanks/Menu_Tank_Ice.sp"
#include "XPMod/Menus/I/Tanks/Menu_Tank_NecroTanker.sp"
#include "XPMod/Menus/I/Tanks/Menu_Tank_Vampiric.sp"
//Game Event Files
#include "XPMod/Events/Events_Main.sp"
#include "XPMod/Events/Events_SDK_Hooks.sp"
#include "XPMod/Events/Events_OnGameFrame.sp"
#include "XPMod/Events/Events_Survivors.sp"
#include "XPMod/Events/Events_Infected.sp"
#include "XPMod/Events/Events_Hurt.sp"
#include "XPMod/Events/Events_Death.sp"
#include "XPMod/Events/Events_Reload.sp"
//Player Talent Files
#include "XPMod/Talents/Talents_Load.sp"
#include "XPMod/Talents/S/Talents_Rochelle.sp"
#include "XPMod/Talents/S/Talents_Coach.sp"
#include "XPMod/Talents/S/Talents_Ellis.sp"
#include "XPMod/Talents/S/Talents_Nick.sp"
#include "XPMod/Talents/S/Talents_Bill.sp"
#include "XPMod/Talents/I/Talents_Boomer.sp"
#include "XPMod/Talents/I/Talents_Smoker.sp"
#include "XPMod/Talents/I/Talents_Hunter.sp"
#include "XPMod/Talents/I/Talents_Spitter.sp"
#include "XPMod/Talents/I/Talents_Charger.sp"
#include "XPMod/Talents/I/Talents_Jockey.sp"
#include "XPMod/Talents/I/Tanks/Talents_Tank.sp"
#include "XPMod/Talents/I/Tanks/Talents_Tank_Fire.sp"
#include "XPMod/Talents/I/Tanks/Talents_Tank_Ice.sp"
#include "XPMod/Talents/I/Tanks/Talents_Tank_NecroTanker.sp"
#include "XPMod/Talents/I/Tanks/Talents_Tank_Vampiric.sp"
//Binded Key Press Files
#include "XPMod/Binds/Bind_1.sp"
#include "XPMod/Binds/Bind_2.sp"
//Timer Files
#include "XPMod/Timers/Timers_Generic.sp"
#include "XPMod/Timers/Timers_Messages.sp"
#include "XPMod/Timers/Timers_Rewards.sp"
#include "XPMod/Timers/S/Timers_Rochelle.sp"
#include "XPMod/Timers/S/Timers_Coach.sp"
#include "XPMod/Timers/S/Timers_Ellis.sp"
#include "XPMod/Timers/S/Timers_Nick.sp"
#include "XPMod/Timers/S/Timers_Bill.sp"
#include "XPMod/Timers/I/Timers_Boomer.sp"
#include "XPMod/Timers/I/Timers_Smoker.sp"
#include "XPMod/Timers/I/Timers_Hunter.sp"
#include "XPMod/Timers/I/Timers_Spitter.sp"
#include "XPMod/Timers/I/Timers_Charger.sp"
#include "XPMod/Timers/I/Timers_Jockey.sp"
#include "XPMod/Timers/I/Timers_Tank.sp"

public Plugin:myinfo =
{
	name = "XPMod",
	author = "Chris Pringle and Ezekiel Keener",
	description = "This is an experience plugin developed for Left4Dead 2. This plugin provides talents for players that have leveled up by earning experience points.",
	version = PLUGIN_VERSION,
	url = "http://www.l4d2xpmod.com"
}

public OnPluginStart()
{
	//Check for Left4Dead 2
	decl String:strGameName[64];
	GetGameFolderName(strGameName, sizeof(strGameName));
	
	if (StrEqual(strGameName, "left4dead2", false) == false)
		SetFailState("XPMod only works in Left4Dead 2.");
	else
		CreateTimer(10.0, Timer_ShowXPModInfoToServer, _);

	// Set up ConVars
	SetupXPMConVars();
		
	//Setup the handle that will link to the MySQL Database
	if(ConnectDB())
	{
		PrintToServer("\n*** Connected to XPMod Database ***\n ");
	}
	else
	{
		PrintToServer("\n********************************************");
		PrintToServer("*** Could Not Connect to XPMod Database! ***");
		PrintToServer("********************************************\n ");
	}

	//Setup Included Files
	SetupLoadouts();
	//Setup Hooks
	SetupXPMEvents();
	//Setup Console Commands clients can use
	SetupConsoleCommands();
	//FindGameOffsets
	SetupGameOffsets();
	//Prep the SDK Call commands
	SetupSDKCalls();
	
	//Set initial values for variables
	for(new i = 0; i <= MaxClients; i++)
	{
		g_iClientNextLevelXPAmount[i] = RoundToFloor(LEVEL_1 * XP_MULTIPLIER);
		
		//Set Infected classes to their initial values
		g_iClientInfectedClass1[i]	= UNKNOWN_INFECTED;
		g_iClientInfectedClass2[i]	= UNKNOWN_INFECTED;
		g_iClientInfectedClass3[i]	= UNKNOWN_INFECTED;
		g_strClientInfectedClass1[i] = "None"; 
		g_strClientInfectedClass2[i] = "None";
		g_strClientInfectedClass3[i] = "None";

		ResetVariablesForMap(i);
		
		//Initially set the client name to all null characters
		for(new l=0; l<23; l++)
			clientidname[i][l] = '\0';
	}
	
	//Start the repeating timers
	CreateTimer(1.0, TimerCheckAndOpenCharacterSelectionMenuForAll, 0, TIMER_REPEAT);
	//CreateTimer(20.0, TimerLogXPMStatsToFile, 0, TIMER_REPEAT);
	CreateTimer(2.0, TimerResetMelee, 0, TIMER_REPEAT);
	CreateTimer(0.1, TimerIDD, 0, TIMER_REPEAT);
	CreateTimer(90.0, PrintUnsetClassesMessage, 0, TIMER_REPEAT);
	CreateTimer(60.0, PrintXPModCreateAndConfirmMessageToAll, 0, TIMER_REPEAT);
	CreateTimer(300.0, PrintXPModAdvertisementMessageToAll, 0, TIMER_REPEAT);
	
	PrecacheLockedWeaponModels();											//Precache locked weapon models
	// This is no longer need with the last stand update (also, this was causing crash when xpmod was replaced witth an update)
	//CreateTimer(1.0, Timer_PrepareCSWeapons, _, TIMER_FLAG_NO_MAPCHANGE);	//Prep the cs weapons for first use

	//Setup Global ArrayLists
	g_listTankRockEntities = CreateArray(TANK_ROCK_ENTITIES_ARRAY_LIST_SIZE);
}

SetupConsoleCommands()
{
	RegConsoleCmd("xpmstats", ShowTeamStatsToPlayer);
	RegConsoleCmd("website", MotdPanel);
	RegConsoleCmd("xpmhelp", OpenHelpMotdPanel);
	//RegConsoleCmd("resetmyaccount", ResetAll);			//Reset Level, skillpoints, XP,  and talents
	RegConsoleCmd("xpmbind1", Bind1Press);				//This is the binded key function for ultimate abilites, Bind 1
	RegConsoleCmd("xpmbind2", Bind2Press);				//This is the binded key function for ultimate abilites, Bind 2
	RegConsoleCmd("xpmbinduses", ShowBindsRemaining);		//Display the total number of bind1 and bind2 uses left
	
	RegConsoleCmd("say", SayCmd);
	RegConsoleCmd("say_team", SayTeamCmd);
	
	RegAdminCmd("freeze", FreezeGame, ADMFLAG_SLAY);
	RegAdminCmd("givexp", GiveXP, ADMFLAG_SLAY);
	RegAdminCmd("giveidxp", GiveXPbyID, ADMFLAG_SLAY);
	
	RegConsoleCmd("closepanel", CloseClientPanel);
	//To be coded
	//RegConsoleCmd("s",Spectate);
	//RegConsoleCmd("showallxp", ShowAllXP);		//Shows all players XP points and level to iClient that typed it (once a round?)

	
	//Misc. Commands
	RegAdminCmd("t1", TestFunction1, ADMFLAG_SLAY);
	RegAdminCmd("t2", TestFunction2, ADMFLAG_SLAY);
	RegAdminCmd("t3", TestFunction3, ADMFLAG_SLAY);
	RegAdminCmd("t4", TestFunction4, ADMFLAG_SLAY);
	RegAdminCmd("t5", TestFunction5, ADMFLAG_SLAY);
	RegAdminCmd("omghaxor", GiveMoreBinds, ADMFLAG_SLAY);
	//RegConsoleCmd("push", push);
	//RegConsoleCmd("pop", pop);
	//RegAdminCmd("s", ChangeSpeed, ADMFLAG_SLAY);
	//RegConsoleCmd("sprite", Command_sprite); 
}

SetupGameOffsets()
{
	g_iOffset_ShovePenalty			= FindSendPropInfo("CTerrorPlayer", "m_iShovePenalty");
	g_iOffset_PlaybackRate			= FindSendPropInfo("CBaseCombatWeapon", "m_flPlaybackRate");
	g_iOffset_ActiveWeapon			= FindSendPropInfo("CBaseCombatCharacter", "m_hActiveWeapon");
	g_iOffset_NextPrimaryAttack		= FindSendPropInfo("CBaseCombatWeapon", "m_flNextPrimaryAttack");
	g_iOffset_NextSecondaryAttack 	= FindSendPropInfo("CBaseCombatWeapon", "m_flNextSecondaryAttack");
	g_iOffset_TimeWeaponIdle		= FindSendPropInfo("CTerrorGun", "m_flTimeWeaponIdle");
	g_iOffset_NextAttack			= FindSendPropInfo("CTerrorPlayer", "m_flNextAttack");
	g_iOffset_ReloadStartDuration	= FindSendPropInfo("CBaseShotgun", "m_reloadStartDuration");
	g_iOffset_ReloadInsertDuration	= FindSendPropInfo("CBaseShotgun", "m_reloadInsertDuration");
	g_iOffset_ReloadEndDuration		= FindSendPropInfo("CBaseShotgun", "m_reloadEndDuration");
	g_iOffset_ReloadState			= FindSendPropInfo("CBaseShotgun", "m_reloadState");
	//g_iOffset_ReloadStartTime		= FindSendPropInfo("CBaseShotgun", "m_reloadStartTime");
	g_iOffset_LayerStartTime		= FindSendPropInfo("CTerrorViewModel", "m_flLayerStartTime");
	g_iOffset_ViewModel				= FindSendPropInfo("CTerrorPlayer", "m_hViewModel");
	g_iOffset_HealthBuffer			= FindSendPropInfo("CTerrorPlayer", "m_healthBuffer");
	//g_iOffset_HealthBufferTime		= FindSendPropInfo("CTerrorPlayer", "m_healthBufferTime");
	g_iOffset_CustomAbility			= FindSendPropInfo("CTerrorPlayer", "m_customAbility");
	g_iOffset_Clip1					= FindSendPropInfo("CAssaultRifle", "m_iClip1");
	g_iOffset_ClipShotgun			= FindSendPropInfo("CBaseShotgun", "m_iClip1");
	g_iOffset_MoveCollide 			= FindSendPropInfo("CBaseEntity", "movecollide");
	g_iOffset_MoveType    			= FindSendPropInfo("CBaseEntity", "movetype");
	g_iOffset_VecVelocity   		= FindSendPropInfo("CBasePlayer", "m_vecVelocity[0]");
	g_iOffset_IsGhost       		= FindSendPropInfo("CTerrorPlayer", "m_isGhost");
	//g_iOffset_OwnerEntity			= FindSendPropInfo("CBaseCombatWeapon", "m_hOwnerEntity");
	g_iOffset_ReloadNumShells		= FindSendPropInfo("CBaseShotgun", "m_reloadNumShells");
	//g_iOffset_ShellsInserted		= FindSendPropInfo("CBaseShotgun", "m_shellsInserted");
	g_bOffset_InReload				= FindSendPropInfo("CBaseShotgun", "m_bInReload");
	//g_iOffset_Ammo					= FindDataMapOffs("CTerrorPlayer", "m_iAmmo");
	
	g_umsgFade = GetUserMessageId("Fade");
}

public OnMapStart()
{
	//PrintToServer("OnMapStart ========================================================================================================")
	
	// Increase the uncommon limit for the NecroTanker and Spitter conjurer abilities
	// Also, more is better...
	SetConVarInt(FindConVar("z_common_limit"), 45);	
	//SetConVarInt(FindConVar("z_background_limit"), 45);		// Not required
	
	// Increases the spawn distance
	// Commented out to ensure that zombies spawn closer to the action
	//SetConVarInt(FindConVar("z_spawn_range"), 2500);	//Required or common will disappear when spawned out of range of NecroTanker
	//SetConVarInt(FindConVar("z_discard_range"), 3000); 	//Required or common will disappear when spawned out of range of NecroTanker
	
	// Set the filename for the log to the server name
	GetConVarString(FindConVar("hostname"), g_strServerName, sizeof(g_strServerName));
	// Get the log file name
	SetXPMStatsLogFileName();
	

	DispatchKeyValue(0, "timeofday", "1"); //Set time of day to midnight
	
	//Set the g_iGameMode variable
	FindGameMode();
	
	//Precache everything needed for XPMod
	PrecacheAllTextures();	
	PrecacheAllModels();
	PrecacheAllParticles();
	PrecacheAllSounds();
	
	//Set the max teleport height for the map
	SetMapsMaxTeleportHeight();
}

FindGameMode()
{
	decl String:g_strGameMode[20];
	GetConVarString(FindConVar("mp_gamemode"), g_strGameMode, sizeof(g_strGameMode));
	
	if (StrEqual(g_strGameMode,"coop",true))
		g_iGameMode = GAMEMODE_COOP;
	else if (StrEqual(g_strGameMode,"versus",true))
		g_iGameMode = GAMEMODE_VERSUS;
	else if (StrEqual(g_strGameMode,"teamversus",true))
		g_iGameMode = GAMEMODE_UNKNOWN;
	else if (StrEqual(g_strGameMode,"teamscavenge",true))
		g_iGameMode = GAMEMODE_SCAVENGE;
	else if (StrEqual(g_strGameMode,"scavenge",true))
		g_iGameMode = GAMEMODE_SCAVENGE;
	else if (StrEqual(g_strGameMode,"survival",true))
		g_iGameMode = GAMEMODE_SURVIVAL;
	else if (StrEqual(g_strGameMode,"realism",true))
		g_iGameMode = GAMEMODE_UNKNOWN;
	else
		g_iGameMode = GAMEMODE_UNKNOWN;
}

ResetVariablesForMap(iClient)
{
	ResetTalentConfirmCountdown(iClient);
	
	g_iEllisMaxHealth[iClient] = 100;
	g_iNickMaxHealth[iClient] = 100;
	g_bTalentsGiven[iClient] = false;
	g_bPlayerInTeamChangeCoolDown[iClient] = false;
	g_fTimeStamp[iClient] = -1.0;
	g_iFastAttackingClientsArray[iClient] = -1;
	g_bDoesClientAttackFast[iClient] = false;
	g_iClientBindUses_1[iClient] = 0;
	g_iClientBindUses_2[iClient] = 0;
	g_iEllisSpeedBoostCounter[iClient] = 0;
	g_bIsFlyingWithJetpack[iClient] = false;
	g_iClientJetpackFuelUsed[iClient] = 0;
	g_bIsJetpackOn[iClient] = false;
	g_iCoachDecapitationCounter[iClient] = 0;
	g_iMeleeDamageCounter[iClient] = 0;
	g_bIsHighJumpCharged[iClient] = false;
	g_bIsWreckingBallCharged[iClient] = false;
	g_iExtraExplosiveUses[iClient] = 0;
	g_iBillSprintChargeCounter[iClient] = 0;
	g_bBillSprinting[iClient] = false;
	g_iSilentSorrowHeadshotCounter[iClient] = 0;
	g_bUsingFireStorm[iClient] = false;
	g_bUsingShadowNinja[iClient] = false;
	g_iStat_ClientInfectedKilled[iClient] = 0;
	g_iStat_ClientCommonKilled[iClient] = 0;
	g_iStat_ClientCommonHeadshots[iClient] = 0;
	g_iStat_ClientSurvivorsKilled[iClient] = 0;
	g_iStat_ClientSurvivorsIncaps[iClient] = 0;
	g_iStat_ClientDamageToSurvivors[iClient] = 0;
	g_bCanPlayHeadshotSound[iClient] = true;
	g_bUsingTongueRope[iClient]=false;
	g_iRopeCountDownTimer[iClient] = 0;
	canchangemovement[iClient]=true;
	g_bIsMovementTypeFly[iClient] = false;
	preledgehealth[iClient] = 1;
	g_bIsClientDown[iClient] = false;
	clienthanging[iClient] = false;
	g_iBillTeamHealCounter[iClient] = 0;
	g_iClientToHeal[iClient] = 1;
	g_bHunterGrappled[iClient] = false;
	g_bChargerGrappled[iClient] = false;
	g_iChargerVictim[iClient] = 0;
	g_bSmokerGrappled[iClient] = false;
	g_iNicksRamboWeaponID[iClient] = 0;
	g_bNickIsInvisible[iClient] = false;
	g_bCanDropPoopBomb[iClient] = true;
	g_bTankOnFire[iClient] = false;
	g_bShowingVGUI[iClient] = false;
	g_bExplosivesJustGiven[iClient] = false;
	g_iLaserUpgradeCounter[iClient] = 0;

	g_iInfectedCharacter[iClient] = UNKNOWN_INFECTED;
	g_bCanBeGhost[iClient] = true;
	g_bIsGhost[iClient] = false;
	g_iTankCounter = 0;
	RemoveAllEntitiesFromTankRockList();
	g_bAdhesiveGooActive[iClient] = false;
	
	g_bSomeoneAttacksFaster = false;
	
	//Bill
	gClone[iClient] = -1;
	
	//Rochelle
	g_bIsRochellePoisoned[iClient] = false;
	
	//Coach
	g_bShowingChargeHealParticle[iClient] = false;
	g_bCoachInCISpeed[iClient] = false;
	g_bCoachInSISpeed[iClient] = false;
	g_iCoachCIHeadshotCounter[iClient] = 0;
	g_iCoachSIHeadshotCounter[iClient] = 0;
	
	//Ellis
	g_bWalkAndUseToggler[iClient] = false;
	g_fEllisBringSpeed[iClient] = 0.0;
	g_fEllisOverSpeed[iClient] = 0.0;
	g_fEllisJamminSpeed[iClient] = 0.0;
	g_bEllisOverSpeedIncreased[iClient] = false;
	
	//Nick 
	g_bNickIsGettingBeatenUp[iClient] = false;
	g_iNickDesperateMeasuresStack = 0;
	
	//Infected Talents
	g_iInfectedConvarsSet[iClient] = false;
	
	//Smoker
	g_iChokingVictim[iClient] = -1;
	g_iMaxTongueLength = 0;
	g_iMaxDragSpeed = 0;
	g_bHasSmokersPoisonCloudOut[iClient] = false;
	g_bIsElectricuting[iClient] = false;
	g_bIsSmokeInfected[iClient] = false;
	g_iSmokerInfectionCloudEntity[iClient] = -1;
	g_bTeleportCoolingDown[iClient] = false;
	g_iSmokerTransparency[iClient] = 0;
	g_bElectricutionCooldown[iClient] = false;
	
	//Boomer
	g_bIsBoomerVomiting[iClient] = false;
	g_iVomitVictimAttacker[iClient] = 0;
	g_bIsServingHotMeal[iClient] = false;
	g_iVomitVictimCounter[iClient] = 0;
	g_iShowSurvivorVomitCounter[iClient] = 0;
	g_bIsSuicideBoomer[iClient] = false;
	g_bIsSuicideJumping[iClient] = false;
	g_bIsSurvivorVomiting[iClient] = false;
	g_bIsSuperSpeedBoomer[iClient] = false;

	//Hunter
	g_bIsCloakedHunter[iClient] = false;
	g_bCanHunterDismount[iClient] = true;
	g_bCanHunterPoisonVictim[iClient] = true;
	g_iHunterShreddingVictim[iClient] = -1;
	g_iHunterPounceDamageCharge[iClient] = 0;
	g_bIsHunterPoisoned[iClient] = false;
	
	//Jockey
	g_bCanJockeyPee[iClient] = true;
	g_bCanJockeyCloak[iClient] = true;
	g_bJockeyIsRiding[iClient] = false;
	g_iJockeyVictim[iClient] = -1;
	g_bCanJockeyJump[iClient] = false;
	g_fJockeyRideSpeed[iClient] = 1.0;
	g_fJockeyRideSpeedVanishingActBoost[iClient] = 0.0;
	
	//Spitter
	g_bBlockGooSwitching[iClient] = false;
	g_bJustSpawnedWitch[iClient] = false;
	g_bCanConjureWitch[iClient] = true;
	g_bHasDemiGravity[iClient] = false;
	g_bIsHallucinating[iClient] = false;
	g_iViralInfector[iClient] = 0;
	g_bIsImmuneToVirus[iClient] = false;
	g_bJustUsedAcidReflex[iClient] = false;
	g_iAcidReflexLeft[iClient] = 0;
	g_bCanBePushedByRepulsion[iClient] = true;
	g_bIsStealthSpitter[iClient] = false;
	g_iStealthSpitterChargePower[iClient] =  0;
	g_iStealthSpitterChargeMana[iClient] =  0;
	g_xyzWitchConjureLocation[iClient][0] = 0.0;
	g_xyzWitchConjureLocation[iClient][1] = 0.0;
	g_xyzWitchConjureLocation[iClient][2] = 0.0;
	g_fAdhesiveAffectAmount[iClient] = 0.0;
	
	//Charger
	g_bCanChargerSuperCharge[iClient] = true;
	g_bIsSpikedCharged[iClient] = false;
	g_bCanChargerSpikedCharge[iClient] = true;
	g_bIsChargerCharging[iClient] = false;
	g_bIsHillbillyEarthquakeReady[iClient] = false;
	g_bIsSuperCharger[iClient] = false;
	g_bChargerCarrying[iClient] = false;
	g_bIsChargerHealing[iClient] = false;
	g_bCanChargerEarthquake[iClient] = true;
	
	//Tank
	g_fFireTankExtraSpeed[iClient] = 0.0;
	//g_bFireTankBaseSpeedIncreased[iClient] = false;
	
	ResetAllVariables(iClient);
	//Delete all the global timer handles at the end of the round
	DeleteAllGlobalTimerHandles(iClient);
	
	for(new j=1;j <= MaxClients;j++)
		g_bNickIsStealingLife[iClient][j] = false;
}

ResetAllVariables(iClient)
{
	g_bHunterGrappled[iClient] = false;
	g_bChargerGrappled[iClient] = false;
	g_bSmokerGrappled[iClient] = false;
	g_bUsingFireStorm[iClient] = false;
	g_bUsingTongueRope[iClient] = false;
	clienthanging[iClient] = false;
	g_bIsJetpackOn[iClient] = false;
	g_bIsFlyingWithJetpack[iClient] = false;
	g_bIsHighJumpCharged[iClient] = false;
	g_bIsWreckingBallCharged[iClient] = false;
	g_bIsMovementTypeFly[iClient] = false;
	g_iNicksRamboWeaponID[iClient] = 0;
	g_bUsingShadowNinja[iClient] = false;
	g_bBillSprinting[iClient] = false;
	g_iBillTeamHealCounter[iClient] = 0;
	g_bIsClientDown[iClient] = false;
	pop(iClient);
	g_bDoesClientAttackFast[iClient] = false;
	
	//Reset Tank (Needed here for changing teams)
	ResetAllTankVariables(iClient);
}

DeleteAllGlobalTimerHandles(iClient)
{
	//delete g_hTimer_FreezeCountdown;
	delete g_hTimer_ShowingConfirmTalents[iClient];
	delete g_hTimer_DrugPlayer[iClient];
	delete g_hTimer_HallucinatePlayer[iClient];
	delete g_hTimer_SlapPlayer[iClient];
	delete g_hTimer_RochellePoison[iClient];
	delete g_hTimer_HunterPoison[iClient];
	delete g_hTimer_NickLifeSteal[iClient];
	delete g_hTimer_BillDropBombs[iClient];
	delete g_hTimer_AdhesiveGooReset[iClient];
	delete g_hTimer_DemiGooReset[iClient];
	delete g_hTimer_ResetGlow[iClient];
	delete g_hTimer_ViralInfectionTick[iClient];
	delete g_hTimer_BlockGooSwitching[iClient];	
	delete g_hTimer_ExtinguishTank[iClient];
	delete g_hTimer_IceSphere[iClient];
	delete g_hTimer_WingDashChargeRegenerate[iClient];
}

SetupSDKCalls()
{
	new Handle:hGameConfigFile = INVALID_HANDLE;
	hGameConfigFile = LoadGameConfigFile("xpmdata");
	if (hGameConfigFile != INVALID_HANDLE)
	{
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "CTerrorPlayer_OnVomitedUpon");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		g_hSDK_VomitOnPlayer = EndPrepSDKCall();

		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "CTerrorPlayer_OnITExpired");
		g_hSDK_UnVomitOnPlayer = EndPrepSDKCall();
		
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "RoundRespawn");
		g_hSDK_RoundRespawn = EndPrepSDKCall();
		
		////NOT USED
		// //StartPrepSDKCall(SDKCall_Player);
		// //PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "BecomeGhost");
		// //PrepSDKCall_AddParameter(SDKType_PlainOldData , SDKPass_Plain);
		// //g_hSDK_BecomeGhost = EndPrepSDKCall();
		
		////NOT USED
		// //StartPrepSDKCall(SDKCall_Player);
		// //PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "State_Transition");
		// //PrepSDKCall_AddParameter(SDKType_PlainOldData , SDKPass_Plain);
		// //g_hSDK_StateTransition = EndPrepSDKCall();
		
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "SetHumanSpec");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		g_hSDK_SetHumanSpec = EndPrepSDKCall();
		
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "TakeOverBot");
		PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
		g_hSDK_TakeOverBot = EndPrepSDKCall();
		
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "CTerrorPlayer::OnPounceEnd");
		g_hSDK_OnPounceEnd = EndPrepSDKCall();
		
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "CTerrorPlayer_Fling");
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
		g_hSDK_Fling = EndPrepSDKCall();

		//
		// StartPrepSDKCall(SDKCall_Player);
		// PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "SetClass");
		// PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		// g_hSetClass = EndPrepSDKCall();
		
		//
		StartPrepSDKCall(SDKCall_Static);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "CreateAbility");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
		g_hCreateAbility = EndPrepSDKCall();
		
		g_iOffset_NextActivation = GameConfGetOffset(hGameConfigFile, "SIAbilityNextActivation");
		
		//g_iAbility = GameConfGetOffset(hGameConfigFile, "Ability");
		
		if (g_hCreateAbility == INVALID_HANDLE)
			SetFailState("[+] S_HGD: Error: Unable to find CreateAbility signature.");
		
		CloseHandle(hGameConfigFile);
	}
	else
		SetFailState("[XPMod] Install the required gamedata file to addons/sourcemod/gamedata/xpmdata.txt");
}

SetMapsMaxTeleportHeight()
{
	//Get current map name
	decl String:strCurrentMap[32];
	GetCurrentMap(strCurrentMap,32);
	
	//Set max teleport height so they dont teleport into the sky
	if(StrEqual(strCurrentMap, "c1m1_hotel") == true)
		g_fMapsMaxTeleportHeight = 3100.0;
	else if(StrEqual(strCurrentMap, "c1m2_streets") == true)
		g_fMapsMaxTeleportHeight = 2000.0;
	else if(StrEqual(strCurrentMap, "c1m3_mall") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c1m4_atrium") == true)
		g_fMapsMaxTeleportHeight = 1100.0;
	else if(StrEqual(strCurrentMap, "c2m1_highway") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c2m2_fairgrounds") == true)
		g_fMapsMaxTeleportHeight = 750.0;
	else if(StrEqual(strCurrentMap, "c2m3_coaster") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c2m4_barns") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c2m5_concert") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c3m1_plankcountry") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c3m2_swamp") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c3m3_shantytown") == true)
		g_fMapsMaxTeleportHeight = 1020.0;
	else if(StrEqual(strCurrentMap, "c3m4_plantation") == true)
		g_fMapsMaxTeleportHeight = 1145.0;
	else if(StrEqual(strCurrentMap, "c4m1_milltown_a") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c4m2_sugarmill_a") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c4m3_sugartown_b") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c4m4_milltown_b") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c4m5_milltown_escape") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c5m1_waterfront") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c5m2_park") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c5m3_cemetery") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c5m4_quarter") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c5m5_bridge") == true)
		g_fMapsMaxTeleportHeight = 3065.0;
	else if(StrEqual(strCurrentMap, "c6m1_riverbank") == true)
		g_fMapsMaxTeleportHeight = 3075.0;
	else if(StrEqual(strCurrentMap, "c6m2_bedlam") == true)
		g_fMapsMaxTeleportHeight = 745.0;
	else if(StrEqual(strCurrentMap, "c6m3_port") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c7m1_docks") == true)
		g_fMapsMaxTeleportHeight = 1018.0;
	else if(StrEqual(strCurrentMap, "c7m2_barge") == true)
		g_fMapsMaxTeleportHeight = 1270.0;
	else if(StrEqual(strCurrentMap, "c7m3_port") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c8m1_apartment") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c8m2_subway") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c8m3_sewers") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c8m4_interior") == true)
		g_fMapsMaxTeleportHeight = 7555.0;
	else if(StrEqual(strCurrentMap, "c8m5_rooftop") == true)
		g_fMapsMaxTeleportHeight = 8080.0;
	else if(StrEqual(strCurrentMap, "c13m1_alpinecreek") == true)
		g_fMapsMaxTeleportHeight = 40000.0;
	else if(StrEqual(strCurrentMap, "c13m2_southpinestream") == true)
		g_fMapsMaxTeleportHeight = 2660.0;
	else if(StrEqual(strCurrentMap, "c13m3_memorialbridge") == true)
		g_fMapsMaxTeleportHeight = 2350.0;
	else if(StrEqual(strCurrentMap, "c13m4_cutthroatcreek") == true)
		g_fMapsMaxTeleportHeight = 1390.0;
	else
		g_fMapsMaxTeleportHeight = 9999999.0;
	
	//Set Rochelle's break from Smoker's tongue vector
	if(StrEqual(strCurrentMap, "c7m2_barge") == true)
	{
		g_xyzBreakFromSmokerVector[0] = 2140.0;
		g_xyzBreakFromSmokerVector[1] = 1412.0;
		g_xyzBreakFromSmokerVector[2] = 80.0;
	}
	else
	{
		g_xyzBreakFromSmokerVector[0] = 0.0;
		g_xyzBreakFromSmokerVector[1] = 0.0;
		g_xyzBreakFromSmokerVector[2] = 0.0;
	}
}

//Chat
Action:SayCmd(iClient, args)
{
	if (iClient < 1 || IsClientInGame(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Continue;
	
	//Check to see if they typed in xpm or xpmod, indifferent to the case used
	decl String:strArgument1[16];
	GetCmdArg(1, strArgument1, sizeof(strArgument1));
	if(StrEqual(strArgument1, "xpm", false) == true || StrEqual(strArgument1, "!xpm", false) == true ||
		StrEqual(strArgument1, "xpmod", false) == true || StrEqual(strArgument1, "!xpmod", false) == true)
		{
			XPModMenuDraw(iClient);
		}
	
	if(StrEqual(strArgument1, "/xpm", false) == true)
	{
		XPModMenuDraw(iClient);
		return Plugin_Handled;
	}
		
	
	//Change the color of the admin text in the chat to green
	if(GetUserAdmin(iClient) != INVALID_ADMIN_ID)
	{
		decl String:input[256];
		
		GetCmdArgString(input, sizeof(input));
		if(input[0] ==  '/' || input[1] ==  '/')
			return Plugin_Handled;
			
		if(input[0] ==  '"')
			input[0] = ' ';
		if(input[strlen(input) - 1] == '"')
			input[strlen(input) - 1] = '\0';
		
		PrintToChatAll("\x03%N\x01 : %s", iClient, input);
		PrintToServer("[Admin] %N : %s", iClient, input);
		return Plugin_Handled;
	}
		
	return Plugin_Continue;
}

Action:SayTeamCmd(iClient, args)
{
	if (iClient < 1 || IsClientInGame(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Continue;
	
	decl String:input[256];
	GetCmdArgString(input,sizeof(input));

	decl String:strArgument1[6];
	GetCmdArg(1, strArgument1, 6);
	if(StrEqual(strArgument1, "xpm", false) == true || StrEqual(strArgument1, "!xpm", false) == true ||
		StrEqual(strArgument1, "xpmod", false) == true || StrEqual(strArgument1, "!xpmod", false) == true)
		XPModMenuDraw(iClient);
		
	if(StrEqual(strArgument1, "/xpm", false) == true)
	{
		XPModMenuDraw(iClient);
		return Plugin_Handled;
	}
	
	decl i;
	for(i = 1; i <= MaxClients; i++)
	{
		if(g_iGatherLevel[i] == 5 && IsClientInGame(i) && IsFakeClient(i) == false && GetClientTeam(i)==TEAM_SURVIVORS && GetClientTeam(iClient)==TEAM_INFECTED)
		{
			decl String:clientname[25];
			GetClientName(iClient, clientname, sizeof(clientname));
			PrintToChat(i, "\x04[\x05IDD Survalence\x04] \x05%s\x04: \x01%s", clientname, input);
		}
	}
	
	return Plugin_Continue;
}