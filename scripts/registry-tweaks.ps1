$regDir = Join-Path -Path $PSScriptRoot -ChildPath "..\reg-files"
if (-not (Test-Path $regDir)) {
    Write-Error "Reg files directory not found: $regDir"
    exit 1
}

Get-ChildItem -Path $regDir -Filter *.reg -File | Sort-Object Name | ForEach-Object {
    # 1. Fallback description in case the file has no comments
    $description = $_.Name
    
    # 2. Extract the first line that starts with a semicolon (ignoring leading spaces)
    $firstComment = Get-Content $_.FullName | Where-Object { $_ -match '^\s*;' } | Select-Object -First 1
    
    # 3. Clean up the string (remove the ';' and trim extra spaces)
    if ($firstComment) {
        $description = $firstComment -replace '^\s*;\s*', ''
    }

    # 4. Print the meaningful message without a line break yet
    Write-Host "$description" -NoNewline
    
    # 5. Run the import, suppressing standard output and errors
    $null = reg import $_.FullName 2>&1

    # 6. Check the exit code and print a clean status
    if ($LASTEXITCODE -eq 0) {
        Write-Host " [Success]" -ForegroundColor Green
    } else {
        Write-Host " [Failed]" -ForegroundColor Red
    }
}