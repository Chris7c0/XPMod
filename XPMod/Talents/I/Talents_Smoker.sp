OnGameFrame_Smoker(iClient)
{
	if(g_iDirtyLevel[iClient] > 0 && g_iSmokerTransparency[iClient] != 0)
	{
		if(g_iSmokerTransparency[iClient] > 1)
		{
			g_iSmokerTransparency[iClient]--;
			SetEntityRenderColor(iClient, 255, 255, 255, RoundToFloor(255 * (1.0 - (float(g_iSmokerTransparency[iClient]) / 300))));		//300 because 10 total levels * 30 fps = 10 seconds
		}
		else
		{
			g_iSmokerTransparency[iClient] = 0;
			SetEntityRenderMode(iClient, RenderMode:0);
			SetEntityRenderColor(iClient, 255, 255, 255, 255);
		}
	}
}