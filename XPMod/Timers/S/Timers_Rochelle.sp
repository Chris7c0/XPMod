
public Action:Timer_BreakFreeOfSmoker(Handle:timer, any:iClient)
{
	TeleportEntity(iClient, g_xyzOriginalPositionRochelle[iClient], NULL_VECTOR, NULL_VECTOR);
	CreateRochelleSmoke(iClient);
	
	return Plugin_Stop;
}

public Action:ShowRopeTimer(Handle:timer, any:iClient)
{
	if (IsServerProcessing()==false)
		return Plugin_Continue;
	if(g_bUsingTongueRope[iClient] == true)
	{
		TE_SetupBeamPoints(g_xyzClientLocation[iClient],g_xyzRopeEndLocation[iClient],g_iSprite_SmokerTongue,0,0,66,0.1,3.0,3.0,10,0.0,{70,40,15,255},1);
		TE_SendToAll();
		return Plugin_Continue;
	}
	else
		return Plugin_Stop;
}

public Action:TimerStopShadowNinja(Handle:timer, any:iClient)
{
	g_bUsingShadowNinja[iClient] = false;
	pop(iClient, 1);
	
	if(IsValidEntity(iClient) == true && IsClientInGame(iClient) == true)
	{
		SetEntityRenderMode(iClient, RenderMode:0);
		SetEntityRenderColor(iClient, 255, 255, 255, 255);
		SetEntProp(iClient, Prop_Send, "m_iGlowType", 0);
		SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
		SetEntProp(iClient, Prop_Send, "m_glowColorOverride", 0);
		ChangeEdictState(iClient, 12);	
		//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), (1.0 + (g_iShadowLevel[iClient]*0.03) + (g_iHunterLevel[iClient]*0.02)), true);
		g_fClientSpeedBoost[iClient] -= (g_iShadowLevel[iClient] * 0.1);
		fnc_SetClientSpeed(iClient);
		
		switch(g_iClientBindUses_2[iClient])
		{
			case 1:
			{
				g_iPID_RochelleCharge1[iClient] = WriteParticle(iClient, "rochelle_ulti_ninja_charge1", 0.0);
				g_iPID_RochelleCharge2[iClient] = WriteParticle(iClient, "rochelle_ulti_ninja_charge2", 0.0);
			}
			case 2:
			{
				g_iPID_RochelleCharge1[iClient] = WriteParticle(iClient, "rochelle_ulti_ninja_charge1", 0.0);
			}
		}
	}
	
	return Plugin_Stop;
}

public Action:TimerPoison(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient) == false)
	{
		g_bIsRochellePoisoned[iClient] = false;
		DeleteParticleEntity(g_iPID_RochellePoisonBullet[iClient]);
		return Plugin_Stop;
	}
	if(IsPlayerAlive(iClient) == false)
	{
		g_bIsRochellePoisoned[iClient] = false;
		DeleteParticleEntity(g_iPID_RochellePoisonBullet[iClient]);
		return Plugin_Stop;
	}
	if(g_bIsRochellePoisoned[iClient] == false)
	{
		g_bIsRochellePoisoned[iClient] = false;
		DeleteParticleEntity(g_iPID_RochellePoisonBullet[iClient]);
		return Plugin_Stop;
	}
	if(g_iSlapRunTimes[iClient]++ < 5)
	{
		if(IsFakeClient(iClient)==false)
			ShowHudOverlayColor(iClient, 0, 100, 0, 100, 300, FADE_IN);
		
		CreateTimer(0.8, TimerPoisonFade, iClient, TIMER_FLAG_NO_MAPCHANGE);	//Make the effect fade away and dmg iClient(victim)
		return Plugin_Continue;
	}
	g_bIsRochellePoisoned[iClient] = false;
	
	//if(IsFakeClient(iClient)==false)
	//	PrintHintText(iClient, "The poison's effects have worn off.");
	
	return Plugin_Stop;
}

public Action:TimerPoisonFade(Handle:timer, any:iClient)
{
	if(IsClientInGame(iClient)==false)
		return Plugin_Stop;
	if(IsPlayerAlive(iClient)==false)
		return Plugin_Stop;
	if(IsValidEntity(iClient) == false)
		return Plugin_Stop;
	new hp = GetEntProp(iClient,Prop_Data,"m_iHealth");
	if(hp < 16)
		ForcePlayerSuicide(iClient);
	else
		SetEntProp(iClient,Prop_Data,"m_iHealth", hp - 25);
		
	WriteParticle(iClient, "poison_bubbles", 0.0, 3.0);
	
	if(IsFakeClient(iClient)==false)
		ShowHudOverlayColor(iClient, 0, 100, 0, 100, 300, FADE_OUT);
	
	return Plugin_Stop;
}

public Action:TimerIDD(Handle:timer, any:data)
{
	if (IsServerProcessing()==false)
		return Plugin_Continue;
	for(new iClient = 1;iClient<MaxClients; iClient++)
	{
		if(IsClientInGame(iClient)==true)
		{
			if(g_iGatherLevel[iClient] > 0)
				if(g_bClientIDDToggle[iClient] == true)
					DetectionHud(iClient);
		}
	}
	return Plugin_Continue;
}