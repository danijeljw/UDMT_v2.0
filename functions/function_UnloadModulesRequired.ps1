function global:UnloadModules{
    If(Get-Module ActiveDirectory){
        Remove-Module ActiveDirectory
    }
}
