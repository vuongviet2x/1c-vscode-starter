@echo off
rem Xuat cau hinh tu infobase ra thu muc src\cf (sau khi sua trong Designer).
setlocal
call "%~dp0_env.cmd" || exit /b 1
if not defined PLATFORM_MISMATCH goto :ok_platform
if "%ALLOW_PLATFORM_MISMATCH%"=="1" goto :ok_platform
echo [DUNG] Khong dump khi platform khac phien ban chung cua nhom.
echo        Doi V8_VERSION / V8_PATH sang ban %TEAM_V8%.x, hoac ca nhom thong nhat doi file .1c-platform.
echo        Biet chac minh lam gi: them ALLOW_PLATFORM_MISMATCH=1 vao 1c.env.
exit /b 1
:ok_platform
set "UPD="
if exist "%SRC%\ConfigDumpInfo.xml" set "UPD=-update -force"
call "%~dp0_run.cmd" dump /DumpConfigToFiles "%SRC%" -Format Hierarchical %UPD%
exit /b %ERRORLEVEL%
