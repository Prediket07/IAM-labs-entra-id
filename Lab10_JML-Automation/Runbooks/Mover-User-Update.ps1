param(
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory=$true)]
    [string]$NewDepartment,

    [Parameter(Mandatory=$true)]
    [string]$NewJobTitle
)

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Groups

Write-Output "Starting Mover Automation"

Connect-MgGraph -Identity

# Get the user
$user = Get-MgUser -UserId $UserPrincipalName

# Update user attributes
Update-MgUser `
    -UserId $user.Id `
    -Department $NewDepartment `
    -JobTitle $NewJobTitle

Write-Output "Updated department to $NewDepartment and title to $NewJobTitle"

# Remove old group membership if moving from Sales
$oldGroup = Get-MgGroup | Where-Object { $_.DisplayName -eq "GG-Sales" }

if ($oldGroup) {
    Remove-MgGroupMemberByRef `
        -GroupId $oldGroup.Id `
        -DirectoryObjectId $user.Id `
        -ErrorAction SilentlyContinue

    Write-Output "Removed user from GG-Sales"
}

# Add new group membership if moving to Finance
if ($NewDepartment -eq "Finance") {

    $newGroup = Get-MgGroup | Where-Object { $_.DisplayName -eq "GG-Finance" }

    if ($newGroup) {
        New-MgGroupMemberByRef `
            -GroupId $newGroup.Id `
            -BodyParameter @{
                "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)"
            }

        Write-Output "Added user to GG-Finance"
    }
    else {
        Write-Output "Group GG-Finance not found"
    }
}

Write-Output "Mover automation completed successfully."
