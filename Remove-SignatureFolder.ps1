# Name: Remove-SignatureFile
# Author: Aaron Breeden
# Purpose: Removes the Signatures folder within the Microsoft Outlook Client

# enumerate all user profiles within C:\users
$users = @(Get-ChildItem 'HKLM:\Software\Microsoft\Windows NT\currentVersion\ProfileList' |% {Get-ItemProperty $_.pspath})

# Loops through each user found on the machine 
foreach($user in $users.profileImagePath) { # begin foreach loop

# test to check if folder exists
$test = test-path -path "$user\appdata\Roaming\Microsoft\Signatures" 

    # if folder exsists remove all items from within the Signatures folder
    if ($test -eq "True") { #begin if statement
        Remove-Item -Path $user\appdata\Roaming\Microsoft\Signatures\* -Recurse -Force
    } # end if statement
} # end foreach loop
