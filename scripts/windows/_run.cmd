@echo off
rem ===================================================================
rem  Chay Designer o che do batch va kiem tra ket qua.
rem  Cach dung:  call "%~dp0_run.cmd" <ten-buoc> <lenh Designer...>
rem  Vi du:      call "%~dp0_run.cmd" dump /DumpConfigToFiles "%SRC%"
rem  Log:        logs\<ten-buoc>.log     Ket qua: logs\<ten-buoc>.result
rem ===================================================================
set "STEP=%~1"
set "STEP_LOG=%LOGDIR%\%STEP%.log"
set "STEP_RES=%LOGDIR%\%STEP%.result"
if exist "%STEP_LOG%" del /q "%STEP_LOG%"
if exist "%STEP_RES%" del /q "%STEP_RES%"

rem Lay phan lenh sau tham so dau tien
set "ARGS="
:collect
shift
if "%~1"=="" goto :run
set ARGS=%ARGS% %1
goto :collect

:run
if exist "%IB%\1Cv8.1CD" goto :run_ok
echo.
echo [LOI] Chua co infobase tai: %IB%
echo       Lam buoc tao infobase truoc: restore-dt.cmd (co file .dt) hoac new-ib.cmd (cau hinh trong).
exit /b 1

:run_ok
echo.
echo === [%STEP%] dang chay Designer ...
start "" /wait "%V8_PATH%" DESIGNER /F "%IB%" %AUTH% %COMMON% /Out "%STEP_LOG%" /DumpResult "%STEP_RES%" %ARGS%

if exist "%STEP_LOG%" powershell -NoProfile -Command "Get-Content -Encoding UTF8 -LiteralPath $env:STEP_LOG"
if not exist "%STEP_RES%" goto :fail
findstr /c:"1" "%STEP_RES%" >nul && goto :fail
echo === [%STEP%] OK
exit /b 0

:fail
echo === [%STEP%] LOI. Xem chi tiet: logs\%STEP%.log
exit /b 1
