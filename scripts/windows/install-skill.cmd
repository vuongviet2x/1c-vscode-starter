@echo off
rem Cai skill 1c-dev-mentor-student vao .claude\skills cua du an.
rem Cach dung:  install-skill.cmd <duong-dan-file-zip-giang-vien-gui>
rem Vi du:      install-skill.cmd "%USERPROFILE%\Downloads\1c-dev-mentor-student-claude-gpt.zip"
setlocal
if "%~1"=="" (
  echo Cach dung: install-skill.cmd ^<duong-dan-file-zip^>
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-skill.ps1" -Zip "%~f1"
exit /b %ERRORLEVEL%
