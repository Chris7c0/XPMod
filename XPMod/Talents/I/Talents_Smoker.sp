OnGameFrame_Smoker(iClient)
{
	if(g_iDirtyLevel[iClient] > 0 && g_iSmokerTransparency[iClient] != 0)
	{
		if(g_iSmokerTransparency[iClient] > 1)
		{
			g_iSmokerTransparency[iClient]--;
			SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iSmokerTransparency[iClient]) / 300))));		//300 because 10 total levels * 30 fps = 10 seconds
		}
		else
		{
			g_iSmokerTransparency[iClient] = 0;
			SetEntityRenderMode(iClient, RenderMode:0);
			SetEntityRenderColor(iClient, 255, 255, 255, 255);
		}
	}
}

EventsHurt_SmokerAttacker(Handle:hEvent, attacker, victim)
{
	decl String:weapon[20];
	GetEventString(hEvent,"weapon", weapon,20);
	if(StrEqual(weapon, "smoker_claw") == true)
	{
		if(g_iDirtyLevel[attacker] > 0)
		{
			if(g_bIsSmokeInfected[victim] == false)
			{
				CreateParticle("bug_zapper_fly_cloud", 20.0, victim, ATTACH_MOUTH, true);
				CreateParticle("bug_zapper_fly_cloud", 20.0, victim, ATTACH_MOUTH, true);
				CreateParticle("bug_zapper_fly_cloud", 20.0, victim, ATTACH_MOUTH, true);
				//CreateParticle("smoke_gib_01", 10.0, iClient, ATTACH_MOUTH, true, 0.0, 0.0, -5.0);
				//CreateParticle("smoker_spore_attack", 20.0, victim, ATTACH_NORMAL, true);
				
				
				new Float:vec[3];
				GetClientEyePosition(victim, vec);
				
				//Play fly sounds
				//EmitSoundToAll(SOUND_FLIES, victim, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, vec, NULL_VECTOR, true, 0.0);
				
				vec[2] -= 25.0;
				
				new smoke = CreateEntityByName("env_smokestack");
									
				new String:clientName[128], String:vecString[32];
				Format(clientName, sizeof(clientName), "Smoke%i", victim);
				Format(vecString, sizeof(vecString), "%f %f %f", vec[0], vec[1], vec[2]);
				
				DispatchKeyValue(smoke,"targetname", clientName);
				DispatchKeyValue(smoke,"Origin", vecString);
				DispatchKeyValue(smoke,"BaseSpread", "0");		//Gap in the middle
				DispatchKeyValue(smoke,"SpreadSpeed", "100");	//Speed the smoke moves outwards
				DispatchKeyValue(smoke,"Speed", "80");			//Speed the smoke moves up
				DispatchKeyValue(smoke,"StartSize", "100");
				DispatchKeyValue(smoke,"EndSize", "100");
				DispatchKeyValue(smoke,"Rate", "20");			//Amount of smoke created
				DispatchKeyValue(smoke,"JetLength", "100");		//Smoke jets outside of the original
				DispatchKeyValue(smoke,"Twist", "10"); 			//Amount of global twisting
				//DispatchKeyValue(smoke,"RenderColor", "200 200 40");
				DispatchKeyValue(smoke,"RenderColor", "50 130 1");
				DispatchKeyValue(smoke,"RenderAmt", "255");		//Transparency
				DispatchKeyValue(smoke,"SmokeMaterial", "particle/particle_smokegrenade1.vmt");		//THIS WAS CHANGED FROM THE PRECACHED TO SEE HOW IT IS
				
				DispatchSpawn(smoke);
				AcceptEntityInput(smoke, "TurnOn");
				g_bIsSmokeInfected[victim] = true;
				g_iSmokerInfectionCloudEntity[victim] = smoke;
				CreateTimer(0.1, TimerMoveSmokePoof1, victim, TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(20.0, TimerStopInfection, victim, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
}