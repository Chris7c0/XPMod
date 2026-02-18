# XPMod

**A SourceMod RPG plugin for Left 4 Dead 2** that adds an experience system, character progression, and unique unlockable abilities for every survivor and special infected.

Players earn XP through gameplay, level up to unlock talents, and activate powerful character-specific abilities — turning standard L4D2 into a full RPG co-op experience.

> **Website & Community:** [xpmod.net](http://xpmod.net)

---

## Features

### RPG Progression
- Earn XP from kills, incapacitations, heals, revives, and more
- Level up through 30 ranks and unlock talent points
- **Prestige system** — reset after max level for cosmetic prestige stars
- Player names display level tags in chat (e.g. `[30] PlayerName`, `[☆5] PrestigePlayer`)
- All progress saved to a MySQL database across sessions

### Character-Specific Talents
Every character has a unique talent tree with passive upgrades and active abilities:

**Survivors**
| Character | Example Talents |
|-----------|----------------|
| Bill | Sprint charge, team healing aura, stealth (Ghillie), crawl speed boost |
| Rochelle | Support abilities, damage buffs, team coordination |
| Coach | Endurance, crowd control, melee bonuses |
| Ellis | Gadget-based abilities, speed boosts, mechanical expertise |
| Nick | Gambler talents, magnum proficiency, Rambo mode, Divine Intervention |
| Louis | Pill-based healing, support passives, team XP bonuses |

**Special Infected**
| Character | Example Talents |
|-----------|----------------|
| Boomer | Rapid vomit, acidic vomit (vision impairment), Norovirus spread |
| Smoker | Extended tongue range, smoke cloud abilities |
| Hunter | Enhanced pounce, movement speed upgrades |
| Spitter | Spit range, acid pooling, conjurer abilities |
| Jockey | Jump distance, ride control, mobility talents |
| Charger | Impact damage, carry enhancements, charge speed |

**Tank Variants** — special mutated Tank forms with their own ability sets:
- **Fire Tank** — flame-based attacks
- **Ice Tank** — freezing and chilling effects
- **Necro Tanker** — undead summoning
- **Vampiric Tank** — life steal mechanics

### Keybind Ability System
Each character has two bindable hotkeys (`Bind 1` / `Bind 2`) that activate their active abilities in-game. Abilities have character-specific cooldowns and charge systems.

### Loadout System
Configure default starting loadouts per character, including primary weapons, secondary weapons, health items, and upgrades.

### Admin Tools
- Admin menu for server management
- Player ban system
- Debug/testing mode with verbosity levels
- Vote kick immunity for high-level players

### HUD & Feedback
- **Victim Health Meter** — real-time damage feedback
- **DPS Meter** — damage-per-second statistics
- **Stats Panel** — round summary and player statistics
- **Top 10 Leaderboard** — tracked via database
- Particle effects and sounds for abilities and level-ups

---

## Requirements

- [Left 4 Dead 2](https://store.steampowered.com/app/550/Left_4_Dead_2/)
- [SourceMod](https://www.sourcemod.net/) (1.10+)
- MySQL database

---

## Installation

1. **Install SourceMod** on your L4D2 server if you haven't already.

2. **Copy the plugin** — place `xpmod.smx` into:
   ```
   left4dead2/addons/sourcemod/plugins/
   ```

3. **Configure the database** — add an `xpmod` entry to your SourceMod `databases.cfg`:
   ```
   "xpmod"
   {
       "driver"    "mysql"
       "host"      "your-db-host"
       "database"  "xpmod"
       "user"      "your-db-user"
       "pass"      "your-db-password"
   }
   ```

4. **Start the server.** XPMod will connect to the database and initialize automatically on first run.

---

## Building from Source

### Linux
```bash
./xpmodcompile.sh
```

### Windows
```bat
win_xpmodcompile.bat
```

The build scripts invoke the bundled `spcomp` SourcePawn compiler and output `xpmod.smx`.

---

## Project Structure

```
XPMod/
├── xpmod.sp                  # Plugin entry point
├── XPMod/
│   ├── GlobalVariables/      # Constants, ConVars, offsets
│   ├── XP/                   # XP earning and level progression
│   ├── Database/             # MySQL persistence layer
│   ├── Menus/                # In-game menus (per character)
│   │   ├── S/                # Survivor menus
│   │   └── I/                # Infected menus + Tank variants
│   ├── Talents/              # Character ability implementations
│   │   ├── S/                # Survivor talents
│   │   └── I/                # Infected talents + Tank variants
│   ├── Binds/                # Hotkey ability activation
│   │   ├── Bind1/
│   │   └── Bind2/
│   ├── Timers/               # Recurring timer logic
│   ├── Events/               # Game event handlers
│   └── Misc/                 # Utilities, admin commands, debug tools
└── include/                  # SourceMod standard includes
```

---

## ConVars

| ConVar | Description |
|--------|-------------|
| `sm_xpmod_debug_mode` | Debug verbosity: `0`=off, `1`=errors, `2`=timers, `3`=verbose, `4`=everything |
| `sm_xpmod_idle_kick` | Kick idle/AFK players |
| `sm_xpmod_xpsave_high_levels` | Continue saving XP after reaching max level |
| `sm_xpmod_default_survivor` | Default survivor: Bill=`0`, Rochelle=`1`, Coach=`2`, Ellis=`3`, Nick=`4`, Louis=`5` |
| `sm_xpmod_default_infected_*` | Default infected class per spawn slot |

---

## Game Mode Support

| Mode | ID |
|------|----|
| Coop | `0` |
| Versus | `1` |
| Scavenge | `2` |
| Survival | `3` |
| Versus Survival | `4` |
