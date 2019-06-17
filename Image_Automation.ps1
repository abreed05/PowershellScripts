# Set execution Policy 
Set-ExecutionPolicy unrestricted 

# create scheduled task that runs a second script on next logon

$ta = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-File C:\scripts\SecondScript.ps1'
$tt = New-ScheduledTaskTrigger -AtLogOn
$tp = New-ScheduledTaskPrincipal -UserId "Domain\domainadminaccount"
$ts = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
$tn = New-ScheduledTask -Action $ta -Principal $tp -Trigger $tt -Settings $ts
Register-ScheduledTask T1 -InputObject $tn 

# create second script before reboot 

Write-Host "Creating Script to run at next logon"
$userAccount = read-host "Enter username to be added to local administrators "
New-Item -Path C:\scripts -Name "SecondScript.ps1" -ItemType "file"
Add-content -Path C:\scripts\SecondScript.ps1 "Add-LocalGroupMember -Group `"Administrators`" -Member `"domain\$userAccount`""
Add-content -Path C:\scripts\SecondScript.ps1 "`nAdd-LocalGroupMember -Group `"Administrators`" -Member `"domain\localadministratoraccount`""
Add-content -Path C:\scripts\SecondScript.ps1 "`nUnregister-ScheduledTask -TaskName T1 -Confirm:$false"
Add-content -Path C:\scripts\SecondScript.ps1 "Remove-Item -Path `"C:\scripts`" -Force -Recurse"

# Rename and Domain Join computer 

write-host "Renaming computer and joining to domain"
$pcName = read-host "Enter desired computer name " 
$creds = Get-Credential
Add-computer -NewName $pcName -DomainName domain.name -Credential $creds -restart
