# [FROM] function_DirectoryStructureComposite.ps1

$global:DriveSelected = $NULL
$global:CurrentYearOnly = (Get-Date).Year
$global:BasePath = $global:DriveSelected\ICT_USB_BACKUP_$global:CurrentYearOnly\$env:COMPUTERNAME

$global:OriginalPath = $NULL

$global:DirectoryComposite = @("Contacts",
                               "Desktop",
                               "Documents",
                               "Downloads",
                               "Favourites",
                               "Links",
                               "Music",
                               "Pictures",
                               "Searches")

# Backup UserData folder
Write-Host "Action 1 of Xc" -ForegroundColor Green
Write-Host "Copying UserData folder"
Copy-Item C:\UserData\* $global:BasePath\UserData -recurse

Write-Host "Action 2 of Xc" -ForegroundColor Green
Write-Host "Copying UserData folder"


Write-Host "Action 1 of Xc" -ForegroundColor Green
Write-Host "Copying UserData folder"
Write-Host "Action 1 of Xc" -ForegroundColor Green
Write-Host "Copying UserData folder"
Write-Host "Action 1 of Xc" -ForegroundColor Green
Write-Host "Copying UserData folder"

