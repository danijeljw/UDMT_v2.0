<#
[FROM] _ExportOutlookSettings
#>

<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

# List of apps that need to be closed if they're currently open as an array
$global:CloseOpenApps = @("outlook","firefox","chrome","iexplore","winword","powerpnt","onenote","excel")

Get-Process $global:CloseOpenApps | ForEach-Object {$_.CloseMainWindow() }

# Variable Cleanup
Remove-Variable -Name CloseOpenApps -Scope Global -Force

<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

<#
[GOTO] _FileNamesNotCopiedTooLong
#>
