$global:DriveSelected = $NULL

function global:WhichDrive2BackupTo{
    If (-Not(Test-Path variable:global:DriveSelected)){
        Write-Host "DriveSelected variable not defined!"
        Write-Host "Exiting in 3 seconds"
        Start-Sleep -s 3
        Exit
    }
    Write-Host "From the drives listed,"
    Write-Host "select the drive to backup"
    $global:DriveSelected = Read-Host "your data to"
    Write-Host ""
    Write-Host "Drive selected is" $global:DriveSelected
}



