<#
[FROM] _DriveSelected
#>

<#
[CARRIED] $global:SelectedDrive
#>

$global:CurrentYearOnly = (Get-Date).Year
$global:TargetPath = "$global:SelectedDrive\ICT_USB_BACKUP_$global:CurrentYearOnly\$env:COMPUTERNAME"
# ie - $global:TargetPath = X:\ICT_USB_BACKUP_2017\IT12345
$global:DirectoryComposite = @("Contacts",
                               "Desktop",
                               "Documents",
                               "Downloads",
                               "Favourites",
                               "Links",
                               "Music",
                               "Pictures",
                               "Searches")

function global:DirectoryStructureComposite{
    If ( Test-Path $global:TargetPath ) {
        # beeps to alert user
        [console]::beep(2000,500)
        [console]::beep(2000,500)
        [console]::beep(2000,500)
        # Path for current machine exists, confirm to overwrite with the word "YES"
        [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
        $ContinueYes = [Microsoft.VisualBasic.Interaction]::InputBox("Backup of " + $env:COMPUTERNAME + "already exists.`n`nType 'YES' into box to continue", "Backup Directory Exists", "YES")
    
        # If "YES" is not typed in, will exit here, using regex
        $YES_Only = "^[esyESY]+$"
        If (-not( $ContinueYes -match $YES_Only){
            [console]::beep(2000,500)
            [console]::beep(2000,500)
            [System.Windows.Forms.MessageBox]::Show("Backup aborted.`n`n'YES' was not entered in previous box.`n`n`nError 1002","User Request Exit")
        }
    <#
    [LEGACY CODE]

    This code was in the original script, and relied solely on the PowerShell window only, it moved away to a Windows-based theme instead

        Write-Host "UDMT Folder Structure Exists!" -BackgroundColor Black -ForegroundColor DarkCyan
    #>
    } Else {
        # Make the UserData folder
        New-Item $global:TargetPath\UserData  -ItemType Directory -Force

        # Create an Outlook signatures folder
        New-Item $global:TargetPath\Users\$env:USERNAME\Roaming\Microsoft\Signatures -ItemType Directory -Force
    
        # Using folders listed in the array $global:DirectoryComposite create personal user data store tree
        ForEach ( $x in $global:DirectoryComposite ){
            New-Item $global:BasePath\Users\$env:USERNAME\$x -ItemType Directory -Force
        }
    }
}


<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

<#
[GOTO] _DriveSelected
#>