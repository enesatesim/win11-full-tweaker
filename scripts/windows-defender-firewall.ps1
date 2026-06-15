# Matrix of applications and their paths (Notice the commas at the start of each line)
# 1. Define the matrix using {0} where you want the program name to appear
$rawMatrix = @(
    , @("Acrobat"       , "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\{0}.exe")
    , @("After Effects" , "%ProgramFiles%\Adobe\Adobe {0} 2026\Support Files\AfterFX.exe") # Outlier naming from Adobe
    , @("Illustrator"   , "%ProgramFiles%\Adobe\Adobe {0} 2026\Support Files\Contents\Windows\{0}.exe")
    , @("InDesign"      , "%ProgramFiles%\Adobe\Adobe {0} 2026\{0}.exe")
    , @("Photoshop"     , "%ProgramFiles%\Adobe\Adobe {0} 2026\{0}.exe")
    , @("Premiere Pro"  , "%ProgramFiles%\Adobe\Adobe {0} 2026\Adobe {0}.exe")
    , @("Media Encoder" , "%ProgramFiles%\Adobe\Adobe {0} 2026\Adobe {0}.exe")
)

# Loop through each item in the matrix
foreach ($app in $rawMatrix) {
    $appName = $app[0]
    $appPath = $app[1]

    # Block the application using Windows Defender Firewall
    New-NetFirewallRule `
        -DisplayName "Block Adobe $appName Internet Access" `
        -Direction Outbound `
        -Program $appPath `
        -Action Block
}