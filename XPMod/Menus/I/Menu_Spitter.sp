//Spitter Menu

//Spitter Menu Draw
Action SpitterTopMenuDraw(iClient)
{
	CheckLevel(iClient);
	DeleteAllMenuParticles(iClient);
	Menu menu = CreateMenu(SpitterTopMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	char title[256];
	FormatEx(title, sizeof(title), "%sLevel %d	XP: %d/%d\n==============================\nSpitter Talents:\n==============================\n \nPuppet Master: Level %d\nMaterial Girl: Level %d\nHallucinogenic Nightmare: Level %d\n \n", strStartingNewLines, g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iPuppetLevel[iClient], g_iMaterialLevel[iClient], g_iHallucinogenicLevel[iClient]);
	SetMenuTitle(menu, title);
	
	AddMenuItem(menu, "option1", "Puppet Master");
	AddMenuItem(menu, "option2", "Material Girl");
	AddMenuItem(menu, "option3", "Hallucinogenic Nightmare\n ");
	AddMenuItem(menu, "option4", "Choose The Spitter\n ");
	AddMenuItem(menu, "option5", "Open In Website\n ");
	
	AddMenuItem(menu, "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(menu, "option8", "", ITEMDRAW_NOTEXT);

	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		\n==============================\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option9", strFinalOptionText);

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Talent Draws///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Ground 'n Pound Menu Draw
Action PuppetMenuDraw(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(PuppetMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s  						Puppet Master (Level %d)\
		\n \
		\nLevel 1:\
		\nSpawn in with +1 CI per level\
		\nWhen incaping a player, spawn +1 CI every other level on the victim\
		\n25%% chance on hit to slow survivors by 2%%, 4%%, or 6%% per level\
		\n \
		\nLevel 6:\
		\nFlaming Goo: A blanket of fire lies over your spit\
		\n \
		\nPress [WALK] to change Goo Types\
		\n ",
		strStartingNewLines,
		g_iPuppetLevel[iClient]);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Spiked Carapace Menu Draw
Action MaterialMenuDraw(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(MaterialMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s				Material Girl (Level %d)\
		\n \
		\nLevel 1:\
		\nIf spit hits incaped player:\
		\nCloak victim +10%% per level\
		\nHide victims' glow\
		\n \
		\nSpawn 1 random UI on spit (2 at Lvl 10)\
		\nMelting Goo: +2 spit dmg\
		\nDmg converts health to temp health\
		\n \
		\nLevel 6:\
		\nDemi Goo: Triples victims gravity and\
		\nrestricts mobility talents\
		\n \
		\nPress [WALK] to change Goo Types\
		\n \
		\n				Bind 1: Bag of Spits\
		\n \
		\nSelect from unique Enhanced CI mobs\
		\nConjure them on your next spit\
		\n ",
		strStartingNewLines,
		g_iMaterialLevel[iClient]);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Hillbilly Madness! Menu Draw
Action HallucinogenicMenuDraw(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(HallucinogenicMenuHandler);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	SetMenuTitle(menu, "\
		%s				Hallucinogenic Nightmare (Level %d)\
		\n \
		\nLevel 1:\
		\n-0.5s spit cooldown per level\
		\nHold [CROUCH] to Phase Shift (stealth and speed)\
		\nClaws drug your victim, causing hallucinations\
		\nRepulsion Goo: Bounces victims in 1 of 9 directions\
		\n \
		\nLevel 6:\
		\nViral Goo: Infect victims with a contagious virus\
		\n \
		\nPress [WALK] to change Goo Types\
		\n \
		\n \
		\n						Bind 2: Sisterhood\
		\n					3 uses; 3 minute cooldown\
		\n \
		\nConjure a disguised witch\
		\n ",
		strStartingNewLines,
		g_iHallucinogenicLevel[iClient]);
	
	char strFinalOptionText[250];
	Format(strFinalOptionText, sizeof(strFinalOptionText),
		"Back\
		%s\n \n \n \n \n \n \n \n \n \n \n \n \n \n ",
		strEndingNewLines);
	AddMenuItem(menu, "option1", strFinalOptionText);
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Spitter Menu Draw
Action ChooseSpitterClassMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	
	CheckLevel(iClient);
	Menu menu = CreateMenu(ChooseSpitterClassMenuHandler);
	SetMenuPagination(menu, MENU_NO_PAGINATION);

	char strStartingNewLines[32], strEndingNewLines[32];
	GetNewLinesToPushMenuDown(iClient, strStartingNewLines);
	GetNewLinesToPushMenuUp(iClient, strEndingNewLines);
	
	char title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Spitter:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	
	SetMenuTitle(menu, title);
	
	AddMenuItem(menu, "option1", "Replace Class 1");
	AddMenuItem(menu, "option2", "Replace Class 2");
	AddMenuItem(menu, "option3", "Replace Class 3");
	AddMenuItem(menu, "option9", "Back");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

Action GooTypeMenuDraw(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(GooTypeMenuHandler);
	
	SetMenuTitle(menu, "Choose your Goo Type!"); 
	if(g_iPuppetLevel[iClient] > 5 && g_iMaterialLevel[iClient] < 1)
	{
		AddMenuItem(menu, "option1", "Flaming Goo");
	}
	else if(g_iMaterialLevel[iClient] > 0 && g_iMaterialLevel[iClient] < 6)
	{
		AddMenuItem(menu, "option1", "Flaming Goo");
		AddMenuItem(menu, "option2", "Melting Goo");
	}
	else if(g_iMaterialLevel[iClient] > 5 && g_iHallucinogenicLevel[iClient] < 1)
	{
		AddMenuItem(menu, "option1", "Flaming Goo");
		AddMenuItem(menu, "option2", "Melting Goo");
		AddMenuItem(menu, "option3", "Demi Goo");
	}
	else if(g_iHallucinogenicLevel[iClient] > 0 && g_iHallucinogenicLevel[iClient] < 6)
	{
		AddMenuItem(menu, "option1", "Flaming Goo");
		AddMenuItem(menu, "option2", "Melting Goo");
		AddMenuItem(menu, "option3", "Demi Goo");
		AddMenuItem(menu, "option4", "Repulsion Goo");
	}
	else if(g_iHallucinogenicLevel[iClient] > 5)
	{
		AddMenuItem(menu, "option1", "Flaming Goo");
		AddMenuItem(menu, "option2", "Melting Goo");
		AddMenuItem(menu, "option3", "Demi Goo");
		AddMenuItem(menu, "option4", "Repulsion Goo");
		AddMenuItem(menu, "option5", "Viral Goo");
	}
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


Action BagOfSpitsMenuDraw(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(BagOfSpitsMenuHandler);
	
	SetMenuTitle(menu, "Pull something nice from your Bag of Spits!\n "); 

	AddMenuItem(menu, "option1",
		"MINI ARMY\
		\n	A dozen very tiny, very annoying, enhanced infected.");
	AddMenuItem(menu, "option2", 
		"MUSCLE CREW\
		\n	Six roided out infected...lookin' for brainz gainz.");
	AddMenuItem(menu, "option3", 
		"ENHANCED JIMMY\
		\n	Big and Enhanced, for your pleasure.");
	AddMenuItem(menu, "option4", 
		"NECROFEASTERS\
		\n	They brought friends, and are ready for seconds.");
	AddMenuItem(menu, "option5", 
		"KILLER KLOWNS FROM OUTER SPACE\
		\n	Alien bozos with an appetite for close encounters.");

	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}
//Handlers/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Spitter Top Menu Handler
SpitterTopMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Ground 'n Pound
			{
				PuppetMenuDraw(iClient);
			}
			case 1: //Spiked Carapace
			{
				MaterialMenuDraw(iClient);
			}
			case 2: //Hillbilly Madness!
			{
				HallucinogenicMenuDraw(iClient);
			}
			case 3: //Select This Class
			{
				if((g_iClientInfectedClass1[iClient] != SPITTER) && (g_iClientInfectedClass2[iClient] != SPITTER) && (g_iClientInfectedClass3[iClient] != SPITTER))
				{
					if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
						ChooseSpitterClassMenuDraw(iClient);
					else
					{
						PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
						SpitterTopMenuDraw(iClient);
					}
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04Spitter\x05 as one of your classes.");
					SpitterTopMenuDraw(iClient);
				}
			}
			case 4: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/infected/ceda%20files/spitter/xpmod_ig_talents_infected_spitter.html", MOTDPANEL_TYPE_URL);
				SpitterTopMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}

//Ground 'n Pound Menu Handler
PuppetMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				SpitterTopMenuDraw(iClient);
			}
		}
	}
}

//Spiked Carapace Menu Handler
MaterialMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				SpitterTopMenuDraw(iClient);
			}
		}
	}
}

//Hillbilly Madness! Menu Handler
HallucinogenicMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				SpitterTopMenuDraw(iClient);
			}
		}
	}
}

//Choose Spitter Top Menu Handler
ChooseSpitterClassMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Replace Class 1
			{
				if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass1[iClient]);
					SetInfectedClassSlot(iClient, 1, SPITTER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 1\x05 with the \x04Spitter\x05.");
					SpitterTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 1\x05 because it has already been confirmed.");
					ChooseSpitterClassMenuDraw(iClient);
				}
			}
			case 1: //Replace Class 2
			{
				if(g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, SPITTER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 2\x05 with the \x04Spitter\x05.");
					SpitterTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 2\x05 because it has already been confirmed.");
					ChooseSpitterClassMenuDraw(iClient);
				}
			}
			case 2: //Replace Class 3
			{
				if(g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, SPITTER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 3\x05 with the \x04Spitter\x05.");
					SpitterTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 3\x05 because it has already been confirmed.");
					ChooseSpitterClassMenuDraw(iClient);
				}
			}
			default: //Back
			{
				SpitterTopMenuDraw(iClient);
			}
		}
	}
}

//Goo Type Menu Handler
GooTypeMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Flaming Goo
			{
				g_iGooType[iClient] = GOO_FLAMING;
			}
			case 1: //Melting Goo
			{
				g_iGooType[iClient] = GOO_MELTING;
			}
			case 2: //Demi Goo
			{
				g_iGooType[iClient] = GOO_DEMI;
			}
			case 3: //Repulsion Goo
			{
				g_iGooType[iClient] = GOO_REPULSION;
			}
			case 4: //Viral Goo
			{
				g_iGooType[iClient] = GOO_VIRAL;
			}
		}
	}
}

//Bag of Spits Menu Handler
BagOfSpitsMenuHandler(Menu menu, MenuAction action, iClient, itemNum)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select) 
	{
		// Make sure they havent already used all their Bind 1s up
		if (RunClientChecks(iClient) == false || g_iClientBindUses_1[iClient] >= 3) 
			return;
			
		// Ensure a valid item was selected before continuing
		if (itemNum < 0 || itemNum >= BAG_OF_SPITS_SPIT_COUNT)
			return;

		// The Menu item number corresponds to the definition of each 
		// Bag of Spits item.  So, just set it to the selected menu item
		g_iBagOfSpitsSelectedSpit[iClient] = itemNum;
	}
}
