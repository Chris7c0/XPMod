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
	Menu menu = CreateMenu(ZoeyMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char text[512], strStartingNewLines[32], strEndingNewLines[32], strNewLines[512];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	FormatEx(text, sizeof(text), "%sLevel %d	XP: %d/%d\n=	=	=	=	=	=	=	=	=	=	=\n \nZoey's Medic Talents\n ", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient]);
	SetMenuTitle(menu, "%s", text);
	GetNewLinesAutomatic(text, strNewLines, 7+2);

	for (int iTalentIndex = 0; iTalentIndex < 6; iTalentIndex++)
	{
		char strTalentName[64];
		GetZoeyTalentName(iTalentIndex, strTalentName, sizeof(strTalentName));
		FormatEx(text, sizeof(text), "[Level %d] %s", GetZoeyTalentLevel(iClient, iTalentIndex), strTalentName);
		AddMenuItem(menu, "option", text);
	}

	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\n \n=	=	=	=	=	=	=	=	=	=	=\
		%s%s",
		strNewLines,
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

	char strStartingNewLines[32], strEndingNewLines[32], text[512], strNewLines[512];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);

	Menu menu = CreateMenu(ZoeyTalentInfoMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	if (iTalentIndex == 0)
	{
		FormatEx(text, sizeof(text), "\
			%s%s\
			\n \
			\n+40%% Revive Speed\
			\n+25%% Movement Speed While Holding A Healing Item\
			\nZoey Deals No Friendly Fire Damage\
			\n \
			\nRevive Bonuses:\
			\n	Revived Ally Gets +20%% Damage Reduction For 7 Seconds\
			\n	Revived Ally Gets Permanent Health Instead Of Temp Health\
			\n \
			\nZoey Gains No Buff From Max HP Increases\
			\n ",
			strStartingNewLines,
			strTalentName);
		GetNewLinesAutomatic(text, strNewLines);
	}
	else if (iTalentIndex == 1)
	{
		FormatEx(text, sizeof(text), "\
			%s%s:\
			\n \
			\nRemoves Primary Weapons\
			\nGain Automatic Explosive Machine Pistol\
			\n	120 Clip Size\
			\n	Bullets Explode\
			\n	OneShots CI\
			\n	+150%% Dmg to SI\
			\n \
			\nPistol Melee Swap\
			\n	Pick Up A Melee Weapon To Stash It\
			\n	Press [WALK] + [ZOOM] To Swap Between Them\
			\n \
			\nMop 'Til They Drop\
			\n	Gain 1 Charge Per 3 Pistol Hits\
			\n	Press [WALK] + [USE] To Arm\
			\n	Armed CI Shot Kills Nearby CI Equal To Stored Charge\
			\n ",
			strStartingNewLines,
			strTalentName);
		GetNewLinesAutomatic(text, strNewLines);
	}
	else if (iTalentIndex == 2)
	{
		FormatEx(text, sizeof(text), "\
			%s%s\
			\n \
			\n+5%% Movement Speed\
			\n+100 Incap Health (Team Shared, Does Not Stack With Other Zoeys)\
			\n+15%% Damage Reduction While Incapacitated\
			\n \
			\nWhile Holding A Medkit Press [WALK] + [USE] To Start\
			\n	Keep The Medkit Out For Up To 20 Seconds\
			\n	Switch Off The Medkit To Activate\
			\n	Reveal SI Ghost Locations With Smoke Mist For Stored Duration\
			\n	3 Minute Global Cooldown\
			\n ",
			strStartingNewLines,
			strTalentName);
		GetNewLinesAutomatic(text, strNewLines);
	}
	else if (iTalentIndex == 3)
	{
		FormatEx(text, sizeof(text), "\
			%s%s\
			\n \
			\nZoey's Healing Splashes To Nearby Teammates\
			\n	15 Foot Aura Radius\
			\n	Does Not Heal Zoey\
			\n	Direct Medkit Target Does Not Get Splash Healing\
			\n \
			\nStash 2 Extra Medkits/Defibrillators\
			\n	Press [WALK] + [ZOOM] While Equipped To Cycle Them\
			\n \
			\nShared Healing:\
			\n	Medkits Share 25%% Permanent Health\
			\n	Pills Share 30%% Permanent Health\
			\n	Adrenaline Shares 50%% Permanent Health\
			\n ",
			strStartingNewLines,
			strTalentName);
		GetNewLinesAutomatic(text, strNewLines);
	}
	else if (iTalentIndex == 4)
	{
		FormatEx(text, sizeof(text), "\
			%s%s\
			\n \
			\n+50%% Medkit Healing\
			\n+40%% Pills Healing\
			\n+60%% Adrenaline Healing\
			\n-50%% Team Bile Duration\
			\n \
			\nScrap Recycle:\
			\n	2 Revives: +1 Pills\
			\n	4 Revives: +1 Medkit\
			\n \
			\nBind 1: Sacrificial Aid\
			\n	Target Player to Open Sacrifice Menu\
			\n	Lose MaxHP For:\
			\n	 -5: +30 HP/Stop Bleedout 10s\
			\n	-10: +70 TempHP/Stop Bleedout 20s\
			\n	-15: +100 HP/Revive Ally\
			\n	-20: +1 Defib\
			\n	-40: Resurrect Ally (1 Use)\
			\n ",
			strStartingNewLines,
			strTalentName);
		GetNewLinesAutomatic(text, strNewLines);
	}
	else
	{
		FormatEx(text, sizeof(text), "\
			%s%s\
			\n \
			\n+40%% Medkit Use Speed\
			\n+5%% Movement Speed per Downed Ally (Max 15%%)\
			\n \
			\nBind 2: Instant Intervention\
			\n	Choose Ally, Then Tap [WALK] to Teleport\
			\n	2 Minute Global Cooldown\
			\n \
			\nOn Arrival:\
			\n	33%% Damage Reduction for 7s\
			\n	+25%% Revive Speed for 7s\
			\n	Drops a Healing Circle for Survivors\
			\n	Instantly Revives 1 Downed Ally\
			\n	Kills All CI Within 10ft\
			\n ",
			strStartingNewLines,
			strTalentName);
		GetNewLinesAutomatic(text, strNewLines);
	}
	SetMenuTitle(menu, "%s", text);

	char strItemData[8];
	IntToString(iTalentIndex, strItemData, sizeof(strItemData));

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		\n %s%s",
		strNewLines,
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
