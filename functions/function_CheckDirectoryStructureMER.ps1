<#
[FROM] _DriveSelected
#>

<#
[CARRIED] $global:SelectedDrive
#>

# current year only
$global:CurrentYearOnly = (Get-Date).Year

# target path for MINI MER backup folder to be
$global:TargetPath = "$global:SelectedDrive\MINI_MER_BACKUP_$global:CurrentYearOnly\$env:COMPUTERNAME"

#
# ie - $global:TargetPath = X:\MINI_MER_BACKUP_2017\IT12345
#


# explicitly define dictionary to folder structure required
$global:DirectoryComposite = @("Contacts",
                               "Desktop",
                               "Documents",
                               "Downloads",
                               "Favourites",
                               "Links",
                               "Music",
                               "Pictures",
                               "Searches")

# check the directory exists, if does, confirm to overwrite
function global:DirectoryStructureComposite{
    If ( Test-Path $global:TargetPath ) {
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
        # Make the UserData folder
        New-Item $global:TargetPath\UserData -ItemType Directory -Force

        # Create an Outlook signatures folder
        New-Item $global:TargetPath\Users\$env:USERNAME\Roaming\Microsoft\Signatures -ItemType Directory -Force
    
        # Using folders listed in the array $global:DirectoryComposite create personal user data store tree
        ForEach ( $x in $global:DirectoryComposite ){
            New-Item $global:BasePath\Users\$env:USERNAME\$x -ItemType Directory -Force
        }
    }
    # Clean up defunct code no longer required
    Remove-Variable -Name CurrentYearOnly -Scope Global -Force
}


<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

<#
[GOTO] _ExportOutlookSettings
#>