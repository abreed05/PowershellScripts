# Name: Network_Troubleshooting
# Author: Aaron Breeden 
# Purpose: A simple script to test various network functionality including LAN, WAN, internal and public DNS. 
#          This script will also attempt to fix issues it finds and logs a test results file to the users desktop. 

# Variables 
$_host1 = "IP.IntenralDNS.Server."
$_host2 = "Ip.Seconday.DNS.Server"
$_host3 = "FQDN.Somehost.local"

$filePath = "$env:USERPROFILE\Desktop\TestResults.txt"
$date = Get-Date
# Functions 

# Function To Test Gateway
Function Test-Gateway {Test-Connection -ComputerName (Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty NextHop) -Quiet}

# Function To Test Lan Connectivity and Inernal DNS
Function Test-Lan {Test-Connection -ComputerName $_host1, $_host2, $_host3 -Quiet }

# Function To Test WAN Connectivity
Function Test-Wan {Test-connection -computername 8.8.8.8 -Quiet }

# Function To Test Public DNS
Function Test-DNS {Test-connection -computername www.google.com -Quiet }

# Function To Release / Renew DHCP Address 
Function Reset-IP {( Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq "Win32_NetworkAdapterConfiguration"} ).InvokeMethod("ReleaseDHCPLeaseAll", $null)
                   ( Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq "Win32_NetworkAdapterConfiguration"} ).InvokeMethod("RenewDHCPLeaseAll", $null)}

# Function To Reset Network Adapter (Set to Wireless adapter by default but can be changed to fit needs)
Function Reset-NetworkAdapter {Disable-NetAdapter -Name Wi-Fi -Confirm:$false
                               Netsh Winsock Reset
                               Enable-NetAdapter -Name Wi-Fi -Confirm:$false }

Add-Content -Path $filePath "Starting tests at $date "

# Tests for an APIPA address. If APIPA is confirmed will attempt to release / renew DHCP using the Reset-IP function
$ipv4 = Test-Connection -ComputerName 172.16.100.7 -Count 1 | select -ExpandProperty IPv4Address
if ($ipv4.IPAddressToString -Like "*169.254*" ) { 
                                                 Write-host "BAD IP"
                                                 write-host "Attempting to renew IP Address "
                                                 Reset-IP
                                                 Add-Content -path $filePath "`nAPIPA Address fonund Attempted fix" }
Else {Write-Host "Getting an expected IP"
      Add-Content -path $filePath "`nGetting an expected IP address"
      }

# Ping Gateway
If (Test-Gateway -eq true) {
    write-host "Gateway pings successful"
    Add-Content -path $filePath "`nGateway test passed"
}

Else {write-host "Gateway test failed"
      Add-Content -path $filePath "`nGateway test failed"}

# Test Lan Connectivity 

If (Test-Lan -eq true) {
    write-host "Lan test successful"
    Add-Content -path $filePath "`nLan test passed"
}

Else {write-host "Lan test failed"
      Add-Content -path $filePath "`nLAN test failed"
      
}

# Perfrom wan test 
If (Test-Wan -eq true) {
    Write-host "You have wan connectivity" 
    Add-Content -path $filePath "`nWAN test passed"
}
Else {write-host "WAN test failed"
      Reset-IP
      Reset-NetworkAdapter
      Test-Gateway
      Test-Lan
      Test-Wan
      Add-Content -path $filePath "`nWan test failed, attempted to reset IP and Network adapter"}

# Perform public DNS test
If (Test-DNS -eq true) {
    Write-host "DNS is resolving as expected"
    Add-Content -path $filePath "`nPublic DNS test passed" 
}
Else {write-host "DNS test failed, flushing DNS"
      ipconfig /flushdns
      Test-DNS
      Add-Content -path $filePath "`nPublic DNS test failed. Flushed DNS cache"}




