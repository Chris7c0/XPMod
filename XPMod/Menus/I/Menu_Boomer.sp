//Boomer Menu

//Boomer Top Menu Draw
Action:BoomerTopMenuDraw(iClient) 
{
	CheckMenu(iClient);
	
	DeleteAllMenuParticles(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(BoomerTopMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	decl String:title[256];
	FormatEx(title, sizeof(title), "\n \nLevel %d	XP: %d/%d\n==========================\nBoomer Talents:\n==========================\n \nRapid Regurgitation: Level %d\nAcidic Brew: Level %d\nNorovirus: Level %d\n \n", g_iClientLevel[iClient], g_iClientXP[iClient], g_iClientNextLevelXPAmount[iClient], g_iRapidLevel[iClient], g_iAcidicLevel[iClient], g_iNorovirusLevel[iClient]);
	SetMenuTitle(g_hMenu_XPM[iClient], title);
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Rapid Regurgitation");
	AddMenuItem(g_hMenu_XPM[iClient], "option2", "Acidic Brew");
	AddMenuItem(g_hMenu_XPM[iClient], "option3", "Norovirus\n ");
	
	AddMenuItem(g_hMenu_XPM[iClient], "option4", "Choose The Boomer\n ");
	
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

//Rapid Regurgitation Menu Draw
Action:RapidMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(RapidMenuHandler);
	SetMenuTitle(g_hMenu_XPM[iClient], "\
		\n \
		\n  					Rapid Regurgitation (Level %d)\
		\n \
		\nLevel 1:\
		\n-2 second vomit cooldown per level\
		\nReduce movement penalty after vomiting by 10%% per level\
		\n ",
		g_iRapidLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");

	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Acidic Brew Menu Draw
Action:AcidicMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(AcidicMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "\
		\n \
		\n						Acidic Brew (Level %d)\
		\n \
		\nLevel 1:\
		\nVomit victims lose their HUD for 2 seconds per level\
		\n+1 damage per level to survivors near your death boom\
		\n \
		\n \
		\n						  Bind 1: Hot Meal\
		\n					3 uses; 9 second duration\
		\n \
		\nLevel 1:\
		\nConstant vomiting while active\
		\n+10%% movement speed per level\
		\n ",
		g_iAcidicLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Norovirus Menu Draw
Action:NorovirusMenuDraw(iClient)
{
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(NorovirusMenuHandler);
	
	SetMenuTitle(g_hMenu_XPM[iClient], "\
		\n \
		\n							Norovirus (Level %d)\
		\n \
		\nLevel 1:\
		\n+4%% chance to make survivors vomit per level\
		\n \
		\nLevel 5:\
		\nRandom effect if you vomit on 3 survivors within 9 seconds\
		\n \
		\n \
		\n						Bind 2: Suicide Boomer\
		\n									3 uses\
		\n \
		\nLevel 1:\
		\n+5x jump heighth per level\
		\n+2 boom damage per level\
		\n+20%% fling distance per level\
		\n+20%% boom distance per level\
		\n ",
		g_iNorovirusLevel[iClient]);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

//Choose Boomer Menu Draw
Action:ChooseBoomerClassMenuDraw(iClient) 
{
	DeleteAllMenuParticles(iClient);
	CheckMenu(iClient);
	
	g_hMenu_XPM[iClient] = CreateMenu(ChooseBoomerClassMenuHandler);
	SetMenuPagination(g_hMenu_XPM[iClient], MENU_NO_PAGINATION);
	
	decl String:title[256];
	FormatEx(title, sizeof(title), "==========================\n		Current Classes\n \nClass 1)	%s\nClass 2)	%s\nClass 3)	%s\n==========================\n \nPick a class to replace with the Boomer:",g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
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

//Boomer Top Menu Handler
BoomerTopMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Rapid Regurgitation
			{
				RapidMenuDraw(iClient);
			}
			case 1: //Acidic Brew
			{
				AcidicMenuDraw(iClient);
			}
			case 2: //Norovirus
			{
				NorovirusMenuDraw(iClient);
			}
			case 3: //Select This Class
			{
				if((g_iClientInfectedClass1[iClient] != BOOMER) && (g_iClientInfectedClass2[iClient] != BOOMER) && (g_iClientInfectedClass3[iClient] != BOOMER))
				{
					if(g_iClientInfectedClass1[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
						ChooseBoomerClassMenuDraw(iClient);
					else
					{
						PrintToChat(iClient, "\x03[XPMod] \x05You cannot change your characters if your talents are confirmed for this round.");
						BoomerTopMenuDraw(iClient);
					}
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You already have the \x04boomer\x05 as one of your classes.");
					BoomerTopMenuDraw(iClient);
				}
			}
			case 4: //Open In Website
			{
				OpenMOTDPanel(iClient, "", "http://xpmod.net/talents/infected/ceda%20files/boomer/xpmod_ig_talents_infected_boomer.html", MOTDPANEL_TYPE_URL);
				BoomerTopMenuDraw(iClient);
			}
			case 8: //Back
			{
				TopInfectedMenuDraw(iClient);
			}
		}
	}
}

//Rapid Regurgitation Menu Handler
RapidMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				BoomerTopMenuDraw(iClient);
			}
/*			case 1: //Talent Info
			{
				RapidDescMenuDraw(iClient);
			}*/
		}
	}
}

//Acidic Brew Menu Handler
AcidicMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				BoomerTopMenuDraw(iClient);
			}
/*			case 1: //Talent Info
			{
				AcidicDescMenuDraw(iClient);
			}
			case 2: //Bind Info
			{
				AcidicBindMenuDraw(iClient);
			}
			case 3: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}*/
		}
	}
}

//Norovirus Menu Handler
NorovirusMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				BoomerTopMenuDraw(iClient);
			}
/*			case 1: //Talent Info
			{
				NorovirusDescMenuDraw(iClient);
			}
			case 2: //Bind Info
			{
				NorovirusBindMenuDraw(iClient);
			}
			case 3: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}*/
		}
	}
}
/*
//Acidic Brew Bind Handler
AcidicBindMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				AcidicMenuDraw(iClient);
			}
			case 1: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}
		}
	}
}

//Norovirus Bind Handler
NorovirusBindMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				NorovirusMenuDraw(iClient);
			}
			case 1: //How To Use Binds
			{
				HowToBindMenuDraw(iClient);
			}
		}
	}
}

//Rapid Regurgitation Description Handler
RapidDescMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				RapidMenuDraw(iClient);
			}
		}
	}
}

//Acidic Brew Description Handler
AcidicDescMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				AcidicMenuDraw(iClient);
			}
		}
	}
}

//Norovirus Description Handler
NorovirusDescMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				NorovirusMenuDraw(iClient);
			}
		}
	}
}
*/
//Choose Boomer Top Menu Handler
ChooseBoomerClassMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
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
					SetInfectedClassSlot(iClient, 1, BOOMER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 1\x05 with the \x04Boomer\x05.");
					BoomerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 1\x05 because it has already been confirmed.");
					ChooseBoomerClassMenuDraw(iClient);
				}
			}
			case 1: //Replace Class 2
			{
				if(g_iClientInfectedClass2[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass2[iClient]);
					SetInfectedClassSlot(iClient, 2, BOOMER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 2\x05 with the \x04Boomer\x05.");
					BoomerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 2\x05 because it has already been confirmed.");
					ChooseBoomerClassMenuDraw(iClient);
				}
			}
			case 2: //Replace Class 3
			{
				if(g_iClientInfectedClass3[iClient] == UNKNOWN_INFECTED || g_bTalentsConfirmed[iClient] == false)
				{
					LevelDownInfectedTalent(iClient, g_iClientInfectedClass3[iClient]);
					SetInfectedClassSlot(iClient, 3, BOOMER);
					PrintToChat(iClient, "\x03[XPMod] \x05Replaced \x04class 3\x05 with the \x04Boomer\x05.");
					BoomerTopMenuDraw(iClient);
				}
				else
				{
					PrintToChat(iClient, "\x03[XPMod] \x05You cannot replace \x04class 3\x05 because it has already been confirmed.");
					ChooseBoomerClassMenuDraw(iClient);
				}
			}
			default: //Back
			{
				BoomerTopMenuDraw(iClient);
			}
		}
	}
}