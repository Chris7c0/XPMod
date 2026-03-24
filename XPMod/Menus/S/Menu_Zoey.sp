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
			\n +25%% Movement Speed While Holding A Healing Item\
			\n Zoey Deals No Friendly Fire Damage\
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
	else if (iTalentIndex == 1)
	{
		FormatEx(text, sizeof(text), "\
			%s\t\t%s:\
			\n \
			\n Removes The Ability To Hold A Primary Weapon\
			\n Dual Pistols Become Automatic Explosive Machine Pistols\
			\n - 120 Clip Size\
			\n - Bullets Explode\
			\n - One-Shots Common Infected\
			\n - Increased Damage To Special Infected\
			\n \
			\n Melee Swap\
			\n - Pick Up A Melee Weapon To Stash It\
			\n - Press [WALK] + [ZOOM] To Swap Between Melee And Machine Pistols\
			\n - Ammo Is Saved When Swapping\
			\n \
			\n Mop 'Til They Drop\
			\n - Gain 1 Charge Per 5 Machine-Pistol Hits On CI/SI\
			\n - Press [WALK] + [USE] To Arm\
			\n - Next Shot Marks A Target And Kills Nearby CI Equal To Stored Charge\
			\n ",
			strStartingNewLines,
			strTalentName);
	}
	else if (iTalentIndex == 2)
	{
		FormatEx(text, sizeof(text), "\
			%s\t\t%s:\
			\n \
			\n +5%% Movement Speed\
			\n +100 Incap Health (Team Shared, Does Not Stack With Other Zoeys)\
			\n +15%% Damage Reduction While Incapacitated\
			\n \
			\n While Holding A Medkit Press [WALK] + [USE] To Start\
			\n - Keep The Medkit Out For Up To 20 Seconds\
			\n - Switch Off The Medkit To Activate\
			\n - Reveal Visible SI Ghost Locations With A Smoke Mist For The Stored Duration\
			\n - 3 Minute Global Cooldown\
			\n ",
			strStartingNewLines,
			strTalentName);
	}
	else if (iTalentIndex == 3)
	{
		FormatEx(text, sizeof(text), "\
			%s\t\t%s:\
			\n \
			\n Zoey's Healing Splashes To Nearby Teammates\
			\n - Aura Radius Scales From 7 To 15 Feet\
			\n - Does Not Heal Zoey\
			\n - Direct Medkit Target Does Not Receive Extra Splash Healing\
			\n \
			\n Shared Healing Scales By Talent Level:\
			\n - Medkits Share Up To 25%%%% Permanent Health\
			\n - Pills Share Up To 50%%%% Permanent Health\
			\n - Adrenaline Shares Up To 80%%%% Permanent Health\
			\n ",
			strStartingNewLines,
			strTalentName);
	}
	else if (iTalentIndex == 4)
	{
		FormatEx(text, sizeof(text), "\
			%s\t\t%s:\
			\n \
			\n +25%% Healing Item Use Speed\
			\n +50%% Medkit Healing\
			\n +40%% Pills Healing\
			\n +60%% Adrenaline Healing\
			\n \
			\n Scrap Recycle:\
			\n - After 4 teammate pickups gain +1 Medkit\
			\n - After 2 teammate pickups gain +1 Pills\
			\n - Team bile duration reduced by 50%%\
			\n \
			\n Bind 1: Sacrificial Aid\
			\n - Aim at a visible teammate and choose a sacrifice\
			\n - 10 second global cooldown\
			\n - -15 Max HP: Heal 100 HP or instantly pick up a downed ally\
			\n - -10 Max HP: Give 70 temp HP or stop bleedout for 20 seconds\
			\n - -5 Max HP: Heal 30 HP or stop bleedout for 10 seconds\
			\n ",
			strStartingNewLines,
			strTalentName);
	}
	else
	{
		FormatEx(text, sizeof(text), "\
			%s\t\t%s:\
			\n \
			\n +40%% Medkit Use Speed\
			\n +5%% Movement Speed Per Downed Survivor\
			\n - Max +15%% movement speed\
			\n \
			\n Bind 2: Instant Intervention\
			\n - +1 use every other level, max 3\
			\n - Choose a teammate, then hold [WALK] to teleport\
			\n - Cannot be used while grappled or downed\
			\n - 2 minute global cooldown\
			\n \
			\n On arrival:\
			\n - Zoey gains 33%% damage reduction for 7 seconds\
			\n - Zoey gains +25%% revive speed for 7 seconds\
			\n - Drops a 10 second healing circle for nearby survivors\
			\n - Instantly picks up one downed survivor in the circle\
			\n - Kills all common infected within 4 meters\
			\n ",
			strStartingNewLines,
			strTalentName);
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
