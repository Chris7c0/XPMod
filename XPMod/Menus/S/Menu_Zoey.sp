//Zoey Menu////////////////////////////////////////////////////////////////

static void GetZoeyTalentName(int iTalentIndex, char[] strTalentName, int iMaxLen)
{
	switch (iTalentIndex)
	{
		case 0: strcopy(strTalentName, iMaxLen, "Resilient Resuscitation");
		case 1: strcopy(strTalentName, iMaxLen, "Trigger Happy");
		case 2: strcopy(strTalentName, iMaxLen, "Survivor's Will");
		case 3: strcopy(strTalentName, iMaxLen, "Sharing Is Caring");
		case 4: strcopy(strTalentName, iMaxLen, "Medical Expertise (Bind 1)");
		case 5: strcopy(strTalentName, iMaxLen, "Instant Intervention (Bind 2)");
		default: strcopy(strTalentName, iMaxLen, "Zoey Talent");
	}
}

static int GetZoeyTalentLevel(int iClient, int iTalentIndex)
{
	switch (iTalentIndex)
	{
		case 0: return g_iZoeyTalent1Level[iClient];
		case 1: return g_iZoeyTalent2Level[iClient];
		case 2: return g_iZoeyTalent3Level[iClient];
		case 3: return g_iZoeyTalent4Level[iClient];
		case 4: return g_iZoeyTalent5Level[iClient];
		case 5: return g_iZoeyTalent6Level[iClient];
	}

	return 0;
}

Action ZoeyMenuDraw(int iClient)
{
	char text[512];

	Menu menu = CreateMenu(ZoeyMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	FormatEx(text, sizeof(text), "%sLevel %d\tXP: %d/%d\n=\t=\t=\t=\t=\t=\t=\t=\t=\t=\t=\t=\n \n\t\tZoey's Medic Talents\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, "%s", text);

	for (int iTalentIndex = 0; iTalentIndex < 6; iTalentIndex++)
	{
		char strTalentName[64];
		GetZoeyTalentName(iTalentIndex, strTalentName, sizeof(strTalentName));
		FormatEx(text, sizeof(text), "\t[Level %d]\t%s", GetZoeyTalentLevel(iClient, iTalentIndex), strTalentName);
		AddMenuItem(menu, "option", text);
	}

	AddMenuItem(menu, "option7", "Open In Website\n ");
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\n \n=\t=\t=\t=\t=\t=\t=\t=\t=\t=\t=\t=\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

Action ZoeyTalentInfoMenuDraw(int iClient, int iTalentIndex)
{
	char strTalentName[64];
	GetZoeyTalentName(iTalentIndex, strTalentName, sizeof(strTalentName));

	char strStartingNewLines[32], strEndingNewLines[32], text[512];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	Menu menu = CreateMenu(ZoeyTalentInfoMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	if (iTalentIndex == 0)
	{
		FormatEx(text, sizeof(text), "\
			%s\t\t%s:\
			\n \
			\n +40%% Revive Speed\
			\n +20%% Movement Speed While Holding A Healing Item\
			\n \
			\n Revive Bonuses:\
			\n - Revived Ally Gains +20%% Damage Reduction For 7 Seconds\
			\n - Revives Are Not Interrupted By Common Infected Hits\
			\n - Revived Allies Return With Permanent Health Instead Of Temporary Health\
			\n \
			\n Zoey Gains No Buff From Max HP Increases\
			\n ",
			strStartingNewLines,
			strTalentName);
	}
	else
	{
		FormatEx(text, sizeof(text), "\
			%s\t\t%s (Level %d):\
			\n \
			\n Zoey's gameplay scaffolding is in place.\
			\n Ability behavior for this talent is not implemented yet.\
			\n \
			\n This slot is reserved for future Medic work.\
			\n ",
			strStartingNewLines,
			strTalentName,
			GetZoeyTalentLevel(iClient, iTalentIndex));
	}
	SetMenuTitle(menu, "%s", text);

	char strItemData[8];
	IntToString(iTalentIndex, strItemData, sizeof(strItemData));

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, strItemData, strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

void ZoeyMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if (itemNum >= 0 && itemNum <= 5)
		{
			ZoeyTalentInfoMenuDraw(iClient, itemNum);
			return;
		}

		if (itemNum == 8)
			TopSurvivorMenuDraw(iClient);
	}
}

void ZoeyTalentInfoMenuHandler(Menu menu, MenuAction action, int iClient, int itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		ZoeyMenuDraw(iClient);
	}
}
