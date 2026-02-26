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
//          Many thanks to the developers at the Allied Modders forums! This mod would not be what it          //
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

#define PLUGIN_VERSION "0.8.5.0326"

#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <regex>
#include <basecomm>

// Added custom includes
#include <sha1>

// XPMod Include Files
#include "XPMod/Includes.sp"

public Plugin myinfo =
{
	name = "XPMod",
	author = "Chris Pringle and Ezekiel Keener",
	description = "XPMod adds RPG elements to Left4Dead2, enabling players to gain powerful abilities and equipment by earning XP.",
	version = PLUGIN_VERSION,
	url = "http://xpmod.net"
}

public void OnPluginStart()
{
	//Check for Left4Dead 2
	char strGameName[64];
	GetGameFolderName(strGameName, sizeof(strGameName));
	
	if (StrEqual(strGameName, "left4dead2", false) == false)
		SetFailState("XPMod only works in Left4Dead 2.");
	else
		CreateTimer(10.0, Timer_ShowXPModInfoToServer, _);
	
	// Set up ConVars
	SetupXPMConVars();
	// Setup the handle that will link to the MySQL Database
	SetUpTheDBConnection();
	// Setup Included Files
	SetupLoadouts();
	// Setup Hooks
	SetupXPMEvents();
	// Setup Console Commands clients can use
	SetupConsoleCommands();
	// FindGameOffsets
	SetupGameOffsets();
	// Prep the SDK Call commands
	SetupSDKCalls();
	// Set initial values for variables
	SetupInitialVariableValues();
	// Precache locked weapon models
	PrecacheLockedWeaponModels();
	// Handle any users that are already connected
	HandleAnyConnectedUsers();
	
	//Start the repeating timers
	CreateTimer(1.0, TimerCheckAndOpenCharacterSelectionMenuForAll, 0, TIMER_REPEAT);
	CreateTimer(5.0, TimerLogXPMStatsToFile, 0, TIMER_REPEAT);
	CreateTimer(1.0, Timer1SecondGlobalRepeating, 0, TIMER_REPEAT);
	CreateTimer(2.0, Timer2SecondGlobalRepeating, 0, TIMER_REPEAT);
	CreateTimer(1.0, TimerRepeatStoreAllPlayersHealth, 0, TIMER_REPEAT);
	CreateTimer(0.1, TimerIDD, 0, TIMER_REPEAT);
	CreateTimer(90.0, PrintUnsetClassesMessage, 0, TIMER_REPEAT);
	CreateTimer(60.0, PrintXPModCreateAndConfirmMessageToAll, 0, TIMER_REPEAT);
	CreateTimer(300.0, PrintXPModAdvertisementMessageToAll, 0, TIMER_REPEAT);
}
