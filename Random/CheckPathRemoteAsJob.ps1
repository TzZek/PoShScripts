# Define the directory path to check
$directoryPath = "C:\Path\To\Directory"

# Define the path to the text file containing a list of computer names
$computersFile = "C:\Path\To\Computers.txt"

# Loop through each computer name in the text file and start a job for each
Get-Content $computersFile | ForEach-Object {
    $remoteComputer = $_
    Write-Host "Starting job for $remoteComputer..."
    
    # Start a new background job for the current computer
    $job = Start-Job -ScriptBlock {
        Param($computerName, $directoryPath)
        if (Test-Path "\\$computerName\$directoryPath") {
            $hostname = Get-WmiObject Win32_ComputerSystem -ComputerName $computerName | Select-Object Name
            $output = New-Object -TypeName PSObject -Property @{
                ComputerName = $hostname.Name
            }
            $output | Export-Csv -Path "C:\Path\To\OutputFile.csv" -NoTypeInformation -Append
        }
    } -ArgumentList $remoteComputer, $directoryPath

    # Wait for the job to complete and receive its results
    $result = Receive-Job -Job $job -Wait -AutoRemoveJob

    # Write any errors to the console
    if ($result.Exception) {
        Write-Host "Error on $remoteComputer: $($result.Exception)"
    } else {
        Write-Host "Job for $remoteComputer completed."
    }
}
 