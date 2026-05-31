Write-Host "Setting custom wallpaper..." -ForegroundColor Cyan

# 1. Define the relative path and convert it to an absolute path
$relativePath = "images\wallpaper.jpg"
$picturePath = Convert-Path $relativePath

# 2. Create the C# tool to tap into the Windows API
$setWallpaperCode = @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

    public static void Set(string path) {
        // 20 is the action code (SPI_SETDESKWALLPAPER), 3 forces the update to save and broadcast
        SystemParametersInfo(20, 0, path, 3);
    }
}
"@

# 3. Load the tool (only if it hasn't been loaded in this session already)
if (-not ([System.Management.Automation.PSTypeName]'Wallpaper').Type) {
    Add-Type -TypeDefinition $setWallpaperCode
}

# 4. Apply the wallpaper
[Wallpaper]::Set($picturePath)

Write-Host "Wallpaper updated successfully!" -ForegroundColor Green