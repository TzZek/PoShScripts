# Define the remote computer name
$computer = "REMOTE_COMPUTER_NAME"

# Define the name of the program to find
$program = "PROGRAM_NAME"

# Use Invoke-Command to run the command on the remote computer
$productCode = Invoke-Command -ComputerName $computer -ScriptBlock {
    (Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq $using:program}).IdentifyingNumber
}

# Write the product code to the console
Write-Host "The product code for $program on $computer is $productCode"