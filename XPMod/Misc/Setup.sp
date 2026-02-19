void SetupConsoleCommands()
{
	RegConsoleCmd("xpmstats", ShowTeamStatsToPlayer);
	RegConsoleCmd("website", MotdPanel);
	RegConsoleCmd("xpmhelp", OpenHelpMotdPanel);
	//RegConsoleCmd("resetmyaccount", ResetAll);		//Reset Level, skillpoints, XP,  and talents (taking this out to avoid issues)
	RegConsoleCmd("xpmbind1", Bind1Press);				//This is the bound key function for ultimate abilities, Bind 1
	RegConsoleCmd("xpmbind2", Bind2Press);				//This is the bound key function for ultimate abilities, Bind 2
	RegConsoleCmd("xpmbinduses", ShowBindsRemaining);	//Display the total number of bind1 and bind2 uses left
	RegConsoleCmd("buy", ShowUserLoadoutMenu);			// People always use this buy command from other servers, show them that they can buy equipment in xpmod
	RegConsoleCmd("banme", QuickBan);
	
	RegConsoleCmd("say", SayCmd);
	RegConsoleCmd("say_team", SayTeamCmd);
	
	RegAdminCmd("freeze", FreezeGame, ADMFLAG_SLAY);
	
	SetupDevCommands();
}

void SetupDevCommands()
{
	if (g_bDevModeEnabled == false)
		return;

	RegAdminCmd("givexp", GiveXP, ADMFLAG_RCON);
	RegAdminCmd("giveidxp", GiveXPbyID, ADMFLAG_RCON);
	
	RegAdminCmd("xpmod_debug_mode", XPModDebugModeToggle, ADMFLAG_SLAY);
	RegAdminCmd("t1", TestFunction1, ADMFLAG_SLAY);
	RegAdminCmd("t2", TestFunction2, ADMFLAG_SLAY);
	RegAdminCmd("t3", TestFunction3, ADMFLAG_SLAY);
	RegAdminCmd("t4", TestFunction4, ADMFLAG_SLAY);
	RegAdminCmd("t5", TestFunction5, ADMFLAG_SLAY);
	RegAdminCmd("omghaxor", GiveMoreBinds, ADMFLAG_SLAY);
	//RegConsoleCmd("push", push);
	//RegConsoleCmd("pop", pop);
	//RegAdminCmd("s", ChangeSpeed, ADMFLAG_SLAY);
	//RegConsoleCmd("sprite", Command_sprite);
}

void SetupGameOffsets()
{
	g_iOffset_ShovePenalty			= FindSendPropInfo("CTerrorPlayer", "m_iShovePenalty");
	g_iOffset_PlaybackRate			= FindSendPropInfo("CBaseCombatWeapon", "m_flPlaybackRate");
	g_iOffset_ActiveWeapon			= FindSendPropInfo("CBaseCombatCharacter", "m_hActiveWeapon");
	g_iOffset_NextPrimaryAttack		= FindSendPropInfo("CBaseCombatWeapon", "m_flNextPrimaryAttack");
	// g_iOffset_NextSecondaryAttack 	= FindSendPropInfo("CBaseCombatWeapon", "m_flNextSecondaryAttack");
	g_iOffset_TimeWeaponIdle		= FindSendPropInfo("CTerrorGun", "m_flTimeWeaponIdle");
	g_iOffset_NextAttack			= FindSendPropInfo("CTerrorPlayer", "m_flNextAttack");
	g_iOffset_ReloadStartDuration	= FindSendPropInfo("CBaseShotgun", "m_reloadStartDuration");
	g_iOffset_ReloadInsertDuration	= FindSendPropInfo("CBaseShotgun", "m_reloadInsertDuration");
	g_iOffset_ReloadEndDuration		= FindSendPropInfo("CBaseShotgun", "m_reloadEndDuration");
	g_iOffset_ReloadState			= FindSendPropInfo("CBaseShotgun", "m_reloadState");
	//g_iOffset_ReloadStartTime		= FindSendPropInfo("CBaseShotgun", "m_reloadStartTime");
	g_iOffset_LayerStartTime		= FindSendPropInfo("CTerrorViewModel", "m_flLayerStartTime");
	g_iOffset_ViewModel				= FindSendPropInfo("CTerrorPlayer", "m_hViewModel");
	g_iOffset_HealthBuffer			= FindSendPropInfo("CTerrorPlayer", "m_healthBuffer");
	//g_iOffset_HealthBufferTime		= FindSendPropInfo("CTerrorPlayer", "m_healthBufferTime");
	g_iOffset_CustomAbility			= FindSendPropInfo("CTerrorPlayer", "m_customAbility");
	g_iOffset_Clip1					= FindSendPropInfo("CAssaultRifle", "m_iClip1");
	g_iOffset_ClipShotgun			= FindSendPropInfo("CBaseShotgun", "m_iClip1");
	g_iOffset_MoveCollide 			= FindSendPropInfo("CBaseEntity", "movecollide");
	g_iOffset_MoveType    			= FindSendPropInfo("CBaseEntity", "movetype");
	g_iOffset_VecVelocity   		= FindSendPropInfo("CBasePlayer", "m_vecVelocity[0]");
	g_iOffset_IsGhost       		= FindSendPropInfo("CTerrorPlayer", "m_isGhost");
	//g_iOffset_OwnerEntity			= FindSendPropInfo("CBaseCombatWeapon", "m_hOwnerEntity");
	g_iOffset_ReloadNumShells		= FindSendPropInfo("CBaseShotgun", "m_reloadNumShells");
	//g_iOffset_ShellsInserted		= FindSendPropInfo("CBaseShotgun", "m_shellsInserted");
	g_bOffset_InReload				= FindSendPropInfo("CBaseShotgun", "m_bInReload");
	//g_iOffset_Ammo					= FindDataMapOffs("CTerrorPlayer", "m_iAmmo");
	
	g_umsgFade = GetUserMessageId("Fade");
}

void SetupSDKCalls()
{
	Handle hGameConfigFile = INVALID_HANDLE;
	hGameConfigFile = LoadGameConfigFile("xpmdata");
	if (hGameConfigFile != INVALID_HANDLE)
	{
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "CTerrorPlayer_OnVomitedUpon");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		g_hSDK_VomitOnPlayer = EndPrepSDKCall();

		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "CTerrorPlayer_OnITExpired");
		g_hSDK_UnVomitOnPlayer = EndPrepSDKCall();
		
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "RoundRespawn");
		g_hSDK_RoundRespawn = EndPrepSDKCall();
		
		////NOT USED
		// //StartPrepSDKCall(SDKCall_Player);
		// //PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "BecomeGhost");
		// //PrepSDKCall_AddParameter(SDKType_PlainOldData , SDKPass_Plain);
		// //g_hSDK_BecomeGhost = EndPrepSDKCall();
		
		////NOT USED
		// //StartPrepSDKCall(SDKCall_Player);
		// //PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "State_Transition");
		// //PrepSDKCall_AddParameter(SDKType_PlainOldData , SDKPass_Plain);
		// //g_hSDK_StateTransition = EndPrepSDKCall();
		
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "SetHumanSpec");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		g_hSDK_SetHumanSpec = EndPrepSDKCall();
		
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "TakeOverBot");
		PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
		g_hSDK_TakeOverBot = EndPrepSDKCall();
		
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "CTerrorPlayer::OnPounceEnd");
		g_hSDK_OnPounceEnd = EndPrepSDKCall();
		
		// Working
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "CTerrorPlayer_Fling");
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
		g_hSDK_Fling = EndPrepSDKCall();
		
		//
		// StartPrepSDKCall(SDKCall_Player);
		// PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "SetClass");
		// PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		// g_hSetClass = EndPrepSDKCall();
		
		//
		StartPrepSDKCall(SDKCall_Static);
		PrepSDKCall_SetFromConf(hGameConfigFile, SDKConf_Signature, "CreateAbility");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
		g_hCreateAbility = EndPrepSDKCall();
		
		g_iOffset_NextActivation = GameConfGetOffset(hGameConfigFile, "SIAbilityNextActivation");
		
		//g_iAbility = GameConfGetOffset(hGameConfigFile, "Ability");
		
		if (g_hCreateAbility == INVALID_HANDLE)
			SetFailState("[+] S_HGD: Error: Unable to find CreateAbility signature.");
		
		CloseHandle(hGameConfigFile);
	}
	else
		SetFailState("[XPMod] Install the required gamedata file to addons/sourcemod/gamedata/xpmdata.txt");
}

void SetupInitialVariableValues()
{
	// Set Client variables
	for(int i = 0; i <= MaxClients; i++)
	{
		g_iClientNextLevelXPAmount[i] = RoundToFloor(LEVEL_1 * XP_MULTIPLIER);
		
		//Set Infected classes to their initial values
		g_iClientInfectedClass1[i]	= UNKNOWN_INFECTED;
		g_iClientInfectedClass2[i]	= UNKNOWN_INFECTED;
		g_iClientInfectedClass3[i]	= UNKNOWN_INFECTED;
		g_strClientInfectedClass1[i] = "None"; 
		g_strClientInfectedClass2[i] = "None";
		g_strClientInfectedClass3[i] = "None";
		
		//Initially set the client name to all null characters
		for (int l = 0; l<23; l++)
			clientidname[i][l] = '\0';
	}

	ResetAllVariablesForRound();

	// Setup Global ArrayLists
	g_listEnhancedCIEntities = CreateArray(ENHANCED_CI_ENTITIES_ARRAY_LIST_SIZE);
	g_listTankRockEntities = CreateArray(TANK_ROCK_ENTITIES_ARRAY_LIST_SIZE);
}

