$computers = Get-Content "C:\ComputerList.txt"
$threads = @()
$maxThreads = 10

foreach ($computer in $computers) {
    while ($threads.Count -ge $maxThreads) {
        Start-Sleep -Milliseconds 100
    }
    $threads += [powershell]::Create()
    $threads[-1].Start("Invoke-Command -ComputerName $computer -ScriptBlock {Get-Process}")
}

foreach ($thread in $threads) {
    $thread.Wait()
}
