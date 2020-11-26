OnGameFrame_Hunter(iClient)
{
	if(g_iKillmeleonLevel[iClient] > 0)		//Dynamic Cloaking for kill-meleon
	{						
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		//For pounce crouch charge
		/*
		if((buttons & IN_DUCK))
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{
				if(g_iHunterShreddingVictim[iClient]  > 0)
				{
					g_iHunterPounceDamageCharge[iClient] = 0;
				}
			}
			
			if(g_iHunterShreddingVictim[iClient] == -1)
				if((GetEntityFlags(iClient) & FL_ONGROUND))
					if(g_iHunterPounceDamageCharge[iClient] <= (g_iKillmeleonLevel[iClient] * 120))
						g_iHunterPounceDamageCharge[iClient]++;
			
			
			if(g_iHunterPounceDamageCharge[iClient] > 59)
				PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 60);
			else if(g_iHunterPounceDamageCharge[iClient] == 30)
				PrintHintText(iClient, "Pounce Attack Charge: 0");
		}
		else
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{	
				g_iHunterPounceDamageCharge[iClient] = 0;
				PrintHintText(iClient, "Pounce Attack Charge: 0");
			}
		}
		*/
		if((buttons & IN_DUCK))
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{
				if(g_iHunterShreddingVictim[iClient]  > 0)
				{
					g_iHunterPounceDamageCharge[iClient] = 0;
				}
			}
			
			if(g_iHunterShreddingVictim[iClient] == -1)
				if((GetEntityFlags(iClient) & FL_ONGROUND))
					if(g_iHunterPounceDamageCharge[iClient] <= (g_iKillmeleonLevel[iClient] * 42))
						g_iHunterPounceDamageCharge[iClient]++;
			
			
			/*
			if(g_iHunterPounceDamageCharge[iClient] == 21)
			{
				PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
			}
			*/
			/*
			new i = 21;
			//for(new i = 21; i == 420; i)
			while(i <= 420)
			{
				if(g_iHunterPounceDamageCharge[iClient] == i)
				{
					i += 21;
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				else if(g_iHunterPounceDamageCharge[iClient] == 0)
				{
					break;
				}
			}
			*/
			//else if(g_iHunterPounceDamageCharge[iClient] == 30)
				//PrintHintText(iClient, "Pounce Attack Charge: 0");
			
			switch(g_iHunterPounceDamageCharge[iClient])
			{
				case 21:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 42:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 63:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 84:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 105:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 126:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 147:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 168:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 189:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 210:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 231:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 252:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 273:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 294:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 315:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 336:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 357:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 378:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 399:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
				case 420:
				{
					PrintHintText(iClient, "Pounce Attack Charge: %d", g_iHunterPounceDamageCharge[iClient] / 21);
				}
			}
		}
		else
		{
			if(g_iHunterPounceDamageCharge[iClient] > 0)
			{	
				g_iHunterPounceDamageCharge[iClient] = 0;
				PrintHintText(iClient, "Pounce Attack Charge: 0");
			}
		}
		//For camouflage
		if(g_bIsCloakedHunter[iClient] == true)
		{
			if( (buttons) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
			{
				if( (!(buttons & IN_DUCK)) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
				{
					//SetEntityRenderMode(iClient, RenderMode:3);	probably dont need this
					SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.010) )));
					g_bIsCloakedHunter[iClient] = false;
					g_iHunterCloakCounter[iClient] = 0;
				}
			}
		}
		else
		{
			if(g_iHunterCloakCounter[iClient] >= 0)
			{
				g_iHunterCloakCounter[iClient]++;
				if( (buttons) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )			//If iClient moves or pushes buttons, resset the counter
				{
					if( (!(buttons & IN_DUCK)) || (!(GetEntityFlags(iClient) & FL_ONGROUND)) )
					{
						if(g_iHunterCloakCounter[iClient] > 20)
						{
							SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.010) )));
						}
						g_iHunterCloakCounter[iClient] = 0;
					}
				}
				if(g_iHunterCloakCounter[iClient] == 100)
				{
					g_iHunterCloakCounter[iClient] = -1; // -1 means iClient is cloaked
					PrintCenterText(iClient, "Camouflaged");
					SetEntityRenderMode(iClient, RenderMode:3);
					SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iKillmeleonLevel[iClient]) * 0.090) )));
					g_bIsCloakedHunter[iClient] = true;
				}
				else if(g_iHunterCloakCounter[iClient] > 20)
				{
					if(g_iHunterCloakCounter[iClient] == 35)
						PrintCenterText(iClient, "Blending in with surroundings");
					SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - ((float(g_iKillmeleonLevel[iClient]) * (0.009 + (float(g_iHunterCloakCounter[iClient] - 20) * 0.001)))) )));
				}
			}
		}
		if(g_iHunterShreddingVictim[iClient] > 0)
		{
			
		}
	}
}