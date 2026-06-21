function Write-Rainbow {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Text
    )

    # Define our rainbow color palette using built-in console colors
    $Colors = @('Red', 'DarkYellow', 'Yellow', 'Green', 'Cyan', 'Blue', 'Magenta')
    
    # Loop through each character in the string
    for ($i = 0; $i -lt $Text.Length; $i++) {
        # Use the modulo operator (%) to cycle through the colors infinitely
        $CurrentColor = $Colors[$i % $Colors.Count]
        
        # Print the single character without moving to the next line
        Write-Host $Text[$i] -NoNewline -ForegroundColor $CurrentColor
    }
    
    # Add a final line break at the very end
    Write-Host ""
}