function global:ExportOutlookProfileSettings{

    #NOTE: This launches Outlook if it is not already running.
    
    '****************************Currently attached archives' | Out-File $Env:UserProfile\Desktop\ArchiveHistory.txt -append
    $Outlook = New-Object -Comobject Outlook.Application
    $Namespace = $Outlook.GetNamespace('MAPI')
    $Mailboxes = $Namespace.Stores | where {$_.ExchangeStoreType -eq 1} | Select-Object DisplayName
    $AttachedArchives = $Namespace.Stores | where {$_.ExchangeStoreType -eq 3} | Select-Object DisplayName,FilePath
    $MailBoxes | Out-File -FilePath $Env:UserProfile\Desktop\OutlookMailboxes.txt
    $AttachedArchives | Out-File -FilePath $Env:UserProfile\Desktop\OutlookAttachedArchives.txt


    '****************************Archive History for Office 2007' | Out-File $Env:UserProfile\Desktop\ArchiveHistory.txt -append
    get-item HKCU:\software\Microsoft\Office\12.0\Outlook\Catalog | select -expandProperty property | where {$_ -match '.pst$'} | Out-File $Env:UserProfile\Desktop\ArchiveHistory.txt


    '****************************Archive History for Office 2010' | Out-File $Env:UserProfile\Desktop\ArchiveHistory.txt -append
    get-item HKCU:\software\Microsoft\Office\14.0\Outlook\Catalog | select -expandProperty property | where {$_ -match '.pst$'} | Out-File $Env:UserProfile\Desktop\ArchiveHistory.txt


    '****************************Archive History for Office 2013' | Out-File $Env:UserProfile\Desktop\ArchiveHistory.txt -append
    get-item HKCU:\software\Microsoft\Office\15.0\Outlook\Search\Catalog | select -expandProperty property | where {$_ -match '.pst$'} | Out-File $Env:UserProfile\Desktop\ArchiveHistory.txt -append


    '****************************Archive History for Office 2016' | Out-File $Env:UserProfile\Desktop\ArchiveHistory.txt -append
    get-item HKCU:\software\Microsoft\Office\16.0\Outlook\Search\Catalog | select -expandProperty property | where {$_ -match '.pst$'} | Out-File $Env:UserProfile\Desktop\ArchiveHistory.txt -append
}

# From here go on to _ExitApps.ps1