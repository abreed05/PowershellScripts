# Name: GetServerInfo
# Author: Aaron Breeden
# Purpose: Pull specific information for each server in an environment 

#Variables 
# Get list of servers 
$_serverCSV = (Get-Content -Path "C:\Temp\ServerList.txt")

# Loop through each server and pull system info 
$_output = foreach ($server in $_serverCSV) {
    Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $server | Format-Table -Property Name,Manufacturer,Model
    Get-CimInstance -ClassName Win32_Processor -ComputerName $server | Format-Table -Property DeviceID,Name
    Get-CimInstance -ClassName win32_networkadapterconfiguration -ComputerName $server | where {$_.IPAddress -ne $null} | select MACAddress, IPAddress
    Get-CimInstance -ClassName Win32_BIOS -ComputerName $server | Select-Object SerialNumber
    }
    
# Write to file 
$_output | Out-File -filepath C:\Temp\serverinfo.txt
