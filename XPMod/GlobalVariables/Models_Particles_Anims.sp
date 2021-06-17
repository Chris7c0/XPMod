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

// Game Items
#define ITEM_EMPTY                  0
#define ITEM_ISRAELI_UZI            1
#define ITEM_SILENCED_MAC_10        2
#define ITEM_MP5                    3
#define ITEM_AK47                   4
#define ITEM_M16A2                  5
#define ITEM_SIG_SG_552             6
#define ITEM_SCAR_L                 7
#define ITEM_REMINGTON_870          8
#define ITEM_REMINGTON_870_CUSTOM   9
#define ITEM_BENELLI_M1014          10
#define ITEM_FRANCHI_SPAS_12        11
#define ITEM_RUGER_MINI_14          12
#define ITEM_HK_MSG90               13
#define ITEM_SCOUT                  14
#define ITEM_AWP                    15
#define ITEM_GRENADE_LAUNCHER       16
#define ITEM_M60                    17
#define ITEM_P220                   18
#define ITEM_GLOCK_P220             19
#define ITEM_MAGNUM                 20
#define ITEM_AXE                    21
#define ITEM_CROWBAR                22
#define ITEM_CRICKET_BAT            23
#define ITEM_BASEBALL_BAT           24
#define ITEM_KATANA                 25
#define ITEM_ELECTRIC_GUITAR        26
#define ITEM_MACHETE                27
#define ITEM_FRYING_PAN             28
#define ITEM_NIGHTSTICK             29
#define ITEM_CHAINSAW               30
#define ITEM_COMBAT_KNIFE           31
#define ITEM_GOLF_CLUB              32
#define ITEM_PITCH_FORK             33
#define ITEM_PIPE_BOMB              34
#define ITEM_MOLOTOV                35
#define ITEM_BILE_JAR               36
#define ITEM_FIRST_AID_KIT          37
#define ITEM_DEFIBRILLATOR          38
#define ITEM_INCENDIARY_AMMO        39
#define ITEM_EXPLOSIVE_AMMO         40
#define ITEM_PAIN_PILLS             41
#define ITEM_ADRENALINE_SHOT        42
// Total Item Count
#define ITEM_COUNT                      42
// Compare Modes for Finding Indexes
#define ITEM_COMPARE_MODE_NAME          0
#define ITEM_COMPARE_MODE_CLASS_NAME    1
#define ITEM_COMPARE_MODE_CMD_NAME      2
// Slots Ranges
#define ITEM_RANGE_MIN_SLOT_PRIMARY     1
#define ITEM_RANGE_MAX_SLOT_PRIMARY     17
#define ITEM_RANGE_MIN_SLOT_SECONDARY   18
#define ITEM_RANGE_MAX_SLOT_SECONDARY   33
#define ITEM_RANGE_MIN_SLOT_EXPLOSIVE   34
#define ITEM_RANGE_MAX_SLOT_EXPLOSIVE   36
#define ITEM_RANGE_MIN_SLOT_HEALTH      37
#define ITEM_RANGE_MAX_SLOT_HEALTH      40
#define ITEM_RANGE_MIN_SLOT_BOOST       41
#define ITEM_RANGE_MAX_SLOT_BOOST       42
// Equipment Type Ranges
#define ITEM_RANGE_MIN_SMG              1
#define ITEM_RANGE_MAX_SMG              3
#define ITEM_RANGE_MIN_RIFLE            4
#define ITEM_RANGE_MAX_RIFLE            7
#define ITEM_RANGE_MIN_SHOTGUN          8
#define ITEM_RANGE_MAX_SHOTGUN          11
#define ITEM_RANGE_MIN_SNIPER           12
#define ITEM_RANGE_MAX_SNIPER           15
#define ITEM_RANGE_MIN_SPECIAL          16
#define ITEM_RANGE_MAX_SPECIAL          17
#define ITEM_RANGE_MIN_PISTOL           18
#define ITEM_RANGE_MAX_PISTOL           20
#define ITEM_RANGE_MIN_MELEE            21
#define ITEM_RANGE_MAX_MELEE            33
#define ITEM_RANGE_MIN_EXPLOSIVE        34
#define ITEM_RANGE_MAX_EXPLOSIVE        36
#define ITEM_RANGE_MIN_HEALTH           37
#define ITEM_RANGE_MAX_HEALTH           38
#define ITEM_RANGE_MIN_BOOST            41
#define ITEM_RANGE_MAX_BOOST            42
// Item XPM Equipment Costs
#define ITEM_COST_EMPTY                  0
#define ITEM_COST_ISRAELI_UZI            55
#define ITEM_COST_SILENCED_MAC_10        60
#define ITEM_COST_MP5                    70
#define ITEM_COST_AK47                   80
#define ITEM_COST_M16A2                  80
#define ITEM_COST_SIG_SG_552             100
#define ITEM_COST_SCAR_L                 0
#define ITEM_COST_REMINGTON_870          60
#define ITEM_COST_REMINGTON_870_CUSTOM   60
#define ITEM_COST_BENELLI_M1014          80
#define ITEM_COST_FRANCHI_SPAS_12        80
#define ITEM_COST_RUGER_MINI_14          60
#define ITEM_COST_HK_MSG90               80
#define ITEM_COST_SCOUT                  60
#define ITEM_COST_AWP                    100
#define ITEM_COST_GRENADE_LAUNCHER       400
#define ITEM_COST_M60                    500
#define ITEM_COST_P220                   0
#define ITEM_COST_GLOCK_P220             15
#define ITEM_COST_MAGNUM                 40
#define ITEM_COST_AXE                    20
#define ITEM_COST_CROWBAR                20
#define ITEM_COST_CRICKET_BAT            25
#define ITEM_COST_BASEBALL_BAT           25
#define ITEM_COST_KATANA                 40
#define ITEM_COST_ELECTRIC_GUITAR        20
#define ITEM_COST_MACHETE                0
#define ITEM_COST_FRYING_PAN             20
#define ITEM_COST_NIGHTSTICK             50
#define ITEM_COST_CHAINSAW               250
#define ITEM_COST_COMBAT_KNIFE           50
#define ITEM_COST_GOLF_CLUB              30
#define ITEM_COST_PITCH_FORK             30
#define ITEM_COST_PIPE_BOMB              30
#define ITEM_COST_MOLOTOV                0
#define ITEM_COST_BILE_JAR               40
#define ITEM_COST_FIRST_AID_KIT          0
#define ITEM_COST_DEFIBRILLATOR          500
#define ITEM_COST_INCENDIARY_AMMO        500
#define ITEM_COST_EXPLOSIVE_AMMO         1000
#define ITEM_COST_PAIN_PILLS             0
#define ITEM_COST_ADRENALINE_SHOT        50
#define ITEM_COST_LASER_SIGHT            100


// new String:ITEM_NAME[][] =              {"Empty",
//                                         "Israeli UZI",
//                                         "Silenced MAC-10",
//                                         "MP5",
//                                         "AK-47",
//                                         "M16A2",
//                                         "SIG SG 552",
//                                         "Scar-L",
//                                         "Remington 870",
//                                         "Remington 870 Custom",
//                                         "Benelli M1014",
//                                         "Franchi SPAS-12",
//                                         "Ruger Mini-14",
//                                         "H&K MSG90",
//                                         "Scout",
//                                         "AWP",
//                                         "Grenade Launcher",
//                                         "M60",
//                                         "P220",
//                                         "Glock + P220",
//                                         "Magnum",
//                                         "Axe",
//                                         "Crowbar",
//                                         "Cricket Bat",
//                                         "Baseball Bat",
//                                         "Katana",
//                                         "Electric Guitar",
//                                         "Machete",
//                                         "Frying Pan",
//                                         "Nightstick",
//                                         "Chainsaw",
//                                         "Combat Knife",
//                                         "Golf Club",
//                                         "Pitch Fork",
//                                         "Pipe Bomb",
//                                         "Molotov",
//                                         "Bile Jar",
//                                         "First Aid Kit",
//                                         "Defibrillator",
//                                         "Incendiary Ammo",
//                                         "Explosive Ammo",
//                                         "Pain Pills",
//                                         "Adrenaline Shot"}

new String:ITEM_CLASS_NAME[][] =        {"empty",
                                        "weapon_smg",
                                        "weapon_smg_silenced",
                                        "weapon_smg_mp5",
                                        "weapon_rifle_ak47",
                                        "weapon_rifle",
                                        "weapon_rifle_sg552",
                                        "weapon_rifle_desert",
                                        "weapon_pumpshotgun",
                                        "weapon_shotgun_chrome",
                                        "weapon_autoshotgun",
                                        "weapon_shotgun_spas",
                                        "weapon_hunting_rifle",
                                        "weapon_sniper_military",
                                        "weapon_sniper_scout",
                                        "weapon_sniper_awp",
                                        "weapon_grenade_launcher",
                                        "weapon_rifle_m60",
                                        "weapon_pistol",
                                        "weapon_pistol",
                                        "weapon_pistol_magnum",
                                        "weapon_fireaxe",
                                        "weapon_crowbar",
                                        "weapon_cricket_bat",
                                        "weapon_baseball_bat",
                                        "weapon_katana",
                                        "weapon_electric_guitar",
                                        "weapon_machete",
                                        "weapon_frying_pan",
                                        "weapon_tonfa",
                                        "weapon_chainsaw",
                                        "weapon_knife",
                                        "weapon_golfclub",
                                        "weapon_pitchfork",
                                        "weapon_pipe_bomb",
                                        "weapon_molotov",
                                        "weapon_vomitjar",
                                        "weapon_first_aid_kit",
                                        "weapon_defibrillator",
                                        "weapon_upgradepack_incendiary",
                                        "weapon_upgradepack_explosive",
                                        "weapon_pain_pills",
                                        "weapon_adrenaline"}

new String:ITEM_CMD_NAME[][] =         {"empty",
                                        "smg",
                                        "smg_silenced",
                                        "smg_mp5",
                                        "rifle_ak47",
                                        "rifle",
                                        "rifle_sg552",
                                        "rifle_desert",
                                        "pumpshotgun",
                                        "shotgun_chrome",
                                        "autoshotgun",
                                        "shotgun_spas",
                                        "hunting_rifle",
                                        "sniper_military",
                                        "sniper_scout",
                                        "sniper_awp",
                                        "grenade_launcher",
                                        "rifle_m60",
                                        "pistol",
                                        "pistol",
                                        "pistol_magnum",
                                        "fireaxe",
                                        "crowbar",
                                        "cricket_bat",
                                        "baseball_bat",
                                        "katana",
                                        "electric_guitar",
                                        "machete",
                                        "frying_pan",
                                        "tonfa",
                                        "chainsaw",
                                        "knife",
                                        "golfclub",
                                        "pitchfork",
                                        "pipe_bomb",
                                        "molotov",
                                        "vomitjar",
                                        "first_aid_kit",
                                        "defibrillator",
                                        "upgradepack_incendiary",
                                        "upgradepack_explosive",
                                        "pain_pills",
                                        "adrenaline"}

new String:ITEM_MODEL_PATH[][] =        {"empty",
                                        "models/w_models/weapons/w_smg_uzi.mdl",
                                        "models/w_models/weapons/w_smg_a.mdl",
                                        "models/w_models/weapons/w_smg_mp5.mdl",
                                        "models/w_models/weapons/w_rifle_ak47.mdl",
                                        "models/w_models/weapons/w_rifle_m16a2.mdl",
                                        "models/w_models/weapons/w_rifle_sg552.mdl",
                                        "models/w_models/weapons/w_desert_rifle.mdl",
                                        "models/w_models/weapons/w_pumpshotgun_A.mdl",
                                        "pumpshotgun_CUSTOM",
                                        "models/w_models/weapons/w_autoshot_m4super.mdl",
                                        "models/w_models/weapons/w_shotgun_spas.mdl",
                                        "hunting_rifle",
                                        "models/w_models/weapons/w_sniper_military.mdl",
                                        "models/w_models/weapons/w_sniper_scout.mdl",
                                        "models/w_models/weapons/w_sniper_awp.mdl",
                                        "models/w_models/weapons/w_grenade_launcher.mdl",
                                        "models/w_models/weapons/w_m60.mdl",
                                        "models/w_models/weapons/w_pistol_a.mdl",
                                        "models/w_models/weapons/w_pistol_a.mdl",
                                        "models/w_models/weapons/w_desert_eagle.mdl",
                                        "fireaxe",
                                        "crowbar",
                                        "cricket_bat",
                                        "baseball_bat",
                                        "katana",
                                        "electric_guitar",
                                        "machete",
                                        "frying_pan",
                                        "tonfa",
                                        "models/weapons/melee/w_chainsaw.mdl",
                                        "knife",
                                        "golfclub",
                                        "pitchfork",
                                        "models/w_models/weapons/w_eq_pipebomb.mdl",
                                        "models/w_models/weapons/w_eq_molotov.mdl",
                                        "models/w_models/weapons/w_eq_bile_flask.mdl",
                                        "models/w_models/weapons/w_eq_medkit.mdl",
                                        "models/w_models/weapons/w_eq_defibrillator.mdl",
                                        "models/w_models/weapons/w_eq_incendiary_ammopack.mdl",
                                        "models/w_models/weapons/w_eq_explosive_ammopack.mdl",
                                        "models/w_models/weapons/w_eq_painpills.mdl",
                                        "models/w_models/weapons/w_eq_adrenaline.mdl"}




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