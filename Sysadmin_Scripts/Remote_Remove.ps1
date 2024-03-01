$computers = Get-Content -Path "C:\ComputerList.txt"
$program = "ProgramName"

ForEach ($computer in $computers) {
    Invoke-Command -ComputerName $computer -ScriptBlock {
        Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq $using:program} | 
        ForEach-Object {$_.Uninstall()}
    }
}

# In this example, the script reads a list of computer names from a text file called "ComputerList.txt" 
# and then uses the ForEach-Parallel cmdlet to run the uninstall command on each computer in parallel. 
# The $using: allows the scriptblock to access the variable $program inside the scriptblock.