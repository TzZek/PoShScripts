$file = "C:\IPAddresses.txt"
# Specify the number of Files You'd Like the list divided into
$numFiles = 5
$ips = Get-Content $file
$chunkSize = [Math]::Ceiling($ips.Count / $numFiles)

$fileIndex = 1
foreach ($i in 0..($ips.Count - 1)..$chunkSize) {
    $chunk = $ips[$i..($i + $chunkSize - 1)]
    $chunk | Out-File -FilePath "C:\IPAddresses_$fileIndex.txt"
    $fileIndex++
}