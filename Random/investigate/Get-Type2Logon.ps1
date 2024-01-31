# Define the script block to query the Event Viewer for events with ID 4624 and Logon Type 2
$scriptBlock = {
    # Query the Event Viewer for events with ID 4624
    Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624} | Where-Object {
        # Convert the event to XML to access the event data
        $eventXml = [xml]$_
        $eventDetail = $eventXml.Event.EventData.Data

        # Filter for Interactive logons (Logon Type 2)
        $eventDetail[8].'#text' -eq '2'
    } | ForEach-Object {
        # Extract and display the necessary information from each event
        $eventXml = [xml]$_
        $eventDetail = $eventXml.Event.EventData.Data

        # Create a custom object to hold the event details
        [PSCustomObject]@{
            TimeCreated = $_.TimeCreated
            AccountName = $eventDetail[5].'#text' # The user account that logged on
            AccountDomain = $eventDetail[6].'#text' # The domain of the user account
            LogonType = $eventDetail[8].'#text' # The logon type (should be 2 for Interactive)
            WorkstationName = $eventDetail[13].'#text' # The name of the workstation from which the logon was initiated
            NetworkAddress = $eventDetail[18].'#text' # The network address from which the logon was initiated
        }
    }
}

try {
    # Run the script block and capture the results
    $results = & $scriptBlock

    # Output the results
    $results | Format-Table -AutoSize | Out-String -Width 4096
    
    # Optionally, you can export results to a file
    # $results | Export-Csv -Path "C:\Logs\InteractiveLogonEvents.csv" -NoTypeInformation
} catch {
    Write-Error "Failed to retrieve Interactive logon events. Error: $_"
}
