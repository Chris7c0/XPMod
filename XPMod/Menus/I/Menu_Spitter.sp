//Spitter Menu

//Spitter Menu Draw
Action:SpitterTopMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(SpitterTopMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "\n \nLevel %d	XP: %d/%d\n==============================\nSpitter Talents:\n==============================\n \nPuppet Master: Level %d\nMaterial Girl: Level %d\nHallucinogenic Nightmare: Level %d\n \n", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iPuppetLevel[iClient], g_iMaterialLevel[iClient], g_iHallucinogenicLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Puppet Master");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Material Girl");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Hallucinogenic Nightmare\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Choose The Spitter\n ");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Open In Website\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\
		\n==============================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Talent Draws///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Ground 'n Pound Menu Draw
Action:PuppetMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(PuppetMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n  						Puppet Master (Level %d)\n \nLevel 1:\nSpawn in with +1 CI per level\nWhen incapping a player, spawn +1 CI every other level on the victim\n25%% chance on hit to slow survivors by 2%%, 4%%, or 6%% per level\n \nLevel 6:\nFlaming Goo: A blanket of fire lies over your spit\n \nPress [WALK] to change Goo Types\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iPuppetLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
//	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Talent Info\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Spiked Carapace Menu Draw
Action:MaterialMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(MaterialMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=\n \n				Material Girl (Level %d)\n \nLevel 1:\nIf spit hits incapped player:\nCloak victim +10%% per level\nHide victims' glow\n \nSpawn 1 random UI on spit (2 at Lvl 10)\nMelting Goo: +2 spit dmg\nDmg converts health to temp health\n \nLevel 6:\nDemi Goo: Triples victims gravity and\nrestricts mobility talents\n \nPress [WALK] to change Goo Types\n \n				Bind 1: Bag of Spits\n \nSelect from unique Enhanced CI mobs\nConjure them on your next spit\n \n=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iMaterialLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
//	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Talent Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Bind Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option4", "How To Use Binds\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Hillbilly Madness! Menu Draw
Action:HallucinogenicMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(HallucinogenicMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n				Hallucinogenic Nightmare (Level %d)\n \nLevel 1:\n-0.5s spit cooldown per level\nHold [CROUCH] to Phase Shift (stealth and speed)\nClaws drug your victim, causing hallucinations\nRepulsion Goo: Bounces victims in 1 of 9 directions\n \nLevel 6:\nViral Goo: Infect victims with a contagious virus\n \nPress [WALK] to change Goo Types\n \n \n						Bind 2: Sisterhood\n					3 uses; 3 minute cooldown\n \nConjure a disguised witch\n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",g_iHallucinogenicLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n ");
//	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Talent Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Bind Info");
//	AddMenuItem(g_hMenu_XPM[iClient], "option4", "How To Use Binds\n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Spitter Menu Draw
Action:ChooseSpitterClassMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(ChooseSpitterClassMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Spitter:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Replace Class 1");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Replace Class 2");	//implemented in loadouts.sp
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Replace Class 3");
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

Action:GooTypeMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(GooTypeMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Choose your Goo Type!"); 
	if(g_iPuppetLevel[iClient] > 5 && g_iMaterialLevel[iClient] < 1)
	{
		AddMenuItem(g_hMenu_XPM[iClient], "option1", "Flaming Goo");
	}
	else if(g_iMaterialLevel[iClient] > 0 && g_iMaterialLevel[iClient] < 6)
	{
		AddMenuItem(g_hMenu_XPM[iClient], "option1", "Flaming Goo");
		AddMenuItem(g_hMenu_XPM[iClient], "option2", "Melting Goo");
	}
	else if(g_iMaterialLevel[iClient] > 5 && g_iHallucinogenicLevel[iClient] < 1)
	{
		AddMenuItem(g_hMenu_XPM[iClient], "option1", "Flaming Goo");
		AddMenuItem(g_hMenu_XPM[iClient], "option2", "Melting Goo");
		AddMenuItem(g_hMenu_XPM[iClient], "option3", "Demi Goo");
	}
	else if(g_iHallucinogenicLevel[iClient] > 0 && g_iHallucinogenicLevel[iClient] < 6)
	{
		AddMenuItem(g_hMenu_XPM[iClient], "option1", "Flaming Goo");
		AddMenuItem(g_hMenu_XPM[iClient], "option2", "Melting Goo");
		AddMenuItem(g_hMenu_XPM[iClient], "option3", "Demi Goo");
		AddMenuItem(g_hMenu_XPM[iClient], "option4", "Repulsion Goo");
	}
	else if(g_iHallucinogenicLevel[iClient] > 5)
	{
		AddMenuItem(g_hMenu_XPM[iClient], "option1", "Flaming Goo");
		AddMenuItem(g_hMenu_XPM[iClient], "option2", "Melting Goo");
		AddMenuItem(g_hMenu_XPM[iClient], "option3", "Demi Goo");
		AddMenuItem(g_hMenu_XPM[iClient], "option4", "Repulsion Goo");
		AddMenuItem(g_hMenu_XPM[iClient], "option5", "Viral Goo");
	}
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}


Action:BagOfSpitsMenuDraw(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(BagOfSpitsMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "Pull something nice from your Bag of Spits!\n "); 

	AddMenuItem(g_hMenu_XPM[iClient], "option1",
		"MINI ARMY\
		\n	A lot of very tiny, very annoying, enhanced infected.");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", 
		"MUSCLE CREW\
		\n	Three roided out infected...lookin' for brainz gainz.");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", 
		"ENHANCED JIMMY\
		\n	Big and Enhanced, for your pleasure.");
	AddMenuItem(g_hMenu_XPM[iClient], "option4", 
		"NECROFEASTERS\
		\n	They brought friends, and are ready for seconds.");
	AddMenuItem(g_hMenu_XPM[iClient], "option5", 
		"KILLER KLOWNS FROM OUTER SPACE\
		\n	Alien bozos with an appetite for close encounters.");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}
//Handlers/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Spitter Top Menu Handler
SpitterTopMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
PuppetMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
MaterialMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
HallucinogenicMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
ChooseSpitterClassMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
GooTypeMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
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
BagOfSpitsMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	// Make sure they havent already used all their Bind 1s up
	if (RunClientChecks(iClient) == false || g_iClientBindUses_1[iClient] >= 3) 
		return;

	if(action==MenuAction_Select) 
	{
		// Ensure a valid item was selected before continuing
		if (itemNum < 0 || itemNum >= BAG_OF_SPITS_SPIT_COUNT)
			return;

		// The Menu item number corresponds to the definition of each 
		// Bag of Spits item.  So, just set it to the selected menu item
		g_iBagOfSpitsSelectedSpit[iClient] = itemNum;
	}
}
