# Matrix of applications and their paths
$matrix = @(
    @("Acrobat"     , "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\Acrobat.exe")
    @("Illustrator" , "%ProgramFiles%\Adobe\Adobe Illustrator 2026\Support Files\Contents\Windows\Illustrator.exe")
    @("Photoshop"   , "%ProgramFiles%\Adobe\Adobe Photoshop 2026\Photoshop.exe")
)

# Loop through each item in the matrix
foreach ($app in $matrix) {
    $appName = $app[0]
    $appPath = $app[1]

    # Block the application using Windows Defender Firewall
    New-NetFirewallRule `
        -DisplayName "Block Adobe $appName" `
        -Direction Outbound `
        -Program $appPath `
        -Action Block
}