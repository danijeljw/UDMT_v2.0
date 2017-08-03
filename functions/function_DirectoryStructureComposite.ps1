<#
[FROM] _DriveSelected
#>

<#
[CARRIED] $global:SelectedDrive
#>

$global:CurrentYearOnly = (Get-Date).Year
$global:TargetPath = "$global:SelectedDrive\ICT_USB_BACKUP_$global:CurrentYearOnly\$env:COMPUTERNAME"
# ie - $global:TargetPath = X:\ICT_USB_BACKUP_2017\IT12345
$global:DirectoryComposite = @("Contacts",
                               "Desktop",
                               "Documents",
                               "Downloads",
                               "Favourites",
                               "Links",
                               "Music",
                               "Pictures",
                               "Searches")

If ( Test-Path $global:DriveSelected\ICT_USB_BACKUP_$global:CurrentYearOnly\$env:COMPUTERNAME ) {
    # beeps to alert user
    [console]::beep(2000,500)
    [console]::beep(2000,500)
    [console]::beep(2000,500)
    Write-Host "UDMT Folder Structure Exists!" -BackgroundColor Black -ForegroundColor DarkCyan
} else {
    # Make the X:\ICT_USB_BACKUP_2017\ITxxxxx\UserData folder
    New-Item $global:BasePath\UserData  -ItemType Directory -Force
    # Create an Outlook signatures folder
    New-Item $global:BasePath\Users\AppData\Roaming\Microsoft\Signatures -ItemType Directory -Force
    # Using folders listed in the array $global:DirectoryComposite create personal user data store tree
    ForEach ( $x in $global:DirectoryComposite ){
        New-Item $global:BasePath\Users\$env:USERNAME\$_ -ItemType Directory -Force
    }
    
}