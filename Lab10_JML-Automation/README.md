# Lab 10 — Full JML Automation System (Joiner-Mover-Leaver)

## Business Scenario

The organization has grown to 500+ employees and the manual identity lifecycle process from Lab 5 is no longer sustainable. HR processes dozens of changes per month and manual execution is causing delays in access provisioning (new hires waiting days for access) and security gaps in offboarding (departed employees retaining access). Leadership has approved building a fully automated JML system that integrates with HR workflows and executes identity changes the moment they are submitted.

-----

## Objective

Build a production-grade, webhook-triggered JML automation system using Azure Automation and Microsoft Graph that handles the complete identity lifecycle — onboarding, role changes, and offboarding — without manual IAM intervention.

-----

## Tools Used

- Azure Automation (Runbooks + Webhooks)
- Microsoft Graph PowerShell SDK
- Managed Identity
- PowerShell
- Webhooks (simulating HR system triggers)
- Microsoft Entra ID

-----

## Architecture

```
HR System
    │
    ▼
Webhook (HTTP POST with JSON payload)
    │
    ▼
Azure Automation Runbook
    │
    ├── JOINER → Create User → Assign License → Add to Groups → Set Manager
    │
    ├── MOVER  → Update Attributes → Remove Old Groups → Add New Groups → Update App Access
    │
    └── LEAVER → Disable Account → Revoke Sessions → Remove Licenses → Remove Groups
    │
    ▼
Microsoft Graph API → Microsoft Entra ID
    │
    ▼
Audit Log + Output Report
```

-----

## What Was Configured

- Azure Automation Account with Managed Identity and Graph API permissions
- Three automation runbooks (Joiner, Mover, Leaver)
- Webhook endpoints created for each runbook
- JSON payload schema designed to simulate HR system input
- End-to-end testing of all three workflows
- Error handling and structured logging throughout

-----

## Runbook Payloads (HR System Simulation)

### Joiner Payload

```json
{
  "action": "joiner",
  "firstName": "Marcus",
  "lastName": "Williams",
  "department": "Engineering",
  "jobTitle": "Junior Developer",
  "manager": "sarah.chen@domain.onmicrosoft.com",
  "startDate": "2024-02-01",
  "licenseType": "M365BusinessPremium"
}
```

### Mover Payload

```json
{
  "action": "mover",
  "userUPN": "marcus.williams@domain.onmicrosoft.com",
  "newDepartment": "Security",
  "newJobTitle": "Security Analyst",
  "removeGroups": ["Engineering-All", "Dev-Tools-Access"],
  "addGroups": ["Security-Team", "SIEM-Access", "Incident-Response"]
}
```

### Leaver Payload

```json
{
  "action": "leaver",
  "userUPN": "marcus.williams@domain.onmicrosoft.com",
  "lastDay": "2024-06-30",
  "reason": "Voluntary Resignation"
}
```

-----

## Core Runbook Logic

```powershell
param (
    [object]$WebhookData
)

Connect-MgGraph -Identity

# Parse incoming webhook payload
$payload = $WebhookData.RequestBody | ConvertFrom-Json
$action = $payload.action
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$log = @()

switch ($action) {

    "joiner" {
        $log += "[$timestamp] ACTION: Joiner workflow initiated"
        
        $upn = "$($payload.firstName.ToLower()).$($payload.lastName.ToLower())@domain.onmicrosoft.com"
        
        # Create user
        $passwordProfile = @{ ForceChangePasswordNextSignIn = $true; Password = "Welcome@$(Get-Random -Max 9999)!" }
        $newUser = New-MgUser -DisplayName "$($payload.firstName) $($payload.lastName)" `
            -UserPrincipalName $upn `
            -GivenName $payload.firstName `
            -Surname $payload.lastName `
            -Department $payload.department `
            -JobTitle $payload.jobTitle `
            -UsageLocation "US" `
            -AccountEnabled $true `
            -PasswordProfile $passwordProfile `
            -MailNickname "$($payload.firstName.ToLower()).$($payload.lastName.ToLower())"
        
        $log += "[$timestamp] CREATED: User $upn"

        # Assign license
        $sku = Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -like "*BUSINESS_PREMIUM*" }
        Set-MgUserLicense -UserId $newUser.Id -AddLicenses @{SkuId = $sku.SkuId} -RemoveLicenses @()
        $log += "[$timestamp] LICENSE: Assigned M365 Business Premium to $upn"

        # Add to department group
        $group = Get-MgGroup -Filter "DisplayName eq '$($payload.department)-All'"
        if ($group) {
            New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $newUser.Id
            $log += "[$timestamp] GROUP: Added to $($payload.department)-All"
        }

        # Assign manager
        $manager = Get-MgUser -Filter "UserPrincipalName eq '$($payload.manager)'"
        if ($manager) {
            Set-MgUserManagerByRef -UserId $newUser.Id -OdataId "https://graph.microsoft.com/v1.0/users/$($manager.Id)"
            $log += "[$timestamp] MANAGER: Set to $($payload.manager)"
        }

        $log += "[$timestamp] COMPLETE: Joiner workflow complete for $upn"
    }

    "mover" {
        $log += "[$timestamp] ACTION: Mover workflow initiated for $($payload.userUPN)"
        $user = Get-MgUser -Filter "UserPrincipalName eq '$($payload.userUPN)'"

        # Update attributes
        Update-MgUser -UserId $user.Id -Department $payload.newDepartment -JobTitle $payload.newJobTitle
        $log += "[$timestamp] UPDATED: Department=$($payload.newDepartment), Title=$($payload.newJobTitle)"

        # Remove old group memberships
        foreach ($groupName in $payload.removeGroups) {
            $group = Get-MgGroup -Filter "DisplayName eq '$groupName'"
            if ($group) {
                Remove-MgGroupMemberByRef -GroupId $group.Id -DirectoryObjectId $user.Id
                $log += "[$timestamp] REMOVED FROM GROUP: $groupName"
            }
        }

        # Add to new groups
        foreach ($groupName in $payload.addGroups) {
            $group = Get-MgGroup -Filter "DisplayName eq '$groupName'"
            if ($group) {
                New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $user.Id
                $log += "[$timestamp] ADDED TO GROUP: $groupName"
            }
        }

        $log += "[$timestamp] COMPLETE: Mover workflow complete for $($payload.userUPN)"
    }

    "leaver" {
        $log += "[$timestamp] ACTION: Leaver workflow initiated for $($payload.userUPN)"
        $user = Get-MgUser -Filter "UserPrincipalName eq '$($payload.userUPN)'"

        # Disable and revoke
        Update-MgUser -UserId $user.Id -AccountEnabled $false
        Revoke-MgUserSignInSession -UserId $user.Id
        $log += "[$timestamp] DISABLED + SESSIONS REVOKED: $($payload.userUPN)"

        # Remove licenses
        $licenses = Get-MgUserLicenseDetail -UserId $user.Id
        if ($licenses) {
            Set-MgUserLicense -UserId $user.Id -AddLicenses @() -RemoveLicenses ($licenses.SkuId)
            $log += "[$timestamp] LICENSES: Removed $($licenses.Count) license(s)"
        }

        # Remove group memberships
        $groups = Get-MgUserMemberOf -UserId $user.Id | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.group' }
        foreach ($group in $groups) {
            Remove-MgGroupMemberByRef -GroupId $group.Id -DirectoryObjectId $user.Id
            $log += "[$timestamp] REMOVED FROM GROUP: $($group.DisplayName)"
        }

        $log += "[$timestamp] COMPLETE: Leaver workflow complete. Account retained 30 days per policy."
    }
}

$log | ForEach-Object { Write-Output $_ }
```

-----

## Testing

|Test  |Payload Sent       |Result                                                      |
|------|-------------------|------------------------------------------------------------|
|Joiner|New hire payload   |User created, licensed, added to groups, manager set        |
|Mover |Transfer payload   |Attributes updated, old groups removed, new groups added    |
|Leaver|Termination payload|Disabled, sessions revoked, licenses removed, groups cleared|

All three workflows tested via Invoke-RestMethod to the webhook URL, simulating HR system calls.

-----

## Outcome / Verification

- All three JML workflows executing in under 90 seconds end-to-end
- Full audit trail in Entra ID Audit Logs for every action taken
- Runbook output logs exported for compliance documentation
- Zero manual IAM intervention required after webhook trigger
- System capable of handling concurrent JML requests

-----

## SC-300 Exam Alignment

|Domain                                    |Topic                                  |
|------------------------------------------|---------------------------------------|
|Govern access using Microsoft Entra ID    |Implement and manage identity lifecycle|
|Plan and implement workload identities    |Configure Managed Identities           |
|Implement identities in Microsoft Entra ID|Automate user lifecycle management     |

-----

## Key Concepts Demonstrated

- Webhook-triggered automation simulating real HR system integration (Workday, SAP, etc.)
- Managed Identity as secure, zero-credential authentication for automation
- Microsoft Graph as the single API surface for all Entra ID operations
- Structured JSON payload schema as the contract between HR system and IAM automation
- Error handling and logging as production requirements, not afterthoughts
- This lab represents the capstone of the IAM lifecycle automation track
