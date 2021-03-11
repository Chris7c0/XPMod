Action:TankMenuDrawIce(iClient)
{
	CheckLevel(iClient);
	Menu menu = CreateMenu(TankMenuHandlerIce);
	
	SetMenuTitle(menu,"\
		\n \
        \nICE TANK\
        \n\"You merely adopted the cold; I was born in it, moulded by it.\"\
        \n \
        \n Passive Abilities\
        \n - %i HP | Good At Close Range\
        \n - Freeze Survivors\
        \n - Weak To Fire, But Fire Goes Out Quickly\
        \n - 33%% Chance To Freeze Survivors On Punch\
        \n \
        \n Active Abilities\
        \n - [Hold CROUCH & Do Not Move] Regenerates Health\
        \n    - Freezes Survivors Inside The Blizard Storm\
        \n - Rock Throw Freezes Survivors (No Cooldown)\
        \n ",
        TANK_HEALTH_ICE);
	
	AddMenuItem(menu, "option1", "Back\
	\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

TankMenuHandlerIce(Handle:hmenu, MenuAction:action, iClient, itemNum)
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