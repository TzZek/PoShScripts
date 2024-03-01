# Define the computer name or IP address
$computer = 'YourComputerName' # Replace with your actual computer name or IP

# Define the script block to execute on the remote computer
$scriptBlock = {
    # Query the Event Viewer for events with ID 4624 (4624 logon - 4647 logout)
    Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624}
}

try {
    # Use Invoke-Command to run the script block on the remote computer
    $results = Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock

    # Output the results
    $results | Format-Table -AutoSize | Out-String -Width 4096
    
    # Optionally, you can export results to a file
    # $results | Export-Csv -Path "C:\Logs\EventLog_$computer.csv" -NoTypeInformation
} catch {
    Write-Error "Failed to retrieve logs from $computer. Error: $_"
}
