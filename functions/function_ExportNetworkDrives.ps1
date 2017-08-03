#[FROM] backup files and folders

#????????
$global:NetworkDrivesBat = $NULL
#????????
$global:BasePath = $global:DriveSelected\ICT_USB_BACKUP_$global:CurrentYearOnly\$env:COMPUTERNAME




function global:SaveNetworkDrives{

    # Write network drives to K:\PC_Migration\Drives.txt
    Get-WmiObject -Class:Win32_MappedLogicalDisk | Select name,providername > $global:BasePath\Drives.txt

    # Delete whitespace at end of each line
    Get-Content "K:\PC_Migration\Drives.txt" | ForEach-Object {$_.TrimEnd()} | Set-Content "K:\PC_Migration\Drives2.txt"

    # Replace gap in drive assignment and path
    Get-Content "K:\PC_Migration\Drives2.txt" | ForEach-Object { $_ -replace ':   ', ': ' } | Set-Content "K:\PC_Migration\Drives3.txt"

    # Add 'net use ' to start of each line
    Get-Content "K:\PC_Migration\Drives3.txt" | ForEach-Object {"net use " + $_ } | Set-Content "K:\PC_Migration\Drives4.txt"

    # Add ' /P' to end of each line for persistence of connection after restart
    Get-Content "K:\PC_Migration\Drives4.txt" | ForEach-Object {$_ + " /P" } | Set-Content "K:\Network_Drives.bat"

    # Clean up reduntant files
    Rm "K:\PC_Migration\*.txt"

    # Network drives saved notification
    Write-Host "Network drives saved to K:\Network_Drives.bat"
    Start-Sleep -s 5
    }
}

<#
[GOTO] _BackupNetworkDrives
#>