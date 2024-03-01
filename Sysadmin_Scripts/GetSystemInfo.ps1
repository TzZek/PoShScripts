Get-WmiObject win32_physicalmemory | Format-Table Manufacturer,Banklabel,Configuredclockspeed,Devicelocator,
Capacity,Serialnumber, Speed -autosize

Get-ComputerInfo | Format-Table WindowsProductName, BiosFirmwareType, CsProcessors, OSNumberOfProcesses -AutoSize

ipconfig /all

Get-CimInstance Win32_PageFileUsage | fl *

Get-Counter 

Get-CimInstance -ClassName Win32_Desktop | ft *

# Get Bios Information
Get-CimInstance -ClassName Win32_BIOS

# Listing Computer Manufacturer and Model
Get-CimInstance -ClassName Win32_ComputerSystem

psexec \\GJKZL-9CS90S3C9 -s powershell 'Get-CimInstance -ClassName Win32_ComputerSystem'

# Get mapped Drives
Get-PSDrive | where{$_.DisplayRoot -match "\\"} | ft Name, DisplayRoot, Used, Free

# Invoke-Command -ComputerName RemoteComputer -ScriptBlock{Get-PSDrive}

Get-CimInstance -ClassName Win32_QuickFixEngineering

# Get the current logged in user
Get-CimInstance -ClassName Win32_ComputerSystem -Property UserName | fl UserName
