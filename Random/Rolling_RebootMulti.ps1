# Import the list of computers from the text file
$computers = Get-Content -Path "C:\path\to\computers.txt"
$batchSize = 10

while ($computers.Count -gt 0) {

    $nextBatch = @($computers | Select-Object -First $batchSize)
    $computers = @($computers | Select-Object -Skip $batchSize)

    Restart-Computer -ComputerName $nextBatch -Force -ErrorAction SilentlyContinue
    # Write the status of the reboot to the console
    Write-Host "Running commands against $($nextBatch.Count) computers [$($nextBatch.ForEach({"'$_'"}) -join ', ')]"

}