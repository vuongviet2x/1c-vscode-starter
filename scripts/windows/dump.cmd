@echo off
rem Xuat cau hinh tu infobase ra thu muc src\cf (sau khi sua trong Designer).
setlocal
call "%~dp0_env.cmd" || exit /b 1
set "UPD="
if exist "%SRC%\ConfigDumpInfo.xml" set "UPD=-update -force"
call "%~dp0_run.cmd" dump /DumpConfigToFiles "%SRC%" -Format Hierarchical %UPD%
exit /b %ERRORLEVEL%
