$regDir = Join-Path -Path $PSScriptRoot -ChildPath "..\reg-files"
if (-not (Test-Path $regDir)) {
	Write-Error "Reg files directory not found: $regDir"
	exit 1
}

Get-ChildItem -Path $regDir -Filter *.reg -File | Sort-Object Name | ForEach-Object {
	Write-Output "Importing registry file: $($_.FullName)"
	reg import $_.FullName
}