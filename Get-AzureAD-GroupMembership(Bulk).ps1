# Name: Get-AzureAD-GroupMembership (BULK)
# Author: Aaron Breeden
# Purpose: Get a list of members for each group in Azure AD

# Variables 
$cred = Get-Credential
$groupID = Get-Content C:\Path\To\Text_File

#create an empty array 
$resultsarray =@()

# connect to azure AD 
Connect-AzureAD -Credential $cred

# Foreach loop that loops through each group in groupID and stores the results in resultsarray
ForEach ($group in $groupID) {
$resultsarray += Get-AzureADGroupMember -ObjectId "$group" | select DisplayName,@{Expression={$group};Label="Group Name"}, @{n='Description';e={Get-AzureAdGroup -ObjectID "$group" | select DisplayName}}
}

# Pipe results from resultsarray to a csv file 
$resultsarray | Export-Csv -Path C:\scripts\grouplistresult.csv -NoTypeInformation
