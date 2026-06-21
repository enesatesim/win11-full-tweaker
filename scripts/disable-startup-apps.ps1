Write-Host "[Disabling Startup App] " -ForegroundColor Yellow -NoNewline
Write-Host "Microsoft Edge Auto Launch"
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "MicrosoftEdgeAutoLaunch*"

Write-Host "[Disabling Startup App] " -ForegroundColor Yellow -NoNewline
Write-Host "OneDrive Setup"
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "OneDriveSetup"