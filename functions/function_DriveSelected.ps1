<#
[FROM] _ShowConnectedDrives
#>

function global:DriveSelected{

    # Wait 3 seconds before firing up
    Start-Sleep -s 3
    [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

    # $Global:SelectedDrive variable is set to letter that carries through rest of script now
    $Global:SelectedDrive = [Microsoft.VisualBasic.Interaction]::InputBox("From the drives listed in the blue window, type just the LETTER of the drive from the list you want to back up to and click on the OK button.", "Drive Letter Selection", "X")
    
    # Regex to test drive letter is only [D, E, F, H, I, J, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z]
    $A2Z_Only = "^[d-fh-jl-zD-FH-JL-Z]+$"

    # Ensure that ONLY a drive letter is provided, else exit
    If($Global:SelectedDrive.length -gt 1){
        [System.Windows.Forms.MessageBox]::Show($Global:SelectedDrive + " is not just the drive letter`n`nExiting app.`n`n`nError Code: D21","Not Just Drive Letter Provided")
        Exit
    }

    # Match drive letter provided is as per regex test, else exit
    If(-Not($Global:SelectedDrive -match $A2Z_Only)){
        [System.Windows.Forms.MessageBox]::Show($Global:SelectedDrive + " is not a valid drive letter`n`n`nError Code: A1045","Incorrect Drive Letter Provided")
        Exit
    }

    # Let the user know backup will commence to the drive X they selected
    [System.Windows.Forms.MessageBox]::Show("The USB drive you selected is " + $Global:SelectedDrive + ".`nDo not disconnect the drive until process finalised.`n`nThis process can take between 15-60 minutes to complete!","Data Backup Start",0) 
}

DriveSelected

<#
[CARRIED] $Global:SelectedDrive
#>

<#
[GOTO] _DirectoryStructureComposite
#>
