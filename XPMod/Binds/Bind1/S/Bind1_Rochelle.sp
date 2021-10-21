void Bind1Press_Rochelle(iClient)
{
	if(g_iSmokeLevel[iClient]> 0)
	{
		//Smokers tongue rope
		if(g_bIsClientDown[iClient] == false && IsClientGrappled(iClient) == false)
		{
			if (g_iRopeCountDownTimer[iClient] < ROCHELLE_ROPE_DURATION)
			{
				if(g_bHasDemiGravity[iClient] == false)
				{
					if(g_bUsingTongueRope[iClient] == false)
					{
						if(canchangemovement[iClient] == true)
						{
							float xyzClientLocation[3], xyzClientAngles[3];
							GetClientEyePosition(iClient,xyzClientLocation); // Get the position of the player's ATTACH_EYES
							GetClientEyeAngles(iClient,xyzClientAngles); // Get the angle the player is looking
							TR_TraceRayFilter(xyzClientLocation,xyzClientAngles,MASK_ALL,RayType_Infinite,TraceRayTryToHit); // Create a ray that tells where the player is looking
							TR_GetEndPosition(g_xyzRopeEndLocation[iClient]); // Get the end xyz coordinate of where a player is looking
							float fRopeDistance = GetVectorDistance(xyzClientLocation,g_xyzRopeEndLocation[iClient], false);
							fRopeDistance *= 0.08;
							if(fRopeDistance > (float(g_iSmokeLevel[iClient]) * 40.0))
							{
								PrintHintText(iClient, "Your smoker tongue rope doesn't reach beyond %.0f ft.", (float(g_iSmokeLevel[iClient]) * 40.0));
								return;
							}

							// Enable the rope
							g_bUsingTongueRope[iClient]=true;
							g_bUsedTongueRope[iClient] = true;
							EmitSoundToAll(SOUND_HOOKGRAB, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);	// Emit sound from the end of the rope
							SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);

							// Create the visual rope
							CreateSmokerTongueNinjaRope(iClient);
						}
					}
					else
					{
						DisableNinjaRope(iClient);
					}
				}	
				else
					PrintHintText(iClient,"You Smoker tongue cannot be used while weighted down by Demi Goo");
			}
			else
				PrintHintText(iClient,"Your have already broken your SMOKER tongue rope");
		}
	}
}

void CreateSmokerTongueNinjaRope(int iClient)
{
	float xyzLocation[3];
	g_iRochelleRopeDummyEntityAttachmentHand[iClient] = CreateDummyEntity(xyzLocation, -1.0, iClient, "muzzle_flash");
	g_iRochelleRopeDummyEntityAttachmentWall[iClient] = CreateDummyEntity(g_xyzRopeEndLocation[iClient]);
	
	CreateBeamEntity(
		g_iRochelleRopeDummyEntityAttachmentHand[iClient], 
		g_iRochelleRopeDummyEntityAttachmentWall[iClient],
		g_iSprite_SmokerTongue,
		125, 125, 125, 255,
		60.0,
		3.0,
		3.0);
}

void DisableNinjaRope(int iClient, bool bPlaySound = true)
{
	if (g_bUsingTongueRope[iClient] == false)
		return;

	g_bUsingTongueRope[iClient]=false;
	KillAllNinjaRopeEntities(iClient);

	if (bPlaySound && 
		RunClientChecks(iClient) && 
		IsPlayerAlive(iClient))
		EmitSoundToAll(SOUND_HOOKRELEASE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);	// Emit sound from the end of the rope
}

void KillAllNinjaRopeEntities(int iClient)
{
	KillEntitySafely(g_iRochelleRopeDummyEntityAttachmentWall[iClient]);
	KillEntitySafely(g_iRochelleRopeDummyEntityAttachmentHand[iClient]);
}