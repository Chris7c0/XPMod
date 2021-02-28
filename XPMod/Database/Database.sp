SetUpTheDBConnection()
{
	//Setup the handle that will link to the MySQL Database
	if(ConnectDB())
	{
		PrintToServer("\n*** Connected to XPMod Database ***\n ");
	}
	else
	{
		PrintToServer("\n********************************************");
		PrintToServer("*** Could Not Connect to XPMod Database! ***");
		PrintToServer("********************************************\n ");
	}
}

bool:ConnectDB()
{	

	if (SQL_CheckConfig(DB_CONF_NAME))
	{
		new String:Error[256];
		g_hDatabase = SQL_Connect(DB_CONF_NAME, true, Error, sizeof(Error));

		if (g_hDatabase == INVALID_HANDLE)
		{
			LogError("Failed to connect to XPMod database: %s", Error);
			return false;
		}
		// This SET NAMES 'utf8' doesnt look like its required.
		// else if (!SQL_FastQuery(g_hDatabase, "SET NAMES 'utf8'"))
		// {
		// 	if (SQL_GetError(g_hDatabase, Error, sizeof(Error)))
		// 		LogError("Failed to update XPMod DB encoding to UTF8: %s", Error);
		// 	else
		// 		LogError("Failed to update XPMod DB encoding to UTF8: unknown");
		// }
	}
	else
	{
		LogError("[XPMod] Databases.cfg missing '%s' entry!", DB_CONF_NAME);
		return false;
	}
	
	// This is used when connecting via the sourcecode
	// new Handle:hKeyValues = CreateKeyValues("sql");
	// KvSetString(hKeyValues, "driver", "mysql");
	// KvSetString(hKeyValues, "host", DB_HOST);
	// KvSetString(hKeyValues, "database", DB_DATABASE);
	// KvSetString(hKeyValues, "user", DB_USER);
	// KvSetString(hKeyValues, "pass", DB_PASSWORD);

	// decl String:error[255];
	// g_hDatabase = SQL_ConnectCustom(hKeyValues, error, sizeof(error), true);
	// CloseHandle(hKeyValues);

	// if (g_hDatabase == INVALID_HANDLE)
	// {
	// 	LogError("MySQL Connection For XPMod User Database Failed: %s", error);
	// 	return false;
	// }
	
	return true;
}