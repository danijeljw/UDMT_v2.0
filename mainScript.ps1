<#
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
#>


function global:ShowConnectedDrives{

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

    Start-Process -FilePath "listofdrives.txt" -WorkingDirectory "C:\Temp" 


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


ShowConnectedDrives






