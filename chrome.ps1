# Path to the Chrome Preferences file
$preferencesPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Preferences"

# Load the JSON content of the Preferences file
$json = Get-Content $preferencesPath -Raw | ConvertFrom-Json

# Set Chrome to open specific pages on startup (change startup preference)
$json.browser.on_startup = 4  # 4 means open specific pages

# Add the desired page to startup URLs
$startupUrl = "chrome://settings/help"

# Check if startup URLs already exists, otherwise create an empty array
if (-not $json.session.startup_urls) {
    $json.session.startup_urls = @()
}

# Add the chrome://settings/help page if it doesn't exist
if (-not ($json.session.startup_urls -contains $startupUrl)) {
    $json.session.startup_urls += $startupUrl
}

# Save the updated JSON back to the Preferences file
$json | ConvertTo-Json -Compress | Set-Content $preferencesPath