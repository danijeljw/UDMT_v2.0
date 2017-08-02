<#
This script is fun from UMT_USB_Backup.ps1
#>

$global:IsUserIDCorrect = $NULL
$global:BackupUserID = $NULL

function global:UserIDCorrect{
    If($global:IsUserIDCorrect -eq $NULL){
        [console]::beep(2000,500)
        [console]::beep(2000,500)
        [console]::beep(2000,500)
        Write-Host "UserID is not set!" -ForegroundColor Red -BackgroundColor Black
        Start-Sleep 2
        Write-Host "Exiting!" -ForegroundColor Yellow -BackgroundColor Black
        [console]::beep(2000,500)
        Start-Sleep 3
        Exit
    }
    ElseIf($global:IsUserIDCorrect -eq 1){
        $global:BackupUserID = $env:USERNAME
    }Else{
        $global:BackupUserID = Write-Host "Enter UserID to backup"
    }
}

<#
$BackupUserID now becomes the UserID that we need to grab files from, and then create the $env:UserName folder
in the target 'cos that means the user may have changed their name!
#>