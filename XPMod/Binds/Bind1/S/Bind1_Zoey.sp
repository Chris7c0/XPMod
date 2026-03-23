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

	int iTarget;
	if (GetZoeySacrificialAidTarget(iClient, iTarget) == false)
	{
		PrintHintText(iClient, "Aim at a visible teammate to use Sacrificial Aid.");
		return;
	}

	ZoeySacrificialAidMenuDraw(iClient, iTarget);
}

Action ZoeySacrificialAidMenuDraw(int iClient, int iTarget)
{
	if (RunClientChecks(iClient) == false ||
		RunClientChecks(iTarget) == false ||
		IsPlayerAlive(iTarget) == false ||
		g_iClientTeam[iTarget] != TEAM_SURVIVORS)
	{
		return Plugin_Handled;
	}

	g_iZoeySacrificialAidMenuTarget[iClient] = iTarget;

	bool bTargetDowned = IsZoeySacrificialAidTargetDowned(iTarget);
	Menu menu = CreateMenu(ZoeySacrificialAidMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char text[512];
	FormatEx(text, sizeof(text), "\
		\n \
		\n      Sacrificial Aid\
		\n========================\
		\n Target: %N\
		\n Current Max HP: %d\
		\n========================\
		\n ",
		iTarget,
		GetPlayerMaxHealth(iClient));
	SetMenuTitle(menu, "%s", text);

	FormatEx(text, sizeof(text), "%s\n ", bTargetDowned ? "-15 Max HP: Instant Pickup" : "-15 Max HP: Heal 100 HP");
	AddMenuItem(menu, "15", text);

	FormatEx(text, sizeof(text), "%s\n ", bTargetDowned ? "-10 Max HP: Stop Bleedout 20s" : "-10 Max HP: Give 70 Temp HP");
	AddMenuItem(menu, "10", text);

	FormatEx(text, sizeof(text), "%s\n ", bTargetDowned ? "-5 Max HP: Stop Bleedout 10s" : "-5 Max HP: Heal 30 HP");
	AddMenuItem(menu, "5", text);

	AddMenuItem(menu, "rescan", "Retarget\n ");
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

		if (StrEqual(strInfo, "rescan", false))
		{
			int iRetarget;
			if (GetZoeySacrificialAidTarget(iClient, iRetarget))
			{
				ZoeySacrificialAidMenuDraw(iClient, iRetarget);
			}
			else
			{
				PrintHintText(iClient, "Aim at a visible teammate to use Sacrificial Aid.");
			}
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
