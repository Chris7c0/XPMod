void Bind1Press_Coach(iClient)
{
    if(g_iLeadLevel[iClient]> 0)	//Coach's Turret Gun Bind
    {
        if(g_iClientBindUses_1[iClient]<3)
        {
            if((GetEntityFlags(iClient) & FL_ONGROUND))
            {
                decl Float:vorigin[3], Float:vangles[3];
                GetLocationVectorInfrontOfClient(iClient, vorigin, vangles);
                
                g_iClientBindUses_1[iClient]++;
                new uses = 3 - g_iClientBindUses_1[iClient];
                decl random_turret;
                random_turret = GetRandomInt(0,1);
                switch (random_turret)
                {
                    case 0: //Minigun
                    {
                        new minigun = CreateEntityByName("prop_minigun_l4d1");	//Create the gun entity to spawn
                        DispatchKeyValue(minigun, "model", "Minigun_1");
                        SetEntityModel(minigun, "models/w_models/weapons/w_minigun.mdl");
                        DispatchKeyValueFloat (minigun, "MaxYaw", 180.0);		//Set the guns shooting angle limits
                        DispatchKeyValueFloat (minigun, "MinPitch", -90.0);
                        DispatchKeyValueFloat (minigun, "MaxPitch", 90.0);
                        DispatchKeyValueVector(minigun, "Angles", vangles);		//Angles for iClient pressing use to get on the gun
                        DispatchKeyValueFloat(minigun, "spawnflags", 256.0);
                        DispatchKeyValueFloat(minigun, "solid", 0.0);
                        DispatchSpawn(minigun);
                        TeleportEntity(minigun, vorigin, vangles, NULL_VECTOR);
                        PrintHintText(iClient, "You mounted a minigun to help protect your team from the masses.\n%d uses remain.", uses);
                    }
                    case 1: //50cal
                    {
                        new minigun = CreateEntityByName("prop_minigun");	//Create the gun entity to spawn
                        DispatchKeyValue(minigun, "model", "Minigun_1");
                        SetEntityModel(minigun, "models/w_models/weapons/50cal.mdl");
                        DispatchKeyValueFloat (minigun, "MaxYaw", 180.0);		//Set the guns shooting angle limits
                        DispatchKeyValueFloat (minigun, "MinPitch", -90.0);
                        DispatchKeyValueFloat (minigun, "MaxPitch", 90.0);
                        DispatchKeyValueVector(minigun, "Angles", vangles);		//Angles for iClient pressing use to get on the gun
                        DispatchKeyValueFloat(minigun, "spawnflags", 256.0);
                        DispatchKeyValueFloat(minigun, "solid", 0.0);
                        DispatchSpawn(minigun);
                        TeleportEntity(minigun, vorigin, vangles, NULL_VECTOR);
                        PrintHintText(iClient, "You mounted a 50 caliber machine gun to help protect your team from the masses.\n%d uses remain.", uses);
                    }
                }
                switch(g_iClientBindUses_1[iClient])
                {
                    case 1:
                        DeleteParticleEntity(g_iPID_CoachCharge1[iClient]);
                    case 2:
                        DeleteParticleEntity(g_iPID_CoachCharge2[iClient]);
                    case 3:
                        DeleteParticleEntity(g_iPID_CoachCharge3[iClient]);
                }
            }
            else
                PrintHintText(iClient, "Your must be on the ground before deployment.");
        }
        else
            PrintHintText(iClient, "Your out of mountable turrets.");
    }
}