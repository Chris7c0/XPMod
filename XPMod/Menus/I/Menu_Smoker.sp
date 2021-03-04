//Smoker Menu

//Smoker Top Menu Draw
Action:SmokerTopMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(SmokerTopMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "\n \nLevel %d	XP: %d/%d\n==========================\nSmoker Talents:\n==========================\n \nEnvelopment: Level %d\nNoxious Gasses: Level %d\nDirty Tricks: Level %d\n \n", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iEnvelopmentLevel[iClient], g_iNoxiousLevel[iClient], g_iDirtyLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Envelopment");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Noxious Gasses");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Dirty Tricks\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Choose The Smoker\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option5", "Open In Website\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option6", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option7", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option8", "", ITEMDRAW_NOTEXT);
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back\
		\n==========================\
		\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Talent Draws///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Envelopment Menu Draw
Action:EnvelopmentMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(EnvelopmentMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "\
	\n \
	\n  			Envelopment (Level %d)\
	\n \
	\nLevel 1:\
	\n(Stacks) +3%% tongue range & fly speed\
	\n \
	\n \
	\nSkill Uses:\
	\n+1 (Stack) for each Smoker with this talent\
	\nUnlimited stacks\
	\n ",
	g_iEnvelopmentLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Noxious Gasses Menu Draw
Action:NoxiousMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(NoxiousMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "\
		\n \
		\n									Noxious Gasses (Level %d)\
		\n \
		\nLevel 1:\
		\n1 cloud damage every tick\
		\n-0.25 seconds between cloud ticks per level (Base: 3 seconds)\
		\n+2%% movement speed per level\
		\n \
		\n \
		\n						    Bind 1: Disperse\
		\n				Unlimited uses; 10 second cooldown\
		\n \
		\nLevel 1:\
		\nTeleport +30 feet per level\
		\n100%% transparency after use, fades to 0%% over +1 second per level\
		\n ",
		g_iNoxiousLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Dirty Tricks Menu Draw
Action:DirtyMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(DirtyMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "\
		\n \
		\n					Dirty Tricks (Level %d)\
		\n \
		\nLevel 1:\
		\nAttacks infect for +2 sec per level\
		\n+1%% speed when choking per level\
		\n(Stacks) +8%% drag speed per level\
		\n \
		\n \
		\n					Bind 2: The Electric Snare\
		\n						 3 uses; 3 sec duration\
		\n \
		\nLevel 1:\
		\nShock for 1 dmg per level every half sec\
		\nArcs to survivors in line of sight for half damage\
		\n \
		\n \
		\nSkill Uses:\
		\n+1 (Stack) for each SMOKER w/ this talent\
		\nUnlimited stacks\
		\n ",
		g_iDirtyLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Smoker Menu Draw
Action:ChooseSmokerClassMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChooseSmokerClassMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Smoker:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Replace Class 1");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Replace Class 2");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Replace Class 3");
	AddMenuItem(g_hMenu_XPM[iClient], "option9", "Back");
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

//Handlers/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Smoker Top Menu Handler
SmokerTopMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Envelopment
			{
				EnvelopmentMenuDraw(iClient);
			}
			case 1: //Noxious Gasses
			{
				NoxiousMenuDraw(iClient);
			}
			case 2: //Dirty
			{
				DirtyMenuDraw(iClient);
			}
			case 3: //Select This Class
			{
				if((g_iClientInfectedClass1[iClient] != SMOKER) && (g_iClientInfectedClass2[iClient] != SMOKER) && (g_iClientInfectedClass3[iClient] != SMOKER))
				{
					if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
						ChooseSmokerClassMenuDraw(iClient);
					else
					{
						PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
						SmokerTopMenuDraw(iClient);
					}
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04smoker\x05 as one of your classes.");
					SmokerTopMenuDraw(iClient);
				}
			}
			case 4: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/infected/ceda%20files/smoker/xpmod_ig_talents_infected_smoker.html", MOTDPANEL_TYPE_URL);
				SmokerTopMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}

//Envelopment Menu Handler
EnvelopmentMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				SmokerTopMenuDraw(iClient);
			}
		}
	}
}

//Noxious Gasses Menu Handler
NoxiousMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				SmokerTopMenuDraw(iClient);
			}
		}
	}
}

//Dirty Menu Handler
DirtyMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				SmokerTopMenuDraw(iClient);
			}
		}
	}
}

//Choose Smoker Top Menu Handler
ChooseSmokerClassMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
					SetInfectedClassSlot(iClient, 1, SMOKER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 1\x05 with the \x04Smoker\x05.");
					SmokerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 1\x05 because it has already been confirmed.");
					ChooseSmokerClassMenuDraw(iClient);
				}
			}
			case 1: //Replace Class 2
			{
				if(g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, SMOKER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 2\x05 with the \x04Smoker\x05.");
					SmokerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 2\x05 because it has already been confirmed.");
					ChooseSmokerClassMenuDraw(iClient);
				}
			}
			case 2: //Replace Class 3
			{
				if(g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, SMOKER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 3\x05 with the \x04Smoker\x05.");
					SmokerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 3\x05 because it has already been confirmed.");
					ChooseSmokerClassMenuDraw(iClient);
				}
			}
			default: //Back
			{
				SmokerTopMenuDraw(iClient);
			}
		}
	}
}