# Name: InitializeDisk
# Author: Aaron Breeden
# Purpose: Initialize all raw disks on a server 

# Variables 
$pcName = read-host "Enter Remote Server Name"
$format = read-host "Enter Format Type"

Invoke-Command -ScriptBlock {

  Get-Disk |
    Where-Object PartitionStyle -eq 'raw' | 
      Initialize-Disk -Passthru | 
        New-Partition -UseMaximumSize -AssignDriveLetter | 
          Format-Volume -FileSystem $format

} -ComputerName $pcName
