# Lab 9 — Automated User Offboarding (Azure Automation + Microsoft Graph)

## Business Scenario

The organization has experienced incidents where departed employees retained active accounts for days after their last day because manual offboarding steps were missed or delayed. HR needs a reliable, immediate offboarding process that doesn’t depend on a single administrator being available. As the IAM engineer, you are tasked with building an automated offboarding runbook that executes every critical deprovisioning step the moment HR submits a termination request.

-----

## Objective

Build an Azure Automation runbook that accepts a user identifier, then automatically executes the complete offboarding sequence: disable account, revoke sessions, remove licenses, and remove group memberships — with full logging of every action taken.

-----

## Tools Used

- Azure Automation (Runbook)
- Microsoft Graph PowerShell SDK
- Managed Identity (Azure Automation → Entra ID)
- PowerShell
- Azure Portal

-----

## Architecture

```
HR Termination Request → Azure Automation Runbook → Microsoft Graph API → Entra ID
                                                                        ↓
                                                         Disable Account
                                                         Revoke Sessions
                                                         Remove Licenses
                                                         Remove Group Memberships
                                                         Generate Audit Log Entry
```

-----

## What Was Configured

- Azure Automation Account with System-Assigned Managed Identity
- Managed Identity granted required Microsoft Graph API permissions
- PowerShell runbook implementing full offboarding sequence
- Runbook tested against a test user account
- Output log capturing every action with timestamp and result

-----

## Steps

### 1. Create Azure Automation Account

- Navigated to **Azure Portal > Automation Accounts > Create**
- Enabled **System-Assigned Managed Identity** during creation
- Noted Managed Identity Object ID for permission assignment

### 2. Grant Managed Identity Graph API Permissions

```powershell
# Run locally as Global Admin to grant permissions to the Managed Identity
Connect-MgGraph -Scopes "AppRoleAssignment.ReadWrite.All", "Application.Read.All"

$managedIdentityId = "<automation-account-managed-identity-object-id>"
$graphAppId = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

$graphSP = Get-MgServicePrincipal -Filter "AppId eq '$graphAppId'"

$permissions = @(
    "User.ReadWrite.All",
    "Group.ReadWrite.All",
    "Directory.ReadWrite.All"
)

foreach ($permission in $permissions) {
    $appRole = $graphSP.AppRoles | Where-Object { $_.Value -eq $permission }
    New-MgServicePrincipalAppRoleAssignment `
        -ServicePrincipalId $managedIdentityId `
        -PrincipalId $managedIdentityId `
        -ResourceId $graphSP.Id `
        -AppRoleId $appRole.Id
}
```

### 3. Offboarding Runbook (PowerShell)

```powershell
param (
    [Parameter(Mandatory=$true)]
    [string]$UserUPN
)

# Authenticate using Managed Identity
Connect-MgGraph -Identity

$log = @()
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

try {
    $user = Get-MgUser -Filter "UserPrincipalName eq '$UserUPN'"
    if (-not $user) { throw "User not found: $UserUPN" }
    
    $userId = $user.Id

    # Step 1: Disable account
    Update-MgUser -UserId $userId -AccountEnabled $false
    $log += "[$timestamp] DISABLED: Account disabled for $UserUPN"

    # Step 2: Revoke all active sessions
    Revoke-MgUserSignInSession -UserId $userId
    $log += "[$timestamp] REVOKED: All sessions revoked for $UserUPN"

    # Step 3: Remove all licenses
    $licenses = Get-MgUserLicenseDetail -UserId $userId
    if ($licenses) {
        $skuIds = $licenses | Select-Object -ExpandProperty SkuId
        Set-MgUserLicense -UserId $userId -AddLicenses @() -RemoveLicenses $skuIds
        $log += "[$timestamp] LICENSES: Removed $($skuIds.Count) license(s) from $UserUPN"
    }

    # Step 4: Remove all group memberships
    $groups = Get-MgUserMemberOf -UserId $userId | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.group' }
    foreach ($group in $groups) {
        try {
            Remove-MgGroupMemberByRef -GroupId $group.Id -DirectoryObjectId $userId
            $log += "[$timestamp] GROUP REMOVED: $($group.DisplayName)"
        } catch {
            $log += "[$timestamp] GROUP ERROR: Could not remove from $($group.DisplayName) - $_"
        }
    }

    $log += "[$timestamp] COMPLETE: Offboarding completed successfully for $UserUPN"

} catch {
    $log += "[$timestamp] ERROR: $_ for $UserUPN"
}

# Output full log
$log | ForEach-Object { Write-Output $_ }
```

### 4. Test Runbook

- Navigated to **Automation Account > Runbooks > Offboarding-Runbook > Test Pane**
- Entered test user UPN
- Executed and reviewed output log
- Verified in Entra ID:
  - Account disabled ✓
  - Sessions revoked (Sign-in attempt failed) ✓
  - Licenses removed ✓
  - Group memberships cleared ✓

-----

## Outcome / Verification

- Runbook executed in under 60 seconds for complete offboarding sequence
- Output log generated with timestamped confirmation of each step
- All offboarding actions visible in **Entra ID > Audit Logs**
- Account confirmed inaccessible — sign-in blocked immediately post-execution

-----

## SC-300 Exam Alignment

|Domain                                    |Topic                                  |
|------------------------------------------|---------------------------------------|
|Govern access using Microsoft Entra ID    |Implement and manage identity lifecycle|
|Implement identities in Microsoft Entra ID|Manage user lifecycle events           |
|Plan and implement workload identities    |Configure Managed Identities           |

-----

## Key Concepts Demonstrated

- Managed Identity as a secure, credential-free authentication method for automation
- Why session revocation is a separate and critical step from account disabling
- Microsoft Graph as the API backbone for identity automation
- Structured logging within runbooks for compliance and auditability
- This runbook is the offboarding component of the full JML automation system built in Lab 10
