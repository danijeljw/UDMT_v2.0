function global:ExitClause{
    Clear-Host
    [console]::beep(2000,500)
    [console]::beep(2000,500)
    [console]::beep(2000,500)
    Write-Host ""
    Write-Host "Invalid entry received!" -ForegroundColor Red -BackgroundColor Black
    Write-Host ""
    Write-Host "Exiting script!" -ForegroundColor DarkYellow -BackgroundColor Black
    Start-Sleep -s 5
    exit
}