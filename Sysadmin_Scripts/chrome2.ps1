# Function to update Chrome startup URLs for the current user
function Update-ChromeStartupURLs {
    # Get the current user's profile path
    $userProfile = [System.Environment]::GetFolderPath('UserProfile')

    # Path to the Chrome Preferences file for the current user
    $preferencesPath = "$userProfile\AppData\Local\Google\Chrome\User Data\Default\Preferences"

    # The URL we want to add
    $newStartupUrl = "https://www.example.com" # Replace with your desired URL

    # Check if Preferences file exists
    if (Test-Path $preferencesPath) {
        # Read the Preferences file content
        $preferencesContent = Get-Content $preferencesPath -Raw | ConvertFrom-Json

        # Ensure the session section exists
        if (-not $preferencesContent.session) {
            $preferencesContent.session = @{}
        }

        # Ensure the startup_urls array exists
        if (-not $preferencesContent.session.startup_urls) {
            $preferencesContent.session.startup_urls = @()
        }

        # Check if the URL is already in the list, and add it if not present
        if (-not ($preferencesContent.session.startup_urls -contains $newStartupUrl)) {
            $preferencesContent.session.startup_urls += $newStartupUrl
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