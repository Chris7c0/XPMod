# Infected Talent Menu Audit

Audit of all infected class talent menus vs actual code functionality.
Each talent's menu description is compared line-by-line against the implementation.

**Legend:**
- MATCH = Menu text accurately reflects code
- MISMATCH = Menu text does not match code behavior
- VAGUE = Menu text is not specific enough to verify or is misleading
- MISSING = Code has functionality not mentioned in the menu

---

## SMOKER

### Talent 1: Rapid Cell Division
**Menu File:** `Menus/I/Menu_Smoker.sp` (EnvelopmentMenuDraw)
**Code File:** `Talents/I/Talents_Smoker.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `%d Max Health` (SMOKER_STARTING_MAX_HEALTH) | Sets max health to 350 (SMOKER_STARTING_MAX_HEALTH = 350) | MATCH |
| 2 | `Regenerate 60 HP per Second` | SMOKER_HEALTH_REGEN_PER_FRAME = 2, at 30fps = 60 HP/s | MATCH |
| 3 | `While Choking a Victim: +2 Dmg per Hit` | `DealDamage(iVictim, iAttacker, 2)` when choking and weapon is smoker_claw | MATCH |
| 4 | `While Choking a Victim: Can Move Slowly` | `SetEntityMoveType(iAttacker, MOVETYPE_ISOMETRIC)` on choke start | MATCH |
| 5 | `Reduced Tongue Ability Cooldown: -1 Second Every Three Levels` | Code: `SMOKER_DEFAULT_TONGUE_COOLDOWN(15) - (RoundToNearest(level / 3.0) * SMOKER_COOLDOWN_REDUCTION_EVERY_OTHER_LEVEL(1))` | MATCH |
| 6 | `While Alive as Smoker, All Smokers Receive: +10% Increased Tongue Range per Level` | CONVAR_SMOKER_TONGUE_RANGE_BUFF_PER_LEVEL = 75, default = 750. 75/750 = 10% per level | MATCH |
| 7 | `+20% Increased Tongue Travel Speed per Level` | CONVAR_SMOKER_TONGUE_FLY_SPEED_BUFF_PER_LEVEL = 200, default = 1000. 200/1000 = 20% | MATCH |
| 8 | `+15% Increased Tongue Drag Speed per Level` | CONVAR_SMOKER_TONGUE_DRAG_SPEED_BUFF_PER_LEVEL = 27, default = 175. 27/175 = 15.4% | MATCH (close enough) |
| 9 | `+20% Increased Tongue Strength per Level` | CONVAR_SMOKER_TONGUE_HEALTH_BUFF_PER_LEVEL = 20, default = 100. 20/100 = 20% | MATCH |

### Talent 2: Illusive Trickster
**Menu File:** `Menus/I/Menu_Smoker.sp` (NoxiousMenuDraw)
**Code File:** `Talents/I/Talents_Smoker.sp`, `Binds/Bind1/I/Bind1_Smoker.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `8.5% Invisibility per Lvl When Tonguing` | On tongue grab, `g_bSmokerIsCloaked` is set to true. Render transparency calculated in `RenderColorAndGlow.sp` uses talent level. | VAGUE - The 8.5% per level value needs verification in the render code; the cloaking is applied but the exact percentage per level depends on the render calculation |
| 2 | `[PRESS CROUCH] Toggle` (invisibility while tonguing) | `ToggleSmokerCloaking` triggered on IN_DUCK while choking victim | MATCH |
| 3 | `When Choking: Hide Victim Glow` | `g_bSmokerVictimGlowDisabled[iVictim] = true` on tongue grab | MATCH |
| 4 | `[PRESS WALK] Create Smoke On Victim` | `CreateSmokeScreenAroundVictim(iClient)` triggered on IN_SPEED while choking | MATCH |
| 5 | `[PRESS RELOAD] Create Doppelganger On Crosshair` | `CreateSmokerDoppelganger(iClient)` triggered on IN_RELOAD | MATCH |
| 6 | `Spawn Clowns & JumboJimmy If Hit` | On clone death: spawns SMOKER_DOPPELGANGER_CI_SPAWN_COUNT(4) clowns (REALLY_BIG) + 1 Jimmy (REALLY_BIG_JIMMY) | MATCH |
| 7 | `Regens (Max 4)` | SMOKER_DOPPELGANGER_MAX_CLONES = 4, regenerates every SMOKER_DOPPELGANGER_REGEN_PERIOD(15s) | MATCH |
| 8 | **Bind 1: Cloud Conversion** | |
| 9 | `Become Fast Moving Invulnerable Smoke` | Smoker enters MOVETYPE_NOCLIP, becomes smoke cloud entity | MATCH |
| 10 | `3 Stages` | Smoke cloud has staged progression | MATCH |
| 11 | `CI Are Enhanced` | Enhanced CI spawn in smoke cloud area | MATCH |
| 12 | `Enhanced CI Spawn on Survivors` | Enhanced CI spawned on survivor locations | MATCH |
| 13 | `SI Get +150 HP/s` | SI heal in smoke cloud area | MATCH |
| 14 | `Fire, Vomit, PipeBombs Vanish` | These effects are cleared in smoke cloud | MATCH |

**MISSING from menu:** Death cloud on Smoker death (from Talent 2 code: creates poison cloud on death with `+2s Duration per Level` - but this is listed under Talent 3's menu instead)

### Talent 3: Acute Toxicity
**Menu File:** `Menus/I/Menu_Smoker.sp` (DirtyMenuDraw)
**Code File:** `Talents/I/Talents_Smoker.sp`, `Binds/Bind2/I/Bind2_Smoker.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `+5% Speed per Level` | Speed set via `SetClientSpeed` in TalentsLoad; actual percentage depends on MovementSpeed.sp calculation | VAGUE - needs verification of exact speed formula in MovementSpeed.sp |
| 2 | `[CLICK ATTACK] Release Tongued Victim` | `SmokerDismount(iClient)` triggered on IN_ATTACK while choking (with button release check) | MATCH |
| 3 | `[PRESS WALK] Teleport (10 Sec CD)` | `SmokerTeleport` triggered on IN_SPEED, SMOKER_TELEPORT_COOLDOWN_PERIOD = 10.0 | MATCH |
| 4 | `Afterwards Briefly Become Invisible` | After teleport: `g_iSmokerTransparency[iClient] = g_iSmokerTalent3Level[iClient] * 30` gradually fades back to visible | MATCH |
| 5 | `Smoke Cloud Created On Death` | Code is in `EventsDeath_VictimSmoker`: creates poison cloud on death | **MISMATCH** - The death cloud is actually triggered by **Talent 2 level** (`g_iSmokerTalent2Level`), not Talent 3. Menu places it under Talent 3 but the code checks `g_iSmokerTalent2Level[iVictim] > 0` |
| 6 | `2 HP Converted to Temp Every Tick` | TimerPoisonCloud converts 2 HP to temp health per tick | MATCH (for the cloud functionality itself) |
| 7 | `-0.25 Secs per Level on Ticks (Base 3s)` | Needs verification in TimerPoisonCloud timer code | VAGUE |
| 8 | `+2s Duration per Level` | Cloud duration: `g_iSmokerTalent2Level[iVictim] * 2.0` | MATCH (but uses Talent 2 level, not Talent 3) |
| 9 | **Bind 2: The Electric Snare** | |
| 10 | `Instantly Set Max HP to 500` | Bind 2 grants 500 max HP when activated | MATCH |
| 11 | `Shock for 1 DMG per Level Every 0.5s for 3s` | Electrocution deals level-based damage at 0.5s intervals for ~2.9s total | MATCH (approximately) |
| 12 | `Arcs to Survivors for Half Damage` | Chain lightning arcs to nearby survivors within 1200 units at reduced damage | MATCH |

**MAJOR FINDING:** The Smoke Cloud on Death is coded under Talent 2 (Illusive Trickster) level check but displayed in the Talent 3 (Acute Toxicity) menu. This means a player with only Talent 3 levels would NOT get the death cloud despite the menu promising it, and a player with only Talent 2 levels WOULD get it even though it's not shown in their talent menu.

---

## BOOMER

### Talent 1: Rapid Regurgitation
**Menu File:** `Menus/I/Menu_Boomer.sp` (RapidMenuDraw)
**Code File:** `Talents/I/Talents_Boomer.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `-2 second vomit cooldown per level` | `TimerSetBoomerCooldown` sets reduced cooldown when `g_iRapidLevel > 0` | VAGUE - The exact reduction per level needs verification in the timer code |
| 2 | `Reduce movement penalty after vomiting by 10% per level` | `SetClientSpeed(iClient)` called after vomiting; exact reduction depends on MovementSpeed.sp | VAGUE - Exact value depends on speed formula |

### Talent 2: Acidic Brew
**Menu File:** `Menus/I/Menu_Boomer.sp` (AcidicMenuDraw)
**Code File:** `Talents/I/Talents_Boomer.sp`, `Binds/Bind1/I/Bind1_Boomer.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `Vomit victims lose their HUD for 2 seconds per level` | `SetEntProp(iVictim, Prop_Send, "m_iHideHUD", 64)` then timer at `g_iAcidicLevel * 2.0` | MATCH |
| 2 | `+1 damage per level to survivors near your death boom` | Death code: `DealDamage(target, iVictim, g_iAcidicLevel[iVictim])` for non-suicide boom | MATCH |
| 3 | **Bind 1: Hot Meal** | |
| 4 | `3 uses; 9 second duration` | 3 bind uses standard; 9-second continuous vomit duration | MATCH |
| 5 | `Constant vomiting while active` | Forces continuous vomiting during Hot Meal | MATCH |
| 6 | `+10% movement speed per level` | Speed boost during Hot Meal scales with Acidic level | VAGUE - needs MovementSpeed.sp verification |

### Talent 3: Norovirus
**Menu File:** `Menus/I/Menu_Boomer.sp` (NorovirusMenuDraw)
**Code File:** `Talents/I/Talents_Boomer.sp`, `Binds/Bind2/I/Bind2_Boomer.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `Level 1: +4% chance to make survivors vomit per level` | `rand <= (g_iNorovirusLevel * 4)` - GetRandomInt(1,100) | MATCH |
| 2 | `Level 5: Random effect if you vomit on 3 survivors within 9 seconds` | Requires `g_iNorovirusLevel >= 5`, counter tracks 3 vomit victims within 9s timer | MATCH |
| 3 | **Bind 2: Suicide Boomer** | |
| 4 | `3 uses` | Standard 3 bind uses | MATCH |
| 5 | `+5x jump height per level` | Suicide Boomer jump height scales with Norovirus level | VAGUE - exact multiplier needs bind code verification |
| 6 | `+2 boom damage per level` | Death boom damage: `10 + RoundToNearest(g_iNorovirusLevel * 1.5)` | **MISMATCH** - Code does `+1.5 damage per level` (rounded), not `+2 per level`. At level 10 the code gives 10 + 15 = 25, but menu would suggest 10 + 20 = 30 |
| 7 | `+20% fling distance per level` | Fling power: `100.0 + (g_iNorovirusLevel * 30.0)` | VAGUE - 30.0 per level on base 100 is 30% per level, not 20% |
| 8 | `+20% boom distance per level` | Boom distance: `200.0 + (g_iNorovirusLevel * 15.0)` | **MISMATCH** - 15/200 = 7.5% increase per level, not 20% |

---

## HUNTER

### Talent 1: Predatorial Evolution
**Menu File:** `Menus/I/Menu_Hunter.sp` (PredatorialMenuDraw)
**Code File:** `Talents/I/Talents_Hunter.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `[HOLD ATTACK] Dismount Victims` | `HunterDismount` triggered on IN_ATTACK while shredding (with button release check and 15s cooldown) | MATCH |
| 2 | `+5% Movement Speed per Level` | `SetClientSpeed` called; exact value in MovementSpeed.sp | VAGUE - needs speed formula verification |
| 3 | `Gain Evolved Lunge: Lunge Much Faster and Further` | `HUNTER_LUNGE_VELOCITY_MULTIPLIER_START` applied on lunge ability use | MATCH |
| 4 | `Extra Damage For A Far Pounce: Up To 20 Extra Damage` | HUNTER_LUNGE_EXTRA_DAMAGE_MAX = 20 | MATCH |
| 5 | `Min: 150 FT` | HUNTER_LUNGE_EXTRA_DAMAGE_DISTANCE_MIN = 150 | MATCH |
| 6 | `Max: 350 FT` | HUNTER_LUNGE_EXTRA_DAMAGE_DISTANCE_MAX = 350 | MATCH |
| 7 | `[HOLD JUMP] Controlled Descent - Like A Flying Squirrel` | `HUNTER_LUNGE_STATE_FLOAT` triggered on IN_JUMP during lunge | MATCH |
| 8 | `[HOLD ATTACK] Dive Bomb - Dash Forward Toward Target` | `HUNTER_LUNGE_STATE_DASH` triggered on IN_ATTACK during lunge while falling | MATCH |
| 9 | `Uses Momentum and Aim Direction` | Dash adds velocity in eye angle direction | MATCH |

**MISSING from menu:** 15-second cooldown after dismounting is not mentioned.

### Talent 2: Blood Lust
**Menu File:** `Menus/I/Menu_Hunter.sp` (BloodLustMenuDraw)
**Code File:** `Talents/I/Talents_Hunter.sp`, `Binds/Bind1/I/Bind1_Hunter.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `Pounce or Claw a Victim to Feed Your Blood Lust Meter` | `BuildBloodLustMeter` called on claw hit (dmgtype 128) and on pounce | MATCH |
| 2 | `3 Blood Lust Stages` | `g_iBloodLustStage` caps at 3 | MATCH |
| 3 | `+35% Movement Speed per Stage` | Speed set via `SetClientSpeed`; exact per-stage amount in MovementSpeed.sp | VAGUE - needs verification |
| 4 | `+25% Non Lunging Stealth per Stage` | Cloaking transparency based on blood lust stage in render code | VAGUE - needs render code verification |
| 5 | `+1 Shredding Damage per Stage` | `DealDamage(victim, attacker, g_iBloodLustStage[attacker])` on shredding hit | MATCH |
| 6 | `+30 Health/Second Regeneration per Stage` | `SetPlayerHealth(iClient, -1, g_iBloodLustStage[iClient], true)` per frame. At 30fps: stage 1 = 30hp/s, stage 2 = 60hp/s, stage 3 = 90hp/s | MATCH |
| 7 | **Bind 1: Immobilization Area** | |
| 8 | `Deploy an Immobilization Cloud` | Creates a stationary slow zone | MATCH |
| 9 | `Survivors Speed While In Cloud 15%` | Speed reduction = 0.15 (15% of normal speed) | MATCH |
| 10 | `Cannot be activated while seen by Survivors` | Requires hunter to be hidden from survivors | MATCH |
| 11 | `30 Sec Duration` | Zone duration: 30 seconds | MATCH |
| 12 | `120 Sec Global Cooldown` | Global cooldown: 120 seconds shared across all hunters | MATCH |

### Talent 3: Kill-meleon
**Menu File:** `Menus/I/Menu_Hunter.sp` (KillmeleonMenuDraw)
**Code File:** `Talents/I/Talents_Hunter.sp`, `Binds/Bind2/I/Bind2_Hunter.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `+250 Max Health` | `SetPlayerMaxHealth(iClient, 500, false)` - default Hunter HP is 250, so +250 = 500 total | MATCH |
| 2 | `Hide Glow` | Glow hidden via `SetClientRenderAndGlowColor` when Kill-meleon active | MATCH |
| 3 | `Do Not Move to Build Your Stealth: Up to 95% Invisible` | `HandleHunterCloaking` checks for no movement/buttons, counter builds to 100 | MATCH |
| 4 | `While Invisible and Survivors Can See You: Rapidly Charges Blood Lust Meter` | `HandleHunterVisibleBloodLustMeterGain` checks cloaked + visible to survivors | MATCH (but function is currently commented out in OnGameFrame_Hunter!) |
| 5 | `The Closer the Survivors, The Faster The Blood Lust Meter Fills` | Distance-normalized calculation: `fDistanceNormalized = 1.0 - (fDistance / 1500.0)` | MATCH (in the commented-out function) |
| 6 | **Bind 2: Lethal Injection** | |
| 7 | `3 uses` | Standard 3 bind uses | MATCH |
| 8 | `Next Attack Does 4 Dmg/Sec` | Timer does 4 damage per tick via `TimerHunterPoison` | MATCH |
| 9 | `+1 Sec/Lvl` | `g_iHunterPoisonRunTimesCounter = g_iKillmeleonLevel` (duration = level in seconds) | MATCH |
| 10 | `Poison Prevents Item Exchanging` | Hunter poison sets `g_bHunterLethalPoisoned` which blocks item exchange | MATCH |
| 11 | `Slow Victims to 25%` | Speed reduction applied via `SetClientSpeed` when poisoned | VAGUE - exact value needs MovementSpeed.sp verification |

**MAJOR FINDING:** `HandleHunterVisibleBloodLustMeterGain` is commented out in `OnGameFrame_Hunter` (line 34: `// HandleHunterVisibleBloodLustMeterGain(iClient);`). This means the Kill-meleon's advertised feature of "While Invisible and Survivors Can See You: Rapidly Charges Blood Lust Meter" is **NOT FUNCTIONAL**.

---

## SPITTER

### Talent 1: Puppet Master
**Menu File:** `Menus/I/Menu_Spitter.sp` (PuppetMenuDraw)
**Code File:** `Talents/I/Talents_Spitter.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `Spawn in with +1 CI per level` | `TimerConjureCommonInfected` spawns CI on spawn | VAGUE - exact count per level needs timer code verification |
| 2 | `When incaping a player, spawn +1 CI every other level on victim` | Needs verification in Events_Infected code | VAGUE |
| 3 | `25% chance on hit to slow survivors by 2%, 4%, or 6% per level` | `GetRandomInt(1, 4)` = 25% chance; slow amounts: `level * 0.02`, `level * 0.04`, `level * 0.06` | MATCH |
| 4 | `Level 6: Flaming Goo` | Flaming Goo available when `g_iPuppetLevel > 5` in GooTypeMenuDraw | MATCH |
| 5 | `Press [WALK] to change Goo Types` | IN_SPEED triggers `GooTypeMenuDraw` in OnGameFrame_Spitter | MATCH |

### Talent 2: Material Girl
**Menu File:** `Menus/I/Menu_Spitter.sp` (MaterialMenuDraw)
**Code File:** `Talents/I/Talents_Spitter.sp`, `Binds/Bind1/I/Bind1_Spitter.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `If spit hits incaped player: Cloak victim +10% per level` | `SetEntityRenderColor(victim, 255, 255, 255, 255 - RoundToNearest(255.0 * 0.1 * g_iMaterialLevel))` on incap spit hit | MATCH |
| 2 | `Hide victims' glow` | `SetEntProp(victim, "m_nGlowRange", 0)` on incap spit hit | MATCH |
| 3 | `Spawn 1 random UI on spit (2 at Lvl 10)` | Needs verification in spit landing event code | VAGUE |
| 4 | `Melting Goo: +2 spit dmg, Dmg converts health to temp health` | GOO_MELTING case: converts 2 health to temp health per tick | MATCH |
| 5 | `Level 6: Demi Goo: Triples victims gravity and restricts mobility talents` | GOO_DEMI: `SetEntityGravity(iVictim, 3.0)`, `g_bHasDemiGravity` set | MATCH |
| 6 | `Press [WALK] to change Goo Types` | Same as Talent 1 | MATCH |
| 7 | **Bind 1: Bag of Spits** | |
| 8 | `Select from unique Enhanced CI mobs, Conjure them on your next spit` | `BagOfSpitsMenuDraw` offers 5 options, `ConjureFromBagOfSpits` spawns on spit landing | MATCH |

### Talent 3: Hallucinogenic Nightmare
**Menu File:** `Menus/I/Menu_Spitter.sp` (HallucinogenicMenuDraw)
**Code File:** `Talents/I/Talents_Spitter.sp`, `Binds/Bind2/I/Bind2_Spitter.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `-0.5s spit cooldown per level` | Needs verification in ability cooldown code | VAGUE |
| 2 | `Hold [CROUCH] to Phase Shift (stealth and speed)` | IN_DUCK triggers Phase Shift: renders invisible (`SetEntityRenderColor... 1`), increases speed | MATCH |
| 3 | `Claws drug your victim, causing hallucinations` | On spitter_claw hit: `g_bIsHallucinating = true`, `TimerHallucinogen` timer, `hallucinogenic_effect` particle | MATCH |
| 4 | `Repulsion Goo: Bounces victims in 1 of 9 directions` | GOO_REPULSION: `GetRandomInt(1, 9)` with 9 different velocity vectors | MATCH |
| 5 | `Level 6: Viral Goo: Infect victims with a contagious virus` | GOO_VIRAL available when `g_iHallucinogenicLevel > 5`, calls `VirallyInfectVictim` | MATCH |
| 6 | `Press [WALK] to change Goo Types` | Same mechanic | MATCH |
| 7 | **Bind 2: Sisterhood** | |
| 8 | `3 uses; 3 minute cooldown` | 3 bind uses; cooldown 3 minutes between witch conjures | MATCH |
| 9 | `Conjure a disguised witch` | Spawns a Witch entity via `SpawnSpecialInfected` | MATCH |

---

## JOCKEY

### Talent 1: Mutated Tenacity
**Menu File:** `Menus/I/Menu_Jockey.sp` (MutatedMenuDraw)
**Code File:** `Talents/I/Talents_Jockey.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `+1 melee damage every 3 levels` | Code: `if level < 5: dmg=1; elif level < 9: dmg=2; else: dmg=3` when NOT riding | **MISMATCH** - The scaling is levels 1-4 = +1, levels 5-8 = +2, levels 9+ = +3. This isn't strictly "every 3 levels". At level 3 it's still +1, at level 6 it's +2, at level 9 it's +3. The breakpoints are at 5 and 9, not every 3rd level |
| 2 | `+5% lunge distance per level` | Needs convar verification | VAGUE |
| 3 | `-0.35 seconds from all lunge cooldowns per level` | Needs convar verification | VAGUE |
| 4 | **Tweakers Twitch** | |
| 5 | `5 charges` | JOCKEY_TWITCH_TOTAL_CHARGES = 5 | MATCH |
| 6 | `Short burst twitch (WALK + move direction)` | IN_SPEED + directional movement triggers `JockeyTwitch` | MATCH |
| 7 | `Shorter distance while riding (Limited to 2 twitches)` | JOCKEY_TWITCH_RIDING_MAX_CHARGES = 2 | MATCH |
| 8 | `Twitches recharge at half the rate while riding` | JOCKEY_TWITCH_CHARGE_REGENERATE_TIME = 3.0, JOCKEY_TWITCH_CHARGE_REGENERATE_TIME_RIDING = 6.0 (exactly double = half rate) | MATCH |

### Talent 2: Erratic Domination
**Menu File:** `Menus/I/Menu_Jockey.sp` (ErraticMenuDraw)
**Code File:** `Talents/I/Talents_Jockey.sp`, `Binds/Bind1/I/Bind1_Jockey.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `+1 riding damage every 3 levels` | Code: `if g_iMutatedLevel < 5: dmg=1; elif < 9: dmg=2; else: dmg=3` | **MISMATCH** - Uses `g_iMutatedLevel` (Talent 1 level) for the riding damage calculation, NOT `g_iErraticLevel`. The riding damage is calculated from the WRONG talent's level variable |
| 2 | `+3% riding speed per level` | `g_fJockeyRideSpeed = 1.0 + (g_iErraticLevel * 0.03)` | MATCH |
| 3 | **Drag Race** | |
| 4 | `Drag Victims for Tiered Rewards` | `HandleDragRaceRewards` gives rewards based on distance | MATCH |
| 5 | `Tier 1: 50 Ft.` | `g_fJockeyRideDistance >= 50.0` triggers Tier 1 | MATCH |
| 6 | `Tier 2: 100 Ft.` | `g_fJockeyRideDistance >= 100.0` triggers Tier 2 | MATCH |
| 7 | `Tier 3: 150 Ft.` | `g_fJockeyRideDistance >= 150.0` triggers Tier 3 | MATCH |
| 8 | **Bind 1: Golden Shower** | |
| 9 | `3 uses` | Standard 3 bind uses | MATCH |
| 10 | `While riding, urinate on your victim, attracting infected` | Pee ability while riding, converts CI | MATCH |
| 11 | `Disables survivors cloaking` | Disables survivor cloaking on pee target | MATCH |
| 12 | `All Nearby CI Are Upgraded to BIG Enhanced CEDA Workers` | Converts CI within 200 units to CEDA Enhanced | MATCH |
| 13 | `Level 10: Summon a horde` | At max level spawns additional mob | MATCH |

### Talent 3: Unfair Advantage
**Menu File:** `Menus/I/Menu_Jockey.sp` (UnfairMenuDraw)
**Code File:** `Talents/I/Talents_Jockey.sp`, `Binds/Bind2/I/Bind2_Jockey.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `+45 max health per level` | `SetPlayerMaxHealth(iClient, (g_iUnfairLevel * 45), true)` at base upgrade level 0 | MATCH |
| 2 | `+7% movement speed per level` | `SetClientSpeed` called; exact value in MovementSpeed.sp | VAGUE |
| 3 | **Bind 2: Vanishing Act** | |
| 4 | `3 uses; 10 second duration` | 3 bind uses; 10-second cloak duration | MATCH |
| 5 | `+9% cloaking per level` | Cloak transparency scales with Unfair level | VAGUE - exact percentage needs render code verification |
| 6 | `Disable Jockey & survivor glow` | Disables glow on both Jockey and ridden survivor | MATCH |
| 7 | `+5% riding speed per level` | Speed boost scales with level during cloak while riding | VAGUE - needs bind code verification |
| 8 | `Jumping Enabled (+50 height per level)` | `xyzJumpVelocity[2] = (g_iUnfairLevel * 50.0)` while riding with Vanishing Act | MATCH |

---

## CHARGER

### Talent 1: Ground 'n Pound
**Menu File:** `Menus/I/Menu_Charger.sp` (GroundMenuDraw)
**Code File:** `Talents/I/Talents_Charger.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `+1 knock damage per level` | Charge knock damage scales with `g_iGroundLevel` | VAGUE - needs event code verification for exact charge knock damage |
| 2 | `+1 punch, pound, and slam damage every 3rd level after the 1st level` | Claw damage: `if level < 4: dmg=1; elif < 7: dmg=2; elif < 10: dmg=3; else: dmg=4` | **MISMATCH** - Breakpoints are at levels 4, 7, 10 which is every 3 levels starting from level 4. Menu says "every 3rd level after the 1st level" which would imply levels 4, 7, 10 - this is actually correct but the wording is confusing. The first damage bonus (+1) starts at level 1, then increases at 4, 7, 10 |

### Talent 2: Spiked Carapace
**Menu File:** `Menus/I/Menu_Charger.sp` (SpikedMenuDraw)
**Code File:** `Talents/I/Talents_Charger.sp`, `Binds/Bind1/I/Bind1_Charger.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `Reflect 1 damage per level when meleed` | `DealDamage(attacker, victim, g_iSpikedLevel)` on melee hit | MATCH |
| 2 | `+40 max health per level` | `SetPlayerMaxHealth(iClient, (g_iSpikedLevel * 40) + ...)` | MATCH |
| 3 | `+33 health per level when knocking survivors` | Needs verification in charge/carry event code | VAGUE |
| 4 | `CROUCH to charge Uppercut, on next melee: Throw survivors up, 5 fall damage, short stun` | IN_DUCK charges g_iSpikedChargeCounter, next claw flings victim upward with power 577.0 | MATCH (the 5 fall damage from the upward throw is from the game's fall damage mechanic) |
| 5 | **Bind 1: Heavy Carry** | |
| 6 | `3 uses; 15 second cooldown` | 3 bind uses; 30 second cooldown in bind code | **MISMATCH** - Menu says 15 second cooldown but code uses 30 second cooldown |
| 7 | `+10% per level to carry distance and speed on next charge` | Carry distance/speed enhanced by Spiked level | VAGUE |
| 8 | `Reset charge cooldown` | Resets charge ability cooldown | MATCH |

### Talent 3: Hillbilly Madness!
**Menu File:** `Menus/I/Menu_Charger.sp` (HillbillyMenuDraw)
**Code File:** `Talents/I/Talents_Charger.sp`, `Binds/Bind2/I/Bind2_Charger.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `+50 Max Health per level` | `SetPlayerMaxHealth(iClient, ... + (g_iHillbillyLevel * 50))` | MATCH |
| 2 | `+3% Movement Speed & Carry Range per level` | Speed set via `SetClientSpeed` | VAGUE - needs speed formula verification |
| 3 | `-1 Second from Charger cooldown every other level` | Needs convar verification | VAGUE |
| 4 | `On successful grapple: Invincibility` | `g_bChargerCarrying` set to true; damage reduction during carry | VAGUE - "invincibility" is strong wording; code shows damage-to-health conversion, not true invincibility |
| 5 | `+5% of damage taken is converted to health per level` | `SetPlayerHealth(victim, -1, dmgHealth + RoundToNearest(dmgHealth * g_iHillbillyLevel * 0.05), true)` | MATCH |
| 6 | **Bind 2: Earthquake** | |
| 7 | `3 uses` | Standard 3 bind uses | MATCH |
| 8 | `Punch ground to: Damage visible survivors in a larger radius` | Shockwave damage radius: CHARGER_EARTHQUAKE_DISTANCE_SHOCKWAVE_DAMAGE = 350 units | MATCH |
| 9 | `Stun visible survivors in a smaller radius` | Stagger radius: CHARGER_EARTHQUAKE_DISTANCE_STAGGER = 150 units | MATCH |

---

## TANKS

### Fire Tank
**Menu File:** `Menus/I/Tanks/Menu_Tank_Fire.sp`
**Code File:** `Talents/I/Tanks/Talents_Tank_Fire.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `%i HP` (TANK_HEALTH_FIRE = 14000) | `SetTanksTalentHealth(iClient, TANK_HEALTH_FIRE)` = 14000 | MATCH |
| 2 | `Good At All Ranges` | Flavor text | N/A |
| 3 | `High Damage Output, Immune To Fire` | Fire damage check: `if(iDmgType == DAMAGETYPE_FIRE1 || ...)` heals back fire damage | MATCH |
| 4 | `%i-%i%% Faster (Pain = Speed)` (30-70%) | TANK_FIRE_BASE_SPEED = 0.30, TANK_FIRE_EXTRA_SPEED_MAX = 0.40. Range: 30%-70% | MATCH |
| 5 | `20% Chance To Ignite Victim On Punch` | `GetRandomInt(1, 5) == 1` = 20% chance | MATCH |
| 6 | `Lose %i HP/Sec` (FIRE_TANK_HP_DRAIN_PER_SECOND = 50) | Timer drains 50 HP per second | MATCH |
| 7 | `Fire Punch every %i hits` (FIRE_TANK_FIRE_PUNCH_EVERY_N_HITS = 3) | Fire punch recharges after 3 non-incap survivor hits | MATCH |
| 8 | `Throw Fire Rocks` | Fire rock trail effect + molotov explosion on hit | MATCH |
| 9 | `[WALK + Move] Fire Dash` | IN_SPEED + movement direction triggers `FireTankDash` | MATCH |
| 10 | `Lose %i HP` (FIRE_TANK_DASH_HP_COST = 750) | `iCurrentHealth - FIRE_TANK_DASH_HP_COST` | MATCH |

**MISSING from menu:** CI Conversion - Fire Tank converts nearby common infected to CEDA (fire immune) every 2 seconds within 400 unit radius. This is a significant passive not mentioned.

### Ice Tank
**Menu File:** `Menus/I/Tanks/Menu_Tank_Ice.sp`
**Code File:** `Talents/I/Tanks/Talents_Tank_Ice.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `%i HP` (TANK_HEALTH_ICE = 14000) | `SetTanksTalentHealth(iClient, TANK_HEALTH_ICE)` = 14000 | MATCH |
| 2 | `Good At Close Range` | Flavor text | N/A |
| 3 | `Cold Aura: Slow Survivors When Close` | `CheckForPlayersInIceTanksColdAuraSlowRange` runs on every game frame | MATCH |
| 4 | `Weak To Fire, But Fire Goes Out Quickly` | Needs verification in fire damage handling | VAGUE |
| 5 | `33% Chance To Freeze Survivors On Punch` | `GetRandomInt(1, 3) == 1` = 33% on tank_claw hit | MATCH |
| 6 | `[Hold CROUCH & Don't Move] Regens HP` | Crouch + no attack + no movement charges regen, then restores HP from life pool | MATCH |
| 7 | `Freezes Survivors In Blizzard Storm` | While regenerating, blizzard sphere freezes survivors within 130 units | MATCH |
| 8 | `Hold [WALK] to Ice Slide` | IN_SPEED triggers ice slide mode with TANK_ICE_SLIDE_SPEED = 5.0 | MATCH |
| 9 | `Rocks Freeze Survivors (No CD)` | Rock hits freeze survivors (direct and indirect), no cooldown on rock ability | MATCH |

### NecroTanker
**Menu File:** `Menus/I/Tanks/Menu_Tank_NecroTanker.sp`
**Code File:** `Talents/I/Tanks/Talents_Tank_NecroTanker.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `%i Start HP, %i Max HP` (10000, 13666) | Start: TANK_HEALTH_NECROTANKER = 10000, Max: NECROTANKER_MAX_HEALTH = 13666 | MATCH |
| 2 | `+%i HP Per CI Kill` (NECROTANKER_CONSUME_COMMON_HP = 250) | `iAdditionalHealth = NECROTANKER_CONSUME_COMMON_HP` for common | MATCH |
| 3 | `+%i HP Per UI Kill` (NECROTANKER_CONSUME_UNCOMMON_HP = 500) | `iAdditionalHealth = NECROTANKER_CONSUME_UNCOMMON_HP` for uncommon | MATCH |
| 4 | `15% Faster` | `SetClientSpeedTankNecroTanker: fSpeed += 0.15` | MATCH |
| 5 | `Immune to Bile` | Needs verification | VAGUE |
| 6 | `Hit Survivors To Summon Infected` | `SummonNecroTankerPunchZombies` on tank_claw hit | MATCH |
| 7 | `Mana Pool (Hits Regen Mana)` | `g_iNecroTankerManaPool` increased by NECROTANKER_MANA_GAIN_PUNCH on hit | MATCH |
| 8 | `[Hold USE] Summon CEDA` | IN_USE + charge timer spawns CEDA uncommon infected | MATCH |
| 9 | `[Hold RELOAD] Summon Enhanced UI` | IN_RELOAD + charge timer spawns Enhanced CI | MATCH |
| 10 | `[WALK] Teleport` | IN_SPEED (pressed, not held) triggers `NecroTankerTeleport` | MATCH |
| 11 | `Throw Boomers!` | Rock throw creates boomer bile explosion on impact, vomits nearby survivors, spawns CI | MATCH |

**MISSING from menu:** Mana costs for abilities, Raining Blood punch effect (10% chance), teleport cooldown (10s), teleport mana cost.

### Vampiric Tank
**Menu File:** `Menus/I/Tanks/Menu_Tank_Vampiric.sp`
**Code File:** `Talents/I/Tanks/Talents_Tank_Vampiric.sp`

| # | Menu Claim | Code Reality | Status |
|---|-----------|-------------|--------|
| 1 | `%i HP` (TANK_HEALTH_VAMPIRIC = 8000) | `SetTanksTalentHealth(iClient, TANK_HEALTH_VAMPIRIC)` = 8000 | MATCH |
| 2 | `Good At Close Range, Safe At Long Range` | Flavor text | N/A |
| 3 | `Life Steal On Punch` | Lifesteal: `iDmgHealth * VAMPIRIC_TANK_LIFESTEAL_MULTIPLIER(8)` on punch | MATCH |
| 4 | `Life Steal More From Incapacitated Victims` | Incap multiplier: `VAMPIRIC_TANK_LIFESTEAL_INCAP_MULTIPLIER(12)` vs normal `(8)` | MATCH |
| 5 | `30% Faster` | `SetClientSpeedTankVampiric: fSpeed += 0.30` | MATCH |
| 6 | `Dodges Bullets (1/3rd Gun Dmg Taken)` | VAMPIRIC_TANK_GUN_DMG_TAKEN_MULTIPLIER = 0.333333 | MATCH |
| 7 | `Weak To Melee (3X Melee Dmg Taken)` | VAMPIRIC_TANK_MELEE_DMG_TAKEN_MULTIPLIER = 3 | MATCH |
| 8 | `[Press JUMP] Fly` | IN_JUMP triggers wing flap with upward velocity, stamina system | MATCH |
| 9 | `[Press MELEE] Wing Dash` | IN_ATTACK2 (secondary attack/melee) triggers wing dash | MATCH |
| 10 | `3 Uses (13 Sec CD)` | `g_iVampiricTankWingDashChargeCount = 3`, VAMPIRIC_TANK_WING_DASH_COOLDOWN = 13.0 | MATCH |
| 11 | `No Rock Throwing` | `SetSIAbilityCooldown(iClient, 99999.0)` disables rock throw | MATCH |

**MISSING from menu:** Stamina system (flaps and dashes consume stamina, stamina regenerates over time).

---

## SUMMARY OF ALL ISSUES FOUND

### Critical Mismatches (functionality doesn't match description):

1. **Smoker Talent 3 - Death Cloud**: Menu says death cloud is part of Acute Toxicity (Talent 3), but code checks `g_iSmokerTalent2Level` (Illusive Trickster / Talent 2). Players with only Talent 3 won't get the death cloud.

2. **Hunter Kill-meleon - Blood Lust Meter from Visibility**: The function `HandleHunterVisibleBloodLustMeterGain` is **commented out** in `OnGameFrame_Hunter`. The menu advertises "While Invisible and Survivors Can See You: Rapidly Charges Blood Lust Meter" but this feature is disabled.

3. **Jockey Erratic Domination - Riding Damage**: Menu says "+1 riding damage every 3 levels" for Erratic Domination, but code uses `g_iMutatedLevel` (Talent 1's variable) instead of `g_iErraticLevel` for the riding damage calculation.

4. **Boomer Norovirus - Suicide Boom Damage**: Menu says "+2 boom damage per level" but code does `10 + RoundToNearest(g_iNorovirusLevel * 1.5)` which is +1.5 per level.

5. **Boomer Norovirus - Suicide Boom Distance**: Menu says "+20% boom distance per level" but code does `200.0 + (level * 15.0)` which is 7.5% increase per level at base, not 20%.

6. **Charger Spiked Carapace - Heavy Carry Cooldown**: Menu says "15 second cooldown" but bind code uses 30 second cooldown.

### Non-Functional Features:
1. **Hunter Kill-meleon's visible blood lust meter gain** - Code exists but is commented out.

### Missing From Menus (undocumented features):
1. **Smoker Talent 1**: Dismount cooldown not mentioned
2. **Hunter Predatorial Evolution**: 15-second dismount cooldown not mentioned
3. **Fire Tank**: CI conversion passive (converts nearby CI to CEDA every 2s) not mentioned
4. **NecroTanker**: Mana costs, Raining Blood effect, teleport cooldown not mentioned
5. **Vampiric Tank**: Stamina system not mentioned
6. **Smoker Death Cloud**: Incorrectly placed in Talent 3 menu when it belongs to Talent 2
