# Spitter Spit Buffs, Zoey Tweaks, and Code Audit
4-02-2026

**Spitter**
- Made repulsion spit continuously bounce players for 2 seconds instead of 1.
- Added continual repulsion pushing intervals.

**Zoey**
- Bind 1 now works while downed.
- Gains +1 MaxHP per Mop the Floor use. Increased Mop the Floor requirement to 5 CI hits.
- Made Mop the Floor only consume a charge per CI killed.

**Smoker**
- Only regens while choking a victim.
- Set Max HP to 325.

**NecroTanker**
- Disabled teleport while throwing Boomers.
- Fixed first incap hit not registering for mana and summons.

**Misc Changes**
- Updated SpawnInfected logic so spawned CI and UI are active and attack survivors right away.
- Survivor and Infected Menu code audit pass.
- Talent Menu character limit pass.
- Updated XP display formatting for players above level 30.
- Updated Help message to use chat hints instead of MOTD panel.

---

# Zoey Has Arrived! New Survivor With 6 Talents
3-25-2026

**Zoey - New Survivor**
- Talent 1: Resilient Resuscitation - Improved revive speed with common infected interruption immunity.
- Talent 2: Trigger Happy - Explosive pistol ammo with melee/pistol swapping. Always active.
- Talent 3: Survivor's Will - Mop the Floor stacking mechanic, 3 CI hits per stack.
- Talent 4: Sharing Is Caring - Splash healing from pills and adrenaline for nearby survivors. +2 extra med item stash slots. Does not apply to other Zoeys.
- Talent 5: Medical Expertise - Increased medkit holding speed to +25%.
- Talent 6: Instant Intervention - Sacrificial Aid grants a defibrillator kit and survivor resurrection. Visual healing circle ring on Bind 2. Ghost smoke visual effect.
- Changed dual pistols to single pistol for increased accuracy and SI damage.
- Removed friendly fire from Zoey.
- No melee weapons, pistol/melee swap available through Trigger Happy.

**Smoker**
- Increased starting Max HP from 250 to 350.
- Added +2 bonus damage while choking a victim.
- Increased health regeneration from 1 to 2 per frame.
- Increased max doppelgangers from 2 to 4, reduced cooldown from 30 seconds to 15 seconds.

**Louis**
- Increased movement speed penalty per dash from 5% to 10%.
- Reduced pills damage buff bonus from 20% to 15%.
- Limited pills + adrenaline option in Warez to 1 use per round.
- Prevented XMR farming before door opens and round starts.

**Misc Changes**
- Increased defib penalty from 25 to 50.
- Added automatic menu new line function for consistent panel alignment.
- Added cvar setting to prevent slow down when survivors are hurt.

---

# NecroTanker Rework, Charger and Jockey Buffs
3-20-2026

**NecroTanker**
- Added Teleport ability for 30 mana.
- Added Raining Blood hit chance (10% chance).
- Removed Summoning SI.
- Increased Summoning CI/UI Mob chance from 60% to 70%.
- Changed all CI Summons to CEDA to make fire less problematic.

**Charger**
- Increased health from 1200 to 1500.
- Reduced Uppercut charge time and cooldown by half (90 frames to 45, 30 seconds to 15).

**Jockey**
- Added new ability Tweakers Twitch.
- Increased health from 675 to 775.

**Nick**
- Changed Magnum damage from 325 to 375 per clip round.

**Boomer**
- Added Necrofeaster UI conversion mechanics for Common Infected during vomit on 3 survivors ability.

**Spitter**
- Updated Phase Shift activation mana requirements for Stealth Spitter.

**Misc Changes**
- Added tank info display when player selects a tank so they can glance abilities.
- Updated Stats Panels and Top XPMod Players display.
- Updated Loadout menu so it doesn't get cut off.

---

# Coach Reworked, Chainsaw Massacre, and Stats Tracking
3-14-2026

**Coach**
- Lowered Max Health from 225 to 200.
- Added a Louis style dash to Bull Rush.
- Added Chainsaw Massacre for Bind 2.
- Added melee execution for CI and SI below 30% HP.
- Added headshot bonuses for all weapons instead of just ones that can decapitate.
- Removed Jock Block. Now Jockey can move Coach at 20% movement speed instead of 0%.
- Modified Rage and Bull Rush to give one extra charge for dash.
- Changed Jetpack to use Spray n Pray instead of Strong Arm.
- Lowered Bind 2 HP regen from 2 to 1.

**New Statistics System**
- Implemented round statistics tracking with database updates for survivors and infected.
- Added personal player statistics tracking and display panel.
- Added top player leaderboard feature with SQL view and display panel.
- Added survivor and infected picks tracking with database integration.
- Added game mode and map tracking to picks.

**Misc Changes and Bug Fixes**
- Fix for Enhanced CI and Ice Tank Freeze being overwritten by movement speed abilities.
- Coach's lunge now prioritizes infected SI targets over CI.
- Refactored talent confirmation logic and state management.
- Fix for Bill's taunting bug while unconfirmed.
- Added XPMod Addon files for both the client and the server.

---

# Fire Tank Overhaul, Bill and Ellis Updates
3-05-2026

**Fire Tank**
- Increased HP from 11k to 14k.
- Added Fire Dash ability with slow health burn.
- Increased dash distance and lowered dash HP cost to 750.
- Changed Fire Punch to occur every 2 hits instead of by holding crouch.
- Fire punch activation threshold increased to 3 hits, no longer counts CI, SI, or incapped survivors.
- Increased starting speed from +30% to +70%.
- Added CI to CEDA UI conversion for Fire Tank.

**Bill**
- Added Support ability to Die Hard Talent.
- Changed taunt mechanics and cooldowns. Activation keys changed to Walk + Use.
- Made Taunt a global cooldown for all Bills.

**Ellis**
- Can now carry and starts with +1 Molotov.
- Bind 2 now gives +1 Molotov.
- Fixed weapon cycling giving the wrong ammo.
- Updated weapon pickup cooldown to 0.7 seconds.

**Misc Changes and Bug Fixes**
- Implemented auto-confirm feature for character selection with save per user.
- Implemented XP farming prevention on revive actions.
- Implemented ability impact damage immunity to prevent incorrect fall damage deaths.
- Added Instantly Refill All Survivors Ammo.
- Fix for XP not saving every round in Co-op.
- Removed exploit to refresh binds on disconnect/reconnect.
- Fix for Smoker's teleport in confined areas.
- Fix for Smoker smoke cloud in Versus Survival on certain maps.
- Fix for Bills infinite chase on a dead poop bomb.
- Added Spitter handler for lingering acid damage after death.

---

# Code Modernization, Balance Updates, and New Prestige Symbols
2-26-2026

**Code Modernization**
- Updated compiler to use spcomp64.
- Updated all strings, floats, and syntax to new SourcePawn style.
- Added #pragma newdecls required to enforce modern style for consistency.
- Removed a lot of commented out code.

**Bill**
- Balance update pass.
- Enhanced Inspirational Leadership talent to reduce screen shake by 25%.

**Louis**
- Balance update pass.

**Rochelle**
- Balance update pass.

**Misc Changes**
- Added new prestige symbols for top 10 players.
- Added cold aura ice smoke effect to players feet when affected by Ice Tanks cold aura.
- Updated all Tank Menus to fit in the limited L4D2 menu character limit.
- Added save user data on confirm talents, so equipment and abilities are saved even when the user crashes.
- Added BanMe command.
- Added ban duration and reason to the ban menu for Admins.
- Added developer mode functionality and related commands.

---

# Charger Earthquake Rework, Nick and Louis Rebalancing
10-14-2023

**Charger**
- Reworked Earthquake ability. Damage and effectiveness of the shock/knockdown is now scaled linearly with distance from the Charger.
- Players in a smaller radius are staggered, players in a larger radius take damage only.

**Nick**
- Lowered Desperate Measures damage increase per teammate down from +75% to +50%.
- Increased Magnum max clip size from 3 to 4.
- Magnum now gets +15% reload speed buff per infected hit on current clip.
- Added automatic firing pistols (not Magnum).
- Increased Magnum damage from +75% to +100% per level.
- Fixed Divine Intervention.

**Louis**
- Reduced critical headshot damage multiplier from 150% to 125% when laser sights are on.
- Reduced laser switch cooldown from 60 seconds to 5 seconds.
- Added automatic firing pistols.
- Added toggle between laser and no laser mode for SMGs (tap CROUCH + USE).
    - Laser On: Lower damage, lower mobility.
    - Laser Off: Higher damage, higher mobility.

**Ellis**
- Fixed auto-fire to work with all weapons other than snipers.
- Removed auto-fire for Sniper Rifles.

**Bill**
- M60 damage lowered from +125% to +100%.

**Jockey**
- Lowered lunge distance multiplier from 160% to 150%.

**Coach**
- Added Homerun ability to gain shotgun clip ammo for melee decapitations. +1 for CI, +10 for SI.

**Misc Changes**
- Set up AFK idle kicker to allow vote kicking vote immune players if AFK for more than 90 seconds. Lowered AFK kick threshold to 5 minutes.

---

# Ellis ROF Rework, Jockey Drag Race, and Ice Tank Ice Slide
5-20-2023

**Ellis**
- Reworked all abilities to increase Rate of Fire speed instead of Damage.
- Added automatic firing for pistols, snipers, and shotguns.
- Removed auto-fire for Sniper Rifles after testing.
- Removed melee weapons for Ellis.
- Removed healing from tank spawns.
- Lowered ammo gained from SI kills from +100 to +40.
- Lowered base rate of fire from +75% to +50% without adrenaline.

**Jockey**
- Added Drag Race ability.

**Ice Tank**
- Reduced healing start up from 5 seconds to 3 seconds.
- Added new ability: Hold [WALK] to activate Ice Slide. Move very fast at the cost of 1000 HP/second. Half HP lost while sliding is returned to the Health Pool. Take 3x damage while Ice Sliding. 10 second cooldown. Cold aura disabled while in use or in cooldown.

**Smoker**
- Increased base health from 250 to 350 HP.
- Bind 2 now instantly sets Max HP to 500 for the remainder of his life on use.

**Rochelle**
- Lowered Max HP from 150 to 125.
- Increased H&K (Military Rifle) damage from +40% to +100%.
- Fixed bug where mounted machine guns gave her hunting rifle stacks.

**Louis**
- Lowered body shot penalty from -100% to -50%, putting him at base L4D2 damage on body shots.
- Lowered Pills damage bonus from +25% to +20% per stack.
- Added speed to Hax the Server so Louis moves faster while everyone else is slowed.

**Bill**
- Changed Rifle Damage bonus from +20% to +30%.
- Changed M60 bonus damage from +100% to +125%.

**Coach**
- Fixed bug where AI bots could move Coach.
- Fixed bug where not confirming talents as Jockey then confirming on ride caused large Drag Race reward.

**Misc Changes**
- Added a DPS Meter for balance testing.
- Lowered New Player Speed buff from +50% to +40%, then to +25%.
- Increased Infected Ghost Speed from +75% to +100%.
- Added AFK timer that kicks players after 2 minutes of no movement.