@echo off
setlocal
powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0Apply-Fix.ps1" -SourcePath "%~1"
set "taskExit=%errorlevel%"
echo.
pause
exit /b %taskExit%
