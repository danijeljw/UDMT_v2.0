# Display output for user in pop-up
$output =  "Public IP address is"
$output1 = "ComputerName is "
$output2 = "Local IP Address is"
[System.Windows.Forms.MessageBox]::Show($output1 + $output2 +"     "+ $output,"IP Address",0) 

# capture input and assign to variable from userinput
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$name = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your name", "Name", "$env:username")
"Your name is $name$"