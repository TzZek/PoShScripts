$userRule = Read-Host -Prompt "Type the Firewall Rule you wish to check"

Get-NetFirewallRule | where {$_.InstanceID -like "*$userRule*"} | ft Name, Enabled >> $HOME\Desktop\rules.txt