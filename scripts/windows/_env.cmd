@echo off
rem ===================================================================
rem  Doc 1c.env va chuan bi bien dung chung. Cac script khac goi file nay:
rem      call "%~dp0_env.cmd" || exit /b 1
rem ===================================================================
for %%I in ("%~dp0..\..") do set "ROOT=%%~fI"
set "SRC=%ROOT%\src\cf"
set "LOGDIR=%ROOT%\logs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

if exist "%ROOT%\1c.env" goto :read_env
echo [LOI] Chua co file 1c.env trong thu muc du an.
echo       Hay chay scripts\windows\doctor.cmd (tu tao 1c.env) hoac sao chep 1c.env.example thanh 1c.env.
exit /b 1

:read_env
set "V8_VERSION="
set "V8_PATH="
set "IB_PATH="
set "IB_USER="
set "IB_PWD="
set "UI_LANG="
set "ALLOW_PLATFORM_MISMATCH="
set "PLATFORM_MISMATCH="
for /f "usebackq eol=# tokens=1,* delims==" %%A in ("%ROOT%\1c.env") do set "%%A=%%B"
if "%UI_LANG%"=="" set "UI_LANG=en"
if "%IB_PATH%"=="" set "IB_PATH=ib"

rem --- Tim 1cv8.exe (Designer) ---------------------------------------
rem V8_PATH dien san -> dung luon. Khong thi tu tim ban MOI NHAT khop V8_VERSION
rem (V8_VERSION trong = moi ban; 8.3.25 = moi ban 8.3.25.x; 8.3.25.1445 = dung ban do).
if not "%V8_PATH%"=="" goto :check_v8
for /f "usebackq delims=" %%P in (`powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0find-platform.ps1" -Want "%V8_VERSION%"`) do set "V8_PATH=%%P"

:check_v8
if exist "%V8_PATH%" goto :v8_ok
if "%V8_VERSION%"=="" echo [LOI] Khong tim thay platform 1C:Enterprise nao tren may.
if not "%V8_VERSION%"=="" echo [LOI] Khong tim thay platform khop V8_VERSION=%V8_VERSION%.
if not "%V8_PATH%"=="" echo       V8_PATH trong 1c.env tro toi file khong ton tai: %V8_PATH%
echo       Cac ban platform tim thay:
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0find-platform.ps1" -List
echo       Sua V8_VERSION trong 1c.env (de trong = tu chon ban moi nhat), hoac dien V8_PATH.
exit /b 1

:v8_ok
for %%I in ("%V8_PATH%") do set "V8_BIN=%%~dpI"
for %%I in ("%V8_PATH%") do set "V8_EXE=%%~nI"
set "V8C_PATH=%V8_BIN%1cv8c.exe"
rem Ban training: Designer = 1cv8t.exe, thin client = 1cv8ct.exe
if /i "%V8_EXE%"=="1cv8t" set "V8C_PATH=%V8_BIN%1cv8ct.exe"

rem --- So phien ban platform voi phien ban chung cua nhom (.1c-platform) ---
for %%I in ("%V8_BIN%..") do set "V8_VDIR=%%~fI"
for %%I in ("%V8_VDIR%") do set "V8_DETECTED=%%~nxI"
set "TEAM_V8="
if exist "%ROOT%\.1c-platform" set /p TEAM_V8=<"%ROOT%\.1c-platform"
if "%TEAM_V8%"=="" goto :team_ok
echo %V8_DETECTED%.| findstr /b /l /c:"%TEAM_V8%." >nul && goto :team_ok
set "PLATFORM_MISMATCH=1"
echo [CANH BAO] Platform cua ban la %V8_DETECTED%, nhom dang dung %TEAM_V8%.x (file .1c-platform).
echo            dump bang ban khac co the lam ca nhom khong nap duoc src\cf. Xem docs\06-lam-viec-nhom.md
:team_ok

rem --- Duong dan infobase --------------------------------------------
set "IB=%ROOT%\%IB_PATH%"
if "%IB_PATH:~1,1%"==":" set "IB=%IB_PATH%"
if "%IB_PATH:~0,2%"=="\\" set "IB=%IB_PATH%"

rem --- Tham so chung --------------------------------------------------
set "AUTH="
if not "%IB_USER%"=="" set AUTH=/N "%IB_USER%" /P "%IB_PWD%"
set COMMON=/DisableStartupDialogs /DisableStartupMessages /L %UI_LANG%
exit /b 0
