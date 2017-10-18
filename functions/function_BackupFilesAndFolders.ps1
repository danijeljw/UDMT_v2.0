<#
[FROM] _FileNamesNotCopiedTooLong
#>


<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>


function global:BackupFilesAndFolders{

    # Backup UserData folder
    Copy-Item C:\UserData\* $global:BasePath\UserData -Recurse -Force

    # Backup $DirectoryComposite folders
    ForEach ( $r in $global:DirectoryComposite ){
        Copy-Item "$env:USERPROFILE\$r\*" "$global:BasePath\$r" -Recurse -Force
    }
}

<#
[CARRIED] $global:TargetPath
[CARRIED] $global:DirectoryComposite
#>

<#
[GOTO] _ExportNetworkDrives
#>