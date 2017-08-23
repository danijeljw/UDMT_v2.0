Import-Module activedirectory
Import-Module "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
CD CBD:

$Global:RemovePC = 'IT51095'

get-aduser -identity 'stephd20'
break

Get-ADComputer -identity $Global:RemovePC | Remove-ADComputer -Confirm:$false
Remove-CMDevice -DeviceName $Global:RemovePC