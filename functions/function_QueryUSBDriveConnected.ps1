<#
[FROM] Main Load
#>

<#
[NOTICE] This has been converted from text to window based
#>

$global:USBDriveConnectedQuery = $NULL

function global:QueryUSBDriveConnected{
    # Global param test built-in or exit
    If (-Not(Test-Path variable:global:USBDriveConnectedQuery)){
        Write-Host "USBDriveConnectedQuery variable not defined!"
        Write-Host "Exiting in 3 seconds"
        Start-Sleep -s 3
        Exit
    }
    # Box window asking user input Yes/No
    Add-Type -AssemblyName PresentationCore,PresentationFramework
    $ButtonType = [System.Windows.MessageBoxButton]::YesNo
    $MessageIcon = [System.Windows.MessageBoxImage]::Question
    $MessageBody = "Have you connected the USB hard drive to the computer first?"
    $MessageTitle = "USB Hard Drive Connected"
    $global:USBDriveConnectedQuery = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
 
    # Box advising USB HDD needs to be connected first
    If ($global:USBDriveConnectedQuery -eq "No"){
        Add-Type -AssemblyName PresentationCore,PresentationFramework
        $ButtonType = [System.Windows.MessageBoxButton]::OK
        $MessageIcon = [System.Windows.MessageBoxImage]::Error
        $MessageBody = "USB hard drive needs to be connected before running UDTM!`n`nExiting application."
        $MessageTitle = "Error!"
        $global:QueryUSBDriveConnected = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
        # Exit here because USB HDD not connected first
        If ($global:USBDriveConnectedQuery -eq "OK"){
            Exit
        }
    }
}

<#
[GOTO] _ShowConnectedDrives
#>