<#
[FROM] _DriveSelected
#>

<#
[CARRIED] $Global:SelectedDrive
#>

$Global:CurrentYearOnly = (Get-Date).Year
$Global:TargetPath = "$Global:SelectedDrive\ICT_USB_BACKUP_$Global:CurrentYearOnly\$env:COMPUTERNAME"
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

function global:DirectoryStructureComposite{
    If ( Test-Path $Global:TargetPath ) {
        # beeps to alert user
        [console]::beep(2000,500)
        [console]::beep(2000,500)
        [console]::beep(2000,500)
        # Path for current machine exists, confirm to overwrite with the word "YES"
        [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
        $ContinueYes = [Microsoft.VisualBasic.Interaction]::InputBox("Backup of " + $env:COMPUTERNAME + " already exists.`n`nType 'YES' into box to continue", "Backup Directory Exists", "YES")
        }

        # If "YES" or "yes" is not typed in, will exit here, using regex
        $YES_Only = "^[esyESY]+$"
        If (-not( $ContinueYes -match $YES_Only)){
            [console]::beep(2000,500)
            [console]::beep(2000,500)
            [System.Windows.Forms.MessageBox]::Show("Backup aborted.`n`n'YES' was not entered in previous box.`n`n`nError 1002","User Request Exit")
        }

    } Else {
        # Make the C:\UserData folder on the USB drive
        New-Item $Global:TargetPath\UserData -ItemType Directory -Force

        # Create an Outlook signatures folder on the USB drive
        New-Item $Global:TargetPath\Users\$env:USERNAME\Roaming\Microsoft\Signatures -ItemType Directory -Force
    
        # Using folders listed in the array $Global:DirectoryComposite, create each folder
        ForEach ( $x in $Global:DirectoryComposite ){
            New-Item $Global:BasePath\Users\$env:USERNAME\$x -ItemType Directory -Force
        }
    }
    # Cleanup no-longer required variables
    Remove-Variable -Name CurrentYearOnly -Scope Global -Force
}


<#
[CARRIED] $Global:TargetPath
[CARRIED] $Global:DirectoryComposite
#>

<#
[GOTO] _ExportOutlookSettings
#>