@echo off
rem Launch setup.ps1 with PowerShell ExecutionPolicy Bypass.
set "SCRIPT_DIR=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%setup.ps1" %*
exit /b %errorlevel%
