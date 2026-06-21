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
    "MicrosoftCorporationII.QuickAssist"
)

foreach ($app in $bloatware) {
    Write-Host "Removing $app..." -ForegroundColor Red
    Get-AppxPackage -Name "*$app*" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
}