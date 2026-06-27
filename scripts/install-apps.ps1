function Install-AppList {
    param(
        [string[]]$Apps,
        [string]$Source = "winget"
    )

    foreach ($app in $Apps) {
        Write-Host "Installing $app..." -ForegroundColor Green

        winget.exe install `
            --id "$app" `
            --exact `
            --source $Source `
            --accept-source-agreements `
            --disable-interactivity `
            --silent `
            --accept-package-agreements `
            --force
    }
}

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

Install-AppList -Apps $favMSStoreApps -Source "msstore"
Install-AppList -Apps $favWingetApps -Source "winget"
