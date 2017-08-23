Import-Module ActiveDirectory

$name = Get-ADUser -Identity bilst  -Properties * | Select-Object Surname

$name