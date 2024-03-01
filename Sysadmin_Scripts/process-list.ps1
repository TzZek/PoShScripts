$process = Read-Host("Type a process name")

Get-Process | where -Property Name -Like *$process* | fl Name, Id, StartTime
