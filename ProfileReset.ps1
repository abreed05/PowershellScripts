# Name: ProfileReset
# Author: Aaron Breeden
# Purpose: Reset user profile, this script is designed to be run on a users machine

# Define All Variables 

# Username and Domain Name Variables
$_userName = Read-Host -Prompt "Enter username"
$_domain = Read-Host -Prompt "Enter Name of Domain"

# Source and destination variables 
$_sourceRoot = "C:\users\$_userName"
$_sourceDest = "C:\Backup"

# User Profile Data To Be Backup up 
$_foldersToCopy = @(
    'Desktop'
    'Downloads'
    'Favorites'
    'Documents'
    'Pictures'
    'Videos'
    )
    
# SID Variable 
$_sid =([wmi] "win32_userAccount.Domain='$_domain',Name='$_userName'").SID.Value

# Begin Script 

# Delete Profile Registry Key 
If (Test-Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Profilelist\$_sid") {
  Write-Host "Found $_userName"
  Write-Host "Removing Profile Key"
  Remove-Item "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Profilelist\$_sid" -Recurse
}
Else {Write-Host "User SID does not exist"}

# If statement to check for backup path and create folder if it does not exit 
If (-Not (Test-Path $_sourceDest)) {
    Write-Host "Path does not exist. Creating now"
    New-Item $_sourceDest -ItemType directory
 }
 Else {Write-Host "Backup folder exists!"}
 
 # Back up user data 
 foreach($folder in $_foldersToCopy) {
    $_source = Join-Path -Path $_sourceRoot -ChildPath $folder
    $_destination = Join-Path -Path $_sourceDest -ChildPath $folder
    robocopy.exe $_source $_destination /E /IS /NP /NFL 
    }
    
 # Rename Profile 
 Rename-Item C:\Users\$_userName C:\Users\$_userName.old
 
