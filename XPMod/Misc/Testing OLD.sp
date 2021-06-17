
//Testing Functions//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Action:GiveMoreBinds(admin, args)
{
	g_iClientBindUses_1[admin] = -99;
	g_iClientBindUses_2[admin] = -99;
}

// Action:ChangeSpeed(iClient, args)
// {
// 	//rspeed = 0.9;
// 	if(args==1)
// 	{
// 		decl String:targetname[128];
// 		GetCmdArg(1, targetname, sizeof(targetname));
// 		rspeed = StringToFloat(targetname);
// 	}
// 	PrintToChat(iClient, "global reload speed = %f", rspeed);
// }

//new Float:g_fEllisTestFireRate = 0.0;
Action:TestFunction1(iClient, args)
{
	PrintToServer("T1");
	//PrintToChat(iClient, "T1");

	if (args < 1) return Plugin_Stop;
	
	char str1[99];
	char str2[99];
	GetCmdArg(1, str1, sizeof(str1));
	GetCmdArg(2, str2, sizeof(str2));

	//g_fEllisTestFireRate = StringToFloat(str1);

	//VAMPIRIC_TANK_WING_FLAP_UP_VELOCITY = StringToFloat(str1);
	VAMPIRIC_TANK_WING_DASH_VELOCITY = StringToFloat(str1);
	
	//SetClientInfo(iClient, "name", str1);
	WriteParticle(iClient, str1, 0.0, 30.0);

	//AddTempHealthToSurvivor(iClient, StringToFloat(str));

	//OpenMOTDPanel(iClient, "t1" , str, MOTDPANEL_TYPE_FILE);
	//OpenMOTDPanel(iClient, "t1" , "http://xpmod.net/blah.html", MOTDPANEL_TYPE_URL);
	//OpenMOTDPanel(iClient, "t1." , "<html><head><title>a</title><meta http-equiv = \"Content-Type\" content = \"text / html; charset = utf-8\" ></head><body bgcolor = \"# 000000\" ><p>test</p></body></html>", MOTDPANEL_TYPE_URL);
	//OpenMOTDPanel(iClient, "t1." , "<html> <body> test <script> window.open('http://xpmod.net', '_blank'); </script> </body> </html>", MOTDPANEL_TYPE_URL);
	//Finding offset for SI cooldowns // Windows is 1084 Linux is +20 1104
	//g_iOffset_NextActivation = StringToInt(str);

	//DealDamage(StringToInt(str1), iClient, 1, StringToInt(str2));

	return Plugin_Stop;
}

Action:TestFunction2(iClient, args)
{
	PrintToServer("T2");

	decl Float:xyzClientLocation[3];
	GetClientAbsOrigin(iClient, xyzClientLocation);
	xyzClientLocation[2] += 30.0;
	WriteParticle(iClient, "mini_fireworks", 0.0, 10.0, xyzClientLocation);

	// if (RunClientChecks(iClient) == false) PrintToChat(iClient, "T1");

	//PrintToChat(iClient, "m_healthBuffer %f", GetEntPropFloat(iClient, Prop_Send, "m_healthBuffer"));
	//PrintToChat(iClient, "settime %f, Gametime: %f, diff: %f", GetEntPropFloat(iClient, Prop_Send, "m_healthBufferTime"), GetGameTime(), GetGameTime() - GetEntPropFloat(iClient, Prop_Send, "m_healthBufferTime"));
	//PrintToChat(iClient, "temp_health %i", GetSurvivorTempHealth(iClient));

	//OpenMOTDPanel(iClient, "t2" , "http://xpmod.net/blah.html", MOTDPANEL_TYPE_URL);
	//OpenMOTDPanel(iClient, "t1." , "<html><head><title>a</title><meta http-equiv = \"Content-Type\" content = \"text / html; charset = utf-8\" ></head><body bgcolor = \"# 000000\" ><p>test</p></body></html>", MOTDPANEL_TYPE_INDEX);

	return Plugin_Stop;
}


Action:TestFunction3(iClient, args)
{
	PrintToChat(iClient, "T3");
	char str1[99];
	GetCmdArg(1, str1, sizeof(str1));

	SpawnSpecialInfected(iClient);

	//OpenMOTDPanel(iClient, "t3" , " .", MOTDPANEL_TYPE_URL);
	//OpenMOTDPanel(iClient, "t3." , "<html><head><title>a</title><meta http-equiv = \"Content-Type\" content = \"text / html; charset = utf-8\" ></head><body bgcolor = \"# 000000\" ><p>test</p></body></html>", MOTDPANEL_TYPE_TEXT);
	return Plugin_Stop;
}

Action:TestFunction4(iClient, args)
{
	PrintToServer("T4");
	char str1[99];
	GetCmdArg(1, str1, sizeof(str1));

	SDKCall(g_hSDK_UnVomitOnPlayer, iClient);
	
	//OpenMOTDPanel(iClient, "t4" , " .", MOTDPANEL_TYPE_INDEX);
	//OpenMOTDPanel(iClient, "t4." , "<html><head><title>a</title><meta http-equiv = \"Content-Type\" content = \"text / html; charset = utf-8\" ></head><body bgcolor = \"# 000000\" ><p>test</p></body></html>", MOTDPANEL_TYPE_INDEX);
	return Plugin_Stop;
}

Action:TestFunction5(iClient, args)
{
	//PrintToChat(iClient, "T5");
	g_iFlag_SpawnOld = GetCommandFlags("z_spawn_old");
	SetCommandFlags("z_spawn_old", g_iFlag_SpawnOld & ~FCVAR_CHEAT);
	RunCheatCommand(iClient, "z_spawn_old", "z_spawn_old tank auto");
	SetCommandFlags("z_spawn_old", g_iFlag_SpawnOld);

	//OpenMOTDPanel(iClient, "t5" , " .", MOTDPANEL_TYPE_FILE);
	//OpenMOTDPanel(iClient, "t5." , "/cfg/server.cfg", MOTDPANEL_TYPE_FILE);

	return Plugin_Stop;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*
CloseMOTDPanel(iClient)
{
	if(IsClientInGame(iClient) == false)
		return;
	if(IsFakeClient(iClient) == true)
		return;
	
	new Handle:Kv = CreateKeyValues("data");
	KvSetString(Kv, "title", " ");
	KvSetString(Kv, "type", "0");
	KvSetString(Kv, "msg", " ");
	ShowVGUIPanel(iClient, "info", Kv, false);
	CloseHandle(Kv);
}*/

/*
//p3tsin credit
bool:SetLongMOTD(const String:panel[],const String:text[])
{
	new table = FindStringTable("InfoPanel");
	
	if(table != INVALID_STRING_TABLE)
	{		
		new len = strlen(text);
		new str = FindStringIndex(table,panel);
		new bool:locked = LockStringTables(false);
		
		if(str == INVALID_STRING_INDEX || str == 65535)
		{
			AddToStringTable(table,panel,text,len);
			//PrintToServer("---------------------- Adding String %s to InfoPanel Table", panel);
		}
		else
		{
			SetStringTableData(table,str,text,len);
			//PrintToServer("--------------0------- Replacing String %s to InfoPanel Table Slot %d", panel, str);
		}
		
		LockStringTables(locked);
		return true;
	}
	
	return false;
}*/

/*
TE_Particle(String:Name[],
            Float:origin[3]=NULL_VECTOR,
            Float:start[3]=NULL_VECTOR,
            Float:angles[3]=NULL_VECTOR,
            entindex=-1,
            attachtype=-1,
            attachpoint=-1,
            bool:resetParticles=true,
            Float:delay=0.0)
{
    // find string table
    new tblidx = FindStringTable("ParticleEffectNames");
    if (tblidx==INVALID_STRING_TABLE) 
    {
        PrintToChatAll("Could not find string table: ParticleEffectNames");
        return;
    }
    
    // find particle index
    new String:tmp[256];
    new count = GetStringTableNumStrings(tblidx);
    new stridx = INVALID_STRING_INDEX;
    new i;
    for (i=0; i<count; i++)
    {
        ReadStringTable(tblidx, i, tmp, sizeof(tmp));
        if (StrEqual(tmp, Name, false))
        {
            stridx = i;
            break;
        }
    }
    if (stridx==INVALID_STRING_INDEX)
    {
        PrintToChatAll("Could not find particle index");
        return;
    }
    
    TE_Start("EffectDispatch");
    //TE_WriteFloat("m_vOrigin.x", origin[0]);
    //TE_WriteFloat("m_vOrigin.y", origin[1]);
    //TE_WriteFloat("m_vOrigin.z", origin[2]);
    TE_WriteFloat("m_vStart.x", start[0]);
    TE_WriteFloat("m_vStart.y", start[1]);
    TE_WriteFloat("m_vStart.z", start[2]);
    //TE_WriteVector("m_vAngles", angles);
	//TE_WriteVector("m_vNormal", angles);
	//TE_WriteNum("m_fFlags", 0);
	//TE_WriteFloat("m_flMagnitude", 1.0);
	//TE_WriteFloat("m_flScale", 1.0);
	//TE_WriteNum("m_nAttachmentIndex", entindex);
	//TE_WriteNum("m_nSurfaceProp", 1);
	TE_WriteNum("m_iEffectName", stridx);
	//TE_WriteNum("m_nMaterial", 1);
	//TE_WriteNum("m_nDamageType", 1);
	//TE_WriteNum("m_nHitBox", 1);
	//if (entindex!=-1)
    //    TE_WriteNum("entindex", entindex);
    //TE_WriteNum("m_nColor", 255);
    //TE_WriteFloat("m_flRadius", 100.0);
    //TE_WriteNum("m_bResetParticles", resetParticles ? 1 : 0);    
    TE_SendToClient(entindex);
}

Action:Command_sprite(iClient, args) 
{
	if(iClient == 0)
		iClient = 1;
	decl Float:origin[3];
	GetClientEyePosition(iClient, origin);
	if(args==2) 
	{
		decl String:arg1[32], String:arg2[128];
		GetCmdArg(1, arg1, sizeof(arg1));
		GetCmdArg(2, arg2, sizeof(arg2));
		new targ = FindPlayerByName(iClient, arg1);
		if(targ!=-1) {
			new ent = CreateEntityByName("env_sprite");
			if(ent!=-1) 
			{
				decl String:buffer[256], Float:vecOrigin[3];
				Format(buffer, sizeof(buffer), "iClient%i", targ);
				DispatchKeyValue(targ, "targetname", buffer);
				DispatchKeyValue(ent, "model", arg2);
				DispatchSpawn(ent);
				GetClientEyePosition(targ, vecOrigin);
				vecOrigin[2] += 32.0;
				TeleportEntity(ent, vecOrigin, NULL_VECTOR, NULL_VECTOR);
				SetVariantString(buffer);
				AcceptEntityInput(ent, "SetParent");
				//new FlashColor[4];
				//FlashColor = {225,225,225,225};
				//TE_SetupGlowSprite(vecOrigin, arg2, 10, 1000, FlashColor);
				//TE_SendToAll();
				new color[4];
				color[0] = 255;
				color[1] = 255;
				color[2] = 255;
				color[3] = 255;
				//BeamEffect("@all",origin,vecOrigin,10.0,3.0,3.0,color,0.0,0);
			}
		}
	} 
	else 
	{
		ReplyToCommand(iClient, "[SM] Usage: sprite <name/#userid> <model>");
	}
}

Action:Command_Respawn(iClient, args)
{
	if (args < 1)
	{
		ReplyToCommand(iClient, "[XPMod] Improper use of respawn");
		return Plugin_Handled;
	}

	decl player_id, String:player[64];
	
	for(new i = 0; i < args; i++)
	{
		GetCmdArg(i+1, player, sizeof(player));
		player_id = FindTarget(iClient, player);
		
		switch(GetClientTeam(player_id))
		{
			case 2:
			{
				SDKCall(g_hSDK_RoundRespawn, player_id);
				
				//if( !SetTeleportEndPoint(iClient) || iClient == player_id)
				//{
				//	return Plugin_Handled;
				//}
				//PerformTeleport(iClient,player_id,g_pos);
				return Plugin_Handled;
			}
			
			case 3:
			{
				SDKCall(g_hSDK_StateTransition, player_id, 8);
				SDKCall(g_hSDK_BecomeGhost, player_id, 1);
				SDKCall(g_hSDK_StateTransition, player_id, 6);
				SDKCall(g_hSDK_BecomeGhost, player_id, 1);
			}
		}
	}
	return Plugin_Handled;
}
*/
/* No longer works because Valve removed ClientCommand functionality

ToggleThirdPerson(iClient)
{
	if(thirdperson[iClient] == false)
	{
		//This code was taken from Pan Xiaohai's "ThirdPerson View" plugin
		thirdperson[iClient] = true;
		ClientCommand(iClient, "thirdpersonshoulder");
		ClientCommand(iClient, "c_thirdpersonshoulder 0");
		ClientCommand(iClient, "thirdpersonshoulder");
		ClientCommand(iClient, "c_thirdpersonshoulderoffset 0");
		ClientCommand(iClient, "c_thirdpersonshoulderaimdist 720");
		ClientCommand(iClient, "cam_ideallag 0");
		if(GetClientTeam(iClient)==3)	ClientCommand(iClient, "cam_idealdist 90");
		else ClientCommand(iClient, "cam_idealdist 40");
		
		ClientCommand(iClient, "bind leftarrow \"incrementvar cam_idealdist 30 130 10\"");
		ClientCommand(iClient, "bind rightarrow \"incrementvar cam_idealdist 30 130 -10\"");
		
		ClientCommand(iClient, "bind uparrow \"incrementvar c_thirdpersonshoulderheight 5 25 5\"");
		ClientCommand(iClient, "bind downarrow \"incrementvar c_thirdpersonshoulderheight 5 25 -5\"");
		
		PrintToChat(iClient, "\x03[XPMod] \x05Third Person Enabled:  Press\x04 arrow keys \x05to adjust your view");
	}
	else
	{
		thirdperson[iClient] = false;
		ClientCommand(iClient, "thirdpersonshoulder");
		ClientCommand(iClient, "c_thirdpersonshoulder 0");
		PrintToChat(iClient, "\x03[XPMod] \x05First Person Enabled");
	}
}
*/

// testingShowHud(iClient)
// {
// 	Doesnt work in l4d2...lame
// 	SetHudTextParams(-1.0, -1.0, 30.0, 255, 255, 255, 255, 0, 0.0, 0.1, 0.1);
// 	ShowHudText(iClient, -1, "THIS IS A TEST BLAH BLAH BLAH");
// }

/*
PrintInstructorText(iClient, String:msg[256], String:color[], String:bind[])
{
	if(iClient < 1)
		return;
	if(IsClientInGame(iClient) == false)
		return;
	if(IsFakeClient(iClient) == true)
		return;
	new Handle:messagepack;
	ClientCommand(iClient, "gameinstructor_enable 1");
	messagepack = CreateDataPack();
	WritePackCell(messagepack, iClient);
	WritePackString(messagepack, msg);
	WritePackString(messagepack, color);
	WritePackString(messagepack, bind);
	CreateTimer(3.0, DisplayInstructorTimer, messagepack);
}

Action:DisplayInstructorTimer(Handle:timer, Handle:pack)
{
	decl iClient;
	decl String:string[256], String:color[15], String:bind[32];
	
	ResetPack(pack);
	iClient = ReadPackCell(pack);
	ReadPackString(pack, string, sizeof(string));
	ReadPackString(pack, color, sizeof(color));
	ReadPackString(pack, bind, sizeof(bind));
	CloseHandle(pack);
	if(iClient < 1)
		return Plugin_Stop;
	if(IsClientInGame(iClient) == false)
		return Plugin_Stop;
	if(IsFakeClient(iClient) == true)
		return Plugin_Stop;
	DisplayInstructorText(iClient, string, color, bind);
	return Plugin_Stop;
	//CreateTimer(0.3, DelayDisplayHint, h_Pack)
}

DisplayInstructorText(iClient, String:s_Message[256], String:color[], String:s_Bind[])
{
	if(iClient < 1)
		return;
	if(IsClientInGame(iClient) == false)
		return;
	if(IsFakeClient(iClient) == true)
		return;
	decl i_Ent, String:s_TargetName[32], Handle:h_RemovePack;
	i_Ent = CreateEntityByName("env_instructor_hint");
	FormatEx(s_TargetName, sizeof(s_TargetName), "hint%d", iClient);
	ReplaceString(s_Message, sizeof(s_Message), "\n", " ");
	DispatchKeyValue(iClient, "targetname", s_TargetName);
	DispatchKeyValue(i_Ent, "hint_target", s_TargetName);
	DispatchKeyValue(i_Ent, "hint_timeout", "5");
	DispatchKeyValue(i_Ent, "hint_range", "0.01");
	DispatchKeyValue(i_Ent, "hint_color", color);
	//DispatchKeyValue(i_Ent, "hint_icon_onscreen", "use_binding");
	DispatchKeyValue(i_Ent, "hint_caption", s_Message);
	//DispatchKeyValue(i_Ent, "hint_binding", s_Bind);
	DispatchSpawn(i_Ent);
	AcceptEntityInput(i_Ent, "ShowHint");
	
	h_RemovePack = CreateDataPack();
	WritePackCell(h_RemovePack, iClient);
	WritePackCell(h_RemovePack, i_Ent);
	CreateTimer(6.0, RemoveInstructorText, h_RemovePack);
}
	
Action:RemoveInstructorText(Handle:h_Timer, Handle:h_Pack)
{
	decl i_Ent, iClient;
	
	ResetPack(h_Pack, false);
	iClient = ReadPackCell(h_Pack);
	i_Ent = ReadPackCell(h_Pack);
	CloseHandle(h_Pack);
	
	if(iClient < 1)
		return Plugin_Stop;
	if(IsClientInGame(iClient) == false)
		return Plugin_Stop;
	if(IsFakeClient(iClient) == true)
		return Plugin_Stop;
	
	if (!iClient || !IsClientInGame(iClient))
		return Plugin_Stop;
	
	if (IsValidEntity(i_Ent))
			AcceptEntityInput(i_Ent);
	
	ClientCommand(iClient, "gameinstructor_enable 0");
		
	DispatchKeyValue(iClient, "targetname", "");
		
	return Plugin_Stop;
}

*/

/*********************
 *Partial Name Parser*
**********************/
 



/******
 *Rope*
*******/

/*
Action_Rope(iClient)
{
	if(iClient>0)
	{
		if(IsPlayerAlive(iClient) && !g_bUsingTongueRope[iClient])
		{
			new Float:clientloc[3],Float:clientang[3];
			GetClientEyePosition(iClient,clientloc); // Get the position of the player's eyes
			GetClientEyeAngles(iClient,clientang); // Get the angle the player is looking
			TR_TraceRayFilter(clientloc,clientang,MASK_ALL,RayType_Infinite,TraceRayTryToHit); // Create a ray that tells where the player is looking
			TR_GetEndPosition(gRopeEndloc[iClient]); // Get the end xyz coordinate of where a player is looking
			//EmitSoundFromOrigin("weapons/crossbow/hit1.wav",gRopeEndloc[iClient]); // Emit sound from the end of the rope
			gRopeDist[iClient] = GetVectorDistance(clientloc,gRopeEndloc[iClient], false);
			g_bUsingTongueRope[iClient]=true; // Tell plugin the player is roping
			SetMoveType(iClient, MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE);
			g_bUsedTongueRope[iClient] = true;
		}
	}
}


Action:Roping(Handle:timer,any:index)
{
	if(IsClientInGame(index)&& g_bUsingTongueRope[index] && IsPlayerAlive(index))
	{
		decl Float:clientloc[3],Float:velocity[3],Float:velocity2[3];
		GetClientAbsOrigin(index,clientloc);
		GetEntDataVector(index, g_iOffset_VecVelocity, velocity);//GetVelocity(index,velocity);
		PrintHintText(index, "z velocity = %f", velocity[2]);
		velocity2[0] = (gRopeEndloc[index][0] - clientloc[0]) * 3.0;
		velocity2[1] = (gRopeEndloc[index][1] - clientloc[1]) * 3.0;
		new Float:y_coord,Float:x_coord;
		y_coord = velocity2[0]*velocity2[0] + velocity2[1]*velocity2[1];
		//x_coord=(GetConVarFloat(cvarRopeSpeed)*20.0)/SquareRoot(y_coord);
		x_coord = (10.0) / (SquareRoot(y_coord));
		velocity[0] += velocity2[0] * x_coord;
		velocity[1] += velocity2[1] * x_coord;
		//if(gRopeEndloc[index][2]-clientloc[2]>=gRopeDist[index]&&velocity[2]<0.0)
		//	velocity[2]*=-1.0;
		velocity[2] = 80.0;
		TeleportEntity(index,NULL_VECTOR,NULL_VECTOR,velocity);
		if(ispushingspace[index]==true)
		{
			decl Float:upVelocity[3];
			GetEntDataVector(index, g_iOffset_VecVelocity, upVelocity);
			upVelocity[2]+=100;
			TeleportEntity(index,NULL_VECTOR,NULL_VECTOR,upVelocity);
		}
		// Make a beam from grabber to grabbed
		decl color[4];
		color[0] = 255;
		color[1] = 255;
		color[2] = 255;
		color[3] = 255;
		clientloc[2]+=100;
		//GetBeamColor(index,Rope,color);
		BeamEffect("@all",clientloc,gRopeEndloc[index],0.1,3.0,3.0,color,0.0,0);
	}
	else
	{
		return Plugin_Stop; // Stop the timer
		//Action_Detach(index);
	}
	return Plugin_Continue;
}

Action_Detach(iClient)
{
	g_bUsingTongueRope[iClient]=false; // Tell plugin the iClient is not using the rope
}


CreateWire(Part1, Part2)
{
	decl Float:Org1[3];
	decl Float:Org2[3];
	decl String:Origin1[128];
	decl String:Origin2[128];

	GetEntPropVector(Part1, Prop_Send, "m_vecOrigin", Org1);
	GetEntPropVector(Part2, Prop_Send, "m_vecOrigin", Org2);
	
	Format(Origin1, 128, "%f %f %f", Org1[0], Org1[1], Org1[2]);
	Format(Origin2, 128, "%f %f %f", Org2[0], Org2[1], Org2[2]);

	new Rope1 = CreateEntityByName("move_rope");
	new Rope2 = CreateEntityByName("keyframe_rope");

	decl String:Name1[64];
	decl String:Name2[64];
	decl String:PartName1[64];
	decl String:PartName2[64];

	Format(Name1, 64, "compwire_%d", Rope1);
	Format(Name2, 64, "compwire_%d", Rope2);
	Format(PartName1, 64, "comppart_%d", Part1);
	Format(PartName2, 64, "comppart_%d", Part2);

	DispatchKeyValue(Part1, "targetname", PartName1);
	DispatchKeyValue(Part2, "targetname", PartName2);

	DispatchKeyValue(Rope1, "MoveSpeed", "64");
	DispatchKeyValue(Rope1, "Slack", "25");
	DispatchKeyValue(Rope1, "Subdiv", "2");
	DispatchKeyValue(Rope1, "Width", "3");
	DispatchKeyValue(Rope1, "TextureScale", "3");
	DispatchKeyValue(Rope1, "RopeMaterial", "materials/particle/smoker_tongue_beam.vmt");
	DispatchKeyValue(Rope1, "PositionInterpolator", "2");
	DispatchKeyValue(Rope1, "targetname", Name1);
	DispatchKeyValue(Rope1, "NextKey", Name2);
	//DispatchKeyValue(Rope1, "origin", Origin1);
	
	DispatchKeyValue(Rope2, "MoveSpeed", "64");
	DispatchKeyValue(Rope2, "Slack", "25");
	DispatchKeyValue(Rope2, "Subdiv", "2");
	DispatchKeyValue(Rope2, "Width", "3");
	DispatchKeyValue(Rope2, "TextureScale", "3");
	DispatchKeyValue(Rope2, "RopeMaterial", "materials/particle/smoker_tongue_beam.vmt");
	DispatchKeyValue(Rope2, "PositionInterpolator", "2");
	DispatchKeyValue(Rope2, "targetname", Name2);
	//DispatchKeyValue(Rope1, "NextKey", Name2);
	//DispatchKeyValue(Rope2, "origin", Origin2);

	DispatchSpawn(Rope1);
	DispatchSpawn(Rope2);

	TeleportEntity(Rope1, Org1, NULL_VECTOR, NULL_VECTOR);
	TeleportEntity(Rope2, Org2, NULL_VECTOR, NULL_VECTOR);
	
	//SetVariantString(PartName1);
	//AcceptEntityInput(Rope1, "SetParent");

	//SetVariantString(PartName2);
	//AcceptEntityInput(Rope2, "SetParent");

	//WireEntity[1][Part1][Part2] = Rope1;
	//WireEntity[2][Part1][Part2] = Rope2;
	//WireEntity[1][Part2][Part1] = Rope2;
	//WireEntity[2][Part2][Part1] = Rope1;

	return;
}
*/

/*
stock CheatCommand(iClient, String:command[], String:arguments[]="")
{
	new userflags = GetUserFlagBits(iClient);
	SetUserFlagBits(iClient, ADMFLAG_ROOT);
	new flags = GetCommandFlags(command);
	SetCommandFlags(command, flags & ~FCVAR_CHEAT);
	FakeClientCommand(iClient, "%s %s", command, arguments);
	SetCommandFlags(command, flags);
	SetUserFlagBits(iClient, userflags);
}


PrintTeamsToClient(iClient)
{
	new Handle:TeamPanel = CreatePanel();
	SetPanelTitle(TeamPanel, " ");
	//DrawPanelText(TeamPanel, " a");
	DrawPanelItem(TeamPanel, "");
	DrawPanelItem(TeamPanel, "");
	DrawPanelItem(TeamPanel, "");
	DrawPanelItem(TeamPanel, "");
	DrawPanelItem(TeamPanel, "");
	DrawPanelItem(TeamPanel, "");
	DrawPanelItem(TeamPanel, "");
	SendPanelToClient(TeamPanel, iClient, TeamPanelHandler, 40);
}

Action:CreateOverlay(iClient) 
{ 
     new ent = CreateEntityByName("env_screenoverlay"); 
     DispatchKeyValue(ent, "OverlayName1", "dev/dev_prisontvoverlay002.vmt"); 
     AcceptEntityInput(ent, "StartOverlays", iClient); 
     //AcceptEntityInput(ent); 
} 
*/

// Action:TestingShit(iClient)
// {	
// 	PrintToChatAll("TestingShit");
	
// 	//new Handle:hEventTest = CreateEvent("tank_spawn");
// 	/*
// 	new Handle:hEventTest = HookEvent("tank_spawn");
// 	SetEventInt(hEventTest, "userid", iClient);
// 	SetEventInt(hEventTest, "tankid", 8);
// 	FireEvent(hEventTest);
// 	*/
	
// 	/*decl String:number[32];
// 	GetCmdArg(1, number, sizeof(number));
// 	new num = 1064;
// 	num = StringToInt(number);
// 	SetEntProp(iClient, Prop_Send, "m_iGlowType", 2);
// 	SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
// 	SetEntProp(iClient, Prop_Send, "m_glowColorOverride", num);*/
// 	//decl String:number1[32];
// 	//decl String:number2[32];
// 	//decl String:number3[32];
// 	//GetCmdArg(1, number1, sizeof(number1));
// 	//GetCmdArg(2, number2, sizeof(number2));
// 	//GetCmdArg(3, number3, sizeof(number3));
// 	//g_iOffset_NextActivation = StringToInt(number1);
// 	//new WeaponIndex;
// 	/*
// 	while ((WeaponIndex = GetPlayerWeaponSlot(iClient, 0)) != -1)
// 	{
// 		RemovePlayerItem(iClient, WeaponIndex);
// 		AcceptEntityInput(WeaponIndex);
// 	}
// 	SDKCall(g_hSetClass, iClient, StringToInt(number1));
// 	AcceptEntityInput(MakeCompatEntRef(GetEntProp(iClient, Prop_Send, "m_customAbility")), "Kill");
// 	SetEntProp(iClient, Prop_Send, "m_customAbility", GetEntData(SDKCall(g_hCreateAbility, iClient), g_iAbility));
// 	*/
// 	//PrintToChatAll("m_zombieClass = %s", GetEntProp(Client, Prop_Send, "m_zombieClass");
// 	//new num = StringToInt(number);
// 	//PrintToChatAll("Number equals %f", StringToFloat(number));
// 	//new Float:xyzNewVelocity[3];
// 	//xyzNewVelocity[0] = StringToFloat(number1);
// 	//xyzNewVelocity[1] = StringToFloat(number2);
// 	//xyzNewVelocity[2] = StringToFloat(number3);
// 	//TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, xyzNewVelocity);
// 	//GetClientWeapon(iClient, strCurrentWeapon, sizeof(strCurrentWeapon));
// 	//PrintToChatAll("Current Weapon is %s", strCurrentWeapon);
// 	//g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 1);
// 	//PrintToChatAll("g_iSecondarySlotID Before = %d", g_iPrimarySlotID[iClient]);
	
// 	// g_iPrimarySlotID[iClient] = GetPlayerWeaponSlot(iClient, 0);
// 	// PrintToChatAll("g_iPrimarySlotID Before = %d", g_iPrimarySlotID[iClient]);
// 	// AcceptEntityInput(g_iPrimarySlotID[iClient]);
// 	// PrintToChatAll("g_iPrimarySlotID After = %d", g_iPrimarySlotID[iClient]);
	
// 	//fnc_DeterminePrimarySlot(iClient);
// 	//StoreCurrentPrimaryWeapon(iClient);
// 	//SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd & ~FCVAR_CHEAT);
// 	//RunCheatCommand(iClient, "upgrade_add", "upgrade_add EXPLOSIVE_AMMO");
// 	//SetCommandFlags("upgrade_add", g_iFlag_UpgradeAdd);
	
// 	// new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
// 	// new SpecialAmmo = GetEntProp(ActiveWeaponID,Prop_Send,"m_nUpgradedPrimaryAmmoLoaded");
// 	// SetEntProp(ActiveWeaponID,Prop_Send,"m_nUpgradedPrimaryAmmoLoaded",200);
// 	// PrintToChatAll("Special Ammo = %d", SpecialAmmo);
	
// 	/*
// 	StoreCurrentPrimaryWeapon(iClient);
// 	StoreCurrentPrimaryWeaponAmmo(iClient);
// 	CyclePlayerWeapon(iClient);
// 	fnc_SetAmmo(iClient);
// 	*/
// 	/*
// 	decl String:clientname[128];
// 	GetClientName(iClient, clientname, sizeof(clientname));
// 	*/
// 	//decl String:ModelName[256];
// 	//new WepSlot = GetPlayerWeaponSlot(iClient, 1);
// 	//new ClientModel = GetClientModel(WepSlot, ModelName, sizeof(ModelName));
// 	//PrintToChatAll("ClientModel = %s", ClientModel);
// 	//decl String:currentweapon[32];
// 	//GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
// 	//decl Float:wepvorigin[3], Float:vangles[3], Float:vdir[3];
// 	//GetClientEyeAngles(iClient, vangles);
// //	GetAngleVectors(vangles, vdir, NULL_VECTOR, NULL_VECTOR);
// 	//vangles[0] = 0.0;		//Lock x and z axis
// 	//vangles[2] = 0.0;
// 	//GetClientAbsOrigin(iClient, wepvorigin);
// 	//wepvorigin[0]+=(vdir[0] * 30.0);		
// 	//wepvorigin[1]+=(vdir[1] * 30.0);
// 	//wepvorigin[2]+=(vdir[2] + 30.0);
// 	//wep2vorigin[0]+=(vdir[0] * 45.0);		
// 	//wep2vorigin[1]+=(vdir[1] * 45.0);
// 	//wep2vorigin[2]+=(vdir[2] + 30.0);
// 	//wepvorigin[0]+=(vdir[0] * 15.0);		
// 	//wepvorigin[1]+=(vdir[1] * 15.0);
// 	//wepvorigin[2]+=(vdir[2] + 30.0);
// 	//new weapon = CreateEntityByName("weapon_melee");
// 	//new weapon = CreateEntityByName("weapon_katana");
// 	//new weapon = CreateEntityByName("weapon_autoshotgun");
// 	//DispatchKeyValue(weapon, "ammo", "200");
// 	//DispatchSpawn(weapon);
// 	//DispatchSpawn(weapon2);
// 	//DispatchSpawn(weapon);
// 	//TeleportEntity(weapon, wepvorigin, vangles, NULL_VECTOR);
// 	//TeleportEntity(weapon2, wep2vorigin, vangles, NULL_VECTOR);
// 	//TeleportEntity(weapon, wepvorigin, vangles, NULL_VECTOR);
// 	//new iEntid2 = GetEntDataEnt2(iClient,g_iOffset_ActiveWeapon);
// 	//new ActiveWeaponID = GetEntDataEnt2(iClient, g_iOffset_ActiveWeapon);
// 	//SetEntData(ActiveWeaponID, g_iOffset_Clip1, 90, true);
// 	//new m_reloadState = GetEntProp(ActiveWeaponID,Prop_Data,"m_reloadState");
// 	//new m_reloadNumShells = GetEntProp(ActiveWeaponID,Prop_Data,"m_reloadNumShells");
// 	//new m_reloadStartTime = GetEntProp(ActiveWeaponID,Prop_Data,"m_reloadStartTime");
// 	//new m_reloadStartDuration = GetEntProp(ActiveWeaponID,Prop_Data,"m_reloadStartDuration");
// 	//new m_reloadInsertDuration = GetEntProp(ActiveWeaponID,Prop_Data,"m_reloadInsertDuration");
// 	//new m_reloadEndDuration = GetEntProp(ActiveWeaponID,Prop_Data,"m_reloadEndDuration");
// 	//new m_shellsInserted = GetEntProp(ActiveWeaponID,Prop_Data,"m_shellsInserted");
// 	//PrintToChatAll("m_reloadState %d", m_reloadState);
// 	//PrintToChatAll("m_reloadNumShells %d", m_reloadNumShells);
// 	//PrintToChatAll("m_reloadStartTime %f", m_reloadStartTime);
// 	//PrintToChatAll("m_reloadStartDuration %f", m_reloadStartDuration);
// 	//PrintToChatAll("m_reloadInsertDuration %f", m_reloadInsertDuration);
// 	//PrintToChatAll("m_reloadEndDuration %f", m_reloadEndDuration);
// 	//PrintToChatAll("m_shellsInserted %d", m_shellsInserted);
// 	//new clip1 = GetEntProp(ActiveWeaponID,Prop_Data,"m_iClip1");
// 	//new clip3 = GetEntProp(ActiveWeaponID,Prop_Send,"m_iClip2");
// 	//new PrimaryAmmoType = GetEntProp(ActiveWeaponID,Prop_Data,"m_iPrimaryAmmoType");
// 	//new SecondaryAmmoType = GetEntProp(ActiveWeaponID,Prop_Data,"m_iSecondaryAmmoType");
// 	//new UpgradedAmmoType = GetEntProp(ActiveWeaponID,Prop_Send,"m_nUpgradedPrimaryAmmoLoaded");
// 	//m_nUpgradedPrimaryAmmoLoaded
// 	//new iOffset_Ammo = FindDataMapInfo(iClient,"m_iAmmo");
// 	//new ReserveAmmo = GetEntProp(ActiveWeaponID,Prop_Data,"m_iAmmo");
// 	//PrintToChatAll("m_iClip3 %d", clip3);
// 	//PrintToChatAll("g_iOffset_ReloadState %d", g_iOffset_ReloadState);
// 	//PrintToChatAll("g_iOffset_ReloadStartDuration %f", g_iOffset_ReloadStartDuration);
// 	//PrintToChatAll("g_iOffset_ReloadInsertDuration %f", g_iOffset_ReloadInsertDuration);
// 	//PrintToChatAll("g_iOffset_ReloadEndDuration %f", g_iOffset_ReloadEndDuration);
// 	//PrintToChatAll("g_iOffset_ReloadState %d", g_iOffset_ReloadState);
// 	//PrintToChatAll("g_iOffset_ReloadStartTime %f", g_iOffset_ReloadStartTime);
// 	//PrintToChatAll("g_bOffset_InReload %d", g_bOffset_InReload);
// 	//PrintToChatAll("g_iOffset_ShellsInserted %d", g_iOffset_ShellsInserted);
// 	//g_iOffset_ReloadState
// 	//g_iOffset_ReloadNumShells
	
// 	//new weaponcheck = GetEntPropString(GetPlayerWeaponSlot(iClient, 1), Prop_Data, "m_strMapSetScriptName", currentweapon, sizeof(currentweapon));
// 	//PrintToChatAll("Test %s", weaponcheck);
	
	
// 	// decl String:szWeapon[64]; 
// 	// GetEventString(event, "weapon", szWeapon, sizeof(szWeapon)); 
// 	// if (strncmp(szWeapon, "melee", 5) == 0) 
// 	// { 
// 	// 	new iWeapon = GetEntDataEnt2(attacker, g_iActiveWeaponOffset); 
// 	// 	if (IsValidEdict(iWeapon)) 
// 	// 	{ 
// 	// 		GetEdictClassname(iWeapon, szWeapon, sizeof(szWeapon)); 
// 	// 		if (strncmp(szWeapon[7], "melee", 5) == 0) 
// 	// 		{ 
// 	// 			GetEntPropString(iWeapon, Prop_Data, "m_strMapSetScriptName", szWeapon, sizeof(szWeapon)); 
// 	// 			SetEventString(event, "weapon", szWeapon);
// 	// 			new check = SetEventString(event, "weapon", szWeapon);
// 	// 			PrintToChatAll("Test 2 %d", check);				
// 	// 		} 
// 	// 	} 
// 	// }  
	
	
	
// 	// new m_reloadNumShells = FindDataMapInfo(iClient,"m_reloadNumShells");
// 	// PrintToChatAll("iClient m_reloadNumShells %d", m_reloadNumShells);
// 	// new m_shellsInserted = FindDataMapInfo(iClient,"m_shellsInserted");
// 	// PrintToChatAll("iClient m_shellsInserted %d", m_shellsInserted);
// 	// new m_reloadNumShells2 = FindDataMapInfo(ActiveWeaponID,"m_reloadNumShells");
// 	// PrintToChatAll("ActiveWeaponID m_reloadNumShells %d", m_reloadNumShells2);
// 	// new m_shellsInserted2 = FindDataMapInfo(ActiveWeaponID,"m_shellsInserted");
// 	// PrintToChatAll("ActiveWeaponID m_shellsInserted %d", m_shellsInserted2);
// 	// new m_reloadNumShells3 = GetEntProp(ActiveWeaponID,Prop_Data,"m_reloadNumShells");
// 	// PrintToChatAll("Prop_Data ActiveWeaponID m_shellsInserted %d", m_reloadNumShells3);
// 	// new m_shellsInserted3 = GetEntProp(iClient,Prop_Data,"m_shellsInserted");
// 	// PrintToChatAll("Prop_Data iClient m_shellsInserted %d", m_shellsInserted3);
	
// 	//new m_reloadNumShells3 = FindDataMapInfo(currentweapon,"m_reloadNumShells");
// 	//PrintToChatAll("currentweapon m_reloadNumShells %d", m_reloadNumShells3);
// 	//new m_shellsInserted3 = FindDataMapInfo(currentweapon,"m_shellsInserted");
// 	//PrintToChatAll("currentweapon m_shellsInserted %d", m_shellsInserted3);
// 	//PrintToChatAll("m_iClip1 %d", clip1);
// 	//PrintToChatAll("m_iClip2 %d", clip2);
// 	//PrintToChatAll("m_iAmmo %d", iOffset_Ammo);
// 	//PrintToChatAll("ReserveAmmo %d", ReserveAmmo);
// 	//PrintToChatAll("m_iPrimaryAmmoType %d", PrimaryAmmoType);
// 	//PrintToChatAll("m_iSecondaryAmmoType %d", SecondaryAmmoType);
// 	//PrintToChatAll("UpgradedAmmoType %d", UpgradedAmmoType);
	
// 	// PrintToChatAll("Current Grenade Slot %d", g_iCoachCurrentGrenadeSlot[iClient]);
// 	// PrintToChatAll("Grenade Slot 1 %s", g_strCoachGrenadeSlot1[iClient]);
// 	// PrintToChatAll("Grenade Slot 2 %s", g_strCoachGrenadeSlot2[iClient]);
// 	// PrintToChatAll("Grenade Slot 3 %s", g_strCoachGrenadeSlot3[iClient]);
	
	
// 	// decl String:currentweapon[32];
// 	// GetClientWeapon(iClient, currentweapon, sizeof(currentweapon));
// 	// PrintToChatAll("Current Weapon: %s", currentweapon);
	
// 	// decl String:number[32];
// 	// GetCmdArg(1, number, sizeof(number));
// 	// new num = 1064;
// 	// num = StringToInt(number);
// 	// SetEntProp(iClient, Prop_Send, "m_iGlowType", 2);
// 	// SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
// 	// SetEntProp(iClient, Prop_Send, "m_glowColorOverride", num);*/
// 	// /*new flags = GetConVarFlags(FindConVar("sv_cheats"));
// 	// SetConVarFlags(FindConVar("sv_cheats"), flags^(FCVAR_NOTIFY|FCVAR_REPLICATED|FCVAR_SPONLY));
// 	// SetConVarBool(FindConVar("sv_cheats"), true);
// 	// SendConVarValue(iClient, FindConVar("sv_cheats"), "1");
// 	// ClientCommand(iClient, "r_screenoverlay dev/dev_prisontvoverlay004.vmt");
// 	// FakeClientCommand(iClient, "boom");
// 	// //SendConVarValue(iClient, FindConVar("sv_cheats"), "0");
// 	// //SetConVarBool(FindConVar("sv_cheats"), false);
// 	// //SetConVarFlags(FindConVar("sv_cheats"), flags);

	
// 	//SetMakeAccountMotdIndex();
// 	//MessageText(iClient, r, g, b, String:message[])
// 	//{
// 	/*new Handle:TextHandle = StartMessageOne("MessageText", iClient);
// 	BfWriteByte(TextHandle, 255);        // R
// 	BfWriteByte(TextHandle, 255);        // G
// 	BfWriteByte(TextHandle, 255);        // B
// 	BfWriteString(TextHandle, "text here omg it worked");
// 	EndMessage();*/
	
// 	//}  
// 	/*//Check Client id name
// 	decl String:clientname[128];
// 	GetClientName(iClient, clientname, sizeof(clientname));
// 	PrintToChat(iClient, "%s", clientname);
// 	for(new l=0; l<25; l++)
// 	{
// 		PrintToChat(iClient, "%c, %d", clientidname[iClient][l], clientidname[iClient][l]);
// 	}
// 	new l = 0;
// 	while(clientname[l]!='\0' || clientidname[iClient][l]!='\0')
// 	{
// 		PrintToChat(iClient, "checking %c, %d = %c, %d", clientidname[iClient][l], clientidname[iClient][l], clientname[l], clientname[l]);
// 		if(clientidname[iClient][l] != clientname[l])
// 		{
// 			PrintToChat(iClient, "Does not match");
// 		}
// 		l++;
// 	}*/
	
// 	/*if(args==1)
// 	{
// 		decl String:targetname[128], String:clientname[128];
// 		GetClientName(iClient, clientname, sizeof(clientname));
// 		GetCmdArg(1, targetname, sizeof(targetname));
// 		PrintToChat(iClient, "%s, %s", targetname, clientname);
// 		for(new l=0; l<25; l++)
// 		{
// 			//clientidname[iClient][l] = targetname[l];
// 			if(clientidname[l]!=-1)
// 				PrintToChat(iClient, "%c, %d", clientidname[iClient][l], clientidname[iClient][l]);
// 		}
// 	}*/
// 	//FakeClientCommandEx(iClient, "explode");
// 	if(testtoggle[iClient] == false)
// 	{
// 		//SetConVarInt(FindConVar("z_no_cull"), 1);
// 		//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 0.3, true);
		
// 		//new flags = GetConVarFlags(FindConVar("sv_cheats"));
// 		//SetConVarFlags(FindConVar("sv_cheats"), flags^(FCVAR_NOTIFY|FCVAR_REPLICATED|FCVAR_SPONLY));
// 		//SetConVarBool(FindConVar("sv_cheats"), true);
// 		//SendConVarValue(iClient, FindConVar("sv_cheats"), "1");
		
// 		//FakeClientCommand(iClient, "boom");
// 		//resetCheats[iClient] = 0;
		
// 		/*//blockEntity[iClient] = true;
// 		new ent = CreateEntityByName("env_screenoverlay");
// 		DispatchKeyValue(ent, "OverlayName1", "dev/dev_prisontvoverlay002.vmt"); 
// 		AcceptEntityInput(ent, "StartOverlays", iClient);*/
		
// 		//blockEntity[iClient][ent] = false;
// 		//RemovePlayerItem(iClient, GetPlayerWeaponSlot(iClient, 0));
		
// 		/* SPWANGING BARRIR
// 		decl Float:vorigin[3], Float:vangles[3], Float:vdir[3];
// 		decl Float:voriginSet[3], Float:vanglesSet[3];
// 		GetClientEyeAngles(iClient, vangles);	//Get clients Eye Angles to know get what direction to spawn gun
// 		GetAngleVectors(vangles, vdir, NULL_VECTOR, NULL_VECTOR);	//Get the direction the iClient is looking
// 		vanglesSet[0] = 0.0;		//Lock x and z axis
// 		vanglesSet[2] = 0.0;
// 		vanglesSet[1] = vangles[1] + 180.0;		//Set Y for the rotation
		
// 		GetClientAbsOrigin(iClient, vorigin);	//Get clients location origin vectors
// 		voriginSet[0] = vorigin[0] + (vdir[0] * 50.0);		//Place the minigun infront of the players view
// 		voriginSet[1] = vorigin[1] + (vdir[1] * 50.0);
// 		voriginSet[2] = vorigin[2] + (vdir[2] * 1.5);
		
// 		PrecacheModel("models/props_fortifications/sandbags_line2.mdl");
		
// 		sandbag1[iClient] = CreateEntityByName("prop_dynamic");		//Front Sand Bag
// 		DispatchKeyValue(sandbag1[iClient], "solid",   "6");
// 		SetEntityModel(sandbag1[iClient], "models/props_fortifications/sandbags_line2.mdl");
// 		DispatchSpawn(sandbag1[iClient]);
// 		TeleportEntity(sandbag1[iClient], voriginSet, vanglesSet, NULL_VECTOR);
		
// 		vanglesSet[1] = vangles[1] + 60.0;
// 		voriginSet[0] = vorigin[0] - (vdir[0] * 50.0);	
// 		voriginSet[1] = vorigin[1] + (vdir[1] * 50.0);
		
// 		sandbag2[iClient] = CreateEntityByName("prop_dynamic");
// 		DispatchKeyValue(sandbag2[iClient], "solid",   "6");
// 		SetEntityModel(sandbag2[iClient], "models/props_fortifications/sandbags_line2.mdl");
// 		DispatchSpawn(sandbag2[iClient]);
// 		TeleportEntity(sandbag2[iClient], voriginSet, vanglesSet, NULL_VECTOR);*/
		
// 		/*sandbag3[iClient] = CreateEntityByName("prop_dynamic");
// 		DispatchKeyValue(sandbag3[iClient], "solid",   "6");
// 		SetEntityModel(sandbag3[iClient], "models/props_fortifications/sandbags_line2.mdl");
// 		DispatchSpawn(sandbag3[iClient]);
// 		TeleportEntity(sandbag3[iClient], voriginSet, vanglesSet, NULL_VECTOR);
// 		*/
		
// 		//sandbags_corner2.mdl
// 		//sandbags_corner3.mdl
// 		//sandbags_line2.mdl
		
// 		PrintHintText(iClient, "Testing toggled on");
		
// 		testtoggle[iClient] = true;
// 	}
// 	else
// 	{	
// 		//SetConVarInt(FindConVar("z_no_cull"), 0);
// 		//SetEntDataFloat(iClient , FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue"), 1.0, true);
// 		/*new ent = CreateEntityByName("env_screenoverlay"); 
// 		DispatchKeyValue(ent, "OverlayName1", "dev/dev_prisontvoverlay001.vmt"); 
// 		AcceptEntityInput(ent, "StartOverlays", iClient); 
// 		*/
		
// 		// SPANWNIGN BARRIR
// 		/*if(sandbag1[iClient] > 0)
// 			if(IsValidEntity(sandbag1[iClient]))
// 				AcceptEntityInput(sandbag1[iClient]);
// 		sandbag1[iClient] = -1;
// 		if(sandbag2[iClient] > 0)
// 			if(IsValidEntity(sandbag2[iClient]))
// 				AcceptEntityInput(sandbag2[iClient]);
// 		sandbag2[iClient] = -1;
// 		if(sandbag3[iClient] > 0)
// 			if(IsValidEntity(sandbag3[iClient]))
// 				AcceptEntityInput(sandbag3[iClient]);
// 		sandbag3[iClient] = -1;
// 		*/
// 		PrintHintText(iClient, "Testing toggled off");
// 		testtoggle[iClient] = false;
// 	}
	
// 	//Stuff to remember
// 	//SetConVarInt(FindConVar("z_non_head_damage_factor_normal"), 200);
// 	//SetConVarFloat(FindConVar("first_aid_heal_percent"), 0.24);
// 	return;
// }

// Action:Timer_ShowPlayerStats(Handle:timer, any:iClient)
// {
// 	decl String:cstr[2];
// 	IntToString(iClient, cstr, sizeof(cstr));
// 	//ShowLongMOTD(iClient, "Player Statistics", cstr);
// 	OpenMOTDPanel(iClient, "Player Statistics", cstr, MOTDPANEL_TYPE_INDEX);
// 	return Plugin_Continue;
// }


// Action:NewRemoveInstructorHint(Handle:h_Timer, Handle:h_Pack)
// {
// 	new i_Ent, iClient;

// 	ResetPack(h_Pack, false);
// 	iClient = ReadPackCell(h_Pack);
// 	i_Ent = ReadPackCell(h_Pack);
// 	CloseHandle(h_Pack);

// 	if (!iClient || !IsClientInGame(iClient))
// 		return Plugin_Handled;

// 	if (IsValidEntity(i_Ent))
// 		AcceptEntityInput(i_Ent);

// 	return Plugin_Continue;
// }

// Action:Timer_UpdateParticle(Handle:timer, any:iClient)
// {
// 	decl Float:pos[3];
// 	decl Float:angles[3];
// 	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", pos);
// 	GetClientEyeAngles(iClient, angles);
// 	pos[2] += 10.0;
// 	angles[2] -= 90.0;
// 	TeleportEntity(testingparticle, pos, angles, NULL_VECTOR);
	
// 	//if(IsValidEntity(testingparticle) == true)
// 	CreateTimer(0.1, Timer_UpdateParticle, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
// 	return Plugin_Stop;
// }

// Action:Testing(iClient)
// {
// 	PrintToChatAll("m_zombieClass = %i", GetEntProp(iClient, Prop_Send, "m_zombieClass"));

// 	new newClass = GetRandomInt(1, 6);

// 	PrintToChatAll("Attempting to change spawn to %i", newClass);
// 	SDKCall(g_hSetClass, iClient, newClass);
// 	int cAbility = GetEntPropEnt(iClient, Prop_Send, "m_customAbility");
// 	if (cAbility > 0) AcceptEntityInput(cAbility, "Kill");
// 	SetEntProp(iClient, Prop_Send, "m_customAbility", GetEntData(SDKCall(g_hCreateAbility, iClient), g_iAbility));
// 	PrintToChatAll("Should be spawned as a %i", newClass);
	
// 	// new iEntid = GetEntDataEnt2(iClient,g_iOffset_CustomAbility);
// 	// PrintToChatAll("iEntid %d", iEntid);
// 	// decl offset;
// 	// //decl Float:flReturn;
// 	// for(offset = 1000;offset <= 2000;offset++)
// 	// {
// 	// 	PrintToChatAll("Started for loop");
// 	// 	PrintToChatAll("Offset = %i", offset);
// 	// 	PrintToChatAll("Offset Value = %f", GetEntDataFloat(iEntid, offset));
// 	// 	/*
// 	// 	if(flReturn > -1.0)
// 	// 	{
// 	// 		PrintToChatAll("Offset %i = %f", offset, flReturn);
// 	// 	}
// 	// 	*/
// 	// }
	
	
// 	//TopMenuDraw(iClient);
	
// 	/*decl String:arg[1024];
// 	GetCmdArg(1, arg, sizeof(arg));
// 	new Float:distance = StringToFloat(arg);
	
// 	new Float:xyzNewVelocity[3] = {0.0, 0.0, 0.0};
	
// 	xyzNewVelocity[2] = distance;
				
// 	TeleportEntity(iClient, NULL_VECTOR, NULL_VECTOR, xyzNewVelocity);
// 	*/
	
// 	//decl String:arg[1024];
// 	//GetCmdArg(1, arg, sizeof(arg));
// 	//new Float:radius = StringToFloat(arg);
// 	//GetCmdArg(2, arg, sizeof(arg));
// 	//new Float:width = StringToFloat(arg);
	
// 	//For testing particles
// 	//decl String:arg1[1024];
// 	//GetCmdArg(1, arg1, sizeof(arg1));
// 	//testingparticle = WriteParticle(iClient, arg1, 0.0, 10.0);
// 	//CreateParticle(arg1, 10.0, iClient, ATTACH_MOUTH, true);
	
// 	//WriteParticle(iClient, "powerup_frame", 0.0, 6.0);
	
// 	/*decl String:arg1[1024];
// 	GetCmdArg(1, arg1, sizeof(arg1));
// 	WriteParticle(iClient, arg1, 0.0, 6.0);
// 	new i;
// 	for(i = 1;i <= MaxClients; i++)
// 	{
// 		if(IsClientInGame(i) == true && IsPlayerAlive(i))
// 			WriteParticle(i, arg1, 0.0, 6.0);
// 	}*/
	
	
	
// 	//CreateTimer(3.0, Timer_UpdateParticle, iClient, TIMER_FLAG_NO_MAPCHANGE);
	
	
// 	/*PrecacheParticle("particle_test");
// 	WriteParticle(iClient, "particle_test", 0.0, 15.0);
	
// 	PrecacheParticle("particle_test_locked");
// 	CreateParticle("particle_test_locked", 15.0, iClient, ATTACH_EYES);  //, bool:useangles = false, Float:xOffs=0.0, Float:yOffs=0.0, Float:zOffs=0.0)
// 	*/
	
// 	/*decl i_Ent, String:s_TargetName[32], Handle:h_Pack;
// 	decl String:buffer[100];

// 	//if( g_bTranslation )
// 	//	Format(buffer, sizeof(buffer), "%T", "Crawl", iClient);
// 	//else
// 	Format(buffer, sizeof(buffer), "testing the new Instructor Hint text!");
// 	ReplaceString(buffer, sizeof(buffer), "\n", " ");

// 	i_Ent = CreateEntityByName("env_instructor_hint");
// 	FormatEx(s_TargetName, sizeof(s_TargetName), "hint%d", iClient);
// 	DispatchKeyValue(iClient, "targetname", s_TargetName);
// 	DispatchKeyValue(i_Ent, "hint_target", s_TargetName);
// 	DispatchKeyValue(i_Ent, "hint_timeout", "5");
// 	DispatchKeyValue(i_Ent, "hint_range", "0.01");
// 	DispatchKeyValue(i_Ent, "hint_icon_onscreen", "icon_tip");
// 	DispatchKeyValue(i_Ent, "hint_caption", buffer);
// 	DispatchKeyValue(i_Ent, "hint_color", "255 255 255");
// 	DispatchSpawn(i_Ent);
// 	AcceptEntityInput(i_Ent, "ShowHint");
// 	h_Pack = CreateDataPack();
// 	WritePackCell(h_Pack, iClient);
// 	WritePackCell(h_Pack, i_Ent);
// 	CreateTimer(5.0, NewRemoveInstructorHint, h_Pack);
	
// 	PrintToChatAll("NextAttack = %d", g_iOffset_NextActivation);
// 	*/
	
// 	/*decl String:number[32];
// 	GetCmdArg(1, number, sizeof(number));
// 	new num = 3;
// 	num = StringToInt(number);
// 	for(new i = 1; i <= num; i++)
// 	{
// 		new Handle:h = CreateDataPack();
// 		WritePackCell(h, iClient);
// 	}*/
	
	
// 	//blockEntity[iClient] = true;
// 	//WriteParticle(iClient, "ellis_ulti_charge3", 3.0, 3.0);
// 	//WriteParticle(iClient, "smoker_spore_trail_spores", 3.0, 3.0);
	
// 	//WriteParticle(iClient, "smoker_smokecloud", 3.0, 3.0);
// 	//PrecacheParticle("ellis_ulti_charge3");
	
// 	/*TE_Start("BeamLaser");
// 	TE_WriteNum("m_nModelIndex", g_iSprite_SmokerTongue);
// 	TE_WriteNum("m_nHaloIndex", 0);
// 	TE_WriteNum("m_nStartFrame",3);
// 	TE_WriteNum("m_nFrameRate", 60);
// 	TE_WriteFloat("m_fLife", 90.0);
// 	TE_WriteFloat("m_fWidth", 10.00);
// 	TE_WriteFloat("m_fEndWidth", 10.0);
// 	TE_WriteNum("m_nFadeLength", 9);
// 	TE_WriteFloat("m_fAmplitude", 1.0);
// 	TE_WriteNum("m_nSpeed", 1);
// 	TE_WriteNum("r", 255);
// 	TE_WriteNum("g", 255);
// 	TE_WriteNum("b", 255);
// 	TE_WriteNum("a", 255);
// 	TE_WriteNum("m_nStartEntity", 3);
// 	TE_WriteNum("m_nEndEntity", 4);*/
// 	//TE_WriteEncodedEnt("m_nStartEntity", iClient);
// 	//TE_WriteEncodedEnt("m_nEndEntity", 4);
	
	
// 	//CreateWire(iClient, 3);
	
// 	/*new flags; 
// 	flags  = GetCommandFlags("r_screenoverlay"); 
// 	flags &= ~FCVAR_CHEAT; 
// 	flags &= ~FCVAR_SPONLY; 
// 	SetCommandFlags("r_screenoverlay", flags); 
// 	ClientCommand(iClient, "r_screenoverlay dev/dev_prisontvoverlay004.vmt");*/
	
// 	/*new flags  = GetCommandFlags("r_screenoverlay"); 
// 	flags &= ~FCVAR_CHEAT; 
// 	flags &= ~FCVAR_REPLICATED; 
// 	flags &= ~FCVAR_SPONLY; 
// 	SetCommandFlags("r_screenoverlay", flags^(FCVAR_NOTIFY|FCVAR_REPLICATED|FCVAR_SPONLY)); 
// 	ClientCommand(iClient, "r_screenoverlay dev/dev_prisontvoverlay004.vmt");*/
	 
// 	/*flags = GetCommandFlags("r_screenoverlay");
// 	SetCommandFlags("r_screenoverlay", flags^(~FCVAR_CHEAT));
// 	//SetCommandFlags("r_screenoverlay", (GetCommandFlags("r_screenoverlay") - FCVAR_CHEAT));
// 	ClientCommand(iClient, "r_screenoverlay dev/dev_prisontvoverlay004.vmt");
// 	*/
	
// 	//SetCommandFlags("r_screenoverlay", (GetCommandFlags("r_screenoverlay") - FCVAR_CHEAT + FCVAR_NOTIFY + FCVAR_REPLICATED - FCVAR_SPONLY));
// 	//SetCommandFlags("r_screenoverlay", (GetCommandFlags("r_screenoverlay") - ~FCVAR_CHEAT + FCVAR_REPLICATED));
	
// 	//ClientCommand(iClient, "r_screenoverlay dev/dev_prisontvoverlay004.vmt");
	
// 	//SetCommandFlags("r_screenoverlay", flags);
	
// 	/*decl String:arg1[1024];
// 	GetCmdArg(1, arg1, sizeof(arg1));
// 	PrintToChatAll("opening %s", arg1);
// 	OpenMOTDPanel(iClient, "Website", arg1, MOTDPANEL_TYPE_URL);
// 	*/
	
// 	/*decl String:text[2048];
// 	decl String:cat[2048];
// 	//FormatEx(text, sizeof(text), "<html><body bgcolor=\"#000000\" text=\"#00FF00\"><h1>%N's Stat, %s</h1></body></html>", iClient, arg1);
// 	FormatEx(text, sizeof(text), "<html><body bgcolor=\"#000000\" text=\"#00FF00\"><h1>%N's Statistics %s</h1>", iClient, arg1);
	
// 	FormatEx(cat, sizeof(cat), "<p>Common Infected kills this round: %d<p>", g_iStat_ClientCommonKilled[iClient]);
// 	StrCat(text, sizeof(text), cat);
// 	FormatEx(cat, sizeof(cat), "<p>Special Infected kills this round: %d<p>", g_iStat_ClientInfectedKilled[iClient]);
// 	StrCat(text, sizeof(text), cat);
	
// 	FormatEx(cat, sizeof(cat), "<p>END OF MESSAGE<p>");
// 	StrCat(text, sizeof(text), cat);
	
// 	StrCat(text, sizeof(text), "</body></html>");
// 	//OpenMOTDPanel(iClient, "Player Stats", text, MOTDPANEL_TYPE_TEXT);
// 	decl String:cstr[2];
// 	IntToString(iClient, cstr, sizeof(cstr));
// 	SetLongMOTD(cstr, text);
// 	CreateTimer(0.1, Timer_ShowPlayerStats, iClient, TIMER_FLAG_NO_MAPCHANGE);
// 	*/
	
	
// 	/*
// 	"<html><body bgcolor=\"#000000\" text=\"#00FF00\"><h1>Player Name = %d</h1></body></html>"
// 	<html>
// 	<body bgcolor="#000000" text="#00FF00">
// 	<h1>Player Name = %d</h1>
// 	</body>
// 	</html>
// 	*/

// 	/*PrecacheParticle("boomer_vomit");
// 	new Float:pos[3];
// 	new Float:angles[3];
// 	//GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", pos);
// 	GetClientEyePosition(iClient, pos);
// 	GetClientEyeAngles(iClient, angles);
// 	TE_Particle("boomer_vomit", pos, pos, angles, iClient);
// 	*/
	
// 	/*new Float:pos[3];
// 	new Float:angles[3];
// 	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", pos);
// 	//pos[1] += 30.0;
// 	//pos[0] += 30.0;
// 	//pos[2] -= 100.0;
// 	GetClientEyeAngles(iClient, angles);
	
// 	new ent = CreateEntityByName("env_sprite");
// 	DispatchKeyValue(ent, "model", "materials/custom/50xp_si.vmt");
// 	DispatchKeyValue(ent, "classname", "env_sprite");
// 	TeleportEntity(ent, pos, angles, NULL_VECTOR);
// 	SetVariantString("!activator");
// 	AcceptEntityInput(ent, "SetParent", iClient, ent, 0);
// 	SetVariantString("forward");
// 	AcceptEntityInput(ent, "SetParentAttachmentMaintainOffset", ent, ent, 0);
// 	DispatchSpawn(ent);
// 	ActivateEntity(ent);
// 	AcceptEntityInput(ent, "Start");
// 	//TeleportEntity(ent, pos, angles, NULL_VECTOR);
// 	*/
	
// 	/*new Handle:hHudText = CreateHudSynchronizer();
// 	SetHudTextParams(-1.0, 0.2, 5.0, 255, 255, 255, 255);
// 	ShowSyncHudText(iClient, hHudText, "This is a test");
// 	CloseHandle(hHudText);*/
	
// 	/*
// 	decl String:number[32];
// 	GetCmdArg(1, number, sizeof(number));
// 	new num = 1064;
// 	num = StringToInt(number);
// 	SetEntProp(iClient, Prop_Send, "m_iGlowType", 2);
// 	SetEntProp(iClient, Prop_Send, "m_nGlowRange", 0);
// 	SetEntProp(iClient, Prop_Send, "m_glowColorOverride", num);
// 	*/
	
// 	/*
// 	decl i;
// 	decl Float:amount[3];
// 	amount[0] = 500.0;
// 	amount[1] = 500.0;
// 	amount[2] = 100.0;
// 	for(i = 1; i<= MaxClients; i++)
// 	{
// 		if(i!=iClient)
// 		if(IsClientInGame(i) == true)
// 			Fling(i,amount,iClient);
// 	}*/
	
// 	/*decl String:number[32];
// 	GetCmdArg(1, number, sizeof(number));
// 	new num = 3;
// 	num = StringToInt(number);
// 	num  = GetEntProp(iClient, Prop_Send, "m_iGlowType", 4); //Set a steady glow(scavenger like)
// 	PrintToChat(iClient, "GlowType = %d", num);
// 	num = GetEntProp(iClient, Prop_Send, "m_nGlowRange", 4); //Set an infinite glow range(scavenger like)
// 	PrintToChat(iClient, "GlowRange = %d", num);
// 	num = GetEntProp(iClient, Prop_Send, "m_glowColorOverride", 4); //Set the color to a red color
// 	PrintToChat(iClient, "ColorOveride = %d", num);
// 	ChangeEdictState(iClient, 12); //Notify clients of the change to the glow color
// 	*/
	
	
// 	//boomflags = GetCommandFlags("boom");
// 	//SetCommandFlags("give", g_iFlag_Give & ~FCVAR_CHEAT);
// 	//SetCommandFlags("", cvarCheatsflags & ~FCVAR_CHEAT);
// 	//FakeClientCommand(iClient, "boom");
// 	//SetCommandFlags("boom", boomflags);
	
// 	//PrintToChatAll("\x03Desperatestack = %d", g_iNickDesperateMeasuresStack);
// 	//VGUI
// 	//WriteParticle(iClient, "loadoutmenu_top", 0.0, 20.0);
	
// 	/*//Store iClient name in clientidname array
// 	decl String:clientname[128];
// 	GetClientName(iClient, clientname, sizeof(clientname));
// 	for(new l=0; l<22; l++)
// 	{
// 		//clientidname[iClient][l] = -1;
// 	}
// 	for(new l=0; l<22; l++)
// 	{
// 		//clientidname[iClient][l] = clientname[l];
// 		PrintToChat(iClient, "%c, %d", clientidname[iClient][l], clientidname[iClient][l]);
// 	}*/
// 	//PrintToChat(iClient, "Clientname stored in database");
	
// 	/*WriteParticle(iClient, "smoker_smokecloud", 0.0, 30.0);
// 	WriteParticle(iClient, "smoker_smokecloud_cheap", 0.0, 30.0);
// 	PrintHintText(iClient, "OMGZZ U h4x0r");
// 	SetEntProp(iClient,Prop_Data,"m_iHealth", 50000);
// 	ExtinguishEntity(iClient);
// 	PrintToChat(iClient, "testing");
// 	new Float:vec[3];
// 	GetClientAbsOrigin(iClient, vec);
// 	vec[2] += 10;*/
// 	//PrecacheSound(SOUND_AMBTEST4);
// 	//GetClientEyePosition(iClient, vec);
// 	//EmitAmbientSound(SOUND_CUSTOM, vec, iClient, SNDLEVEL_SCREAMING);
// 	//EmitAmbientSound(SOUND_PEEING, vec, iClient, SNDLEVEL_SCREAMING);
	
// 	//new String:teststring[10];
// 	//GetCmdArg(1, teststring, sizeof(teststring));
// 	//new test =0;
// 	/*new Float:noise = GetEntDataFloat(iClient,m_noiselevel);
// 	PrintToChatAll("noise level = %f", noise);
// 	SetEntDataFloat(iClient,m_noiselevel, 100.0 ,true);
// 	noise = GetEntDataFloat(iClient,m_noiselevel);
// 	PrintToChatAll("noise level = %f", noise);*/
// 	//new glow = -1;
// 	//new weapon;
// 	//test = StringToInt(teststring);
// 	/*if(test!=0)
// 		if(IsValidEntity(test))
// 			if(IsValidEdict(test))
// 				AcceptEntityInput(test);
// 	ListParticles();
// 	*/
// 	//SetEntProp(iClient, Prop_Send, "m_bWearingSuit", 1);
// 	//SetEntProp(iClient, Prop_Send, "m_bPoisoned", 1);
// 	//SetEntData(iClient, m_bWearingSuit, 1, true);
// 	//SetEntData(iClient, m_bPoisoned, 1, true);
	
// 	/*for(new i=1;i<=MaxClients;i++)
// 	{
// 		if(RunClientChecks(i))
// 		{
// 			new m_hMyWeapons = FindSendPropInfo("CBasePlayer", "m_hMyWeapons");
// 			//SetEntityGravity(i, 0.5);
// 			for(new l=0;l<63;l++)
// 			{
// 				weapon = GetEntDataEnt2(i, m_hMyWeapons + l);            
// 				if(weapon>=0)
// 				{
// 					PrintToChat(i, "attempting change");
// 					SetEntityRenderMode(weapon, RenderMode:test);
// 					SetEntityRenderColor(weapon,255,255,255,150);
// 					SetEntData(weapon, g_iOffset_Clip1, 99, true);
// 					SetEntDataFloat(weapon, m_duration, 0.5, true);
// 				}
// 			}
// 			//SetEntData(iClient, glowrange, test, true);
// 			//SetEntData(iClient, glowtype, test, true);
// 		}
// 	}*/
// }