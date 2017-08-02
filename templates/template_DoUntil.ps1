Clear-Host
$strPassword ="123"
$strQuit = "Not yet"
Do {
$Guess = Read-Host "`n Guess the Password"
if($Guess -eq $StrPassword)
{" Correct guess"; $strQuit ="n"}
   else{
     $strQuit = Read-Host " Wrong `n Do you want another guess? (Y/N)"
         }
      } # End of 'Do'
Until ($strQuit -eq "N")