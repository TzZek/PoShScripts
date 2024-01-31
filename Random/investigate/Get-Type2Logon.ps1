# Query the Event Viewer for events with ID 4624 and Logon Type 2 (Interactive Logon)
$results = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624} | Where-Object {
    # Access the event properties directly
    $_.Properties[8].Value -eq 2
} | ForEach-Object {
    # Access the event properties directly
    $properties = $_.Properties

    # Create a custom object to hold the event details
    [PSCustomObject]@{
        TimeCreated = $_.TimeCreated
        AccountName = $properties[5].Value # The user account that logged on
        AccountDomain = $properties[6].Value # The domain of the user account
        LogonType = $properties[8].Value # The logon type (should be 2 for Interactive)
        WorkstationName = $properties[13].Value # The name of the workstation from which the logon was initiated
        NetworkAddress = $properties[18].Value # The network address from which the logon was initiated
    }
}

# Output the results
$results | Format-Table -AutoSize | Out-String -Width 4096

# Optionally, you can export results to a file
# $results | Export-Csv -Path "C:\Logs\InteractiveLogonEvents.csv" -NoTypeInformation
