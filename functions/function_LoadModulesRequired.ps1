function global:LoadModulesRequired{
    Try
    {
      Import-Module ActiveDirectory -ErrorAction Stop
    }
    Catch
    {
      Write-Host ""
      Write-Warning "ActiveDirectory Module couldn't be loaded. Exiting!"
      Start-Sleep -s 5
      Exit 1
    }
}