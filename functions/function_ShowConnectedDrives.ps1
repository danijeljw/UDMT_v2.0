<#
[FROM] _QueryUSBDriveConnected
#>

# Show list of connected drives (physical/USB) to allow user to connect to one
function global:ShowConnectedDrives{

    # Clear the screen of text first
    Clear-Host
    Write-Host "The drives you currently have connected are:" -ForegroundColor Yellow -BackgroundColor DarkGray
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
    }
}
ShowConnectedDrives

<#
[GOTO] _DriveSelected
#>
