# Import hostnames from file
$hostnames = Get-Content -Path 'hostnames.txt'

# Specify the user profile to check
$userProfile = "\Users\username"

# Prepare the output file
$outputFile = "output.txt"

# Clear the output file if it exists
if (Test-Path $outputFile)
{
    Clear-Content $outputFile
}

foreach ($hostname in $hostnames)
{
    Write-Host "Checking $hostname..."

    # Test for remote connection availability
    if (Test-Connection -ComputerName $hostname -Quiet -Count 1)
    {
        # Get IP address of hostname
        $ipAddress = [System.Net.Dns]::GetHostAddresses($hostname) | 
                     Where-Object { $_.AddressFamily -eq 'InterNetwork' } | 
                     Select-Object -ExpandProperty IPAddressToString -First 1

        # Test for user profile existence
        try
        {
            $userProfilePath = "\\$hostname\$userProfile"
            $userProfilePath = $userProfilePath.Replace('\', '\\')

            $scriptBlock = [ScriptBlock]::Create("
                if (Test-Path -Path '$userProfilePath') {
                    '$hostname | $ipAddress' | Out-File -Append -FilePath '$outputFile'
                }
            ")

            Invoke-Command -ComputerName $hostname -ScriptBlock $scriptBlock
        }
        catch
        {
            Write-Host "Failed to check $hostname. Error: $_"
        }
    }
    else
    {
        Write-Host "$hostname is not reachable."
    }
}
