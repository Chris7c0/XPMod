SetClientRenderColor(iClient, iRed = 255, iGreen = 255, iBlue = 255, iAlpha = 255, iRenderMode = RENDER_MODE_NORMAL)
{
	if (IsValidEntity(iClient) == false)
		return;
	
	SetEntityRenderMode(iClient, RenderMode:iRenderMode);
	SetEntityRenderColor(iClient, iRed, iGreen, iBlue, iAlpha);
}

// 0 0 0 and GLOWTYPE_NORMAL sets normal glow
// 1 0 0 and GLOWTYPE_CONSTANT needs to be used to hide glow
SetClientGlow(iClient, iRed = 0, iGreen = 0, iBlue = 0, iGlowType = GLOWTYPE_NORMAL)
{
	if (IsValidEntity(iClient) ==  false)
		return;
	
	SetEntProp(iClient, Prop_Send, "m_iGlowType", iGlowType);
	SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
	SetEntProp(iClient, Prop_Send, "m_glowColorOverride", iRed + (iGreen * 256) + (iBlue * 65536));
}

SetClientRenderAndGlowColor(int iClient)
{
	if (RunClientChecks(iClient) == false || 
		IsPlayerAlive(iClient) ==  false ||
		g_bGameFrozen)
		return;

	// Overrides
	// Remove Smoker victim's glow
	if (g_bSmokerVictimGlowDisabled[iClient] == true)
	{
		SetClientGlow(iClient, 1, 0, 0, GLOWTYPE_CONSTANT);
		return;
	}

	if(g_iClientTeam[iClient] == TEAM_SURVIVORS)
	{
		switch(g_iChosenSurvivor[iClient] && g_bTalentsConfirmed[iClient])
		{
			case BILL:
			{
				if (g_iGhillieLevel[iClient] > 0)
				{
					// Check and update if bill is grappled or down
					if (IsClientGrappled(iClient) == false && g_bIsClientDown[iClient] == false)
					{					
						// Cloaking Suit values
						new iAlpha = RoundToFloor(255 * (1.0 - (((float(g_iGhillieLevel[iClient]) * 0.13) + ((float(g_iPromotionalLevel[iClient]) * 0.04))))));
						SetClientRenderColor(iClient, 255, 255, 255, iAlpha, RENDER_MODE_TRANSPARENT);
						SetClientGlow(iClient, 1, 0, 0, GLOWTYPE_CONSTANT);
						return;
					}
					else if (IsClientGrappled(iClient) == true || g_bIsClientDown[iClient] == true)
					{
						// Reset to normal rendering
						SetClientRenderColor(iClient);
						SetClientGlow(iClient)
						return;
					}
				}
			}
			case ROCHELLE:
			{
				if(g_bUsingShadowNinja[iClient] == true)
				{
					// Shadow Ninja colors
					new iAlpha = RoundToFloor(255 * (1.0 - (float(g_iShadowLevel[iClient]) * 0.19)));
					SetClientRenderColor(iClient, 255, 255, 255, iAlpha, RENDER_MODE_TRANSPARENT);
					SetClientGlow(iClient, 1, 0, 0, GLOWTYPE_CONSTANT);
					return;
				}
			}
			case ELLIS:
			{
				if(g_bUsingFireStorm[iClient] == true)
				{
					// Fire Storm colors
					SetClientRenderColor(iClient, 210, 88, 30, 255, RENDER_MODE_NORMAL);
					SetClientGlow(iClient, 210, 88, 30, GLOWTYPE_CONSTANT);
					return;
				}
			}
			case NICK:
			{
				if(g_bNickIsInvisible[iClient] == true)
				{
					// Make Nick invisible
					SetClientRenderColor(iClient, 255, 255, 255, 0, RENDER_MODE_TRANSPARENT);
					SetClientGlow(iClient, 1, 0, 0, GLOWTYPE_CONSTANT);
					return;
				}
			}
		}
	}
	else if(g_iClientTeam[iClient] == TEAM_INFECTED && g_bTalentsConfirmed[iClient])
	{
		switch(g_iInfectedCharacter[iClient])
		{
			case SMOKER:
			{
				// Cloak smoker while he has a victim
				if (g_bSmokerIsCloaked[iClient] == true)
				{
					SetClientRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (g_iSmokerTalent2Level[iClient] * 0.085))), RENDER_MODE_TRANSPARENT);
					return;
				}
				// Hide smoker while he is a smoke cloud
				if (g_bSmokerIsSmokeCloud[iClient] == true)
				{
					SetClientRenderColor(iClient, 255, 255, 255, 0, RENDER_MODE_TRANSPARENT);
					SetClientGlow(iClient, 1, 0, 0, GLOWTYPE_CONSTANT);
					return;
				}
			}
			case HUNTER:
			{
				// Hunter Killmeleon hidden glow and transparency
				// Note, the transisitioning transparency is handled elsewhere, being called frequently
				if((g_iHunterShreddingVictim[iClient] != -1) && (g_iKillmeleonLevel[iClient] >= 5))
				{
					// Hide the glow
					SetClientRenderColor(iClient, 255, 255, 255, 255, RENDER_MODE_TRANSPARENT);
					SetClientGlow(iClient, 1, 0, 0, GLOWTYPE_CONSTANT);
					return;
				}
				else if((g_iHunterShreddingVictim[iClient] == -1) && (g_iKillmeleonLevel[iClient] >= 5))
				{
					// Show the glow
					SetClientRenderColor(iClient);
					SetClientGlow(iClient);
					return;
				}
			}
		}
	}

	// Set to default glow/color, if no other value was set
	SetClientRenderColor(iClient);
	SetClientGlow(iClient);
}