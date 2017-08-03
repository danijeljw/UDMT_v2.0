﻿<#
[FROM] _ExitApps
#>

<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

$global:TooLongFileNamesUserData = $NULL
$global:TooLongFileNamesUsersUserID = $NULL

function global:FileNamesNotCopiedTooLong{
    "*****Files from C:\UserData*****" | Out-File "$global:TargetPath\FilesNotCopied.txt" -Append
    cmd /c "dir /b /s /a:d C:\UserData" | ForEach-Object{
        If ( $_.length -gt 250 ){
            $_ | Out-File "$global:TargetPath\FilesNotCopied.txt"
        }
    "*****Files from C:\Users\$env:USERNAME\Contacts*****" | Out-File "$global:TargetPath\FilesNotCopied.txt" -Append
    cmd /c "dir /b /s /a:d C:\UserData\$env:USERNAME\Contacts" | ForEach-Object{
        If ( $_.length -gt 250){
            $_ | Out-File "$global:TargetPath\FilesNotCopied.txt"
        }
    "*****Files from C:\Users\$env:USERNAME\Desktop*****" | Out-File "$global:TargetPath\FilesNotCopied.txt" -Append
    cmd /c "dir /b /s /a:d C:\UserData\$env:USERNAME\Desktop" | ForEach-Object{
        If ( $_.length -gt 250){
            $_ | Out-File "$global:TargetPath\FilesNotCopied.txt"
        }
    "*****Files from C:\Users\$env:USERNAME\Documents*****" | Out-File "$global:TargetPath\FilesNotCopied.txt" -Append
    cmd /c "dir /b /s /a:d C:\UserData\$env:USERNAME\Documents" | ForEach-Object{
        If ( $_.length -gt 250){
            $_ | Out-File "$global:TargetPath\FilesNotCopied.txt"
        }
    "*****Files from C:\Users\$env:USERNAME\Downloads*****" | Out-File "$global:TargetPath\FilesNotCopied.txt" -Append
    cmd /c "dir /b /s /a:d C:\UserData\$env:USERNAME\Downloads" | ForEach-Object{
        If ( $_.length -gt 250){
            $_ | Out-File "$global:TargetPath\FilesNotCopied.txt"
        }
    "*****Files from C:\Users\$env:USERNAME\Favourites*****" | Out-File "$global:TargetPath\FilesNotCopied.txt" -Append
    cmd /c "dir /b /s /a:d C:\UserData\$env:USERNAME\Favourites" | ForEach-Object{
        If ( $_.length -gt 250){
            $_ | Out-File "$global:TargetPath\FilesNotCopied.txt"
        }
    "*****Files from C:\Users\$env:USERNAME\Links*****" | Out-File "$global:TargetPath\FilesNotCopied.txt" -Append
    cmd /c "dir /b /s /a:d C:\UserData\$env:USERNAME\Links" | ForEach-Object{
        If ( $_.length -gt 250){
            $_ | Out-File "$global:TargetPath\FilesNotCopied.txt"
        }
    "*****Files from C:\Users\$env:USERNAME\Music*****" | Out-File "$global:TargetPath\FilesNotCopied.txt" -Append
    cmd /c "dir /b /s /a:d C:\UserData\$env:USERNAME\Music" | ForEach-Object{
        If ( $_.length -gt 250){
            $_ | Out-File "$global:TargetPath\FilesNotCopied.txt"
        }
    "*****Files from C:\Users\$env:USERNAME\Pictures*****" | Out-File "$global:TargetPath\FilesNotCopied.txt" -Append
    cmd /c "dir /b /s /a:d C:\UserData\$env:USERNAME\Pictures" | ForEach-Object{
        If ( $_.length -gt 250){
            $_ | Out-File "$global:TargetPath\FilesNotCopied.txt"
        }
    "*****Files from C:\Users\$env:USERNAME\Searches*****" | Out-File "$global:TargetPath\FilesNotCopied.txt" -Append
    cmd /c "dir /b /s /a:d C:\UserData\$env:USERNAME\Searches" | ForEach-Object{
        If ( $_.length -gt 250){
            $_ | Out-File "$global:TargetPath\FilesNotCopied.txt"
        }
}




<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

<#
[GOTO] _BackupFilesAndFolders
#>
