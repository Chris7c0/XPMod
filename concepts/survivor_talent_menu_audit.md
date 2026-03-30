# Survivor Talent Menu Audit

Audit of all survivor talent menu descriptions vs actual code implementations.
**Total discrepancies found: 26** across 6 survivors. Zoey is clean.

---

## Zoey - No Discrepancies

All 6 talents fully match between menu and code:
- Resilient Resuscitation
- Trigger Happy
- Survivor's Will
- Sharing Is Caring
- Medical Expertise (Bind 1)
- Instant Intervention (Bind 2)

---

## Bill - 4 Discrepancies

### Exorcism in a Barrel - Reload Speed Wrong
- **Menu says:** +20% Reload speed per level
- **Code does:** +9% per level (`* 0.09` in `Events_Reload.sp:118`)

### Die Hard (Bind 1) - Bind Uses Don't Scale
- **Menu says:** "+1 use every other level" for Improvised Explosives
- **Code does:** Always 3 uses regardless of level. Only the number of pipebombs dropped per use scales (1 at levels 1-2, 2 at levels 3-4, 3 at level 5). `g_iClientBindUses_1` is never initialized based on Die Hard level in `TalentsLoad_Bill()`.

### Promotional Benefits - Reload Speed Wrong
- **Menu says:** +8% reload speed per level
- **Code does:** +4% per level (`* 0.04` in `Events_Reload.sp:118`)

### Promotional Benefits - Cloaking Wrong
- **Menu says:** +8% cloaking per level
- **Code does:** +4% per level (`* 0.04` in `RenderColorAndGlow.sp:81`)

### Possible Bug (Not a Menu Issue)
`HandleBillsTeamHealing()` in `Talents_Bill.sp:428` checks `g_iInspirationalLevel < 0` instead of `<= 0`, allowing team healing to work even at Inspirational level 0.

---

## Rochelle - 4 Discrepancies

### Silent Sorrow - Format String Bug
- **Menu says:** `+12%` with a single `%`
- **Should be:** `+12%%%%` to match all other percentages in the same FormatEx call
- **Location:** `Menu_Rochelle.sp:215`

### Shadow Ninja (Bind 2) - Bind Uses Don't Scale
- **Menu says:** "+1 use every other level"
- **Code does:** Always 3 uses at all levels. `g_iClientBindUses_2` is initialized to 0 in `ResetVariables.sp:97` with no Shadow-level-based scaling. Compare with Zoey which properly initializes bind uses based on level.

---

## Coach - 2 Discrepancies

### Lead by Example - Screen Shake Level Gate Wrong
- **Menu says:** Screen shake reduction is a "Level 5" bonus
- **Code does:** Applies at Level 1+ (`g_iLeadLevel > 0` in `Talents_Coach.sp:63` and `Talents_Bill.sp:39`)

### Homerun! - Terminology Inaccurate (Minor)
- **Menu says:** "On CI Decapitation" and "On SI Decapitation"
- **Code does:** Triggers on any melee headshot kill (`GetEventBool(hEvent, "headshot")`), not specifically decapitations. The code itself has a comment acknowledging this at `Talents_Coach.sp:1068`. Especially misleading for SI since they don't get decapitated.

---

## Ellis - 6 Discrepancies

### Overconfidence - RoF Not Conditional on HP
- **Menu says:** "If Within X Points Of Max Health: +5% RoF To All Guns per Level"
- **Code does:** The +5% RoF is always applied unconditionally in `HandleFasterAttacking_Ellis` (`Talents_Ellis.sp:320-321`). Only the +1% movement speed is actually gated on the HP check.

### Jammin' to the Music - Speed Scales With Tank Count
- **Menu says:** "+1% Movement Speed per Level"
- **Code does:** `g_iTankCounter * g_iJamminLevel * 0.01` (`MovementSpeed.sp:148`). The speed boost is multiplied by the number of active tanks, which the menu does not mention.

### Weapons Training - Laser Sight Level Gate Wrong
- **Menu says:** Automatic Laser Sight listed under "Level 5"
- **Code does:** Granted at Level 1+ (`g_iWeaponsLevel > 0` in `Events_Interact.sp:92-99`)

### Mechanic Affinity - Firing Rate Requires Overconfidence
- **Menu says:** "+5% Firing Rate per Level" as a standalone Level 1 bonus
- **Code does:** The entire `HandleFasterAttacking_Ellis` function returns early if `g_iOverLevel <= 0` (`Talents_Ellis.sp:276-281`). Zero firing rate bonus without investment in Overconfidence.

### Fire Storm (Bind 2) - Bind Uses Don't Scale
- **Menu says:** "+1 Use Every Other Level"
- **Code does:** Always 3 uses. `g_iClientBindUses_2` is initialized to 0 with no Fire-level-based scaling. Compare with Bind 1 (Mechanic Affinity) which properly scales: `3 - RoundToCeil(g_iMetalLevel * 0.5)`.

---

## Nick - 7 Discrepancies

### Swindler - Life Steal Timing Wrong
- **Menu says:** "Life stealing ticks every second for 5 seconds"
- **Code does:** Repeating timer fires every 2.0 seconds (`CreateTimer(2.0, ...)` in `Timers_Nick.sp:51-95`), runs 5 ticks, so total duration is ~10 seconds with effects every ~2 seconds.

### Risky Business - Reload Speed Wrong
- **Menu says:** +20% reload speed per level
- **Code does:** +10% per level (`* 0.1` in `Events_Reload.sp:123`)

### Risky Business - Damage Wrong
- **Menu says:** +20% damage per level
- **Code does:** +13% per level (`* 0.13` in `Talents_Nick.sp:550`)

### Enhanced Pain Killers - Pistol Heal Amount Wrong
- **Menu says:** "Pistols: +2 HP for Teammate"
- **Code does:** Net +1 HP. Friendly fire damage is reversed plus `NICK_HEAL_PISTOL_GIVE = 1` (`GlobalVariables/Survivors.sp:316`).

### Desperate Measures - Speed Bonus Wrong
- **Menu says:** "(Stacks) +2% speed per level"
- **Code does:** +1% per level per stack (`* 0.01` in `MovementSpeed.sp:166-168`)

### Desperate Measures - Heal Amount Wrong
- **Menu says:** "Heal team +4 health per level (costs 1 charge)"
- **Code does:** +5 health per level (`* 5` in `Talents_Nick.sp:864-867`)

### Desperate Measures (Bind 2) - Bind Uses Don't Scale
- **Menu says:** "+1 use every other level"
- **Code does:** Always 3 uses. `g_iClientBindUses_2` is never initialized based on `g_iDesperateLevel`. Compare with Bind 1 (Magnum Stampede) which properly scales uses.

---

## Louis - 5 Discrepancies

### 9mm Augmentation - Damage Wrong
- **Menu says:** +10% Damage per Level
- **Code does:** +20% per level (`LOUIS_BONUS_DAMAGE_PER_LEVEL = 0.20` in `Talents_Louis.sp:318`)

### BOOM HEADSHOT! - Headshot Damage Multiplier Wrong
- **Menu says:** +40% Headshot Damage Multiplier per Level
- **Code does:** Varies by mode, none are 40%:
  - Laser mode on: 5% per level (`LOUIS_HEADSHOT_DMG_MULITPLIER_PER_LEVEL_LASER = 0.05`)
  - Laser mode off: 30% per level (`LOUIS_HEADSHOT_DMG_MULITPLIER_PER_LEVEL_NOLASER = 0.30`)
  - Pistol: 20% per level (`LOUIS_HEADSHOT_DMG_MULITPLIER_PER_LEVEL_PISTOL = 0.20`)

### BOOM HEADSHOT! - Non-Headshot Damage Penalty Incomplete
- **Menu says:** -10% Damage Penalty for Non-Headshots per Level
- **Code does:** Varies by mode:
  - Laser mode on: -20% per level (`LOUIS_BODY_DAMAGE_REDUCTION_PER_LEVEL_LASER = 0.20`)
  - Laser mode off: -10% per level (`LOUIS_BODY_DAMAGE_REDUCTION_PER_LEVEL_NOLASER = 0.10`)
  - Pistol: -15% per level (`LOUIS_BODY_DAMAGE_REDUCTION_PER_LEVEL_PISTOL = 0.15`)
- Only the no-laser mode matches the menu.

### BOOM HEADSHOT! & PILLS HERE! - Speed Cap Wrong
- **Menu says:** "Louis Is Always Capped At +15% Speed"
- **Code does:** Cap varies by laser mode:
  - Laser mode on: +10% (`LOUIS_SPEED_MAX_LASER = 1.10`)
  - Laser mode off: +25% (`LOUIS_SPEED_MAX_NOLASER = 1.25`)
- Neither is 15%.

### PILLS HERE! - Health Reduction Uses Wrong Talent Level
- **Menu says:** "-2 Temp Health Per Level" (implies PILLS HERE! talent level)
- **Code does:** Uses `g_iLouisTalent5Level` (Neurosurgeon level) instead of `g_iLouisTalent6Level` (PILLS HERE! level) at `Talents_Louis.sp:492`. May be intentional cross-talent dependency or a bug.

---

## Common Patterns

1. **Percentage values don't match code** - Most frequent issue. Reload speeds, damage bonuses, and cloaking percentages are often wrong in menus.
2. **"Bind uses scale with level" claimed but not implemented** - Bill Die Hard, Rochelle Shadow Ninja, Ellis Fire Storm, and Nick Desperate Measures all claim "+1 use every other level" but always give 3 uses. Their corresponding Bind 1 talents DO scale properly.
3. **Level gates described incorrectly** - Features listed under "Level 5" that actually activate at Level 1 (Coach Lead by Example screen shake, Ellis Weapons Training laser sight).
4. **Unimplemented features** - Rochelle's melee attack speed bonus and Ellis's witch neutralization exist only in menu text.
