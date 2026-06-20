$regDir = Join-Path -Path $PSScriptRoot -ChildPath "..\reg-files"
if (-not (Test-Path $regDir)) {
	Write-Error "Reg files directory not found: $regDir"
	exit 1
}

Get-ChildItem -Path $regDir -Filter *.reg -File | Sort-Object Name | ForEach-Object {
	Write-Output "Importing registry file: $($_.FullName)"
	reg import $_.FullName
}



# Disables Microsoft Store search suggestions in the start menu for all users by denying access to the Store app database file for each user
function DisableStoreSearchSuggestionsForAllUsers {
    # Get path to Store app database for all users
    $userPathString = GetUserDirectory -userName "*" -fileName "AppData\Local\Packages"
    $usersStoreDbPaths = Get-ChildItem -Path $userPathString -ErrorAction SilentlyContinue

    # Go through all users and disable start search suggestions
    ForEach ($storeDbPath in $usersStoreDbPaths) {
        DisableStoreSearchSuggestions ($storeDbPath.FullName + "\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\store.db")
    }

    # Also disable start search suggestions for the default user profile
    $defaultStoreDbPath = GetUserDirectory -userName "Default" -fileName "AppData\Local\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\store.db" -exitIfPathNotFound $false
    DisableStoreSearchSuggestions $defaultStoreDbPath
}