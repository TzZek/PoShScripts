# Replace "hostname" with the actual hostname
$hostname = "hostname"

# Get the computer object from Active Directory
$computer = Get-ADComputer -Identity $hostname -Properties LastLogonDate

# Get the last logon date for the computer
$lastLogon = $computer.LastLogonDate

# Get the user object for the last logged on user
$user = Get-ADUser -Filter {LastLogon -eq $lastLogon} -Properties LastLogon

# Output the name of the last logged on user
$user.Name


# If the above fails if the lastlogon is not filled in try:

# Replace "hostname" with the actual hostname
# Get the security event log for the specified hostname
$log = Get-EventLog -LogName Security -ComputerName $hostname

# Filter the event log for event ID 4624 (logon event)
$log = $log | Where-Object {$_.EventID -eq 4624}

# Sort the event log by the time the event was logged
$log = $log | Sort-Object -Property TimeGenerated -Descending

# Get the first logon event (the most recent one)
$logonEvent = $log[0]

# Output the username of the user who logged on
$logonEvent.ReplacementStrings[5]