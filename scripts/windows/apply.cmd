@echo off
rem Nap code tu src\cf vao cau hinh VA cap nhat database (giong F7 trong Designer).
rem Dong het Designer va cac phien 1C:Enterprise dang mo infobase nay truoc khi chay.
setlocal
call "%~dp0_env.cmd" || exit /b 1
if not exist "%SRC%\Configuration.xml" (
  echo [LOI] src\cf chua co cau hinh. Chay dump.cmd truoc.
  exit /b 1
)
call "%~dp0_run.cmd" backup /DumpCfg "%LOGDIR%\backup-before-load.cf" || exit /b 1
call "%~dp0_run.cmd" load /LoadConfigFromFiles "%SRC%" -Format Hierarchical -updateConfigDumpInfo || exit /b 1
call "%~dp0_run.cmd" update /UpdateDBCfg
exit /b %ERRORLEVEL%
