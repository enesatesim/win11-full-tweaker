@echo off
setlocal enabledelayedexpansion

echo Downloading Win11 Full Tweaker...

set "ZIP_FILE=%TEMP%\StarterPack.zip"
set "EXTRACT_DIR=%TEMP%\StarterPack"

rem Download the repository
powershell.exe -NoProfile -Command "Invoke-RestMethod -Uri 'https://github.com/enesatesim/win11-full-tweaker/archive/refs/heads/main.zip' -OutFile '%ZIP_FILE%'"

rem Extract the ZIP file
powershell.exe -NoProfile -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%EXTRACT_DIR%' -Force"

rem Run the master script
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%EXTRACT_DIR%\win11-full-tweaker-main\master.ps1"

exit /b %errorlevel%
