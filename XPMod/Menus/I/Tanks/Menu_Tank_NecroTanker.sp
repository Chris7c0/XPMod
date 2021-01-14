public Action:TankMenuDrawNecroTanker(iClient)
{
	CheckMenu(iClient);
	CheckLevel(iClient);
	g_hMenu_XPM[iClient] = CreateMenu(TankMenuHandlerNecroTanker);
	
	SetMenuTitle(g_hMenu_XPM[iClient],
        "=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \
        \nNECROTANKER\
        \n\"Life is finite, whereas Death...ah, yes. Death is infinite.\"\
        \n \
        \n Passive Abilities\
        \n - %i Starting HP, %i Max HP | Good At Close Range\
        \n - Consume Infected For Health\
        \n	+%i HP Per CI Kill\
        \n	+%i HP Per UI Kill\
        \n - Immune to Bile\
        \n - Punching Survivors Summons Infected\
        \n	+60%% CI/UI Mob\
        \n	+5%% SI\
        \n	+5%% Witch\
        \n	+1%% Tank\
        \n \
        \n Active Abilities\
        \n - [Hold CROUCH] Summon Infected\
        \n - [Press MELEE] Throw Boomers (+10 Sec Cooldown)\
        \n \n=	=	=	=	=	=	=	=	=	=	=	=	=	=	=	=\n \n",
        TANK_HEALTH_NECROTANKER,
        NECROTANKER_MAX_HEALTH,
        NECROTANKER_CONSUME_COMMON_HP,
        NECROTANKER_CONSUME_UNCOMMON_HP);
	
	AddMenuItem(g_hMenu_XPM[iClient], "option1", "Back\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ");
	
	SetMenuExitButton(g_hMenu_XPM[iClient], false);
	DisplayMenu(g_hMenu_XPM[iClient], iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

public TankMenuHandlerNecroTanker(Handle:hmenu, MenuAction:action, iClient, itemNum)
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