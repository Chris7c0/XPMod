OnGameFrame_Charger(iClient)
{
	if(g_bIsSpikedCharged[iClient] == false)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if(buttons & IN_DUCK)
		{
			if(g_bCanChargerSpikedCharge[iClient] == true)
			{
				g_iSpikedChargeCounter[iClient]++;
				if(g_iSpikedChargeCounter[iClient] == 20)
				{
					PrintHintText(iClient, "Charging Uppercut");
					//play sound and particle for charging here
				}
				if(g_iSpikedChargeCounter[iClient]>90)
				{
					g_iSpikedChargeCounter[iClient] = 0;
					g_bIsSpikedCharged[iClient] = true;
					PrintHintText(iClient, "Uppercut charged!");
					//play sound and particle for charged here
				}
			}
			else if(g_iSpikedChargeCounter[iClient] == 0)
			{
				g_iSpikedChargeCounter[iClient] = -1;
				PrintHintText(iClient, "Wait 30 seconds to charge your Uppercut again");
			}
		}
		else
		{
			if(g_iSpikedChargeCounter[iClient] > 0)
			{
				PrintHintText(iClient, "Failed to charge Uppercut");
				g_iSpikedChargeCounter[iClient] = 0;
			}
		}
	}
/*
	if (g_iHillbillyLevel[iClient] == 10)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		//decl Float:originalVector[3];
		//decl Float:eyeAngles[3];
		//decl Float:vectorDirection[3];
		decl Float:vectorVelocity[3];
		if (buttons & IN_MOVELEFT)
		{
			//FakeClientCommand(iClient, "+left");
			//GetClientEyePosition(iClient, originalVector);
			//GetClientEyeAngles(iClient, eyeAngles);
			//GetAngleVectors(eyeAngles, vectorDirection, NULL_VECTOR, NULL_VECTOR);
			//originalVector[1]--;
			GetEntDataVector(iClient, g_iOffset_VecVelocity, vectorVelocity);
			vectorVelocity[0] -= 250.0;
			TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vectorVelocity);
		}
		if (buttons & IN_MOVERIGHT)
		{
			//FakeClientCommand(iClient, "+right");
			//GetClientEyePosition(iClient, originalVector);
			//originalVector[1]++;
			GetEntDataVector(iClient, g_iOffset_VecVelocity, vectorVelocity);
			vectorVelocity[0] += 250.0;
			TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, vectorVelocity);
		}
	}*/
	/*if (g_iHillbillyLevel[iClient] == 10)
	{
		if (g_bIsChargerCharging[iClient] == true)
		{
			new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
			decl Float:originalVector[3];
			if (buttons & IN_MOVELEFT)
			{
				//FakeClientCommand(iClient, "+left");
				GetClientEyePosition(iClient, originalVector);
				originalVector[0]--;
				TeleportEntity(iClient, originalVector, NULL_VECTOR, NULL_VECTOR);
			}
			if (buttons & IN_MOVERIGHT)
			{
				//FakeClientCommand(iClient, "+right");
				GetClientEyePosition(iClient, originalVector);
				originalVector[0]++;
				TeleportEntity(iClient, originalVector, NULL_VECTOR, NULL_VECTOR);
			}
		}
	}*/
	/*if (g_iHillbillyLevel[iClient] == 10)
	{
		new buttons = GetEntProp(iClient, Prop_Data, "m_nButtons", buttons);
		if ((g_bIsChargerCharging[iClient] == true) && (buttons & IN_MOVELEFT))
		{
			FakeClientCommand(iClient, "+left");
		}
		if ((g_bIsChargerCharging[iClient] == true) && (buttons & IN_MOVERIGHT))
		{
			FakeClientCommand(iClient, "+right");
		}
	}*/
}