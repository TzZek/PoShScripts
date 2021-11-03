Do {
$userColor = Read-Host -Prompt "Input a color"

if($userColor -eq "Red" -or $userColor -eq "Yellow" -or $userColor -eq "Blue"){
    Write-Host("That is a primary color")
} elseif($userColor -eq "Green" -or $userColor -eq "Orange" -or $userColor -eq "Violet"){
    Write-Host("That color is a secondary colors")
} else {
    Write-Host("Select another color")
} 
}
While($userColor -ne "Red" -or $userColor -ne "Yellow" -or $userColor -ne "Blue" -or $userColor -ne "Green" -or $userColor -ne "Orange" -or $userColor -ne "Violet")
