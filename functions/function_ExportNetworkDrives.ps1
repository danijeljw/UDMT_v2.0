<#
[FROM] BackupFilesAndFolders
#>


<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>


function global:ExportNetworkDrives{
    # Write network drives to K:\PC_Migration\Drives.txt
  "$global:TargetPath\Drives1.txt"

    # Delete whitespace at end of each line
    Get-Content "$global:TargetPath\Drives1.txt" | ForEach-Object {$_.TrimEnd()} | Set-Content "$global:TargetPath\Drives2.txt"

    # Replace gap in drive assignment and path
    Get-Content "$global:TargetPath\Drives2.txt" | ForEach-Object { $_ -replace ':   ', ': ' } | Set-Content "$global:TargetPath\Drives3.txt"

    # Add 'net use ' to start of each line
    Get-Content "$global:TargetPath\Drives3.txt" | ForEach-Object {"net use " + $_ } | Set-Content "$global:TargetPath\Drives4.txt"

    # Add ' /P:Yes' to end of each line for persistence of connection after restart
    Get-Content "$global:TargetPath\Drives4.txt" | ForEach-Object {$_ + " /P:Yes" } | Set-Content "$global:TargetPath\Drives.bat"

    # Clean up reduntant files
    Remove-Item "$global:TargetPath\Drives*.txt" -Force
}

<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

<#
[GOTO] _ExportNetworkPrinters
#>




<#

REMOVE BLANK LINES
$r | ? {$_.trim() -ne ""}


THEN ACTION OVER VARIABLES PRE-SET
$s = ($r | ? {$_.trim() -ne ""}) 
#>