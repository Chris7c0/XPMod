//Callback function for enabling or disabling the new vote winner sound
public CVarChange_TalentSelectionMode(Handle:hCVar, const String:strOldValue[], const String:strNewValue[])
{
	//If the value was not changed, then do nothing
	if(StrEqual(strOldValue, strNewValue) == true)
		return;
	
	//If the value was changed, then set it and display a message to the server and players
	if (StringToInt(strNewValue) == 1)
	{
		g_iTalentSelectionMode = CONVAR_WEBSITE;
		PrintToServer("[XPM] ConVar changed: Talent Selection Mode is now WEBSITE");
		PrintToChatAll("[XPM] ConVar changed: Talent Selection Mode is now WEBSITE");
	}
	else
	{
		g_iTalentSelectionMode = CONVAR_MENU;
		PrintToServer("[XPM] ConVar changed: Talent Selection Mode is now MENU");
		PrintToChatAll("[XPM] ConVar changed: Talent Selection Mode is now MENU");
	}
}