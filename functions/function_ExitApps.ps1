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

<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

<#
[GOTO] _FileNamesNotCopiedTooLong
#>
