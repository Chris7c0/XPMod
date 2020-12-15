// Create the ConVars and Hook their changes
SetupXPMConVars()
{
	// // TalentSelectionMode
	// g_hCVar_TalentSelectionMode = CreateConVar("xpm_talent_selection_mode", "1", "Sets the talent selection mode when players choose characters [0 = MENU, 1 = WEBSITE]", 0, true, 0.0, true, 1.0);
	// HookConVarChange(g_hCVar_TalentSelectionMode, CVarChange_TalentSelectionMode);

	// Default Survivor Class
	g_hCVar_DefaultSurvivor = CreateConVar("xpm_default_survivor", "0", "Sets the default surivovor when someone first logs in [0 = BILL, 1 = ROCHELLE, 2 = COACH, 3 = ELLIS, 4 = NICK]", 0, true, 0.0, true, 1.0);
	HookConVarChange(g_hCVar_DefaultSurvivor, CVarChange_DefaultSurvivor);

	// Default Infected Class Slot 1
	g_hCVar_DefaultInfecttedSlot1 = CreateConVar("xpm_default_infected_1", "2", "Sets the default infected for slot 1 when someone first logs in [1 = SMOKER, 2 = BOOMER, 3 = HUNTER, 4 = SPITTER, 5 = JOCKEY, 6 = CHARGER]", 0, true, 0.0, true, 1.0);
	HookConVarChange(g_hCVar_DefaultInfecttedSlot1, CVarChange_DefaultInfectedSlot1);

	// Default Infected Class Slot 2
	g_hCVar_DefaultInfecttedSlot2 = CreateConVar("xpm_default_infected_2", "5", "Sets the default infected for slot 2 when someone first logs in [1 = SMOKER, 2 = BOOMER, 3 = HUNTER, 4 = SPITTER, 5 = JOCKEY, 6 = CHARGER]", 0, true, 0.0, true, 1.0);
	HookConVarChange(g_hCVar_DefaultInfecttedSlot2, CVarChange_DefaultInfectedSlot2);

	// Default Infected Class Slot 3
	g_hCVar_DefaultInfecttedSlot3 = CreateConVar("xpm_default_infected_3", "1", "Sets the default infected for slot 3 when someone first logs in [1 = SMOKER, 2 = BOOMER, 3 = HUNTER, 4 = SPITTER, 5 = JOCKEY, 6 = CHARGER]", 0, true, 0.0, true, 1.0);
	HookConVarChange(g_hCVar_DefaultInfecttedSlot3, CVarChange_DefaultInfectedSlot3);
}

//Callback function for enabling or disabling the new vote winner sound
// public CVarChange_TalentSelectionMode(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
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
public CVarChange_DefaultSurvivor(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultSurvivor =  StringToInt(strNewValue)
	PrintToServer("[XPM] ConVar changed: Default Surivovor is now %i", strNewValue);
	PrintToChatAll("[XPM] ConVar changed: Default Surivovor is now %i", strNewValue);
}

//Callback function for updating the default infected
public CVarChange_DefaultInfectedSlot1(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultInfectedSlot1 =  StringToInt(strNewValue)
	PrintToServer("[XPM] ConVar changed: Default Infected Slot 1 is now %i", strNewValue);
	PrintToChatAll("[XPM] ConVar changed: Default Infected Slot 1 is now %i", strNewValue);
}

//Callback function for updating the default infected
public CVarChange_DefaultInfectedSlot2(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultInfectedSlot2 =  StringToInt(strNewValue)
	PrintToServer("[XPM] ConVar changed: Default Infected Slot 2 is now %i", strNewValue);
	PrintToChatAll("[XPM] ConVar changed: Default Infected Slot 2 is now %i", strNewValue);
}


//Callback function for updating the default infected
public CVarChange_DefaultInfectedSlot3(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	g_iDefaultInfectedSlot3 =  StringToInt(strNewValue)
	PrintToServer("[XPM] ConVar changed: Default Infected Slot 3 is now %i", strNewValue);
	PrintToChatAll("[XPM] ConVar changed: Default Infected Slot 3 is now %i", strNewValue);
}


