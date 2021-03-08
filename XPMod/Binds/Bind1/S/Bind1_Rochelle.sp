void Bind1Press_Rochelle(iClient)
{
    if(g_iSmokeLevel[iClient]> 0)
    {
        //Smokers tongue rope
        if((g_bIsClientDown[iClient] == false) && (g_bChargerGrappled[iClient] == false) && (g_bSmokerGrappled[iClient] == false) && (g_bHunterGrappled[iClient] == false))
        if(g_iRopeCountDownTimer[iClient] < 900)
        {
            if(g_bHasDemiGravity[iClient] == false)
            {
                if(!g_bUsingTongueRope[iClient])
                {
                    if(canchangemovement[iClient] == true)
                    {
                        //precache_laser=PrecacheModel("materials/custom/nylonninjarope.vmt");
                        
                        new Float:clientloc[3],Float:clientang[3];
                        GetClientEyePosition(iClient,clientloc); // Get the position of the player's ATTACH_EYES
                        GetClientEyeAngles(iClient,clientang); // Get the angle the player is looking
                        TR_TraceRayFilter(clientloc,clientang,MASK_ALL,RayType_Infinite,TraceRayTryToHit); // Create a ray that tells where the player is looking
                        TR_GetEndPosition(g_xyzRopeEndLocation[iClient]); // Get the end xyz coordinate of where a player is looking
                        g_xyzOriginalRopeDistance[iClient] = GetVectorDistance(clientloc,g_xyzRopeEndLocation[iClient], false);
                        g_xyzOriginalRopeDistance[iClient] *= 0.08;
                        if(g_xyzOriginalRopeDistance[iClient] > (float(g_iSmokeLevel[iClient]) * 40.0))
                        {
                            PrintHintText(iClient, "Your smoker tongue rope doesnt reach beyond %.0f ft.", (float(g_iSmokeLevel[iClient]) * 40.0));
                            return;
                        }
                        //PrintToChat(iClient, "original rope distance = %f", g_xyzOriginalRopeDistance[iClient]);
                        g_bUsingTongueRope[iClient]=true; // Tell plugin the player is roping
                        EmitSoundToAll(SOUND_HOOKGRAB, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);	// Emit sound from the end of the rope
                        SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
                        g_bUsedTongueRope[iClient] = true;
                        g_xyzClientLocation[iClient][0] = clientloc[0];
                        g_xyzClientLocation[iClient][1] = clientloc[1];
                        g_xyzClientLocation[iClient][2] = clientloc[2] - 5.0;
                        CreateTimer(0.1, ShowRopeTimer, iClient, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
                    }
                }
                else
                {
                    EmitSoundToAll(SOUND_HOOKRELEASE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);	// Emit sound from the end of the rope
                    g_bUsingTongueRope[iClient]=false;
                }
            }	
            else
                PrintHintText(iClient,"You Smoker tongue cannot be used while weighted down by Demi Goo");
        }
        else
            PrintHintText(iClient,"Your have already broken your SMOKER tongue rope");
    }
}