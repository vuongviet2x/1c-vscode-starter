@echo off
rem Mo infobase o che do 1C:Enterprise (thin client).
setlocal
call "%~dp0_env.cmd" || exit /b 1
set "CLIENT=%V8C_PATH%"
if not exist "%CLIENT%" set "CLIENT=%V8_PATH%"
start "" "%CLIENT%" ENTERPRISE /F "%IB%" %AUTH% /L %UI_LANG%
