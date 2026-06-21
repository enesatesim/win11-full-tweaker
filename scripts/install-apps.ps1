$favApps = @(
    "voidtools.Everything.Alpha",
    "M2Team.NanaZip",
    "AntibodySoftware.WizTree",
    "Voidstar.FilePilot"
)

foreach ($app in $favApps) {
    Write-Host "Installing $app..." -ForegroundColor Green
    winget.exe install --id "$app" --exact `
        --source winget `
        --accept-source-agreements `
        --disable-interactivity `
        --silent `
        --accept-package-agreements `
        --force
}
