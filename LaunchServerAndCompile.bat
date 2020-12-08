@echo off

set l4d2pluginfolder="C:\Program Files (x86)\Steam\steamapps\common\Left 4 Dead 2 Dedicated Server\left4dead2\addons\sourcemod\plugins\"
set l4d2networkfolder="D:\l4d2\"

spcomp xpmod.sp -v 0

@echo off

xcopy ".\xpmod.smx" %l4d2pluginfolder% /Y >NUL
xcopy ".\xpmod.smx" %l4d2networkfolder% /Y >NUL

start .\LaunchServer.lnk