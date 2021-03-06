﻿<#
==============================================================================
#>

function Global:QueryUSBDriveConnected
{

    # Box window asking user input Yes/No
    Add-Type -AssemblyName PresentationCore,PresentationFramework
    $ButtonType = [System.Windows.MessageBoxButton]::YesNo
    $MessageIcon = [System.Windows.MessageBoxImage]::Question
    $MessageBody = "Have you connected the USB hard drive to the computer first?"
    $MessageTitle = "USB Hard Drive Connected"
    $Global:USBDriveConnectedQuery = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
 
    # Box advising USB HDD needs to be connected first
    If ($Global:USBDriveConnectedQuery -eq "No")
    {
        Add-Type -AssemblyName PresentationCore,PresentationFramework
        $ButtonType = [System.Windows.MessageBoxButton]::OK
        $MessageIcon = [System.Windows.MessageBoxImage]::Error
        $MessageBody = "USB hard drive needs to be connected before running UDMT 2.0!`n`nExiting application.`n`n`nError Code: U221"
        $MessageTitle = "Error!"
        $Global:QueryUSBDriveConnected = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
        # Exit here because USB HDD not connected first
        Exit
    }
}

QueryUSBDriveConnected

<#
==============================================================================
#>

function Global:WarningCloseApps
{
    # Prompt with list of apps that are required to be closed
    [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    $Global:Apps2Shutdown = [Microsoft.VisualBasic.Interaction]::InputBox("The following applications will be closed automatically:`n`nWord, Excel, Outlook, PowerPoint, OneNote, Internet Explorer, Google Chrome`n`n`nType 'YES' into the box and click OK to confirm.", "Closing Mandatory Apps", "No")

    # If not OK to close these applications, exit program
    $YES_Only = "^[esyESY]+$"
    If (-not($Global:Apps2Shutdown -match $YES_Only))
    {
        [console]::beep(1000,500)
        [console]::beep(1000,500)
        [System.Windows.Forms.MessageBox]::Show("Backup aborted.`n`n'YES' was not entered in previous box.`n`n`nError G404","User Request Exit")
        Exit
    }
}

WarningCloseApps

<#
==============================================================================
#>

function Global:ShowConnectedDrivesAndSelectDrive
{

    # Clear the screen of text first
    Clear-Host

    "The drives you currently have connected are:" | Out-File C:\Temp\listofdrives.txt
    Get-WmiObject Win32_DiskDrive | % {
      $disk = $_
      $partitions = "ASSOCIATORS OF " +
                    "{Win32_DiskDrive.DeviceID='$($disk.DeviceID)'} " +
                    "WHERE AssocClass = Win32_DiskDriveToDiskPartition"
      Get-WmiObject -Query $partitions | % {
        $partition = $_
        $drives = "ASSOCIATORS OF " +
                  "{Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} " +
                  "WHERE AssocClass = Win32_LogicalDiskToPartition"
        Get-WmiObject -Query $drives | % {
          New-Object -Type PSCustomObject -Property @{
            #Disk        = $disk.DeviceID
            #DiskSize    = $disk.Size
            #DiskModel   = $disk.Model
            #Partition   = $partition.Name
            #RawSize     = $partition.Size
            "Drive Letter" = $_.DeviceID
            "Drive Name"  = $_.VolumeName
            #Size        = $_.Size
            "GB Free"   = [int](($_.FreeSpace/1048576)/1000)
          }
        }
      }
    } | Out-File C:\Temp\listofdrives.txt -Append

    # Open the TXT file with the apps
    Start-Process -FilePath "listofdrives.txt" -WorkingDirectory "C:\Temp" 
    
    # Wait 3 seconds before firing up
    Start-Sleep -s 3
    [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

    # $Global:SelectedDrive variable is set to letter that carries through rest of script now
    $Global:SelectedDrive = [Microsoft.VisualBasic.Interaction]::InputBox("From the drives listed in the Notepad document, type just the LETTER of the drive from the list you want to back up to and click on the OK button.", "Drive Letter Selection", "X")
    
    # Regex to test drive letter is only [D, E, F, H, I, J, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z]
    $A2Z_Only = "^[d-fh-jl-zD-FH-JL-Z]+$"

    # Ensure that ONLY a drive letter is provided, else exit
    If ($Global:SelectedDrive.length -gt 1)
    {
        [System.Windows.Forms.MessageBox]::Show($Global:SelectedDrive + " is not just the drive letter`n`nExiting app.`n`n`nError Code: D21","Not Just Drive Letter Provided")
        Exit
    }

    # Match drive letter provided is as per regex test, else exit
    If (-Not($Global:SelectedDrive -match $A2Z_Only))
    {
        [System.Windows.Forms.MessageBox]::Show($Global:SelectedDrive + " is not a valid drive letter`n`n`nError Code: A1045","Incorrect Drive Letter Provided")
        Exit
    }

    # Let the user know backup will commence to the drive X they selected
    [System.Windows.Forms.MessageBox]::Show("The USB drive you selected is " + $Global:SelectedDrive + ".`nDo not disconnect the drive until process finalised.`n`nThis process can take between 15-60 minutes to complete!","Data Backup Start",0) 

    Stop-Process -Name notepad -ErrorAction SilentlyContinue 
}

ShowConnectedDrivesAndSelectDrive

<#
==============================================================================
#>

function Global:ParameterSetsRequired
{
    $Global:CurrentYearOnly = (Get-Date).Year

    $Global:TargetPath = $Global:SelectedDrive + ":\ICT_USB_BACKUP_" + $Global:CurrentYearOnly + "\" + $env:COMPUTERNAME
    # ie - $Global:TargetPath = X:\ICT_USB_BACKUP_2017\IT12345

    # Define the folders in in the UserProfile folder in C:\Users\X
    $Global:DirectoryComposite = @("Contacts",
                                   "Desktop",
                                   "Documents",
                                   "Downloads",
                                   "Favourites",
                                   "Links",
                                   "Music",
                                   "Pictures",
                                   "Searches")
}

ParameterSetsRequired



<#
==============================================================================
#>

function Global:DirectoryStructureComposite
{
    If (Test-Path $Global:TargetPath)
    {

        # beeps to alert user
        [console]::beep(1000,500)
        [console]::beep(2000,500)
        [console]::beep(1000,500)

        # Path for current machine exists, confirm to overwrite with the word "YES"
        [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
        $ContinueYes = [Microsoft.VisualBasic.Interaction]::InputBox("Backup of " + $env:COMPUTERNAME + " already exists.`n`nType 'YES' into box to continue", "Backup Directory Exists", "YES")

        # If "YES" or "yes" is not typed in, will exit here, using regex
        $YES_Only = "^[esyESY]+$"
        If (-not($ContinueYes -match $YES_Only))
        {
            [console]::beep(1000,500)
            [console]::beep(1000,500)
            [System.Windows.Forms.MessageBox]::Show("Backup aborted.`n`n'YES' was not entered in previous box.`n`n`nError 1002","User Request Exit")
            Exit
        }
    }
}

DirectoryStructureComposite



<#
==============================================================================
#>

function Global:MakeOtherFoldersRequired
{
    # Make the C:\UserData folder on the USB drive
    New-Item "$Global:TargetPath\UserData" -ItemType Directory -Force

    # Create an Outlook signatures folder on the USB drive
    New-Item "$Global:TargetPath\Users\$env:USERNAME\Roaming\Microsoft\Signatures" -ItemType Directory -Force

    # Create Google Chrome bookmarks folder on the USB drive
    New-Item "$Global:TargetPath\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data\Default" -ItemType Directory -Force
    
    # Using folders listed in the array $Global:DirectoryComposite, create each folder
    ForEach ($x in $Global:DirectoryComposite)
    {
        New-Item $Global:TargetPath\Users\$env:USERNAME\$x -ItemType Directory -Force
    }
}

MakeOtherFoldersRequired






<#
==============================================================================
#>




function Global:ExportOutlookSettings
{

    # This parameter is required here
    $Global:Outlook_Exported_Settings = "$Global:TargetPath\Users\$env:USERNAME\Desktop\Outlook_Exported_Settings.txt"


    # Create OutlookProfileSettings Text File
    New-Item $Global:Outlook_Exported_Settings -ItemType File -Force
    

    # Write settings to Outlook_Exported_Settings text file
    '****************************Currently attached archives' | Out-File $Global:Outlook_Exported_Settings -Append
    $Outlook = New-Object -Comobject Outlook.Application
    $Namespace = $Outlook.GetNamespace('MAPI')
    $Mailboxes = $Namespace.Stores | where {$_.ExchangeStoreType -eq 1} | Select-Object DisplayName
    $AttachedArchives = $Namespace.Stores | where {$_.ExchangeStoreType -eq 3} | Select-Object DisplayName,FilePath
    $MailBoxes | Out-File -FilePath $Global:Outlook_Exported_Settings -Append
    $AttachedArchives | Out-File -FilePath $Global:Outlook_Exported_Settings -Append
    

    # Write out mapped PST for Outlook 2007
    '****************************Archive History for Office 2007' | Out-File $Global:Outlook_Exported_Settings -Append
    If ((Test-Path HKCU:\software\Microsoft\Office\12.0\Outlook\Catalog) -eq $True)
    {
        Get-Item HKCU:\software\Microsoft\Office\12.0\Outlook\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $Global:Outlook_Exported_Settings -Append
    }
    Else
    {
        'NO DATA EXISTS for Office 2007' | Out-File $Global:Outlook_Exported_Settings -Append
        '                              ' | Out-File $Global:Outlook_Exported_Settings -Append
    }


    # Write out mapped PST for Outlook 2010
    '****************************Archive History for Office 2010' | Out-File $Global:Outlook_Exported_Settings -Append
    If ((Test-Path HKCU:\software\Microsoft\Office\14.0\Outlook\Catalog) -eq $True)
    {
        Get-Item HKCU:\software\Microsoft\Office\14.0\Outlook\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $Global:Outlook_Exported_Settings -Append
    }
    Else
    {
        'NO DATA EXISTS for Office 2010' | Out-File $Global:Outlook_Exported_Settings -Append
        '                              ' | Out-File $Global:Outlook_Exported_Settings -Append
    }


    # Write out mapped PST for Outlook 2013
    '****************************Archive History for Office 2013' | Out-File $Global:Outlook_Exported_Settings -Append
    If ((Test-Path HKCU:\software\Microsoft\Office\15.0\Outlook\Search\Catalog) -eq $True)
    {
        Get-Item HKCU:\software\Microsoft\Office\15.0\Outlook\Search\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $Global:Outlook_Exported_Settings -Append
    }
    Else
    {
        'NO DATA EXISTS for Office 2013' | Out-File $Global:Outlook_Exported_Settings -Append
        '                              ' | Out-File $Global:Outlook_Exported_Settings -Append
    }


    # Write out mapped PST for Outlook 2016
    '****************************Archive History for Office 2016' | Out-File $Global:Outlook_Exported_Settings -Append
    If ((Test-Path HKCU:\software\Microsoft\Office\16.0\Outlook\Search\Catalog) -eq $True)
    {
        Get-Item HKCU:\software\Microsoft\Office\16.0\Outlook\Search\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $Global:Outlook_Exported_Settings -Append
    }
    Else
    {
        'NO DATA EXISTS for Office 2013' | Out-File $Global:Outlook_Exported_Settings -Append
        '                              ' | Out-File $Global:Outlook_Exported_Settings -Append
    }

}

ExportOutlookSettings











function Global:KillAppsNow
{
    # List of apps that need to be closed if they're currently open as an array
    $Global:CloseOpenApps = @("outlook","firefox","chrome","iexplore","winword","powerpnt","onenote","excel")

    ForEach ($process in $Global:CloseOpenApps)
        {
            Stop-Process -Name $process -ErrorAction SilentlyContinue 
        }
}

KillAppsNow






function Global:FileNamesNotCopiedTooLong
{
    $Global:TooLongFileNamesUserData = "C:\Users\$env:USERNAME\" + $Global:DirectoryComposite[1] + "\FilesNotCopied-UserData.txt"
    $Global:TooLongFileNamesUsersUserID = "C:\Users\$env:USERNAME\" + $Global:DirectoryComposite[1] + "\FilesNotCopied-UserID.txt"
    
    New-Item $Global:TooLongFileNamesUserData -ItemType File -Force
    New-Item $Global:TooLongFileNamesUsersUserID -ItemType File -Force


    "*****Files from C:\UserData*****" | Out-File $Global:TooLongFileNamesUserData -Append
    cmd /c "dir /b /s /a:d C:\UserData" | ForEach-Object
    {
        If ($_.length -gt 250)
        {
            $_ | Out-File $Global:TooLongFileNamesUserData -Append
        }
    }

    "*****Files from C:\Users\$env:USERNAME\Contacts*****" | Out-File $Global:TooLongFileNamesUsersUserID -Append
    cmd /c "dir /b /s /a:d C:\Users\%USERNAME%\Contacts" | ForEach-Object
    
    {
        If ($_.length -gt 250)
        {
            $_ | Out-File $Global:TooLongFileNamesUsersUserID -Append
        }
    }
    
    "*****Files from C:\Users\$env:USERNAME\Desktop*****" | Out-File $Global:TooLongFileNamesUsersUserID -Append
    cmd /c "dir /b /s /a:d C:\Users\%USERNAME%\Desktop" | ForEach-Object
    {
        If ($_.length -gt 250)
        {
            $_ | Out-File $Global:TooLongFileNamesUsersUserID -Append
        }
    }

    "*****Files from C:\Users\$env:USERNAME\Documents*****" | Out-File $Global:TooLongFileNamesUsersUserID -Append
    cmd /c "dir /b /s /a:d C:\Users\%USERNAME%\Documents" | ForEach-Object
    {
        If ($_.length -gt 250)
        {
            $_ | Out-File $Global:TooLongFileNamesUsersUserID -Append
        }
    }

    "*****Files from C:\Users\$env:USERNAME\Downloads*****" | Out-File $Global:TooLongFileNamesUsersUserID -Append
    cmd /c "dir /b /s /a:d C:\Users\%USERNAME%\Downloads" | ForEach-Object
    {
        If ($_.length -gt 250)
        {
            $_ | Out-File $Global:TooLongFileNamesUsersUserID -Append
        }
    }

    "*****Files from C:\Users\$env:USERNAME\Favourites*****" | Out-File $Global:TooLongFileNamesUsersUserID -Append
    cmd /c "dir /b /s /a:d C:\Users\%USERNAME%\Favourites" | ForEach-Object
    {
        If ($_.length -gt 250)
        {
            $_ | Out-File $Global:TooLongFileNamesUsersUserID -Append
        }
    }

    "*****Files from C:\Users\$env:USERNAME\Links*****" | Out-File $Global:TooLongFileNamesUsersUserID -Append
    cmd /c "dir /b /s /a:d C:\Users\%USERNAME%\Links" | ForEach-Object
    {
        If ($_.length -gt 250)
        {
            $_ | Out-File $Global:TooLongFileNamesUsersUserID -Append
        }
    }

    "*****Files from C:\Users\$env:USERNAME\Music*****" | Out-File $Global:TooLongFileNamesUsersUserID -Append
    cmd /c "dir /b /s /a:d C:\Users\%USERNAME%\Music" | ForEach-Object{
        If ($_.length -gt 250){
            $_ | Out-File $Global:TooLongFileNamesUsersUserID -Append
        }
    }
    "*****Files from C:\Users\$env:USERNAME\Pictures*****" | Out-File $Global:TooLongFileNamesUsersUserID -Append
    cmd /c "dir /b /s /a:d C:\Users\%USERNAME%\Pictures" | ForEach-Object{
        If ($_.length -gt 250){
            $_ | Out-File $Global:TooLongFileNamesUsersUserID -Append
        }
    }
    "*****Files from C:\Users\$env:USERNAME\Searches*****" | Out-File $Global:TooLongFileNamesUsersUserID -Append
    cmd /c "dir /b /s /a:d C:\Users\%USERNAME%\Searches" | ForEach-Object{
        If ($_.length -gt 250){
            $_ | Out-File $Global:TooLongFileNamesUsersUserID -Append
        }
    }
}

FileNamesNotCopiedTooLong








function Global:BackupFilesAndFolders
{
    # Backup UserData folder
    Copy-Item C:\UserData\* $Global:TargetPath\UserData -Recurse -Force

    # Backup each folder in UsersUserID Folder
    If ((Test-Path $env:USERPROFILE\Contacts) -eq $True){Copy-Item "$env:USERPROFILE\Contacts\*" "$Global:TargetPath\Users\$env:USERNAME\Contacts\*" -Recurse -Force}
    If ((Test-Path $env:USERPROFILE\Desktop) -eq $True){Copy-Item "$env:USERPROFILE\Desktop\*" "$Global:TargetPath\Users\$env:USERNAME\Desktop\*" -Recurse -Force}
    If ((Test-Path $env:USERPROFILE\Documents) -eq $True){Copy-Item "$env:USERPROFILE\Documents\*" "$Global:TargetPath\Users\$env:USERNAME\Documents\*" -Recurse -Force}
    If ((Test-Path $env:USERPROFILE\Downloads) -eq $True){Copy-Item "$env:USERPROFILE\Downloads\*" "$Global:TargetPath\Users\$env:USERNAME\Downloads\*" -Recurse -Force}
    If ((Test-Path $env:USERPROFILE\Favourites) -eq $True){Copy-Item "$env:USERPROFILE\Favourites\*" "$Global:TargetPath\Users\$env:USERNAME\Favourites\*" -Recurse -Force}
    If ((Test-Path $env:USERPROFILE\Links) -eq $True){Copy-Item "$env:USERPROFILE\Links\*" "$Global:TargetPath\Users\$env:USERNAME\Links\*" -Recurse -Force}
    If ((Test-Path $env:USERPROFILE\Music) -eq $True){Copy-Item "$env:USERPROFILE\Music\*" "$Global:TargetPath\Users\$env:USERNAME\Music\*" -Recurse -Force}
    If ((Test-Path $env:USERPROFILE\Pictures) -eq $True){Copy-Item "$env:USERPROFILE\Pictures\*" "$Global:TargetPath\Users\$env:USERNAME\Pictures\*" -Recurse -Force}
    If ((Test-Path $env:USERPROFILE\Searches) -eq $True){Copy-Item "$env:USERPROFILE\Searches\*" "$Global:TargetPath\Users\$env:USERNAME\Searches\*" -Recurse -Force}
    
    # Backup all the signatures to USB drive
    If ((Test-Path $env:USERPROFILE\AppData\Roaming\Microsoft\Signatures) -eq $True){Copy-Item "$env:USERPROFILE\AppData\Roaming\Microsoft\Signatures\*" "$Global:TargetPath\Users\$env:USERNAME\AppData\Roaming\Microsoft\Signatures\*" -Recurse -Force}
    
    # Backup the Google Chrome bookmarks to USB drive
    If ((Test-Path "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Bookmarks") -eq $True){Copy-Item "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" "$Global:TargetPath\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" -Recurse -Force}
}

BackupFilesAndFolders











function Global:ExportNetworkDrives
{
    # PowerShell version of the "net use" command
    Get-PSDrive -PSProvider FileSystem | Select-Object Name, DisplayRoot | Where-Object {$_.DisplayRoot -ne $null} > $Global:TargetPath\Drives2.txt

    # Remove whitepace at end of each line
    Get-Content $Global:TargetPath\Drives2.txt | ForEach-Object {$_.TrimEnd()} | Set-Content $Global:TargetPath\Drives3.txt

    # Replace '    ' with ': ' each line
    Get-Content $Global:TargetPath\Drives3.txt | ForEach-Object {$_ -replace '    ', ': '} | Set-Content $Global:TargetPath\Drives4.txt

    # Interim fix, checked steps
    Get-Content $Global:TargetPath\Drives4.txt | ? {$_.trim() -ne "" } | Set-Content $Global:TargetPath\Drives5a.txt

    # Interim fix, checked steps
    Get-Content $Global:TargetPath\Drives5a.txt | ForEach-Object {$_ -replace 'Name DisplayRoot', ''} | Set-Content $Global:TargetPath\Drives5b.txt

    # Interim fix, checked steps
    Get-Content $Global:TargetPath\Drives5b.txt | ForEach-Object {$_ -replace '---- -----------', ''} | Set-Content $Global:TargetPath\Drives5c.txt

    # Interim fix, checked steps
    Get-Content $Global:TargetPath\Drives5c.txt | ? {$_.trim() -ne "" } | Set-Content $Global:TargetPath\Drives5d.txt

    # Prefix each line with 'net use ' for batch file at the end
    Get-Content $Global:TargetPath\Drives5d.txt | ForEach-Object {"net use " + $_} | Set-Content $Global:TargetPath\Drives6.txt

    # Suffix each line with '" /P:Yes' for perisistance and share paths with spaces in name
    Get-Content $Global:TargetPath\Drives6.txt | ForEach-Object {$_ + '" /P:Yes'} | Set-Content $Global:TargetPath\Drives7.txt

    # Replace '\\' with '"\\' for share paths with spaces in name
    Get-Content $Global:TargetPath\Drives7.txt | ForEach-Object {$_ -replace ': \\', ': "\'} | Set-Content $Global:TargetPath\Drives8.txt

    # Append Drives8.txt to BAT file
    Get-Content $Global:TargetPath\Drives8.txt | ForEach-Object {$_} | Set-Content "$Global:TargetPath\Drives.bat" -Force

    # Clean up reduntant files
    Remove-Item "$Global:TargetPath\Drives*.txt" -Force
}

ExportNetworkDrives












function Global:ExportNetworkPrinters
{
    Get-WMIObject Win32_Printer -ComputerName $env:COMPUTERNAME | where{$_.Name -like “*\\*”} | select name | Out-File "$Global:TargetPath\Printers.txt" -Append
}

ExportNetworkPrinters




function Global:BackupIsNowComplete
{
    Add-Type -AssemblyName PresentationCore,PresentationFramework
    $ButtonType = [System.Windows.MessageBoxButton]::OK
    $MessageIcon = [System.Windows.MessageBoxImage]::Exclamation
    $MessageBody = "Data has been backed up! Process is now complete.`n`n`n`nClick OK to exit."
    $MessageTitle = "UDMT 2.0 Process Complete"
    $Global:QueryUSBDriveConnected = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
    # Exit here because USB HDD not connected first
    Exit
}