//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////       XP AND TALENT FUNCTIONS       ///////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/**************************************************************************************************************************
 *                                                     Load Talents                                                       *
 **************************************************************************************************************************/
void LoadTalents(int iClient)
{
	if (RunClientChecks(iClient) == false || 
		g_bClientLoggedIn[iClient] == false ||
		g_iClientTeam[iClient] == TEAM_SPECTATORS ||
		g_bClientSpectating[iClient] == true ||
		IsClientInGame(iClient) == false ||
		IsFakeClient(iClient) == true || 
		IsPlayerAlive(iClient) == false ||
		GetEntData(iClient, g_iOffset_IsGhost, 1) == 1)
		return;
	

	if (g_iClientTeam[iClient] == TEAM_INFECTED)
	{
		g_iInfectedCharacter[iClient] = GetEntProp(iClient, Prop_Send, "m_zombieClass");
		
		switch(g_iInfectedCharacter[iClient])
		{
			case SMOKER:	TalentsLoad_Smoker(iClient);
			case BOOMER:	TalentsLoad_Boomer(iClient);
			case HUNTER:	TalentsLoad_Hunter(iClient);
			case SPITTER:	TalentsLoad_Spitter(iClient);
			case JOCKEY:	TalentsLoad_Jockey(iClient);
			case CHARGER:	TalentsLoad_Charger(iClient);
			case TANK:		TalentsLoad_Tank(iClient);
		}
	}
	else if (g_iClientTeam[iClient] == TEAM_SURVIVORS)		//Survivor Talents
	{
		SetSurvivorModel(iClient);	//Spawn their character (change their character model)
		DeleteAllClientParticles(iClient);
		SetClientRenderAndGlowColor(iClient);

		if(g_bSurvivorTalentsGivenThisRound[iClient] == false)
		{
			g_iSavedClip[iClient] = 0;
			g_bForceReload[iClient] = false;
			
			switch(g_iChosenSurvivor[iClient])
			{
				case BILL:		TalentsLoad_Bill(iClient);
				case ROCHELLE:	TalentsLoad_Rochelle(iClient);
				case COACH:		TalentsLoad_Coach(iClient);
				case ELLIS:		TalentsLoad_Ellis(iClient);
				case NICK:		TalentsLoad_Nick(iClient);
				case LOUIS:		TalentsLoad_Louis(iClient);
			}
			
			if( (g_iClientLevel[iClient] - (g_iClientLevel[iClient] - g_iSkillPoints[iClient])) <= (g_iClientLevel[iClient] - 1))	//Show Ring Effect if they have leveled up a talent
			{
				float pos[3];
				int color[4];
				switch(g_iChosenSurvivor[iClient])
				{
					case BILL: 		{ color[0] = 0;		color[1] = 0; 	color[2] = 255;	color[3] = 255; }
					case ROCHELLE: 	{ color[0] = 150;	color[1] = 0; 	color[2] = 255;	color[3] = 255; }
					case COACH: 	{ color[0] = 160;	color[1] = 0; 	color[2] = 0;	color[3] = 255; }
					case ELLIS: 	{ color[0] = 255;	color[1] = 80; 	color[2] = 0;	color[3] = 255; }
					case NICK: 		{ color[0] = 255;	color[1] = 255;	color[2] = 255;	color[3] = 255; }
					case LOUIS: 	{ color[0] = 0;		color[1] = 255;	color[2] = 50;	color[3] = 255; }
				}
				
				GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", pos);
				
				int i;
				for(i = 0; i < 30; i++)		//15
				{
					pos[2] += 3.0;	//5.0
					TE_Start("BeamRingPoint");
					TE_WriteVector("m_vecCenter", pos);
					TE_WriteFloat("m_flStartRadius", 10.0);
					TE_WriteFloat("m_flEndRadius", 90.0);
					TE_WriteNum("m_nModelIndex", g_iSprite_Laser);
					TE_WriteNum("m_nHaloIndex", g_iSprite_Glow);
					TE_WriteNum("m_nStartFrame", 0);
					TE_WriteNum("m_nFrameRate", 60);
					TE_WriteFloat("m_fLife", 0.9);
					TE_WriteFloat("m_fWidth", 0.1); //5.0
					TE_WriteFloat("m_fEndWidth", 0.1);
					TE_WriteFloat("m_fAmplitude",  0.0);
					TE_WriteNum("r", color[0]);
					TE_WriteNum("g", color[1]);
					TE_WriteNum("b", color[2]);
					TE_WriteNum("a", color[3]);
					TE_WriteNum("m_nSpeed", 10);
					TE_WriteNum("m_nFlags", 0);
					TE_WriteNum("m_nFadeLength", 0);
					TE_SendToAll();
				}
				
				EmitSoundToAll(SOUND_TALENTS_LOAD1, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.75, SNDPITCH_NORMAL, -1, pos, NULL_VECTOR, true, 0.0);
				EmitSoundToAll(SOUND_TALENTS_LOAD2, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, pos, NULL_VECTOR, true, 0.0);
			}
		
			//This is for if they are black and white
			SetEntProp(iClient, Prop_Send, "m_isGoingToDie", 0);
			//Give them their weapons
			SpawnWeapons(iClient);

			g_bSurvivorTalentsGivenThisRound[iClient] = true;	//Block Surivor Talents from being given again to the same iClient
		}		
	}

	// Capture the players health for functionality like self revive on ledge
	CreateTimer(0.1, TimerStorePlayerHealth, iClient, TIMER_FLAG_NO_MAPCHANGE);

	// Reset client speed
	// This is mainly for the load talent delay
	SetClientSpeed(iClient);
}
