GetXPMConVarValues()
{
	//Execute config file
	decl String:strFileName[64];
	Format(strFileName, sizeof(strFileName), "xpmod_%s", PLUGIN_VERSION);
	AutoExecConfig(true, strFileName);
}


// Create the ConVars and Hook their changes
SetupXPMConVars()
{
	CreateConVar("xpm_version", PLUGIN_VERSION, "XPMod Version loaded", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	CreateConVar("xpmod_version", PLUGIN_VERSION, "XPMod Version loaded", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);

	// Default Survivor Class
	g_hCVar_DebugMode = CreateConVar("xpm_debug", "0", "Sets the level of debug logging [0 = DEBUG_MODE_OFF, 1 = DEBUG_MODE_ERRORS, 2 = DEBUG_MODE_TIMERS, 3 = DEBUG_MODE_VERBOSE, 4 = DEBUG_MODE_EVERYTHING, -1 = DEBUG_MODE_TESTING]", 0, true, -1.0, true, 4.0);
	HookConVarChange(g_hCVar_DebugMode, CVarChange_DebugMode);

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
}

//Callback function for updating the default survivor
CVarChange_DebugMode(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDebugMode =  StringToInt(strNewValue);
	PrintToServer("[XPM] ConVar changed: DebugMode is now %i", g_iDebugMode);
	PrintToChatAll("[XPM] ConVar changed: DebugMode is now %i", g_iDebugMode);
}

//Callback function for enabling or disabling the new vote winner sound
// CVarChange_TalentSelectionMode(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
// {
// 	//If the value was not changed, then do nothing
// 	if(StrEqual(strOldValue, strNewValue) == true)
// 		return;
	
// 	//If the value was changed, then set it and display a message to the server and players
// 	if (StringToInt(strNewValue) == 1)
// 	{
// 		g_iTalentSelectionMode = CONVAR_WEBSITE;
// 		PrintToServer("[XPM] ConVar changed: Talent Selection Mode is now WEBSITE");
// 		PrintToChatAll("[XPM] ConVar changed: Talent Selection Mode is now WEBSITE");
// 	}
// 	else
// 	{
// 		g_iTalentSelectionMode = CONVAR_MENU;
// 		PrintToServer("[XPM] ConVar changed: Talent Selection Mode is now MENU");
// 		PrintToChatAll("[XPM] ConVar changed: Talent Selection Mode is now MENU");
// 	}
// }


//Callback function for updating the default survivor
CVarChange_DefaultSurvivor(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultSurvivor =  StringToInt(strNewValue);
	PrintToServer("[XPM] ConVar changed: Default Surivovor is now %i", g_iDefaultSurvivor);
	PrintToChatAll("[XPM] ConVar changed: Default Surivovor is now %i", g_iDefaultSurvivor);
}

//Callback function for updating the default infected
CVarChange_DefaultInfectedSlot1(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultInfectedSlot1 =  StringToInt(strNewValue);
	PrintToServer("[XPM] ConVar changed: Default Infected Slot 1 is now %i", g_iDefaultInfectedSlot1);
	PrintToChatAll("[XPM] ConVar changed: Default Infected Slot 1 is now %i", g_iDefaultInfectedSlot1);
}

//Callback function for updating the default infected
CVarChange_DefaultInfectedSlot2(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultInfectedSlot2 =  StringToInt(strNewValue);
	PrintToServer("[XPM] ConVar changed: Default Infected Slot 2 is now %i", g_iDefaultInfectedSlot2);
	PrintToChatAll("[XPM] ConVar changed: Default Infected Slot 2 is now %i", g_iDefaultInfectedSlot2);
}


//Callback function for updating the default infected
CVarChange_DefaultInfectedSlot3(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
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