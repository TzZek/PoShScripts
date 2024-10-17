# Function to update Chrome startup URLs for the current user
function Update-ChromeStartupURLs {
    # Get the current user's profile path
    $userProfile = [System.Environment]::GetFolderPath('UserProfile')

    # Path to the Chrome Preferences file for the current user
    $preferencesPath = "$userProfile\AppData\Local\Google\Chrome\User Data\Default\Preferences"

    # The URL we want to add (ensure it's treated as a string)
    $newStartupUrl = "chrome://settings/onStartup"

    # Check if Preferences file exists
    if (Test-Path $preferencesPath) {
        # Read the Preferences file content
        $preferencesContent = Get-Content $preferencesPath -Raw | ConvertFrom-Json

        # Ensure the session section exists, if not create it
        if (-not $preferencesContent.PSObject.Properties["session"]) {
            $preferencesContent | Add-Member -MemberType NoteProperty -Name "session" -Value @{ startup_urls = @() }
        }

        # Ensure the startup_urls array exists in the session object
        if (-not $preferencesContent.session.PSObject.Properties["startup_urls"]) {
            $preferencesContent.session | Add-Member -MemberType NoteProperty -Name "startup_urls" -Value @()
        }

        # Check if the URL is already in the list, and add it if not present
        if (-not ($preferencesContent.session.startup_urls -contains $newStartupUrl)) {
            # Add the URL as a string to the startup_urls array
            $preferencesContent.session.startup_urls += [string]$newStartupUrl
            Write-Host "Added new URL to startup pages: $newStartupUrl"
        } else {
            Write-Host "The URL is already present in the startup pages."
        }

        # Convert the JSON back and save the updated content with increased depth for serialization
        $preferencesContent | ConvertTo-Json -Compress -Depth 10 | Set-Content $preferencesPath

        Write-Host "Updated Chrome Preferences for the current user."
    } else {
        Write-Host "Chrome Preferences file not found for the current user."
    }
}

# Call the function to update the Chrome Preferences for the current user
Update-ChromeStartupURLs