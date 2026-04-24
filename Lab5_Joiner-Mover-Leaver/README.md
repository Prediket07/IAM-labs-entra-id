# Lab 5 — Joiner-Mover-Leaver (JML) Identity Lifecycle Management

## Business Scenario

HR has submitted three identity requests simultaneously: a new employee starting Monday (Joiner), an existing employee transferring from Sales to Finance (Mover), and an employee who resigned effective immediately (Leaver). As the IAM engineer, you must process all three requests in a way that is accurate, timely, and auditable — ensuring the new hire has access on day one, the transfer is clean with no residual Sales permissions, and the departed employee is fully locked out before end of business.

-----

## Objective

Execute the full Joiner-Mover-Leaver identity lifecycle manually in Microsoft Entra ID, documenting each step as it would occur in a real enterprise environment, and establishing the process baseline that Lab 10 will automate.

-----

## Tools Used

- Microsoft Entra ID Portal
- Microsoft 365 Admin Center
- PowerShell + Microsoft Graph PowerShell SDK

-----

## What Was Configured

**Joiner:** New user provisioned with correct attributes, group memberships, license, and manager assignment

**Mover:** Department updated, removed from Sales groups, added to Finance groups, application access updated to reflect new role

**Leaver:** Account disabled, active sessions revoked, licenses removed, group memberships cleared, manager notified via documented process

-----

## Steps

### JOINER — New Employee Onboarding

#### 1. Provision User Account

```powershell
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"

$passwordProfile = @{
    ForceChangePasswordNextSignIn = $true
    Password = "TempP@ssw0rd!"
}

$newUser = @{
    DisplayName       = "Alex Johnson"
    GivenName         = "Alex"
    Surname           = "Johnson"
    UserPrincipalName = "alex.johnson@domain.onmicrosoft.com"
    MailNickname      = "alex.johnson"
    Department        = "Marketing"
    JobTitle          = "Marketing Coordinator"
    UsageLocation     = "US"
    AccountEnabled    = $true
    PasswordProfile   = $passwordProfile
}

New-MgUser -BodyParameter $newUser
```

#### 2. Assign License and Groups

```powershell
# Assign M365 license
Set-MgUserLicense -UserId $newUser.Id `
  -AddLicenses @{SkuId = "<license-sku-id>"} `
  -RemoveLicenses @()

# Add to department group
New-MgGroupMember -GroupId "<marketing-group-id>" -DirectoryObjectId $newUser.Id
```

-----

### MOVER — Department Transfer

#### 1. Update User Attributes

```powershell
Update-MgUser -UserId "<user-id>" `
  -Department "Finance" `
  -JobTitle "Financial Analyst"
```

#### 2. Remove Old Group Memberships

```powershell
Remove-MgGroupMemberByRef -GroupId "<sales-group-id>" -DirectoryObjectId "<user-id>"
```

#### 3. Add to New Groups

```powershell
New-MgGroupMember -GroupId "<finance-group-id>" -DirectoryObjectId "<user-id>"
```

-----

### LEAVER — Employee Offboarding

#### 1. Disable Account and Revoke Sessions

```powershell
# Disable account
Update-MgUser -UserId "<user-id>" -AccountEnabled $false

# Revoke all active sessions
Revoke-MgUserSignInSession -UserId "<user-id>"
```

#### 2. Remove Licenses and Group Memberships

```powershell
# Remove license
Set-MgUserLicense -UserId "<user-id>" `
  -AddLicenses @() `
  -RemoveLicenses @("<license-sku-id>")

# Get and remove all group memberships
$groups = Get-MgUserMemberOf -UserId "<user-id>"
foreach ($group in $groups) {
    Remove-MgGroupMemberByRef -GroupId $group.Id -DirectoryObjectId "<user-id>"
}
```

#### 3. Document and Retain Account (30-day hold)

- Account disabled but not deleted — retained for audit and data recovery purposes
- Manager notified per documented offboarding procedure
- Scheduled deletion set for 30 days post-departure

-----

## Outcome / Verification

- **Joiner:** New user signing in successfully, correct group memberships, license active
- **Mover:** No residual Sales group access, Finance group confirmed, attributes updated
- **Leaver:** Sign-in blocked, sessions revoked, confirmed via Sign-in Logs showing failure
- All three events visible in **Entra ID > Audit Logs** with full action trail

-----

## SC-300 Exam Alignment

|Domain                                    |Topic                                        |
|------------------------------------------|---------------------------------------------|
|Implement identities in Microsoft Entra ID|Create, configure, and manage user identities|
|Implement identities in Microsoft Entra ID|Manage user lifecycle                        |
|Govern access using Microsoft Entra ID    |Implement and manage identity governance     |

-----

## Key Concepts Demonstrated

- Full JML lifecycle as a structured, auditable process
- Importance of session revocation (not just account disable) for Leavers
- 30-day account retention before deletion — enterprise standard practice
- This lab is the manual baseline that Lab 10 fully automates via Azure Automation and Microsoft Graph
