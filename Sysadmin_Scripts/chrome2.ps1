# Function to update Chrome startup URLs for the current user
function Update-ChromeStartupURLs {
    # Get the current user's profile path
    $userProfile = [System.Environment]::GetFolderPath('UserProfile')

    # Path to the Chrome Preferences file for the current user
    $preferencesPath = "$userProfile\AppData\Local\Google\Chrome\User Data\Default\Preferences"

    # Check if Preferences file exists
    if (Test-Path $preferencesPath) {
        # Read the Preferences file content
        $preferencesContent = Get-Content $preferencesPath -Raw | ConvertFrom-Json

        # Ensure the session section exists
        if (-not $preferencesContent.session) {
            $preferencesContent.session = @{}
        }

        # Set the startup URLs to the desired value (replace with a valid URL)
        $preferencesContent.session.startup_urls = @("https://www.example.com") # Replace with your desired URL

        # Convert the JSON back and save the updated content with increased depth for serialization
        $preferencesContent | ConvertTo-Json -Compress -Depth 10 | Set-Content $preferencesPath

        Write-Host "Updated Chrome Preferences for the current user."
    } else {
        Write-Host "Chrome Preferences file not found for the current user."
    }
}

# Call the function to update the Chrome Preferences for the current user
Update-ChromeStartupURLs