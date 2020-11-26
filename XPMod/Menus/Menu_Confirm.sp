
//Confirm Talents
public Action:TimerCheckTalentsConfirmed(Handle:timer, any:data)
{
	decl iClient;
	for(iClient = 1; iClient <= MaxClients; iClient++)
	{
		if(g_bGameFrozen == false && g_bUserStoppedConfirmation[iClient] == false && 
			g_iAutoSetCountDown[iClient] == -1 && g_bClientLoggedIn[iClient] == true && 
			g_bTalentsConfirmed[iClient] == false && IsClientInGame(iClient) == true && 
			GetClientMenu(iClient) == MenuSource_None && IsFakeClient(iClient) == false)
		{
			g_iAutoSetCountDown[iClient] = 30;
			CreateTimer((0.1 * iClient), TimerShowTalentsConfirmed, iClient, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	
	return Plugin_Continue;
}


public Action:TimerShowTalentsConfirmed(Handle:timer, any:iClient)
{
	if(g_bGameFrozen == false)
	{
		if(IsClientInGame(iClient))
		{
			if(IsFakeClient(iClient) == false)
			{
				if(g_bClientLoggedIn[iClient] == true)
				{
					if(g_bTalentsConfirmed[iClient] == false)
					{
						if(g_bUserStoppedConfirmation[iClient] == false)
						{
							ConfirmationMessageMenuDraw(iClient);
							g_iAutoSetCountDown[iClient]--;
							CreateTimer(1.0, TimerShowTalentsConfirmed, iClient, TIMER_FLAG_NO_MAPCHANGE);
						}
					}
				}
			}
		}
	}
	
	return Plugin_Stop;
}


public Action:ConfirmationMessageMenuDraw(iClient)
{
	if(iClient < 1)
		return Plugin_Handled;
	if(IsClientInGame(iClient) == false)
		return Plugin_Handled;
	if(IsFakeClient(iClient) == true)
		return Plugin_Handled;
	
	if(g_bTalentsConfirmed[iClient] == false)
	{
		if(g_iAutoSetCountDown[iClient] > 0)
		{
			CheckMenu(iClient);
			g_hMenu_XPM[iClient] = CreateMenu(ConfirmationMessageMenuHandler);
			
			decl String:surClass[16];
			switch(g_iChosenSurvivor[iClient])
			{
				case 0: surClass =  "Support";
				case 1: surClass =  "Ninja";
				case 2: surClass =  "Berserker";
				case 3: surClass =  "Weapons Expert";
				case 4: surClass =  "Medic";
				default: surClass = "NONE";
			}
			
			decl String:text[300];
			FormatEx(text, sizeof(text), "================================================\n \n	Survivor Class:       %s\n	Equipment Cost:      %d XP\n	Infected Classes:    %s	%s	%s\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \nConfirm your talents and equipment for this round?\n ", surClass, g_iClientTotalXPCost[iClient], g_strClientInfectedClass1[iClient], g_strClientInfectedClass2[iClient], g_strClientInfectedClass3[iClient]);
			SetMenuTitle(g_hMenu_XPM[iClient], text);
			
			AddMenuItem(g_hMenu_XPM[iClient], "option1", " Yes, I want these talents for this round.");
			if(g_iAutoSetCountDown[iClient] > 9)
			{
				switch( (g_iAutoSetCountDown[iClient] % 3) )
				{
					case 0: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n   ->           Auto-Confirming in %d Seconds           <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 1: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n            ->  Auto-Confirming in %d Seconds  <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 2: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n        ->      Auto-Confirming in %d Seconds      <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
				}
			}
			else
			{
				switch( (g_iAutoSetCountDown[iClient] % 3) )
				{
					case 0: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n   ->           Auto-Confirming in  %d Seconds           <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 1: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n            ->  Auto-Confirming in  %d Seconds  <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
					case 2: FormatEx(text, sizeof(text), " No, not yet. I will confirm in the !xpm menu.\n \n~	~	~	~	~	~	~	~	~	~	~	~	~	~	~	~\n \n        ->      Auto-Confirming in  %d Seconds      <-\n================================================\n \n \n \n \n \n \n \n \n ", g_iAutoSetCountDown[iClient]);
				}
			}
			
			AddMenuItem(g_hMenu_XPM[iClient], "option2", text);
			
			SetMenuExitButton(g_hMenu_XPM[iClient], false);
			DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);
		}
		else
		{
			ClosePanel(iClient);
			if(g_bClientLoggedIn[iClient] == true)
			{
				g_bTalentsConfirmed[iClient] = true;
				g_iAutoSetCountDown[iClient] = -1;
				PrintHintText(iClient, "Talents Confirmed");
				LoadTalents(iClient);
			}
		}
	}
	
	return Plugin_Handled;
}

public ConfirmationMessageMenuHandler(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select)
	{
		switch (itemNum)
		{
			case 0: //Yes
			{
				if(g_bClientLoggedIn[iClient] == true)
				{
					g_bTalentsConfirmed[iClient] = true;
					g_iAutoSetCountDown[iClient] = -1;
					
					PrintHintText(iClient, "Talents Confirmed");
					LoadTalents(iClient);
				}
			}
			case 1: //No
			{
				g_iAutoSetCountDown[iClient] = -1;
				g_bTalentsConfirmed[iClient] = false;
				g_bUserStoppedConfirmation[iClient] = true;
			}
		}
	}
}