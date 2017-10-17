<#
[FROM] Main Load
#>

<#
[NOTICE] This has been converted from text to window based
#>

$Global:USBDriveConnectedQuery = $NULL

function global:QueryUSBDriveConnected{

    # Box window asking user input Yes/No
    Add-Type -AssemblyName PresentationCore,PresentationFramework
    $ButtonType = [System.Windows.MessageBoxButton]::YesNo
    $MessageIcon = [System.Windows.MessageBoxImage]::Question
    $MessageBody = "Have you connected the USB hard drive to the computer first?"
    $MessageTitle = "USB Hard Drive Connected"
    $Global:USBDriveConnectedQuery = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
 
    # Box advising USB HDD needs to be connected first
    If ($Global:USBDriveConnectedQuery -eq "No"){
        Add-Type -AssemblyName PresentationCore,PresentationFramework
        $ButtonType = [System.Windows.MessageBoxButton]::OK
        $MessageIcon = [System.Windows.MessageBoxImage]::Error
        $MessageBody = "USB hard drive needs to be connected before running UDTM!`n`nExiting application."
        $MessageTitle = "Error!"
        $Global:QueryUSBDriveConnected = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
        # Exit here because USB HDD not connected first
        If ($Global:USBDriveConnectedQuery -eq "OK"){
            Exit
        }
    }
}

QueryUSBDriveConnected

<#
[GOTO] _ShowConnectedDrives
#>