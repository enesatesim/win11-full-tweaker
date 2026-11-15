# Check for Administrator privileges (required for HKLM and Public\AccountPictures)
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires Administrator rights. Requesting elevation..."
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# 1. Define Variables
$Url = "https://i.ibb.co/tPBjMjGv/ema-pp-default-fastupload.jpg"
$DestDir = "C:\Me\Library\Pictures\ProfilePictures"
$FileName = "ema-pp-default-fastupload.jpg"
$DestPath = Join-Path -Path $DestDir -ChildPath $FileName

# 2. Create the target directory if it doesn't exist
if (-not (Test-Path -Path $DestDir)) {
    Write-Host "Creating directory: $DestDir" -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
}

# 3. Download the image
Write-Host "Downloading profile picture..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $Url -OutFile $DestPath
Write-Host "Download complete: $DestPath" -ForegroundColor Green

# 4. Prepare Windows AccountPictures folder and Registry key for current user SID
$Sid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$AccountPicturesDir = "C:\Users\Public\AccountPictures\$Sid"
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AccountPicture\Users\$Sid"

if (-not (Test-Path -Path $AccountPicturesDir)) {
    New-Item -ItemType Directory -Path $AccountPicturesDir | Out-Null
}
(Get-Item -Path $AccountPicturesDir -Force).Attributes = "Directory, Hidden"

if (-not (Test-Path -Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# 5. Resize image into all required Windows 11 account picture dimensions and register paths
Write-Host "Setting profile picture..." -ForegroundColor Cyan
Add-Type -AssemblyName System.Drawing

$Sizes = @(32, 40, 48, 64, 96, 192, 200, 240, 424, 448, 1080)
$img = $null

try {
    $img = [System.Drawing.Image]::FromFile($DestPath)

    foreach ($s in $Sizes) {
        $bmp = $null
        $g = $null
        try {
            $bmp = New-Object System.Drawing.Bitmap($s, $s)
            $g = [System.Drawing.Graphics]::FromImage($bmp)
            $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
            $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
            $g.DrawImage($img, 0, 0, $s, $s)

            $ImagePath = Join-Path -Path $AccountPicturesDir -ChildPath "Image$s.jpg"
            $bmp.Save($ImagePath, [System.Drawing.Imaging.ImageFormat]::Jpeg)

            Set-ItemProperty -Path $RegPath -Name "Image$s" -Value $ImagePath -Type String -Force
        }
        finally {
            if ($null -ne $g) { $g.Dispose() }
            if ($null -ne $bmp) { $bmp.Dispose() }
        }
    }
}
finally {
    if ($null -ne $img) { $img.Dispose() }
}

Write-Host "Profile picture updated successfully!" -ForegroundColor Green
