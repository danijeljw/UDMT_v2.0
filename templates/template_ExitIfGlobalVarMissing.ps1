If (-Not(Test-Path variable:global:XXXXXXX)){
    Write-Host "XXXXXXX variable not defined!"
    Write-Host "Exiting in 3 seconds"
    Start-Sleep -s 3
    Exit
}
