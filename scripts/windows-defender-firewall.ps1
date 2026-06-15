# 1. Define the matrix using {0} where you want the program name to appear
$rawMatrix = @(
    , @("Acrobat"       , "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\{0}.exe")
    , @("After Effects" , "%ProgramFiles%\Adobe\Adobe After Effects 2026\Support Files\AfterFX.exe") # No {0} needed here
    , @("Illustrator"   , "%ProgramFiles%\Adobe\Adobe {0} 2026\Support Files\Contents\Windows\{0}.exe")
    , @("InDesign"      , "%ProgramFiles%\Adobe\Adobe {0} 2026\{0}.exe")
    , @("Photoshop"     , "%ProgramFiles%\Adobe\Adobe {0} 2026\{0}.exe")
    , @("Premiere Pro"  , "%ProgramFiles%\Adobe\Adobe {0} 2026\Adobe {0}.exe")
    , @("Media Encoder" , "%ProgramFiles%\Adobe\Adobe {0} 2026\Adobe {0}.exe")
)

# 2. Process the matrix to inject the names into the paths
$matrix = foreach ($row in $rawMatrix) {
    $name = $row[0]
    $path = $row[1] -f $name 
    
    # Return the updated pair back to the new $matrix
    , @($name, $path)
}

# Loop through each item in the matrix
foreach ($app in $matrix) {
    $appName = $app[0]
    $appPath = $app[1]

    # Block the application using Windows Defender Firewall
    New-NetFirewallRule `
        -DisplayName "Block Adobe $appName Internet Access" `
        -Direction Outbound `
        -Program $appPath `
        -Action Block
}