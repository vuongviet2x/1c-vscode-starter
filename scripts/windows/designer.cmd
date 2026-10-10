@echo off
rem Mo Designer (giao dien) cho infobase cua du an.
setlocal
call "%~dp0_env.cmd" || exit /b 1
start "" "%V8_PATH%" DESIGNER /F "%IB%" %AUTH% /L %UI_LANG%
