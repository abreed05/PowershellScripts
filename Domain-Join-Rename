# Name: Domain Join and Rename
# Author: Aaron Breeden
# Purpose: Join PC to an AD domain and also rename the machine

# Variables to be used in the script

$pcName = Read-Host "Please Enter PC Name" 
$domainName = Read-Host "Please Enter Domain Name"

# Join PC to Domain and Rename Computer

Add-computer -DomainName "$domainName" -NewName $pcName -Restart
