$favApps = @(
    "voidtools.Everything.Alpha",
    "M2Team.NanaZip",
    "Nilesoft.Shell",
    "RamenSoftware.Windhawk",
    "AutoHotkey.AutoHotkey"
)

Write-Host "Queueing applications for installation..." -ForegroundColor Cyan

# Start all installations simultaneously as background jobs
$jobs = foreach ($app in $favApps) {
    Start-Job -ScriptBlock {
        param($appName)
        winget.exe install --id "$appName" --exact `
            --source winget `
            --accept-source-agreements `
            --disable-interactivity `
            --silent `
            --accept-package-agreements `
            --force
    } -ArgumentList $app
}

# Wait for all jobs to complete 
Wait-Job -Job $jobs | Out-Null

# Output the results of the jobs to the console
Receive-Job -Job $jobs

# Clean up the jobs from memory
Remove-Job -Job $jobs

Write-Host "All applications processed!" -ForegroundColor Green