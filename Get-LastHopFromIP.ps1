# Change these file paths as needed
$InputFile = "ip_addresses.txt"
$OutputFile = "last_hop_ips.csv"

# Read the IP addresses from the input file
$IPAddresses = Get-Content $InputFile

# Initialize an array to store the results
$Results = @()

# Perform the traceroute and processing in parallel for each IP address
$IPAddresses | ForEach-Object -Parallel {
    $IPAddress = $_

    $TracerouteResult = Test-NetConnection -ComputerName $IPAddress -TraceRoute
    $LastHop = $TracerouteResult.TraceRoute[-2]

    if ($LastHop -ne $null) {
        $LastHopIP = $LastHop
        $OutputLine = [PSCustomObject]@{
            'LastHop' = $LastHopIP
            'IP'      = $IPAddress
        }
        $OutputLine
    }
} -ThrottleLimit 10 | ForEach-Object {
    # Add the result to the array
    $Results += $_
}

# Export the results array to a CSV file
$Results | Export-Csv -Path $OutputFile -NoTypeInformation
