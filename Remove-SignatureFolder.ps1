# enumerate all user profiles within C:\users
$users = @(Get-ChildItem 'HKLM:\Software\Microsoft\Windows NT\currentVersion\ProfileList' |% {Get-ItemProperty $_.pspath})

# for each loop to loop through each folder found in C:\users
foreach($user in $users.profileImagePath) { # begin foreach loop

# test to check if folder exists
$test = test-path -path "$user\appdata\Roaming\Microsoft\Signatures" 

    # if folder exsists remove all items from within the Signature folder
    if ($test -eq "True") { #begin if statement
        Remove-Item -Path $user\appdata\Roaming\Microsoft\Signatures\* -Recurse -Force
    } # end if statement
} # end foreach loop
