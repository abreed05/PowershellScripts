# Name: NewStoragePool
# Author: Aaron Breeden
# Purpose: Create a new storage pool on Windows Server

# Variables 
$disks = Get-StoragePool -IsPrimordial $true | 
  Get-PhysicalDisk | Where-Object CanPool -eq $True
$storageSubSystem = Get-StorageSubSystem 
$storagePoolFN = Read-Host "Enter Storage Pool Friendly Name"
$virtualDiskFN = read-host "Enter Virtual Disk Friendly Name"

# Create New Storage Pool

New-StoragePool -FriendlyName $storagePoolFN `
-StorageSubSystemFriendlyName $storageSubsystem.FriendlyName `
-PhysicalDisks $disks

# Create New Virtual Disk 

New-VirtualDisk -FriendlyName $virtualDiskFN `
-StoragePoolFriendlyName $storagePoolFN `
-ResiliencySettingName Mirror `
-ProvisioningType Fixed `
-NumberofDataCopies 2 `
-UseMaximumSize

# Verify Creation of Storage Pool

Get-VirtualDisk -FriendlyName $virtualDiskFN |
  Get-Disk | Initialize-Disk -Passthru | 
    New-Partition -AssignDriveLetter -UseMaximumSize | 
      Format-Volume -FileSystem NTFS 
