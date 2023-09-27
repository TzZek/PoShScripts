# Define the output file
$outputFile = "C:\path\to\your\output.csv"

# Get the hostname
$hostname = hostname

# Get the IP address
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -ne 'Loopback Pseudo-Interface 1' }).IPAddress

# Get the matching MAC address for the given IP address
$macAddress = $null
foreach ($ip in $ipAddress) {
    $neighbor = Get-NetNeighbor -IPAddress $ip -AddressFamily IPv4 | Where-Object { $_.State -eq 'Reachable' }
    if ($null -ne $neighbor) {
        $macAddress += $neighbor.LinkLayerAddress
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
    MACAddress   = $macAddress -join ', '
    SerialNumber = $serialNumber
    OSVersion    = $osVersion
}

# Append the information to the CSV file
$computerInfo | Export-Csv -Path $outputFile -Append -NoTypeInformation
