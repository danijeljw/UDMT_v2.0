# What transfer service being used?
#
# 1. Direct Transfer - Both machines on network at once
# 2. USB Transfer - Using external USB drive
# 3. Network Transfer - Backup to network, then download to replacement machine

$global:TransferType = $NULL
$global:USBDriveLetter = $NULL

function global:CreateBackupFolderStructure{
    New-Item $DrivePath\$env:COMPUTERNAME
    }

function global:CurrentMachineName{
    $env:COMPUTERNAME
    }

function global:TargetMachineName{
    Set-Variable -Name "TargetMachine" -Value (Read-Host "Target machine IT number") 

<#
=======================
    USER MIGRATION TOOL
    START HERE
=======================
#>


$menu=@"
  1   Direct Transfer - Both machines on network at once
  2   USB Data Backup
  3   USB Data Restore
  4   Network Transfer
	  
 Select a task by number or 'Q' to quit
"@

Function Invoke-Menu {
[cmdletbinding()]
Param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter your menu text")]
[ValidateNotNullOrEmpty()]
[string]$Menu,
[Parameter(Position=1)]
[ValidateNotNullOrEmpty()]
[string]$Title = "My Menu",
[Alias("cls")]
[switch]$ClearScreen
)
 
#clear the screen If requested
If ($ClearScreen) { 
 Clear-Host 
}
 
#build the menu prompt
$menuPrompt = $title
#add a return
$menuprompt+="`n"
#add an underline
$menuprompt+="-"*$title.Length
#add another return
$menuprompt+="`n"
#add the menu
$menuPrompt+=$menu
 
Read-Host -Prompt $menuprompt
 
} #end function

Do {
    # use a Switch construct to take action depending on what menu choice is selected
    Switch (Invoke-Menu -menu $menu -title " User Migration Tool v2.0 " -clear) {
        "1"{
            
        }
        "2"{
            # Set the USB Drive letter
            $USBDriveLetter = Read-Host "Enter letter of USB drive for backup"

            # Make necessary folder structure for backup
        }
        "3"{
        }
        "4"{
            #
        }
            