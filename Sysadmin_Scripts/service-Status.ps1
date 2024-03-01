$varStatus = Read-Host -Prompt "Enter the status Running or Stopped"
Get-Service | where {$_.Status -eq $varStatus} | ft -Wrap Name, Status