# Function to update Chrome startup URLs for a given user profile
function Update-ChromeStartupURLs {
    param (
        [string]$userProfile  # The user's profile directory
    )

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
            # Add the URL explicitly as a string
            $preferencesContent.session.startup_urls += @([string]$newStartupUrl)
            Write-Host "Added new URL to startup pages for $userProfile: $newStartupUrl"
        } else {
            Write-Host "The URL is already present in the startup pages for $userProfile."
        }

        # Convert the JSON back and save the updated content with proper formatting
        $jsonContent = $preferencesContent | ConvertTo-Json -Compress -Depth 10

        # Ensure the text formatting is correct, including double-quotes around the URL
        $jsonContent = $jsonContent -replace '"chrome://settings/onStartup"', '"chrome://settings/onStartup"'

        # Save the updated content back to the Preferences file
        Set-Content -Path $preferencesPath -Value $jsonContent

        Write-Host "Updated Chrome Preferences for the user: $userProfile"
    } else {
        Write-Host "Chrome Preferences file not found for user profile: $userProfile"
    }
}

# Get all user profiles on the system (excluding system profiles)
$userProfiles = Get-ChildItem "C:\Users" | Where-Object {
    ($_ -notmatch "Public|Default|Default User|All Users") -and (Test-Path "$($_.FullName)\AppData\Local\Google\Chrome\User Data\Default\Preferences")
}

# Loop through each user profile and update the Chrome Preferences
foreach ($profile in $userProfiles) {
    $profilePath = $profile.FullName
    Update-ChromeStartupURLs -userProfile $profilePath
}