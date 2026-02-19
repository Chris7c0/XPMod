void GetXPMConVarValues()
{
	//Execute config file
	char strFileName[64];
	Format(strFileName, sizeof(strFileName), "xpmod");
	AutoExecConfig(true, strFileName);
}


// Create the ConVars and Hook their changes
void SetupXPMConVars()
{
	CreateConVar("xpm_version", PLUGIN_VERSION, "XPMod Version loaded", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	CreateConVar("xpmod_version", PLUGIN_VERSION, "XPMod Version loaded", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);

	// Debug Mode Logging
	g_hCVar_DebugModeLogLevel = CreateConVar("xpm_debug_logging", "0", "Sets the level of debug logging [0 = DEBUG_MODE_OFF, 1 = DEBUG_MODE_ERRORS, 2 = DEBUG_MODE_TIMERS, 3 = DEBUG_MODE_VERBOSE, 4 = DEBUG_MODE_EVERYTHING, -1 = DEBUG_MODE_TESTING]", 0, true, -1.0, true, 4.0);
	HookConVarChange(g_hCVar_DebugModeLogLevel, CVarChange_DebugModeLogLevel);

	// XPMod Debug Mode
	g_hCVar_DebugModeEnabled = CreateConVar("xpm_debug_mode_enabled", "0", "Sets if xpmod_debug_mode is on [0 = Debug Mode DISABLED, 1 = Debug mode ENABLED]", 0, true, -1.0, true, 4.0);
	HookConVarChange(g_hCVar_DebugModeEnabled, CVarChange_DebugModeEnabled);

	// AFK Idle Kicking
	g_hCVar_IdleKickEnabled = CreateConVar("xpm_idle_kick_enabled", "1", "Sets if the AFK Idle Kicking feature is on [0 = Idle Kicking DISABLED, 1 = Idle Kicking ENABLED]", 1, true, -1.0, true, 4.0);
	HookConVarChange(g_hCVar_IdleKickEnabled, CVarChange_IdleKickEnabled);

	// XP Saving for high XP players
	g_hCVar_XPSaveForHighLevelsEnabled = CreateConVar("xpm_xp_save_enabled", "1", "Sets if XP will be saved for players above 2x Max Level XP amount [0 = XP Saving DISABLED, 1 = XP Saving ENABLED]", 0, true, 0.0, true, 1.0);
	HookConVarChange(g_hCVar_XPSaveForHighLevelsEnabled, CVarChange_XPSaveForHighLevelsEnabled);

	// // TalentSelectionMode
	// g_hCVar_TalentSelectionMode = CreateConVar("xpm_talent_selection_mode", "1", "Sets the talent selection mode when players choose characters [0 = MENU, 1 = WEBSITE]", 0, true, 0.0, true, 1.0);
	// HookConVarChange(g_hCVar_TalentSelectionMode, CVarChange_TalentSelectionMode);

	// Default Survivor Class
	g_hCVar_DefaultSurvivor = CreateConVar("xpm_default_survivor", "0", "Sets the default surivovor when someone first logs in [0 = BILL, 1 = ROCHELLE, 2 = COACH, 3 = ELLIS, 4 = NICK]", 0, true, 0.0, true, 8.0);
	HookConVarChange(g_hCVar_DefaultSurvivor, CVarChange_DefaultSurvivor);

	// Default Infected Class Slot 1
	g_hCVar_DefaultInfecttedSlot1 = CreateConVar("xpm_default_infected_1", "2", "Sets the default infected for slot 1 when someone first logs in [1 = SMOKER, 2 = BOOMER, 3 = HUNTER, 4 = SPITTER, 5 = JOCKEY, 6 = CHARGER]", 0, true, 0.0, true, 6.0);
	HookConVarChange(g_hCVar_DefaultInfecttedSlot1, CVarChange_DefaultInfectedSlot1);

	// Default Infected Class Slot 2
	g_hCVar_DefaultInfecttedSlot2 = CreateConVar("xpm_default_infected_2", "5", "Sets the default infected for slot 2 when someone first logs in [1 = SMOKER, 2 = BOOMER, 3 = HUNTER, 4 = SPITTER, 5 = JOCKEY, 6 = CHARGER]", 0, true, 0.0, true, 6.0);
	HookConVarChange(g_hCVar_DefaultInfecttedSlot2, CVarChange_DefaultInfectedSlot2);

	// Default Infected Class Slot 3
	g_hCVar_DefaultInfecttedSlot3 = CreateConVar("xpm_default_infected_3", "1", "Sets the default infected for slot 3 when someone first logs in [1 = SMOKER, 2 = BOOMER, 3 = HUNTER, 4 = SPITTER, 5 = JOCKEY, 6 = CHARGER]", 0, true, 0.0, true, 6.0);
	HookConVarChange(g_hCVar_DefaultInfecttedSlot3, CVarChange_DefaultInfectedSlot3);

	
	SetUpInitialConvarValues();
}

// This is required for auto reload plugin
void SetUpInitialConvarValues()
{
	g_bDebugModeEnabled = g_hCVar_DebugModeEnabled.IntValue == 1 ? true : false;
	SetDebugMode(g_bDebugModeEnabled);

	g_bAFKIdleKickingEnabled =  g_hCVar_IdleKickEnabled.IntValue == 1 ? true : false;
}

//Callback function for updating the Debug Mode
void CVarChange_DebugModeLogLevel(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDebugModeLogLevel =  StringToInt(strNewValue);
	PrintToServer("[XPM] ConVar changed: DebugMode is now %i", g_iDebugModeLogLevel);
	PrintToChatAll("[XPM] ConVar changed: DebugMode is now %i", g_iDebugModeLogLevel);
}

//Callback function for updating the Idle Kicking
void CVarChange_DebugModeEnabled(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_bDebugModeEnabled =  StringToInt(strNewValue) == 1 ? true : false;
	PrintToServer("[XPM] ConVar changed: DebugMode is now %i", g_bDebugModeEnabled);
	PrintToChatAll("[XPM] ConVar changed: DebugMode is now %i", g_bDebugModeEnabled);

	SetDebugMode(g_bDebugModeEnabled);
}


//Callback function for updating the Idle Kicking
void CVarChange_IdleKickEnabled(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_bAFKIdleKickingEnabled =  StringToInt(strNewValue) == 1 ? true : false;
	PrintToServer("[XPM] ConVar changed: AFK Idle Kick is now %i", g_bAFKIdleKickingEnabled);
	PrintToChatAll("[XPM] ConVar changed: AFK Idle Kick is now %i", g_bAFKIdleKickingEnabled);
}

//Callback function for updating the XP Gain and Use on the Server
void CVarChange_XPSaveForHighLevelsEnabled(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	XPSaveForHighLevelsEnabled =  StringToInt(strNewValue) == 0 ? false : true;
	PrintToServer("[XPM] ConVar changed: XP saving for high XP players is now %s on this server.", XPSaveForHighLevelsEnabled ? "ENABLED" : "DISABLED");
	PrintToChatAll("[XPM] ConVar changed: XP saving for high XP players is now %s on this server.", XPSaveForHighLevelsEnabled ? "ENABLED" : "DISABLED");
}


//Callback function for updating the default survivor
void CVarChange_DefaultSurvivor(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultSurvivor =  StringToInt(strNewValue);
	PrintToServer("[XPM] ConVar changed: Default Surivovor is now %i", g_iDefaultSurvivor);
	PrintToChatAll("[XPM] ConVar changed: Default Surivovor is now %i", g_iDefaultSurvivor);
}

//Callback function for updating the default infected
void CVarChange_DefaultInfectedSlot1(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultInfectedSlot1 =  StringToInt(strNewValue);
	PrintToServer("[XPM] ConVar changed: Default Infected Slot 1 is now %i", g_iDefaultInfectedSlot1);
	PrintToChatAll("[XPM] ConVar changed: Default Infected Slot 1 is now %i", g_iDefaultInfectedSlot1);
}

//Callback function for updating the default infected
void CVarChange_DefaultInfectedSlot2(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultInfectedSlot2 =  StringToInt(strNewValue);
	PrintToServer("[XPM] ConVar changed: Default Infected Slot 2 is now %i", g_iDefaultInfectedSlot2);
	PrintToChatAll("[XPM] ConVar changed: Default Infected Slot 2 is now %i", g_iDefaultInfectedSlot2);
}


//Callback function for updating the default infected
void CVarChange_DefaultInfectedSlot3(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultInfectedSlot3 =  StringToInt(strNewValue);
	PrintToServer("[XPM] ConVar changed: Default Infected Slot 3 is now %i", g_iDefaultInfectedSlot3);
	PrintToChatAll("[XPM] ConVar changed: Default Infected Slot 3 is now %i", g_iDefaultInfectedSlot3);
}

// For calculating temp health
void OnPainPillsDecayChanged(Handle convar, const char[] oldValue, const char[] newValue)
{
    flPainPillsDecay = StringToFloat(newValue);
}
