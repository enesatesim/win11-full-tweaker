# Check for Administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires Administrator rights. Requesting elevation..."
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

Write-Host "Running as Administrator. Proceeding with Setup..." -ForegroundColor Green

# Get the directory
$rootDir = $PSScriptRoot
$scriptsDir = "$rootDir\scripts"

# Execute the local child scripts
# & "$scriptsDir\remove-bloatware.ps1"
& "$scriptsDir\registry-tweaks.ps1"
& "$scriptsDir\set-desktop-wallpaper.ps1"
# & "$scriptsDir\windows-defender-firewall.ps1"
# & "$scriptsDir\install-apps.ps1"

# Restart Windows Explorer to apply changes
Write-Host "Restarting Windows Explorer to apply changes..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force

Write-Host "Setup completed successfully!" -ForegroundColor Green