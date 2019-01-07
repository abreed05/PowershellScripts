# Pull user information 

$Account = Read-Host -Prompt 'Input Account Name'

# Check if account is locked out
$LockedOut = (Get-Aduser $Account -Properties lockedout).LockedOut

# Unlock Account If true 
If ($LockedOut -eq $True) {
Unlock-ADAccount -Identity $Account
Write-Host "Account has been unlocked"
}
Else { Write-Host "Acount is not locked" 
}
