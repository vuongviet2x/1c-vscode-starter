@echo off
rem Nap code tu src\cf vao cau hinh va kiem tra cu phap module.
rem KHONG cap nhat database (an toan, chay bao nhieu lan cung duoc).
setlocal
call "%~dp0_env.cmd" || exit /b 1
if not exist "%SRC%\Configuration.xml" (
  echo [LOI] src\cf chua co cau hinh. Chay dump.cmd truoc.
  exit /b 1
)
call "%~dp0_run.cmd" backup /DumpCfg "%LOGDIR%\backup-before-load.cf" || exit /b 1
call "%~dp0_run.cmd" load /LoadConfigFromFiles "%SRC%" -Format Hierarchical -updateConfigDumpInfo || exit /b 1
call "%~dp0_run.cmd" check /CheckModules -ThinClient -WebClient -Server -ExternalConnection
exit /b %ERRORLEVEL%
