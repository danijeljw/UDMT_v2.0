# Temp network directory to store files
$TempNetworkStore = $NULL

# Current computer name
$CurrentPCName = $env:COMPUTERNAME

# Replacement computer name
$ReplacementPCName = (Write-Host "Name of new computer")

# Save network drives function
function SaveNetworkDrives{

    # Test if migrating To or From and execute as required
    If( Test-Path K:\Network_Drives.bat -eq $TRUE ){
        Write-Host "Network Drives list exist"
        Write-Host "Adding Network Drives back to PC"
        CMD.exe /c 'K:\Network_Drives.bat'
    }Else{
        # Write network drives to K:\PC_Migration\Drives.txt
        Get-WmiObject -Class:Win32_MappedLogicalDisk | Select name,providername > K:\PC_Migration\Drives.txt

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

# Back up C:\UserData
Copy-Item C:\UserData\* "$TempNetworkStore\$CurrentPCName"

# Back up User Profile main structure
Copy-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Signatures\*" "$TempNetworkStore\$CurrentPCName"

