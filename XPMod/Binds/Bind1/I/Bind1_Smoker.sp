void Bind1Press_Smoker(iClient)
{
    //Teleportation
    if((g_iClientInfectedClass1[iClient] == SMOKER) || (g_iClientInfectedClass2[iClient] == SMOKER) || (g_iClientInfectedClass3[iClient] == SMOKER))
    {
        if(g_iSmokerTalent3Level[iClient] > 0)
        {
            if(g_bTeleportCoolingDown[iClient] == false)
            {
                if(g_iChokingVictim[iClient] < 1)
                {
                    decl Float:eyeorigin[3], Float:eyeangles[3], Float:endpos[3], Float:vdir[3], Float:distance;
                    GetClientEyePosition(iClient, eyeorigin);
                    GetClientEyeAngles(iClient, eyeangles);
                    GetAngleVectors(eyeangles, vdir, NULL_VECTOR, NULL_VECTOR);	//Get direction in which iClient is facing
                    new Handle:trace = TR_TraceRayFilterEx(eyeorigin, eyeangles, MASK_SHOT, RayType_Infinite, TraceRayDontHitSelf, iClient);
                    if(TR_DidHit(trace))
                    {
                        TR_GetEndPosition(endpos, trace);
                        if(endpos[2] < g_fMapsMaxTeleportHeight)	//This limits the height of teleportation for each map, to prevent from walking in the sky
                        {
                            endpos[0]-=(vdir[0] * 50.0);		//Spawn iClient right ahead of where they were looking
                            endpos[1]-=(vdir[1] * 50.0);
                            //endpos[2]-=(vdir[2] * 50.0);
                            //PrintToChat(iClient, "vdir = %.4f, %.4f, %.4f", vdir[0], vdir[1], vdir[2]);
                            distance = GetVectorDistance(eyeorigin, endpos, false);
                            distance = distance * 0.08;
                            if(distance <= (float(g_iSmokerTalent3Level[iClient]) * 30.0))
                            {
                                decl Float:vorigin[3];
                                GetClientAbsOrigin(iClient, vorigin);
                                TeleportEntity(iClient, endpos, NULL_VECTOR, NULL_VECTOR);
                                EmitSoundToAll(SOUND_WARP_LIFE, iClient, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1,  endpos, NULL_VECTOR, true, 0.0);
                                EmitSoundToAll(SOUND_WARP, SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1,  endpos, NULL_VECTOR, true, 0.0);
                                WriteParticle(iClient, "teleport_warp", 0.0, 7.0);
                                PrintHintText(iClient, "You teleported %.1f ft.", distance);
                                PrintToChat(iClient, "<%f, %f, %f>", endpos[0], endpos[1], endpos[2]);
                                g_fTeleportOriginalPositionX[iClient] = vorigin[0];
                                g_fTeleportOriginalPositionY[iClient] = vorigin[1];
                                g_fTeleportOriginalPositionZ[iClient] = vorigin[2];
                                g_fTeleportEndPositionX[iClient] = endpos[0];
                                g_fTeleportEndPositionY[iClient] = endpos[1];
                                g_fTeleportEndPositionZ[iClient] = endpos[2];
                                CreateTimer(3.0, CheckIfStuck, iClient, TIMER_FLAG_NO_MAPCHANGE);		//Check if the player is stuck in a wall
                                g_bTeleportCoolingDown[iClient] = true;
                                CreateTimer(10.0, ReallowTeleport, iClient, TIMER_FLAG_NO_MAPCHANGE);	//After 10 seconds reallow teleportation fot the iClient
                                
                                //Make smoker transparent and set him to gradually become more opaque
                                g_iSmokerTransparency[iClient] = g_iSmokerTalent3Level[iClient] * 30;
                                SetEntityRenderMode(iClient, RenderMode:3);
                                SetEntityRenderColor(iClient, 0, 0, 0, 0);
                            }
                            else
                                PrintHintText(iClient, "You cannot teleport beyond %.0f ft.", (float(g_iSmokerTalent3Level[iClient]) * 30.0));
                        }
                        else
                            PrintHintText(iClient, "You cannot teleport to this location.");
                    }
                    else
                        PrintHintText(iClient, "You cannot teleport to this location.");
                        
                    CloseHandle(trace);
                }
                else
                    PrintHintText(iClient, "You cannot teleport while choking a victim.");
            }
            else
                PrintHintText(iClient, "You must wait 10 seconds between teleportations.");
        }
        else
            PrintHintText(iClient, "You must have Noxious Gasses (Level 1) for Smoker Bind 1");
    }
    else
        PrintHintText(iClient, "You dont have the Smoker as one of your classes");
}