# Name: Reset ESXi VM
# Author: Aaron Breeden
# Purpose: Reset VMware VM for Netlab Custom Pod
# Requirement: PowerCLI




# Required Variables

$vmhost = Read-Host -Prompt 'Input Name of Vmhost'
$user = Read-Host -Prompt 'Please enter your username'
$passwd = Read-Host -Prompt 'Please Type Your password'

# Connect to ESXi Host VM resides on

Connect-ViServer $vmhost -Protocol https -User $user -Password $passwd

# Get VM and store VM as a variable 

$vm = Read-Host -Prompt 'Please Enter Name of Vm You would like to change'
Get-VM $vm

#Show Output of Get-HardDisk

"$($i=Get-HardDisk $vm)"
Write-output $i

# Remove Harddisk 

$hd1 = Read-Host -Prompt 'Input name of first harddisk'
Get-Harddisk -VM $vm | Where-object {$_.FileName -like "*$hd1*"} | Remove-HardDisk

$hd2 = Read-Host -Prompt 'Input name of second harddisk' 
Get-Harddisk -VM $vm | Where-object {$_.FileName -like "*$hd2*"} | Remove-HardDisk

$hd3 = Read-Host -Prompt 'Input name of third hard disk'
Get-Harddisk -VM $vm | Where-object {$_.FileName -like "*$hd3*"} | Remove-HardDisk

#Refresh VM Variable 

Get-VM $vm

# Add New Hard Disks 

New-Harddisk -VM $vm -CapacityGB 50
New-Harddisk -VM $vm -CapacityGB 10 
New-Harddisk -VM $vm -CapacityGB 10 

#Refresh VM Variable 

Get-VM $vm

#Show Output of Get-HardDisk

"$($i=Get-HardDisk $vm)"
Write-output $i
