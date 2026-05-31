Write-Host "Downloading and setting custom wallpaper..." -ForegroundColor Cyan

# 1. Define the direct Google Drive URL and where to save the image
$url = "https://drive.google.com/uc?export=download&id=1HYunfpyfvZVEW7Faii_GsqnX_L6AyW7x"
$picturePath = "$env:USERPROFILE\Pictures\Wallpaper\CustomWallpaper.jpg"

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