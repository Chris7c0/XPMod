//This is for overlay colors
new UserMsg:g_umsgFade;

//Particle attatchment points
#define ATTACH_NONE				-1
#define ATTACH_NORMAL			0
#define ATTACH_MOUTH			1
#define ATTACH_EYES				2
#define ATTACH_MUZZLE_FLASH		3
#define ATTACH_WEAPON_BONE		4
#define ATTACH_DEBRIS			5
#define ATTACH_RSHOULDER		6

/*
#define ATTACH_MEDKIT			X
#define ATTACH_SHELL			X
#define ATTACH_SPINE			X
#define ATTACH_FORWARD			X
#define ATTACH_SURVIVOR_LIGHT	X
#define ATTACH_BLUR				X
*/

//Animations for crawling
#define ANIM_L4D2_NICK		631
#define ANIM_L4D2_ELLIS		636
#define ANIM_L4D2_ROCHELLE		639
#define ANIM_L4D2_ZOEY		658
#define ANIM_L4D2_LOUIS		539
#define ANIM_L4D2_FRANCIS	542
#define ANIM_L4D2_BILL		539


//For Hud Overlay Colors
//#define FADE_SOLID2	0x0000
#define FADE_SOLID	0x0008
#define FADE_OUT	0x0001
#define FADE_IN		0x0002
#define FADE_STOP	0x0010


//Common Infected Model Names
new String:COMMON_INFECTED_MODELS[][] = {"models/infected/common_female_tanktop_jeans.mdl", 
                                        "models/infected/common_female_tshirt_skirt.mdl",
                                        "models/infected/common_male_dressshirt_jeans.mdl",
                                        "models/infected/common_male_polo_jeans.mdl",
                                        "models/infected/common_male_tanktop_jeans.mdl",
                                        "models/infected/common_male_tanktop_overalls.mdl",
                                        "models/infected/common_male_tshirt_cargos.mdl"}

//Uncommon Infected Model Names
new String:UNCOMMON_INFECTED_MODELS[][] =   {"models/infected/common_male_jimmy.mdl",
                                            "models/infected/common_male_clown.mdl",
                                            "models/infected/common_male_ceda.mdl", 
                                            "models/infected/common_male_mud.mdl",
                                            "models/infected/common_male_riot.mdl",
                                            "models/infected/common_male_roadcrew.mdl"}

// Game Item Models for spawning in game
#define ITEM_FIRST_AID_KIT          0
#define ITEM_PAIN_PILLS             1
#define ITEM_ADRENALINE             2
#define ITEM_DEFIBRILLATOR          3
#define ITEM_MOLOTOV                4
#define ITEM_BILE_JAR               5
#define ITEM_PIPE_BOMB              6
#define ITEM_COUNT                  6

new String:ITEM_NAME[][] =              {"weapon_first_aid_kit",
                                        "weapon_pain_pills",
                                        "weapon_adrenaline",
	                                    "weapon_defibrillator",
                                        "weapon_molotov",
                                        "weapon_vomitjar",
	                                    "weapon_pipe_bomb"}

new String:ITEM_MODEL_PATH[][] =        {"models/w_models/weapons/w_eq_medkit.mdl",
                                        "models/w_models/weapons/w_eq_painpills.mdl",
                                        "models/w_models/weapons/w_eq_adrenaline.mdl",
	                                    "models/w_models/weapons/w_eq_defibrillator.mdl",
                                        "models/w_models/weapons/w_eq_molotov.mdl",
                                        "models/w_models/weapons/w_eq_bile_flask.mdl",
	                                    "models/w_models/weapons/w_eq_pipebomb.mdl"}




//Sprites
new g_iSprite_Laser;
new g_iSprite_Halo;
new g_iSprite_SmokerTongue;
new g_iSprite_AmmoBox;
new g_iSprite_Arrow;
//Experience Sprites
new g_iSprite_1XP;
new g_iSprite_5XP_HS;
new g_iSprite_25XP;
new g_iSprite_50XP;
new g_iSprite_75XP_HS;
new g_iSprite_100XP;
new g_iSprite_150XP;
new g_iSprite_250XP;
new g_iSprite_250XP_Team;
new g_iSprite_350XP;
new g_iSprite_10XP_Bill;
new g_iSprite_20XP_Bill;
new g_iSprite_30XP_Bill;
new g_iSprite_40XP_Bill;
new g_iSprite_50XP_Bill;
new g_iSprite_3XP_SI;
new g_iSprite_10XP_SI;
new g_iSprite_15XP_SI;
new g_iSprite_25XP_SI;
new g_iSprite_50XP_SI;
new g_iSprite_200XP_SI;
new g_iSprite_500XP_SI;



//Particles /////////////////////////////////////////////////////////////////////////////////////

//Bill Particles

//Rochelle Particles
new g_iPID_RochelleCharge1[MAXPLAYERS + 1];
new g_iPID_RochelleCharge2[MAXPLAYERS + 1];
new g_iPID_RochelleCharge3[MAXPLAYERS + 1];
new g_iPID_RochelleJumpCharge[MAXPLAYERS + 1];
new g_iPID_RochellePoisonBullet[MAXPLAYERS + 1];

//Coach Particles
new g_iPID_CoachMeleeCharge1[MAXPLAYERS + 1];
new g_iPID_CoachMeleeCharge2[MAXPLAYERS + 1];
new g_iPID_CoachCharge1[MAXPLAYERS + 1];
new g_iPID_CoachCharge2[MAXPLAYERS + 1];
new g_iPID_CoachCharge3[MAXPLAYERS + 1];
new g_iPID_CoachJetpackStream[MAXPLAYERS + 1];
new g_iPID_CoachMeleeChargeHeal[MAXPLAYERS + 1];

//Ellis Particles
new g_iPID_EllisCharge1[MAXPLAYERS + 1];
new g_iPID_EllisCharge2[MAXPLAYERS + 1];
new g_iPID_EllisCharge3[MAXPLAYERS + 1];
new g_iPID_EllisFireStorm[MAXPLAYERS + 1];

//Nicks Particles
new g_iPID_NickCharge1[MAXPLAYERS + 1];
new g_iPID_NickCharge2[MAXPLAYERS + 1];
new g_iPID_NickCharge3[MAXPLAYERS + 1];

//Spitter Particles
new g_iPID_DemiGravityEffect[MAXPLAYERS + 1];
new g_iPID_SpitterSlimeTrail[MAXPLAYERS + 1];

//Charger Particles
new g_iPID_ChargerShield[MAXPLAYERS + 1];

//Tank Particles
new g_iPID_TankChargedFire[MAXPLAYERS + 1];
new g_iPID_IceTankChargeMistStock[MAXPLAYERS + 1];
new g_iPID_IceTankChargeMistAddon[MAXPLAYERS + 1];
new g_iPID_IceTankChargeSnow[MAXPLAYERS + 1];
new g_iPID_IceTankIcicles[MAXPLAYERS + 1];
new g_iPID_TankTrail[MAXPLAYERS + 1];

//Survivor Particle Menu Descriptions
new bool:g_bEnabledVGUI[MAXPLAYERS + 1];					//VGUI toggle for iClient menu descriptions
new bool:g_bShowingVGUI[MAXPLAYERS + 1];	

new g_iPID_MD_Bill_Inspirational[MAXPLAYERS + 1];
new g_iPID_MD_Bill_Ghillie[MAXPLAYERS + 1];
new g_iPID_MD_Bill_Will[MAXPLAYERS + 1];
new g_iPID_MD_Bill_Exorcism[MAXPLAYERS + 1];
new g_iPID_MD_Bill_Diehard[MAXPLAYERS + 1];
new g_iPID_MD_Bill_Promotional[MAXPLAYERS + 1];

new g_iPID_MD_Rochelle_Gather[MAXPLAYERS + 1];
new g_iPID_MD_Rochelle_Hunter[MAXPLAYERS + 1];
new g_iPID_MD_Rochelle_Sniper[MAXPLAYERS + 1];
new g_iPID_MD_Rochelle_Silent[MAXPLAYERS + 1];
new g_iPID_MD_Rochelle_Smoke[MAXPLAYERS + 1];
new g_iPID_MD_Rochelle_Shadow[MAXPLAYERS + 1];

new g_iPID_MD_Coach_Bull[MAXPLAYERS + 1];
new g_iPID_MD_Coach_Wrecking[MAXPLAYERS + 1];
new g_iPID_MD_Coach_Spray[MAXPLAYERS + 1];
new g_iPID_MD_Coach_Homerun[MAXPLAYERS + 1];
new g_iPID_MD_Coach_Lead[MAXPLAYERS + 1];
new g_iPID_MD_Coach_Strong[MAXPLAYERS + 1];

new g_iPID_MD_Ellis_Over[MAXPLAYERS + 1];
new g_iPID_MD_Ellis_Bring[MAXPLAYERS + 1];
new g_iPID_MD_Ellis_Jammin[MAXPLAYERS + 1];
new g_iPID_MD_Ellis_Weapons[MAXPLAYERS + 1];
new g_iPID_MD_Ellis_Mechanic[MAXPLAYERS + 1];
new g_iPID_MD_Ellis_Fire[MAXPLAYERS + 1];

new g_iPID_MD_Nick_Swindler[MAXPLAYERS + 1];
new g_iPID_MD_Nick_Leftover[MAXPLAYERS + 1];
new g_iPID_MD_Nick_Magnum[MAXPLAYERS + 1];
new g_iPID_MD_Nick_Enhanced[MAXPLAYERS + 1];
new g_iPID_MD_Nick_Risky[MAXPLAYERS + 1];
new g_iPID_MD_Nick_Desperate[MAXPLAYERS + 1];