$favWingetApps = @(
    "Brave.Brave",
    "M2Team.NanaZip",
    "AntibodySoftware.WizTree",
    "AutoHotkey.AutoHotkey",
    "Tonec.InternetDownloadManager",
    "MartiCliment.UniGetUI",
    "RamenSoftware.Windhawk",
    "voidtools.Everything.Alpha",
    "xanderfrangos.twinkletray",
    "Nilesoft.Shell"
)

$favMSStoreApps = @(
    "9PFXXSHC64H3"
)

foreach ($app in $favWingetApps) {
    Write-Host "Installing $app..." -ForegroundColor Green

    winget.exe install `
        --id "$app" `
        --exact `
        --source winget `
        --accept-source-agreements `
        --disable-interactivity `
        --silent `
        --accept-package-agreements `
        --force
}

foreach ($app in $favMSStoreApps) {
    Write-Host "Installing $app..." -ForegroundColor Green

    winget.exe install `
        --id "$app" `
        --exact `
        --source winget `
        --accept-source-agreements `
        --disable-interactivity `
        --silent `
        --accept-package-agreements `
        --force
}
