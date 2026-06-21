# ==============================================================================
# Script: Set-Wallpaper.ps1
# Description: Sets the Windows desktop wallpaper using a relative path.
# ==============================================================================

# 1. Define the relative path to the image
$ImagePath = Join-Path -Path $PSScriptRoot -ChildPath "images\wallpaper.jpg"

# 2. Verify the image file exists before proceeding
if (-Not (Test-Path -Path $ImagePath)) {
    Write-Warning "Wallpaper image not found at: $ImagePath"
    Write-Warning "Please ensure the 'images' folder is in the same directory as this script."
    exit
}

# 3. Define the C# code to interact with the Windows API
$CSharpSignature = @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    // Windows API constants for setting the wallpaper
    public const int SPI_SETDESKWALLPAPER = 20;
    public const int SPIF_UPDATEINIFILE = 0x01;
    public const int SPIF_SENDWININICHANGE = 0x02;

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# 4. Add the C# class to the current PowerShell session
try {
    # Check if the type is already added to prevent errors on multiple runs
    if (-not ([System.Management.Automation.PSTypeName]'Wallpaper').Type) {
        Add-Type -TypeDefinition $CSharpSignature
    }
}
catch {
    Write-Error "Failed to load Windows API class."
    exit
}

# 5. Execute the API call to change the wallpaper
$Result = [Wallpaper]::SystemParametersInfo(
    [Wallpaper]::SPI_SETDESKWALLPAPER, 
    0, 
    $ImagePath, 
    [Wallpaper]::SPIF_UPDATEINIFILE -bor [Wallpaper]::SPIF_SENDWININICHANGE
)

if ($Result) {
    Write-Host "Wallpaper has been updated!" -ForegroundColor Purple
} else {
    Write-Error "Failed to update the wallpaper."
}