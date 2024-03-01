# Define the output file
$outputFile = "C:\path\to\your\output.csv"

# Get the hostname
$hostname = hostname

# Get the IP address
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -ne 'Loopback Pseudo-Interface 1' -and $_.IPAddress -ne '127.0.0.1' }).IPAddress

# Initialize MAC address variable
$macAddress = $null

# Loop through each IP address to find the corresponding MAC address
foreach ($ip in $ipAddress) {
    $interfaceIndex = (Get-NetIPAddress -IPAddress $ip).InterfaceIndex
    $mac = (Get-NetAdapter -InterfaceIndex $interfaceIndex).MacAddress
    if ($null -ne $mac) {
        $macAddress = $mac
        break
    }
}

# Get the serial number
$serialNumber = (Get-WmiObject win32_bios).SerialNumber

# Get the OS version
$osVersion = (Get-WmiObject win32_operatingsystem).Version

# Create a custom object to hold the information
$computerInfo = [PSCustomObject]@{
    Hostname     = $hostname
    IPAddress    = $ipAddress -join ', '
    MACAddress   = $macAddress
    SerialNumber = $serialNumber
    OSVersion    = $osVersion
}

# Append the information to the CSV file
$computerInfo | Export-Csv -Path $outputFile -Append -NoTypeInformation
