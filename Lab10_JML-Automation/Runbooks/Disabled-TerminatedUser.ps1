param(
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName
)

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Groups

Write-Output "Starting IAM Offboarding Automation..."

Connect-MgGraph -Identity

# Get the user
$user = Get-MgUser -UserId $UserPrincipalName

Write-Output "Disabling user: $UserPrincipalName"

# Disable the user account
Update-MgUser -UserId $UserPrincipalName -AccountEnabled:$false

# Revoke active sessions
Write-Output "Revoking sign-in sessions"
Revoke-MgUserSignInSession -UserId $UserPrincipalName

# Remove all licenses
Write-Output "Removing licenses"

$licenses = Get-MgUserLicenseDetail -UserId $UserPrincipalName

foreach ($license in $licenses) {
    Set-MgUserLicense `
        -UserId $UserPrincipalName `
        -RemoveLicenses @($license.SkuId) `
        -AddLicenses @{}
}

# Remove group memberships
Write-Output "Removing group memberships"

$groups = Get-MgUserMemberOf -UserId $UserPrincipalName

foreach ($group in $groups) {
    Remove-MgGroupMemberByRef `
        -GroupId $group.Id `
        -DirectoryObjectId $user.Id `
        -ErrorAction SilentlyContinue
}

Write-Output "User offboarding completed successfully."
