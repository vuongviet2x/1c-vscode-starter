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
set "PF86=%ProgramFiles(x86)%"
if not "%V8_PATH%"=="" goto :check_v8
if exist "%ProgramFiles%\1cv8\%V8_VERSION%\bin\1cv8.exe" set "V8_PATH=%ProgramFiles%\1cv8\%V8_VERSION%\bin\1cv8.exe"
if not "%V8_PATH%"=="" goto :check_v8
if exist "%PF86%\1cv8\%V8_VERSION%\bin\1cv8.exe" set "V8_PATH=%PF86%\1cv8\%V8_VERSION%\bin\1cv8.exe"
if not "%V8_PATH%"=="" goto :check_v8
rem Ban training (hoc tap) cua platform: thu muc 1cv8t, file 1cv8t.exe
if exist "%ProgramFiles%\1cv8t\%V8_VERSION%\bin\1cv8t.exe" set "V8_PATH=%ProgramFiles%\1cv8t\%V8_VERSION%\bin\1cv8t.exe"
if not "%V8_PATH%"=="" goto :check_v8
if exist "%PF86%\1cv8t\%V8_VERSION%\bin\1cv8t.exe" set "V8_PATH=%PF86%\1cv8t\%V8_VERSION%\bin\1cv8t.exe"

:check_v8
if exist "%V8_PATH%" goto :v8_ok
echo [LOI] Khong tim thay 1cv8.exe cua platform %V8_VERSION%.
if not "%V8_PATH%"=="" echo       V8_PATH trong 1c.env tro toi file khong ton tai: %V8_PATH%
echo       Cac ban platform tim thay trong Program Files:
set "FOUND="
for /d %%D in ("%ProgramFiles%\1cv8\8.*") do call :show_v8 "%%~fD"
for /d %%D in ("%PF86%\1cv8\8.*") do call :show_v8 "%%~fD"
for /d %%D in ("%ProgramFiles%\1cv8t\8.*") do call :show_v8 "%%~fD"
for /d %%D in ("%PF86%\1cv8t\8.*") do call :show_v8 "%%~fD"
if not defined FOUND echo         - khong co ban nao. Platform co the cai o noi khac: dien duong dan day du vao V8_PATH.
echo       Sua V8_VERSION trong 1c.env cho dung mot ban o tren, hoac dien V8_PATH.
exit /b 1

:show_v8
if exist "%~1\bin\1cv8.exe" echo         %~nx1   -^>  %~1\bin\1cv8.exe
if exist "%~1\bin\1cv8.exe" set "FOUND=1"
if exist "%~1\bin\1cv8t.exe" echo         %~nx1 (training)   -^>  %~1\bin\1cv8t.exe
if exist "%~1\bin\1cv8t.exe" set "FOUND=1"
exit /b 0

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
echo [CANH BAO] Platform cua ban la %V8_DETECTED%, nhom thong nhat dung %TEAM_V8%.x (file .1c-platform).
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
