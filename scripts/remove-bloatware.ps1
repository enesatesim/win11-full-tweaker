$bloatware = @(
    "Clipchamp.Clipchamp",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.Todos",
    "Microsoft.PowerAutomateDesktop",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.BingNews",
    "Microsoft.BingSearch",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.Microsoft.BingWeather",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.YourPhone",
    "Microsoft.Windows.DevHome",
    "Microsoft.GamingApp",
    "Microsoft.XboxGamingOverlay",
    "MicrosoftCorporationII.QuickAssist"
)

foreach ($app in $bloatware) {
    Write-Host "[Removing] " -ForegroundColor Red -NoNewline
    Write-Host "$app"
    Get-AppxPackage -Name "*$app*" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
}