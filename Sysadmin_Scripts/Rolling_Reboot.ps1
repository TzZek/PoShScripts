# Import the list of computers from the text file
$computers = Get-Content -Path "C:\path\to\computers.txt"

# Loop through each computer in the list
foreach ($computer in $computers) {
    # Attempt to reboot the computer
    Restart-Computer -ComputerName $computer -Force -ErrorAction SilentlyContinue
    # Write the status of the reboot to the console
    if ($?) {
        Write-Host "$computer rebooted successfully"
    } else {
        Write-Host "$computer reboot failed"
    }
}