int GetPlayerHealth(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] == TEAM_SPECTATORS ||
		(g_iClientTeam[iClient] == TEAM_SURVIVORS &&
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1))
		return 0;

	// PrintToChatAll("GetPlayerHealth: %i", GetEntProp(iClient, Prop_Data, "m_iHealth"));
		
	return GetEntProp(iClient, Prop_Data, "m_iHealth");
}

int GetPlayerMaxHealth(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false)
		return 0;

	// PrintToChatAll("GetPlayerMaxHealth: %i", GetEntProp(iClient, Prop_Data, "m_iMaxHealth"));
		
	return GetEntProp(iClient, Prop_Data, "m_iMaxHealth");
}

bool SetPlayerHealth(int iClient, int iHealthAmount, bool bAdditive = false, bool bClampWithTempHealth = true)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] == TEAM_SPECTATORS ||
		(g_iClientTeam[iClient] == TEAM_SURVIVORS &&
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1))
		return false;

	// Clamp the health
	if (iHealthAmount < 0 && bAdditive == false)
		iHealthAmount = 0;
	
	int iMaxHealth = GetPlayerMaxHealth(iClient);
	int iTempHealth = GetSurvivorTempHealth(iClient);
	// Subtract temp health from MaxHealth to stop from going over
	if (bClampWithTempHealth && iTempHealth > 0)
		iMaxHealth = iMaxHealth - iTempHealth;

	// Add the health to existing health if its additive
	if (bAdditive)
		iHealthAmount += GetPlayerHealth(iClient);

	// Clamp the players health to their max health bounds, then set it
	SetEntProp(iClient, Prop_Data, "m_iHealth", iHealthAmount > iMaxHealth ? iMaxHealth : iHealthAmount);

	HandlePostSetPlayerHealth(iClient);

	return true;
}

bool SetPlayerMaxHealth(int iClient, int iHealthAmount, bool bAdditive = false, bool bAddHealthToFillGap = true)
{
	if (iHealthAmount <= 0 ||
		RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] == TEAM_SPECTATORS ||
		(g_iClientTeam[iClient] == TEAM_SURVIVORS &&
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1))
		return false;

	int iCurrentMaxHealth = GetPlayerMaxHealth(iClient);
	GetPlayerHealth(iClient);

	// Add the health to existing max health if its additive
	if (bAdditive)
		iHealthAmount += iCurrentMaxHealth;
	
	SetEntProp(iClient, Prop_Data, "m_iMaxHealth", iHealthAmount);

	// Clamp the players health to their new max health
	SetPlayerHealth(iClient, 0, true);

	// Give the player more health to fill in the gap created by giving max health
	if (bAddHealthToFillGap && iHealthAmount > iCurrentMaxHealth)
		SetPlayerHealth(iClient, iHealthAmount - iCurrentMaxHealth, true);

	GetPlayerMaxHealth(iClient);
	GetPlayerHealth(iClient);
	
	HandlePostSetPlayerHealth(iClient);
	
	return true;
}

void HandlePostSetPlayerHealth(int iClient)
{
	HandlePostSetPlayerHealth_Ellis(iClient);
}

void ResetTempHealthToSurvivor(iClient)
{
	if (!RunClientChecks(iClient) || 
		!IsPlayerAlive(iClient) || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1)
		return;
	
	SetEntPropFloat(iClient, Prop_Send, "m_healthBuffer", 0.0);
}

void AddTempHealthToSurvivor(int iClient, float fAdditionalTempHealth, bool bRespectMaxHealth = true)
{
	if (!RunClientChecks(iClient) || 
		!IsPlayerAlive(iClient) || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return;
	
	// Calculate the current survivors temp health
	new iTempHealth = GetSurvivorTempHealth(iClient);
	if (iTempHealth < 0)
		return;

	// Cap fAdditionalTempHealth to Max Health if option selected
	if (bRespectMaxHealth)
	{
		new iCurrentHealth = GetEntProp(iClient,Prop_Data,"m_iHealth");
		new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");

		// This will go over max health, so cap the additional amount given if true
		if (iCurrentHealth + iTempHealth + RoundToNearest(fAdditionalTempHealth) > iMaxHealth)
			fAdditionalTempHealth = float(iMaxHealth - iCurrentHealth - iTempHealth);
	}
	
	// If the temp health is not set or is expired (passed buffer time), then
	// reset the buffer time and set a new temp health buffer with the new value.
	// Else, simply add the additional health to the existing players temp health,
	// without resetting the time buffer.
	if (iTempHealth == 0)
	{
		SetEntPropFloat(iClient, Prop_Send, "m_healthBufferTime", GetGameTime());
		SetEntPropFloat(iClient, Prop_Send, "m_healthBuffer", fAdditionalTempHealth);
	}
	else
	{
		// Get the current health buffer and add the specified amount to it
		float fTempHealth = GetEntPropFloat(iClient, Prop_Send, "m_healthBuffer")
		fTempHealth += fAdditionalTempHealth;

		// Set it
		SetEntPropFloat(iClient, Prop_Send, "m_healthBuffer", fTempHealth);
	}
}

// This function calculates a survivors temp health, since there is no direct way to 
// obtain this information.  It takes health buffer ammount and subtracts the gametime minus
// buffer time times the decay rate for temp health.
int GetSurvivorTempHealth(int iClient)
{
	if (!RunClientChecks(iClient) || 
		!IsPlayerAlive(iClient) || 
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
		return -1;
	
	if (cvarPainPillsDecay == INVALID_HANDLE)
	{
		cvarPainPillsDecay = FindConVar("pain_pills_decay_rate");
		if (cvarPainPillsDecay == INVALID_HANDLE)
			return -1;
		
		HookConVarChange(cvarPainPillsDecay, OnPainPillsDecayChanged);
		flPainPillsDecay = cvarPainPillsDecay.FloatValue;
	}
	
	int tempHealth = RoundToCeil(GetEntPropFloat(iClient, Prop_Send, "m_healthBuffer") - ((GetGameTime() - GetEntPropFloat(iClient, Prop_Send, "m_healthBufferTime")) * flPainPillsDecay)) - 1;
	return tempHealth < 0 ? 0 : tempHealth;
}

// Action:TimerConvertAllSurvivorHealthToTemporary(Handle:timer, int iClient)
// {
// 	ConvertAllSurvivorHealthToTemporary(iClient);
// }

bool ConvertSomeSurvivorHealthToTemporary(int iClient, int iHealthConversionAmount)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1)
		return false;
	
	// Store current health numbers
	new iCurrentHealth = GetPlayerHealth(iClient);
	// new iTempHealth = GetSurvivorTempHealth(iClient);
	
	if (iCurrentHealth <= 1)
		return false;

	SetPlayerHealth(iClient, -1 * iHealthConversionAmount, true);
	AddTempHealthToSurvivor(iClient, float(iHealthConversionAmount));

	return true;
}

bool ConvertAllSurvivorHealthToTemporary(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS ||
		GetEntProp(iClient, Prop_Send, "m_isIncapacitated") == 1)
		return false;
	
	// Store current health numbers
	new iCurrentHealth = GetPlayerHealth(iClient);
	new iTempHealth = GetSurvivorTempHealth(iClient);
	// Change health to only be 1
	// Dont call SetPlayerHealth here, infinite loop because it calls this function
	SetEntProp(iClient, Prop_Data, "m_iHealth", 1);
	// Change temp health to self revive health
	if (iCurrentHealth > 1)
	{
		ResetTempHealthToSurvivor(iClient);
		AddTempHealthToSurvivor(iClient, float(iCurrentHealth + iTempHealth));
	}

	return true;
}

HealClientFully(iClient)
{
	if (RunClientChecks(iClient) == false || IsPlayerAlive(iClient) == false)
		return;

	RunCheatCommand(iClient, "give", "give health");
	ResetTempHealthToSurvivor(iClient);

	g_bIsClientDown[iClient] = false;
	
	// new iMaxHealth = GetEntProp(iClient,Prop_Data,"m_iMaxHealth");
	// SetEntProp(iClient, Prop_Data, "m_iHealth", iMaxHealth);
}

HealAllSurvivorsFully()
{
	for(new i=1;i <= MaxClients;i++)
	{
		if (RunClientChecks(i) && 
			IsPlayerAlive(i) && 
			g_iClientTeam[i] == TEAM_SURVIVORS)
			HealClientFully(i);
	}
}