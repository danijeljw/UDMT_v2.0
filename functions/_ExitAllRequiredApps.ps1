# Prompt with list of apps that are required to be closed
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$Global:Apps2Shutdown = [Microsoft.VisualBasic.Interaction]::InputBox("The following applications will be closed automatically:`n`nWord, Excel, Outlook, PowerPoint, OneNote, Internet Explorer, Google Chrome`n`n`nType 'YES' into the box and click OK to confirm.", "Closing Mandatory Apps", "No")

# Check if less than 3 characters returned in response, else exit
If($Global:Apps2Shutdown.length -lt 3){
    [System.Windows.Forms.MessageBox]::Show($Global:SelectedDrive + " is not an accepted answer.`n`nExiting app.`n`nError Code: F301","Not Just Drive Letter Provided")
    Exit
}

# Check if less than 3 characters returned in response, else exit
If($Global:Apps2Shutdown.length -gt 3){
    [System.Windows.Forms.MessageBox]::Show($Global:SelectedDrive + " is not an accepted answer.`n`nExiting app.`n`nError Code: F301","Not Just Drive Letter Provided")
    Exit
}

$YES_Only = "^[esyESY]+$"
If (-not($Global:Apps2Shutdown -match $YES_Only)){
    [System.Windows.Forms.MessageBox]::Show($Global:SelectedDrive + " is not an accepted answer.`n`nExiting app.`n`nError Code: F301","Not Just Drive Letter Provided")
    Exit
}


function global:DirectoryStructureComposite{
    If ( Test-Path $Global:TargetPath ) {
        # beeps to alert user
        [console]::beep(1000,500)
        [console]::beep(2000,500)
        [console]::beep(1000,500)
        # Path for current machine exists, confirm to overwrite with the word "YES"
        [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
        $ContinueYes = [Microsoft.VisualBasic.Interaction]::InputBox("Backup of " + $env:COMPUTERNAME + " already exists.`n`nType 'YES' into box to continue", "Backup Directory Exists", "YES")
        }

        # If "YES" or "yes" is not typed in, will exit here, using regex
        $YES_Only = "^[esyESY]+$"
        If (-not( $ContinueYes -match $YES_Only)){
            [console]::beep(1000,500)
            [console]::beep(1000,500)
            [System.Windows.Forms.MessageBox]::Show("Backup aborted.`n`n'YES' was not entered in previous box.`n`n`nError 1002","User Request Exit")
            Exit
        }

    } Else {
        # Make the C:\UserData folder on the USB drive
        New-Item $Global:TargetPath\UserData -ItemType Directory -Force

        # Create an Outlook signatures folder on the USB drive
        New-Item $Global:TargetPath\Users\$env:USERNAME\Roaming\Microsoft\Signatures -ItemType Directory -Force

        # Create Google Chrome bookmarks folder on the USB drive
        New-Item "$Global:TargetPath\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data\Default"
    
        # Using folders listed in the array $Global:DirectoryComposite, create each folder
        ForEach ( $x in $Global:DirectoryComposite ){
            New-Item $Global:BasePath\Users\$env:USERNAME\$x -ItemType Directory -Force
        }
    }