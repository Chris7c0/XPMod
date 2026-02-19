void SetUpTheDBConnection()
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

bool ConnectDB()
{	

	if (SQL_CheckConfig(DB_CONF_NAME))
	{
		char Error[256];
		g_hDatabase = SQL_Connect(DB_CONF_NAME, true, Error, sizeof(Error));

		if (g_hDatabase == INVALID_HANDLE)
		{
			LogError("Failed to connect to XPMod database: %s", Error);
			return false;
		}
	}
	else
	{
		LogError("[XPMod] Databases.cfg missing '%s' entry!", DB_CONF_NAME);
		return false;
	}
	
	return true;
}
