@echo off
rem Tao infobase trong (khong co cau hinh) - dung cho lop MIS tu xay dung he thong.
setlocal
call "%~dp0_env.cmd" || exit /b 1
if exist "%IB%\1Cv8.1CD" (
  echo [LOI] Da co infobase. Xoa thu muc ib neu muon tao lai.
  exit /b 1
)
start "" /wait "%V8_PATH%" CREATEINFOBASE File="%IB%" /Out "%LOGDIR%\create.log"
if exist "%LOGDIR%\create.log" type "%LOGDIR%\create.log"
if not exist "%IB%\1Cv8.1CD" (
  echo [LOI] Khong tao duoc infobase.
  exit /b 1
)
echo [OK] Da tao infobase trong. Chay dump.cmd de xuat cau hinh ra src\cf.
