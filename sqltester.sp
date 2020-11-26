#include <sourcemod>
#include <sdktools>

#define DB_HOST 		"xpmodclients.db.6902666.hostedresource.com"
#define DB_DATABASE		"xpmodclients"
#define DB_USER			"xpmodclients"
#define DB_PASSWORD		"C1ientPW"
#define DB_CONF_NAME 	"sqltester"
#define DB_TABLENAME  	"test"

new Handle:g_hDatabase = INVALID_HANDLE;


public Plugin:myinfo = 
{
	name = "SQL Tester",
	author = "Dragonzk and Chrisp",
	description = "testing SQL",
	version = "1.0",
	url = "null"
}

public OnPluginStart()
{
	RegConsoleCmd("massinsert", ConsoleCommandMassInsert);
	RegConsoleCmd("massquery", ConsoleCommandMassQuery);
	RegConsoleCmd("deletedata", ConsoleCommandDeleteData);
}


public Action:ConsoleCommandMassInsert(client, args)
{
	decl String:queryInsert[256];
	decl String:number[16];
	for(new i = 8000;i < 16000; i++)
	{
		IntToString(i, number, sizeof(number));
		Format(queryInsert, sizeof(queryInsert), "INSERT INTO %s (SteamID, Name, IsBot) VALUES ('%s', 'black bear', 1)", DB_TABLENAME, number);
		SQL_TQuery(g_hDatabase, SQLErrorCheckCallback, queryInsert);
	}
}

public Action:ConsoleCommandMassQuery(client, args)
{
	decl String:query[64];
	for(new i = 0;i < 2; i++)
	{
		Format(query, sizeof(query), "SELECT SteamID FROM %s", DB_TABLENAME);
		SQL_TQuery(g_hDatabase, GetDataFromQuery, query);
	}
}

public Action:ConsoleCommandDeleteData(client, args)
{
	decl String:query[64];
	Format(query, sizeof(query), "DELETE FROM %s", DB_TABLENAME);
	SQL_TQuery(g_hDatabase, GetDataFromQuery, query);
}


public OnMapStart()
{
	PrintToServer("----------------------------  STARTING SQL TESTER  ----------------------------");
	
	if(ConnectDB())
	{
		PrintToServer("*** Connected To Database ***");
		
		/*decl String:query1[64];
		Format(query1, sizeof(query1), "UPDATE %s SET SteamID = 'NEWTEST' WHERE id = 1", DB_TABLENAME);
		
		SQL_TQuery(g_hDatabase, SQLErrorCheckCallback, query1);*/
		
		/*new bool:success = SQL_FastQuery(g_hDatabase, queryInsert);
		if (success)
		{
		
		}
		else
		{
			decl String:error[255];
			SQL_GetError(g_hDatabase, error, sizeof(error));
			LogError("Unable to REPLACE ban into DB,%s, query", error);
		}*/
		
		/*decl String:query2[64];
		Format(query2, sizeof(query2), "SELECT SteamID FROM %s", DB_TABLENAME);
		
		SQL_TQuery(g_hDatabase, GetDataFromQuery, query2);*/
	}
	else
		PrintToServer("*** Could Not Connect To Database ***");
}

// Generate total rank amount.
public GetDataFromQuery(Handle:owner, Handle:hQuery, const String:error[], any:data)
{
	if (hQuery == INVALID_HANDLE)
	{
		LogError("GetDataFromQuery Query failed: %s", error);
		return;
	}

	decl String:s[64];
	
	while (SQL_FetchRow(hQuery))
	{
		if(SQL_FetchString(hQuery, 0, s, 64) != 0)
			PrintToServer(s);
		else
			PrintToServer("Error getting row from query");
	}
}

// Report error on sql query;

public SQLErrorCheckCallback(Handle:owner, Handle:hndl, const String:error[], any:queryid)
{
	if (g_hDatabase == INVALID_HANDLE)
		return;

	if(!StrEqual("", error))
	{
		LogError("SQL Error: %s", error);
	}
}

bool:ConnectDB()
{
	if (g_hDatabase != INVALID_HANDLE)
		return true;
	
	new Handle:hKeyValues = CreateKeyValues("sql");
	KvSetString(hKeyValues, "driver", "mysql");
	KvSetString(hKeyValues, "host", DB_HOST);
	KvSetString(hKeyValues, "database", DB_DATABASE);
	KvSetString(hKeyValues, "user", DB_USER);
	KvSetString(hKeyValues, "pass", DB_PASSWORD);

	decl String:error[255];
	g_hDatabase = SQL_ConnectCustom(hKeyValues, error, sizeof(error), true);
	CloseHandle(hKeyValues);

	if (g_hDatabase == INVALID_HANDLE)
	{
		LogError("SQL Connection Failed: %s", error);
		return false;
	}
	
	/*if (SQL_CheckConfig(DB_CONF_NAME))
	{
		new String:Error[256];
		g_hDatabase = SQL_Connect(DB_CONF_NAME, true, Error, sizeof(Error));

		if (g_hDatabase == INVALID_HANDLE)
		{
			LogError("Failed to connect to database: %s", Error);
			return false;
		}
		else if (!SQL_FastQuery(g_hDatabase, "SET NAMES 'utf8'"))
		{
			if (SQL_GetError(g_hDatabase, Error, sizeof(Error)))
				LogError("Failed to update encoding to UTF8: %s", Error);
			else
				LogError("Failed to update encoding to UTF8: unknown");
		}
		
	}
	else
	{
		LogError("Databases.cfg missing '%s' entry!", DB_CONF_NAME);
		return false;
	}*/

	return true;
}