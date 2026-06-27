# Get the current year dynamically
$currentYear = (Get-Date).Year

# Generate an array of years from (Current Year - 2) to (Current Year + 2)
# Example: If it's 2026, this creates @(2025, 2026, 2027)
$years = ($currentYear - 1)..($currentYear + 1)

# Matrix of applications and their paths using {YEAR} as a placeholder
$matrix = @(
    , @("Acrobat"       , "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\Acrobat.exe")
    , @("After Effects" , "%ProgramFiles%\Adobe\Adobe After Effects {YEAR}\Support Files\AfterFX.exe")
    , @("Illustrator"   , "%ProgramFiles%\Adobe\Adobe Illustrator {YEAR}\Support Files\Contents\Windows\Illustrator.exe")
    , @("InDesign"      , "%ProgramFiles%\Adobe\Adobe InDesign {YEAR}\InDesign.exe")
    , @("Photoshop"     , "%ProgramFiles%\Adobe\Adobe Photoshop {YEAR}\Photoshop.exe")
    , @("Premiere Pro"  , "%ProgramFiles%\Adobe\Adobe Premiere Pro {YEAR}\Adobe Premiere Pro.exe")
    , @("Media Encoder" , "%ProgramFiles%\Adobe\Adobe Media Encoder {YEAR}\Adobe Media Encoder.exe")
)

# Loop through each item in the matrix
foreach ($app in $matrix) {
    $appName = $app[0]
    $appPath = $app[1]

    # Check if the path requires versioning
    if ($appPath -match "{YEAR}") {
        # Create a rule for each year
        foreach ($year in $years) {
            $versionedPath = $appPath -replace "{YEAR}", $year
            $ruleName = "Block Internet Access - Adobe $appName $year"

            New-NetFirewallRule `
                -DisplayName $ruleName `
                -Direction Outbound `
                -Program $versionedPath `
                -Action Block `
                -ErrorAction SilentlyContinue | Out-Null
            
            Write-Host "[Block Internet Access] " -ForegroundColor Red -NoNewline
            Write-Host "Adobe $appName $year"
        }
    }
    else {
        # Create a single rule for non-versioned apps (e.g., Acrobat)
        $ruleName = "Block Internet Access - Adobe $appName"

        New-NetFirewallRule `
            -DisplayName $ruleName `
            -Direction Outbound `
            -Program $appPath `
            -Action Block `
            -ErrorAction SilentlyContinue | Out-Null
        
        Write-Host "[Block Internet Access] Adobe $appName"
    }
}