$num1 = Read-Host -Prompt "Enter the first number."
$num2 = Read-Host -Prompt "Enter the second number."

if($num1 -gt $num2){
    Write-Host("$num1 is larger!")
} elseif($num2 -gt $num1){
    Write-Host("$num2 is larger!")
} else {
    Write-Host("Numbers are equal")
}