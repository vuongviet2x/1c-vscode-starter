@echo off
rem Xuat cau hinh tu infobase ra thu muc src\cf (sau khi sua trong Designer).
setlocal
call "%~dp0_env.cmd" || exit /b 1
if not defined PLATFORM_MISMATCH goto :ok_platform
if "%ALLOW_PLATFORM_MISMATCH%"=="1" goto :ok_platform
echo [DUNG] Khong dump khi platform khac phien ban chung cua nhom (%TEAM_V8%.x).
echo        Dat V8_VERSION=%TEAM_V8% trong 1c.env, hoac ca nhom thong nhat sua file .1c-platform.
echo        Biet chac minh lam gi: them ALLOW_PLATFORM_MISMATCH=1 vao 1c.env.
exit /b 1
:ok_platform
set "UPD="
if exist "%SRC%\ConfigDumpInfo.xml" set "UPD=-update -force"
call "%~dp0_run.cmd" dump /DumpConfigToFiles "%SRC%" -Format Hierarchical %UPD% || exit /b 1

rem Lan dump dau tien: ghi phien ban platform vao .1c-platform de ca nhom dung chung
if exist "%ROOT%\.1c-platform" exit /b 0
for /f "tokens=1-3 delims=." %%a in ("%V8_DETECTED%") do set "TEAM_NEW=%%a.%%b.%%c"
if "%TEAM_NEW%"=="" exit /b 0
<nul set /p "=%TEAM_NEW%" > "%ROOT%\.1c-platform"
echo [MOI] Da ghi phien ban platform %TEAM_NEW% vao file .1c-platform. Commit file nay de ca nhom dung chung ban.
exit /b 0
