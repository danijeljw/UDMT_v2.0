<#
[FROM] _DirectoryStructureComposite
#>

<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

$global:Outlook_Exported_Settings = "$global:TargetPath\Users\$env:USERNAME\$global:DirectoryComposite[1]\Outlook_Exported_Settings.txt"

function global:ExportOutlookSettings{

    # NOTE: This launches Outlook if it is not already running!

    # Create OutlookProfileSettings Text File
    Out-File -FilePath $global:Outlook_Exported_Setting -Force
    
    # Write settings to Outlook_Exported_Settings text file
    '****************************Currently attached archives' | Out-File $global:Outlook_Exported_Settings -Append
    $Outlook = New-Object -Comobject Outlook.Application
    $Namespace = $Outlook.GetNamespace('MAPI')
    $Mailboxes = $Namespace.Stores | where {$_.ExchangeStoreType -eq 1} | Select-Object DisplayName
    $AttachedArchives = $Namespace.Stores | where {$_.ExchangeStoreType -eq 3} | Select-Object DisplayName,FilePath
    $MailBoxes | Out-File -FilePath $global:Outlook_Exported_Setting -Append
    $AttachedArchives | Out-File -FilePath $global:Outlook_Exported_Setting -Append

    # Write out mapped PST for Outlook 2007
    '****************************Archive History for Office 2007' | Out-File $global:Outlook_Exported_Settings -Append
    Get-Item HKCU:\software\Microsoft\Office\12.0\Outlook\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $global:Outlook_Exported_Settings -Append

    # Write out mapped PST for Outlook 2010
    '****************************Archive History for Office 2010' | Out-File $global:Outlook_Exported_Settings -Append
    Get-Item HKCU:\software\Microsoft\Office\14.0\Outlook\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $global:Outlook_Exported_Settings -Append

    # Write out mapped PST for Outlook 2013
    '****************************Archive History for Office 2013' | Out-File $global:Outlook_Exported_Settings -Append
    Get-Item HKCU:\software\Microsoft\Office\15.0\Outlook\Search\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $global:Outlook_Exported_Settings -Append

    # Write out mapped PST for Outlook 2016
    '****************************Archive History for Office 2016' | Out-File $global:Outlook_Exported_Settings -Append
    Get-Item HKCU:\software\Microsoft\Office\16.0\Outlook\Search\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $global:Outlook_Exported_Settings -Append

    # Variable Cleanup
    Remove-Variable -Name Outlook_Exported_Settings -Scope Global -Force
}

<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

<#
[GOTO] _ExitApps
#>
