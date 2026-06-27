# Set "Turn my screen off after" to Never (0 seconds) for AC power
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0

# Set "Make my device sleep after" to Never (0 seconds) for AC power
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0

# Set "Turn my screen off after" to 5 minutes (300 seconds) for DC power
powercfg /setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 300

# Set "Make my device sleep after" to 5 minutes (300 seconds) for DC power
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 300