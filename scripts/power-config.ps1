# Set "Turn my screen off after" to Never (0 seconds) for AC power
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0
Write-Host "[Set] " -ForegroundColor Green -NoNewline
Write-Host "Never turn my screen off when on AC power."

# Set "Make my device sleep after" to Never (0 seconds) for AC power
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
Write-Host "[Set] " -ForegroundColor Green -NoNewline
Write-Host "Never make my device sleep when on AC power."

# Set "Turn my screen off after" to 5 minutes (300 seconds) for DC power
powercfg /setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 300
Write-Host "[Set] " -ForegroundColor Green -NoNewline
Write-Host "Turn my screen off after 5 minutes when on DC power."

# Set "Make my device sleep after" to 5 minutes (300 seconds) for DC power
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 300
Write-Host "[Set] " -ForegroundColor Green -NoNewline
Write-Host "Make my device sleep after 5 minutes when on DC power."