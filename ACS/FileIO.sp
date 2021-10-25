void CreateNewMapListFileIfDoesNotExist()
{
	SetACSMapListFilePath();

	// Check to make sure the file doesn't already exist
	if (FileExists(g_strMapListFilePath))
		return;

	WriteDefaultMapListToFile();
}

void SetACSMapListFilePath()
{	
	BuildPath(Path_SM, g_strMapListFilePath, PLATFORM_MAX_PATH, ACS_MAP_LIST_FILE_PATH);
}

void WriteDefaultMapListToFile()
{
	if (strlen(g_strMapListFilePath) < 1)
	{
		LogError("ACS Error: g_strMapListFilePath not set!");
		return;
	}

	Handle hFile = OpenFile(g_strMapListFilePath, "w");
	if (hFile == null)
	{
		LogError("ACS Error: Unable to open and write to map list file path!");
		CloseHandle(hFile);
		return;
	}

	char strBuffer[256];
	for (int i=0; i < sizeof(g_strDefaultMapListArray); i++)
	{
		strBuffer = "";

		for(int j=0; j < sizeof(g_strDefaultMapListArray[]); j++)
		{
			StrCat(strBuffer, sizeof(strBuffer), g_strDefaultMapListArray[i][j]);
			if(j != sizeof(g_strDefaultMapListArray[]) -1 )
				StrCat(strBuffer, sizeof(strBuffer), ",");

			// PrintToServer("i,j: %i, %i %s", i, j, g_strDefaultMapListArray[i][j]);
		}

		// PrintToServer("================== strBuffer: %s", strBuffer);
		WriteFileLine(hFile, strBuffer);
	}
	
	CloseHandle(hFile);
}

void SetupMapListArrayFromFile()
{
	SetACSMapListFilePath();

	// Check to make sure the file doesn't already exist
	if (FileExists(g_strMapListFilePath) == false)
		return;

	// TODO: Clear out any previous maps from the storage array

	// Open the file
	Handle hFile = OpenFile(g_strMapListFilePath, "rt");
	if (hFile == null)
	{
		LogError("ACS Error: Unable to open and read map list file path!");
		CloseHandle(hFile);
		return;
	}

	// Read each line from the file and store its info into the global map list array
	char strLine[300], strLineItems[4][64];
	int iCurrentArrayRow;
	while(IsEndOfFile(hFile) == false && ReadFileLine(hFile, strLine, sizeof(strLine)))
	{
		// Remove any white space
		TrimString(strLine);

		// Ensure there is some data before going further with this line
		if (strlen(strLine) <= 0)
			continue;
		
		ExplodeString(strLine, ",", strLineItems, sizeof(strLineItems), sizeof(strLineItems[]));

		// PushArrayArray(g_listMaps, strLineItems);

		// PrintToServer("%s		%s		%s		%s", strLineItems[0], strLineItems[1], strLineItems[2], strLineItems[3]);
		for (int iItemIndex = 0; iItemIndex < 4; iItemIndex++)
		{
			// Remove any white space
			TrimString(strLineItems[iItemIndex]);
			// Store it into the global array list
			g_strMapListArray[iCurrentArrayRow][iItemIndex] = strLineItems[iItemIndex];
		}

		// PrintToServer("g_strMapListArray: %s		%s		%s		%s", g_strMapListArray[iCurrentArrayRow][0], g_strMapListArray[iCurrentArrayRow][1], g_strMapListArray[iCurrentArrayRow][2], g_strMapListArray[iCurrentArrayRow][3]);

		iCurrentArrayRow++;
	}
}

void PrintTheCurrentMapListArrayInfo()
{
	char strBuffer[256];
	for (int i=0; i < sizeof(g_strMapListArray); i++)
	{
		strBuffer = "";

		for(int j=0; j < sizeof(g_strMapListArray[]); j++)
		{
			StrCat(strBuffer, sizeof(strBuffer), g_strMapListArray[i][j]);
			if(j != sizeof(g_strMapListArray[]) -1 )
				StrCat(strBuffer, sizeof(strBuffer), ",");

			// PrintToServer("i,j: %i, %i %s", i, j, g_strMapListArray[i][j]);
		}

		PrintToServer("%i: %s", i, strBuffer);
	}
}

void EmptyTheCurrentMapListArrayInfo()
{
	for (int i=0; i < sizeof(g_strMapListArray); i++)
		for(int j=0; j < sizeof(g_strMapListArray[]); j++)
			g_strMapListArray[i][j][0] = 0;
}

void SetCurrentMapIndexRangeForCurrentGameMode()
{
	// Reset the values
	g_iMapsIndexStartForCurrentGameMode = -1;
	g_iMapsIndexEndForCurrentGameMode = -1;

	for (int i=0; i < sizeof(g_strMapListArray); i++)
	{
		// Ensure the game mode for this index in the map list array matches the current one, or skip this one
		if (StrEqual(g_strMapListArray[i][MAP_LIST_COLUMN_GAMEMODE], g_strGameModeString[g_iGameMode], false) == false)
			continue;

		// Set the Start index, only if not already set
		if (g_iMapsIndexStartForCurrentGameMode == -1)
			g_iMapsIndexStartForCurrentGameMode = i;
		
		// Keep setting this because each time will be higher
		g_iMapsIndexEndForCurrentGameMode = i;
	}

	PrintToServer("\n\n\nSetCurrentMapIndexRangeForCurrentGameMode: %i -> %i\n\n\n", g_iMapsIndexStartForCurrentGameMode, g_iMapsIndexEndForCurrentGameMode);
}