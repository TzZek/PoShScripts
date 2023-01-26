# Map network drive
New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\server\share" -Persist



# Set default printer?
$Printer = "\\printserver\printer"
$Default = $True
$Printer | Add-Printer -ConnectionName $Printer -DriverName "PCL5" -PortName "IP_192.168.1.5" -Default

# Create desktop shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Shortcut.lnk")
$Shortcut.TargetPath = "C:\Program Files\Application.exe"
$Shortcut.Save()


# Check for SCCM Update on Logon
# Import SCCM module
Import-Module (Get-WmiObject -Namespace "root\ccm\ClientSDK" -Class CCM_ClientUtilities).DllPath

# Check for updates
$Updates = Get-WmiObject -Namespace "root\ccm\ClientSDK" -Class CCM_SoftwareUpdates -Filter "IsAssigned=1"

# Install updates
ForEach ($Update in $Updates) {
    Invoke-WmiMethod -Namespace "root\ccm\ClientSDK" -Class CCM_SoftwareUpdates -Name Install -ArgumentList $Update.CI_ID
}