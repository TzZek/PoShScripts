# Get the list of hostnames from a text file. One hostname per line.
$hostnames = Get-Content "C:\path\to\your\file.txt"

# Set the throttle limit for maximum number of simultaneous connections. Adjust based on your requirements.
$throttleLimit = 10

# Loop through each hostname.
$hostnames | ForEach-Object -Parallel {
    # Get the current hostname.
    $hostname = $_

    # Try to run the commands on the remote computer.
    try {
        # Use Invoke-Command to run the command on the remote computer.
        Invoke-Command -ComputerName $hostname -ScriptBlck {
            # Run gpupdate and force it.
            Invoke-Expression "gpupdate /force"

            # Give gpupdate some time to complete.
            Start-Sleep -Seconds 60

            # Restart the computer.
            Restart-Computer -Force
        } -ErrorAction Stop
    }
    catch {
        # If there was an error, write it to the console.
        Write-Error "Failed to update and restart $hostname: $_"
    }
} -ThrottleLimit $throttleLimit