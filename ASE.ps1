# Check for Administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires Administrator rights. Requesting elevation..."
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

Write-Host "Running as Administrator. Proceeding with Setup..." -ForegroundColor Green


Write-Host "Removing bloatware..." -ForegroundColor Cyan

$bloatware = @(
    "Microsoft.Todos",
    "Microsoft.WindowsFeedbackHub",
    "Clipchamp.Clipchamp"
)

foreach ($app in $bloatware) {
    Write-Host "Removing $app..."
    Get-AppxPackage -Name "*$app*" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
}


Write-Host "Applying system tweaks..." -ForegroundColor Cyan

# Show file extensions in Explorer
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# Align the Start Menu to the Left (Windows 10 style)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0

# Hide the annoying "Search Highlights" in the search box
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 1

# Restart Windows Explorer to apply changes
Stop-Process -Name explorer -Force




Write-Host "Downloading and setting custom wallpaper..." -ForegroundColor Cyan

# 1. Define the direct Google Drive URL and where to save the image
$url = "https://drive.google.com/uc?export=download&id=1HYunfpyfvZVEW7Faii_GsqnX_L6AyW7x"
$picturePath = "$env:USERPROFILE\Pictures\CustomWallpaper.jpg"

# 2. Download the image
Invoke-WebRequest -Uri $url -OutFile $picturePath -UseBasicParsing

# 3. Create a small C# tool to tap into the Windows API
$setWallpaperCode = @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

    public static void Set(string path) {
        // 20 is the action code to set the desktop wallpaper, 3 forces the update to save
        SystemParametersInfo(20, 0, path, 3);
    }
}
"@

# 4. Load the tool and apply the wallpaper
Add-Type -TypeDefinition $setWallpaperCode
[Wallpaper]::Set($picturePath)

Write-Host "Wallpaper updated successfully!" -ForegroundColor Green
pause