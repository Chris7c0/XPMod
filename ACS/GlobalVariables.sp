//Define the number of campaigns and maps in rotation
#define NUMBER_OF_CAMPAIGNS			14		/* CHANGE TO MATCH THE TOTAL NUMBER OF CAMPAIGNS */
#define NUMBER_OF_SCAVENGE_MAPS		18		/* CHANGE TO MATCH THE TOTAL NUMBER OF SCAVENGE MAPS */
#define NUMBER_OF_SURVIVAL_MAPS		18		/* CHANGE TO MATCH THE TOTAL NUMBER OF SCAVENGE MAPS */


//Define Game Modes
#define GAMEMODE_UNKNOWN	        -1
#define GAMEMODE_COOP 		        0
#define GAMEMODE_VERSUS 	        1
#define GAMEMODE_SCAVENGE 	        2
#define GAMEMODE_SURVIVAL 	        3
#define GAMEMODE_VERSUS_SURVIVAL 	4

#define DISPLAY_MODE_DISABLED	0
#define DISPLAY_MODE_HINT		1
#define DISPLAY_MODE_CHAT		2
#define DISPLAY_MODE_MENU		3

// Define the wait time after round before changing to the next map in each game mode
// These must line up the game modes array
float g_fWaitTimeBeforeSwitch[] = {
    10.0,   // Coop
    5.0,    // Versus
    10.0,   // Scavenge
    10.0,   // Survival
    10.0    // Versus Survival
};

// Miscellaneous config
#define REALLOW_ACS_MAP_CHANGE_DELAY        20.0    //Seconds, used to prevent multiple triggers for 1 round end
#define REALLOW_ROUND_END_INCREMENT_DELAY   20.0    //Seconds, used to prevent multiple triggers for 1 round end

#define SOUND_NEW_VOTE_START	"ui/Beep_SynthTone01.wav"
#define SOUND_NEW_VOTE_WINNER	"ui/alert_clink.wav"


//Global Variables
int g_iGameMode;					    //Integer to store the gamemode
int g_iRoundEndCounter;				    //Round end event counter for versus
bool g_bStopACSChangeMap;
bool g_bCanIncrementRoundEndCounter;    // Prevents incrementing the round end counter twice from multiple event triggers
int g_iCoopFinaleFailureCount;		    //Number of times the Survivors have lost the current finale
int g_iMaxCoopFinaleFailures = 5;	    //Amount of times Survivors can fail before ACS switches in coop
bool g_bFinaleWon;				        //Indicates whether a finale has be beaten or not

//Campaign and map strings/names
char g_strCampaignFirstMap[NUMBER_OF_CAMPAIGNS][32];		//Array of maps to switch to
char g_strCampaignLastMap[NUMBER_OF_CAMPAIGNS][32];		//Array of maps to switch from
char g_strCampaignName[NUMBER_OF_CAMPAIGNS][32];			//Array of names of the campaign
char g_strScavengeMap[NUMBER_OF_SCAVENGE_MAPS][32];		//Array of scavenge maps
char g_strScavengeMapName[NUMBER_OF_SCAVENGE_MAPS][32];	//Name of scavenge maps
char g_strSurvivalMap[NUMBER_OF_SCAVENGE_MAPS][32];		//Array of Survival maps
char g_strSurvivalMapName[NUMBER_OF_SCAVENGE_MAPS][32];	//Name of Survival maps

//Voting Variables
bool g_bVotingEnabled = true;							    //Tells if the voting system is on
int g_iVotingAdDisplayMode = DISPLAY_MODE_MENU;				//The way to advertise the voting system
float g_fVotingAdDelayTime = 1.0;						//Time to wait before showing advertising
bool g_bVoteWinnerSoundEnabled = true;					    //Sound plays when vote winner changes
int g_iNextMapAdDisplayMode = DISPLAY_MODE_HINT;			//The way to advertise the next map
float g_fNextMapAdInterval = 600.0;						//Interval for ACS next map advertisement
bool g_bClientShownVoteAd[MAXPLAYERS + 1];				    //If the client has seen the ad already
bool g_bClientVoted[MAXPLAYERS + 1];					    //If the client has voted on a map
int g_iClientVote[MAXPLAYERS + 1];							//The value of the clients vote
int g_iWinningMapIndex;										//Winning map/campaign's index
int g_iWinningMapVotes;										//Winning map/campaign's number of votes

//Console Variables (CVars)
Handle g_hCVar_VotingEnabled			= INVALID_HANDLE;
Handle g_hCVar_VoteWinnerSoundEnabled	= INVALID_HANDLE;
Handle g_hCVar_VotingAdMode				= INVALID_HANDLE;
Handle g_hCVar_VotingAdDelayTime		= INVALID_HANDLE;
Handle g_hCVar_NextMapAdMode			= INVALID_HANDLE;
Handle g_hCVar_NextMapAdInterval		= INVALID_HANDLE;
Handle g_hCVar_MaxFinaleFailures		= INVALID_HANDLE;