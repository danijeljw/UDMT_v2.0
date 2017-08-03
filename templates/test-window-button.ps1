[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#create a pop up diaglog box
$objForm = New-Object System.Windows.Forms.Form
$objForm.Text = "Powershell Script Entry pop-up diaglog box"
$objForm.Size = New-Object System.Drawing.Size(400,500)
$objForm.StartPosition = "CenterScreen"
$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter")
    {$x=$objTextBox.Text;$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
    {$objForm.Close()}})
#create a OK button
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(100,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$x=$objTextBox.Text;$objForm.Close()})
$objForm.Controls.Add($OKButton)
#create a Cancel button
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(200,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)
#Create a text box for input
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20)
$objLabel.Size = New-Object System.Drawing.Size(280,20)
$objLabel.Text = "Please enter the information in the space below:"
$objForm.Controls.Add($objLabel)
$objTextBox = New-Object System.Windows.Forms.TextBox
$objTextBox.Location = New-Object System.Drawing.Size(40,60)
$objTextBox.Size = New-Object System.Drawing.Size(260,40)
$objForm.Controls.Add($objTextBox)

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()
$x = {$a = Read-Host
Write-Host "You are running $a"
Write-Host "Start!"
powershell.exe –noexit .\$a
}