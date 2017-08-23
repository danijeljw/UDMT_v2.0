<#
[FROM] _ShowConnectedDrives
#>

$global:SelectedDrive = $NULL

function global:DriveSelected{
    If (-Not(Test-Path variable:global:SelectedDrive)){
        Write-Host "SelectedDrive variable not defined!"
        Write-Host "Exiting in 3 seconds"
        Start-Sleep -s 3
        Exit
    }
    # Wait 3 seconds before firing up
    Start-Sleep -s 3
    [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    # $global:SelectedDrive variable is set to letter that carries through rest of script now
    $global:SelectedDrive = [Microsoft.VisualBasic.Interaction]::InputBox("From the drives listed in the blue window, type just the LETTER of the drive from the list you want to back up to and click on the OK button.", "Drive Letter Selection", "X")
    
    # Regex to test drive letter is only [D, E, F, G, H, I, J, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z]
    $A2Z_Only = "^[abd-jl-zABD-JL-Z]+$"

    # Match drive letter provided is as per regex test, else exit
    If(-Not($global:SelectedDrive -match $A2Z_Only)){
        [System.Windows.Forms.MessageBox]::Show($global:SelectedDrive + " is not a valid drive letter`n`nExiting app.","Incorrect Drive Letter Provided")
        Exit
    }

    # Ensure that ONLY a drive letter is provided, else exit
    If($global:SelectedDrive.legth -gt 1){
        [System.Windows.Forms.MessageBox]::Show($global:SelectedDrive + " is not just the drive letter`n`nExiting app.","Not Just Drive Letter Provided")
        Exit
    }

<#
[CARRIED] $global:SelectedDrive
#>

    # Let the user know backup will commence to the drive X they selected
    [System.Windows.Forms.MessageBox]::Show("The USB drive you selected is " + $global:SelectedDrive + ".`nDo not disconnect the drive until process finalised.","Data Backup Start",0) 
}

<#
[LEGACY CODE]

This code was in the original script, and relied solely on the PowerShell window only, it moved away to a Windows-based theme instead

    Write-Host "From the drives listed,"
    Write-Host "select the drive to backup"
    $global:DriveSelected = Read-Host "your data to"
    Write-Host ""
    Write-Host "Drive selected is" $global:SelectedDrive
#>

<#
[GOTO] _DirectoryStructurComposite
#>
