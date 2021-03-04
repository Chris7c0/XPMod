Action:TankMenuDrawFire(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(TankMenuHandlerFire);
	
	SetMenuTitle(g_hMenu_XPM[iClient],"\
		\n \
        \nFIRE TANK\
        \n\"MoRE PAiN?! MOrE FUUuN!!\"\
        \n \
        \n Passive Abilities\
        \n - %i HP | Good At All Ranges\
        \n - High Damage Output, Immune To Fire\
        \n - 25-50%% Faster (More Pain = More Speed)\
        \n - 20%% Chance To Ignite Survivors On Punch\
        \n \
        \n Active Abilities\
        \n - [Hold CROUCH] Charges Fire Punch\
        \n    - \"PuNCh FAcE...MAkE BoOM!\"\
        \n - Rock Throw Spreads Fire (15 Sec Cooldown)\
        \n ",
        TANK_HEALTH_FIRE);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

TankMenuHandlerFire(Handle:hmenu, MenuAction:action, iClient, itemNum)
{
	if(action==MenuAction_Select) 
	{
		switch (itemNum)
		{
			case 0: //Back
			{
				TankTopMenuDraw(iClient);
			}
		}
	}
}