# Function to update Chrome preferences for a given user
function Update-ChromeStartupURLs {
    param (
        [string]$userProfile
    )

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

        # Set the startup URLs to the desired value (note: chrome:// URLs will not work)
        $preferencesContent.session.startup_urls = @("https://www.example.com") # Replace with a valid URL

        # Convert the JSON back and save the updated content
        $preferencesContent | ConvertTo-Json -Compress | Set-Content $preferencesPath

        Write-Host "Updated Chrome Preferences for user profile: $userProfile"
    } else {
        Write-Host "Chrome Preferences file not found for user profile: $userProfile"
    }
}

# Get all user profiles on the system
$userProfiles = Get-ChildItem "C:\Users" | Where-Object { Test-Path "$($_.FullName)\AppData\Local\Google\Chrome\User Data\Default\Preferences" }

# Loop through each user profile and update the Chrome Preferences
foreach ($profile in $userProfiles) {
    Update-ChromeStartupURLs -userProfile $profile.FullName
}