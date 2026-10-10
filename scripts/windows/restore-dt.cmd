@echo off
rem Tao infobase (neu chua co) va nap file .dt vao.
rem Cach dung:  restore-dt.cmd [duong-dan-file.dt]
rem Khong truyen tham so: lay file .dt dau tien trong thu muc dt\
setlocal
call "%~dp0_env.cmd" || exit /b 1
set "DT=%~f1"
if not "%~1"=="" goto :have_dt
for %%F in ("%ROOT%\dt\*.dt") do (
  set "DT=%%~fF"
  goto :have_dt
)
:have_dt
if "%DT%"=="" goto :no_dt
if not exist "%DT%" goto :no_dt
if exist "%IB%\1Cv8.1CD" goto :restore
echo Tao infobase moi tai %IB% ...
start "" /wait "%V8_PATH%" CREATEINFOBASE File="%IB%" /Out "%LOGDIR%\create.log"
if exist "%IB%\1Cv8.1CD" goto :restore
if exist "%LOGDIR%\create.log" type "%LOGDIR%\create.log"
echo [LOI] Khong tao duoc infobase.
exit /b 1

:restore
echo CANH BAO: du lieu hien co trong %IB% se bi thay bang %DT%
choice /m "Tiep tuc"
if errorlevel 2 exit /b 1
call "%~dp0_run.cmd" restore /RestoreIB "%DT%"
exit /b %ERRORLEVEL%

:no_dt
echo [LOI] Khong tim thay file .dt. Chep file .dt vao thu muc dt\ hoac truyen duong dan.
exit /b 1
