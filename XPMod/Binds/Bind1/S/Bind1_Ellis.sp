void Bind1Press_Ellis(int iClient)
{
    if(g_iMetalLevel[iClient]> 0)	//Ellis's Ammo Bind
    {
        if(g_iClientBindUses_1[iClient]<3)
        {
            if((GetEntityFlags(iClient) & FL_ONGROUND))
            {
                float vorigin[3], vangles[3], topvec[3];
                GetLocationVectorInfrontOfClient(iClient, vorigin, vangles);
                
                int ammopile = CreateEntityByName("weapon_ammo_spawn");
                DispatchKeyValueVector(ammopile, "Origin", vorigin);
                DispatchKeyValueVector(ammopile, "Angles", vangles);
                DispatchKeyValue(ammopile, "solid", "2");
                DispatchKeyValue(ammopile, "spawnflags", "2");
                DispatchSpawn(ammopile);
                SetEntityModel(ammopile, "models/props_unique/spawn_apartment/coffeeammo.mdl");
                // Set the ammo pile to not be solid to prevent glitches like blocking saferoom door
                SetEntProp(ammopile, Prop_Send, "m_nSolidType", 0);
                
                //Show the arrow under the ammo sprite
                vorigin[2] += 10.0;
                topvec[0] = vorigin[0];
                topvec[1] = vorigin[1];
                topvec[2] = vorigin[2] + 125.0;
                TE_SetupBeamPoints(vorigin,topvec,g_iSprite_Arrow,0,0,0,20.0,2.0,6.0, 1,0.0,{255, 255, 255, 255}, 10);
                TE_SendToAll();
                //Show the ammo sprite
                vorigin[2] += 135.0;
                topvec[0] = vorigin[0];
                topvec[1] = vorigin[1];
                topvec[2] = vorigin[2] + 98.0;
                TE_SetupBeamPoints(topvec,vorigin,g_iSprite_AmmoBox,0,0,0,20.0,55.0,55.0, 1,0.0,{255, 255, 255, 255},0);
                TE_SendToAll();
                
                g_iClientBindUses_1[iClient]++;
                int uses = 3 - g_iClientBindUses_1[iClient];
                PrintHintText(iClient, "Your have deployed ammo for the team, %d ammo piles remain", uses);
            }
            else
                PrintHintText(iClient, "Your must be on the ground to deploy ammo.");
        }
        else
            PrintHintText(iClient, "You are out of ammo piles.");
    }
}
