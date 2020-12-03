
///https://developer.valvesoftware.com/wiki/List_of_L4D2_Missions_Files




//////////////////////////////////////////
// Automatic Campaign Switcher for L4D2 //
// Version 1.2.4                        //
// Compiled Dec 31, 2020                //
// Programmed by Chris Pringle          //
//////////////////////////////////////////

/*==================================================================================================

	This plugin was written in response to the server kicking everyone if the vote is not passed
	at the end of the campaign. It will automatically switch to the appropriate map at all the
	points a vote would be automatically called, by the game, to go to the lobby or play again.
	ACS also includes a voting system in which people can vote for their favorite campaign/map
	on a finale or scavenge map.  The winning campaign/map will become the next map the server
	loads.

	Supported Game Modes in Left 4 Dead 2
	
		Coop
		Realism
		Versus
		Team Versus
		Scavenge
		Team Scavenge
		Mutation 1-20
		Community 1-5

	Change Log
		v1.2.4 (Dec 31, 2020)	- Added new maps for the Last Stand Update
								- Removed hardcoded maps by making the campaign maps a config file
								- Made map comparisons case insensitive
								- Added precache of witch models to fix bug in The Passing campaign 
								  transition crash
								- Fixed several infinite loop bugs when on the last campaign
								- Removed FCVAR_PLUGIN

		v1.2.3 (Jan 8, 2012)	- Added the new L4D2 campaigns
		
		v1.2.2 (May 21, 2011)	- Added message for new vote winner when a player disconnects
								- Fixed the sound to play to all the players in the game
								- Added a max amount of coop finale map failures cvar
								- Changed the wait time for voting ad from round_start to the 
								  player_left_start_area event 
								- Added the voting sound when the vote menu pops up
		
		v1.2.1 (May 18, 2011)	- Fixed mutation 15 (Versus Survival)
		
		v1.2.0 (May 16, 2011)	- Changed some of the text to be more clear
								- Added timed notifications for the next map
								- Added a cvar for how to advertise the next map
								- Added a cvar for the next map advertisement interval
								- Added a sound to help notify players of a new vote winner
								- Added a cvar to enable/disable sound notification
								- Added a custom wait time for coop game modes
								
		v1.1.0 (May 12, 2011)	- Added a voting system
								- Added error checks if map is not found when switching
								- Added a cvar for enabling/disabling voting system
								- Added a cvar for how to advertise the voting system
								- Added a cvar for time to wait for voting advertisement
								- Added all current Mutation and Community game modes
								
		v1.0.0 (May 5, 2011)	- Initial Release

===================================================================================================*/

#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION	"v1.2.4"

//Define the number of campaigns and maps in rotation
#define NUMBER_OF_CAMPAIGNS			14		/* CHANGE TO MATCH THE TOTAL NUMBER OF CAMPAIGNS */
#define NUMBER_OF_SCAVENGE_MAPS		18		/* CHANGE TO MATCH THE TOTAL NUMBER OF SCAVENGE MAPS */

//Define the wait time after round before changing to the next map in each game mode
#define WAIT_TIME_BEFORE_SWITCH_COOP			1.0
#define WAIT_TIME_BEFORE_SWITCH_VERSUS			1.0
#define WAIT_TIME_BEFORE_SWITCH_SCAVENGE		1.0

//Define Game Modes
#define GAMEMODE_UNKNOWN	-1
#define GAMEMODE_COOP 		0
#define GAMEMODE_VERSUS 	1
#define GAMEMODE_SCAVENGE 	2
#define GAMEMODE_SURVIVAL 	3

#define DISPLAY_MODE_DISABLED	0
#define DISPLAY_MODE_HINT		1
#define DISPLAY_MODE_CHAT		2
#define DISPLAY_MODE_MENU		3

#define SOUND_NEW_VOTE_START	"ui/Beep_SynthTone01.wav"
#define SOUND_NEW_VOTE_WINNER	"ui/alert_clink.wav"


//Global Variables

new g_iGameMode;					//Integer to store the gamemode
new g_iRoundEndCounter;				//Round end event counter for versus
new g_iCoopFinaleFailureCount;		//Number of times the Survivors have lost the current finale
new g_iMaxCoopFinaleFailures = 5;	//Amount of times Survivors can fail before ACS switches in coop
new bool:g_bFinaleWon;				//Indicates whether a finale has be beaten or not

//Campaign and map strings/names
new String:g_strCampaignFirstMap[NUMBER_OF_CAMPAIGNS][32];		//Array of maps to switch to
new String:g_strCampaignLastMap[NUMBER_OF_CAMPAIGNS][32];		//Array of maps to switch from
new String:g_strCampaignName[NUMBER_OF_CAMPAIGNS][32];			//Array of names of the campaign
new String:g_strScavengeMap[NUMBER_OF_SCAVENGE_MAPS][32];		//Array of scavenge maps
new String:g_strScavengeMapName[NUMBER_OF_SCAVENGE_MAPS][32];	//Name of scaveenge maps

//Voting Variables
new bool:g_bVotingEnabled = true;							//Tells if the voting system is on
new g_iVotingAdDisplayMode = DISPLAY_MODE_HINT;				//The way to advertise the voting system
new Float:g_fVotingAdDelayTime = 1.0;						//Time to wait before showing advertising
new bool:g_bVoteWinnerSoundEnabled = true;					//Sound plays when vote winner changes
new g_iNextMapAdDisplayMode = DISPLAY_MODE_HINT;			//The way to advertise the next map
new Float:g_fNextMapAdInterval = 600.0;						//Interval for ACS next map advertisement
new bool:g_bClientShownVoteAd[MAXPLAYERS + 1];				//If the client has seen the ad already
new bool:g_bClientVoted[MAXPLAYERS + 1];					//If the client has voted on a map
new g_iClientVote[MAXPLAYERS + 1];							//The value of the clients vote
new g_iWinningMapIndex;										//Winning map/campaign's index
new g_iWinningMapVotes;										//Winning map/campaign's number of votes
new Handle:g_hMenu_Vote[MAXPLAYERS + 1]	= INVALID_HANDLE;	//Handle for each players vote menu

//Console Variables (CVars)
new Handle:g_hCVar_VotingEnabled			= INVALID_HANDLE;
new Handle:g_hCVar_VoteWinnerSoundEnabled	= INVALID_HANDLE;
new Handle:g_hCVar_VotingAdMode				= INVALID_HANDLE;
new Handle:g_hCVar_VotingAdDelayTime		= INVALID_HANDLE;
new Handle:g_hCVar_NextMapAdMode			= INVALID_HANDLE;
new Handle:g_hCVar_NextMapAdInterval		= INVALID_HANDLE;
new Handle:g_hCVar_MaxFinaleFailures		= INVALID_HANDLE;



/*======================================================================================
##################            A C S   M A P   S T R I N G S            #################
========================================================================================
###                                                                                  ###
###      ***  EDIT THESE STRINGS TO CHANGE THE MAP ROTATIONS TO YOUR LIKING  ***     ###
###                                                                                  ###
========================================================================================
###                                                                                  ###
###       Note: The order these strings are stored is important, so make             ###
###             sure these match up or it will not work properly.                    ###
###                                                                                  ###
###       Make all three of the string variables match, for example:                 ###
###                                                                                  ###
###             Format(g_strCampaignFirstMap[1], 32, "c1m1_hotel");                  ###
###             Format(g_strCampaignLastMap[1], 32, "c1m4_atrium");                  ###
###             Format(g_strCampaignName[1], 32, "Dead Center");                     ###
###                                                                                  ###
###       Notice, all of the strings corresponding with [1] in the array match.      ###
###                                                                                  ###
======================================================================================*/

SetupMapStrings()
{	
	//The following three variables are for all game modes except Scavenge.
	
	//*IMPORTANT* Before editing these change NUMBER_OF_CAMPAIGNS near the top 
	//of this plugin to match the total number of campaigns or it will not 
	//loop through all of them when the check is made to change the campaign.
	
	//First Maps of the Campaign
	Format(g_strCampaignFirstMap[0], 32, "c8m1_apartment");
	Format(g_strCampaignFirstMap[1], 32, "c9m1_alleys");
	Format(g_strCampaignFirstMap[2], 32, "c10m1_caves");
	Format(g_strCampaignFirstMap[3], 32, "c11m1_greenhouse");
	Format(g_strCampaignFirstMap[4], 32, "c12m1_hilltop");
	Format(g_strCampaignFirstMap[5], 32, "c1m1_hotel");
	Format(g_strCampaignFirstMap[6], 32, "c7m1_docks");
	Format(g_strCampaignFirstMap[7], 32, "c6m1_riverbank");
	Format(g_strCampaignFirstMap[8], 32, "c2m1_highway");
	Format(g_strCampaignFirstMap[9], 32, "c3m1_plankcountry");
	Format(g_strCampaignFirstMap[10], 32, "c4m1_milltown_a");
	Format(g_strCampaignFirstMap[11], 32, "c5m1_waterfront");
	Format(g_strCampaignFirstMap[12], 32, "c13m1_alpinecreek");
	Format(g_strCampaignFirstMap[13], 32, "c14m1_junkyard");
	
	//Last Maps of the Campaign
	Format(g_strCampaignLastMap[0], 32, "c8m5_rooftop");
	Format(g_strCampaignLastMap[1], 32, "c9m2_lots");
	Format(g_strCampaignLastMap[2], 32, "c10m5_houseboat");
	Format(g_strCampaignLastMap[3], 32, "c11m5_runway");
	Format(g_strCampaignLastMap[4], 32, "c12m5_cornfield");
	Format(g_strCampaignLastMap[5], 32, "c1m4_atrium");
	Format(g_strCampaignLastMap[6], 32, "c7m3_port");
	Format(g_strCampaignLastMap[7], 32, "c6m3_port");
	Format(g_strCampaignLastMap[8], 32, "c2m5_concert");
	Format(g_strCampaignLastMap[9], 32, "c3m4_plantation");
	Format(g_strCampaignLastMap[10], 32, "c4m5_milltown_escape");
	Format(g_strCampaignLastMap[11], 32, "c5m5_bridge");
	Format(g_strCampaignLastMap[12], 32, "c13m4_cutthroatcreek");
	Format(g_strCampaignLastMap[13], 32, "c14m2_lighthouse");
	
	//Campaign Names
	Format(g_strCampaignName[0], 32, "No Mercy");
	Format(g_strCampaignName[1], 32, "Crash Course");
	Format(g_strCampaignName[2], 32, "Death Toll");
	Format(g_strCampaignName[3], 32, "Dead Air");
	Format(g_strCampaignName[4], 32, "Blood Harvest");
	Format(g_strCampaignName[5], 32, "Dead Center");
	Format(g_strCampaignName[6], 32, "The Sacrifice");
	Format(g_strCampaignName[7], 32, "The Passing");
	Format(g_strCampaignName[8], 32, "Dark Carnival");
	Format(g_strCampaignName[9], 32, "Swamp Fever");
	Format(g_strCampaignName[10], 32, "Hard Rain");
	Format(g_strCampaignName[11], 32, "The Parish");
	Format(g_strCampaignName[12], 32, "Cold Stream");
	Format(g_strCampaignName[13], 32, "The Last Stand");
	
	
	//The following string variables are only for Scavenge
	
	//*IMPORTANT* Before editing these change NUMBER_OF_SCAVENGE_MAPS 
	//near the top of this plugin to match the total number of scavenge  
	//maps, or it will not loop through all of them when changing maps.
	
	//Scavenge Maps
	Format(g_strScavengeMap[0], 32, "c8m1_apartment");
	Format(g_strScavengeMap[1], 32, "c8m5_rooftop");
	Format(g_strScavengeMap[2], 32, "c10m3_ranchhouse");
	Format(g_strScavengeMap[3], 32, "c11m4_terminal");
	Format(g_strScavengeMap[4], 32, "c12m5_cornfield");
	Format(g_strScavengeMap[5], 32, "c1m4_atrium");
	Format(g_strScavengeMap[6], 32, "c7m1_docks");
	Format(g_strScavengeMap[7], 32, "c7m2_barge");
	Format(g_strScavengeMap[8], 32, "c6m1_riverbank");
	Format(g_strScavengeMap[9], 32, "c6m2_bedlam");
	Format(g_strScavengeMap[10], 32, "c6m3_port");
	Format(g_strScavengeMap[11], 32, "c2m1_highway");
	Format(g_strScavengeMap[12], 32, "c3m1_plankcountry");
	Format(g_strScavengeMap[13], 32, "c4m1_milltown_a");
	Format(g_strScavengeMap[14], 32, "c4m2_sugarmill_a");
	Format(g_strScavengeMap[15], 32, "c5m2_park");
	Format(g_strScavengeMap[16], 32, "c14m1_junkyard");
	Format(g_strScavengeMap[17], 32, "c14m2_lighthouse");
	
	//Scavenge Map Names
	Format(g_strScavengeMapName[0], 32, "Apartments");
	Format(g_strScavengeMapName[1], 32, "Rooftop");
	Format(g_strScavengeMapName[2], 32, "The Church");
	Format(g_strScavengeMapName[3], 32, "The Terminal");
	Format(g_strScavengeMapName[4], 32, "The Farmhouse");
	Format(g_strScavengeMapName[5], 32, "Mall Atrium");
	Format(g_strScavengeMapName[6], 32, "Brick Factory");
	Format(g_strScavengeMapName[7], 32, "Barge");
	Format(g_strScavengeMapName[8], 32, "Riverbank");
	Format(g_strScavengeMapName[9], 32, "Underground");
	Format(g_strScavengeMapName[10], 32, "Port");
	Format(g_strScavengeMapName[11], 32, "Motel");
	Format(g_strScavengeMapName[12], 32, "Plank Country");
	Format(g_strScavengeMapName[13], 32, "Milltown");
	Format(g_strScavengeMapName[14], 32, "Sugar Mill");
	Format(g_strScavengeMapName[15], 32, "Park");
	Format(g_strScavengeMapName[16], 32, "The Village");
	Format(g_strScavengeMapName[17], 32, "The Lighthouse");
}

/*======================================================================================
#####################             P L U G I N   I N F O             ####################
======================================================================================*/

public Plugin:myinfo = 
{
	name = "Automatic Campaign Switcher (ACS)",
	author = "Chris Pringle",
	description = "Automatically switches to the next campaign when the previous campaign is over",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net/showthread.php?t=156392"
}

/*======================================================================================
#################             O N   P L U G I N   S T A R T            #################
======================================================================================*/

public OnPluginStart()
{
	//Get the strings for all of the maps that are in rotation
	SetupMapStrings();
	
	//Create custom console variables
	CreateConVar("acs_version", PLUGIN_VERSION, "Version of Automatic Campaign Switcher (ACS) on this server", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	g_hCVar_VotingEnabled = CreateConVar("acs_voting_system_enabled", "1", "Enables players to vote for the next map or campaign [0 = DISABLED, 1 = ENABLED]", 0, true, 0.0, true, 1.0);
	g_hCVar_VoteWinnerSoundEnabled = CreateConVar("acs_voting_sound_enabled", "1", "Determines if a sound plays when a new map is winning the vote [0 = DISABLED, 1 = ENABLED]", 0, true, 0.0, true, 1.0);
	g_hCVar_VotingAdMode = CreateConVar("acs_voting_ad_mode", "1", "Sets how to advertise voting at the start of the map [0 = DISABLED, 1 = HINT TEXT, 2 = CHAT TEXT, 3 = OPEN VOTE MENU]\n * Note: This is only displayed once during a finale or scavenge map *", 0, true, 0.0, true, 3.0);
	g_hCVar_VotingAdDelayTime = CreateConVar("acs_voting_ad_delay_time", "1.0", "Time, in seconds, to wait after survivors leave the start area to advertise voting as defined in acs_voting_ad_mode\n * Note: If the server is up, changing this in the .cfg file takes two map changes before the change takes place *", 0, true, 0.1, false);
	g_hCVar_NextMapAdMode = CreateConVar("acs_next_map_ad_mode", "1", "Sets how the next campaign/map is advertised during a finale or scavenge map [0 = DISABLED, 1 = HINT TEXT, 2 = CHAT TEXT]", 0, true, 0.0, true, 2.0);
	g_hCVar_NextMapAdInterval = CreateConVar("acs_next_map_ad_interval", "600.0", "The time, in seconds, between advertisements for the next campaign/map on finales and scavenge maps", 0, true, 60.0, false);
	g_hCVar_MaxFinaleFailures = CreateConVar("acs_max_coop_finale_failures", "5", "The amount of times the survivors can fail a finale in Coop before it switches to the next campaign [0 = INFINITE FAILURES]", 0, true, 0.0, false);
	
	//Hook console variable changes
	HookConVarChange(g_hCVar_VotingEnabled, CVarChange_Voting);
	HookConVarChange(g_hCVar_VoteWinnerSoundEnabled, CVarChange_NewVoteWinnerSound);
	HookConVarChange(g_hCVar_VotingAdMode, CVarChange_VotingAdMode);
	HookConVarChange(g_hCVar_VotingAdDelayTime, CVarChange_VotingAdDelayTime);
	HookConVarChange(g_hCVar_NextMapAdMode, CVarChange_NewMapAdMode);
	HookConVarChange(g_hCVar_NextMapAdInterval, CVarChange_NewMapAdInterval);
	HookConVarChange(g_hCVar_MaxFinaleFailures, CVarChange_MaxFinaleFailures);
		
	//Hook the game events
	//HookEvent("round_start", Event_RoundStart);
	HookEvent("player_left_start_area", Event_PlayerLeftStartArea);
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("finale_win", Event_FinaleWin);
	HookEvent("scavenge_match_finished", Event_ScavengeMapFinished);
	HookEvent("player_disconnect", Event_PlayerDisconnect);
	
	//Register custom console commands
	RegConsoleCmd("mapvote", MapVote);
	RegConsoleCmd("mapvotes", DisplayCurrentVotes);
}

/*======================================================================================
##########           C V A R   C A L L B A C K   F U N C T I O N S           ###########
======================================================================================*/

//Callback function for the cvar for voting system
public CVarChange_Voting(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	//If the value was changed, then set it and display a message to the server and players
	if (StringToInt(strNewValue) == 1)
	{
		g_bVotingEnabled = true;
		PrintToServer("[ACS] ConVar changed: Voting System ENABLED");
		PrintToChatAll("[ACS] ConVar changed: Voting System ENABLED");
	}
	else
	{
		g_bVotingEnabled = false;
		PrintToServer("[ACS] ConVar changed: Voting System DISABLED");
		PrintToChatAll("[ACS] ConVar changed: Voting System DISABLED");
	}
}

//Callback function for enabling or disabling the new vote winner sound
public CVarChange_NewVoteWinnerSound(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	//If the value was changed, then set it and display a message to the server and players
	if (StringToInt(strNewValue) == 1)
	{
		g_bVoteWinnerSoundEnabled = true;
		PrintToServer("[ACS] ConVar changed: New vote winner sound ENABLED");
		PrintToChatAll("[ACS] ConVar changed: New vote winner sound ENABLED");
	}
	else
	{
		g_bVoteWinnerSoundEnabled = false;
		PrintToServer("[ACS] ConVar changed: New vote winner sound DISABLED");
		PrintToChatAll("[ACS] ConVar changed: New vote winner sound DISABLED");
	}
}

//Callback function for how the voting system is advertised to the players at the beginning of the round
public CVarChange_VotingAdMode(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	//If the value was changed, then set it and display a message to the server and players
	switch(StringToInt(strNewValue))
	{
		case 0:
		{
			g_iVotingAdDisplayMode = DISPLAY_MODE_DISABLED;
			PrintToServer("[ACS] ConVar changed: Voting display mode: DISABLED");
			PrintToChatAll("[ACS] ConVar changed: Voting display mode: DISABLED");
		}
		case 1:
		{
			g_iVotingAdDisplayMode = DISPLAY_MODE_HINT;
			PrintToServer("[ACS] ConVar changed: Voting display mode: HINT TEXT");
			PrintToChatAll("[ACS] ConVar changed: Voting display mode: HINT TEXT");
		}
		case 2:
		{
			g_iVotingAdDisplayMode = DISPLAY_MODE_CHAT;
			PrintToServer("[ACS] ConVar changed: Voting display mode: CHAT TEXT");
			PrintToChatAll("[ACS] ConVar changed: Voting display mode: CHAT TEXT");
		}
		case 3:
		{
			g_iVotingAdDisplayMode = DISPLAY_MODE_MENU;
			PrintToServer("[ACS] ConVar changed: Voting display mode: OPEN VOTE MENU");
			PrintToChatAll("[ACS] ConVar changed: Voting display mode: OPEN VOTE MENU");
		}
	}
}

//Callback function for the cvar for voting display delay time
public CVarChange_VotingAdDelayTime(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	//Get the new value
	new Float:fDelayTime = StringToFloat(strNewValue);
	
	//If the value was changed, then set it and display a message to the server and players
	if (fDelayTime > 0.1)
	{
		g_fVotingAdDelayTime = fDelayTime;
		PrintToServer("[ACS] ConVar changed: Voting advertisement delay time changed to %f", fDelayTime);
		PrintToChatAll("[ACS] ConVar changed: Voting advertisement delay time changed to %f", fDelayTime);
	}
	else
	{
		g_fVotingAdDelayTime = 0.1;
		PrintToServer("[ACS] ConVar changed: Voting advertisement delay time changed to 0.1");
		PrintToChatAll("[ACS] ConVar changed: Voting advertisement delay time changed to 0.1");
	}
}

//Callback function for how ACS and the next map is advertised to the players during a finale
public CVarChange_NewMapAdMode(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	//If the value was changed, then set it and display a message to the server and players
	switch(StringToInt(strNewValue))
	{
		case 0:
		{
			g_iNextMapAdDisplayMode = DISPLAY_MODE_DISABLED;
			PrintToServer("[ACS] ConVar changed: Next map advertisement display mode: DISABLED");
			PrintToChatAll("[ACS] ConVar changed: Next map advertisement display mode: DISABLED");
		}
		case 1:
		{
			g_iNextMapAdDisplayMode = DISPLAY_MODE_HINT;
			PrintToServer("[ACS] ConVar changed: Next map advertisement display mode: HINT TEXT");
			PrintToChatAll("[ACS] ConVar changed: Next map advertisement display mode: HINT TEXT");
		}
		case 2:
		{
			g_iNextMapAdDisplayMode = DISPLAY_MODE_CHAT;
			PrintToServer("[ACS] ConVar changed: Next map advertisement display mode: CHAT TEXT");
			PrintToChatAll("[ACS] ConVar changed: Next map advertisement display mode: CHAT TEXT");
		}
	}
}

//Callback function for the interval that controls the timer that advertises ACS and the next map
public CVarChange_NewMapAdInterval(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	//Get the new value
	new Float:fDelayTime = StringToFloat(strNewValue);
	
	//If the value was changed, then set it and display a message to the server and players
	if (fDelayTime > 60.0)
	{
		g_fNextMapAdInterval = fDelayTime;
		PrintToServer("[ACS] ConVar changed: Next map advertisement interval changed to %f", fDelayTime);
		PrintToChatAll("[ACS] ConVar changed: Next map advertisement interval changed to %f", fDelayTime);
	}
	else
	{
		g_fNextMapAdInterval = 60.0;
		PrintToServer("[ACS] ConVar changed: Next map advertisement interval changed to 60.0");
		PrintToChatAll("[ACS] ConVar changed: Next map advertisement interval changed to 60.0");
	}
}

//Callback function for the amount of times the survivors can fail a coop finale map before ACS switches
public CVarChange_MaxFinaleFailures(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	//Get the new value
	new iMaxFailures = StringToInt(strNewValue);
	
	//If the value was changed, then set it and display a message to the server and players
	if (iMaxFailures > 0)
	{
		g_iMaxCoopFinaleFailures = iMaxFailures;
		PrintToServer("[ACS] ConVar changed: Max Coop finale failures changed to %f", iMaxFailures);
		PrintToChatAll("[ACS] ConVar changed: Max Coop finale failures changed to %f", iMaxFailures);
	}
	else
	{
		g_iMaxCoopFinaleFailures = 0;
		PrintToServer("[ACS] ConVar changed: Max Coop finale failures changed to 0");
		PrintToChatAll("[ACS] ConVar changed: Max Coop finale failures changed to 0");
	}
}
/*======================================================================================
#################                     E V E N T S                      #################
======================================================================================*/

public OnMapStart()
{
	//Execute config file
	decl String:strFileName[64];
	Format(strFileName, sizeof(strFileName), "Automatic_Campaign_Switcher_%s", PLUGIN_VERSION);
	AutoExecConfig(true, strFileName);
	
	//Set all the menu handles to invalid
	CleanUpMenuHandles();
	
	//Set the game mode
	FindGameMode();
	
	//Precache models (This fixes missing Witch model on "The Passing")
	if(IsModelPrecached("models/infected/witch.mdl") == false)
		PrecacheModel("models/infected/witch.mdl");
	if(IsModelPrecached("models/infected/witch_bride.mdl") == false)
		PrecacheModel("models/infected/witch_bride.mdl");

	//Precache sounds
	PrecacheSound(SOUND_NEW_VOTE_START);
	PrecacheSound(SOUND_NEW_VOTE_WINNER);
	
	
	//Display advertising for the next campaign or map
	if(g_iNextMapAdDisplayMode != DISPLAY_MODE_DISABLED)
	{
		CreateTimer(g_fNextMapAdInterval, Timer_AdvertiseNextMap, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
	
	g_iRoundEndCounter = 0;			//Reset the round end counter on every map start
	g_iCoopFinaleFailureCount = 0;	//Reset the amount of Survivor failures
	g_bFinaleWon = false;			//Reset the finale won variable
	ResetAllVotes();				//Reset every player's vote
}

//Event fired when the Survivors leave the start area
public Action:Event_PlayerLeftStartArea(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{		
	if(g_bVotingEnabled == true && OnFinaleOrScavengeMap() == true)
		CreateTimer(g_fVotingAdDelayTime, Timer_DisplayVoteAdToAll, _, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Continue;
}

//Event fired when the Round Ends
public Action:Event_RoundEnd(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//Check to see if on a finale map, if so change to the next campaign after two rounds
	if(g_iGameMode == GAMEMODE_VERSUS && OnFinaleOrScavengeMap() == true)
	{
		g_iRoundEndCounter++;
		
		if(g_iRoundEndCounter >= 4)	//This event must be fired on the fourth time Round End occurs.
			CheckMapForChange();	//This is because it fires twice during each round end for
									//some strange reason, and versus has two rounds in it.
	}
	//If in Coop and on a finale, check to see if the surviors have lost the max amount of times
	else if(g_iGameMode == GAMEMODE_COOP && OnFinaleOrScavengeMap() == true &&
			g_iMaxCoopFinaleFailures > 0 && g_bFinaleWon == false &&
			++g_iCoopFinaleFailureCount >= g_iMaxCoopFinaleFailures)
	{
		CheckMapForChange();
	}
	
	return Plugin_Continue;
}

//Event fired when a finale is won
public Action:Event_FinaleWin(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	g_bFinaleWon = true;	//This is used so that the finale does not switch twice if this event
							//happens to land on a max failure count as well as this
	
	//Change to the next campaign
	if(g_iGameMode == GAMEMODE_COOP)
		CheckMapForChange();
	
	return Plugin_Continue;
}

//Event fired when a map is finished for scavenge
public Action:Event_ScavengeMapFinished(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	//Change to the next Scavenge map
	if(g_iGameMode == GAMEMODE_SCAVENGE)
		ChangeScavengeMap();
	
	return Plugin_Continue;
}

//Event fired when a player disconnects from the server
public Action:Event_PlayerDisconnect(Handle:hEvent, const String:strName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	
	if(iClient	< 1)
		return Plugin_Continue;
	
	//Reset the client's votes
	g_bClientVoted[iClient] = false;
	g_iClientVote[iClient] = -1;
	
	//Check to see if there is a new vote winner
	SetTheCurrentVoteWinner();
	
	return Plugin_Continue;
}

/*======================================================================================
#################              F I N D   G A M E   M O D E             #################
======================================================================================*/

//Find the current gamemode and store it into this plugin
FindGameMode()
{
	//Get the gamemode string from the game
	decl String:strGameMode[20];
	GetConVarString(FindConVar("mp_gamemode"), strGameMode, sizeof(strGameMode));
	
	//Set the global gamemode int for this plugin
	if(StrEqual(strGameMode, "coop"))
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "realism"))
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode,"versus"))
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "teamversus"))
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "scavenge"))
		g_iGameMode = GAMEMODE_SCAVENGE;
	else if(StrEqual(strGameMode, "teamscavenge"))
		g_iGameMode = GAMEMODE_SCAVENGE;
	else if(StrEqual(strGameMode, "survival"))
		g_iGameMode = GAMEMODE_SURVIVAL;
	else if(StrEqual(strGameMode, "mutation1"))		//Last Man On Earth
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation2"))		//Headshot!
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation3"))		//Bleed Out
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation4"))		//Hard Eight
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation5"))		//Four Swordsmen
		g_iGameMode = GAMEMODE_COOP;
	//else if(StrEqual(strGameMode, "mutation6"))	//Nothing here
	//	g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation7"))		//Chainsaw Massacre
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation8"))		//Ironman
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation9"))		//Last Gnome On Earth
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation10"))	//Room For One
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation11"))	//Healthpackalypse!
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "mutation12"))	//Realism Versus
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "mutation13"))	//Follow the Liter
		g_iGameMode = GAMEMODE_SCAVENGE;
	else if(StrEqual(strGameMode, "mutation14"))	//Gib Fest
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation15"))	//Versus Survival
		g_iGameMode = GAMEMODE_SURVIVAL;
	else if(StrEqual(strGameMode, "mutation16"))	//Hunting Party
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation17"))	//Lone Gunman
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "mutation18"))	//Bleed Out Versus
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "mutation19"))	//Taaannnkk!
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "mutation20"))	//Healing Gnome
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "community1"))	//Special Delivery
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "community2"))	//Flu Season
		g_iGameMode = GAMEMODE_COOP;
	else if(StrEqual(strGameMode, "community3"))	//Riding My Survivor
		g_iGameMode = GAMEMODE_VERSUS;
	else if(StrEqual(strGameMode, "community4"))	//Nightmare
		g_iGameMode = GAMEMODE_SURVIVAL;
	else if(StrEqual(strGameMode, "community5"))	//Death's Door
		g_iGameMode = GAMEMODE_COOP;
	else
		g_iGameMode = GAMEMODE_UNKNOWN;
}

/*======================================================================================
#################             A C S   C H A N G E   M A P              #################
======================================================================================*/

//Check to see if the current map is a finale, and if so, switch to the next campaign
CheckMapForChange()
{
	decl String:strCurrentMap[32];
	GetCurrentMap(strCurrentMap,32);					//Get the current map from the game
	
	for(new iMapIndex = 0; iMapIndex < NUMBER_OF_CAMPAIGNS; iMapIndex++)
	{
		if(StrEqual(strCurrentMap, g_strCampaignLastMap[iMapIndex], false) == true)
		{
			//Check to see if someone voted for a campaign, if so, then change to the winning campaign
			if(g_bVotingEnabled == true && g_iWinningMapVotes > 0 && g_iWinningMapIndex >= 0)
			{
				if(IsMapValid(g_strCampaignFirstMap[g_iWinningMapIndex]) == true)
				{
					PrintToChatAll("\x03[ACS] \x05Switching campaign to the vote winner: \x04%s", g_strCampaignName[g_iWinningMapIndex]);
					
					if(g_iGameMode == GAMEMODE_VERSUS)
						CreateTimer(WAIT_TIME_BEFORE_SWITCH_VERSUS, Timer_ChangeCampaign, g_iWinningMapIndex);
					else if(g_iGameMode == GAMEMODE_COOP)
						CreateTimer(WAIT_TIME_BEFORE_SWITCH_COOP, Timer_ChangeCampaign, g_iWinningMapIndex);
					
					return;
				}
				else
					LogError("Error: %s is an invalid map name, attempting normal map rotation.", g_strCampaignFirstMap[g_iWinningMapIndex]);
			}
			
			//If no map was chosen in the vote, then go with the automatic map rotation
			new iNextCampaignMapIndex = iMapIndex + 1;	// Get the next campaign map index
			if(iMapIndex == NUMBER_OF_CAMPAIGNS - 1)	// Check to see if its the end of the array
				iNextCampaignMapIndex = 0;				// If so, set it to the first map index
				
			if(IsMapValid(g_strCampaignFirstMap[iNextCampaignMapIndex]) == true)
			{
				PrintToChatAll("\x03[ACS] \x05Switching campaign to \x04%s", g_strCampaignName[iNextCampaignMapIndex]);
				
				if(g_iGameMode == GAMEMODE_VERSUS)
					CreateTimer(WAIT_TIME_BEFORE_SWITCH_VERSUS, Timer_ChangeCampaign, iNextCampaignMapIndex);
				else if(g_iGameMode == GAMEMODE_COOP)
					CreateTimer(WAIT_TIME_BEFORE_SWITCH_COOP, Timer_ChangeCampaign, iNextCampaignMapIndex);
			}
			else
				LogError("Error: %s is an invalid map name, unable to switch map.", g_strCampaignFirstMap[iNextCampaignMapIndex]);
			
			return;
		}
	}
}

//Change to the next scavenge map
ChangeScavengeMap()
{
	//Check to see if someone voted for a map, if so, then change to the winning map
	if(g_bVotingEnabled == true && g_iWinningMapVotes > 0 && g_iWinningMapIndex >= 0)
	{
		if(IsMapValid(g_strScavengeMap[g_iWinningMapIndex]) == true)
		{
			PrintToChatAll("\x03[ACS] \x05Switching map to the vote winner: \x04%s", g_strScavengeMapName[g_iWinningMapIndex]);
			
			CreateTimer(WAIT_TIME_BEFORE_SWITCH_SCAVENGE, Timer_ChangeScavengeMap, g_iWinningMapIndex);
			
			return;
		}
		else
			LogError("Error: %s is an invalid map name, attempting normal map rotation.", g_strScavengeMap[g_iWinningMapIndex]);
	}
	
	//If no map was chosen in the vote, then go with the automatic map rotation
	
	decl String:strCurrentMap[32];
	GetCurrentMap(strCurrentMap, 32);					//Get the current map from the game
	
	//Go through all maps and to find which map index it is on, and then switch to the next map
	for(new iMapIndex = 0; iMapIndex < NUMBER_OF_SCAVENGE_MAPS; iMapIndex++)
	{
		if(StrEqual(strCurrentMap, g_strScavengeMap[iMapIndex]) == true)
		{
			new iNextCampaignMapIndex = iMapIndex + 1;		// Get the next campaign map index
			if(iMapIndex == NUMBER_OF_SCAVENGE_MAPS - 1)	// Check to see if its the end of the array
				iNextCampaignMapIndex = 0;					// If so, set it to the first map index
			
			//Make sure the map is valid before changing and displaying the message
			if(IsMapValid(g_strScavengeMap[iNextCampaignMapIndex]) == true)
			{
				PrintToChatAll("\x03[ACS] \x05Switching map to \x04%s", g_strScavengeMapName[iNextCampaignMapIndex]);
				
				CreateTimer(WAIT_TIME_BEFORE_SWITCH_SCAVENGE, Timer_ChangeScavengeMap, iNextCampaignMapIndex);
			}
			else
				LogError("Error: %s is an invalid map name, unable to switch map.", g_strScavengeMap[iNextCampaignMapIndex]);
			
			return;
		}
	}
}

//Change campaign to its index
public Action:Timer_ChangeCampaign(Handle:timer, any:iCampaignIndex)
{
	ServerCommand("changelevel %s", g_strCampaignFirstMap[iCampaignIndex]);	//Change the campaign
	
	return Plugin_Stop;
}

//Change scavenge map to its index
public Action:Timer_ChangeScavengeMap(Handle:timer, any:iMapIndex)
{
	ServerCommand("changelevel %s", g_strScavengeMap[iMapIndex]);			//Change the map
	
	return Plugin_Stop;
}

/*======================================================================================
#################            A C S   A D V E R T I S I N G             #################
======================================================================================*/

public Action:Timer_AdvertiseNextMap(Handle:timer)
{
	if(g_iNextMapAdDisplayMode == DISPLAY_MODE_DISABLED)
		return Plugin_Stop;
	
	//Display the ACS next map advertisement to everyone
	DisplayNextMapToAll();

	return Plugin_Continue;
}

DisplayNextMapToAll()
{
	//If there is a winner to the vote display the winner if not display the next map in rotation
	if(g_iWinningMapIndex >= 0)
	{
		if(g_iNextMapAdDisplayMode == DISPLAY_MODE_HINT)
		{
			//Display the map that is currently winning the vote to all the players using hint text
			if(g_iGameMode == GAMEMODE_SCAVENGE)
				PrintHintTextToAll("The next map is currently %s", g_strScavengeMapName[g_iWinningMapIndex]);
			else
				PrintHintTextToAll("The next campaign is currently %s", g_strCampaignName[g_iWinningMapIndex]);
		}
		else if(g_iNextMapAdDisplayMode == DISPLAY_MODE_CHAT)
		{
			//Display the map that is currently winning the vote to all the players using chat text
			if(g_iGameMode == GAMEMODE_SCAVENGE)
				PrintToChatAll("\x03[ACS] \x05The next map is currently \x04%s", g_strScavengeMapName[g_iWinningMapIndex]);
			else
				PrintToChatAll("\x03[ACS] \x05The next campaign is currently \x04%s", g_strCampaignName[g_iWinningMapIndex]);
		}
	}
	else
	{
		decl String:strCurrentMap[32];
		GetCurrentMap(strCurrentMap, 32);					//Get the current map from the game
		
		if(g_iGameMode == GAMEMODE_SCAVENGE)
		{
			//Go through all maps and to find which map index it is on, and then switch to the next map
			for(new iMapIndex = 0; iMapIndex < NUMBER_OF_SCAVENGE_MAPS; iMapIndex++)
			{
				if(StrEqual(strCurrentMap, g_strScavengeMap[iMapIndex]) == true)
				{
					new iNextCampaignMapIndex = iMapIndex + 1;		// Set to the next upcoming map index item
					if(iMapIndex == NUMBER_OF_SCAVENGE_MAPS - 1)	// Check to see if its the end of the array
						iNextCampaignMapIndex = 0;					// If so, then set the map index to the first one
					
					//Display the next map in the rotation in the appropriate way
					if(g_iNextMapAdDisplayMode == DISPLAY_MODE_HINT)
						PrintHintTextToAll("The next map is currently %s", g_strScavengeMapName[iNextCampaignMapIndex]);
					else if(g_iNextMapAdDisplayMode == DISPLAY_MODE_CHAT)
						PrintToChatAll("\x03[ACS] \x05The next map is currently \x04%s", g_strScavengeMapName[iNextCampaignMapIndex]);
				}
			}
		}
		else
		{
			//Go through all maps and to find which map index it is on, and then switch to the next map
			for(new iMapIndex = 0; iMapIndex < NUMBER_OF_CAMPAIGNS; iMapIndex++)
			{
				if(StrEqual(strCurrentMap, g_strCampaignLastMap[iMapIndex], false) == true)
				{
					new iNextCampaignMapIndex = iMapIndex + 1;	// Set to the next upcoming map index item
					if(iMapIndex == NUMBER_OF_CAMPAIGNS - 1)	// Check to see if its the end of the array
						iNextCampaignMapIndex = 0;				// If so, then set the map index to the first one
					
					//Display the next map in the rotation in the appropriate way
					if(g_iNextMapAdDisplayMode == DISPLAY_MODE_HINT)
						PrintHintTextToAll("The next campaign is currently %s", g_strCampaignName[iNextCampaignMapIndex]);
					else if(g_iNextMapAdDisplayMode == DISPLAY_MODE_CHAT)
						PrintToChatAll("\x03[ACS] \x05The next campaign is currently \x04%s", g_strCampaignName[iNextCampaignMapIndex]);
				}
			}
		}
	}
}

/*======================================================================================
#################              V O T I N G   S Y S T E M               #################
======================================================================================*/

/*======================================================================================
################             P L A Y E R   C O M M A N D S              ################
======================================================================================*/

//Command that a player can use to vote/revote for a map/campaign
public Action:MapVote(iClient, args)
{
	if(g_bVotingEnabled == false)
	{
		PrintToChat(iClient, "\x03[ACS] \x05Voting has been disabled on this server.");
		return;
	}
	
	if(OnFinaleOrScavengeMap() == false)
	{
		PrintToChat(iClient, "\x03[ACS] \x05Voting is only enabled on a Scavenge or finale map.");
		return;
	}
	
	//Open the vote menu for the client if they arent using the server console
	if(iClient < 1)
		PrintToServer("You cannot vote for a map from the server console, use the in-game chat");
	else
		VoteMenuDraw(iClient);
}

//Command that a player can use to see the total votes for all maps/campaigns
public Action:DisplayCurrentVotes(iClient, args)
{
	if(g_bVotingEnabled == false)
	{
		PrintToChat(iClient, "\x03[ACS] \x05Voting has been disabled on this server.");
		return;
	}
	
	if(OnFinaleOrScavengeMap() == false)
	{
		PrintToChat(iClient, "\x03[ACS] \x05Voting is only enabled on a Scavenge or finale map.");
		return;
	}
	
	decl iPlayer, iMap, iNumberOfMaps;
	
	//Get the total number of maps for the current game mode
	if(g_iGameMode == GAMEMODE_SCAVENGE)
		iNumberOfMaps = NUMBER_OF_SCAVENGE_MAPS;
	else
		iNumberOfMaps = NUMBER_OF_CAMPAIGNS;
		
	//Display to the client the current winning map
	if(g_iWinningMapIndex != -1)
	{
		if(g_iGameMode == GAMEMODE_SCAVENGE)
			PrintToChat(iClient, "\x03[ACS] \x05Currently winning the vote: \x04%s", g_strScavengeMapName[g_iWinningMapIndex]);
		else
			PrintToChat(iClient, "\x03[ACS] \x05Currently winning the vote: \x04%s", g_strCampaignName[g_iWinningMapIndex]);
	}
	else
		PrintToChat(iClient, "\x03[ACS] \x05No one has voted yet.");
	
	//Loop through all maps and display the ones that have votes
	new iMapVotes[iNumberOfMaps];
	
	for(iMap = 0; iMap < iNumberOfMaps; iMap++)
	{
		iMapVotes[iMap] = 0;
		
		//Tally votes for the current map
		for(iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
			if(g_iClientVote[iPlayer] == iMap)
				iMapVotes[iMap]++;
		
		//Display this particular map and its amount of votes it has to the client
		if(iMapVotes[iMap] > 0)
		{
			if(g_iGameMode == GAMEMODE_SCAVENGE)
				PrintToChat(iClient, "\x04          %s: \x05%d votes", g_strScavengeMapName[iMap], iMapVotes[iMap]);
			else
				PrintToChat(iClient, "\x04          %s: \x05%d votes", g_strCampaignName[iMap], iMapVotes[iMap]);
		}
	}
}

/*======================================================================================
###############                   V O T E   M E N U                       ##############
======================================================================================*/

//Timer to show the menu to the players if they have not voted yet
public Action:Timer_DisplayVoteAdToAll(Handle:hTimer, any:iData)
{
	if(g_bVotingEnabled == false || OnFinaleOrScavengeMap() == false)
		return Plugin_Stop;
	
	for(new iClient = 1;iClient <= MaxClients; iClient++)
	{
		if(g_bClientShownVoteAd[iClient] == false && g_bClientVoted[iClient] == false && IsClientInGame(iClient) == true && IsFakeClient(iClient) == false)
		{
			switch(g_iVotingAdDisplayMode)
			{
				case DISPLAY_MODE_MENU: VoteMenuDraw(iClient);
				case DISPLAY_MODE_HINT: PrintHintText(iClient, "To vote for the next map, type: !mapvote\nTo see all the votes, type: !mapvotes");
				case DISPLAY_MODE_CHAT: PrintToChat(iClient, "\x03[ACS] \x05To vote for the next map, type: \x04!mapvote\n           \x05To see all the votes, type: \x04!mapvotes");
			}
			
			g_bClientShownVoteAd[iClient] = true;
		}
	}
	
	return Plugin_Stop;
}

//Draw the menu for voting
public Action:VoteMenuDraw(iClient)
{
	if(iClient < 1 || IsClientInGame(iClient) == false || IsFakeClient(iClient) == true)
		return Plugin_Handled;
	
	//Create the menu
	g_hMenu_Vote[iClient] = CreateMenu(VoteMenuHandler);
	
	//Give the player the option of not choosing a map
	AddMenuItem(g_hMenu_Vote[iClient], "option1", "I Don't Care");
	
	//Populate the menu with the maps in rotation for the corresponding game mode
	if(g_iGameMode == GAMEMODE_SCAVENGE)
	{
		SetMenuTitle(g_hMenu_Vote[iClient], "Vote for the next map\n ");

		for(new iCampaign = 0; iCampaign < NUMBER_OF_SCAVENGE_MAPS; iCampaign++)
			AddMenuItem(g_hMenu_Vote[iClient], g_strScavengeMapName[iCampaign], g_strScavengeMapName[iCampaign]);
	}
	else
	{
		SetMenuTitle(g_hMenu_Vote[iClient], "Vote for the next campaign\n ");

		for(new iCampaign = 0; iCampaign < NUMBER_OF_CAMPAIGNS; iCampaign++)
			AddMenuItem(g_hMenu_Vote[iClient], g_strCampaignName[iCampaign], g_strCampaignName[iCampaign]);
	}
	
	//Add an exit button
	SetMenuExitButton(g_hMenu_Vote[iClient], true);
	
	//And finally, show the menu to the client
	DisplayMenu(g_hMenu_Vote[iClient], iClient, MENU_TIME_FOREVER);
	
	//Play a sound to indicate that the user can vote on a map
	EmitSoundToClient(iClient, SOUND_NEW_VOTE_START);
	
	return Plugin_Handled;
}

//Handle the menu selection the client chose for voting
public VoteMenuHandler(Handle:hMenu, MenuAction:maAction, iClient, iItemNum)
{
	if(maAction == MenuAction_Select) 
	{
		g_bClientVoted[iClient] = true;
		
		//Set the players current vote
		if(iItemNum == 0)
			g_iClientVote[iClient] = -1;
		else
			g_iClientVote[iClient] = iItemNum - 1;
			
		//Check to see if theres a new winner to the vote
		SetTheCurrentVoteWinner();
		
		//Display the appropriate message to the voter
		if(iItemNum == 0)
			PrintHintText(iClient, "You did not vote.\nTo vote, type: !mapvote");
		else if(g_iGameMode == GAMEMODE_SCAVENGE)
			PrintHintText(iClient, "You voted for %s.\n- To change your vote, type: !mapvote\n- To see all the votes, type: !mapvotes", g_strScavengeMapName[iItemNum - 1]);
		else
			PrintHintText(iClient, "You voted for %s.\n- To change your vote, type: !mapvote\n- To see all the votes, type: !mapvotes", g_strCampaignName[iItemNum - 1]);
	}
}

//Resets all the menu handles to invalid for every player, until they need it again
CleanUpMenuHandles()
{
	for(new iClient = 0; iClient <= MAXPLAYERS; iClient++)
	{
		if(g_hMenu_Vote[iClient] != INVALID_HANDLE)
		{
			CloseHandle(g_hMenu_Vote[iClient]);
			g_hMenu_Vote[iClient] = INVALID_HANDLE;
		}
	}
}

/*======================================================================================
#########       M I S C E L L A N E O U S   V O T E   F U N C T I O N S        #########
======================================================================================*/

//Resets all the votes for every player
ResetAllVotes()
{
	for(new iClient = 1; iClient <= MaxClients; iClient++)
	{
		g_bClientVoted[iClient] = false;
		g_iClientVote[iClient] = -1;
		
		//Reset so that the player can see the advertisement
		g_bClientShownVoteAd[iClient] = false;
	}
	
	//Reset the winning map to NULL
	g_iWinningMapIndex = -1;
	g_iWinningMapVotes = 0;
}

//Tally up all the votes and set the current winner
SetTheCurrentVoteWinner()
{
	decl iPlayer, iMap, iNumberOfMaps;
	
	//Store the current winnder to see if there is a change
	new iOldWinningMapIndex = g_iWinningMapIndex;
	
	//Get the total number of maps for the current game mode
	if(g_iGameMode == GAMEMODE_SCAVENGE)
		iNumberOfMaps = NUMBER_OF_SCAVENGE_MAPS;
	else
		iNumberOfMaps = NUMBER_OF_CAMPAIGNS;
	
	//Loop through all maps and get the highest voted map	
	new iMapVotes[iNumberOfMaps], iCurrentlyWinningMapVoteCounts = 0, bool:bSomeoneHasVoted = false;
	
	for(iMap = 0; iMap < iNumberOfMaps; iMap++)
	{
		iMapVotes[iMap] = 0;
		
		//Tally votes for the current map
		for(iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
			if(g_iClientVote[iPlayer] == iMap)
				iMapVotes[iMap]++;
		
		//Check if there is at least one vote, if so set the bSomeoneHasVoted to true
		if(bSomeoneHasVoted == false && iMapVotes[iMap] > 0)
			bSomeoneHasVoted = true;
		
		//Check if the current map has more votes than the currently highest voted map
		if(iMapVotes[iMap] > iCurrentlyWinningMapVoteCounts)
		{
			iCurrentlyWinningMapVoteCounts = iMapVotes[iMap];
			
			g_iWinningMapIndex = iMap;
			g_iWinningMapVotes = iMapVotes[iMap];
		}
	}
	
	//If no one has voted, reset the winning map index and votes
	//This is only for if someone votes then their vote is removed
	if(bSomeoneHasVoted == false)
	{
		g_iWinningMapIndex = -1;
		g_iWinningMapVotes = 0;
	}
	
	//If the vote winner has changed then display the new winner to all the players
	if(g_iWinningMapIndex > -1 && iOldWinningMapIndex != g_iWinningMapIndex)
	{
		//Send sound notification to all players
		if(g_bVoteWinnerSoundEnabled == true)
			for(iPlayer = 1; iPlayer <= MaxClients; iPlayer++)
				if(IsClientInGame(iPlayer) == true && IsFakeClient(iPlayer) == false)
					EmitSoundToClient(iPlayer, SOUND_NEW_VOTE_WINNER);
		
		//Show message to all the players of the new vote winner
		if(g_iGameMode == GAMEMODE_SCAVENGE)
			PrintToChatAll("\x03[ACS] \x04%s \x05is now winning the vote.", g_strScavengeMapName[g_iWinningMapIndex]);
		else
			PrintToChatAll("\x03[ACS] \x04%s \x05is now winning the vote.", g_strCampaignName[g_iWinningMapIndex]);
	}
}

//Check if the current map is the last in the campaign if not in the Scavenge game mode
bool:OnFinaleOrScavengeMap()
{
	if(g_iGameMode == GAMEMODE_SCAVENGE)
		return true;
	
	if(g_iGameMode == GAMEMODE_SURVIVAL)
		return false;
	
	decl String:strCurrentMap[32];
	GetCurrentMap(strCurrentMap,32);			//Get the current map from the game
	
	//Run through all the maps, if the current map is a last campaign map, return true
	for(new iMapIndex = 0; iMapIndex < NUMBER_OF_CAMPAIGNS; iMapIndex++)
		if(StrEqual(strCurrentMap, g_strCampaignLastMap[iMapIndex], false) == true)
			return true;
	
	return false;
}