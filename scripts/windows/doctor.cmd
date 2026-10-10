@echo off
rem Kiem tra moi truong lam viec: platform, infobase, ma nguon, skill, cong cu.
setlocal
for %%I in ("%~dp0..\..") do set "ROOT=%%~fI"
echo ==== Kiem tra moi truong 1C + VS Code ====
if not exist "%ROOT%\1c.env" (
  copy "%ROOT%\1c.env.example" "%ROOT%\1c.env" >nul
  echo [MOI] Da tao 1c.env tu 1c.env.example. Mo file nay va kiem tra lai.
)
call "%~dp0_env.cmd"
if errorlevel 1 goto :tools
echo [OK]   Platform: %V8_PATH%
if exist "%V8C_PATH%" echo [OK]   Thin client: %V8C_PATH%
if not exist "%V8C_PATH%" echo [CANH BAO] Khong thay 1cv8c.exe - run.cmd se dung 1cv8.exe
if exist "%IB%\1Cv8.1CD" echo [OK]   Infobase: %IB%
if not exist "%IB%\1Cv8.1CD" echo [THIEU] Chua co infobase tai %IB% - chay restore-dt.cmd
if exist "%SRC%\Configuration.xml" echo [OK]   Ma nguon: src\cf
if not exist "%SRC%\Configuration.xml" echo [THIEU] src\cf trong - chay dump.cmd

:tools
if exist "%ROOT%\.claude\skills\1c-dev-mentor-student\SKILL.md" (echo [OK]   Skill 1c-dev-mentor-student da cai) else (echo [THIEU] Chua cai skill - chay install-skill.cmd ^<file-zip^>)
where git >nul 2>&1 && (echo [OK]   Git) || (echo [THIEU] Git - cai tu https://git-scm.com/downloads/win)
where code >nul 2>&1 && (echo [OK]   VS Code) || (echo [CANH BAO] Khong thay lenh 'code' trong PATH)
where claude >nul 2>&1 && (echo [OK]   Claude Code CLI) || (echo [TUY CHON] Chua co Claude Code CLI - extension VS Code van dung duoc)
echo ==========================================
