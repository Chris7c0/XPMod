void Bind2Press_Zoey(int iClient)
{
	if (RunClientChecks(iClient) == false ||
		IsFakeClient(iClient) == true ||
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
	{
		return;
	}

	if (g_iZoeyTalent6Level[iClient] <= 0)
	{
		PrintHintText(iClient, "You possess no talent for Bind 2.");
		return;
	}

	if (IsZoeyClientDownedOrHanging(iClient) == true || IsClientGrappled(iClient) == true)
	{
		PrintHintText(iClient, "Instant Intervention cannot be used while downed, hanging, or grappled.");
		return;
	}

	if (g_iClientBindUses_2[iClient] >= 3)
	{
		PrintHintText(iClient, "You are out of Instant Intervention uses.");
		return;
	}

	float fCooldownRemaining = GetZoeyInstantInterventionGlobalCooldownRemaining();
	if (fCooldownRemaining > 0.0)
	{
		PrintHintText(iClient, "Instant Intervention cooling down: %0.0f seconds", fCooldownRemaining);
		return;
	}

	ZoeyInstantInterventionMenuDraw(iClient);
}

Action ZoeyInstantInterventionMenuDraw(int iClient)
{
	Menu menu = CreateMenu(ZoeyInstantInterventionMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char text[512];
	FormatEx(text, sizeof(text), "\
		\n \
		\n    Instant Intervention\
		\n========================\
		\n Uses Remaining: %d\
		\n========================\
		\n Choose a teammate\
		\n ",
		3 - g_iClientBindUses_2[iClient]);
	SetMenuTitle(menu, "%s", text);

	bool bFoundTarget = false;
	for (int iTarget = 1; iTarget <= MaxClients; iTarget++)
	{
		if (iTarget == iClient ||
			RunClientChecks(iTarget) == false ||
			IsPlayerAlive(iTarget) == false ||
			g_iClientTeam[iTarget] != TEAM_SURVIVORS)
		{
			continue;
		}

		char strInfo[16];
		IntToString(GetClientUserId(iTarget), strInfo, sizeof(strInfo));

		char strStatus[16];
		if (IsZoeySacrificialAidTargetHanging(iTarget))
			strcopy(strStatus, sizeof(strStatus), " [LEDGE]");
		else if (IsIncap(iTarget))
			strcopy(strStatus, sizeof(strStatus), " [DOWN]");
		else
			strcopy(strStatus, sizeof(strStatus), "");

		FormatEx(text, sizeof(text), "%N%s", iTarget, strStatus);
		AddMenuItem(menu, strInfo, text);
		bFoundTarget = true;
	}

	if (bFoundTarget == false)
	{
		delete menu;
		PrintHintText(iClient, "No valid teammate is available for Instant Intervention.");
		return Plugin_Handled;
	}

	AddMenuItem(menu, "cancel", "Cancel\n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

void ZoeyInstantInterventionMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if (RunClientChecks(iClient) == false ||
			IsPlayerAlive(iClient) == false ||
			g_iClientTeam[iClient] != TEAM_SURVIVORS ||
			IsFakeClient(iClient) == true)
		{
			return;
		}

		char strInfo[16];
		GetMenuItem(menu, itemNum, strInfo, sizeof(strInfo));
		if (StrEqual(strInfo, "cancel", false))
		{
			g_iZoeyInstantInterventionTargetUserId[iClient] = 0;
			g_bZoeyInstantInterventionWalkHeld[iClient] = false;
			return;
		}

		int iTarget = GetClientOfUserId(StringToInt(strInfo));
		if (RunClientChecks(iTarget) == false ||
			IsPlayerAlive(iTarget) == false ||
			g_iClientTeam[iTarget] != TEAM_SURVIVORS ||
			iTarget == iClient)
		{
			PrintHintText(iClient, "That teammate is no longer a valid target.");
			return;
		}

		g_iZoeyInstantInterventionTargetUserId[iClient] = GetClientUserId(iTarget);
		g_bZoeyInstantInterventionWalkHeld[iClient] = false;
		PrintHintText(iClient, "Instant Intervention target: %N\nHold WALK to teleport.", iTarget);
	}
}
