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
& "$scriptsDir\remove-bloatware.ps1"
& "$scriptsDir\disable-startup-apps.ps1"
& "$scriptsDir\registry-tweaks.ps1"
& "$scriptsDir\set-desktop-wallpaper.ps1"
& "$scriptsDir\windows-defender-firewall.ps1"
& "$scriptsDir\install-apps.ps1"
& "$scriptsDir\power-config.ps1"

# Restart Windows Explorer to apply changes
Write-Host "Restarting Windows Explorer to apply changes..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force

function Write-Rainbow {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Text
    )

    # Define our rainbow color palette using built-in console colors
    $Colors = @('Red', 'DarkYellow', 'Yellow', 'Green', 'Cyan', 'Blue', 'Magenta')
    
    # Loop through each character in the string
    for ($i = 0; $i -lt $Text.Length; $i++) {
        # Use the modulo operator (%) to cycle through the colors infinitely
        $CurrentColor = $Colors[$i % $Colors.Count]
        
        # Print the single character without moving to the next line
        Write-Host $Text[$i] -NoNewline -ForegroundColor $CurrentColor
    }
    
    # Add a final line break at the very end
    Write-Host ""
}

& "$scriptsDir\outro.ps1"