# Define the directory path to check
$directoryPath = "C:\Path\To\Directory"

# Define the path to the text file containing a list of computer names
$computersFile = "C:\Path\To\Computers.txt"

# Loop through each computer name in the text file
Get-Content $computersFile | ForEach-Object {
    $remoteComputer = $_
    Write-Host "Checking $remoteComputer..."

    # Test if the directory exists on the remote computer
    if (Test-Path "\\$remoteComputer\$directoryPath") {
        # If the directory exists, write the computer hostname to a spreadsheet
        $hostname = Get-WmiObject Win32_ComputerSystem -ComputerName $remoteComputer | Select-Object Name
        $output = New-Object -TypeName PSObject -Property @{
            ComputerName = $hostname.Name
        }
        $output | Export-Csv -Path "C:\Path\To\OutputFile.csv" -NoTypeInformation -Append
    }
}