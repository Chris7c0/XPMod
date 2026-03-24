void Bind1Press_Zoey(int iClient)
{
	if (RunClientChecks(iClient) == false || IsFakeClient(iClient) == true)
		return;

	if (IsZoeyMedicalExpertiseActive(iClient) == false)
	{
		PrintHintText(iClient, "You possess no talent for Bind 1.");
		return;
	}

	if (IsZoeyClientDownedOrHanging(iClient) == true || IsClientGrappled(iClient) == true)
	{
		PrintHintText(iClient, "Sacrificial Aid cannot be used while downed, hanging, or grappled.");
		return;
	}

	float fCooldownRemaining = GetZoeySacrificialAidGlobalCooldownRemaining();
	if (fCooldownRemaining > 0.0)
	{
		PrintHintText(iClient, "Sacrificial Aid cooling down: %0.0f seconds", fCooldownRemaining);
		return;
	}

	int iTarget = -1;
	GetZoeySacrificialAidTarget(iClient, iTarget);

	ZoeySacrificialAidMenuDraw(iClient, iTarget);
}

Action ZoeySacrificialAidMenuDraw(int iClient, int iTarget)
{
	if (RunClientChecks(iClient) == false ||
		IsPlayerAlive(iClient) == false ||
		g_iClientTeam[iClient] != TEAM_SURVIVORS)
	{
		return Plugin_Handled;
	}

	bool bHasTarget = RunClientChecks(iTarget) &&
		IsPlayerAlive(iTarget) == true &&
		g_iClientTeam[iTarget] == TEAM_SURVIVORS;

	g_iZoeySacrificialAidMenuTarget[iClient] = bHasTarget ? iTarget : -1;

	Menu menu = CreateMenu(ZoeySacrificialAidMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char text[512];
	char strTargetLine[64];
	if (bHasTarget)
		FormatEx(strTargetLine, sizeof(strTargetLine), "Target: %N", iTarget);
	else
		FormatEx(strTargetLine, sizeof(strTargetLine), "Target: None");

	FormatEx(text, sizeof(text), "\
		\n \
		\n      Sacrificial Aid\
		\n========================\
		\n %s\
		\n Current Max HP: %d\
		\n========================\
		\n ",
		strTargetLine,
		GetPlayerMaxHealth(iClient));
	SetMenuTitle(menu, "%s", text);

	FormatEx(text, sizeof(text), "-5 Max HP: Heal 30 HP\n    Downed: Stop Bleedout 10s\n ");
	AddMenuItem(menu, "5", text, bHasTarget ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);

	FormatEx(text, sizeof(text), "-10 Max HP: Give 70 Temp HP\n    Downed: Stop Bleedout 20s\n ");
	AddMenuItem(menu, "10", text, bHasTarget ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);

	FormatEx(text, sizeof(text), "-15 Max HP: Regen 20 HP/s (5s)\n    Downed: Instant Pickup\n ");
	AddMenuItem(menu, "15", text, bHasTarget ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);

	FormatEx(text, sizeof(text), "-20 Max HP: Gain a Defibrillator\n ");
	AddMenuItem(menu, "20", text);

	FormatEx(text, sizeof(text), "-40 Max HP: Survivor Resurrection\n ");
	AddMenuItem(menu, "40", text);

	AddMenuItem(menu, "cancel", "Cancel\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

void ZoeySacrificialAidMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
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

		char strInfo[32];
		GetMenuItem(menu, itemNum, strInfo, sizeof(strInfo));

		if (StrEqual(strInfo, "cancel", false))
			return;

		if (StrEqual(strInfo, "40", false))
		{
			if (TryUseZoeySacrificialAidResurrection(iClient) == false)
				ZoeySacrificialAidMenuDraw(iClient, g_iZoeySacrificialAidMenuTarget[iClient]);
			return;
		}

		if (StrEqual(strInfo, "20", false))
		{
			if (TryUseZoeySacrificialAidDefibrillator(iClient) == false)
				ZoeySacrificialAidMenuDraw(iClient, g_iZoeySacrificialAidMenuTarget[iClient]);
			return;
		}

		int iTarget = g_iZoeySacrificialAidMenuTarget[iClient];
		if (RunClientChecks(iTarget) == false ||
			IsPlayerAlive(iTarget) == false ||
			g_iClientTeam[iTarget] != TEAM_SURVIVORS)
		{
			PrintHintText(iClient, "Sacrificial Aid target is no longer valid.");
			return;
		}

		int iCost = StringToInt(strInfo);
		if (TryUseZoeySacrificialAid(iClient, iTarget, iCost) == false)
		{
			ZoeySacrificialAidMenuDraw(iClient, iTarget);
		}
	}
}
