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

void SetupMapStrings()
{	
	//The following three variables are for all game modes except Scavenge.
	
	//*IMPORTANT* Before editing these change NUMBER_OF_CAMPAIGNS near the top 
	//of this plugin to match the total number of campaigns or it will not 
	//loop through all of them when the check is made to change the campaign.
	
	//First Maps of the Campaign
	Format(g_strCampaignFirstMap[0], 32, "c8m1_apartment");  // Known area to not load sometimes and everyone is returned to lobby
	Format(g_strCampaignFirstMap[1], 32, "c9m1_alleys");
	Format(g_strCampaignFirstMap[2], 32, "c10m1_caves");
	Format(g_strCampaignFirstMap[3], 32, "c11m1_greenhouse");
	Format(g_strCampaignFirstMap[4], 32, "c12m1_hilltop");
	Format(g_strCampaignFirstMap[5], 32, "c7m1_docks");
	Format(g_strCampaignFirstMap[6], 32, "c1m1_hotel");
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
	Format(g_strCampaignLastMap[5], 32, "c7m3_port");
	Format(g_strCampaignLastMap[6], 32, "c1m4_atrium");
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
	Format(g_strCampaignName[5], 32, "The Sacrifice");
	Format(g_strCampaignName[6], 32, "Dead Center");
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
	Format(g_strScavengeMap[5], 32, "c7m1_docks");
	Format(g_strScavengeMap[6], 32, "c7m2_barge");
	Format(g_strScavengeMap[7], 32, "c1m4_atrium");
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
	Format(g_strScavengeMapName[5], 32, "Brick Factory");
	Format(g_strScavengeMapName[6], 32, "Barge");
	Format(g_strScavengeMapName[7], 32, "Mall Atrium");
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

	// Missing scavenge
	// Crash course, the alleys

	//The following string variables are only for Survival

	//Survival Maps
	//Format(g_strSurvivalMap[0], 32, "c8m1_apartment");
	Format(g_strSurvivalMap[1], 32, "c8m5_rooftop");
	Format(g_strSurvivalMap[2], 32, "c10m3_ranchhouse");
	Format(g_strSurvivalMap[3], 32, "c11m4_terminal");
	Format(g_strSurvivalMap[4], 32, "c12m5_cornfield");
	Format(g_strSurvivalMap[5], 32, "c7m1_docks");
	Format(g_strSurvivalMap[6], 32, "c7m2_barge");
	Format(g_strSurvivalMap[7], 32, "c1m4_atrium");
	Format(g_strSurvivalMap[8], 32, "c6m1_riverbank");
	Format(g_strSurvivalMap[9], 32, "c6m2_bedlam");
	Format(g_strSurvivalMap[10], 32, "c6m3_port");
	Format(g_strSurvivalMap[11], 32, "c2m1_highway");
	Format(g_strSurvivalMap[12], 32, "c3m1_plankcountry");
	Format(g_strSurvivalMap[13], 32, "c4m1_milltown_a");
	Format(g_strSurvivalMap[14], 32, "c4m2_sugarmill_a");
	Format(g_strSurvivalMap[15], 32, "c5m2_park");
	Format(g_strSurvivalMap[16], 32, "c14m1_junkyard");
	Format(g_strSurvivalMap[17], 32, "c14m2_lighthouse");
	
	//Survival Map Names
	// No mercy
	// Generator Room
	//Format(g_strSurvivalMapName[0], 32, "Apartments");
	Format(g_strSurvivalMapName[1], 32, "Rooftop");
	Format(g_strSurvivalMapName[2], 32, "The Church");
	Format(g_strSurvivalMapName[3], 32, "The Terminal");
	Format(g_strSurvivalMapName[4], 32, "The Farmhouse");
	Format(g_strSurvivalMapName[5], 32, "Brick Factory");
	Format(g_strSurvivalMapName[6], 32, "Barge");
	Format(g_strSurvivalMapName[7], 32, "Mall Atrium");
	Format(g_strSurvivalMapName[8], 32, "Riverbank");
	Format(g_strSurvivalMapName[9], 32, "Underground");
	//The Sacrifice
	// Train Car
	Format(g_strSurvivalMapName[10], 32, "Port");	// port shows up in the passing and teh sacrifice
	Format(g_strSurvivalMapName[11], 32, "Motel"); 
	//Dark Carnival
	// Stadium Gate
	// Concert
	Format(g_strSurvivalMapName[12], 32, "Plank Country");
	Format(g_strSurvivalMapName[13], 32, "Milltown");
	//Hard Rain
	// Burger Tank
	Format(g_strSurvivalMapName[14], 32, "Sugar Mill");
	Format(g_strSurvivalMapName[15], 32, "Park");
	Format(g_strSurvivalMapName[16], 32, "The Village");
	Format(g_strSurvivalMapName[17], 32, "The Lighthouse");
}

//Swamp Fever
// Gator village
// Plantation

//The Parish
// Bus Depot
// Bridge
