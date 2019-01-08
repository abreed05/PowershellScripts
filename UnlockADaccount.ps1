# Name: Unlock AD Account
# Author: Aaron Breeden
# Purpose: Checks to see if the user account is unlocked and if so unlocks the AD account


# Variable to pull user information 

$account = Read-Host -Prompt 'Input Account Name'

# Check if account is locked out
$lockedOut = (Get-Aduser $account -Properties lockedout).LockedOut

# Unlock Account If true 
If ($lockedOut -eq $True) {
Unlock-ADAccount -Identity $account
Write-Host "Account has been unlocked"
}

# Condition if $lockedOut -eq $False

Else { Write-Host "Acount is not locked" 
}
