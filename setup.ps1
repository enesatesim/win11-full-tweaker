Write-Host "Downloading Win11 Full Tweaker..."

# If you need to bypass system execution policy, run setup.bat instead.
# This wrapper launches PowerShell with -ExecutionPolicy Bypass to ensure the script can run.

$zip = "$env:TEMP\StarterPack.zip"
$dir = "$env:TEMP\StarterPack"

# Download and extract the repo locally
irm "https://github.com/enesatesim/win11-full-tweaker/archive/refs/heads/main.zip" -OutFile $zip
Expand-Archive $zip -DestinationPath $dir -Force

# Run your actual master script from the extracted local folder
& "$dir\win11-full-tweaker-main\master.ps1"