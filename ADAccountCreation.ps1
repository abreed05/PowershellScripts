# Name: AutomateADCreation
# Author: Aaron Breeden
# Purpose: Create AD users and fill in basic information for user accounts in AD

# Variables For The Script
$pathToCsv = Read-Host "Please enter path to CSV"
$ou = "OU=Company Users,DC=testlab,DC=pri"
$import = Import-Csv -Path "$pathToCsv"

# Foreach Loop To loop through the CSV file

foreach ($user in $import) {
$password = $user.password | ConvertTo-Securestring -AsPlainText -Force
New-ADuser -Name $user.name -GivenName $user.firstname -Surname $user.lastname -Path $ou -AccountPassword $password -OtherAttributes @{'title'=$user.title;'mail'=$user.mail} -ChangePasswordAtLogon $True -Enabled $True }
