<#
[FROM] ExportNetworkDrives
#>


<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

function global:ExportNetworkPrinters{
    Get-WMIObject Win32_Printer -ComputerName $env:COMPUTERNAME | where{$_.Name -like “*\\*”} | select name | Out-File "$global:TargetPath\Printers.txt" -Append
}

<#
[GOTO] Done
#>