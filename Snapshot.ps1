# Name: Snapshot
# Author: Aaron Breeden
# Purpose: Check if specific snapshot exists on VMWARE ESXi and if not create it 
# Requirements: PowerCLI v.11 

# Variables that can be changed
$snapshot = 'GOLDEN_SNAPSHOT'
$desc = "GOLDEN_SNAPSHOT CREATED ON $(Get-Date -Format 'u')"

# ---- DO NOT CHANGE VARIABLES BELOW THIS LINE ----

# Connect to host
$vmhost = Read-Host -Prompt 'Input IP or FQDN of host'
$user = Read-Host -Prompt 'Input Username'
$passwd = Read-Host -Prompt 'Input Password'

Connect-VIServer $vmhost -Protocol https -User $user -Password $passwd

# Get VMs
$vms = Get-VM

# Loop through each VM, Check if Snapshot exists and if not create it 
ForEach ($vm in $vms) {
$snapshotExists = $null
$snapshotExists = $vm | Get-Snapshot -Name $snapshot -ea SilentlyContinue

# If else statement 
If ($snapshotExists -eq $null) {$vm | New-Snapshot -Name $snapshot -Description $desc}
Else {Write-Host "$vm snapshot $snapshot already exists "}
}
