# Name: Get-AzureAD-GroupMembership (BULK)
# Author: Aaron Breeden
# Purpose: Get a list of members for each group in Azure AD

#Variables
$cred = Get-Credential
$filePath = \\your\path\here
$groupID = Get-Content $filePath\grouplist.txt

# creates an empty array
$resultsarray =@()

#connect to azure AD
Connect-AzureAD -Credential $cred

# Foreach loop to loop through each group and pull group membership 
ForEach ($group in $groupID) {
$resultsarray += Get-AzureADGroupMember -ObjectId "$group" | select DisplayName,@{n='Group Name';e={Get-AzureAdGroup -ObjectID "$group" | select -ExpandProperty DisplayName}}
}

# take resultsaaray and pipe results to a csv file - Place CSV where you want 
$resultsarray | Export-Csv -Path $filePath\grouplistresult.csv -NoTypeInformation

exit
