# 1. Define Variables
$Url = "https://i.ibb.co/k26M4jsK/DWP-Buraya-Bakarlar-Tu-e.png"
$DestDir = "C:\Me\Library\Pictures\Wallpapers"
$FileName = "DWP-Buraya-Bakarlar-Tuce.png"
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