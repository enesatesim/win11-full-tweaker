$favApps = @(
    "voidtools.Everything.Alpha",
    "M2Team.NanaZip",
    "Nilesoft.Shell",
    "RamenSoftware.Windhawk",
    "AutoHotkey.AutoHotkey"
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
