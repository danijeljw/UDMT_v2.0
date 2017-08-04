###############################################################################################################
#                                                                                                             #
#                                                                                                             #
#                                                                                                             #
###############################################################################################################

# Init Form
Add-Type -AssemblyName System.Drawing 
Add-Type -AssemblyName System.Windows.Forms  

#Enables visual styles when run in PowerShell.exe
[System.Windows.Forms.Application]::EnableVisualStyles()


#Detect whether Active Directory Module is available. If not installed need to add as windows feature
If ((Get-Module -ListAvailable -Name ActiveDirectory) -eq $null)
{
  Write-Host 'ActiveDirectory module not detected' -ForegroundColor Red
  Exit
}
 
Import-Module -Name 'ActiveDirectory'

#Get user accounts from AD
$userids = Get-ADuser -searchbase $env:ADRestrictedAccounts -filter * -Properties name | Select-Object -ExpandProperty name | Sort-Object -Property $_.Name


#Create Form
$Form = New-Object -TypeName System.Windows.Forms.Form    
$Form.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (750,620)
$Form.StartPosition = 'CenterScreen'
$Form.SizeGripStyle = 'Show'
$Form.Text = ''
#$Form.BackColor = "Silver"

#Form label
$LabelFormTitle = New-Object -TypeName System.Windows.Forms.Label
$LabelFormTitle.Location = New-Object -TypeName System.Drawing.Size -ArgumentList (10,10)
$LabelFormTitle.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (140,18)
$LabelFormTitle.BorderStyle = 'None' #FixedSingle
$LabelFormTitle.Text = 'My Tool'
$Form.Controls.Add($LabelFormTitle)

#Tab Control 
$InitialFormWindowState = New-Object -TypeName System.Windows.Forms.FormWindowState
$TabControl = New-Object -TypeName System.Windows.Forms.TabControl
$TabControl.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object -TypeName System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 30
$tabControl.Location = $System_Drawing_Point
$tabControl.Name = 'tabControl'
$System_Drawing_Size = New-Object -TypeName System.Drawing.Size
$System_Drawing_Size.Height = 200
$System_Drawing_Size.Width = 700
$tabControl.Size = $System_Drawing_Size
$form.Controls.Add($tabControl)

#Output results
$outputBox = New-Object -TypeName System.Windows.Forms.TextBox
$outputBox.Location = New-Object -TypeName System.Drawing.Size -ArgumentList (10,250)
$outputBox.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (700,320)
$outputBox.MultiLine = $True
$outputBox.ScrollBars = 'Vertical'
$outputBox.font = 'lucida console, 9'
$form.Controls.Add($outputBox)
$outputBox.anchor = 
         [System.Windows.Forms.AnchorStyles]::Top `
    -bor [System.Windows.Forms.AnchorStyles]::Left `
    -bor [System.Windows.Forms.AnchorStyles]::Right `
    -bor [System.Windows.Forms.AnchorStyles]::Bottom


$BtnExitForm = New-Object -TypeName System.Windows.Forms.Button 
$BtnExitForm.Location = New-Object -TypeName System.Drawing.Size -ArgumentList (650,4)
$BtnExitForm.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (70,24)
$BtnExitForm.ForeColor = 'Red'
$BtnExitForm.Text = 'Exit' 
$BtnExitForm.Add_Click({ExitForm})
$Form.Controls.Add($BtnExitForm) 
$BtnExitForm.anchor = 
         [System.Windows.Forms.AnchorStyles]::Top `
    -bor [System.Windows.Forms.AnchorStyles]::Right

function ExitForm 
    {
        $Form.Dispose()
    }


$tab1 = New-Object -TypeName System.Windows.Forms.TabPage
$tab1.DataBindings.DefaultDataSourceUpdateMode = 0
$tab1.UseVisualStyleBackColor = $True
$tab1.Name = 'tab1'
$tab1.Text = 'User Information'
$tabControl.Controls.Add($tab1)

$Label1 = New-Object -TypeName System.Windows.Forms.Label
$Label1.Location = New-Object -TypeName System.Drawing.Size -ArgumentList (10,30)
$Label1.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (120,18)
$Label1.BorderStyle = 'None' #FixedSingle
$Label1.Text = 'Select user account'
$tab1.Controls.Add($Label1)


#Enter user id (drop down option)
$InputBoxUserID = New-Object -TypeName System.Windows.Forms.ComboBox
$InputBoxUserID.Location = New-Object -TypeName System.Drawing.Point -ArgumentList ($Label1.Left + 0), ($Label1.Top + 20)
$InputBoxUserID.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (150,30)
$InputBoxUserID.DropDownHeight = 500
$InputBoxUserID.ItemHeight = 50
$InputBoxUserID.Add_KeyDown({if ($_.KeyCode -eq 'Enter') {(UserInfo)}})
$tab1.Controls.Add($InputBoxUserID) 
foreach ($userid in $userids) 
{
  $InputBoxUserID.Items.Add($userid) *>$null 
}  #end foreach
$InputBoxUserID.AutoCompleteSource = [Windows.Forms.AutoCompleteSource]::CustomSource
$InputBoxUserID.AutoCompleteMode = [Windows.Forms.AutoCompleteMode]::SuggestAppend
$InputBoxUserID.AutoCompleteCustomSource.AddRange($userids)

$Button1 = New-Object -TypeName System.Windows.Forms.Button 
$Button1.Location = New-Object -TypeName System.Drawing.Size -ArgumentList (180,48) 
$Button1.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (100,24) 
$Button1.Text = 'Get User Info' 
$Button1.TextAlign = 'MiddleCenter'
$Button1.Add_Click({UserInfo})
$Button1.name='Button1'
$tab1.Controls.Add($Button1)

$tab2 = New-Object -TypeName System.Windows.Forms.TabPage
$tab2.DataBindings.DefaultDataSourceUpdateMode = 0
$tab2.UseVisualStyleBackColor = $True
$tab2.Name = 'tab2'
$tab2.Text = 'Computer information'
$tabControl.Controls.Add($tab2)

$Label2 = New-Object -TypeName System.Windows.Forms.Label
$Label2.Location = New-Object -TypeName System.Drawing.Size -ArgumentList (10,30)
$Label2.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (120,18)
$Label2.BorderStyle = 'None' #FixedSingle
$Label2.Text = 'Enter computer name'
$tab2.Controls.Add($Label2)

$InputBoxComputer = New-Object -TypeName System.Windows.Forms.TextBox
$InputBoxComputer.Location = New-Object -TypeName System.Drawing.Size -ArgumentList (10,50)
$InputBoxComputer.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (160,30)
#$InputBoxComputer.DropDownHeight = 500
$tab2.Controls.Add($InputBoxComputer)

$Button2 = New-Object -TypeName System.Windows.Forms.Button 
$Button2.Location = New-Object -TypeName System.Drawing.Point -ArgumentList ($InputBox2.Right + 10), ($InputBox2.Top - 2)
$Button2.MaximumSize = New-Object -TypeName System.Drawing.Size -ArgumentList (0,24)
$Button2.AutoSize = 'True'
$Button2.Font = New-Object -TypeName System.Drawing.Font -ArgumentList ('Microsoft Sans Serif',8.5)
$Button2.Text = 'C$'
$Button2.Add_Click({CDollar})
$Button2.name='Button2'
$Button2.BackColor = '#e1e1e1'
$tab2.Controls.Add($Button2) 



function CDollar 
    {
        $computer=$InputBox2.text
        $path = "\\$computer\c$"
        Write-Host ($outputBox.text= 'Attempting to connect to remote computer...')
        Start-Sleep -Seconds 1

        If (!(Test-Connection -ComputerName $computer -Count 1 -Quiet)) 
            {
                Write-Host ($outputBox.text=('Failed to connect, error or {0} not on network' -f $computer)) {break}
            }
        Else
            {
                Write-Host ($outputBox.text= ('Connecting to computer {0}...' -f $computer))
                Invoke-item -Path $path
                Write-Host ($outputBox.text=('Successfully connected to {0}' -f $computer))
            }
    }


function UserInfo 
{
  $userid=$InputBoxUserID.text
 
  Write-Host ($outputBox.text= 'Retrieving information, please wait...') 
  $userinfo=Get-ADUser -identity $userid -properties Name, sAMAccountName, UserPrincipalName, DisplayName, mail, title, Description, physicalDeliveryOfficeName, manager, telephoneNumber, mobile, lastlogon, pwdlastset, otherpager, otheripphone, ObjectGUID, AdminDescription, comment, displaynameprintable, networkaddress | 
  Select-Object -Property Name, sAMAccountName, UserPrincipalName, DisplayName, mail, title, Description, physicalDeliveryOfficeName, @{label='Manager'
  expression={$_.manager -replace '^CN=|,.*$'}}, telephoneNumber, mobile, @{N='LastLogon'
  E={[DateTime]::FromFileTime($_.LastLogon)}}, @{N='pwdlastset'
  E={[DateTime]::FromFileTime($_.pwdlastset)}}, otherpager, otheripphone, @{L='adminDescription'
  E={$_.adminDescription}}, ObjectGUID, networkaddress, comment, displaynameprintable, @{l='Parent'
  e={(New-Object -TypeName 'System.DirectoryServices.directoryEntry' -ArgumentList "LDAP://$($_.DistinguishedName)").Parent}}
  If (!($userinfo)) 
  { 
    Write-Host ($outputBox.text=('UserID {0} does not exist' -f $userid))
  }
  Else 
  {
    Start-sleep -milliseconds 180
    Write-Host ($outputBox.text=$userinfo | Format-list | Out-string)
    $userinfo | Export-csv -path $env:userinfo -NoTypeinformation
  }
}



######### ACTIVATE FORM

$Form.Add_Shown({$Form.Activate()})
$null =  $Form.ShowDialog()

######### END FORM