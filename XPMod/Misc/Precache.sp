PrecacheAllParticles()
{
	// Bill
	
	// Rochelle
	PrecacheParticle("rochelle_ulti_ninja_charge1");
	PrecacheParticle("rochelle_ulti_ninja_charge2");
	PrecacheParticle("rochelle_ulti_ninja_charge3");
	PrecacheParticle("poison_bullet");
	PrecacheParticle("poison_bullet_pool");
	//PrecacheParticle("rochelle_smoke");
	PrecacheParticle("rochelle_jump_charge");
	//PrecacheParticle("rochelle_weapon_trail");		//Needs to be tested
	PrecacheParticle("rochelle_jump_charge_release");
	PrecacheParticle("rochelle_jump_charge_trail");
	PrecacheParticle("rochelle_silhouette");		// need to fix?
	
	// Coach
	PrecacheParticle("coach_bind_turret_charge1");
	PrecacheParticle("coach_bind_turret_charge2");
	PrecacheParticle("coach_bind_turret_charge3");
	PrecacheParticle("coach_melee_charge_muzbone");
	PrecacheParticle("coach_melee_charge_wepbone");
	PrecacheParticle("coach_melee_charge_splash");
	PrecacheParticle("jetpack_stream");
	PrecacheParticle("coach_melee_charge_heal");
	//PrecacheParticle("coach_melee_charge_arms");
	
	// Ellis
	PrecacheParticle("ellis_ulti_fire_charge1");
	PrecacheParticle("ellis_ulti_fire_charge2");
	PrecacheParticle("ellis_ulti_fire_charge3");
	PrecacheParticle("ellis_ulti_firewalk");
	
	// Nick
	PrecacheParticle("nick_ulti_heal_charge1");
	PrecacheParticle("nick_ulti_heal_charge2");
	PrecacheParticle("nick_ulti_heal_charge3");
	PrecacheParticle("nick_ulti_heal");
	PrecacheParticle("nick_ulti_revive");
	PrecacheParticle("nick_ulti_resurrect_base");
	PrecacheParticle("nick_ulti_resurrect_mind");
	PrecacheParticle("nick_ulti_resurrect_body");
	PrecacheParticle("nick_ulti_resurrect_soul");
	PrecacheParticle("nick_ulti_resurrect_trail");
	PrecacheParticle("nick_bind_gamble");
	PrecacheParticle("nick_lifesteal_recovery");
	
	// Smoker
	PrecacheParticle("bug_zapper_fly_cloud");
	PrecacheParticle("electrical_arc_01_system");
	// PrecacheParticle("smoker_spore_attack");
	PrecacheParticle("teleport_warp");
	
	//Menu Descriptions "VGUIs"
	// Bill
	PrecacheParticle("md_bill_inspirational");
	PrecacheParticle("md_bill_ghillie");
	PrecacheParticle("md_bill_will");
	PrecacheParticle("md_bill_exorcism");
	PrecacheParticle("md_bill_diehard");
	PrecacheParticle("md_bill_promotional");
	
	// Rochelle
	PrecacheParticle("md_rochelle_gather");
	PrecacheParticle("md_rochelle_hunter");
	PrecacheParticle("md_rochelle_sniper");
	PrecacheParticle("md_rochelle_silent");
	PrecacheParticle("md_rochelle_smoke");
	PrecacheParticle("md_rochelle_shadow");
	
	// Coach
	PrecacheParticle("md_coach_bull");
	PrecacheParticle("md_coach_wrecking");
	PrecacheParticle("md_coach_spray");
	PrecacheParticle("md_coach_homerun");
	PrecacheParticle("md_coach_lead");
	PrecacheParticle("md_coach_strong");
	
	// Ellis
	PrecacheParticle("md_ellis_over");
	PrecacheParticle("md_ellis_bring");
	PrecacheParticle("md_ellis_jammin");
	PrecacheParticle("md_ellis_weapons");
	PrecacheParticle("md_ellis_mechanic");
	PrecacheParticle("md_ellis_fire");
	
	// Nick
	PrecacheParticle("md_nick_swindler");
	PrecacheParticle("md_nick_leftover");
	PrecacheParticle("md_nick_magnum");
	PrecacheParticle("md_nick_enhanced");
	PrecacheParticle("md_nick_risky");
	PrecacheParticle("md_nick_desperate");
	
	// Spitter
	PrecacheParticle("spitter_goo_adhesive");
	PrecacheParticle("spitter_goo_melting");
	PrecacheParticle("spitter_goo_demi");
	PrecacheParticle("spitter_goo_repulsion");
	PrecacheParticle("spitter_goo_viral");
	PrecacheParticle("spitter_slime_trail");
	PrecacheParticle("demi_gravity_effect");
	PrecacheParticle("hallucinogenic_effect");
	PrecacheParticle("hallucinogenic_effect_people");
	PrecacheParticle("spitter_conjure");
	
	// Charger
	PrecacheParticle("charger_shield");
	
	// Tanks
	PrecacheParticle("fire_small_01");
	PrecacheParticle("ice_tank_charge_mist");
	PrecacheParticle("ice_tank_charge_snow");
	PrecacheParticle("ice_tank_icicles");
	PrecacheParticle("vomit_jar_b");
	
	// Misc
	PrecacheParticle("mini_fireworks");
	PrecacheParticle("drugged_effect");
	PrecacheParticle("poison_bubbles");
}

PrecacheAllSounds()
{
	PrecacheSound(SOUND_XPM_ADVERTISEMENT);
	PrecacheSound(SOUND_LOGIN);
	PrecacheSound(SOUND_LEVELUP);
	PrecacheSound(SOUND_TALENTS_LOAD);
	PrecacheSound(SOUND_AMBTEST4);
	PrecacheSound(SOUND_PEEING);
	PrecacheSound(SOUND_IGNITE);
	PrecacheSound(SOUND_ONFIRE);
	PrecacheSound(SOUND_JPHIGHREV);
	PrecacheSound(SOUND_JPIDLEREV);
	PrecacheSound(SOUND_JPDIE);
	PrecacheSound(SOUND_JPSTART);
	PrecacheSound(SOUND_JEBUS);
	PrecacheSound(SOUND_CHARGECOACH);
	PrecacheSound(SOUND_IDD_ACTIVATE);
	PrecacheSound(SOUND_IDD_DEACTIVATE);
	PrecacheSound(SOUND_NINJA_ACTIVATE);
	PrecacheSound(SOUND_WARP);
	PrecacheSound(SOUND_WARP_LIFE);
	PrecacheSound(SOUND_NICK_HEAL);
	PrecacheSound(SOUND_NICK_RESURRECT);
	PrecacheSound(SOUND_NICK_REVIVE);
	PrecacheSound(SOUND_NICK_LIFESTEAL_HIT);
	PrecacheSound(SOUND_COACH_CHARGE_HIT);
	PrecacheSound(SOUND_COACH_CHARGE1);
	PrecacheSound(SOUND_COACH_CHARGE2);
	PrecacheSound(SOUND_COACH_CHARGE3);
	PrecacheSound(SOUND_HOOKGRAB);
	PrecacheSound(SOUND_HOOKRELEASE);
	PrecacheSound(SOUND_SUITCHARGED);
	PrecacheSound(SOUND_BEEP);
	PrecacheSound(SOUND_ZAP1);
	PrecacheSound(SOUND_ZAP2);
	PrecacheSound(SOUND_ZAP3);
	//Infected Sounds
	PrecacheSound(SOUND_JOCKEYPEE);
	PrecacheSound(SOUND_BOOMER_EXPLODE);
	for(new i=0; i < sizeof(SOUND_BOOMER_THROW); i++)
		PrecacheSound(SOUND_BOOMER_THROW[i]);
	PrecacheSound(SOUND_EXPLODE);
	for(new i=0; i < sizeof(SOUND_ZOMBIE_SLASHES); i++)
		PrecacheSound(SOUND_ZOMBIE_SLASHES[i]);
	for(new i=0; i < sizeof(SOUND_WING_FLAP); i++)
		PrecacheSound(SOUND_WING_FLAP[i]);
		
		
	//Announcer Sounds
	PrecacheSound(SOUND_GETITON);
	PrecacheSound(SOUND_1KILL);
	PrecacheSound(SOUND_2KILLS);
	PrecacheSound(SOUND_3KILLS);
	PrecacheSound(SOUND_4KILLS);
	PrecacheSound(SOUND_5KILLS);
	PrecacheSound(SOUND_6KILLS);
	PrecacheSound(SOUND_7KILLS);
	PrecacheSound(SOUND_8KILLS);
	PrecacheSound(SOUND_9KILLS);
	PrecacheSound(SOUND_10KILLS);
	PrecacheSound(SOUND_11KILLS);
	PrecacheSound(SOUND_12KILLS);
	PrecacheSound(SOUND_13KILLS);
	PrecacheSound(SOUND_14KILLS);
	PrecacheSound(SOUND_15KILLS);
	PrecacheSound(SOUND_16KILLS);
	PrecacheSound(SOUND_HEADSHOT1);
	PrecacheSound(SOUND_HEADSHOT2);
	PrecacheSound(SOUND_HEADSHOT3);
}

PrecacheAllTextures()
{
	PrecacheModel("particle/particle_smokegrenade1.vmt");
	
	//Precache Sprites
	g_iSprite_Laser			= PrecacheModel("materials/sprites/laserbeam.vmt");	
	g_iSprite_Halo 			= PrecacheModel("materials/dev/halo_add_to_screen.vmt");
	g_iSprite_SmokerTongue 	= PrecacheModel("materials/particle/smoker_tongue_beam.vmt");
	g_iSprite_Arrow 		= PrecacheModel("materials/sprites/640_pain_up.vmt");
	
	g_iSprite_AmmoBox 		= PrecacheModel("materials/vgui/achievements/ach_deploy_ammo_upgrade.vmt");		//REPLACE
	
	//XP Sprtes//
	g_iSprite_1XP 			= PrecacheModel("materials/xp_sprites/1xp.vmt");
	g_iSprite_5XP_HS 		= PrecacheModel("materials/xp_sprites/5xp_hs.vmt");
	g_iSprite_25XP 			= PrecacheModel("materials/xp_sprites/25xp.vmt");
	g_iSprite_50XP 			= PrecacheModel("materials/xp_sprites/50xp.vmt");
	g_iSprite_75XP_HS 		= PrecacheModel("materials/xp_sprites/75xp_hs.vmt");
	g_iSprite_100XP 		= PrecacheModel("materials/xp_sprites/100xp.vmt");
	g_iSprite_150XP 		= PrecacheModel("materials/xp_sprites/150xp.vmt");
	g_iSprite_250XP 		= PrecacheModel("materials/xp_sprites/250xp.vmt");
	g_iSprite_250XP_Team 	= PrecacheModel("materials/xp_sprites/250xp_team.vmt");
	g_iSprite_350XP 		= PrecacheModel("materials/xp_sprites/350xp.vmt");
	//Team/Bill
	g_iSprite_10XP_Bill 	= PrecacheModel("materials/xp_sprites/10xp_bill.vmt");
	g_iSprite_20XP_Bill 	= PrecacheModel("materials/xp_sprites/20xp_bill.vmt");
	g_iSprite_30XP_Bill 	= PrecacheModel("materials/xp_sprites/30xp_bill.vmt");
	g_iSprite_40XP_Bill 	= PrecacheModel("materials/xp_sprites/40xp_bill.vmt");
	g_iSprite_50XP_Bill 	= PrecacheModel("materials/xp_sprites/50xp_bill.vmt");
	//Special Infected
	g_iSprite_3XP_SI 		= PrecacheModel("materials/xp_sprites/3xp_si.vmt");
	g_iSprite_10XP_SI 		= PrecacheModel("materials/xp_sprites/10xp_si.vmt");
	g_iSprite_15XP_SI 		= PrecacheModel("materials/xp_sprites/15xp_si.vmt");
	g_iSprite_25XP_SI 		= PrecacheModel("materials/xp_sprites/25xp_si.vmt");
	g_iSprite_50XP_SI 		= PrecacheModel("materials/xp_sprites/50xp_si.vmt");
	g_iSprite_200XP_SI 		= PrecacheModel("materials/xp_sprites/200xp_si.vmt");
	g_iSprite_500XP_SI 		= PrecacheModel("materials/xp_sprites/500xp_si.vmt");
}

PrecacheAllModels()
{
	PrecacheLockedWeaponModels();
	
	if (!IsModelPrecached("models/props_unique/spawn_apartment/coffeeammo.mdl"))
		PrecacheModel("models/props_unique/spawn_apartment/coffeeammo.mdl", true);
	if (!IsModelPrecached("models/w_models/weapons/w_eq_pipebomb.mdl"))
		PrecacheModel("models/w_models/weapons/w_eq_pipebomb.mdl", true);
	if(!IsModelPrecached("models/w_models/weapons/50cal.mdl"))
		PrecacheModel("models/w_models/weapons/50cal.mdl", true);	//Mounted Machine Gun
	if(!IsModelPrecached("models/w_models/weapons/w_minigun.mdl"))
		PrecacheModel("models/w_models/weapons/w_minigun.mdl", true);
	
	if(!IsModelPrecached("models/survivors/survivor_namvet.mdl"))
		PrecacheModel("models/survivors/survivor_namvet.mdl", true);	//Bill
	if(!IsModelPrecached("models/survivors/survivor_biker.mdl"))
		PrecacheModel("models/survivors/survivor_biker.mdl", true);	//Francis
	if(!IsModelPrecached("models/survivors/survivor_manager.mdl"))
		PrecacheModel("models/survivors/survivor_manager.mdl", true);	//Louis
	if(!IsModelPrecached("models/survivors/survivor_teenangst.mdl"))
		PrecacheModel("models/survivors/survivor_teenangst.mdl", true);	//Zoey
		
	if(!IsModelPrecached("models/survivors/survivor_producer.mdl"))
		PrecacheModel("models/survivors/survivor_producer.mdl", true);	//Rochelle
	if(!IsModelPrecached("models/survivors/survivor_coach.mdl"))
		PrecacheModel("models/survivors/survivor_coach.mdl", true);	//Coach
	if(!IsModelPrecached("models/survivors/survivor_mechanic.mdl"))
		PrecacheModel("models/survivors/survivor_mechanic.mdl", true);	//Ellis
	if(!IsModelPrecached("models/survivors/survivor_gambler.mdl"))
		PrecacheModel("models/survivors/survivor_gambler.mdl", true);	//Nick

	//Precache Uncommon Infected Models
	if(!IsModelPrecached("models/infected/witch.mdl"))
		PrecacheModel("models/infected/witch.mdl", true);
	
	if(!IsModelPrecached("models/infected/common_male_ceda.mdl"))
		PrecacheModel("models/infected/common_male_ceda.mdl", true);
	if(!IsModelPrecached("models/infected/common_male_clown.mdl"))
		PrecacheModel("models/infected/common_male_clown.mdl", true);
	if(!IsModelPrecached("models/infected/common_male_roadcrew.mdl"))
		PrecacheModel("models/infected/common_male_roadcrew.mdl", true);
	if(!IsModelPrecached("models/infected/common_male_mud.mdl"))
		PrecacheModel("models/infected/common_male_mud.mdl", true);
	if(!IsModelPrecached("models/infected/common_male_riot.mdl"))
		PrecacheModel("models/infected/common_male_riot.mdl", true);
	if(!IsModelPrecached("models/infected/common_male_jimmy.mdl"))
		PrecacheModel("models/infected/common_male_jimmy.mdl", true);
	
	if(!IsModelPrecached("models/infected/common_female_tanktop_jeans.mdl"))
		PrecacheModel("models/infected/common_female_tanktop_jeans.mdl", true);
	if(!IsModelPrecached("models/infected/common_male_dressshirt_jeans.mdl"))
		PrecacheModel("models/infected/common_male_dressshirt_jeans.mdl", true);
	if(!IsModelPrecached("models/infected/common_female_tshirt_skirt.mdl"))
		PrecacheModel("models/infected/common_female_tshirt_skirt.mdl", true);
	if(!IsModelPrecached("models/infected/common_male_polo_jeans.mdl"))
		PrecacheModel("models/infected/common_male_polo_jeans.mdl", true);
	if(!IsModelPrecached("models/infected/common_male_tanktop_jeans.mdl"))
		PrecacheModel("models/infected/common_male_tanktop_jeans.mdl", true);
	if(!IsModelPrecached("models/infected/common_male_tanktop_overalls.mdl"))
		PrecacheModel("models/infected/common_male_tanktop_overalls.mdl", true);
	if(!IsModelPrecached("models/infected/common_male_tshirt_cargos.mdl"))
		PrecacheModel("models/infected/common_male_tshirt_cargos.mdl", true);
	
}

PrecacheLockedWeaponModels()	//Precache the locked weapon models
{
	//CS Weapons
	//World Models
	if (!IsModelPrecached("models/w_models/weapons/w_rifle_sg552.mdl"))	
		PrecacheModel("models/w_models/weapons/w_rifle_sg552.mdl");
	if (!IsModelPrecached("models/w_models/weapons/w_smg_mp5.mdl"))
		PrecacheModel("models/w_models/weapons/w_smg_mp5.mdl");
	if (!IsModelPrecached("models/w_models/weapons/w_sniper_awp.mdl"))
		PrecacheModel("models/w_models/weapons/w_sniper_awp.mdl");
	if (!IsModelPrecached("models/w_models/weapons/w_sniper_scout.mdl"))
		PrecacheModel("models/w_models/weapons/w_sniper_scout.mdl");
	//View Models
	if (!IsModelPrecached("models/v_models/v_rif_sg552.mdl"))
		PrecacheModel("models/v_models/v_rif_sg552.mdl");
	if (!IsModelPrecached("models/v_models/v_smg_mp5.mdl"))
		PrecacheModel("models/v_models/v_smg_mp5.mdl");
	if (!IsModelPrecached("models/v_models/v_snip_awp.mdl"))
		PrecacheModel("models/v_models/v_snip_awp.mdl");
	if (!IsModelPrecached("models/v_models/v_snip_scout.mdl"))
		PrecacheModel("models/v_models/v_snip_scout.mdl");
	
	//Melee Weapons
	//World Models
	if (!IsModelPrecached("models/w_models/w_knife_t.mdl"))
		PrecacheModel("models/w_models/w_knife_t.mdl");
	// if (!IsModelPrecached("models/weapons/melee/w_riotshield.mdl"))
	// 	PrecacheModel("models/weapons/melee/w_riotshield.mdl");
	if (!IsModelPrecached("models/weapons/melee/w_bat.mdl"))
		PrecacheModel("models/weapons/melee/w_bat.mdl");
	if (!IsModelPrecached("models/props_junk/gnome.mdl"))
		PrecacheModel("models/props_junk/gnome.mdl");
	if (!IsModelPrecached("models/weapons/melee/w_golfclub.mdl"))
		PrecacheModel("models/weapons/melee/w_golfclub.mdl");
	//View Models
	if (!IsModelPrecached("models/v_models/v_knife_t.mdl"))
		PrecacheModel("models/v_models/v_knife_t.mdl");
	// if (!IsModelPrecached("models/weapons/melee/v_riotshield.mdl"))
	// 	PrecacheModel("models/weapons/melee/v_riotshield.mdl");
	if (!IsModelPrecached("models/weapons/melee/v_bat.mdl"))
		PrecacheModel("models/weapons/melee/v_bat.mdl");
	if (!IsModelPrecached("models/weapons/melee/v_gnome.mdl"))
		PrecacheModel("models/weapons/melee/v_gnome.mdl");
	if (!IsModelPrecached("models/weapons/melee/v_golfclub.mdl"))
		PrecacheModel("models/weapons/melee/v_golfclub.mdl");
}

Action:Timer_PrepareCSWeapons(Handle:timer, any:iClient)
{
	//Prepare the CounterStrike weapons for use by spawning and destroying
	new iWeapon = CreateEntityByName("weapon_rifle_sg552");
	DispatchSpawn(iWeapon);
	AcceptEntityInput(iWeapon, "Kill");
	iWeapon = CreateEntityByName("weapon_smg_mp5");
	DispatchSpawn(iWeapon);
	AcceptEntityInput(iWeapon, "Kill");
	iWeapon = CreateEntityByName("weapon_sniper_awp");
	DispatchSpawn(iWeapon);
	AcceptEntityInput(iWeapon, "Kill");
	iWeapon = CreateEntityByName("weapon_sniper_scout");
	DispatchSpawn(iWeapon);
	AcceptEntityInput(iWeapon, "Kill");
	
	//Reload the current map, so that the weapons works properly
	decl String:Map[64];
	GetCurrentMap(Map, sizeof(Map));
	ForceChangeLevel(Map, "Preparing the CS Weapons for first use");
	
	return Plugin_Stop;
}