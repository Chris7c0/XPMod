let announcementsData = [
    {
        title: `Bill's Heals and Bots Get Buffed`,
        text: `ChrisP<br>5-05-2023<br>
<b>Bill</b>
- Reworked Bills Healing:
    - Increased the healing speed significantly.
        - Heals 10 hp every 1 second, only to the closest survivor.
    - Added a 400 HP pool shared among all Bill's
    - Added a limit to the distance you can heal teammates (100 ft.)
    - Fixed bug where Bill could heal before confirming

<b>Nick</b>
- Removed Nick's ability to heal other Nicks with pistols preventing infinite heal loop.
- Added XP gain of +2xp with dual pistols and +3xp with magnum when healing a teammate with Nick's healing pistols ability.
- Fixed bug where Nick's healing pistols would still do team damage when new player buff is applied

<b>Misc Updates</b>
- Gave bots the New Player Buff (Low Level Buff)
    - Reduced the New Player Buff Damage Reduction down from 75% to 50%.
    - Increased the New Player Buff Speed from +15% to +50% so bots will be able to help and move around more quickly, and hopefully effectively
- Added automatic Prestige Point updating and XP reset in the database
    - Takes place on the 1st of every month at 4 am.
- Fixed Louis text for bile kits gained.
- Fixed an issue where the new player buff would give players health when hit from behind because of the common infected back damage reduction not being part of the event used to capture damage taken. This will always do at least 1 damage now.
`
    },
    {
        title: `Giving A Little Bit Back to Smoker and the NecroTanker`,
        text: `ChrisP<br>4-29-2023<br>
<b>Smoker</b>
- Added back Smoker's Tongue health to +200%.
- Lowered Smoker's teleport cooldown from 15s to 10s.
- Changed Smoker Teleport Max distance from 100ft to 150ft.

<b>Louis</b>
- Changed Louis Bind1 Warez to give +3 Bile Cleansing Kits down from +5.
- Lowered Louis Warez Im Feeling Lucky max item loss from -5 to -3 items.

<b>NecroTanker</b>
- NecroTanker increased starting health from 6660 to 10000.
- NecroTanker increased mana gained from 30 to 40 for survivor punches.

<b>Misc Changes</b>
- Increased the disconnected ban player list from 100 to 500 players.
`
    },
    {
        title: `Rochelle's "Final" Tweaks and Smoker Re-Re-Balancing`,
        text: `ChrisP<br>4-21-2023<br>
<b>Rochelle</b>
- Snipers
    - Scout
        - Max stacks reduced from 10 to 8
        - Damage gained from headshots is percentage based on stacks, can 1 shot chargers with headshots after a few stacks.
    - AWP
        - Base damage changed to +85% per level maxing out at 603 damage per shot.
- Rochelle's Rope changed to have smaller lifetime but regenerate over time to prevent rushing and allow continuous use over long games.

<b>Smoker</b>
- Tongue changes
    - Range increased from +75% to 100%
    - Healing only works while choking a victim
- Doppelganger no longer spawns tiny clowns, instead big clowns and a really big Jimmy Gibbs (JumboJimmy)
- Removed Bind 2 Electrocution screen shake. It no longer blocks jumping.
    - Added a limit of 150ft to the range of the chained electrocution.
- Bind 1 Smoke Cloud only activates if not visible to survivors (cannot be used to escape) and only if beyond smoke cloud size distance away.
- Added a 30 second global wait period for smoker Bind 1 before it can be used, triggered by the opening of the safe room door.
- Teleport max range reduced from 150ft to 100ft (maybe less), and set cooldown to 10 seconds.
`
    },
    {
        title: `Rochelle's Snipers Reworked At Last`,
        text: `ChrisP<br>4-15-2023<br>
<b>Rochelle</b>
- Snipers
    - Ruger
        - Stacks up to 100, 10 stacks for SI, 2 stacks for Tanks, 1 stack for ci
        - +5% damage per stack, -15 stacks every infected miss
    - Scout
        - Headshot counter lowered to 10
        - Damage increased to 75% base damage and +35 damage (not %) per scout headshot stack.
    - AWP
        - Damage increased from 40% to 45%
        - SI kills charge meter up (3 SI for full charge), after activating it reloads with only 1 bullet, does 2000 dmg.
    - H & K remains untouched
- Lowered Ninja Escape chance from 25% to 15%
- Increased Ninja Rope length from 200ft to 300ft.
- Lowered Shadow Ninja speed from +50% to +30% speed increase.

<b>Hunter</b>
- Added a timer to temporarily override the blood Lust hint text with the pounce distance hint text so players can see pounce distance.
`
    },
    {
        title: `I was blind, and now I can see! More Balance Changes`,
        text: `ChrisP<br>2-28-2023<br>
<b>Louis</b>
- Drastically improved Louis Dash Teleport.
    - Changed from 5 to 3 charges, but increased recharge rate by 5 seconds.
    - Heavily reduced movement speed penalty on charge and reduced the blinding effect.
- Lowered XMR prices across the board, also reduced starting XMR a little.

<b>Hunter</b>
- Reduced blood lust speed per stage from 60 to 35%.
- Fixed Bug where Hunter Bind 1 would not work if Hunter dies.

<b>Smoker</b>
- Removed Smoker Tar Fingers ability.
- Reduced Smokers Health Regeneration by half.

<b>Tanks</b>
<b>Fire Tank</b>
- Increased speed from damage from +25% to +20% base, when taking damage +25% changed to +50% speed. +70% speed total maxed out at 0 health.

<b>NecroTanker</b>
- No longer gains HP from SI kills.

<b>Misc and bug fixes</b>
- Fixed Bug where Hunter Bind 1 would not work if Hunter dies.
- Fixed a new user creation error bug.
- Fixed bug where Vampiric Tank could heal off SI.
`
    },
    {
        title: `Hunter Reworked, Finally`,
        text: `ChrisP<br>12-01-2022<br>
<b>Coach</b>
- Lowered Coach's Wrecking Ball health from +50hp to +25hp, setting his max health to 225hp from 250hp.
- Removed stacking from Coach's Team Health Bonus for Lead by Example skill.
- Changed Coaches Bind2 Jet Pack to have a smaller fuel pack, but it now regenerates over time.
- Updated Coach's Strong Arm (Jet Pack) menu.

<b>Hunter</b>
- Reworked Blood Lust Ability for Hunter to match the new skills. Added Primary attack dismount.
- Added Visibility to survivors meter gain for Blood Lust.
- Increased hunter cloaking while not moving to 95% invisible
- Updated Hunter Menu to match current abilities. Added +250 HP to the Kill-meleon ability.
- Adding a check if player moved for the blood lust meter gain when close to survivors.
- Added Hunter Bind 1, Immobilization Area.
- Added a minimum distance for hunter bind 1.  Added an activation attempt cooldown for bind1.
- Implemented Hunter invisibility based on blood lust +25% per stage. Rewrote all of the hunter stealth rendering and glow code. Changed Killmeleon to always hide the glow of the hunter, even while not shredding victim.
- Lowered Hunter Blood Lust movement speed from +75% per stage to +60% per stage.
- Added checks for empty vector in Hunter bind 1 survivor proximity check.
- Added +5% per level base speed to hunters first talent.
- Added Blood Lust Meter gain on successful pounce lands. Added PrintToChat for Blood Lust stage change notifications.
- Added a 1 second pounce land cooldown before being able to dismount for hunter to prevent mis-click dismounts.

<b>Tanks
<b>Ice Tank</b>
- Reduced Ice Tank Slow Radius by 30%.
- Increased the Ice Tank victim freeze again cooldown after being frozen from 3 to 7 seconds.
- Added +5% to Ice Tank's Speed.

<b>NecroTanker</b>
- Increased mana cost for NecroTanker Boomer throw from 15 to 30.  -Increased the Boomer throw cooldown from 6 to 10 seconds.

<b>Misc and bug fixes</b>
- Added fix for bug where players were stuck with movement speed of immobility area.
`
    },
    {
        title: `Louis Balancing and Ellis Gets a Bone`,
        text: `ChrisP<br>11-11-2022<br>
<b>Louis</b>
- Removed Louis base movement speed buff.  Changed Max movement speed buff from +25% to +15%.
- Forced Louis remove laser on Player Use event, to prevent player from getting lasers on weapons that were already picked up from the world.
- Removed Medkit drops from Neurosurgeon Skill.
- Changed Louis 9mm Augmentation skill to remove laser sights instead of add them.
- Many changes to Louis's Warez Station.
    - Increase Max HP from 10 to 25 in warez
    - Lower ScreenShake in warez to 25% from 50%
    - Change to 5 cleansing kits in warez
    - Removed self res from warez
    - Lowered Im feeling lucky self res from +10 to +3
    - Added 1 to 5 Random Equipped Item Loss as possible I'm feeling lucky
    - Increased Electrocution damage from 30 to 50
    - Added Deadly Electrocution 99 damage

<b>Ellis</b>
- Added Self Revive Kit for Ellis and when he uses self revive kit, he gains +1 Adrenaline.

<b>Misc and bug fixes</b>
- Changed all the BanClients to be KickClient to allow for users to be unbanned just by editing the database.
- Added ability for Admins to ban people that have already left the server through a ban disconnected players menu.
`
    },
    {
        title: `Flaunt it! New Prestige System`,
        text: `ChrisP<br>2-28-2022<br>
<b>Misc and bug fixes</b>
- Added the ability to force XP updates to players in the servers from the database using the push_update_from_db attribute.
- Added Prestige Points functionality to the player in game name tags.
- Added Prestige Points to database query.
- Added kick functionality for any player that changes their name while in the server.
- Added ability for XP Saving to be disabled for high XP players on specified servers, such as custom map or game mode servers.
- Added automatic version incrementing script when compiling XPMod.
- Forced a hard cap of 10000 XP gained for Survivor Damage reward at the end of the round bonus.
- Added prevention for getting massive amount of XP from death animation loop stuck Tanks. Added prevention for death animation loop stuck Tanks.
- Fixed bug in fire damage check on Ice Tank when attacker is using a melee weapon.
`
    },
    {
        title: `Ice Tank and Smoker Nerfs With a Side of Bug Fixes`,
        text: `ChrisP<br>2-03-2022<br>
<b>Ice Tank</b>
- Increased direct fire damage from molotovs from 216 to 350 per tick.
- Lowered HP from 15000 to 14000, also lowers the reserve life pool.
- Added 1.5x multiplier from Ellis Bind 2 or Incendiary Round damage.
    - Added HandleFireDamageVictimIceTank to handle various types of Fire Damage.

<b>Smoker Bind 1</b>
- Nerfed radius, duration, time gained per survivor, health regeneration for infected

<b>Misc and bug fixes</b>
- Added checks for Hunter class selection for lunge talents.
- Fixed max value for calculating the value of damage from hunter pounce.
- Fixed bug where NecroTanker Boomer rock would not spawn CI.
- Added entity check before setting shotgun next attack.
- Added client check on checking if smoker is stuck after teleport.
- Added entity check for poop bombs.
- Added entity prop check for poop bombs.
- Removed the TIMER_FLAG_NO_MAPCHANGE from a timer with a global handle associated to it to stop invalid handle errors.
`
    },
    {
        title: `Smoker Finished, ACS Rewrite, Balancing, and Bug Fixes`,
        text: `ChrisP<br>11-14-2021<br>
Another large update. This one focuses on finishing the Smoker, rewriting my old ACS plugin, modifying and balancing abilities, and fixing various bugs. Hunter rework has begun.

<b>Smoker</b>
- Completely reworked Smoker Bind 1 Smoke Cloud changing it from slowing and blinding players to spawning and converting CI to Enhanced CI with 3 stages of intensity.
- Added Smoker Doppelganger damage detection.
    - If doppelganger is shot then it will spawn 5 really small enhanced clowns.
    - Added a fade effect on doppelganger spawn that will only register damage after the fade in is completed.
    - Changed Doppelganger clones max to 2 and regeneration to 30 seconds.
- Reworked the smoker teleport to not use hardcoded ceilings for every map.
    - It now checks the m_WorldMaxs and end point delta as well as TR_PointOutsideWorld plus a small offset.
- Made Smoker's Tar Fingers blind players faster.
- Removed Smoker Health boost putting him back at the default 250 HP from 270 HP.
- Fixed bug where Smoker bind 1 could do more damage than the survivor has and could instant kill them.
- Added variable reset on death and talent load for Smoker to fix bug where it thinks the player is choking a victim, but they really aren't.
- Added a 3 second delay after leaving smoker smoke cloud until movement is restored to normal.
- Added a few mitigation methods to lessen bots attacking a smoke cloud smoker.
- Added fail safe checks in events to return smoker from smoke cloud form.
- Added on game frame checks while in smoke cloud form to convert movement type back to no clip, attempting to stop being killed while hit by nearby boomer charger or hunter actions.
- Added a timer that forces player out of smoke cloud limbo into normal form.
- Reorganized code around Electrocution for Smoker Bind 2.
- Removed Choke End event because its falsely triggered by smoker movement and the Tongue Release event appears to capture everything.
    - This fixes several bugs caused by wrong Smoker choking victim check results.
- Reduced Smoker Bind 1 particle count to make it more performant for lower end GPUs.

<b>Hunter</b>
- Changed Hunter's Lunge ability to be more dynamic and easier to control.
    - Added HOLD JUMP ability to glide in the air like a flying squirrel.
    - Added HOLD ATTACK ability that will dash you forward considering your momentum and direction you are facing.
- Replaced Hunter's crouch timed damage bonus with a damage bonus reward for the distance a victim was pounced from.
- Fixed Hunter Life Stealing.
    - Still buggy while mounted on a survivor.
- Increased the speed of life steal to be 8 per level.
- Made the maximum health from life steal 1500 hp.

<b>Tanks</b>
- Fixed Tank Automatic Fire Tank selection damage loss check.
    - Now Tanks will take 1000 HP damage before automatic tank selection is applied.
- Rewrote the tanks passed or frustrated health percentage functionality to fix several bugs.
- Added a generic SetTanksTalentHealth function for all tanks to use when setting health.
- To fix multiple tanks rock type issues, created a new cleaner method for detecting the tank rock owners.

<b>Ice Tank</b>
- Changed Max Health from 20k to 16k.
- Made it so the health pool reserve is equal to his max health.
- Increased the cold slow aura radius, but decreased the amount of slow it does.
- Increased the health regeneration rate from 10 HP to 40 HP per tick.
- Each punch now resets the cold aura re-enable timer.
- Increased the cold aura disable after hit by 1 second.
- Increased the slowest possible Survivor speed from 20% to 25% while in cold aura.

<b>Vampiric Tank</b>
- Added a Stamina Meter for his flying and dash abilities.

<b>Louis</b>
- Raised Louis's Bind 2 Time Out duration from 30s to 60s.
- For Neurosurgeon, replaced the molotovs drops with adrenaline shot instead.
- Fixed Louis clip size overflow bug from ammo gained.
- Fixed bug where Louis kept his movement penalty on map change if dashed before map transition.
- Balance Changes for Louis.
    - Increased non-headshot damage penalty increased from -15% to -20% per level, putting Louis at -50% non-hs damage at max level.
    - Louis speed lowered to 1% per talent level.
    - Changes to Pills Here talent: Lowered pill health to only heal 40 HP.
        - 10% speed increase per pill stack.
        - 25% damage increase per pill stack.
        - 3 Stacks Max.
        - Increased duration of pills effect from 60 to 90 seconds.
    - Increased louis stashed pills to 4.
    - Lowered Louis's clip ammo gained for CI from 25 to 15 and for SI 75 to 50.

<b>Ellis</b>
- Lowered Ellis's ROF to prevent fire rate issues. To counteract this:
    - Increased Ellis's overconfidence damage for adrenaline from 25% to 30%.
    - Increased Ellis's overconfidence damage for within 40% of max hp from 25% to 30%.
- Fixed Molotov damage bug while Ellis is above max HP.
- Fixed health resetting while taking a shot or pills by adding a way of storing temp health outside of the adrenaline and pill use events.
- Added a cap to max temp health Ellis can gain.
- Added extra adrenaline to Ellis when he spawns.
- Fixed bug where Bill healing Ellis gave actual health instead of temp health.

<b>Coach</b>
- Increased crouch healing to be 1 health every half second.
- Added a requirement to be on the ground to do crouch healing.
- Fixed health stacks to not infinitely stack when a user leaves and connects back to the server.

<b>Bill</b>
- Rewrote Bill's team healing code.
- Bill now heals closest ally instead of a random one and heals for 5 HP every 4 seconds.

<b>Misc Changes and Bug Fixes</b>
- Fixed bug where Nick or Louis can get stuck while using a first aid kit and consuming it at the same time.
- Added XPMod DebugMode for testing that continually kills CI and bot SI.
- Added RunCloseProximityWeaponCleanUp function to remove all entities that are too close to each other fixing server performance issues when this is the case.
    - These checks are run whenever a player picks up X number of weapons that trigger a laser sight upgrade.
- Updated the XPMod chat advertisements to be simpler.
- Found a way to attach TempEnts to other dummy entities as well as existing ones such as players.
- Wrote a CreateDummyEntity function that can be used to attached TempEnts to.
- Changed Rochelle's Ninja Rope to use attachments instead of the destroying and recreating method.
- Fixed GetLocationVectorInfrontOfClient function to use m_angRotation instead of EyeAngles for consistent results.
- Rewrote all survivors set max health for talents to be used in other locations of the code.
- Fixed Health when going idle, getting rescued and going taking over for a bot.
- Added some helper functions for SpawnInfected file.
- Added an entity property tracking system.
- Added FindClosestSurvivor and IsIncap helper functions.
- Added a fix for Nick's pistol swapping duplicates.
- Added the ability to remove the particle effect from the XPMod SpawnInfected functions for performance impacting situations.

<b>Automatic Campaign Switcher (ACS) Plugin</b>
- Rewrote most of the code to be more generic and reusable.
- Started using OnPZEndGamePanelMsg as a cleaner method for most of the end map triggers.
- Updated all the code to the new Syntax.
- Separated out the ACS code into smaller more manageable files.
- Fixed a number of bugs.
- Added Survival Map rotation.
- Added file IO for storing default maps and getting map info from a configurable map list file.
    - Updated the new MapNames with every default L4d2 map.
    - Removed the OldMapNames.
    - Added support for comments to the config file.
    - Added a description and instructions to be generated with new config file.
    - Added Maps Listing in console output to help with configuring custom maps.
    - Added automatic detection of modifications to the Map List config file.
        - Update the map list array on each map change.
    - Set the ACS Map list file location to be in the SourceMod configs folder.
- Combined all map list arrays into one map list array of arrays that contains everything.
- Added a start and end range that changes based on the current game mode to enable only looking through needed items.
`
    },
    {
        title: `Smoker Rework, Balance Changes, and Bug Fixes`,
        text: `ChrisP<br>09-25-2021<br>
Large update that captures all of the changes over the last couple of months.

<b>Smoker</b>
- Changed Smoker's health to 270 HP.
- Created every ability for Smoker's new Talent 1 Rapid Cell Division.
    - Added Health Regeneration 60 HP per second.
    - Changed max pull rate to +150%.
    - Changed max tongue fly speed to +200%.
    - Changed Smoker tongue reach to +75%.
    - Changed tongue health to +200%.
    - Changed max ability cooldown 12 seconds instead of 10 seconds.
- Added Smoker Dismount ability.
- Added Smoke Screen to the smoker, activated by pressing WALK while choking a victim.
- Added glow removal of victim while being choked.
- Added cloaking to smoker while grabbing a victim with his tongue.
- Fully implemented Smoker Cloak Toggling while choking a victim.
- Added toggle cloaking while choking a victim.
- Made Smoker Teleport and Smoker Doppelganger ray traces not hit clients.
- Added Doppelganger clones for Smoker.
- Added button inputs that enable smoker teleport smoker dismount and smoker doppelganger.
- Added Smoker Bind 1, Smoke Cloud:
    - 20 second cap on duration.
    - 1 minute cooldown (individual).
    - 8 second base duration.
    - .3 survivor player duration gain.
    - .1 survivor bot duration gain.
    - Tweaked the controls to not use angles.
    - Slowed players in smoke to  a fixed 0.33 speed.
- Added Tar Fingers to Smoker abilities. Progressively blinds players with each scratch.
- Fixed bug with bots being stuck in smoker's death cloud.
- Fixed bug where smoker would instantly release victim if primary attack was held.
- Cleaned up a lot of the old Smoker code.
- Updated Smoker's menu to reflect all of his new class abilities.

<b>Fire Tank</b>
- Fixed Tank ignition for XPMod ignite.
- Decreased burn duration from 30 seconds to 15 seconds.
- Changed Fire Tank's Fire Punch cooldown to 5 seconds, making it 5 second cooldown + 5 seconds to charge.

<b>Ice Tank</b>
- Doubled the ice tank rock freeze radius.
- Increased the Ice Tank Rock Direct hit duration to 10 seconds.
- Changed Unfreeze to only allow unfreezing if hit by SI, not CI or other forms of damage.
- Added cold aura that slows survivors down if they get near the Ice Tank
- Fixed bug where Ice Tank Cold Aura would remain on survivors after Ice Tank's death.

<b>NecroTanker</b>
- Buffed speed to +15% from 10%.

<b>Vampiric Tank</b>
- Buffed speed to +30% from 20%.

<b>Ellis</b>
- Reworked Ellis's Talents to make them easier to understand by combining same buffs into only one talent each.
- Reduced Ellis's fire rate from +70% to +30%.
- Reduced Ellis's speed from +55% max to +40% max.
- Decreased Ellis's bind 2 from 30 seconds to 15 seconds.
- Lowered fire rate to be +25%.
- Lowered reload speed from +90% to +75% making it more believable, but still really fast.
- Increased Ellis's Max health from 85HP to 90HP.
- Increased Ellis's overconfidence buff to be within 40 HP of max health so when hes above 50HP he gets the overconfidence buff now.
- Consolidated Ellis clip size code into one function.

<b>Nick</b>
- Restructured Nick's bind 1 code to allow for automatic conditionally triggered re-rolls.
- Made Nick's Rambo reroll if player is incap or grappled.
- Changed some of the gambles for Nick's bind 1.
- Changed Nick bind 1 that gives bind 2s to be only once per round.
- Fixed bug where molotovs would Life Transfer with Nick.

<b>Louis</b>
- Fixed bug in Louis Bind 2 where the exploit menu could be used while dead.
- Changed prices of Louis exploitz.

<b>Misc Changes and Bug Fixes</b>
- A round of bug fixes fixing logged errors.
- Fixed Bug in SetPlayerHealth that the last call wouldn't deliver the killing damage.
- Fixed Incendiary ammo in equipment load out.
- Fixed error in Rochelle's silent sorrow headshot counter.
- Added PrintToChat notification for SilentSorrow headshots.
- Removed debug chat spam and other chat messages that shouldn't be received for Louis and Nick by checking client team.
- Changed GiveEveryWeaponToSurvivor to use the spawn system instead of using cheat commands and replacing weapons.
- Reduced the number of items that GiveEveryWeaponToSurvivor gives, for performance reasons.
- Added support for spawning melee weapons into the world using spawn system.
- Added a cooldown timer to GiveAlotOfWeapons to prevent it from flooding the servers.
- Changed GiveEveryWeaponToSurvivor to give more explosives and not grenade launcher.
- Fixed bug where hunter poison could poison the next round.
- Added reserved ammo to the spawned item primary weapons that was empty otherwise.
- Updated some of the Website and Download menu items to have instructions instead of the actual website, because the L4D2 in game browser is complete garbage.
- Added KillEntitySafely function for removing entities safely.
- Added Scriptable commands.
- Added the start of a scriptable bot goal system.
- Added GetLookAtAnglesFromPoints function.
- Added a GetCrosshairPosition function.
- Created a generic CreateSmokeParticle function.
- Separated out Render Color and Glow into a separate SP file.
- Separated out the code for each class for all smoker tongue and choke events.
- Made CreatePlayerClone support animation sequences as well as animation names.
- Added team switching through xpm menu for Versus Survival.
- Talent menu updates.
`
    },
    {
        title: `New XPMod Site`,
        text: `ChrisP<br>08-27-2021<br>
The XPMod website has been completely redone to bring it closer to what a modern page looks like.

I learned how to use Blender and have rendered high resolution character models for each Survivor and Special Infected class. These can be seen on the Character Bio Pages in the Talents (CEDA Files) section of the site.

I have tested the site across a ton of browsers and its now completely responsive. This means the site should work well on phones or tablets also. Just don't try to use Internet Explorer!

Thank you to <b>VorTexas</b> for a lot of the the photograph images used in the Character Selection pages in the Talents section.

On the actual mod, I have done several balance changes, added a new Ice Tank ability, and nearly finished the Smoker. More updates to come soon that will outline the details of all the changes.`
    },
    {
        title: `Ellis, Louis, and Coach Changes`,
        text: `ChrisP<br>07-04-2021<br>
<b>Ellis</b>

- Reduced Ellis base Max Health to 85 HP.
- Made all his health temporary.
- Increased firerate from +60% to +70%.
- Increased overconfidence activation health range from 20hp to 30hp.
- Increased the damage for overconfidence from 20% to 25%.
- Fixed Molotov from Tank spawns to make it consistent.
-  Added ability to gain and store molotovs for every tank that spawns
    - This works even if you already have an explosive item.
    - Capped Ellis's Molotov and Adrenaline stash to 5 for Tank spawns.
- Added adrenaline gain on tank spawn.
- Added ability to stash adrenaline and handled all the areas where this is needed.
- Fixed Adrenaline duration increase.
- Doubled adrenaline duration buff.
- Added adrenaline buffs +25hp +25 dmg while on adrenaline.
- Removed pill buffs, only adrenaline now.
- Cleaned up Ellis's menu text and rearranged Ellis's Menu Code.
- Rewrote Ellis's switch weapon code to use the new item index system.
- Fixed Ellis's weapon switching when he chooses the same weapon twice.
- Rewrote the code around Ellis's limit break to work reliably.
- Added talent confirmation checks for Ellis.

<b>Louis</b>

- Lowered HP from 150 to 125.
- Gave 4.2 starting XMR, but raised all prices by 5 XMR.
- Changed med hax from instant to 1 second.
- Lowered amount of XMR given from Neurosurgeon for 1% of SI kills to 3.0.
- Lowered LOUIS_STASHED_INVENTORY_MAX_PILLS to 3 stashed.
- Made his first aid kit converted pills go directly into his stash.
- Tripled stacking movement speed penalty after dashing (Time Dilation).
- Changed movement penalty time from 20 seconds to 15 seconds.
- Increased Louis's warez station speed to 5% and capped at 10%.

<b>Coach</b>

- Nerfed Coaches Health to 250 HP from 300 HP.
- Fixed bug in Coach's menu where Bull Rush level was shown as 0.
- Decreassed crouching health regen from 1 hp every 0.75 seconds to every 2 seconds.
- Coach's Rage Ability
    - Increased  cooldown from 1 minute to 3 minutes.
    - Added 15% speed decrease to Coach's rage while in cooldown.
    - Increased the speed while raging to +25%.
    - Increased the damage from +100 to +200 melee damage.
    - Fixed a bug where the speed boost would last all round.
    - Fixed a bug where the damage would not always apply.

<b>Misc Changes and Bug Fixes</b>

- Separated out several functions into new Health.sp file.
- Added 4 new helper functions for handling getting setting health and max health.
- Converted every health/max health get/set call to use the new functions.
- Replaced most Set Max Health calls with the new function call.
- Changed filename format to replace spaces with underscores in xpmstats log.
- Added server info in xpmstats log file.
- Changed in xpmstats log formatting to make more compact.


<b>Smoker and the rest of the Infected are the focus now.</b>`
    },
    {
        title: `Louis, Nick, Balance and Bug Fixes`,
        text: `ChrisP<br>06-18-2021<br>
<b>Louis</b>

- Removed the Preview on Louis's selection menu item. He has arrived!
    - Note: He will still be getting some more nerfs shortly.
- Added some global chat text to indicate all Louis Bind2 uses.
- Nerfed Time Dilation.
    - Increased charge regeneration time.
    - Increased blinding amount
    - Increased blinding duration
    - Increased movement penalty duration.
    - Added a new tunable parameter.
- Nerfed reload speed from a 75% to a 25% increase.
- Nerfed passive damage buff from +75% to +50%.
- Added non-headshot damage penalty in BOOM HEADSHOT, making headshots even more important for him.
- Updated Louis's Neurosurgeon ability to use the new item index system.
- Made performance optimizations for Neurosurgeon particle effects.

<b>Nick</b>

- Fixed Divine Intervention while grappled.
- Fixed bug with Nick healing himself instead of hurting himself with explosives when pistols are out.
- Updated Nick's weapon stashing for use with Rambo to use the new item index system.
- Fixed Nick's Rambo Gamble to work the full duration and return your weapon after Rambo Mode expires.
- Rewrote Nick Desperate Measures to fix a bug where the stacks never decreased.
- Added a function GetIncapOrDeadSurvivorCount to consistently set the proper values.
- Made Desperate Measures also decrease when defib was used and on player resurrection.

<b>Misc Changes and Bug Fixes</b>

- Lowered XPMod Tank Spawn HP from 50% to 33%.
- Removed Explosive Ammo from Equipment Menu.
- Added entity > 0 checks before all AcceptEntityInput Kill calls as a preventative crash measure.
- Rewrote the HandleFastAttackingClients function currently used for Rochelle and Ellis to be more readable, logical, and work more efficiently.
- Added all items to an item index system that can be used to check and get item/weapon types.
- And more stuff you probably don't care about.`
    },
    {
        title: `Louis' Bind2, Neurosurgery, and Misc Updates`,
        text: `ChrisP<br>05-25-2021<br>
<b>Louis</b>

- Added Louis' Bind 2, H3D Sh0P (Script Kiddie Exploitz Menu)
    - Added a "money" system that rewards player with XMR for headshots. This XMR can be used to for the following items.
    - Added Speed Hax that doubles movement speed for all survivors for a period.
    - Added Med Hax that makes revives, healing, defibs work instantly.
    - Added Nub Wipe ability that kills all CI currently spawned in.
    - Added Hak Target player select target menu system and the functionality to reverse players controls, spam their chat, and play random sounds for a period.
    - Added Hack the server, that slows time to 1/4th speed for everyone, giving most Survivors an advantage because they have long range weapons.
    - Added Time Out that disables infected binds for a period of time.
- Added Neurosurgery Talent functionality and menu.
    - % chance to get rewards for every headshot kill.
        - CI give equipment spawned on the victim
        - SI give XMR or another warez station
- Fixed bug with Louis giving pills or adrenaline while having stashed pills.

<b>Enhanced Common Infected (CI)</b>

- Added OnTakeDamage SDK Hook for CI damage handling to cap melee damage per hit to CI.
- Increased Enhanced CI HP for many of them.
- Made Spitter's Bind 1 (Bag of Spits) stronger across the board.

<b>Misc Changes and Bug Fixes</b>

- Added a spawning system for creating game item entities at any location in game.
- Created reverse target player controls functionality.  This is not only for movement keys, but its dynamically adjusted by the orientation that the player is facing.  This is for Louis's Hak Target now, and will likely be used for the Smoker later.
- Fixed bug where player could still choose a different Survivor after confirming.
- Attempted to fix Map Not Started error for Tank Rock entity errors.
- Removed bots from current round statistics, this was just for testing purposes.`
    },
    {
        title: `Statistics Panel, Louis Features, and Balance Changes`,
        text: `ChrisP<br>04-01-2021<br>
<b>Louis</b>

- Added PILLS HERE talent for Louis (not bind 2 yet, probably next).
- Touched up Louis's Talents Menus.
- Made Louis Bind 1 only work while not grappled or incap.
- Fixed bug with Louis Bind 1 only gives menu to the person who spawned it.
- Fixed bug with infinite Louis Bind 1's I'm feeling lucky.
- Stopped ScreenShake selection in Bind1 Warez Station if its already 0.
- Louis Warez Station Menu refinements.
- Added +3 Bile Cleansing Kits to Warez Station Menu.

<b>Admin Menu Panel</b>

- Added more functionality to the XPMod Admin Menu. Most of its there now.
- Added Griefing tools section to help undo griefers bs.
- Retrofit Resurrect for Griefing Undo Tools.
- Added Mute Player to Admin Menu.
- Added verification of SteamID for kicks and bans to XPMod admin menu.

<b>Tanks</b>

- Removed NecroTanker spawn tank chance.
- Removed NecroTanker punch spawn on incap players.
- Set Tank Frustration Meter to 90 seconds. 120 secs made it stop working.
- Vampiric Tank no longer life steals with objects.

<b>New Statistics Panel</b>

- Added multiple timed Statistics Panels on Confirmation.
- Removed replaced in-game-chat round stats.
- Added query top XPMod players functionality. Added this to a new Statistics Panel.
- Added Extras Menu option to show last round statistics panels on demand.

<b>Misc Changes & Bug Fixes</b>

- Added Bile Cleansing Kit system.
- Rewrote check client grappled code, should fix a lot of bugs.
- Added g_bIsClientDown to areas that it was missing to fix false incap issues.
- Rewrote Nicks Resurrect functionality.
- Made boomer chain reaction count for Boomer Attacker, which should fix bugs.
- Restructured Switch Player Team code for modularity.
- Another big round of bug fixing from error logs.
- Fixed memory leak with datapack handles not closed on reload.
- Checked and cleaned up all DataPacks handles and closehandles to prevent Memory Leaks.`
    },
    {
        title: `Added More to Louis and Balance Changes`,
        text: `ChrisP<br>03-16-2021<br>
- Added most of Louis's bind 1.  Creates a Warez Station that all survivors can use which lasts for 25 seconds.  Best get it while its hot.
- Added a Self Revive system.  This can be accessed via Louis Bind 1.  Eventually, other classes will be getting this later.
- Nerfed Coaches Screen Shake to be a 50% stackable reduction instead of complete removal from one Coach.  Added global chat message when screen shake is reduced.
- Added SetClientSpeed to trigger on talents load.  This is required when the loaded talents are delayed until after spawn.  This fixes Spitter bug where she constantly had phase shift speed after death.
- Added extra height to Spitter's bind 2 witch summon.  This should make it much more consistent and fix most if not all issues where the witch didn't spawn in.
- Changed Nick's Global Max Resurrections per round to 1.
- Fixed bug with everyone seeing nicks teammate incap message.
- Restructured all of the bind key press code. To support for new additions and make it A LOT easier to go through.
- Increased Enhanced CI Necro spawn chance to 50%.
- Added support for permanent bans in the xpmod database and xpmod sourcecode.
- Added Pausing, Kicking, and Permanent Banning to XPMod Admin menu. More to come soon.
- Added Debug logging support.
- Attempted to fix Load Talents on Change Team bug where talents wouldn't load on switch.
- Updated menus to support dynamically moving the menu down while dead as a survivor or spectating, allowing the player to see the menu, not having it blocked by UI elements.  This was painfully done for all menus.
- Redid all menu's to not call CloseHandle on global variable to fix server crashing bug under certain conditions.
- Removed the global menu handlers for every menu.
- Checked\Changed ACS for potential crash issues. Made advertising timer repeat and not on map change. Removed global handle for menu. Made the OpenVoteMenu the default option.`
    },
    {
        title: `Admin Updates and More`,
        text: `ChrisP<br>03-05-2021<br>
- Added Tank frustration into XPMod.
    - The frustration time is increase from the default 20 seconds to 120 seconds.
        - Speak up if you try it and feel this is too long or short.
    - Tanks will start to frustrate when they can't be seen by Survivors.
    - When the Tank is seen or taking damage, the timer will pause.
    - Punching a survivor will reset the frustration timer.
- Made menus more consistent and cleaned them up quite a bit...not perfect, but much better.
- Added several random bug fixes.
- Added a custom ban system.
    - Bans are now stored in a database instead of a file.
    - This adds temporary ban persistence across server crashes/restarts.
    - Restructured the previous code around this.
- Added confirmation to the Ban Me menu.
- Restructured a lot of old code to be a lot more organized and manageable.
- Some small tweaks for Enhanced CI as well as their spawn rate.
- Added the Pitchfork to the Buy Equipment Loadout options
- Started a Admin menu, however, its not enabled yet.  This will eventually have:
    - Auto Balance teams (based on player levels, maybe stats too...but probably not a first)
    - Switch specific players team
    - Pause game.  (To minimize damage from hackers and griefers)
    - Griefer damage undo controls.
    - Kick, ban, ban disconnected player via XPMod database.
    - Force Player Menu Popups
        - Like Help, Addon Download, Confirm Talents, etc.
- Replaced RemoveEdict with AcceptEntityInput Kill everywhere in XPMod. This is to prevent crashes.
- Redid the VictimHealthMeter to be ran OnGameFrame giving 100% accurate readings and updates for a few seconds after the victim was shot.`
    },
    {
        title: `Changes for Tanks, Louis, and Ellis`,
        text: `ChrisP<br>01-24-2021<br>
Pretty decent sized update was just loaded into the servers:
- A lot of bug fixes
- Louis's abilities got changed a bit
    - Temp movement penalty for his teleport
    - His talents were balanced to accommodate this.
    - You can read the in game menu for all the details
- Ellis had his damage fixed from a really old bug, that caused too much dmg.
    - His fire rate and damage was adjusted to try and balance it out the fix.
    - His tank spawn speed boost is now 5% per tank.
    - His SI kill speed boost is now capped at 20%.
- NecroTanker and Vamipiric Tank, got a speed boost.
- Increased Fire Tank's health to from 9k to 11k.
- Reduced XPMod Tank spawns (like Jockey Tanks) health to 1/3rd.
- Tanks now have a scaling HP system that changes their starting HP based on the combined alive XPMod player levels on the survivor team.
- Added a Ban Me option for players that join the game and want nothing to do with XPMod.
    - XPM Menu -> Extras -> Ban Me
    - Note, this is not persistent through server restarts yet.
- More behind the curtain items.

If you're unhappy with any of the updates here, then lets discuss it. I'm always happy to receive more feedback to make XPMod as good and balanced as possible.`
    },
    {
        title: `New Tanks, New Survivor, and More!`,
        text: `ChrisP<br>01-05-2021<br>
- Two new Tanks have been added, NecroTanker and Vampiric Tank.
- New Survivor added, Louis.
- Menu UI has been overhauled and made simpler to use.
- New database system has been created.
- Several major bugs have been fixed.
- Leveling is now automatic for Survivors.
- Applied some obvious balancing for existing characters.`
    },
    {
        title: `XPMod Lives Again!`,
        text: `ChrisP<br>12-05-2020<br>
I am working to fix the issues that have been accumulating from years of Left4Dead2 patches. There is one test server live now, but there will be more to come once everything is working better.

The Downloads Page has been updated to reflect a new XPMod Addon installation process thats now available inside of the Steam Workshop. Installation is much easier now with only 3 clicks and a relaunch, then you are good to go.

After all the issues have been fixed, we will be simplifying UI, balancing/adding characters, and improving XPMod based on your input. Please feel free to send us your feedback or suggestions.

Lastly, thank you to those who are still around and have stuck with XPMod for so many years!`
    },
]
