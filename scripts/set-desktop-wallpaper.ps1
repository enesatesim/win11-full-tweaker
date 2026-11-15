# 1. Define Variables
$Url = "https://i.ibb.co/6RkwW0br/bliss-win11-dark-16x9.png"
$DestDir = "C:\Me\Library\Pictures\Wallpapers"
$FileName = "bliss-win11-dark-16x9.png"
$DestPath = Join-Path -Path $DestDir -ChildPath $FileName

# 2. Create the target directory if it doesn't exist
if (-not (Test-Path -Path $DestDir)) {
    Write-Host "Creating directory: $DestDir" -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
}

# 3. Download the image
Write-Host "Downloading image..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $Url -OutFile $DestPath
Write-Host "Download complete: $DestPath" -ForegroundColor Green

# 4. Define the C# class to call the Windows API (user32.dll)
$csharpSignature = @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    public const int SPI_SETDESKWALLPAPER = 20;
    public const int SPIF_UPDATEINIFILE = 0x01;
    public const int SPIF_SENDWININICHANGE = 0x02;

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# Load the C# class into the PowerShell session
Add-Type -TypeDefinition $csharpSignature -ErrorAction SilentlyContinue

# 5. Set the wallpaper
Write-Host "Setting wallpaper..." -ForegroundColor Cyan
$flags = [Wallpaper]::SPIF_UPDATEINIFILE -bor [Wallpaper]::SPIF_SENDWININICHANGE
[Wallpaper]::SystemParametersInfo([Wallpaper]::SPI_SETDESKWALLPAPER, 0, $DestPath, $flags) | Out-Null

Write-Host "Wallpaper updated successfully!" -ForegroundColor Green

# 6. Set the lock screen wallpaper (Settings > Personalisation > Lock screen)
Write-Host "Setting lock screen wallpaper..." -ForegroundColor Cyan

$cdmPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
if (-not (Test-Path -Path $cdmPath)) {
    New-Item -Path $cdmPath -Force | Out-Null
}
Set-ItemProperty -Path $cdmPath -Name "RotatingLockScreenEnabled" -Value 0 -Type DWord

$lockScreenRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lock Screen"
if (Test-Path -Path $lockScreenRegPath) {
    Set-ItemProperty -Path $lockScreenRegPath -Name "SlideshowEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
}

[Windows.System.UserProfile.LockScreen, Windows.System.UserProfile, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
Add-Type -AssemblyName System.Runtime.WindowsRuntime

$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
    $_.Name -eq 'AsTask' -and
    $_.GetParameters().Count -eq 1 -and
    $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1'
})[0]

$asTaskAction = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
    $_.Name -eq 'AsTask' -and
    $_.GetParameters().Count -eq 1 -and
    -not $_.IsGenericMethod
})[0]

$getFileTask = $asTaskGeneric.MakeGenericMethod([Windows.Storage.StorageFile]).Invoke(
    $null,
    @([Windows.Storage.StorageFile]::GetFileFromPathAsync($DestPath))
)
$getFileTask.Wait(-1) | Out-Null
$storageFile = $getFileTask.Result

$setImageTask = $asTaskAction.Invoke(
    $null,
    @([Windows.System.UserProfile.LockScreen]::SetImageFileAsync($storageFile))
)
$setImageTask.Wait(-1) | Out-Null

Write-Host "Lock screen wallpaper updated successfully!" -ForegroundColor Green