void Bind2Press_Louis(iClient)
{
    SuppressNeverUsedWarning(iClient);
}



public Action:TimeScale(client, args)
{
	decl i_Ent, String:arg[12];
	if(args == 1)
	{
		GetCmdArg(1, arg, sizeof(arg));
		new Float:scale = StringToFloat(arg);
		if(scale == 0.0)
		{
			ReplyToCommand(client, "[SM] Invalid Float!");
			return;
		}	
		i_Ent = CreateEntityByName("func_timescale");
		DispatchKeyValue(i_Ent, "desiredTimescale", arg);
		DispatchKeyValue(i_Ent, "acceleration", "2.0");
		DispatchKeyValue(i_Ent, "minBlendRate", "1.0");
		DispatchKeyValue(i_Ent, "blendDeltaMultiplier", "2.0");
		DispatchSpawn(i_Ent);
		AcceptEntityInput(i_Ent, "Start");
	}
	else
	{
		ReplyToCommand(client, "[SM] Usage: sm_timescale <float>");
	}	
}

void KillAllCI(iClient)
{
	for (int i=1; i < MAXENTITIES; i++)
	{
		if (IsValidEntity(i) && IsCommonInfected(i, ""))
		{
			DealDamage(i, iClient, 9999);
			DealDamage(i, iClient, 9999);
			DealDamage(i, iClient, 9999);
			DealDamage(i, iClient, 9999);
			DealDamage(i, iClient, 9999);
		}
	}
}