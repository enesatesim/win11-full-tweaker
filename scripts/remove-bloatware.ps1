$bloatware = @(
    "Microsoft.Todos",
    "Microsoft.WindowsFeedbackHub",
    "Clipchamp.Clipchamp"
)

foreach ($app in $bloatware) {
    Write-Host "Removing $app..."
    Get-AppxPackage -Name "*$app*" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
}