//////////////////////////////////////////////////////////////////////
///////////////////////   Sound Definitions   ////////////////////////
//////////////////////////////////////////////////////////////////////

//Stock Sounds//
#define SOUND_XPM_ADVERTISEMENT             "buttons/button14.wav"
#define SOUND_LOGIN                         "ui/menu_countdown.wav"
#define SOUND_LEVELUP				        "ui/critical_event_1.wav"
#define SOUND_TALENTS_LOAD1			        "player/orch_hit_csharp_short.wav"
#define SOUND_HEADSHOT                      "level/timer_bell.wav"
#define SOUND_HEADSHOT_REWARD               "level/light_on.wav"
#define SOUND_FREEZE				        "physics/glass/glass_impact_bullet4.wav"
#define SOUND_AMBTEST3				        "music/stmusic/deathisacarousel.wav"
#define SOUND_PEEING				        "ambient/spacial_loops/4b_hospatrium_waterleak.wav"
#define SOUND_AMBTEST2				        "ambient/alarms/alarm1.wav"
#define SOUND_AMBTEST4				        "player/jockey/voice/idle/jockey_lurk03.wav"
#define SOUND_LEVELUPORIG			        "ui/beep_synthtone01.wav"
#define SOUND_IGNITE				        "ambient/fire/gascan_ignite1.wav"
#define SOUND_ONFIRE				        "ambient/fire/interior_fireclose01_mono.wav"
#define SOUND_JPHIGHREV				        "weapons/chainsaw/chainsaw_high_speed_lp_01.wav"
#define SOUND_JPIDLEREV				        "weapons/chainsaw/chainsaw_idle_lp_01.wav"
#define SOUND_JPSTART				        "weapons/chainsaw/chainsaw_start_02.wav"
#define SOUND_JPDIE					        "weapons/chainsaw/chainsaw_die_01.wav"
#define SOUND_JEBUS					        "ambient/wind/wind_snippet1.wav"
#define SOUND_CHARGECOACH			        "player/survivor/voice/coach/battlecry07.wav"
#define SOUND_SUITCHARGED			        "items/suitchargeok1.wav"
#define SOUND_WAREZ_STATION                 "ambient/spacial_loops/lights_flicker.wav"
#define SOUND_LOUIS_TELEPORT_USE            "ui/menu_countdown.wav"
#define SOUND_LOUIS_TELEPORT_USE_REGEN      "buttons/blip1.wav"
#define SOUND_LOUIS_TELEPORT_OVERLOAD       "ui/pickup_misc42.wav"
#define SOUND_ZAP1					        "ambient/energy/zap1.wav"
#define SOUND_ZAP2					        "ambient/energy/zap2.wav"
#define SOUND_ZAP3					        "ambient/energy/zap3.wav"
#define SOUND_BEEP					        "weapons/hegrenade/beep.wav"
#define SOUND_COACH_CHARGE1	        		"player/survivor/voice/coach/battlecry07.wav"
#define SOUND_COACH_CHARGE2			        "player/survivor/voice/coach/battlecry08.wav"
#define SOUND_COACH_CHARGE3			        "player/survivor/voice/coach/battlecry09.wav"
#define SOUND_FLIES					        "ambient/creatures/flies_loop.wav"
#define SOUND_HOOKGRAB				        "player/smoker/miss/smoker_reeltonguein_02.wav"
#define SOUND_HOOKRELEASE			        "player/smoker/miss/smoker_reeltonguein_01.wav"
#define SOUND_JOCKEYPEE				        "ambient/spacial_loops/4b_hospatrium_waterleak.wav"
#define SOUND_JOCKEYLAUGH1			        "player/jockey/voice/idle/jockey_lurk03.wav"
#define SOUND_JOCKEYLAUGH2			        "player/jockey/voice/idle/jockey_lurk09.wav"
#define SOUND_BOOMER_EXPLODE                "player/boomer/explode/explo_medium_10.wav"
new String:SOUND_BOOMER_THROW[][] =         {"player/boomer/hit/boomer_shoved_02.wav",
                                            "player/boomer/hit/boomer_shoved_04.wav",
                                            "player/boomer/hit/boomer_shoved_05.wav",
                                            "player/boomer/hit/boomer_shoved_06.wav",
                                            "player/boomer/hit/boomer_shoved_07.wav",
                                            "player/boomer/hit/boomer_shoved_08.wav",
                                            "player/boomer/fall/boomer_dive_01.wav"}
#define SOUND_EXPLODE				        "ambient/explosions/explode_1.wav"
new String:SOUND_ZOMBIE_SLASHES[][] =       {"player/pz/hit/zombie_slice_1.wav",
                                            "player/pz/hit/zombie_slice_2.wav",
                                            "player/pz/hit/zombie_slice_3.wav",
                                            "player/pz/hit/zombie_slice_4.wav",
                                            "player/pz/hit/zombie_slice_5.wav",
                                            "player/pz/hit/zombie_slice_6.wav"}
new String:SOUND_WING_FLAP[][] =            {"player/survivor/swing/swing_miss1.wav",
                                            "player/survivor/swing/swing_miss2.wav"}

//Custom Sounds//
#define SOUND_TALENTS_LOAD2			"xpmod/ui/talents_load.wav"
#define SOUND_NINJA_ACTIVATE		"xpmod/survivors/rochelle/rochelle_ulti_ninja_activate.wav"
#define SOUND_IDD_ACTIVATE			"xpmod/survivors/rochelle/rochelle_idd_activate.wav"
#define SOUND_IDD_DEACTIVATE		"xpmod/survivors/rochelle/rochelle_idd_deactivate.wav"
#define SOUND_NICK_HEAL				"xpmod/survivors/nick/nick_ulti_heal_success.wav"
#define SOUND_NICK_RESURRECT		"xpmod/survivors/nick/nick_ulti_resurrect_success.wav"
#define SOUND_NICK_REVIVE           "xpmod/survivors/nick/nick_ulti_revive_success.wav"
#define SOUND_NICK_LIFESTEAL_HIT    "xpmod/survivors/nick/nick_vampire_round_hit.wav"
#define SOUND_COACH_CHARGE_HIT		"xpmod/survivors/coach/coach_melee_charge_hit.wav"
#define SOUND_WARP					"xpmod/infected/smoker/teleport_warp.wav"
#define SOUND_WARP_LIFE				"xpmod/infected/smoker/teleport_warp_lifetime_sound.wav"
#define SOUND_1KILL					"xpmod/announcer/1_kill.wav"
#define SOUND_2KILLS				"xpmod/announcer/2_kills.wav"
#define SOUND_3KILLS				"xpmod/announcer/3_kills.wav"
#define SOUND_4KILLS				"xpmod/announcer/4_kills.wav"
#define SOUND_5KILLS				"xpmod/announcer/5_kills.wav"
#define SOUND_6KILLS				"xpmod/announcer/6_kills.wav"
#define SOUND_7KILLS				"xpmod/announcer/7_kills.wav"
#define SOUND_8KILLS				"xpmod/announcer/8_kills.wav"
#define SOUND_9KILLS				"xpmod/announcer/9_kills.wav"
#define SOUND_10KILLS				"xpmod/announcer/10_kills.wav"
#define SOUND_11KILLS				"xpmod/announcer/11_kills.wav"
#define SOUND_12KILLS				"xpmod/announcer/12_kills.wav"
#define SOUND_13KILLS				"xpmod/announcer/13_kills.wav"
#define SOUND_14KILLS				"xpmod/announcer/14_kills.wav"
#define SOUND_15KILLS				"xpmod/announcer/15_kills.wav"
#define SOUND_16KILLS				"xpmod/announcer/16_kills.wav"
#define SOUND_HEADSHOT1				"xpmod/announcer/headshot.wav"
#define SOUND_HEADSHOT2				"xpmod/announcer/headshot_boom.wav"
#define SOUND_HEADSHOT3				"xpmod/announcer/brain_surgeon.wav"
#define SOUND_GETITON				"xpmod/announcer/get_it_on.wav"