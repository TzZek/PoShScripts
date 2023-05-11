# Input: CSV file with a list of IP addresses in column A
$inputFile = "InputIPs.csv"

# Output: CSV file with last hop in column B corresponding to each IP
$outputFile = "OutputIPs.csv"

# Read IP addresses from the input CSV file
$ipList = Import-Csv -Path $inputFile

# Create CSV header
$header = "IP,LastHop"
Add-Content -Path $outputFile -Value $header

foreach ($row in $ipList) {
    $ip = $row.IP

    # Perform traceroute and get the last hop
    $tracertResult = tracert $ip | Out-String
    $tracertLines = $tracertResult.Split("`n")

    # Skip if no results found
    if ($tracertLines.Count -lt 4) {
        continue
    }

    # Extract last hop
    $lastHopLine = $tracertLines[-2]
    $lastHopData = $lastHopLine.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    $lastHop = $lastHopData[1]

    # Write last hop and IP to CSV
    $csvRow = "{0},{1}" -f $ip, $lastHop
    Add-Content -Path $outputFile -Value $csvRow
}
