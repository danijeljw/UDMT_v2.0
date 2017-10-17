<#
[FROM] _DirectoryStructureComposite
#>

<#
[CARRIED] $Global:TargetPath (ie - $Global:TargetPath = X:\ICT_USB_BACKUP_2017\IT12345)
[CARRIED] $Global:DirectoryComposite
#>

$Global:Outlook_Exported_Settings = "$Global:TargetPath\Users\$env:USERNAME\Desktop\Outlook_Exported_Settings.txt"

function global:ExportOutlookSettings{

    # NOTE: This launches Outlook if it is not already running!

    # Create OutlookProfileSettings Text File
    Out-File -FilePath $Global:Outlook_Exported_Settings -Force
    
    # Write settings to Outlook_Exported_Settings text file
    '****************************Currently attached archives' | Out-File $Global:Outlook_Exported_Settings -Append
    $Outlook = New-Object -Comobject Outlook.Application
    $Namespace = $Outlook.GetNamespace('MAPI')
    $Mailboxes = $Namespace.Stores | where {$_.ExchangeStoreType -eq 1} | Select-Object DisplayName
    $AttachedArchives = $Namespace.Stores | where {$_.ExchangeStoreType -eq 3} | Select-Object DisplayName,FilePath
    $MailBoxes | Out-File -FilePath $Global:Outlook_Exported_Settings -Append
    $AttachedArchives | Out-File -FilePath $Global:Outlook_Exported_Settings -Append


    # Write out mapped PST for Outlook 2007
    '****************************Archive History for Office 2007' | Out-File $Global:Outlook_Exported_Settings -Append
    If ((Test-Path HKCU:\software\Microsoft\Office\12.0\Outlook\Catalog) -eq $True){
        Get-Item HKCU:\software\Microsoft\Office\12.0\Outlook\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $Global:Outlook_Exported_Settings -Append
    }Else{
        'NO DATA EXISTS for Office 2007' | Out-File $Global:Outlook_Exported_Settings -Append
        '                              ' | Out-File $Global:Outlook_Exported_Settings -Append
    }


    # Write out mapped PST for Outlook 2010
    '****************************Archive History for Office 2010' | Out-File $Global:Outlook_Exported_Settings -Append
    If ((Test-Path HKCU:\software\Microsoft\Office\14.0\Outlook\Catalog) -eq $True){
        Get-Item HKCU:\software\Microsoft\Office\14.0\Outlook\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $Global:Outlook_Exported_Settings -Append
    }Else{
        'NO DATA EXISTS for Office 2010' | Out-File $Global:Outlook_Exported_Settings -Append
        '                              ' | Out-File $Global:Outlook_Exported_Settings -Append
    }


    # Write out mapped PST for Outlook 2013
    '****************************Archive History for Office 2013' | Out-File $Global:Outlook_Exported_Settings -Append
    If ((Test-Path HKCU:\software\Microsoft\Office\15.0\Outlook\Search\Catalog) -eq $True){
        Get-Item HKCU:\software\Microsoft\Office\15.0\Outlook\Search\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $Global:Outlook_Exported_Settings -Append
    }Else{
        'NO DATA EXISTS for Office 2013' | Out-File $Global:Outlook_Exported_Settings -Append
        '                              ' | Out-File $Global:Outlook_Exported_Settings -Append
    }

    # Write out mapped PST for Outlook 2016
    '****************************Archive History for Office 2016' | Out-File $Global:Outlook_Exported_Settings -Append
    If ((Test-Path HKCU:\software\Microsoft\Office\16.0\Outlook\Search\Catalog) -eq $True){
        Get-Item HKCU:\software\Microsoft\Office\16.0\Outlook\Search\Catalog | Select -ExpandProperty Property | where {$_ -match '.pst$'} | Out-File $Global:Outlook_Exported_Settings -Append
    }Else{
        'NO DATA EXISTS for Office 2013' | Out-File $Global:Outlook_Exported_Settings -Append
        '                              ' | Out-File $Global:Outlook_Exported_Settings -Append
    }

    # Variable Cleanup
    #Remove-Variable -Name Outlook_Exported_Settings -Scope Global -Force
    # not sure if i should leave this here or move it down?
}

<#
[CARRIED] $Global:TargetPath
[CARRIED] $Global:DirectoryComposite
#>

<#
[GOTO] _ExitApps
#>
